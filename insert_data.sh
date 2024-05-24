#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

tail -n +2 "games.csv" | while IFS=, read -r year round winner opponent winner_goals opponent_goals; do
    # Insert or get the winner team_id
    # winner_id=$($PSQL "SELECT team_id from teams where name='$winner'")
    # if [[ -z $winner_id ]]
    # then 
    #   echo $($PSQL "INSERT INTO teams (name) VALUES ('$winner')")
    #   winner_id=$($PSQL "SELECT team_id from teams where name='$winner'")
    # fi
    winner_id=$(echo $($PSQL "INSERT INTO teams (name) VALUES ('$winner') ON CONFLICT (name) DO UPDATE SET name=EXCLUDED.name RETURNING team_id;") | awk '{print $1}')
    # echo $winner_id
    # Insert or get the opponent team_id
    # opponent_id=$($PSQL "SELECT team_id from teams where name='$opponent'")
    # if [[ -z $opponent_id ]]
    # then 
    #   echo $($PSQL "INSERT INTO teams (name) VALUES ('$opponent')")
    #   opponent_id=$($PSQL "SELECT team_id from teams where name='$opponent'")
    # fi
    opponent_id=$(echo $($PSQL "INSERT INTO teams (name) VALUES ('$opponent') ON CONFLICT (name) DO UPDATE SET name=EXCLUDED.name RETURNING team_id;") | awk '{print $1}')
    # echo $opponent_id
    # # Insert the game record
    echo $($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)")
done