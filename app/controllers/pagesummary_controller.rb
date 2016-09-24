class PagesummaryController < ApplicationController
  def allpages
  	@project = Project.where(:id => params[:id]).first
  	@pages = @project.pages
  end

  def individualpage
  	@project = Project.where(:id => params[:id]).first #Todo: Find out why this is required!
  	@pages = @project.pages.where(:url => "#{params[:url]}")
  end





  
end
