///|
pub(all) struct User {
  id : String
  name : String
  avatar_url : String?
} derive(Show, Eq)

///|
pub(all) enum MessageStatus {
  Sending
  Sent
  Delivered
  Read
  Failed
} derive(Show, Eq)

///|
pub(all) enum MessageContent {
  Text(String)
  Markdown(String)
  Image(url~ : String, caption~ : String?)
  System(String)
} derive(Show, Eq)

///|
pub(all) struct MessageSnapshot {
  id : String
  sender : User
  content : MessageContent
  timestamp_ms : Int64
  status : MessageStatus
} derive(Show, Eq)
