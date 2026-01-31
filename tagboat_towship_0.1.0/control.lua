
-- MINIMAL, STABLE CONTROL
-- Vanilla ENTER works 100%
-- Only blocks entering the barge (not a vehicle)

local function safe_player(i)
  if not (game and i) then return nil end
  local p = game.get_player(i)
  if p and p.valid then return p end
  return nil
end

script.on_event(defines.events.on_player_driving_changed_state, function(event)
  local player = safe_player(event.player_index)
  if not player then return end

  local veh = player.vehicle
  if veh and veh.valid and veh.name == "wooden-platform-barge" then
    player.driving = false
    player.print({"", "[Tagboat] ", "Nie można wsiadać do barki."})
  end
end)
