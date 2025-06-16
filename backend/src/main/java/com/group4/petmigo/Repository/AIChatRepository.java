package com.group4.petmigo.Repository;

import com.group4.petmigo.models.entities.AskAI.AIChat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AIChatRepository extends JpaRepository<AIChat, String> {
}