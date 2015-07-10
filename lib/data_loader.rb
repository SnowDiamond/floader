class DataLoader
  class << self

    def from_ini(model)
      fixtures = IniFile.load("./fixtures/#{model.name.downcase}.ini")
      return unless fixtures
      fixtures.each_section do |section|
        load_fixture(fixtures[section], model)
      end
    end

    def from_json(model)
      file_path = "./fixtures/#{model.name.downcase}.json"
      return unless File.exists?(file_path)
      data = File.open(file_path).read
      fixtures = JSON.parse(data)
      fixtures.each do |fixture|
        load_fixture(fixture, model)
      end     
    end

    def load_fixture(fixture, model)
      id = model.find(fixture["id"]).id if model.find(fixture["id"])
      if id.nil?
        keys = fixture.keys.join(', ')        
        values = fixture.values.map { |el| "'#{el}'" }.join(', ')
        Database.connect.query("INSERT INTO #{model.table_name}(#{keys}) VALUES(#{values})")
      else
        fields = fixture.keys.map { |key| "#{key} = ?" }.join(', ')
        sql = "UPDATE #{model.table_name} SET #{fields} WHERE id = ?"
        request = Database.connect.prepare(sql)
        values = fixture.values
        request.execute(*values, id)
      end
    end 

    private :new
  end
end