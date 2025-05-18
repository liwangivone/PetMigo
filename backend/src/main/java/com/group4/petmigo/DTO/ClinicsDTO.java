package com.group4.petmigo.DTO;

import lombok.Data;

@Data
public class ClinicsDTO {
    private Long clinics_id;
    private String name;
    private String location;
    private String openinghours;
}
