def map(array)
  new =[]
  i = 0
  while  i< array.size 
  new.push(yield(array[i])) 
  i += 1 
end
  new
end

def reduce(array, sp = nil)
  if sp  
    sum = sp
    i = 0 
  else
    sum = array[0]
end