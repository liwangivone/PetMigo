package com.group4.petmigo.Service;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import com.group4.petmigo.models.entities.OtpGenerator;

@Service
public class EmailService {
    
        private final JavaMailSender mailSender;

    @Value("${otp.length}")
    private int otpLength;

    @Value("${otp.expiry.seconds}")  // Changed to read seconds
    private int otpExpirySeconds;

    private ConcurrentHashMap<String, Long> otpExpirations = new ConcurrentHashMap<>(); // Store OTP expirations

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public String sendOtp(String toEmail) {
        String otp = OtpGenerator.generateOtp(otpLength);

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("Your OTP Code");
        message.setText("Your OTP is: " + otp + "\nIt will expire in " + otpExpirySeconds + " seconds.");

        mailSender.send(message);

        // Set OTP expiration to the configured value in seconds
        otpExpirations.put(otp, System.currentTimeMillis() + TimeUnit.SECONDS.toMillis(otpExpirySeconds));

        return otp;
    }

    // Method to validate OTP
    public boolean isOtpValid(String otp) {
        Long expiryTime = otpExpirations.get(otp);
        return expiryTime != null && System.currentTimeMillis() < expiryTime;
    }

}
