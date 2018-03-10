class Admin::ImageUploader < CarrierWave::Uploader::Base

  #**************************************************#
  # This uploader only used for Image model
  # *************************************************#

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  process :store_file_info

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :mini do
    process resize_to_fit: [48, 48]
  end

  version :small do
    process resize_to_fit: [100, 100]
  end

  version :product do
    process resize_to_fit: [240, 240]
  end

  version :large do
    process resize_to_fit: [600, 600]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  private

  def store_file_info
    if file && model
      model.content_type = file.content_type if file.content_type
      model.file_size = file.size
      img = ::Magick::Image::read(file.file).first
      model.width = img.columns
      model.height = img.rows
    end
  end
end
