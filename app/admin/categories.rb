ActiveAdmin.register Category do

  menu priority: 1
  menu parent: "Listed Items"

  permit_params :category_name, :approval_status, :image

  actions :all, except: [:update, :edit]


  filter :category_name

  member_action :approve,  method: :put do
    resource.update(approval_status: 'Approved')
    redirect_to admin_categories_path, notice: "New Category added"
  end

  member_action :reject, method: :put do
    resource.update(approval_status: 'Rejected')
    redirect_to admin_categories_path, notice: "Cannot add new category. Try again."
  end

  action_item :approve, only: :show do
    if resource.approval_status == 'Approved'
      link_to "Reject", reject_admin_category_path(resource), method: :put
    elsif resource.approval_status == 'Rejected'
      link_to "Approve", approve_admin_category_path(resource), method: :put
    else
      link_to "Approve", approve_admin_category_path(resource), method: :put
    end
  end
  
  index do
    id_column
    column :category_name
    column :approval_status
    actions 
  end

  show do
    attributes_table do
      row :category_name
      if resource.image.persisted?
        row :image do |category|
          image_tag(category.image, height: '100px')
        end
      end
    end
  end

  form do |f|
    f.semantic_errors 
    f.inputs do
      f.input :category_name
      f.input :image, as: :file, input_html: {accept: ".jpg, .jpeg"}, hint: (image_tag(f.object.image, width: 150) if f.object.image.attached?)
    end
    f.actions do
      f.action :submit, as: :button, label: resource.persisted? ? 'Update' : 'Create'
    end
  end
end