package com.group4.backend.Model.NeedVet.Doctor;

import java.time.LocalDate;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.group4.backend.Model.Chat.Chat;
import com.group4.backend.Model.NeedVet.Clinics.Clinics;

import jakarta.persistence.*;
import lombok.Data;
@Data
@Entity
public class Doctor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;
    private String phonenumber;
    private String spesialisasi;
    private LocalDate pengalaman;
    private String deskripsi;
    private LocalDate jadwal;
    private String password;
    private String email;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "clinic_id", nullable = false)  // Relating to Clinics
    @JsonIgnore  // Prevent infinite recursion
    private Clinics clinic;

    @OneToMany(mappedBy = "doctor", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnoreProperties(value = {"doctor"}, allowSetters = true)
    @JsonProperty(access = JsonProperty.Access.READ_ONLY)
    private List<Chat> chats;
}
