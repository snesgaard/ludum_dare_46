local gamestate = {
    respawn = nil,
    torch_level = 4,
    max_level = 4,
    scene_graph = Node.create(require "scene_graph"),
    player_id = "player",
    control_id = "control_1337",
    ticks = {
        tick_duration = 10,
        time_till_next = nil
    }
}


function gamestate:set_respawn(id)
    self.respawn_id = id
end

function gamestate:reset_ticks()
    self.ticks.time_till_next = self.ticks.tick_duration
end

function gamestate:do_respawn()
    local player_body = self.scene_graph:get_body(self.player_id)
    local respawn_body = self.scene_graph:get_body(self.respawn_id)
    player_body:warp(respawn_body:get_shape():centerbottom():unpack())
end

function gamestate:set_torch_level(level)
    if level == 0 then
        gamestate:do_respawn()
        return self:set_torch_level(4)
    end

    self.torch_level = math.max(level, 0)
    self:reset_ticks()
    local sprite = self.scene_graph:get_sprite(self.player_id)
    sprite:find("torch"):set_level(level)
end

function gamestate:kill_player()
    return self:set_torch_level(0)
end

function gamestate:reduce_torch()
    return self:set_torch_level(self.torch_level - 1)
end

function gamestate:checkpoint(id)
    self.respawn = id
end

function gamestate:update(dt)
    local time = self.ticks.time_till_next - dt
    if time < 0 then
        time = self.ticks.tick_duration
        self:reduce_torch()
    end
    self.ticks.time_till_next = time
end

return gamestate
