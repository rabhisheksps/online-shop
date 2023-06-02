ActiveAdmin.register Product do 

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  
  # Uncomment all parameters which should be permitted for assignment

  # menu label: "My Products"
  menu priority: 1
  menu parent: "Listed Items"
  
  permit_params :product_name, :price, :material, :vendor, :description, :available, :approval_status, images: []
  
  actions :all, except: [:update, :edit]

  # includes :state it needs to have an association displaying state (eager loading)

  filter :material
  filter :price
  
  member_action :approve, method: :put do
    resource.update(approval_status: 'Approved')
    redirect_to admin_products_path, notice: "Product listed!"
  end

  member_action :reject, method: :put do
    resource.update(approval_status: 'Rejected')
    redirect_to admin_products_path, notice: "Product remove from the list!"
  end

  action_item :approve, only: :show do
    if resource.approval_status == 'Approved'
      link_to "Reject", reject_admin_product_path(resource), method: :put
    elsif resource.approval_status == 'Rejected'
      link_to "Approve", approve_admin_product_path(resource), method: :put
    else
      link_to "Approve", approve_admin_product_path(resource), method: :put
    end
  end

  index do
    id_column
    column :product_name
    column :price
    column :material
    actions
  end

  show do 
    attributes_table do
      row :id
      row :product_name
      row :price
      row :vendor
      row :description
      row :available
      row :approval_status
    end
    panel 'Images' do
      table_for resource.images do
        column 'Image' do |image|
          image_tag(image, height: '100px')
        end
      end
    end
  end

  controller do 
    def create
      @product = Product.new(permitted_params[:product])
    end
  end
end