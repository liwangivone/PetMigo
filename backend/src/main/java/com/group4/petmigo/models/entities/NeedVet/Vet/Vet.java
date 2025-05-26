package com.group4.petmigo.models.entities.NeedVet.Vet;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.group4.petmigo.models.entities.NeedVet.Clinics.Clinics;
import com.group4.petmigo.models.entities.User.status;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "vet")
public class Vet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "vet_id")
    private Long vetid;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String specialization;

    @Column(name = "experience_years", nullable = false)
    private int experienceYears;

    @Column(nullable = false)
    private String overview;

    @Column(name = "schedule", nullable = false)
    private String schedule; 

    @Column(nullable = false)
    private String email;

    @Column(nullable = false)
    private String password;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private status status;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "clinic_id", nullable = true)
    @JsonIgnore
    private Clinics clinics;

}
