package com.group4.petmigo.DTO;

import lombok.Data;

@Data
public class VetDTO {
    private Long vetid;
    private String name;
    private String specialization;
    private int experienceYears;
    private String overview;
    private String schedule;
    private String email;
    
    // ── tambahan ──
    private Long   clinicId;    // bisa null
    private String clinicName;  // bisa null
}
