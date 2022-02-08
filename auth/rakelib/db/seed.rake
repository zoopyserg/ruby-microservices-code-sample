# frozen_string_literal: true

namespace :db do
  desc 'Seed the database'
  task seed: :settings do
    require 'sequel'
    require 'sequel/extensions/seed'
    require_relative '../../config/initializers/db'

    seeds = File.expand_path('../../db/seeds', __dir__)

    Sequel::Seed.setup ENV['RACK_ENV'].to_sym
    Sequel.extension :seed

    p 'Seeding started'
    Sequel.connect(Settings.db.to_hash) do |db|
      Sequel::Seeder.apply(db, seeds)
    end
    p 'Seeding was successfully finished'
  end
end
