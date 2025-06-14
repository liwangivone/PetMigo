package com.group4.petmigo.DTO;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class PetScheduleDTO {
    private Long schedule_id;
    private String category;
    private int expense;
    private String description;
    private LocalDateTime date;
}
