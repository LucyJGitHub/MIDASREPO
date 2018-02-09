     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL ATU Accounts for Demand Interest Capitali')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLC000580 - Midas GL ATU Accounts for Demand Interest        *
      *              Capitalisation Audit List                        *
      *                                                               *
      *  Function:  This program allows the user to generate a        *
      *   (I/C)     complete list of selected accounts that has been  *
      *             successfully requested for demand interest        *
      *             capitalisation by the Account Transfer Utility    *
      *             function.                                         *
      *                                                               *
      *  Called By: GLC000580                                         *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CGL114A *CREATE    Date 12Mar10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CGL114A - CCR Interest Capitalisation                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *   81          Overflow P1                                     *
      *   82          Overflow AU                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SrPrint - Print Detail Report                                 *
      * SrAudit - Write Audit Report                                  *
      * SrRCFAU - Register Audit Report in RCF                        *
      * SrRCFP1 - Register P1 Report in RCF                           *
      * SrEnd   - Write Trailer in Report                             *
      * *PSSR   - Error processing                                    *
      * *INZSR  - Initialise                                          *
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
     FGLSLACL8  IF   E           K DISK    INFSR(*PSSR)
     F
     FGLIPDFPD  IF   E           K DISK    INFSR(*PSSR)
     F
     FGL000580P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN
     F                                     OFLIND(*IN81)
      *
     FGL000580AUO    E             PRINTER INFSR(*PSSR)
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
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Definition: First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Definition: First DS for Access Programs, Long Data Structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Definition: Bank Details Accessed Via Access Program.
 
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
      ** Definition: Account Master Details Accessed Via Access Program.
 
      ** File Information Data Structure for GL000580P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for GL000580AU
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
     D PRetl           S             10
     D PCnum           S              6
     D PCucd           S              3
     D PAccd           S             10
     D PAcsq           S              2
     D PBrca           S              3
 
      ** Other fields
     D CPY2@           S             80
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D WACCTFR         S              1
 
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
 
      ** Generate report validation
 
     C                   IF        WACCTFR <> 'Y' OR
     C                             BDDICR  <> 'Y'
     C                   EXSR      SrAudit
     C                   ENDIF
 
      ** Set file pointer to first record and do initial read.
 
     C     *LOVAL        SETLL     GLSLACL8
     C                   READ      GLSLACL8
 
     C                   IF        NOT %EOF(GLSLACL8)
     C                   EXSR      SrRCFP1
     C                   ELSE
     C                   EXSR      SrAudit
     C                   ENDIF
 
     C                   DOW       NOT %EOF(GLSLACL8)
 
      ** Retrieve Account details
 
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      SLACNO        PRetl
     C                   PARM      SLFCNU        PCnum
     C                   PARM      SLCCY         PCucd
     C                   PARM      SLFACO        PAccd
     C                   PARM      SLFACS        PAcsq
     C                   PARM      SLFBRC        PBrca
     C     SDACCT        PARM      SDACCT        DSSDY
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey  = PRetl+PCnum+PCucd+PAccd+PAcsq+PBrca
     C                   EVAL      DBFile = 'ACCNTAB'
     C                   EVAL      DBase  = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Output the details if Account type is Retail
 
     C                   IF        ATYP = 'R' AND
     C                             LTAC = 0
     C                   EXSR      SrPrint
      ** Record count.
     C                   EVAL      NOREC = NOREC + 1
     C                   ENDIF
 
     C                   READ      GLSLACL8
     C                   ENDDO
 
     C                   EXSR      SrEnd
 
      *****************************************************************
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
     C     SrPrint       BEGSR
 
     C                   EVAL      R1RFNO = SLRFNO
     C                   EVAL      R1FBRC = SLFBRC
     C                   EVAL      R1FCNU = SLFCNU
     C                   EVAL      R1CCY  = SLCCY
     C                   EVAL      R1FACO = SLFACO
     C                   EVAL      R1FACS = SLFACS
     C                   EVAL      R1ACNO = SLACNO
     C                   EVAL      R1ACOC = SLACOC
     C                   EVAL      R1ATYP = SLATYP
     C                   EVAL      R1COLC = SLCOLC
     C                   EVAL      R1CRTD = SLCRTD
     C                   EVAL      R1TBRC = SLTBRC
     C                   EVAL      R1TCNU = SLTCNU
     C                   EVAL      R1TACO = SLTACO
     C                   EVAL      R1TACS = SLTACS
 
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** For initial print of details or overflow has occured, print the Header
      ** of the report.
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit - Write audit report                                  *
      *                                                               *
      * Called by: Main Processing, SREnd, *PSSR                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR
 
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** No records printed.
 
     C                   IF        NOREC = 0
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
 
      ** Close printer files.
 
     C                   IF        %OPEN(GL000580AU)
     C                   CLOSE     GL000580AU
     C                   ENDIF
 
     C                   IF        %OPEN(GL000580P1)
     C                   CLOSE     GL000580P1
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
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
     C     SrRCFAU       BEGSR
 
     C                   IF        NOT %OPEN(GL000580AU)
     C                   OPEN      GL000580AU
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      ZSnumU = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PRSeq
     C                   PARM      *BLANKS       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *BLANK        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        ZSerr = 'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
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
     C     SrRCFP1       BEGSR
 
     C                   IF        NOT %OPEN(GL000580P1)
     C                   OPEN      GL000580P1
 
     C                   WRITE     HEADP1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = SFNUM1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PRSeq
     C                   PARM      *BLANKS       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *BLANK        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        ZSerr = 'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - Write Trailer in Report                               *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrEnd         BEGSR
 
      ** Print detail report only if there are records to print.
 
     C                   IF        %OPEN(GL000580P1)
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out report trailer.
 
     C                   WRITE     TRAILP1
     C                   ENDIF
 
      ** Write audit report.
 
     C                   EXSR      SrAudit
 
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
     C                   PARM                    PRSeq
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
      ** Retrieve ACCTFR Data
 
     C     *DTAARA       DEFINE    ACCTFR        WACCTFR
     C                   IN        WACCTFR
 
     C                   EXSR      SrRCFAU
 
      ** Retrieve Account Transfer Batch I/F Defaults
 
     C                   READ      GLIPDFPD
 
     C                   IF        %EOF(GLIPDFPD)
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey  = 'No REC'
     C                   EVAL      DBFile = 'GLIPDFPD'
     C                   EVAL      DBase  = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve Bank Details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey  = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase  = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Report Work fields.
 
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
     C                   EVAL      NOREC = 0
 
     C                   MOVEA     CPY@          CPY2@
 
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
      *
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   EXSR      SrAudit
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2010
