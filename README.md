# carb-inject

`carb-inject` is an utility library for automated dependency injection.
Together with a generic container (even a simple `Hash`!), it will cover all
the needs for an IoC container.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'carb-inject'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carb-inject

## Glossary

<table>
  <tr>
    <th>Term</th>
    <th>Meaning</th>
  </tr>
  <tr>
    <th>Dependency</th>
    <td>
      The actual Object a dependency is (a number for example). Can be
      extracted from the container with <code>container[dependency_name]</code>
    </td>
  </tr>
  <tr>
    <th>Dependency name</th>
    <td>
      An object which allows extracting a <code>Dependency</code> from the
      container
    </td>
  </tr>
  <tr>
    <th>Dependency alias</th>
    <td>
      A symbol representing <code>Dependency name</code>, must be a valid method
      name
    </td>
  </tr>
  <tr>
    <th>Array of dependency names</th>
    <td>
      An array of <code>Dependency name</code>. When passed to the injector,
      every object must support <code>to_s</code> and the returned
      <code>String</code> must be a valid method name
    </td>
  </tr>
  <tr>
    <th>Hash of dependency aliases (or hash of aliases)</th>
    <td>
      A hash consisting of <code>Dependency alias => Dependency name</code>
    </td>
  </tr>
</table>

## Usage

First you'll need a container object.
[carb-container](https://github.com/Carburetor/carb-container) provides a
simple `RegistryContainer` which you can use.
Alternatively, you can use a simple ruby hashmap, or use `carb-inject` in an
entirely [containerless fashion](#passing-lambdas)

```ruby
container = { name: "john", age: 30 }
```

Create an injector that you'll use across your application. Usually you want to
put this in a constant

```ruby
require "carb-inject"
Inject = Carb::Inject::Injector.new(container)
```

Then, create a class you want dependencies injected automatically

```ruby
class JohnPerson
  include Inject[:name, :age]

  def initialize(**deps)
    inject_dependencies!(deps)
  end

  def hello
    "Hello I'm #{name}, #{age} years old"
  end
end
```

And finally, use the class!

```ruby
john = JohnPerson.new
john.hello # => Hello I'm john, 30 years old
```

You can overwrite dependencies on the fly

```ruby
john = JohnPerson.new(age: 20)
john.hello # => Hello I'm john, 20 years old
```

You can still require different arguments in the constructor

```ruby
class JohnPerson
  include Inject[:name, :age]

  def initialize(last_name, **dependencies)
    inject_dependencies!(dependencies)
    @last_name = last_name
  end

  def hello
    "Hello I'm #{name} #{@last_name}, #{age} years old"
  end
end

john = JohnPerson.new("snow", age: 20)
john.hello # => Hello I'm john snow, 20 years old
```

Finally, you can alias dependencies

```ruby
class JohnPerson
  include Inject[special_name: :name, a_number: :age]

  def initialize(**deps)
    inject_dependencies!(deps)
  end

  def hello
    "special_name is #{special_name}, a_number is #{a_number}"
  end
end

john = JohnPerson.new(a_number: 20)
john.hello # => special_name is john, a_number is 20
```

Be aware, you can't pass on-the-fly dependencies that were not defined on that
class. If you do, you must be the one taking care of them!

```ruby
class JohnPerson
  include Inject[:name]

  def initialize(**deps)
    inject_dependencies!(deps)
  end

  def hello
    "Hello I'm #{name}, #{age} years old"
  end
end

john = JohnPerson.new(age: 20)
john.hello # => NameError: undefined local variable or method `age'
```

### Auto invoke inject_dependencies!

Instead of manually calling `inject_dependencies!`, you can invoke the
injector with `true` as second argument. This has the downsides of including
a module which creates an initializer, with all the consequences it creates
(some issues with inheritance). It's not recommended, but if you don't use
inheritance, it does the trick.

```ruby
require "carb-inject"

container = { name: "john", age: 30 }
Inject = Carb::Inject::Injector.new(container, true)

class JohnPerson
  include Inject[:name, :age]

  def hello
    "Hello I'm #{name}, #{age} years old"
  end
end

john = JohnPerson.new
john.hello # => Hello I'm john, 30 years old
```

### Passing lambdas

There is an alternative way to use the library in a _containerless_ fashion.
You will pass a list of dependency as usual, but instead of aliasing them,
pass a lambda and it will be resolved when used

```ruby
require "carb-inject"

container = { name: "John", last_name: "Snow" }
Inject = Carb::Inject::Injector.new(container, true)

class JohnPerson
  include Inject[:last_name, foo: :name, age: -> { 30 }]

  def hello
    "Hello I'm #{foo} #{last_name}, #{age} years old"
  end
end

john = JohnPerson.new
john.hello # => Hello I'm John Snow, 30 years old
```

## Gotchas

- Alias hash **must have symbols as keys**
- Straight dependency names, when used in array and not as values for alias
  hash, must support `to_s` and the resulting `String` must be a valid method
  name (an exception is raised otherwise)

## Features

- Supports inheritance
- Can write your own injector if you don't like the syntax of the existing one
- Can alias dependencies
- Supports any container which responds to `[]` and `has_key?`
- Can write your own initializer with your own arguments

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Carburetor/carb-inject.

