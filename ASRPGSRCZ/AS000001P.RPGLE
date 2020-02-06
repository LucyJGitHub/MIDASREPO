     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Hedge linkage aud/reqst report')              *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standard Module                           *
      *                                                               *
      *  AS000001P - Hedge Linkage Audit/Request Report               *
      *                                                               *
      *  Function:  This module lists the Hedge Linkages List in a    *
      *             hedge group. Runs on I/C upon request and in COB  *
      *             if there is an action done in maintenance.        *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CSE071             Date 19Jul05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CAS006             Date 21Jan03               *
      *                 214841             Date 12Feb03               *
      *                 212430             Date 20Nov02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS002  *CREATE    Date 14Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  214841 - Hedge Linkage report should only print live and/or  *
      *           trading status.                                     *
      *  212430 - Various errors on deleted transactions and deleted  *
      *           linkages                                            *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAS002 - Hedge Strategy/Linkage                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of File for ASHGLKL1                        *
      *    02         End of File for ASHTRNL4                        *
      *    03         End of File for ASHTRNL5                        *
      *    04         Use Module & Deal no. for Hedged Derivatives    *
      *    05         Use Mod & Deal # for hedged deal/loan/security  *
      *    11         No Details to Report                            *
      *    12         Chain fail to files                             *
      *    13         Program Failure                                 *
      *    14         Record Locked                                   *
      *    15         Update Error                                    *
      *    21         Hedge Accounting Phase B Indicator              *                       CAS006
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRINIT - Initialisation                                       *
      * SRPROC - Detail Processing                                    *
      * SRAUDT - Audit Printing                                       *
      * SRPRNT - Detail Printing                                      *
      * SRRCFP1 - Detail Spool File recorded by RCF                   *
      * SRCHTP - Determine Last Action Done to record                 *
      * SRDATE - Convert Midas day number to date                     *
      * SRCHKLIN - Checks for overflow condition                      *
      * SRDRVT - Process Derivatives                                  *
      * SRHDGE - Process Hedged                                       *
      * SRCLEAR - Initialises Printer File Output fields              *
      * SRUPDAT - Perform Audit file Update                           *
      * SRPRCNT - Derives Value in percent                            *
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
 
      ** AS Hedge Linkage Details
     FASHGLKL1  IF   E           K DISK    INFSR(*PSSR)
     FASHGLKL3  IF   E           K DISK    INFSR(*PSSR)                                       214841
     F                                     RENAME(ASHGLKD0:ASHGLKD3)                          214841
 
      ** AS Hedge Transactions File Retrieve
     F***ASHTRNL4  IF   E           K DISK    INFSR(*PSSR)                                    CAS004
     F**********                           RENAME(ASHTRND0:ASHTRND4)                          CAS004
     FASHTRNLC  IF   E           K DISK    INFSR(*PSSR)                                       CAS004
     F                                     RENAME(ASHTRND0:ASHTRNDC)                          CAS004
 
      ** AS Hedge Transactions File retrieve
     F***ASHTRNL5  IF   E           K DISK    INFSR(*PSSR)                                    CAS004
     F**********                           RENAME(ASHTRND0:ASHTRND5)                          CAS004
     FASHTRNLD  IF   E           K DISK    INFSR(*PSSR)                                       CAS004
     F                                     RENAME(ASHTRND0:ASHTRNDD)                          CAS004
 
      ** RTV: Standing Data Controls Retrieval index
     FSDFCTLL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** UPD: Standing Data Controls Update index
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
 
      ** Forecast Transaction Details Master File Retrieval Index                             212430
     FASFHTRL1  IF   E           K DISK    INFSR(*PSSR)                                       212430
     F                                     PREFIX(FC:2)                                       212430
                                                                                              212430
      ** Deals File                                                                           212430
     FDEALALL   IF   E           K DISK    INFSR(*PSSR)                                       212430
     F                                     IGNORE(DEALSDAF)                                   212430
     F                                     IGNORE(DEALSDFF)                                   212430
                                                                                              212430
      ** Loans File                                                                           212430
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)                                       212430
     F                                     IGNORE(CLOANHHF)                                   212430
     F                                     IGNORE(CLOANCKF)                                   212430
     F                                     IGNORE(CLOANZ1F)                                   212430
                                                                                              212430
      ** Securities File                                                                      212430
     FSECTY     IF   E           K DISK    INFSR(*PSSR)                                       212430
                                                                                              212430
      ** FF Transaction Details                                                               212430
     FTRANS2    IF   E           K DISK    INFSR(*PSSR)                                       212430
                                                                                              212430
      ** SD Hedge Strategy Table detail report
     FAS000001P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Switchable Feature Details Data Structure                                            CAS006
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS006
                                                                                              CAS006
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for ASHGLKPD
     D DSLINK        E DS                  EXTNAME(ASHGLKPD)
     D  DSDVDL                32     33
     D  DSHGDL                34     35
 
      ** File Information Data Structure for AS000001P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
      *
      ** File Information Data Structure for AS000001AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6A                                                      CAS006
 
      ** Switchable Features                                                                  CAS006
     D CAS006          S              1A   INZ('N')                                           CAS006
                                                                                              CAS006
     D PMode           S              1
     D PFlag           S              1
 
     D RqdLn1          S              3P 0
     D DifLn1          S              4P 0
     D WorkNum         S              5P 0
     D PReptNam        S             10
 
     D WHead1          S             14
     D WLine1          S             14
     D WHead2          S             18
     D WLine2          S             18
 
     D ZDATE           S              6  0
     D ZADATE          S              7
     D PDate           S                   LIKE(FSENDT)
 
     D PFLD15          S             15  0
     D PDECS           S              1  0
     D PECODE          S              1
     D POUT21          S             21
     D WAlpha19        S             19
 
     D KFilNam         S             10
     D WNORC           S                   LIKE(AHNORC)
     D WNORC2          S                   LIKE(AHNORC)
     D WNOIN           S                   LIKE(AHNOIN)
     D WNOAM           S                   LIKE(AHNOAM)
     D WNODL           S                   LIKE(AHNODL)
 
     D WError          S              1
     D WIndSel         S              1
     D WPCTG           S              6  0
     D WPerCent        S                   LIKE(FSPCTG)
 
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
 
     C                   EXSR      SRINIT
 
     C                   EXSR      SRPROC
 
     C                   EXSR      SRAUDT
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialisation                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** RCF Processing for rinter File.
 
     C                   EXSR      SRRCFP1
 
      ** Report Work fields.
 
     C                   EVAL      RqdLn1  = 0
     C                   EVAL      DifLn1  = 0
     C                   EVAL      RTOTAL  = 0
     C                   EVAL      PrtLn1  = 0
     C                   EVAL      WorkNum = 0
     C                   EVAL      *IN11 = '0'
     C                   EVAL      PFlag = *BLANKS
     C                   EVAL      WError = 'N'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRPRNT                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
      ** Print Header
     C                   WRITE     HEADP1
 
      ** SD Hedge Strategy
     C                   IF        PMode = 'A'                                                214841
     C     *LOVAL        SETLL     ASHGLKL1
     C                   READ      ASHGLKL1                               01
     C                   ELSE                                                                 214841
     C     *LOVAL        SETLL     ASHGLKL3                                                   214841
     C                   READ      ASHGLKL3                               01                  214841
     C                   ENDIF                                                                214841
 
     C                   DOW       *IN01 = *OFF
 
     C                   EVAL      WorkNum = WorkNum + 1
 
      ** If AUDIT mode, process only records whose LCD = Rundate
      ** If report is requested, process only live records
     C                   IF        ((PMode = 'A') AND (FSLCD = BJRDNB))
     C**********                   OR ((PMode <> 'A') AND                                     212430
     C**********                   (FSCHTP <> 'D'))                                           212430
     C                             OR   PMode <> 'A'                                          212430
     C                   EXSR      SRPRNT
     C                   ENDIF
 
     C                   IF        PMode = 'A'                                                214841
     C                   READ      ASHGLKL1                               01
     C                   ELSE                                                                 214841
     C                   READ      ASHGLKL3                               01                  214841
     C                   ENDIF                                                                214841
 
     C                   ENDDO
 
      ** When EOF, write trailer
     C                   IF        *IN01 = *ON
     C                   EVAL      RqdLn1 = 8
     C                   EXSR      SRCHKLIN
 
     C                   IF        RTOTAL = 0
     C                   EVAL      *IN11 = '1'
     C                   ENDIF
 
     C                   WRITE     TRAILP1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPRNT - Detail Printing                                      *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: SRCHKLIN, SRDATE, SRCHTP, SRDRVT, SRHDGE, SRCLEAR      *
      *                                                               *
      *****************************************************************
 
     C     SRPRNT        BEGSR
 
      ** Initialise printer output fields
     C                   EXSR      SRCLEAR
 
      ** Check for overflow
     C                   EVAL      RqdLn1 = 12
     C                   EXSR      SRCHKLIN
 
      ** Put details to printer fields.
 
     C                   MOVE      FSHEDI        RHEDI
     C                   EVAL      RHGST = FSHGST
     C**********         EVAL      RFCOA = FSFCOA                                             CAS006
     C**********         EVAL      RICAT = FSICAT                                             CAS006
 
      ** Convert midas rundate to appropriate date format
     C                   EVAL      PDate = FSEFFD
     C                   EXSR      SRDATE
     C                   EVAL      REFFD = ZADATE
 
     C                   EVAL      PDate = FSINDT
     C                   EXSR      SRDATE
     C                   EVAL      RINDT = ZADATE
 
     C                   EVAL      PDate = FSSTDT
     C                   EXSR      SRDATE
     C                   EVAL      RSTDT = ZADATE
 
     C                   EVAL      PDate = FSENDT
     C                   EXSR      SRDATE
     C                   EVAL      RENDT = ZADATE
 
      ** Set the Hedge Linkage Data Fields if CAS006 is enabled.                              CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
                                                                                              CAS006
     C                   IF        FSDPTS <> *ZERO                                            CAS006
     C                   EVALR     RDPTS = %CHAR(FSDPTS)                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   EVAL      RDFRQ = FSDFRQ                                             CAS006
     C                   EVAL      RWDAY = FSWDAY                                             CAS006
                                                                                              CAS006
     C                   IF        FSMNTH <> *ZERO                                            CAS006
     C                   EVALR     RMNTH = %CHAR(FSMNTH)                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   EVAL      PDate = FSNDTA                                             CAS006
     C                   EXSR      SRDATE                                                     CAS006
     C                   EVAL      RNDTA = ZADATE                                             CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Get Last Change type
     C                   EXSR      SRCHTP
 
      ** Write First Details
      *
     C                   WRITE     DETAIL1
 
      ** Process Derivatives (2nd Detail)
     C                   EXSR      SRDRVT
 
      ** Process Hedged Details (3rd detail)
     C                   EXSR      SRHDGE
 
     C                   EVAL      RTOTAL = RTOTAL + 1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAUDT - Audit Processing                                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SDC540P                                                *
      *                                                               *
      *****************************************************************
 
     C     SRAUDT        BEGSR
 
      ** Process SDFCTLPA only in audit mode
     C                   IF        PMode = 'A'
 
     C                   EVAL      KFilNam = 'ASHGLKPD  '
     C     KFILE         CHAIN     SDFCTLL1                           12
 
      ** DBerror if record not found
     C                   IF        *IN12 = '1'
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = KFilNam
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   EVAL      WNORC = AHNORC
     C                   EVAL      WNOIN = AHNOIN
     C                   EVAL      WNOAM = AHNOAM
     C                   EVAL      WNODL = AHNODL
     C                   ENDIF
 
      ** Compare # of records read to the # of records in file
     C                   IF        WorkNum <> WNORC
     C                   EVAL      PFlag = 'N'
     C                   ENDIF
 
      ** Call Audit Printfile override program, SD Data Controls
     C                   CALL      'SDC540P'                            13
     C                   PARM      'AS000001AU'  PReptNam
     C                   PARM                    PFlag
     C                   PARM                    WNOIN
     C                   PARM                    WNOAM
     C                   PARM                    WNODL
     C                   PARM                    WorkNum
     C                   PARM                    WNORC
     C                   PARM                    RTITLE
     C                   PARM                    RUNDLN
 
      ** Call to program ended in error
     C                   IF        *IN13 = '1'
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
      ** If work flag is incorrect
     C                   IF        PFlag = 'N'
     C                   EVAL      *INU8 = '1'
     C                   ENDIF
 
      ** If audit program ended normally
     C                   IF        WError = 'N'
     C                   EXSR      SRUPDAT
     C                   ENDIF
 
     C                   ENDIF
 
      ** END OF PROGRAM
     C                   EVAL      *INLR = '1'
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFP1 - Detail Spool File recorded by RCF                   *
      *                                                               *
      * Called by: SRINIT                                             *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRRCFP1       BEGSR
 
     C                   OPEN      AS000001P1
      *
      ** Ensure Detail Spool File recorded by RCF.
      *
     C                   EVAL      ZSnum = PSFNum1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCLEAR -  Blank out printer file output fields               *
      *                                                               *
      * Called by: SRPRNT                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCLEAR       BEGSR
 
     C                   CLEAR                   RHEDI
     C                   CLEAR                   RACT
     C                   CLEAR                   RACTION
     C                   CLEAR                   RHGST
     C                   CLEAR                   REFFD
     C                   CLEAR                   RINDT
     C**********         CLEAR                   RFCOA                                        CAS006
     C**********         CLEAR                   RICAT                                        CAS006
     C                   CLEAR                   RSTDT
     C                   CLEAR                   RENDT
     C                   CLEAR                   RDMOD
     C                   CLEAR                   RDDNO
     C                   CLEAR                   RFPNO
     C                   CLEAR                   RDPCT
     C                   CLEAR                   RHMOD
     C                   CLEAR                   RHDNO
     C                   CLEAR                   RHSEC
     C                   CLEAR                   RHPCT
                                                                                              CAS006
      ** Clear the Hedge Linkage Data Fields if CAS006 is enabled.                            CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   CLEAR                   RDPTS                                        CAS006
     C                   CLEAR                   RDFRQ                                        CAS006
     C                   CLEAR                   RWDAY                                        CAS006
     C                   CLEAR                   RMNTH                                        CAS006
     C                   CLEAR                   RNDTA                                        CAS006
     C                   ENDIF                                                                CAS006
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCHTP - Determine Last Action done to record                 *
      *                                                               *
      * Called by: SRPRNT                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCHTP        BEGSR
 
      ** Populate action fields only in AUDIT mode
 
     C                   IF        PMode = 'A'
 
     C                   EVAL      RACT  = 'ACTION:'
     C                   SELECT
     C                   WHEN      FSCHTP = 'I'
     C                   EVAL      RACTION = 'INSERT'
     C                   WHEN      FSCHTP = 'A'
     C                   EVAL      RACTION = 'AMEND'
     C                   WHEN      FSCHTP = 'D'
     C                   EVAL      RACTION = 'DELETE'
     C                   ENDSL
 
     C                   ELSE
     C                   EVAL      RACT = *BLANKS
     C                   EVAL      RACTION = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDATE - Convert Date to DDMMMYY                              *
      *                                                               *
      * Called by: SRPRNT                                             *
      *                                                               *
      * Calls: ZDATE2                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRDATE        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDate
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANKS       ZADATE
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPDAT - Update Audit Controls                               *
      *                                                               *
      * Called by: SRAUDT                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRUPDAT       BEGSR
 
     C                   EVAL      KFilNam = 'ASHGLKPD  '
     C     KFILE         CHAIN     SDFCTLL0                           1214
 
      ** DBerror if record not found
     C                   IF        *IN12 = '1'
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = KFilNam
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Record Locked dont continue update
     C                   IF        *IN14 = '1'
     C                   EVAL      *IN14 = '1'
     C                   ELSE
 
      ** Save values in work fields
     C                   EVAL      WNORC2 = AHNORC
     C                   EVAL      WNOIN  = AHNOIN
     C                   EVAL      WNOAM  = AHNOAM
     C                   EVAL      WNODL  = AHNODL
 
      ** Update File fields
     C                   EVAL      AHNORC = WNORC2
     C                   EVAL      AHNOIN = 0
     C                   EVAL      AHNOAM = 0
     C                   EVAL      AHNODL = 0
 
     C                   UPDATE    @AHREAU                              15
     C                   IF        *IN15 = '1'
     C                   EVAL      DBASE = 5
     C                   EVAL      DBKEY = '*UPDATE'
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDRVT - Process Derivative details                           *
      *                                                               *
      * Called by: SRPRNT                                             *
      *                                                               *
      * Calls: SRPRCNT, SRCHKLIN                                      *
      *                                                               *
      *****************************************************************
 
     C     SRDRVT        BEGSR
 
      ** Check for overflow
     C                   EVAL      RqdLn1 = 3
     C                   EXSR      SRCHKLIN
     C                   WRITE     DETAIL2
 
      ** Hedging data
     C                   IF        (DSDVDL = 'YN') OR (DSDVDL = 'Y ')
     C                   EVAL      *IN04 = '1'
     C                   ENDIF
 
     C                   IF        (DSDVDL = 'NY') OR (DSDVDL = ' Y')
     C                   EVAL      *IN04 = '0'
     C                   ENDIF
 
      ** Print all Hedging instrument/Hedged items under this
      ** particular hedge ID
     C                   EVAL      WIndSel = 'D'
     C*****KEYTRN        SETLL     ASHTRNL4                                                   CAS004
     C*****KEYTRN        READE     ASHTRNL4                               02                  CAS004
     C     KEYTRN        SETLL     ASHTRNLC                                                   CAS004
     C     KEYTRN        READE     ASHTRNLC                               02                  CAS004
     C                   DOW       *IN02 = '0'
 
     C                   CLEAR                   DETAIL2A
 
     C                   SELECT                                                               212430
     C                   WHEN      FSMOD = 'DL'                                               212430
     C*****FSDLNO        CHAIN     DEALALL                            06               212430 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2           6 0                        CLE148
     C     FSDLNO2       CHAIN     DEALALL                            06                      CLE148
     C                   OTHER                                                                212430
     C*****FSDLNO        CHAIN     TRANS2                             06               212430 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     TRANS2                             06                      CLE148
     C                   ENDSL                                                                212430
                                                                                              212430
     C                   IF        *IN06 = '1'                                                212430
     C                             OR RECI <> 'D'                                             212430
     C                   EVAL      RDDEL = '*'                                                212430
     C                   ENDIF                                                                212430
                                                                                              212430
     C                   IF        FSHTCT = 'D'                                               212430
     C                   EVAL      RDDEL = '*'                                                212430
     C                   ENDIF                                                                212430
                                                                                              212430
     C                   MOVE      FSDLNO        RDDNO
     C                   EVAL      RDMOD = FSMOD
     C                   EVAL      RFPNO = FSFPSE
 
      ** Derive Percentage
     C                   EXSR      SRPRCNT
     C                   MOVE      WAlpha19      RDPCT
 
      ** Check for overflow
     C                   EVAL      RqdLn1 = 1
     C                   EXSR      SRCHKLIN
     C                   WRITE     DETAIL2A
 
     C*****KEYTRN        READE     ASHTRNL4                               02                  CAS004
     C     KEYTRN        READE     ASHTRNLC                               02                  CAS004
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHDGE - Process Hedged details                               *
      *                                                               *
      * Called by: SRPRNT                                             *
      *                                                               *
      * Calls: SRPRCNT, SRCHKLIN                                      *
      *                                                               *
      *****************************************************************
 
     C     SRHDGE        BEGSR
 
      ** Check for overflow
     C                   EVAL      RqdLn1 = 3
     C                   EXSR      SRCHKLIN
     C                   WRITE     DETAIL3
 
      ** Hedging data
     C                   IF        (DSHGDL = 'YN') OR (DSHGDL = 'Y ')
     C                   EVAL      *IN05 = '1'
     C                   ENDIF
 
     C                   IF        (DSHGDL = 'NY') OR (DSHGDL = ' Y')
     C                   EVAL      *IN05 = '0'
     C                   ENDIF
 
      ** Print all Derivatives under this particular hedge ID
     C                   EVAL      WIndSel = 'H'
     C*****KEYTRN        SETLL     ASHTRNL5                                                   CAS004
     C*****KEYTRN        READE     ASHTRNL5                               03                  CAS004
     C     KEYTRN        SETLL     ASHTRNLD                                                   CAS004
     C     KEYTRN        READE     ASHTRNLD                               03                  CAS004
     C                   DOW       *IN03 = '0'
 
     C                   CLEAR                   DETAIL3A
 
     C                   SELECT                                                               212430
     C                   WHEN      FSMOD = 'DL'                                               212430
     C*****FSDLNO        CHAIN     DEALALL                            06               212430 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     DEALALL                            06                      CLE148
     C                   WHEN      FSMOD = 'LE'                                               212430
     C     FSDLNO        CHAIN     CLOANCLF                           06                      212430
     C                   WHEN      FSMOD = 'FH'                                               212430
     C*****FSDLNO        CHAIN     ASFHTRL1                           06               212430 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     ASFHTRL1                           06                      CLE148
     C                   OTHER                                                                212430
     C     FSFPSE        CHAIN     SECTYDF                            06                      212430
     C                   ENDSL                                                                212430
                                                                                              212430
     C                   IF        *IN06 = '0'                                                212430
     C                             AND RECI <> 'D'                                            212430
     C                             AND FSMOD <> 'FH'                                          212430
     C                             OR *IN06 = '0'                                             212430
     C                             AND FSRECI <> 'D'                                          212430
     C                             AND FSMOD = 'FH'                                           212430
     C                             OR *IN06 = '1'                                             212430
     C                   EVAL      RHDEL = '*'                                                212430
     C                   ENDIF                                                                212430
                                                                                              212430
     C                   IF        FSHTCT = 'D'                                               212430
     C                   EVAL      RHDEL = '*'                                                212430
     C                   ENDIF                                                                212430
                                                                                              212430
     C                   MOVE      FSDLNO        RHDNO
     C                   EVAL      RHMOD = FSMOD
     C                   EVAL      RHSEC = FSFPSE
 
      ** Derive Percentage
     C                   EXSR      SRPRCNT
     C                   MOVE      WAlpha19      RHPCT
 
      ** Check for overflow
     C                   EVAL      RqdLn1 = 1
     C                   EXSR      SRCHKLIN
     C                   WRITE     DETAIL3A
 
     C*****KEYTRN        READE     ASHTRNL5                               03                  CAS004
     C     KEYTRN        READE     ASHTRNLD                               03                  CAS004
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCHKLIN - Checks for printer file overflow condition         *
      *                                                               *
      * Called by: SRPROC, SRPRNT, SRDRVT, SRHDGE                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCHKLIN      BEGSR
 
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPRCNT - Derives Percentage to be outputted                  *
      *                                                               *
      * Called by: SRDRVT, SRHDGE                                     *
      *                                                               *
      * Calls: ZSEDIT                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRPRCNT       BEGSR
 
      ** Initialise Work Fields
     C                   CLEAR                   PFLD15
     C                   CLEAR                   PDECS
     C                   CLEAR                   PECODE
     C                   CLEAR                   POUT21
     C                   CLEAR                   WAlpha19
 
     C                   IF        FSPCTG = 0
     C                   EVAL      WPerCent = 100
     C                   ELSE
     C                   EVAL      WPerCent = FSPCTG
     C                   ENDIF
 
     C                   MOVE      WPerCent      WPCTG
     C                   MOVE      WPCTG         PFLD15
     C                   EVAL      PDECS = 2
     C                   EVAL      PECODE = 'L'
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    PFLD15
     C                   PARM                    PDECS
     C                   PARM                    PECODE
     C                   PARM                    POUT21
 
     C                   EVAL      WAlpha19 = POUT21
 
     C                   ENDSR
 
      *****************************************************************
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
 
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Set the Database Program Name.                                                       CAS006
                                                                                              CAS006
     C                   EVAL      DBPgm = 'AS000001P'                                        CAS006
                                                                                              CAS006
      ** Access Bank Details
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C**********         EVAL      DBPGM = 'AS000001P'                                        CAS006
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CAS006
      ** Check if CAS006 is enabled.                                                          CAS006
                                                                                              CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRTCD                                        CAS006
     C                   PARM      '*VERIFY'     POPTN                                        CAS006
     C                   PARM      'CAS006'      PSARD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRtCd = *BLANKS                                            CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   EVAL      *IN21 = *ON                                                CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        PRtCd <> '*NRF'                                            CAS006
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBKey  = 'CAS006'                                          CAS006
     C                   EVAL      DBase  = 2                                                 CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
 
      ** Prepare the Header Title to be used (must be centered)
     C                   EVAL      WHead1 = 'HEDGE LINKAGES'
     C                   EVAL      WLine1 = '--------------'
 
     C                   IF        PMode = 'A'
     C                   EVAL      WHead2 = ' MAINTENANCE TODAY'
     C                   EVAL      WLine2 = '------------------'
     C                   EVAL      RTITLE = '           ' +
     C                                      WHead1 + WHead2
     C                   EVAL      RUNDLN = '           ' +
     C                                      WLine1 + WLine2
     C                   ELSE
 
     C                   EVAL      WHead2 = ' LISTING'
     C                   EVAL      WLine2 = '--------'
     C                   EVAL      RTITLE = '                ' +
     C                                      WHead1 + WHead2
     C                   EVAL      RUNDLN = '                ' +
     C                                      WLine1 + WLine2
     C                   ENDIF
 
      ** Define Key List For SDFCTLPA
     C     KFILE         KLIST
     C                   KFLD                    KFilNam
 
      ** Define Key List For ASHTRNPD
     C     KEYTRN        KLIST
     C                   KFLD                    FSHEDI
     C                   KFLD                    WIndSel
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      ReturnCode = '*ERROR'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
