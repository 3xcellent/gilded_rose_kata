class QualityUpdater
  attr_reader :item
  def initialize(item)
    @item = item
  end

  def update
    case item.name
    when 'Aged Brie'
      AgedBrie.new(item).update
    when 'Sulfuras, Hand of Ragnaros'
      Sulfuras.new(item).update
    when 'Backstage passes to a TAFKAL80ETC concert'
      BackstagePass.new(item).update
    when 'Conjured Mana Cake'
      ConjuredManaCake.new(item).update
    else
      NormalItem.new(item).update
    end
  end
  class NormalItem
    attr_reader :item
    MAX = 50
    def initialize(item)
      @item = item
    end

    def update
      item.tap do |i|
        item.quality = [0, new_quality].max
        item.sell_in -= 1
      end
    end

    def change_in_quality
      item.sell_in > 0 ? -1 : -2
    end

    def new_quality
      [MAX, item.quality + change_in_quality].min
    end
  end
  class AgedBrie < NormalItem
    def change_in_quality
      item.sell_in > 0 ? 1 : 2
    end
  end
  class Sulfuras < NormalItem
    def update
      item
    end
  end
  class BackstagePass < NormalItem
    MAX = 50
    def change_in_quality
      if item.sell_in >= 11
        1
      elsif (6..10).include? item.sell_in
        2
      elsif (1..5).include? item.sell_in
        3
      else
        0 - item.quality
      end
    end
  end
  class ConjuredManaCake < NormalItem
    def change_in_quality
      if item.sell_in > 0
        -2
      else
        -4
      end
    end
  end
end

def update_quality(items)
  items.each do |item|
    item = QualityUpdater.new(item).update
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

