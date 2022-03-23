// Moving agent

/* Initial beliefs and rules */

// Initially, the agent believes that there is a free position on the table
emptyPosition(150, 100, 0)[certainty(1)].

// Initially, the agent believes that all blocks in the workspace have a Height
// equal to 5cm
blockHeight(5).

// Initially, the agent believes the gripper of leubot1 is empty
gripperEmpty.

/*
  TASK 3 - STEP 1 Add an initial belief apikey() with your API key (as a string)
  for interacting with leubot1
  You can register manually and acquire and API key, by executing the script:
*/
  // Uncomment the following and add your API key
  //apikey("YOUR_API_KEY").


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
  TASK 3 - STEP 2 Replace this rule with the one that you implemented on Task2
  (on detector.asl).
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
  TASK 3 - Step 2 Replace this rule with the one that you implemented on Task2
  (on detector.asl).
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
  Context:
  - There is an API key
  Body:
  - Use the operation setAPIkey() of leubot1 to enable the interactions with leubot1
  - Use the operation detect() of detector1 to detect the positions of blocks
  - Organize the blocks A, B, and, C
  - Print the positions of A, B, and, C (after organizing them)
*/
+!start :
  apikey(Token)
<-
  setAPIKey(Token)[artifact_id(leubot1)];
  detect[artifact_id(detector1)];
  .wait(3000);

  // Achieve organizing the blocks A, B, and C. It triggers the execution of
  // the plan with the triggering event +!organize(Block1, Block2, Block3).
  !organize("A", "B", "C");

  // Achieve printPosition of each block A, B, and C. It triggers the execution
  // of the plan with the triggering event +!printPosition(Block).
  !printPosition("A");
  !printPosition("B");
  !printPosition("C");
.


/*
  Achievement-goal deletion: Handles the failure of plan start
*/
-!start <-
  .print("An API key is required for the agent to start.");
  .print("Revisit Task 3 - Step 1 to add a belief with a necessary API key.");
.

/***********Plans for resolving the blocks-world problem***********/

/*
  TASK 3 - STEP 3
  Update the context and the body of the plan that follows:
  Achievement-goal addition: Plan for achieving organize(Block1, Block2, Block3).
  The plan is useful for organizing 3 blocks based on the blocks-world example:
  Context:
  - Block2 has nothing on top
  - Block3 has nothing on top
  - Block1 is on the table
  - Block2 is on the table
  - Block3 is on Block1
  - The gripper is empty
  Body:
    Implement the body for having Block1 on top of Block2,
    Block2 on top of Block 3, and Block3 on top of the table.
*/
+!organize(Block1, Block2, Block3) :
  true // update the context
<-
  .print("Organizing.");
  /* update the body for solving the blocks-world problem
     HINT: Exploit the sub-goals:
           - unstack(Block1, Block2)
           - pickUp(Block)
           - putDown(Block)
           - stack(Block1, Block2)
  */
.

/*
  Achievement-goal deletion: Handles the failure of plan organize(Block1, Block2, Block3).
*/
// Comment this plan if you want to see why organize(Block1, Block2, Block3) fails.
-!organize(Block1, Block2, Block3) <-
  .print("Cannot organize");

  // Use the detect() operation of detector1 to detect the positions of blocks
  detect[artifact_id(detector1)];
  .wait(3000);

  // Try again to organize(Block1, Block2, Block3)
  !organize(Block1, Block2, Block3);
.

/*
  Achievement-goal addition: Plan for achieving unstack(Block1, Block2).
  The plan is useful for unstacking Block1 from Block2:
  Context:
  - Block1 is on Block 2
  - Block2 has nothing on top
  - The gripper is empty
  - Block1 has coordinates (X1, Y1, Z1) with degree of certainty >= 0.5
  Body:
  - leubot1 moves to (X1, Y1, Z1)
  - leubot1 grasps
  - leubot1 holds Block1
  - The gripper is not empty
*/
+!unstack(Block1, Block2) :
  on(Block1, Block2) &
  clear(Block1) &
  gripperEmpty &
  positioned(Block1, X1, Y1, Z1)[certainty(Cert1)] &
  Cert1 >= 0.5
<-
  .print("Unstack ", Block1, " from ", Block2);
  !moveTo(X1, Y1, Z1);
  !grasp;
  +holding(Block1);
  -gripperEmpty;
