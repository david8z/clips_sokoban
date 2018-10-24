;;============================================
;;============ S O K O B A N =================
;;============================================

(defglobal ?*nod-gen* = 0)

;;=============MOVEMENT RIGHT=================
(defrule right-no-box
	(robot ?y ?x $?aux level ?lvl) 
	(obstacles: $?obs)
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (< ?x ?xd))
	(test (< ?lvl ?prof))
	(test (not (member (create$ warehouse ?y (+ ?x 1)) $?aux)))
	(test (not (member (create$ box ?y (+ ?x 1)) $?aux)))
	(test (not (member (create$ obstacle ?y (+ ?x 1)) $?obs)))
   =>
	(assert (robot ?y (+ ?x 1 ) $?aux level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule  right-with-box
	(declare (salience 25))
	(robot ?y ?x $?aux1 box ?y =(+ ?x 1) $?aux2 level ?lvl)
	(obstacles: $?obs)
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (< (+ ?x 1) ?xd))
	(test (< ?lvl ?prof))
	(test (not (member (create$ box ?y (+ ?x 2)) $?aux1)))
	(test (not (member (create$ box ?y (+ ?x 2)) $?aux2))) 
	(test (not (member (create$ warehouse ?y (+ ?x 2)) $?aux1)))
	(test (not (member (create$ obstacle ?y (+ ?x 2)) $?obs)))
   =>
	(assert (robot ?y (+ ?x 1 ) $?aux1 box ?y (+ ?x 2) $?aux2 level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule right-insert-box
	(declare (salience 50))
	(robot ?y ?x $?aux1 warehouse ?y =(+ ?x 2) ?cw $?aux2 box ?y =(+ ?x 1)  $?aux3 level ?lvl)
	(max-depth ?prof)
	(warehouse_capacity ?cap)	

	(test (< ?cw ?cap))
	(test (< ?lvl ?prof))
   =>
	(assert (robot ?y (+ ?x 1 ) $?aux1 warehouse ?y (+ ?x 2) (+ ?cw 1) $?aux2 $?aux3 level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

;;=============MOVEMENT LEFT=================
(defrule left-no-box
	(robot ?y ?x $?aux level ?lvl) 
	(obstacles: $?obs)
	(max-depth ?prof)
	
	(test (> ?x 1))
	(test (< ?lvl ?prof))
	(test (not (member (create$ warehouse ?y (- ?x 1)) $?aux)))
	(test (not (member (create$ box ?y (- ?x 1)) $?aux)))
	(test (not (member (create$ obstacle ?y (- ?x 1)) $?obs)))
   =>
	(assert (robot ?y (- ?x 1 ) $?aux level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule  left-with-box
	(declare (salience 25))
	(robot ?y ?x $?aux1 box ?y =(- ?x 1) $?aux2 level ?lvl)
	(obstacles: $?obs)
	(max-depth ?prof)
	
	(test (> ?x 2))
	(test (< ?lvl ?prof))
	(test (not (member (create$ box ?y (- ?x 2)) $?aux1)))
	(test (not (member (create$ box ?y (- ?x 2)) $?aux2))) 
	(test (not (member (create$ warehouse ?y (- ?x 2)) $?aux1)))
	(test (not (member (create$ obstacle ?y (- ?x 2)) $?obs)))
   =>
	(assert (robot ?y (- ?x 1 ) $?aux1 box ?y (- ?x 2) $?aux2 level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule left-insert-box
	(declare (salience 50))
	(robot ?y ?x $?aux1 warehouse ?y =(- ?x 2) ?cw $?aux2 box ?y =(- ?x 1)  $?aux3 level ?lvl)
	(max-depth ?prof)
	(warehouse_capacity ?cap)	

	(test (< ?cw ?cap))
	(test (< ?lvl ?prof))
   =>
	(assert (robot ?y (- ?x 1 ) $?aux1 warehouse ?y (- ?x 2) (+ ?cw 1) $?aux2 $?aux3 level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

;;==============MOVEMENT UP==================
(defrule up-no-box
	(robot ?y ?x $?aux level ?lvl) 
	(obstacles: $?obs)
	(max-depth ?prof)
	
	(test (> ?y 1))
	(test (< ?lvl ?prof))
	(test (not (member (create$ warehouse (- ?y 1)  ?x ) $?aux)))
	(test (not (member (create$ box (- ?y 1) ?x ) $?aux)))
	(test (not (member (create$ obstacle (- ?y 1) ?x) $?obs)))
	   =>
	(assert (robot (- ?y 1) ?x $?aux level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule  up-with-box
	(declare (salience 25))
	(robot ?y ?x $?aux1 box =(- ?y 1) ?x $?aux2 level ?lvl)
	(obstacles: $?obs)	
	(max-depth ?prof)
	
	(test (> (- ?y 1) 1))
	(test (< ?lvl ?prof))
	(test (not (member (create$ box (- ?y 2) ?x) $?aux1)))
	(test (not (member (create$ box (- ?y 2)  ?x ) $?aux2))) 
	(test (not (member (create$ warehouse (- ?y 2) ?x) $?aux1)))
	(test (not (member (create$ obstacle (- ?y 2) ?x) $?obs)))
	   =>
	(assert (robot (- ?y 1) ?x $?aux1 box (- ?y 2) ?x $?aux2 level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule up-insert-box
	(declare (salience 50))
	(robot ?y ?x $?aux1 warehouse =(- ?y 2) ?x ?cw $?aux2 box =(- ?y 1) ?x  $?aux3 level ?lvl)
	(max-depth ?prof)
	(warehouse_capacity ?cap)	

	(test (< ?cw ?cap))
	(test (< ?lvl ?prof))
   =>
	(assert (robot (- ?y 1) ?x $?aux1 warehouse (- ?y 2) ?x (+ ?cw 1) $?aux2 $?aux3 level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

;;==============MOVEMENT DOWN==================
(defrule down-no-box
	(robot ?y ?x $?aux level ?lvl) 
	(obstacles: $?obs)
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (< ?y  ?yd ))
	(test (< ?lvl ?prof))
	(test (not (member (create$ warehouse (+ ?y 1)  ?x ) $?aux)))
	(test (not (member (create$ box (+ ?y 1) ?x ) $?aux)))
	(test (not (member (create$ obstacle (+ ?y 1) ?x) $?obs)))
	   =>
	(assert (robot (+ ?y 1) ?x $?aux level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule  down-with-box
	(declare (salience 25))
	(robot ?y ?x $?aux1 box =(+ ?y  1) ?x $?aux2 level ?lvl)
	(obstacles: $?obs)
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (< ?y (- ?yd 1))) 
	(test (< ?lvl ?prof))
	(test (not (member (create$ box (+ ?y 2) ?x) $?aux1)))
	(test (not (member (create$ box (+ ?y 2)  ?x ) $?aux2))) 
	(test (not (member (create$ warehouse (+ ?y 2) ?x) $?aux1)))
	(test (not (member (create$ obstacle (+ ?y 2) ?x) $?obs)))
	   =>
	(assert (robot (+ ?y 1) ?x $?aux1 box (+ ?y 2) ?x $?aux2 level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule down-insert-box
	(declare (salience 50))
	(robot ?y ?x $?aux1 warehouse =(+ ?y 2) ?x ?cw $?aux2 box =(+ ?y 1) ?x  $?aux3 level ?lvl)
	(max-depth ?prof)
	(warehouse_capacity ?cap)	

	(test (< ?cw ?cap))
	(test (< ?lvl ?prof))
   =>
	(assert (robot (+ ?y 1) ?x $?aux1 warehouse (+ ?y 2) ?x (+ ?cw 1) $?aux2 $?aux3 level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)


;;==============HOP PROBLEM=================

(defrule right-obstacle
	(robot ?y ?x $?aux level ?lvl) 
	(obstacles: $?obs)
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (< ?x (- ?xd 1)))
	(test (< ?lvl ?prof))
	(test (not (member (create$ warehouse ?y (+ ?x 1)) $?aux)))
	(test (not (member (create$ box ?y (+ ?x 1)) $?aux)))
	(test (member$ (create$ obstacle ?y (+ ?x 1)) $?obs))
	(test (not (member (create$ warehouse ?y (+ ?x 2)) $?aux)))
	(test (not (member (create$ box ?y (+ ?x 2)) $?aux)))
	(test (not (member (create$ obstacle ?y (+ ?x 2)) $?obs)))
   =>
	(assert (robot ?y (+ ?x 2 ) $?aux level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule left-obstacle
	(robot ?y ?x $?aux level ?lvl) 
	(obstacles: $?obs)
	(max-depth ?prof)
	
	(test (> ?x 2))
	(test (< ?lvl ?prof))
	(test (not (member (create$ warehouse ?y (- ?x 1)) $?aux)))
	(test (not (member (create$ box ?y (- ?x 1)) $?aux)))
	(test (member (create$ obstacle ?y (- ?x 1)) $?obs))
	(test (not (member (create$ warehouse ?y (- ?x 2)) $?aux)))
	(test (not (member (create$ box ?y (- ?x 2)) $?aux)))
	(test (not (member (create$ obstacle ?y (- ?x 2)) $?obs)))
   =>
	(assert (robot ?y (- ?x 2 ) $?aux level (+ ?lvl 1)))
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
	(assert (obstacles: obstacle 3 1 obstacle 1 4 obstacle 3 4 obstacle 4 4 obstacle 5 4 obstacle 3 8))
	(assert (robot 4 1 warehouse 1 7 0 warehouse 4 7 0 box 4 3 box 2 2 level 0)) 
	(assert (max-depth ?prof))

)
