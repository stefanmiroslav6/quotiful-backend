class PostsController < ApplicationController
  def show
    @post = Post.find_by_created_at(Time.at(params[:id].to_i))
    @page_title = "Photo by #{@post.user.full_name} | "
    image_path = @post.quote_image_url
    host = Rails.env.development? ? 'http://localhost:3000' : URI::HTTP.build({host: DEFAULT_HOST})
    @ogtags = {
      title: "Photo by #{@post.user.full_name} | Quotiful",
      description: "#{@post.user.full_name}'s photo on Quotiful",
      web_url: post_url(@post.created_at.to_i),
      image_url: host + image_path
    }
    
    unless @post.present?
      redirect_to root_url, alert: "Photo not found."
      return
    end
  end
end
