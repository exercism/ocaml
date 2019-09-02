open Yojson.Basic

type language_config = {
  template_file_name: string;
  default_base_folder: string;
  test_start_marker: string;
  test_end_marker: string;
  edit_parameters: slug: string -> (string * json) list -> (string * string) list option;
}
