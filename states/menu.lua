
local menu = {}

local Inputmanager = require 'inputmanager'

inputManager = Inputmanager:init({{name="AAA"}})

function menu:init()

end

function menu:enter()

end

function menu:draw()
    love.graphics.push()
    love.graphics.scale(CONFIG.renderer.scale+2, CONFIG.renderer.scale+2)
    love.graphics.print("POWER AND LIGHT", (love.graphics.getWidth()/(CONFIG.renderer.scale+2)/2)-55, (love.graphics.getHeight()/(CONFIG.renderer.scale+2)/2)-40)
    love.graphics.pop()

    love.graphics.push()
    love.graphics.scale(CONFIG.renderer.scale+2, CONFIG.renderer.scale+2)
    love.graphics.print("PRESS ( SPACE ) TO CONTINUE", (love.graphics.getWidth()/(CONFIG.renderer.scale+2)/2)-90, (love.graphics.getHeight()/(CONFIG.renderer.scale+2)/2)+10)
    love.graphics.pop()

    love.graphics.push()
    love.graphics.scale(CONFIG.renderer.scale+2, CONFIG.renderer.scale+2)
    love.graphics.print("PRESS ( ESC ) TO QUIT", (love.graphics.getWidth()/(CONFIG.renderer.scale+2)/2)-70, (love.graphics.getHeight()/(CONFIG.renderer.scale+2)/2)+20)
    love.graphics.pop()
end

function menu:keyreleased(key)
    if inputManager.players[1].type == 2 and key == inputManager.players[1].controller.a then
        State.switch(States.game)
    elseif key == "escape" then
        love.event.quit()
    end
 end

function menu:exit()

end

return menu