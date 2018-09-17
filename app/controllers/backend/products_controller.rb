class Backend::ProductsController < Backend::BaseController
  before_action :load_categories, except: %i(destroy import)
  before_action :load_product, except: %i(index new create import)

  def index
    @products = Product.includes(:category).newest.paginate page: params[:page],
      per_page: Settings.admin_product_perpage
    if params[:category_id].present?
      (params[:search].present? ? search_key_cat : search_category)
        .paginate page: params[:page], per_page: Settings.admin_product_perpage
    elsif params[:search].present?
      search_key
    end
  end

  def new
    @product = Product.new
  end

  def create
    product_params[:number_of_order] = Settings.number_order
    @product = Product.new product_params
    if @product.save
      flash[:success] = t ".create_success"
      redirect_to backend_products_path
    else
      flash[:danger] = t ".create_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @product.update_attributes product_params
      flash[:success] = t ".update_success"
      redirect_to backend_products_path
    else
      render :edit
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = t ".delete_success"
    else
      flash[:danger] = t ".delete_fail"
    end
    redirect_to backend_products_path
  end

  def import
    ActiveRecord::Base.transaction do
      if params[:file].present?
        Product.import_file params[:file]
        flash[:success] = t ".import_succsess"
        redirect_to backend_products_path
      else
        flash[:danger] = t ".have_not_file"
      end
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t ".import_danger"
    redirect_to backend_products_path
  end

  private

  def product_params
    params.require(:product).permit :name, :price, :quantity, :description,
      :picture, :number_of_order, :category_id
  end

  def load_categories
    @categories = Category.all.order_name_alpha
  end

  def load_product
    @product = Product.find params[:id]
  end

  def search_key_cat
    @products = @products.search(params[:search],
      params[:category_id])
  end

  def search_category
    @products = @products.of_category_id(params[:category_id])
  end

  def search_key
    @products = @products.search_by_key(params[:search]).paginate page:
      params[:page], per_page: Settings.admin_product_perpage
  end
end
