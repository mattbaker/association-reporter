class Article < ActiveRecord::Base
  extend AssociationReporter::Reporter
  belongs_to :author, class_name: :User
  has_one :author_profile, through: :author, source: :profile
  has_many :comments
  has_many :article_tags
  has_many :tags, through: :article_tags
end
