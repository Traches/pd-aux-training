class Video < ApplicationRecord
  URL_REGEX = %r{(youtu\.be/|youtube\.com/(watch\?(.*&)?v=|(embed|v)/))([^\?&"'>]+)}.freeze

  # Associations:
  belongs_to :lesson, inverse_of: :video

  # Validations:
  validates :url, presence: true
  validates_format_of :url, with: URL_REGEX,
                            message: ": I'm sorry, I don't know what to do with that address."

  # Custom methods:
  def yt_id
    URL_REGEX.match(url)[5]
  end
end
