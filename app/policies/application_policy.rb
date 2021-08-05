class ApplicationPolicy
  attr_reader :user, :record

  delegate :admin?, :simple?, :owner_of?, to: :user, allow_nil: true

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    !!user
  end

  def new?
    create?
  end

  def update?
    admin? || owner_of?(record)
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
