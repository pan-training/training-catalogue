class EventunscrapedPolicy < ScrapedResourcePolicy

   def index?
       #@user && @user.has_role?(:admin) same as underneath it seems
       @user && @user.is_admin?
   end 

   def show?
       @user && @user.is_admin?
   end 
   
   def new?
       @user && @user.is_admin?
   end        
   
   #def check_exists?
   #    puts "can't do this underneath because user is nil when the scraper tries to access it, no idea why ... weird"
   #    puts @user
   #    #puts @user.has_role?(:admin)
   #    #puts @user.has_role?(:scraper_user)
   #    #@user && (@user.has_role?(:admin) || @user.has_role?(:scraper_user))
   #    #true
   #end 
   
   def create?
       @user && @user.is_admin?
   end 
   
   def destroy?
       @user && @user.is_admin?
   end 
        
end








