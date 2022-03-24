# Exercise 5: Cognitive Agents in Hypermedia Environments
A template for an application implemented with the [JaCaMo 0.9](http://jacamo.sourceforge.net/?page_id=40) framework for programming Multi-Agent Systems (MAS).

### Table of Contents
-   [Task 1](#task-1)
-   [Task 2](#task-2)
-   [Task 3](#task-3)
-   [Register as a user to leubot1](#register-as-a-user-to-leubot1)
-   [Programming JaCaMo applications in Atom](#programming-jacamo-applications-in-atom)
-   [How to run the project](#how-to-run-the-project)

### Task 1
Task 1 requires implementing (part of) a tutorial for programming four agents that will print different hello world messages. 

Follow the instructions of the [Hello JaCaMo - Part II (agent)](http://jacamo.sourceforge.net/tutorial/hello-world/#part-ii-agent) tutorial. Update the files [`sample_agent.asl`](https://github.com/HSG-WAS-SS22/exercise-5/blob/main/src/agt/sample_agent.asl) and  [`task1.jcm`](https://github.com/HSG-WAS-SS22/exercise-5/blob/main/task1.jcm) based on the instructions. 

HINTS:
- Run the Gradle task `task1` based on the [instructions](#how-to-run-the-project) to observe the behavior of your implementation.


### Task 2
Task2 requires updating the program of a _detector_ agent for enabling it to infer knowledge based on the current state of the world. 

A detector agent uses a simulated service `detector1` for detecting blocks whithin a **workspace** named "lab". Based on the notifications that the agent receives from the service, it constructs **beliefs** of the form `positioned(BlockName, X, Y, Z)[certainty(Cert)]`, e.g. `positioned("A", 100, 150, 0)[certainty(0.9)]`. Such a belief denotes that the agent believes that block "A" is positioned in (100, 150, 0) with a **degree of certainty** 0.9. Based on its beliefs, the agent follows Prolog-like **rules** to infer whether a block is positioned on top of another block, and whether a block is positioned on the table within the workspace.

STEPS:
- Step 1: Update the rule [`on(Block1, Block2)`](https://github.com/HSG-WAS-SS22/exercise-5/blob/ba6d52c8d6352a1d9146ae824ca70f45f2b87f5a/src/agt/detector.asl#L30) to enable the agent to infer whether a Block1 is detected to be positioned on top of a Block2.
- Step 2: Update the rule [`onTable(Block)`](https://github.com/HSG-WAS-SS22/exercise-5/blob/ba6d52c8d6352a1d9146ae824ca70f45f2b87f5a/src/agt/detector.asl#L45) to enable the agent to infer whether a Block is detected to be positioned on the table.

HINTS:
- Observe how the similar rule [`clear(Block)`](https://github.com/HSG-WAS-SS22/exercise-5/blob/ba6d52c8d6352a1d9146ae824ca70f45f2b87f5a/src/agt/detector.asl#L10) is implemented for inferring whether nothing is positioned on top of a Block. 
- For implementing the rules, take into consideration the degree of certainty of the agent's beliefs. The agent should not infer anything if any related belief has a degree of certainty < 0.5. 
- Run the Gradle task `task2` based on the [instructions](#how-to-run-the-project) to test your implementation.

### Task 3
Task3 requires updating the program of a _mover_ agent for planning the solution of the **blocks-world** problem in the lab workspace. 

A mover agent uses the following:
- A simulated service `detector1` for detecting blocks whithin the lab workspace.
- A robotic arm `leubot1` for moving blocks within the lab workspace.

By using `detector1` and its rules (implemented in Task 1), the agent believes (as described in Task 1), at some point in time, that the state of the world is as follows:

<img src="https://github.com/danaivach/assignment-5/blob/4a0517423cf2d5bf86c41e7e2abd3a794b6043aa/blocks-world-initial-state.png?raw=true" width="400">

Based on its beliefs about the state, the agent attempts to organize the blocks "A", "B", "C" using the robotic arm `leubot1`, so that the state of the world looks as follows:

<img src="https://github.com/danaivach/assignment-5/blob/4a0517423cf2d5bf86c41e7e2abd3a794b6043aa/blocks-world-final-state.png?raw=true" width="400">


After organizing the blocks, the agent prints its current beliefs that should have been updated based on the notifications of `detector1` and should correspond to the updated state of the world.

STEPS:
- Step 1: Register as a user to `leubot1`, so that the agent can use the robotic arm. Follow the instructions for acquiring an API key, and then update the agent's belief [`apikey`](https://github.com/HSG-WAS-SS22/exercise-5/blob/9caea9056ebdc451a4f23bea0153cf8b360932d4/src/agt/mover.asl#L15) accordingly. Alternatively, if you are running the application on dry run (i.e. without executing the requests to `leubot1`), simply uncomment the existing belief. This belief is required for the agent to start (see plan `start`). 
- Step 2: Update the rules [`on(Block1, Block2)`](https://github.com/HSG-WAS-SS22/exercise-5/blob/9caea9056ebdc451a4f23bea0153cf8b360932d4/src/agt/mover.asl#L44) and [`onTable(Block)`](https://github.com/HSG-WAS-SS22/exercise-5/blob/9caea9056ebdc451a4f23bea0153cf8b360932d4/src/agt/mover.asl#L59) based on the work that you implemented in Task 2. These rules are useful for the agent to infer beliefs required for organizing the blocks. 
- Step 3: Update the context and body of the agent's plan [`organize(Block1, Block2, Block3)`](https://github.com/HSG-WAS-SS22/exercise-5/blob/9caea9056ebdc451a4f23bea0153cf8b360932d4/src/agt/mover.asl#L115) to enable the agent to organize Block1, Block2, and Block3 based on the blocks-world problem. Use the agent's beliefs (e.g. beliefs inferred through the agent's rules) to implement the context of the plan. Use the plans `unstack(Block1, Block2)`, `pickUp(Block)`, `putDown(Block)`, and `stack(Block1, Block2)` to implement the plan based on sub-goals.
- Step 4: Update the context and body of the agent's plan [`putDown(Block)`](https://github.com/HSG-WAS-SS22/exercise-5/blob/9caea9056ebdc451a4f23bea0153cf8b360932d4/src/agt/mover.asl#L188) to enable the agent to put a Block on the table by using `leubot1`.
- Step 5: Update the context and body of the agent's plan [`pickUp(Block)`](https://github.com/HSG-WAS-SS22/exercise-5/blob/9caea9056ebdc451a4f23bea0153cf8b360932d4/src/agt/mover.asl#L209) to enable the agent to pick a Block from the table by using `leubot1`.
- Step 6: Update the context and body of the agent's plan [`stack(Block1, Block2)`](https://github.com/HSG-WAS-SS22/exercise-5/blob/9caea9056ebdc451a4f23bea0153cf8b360932d4/src/agt/mover.asl#L232) to enable the agent to stack a Block1 on Block2 by using `leubot1`.

HINTS:
- For implementing Tasks 4-6, observe how the similar plan [`unstack(Block1, Block2)`](https://github.com/HSG-WAS-SS22/exercise-5/blob/9caea9056ebdc451a4f23bea0153cf8b360932d4/src/agt/mover.asl#L159) is implemented for enabling the agent to ustack a Block1 from a Block2 by using `leubot1`. 
- For implementing Tasks 3-6, avoid updating by yourselves any agent's beliefs that should be inferred through the agent's rules. Such beliefs should be automatically updated through the rules whenever `detector1` notifies the agent about a change in the state of the world. For example, avoid making a belief addition `+on(Block1,Block2)` on the plan body of `stack(Block1,Block2)`. Instead, concentrate on implementing a body that triggers the execution of existing plans (e.g. `!unstack(Block1, Block2)` etc. in Step 3, and `!move(X,Y,Z)`, `!release` etc. in Steps 3-6), and that updates the agent's beliefs about `leubot1` (e.g. `gripperEmpty` etc.).
- Run the Gradle task `task3` or `task3dryrun` based on the [instructions](#how-to-run-the-project) to observe the behavior of your implementation.


### Register as a user to leubot1
For registering as a user and exploit the API of [leubot1 v1.3.4](https://interactions-hsg.github.io/leubot/), you need to send an HTTP POST request to https://api.interactions.ics.unisg.ch/leubot1/v1.3.4/user with your name and email in a JSON payload. The last element of the response header `Location` is the API key that is required for interacting with leubot1. 

For example, if you are using [cURL](https://curl.se/docs/manpage.html), you can run a similar command:
```
curl -v https://api.interactions.ics.unisg.ch/leubot1/v1.3.4/user -H 'Content-Type: application/json' --data '{"name": "Example Name", "email": "example@unisg.ch"}'
``` 

Upon execution, you should receive a similar response:
```
HTTP/1.1 201 Created
< Server: nginx/1.14.1
< Date: Tue, 22 Mar 2022 21:07:32 GMT
< Content-Type: application/json; charset=UTF-8
< Content-Length: 0
< Connection: keep-alive
< Access-Control-Allow-Credentials: true
< Access-Control-Allow-Headers: *
< Access-Control-Allow-Methods: GET,HEAD,OPTIONS,POST
< Access-Control-Allow-Origin: *
< Location: https://api.interactions.ics.unisg.ch/leubot1/v1.3.4/user/047820620ee091c7301b3fceed54d918
```
Here, `047820620ee091c7301b3fceed54d918` is the valid API key.

The W3C Web of Things Thing Description of leubot1 is available [here](https://raw.githubusercontent.com/Interactions-HSG/example-tds/main/tds/leubot1.ttl).

### Programming JaCaMo applications in Atom
The [Atom editor](https://atom.io/) supports syntax highlighting for programming JaCaMo applications. Suggested packages:
- [language-agentspeak](https://atom.io/packages/language-agentspeak): syntax highlighting for agent files (.asl) with the AgentSpeak language [1].
- [language-jcm](https://atom.io/packages/language-jcm): syntax highlighting for the [configurations files (.jcm)](http://jacamo.sourceforge.net/doc/jcm.html) of JaCaMo MAS applications. 
- [ide-java](https://atom.io/packages/ide-java) and [atom-ide-ui](https://atom.io/packages/atom-ide-ui): syntax highlighting for Java files (.java) used for the provided implementations of `detector1` and `leubot1`.

To install any of the suggested packages, open your Atom editor, and `Packages -> Settings View -> Install Packages/Themes`, and search and `Install` your preferred package.

[1] Bordini, R. H., Hübner, J. F., & Wooldridge, M. (2007). Programming multi-agent systems in AgentSpeak using Jason. John Wiley & Sons.

### How to run the project
Run with [Gradle 7.4](https://gradle.org/): 
- MacOS and Linux: run the following commands
- Windows: replace `./gradlew` with `gradlew.bat`

For Task 1:
```shell
./gradlew task1
```
For Task 2:
```shell
./gradlew task2
```
For Task 3 by printing and executing the requests to leubot1):
```shell
./gradlew task3
```
For Task 3 by only printing the requests to leubot1):
```shell
./gradlew task3dryrun
```





