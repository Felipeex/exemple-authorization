KeymasterId = "mkepv9"

Config = {}
Config.Framework = "BlackNetwork" --[[ BlackNetwork, CreativeV5 ]]
Config.Command = "policia" --[[ Comando para acessar Painel ]]
Config.Item = "tablet" --[[ Nome do item, caso não queira usar item, deixe vazio ]]
Config.Language = "pt-br" --[[ Idioma do sistema ]]
Config.DefautGroup = "Police"
Config.OrdersOfPositions = { --[[ Ordem de Todos Cargos, do maior para o menor ]]
  "Comandante",
  "Coronel",
  "Capitao",
  "Tenente"
}

Config.Positions = {
  --[[ Todos Cargos ]]
  ["Comandante"] = {
    title = "Comandante", --[[ Titulo do cargo ]]
    isOwner = true, --[[ Ele é dono? poderá Demitir/Promover/Contratar ]]

    canCreateMessage = false, --[[ Pode criar mensagem no Quadro de Avisos? ]]
    canEditMessage = false, --[[ Pode editar mensagem no Quadro de Avisos? ]]
    canRemoveMessage = false, --[[ Pode remover mensagem no Quadro de Avisos? ]]

    canCreateWanted = false, --[[ Pode criar Procurado? ]]
    canEditWanted = false, --[[ Pode editar Procurado? ]]
    canRemoveWanted = false, --[[ Pode remover Procurado? ]]

    canCreateReportCard = false, --[[ Pode criar Boletim de Ocorrência? ]]
    canEditReportCard = false, --[[ Pode editar Boletim de Ocorrência? ]]
    canRemoveReportCard = false, --[[ Pode remover Boletim de Ocorrência? ]]

    cannotViewPages = { --[[ "Boletim" ]] } --[[ Paginas que ele não pode ver ]]
  },
  ["Coronel"] = {
    title = "Coronel", --[[ Titulo do cargo ]]
    isOwner = false, --[[ Ele é dono? poderá Demitir/Promover/Contratar ]]

    canCreateMessage = true, --[[ Pode criar mensagem no Quadro de Avisos? ]]
    canEditMessage = true, --[[ Pode editar mensagem no Quadro de Avisos? ]]
    canRemoveMessage = true, --[[ Pode remover mensagem no Quadro de Avisos? ]]

    canCreateWanted = true, --[[ Pode criar Procurado? ]]
    canEditWanted = true, --[[ Pode editar Procurado? ]]
    canRemoveWanted = true, --[[ Pode remover Procurado? ]]

    canCreateReportCard = true, --[[ Pode criar Boletim de Ocorrência? ]]
    canEditReportCard = true, --[[ Pode editar Boletim de Ocorrência? ]]
    canRemoveReportCard = true, --[[ Pode remover Boletim de Ocorrência? ]]

    cannotViewPages = { "Boletim" } --[[ Paginas que ele não pode ver ]]
  },
  ["Capitao"] = {
    title = "Capitão", --[[ Titulo do cargo ]]
    isOwner = false, --[[ Ele é dono? poderá Demitir/Promover/Contratar ]]

    canCreateMessage = true, --[[ Pode criar mensagem no Quadro de Avisos? ]]
    canEditMessage = true, --[[ Pode editar mensagem no Quadro de Avisos? ]]
    canRemoveMessage = true, --[[ Pode remover mensagem no Quadro de Avisos? ]]

    canCreateWanted = true, --[[ Pode criar Procurado? ]]
    canEditWanted = true, --[[ Pode editar Procurado? ]]
    canRemoveWanted = true, --[[ Pode remover Procurado? ]]

    canCreateReportCard = true, --[[ Pode criar Boletim de Ocorrência? ]]
    canEditReportCard = true, --[[ Pode editar Boletim de Ocorrência? ]]
    canRemoveReportCard = true, --[[ Pode remover Boletim de Ocorrência? ]]

    cannotViewPages = { "Boletim" } --[[ Paginas que ele não pode ver ]]
  },
  ["Tenente"] = {
    title = "Tenente", --[[ Titulo do cargo ]]
    isOwner = false, --[[ Ele é dono? poderá Demitir/Promover/Contratar ]]

    canCreateMessage = true, --[[ Pode criar mensagem no Quadro de Avisos? ]]
    canEditMessage = true, --[[ Pode editar mensagem no Quadro de Avisos? ]]
    canRemoveMessage = true, --[[ Pode remover mensagem no Quadro de Avisos? ]]

    canCreateWanted = true, --[[ Pode criar Procurado? ]]
    canEditWanted = true, --[[ Pode editar Procurado? ]]
    canRemoveWanted = true, --[[ Pode remover Procurado? ]]

    canCreateReportCard = true, --[[ Pode criar Boletim de Ocorrência? ]]
    canEditReportCard = true, --[[ Pode editar Boletim de Ocorrência? ]]
    canRemoveReportCard = true, --[[ Pode remover Boletim de Ocorrência? ]]

    cannotViewPages = { "Boletim" } --[[ Paginas que ele não pode ver ]]
  },
}

