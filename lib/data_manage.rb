class DataManage
  class << self
    
    def create(options={})
      keys = options.keys.join(', ')        
      values = options.values.map { |value| "'#{value}'" }.join(', ')
      sql = "INSERT INTO #{table_name} (#{keys}) VALUES (#{values})"
      request = Database.connect.prepare(sql)
      request.execute
      self.find(request.insert_id)
    end

    def find(id)
      sql = "SELECT #{attributes.join(', ')} FROM #{table_name} WHERE id = ?"
      request = Database.connect.prepare(sql)
      request.execute(id)
      result = fetch(request)
      request.close
      return result
    end

    def fetch(request)
      row = request.fetch
      return nil unless row
      record = self.new
      number = 0
      attributes.each do |attribute| 
        record.send("#{attribute}=", row[number])
        number += 1
      end
      return record
    end

    def attributes
      fields = []
      Database.connect.query("select * from #{table_name}").fetch_fields.each do |field|
        fields << field.name
      end
      @@attributes = fields.map(&:to_sym)
      return fields
    end

    def table_name
      self.name.downcase.pluralize
    end
  end
 
  def save
    options = {}
    self.class.attributes.each { |attribute| options[attribute] = send(attribute) }
    update(options)
    return self
  end

  def update(options={})
    attributes = options.keys.map { |key| "#{key} = ?" }.join(', ')    
    values = options.values       
    sql = "UPDATE #{self.class.table_name} SET #{attributes} WHERE id = ?"
    request = Database.connect.prepare(sql)
    request.execute(*values, id)
    request.close
  end
end
