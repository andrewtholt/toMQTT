class = require("30log")

local M = class("Test")

-- function M:unlock(name)
--   local t=self.p[name]
--   
--   if t ~= nil then
--     t.lock = false
--   end

function M:init()
  print("Init")
  self.p = {}
  self.sub = {}
  self.p["DEBUG"] = "FALSE"

  self.p["WHATAMI"]= { value="", lock=true }

  if node == nil then
      self.p["WHATAMI"].value = "HOST"
  else
      self.p["WHATAMI"].value = "NODEMCU"
  end

  self.p["WHATAMI"].lock=true
end

function M:dump()
  print("    Dump")
  print("    ====")
  for k,v in pairs(self.p) do
    print(k,v.value,v.lock)
  end
  print("    ====")
  print("\nSubscription List")
  print("============ ====")
  
  for i,v in ipairs(self.sub) do
    print( v )
  end
  
  
end

function M:save(fname)
  local op=""
  local loc=""

  if fname == nil then
    loc=self.p["SAVETO"]
    if loc == nil then
      loc="/tmp"
    end

    fname = self.p["NODE"]
    if fname == nil then
      print("Error NODE")
      return false
    end
    fname = loc.value .. "/" .. fname.value .. ".rc"
  end

  print(fname)

  local file=io.open( fname, "w" )

  for k,v in pairs(self.p) do
    op = "^set " .. k .. ' ' .. v.value
    file:write( op .. "\n" )
    
    if v.lock then
      file:write("^lock " .. k .. "\n")
    else
      file:write("^unlock " .. k .. "\n")
    end
    
  end
  
  file:write("\n")
  
  for i,v in ipairs(self.sub) do
    file:write("^sub " .. v .. "\n" )
  end

  return true
end

function M:load(fname)
  if fname == nil then
    local loc=self.p["SAVETO"]
    if loc == nil then
      return false
    end

    fname = self.p["NODE"]
    if fname == nill then
      return false
    end
    fname = loc .. "/" .. fname .. ".rc"
  end

  print( fname )
  local file=io.open( fname, "r" )
  if file == nill then
    return false
  end

  while true do
    line = file:read()
    if line == nil then
      break
    end

    print(line)
  end
  return true
end

-- Add an entry.  lock will prevent the data be changed ...
-- If its true.
--
function M:set(name,v, l)
  if l == nil then
    l = false
  end
  
  if self.p[name] == nil then
    self.p[name]= { value=v, lock=l }
  else
    if self.p[name].lock == false or self.p[name].lock == nil then
      self.p[name]= { value=v, lock=l }
    end
  end
end

function M:lock(name)
  local t=self.p[name]
  
  if t ~= nil then
    t.lock = true
  end
  
end

function M:unlock(name)
  local t=self.p[name]
  
  if t ~= nil then
    t.lock = false
  end
  
end


function M:get(name)
  local t=self.p[name]
    
  if t == nil then
    print(name,"Not found")
    return false
  end
  
  return t.value
end

function M:subscribe( topic )
  local t = string.sub( topic,1,1)
  
  if t ~= '/' then
    topic = self.p["ROOT"].value .. "/" .. topic
  end
  
  -- print(topic)
  table.insert(self.sub, topic)
  
  
end

function M:connect()
  local t=self.p["SERVER"]
  -- 
  if t == nil then
    print("ERR:NO SERVER")
    return false
  end
  local server = t.value
  local tmp = self.p["MQTT_PORT"]

  if tmp == nil then
    print("ERR:NO PORT")
    return false
  end

  local port=tonumber( tmp.value )

  if port == nil then
    print("ERR:BAD PORT")
    return false
  end

  if self.p["WHATAMI"].value == "HOST" then
      --
      -- Load OS MQTT lib
      --
      MQTT = require("mqtt_library")
  end
  return true
end


return M
