     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Country of Tax Code List')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000780P -  Midas SD Countries of Tax Codes List            *
      *                                                               *
      *  Function:  This module reports the Countries of Tax Codes    *
      *             List.                                             *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23146           Date 25Mar09               *
      *                 BUG23587           Date 26Mar09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236137             Date 20Sep05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax                        *
      *  BUG23146 - SD000780 Confusing to read                        *
      *  BUG23587 - Saving Account Threshold no more required         *
      *  CER048 - German Features - Taxes                             *
      *  236137 - Change Control for CGL031 Parts 4 & 5.              *
      *           Several changes in the Taxation of Savings Income   *
      *           functionality.                                      *
      *           to report SDCTTXPD 6 new fields.                    *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         End of file for SDCTTXL1                        *
      *    03         Record not found in SDFCTLL1                    *
      *    20         Audit mode, use for header                      *
      *    21         Out of balance, difference in number of records *
      *    22         Space between different Country of Tax Info     *
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
 
      ** SD Country of Tax Codes details - Retrieve
     FSDCTTXL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Control file retrieval index
     FSDFCTLL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Country of Tax Codes Printer file - Details
     FSD000780P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      ** Country of Tax Codes Printer file - Audit
     FSD000780AUO    E             PRINTER INFDS(SPOOLU)
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
      *                                                                                     BUG23146
      ** External data structure for Country Details                                        BUG23146
      *                                                                                     BUG23146
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)                                BUG23146
 
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                                       CER048
      ** Switchable Feature Details Data Structure                                            CER048
      *                                                                                       CER048
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER048
 
      ** File Information Data Structure for SD000780P1.
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for SD000780AU
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
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
                                                                                              236137
      ** Parameters for ZEDIT                                                                 236137
                                                                                              236137
     D ZFIELD          S             16                                                       236137
     D ZADEC           S              1  0                                                    236137
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameters for access object programs
     D PRtcd           S              7
     D POptn           S              7
     D PSARd           S              6
 
      ** Parameter list fields
     D PMode           S              1
     D PLevl           S              1
     D PEnty           S              3
 
      ** Other fields used
     D WRun            S              1
     D WOpen           S              1    INZ('N')
     D WFirst          S              1    INZ('Y')
     D WFName          S             10
     D WNoRec          S              5  0 INZ(0)
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D WCtrt           S              2
     D PCNCD           S              2                                                     BUG23146
      *                                                                                       CER048
      ** Declare variable to check Switchable feature                                         CER048
      *                                                                                       CER048
     D CER048          S              1                                                       CER048
     D CER054          S              1                                                       CER054
 
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
 
     C     *LOVAL        SETLL     SDCTTXL1
     C                   READ      SDCTTXL1                               02
 
      ** Write to Audit File if file is empty.
 
     C                   IF        EndOfFile = True
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   DOU       EndOfFile = True
 
      ** Count no. of records processed.
 
     C                   EVAL      WNoRec = WNoRec + 1
 
      ** Process Report Lines.
 
     C                   EXSR      SRPrint
 
      ** Read next record.
 
     C                   READ      SDCTTXL1                               02
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
     C                   OPEN      SD000780P1
 
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
 
     C**********         EVAL      RqdLn1 = 1                                                 236137
     C**********         EVAL      RqdLn1 = 2                                          236137 CER048
     C**********         EVAL      RqdLn1 = 3                                        CER048 BUG23146
     C**********         EVAL      RqdLn1 = 20                                       BUG23146 CER054
     C                   EVAL      RqdLn1 = 21                                                CER054
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** For initial print of details or overflow has occured, print the Header
      ** of the report.
 
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF
 
      ** Write details to printer fields.
 
     C                   EVAL      *IN22 = *OFF
 
      ***Print*Country of Tax value only at the beginning of a new Country of Tax           BUG23146
      ***group*or at the beginnig of a new page.                                            BUG23146
 
     C**********         IF        EWCTRT <> WCtrt OR                                       BUG23146
     C**********                   DifLn1 <= RqdLn1                                         BUG23146
     C                   EVAL      RCTRT = EWCTRT
     C**********         EVAL      WCtrt = EWCTRT                                           BUG23146
     C**********         EVAL      *IN22 = *ON                                              BUG23146
     C**********         ELSE                                                               BUG23146
     C**********         EVAL      RCTRT = *Blanks                                          BUG23146
     C**********         ENDIF                                                              BUG23146
 
      *                                                                                     BUG23146
      ** Get Country Name for Country Tax                                                   BUG23146
      *                                                                                     BUG23146
     C                   CALL      'AOCTRYR0'                                               BUG23146
     C                   PARM      *BLANKS       PRTCD                                      BUG23146
     C                   PARM      '*KEY   '     POPTN                                      BUG23146
     C                   PARM      EWCTRT        PCNCD                                      BUG23146
     C     SDCTRY        PARM      SDCTRY        DSFDY                                      BUG23146
                                                                                            BUG23146
     C                   EVAL      RCTNM = A4CNNM                                           BUG23146
                                                                                            BUG23146
      ** Country of Residence
 
     C                   EVAL      RCTRR = EWCTRR
 
      *                                                                                     BUG23146
      ** Get Country Name for Country of Residence                                          BUG23146
      *                                                                                     BUG23146
     C                   IF        EWCTRR <> *BLANKS                                        BUG23146
     C                   CALL      'AOCTRYR0'                                               BUG23146
     C                   PARM      *BLANKS       PRTCD                                      BUG23146
     C                   PARM      '*KEY   '     POPTN                                      BUG23146
     C                   PARM      EWCTRR        PCNCD                                      BUG23146
     C     SDCTRY        PARM      SDCTRY        DSFDY                                      BUG23146
                                                                                            BUG23146
     C                   EVAL      RCTRN = A4CNNM                                           BUG23146
     C                   ENDIF                                                              BUG23146
                                                                                            BUG23146
      ** Default Tax Status 1
 
     C                   EVAL      RTXS1 = EWTXS1
 
      ** Effective Date 1
 
     C                   EVAL      ZDayNo = EWEDT1
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
 
     C                   MOVE      ZADate        REDT1
 
      ** Transition Type 1
 
     C                   EVAL      RTRT1 = EWTRT1
 
      ** Default Tax Status 2
 
     C                   EVAL      RTXS2 = EWTXS2
 
      ** Effective Date 2
 
     C                   EVAL      ZDayNo = EWEDT2
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
 
     C                   MOVE      ZADate        REDT2
 
      ** Transition Type 2
 
     C                   EVAL      RTRT2 = EWTRT2
 
      ** Tax Basket
 
     C                   EVAL      RTXBS = EWTXBS
 
      ** Withholding Tax Account Code
 
     C                   EVAL      RWTAC = EWWTAC
 
      ** Last Change Type
 
     C                   EVAL      RCHTP = *BLANKS
 
     C                   IF        EWCHTP = 'I'
     C                   EVAL      RCHTP = 'INSERT'
     C                   ELSE
     C                   EVAL      RCHTP = 'AMEND'
     C                   ENDIF
 
      ** Last Change Date
 
     C                   EVAL      ZDayNo = EWLCDT
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDate
     C                   PARM      *BLanks       ZADate
 
     C                   MOVE      ZADate        RLCDT
                                                                                              236137
      ** De Minimis Rule Applicable indicator.                                                236137
                                                                                              236137
     C                   EVAL      RDMAP = EWDMAP                                             236137
                                                                                              236137
      ** Total Discount Percentage.                                                           236137
                                                                                              236137
     C                   MOVE      *BLANKS       ZFIELD                                       236137
     C                   IF        EWDMAP = 'Y'                                               236137
     C                   MOVE      EWTTDP        ZFIELD                                       236137
     C                   CALLB     'ZEDIT'                                                    236137
     C                   PARM                    ZFIELD                                       236137
     C                   PARM      3             ZADEC                                        236137
                                                                                              236137
     C                   ENDIF                                                                236137
     C                   MOVE      ZFIELD        RTTDP                                        236137
                                                                                              236137
      ** Yearly Discount Percentage.                                                          236137
                                                                                              236137
     C                   MOVE      *BLANKS       ZFIELD                                       236137
     C                   IF        EWDMAP = 'Y'                                               236137
     C                   MOVE      EWYRDP        ZFIELD                                       236137
     C                   CALLB     'ZEDIT'                                                    236137
     C                   PARM                    ZFIELD                                       236137
     C                   PARM      3             ZADEC                                        236137
                                                                                              236137
     C                   ENDIF                                                                236137
     C                   MOVE      ZFIELD        RYRDP                                        236137
                                                                                              236137
      ** Tax Calculation Basis indicator.                                                     236137
                                                                                              236137
     C                   EVAL      RTXCB = EWTXCB                                             236137
                                                                                              236137
      ** Premium Amortized to be Deducted indicator.                                          236137
                                                                                              236137
     C                   EVAL      RPADD = EWPADD                                             236137
                                                                                              236137
      ** Delta of TIS Taxable Only indicator.                                                 236137
                                                                                              236137
     C                   EVAL      RTIST = EWTIST                                             236137
      *                                                                                       CER048
      ** Checking switchable feature CER048                                                   CER048
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C                   EVAL      RSTXB = EWSTXB                                             CER048
     C                   EVAL      RSTAC = EWSTAC                                             CER048
     C                   EVAL      ZDayNo = EWSEDT                                            CER048
      *                                                                                       CER048
     C                   CALLB     'ZDATE2'                                                   CER048
     C                   PARM                    ZDayNo                                       CER048
     C                   PARM                    BJDFIN                                       CER048
     C                   PARM      *ZEROS        ZDate                                        CER048
     C                   PARM      *BLANKS       ZADate                                       CER048
      *                                                                                       CER048
     C                   EVAL      RSEDT = ZADate                                             CER048
     C                   MOVE      *BLANKS       ZFIELD                                       CER048
     C                   MOVE      EWRARL        ZFIELD                                       CER048
      *                                                                                       CER048
     C                   CALLB     'ZEDIT'                                                    CER048
     C                   PARM                    ZFIELD                                       CER048
     C                   PARM      5             ZADEC                                        CER048
      *                                                                                       CER048
     C                   MOVE      ZFIELD        RRARL                                        CER048
      *                                                                                       CER048
     C                   EVAL      ZDayNo = EWRAED                                            CER048
      *                                                                                       CER048
     C                   CALLB     'ZDATE2'                                                   CER048
     C                   PARM                    ZDayNo                                       CER048
     C                   PARM                    BJDFIN                                       CER048
     C                   PARM      *ZEROS        ZDate                                        CER048
     C                   PARM      *BLANKS       ZADate                                       CER048
      *                                                                                       CER048
     C                   EVAL      RRAED = ZADate                                             CER048
     C                   MOVE      *BLANKS       ZFIELD                                       CER048
     C                   MOVE      EWRARL        ZFIELD                                       CER048
      *                                                                                       CER048
     C                   CALLB     'ZEDIT'                                                    CER048
     C                   PARM                    ZFIELD                                       CER048
     C                   PARM      5             ZADEC                                        CER048
      *                                                                                       CER048
     C                   MOVE      ZFIELD        RPARL                                        CER048
     C                   MOVEL     EWINTH        RINTH                                        CER048
     C                   MOVEL     EWJTTH        RJTTH                                        CER048
     C                   MOVEL     EWECTH        RECTH                                        CER048
      *                                                                                       CER048
     C                   MOVE      *BLANKS       ZFIELD                                       CER048
     C**********         MOVE      EWSATH        ZFIELD                              CER048 BUG23587
      **********                                                                     CER048 BUG23587
     C**********         CALLB     'ZEDIT'                                           CER048 BUG23587
     C**********         PARM                    ZFIELD                              CER048 BUG23587
     C**********         PARM      2             ZADEC                               CER048 BUG23587
      **********                                                                     CER048 BUG23587
     C**********         MOVE      ZFIELD        RSATH                               CER048 BUG23587
     C                   EVAL      RMPCR = EWMPCR                                             CER048
     C                   EVAL      RTHMD = EWTHMD                                             CER048
      *                                                                                       CER048
     C                   IF        CER054 = 'Y'                                               CER054
     C                   EVAL      RTTAM = EWTTAM                                             CER054
     C                   EVAL      RTTAC = EWTTAC                                             CER054
     C                   EVAL      ZDayNo = EWTEDT                                            CER054
     C                   CALLB     'ZDATE2'                                                   CER054
     C                   PARM                    ZDayNo                                       CER054
     C                   PARM                    BJDFIN                                       CER054
     C                   PARM      *ZEROS        ZDate                                        CER054
     C                   PARM      *BLANKS       ZADate                                       CER054
     C                   EVAL      RTEDT = ZADate                                             CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER048
 
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
 
     C**********         EVAL      RqdLn1 = 4                                               BUG23146
     C**********         EVAL      DifLn1 = OFLLN1 - PRTLN1                                 BUG23146
     C**********         IF        DifLn1 <= RqdLn1                                         BUG23146
     C**********         WRITE     HEADP1                                                   BUG23146
     C**********         ENDIF                                                              BUG23146
 
      ** Write out report trailer.
 
     C                   WRITE     TRAILP1
 
      ** Retrieve control details.
 
     C                   EVAL      WFName = 'SDCTTXPD'
     C     WFName        CHAIN     SDFCTLL1                           03
 
      ** Database error.
 
     C                   IF        RecNotFnd = True
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = WFName
     C                   EVAL      DBFile = 'SDFCTLPA'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RINSER = AHNOIN
     C                   EVAL      RAMEND = AHNOAM
     C                   EVAL      RDELET = AHNODL
     C                   EVAL      RAUDIT = AHNORC
     C                   EVAL      RCOUNT = WNoRec
 
     C                   IF        RCOUNT <> RAUDIT
     C                   EVAL      *IN21 = *On
     C                   ELSE
     C                   EVAL      *IN21 = *Off
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
 
     C                   OPEN      SD000780AU
 
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
 
     C                   EVAL      *INLR ='1'
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
      *                                                                                       CER048
      ** Call AOSARDR0 to check for CER048                                                    CER048
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   EVAL      *IN16 = *ON                                                CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   EVAL      *IN16 = *OFF                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Database error.                                                                      CER048
      *                                                                                       CER048
     C                   IF        PRtcd <> *BLANKS AND                                       CER048
     C                             PRtcd <> '*NRF   '                                         CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBKey = POptn                                              CER048
     C                   EVAL      DBFile = 'SCSARDPD'                                        CER048
     C                   EVAL      DBase = 005                                                CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Call AOSARDR0 to check for CER054                                                    CER054
      *                                                                                       CER054
     C                   CALL      'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRtcd                                        CER054
     C                   PARM      '*VERIFY'     POptn                                        CER054
     C                   PARM      'CER054'      PSard                                        CER054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'N'                                               CER054
     C                   EVAL      *IN17 = *OFF                                               CER054
      *                                                                                       CER054
     C                   IF        PRtcd = *BLANKS                                            CER054
     C                   EVAL      CER054 = 'Y'                                               CER054
     C                   EVAL      *IN17 = *ON                                                CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
      ** Database error.                                                                      CER054
      *                                                                                       CER054
     C                   IF        PRtcd <> *BLANKS AND                                       CER054
     C                             PRtcd <> '*NRF   '                                         CER054
     C     *LOCK         IN        LDA                                                        CER054
     C                   EVAL      DBKey = POptn                                              CER054
     C                   EVAL      DBFile = 'SCSARDPD'                                        CER054
     C                   EVAL      DBase = 006                                                CER054
     C                   OUT       LDA                                                        CER054
     C                   EXSR      *PSSR                                                      CER054
     C                   ENDIF                                                                CER054
 
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
(c) Finastra International Limited 2004
