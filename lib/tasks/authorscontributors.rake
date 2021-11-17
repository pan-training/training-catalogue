namespace :dice do
  desc "This task migrates the old data to the new models"
  task authorscontributors: :environment do
    for mat in Material.all
      mat.authors.each do |woo|
          paranthesispresent = 0
          woo.split("").each do |letter|
              if letter=="("
                  paranthesispresent=1
              end
          end 
          puts woo
          puts paranthesispresent
          
          if paranthesispresent==0

          length = woo.split(" ").length()
          firstname = ""
          lastname  = ""
          i=0
          while i<length-1
              if i!=length-2
              firstname=firstname+woo.split(" ")[i]+ " "
              else
              firstname=firstname+woo.split(" ")[i]
              end
              i=i+1
          end
          lastname = woo.split(" ")[length-1]
          puts woo
          puts "firstname"
          puts firstname
          puts "lastname"
          puts lastname
          mat.update_attributes(bauthors_attributes: [{firstname:firstname,lastname:lastname}])
         else
     
          waa = woo.split("(")[0].strip()       
          length = waa.split(" ").length()
          firstname = ""
          lastname  = ""
          i=0
          while i<length-1
              if i!=length-2
              firstname=firstname+waa.split(" ")[i]+ " "
              else
              firstname=firstname+waa.split(" ")[i]
              end
              i=i+1
          end
          lastname = waa.split(" ")[length-1]
          puts waa
          puts "firstname"
          puts firstname
          puts "lastname"
          puts lastname
          mat.update_attributes(bauthors_attributes: [{firstname:firstname,lastname:lastname}])
                   
         end
      end
    end
  end
end
