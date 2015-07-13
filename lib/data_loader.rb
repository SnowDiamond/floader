class DataLoader
  class << self
    def execute
      Dir.glob("fixtures/*.{json,ini}").each do |file|
        if model = model_exist?(file)
          loader = File.extname(file) == '.json' ? JsonLoader.new(file) : IniLoader.new(file)
          loader.parse do |data|
            record = model.find(data["id"])
            record.nil? ? model.create(data) : record.update(data)
          end
        end
      end
    end

    def model_exist?(file_name)
      model = File.basename(file_name, ".*").capitalize.constantize
      rescue NameError
      model && model.superclass == DataManage
    end

    private :new
  end
end