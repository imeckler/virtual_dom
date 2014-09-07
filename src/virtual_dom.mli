module Attribute : sig
  type t = string * string
end

module Css : sig
  type t = string * string
end

module Event : sig
  module Listener : sig
    type t
  end

  module Mouse : sig
    val click : (Dom_html.mouseEvent Js.t -> unit) -> Listener.t
    val down  : (Dom_html.mouseEvent Js.t -> unit) -> Listener.t
    val up    : (Dom_html.mouseEvent Js.t -> unit) -> Listener.t
    val move  : (Dom_html.mouseEvent Js.t -> unit) -> Listener.t
    val enter : (Dom_html.mouseEvent Js.t -> unit) -> Listener.t
    val leave : (Dom_html.mouseEvent Js.t -> unit) -> Listener.t
    val over  : (Dom_html.mouseEvent Js.t -> unit) -> Listener.t
    val out   : (Dom_html.mouseEvent Js.t -> unit) -> Listener.t
  end

  module Unsafe : sig
    val create : string -> ('a -> unit) -> Listener.t
  end
end

module Patch : sig
  type t
end

type t

val text : string -> t

val node
  : ?events:(Event.Listener.t array)
  -> string -> Attribute.t array -> Css.t array -> t array
  -> t

val to_dom_element : t -> Dom_html.element Js.t

val diff : t -> t -> Patch.t

val patch : Dom_html.element Js.t -> Patch.t -> unit

