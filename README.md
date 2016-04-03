# Association Reporter

This is a mass of untested and questionably constructed code built around ActiveRecord's reflection API. It's a learning tool that attempts to show you the guesses AR is making as you define and tweak your associations. It will also tell you if the guesses are valid, or if ActiveRecord was unable to guess correctly.

This will be cleaned up in the future, but I'd rather get it out into the world now for students to play with than hold back until I can polish it up.

It comes with no guarantees. It could be wrong, it might not work, it might burn down your computer. Feel free to submit PRs with failing tests that demonstrate issues, or with fixes.

## Requirements

AssociationReporter requires the `colorize` gem.

```
gem install colorize
```

## Usage

Require association-reporter and extend your ActiveRecord model with AssociationReporter.

```ruby

require_relative 'association_reporter' #or wherever you put it

class Article < ActiveRecord::Base
  extend AssociationReporter

  has_many :comments
end
```

This will add a class method `describe` that allows you to describe the association.

```text
irb > Article.describe(:comments)

Describing the association Article#comments

  This `has_many` association is looking for a column called 'article_id' on the table 'comments'.
  It's expecting to return a Comment object from the 'comments' table.

  This association is feeling 😀.
```