.


/*TASK 3 - STEP 4
  Update the context and the body of the plan that follows:
  Achievement-goal addition: Plan for achieving putDown(Block).
  The plan is useful for putting a Block on the table:
  Context:
  - There is an empty position in (X, Y, Z) with degree of certainty >=0.5
    HINT: Use a relevant initial belief of the agent (from the top of this document)
  - leubot1 holds the Block
  Body:
  - leubot1 moves to (X, Y, Z)
  - leubot1 releases
  - leubot1 does not hold the Block
  - The gripper is empty
*/
+!putDown(Block) :
  true // update the context
<-
  .print("Put ", Block, " on the table"); // update the body
.


/*
  TASK 3 - STEP 5
  Update the context and the body of the plan that follows:
  Achievement-goal addition: Plan for achieving pickUp(Block).
  The plan is useful for picking up a Block from the table:
  Context:
  - There is nothing on the Block
  - The Block is on the table
  - The gripper is empty
  - The Block has coordinates (X, Y, Z) with degree of certainty >= 0.5
  Body:
  - leubot1 moves to (X, Y, Z)
  - leubot1 grasps
  - leubot1 holds the Block
  - The gripper is not empty
*/
+!pickUp(Block) :
  true // update the context
<-
  .print("Pick ", Block, " from the table"); // update the body
.


/*
  TASK 3 - STEP 6
  Update the context and the body of the plan that follows:
  Achievement-goal addition: Plan for achieving stack(Block1, Block2).
  The plan is useful for stacking Block1 on Block2:
  Context:
  - leubot1 holds Block1
  - Block2 has nothing on top
  - Block2 has coordinates (X1, Y1, Z1) with degree of certainty >= 0.5
  Body:
  - leubot1 moves to (X2, Y2, Z2)
  - leubot1 releases
  - leubot1 does not hold Block1
  - The gripper is empty
*/
+!stack(Block1, Block2) :
  true // update the context
<-
  .print("Stact ", Block1, " on ", Block2); // update the body
.

/***********Plans for interacting with leubot1***********/

/*
  Achievement-goal addition: Plan for achieving release.
  The plan is useful for releasing the gripper of leubot1:
  Body:
  - Invoke the action onto:SetGripper with payload 512
*/
+!release
<-
  .print("- leubot1 releases")
  invokeAction("https://ci.mines-stetienne.fr/kg/ontology#SetGripper", ["https://www.w3.org/2019/wot/json-schema#IntegerSchema"], [512]);
  !interval;
.

/*
  Achievement-goal addition: Plan for achieving grasp.
  The plan is useful for grasping with the gripper of leubot1:
  Body:
  - Invoke the action onto:SetGripper with payload 0
*/
+!grasp
<-
  .print("- leubot1 grasps")
  invokeAction("https://ci.mines-stetienne.fr/kg/ontology#SetGripper", ["https://www.w3.org/2019/wot/json-schema#IntegerSchema"], [0]);
  !interval;
.

/*
  Achievement-goal addition: Plan for achieving moveTo(X, Y, Z).
  The plan is useful for moving leubot1 to (X, Y, Z):
  Context:
  - There is a known mapping for the 3D coordinates (X, Y, Z)
  Body:
  - Invoke the action onto:SetBase with a payload that maps to (X, Y, Z)
*/
+!moveTo(X, Y, Z) :
  angularDisplacement(X, Y, Degrees)
<-
  .print("- leubot1 moves to (", X, ", ", Y, ")");
  invokeAction("https://ci.mines-stetienne.fr/kg/ontology#SetBase", ["https://www.w3.org/2019/wot/json-schema#IntegerSchema"], [Degrees])[artifact_id(leubot1)];
  !interval;
.

/*
  Achievement-goal addition: Plan for introducing a delay between
  requests to leubot1
*/
+!interval <- .wait(3000).


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


/*
  Achievement-goal deletion: Handles the failure of plan printPosition(Block)
*/
-!printPosition(Block)
<-
  .print("Failed on printing the position of ", Block);
  .print("You should not be organizing blocks that have been detected with a degree of certainty < 0.5.");
  .print("Revisit Task 3 - Step 2 and Step 3 to make sure that the context of organizing(Block1, Block2, Block3) is appropriate.");
.

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



// Include additional agent behavior
{ include("/incl/common.asl") }
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
