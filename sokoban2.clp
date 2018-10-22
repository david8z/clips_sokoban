;;============================================
;;============ S O K O B A N =================
;;============================================

(defglobal ?*nod-gen* = 0)

;;=============MOVEMENT RIGHT=================
(defrule right-no-box
	?f1 <- (robot ?y ?x $?aux level ?lvl) 
	(obstacle ?yo ?xo)	
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (not(member (create$ warehouse ?y (+ ?x 1)) $?aux)))
	(test (not(member (create$ box ?y (+ ?x 1)) $?aux)))
	(test (or (<> ?y ?yo ) (<> (+ ?x 1) ?xo)))
	(test (< ?x ?xd))
	(test (< ?lvl ?prof))
   =>
	(assert (robot ?y (+ ?x 1 ) $?aux level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule  right-with-box
	?f1 <- (robot ?y ?x $?aux1 box ?y ?xb $?aux2 level ?lvl)
	(obstacle ?yo ?xo)
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (= (+ ?x 1) ?xb))
	(test (not (member (create$ box ?y (+ ?x 2)) $?aux1)))
	(test (not (member (create$ box ?y (+ ?x 2)) $?aux2))) 
	(test (not(member (create$ warehouse ?y (+ ?x 2)) $?aux1)))
	(test (or (<> ?y ?yo ) (<> (+ ?x 2) ?xo)))
	(test (< (+ ?x 1) ?xd))
	(test (< ?lvl ?prof))
   =>
	(assert (robot ?y (+ ?x 1 ) $?aux1 box ?y (+ ?xb 1) $?aux2 level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule right-insert-box
	?f1 <- (robot ?y ?x $?aux1 warehouse ?y ?xw ?cw $?aux2 box ?y ?xb  $?aux3 level ?lvl)
	(obstacle ?yo ?xo)
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	(warehouse_capacity ?cap)	

	(test (= (+ ?x 1) ?xb))
	(test (= (+ ?x 2) ?xw))
	(test (< ?cw ?cap))
	(test (< (+ ?x 1) ?xd))
	(test (< ?lvl ?prof))
   =>
	(assert (robot ?y (+ ?x 1 ) $?aux1 warehouse ?y ?xw (+ ?cw 1) $?aux2 $?aux3 level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

;;=============MOVEMENT LEFT=================
(defrule left-no-box
	?f1 <- (robot ?y ?x $?aux level ?lvl) 
	;;(obstacle ?yo ?xo)	
	;;(grid_dimension ?yd ?xd) NO NEED TO USE GRID DIMENSION IN THIS CASE
	(max-depth ?prof)
	
	(test (not(member (create$ warehouse ?y (- ?x 1)) $?aux)))
	(test (not(member (create$ box ?y (- ?x 1)) $?aux)))
	;;(test (or (<> ?y ?yo ) (<> (+ ?x 1) ?xo)))
	(not (obstacle =(- ?x 1) ?y)) ;;ESTA MANERA ES M�S CORRECTA SI HAY M�S DE UN OBSTACULO
	(test (> ?x 0))
	(test (< ?lvl ?prof))
   =>
	(assert (robot ?y (- ?x 1 ) $?aux level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule  left-with-box
	?f1 <- (robot ?y ?x $?aux1 box ?y ?xb $?aux2 level ?lvl)
	;;(obstacle ?yo ?xo)
	;;(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (eq (- ?x 1) ?xb)) ;;HE UTILIZADO EL eq PORQUE NO SE SI EL = FUNCIONA IGUAL
	(test (not (member (create$ box ?y (- ?x 2)) $?aux1)))
	(test (not (member (create$ box ?y (- ?x 2)) $?aux2))) 
	(test (not (member (create$ warehouse ?y (- ?x 2)) $?aux1)))
	;;(test (or (<> ?y ?yo ) (<> (+ ?x 2) ?xo)))
	(not (obstacle =(- ?x 2) ?y))
	;;(test (< (+ ?x 1) ?xd))
	(test (> ?x 1))
	(test (< ?lvl ?prof))
   =>
	(assert (robot ?y (- ?x 1 ) $?aux1 box ?y (- ?xb 1) $?aux2 level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule left-insert-box
	(delcare (salience 50))
	?f1 <- (robot ?y ?x $?aux1 warehouse ?y ?xw ?cw $?aux2 box ?y ?xb  $?aux3 level ?lvl)
	(obstacle ?yo ?xo)
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	(warehouse_capacity ?cap)	

	(test (= (- ?x 1) ?xb))
	(test (= (- ?x 2) ?xw))
	(test (< ?cw ?cap))
	(test (> ?x 1))
	(test (< ?lvl ?prof))
   =>
	(assert (robot ?y (- ?x 1 ) $?aux1 warehouse ?y ?xw (+ ?cw 1) $?aux2 $?aux3 level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)
;;==============MOVEMENT UP==================
(defrule up-no-box
	?f1 <- (robot ?y ?x $?aux level ?lvl) 
	(obstacle ?yo ?xo)	
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (not(member (create$ warehouse (- ?y 1)  ?x ) $?aux)))
	(test (not(member (create$ box (- ?y 1) ?x ) $?aux)))
	(test (or (<> (- ?y 1) ?yo ) (<> ?x ?xo)))
	(test (> ?y 1))
	(test (< ?lvl ?prof))
   =>
	(assert (robot (- ?y 1) ?x $?aux level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule  up-with-box
	?f1 <- (robot ?y ?x $?aux1 box ?yb ?x $?aux2 level ?lvl)
	(obstacle ?yo ?xo)
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (= (- ?y 1) ?yb))
	(test (not (member (create$ box (- ?y 2) ?x) $?aux1)))
	(test (not (member (create$ box (- ?y 2)  ?x ) $?aux2))) 
	(test (not(member (create$ warehouse (- ?y 2) ?x) $?aux1)))
	(test (or (<> (- ?y 2) ?yo ) (<> ?x ?xo)))
	(test (> (- ?y 1) 1))
	(test (< ?lvl ?prof))
   =>
	(assert (robot (- ?y 1) ?x $?aux1 box (- ?yb 1) ?x $?aux2 level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule up-insert-box
	?f1 <- (robot ?y ?x $?aux1 warehouse ?yw ?x ?cw $?aux2 box ?yb ?x  $?aux3 level ?lvl)
	(obstacle ?yo ?xo)
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	(warehouse_capacity ?cap)	

	(test (= (- ?y 1) ?yb))
	(test (= (- ?x 2) ?yw))
	(test (< ?cw ?cap))
	(test (> (- ?y 1) 1))
	(test (< ?lvl ?prof))
   =>
	(assert (robot (- ?y 1) ?x $?aux1 warehouse ?yw ?x (+ ?cw 1) $?aux2 $?aux3 level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

;;==============MOVEMENT DOWN==================
(defrule down-no-box
	?f1 <- (robot ?y ?x $?aux level ?lvl) 
	;;(obstacle ?yo ?xo)	
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	
	(not (obstacle ?x =(+ ?y 1)))
	(test (not(member (create$ warehouse (+ ?y 1)  ?x ) $?aux)))
	(test (not(member (create$ box (+ ?y 1) ?x ) $?aux)))
	;;(test (or (<> (- ?y 1) ?yo ) (<> ?x ?xo)))
	(test (< ?y (- ?yd 1)))
	(test (< ?lvl ?prof))
   =>
	(assert (robot (+ ?y 1) ?x $?aux level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule  down-with-box
	?f1 <- (robot ?y ?x $?aux1 box ?yb ?x $?aux2 level ?lvl)
	(obstacle ?yo ?xo)
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	
	(test (= (+ ?y 1) ?yb))
	(test (not (member (create$ box (+ ?y 2) ?x) $?aux1)))
	(test (not (member (create$ box (+ ?y 2)  ?x ) $?aux2))) 
	(test (not(member (create$ warehouse (+ ?y 2) ?x) $?aux1)))
	;;(test (or (<> (- ?y 2) ?yo ) (<> ?x ?xo)))
	(not (obstacle ?x =(+ ?y 2)))
	(test (< ?y (- ?yo 2))) 
	(test (< ?lvl ?prof))
   =>
	(assert (robot (+ ?y 1) ?x $?aux1 box (+ ?yb 1) ?x $?aux2 level (+ ?lvl 1)))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule down-insert-box
	?f1 <- (robot ?y ?x $?aux1 warehouse ?yw ?x ?cw $?aux2 box ?yb ?x  $?aux3 level ?lvl)
	;;(obstacle ?yo ?xo)
	(grid_dimension ?yd ?xd)
	(max-depth ?prof)
	(warehouse_capacity ?cap)	

	(test (= (+ ?y 1) ?yb))
	(test (= (+ ?x 2) ?yw))
	(test (< ?cw ?cap))
	(test (< ?y (- ?yd 2)))
	(test (< ?lvl ?prof))
   =>
	(assert (robot (+ ?y 1) ?x $?aux1 warehouse ?yw ?x (+ ?cw 1) $?aux2 $?aux3 level (+ ?lvl 1)))
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

(defrule no_SOLUTION
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

)

(deffacts init_map
 (initial-fact)
 (map 8 5)
 (robot 4 1 warehouse 4 8 0 warehouse 1 10 0 box 1 9 box 4 4 level 0)
 (obstacle 3 1)
 (obstacle none none)
 (warehouse_capacity 1)
 (max-depth ?prof)
)