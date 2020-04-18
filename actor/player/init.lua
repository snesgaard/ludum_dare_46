local player = {}

player.atlas = "art/characters"

player.animations = {
    idle="main_run/idle",
    run="main_run/run",
    ascend="main_run/ascend",
    descend="main_run/descend",
}

function player.scene(world)
    local body = Node.create(collision.Body, world)

    body = Node.create(require "collision.body", world)

    local sprite = body:child(
        "sprite",
        Sprite,
        player.animations,
        player.atlas
    )

    local body_shape = sprite:get_animation("idle"):head().slices.body
    body:reshape(body_shape:relative():unpack())
    body:set_gravity(vec2(0, 0))
    sprite.on_slice_update = curry(collision.sprite_hitbox_sync, body)

    sprite:queue("idle")

    local torch = sprite:child("torch", require "actor.player.torch")

    function sprite.on_slice_update(slices)
        torch:reshape(slices.torch)
    end

    local grav_y, jump_speed = collision.Body.jump_curve(110, 0.4)
    body.jump_speed = jump_speed
    body.default_gravity = vec2(0, grav_y)
    body:set_gravity(vec2(0, grav_y))

    return body
end

return player
