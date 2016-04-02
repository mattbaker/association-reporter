class Comment < ActiveRecord::Base
  extend AssociationReporter::Reporter
  belongs_to :article
  belongs_to :user
end
