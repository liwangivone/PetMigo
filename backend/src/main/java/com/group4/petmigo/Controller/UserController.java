package com.group4.petmigo.Controller;


import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.group4.petmigo.DTO.UserDTO;
import com.group4.petmigo.Service.UserService;
import com.group4.petmigo.models.entities.User.User;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserController {

    @Autowired
    private UserService userService;
    
    @PostMapping("/register")
    public UserDTO register(@RequestParam String name,String email, String password) {
        
        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);
        return userService.register(user);
    }

    @PostMapping("/login")
    public UserDTO login(@RequestParam String email, @RequestParam String password) {
        return userService.Login(email, password);
    }

    @GetMapping("/ping/{id}")
    public ResponseEntity<?> ping(@PathVariable Long id) {
        boolean success = userService.pingUser(id);
        return success ? ResponseEntity.ok("ONLINE") : ResponseEntity.status(404).body("Not Found");
    }

    @PostMapping("/offline/{id}")
    public ResponseEntity<?> manualOffline(@PathVariable Long id) {
        boolean success = userService.manualSetOffline(id);
        return success ? ResponseEntity.ok("OFFLINE") : ResponseEntity.status(404).body("Not Found");
    }
    
    @GetMapping("/{id}")
    public UserDTO getUserById(@PathVariable Long id) {
        return userService.findById(id);
    }

    // Update profile with request params
    @PutMapping("/{id}/update")
    public UserDTO updateUserProfile(
            @PathVariable Long id,
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam(required = false) String phonenumber,
            @RequestParam(required = false) String password) {

        User updatedData = new User();
        updatedData.setName(name);
        updatedData.setEmail(email);
        updatedData.setPhonenumber(phonenumber);
        if (password != null && !password.isBlank()) {
            updatedData.setPassword(password);
        }

        updatedData.setUpdateAt(LocalDateTime.now());

        return userService.updateProfile(id, updatedData);
    }
}
