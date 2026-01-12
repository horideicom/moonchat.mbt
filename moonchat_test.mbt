///|
test "message status updates" {
  let user = User::{ id: "u1", name: "Alice", avatar_url: None }
  let message = new_message("m1", user, MessageContent::Text("hi"), 0L)
  inspect(message.status_value(), content="Sending")
  message.set_status(MessageStatus::Delivered)
  inspect(message.status_value(), content="Delivered")
}

///|
test "store add and update" {
  let store = new_store()
  let user = User::{ id: "u1", name: "Alice", avatar_url: None }
  let message = new_message("m1", user, MessageContent::Text("hi"), 0L)
  store.add_message(message)
  inspect(store.messages_signal().get().length(), content="1")
  let updated = store.update_message_status("m1", MessageStatus::Read)
  inspect(updated, content="true")
  let first = store.messages_signal().get()[0]
  inspect(first.status_value(), content="Read")
}

///|
test "typing users" {
  let store = new_store()
  let user = User::{ id: "u1", name: "Alice", avatar_url: None }
  store.set_user_typing(user, true)
  inspect(store.typing_users_signal().get().length(), content="1")
  store.set_user_typing(user, false)
  inspect(store.typing_users_signal().get().length(), content="0")
}
