local mkstr = ZO_CreateStringId
local SI = BMU.SI

-----------------------------------------------------------------------------
-- INTERFACE
-----------------------------------------------------------------------------
mkstr(SI.TELE_UI_TOTAL, "Resultado:")
mkstr(SI.TELE_UI_GOLD, "Oro ahorrado:")
mkstr(SI.TELE_UI_GOLD_ABBR, "k")
mkstr(SI.TELE_UI_GOLD_ABBR2, "m")
mkstr(SI.TELE_UI_TOTAL_PORTS, "Total de transbordos:")
---------
--------- Buttons
mkstr(SI.TELE_UI_BTN_REFRESH_ALL, "Actualizar lista")
mkstr(SI.TELE_UI_BTN_UNLOCK_WS, "Descubrimiento automatico de ermitas de la zona actual")
mkstr(SI.TELE_UI_BTN_FIX_WINDOW, "Fijar / Desplazable ventana")
mkstr(SI.TELE_UI_BTN_TOGGLE_ZONE_GUIDE, "Cambiar a BeamMeUp")
mkstr(SI.TELE_UI_BTN_TOGGLE_BMU, "Cambiar a Guia de la Zona")
mkstr(SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE, "Casas obtenidas")
mkstr(SI.TELE_UI_BTN_ANCHOR_ON_MAP, "Desanclar / Anclar por el mapa")
mkstr(SI.TELE_UI_BTN_GUILD_BMU, "BeamMeUp Gremios & Gremios colaboradores")
mkstr(SI.TELE_UI_BTN_GUILD_HOUSE_BMU, "Visitar casa del Gremio BeamMeUp")
mkstr(SI.TELE_UI_BTN_PTF_INTEGRATION, "\"Port to Friend's House\" Integracion")
mkstr(SI.TELE_UI_BTN_DUNGEON_FINDER, "Arenas / Pruebas / Mazmorras")
mkstr(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU, "\n|c777777(Click derecho para mas opciones)")
---------
--------- List
mkstr(SI.TELE_UI_UNRELATED_ITEMS, "Mapas en otras Zonas")
mkstr(SI.TELE_UI_UNRELATED_QUESTS, "Misiones en otras Zonas")
mkstr(SI.TELE_UI_SAME_INSTANCE, "Misma Instancia")
mkstr(SI.TELE_UI_DIFFERENT_INSTANCE, "Instancia Diferente")
---------
--------- Menu
mkstr(SI.TELE_UI_FAVORITE_PLAYER, "jugador Favorito")
mkstr(SI.TELE_UI_FAVORITE_ZONE, "Zona Favorita")
mkstr(SI.TELE_UI_REMOVE_FAVORITE_PLAYER, "Eliminar Jugador Favorito")
mkstr(SI.TELE_UI_REMOVE_FAVORITE_ZONE, "Eliminar Zona Favorita")
mkstr(SI.TELE_UI_VOTE_TO_LEADER, "Votar por un Lider")
mkstr(SI.TELE_UI_RESET_COUNTER_ZONE, "Reiniciar Contador")
mkstr(SI.TELE_UI_INVITE_BMU_GUILD, "Invitar al Gremio BeamMeUp")
mkstr(SI.TELE_UI_SHOW_QUEST_MARKER_ON_MAP, "Mostrar marcador de Misiones")
mkstr(SI.TELE_UI_RENAME_HOUSE_NICKNAME, "Renombrar apodo de la Casa")
mkstr(SI.TELE_UI_TOGGLE_HOUSE_NICKNAME, "Mostrar apodos")
mkstr(SI.TELE_UI_VIEW_MAP_ITEM, "Ver articulo del Mapa")
mkstr(SI.TELE_UI_TOGGLE_ARENAS, "Solo Arenas")
mkstr(SI.TELE_UI_TOGGLE_GROUP_ARENAS, "Grupo Arenas")
mkstr(SI.TELE_UI_TOGGLE_TRIALS, "Pruebas")
mkstr(SI.TELE_UI_TOGGLE_GROUP_DUNGEONS, "Grupo Mazmorras")
mkstr(SI.TELE_UI_TOGGLE_SORT_ACRONYM, "Ordenar por acronimo")
mkstr(SI.TELE_UI_DAYS_LEFT, "%d dias restantes")
mkstr(SI.TELE_UI_TOGGLE_UPDATE_NAME, "Show update name")
mkstr(SI.TELE_UI_UNLOCK_WAYSHRINES, "Descubrimiento automatico de ermitas")
mkstr(SI.TELE_UI_SUBMENU_FAVORITES, "Favoritos")
mkstr(SI.TELE_UI_TOOGLE_ZONE_NAME, "Show zone name")
mkstr(SI.TELE_UI_TOGGLE_SORT_RELEASE, "Sort by release")
mkstr(SI.TELE_UI_TOGGLE_ACRONYM, "Show acronym")
mkstr(SI.TELE_UI_TOOGLE_DUNGEON_NAME, "Show instance name")



