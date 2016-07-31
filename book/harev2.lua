-- "Hare" utility library
-- By Al Sweigart
-- al@inventwithpython.com
-- Provides useful utility functions.

version = "2"

function fuelSpace()
  if turtle.getFuelLimit() == 'unlimited' then
    return 0
  else 
    return turtle.getFuelLimit() - turtle.getFuelLevel()
  end
end

function findItem(name, metadata)
  -- finds inventory slot that has the named item
  -- returns slot number if found, nil if not found
  local slot, item

  -- first try to find an exact match
  for slot=1,16 do
    item = turtle.getItemDetail(slot)
    if item ~= nil and 
       item['name'] == name and
       (metadata == nil or item['metadata'] == metadata) then
      return slot
    end
  end

  -- next try to find a similar match
  for slot=1,16 do
    item = turtle.getItemDetail(slot)
    if item ~= nil and 
       string.find(item['name'], name) and
       (metadata == nil or item['metadata'] == metadata) then
      return slot
    end
  end

  return nil -- couldn't find item
end


function selectItem(name, metadata)
  -- selects inventory slot that has the named item
  -- return true if found, false if not found
  local slot = findItem(name, metadata)

  if slot ~= nil then
    turtle.select(slot)
    return true
  else
    return false -- couldn't find item
  end
end


function findEmptySlot()
  -- finds inventory slot that has nothing in it
  -- returns slot number if found, nil if not found
  local slot
  for slot=1,16 do
    if turtle.getItemCount(slot) == 0 then
      return slot
    end
  end
  return nil -- couldn't find empty space
end


function selectEmptySlot()
  -- selects inventory slot that has nothing in it
  -- return true if found, false if not found
  local slot = findEmptySlot()
  if slot ~= nil then
    turtle.select(slot)
    return true
  else
    return false -- couldn't find empty space
  end
end


function doAction(action)
  action = string.lower(action)

  if action == 'f' then
    return turtle.forward()
  elseif action == 'b' then
    return turtle.back()
  elseif action == 'l' then
    return turtle.turnLeft()
  elseif action == 'r' then
    return turtle.turnRight()
  elseif action == 'up' then
    return turtle.up()
  elseif action == 'dn' then
    return turtle.down()
  elseif action == 'd' then
    return turtle.dig()
  elseif action == 'du' then
    return turtle.digUp()
  elseif action == 'dd' then
    return turtle.digDown()
  elseif action == 'i' then
    return turtle.inspect()
  elseif action == 'iu' then
    return turtle.inspectUp()
  elseif action == 'id' then
    return turtle.inspectDown()
  elseif action == 's' then
    return turtle.suck()
  elseif action == 'sd' then
    return turtle.suckDown()
  elseif action == 'su' then
    return turtle.suckUp()
  elseif action == 'p' then
    return turtle.place()
  elseif action == 'pu' then
    return turtle.placeUp()
  elseif action == 'pd' then
    return turtle.placeDown()
  elseif action == 'dr' then
    return turtle.drop()
  elseif action == 'dru' then
    return turtle.dropUp()
  elseif action == 'drd' then
    return turtle.dropDown()
  elseif action == 'c' then
    return turtle.craft()
  elseif action == 'el' then
    return turtle.equipLeft()
  elseif action == 'er' then
    return turtle.equipRight()
  elseif action == 'a' then
    return turtle.attack()
  elseif action == 'au' then
    return turtle.attackUp()
  elseif action == 'ad' then
    return turtle.attackDown()
  elseif action == 'det' then
    return turtle.detect()
  elseif action == 'detup' then
    return turtle.detectUp()
  elseif action == 'detd' then
    return turtle.detectDown()  
  elseif action == 'cmp' then
    return turtle.compare()
  elseif action == 'cmpu' then
    return turtle.compareUp()
  elseif action == 'cmpd' then
    return turtle.compareDown()
  elseif action == 'ref' then
    return turtle.refuel()
  elseif string.sub(action, 0, 3) == 'sel' then
    local slot = tonumber(string.sub(action, 3, 2))
    return turtle.select(slot)
  elseif string.sub(action, 0, 4) == 'tran' then
    --local from = tonnumber(string.sub())
    -- TODO - finsih
  else
    -- not a recognized action
    return false, 'Not a recognized action.'
  end
end


function split(str)
  -- splits a string into an array of strings
  -- Example: 'a b c' -> {'a', 'b', 'c'}
  local result = {}
  local word
  -- Note: The gmatch() function is
  -- beyond the scope of this book.
  for word in str:gmatch("%w+") do 
    table.insert(result, word) 
  end
  return result
end


function doActions(actions)
  -- Do a series of actions.
  -- actions is a string: "f r 3" will
  -- go forward, turn right 3 times.
  -- See doAction() for action codes.
  -- If safeMode is true, then stop
  -- if one action fails.

  -- get array of strings from string
  actions = split(actions)

  while #actions > 0 do
    -- check for rep count
    if tonumber(actions[2]) ~= nil then
      -- reduce the rep count by 1
      actions[2] = tonumber(actions[2]) - 1
    end
    if tonumber(actions[2]) == 0 then
      -- if the rep count is 0, remove it
      table.remove(actions, 2)
    end

    -- do the action
    result1, result2 = doAction(actions[1])

    if tonumber(actions[2]) == nil then
      -- if there's no rep count,
      -- remove this action
      table.remove(actions, 1)
    end

    -- check for error message
    if type(result2) == 'string' then
      -- action failed, return the error message
      return result2
    end
  end

  return 'ok' -- all actions done
end
