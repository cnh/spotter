class Issue < ActiveRecord::Base
  has_attached_file :image, :styles => { :medium => "300x300", :thumb => "100x100"}
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode
  before_create :randomize_file_name

  def image_thumb
    image.url(:thumb)
  end

  def image_medium
    # we do not send large images yet. At the most, a medium sized.
    image.url(:medium)
  end

  def self.in_area lat, lng, area
    Issue.near([lat, lng], area)
  end

  def distance lat, lng
    self.distance_from([lat, lng])
  end

  def randomize_file_name
    extension = File.extname(image_file_name).downcase
    self.image.instance_write(:file_name, "#{SecureRandom.hex(16)}#{extension}")
  end
end
