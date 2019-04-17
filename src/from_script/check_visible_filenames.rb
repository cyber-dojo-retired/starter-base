require_relative 'show_error'

module CheckVisibleFilenames

  include ShowError

  def check_visible_filenames(url, manifest_filename, json, error_code)
    visible_filenames = json['visible_filenames']
    exit_unless_visible_filenames_is_array(visible_filenames, url, manifest_filename, error_code)
    exit_if_visible_filenames_is_empty(visible_filenames, url, manifest_filename, error_code)
    visible_filenames.each_with_index do |filename,index|
      exit_unless_visible_filename_is_a_String(visible_filenames, filename, index, url, manifest_filename, error_code)
      exit_if_visible_filename_is_empty(visible_filenames, filename, index, url, manifest_filename, error_code)
      exit_unless_visible_filename_is_portable(visible_filenames, filename, index, url, manifest_filename, error_code)
    end
    exit_if_visible_filename_duplicate(visible_filenames, url, manifest_filename, error_code)
    check_language_visible_filename_cyber_dojo_sh(visible_filenames, url, manifest_filename, error_code)
    exit_unless_all_visible_filenames_exist(visible_filenames, url, manifest_filename, error_code)
    exit_if_visible_file_too_large(visible_filenames, url, manifest_filename, error_code)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def exit_unless_visible_filenames_is_array(visible_filenames, url, manifest_filename, error_code)
    unless visible_filenames.is_a?(Array)
      title = 'visible_filenames is not an Array'
      key = quoted('visible_filenames')
      msg = "#{key}: #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

  def exit_if_visible_filenames_is_empty(visible_filenames, url, manifest_filename, error_code)
    if visible_filenames.empty?
      title = 'visible_filenames cannot be empty'
      key = quoted('visible_filenames')
      msg = "#{key}: #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

  def exit_unless_visible_filename_is_a_String(visible_filenames, filename, index, url, manifest_filename, error_code)
    unless filename.is_a?(String)
      title = "visible_filenames[#{index}]=#{filename.to_s} is not a String"
      key = quoted('visible_filenames')
      msg = "#{key}: #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

  def exit_if_visible_filename_is_empty(visible_filenames, filename, index, url, manifest_filename, error_code)
    if filename.empty?
      title = "visible_filenames[#{index}]='' cannot be empty String"
      key = quoted('visible_filenames')
      msg = "#{key}: #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

  def exit_unless_visible_filename_is_portable(visible_filenames, filename, index, url, manifest_filename, error_code)
    filename.each_char do |ch|
      unless portable?(ch)
        title = "visible_filenames[#{index}]=#{quoted(filename)} has non-portable character '#{ch}'"
        key = quoted('visible_filenames')
        msg = "#{key}: #{visible_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
    if filename[0] == '-'
      title = "visible_filenames[#{index}]=#{quoted(filename)} has non-portable leading character '-'"
      key = quoted('visible_filenames')
      msg = "#{key}: #{visible_filenames}"
      show_error(title, url, manifest_filename, msg)
      exit(error_code)
    end
  end

  def exit_if_visible_filename_duplicate(visible_filenames, url, manifest_filename, error_code)
    visible_filenames.each do |filename|
      dups = get_dup_indexes(visible_filenames, filename)
      unless dups == []
        title = "visible_filenames#{dups} are duplicates of #{quoted(filename)}"
        key = quoted('visible_filenames')
        msg = "#{key}: #{visible_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
  end

  def exit_unless_all_visible_filenames_exist(visible_filenames, url, manifest_filename, error_code)
    dir_name = File.dirname(manifest_filename)
    visible_filenames.each_with_index do |filename,index|
      unless File.exists?(dir_name + '/' + filename)
        title = "visible_filenames[#{index}]=#{quoted(filename)} does not exist"
        key = quoted('visible_filenames')
        msg = "#{key}: #{visible_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
  end

  def exit_if_visible_file_too_large(visible_filenames, url, manifest_filename, error_code)
    dir_name = File.dirname(manifest_filename)
    visible_filenames.each_with_index do |filename,index|
      if File.size("#{dir_name}/#{filename}") > 25*1024
        title = "visible_filenames[#{index}]=#{quoted(filename)} is too large (>25K)"
        key = quoted('visible_filenames')
        msg = "#{key}: #{visible_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
  end

  def check_language_visible_filename_cyber_dojo_sh(visible_filenames, url, manifest_filename, error_code)
    if @type == 'languages'
      unless visible_filenames.include?('cyber-dojo.sh')
        title = 'visible_filenames does not include "cyber-dojo.sh"'
        key = quoted('visible_filenames')
        msg = "#{key}: #{visible_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
    if @type == 'exercises'
      if visible_filenames.include?('cyber-dojo.sh')
        title = 'visible_filenames cannot include "cyber-dojo.sh"'
        key = quoted('visible_filenames')
        msg = "#{key}: #{visible_filenames}"
        show_error(title, url, manifest_filename, msg)
        exit(error_code)
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def get_dup_indexes(all, value)
    dups = all.each_index.select { |index| all[index] == value }
    dups.size != 1 ? dups : []
  end

  def portable?(ch)
    # http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_278
    # I allow forward slash since some filenames include dirs.
    upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    lower = 'abcdefghijklmnopqrstuvwxyz'
    digits = '0123456789'
    extra = '/._-'
    (upper+lower+digits+extra).include?(ch)
  end

end