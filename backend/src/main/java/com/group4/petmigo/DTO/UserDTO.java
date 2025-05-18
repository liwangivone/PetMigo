package com.group4.petmigo.DTO;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class UserDTO {
    
 private Long user_id;
    private String username;
    private String phonenumber;
    private String email;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
