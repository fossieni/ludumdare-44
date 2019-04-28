
local gameover = {}

local Inputmanager = require 'inputmanager'

inputManager = Inputmanager:init({
    {name="AAA"}
})

function gameover:init()

end

function gameover:enter()

end

function gameover:update(dt)

end

function gameover:draw()
    love.graphics.push()
    love.graphics.scale(CONFIG.renderer.scale+3, CONFIG.renderer.scale+3)
    love.graphics.print("GAME OVER", (love.graphics.getWidth()/(CONFIG.renderer.scale+3)/2)-30, (love.graphics.getHeight()/(CONFIG.renderer.scale+3)/2)-30)
    love.graphics.pop()

    love.graphics.push()
    love.graphics.scale(CONFIG.renderer.scale+1, CONFIG.renderer.scale+1)
    love.graphics.print("BEST THIS SESSION", (love.graphics.getWidth()/(CONFIG.renderer.scale+1)/2)-57, (love.graphics.getHeight()/(CONFIG.renderer.scale+1)/2-10))
    love.graphics.pop()

    love.graphics.push()
    love.graphics.scale(CONFIG.renderer.scale+2, CONFIG.renderer.scale+2)
    love.graphics.print(besttoday, (love.graphics.getWidth()/(CONFIG.renderer.scale+2)/2)+2, (love.graphics.getHeight()/(CONFIG.renderer.scale+2)/2+2))
    love.graphics.pop()

    love.graphics.push()
    love.graphics.scale(CONFIG.renderer.scale+1, CONFIG.renderer.scale+1)
    love.graphics.print("PRESS ( SPACE ) TO CONTINUE", (love.graphics.getWidth()/(CONFIG.renderer.scale+1)/2-85), (love.graphics.getHeight()/(CONFIG.renderer.scale+1)/2)+50)
    love.graphics.pop()
end

function gameover:keyreleased(key)
    if inputManager.players[1].type == 2 and key == inputManager.players[1].controller.a then
        State.switch(States.menu)
    elseif key == "escape" then
        love.event.quit()
    end
 end

function gameover:exit()

end

return gameover