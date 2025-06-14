package com.group4.petmigo.models.entities.ChatBot;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.ForeignKey;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Table;
import jakarta.persistence.ManyToOne;
import lombok.Setter;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Setter
@Getter
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "ai_chat")
public class AIChat {

    @Id
    @Column(name = "id", length = 255, nullable = false)
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @ManyToOne
    @JoinColumn(nullable = false, name = "id_chat_room", referencedColumnName = "id", foreignKey = @ForeignKey(name = "fk_ai_chat_room_chat"))
    private AIChatRoom idChatRoom;

    @Column(name = "chat", nullable = false, columnDefinition="TEXT")
    private String chat;

    @Column(name = "is_bot", nullable = false)
    private Boolean isBot;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
}