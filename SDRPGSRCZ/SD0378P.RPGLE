     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('MIDAS SD Beneficial Owner Details Report')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0378P - Midas SD Beneficial Owners Detail Report           *
      *                                                               *
      *  Function:  This module will report all the Benefical Owner   *
      *             details from file SDBNFOPD.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE024   *CREATE   Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE024 - Withholding Tax - Sub account processing            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Error in reading file SDBNFOL1                  *
      *    02         End of file                                     *
      *    21         Out of balance, difference in number of records *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR        - Error processing                              *
      *  *INZSR       - Initialise                                    *
      *  SRPrint      - Print details                                 *
      *  SRFilHdr2    - Fill up Header 2 screen fields                *
      *  SRTotPct     - Write total percentage holding to report      *
      *  SRFmtAmt     - Format printer file fields amount             *
      *  SREnd        - Write trailer in report                       *
      *  SRAudit      - Write audit report                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** SD Beneficial Owner Details retrieval index
     FSDBNFOL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Control file retrieval index
     FSDFCTLL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Beneficial Owners - Detail
     FSD0378P1  O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *
      ** Beneficial Owners - Audit
     FSD0378PM  O    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
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
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** File Information Data Structure for SD0378P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
      *
      ** File Information Data Structure for SD0378PM.
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  ErrorOnFl             01     01
     D  EndOfFile             02     02
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
      *
      ** Entry Parameter
     D PRtcd           S              7
     D PMode           S              1
     D PRSeq           S              5
     D PLevl           S              1
     D PEnty           S              3
      *
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
      *
      ** Parameters for access object programs
     D POptn           S              7
     D PCust           S             10
     D PKySt           S              7
      *
      ** Parameters for ZEDIT
     D ZADec           S              1P 0
     D ZField          S             16A
      *
      ** Other fields used
     D WRun            S              1
     D WCnt            S              1
     D WFirstCust      S              1    INZ('Y')
     D WNewCust        S              1    INZ('Y')
     D WOpen           S              1    INZ('N')
     D WCnum           S              6
     D WCrnm           S             20
     D WCttx           S              2
     D WDept           S              6
     D WPrevCnum       S              6
     D WPrevCttx       S              2
     D WPrevDept       S              6
     D WTotPctAH       S              7P 4 INZ(0)
     D WFName          S             10
     D WPrtRec         S              1
     D RqdLn1          S              3  0
     D DifLn1          S              3  0
      *
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
      *
     C     *LOVAL        SETLL     SDBNFOL1
     C                   READ      SDBNFOL1                             0102
      *
      ** Database error.
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFile = 'SDBNFOL1'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      WCnt = 'N'
      *
     C                   IF        EndOfFile = True
     C                   EXSR      SRAudit
     C                   ELSE
     C                   EVAL      WCnt = 'Y'
     C                   ENDIF
      *
     C                   DOU       EndOfFile = True
      *
      ** Count records read
      *
     C                   EVAL      RCOUNT = RCOUNT + 1
      *
     C                   EVAL      WPrtRec = 'Y'
      *
     C                   IF        PMode = 'A' AND
     C                             BNLCD <> BJRDNB
     C                   EVAL      WPrtRec = 'N'
     C                   ENDIF
      *
      ** Process Report Lines.
      *
     C                   IF        WPrtRec = 'Y'
     C                   EXSR      SRPrint
     C                   ENDIF
      *
      ** Read next record.
      *
     C                   READ      SDBNFOL1                             0102
      *
      ** Database error.
      *
     C                   IF        ErrorOnFl = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*NEXT  '
     C                   EVAL      DBFile = 'SDBNFOL1'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check if next customer.
      *
     C                   IF        BNCNUM <> WPrevCnum OR
     C                             BNCTTX <> WPrevCttx OR
     C                             BNDEPT <> WPrevDept
     C                   EVAL      WNeWCust = 'Y'
     C                   ELSE
     C                   EVAL      WNewCust = 'N'
     C                   ENDIF
      *
     C                   EVAL      WPrevCnum = BNCNUM
     C                   EVAL      WPrevCttx = BNCTTX
     C                   EVAL      WPrevDept = BNDEPT
      *
      ** End of DO until.
      *
     C                   ENDDO
 
     C                   EXSR      SRTotPct
 
     C                   EXSR      SREnd
      *
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrnt - Print details                                       *
      *                                                               *
      *****************************************************************
 
     C     SRPrint       BEGSR
 
     C                   IF        WOpen <> 'Y'
      *
     C                   EVAL      WOpen = 'Y'
     C                   OPEN      SD0378P1
     C                   EVAL      WPrevCnum = BNCNUM
     C                   EVAL      WPrevCttx = BNCTTX
     C                   EVAL      WPrevDept = BNDEPT
      *
      ** Ensure Detail Spool File recorded by RCF.
      *
     C                   EVAL      ZSnum = SFNUM1
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** If new customer number,
      *
     C                   IF        WNewCust = 'Y'
      *
     C                   IF        WFirstCust <> 'Y'
     C                   EXSR      SRTotPct
     C                   ENDIF
      *
     C                   WRITE     HEADER1
     C                   EVAL      WFirstCust = 'N'
      *
      ** Reset total percentage allocation holding
      *
     C                   Z-ADD     BNPAHD        WTotPctAH
      *
      ** Fill up Header2 screen fields.
      *
     C                   EXSR      SRFilHdr2
     C                   WRITE     HEADER2
      *
     C                   ELSE
      *
     C                   EVAL      RqdLn1 = 24
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
      *
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADER1
     C                   EXSR      SRFilHdr2
     C                   WRITE     HEADER2
     C                   ENDIF
      *
      ** Add the record's pctage holding to the customer's total holding.
      *
     C                   ADD       BNPAHD        WTotPctAH
      *
     C                   ENDIF
      *
      ** Write Detail.
      *
     C                   EVAL      RBONO = BNBONO
     C                   EVAL      RBONM = BNBONM
     C                   EVAL      RBOA1 = BNBOA1
     C                   EVAL      RBOA2 = BNBOA2
     C                   EVAL      RBOA3 = BNBOA3
     C                   EVAL      RDCRC = BNDCRC
     C                   EVAL      RBCWA = BNBCWA
     C                   EVAL      REXCD = BNEXCD
     C                   EVAL      RCTRS = BNCTRS
     C                   EVAL      RCSTN = BNTXID
     C                   EVAL      RTXBS = BNTXBS
     C                   EVAL      RRPCD = BNRPCD
     C                   EVAL      RDFRD = BNDFRD
      *
     C                   EVAL      ZField = *Blanks
     C                   MOVE      BNPAHD        ZField
     C                   EVAL      ZADec = 4
     C                   EXSR      SRFmtAmt
     C                   MOVE      ZField        RPAHD
      *
     C                   WRITE     DETAIL1
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFIlHdr2 - Fill up HEADER 2 screen fields                   *
      *                                                               *
      *****************************************************************
 
     C     SRFilHdr2     BEGSR
      *
      ** Retrieve new data if first record on file or next customer.
      *
     C                   IF        WNewCust = 'Y'
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BNCNUM        PCust
     C                   PARM                    PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Database error.
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCust
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      RCNUM = BNCNUM
     C                   EVAL      RCRNM = BBCRNM
     C                   EVAL      RCTTX = BNCTTX
     C                   EVAL      RDEPT = BNDEPT
      *
     C                   EVAL      WCnum = RCNUM
     C                   EVAL      WCrnm = RCRNM
     C                   EVAL      WCttx = RCTTX
     C                   EVAL      WDept = RDEPT
      *
     C                   ELSE
      *
      ** Use the previous data.
      *
     C                   EVAL      RCNUM = WCnum
     C                   EVAL      RCRNM = WCrnm
     C                   EVAL      RCTTX = WCttx
     C                   EVAL      RDEPT = WDept
      *
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTotPct - Write total percentage to report                  *
      *                                                               *
      *****************************************************************
 
     C     SRTotPct      BEGSR
      *
      ** For total percentage allocation holding, then write to report
      *
     C                   EVAL      ZField = *Blanks
     C                   MOVE      WTotPctAH     ZField
     C                   EVAL      ZADec = 4
     C                   EXSR      SRFmtAmt
      *
     C                   MOVE      ZField        RTPAH
     C                   WRITE     TRAIL1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmt - Format printer file fields amount                 *
      *                                                               *
      *****************************************************************
 
     C     SRFmtAmt      BEGSR
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZField
     C                   PARM                    ZADec
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Write trailer in report                              *
      *                                                               *
      *****************************************************************
 
     C     SREnd         BEGSR
      *
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADER1
     C                   ENDIF
      *
      ** Write out report trailer.
      *
     C                   WRITE     TRAIL2
      *
      ** Check control details.
      *
     C                   EVAL      WFName = 'SDBNFOPD'
     C     WFName        CHAIN     SDFCTLL1                           02
      *
      ** Database error.
      *
     C                   IF        EndofFile = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = WFName
     C                   EVAL      DBFile = 'SDFCTLPA'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      RINSER = AHNOIN
     C                   EVAL      RAMEND = AHNOAM
     C                   EVAL      RDELET = AHNODL
     C                   EVAL      RAUDIT = AHNORC
      *
     C                   IF        RCOUNT <> RAUDIT
     C                   EVAL      *IN21 = *On
     C                   ELSE
     C                   EVAL      *IN21 = *Off
     C                   ENDIF
      *
      ** Write audit report.
      *
     C                   EXSR      SRAudit
     C                   EVAL      *INLR = '1'
     C                   RETURN
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
      *
     C                   OPEN      SD0378PM
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   EVAL      ZSnumU = SFNUMU
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   WRITE     HEADAU
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
     C                   WRITE     CONTROL
      *
      ** Or, if no records read, Output "No Details" message.
      *
     C                   IF        WCnt ='N'
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      *INLR ='1'
     C                   RETURN
 
     C                   ENDSR
      *
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
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRtcd
     C                   PARM                    PMode
     C                   PARM                    PRSeq
     C                   PARM                    PLevl
     C                   PARM                    PEnty
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Report Work fields.
      *
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
 
     C                   ENDSR
      *
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
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
