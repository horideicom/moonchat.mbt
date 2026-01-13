///|
using @element {
  button,
  div,
  events,
  h1,
  header_,
  main_,
  p,
  section,
  span,
  text,
  text_dyn,
}

///|
fn next_message_id(counter : Ref[Int]) -> String {
  counter.val = counter.val + 1
  "m" + counter.val.to_string()
}

///|
fn next_timestamp(counter : Ref[Int64]) -> Int64 {
  counter.val = counter.val + 1L
  counter.val
}

///|
fn add_message(
  store : @lib.ChatStore,
  id_counter : Ref[Int],
  ts_counter : Ref[Int64],
  sender : @lib.User,
  content : @lib.MessageContent,
  status? : @lib.MessageStatus = @lib.MessageStatus::Delivered,
) -> String {
  let id = next_message_id(id_counter)
  let timestamp = next_timestamp(ts_counter)
  let message = @lib.new_message(id, sender, content, timestamp, status~)
  store.add_message(message)
  id
}

///|
fn schedule_outbound_status(
  store : @lib.ChatStore,
  win : @js_dom.Window,
  id : String,
) -> Unit {
  let _ = win.setTimeout(
    fn() {
      let _ = store.update_message_status(id, @lib.MessageStatus::Sent)

    },
    250,
  )
  let _ = win.setTimeout(
    fn() {
      let _ = store.update_message_status(id, @lib.MessageStatus::Delivered)

    },
    900,
  )
  let _ = win.setTimeout(
    fn() {
      let _ = store.update_message_status(id, @lib.MessageStatus::Read)

    },
    1600,
  )

}

///|
fn queue_bot_reply(
  store : @lib.ChatStore,
  win : @js_dom.Window,
  id_counter : Ref[Int],
  ts_counter : Ref[Int64],
  bot : @lib.User,
  body : String,
) -> Unit {
  store.set_user_typing(bot, true)
  let _ = win.setTimeout(
    fn() {
      store.set_user_typing(bot, false)
      let _ = add_message(
        store,
        id_counter,
        ts_counter,
        bot,
        @lib.MessageContent::Markdown(body),
      )

    },
    800,
  )

}

///|
fn build_demo_view(
  store : @lib.ChatStore,
  self_id : String,
  on_send : (String) -> Unit,
  on_simulate : () -> Unit,
) -> @lib.DomNode {
  div(class="mc-demo", [
    header_(class="mc-demo__header", [
      div(class="mc-demo__title", [
        h1(class="mc-demo__title-text", [text("MoonChat")]),
        p(class="mc-demo__subtitle", [text("Local JS demo for MoonBit + Luna")]),
      ]),
      div(class="mc-demo__meta", [
        span(class="mc-demo__status-label", [text("Status")]),
        span(class="mc-demo__status-value", [
          text_dyn(fn() {
            if store.connection_signal().get() {
              "Online"
            } else {
              "Offline"
            }
          }),
        ]),
      ]),
    ]),
    main_(class="mc-demo__main", [
      section(class="mc-demo__messages", [@lib.message_list(store, self_id~)]),
      div(class="mc-demo__composer", [
        @lib.input_area(on_send, placeholder="Write a message..."),
        div(class="mc-demo__controls", [
          button(
            class="mc-demo__button",
            on=events().click(fn(_) { on_simulate() }),
            [text("Simulate reply")],
          ),
        ]),
      ]),
    ]),
  ])
}

///|
fn ensure_root(id : String) -> @element.DomElement {
  let doc = @js_dom.document()
  match doc.getElementById(id) {
    Some(existing) => @element.DomElement::from_dom(existing)
    None => {
      let root = doc.createElement("div")
      root.setId(id)
      match doc.body() {
        Some(body) => body.as_node().appendChild(root.as_node()) |> ignore
        None => ()
      }
      @element.DomElement::from_dom(root)
    }
  }
}

///|
fn main {
  let store = @lib.new_store()
  store.set_connected(true)
  let self_user = @lib.User::{ id: "u_self", name: "You", avatar_url: None }
  let bot_user = @lib.User::{ id: "u_bot", name: "Nova", avatar_url: None }
  let id_counter : Ref[Int] = { val: 0 }
  let ts_counter : Ref[Int64] = { val: 0L }
  let win = @js_dom.window()
  let _ = add_message(
    store,
    id_counter,
    ts_counter,
    bot_user,
    @lib.MessageContent::System(
      "Welcome to MoonChat. This UI is fully reactive.",
    ),
  )
  let _ = add_message(
    store,
    id_counter,
    ts_counter,
    bot_user,
    @lib.MessageContent::Text("Try sending a message below."),
  )
  let _ = add_message(
    store,
    id_counter,
    ts_counter,
    self_user,
    @lib.MessageContent::Text("Hello, Nova!"),
    status=@lib.MessageStatus::Read,
  )
  let image_url = "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='320' height='180'><rect width='100%' height='100%' fill='%231f2937'/><text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' fill='white' font-size='18' font-family='sans-serif'>MoonChat</text></svg>"
  let _ = add_message(
    store,
    id_counter,
    ts_counter,
    bot_user,
    @lib.MessageContent::Image(url=image_url, caption=Some("Inline SVG banner")),
  )
  fn handle_send(body : String) -> Unit {
    let id = add_message(
      store,
      id_counter,
      ts_counter,
      self_user,
      @lib.MessageContent::Text(body),
      status=@lib.MessageStatus::Sending,
    )
    schedule_outbound_status(store, win, id)
    queue_bot_reply(
      store, win, id_counter, ts_counter, bot_user, "Nice. Want to try a *markdown* message next?",
    )
  }

  fn handle_simulate() -> Unit {
    queue_bot_reply(
      store, win, id_counter, ts_counter, bot_user, "Here's a simulated reply with **bold** + _italic_ text.",
    )
  }

  let root = ensure_root("app")
  let view = build_demo_view(store, self_user.id, handle_send, handle_simulate)
  @element.render(root, view)
}
