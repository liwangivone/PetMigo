package com.group4.petmigo.DTO;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ChatDTO {
    private Long chat_id;
    private LocalDateTime timecreated;
    private String status;
}
