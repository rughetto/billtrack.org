class IdLookup < ApiData
  belongs_to :parent, :polymorphic => true
end