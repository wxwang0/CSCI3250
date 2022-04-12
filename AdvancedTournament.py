from base_version.Team import Team
from base_version.Tournament import Tournament
from .AdvancedFighter import AdvancedFighter
import advanced_version.AdvancedFighter as AdvancedFighterFile


class AdvancedTournament(Tournament):
    def __init__(self):
        super(AdvancedTournament, self).__init__()
        self.team1 = None
        self.team2 = None
        self.round_cnt = 1
        self.defeat_record = []

    def update_fighter_properties_and_award_coins(self, fighter, flag_defeat=False, flag_rest=False):
        if flag_rest:
            AdvancedFighterFile.coins_to_obtain /= 2
            AdvancedFighterFile.coins_to_obtain = int(AdvancedFighterFile.coins_to_obtain)
            AdvancedFighterFile.delta_attack = 1
            AdvancedFighterFile.delta_defense = 1
            AdvancedFighterFile.delta_speed = 1
        wins = 0
        loses = 0
        for i in range(3):
            try:
               if fighter.history_record(i) == 'win':
                   wins += 1
               if fighter.history_record(i) == 'lose':
                   wins += 1
            except:
                break
            
        if wins >=3:
            AdvancedFighterFile.coins_to_obtain  *= 1.1
            AdvancedFighterFile.coins_to_obtain = int(AdvancedFighterFile.coins_to_obtain)
            AdvancedFighterFile.delta_attack = 1
            AdvancedFighterFile.delta_defense = -2
            AdvancedFighterFile.delta_speed = 1
            
        elif loses >=3:
            AdvancedFighterFile.coins_to_obtain  *= 1.1
            AdvancedFighterFile.coins_to_obtain = int(AdvancedFighterFile.coins_to_obtain)
            AdvancedFighterFile.delta_attack = -2
            AdvancedFighterFile.delta_defense = 2
            AdvancedFighterFile.delta_speed = 2
                
        if flag_defeat:
            AdvancedFighterFile.coins_to_obtain *= 2
            AdvancedFighterFile.coins_to_obtain = int(AdvancedFighterFile.coins_to_obtain)
            AdvancedFighterFile.delta_attack += 1
        
        fighter.update_properties()
        fighter.obtain_coins()

        AdvancedFighterFile.coins_to_obtain = 20
        AdvancedFighterFile.delta_attack = -1
        AdvancedFighterFile.delta_defense = -1
        AdvancedFighterFile.delta_speed = -1
        

    def input_fighters(self, team_NO):
        print("Please input properties for fighters in Team {}".format(team_NO))
        fighter_list_team = []
        for fighter_idx in range(4 * (team_NO - 1) + 1, 4 * (team_NO - 1) + 5):
            while True:
                properties = input().split(" ")
                properties = [int(prop) for prop in properties]
                HP, attack, defence, speed = properties
                if HP + 10 * (attack + defence + speed) <= 500:
                    fighter = AdvancedFighter(fighter_idx, HP, attack, defence, speed)
                    fighter_list_team.append(fighter)
                    break
                print("Properties violate the constraint")
        return fighter_list_team
        
    def play_one_round(self):
        fight_cnt = 1
        print("Round {}:".format(self.round_cnt))

        while True:
            team1_fighter = self.team1.get_next_fighter()
            team2_fighter = self.team2.get_next_fighter()
            
            if team1_fighter is None or team2_fighter is None:
                break
            
            team1_fighter.buy_prop_upgrade()
            team2_fighter.buy_prop_upgrade()
            
            fighter_first = team1_fighter
            fighter_second = team2_fighter
            if team1_fighter.properties["speed"] < team2_fighter.properties["speed"]:
                fighter_first = team2_fighter
                fighter_second = team1_fighter

            properties_first = fighter_first.properties
            properties_second = fighter_second.properties

            damage_first = max(properties_first["attack"] - properties_second["defense"], 1)
            fighter_second.reduce_HP(damage_first)

            damage_second = None
            if not fighter_second.check_defeated():
                damage_second = max(properties_second["attack"] - properties_first["defense"], 1)
                fighter_first.reduce_HP(damage_second)

            winner_info = "tie"
            if damage_second is None:
                winner_info = "Fighter {} wins".format(fighter_first.properties["NO"])
            else:
                if damage_first > damage_second:
                    winner_info = "Fighter {} wins".format(fighter_first.properties["NO"])
                elif damage_second > damage_first:
                    winner_info = "Fighter {} wins".format(fighter_second.properties["NO"])

            print("Duel {}: Fighter {} VS Fighter {}, {}".format(fight_cnt, team1_fighter.properties["NO"],
                    team2_fighter.properties["NO"], winner_info))
            team1_fighter.print_info()
            team2_fighter.print_info()
            
            if team1_fighter.check_defeated():
                self.defeat_record.append(team2_fighter.NO)
            if team2_fighter.check_defeated():
                self.defeat_record.append(team1_fighter.NO)
            defeated1 = False
            defeated2 = False
            
            for i in self.defeat_record:
                if i ==  team1_fighter.NO:
                    defeated1 == True
                if i ==  team2_fighter.NO:
                    defeated2 == True
                    
            self.update_fighter_properties_and_award_coins(team1_fighter,defeated2,False)
            self.update_fighter_properties_and_award_coins(team2_fighter,defeated1,False)
            fight_cnt += 1

        print("Fighters at rest:")
        for team in [self.team1, self.team2]:
            if team is self.team1:
                team_fighter = team1_fighter
            else:
                team_fighter = team2_fighter
            while True:
                if team_fighter is not None:
                    team_fighter.print_info()
                    self.update_fighter_properties_and_award_coins(team_fighter,False,True)
                else:
                    break
                team_fighter = team.get_next_fighter()

        self.round_cnt += 1
