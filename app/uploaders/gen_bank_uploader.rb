class GenBankUploader < CarrierWave::Uploader::Base
  storage :file

  if Rails.env.test?
    CarrierWave.configure do |config|
      config.enable_processing = false
    end
  end

  def store_dir
    "#{Rails.root}/tmp/uploads/#{DateTime.now.to_f}.#{rand(999)}.#{rand(999)}"
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(gb fasta)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for
  # details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
