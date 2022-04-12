from base_version.Fighter import Fighter

coins_to_obtain = 20
delta_attack = -1
delta_defense = -1
delta_speed = -1


class AdvancedFighter(Fighter):
    def __init__(self, NO, HP, attack, defense, speed):
        super(AdvancedFighter, self).__init__(NO, HP, attack, defense, speed)
        self.coins = 0
        self.history_record = []

    def obtain_coins(self):
        self.coins += coins_to_obtain
        
    def buy_prop_upgrade(self):
        while self.coins >=50:
            print(self.coins)
            print( "Do you want to upgrade properties for Fighter {}? A for attack. D for defense. S for speed. N for no".format(self.NO))
            inputvalue = input().split(" ")
            if inputvalue[0] == 'A':
                self.attack+=1
                self.coins -= 50
            elif inputvalue[0] == 'D':
                self.defense+=1
                self.coins -= 50
            elif inputvalue[0] == 'S':
                self.speed+=1
                self.coins -= 50
            elif inputvalue[0] == 'N':
                break
        
    def update_properties(self):
        self.attack+= delta_attack
        if self.attack <1:
            self.attack =1
        self.defense+= delta_defense
        if self.defense <1:
            self.defense =1
        self.speed+= delta_speed
        if self.speed <1:
            self.speed =1

    def record_fight(self, fight_result):
        self.history_record.append(fight_result)
