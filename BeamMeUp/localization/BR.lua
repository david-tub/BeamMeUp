local mkstr = ZO_CreateStringId
local SI = BMU.SI

-----------------------------------------------------------------------------
-- INTERFACE
-----------------------------------------------------------------------------
mkstr(SI.TELE_UI_TOTAL, "Resultados:")
mkstr(SI.TELE_UI_GOLD, "Ouro Salvo:")
mkstr(SI.TELE_UI_GOLD_ABBR, "k")
mkstr(SI.TELE_UI_GOLD_ABBR2, "m")
mkstr(SI.TELE_UI_TOTAL_PORTS, "Total Portas:")
---------
--------- Buttons
mkstr(SI.TELE_UI_BTN_REFRESH_ALL, "Atualizar a lista de resultados.")
mkstr(SI.TELE_UI_BTN_UNLOCK_WS, "Desbloquear Santuários na Zona atual")
mkstr(SI.TELE_UI_BTN_FIX_WINDOW, "Corrigir / Prefixar janela")
mkstr(SI.TELE_UI_BTN_TOGGLE_ZONE_GUIDE, "Trocar para BeamMeUp")
mkstr(SI.TELE_UI_BTN_TOGGLE_BMU, "Trocar para Guia de Zona")
mkstr(SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE, "Casa Própria")
mkstr(SI.TELE_UI_BTN_ANCHOR_ON_MAP, "IU Desbloqueada")
mkstr(SI.TELE_UI_BTN_GUILD_BMU, "Guildas BeamMeUp e Guildas de Parceiros")
mkstr(SI.TELE_UI_BTN_GUILD_HOUSE_BMU, "Visite Casa da Guilda BeamMeUp")
mkstr(SI.TELE_UI_BTN_PTF_INTEGRATION, "\"Viaje para casa do Amigo\" Integração")
mkstr(SI.TELE_UI_BTN_DUNGEON_FINDER, "Arenas / Provações / Masmorras")
mkstr(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU, "\n|c777777(click com botão direito p/ mais informações)")
---------
--------- List
mkstr(SI.TELE_UI_UNRELATED_ITEMS, "Mapas em outras zonas")
mkstr(SI.TELE_UI_UNRELATED_QUESTS, "Missões em outras zonas")
mkstr(SI.TELE_UI_SAME_INSTANCE, "Mesma Instância")
mkstr(SI.TELE_UI_DIFFERENT_INSTANCE, "Instância Diferentes")
---------
--------- Menu
mkstr(SI.TELE_UI_FAVORITE_PLAYER, "Jogador Favorito")
mkstr(SI.TELE_UI_FAVORITE_ZONE, "Zona Favorita")
mkstr(SI.TELE_UI_REMOVE_FAVORITE_PLAYER, "Remover Jogador Favorito")
mkstr(SI.TELE_UI_REMOVE_FAVORITE_ZONE, "Remover Zona Favorita")
mkstr(SI.TELE_UI_VOTE_TO_LEADER, "Votar o Lider")
mkstr(SI.TELE_UI_RESET_COUNTER_ZONE, "Redefinir contador")
mkstr(SI.TELE_UI_INVITE_BMU_GUILD, "Convidar para BeamMeUp Guild")
mkstr(SI.TELE_UI_SHOW_QUEST_MARKER_ON_MAP, "Mostrar marcador de missão")
mkstr(SI.TELE_UI_RENAME_HOUSE_NICKNAME, "Renomear apelido da casa")
mkstr(SI.TELE_UI_TOGGLE_HOUSE_NICKNAME, "Mostre apelidos")
mkstr(SI.TELE_UI_VIEW_MAP_ITEM, "Exibir item do mapa")
mkstr(SI.TELE_UI_TOGGLE_ARENAS, "Arenas Solo")
mkstr(SI.TELE_UI_TOGGLE_GROUP_ARENAS, "Arenas em Groupo")
mkstr(SI.TELE_UI_TOGGLE_TRIALS, "Provações")
mkstr(SI.TELE_UI_TOGGLE_GROUP_DUNGEONS, "Masmorras em Grupo")
mkstr(SI.TELE_UI_TOGGLE_SORT_ACRONYM, "Classificar por acrônimo")
mkstr(SI.TELE_UI_DAYS_LEFT, "%d dias restantes")
mkstr(SI.TELE_UI_TOGGLE_UPDATE_NAME, "Show update name")
mkstr(SI.TELE_UI_UNLOCK_WAYSHRINES, "Descoberta automática de santuários")
mkstr(SI.TELE_UI_SUBMENU_FAVORITES, "Favoritos")
mkstr(SI.TELE_UI_TOOGLE_ZONE_NAME, "Show zone name")
mkstr(SI.TELE_UI_TOGGLE_SORT_RELEASE, "Sort by release")
mkstr(SI.TELE_UI_TOGGLE_ACRONYM, "Show acronym")
mkstr(SI.TELE_UI_TOOGLE_DUNGEON_NAME, "Show instance name")



