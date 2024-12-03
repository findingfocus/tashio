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
                looping = true
            },
            ['walk-right'] = {
                frames = {7, 8}, --ADD THESE DIRECTION SPRITES TO THE ATLAS
                interval = 0.3,
                texture = 'character-walk',
                looping = true
            },
            ['walk-up'] = {
                frames = {3, 4},
                interval = 0.3,
                texture = 'character-walk',
                looping = true
            },
            ['walk-down'] = {
                frames = {1, 2},
                interval = 0.3,
                texture = 'character-walk',
                looping = true
            },
            ['idle-left'] = {
                frames = {5},
                interval = 0.3,
                texture = 'character-walk',
                looping = true
            },
            ['idle-right'] = {
                frames = {8},
                interval = 0.3,
                texture = 'character-walk',
                looping = true
            },
            ['idle-up'] = {
                frames = {4},
                interval = 0.3,
                texture = 'character-walk',
                looping = true
            },
            ['idle-down'] = {
                frames = {2},
                interval = 0.3,
                texture = 'character-walk',
                looping = true
            },
            ['falling'] = {
                frames = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
                interval = 0.1,
                texture = 'character-fall',
                looping = false
            },
            ['push-down'] = {
                frames = {1, 2},
                interval = 0.3,
                texture = 'character-push',
                looping = true
            },
            ['push-up'] = {
                frames = {3, 4},
                interval = 0.3,
                texture = 'character-push',
                looping = true
            },
            ['push-left'] = {
                frames = {5, 6},
                interval = 0.3,
                texture = 'character-push',
                looping = true
            },
            ['push-right'] = {
                frames = {7, 8},
                interval = 0.3,
                texture = 'character-push',
                looping = true
            },
        }
    },
    ['character-element'] = {
        animations = {
            ['walk-left'] = {
                frames = {6, 5},
                interval = 0.3,
                texture = 'character-element',
                looping = true
            },
            ['walk-right'] = {
                frames = {7, 8}, --ADD THESE DIRECTION SPRITES TO THE ATLAS
                interval = 0.3,
                texture = 'character-element',
                looping = true
            },
            ['walk-up'] = {
                frames = {3, 4},
                interval = 0.3,
                texture = 'character-element',
                looping = true
            },
            ['walk-down'] = {
                frames = {1, 2},
                interval = 0.3,
                texture = 'character-element',
                looping = true
            },
            ['idle-left'] = {
                frames = {5},
                interval = 0.3,
                texture = 'character-element',
                looping = true
            },
            ['idle-right'] = {
                frames = {8},
                interval = 0.3,
                texture = 'character-element',
                looping = true
            },
            ['idle-up'] = {
                frames = {4},
                interval = 0.3,
                texture = 'character-element',
                looping = true
            },
            ['idle-down'] = {
                frames = {2},
                interval = 0.3,
                texture = 'character-element',
                looping = true
            },
        }
    },
    ['villager1'] = {
        walkSpeed = PLAYER_WALK_SPEED / 2,
        height = 16,
        width = 16,
        animations = {
            ['walk-left'] = {
                frames = {6, 5},
                interval = 0.3,
                texture = 'villager1-walk',
                looping = true
            },
            ['walk-right'] = {
                frames = {7, 8},
                interval = 0.3,
                texture = 'villager1-walk',
                looping = true
            },
            ['walk-up'] = {
                frames = {3, 4},
                interval = 0.3,
                texture = 'villager1-walk',
                looping = true
            },
            ['walk-down'] = {
                frames = {1, 2},
                interval = 0.3,
                texture = 'villager1-walk',
                looping = true
            },
            ['idle-left'] = {
                frames = {5},
                interval = 0.3,
                texture = 'villager1-walk',
                looping = true
            },
            ['idle-right'] = {
                frames = {8},
                interval = 0.3,
                texture = 'villager1-walk',
                looping = true
            },
            ['idle-up'] = {
                frames = {4},
                interval = 0.3,
                texture = 'villager1-walk',
                looping = true
            },
            ['idle-down'] = {
                frames = {2},
                interval = 0.3,
                texture = 'villager1-walk',
                looping = true
            },
        }
    },
    ['mage'] = {
        walkSpeed = PLAYER_WALK_SPEED / 2,
        height = 16,
        width = 16,
        animations = {
            ['walk-left'] = {
                frames = {6, 5},
                interval = 0.3,
                texture = 'mage-walk',
                looping = true
            },
            ['walk-right'] = {
                frames = {7, 8},
                interval = 0.3,
                texture = 'mage-walk',
                looping = true
            },
            ['walk-up'] = {
                frames = {3, 4},
                interval = 0.3,
                texture = 'mage-walk',
                looping = true
            },
            ['walk-down'] = {
                frames = {1, 2},
                interval = 0.3,
                texture = 'mage-walk',
                looping = true
            },
            ['idle-left'] = {
                frames = {5},
                interval = 0.3,
                texture = 'mage-walk',
                looping = true
            },
            ['idle-right'] = {
                frames = {8},
                interval = 0.3,
                texture = 'mage-walk',
                looping = true
            },
            ['idle-up'] = {
                frames = {4},
                interval = 0.3,
                texture = 'mage-walk',
                looping = true
            },
            ['idle-down'] = {
                frames = {2},
                interval = 0.3,
                texture = 'mage-walk',
                looping = true
            },
        }
    },
    ['spellcast'] = {
        animations = {
            ['flame'] = {
                frames = {1, 2, 3, 4, 5},
                interval = 0.1,
                texture = 'flame',
                looping = true
            },
        },
    },
    ['gecko'] = {
        animations = {
            ['idle-up'] = {
                frames = {5},
                interval = 0.5,
                texture = 'gecko',
                looping = true
            },
            ['idle-left'] = {
                frames = {10},
                interval = 0.5,
                texture = 'gecko',
                looping = true
            },
            ['idle-down'] = {
                frames = {15},
                interval = 0.5,
                texture = 'gecko',
                looping = true
            },
            ['idle-right'] = {
                frames = {20},
                interval = 0.5,
                texture = 'gecko',
                looping = true
            },
            ['walk-up'] = {
                frames = {1, 2, 3, 4, 5},
                interval = 0.07,
                texture = 'gecko',
                looping = true
            },
            ['walk-down'] = {
                frames = {11, 12, 13, 14, 15},
                interval = 0.07,
                texture = 'gecko',
                looping = true
            },
            ['walk-left'] = {
                frames = {6, 7, 8, 9, 10},
                interval = 0.07,
                texture = 'gecko',
                looping = true
            },
            ['walk-right'] = {
                frames = {16, 17, 18, 19, 20},
                interval = 0.07,
                texture = 'gecko',
                looping = true
            },
        }
    },
    ['geckoC'] = {
        animations = {
            ['idle-up'] = {
                frames = {5},
                interval = 0.5,
                texture = 'geckoC',
                looping = true
            },
            ['idle-left'] = {
                frames = {10},
                interval = 0.5,
                texture = 'geckoC',
                looping = true
            },
            ['idle-down'] = {
                frames = {15},
                interval = 0.5,
                texture = 'geckoC',
                looping = true
            },
            ['idle-right'] = {
                frames = {20},
                interval = 0.5,
                texture = 'geckoC',
                looping = true
            },
            ['walk-up'] = {
                frames = {1, 2, 3, 4, 5},
                interval = 0.07,
                texture = 'geckoC',
                looping = true
            },
            ['walk-down'] = {
                frames = {11, 12, 13, 14, 15},
                interval = 0.07,
                texture = 'geckoC',
                looping = true
            },
            ['walk-left'] = {
                frames = {6, 7, 8, 9, 10},
                interval = 0.07,
                texture = 'geckoC',
                looping = true
            },
            ['walk-right'] = {
                frames = {16, 17, 18, 19, 20},
                interval = 0.07,
                texture = 'geckoC',
                looping = true
            },
        }
    }
}

