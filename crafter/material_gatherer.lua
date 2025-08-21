require 'utils.array_utils'

local block_mapping = {
  ['minecraft:coal'] = 'minecraft:black_wool',
  ['mysticalagriculture:inferium_essence'] = 'minecraft:lime_wool',
  ['mysticalagriculture:prudentium_essence'] = 'minecraft:green_wool',
  ['mysticalagriculture:tertium_essence'] = 'minecraft:orange_wool',
  ['mysticalagriculture:imperium_essence'] = 'minecraft:blue_wool',
  ['mysticalagriculture:supremium_essence'] = 'minecraft:red_wool',
  ['mysticalagriculture:prosperity_gemstone'] = 'minecraft:white_wool',
  ['mysticalagriculture:prosperity_ingot'] = 'minecraft:light_gray_wool'
}

local function turnToPickUp()
  turtle.turnLeft()
  local turns = 1

  if not turtle.suck() then
    turtle.turnLeft()
    turtle.turnLeft()
    local suckResult = turtle.suck()
    turtle.turnLeft()
    return suckResult
  end

  turtle.turnRight()
  return true
end

function getItems(itemNames)
  local blockNames = {}
  for _, itemName in ipairs(itemNames) do
    local blockName = block_mapping[itemName]
    if blockName == nil then
      print(string.format('Looking for unknown Item "%s"', itemName))
      return false
    end
    table.insert(blockNames, blockName)
  end

  while #blockNames > 0 do
    local block = turtle.inspectDown()
    if block == nil then
      print('Found empty block, pls fix setup')
      return false
    end

    local nameIndex = has_value(blockNames, block.name)
    if nameIndex ~= nil then
      turtle.select(#itemNames - (#blockNames - 1))
      if not turnToPickUp() then
        print(string.format('Could not find chest next to %s', block.name))
        return false
      end

      table.remove(blockNames, nameIndex)
    end

    if not turtle.forward() then
      for _, block in ipairs(blockNames) do
        print(string.format('Could not find expected block: %s', block))
      end
      return false
    end
  end

  return true
end
