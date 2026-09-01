-- check for solar panels list file
if fs.exists("solar_panels_list.json") then
    solar_panels_file = fs.open("solar_panels_list.json","r")
    solar_panels_list = textutils.unserializeJSON(solar_panels_file.readAll())
    solar_panels_file.close()
else
    solar_panels_list = {}
    file = fs.open("solar_panels_list.json","w+")
    file.write(textutils.serializeJSON(solar_panels_list))
    file.close()
    solar_panels_file = fs.open("solar_panels_list.json","r")
    solar_panels = textutils.serializeJSON(solar_panels_file.readAll())
    solar_panels_file.close()
end

-- check for data file
if fs.exists("data.json") then
    data_file = fs.open("data.json","r")
    data = textutils.unserializeJSON(data_file.readAll())
    data_file.close()
else
    data = {current_id = 1}
    file = fs.open("data.json","w+")
    file.write(textutils.serializeJSON(data))
    file.close()
end


detected_solar_panels = {}
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

for k,v in pairs(solar_panels_relay) do
    table.insert(detected_solar_panels, {relay = v, sequence = solar_panels_sequence[k], zeroed = false})
end

function zero(v,tohour,tozero)
    v.aligned = false
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
            v.relay.setOutput("back",true)
            sleep(0.2)
            v.relay.setOutput("back",false)
            v.relay.setOutput("front",false)
            sleep(1)
            v.relay.setOutput("top", false)
            v.zeroed = true
        end
        sleep(0.1)
    end
    sleep(3)
    v.prev_hour = 6
    while v.aligned == false do
        if tohour < 18 and tohour > 5 and v.prev_hour < tohour then
            v.remaining_hours = tohour - v.prev_hour 
            v.sequence.rotate(angle * v.remaining_hours,-1)
        end
        sleep(0.1)
        v.aligned = true
    end
end

function align(v)
    v.sequence.rotate(angle,-1)
    v.zeroed = false
end

function scan()
    -- relay
    new_solar_panel_relay = nil
    new_solar_panel_sequence = nil
    for k,v in pairs(detected_solar_panels) do
        matches = false
        for x,y in pairs(solar_panels_list) do
            if peripheral.getName(v.relay) == y.relay then
                matches = true
            end
        end
        if matches == false then
            new_solar_panel_relay = peripheral.getName(v.relay)
        end
    end
    -- sequence
    for k,v in pairs(detected_solar_panels) do
        matches = false
        for x,y in pairs(solar_panels_list) do
            if peripheral.getName(v.sequence) == y.sequence then
                matches = true
            end
        end
        if matches == false then
            new_solar_panel_sequence = peripheral.getName(v.sequence)
        end
    end
    if new_solar_panel_relay == nil and new_solar_panel_sequence == nil then
        print("no new solar panel detected.")

    else
        print("new solar panel detected!")
        table.insert(solar_panels_list,{relay = new_solar_panel_relay, sequence = new_solar_panel_sequence,zeroed = false,id = data.current_id})
        file = fs.open("solar_panels_list.json","w+")
        file.write(textutils.serializeJSON(solar_panels_list))
        file.close()
        data.current_id = data.current_id + 1
        file = fs.open("data.json","w+")
        file.write(textutils.serializeJSON(data))
        file.close()    
    end
    solar_panels_file = fs.open("solar_panels_list.json","r")
    solar_panels = textutils.unserializeJSON(solar_panels_file.readAll())
    solar_panels_file.close()
end

scan()

time = os.time("ingame")
tohour = math.floor(time)
funcs = {}
for k,v in pairs(solar_panels) do 
    table.insert(funcs,function()
        p = {relay = peripheral.wrap(v.relay), sequence = peripheral.wrap(v.sequence),zeroed = v.zeroed,aligned = false}
        zero(p,tohour)
    end)
end
parallel.waitForAll(table.unpack(funcs))

while running do
    sleep(1)
    time = os.time("ingame")
    hour = math.floor(time)
    if prev_hour == nil then 
        prev_hour = hour
    end
    for k,v in pairs(solar_panels) do
        if prev_hour < hour and hour > 5 and hour < 18 then
            p = {relay = peripheral.wrap(v.relay), sequence = peripheral.wrap(v.sequence),zeroed = v.zeroed}
            align(p)  
            all_resetted = false
        end
    end
    if hour > 17 and hour < 24 and all_resetted == false or hour > 0 and hour < 6 and all_resetted == false then
        funcs2 = {}
        for k,v in pairs(solar_panels) do 
            table.insert(funcs2,function()
                p = {relay = peripheral.wrap(v.relay), sequence = peripheral.wrap(v.sequence),zeroed = v.zeroed}
                print(v.relay)
                zero(p,6)
            end)
        end
        parallel.waitForAll(table.unpack(funcs2))
        all_resetted = true
    end
    prev_hour = hour
    sleep(1)
end
