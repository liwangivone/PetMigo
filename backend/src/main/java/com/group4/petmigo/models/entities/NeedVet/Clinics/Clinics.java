package com.group4.petmigo.models.entities.NeedVet.Clinics;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.group4.petmigo.models.entities.NeedVet.Vet.Vet;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
public class Clinics {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long clinics_id;

    private String name;          // Changed from 'nama'
    private String location;      // Changed from 'lokasi'
    private String openingHours;  // Changed from 'jadwalBuka'

    @OneToMany(mappedBy = "clinics", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<Vet> vet;
}
