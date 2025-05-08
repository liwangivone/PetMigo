package com.group4.petmigo.models.entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "vet")
@Getter
@Setter
@NoArgsConstructor

public class Vet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "vet_id")
    private int vetID;

    @Column(name = "vet_name", nullable = false)
    private String vetName;

    @Column(name = "specialization", nullable = false)
    private String specialization;

    @Column(name = "experience_years", nullable = false)
    private int experienceYears;

    @Column(name = "overview", nullable = false)
    private String overview;


    public Vet(int vetID, String vetName, String specialization, int experienceYears, String overview) {
        this.vetID = vetID;
        this.vetName = vetName;
        this.specialization = specialization;
        this.experienceYears = experienceYears;
        this.overview = overview;
    }    
}
