package com.group4.petmigo.models.entities.User;

import java.time.LocalDateTime;
import java.util.List;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

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
    private Long userid;
    
    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "phonenumber", nullable = true)
    private String phonenumber;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "email", nullable = false)
    private String email;

    @CreationTimestamp
    @Column(name = "createdAt", updatable = false)
    private LocalDateTime createdAt; // ini creation dan update jangan dihapus emang gak perlu tapi kan memang harus ada 

    @UpdateTimestamp
    private LocalDateTime updateAt;

    @Column(name = "uid", nullable = false, unique = true)
    private String uid;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private status status;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnoreProperties(value = { "user" }, allowSetters = true) // Avoid circular reference for Pet
    @JsonProperty(access = JsonProperty.Access.READ_ONLY) // Prevent pets from being included in JSON serialization
    private List<Pet> pets;
}