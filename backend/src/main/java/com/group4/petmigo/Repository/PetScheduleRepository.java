package com.group4.petmigo.Repository;

import com.group4.petmigo.models.entities.pet.Pet;
import com.group4.petmigo.models.entities.pet.PetSchedule;

import jakarta.transaction.Transactional;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.stereotype.Repository;

@Repository
public interface PetScheduleRepository extends JpaRepository<PetSchedule, Long> {
    List<PetSchedule> findByPet_petid(Long petid);
    List<PetSchedule> findByPet(Pet pet);
    
    @Modifying
    @Transactional
    void deleteByPet_Petid(Long petid); // pakai naming convention saja
}
