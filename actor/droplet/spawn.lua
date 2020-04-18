local droplet = require "actor.droplet"

return function(scene_graph, id, properties, shape)
    local delay = properties.delay or love.math.random() * 5
    local span = properties.span or 5
    event:sleep(delay)
    while true do
        local droplet_id = "droplet:" .. lume.uuid()
        local node = scene_graph:init_actor(droplet_id, droplet.scene, scene_graph.world)
        node.transform = transform(shape:center():unpack())
        event:sleep(span)
    end
end
