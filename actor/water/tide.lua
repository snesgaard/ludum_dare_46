return function(scene_graph, id, properties)
    local body = scene_graph:get_body(id)
    local transform = body.transform
    local amp = properties.amplitude or 5.0
    local freq = properties.frequency or 1.0
    local phase = properties.phase or 0
    local time = 0
    while true do
        local dt = event:wait("update")
        time = time + dt
        transform.position.y = math.sin(time * freq + phase * math.pi * 2) * amp
    end

end
