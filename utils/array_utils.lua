function has_value(tab, val)
  for index, value in ipairs(tab) do
    if value == val then
      return index
    end
  end

  return nil
end
