package com.group4.petmigo.Service;

import com.group4.petmigo.models.entities.pet.Pet;
import com.group4.petmigo.models.entities.pet.PetSchedule;
import com.group4.petmigo.Repository.PetRepository;
import com.group4.petmigo.Repository.PetScheduleRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PetScheduleService {

    private final PetScheduleRepository scheduleRepository;
    private final PetRepository petRepository;

    public PetScheduleService(PetScheduleRepository scheduleRepository, PetRepository petRepository) {
        this.scheduleRepository = scheduleRepository;
        this.petRepository = petRepository;
    }

    public PetSchedule createSchedule(Long petId, PetSchedule schedule) {
        Pet pet = petRepository.findById(petId)
                .orElseThrow(() -> new RuntimeException("Pet not found with id " + petId));

        schedule.setPet(pet);
        return scheduleRepository.save(schedule);
    }

    public Optional<PetSchedule> getScheduleById(Long id) {
        return scheduleRepository.findById(id);
    }

    public PetSchedule updateSchedule(Long schedule_id, PetSchedule schedule) {
        PetSchedule existing = scheduleRepository.findById(schedule_id)
            .orElseThrow(() -> new RuntimeException("Schedule not found with id " + schedule_id));

        // Update field yang diizinkan saja
        existing.setDescription(schedule.getDescription());
        existing.setDate(schedule.getDate());
        existing.setExpense(schedule.getExpense());
        // Tambahkan field lain yang perlu diupdate jika ada

        // Jangan ubah existing.setPet() supaya relasi ke pet tetap aman

        return scheduleRepository.save(existing);
    }

    public void deleteSchedule(Long id) {
        scheduleRepository.deleteById(id);
    }

    public List<PetSchedule> getAllSchedules() {
        return scheduleRepository.findAll();
    }

    public int getTotalExpenseByPetId(Long petid) {
        // ambil semua schedule yang punya pet dengan id petId
        List<PetSchedule> schedules = scheduleRepository.findByPet_petid(petid);
        
        return schedules.stream()
                .mapToInt(PetSchedule::getExpense)
                .sum();
    }
}
