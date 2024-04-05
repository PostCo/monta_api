# frozen_string_literal: true

require_relative "monta_api/version"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("monta_api" => "MontaAPI")
loader.collapse("#{__dir__}/monta_api/objects")
loader.collapse("#{__dir__}/monta_api/resources")
# Zeitwerk doesn't support multiple classes in a single file
# https://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#one-file-one-constant-at-the-same-top-level
loader.ignore("#{__dir__}/monta_api/errors.rb")
loader.setup

require "monta_api/errors"

module MontaAPI
end
