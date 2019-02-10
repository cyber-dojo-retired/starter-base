require_relative 'show_error'
require_relative 'well_formed_image_name'

module CheckImageNameIsValid

  include ShowError
  include WellFormedImageName

  def check_image_name_is_valid(url, filename, json)
    image_name = json['image_name']
    unless image_name.is_a?(String)
      title = 'invalid image_name in manifest.json file'
      msg = "\"image_name\": #{image_name}"
      show_error(title, url, filename, msg)
      exit(21)
    end
    unless well_formed_image_name?(image_name)
      title = 'malformed image_name in manifest.json file'
      msg = "\"image_name\": \"#{image_name}\""
      show_error(title, url, filename, msg)
      exit(22)
    end
  end

end
