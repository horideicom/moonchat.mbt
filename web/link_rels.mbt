///|
/// HTMX属性ヘルパー関数

///|
/// hx-postとhx-swap、hx-target属性を持つAttrsを作成
pub fn post_attrs(url : String, swap : String, target : String) -> @html.Attrs {
  let mut attrs = @html.Attrs::new()
  attrs = attrs.hx_post(url)
  attrs = attrs.hx_swap(swap)
  attrs = attrs.hx_target(target)
  attrs
}

///|
/// hx-getとhx-swap、hx-target属性を持つAttrsを作成
pub fn get_attrs(url : String, swap : String, target : String) -> @html.Attrs {
  let mut attrs = @html.Attrs::new()
  attrs = attrs.hx_get(url)
  attrs = attrs.hx_swap(swap)
  attrs = attrs.hx_target(target)
  attrs
}
