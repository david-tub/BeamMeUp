local mkstr = ZO_CreateStringId
local SI = BMU.SI

-----------------------------------------------------------------------------
-- INTERFACE
-----------------------------------------------------------------------------
mkstr(SI.TELE_UI_TOTAL, "ポート先件数:")
mkstr(SI.TELE_UI_GOLD, "BMUで節約したGold:")
mkstr(SI.TELE_UI_GOLD_ABBR, "k")
mkstr(SI.TELE_UI_GOLD_ABBR2, "m")
mkstr(SI.TELE_UI_TOTAL_PORTS, "総移動回数:")
---------
--------- Buttons
mkstr(SI.TELE_UI_BTN_REFRESH_ALL, "プレイヤー一覧を更新する")
mkstr(SI.TELE_UI_BTN_UNLOCK_WS, "現在のゾーンの旅の祠を解除")
mkstr(SI.TELE_UI_BTN_FIX_WINDOW, "ウィンドウを固定／固定を解除する")
mkstr(SI.TELE_UI_BTN_TOGGLE_ZONE_GUIDE, "BeamMeUpに切り替える")
mkstr(SI.TELE_UI_BTN_TOGGLE_BMU, "ゾーンガイドに切り替える")
mkstr(SI.TELE_UI_BTN_PORT_TO_OWN_HOUSE, "購入済み住居")
mkstr(SI.TELE_UI_BTN_ANCHOR_ON_MAP, "マップに固定／固定解除する")
mkstr(SI.TELE_UI_BTN_GUILD_BMU, "BeamMeUp公式ギルド＆パートナーギルド")
mkstr(SI.TELE_UI_BTN_GUILD_HOUSE_BMU, "BeamMeUp公式ギルドのギルドハウスを訪ねる")
mkstr(SI.TELE_UI_BTN_PTF_INTEGRATION, "\"Port to Friend's House\" との連携\n（お気に入りリスト）")
mkstr(SI.TELE_UI_BTN_DUNGEON_FINDER, "アリーナ / 試練 / ダンジョン")
mkstr(SI.TELE_UI_BTN_TOOLTIP_CONTEXT_MENU, "\n|c777777(右クリックで追加オプション)")
---------
--------- List
mkstr(SI.TELE_UI_UNRELATED_ITEMS, "他のゾーンの地図")
mkstr(SI.TELE_UI_UNRELATED_QUESTS, "他のゾーンのクエスト")
mkstr(SI.TELE_UI_SAME_INSTANCE, "同一インスタンス")
mkstr(SI.TELE_UI_DIFFERENT_INSTANCE, "別インスタンス")
---------
--------- Menu
mkstr(SI.TELE_UI_FAVORITE_PLAYER, "プレイヤーのお気に入り")
mkstr(SI.TELE_UI_FAVORITE_ZONE, "ゾーンのお気に入り")
mkstr(SI.TELE_UI_REMOVE_FAVORITE_PLAYER, "プレイヤーのお気に入りから削除する")
mkstr(SI.TELE_UI_REMOVE_FAVORITE_ZONE, "ゾーンのお気に入りから削除する")
mkstr(SI.TELE_UI_VOTE_TO_LEADER, "リーダーに投票する")
mkstr(SI.TELE_UI_RESET_COUNTER_ZONE, "カウンターをリセット")
mkstr(SI.TELE_UI_INVITE_BMU_GUILD, "BeamMeUp公式ギルドに招待する")
mkstr(SI.TELE_UI_SHOW_QUEST_MARKER_ON_MAP, "Show Quest Marker")
mkstr(SI.TELE_UI_RENAME_HOUSE_NICKNAME, "家のニックネームを変更する")
mkstr(SI.TELE_UI_TOGGLE_HOUSE_NICKNAME, "ニックネームを表示する")
mkstr(SI.TELE_UI_VIEW_MAP_ITEM, "地図を表示")
mkstr(SI.TELE_UI_TOGGLE_ARENAS, "ソロアリーナ")
mkstr(SI.TELE_UI_TOGGLE_GROUP_ARENAS, "グループアリーナ")
mkstr(SI.TELE_UI_TOGGLE_TRIALS, "試練")
mkstr(SI.TELE_UI_TOGGLE_GROUP_DUNGEONS, "グループダンジョン")
mkstr(SI.TELE_UI_TOGGLE_SORT_ACRONYM, "頭文字で並び替え")
mkstr(SI.TELE_UI_DAYS_LEFT, "残り日数 %d")
mkstr(SI.TELE_UI_TOGGLE_UPDATE_NAME, "Show update name")
mkstr(SI.TELE_UI_UNLOCK_WAYSHRINES, "旅の祠の自動解除")
mkstr(SI.TELE_UI_SUBMENU_FAVORITES, "お気に入り")
mkstr(SI.TELE_UI_TOOGLE_ZONE_NAME, "Show zone name")
mkstr(SI.TELE_UI_TOGGLE_SORT_RELEASE, "Sort by release")
mkstr(SI.TELE_UI_TOGGLE_ACRONYM, "Show acronym")
mkstr(SI.TELE_UI_TOOGLE_DUNGEON_NAME, "Show instance name")



