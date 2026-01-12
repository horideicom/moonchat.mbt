///|
using @element { button, div, events, text, textarea, type DomNode }

///|
using @signal { signal }

///|
pub fn input_area(
  on_send : (String) -> Unit,
  placeholder? : String = "Type a message...",
  disabled? : Bool = false,
) -> DomNode {
  let text_value = signal("")

  fn send_current() -> Unit {
    let current = text_value.get()
    let trimmed = current.trim()
    if trimmed.length() == 0 {
      return
    }
    on_send(current)
    text_value.set("")
  }

  fn handle_input(ev : @js_dom.InputEvent) -> Unit {
    let target : @js_dom.HTMLTextAreaElement = ev.target() |> @core.identity
    text_value.set(target.value)
  }

  fn handle_keydown(ev : @js_dom.KeyboardEvent) -> Unit {
    if ev.key == "Enter" && not(ev.shiftKey) {
      ev.preventDefault()
      send_current()
    }
  }

  div(
    class="mc-input-area",
    [
      textarea(
        class="mc-input-area__field",
        placeholder=placeholder,
        disabled=disabled,
        on=events().input(handle_input).keydown(handle_keydown),
        dyn_attrs=[
          ("value", @element.AttrValue::Dynamic(fn() { text_value.get() })),
        ],
        [],
      ),
      button(
        class="mc-input-area__send",
        on=events().click(fn(_) { send_current() }),
        dyn_disabled=fn() { disabled || text_value.get().trim().length() == 0 },
        [text("Send")],
      ),
    ],
  )
}
