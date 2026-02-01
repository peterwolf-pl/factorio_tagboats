
-- MINIMAL, STABLE CONTROL
-- Vanilla ENTER works 100%
-- Only blocks entering the barge (not a vehicle)

local function safe_player(i)
  if not (game and i) then return nil end
  local p = game.get_player(i)
  if p and p.valid then return p end
  return nil
end

local function find_nearest_empty_tagboat(player, radius)
  if not (player and player.valid) then return nil end
  local surface = player.surface
  if not surface then return nil end
  local boats = surface.find_entities_filtered({
    name = "towship-tagboat",
    position = player.position,
    radius = radius
  })
  local best
  local best_dist
  for _, boat in pairs(boats) do
    if boat.valid and not boat.get_driver() and not boat.get_passenger() then
      local dx = boat.position.x - player.position.x
      local dy = boat.position.y - player.position.y
      local dist = (dx * dx) + (dy * dy)
      if not best or dist < best_dist then
        best = boat
        best_dist = dist
      end
    end
  end
  return best
end

script.on_event(defines.events.on_player_driving_changed_state, function(event)
  local player = safe_player(event.player_index)
  if not player then return end

  local veh = player.vehicle
  if veh and veh.valid and veh.name == "wooden-platform-barge" then
    local tagboat = find_nearest_empty_tagboat(player, 6)
    if tagboat then
      player.driving = false
      tagboat.set_driver(player)
    else
      player.driving = false
      player.print({"", "[Tagboat] ", "Nie można wsiadać do barki."})
    end
  end
end)
