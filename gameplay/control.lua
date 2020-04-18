local animation = {}

function animation.idle(scene_graph, id)
    local body = scene_graph:get_body(id)
    local sprite = scene_graph:get_sprite(id)
    while true do
        if body.velocity.y < 0 then
            sprite:play("ascend")
        elseif body.velocity.y > 0 then
            sprite:play("descend")
        elseif body.velocity.x ~= 0 then
            sprite:play("run")
        else
            sprite:play("idle")
        end
        event:wait("update")
    end
end

function animation.id(id)
    return join(id, "animation")
end

local control = {}

function control.motion(body, key)
    local speed = 0
    if love.keyboard.isDown("left") then
        speed = speed - 1
    end
    if love.keyboard.isDown("right") then
        speed = speed + 1
    end
    if speed ~= 0 then
        body.transform.scale.x = speed
    end

    body.velocity.x = 200 * speed
end

function control.jump(body)
    body.velocity.y = body.jump_speed or 0
end

function control.idle(scene_graph, id)
    local body = scene_graph:get_body(id)

    if not body then
        errorf("Could no locate body for %s", id)
    end

    coroutine.set(animation.id(id), animation.idle, scene_graph, id)

    local control_token = event:listen("update", curry(control.motion, body))

    while true do
        local key = event:wait("keypressed")
        if key == "space" and body.on_ground then
            if love.keyboard.isDown("down") then
                body:relative_move(0, 1, true)
            else
                control.jump(body)
            end
        end
    end
end

return control
