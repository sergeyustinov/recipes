class RecipesController < ApplicationController
  COUNT_RECIPES_ON_PAGE = 5

  before_action :find_recipe, only: %i[edit update destroy]

  def index
    @recipes = recipes.search(params[:query]).page(params[:page]).per(COUNT_RECIPES_ON_PAGE)
  end

  def recent
    @recipes = recipes.recent(params[:last_id])
  end

  def my
    @recipes = recipes.of_owner(current_user).page(params[:page]).per(COUNT_RECIPES_ON_PAGE)
  end

  def edit; end

  def new
    @recipe = Recipe.new

    authorize @recipe
  end

  def create
    @recipe = current_user.recipes.new
    @recipe.assign_attributes permitted_params

    authorize @recipe

    if @recipe.save
      redirect_to({ action: :my }, notice: t('.notice'))
    else
      flash[:error] = t('.error')
      render :new
    end
  end

  def update
    if @recipe.update permitted_params
      redirect_to({ action: :my }, notice: t('.notice'))
    else
      flash[:error] = t('.error')
      render :edit
    end
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
