collision = require "collision"

function actor(world, manager)
    body = Node.create(require "collision.body", world)

    local sprite = body:child(
        "sprite",
        Sprite,
        actor.wizard.animations,
        actor.wizard.atlas
    )
    --body:child("laser", teleport.laser)

    sprite:queue("idle")
    local body_shape = sprite:get_animation("run"):head().slices.body
    body:reshape(body_shape:relative():unpack())
    body.transform.scale = vec2(1, 1)
    body.transform.position = vec2(200, 200)
    local grav_y, jump_speed = collision.Body.jump_curve(110, 0.4)
    body.jump_speed = jump_speed
    body.default_gravity = vec2(0, grav_y)
    body:set_gravity(vec2(0, grav_y))


    sprite.on_slice_update = curry(collision.sprite_hitbox_sync, body)

    local stats = {
        damage = {
            health = 15
        }
    }

    return body
end