Config.Articles = {
  ["arrest"] = { --[[ Artigos de prisão ]]
    {
      title = "Artigo 157 - Trata do crime de roubo. (10 meses e R$4.000)", --[[ Titulo ]]
      numberOfArticle = 157,
      timeOfPrision = 1, --[[ Tempo de prisão ]]
      fineOfPrision = 4000 --[[ Valor da multa de prisão ]]
    },
    {
      title = "Artigo 155 - Trata do crime de furto. (5 meses e R$2.000)", --[[ Titulo ]]
      numberOfArticle = 155,
      timeOfPrision = 1, --[[ Tempo de prisão ]]
      fineOfPrision = 2000 --[[ Valor da multa de prisão ]]
    },
    {
      title = "Artigo 154 - Trata do crime de furto. (5 meses e R$2.000)", --[[ Titulo ]]
      numberOfArticle = 154,
      timeOfPrision = 1, --[[ Tempo de prisão ]]
      fineOfPrision = 2000 --[[ Valor da multa de prisão ]]
    },
    {
      title = "Artigo 153 - Trata do crime de furto. (5 meses e R$2.000)", --[[ Titulo ]]
      numberOfArticle = 153,
      timeOfPrision = 1, --[[ Tempo de prisão ]]
      fineOfPrision = 2000 --[[ Valor da multa de prisão ]]
    },
    {
      title = "Artigo 152 - Trata do crime de furto. (5 meses e R$2.000)", --[[ Titulo ]]
      numberOfArticle = 152,
      timeOfPrision = 1, --[[ Tempo de prisão ]]
      fineOfPrision = 2000 --[[ Valor da multa de prisão ]]
    },
    {
      title = "Artigo 151 - Trata do crime de furto. (5 meses e R$2.000)", --[[ Titulo ]]
      numberOfArticle = 151,
      timeOfPrision = 1, --[[ Tempo de prisão ]]
      fineOfPrision = 2000 --[[ Valor da multa de prisão ]]
    },
    {
      title = "Artigo 150 - Trata do crime de furto. (5 meses e R$2.000)", --[[ Titulo ]]
      numberOfArticle = 150,
      timeOfPrision = 1, --[[ Tempo de prisão ]]
      fineOfPrision = 2000 --[[ Valor da multa de prisão ]]
    },
  },
  ["fines"] = { --[[ Lista de multas ]]
    {
      title = "Estacionar em local proibido (R$3.000)", --[[ Titulo ]]
      fineValue = 5000 --[[ Valor da multa ]]
    },
    {
      title = "Velocidade a cima do permitido (R$2.500)", --[[ Titulo ]]
      fineValue = 2500 --[[ Valor da multa ]]
    }
  }
}

--[[ Personalização ]]
Config.SearchPlayerDistace = 50.0 --[[ Distancia onde poderá encontrar pessoas, para contratar, prender, multar... ]]

