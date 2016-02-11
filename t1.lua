#!/usr/bin/lua

p=require("param")

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

function main()
    local fileFlag=false

    p:init()

    p:set("ROOT","/home/livingRoom/temperature")
    p:set("NODE","localhost")
    p:set("SAVETO","/tmp")
    p:set("DEBUG","FALSE")
    p:set("RUNFLAG","TRUE")

    p:dump()

    while p:get("RUNFLAG") == "TRUE" do
        if fileFlag then
            line=io.read()

            if line == nil then
                io.close()
                io.input(io.stdin)
                fileFlag=false
                line="^eof"
            end
        else
            io.write("-> ");
            line = io.read("*line")
        end

        if line == "^exit" then
            p:set("RUNFLAG","FALSE")
        else
            local cmd = line:split(" ")

            if cmd[1] == "^dump" then
                p:dump()
            end

            if cmd[1] == "^set" then
                p:set( cmd[2], cmd[3], false)
            end

            if cmd[1] == "^lock" then
                p:lock( cmd[2])
            end

            if cmd[1] == "^unlock" then
                p:unlock( cmd[2])
            end

            if cmd[1] == "^save" then
                p:save()
            end

            if cmd[1] == "^sub" then
                p:subscribe(cmd[2])
            end

            if cmd[1] == "^connect" then
                p:connect()
            end

            --
            -- ^load must be last.
            --
            if cmd[1] == "^load" then
                fileFlag=true
                local fname = p:get("SAVETO")
                fname = fname .. "/"
                fname = fname .. p:get("NODE") .. ".rc"
                print("fname",fname)
                io.input(fname)
            end
        end
    end
end

main()

