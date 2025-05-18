package com.group4.petmigo.models.entities.NeedVet.Vet;

import java.time.LocalDate;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.group4.petmigo.models.entities.Chat.Chat;
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
    private int vet_id;

    @Column(nullable = false)
    private String username;

    @Column(nullable = false)
    private String specialization;

    @Column(name = "experience_years", nullable = false)
    private int experienceYears;

    @Column(nullable = false)
    private String overview;

    @Column(name = "schedule", nullable = false)
    private LocalDate schedule; // Fixed typo from 'scedule'

    @Column(nullable = false)
    private String email;

    @Column(nullable = false)
    private String password;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private status status;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "clinic_id", nullable = false)
    @JsonIgnore
    private Clinics clinics;

    @OneToMany(mappedBy = "vet", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnoreProperties(value = {"vet"}, allowSetters = true)
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    private List<Chat> chat;
}
