use strict;
use warnings;

package AdvancedTournament;
use base_version::Team;
use advanced_version::AdvancedFighter;
use base_version::Tournament;
use List::Util qw(sum);

our @ISA = qw(Tournament); 

sub new{
    my ($class) = @_;
    my $self = $class->SUPER::new($_[1]);
    $self ->{defeated_record} = [];
    bless $self,$class;
}

sub play_one_round{
    my $self = shift;
    my $fight_cnt = 1;
    print "Round ".$self->{round_cnt}.":\n";
    my $team1_fighter = undef;
    my $team2_fighter = undef;
    
    while(1){
        $team1_fighter = $self->{team1}->get_next_fighter();
        $team2_fighter = $self->{team2}->get_next_fighter();
        
        if (!defined($team1_fighter) || !defined($team2_fighter)){
            last;
        }
        
           
        my $fighter_first = $team1_fighter;  
        my $fighter_second = $team2_fighter;    
        
        $team1_fighter ->buy_prop_upgrade();
        $team2_fighter ->buy_prop_upgrade();
        
        if ($team1_fighter->{speed} < $team2_fighter->{speed}){
           $fighter_first = $team2_fighter;
           $fighter_second = $team1_fighter;
        }
        my $properties_first = $fighter_first->get_properties();
        my $properties_second = $fighter_second->get_properties();

        my $damage_first = $properties_first->{attack} - $properties_second->{defense};
        if ($damage_first<1){
            $damage_first = 1;
        }
        $fighter_second->reduce_HP($damage_first);

        my $damage_second = undef;
        if ($fighter_second->check_defeated() == 0){
            $damage_second = $properties_second->{attack} - $properties_first->{defense};
                if ($damage_second <1){
                    $damage_second = 1;
                }
            $fighter_first->reduce_HP($damage_second);
        }
        
        my $winner_info = " tie";
        if (!defined($damage_second)){
            $winner_info = " Fighter ".$fighter_first ->{NO}." wins";
            $fighter_first->record_fight(1);
            $fighter_second->record_fight(2);
            }
        else{
            if ($damage_first > $damage_second){
                $winner_info = " Fighter ".$fighter_first ->{NO}." wins";
                $fighter_first->record_fight(1);
                $fighter_second->record_fight(2);
                
            }
            elsif ($damage_second > $damage_first){
                $winner_info = join " Fighter ".$fighter_second ->{NO}." wins";
                $fighter_first->record_fight(2);
                $fighter_second->record_fight(1);
                               
            }
        }
        print "Duel ". $fight_cnt. ": Fighter ". $team1_fighter->{NO}. " VS Fighter " .$team2_fighter->{NO}.",". $winner_info."\n"; 
        
        if ($team1_fighter->check_defeated()){
            push @{$self->{defeated_record}},$team1_fighter->{NO};           
        }
        elsif ($team2_fighter->check_defeated()){
            push @{$self->{defeated_record}},$team2_fighter->{NO};            
        }
        
        $team1_fighter->print_info();
        $team2_fighter->print_info();
          
        my $team1_defeat = 0;
        my $team2_defeat = 0;
        
        for my $i(@{$self->{defeated_record}}){
            if ($i == $team1_fighter ->{NO}){
                $team1_defeat = 1;
            }
            if ($i == $team2_fighter ->{NO}){
                $team2_defeat = 1;
            }
        } 
        
        $self->update_fighter_properties_and_award_coins($team1_fighter,$team2_defeat,0);        
        $self->update_fighter_properties_and_award_coins($team2_fighter,$team1_defeat,0);      
        $fight_cnt += 1;
    }
        

    print"Fighters at rest:\n";
    my $team_fighter = $team1_fighter;
    while (defined($team_fighter)){
        $self->update_fighter_properties_and_award_coins($team_fighter,0,1);
        $team_fighter->print_info();
        $team_fighter = $self->{team1}->get_next_fighter();
    }
        
    $team_fighter = $team2_fighter;
    while (defined($team_fighter)){
        $self->update_fighter_properties_and_award_coins($team_fighter,0,1);
        $team_fighter->print_info();
        $team_fighter = $self->{team2}->get_next_fighter();
    }
    $self->{defeated_record} = [];
    $self->{round_cnt} += 1;    
}

sub update_fighter_properties_and_award_coins{
    my $self = shift;
    my $fighter = shift;
    my $flag_defeat = shift;
    my $flag_rest = shift;

    local $AdvancedFighter::delta_attack = $AdvancedFighter::delta_attack;
    local $AdvancedFighter::delta_defense = $AdvancedFighter::delta_defense;
    local $AdvancedFighter::delta_speed = $AdvancedFighter::delta_speed;
    local $AdvancedFighter::coins_to_obtain = $AdvancedFighter::coins_to_obtain;
    
    my $consecutive_win = 0;
    my $consecutive_lose = 0;
    #calculate rest
    if ($flag_rest){
        $AdvancedFighter::coins_to_obtain  /= 2;
        local $AdvancedFighter::delta_attack = 1;
        local $AdvancedFighter::delta_defense = 1;
        local $AdvancedFighter::delta_speed = 1;
    }
    
    #calculate $consecutive_win/lose
    my $record = undef;
    for $record (0..2){
        if (defined($fighter ->{history_record}[$record]) &&($fighter ->{history_record}[$record] == 1)){
            $consecutive_win += 1;
        }
        if (defined($fighter ->{history_record}[$record]) &&($fighter ->{history_record}[$record] == 2)){
            $consecutive_lose += 1;
        }
    }
    
    if ($consecutive_win>=3){
        local $AdvancedFighter::coins_to_obtain  = $AdvancedFighter::coins_to_obtain *1.1;
        local $AdvancedFighter::delta_attack = 1;
        local $AdvancedFighter::delta_defense = -2;
        local $AdvancedFighter::delta_speed = 1;
        $fighter ->{history_record} = [];
    }
    elsif ($consecutive_lose>=3){
        local $AdvancedFighter::coins_to_obtain  = $AdvancedFighter::coins_to_obtain *1.1;
        local $AdvancedFighter::delta_attack = -2;
        local $AdvancedFighter::delta_defense = 2;
        local $AdvancedFighter::delta_speed = 2;
        $fighter ->{history_record} = [];
    }
    
    #calculate defeat    
    if ($flag_defeat){
        local $AdvancedFighter::delta_attack += 1;
        local $AdvancedFighter::coins_to_obtain = int( $AdvancedFighter::coins_to_obtain *2);
    }
       
    $fighter->obtain_coins();  
    $fighter->update_properties();    
}

sub input_fighters{
    my $self = shift;
    my $team_NO = shift;
    print "Please input properties for fighters in Team $team_NO\n";
    my @fighter_list_team = ();
    for my $fighter_idx (4*($team_NO - 1)+1..4 * ($team_NO - 1) + 4){
        while(1){
            my @properties = ();
            my $input = <STDIN>;
            chomp ($input);
            @properties = split(/ /, $input);
            if ($properties[0] + 10*($properties[1] + $properties[2] + $properties[3]) <= 500){
                my $fighter = new AdvancedFighter($fighter_idx,$properties[0], $properties[1],$properties[2],$properties[3]);
                push @fighter_list_team, $fighter;
                last;
            }      
            print("Properties violate the constraint\n");
        }        
    }
    return @fighter_list_team;
}


1;