class Student
  attr_accessor :id, :name, :grade
  @@all = []

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students;"
    DB[:conn].execute(sql).each {|result| @@all << self.new_from_db(result)}
    @@all
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students 
      WHERE name = ?
    SQL

    results = DB[:conn].execute(sql, name)
    self.new_from_db(results[0])
  end

  def self.all_students_in_grade_9
    all_students_in_grade_X(9)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students 
      WHERE grade < ?
    SQL

    students = []
    DB[:conn].execute(sql, '12').each {|result|  students << self.new_from_db(result)}
    students    
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students 
      WHERE grade = 10 
      LIMIT ? 
    SQL

    students = []
    DB[:conn].execute(sql, x).each {|result|  students << self.new_from_db(result)}
    students    
  end

  def self.first_student_in_grade_10
    first_X_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT * FROM students 
      WHERE grade = ?
    SQL

    students = []
    DB[:conn].execute(sql, x).each {|result|  students << self.new_from_db(result)}
    students    
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
end