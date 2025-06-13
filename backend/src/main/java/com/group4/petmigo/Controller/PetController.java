package com.group4.petmigo.Controller;

import com.group4.petmigo.models.entities.pet.Pet;
import com.group4.petmigo.Service.PetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/pet")
public class PetController {

    @Autowired
    private PetService petService;

    // Create pet dengan userId sebagai query param atau path var
    @PostMapping("/register")
    public ResponseEntity<Pet> registerPet(@RequestParam Long userId, @RequestBody Pet pet) {
        Pet created = petService.createPet(userId, pet);
        return ResponseEntity.ok(created);
    }

    // Read pet by id
    @GetMapping("/{id}")
    public ResponseEntity<Pet> getPet(@PathVariable Long id) {
        Optional<Pet> petOpt = petService.getPetById(id);
        if (petOpt.isPresent()) {
            return ResponseEntity.ok(petOpt.get());
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Update pet by id
    @PutMapping("/{id}")
    public ResponseEntity<Pet> updatePet(@PathVariable Long id, @RequestBody Pet pet) {
        try {
            Pet updated = petService.updatePet(id, pet);
            return ResponseEntity.ok(updated);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // Delete pet by id
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePet(@PathVariable Long id) {
        petService.deletePet(id);
        return ResponseEntity.noContent().build();
    }

    // Get all pets for a user
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Pet>> getPetsByUser(@PathVariable Long userId) {
        List<Pet> pets = petService.getPetsByUserId(userId);
        return ResponseEntity.ok(pets);
    }
}
