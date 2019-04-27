local Roommaze = {}
Roommaze.__index = Roommaze

local Tilelayer = require 'tilelayer'
local Actor = require 'actor'

local levelData = require 'assets/untitled'

function Roommaze:init(bump)
    local room = {}
    setmetatable(room,Roommaze)

    room.bumpWorld = bump

    local anim = {
        {index=26,started=false,looping=false,speed=200,animation={18,27,18,27,18,27,18,27}},
        {index=27,started=false,looping=false,speed=200,animation={18,28,18,28,18,28,18,28}},
        {index=28,started=false,looping=false,speed=200,animation={18,29,18,29,18,29,18,29}},
    }
    local anim2 = {
        {
            id = 17,
            started=true,
            looping=true,
            animation = {
              {
                tileid = 0,
                duration = 100
              },
              {
                tileid = 1,
                duration = 100
              },
              {
                tileid = 2,
                duration = 100
              },
              {
                tileid = 19,
                duration = 100
              },
              {
                tileid = 21,
                duration = 100
              }
            }
        },
    }
    local walkable = {[35]=true}
   
    --room.effect = love.graphics.newShader("light.glsl")

    room.backgroundTiles = Tilelayer:init(
        levelData.layers[1].width, levelData.layers[1].height, levelData.layers[1].data,
        levelData.tilesets[1].tilewidth, levelData.tilesets[1].tileheight, "assets/tileset_01.png", levelData.tilesets[1].columns, CONFIG.renderer.scale)
    room.backgroundTiles:addTiledAnimations(anim2)
    room.backgroundTiles:addManualTileAnimations(anim)
    room.backgroundTiles:initCanvas()
    room.backgroundTiles.walls = {}
    room.doors = {}

    room.offsetX = (love.graphics.getWidth()/2) - (levelData.layers[1].width*levelData.tilesets[1].tilewidth*CONFIG.renderer.scale/2)
    room.offsetY = (love.graphics.getHeight()/2) - (levelData.layers[1].height*levelData.tilesets[1].tileheight*CONFIG.renderer.scale/2)

    for i, tile in pairs(levelData.layers[1].data) do
        if tile == 27 then
            local doorx = ((i-1) % room.backgroundTiles.mapWidth) * room.backgroundTiles.tileWidth
            local doory = math.floor((i-1) / room.backgroundTiles.mapWidth) * room.backgroundTiles.tileHeight
            local door = {x=doorx, y=doory, w=room.backgroundTiles.tileWidth, h=room.backgroundTiles.tileHeight, type=10}
            table.insert(room.doors, door)
            room.bumpWorld:add(door, door.x, door.y, door.w, door.h)
        elseif tile == 28 then
            local doorx = ((i-1) % room.backgroundTiles.mapWidth) * room.backgroundTiles.tileWidth
            local doory = math.floor((i-1) / room.backgroundTiles.mapWidth) * room.backgroundTiles.tileHeight
            local door = {x=doorx, y=doory, w=room.backgroundTiles.tileWidth, h=room.backgroundTiles.tileHeight, type=11}
            table.insert(room.doors, door)
            room.bumpWorld:add(door, door.x, door.y, door.w, door.h)
        elseif tile == 29 then
            local doorx = ((i-1) % room.backgroundTiles.mapWidth) * room.backgroundTiles.tileWidth
            local doory = math.floor((i-1) / room.backgroundTiles.mapWidth) * room.backgroundTiles.tileHeight
            local door = {x=doorx, y=doory, w=room.backgroundTiles.tileWidth, h=room.backgroundTiles.tileHeight, type=12}
            table.insert(room.doors, door)
            room.bumpWorld:add(door, door.x, door.y, door.w, door.h)
        elseif walkable[tile] == nil then
            local wallx = ((i-1) % room.backgroundTiles.mapWidth) * room.backgroundTiles.tileWidth
            local wally = math.floor((i-1) / room.backgroundTiles.mapWidth) * room.backgroundTiles.tileHeight
            local wall = {x=wallx, y=wally, w=room.backgroundTiles.tileWidth, h=room.backgroundTiles.tileHeight, type=1}
            table.insert(room.backgroundTiles.walls, wall)
            room.bumpWorld:add(wall, wall.x, wall.y, wall.w, wall.h)
        end
    end

    room.doorsVisible = false
    room.barter = true
    room.actors = {}

    local playerActor = Actor:init(16,16,"assets/tileset_01.png",16,CONFIG.renderer.scale)
    local devadv = Actor:init(16,16,"assets/tileset_01.png",16,CONFIG.renderer.scale)
    table.insert(room.actors, playerActor)
    table.insert(room.actors, devadv)
    room.actors[1]:moveActor(room.backgroundTiles.tileWidth*4+3, room.backgroundTiles.tileHeight*8+3)
    room.actors[2]:moveActor(room.backgroundTiles.tileWidth*4, room.backgroundTiles.tileHeight*5)

    return room
end

function Roommaze:barterChoosen()
    self.barter = false
end

function Roommaze:revealDoors()
    for _, tile in pairs(self.backgroundTiles.tileMap) do
        if tile.index == 26 or tile.index == 27 or tile.index == 28 then
            tile.started = true
        end
    end
    self.doorsVisible = true
end

function Roommaze:endRoom()
    for _, wall in pairs(self.walls) do
      bumpWorld.remove(wall)
    end
    for _, doors in pairs(self.doors) do
      bumpWorld.remove(doors)
    end
end


function Roommaze:movePlayerActor(x, y)
    self.actors[1]:moveActor(x, y)
end

function Roommaze:update(dt)
    self.backgroundTiles:update(dt)
    DEBUG_BUFFER = DEBUG_BUFFER.."ACTORS "..table.getn(self.actors).."\n"
    self.actors[1]:update(dt)
    self.actors[2]:update(dt)
    for i, a in pairs(self.actors) do
        DEBUG_BUFFER = DEBUG_BUFFER.."---- "..i.." ("..a.pos.x..","..a.pos.y..")\n"
    end
    DEBUG_BUFFER = DEBUG_BUFFER.."DOORS "..table.getn(self.doors).."\n"
    for i, a in pairs(self.doors) do
        DEBUG_BUFFER = DEBUG_BUFFER.."---- "..i.." ("..a.x..","..a.y..")\n"
    end
end

function Roommaze:draw()
    love.graphics.push()
    love.graphics.translate(self.offsetX, self.offsetY)

    --effect:send("diffuse", stump_diffuse)
    if self.barter == true then
        --DRAW all the menu stuff
        self.actors[2]:draw()
    else
        self.backgroundTiles:draw()
    end

    self.actors[1]:draw()

    love.graphics.pop()
end

return Roommaze