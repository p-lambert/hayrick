## Hayrick
*Query Objects without a hitch.*

---
[![Build Status](https://travis-ci.org/p-lambert/hayrick.svg?branch=master)](https://travis-ci.org/p-lambert/hayrick)

`Hayrick` lets you easily create
[Query Objects](http://martinfowler.com/eaaCatalog/queryObject.html), decoupling
your data models from querying concerns. It is extremely lightweight, having
less than `100` lines of code and no external dependencies. `Hayrick` currently
supports
[Active Record](https://github.com/rails/rails/tree/master/activerecord) and
[Sequel](https://github.com/jeremyevans/sequel).

### Usage

First, add this line to your application's `Gemfile`:

```ruby
gem 'hayrick'
```

Then you have just to include the `Hayrick` module and implement a `#base_scope` method:

```ruby
class AlbumCollection
  include Hayrick

  def base_scope
    Album.all # or Album.unscoped depending on your Rails version
  end
end
```

And that's it! You're now able to perform queries by calling
`AlbumCollection#search`.

```ruby
AlbumCollection.new.search(artist: 'Morphine')
=> #<ActiveRecord::Relation [#<Album id: 1, name: "Good", artist: "Morphine", release_date: "1992-09-08">, #<Album id: 2, name: "Cure for Pain", artist: "Morphine", release_date: "1993-09-14">...]>
```

That seems fine, but we usually want to carry out queries using parameters other
than our model fields, right? `Hayrick` provides a simple DSL for adding such
filters:

```ruby
class AlbumCollection
  include Hayrick

  filter :year do |search_relation, year|
    search_relation.where('extract(year from released_at) = ?', year)
  end

  def base_scope
    Album.all
  end
end
```

Notice the `.filter` method receives two parameters:

* a filter name (in this case, `:year`)
* a filter definition which can be either a `Proc` or a block. This callable
  object must receive two arguments: the first is the search relation and the
  second is the argument for the filter itself. Make sure to always return the
  search relation to prevent the filter chain from breaking.

```ruby
AlbumCollection.new.search(artist: 'Morphine', year: 1993)
=> #<ActiveRecord::Relation [#<Album id: 2, name: "Cure for Pain", artist: "Morphine", release_date: "1993-09-14">]>
```
