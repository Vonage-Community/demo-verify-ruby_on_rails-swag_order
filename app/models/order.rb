class Order < ApplicationRecord
  def to_param
    self.uuid
  end

  validates_presence_of :product_name, :uuid
end
