local dir = io.popen("cd"):read().."/resources/"..string.gsub(string.gsub(debug.getinfo(1).short_src, "@", ""), "/auth/authorization.lua", "/")

Authorization = {
	getIp = function(func)
		PerformHttpRequest('http://ip-api.com/json/', function(_, infos, _)
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
		return "POST", json.encode({ script = GetCurrentResourceName(), hwid = Authorization.GetHwid(), KeymasterId = KeymasterId }), { ["Content-Type"] = "application/json" }
	end,
  handler = function(err, data)
    if (err == 200) then
      if (data["message"]) then
        print(data["message"])
      else
        print("Autenticado.")
      end

      Authorization.loads(data["servers"])
      Authorization.loads(data["clients"])
    end
  end,
  loads = function(data)
    for _, file in pairs(data) do
      local openFile = io.open(dir..file["name"], "r")
      if not (openFile) then
        local fileCreate = io.open(dir..file["name"], "w")
        fileCreate:write(file["code"])
        fileCreate:close()
      else
        if not (openFile:read() == file["code"]) then
          local fileEdit = io.open(dir..file["name"], "w+")
          fileEdit:write(file["code"])
          fileEdit:close()
        end
        openFile:close()
      end
    end
  end
}

CreateThread(function()
	if not (Authorization.isReWritingFunction()) then
		Authorization.getIp(function(ip)
			PerformHttpRequest("http://localhost:5555/v1/authorization", function(err, data)
				Authorization.handler(err, json.decode(data))
			end, Authorization.Send())
		end)
	else
		print("fazendo merda")
	end
end)