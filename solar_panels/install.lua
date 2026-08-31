main_startup_url = "https://raw.githubusercontent.com/turboblitz181/computercraft-projects/refs/heads/main/solar_panels/main_computer/startup.lua?token=GHSAT0AAAAAAEAEAEUOKOYPKJGTWT46M6VW2UVJURA"
sector_1_startup_url = "https://raw.githubusercontent.com/turboblitz181/computercraft-projects/refs/heads/main/solar_panels/sector_1/startup.lua?token=GHSAT0AAAAAAEAEAEUOXEDP2G5CU4R2BQVK2UVJVFQ"

local basalt = require("basalt")

local main = basalt.getMainFrame()


main:addButton():setText("main startup"):setPosition(2, 2):onClick(function(self)
        local request = http.get(main_startup_url)
        if not request then
            self:setText("error installing!")
            return
        end
        local file = fs.open("startup.lua", "w")
        file.write(request.readAll())
        file.close()
        request.close()
        self:setText("installed!")
    end)

main:addButton():setText("sector1 startup"):setPosition(2, 4):onClick(function(self)
        local request = http.get(sector_1_startup_url)
        if not request then
            self:setText("error installing!")
            return
        end
        local file = fs.open("startup.lua", "w")
        file.write(request.readAll())
        file.close()
        request.close()
        self:setText("installed!")
    end)

main:addButton():setText("sector 2 startup"):setPosition(2, 6):onClick(function(self)
        local request = http.get(sector_2_startup_url)
        if not request then
            self:setText("error installing!")
            return
        end
        local file = fs.open("startup.lua", "w")
        file.write(request.readAll())
        file.close()
        request.close()
        self:setText("installed!")
    end)