-----------------------------------------------------------------------------
-- CHAT OUTPUTS
-----------------------------------------------------------------------------
mkstr(SI.TELE_CHAT_FAVORITE_UNSET, "Espaço favorito não definido")
mkstr(SI.TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL, "O jogador está offline ou oculto por filtros definidos")
mkstr(SI.TELE_CHAT_NO_FAST_TRAVEL, "Não é encontrada uma opção de viagem rápida")
mkstr(SI.TELE_CHAT_NOT_IN_GROUP, "Você não está em um grupo")
mkstr(SI.TELE_CHAT_PORT_TO_OWN_PRIMARY_HOUSE_FAILED, "Nenhum residência principal!")
mkstr(SI.TELE_CHAT_GROUP_LEADER_YOURSELF, "Você é o líder do grupo")
mkstr(SI.TELE_CHAT_UNLOCK_WS_DISCOVERED_TOTAL, "Total de Santuários descobertos nessa Zona:")
mkstr(SI.TELE_CHAT_UNLOCK_WS_NEED_DISCOVERED, "Os seguintes Santuários ainda precisam ser visitados fisicamente:")
mkstr(SI.TELE_CHAT_SHARING_FOLLOW_LINK, "Seguindo o link ...")
mkstr(SI.TELE_CHAT_AUTO_UNLOCK_CANCELED, "Descoberta automática cancelada pelo usuário.")
mkstr(SI.TELE_CHAT_AUTO_UNLOCK_SKIP, "Erro de viagem rápida: pule o jogador atual.")



