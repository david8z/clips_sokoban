;;============================================
;;============ S O K O B A N =================
;;============================================


(defrule right-no-box
	?f1 <- (robot ?y ?x $?aux level ?lvl) 
	(obstacle ?yo ?xo)	
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (not(member (create$ warehouse ?y (+ ?x 1)) $?aux)))
	(test (not(member (create$ box ?y (+ ?x 1)) $?aux)))
	(test (and (<> ?y ?yo ) (<> (+ ?x 1) ?xo)))
	(test (< ?x ?xd))
	(test (< ?lvl ?prof))
   =>
	(assert (robot ?y (+ ?x 1 ) $?aux level (+ ?lvl 1)))
)

(defrule  right-with-box
	?f1 <- (robot ?y ?x $?aux1 box ?y ?xb $?aux2 level ?lvl)
	(obstacle ?yo ?xo)
	(grid _dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (= (+ ?x 1) ?xb))
	(test (not (memeber (create$ box ?y (+ ?x 2)) $?aux1)))
	(test (not (memeber (create$ box ?y (+ ?x 2)) $?aux2))) 
	(test (not(member (create$ warehouse ?y (+ ?x 2)) $?aux2)))
	(test (and (<> ?y ?yo ) (<> (+ ?x 2) ?xo)))
	(test (< (+ ?x 1) ?xd))
	(test (< ?lvl ?prof))
   =>
	(assert (robot ?y (+ ?x 1 ) $?aux1 box ?y (+ ?xb 1) $?aux2 level (+ ?lvl 1)))
)

(defrule right-insert-box
	?f1 <- (robot ?y ?x $?aux1 box ?y ?xb $?aux2 warehouse ?y ?xw ?cw level ?lvl)
	(obstacle ?yo ?xo)
	(grid _dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (= (+ ?x 1) ?xb))
	(test (not (memeber (create$ box ?y (+ ?x 2)) $?aux1)))
	(test (not (memeber (create$ box ?y (+ ?x 2)) $?aux2))) 
	(test (not(member (create$ warehouse ?y (+ ?x 2)) $?aux2)))
	(test (and (<> ?y ?yo ) (<> (+ ?x 2) ?xo)))
	(test (< (+ ?x 1) ?xd))
	(test (< ?lvl ?prof))
   =>
	(assert (robot ?y (+ ?x 1 ) $?aux1 box ?y (+ ?xb 1) $?aux2 level (+ ?lvl 1)))


(defrule goal
	(declare (salience 100))
	?f <- (robot $?all level ?lvl)
	(test (not (member box $?all)))
   =>
	(printout t "SOLUTION FOUND AT LEVEL " ?lvl crlf)
	(printout t "GOAL FACT " ?f crlf)
    
	(halt)
)

(defrule no_SOLUTION
	(declare (salience -99))
	(robot $?all level ?lvl)
   =>
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
	(assert (grid_dimension 5 3))
	(assert (obstacle 3 1))
	(assert (robot 4 1 warehouse 4 3 0 warehouse 1 2 0 box 3 2 box 2 2 level 0)) 
	(assert (max-depth ?prof))

)
