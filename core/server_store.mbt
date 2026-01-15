///|
/// サーバーサイドチャットストア
pub(all) struct ChatStore {
  mut messages : Array[Message]
  mut typing_users : Array[User]
  mut connected : Bool
  mut message_counter : Int
}

///|
/// 新しいストアを作成
pub fn ChatStore::new() -> ChatStore {
  { messages: [], typing_users: [], connected: false, message_counter: 0 }
}

///|
/// 接続状態を取得
pub fn ChatStore::is_connected(self : ChatStore) -> Bool {
  self.connected
}

///|
/// 接続状態を設定
pub fn ChatStore::set_connected(self : ChatStore, connected : Bool) -> Unit {
  self.connected = connected
}

///|
/// メッセージリストを取得
pub fn ChatStore::get_messages(self : ChatStore) -> Array[Message] {
  self.messages
}

///|
/// メッセージを追加
pub fn ChatStore::add_message(self : ChatStore, message : Message) -> Unit {
  self.messages.push(message)
}

///|
/// 新しいメッセージIDを生成
pub fn ChatStore::next_message_id(self : ChatStore) -> String {
  self.message_counter = self.message_counter + 1
  "m" + self.message_counter.to_string()
}

///|
/// メッセージをIDで検索
pub fn ChatStore::find_message(self : ChatStore, id : String) -> Message? {
  for msg in self.messages {
    if msg.id == id {
      return Some(msg)
    }
  }
  None
}

///|
/// メッセージステータスを更新
pub fn ChatStore::update_message_status(
  self : ChatStore,
  id : String,
  status : MessageStatus,
) -> Bool {
  for i = 0; i < self.messages.length(); i = i + 1 {
    if self.messages[i].id == id {
      self.messages[i] = self.messages[i].set_status(status)
      return true
    }
  }
  false
}

///|
/// タイピング中ユーザーリストを取得
pub fn ChatStore::get_typing_users(self : ChatStore) -> Array[User] {
  self.typing_users
}

///|
/// タイピング中ユーザーを設定
pub fn ChatStore::set_typing_users(
  self : ChatStore,
  users : Array[User],
) -> Unit {
  self.typing_users = users
}

///|
/// ユーザーのタイピング状態を設定
pub fn ChatStore::set_user_typing(
  self : ChatStore,
  user : User,
  typing : Bool,
) -> Unit {
  if typing {
    let exists = self.typing_users.any(u => u.id == user.id)
    if not(exists) {
      self.typing_users.push(user)
    }
  } else {
    self.typing_users = self.typing_users.filter(u => u.id != user.id)
  }
}

///|
/// グローバルストアインスタンス
pub let global_store : ChatStore = ChatStore::new()
