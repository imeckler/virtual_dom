module Attribute = struct
  type t = string * string
end

module Css = struct
  type t = string * string
end

let coerce (x : Js.Unsafe.any) : 'a = Obj.magic x

module Event = struct
  module Listener = struct
    type t =
      { event_name : Js.js_string Js.t
      ; handler    : (Js.Unsafe.any -> unit) Js.callback
      }
  end

  module Unsafe = struct
    let create event_name handler =
      let js_handler = Js.wrap_callback (fun x -> handler (coerce x)) in
      {Listener.event_name = Js.string event_name; handler = js_handler}
  end

  module Mouse = struct

    let click = Unsafe.create "onmouseclick"
    let up    = Unsafe.create "onmouseup"
    let down  = Unsafe.create "onmousedown"
    let move  = Unsafe.create "onmousemove"
    let enter = Unsafe.create "onmouseenter"
    let leave = Unsafe.create "onmouseleave"
    let over  = Unsafe.create "onmouseover"
    let out   = Unsafe.create "onmouseout"
  end
end

type t

let text s : t = Js.Unsafe.(
  new_obj (Js.Unsafe.variable "VText") [|inject (Js.string s)|])

let data_set_hook x = Js.Unsafe.(fun_call (variable "DataSetHook") [|inject x|])

let node ?(events=[||]) name attributes properties contents : t =
  let open Js.Unsafe in
  let attrs = obj (Array.map (fun (k, v) -> k, inject (Js.string v)) attributes) in
  let props = obj (Array.map (fun (k, v) -> k, inject (Js.string v)) properties) in
  attrs##style <- props;
  Array.iter (fun {Event.Listener.event_name; handler} ->
    set attrs event_name (data_set_hook handler)) events;
  new_obj (Js.Unsafe.variable "VNode")
    [|inject (Js.string name); inject attrs; inject (Js.array contents)|]

module Patch = struct
  type t
end

let to_dom_element t =
  Js.Unsafe.(fun_call (variable "VcreateElement") [|inject t|])

let diff t1 t2 =
  Js.Unsafe.(fun_call (variable "Vdiff") [|inject t1; inject t2|])

let patch elt p =
    ignore (Js.Unsafe.(fun_call (variable "Vpatch") [|inject elt; inject p|]))

