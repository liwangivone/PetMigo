package com.group4.petmigo.models.entities;

import java.security.SecureRandom;

public class OtpGenerator {
    private static final String DIGITS = "0123456789";

    public static String generateOtp(int length) {
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < length; i++) {
            sb.append(DIGITS.charAt(random.nextInt(DIGITS.length())));
        }

        return sb.toString();
    }
}
