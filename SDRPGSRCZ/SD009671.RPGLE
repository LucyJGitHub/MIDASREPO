     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate Exchange rate system value')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009671 - Validation program for System Values              *
      *             Reciprocal Interest Rate Tolerance                *
      *                                                               *
      *  Function:  This program validates the New System value       *
      *             Reciprocal Interest Rate Tolerance                *
      *                                                               *
      *  Called By: SD009501                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG23323           Date 14Apr09               *
      *                 BUG21383 *CREATE   Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23323 - Incorrect error message when entering invalid     *
      *             ExchRateTolerance values                          *
      *  BUG21383 - System value for Exchange Rate Tolerance does     *
      *             not accept decimal value in the Current Setting   *
      *             field.                                            *
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
 
     C                   If        PCurVal <> *Blanks
     C                   EVAL      WRETPA = %TRIM(PCurVal)
 
     C                   EVAL      WUZASF = *BLANKS
     C                   MOVEL(P)  WRETPA        WUZASF
      *
      ** Validate alphanumeric input field
      *
     C                   CALL      'ZALIGN'                             90
     C     W0RTN         PARM      W0RTN         WQ0324            7
     C     WUZASF        PARM      WUZASF        WQ0325           16
     C                   PARM      2             WQ0326            1 0
     C                   PARM      3             WQ0327            2 0
     C     WUZAFF        PARM      *BLANK        WQ0328           16
     C                   IF        *IN90 = *ON
     C                   EVAL      PGenErr = 'Y'
     C                   ADD       1             PIdx
     C                   EVAL      PMsgIdar(PIdx) = 'USR8070'
     C                   ENDIF
 
     C                   EVAL      WUERCD = ' '
 
     C                   SELECT
 
     C                   WHEN      W0RTN = *BLANK
      *
      ** Insert decimal pt. and blank out the leading zeroes
      *
     C                   EVAL      WUERCD = 'N'
     C                   CALL      'ZEDIT'                              90
     C     WUZASF        PARM      WUZASF        WQ0329           16
     C                   PARM      2             WQ0330            1 0
 
     C                   IF        *IN90 = *ON
     C                   Eval      PGenErr = 'Y'
     C                   Add       1             PIdx
     C                   Eval      PMsgIdar(PIdx) = 'USR8071'
     C                   ENDIF
 
     C                   WHEN      W0RTN = '*ERROR*'
     C                   EVAL      WUERCD = 'Y'
 
     C                   OTHER
 
     C                   EVAL      WUERCD = 'Y'
     C                   EVAL      *IN99 = *ON
     C                   ENDSL
 
     C                   IF        WUERCD = 'Y'
     C                   Eval      PGenErr = 'Y'
     C                   Add       1             PIdx
     C                   Eval      PMsgIdar(PIdx) = 'USR8009'
     C                   EVAL      WRETPA = %TRIM(PCurVal)
 
     C                   ELSE
 
     C                   MOVE      WUZASF        WRETPA
     C                   MOVE      WUZAFF        WRETPN
      *
      ** Validation for the tolerance
      *
     C     WRETPN        IFGT      100
     C                   Eval      PGenErr = 'Y'
     C                   Add       1             PIdx
     C**********         Eval      PMsgIdar(PIdx) = 'USR8010'                               BUG23323
     C                   Eval      PMsgIdar(PIdx) = 'USR8009'                               BUG23323
     C                   ENDIF
 
     C                   ENDIF
 
     C                   Eval      PCurVal = %Trim(WRETPA)
 
     C                   ENDIF
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
