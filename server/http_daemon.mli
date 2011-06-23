type conn_id
val string_of_conn_id : conn_id -> string

type daemon_spec = {
  address : string;
  auth : Http_types.auth_info;
  callback : conn_id -> Http_request.request -> string Lwt_stream.t Lwt.t;
  conn_closed : conn_id -> unit;
  port : int;
  root_dir : string option;
  exn_handler : exn -> unit Lwt.t;
  timeout : int option;
  auto_close : bool;
}
val respond :
  ?body:string ->
  ?headers:(string * string) list ->
  ?version:Http_types.version ->
  ?status:Http_types.status_code -> unit -> string Lwt_stream.t Lwt.t
val respond_control :
  string ->
  ?is_valid_status:(int -> bool) ->
  ?headers:(string * string) list ->
  ?body:string ->
  ?version:Http_types.version ->
  Http_types.status_code -> string Lwt_stream.t Lwt.t
val respond_redirect :
  location:string ->
  ?body:string ->
  ?version:Http_types.version ->
  ?status:Http_types.status_code -> unit -> string Lwt_stream.t Lwt.t
val respond_error :
  ?body:string ->
  ?version:Http_types.version ->
  ?status:Http_types.status_code -> unit -> string Lwt_stream.t Lwt.t
val respond_not_found :
  url:'a ->
  ?version:Http_types.version -> unit -> string Lwt_stream.t Lwt.t
val respond_forbidden :
  url:'a ->
  ?version:Http_types.version -> unit -> string Lwt_stream.t Lwt.t
val respond_unauthorized :
  ?version:'a -> ?realm:string -> unit -> string Lwt_stream.t Lwt.t
val respond_file :
  fname:Lwt_io.file_name ->
  ?droot:string ->
  ?version:Http_types.version -> ?mime_type: string -> unit -> string Lwt_stream.t Lwt.t
val respond_with :
  Http_response.response -> string Lwt_stream.t Lwt.t
val daemon_callback :
  daemon_spec ->
  clisockaddr:Unix.sockaddr -> srvsockaddr:Unix.sockaddr -> Lwt_io.input_channel -> Lwt_io.output_channel -> unit Lwt.t
val main : daemon_spec -> 'a Lwt.t
module Trivial :
  sig
    val heading_slash_RE : Pcre.regexp
    val trivial_callback :
      conn_id -> Http_request.request -> string Lwt_stream.t Lwt.t
    val callback :
      conn_id -> Http_request.request -> string Lwt_stream.t Lwt.t
    val main : daemon_spec -> 'a Lwt.t
  end
val default_spec : daemon_spec
