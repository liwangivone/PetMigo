package com.group4.petmigo.Controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.group4.petmigo.Service.EmailService;

@RestController
@RequestMapping("/api/email")
@CrossOrigin(origins = "*")
public class EmailController {
    
        private final EmailService emailService;

    public EmailController(EmailService emailService) {
        this.emailService = emailService;
    }

    @PostMapping("/send-otp")
    public String sendOtp(@RequestParam String email) {
        String otp = emailService.sendOtp(email);
        return "OTP sent to " + email + ": " + otp; // hanya untuk testing
    }

}
