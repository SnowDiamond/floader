class DataManage
  class << self
    def find(id);
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
    attributes = self.class.attributes.map { |attribute| "#{attribute} = ?" }.join(', ')
    sql = "UPDATE #{self.class.table_name} SET #{attributes} WHERE id = ?"
    request = Database.connect.prepare(sql)
    values = self.class.attributes.map { |attribute| send(attribute) }
    request.execute(*values, id)
    request.close
    return self
  end
end
