# Generalized Map and Reduce Lab

## Learning Goals

- Identify duplication that can be avoided with blocks
- State two ways of constructing blocks
- Execute a block from within a method
- State the purpose of the `yield` keyword
- Pass data between methods and blocks

## Introduction

As you saw in the previous lesson, there's a lot of repeated code between our
various `map`-based and `reduce`-based methods. This should trigger an
"allergic" reaction in you. You learned to "DRY out" your code. In this lesson,
we'll learn to DRY out our home-grown enumerable methods using a powerful
language feature of Ruby: the _block_.

## Identify Duplication That Can Be Avoided With Blocks

Let's look at this solution code from the previous lesson:

```ruby
def map_to_negativize(source_array)
  new = []
  i = 0
  while i < source_array.length do
    new.push( source_array[i] * -1 ) # <== Unique work
    i += 1
  end
  return new
end

def map_to_no_change(source_array)
  new = []
  i = 0
  while i < source_array.length do
    new.push( source_array[i] ) # <== Unique work
    i += 1
  end
  return new
end

def map_to_double(source_array)
  new = []
  i = 0
  while i < source_array.length do
    new.push( source_array[i] * 2 ) # <== Unique work
    i += 1
  end
  return new
end

def map_to_square(source_array)
  new = []
  i = 0
  while i < source_array.length do
    new.push( source_array[i] * source_array[i] ) # <== Unique work
    i += 1
  end
  return new
end
```

As you can see, the only thing that varies between these methods is the line
which we've labeled with `Unique work`. We want to get rid of that duplicated
"noised" around those lines.

When you learned to create methods, you learned that the way to _abstract_ the
method is to pass in the stuff that varies as an _argument_ in the _call_ of
the method. We'd _like_ to do the same thing here. But in Ruby, we know we can
pass `String`s, `Array`s, `Hash`es, and `Float`s. With _blocks_, Ruby lets us
pass in "work to do later," although it looks a little bit different than
passing an argument to a method.

## State Two Ways of Constructing Blocks

We write blocks in Ruby using two syntaxes:

1. Curly brace `{}`
2. `do...end`

We generally use curly brace when the work inside is only one expression. Since
expressions in Ruby _always_ return a value, the return value of the block will
the value of that _single_ expression.

We use `do...end` when the work takes multiple lines. Just like methods,
whatever is on the last line of a `do...end` block will be the return value of
the block.

### Code Writing Tip

It's wise to start out with a `do...end` blocks. If you need to add debugging
data like `p "this should be #{i}"`, need to assign some local variables, or
maybe use a less-fancy bit of code to do the work, you're already in the
"multi-line-friendly" style.

Once you're sure you've gotten your implementation correct, you can use the
shorter, and more elegant `{}` format.

If you refuse this advice, if you need to include multiple expressions inside
of a `{}`, you should separate the expressions with `;`.

On the other hand, it's hard to see how an expression like `-1 * x` could go
wrong, so _maybe_ in some cases you can start with `{}`. Using `do...end` is
our recommendation while you're starting out.

## Pass a Block to a Method

We pass a block to a method by including either a `{}` or a `do...end` block
after our call to the method.

```ruby
method_using_block { puts "hi" }

# Is the same as...
method_using_block do
  puts "hi"
end
```

## Execute a Code Passed as a Block Inside a Method

When we pass arguments into a method, we have _parameters_ that allow us to
refer to them:

```ruby
def make_sandwich(element1, element2)
end

make_sandwich("Peanut Butter", "Yakisoba")
```

Inside of the `make_sandwich` method, we could get the `String`s passed into
`make_sandwich` by working with the local variables (or "_parameters_")
`element1` or `element2`.

When blocks are passed in, they **_are not stored_** in a _parameter_ name.
They are, instead, _implicitly_ passed. We "run" the code in the block by using
the Ruby keyword `yield`.

> **ADVANCED**: You actually _can_ capture blocks. We hope you'll stick with
> Ruby long enough to learn this super-cool concept.

## State the Purpose of the `yield` Keyword

The `yield` keyword **executes** the block passed into the method. When it is
executed, it can be passed arguments. You could pass it local variables that
were defined _within_ the method that is, in turn, executing the block.

Let's add a block to our call to `make_sandwich` and add a call to `yield`
inside of `make_sandwich`.

```ruby
def make_sandwich(element1, element2)
  base = "A #{element1} and #{element2}"
  puts base
  yield
  base
end

make_sandwich("chicken", "a sense of malaise") do |innards|
  puts "making some tasty stuff..."
end #=> "A chicken and a sense of malaise"
```

