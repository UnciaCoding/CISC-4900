%
(****************************************************************************)
( Create a rectangular slot 4" long, 0.5" wide, and 0.5" deep                )
( The end mill is 1/8", with 0.05" depth per pass, and 50% overlap           )
( Assuming cut from x=0, y=0 to x=4, y=0.5, and from z=1 down to z=0.5		 )
( Arguments:                                                                 )
(   #<toolDiam>: Tool Diameter                                                    )
(   #<passDepth>: Depth per Pass                                                   )
(   #<slotW>: Slot Width                                                       )
(   #<slotL>: Slot Length                                                      )
(   #<slotD>: Slot Depth                                                       )
(   #<overPer>: Overlap Percentage                                               )
(   #<stepOver>: Stepover Amount                                                  )
(   #<nPassesW>: Number of Width passes                                           )
(   #<nPassesD>: Number of Depth Passes                                           )
(   #<xStart>: X start - based on workpiece                                     )
(   #<yStart>: Y start - based on workpiece                                     )
(   #<currX>: Current X                                                        )
(   #<currY>: Current Y                                                        )
(****************************************************************************)

O1000 

(Setup)
(Absolute, Feed per min, XY plane, Inches)
G90 G94 G17 G20 
G54 
S3000 M3 
G0 Z1.5 

(Program Variables)
#<toolDiam> = 0.125 
#<passDepth> = 0.05
#<slotW> = 0.5
#<slotL> = 4.0 
#<slotD> = 0.5 
#<overPer> = 0.5

(Calculate number of passes)
#<stepOver> = [#<toolDiam> * #<overPer>] 
#<nPassesW> = [#<slotW> / #<stepOver>]
#<nPassesD> = [#<slotD> / #<passDepth>]

(Start position - bottom left corner of slot)
#<xStart> = [#<toolDiam> / 2]
#<yStart> = [#<toolDiam> / 2]
#<currX> = #<xStart>
#<currY> = #<yStart> 

(DEPTH LOOP - Z axis)
#1 = 1                              (Depth pass counter)
O101 WHILE [#1 LE #<nPassesD>]
    #2 = [1 - [#1 * #<passDepth>]]			(Z depth counter)
    O102 IF [#2 LT #<slotD>]
	 #2 = #<slotD>                            (Don't exceed final depth)
    O102 ENDIF 
    
    (WIDTH LOOP - Y axis)
    #3 = 1                                (Width pass counter)
    #4 = #<yStart>                           (Current Y position - reset for each depth layer)
    
    O103 WHILE [#3 LE #<nPassesW>]
        (Move to start position)
        G0 X#<xStart> Y#4
        G0 Z[#2+0.06]                       (Rapid to just above material)
        G1 Z#2 F10                     (Plunge to depth)
        
        (Cut the length)
        G1 X[#<xStart> + [#<slotL>-#<toolDiam>/2]] F20                         (Cut forward)
        G0 Z[#2+0.06]                             (Retract)
        
        (Move to next Y position with 50% overlap)
        #4 = [#4 + #<stepOver>]
        #3 = [#3 + 1]
    O103 ENDWHILE 
    
    #1 = [#1 + 1]
O101 ENDWHILE

G0 Z1.5 
M5 
M30 
%
