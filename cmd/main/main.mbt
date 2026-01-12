///|
fn main {
  let store = @lib.new_store()
  let user = @lib.User::{ id: "u1", name: "Alice", avatar_url: None }
  let message = @lib.new_message("m1", user, @lib.MessageContent::Text("hello"), 0L)
  store.add_message(message)
  println(store.messages_signal().get().length())
}
