package com.group4.petmigo.models.entities.User;

import java.time.LocalDate;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.group4.petmigo.models.entities.pet.Pet;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long user_id;
    
    @Column(name = "username", nullable = false)
    private String username;

    @Column(name = "phonenumber", nullable = false)
    private String phonenumber;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "email", nullable = false)
    private String email;

    @Column(name = "calendar", nullable = false)
    private LocalDate calendar;

    @Column(name = "uid", nullable = false)
    private Long uid;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnoreProperties(value = { "user" }, allowSetters = true) // Avoid circular reference for Pet
    @JsonProperty(access = JsonProperty.Access.READ_ONLY) // Prevent pets from being included in JSON serialization
    private List<Pet> pets;
}