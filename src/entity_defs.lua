ENTITY_DEF = {
    ['player'] = {
        walkSpeed = PLAYER_WALK_SPEED,
        animations = {
            ['walk-left'] = {
                frames = {5, 6}
                interval = 0.5
                texture = kvotheSpriteSheet
            }
            ['walk-right'] = {
                frames = {7, 8} --ADD THESE DIRECTION SPRITES TO THE ATLAS
                interval = 0.5
                texture = kvotheSpriteSheet
            }
            ['walk-up'] = {
                frames = {3, 4}
                interval = 0.5
                texture = kvotheSpriteSheet
            }
            ['walk-down'] = {
                frames = {1, 2}
                interval = 0.5
                texture = kvotheSpriteSheet
            }
        }
    }
    ['gecko'] = {
        animations = {
            frames = {1, 2, 3}
            interval = 0.5
            texture = --ADD THIS
        }
    }
}

