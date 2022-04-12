use strict;
use warnings;

package Fighter;

sub new{
  my $class = shift;
  my $self = {
    NO =>  shift,
    HP =>  shift,
    attack =>  shift,
    defense =>  shift,
    speed =>  shift,
    defeated =>  0,
  };
  bless $self,$class;
  return $self;
}

sub get_properties{
  my $self = shift;
  return {"NO" => $self->{NO},
   "HP" => $self->{HP},
   "attack" => $self->{attack},
   "defense" => $self->{defense},
   "speed" => $self->{speed},
   "defeated" => $self->{defeated}
 };
}

sub reduce_HP{
  my $self = shift;
  $self->{HP} = $self->{HP} -shift;
  if ($self->{HP} <= 0){
    $self->{HP} = 0;
    $self->{defeated} = 1;
  }
}

sub check_defeated{
  my $self = shift;
  return $self->{defeated};
}

sub print_info{
  my $self = shift;
  my $defeated_info;
  if ($self -> check_defeated() == 1){
    $defeated_info = "defeated";
  }else{
    $defeated_info = "undefeated";
  }
  print "Fighter $self->{'NO'}: HP: $self->{'HP'} attack: $self->{'attack'} defense: $self->{'defense'} speed: $self->{'speed'} $defeated_info\n";
}


1;