-----------------------------------------------------------------------------
-- CHAT OUTPUTS
-----------------------------------------------------------------------------
mkstr(SI.TELE_CHAT_FAVORITE_UNSET, "La ranura de Favoritos no esta configurada")
mkstr(SI.TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL, "Este jugador esta desconectado u oculto por filtros")
mkstr(SI.TELE_CHAT_NO_FAST_TRAVEL, "Sin opcion de viaje rapido")
mkstr(SI.TELE_CHAT_NOT_IN_GROUP, "No te encuentras en un grupo")
mkstr(SI.TELE_CHAT_PORT_TO_OWN_PRIMARY_HOUSE_FAILED, "No residencia primaria establecida!")
mkstr(SI.TELE_CHAT_GROUP_LEADER_YOURSELF, "Eres el Lider del Grupo")
mkstr(SI.TELE_CHAT_UNLOCK_WS_DISCOVERED_TOTAL, "Total de ermitas descubridas en la Zona:")
mkstr(SI.TELE_CHAT_UNLOCK_WS_NEED_DISCOVERED, "Las siguientes ermitas aun necesitan ser  fisicamente visitadas:")
mkstr(SI.TELE_CHAT_SHARING_FOLLOW_LINK, "Siguiendo el enlace ...")
mkstr(SI.TELE_CHAT_AUTO_UNLOCK_CANCELED, "Descubrimiento automático cancelado por el usuario.")
mkstr(SI.TELE_CHAT_AUTO_UNLOCK_SKIP, "Error al saltar a otro jugador: Omisión del jugador actual.")



