use strict;
use warnings;
package Team;

sub new {
    my $class = shift;
    my $self = {
     NO =>  shift,
     fighter_list => undef,
     order => undef,
     fight_cnt => 0,
    };
   
   bless $self,$class;
   return $self;};

sub set_fighter_list{
    my $self = shift;
    $self ->{fighter_list} = [];
    $self ->{fighter_list} = \@_;
}
sub get_fighter_list{
    my $self = shift;
    return $self->{fighter_list};
}

sub set_order{
    my $self = shift;
    $self ->{order} = [];
    $self ->{order} = \@_;
    $self->{fight_cnt} = 0;
}
sub get_next_fighter{
    my $self = shift;
    my $len = @{$self->{order}};
    my $cnt = $self->{fight_cnt};
        
    if($cnt >= $len){
        return undef;
    }

    my $prev_fighter_idx = $self->{order}[$cnt];
    my $fighter = undef;
    
    for my $i(0..($len-1)){
        if ($self ->{fighter_list}[$i]->{NO} == $prev_fighter_idx){
            $fighter = $self ->{fighter_list}[$i];
            last;
         }
    }
    $self->{fight_cnt} += 1;
    return $fighter;
}
1;