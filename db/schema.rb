# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 15) do

  create_table "contacts", :force => true do |t|
    t.column "person_id", :integer
    t.column "owner_id", :integer
  end

  create_table "events", :force => true do |t|
    t.column "person_id", :integer
    t.column "name", :string
    t.column "description", :text
    t.column "when", :datetime
    t.column "created_at", :datetime
    t.column "open", :boolean, :default => false
    t.column "admins", :text
  end

  create_table "families", :force => true do |t|
    t.column "legacy_id", :integer
    t.column "name", :string
    t.column "last_name", :string
    t.column "suffix", :string, :limit => 25
    t.column "address1", :string
    t.column "address2", :string
    t.column "city", :string
    t.column "state", :string, :limit => 2
    t.column "zip", :string, :limit => 10
    t.column "home_phone", :integer, :limit => 20
    t.column "email", :string
    t.column "latitude", :float
    t.column "longitude", :float
    t.column "mail_group", :string, :limit => 1
    t.column "security_token", :string, :limit => 25
    t.column "share_address", :boolean, :default => true
    t.column "share_mobile_phone", :boolean, :default => false
    t.column "share_work_phone", :boolean, :default => false
    t.column "share_fax", :boolean, :default => false
    t.column "share_email", :boolean, :default => false
    t.column "share_birthday", :boolean, :default => true
    t.column "share_anniversary", :boolean, :default => true
  end

  create_table "groups", :force => true do |t|
    t.column "name", :string, :limit => 100
    t.column "description", :text
    t.column "meets", :string, :limit => 100
    t.column "location", :string, :limit => 100
    t.column "directions", :text
    t.column "notes", :text
    t.column "category", :string, :limit => 50
    t.column "creator_id", :integer
    t.column "private", :boolean, :default => false
    t.column "address", :string
    t.column "members_send", :boolean, :default => true
    t.column "link_code", :string, :limit => 10
    t.column "subscription", :boolean, :default => false
  end

  create_table "memberships", :force => true do |t|
    t.column "group_id", :integer
    t.column "person_id", :integer
    t.column "admin", :boolean, :default => false
    t.column "get_email", :boolean, :default => true
    t.column "share_address", :boolean
    t.column "share_mobile_phone", :boolean
    t.column "share_work_phone", :boolean
    t.column "share_fax", :boolean
    t.column "share_email", :boolean
    t.column "share_birthday", :boolean
    t.column "share_anniversary", :boolean
  end

  create_table "messages", :force => true do |t|
    t.column "group_id", :integer
    t.column "person_id", :integer
    t.column "to_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "parent_id", :integer
    t.column "subject", :string
    t.column "body", :text
    t.column "share_email", :boolean, :default => false
    t.column "wall_id", :integer
  end

  create_table "ministries", :force => true do |t|
    t.column "admin_id", :integer
    t.column "name", :string, :limit => 100
    t.column "description", :text
  end

  create_table "people", :force => true do |t|
    t.column "legacy_id", :integer
    t.column "family_id", :integer
    t.column "sequence", :integer
    t.column "gender", :string, :limit => 6
    t.column "first_name", :string
    t.column "last_name", :string
    t.column "suffix", :string, :limit => 25
    t.column "mobile_phone", :integer, :limit => 20
    t.column "work_phone", :integer, :limit => 20
    t.column "fax", :integer, :limit => 20
    t.column "birthday", :datetime
    t.column "email", :string
    t.column "email_changed", :boolean, :default => false
    t.column "website", :string
    t.column "classes", :string
    t.column "shepherd", :string
    t.column "mail_group", :string, :limit => 1
    t.column "encrypted_password", :string, :limit => 100
    t.column "service_name", :string, :limit => 100
    t.column "service_description", :text
    t.column "service_phone", :integer, :limit => 20
    t.column "service_email", :string
    t.column "service_website", :string
    t.column "activities", :text
    t.column "interests", :text
    t.column "music", :text
    t.column "tv_shows", :text
    t.column "movies", :text
    t.column "books", :text
    t.column "quotes", :text
    t.column "about", :text
    t.column "testimony", :text
    t.column "share_mobile_phone", :boolean
    t.column "share_work_phone", :boolean
    t.column "share_fax", :boolean
    t.column "share_email", :boolean
    t.column "share_birthday", :boolean
    t.column "anniversary", :datetime
  end

  create_table "pictures", :force => true do |t|
    t.column "event_id", :integer
    t.column "person_id", :integer
    t.column "created_at", :datetime
    t.column "cover", :boolean, :default => false
  end

  create_table "publications", :force => true do |t|
    t.column "name", :string
    t.column "description", :text
    t.column "created_at", :datetime
    t.column "file", :string
  end

  create_table "sessions", :force => true do |t|
    t.column "session_id", :string
    t.column "data", :text
    t.column "updated_at", :datetime
  end

  add_index "sessions", ["session_id"], :name => "sessions_session_id_index"

  create_table "verifications", :force => true do |t|
    t.column "email", :string
    t.column "mobile_phone", :integer, :limit => 20
    t.column "code", :integer
    t.column "verified", :boolean
    t.column "created_at", :datetime
  end

  create_table "workers", :force => true do |t|
    t.column "ministry_id", :integer
    t.column "person_id", :integer
    t.column "start", :datetime
    t.column "end", :datetime
    t.column "remind_on", :datetime
    t.column "reminded", :boolean, :default => false
  end

end
