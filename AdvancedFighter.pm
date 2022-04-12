use strict;
use warnings;

package AdvancedFighter;

use base_version::Fighter;
use List::Util qw(sum);

our @ISA = qw(Fighter); 

our $coins_to_obtain = 20;
our $delta_attack = -1;
our $delta_defense = -1;
our $delta_speed = -1;


sub new{
    my ($class) = @_;
    my $self = $class->SUPER::new($_[1],$_[2],$_[3],$_[4],$_[5]);
    $self ->{coins} = 0;
    $self ->{history_record} = [];
    
  bless $self,$class;
  return $self;
}

sub obtain_coins{
    my $self = shift;   
    $self->{coins} += $coins_to_obtain;    
}

sub buy_prop_upgrade{
    my $self = shift;
    while ($self->{coins} >= 50){
        print "Do you want to upgrade properties for Fighter ".$self->{NO}."? A for attack. D for defense. S for speed. N for no \n";
        my $input = <STDIN>;
        chomp ($input);
        my @inputvalues= split(/ /, $input);
        my $choice = $inputvalues[0];
        if ($choice eq 'A'){
            $self ->{attack} += 1;
            $self->{coins} -= 50;
        }
        elsif ($choice eq 'D'){
            $self ->{defense} += 1;
            $self->{coins} -= 50;
        }
        elsif ($choice eq 'S'){
            $self ->{speed} += 1;
            $self->{coins} -= 50;
        }
        elsif ($choice eq 'N'){
            last;
        }
    }
}

sub record_fight{
    #1 for win, 2 for lose
    my $self = shift;
    my $result = shift;
    push @{$self ->{history_record}}, $result;
}


sub update_properties{
    my $self = shift;
    $self->{attack} = $self->{attack} + $delta_attack;
    if ($self->{attack}<1){
        $self->{attack} = 1;
    }
    $self->{defense} = $self->{defense} + $delta_defense;
    if ($self->{defense}<1){
        $self->{defense} = 1;
    }
    $self->{speed} = $self->{speed} + $delta_speed;
    if ($self->{speed}<1){
        $self->{speed} = 1;
    }
}
