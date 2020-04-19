local droplet = require "actor.droplet"

return function(scene_graph, id, properties, shape)
    local emit = properties.emit or 1
    local emit_pause = properties.pause or 0.5
    local sleep = properties.sleep or 1
    while true do
        for i = 1, emit do
            local droplet_id = "droplet:" .. lume.uuid()
            local node = scene_graph:init_actor(
                droplet_id, droplet.scene, scene_graph.world
            )
            node.transform = transform(shape:center():unpack())
            event:sleep(emit_pause)
        end
        event:sleep(sleep)
    end

end
