package com.group4.petmigo.Repository;

import com.group4.petmigo.models.entities.pet.Pet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PetRepository extends JpaRepository<Pet, Long> {
    List<Pet> findByUserUserid(Long userid);
    // Fetch pets beserta schedules sekaligus (fetch join)
    @Query("SELECT DISTINCT p FROM Pet p LEFT JOIN FETCH p.petSchedule WHERE p.user.userid = :userId")
    List<Pet> findPetsWithSchedulesByUserId(@Param("userId") Long userId);
}
