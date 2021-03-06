module Gitlab
  module Ci
    module Build
      class Step
        WHEN_ON_FAILURE = 'on_failure'.freeze
        WHEN_ON_SUCCESS = 'on_success'.freeze
        WHEN_ALWAYS = 'always'.freeze

        attr_reader :name
        attr_writer :script
        attr_accessor :timeout, :when, :allow_failure

        class << self
          def from_commands(job)
            self.new(:script).tap do |step|
              step.script = job.commands
              step.timeout = job.timeout
              step.when = WHEN_ON_SUCCESS
            end
          end

          def from_after_script(job)
            after_script = job.options[:after_script]
            return unless after_script

            self.new(:after_script).tap do |step|
              step.script = after_script
              step.timeout = job.timeout
              step.when = WHEN_ALWAYS
              step.allow_failure = true
            end
          end
        end

        def initialize(name)
          @name = name
          @allow_failure = false
        end

        def script
          @script.split("\n")
        end
      end
    end
  end
end
