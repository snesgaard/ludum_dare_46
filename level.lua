local collision = require "collision"

local level = {}

local function is_inbound(world, shape)
    local lx, ux = shape.x, shape.x + shape.w
    local ly, uy = shape.y, shape.y + shape.h
    return 0 <= lx and 0 <= ly and ux <= world._width and uy <= world._height
end

local function default_loader(world, obj, scene_graph)
    local f = require(obj.type)
    f = type(f) == "table" and f or {scene=f}

    local id = obj.name ~= "" and obj.name or lume.uuid()

    local shape = spatial(obj.x, obj.y, obj.width, obj.height)
    local node = scene_graph:init_actor(id, f.scene, world, shape)
    local align_method = Spatial[f.align or "centerbottom"] or Spatial.centerbottom
    if not node.transform then
        node.transform = transform(align_method(shape):unpack())
    else
        local p = node.transform.position
        p.x, p.y = align_method(shape):unpack()
    end

    return id
end

function level.load(path, loader, scene_graph)
    loader = loader or {}
    local world = bump.newWorld()
    local level = sti(path, { "bump" })
    level:bump_init(world)
    level.world = world
    world._width = level.width * level.tilewidth
    world._height = level.height * level.tileheight
    world.is_inbound = is_inbound
    scene_graph.world = world

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
            for i, obj in ipairs(layer.objects) do
                local f = loader[obj.type]
                f = f or default_loader
                if f and obj.visible then
                    local id = f(level.world, obj, scene_graph)
                    if obj.properties.script then
                        if id then
                            local script = require(obj.properties.script)
                            coroutine.set(
                                id, script, scene_graph, id,
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
