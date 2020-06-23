class RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, :only => :create
  
  def create
    build_resource(sign_up_params)
    if resource.save!
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        render :json => {success: true}
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        render :json => {success: true}
      end
    else
      clean_up_passwords resource
    end
  end

  private

  def sign_up_params
    params.require(:user).permit( :first_name,
                                  :last_name, 
                                  :email, 
                                  :password, 
                                  :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit( :first_name, 
                                  :last_name, 
                                  :email, 
                                  :password, 
                                  :password_confirmation, 
                                  :current_password)
  end

end