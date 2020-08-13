     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL JMI116 Utility Module')                       *
      *****************************************************************
      *                                                               *
      *  Midas - GL module                                            *
      *                                                               *
      *  XX116003 - JMI116 Compare two alphanumeric values            *
      *                                                               *
      *  Function:  This program will compare two alphanumeric values *
      *             and return a boolean                              *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. JMI116  *CREATE    Date 21Jul20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI116 - Reserve Journal Entry Batch Numbers                 *
      *                                                               *
      *****************************************************************
      *
     D ALPHNUM         C                   CONST('0123456789-
     D                                     ABCDEFGHIJKLMNOPQRSTUVWXYZ')
      *
      *****************************************************************
      *
     C     *Entry        PList
     C                   Parm                    DDBTNB            3
     C                   Parm                    XSBTNB            3
     C                   Parm                    XEBTNB            3
     C                   Parm                    WRANGEOK          1
      *
     C                   ExSr      CompBNums
      *
     C                   SetOn                                        LR
     C                   Return
      *
      *****************************************************************
      *                                                               *
      * CompBNums - Compares the Batch Numbers input as the range     *
      *             against existing defined ranges                   *
      *                                                               *
      *****************************************************************
     C     CompBNums     Begsr
      *
      * Find out if Start Batch Number is less than, equal to or greater than an
      * existing record Start Batch Number
     C                   Move      DDBTNB        W_SBTN            3
     C                   Move      XSBTNB        W_EBTN            3
     C                   Move      *Blanks       W_ELH             1
     C                   ExSr      ValBNumSE
     C                   Move      W_ELH         SS_ELH            1
      *
      * Find out if Start Batch Number is less than, equal to or greater than an
      * existing record End Batch Number
     C                   Move      DDBTNB        W_SBTN
     C                   Move      XEBTNB        W_EBTN
     C                   Move      *Blanks       W_ELH
     C                   ExSr      ValBNumSE
     C                   Move      W_ELH         SE_ELH            1
      *
     C                   If        (SS_ELH = 'H' or SS_ELH = 'E') and
     C                             (SE_ELH = 'L' or SE_ELH = 'E')
     C                   Eval      WRANGEOK = 'Y'
     C                   EndIf
      *
     C                   EndSr
      *
      *****************************************************************
      *                                                               *
      * ValBNumSE - Receives 2 batch numbers and checks which is      *
      *             higher, lower of equal                            *
      *             This is called to validate that End Batch No      *
      *             input is higher than the Start Batch No input     *
      *             and also to compare the input Batch Nos against   *
      *             the Batch numbers off existing records on         *
      *             XXRBNOPD                                          *
      *                                                               *
      *****************************************************************
     C     ValBNumSE     Begsr
      *
     C                   Move      'N'           InvEBNum          1
     C                   Z-Add     1             x                 1 0
     C                   Z-Add     1             yS                2 0
     C                   Z-Add     1             yE                2 0
     C     1             Subst     W_SBTN:x      #CHS              1
     C     #CHS          Scan      ALPHNUM:1     yS                       55
	 *
     C     1             Subst     W_EBTN:x      #CHE              1
     C     #CHE          Scan      ALPHNUM:1     yE                       55
	
      * Checking the valid batch characters, if Position 1 of the End
      * batch number is before the Position 1 of the Start Batch Number
      * then error.
      * If Position 1 of the End batch number is after the Position 1
      * of the Start batch number then OK
      * If equal, then check position 2
     C                   If        yE < yS
     C                   Move      'Y'           InvEBNum
     C                   Move      'H'           W_ELH
     C                   Goto      ValBNumSEE
     C                   EndIf
      *
     C                   If        yE > yS
     C                   Move      'L'           W_ELH
     C                   Goto      ValBNumSEE
     C                   EndIf
      *
     C                   Z-Add     2             x
     C                   Z-Add     1             yS
     C                   Z-Add     1             yE
     C     1             Subst     W_SBTN:x      #CHS              1
     C     #CHS          Scan      ALPHNUM:1     yS                       55
	
     C     1             Subst     W_EBTN:x      #CHE              1
     C     #CHE          Scan      ALPHNUM:1     yE                       55
      *
     C                   If        yE < yS
     C                   Move      'H'           W_ELH
     C                   Move      'Y'           InvEBNum
     C                   Goto      ValBNumSEE
     C                   Endif
     C                   If        yE > yS
     C                   Move      'L'           W_ELH
     C                   Goto      ValBNumSEE
     C                   EndIf
      *
     C                   Z-Add     3             x
     C                   Z-Add     1             yS
     C                   Z-Add     1             yE
     C     1             Subst     W_SBTN:x      #CHS              1
     C     #CHS          Scan      ALPHNUM:1     yS                       55
	
     C     1             Subst     W_EBTN:x      #CHE              1
     C     #CHE          Scan      ALPHNUM:1     yE                       55
      *
      * If checking the 3rd position of Start and End batch number, error if
      * position 3 of the End batch number is before or the same as Position 3
      * of the Start batch number
     C                   If        yE <= yS
     C                   Move      'Y'           InvEBNum
     C                   EndIf
      *
     C                   If        yE < yS
     C                   Move      'H'           W_ELH
     C                   Else
     C                   If        yE > yS
     C                   Move      'L'           W_ELH
     C                   Else
     C                   Move      'E'           W_ELH
     C                   EndIf
     C                   EndIf
      *
     C     ValBNumSEE    Tag
     C                   EndSr
      *****************************************************************
