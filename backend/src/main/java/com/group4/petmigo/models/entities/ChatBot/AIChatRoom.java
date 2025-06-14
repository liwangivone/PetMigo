package com.group4.petmigo.models.entities.ChatBot;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.Set;
import java.util.List;
import java.util.stream.Collectors;

import com.group4.petmigo.models.entities.User.User;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.ForeignKey;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Table;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import lombok.Setter;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Setter
@Getter
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "ai_chat_room")
public class AIChatRoom {

    @Id
    @Column(name = "id", length = 255, nullable = false)
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;    @ManyToOne
    @JoinColumn(nullable = false, name = "id_user", referencedColumnName = "user_id", foreignKey = @ForeignKey(name = "fk_ai_chat_room_user"))
    private User idUser;

    @Column(name = "judul_chat", length = 255, nullable = false)
    private String judulChat;

    @Column(name = "deleted_at", nullable = true)
    private LocalDate deletedAt;

    @Column(name = "created_at", nullable = false)
    private LocalDate createdAt;

    @Column(name = "edited_at", nullable = false)
    private LocalDate editedAt;

    @OneToMany(mappedBy = "idChatRoom", cascade = CascadeType.ALL)
    private Set<AIChat> aiChats;

    public LocalDateTime getLastChatDateTime() {
        return aiChats.stream()
                .map(AIChat::getCreatedAt)
                .max(LocalDateTime::compareTo).get();
    }

    public AIChat getLastChat() {
        List<AIChat> aiChatList = aiChats.stream()
                .sorted(Comparator.comparing(AIChat::getCreatedAt))
                .collect(Collectors.toList());
        return aiChatList.get(aiChatList.size() - 1);
    }
}