-----------------------------------------------------------------------------
-- CHAT OUTPUTS
-----------------------------------------------------------------------------
mkstr(SI.TELE_CHAT_FAVORITE_UNSET, "お気に入りのスロットが設定されていません")
mkstr(SI.TELE_CHAT_FAVORITE_PLAYER_NO_FAST_TRAVEL, "プレイヤーがオフラインかフィルタ設定されています")
mkstr(SI.TELE_CHAT_NO_FAST_TRAVEL, "ファストトラベルのオプションが見つかりません")
mkstr(SI.TELE_CHAT_NOT_IN_GROUP, "グループに所属していません")
mkstr(SI.TELE_CHAT_PORT_TO_OWN_PRIMARY_HOUSE_FAILED, "本邸が設定されていません！")
mkstr(SI.TELE_CHAT_GROUP_LEADER_YOURSELF, "貴方がグループリーダーです")
mkstr(SI.TELE_CHAT_UNLOCK_WS_DISCOVERED_TOTAL, "ゾーンで発見した旅の祠の総計:")
mkstr(SI.TELE_CHAT_UNLOCK_WS_NEED_DISCOVERED, "以下の旅の祠はまず直接訪れる必要があります:")
mkstr(SI.TELE_CHAT_SHARING_FOLLOW_LINK, "Following the link ...")
mkstr(SI.TELE_CHAT_AUTO_UNLOCK_CANCELED, "ユーザーによって自動検出がキャンセルされました。")
mkstr(SI.TELE_CHAT_AUTO_UNLOCK_SKIP, "ファストトラベルエラー: 現在のプレイヤーをスキップします。")



