///|
/// ユーザー型
pub(all) struct User {
  id : String
  name : String
  avatar_url : String?
} derive(Show, Eq)

///|
/// メッセージ状態
pub(all) enum MessageStatus {
  Sending
  Sent
  Delivered
  Read
  Failed
} derive(Show, Eq)

///|
/// メッセージコンテンツ
pub(all) enum MessageContent {
  Text(String)
  Markdown(String)
  Image(url~ : String, caption~ : String?)
  System(String)
} derive(Show, Eq)

///|
/// メッセージ（サーバーサイド版 - リアクティブシグナルなし）
pub struct Message {
  id : String
  sender : User
  content : MessageContent
  timestamp_ms : Int64
  status : MessageStatus
}

///|
/// メッセージを作成
pub fn Message::new(
  id : String,
  sender : User,
  content : MessageContent,
  timestamp_ms : Int64,
  status? : MessageStatus = MessageStatus::Sending,
) -> Message {
  { id, sender, content, timestamp_ms, status }
}

///|
/// メッセージステータスを更新
pub fn Message::set_status(self : Message, status : MessageStatus) -> Message {
  { ..self, status, }
}

///|
/// 不変スナップショット
pub struct MessageSnapshot {
  id : String
  sender : User
  content : MessageContent
  timestamp_ms : Int64
  status : MessageStatus
} derive(Show, Eq)

///|
/// スナップショットを作成
pub fn Message::snapshot(self : Message) -> MessageSnapshot {
  {
    id: self.id,
    sender: self.sender,
    content: self.content,
    timestamp_ms: self.timestamp_ms,
    status: self.status,
  }
}

///|
/// MessageContent::Textを作成
pub fn text_content(s : String) -> MessageContent {
  MessageContent::Text(s)
}

///|
/// MessageContent::Systemを作成
pub fn system_content(s : String) -> MessageContent {
  MessageContent::System(s)
}

///|
/// MessageStatus::Sentを作成
pub fn sent_status() -> MessageStatus {
  MessageStatus::Sent
}

///|
/// MessageStatus::Sendingを作成
pub fn sending_status() -> MessageStatus {
  MessageStatus::Sending
}
