class PackageZenodomaterial < ApplicationRecord
  belongs_to :zenodomaterial
  belongs_to :package

  include PublicActivity::Common

  self.primary_key = 'id'

  after_save :log_activity

  def log_activity
    self.package.create_activity(:add_zenodomaterial, owner: User.current_user,
                                 parameters: { zenodomaterial_id: self.zenodomaterial_id, zenodomaterial_title: self.zenodomaterial.title })
    self.zenodomaterial.create_activity(:add_to_package, owner: User.current_user,
                                  parameters: { package_id: self.package_id, package_title: self.package.title })
  end
end
