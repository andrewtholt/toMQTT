#!/usr/bin/lua

function string:split( inSplitPattern, outResults )
    if not outResults then
        outResults = { }
    end
    local theStart = 1
    local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    while theSplitStart do
        table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
        theStart = theSplitEnd + 1
        theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    end
    table.insert( outResults, string.sub( self, theStart ) )
    return outResults
end

function dump(t)
    local x=0
    print("Dump")

    for k,v in pairs(t) do
        print(k,v)
    end
end

function save(t)
    local x=0
    print("Save")
    
    local loc=t["SAVETO"]
    if loc = nil then
      loc = "/tmp"
    end

    local fname=loc .. "/" .. t["NODE"] .. ".rc"
    local file=io.open(fname,"w")

    print("... to file " .. fname)
    
    for k,v in pairs(t) do
        file:write("^set " .. k .. ' "' .. v.valu^exit .. '"\n')
    end

    file:flush()
    io.close(file)
end

function subscribe(pList, topic)
  print("Subscribe\n")
  
  if string.sub(topic,1,1) == "/" then

  end

  table.insert(pList, topic)
end

function main()
    param={}
    local runFlag=true
    local fileFlag = false
    local subList = {}
    
    param["DEBUG"] = "FALSE"
    param["NODE"] = "TEST"
    fileInput=stdin


    while runFlag == true do

        if fileFlag then
            line = io.read()

            if line == nil then
                io.close()
                io.input(io.stdin)
                fileFlag=false
                line="^nop"
            end
        else
            io.write("> ")
            line = io.read("*line")
        end



        if line ~= nil then
            if line == "^exit" then
                runFlag=false
            else
                local cmd = line:split(" ")
                if cmd[1] == "^subscribe" then
                  subscribe(subList,cmd[2])
                end

                if cmd[1] == "^nop" then
                end
                
                if cmd[1] == "^dump" then
                    dump(param)
                end


                if cmd[1] == "^print" then
                    print(param[cmd[2]])
                end

                if cmd[1] == "^set" then
                    param[cmd[2]] = cmd[3]
                end

                if cmd[1] == "^save" then
                    save(param)
                end

                if param["DEBUG"] == "TRUE" then
                    for x=1, #cmd do
                        print("-->",cmd[x])
                    end
                end

                if cmd[1] == "^load" then
                    fileFlag=true
                    local fname="/tmp/" ..  param["NODE"] .. ".rc"
                    print("File is " .. fname)
                    io.input(fname)
                end
            end
        end
    end
    print("Done")
end

main()



