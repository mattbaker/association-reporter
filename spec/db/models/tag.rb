class Tag < ActiveRecord::Base
  extend AssociationReporter::Reporter
  has_many :article_tags
  has_many :articles, through: :article_tags
end
