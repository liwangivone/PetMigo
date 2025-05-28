package com.group4.petmigo.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.group4.petmigo.models.entities.NeedVet.Vet.Vet;

@Repository
public interface VetRepository extends JpaRepository <Vet, Long> {

    boolean existsByEmail(String email);
    boolean existsByName(String name);
    Vet findByEmail(String email);

}