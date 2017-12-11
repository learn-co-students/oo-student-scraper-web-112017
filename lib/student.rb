class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url

  @@all = []

  def initialize(student_hash)
    student_hash.each do |key, value|
      self.send("#{key}=", value)
      @@all << self
    end
  end

  def self.create_from_collection(students_array)
    students_array.map do |hash|
      Student.new(hash)
    end
  end

  def add_student_attributes(attributes_hash)
    attributes_hash.each do |key, value|
      self.send("#{key.to_s}=", value)
    end
    self
  end

  def self.all
    @@all.uniq
  end
end
