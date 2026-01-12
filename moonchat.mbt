///|
pub type User = @core.User

///|
pub type MessageStatus = @core.MessageStatus

///|
pub type MessageContent = @core.MessageContent

///|
pub type MessageSnapshot = @core.MessageSnapshot

///|
pub type Message = @core.Message

///|
pub type ChatStore = @core.ChatStore

///|
pub fn new_store() -> ChatStore {
  @core.ChatStore::new()
}

///|
pub fn new_message(
  id : String,
  sender : User,
  content : MessageContent,
  timestamp_ms : Int64,
  status? : MessageStatus = MessageStatus::Sending,
) -> Message {
  @core.Message::new(
    id,
    sender,
    content,
    timestamp_ms,
    status=status,
  )
}
