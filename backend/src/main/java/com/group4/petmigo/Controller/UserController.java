package com.group4.petmigo.Controller;

import org.springframework.beans.factory.annotation.Autowired;
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
}
