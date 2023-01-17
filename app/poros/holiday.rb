
class Holiday
  attr_accessor :date,
              :name

  def initialize(data)
    @date = data[:date]
    @name = data[:name]
  end
end