///|
/// HTTPハンドラー（JSターゲット用）

///|
/// HTTPレスポンス
pub struct HttpResponse {
  status_code : Int
  headers : Array[(String, String)]
  body : String
}

///|
/// HTMLレスポンスを作成
pub fn html_response(body : String) -> HttpResponse {
  {
    status_code: 200,
    headers: [("Content-Type", "text/html; charset=utf-8")],
    body,
  }
}

///|
/// HDAレスポンスを作成（簡易版）
pub fn hda_response(body : String) -> HttpResponse {
  {
    status_code: 200,
    headers: [
      ("Content-Type", "text/html; charset=utf-8"),
      ("HX-Reswap", "innerHTML"),
    ],
    body,
  }
}

///|
/// ルートハンドラー - メインページを返す
pub fn handle_root(store : @core.ChatStore, self_id : String) -> HttpResponse {
  let messages = store.get_messages()
  let connected = store.is_connected()
  let html = render_page(messages, connected, self_id)
  html_response(html)
}

///|
/// メッセージリスト断片を返す
pub fn handle_message_list(
  store : @core.ChatStore,
  self_id : String,
) -> HttpResponse {
  let messages = store.get_messages()
  let html = render_message_list(messages, self_id).render()
  hda_response(html)
}

///|
/// メッセージ送信ハンドラー
pub fn handle_send_message(
  store : @core.ChatStore,
  body : String,
  self_user : @core.User,
) -> HttpResponse {
  let params = parse_form_urlencoded(body)
  match params.get("message") {
    Some(msg_text) => {
      let id = store.next_message_id()
      let timestamp = 0L
      let message = @core.Message::new(
        id,
        self_user,
        @core.text_content(msg_text),
        timestamp,
      )
      store.add_message(message)
      let messages = store.get_messages()
      let html = render_message_list(messages, self_user.id).render()
      hda_response(html)
    }
    None =>
      {
        status_code: 400,
        headers: [("Content-Type", "text/plain")],
        body: "Missing message parameter",
      }
  }
}

///|
/// ボット応答シミュレーションハンドラー
pub fn handle_simulate(
  store : @core.ChatStore,
  bot_user : @core.User,
) -> HttpResponse {
  let id = store.next_message_id()
  let timestamp = 0L
  let responses = [
    "こんにちは！何かお手伝いできることはありますか？", "なるほど、興味深いですね。",
    "わかりました。もう少し詳しく教えていただけますか？",
    "それは素晴らしいアイデアですね！", "そうですね、続けてください。",
  ]
  let idx = (id.length() - 1) % responses.length()
  let response = responses[idx]
  let message = @core.Message::new(
    id,
    bot_user,
    @core.text_content(response),
    timestamp,
  )
  store.add_message(message)
  let messages = store.get_messages()
  let html = render_message_list(messages, bot_user.id).render()
  hda_response(html)
}

///|
/// application/x-www-form-urlencoded をパース（簡易版）
fn parse_form_urlencoded(body : String) -> @hashmap.HashMap[String, String] {
  let result = @hashmap.new()
  let pairs = body.split("&").to_array()
  for pair in pairs {
    let parts = pair.split("=").to_array()
    if parts.length() == 2 {
      let key = parts[0].to_string()
      let value = parts[1].to_string()
      result.set(key, value)
    }
  }
  result
}
