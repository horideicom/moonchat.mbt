///|
/// 属性値
pub enum AttrValue {
  Str(String)
  Bool(Bool)
  Int(Int)
  None
} derive(Show, Eq)

///|
pub fn AttrValue::to_string(self : AttrValue) -> String {
  match self {
    Str(s) => s
    Bool(true) => "true"
    Bool(false) => "false"
    Int(i) => i.to_string()
    None => ""
  }
}

///|
/// 文字列からAttrValueを作成
pub fn attr_value_str(s : String) -> AttrValue {
  AttrValue::Str(s)
}

///|
/// 文字列からAttrsを作成
pub fn attr_str(key : String, value : String) -> Attrs {
  Attrs::new().add(key, attr_value_str(value))
}

///|
/// 属性セット
pub struct Attrs {
  attrs : Array[(String, AttrValue)]
} derive(Show)

///|
pub fn Attrs::new() -> Attrs {
  { attrs: [] }
}

///|
pub fn Attrs::add(self : Attrs, key : String, value : AttrValue) -> Attrs {
  { attrs: [(key, value)] + self.attrs }
}

///|
/// 2つの Attrs をマージする（prefer の属性が優先）
pub fn Attrs::merge(prefer : Attrs, fallback : Attrs) -> Attrs {
  // prefer のキーを追跡
  let prefer_keys = @hashmap.new()
  for i = 0; i < prefer.attrs.length(); i = i + 1 {
    let (key, _) = prefer.attrs[i]
    prefer_keys.set(key, "marker")
  }

  // fallback の重複しない属性を収集
  let mut unique_fallback = []
  for i = 0; i < fallback.attrs.length(); i = i + 1 {
    let (key, value) = fallback.attrs[i]
    match prefer_keys.get(key) {
      Some(_) => () // prefer に存在する場合はスキップ
      None => unique_fallback = unique_fallback + [(key, value)]
    }
  }

  // prefer + unique_fallback（順序を維持）
  { attrs: prefer.attrs + unique_fallback }
}

///|
pub fn Attrs::class(self : Attrs, name : String) -> Attrs {
  self.add("class", Str(name))
}

///|
pub fn Attrs::id(self : Attrs, id : String) -> Attrs {
  self.add("id", Str(id))
}

///|
pub fn Attrs::href(self : Attrs, url : String) -> Attrs {
  self.add("href", Str(url))
}

///|
pub fn Attrs::attr_type(self : Attrs, t : String) -> Attrs {
  self.add("type", Str(t))
}

///|
pub fn Attrs::name(self : Attrs, n : String) -> Attrs {
  self.add("name", Str(n))
}

///|
/// Htmx属性: hx-get
pub fn Attrs::hx_get(self : Attrs, url : String) -> Attrs {
  self.add("hx-get", Str(url))
}

///|
/// Htmx属性: hx-post
pub fn Attrs::hx_post(self : Attrs, url : String) -> Attrs {
  self.add("hx-post", Str(url))
}

///|
/// Htmx属性: hx-put
pub fn Attrs::hx_put(self : Attrs, url : String) -> Attrs {
  self.add("hx-put", Str(url))
}

///|
/// Htmx属性: hx-delete
pub fn Attrs::hx_delete(self : Attrs, url : String) -> Attrs {
  self.add("hx-delete", Str(url))
}

///|
/// Htmx属性: hx-patch
pub fn Attrs::hx_patch(self : Attrs, url : String) -> Attrs {
  self.add("hx-patch", Str(url))
}

///|
/// Htmx属性: hx-swap
pub fn Attrs::hx_swap(self : Attrs, swap : String) -> Attrs {
  self.add("hx-swap", Str(swap))
}

///|
/// Htmx属性: hx-target
pub fn Attrs::hx_target(self : Attrs, selector : String) -> Attrs {
  self.add("hx-target", Str(selector))
}

///|
/// Htmx属性: hx-trigger
pub fn Attrs::hx_trigger(self : Attrs, event : String) -> Attrs {
  self.add("hx-trigger", Str(event))
}

///|
pub fn Attrs::value(self : Attrs, v : String) -> Attrs {
  self.add("value", Str(v))
}

