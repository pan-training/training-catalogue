class CreateZenodomaterials < ActiveRecord::Migration[5.2]
  def change
    create_table :zenodomaterials do |t|

    t.text "title"
    t.string "url"    
    t.string "short_description"
    t.string "doi"
    
    t.date "remote_updated_date"
    t.date "remote_created_date"
    
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    
    t.string "licence", default: "notspecified"
        
    t.integer "content_provider_id"
    
    t.string "slug"
    t.integer "user_id"
    
    t.date "last_scraped"
    t.boolean "scraper_record", default: false
    
    t.text "keyword"
    t.string "resource_type", default: [], array: true
    
    t.string "keywords", default: [], array: true
    
    t.string "language", default: "English"
    
    t.index ["content_provider_id"], name: "index_zenodomaterials_on_content_provider_id"
    t.index ["slug"], name: "index_zenodomaterials_on_slug", unique: true
    t.index ["user_id"], name: "index_zenodomaterials_on_user_id"

    #these are the t.timestamps I think
    #t.datetime "created_at", null: false
    #t.datetime "updated_at", null: false
      
    t.timestamps    
    end
  end
end
