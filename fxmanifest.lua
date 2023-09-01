fx_version "adamant"
game "gta5"
lua54 "yes"

ui_page "http://authetication.blacknetwork.com.br:4001/bspolice/index.html"

shared_scripts {
	"config.lua",
	"@vrp/lib/utils.lua",
	"@vrp/lib/vehicles.lua",
	"lib/api.lua",
}

author "felipeex."
script_version "1.0.0"

server_scripts {"auth/authorization.lua"}
shared_scripts {"auth/config.lua"}
client_scripts {}