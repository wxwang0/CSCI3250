(* data type *)
(* 
∗ CSCI3180 Principles of Programming Languages
∗
∗ --- Declaration ---
∗
∗ I declare that the assignment here submitted is original except for source
∗ material explicitly acknowledged. I also acknowledge that I am aware of
∗ University policy and regulations on honesty in academic work, and of the
∗ disciplinary guidelines and procedures applicable to breaches of such policy
∗ and regulations, as contained in the website
∗ http://www.cuhk.edu.hk/policy/academichonesty/
∗
* Assignment 4
* Name : Wang Wei Xiao
* Student ID : 1155141608
* Email Addr : 1155141608@link.cuhk.edu.hk
*)

datatype rank = Jack | Queen | King | Ace | Num of int
(* val cardlist = [Num 1, Num 2, Num 3, Num 4, King, Jack, Queen, Ace, Num 9, Num 10];*)

(* basic version: the point of Ace is 1 *)
(* magic version: the point of Ace is 1 or 11*)

(* Problem 1 *)
(* compute the point for basic version *)
(* input: a rank *)
(* output: the basic point of the rank *)

fun get_basic_point (Jack) = 10:int
 | get_basic_point (Queen) = 10:int
 | get_basic_point (King) = 10:int
 | get_basic_point (Ace) = 1:int
 | get_basic_point (Num 2) = 2:int
 | get_basic_point (Num 3) = 3:int
 | get_basic_point (Num 4) = 4:int
 | get_basic_point (Num 5) = 5:int
 | get_basic_point (Num 6) = 6:int
 | get_basic_point (Num 7) = 7:int
 | get_basic_point (Num 8) = 8:int
 | get_basic_point (Num 9) = 9:int
 | get_basic_point (Num 10) = 10:int;

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
fun get_cards (n1:int,n2:int, card_list:rank list)= 
let val card_list1 = [] :rank list
val card_list2 = [] :rank list
fun draw_cards (0,0,cards1: rank list,cards2: rank list, card_list: rank list,first:int) = (cards1,cards2)
    | draw_cards (n1,n2,cards1,cards2,card_list,first) =
    if first = 1 andalso n1>0 then draw_cards(n1-1,n2,cards1::(hd (card_list)::[]),cards2,tl card_list,2)
    else if first = 2 andalso n2 >0 then draw_cards(n1,n2-1,cards1,cards2::(hd card_list::[]),tl card_list,1)
    else if n1>0 then draw_cards(n1-1,n2,cards1::(hd (card_list)::[]),cards2,tl card_list,2)
    else draw_cards(n1,n2-1,cards1,cards2::(hd card_list::[]),tl card_list,1)
  
in 
 draw_cards (n1,n2,card_list1,card_list2, card_list,1)
 end;
     

(* Problem 3 *)
(* tanslate the sum of points to TP by objective function *)
(* the tool used by other functions *)
(* input: the sum of points for all cards *)
(* output: the TP computed by objective function *)
fun cal_TP(0) = 0
 | cal_TP(sp:int) = if sp < 22 then sp
 else cal_TP(sp-21);

(* Problem 4 *)
(* compute the TP for basic version *)
(* input: a rank list *)
(* output: the TP for basic version *)
fun get_basic_TP [] = 0 
 | get_basic_TP(a::(card_list:rank list)) = cal_TP(get_basic_point(a) + get_basic_TP (card_list));

(* Problem 5 *)
(* compute TP considering the different choices of Ace for magic version *)
(* input: a rank list *)
(* output: the TP for magic version *)
fun get_TP(card_list:rank list) = 
 let fun num_of_ace [] = 0
   | num_of_ace (a::thelist) = if a = Ace then num_of_ace(thelist)+1
   else num_of_ace(thelist) 
 val Aces = num_of_ace (card_list) 
 val basicTP = get_basic_TP(card_list) 
 fun find_max_TP(0,TP:int) = TP
   | find_max_TP(n:int,TP:int) =     
   if cal_TP(10*n+TP)>TP then find_max_TP(n-1,cal_TP(10*n+TP))
   else find_max_TP(n-1,TP) 
 in
(* recurisives change value of ACE to 11,and search for the largest TP *)
 find_max_TP(Aces,basicTP)
 end;
              
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
fun judge_winner_basic (cards1:rank list, cards2: rank list)=
 let val TP1 = get_basic_TP(cards1) 
 val TP2 = get_basic_TP(cards2) in            
 ( if TP1 > TP2 then 1
 else if TP1 < TP2 then 2
 else 0)
 end;

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
fun judge_winner (cards1: rank list,cards2: rank list) =  let val TP1 = get_TP(cards1) 
 val TP2 = get_TP(cards2) in            
 (if TP1 > TP2 then 1
 else if TP1 < TP2 then 2
 else 0)
 end;

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
fun basic_result(n1:int,n2:int,card_list: rank list) = let val cards = get_cards (n1,n2, card_list)   in                      
  judge_winner_basic cards  
 end;            

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
fun result(n1:int,n2:int,card_list: rank list) = let val cards = get_cards (n1,n2, card_list) in                     
 judge_winner cards
 end ;

(* Problem 10 *)
(* magic version *)
(* judge the largest TP which can be gotten by player 2 with any legal number of drawn cards *)
(*
** input: the number of cards for player 1
**        the common rank list for two players
*)
(* output: the largest TP *)
fun cal_largest_TP (n1:int,card_list: rank list)  = let fun remain_list(0,list1:rank list) = list1
       | remain_list(n:int, list1:rank list) = remain_list(n-1,tl(list1))                                (* find the remaining list*)
    val remaining = remain_list(n1,card_list) 
    fun cutlist(0,thelist: rank list) = []
       | cutlist(num:int, a::thelist) =
       a::cutlist(num-1,thelist)                          
                                    
   fun leng [] = 0
     | leng(a::thelist) = leng(thelist) +1 
   fun find_largest(n,thelist: rank list ,maxTP:int) =
      if n >= leng(thelist) then maxTP
      else if get_TP(cutlist(n,thelist)) > maxTP then     find_largest(n+1,thelist,get_TP(thelist))
      else find_largest(n+1,thelist,maxTP) in                                      
 find_largest(0,remaining,0)
 end;
(* calculate the TP starting will n2 = 0, to n2 = length of remaining list, and find the largest *)                                     
                                  
get_cards(2, 2, [Num 5, Num 2, Num 3, Num 4]);