///|
pub fn Attrs::placeholder(self : Attrs, p : String) -> Attrs {
  self.add("placeholder", Str(p))
}

///|
pub fn Attrs::data(self : Attrs, key : String, value : String) -> Attrs {
  self.add("data-" + key, Str(value))
}

///|
/// Htmx属性: hx-swap (型安全版 - Swap enumを受け取る)
pub fn Attrs::hx_swap_safe(self : Attrs, swap : Swap) -> Attrs {
  self.hx_swap(swap.to_string())
}

///|
/// Htmx属性: hx-trigger (型安全版 - Trigger enumを受け取る)
pub fn Attrs::hx_trigger_safe(self : Attrs, trigger : Trigger) -> Attrs {
  self.hx_trigger(trigger.to_string())
}

///|
/// HDA Swap戦略
pub enum Swap {
  InnerHTML
  OuterHTML
  BeforeBegin
  AfterBegin
  BeforeEnd
  AfterEnd
  Delete
  None
} derive(Show, Eq)

///|
pub fn Swap::to_string(self : Swap) -> String {
  match self {
    InnerHTML => "innerHTML"
    OuterHTML => "outerHTML"
    BeforeBegin => "beforebegin"
    AfterBegin => "afterbegin"
    BeforeEnd => "beforeend"
    AfterEnd => "afterend"
    Delete => "delete"
    None => "none"
  }
}

///|
pub fn Swap::from_string(s : String) -> Swap {
  match s {
    "innerHTML" => InnerHTML
    "outerHTML" => OuterHTML
    "beforebegin" => BeforeBegin
    "afterbegin" => AfterBegin
    "beforeend" => BeforeEnd
    "afterend" => AfterEnd
    "delete" => Delete
    "none" => None
    _ => None // 不明な値はデフォルトで None
  }
}

///|
/// トリガー修飾子
pub enum TriggerMod {
  Once
  Changed
  Delay(Int)
  Throttle(Int)
  From(String)
  Target(String)
  Filter(String)
  Consumed
  Queue(String)
} derive(Show, Eq)

///|
pub fn TriggerMod::to_string(self : TriggerMod) -> String {
  match self {
    Once => "once"
    Changed => "changed"
    Delay(ms) => "delay:" + ms.to_string() + "ms"
    Throttle(ms) => "throttle:" + ms.to_string() + "ms"
    From(sel) => "from:" + sel
    Target(sel) => "target:" + sel
    Filter(expr) => "filter:" + expr
    Consumed => "consumed"
    Queue(name) => "queue:" + name
  }
}

///|
/// トリガー
pub enum Trigger {
  Event(String)
  EventWithMods(String, Array[TriggerMod])
  Multiple(Array[Trigger])
} derive(Show)

///|
pub fn Trigger::to_string(self : Trigger) -> String {
  match self {
    Event(name) => name
    EventWithMods(name, mods) => {
      let mod_str = mods.map(TriggerMod::to_string).join(" ")
      if mod_str.length() > 0 {
        name + " " + mod_str
      } else {
        name
      }
    }
    Multiple(triggers) => triggers.map(Trigger::to_string).join(", ")
  }
}

///|
/// HTML要素
pub enum Html {
  Element(String, Attrs, Array[Html], Bool)
  Text(String)
  Fragment(Array[Html])
  Raw(String)
  When(Bool, Html, Html?)
} derive(Show)

///|
/// HTMLエスケープ（文字単位処理・UTF-8対応）
fn escape_html(s : String) -> String {
  let mut result : Array[String] = []
  let len = s.length()
  for i = 0; i < len; i = i + 1 {
    let uint = s[i]
    let code = uint.to_int()
    match code {
      38 => result = result + ["&amp;"] // &
      60 => result = result + ["&lt;"] // <
      62 => result = result + ["&gt;"] // >
      34 => result = result + ["&quot;"] // "
      39 => result = result + ["&#39;"] // '
      _ =>
        // UInt16(Char)をStringに変換
        match uint.to_char() {
          Some(ch) => {
            let char_str = String::from_array([ch])
            result = result + [char_str]
          }
          None => result = result + [""]
        }
    }
  }
  result.join("")
}

