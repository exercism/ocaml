let egg_count number =
  let rec do_count number acc =
    if number = 0 then acc
    else do_count (number lsr 1) (acc + (number land 1))
  in
  do_count number 0
