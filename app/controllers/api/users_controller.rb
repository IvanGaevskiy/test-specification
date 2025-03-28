class Api::UsersController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    result = Users::Create.run(user_params)

    if result.valid?
      render json: { status: 'success', user: result.result }, status: :created
    else
      render json: { status: 'error', errors: result.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(
      :surname, :name, :patronymic, :email, :age,
      :nationality, :country, :gender, :skills,
      interests: []
    )
  end
end
