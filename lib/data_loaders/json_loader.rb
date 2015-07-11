class JsonLoader
  def initialize(file)
    @file = file
  end

  def parse
    content = File.open(@file).read
    fixtures = JSON.parse(content)
    fixtures.each do |fixture|
      yield fixture
    end     
  end
end