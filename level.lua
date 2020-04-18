local collision = require "collision"

local level = {}

local function is_inbound(world, shape)
    local lx, ux = shape.x, shape.x + shape.w
    local ly, uy = shape.y, shape.y + shape.h
    return 0 <= lx and 0 <= ly and ux <= world._width and uy <= world._height
end

function level.load(path, loader, ...)
    loader = loader or {}
    local world = bump.newWorld()
    local level = sti(path, { "bump" })
    level:bump_init(world)
    level.world = world
    world._width = level.width * level.tilewidth
    world._height = level.height * level.tileheight
    world.is_inbound = is_inbound
    gamestate.scene_graph.world = world

    local bg_layer = level:addCustomLayer("bg_layer", 1)

    function bg_layer:draw()
        gfx.push()
        gfx.origin()
        gfx.setColor(0.1, 0.05, 0.1)
        gfx.rectangle("fill", 0, 0, gfx.getWidth(), gfx.getHeight())
        gfx.setColor(1, 1, 1)
        gfx.pop()
    end

        for name, layer in pairs(level.layers) do
            if name == "entity" then
                for _, obj in pairs(layer.objects) do
                    local f = loader[obj.type]
                    if f and obj.visible then
                        local id = f(level.world, obj, ...)
                        if obj.properties.script then
                            if id then
                                local script = require(obj.properties.script)
                                coroutine.set(
                                    id, script, gamestate.scene_graph, id,
                                    obj.properties,
                                    spatial(obj.x, obj.y, obj.width, obj.height)
                                )
                            else
                                log.warn("An id must be given for %s", obj.name)
                            end
                        end
                    end

                end
                layer.visible = false
            end
        end

    collision.init(level.world)

    return level
end

level.__call = level.load

return setmetatable(level, level)
