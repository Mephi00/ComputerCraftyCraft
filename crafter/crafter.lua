local craftingGrid = { 1, 2, 3, 5, 6, 7, 9, 10, 11 }
local nonCraftingSlots = { 4, 8, 12, 13, 14, 15, 16 }
local recipies = {}

for _, s in ipairs({ 'inferium', 'tertium', 'imperium', 'prudentium', 'supremium' }) do
  recipies[string.format("%s_ingot", s)] = {
    [1] = 'mysticalagriculture:prosperity_ingot',
    [2] = string.format('mysticalagriculture:%s_essence', s),
    [5] = string.format('mysticalagriculture:%s_essence', s)
  }
  recipies[string.format("%s_gem", s)] = {
    [1] = 'mysticalagriculture:prosperity_gemstone',
    [2] = string.format('mysticalagriculture:%s_essence', s),
    [5] = string.format('mysticalagriculture:%s_essence', s)
  }
end

local function has_value(tab, val)
  for index, value in ipairs(tab) do
    if value == val then
      return true
    end
  end

  return false
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

local function assembleRecipie(name)
  local recipie = recipies[name]
  if recipie == nil then
    print('Recipie not known')
    return
  end

  local placedItems = {}

  for position, itemName in ipairs(recipie) do
    local spot = findItem(itemName)
    if spot == 0 then
      print('item not present', itemName)
      return itemName
    end
    print('placing:', itemName)
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
  return nil
end

assembleRecipie('inferium_ingot')
