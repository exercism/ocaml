open Core.Std

(* finds a template within a file, returning the line numbers of the comment starting and ending the template, and the body of the template *)
val find_template : template_text: string -> (int * int * string) option

val generate_code : template_file: string -> canonical_data_file : string -> (string, string) Result.t

val run : templates_folder: string -> canonical_data_folder: string -> output_folder: string -> unit
