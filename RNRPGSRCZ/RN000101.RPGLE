     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*YES)                                                *
/*EXI *  TEXT('Midas FRS RN Failed Extraction Exception Report')
      *****************************************************************
      *                                                               *
      *  MidasPlus - FRS Regulatory Reporting Interface               *
      *                                                               *
      *  RPGLE/RN000101 - RN Transaction/Account Exception Report     *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CRN001  *CREATE    Date 22Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRN001 - FRS Regulatory Reporting Interface                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** RN Exception file (Position)
     FRNXCPNL0  IF   E           K DISK    INFSR(*PSSR)
      *
      * GP FRS Regulatory Authorities
     FGPREGAPD  IF   E           K DISK    INFSR(*PSSR)
      *
     FRN000101AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
      *
     FRN000101P1O    E             PRINTER INFDS(SPOOL1)
     F                                     INFSR(*PSSR)
     F                                     OFLIND(*IN67)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *    67 - Overflow indicator of P1 report                       *
      *   89  - End of File                                           *
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
      *  *INZSR    - Program initialisation                           *
      *  AUDIT     - Produce Audit Report and End Program             *
      *  CLOSEDOWN - Exit program subroutine                          *
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
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      /SPACE 3
 
      **  File Information Data Structure for RN000101P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      **  File Information Data Structure for RN000101AU.
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
     D DSFDY         E DS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ***  Work fields
     D FIRST           S              1
     D pRtnCod         S              7
     D pOption         S              7
     D RemainLine      S              3  0                                      remaining lines
     D SaveRegAut      S                   LIKE(XCREGAUT) INZ(' ')              Save Authority
 
     C/TITLE Main Processing
      *****************************************************************
      *
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EXSR      MAIN
 
     C                   EXSR      CLOSEDOWN
 
      *****************************************************************
      /TITLE SR/MAIN
      *****************************************************************
      *                                                               *
      *  MAIN   -  Main subroutine                                    *
      *                                                               *
      *****************************************************************
     C     MAIN          BEGSR
 
     C                   EVAL      FIRST = 'Y'
 
     C     *START        SETLL     RNXCPNL0
     C                   READ      RNXCPNL0                               89
 
     C     *IN89         DOWEQ     *OFF
 
      * If first record, write subheadings and column heading.
     C                   IF        FIRST = 'Y'
     C                   EVAL      FIRST = 'N'
     C                   EXSR      WrtHeader
     C                   ENDIF
      *
      ** Set off any overflow indicator.
     C                   SETOFF                                       67
      *
      ** Details line
     C                   WRITE     DETAIL
      *
      ** Increment record count
     C                   ADD       1             PCOUNT
 
     C                   READ      RNXCPNL0                               89
 
     C                   IF        NOT %EOF
      *
      ** On change of regulatory authority id or module, or overflow, start
      ** new page for report heading
     C                   IF        SaveRegAut  <> XCREGAUT OR
     C                             HTrnCls     <> XCTRNCLS OR
     C                             *IN67 = *ON
     C                   WRITE     HEADP1
     C                   EXSR      WrtHeader
      *
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
     C                   WRITE     HEADP1
     C                   ENDIF
      *
     C                   WRITE     TRAILP1
      *
      ** Write Audit
     C                   EXSR      Audit
      *
     C     MAINE         ENDSR
 
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      /TITLE SR/WrtHeader
      *****************************************************************
      *                                                               *
      *  WrtHeader  - Write Header (Regulatory Authority, Tx Class)   *
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
     C                   IF        SaveRegAut <> XCREGAUT
      *
     C     XCREGAUT      CHAIN     GPREGAPD
     C                   IF        %FOUND
     C                   EVAL      HRANAME = RANAME
     C                   ELSE
     C                   EVAL      wDbFile  = 'GPREGAPD'
     C                   EVAL      wDBase   = 2
     C                   EVAL      wDbKey   = XCREGAUT
     c                   EVAL      wDbMod   = ' '
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Output the regulatory authority id.
     C                   EVALR     HREGAUT     = %TRIMR(XCREGAUT)
      *
      **  Save the regulatory authority id. as SaveRegAut.
     C                   EVAL      SaveRegAut  = XCREGAUT
      *
     C                   ENDIF                                                  FI SaveRegAut
      *                                                                            <> XCREGAPD
     C                   EVAL      HTRNCLS  = XCTRNCLS
      *
      ** Write Header
     C                   WRITE     SUBHEAD1
      *
     C     WrtHeaderE    ENDSR
      *
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Initialise LDA field.
      *
     C     *DTAARA       DEFINE    LDA           @LDA            256
 
      ** RCF processing for P1 Report
     C                   EXSR      RCFP1
      *
      ** Get bank details.
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR'      pRtnCod
     C                   PARM      '*FIRST'      pOption
     C     SDBANK        PARM                    DSFDY
 
     C                   IF        pRtnCod <> *blank
     C                   EVAL      wDbFile  = 'SDBANKL1'
     C                   EVAL      wDBase   = 1
     C                   EVAL      wDbKey   = '*FIRST'
     C                   EVAL      wDbMod   = 'AOBANKR0'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Write Report Heading
     C                   WRITE     HEADP1
      *
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/AUDIT
      *****************************************************************
      *                                                               *
      *  AUDIT  - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, *PSSR                            *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
 
     C     AUDIT         BEGSR
 
      **  RCF Processing for Audit File.
     C                   EXSR      RCFAU
 
      **  Output Report Header and File Controls.
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
 
      **  If there is a DB Error, Output the DB Error Information.
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ENDIF
 
     C                   WRITE     TRAILAU
 
     C     AuditE        ENDSR
 
      *****************************************************************
      /TITLE SR/CLOSEDOWN
      *****************************************************************
      *                                                               *
      *  CLOSEDOWN -  Return to Calling Program                       *
      *                                                               *
      *****************************************************************
     C     CLOSEDOWN     BEGSR
 
     C                   EVAL      *INLR       = *ON
     C                   RETURN
 
     C     CloseDownE    ENDSR
 
      *****************************************************************
      /TITLE SR/RCFP1
      *****************************************************************
      *                                                               *
      *  RCFP1  - Subroutine to register the P1 Printer File via RCF. *
      *                                                               *
      *****************************************************************
 
     C     RCFP1         BEGSR
 
      **  Ensure Report Spool File recorded by RCF.
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ               5
     C                   PARM      *BLANKS       SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
 
      **  If Error occurs during ZSFILE Processing, then return to the
      **  Calling Program.
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
 
     C     RCFP1E        ENDSR
 
      *****************************************************************
      /TITLE SR/RCFAU
      *****************************************************************
      *                                                               *
      *  RCFAU  - Subroutine to register the AU Printer File via RCF. *
      *                                                               *
      *****************************************************************
 
     C     RCFAU         BEGSR
 
      **  Ensure Audit Spool File recorded by RCF.
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      **  If Error occurs during ZSFILE Processing, then return to the
      **  Calling Program.
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
 
     C     RCFAUE        ENDSR
 
      *********************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
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
(c) Finastra International Limited 2005
