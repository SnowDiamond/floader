module Database
  def self.connect
    host = 'localhost'
    user = 'root'
    password = '1371'
    database = 'floader'
    @@db ||= Mysql.connect(host, user, password, database)
  end
end