-----------------------------------------------------------------------------
-- SETTINGS
-----------------------------------------------------------------------------
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN, "Abrir BeamMeUp cuando el mapa esta abierto")
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP, "Cuando abras el mapa, BeamMeUp automaticamente se abrira tambien, de otra manera veras un boton en la parte superior izquierda ademas de un boton de cambio en la ventada completa del mapa.")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY, "Mostrar cada zona solo una vez")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP, "Mostrar solo un listado para cada zona.")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ, "Frecuencia de desbloqueo de ermitas (ms)")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP, "Ajustar frecuencia de desbloqueo automatico de ermitas. Para computadoras lentas o prevenir posible expulsion del juego, un valor mas alto puede ayudar.")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH, "Actualizar & Resetear al abrir")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP, "Actualizar resultado de lista cada vez que se abra BeamMeUp. Area de entrada seran despejadas.")
mkstr(SI.TELE_SETTINGS_HEADER_BLACKLISTING, "Listar en lista negra")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS, "Ocultar varias Zonas inaccesibles")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP, "Ocultar Zonas como la Arena Maelstrom, Refugio de Foragidos u zonas en solitario.")
mkstr(SI.TELE_SETTINGS_HIDE_PVP, "Ocultar Zonas JyJ")
mkstr(SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP, "Ocultar zonas como Cyrodiil, Ciudad Imperial y Campos de Batalla.")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS, "Ocultar Mazmorras Grupales y Pruebas")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP, "Ocultar todas las Mazmorras de grupos de 4 personas, Pruebas de 12 personas y Mazmorras grupales en Craglorn. Miembros grupales en estas zonas aun seran desplegados!")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES, "Ocultar casas")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP, "Ocultar todas las casas.")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY, "Mantener BeamMeUp abierto")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP, "Cuando usted abra BeamMeUp sin el mapa, se mantendra abierto incluso si usted abre o mueve otra ventana. Si utiliza esta opcion, se recomienda deshabilitar la opcion 'Cerrar BeamMeUp con mapa'.")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS, "Mostrar solo Regiones / Zonas terrestres")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP, "Mostrar solamente regiones principales como Deshaan o Estivalia.")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ, "Actualizar intervalos (s)")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP, "Cuando BeamMeUp esta abierto, una actualizacion automatica de la lista de resultados  es realizada cada x segundos. Configura el valor a 0 para desabilitar la actualizacion automatica.")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN, "Centrar el cuadro de búsqueda de zona")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP, "Enfoca el cuadro de búsqueda de zona cuando se abre BeamMeUp junto con el mapa.")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES, "Ocultar Cuevas")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP, "Ocultar todas las Cuevas.")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS, "Ocultar Mazmorras Publicas")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP, "Ocultar todas las Mazmorras Publicas.")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME, "Ocultar articulos de nombres de Zonas")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP, "Ocultar todos los articulos de nombres de Zonas para asegurar una mejor clasificacion para acelerar busqueda de Zonas.")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES, "Numero de lineas / listado")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP, "Al configurar el numero de lineas visibles / listados podra controlar la total altura del complemento.")
mkstr(SI.TELE_SETTINGS_HEADER_ADVANCED, "Caracteristicas Extras")
mkstr(SI.TELE_SETTINGS_HEADER_UI, "General")
mkstr(SI.TELE_SETTINGS_HEADER_RECORDS, "Listado")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING, "Cierre automatico de mapa y BeamMeUp")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP, "Cerrar mapa y BeamMeUp tras el proceso de transporte ha sido iniciado.")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS, "Mostrar numero de jugadores en el mapa")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP, "Mostrar numero de jugadores por mapa, a los cuales puedas transportar. Podras hacer click en el numero para ver a todos estos jugadores.")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET, "Desplazamiento del botón en el cuadro de chat")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP, "Aumente el desplazamiento horizontal del botón en el encabezado del cuadro de chat para evitar conflictos visuales con otros íconos de Complementos.")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES, "Tambien busca nombres de personajes")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP, "También busque nombres de personajes cuando busque jugadores..")
mkstr(SI.TELE_SETTINGS_SORTING, "Clasificar")
mkstr(SI.TELE_SETTINGS_SORTING_TOOLTIP, "Elija uno de los posibles tipos de lista.")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE, "Segunda busqueda de Lenguaje")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP, "Puede buscar por nombres de Zonas en el idioma de cliente y este segundo Lenguaje al mismo tiempo. La información sobre herramientas del nombre de la zona también muestra el nombre en el segundo idioma.")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE, "Notificacion de Jugador Favorito en Linea")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP, "Recibira una notificacion (mensaje en pantalla central) cuando un jugador favotiro se conecte en Linea.")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE, "Cerrar BeamMeUp cuando el mapa este cerrado")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP, "Cuando usted cierra el mapa, BeamMeUp tambien se cerrara.")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL, "Desplazamiento de la posición del acoplamiento del mapa - Horizontal")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP, "Aquí puede personalizar el desplazamiento horizontal del acoplamiento en el mapa.")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL, "Desplazamiento de la posición del acoplamiento del mapa - Vertical")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP, "Aquí puede personalizar el desplazamiento vertical del acoplamiento en el mapa.")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS, "Resetear contadores de Todas las Zonas")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP, "Todos los contadores de Zonas han sido reseteados. Por ello, la clasificacion de mas utilizados ha sido reseteada.")
mkstr(SI.TELE_SETTINGS_OFFLINE_NOTE, "Recordatorio de desconeccion")
mkstr(SI.TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP, "Si está desconectado por un tiempo y susurra o viaja con alguien, recibirá un mensaje de pantalla corto como recordatorio. Mientras esté desconectado, no podrá recibir ningún mensaje susurrado y nadie podrá viajar hasta usted (pero compartir es cuidar).")
mkstr(SI.TELE_SETTINGS_SCALE, "UI ajuste")
mkstr(SI.TELE_SETTINGS_SCALE_TOOLTIP, "Factor de ajuste para la interfaz de usuario/ventana completa de BeamMeUp. Es necesaria una recarga para aplicar los cambios..")
mkstr(SI.TELE_SETTINGS_RESET_UI, "Resetear UI")
mkstr(SI.TELE_SETTINGS_RESET_UI_TOOLTIP, "Resetear BeamMeUp UI configurando las siguientes opciones de nuevo a los valores predeterminados: ajustes, compensación de botones, compensaciones de base de mapa y posiciones de ventana. Se volverá a cargar la interfaz de usuario completa..")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION, "Notificación de mapa prospeccion ")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP, "Si extrae un mapa de prospeccion y todavía hay algunos mapas idénticos (misma ubicación) en su inventario, una notificación (mensaje en la pantalla central) le informará.")
mkstr(SI.TELE_SETTINGS_HEADER_PRIO, "Priorización")
mkstr(SI.TELE_SETTINGS_HEADER_CHAT_COMMANDS, "Comandos de Chat")
mkstr(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT, "Minimizar la salida del chat")
mkstr(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT_TOOLTIP, "Reduzca la cantidad de salidas de chat al usar la función de desbloqueo automático.")
mkstr(SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION, "Aqui podra definir cuales jugadores seran preferentemente utilizados para viaje rapido. Tras dejar o unirse a un Gremio, una recarga sera necesaria para desplazarse correctamente ahi.")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP, "Mostrar boton adicional en el mapa.")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP, "Desplegar un boton de texto en la esquina superior izquierda del mapa mundial para abrir BeamMeUp.")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND, "Reproducir sonido")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP, "Reproducir un sonido cuando muestra una notificacion.")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL, "Confirmacion automatica de viaje a ermitas")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP, "Deshabilitar el dialogo de confirmacion cuando viaja a otras ermitas.")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP, "Mostrar zona actual siempre en la parte superior")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP, "Mostrar zona actual siempre en la parte superior de la lista.")
mkstr(SI.TELE_SETTINGS_HIDE_OWN_HOUSES, "Ocultar casas propias")
mkstr(SI.TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP, "Ocultar casas propias  (transportar afuera) en la lista principal.")
mkstr(SI.TELE_SETTINGS_HEADER_STATS, "Estadisticas")
mkstr(SI.TELE_SETTINGS_MOST_PORTED_ZONES, "Zonas mas transportadas:")
mkstr(SI.TELE_SETTINGS_INSTALLED_SCINCE, "Instalado desde:")
mkstr(SI.TELE_SETTINGS_INFO_CHARACTER_DEPENDING, "Esta opcion esta  enlazada a tu personaje (no a todas las cuentas)!")
mkstr(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION, "Animacion de teletransporte")
mkstr(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP, "Mostrar una animación de teletransportación adicional al iniciar un viaje rápido a través de BeamMeUp. El objeto coleccionable 'Baratija de Finvir' debe estar desbloqueado.")
mkstr(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON, "Boton en la ventana del chat")
mkstr(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON_TOOLTIP, "Mostrar un botón en el encabezado de la ventana de chat para abrir BeamMeUp.")
mkstr(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM, "Panorámica y zoom")
mkstr(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP, "Panoramica y zoom al destino en el mapa al hacer clic en miembros del grupo o zonas específicas (mazmorras, casas, etc.).")
mkstr(SI.TELE_SETTINGS_USE_RALLY_POINT, "Ping en mapa")
mkstr(SI.TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP, "Muestre un ping de mapa (punto de reunión) en el destino en el mapa cuando haga clic en miembros del grupo o zonas específicas (mazmorras, casas, etc.). La biblioteca LibMapPing debe estar instalada. Recuerde también: si usted es el líder del grupo, sus pings (puntos de reunión) son visibles para todos los miembros del grupo.")
mkstr(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS, "Muesta zonas sin jugadores o casas")
mkstr(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP, "Desplegar zonas en la lista principal incluso sin jugadores ni casas a las cuales transportarse.  Usted aun tiene la opcion de transportarse con oro si ha descubierto al menos una Ermita en la zona.")


