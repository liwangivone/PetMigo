package com.group4.petmigo.Service;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.util.*;

import com.group4.petmigo.DTO.UserDTO;
import com.group4.petmigo.Repository.UserRepository;
import com.group4.petmigo.models.entities.User.User;
import com.group4.petmigo.models.entities.User.status;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;

public class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    private User user;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this); // Init mocks

        user = new User();
        user.setUserid(1L);
        user.setUid("123");  // Ganti ke Long kalau service mengharapkan Long
        user.setName("testuser");
        user.setEmail("test@example.com");
        user.setPassword("password");
        user.setPhonenumber("12345678");
        user.setStatus(status.offline);
    }

    @Test
    public void testRegisterSuccess() {
        when(userRepository.existsByEmail(user.getEmail())).thenReturn(false);
        when(userRepository.existsByName(user.getName())).thenReturn(false);
        when(userRepository.findTopByOrderByUidDesc()).thenReturn(Collections.singletonList(user));
        when(userRepository.save(any(User.class))).thenAnswer(i -> i.getArgument(0));

        UserDTO result = userService.register(user);

        assertNotNull(result);
        assertEquals(user.getName(), result.getName());
        assertEquals(user.getEmail(), result.getEmail());
        verify(userRepository).save(any(User.class));
    }

    @Test
    public void testRegisterDuplicateEmail() {
        when(userRepository.existsByEmail(user.getEmail())).thenReturn(true);

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            userService.register(user);
        });

        assertEquals("Email sudah digunakan.", exception.getMessage());
        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    public void testLoginSuccess() {
        when(userRepository.findByEmail(user.getEmail())).thenReturn(user);

        UserDTO result = userService.Login(user.getEmail(), user.getPassword());

        assertNotNull(result);
        assertEquals(user.getEmail(), result.getEmail());
        assertEquals(user.getName(), result.getName());
    }

    @Test
    public void testLoginFailWrongPassword() {
        when(userRepository.findByEmail(user.getEmail())).thenReturn(user);

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            userService.Login(user.getEmail(), "wrongpassword");
        });

        assertEquals("email atau password salah", exception.getMessage());
    }

    @Test
    public void testLoginFailUserNotFound() {
        when(userRepository.findByEmail("notfound@example.com")).thenReturn(null);

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            userService.Login("notfound@example.com", "anyPassword");
        });

        assertEquals("email atau password salah", exception.getMessage());
    }
}
