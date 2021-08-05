class RecipePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def permitted_attributes
    return [:title, :content] if admin? || owner_of?(record)

    []
  end
end