///|
/// 属性値エスケープ（文字単位処理・UTF-8対応）
fn escape_attr(s : String) -> String {
  let mut result : Array[String] = []
  let len = s.length()
  for i = 0; i < len; i = i + 1 {
    let uint = s[i]
    let code = uint.to_int()
    match code {
      38 => result = result + ["&amp;"] // &
      34 => result = result + ["&quot;"] // "
      60 => result = result + ["&lt;"] // <
      62 => result = result + ["&gt;"] // >
      _ =>
        // UInt16(Char)をStringに変換
        match uint.to_char() {
          Some(ch) => {
            let char_str = String::from_array([ch])
            result = result + [char_str]
          }
          None => result = result + [""]
        }
    }
  }
  result.join("")
}

///|
/// 属性を文字列に変換
fn attrs_to_string(attrs : Attrs) -> String {
  let mut result = ""
  let attr_array = attrs.attrs
  for i = 0; i < attr_array.length(); i = i + 1 {
    let (key, value) = attr_array[i]
    let value_str = match value {
      None => " " + key
      Str(s) => " " + key + "=\"" + escape_attr(s) + "\""
      Bool(true) => " " + key + "=\"true\""
      Bool(false) => " " + key + "=\"false\""
      Int(i) => " " + key + "=\"" + i.to_string() + "\""
    }
    result = result + value_str
  }
  result
}

///|
/// 子要素を文字列に変換
fn children_to_string(children : Array[Html]) -> String {
  let mut result = ""
  for i = 0; i < children.length(); i = i + 1 {
    result = result + Html::render(children[i])
  }
  result
}

///|
/// HTMLを文字列にレンダリング
pub fn Html::render(self : Html) -> String {
  match self {
    Element(tag, attrs, children, is_void) => {
      let attr_str = attrs_to_string(attrs)
      let children_str = children_to_string(children)
      if is_void {
        "<" + tag + attr_str + ">"
      } else {
        "<" + tag + attr_str + ">" + children_str + "</" + tag + ">"
      }
    }
    Text(s) => escape_html(s)
    Fragment(children) => children_to_string(children)
    Raw(s) => s
    When(condition, then, otherwise) =>
      if condition {
        then.render()
      } else {
        match otherwise {
          Some(o) => o.render()
          None => ""
        }
      }
  }
}

///|
/// テキストノード
pub fn text(content : String) -> Html {
  Text(content)
}

///|
/// フラグメント
pub fn fragment(children : Array[Html]) -> Html {
  Fragment(children)
}

///|
/// Raw HTML（エスケープなし）
pub fn raw(content : String) -> Html {
  Raw(content)
}

///|
/// 条件付きレンダリング（elseあり）
pub fn when_else(condition : Bool, then : Html, otherwise : Html) -> Html {
  When(condition, then, Some(otherwise))
}

///|
/// 条件付きレンダリング（elseなし）
pub fn when(condition : Bool, then : Html) -> Html {
  When(condition, then, None)
}

///|
/// 要素ビルダー
pub struct ElementBuilder {
  tag : String
  attrs : Attrs
  is_void : Bool
}

///|
fn ElementBuilder::new(tag : String) -> ElementBuilder {
  { tag, attrs: Attrs::new(), is_void: false }
}

///|
fn ElementBuilder::new_void(tag : String) -> ElementBuilder {
  { tag, attrs: Attrs::new(), is_void: true }
}

///|
pub fn ElementBuilder::attrs(
  self : ElementBuilder,
  attrs : Attrs,
) -> ElementBuilder {
  { ..self, attrs, }
}

///|
pub fn ElementBuilder::attr(
  self : ElementBuilder,
  key : String,
  value : AttrValue,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.add(key, value) }
}

///|
/// 文字列属性を追加（簡易版）
pub fn ElementBuilder::attr_str(
  self : ElementBuilder,
  key : String,
  value : String,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.add(key, attr_value_str(value)) }
}

///|
pub fn ElementBuilder::class(
  self : ElementBuilder,
  name : String,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.class(name) }
}

///|
pub fn ElementBuilder::id(self : ElementBuilder, id : String) -> ElementBuilder {
  { ..self, attrs: self.attrs.id(id) }
}

///|
pub fn ElementBuilder::href(
  self : ElementBuilder,
  url : String,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.href(url) }
}

