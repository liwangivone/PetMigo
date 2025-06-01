package com.group4.petmigo.Repository;

import com.group4.petmigo.models.entities.pet.PetSchedule;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PetScheduleRepository extends JpaRepository<PetSchedule, Long> {
    List<PetSchedule> findByPet_petid(Long petid);
}
