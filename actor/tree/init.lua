local tree = {}

tree.atlas = "art/characters"

tree.animations = {
    idle = "tree_checkpoint"
}

local function look_for_tourch(col)
    if col.other.subtype ~= "torch" then return end
    local fire = col.item:find("../../sprite/fire")
    fire:activate()
    local id = col.item:upsearch("id")
    gamestate:set_respawn(id)
    gamestate:set_torch_level(gamestate.max_level)
end

function tree.scene(world)
    local body = Node.create(collision.Body, world)

    local sprite = body:child(
        "sprite",
        Sprite,
        tree.animations,
        tree.atlas
    )

    local slices = sprite:get_animation("idle"):head().slices
    local body_shape = slices.body
    body:reshape(body_shape:relative():unpack())

    function sprite.on_slice_update(slices)
        collision.sprite_hitbox_sync(body, slices)

        body:find("hitbox/activate").on_collision = look_for_tourch
    end
    sprite:queue("idle")

    local fire = sprite:child("fire", require "actor.tree.fire")
    fire:reshape(slices.fire_A:relative(slices.body))

    return body
end

return tree
