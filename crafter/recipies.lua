require 'utils.array_utils'

recipies = {}
local essences = { 'inferium', 'prudentium', 'tertium', 'imperium', 'supremium' }

for i, s in ipairs(essences) do
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

  if i > 1 and i < #essences then
    recipies[string.format('mysticalagriculture:%s_essence', s)] = {
      string.format('mysticalagriculture:%s_essence', essences[i + 1])
    }
  end
end

function getItemsForRecipie(recipie)
  local items = {}

  for _, item in pairs(recipie) do
    if has_value(items, item) == nil then
      table.insert(items, item)
    end
  end

  return items
end
