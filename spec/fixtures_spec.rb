describe DataLoader do
  before :each do
    Database.connect.query("DELETE from users")
    DataLoader.execute
  end
  it 'creates new records' do     
    count = Database.connect.query("SELECT * from users").num_rows
    expect(count).to eq 4
  end

  it 'updates duplicate records' do
    Database.connect.query("UPDATE users SET name = 'suzi' WHERE id = 1")
    DataLoader.execute
    name = Database.connect.query("SELECT * from users WHERE id = 1").fetch_hash["name"]
    expect(name).to eq 'kate'
  end
end