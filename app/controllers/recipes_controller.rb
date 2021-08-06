class RecipesController < ApplicationController
  COUNT_RECIPES_ON_PAGE = 5

  # it is not neccessary as pundit will check, but will remove unneccessary 500 errors with current_user as nil
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :find_recipe, only: %i[edit update destroy]

  def index
    @recipes = recipes.active.search(params[:query]).page(params[:page]).per(COUNT_RECIPES_ON_PAGE)
  end

  def recent
    @recipes = recipes.active.recent(params[:last_id].to_i)
  end

  def my
    @recipes = recipes.of_owner(current_user).page(params[:page]).per(COUNT_RECIPES_ON_PAGE)
  end

  def edit; end

  def new
    @recipe = current_user.recipes.new

    authorize @recipe
  end

  def create
    @recipe = current_user.recipes.new
    @recipe.assign_attributes permitted_params

    authorize @recipe

    redirect_to({ action: :my }, notice: t('.notice')) and return if @recipe.save

    flash[:error] = t('.error')
    render :new
  end

  def update
    redirect_to({ action: :my }, notice: t('.notice')) and return if @recipe.update(permitted_params)

    flash[:error] = t('.error')
    render :edit
  end

  def destroy
    @recipe.destroy

    redirect_to({ action: :my }, notice: t('.notice'))
  end

  protected

  def permitted_params
    params.require(:recipe).permit(policy(@recipe).permitted_attributes)
  end

  def find_recipe
    @recipe = Recipe.find(params[:id])

    authorize @recipe
  end

  def recipes
    policy_scope(Recipe).ordered.with_rich_text_content_and_embeds
  end
end
