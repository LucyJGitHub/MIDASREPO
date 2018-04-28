     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Tax Self Declaration Cert Expiry Report')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000766P - Tax Self Declaration Certificate Expiry Report   *
      *                                                               *
      *  Function:   This module will list all the self-declarations  *
      *              certificate which are due to expire in the       *
      *              next 30 days.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG24029           Date 20May09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 237337             Date 03Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 01Apr05               *
      *                 CGL035             Date 01Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  BUG22580 - Fields incorrectly labeled and lengths (Recompile)*
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  237337 - Avoid database error if customer deleted (ie,       *
      *           PRTCD = '*CUSDEL')                                  *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL035 - EUSD Upgrade to MidasPlus                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         End of file.                                    *
      *    03         Record not found.                               *
      *    04         Space between different Country of Tax Info     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRPrint1- Print details (Customer)                            *
      * SRPrint2- Print details (Non-Ac Holders)                      *
      * SREnd   - Write trailer in report                             *
      * SRAudit - Write audit report                                  *
      * *INZSR  - Initialise                                          *
      * *PSSR   - Error processing                                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** SD Cust Details by Country fo Tax
     FSDACTXL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** SD Non-A/c Holders by Country of Tax
     FSDNHTXL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** TA Swiss Installation Control Data
     FSDSTAXL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Certificate Expiry  Printer file - Details
     FSD000766P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      ** Certificate Expiry  Printer file - Audit
     FSD000766AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Externally described DS for Customer details
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** Externally described DS for Country Details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                            BUG24029
      ** DS for access objects - longt data structure                                       BUG24029
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG24029
 
      ** File Information Data Structure for SD0766P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for SD0766AU.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             01     01
     D  EndOfFile             02     02
     D  RecNotFnd             03     03
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for ZDATE2
     D ZDayNo          S              5P 0
     D ZDate           S              6P 0
     D ZADate          S              7A
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PRName          S             10                                                       CGL035
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameters for access object programs
     D PRtcd           S              7
     D POptn           S              7
     D PSARd           S              6
     D PCnCd           S              2
     D PKeySts         S              7
     D PCust           S             10
     D PNaho           S             10
 
      ** Parameter list fields
     D PMode           S              1
     D PLevl           S              1
     D PEnty           S              3
 
      ** Other fields used
     D WRun            S              1
     D WOpen           S              1    INZ('N')
     D WFirst          S              1    INZ('Y')
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D WDayExp         S              5  0
     D WNoRec          S              7  0
 
      ** Variables to hold previous values of fields
     D WPrevCUST       s                   like(AXCUST)
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Customer File Printing routine
      ** Set file pointer to first record and do initial read.
 
     C     *LOVAL        SETLL     SDACTXL1
     C                   READ      SDACTXL1                               02
 
     C                   DOW       EndOfFile = False
 
      ** Process only self-report records 'S' and about to expire within
      ** the next 30 days.
 
     C                   IF        AXETXS = 'S' AND
     C                             AXCEEX <= WDayExp
     C                   EXSR      SRPrint1
 
     C                   EVAL      WPrevCUST = AXCUST
 
     C                   ENDIF
 
     C                   READ      SDACTXL1                               02
 
     C                   ENDDO
 
      ** Non-A/c  File Printing Routine
 
     C                   EVAL      WPrevCUST = *Blanks
     C                   EVAL      *IN01     = *OFF
     C                   EVAL      *IN02     = *OFF
     C                   EVAL      *IN04     = *ON
 
      ** Set file pointer to first record and do initial read.
 
     C     *LOVAL        SETLL     SDNHTXL1
     C                   READ      SDNHTXL1                               02
 
     C                   DOW       EndOfFile = False
 
      ** Process only self-report records 'S' and about to expire within
      ** the next 30 days.
 
     C                   IF        NXETXS = 'S' AND
     C                             NXCEEX <= WDayExp
     C                   EXSR      SRPrint2
 
     C                   EVAL      WPrevCUST = NXNAHO
 
     C                   ENDIF
     C
     C                   READ      SDNHTXL1                               02
 
     C                   ENDDO
 
     C                   EXSR      SREnd
 
     C                   IF        EndOfFile = True
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrnt1- Print details (Customer File)                       *
      *                                                               *
      *****************************************************************
     C     SRPrint1      BEGSR
 
     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SD000766P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = SFNUM1
 
     C**********         CALL      'ZSFILE'                                                   CGL035
     C                   CALL      'ZSFILE2'                                                  CGL035
     C                   PARM                    PSeq
     C                   PARM      'SD000766P'   PRName                                       CGL035
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
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
 
     C                   ENDIF
 
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** For initial print of details or overflow has occured, print the Header
      ** of the report.
 
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF
 
      ** Write details to printer fields.
      ** Print Reference, Rept Name and Rept Town at the beginning of a new Reference
      ** group or at the beginning of a new page.
 
     C                   EVAL      RCUST = *Blanks
     C                   EVAL      RCRNM = *Blanks
     C                   EVAL      RCRTN = *Blanks
 
     C                   IF        AXCUST <> WPrevCUST OR
     C                             DifLn1 <= RqdLn1
     C
      ** Get Report Name and Report Town
 
     C                   EVAL      RCUST = AXCUST
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      AXCUST        PCust
     C                   PARM      *Blanks       PKeySts
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C*********          IF        PRtcd <> *Blanks                                   237337
     C                   IF        PRTCD <> *Blanks AND PRTCD <> '*CUSDEL'            237337
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBKey  = PCust
     C                   EVAL      DBase  = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      RCRNM = BBCRNM
     C                   EVAL      RCRTN = BBCRTN
     C                   ENDIF
 
     C                   EVAL      *IN04 = *ON
 
     C                   ENDIF
 
      ** Country of Tax Code
 
     C                   EVAL      RCTTX = AXCTTX
 
      ** Get Country of Tax Name.
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      AXCTTX        PCncd
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   EVAL      RCNNM = A4CNNM
 
      ** Certificate Reference
 
     C                   EVAL      RCERF = AXCERF
 
      ** Certificate Expiry Date
 
     C                   EVAL      ZDayNo = AXCEEX
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
 
     C                   MOVE      ZADate        RCEEX
 
      ** Write Detail
 
     C                   WRITE     DETAIL
 
     C                   EVAL      WNoRec = WNoRec + 1
     C                   EVAL      *IN04 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrnt2- Print details (Non-A/c Holders)                     *
      *                                                               *
      *****************************************************************
     C     SRPrint2      BEGSR
 
     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SD000766P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = SFNUM1
 
     C**********         CALL      'ZSFILE'                                                   CGL035
     C                   CALL      'ZSFILE2'                                                  CGL035
     C                   PARM                    PSeq
     C                   PARM      'SD000766P'   PRName                                       CGL035
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
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
 
     C                   ENDIF
 
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** For initial print of details or overflow has occured, print the Header
      ** of the report.
 
     C                   EVAL      RCUST = *Blanks
     C                   EVAL      RCRNM = *Blanks
     C                   EVAL      RCRTN = *Blanks
 
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF
 
      ** Write details to printer fields.
      ** Print Reference, Rept Name and Rept Town at the beginning of a new Reference
      ** group or at the beginning of a new page.
 
     C                   IF        NXNAHO <> WPrevCUST OR
     C                             DifLn1 <= RqdLn1
     C
      ** Get Report Name and Report Town
 
     C                   EVAL      RCUST = NXNAHO
 
     C                   CALL      'AONAHOR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      NXNAHO        PCust
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      BUG24029
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24029
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBKey  = PCust
     C                   EVAL      DBase  = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      RCRNM = NHNARN
     C                   EVAL      RCRTN = NHNATW
     C                   ENDIF
 
     C                   EVAL      *IN04 = *ON
 
     C                   ENDIF
 
      ** Country of Tax Code
 
     C                   EVAL      RCTTX = NXCTTX
 
      ** Get Country of Tax Name.
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      NXCTTX        PCncd
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C                   EVAL      RCNNM = A4CNNM
 
      ** Certificate Reference
 
     C                   EVAL      RCERF = NXCERF
 
      ** Certificate Expiry Date
 
     C                   EVAL      ZDayNo = NXCEEX
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
 
     C                   MOVE      ZADate        RCEEX
 
      ** Write Detail
 
     C                   WRITE     DETAIL
 
     C                   EVAL      WNoRec = WNoRec + 1
     C                   EVAL      *IN04 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
     C                   OPEN      SD000766AU
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      ZSnumU = SFNUMU
 
     C**********         CALL      'ZSFILE'                                                   CGL035
     C                   CALL      'ZSFILE2'                                                  CGL035
     C                   PARM                    PSeq
     C                   PARM      'SD000766P'   PRName                                       CGL035
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
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
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write trailer in report                              *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR
 
     C                   IF        WNoRec > 0
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out report trailer.
 
     C                   WRITE     TRAILP1
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
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
     C                   PARM                    PRtcd
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevl
     C                   PARM                    PEnty
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Report Work fields.
 
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PrtLn1 = 0
 
      ** Intialize variables and *IN04
 
     C                   EVAL      WPrevCUST = *Blanks
     C                   EVAL      *IN04     = *ON
     C                   EVAL      WNoRec    = *Zeros
 
      ** Add Exemption Certificates Report Days to rundate to be
      ** used as Expiry Date
 
     C     *LOVAL        SETLL     SDSTAXL1
     C                   READ      SDSTAXL1                               03
     C                   IF        RecNotFnd = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = *Blanks
     C                   EVAL      DBFILE = 'SDSTAXPD'
     C                   EVAL      DBASE = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WDayExp   = BJRDNB + TXCEXD
 
      ** Database fields
 
     C                   EVAL      DBKey  = *Blanks
     C                   EVAL      DBFile = *Blanks
     C                   EVAL      DBase  = *Zeros
     C                   EVAL      DBPgm  = 'SD000766P'
 
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
 
     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