-----------------------------------------------------------------------------
-- SETTINGS
-----------------------------------------------------------------------------
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN, "Abra o BeamMeUp quando o mapa é aberto")
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP, "Quando você abre o mapa, o BeamMeUp será automaticamente aberto, caso contrário, você verá um botão no mapa superior esquerdo e também um botão de troca na janela de conclusão do mapa.")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY, "Mostrar cada zona apenas uma vez")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP, "Mostrar apenas uma lista para cada zona.")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ, "Frequência de desvios de Santuários (ms)")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP, "Ajuste a frequência do desbloqueio automático de Wayshrine. Para computadores lentos ou para evitar possíveis chutes do jogo, um valor mais alto pode ajudar.")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH, "Atualizar e redefinir na abertura")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP, "Atualize a lista de resultados toda vez que você abrir o BeamMeUp. Campos de entrada são limpos.")
mkstr(SI.TELE_SETTINGS_HEADER_BLACKLISTING, "Lista negra")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS, "Esconder várias zonas inacessíveis")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP, "Esconder zonas como Maelstrom Arena, Outlaw Refuges e Zonas Solo.")
mkstr(SI.TELE_SETTINGS_HIDE_PVP, "Ocultar zonas PVP.")
mkstr(SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP, "Esconder zonas como Cyrodiil, Cidade Imperial e Campo de Batalha.")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS, "Ocultar Masmorras e Provações")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP, "Ocultar todos os 4 membros do grupo de Masmorras, 12 membros de Provações em Craglorn. Os membros do grupo nessas zonas ainda serão exibidos!")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES, "Esconder casas")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP, "Esconder todas as casas.")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY, "Mantenha o BeamMeUp Aberto")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP, "Quando você abre BeamMeUp sem o mapa, ele permanecerá mesmo se você mover ou abrir outras janelas. Se você usar esta opção, é recomendável desativar a opção 'fechar BeamMeup com o mapa'.")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS, "Mostrar apenas regiões/zonas terrestres")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP, "Mostrar apenas as principais regiões como Deshaan ou Summerset.")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ, "Intervalo de atualização (s)")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP, "Quando o BeamMeUp está aberto, uma atualização automática da lista de resultados é executada a cada x segundos. Defina o valor para 0 para desativar a atualização automática.")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN, "Concentre a caixa de pesquisa de zona")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP, "Concentre a caixa de pesquisa de zona quando o BeamMeUp é aberto junto com o mapa.")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES, "Esconder Covis.")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP, "Esconda todos os Covis.")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS, "Esconder Masmorras Públicas")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP, "Esconder todas as Masmorras Públicas.")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME, "Ocultar nomes de artigos de zona")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP, "Ocultar os nomes dos artigos de zona para garantir uma melhor classificação para encontrar zonas mais rapidamente.")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES, "Número de linhas/listagens")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP, "Ao definir o número de linhas/listagens visíveis, você pode controlar a altura total do addon.")
mkstr(SI.TELE_SETTINGS_HEADER_ADVANCED, "Recursos extras")
mkstr(SI.TELE_SETTINGS_HEADER_UI, "Geral")
mkstr(SI.TELE_SETTINGS_HEADER_RECORDS, "Listagens")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING, "Auto Fechar Mapa e BeamMeUp")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP, "Feche o mapa e o BeamMeUp após o início do processo de viagem.")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS, "Mostrar número de jogadores por mapa")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP, "Exibe o número de jogadores por mapa, você pode portar. Você pode clicar no número para ver todos esses jogadores.")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET, "Deslocamento do botão na caixa de chat")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP, "Aumente o deslocamento horizontal do botão no cabeçalho da caixa de chat para evitar conflitos visuais com outros ícones do Addon.")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES, "Também procurar nomes de personagens")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP, "Também procure por nomes de personagens ao pesquisar jogadores.")
mkstr(SI.TELE_SETTINGS_SORTING, "Ordenação")
mkstr(SI.TELE_SETTINGS_SORTING_TOOLTIP, "Escolha um dos tipos possíveis da lista.")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE, "Segunda Linguagem de Pesquisa")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP, "Você pode pesquisar por nomes de zona na sua linguagem cliente e este segundo idioma ao mesmo tempo. A dica de ferramenta do nome da zona também é o nome no segundo idioma.")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE, "Notificação de Jogador favorito online")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP, "Você recebe uma notificação (mensagem de tela central) quando um jogador favorito esta online.")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE, "Feche o BeamMeUp quando o mapa estiver fechado")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP, "Quando você fecha o mapa, o BeamMeUp também fecha.")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL, "Deslocamento da doca do mapa - Horizontal")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP, "Aqui você pode personalizar o deslocamento horizontal do encaixe no mapa.")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL, "Deslocamento da doca do mapa - Vertical")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP, "Aqui você pode personalizar o deslocamento vertical do encaixe no mapa.")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS, "Redefinir todos os contadores de zona")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP, "Todos os contadores de zona são redefinidos. Portanto, a classificação pela maioria usada é redefinida.")
mkstr(SI.TELE_SETTINGS_OFFLINE_NOTE, "Lembrete offline")
mkstr(SI.TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP, "Se você ficar off-line por um tempo e sussurrar ou viajar para alguém, receberá uma mensagem na tela. Enquanto estiver configurado para offline, você não pode receber mensagens de sussurro e ninguém pode viajar até você (mas compartilhar é importante).")
mkstr(SI.TELE_SETTINGS_SCALE, "Dimensionamento UI")
mkstr(SI.TELE_SETTINGS_SCALE_TOOLTIP, "Fator de escala para a interface completa/janela de BeamMeUp. Uma reinicio da UI é necessária para aplicar alterações.")
mkstr(SI.TELE_SETTINGS_RESET_UI, "Redefinir UI")
mkstr(SI.TELE_SETTINGS_RESET_UI_TOOLTIP, "Redefinir BeamMeUp UI Configurando as seguintes opções Voltar para o padrão: Escala, compensação do botão, deslocamento do mapa e posições de janela. A interface completa será recarregada.")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION, "Notificação do mapa de pesquisa")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP, "Se você possuir um mapa de pesquisa e ainda há alguns mapas idênticos (no mesmo local) em seu inventário, uma notificação (mensagem central) irá informá-lo.")
mkstr(SI.TELE_SETTINGS_HEADER_PRIO, "Priorização")
mkstr(SI.TELE_SETTINGS_HEADER_CHAT_COMMANDS, "Comandos de bate-papo.")
mkstr(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT, "Minimizar a saída de bate-papo.")
mkstr(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT_TOOLTIP, "Reduza o número de saídas de bate-papo ao usar o recurso de desbloqueio automático.")
mkstr(SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION, "Aqui você pode definir quais jogadores devem ser usados de forma rápida. Depois de sair ou unir uma guilda, um reinicio de UI é necessária para ser exibida corretamente aqui.")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP, "Mostrar botão adicional no mapa")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP, "Exibir um botão de texto no canto superior esquerdo do mapa do mundo para abrir o BeamMeUp.")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND, "Tocar música")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP, "Toque um som ao mostrar a notificação.")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL, "Confirme para viajar automáticamente para um Santuário")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP, "Desativar a caixa de diálogo de confirmação quando você se teletransportar para outras matrizes.")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP, "Mostrar a zona atual sempre no topo")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP, "Mostrar a zona atual sempre em cima da lista.")
mkstr(SI.TELE_SETTINGS_HIDE_OWN_HOUSES, "Esconder casas próprias")
mkstr(SI.TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP, "Esconda suas próprias casas (Viajar para fora) na lista principal.")
mkstr(SI.TELE_SETTINGS_HEADER_STATS, "Estatisticas")
mkstr(SI.TELE_SETTINGS_MOST_PORTED_ZONES, "Zonas mais visitadas:")
mkstr(SI.TELE_SETTINGS_INSTALLED_SCINCE, "Instalado em:")
mkstr(SI.TELE_SETTINGS_INFO_CHARACTER_DEPENDING, "Esta opção está vinculada ao seu personagem (não há conta)!")
mkstr(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION, "Animação de teletransporte")
mkstr(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP, "Mostre uma animação de teletransporte adicional ao iniciar uma viagem rápida via BeamMeUp. O colecionável 'Finvir's Trinket' deve ser desbloqueado.")
mkstr(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON, "Atalho na janela de bate-papo")
mkstr(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON_TOOLTIP, "Exibe um atalho na janela de bate-papo para abrir o BeamMeUp.")
mkstr(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM, "Panorâmica e Zoom")
mkstr(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP, "Faça uma panorâmica e amplie o destino no mapa ao clicar em membros do grupo ou zonas específicas (masmorras, casas etc.).")
mkstr(SI.TELE_SETTINGS_USE_RALLY_POINT, "Mapa Ping")
mkstr(SI.TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP, "Exibe um ponto no mapa (ponto de encontro) no destino quando você clicar em membros do grupo ou zonas específicas (masmorras, casas etc.). A biblioteca LibMapPing deve estar instalada. Lembre-se também: Se você é o líder do grupo, seus locais (pontos de rally) são visíveis para todos os membros do grupo.")
mkstr(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS, "Mostrar zonas sem jogadores ou casas")
mkstr(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP, "Exibir zonas na lista principal, mesmo que não haja jogadores ou casas para as quais você possa viajar. Você ainda tem a opção de viajar vom custo de ouro se tiver descoberto pelo menos um santuário na zona.")


