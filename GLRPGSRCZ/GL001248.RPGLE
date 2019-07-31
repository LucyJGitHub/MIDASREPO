     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL RWA netted balances report')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001248 - RWA Netted Balances Report                        *
      *                                                               *
      *  Function:  This report lists all netting groups in Primary   *
      *             then secondary account order, showing original    *
      *             balances for each account, the netted balance and *
      *             the net weighted balance for each group.          *
      *                                                               *
      ** +---------------------------------------------------------+ **
      *                                                               *
      *  Component of: GL001248                                       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL018  *CREATE    Date 10Oct02               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *   37  - Multibranching ON                                     *
      *                                                               *
      *   86  - LOOKUP                                                *
      *   87  - CHAIN GLRWABL1                                        *
      *   88  - READ GLNETGL6                                         *
      *   89  - READ SDRWASL1                                         *
      *                                                               *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      *   90-99 - Used by Standard Subroutines                        *
      *                                                               *
      *   U7+U8 - Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  PROCES - Detail Processing                                   *
      *  REPORT - Process Report Lines                                *
      *  WP1END - Write End of Report                                 *
      *  AUDIT  - Produce Audit Report and End Program                *
      *  RCFP1  - RCF Processing for P1 Report                        *
      *  RCFAU  - RCF Processing for Audit Report                     *
      *                                                               *
      * *PSSR - Error processing                                      *
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
 
     FSDRWASL1  IF   E           K DISK
      * Risk Weighted Asset Master File Retrieval Index
 
     FGLRWABL1  IF   E           K DISK
      * General Ledger Risk Weighted Assets Balance file
 
     FGLNETGL6  IF   E           K DISK
     F                                     PREFIX(L6)
      * Risk Weighted Asset Netting Group by Confirmed
 
     FGL001248AUO    E             PRINTER INFDS(SPOOLU)
      * Midas GL RWA Netted Balances List
 
     FGL001248P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
      * Midas GL RWA Netted Balances Audit Report
 
      *****************************************************************
      /EJECT
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      **  Array For ZEDIT And ZALIGN
     D/COPY ZSRSRC,ZALIGNZ1LE
 
      ***  File Information Data Structure for GL001248P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ***  File Information Data Structure for GL001248AU.
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ***  Dummy Data Structures used by Access Programs.
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ***  Dummy Data Structures used by Access Programs.
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ***  External data structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ***  External data structures for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ***  External data structures for XXXXXXXXXX
     D GLRWAB        E DS                  EXTNAME(GLRWABPD)
 
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D DSRWAB          DS
     D  WBRECI                 1      1
     D  WBSETS                20     55    DIM(36)
     D    A#SET                       1    OVERLAY(WBSETS)
     D  WBBALS                56    343    DIM(36)
     D    A#BAL                      15P 0 OVERLAY(WBBALS)
      *
     D                 DS
     D T#6C                    1      6
     D*T#6N*****                      6  0 OVERLAY(T#6C)                                      CSD027
     D T#6N                           6    OVERLAY(T#6C)                                      CSD027
      *
     D                 DS
     D***T#4C***                 1      4                                                     CGL029
     D***T#4N***                        4  0 OVERLAY(T#4C)                                    CGL029
     D T#4C                    1     10                                                       CGL029
     D T#4N                          10  0 OVERLAY(T#4C)                                      CGL029
      *
     D                 DS
     D T#2C                    1      2
     D T#2N                           2  0 OVERLAY(T#2C)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WRun            S              1A
     D PSEQ            S              5A
     D WRTCD           S              7A
     D WOPTN           S              7A
     D RQDLN1          S              3  0
     D DIFLN1          S              3  0
     D SEQ             S              5A
     D SENTY           S              3A
     D ZSERR           S              1A
     D ZSNUM           S              6  0
     D SETN            S              2  0
     D RCOUNT          S              5  0
     D P#CCY           S              3
     D SUMOFSEC        S             15  0
     D RWB             S             15  0
     D PAB             S             15  0
     D NEXTPRIM        S              1
 
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
      *
      ***  Perform Detail Processing.
      *
     C                   EXSR      PROCES
      *
      ***  Output Audit Report and End Program.
      *
     C                   EXSR      AUDIT
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PROCES - SR to do the detail processing                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *  AUDIT  - Produce audit report and end program                *
      *  RCFP1  - Record P1 spool file on RCF                         *
      *  REPORT - Process Report Lines                                *
      *  WP1END - Write end of report                                 *
      *                                                               *
      *****************************************************************
      *
     C     PROCES        BEGSR
      *
     C                   EVAL      RCOUNT = 0
      *
     C**** *LOVAL        SETLL     SDRWASL1                                     CGL018
     C****               READ      SDRWASL1                               89    CGL018
     C     *LOVAL        SETLL     GLNETGL6                                     CGL018
     C                   READ      GLNETGL6                               89    CGL018
      *
      ***  If EOF report no records
      *
