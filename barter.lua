local Barter = {}
Barter.__index = Barter

function Barter:init(choices, scale)
    local menu = {}
    setmetatable(menu,Barter)

    menu.pos = {x=0, y=0}
    menu.scaleX = scale+2
    menu.scaleY = scale+2

    menu.selected = 1
    menu.selectiontimer = 0
    menu.choices = choices or {text="NOTHING", cost=0, light=0}

    return menu
end

function Barter:update(dt)
    self.selectiontimer = self.selectiontimer + dt * 1000
end

function Barter:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.push()
    love.graphics.scale(self.scaleX, self.scaleY)

    love.graphics.print("I NEED OIL! BRING ME OIL AND I WILL LET YOU OUT... BUT", -70, -10)
    love.graphics.print("IT'S DANGEROUS TO GO ALONE. YOU SHOULD BUY SOMETHING!", -70, 0)
    love.graphics.print("IT WILL ONLY COST YOU YOUR LIFE, BUY NOW WITH ( SPACE )", -70, 10)
    for i, text in pairs(self.choices) do
        love.graphics.print(text.text, 0, i*10+40)
        if self.selected == i then
            love.graphics.print("+", -20, i*10+40)
        end
    end
    love.graphics.pop()
end

return Barter