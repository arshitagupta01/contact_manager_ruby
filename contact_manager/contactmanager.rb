require 'json'

FILE_NAME = "contacts.json"

def load_contacts
  return {} unless File.exist?(FILE_NAME) && !File.zero?(FILE_NAME)

  JSON.parse(File.read(FILE_NAME))
rescue JSON::ParserError
  {}
end

def save_contacts(contacts)
  File.write(FILE_NAME, JSON.pretty_generate(contacts))
end

def add_contact(contacts, phone, name, email)
  if contacts.key?(phone)
    puts "Error: Contact already exists!"
    return
  end

  contacts[phone] = {
    "name" => name,
    "email" => email,
    "search_key" => name.downcase
  }
  save_contacts(contacts)
  puts "Contact added successfully!"
end

def delete_contact(contacts, phone)
  if contacts.delete(phone)
    save_contacts(contacts)
    puts "Contact deleted successfully!"
  else
    puts "Contact not found."
  end
end

def edit_contact(contacts, phone, new_name, new_email)
  unless contacts.key?(phone)
    puts "Contact not found."
    return
  end

  contacts[phone]["name"] = new_name unless new_name.strip.empty?
  contacts[phone]["email"] = new_email unless new_email.strip.empty?
  contacts[phone]["search_key"] = new_name.downcase unless new_name.strip.empty?

  save_contacts(contacts)
  puts "Contact updated successfully!"
end

def search_contacts(contacts, query)
  query = query.downcase
  results = contacts.select { |phone, details| details["search_key"].include?(query) || phone.include?(query) }

  if results.empty?
    puts "No contacts found."
  else
    puts "Matching Contacts:"
    results.each { |phone, details| puts "#{details['name']} - #{phone}, #{details['email']}" }
  end
end

contacts = load_contacts

loop do
  puts " Contact Manager:"
  puts "1. Add Contact"
  puts "2. Delete Contact"
  puts "3. Edit Contact"
  puts "4. Search Contact"
  print "Enter your choice: "

  choice = gets.chomp.to_i

  case choice
  when 1
    print "Enter phone number: "
    phone = gets.chomp
    print "Enter name: "
    name = gets.chomp
    print "Enter email: "
    email = gets.chomp
    add_contact(contacts, phone, name, email)

  when 2
    print "Enter phone number to delete: "
    phone = gets.chomp
    delete_contact(contacts, phone)

  when 3
    print "Enter phone number to edit: "
    phone = gets.chomp
    print "Enter new name (leave blank to keep existing): "
    new_name = gets.chomp
    print "Enter new email (leave blank to keep existing): "
    new_email = gets.chomp
    edit_contact(contacts, phone, new_name, new_email)

  when 4
    print "Enter name or phone number to search: "
    query = gets.chomp
    search_contacts(contacts, query)

  else
    puts "Invalid choice. Please try again."
  end
end