B1   C                   IF        *IN89 = *on
     C                   EXSR      AUDIT
X1   C                   ELSE
      *
      ***  If record read, ensure spool file P1 recorded by RCF
      *
     C                   OPEN      GL001248P1
     C                   EXSR      RCFP1
E1   C                   ENDIF
      *
      ***  Main Process
      *
     C                   EVAL      SETN = 1
     C*****              EVAL      RCOUNT = 0                                   CGL018
     C     *LOVAL        SETLL     SDRWASL1
     C                   MOVE      *OFF          *IN89
      *
B1   C                   DOW       *IN89 = *OFF
     C                   READ      SDRWASL1                               89
      *
     C                   IF        RWRECI = '*' OR
     C                             *IN89
     C                   ITER
     C                   ENDIF
      *
      ***  Process report detail lines.
      *
     C*****              EVAL      RCOUNT1 = RCOUNT1 + 1                        CGL018
     C                   MOVE      RWSETN        RRSET
     C                   WRITE     HEADP1
     C                   EXSR      REPORT
                                                                                CGL018
      ** Print total line                                                       CGL018
     C                   EXSR      SRDETSE3                                     CGL018
     C                   EVAL      SETN = SETN + 1                              CGL018
                                                                                CGL018
E1   C                   ENDDO
      *
      *****Print*Sumary For Last Group                                          CGL018
      *
     C*****              EXSR      SRDETSE3                                     CGL018
      *
      ***  Write final records and totals to report
      *
     C                   EXSR      WP1END
     C                   ENDSR
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * REPORT - Process Report Lines                                 *
      *                                                               *
      * Called by: PROCES                                             *
      *                                                               *
      * Calls:                                                        *
      *  RtvCcySR - Retrieve ccy details                              *
      *                                                               *
      *****************************************************************
      *
     C     REPORT        BEGSR
      *
     C                   MOVE      *OFF          *IN88
     C                   MOVE      *BLANK        PRINTSUM
     C     *LOVAL        SETLL     GLNETGL6
     C                   READ      GLNETGL6                               88
      *
B1   C                   DOW       *IN88 = *OFF
      *
B2   C                   IF        L6RWRECI <> '*' AND
     C                             *IN88 = *OFF
                                                                                CGL018
     C                   IF        SETN = 1                                     CGL018
     C                   EVAL      RCOUNT1 = RCOUNT1 + 1                        CGL018
     C                   ENDIF                                                  CGL018
      *
      ***  Primary Acc
      *
