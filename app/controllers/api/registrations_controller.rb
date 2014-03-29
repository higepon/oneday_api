class Api::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  skip_before_filter :authenticate_scope!, :only => [:update]
  respond_to :json

  def create
    build_resource(params[:user])
    if resource.save
      if resource.active_for_authentication?
        sign_in(resource)
        @success = true
        @user = resource
        return
      else
        expire_session_data_after_sign_in!
        # quick hack
        @user.confirmed_at = Time.new
        @user.save!
        return render :json => {:success => true, :user => @user }
      end
    else
      clean_up_passwords resource
      return render :status => 401, :json => {:errors => resource.errors}
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :heard_how,
        :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name,
        :email, :password, :password_confirmation, :current_password)
    end
  end
end
