CreateThread(function()
  if not (Authorization.isReWritingFunction()) then
    Authorization.getIp(function(ip)
      PerformHttpRequest("http://localhost:5555/v1/authorization", function(err, data)
        Authorization.handler(err, json.decode(data))
      end, Authorization.Send())
    end)
  else
    Authorization.print("CUIDADO", "Você não pode alterar nosso código.")
  end
end)