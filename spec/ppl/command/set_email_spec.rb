
describe Ppl::Command::SetEmail do

  before(:each) do
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @command = Ppl::Command::SetEmail.new
    @storage = double(Ppl::Adapter::Storage)

    @command.storage = @storage
    @contact.id = "jim"
  end

  describe "#name" do
    it "should be 'email'" do
      @command.name.should eq "email"
    end
  end

  describe "#execute" do

    it "should change the contact's email address" do

      @storage.should_receive(:require_contact).and_return(@contact)

      @storage.should_receive(:save_contact) do |contact|
        contact.email_address.should eq "jim@example.org"
      end

      @input.arguments = ["jim", "jim@example.org"]
      @command.execute(@input, @output)
    end

  end

end
