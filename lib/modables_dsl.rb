require 'active_support/json'
require 'active_support/core_ext/hash/deep_merge'

require_relative 'modables_dsl/dsl/arguments'
require_relative 'modables_dsl/dsl/core'

template = ModablesDSL::DSL.instance_eval(File.read('main.tf.rb'))

print template