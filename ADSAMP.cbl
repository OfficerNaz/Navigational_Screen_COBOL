
      ******************************************************************
      * Copyright Micro Focus International Ltd 1996-1998.
      * All Rights Reserved.
      ******************************************************************

      ****************************************************************
      * This program assumes that the default configuration has been *
      * selected using Adiscf.                                       *
      ****************************************************************

       special-names.
           cursor is cursor-position
           crt status is key-status.

       data division.
       working-storage section. 

      **************************************************
      * Parameters to be used for the x"AF" calls.
      **************************************************
       
       01 set-bit-pairs 		pic 9(2) comp-x value 1.
       01 get-single-character 		pic 9(2) comp-x value 26.
       
       01 enable-esc-and-f1.
           03 filler			pic 9(2) comp-x value 1.
           03 filler			pic x value "1".
           03 filler			pic 9(2) comp-x value 0.
           03 filler   			pic 9(2) comp-x value 2.
      **************************************************
      * enables f5    
      **************************************************
     
       01 enable-f5.
           03 filler			pic 9(2) comp-x value 1.
           03 filler			pic x value "1".
           03 filler			pic 9(2) comp-x value 5.
           03 filler   			pic 9(2) comp-x value 6.     
       
       01 disable-all-other-user-keys.
           03 filler  			pic 9(2) comp-x value 0.
           03 filler   			pic x value "1".
           03 filler  			pic 9(2) comp-x value 6.
           03 filler  			pic 9(2) comp-x value 126.
       
       
       01 enable-slash-key.
           03 filler  			pic 9(2) comp-x value 1. 
           03 filler    		pic x value "3".
           03 filler			pic x value "/".
           03 filler			pic 9(2) comp-x value 1. 
           
           

      **************************************************
      * Status returned after termination of an ACCEPT.
      **************************************************
       01 key-status.
           03 key-type			pic x.
           03 key-code-1 		pic 9(2) comp-x.
           03 key-code-1-x		redefines key-code-1 pic x.
           03 key-code-2  		pic 9(2) comp-x.
       
      **************************************************
      * Cursor-Position is returned by ADIS containing 
      * the position of the cursor when the ACCEPT was 
      * terminated.
      ***************************************************
       01 cursor-position.
           03 cursor-row  		pic 99.
           03 cursor-column  		pic 99.
       
      **************************************************
      * Work areas used by the program.
      ************************************************** 
       01 work-areas.
           03 wa-name   		pic x(30).
           03 wa-address-line-1		pic x(40).
           03 wa-address-line-2		pic x(40).
           03 wa-address-line-3		pic x(40).
           03 wa-address-line-4		pic x(40).
           03 wa-age  			pic 999 value 0.
       
       01 exit-flag   			pic 9(2) comp-x value 0.
       
       
      **************************************************
      * Screen Section.
      **************************************************
       screen section.
       
       01 main-screen.
           03 blank screen.
           03 line 2 column 27 
               value "Typical Data Entry Screen".
           03 line 3 column 27 
               value "-------------------------".
           03 line 5 column 1 value "name     [".
           03 pic x(30) using wa-name highlight prompt " ".
           03 value "]".
           03 line 7 column 1 value "address  [".
           03 pic x(40) using wa-address-line-1 highlight prompt " ".
           03 value "]".
           03 line 8 column 1 value "         [".
           03 pic x(40) using wa-address-line-2 highlight prompt " ".
           03 value "]".
           03 line 9 column 1 value "         [".
           03 pic x(40) using wa-address-line-3 highlight prompt " ".
           03 value "]".
           03 line 10 column 1 value "         [".
           03 pic x(40) using wa-address-line-4 highlight prompt " ".
           03 value "]".
           03 line 12 column 1 value "age      [".
           03 pic zz9 using wa-age highlight prompt " ".
           03 value "]".
           
      ***************************************************
      * Adding telephone to the list in the main page   
      ***************************************************    
           03 line 14 column 1 value "Telephone[".
           03 pic 999,999,9999.
           03 value "]"
           
      ***************************************************
      *Adding gender to the list in the main page
      ***************************************************     
           03 line 16 column 1 value "Gender   [".
           03 pic A.
           03 value "]"
           
           03 line 20 column 1 value
              "---------------------------------------------------------
      -       "-----------------------".
           03 line 21 column 1 value "f1" highlight.
           03 value "=".
           03 value "/h" highlight.
           03 value "elp".
           
      ************************************************** 
      *Adding f5 as an option in the main page
      **************************************************
      
           03 column 30 value "f5/Student Info" highlight.
           03 column 75 value "esc" highlight.
           03 value "ape".
       
       01 help-screen.
           03 blank screen.
           03 line 1 column 34 value "Help Screen".
           03 line + 1 column 34 value "-----------".
           03 line 4 value "escape" highlight.
           03 value "     Quit this program.".
           03 line 6 column 1 value "f1 or /h" highlight.
           03 value "   View this help screen.".
           03 line 8 column 1 
               value "Use the cursor keys to move around ".
           03 value "the fields on the screen.". 
           03 value " Pressing enter".
           03 line + 1 column 1 value "accepts the data ".
           03 value "and presents a new blank form to fill in.".
           03 line 24 column 25 
               value "Press any key to continue ...".
      **********************************************************
      *New Screen triggered by the f5 key
      **********************************************************
      
       01 third-screen.
           03 blank screen.
           03 line 2 column 27 
               value "******Student info******".
           03 line 3 column 27 
               value "-------------------------".
           03 line 5 column 5 value "Name: Naz Sassine"
           03 line 7 column 5 value "Student ID: 040979531"
           03 line 9 column 5 value 
           "Program of study: Compute Programming".
       
      **************************************************
      * Procedure Division.
      **************************************************
       
       procedure division.
       entry-point section.
       
      * First we want to ensure that the keys are enabled as we want
      * them. Enable the Escape and F1 keys.
       
           call x"AF" using set-bit-pairs 
                            enable-esc-and-f1
           
      * Enables the f2 key.
      
           call x"AF" using set-bit-pairs 
                            enable-f5
           
      * disable every other user function key. 
           call x"AF" using set-bit-pairs
                            disable-all-other-user-keys
       
      * set up "/" key to act as a function key and terminate 
      * the ACCEPT operation.
       
           call x"AF" using set-bit-pairs 
                            enable-slash-key
           
           
    
      * Now ensure that the cursor position will be returned when an
      * ACCEPT is terminated. Setting to row 1, column 1 will ensure
      * that the cursor will be initially positioned at the start of 
      * the first field.
       
           move 1 to cursor-row
           move 1 to cursor-column
       
      * Loop until the Escape key is pressed.
       
           perform until exit-flag = 1
               display main-screen
               accept main-screen
               evaluate key-type
                 when "0"
       
      * The ACCEPT operation terminated normally; that is the Enter key
      * was pressed. In this case, we simply blank out the work areas
      * and restart in the first field.
       
                   initialize work-areas
                   move 1 to cursor-row
                   move 1 to cursor-column
       
                 when "1"
       
      * A user function key has been pressed. This will either be
      * Escape or F1 as all others have been disabled.
       
                   if key-code-1 = 0
      
      * Escape has been pressed, so we wish to leave the program.
       
                       move 1 to exit-flag
                   
                       else if
                           key-code-1 = 1
      
      * F1 has been pressed so display the help screen. 
                       perform display-help-screen
                       
                       else 
      * If any key that isn't f1 or the escape is pressed, then
      *the third page is displayed.
      
                        perform display-third-screen   
                  end-if
       
                 when "3"
       
      * A data key has terminated the ACCEPT operation. It must be "/"
      * as no other keys have been enabled to do this. Now get the 
      * next character to see if "H" or "h" has been pressed.
       
                   call x"AF" using get-single-character
                                    key-status
                   if key-type = "3" and
                     (key-code-1-x = "h" or 
                      key-code-1-x = "H")
                       perform display-help-screen
                   end-if
       
               end-evaluate
           end-perform
           stop run.
       
       display-help-screen section.
      
      * Display the help screen and then wait for a key to be pressed.
       
           display help-screen
           call x"AF" using get-single-character
                            key-status.
           
      * Displays the third screen                     
       display-third-screen section.
           
           display third-screen
            call x"AF" using get-single-character
                            key-status. 
           
              
