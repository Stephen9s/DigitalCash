class UsersController < ApplicationController
  
  before_filter :authenticate_user, :except => [:new, :create]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      flash[:notice] = "Username successfully created!"
      flash[:color] = "valid"
      
      @new_account = CheckingAccount.create(:owner_id => @user.id, :amount => 1000)
      
      # if created, then don't ask them to create another one...
      # redirect to login
      redirect_to :controller => 'sessions', :action => 'login'
    else
      flash[:notice] = "Form is invalid"
      flash[:color] = "invalid"
      render "new"
    end
    
  end
  
end
