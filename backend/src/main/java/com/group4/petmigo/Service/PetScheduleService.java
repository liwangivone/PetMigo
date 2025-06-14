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

    /**
     * Membuat jadwal baru untuk hewan peliharaan tertentu.
     */
    public PetSchedule createSchedule(Long petId, PetSchedule schedule) {
        Pet pet = petRepository.findById(petId)
                .orElseThrow(() -> new IllegalArgumentException("Pet not found with id " + petId));

        schedule.setPet(pet);
        return scheduleRepository.save(schedule);
    }

    /**
     * Memperbarui jadwal berdasarkan ID.
     * Hanya field tertentu yang diizinkan untuk diubah.
     */
    public PetSchedule updateSchedule(Long scheduleId, PetSchedule updatedSchedule) {
        PetSchedule existing = scheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new IllegalArgumentException("Schedule not found with id " + scheduleId));

        existing.setDescription(updatedSchedule.getDescription());
        existing.setDate(updatedSchedule.getDate());
        existing.setExpense(updatedSchedule.getExpense());
        existing.setCategory(updatedSchedule.getCategory());
        // Tidak mengubah relasi pet

        return scheduleRepository.save(existing);
    }

    /**
     * Menghapus jadwal berdasarkan ID.
     */
    public void deleteSchedule(Long id) {
        if (!scheduleRepository.existsById(id)) {
            throw new IllegalArgumentException("Schedule not found with id " + id);
        }
        scheduleRepository.deleteById(id);
    }

    /**
     * Mengambil semua pet milik user beserta jadwalnya dan total pengeluaran.
     */
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
}
