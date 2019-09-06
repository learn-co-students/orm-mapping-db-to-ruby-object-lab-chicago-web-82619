require "pry"
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.news_from_db(rows)
    rows.map do |row|
      new_from_db(row)
    end
  end

  def self.all
    sql = <<-SQL
            SELECT * from students
            SQL
    news_from_db(DB[:conn].execute(sql))
  end

  def self.find_by_name(name)
    sql = <<-SQL
            SELECT * from students 
            WHERE name = ?
            LIMIT 1
            SQL
    news_from_db(DB[:conn].execute(sql, name))[0]
  end 
  
  def self.all_students_in_grade_9
   # sql = <<-SQL
   #         SELECT * from students
   #         WHERE grade = 9
   #         SQL
   # self.news_from_db(DB[:conn].execute(sql))
   all_students_in_grade_X(9)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
            SELECT * from students
            WHERE grade < 12
            SQL
    news_from_db(DB[:conn].execute(sql))
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
            SELECT * from students
            WHERE grade = 10
            LIMIT ?
            SQL
    news_from_db(DB[:conn].execute(sql, x))
  end

  def self.first_student_in_grade_10
    first_X_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
            SELECT * from students
            WHERE grade = ?
            SQL
    news_from_db(DB[:conn].execute(sql, x))
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
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
end
