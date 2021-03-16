     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CB MD-57673 Data Patch Program')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business                                    *
      *                                                               *
      *  UTCB0857 - Midas CB Data Patch Program                       *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD057673  *CREATE  Date 13Mar21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD057673 - Unauthorised transactions screen error in         *
      *             CB001001DF                                        *
      *                                                               *
      *****************************************************************

     FGPDWNLL0  UF   E           K DISK    INFSR(*PSSR)
     FUTCB0857P1O    E             PRINTER OFLIND(*IN25)

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

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRTCD           S              7
     D POPTN           S              7
     D PMODE           S              1

     D W_DLVALF        S              1
     D W_PDLVAL        S              5

     D/COPY ZSRSRC,ZHOLILE

      *****************************************************************
      /EJECT
      *****************************************************************

     C                   EVAL      *IN10 = *OFF
     C                   IF        PMODE = 'A'
     C                             OR PMODE = 'a'
     C                   EVAL      *IN10 = *ON
     C                   ENDIF
      ** Initialize total counter
     C                   EVAL      PCTR  = 0
      ** Print Header
     C                   EVAL      *IN25 = *ON
     C                   EXSR      PrintHeader1
     C                   EVAL      *IN25 = *ON
     C                   EXSR      PrintHeader2
      ** Main sub-routine
     C                   EXSR      ReadGPDWNLPD
      ** Print Total
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTCB0857T
      ** Print End of Report
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTCB0857E

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  ReadGPDWNLPD - read GPDWNLPD file                            *
      *****************************************************************

     C     ReadGPDWNLPD  BEGSR

     C     *LOVAL        SETLL     GPDWNLL0
     C                   READ      GPDWNLL0

     C                   DOW       NOT %EOF(GPDWNLL0)

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
     C* N10              UPDATE    @DWNLL0
     C                   ENDIF

     C                   ENDIF

     C                   READ      GPDWNLL0
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
     C                   WRITE     UTCB0857H1
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
     C                   WRITE     UTCB0857H2
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
     C                   WRITE     UTCB0857D1

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PMODE

      *
      ** Read Bank details via Access program
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C     SDBANK        PARM                    SDBANK
      *
      ** If record not found, exit via DBERR subroutine
      *
     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'UTCB0857'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
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
Finastra International Limited 2021
