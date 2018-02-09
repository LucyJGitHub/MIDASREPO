     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Compliance Watch Hit List Housekeeping')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000030 - Compliance Watch Hit List Housekeeping            *
      *                                                               *
      *  Function:  This program tidies up the Compliance Watch Hit   *
      *             List File.  All records which haven't been checked*
      *             for one year and with a status of 'False Positive'*
      *             will be dropped.  A report showing the details of *
      *             the record dropped will be generated.             *
      *                                                               *
      *  Called By: SDC000030 - Compliance Watch Hit List Housekeeping*
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD019             Date 02Jun03               *
      *                 CSD015  *CREATE    Date 03Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD019 - Midas Compliance Watch - Entry Level Watch List     *
      *           Checking                                            *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    21         Print Function fields                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRINIT - Initialisation                                       *
      * SRPROC - Detail Processing                                    *
      * SRAUDT - Audit Printing                                       *
      * SRPRNT - Detail Printing                                      *
      * SRBKPR - Backup Printing                                      *                       CSD019
      * SRBKUP - Detail Backup                                        *                       CSD019
      * SRBKNM - Name Synonyms Backup                                 *                       CSD019
      * SRBKAD - Address Synonyms Backup                              *                       CSD019
      * SRBKCT - City Synonyms Backup                                 *                       CSD019
      * SRBKCO - Country Synonyms Backup                              *                       CSD019
      * SRRCFP1 - Detail Spool File recorded by RCF                   *
      * SRRCFP2 - Detail Spool File recorded by RCF                   *                       CSD019
      * SRP2HDR - P2 Header Printing                                  *                       CSD019
      * SRDATE - Convert Midas day number to date                     *
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
 
      ** Compliance Watch Hit List File
     FSDCWHTL0  UF   E           K DISK             INFSR(*PSSR)
 
      ** Compliance Watch Case External Match Details File                                    CSD019
     FSDCWCSL0  UF   E           K DISK    INFSR(*PSSR)                                       CSD019
                                                                                              CSD019
      ** Compliance Watch Case Matched Names Synonyms File                                    CSD019
     FSDCWNML0  UF   E           K DISK    INFSR(*PSSR)                                       CSD019
                                                                                              CSD019
      ** Compliance Watch Case Matched Address Synonyms File                                  CSD019
     FSDCWADL0  UF   E           K DISK    INFSR(*PSSR)                                       CSD019
                                                                                              CSD019
      ** Compliance Watch Case Matched City Synonyms File                                     CSD019
     FSDCWCTL0  UF   E           K DISK    INFSR(*PSSR)                                       CSD019
                                                                                              CSD019
      ** Compliance Watch Case Matched Country Synonyms File                                  CSD019
     FSDCWCOL0  UF   E           K DISK    INFSR(*PSSR)                                       CSD019
                                                                                              CSD019
      ** CW Backup Case External Match Details File                                           CSD019
     FSDCBCSPD  O    E             DISK    INFSR(*PSSR)                                       CSD019
     F                                     RENAME(SDCWCSD0 : SDCBCSD0)                        CSD019
                                                                                              CSD019
      ** CW Backup Case Matched Names Synonyms File                                           CSD019
     FSDCBNMPD  O    E             DISK    INFSR(*PSSR)                                       CSD019
     F                                     RENAME(SDCWNMD0 : SDCBNMD0)                        CSD019
                                                                                              CSD019
      ** CW Backup Case Matched Address Synonyms File                                         CSD019
     FSDCBADPD  O    E             DISK    INFSR(*PSSR)                                       CSD019
     F                                     RENAME(SDCWADD0 : SDCBADD0)                        CSD019
                                                                                              CSD019
      ** CW Backup Case Matched City Synonyms File                                            CSD019
     FSDCBCTPD  O    E             DISK    INFSR(*PSSR)                                       CSD019
     F                                     RENAME(SDCWCTD0 : SDCBCTD0)                        CSD019
                                                                                              CSD019
      ** CW Backup Case Matched Country Synonyms File                                         CSD019
     FSDCBCOPD  O    E             DISK    INFSR(*PSSR)                                       CSD019
     F                                     RENAME(SDCWCOD0 : SDCBCOD0)                        CSD019
                                                                                              CSD019
      ** Compliance Watch List Item Type Code Details File                                    CSD019
     FSDWLITL0  IF   E           K DISK    INFSR(*PSSR)                                       CSD019
                                                                                              CSD019
      ** Compliance Watch Hit List Details Dropped Printer File
     FSD000030P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
 
      ** Compliance Watch List Match Details Dropped Printer File                             CSD019
     FSD000030P2O    E             PRINTER USROPN                                             CSD019
     F                                     INFSR(*PSSR)                                       CSD019
     F                                     INFDS(SPOOL2)                                      CSD019
                                                                                              CSD019
      ** Compliance Watch Hit List Details Dropped Printer File (Audit)
     FSD000030AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
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
 
      ** Externally described DS for Switchable Feature details                               CSD019
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD019
                                                                                              CSD019
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** SC24X7 Data Area                                                                     CSD019
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSD019
                                                                                              CSD019
      ** SDSTAT Data Area                                                                     CSD019
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD019
                                                                                              CSD019
      ** File Information Data Structure for SD000030P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ** File Information Data Structure for SD000030P2                                       CSD019
     D SPOOL2          DS                                                                     CSD019
     D  PSFile2               83     92                                                       CSD019
     D  PSFNum2              123    124B 0                                                    CSD019
     D  OflLn2               188    189B 0                                                    CSD019
     D  PrtLn2               367    368B 0                                                    CSD019
                                                                                              CSD019
      ** File Information Data Structure for SD000030AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
     D PSard           S              6A                                                      CSD019
 
      ** Switchable Features                                                                  CSD019
     D CSD019          S              1A   INZ('N')                                           CSD019
     D CSC011          S              1A   INZ('N')                                           CSD019
                                                                                              CSD019
      ** Key Fields                                                                           CSD019
     D KFunTyp         S                   LIKE(W8FUNT)                                       CSD019
     D KIden           S                   LIKE(W8IDEN)                                       CSD019
     D KBrch           S                   LIKE(W8BRCH)                                       CSD019
     D KSysPrfx        S                   LIKE(W8SYSM)                                       CSD019
     D KMatCde         S                   LIKE(W8MATC)                                       CSD019
     D KItemCde        S                   LIKE(W1ITEM)                                       CSD019
                                                                                              CSD019
     D PMode           S              1
 
     D RqdLn1          S              3P 0
     D DifLn1          S              4P 0
     D RqdLn2          S              3P 0                                                    CSD019
     D DifLn2          S              4P 0                                                    CSD019
     D WTotDrp         S              4P 0                                                    CSD019
     D WorkNum         S              5P 0
     D PReptNam        S             10
     D WkDiff          S              5P 0
     D W1stDet         S              1A                                                      CSD019
 
     D WHead1          S             16
     D WLine1          S             16
     D WHead2          S             18
     D WLine2          S             18
 
     D ZDATE           S              6  0
     D ZADATE          S              7
 
     D WFunTyp         S                   LIKE(W8FUNT)                                       CSD019
     D WIden           S                   LIKE(W8IDEN)                                       CSD019
     D WBrch           S                   LIKE(W8BRCH)                                       CSD019
     D WSysPrfx        S                   LIKE(W8SYSM)                                       CSD019
     D WMatCde         S                   LIKE(W8MATC)                                       CSD019
     D WItemDsc        S                   LIKE(W1IDES)                                       CSD019
     D WError          S              1
     D PRetCode        S              7
     D NewPage         S              1
 
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
 
     C                   IF        CSD019 = 'Y'                                               CSD019
     C                   EXSR      SRRCFP2                                                    CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** Report Work fields.
 
     C                   EVAL      RqdLn1  = 0
     C                   EVAL      DifLn1  = 0
     C                   EVAL      PRTOTD  = 0
     C                   EVAL      PrtLn1  = 0
     C                   EVAL      WorkNum = 0
     C                   EVAL      WError = 'N'
     C                   EVAL      NewPage = 'N'
 
     C                   IF        CSD019 = 'Y'                                               CSD019
     C                   EVAL      RqdLn2 = *ZERO                                             CSD019
     C                   EVAL      DifLn2 = *ZERO                                             CSD019
     C                   EVAL      PrtLn2 = *ZERO                                             CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
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
 
     C                   IF        CSD019 = 'Y'                                               CSD019
     C                   WRITE     HEADP2                                                     CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C     *LOVAL        SETLL     SDCWHTL0
 
      ** Compliance Watch Hit List File
 
     C                   READ      SDCWHTD0
 
     C                   DOW       NOT %EOF(SDCWHTL0)
 
     C                   EVAL      WorkNum = WorkNum + 1
 
      ** If hit status is 'FALSPOSITIV' and last watch list check
      ** date is one year ago or earlier process record
 
     C                   EVAL      WkDiff = BJRDNB - W3LWCD
 
     C                   IF        W3HSTS = 'FALSPOSITV' AND WkDiff >= 365
     C                   EXSR      SRPRNT
                                                                                              CSD019
      ** Save key fields if CSD019 is enabled.                                                CSD019
                                                                                              CSD019
     C                   IF        CSD019 = 'Y'                                               CSD019
     C                   EVAL      WFunTyp = W3FUNT                                           CSD019
     C                   EVAL      WIden = W3IDEN                                             CSD019
     C                   EVAL      WBrch = W3BRCH                                             CSD019
     C                   ENDIF                                                                CSD019
 
      ** Delete record from file
 
     C                   DELETE    SDCWHTD0
 
      ** Backup the external matches and synonyms for this record                             CSD019
      ** if CSD019 is enabled.                                                                CSD019
                                                                                              CSD019
     C                   IF        CSD019 = 'Y'                                               CSD019
     C                   EXSR      SRBKUP                                                     CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   ENDIF
 
     C                   READ      SDCWHTD0
 
     C                   ENDDO
 
      ** When EOF, write trailer
 
     C                   IF        %EOF(SDCWHTL0)
 
     C                   EVAL      RqdLn1 = 8
     C                   EXSR      SRCHKLIN
 
     C                   WRITE     TRAILP1
 
     C                   IF        CSD019 = 'Y'                                               CSD019
     C                   EVAL      RqdLn2 = 8                                                 CSD019
     C                   EXSR      SRP2HDR                                                    CSD019
     C                   WRITE     TRAILP2                                                    CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
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
      * Calls: SRBRCH                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRPRNT        BEGSR
 
      ** Check for overflow
     C                   EVAL      RqdLn1 = 14
     C                   EXSR      SRCHKLIN
 
      ** Put details to printer fields.
 
      ** Print Function field only when not equal to previous
 
     C                   IF        PRFUNT <> W3FUNT
     C                   EVAL      PRFUNT = W3FUNT
     C                   EVAL      *IN21 = *ON
     C                   ELSE
     C                   IF        NewPage = 'Y'
     C                   EVAL      *IN21 = *ON
     C                   EVAL      NewPage = 'N'
     C                   ELSE
     C                   EVAL      *IN21 = *OFF
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      PRIDEN = W3IDEN
     C                   EVAL      PRBRCH = W3BRCH
     C                   EVAL      PRHSTS = W3HSTS
     C                   EVAL      PRUNCF = W3UNCF
     C                   EVAL      PRTREL = W3TREL
 
      ** Convert midas rundate to appropriate date format
     C                   EXSR      SRDATE
     C                   MOVE      ZADATE        PRLWCD
 
     C                   EVAL      PRTOTD = PRTOTD + 1
 
      ** Write Detail
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
 
      *****************************************************************                       CSD019
      /EJECT                                                                                  CSD019
      *****************************************************************                       CSD019
      *                                                               *                       CSD019
      *  SRBKUP - Backups the external matches and synonyms for a     *                       CSD019
      *           given Hit List record.                              *                       CSD019
      *                                                               *                       CSD019
      *  Called by: SRPROC                                            *                       CSD019
      *                                                               *                       CSD019
      *  Calls: SRBKPR, SRBKNM, SRBKAD, SRBKCT, SRBKCO                *                       CSD019
      *                                                               *                       CSD019
      *****************************************************************                       CSD019
                                                                                              CSD019
     C     SRBKUP        BEGSR                                                                CSD019
                                                                                              CSD019
      ** Initialise the first detail flag.                                                    CSD019
                                                                                              CSD019
     C                   EVAL      W1stDet = 'Y'                                              CSD019
                                                                                              CSD019
      ** Set the CW Case External Match Details Key Fields.                                   CSD019
                                                                                              CSD019
     C                   EVAL      KFunTyp = WFunTyp                                          CSD019
     C                   EVAL      KIden = WIden                                              CSD019
     C                   EVAL      KBrch = WBrch                                              CSD019
     C                   EVAL      KSysPrfx = WSysPrfx                                        CSD019
                                                                                              CSD019
     C     KCWCS         SETLL     SDCWCSL0                                                   CSD019
     C     KCWCS         READE     SDCWCSL0                                                   CSD019
                                                                                              CSD019
     C                   DOW       NOT %EOF(SDCWCSL0)                                         CSD019
                                                                                              CSD019
      ** Save the Match Code.                                                                 CSD019
                                                                                              CSD019
     C                   EVAL      WMatCde = W8MATC                                           CSD019
                                                                                              CSD019
      ** Find the Item Type Description.                                                      CSD019
                                                                                              CSD019
     C                   EVAL      KItemCde = W8ITEM                                          CSD019
     C     KItemCde      CHAIN     SDWLITL0                                                   CSD019
                                                                                              CSD019
     C                   IF        %FOUND(SDWLITL0)                                           CSD019
                                                                                              CSD019
     C                   IF        W1IDES <> *BLANKS                                          CSD019
     C                   EVAL      WItemDsc = W1IDES                                          CSD019
     C                   ELSE                                                                 CSD019
     C                   EVAL      WItemDsc = 'NO DESCRIPTION FOUND'                          CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   ELSE                                                                 CSD019
                                                                                              CSD019
     C     *LOCK         IN        LDA                                                        CSD019
     C                   EVAL      DBPGM = 'SD000030'                                         CSD019
     C                   EVAL      DBFILE = 'SDWLITPD'                                        CSD019
     C                   EVAL      DBKEY = KItemCde                                           CSD019
     C                   EVAL      DBASE = 101                                                CSD019
     C                   OUT       LDA                                                        CSD019
     C                   EVAL      WError = 'Y'                                               CSD019
     C                   EXSR      SRAUDT                                                     CSD019
                                                                                              CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** Backup details are set implicitly every time a READE occurs.                         CSD019
                                                                                              CSD019
     C                   WRITE     SDCBCSD0                                                   CSD019
     C                   DELETE    SDCWCSL0                                                   CSD019
                                                                                              CSD019
      ** Print the archived external matches for the current hit.                             CSD019
                                                                                              CSD019
     C                   EXSR      SRBKPR                                                     CSD019
                                                                                              CSD019
      ** Archive the referenced synonyms for the current hit.                                 CSD019
                                                                                              CSD019
     C                   EVAL      KMatCde = WMatCde                                          CSD019
                                                                                              CSD019
     C                   EXSR      SRBKNM                                                     CSD019
     C                   EXSR      SRBKAD                                                     CSD019
     C                   EXSR      SRBKCT                                                     CSD019
     C                   EXSR      SRBKCO                                                     CSD019
                                                                                              CSD019
     C     KCWCS         READE     SDCWCSL0                                                   CSD019
                                                                                              CSD019
     C                   ENDDO                                                                CSD019
                                                                                              CSD019
     C                   ENDSR                                                                CSD019
                                                                                              CSD019
      *****************************************************************                       CSD019
      /EJECT                                                                                  CSD019
      *****************************************************************                       CSD019
      *                                                               *                       CSD019
      *  SRBKPR - Prints the archived external matches for a given    *                       CSD019
      *           Hit List record.                                    *                       CSD019
      *                                                               *                       CSD019
      *  Called by: SRPROC                                            *                       CSD019
      *                                                               *                       CSD019
      *  Calls: SRP2HDR                                               *                       CSD019
      *                                                               *                       CSD019
      *****************************************************************                       CSD019
                                                                                              CSD019
     C     SRBKPR        BEGSR                                                                CSD019
                                                                                              CSD019
      ** Print a new header if necessary.                                                     CSD019
                                                                                              CSD019
     C                   EVAL      RqdLn2 = 14                                                CSD019
     C                   EXSR      SRP2HDR                                                    CSD019
                                                                                              CSD019
      ** Print the detail.                                                                    CSD019
                                                                                              CSD019
     C                   EVAL      R2MATC = WMatCde                                           CSD019
                                                                                              CSD019
     C                   IF        W1stDet = 'Y'                                              CSD019
     C                   EVAL      R2ITEM = WItemDsc                                          CSD019
     C                   EVAL      R2IDEN = WIden                                             CSD019
     C                   EVAL      R2BRCH = WBrch                                             CSD019
     C                   EVAL      R2SYSM = WSysPrfx                                          CSD019
     C                   EVAL      W1stDet = 'N'                                              CSD019
     C                   WRITE     DETLAP2                                                    CSD019
     C                   ELSE                                                                 CSD019
     C                   WRITE     DETLBP2                                                    CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** Update the number of matches dropped.                                                CSD019
                                                                                              CSD019
     C                   EVAL      WTotDrp = WTotDrp + 1                                      CSD019
     C                   EVAL      R2TOTD = WTotDrp                                           CSD019
                                                                                              CSD019
     C                   ENDSR                                                                CSD019
                                                                                              CSD019
      *****************************************************************                       CSD019
      /EJECT                                                                                  CSD019
      *****************************************************************                       CSD019
      *                                                               *                       CSD019
      *  SRBKNM - Archives the Name Synonyms for a given Hit List     *                       CSD019
      *           record.                                             *                       CSD019
      *                                                               *                       CSD019
      *  Called by: SRBKUP                                            *                       CSD019
      *                                                               *                       CSD019
      *  Calls: None                                                  *                       CSD019
      *                                                               *                       CSD019
      *****************************************************************                       CSD019
     C     SRBKNM        BEGSR                                                                CSD019
                                                                                              CSD019
     C     KMatCde       SETLL     SDCWNML0                                                   CSD019
     C     KMatCde       READE     SDCWNML0                                                   CSD019
                                                                                              CSD019
     C                   DOW       NOT %EOF(SDCWNML0)                                         CSD019
                                                                                              CSD019
      ** Backup details are set implicitly every time a READE occurs.                         CSD019
                                                                                              CSD019
     C                   WRITE     SDCBNMD0                                                   CSD019
     C                   DELETE    SDCWNML0                                                   CSD019
     C     KMatCde       READE     SDCWNML0                                                   CSD019
     C                   ENDDO                                                                CSD019
                                                                                              CSD019
     C                   ENDSR                                                                CSD019
                                                                                              CSD019
      *****************************************************************                       CSD019
      /EJECT                                                                                  CSD019
      *****************************************************************                       CSD019
      *                                                               *                       CSD019
      *  SRBKAD - Archives the Address Synonyms for a given Hit List  *                       CSD019
      *           record.                                             *                       CSD019
      *                                                               *                       CSD019
      *  Called by: SRBKUP                                            *                       CSD019
      *                                                               *                       CSD019
      *  Calls: None                                                  *                       CSD019
      *                                                               *                       CSD019
      *****************************************************************                       CSD019
     C     SRBKAD        BEGSR                                                                CSD019
                                                                                              CSD019
     C     KMatCde       SETLL     SDCWADL0                                                   CSD019
     C     KMatCde       READE     SDCWADL0                                                   CSD019
                                                                                              CSD019
     C                   DOW       NOT %EOF(SDCWADL0)                                         CSD019
                                                                                              CSD019
      ** Backup details are set implicitly every time a READE occurs.                         CSD019
                                                                                              CSD019
     C                   WRITE     SDCBADD0                                                   CSD019
     C                   DELETE    SDCWADL0                                                   CSD019
     C     KMatCde       READE     SDCWADL0                                                   CSD019
     C                   ENDDO                                                                CSD019
                                                                                              CSD019
     C                   ENDSR                                                                CSD019
                                                                                              CSD019
      *****************************************************************                       CSD019
      /EJECT                                                                                  CSD019
      *****************************************************************                       CSD019
      *                                                               *                       CSD019
      *  SRBKCT - Archives the City Synonyms for a given Hit List     *                       CSD019
      *           record.                                             *                       CSD019
      *                                                               *                       CSD019
      *  Called by: SRBKUP                                            *                       CSD019
      *                                                               *                       CSD019
      *  Calls: None                                                  *                       CSD019
      *                                                               *                       CSD019
      *****************************************************************                       CSD019
     C     SRBKCT        BEGSR                                                                CSD019
                                                                                              CSD019
     C     KMatCde       SETLL     SDCWCTL0                                                   CSD019
     C     KMatCde       READE     SDCWCTL0                                                   CSD019
                                                                                              CSD019
     C                   DOW       NOT %EOF(SDCWCTL0)                                         CSD019
                                                                                              CSD019
      ** Backup details are set implicitly every time a READE occurs.                         CSD019
                                                                                              CSD019
     C                   WRITE     SDCBCTD0                                                   CSD019
     C                   DELETE    SDCWCTL0                                                   CSD019
     C     KMatCde       READE     SDCWCTL0                                                   CSD019
     C                   ENDDO                                                                CSD019
                                                                                              CSD019
     C                   ENDSR                                                                CSD019
                                                                                              CSD019
      *****************************************************************                       CSD019
      /EJECT                                                                                  CSD019
      *****************************************************************                       CSD019
      *                                                               *                       CSD019
      *  SRBKCO - Archives the Country Synonyms for a given Hit List  *                       CSD019
      *           record.                                             *                       CSD019
      *                                                               *                       CSD019
      *  Called by: SRBKUP                                            *                       CSD019
      *                                                               *                       CSD019
      *  Calls: None                                                  *                       CSD019
      *                                                               *                       CSD019
      *****************************************************************                       CSD019
     C     SRBKCO        BEGSR                                                                CSD019
                                                                                              CSD019
     C     KMatCde       SETLL     SDCWCOL0                                                   CSD019
     C     KMatCde       READE     SDCWCOL0                                                   CSD019
                                                                                              CSD019
     C                   DOW       NOT %EOF(SDCWCOL0)                                         CSD019
                                                                                              CSD019
      ** Backup details are set implicitly every time a READE occurs.                         CSD019
                                                                                              CSD019
     C                   WRITE     SDCBCOD0                                                   CSD019
     C                   DELETE    SDCWCOL0                                                   CSD019
     C     KMatCde       READE     SDCWCOL0                                                   CSD019
     C                   ENDDO                                                                CSD019
                                                                                              CSD019
     C                   ENDSR                                                                CSD019
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAUDT - Audit Processing                                     *
      *                                                               *
      * Called by: Main Processing, *INZSR                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRAUDT        BEGSR
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     HEADAU
 
     C                   IF        WError = 'Y'
     C                   WRITE     DBERROR
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        WorkNum > 0
     C                   Z-ADD     WorkNum       RCOUNT
     C                   Z-ADD     PRTOTD        RPROCS
     C                   Z-ADD     PRTOTD        RDELTD
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
 
      ** End of program
 
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
 
     C                   OPEN      SD000030P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************                       CSD019
      /EJECT                                                                                  CSD019
      *****************************************************************                       CSD019
      *                                                               *                       CSD019
      *  SRRCFP2 - Records the Detail Spool File via RCF.             *                       CSD019
      *                                                               *                       CSD019
      *  Called by: SRINIT                                            *                       CSD019
      *                                                               *                       CSD019
      *  Calls: ZSFILE                                                *                       CSD019
      *                                                               *                       CSD019
      *****************************************************************                       CSD019
                                                                                              CSD019
     C     SRRCFP2       BEGSR                                                                CSD019
                                                                                              CSD019
     C                   OPEN      SD000030P2                                                 CSD019
                                                                                              CSD019
      ** Make sure that the Detail Spool File is recorded by RCF.                             CSD019
                                                                                              CSD019
     C                   EVAL      ZSnum = PSFNum2                                            CSD019
                                                                                              CSD019
     C                   CALL      'ZSFILE'                                                   CSD019
     C                   PARM                    PSeq                                         CSD019
     C                   PARM                    PEnty                                        CSD019
     C                   PARM                    PSFile2                                      CSD019
     C                   PARM                    ZSnum                                        CSD019
     C                   PARM      *BLANK        ZSErr                                        CSD019
                                                                                              CSD019
      ** Return to the calling program if an error occurred.                                  CSD019
                                                                                              CSD019
     C                   IF        ZSErr = 'Y'                                                CSD019
     C                   EVAL      *INU7 = *ON                                                CSD019
     C                   EVAL      *INU8 = *ON                                                CSD019
     C                   EVAL      *INLR = *ON                                                CSD019
     C                   RETURN                                                               CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   ENDSR                                                                CSD019
                                                                                              CSD019
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDATE - Convert Date to DDMMYY                               *
      *                                                               *
      * Called by: SRPRNT                                             *
      *                                                               *
      * Calls: ZDATE2                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRDATE        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    W3LWCD
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANKS       ZADATE
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCHKLIN - Checks for printer file overflow condition         *
      *                                                               *
      * Called by: SRPROC, SRPRNT                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCHKLIN      BEGSR
 
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   EVAL      NewPage = 'Y'
     C                   ENDIF
 
     C                   ENDSR
                                                                                              CSD019
      *****************************************************************                       CSD019
      /EJECT                                                                                  CSD019
      *****************************************************************                       CSD019
      *                                                               *                       CSD019
      *  SRP2HDR - Prints a new (P2) header if necessary.             *                       CSD019
      *                                                               *                       CSD019
      *  Called by: SRBKPR                                            *                       CSD019
      *                                                               *                       CSD019
      *  Calls: None                                                  *                       CSD019
      *                                                               *                       CSD019
      *****************************************************************                       CSD019
                                                                                              CSD019
     C     SRP2HDR       BEGSR                                                                CSD019
                                                                                              CSD019
     C                   EVAL      DifLn2 = OFLLN2 - PRTLN2                                   CSD019
                                                                                              CSD019
     C                   IF        DifLn2 <= RqdLn2                                           CSD019
     C                   WRITE     HEADP2                                                     CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   ENDSR                                                                CSD019
 
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
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Compliance Watch Case External Match Details Partial Key List                        CSD019
                                                                                              CSD019
     C     KCWCS         KLIST                                                                CSD019
     C                   KFLD                    KFunTyp                                      CSD019
     C                   KFLD                    KIden                                        CSD019
     C                   KFLD                    KBrch                                        CSD019
     C                   KFLD                    KSysPrfx                                     CSD019
                                                                                              CSD019
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
     C                   EVAL      DBPGM = 'SD000030'
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRAUDT
     C                   ENDIF
                                                                                              CSD019
      ** Check if CSD019 is enabled.                                                          CSD019
                                                                                              CSD019
     C                   CALL      'AOSARDR0'                                                 CSD019
     C                   PARM      *BLANKS       PRtCd                                        CSD019
     C                   PARM      '*VERIFY'     POptn                                        CSD019
     C                   PARM      'CSD019'      PSard                                        CSD019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD019
                                                                                              CSD019
     C                   IF        PRtCd = *BLANKS                                            CSD019
     C                   EVAL      CSD019 = 'Y'                                               CSD019
     C                   ELSE                                                                 CSD019
                                                                                              CSD019
     C                   IF        PRtCd <> '*NRF'                                            CSD019
     C     *LOCK         IN        LDA                                                        CSD019
     C                   EVAL      DBPGM = 'SD000030'                                         CSD019
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD019
     C                   EVAL      DBKEY = 'CSD019'                                           CSD019
     C                   EVAL      DBASE = 2                                                  CSD019
     C                   OUT       LDA                                                        CSD019
     C                   EVAL      WError = 'Y'                                               CSD019
     C                   EXSR      SRAUDT                                                     CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** Check if CSC011 is enabled.                                                          CSD019
                                                                                              CSD019
     C                   CALL      'AOSARDR0'                                                 CSD019
     C                   PARM      *BLANKS       PRtCd                                        CSD019
     C                   PARM      '*VERIFY'     POptn                                        CSD019
     C                   PARM      'CSC011'      PSard                                        CSD019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD019
                                                                                              CSD019
     C                   IF        PRtCd = *BLANKS                                            CSD019
     C                   EVAL      CSC011 = 'Y'                                               CSD019
     C                   ELSE                                                                 CSD019
                                                                                              CSD019
     C                   IF        PRtCd <> '*NRF'                                            CSD019
     C     *LOCK         IN        LDA                                                        CSD019
     C                   EVAL      DBPGM = 'SD000030'                                         CSD019
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD019
     C                   EVAL      DBKEY = 'CSC011'                                           CSD019
     C                   EVAL      DBASE = 3                                                  CSD019
     C                   OUT       LDA                                                        CSD019
     C                   EVAL      WError = 'Y'                                               CSD019
     C                   EXSR      SRAUDT                                                     CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** Set the System Prefix.                                                               CSD019
                                                                                              CSD019
     C                   IF        CSD019 = 'Y'                                               CSD019
                                                                                              CSD019
     C                   IF        CSC011 = 'Y'                                               CSD019
     C                   IN        SC24X7                                                     CSD019
     C                   EVAL      WSysPrfx = S1MAIN                                          CSD019
     C                   ELSE                                                                 CSD019
     C                   IN        SDSTAT                                                     CSD019
     C                   EVAL      WSysPrfx = LIBR                                            CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   ENDIF                                                                CSD019
 
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
     C                   EVAL      PRetCode = '*ERROR'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
