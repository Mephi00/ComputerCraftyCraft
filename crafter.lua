require 'crafter.crafting'

peripheral.find("modem", rednet.open)
rednet.host('craft', 'crafter')

repeat
  local id, msg = rednet.receive('craft')

  craft(msg)
until false
