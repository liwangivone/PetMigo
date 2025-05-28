package com.group4.petmigo.DTO;

import java.time.LocalDate;

import lombok.Data;

@Data
public class MessageDTO {
    private Long message_id;
    private String name;
    private String role;
    private Long senderId;
    private String messageText;
    private LocalDate sentDate;
}
