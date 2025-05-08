package com.group4.backend.Model.User;

import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.group4.backend.Model.MyPet.Pet;
import com.group4.backend.Model.User.UserFoto.Foto;
import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long id;

    private String username;
    private String phonenumber;
    private String password;
    private String email;
    private String calendar;
    private Long uid;
    private Foto foto;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnoreProperties(value = { "user" }, allowSetters = true) // Avoid circular reference for Pet
    @JsonProperty(access = JsonProperty.Access.READ_ONLY) // Prevent pets from being included in JSON serialization
    private List<Pet> pets;
}
