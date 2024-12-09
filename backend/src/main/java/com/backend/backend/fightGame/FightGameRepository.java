package com.backend.backend.fightGame;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.backend.backend.fightGame.FightGame;

public interface FightGameRepository extends JpaRepository<FightGame, Long> {
    
}
