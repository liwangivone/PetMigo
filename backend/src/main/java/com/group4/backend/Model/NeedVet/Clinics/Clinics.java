package com.group4.backend.Model.NeedVet.Clinics;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.group4.backend.Model.NeedVet.Doctor.Doctor;

import jakarta.persistence.*;
import lombok.Data;
@Data
@Entity
public class Clinics {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nama;
    private String lokasi;
    private String jadwalBuka;

    @OneToMany(mappedBy = "clinic", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<Doctor> doctors;  // Make sure Doctor has a "clinic" field
}

