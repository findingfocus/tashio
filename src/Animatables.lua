Animatables = Class{}

function Animatables:init()
    FLOWER = 1012
    FLOWER = AnimSpitter(1012, 1015, 0.75)
end

function Animatables:update(dt)
    FLOWER:update(dt)
end
