     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL FATCA End of Year Check')                     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000620 - Midas GL FATCA End of Year Check                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CGL154  *CREATE    Date 13Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL154 - FATCA Reporting                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR       - Initialise                                    *
      *  *PSSR        - Error processing                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Data Structures used by Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Data Structures used by SD General ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** ** Short Data Structure

     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)

      ** Month Array
     DMonthAr          S              3A   DIM(MonthNo) CTDATA PERRCD(MonthNo)

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for AOSVALR0
     D POP01           S             20A   INZ('FATCAEOYCompRunDate')
     D POP02           S             20A
     D POP03           S             20A
     D POP04           S             20A
     D POP05           S             20A
     D POP06           S             20A
     D POP07           S             20A
     D POP08           S             20A
     D POP09           S             20A
     D POP10           S             20A
     D PVL01           S            200A
     D PVL02           S            200A
     D PVL03           S            200A
     D PVL04           S            200A
     D PVL05           S            200A
     D PVL06           S            200A
     D PVL07           S            200A
     D PVL08           S            200A
     D PVL09           S            200A
     D PVL10           S            200A

      ** Parameters AOBANKR0

     D POptn           S              7A
     D PRtcd           S              7A

      ** Parameters for ZDATE9
     D DayOut8         S              8S 0
     D WNAcrDt         S              8
     D DateIn5         S              5P 0
     D WSysYear        S              4A

      ** Parameters ZDATE10
     D PDateIN         S              8S 0
     D PFATCDNO        S              5  0

     D MthIx           S              2  0
     D WDayNo          S              2
     D WSvlMth         S              3
     D WDateFmt        S              8
     D WMthIx          S              2
     D FEoyFlag        S              1
     D FEoyDAYr        S              4
     D WYearNo         S              2
     D WYearNoP1       S              2
     D WYearNum        S              2S 0

      ** Constants
     D Up              C                   'ABCDEFGHIJKLMNOPQRS-
     D                                     TUVWXYZ'
     D Lo              C                   'abcdefghijklmnopqrs-
     D                                     tuvwxyz'

      ** Array Constants
     D MonthNo         C                   CONST(12)

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      *                                                               *
      * MAIN PROCEDURE                                                *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    FEoyFlag
     C                   PARM                    FEoyDAYr
     C                   PARM                    WYearNo
     C                   PARM                    WYearNoP1

      ** Get system rundate and Date of Next Working Day

     C                   EXSR      SrBankDtl

      ** Get the current year

     C                   EXSR      SrGetYr

      ** Get FATCA End Of Year day and month value

     C                   EXSR      SrSysVal

      ** Convert YYYYMMDD Format Date to Midas Day No.

     C                   EXSR      SrMdasDay

      ** Use access program to get the Accrual Profit Date

     C                   EXSR      SrAcrDate

      ** Check FATCA EOY Component run date if it is
      ** equal or greater than Accrual profit date
      ** and before next working day

     C                   IF        PFATCDNO <= BKAPDT
     C                   IF        WSysYear <> FEoyDAYr
     C                   EVAL      FEoyFlag = 'Y'
     C                   EVAL      FEoyDAYr = WSysYear
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      *INLR = *ON

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBankDtl - Get system rundate and Date of Next Working Day   *
      *                                                               *
      *****************************************************************
     C     SrBankDtl     BEGSR

     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF

     C                   EVAL      DateIn5 = BJRDNB

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetYr -  Convert Day Number to YYYYMMDD format and get the *
      *             year in YYYY format                               *
      *                                                               *
      *****************************************************************
     C     SrGetYr       BEGSR

      ** Convert Day Number to YYYYMMDD format

     C                   CALLB     'ZDATE9'
     C                   PARM                    DateIn5
     C                   PARM      *ZERO         DayOut8
     C                   PARM                    PRtcd

     C                   MOVE      DayOut8       WNAcrDt
     C                   EVAL      WSysYear  = %SubSt(WNAcrDt:1:4)
     C                   MOVE      WSysYear      WYearNo
     C                   EVAL      WYearNum = *ZERO
     C                   MOVE      WYearNo       WYearNum
     C                   MOVE      WYearNo       WYearNoP1
     C                   EVAL      WYearNum = WYearNum - 1
     C                   MOVE      WYearNum      WYearNo

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSysVal - Get FATCA End Of Year day and month value          *
      *                                                               *
      *****************************************************************
     C     SrSysVal      BEGSR

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    POP01
     C                   PARM                    PVL01
     C                   PARM                    POP02
     C                   PARM                    PVL02
     C                   PARM                    POP03
     C                   PARM                    PVL03
     C                   PARM                    POP04
     C                   PARM                    PVL04
     C                   PARM                    POP05
     C                   PARM                    PVL05
     C                   PARM                    POP06
     C                   PARM                    PVL06
     C                   PARM                    POP07
     C                   PARM                    PVL07
     C                   PARM                    POP08
     C                   PARM                    PVL08
     C                   PARM                    POP09
     C                   PARM                    PVL09
     C                   PARM                    POP10
     C                   PARM                    PVL10

     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY = POP01
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF

      ** Get the Day Number DD

     C                   EVAL      WDayNo = %SubSt(PVL01:1:2)

      ** Convert MMM to MM Month format

     C                   EVAL      WSvlMth = %SubSt(PVL01:3:3)
     C                   EVAL      WSvlMth = %XLATE(Lo:Up:WSvlMth)
     C                   EVAL      MthIx = (%LOOKUP (WSvlMth : MonthAr))

      ** Setup ZDATE10 parameters YYYYMMDD

     C                   MOVE      MthIx         WMthIx
     C                   EVAL      WDateFmt = WSysYear + WMthIx + WDayNo
     C                   EVAL      PDateIN = %DEC(WDateFmt:8:0)

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMdasDay - Convert YYYYMMDD Format Date to Midas Day No.    *
      *                                                               *
      *****************************************************************
     C     SrMdasDay     BEGSR

     C                   CALLB     'ZDATE10'
     C                   PARM                    PDateIN
     C                   PARM      *ZERO         PFATCDNO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAcrDate - Use access program for to get the Accrual Profit *
      *              Date                                             *
      *                                                               *
      *****************************************************************
     C     SrAcrDate     BEGSR

     C                   CALL      'AOGELRR0'
     C                   PARM      '*MSG   '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSFDY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR
      *****************************************************************
**   MonthAr - Month short name
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
