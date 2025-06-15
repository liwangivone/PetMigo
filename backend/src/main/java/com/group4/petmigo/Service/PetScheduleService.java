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

    public PetScheduleService(PetScheduleRepository scheduleRepository,
                              PetRepository petRepository) {
        this.scheduleRepository = scheduleRepository;
        this.petRepository = petRepository;
    }

    /** Membuat jadwal baru untuk hewan peliharaan tertentu. */
    public PetSchedule createSchedule(Long petId, PetSchedule schedule) {
        Pet pet = petRepository.findById(petId)
                .orElseThrow(() ->
                        new IllegalArgumentException("Pet not found with id " + petId));

        schedule.setPet(pet);
        return scheduleRepository.save(schedule);
    }

    /** Memperbarui jadwal berdasarkan ID. */
    public PetSchedule updateSchedule(Long scheduleId, PetSchedule updatedSchedule) {
        PetSchedule existing = scheduleRepository.findById(scheduleId)
                .orElseThrow(() ->
                        new IllegalArgumentException("Schedule not found with id " + scheduleId));

        existing.setDescription(updatedSchedule.getDescription());
        existing.setDate(updatedSchedule.getDate());
        existing.setExpense(updatedSchedule.getExpense());
        existing.setCategory(updatedSchedule.getCategory());
        // hubungan pet tidak diubah
        return scheduleRepository.save(existing);
    }

    /** Menghapus jadwal berdasarkan ID. */
    public void deleteSchedule(Long scheduleId) {
        if (!scheduleRepository.existsById(scheduleId)) {
            throw new IllegalArgumentException("Schedule not found with id " + scheduleId);
        }
        scheduleRepository.deleteById(scheduleId);
    }

    /** Mengambil semua pet milik user beserta jadwal & total pengeluaran. */
    public Map<String, Object> getPetsWithSchedulesAndTotalExpenseByUserId(Long userId) {
        List<Pet> pets = petRepository.findPetsWithSchedulesByUserId(userId);

        int totalExpense = pets.stream()
                .flatMap(pet -> pet.getPetSchedule().stream())
                .mapToInt(PetSchedule::getExpense)
                .sum();

        Map<String, Object> result = new HashMap<>();
        result.put("pets", pets);
        result.put("totalExpense", totalExpense);
        return result;
    }

    /** 🔍 Baru: ambil seluruh jadwal milik satu pet. */
    public List<PetSchedule> getSchedulesByPetId(Long petId) {
        Pet pet = petRepository.findById(petId)
                .orElseThrow(() ->
                        new IllegalArgumentException("Pet not found with id " + petId));
        return scheduleRepository.findByPet(pet);
    }
}
