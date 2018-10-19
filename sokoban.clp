;;============================================
;;============ S O K O B A N =================
;;============================================

(defrule goal
    (declare (salience 100))
    ?f <- (robot $?all level ?lvl)
	(test (not (member box $?all)))
   =>
    (printout t "SOLUTION FOUND AT LEVEL " ?lvl crlf)
    (printout t "GOAL FACT " ?f crlf)
    
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
	(assert (gridsize 8 5))
	(assert (obstacle 2 4))
	(assert (robot 2 4 warehous 2 7 0 level 0)) 
	(assert (max-depth ?prof))

)
