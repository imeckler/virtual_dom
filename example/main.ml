let px n = Printf.sprintf "%dpx" n

let render count =
  Virtual_dom.node "div" [||]
    [| "textAlign"    , "center"
     ; "verticalAlign", "center"
     ; "border"       , "1px solid red"
     ; "lineHeight"   , px (100 + count)
     ; "width"        , px (100 + count)
     ; "height"       , px (100 + count)
    |]
    [| Virtual_dom.text (string_of_int count) |]

let main () =
  let count     = ref 0 in
  let tree      = ref (render !count) in
  let root_node = Virtual_dom.to_dom_element !tree in

  Dom.appendChild (Dom_html.document##body) root_node;

  let update () =
    incr count;
    let new_tree = render !count in
    Virtual_dom.patch root_node (Virtual_dom.diff !tree new_tree);
    tree := new_tree
  in
  ignore (Dom_html.window##setInterval(Js.wrap_callback update, 1000.))

let on_ready (f : unit -> unit) =
  Js.Unsafe.(fun_call (variable "$") [|inject (Js.wrap_callback f)|])

let () = on_ready main

