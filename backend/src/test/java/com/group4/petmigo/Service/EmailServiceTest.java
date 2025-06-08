package com.group4.petmigo.Service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;

import java.lang.reflect.Field;
import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class EmailServiceTest {

    private JavaMailSender mailSender;
    private EmailService emailService;

    @BeforeEach
    public void setUp() throws Exception {
        mailSender = mock(JavaMailSender.class);
        emailService = new EmailService(mailSender);

        // Set private fields via reflection
        setPrivateField(emailService, "otpLength", 6);
        setPrivateField(emailService, "otpExpirySeconds", 3); // 3 seconds for fast test
    }

    private void setPrivateField(Object target, String fieldName, Object value) throws Exception {
        Field field = target.getClass().getDeclaredField(fieldName);
        field.setAccessible(true);
        field.set(target, value);
    }

    @Test
    public void testSendOtp_EmailSentAndOtpStored() {
        String toEmail = "test@example.com";
        String otp = emailService.sendOtp(toEmail);

        // Verify that mailSender.send() was called
        ArgumentCaptor<SimpleMailMessage> captor = ArgumentCaptor.forClass(SimpleMailMessage.class);
        verify(mailSender, times(1)).send(captor.capture());

        SimpleMailMessage sentMessage = captor.getValue();

        assertEquals(toEmail, sentMessage.getTo()[0]);
        assertTrue(sentMessage.getText().contains(otp));
        assertTrue(emailService.isOtpValid(otp)); // OTP should be valid immediately after sending

        System.out.println("✅ OTP generated: " + otp);
        System.out.println("✅ Email sent to: " + sentMessage.getTo()[0]);
    }

    @Test
    public void testOtpValidity_ExpiresAfterTimeout() throws InterruptedException {
        String otp = emailService.sendOtp("expire@test.com");
        assertTrue(emailService.isOtpValid(otp), "OTP should be valid right after sending");

        // Wait longer than expiry
        Thread.sleep(TimeUnit.SECONDS.toMillis(4));
        assertFalse(emailService.isOtpValid(otp), "OTP should expire after timeout");

        System.out.println("✅ OTP expired as expected after timeout.");
    }
}
