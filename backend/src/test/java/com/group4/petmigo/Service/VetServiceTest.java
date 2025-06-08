package com.group4.petmigo.Service;

import com.group4.petmigo.DTO.VetDTO;
import com.group4.petmigo.Repository.VetRepository;
import com.group4.petmigo.models.entities.NeedVet.Vet.Vet;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class VetServiceTest {

    private VetRepository vetRepository;
    private VetService vetService;

    @BeforeEach
    public void setUp() {
        vetRepository = mock(VetRepository.class);
        vetService = new VetService(vetRepository);
    }

    @Test
    public void testRegister_Success() {
        Vet vet = new Vet();
        vet.setEmail("vet@example.com");
        vet.setName("Dr. Vet");

        when(vetRepository.existsByEmail("vet@example.com")).thenReturn(false);
        when(vetRepository.existsByName("Dr. Vet")).thenReturn(false);
        when(vetRepository.save(any(Vet.class))).thenAnswer(invocation -> invocation.getArgument(0));

        VetDTO result = vetService.register(vet);

        assertNotNull(result);
        assertEquals("Dr. Vet", result.getName());
        assertEquals("vet@example.com", result.getEmail());
        verify(vetRepository).save(vet);
        System.out.println("✅ Register berhasil: " + result.getName());
    }

    @Test
    public void testRegister_EmailAlreadyUsed() {
        Vet vet = new Vet();
        vet.setEmail("used@example.com");

        when(vetRepository.existsByEmail("used@example.com")).thenReturn(true);

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            vetService.register(vet);
        });

        assertEquals("Email sudah digunakan.", exception.getMessage());
        System.out.println("✅ Gagal register karena email sudah dipakai");
    }

    @Test
    public void testRegister_UsernameAlreadyUsed() {
        Vet vet = new Vet();
        vet.setEmail("new@example.com");
        vet.setName("UsedName");

        when(vetRepository.existsByEmail("new@example.com")).thenReturn(false);
        when(vetRepository.existsByName("UsedName")).thenReturn(true);

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            vetService.register(vet);
        });

        assertEquals("Username sudah digunakan.", exception.getMessage());
        System.out.println("✅ Gagal register karena nama sudah dipakai");
    }

    @Test
    public void testLogin_Success() {
        Vet vet = new Vet();
        vet.setEmail("vet@example.com");
        vet.setPassword("password123");
        vet.setName("Dr. Vet");

        when(vetRepository.findByEmail("vet@example.com")).thenReturn(vet);

        VetDTO result = vetService.login("vet@example.com", "password123");

        assertNotNull(result);
        assertEquals("Dr. Vet", result.getName());
        System.out.println("✅ Login berhasil: " + result.getEmail());
    }

    @Test
    public void testLogin_InvalidCredentials() {
        when(vetRepository.findByEmail("wrong@example.com")).thenReturn(null);

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            vetService.login("wrong@example.com", "anyPassword");
        });

        assertEquals("email atau password salah", exception.getMessage());
        System.out.println("✅ Login gagal karena email salah");
    }

    @Test
    public void testGetAllVets() {
        Vet vet1 = new Vet();
        vet1.setVetid(1L);
        vet1.setName("Dr. One");
        vet1.setEmail("one@example.com");

        Vet vet2 = new Vet();
        vet2.setVetid(2L);
        vet2.setName("Dr. Two");
        vet2.setEmail("two@example.com");

        when(vetRepository.findAll()).thenReturn(Arrays.asList(vet1, vet2));

        List<VetDTO> vets = vetService.getAllVets();

        assertEquals(2, vets.size());
        assertEquals("Dr. One", vets.get(0).getName());
        assertEquals("Dr. Two", vets.get(1).getName());

        System.out.println("✅ getAllVets berhasil, jumlah: " + vets.size());
    }
}
