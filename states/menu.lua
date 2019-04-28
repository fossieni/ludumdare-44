
local menu = {}

local Inputmanager = require 'inputmanager'

inputManager = Inputmanager:init({{name="AAA"}})

function menu:init()

end

function menu:enter()

end

function menu:draw()
    love.graphics.push()
    love.graphics.scale(CONFIG.renderer.scale+1, CONFIG.renderer.scale+1)
    love.graphics.print("SUPER FANCY TITLE!!!!", (love.graphics.getWidth()/(CONFIG.renderer.scale+1)/2)-70, (love.graphics.getHeight()/(CONFIG.renderer.scale+1)/2)-40)
    love.graphics.pop()

    love.graphics.push()
    love.graphics.scale(CONFIG.renderer.scale, CONFIG.renderer.scale)
    love.graphics.print("PRESS [ button ] TO CONTINUE", (love.graphics.getWidth()/CONFIG.renderer.scale/2)-90, (love.graphics.getHeight()/CONFIG.renderer.scale/2)+10)
    love.graphics.pop()
end

function menu:keyreleased(key)
    if inputManager.players[1].type == 2 and key == inputManager.players[1].controller.a then
        State.switch(States.game)
    end
 end

function menu:exit()

end

return menu