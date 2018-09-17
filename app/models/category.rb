class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :suggests, dependent: :destroy

  has_many :childs, class_name: Category.name, foreign_key: :parent_id,
   dependent: :destroy

  validates :name, presence: true, length: {maximum: Settings.maximum.name}
  validates :parent_id, presence: true

  scope :newest, ->{order created_at: :desc}
  scope :search, ->(key) do where "name LIKE ?", "%#{key}%" end
  scope :find_parent, ->{where parent_id: 0}
  scope :find_child, ->(parent){where parent_id: parent.ids}
  scope :select_category, ->{where.not id: Category.pluck("parent_id")}
  scope :order_name_alpha, ->{order name: :asc}

  def parent_name
    return "null" if parent_id == Settings.category_roof
    category = Category.find_by id: parent_id
    category ? category.name : t("category.not_found")
  end
end
