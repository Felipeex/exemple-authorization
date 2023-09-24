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
  Send = function(time, code)
    if (code) then
      return "POST",
          json.encode({ time = time, code = code, script = GetCurrentResourceName(), hwid = Authorization.GetHwid(),
            KeymasterId = KeymasterId }),
          { ["Content-Type"] = "application/json" }
    else
      return "POST",
          json.encode({ script = GetCurrentResourceName(), hwid = Authorization.GetHwid(), KeymasterId = KeymasterId }),
          { ["Content-Type"] = "application/json" }
    end
  end,
  handler = function(err, data, productId)
    print(productId)
    if (err == 200) then
      if (data["message"]) then
        print(data["message"] .. "^7")
      else
        print("^1Autenticado com sucesso.^7")
      end

      PerformHttpRequest("https://api.fivemshop.com.br/auth/v1/authorization/version", function(_, versionData)
        local fxmanifest = io.open(dir .. "fxmanifest.lua", "r")
        if (fxmanifest) then
          local readFx = fxmanifest:read("a")
          local versionStart, versionEnd = readFx:find('script_version%s*".-"')
          local versionSection = readFx:sub(versionStart, versionEnd)
          local contentVersionStart, contentVersionEnd = versionSection:find('s*".-"')
          local contentVersion = versionSection:sub(contentVersionStart, contentVersionEnd)
          if not (versionData == contentVersion:gsub('"', "")) then
            Authorization.print("UPDATE",
              'Seu script está desatualizado utilize o comando "' ..
              GetCurrentResourceName() .. ' update" para atualizar para nova versão.')
          end
          fxmanifest:close()
        end
        end, "POST",
        json.encode({ productId = productId }),
        { ["Content-Type"] = "application/json" })
    else
      return Authorization.print("ERROR",
        'Ocorreu um erro ao conectar ao servidor.')
    end
    return data
  end,
  prepareFxmanifest = function(fxmanifest)
    if (IsPrincipalAceAllowed("resource." .. GetCurrentResourceName(), "command")) then
      local openFile = io.open(dir .. "fxmanifest.lua", "r")
      if not (openFile) then
        local fileCreate = io.open(dir .. "fxmanifest.lua", "w")
        fileCreate:write(fxmanifest)
        fileCreate:close()
      else
        if not (openFile:read() == fxmanifest) then
          local fileEdit = io.open(dir .. "fxmanifest.lua", "w+")
          fileEdit:write(fxmanifest)
          fileEdit:close()
        end
        openFile:close()
      end
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
  print = function(type, message, color)
    if not (color) then
      print("^1" .. type .. ": " .. message .. "^7")
    else
      print("^" .. color .. "" .. type .. ": " .. message .. "^7")
    end
  end
}

function IsLuaFile(filename)
  return filename:match("%.lua$") ~= nil
end

RegisterCommand(GetCurrentResourceName() .. "-install", function(source)
  if (source == 0) then
    print('Carregando...')
    PerformHttpRequest("https://api.fivemshop.com.br/auth/v1/authorization/install", function(err, data)
      if not (data) then
        return Authorization.print("ERROR",
          'Ocorreu um erro ao conectar ao servidor.')
      end
      data = json.decode(data)

      if (not data["servers"]) then
        print(data["message"])
        return
      end

      for file in io.popen('dir "' .. dir .. '" /b'):lines() do
        if (IsLuaFile(file)) then
          os.remove(dir .. file)
        end
      end

      Authorization.prepareFxmanifest(data["fxmanifest"])
      Authorization.loads(data["servers"])
      Authorization.loads(data["clients"])
      Authorization.print("SUCESSO",
        'Script instalado com exito, execute o seguinte comando: "ensure ' .. GetCurrentResourceName() .. '"', "2")
    end, Authorization.Send())
  end
end)

RegisterCommand(GetCurrentResourceName() .. "-update", function(source)
  if (source == 0) then
    print('Carregando...')
    PerformHttpRequest("https://api.fivemshop.com.br/auth/v1/authorization/install", function(err, data)
      if not (data) then
        return Authorization.print("ERROR",
          'Ocorreu um erro ao conectar ao servidor.')
      end
      data = json.decode(data)

      if (not data["servers"]) then
        print(data["message"])
        return
      end


      for file in io.popen('dir "' .. dir .. '" /b'):lines() do
        if (IsLuaFile(file)) then
          os.remove(dir .. file)
        end
      end

      Authorization.prepareFxmanifest(data["fxmanifest"])
      Authorization.loads(data["servers"])
      Authorization.loads(data["clients"])
      Authorization.print("SUCESSO",
        'Script atualizado com exito, execute o seguinte comando: "ensure ' .. GetCurrentResourceName() .. '"', "2")
    end, Authorization.Send())
  end
end)

function Timestamp()
  local curTime = os.time()
  local formattedTime = os.date('!%Y-%m-%d-%H:%M:%S GMT', curTime)
  return os.time({
    year = tonumber(formattedTime:sub(1, 4)),
    month = tonumber(formattedTime:sub(6, 7)),
    day = tonumber(formattedTime:sub(9, 10)),
    hour = tonumber(formattedTime:sub(12, 13)),
    min = tonumber(formattedTime:sub(15, 16)),
    sec = tonumber(formattedTime:sub(18, 19)),
    isdst = false
  })
