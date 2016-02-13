#!/usr/bin/lua

broker="192.168.100.99"
-- broker="iduino"

mqtt = require("mosquitto")
client = mqtt.new()

client.ON_CONNECT = function()
        print("connected")
        client:subscribe("/home/+")
        local mid = client:subscribe("/home/livingRoom/temperature/fred", 2)
end

client.ON_MESSAGE = function(mid, topic, payload)
        print(topic, payload)
end

client:connect(broker)
client:loop_forever()
