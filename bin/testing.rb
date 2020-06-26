require_relative '../config/environment'

prompt = TTY::Prompt.new(track_history: false) 
cli = CommandLineInterface.new


puts "\nWelcome to League Manager!".colorize(:green)
press = prompt.keypress("\nPress enter to continue!", keys: [:return])

while press == "\r" 
  main_menu = prompt.select("Select an option".colorize(:cyan)) do |menu|
    menu.choice 'Favorite NBA team'
    menu.choice 'Create a new game'
    menu.choice 'See list of played games'
    menu.choice 'Change your favorite NBA team'
    menu.choice 'Exit'
  end
  case main_menu
  when 'Favorite NBA team'
    fav_team_menu = prompt.select("Select an option") do |menu|
      menu.choice 'Select favorite team'
      menu.choice 'Get list of favorite team played home games'
      menu.choice 'Get list of favorite team played away games'
      menu.choice 'Go back'
    end
    case fav_team_menu
    when 'Select favorite team'
      fav_team = prompt.ask("What’s your favorite NBA team?".capitalize)
      team_name_search = Team.where('name LIKE ?', '%' + "#{fav_team}" + '%').pluck(:name)[0]

      while !team_name_search do
        fav_team = prompt.ask("Please enter a valid NBA team:".capitalize)
        team_name_search = Team.where('name LIKE ?', '%' + "#{fav_team}" + '%').pluck(:name)[0]
      end
      puts "\tAwesome! You picked the #{Team.where('name LIKE ?', '%' + "#{fav_team}" + '%').pluck(:name)[0]}"

      select_fav_team_menu = prompt.select("Select an option") do |menu|
        menu.choice 'See played home games for favorite team'
        menu.choice 'See played away games for favorite team'
        menu.choice 'Go back'
      end

      case select_fav_team_menu
      when 'See played home games for favorite team'
        fav_team_object = Team.all.select do |team|
          team.name == Team.where('name LIKE ?', '%' + "#{fav_team}" + '%').pluck(:name)[0]
        end
        puts "\nHere are the #{Team.where('name LIKE ?', '%' + "#{fav_team}" + '%').pluck(:name)[0]} home games:"
        cli.home_games(fav_team_object)
        go_back = prompt.select("Select an option") do |menu|
          menu.choice 'Go back'
        end
        case go_back
        when 'Go back'
          select_fav_team_menu = prompt.select("Select an option") do |menu|
            menu.choice 'See played home games for favorite team'
            menu.choice 'See played away games for favorite team'
            menu.choice 'Go back'
          end
          case select_fav_team_menu
          when 'See played away games for favorite team'
            fav_team_object = Team.all.select do |team|
              team.name == Team.where('name LIKE ?', '%' + "#{fav_team}" + '%').pluck(:name)[0]
            end
            puts "\nHere are the #{Team.where('name LIKE ?', '%' + "#{fav_team}" + '%').pluck(:name)[0]} home games:"
            cli.away_games(fav_team_object)
            go_back = prompt.select("Select an option") do |menu|
              menu.choice 'Go back'
            end
          end
        end

      when 'See played away games for favorite team'
        
      

      when 'Go back'
      end
    
    
    when 'Get list of favorite team played home games'
      if !fav_team 
        puts "You have not selected a favorite NBA yet!".colorize(:red)
        go_back = prompt.select("Select an option") do |menu|
          menu.choice 'Go back'
        end
      else 
        fav_team_object = Team.all.select do |team|
          team.name == Team.where('name LIKE ?', '%' + "#{fav_team}" + '%').pluck(:name)[0]
        end
        puts "\nHere are the #{Team.where('name LIKE ?', '%' + "#{fav_team}" + '%').pluck(:name)[0]} home games:"
        cli.home_games(fav_team_object)
        go_back = prompt.select("Select an option") do |menu|
          menu.choice 'Go back'
        end
      end
    

    when 'Get list of favorite team played away games'
      if !fav_team 
        puts "You have not selected a favorite NBA yet!".colorize(:red)
        go_back = prompt.select("Select an option") do |menu|
          menu.choice 'Go back'
        end
      else
        fav_team_object = Team.all.select do |team|
          team.name == Team.where('name LIKE ?', '%' + "#{fav_team}" + '%').pluck(:name)[0]
        end
        puts "\nHere are the #{Team.where('name LIKE ?', '%' + "#{fav_team}" + '%').pluck(:name)[0]} away games:"
        cli.away_games(fav_team_object) 
      end
    
    when 'Go back'
    end  


  when 'Create a new game'
    cli.create_game
    create_game = prompt.select("Select an option") do |menu|
      menu.choice 'See results of game'
      menu.choice 'Go back'
    end
    case create_game
    when 'See results of game'
      cli.get_results
      go_back = prompt.select("Select an option") do |menu|
        menu.choice 'Go back'
      end
    end

  when 'See list of played games'
    cli.show_games
    go_back = prompt.select("Select an option") do |menu|
      menu.choice 'Go back'
    end

  when 'Change your favorite NBA team'
    if !fav_team
      puts "You have not selected a favorite NBA team. Go back to select" 
      go_back = prompt.select("Select an option") do |menu|
        menu.choice 'Go back'
      end
    else
      change_fav_team = prompt.ask("Pick another NBA team".capitalize)
      team_name_search = Team.where('name LIKE ?', '%' + "#{change_fav_team}" + '%').pluck(:name)[0]

      while !team_name_search do
        puts "Please enter a valid NBA team"
        change_fav_team = prompt.ask("Pick another NBA team".capitalize)
        team_name_search = Team.where('name LIKE ?', '%' + "#{change_fav_team}" + '%').pluck(:name)[0]
      end
      puts "Awesome! You changed your team to the #{Team.where('name LIKE ?', '%' + "#{change_fav_team}" + '%').pluck(:name)[0]}"
      go_back = prompt.select("Select an option") do |menu|
        menu.choice 'Go back'
      end
    end

  when 'Exit'
    press = "exit"
  end
  
end