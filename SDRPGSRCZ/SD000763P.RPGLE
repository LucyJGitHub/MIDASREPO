     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Joint Account Members Audit List')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000763P - SD Joint Account Members Audit List              *
      *                                                               *
      *  Function:  This program generates joint account members      *
      *             audit list                                        *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG24863           Date 10Jul09               *
      *                 BUG24029           Date 20May09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSW207             Date 23Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 237337             Date 03Oct06               *
      *                 232543             Date 01Apr05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24863 - SDC541P 10081                                     *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  BUG22580 - Fields incorrectly labeled and lengths (Recompile)*
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  237337 - Avoid database error if customer deleted (ie,       *
      *           PRTCD = '*CUSDEL')                                  *
      *  232543 - Fix to CGL032 (Recompile)                           *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of file SDJACCL1                            *
      *    02         READE SDJACCL1                                  *
      *    04         Report spacing, break on Joint Account No.      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  *PSSR         -  Error handling subroutine                   *
      *  SRNonAcHol    -  Retrieve Non A/c holder from SDJACCL3       *
      *  SRCustRec     -  Retrieve customer details from SDJACCL1     *
      *  SRPrint       -  Print Detail Report                         *
      *  SREnd         -  Write Trailer in Report                     *
      *  SRAudit       -  Write audit report                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** SD Joint Account Member Details - Retrieve
     FSDJACCL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** SD Joint Account Member Details
     FSDJACCL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDJACCD0:SDJACCD3)
     F                                     PREFIX(N)
 
      ** Control file retrieval index
     FSDFCTLL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** SD Joint Account Members Audit List - Detail
     FSD000763P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      ** SD Joint Account Members Audit List - Audit
     FSD000763AUO    E             PRINTER INFDS(SPOOLU)
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
 
      ** Externally described DS for Customer Number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Externally described DS for Non A/c Holder Reference
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** DS for access objects - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                            BUG24029
      ** DS for access objects - long data structure                                        BUG24029
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG24029
                                                                                              CSW207
      **  Short DS for access programs                                                        CSW207
     D DSFDY         E DS                  Extname(DSFDY)                                     CSW207
                                                                                              CSW207
      ** External DS for Midas modules details                                                CSW207
     D SDMMOD        E DS                  Extname(SDMMODPD)                                  CSW207
 
      ** File Information Data Structure for SD000763P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for SD000763AU
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      ** True and False can be used for indicators being on or off.
     D True            C                   *On
     D False           C                   *Off
 
      ** Value will be used to search Standing Data Control file.
     D WFileName       C                   CONST('SDJACCPD  ')
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
      *
      ** Parameters for access object programs
     D PRtcd           S              7
     D POptn           S              7
     D PKey            S              7
     D PSARd           S              6
     D PCustNo         S             10
 
      ** Parameter list fields
     D PMode           S              1
     D PLevl           S              1
     D PEnty           S              3
 
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
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** Other fields used
     D WRun            S              1
     D WLvl1           S              1    INZ('Y')
     D WNoRec          S              5S 0 INZ(0)
     D WNAHFlg         S              1
     D WFirst          S              1    INZ('Y')
     D WJAcNum         S              6
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D CGL031          S              1    INZ(' ')                                           CSW207
     D CGL032          S              1    INZ(' ')                                           CSW207
     D PrivBank        S              1    INZ(' ')                                           CSW207
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
 
     C     *LOVAL        SETLL     SDJACCL1
     C                   READ      SDJACCL1                               01
 
     C                   EVAL      WJAcNum = JCJANO
     C                   EVAL      *IN04 = *ON
 
     C                   DOW       EndOfFile = False
 
     C                   IF        JCJANO <> WJacNum
     C                   EVAL      *IN04 = *ON
     C                   EVAL      WLvl1 = 'Y'
     C                   ENDIF
 
      ** Process all Non a/c holders.
 
     C                   IF        JCCUST = *BLANKS
     C                   IF        WLvl1 = 'Y'
     C                   EXSR      SRNonACHol
     C                   EVAL      WJAcNum = JCJANO
     C                   ENDIF
 
     C                   ELSE
 
      ** Store report details of customer.
 
     C                   EXSR      SRCustRec
     C                   ENDIF
     C                   EVAL      WJAcNum = JCJANO
 
      ** Record count.
 
     C                   EVAL      WNoRec = WNoRec + 1
 
     C                   READ      SDJACCL1                               01
     C                   ENDDO
 
     C                   EXSR      SREnd
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNonAcHol - Retrieve Non A/c holder                          *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: SRPrint                                                *
      *                                                               *
      *****************************************************************
 
     C     SRNonAcHol    BEGSR
 
 
     C     JCJANO        SETLL     SDJACCL3
     C     JCJANO        READE     SDJACCL3                               02
 
     C                   DOW       *IN02 = *OFF
 
     C                   IF        NJCNAHO <> *BLANKS
 
      ** Joint Account Number
 
     C                   IF        WLvl1 = 'Y'
     C                   EVAL      RJANO = NJCJANO
     C                   ENDIF
 
      ** Joint Account Report Name
 
     C                   IF        WLvl1 = 'Y'
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      NJCJANO       PCustNo
     C                   PARM      *BLANKS       PKey
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database error.
 
     C*********          IF        PRtcd <> *Blanks                                   237337
     C                   IF        PRTCD <> *Blanks AND PRTCD <> '*CUSDEL'            237337
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCustNo
     C                   EVAL      DBFile = 'SDCUSTL1'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RJANM = BBCRNM
     C                   ENDIF
 
     C                   ENDIF
 
      ** Non-account Holder report name
 
     C                   CALL      'AONAHOR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      NJCNAHO       PCustNo
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      BUG24029
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24029
 
      ** Database error.
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCustNo
     C                   EVAL      DBFile = 'SDNAHOL1'
     C                   EVAL      DBase = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RCRNM = NHNARN
     C                   EVAL      RCRTN = NHNATW
     C                   ENDIF
 
      ** Non Account Holder Reference
 
     C                   EVAL      RREFN = NJCNAHO
 
      ** Investment Proportion
 
     C                   EVAL      RINVP  = NJCINVP
 
      ** Prime A/C Holder for Tax Purposes
 
     C                   EVAL      RPAHT  = NJCPAHT
 
      ** Prime A/C Holder
 
     C                   EVAL      RPAHO  = NJCPAHO
 
      ** Last Change Date
 
     C                   EVAL      ZDayNo = NJCLCDT
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
 
     C                   MOVE      ZADate        RLCDT
 
      ** Last Change Type
 
     C                   SELECT
     C                   WHEN      NJCCHTP = 'I'
     C                   EVAL      RCHTP  = 'Inserted'
     C                   WHEN      NJCCHTP = 'A'
     C                   EVAL      RCHTP  = 'Amended'
     C                   WHEN      NJCCHTP = 'D'
     C                   EVAL      RCHTP  = 'Deleted'
     C                   OTHER
     C                   EVAL      RCHTP  = *BLANKS
     C                   ENDSL
 
      ** Print Report fields
 
     C                   EXSR      SRPrint
 
     C                   IF        WLvl1 = 'Y'
     C                   EVAL      WLvl1 = 'N'
     C                   EVAL      *IN04 = *OFF
     C                   ENDIF
 
     C                   ENDIF
 
     C     JCJANO        READE     SDJACCL3                               02
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCustRec - Store report details from SDJACCL1                *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCustRec     BEGSR
 
      ** Joint Account Number
 
     C                   IF        WLvl1 = 'Y'
     C                   EVAL      RJANO = JCJANO
     C                   ENDIF
 
      ** Joint Account Report Name
 
     C                   IF        WLvl1 = 'Y'
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      JCJANO        PCustNo
     C                   PARM      *BLANKS       PKey
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCustNo
     C                   EVAL      DBFile = 'SDCUSTL1'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RJANM = BBCRNM
     C                   ENDIF
 
     C                   ENDIF
 
      ** Customer Number
 
     C                   EVAL      RREFN = JCCUST
 
      ** Customer Report Name and Report Town
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      JCCUST        PCustNo
     C                   PARM      *BLANKS       PKey
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCustNo
     C                   EVAL      DBFile = 'SDCUSTL1'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RCRNM = BBCRNM
     C                   EVAL      RCRTN = BBCRTN
     C                   ENDIF
 
      ** Investment Proportion
 
     C                   EVAL      RINVP  = JCINVP
 
      ** Prime A/C Holder for Tax Purposes
 
     C                   EVAL      RPAHT  = JCPAHT
 
      ** Prime A/C Holder
 
     C                   EVAL      RPAHO  = JCPAHO
 
      ** Last Change Date
 
     C                   EVAL      ZDayNo = JCLCDT
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
 
     C                   MOVE      ZADate        RLCDT
 
      ** Last Change Type
 
     C                   SELECT
     C                   WHEN      JCCHTP = 'I'
     C                   EVAL      RCHTP  = 'Inserted'
     C                   WHEN      JCCHTP = 'A'
     C                   EVAL      RCHTP  = 'Amended'
     C                   WHEN      JCCHTP = 'D'
     C                   EVAL      RCHTP  = 'Deleted'
     C                   OTHER
     C                   EVAL      RCHTP  = *BLANKS
     C                   ENDSL
 
      ** Set Flag to 'N' to indicate processing of similar joint a/c no.
 
     C                   EVAL      WLvl1 = 'N'
 
      ** Print Report fields
 
     C                   EXSR      SRPrint
     C                   EVAL      *IN04 = *OFF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrint  - Print Detail Report                                *
      *                                                               *
      * Called by: SRCustRec/SRNonACHol                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRPrint       BEGSR
 
     C                   IF        NOT %OPEN(SD000763P1)
     C                   OPEN      SD000763P1
 
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
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
     C**********         EVAL      RqdLn1 = 1                                               BUG24863
     C                   EVAL      RqdLn1 = 2                                               BUG24863
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** For initial print of details or overflow has occured, print the Header
      ** of the report.
 
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF
 
      ** Write details to printer fields.
 
     C                   WRITE     DETAIL
 
      ** Clear report fields.
 
     C                   EVAL      RJANO = *BLANKS
     C                   EVAL      RJANM = *BLANKS
     C                   EVAL      RREFN = *BLANKS
     C                   EVAL      RCRNM = *BLANKS
     C                   EVAL      RCRTN = *BLANKS
     C                   EVAL      RINVP = *BLANKS
     C                   EVAL      RPAHT = *BLANKS
     C                   EVAL      RPAHO = *BLANKS
     C                   EVAL      RLCDT = *BLANKS
     C                   EVAL      RCHTP = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write Trailer in Report                              *
      *                                                               *
      * Called by: Main Program                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SREnd         BEGSR
 
      ** Print detail report only if there are records to print.
 
     C                   IF        %OPEN(SD000763P1)
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
 
      ** Write out report trailer.
 
     C                   WRITE     TRAILP1
     C                   ENDIF
 
      ** Write audit report.
     C                   EXSR      SRAudit
 
      ** Close printer files.
 
     C                   IF        %OPEN(SD000763AU)
     C                   CLOSE     SD000763AU
     C                   ENDIF
 
     C                   IF        %OPEN(SD000763P1)
     C                   CLOSE     SD000763P1
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
     C                   IF        NOT %OPEN(SD000763AU)
     C                   OPEN      SD000763AU
 
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
 
     C                   ENDIF
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ENDIF
 
      ** No records printed.
 
     C                   IF        WNoRec = 0
     C                   WRITE     NODTLS
     C                   ELSE
 
      ** Print Audit Trail.
 
     C     WFileName     CHAIN     SDFCTLL0
     C                   IF        %FOUND
     C                   EVAL      RINSER = AHNOIN
     C                   EVAL      RAMEND = AHNOAM
     C                   EVAL      RDELET = AHNODL
     C                   EVAL      RAUDIT = AHNORC
     C                   EVAL      RCOUNT = WNoRec
 
      ** Print the word "Difference" if no. of records processed <> recorded on SDFCTLPA
 
     C                   IF        RAUDIT <> WNoRec
     C                   EVAL      *IN21 = *ON
     C                   ENDIF
 
     C                   WRITE     CONTROL
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
 
      ** Entry Paramters
 
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
 
      ** Bank Details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Check CGL031 feature                                                                 CSW207
     C                   Call      'AOSARDR0'                                                 CSW207
     C                   Parm      *Blanks       PRtCd                                        CSW207
     C                   Parm      '*VERIFY'     POptn                                        CSW207
     C                   Parm      'CGL031'      PSARD             6                          CSW207
     C                   Parm                    DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd <> *BLANKS AND                                       CSW207
     C                             PRtCd <> '*NRF'                                            CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFile = 'CGL031'                                          CSW207
     C                   EVAL      DBKey = POptn                                              CSW207
     C                   EVAL      DBase = 006                                                CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ELSE                                                                 CSW207
     C                   IF        PRtCd = '*NRF   '                                          CSW207
     C                   EVAL      CGL031 = 'N'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CGL031 = 'Y'                                               CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
      ** Check CGL032 feature                                                                 CSW207
     C                   Call      'AOSARDR0'                                                 CSW207
     C                   Parm      *Blanks       PRtCd                                        CSW207
     C                   Parm      '*VERIFY'     POptn                                        CSW207
     C                   Parm      'CGL032'      PSARD                                        CSW207
     C                   Parm                    DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd <> *BLANKS AND                                       CSW207
     C                             PRtCd <> '*NRF'                                            CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFile = 'CGL032'                                          CSW207
     C                   EVAL      DBKey = POptn                                              CSW207
     C                   EVAL      DBase = 007                                                CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ELSE                                                                 CSW207
     C                   IF        PRtCd = '*NRF   '                                          CSW207
     C                   EVAL      CGL032 = 'N'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CGL032 = 'Y'                                               CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
      ** Check if Private Banking Module is available                                         CSW207
     C                   Call      'AOMMODR0'                                                 CSW207
     C                   Parm      *Blanks       PRtCd                                        CSW207
     C                   Parm      '*FIRST'      POptn                                        CSW207
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CSW207
                                                                                              CSW207
     C                   IF        PRtCd <> *BLANKS                                           CSW207
     C     *LOCK         IN        LDA                                                        CSW207
     C                   EVAL      DBFile = 'SDMMODPD'                                        CSW207
     C                   EVAL      DBKey = POptn                                              CSW207
     C                   EVAL      DBase = 008                                                CSW207
     C                   OUT       LDA                                                        CSW207
     C                   EXSR      *PSSR                                                      CSW207
     C                   ENDIF                                                                CSW207
     C                   IF        BGN4ST = 'Y'                                               CSW207
     C                   EVAL      PrivBank = 'Y'                                             CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        (CGL031 = 'Y' AND                                          CSW207
     C                             CGL032 = 'Y') OR                                           CSW207
     C                             PrivBank = 'Y'                                             CSW207
     C                   EVAL      *IN35 = *ON                                                CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      *IN35 = *OFF                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
 
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
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
