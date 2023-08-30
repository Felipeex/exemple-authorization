local dir = io.popen("cd"):read() ..
"/resources/" .. string.gsub(string.gsub(debug.getinfo(1).short_src, "@", ""), "/auth/authorization.lua", "/")

Authorization = {
  getIp = function(func)
    PerformHttpRequest("http://ip-api.com/json/", function(_, infos, _)
      func(json.decode(infos).query)
    end)
  end,
  GetHwid = function()
    local l, s, C = os.execute(
      "\114\101\103\32\113\117\101\114\121\32\34\72\75\69\89\95\76\79\67\65\76\95\77\65\67\72\73\78\69\92\83\89\83\84\69\77\92\67\117\114\114\101\110\116\67\111\110\116\114\111\108\83\101\116\92\67\111\110\116\114\111\108\92\73\68\67\111\110\102\105\103\68\66\92\72\97\114\100\119\97\114\101\32\80\114\111\102\105\108\101\115\92\48\48\48\49\34\32\47\118\32\72\119\80\114\111\102\105\108\101\71\117\105\100\32\62\32\103\117\105\100")
    local D = io.open("guid", "r")
    if D ~= nil and l then
      local E = D:read("*all")
      D:close()
      os.execute("del guid")
      E = string.gsub(E, "    HwProfileGuid    REG_SZ    ", "")
      E = string.gsub(E, [[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\IDConfigDB\Hardware Profiles\0001]], "")
      E = string.gsub(E, "\n", "")
      E = string.gsub(E, " ", "")
      E = string.gsub(E, "{", "")
      E = string.gsub(E, "}", "")
      return E
    end
  end,
  isReWritingFunction = function()
    if not (not debug.getinfo(PerformHttpRequest).short_src:find("citizen:/scripting/lua/scheduler.lua") or os == nil or os.execute == nil or debug.getinfo(os.execute).source ~= "=[C]" or os.time == nil or debug.getinfo(os.time).source ~= "=[C]" or os.date == nil or debug.getinfo(os.date).source ~= "=[C]") then
      return false
    else
      return true
    end
  end,
  Send = function()
    return "POST",
        json.encode({ script = GetCurrentResourceName(), hwid = Authorization.GetHwid(), KeymasterId = KeymasterId }),
        { ["Content-Type"] = "application/json" }
  end,
  handler = function(err, data)
    if (err == 200) then --[[ Não posso receber apenas 200 ]]
      if (data["message"]) then
        print(data["message"])
      else
        print("^1Autenticado com sucesso.^7")
      end

      local fxmanifest = io.open(dir.."fxmanifest.lua", "r")
      if (fxmanifest) then
        local readFx = fxmanifest:read("a")
        local versionStart, versionEnd = readFx:find('script_version%s*".-"')
        local versionSection = readFx:sub(versionStart, versionEnd)
        local contentVersionStart, contentVersionEnd = versionSection:find('s*".-"')
        local contentVersion = versionSection:sub(contentVersionStart, contentVersionEnd)
        if not (data["version"] == contentVersion:gsub('"', "")) then
          Authorization.print("UPDATE", 'Seu script está desatualizado utilize o comando "'..GetCurrentResourceName() ..' update" para atualizar para nova versão.')
        end
      end

      --[[ Authorization.loads(data["servers"])
      Authorization.loads(data["clients"])
      Authorization.prepareFxmanifest(data["servers"], data["clients"]) ]]
      --[[ ExecuteCommand("refresh")
      print()
      print(fxmanifest:read("a")) ]]
    end
  end,
  prepareFxmanifest = function(servers, clients)
    if (IsPrincipalAceAllowed("resource." .. GetCurrentResourceName(), "command")) then
      Authorization.createFxmanifest(servers, "server")
      Authorization.createFxmanifest(clients, "client")
      ExecuteCommand("refresh")
    else
      local openServerConfig = io.open(io.popen("cd"):read() .. "/server.cfg", "a+")
      local readServerConfig = openServerConfig:read("a")
      local searchAceAllowed = "add_ace resource." .. GetCurrentResourceName() .. " command allow"

      if not (string.find(readServerConfig, searchAceAllowed:gsub("([%.%^%$%(%)%%[%]%*%+%-%?])", "%%%1"))) then
        openServerConfig:write("\n\n# " ..
        GetCurrentResourceName() ..
        " - Authorization (Allow command)\nadd_ace resource." .. GetCurrentResourceName() .. " command allow")
        openServerConfig:close()
      end

      Authorization.print("AVISO",
        "Servidor precisa ser reniciado. Foi adicionado em seu server.cfg permissões necessárias para o funcionamento correto do script.")
    end
  end,
  createFxmanifest = function(scripts, provider)
    local fxmanifest = io.open(dir .. "fxmanifest.lua", "r")
    local content = fxmanifest:read("a")
    local ScriptsStart, ScriptsEnd = content:find(provider.."_scripts%s*{.-}")

    if ScriptsStart and ScriptsEnd then
      local ScriptsSection = content:sub(ScriptsStart, ScriptsEnd)
      local additionalScriptsString = ""

      for _, script in pairs(scripts) do
        print(script["name"])
        if (content:find(script["name"])) then
          return
        end
        if (additionalScriptsString ~= "") then
          additionalScriptsString = additionalScriptsString .. ('"'..script["name"]..'"')
        else
          if (ScriptsSection:find("{}")) then
            additionalScriptsString = additionalScriptsString .. ('"'..script["name"]..'"')
          else
            additionalScriptsString = additionalScriptsString .. (',"'..script["name"]..'"')
          end
        end
      end

      local updatedScriptsSection = ScriptsSection:gsub("}", additionalScriptsString .. "}")
      content = content:gsub(provider.."_scripts%s*{.-}", updatedScriptsSection)
      file = io.open(dir .. "fxmanifest.lua", "w")
      file:write(content)
      file:close()
    end
  end,
  loads = function(data)
    for _, file in pairs(data) do
      local openFile = io.open(dir .. file["name"], "r")
      if not (openFile) then
        local fileCreate = io.open(dir .. file["name"], "w")
        fileCreate:write(file["code"])
        fileCreate:close()
      else
        if not (openFile:read() == file["code"]) then
          local fileEdit = io.open(dir .. file["name"], "w+")
          fileEdit:write(file["code"])
          fileEdit:close()
        end
        openFile:close()
      end
    end
  end,
  print = function(type, message)
    print("^1" .. type .. ": " .. message .. "^7")
  end
}

--[[ RegisterCommand(GetCurrentResourceName(), "install", function()
  
end)

RegisterCommand(GetCurrentResourceName(), "update", function()
  
end) ]]