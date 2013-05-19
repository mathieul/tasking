require 'spec_helper'

describe VelocityService do
  context "#index" do
    it "returns the index of the story which causes the sum of points to exceed the velocity" do
      velocity = VelocityService.new(8, [
        double(points: 5), double(points: 2), # => 7
        double(points: 3), double(points: 1)  # => 11
      ])
      expect(velocity.index).to eq(2)
      expect(velocity.sum).to eq(7)
    end

    it "returns nil if there are no stories" do
      velocity = VelocityService.new(3, [])
      expect(velocity.index).to be_nil
      expect(velocity.sum).to eq(0)
    end

    it "returns 0 if the velocity is less than the first story points" do
      velocity = VelocityService.new(3, [double(points: 5)])
      expect(velocity.index).to eq(0)
      expect(velocity.sum).to eq(0)
    end

    it "returns the index of last story + 1 if velocity equals the sum of all points" do
      velocity = VelocityService.new(5, [double(points: 3), double(points: 2)])
      expect(velocity.index).to eq(2)
      expect(velocity.sum).to eq(5)
    end
  end
end
