package com.group4.petmigo.Service;

import com.group4.petmigo.Repository.ChatRepository;
import com.group4.petmigo.Repository.MessageRepository;
import com.group4.petmigo.Repository.UserRepository;
import com.group4.petmigo.Repository.VetRepository;
import com.group4.petmigo.models.entities.Chat.Chat;
import com.group4.petmigo.models.entities.NeedVet.Vet.Vet;
import com.group4.petmigo.models.entities.User.User;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.web.server.ResponseStatusException;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class ChatServiceTest {

    @Mock
    private ChatRepository chatRepo;

    @Mock
    private UserRepository userRepo;

    @Mock
    private VetRepository vetRepo;

    @Mock
    private MessageRepository messageRepo;

    @InjectMocks
    private ChatService chatService;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this); // Inisialisasi @Mock dan @InjectMocks
    }

    @Test
    public void testCreateChat_Success() {
        Long userId = 1L;
        Long vetId = 2L;

        User mockUser = new User();
        mockUser.setUserid(userId);
        mockUser.setName("Test User");

        Vet mockVet = new Vet();
        mockVet.setVetid(vetId);
        mockVet.setName("Dr. Vet");

        when(userRepo.findById(userId)).thenReturn(Optional.of(mockUser));
        when(vetRepo.findById(vetId)).thenReturn(Optional.of(mockVet));

        Chat mockChat = new Chat();
        mockChat.setUser(mockUser);
        mockChat.setVet(mockVet);
        when(chatRepo.save(any(Chat.class))).thenReturn(mockChat);

        Chat createdChat = chatService.createChat(userId, vetId);

        assertNotNull(createdChat);
        assertEquals(mockUser, createdChat.getUser());
        assertEquals(mockVet, createdChat.getVet());

        // Print hasil
        System.out.println("✅ testCreateChat_Success:");
        System.out.println("User: " + createdChat.getUser().getName());
        System.out.println("Vet : " + createdChat.getVet().getName());
    }

    @Test
    public void testCreateChat_UserNotFound() {
        Long userId = 1L;
        Long vetId = 2L;

        when(userRepo.findById(userId)).thenReturn(Optional.empty());

        ResponseStatusException exception = assertThrows(ResponseStatusException.class, () -> {
            chatService.createChat(userId, vetId);
        });

        assertEquals("404 NOT_FOUND \"User tidak ditemukan\"", exception.getMessage());
        System.out.println("✅ testCreateChat_UserNotFound: " + exception.getMessage());
    }

    @Test
    public void testCreateChat_VetNotFound() {
        Long userId = 1L;
        Long vetId = 2L;

        User mockUser = new User();
        mockUser.setUserid(userId);

        when(userRepo.findById(userId)).thenReturn(Optional.of(mockUser));
        when(vetRepo.findById(vetId)).thenReturn(Optional.empty());

        ResponseStatusException exception = assertThrows(ResponseStatusException.class, () -> {
            chatService.createChat(userId, vetId);
        });

        assertEquals("404 NOT_FOUND \"Dokter tidak ditemukan\"", exception.getMessage());
        System.out.println("✅ testCreateChat_VetNotFound: " + exception.getMessage());
    }
}
