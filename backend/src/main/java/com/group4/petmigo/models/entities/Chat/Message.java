package com.group4.petmigo.models.entities.Chat;

import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonBackReference;

import jakarta.persistence.*;
import lombok.Data;


@Data
@Entity
public class Message {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long message_id;

    private String username; //data gak perlu nullable karena otomatis bukan user yang buat
    private String role;
    private Long sender_id;
    private String messagetext;
    private LocalDate sentdate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chat_id", nullable = false)
    @JsonBackReference
    private Chat chat;
}