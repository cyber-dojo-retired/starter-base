require 'json'
require_relative 'ready'
require_relative 'sha'
require_relative 'starter'

class StarterCustom

  def initialize
    @cache = {
      'display_names' => display_names('custom'),
      'manifests'     => manifests('custom')
    }
  end

  include Ready
  include Sha

  def start_points
    cache['display_names']
  end

  def manifest(display_name)
    assert_string('display_name', display_name)
    cached_manifest(display_name)
  end

  private

  attr_reader :cache
  include Starter

end
