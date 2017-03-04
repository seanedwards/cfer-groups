$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

module Cfer
  DEBUG = true if ENV['CFER_DBG']
end

require "cfer"
require "cfer/groups"

Cfer::LOGGER.level = Logger::DEBUG if ENV['CFER_DBG']

