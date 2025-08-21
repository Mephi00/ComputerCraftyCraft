require 'utils.logging_utils'
require 'crafter.recipies'
require 'crafter.material_gatherer'

local startBlock = 'minecraft:purple_wool'

local craftingGrid = { 1, 2, 3, 5, 6, 7, 9, 10, 11 }

local function findDirection()
  local present, block = turtle.inspect()
  local turns = 0
  while present do
    print(present)
    if turns > 4 then
      return false
    end

    turtle.turnLeft()
    turns = turns + 1
    present, block = turtle.inspect()
  end

  return true
end

local function findStartBlock()
  if not findDirection() then
    return false
  end

  local present, block = turtle.inspectDown()
  local turnedAround = false
  while not present or block.name ~= startBlock do
    if not turtle.forward() then
      if turnedAround then
        return false
      end

      turtle.turnLeft()
      turtle.turnLeft()
      turnedAround = true
    end
    present, block = turtle.inspectDown()
  end
  return true
end

local function dumpInventory()
  findStartBlock()

  local present, block = turtle.inspectDown()
  local turns = 0
  while not present or block.tags['c:chests'] == nil do
    if turns > 4 then
      print('couldnt find chest')
      return false
    end

    turtle.turnLeft()
    turns = turns + 1
  end

  print('found chest')

  for k = 1, 16 do
    turtle.select(k)
    turtle.drop()
  end

  findDirection()

  return true
end

local function clearCraftingGrid(itemsToCraftWith)
  local filledSlots = {}
  for _, k in ipairs(craftingGrid) do
    turtle.select(k)
    local itemDetail = turtle.getItemDetail()
    if itemDetail ~= nil then
      if has_value(itemsToCraftWith, itemDetail) then
        table.insert(filledSlots, itemDetail.name)
        turtle.transferTo(craftingGrid(#filledSlots))
      else
        turtle.drop()
      end
    end
  end
end

local function findItem(name)
  for k = 1, 16 do
    local item = turtle.getItemDetail(k)
    if item ~= nil and item.name == name then
      return k
    end
  end
  return 0
end

local function assembleRecipie(recipie)
  local placedItems = {}

  for position, itemName in pairs(recipie) do
    local spot = findItem(itemName)
    if spot == 0 then
      print('item not present', itemName)
    end
    turtle.select(spot)
    local placedItem = placedItems[itemName]
    if placedItem ~= nil then
      local itemAmount = turtle.getItemDetail(placedItem[#placedItem]).count
      turtle.transferTo(position, itemAmount / 2)
      table.insert(placedItem, position)
    else
      turtle.transferTo(position)
      placedItems[itemName] = { position }
    end
  end
  return true
end

function craft(recipieName)
  local recipie = recipies[recipieName]
  if recipie == nil then
    print('Recipie not known')
    return
  end

  if not findStartBlock() then
    print(string.format('FAILURE: Cannot find start block %s', startBlock))
    os.exit()
  end

  if not findDirection() then
    print('FAILURE: Cannot find a way out from the start')
    os.exit()
  end

  if not dumpInventory() then
    print('FAILURE: Cannot dump inventory')
    os.exit()
  end

  local requiredItems = getItemsForRecipie(recipie)
  if not getItems(requiredItems) then
    print('Could not craft recipie')
    return false
  end

  assembleRecipie(recipie)
  turtle.craft()
  dumpInventory()
end

craft('inferium_ingot')
