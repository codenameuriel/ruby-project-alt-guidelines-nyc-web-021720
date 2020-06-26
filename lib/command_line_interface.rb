require_relative '../lib/game.rb'
require_relative '../lib/team.rb'

class CommandLineInterface

  attr_accessor :favorite_team

  def welcome 
    puts "Welcome to League Manager!\n ".colorize(:green)
  end


  #this method will give user an option to pick their home and away team
  def create_game
  
    puts "Pick your home team".colorize(:red)
    home_team = gets.chomp.capitalize.strip
    team_name_search = Team.where('name LIKE ?', '%' + "#{home_team}" + '%').pluck(:name)[0]
    while !team_name_search do
    
      puts "Please enter a valid NBA team".colorize(:red)
      home_team = gets.chomp.capitalize.strip 
      team_name_search = Team.where('name LIKE ?', '%' + "#{home_team}" + '%').pluck(:name)[0]
    end

    puts "\nPick your away team".colorize(:red)
    away_team = gets.chomp.capitalize.strip
    team_name_search = Team.where('name LIKE ?', '%' + "#{away_team}" + '%').pluck(:name)[0]
    while !team_name_search do
    
      puts "Please enter a valid NBA team".colorize(:red)
      away_team = gets.chomp.capitalize.strip 
      team_name_search = Team.where('name LIKE ?', '%' + "#{away_team}" + '%').pluck(:name)[0]
    end
    

    home_team_id = Team.where('name LIKE ?', '%' + "#{home_team}" + '%').ids[0]
    away_team_id = Team.where('name LIKE ?', '%' + "#{away_team}" + '%').ids[0] 

    db_home_team = Team.where('name LIKE ?', '%' + "#{home_team}" + '%').pluck(:name)[0]
    db_away_team = Team.where('name LIKE ?', '%' + "#{away_team}" + '%').pluck(:name)[0]

   
    game = Game.create(home_team_id: home_team_id, away_team_id: away_team_id)

    puts "\nGreat! You scheduled the #{db_home_team} to play against the #{db_away_team}!".colorize(:yellow)
  end

  
  def end_app
    puts "\nThanks for using League Manager\n".colorize(:green)
  end


  def team_stadium_name(team)
    puts Team.where('name LIKE ?', '%' + "#{team}" + '%').pluck(:stadium_name)[0].colorize(:yellow)
  end


  def team_stadium_location(team)
    puts Team.where('name LIKE ?', '%' + "#{team}" + '%').pluck(:stadium_location)[0].colorize(:yellow)
  end


  def show_games
    Game.all.map do |game|
      puts "\tGame #{game.id} - the #{Team.find_by(id: game.home_team_id).name} vs the #{Team.find_by(id: game.away_team_id).name}".colorize(:yellow)
    end
  end


  def home_games(fav_team_object)
    list = fav_team_object[0]
    home_games = list.home_games
    name = list.name

    
    if home_games.length < 1
      puts "\tThe #{name} have not played as the home team yet".colorize(:yellow)
    end
    
   
    home_games.each do |game|
     puts "\tIn game #{game.id} - the #{Team.find_by(id: game.home_team_id).name} played against the #{Team.find_by(id: game.away_team_id).name} at the #{Team.find_by(id: game.home_team_id).stadium_name}".colorize(:yellow)
    end
  end


  def away_games(fav_team_object)
    list = fav_team_object[0]
    away_games = list.away_games
    name = list.name 

    if away_games.length < 1
      puts "\tThe #{name} have not played as the away team yet".colorize(:yellow)
    end
    
    
    away_games.each do |game|
     puts "\tIn game #{game.id} - the #{Team.find_by(id: game.away_team_id).name} played against the #{Team.find_by(id: game.home_team_id).name} at the #{Team.find_by(id: game.home_team_id).stadium_name}"
    end
  end



  def get_results
    last_game = Game.last
    home_team_id = Game.last.home_team_id
    away_team_id = Game.last.away_team_id

    home_score = rand(90..125)
    away_score = rand(90..125)


    if home_score == away_score
      home_score = rand(90..125)
    end

    if home_score < away_score 
      puts "\nThe #{Team.find_by(id: away_team_id).name} won the game!"
      puts "\tFinal score: the #{Team.find_by(id: home_team_id).name} #{home_score} - the #{Team.find_by(id: away_team_id).name} #{away_score}".colorize(:yellow)
    elsif home_score > away_score
      puts "\nThe #{Team.find_by(id: home_team_id).name} won the game!"
      puts "\tFinal score: the #{Team.find_by(id: home_team_id).name} #{home_score} - the #{Team.find_by(id: away_team_id).name} #{away_score}".colorize(:yellow)
    end
  end

  def change_fav_team
    
  end
 
end  


