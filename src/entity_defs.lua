ENTITY_DEFS = {
    ['player'] = {
        walkSpeed = PLAYER_WALK_SPEED,
        animations = {
            ['walk-left'] = {
                frames = {5, 6},
                interval = 0.3,
                texture = 'character-walk',
            },
            ['walk-right'] = {
                frames = {7, 8}, --ADD THESE DIRECTION SPRITES TO THE ATLAS
                interval = 0.3,
                texture = 'character-walk',
            },
            ['walk-up'] = {
                frames = {3, 4},
                interval = 0.3,
                texture = 'character-walk',
            },
            ['walk-down'] = {
                frames = {1, 2},
                interval = 0.3,
                texture = 'character-walk',
            },
            ['idle-left'] = {
                frames = {5},
                interval = 0.3,
                texture = 'character-walk',
            },
            ['idle-right'] = {
                frames = {8},
                interval = 0.3,
                texture = 'character-walk',
            },
            ['idle-up'] = {
                frames = {3},
                interval = 0.3,
                texture = 'character-walk',
            },
            ['idle-down'] = {
                frames = {1},
                interval = 0.3,
                texture = 'character-walk',
            }
        }
    },
    ['gecko'] = {
        animations = {
            frames = {1, 2, 3},
            interval = 0.5,
            --texture = --ADD THIS
        }
    }
}

