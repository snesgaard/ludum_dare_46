local loader = {}

function loader.player_spawn(world, obj, scene_graph)
    local player = require "actor.player"

    local shape = spatial(obj.x, obj.y, obj.width, obj.height)
    scene_graph:init_actor(gamestate.player_id, player.scene, world)
    local player_body = scene_graph:get_body(gamestate.player_id)
    player_body.transform = transform(shape:centerbottom():unpack())
end

function loader.water(world, obj, scene_graph)
    local id = "water:" .. lume.uuid()
    local shape = spatial(obj.x, obj.y, obj.width, obj.height)
    scene_graph:init_actor(id, require("actor.water").scene, shape)
    return id
end

function loader.tree(world, obj, scene_graph)
    local tree = require "actor.tree"
    local id = obj.name or "tree" .. lume.uuid()
    local shape = spatial(obj.x, obj.y, obj.width, obj.height)
    scene_graph:init_actor(id, tree.scene, world)
    local body = scene_graph:get_body(id)
    body.transform = transform(shape:centerbottom():unpack())
end

function loader.droplet_spawn(world, obj, scene_graph)
    local id = "droplet" .. lume.uuid()
    return id
end

return loader
