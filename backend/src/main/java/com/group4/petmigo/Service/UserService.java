package com.group4.petmigo.Service;


import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.group4.petmigo.DTO.UserDTO;
import com.group4.petmigo.Repository.UserRepository;
import com.group4.petmigo.models.entities.User.User;
import com.group4.petmigo.models.entities.User.status;

@Service
public class UserService {

    
    @Autowired
    private UserRepository userRepository;
    
    public UserDTO register(User user) {
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email sudah digunakan.");
        }

        if (userRepository.existsByName(user.getName())) {
            throw new RuntimeException("Username sudah digunakan.");
        }

        if (user.getPassword() == null || user.getPassword().isBlank()) {
            throw new RuntimeException("Password tidak boleh kosong.");
        }

        user.setStatus(status.offline);
        user.setUid(generateUid());
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdateAt(LocalDateTime.now());
        user.setPets(null);

        User saved = userRepository.save(user);
        return toDTO(saved);
    }


    public UserDTO Login(String email, String password){
        User user = userRepository.findByEmail(email);
        if (user != null && user.getPassword().equals(password)) {
            return toDTO(user);
        }

        throw new RuntimeException("email atau password salah");
    }

  // Map menyimpan last ping time tiap user yang online
    private final ConcurrentHashMap<Long, LocalDateTime> onlineUsers = new ConcurrentHashMap<>();

    public boolean pingUser(Long id) {
        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isEmpty()) return false;

        User user = userOpt.get();

        if (user.getStatus() != status.online) {
            user.setStatus(status.online);
            userRepository.save(user);
        }

        onlineUsers.put(id, LocalDateTime.now());
        return true;
    }

    public boolean manualSetOffline(Long id) {
        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isEmpty()) return false;

        User user = userOpt.get();
        if(user.getStatus() != status.offline){
            user.setStatus(status.offline);
            userRepository.save(user);
        }
        onlineUsers.remove(id);
        return true;
    }

    public UserDTO findById(Long id) {
        return userRepository.findById(id)
            .map(this::toDTO)
            .orElseThrow(() -> new RuntimeException("User tidak ditemukan dengan ID: " + id));
    }

    public UserDTO updateProfile(Long id, User updatedData) {
    User user = userRepository.findById(id)
        .orElseThrow(() -> new RuntimeException("User tidak ditemukan."));

    if (!user.getEmail().equals(updatedData.getEmail())
            && userRepository.existsByEmail(updatedData.getEmail())) {
        throw new RuntimeException("Email sudah digunakan.");
    }

    if (!user.getName().equals(updatedData.getName())
            && userRepository.existsByName(updatedData.getName())) {
        throw new RuntimeException("Username sudah digunakan.");
    }

    user.setName(updatedData.getName());
    user.setEmail(updatedData.getEmail());
    user.setPhonenumber(updatedData.getPhonenumber());
    user.setPassword(updatedData.getPassword()); // opsional, bisa dicek null
    user.setUpdateAt(LocalDateTime.now());

    return toDTO(userRepository.save(user));
    }



    // ini otomatis online offline

    @Scheduled(fixedRate = 10000) // tiap 5 detik cek semua user yang online
    public void checkOfflineUsers() {
        LocalDateTime now = LocalDateTime.now();

        for (Map.Entry<Long, LocalDateTime> entry : onlineUsers.entrySet()) {
            Long userId = entry.getKey();
            LocalDateTime lastPing = entry.getValue();

            // Jika sudah lebih dari 10 detik tidak ping
            if (lastPing.plusSeconds(10).isBefore(now)) {
                manualSetOffline(userId); // otomatis set offline user
            }
        }
    }

    private UserDTO toDTO(User user){
        UserDTO dto = new UserDTO();
        dto.setUserid(user.getUserid());
        dto.setName(user.getName());
        dto.setEmail(user.getEmail());
        dto.setPhonenumber(user.getPhonenumber());
        return dto;
    }

    private String generateUid() {
    List<User> latestUsers = userRepository.findTopByOrderByUidDesc();
    if (latestUsers.isEmpty()) {
        return "00000000";
    }
    Long lastId = latestUsers.get(0).getUserid(); // ambil id terakahir
    return String.format("%08d", lastId + 1); // format ke 8 digit
    }
}
