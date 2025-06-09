package com.group4.petmigo.Service;

import com.group4.petmigo.models.entities.pet.Pet;
import com.group4.petmigo.models.entities.pet.PetSchedule;
import com.group4.petmigo.models.entities.pet.PetScheduleCategory;
import com.group4.petmigo.Repository.PetRepository;
import com.group4.petmigo.Repository.PetScheduleRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;

import java.time.LocalDate;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

public class PetScheduleServiceTest {

    @Mock
    private PetScheduleRepository scheduleRepository;

    @Mock
    private PetRepository petRepository;

    @InjectMocks
    private PetScheduleService petScheduleService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testCreateSchedule_Success() {
        Long petId = 1L;

        Pet pet = new Pet();
        pet.setPetid(petId);

        PetSchedule inputSchedule = new PetSchedule();
        inputSchedule.setDescription("Food");
        inputSchedule.setDate(LocalDate.of(2025, 6, 8));
        inputSchedule.setExpense(50000);
        inputSchedule.setCategory(PetScheduleCategory.Food);

        // Mock findById petRepository
        when(petRepository.findById(petId)).thenReturn(Optional.of(pet));

        // Mock save scheduleRepository, mengembalikan objek schedule dengan pet sudah di-set
        when(scheduleRepository.save(any(PetSchedule.class))).thenAnswer(invocation -> invocation.getArgument(0));

        PetSchedule result = petScheduleService.createSchedule(petId, inputSchedule);

        assertNotNull(result);
        assertEquals("Food", result.getDescription());
        assertEquals(pet, result.getPet());

        System.out.println("Create Schedule Result: " + result.getDescription() + ", Pet ID: " + result.getPet().getPetid());
    }

    @Test
    public void testUpdateSchedule_Success() {
        Long scheduleId = 1L;

        PetSchedule existingSchedule = new PetSchedule();
        existingSchedule.setDescription("Old Description");
        existingSchedule.setDate(LocalDate.of(2025, 1, 1));
        existingSchedule.setExpense(20000);
        existingSchedule.setCategory(PetScheduleCategory.Vaccination);

        PetSchedule updateData = new PetSchedule();
        updateData.setDescription("New Description");
        updateData.setDate(LocalDate.of(2025, 6, 8));
        updateData.setExpense(30000);
        updateData.setCategory(PetScheduleCategory.Others);

        when(scheduleRepository.findById(scheduleId)).thenReturn(Optional.of(existingSchedule));
        when(scheduleRepository.save(any(PetSchedule.class))).thenAnswer(invocation -> invocation.getArgument(0));

        PetSchedule updated = petScheduleService.updateSchedule(scheduleId, updateData);

        assertEquals("New Description", updated.getDescription());
        assertEquals(LocalDate.of(2025, 6, 8), updated.getDate());
        assertEquals(30000, updated.getExpense());

        // Bandingkan enum, bukan string
        assertEquals(PetScheduleCategory.Others, updated.getCategory());

        System.out.println("Update Schedule Result: " + updated.getDescription() + ", Category: " + updated.getCategory());
    }

    @Test
    public void testDeleteSchedule_VerifyDeleteCalled() {
        Long scheduleId = 1L;

        doNothing().when(scheduleRepository).deleteById(scheduleId);

        petScheduleService.deleteSchedule(scheduleId);

        verify(scheduleRepository, times(1)).deleteById(scheduleId);

        System.out.println("Delete schedule called for ID: " + scheduleId);
    }

    @Test
    public void testGetPetsWithSchedulesAndTotalExpenseByUserId() {
        Long userId = 10L;

        // Setup pets and schedules
        PetSchedule schedule1 = new PetSchedule();
        schedule1.setExpense(10000);

        PetSchedule schedule2 = new PetSchedule();
        schedule2.setExpense(20000);

        Pet pet1 = new Pet();
        pet1.setPetid(1L);
        pet1.setPetSchedule(List.of(schedule1));

        Pet pet2 = new Pet();
        pet2.setPetid(2L);
        pet2.setPetSchedule(List.of(schedule2));

        List<Pet> pets = List.of(pet1, pet2);

        when(petRepository.findPetsWithSchedulesByUserId(userId)).thenReturn(pets);

        Map<String, Object> result = petScheduleService.getPetsWithSchedulesAndTotalExpenseByUserId(userId);

        assertNotNull(result);
        assertTrue(result.containsKey("pets"));
        assertTrue(result.containsKey("totalExpense"));

        int totalExpense = (int) result.get("totalExpense");
        assertEquals(30000, totalExpense);

        System.out.println("Total Expense for user " + userId + ": " + totalExpense);
        System.out.println("Number of pets returned: " + ((List<?>) result.get("pets")).size());
    }
}
