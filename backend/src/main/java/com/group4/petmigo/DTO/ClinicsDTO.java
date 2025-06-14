package com.group4.petmigo.DTO;

import java.util.List;

import lombok.Data;

@Data
public class ClinicsDTO {
    private String name;
    private String location;
    private String openinghours;
    private Long vetId; // ← Tambah vetId agar bisa assign vet ke clinic
    private List<Long> vetIds;
}
