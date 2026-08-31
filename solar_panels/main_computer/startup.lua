-- computer ids
sector_1 = 26
sector_2 = 22
sector_3 = 24
sector_4 = 25

sector_1_loaded = false
sector_2_loaded = false
sector_3_loaded = false
sector_4_loaded = false

rednet.open("back")
all_loaded = false
while all_loaded == false do
    local id,message = rednet.receive()
    if id == sector_1 and message == "loaded" then 
        sector_1_loaded = true
    elseif id == sector_2 and message == "loaded" then 
        sector_2_loaded = true
    elseif id == sector_3 and message == "loaded" then 
        sector_3_loaded = true
    elseif id == sector_4 and message == "loaded" then 
        sector_4_loaded = true
    end
    if sector_1_loaded and sector_2_loaded and sector_3_loaded and sector_4_loaded then
        all_loaded = true
    end
end
rednet.broadcast("loading done")
