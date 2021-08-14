##
# Make services behave like procs (execute themselves with given params)
#
class ApplicationService
  # rubocop:disable Style/ArgumentsForwarding
  def self.call(*args, &block)
    new(*args, &block).call
  end
  # rubocop:enable Style/ArgumentsForwarding
end
