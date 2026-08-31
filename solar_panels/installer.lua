main_startup_url = "https://raw.githubusercontent.com/turboblitz181/computercraft-projects/refs/heads/main/solar_panels/main_computer/startup.lua"
sector_startup_url = "https://raw.githubusercontent.com/turboblitz181/computercraft-projects/refs/heads/main/solar_panels/sectors/startup.lua"
old_sector_url = "https://raw.githubusercontent.com/turboblitz181/computercraft-projects/refs/heads/main/solar_panels/old%20sector%20code/startup.lua"

local basalt = require("basalt")
local main = basalt.getMainFrame()
main:addLabel():setText("solar panel installer"):setPosition(16,2)
main:addButton():setText("main startup"):setPosition(20,5):setSize(15,2):onClick(function(self)
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

main:addButton():setText("sector startup"):setPosition(20, 7):setSize(15,2):onClick(function(self)
        local request = http.get(sector_startup_url)
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

main:addButton():setText("old sector startup"):setPosition(17, 13):setSize(20,2):onClick(function(self)
        local request = http.get(old_sector_url)
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

basalt.run()
