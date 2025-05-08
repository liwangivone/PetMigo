package com.group4.backend.Model.MyPet;

import java.time.LocalDate;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.group4.backend.Model.MyPet.PetFile.File.PetFiles;
import com.group4.backend.Model.MyPet.PetSchedule.PetSchedule;
import com.group4.backend.Model.User.User;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
public class Pet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private PetGender gender;
    private PetType type;
    private LocalDate birthday;
    private String breed;
    private double weight;
    private String color;


    @Enumerated(EnumType.STRING)
    private PetFiles files; 

    @OneToMany(mappedBy = "pet", fetch = FetchType.LAZY)
    @JsonIgnore
    private List<PetSchedule> petSchedule;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    @JsonIgnore  // Prevent infinite recursion
    private User user;
}
