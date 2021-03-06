describe Ppl::Service::PostalAddress do

  before(:each) do
    @service = Ppl::Service::PostalAddress.new
    @contact = Ppl::Entity::Contact.new
    @address = Ppl::Entity::PostalAddress.new
  end

  describe "#add" do

    before(:each) do
      @service.add(@contact, "home", {
        :country     => "United Kingdom",
        :locality    => "Bristol",
        :street      => "1 Broad Mead",
        :po_box      => "550011",
        :postal_code => "BS1 1SB",
        :region      => "South West",
      })
      @address = @contact.postal_addresses.first
    end

    it "adds one postal address to the contact" do
      expect(@contact.postal_addresses.length).to eq 1
    end

    it "sets the country of the new address" do
      expect(@address.country).to eq "United Kingdom"
    end
    it "sets the locality of the new address" do
      expect(@address.locality).to eq "Bristol"
    end
    it "sets the street of the new address" do
      expect(@address.street).to eq "1 Broad Mead"
    end
    it "sets the PO box of the new address" do
      expect(@address.po_box).to eq "550011"
    end
    it "sets the postal code of the new address" do
      expect(@address.postal_code).to eq "BS1 1SB"
    end
    it "sets the region of the new address" do
      expect(@address.region).to eq "South West"
    end
  end


  describe "#update" do

    before(:each) do
      @address.id = "home"
      @contact.postal_addresses << @address
      @service.update(@contact, "home", {
        :country     => "United Kingdom",
        :locality    => "Bristol",
        :street      => "1 Broad Mead",
        :po_box      => "550011",
        :postal_code => "BS1 1SB",
        :region      => "South West",
      })
    end

    it "doesn't change the number of addresses owned by the contact" do
      expect(@contact.postal_addresses.length).to eq 1
    end
    it "sets the country of the new address" do
      expect(@address.country).to eq "United Kingdom"
    end
    it "sets the locality of the new address" do
      expect(@address.locality).to eq "Bristol"
    end
    it "sets the street of the new address" do
      expect(@address.street).to eq "1 Broad Mead"
    end
    it "sets the PO box of the new address" do
      expect(@address.po_box).to eq "550011"
    end
    it "sets the postal code of the new address" do
      expect(@address.postal_code).to eq "BS1 1SB"
    end
    it "sets the region of the new address" do
      expect(@address.region).to eq "South West"
    end
  end


  describe "#update" do

    before(:each) do
      @address.id = "home"
      @contact.postal_addresses << @address
    end

    it "allows addresses to be moved" do
      expect(@service).to receive(:move)
      @service.update(@contact, "home", {:new_id => "work"})
    end

    it "sets addresses as preferred" do
      second_address = Ppl::Entity::PostalAddress.new
      second_address.id = "other"
      second_address.preferred = true
      @contact.postal_addresses << second_address
      @service.update(@contact, "home", {:preferred => true})
      expect(@address.preferred).to eq true
      expect(second_address.preferred).to eq false
    end

    it "sets addresses as not preferred" do
      @address.preferred = true
      @service.update(@contact, "home", {:preferred => false})
      expect(@address.preferred).to eq false
    end

  end

  describe "#move" do
    before(:each) do
      @address.id = "home"
      @contact.postal_addresses << @address
      other_address = Ppl::Entity::PostalAddress.new
      other_address.id = "other"
      @contact.postal_addresses << other_address
    end
    it "raises an error if the new ID is already in use" do
      expect{@service.move(@contact, "home", "other")}.to raise_error
    end
    it "moves the address to the new ID" do
      @service.move(@contact, "home", "available")
      expect(@address.id).to eq "available"
    end
  end

  describe "#remove" do
    before(:each) do
      @address.id = "home"
      @contact.postal_addresses << @address
      @service.remove(@contact, "home")
    end

    it "removes the specified address" do
      expect(@contact.postal_addresses.length).to eq 0
    end

    it "raises an error if there is no such address" do
      expect{@service.remove(@contact, "home")}.to raise_error(Ppl::Error::PostalAddressNotFound)
    end
  end

end

