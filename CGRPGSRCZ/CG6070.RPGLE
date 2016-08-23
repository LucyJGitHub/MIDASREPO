     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG LE rollover rate fixed advices driver')       *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG6070 - Lending Rollover Rate Fixed Advices - Driver        *
      *                                                               *
      *  Function:  This program drives the customer correspondence   *
      *             extract file process that is required for product-*
      *             ion of the Lending Rollover Rate Fixing Advices   *
      *             through UDC.                                      *
      *                                                               *
      *             This is submitted automatically in I/C after loan *
      *             rate fixing process has been requested or will    *
      *             run daily as part of the COB after the daily loan *
      *             rate fixing process has been run. This processes  *
      *             any loans flagged as requiring a rate fixed ad-   *
      *             vice.                                             *
      *                                                               *
      *  Called By: LEC3165 - Rollover Rate Fixing Advices Control    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CLE042             Date 06Sep05               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CLE011  *CREATE    Date 07Nov00               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *                                                               *
      *  10 - File access indicator for LELOANL0                      *
      *                                                               *
      *  U7+U8 - Database error occurs                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRMain - Controls main flow of program.                      *
      *  SRInitial - Initial processing.                              *
      *  SRAudit - Calls CG9020 and CGZAUDIT to do auditing.          *
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
 
     FLELOANL0  IF   E           K DISK    INFSR(*PSSR)
      ** Live Loans details
 
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
 
     D PEDsCGUDTAPD  E DS                  EXTNAME(CGUDTAPD)
      ** Data structure for UDC extract file
 
     D PDsParm         DS           256
     D**PLoanRef               1      6S 0                                                    CLE148
     D  PLoanRef               1      6A                                                      CLE148
     D**PCustNum               7     12S 0                                                    CSD027
     D  PCustNum               7     12A                                                      CSD027
     D  PBrch                 13     15A
     D  POrigBrch             16     18A
     D  PCommit               19     21A
 
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
      *  Calls:     CG6075, SRAudit, SRERR                            *
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
     C                   READ      LELOANL0                               10
      *
     C                   DOW       *IN10 = *OFF
      *
      ** Increment number of records read
     C                   ADD       1             WNumRec
      *
     C                   IF        RFAR = 'Y'
      *
     C**********         Z-ADD     LNRF          PLoanRef                                     CLE148
     C                   MOVEL     LNRF          PLoanRef                                     CLE148
     C**********         Z-ADD     CNUM          PCustNum                                     CSD027
     C                   EVAL      PCustNum=CNUM                                              CSD027
     C                   MOVE      BRCA          PBrch
     C                   MOVE      ORBR          POrigBrch
     C                   MOVE      P0Commit      PCommit
     C                   CALL      'CG6075'
     C                   PARM                    PRtnCode
     C                   PARM                    PDsParm
     C                   IF        PRtnCode <> *BLANKS
     C                   EXSR      SRAudit
     C                   MOVEL     'CG7075  '    W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      LELOANL0                               10
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
      *  Calls:     CGZAudit                                          *
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
     C                   MOVEL     'CG6070AU'    I#SPLN
     C                   MOVEL     'CG6070  '    I#REF
     C                   MOVEL     'CGD2539'     I#TITL
     C                   MOVEL     'CGD2540'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
      *
     C                   CALL      'CGZAUDIT'
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
      *  SRAudit - Calls CG9020 and CGZAUDIT to do auditing.          *
      *                                                               *
      *  Called by: Main processing, SRMain                           *
      *                                                               *
      *  Calls:     CGZAUDIT, CG9020                                  *
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
     C                   MOVEL     'CG6070 '     I#REF
     C                   MOVEL     'CGD2539'     I#TITL
     C                   MOVEL     'CGD2540'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVEL     'CLOANB'      I#SUB
     C                   MOVEL     'CAD1021'     I#TEXT
     C                   Z-ADD     WNumRec       I#QTY
     C                   Z-ADD     *ZERO         I#DECS
     C                   MOVEL     '1'           I#EDIT
      *
      ** Write line of text
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*LINE   '    PAction8
     C                   PARM                    I#DTA
     C                   PARM                    PSequence
      *
      ** Skip a line
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*SKIP   '    PAction8
     C                   PARM                    I#DTA
     C                   PARM                    PSequence
      *
      ** Produce the Audit report
     C                   CALL      'CG9020'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*AUDIT  '    PAction8
     C                   PARM      *BLANKS       PPath
     C                   PARM                    PEDsCGUDTAPD
     C                   PARM      'CGD2539'     I#TITL
     C                   PARM      'CGD2540'     I#TUL
     C                   PARM      P0Commit      PCommit
      *
      ** Close Audit Printer file
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG6070 '     I#REF
     C                   MOVEL     'CGD2539'     I#TITL
     C                   MOVEL     'CGD2540'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
      *
     C                   CALL      'CGZAUDIT'
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
     C/COPY CGCPYSRC,SRERRCLE
      /EJECT
     C/COPY CGCPYSRC,SRERRPSSRL
      /EJECT
      *****************************************************************
