local Roommaze = {}
Roommaze.__index = Roommaze

local Tilelayer = require 'tilelayer'
local Actor = require 'actor'

local levelData = require 'assets/test2'

function Roommaze:init(bump)
    local room = {}
    setmetatable(room,Roommaze)

    room.bumpWorld = bump


    local anim = {
        {index=33,speed=200,animation={0,1,2,3,4,5,6,7}},
    }
    local anim2 = {
        {
            id = 16,
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
    local walkable = { [9]=true, [54]=true, [55]=true, [56]=true, [57]=true}
   
    room.backgroundTiles = Tilelayer:init(
        levelData.layers[1].width, levelData.layers[1].height, levelData.layers[1].data,
        levelData.tilesets[1].tilewidth, levelData.tilesets[1].tileheight, "assets/tileset_01.png", levelData.tilesets[1].columns, CONFIG.renderer.scale)
        room.backgroundTiles:addTiledAnimations(anim2)
    --playMap:addManualTileAnimations(anim)
    room.backgroundTiles:initCanvas()
    room.backgroundTiles.walls = {}

    for i, tile in pairs(levelData.layers[1].data) do
        DEBUG_BUFFER = DEBUG_BUFFER.."["..i.."] "..tile
        if walkable[tile] == nil then
            DEBUG_BUFFER = DEBUG_BUFFER.."* "
            local wallx = ((i-1) % room.backgroundTiles.mapWidth) * room.backgroundTiles.tileWidth
            local wally = math.floor((i-1) / room.backgroundTiles.mapWidth) * room.backgroundTiles.tileHeight
            local wall = {x=wallx, y=wally, w=room.backgroundTiles.tileWidth, h=room.backgroundTiles.tileHeight, type=1}
            table.insert(room.backgroundTiles.walls, wall)
            room.bumpWorld:add(wall, wall.x, wall.y, wall.w, wall.h)
        end
    end

    room.showDoors = false
    room.actors = {}

    local playerSprite = Actor:init()
    table.insert(room.actors, playerSprite)

    return room
end

function Roommaze:beginRoom()

end

function Roommaze:movePlayerActor(x, y)
    DEBUG_BUFFER = DEBUG_BUFFER.."ACTORS "..table.getn(self.actors)
    -- for i, a in pairs(self.actors) do
    --     DEBUG_BUFFER = DEBUG_BUFFER.."----"..i.."-"..a.sprite.offsetX
    -- end
end

function Roommaze:update(dt)
    self.backgroundTiles:update(dt)
end

function Roommaze:draw()
    -- DRAW ALL THE ACTORS actors:draw()
    self.backgroundTiles:draw()
end

return Roommaze