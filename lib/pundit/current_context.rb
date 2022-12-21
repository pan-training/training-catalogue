module Pundit
  class CurrentContext
    attr_reader :user, :request, :session

    def initialize(user, request, session)
      @user = user
      @request = request
      @session = session
    end
  end
end