B3   C                   IF        L6RWPRIM = 'P'
     C                   MOVE      *BLANK        NEXTPRIM
      *
      ***  Print Sumary
      *
     C                   IF        PRINTSUM = 'Y'
     C                   EXSR      SRDETSE3
     C                   ENDIF
      *
      ***  Retrieve And Store RWA Balance
      *
     C     K#WAB1        CHAIN     GLRWABL1                           87
      *
      ***  If record not found account is not reported
      *
     C                   IF        *IN87 = *ON
     C                   CLEAR                   DSRWAB
     C                   ELSE
      *
     C                   CLEAR                   DSRWAB
     C                   MOVEL     GLRWAB        DSRWAB
     C                   ENDIF
 
     C                   Z-ADD     1             I                 2 0
     C     RWSETN        LOOKUP    A#SET(I)                               86
     C                   IF        *IN86 = *OFF
     C                   MOVE      'Y'           NEXTPRIM
     C                   GOTO      NEXTREC
     C                   ELSE
     C                   Z-ADD     0             RWB
     C                   MOVEA     A#BAL(I)      RWB
     C                   ENDIF
      *
      ***  Store Primary Acc Balance
      *
     C                   Z-ADD     0             PAB
     C*****              Z-ADD     L6RWSBAL      PAB                            CGL018
     C                   Z-ADD     L6RWPBAL      PAB                            CGL018
      *
     C                   EVAL      T#6N = L6RWPCUST
     C                   EVAL      T#4N = L6RWPACOD
     C                   EVAL      T#2N = L6RWPACSQ
     C                   EVAL      RRPACC = L6RWPBRCA + '-' + T#6C + '-' +
     C                                      L6RWPCCY + '-' + T#4C + '-' + T#2C
      *
     C                   EVAL      P#CCY = L6RWPCCY
     C                   EXSR      RtvCcySR
     C*****              IF        PAB < 0                                      CGL018
     C                   IF        L6RWSBAL < 0                                 CGL018
     C                   EVAL      RRDRCR = 'CR'
     C                   EVAL      L6RWSBAL = L6RWSBAL * -1                     CGL018
     C                   ELSE
     C                   EVAL      RRDRCR = 'DR'
     C                   ENDIF
      *
     C*****              IF        PAB < 0                                      CGL018
     C*****PAB           MULT      -1            PAB                            CGL018
     C*****              ENDIF                                                  CGL018
      *
     C*****              MOVE      *BLANK        ZFIELD           16            CGL018
     C*****              MOVE      PAB           ZFIELD                         CGL018
     C                   Z-ADD     L6RWSBAL      ZFLD15           15 0          CGL018
     C                   Z-ADD     A6NBDP        ZADEC             1 0
     C*****              CALL      'ZEDIT'                                      CGL018
     C                   CALLB     'ZSEDIT'                                     CGL018
     C*****              PARM                    ZFIELD                         CGL018
     C                   PARM                    ZFLD15                         CGL018
     C                   PARM                    ZADEC
     C                   PARM      'J'           ZECODE            1            CGL018
     C                   PARM      *blanks       ZFIELD           21            CGL018
     C                   MOVE      ZFIELD        RRBAL1
      *
     C*****              EVAL      RQDLN1 = 1                                   CGL018
     C                   EVAL      RQDLN1 = 2                                   CGL018
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
     C                   WRITE     DETPRI
      *
     C                   MOVE      'Y'           FIRSTSEC          1
     C                   MOVE      'Y'           PRINTSUM          1            CGL018
      *
      ***  Secondary Acc
      *
