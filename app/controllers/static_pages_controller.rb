class StaticPagesController < ApplicationController
  require 'flickr'

  def index
    if params[:user_id].present?
      user_id = params[:user_id]

      Flickr.api_key = ENV['FLICKR_API_KEY']
      Flickr.shared_secret = ENV['FLICKR_SHARED_SECRET']

      flickr = Flickr.new
      begin
        photostream = flickr.people.getPhotos(user_id: user_id)
        @photos = photostream.map do |photo|
          farm = photo['farm']
          server = photo['server']
          id = photo['id']
          secret = photo['secret']
          "https://farm#{farm}.staticflickr.com/#{server}/#{id}_#{secret}.jpg"
        end
      rescue Flickr::FailedResponse => e
        flash[:error] = "Error fetching photostream: #{e.message}"
      end
    end
  end
end
