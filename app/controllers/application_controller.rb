class ApplicationController < ActionController::API
  def not_found
    render json: { error: 'not_found' }
  end

  private

  def check_admin_role
    unless @current_user.present? && @current_user.admin?
      return render json: { errors: 'Need admin permission' }, status: :unauthorized
    end
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
