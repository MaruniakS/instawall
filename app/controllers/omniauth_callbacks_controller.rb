class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def instagram
    generic_callback( 'instagram' )
  end

  def generic_callback( provider )
    @user = User.find_for_oauth env["omniauth.auth"]

    if @user.persisted?
      # This is because we've created the user manually, and Device expects a
      # FormUser class (with the validations)
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end