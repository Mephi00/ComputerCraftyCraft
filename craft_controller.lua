local args = { ... }

peripheral.find("modem", rednet.open)

while true do
  if redstone.getInput('back') then
    rednet.broadcast(args[1], 'craft')

    sleep(30)
  end

  sleep(10)
end
