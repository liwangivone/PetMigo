package com.group4.petmigo.Service;


import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
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

        if (userRepository.existsByUsername(user.getUsername())) {
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

    private UserDTO toDTO(User user){
        UserDTO dto = new UserDTO();
        dto.setUser_id(user.getUser_id());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        dto.setPhonenumber(user.getPhonenumber());
        return dto;
    }

    private String generateUid() {
    List<User> latestUsers = userRepository.findTopByOrderByUidDesc();
    if (latestUsers.isEmpty()) {
        return "00000000";
    }
    Long lastId = latestUsers.get(0).getUser_id(); // ambil id terakhir
    return String.format("%08d", lastId + 1); // format ke 8 digit
    }
}
