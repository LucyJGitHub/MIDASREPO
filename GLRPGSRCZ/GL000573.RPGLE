     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account Transfer - Transfer Audit Report')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000573 - Midas GL Account Transfer - Transfer Audit Report *
      *                                                               *
      *  Function:  This program allows the user to produce an audit  *
      *   (I/C)     list of all records processed by the Account      *
      *             Transfer Utility Function.                        *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CGL114  *CREATE    Date 04Jan10               *
      *                 XXXXXX             Date DDMmmYY               *
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
     FGLAUTFL0  IF   E           K DISK    INFSR(*PSSR)
     F
     FGLATULL1  IF   E           K DISK    INFSR(*PSSR)
     F
     FGL000573P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN
     F                                     OFLIND(*IN81)
      *
     FGL000573AUO    E             PRINTER INFSR(*PSSR)
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
 
      ** File Information Data Structure for GL000573P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for GL000573AU
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Entry Parameter
     D PRSeq           S              5
 
      ** Access Object Parameters
     D PRtcd           S              7
     D POptn           S              7
 
      ** Other fields
     D MKI@            S             80
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D Previous_RFNO   S             10
 
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
 
     C                   Eval      Previous_RFNO = *Blanks
 
     C     *Loval        SetLL     GLAUTFL0
     C                   Read      GLAUTFL0                               01
 
     C                   If        Not %EoF(GLAUTFL0)
     C                   Exsr      SrRCFP1
     C                   Else
     C                   Exsr      SrAudit
     C                   Endif
 
     C                   DoW       NoT %EoF(GLAUTFL0)
 
      ** Output the details
 
     C                   Exsr      SrPrint
 
      ** Record count.
 
     C                   Eval      NOREC = NOREC + 1
     C                   Read      GLAUTFL0                               01
     C                   EndDo
 
     C                   Exsr      SREnd
 
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
 
      ** Write header
 
     C                   If        AURFNO <> Previous_RFNO
     C                   Eval      H1RFNO = AURFNO
     C                   Eval      H1PRCD = AUCRTD
 
     C     *HIVAL        SetGT     GLATULL1
     C                   ReadP     GLATULL1                               99
     C                   If        *In99 = *On
     C     *LOCK         In        LDA
     C                   Eval      DBKey = 'File Empty'
     C                   Eval      DBFile = 'GLATULPD'
     C                   Eval      DBase = 002
     C                   Eval      DBPGM = PSProcPgm
     C                   Out       LDA
     C                   Exsr      *PSSR
     C
     C                   Else
     C                   Eval      H1USER = ATUSER
     C                   Endif
 
     C                   Write     HEADP1
     C                   Eval      Previous_RFNO = AURFNO
     C                   Endif
 
     C                   Eval      R1FBRC = AUFBRC
     C                   Eval      R1FCNU = AUFCNU
     C                   Eval      R1FACO = AUFACO
     C                   Eval      R1FACS = AUFACS
     C                   Eval      R1TBRC = AUTBRC
     C                   Eval      R1TCNU = AUTCNU
     C                   Eval      R1TACO = AUTACO
     C                   Eval      R1TACS = AUTACS
     C                   Eval      R1FILE = AUFILE
     C                   Eval      R1TEXT = AUTEXT
 
     C                   Eval      RqdLn1 = 1
     C                   Eval      DifLn1 = OFLLN1 - PRTLN1
 
      ** For initial print of details or overflow has occured, print the Header
      ** of the report.
 
     C                   If        DifLn1 <= RqdLn1
     C                   Write     HEADP1
     C                   Endif
 
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
 
     C                   Write     HEADAU
     C                   Write     CONTROL
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   If        *INU7 = *On
     C                   Write     DBERROR
     C                   Else
 
      ** No records printed.
 
     C                   If        NOREC = 0
     C                   Write     NODTLS
     C                   Endif
     C                   Endif
 
     C                   Eval      *INLR = *On
     C                   Return
 
     C                   EndSr
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRCFAU - Register Audit Report in RCF                        *
      *                                                               *
      * Called by: Initialisation                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrRCFAU       BegSr
 
     C                   If        NOT %OPEN(GL000573AU)
     C                   Open      GL000573AU
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   Eval      ZSnumU = SFNUMU
 
     C                   Call      'ZSFILE'
     C                   Parm                    PRSeq
     C                   Parm      *Blanks       SEnty
     C                   Parm                    SFILEU
     C                   Parm                    ZSnumU
     C                   Parm      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSerr         IfEq      'Y'
     C                   SetOn                                        U7U8LR
     C                   Return
     C                   Endif
 
     C                   Endif
     C                   EndSr
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRCFP1 - Register P1 Report in RCF                           *
      *                                                               *
      * Called by: Main Procedure                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrRCFP1       BegSr
 
     C                   If        NOT %OPEN(GL000573P1)
     C                   Open      GL000573P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   Eval      ZSnum = SFNUM1
 
     C                   Call      'ZSFILE'
     C                   Parm                    PRSeq
     C                   Parm      *Blanks       SEnty
     C                   Parm                    SFILE1
     C                   Parm                    ZSnum
     C                   Parm      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSerr         IFEQ      'Y'
     C                   SetOn                                        U7U8LR
     C                   Return
     C                   Endif
 
     C                   Endif
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
 
     C                   If        %OPEN(GL000573P1)
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
 
     C                   If        %OPEN(GL000573AU)
     C                   Close     GL000573AU
     C                   Endif
 
     C                   If        %OPEN(GL000573P1)
     C                   Close     GL000573P1
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
     C                   Parm                    PRSeq
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
     C                   Eval      DBase = 003
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Exsr      SrRCFAU
 
      ** Report Work fields.
 
     C                   Eval      RqdLn1 = 0
     C                   Eval      DifLn1 = 0
     C                   Eval      PRTLN1 = 0
     C                   Eval      NOREC = 0
 
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
