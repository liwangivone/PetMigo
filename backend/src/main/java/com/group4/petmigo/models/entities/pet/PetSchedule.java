package com.group4.petmigo.models.entities.pet;

import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "PetSchedule")
public class PetSchedule {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "schedule_id")
    private Long Schedule_id; // id dari schedule

    @Column(name = "category", nullable = false )
    private PetScheduleCategory category; //category pakai enum biar memilih salah satu
    
    @Column(name = "expense", nullable = false)
    private int expense; // expense int agar gak bisa abcd 
    
    @Column(name = "description", nullable = false)
    private String description; // description String agar bisa mengimput abcd 

    @Column(name = "date", nullable = false)
    private LocalDate date; // memakai local date agar data lebih gampang di baca saat memakai kalender

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pet_id", nullable = false)
    @JsonIgnore  // Avoid circular reference serialization
    private Pet pet;
}
