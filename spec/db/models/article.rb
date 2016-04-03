class Article < ActiveRecord::Base
  extend AssociationReporter::Reporter
  belongs_to :writer, class_name: "User", foreign_key: :author_id
  has_one :author_profile, through: :author, source: :profile
  has_many :comments
  has_many :taggings
  has_many :toogs, through: :taggings, source: :toog
end
