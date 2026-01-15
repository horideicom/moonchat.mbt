///|
/// HTML DSLビュー関数
using @html {
  type Html,
  div,
  span,
  p,
  h1,
  header,
  main_el,
  section,
  button,
  form,
  textarea,
  fragment,
  doctype,
  html,
  head,
  body,
  meta,
  title,
  style,
  script,
  small,
}

///|
/// CSSスタイル
pub fn render_css() -> String {
  ".mc-message-list{display:flex;flex-direction:column;gap:12px}.mc-message-bubble{display:flex;flex-direction:column;gap:4px;max-width:70%}.mc-message-bubble--inbound{align-self:flex-start}.mc-message-bubble--outbound{align-self:flex-end}.mc-message-bubble--system{align-self:center;text-align:center}.mc-message-bubble__body{background:#334155;padding:10px 14px;border-radius:16px;border-bottom-left-radius:4px}.mc-message-bubble--outbound .mc-message-bubble__body{background:#3b82f6;border-radius:16px;border-bottom-right-radius:4px}.mc-message-bubble__text{word-wrap:break-word;white-space:pre-wrap}.mc-input-area{display:flex;flex-direction:column;gap:12px}.mc-input-area__field{flex:1;min-height:80px;padding:12px;background:#334155;color:#f1f5f9;border:1px solid #334155;border-radius:12px;resize:none;font-family:inherit}.mc-input-area__send{padding:12px 24px;background:#3b82f6;color:#fff;border:none;border-radius:12px;cursor:pointer}.mc-demo{display:flex;flex-direction:column;height:100vh;max-width:900px;margin:0 auto}.mc-demo__header{background:#1e293b;border-bottom:1px solid #334155;padding:16px 20px;display:flex;align-items:center;justify-content:space-between}.mc-demo__main{flex:1;display:flex;flex-direction:column;overflow:hidden}.mc-demo__messages{flex:1;overflow-y:auto;padding:16px}.mc-demo__composer{background:#1e293b;border-top:1px solid #334155;padding:16px}.mc-demo__controls{display:flex;gap:8px;margin-top:12px}.mc-demo__button{padding:8px 16px;background:#334155;color:#f1f5f9;border:1px solid #334155;border-radius:8px;cursor:pointer}"
}

///|
/// メッセージバブルをレンダリング
pub fn render_message_bubble(message : @core.Message, self_id : String) -> Html {
  match message.content {
    @core.MessageContent::System(body) =>
      div().class("mc-message-bubble mc-message-bubble--system").text(body)
    _ => {
      let outbound = self_id == message.sender.id
      let bubble_class = if outbound {
        "mc-message-bubble mc-message-bubble--outbound"
      } else {
        "mc-message-bubble mc-message-bubble--inbound"
      }
      div()
      .class(bubble_class)
      .children([
        div()
        .class("mc-message-bubble__meta")
        .children([
          span().class("mc-message-bubble__author").text(message.sender.name),
          span()
          .class("mc-message-bubble__time")
          .text(message.timestamp_ms.to_string()),
        ]),
        div()
        .class("mc-message-bubble__body")
        .children([
          p()
          .class("mc-message-bubble__text")
          .text(
            match message.content {
              @core.MessageContent::Text(s) => s
              @core.MessageContent::Markdown(s) => s
              @core.MessageContent::Image(..) => "[Image]"
              @core.MessageContent::System(s) => s
            },
          ),
        ]),
        span()
        .class("mc-message-bubble__status")
        .text(status_to_string(message.status)),
      ])
    }
  }
}

///|
fn status_to_string(status : @core.MessageStatus) -> String {
  match status {
    _ => "送信済み"
  }
}

///|
/// メッセージリストをレンダリング
pub fn render_message_list(
  messages : Array[@core.Message],
  self_id : String,
) -> Html {
  let message_htmls = messages.map(msg => render_message_bubble(msg, self_id))
  div().id("message-list").class("mc-message-list").children(message_htmls)
}

///|
/// 入力エリアをレンダリング
pub fn render_input_area() -> Html {
  let send_attrs = post_attrs("/messages", "innerHTML", "#message-list")
  div()
  .class("mc-input-area")
  .children([
    form()
    .attrs(send_attrs)
    .children([
      textarea()
      .name("message")
      .class("mc-input-area__field")
      .placeholder("メッセージを入力...")
      .empty(),
      button().class("mc-input-area__send").text("送信"),
    ]),
  ])
}

///|
/// ページ全体をレンダリング
pub fn render_page(
  messages : Array[@core.Message],
  connected : Bool,
  self_id : String,
) -> String {
  let status_class = if connected { "online" } else { "" }
  let status_text = if connected { "Online" } else { "Offline" }
  fragment([
    doctype(),
    html()
    .attr_str("lang", "ja")
    .children([
      head().children([
        meta().attr_str("charset", "UTF-8").empty(),
        meta()
        .attr_str("name", "viewport")
        .attr_str("content", "width=device-width, initial-scale=1")
        .empty(),
        title().text("MoonChat - HDA"),
        style().child(@html.raw(render_css())),
        script().attr_str("src", "/assets/htmx.js").empty(),
      ]),
      body().children([
        div()
        .class("mc-demo")
        .children([
          header()
          .class("mc-demo__header")
          .children([
            div()
            .class("mc-demo__title")
            .children([
              h1().class("mc-demo__title-text").text("MoonChat"),
              small()
              .class("mc-demo__subtitle")
              .text("Hypermedia Driven Application"),
            ]),
            div()
            .class("mc-demo__meta")
            .children([
              span().class("mc-demo__status-label").text("状態: "),
              span()
              .class("mc-demo__status-value " + status_class)
              .text(status_text),
            ]),
          ]),
          main_el()
          .class("mc-demo__main")
          .children([
            section()
            .class("mc-demo__messages")
            .children([render_message_list(messages, self_id)]),
            div()
            .class("mc-demo__composer")
            .children([
              render_input_area(),
              div()
              .class("mc-demo__controls")
              .children([
                button()
                .hx_post("/simulate")
                .hx_swap("beforeend")
                .hx_target("#message-list")
                .class("mc-demo__button")
                .text("ボット応答をシミュレート"),
              ]),
            ]),
          ]),
        ]),
      ]),
    ]),
  ]).render()
}
