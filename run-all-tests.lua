#!/usr/bin/lua

local lfs = require("lfs")

local filename = arg[1]
local file = io.open(filename, "r")
if not file then
  print("Could not open exercises file " .. filename)
  os.exit(1)
end

local exercises = {}
for line in file:lines() do
  table.insert(exercises, line)
end

for _, exercise in pairs(exercises) do
  local attr = lfs.attributes(exercise)
  if attr and attr.mode == "directory" then
    lfs.chdir(exercise)
    os.execute("exercism test")
    lfs.chdir("..")
  else
    print("Skipping '" .. exercise .. "' as it doesn't appear to be downloaded")
  end
end

file:close()
