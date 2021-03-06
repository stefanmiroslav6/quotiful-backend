module Jobs
  class UploadPost
    @queue = :upload

    def self.perform(post_id)
      require 'open-uri'
      require "em-synchrony"
      require "em-synchrony/fiber_iterator"
      require "thread"

      post = Post.find(post_id)

      images = Response::Object.new('post', post).to_hash[:data][:post].values_at(:s_thumbnail_url, :m_thumbnail_url, :quote_image_url).delete_if {|u| u.starts_with?("http://d1t4f9gbrjiu98.cloudfront.net/")}
      images += [post.quote_image_url('35x35#'), post.quote_image_url('612x612#'), post.quote_image_url]

      EM.synchrony do
        EM::Synchrony::FiberIterator.new(images, 10).each do |image|
          url = URI.parse(image)
          open(url) do |http|
            response = http.read
            puts "response: #{response.inspect}"
          end
        end
        EM.stop
      end
    end
  end
end