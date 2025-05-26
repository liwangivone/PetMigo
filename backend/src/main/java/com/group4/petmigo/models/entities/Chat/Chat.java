package com.group4.petmigo.models.entities.Chat;

import java.time.LocalDateTime;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.group4.petmigo.models.entities.NeedVet.Vet.Vet;
import com.group4.petmigo.models.entities.User.User;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
public class Chat {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long chat_id;
    
    private LocalDateTime timecreated;
    private String status;

    @ManyToOne
    @JoinColumn(name = "user_id") // atau "vet_id", tergantung desain
    private User user;

    @ManyToOne
    @JoinColumn(name = "vet_id")
    private Vet vet;

    @OneToMany(mappedBy = "chat", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference
    private List<Message> messages;
}