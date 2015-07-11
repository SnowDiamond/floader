class DataLoader
  class << self
    def execute
      Dir.glob("fixtures/*.{json,ini}").each do |file|
        if model = model_exist?(file)
          loader = File.extname(file) == '.json' ? JsonLoader.new(file) : IniLoader.new(file)
          loader.parse do |data|
            load_fixture(data, model)
          end
        end
      end
    end

    def model_exist?(file_name)
      model = File.basename(file_name, ".*").capitalize.constantize
      rescue NameError
      model && model.superclass == DataManage
    end

    def load_fixture(data, model)
      id = model.find(data["id"]).id if model.find(data["id"])
      if id.nil?
        keys = data.keys.join(', ')        
        values = data.values.map { |el| "'#{el}'" }.join(', ')
        Database.connect.query("INSERT INTO #{model.table_name}(#{keys}) VALUES(#{values})")
      else
        fields = data.keys.map { |key| "#{key} = ?" }.join(', ')
        sql = "UPDATE #{model.table_name} SET #{fields} WHERE id = ?"
        request = Database.connect.prepare(sql)
        values = data.values
        request.execute(*values, id)
      end
    end 

    private :new
  end
end