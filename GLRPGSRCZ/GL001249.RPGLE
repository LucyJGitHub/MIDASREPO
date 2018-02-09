     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Risk Weighted Assets Balances Report')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001249 - Risk Weighted Assets Balances Report              *
      *                                                               *
      *  Function:  This report lists all asset balances with the     *
      *             risk weighted amounts calculated.                 *
      *             It runs in CoB after all RWA balances update pgms *
      *             have been run.                                    *
      *                                                               *
      ** +---------------------------------------------------------+ **
      *                                                               *
      *  Component of: GL001249                                       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 220112             Date 06Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL018   *CREATE   Date 23Sep02               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  220112 - RCOUNT too small causing GL001249 to end in error.  *
      *           Recompiled over changes to GL001249AU.              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *   30  - Currency has 0 dec. places                            *
      *   31  - Currency has 1 dec. places                            *
      *   32  - Currency has 2 dec. places                            *
      *   33  - Currency has 3 dec. places                            *
      *                                                               *
      *   37  - Multibranching ON                                     *
      *                                                               *
      *   60  - Chain fail SDRWASL1                                   *
      *   89  - EOF GLRWARL1                                          *
      *                                                               *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  PROCES - Detail Processing                                   *
      *  REPORT - Process Report Lines                                *
      *  WP1REC - Format and Write a Detail Record to the Report      *
      *  WP2REC - Write RWA Balance Record to the Report              *
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
 
     FGLRWARL1  IF   E           K DISK
      * RWA Balance Report File
 
     FSDRWASL1  IF   E           K DISK
      * RWA Set Number Master File
 
     FGL001249AUO    E             PRINTER INFDS(SPOOLU)
      * RWA Balances Report Audit Printer File
 
     FGL001249P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
      * RWA Balances Report Printer File
 
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
 
      ***  File Information Data Structure for GL001249P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ***  File Information Data Structure for GL001249AU.
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
 
     D                 DS
     D AMNT0                   1     15  0
     D AMNT1                         15  1 Overlay(AMNT0:1)
     D AMNT2                         15  2 Overlay(AMNT0:1)
     D AMNT3                         15  3 Overlay(AMNT0:1)
 
     D                 DS
     D RIAMT0                  1     15  0
     D RIAMT1                        15  1 Overlay(RIAMT0:1)
     D RIAMT2                        15  2 Overlay(RIAMT0:1)
     D RIAMT3                        15  3 Overlay(RIAMT0:1)
 
     D                 DS
     D RADJA0                  1     15  0
     D RADJA1                        15  1 Overlay(RADJA0:1)
     D RADJA2                        15  2 Overlay(RADJA0:1)
     D RADJA3                        15  3 Overlay(RADJA0:1)
 
     D                 DS
     D RABAL0                  1     15  0
     D RABAL1                        15  1 Overlay(RABAL0:1)
     D RABAL2                        15  2 Overlay(RABAL0:1)
     D RABAL3                        15  3 Overlay(RABAL0:1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
 
     D SaveSetN        S                   Like(RWSETN) Inz
     D SaveMod         S                   Like(RWMOD) Inz
     D SaveTran        S                   Like(RWTRAN) Inz
 
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
 
      ***  Perform Detail Processing.
 
     C                   EXSR      PROCES
 
      ***  Output Audit Report and End Program.
 
     C                   EXSR      AUDIT
 
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
 
     C     PROCES        BEGSR
 
     C                   EVAL      RCOUNT = 0
 
     C     KeyRWAR       SETLL     GLRWARL1
     C                   READ      GLRWARL1                               89
 
      ***  If EOF report no records
 
     C                   IF        *IN89 = *on
     C                   EXSR      AUDIT
     C                   ELSE
 
      ***  If record read, ensure spool file P1 recorded by RCF
 
     C                   OPEN      GL001249P1
     C                   EXSR      RCFP1
     C                   ENDIF
 
     C                   DOU       *IN89 = *on
 
      ***  Count records read
 
     C                   EVAL      RCOUNT = RCOUNT + 1
 
      ***  If change of set, report RWA balance for previous transaction,
      ***  then retrieve set details and start a new page.
 
     C                   IF        RWSETN <> SaveSetN
     C                   IF        SaveSetN <> *blank
     C                   EXSR      WP2REC
     C                   ENDIF
     C                   EXSR      RtvSetSR
     C                   WRITE     HEADPY
     C                   ENDIF
 
      ***  Process report detail lines.
 
     C                   EXSR      REPORT
 
      ***  Read next record
 
     C                   READ      GLRWARL1                               89
 
     C                   ENDDO
 
      ***  Write final records and totals to report
 
     C                   EXSR      WP2REC
     C                   EXSR      WP1END
 
     C                   ENDSR
 
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
      *  WP1REC   - Format and write a detail record to the report    *
      *                                                               *
      *****************************************************************
 
     C     REPORT        BEGSR
 
      ***  Check if change of transaction
 
     C                   IF        RWTRAN <> SaveTran
     C                             or RWTRAN = SaveTran and RWMOD <> SaveMod
 
      ***  If not change of set, report RWA balance for previous transaction
 
     C                   IF        RWSETN = SaveSetN
     C                   EXSR      WP2REC
     C                   ENDIF
 
      ***  Format transaction reference
      ***  For GL format the account number, for SE format the branch/book/
      ***  market/security ref., for DL or LE just use the ref.
 
     C                   EVAL      TRANO = *blanks
     C                   SELECT
 
     C                   WHEN      RWMOD = 'GL'
     C**********         EVAL      TRANO = %subst(RWTRAN:16:3) + '-'                          CGL029
     C**********                             + %subst(RWTRAN:1:6) + '-'                       CGL029
     C**********                             + %subst(RWTRAN:7:3) + '-'                       CGL029
     C**********                             + %subst(RWTRAN:10:4) + '-'                      CGL029
     C**********                             + %subst(RWTRAN:14:2)                            CGL029
     C                   EVAL      TRANO = %subst(RWTRAN:22:3) + '-'                          CGL029
     C                                       + %subst(RWTRAN:1:6) + '-'                       CGL029
     C                                       + %subst(RWTRAN:7:3) + '-'                       CGL029
     C                                       + %subst(RWTRAN:10:10) + '-'                     CGL029
     C                                       + %subst(RWTRAN:20:2)                            CGL029
 
     C                   WHEN      RWMOD = 'SE'
     C                   EVAL      TRANO = %subst(RWTRAN:1:3) + ' '
     C                                     + %subst(RWTRAN:4:2) + ' '
     C                                     + %subst(RWTRAN:6:1) + ' '
     C                                     + %subst(RWTRAN:7:10)
 
     C                   OTHER
     C                   EVAL      TRANO = RWTRAN
 
     C                   ENDSL
 
      ***  Retrieve currency decimal places
 
     C                   EXSR      RtvCcySR
 
     C                   EVAL      AMNT0 = RWAMNT
 
     C                   ENDIF
 
     C                   EVAL      SaveSetN = RWSETN
 
      ***  Format the percentage & amounts
 
     C                   MOVE      RWPERC        PERCO
     C                   EVAL      RIAMT0 = RWIAMT
     C                   EVAL      RADJA0 = RWADJA
     C                   EVAL      RABAL0 = RWABAL
 
      ***  If collateral weighting, report the reference and currency.
 
     C                   IF        RWWSRC = 'COLLATERAL'
     C                   EVAL      COLNAR = 'Coll. Ref. ' + RWCREF +
     C                                      ' (' + RWCCCY + ')'
     C                   ELSE
     C                   EVAL      COLNAR = *blanks
     C                   ENDIF
 
      ***  Output the detail record(s)
 
     C                   EXSR      WP1REC
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RtvSetSR - Retrieve set details                               *
      *                                                               *
      * Called by: PROCES                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     RtvSetSR      BEGSR
 
     C     RWSETN        CHAIN     SDRWASL1                           60
     C                   IF        *IN60 = *on
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = RWSETN
     C                   EVAL      DBFile = 'SDRWASPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
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
 
     C     RtvCcySR      BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*KEY   '     WOPTN
     C                   PARM                    RWCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ***  Handle Database Error.
 
     C                   IF        WRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = RWCCY
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     A6NBDP        COMP      1                                    3031
     C     A6NBDP        COMP      2                                  33  32
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * WP1REC - SR to write a detail record to the report            *
      *                                                               *
      * Called by: REPORT                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     WP1REC        BEGSR
 
      ***  Check that sufficient lines remain for the format. If not,
      ***  write out the main headings on a new page.
 
     C                   IF        RWTRAN <> SaveTran
     C                             or RWTRAN = SaveTran and RWMOD <> SaveMod
     C                   EVAL      RQDLN1 = 5
     C                   ELSE
     C                   EVAL      RQDLN1 = 1
     C                   ENDIF
 
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADPY
     C                   ENDIF
 
      ***  If change of transaction write transaction details
 
     C                   IF        RWTRAN <> SaveTran
     C                             or RWTRAN = SaveTran and RWMOD <> SaveMod
     C                   WRITE     DETAIL1
     C                   EVAL      SaveTran = RWTRAN
     C                   EVAL      SaveMod = RWMOD
     C                   ENDIF
 
      ***  Write weighting and RWA amount details
 
     C                   WRITE     DETAIL2
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * WP2REC - SR to write RWA balance to the report                *
      *                                                               *
      * Called by: PROCES, REPORT                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     WP2REC        BEGSR
 
      ***  Check that sufficient lines remain for the format. If not,
      ***  write out the main headings on a new page.
 
     C                   EVAL      RQDLN1 = 1
 
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADPY
     C                   ENDIF
 
      ***  Write RWA balance
 
     C                   WRITE     DETTOT
 
     C                   ENDSR
 
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
 
     C     WP1END        BEGSR
 
      ***  Check that sufficient lines remain for the format. If not,
      ***  write out the main headings on a new page.
 
     C                   EVAL      RQDLN1 = 4
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADPY
     C                   ENDIF
 
      ***  Write out Total Format
 
     C                   WRITE     TRAILPY
 
     C                   ENDSR
 
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
 
     C     AUDIT         BEGSR
 
      ***  Output Report Header and File Controls.
 
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
 
      ***  If there is a DB error, output the DB error information.
 
     C                   IF        *INU7 = *on
     C                   WRITE     DBERROR
     C                   ELSE
 
      ***  Or, if no records read, output "No Details" message.
 
     C                   IF        RCOUNT = 0
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
 
      ***  End Program and Return.
 
     C                   EVAL      *INLR = *on
     C                   RETURN
 
     C                   ENDSR
 
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
 
     C     RCFP1         BEGSR
 
      ***  Ensure Report Spool File recorded by RCF.
 
     C                   EVAL      ZSNUM = SFNUM1
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          SEQ
     C                   PARM      'ALL'         SENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM      *BLANK        ZSERR
 
      ***  If error occurs during ZSFILE processing, then return to the
      ***  calling program.
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *on
     C                   EVAL      *INU8 = *on
     C                   EVAL      *INLR = *on
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
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
 
     C     RCFAU         BEGSR
 
      ***  Ensure Audit Spool File recorded by RCF.
     C                   EVAL      ZSNUM = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          SEQ
     C                   PARM      'ALL'         SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUM
     C                   PARM      *BLANK        ZSERR
 
      ***  If error occurs during ZSFILE processing, then return to the
      ***  calling program.
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *on
     C                   EVAL      *INU8 = *on
     C                   EVAL      *INLR = *on
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
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
 
     C     *INZSR        BEGSR
 
      ***  Receive Parameter List.
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ
 
     C     KeyRWAR       KLIST
     C                   KFLD                    RWSETN
     C                   KFLD                    RWMOD
     C                   KFLD                    RWTRAN
     C                   KFLD                    RWPERC
 
      ***  Initialise LDA field.
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
      ***  Call Access Program for Bank Details - Title, Run Date and
      ***  Run Day Number.
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD
     C                   PARM      '*FIRST '     WOPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ***  Handle Database Error.
 
     C                   IF        WRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = WOPTN
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ***  Check System Date Format, DDMMYY (*IN98 off)
      ***                            MMDDYY (*IN98 on).
 
     C                   IF        BJDFIN = 'M'
     C                   EVAL      *IN98 = *on
     C                   ENDIF
 
      ***  Access RUNDAT for multibranching indicator
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C                   IF        AGMBIN = 'M'
     C                   ENDIF
 
      ***  RCF Processing for Audit File.
     C                   EXSR      RCFAU
 
      ***  Report Work fields.
 
     C                   EVAL      RQDLN1 = 0
     C                   EVAL      DIFLN1 = 0
 
     C                   EVAL      RWSETN = *blanks
     C                   EVAL      RWMOD = *blanks
     C                   EVAL      RWTRAN = *blanks
     C                   EVAL      RWPERC = *zero
 
     C                   ENDSR
 
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
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   CALLB     'DBERRCTL'
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   EXSR      AUDIT
 
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
** CPY@
(c) Finastra International Limited 2002