-----------------------------------------------------------------------------
-- SETTINGS
-----------------------------------------------------------------------------
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN, "マップと同時にBeamMeUpも開く")
mkstr(SI.TELE_SETTINGS_SHOW_ON_MAP_OPEN_TOOLTIP, "マップを開いた時、 BeamMeUpも自動で開きます。そうでない場合はマップの左上と「完了した地図」ウィンドウに切り替えボタンが表示されます。")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY, "ゾーンでグループ化する")
mkstr(SI.TELE_SETTINGS_ZONE_ONCE_ONLY_TOOLTIP, "テレポート先プレイヤーを一行ずつ表示せず、ゾーンごとにまとめて表示します。")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ, "旅の祠の自動解除頻度 (ms)")
mkstr(SI.TELE_SETTINGS_AUTO_PORT_FREQ_TOOLTIP, "自動的に解除する旅の祠を調整します。 低スペックのコンピュータやゲームからのキックを防ぐために役立ちます。")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH, "BeamMeUpを開いたら更新とリセット")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_TOOLTIP, "BeamMeUpを開くたびに結果リストを更新します。 また入力フィールドはクリアされます。")
mkstr(SI.TELE_SETTINGS_HEADER_BLACKLISTING, "非表示化")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS, "アクセス出来ないゾーンを隠す")
mkstr(SI.TELE_SETTINGS_HIDE_OTHERS_TOOLTIP, "メイルストローム闘技場、無法者の避難所やソロのゾーンを隠します。")
mkstr(SI.TELE_SETTINGS_HIDE_PVP, "PVPゾーンを隠す")
mkstr(SI.TELE_SETTINGS_HIDE_PVP_TOOLTIP, "シロディール、インペリアルシティやバトルグラウンドのようなゾーンを隠します。")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS, "グループダンジョンと試練を隠す")
mkstr(SI.TELE_SETTINGS_HIDE_CLOSED_DUNGEONS_TOOLTIP, "全ての4人のグループダンジョン、12人の試練とクラグローンのグループダンジョンを非表示にします。 これらのゾーンのグループメンバーは引き続き表示されます。")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES, "住居を隠す")
mkstr(SI.TELE_SETTINGS_HIDE_HOUSES_TOOLTIP, "全ての住居を隠します。")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY, "BeamMeUpを開いたままにする")
mkstr(SI.TELE_SETTINGS_WINDOW_STAY_TOOLTIP, "キーバインドでBeamMeUpを開くと、他のウィンドウを移動したり開いたりしてもBeamMeUpはそのまま残ります。 このオプションを使用する場合は、[マップと同時にBeamMeUpも閉じる／開く]オプションを無効にすることをお勧めします。")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS, "リージョン／オーバーランドのみ表示")
mkstr(SI.TELE_SETTINGS_ONLY_MAPS_TOOLTIP, "デシャーンやサマーセットといったような主要なリージョンのみ表示します。")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ, "更新間隔 (s)")
mkstr(SI.TELE_SETTINGS_AUTO_REFRESH_FREQ_TOOLTIP, "BeamMeUpが開いている場合、結果の自動更新はx秒ごとに実行されます。 自動更新を無効にするには、値を0に設定します。")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN, "マップを開いたらゾーン検索にフォーカス")
mkstr(SI.TELE_SETTINGS_FOCUS_ON_MAP_OPEN_TOOLTIP, "BMUが地図画面と一緒に開かれた時は、ゾーンの検索ボックスにカーソルが移動します。")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES, "洞窟を隠す")
mkstr(SI.TELE_SETTINGS_HIDE_DELVES_TOOLTIP, "全ての洞窟を隠します。")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS, "パブリックダンジョンを隠す")
mkstr(SI.TELE_SETTINGS_HIDE_PUBLIC_DUNGEONS_TOOLTIP, "全てのパブリックダンジョンを隠します。")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME, "ゾーン名の記事を非表示にする")
mkstr(SI.TELE_SETTINGS_FORMAT_ZONE_NAME_TOOLTIP, "ゾーン名の記事を非表示にすることで、ゾーンをより速く見つけるためのソートを確実にします。")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES, "行数/登録数")
mkstr(SI.TELE_SETTINGS_NUMBER_LINES_TOOLTIP, "表示される行数を調整することで、BeamMeUp全体の高さをコントロールできます。")
mkstr(SI.TELE_SETTINGS_HEADER_ADVANCED, "その他の設定")
mkstr(SI.TELE_SETTINGS_HEADER_UI, "全般")
mkstr(SI.TELE_SETTINGS_HEADER_RECORDS, "リスト表示設定")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING, "テレポートを開始したら閉じる")
mkstr(SI.TELE_SETTINGS_CLOSE_ON_PORTING_TOOLTIP, "テレポートを開始したら、マップ画面とBeamMeUpを閉じます。")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS, "マップ毎のプレイヤー数を表示する")
mkstr(SI.TELE_SETTINGS_SHOW_NUMBER_PLAYERS_TOOLTIP, "そのマップにいるテレポート可能なプレイヤーの数を表示します。数値部分をクリックするとプレイヤー一覧が確認できます。")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET, "チャットウィンドウの設定ボタンの位置")
mkstr(SI.TELE_SETTINGS_CHAT_BUTTON_OFFSET_TOOLTIP, "チャットウィンドウに表示しているBeamMeUp表示用ボタンのオフセット値です。表示用ボタンが他のアドオンの表示項目と重なりましたら利用してください。")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES, "プレイヤー名でも検索する")
mkstr(SI.TELE_SETTINGS_SEARCH_CHARACTERNAMES_TOOLTIP, "アカウントIDのみでなく、プレイヤー名でも検索します。")
mkstr(SI.TELE_SETTINGS_SORTING, "表示順")
mkstr(SI.TELE_SETTINGS_SORTING_TOOLTIP, "ソートの組み合わせから一つを選択してください。")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE, "サブ言語")
mkstr(SI.TELE_SETTINGS_SECOND_SEARCH_LANGUAGE_TOOLTIP, "ゾーン名の検索にて、クライアントの言語と一緒にここで指定した言語でも検索ができます。ツールチップに表示されるゾーン名もこちらの言語に変更されます。")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE, "お気に入りプレイヤーをログイン通知する")
mkstr(SI.TELE_SETTINGS_NOTIFICATION_PLAYER_FAVORITE_ONLINE_TOOLTIP, "お気に入りプレイヤーがログインした時に、通知を表示します。（表示位置：画面中央）")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE, "マップと同時にBeamMeUpも閉じる")
mkstr(SI.TELE_SETTINGS_HIDE_ON_MAP_CLOSE_TOOLTIP, "マップ画面を閉じた時、BeamMeUpも自動で閉じます。")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL, "マップ画面との結合位置のオフセット(横軸)")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_HORIZONTAL_TOOLTIP, "BeamMeUpウィンドウのマップとの結合位置（横軸）オフセットを設定します。")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL, "マップ画面との結合位置のオフセット(縦軸)")
mkstr(SI.TELE_SETTINGS_MAP_DOCK_OFFSET_VERTICAL_TOOLTIP, "BeamMeUpウィンドウのマップとの結合位置（縦軸）オフセットを設定します。")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS, "ゾーンカウンタをリセット")
mkstr(SI.TELE_SETTINGS_RESET_ALL_COUNTERS_TOOLTIP, "テレポートしたゾーンのカウンタをリセットします。ゾーンの利用回数によるソート順もリセットされます。")
mkstr(SI.TELE_SETTINGS_OFFLINE_NOTE, "オフラインリマインダー")
mkstr(SI.TELE_SETTINGS_OFFLINE_NOTE_TOOLTIP, "しばらくの間オフラインに設定されていた場合、誰かにささやきかけたり移動したりすると、リマインダーとして短い画面メッセージが表示されます。オフライン設定されている間はささやきメッセージを受信することはできず、誰もあなたの所に移動することはできません。(しかし、共有は思いやりです)")
mkstr(SI.TELE_SETTINGS_SCALE, "ウィンドウ・文字・アイコンの大きさ")
mkstr(SI.TELE_SETTINGS_SCALE_TOOLTIP, "BeamMeUpのUI全般のスケール値です。設定値の反映にはリロードが必要となります。")
mkstr(SI.TELE_SETTINGS_RESET_UI, "UI設定を初期化する")
mkstr(SI.TELE_SETTINGS_RESET_UI_TOOLTIP, "当項目のUI設定を初期化します（スケール、ボタンオフセット、ウィンドウ表示位置）。 初期化されたUIがリロードされます。")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION, "重複した調査の地図の通知")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_TOOLTIP, "調査の地図の収穫完了時、インベントリに同じ地図がまだ残っていたら通知を表示します。 (画面中央のメッセージ)")
mkstr(SI.TELE_SETTINGS_HEADER_PRIO, "表示優先度")
mkstr(SI.TELE_SETTINGS_HEADER_CHAT_COMMANDS, "チャットコマンド")
mkstr(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT, "自動解除時、システムメッセージを抑制する")
mkstr(SI.TELE_SETTINGS_UNLOCKING_LESS_CHAT_OUTPUT_TOOLTIP, "自動解除機能の使用時に出力されるシステムメッセージを減少させます。")
mkstr(SI.TELE_SETTINGS_PRIORITIZATION_DESCRIPTION, "テレポート先として利用するプレイヤーの優先度を設定できます。ギルドへの加入と脱退のあとにはリロードが必要です。")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP, "マップにBeamMeUp呼び出しリンクを表示")
mkstr(SI.TELE_SETTINGS_SHOW_BUTTON_ON_MAP_TOOLTIP, "マップ左上にBeamMeUp切り替え用のテキストリンクを表示します。")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND, "通知音")
mkstr(SI.TELE_SETTINGS_SURVEY_MAP_NOTIFICATION_SOUND_TOOLTIP, "この通知を表示する時に音を鳴らします。")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL, "旅の祠へのファストトラベルを自動承認")
mkstr(SI.TELE_SETTINGS_AUTO_CONFIRM_WAYSHRINE_TRAVEL_TOOLTIP, "旅の祠へファストトラベルする時の確認メッセージを表示しません。")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP, "現在のゾーンを常に一番上に表示")
mkstr(SI.TELE_SETTINGS_CURRENT_ZONE_ALWAYS_TOP_TOOLTIP, "現在のゾーンを常にリストの一番上に表示します。")
mkstr(SI.TELE_SETTINGS_HIDE_OWN_HOUSES, "自宅を隠す")
mkstr(SI.TELE_SETTINGS_HIDE_OWN_HOUSES_TOOLTIP, "メインリストから自宅(外へ移動)を隠します。")
mkstr(SI.TELE_SETTINGS_HEADER_STATS, "統計情報")
mkstr(SI.TELE_SETTINGS_MOST_PORTED_ZONES, "最も移動したゾーン：")
mkstr(SI.TELE_SETTINGS_INSTALLED_SCINCE, "インストール日：")
mkstr(SI.TELE_SETTINGS_INFO_CHARACTER_DEPENDING, "この項目はキャラクター毎に設定されます(グローバル設定ではありません)！")
mkstr(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION, "テレポートアニメーション")
mkstr(SI.TELE_SETTINGS_SHOW_TELEPORT_ANIMATION_TOOLTIP, "BeamMeUpでファストトラベルを開始する際に追加のテレポートアニメーションを表示します。記念品「フィヴニールの小装飾品」のアンロックが必要です。")
mkstr(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON, "チャットウィンドウにボタンを表示")
mkstr(SI.TELE_SETTINGS_SHOW_CHAT_BUTTON_TOOLTIP, "BeamMeUpを起動するボタンをチャットウィンドウのヘッダーに表示します。")
mkstr(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM, "パン＆ズーム")
mkstr(SI.TELE_SETTINGS_USE_PAN_AND_ZOOM_TOOLTIP, "グループメンバーや特定のゾーン(ダンジョン、家など)をクリックすると、マップ上の目的地までパン＆ズームします。")
mkstr(SI.TELE_SETTINGS_USE_RALLY_POINT, "マップピン")
mkstr(SI.TELE_SETTINGS_USE_RALLY_POINT_TOOLTIP, "グループメンバーや特定のゾーン(ダンジョン、家など)をクリックすると、マップ上の目的地にピン(再集結地点)を表示します。'LibMapPing'というライブラリがインストールされている必要があります。また覚えておいてほしいのは、あなたがグループリーダーの場合、あなたのピン(再集結地点)はグループメンバー全員に見えるということです。")
mkstr(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS, "プレイヤーや家のないゾーンを表示")
mkstr(SI.TELE_SETTINGS_SHOW_ZONES_WITHOUT_PLAYERS_TOOLTIP, "ファストトラベルできるプレーヤーや家がない場合でも、メインリストにゾーンを表示します。そのゾーンで少なくとも1つの旅の祠を発見していれば、ゴールドを払って移動する選択肢はまだ残っています。")


