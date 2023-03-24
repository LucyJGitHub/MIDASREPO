     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Housekeeping of MEMOS-GLMEMOT2 pgm')          *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL004611 - Midas GL Housekeeping of MEMOS Shadow files pgm   *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD060909  *CREATE  Date 14Feb23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060909 - After COB job FTC0630 go in MSGW.                 *
      *                                                               *
      *****************************************************************

     FGLMEMOT2L0UF   E           K DISK    INFSR(*PSSR)
     FGL004611P1O    E             PRINTER OFLIND(*IN25)

      ** =======
      ** D-specs
      ** =======


     D/COPY ZACPYSRC,STD_D_SPEC

      ** Data Structure for Bank Details File
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

     D WDTMST          DS
     D  WTMST                  1     26
     D  WWY1                   1      2
     D  WWY2                   3      4
     D  WWMM                   6      7
     D  WWDD                   9     10
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PSValK1         S             20A
     D PSValK2         S             20A
     D PSValK3         S             20A
     D PSValK4         S             20A
     D PSValK5         S             20A
     D PSValK6         S             20A
     D PSValK7         S             20A
     D PSValK8         S             20A
     D PSValK9         S             20A
     D PSValK10        S             20A
     D PSVal1          S            200A
     D PSVal2          S            200A
     D PSVal3          S            200A
     D PSVal4          S            200A
     D PSVal5          S            200A
     D PSVal6          S            200A
     D PSVal7          S            200A
     D PSVal8          S            200A
     D PSVal9          S            200A
     D PSVal10         S            200A

     D PRTCD           S              7
     D POPTN           S              7
     D PDAYNO          S              5  0
     D PDATE           S              6  0
     D PADATE          S              7A
     D PYYMMDD         S              8S 0

     D WDayNoA         S              2A
     D WYYMMDDA        S              8A
     D WDayNo          S              2S 0
     D WDIFF           S              5S 0
     D ErrorFlag       S              1A
     D DateIn5         S              5P 0
     D DayOut8         S              8S 0
     D RundateYYMMDD   S              8S 0

      ** Constants for system values

     D WKeySysVal1     C                   CONST('MEMOSRetentionPeriod')

     D/COPY ZSRSRC,ZHOLILE

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Initialize total counter
     C                   EVAL      PCTR  = 0
      ** Print Header
     C                   EVAL      *IN25 = *ON
     C                   EXSR      PrintHeader1
     C                   EVAL      *IN25 = *ON
     C                   EXSR      PrintHeader2
      ** Main sub-routine
     C                   EXSR      ReadGLMEMOT2
      ** Print Total
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     GL004611T
      ** Print End of Report
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     GL004611E

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  ReadGLMEMOT2 - read GLMEMOT2 file                            *
      *****************************************************************

     C     ReadGLMEMOT2  BEGSR

     C     *LOVAL        SETLL     GLMEMOT2L0
     C                   READ      GLMEMOT2L0

     C                   DOW       NOT %EOF(GLMEMOT2L0)

     C                   MOVE      METMST        WTMST
     C                   EVAL      WTMST = %CHAR(METMST)
     C                   EVAL      WYYMMDDA = WWY1 + WWY2 + WWMM + WWDD
     C                   MOVE      WYYMMDDA      PYYMMDD
      *
      ** Convert Timestamp (YYYYMMDD) to Midas day
      *
     C                   CALL      'ZDATE10'
     C                   PARM                    PYYMMDD
     C                   PARM      *ZERO         PDAYNO

     C                   EVAL      WDIFF  = BJRDNB - PDAYNO
     C                   IF        WDIFF > WDayNo

     C                   EVAL      PCTR+=1
     C                   EVAL      PACNO = MEACNO
     C                   EVAL      PCNUM = MECNUM
     C                   EVAL      PCCY  = MECCY
     C                   EVAL      PACSQ = MEACSQ
     C                   EVAL      PBRCA = MEBRCA
      *
      ** Convert Value Date to DDMMMYY format
      *
     C                   EVAL      PDAYNO = MEVDAT
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      0             PDATE
     C                   PARM      *BLANKS       PADATE
     C                   EVAL      PVDATEA = PADATE

     C                   EVAL      PAMT = MEAMT
     C                   EVAL      PTMST = METMST
     C                   EXSR      PrintDetail1
     C                   DELETE    GLMEMOT2
     C                   ENDIF

     C                   READ      GLMEMOT2L0

     C                   ENDDO


     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  PrintHeader1 - Print header 1                                *
      *****************************************************************

     C     PrintHeader1  BEGSR

     C                   IF        *IN25 = *ON
     C                   WRITE     GL004611H1
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  PrintHeader2 - Print header 2                                *
      *****************************************************************

     C     PrintHeader2  BEGSR

     C                   IF        *IN25 = *ON
     C                   WRITE     GL004611H2
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  PrintDetail1  - Print Detail record                          *
      *****************************************************************

     C     PrintDetail1  BEGSR

     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     GL004611D1

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************

     C     *INZSR        BEGSR

      *
      ** Read Bank details via Access program
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C     SDBANK        PARM                    SDBANK
      *
      ** If record not found, exit via DBERR subroutine
      *
     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'GL004611'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      WKeySysVal1   PSValK1
     C                   PARM                    PSVal1
     C                   PARM      *BLANKS       PSValK2
     C                   PARM                    PSVal2
     C                   PARM      *BLANKS       PSValK3
     C                   PARM                    PSVal3
     C                   PARM      *BLANKS       PSValK4
     C                   PARM                    PSVal4
     C                   PARM      *BLANKS       PSValK5
     C                   PARM                    PSVal5
     C                   PARM      *BLANKS       PSValK6
     C                   PARM                    PSVal6
     C                   PARM      *BLANKS       PSValK7
     C                   PARM                    PSVal7
     C                   PARM      *BLANKS       PSValK8
     C                   PARM                    PSVal8
     C                   PARM      *BLANKS       PSValK9
     C                   PARM                    PSVal9
     C                   PARM      *BLANKS       PSValK10
     C                   PARM                    PSVal10
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'GL004611'
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = %TRIM(PSValK1)
     C                   OUT       LDA
      *
     C                   EXSR      *PSSR
      *
     C                   ENDIF

     C                   EVAL      WDayNoA = %SubSt(PSVal1:1:2)
     C                   MOVE      WDayNoA       WDayNo

      *
      ** Convert run date
      *
     C                   EVAL      DateIn5 = BJRDNB
      *
      ** Convert Midas Run Day Number to YYYYMMDD format
      *
     C*                  CALLB     'ZDATE9'
     C*                  PARM                    DateIn5
     C*                  PARM                    DayOut8
     C*                  PARM                    ErrorFlag

     C*                  EVAL      RundateYYMMDD = DayOut8

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
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
**
Finastra International Limited 2023
