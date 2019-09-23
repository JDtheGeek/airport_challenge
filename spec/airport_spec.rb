require 'airport'

describe Airport do
subject(:airport) { described_class.new}

  describe '#planes' do
    it 'returns list of planes currently landed' do
      allow(airport).to receive(:safe_to_fly?).and_return(true)
      airport.update_forecast

      array = []
      5.times {
        plane = Plane.new
        airport.land(plane)
        array << plane
      }
      expect(airport.planes).to eq array
    end
  end
  
  describe "#land" do
    it "instructs plane to land at the airport" do
      allow(airport).to receive(:safe_to_fly?).and_return(true)
      airport.update_forecast
      plane_1 = Plane.new
      expect(airport.land(plane_1)).to eq "roger wilko"
    end
    it "prevents landing if airport full" do
      allow(airport).to receive(:safe_to_fly?).and_return(true)
      airport.update_forecast
      20.times { airport.land(Plane.new) }
      my_plane = Plane.new
      expect { airport.land(my_plane) }.to raise_error "At capacity"
    end
    it "prevents landing if weather is stormy" do
      plane_1 = Plane.new
      allow(airport).to receive(:safe_to_fly?).and_return(false)
      airport.update_forecast 
      expect { airport.land(plane_1) }.to raise_error "Permission denied due to weather"
    end
    it 'prevents landing if plane already landed' do
      allow(airport).to receive(:safe_to_fly?).and_return(true)
      airport.update_forecast
      my_plane = Plane.new
      airport.land(my_plane)
      expect { airport.land(my_plane) }.to raise_error 'Already landed!'
    end
  end

  describe "#take_off" do
    it "instructs a plane to take_off and returns confirmation" do
      allow(airport).to receive(:safe_to_fly?).and_return(true)
      airport.update_forecast
      plane_1 = Plane.new
      airport.land(plane_1)
      expect(airport.take_off(plane_1)).to eq "In the air"
    end

    it "it raises error if plane not at that airport" do
      allow(airport).to receive(:safe_to_fly?).and_return(true)
      airport.update_forecast
      heathrow = Airport.new
      plane_1 = Plane.new
      airport.land(plane_1)
      expect { heathrow.take_off(plane_1) }.to raise_error "No such plane"
    end
  end

  describe '#amend_capacity' do
    it 'allows the default capacity to be over-ridden' do
      airport.capacity = 10
      10.times { airport.land(Plane.new) }
      my_plane = Plane.new
      expect { airport.land(my_plane) }.to raise_error('At capacity')
    end
  end
end
