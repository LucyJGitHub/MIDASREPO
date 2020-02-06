     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CRS Due Diligence Action Extract')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000719 - Midas SD CRS Due Diligence Action Extract         *
      *                                                               *
      *  Function:  This is a new program to extract the data to      *
      *             create the driving files to be used in Due        *
      *             Diligence Action Report for both Customer and     *
      *             Non-Account Holder                                *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CGL177   *CREATE   Date 11Jan16               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRLoadDrv   - Load data to driver file                       *
      *  SRChkTypAc  - Check Type of account if N=New or E=Existing   *
      *  SRValCond   - Validation process                             *
      *  SRWriteDrv  - Write a record into the driving file           *
      *  SRAlgAmount - Align amount                                   *
      *  SrZDATE1    - Validate and convert date to a day number      *
      *  SrZDAT10    - Convert YYYYMMDD Date to Midas Day             *
      *  *PSSR       - Error processing                               *
      *  *INZSR      - Initialise                                     *
      *                                                               *
      *    The *INZSR Subroutine Will Only Get Called Automatically   *
      *    On Entry To The Module The First Time It Is Run            *
      *    (Unless You End The Program With LR On).  Similarly        *
      *    D-spec Initialisation Only Happens The First Time.  Use    *
      *    RESET For Subsequent Passes.                               *
      *                                                               *
      *****************************************************************
      *---------------------------------------------------------------*
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      *
      ** CRS Customer Details File - Keyed by Customer
     FSDCRSHL3  IF   E           K DISK
      *
      ** Non-Account Holders File - Keyed by Customer
     FSDCRNHL3  IF   E           K DISK
      *
      ** Customer Extension
     FSDCUSXL0  IF   E           K DISK
      *
      ** Midas SD Due Diligence CRS Action Driving File
     FSDDDCRPD  O    E             DISK
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically Included D-Specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The Following /COPY Line Includes The LDA Layout,
      ** And The Following Named Constants:
      **    True       Logical = *ON (For Indcator Processing)
      **    False      Logical = *OFF (For Indcator Processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (The Name Of The Database
      **                         Error Handler)
      ** And The Following Variables:
      **    RunBefore  1A (For The PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The Following /COPY Line Includes All The Defined Fields In
      ** the PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End Of Automatically Included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** External DS for Bank Details ICD retrieval
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS Based On SDCUSTPD
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External DS Based On SDNAHOPD
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
      *
      ** External DS Based On SDDDCRPD
     D SDDDAC        E DS                  EXTNAME(SDDDCRPD)
      *
      ** Data structure for AOSVALR0 string
     D PVal01          DS           200
     D  WDilMedInd             1      6
     D PVal02          DS           200
     D  WDilHiInd              1      6
     D PVal03          DS           200
     D  WDilMedEnt             1      6
     D PVal04          DS           200
     D  WDilHiEnt              1      6
     D PVal05          DS           200
     D PVal06          DS           200
     D  WEffStrDate            1      6
     D PVal07          DS           200
     D PVal08          DS           200
     D PVal09          DS           200
     D PVal10          DS           200
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Recursive       S              1    INZ('N')
      ** AOCUSTR0 Parameters
     D PKeyST          S              7
     D POptn           S              7
     D Prtcd           S              7
      ** AOBANKR0 Parameters
     D PRetCode        S              7    INZ(*Blanks)
     D POption         S              7    INZ(*Blanks)
      ** AOSVALR0 Parameters
     D SVal01          S             20    INZ(*Blanks)
     D SVal02          S             20    INZ(*Blanks)
     D SVal03          S             20    INZ(*Blanks)
     D SVal04          S             20    INZ(*Blanks)
     D SVal05          S             20    INZ(*Blanks)
     D SVal06          S             20    INZ(*Blanks)
     D SVal07          S             20    INZ(*Blanks)
     D SVal08          S             20    INZ(*Blanks)
     D SVal09          S             20    INZ(*Blanks)
     D SVal10          S             20    INZ(*Blanks)
      ** Temporary Variables
     D WDMIDayNo       S              5  0
     D WDHIDayNo       S              5  0
     D WDMEDayNo       S              5  0
     D WDHEDayNo       S              5  0
     D LowVal1         S              5  0
     D LowVal2         S              5  0
     D LowestVal       S              5  0
     D WEffectiveDate  S              5  0
     D WNewAc          S              5  0
     D WNoticeDays     S              5  0
     D WFDCSNH         S             10
     D WFDCRNM         S             20
     D WFDHVAL         S              1
     D WFDCRDT         S              5  0
     D WFDSYDT         S              5  0
     D WFDFILE         S              4
     D WFDTYPE         S              1
     D WFDATYP         S              1
     D WCONTYP         S              1
      ** Parameters for ZDATE10
     D PDateIn         S              8
     D PMDNO           S              5  0
      ** Parameters for ZDATE1
     D PDate           S              6
     D PDayNo          S              5  0
     D PError          S              7
      ** Parameters for ZALIGN
     D ZAlignOK        S              1
     D ZField          S             16
     D ZADec           S              1P 0
     D ZADig           S              2P 0
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** System value CRS Diligence Existing A/C - Individual/Medium
     DWSysVal1         C                   'CRSDiligenceMedInd'
      *
      ** System value CRS Diligence Existing A/C - Individual/High
     DWSysVal2         C                   'CRSDiligenceHiInd'
      *
      ** System value CRS Diligence Existing A/C - Entity/Medium
     DWSysVal3         C                   'CRSDiligenceMedEnt'
      *
      ** System value CRS Diligence Existing A/C - Entity/High
     DWSysVal4         C                   'CRSDiligenceHiEnt'
      *
      ** System value CRS Diligence New A/C
     DWSysVal5         C                   'CRSDiligenceNewA/C'
      *
      ** System value CRS Effective Date
     DWSysVal6         C                   'CRSEffectStartDate'
      *
      ** System value Notice Days for Actions Report for CRS
     DWSysVal7         C                   'CRSNotDaysActRept'
      *
      ** +--------------------------------------+
      ** ¦ End Of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      **+--- Start of Main Processing --------------------------------+
      **|                                                             ¦
      **¦ Initial Processing Is Performed Automatically: The *INZSR   ¦
      **¦ Is Executed At Program Activation.                          ¦
      **¦                                                             ¦
      **+-------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN - Processing                                             *
      *****************************************************************
      *
      ** Customers/Non-Account Holders Driver File Load Loop
     C                   EXSR      SRLoadDrv

      ** End Program
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoadDrv - Loop through the CRS Customers and Non-Account    *
      *             Holders to load into the driving file             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: *PSSR, SRChkTypAc, SRChkSyDt, SRValCond,               *
      *        SrZDAT10                                               *
      *                                                               *
      *****************************************************************
     C     SRLoadDrv     BEGSR

      **  CRS Customer
     C     *LOVAL        SETLL     SDCRSHL3
     C                   READ      SDCRSHL3
      *
     C                   DOW       NOT %EOF(SDCRSHL3)
      ** Clear driver file
     C                   CLEAR                   SDDDAC
     C                   EVAL      WFDCSNH = CRCUST
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WFDCSNH
     C                   PARM      *BLANKS       PKeyST
     C     SDCUST        PARM      SDCUST        DSSDY

      ** Database error processing
     C                   IF        Prtcd <> *BLANKS
     C                             AND Prtcd <> '*CUSDEL'
     C                             AND Prtcd <> '*CUSCLS'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBKEY = WFDCSNH
     C                   EVAL      DBASE = 003
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF
     C                   IF        Prtcd = '*CUSDEL'
     C                             OR Prtcd = '*CUSCLS'
     C                   READ      SDCRSHD0
     C                   ITER
     C                   ELSE
     C     BBCUST        CHAIN     SDCUSTX0

      ** Database error processing
     C                   IF        NOT %FOUND(SDCUSXL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTXC'
     C                   EVAL      DBKEY  = BBCUST
     C                   EVAL      DBASE  = 004
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ELSE

      ** Move fields to work variables before write to driver file
     C                   EVAL      WFDFILE = 'CUST'
     C                   EVAL      WFDHVAL = CRHVAL
     C                   EVAL      WFDTYPE = CRTYPE
     C                   EVAL      WFDCRNM = BBCRNM
     C                   EVAL      WFDCRDT = XCCRDT
      ** Check Type of Account
     C                   EXSR      SRChkTypAc
      ** Validation Processing before writing to driver file
     C                   EVAL      WCONTYP = *BLANKS
     C                   EVAL      WCONTYP = 'C'
     C                   EXSR      SRValCond
     C                   ENDIF
     C                   ENDIF
     C                   READ      SDCRSHD0
     C                   ENDDO

      **  CRS Non-Account Holder
     C     *LOVAL        SETLL     SDCRNHL3
     C                   READ      SDCRNHL3

     C                   DOW       NOT %EOF(SDCRNHL3)
      ** Clear driver file
     C                   CLEAR                   SDDDAC
     C                   EVAL      WFDCSNH = NRNAHO
      *
     C                   CALLB     'AONAHOR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WFDCSNH
     C     SDNAHO        PARM      SDNAHO        DSSDY

      ** Database error processing
     C                   IF        Prtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   EVAL      DBKEY = WFDCSNH
     C                   EVAL      DBASE = 005
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ELSE
      ** Move fields to work variables before write to driver file
     C                   EVAL      WFDFILE = 'NAHO'
     C                   EVAL      WFDHVAL = NRHVAL
     C                   EVAL      WFDTYPE = NRTYPE
     C                   EVAL      WFDCRNM = NHNARN
      ** Convert Non-account Holder Creation Date to Midas Date
     C                   EVAL      PDateIn = NHCRDT
     C                   EXSR      SrZDAT10
     C                   EVAL      WFDCRDT = PMDNO
      ** Check Type of Account
     C                   EXSR      SRChkTypAc
      ** Validation Processing before writing to driver file
     C                   EVAL      WCONTYP = *BLANKS
     C                   EVAL      WCONTYP = 'N'
     C                   EXSR      SRValCond
     C                   ENDIF
      *
     C                   READ      SDCRNHD0
     C                   ENDDO
      *
     C                   FEOD      SDDDCRPD

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValCond - Validation process                                *
      *           - Check Due Diligence Date based on Type of Account *
      *                                                               *
      * Called by: SRLoadDrv                                          *
      *                                                               *
      * Calls: SRWriteDrv                                             *
      *                                                               *
      *****************************************************************
     C     SRValCond     BEGSR

      ** For Existing Customer/Non-account Holder
     C                   IF        WFDATYP = 'E'

     C                   EXSR      SrCRSDlgDte

      ** For Existing Customer/Non-account Holder
     C                   IF        WCONTYP = 'C'

     C                   SELECT
      ** Existing A/C - Individual/Blank or Individual/N
     C                   WHEN      CRTYPE = 'P' AND CRHVAL = ' '
     C                             OR CRTYPE = 'P' AND CRHVAL = 'N'
      *
     C                   EVAL      WFDSYDT = LowestVal
      *
     C                   IF        (LowestVal - WNoticeDays) <= BJRDNB
     C                   EXSR      SRWriteDrv
     C                   ENDIF

      ** Existing A/C - Entity/Blank or Entity/N
     C                   WHEN      CRTYPE <> 'P' AND CRHVAL = ' '
     C                             OR CRTYPE <> 'P' AND CRHVAL = 'N'
      *
     C                   EVAL      WFDSYDT = LowestVal
      *
     C                   IF        (LowestVal - WNoticeDays) <= BJRDNB
     C                   EXSR      SRWriteDrv
     C                   ENDIF

      ** Existing A/C - Individual/Medium or Individual/Low
     C                   WHEN      CRTYPE = 'P' AND CRHVAL = 'M'
     C                             OR CRTYPE = 'P' AND CRHVAL = 'L'
      *
     C                   EVAL      WFDSYDT = WDMIDayNo
      *
     C                   IF        (WDMIDayNo - WNoticeDays) <= BJRDNB
     C                   EXSR      SRWriteDrv
     C                   ENDIF

      ** Existing A/C - Individual/High
     C                   WHEN      CRTYPE = 'P' AND CRHVAL = 'H'
      *
     C                   EVAL      WFDSYDT = WDHIDayNo
      *
     C                   IF        (WDHIDayNo - WNoticeDays) <= BJRDNB
     C                   EXSR      SRWriteDrv
     C                   ENDIF

      ** Existing A/C - Entity/Medium or Entity/Low
     C                   WHEN      CRTYPE <> 'P' AND CRHVAL = 'M'
     C                             OR CRTYPE <> 'P' AND CRHVAL = 'L'
      *
     C                   EVAL      WFDSYDT = WDMEDayNo
      *
     C                   IF        (WDMEDayNo - WNoticeDays) <= BJRDNB
     C                   EXSR      SRWriteDrv
     C                   ENDIF

      ** Existing A/C - Entity/High
     C                   WHEN      CRTYPE <> 'P' AND CRHVAL = 'H'
      *
     C                   EVAL      WFDSYDT = WDHEDayNo
      *
     C                   IF        (WDHEDayNo - WNoticeDays) <= BJRDNB
     C                   EXSR      SRWriteDrv
     C                   ENDIF

     C                   ENDSL

     C                   ENDIF

      ** For Existing Non-account Holder
     C                   IF        WCONTYP = 'N'

     C                   SELECT
      ** Existing A/C - Individual/Blank or Individual/N
     C                   WHEN      NRTYPE = 'P' AND NRHVAL = ' '
     C                             OR NRTYPE = 'P' AND NRHVAL = 'N'
      *
     C                   EVAL      WFDSYDT = LowestVal
      *
     C                   IF        (LowestVal - WNoticeDays) <= BJRDNB
     C                   EXSR      SRWriteDrv
     C                   ENDIF

      ** Existing A/C - Entity/Blank or Entity/N
     C                   WHEN      NRTYPE <> 'P' AND NRHVAL = ' '
     C                             OR NRTYPE <> 'P' AND NRHVAL = 'N'
      *
     C                   EVAL      WFDSYDT = LowestVal
      *
     C                   IF        (LowestVal - WNoticeDays) <= BJRDNB
     C                   EXSR      SRWriteDrv
     C                   ENDIF

      ** Existing A/C - Individual/Medium or Individual/Low
     C                   WHEN      NRTYPE = 'P' AND NRHVAL = 'M'
     C                             OR NRTYPE = 'P' AND NRHVAL = 'L'
      *
     C                   EVAL      WFDSYDT = WDMIDayNo
      *
     C                   IF        (WDMIDayNo - WNoticeDays) <= BJRDNB
     C                   EXSR      SRWriteDrv
     C                   ENDIF

      ** Existing A/C - Individual/High
     C                   WHEN      NRTYPE = 'P' AND NRHVAL = 'H'
      *
     C                   EVAL      WFDSYDT = WDHIDayNo
      *
     C                   IF        (WDHIDayNo - WNoticeDays) <= BJRDNB
     C                   EXSR      SRWriteDrv
     C                   ENDIF

      ** Existing A/C - Entity/Medium or Entity/Low
     C                   WHEN      NRTYPE <> 'P' AND NRHVAL = 'M'
     C                             OR NRTYPE <> 'P' AND NRHVAL = 'L'
      *
     C                   EVAL      WFDSYDT = WDMEDayNo
      *
     C                   IF        (WDMEDayNo - WNoticeDays) <= BJRDNB
     C                   EXSR      SRWriteDrv
     C                   ENDIF

      ** Existing A/C - Entity/High
     C                   WHEN      NRTYPE <> 'P' AND NRHVAL = 'H'
      *
     C                   EVAL      WFDSYDT = WDHEDayNo
      *
     C                   IF        (WDHEDayNo - WNoticeDays) <= BJRDNB
     C                   EXSR      SRWriteDrv
     C                   ENDIF

     C                   ENDSL

     C                   ENDIF

     C                   ENDIF

      ** For New Customer/Non-account Holder
     C                   IF        WFDATYP = 'N'
      *
     C                   EVAL      WFDSYDT = WFDCRDT + WNewAc
      *
     C                   IF        (WFDCRDT + WNewAc - WNoticeDays) <= BJRDNB
     C                   EXSR      SRWriteDrv
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCRSDlgDte - CRS Due Diligence date comparison for CRS High *
      *                Value 'Blank' or 'N', check against earliest   *
      *                defined Due Diligence date                     *
      *                                                               *
      *****************************************************************
     C     SrCRSDlgDte   BEGSR

      ** CRS Due Diligence earliest date comparison
     C                   IF        WDMIDayNo > WDHIDayNo
     C                   EVAL      LowVal1 = WDHIDayNo
     C                   ELSE
     C                   EVAL      LowVal1 = WDMIDayNo
     C                   ENDIF

     C                   IF        WDMEDayNo > WDHEDayNo
     C                   EVAL      LowVal2 = WDHEDayNo
     C                   ELSE
     C                   EVAL      LowVal2 = WDMEDayNo
     C                   ENDIF

      ** CRS Due Diligence earliest date
     C                   IF        LowVal1 > LowVal2
     C                   EVAL      LowestVal = LowVal2
     C                   ELSE
     C                   EVAL      LowestVal = LowVal1
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkTypAc - Check Type of account if New or Existing         *
      *                                                               *
      * Called by: SRLoadDrv                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRChkTypAc    BEGSR

     C                   IF        WEffectiveDate < WFDCRDT
     C                   EVAL      WFDATYP = 'N'
     C                   ELSE
     C                   EVAL      WFDATYP = 'E'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWriteDrv - Write a record into the driving file             *
      *                                                               *
      * Called by: SRValCond                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRWriteDrv    BEGSR

     C                   EVAL      DCCUST = WFDCSNH
     C                   EVAL      DCFILE = WFDFILE
     C                   EVAL      DCHVAL = WFDHVAL
     C                   EVAL      DCTYPE = WFDTYPE
     C                   EVAL      DCCRNM = WFDCRNM
     C                   EVAL      DCCRDT = WFDCRDT
     C                   EVAL      DCATYP = WFDATYP
     C                   EVAL      DCSYDT = WFDSYDT

      ** Write to driver file
     C                   WRITE     SDDDCRD0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialisation                                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Access installation control data
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST'      POption
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POption
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF

     C                   CALLB     'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      WSysVal1      SVal01
     C                   PARM      *BLANKS       PVal01
     C                   PARM      WSysVal2      SVal02
     C                   PARM      *BLANKS       PVal02
     C                   PARM      WSysVal3      SVal03
     C                   PARM      *BLANKS       PVal03
     C                   PARM      WSysVal4      SVal04
     C                   PARM      *BLANKS       PVal04
     C                   PARM      WSysVal5      SVal05
     C                   PARM      *BLANKS       PVal05
     C                   PARM      WSysVal6      SVal06
     C                   PARM      *BLANKS       PVal06
     C                   PARM      WSysVal7      SVal07
     C                   PARM      *BLANKS       PVal07
     C                   PARM      *BLANKS       SVal08
     C                   PARM      *BLANKS       PVal08
     C                   PARM      *BLANKS       SVal09
     C                   PARM      *BLANKS       PVal09
     C                   PARM      *BLANKS       SVal10
     C                   PARM      *BLANKS       PVal10

     C                   IF        PRetCode  <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBKEy = SVal01
     C                   EVAL      DBase = 002
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF

      ** Convert CRS Existing A/C Individual/Medium to
      ** Midas Day Number

     C                   EVAL      PDate = WDilMedInd
     C                   EXSR      SrZDATE1
     C                   EVAL      WDMIDayNo = PDayNo

      ** Convert CRS Existing A/C Individual/High to
      ** Midas Day Number

     C                   EVAL      PDate = WDilHiInd
     C                   EXSR      SrZDATE1
     C                   EVAL      WDHIDayNo = PDayNo

      ** Convert CRS Existing A/C Entity/Medium to Midas Day Number

     C                   EVAL      PDate = WDilMedEnt
     C                   EXSR      SrZDATE1
     C                   EVAL      WDMEDayNo = PDayNo

      ** Convert CRS Existing A/C Entity/High to Midas Day Number

     C                   EVAL      PDate = WDilHiEnt
     C                   EXSR      SrZDATE1
     C                   EVAL      WDHEDayNo = PDayNo

      ** Convert CRS effective date to Midas Day Number

     C                   EVAL      PDate = WEffStrDate
     C                   EXSR      SrZDATE1
     C                   EVAL      WEffectiveDate = PDayNo

      ** Convert CRS Diligence New A/C for computation purpose
     C                   EVAL      ZADec = 0
     C                   EVAL      ZADig = 5
     C                   EVAL      ZField = PVal05
     C                   EXSR      SRAlgAmount
     C                   MOVE      ZField        WNewAc

      ** Convert Notice Days for Actions Report for CRS
     C                   EVAL      ZField = PVal07
     C                   EXSR      SRAlgAmount
     C                   MOVE      ZField        WNoticeDays

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAlgAmount - Align amount                                   *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRAlgAmount   BEGSR
      *
      * Align amount
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOK
     C                   PARM                    ZField
     C                   PARM                    ZADec
     C                   PARM                    ZADig
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZDATE1 - Validate and convert date to a day number         *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrZDATE1      BEGSR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDate
     C                   PARM      *ZERO         PDayNo
     C                   PARM                    BJDFIN
     C                   PARM                    PError
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZDAT10 - Convert YYYYMMDD Date to Midas Day                *
      *                                                               *
      *  Called by: SRLoadDrv                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrZDAT10      BEGSR
      *
     C                   CALLB     'ZDATE10'
     C                   PARM                    PDateIN
     C                   PARM                    PMDNO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
** CPY@
(c) Finastra International Limited 2016
