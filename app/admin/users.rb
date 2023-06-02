ActiveAdmin.register User do

  permit_params :email, :first_name, :last_name, :phone_number, :approval_status

  actions :all, except: [:new, :edit, :update]
  filter :email
  filter :first_name
  filter :last_name
  filter :role

  member_action :approve, method: :put do
    resource.update(approval_status: 'Approved')
    redirect_to admin_users_path, notice: "User approved!"
  end

  member_action :reject, method: :put do
    resource.update(approval_status: 'Rejected')
    redirect_to admin_users_path, notice: "User rejected!"
  end

  action_item :approve, only: :show do
    if resource.role == 'Merchant'
      if resource.approval_status == 'Approved'
        link_to "Reject", reject_admin_user_path(resource), method: :put
      elsif resource.approval_status == 'Rejected'
        link_to "Approve", approve_admin_user_path(resource), method: :put
      else
        link_to "Approve", approve_admin_user_path(resource), method: :put
      end
    end
  end
  
  index do
    id_column
    column :email
    column :first_name
    column :last_name
    column('User Address') { |obj| obj.addresses&.first&.address_line_1 || "NA" }
    column :phone_number
    column :role
    actions
  end

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :address
      row :phone_number
      row :approval_status
    end
  end
end
