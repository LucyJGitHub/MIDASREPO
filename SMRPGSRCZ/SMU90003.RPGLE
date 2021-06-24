     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL MD-53068 Data Patch Program')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  SMU90003 - Midas DL Data Patch Program                       *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD053068  *CREATE  Date 11Jun21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053068 - FX deal not deleted after deletion in Kondor      *
      *                                                               *
      *****************************************************************

     FFXDEALL10 IF   E           K DISK
     FDLDEALL5  IF A E           K DISK
     FSMU90003P1O    E             PRINTER OFLIND(*IN25)

      ** Midas Local Data Area for database error reporting; based on
      ** external file
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)

     D APDUMP        E DS                  EXTNAME(APDUMP) DTAARA(APDUMP)

      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

     D ARRREM          S             50    DIM(15) CTDATA PERRCD(1)

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
     D PRTN            S              1

     D                 DS
     D  YYYYMMDD               1      8  0
     D  YYYY                   1      4  0
     D  MM                     5      6  0
     D  DD                     7      8  0
      *
     C                   EVAL      *IN10 = *OFF
      ** Print Header
     C                   EVAL      *IN25 = *ON
     C                   WRITE     SMU90003H1
     C                   WRITE     SMU90003H2
     C                   EVAL      *IN25 = *OFF
     C                   MOVEL     'SMU90003'    DBPGM
      *
     C                   READ      FXDEALL10
      *
      ** READ FX DEALS FILE UNTIL END OF FILE
      *
     C                   DOW       NOT %EOF(FXDEALL10)
      *
      ** CHECK IF EXISTING IN FX DEAL EXTENSION FILE
      *
     C                   MOVE      FHDN38        PDLNO
     C                   EVAL      PFRNT = FHFRNT
     C     PDLNO         CHAIN     DLDEALL5
      *
     C                   IF        NOT %FOUND(DLDEALL5)
      *
     C                   EVAL      PCTR+=1
     C                   EXSR      MoveFXtoQD
      *
     C                   EVAL      PREM = ARRREM(2)
     C                   EXSR      PrintDetail1
      *
     C                   WRITE     DLDLDBD0
      *
     C                   ENDIF
      *
      **READS NEXT RECORD ON FCPREQPD
      *
     C                   READ      FXDEALL10
     C                   ENDDO
      ** Print Total
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     SMU90003T
      ** Print End of Report
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     SMU90003E
     C                   SETON                                        LR

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  MoveFXtoQD - Move FX Deal to QD                              *
      *****************************************************************

     C     MoveFXtoQD    BEGSR

     C                   EVAL      F1BRCA = FHDBRC
     C                   MOVE      FHDN38        F1DLNO
     C                   EVAL      F1FCCU = *BLANKS
     C                   EVAL      F1FACT = 0
     C                   EVAL      F1FCNO = 0
     C                   EVAL      F1OFCC = *BLANKS
     C                   EVAL      F1OFAC = 0
     C                   EVAL      F1OFCN = 0
     C                   EVAL      F1FACI = *BLANKS
     C                   EVAL      F1TEXO = 0
     C                   EVAL      F1TEOF = 0
     C                   EVAL      F1TEOC = 0
     C                   EVAL      F1EXCY = *BLANKS
     C                   EVAL      F1FRID = FHFRNT

     C                   IF        *IN25 = *ON
     C                   WRITE     SMU90003H1
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  PrintHeader1 - Print header 1                                *
      *****************************************************************

     C     PrintHeader1  BEGSR

     C                   IF        *IN25 = *ON
     C                   WRITE     SMU90003H1
     C                   WRITE     SMU90003H2
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
     C                   WRITE     SMU90003H2
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
     C                   WRITE     SMU90003D1

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
     C                   EVAL      DBPGM = 'SMU90003'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   CLEAR                   SMU90003D1
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
** ARRAY REMARKS
FX deal not found in extension file
FX deal was written to extension file
