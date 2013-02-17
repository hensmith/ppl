
class Ppl::Format::AddressBook::Nicknames < Ppl::Format::AddressBook

  attr_writer :table

  def initialize
    @table = Ppl::Format::Table.new([:id, :nicknames])
  end

  def process(address_book)
    address_book.contacts.each { |contact| add_row(contact) }
    @table.to_s
  end


  private

  def add_row(contact)
    @table.add_row({
      :id        => sprintf("%s:", contact.id),
      :nicknames => contact.nicknames.join(", "),
    })
  end


end
