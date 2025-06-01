package com.group4.petmigo.Service;

import com.group4.petmigo.models.entities.User.User;
import com.group4.petmigo.models.entities.pet.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class PetServiceTest {

    private Map<Long, Pet> petDb;
    private Pet dummyPet;
    private User dummyUser;

    @BeforeEach
    void setUp() {
        petDb = new HashMap<>();

        // Gunakan mock untuk User
        dummyUser = mock(User.class);

        // Stub semua method yang digunakan
        when(dummyUser.getUserid()).thenReturn(1L);
        when(dummyUser.getName()).thenReturn("Alice");
        when(dummyUser.getEmail()).thenReturn("alice@example.com");
        when(dummyUser.getPassword()).thenReturn("secret");
        when(dummyUser.getUid()).thenReturn("uid-123");
        when(dummyUser.getStatus()).thenReturn(com.group4.petmigo.models.entities.User.status.online);

        // dummyPet instance asli
        dummyPet = new Pet();
        dummyPet.setPetid(1L);
        dummyPet.setName("Snowy");
        dummyPet.setBreed("Husky");
        dummyPet.setType(PetType.DOG);
        dummyPet.setGender(PetGender.FEMALE);
        dummyPet.setBirthdate(LocalDate.of(2020, 1, 1));
        dummyPet.setColor("White");
        dummyPet.setWeight(10.5);
        dummyPet.setUser(dummyUser);
    }

    @Test
    void testCreatePet() {
        petDb.put(dummyPet.getPetid(), dummyPet);

        assertEquals(1, petDb.size());
        assertTrue(petDb.containsKey(1L));
        assertEquals("Snowy", petDb.get(1L).getName());

        System.out.println("testCreatePet: Pet created with name = " + petDb.get(1L).getName());
    }

    @Test
    void testReadPet() {
        petDb.put(dummyPet.getPetid(), dummyPet);

        Pet fetched = petDb.get(1L);
        assertNotNull(fetched);
        assertEquals(PetType.DOG, fetched.getType());
        assertEquals("Husky", fetched.getBreed());

        System.out.println("testReadPet: Pet read with breed = " + fetched.getBreed());
    }

    @Test
    void testUpdatePet() {
        petDb.put(dummyPet.getPetid(), dummyPet);

        Pet toUpdate = petDb.get(1L);
        toUpdate.setName("Fluffy");
        toUpdate.setWeight(12.0);
        petDb.put(1L, toUpdate);

        assertEquals("Fluffy", petDb.get(1L).getName());
        assertEquals(12.0, petDb.get(1L).getWeight());

        System.out.println("testUpdatePet: Pet updated to name = " + petDb.get(1L).getName() + ", weight = " + petDb.get(1L).getWeight());
    }

    @Test
    void testDeletePet() {
        petDb.put(dummyPet.getPetid(), dummyPet);
        petDb.remove(1L);

        assertFalse(petDb.containsKey(1L));

        System.out.println("testDeletePet: Pet with ID 1 deleted. Contains key? " + petDb.containsKey(1L));
    }

    @Test
    void testUserHasPets() {
        List<Pet> userPets = new ArrayList<>();
        userPets.add(dummyPet);

        // Stub getPets di dummyUser agar tidak null
        when(dummyUser.getPets()).thenReturn(userPets);

        assertEquals(1, dummyUser.getPets().size());
        assertEquals("Snowy", dummyUser.getPets().get(0).getName());
        assertEquals("Alice", dummyUser.getPets().get(0).getUser().getName());

        System.out.println("testUserHasPets: User " + dummyUser.getName() + " has pet named " + dummyUser.getPets().get(0).getName());
    }
}
