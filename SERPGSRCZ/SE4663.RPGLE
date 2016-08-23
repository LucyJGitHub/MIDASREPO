     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE CG Statement - Driver')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  SE4663 - Midas CG SE Statement - Driver                      *
      *                                                               *
      *  Function:  This program drives the customer correspondence   *
      *             extract file process that is required for product-*
      *             ion of SE Statements through Correspondence       *
      *             Manager.                                          *
      *                                                               *
      *  Called By   : SEC4651 - SE Statement Processing              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSE040  *CREATE    Date 24Mar03               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *                                                               *
      *  U7+U8 - Database error occurs                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRMain - Controls main flow of program.                      *
      *  SRInitial - Initial processing.                              *
      *  SRAudit - ZAZAUDIT to do auditing.                           *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSESDRVL4  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Statement - Driver file - Generation Flag
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data structure for access objects, first DS
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data structure for access objects, second DS
 
     D PDsSDRV       E DS                  EXTNAME(SESDRVPD)
      ** Midas SE Statement - Driver File
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WNumRec         S             15P 0
      ** Number of records read from the input file
 
      ** Parameter fields
     D PAction8        S              8A
     D PPath           S            256A
     D POption         S              7A
     D PRtnCode        S              7A
     D PSequence       S              5A
     D PCommit         S              3A
 
      ** Entry parameter fields
     D P0RtnCde        S              7A
     D P0Commit        S              3A
 
     D/COPY CGCPYSRC,SRERRDLE
      ** Fields, data structures, arrays definition for CG error processing
 
     D/COPY CGCPYSRC,CGAUDTDLE
      ** Fields, data structures, arrays definition for CG audit processing
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN      '  @STK(Q)
      *
      ** Initial processing
      *
     C                   EXSR      SRInitial
      *
      ** Execute main subroutine
      *
     C                   EXSR      SRMain
      *
      ** Audit processing
      *
     C                   EXSR      SRAudit
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      ** Termination
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Controls main flow of program.                      *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     SE4665, SRAudit, SRERR                            *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRMain    '  @STK(Q)
      *
      ** Read a record from the input file
      *
     C     *LOVAL        SETLL     SESDRVL4
     C                   READ      SESDRVL4
      *
     C                   DOW       NOT %EOF(SESDRVL4)
      *
      ** Increment number of records read
     C                   ADD       1             WNumRec
      *
     C                   SELECT
      *
     C                   WHEN         SPTYPE = 'TF'                             Trade/Complete
     C                             OR SPTYPE = 'VF'                             Value/Complete
     C                             OR SPTYPE = 'SF'                             Settle/Complete
     C                             OR SPTYPE = 'TC'                             Trade/Change
     C                             OR SPTYPE = 'VC'                             Value/Change
     C                             OR SPTYPE = 'SC'                             Settle/Change
      *
     C                   CALLB     'SE4665'
     C                   PARM      *Blanks       PRtnCode
     C                   PARM                    PDsSDRV
     C                   PARM      P0Commit      PCommit
      *
     C                   IF        PRtnCode <> *BLANKS
     C                   EXSR      SRAudit
     C                   MOVEL     'SE4665  '    W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   WHEN         SPTYPE = 'MF'                             Transaction
      *
     C                   CALLB     'SE4666'
     C                   PARM      *Blanks       PRtnCode
     C                   PARM                    PDsSDRV
     C                   PARM      P0Commit      PCommit
      *
     C                   IF        PRtnCode <> *BLANKS
     C                   EXSR      SRAudit
     C                   MOVEL     'SE4666  '    W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     2             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   READ      SESDRVL4
      *
     C                   ENDDO
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitial - Initial processing.                              *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     ZAZAudit                                          *
      *                                                               *
      *****************************************************************
     C     SRInitial     BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRInitial '  @STK(Q)
      *
      ** Open the Audit Print file
      *
     C                   CLEAR                   I#DTA
     C                   MOVEL     'SE4663AU'    I#SPLN
     C                   MOVEL     'SE4663  '    I#REF
     C                   MOVEL     'CGD2623'     I#TITL
     C                   MOVEL     'CGD2624'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
      *
     C                   CALL      'ZAZAUDIT'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*OPEN   '    PAction8
     C                   PARM                    I#DTA
     C                   PARM                    PSequence
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Calls CGZAUDIT to do auditing.                     *
      *                                                               *
      *  Called by: Main processing, SRMain                           *
      *                                                               *
      *  Calls:     CGZAUDIT                                          *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
      *
      ** Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRAudit   '  @STK(Q)
      *
      ** Output the count of records read
      *
     C                   CLEAR                   I#DTA
     C                   MOVEL     'SE4663 '     I#REF
     C                   MOVEL     'CGD2623'     I#TITL
     C                   MOVEL     'CGD2624'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVEL     'SESDRVL4'    I#SUB
     C                   MOVEL     'CAD1021'     I#TEXT
     C                   Z-ADD     WNumRec       I#QTY
     C                   Z-ADD     *ZERO         I#DECS
     C                   MOVEL     '1'           I#EDIT
      *
      ** Write line of text
     C                   CALL      'ZAZAUDIT'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*LINE   '    PAction8
     C                   PARM                    I#DTA
     C                   PARM                    PSequence
      *
      ** Skip a line
     C                   CALL      'ZAZAUDIT'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*SKIP   '    PAction8
     C                   PARM                    I#DTA
     C                   PARM                    PSequence
      *
      ** Close Audit Printer file
     C                   CLEAR                   I#DTA
     C                   MOVEL     'SE4663 '     I#REF
     C                   MOVEL     'CGD2623'     I#TITL
     C                   MOVEL     'CGD2624'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
      *
     C                   CALL      'ZAZAUDIT'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*CLOSE  '    PAction8
     C                   PARM                    I#DTA
     C                   PARM                    PSequence
      *
      ** Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialization routine                               *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls:     None.                                             *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM      W0RTN         P0RtnCde
     C                   PARM                    P0Commit
      *
     C                   MOVEL     ##PGM         DBPGM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,SRERRCLE
      /EJECT
     C/COPY ZACPYSRC,SRERRPSSRL
      /EJECT
      *****************************************************************
