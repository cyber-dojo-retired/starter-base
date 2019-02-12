#!/usr/bin/ruby

require 'json'

def data_set_name
  ARGV[0]
end

def target_dir
  ARGV[1]
end

# - - - - - - - - - - - - - - - - - - - - - - -

def custom_no_manifests
  `cp -R /app/custom-yahtzee #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").each do |manifest_filename|
    `rm #{manifest_filename}`
  end
end

def exercises_no_manifests
  `cp -R /app/exercises-bowling-game #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").each do |manifest_filename|
    `rm #{manifest_filename}`
  end
end

def languages_no_manifests
  `cp -R /app/languages-ruby-minitest #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").each do |manifest_filename|
    `rm #{manifest_filename}`
  end
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_bad_json
  `cp -R /app/languages-python-unittest #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").sort.each do |manifest_filename|
    IO.write(manifest_filename, 'sdfsdf')
    break
  end
end

def exercises_bad_json
  `cp -R /app/exercises-bowling-game #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").sort.each do |manifest_filename|
    IO.write(manifest_filename, 'ggghhhjjj')
    break
  end
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_has_duplicate_keys
  `cp -R /app/languages-csharp-nunit #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").sort.each do |manifest_filename|
    manifest = <<~MANIFEST.strip
    {
      "display_name": "C#, NUnit",
      "display_name": "C#, JUnit",
      "visible_filenames": [
        "HikerTest.cs",
        "Hiker.cs",
        "cyber-dojo.sh"
      ],
      "hidden_filenames": [ "TestResult\\.xml" ],
      "image_name": "cyberdojofoundation/csharp_nunit",
      "runner_choice": "stateless",
      "filename_extension": ".cs"
    }
    MANIFEST
    IO.write(manifest_filename, manifest)
    break
  end
end

def exercises_manifest_has_duplicate_keys
  `cp -R /app/exercises-leap-years #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").sort.each do |manifest_filename|
    manifest = <<~MANIFEST
    {
      "display_name": "Leap Years",
      "display_name": "Years Leap"
    }
    MANIFEST
    IO.write(manifest_filename, manifest)
    break
  end
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_has_unknown_key
  peturb_manifest('languages-csharp-nunit', 'Display_name', 'C#, NUnit')
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_missing_display_name
  `cp -R /app/languages-csharp-nunit #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").sort.each do |manifest_filename|
    # no display_name
    manifest = <<~MANIFEST.strip
    {
      "visible_filenames": [
        "HikerTest.cs",
        "Hiker.cs",
        "cyber-dojo.sh"
      ],
      "image_name": "cyberdojofoundation/csharp_nunit",
      "filename_extension": ".cs"
    }
    MANIFEST
    IO.write(manifest_filename, manifest)
    break
  end
end

def languages_manifest_missing_visible_filenames
  `cp -R /app/languages-csharp-nunit #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").sort.each do |manifest_filename|
    # no display_name
    manifest = <<~MANIFEST.strip
    {
      "display_name": "C#, NUnit",
      "image_name": "cyberdojofoundation/csharp_nunit",
      "filename_extension": ".cs"
    }
    MANIFEST
    IO.write(manifest_filename, manifest)
    break
  end
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_has_non_string_image_name
  peturb_manifest('languages-csharp-nunit', 'image_name', [1,2,3])
end

def languages_manifest_has_malformed_image_name
  peturb_manifest('languages-csharp-nunit', 'image_name', 'CYBERDOJO/csharp_nunit')
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_has_non_string_display_name
  peturb_manifest('languages-csharp-nunit', 'display_name', [1,2,3])
end

def languages_manifest_has_empty_display_name
  peturb_manifest('languages-csharp-nunit', 'display_name', '')
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_has_non_array_visible_filenames
  value = 1
  peturb_manifest('languages-csharp-nunit', 'visible_filenames', value)
end

def languages_manifest_has_empty_visible_filenames
  value = []
  peturb_manifest('languages-csharp-nunit', 'visible_filenames', value)
end

def languages_manifest_has_non_array_string_visible_filenames
  value = [1,2,3]
  peturb_manifest('languages-csharp-nunit', 'visible_filenames', value)
end

def languages_manifest_has_empty_string_visible_filename
  value = ["hiker.cs", ""]
  peturb_manifest('languages-csharp-nunit', 'visible_filenames', value)
end

def languages_manifest_visible_filename_has_non_portable_character
  value = ["hiker.cs","hiker&.cs"]
  peturb_manifest('languages-csharp-nunit', 'visible_filenames', value)
end

def languages_manifest_visible_filename_has_non_portable_leading_character
  value = ["-hiker.cs","hiker.test.cs"]
  peturb_manifest('languages-csharp-nunit', 'visible_filenames', value)
end

def languages_manifest_visible_filename_has_duplicates
  value = ["a.cs", "b.cs", "c.cs", "b.cs"]
  peturb_manifest('languages-csharp-nunit', 'visible_filenames', value)
end

def languages_manifest_visible_filename_does_not_exist
  value = [ 'HikerTest.cs', 'xHiker.cs', 'cyber-dojo.sh' ]
  peturb_manifest('languages-csharp-nunit', 'visible_filenames', value)
end

def languages_manifest_visible_filename_no_cyber_dojo_sh
  value = [ 'HikerTest.cs', 'Hiker.cs' ]
  peturb_manifest('languages-csharp-nunit', 'visible_filenames', value)
end

# - - - - - - - - - - - - - - - - - - - - - - -

def languages_manifest_has_non_string_filename_extension
  value = 1
  peturb_manifest('languages-csharp-nunit', 'filename_extension', value)
end

# - - - - - - - - - - - - - - - - - - - - - - -

def peturb_manifest(dir_name, key, value)
  `cp -R /app/#{dir_name} #{target_dir}`
  Dir.glob("#{target_dir}/**/manifest.json").sort.each do |manifest_filename|
    json = JSON.parse!(IO.read(manifest_filename))
    json[key] = value
    IO.write(manifest_filename, JSON.pretty_generate(json))
    break
  end
end

# - - - - - - - - - - - - - - - - - - - - - - -

eval(data_set_name)
