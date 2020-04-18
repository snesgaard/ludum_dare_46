local animation = {}

function animation.idle(scene_graph, id)
    local body = scene_graph:get_body(id)
    local sprite = scene_graph:get_sprite(id)
    local torch = sprite:find("torch")
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

        if torch then
            local vx, vy = body.velocity:unpack()
            torch:set_motion(math.abs(vx), 0)
        end
        event:wait("update")
    end
end

function animation.id(id)
    return join(id, "animation")
end

local control = {}

function control.should_jump(body)
    if not body.jump or not body.ground then return end
    if math.abs(body.jump - body.ground) < 0.2 then
        body.jump = nil
        control.jump(body)
    end
end

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

    control.should_jump(body)
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
        if key == "space" then
            if love.keyboard.isDown("down") and body.on_ground then
                body:relative_move(0, 1, true)
            else
                body.jump = love.timer.getTime()
            end
        end
    end
end

return control
