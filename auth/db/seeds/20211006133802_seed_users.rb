# frozen_string_literal: true

require_relative '../../app/models/user'

Sequel.seed do
  def run
    [
      ['Tom', 'tom@gmail.com', 'qwerty123'],
      ['Logan', 'logan@gmail.com', 'qwerty123'],
      ['Jack', 'jack@gmail.com', 'qwerty123']
    ].each do |name, email, pass|
      User.create name: name, email: email, password: pass
    end
  end
end
