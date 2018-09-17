module Backend::ProductsHelper
  def load_data_categories data
    @options = options_from_collection_for_select(data, :id, :name)
  end
end
