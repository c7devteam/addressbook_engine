
# encoding: utf-8
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'carrierwave/processing/mini_magick'
require 'carrierwave/processing/mime_types'
module Addressbook
  class AccountContactImageUploader < CarrierWave::Uploader::Base

    include CarrierWave::MiniMagick

    storage :file
   
    def store_dir
      "#{image_storing_path}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    def extension_white_list
       %w(jpg jpeg gif png)
    end

    version :thumb do
      process :resize_to_fill => [100,100]
    end
    
  end
end