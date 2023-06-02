ActiveAdmin.register Subcategory do

  menu parent: "Listed Items"

  actions :all, except: [:update, :edit]

  permit_params :subcategory_name, :approval_status, :image

  filter :subcategory_name

  member_action :approve,  method: :put do
    resource.update(approval_status: 'Approved')
    redirect_to admin_subcategories_path, notice: "New subcategoy Listed"
  end

  member_action :reject, method: :put do
    resource.update(approval_status: 'Rejected')
    redirect_to admin_subcategories_path, notice: "Cannot add new subcategory. Try again"
  end

  action_item :approve, only: :show do
    if resource.approval_status == 'Approved'
      link_to "Reject", reject_admin_subcategory_path(resource), method: :put
    elsif resource.approval_status == 'Rejected'
      link_to "Approve", approve_admin_subcategory_path(resource), method: :put
    else
      link_to "Approve", approve_admin_subcategory_path(resource), method: :put
    end
  end
  
  index do
    id_column
    column :subcategory_name
    actions
  end

  show do
    attributes_table do
      row :subcategory_name
      if resource.image.persisted?
        row :image do |subcategory|
          image_tag(subcategory.image, height: '100px')
        end
      end
    end
  end

  form do |f|
    f.semantic_errors 
    f.inputs do
      f.input :subcategory_name
      f.input :category, as: :select, collection: Category.pluck(:category_name, :id)
      f.input :image, as: :file, input_html: {accept: ".jpg, .jpeg"}, hint: (image_tag(f.object.image, width: 150) if f.object.image.attached?)
    end
    f.actions do
      f.action :submit, as: :button, label: resource.persisted? ? 'Update' : 'Create'
    end
  end
end