#!/usr/bin/lua

local filename = arg[1]
local track = arg[2]
local track_txt = track .. ".txt"
if filename:sub(-#track_txt) ~= track_txt then
  print("Filename '" .. filename .. "' doesn't agree with track '" .. track .. "'")
  os.exit(1)
end
local file = io.open(filename, "r")
if not file then
  print("Could not open exercises file " .. filename)
  os.exit(1)
end
local exercises = {}
for line in file:lines() do
  table.insert(exercises, line)
end
file:close()

for _, exercise in pairs(exercises) do
  os.execute("exercism download --track=" .. track .. " --exercise=" .. exercise .. " --force")
end
