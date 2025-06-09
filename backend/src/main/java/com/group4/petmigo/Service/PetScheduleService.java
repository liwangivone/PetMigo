package com.group4.petmigo.Service;

import com.group4.petmigo.models.entities.pet.Pet;
import com.group4.petmigo.models.entities.pet.PetSchedule;
import com.group4.petmigo.Repository.PetRepository;
import com.group4.petmigo.Repository.PetScheduleRepository;
import org.springframework.stereotype.Service;

import java.util.*;

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

    public PetSchedule updateSchedule(Long schedule_id, PetSchedule schedule) {
        PetSchedule existing = scheduleRepository.findById(schedule_id)
                .orElseThrow(() -> new RuntimeException("Schedule not found with id " + schedule_id));

        // Update field yang diizinkan saja
        existing.setDescription(schedule.getDescription());
        existing.setDate(schedule.getDate());
        existing.setExpense(schedule.getExpense());
        existing.setCategory(schedule.getCategory()); // tambahkan ini agar category bisa berubah
        // Jangan ubah relasi pet

        return scheduleRepository.save(existing);
    }

    public void deleteSchedule(Long id) {
        scheduleRepository.deleteById(id);
    }

    // Ambil semua pets beserta schedules dari userId, dan total expenses-nya
    public Map<String, Object> getPetsWithSchedulesAndTotalExpenseByUserId(Long userId) {
        List<Pet> pets = petRepository.findPetsWithSchedulesByUserId(userId);

        int totalExpense = pets.stream()
                .flatMap(pet -> pet.getPetSchedule().stream())
                .mapToInt(schedule -> schedule.getExpense())
                .sum();

        Map<String, Object> result = new HashMap<>();
        result.put("pets", pets);
        result.put("totalExpense", totalExpense);

        return result;
    }

}
