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
  
end