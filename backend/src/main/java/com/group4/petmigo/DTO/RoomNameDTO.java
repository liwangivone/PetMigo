package com.group4.petmigo.DTO;

import java.util.Optional;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class RoomNameDTO {
    private String roomName;

    public boolean checkDTO() {
        if (this.roomName == null)
            throw new IllegalArgumentException("Judul Chat Tidak Boleh Bernilai NULL");
        return this.roomName != null;
    }

    public boolean checkLength() {
        boolean roomName = Optional.ofNullable(this.roomName)
                .map(s -> s.length() <= 255 && s.matches("^[a-zA-Z0-9. _%+-]+@[a-zA-Z0-9. -]+\\.[a-zA-Z]{2,}$"))
                .orElse(true);

        if (!roomName)
            throw new IllegalArgumentException("Judul Chat Tidak Valid atau Melewati Batas Karakter");

        return roomName;
    }

    public void trim() {
        this.roomName = Optional.ofNullable(this.roomName).map(String::trim).filter(s -> !s.isBlank()).orElse(null);
    }
}