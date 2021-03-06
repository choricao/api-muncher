require 'httparty'

class EdamamApiWrapper
  URL = "https://api.edamam.com/search"
  ID = ENV["EDAMAM_ID"]
  KEYS = ENV["EDAMAM_KEYS"]
  # @recipe_list = []

  def self.list_recipes(term, page_num)
    start_from = (page_num.to_i - 1) * 10
    response = HTTParty.get("#{URL}?q=#{term}&app_id=#{ID}&app_key=#{KEYS}&from=#{start_from}")

    if response["hits"]
      recipe_list = []
      response["hits"].each do |hit|
        recipe_list << Recipe.new(
          hit["recipe"]["uri"],
          hit["recipe"]["label"],
          hit["recipe"]["image"],
          hit["recipe"]["source"],
          hit["recipe"]["url"],
          hit["recipe"]["ingredientLines"],
          hit["recipe"]["dietLabels"]
        )
      end
    else
      return []
    end

    return recipe_list
  end

  def self.find_recipe(recipe_id)
    # @recipe_list.each do |recipe|
    #   if recipe.id == recipe_id
    #     return recipe
    #   end
    # end
    response = HTTParty.get("#{URL}?r=http%3A%2F%2Fwww.edamam.com%2Fontologies%2Fedamam.owl%23recipe_#{recipe_id}&app_id=#{ID}&app_key=#{KEYS}")
    if response[0]
      recipe = Recipe.new(
        response[0]["uri"],
        response[0]["label"],
        response[0]["image"],
        response[0]["source"],
        response[0]["url"],
        response[0]["ingredientLines"],
        response[0]["dietLabels"]
      )
      return recipe
    else
      return nil
    end
  end
end
