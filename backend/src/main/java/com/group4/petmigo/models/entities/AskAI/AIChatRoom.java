package com.group4.petmigo.models.entities.AskAI;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.Set;
import java.util.List;
import java.util.stream.Collectors;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.group4.petmigo.models.entities.User.User;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.ForeignKey;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.PrePersist;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import lombok.Data;

@Data
@Entity
public class AIChatRoom {

    @Id
    @Column(name = "id", length = 255, nullable = false)
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;    @ManyToOne
    @JoinColumn(nullable = false, name = "id_user", referencedColumnName = "user_id", foreignKey = @ForeignKey(name = "fk_ai_chat_room_user"))
    @JsonIgnore  // Prevent circular reference
    private User userid;

    @Column(name = "title", length = 255, nullable = false)
    private String title = "New Chat"; 

    @Column(name = "deleted_at", nullable = true)
    private LocalDate deletedAt;

    @Column(name = "created_at", nullable = false)
    private LocalDate createdAt;

    @Column(name = "edited_at", nullable = false)
    private LocalDate editedAt;

    @OneToMany(mappedBy = "idChatRoom", cascade = CascadeType.ALL)
    private Set<AIChat> aiChats;

    public LocalDateTime getLastChatDateTime() {
        if (aiChats == null || aiChats.isEmpty()) {
            return createdAt.atStartOfDay(); // Return creation time as LocalDateTime if no chats
        }
        return aiChats.stream()
                .map(AIChat::getCreatedAt)
                .max(LocalDateTime::compareTo)
                .orElse(createdAt.atStartOfDay());
    }

    public AIChat getLastChat() {
        if (aiChats == null || aiChats.isEmpty()) {
            return null;
        }
        List<AIChat> aiChatList = aiChats.stream()
                .sorted(Comparator.comparing(AIChat::getCreatedAt))
                .collect(Collectors.toList());
        return aiChatList.get(aiChatList.size() - 1);
    }

    @PrePersist
    private void setDefaultValues() {
        if (this.title == null || this.title.trim().isEmpty()) {
            this.title = "Chat Room - " + java.time.LocalDateTime.now().format(
                java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")
            );
        }
        if (this.createdAt == null) {
            this.createdAt = LocalDate.now();
        }
        if (this.editedAt == null) {
            this.editedAt = LocalDate.now();
        }
    }
}