-----------------------------------------------------------------------------
-- KEY BINDING
-----------------------------------------------------------------------------
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN, "Abrir BeamMeUp")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_RELATED_ITEMS, "Mapas de Tesoros & Prospecciones & Pistas")
mkstr(SI.TELE_KEYBINDING_REFRESH, "Actualizar resultado de lista")
mkstr(SI.TELE_KEYBINDING_WAYSHRINE_UNLOCK, "Desbloquear ermitas de la zona actual")
mkstr(SI.TELE_KEYBINDING_PRIMARY_RESIDENCE, "Transportar en residencia primaria")
mkstr(SI.TELE_KEYBINDING_GUILD_HOUSE_BMU, "Visitar casa del Gremio BeamMeUp")
mkstr(SI.TELE_KEYBINDING_CURRENT_ZONE, "Transportar a zona actual")
mkstr(SI.TELE_KEYBINDING_PRIMARY_RESIDENCE_OUTSIDE, "Transporta afuera de residencia primaria")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_DUNGEON_FINDER, "Arenas / Pruebass / Mazmorras")
mkstr(SI.TELE_KEYBINDING_TRACKED_QUEST, "Transportar a mision enfocada")


-----------------------------------------------------------------------------
-- DIALOGS | NOTIFICATIONS
-----------------------------------------------------------------------------
mkstr(SI.TELE_DIALOG_NO_BMU_GUILD_BODY, "Realmente lo sentimos, pero parece ser que aun no hay un gremio BeamMeUp en este servidor.\n\nSientase libre de contactarnos en la pagina web ESOUI e iniciar un gremio oficial de BeamMeUp en este servidor.")
mkstr(SI.TELE_DIALOG_INFO_BMU_GUILD_BODY, "Hola y gracias por utilizar BeamMeUp. En 2019, nosotros iniciamos varios Gremios BeamMeUp con el proposito de compartir opciones de transporte rapido. Sean todos bienvenidos, sin reuqerimientos ni obligacioness!\n\nAl confirmar este dialogo, usted podra ver el gremio oficial y colaboradores de BeamMeUp en la lista. Es usted bienvenido de unirse! Podra desplegar los gremios haciendo click en el boton de gremios ubicado en la esquina superior izquierda.\nSu equipo BeamMeUp")
mkstr(SI.TELE_DIALOG_INFO_NEW_FEATURE_FAVORITE_PLAYER_NOTIFICATION, "Recibir notificacion (mensaje en pantalla central) cuando un jugador favorito se conecta en linea.\n\nDesabilitar este rasgo?")
mkstr(SI.TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION, "Si extrae un mapa de prospeccion y todavía hay algunos mapas idénticos (misma ubicación) en su inventario, una notificación (mensaje en la pantalla central) le informará.\n\n¿Habilitar esta función?")
mkstr(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE, "Integracion de \"Port to Friend's House\"")
mkstr(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY, "Para utilizar el rasgo de integracion, por facor instalar el complemento \"Port to Friend's House\". Usted podra ver su casas configuradas y salones de gremios aqui en la lista.\n\nDesea abrir la pagina web del complemento \"Port to Friend's House\" ahora?")
-- AUTO UNLOCK: Start Dialog
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_TITLE, "Iniciar desbloqueo automatico de ermitas?")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_BODY, "Al confirmar, BeamMeUp iniciara viaje a todos los jugadores disponibles en la zona. De esta manera automaticamente saltara usted de una ermita a otra ermita para desbloquear tantas como sean posibles.")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_LOOP_OPTION, "Recorriendo zonas ...")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION1, "mezclar aleatoriamente")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION2, "por proporción de Ermitas sin descubrir")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION3, "por numero de Jugadores")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_CHAT_LOG_OPTION, "Colocar resultados en el Chat")
-- AUTO UNLOCK: Refuse Dialogs
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE, "Desbloquear no es posible")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY, "Todas las ermitas de esta zona ya han sido desbloqueadas.")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY2, "Desbloquear ermitas no es posible en esta zona. El rasgo solo esta disponible por zonas terrestres / regiones.")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY3, "Desafortunadamente, no hay jugadores en esta zona a donde transportar.")
-- AUTO UNLOCK: Process Dialog
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART, "Descubrimiento automático de Ermitas en marcha...")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY, "Nuevas Ermitas descubiertas:")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP, "Exp. ganadas:")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_PROGRESS, "Progreso:")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_TIMER, "Siguiente salto en:")
-- AUTO UNLOCK: Finish Dialog
mkstr(SI.TELE_DIALOG_FINISH_AUTO_UNLOCK_BODY_PART, "Descubrimiento automático de Ermitas completado.")
-- AUTO UNLOCK: Timeout Dialog
mkstr(SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_TITLE, "Se acabó el tiempo")
mkstr(SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_BODY, "Lo sentimos, un error desconocido ha ocurrido. El descubrimiento automático ha sido cancelado.")
-- AUTO UNLOCK: Loop Finish Dialog
mkstr(SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE, "Descubrimiento automático finalizado")
mkstr(SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY, "No se han encontrado más zonas para descubrir. O no hay jugadores en esas zonas o ha descubierto todas las Ermitas.")



