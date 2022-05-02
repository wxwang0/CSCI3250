(* data type *)
datatype rank = Jack | Queen | King | Ace | Num of int
(* val cardlist = [Num 1, Num 2, Num 3, Num 4, King, Jack, Queen, Ace, Num 9, Num 10];*)

(* basic version: the point of Ace is 1 *)
(* magic version: the point of Ace is 1 or 11*)

(* Problem 1 *)
(* compute the point for basic version *)
(* input: a rank *)
(* output: the basic point of the rank *)

fun get_basic_point (Jack) = 10:int
= | get_basic_point (Queen) = 10:int
= | get_basic_point (King) = 10:int
= | get_basic_point (Ace) = 1:int
= | get_basic_point (Num i) = i

(* Problem 2 *)
(* get the cards of Player 1 *)
(*
** input: the number of cards for player 1
**        the number of cards for player 2
**        the common rank list for two players
*)
(* output: (the drawn cards of player 1, the drawn cards of player 2) *)
(* n1 + n2 is smaller than the number of cards *)
(* n1 and n2 are positive *)
fun get_cards (n1:int,n2:int, card_list:rank list)
= let fun get_list(0,list1:rank list) = []
      =| get_list(n:int,list1: rank list) 
      = hd card_list: get_list(n-1,tl(list1)) in
  (* find the first list*)
= let fun remain_list(0,list1:rank list) = list1
      = | remain_list(n:int, list1:rank list) 
      = remain_list(n-1,tl(list1)) in
   (* find the remaining list*)
= (get_list[n1,card_list],get_list[n2,remain_list(n1,card_list)])
     

(* Problem 3 *)
(* tanslate the sum of points to TP by objective function *)
(* the tool used by other functions *)
(* input: the sum of points for all cards *)
(* output: the TP computed by objective function *)
fun cal_TP(0) = 0
= | cal_TP(sp:int) 
= if sp < 22 then sp
= else cal_TP(sp-21)

(* Problem 4 *)
(* compute the TP for basic version *)
(* input: a rank list *)
(* output: the TP for basic version *)
fun get_basic_TP [] = 0 
= | get_basic_TP(a::(card_list:rank list)) = cal_tp(get_basic_point(a) + get_basic_TP (card_list))

(* Problem 5 *)
(* compute TP considering the different choices of Ace for magic version *)
(* input: a rank list *)
(* output: the TP for magic version *)
fun get_TP(card_list:rank list) = 
= let fun num_of_ace [] = 0
  = | num_of_ace (a::thelist) 
  = if a = Ace then num_of_ace(thelist)+1
  = else num_of_ace(thelist) 
= let val Aces = num_of_ace (card_list) in
= let val basicTP = get_basic_TP(card_list) in
= let fun find_max_TP(0,TP:int) = TP
  = | find_max_TP(n:int,TP:int)
  = let val newTP = cal_tp(10*n+TP)          
  = if newTP>TP then find_max_TP(n-1,newTP)
  = else find_max_TP(n-1,TP) in
(* recurisives change value of ACE to 11,and search for the largest TP *)
= find_max_TP(Aces,basicTP)
              
(* Problem 6 *)
(* judge winner by the given rank lists of players *)
(*
** input: (the drawn cards of player 1, the drawn cards of player 2)
*)
(*
** output: 1 (player 1 wins) or
**         2 (player 2 wins) or
**         0 (tie)
*)
fun judge_winner_basic (cards1:rank list,cards2: rank list)
= let val TP1 = get_basic_TP(cards1) in
= let val TP2 = get_basic_TP(cards2) in            
= if TP1 > TP2 then 1
= orelse if TP1 < TP2 then 2
= orelse 0

(* Problem 7 *)
(* judge winner by the given rank lists of players *)
(*
** input: (the drawn cards of player 1, the drawn cards of player 2)
*)
(*
** output: 1 (player 1 wins) or
**         2 (player 2 wins) or
**         0 (tie)
*)
fun judge_winner (cards1: rank list,cards2: rank list)
= let val TP1 = get_TP(cards1) in
= let val TP2 = get_TP(cards2) in            
= if TP1 > TP2 then 1
= orelse if TP1 < TP2 then 2
= orelse 0

(* Problem 8 *)
(* judge winner by the number of drawn cards and the rank list *)
(* n1 + n2 is smaller than the number of cards *)
(* n1 and n2 are positive *)
(*
** input: the number of cards for player 1
**        the number of cards for player 2
**        the common rank list for two players
*)
(*
** output: 1 (player 1 wins) or
**         2 (player 2 wins) or
**         0 (tie)
*)
fun basic_result(n1:int,n2:int,card_list: rank list) 
= let val cards = get_cards (n1,n2, card_list) in  
= let val list1 = hd(card_list) in
= let val list2 = hd(tl(hard_list)) in                      
= judge_winner_basic(list1,list2)               

(* Problem 9 *)
(* judge winner by the number of drawn cards and the rank list *)
(* n1 + n2 is smaller than the number of cards *)
(* n1 and n2 are positive *)
(*
** input: the number of cards for player 1
**        the number of cards for player 2
**        the common rank list for two players
*)
(*
** output: 1 (player 1 wins) or
**         2 (player 2 wins) or
**         0 (tie)
*)
fun result(n1:int,n2:int,card_list: rank list) 
= let val cards = get_cards (n1,n2, card_list) in  
= let val list1 = hd(card_list) in
= let val list2 = hd(tl(hard_list)) in                      
= judge_winner(list1,list2) 

(* Problem 10 *)
(* magic version *)
(* judge the largest TP which can be gotten by player 2 with any legal number of drawn cards *)
(*
** input: the number of cards for player 1
**        the common rank list for two players
*)
(* output: the largest TP *)
fun cal_largest_TP (n1:int,card_list: rank list)
  = let fun remain_list(0,list1:rank list) = list1
      = | remain_list(n:int, list1:rank list) 
      = remain_list(n-1,tl(list1)) in                               (* find the remaining list*)
  = let val remaining = remain_list(n1,card_list) in
  = let fun cutlist(0,thelist: rank list) = []
      = | cutlist(num:int, a::thelist: rank list)
      = a::cutlist(num-1,thelist) in                          
                                    
  = let fun leng [] = 0
    = | leng(a::thelist) = leng(thelist) +1 in
  = let fun find_largest(n,thelist: rank list ,maxTP:int) 
     = if n >= leng(thelist) then maxTP
     = else if get_TP(cutlist(n,thelist)) > maxTP then     find_largest(n+1,thelist,getTP(list2))
     = else find_largest(n+1,thelist,maxTP) in                                      
= find_largest(0,remaining,0)
(* calculate the TP starting will n2 = 0, to n2 = length of remaining list, and find the largest *)                                     
                                            
                                 