X3   C                   ELSE
      *
     C                   IF        NEXTPRIM = 'Y'
     C                   GOTO      NEXTREC
     C                   ENDIF
      *
     C*****              MOVE      'Y'           PRINTSUM          1            CGL018
      *
      ***  Print Secondary Text
      *
     C                   IF        FIRSTSEC = 'Y'
     C                   EVAL      RQDLN1 = 1
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     DETSE1
     C                   MOVE      *BLANK        FIRSTSEC
     C                   ENDIF
      *
      ***  Print Secondary Acc + Balances
      *
     C                   EVAL      T#6N = L6RWCUST
     C                   EVAL      T#4N = L6RWACOD
     C                   EVAL      T#2N = L6RWACSQ
     C                   EVAL      RRSACC = L6RWBRCA + '-' + T#6C + '-' +
     C                                      L6RWCCY + '-' + T#4C + '-' + T#2C
      *
     C                   IF        L6RWSBAL < 0
     C                   EVAL      RRDRCR = 'CR'
     C                   ELSE
     C                   EVAL      RRDRCR = 'DR'
     C                   ENDIF
      *
     C                   IF        L6RWSBAL < 0
     C     L6RWSBAL      MULT      -1            L6RWSBAL
     C                   ENDIF
      *
     C                   MOVE      *BLANK        ZFIELD
     C*****              MOVE      L6RWSBAL      ZFIELD                         CGL018
     C                   Z-ADD     L6RWSBAL      ZFLD15                         CGL018
     C*****              EVAL      SUMOFSEC = SUMOFSEC + L6RWSBAL               CGL018
     C                   Z-ADD     A6NBDP        ZADEC
     C*****              CALL      'ZEDIT'                                      CGL018
     C                   CALLB     'ZSEDIT'                                     CGL018
     C*****              PARM                    ZFIELD                         CGL018
     C                   PARM                    ZFLD15                         CGL018
     C                   PARM                    ZADEC
     C                   PARM      'J'           ZECODE                         CGL018
     C                   PARM      *blanks       ZFIELD                         CGL018
     C                   MOVE      ZFIELD        RRSBA1
      *
     C                   EVAL      RQDLN1 = 1
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
     C                   WRITE     DETSE2
E3   C                   ENDIF
      *
E2   C                   ENDIF
      *
      ***  Next Record
      *
     C     NEXTREC       TAG
     C                   READ      GLNETGL6                               88
