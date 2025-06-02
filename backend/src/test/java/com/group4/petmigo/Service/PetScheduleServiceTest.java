package com.group4.petmigo.Service;

import com.group4.petmigo.models.entities.pet.PetSchedule;
import com.group4.petmigo.models.entities.pet.PetScheduleCategory;
import com.group4.petmigo.models.entities.pet.Pet;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class PetScheduleServiceTest {

    private Map<Long, PetSchedule> scheduleDb;
    private Pet dummyPet;

    @BeforeEach
    void setUp() {
        scheduleDb = new HashMap<>();

        // Mock Pet
        dummyPet = mock(Pet.class);
        when(dummyPet.getPetid()).thenReturn(1L);
        when(dummyPet.getName()).thenReturn("Snowy");
    }

    @Test
    void testCreateSchedules() {
        PetSchedule s1 = createPetSchedule(1L, PetScheduleCategory.Vaccination, 100, "Rabies vaccine", LocalDate.of(2024,6,1));
        PetSchedule s2 = createPetSchedule(2L, PetScheduleCategory.Food, 200, "Food", LocalDate.of(2024,6,15));
        PetSchedule s3 = createPetSchedule(3L, PetScheduleCategory.Grooming, 300, "Full grooming", LocalDate.of(2024,7,1));

        scheduleDb.put(s1.getSchedule_id(), s1);
        scheduleDb.put(s2.getSchedule_id(), s2);
        scheduleDb.put(s3.getSchedule_id(), s3);

        assertEquals(3, scheduleDb.size());

        System.out.println("testCreateSchedules: Created 3 schedules.");
    }

    @Test
    void testReadSchedule() {
        PetSchedule s1 = createPetSchedule(1L, PetScheduleCategory.Vaccination, 100, "Rabies vaccine", LocalDate.of(2024,6,1));
        scheduleDb.put(s1.getSchedule_id(), s1);

        PetSchedule fetched = scheduleDb.get(1L);

        assertNotNull(fetched);
        assertEquals(100, fetched.getExpense());

        System.out.println("testReadSchedule: Read schedule ID 1 with expense = " + fetched.getExpense());
    }

    @Test
    void testUpdateSchedule() {
        PetSchedule s1 = createPetSchedule(1L, PetScheduleCategory.Vaccination, 100, "Rabies vaccine", LocalDate.of(2024,6,1));
        scheduleDb.put(s1.getSchedule_id(), s1);

        // Update data
        PetSchedule toUpdate = scheduleDb.get(1L);
        toUpdate.setExpense(150);
        toUpdate.setDescription("Rabies + Distemper vaccine");
        scheduleDb.put(1L, toUpdate);

        assertEquals(150, scheduleDb.get(1L).getExpense());
        assertEquals("Rabies + Distemper vaccine", scheduleDb.get(1L).getDescription());

        System.out.println("testUpdateSchedule: Updated schedule ID 1 with new expense = " + scheduleDb.get(1L).getExpense());
    }

    @Test
    void testDeleteSchedule() {
        PetSchedule s1 = createPetSchedule(1L, PetScheduleCategory.Vaccination, 100, "Rabies vaccine", LocalDate.of(2024,6,1));
        scheduleDb.put(s1.getSchedule_id(), s1);

        scheduleDb.remove(1L);

        assertFalse(scheduleDb.containsKey(1L));

        System.out.println("testDeleteSchedule: Deleted schedule ID 1. Exists? " + scheduleDb.containsKey(1L));
    }

    @Test
    void testMultipleSchedulesAndTotalExpense() {
        PetSchedule s1 = createPetSchedule(1L, PetScheduleCategory.Vaccination, 100, "Rabies vaccine", LocalDate.of(2024,6,1));
        PetSchedule s2 = createPetSchedule(2L, PetScheduleCategory.Food, 300, "Food", LocalDate.of(2024,6,15));
        PetSchedule s3 = createPetSchedule(3L, PetScheduleCategory.Grooming, 300, "Full grooming", LocalDate.of(2024,7,1));

        scheduleDb.put(s1.getSchedule_id(), s1);
        scheduleDb.put(s2.getSchedule_id(), s2);
        scheduleDb.put(s3.getSchedule_id(), s3);

        assertEquals(3, scheduleDb.size());

        int totalExpense = scheduleDb.values()
            .stream()
            .mapToInt(PetSchedule::getExpense)
            .sum();

        System.out.println("testMultipleSchedulesAndTotalExpense: Total expense = " + totalExpense);

        assertEquals(700, totalExpense);

        // Print detail tiap schedule
        scheduleDb.values().forEach(s -> System.out.println(
                "Schedule ID: " + s.getSchedule_id() +
                ", Category: " + s.getCategory() +
                ", Expense: " + s.getExpense() +
                ", Description: " + s.getDescription() +
                ", Pet Name: " + s.getPet().getName()
        ));
    }

    // Helper method untuk buat PetSchedule dummy
    private PetSchedule createPetSchedule(Long id, PetScheduleCategory category, int expense, String desc, LocalDate date) {
        PetSchedule schedule = new PetSchedule();
        schedule.setSchedule_id(id);
        schedule.setCategory(category);
        schedule.setExpense(expense);
        schedule.setDescription(desc);
        schedule.setDate(date);
        schedule.setPet(dummyPet);
        return schedule;
    }
}
