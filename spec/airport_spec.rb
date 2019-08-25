require 'airport'

describe Airport do
  subject {
    weather = double :weather
    allow(weather).to receive(:weather_condition).and_return(:sunny)
    Airport.new(weather)
  }

  it 'has a default capacity' do
    expect(subject.capacity).to eq Airport::DEFAULT_CAPACITY
  end

  describe 'initialization' do
    it 'has a default capacity' do
      described_class::DEFAULT_CAPACITY.times do
        subject.land double(:plane)
      end
      expect { subject.land double(:plane) }.to raise_error 'Airport full'
    end
  end

  describe '#take_off' do
    it 'raises an error when plane not in the airport' do
      expect { subject.take_off double(:plane) }.to raise_error 'Plane not in this airport'
    end

    # it 'confirms after a plane takes off' do
    #   plane = double(:plane)
    #   subject.land(plane)
    #   allow(plane).to receive_message_chain(:taken_off, flying?: true)
    #   subject.take_off(plane) 
    # end

    it 'prevents plane from taking off in stormy weather' do
      weather = double(:weather)
      airport = Airport.new(weather)
      plane = double(:plane)

      allow(weather).to receive(:weather_condition).and_return(:sunny)
      airport.land plane
      
      allow(weather).to receive(:weather_condition).and_return(:stormy)
      expect { airport.take_off plane }.to raise_error 'Cannot take off in stormy weather'
    end
  end

  describe '#land' do
    it 'raises an error when airport is full' do
      subject.capacity.times do
        subject.land double(:plane)
      end
      expect { subject.land double(:plane) }.to raise_error 'Airport full'
    end

    it 'raises an error when plane already landed' do
      plane = double(:plane)
      subject.land plane
      expect { subject.land plane }.to raise_error 'Plane already landed'
    end

    it 'prevents a plane from landing in stormy weather' do
      weather = double(:weather)
      airport = Airport.new(weather)

      allow(weather).to receive(:weather_condition).and_return(:stormy)
      expect { airport.land double(:plane) }.to raise_error 'Cannot land in stormy weather'
    end

  end

end
