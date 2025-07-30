let classify n = 
  if n < 1 then 
    Error "Classification is only possible for positive integers."
