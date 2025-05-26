package com.group4.petmigo.DTO;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class UserDTO {
    
 private Long userid;
    private String name;
    private String phonenumber;
    private String email;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