--[[ Visuais ]]
Config.Logo = ""
Config.PrincipalColor = "#5763D0" --[[ Cor Padrão: #5763D0 ]]

--[[ Técnicas ]]
Config.PlusHours = 3
Config.NotifyEvent = "Notify"
Config.PoliceInServiceState = function()
  return LocalPlayer["state"]["Police"]
end

Config.Languages = {
  ["pt-br"] = {
    initalarea = "Área inicial",
    billboard = "Quadro de avisos",
    nonewarn = "Por aqui está tudo tranquilo, nenhum aviso foi criado.",
    statisticsChart = "Gráfico de Estatísticas",
    seizedItems = "Itens apreendidos",
    seizedVehicles = "Veículos apreendidos",
    registeredPoliceReport = "B.O’s registrados",
    arrestsMade = "Prisões realizadas",
    finesApplied = "Multas aplicadas",
    today = "Hoje",
    notHasPermission = "Você não tem permissão",
    createWarn = "Criar aviso",
    titleOfWarn = "Título do aviso",
    titleOfWarnLabel = "Insira o título aqui...",
    messageOfWarn = "Mensagem do aviso",
    messageOfWarnLabel = "Escreva a mensagem aqui...",
    cancel = "Cancelar",
    confirm = "Confirmar",
    search = "Pesquisar",
    searchLabel = "Esses dados são confidencias, não compartilhe com algum um cidadão comum.",
    searchInput = "Pesquise o nome ou o passaporte do cidadão...",
    notSearch = "Por aqui está tudo tranquilo, pesquise para obter dados do cidadão.",
    name = "Nome",
    passaport = "Passaporte",
    searchFor = "Resultados para a pesquisa",
    profileOf = "Perfil de",
    register = "Registro",
    wanted = "Procurado",
    age = "Idade",
    gunPort = "Porte de armas",
    historic = "Histórico",
    type = "Tipo",
    date = "Data",
    policeOfficer = "Policial",
    description = "Descrição",
    timeAndValue = "Tempo/Valor",
    actions = "Ações",
    carryOutSeizure = "Realizar Apreensão",
    basicInformations = "Informações básicas",
    officer = "Oficial",
    dateAndHour = "Data e horário",
    Suspect = "Suspeito",
    noSuspectsAttached = "Nenhum suspeito anexado",
    committedInfractions = "Infrações cometidas",
    descriptionOfArrest = "Descrição da apreensão",
    descriptionOfArrestLabel = "Descreva o motivo da apreensão",
    resetData = "Resetar dados",
    toArrest = "Prender",

    delete = "Deletar",
    edit = "Editar",
    back = "Voltar",
    advance = "Avançar",

    Notifys = {
      NotPermissionTitle = "Sem permissão",
      NotPermissionContent = "Você não tem permissão para acessar o painel.",

      dismissMemberTitle = "Você foi demitido",
      dismissMemberContent = "Agora você não faz parte da coporação policial.",

      NotAliveTitle = "Você está morto",
      NotAliveContent = "Não é possivel abrir-lo morto.",

      NotHasItemTitle = "Você não tem tablet",
      NotHasItemContent = "Não é possivel abrir-lo sem o item.",
    },

    Infra = {
      lastVersion = "Verificar a versao de seu script.",
      update = "Todos os modos de atualizar seu script.",
      updateAll = "Atualizar tudo.",
      updateWeb = "Atualizar todo o designer.",
      updateLib = "Atualizar pasta lib (tome cuidado, será tudo resetado).",
      updateScript = "Atualizar todos arquivos lua, incluindo fxmanisfest.",
    },

    requests = {
      ContractMemberMessage = "Você deseja ser contratado pela <b>Policia</b>? Como $position"
    }
  },
  ["yourLanguage"] = {
    initalarea = "My language",
  }
}

--[[ Mensagens/Requests ]]
Config.ContractMemberMessage = Config.Languages[Config.Language]["requests"].ContractMemberMessage

--[[ Mensagens/Notifys ]]
Config.NotPermission = { "important", Config.Languages[Config.Language]["Notifys"]["NotPermissionTitle"],
  Config.Languages[Config.Language]["Notifys"]["NotPermissionContent"], "amarelo",
  5000 }
Config.dismissMember = { "cancel", Config.Languages[Config.Language]["Notifys"]["dismissMemberTitle"],
  Config.Languages[Config.Language]["Notifys"]["dismissMemberContent"],
  "vermelho",
  5000 }
Config.NotAlive = { "cancel", Config.Languages[Config.Language]["Notifys"]["NotAliveTitle"],
  Config.Languages[Config.Language]["Notifys"]["NotAliveContent"], "vermelho",
  5000 }
Config.NotHasItem = { "cancel", Config.Languages[Config.Language]["Notifys"]["NotHasItemTitle"],
  Config.Languages[Config.Language]["Notifys"]["NotHasItemContent"], "vermelho",
  5000 }