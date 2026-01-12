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
pub type DomNode = @components.DomNode

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

///|
pub fn message_bubble(message : Message, self_id? : String) -> DomNode {
  @components.message_bubble(message, self_id?)
}

///|
pub fn message_list(store : ChatStore, self_id? : String) -> DomNode {
  @components.message_list(store, self_id?)
}

///|
pub fn input_area(
  on_send : (String) -> Unit,
  placeholder? : String = "Type a message...",
  disabled? : Bool = false,
) -> DomNode {
  @components.input_area(on_send, placeholder=placeholder, disabled=disabled)
}
