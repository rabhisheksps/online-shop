ActiveAdmin.register Cart do 

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  
  # Uncomment all parameters which should be permitted for assignment

  permit_params :payment_status, :approval_status

  actions :all, except: [:new, :create, :update, :edit]

  # includes :state it needs to have an association displaying state (eager loading)

  filter :payment_status
  filter :approval_status

  member_action :accept, method: :put do
    resource.update(approval_status: true)
    redirect_to admin_carts_path, notice: "Order confirmed!"
  end

  member_action :reject, method: :put do
    resource.update(approval_status: false)
    redirect_to admin_carts_path, notice: "Order canceled!"
  end

  action_item :accept, only: :show do
    if resource.approval_status == true
      link_to "Reject", reject_admin_cart_path(resource), method: :put
    elsif resource.approval_status == 'Rejected'
      link_to "Approve", accept_admin_cart_path(resource), method: :put
    else
      link_to "Approve", accept_admin_cart_path(resource), method: :put
    end
  end

  index do
    id_column
    column('Ordered By') { |obj| obj.user.first_name }
    # column('Product Name') { |obj| obj.cart_items.product_name }
    column :approval_status
    actions
  end

  show do 
    attributes_table do
      # row('Product Name') { |obj| obj.product.product_name }
      # row('Product Seller') { |obj| obj.product.vendor}
      row :approval_status
      # row :state
      # row :country
      # row :pincode
      # row :subtotal
      # row('Added Tax') { |obj| obj.product.tax }
      # row('Shipping Fees') { |obj| obj.product.shipping_fees }
      # row :total
    end
    # panel 'Images' do
    #   table_for resource.product.images do
    #     column 'Image' do |image|
    #       image_tag(image, height: '100px')
    #     end
    #   end
    # end
  end
end 