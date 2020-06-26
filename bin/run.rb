require_relative '../config/environment'

cli = CommandLineInterface.new
prompt = TTY::Prompt.new 

# puts welcome message 
cli.welcome

# collectes favorite team from prompt question 
fav_team = prompt.ask("What’s your favorite NBA team?".capitalize)
# checks to see if input was an a valid NBA team
team_name_search = Team.where('name LIKE ?', '%' + "#{fav_team}" + '%').pluck(:name)[0]
# if not then will loop until a valid NBA is input
while !team_name_search do

  puts "Please enter a valid NBA team".colorize(:red)
  fav_team = prompt.ask("What’s your favorite NBA team?".capitalize.colorize(:cyan))
  team_name_search = Team.where('name LIKE ?', '%' + "#{fav_team}" + '%').pluck(:name)[0]
  
end



choices = %w(Yes No)
stadium_name = prompt.multi_select("\nDo you want to know your favorite teams stadium name?", choices)
if stadium_name.pop == choices[0]
  cli.team_stadium_name(fav_team)
else
  puts "Okay!".colorize(:yellow)
end
 

location = prompt.multi_select("\nDo you want to know your favorite teams stadium location?", choices)
if location.pop == choices[0]
  cli.team_stadium_location(fav_team)
else
  puts "Okay!".colorize(:yellow)
end


create_game_question = prompt.multi_select("\nDo you want to create an NBA game?", choices)
if create_game_question.pop == choices[0]
  cli.create_game
  game_results = prompt.multi_select("\nDo you want to know the score?", choices)
  if game_results.pop == choices[0]
    cli.get_results
  end
else
  puts "Okay!".colorize(:yellow) 
end


show_games_question = prompt.multi_select("\nDo you want to see all the played games", choices)
if show_games_question.pop == choices[0]
  puts "\nHere are all the played games!"
  cli.show_games
else
  puts "Okay!".colorize(:yellow)
end


favorite_team_games = prompt.multi_select("\nDo you want to see all the games where your favorite team played at home?", choices)
if favorite_team_games.pop == choices[0]
  fav_team_object = Team.all.select do |team|
    team.name == Team.where('name LIKE ?', '%' + "#{fav_team}" + '%').pluck(:name).pop
  end
  puts "\nHere are the #{Team.where('name LIKE ?', '%' + "#{fav_team}" + '%').pluck(:name).pop} home games:"
  cli.home_games(fav_team_object)
else
  puts "Okay!".colorize(:yellow)
end


favorite_team_games_away = prompt.multi_select("\nDo you want to see all the games where your favorite team played away?", choices)
if favorite_team_games_away.pop == choices[0]
  fav_team_object = Team.all.select do |team|
    team.name == Team.where('name LIKE ?', '%' + "#{fav_team}" + '%').pluck(:name).pop
  end
  puts "\nHere are the #{Team.where('name LIKE ?', '%' + "#{fav_team}" + '%').pluck(:name).pop} away games:"
  cli.away_games(fav_team_object)
else
  puts "Okay!".colorize(:yellow)
end

cli.end_app





