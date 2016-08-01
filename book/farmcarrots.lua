-- Farm Carrots program
-- By Al Sweigart
-- al@inventwithpython.com
-- Automatically farms carrots.

--[[
IMPORTANT NOTE!!!
Planted carrots in the game world are
named 'minecraft:carrots' but carrots
in your inventory are called
'minecraft:carrot'
]]

os.loadAPI('hare')

local cliArgs = {...}
local rowsArg = tonumber(cliArgs[1])
local columnsArg = tonumber(cliArgs[2])

if columnsArg == nil then
  print('Usage: farmcarrots rows columns')
  return
end


function checkCrop()
  local result, block = turtle.inspectDown()

  if result == false then
    turtle.digDown() -- till the soil
    plantCarrot()
  elseif block ~= nil and block['name'] == 'minecraft:carrots' and block['metadata'] == 7 then
    if turtle.digDown() then -- collect carrots
      print('Collected carrots.')
      plantCarrot()
    end
  end
end


function plantCarrot()
  if hare.selectItem('minecraft:carrot') == false then
    print('Warning: Low on carrots.')
    return false
  elseif turtle.placeDown() then -- plant a carrot
    print('Planted carrot.')
    return true
  else
    return false -- couldn't plant
  end
end


function storeCarrots()
  if not hare.findBlock('minecraft:chest') then -- face the chest
    print('Warning: Could not find chest.')
    return
  end

  -- drop off carrots
  local numToSave = rowsArg * columnsArg
  while hare.countItems('minecraft:carrot') > numToSave do
    hare.selectItem('minecraft:carrot')
    local numToDropOff = math.min((hare.countItems('minecraft:carrot') - numToSave), turtle.getItemCount())
    print('Dropping off ' .. numToDropOff .. ' carrots...')
    if not turtle.drop(numToDropOff) then
      print('Carrot chest is full!')
      print('Waiting for chest to be emptied...')
      while not turtle.drop(numToDropOff) do
        os.sleep(10)
      end
    end
  end

  -- face field again
  turtle.turnLeft()
  turtle.turnLeft()
end


print('Hold Ctrl+T to stop.')
if not hare.findBlock('minecraft:chest') then
  print('ERROR: Must start next to a chest!')
end

-- face field
turtle.turnLeft()
turtle.turnLeft()

while true do
  -- check fuel
  if turtle.getFuelLevel() < (rowsArg * columnsArg) + rowsArg + columnsArg then
    print('ERROR: Not enough fuel.')
    return
  end

  -- farm carrots
  print('Sweeping field...')
  hare.sweepField(rowsArg, columnsArg, checkCrop, storeCarrots)

  print('Sleeping for 10 minutes...')
  os.sleep(600)
end