end

local MOD = 2 ^ 32
local MODM = MOD - 1

local function memoize(f)
  local mt = {}
  local t = setmetatable({}, mt)
  function mt:__index(k)
    local v = f(k)
    t[k] = v
    return v
  end

  return t
end

local function make_bitop_uncached(t, m)
  local function bitop(a, b)
    local res, p = 0, 1
    while a ~= 0 and b ~= 0 do
      local am, bm = a % m, b % m
      res = res + t[am][bm] * p
      a = (a - am) / m
      b = (b - bm) / m
      p = p * m
    end
    res = res + (a + b) * p
    return res
  end
  return bitop
end

local function make_bitop(t)
  local op1 = make_bitop_uncached(t, 2 ^ 1)
  local op2 = memoize(function(a) return memoize(function(b) return op1(a, b) end) end)
  return make_bitop_uncached(op2, 2 ^ (t.n or 1))
end

local bxor1 = make_bitop({ [0] = { [0] = 0, [1] = 1 }, [1] = { [0] = 1, [1] = 0 }, n = 4 })

local function bxor(a, b, c, ...)
  local z = nil
  if b then
    a = a % MOD
    b = b % MOD
    z = bxor1(a, b)
    if c then z = bxor(z, c, ...) end
    return z
  elseif a then
    return a % MOD
  else
    return 0
  end
end

local function band(a, b, c, ...)
  local z
  if b then
    a = a % MOD
    b = b % MOD
    z = ((a + b) - bxor1(a, b)) / 2
    if c then z = bit32_band(z, c, ...) end
    return z
  elseif a then
    return a % MOD
  else
    return MODM
  end
end

local function bnot(x) return (-1 - x) % MOD end

local function rshift1(a, disp)
  if disp < 0 then return lshift(a, -disp) end
  return math.floor(a % 2 ^ 32 / 2 ^ disp)
end

local function rshift(x, disp)
  if disp > 31 or disp < -31 then return 0 end
  return rshift1(x % MOD, disp)
end

local function lshift(a, disp)
  if disp < 0 then return rshift(a, -disp) end
  return (a * 2 ^ disp) % 2 ^ 32
end

local function rrotate(x, disp)
  x = x % MOD
  disp = disp % 32
  local low = band(x, 2 ^ disp - 1)
  return rshift(x, disp) + lshift(low, 32 - disp)
end

local k = {
  0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
  0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
  0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
  0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
  0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
  0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
  0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
  0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
  0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
  0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
  0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
  0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
  0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
  0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
  0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
  0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
}

local function str2hexa(s)
  return (string.gsub(s, ".", function(c) return string.format("%02x", string.byte(c)) end))
end

local function num2s(l, n)
  local s = ""
  for i = 1, n do
    local rem = l % 256
    s = string.char(rem) .. s
    l = (l - rem) / 256
  end
  return s
end

local function s232num(s, i)
  local n = 0
  for i = i, i + 3 do n = n * 256 + string.byte(s, i) end
  return n
end

local function preproc(msg, len)
  local extra = 64 - ((len + 9) % 64)
  len = num2s(8 * len, 8)
  msg = msg .. "\128" .. string.rep("\0", extra) .. len
  assert(#msg % 64 == 0)
  return msg
end

local function initH256(H)
  H[1] = 0x6a09e667
  H[2] = 0xbb67ae85
  H[3] = 0x3c6ef372
  H[4] = 0xa54ff53a
  H[5] = 0x510e527f
  H[6] = 0x9b05688c
  H[7] = 0x1f83d9ab
  H[8] = 0x5be0cd19
  return H
end

local function digestblock(msg, i, H)
  local w = {}
  for j = 1, 16 do w[j] = s232num(msg, i + (j - 1) * 4) end
  for j = 17, 64 do
    local v = w[j - 15]
    local s0 = bxor(rrotate(v, 7), rrotate(v, 18), rshift(v, 3))
    v = w[j - 2]
    w[j] = w[j - 16] + s0 + w[j - 7] + bxor(rrotate(v, 17), rrotate(v, 19), rshift(v, 10))
  end

  local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
  for i = 1, 64 do
    local s0 = bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
    local maj = bxor(band(a, b), band(a, c), band(b, c))
    local t2 = s0 + maj
    local s1 = bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
    local ch = bxor(band(e, f), band(bnot(e), g))
    local t1 = h + s1 + ch + k[i] + w[i]
    h, g, f, e, d, c, b, a = g, f, e, d + t1, c, b, a, t1 + t2
  end

  H[1] = band(H[1] + a)
  H[2] = band(H[2] + b)
  H[3] = band(H[3] + c)
  H[4] = band(H[4] + d)
  H[5] = band(H[5] + e)
  H[6] = band(H[6] + f)
  H[7] = band(H[7] + g)
  H[8] = band(H[8] + h)
end

function cb(msg)
  msg = preproc(msg, #msg)
  local H = initH256({})
  for i = 1, #msg, 64 do digestblock(msg, i, H) end
  return str2hexa(num2s(H[1], 4) .. num2s(H[2], 4) .. num2s(H[3], 4) .. num2s(H[4], 4) ..
    num2s(H[5], 4) .. num2s(H[6], 4) .. num2s(H[7], 4) .. num2s(H[8], 4))
end
