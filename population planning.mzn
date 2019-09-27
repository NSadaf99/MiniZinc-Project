include "globals.mzn";
int : m_age ; 
int : f_age ;
int : annual_income;
int : m_working_hours;
int : f_working_hours;
set of int: disease= 1..10;
set of int: sev= 1..10;
set of int: factors= 1..5;
array[1..10] of int: m_disease; %input taken from 1 to 5 
array[1..10] of int: f_disease; %input taken from 1 to 5 
int : number_of_children;
array[1..10] of int: severity= [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
int: disease_factor;

array[1..5] of var int: factor_taken;
var int: number_of_children_advised;

constraint forall(f in factors)(factor_taken[f] >= 0);
constraint forall(f in factors)(factor_taken[f] <= 1);

constraint number_of_children + number_of_children_advised <=3;

constraint factor_taken[3]=1;
constraint factor_taken[4]=1;
constraint factor_taken[5]=1;
%constraint sum (f in factors)(factor_taken[f]) >=3; %3 or more factor must be taken into account

constraint (factor_taken[1]*working_hours_factor+
factor_taken[2]*annual_income_factor+
factor_taken[3]*m_age_factor+
factor_taken[4]*f_age_factor+
factor_taken[5]*disease_factor)
/
(sum (f in factors)(factor_taken[f]))
>=0.6; %avg of all factors taken must be greater than 0.6

disease_factor= if sum (d in disease)((m_disease[d] * severity[d]) + (f_disease[d] * severity[d])) <=3
then 1
else
0
endif;

float : working_hours_factor=
if m_working_hours<=6 \/ f_working_hours<=6
then 1
elseif m_working_hours>6 /\ m_working_hours<=9
then 0.5
elseif f_working_hours>6 /\ f_working_hours<=12
then 0.5
else 0
endif;

float : annual_income_factor= 
if annual_income<600000 
then 0.0
elseif annual_income>=600000 /\ annual_income<960000
then 0.6
elseif annual_income>=960000 /\ annual_income<1200000
then 0.8
else 1
endif;

float : m_age_factor= 
if m_age>=18 /\ m_age<32 
then 1.0
elseif m_age>=32 /\ m_age<37
then 0.6
elseif m_age>=37 /\ m_age<=51
then 0.35
else 0
endif;

float : f_age_factor= if m_age>=18 /\ m_age<40
then 1.0
elseif m_age>=40 /\ m_age<50
then 0.6
elseif m_age>=50 /\ m_age<=65
then 0.35
else 0
endif;

%calc of no of children left out
solve maximize (sum (f in factors)(factor_taken[f]));
output [show(factor_taken[1]) ++ " " ++ show (factor_taken[2]) ++ " " ++ show(factor_taken[3] )];
 