And outputs:

```shell
A chicken and a sense of malaise
making some tasty stuff...
```

Make sure you understand what's going on here or work with this simple code in
IRB.

## Pass Data Between Methods and Blocks

In the same way that you provide _parameters_ in methods in order to "catch"
things passed in, we define \_block-parameters\_ by placing their name(s) between
a pair of "pipe" characters (`|`), separated by commas (`,`). Then, within the
block, we can use the passed-in data in whatever way we deem fit.

```ruby
def make_sandwich(element1, element2)
  base = "A #{element1} and #{element2}"
  yield(base)
end

make_sandwich("gator", "gumbo") do |innards|
  "#{innards} on rye"
end #=> "A gator and gumbo on rye"
```

Since this is a simple transformation, we'll convert to a `{}`-based block.
We'll also rewrite the internals of `make_sandwich` to be a bit cleaner. Make
sure you can step through this code and understand what's going on with return
values, implicit return. This is would be typical of a professional codebase.

We'll also add the word "sandwich" to our default implementation.

```ruby
def make_sandwich(element1, element2)
  yield("A #{element1} and #{element2} sandwich")
end

make_sandwich("grits", "abject terror") { |innards| "#{innards} on rye" }
#=> "A grits and abject terror sandwich on rye"
```

But now we are prepared to see the power of blocks.

## Demonstrate How Blocks Allow for Flexible Method Calls

Because we've "exposed" how to customize the sandwich in the block, it's
possible for us to satisfy many types of calls to this method flexibly. We can
provide the final bit of "work" (look back to the first lesson, a little bit of
"work" is common to all Enumerables!).

```ruby
def make_sandwich(element1, element2)
  yield("A #{element1} and #{element2} sandwich")
end

# Wheat, sure!
make_sandwich("Creamy peanut butter", "glittering sense of accomplishment") { |b| "#{b} on wheat" }

# Bueno!
make_sandwich("Creamy peanut butter", "glittering sense of accomplishment") { |b| "#{b} on tortilla" }

# Lewis Carroll's Kitchen
make_sandwich("Creamy peanut butter", "glittering sense of accomplishment") { |b| "#{b.reverse} on #{"bread".reverse}" }

# Try some more yourself!
```

This produces:

```shell
"A Creamy peanut butter and glittering sense of accomplishment sandwich on wheat"
"A Creamy peanut butter and glittering sense of accomplishment sandwich on tortilla"
"hciwdnas tnemhsilpmocca fo esnes gnirettilg dna rettub tunaep ymaerC A on daerb"
```

> **KEEP GOING**: Did you notice that some of the template sentence doesn't
> quite work? Consider updating our code with conditionals. Add more logic in
> the method or in the block. Play with how you can move logic from the block
> to the method and back. Make this piece your own!

By now it should be clear that a block allows us to separate small bits of
_varying_ work from methods that, for the most part, remain the same. This
should be the key to making a generalized, _abstract_ `map` and `reduce`.

## Lab

In this lab, you should write a generalized `map` and `reduce` method. Both of
these methods will take a block and require that you pass information between
the method and the block. Write your code in the `lib/my_code.rb` file.

### `map`

Your implementation should expect a source array and a block. All the tests
will pass an `Array` and a block.

Remember, `map` returns a new `Array`.

### `reduce`

Your implementation should expect a source array and _optionally_ (recall
optional parameters in methods!) a starting value. All the tests will pass an
`Array` and sometimes, a starting point.

Remember, `reduce` returns a value.

You might be interested to compare the code in the previous lesson to the code
in this lesson: they're the exact same expectations but since we know how to
use blocks we need only call `map` versus `map_to_negativize`,
`map_to_no_change`, etc...

```ruby
  expect(map_to_square([1, 2, 3, -9])).to eq([1, 4, 9, 81])
```

became _generalized_ as:

```ruby
  expect(map([1, 2, 3, -9]){|n| n * n}).to eq([1, 4, 9, 81])
```

## Conclusion

Congratulations you've linked your conceptual grasp of Enumeration with the
understanding of the code needed in Enumerables. Now would be a great time to
go back to Ruby's [Enumerables documentation][enumdoc] and try to follow along
with the code examples to see how you can use Enumerable methods to make your
coding easier.

[enumdoc]: https://ruby-doc.org/core-2.6.3/Enumerable.html
