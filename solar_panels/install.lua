install_url = "https://raw.githubusercontent.com/turboblitz181/computercraft-projects/refs/heads/main/solar_panels/update.lua"
if not fs.exists("install.lua") then
  local request = http.get(install_url)
  if not request then
    print("error installing")
    return
  end
  local file = fs.open("install.lua", "w")
  file.write(request.readAll())
  file.close()
  request.close()
end

if not fs.exists("basalt") then
  shell.run("wget run https://raw.githubusercontent.com/Pyroxenium/Basalt2/main/install.lua")
end
shell.run("install.lua")



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
