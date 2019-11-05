     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Cust Sbjct to European Tax Audit List')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000765P -  SD Customers Subject to European Tax Audit List *
      *                                                               *
      *  Function:  This module reports the list of Customers subject *
      *             to European Tax                                   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 CER069             Date 03Jul14               *
      *                 CLE134             Date 01Aug12               *
      *                 AR750273B          Date 09Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26433           Date 02Dec09               *
      *                 CER045             Date 20Jul09               *
      *                 BUG23797A          Date 16Jun09               *
      *                 BUG23797           Date 23Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13252           Date 08Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 235085             Date 29Jul05               *
      *                 232543             Date 01Apr05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CER069 - German Tax Enhancement                              *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR750273B - Components failed due to closed customer         *
      *              (Child: AR750274)                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26433 - Correct counting of records in trailer report.    *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG23797A - Do not fail the component when the customer is   *
      *             deleted or closed                                 *
      *  BUG23797 - Replace AOCUSTR0 with AOCUSTR1                    *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  BUG13252 - Receiver value too small to hold result           *
      *  235085 - DBERR when customer is tagged as closed. Fix is to  *
      *           prevent database error and tag customer as closed   *
      *           in the report. Also, correct counting of records    *
      *           processed.                                          *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Error in reading file SDACUSL1                  *
      *    02         End of file for SDACUSL1                        *
      *    03         Record not found in SDFCTLL1                    *
      *    20         Audit mode, use for header                      *
      *    21         Out of balance, difference in number of records *
      *    22         Customer is closed                              *                       235085
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRPrint - Print details                                       *
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
 
      ** SD Identification Types details - Retrieve
     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** SD Cust Details by Country fo Tax - Rerieve
     FSDACTXL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Control file retrieval index
     FSDFCTLL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Cust Subjct to EuTax Printer file - Details
     FSD000765P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      ** Cust Subjct to EuTax Printer file - Audit
     FSD000765AUO    E             PRINTER INFDS(SPOOLU)
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
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access objects - short data structure                                       BUG23797
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG23797
                                                                                            BUG23797
      ** Data structure for access objects, long DS                                        AR750273B
     D DSSDY         E DS                  EXTNAME(DSSDY)                                  AR750273B
                                                                                           AR750273B
      ** Externally described DS for Country Details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      ** External DS for Customer Details by Country of Tax
     D SDACTX        E DS                  EXTNAME(SDACTXPD)
 
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTL1)
 
      ** File Information Data Structure for SD000765P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for SD000765AU.
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
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameters for access object programs
     D PRtcd           S              7
     D POptn           S              7
     D PCust           S             10
     D PKey            S              7
 
      ** Parameter list fields
     D PMode           S              1
     D PLevl           S              1
     D PEnty           S              3
     D PCncd           S              2
 
      ** Other fields used
     D WRun            S              1
     D WOpen           S              1    INZ('N')
     D WFirst          S              1    INZ('Y')
     D WFName          S             10
     D WNoRec          S              5  0 INZ(0)
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D WCtrt           S              2
     D CustFlag        S              1    INZ('Y')
     D KCust#          S                   like(E5CUST)
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
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
 
      ** Set file pointer to first record and do initial read.
 
     C     *LOVAL        SETLL     SDACUSL1
     C                   READ      SDACUSL1
 
     C                   IF        %eof(SDACUSL1)
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   DOU       %eof(SDACUSL1)
 
      ** Initialize Customer Flag
 
     C                   EVAL      CustFlag = 'Y'
 
      ***Count*no.*of*records*processed.*******************************              235085 BUG26433
      **********                                                                     235085 BUG26433
     C**********         EVAL      WNoRec = WNoRec + 1                               235085 BUG26433
 
      ** Chain Customer to Tax file SDACTXL1
 
     C                   EVAL      KCust# = E5CUST
     C     KLIST1        SETLL     SDACTXL1
     C     KLIST1        READE     SDACTXL1
     C                   DOW       NOT %EOF(SDACTXL1)
 
     C                   IF        AXETXS = 'T'
     C                             OR AXETXS = 'Y'                                            CER069
 
      ***Count*no.*of*records*processed.*******************************                       235085
      **********                                                                              235085
     C**********         EVAL      WNoRec = WNoRec + 1                                        235085
      ** Count no. of records processed.                                                    BUG26433
      *                                                                                     BUG26433
     C                   EVAL      WNoRec = WNoRec + 1                                      BUG26433
 
      ** Process Report Lines.
 
     C                   EXSR      SRPrint
 
      ** Customer Flag
 
     C                   EVAL      CustFlag = 'N'
 
     c                   ENDIF
 
      ** Read next chained record
 
     C     KLIST1        READE     SDACTXL1
 
     C                   ENDDO
 
      ** Read Customer record
 
     C                   READ      SDACUSL1
 
     C                   ENDDO
 
     C                   EXSR      SREnd
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrnt - Print details                                       *
      *                                                               *
      *****************************************************************
 
     C     SRPrint       BEGSR
 
     C                   IF        WOpen <> 'Y'
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SD000765P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = SFNUM1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      RqdLn1 = 2
 
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** For initial print of details or overflow has occured, print the Header
      ** of the report.
 
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF
 
      ** Initialize Printer file variables
 
     C                   EVAL      RCUST = *BLANKS
     C                   EVAL      RCRNM = *BLANKS
     C                   EVAL      RCRTN = *BLANKS
     C                   EVAL      RCTTX = *BLANKS
     C                   EVAL      RTXNM = *BLANKS
     C                   EVAL      RLCDT = *BLANKS
     C                   EVAL      RCHTP = *BLANKS
     C                   EVAL      *IN22 = '0'                                                235085
 
     C                   IF        CustFlag = 'Y'  or DifLn1 <= RqdLn1
     C                             or WFirst = 'Y'
 
      ** Customer Number
 
     C                   EVAL      RCUST = E5CUST
 
     C**********         CALL      'AOCUSTR0'                                               BUG23797
     C**********         CALL      'AOCUSTR1'                                     BUG23797 AR750273B
     C                   CALL      'AOCUSTR0'                                              AR750273B
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      E5CUST        PCust
     C                   PARM      *BLANKS       PKey
     C*****SDCUST        PARM      SDCUST        DSFDY                                      BUG23797
     C*****SDCUST        PARM      SDCUST        DSLDY                            BUG23797 AR750273B
     C     SDCUST        PARM      SDCUST        DSSDY                                     AR750273B
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C                             AND PRtcd <> '*CUSDEL'                                     235085
     C                             AND PRtcd <> '*CUSCLS'                                  AR750273B
     C**********                   AND BBCLST <> 'Y'                              BUG23797 BUG23797A
     C**********                   AND PRtcd <> '*CUSCLO'                        BUG23797A AR750273B
     C                   EVAL      DBFILE = 'SDCUSTL1'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = E5CUST
     C                   EXSR      *PSSR
     C                   ELSE
 
     C                   IF        PRtcd = '*CUSDEL'                                          235085
     C                             OR PRtcd = '*CUSCLS'                                    AR750273B
     C**********                   OR BBCLST = 'Y'                                BUG23797 BUG23797A
     C**********                   OR PRtcd = '*CUSCLO'                          BUG23797A AR750273B
     C                   EVAL      *IN22 = '1'                                                235085
     C                   ELSE                                                                 235085
     C                   EVAL      *IN22 = '0'                                                235085
     C                   ENDIF                                                                235085
                                                                                              235085
      ** Customer Report Name
 
     C                   EVAL      RCRNM = BBCRNM
 
      ** Customer Report Town
 
     C                   EVAL      RCRTN = BBCRTN
 
     C                   ENDIF
 
      ** Last Change Date
 
     C                   EVAL      ZDayNo = E5LCD
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
 
     C                   MOVE      ZADate        RLCDT
 
      ** Last Change Type
 
     C                   SELECT
     C                   WHEN      E5TYLC = 'I'
     C                   EVAL      RCHTP = 'Insert'
     C                   WHEN      E5TYLC = 'A'
     C                   EVAL      RCHTP = 'Amend '
     C                   WHEN      E5TYLC = 'D'
     C                   EVAL      RCHTP = 'Delete'
     C                   ENDSL
 
     C                   ENDIF
 
      ** Country of Tax
 
     C                   EVAL      RCTTX = AXCTTX
 
      ** Country of Tax
      ** Get Country Name
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      RCTTX         PCncd
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBKEY  = PCncd
     C                   EVAL      DBPGM  = 'SD000765P'
     C                   EVAL      DBASE  = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RTXNM = A4CNNM
     C                   ENDIF
 
      ** Write Detail
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write trailer in report                              *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR
 
     C                   IF        WOpen <> 'Y'                                             BUG13252
     C                   EVAL      WOpen = 'Y'                                              BUG13252
     C                   OPEN      SD000765P1                                               BUG13252
     C                   WRITE     HEADP1                                                   BUG13252
     C                   WRITE     NOREPO                                                   BUG13252
     C                   ENDIF                                                              BUG13252
      *                                                                                     BUG13252
     C                   IF        WNoRec > 0
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out report trailer.
 
     C                   WRITE     TRAILP1
 
      ** Retrieve control details.
 
     C**********         EVAL      WFName = 'SDACUSPD'                                      BUG26433
     C*****WFName        CHAIN     SDFCTLL1                           03                    BUG26433
 
      ***Database error.                                                                    BUG26433
 
     C**********         IF        RecNotFnd = True                                         BUG26433
     C******LOCK         IN        LDA                                                      BUG26433
     C**********         EVAL      DBKey = WFName                                           BUG26433
     C**********         EVAL      DBFile = 'SDACUSPD'                                      BUG26433
     C**********         EVAL      DBase = 004                                              BUG26433
     C**********         OUT       LDA                                                      BUG26433
     C**********         EXSR      *PSSR                                                    BUG26433
     C**********         ENDIF                                                              BUG26433
 
     C**********         EVAL      RINSER = AHNOIN                                          BUG26433
     C**********         EVAL      RAMEND = AHNOAM                                          BUG26433
     C**********         EVAL      RDELET = AHNODL                                          BUG26433
     C**********         EVAL      RAUDIT = AHNORC                                          BUG26433
     C                   EVAL      RCOUNT = WNoRec
 
     C**********         IF        RCOUNT <> RAUDIT                                         BUG26433
     C**********         EVAL      *IN21 = *On                                              BUG26433
     C**********         ELSE                                                               BUG26433
     C**********         EVAL      *IN21 = *Off                                             BUG26433
     C**********         ENDIF                                                              BUG26433
     C                   ENDIF
 
      ** Write audit report.
 
     C                   EXSR      SRAudit
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
     C                   OPEN      SD000765AU
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      ZSnumU = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
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
 
      ** If there is a record read, write audit control report.
 
     C                   IF        WNoRec <> 0
     C                   WRITE     CONTROL
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message.
 
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
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
     C                   PARM                    PRtcd
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevl
     C                   PARM                    PEnty
 
     C     KLIST1        KLIST
     C                   KFLD                    KCUST#
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
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
     C                   EVAL      PRTLN1 = 0
 
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
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
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
(c) Finastra International Limited 2004
