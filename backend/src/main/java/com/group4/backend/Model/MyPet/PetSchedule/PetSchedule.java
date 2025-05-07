package com.group4.backend.Model.MyPet.PetSchedule;

import java.time.LocalDate;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.group4.backend.Model.MyPet.Pet;
import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
public class PetSchedule {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private PetTypeSchedule category;  // Ensure PetTypeSchedule enum exists
    private int pengeluaran;  // Ensure PetTypeSchedule enum exists
    private String deskripsi;  // Ensure PetTypeSchedule enum exists
    private LocalDate date;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pet_id", nullable = false)
    @JsonIgnore  // Avoid circular reference serialization
    private Pet pet;
}
