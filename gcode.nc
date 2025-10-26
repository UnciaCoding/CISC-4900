%
(****************************************************************************)
( Create a rectangular slot 4" long, 0.5" wide, and 0.5" deep                )
( The end mill is 1/8", with 0.05" depth per pass, and 50% overlap           )
( Assuming cut from x=0, y=0 to x=4, y=0.5, and from z=1 down to z=0.5		 )
( Arguments:                                                                 )
(   #100: Tool Diameter                                                    )
(   #101: Depth per Pass                                                   )
(   #102: Slot Width                                                       )
(   #103: Slot Length                                                      )
(   #104: Slot Depth                                                       )
(   #105: Overlap Percentage                                               )
(   #106: Stepover Amount                                                  )
(   #107: Number of Width passes                                           )
(   #108: Number of Depth Passes                                           )
(   #109: X start - based on workpiece                                     )
(   #110: Y start - based on workpiece                                     )
(   #111: Current X                                                        )
(   #112: Current Y                                                        )
(****************************************************************************)

O1000 

(Setup)
(Absolute, Feed per min, XY plane, Inches)
G90 G94 G17 G20 
G54 
S3000 M3 
G0 Z1.5 

(Program Variables)
#100 = 0.125 
#101 = 0.05
#102 = 0.5
#103 = 4.0 
#104 = 0.5 
#105 = 0.5

(Calculate number of passes)
#106 = #100 * #105 
#107 = #102 / #106 
#108 = #104 / #101

(Start position - bottom left corner of slot)
#109 = #100 / 2
#110 = #100 / 2
#111 = #109
#112 = #110 

(DEPTH LOOP - Z axis)
#1 = 1                              (Depth pass counter)
O101 WHILE [#1 LE #108]
    #2 = 1 - #1 * #101 			(Z depth counter)
    O102 IF [#2 LT #104]
	 #2 = #104                            (Don't exceed final depth)
    O102 ENDIF 
    
    (WIDTH LOOP - Y axis)
    #3 = 1                                (Width pass counter)
    #4 = #110                           (Current Y position - reset for each depth layer)
    
    O103 WHILE [#3 LE #107]
        (Move to start position)
        G0 X#109 Y#4
        G0 Z[#2+0.06]                       (Rapid to just above material)
        G1 Z#2 F10                     (Plunge to depth)
        
        (Cut the length)
        G1 X[#109 + [#103-#100/2]] F20                         (Cut forward)
        G0 Z[#2+0.06]                             (Retract)
        
        (Move to next Y position with 50% overlap)
        #4 = #4 + #106
        #3 = #3 + 1
    O103 ENDWHILE 
    
    #1 = #1 + 1
O101 ENDWHILE

G0 Z1.5 
M5 
M30 
%
