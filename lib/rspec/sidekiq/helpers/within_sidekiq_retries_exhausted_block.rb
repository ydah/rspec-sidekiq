# frozen_string_literal: true

module Sidekiq
  module Worker
    module ClassMethods
      def within_sidekiq_retries_exhausted_block(user_msg = {}, exception = default_retries_exhausted_exception, &block)
        unless sidekiq_retries_exhausted_block
          raise ArgumentError, 'Define `sidekiq_retries_exhausted` before calling `within_sidekiq_retries_exhausted_block`'
        end

        block.call
        sidekiq_retries_exhausted_block.call(default_retries_exhausted_message.merge(user_msg), exception)
      end

      def default_retries_exhausted_message
        {
          'queue' => get_sidekiq_options['queue'],
          'class' => name,
          'args' => [],
          'error_message' => 'An error occurred'
        }
      end

      def default_retries_exhausted_exception
        StandardError.new('An error occurred')
      end
    end
  end
end
