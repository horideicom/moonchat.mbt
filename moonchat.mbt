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
pub type Html = @html.Html

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
  @core.Message::new(id, sender, content, timestamp_ms, status~)
}

///|
pub fn render_css() -> String {
  @web.render_css()
}

///|
pub fn render_message_bubble(message : Message, self_id : String) -> Html {
  @web.render_message_bubble(message, self_id)
}

///|
pub fn render_message_list(messages : Array[Message], self_id : String) -> Html {
  @web.render_message_list(messages, self_id)
}

///|
pub fn render_input_area() -> Html {
  @web.render_input_area()
}

///|
pub fn render_page(
  messages : Array[Message],
  connected : Bool,
  self_id : String,
) -> String {
  @web.render_page(messages, connected, self_id)
}
