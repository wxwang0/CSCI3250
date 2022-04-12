use strict;
use warnings;

package Tournament;
use base_version::Team;
use base_version::Fighter;

sub new{
    my $class = shift;
    my $self = {
     team1 => undef,
     team2 => undef,
     round_cnt =>  1
    };
    bless $self,$class;
}

sub set_teams{
    my $self = shift;
    $self->{team1} = shift;
    $self->{team2} = shift;
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
            }
        else{
            if ($damage_first > $damage_second){
                $winner_info = " Fighter ".$fighter_first ->{NO}." wins";
            }
            elsif ($damage_second > $damage_first){
                $winner_info = join " Fighter ".$fighter_second ->{NO}." wins";
            }
        }
        print "Duel ". $fight_cnt. ": Fighter ". $team1_fighter->{NO}. " VS Fighter " .$team2_fighter->{NO}.",". $winner_info."\n"; 
        $team1_fighter->print_info();
        $team2_fighter->print_info();
        $fight_cnt += 1;
    }
        

    print"Fighters at rest:\n";
    my $team_fighter = $team1_fighter;
    while (defined($team_fighter)){
        $team_fighter->print_info();
        $team_fighter = $self->{team1}->get_next_fighter();
    }
        
    $team_fighter = $team2_fighter;
    while (defined($team_fighter)){
        $team_fighter->print_info();
        $team_fighter = $self->{team2}->get_next_fighter();
    }
    $self->{round_cnt} += 1;    
}

sub check_winner(){
    my $self = shift;
    my $team1_defeated = 1;
    my $team2_defeated = 1;
    
    for my $i (0..3){
        my $fighter = $self->{team1}->{fighter_list}[$i];
        if ((defined($fighter))&&($fighter ->check_defeated() != 0)){
             $team1_defeated = 0;
             last;
         }
    }
    for my $i (0..3){
        my $fighter = $self->{team2}->{fighter_list}[$i];
        if ((defined($fighter))&&($fighter ->check_defeated() != 0)){
             $team2_defeated = 0;
             last;
         }
    }

    my $stop = 0;
    my $winner = 0;
    if ($team1_defeated){
         $stop = 1;
         $winner = 2;
     }

    if ($team1_defeated){
         $stop = 1;
         $winner = 1;
     }
    return $stop,$winner;
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
                my $fighter = new Fighter($fighter_idx,$properties[0], $properties[1],$properties[2],$properties[3]);
                push @fighter_list_team, $fighter;
                last;
            }      
            print("Properties violate the constraint\n");
        }        
    }
    return @fighter_list_team;
}

sub play_game{
    my $self = shift;
    my @fighter_list_team1 = $self->input_fighters(1);
    my @fighter_list_team2 = $self->input_fighters(2);
    
    my $team1 = new Team(1);
    my $team2 = new Team(2);
    $team1->set_fighter_list(@fighter_list_team1);
    $team2->set_fighter_list(@fighter_list_team2);

    $self->set_teams($team1, $team2);
    print("===========\n");
    print("Game Begins\n");
    print("===========\n");
    
    my @order1 = undef;
    my @order2 = undef;

    while (1){
       print("Team 1: please input order\n");
       while (1){
          my $input = <STDIN>;
          @order1 = split(/ /, $input);
          for my $i (@order1){
              $i = int($i);
          }
          my $flag_valid = 1;
          my $undefeated_number = 0;
          for my $order (@order1){
              if (($order<1)||($order>4)){
                  $flag_valid = 0;
              }
              elsif ($self->{team1}->{fighter_list}[$order - 1]->check_defeated()){
                  $flag_valid = 0;
              }
          }
          my $order_len = scalar @order1 -1;
          for my $i(0.. $order_len){
              for my $j($i+1..$order_len){
                  if($order1[$i] == $order1[$j]){
                      $flag_valid = 0;
                      last;
                  }                  
              }
          }
          for my $i (0..3){
            if ($self->{team1}->{fighter_list}[$i]->check_defeated() == 0){
                $undefeated_number += 1;
            }
          }
          if ($undefeated_number != scalar @order1){
              $flag_valid = 0;
          }
          if ($flag_valid){
              last;          
          }
          else{
              print("Invalid input order\n");
          }
          
        }
       print("Team 2: please input order\n");
       while (1){
          my $input = <STDIN>;
       
          @order2 = split(/ /, $input);
          for my $i (@order2){
              $i = int($i);
          }
          my $flag_valid = 1;
          my $undefeated_number = 0;
          for my $order (@order2){
              if (($order<5)||($order>8)){
                  $flag_valid = 0;
              }
              elsif ($self->{team2}->{fighter_list}[$order - 5]->check_defeated()){
                  $flag_valid = 0;
              }
          }
          for my $i(0.. scalar @order2-1){
              for my $j($i+1..scalar @order2-1){
                  if($order2[$i] == $order2[$j]){
                      $flag_valid = 0;
                      last;
                  }                  
              }
          }
          for my $i (0..3){
            if ($self->{team2}->{fighter_list}[$i]->check_defeated() == 0){
                $undefeated_number += 1;
            }
        }
          if ($undefeated_number != scalar @order2){
              $flag_valid = 0;
          }
          if ($flag_valid){
              last;
          }
          else{
              print("Invalid input order\n");
          }
          
        }
        
        $self->{team1}->set_order(@order1);
        $self->{team2}->set_order(@order2);
        
        
        $self->play_one_round();
        my $stop, my $winner = $self->check_winner();
        if ($stop){
           print "Team ".$winner." wins\n";
           last;
        }
    }
    
}
1;