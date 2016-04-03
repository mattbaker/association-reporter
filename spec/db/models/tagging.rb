class Tagging < ActiveRecord::Base
  extend AssociationReporter::Reporter
  belongs_to :article
  belongs_to :tag
end
