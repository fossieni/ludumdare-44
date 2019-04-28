return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.3",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 21,
  height = 15,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 2,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "NewTileset",
      firstgid = 1,
      filename = "NewTileset.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 10,
      image = "NewTileset.png",
      imagewidth = 320,
      imageheight = 384,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 120,
      tiles = {
        {
          id = 1,
          animation = {
            {
              tileid = 1,
              duration = 100
            },
            {
              tileid = 21,
              duration = 100
            },
            {
              tileid = 41,
              duration = 100
            },
            {
              tileid = 61,
              duration = 100
            }
          }
        },
        {
          id = 11,
          animation = {
            {
              tileid = 11,
              duration = 100
            },
            {
              tileid = 31,
              duration = 100
            },
            {
              tileid = 51,
              duration = 100
            },
            {
              tileid = 71,
              duration = 100
            }
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 1,
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 21,
      height = 15,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        81, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 82, 83,
        91, 44, 1, 2, 3, 44, 44, 1, 2, 3, 44, 1, 2, 3, 44, 44, 1, 2, 3, 44, 93,
        91, 54, 11, 12, 13, 54, 54, 11, 12, 13, 54, 11, 12, 13, 54, 54, 11, 12, 13, 54, 93,
        91, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 93,
        91, 14, 15, 14, 15, 14, 15, 14, 15, 14, 15, 14, 15, 14, 15, 14, 24, 25, 15, 14, 93,
        91, 4, 24, 25, 5, 4, 5, 4, 5, 24, 25, 4, 5, 4, 5, 4, 34, 35, 5, 4, 93,
        91, 14, 34, 35, 15, 14, 15, 14, 15, 34, 35, 14, 15, 14, 15, 14, 15, 14, 15, 14, 93,
        91, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 93,
        91, 14, 15, 14, 15, 14, 15, 14, 15, 24, 25, 14, 15, 14, 15, 14, 15, 14, 15, 14, 93,
        91, 4, 5, 4, 5, 24, 25, 4, 5, 34, 35, 4, 5, 4, 5, 24, 25, 4, 5, 4, 93,
        91, 14, 15, 14, 15, 34, 35, 14, 15, 14, 15, 14, 24, 25, 15, 34, 35, 14, 15, 14, 93,
        91, 4, 24, 25, 5, 4, 5, 4, 5, 4, 5, 4, 34, 35, 5, 4, 5, 4, 5, 4, 93,
        91, 14, 34, 35, 15, 14, 15, 14, 15, 14, 15, 14, 15, 14, 15, 14, 15, 14, 15, 14, 93,
        91, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 5, 4, 93,
        101, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 102, 103
      }
    }
  }
}
