///|
/// MoonChat HDAサーバー
using @http {Request, Response, Method, Server}

///|
/// デモユーザー定義
let self_user : @core.User = { id: "u_self", name: "You", avatar_url: None }

///|
let bot_user : @core.User = { id: "u_bot", name: "Nova", avatar_url: None }

///|
/// 初期メッセージを設定
fn initialize_store(store : @core.ChatStore) -> Unit {
  store.set_connected(true)
  let welcome_msg = @core.Message::new(
    store.next_message_id(),
    bot_user,
    @core.MessageContent::System(
      "MoonChatへようこそ。HDAパターンで構築されています。",
    ),
    0L,
    status=@core.MessageStatus::Sent,
  )
  store.add_message(welcome_msg)
  let hello_msg = @core.Message::new(
    store.next_message_id(),
    bot_user,
    @core.MessageContent::Text(
      "下の入力フィールドにメッセージを入力してください。",
    ),
    0L,
    status=@core.MessageStatus::Sent,
  )
  store.add_message(hello_msg)
}

///|
/// メインハンドラー
fn handler(runtime_js : Bytes?, req : Request) -> Response {
  let store = @core.global_store

  match (req.mthd, req.path) {
    (Method::Get, "/") =>
      @web.handle_root(store, self_user.id),
    (Method::Get, "/messages") =>
      @web.handle_message_list(store, self_user.id~),
    (Method::Post, "/messages") =>
      @web.handle_send_message(store, req.body, self_user, bot_user),
    (Method::Post, "/typing") =>
      @web.handle_typing(store, self_user.id, self_user.name),
    (Method::Post, "/simulate") =>
      @web.handle_simulate(store, bot_user),
    (Method::Get, "/assets/htmx.js") =>
      match runtime_js {
        Some(js) =>
          Response::ok()
          .content_type("application/javascript; charset=utf-8")
          .bytes(js)
        None => Response::not_found().text("Missing assets/htmx.js. Build with 'make client-runtime' in engeni.mbt")
      }
    (_, _) =>
      Response::not_found().text("404 - Not Found"),
  }
}

///|
/// サーバーを起動
async fn start_server() -> Unit {
  let store = @core.global_store
  initialize_store(store)
  let runtime_js = @http.load_asset_bytes("../assets/htmx.js")
  if runtime_js is None {
    println("Warning: assets/htmx.js not found.")
    println("Please build the htmx runtime from engeni.mbt:")
    println("  cd ../engenis.mbt && make client-runtime")
    println("  cp target/js/release/build/htmx.js ../moonchat.mbt/assets/")
  }
  let server = Server::bind("127.0.0.1:8080", fn(req) {
    handler(runtime_js, req)
  }) catch {
    _err => {
      println("Failed to create server")
      return
    }
  }
  println("========================================")
  println("  MoonChat HDA Server")
  println("========================================")
  println("")
  println("Server running at http://127.0.0.1:8080")
  println("Press Ctrl+C to stop")
  println("")
  server.run_forever()
}

///|
/// エントリーポイント
async fn main {
  start_server()
}
