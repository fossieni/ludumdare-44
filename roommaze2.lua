local Roommaze2 = {}
Roommaze2.__index = Roommaze2

local Tilelayer = require 'tilelayer'
local Actor = require 'actor'

local levelData = require 'assets/test2'

function Roommaze2:init(bump)
    local room = {}
    setmetatable(room,Roommaze2)

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
   
    room.backgroundTiles = Tilelayer:init(
        levelData.layers[1].width, levelData.layers[1].height, levelData.layers[1].data,
        levelData.tilesets[1].tilewidth, levelData.tilesets[1].tileheight, "assets/tileset_01.png", levelData.tilesets[1].columns, CONFIG.renderer.scale)
    room.backgroundTiles:addTiledAnimations(anim2)
    room.backgroundTiles:addManualTileAnimations(anim)
    room.backgroundTiles:initCanvas()
    room.backgroundTiles.walls = {}
    room.doors = {}

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
    room.actors = {}

    local playerActor = Actor:init(16,16,"assets/tileset_01.png",16,CONFIG.renderer.scale)
    table.insert(room.actors, playerActor)

    return room
end

function Roommaze2:beginRoom()

end

function Roommaze2:revealDoors()
    for _, tile in pairs(self.backgroundTiles.tileMap) do
        if tile.index == 26 or tile.index == 27 or tile.index == 28 then
            tile.started = true
        end
    end
    self.doorsVisible = true
end

function Roommaze2:endRoom()
    for _, wall in pairs(self.walls) do
      bumpWorld.remove(wall)
    end
    for _, doors in pairs(self.doors) do
      bumpWorld.remove(doors)
    end
end


function Roommaze2:movePlayerActor(x, y)
    self.actors[1]:moveActor(x, y)
end

function Roommaze2:update(dt)
    self.backgroundTiles:update(dt)
    DEBUG_BUFFER = DEBUG_BUFFER.."ACTORS "..table.getn(self.actors).."\n"
    self.actors[1]:update(dt)
    for i, a in pairs(self.actors) do
        DEBUG_BUFFER = DEBUG_BUFFER.."---- "..i.." ("..a.pos.x..","..a.pos.y..")\n"
    end
    DEBUG_BUFFER = DEBUG_BUFFER.."DOORS "..table.getn(self.doors).."\n"
    for i, a in pairs(self.doors) do
        DEBUG_BUFFER = DEBUG_BUFFER.."---- "..i.." ("..a.x..","..a.y..")\n"
    end
end

function Roommaze2:draw()
    self.backgroundTiles:draw()
    self.actors[1]:draw()
end

return Roommaze2