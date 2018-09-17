class Product < ApplicationRecord
  belongs_to :category
  delegate :name, to: :category, prefix: true

  has_many :comments, dependent: :destroy
  has_many :rattings, dependent: :destroy
  has_many :order_items, dependent: :destroy

  validates :category_id, presence: true
  validates :name, presence: true, length: {maximum: Settings.maximum.name}
  validates :price, presence: true, numericality: true
  validates :description, presence: true,
    length: {maximum: Settings.maximum.description}
  validates :quantity, presence: true, numericality: {only_integer: true}

  mount_uploader :picture, PictureUploader

  scope :newest, ->{order created_at: :desc}
  scope :search, ->(key, cat_id) do
    where "name LIKE ? OR category_id = ?", "%#{key}%", "%#{cat_id}%"
  end
  scope :search_by_key, ->(key) do
    where "name LIKE ? ", "%#{key}%"
  end
  scope :of_category_id, ->(cat_id){where(category_id: cat_id)}
  scope :top_order, ->{order(number_of_order: :desc).limit Settings.top_order}
  scope :newest, ->{order(created_at: :desc).limit Settings.product_recent}
  scope :by_category, ->(category_id){where category_id: category_id if category_id.present?}
  scope :by_name, ->(name){where "name LIKE ?", "%#{name}%" if name.present?}
  scope :by_min_price, ->(min){where "price >= #{min}" if min.present?}
  scope :by_max_price, ->(max){where "price <= #{max}" if max.present?}

  def update_quantity old_quantity
    update_attributes quantity: (quantity - old_quantity)
  end
  class << self
    def import_file file
      spreadsheet = Roo::Spreadsheet.open file
      header = spreadsheet.row 1
      (2..spreadsheet.last_row).each do |i|
        data = spreadsheet.row(i)
        [header, spreadsheet.row(i)].transpose.to_h
        product = Product.new
        load_data product, data
        product.save!
      end
    end

    def load_data product, data
      product.name = data[Settings.data_name]
      product.price = data[Settings.data_price]
      product.quantity = data[Settings.data_quantity]
      product.description = data[Settings.data_description]
      if File.exist?(Rails.root.join("public#{data[4]}")).present?
        product.picture = File.open(Rails.root.join("public#{data[4]}"))
      end
      product.number_of_order = data[Settings.data_number_of_order]
      product.category_id = data[Settings.data_category_id]
    end
  end
end
