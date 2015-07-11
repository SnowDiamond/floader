class IniLoader
  def initialize(file)
    @file = file
  end

  def parse
    fixtures = IniFile.load(@file)
    fixtures.each_section do |section|
      yield fixtures[section]
    end
  end
end
