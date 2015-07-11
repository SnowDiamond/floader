describe DataManage do
  before :each do
    DataLoader.execute
  end

  it 'finds record by id' do
    user = User.find(1)
    expect(user.name).to eq 'kate'
  end

  describe 'instance methods' do
    let(:user) { User.find(1) }

    it 'gets attribute value by name' do
      expect(user.age).to eq 25
      expect(user.name).to eq 'kate'
      expect(user.last_name).to eq 'smile'
    end
    
    it 'sets new attribute value' do
      user.age = 20
      expect(user.age).to eq 20
      expect(User.find(1).age).not_to eq 20
    end

    it 'updates record' do
      user.age = 20
      user.save
      expect(user.age).to eq 20
      expect(User.find(1).age).to eq 20
    end
  end

end