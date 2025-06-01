package com.group4.petmigo.Service;

import com.group4.petmigo.models.entities.User.User;
import com.group4.petmigo.models.entities.pet.Pet;
import com.group4.petmigo.Repository.PetRepository;
import com.group4.petmigo.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PetService {

    @Autowired
    private PetRepository petRepository;

    @Autowired
    private UserRepository userRepository;

    // Create Pet dengan userId
    public Pet createPet(Long userId, Pet pet) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isEmpty()) {
            throw new IllegalArgumentException("User dengan id " + userId + " tidak ditemukan.");
        }
        User user = userOpt.get();
        pet.setUser(user);
        return petRepository.save(pet);
    }

    // Read Pet by id
    public Optional<Pet> getPetById(Long petId) {
        return petRepository.findById(petId);
    }

    // Update Pet (asumsi pet sudah punya ID valid)
    public Pet updatePet(Long petId, Pet updatedPet) {
        Optional<Pet> petOpt = petRepository.findById(petId);
        if (petOpt.isEmpty()) {
            throw new IllegalArgumentException("Pet dengan id " + petId + " tidak ditemukan.");
        }
        Pet pet = petOpt.get();
        pet.setName(updatedPet.getName());
        pet.setBreed(updatedPet.getBreed());
        pet.setType(updatedPet.getType());
        pet.setGender(updatedPet.getGender());
        pet.setBirthdate(updatedPet.getBirthdate());
        pet.setColor(updatedPet.getColor());
        pet.setWeight(updatedPet.getWeight());
        // User tidak diupdate di sini, kecuali ingin support pindah user
        return petRepository.save(pet);
    }

    // Delete Pet
    public void deletePet(Long petId) {
        petRepository.deleteById(petId);
    }

    // List all pets for a user
    public List<Pet> getPetsByUserId(Long userid) {
        return petRepository.findByUserUserid(userid); // method custom di repo, sesuaikan
    }
}
