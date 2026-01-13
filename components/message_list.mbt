///|
using @core {type ChatStore, type User}

///|
fn typing_label(users : Array[User]) -> String {
  let names = users.map(fn(user) { user.name })
  let joined = names.join(", ")
  "\{joined} typing..."
}

///|
fn typing_indicator(store : ChatStore) -> DomNode {
  show(fn() { store.typing_users_signal().get().length() > 0 }, fn() {
    div(class="mc-message-list__typing", [
      text(typing_label(store.typing_users_signal().get())),
    ])
  })
}

///|
pub fn message_list(store : ChatStore, self_id? : String) -> DomNode {
  div(class="mc-message-list", [
    for_each(fn() { store.messages_signal().get() }, fn(message, _) {
      message_bubble(message, self_id?)
    }),
    typing_indicator(store),
  ])
}
