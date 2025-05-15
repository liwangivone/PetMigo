package com.group4.petmigo.DTO;

import java.time.LocalDate;
import java.util.List;

import lombok.Data;

@Data
public class PetDTO {
    private Long pet_id;
    private String name;
    private String gender;  // Bisa String atau enum name()
    private String type;
    private LocalDate birthdate;
    private String breed;
    private Double weight;
    private String color;
    private List<PetScheduleDTO> petSchedule;
}
