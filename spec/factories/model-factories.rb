require 'active_record'

module ModelFactories
  extend self

  class CreateTestTables < ActiveRecord::Migration
    def self.up
      create_table :articles do |t|
        t.integer :author_id
      end

      create_table :users

      create_table :comments do |t|
        t.integer :article_id
        t.integer :user_id
      end


      create_table :taggings do |t|
        t.integer :article_id
        t.integer :tag_id
      end

      create_table :tags
    end

    def self.down
      drop_table :articles
      drop_table :users
      drop_table :comments
      drop_table :taggings
      drop_table :tags
    end
  end

  def clear_and_define(const)
    Object.send(:remove_const, const) if Object.const_defined?(const)
    klass = yield
    Object.const_set(const, klass)
  end

  def define_all_models
    define_Article_model
    define_Comment_model
    define_Tagging_model
    define_Tag_model
  end

  def define_Article_model
    clear_and_define(:Article) do
      Class.new(ActiveRecord::Base) do
        extend AssociationReporter::Reporter
        has_many :taggings
        has_many :hashtags, through: :taggings
        has_many :comments
        belongs_to :author, class_name: "User"
      end
    end
  end

  def define_User_model
    clear_and_define(:User) do
      Class.new(ActiveRecord::Base) do
        extend AssociationReporter::Reporter
        has_many :comments
      end
    end
  end

  def define_Comment_model
    clear_and_define(:Comment) do
      Class.new(ActiveRecord::Base) do
        extend AssociationReporter::Reporter
        belongs_to :article
        belongs_to :user
      end
    end
  end

  def define_Tagging_model
    clear_and_define(:Tagging) do
      Class.new(ActiveRecord::Base) do
        extend AssociationReporter::Reporter
        belongs_to :article
        belongs_to :tag
      end
    end
  end

  def define_Tag_model
    clear_and_define(:Tag) do
      Class.new(ActiveRecord::Base) do
        extend AssociationReporter::Reporter
        has_many :taggings
        has_many :tagged_articles, through: :taggings, source: :article
      end
    end
  end

  def define_Article_with_bad_fkey_good_model
    clear_and_define(:Article) do
      Class.new(ActiveRecord::Base) do
        extend AssociationReporter::Reporter
        belongs_to :writer, class_name: "User"
      end
    end
  end

  def define_Article_with_good_fkey_bad_model
    clear_and_define(:Article) do
      Class.new(ActiveRecord::Base) do
        extend AssociationReporter::Reporter
        belongs_to :writer, foreign_key: :author_id
      end
    end
  end

  def define_Article_with_bad_has_many_model
    clear_and_define(:Article) do
      Class.new(ActiveRecord::Base) do
        extend AssociationReporter::Reporter
        has_many :things_people_said
      end
    end
  end

  def define_Article_with_valid_belongs_to
    clear_and_define(:Article) do
      Class.new(ActiveRecord::Base) do
        extend AssociationReporter::Reporter
        belongs_to :writer, foreign_key: :author_id, class_name: "User"
      end
    end
  end

  def define_Article_with_has_many
    clear_and_define(:Article) do
      Class.new(ActiveRecord::Base) do
        extend AssociationReporter::Reporter
        has_many :comments
      end
    end
  end

  def define_Article_with_invalid_through
    clear_and_define(:Article) do
      Class.new(ActiveRecord::Base) do
        extend AssociationReporter::Reporter
        has_many :taggings
        has_many :hashtags, through: :foo
      end
    end
  end

  def define_Article_with_invalid_source
    clear_and_define(:Article) do
      Class.new(ActiveRecord::Base) do
        extend AssociationReporter::Reporter
        has_many :taggings
        has_many :hashtags, through: :taggings
      end
    end
  end

  def define_Article_with_valid_through_and_source
    clear_and_define(:Article) do
      Class.new(ActiveRecord::Base) do
        extend AssociationReporter::Reporter
        has_many :taggings
        has_many :hashtags, through: :taggings, source: :tag
      end
    end
  end

end
