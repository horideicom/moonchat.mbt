///|
pub struct Message {
  id : String
  sender : User
  content : MessageContent
  timestamp_ms : Int64
  status : @luna.Signal[MessageStatus]
}

///|
pub fn Message::new(
  id : String,
  sender : User,
  content : MessageContent,
  timestamp_ms : Int64,
  status? : MessageStatus = MessageStatus::Sending,
) -> Message {
  {
    id,
    sender,
    content,
    timestamp_ms,
    status: @luna.signal(status),
  }
}

///|
pub fn Message::status_value(self : Message) -> MessageStatus {
  self.status.get()
}

///|
pub fn Message::set_status(self : Message, status : MessageStatus) -> Unit {
  self.status.set(status)
}

///|
pub fn Message::snapshot(self : Message) -> MessageSnapshot {
  {
    id: self.id,
    sender: self.sender,
    content: self.content,
    timestamp_ms: self.timestamp_ms,
    status: self.status.get(),
  }
}

///|
pub struct ChatStore {
  messages : @luna.Signal[Array[Message]]
  typing_users : @luna.Signal[Array[User]]
  is_connected : @luna.Signal[Bool]
}

///|
pub fn ChatStore::new() -> ChatStore {
  {
    messages: @luna.signal([]),
    typing_users: @luna.signal([]),
    is_connected: @luna.signal(false),
  }
}

///|
pub fn ChatStore::messages_signal(self : ChatStore) -> @luna.Signal[Array[Message]] {
  self.messages
}

///|
pub fn ChatStore::typing_users_signal(self : ChatStore) -> @luna.Signal[Array[User]] {
  self.typing_users
}

///|
pub fn ChatStore::connection_signal(self : ChatStore) -> @luna.Signal[Bool] {
  self.is_connected
}

///|
pub fn ChatStore::set_connected(self : ChatStore, connected : Bool) -> Unit {
  self.is_connected.set(connected)
}

///|
pub fn ChatStore::set_messages(
  self : ChatStore,
  messages : Array[Message],
) -> Unit {
  self.messages.set(messages)
}

///|
pub fn ChatStore::add_message(self : ChatStore, message : Message) -> Unit {
  self.messages.update(fn (current) {
    let next = current.copy()
    next.push(message)
    next
  })
}

///|
pub fn ChatStore::update_message_status(
  self : ChatStore,
  message_id : String,
  status : MessageStatus,
) -> Bool {
  for message in self.messages.get() {
    if message.id == message_id {
      message.set_status(status)
      return true
    }
  }
  false
}

///|
pub fn ChatStore::set_typing_users(self : ChatStore, users : Array[User]) -> Unit {
  self.typing_users.set(users)
}

///|
pub fn ChatStore::set_user_typing(
  self : ChatStore,
  user : User,
  typing : Bool,
) -> Unit {
  self.typing_users.update(fn (current) {
    if typing {
      let exists = current.any(u => u.id == user.id)
      if exists {
        current
      } else {
        let next = current.copy()
        next.push(user)
        next
      }
    } else {
      current.filter(u => u.id != user.id)
    }
  })
}
