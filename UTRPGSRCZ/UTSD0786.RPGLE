     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD MD-39670 Utility program for SDFTCSPD')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  UTSD0784 - Midas SD MD-39670 Utility program for SDFTCSPD    *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD039670  *CREATE  Date 26Jul16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD036288A - HK system failed component EMC06                 *
      *                                                               *
      *****************************************************************

     FSDFTCSL0  UF   E           K DISK    INFSR(*PSSR)

     FUTSD0786P1O    E             PRINTER OFLIND(*IN25)

      ** =======
      ** D-specs
      ** =======


     D/COPY ZACPYSRC,STD_D_SPEC

      ** External DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** Short Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long Data Structure for Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Data Structure for Customer Master File
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Data Structure for Bank Details File
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+


     D PRTCD           S              7
     D POPTN           S              7
     D PKEY1           S             10
     D PKYST           S              7
     D PMODE           S              7

      ** ZDATE2 Parameters
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7

      *****************************************************************
      /EJECT
      *****************************************************************

     C                   EVAL      *IN10 = *OFF
     C                   IF        PMODE = 'A'
     C                   EVAL      *IN10 = *ON
     C                   ENDIF

     C                   EXSR      SRSDFTCSPD

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSDFTCSPD - Patch SDFTCSPD subroutine                       *
      *****************************************************************

     C     SRSDFTCSPD    BEGSR

     C     *LOVAL        SETLL     SDFTCSL0
     C                   READ      SDFTCSL0

     C                   WRITE     UTSD0786H
     C                   WRITE     UTSD0786H2

     C                   EVAL      WCTR  = 0
     C                   DOW       NOT %EOF(SDFTCSL0)

     C                   EVAL      PKEY1  = FACUST
     C                   IF        PKEY1  <> *BLANKS

     C                   IF        *IN25 = *ON
     C                   WRITE     UTSD0786H
     C                   WRITE     UTSD0786H2
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF

     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY  '      POPTN
     C                   PARM                    PKEY1
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        PRTCD = *BLANKS
     C                   ELSE
     C                   IF        PRTCD = '*CUSCLS'
     C                             OR PRTCD = '*CUSDEL'
     C                             OR PRTCD = '*NRF'

     C                   EVAL      WCUST = FACUST
     C                   EVAL      WCLAC = FACLAC

     C                   Z-ADD     FACLAD        ZDAYNO
     C                   EXSR      SRDATE2
     C                   MOVEL     ZADATE        WCLAD

     C                   EVAL      WPCLA = FAPCLA

     C                   WRITE     UTSD0786D

     C                   IF        PMODE = 'U'
     C                   DELETE    SDFTCSD0
     C                   ENDIF
     C                   EVAL      WCTR +=1
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   READ      SDFTCSL0
     C                   ENDDO

     C                   IF        *IN25 = *ON
     C                   WRITE     UTSD0786H
     C                   WRITE     UTSD0786H2
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF
     C                   WRITE     UTSD0786T

     C                   IF        *IN25 = *ON
     C                   WRITE     UTSD0786H
     C                   WRITE     UTSD0786H2
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF
     C                   WRITE     UTSD0786E

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDATE2  - Convert Date to Printer Date                       *
      *                                                               *
      * Called by: SrPrint                                            *
      *                                                               *
      * Calls    : ZDATE2                                             *
      *                                                               *
      *****************************************************************

     C     SRDATE2       BEGSR

     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE

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
      ** Get Module details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST'      POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * Database error
      *
     C     PRTCD         IFNE      *BLANK
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF

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
     C                   EVAL      DBPGM = 'UTSD0786'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 002
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
