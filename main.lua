
require 'globals'

States = {
    menu = require 'states.menu',
    game = require 'states.game',
    gameover = require 'states.gameover'
}

besttoday = 0

math.randomseed( os.time() )

function love.load()
    --love.window.setIcon(love.image.newImageData(CONFIG.window.icon))
    love.graphics.setDefaultFilter(CONFIG.renderer.filter.down, CONFIG.renderer.filter.up, 1)
    font = love.graphics.newImageFont("assets/font.png", " !\"#$%&\'()*+,-./0123456789:@ABCDEFGHIJKLMNOPQRSTUVWXYZ±abcdefghijklmnopqrstuvwxyz")
    local callbacks = {'update'}
    for k in pairs(love.handlers) do
        callbacks[#callbacks+1] = k
    end
    State.registerEvents(callbacks)

    State.switch(States.game)

end

function love.update(dt)
    if DEBUG then
        --DEBUG_BUFFER = DEBUG_BUFFER .. "BLAAAAAAAA\n"
    end
end


function love.draw()
    love.graphics.setFont(font)
    local t = love.timer.getTime()
    State.current():draw()
    local drawtime = love.timer.getTime() - t

    if DEBUG then
        love.graphics.push()
        --love.graphics.scale(CONFIG.renderer.scale, CONFIG.renderer.scale)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(DEBUG_BUFFER, 10, 30)
        love.graphics.print(tostring(love.timer.getFPS( )).." fps", 10, 20)
        love.graphics.pop()
        DEBUG_BUFFER = ""
    end
end