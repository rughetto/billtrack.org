class NameLookup < ApiData
  belongs_to :parent, :polymorphic => true
end  