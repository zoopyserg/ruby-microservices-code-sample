# frozen_string_literal: true

module ApplicationLoader
  extend self

  def load_app!
    init_config
    require_app
    init_app
  end

  private

  def init_config
    require_file 'config/initializers/config'
  end

  def require_app
    require_dir 'app/services'
    require_dir 'app/helpers'
    require_file 'config/application'
    require_dir 'app'
  end

  def init_app
    require_file 'config/initializers/logger'
    require_dir 'config/initializers'
  end

  def require_file(path)
    require File.join(root, path)
  end

  def require_dir(path)
    path = File.join(root, path)
    Dir["#{path}/**/*.rb"].each { |file| require file }
  end

  def root
    File.expand_path('..', __dir__)
  end
end
