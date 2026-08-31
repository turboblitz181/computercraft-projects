installer_url = "https://raw.githubusercontent.com/turboblitz181/computercraft-projects/refs/heads/main/solar_panels/installer.lua"
if not fs.exists("installer.lua") then
  local request = http.get(installer_url)
  if not request then
    print("error installing")
    return
  end
  local file = fs.open("installer.lua", "w")
  file.write(request.readAll())
  file.close()
  request.close()
end

if not fs.exists("basalt") then
  shell.run("wget run https://raw.githubusercontent.com/Pyroxenium/Basalt2/main/install.lua")
end
