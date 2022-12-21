class ZenodomaterialPolicy < ScrapedResourcePolicy

  def create?
    (@user && !@user.role.blank? && !@user.has_role?(:basic_user) && !@user.profile.zenodotokenchoice.nil? && @user.profile.zenodotokenchoice && @session[:zenodo_access_token]) || (@user &&  !@user.role.blank? && !@user.has_role?(:basic_user) && !@user.profile.zenodotokenchoice.nil? && !@user.profile.zenodotokenchoice)
  end

  def new?
    create?
  end

  def update?
    managezenodomaterial?
  end

  def edit?
    update?
  end

  def newversionupdate?
    managezenodomaterial?
  end

  def newversionedit?
    newversionupdate?
  end

  #og manage
  def destroy?
    manage?
  end

  def newversionzenodo?
    managezenodomaterial?
  end
  
  def deletezenodofile?
    managezenodomaterial?
  end
  
  def listfiles?
    managezenodomaterial?
  end

  #we only want admins (maybe curators too?) to be able to delete/unscrape a scraped material
  def unscrape?
    @user.is_admin?
  end

  # special manage for zenodo materials
  # if using users zen account, only the owner of the zenodo material can interact
  # if using pan zen account, the owner of the zen mat and the admin can interact
  def managezenodomaterial?
    (@user &&  @user.is_owner?(@record) && !@user.profile.zenodotokenchoice.nil? && @user.profile.zenodotokenchoice && @session[:zenodo_access_token]) || (@user &&  @user.is_owner?(@record) && !@user.profile.zenodotokenchoice.nil? && !@user.profile.zenodotokenchoice) || (@user &&  @user.is_admin? && !@user.profile.zenodotokenchoice.nil? && !@user.profile.zenodotokenchoice)  
  end

end
