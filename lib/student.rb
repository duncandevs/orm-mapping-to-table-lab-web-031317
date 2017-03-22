# attributes
#   has a name and a grade (FAILED - 1)
#   has an id that is readable but not writable (FAILED - 2)
# .create_table
#   creates the students table in the database (FAILED - 3)
# .drop_table
#   drops the students table from the database (FAILED - 4)
# #save
#   saves an instance of the Student class to the database (FAILED - 5)
# .create
#   takes in a hash of attributes and uses metaprogramming to create a new student object. Then it uses the #save method to save that student to the database (FAILED - 6)
#   returns the new object that it instantiated (FAILED - 7)
class Student
  attr_reader :id, :name, :grade
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = nil
  end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )
        SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql =  <<-SQL
      DROP TABLE students
        SQL
    DB[:conn].execute(sql)
  end

  def save
    #remeber that the act of "saving" is the act of inserting a row in the database
    #also note that the save method is being called on an insance
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade) #calling self to pass this instances attributes
    # grab the id from the database and then save it in the instance variable id
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0] # the DB command likely returns an array which can be accessed as [0][0]
  end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def self.create(name:, grade:)
    #create action involves making a new instance of the class and then passing the save method on the instance
    # 1. make new , 2. save to database
    # call this like Student.create(name:"Duncan",grade:10) => will do the following
      #1. create a new instance of the student with name = duncan and grade = 10
      #2. save that instance in the database using the save method which works on the instance
     student = Student.new(name, grade)
     student.save
     student
  end

end
