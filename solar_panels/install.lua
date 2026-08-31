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
