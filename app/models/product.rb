class Product < ActiveRecord::Base
  before_destroy :ensure_not_referenced_by_any_line_item
  validates :description, :name, presence: true
  validates :price_in_cents, numericality: {only_integer: true, greater_than: 0}
  has_many :reviews, :dependent => :destroy
  mount_uploader :picture, PictureUploader
  has_many :line_items
  def ensure_not_referenced_by_any_line_item
    if line_items.count.zero?
      return true
    else
      errors[:base] << "Line Items Present"
      return false
    end
  end
  
  def formatted_price
    price_in_dollars = price_in_cents.to_f / 100
    sprintf("%.2f", price_in_dollars)
  end

  def self.search(search)
    where("name ILIKE ? OR description ILIKE ?", "%#{search}%", "%#{search}%")
  end
end