-----------------------------------------------------------------------------
-- CENTER SCREEN NOTIFICATIONS
-----------------------------------------------------------------------------
mkstr(SI.TELE_CENTERSCREEN_OFFLINE_NOTE_HEAD, "Nota: Estas establecido como desconectado!")
mkstr(SI.TELE_CENTERSCREEN_OFFLINE_NOTE_BODY, "Nadie puede susurrar o viajar hasta ti!\n|c8c8c8c(La notificacion puede ser deshabilitada en configuraciones en BeamMeUp)")
mkstr(SI.TELE_CENTERSCREEN_SURVEY_MAPS, "¡Te quedan %d de los mapas de esta propeccion! Vuelve después de que estos reaparezcan!")
mkstr(SI.TELE_CENTERSCREEN_FAVORITE_PLAYER_ONLINE, "Ahora esta en Linea!")



-----------------------------------------------------------------------------
-- ITEM NAMES (PART OF IT) - BACKUP
-----------------------------------------------------------------------------
mkstr(SI.CONSTANT_TREASURE_MAP, "Mapa del tesoro") -- need a part of the item name that is in every treasure map item the same no matter which zone
mkstr(SI.CONSTANT_SURVEY_MAP, "Prospección") -- need a part of the item name that is in every survey map item the same no matter which zone and kind of craft