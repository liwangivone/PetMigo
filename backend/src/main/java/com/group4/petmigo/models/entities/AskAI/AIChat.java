package com.group4.petmigo.models.entities.AskAI;

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

import lombok.Data;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Builder;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
@Table(name = "ai_chat")
public class AIChat {

    @Id
    @Column(name = "idChat", length = 255, nullable = false)
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @ManyToOne
    @JoinColumn(
        nullable = false, 
        name = "id_chat_room", 
        referencedColumnName = "id", 
        foreignKey = @ForeignKey(name = "fk_ai_chat_room_chat")
    )
    private AIChatRoom idChatRoom;

    @Column(name = "chat", nullable = false, columnDefinition = "TEXT")
    private String chat;

    @Column(name = "is_bot", nullable = false)
    private Boolean isBot;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
}