E1   C                   ENDDO
      *
     C                   ENDSR
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RtvCcySR - SR to retrieve currency decimal places             *
      *                                                               *
      * Called by: REPORT                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     RtvCcySR      BEGSR
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM      P#CCY         CCY               3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ***  Handle Database Error.
      *
     C                   IF        WRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = P#CCY
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * WP1END - SR to write End of Report                            *
      *                                                               *
      * Called by: PROCES                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     WP1END        BEGSR
      *
     C                   EVAL      RQDLN1 = 4
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
      ***  Write out Total Format
      *
     C                   WRITE     TRAILP1
     C                   ENDSR
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AUDIT - SR to output audit report and end program             *
      *                                                               *
      * Called by: Main, PROCES, *PSSR                                *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     AUDIT         BEGSR
      *
      ***  Output Report Header and File Controls.
      *
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
      ***  If there is a DB error, output the DB error information.
      *
     C                   IF        *INU7 = *on
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ***  Or, if no records read, output "No Details" message.
      *
     C*****              IF        RCOUNT = 0                                   CGL018
     C                   IF        RCOUNT1 = 0                                  CGL018
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
      *
      ***  End Program and Return.
      *
     C                   EVAL      *INLR = *on
     C                   RETURN
      *
     C                   ENDSR
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RCFP1 - SR to register the P1 PRTF via RCF.                   *
      *                                                               *
      * Called by: PROCES                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     RCFP1         BEGSR
      *
      ***  Ensure Report Spool File recorded by RCF.
      *
     C                   EVAL      ZSNUM = SFNUM1
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          SEQ
     C                   PARM                    SENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM      *BLANK        ZSERR
      *
      ***  If error occurs during ZSFILE processing, then return to the
      ***  calling program.
      *
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *on
     C                   EVAL      *INU8 = *on
     C                   EVAL      *INLR = *on
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RCFAU - SR to register the AU PRTF via RCF.                   *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     RCFAU         BEGSR
      *
      ***  Ensure Audit Spool File recorded by RCF.
     C                   EVAL      ZSNUM = SFNUMU
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          SEQ
     C                   PARM                    SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUM
     C                   PARM      *BLANK        ZSERR
      *
      ***  If error occurs during ZSFILE processing, then return to the
      ***  calling program.
      *
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *on
     C                   EVAL      *INU8 = *on
     C                   EVAL      *INLR = *on
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: SR/RCFAU                                               *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ***  Receive Parameter List.
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ
      *
     C     K#WAB1        KLIST
     C                   KFLD                    L6RWPBRCA
     C                   KFLD                    L6RWPCUST
     C                   KFLD                    L6RWPCCY
     C                   KFLD                    L6RWPACOD
     C                   KFLD                    L6RWPACSQ
      *
      ***  Initialise LDA field.
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
      ***  Call Access Program for Bank Details - Title, Run Date and
      ***  Run Day Number.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD
     C                   PARM      '*FIRST '     WOPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Handle Database Error.
      *
     C                   IF        WRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = WOPTN
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Check System Date Format, DDMMYY (*IN98 off)
      ***                            MMDDYY (*IN98 on).
      *
     C                   IF        BJDFIN = 'M'
     C                   EVAL      *IN98 = *on
     C                   ENDIF
      *
      ***  Access RUNDAT for multibranching indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C                   IF        AGMBIN = 'M'
     C                   EVAL      *IN37 = *on
     C                   ENDIF
      *
      ***  RCF Processing for Audit File.
      *
     C                   EXSR      RCFAU
      *
      ***  Report Work fields.
      *
     C                   EVAL      RQDLN1 = 0
     C                   EVAL      DIFLN1 = 0
     C                   EVAL      PRTLN1 = 0
      *
     C                   ENDSR
      *
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   CALLB     'DBERRCTL'
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   EXSR      AUDIT
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDETSE3 - PRINT DETAIL 3                                     *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRDETSE3      BEGSR
      *
     C*****              IF        L6RWPBAL < 0                                 CGL018
     C                   IF        PAB < 0                                      CGL018
     C                   EVAL      RRDRCR = 'CR'
     C                   EVAL      PAB = PAB * -1                               CGL018
     C                   ELSE
     C                   EVAL      RRDRCR = 'DR'
     C                   ENDIF
      *
     C*****              IF        L6RWPBAL < 0                                 CGL018
     C*****L6RWPBAL      MULT      -1            L6RWPBAL                       CGL018
     C*****              ENDIF                                                  CGL018
      *
     C                   MOVE      *BLANK        ZFIELD
     C*****              MOVE      L6RWPBAL      ZFIELD                         CGL018
     C                   Z-ADD     PAB           ZFLD15                         CGL018
     C                   Z-ADD     A6NBDP        ZADEC
     C*****              CALL      'ZEDIT'                                      CGL018
     C                   CALLB     'ZSEDIT'                                     CGL018
     C*****              PARM                    ZFIELD                         CGL018
     C                   PARM                    ZFLD15                         CGL018
     C                   PARM                    ZADEC
     C                   PARM      'J'           ZECODE                         CGL018
     C                   PARM      *blanks       ZFIELD                         CGL018
     C                   MOVE      ZFIELD        RRSBA2
     C                   MOVE      *BLANK        ZFIELD
      *
     C                   IF        RWB < 0
     C                   EVAL      RRDRC1 = 'CR'
     C                   ELSE
     C                   EVAL      RRDRC1 = 'DR'
     C                   ENDIF
      *
     C                   IF        RWB < 0
     C     RWB           MULT      -1            RWB
     C                   ENDIF
      *
     C*****              MOVE      RWB           ZFIELD                         CGL018
     C                   Z-ADD     RWB           ZFLD15                         CGL018
     C                   Z-ADD     A6NBDP        ZADEC
     C*****              CALL      'ZEDIT'                                      CGL018
     C                   CALLB     'ZSEDIT'                                     CGL018
     C*****              PARM                    ZFIELD                         CGL018
     C                   PARM                    ZFLD15                         CGL018
     C                   PARM                    ZADEC
     C                   PARM      'J'           ZECODE                         CGL018
     C                   PARM      *blanks       ZFIELD                         CGL018
     C                   MOVE      ZFIELD        RRSBA3
      *
     C                   EVAL      RQDLN1 = 1
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF
      *
     C                   WRITE     DETSE3
     C                   MOVE      *BLANK        PRINTSUM
      *
     C                   ENDSR
      ********************************************************************
** CPY@
(c) Finastra International Limited 2002
