class Example::UsersController < ApplicationController

  def show
    @user = {id: 1, name: "name", password: "pass"}
    respond_to do |format|
      format.html
      format.json { render :json => @user.to_json(:only => [:id, :name]) }
    end
  end

end
