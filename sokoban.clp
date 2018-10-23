;;============================================
;;============ S O K O B A N =================
;;============================================

(defglobal ?*nod-gen* = 0)

;;=============MOVEMENT RIGHT=================
(defrule right-no-box
	?f1 <- (robot ?y ?x $?aux movement ?mv level ?lvl) 
	(obstacles: $?obs)
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (not (member (create$ warehouse ?y (+ ?x 1)) $?aux)))
	(test (not (member (create$ box ?y (+ ?x 1)) $?aux)))
	(test (not (member (create$ obstacle ?y (+ ?x 1)) $?obs)))
	(test (< ?x ?xd))
	(test (< ?lvl ?prof))
	(test (neq ?mv left))
   =>
	(assert (robot ?y (+ ?x 1 ) $?aux movement right level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule  right-with-box
	(declare (salience 25))
	?f1 <- (robot ?y ?x $?aux1 box ?y ?xb $?aux2 movement ?mv level ?lvl)
	(obstacles: $?obs)
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (= (+ ?x 1) ?xb))
	(test (not (member (create$ box ?y (+ ?x 2)) $?aux1)))
	(test (not (member (create$ box ?y (+ ?x 2)) $?aux2))) 
	(test (not (member (create$ warehouse ?y (+ ?x 2)) $?aux1)))
	(test (not (member (create$ obstacle ?y (+ ?x 2)) $?obs)))
	(test (< (+ ?x 1) ?xd))
	(test (< ?lvl ?prof))
   =>
	(assert (robot ?y (+ ?x 1 ) $?aux1 box ?y (+ ?xb 1) $?aux2 movement null level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule right-insert-box
	(declare (salience 50))
	?f1 <- (robot ?y ?x $?aux1 warehouse ?y ?xw ?cw $?aux2 box ?y ?xb  $?aux3 movement ?mv level ?lvl)
	(max-depth ?prof)
	(warehouse_capacity ?cap)	

	(test (= (+ ?x 1) ?xb))
	(test (= (+ ?x 2) ?xw))
	(test (< ?cw ?cap))
	(test (< ?lvl ?prof))
   =>
	(assert (robot ?y (+ ?x 1 ) $?aux1 warehouse ?y ?xw (+ ?cw 1) $?aux2 $?aux3 movement null level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

;;=============MOVEMENT LEFT=================
(defrule left-no-box
	?f1 <- (robot ?y ?x $?aux movement ?mv level ?lvl) 
	(obstacles: $?obs)
	(max-depth ?prof)
	
	(test (not (member (create$ warehouse ?y (- ?x 1)) $?aux)))
	(test (not (member (create$ box ?y (- ?x 1)) $?aux)))
	(test (not (member (create$ obstacle ?y (- ?x 1)) $?obs)))
	(test (neq ?mv right))
	(test (> ?x 1))
	(test (< ?lvl ?prof))
   =>
	(assert (robot ?y (- ?x 1 ) $?aux movement left level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule  left-with-box
	(declare (salience 25))
	?f1 <- (robot ?y ?x $?aux1 box ?y ?xb $?aux2 movement ?mv level ?lvl)
	(obstacles: $?obs)
	(max-depth ?prof)
	
	(test (eq (- ?x 1) ?xb)) 
	(test (not (member (create$ box ?y (- ?x 2)) $?aux1)))
	(test (not (member (create$ box ?y (- ?x 2)) $?aux2))) 
	(test (not (member (create$ warehouse ?y (- ?x 2)) $?aux1)))
	(test (not (member (create$ obstacle ?y (- ?x 2)) $?obs)))
	(test (> ?x 2))
	(test (< ?lvl ?prof))
   =>
	(assert (robot ?y (- ?x 1 ) $?aux1 box ?y (- ?xb 1) $?aux2 movement null level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule left-insert-box
	(declare (salience 50))
	?f1 <- (robot ?y ?x $?aux1 warehouse ?y ?xw ?cw $?aux2 box ?y ?xb  $?aux3 movement ?mv level ?lvl)
	(max-depth ?prof)
	(warehouse_capacity ?cap)	

	(test (= (- ?x 1) ?xb))
	(test (= (- ?x 2) ?xw))
	(test (< ?cw ?cap))
	(test (< ?lvl ?prof))
   =>
	(assert (robot ?y (- ?x 1 ) $?aux1 warehouse ?y ?xw (+ ?cw 1) $?aux2 $?aux3 movement null level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

;;==============MOVEMENT UP==================
(defrule up-no-box
	?f1 <- (robot ?y ?x $?aux movement ?mv level ?lvl) 
	(obstacles: $?obs)
	(max-depth ?prof)
	
	(test (not (member (create$ warehouse (- ?y 1)  ?x ) $?aux)))
	(test (not (member (create$ box (- ?y 1) ?x ) $?aux)))
	(test (not (member (create$ obstacle (- ?y 1) ?x) $?obs)))
	(test (> ?y 1))
	(test (< ?lvl ?prof))
	(test (neq ?mv down)) 
   =>
	(assert (robot (- ?y 1) ?x $?aux movement up level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule  up-with-box
	(declare (salience 25))
	?f1 <- (robot ?y ?x $?aux1 box ?yb ?x $?aux2 movement ?mv level ?lvl)
	(obstacles: $?obs)	
	(max-depth ?prof)
	
	(test (= (- ?y 1) ?yb))
	(test (not (member (create$ box (- ?y 2) ?x) $?aux1)))
	(test (not (member (create$ box (- ?y 2)  ?x ) $?aux2))) 
	(test (not (member (create$ warehouse (- ?y 2) ?x) $?aux1)))
	(test (not (member (create$ obstacle (- ?y 2) ?x) $?obs)))
	(test (> (- ?y 1) 1))
	(test (< ?lvl ?prof))
   =>
	(assert (robot (- ?y 1) ?x $?aux1 box (- ?yb 1) ?x $?aux2 movement null level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule up-insert-box
	(declare (salience 50))
	?f1 <- (robot ?y ?x $?aux1 warehouse ?yw ?x ?cw $?aux2 box ?yb ?x  $?aux3 movement ?mv level ?lvl)
	(max-depth ?prof)
	(warehouse_capacity ?cap)	

	(test (= (- ?y 1) ?yb))
	(test (= (- ?y 2) ?yw))
	(test (< ?cw ?cap))
	(test (< ?lvl ?prof))
   =>
	(assert (robot (- ?y 1) ?x $?aux1 warehouse ?yw ?x (+ ?cw 1) $?aux2 $?aux3 movement null level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

;;==============MOVEMENT DOWN==================
(defrule down-no-box
	?f1 <- (robot ?y ?x $?aux movement ?mv level ?lvl) 
	(obstacles: $?obs)
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (not (member (create$ warehouse (+ ?y 1)  ?x ) $?aux)))
	(test (not (member (create$ box (+ ?y 1) ?x ) $?aux)))
	(test (not (member (create$ obstacle (+ ?y 1) ?x) $?obs)))
	(test (neq  ?mv up))
	(test (< ?y  ?yd ))
	(test (< ?lvl ?prof))
   =>
	(assert (robot (+ ?y 1) ?x $?aux movement down level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule  down-with-box
	(declare (salience 25))
	?f1 <- (robot ?y ?x $?aux1 box ?yb ?x $?aux2 movement ?mv level ?lvl)
	(obstacles: $?obs)
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (= (+ ?y 1) ?yb))
	(test (not (member (create$ box (+ ?y 2) ?x) $?aux1)))
	(test (not (member (create$ box (+ ?y 2)  ?x ) $?aux2))) 
	(test (not (member (create$ warehouse (+ ?y 2) ?x) $?aux1)))
	(test (not (member (create$ obstacle (+ ?y 2) ?x) $?obs)))
	(test (< ?y (- ?yd 1))) 
	(test (< ?lvl ?prof))
   =>
	(assert (robot (+ ?y 1) ?x $?aux1 box (+ ?yb 1) ?x $?aux2 movement null level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule down-insert-box
	(declare (salience 50))
	?f1 <- (robot ?y ?x $?aux1 warehouse ?yw ?x ?cw $?aux2 box ?yb ?x  $?aux3 movement ?mv level ?lvl)
	(max-depth ?prof)
	(warehouse_capacity ?cap)	

	(test (= (+ ?y 1) ?yb))
	(test (= (+ ?y 2) ?yw))
	(test (< ?cw ?cap))
	(test (< ?lvl ?prof))
   =>
	(assert (robot (+ ?y 1) ?x $?aux1 warehouse ?yw ?x (+ ?cw 1) $?aux2 $?aux3 movement null level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)


;;==============DEFAULT=================

(defrule goal
	(declare (salience 100))
	?f <- (robot $?all level ?lvl)
	(test (not (member box $?all)))
   =>
        
	(printout t "SOLUTION FOUND AT LEVEL " ?lvl crlf)
	(printout t "NUMBER OF EXPANDED NODES OR TRIGGERED RULES " ?*nod-gen* crlf)
	(printout t "GOAL FACT " ?f crlf)
    
	(halt)
)

(defrule no_solution
	(declare (salience -99))
	(robot $?all level ?lvl)
   =>
	(printout t "NUMBER OF EXPANDED NODES OR TRIGGERED RULES " ?*nod-gen* crlf)
	(printout t "SOLUTION NOT FOUND" crlf)
	
	(halt)
)
	


(deffunction start ()
        (reset)
	(printout t "Maximum depth:= " )
	(bind ?prof (read))
	(printout t "Search strategy " crlf "    1.- Breadth" crlf "    2.- Depth" crlf )
	(bind ?a (read))
	(if (= ?a 1)
	       then    (set-strategy breadth)
	       else   (set-strategy depth))
        (printout t " Execute run to start the program " crlf)
	(assert (warehouse_capacity 1))
	(assert (grid_dimension 5 8))
	(assert (obstacles: obstacle 3 1 obstacle 1 4 obstacle 3 4 obstacle 4 4 obstacle 5 4 obstacle 3 5 obstacle 3 8))
	(assert (robot 4 1 warehouse 1 7 0 warehouse 4 5 0 warehouse 5 5 0 box 4 3 box 2 2 box 2 6 movement null level 0)) 
	(assert (max-depth ?prof))

)
