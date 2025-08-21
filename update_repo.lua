if not fs.exists('clone.lua') then
  shell.run(
    'wget https://gist.githubusercontent.com/SquidDev/e0f82765bfdefd48b0b15a5c06c0603b/raw/clone.min.lua clone.lua')
end

shell.run('rm ComputerCraftyCraft')
shell.run('clone https://github.com/Mephi00/ComputerCraftyCraft')
