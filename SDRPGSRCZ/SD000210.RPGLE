     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validation Pgm for WHTDftMtrxPriorities')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000210 - Validation program for System Value               *
      *             WHTDftMtrxPriorities                              *
      *                                                               *
      *  Function:  This program validates the New System value       *
      *             for WHT Default Matrix Priority definition        *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165  *CREATE    Date 23Feb15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D ARR1            S              1    DIM(9)
 
     D PMsgIdar        S                   DIM(99)  LIKE(PErrMsgid)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PErrMsgid       S              7A
     D PRtcd           S              7A
     D POptn           S              7A
     D PSysVal         S             20A
     D PCurVal         S            200A
     D PProcMod        S            190A
     D PGenErr         S              1A
     D PIdx            S              2P 0
     D X               S              2  0
     D Y               S              2  0
     D WRETPA          S              6A
     D WRETPN          S              5S 2
     D WUZASF          S             16A
     D WUZAFF          S             16A
     D W0RTN           S              7A
     D WUERCD          S              1A   INZ(*BLANKS)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
     C                   Eval      PGenErr = *Blanks
 
      * Error if blanks
B1   C                   If        PCurVal = *Blanks
     C                   EVAL      PGenErr = 'Y'
     C                   ADD       1             PIdx
     C                   EVAL      PMsgIdar(PIdx) = 'USS0557'
      *
X1   C                   Else
      *
      * Move Current Value to array
     C                   MoveA     PCurVal       ARR1
      *
      *If any position is not a number between 0 and 9 error
     C                   Z-ADD     1             X
     C     X             DOUEQ     10
      *
B2   C                   IF        ARR1(X) < '0' or ARR1(X) > '9'
     C                   EVAL      PGenErr = 'Y'
     C                   ADD       1             PIdx
     C                   EVAL      PMsgIdar(PIdx) = 'USS0557'
E2   C                   ENDIF
      *
     C                   ADD       1             X
     C                   ENDDO
      *
      * If no error, check that no number apart from 0 is defined twice
B2   C                   IF        PGenErr = *Blanks
      *
     C                   Z-ADD     1             Y
     C                   Z-ADD     1             X
     C     X             DOUEQ     10
      *
B3   C                   IF        ARR1(X) <> '0'
     C     X             ADD       1             Y
     C     Y             DOWNE     10
B4   C                   IF        ARR1(Y) = ARR1(X)
     C                   EVAL      PGenErr = 'Y'
     C                   ADD       1             PIdx
     C                   EVAL      PMsgIdar(PIdx) = 'USS0558'
E4   C                   ENDIF
     C                   ADD       1             Y
     C                   ENDDO
      *
E3   C                   ENDIF
      *
     C                   ADD       1             X
     C                   ENDDO
      *
E2   C                   ENDIF
      *
      * If no error so far, check that Transaction Type is there if Module is included
B3   C                   IF        ARR1(8) <> '0'
     C                             AND ARR1(7) = '0'
     C                   EVAL      PGenErr = 'Y'
     C                   ADD       1             PIdx
     C                   EVAL      PMsgIdar(PIdx) = 'USS0559'
E2   C                   ENDIF
      *
E1   C                   ENDIF
      *
      ** Ending the program
      *
     C                   Eval      *INLR = *On
     C                   Return
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    PSysVal
     C                   PARM                    PCurVal
     C                   PARM                    PProcMod
     C                   PARM                    PGenErr
     C                   PARM                    PIdx
     C                   PARM                    PMsgIdar
 
     C                   ENDSR
 
      *
