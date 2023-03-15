     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Housekeeping of MEMOS Shadow files program')  *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL004609 - Midas GL Housekeeping of MEMOS Shadow files pgm   *
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

     FGLMEMOL0  UF   E           K DISK    INFSR(*PSSR)
     FGL004609P1O    E             PRINTER OFLIND(*IN25)

      ** =======
      ** D-specs
      ** =======


     D/COPY ZACPYSRC,STD_D_SPEC

      ** Data Structure for Bank Details File
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Data Structure for GPDWNLPD
     D                 DS
     D DS_DLVAL                1     50
     D DS_DLVAL1               1      1
     D DS_DLVAL2               2      2
     D DS_DLVAL3               3      3
     D DS_DLVAL4               4      4
     D DS_DLVAL5               5      5
     D DS_DLVAL1TO5            1      5
     D DS_DLVAL560             6     50

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

     D PRTCD           S              7
     D POPTN           S              7

     D W_DLVALF        S              1
     D W_PDLVAL        S              5
     D ErrorFlag       S              1A
     D DateIn5         S              5P 0
     D DayOut8         S              8S 0

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
     C                   EXSR      ReadGLMEMOTD
      ** Print Total
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     GL004609T
      ** Print End of Report
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     GL004609E

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  ReadGLMEMOTD - read GLMEMOTD file                            *
      *****************************************************************

     C     ReadGLMEMOTD  BEGSR

     C     *LOVAL        SETLL     GLMEMOL0
     C                   READ      GLMEMOL0

     C                   DOW       NOT %EOF(GLMEMOL0)

     C                   EVAL      METMST = WTMST
      ** Mimic V_DASHACTN sqlview file
     C                   IF        DLVAL <> ' ' AND DLUATH = 'Y'
     C                             OR DLVAL <> ' ' AND DLUATH = 'W'

      ** Validate DLVAL field
     C                   EXSR      VAL_DLVAL

      ** If DLVAL is converted to valid value
     C                   IF        W_DLVALF = 'Y'
     C                   EVAL      DS_DLVAL560 = *BLANKS
     C                   EVAL      PCTR+=1
     C                   EVAL      PMSID = DLMSID
     C                   EVAL      PKEYD = DLKEYD
     C                   EVAL      PVAL  = 'from ' + W_PDLVAL + ' to '
     C                             + DS_DLVAL1TO5
     C                   EXSR      PrintDetail1
     C                   EVAL      DLVAL = DS_DLVAL
     C                   UPDATE    @DWNLL0
     C                   ENDIF

     C                   ENDIF

     C                   READ      GLMEMOL0
     C                   ENDDO


     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  VAL_DLVAL - Validate DLVAL field                             *
      *****************************************************************

     C     VAL_DLVAL     BEGSR

     C                   EVAL      W_DLVALF = 'N'
     C                   EVAL      W_PDLVAL = DLVAL
     C                   EVAL      DS_DLVAL = DLVAL

      ** Conversion of DLVAL was simplified by replacing the non-numeric value to '0'
      ** DLVAL will also be updated by zonal background job MIDASSTS

     C                   IF        DS_DLVAL1 >= '0' AND DS_DLVAL1 <= '9'
     C                   ELSE
     C                   EVAL      DS_DLVAL1 = '0'
     C                   EVAL      W_DLVALF = 'Y'
     C                   ENDIF

     C                   IF        DS_DLVAL2 >= '0' AND DS_DLVAL2 <= '9'
     C                   ELSE
     C                   EVAL      DS_DLVAL2 = '0'
     C                   EVAL      W_DLVALF = 'Y'
     C                   ENDIF

     C                   IF        DS_DLVAL3 >= '0' AND DS_DLVAL3 <= '9'
     C                   ELSE
     C                   EVAL      DS_DLVAL3 = '0'
     C                   EVAL      W_DLVALF = 'Y'
     C                   ENDIF

     C                   IF        DS_DLVAL4 >= '0' AND DS_DLVAL4 <= '9'
     C                   ELSE
     C                   EVAL      DS_DLVAL4 = '0'
     C                   EVAL      W_DLVALF = 'Y'
     C                   ENDIF

     C                   IF        DS_DLVAL5 >= '0' AND DS_DLVAL5 <= '9'
     C                   ELSE
     C                   EVAL      DS_DLVAL5 = '0'
     C                   EVAL      W_DLVALF = 'Y'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  PrintHeader1 - Print header 1                                *
      *****************************************************************

     C     PrintHeader1  BEGSR

     C                   IF        *IN25 = *ON
     C                   WRITE     GL004609H1
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
     C                   WRITE     GL004609H2
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
     C                   WRITE     GL004609D1

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
     C                   EVAL      DBPGM = 'GL004609'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      DateIn5 = CDEFFD
      *
      ** Convert Midas Run Day Number to YYYYMMDD format
     C                   CALLB     'ZDATE9'
     C                   PARM                    DateIn5
     C                   PARM                    DayOut8
     C                   PARM                    ErrorFlag
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
