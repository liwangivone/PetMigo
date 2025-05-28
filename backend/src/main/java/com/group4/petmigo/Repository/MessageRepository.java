package com.group4.petmigo.Repository;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.group4.petmigo.models.entities.Chat.Message;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long> {
}