///|
pub fn ElementBuilder::attr_type(
  self : ElementBuilder,
  t : String,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.attr_type(t) }
}

///|
pub fn ElementBuilder::name(
  self : ElementBuilder,
  n : String,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.name(n) }
}

///|
/// Htmx属性: hx-get
pub fn ElementBuilder::hx_get(
  self : ElementBuilder,
  url : String,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.hx_get(url) }
}

///|
/// Htmx属性: hx-post
pub fn ElementBuilder::hx_post(
  self : ElementBuilder,
  url : String,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.hx_post(url) }
}

///|
/// Htmx属性: hx-put
pub fn ElementBuilder::hx_put(
  self : ElementBuilder,
  url : String,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.hx_put(url) }
}

///|
/// Htmx属性: hx-delete
pub fn ElementBuilder::hx_delete(
  self : ElementBuilder,
  url : String,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.hx_delete(url) }
}

///|
/// Htmx属性: hx-patch
pub fn ElementBuilder::hx_patch(
  self : ElementBuilder,
  url : String,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.hx_patch(url) }
}

///|
/// Htmx属性: hx-swap
pub fn ElementBuilder::hx_swap(
  self : ElementBuilder,
  swap : String,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.hx_swap(swap) }
}

///|
/// Htmx属性: hx-target
pub fn ElementBuilder::hx_target(
  self : ElementBuilder,
  selector : String,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.hx_target(selector) }
}

///|
/// Htmx属性: hx-trigger
pub fn ElementBuilder::hx_trigger(
  self : ElementBuilder,
  event : String,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.hx_trigger(event) }
}

///|
pub fn ElementBuilder::value(
  self : ElementBuilder,
  v : String,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.value(v) }
}

///|
pub fn ElementBuilder::placeholder(
  self : ElementBuilder,
  p : String,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.placeholder(p) }
}

///|
pub fn ElementBuilder::data(
  self : ElementBuilder,
  key : String,
  value : String,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.data(key, value) }
}

///|
/// Htmx属性: hx-swap (型安全版 - Swap enumを受け取る)
pub fn ElementBuilder::hx_swap_safe(
  self : ElementBuilder,
  swap : Swap,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.hx_swap_safe(swap) }
}

///|
/// Htmx属性: hx-trigger (型安全版 - Trigger enumを受け取る)
pub fn ElementBuilder::hx_trigger_safe(
  self : ElementBuilder,
  trigger : Trigger,
) -> ElementBuilder {
  { ..self, attrs: self.attrs.hx_trigger_safe(trigger) }
}

///|
pub fn ElementBuilder::children(
  self : ElementBuilder,
  children : Array[Html],
) -> Html {
  Element(self.tag, self.attrs, children, self.is_void)
}

///|
pub fn ElementBuilder::child(self : ElementBuilder, child : Html) -> Html {
  Element(self.tag, self.attrs, [child], self.is_void)
}

///|
pub fn ElementBuilder::text(self : ElementBuilder, t : String) -> Html {
  Element(self.tag, self.attrs, [Text(t)], self.is_void)
}

///|
pub fn ElementBuilder::empty(self : ElementBuilder) -> Html {
  Element(self.tag, self.attrs, [], self.is_void)
}

///|
/// HTML要素生成関数
pub fn html() -> ElementBuilder {
  ElementBuilder::new("html")
}

///|
pub fn head() -> ElementBuilder {
  ElementBuilder::new("head")
}

///|
pub fn body() -> ElementBuilder {
  ElementBuilder::new("body")
}

///|
pub fn div() -> ElementBuilder {
  ElementBuilder::new("div")
}

///|
pub fn span() -> ElementBuilder {
  ElementBuilder::new("span")
}

///|
pub fn p() -> ElementBuilder {
  ElementBuilder::new("p")
}

///|
pub fn h1() -> ElementBuilder {
  ElementBuilder::new("h1")
}

///|
pub fn h2() -> ElementBuilder {
  ElementBuilder::new("h2")
}

///|
pub fn h3() -> ElementBuilder {
  ElementBuilder::new("h3")
}

///|
pub fn h4() -> ElementBuilder {
  ElementBuilder::new("h4")
}

///|
pub fn h5() -> ElementBuilder {
  ElementBuilder::new("h5")
}

