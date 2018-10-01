     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2017')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL CGL185 Utility')                              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  GL000672 - Midas GL FATCA Closed Accounts Balances           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD051779           Date 01Oct18               *
      *  Prev Amend No. MD045190           Date 07Apr17               *
      *                 MD045106           Date 03Apr17               *
      *                 CGL185  *CREATE    Date 13Mar17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD051779 - Missing GLC000672 on delivery                     *
      *  MD045190 - Other Closed FATCA Transaction records besides    *
      *             Closed Retail Accounts are deleted after FATCA    *
      *             EOY COB (Recompile)                               *
      *  MD045106 - CGL185 utility                                    *
      *  CGL185 - FATCA XML 2.0                                       *
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

      ** Midas GL FATCA Customer counts Balances
     FGLCSBAL2  UF A E           K DISK    INFSR(*PSSR)

      ** Midas GL Account Master Details
     FACCNTL1   IF   E           K DISK    INFSR(*PSSR)

      ** Midas RE Retail History File
     FREHISL0   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(R1)

      ** Midas SD Joint Account Member
     FSDJACCL0  IF   E           K DISK    INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

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

      ** Data Structures used by Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Data Structures used by Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Month Array
     DMonthAr          S              3A   DIM(MonthNo) CTDATA PERRCD(MonthNo)

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Variables used

     D WRUND           S              5  0
     D Retcd           S              7A
     D Prtcd           S              7A
     D Option          S              7A
     D WHIS            S              5  0
     D WSysYear        S              4A
     D WSysYearC       S              4A
     D WSysYearN       S              4S 0
     D MthIx           S              2  0
     D WDayNo          S              2A
     D WSvlMth         S              3A
     D WDateFmt        S              8A
     D WMthIx          S              2A
     D WWJANO          S              6A
     D JANO            S              6A
     D ACHL            S             10A
     D ACTY            S              4A
     D JATP            S              1A
     D CUST1           S              6A

      ** Constants
     D Up              C                   'ABCDEFGHIJKLMNOPQRS-
     D                                     TUVWXYZ'
     D Lo              C                   'abcdefghijklmnopqrs-
     D                                     tuvwxyz'

      ** Parameters ZDATE10
     D PDateIN         S              8S 0
     D PFATCDNO        S              5  0

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
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Read the first record from Account Details File

     C     *LOVAL        SETLL     ACCNTL1
     C                   READ      ACCNTL1

      ** Do while end of file not reached.

     C                   DOW       NOT %EOF(ACCNTL1)

     C                   MOVE      CNUM          CUST1
     C                   EVAL      JANO = *Blanks
     C                   EVAL      ACHL = *Blanks
     C                   EVAL      ACTY = *Blanks
     C                   EVAL      JATP = *Blanks

     C     WACCT3        CHAIN     GLCSBAL2

     C                   EVAL      CBYEAR = WSysYear
     C                   MOVEL     CNUM          CBCUST
     C                   EVAL      CBCURR = CCY
     C                   EVAL      CBBRCH = BRCA
     C                   EVAL      CBACOD = ACOD
     C                   EVAL      CBACSQ = ACSQ
     C                   EVAL      CBTRNN = *BLANKS
     C                   EVAL      CBTTYP = *BLANKS
     C                   EVAL      CBJANO = *BLANKS
     C                   EVAL      CBACHL = *BLANKS
     C                   EVAL      CBACTY = *BLANKS
     C                   EVAL      CBJATP = *BLANKS

      ** Get last history record to get previous day balance before closing account

     C                   EVAL      WHIS = PFATCDNO

     C     WACCT1        SETGT     REHISL0
     C     WACCT2        READPE    REHISL0

     C                   IF        %FOUND(REHISL0)
     C                             AND R1HISB > *ZERO
     C                             AND R1CNUM = CNUM
     C                             AND R1BRCA = BRCA
     C                             AND R1CCY = CCY
     C                             AND R1ACSQ = ACSQ
     C                             AND R1ACOD = ACOD
     C                             AND R1HISD <= PFATCDNO

     C                   EVAL      CBBALN = R1HISB

     C                   IF        %FOUND(GLCSBAL2)
     C                   UPDATE    GLCSBAD0
     C                   ELSE
     C                   WRITE     GLCSBAD0
     C                   ENDIF

     C                   EVAL      WWJANO = CBCUST
     C     WWJANO        SETLL     SDJACCL0
     C     WWJANO        READE     SDJACCL0

     C                   DOW       NOT %EOF(SDJACCL0)

     C                   EVAL      JANO = JCJANO
     C                   IF        JCCUST <> *BLANKS
     C                   EVAL      ACHL = JCCUST
     C                   EVAL      ACTY = 'CUST'
     C                   ELSE
     C                   EVAL      ACHL = JCNAHO
     C                   EVAL      ACTY = 'NAHO'
     C                   ENDIF
     C                   EVAL      JATP = 'M'

     C     WACCT3        CHAIN     GLCSBAL2

     C                   EVAL      CBYEAR = WSysYear
     C                   MOVEL     CNUM          CBCUST
     C                   EVAL      CBCURR = CCY
     C                   EVAL      CBBRCH = BRCA
     C                   EVAL      CBACOD = ACOD
     C                   EVAL      CBACSQ = ACSQ
     C                   EVAL      CBTRNN = *BLANKS
     C                   EVAL      CBTTYP = *BLANKS
     C                   EVAL      CBJANO = JCJANO
     C                   EVAL      CBCUST = JCCUST
     C                   IF        JCCUST <> *BLANKS
     C                   EVAL      CBACHL = JCCUST
     C                   EVAL      CBACTY = 'CUST'
     C                   ELSE
     C                   EVAL      CBACHL = JCNAHO
     C                   EVAL      CBACTY = 'NAHO'
     C                   ENDIF
     C                   EVAL      CBJATP = 'M'

     C                   IF        %FOUND(GLCSBAL2)
     C                   UPDATE    GLCSBAD0
     C                   ELSE
     C                   WRITE     GLCSBAD0
     C                   ENDIF

     C                   EVAL      CBJANO = *BLANKS
     C                   EVAL      CBACHL = *BLANKS
     C                   EVAL      CBACTY = *BLANKS
     C                   EVAL      CBJATP = *BLANKS

     C     WWJANO        READE     SDJACCL0
     C                   ENDDO

     C                   ENDIF

      ** Read next record.

     C                   READ      ACCNTL1

     C                   ENDDO

     C                   MOVE      *ON           *INLR
     C                   RETURN

      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    Prtcd
     C                   PARM                    WSysYear

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       Retcd
     C                   PARM      '*FIRST '     Option
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C     Retcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     Option        DBKEY
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF

     C                   EVAL      WRUND  =  BJRDNB

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
     C                   MOVE      WSysYear      WSysYearN
     C**********         EVAL      WSysYearN = WSysYearN - 1                                MD045106
     C                   EVAL      WSysYearN = WSysYearN + 1                                MD045106
     C                   MOVE      WSysYearN     WSysYearC
     C                   EVAL      WDateFmt = WSysYearC + WMthIx + WDayNo
     C                   EVAL      PDateIN = %DEC(WDateFmt:8:0)

     C                   CALLB     'ZDATE10'
     C                   PARM                    PDateIN
     C                   PARM      *ZERO         PFATCDNO
                                                                                            MD045106
     C                   IF        PFATCDNO >= BJRDNB                                       MD045106
     C                   EVAL      WSysYearN = WSysYearN - 1                                MD045106
     C                   MOVE      WSysYearN     WSysYearC                                  MD045106
     C                   EVAL      WDateFmt = WSysYearC + WMthIx + WDayNo                   MD045106
     C                   EVAL      PDateIN = %DEC(WDateFmt:8:0)                             MD045106
                                                                                            MD045106
     C                   CALLB     'ZDATE10'                                                MD045106
     C                   PARM                    PDateIN                                    MD045106
     C                   PARM      *ZERO         PFATCDNO                                   MD045106
     C                   ENDIF                                                              MD045106

      ** Initialize enhancements indicator


     C     WACCT1        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    WHIS

     C     WACCT2        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ

     C     WACCT3        KLIST
     C                   KFLD                    CUST1
     C                   KFLD                    BRCA
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    CCY
     C                   KFLD                    JANO
     C                   KFLD                    ACHL
     C                   KFLD                    ACTY
     C                   KFLD                    JATP

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

     C                   EVAL      Prtcd = '*Error'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'GLCSBAPD'
     C                   EVAL      DBASE = 3
     C                   OUT       LDA

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR
      *****************************************************************
**   MonthAr - Month short name
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
