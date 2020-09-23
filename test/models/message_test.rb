require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "rejects an empty subject" do
    message = Message.new(subject: "")

    assert_not_predicate message, :valid?
    assert_includes message.errors, :subject
  end

  test "accepts valid recipient emails" do
    message = Message.new(recipient: "user@example.com")

    message.validate

    assert_not_includes message.errors, :recipient
  end

  test "rejects empty recipients" do
    message = Message.new(recipient: [])

    assert_not_predicate message, :valid?
    assert_includes message.errors, :recipient
  end

  test "rejects an invalid recipient email" do
    message = Message.new(recipient: "junk-email")

    assert_not_predicate message, :valid?
    assert_includes message.errors, :recipient
  end

  test "rejects the current user's email" do
    message = Message.new(recipient: "me@example.com")

    assert_not_predicate message, :valid?
    assert_includes message.errors, :recipient
  end
end
