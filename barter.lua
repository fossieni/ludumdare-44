local Barter = {}
Barter.__index = Barter

function Barter:init(w, h, tileSetFile, tileSetModulo, scale)
    local menu = {}
    setmetatable(menu,Barter)

    menu.pos = {x=0, y=0}
    menu.scaleX = scale
    menu.scaleY = scale

    return menu
end

function Barter:update(dt)
end

function Barter:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.push()
    love.graphics.scale(self.scaleX, self.scaleY)
    love.graphics.draw(self.canvas, self.pos.x+self.pos.offsetX, self.pos.y+self.pos.offsetY)
    love.graphics.pop()
end

return Barter