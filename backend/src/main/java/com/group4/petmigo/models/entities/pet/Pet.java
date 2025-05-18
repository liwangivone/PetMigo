package com.group4.petmigo.models.entities.pet;

import java.time.LocalDate;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.group4.petmigo.models.entities.User.User;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
public class Pet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "pet_id")
    private Long pet_id;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "gender", nullable = false)
    private PetGender gender;
    
    @Column(name = "type", nullable = false)
    private PetType type;
    
    @Column(name = "birhdate", nullable = false)
    private LocalDate birthdate;
    
    @Column(name = "breed", nullable = false)
    private String breed;
    
    @Column(name = "weight", nullable = true)
    private double weight;

    @Column(name = "color", nullable = true)
    private String color;



    @OneToMany(mappedBy = "pet", fetch = FetchType.LAZY)
    @JsonIgnore
    private List<PetSchedule> petSchedule;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    @JsonIgnore  // Prevent infinite recursion
    private User user;
}