ENTITY_DEFS = {
    ['player'] = {
        walkSpeed = PLAYER_WALK_SPEED,
        height = 16,
        width = 16,
        animations = {
            ['walk-left'] = {
                frames = {6, 5},
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
                frames = {4},
                interval = 0.3,
                texture = 'character-walk',
            },
            ['idle-down'] = {
                frames = {2},
                interval = 0.3,
                texture = 'character-walk',
            }
        }
    },
    ['gecko'] = {
        animations = {
            ['idle-up'] = {
                frames = {5},
                interval = 0.5,
                texture = 'gecko',
            },
            ['walk-up'] = {
                frames = {1, 2, 3, 4, 5},
                interval = 0.07,
                texture = 'gecko',
            },
        }
    }
}

