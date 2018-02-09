     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account Transfer Utility Criteria List')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000571 - Midas GL Account Transfer Utility Criteria List   *
      *                                                               *
      *  Function:  This program allows the user to produce a list    *
      *   (I/C)     of all records stored in the Account Transfer     *
      *             Converion File, GLACRFPD.                         *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CGL114  *CREATE    Date 04Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL114 - Account Transfer Utility                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  01 - 19      Input Control.                                  *
      *  20 - 29      I/O Conditioning (ie. CHAIN, LOKUP etc...)      *
      *   20          Record Not Found                                *
      *   21          File Error Occurred                             *
      *   22          Start/End Of File Reached                       *
      *   25          Lookup/Scan.                                    *
      *  30 - 39      Program Work Indicators                         *
      *  40 - 49      Output Control.                                 *
      *  50 - 89      Output Conditioning (ie. Cursor Positioning)    *
      *  90 - 99      Error Control.                                  *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
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
     FGLACRFL0  IF   E           K DISK    INFSR(*PSSR)
     F
     FGL000571P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN
     F                                     OFLIND(*IN81)
      *
     FGL000571AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
     F                                     USROPN
     F                                     OFLIND(*IN82)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
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
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * Definition: First DS for Access Programs, Short Data Structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Definition: Bank Details Accessed Via Access Program.
 
      ** File Information Data Structure for GL000571P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for GL000571AU
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Entry Paramerter
     D PSEQ            S              5
 
      ** Access Object Parameters
     D PRtcd           S              7
     D POptn           S              7
 
      ** Other fields
     D MKI@            S             80
     D WNoRec          S              5S 0 INZ(0)
     D WFirst          S              1    INZ('Y')
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
 
      ** Parameters for ZSFILE
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
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
 
      ** Set file pointer to first record and do initial read.
 
     C     *Loval        SetLL     GLACRFL0
     C                   Read      GLACRFL0                               01
 
     C                   If        %EoF(GLACRFL0)
     C                   Exsr      SrAudit
     C                   Endif
 
     C                   DoW       NoT %EoF(GLACRFL0)
 
      ** Output the details
 
     C                   SetOff                                       545556
     C                   Exsr      SrPrint
 
      ** Record count.
 
     C                   Eval      WNoRec = WNoRec + 1
     C                   Read      GLACRFL0                               01
     C                   EndDo
 
     C                   Exsr      SREnd
     C                   Return
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrint - Print Detail Report                                 *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRPrint       BegSr
 
     C                   If        NOT %OPEN(GL000571P1)
     C                   Open      GL000571P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   Eval      ZSnum = SFNUM1
 
     C                   Call      'ZSFILE'
     C                   Parm                    PSeq
     C                   Parm      *Blanks       SEnty
     C                   Parm                    SFILE1
     C                   Parm                    ZSnum
     C                   Parm      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   SetOn                                        U7U8LR
     C                   Return
     C                   Endif
 
     C                   Endif
 
     C                   Eval      RqdLn1 = 1
     C                   Eval      DifLn1 = OFLLN1 - PRTLN1
 
      ** For initial print of details or overflow has occured, print the Header
      ** of the report.
 
     C                   If        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   Write     HEADP1
     C                   Eval      WFirst = 'N'
     C                   Endif
 
      ** Write details to printer fields.
 
     C                   Move      ACRFNO        P1RFNO
     C                   Eval      P1DESC = ACDESC
     C                   Eval      P1BRCA = ACBRCA
     C                   Eval      P1CNU1 = ACCNU1
     C                   Eval      P1CNU2 = ACCNU2
     C                   If        P1CNU2 <> *Blanks
     C                   Eval      *IN54 = *ON
     C                   Endif
     C                   Eval      P1CCY = ACCCY
     C                   Move      ACACO1        P1ACO1
     C                   Move      ACACO2        P1ACO2
     C                   If        P1ACO2 <> *Blanks
     C                   Eval      *IN55 = *ON
     C                   Endif
     C                   Move      ACACSQ        P1ACSQ
     C                   Eval      P1ACN1 = ACACN1
     C                   Eval      P1ACN2 = ACACN2
     C                   If        P1ACN2 <> *Blanks
     C                   Eval      *IN56 = *ON
     C                   Endif
     C                   Eval      P1ACOC = ACACOC
     C                   Eval      P1ATYP = ACATYP
     C                   Eval      P1COLC = ACCOLC
     C                   Eval      P1STAT = ACSTAT
     C                   Eval      P1TBRC = ACTBRC
     C                   Eval      P1TCNU = ACTCNU
     C                   Move      ACTACO        P1TACO
     C                   Move      ACTACS        P1TACS
     C                   Eval      P1CRTD = ACCRTD
     C                   Eval      P1PRCD = ACPRCD
     C                   Write     DETAIL
 
     C                   EndSr
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit - Write audit report                                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRAudit       BegSr
 
     C                   If        NOT %OPEN(GL000571AU)
     C                   Open      GL000571AU
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   Eval      ZSnumU = SFNUMU
 
     C                   Call      'ZSFILE'
     C                   Parm                    PSeq
     C                   Parm      *Blanks       SEnty
     C                   Parm                    SFILEU
     C                   Parm                    ZSnumU
     C                   Parm      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IfEq      'Y'
     C                   SetOn                                        U7U8LR
     C                   Return
     C                   Endif
 
     C                   Endif
 
     C                   Write     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   If        *INU7 = *On
     C                   Write     DBERROR
     C                   Endif
 
      ** No records printed.
 
     C                   If        WNoRec = 0 And
     C                             *INU7 = *Off
     C                   Write     NODTLS
     C                   Endif
 
     C                   Eval      *INLR = *On
     C                   Return
 
     C                   EndSr
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - Write Trailer in Report
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SREnd         BegSr
 
      ** Print detail report only if there are records to print.
 
     C                   If        %OPEN(GL000571P1)
     C                   Eval      RqdLn1 = 4
     C                   Eval      DifLn1 = OFLLN1 - PRTLN1
     C                   If        DifLn1 <= RqdLn1
     C                   Write     HEADP1
     C                   Endif
 
 
      ** Write out report trailer.
 
     C                   Write     TRAILP1
     C                   Endif
 
      ** Write audit report.
     C                   Exsr      SRAudit
 
      ** Close printer files.
 
     C                   If        %OPEN(GL000571AU)
     C                   Close     GL000571AU
     C                   Endif
 
     C                   If        %OPEN(GL000571P1)
     C                   Close     GL000571P1
     C                   Endif
 
     C                   Eval      *INLR = *On
     C                   Return
 
     C                   EndSr
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
     C     *INZSR        BegSr
 
     C     *Entry        Plist
     C                   Parm                    PSEQ
      *
      ** Read in Installation Data
      *
     C     *DTAARA       Define                  LDA
 
     C     *LOCK         In        LDA
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Out       LDA
 
      * Retrieve Bank Details.
 
     C                   Call      'AOBANKR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*FIRST '     POptn
     C     SDBANK        Parm      SDBANK        DSFDY
      *
     C                   If        PRtcd <> *Blanks
     C     *LOCK         In        LDA
     C                   Eval      DBKey = POptn
     C                   Eval      DBFile = 'SDBANKPD'
     C                   Eval      DBase = 001
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
 
      ** Report Work fields.
 
     C                   Eval      RqdLn1 = 0
     C                   Eval      DifLn1 = 0
     C                   Eval      PRTLN1 = 0
     C                   Eval      WNoRec = 0
 
     C                   Movea     CPY@          MKI@
 
     C                   EndSr
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
      *
     C     *PSSR         BegSr
      *
     C                   If        @RUN = *BLANK
     C                   Eval      @RUN = 'Y'
     C                   Eval      *INU7 = *On
     C                   Eval      *INU8 = *On
     C                   Eval      *INLR = *On
     C                   Dump
     C                   Exsr      SRAudit
     C                   Call      'DBERRCTL'
     C                   Endif
      *
     C                   Eval      *INU7 = *On
     C                   Eval      *INU8 = *On
     C                   Eval      *INLR = *On
 
     C                   Return
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2010
