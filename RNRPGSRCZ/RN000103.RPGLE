     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*YES)                                                *
/*EXI *  TEXT('Midas FRS Movement Exception Report')
      *****************************************************************
      *                                                               *
      *  MidasPlus - FRS Regulatory Reporting Interface               *
      *                                                               *
      *  RPGLE/RN000103 - Movement Exception Report                   *
      *                                                               *
      *  Function:  This program will read RNXCMVPD file and print    *
      *             each record to the movement exception report.     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG10742           Date 08May06               *
      *  Prev Amend No. CRN001  *CREATE    Date 03Oct05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG10742 - AC key in files RNAUMVPD and RNXCMVPD changed to  *
      *             20A due to CDL038. Recompile is needed.           *
      *  CRN001 - FRS Regulatory Reporting Interface                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *
      * RN Audit file
     FRNXCMVL0  IF   E           K DISK    INFSR(*PSSR)
      *
      * GP FRS Regulatory Authorities
     FGPREGAPD  IF   E           K DISK    INFSR(*PSSR)
      *
     FRN000103AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
      *
     FRN000103P1O    E             PRINTER INFDS(SPOOL1)
     F                                     INFSR(*PSSR)
     F                                     OFLIND(*IN67)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *    50 - Print transaction identifier                          *
      *    51 - Print account key                                     *
      *    67 - Overflow indicator of P1 report                       *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  Main      - Main processing                                  *
      *  WrtHeader - Write header                                     *
      *  WrtDetail - Write detail line                                *
      *  Audit     - Produce Audit Report and End Program             *
      *  *INZSR    - Program initialisation                           *
      *  CloseDown - Return to calling program                        *
      *  RCFP1     - RCF processing for P1 Report                     *
      *  RCFAU     - RCF processing for Audit Report                  *
      *  *PSSR     - Program Error processing Subroutine              *
      *                                                               *
      *****************************************************************
     D/EJECT
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      /COPY ZACPYSRC,PSDS
      /COPY RNCPYSRC,RNPSSRDFN
 
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      /SPACE 3
      *
      ***  File Information Data Structure for RN000103P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0                                      Lines printed
      *
     D SPOOLU          DS
      ***  File Information Data Structure for RN000103AU.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      ***  Data structure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS
      *
      ***  Work fields
     D FIRST           S              1
     D PCount          S              5  0 INZ(0)                               records count
     D RemainLine      S              3  0                                      remaining lines
     D SaveRegAut      S                   LIKE(XMREGAUT) INZ(' ')              Save Authority
     D SaveCntRef      S                   LIKE(XMCNTREF) INZ(' ')              Save Tx identifier
     D SaveAkey        S                   LIKE(XMAKEY)   INZ(' ')              Save a/c key
      *
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
     C                   EXSR      MAIN
 
     C                   EXSR      CloseDown
 
      *****************************************************************
      /TITLE SR/MAIN
      *****************************************************************
      *                                                               *
      *  MAIN   -  Main subroutine                                    *
      *                                                               *
      *****************************************************************
     C     MAIN          BEGSR
      *
     C                   EVAL      FIRST = 'Y'
      *
     C     *LOVAL        SETLL     RNXCMVL0
     C                   READ      RNXCMVL0
      *
     C                   DOW       NOT %EOF
      *
      * If first record, write subheadings and column heading.
     C                   IF        FIRST = 'Y'
     C                   EVAL      FIRST = 'N'
     C                   EXSR      WrtHeader
     C                   ENDIF
      *
      ** Details line
     C                   EXSR      WrtDetail
      *
      ** Increment record count
     C                   EVAL      PCount = PCount + 1
      *
     C                   READ      RNXCMVL0
      *
     C                   IF        NOT %EOF
      *
      ** On change of regulatory authority id or module, or overflow, start
      ** new page for report heading
     C                   IF        SaveRegAut  <> XMREGAUT OR
     C                             HModule     <> XMMODULE OR
     C                             *IN67 = *ON
     C                   WRITE     RPTHEAD
     C                   EXSR      WrtHeader
      *
      ** Set on overflow indicator to force to print transaction id and account key.
      ** in case they are same as previous record.
     C  N67              SETON                                        67
     C                   ENDIF
      *
     C                   ENDIF                                                  FI not %EOF
      *
     C                   ENDDO                                                  DOW not %EOF
      *
      ** If no record printed, write '*** NO DETAILS TO REPORT ***'
      *
     C                   IF        PCount = 0
     C                   WRITE     NODTLS
     C                   ENDIF
      *
      ** Check overflow before write Trailer.
     C                   EVAL      RemainLine = OFLLN1 - PRTLN1
     C                   IF        RemainLine < 3
     C                   WRITE     RPTHEAD
     C                   ENDIF
      *
     C                   WRITE     TRAILP1
      *
      ** Write Audit
     C                   EXSR      Audit
      *
     C                   ENDSR
 
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      /TITLE SR/WrtHeader
      *****************************************************************
      *                                                               *
      *  WrtHeader  - Write Header (Regulatory Authority, Module)     *
      *               and column heading                              *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     WrtHeader     BEGSR
      *
      ** If change on regulatory authority Id, get its description.
      *
     C                   IF        SaveRegAut <> XMREGAUT
      *
     C     XMREGAUT      CHAIN     GPREGAPD
     C                   IF        %FOUND
     C                   EVAL      HRANAME = RANAME
     C                   ELSE
     C                   EVAL      wDbFile  = 'GPREGAPD'
     C                   EVAL      wDBase   = 2
     C                   EVAL      wDbKey   = XMREGAUT
     c                   EVAL      wDbMod   = ' '
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Output the regulatory authority id.
     C                   EVALR     HREGAUT     = %TRIMR(XMREGAUT)
      *
      **  Save the regulatory authority id. as SaveRegAut.
     C                   EVAL      SaveRegAut  = XMREGAUT
      *
     C                   ENDIF                                                  FI SaveRegAut
      *                                                                            <> XMREGAPD
      ** If change on module, get its description from array @Module.
     C                   IF        HModule <> XMMODULE
      *
     C                   EVAL      HMODULE  = XMMODULE
      *
     C                   SELECT
     C                   WHEN      XMMODULE = 'DL'
     C                   EVAL      HMONAME  = 'Dealing'
     C                   WHEN      XMMODULE = 'LE'
     C                   EVAL      HMONAME  = 'Lending'
     C                   WHEN      XMMODULE = 'FT'
     C                   EVAL      HMONAME  = 'Fund Transfer'
     C                   OTHER
     C                   EVAL      HMONAME  = *BLANK
     C                   ENDSL
      *
     C                   ENDIF                                                  FI HModule<>XMMODULE
      *
      ** Write Header
     C                   WRITE     SUBHEAD
      *
     C     WrtHeaderE    ENDSR
      *
      *****************************************************************
      /TITLE SR/WRTDETAIL
      *****************************************************************
      *                                                               *
      *  WrtDetail - Write Detail                                     *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     WrtDetail     BEGSR
      *
      ** Set indicators not to print tx identifier and account key.
     C                   SETOFF                                       5051
      *
      ** If change on transaction identifier or overflow,
      **    output new transaction identifier and account key
     C                   IF        SaveCntRef <> XMCNTREF OR
     C                             *IN67      = *ON
      *
      ** Save the printed Tx identifier and account key as SaveCntRef and SaveAKey.
     C                   EVAL      SaveCntRef = XMCNTREF
     C                   EVAL      SaveAKey   = XMAKEY
     C                   SETON                                        5051
     C                   ELSE
      *
      ** Else if change on account key, print account key
     C                   IF        SaveAkey   <> XMAKEY
     C                   EVAL      SaveAKey   = XMAKEY
     C                   SETON                                        51
     C                   ENDIF                                                  FI SaveAKey<>XMAKEY
      *
     C                   ENDIF                                                  FI SaveCntRef <>
      *                                                                            XMCntRef
      *
      * Set up reason code description.
     C                   SELECT
     C                   WHEN      XMRSNCDE = 'M'
     C                   EVAL      REASON   = 'Account key mapping undefined'
     C                   WHEN      XMRSNCDE = 'P'
     C                   EVAL      REASON   = 'Pay/Receive undefined'
     C                   OTHER
     C                   EVAL      REASON   = XMRSNCDE
     C                   ENDSL
      *
      ** Set off any overflow indicator.
     C                   SETOFF                                       67
      *
      ** Write details
     C                   WRITE     DETAIL
      *
     C     WrtDetailE    ENDSR
      *
      *****************************************************************
      /TITLE SR/Audit
      *****************************************************************
      *                                                               *
      *  Audit  - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, *PSSR                            *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
      *
     C     Audit         BEGSR
      *
      ** RCF Processing for Audit File.
     C                   EXSR      RCFAU
      *
      ** Output Report Header and File Controls.
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
      ** If there is a DB Error, Output the DB Error Information.
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ENDIF
      *
     C                   WRITE     TRAILAU
      *
     C     AuditE        ENDSR
 
      *****************************************************************
      /TITLE SR/*INZSR
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Automatically                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Initialise LDA field.
      *
     C     *DTAARA       DEFINE    LDA           @LDA            256
      *
      ** RCF processing for P1 Report
     C                   EXSR      RCFP1
      *
      ** Get bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *blank        pRtnCod           7
     C                   PARM      '*FIRST'      POption           7
     C     SDBANK        PARM                    DSFDY
      *
     C                   IF        pRtnCod <> *blank
     C                   EVAL      wDbFile  = 'SDBANKL1'
     C                   EVAL      wDBase   = 1
     C                   EVAL      wDbKey   = '*FIRST'
     C                   EVAL      wDbMod   = 'AOBANKR0'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Write Report Heading
     C                   WRITE     RPTHEAD
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/CloseDown
      *****************************************************************
      *                                                               *
      *  CloseDown -  Return to Calling Program                       *
      *                                                               *
      *****************************************************************
     C     CloseDown     BEGSR
      *
     C                   EVAL      *INLR       = *ON
     C                   RETURN
 
     C     CloseDownE    ENDSR
      *
      *****************************************************************
      /TITLE SR/RCFP1
      *****************************************************************
      *                                                               *
      *  RCFP1  - Subroutine to register the P1 Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     RCFP1         BEGSR
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ               5
     C                   PARM      *BLANKS       SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
      ** If Error occurs during ZSFILE Processing, then return to the
      ** calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C     RCFP1E        ENDSR
      *
      *****************************************************************
      /TITLE SR/RCFAU
      *****************************************************************
      *                                                               *
      *  RCFAU  - Subroutine to register the AU Printer File via RCF. *
      *                                                               *
      *****************************************************************
      *
     C     RCFAU         BEGSR
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      ** If Error occurs during ZSFILE Processing, then return to the
      ** calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C     RCFAUE        ENDSR
      *
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        not inPssr
     C                   EVAL      inPssr      = *on
     C                   SETON                                        U7U8
      *
     C     *lock         IN        LDA
     C                   EVAL      dbpgm       = PSProcPgm
     C                   EVAL      dbfile      = wDbfile
     C                   EVAL      dbkey       = wDbkey
     C                   EVAL      dbase       = wDbase
     C                   EVAL      dbmod       = wDbmod
     C                   EVAL      dbproc      = wDbproc
     C                   OUT       LDA
      *
     C                   DUMP
     C                   EXSR      Audit
      *
     C                   ENDIF                                                  FI not inPssr
      *
     C                   EXSR      Closedown
      *
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