-----------------------------------------------------------------------------
-- KEY BINDING
-----------------------------------------------------------------------------
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN, "Abrir BeamMeUp")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_RELATED_ITEMS, "Tesouros & Mapas de Pesquisas & Leads")
mkstr(SI.TELE_KEYBINDING_REFRESH, "Atualizar a lista de resultados.")
mkstr(SI.TELE_KEYBINDING_WAYSHRINE_UNLOCK, "Desbloquear Santuários da zona atual")
mkstr(SI.TELE_KEYBINDING_PRIMARY_RESIDENCE, "Viajar em residência primária")
mkstr(SI.TELE_KEYBINDING_GUILD_HOUSE_BMU, "Visite a Casa da Guilda BeamMeUp")
mkstr(SI.TELE_KEYBINDING_CURRENT_ZONE, "Viajar para a zona atual")
mkstr(SI.TELE_KEYBINDING_PRIMARY_RESIDENCE_OUTSIDE, "Viajar para fora da residência primária")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_DUNGEON_FINDER, "Arenas / Provações / Masmorras")
mkstr(SI.TELE_KEYBINDING_TRACKED_QUEST, "Trocar para missão escolhida")


-----------------------------------------------------------------------------
-- DIALOGS | NOTIFICATIONS
-----------------------------------------------------------------------------
mkstr(SI.TELE_DIALOG_NO_BMU_GUILD_BODY, "Lamentamos, mas parece que não há uma guilda de BeamMeUp neste servidor ainda.\n\nSinta-se à vontade para entrar em contato conosco através do site de Esoui e iniciar uma guilda oficial de BeamMeUp neste servidor.")
mkstr(SI.TELE_DIALOG_INFO_BMU_GUILD_BODY, "Olá e obrigado por usar o BeamMeUp. Em 2019, começamos várias guildas de BeamMeUp com o objetivo de compartilhar opções de viagem rápidas gratuitas. Todos são bem-vindos, sem requisitos ou obrigações!\n\nConfirmando esta caixa de diálogo, você verá as guildas oficiais e parceiras da BeamMeUp na lista. Você é bem-vindo para participar! Você também pode exibir as guildas clicando no botão Guild no canto superior esquerdo.\nYour Team BeamMeUp")
mkstr(SI.TELE_DIALOG_INFO_NEW_FEATURE_FAVORITE_PLAYER_NOTIFICATION, "Você recebe uma notificação (mensagem central de tela) quando um favorito do jogador vem online.\n\nAtive este recurso?")
mkstr(SI.TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION, "Se você possuir um mapa de pesquisa e ainda há alguns mapas idênticos (no mesmo local) em seu inventário, uma notificação (mensagem central) irá informá-lo.\n\nAtivar esse recurso?")
mkstr(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE, "Integração de \"Port to Friend's House\"")
mkstr(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY, "Para usar o recurso de integração, por favor, instale a porta Addon \"Port to Friend's House\". Você então verá suas casas configuradas e salas de guilda aqui na lista.\n\nVocê deseja abrir \"Port to Friend's House\" Addon website agora?")
-- AUTO UNLOCK: Start Dialog
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_TITLE, "Iniciar o desbloqueio automático de Santuários?")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_BODY, "Ao confirmar, o BeamMeUp começará a viajar para todos os jogadores disponíveis na zona atual. Dessa forma, automaticamente você irá de um santuário para outro para desbloquear o máximo possível.")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_LOOP_OPTION, "Percorrendo zonas...")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION1, "Percorrer aleatoriamente")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION2, "por Santuários Desconhecidos")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION3, "por número de jogadores")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_CHAT_LOG_OPTION, "Resultados de saída no chat")
-- AUTO UNLOCK: Refuse Dialogs
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE, "Desbloquear não é possível")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY, "Todos os Santuários da zona já foram desbloqueados.")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY2, "Desbloquear Santuários não é possível nesta zona. O recurso só está disponível em zonas/regiões terrestre.")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY3, "Infelizmente, não há jogadores na zona que você deseja viajar.")
-- AUTO UNLOCK: Process Dialog
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART, "Descoberta automática de santuários em execução...")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY, "Santuários recém-descobertos:")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP, "EXP ganha:")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_PROGRESS, "Progresso:")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_TIMER, "Próximo salto em:")
-- AUTO UNLOCK: Finish Dialog
mkstr(SI.TELE_DIALOG_FINISH_AUTO_UNLOCK_BODY_PART, "Descoberta automática de santuários concluído.")
-- AUTO UNLOCK: Timeout Dialog
mkstr(SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_TITLE, "Tempo esgotado")
mkstr(SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_BODY, "Desculpe, ocorreu um erro desconhecido. A descoberta automática foi cancelada.")
-- AUTO UNLOCK: Loop Finish Dialog
mkstr(SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE, "Descoberta automática concluída")
mkstr(SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY, "Não há mais zonas encontradas para serem descobertas. Ou não há jogadores nas zonas ou você já descobriu todos os santuários.")



