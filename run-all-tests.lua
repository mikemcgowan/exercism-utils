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
file:close()

local successful = 0
local failures = {}
local total = 0
for _, exercise in pairs(exercises) do
  local attr = lfs.attributes(exercise)
  if attr and attr.mode == "directory" then
    lfs.chdir(exercise)
    local status, _, _ = os.execute("exercism test")
    if status then
      successful = successful + 1
    else
      table.insert(failures, exercise)
    end
    total = total + 1
    lfs.chdir("..")
  else
    print("Skipping '" .. exercise .. "' as it doesn't appear to be downloaded")
  end
end

print(successful .. " out of " .. total .. " succeeded")
if #failures > 0 then
  local s = #failures == 1 and "exercise" or "exercises"
  print("The following " .. #failures .. " " .. s .. " failed:")
  for _, v in ipairs(failures) do
    print(v)
  end
end
