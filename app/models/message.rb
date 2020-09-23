class Message < ApplicationModel
  attribute :content, :string
  attribute :recipient, :string
  attribute :subject, :string

  validates :recipient,
    presence: true,
    format: /[[:word:]]+@[[:word:]]+/,
    exclusion: {in: ["me@example.com"]}
  validates :subject, presence: true, length: {maximum: 10}
end
