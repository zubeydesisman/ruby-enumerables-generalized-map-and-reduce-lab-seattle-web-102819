## Code Snippet

```ruby
def map(s)
  new = []
  i = 0
  while i < s.length
    new.push(yield(s[i]))
    i += 1
  end
  new
end

def reduce(s, sp=nil)
  if sp
    accum = sp
    i = 0
  else
    accum = s[0]
    i = 1
  end
  while i < s.length
    accum = yield(accum, s[i])
    i += 1
  end
  accum
end

p map([1,2,3]){|x| x * 2}
p reduce([1,2,3], 100){|memo, x|  x + memo }
p reduce([1,2,3]){|memo, x|  x + memo }
p reduce([true, true, true]){ |memo, x| memo && x } # all?
p reduce([true, false, true]){ |memo, x| memo && x } # all?
p reduce([true, false, true]){ |memo, x| memo || x } # any?
p reduce([!true, false, !true]){ |memo, x| memo || x } # any?
```