-----------------------------------------------------------------------------
-- CENTER SCREEN NOTIFICATIONS
-----------------------------------------------------------------------------
mkstr(SI.TELE_CENTERSCREEN_OFFLINE_NOTE_HEAD, "Nota: Você ainda está definido como offline!")
mkstr(SI.TELE_CENTERSCREEN_OFFLINE_NOTE_BODY, "Ninguém pode sussurrar ou viajar até você!\n|c8c8c8c(A notificação pode ser desativada nas configurações do BeamMeUp)")
mkstr(SI.TELE_CENTERSCREEN_SURVEY_MAPS, "Você possui %d mapas de pesquisa! Afaste à 100 metros e retorne para recolher o próximo mapa!")
mkstr(SI.TELE_CENTERSCREEN_FAVORITE_PLAYER_ONLINE, "está online!")



-----------------------------------------------------------------------------
-- ITEM NAMES (PART OF IT) - BACKUP
-----------------------------------------------------------------------------
mkstr(SI.CONSTANT_TREASURE_MAP, "Mapa de Tesouro") -- need a part of the item name that is in every treasure map item the same no matter which zone
mkstr(SI.CONSTANT_SURVEY_MAP, "Mapa de Pesquisa:") -- need a part of the item name that is in every survey map item the same no matter which zone and kind of craft