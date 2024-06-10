/* pasrec.c      program to test record operations      10 Feb 04 */

#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>
typedef struct complex { double re; double im;} *COMPLEX;
enum color { red, white, blue };
typedef struct person
 { int age;
   struct person * friend;
   struct complex location;
   enum color favorite;
   double salary;} *PERSON;
void graph1()
{  struct complex c,d; double x; int i, sum;
   struct complex ac[10];
   enum color aco[10][3];
   PERSON john, mary, fred, ptr; struct person people[20];
   john = (PERSON) malloc(sizeof(struct person));
   mary = (PERSON) malloc(sizeof(struct person));
   fred = (PERSON) malloc(sizeof(struct person));
   john->favorite = blue;
   john->age = 19;
L1492:
   john->friend = mary;
   john->salary = 40000.0;
   john->location.re = 3;
   mary->age = 21;
   mary->friend = fred;
L1776:
   fred->age = 20;
   fred->friend = NULL;
   john->friend->friend->location.im = 4.5;
   ac[6].re = john->salary;
   ptr = john;
   sum = 0;
   i = 1;
   while (ptr != NULL)
     {
	sum = sum + ptr->age;
	people[i].age = ptr->age;
	aco[i][white] = john->favorite;
	ptr = ptr->friend;
        i = i + 1;
     };
   printf("i = %d\n", i);
   printf("Sum of ages = %d\n", sum);
   printf("Fred loc im = %f\n", fred->location.im);
   if (sum < 3) goto L1776;
}

int main()
{ graph1(); exit(0);}
