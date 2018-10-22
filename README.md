# SOKOBAN on CLIPS

---

![SOKOBAN IMAGE](./sokoban.gif)

Rule Based System program that solves the sokoban problem using CLIPS. The different elements of the program are:

	- obstacle y\_index x\_index
	- robot y\_index x\_index
	- warehouse y\_index x\_index capacity
	- box y\_index x\_index

All this elements along other inner variables can be modified on the start function at the end of the program.

---

In order to execute the code on linux based systems, first install clips.

`bash
sudo apt-get install clips
`

Clone the repo into your local system.

`bash 
git init

git clone https://github.com/david8z/clips_sokoban.git
`

Then run the program using the clips interpreter.

`bash 
clips -f sokoban.clp

CLIPS> (start)

CLIPS> (run)
`

_It is recommended to use (watch facts) inside clips for an easier interpretation._
