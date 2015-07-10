describe DataLoader do
  before { Database.connect.query("DELETE from users") }
  
  context 'json format' do
    before { DataLoader.from_json User }

    it 'creates new records' do     
      count = Database.connect.query("SELECT * from users").num_rows
      expect(count).to eq 2
    end

    it 'updates duplicate records' do
      Database.connect.query("UPDATE users SET name = 'suzi' WHERE id = 1")
      DataLoader.from_json User
      name = Database.connect.query("SELECT * from users WHERE id = 1").fetch_hash["name"]
      expect(name).to eq 'kate'
    end
  end

  context 'ini format' do
    before { DataLoader.from_ini User }
    it 'creates new records' do
      count = Database.connect.query("SELECT * from users").num_rows
      expect(count).to eq 2
    end

    it 'updates duplicate records' do
      Database.connect.query("UPDATE users SET name = 'kate' WHERE id = 3")
      DataLoader.from_ini User
      name = Database.connect.query("SELECT * from users WHERE id = 3").fetch_hash["name"]
      expect(name).to eq 'glory'
    end
  end
end