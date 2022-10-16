     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL MD-60586 data patch program for MMDELDPP')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SMU90013 - Midas DL MD-60586 data patch program for MMDELDPP *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD060586  *CREATE  Date 13Oct22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060586 - A term deposit can´t be ended prematurely.        *
      *           - Zeroise the short term rate field from file       *
      *             MMDELDPP.                                         *
      *                                                               *
      *****************************************************************

     FMMDELDL0  UF   E           K DISK    INFSR(*PSSR)
     FSMU90013P1O    E             PRINTER OFLIND(*IN25)

      ** =======
      ** D-specs
      ** =======


     D/COPY ZACPYSRC,STD_D_SPEC

      ** Short Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Data Structure for Bank Details File
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Data Structure for Swtichable feature
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
     D PKEY1           S             10
     D PKYST           S              7

     D CDL033          S              1

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
      *
     C                   EXSR      ReadMMDELDPP
      ** Print Total
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     SMU90013T
      ** Print End of Report
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     SMU90013E

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  ReadMMDELDPP - read MMDELDPP file                            *
      *****************************************************************

     C     ReadMMDELDPP  BEGSR

     C     *LOVAL        SETLL     MMDELDL0
     C                   READ      MMDELDL0

     C                   DOW       NOT %EOF(MMDELDL0)

     C                   IF        HKSTRT <> 0

     C                   IF        CDL033 = 'N'
     C                   EXSR      PrintDetail1
     C                   EVAL      HKSTRT = 0
     C*                  UPDATE    MMDELDP0

     C                   ELSE
     C                   IF        CDL033 = 'Y'
     C                             AND HKBSRC <> *BLANKS
     C                   EXSR      PrintDetail1
     C                   EVAL      HKSTRT = 0
     C*                  UPDATE    MMDELDP0
     C                   ENDIF
     C
     C                   ENDIF

     C                   ENDIF

     C                   READ      MMDELDL0
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  PrintHeader1 - Print header 1                                *
      *****************************************************************

     C     PrintHeader1  BEGSR

     C                   IF        *IN25 = *ON
     C                   WRITE     SMU90013H1
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
     C                   WRITE     SMU90013H2
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *  PrintDetail1  - Print Detail record                          *
      *****************************************************************

     C     PrintDetail1  BEGSR

     C                   EVAL      PCTR+=1
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     SMU90013D1

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
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C     SDBANK        PARM                    SDBANK
      *
      ** If record not found, exit via DBERR subroutine
      *
     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SMU90013'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check if enhancement CGL032 is on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CDL033'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CDL033'
     C                   EVAL      DBASE  = 002
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   EVAL      *IN10 = '0'
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CDL033 = 'Y'
     C                   EVAL      *IN10 = '1'
     C                   ELSE
     C                   EVAL      CDL033 = 'N'
     C                   ENDIF

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
