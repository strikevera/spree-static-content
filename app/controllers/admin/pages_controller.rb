class Admin::PagesController < Admin::BaseController
  resource_controller

  update.response do |wants|
    wants.html { redirect_to collection_url }
  end
  
  update.after do
    expire_page :controller => 'static_content', :action => 'show', :path => @page.slug
    Rails.cache.delete('page_not_exist/'+@page.slug)
  end
  
  create.response do |wants|
    wants.html { redirect_to collection_url }
  end

  create.after do
    Rails.cache.delete('page_not_exist/'+@page.slug)
  end

  def version
    @version = Page.find(params[:id])
    @version.revert_to(params[:version])
    render :json => @version
  end

  private
  def collection
    return @collection if @collection.present?
    @search = Page.searchlogic(params[:search])
    @search.order ||= "ascend_by_title"
    @collection = @search.do_search.paginate(:per_page => Spree::Config[:admin_products_per_page], :page => params[:page])
  end
end
