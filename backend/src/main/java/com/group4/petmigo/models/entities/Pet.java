package com.group4.petmigo.models.entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "pet")
@Getter
@Setter
@NoArgsConstructor

public class Pet {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "pet_id")
    private int petID;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User userID;

    @Column(name = "nickname", nullable = false)
    private String nickname;

    @Column(name = "gender", nullable = false)
    private String gender;

    @Column(name = "breed", nullable = false)
    private String breed;

    @Column(name = "birth_date", nullable = false)
    private String birthDate;

}