///|
pub fn h6() -> ElementBuilder {
  ElementBuilder::new("h6")
}

///|
pub fn a() -> ElementBuilder {
  ElementBuilder::new("a")
}

///|
pub fn button() -> ElementBuilder {
  ElementBuilder::new("button")
}

///|
pub fn form() -> ElementBuilder {
  ElementBuilder::new("form")
}

///|
pub fn input() -> ElementBuilder {
  ElementBuilder::new_void("input")
}

///|
pub fn textarea() -> ElementBuilder {
  ElementBuilder::new("textarea")
}

///|
pub fn label() -> ElementBuilder {
  ElementBuilder::new("label")
}

///|
pub fn ul() -> ElementBuilder {
  ElementBuilder::new("ul")
}

///|
pub fn ol() -> ElementBuilder {
  ElementBuilder::new("ol")
}

///|
pub fn li() -> ElementBuilder {
  ElementBuilder::new("li")
}

///|
pub fn table() -> ElementBuilder {
  ElementBuilder::new("table")
}

///|
pub fn thead() -> ElementBuilder {
  ElementBuilder::new("thead")
}

///|
pub fn tbody() -> ElementBuilder {
  ElementBuilder::new("tbody")
}

///|
pub fn tr() -> ElementBuilder {
  ElementBuilder::new("tr")
}

///|
pub fn th() -> ElementBuilder {
  ElementBuilder::new("th")
}

///|
pub fn td() -> ElementBuilder {
  ElementBuilder::new("td")
}

///|
pub fn img() -> ElementBuilder {
  ElementBuilder::new_void("img")
}

///|
pub fn br() -> ElementBuilder {
  ElementBuilder::new_void("br")
}

///|
pub fn hr() -> ElementBuilder {
  ElementBuilder::new_void("hr")
}

///|
pub fn meta() -> ElementBuilder {
  ElementBuilder::new_void("meta")
}

///|
pub fn link_tag() -> ElementBuilder {
  ElementBuilder::new_void("link")
}

///|
pub fn script() -> ElementBuilder {
  ElementBuilder::new("script")
}

///|
pub fn style() -> ElementBuilder {
  ElementBuilder::new("style")
}

///|
pub fn title() -> ElementBuilder {
  ElementBuilder::new("title")
}

///|
pub fn nav() -> ElementBuilder {
  ElementBuilder::new("nav")
}

///|
pub fn header() -> ElementBuilder {
  ElementBuilder::new("header")
}

///|
pub fn footer() -> ElementBuilder {
  ElementBuilder::new("footer")
}

///|
pub fn main_el() -> ElementBuilder {
  ElementBuilder::new("main")
}

///|
pub fn section() -> ElementBuilder {
  ElementBuilder::new("section")
}

///|
pub fn article() -> ElementBuilder {
  ElementBuilder::new("article")
}

///|
pub fn aside() -> ElementBuilder {
  ElementBuilder::new("aside")
}

///|
pub fn code() -> ElementBuilder {
  ElementBuilder::new("code")
}

///|
pub fn pre() -> ElementBuilder {
  ElementBuilder::new("pre")
}

///|
pub fn blockquote() -> ElementBuilder {
  ElementBuilder::new("blockquote")
}

///|
pub fn strong() -> ElementBuilder {
  ElementBuilder::new("strong")
}

///|
pub fn em() -> ElementBuilder {
  ElementBuilder::new("em")
}

///|
pub fn del() -> ElementBuilder {
  ElementBuilder::new("del")
}

///|
pub fn small() -> ElementBuilder {
  ElementBuilder::new("small")
}

///|
/// ヘルパー関数
pub fn doctype() -> Html {
  Raw("<!DOCTYPE html>")
}

///|
pub fn charset(charset : String) -> Html {
  Element("meta", Attrs::new().add("charset", Str(charset)), [], true)
}

///|
pub fn viewport(content : String) -> Html {
  Element(
    "meta",
    Attrs::new().add("name", Str("viewport")).add("content", Str(content)),
    [],
    true,
  )
}

///|
pub fn stylesheet(href : String) -> Html {
  Element(
    "link",
    Attrs::new().add("rel", Str("stylesheet")).add("href", Str(href)),
    [],
    true,
  )
}
