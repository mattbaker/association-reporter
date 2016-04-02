class User < ActiveRecord::Base
  extend AssociationReporter::Reporter
  has_many :articles
  has_many :comments
  has_one :profile
end
