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
        user.setUid("00000001");
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

        System.out.println("✅ testRegisterSuccess passed");
    }

    @Test
    public void testRegisterDuplicateEmail() {
        when(userRepository.existsByEmail(user.getEmail())).thenReturn(true);

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            userService.register(user);
        });

        assertEquals("Email sudah digunakan.", exception.getMessage());
        verify(userRepository, never()).save(any(User.class));

        System.out.println("✅ testRegisterDuplicateEmail passed");
    }

    @Test
    public void testLoginSuccess() {
        when(userRepository.findByEmail(user.getEmail())).thenReturn(user);

        UserDTO result = userService.Login(user.getEmail(), user.getPassword());

        assertNotNull(result);
        assertEquals(user.getEmail(), result.getEmail());

        System.out.println("✅ testLoginSuccess passed");
    }

    @Test
    public void testLoginFailWrongPassword() {
        when(userRepository.findByEmail(user.getEmail())).thenReturn(user);

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            userService.Login(user.getEmail(), "wrongpassword");
        });

        assertEquals("email atau password salah", exception.getMessage());

        System.out.println("✅ testLoginFailWrongPassword passed");
    }

    @Test
    public void testLoginFailUserNotFound() {
        when(userRepository.findByEmail("notfound@example.com")).thenReturn(null);

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            userService.Login("notfound@example.com", "anyPassword");
        });

        assertEquals("email atau password salah", exception.getMessage());

        System.out.println("✅ testLoginFailUserNotFound passed");
    }

    @Test
    public void testPingUser_Success() {
        when(userRepository.findById(user.getUserid())).thenReturn(Optional.of(user));
        when(userRepository.save(any(User.class))).thenReturn(user);

        boolean result = userService.pingUser(user.getUserid());

        assertTrue(result);
        verify(userRepository).save(user);

        System.out.println("✅ testPingUser_Success passed");
    }

    @Test
    public void testPingUser_NotFound() {
        when(userRepository.findById(99L)).thenReturn(Optional.empty());

        boolean result = userService.pingUser(99L);

        assertFalse(result);
        verify(userRepository, never()).save(any());

        System.out.println("✅ testPingUser_NotFound passed");
    }

    @Test
    public void testManualSetOffline_Success() {
        user.setStatus(status.online);
        when(userRepository.findById(user.getUserid())).thenReturn(Optional.of(user));
        when(userRepository.save(any(User.class))).thenReturn(user);

        boolean result = userService.manualSetOffline(user.getUserid());

        assertTrue(result);
        assertEquals(status.offline, user.getStatus());
        verify(userRepository).save(user);

        System.out.println("✅ testManualSetOffline_Success passed");
    }

    @Test
    public void testFindById_Success() {
        when(userRepository.findById(user.getUserid())).thenReturn(Optional.of(user));

        UserDTO dto = userService.findById(user.getUserid());

        assertNotNull(dto);
        assertEquals(user.getEmail(), dto.getEmail());

        System.out.println("✅ testFindById_Success passed");
    }

    @Test
    public void testFindById_NotFound() {
        when(userRepository.findById(123L)).thenReturn(Optional.empty());

        RuntimeException ex = assertThrows(RuntimeException.class, () -> {
            userService.findById(123L);
        });

        assertTrue(ex.getMessage().contains("User tidak ditemukan"));

        System.out.println("✅ testFindById_NotFound passed");
    }

    @Test
    public void testUpdateProfile_Success() {
        User updated = new User();
        updated.setName("newname");
        updated.setEmail("new@example.com");
        updated.setPhonenumber("987654321");
        updated.setPassword("newpass");

        when(userRepository.findById(user.getUserid())).thenReturn(Optional.of(user));
        when(userRepository.existsByEmail("new@example.com")).thenReturn(false);
        when(userRepository.existsByName("newname")).thenReturn(false);
        when(userRepository.save(any(User.class))).thenReturn(user);

        UserDTO result = userService.updateProfile(user.getUserid(), updated);

        assertNotNull(result);
        assertEquals("new@example.com", result.getEmail());
        assertEquals("newname", result.getName());

        System.out.println("✅ testUpdateProfile_Success passed");
    }

    @Test
    public void testGetUserProfileById_Success() {
        when(userRepository.findByUserid(user.getUserid())).thenReturn(Optional.of(user));

        User result = userService.getUserProfileById(user.getUserid());

        assertNotNull(result);
        assertEquals(user.getEmail(), result.getEmail());

        System.out.println("✅ testGetUserProfileById_Success passed");
    }

    @Test
    public void testGetUserProfileById_NotFound() {
        when(userRepository.findByUserid(404L)).thenReturn(Optional.empty());

        RuntimeException ex = assertThrows(RuntimeException.class, () -> {
            userService.getUserProfileById(404L);
        });

        assertTrue(ex.getMessage().contains("User dengan ID 404 tidak ditemukan"));

        System.out.println("✅ testGetUserProfileById_NotFound passed");
    }
}
