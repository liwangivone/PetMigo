package com.group4.petmigo.DTO;


import java.time.LocalDate;
import lombok.Data;

@Data
public class VetDTO {
    private int vet_id;
    private String username;
    private String specialization;
    private int experienceYears;
    private String overview;
    private LocalDate schedule;
    private String email;
}
