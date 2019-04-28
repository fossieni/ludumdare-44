local Roommaze = {}
Roommaze.__index = Roommaze

local Tilelayer = require 'tilelayer'
local Actor = require 'actor'
local Barter = require 'barter'

local levelData = require 'assets/NewMap'

function Roommaze:init(bump)
    local room = {}
    setmetatable(room,Roommaze)

    room.bumpWorld = bump

    local anim = {
        {index=26,started=false,looping=false,speed=200,animation={18,27,18,27,18,27,18,27}},
        {index=27,started=false,looping=false,speed=200,animation={18,28,18,28,18,28,18,28}},
        {index=28,started=false,looping=false,speed=200,animation={18,29,18,29,18,29,18,29}},
    }

    room.walk = {4,5,14,15,24,25,34,35}

    local walkable = {}
    for _, i in pairs(room.walk) do
        walkable[i] = true
    end

    room:addMazeToData(10, 6, 1, 4, levelData.layers[1].data)

    room.backgroundTiles = Tilelayer:init(
        levelData.layers[1].width, levelData.layers[1].height, levelData.layers[1].data,
        levelData.tilesets[1].tilewidth, levelData.tilesets[1].tileheight, "assets/NewTileset.png", levelData.tilesets[1].columns, CONFIG.renderer.scale)
    room.backgroundTiles:addTiledAnimations(levelData.tilesets[1].tiles)
    --room.backgroundTiles:addManualTileAnimations()
    room.backgroundTiles:initCanvas()
    room.backgroundTiles.walls = {}
    room.doors = {}

    local file = "assets/wolframTones_ambiance_0"..math.random(1,5)..".mp3"
    room.music = love.audio.newSource(file, "stream")
    room.music:setLooping(true)
    room.music:play()

    players[1].drain = math.random(50,100)/100

    room.offsetX = (love.graphics.getWidth()/2) - (levelData.layers[1].width*levelData.tilesets[1].tilewidth*CONFIG.renderer.scale/2)
    room.offsetY = (love.graphics.getHeight()/2) - (levelData.layers[1].height*levelData.tilesets[1].tileheight*CONFIG.renderer.scale/2)

    for i, tile in pairs(levelData.layers[1].data) do
        if tile == 2 then
            local doorx = ((i-1) % room.backgroundTiles.mapWidth) * room.backgroundTiles.tileWidth
            local doory = math.floor((i-1) / room.backgroundTiles.mapWidth) * room.backgroundTiles.tileHeight
            local door = {x=doorx, y=doory, w=room.backgroundTiles.tileWidth, h=room.backgroundTiles.tileHeight, type=10}
            table.insert(room.doors, door)
            room.bumpWorld:add(door, door.x, door.y, door.w, door.h)
        elseif walkable[tile] == nil and tile ~= 12 then
            local wallx = ((i-1) % room.backgroundTiles.mapWidth) * room.backgroundTiles.tileWidth
            local wally = math.floor((i-1) / room.backgroundTiles.mapWidth) * room.backgroundTiles.tileHeight
            local wall = {x=wallx, y=wally, w=room.backgroundTiles.tileWidth, h=room.backgroundTiles.tileHeight, type=1}
            table.insert(room.backgroundTiles.walls, wall)
            room.bumpWorld:add(wall, wall.x, wall.y, wall.w, wall.h)
        end
    end

    room.doorsVisible = false
    room.barter = true
    room.menu = Barter:init({
      {text="NOTHING", cost=0, light=0},
      {text="A LIGHT BULB            25 POWER", cost=25, light=20},
      {text="A BIG LIGHT BULB        50 POWER", cost=50, light=50},
    }, CONFIG.renderer.scale)
    room.actors = {}

    local playerActor = Actor:init(32,32,"assets/Sprite-0007.png",8,{{time=0, speed=200, frame=1, animation={0,4}},{time=0, speed=200, frame=1, animation={1,5}},{time=0, speed=200, frame=1, animation={2,6}},{time=0, speed=200, frame=1, animation={3,7}}},CONFIG.renderer.scale)
    local devadv = Actor:init(32,32,"assets/BadchickenRobot.png",8,{{time=0, speed=200, frame=1, animation={0,4}},{time=0, speed=200, frame=1, animation={1,5}},{time=0, speed=200, frame=1, animation={2,6}},{time=0, speed=200, frame=1, animation={3,7}}},CONFIG.renderer.scale)
    local battery1 = Actor:init(32,32,"assets/Sprite-0001.png",8,{{time=0, speed=200, frame=1, animation={0,1}}},CONFIG.renderer.scale)
    local battery2 = Actor:init(32,32,"assets/Sprite-0001.png",8,{{time=0, speed=200, frame=1, animation={0,1}}},CONFIG.renderer.scale)
    local battery3 = Actor:init(32,32,"assets/Sprite-0001.png",8,{{time=0, speed=200, frame=1, animation={0,1}}},CONFIG.renderer.scale)
    local oil = Actor:init(32,32,"assets/Sprite-0002.png",8,{{time=0, speed=200, frame=1, animation={0,1}}},CONFIG.renderer.scale)
    table.insert(room.actors, playerActor)
    table.insert(room.actors, devadv)
    table.insert(room.actors, battery1)
    table.insert(room.actors, battery2)
    table.insert(room.actors, battery3)
    table.insert(room.actors, oil)

    for i, thing in pairs(room.actors) do
        if i > 2 then
            local tilei = 1
            repeat
                tilei = math.random(1, #levelData.layers[1].data)
            until walkable[levelData.layers[1].data[tilei]]
            local bx = ((tilei-1) % room.backgroundTiles.mapWidth)*room.backgroundTiles.tileWidth+3
            local by = math.floor((tilei-1)/room.backgroundTiles.mapWidth)*room.backgroundTiles.tileHeight+3
            thing:moveActor(bx, by)
            local bthing = {x=bx, y=by, w=room.backgroundTiles.tileWidth, h=room.backgroundTiles.tileHeight, type=2, obj=thing}
            if i == #room.actors then
                bthing.type = 9
            end
            room.bumpWorld:add(bthing, bthing.x, bthing.y, bthing.w, bthing.h)
        end
    end

    room.actors[1]:moveActor(room.backgroundTiles.tileWidth*10+3, room.backgroundTiles.tileHeight*13+3)
    room.actors[2]:moveActor(room.backgroundTiles.tileWidth*10+3, room.backgroundTiles.tileHeight*8)

    return room
end

function Roommaze:barterChoosen()
    self.barter = false
    return self.menu.choices[self.menu.selected].cost, self.menu.choices[self.menu.selected].light
end

function Roommaze:revealDoors()
    for _, tile in pairs(self.backgroundTiles.tileMap) do
        if tile.animation and tile.started == false then
            tile.started = true
        end
    end
    self.doorsVisible = true
end

function Roommaze:endRoom()
    local items, len = self.bumpWorld:getItems()
    for _, thing in pairs(items) do
        if thing.type ~= 0 then
            self.bumpWorld:remove(thing)
        end
    end
    self.music:stop()
    levels[levelIndex+1] = RoomMaze
end

function Roommaze:addMazeToData(w, h, ofsx, ofsy, data)
    function initialize_grid(w, h)
        local a = {}
        for i = 1, h do
          table.insert(a, {})
          for j = 1, w do
            table.insert(a[i], true)
          end
        end
        return a
    end
    function shuffle(t)
        for i = 1, #t - 1 do
          local r = math.random(i, #t)
          t[i], t[r] = t[r], t[i]
        end
    end
    function avg(a, b)
        return (a + b) / 2
    end
    local map = initialize_grid(w*2+1, h*2+1)
    local dirs = {
        {x = 0, y = -2}, -- north
        {x = 2, y = 0}, -- east
        {x = -2, y = 0}, -- west
        {x = 0, y = 2}, -- south
    }

    function walk(x, y)
      map[y][x] = false
   
      local d = { 1, 2, 3, 4 }
      shuffle(d)
      for i, dirnum in ipairs(d) do
        local xx = x + dirs[dirnum].x
        local yy = y + dirs[dirnum].y
        if map[yy] and map[yy][xx] then
          map[avg(y, yy)][avg(x, xx)] = false
          walk(xx, yy)
        end
      end
    end
   
    walk(math.random(1, w)*2, math.random(1, h)*2)

    DEBUG_BUFFER = DEBUG_BUFFER.."W "..w.."\n"
    DEBUG_BUFFER = DEBUG_BUFFER.."H "..h.."\n"

    map[2][4] = false
    map[2][9] = false
    map[2][13] = false
    map[2][18] = false

    map[12][10] = false
    map[12][11] = false
    map[12][12] = false


    for i = 2, h*2 do
        for j = 2, w*2 do
          if map[i][j] then
            DEBUG_BUFFER = DEBUG_BUFFER.."X"
            data[(i+ofsy-3)*21+j+ofsx-1] = 1
          else
            DEBUG_BUFFER = DEBUG_BUFFER.." "

            data[(i+ofsy-3)*21+j+ofsx-1] = self.walk[math.random(1, #self.walk)]
          end
        end
        DEBUG_BUFFER = DEBUG_BUFFER.."\n"
    end
end

function Roommaze:movePlayerActor(x, y)
    self.actors[1]:moveActor(x, y)
end

function Roommaze:update(dt)
    self.backgroundTiles:update(dt)
    self.menu:update(dt)
    DEBUG_BUFFER = DEBUG_BUFFER.."ACTORS "..table.getn(self.actors).."\n"
    for i, a in pairs(self.actors) do
        DEBUG_BUFFER = DEBUG_BUFFER.."---- "..i.." ("..a.pos.x..","..a.pos.y..")\n"
        a:update(dt)
    end
    DEBUG_BUFFER = DEBUG_BUFFER.."DOORS "..table.getn(self.doors).."\n"
    for i, a in pairs(self.doors) do
        DEBUG_BUFFER = DEBUG_BUFFER.."---- "..i.." ("..a.x..","..a.y..")\n"
    end
    DEBUG_BUFFER = DEBUG_BUFFER.."BUMPOBJECTS "..self.bumpWorld:countItems().."\n"
end

function Roommaze:draw()
    love.graphics.push()
    love.graphics.translate(self.offsetX, self.offsetY)


    if self.barter == true then
        self.menu:draw()
        self.actors[2]:draw()
        love.graphics.pop()
    else
        love.graphics.setColor(1,1,1)
        love.graphics.setBlendMode("add") 
        love.graphics.circle("fill", self.actors[1].pos.x+16, self.actors[1].pos.y+16, players[1].power+players[1].light*10)
        love.graphics.setBlendMode("multiply", "premultiplied")

        self.backgroundTiles:draw()
        love.graphics.setBlendMode("alpha")
        for i, thing in pairs(self.actors) do
            if i > 2 then
                thing:draw()
            end
        end

        love.graphics.setBlendMode("alpha")
        love.graphics.pop()
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight()/2 - levelData.layers[1].height*levelData.tilesets[1].tileheight/2)
        love.graphics.rectangle("fill", 0, love.graphics.getHeight()/2 + levelData.layers[1].height*levelData.tilesets[1].tileheight/2, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.rectangle("fill", love.graphics.getWidth()/2+levelData.layers[1].width*levelData.tilesets[1].tilewidth/2, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth()/2-levelData.layers[1].width*levelData.tilesets[1].tilewidth/2, love.graphics.getHeight())

    end

    love.graphics.push()
    love.graphics.translate(self.offsetX, self.offsetY)
    self.actors[1]:draw()
    love.graphics.pop()
end

return Roommaze