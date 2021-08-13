require "test_helper"

class TypeTest < ActiveSupport::TestCase
  test 'create a type instance' do
    type = FactoryBot.create :type, :with_name

    assert_equal 'fighting', type.name
  end
end
