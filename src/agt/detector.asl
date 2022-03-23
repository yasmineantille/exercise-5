// Detecting agent

/* Initial beliefs and rules */

// Initially, the agent believes that all blocks in the workspace have a Height
// equal to 5cm
blockHeight(5).


/*
  Rule for inferring whether a Block1 has nothing on top
  Body:
  - Block1 has coordinates (X1, Y1, Z1) with degree of certainty >= 0.5
  - There is no Block2 for which:
    - Block2 has coordinates (X2, Y2, Z2) with degree of certainty >= 0.5
    - X1 = X2
    - Y1 = Y2
    - Z2 > Z1
*/
clear(Block1) :-
  positioned(Block1, X1, Y1, Z1)[certainty(Cert1)] &
  Cert1 >= 0.5 &
  not (
    positioned(Block2, X2, Y2, Z2)[certainty(Cert2)] &
    Cert2 >= 0.5 &
    X1 == X2 & Y1 == Y2 & Z2 > Z1
  ).


/*
  TASK 2 - STEP 1
  Update the following rule based on the beliefs acquired by using detector1:
  Rule for inferring whether a Block1 is on top of Block2
  Body:
  - Block1 has coordinates (X1, Y1, Z1) with degree of certainty >= 0.5
  - Block2 has coordinates (X2, Y2, Z2) with degree of certainty >= 0.5
  - Blocks have a Height
  - X1 = X2
  - Y1 = Y2
  - Z1-Z2 = Height
*/
on(Block1, Block2) :- true.


/*
  TASK 2 - STEP 2
  Update the following rule based on the beliefs acquired by using detector1:
  Rule for inferring whether a Block is on the table
  Body:
  - Block has coordinates (X, Y, Z) with degree of certainty >= 0.5
  - Z = 0
*/
onTable(Block) :- true.


/* Initial goals */
// Achieve start. It triggers the execution of the plan with the triggering
// event +!start.
!start.


/*
  Achievement-goal addition: Plan for achieving start
  Body:
  - Use the operation detect() of detector1 to detect the positions of blocks
  - Print the positions of A, B, and, C (after organizing them)
*/
+!start
<-
  // Tests - round 1
  // Use the operation detect() of detector1 to detect the positions of blocks
  detect[artifact_id(detector1)];
  .wait(3000);

  !testTask2Step1;
  !testTask2Step2;

  // Tests - round 2
  // Use the operation detect() of detector1 to detect the positions of blocks
  detect[artifact_id(detector1)];
  .wait(3000);

  !testTask2Step1;
  !testTask2Step2;
.


/***********Plans for testing Task 2 - Step 1***********/

+!testTask2Step1 :
  not on("C","A") &
  positioned("A", _, _, _)[certainty(Cert)] &
  Cert < 0.5
<-
  .print("Test 1/2 for Task2 - Step 1 passed successfully.");
.

+!testTask2Step1 :
  on("C","A") &
  not on("C","B") &
  not on("A","C") &
  not on("B","C") &
  not on("A","B") &
  not on("B","A") &
  positioned("A", _, _, _)[certainty(Cert1)] &
  positioned("B", _, _, _)[certainty(Cert2)] &
  positioned("C", _, _, _)[certainty(Cert3)] &
  Cert1 >= 0.5 & Cert2 >= 0.5 & Cert3 >= 0.5
<-
  .print("Test 2/2 for Task2 - Step 1 passed successfully.");
.

+!testTask2Step2 :
  not onTable("B") &
  positioned("B", _, _, _)[certainty(Cert)] &
  Cert < 0.5
<-
  .print("Test 1/2 for Task2 - Step 2 passed successfully.");
.

+!testTask2Step2 :
  onTable("B") &
  onTable("A") &
  not onTable("C") &
  positioned("A", _, _, _)[certainty(Cert1)] &
  positioned("B", _, _, _)[certainty(Cert2)] &
  positioned("C", _, _, _)[certainty(Cert3)] &
  Cert1 >= 0.5 & Cert2 >= 0.5 & Cert3 >= 0.5
<-
  .print("Test 2/2 for Task2 - Step 2 passed successfully.");
.

-!testTask2Step1 <- .print("A test for Task2 - Step 1 has failed.").
-!testTask2Step2 <- .print("A test for Task2 - Step 2 has failed.").


/***********Plans for handling notifications about detected blocks***********/
/*
  Belief addition: Plan for handling the belief addition positioned(BlockName, X, Y, Z, Weight).
  The plan is useful for handling notifications from detector1
  Body:
  - Add a belief "positioned(BlockName, X, Y, Z)[certainty(Weight)]", where:
    - BlockName is the name of the detected block (i.e. "A", "B", or "C")
    - X is the coordinate of the detected block's position on the X axis
    - Y is the coordinate of the detected block's position on the Y axis
    - Z is the coordinate of the detected block's position on the Z axis
    - Weight is degree of certainty of the belief "positioned"
      (e.g. if Weight is greater or equal to 0.5 then the detection is accurate)
*/
+positioned(BlockName, X, Y, Z, Weight) <-
  .print("Perceive ", BlockName, " in (", X, ",", Y, ",", Z, ") with degree of certainty: ", Weight);
  -positioned(BlockName,_,_,_);
  +positioned(BlockName, X, Y, Z)[certainty(Weight)];
.
/*
  Achievement-goal addition: Plan for printing the position of a block
  Context:
    - The Block has coordinates (X, Y, Z) with degree of certainty >= 0.5
*/
+!printPosition(Block) :
  positioned(Block, X, Y, Z)[certainty(Cert)] & Cert >= 0.5
<-
  .print(Block, " in (", X, ",", Y, ",", Z, ")");
.


// Include additional agent behavior
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
