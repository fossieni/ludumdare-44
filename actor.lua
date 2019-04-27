local Actor = {}
Actor.__index = Actor

local Tilelayer = require 'tilelayer'

function Actor:init()
    local actor = {}
    setmetatable(actor,Actor)

    local anim = {
        {index=1,speed=200,animation={0,1,2,3,4,5,6,7}},
    }
    actor.sprite = Tilelayer:init(1, 1, {1},
        16, 16, "assets/tileset_01.png", 10)
    actor.sprite:addManualTileAnimations(anim)
    actor.sprite:initCanvas()

    return actor
end

function Actor:moveActor(x,y)
    self.sprite.offsetX = x
    self.sprite.offsetY = y
end

function Actor:update(dt)
    self.sprite:update(dt)
end

function Actor:draw()
    self.sprite:draw()
end

return Actor