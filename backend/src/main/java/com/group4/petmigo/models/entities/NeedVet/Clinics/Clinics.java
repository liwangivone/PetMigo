package com.group4.petmigo.models.entities.NeedVet.Clinics;

import java.util.ArrayList;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.group4.petmigo.models.entities.NeedVet.Vet.Vet;
import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
public class Clinics {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "clinics_id")
    private Long clinicsid;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String location;

    @Column(nullable = false)
    private String openinghours;

// Clinics.java
    @OneToMany(
        mappedBy = "clinics",
        cascade = {CascadeType.PERSIST, CascadeType.MERGE}, // ← Hanya simpan & update
        orphanRemoval = false                               // ← Jangan hapus orphan
    )
    private List<Vet> vet = new ArrayList<>();

}
