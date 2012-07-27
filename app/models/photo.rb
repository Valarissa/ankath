class Photo < ActiveRecord::Base
  validates_uniqueness_of :filename

  attr_accessible :name, :description, :filename

  UPLOADED_IMAGE_ROOT = 'images/work/'

  def filepath
    UPLOADED_IMAGE_ROOT + filename
  end

  def move(filename)
    Photo.check_filename(filename)
    old_file = File.open(Photo.path_to(self.filename), 'r')
    begin
      File.open(Photo.path_to(filename), 'w') do |f|
        f.write(old_file.read)
      end
      old_file.close
    rescue
      old_file.close
      File.delete(Photo.path_to(filename))
      raise "Failed to save properly"
    end

    File.delete(Photo.path_to(self.filename))

    self.filename = filename
  end

  def self.upload(file)
    filename = file.original_filename
    if filename =~ /(jpg|png|gif)$/
      Photo.check_filename(filename)
      path = Photo.path_to(filename)
      File.open(path, 'w') do |f|
        f.set_encoding('ascii-8bit')
        f.write(file.read)
      end
      return filename
    else
      raise "Not an image file"
    end
  end

  private

  def self.check_filename(name)
    if Photo.where(:filename => name).exists?
      raise "Filename already exists in the database"
    end
  end

  def self.path_to(filename)
    File.join(Rails.root, 'public/assets', UPLOADED_IMAGE_ROOT, filename).to_s
  end
end
