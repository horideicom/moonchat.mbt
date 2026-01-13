///|
using @core {type Message, type MessageContent}

///|
fn bubble_class(message : Message, self_id : String?) -> String {
  let base = "mc-message-bubble"
  match self_id {
    Some(id) if id == message.sender.id => base + " " + base + "--outbound"
    _ => base + " " + base + "--inbound"
  }
}

///|
fn render_message_content(content : MessageContent) -> DomNode {
  match content {
    MessageContent::Text(body) =>
      p(class="mc-message-bubble__text", [text(body)])
    MessageContent::Markdown(body) =>
      p(class="mc-message-bubble__markdown", [text(body)])
    MessageContent::Image(url~, caption~) => {
      let children : Array[DomNode] = [
        img(
          src=url,
          alt=caption.unwrap_or(""),
          class="mc-message-bubble__image",
        ),
      ]
      if caption is Some(caption_text) {
        children.push(
          span(class="mc-message-bubble__caption", [text(caption_text)]),
        )
      }
      div(class="mc-message-bubble__media", children)
    }
    MessageContent::System(body) =>
      div(class="mc-message-bubble__system", [text(body)])
  }
}

///|
pub fn message_bubble(message : Message, self_id? : String) -> DomNode {
  match message.content {
    MessageContent::System(body) =>
      div(class="mc-message-bubble mc-message-bubble--system", [text(body)])
    _ =>
      div(class=bubble_class(message, self_id), [
        div(class="mc-message-bubble__meta", [
          span(class="mc-message-bubble__author", [text(message.sender.name)]),
          span(class="mc-message-bubble__time", [
            text(message.timestamp_ms.to_string()),
          ]),
        ]),
        div(class="mc-message-bubble__body", [
          render_message_content(message.content),
        ]),
        span(class="mc-message-bubble__status", [
          text_dyn(fn() { message.status_value().to_string() }),
        ]),
      ])
  }
}
