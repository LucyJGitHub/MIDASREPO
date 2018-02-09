     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Due Diligence Action Extract')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000718 - Midas SD FATCA Due Diligence Action Extract       *
      *                                                               *
      *  Function:  This is a new program to extract the data to      *
      *             create the driving files to be used in Due        *
      *             Diligence Action Report for both Customer and     *
      *             Non-Account Holder                                *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD042946           Date 01Dec16               *
      *                 MD039670           Date 26Jul16               *
      *                 CGL154   *CREATE   Date 13Oct14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD042946 - Input Cycle Due Diligence Action Report is not    *
      *             generated (Recompile)                             *
      *  MD039670 - FATCA Housekeeping program                        *
      *  CGL154 - FATCA Reporting                                     *
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
      ** Customer Details File - Keyed by Info Complete Flag
     FSDFTCSL8  IF   E           K DISK
      *
      ** Non-Account Holders File - Keyed by Info Complete Flag
     FSDFTNHL8  IF   E           K DISK
      *
      ** Customer Extension
     FSDCUSXL0  IF   E           K DISK
      *
      ** Midas SD Due Diligence Action Driving File
     FSDDDACPD  O    E             DISK
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
      ** External DS Based On SDDDACPD
     D SDDDAC        E DS                  EXTNAME(SDDDACPD)
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
     D WEffectiveDate  S              5  0
     D WNewAc          S              5  0
     D WNoticeDays     S              5  0
     D WFDCSNH         S             10
     D WFDCRNM         S             20
     D WFDHVAC         S              1
     D WFDCRDT         S              5  0
     D WFDSYDT         S              5  0
     D WFDFILE         S              4
     D WFDCSTY         S              1
     D WFDATYP         S              1
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
      ** System value FATCA Diligence Existing A/C - Individual/Medium
     DWSysVal1         C                   'FATCADiligenceMedInd'
      *
      ** System value FATCA Diligence Existing A/C - Individual/High
     DWSysVal2         C                   'FATCADiligenceHiInd'
      *
      ** System value FATCA Diligence Existing A/C - Entity/Medium
     DWSysVal3         C                   'FATCADiligenceMedEnt'
      *
      ** System value FATCA Diligence Existing A/C - Entity/High
     DWSysVal4         C                   'FATCADiligenceHiEnt'
      *
      ** System value FATCA Diligence New A/C
     DWSysVal5         C                   'FATCADiligenceNewA/C'
      *
      ** System value FATCA Effective Date
     DWSysVal6         C                   'FATCAEffectStartDate'
      *
      ** System value Notice Days for Actions Report for FATCA
     DWSysVal7         C                   'FATCANotDaysActRept'
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
      * SRLoadDrv - Loop through the FATCA Customers and Non-Account  *
      *             Holders to load into the driving file             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: *PSSR, SRChkTypAc, SRChkSyDt, SRValCond,               *
      *        SrZDAT10                                               *
      *                                                               *
      *****************************************************************
     C     SRLoadDrv     BEGSR
 
      **  FATCA Customer
     C     *LOVAL        SETLL     SDFTCSL8
     C                   READ      SDFTCSL8
      *
     C                   DOW       NOT %EOF(SDFTCSL8)
      ** Clear driver file
     C                   CLEAR                   SDDDAC
     C                   EVAL      WFDCSNH = FACUST
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
     C                   READ      SDFTCSD0
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
     C                   EVAL      WFDHVAC = FAHVAC
     C                   EVAL      WFDCSTY = FACSTY
     C                   EVAL      WFDCRNM = BBCRNM
     C                   EVAL      WFDCRDT = XCCRDT
      ** Check Type of Account
     C                   EXSR      SRChkTypAc
      ** Validation Processing before writing to driver file
     C                   EXSR      SRValCond
     C                   ENDIF
     C                   ENDIF
     C                   READ      SDFTCSD0
     C                   ENDDO
 
      **  FATCA Non-Account Holder
     C     *LOVAL        SETLL     SDFTNHL8
     C                   READ      SDFTNHL8
 
     C                   DOW       NOT %EOF(SDFTNHL8)
      ** Clear driver file
     C                   CLEAR                   SDDDAC
     C                   EVAL      WFDCSNH = FNNAHO
      *
     C                   CALLB     'AONAHOR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WFDCSNH
     C     SDNAHO        PARM      SDNAHO        DSSDY
 
     C                   IF        PRTCD = '*NRF'                                           MD039670
     C                             OR NHCHTP = 'D'                                          MD039670
     C                   READ      SDFTNHL8                                                 MD039670
     C                   ITER                                                               MD039670
     C                   ENDIF                                                              MD039670
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
     C                   EVAL      WFDHVAC = FNHVAC
     C                   EVAL      WFDCSTY = FNNHTY
     C                   EVAL      WFDCRNM = NHNARN
      ** Convert Non-account Holder Creation Date to Midas Date
     C                   EVAL      PDateIn = NHCRDT
     C                   EXSR      SrZDAT10
     C                   EVAL      WFDCRDT = PMDNO
      ** Check Type of Account
     C                   EXSR      SRChkTypAc
      ** Validation Processing before writing to driver file
     C                   EXSR      SRValCond
     C                   ENDIF
      *
     C                   READ      SDFTNHD0
     C                   ENDDO
      *
     C                   FEOD      SDDDACPD
 
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
 
      ** Existing A/C - Individual/Medium
     C                   IF        FACSTY = 'P'
     C                             AND FAHVAC = 'M'
     C                             OR FNNHTY = 'P'
     C                             AND FNHVAC = 'M'
      *
     C                   EVAL      WFDSYDT = WDMIDayNo
      *
     C                   IF        (WDMIDayNo - WNoticeDays) <= BJRDNB
     C                   EXSR      SRWriteDrv
     C                   ENDIF
     C                   ENDIF
 
      ** Existing A/C - Individual/High
     C                   IF        FACSTY = 'P'
     C                             AND FAHVAC = 'H'
     C                             OR FNNHTY = 'P'
     C                             AND FNHVAC = 'H'
      *
     C                   EVAL      WFDSYDT = WDHIDayNo
      *
     C                   IF        (WDHIDayNo - WNoticeDays) <= BJRDNB
     C                   EXSR      SRWriteDrv
     C                   ENDIF
     C                   ENDIF
 
      ** Existing A/C - Entity/Medium
     C                   IF        FACSTY <> 'P'
     C                             AND FAHVAC = 'M'
     C                             OR FNNHTY <> 'P'
     C                             AND FNHVAC = 'M'
      *
     C                   EVAL      WFDSYDT = WDMEDayNo
      *
     C                   IF        (WDMEDayNo - WNoticeDays) <= BJRDNB
     C                   EXSR      SRWriteDrv
     C                   ENDIF
     C                   ENDIF
 
      ** Existing A/C - Entity/High
     C                   IF        FACSTY <> 'P'
     C                             AND FAHVAC = 'H'
     C                             OR FNNHTY <> 'P'
     C                             AND FNHVAC = 'H'
      *
     C                   EVAL      WFDSYDT = WDHEDayNo
      *
     C                   IF        (WDHEDayNo - WNoticeDays) <= BJRDNB
     C                   EXSR      SRWriteDrv
     C                   ENDIF
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
 
     C                   EVAL      FDCUST = WFDCSNH
     C                   EVAL      FDFILE = WFDFILE
     C                   EVAL      FDHVAC = WFDHVAC
     C                   EVAL      FDCSTY = WFDCSTY
     C                   EVAL      FDCRNM = WFDCRNM
     C                   EVAL      FDCRDT = WFDCRDT
     C                   EVAL      FDATYP = WFDATYP
     C                   EVAL      FDSYDT = WFDSYDT
 
      ** Write to driver file
     C                   WRITE     SDDDACD0
 
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
 
      ** Convert FATCA Existing A/C Individual/Medium to
      ** Midas Day Number
 
     C                   EVAL      PDate = WDilMedInd
     C                   EXSR      SrZDATE1
     C                   EVAL      WDMIDayNo = PDayNo
 
      ** Convert FATCA Existing A/C Individual/High to
      ** Midas Day Number
 
     C                   EVAL      PDate = WDilHiInd
     C                   EXSR      SrZDATE1
     C                   EVAL      WDHIDayNo = PDayNo
 
      ** Convert FATCA Existing A/C Entity/Medium to Midas Day Number
 
     C                   EVAL      PDate = WDilMedEnt
     C                   EXSR      SrZDATE1
     C                   EVAL      WDMEDayNo = PDayNo
 
      ** Convert FATCA Existing A/C Entity/High to Midas Day Number
 
     C                   EVAL      PDate = WDilHiEnt
     C                   EXSR      SrZDATE1
     C                   EVAL      WDHEDayNo = PDayNo
 
      ** Convert FATCA effective date to Midas Day Number
 
     C                   EVAL      PDate = WEffStrDate
     C                   EXSR      SrZDATE1
     C                   EVAL      WEffectiveDate = PDayNo
 
      ** Convert FATCA Diligence New A/C for computation purpose
     C                   EVAL      ZADec = 0
     C                   EVAL      ZADig = 5
     C                   EVAL      ZField = PVal05
     C                   EXSR      SRAlgAmount
     C                   MOVE      ZField        WNewAc
 
      ** Convert Notice Days for Actions Report for FATCA
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
(c) Finastra International Limited 2014
