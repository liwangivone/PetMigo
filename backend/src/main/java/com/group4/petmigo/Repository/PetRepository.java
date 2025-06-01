package com.group4.petmigo.Repository;

import com.group4.petmigo.models.entities.pet.Pet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PetRepository extends JpaRepository<Pet, Long> {
    List<Pet> findByUserUserid(Long userid);
}