-----------------------------------------------------------------------------
-- KEY BINDING
-----------------------------------------------------------------------------
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN, "BeamMeUpを開く")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_RELATED_ITEMS, "宝の地図・調査報告・手掛かり")
mkstr(SI.TELE_KEYBINDING_REFRESH, "更新")
mkstr(SI.TELE_KEYBINDING_WAYSHRINE_UNLOCK, "旅の祠を解除する")
mkstr(SI.TELE_KEYBINDING_PRIMARY_RESIDENCE, "本邸の内へ移動")
mkstr(SI.TELE_KEYBINDING_GUILD_HOUSE_BMU, "BeamMeUpギルドハウスを訪ねる")
mkstr(SI.TELE_KEYBINDING_CURRENT_ZONE, "現在のゾーンにテレポート")
mkstr(SI.TELE_KEYBINDING_PRIMARY_RESIDENCE_OUTSIDE, "本邸の外へ移動")
mkstr(SI.TELE_KEYBINDING_TOGGLE_MAIN_DUNGEON_FINDER, "アリーナ / 試練 / ダンジョン")
mkstr(SI.TELE_KEYBINDING_TRACKED_QUEST, "フォーカスしているクエストへの移動")


-----------------------------------------------------------------------------
-- DIALOGS | NOTIFICATIONS
-----------------------------------------------------------------------------
mkstr(SI.TELE_DIALOG_NO_BMU_GUILD_BODY, "申し訳ありません。こちらのメガサーバーにはBeamMeUp公式ギルドがまだ存在しておりません。\n\nこのサーバーでBeamMeUpの公式ギルドを作成するのでしたら、ESOUIのサイトからお気軽にご連絡下さい。")
mkstr(SI.TELE_DIALOG_INFO_BMU_GUILD_BODY, "BeamMeUpをご利用いただき、ありがとうございます。より多くのファストトラベル先を共有するために、2019年よりBeamMeUp公式ギルドの運営を開始致しました。どなたでも入隊を歓迎します。入隊要件、義務はありません。\n\nこちらの確認後に、BeamMeUp公式ギルド＆パートナーギルドの一覧を表示します。入隊を歓迎します！ ギルド画面左上のプルダウンボタンからもギルド検索を行えます。 \nBeamMeUp開発チーム一同")
mkstr(SI.TELE_DIALOG_INFO_NEW_FEATURE_FAVORITE_PLAYER_NOTIFICATION, "お気に入りのプレイヤーがオンラインになりましたら通知（画面中央）を受け取ります。\n\nこの機能を有効にしますか？")
mkstr(SI.TELE_DIALOG_INFO_NEW_FEATURE_SURVEY_MAP_NOTIFICATION, "調査の地図の収穫完了時、インベントリに同じ地図がまだ残っていたら通知を表示します。 (画面中央のメッセージ)\n\nこの機能を有効にしますか？")
mkstr(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_TITLE, "\"Port to Friend's House\"との連携")
mkstr(SI.TELE_DIALOG_PTF_INTEGRATION_MISSING_BODY, "この連携機能を使用するには、アドオン「\"Port to Friend's House\"」のインストールが必要です。アドオンのインストールとお気に入りの設定後に、それらのハウスやギルドホールがこちらに表示されます。\n\n 「\"Port to Friend's House\"」のウェブサイトをブラウザで開きますか？")
-- AUTO UNLOCK: Start Dialog
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_TITLE, "旅の祠の解除を自動で始めますか？")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_BODY, "実行すると、BeamMeUpは現在のゾーンにいる全ての利用可能なプレーヤーのもとへ移動を開始します。旅の祠から旅の祠へ自動的にジャンプすることで、多くのロックを解除することができます。")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_LOOP_OPTION, "ゾーンを巡回する…")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION1, "ランダムシャッフル")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION2, "旅の祠の未発見率")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_ORDER_OPTION3, "プレイヤー数")
mkstr(SI.TELE_DIALOG_AUTO_UNLOCK_CHAT_LOG_OPTION, "チャットで結果を出力")
-- AUTO UNLOCK: Refuse Dialogs
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_TITLE, "現在、旅の祠の解除は実行できません。")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY, "このゾーンの旅の祠は全て解除されました。")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY2, "このゾーンでは旅の祠の解除は実行できません。オーバーランド／リージョンでのみ実行できます。")
mkstr(SI.TELE_DIALOG_REFUSE_AUTO_UNLOCK_BODY3, "残念ながら、このゾーンには移動に利用可能なプレイヤーがいません。")
-- AUTO UNLOCK: Process Dialog
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART, "旅の祠を自動検出中…")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_DISCOVERY, "新たに発見された旅の祠:")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_XP, "獲得したXP:")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_PROGRESS, "進行状況:")
mkstr(SI.TELE_DIALOG_PROCESS_AUTO_UNLOCK_BODY_PART_TIMER, "次のジャンプ:")
-- AUTO UNLOCK: Finish Dialog
mkstr(SI.TELE_DIALOG_FINISH_AUTO_UNLOCK_BODY_PART, "旅の祠の自動検出が完了しました。")
-- AUTO UNLOCK: Timeout Dialog
mkstr(SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_TITLE, "タイムアウト")
mkstr(SI.TELE_DIALOG_TIMEOUT_AUTO_UNLOCK_BODY, "申し訳ありませんが、不明なエラーが発生しました。自動検出はキャンセルされました。")
-- AUTO UNLOCK: Loop Finish Dialog
mkstr(SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_TITLE, "自動検出が終了しました")
mkstr(SI.TELE_DIALOG_LOOP_FINISH_AUTO_UNLOCK_BODY, "もう発見すべきゾーンはありません。ゾーンにプレイヤーがいないか、すでに全ての旅の祠を発見してしまったかのいずれかです。")



-----------------------------------------------------------------------------
-- CENTER SCREEN NOTIFICATIONS
-----------------------------------------------------------------------------
mkstr(SI.TELE_CENTERSCREEN_OFFLINE_NOTE_HEAD, "注意：あなたはまだオフラインに設定されています！")
mkstr(SI.TELE_CENTERSCREEN_OFFLINE_NOTE_BODY, "誰もあなたにささやいたり移動したりできません！\n|c8c8c8c(通知はBeamMeUpの設定で無効にできます)")
mkstr(SI.TELE_CENTERSCREEN_SURVEY_MAPS, "%d 枚の調査報告が残っています！ リスポーン後に戻ってきてください！")
mkstr(SI.TELE_CENTERSCREEN_FAVORITE_PLAYER_ONLINE, "がオンラインになりました！")



-----------------------------------------------------------------------------
-- ITEM NAMES (PART OF IT) - BACKUP
-----------------------------------------------------------------------------
mkstr(SI.CONSTANT_TREASURE_MAP, "宝箱の地図") -- need a part of the item name that is in every treasure map item the same no matter which zone
mkstr(SI.CONSTANT_SURVEY_MAP, "調査:") -- need a part of the item name that is in every survey map item the same no matter which zone and kind of craft

