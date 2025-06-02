
package com.group4.petmigo.Service;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

import org.junit.jupiter.api.Test;

import com.group4.petmigo.models.entities.User.User;
import com.group4.petmigo.models.entities.User.status;
import com.group4.petmigo.models.entities.pet.Pet;
import com.group4.petmigo.models.entities.pet.PetGender;
import com.group4.petmigo.models.entities.pet.PetType;

public class UserProfileTest {

    @Test
    void setUp() {
        // === ARRANGE ===
        // Mock User
        User mockUser = mock(User.class);
        when(mockUser.getUserid()).thenReturn(1L);
        when(mockUser.getName()).thenReturn("Jane Doe");
        when(mockUser.getEmail()).thenReturn("jane.doe@example.com");
        when(mockUser.getPassword()).thenReturn("hashedpassword123");
        when(mockUser.getPhonenumber()).thenReturn("08123456789");
        when(mockUser.getStatus()).thenReturn(status.online);
        when(mockUser.getUid()).thenReturn("UID-001");
        when(mockUser.getCreatedAt()).thenReturn(LocalDateTime.now().minusYears(1));
        when(mockUser.getUpdateAt()).thenReturn(LocalDateTime.now());

        // Mock Pet 1
        Pet mockPet1 = mock(Pet.class);
        when(mockPet1.getPetid()).thenReturn(1001L);
        when(mockPet1.getName()).thenReturn("Rex");
        when(mockPet1.getType()).thenReturn(PetType.DOG);
        when(mockPet1.getGender()).thenReturn(PetGender.MALE);
        when(mockPet1.getBirthdate()).thenReturn(LocalDate.of(2019, 5, 20));
        when(mockPet1.getBreed()).thenReturn("German Shepherd");
        when(mockPet1.getWeight()).thenReturn(30.5);
        when(mockPet1.getColor()).thenReturn("Brown");
        when(mockPet1.getUser()).thenReturn(mockUser);

        // Mock Pet 2
        Pet mockPet2 = mock(Pet.class);
        when(mockPet2.getPetid()).thenReturn(1002L);
        when(mockPet2.getName()).thenReturn("Mittens");
        when(mockPet2.getType()).thenReturn(PetType.CAT);
        when(mockPet2.getGender()).thenReturn(PetGender.FEMALE);
        when(mockPet2.getBirthdate()).thenReturn(LocalDate.of(2020, 8, 15));
        when(mockPet2.getBreed()).thenReturn("Siamese");
        when(mockPet2.getWeight()).thenReturn(4.3);
        when(mockPet2.getColor()).thenReturn("Cream");
        when(mockPet2.getUser()).thenReturn(mockUser);

        // Stub getPets() di mockUser untuk balikin list mockPet1 dan mockPet2
        List<Pet> petList = Arrays.asList(mockPet1, mockPet2);
        when(mockUser.getPets()).thenReturn(petList);

        // === ACT ===
        Long userId = mockUser.getUserid();
        String userName = mockUser.getName();
        List<Pet> pets = mockUser.getPets();

        // === PRINT OUTPUT ke terminal supaya keliatan ===
        System.out.println("User ID: " + userId);
        System.out.println("User Name: " + userName);
        System.out.println("User Email: " + mockUser.getEmail());
        System.out.println("Total Pets: " + pets.size());
        for (int i = 0; i < pets.size(); i++) {
            Pet pet = pets.get(i);
            System.out.printf("Pet #%d: Name=%s, Type=%s, Gender=%s, Breed=%s, Birthdate=%s, Weight=%.1f, Color=%s%n",
                    i + 1,
                    pet.getName(),
                    pet.getType(),
                    pet.getGender(),
                    pet.getBreed(),
                    pet.getBirthdate(),
                    pet.getWeight(),
                    pet.getColor());
        }

        // === ASSERT ===
        assertEquals(1L, userId);
        assertEquals("Jane Doe", userName);
        assertEquals("jane.doe@example.com", mockUser.getEmail());
        assertEquals(2, pets.size());

        Pet p1 = pets.get(0);
        assertEquals("Rex", p1.getName());
        assertEquals(PetType.DOG, p1.getType());
        assertEquals(PetGender.MALE, p1.getGender());
        assertEquals("German Shepherd", p1.getBreed());

        Pet p2 = pets.get(1);
        assertEquals("Mittens", p2.getName());
        assertEquals(PetType.CAT, p2.getType());
        assertEquals(PetGender.FEMALE, p2.getGender());
        assertEquals("Siamese", p2.getBreed());

        // Pastikan pet user sama mockUser
        assertSame(mockUser, p1.getUser());
        assertSame(mockUser, p2.getUser());
    }
}
