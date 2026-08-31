solar_panels = {}
solar_panels_relay = {peripheral.find("redstone_relay")}
solar_panels_sequence = {peripheral.find("Create_SequencedGearshift")}
rpm = 1
total_hours = 18-6
starting_angle = 0
ending_angle = 180
running = true
current_angle = 0
aligned = false
angle = (ending_angle - starting_angle) / total_hours
rednet.open("top")

for k,v in pairs(solar_panels_relay) do
    table.insert(solar_panels, {relay = v, sequence = solar_panels_sequence[k], zeroed = false})
end

function zero(v)
    aligned = false
    if v.relay.getInput("bottom") then
        v.zeroed = true
    end
    if v.zeroed == false then
        v.relay.setOutput("top", true)
    else
        v.relay.setOutput("top", false)
    end
    while v.zeroed == false do
        v.relay.setOutput("front", true)
        if v.relay.getInput("bottom") then
            v.relay.setOutput("front",false)
            sleep(1)
            v.relay.setOutput("top", false)
            v.zeroed = true
        end
        sleep(0.1)
    end
    sleep(5)
    prev_hour = 6
    while aligned == false do
        time = os.time("ingame")
        hour = math.floor(time)
        if hour < 18 and hour > 5 and prev_hour < hour then
            remaining_hours = hour - prev_hour 
            v.sequence.rotate(angle * remaining_hours,-1)
            aligned = true
        end
        sleep(0.1)
    end
end

function align(v)
    v.sequence.rotate(angle,-1)
    v.zeroed = false
end

for k,v in pairs(solar_panels) do 
    zero(v)
end

while running do
    sleep(1)
    time = os.time("ingame")
    hour = math.floor(time)
    if prev_hour == nil then 
        prev_hour = hour
    end
    for k,v in pairs(solar_panels) do
        if prev_hour < hour and hour > 5 and hour < 18 then
            align(v)            
        elseif hour > 17 and hour < 24 and v.zeroed == false or hour > 0 and hour < 6 and v.zeroed == false then
            v.relay.setOutput("top", true)
            sleep(1)
            while v.zeroed == false do
                v.relay.setOutput("front", true)
                if v.relay.getInput("bottom") then
                    v.relay.setOutput("front",false)
                    sleep(1)
                    v.relay.setOutput("top", false)
                    v.zeroed = true
                end
                sleep(0.1)
            end
        end
    end
    if redstone.getInput("back") then
        for k,v in pairs(solar_panels) do 
            zero(v)
        end
    end
    prev_hour = hour
    sleep(1)
end
