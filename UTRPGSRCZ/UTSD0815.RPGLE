     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD MD-51784 Data Patch Program')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  UTSD0815 - Midas SD Data Patch Program                       *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD051784  *CREATE  Date 20Feb19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD051784 - FBM Live COB: SDC000776 Customers Status Update   *
      *             at Effective Date 2 FAILED                        *
      *                                                               *
      *****************************************************************

     FSDCUSTL0  UF   E           K DISK    INFSR(*PSSR)
     FSDACTXL0  UF   E           K DISK    INFSR(*PSSR)
     FSDFTCSL0  UF   E           K DISK    INFSR(*PSSR)
     FSDCUSXL0  UF   E           K DISK    INFSR(*PSSR)
     FUTSD0815P1O    E             PRINTER OFLIND(*IN25)

      ** =======
      ** D-specs
      ** =======


     D/COPY ZACPYSRC,STD_D_SPEC

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
     D PMODE           S              1
     D PRTN            S              1

     D CGL032          S              1
     D CGL132          S              1
     D CSD007          S              1

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
      *
     C                   IF        CGL032 = 'Y'
     C                   EXSR      ReadSDACTXPD
     C                   ENDIF
      *
     C                   IF        CGL132 = 'Y'
     C                   EXSR      ReadSDFTCSPD
     C                   EXSR      ReadSDCUSTXC
     C                   ENDIF
      ** Print Total
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTSD0815T
      ** Print End of Report
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTSD0815E

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  ReadSDACTXPD - read SDACTXPD file                             *
      *****************************************************************

     C     ReadSDACTXPD  BEGSR

     C     *LOVAL        SETLL     SDACTXL0
     C                   READ      SDACTXL0

     C                   DOW       NOT %EOF(SDACTXL0)

     C                   EVAL      PKEY1 = AXCUST
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C                   PARM      *BLANK        PKYST
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        CSD007 = 'N'
     C                             AND PRTCD <> *BLANKS
     C                             OR CSD007 = 'Y'
     C                             AND PRTCD <> *BLANKS
     C                             AND PRTCD <> '*CUSCLS'
     C                             AND PRTCD <> '*CUSDEL'
     C                   EVAL      PCTR+=1
     C                   EVAL      PCTTX = AXCTTX
     C                   EVAL      PREM = ARRREM(1)
     C                   EVAL      PCUST = PKEY1
     C                   EXSR      PrintDetail1
     C  N10              EVAL      PCTTX = *BLANKS
     C  N10              EVAL      PREM2 = ARRREM(2)
     C  N10              EXSR      PrintDetail2
     C  N10              DELETE    SDACTXD0
     C                   ENDIF

     C                   READ      SDACTXL0
     C                   ENDDO


     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  ReadSDFTCSPD - read SDFTCSPD file                            *
      *****************************************************************

     C     ReadSDFTCSPD  BEGSR

     C     *LOVAL        SETLL     SDFTCSL0
     C                   READ      SDFTCSL0

     C                   EVAL      PCTTX = *BLANKS
     C                   DOW       NOT %EOF(SDFTCSL0)

     C                   EVAL      PKEY1 = FACUST
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C                   PARM      *BLANK        PKYST
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        CSD007 = 'N'
     C                             AND PRTCD <> *BLANKS
     C                             OR CSD007 = 'Y'
     C                             AND PRTCD <> *BLANKS
     C                             AND PRTCD <> '*CUSCLS'
     C                             AND PRTCD <> '*CUSDEL'
     C                   EVAL      PCTR+=1
     C                   EVAL      PREM = ARRREM(3)
     C                   EVAL      PCUST = PKEY1
     C                   EXSR      PrintDetail1
     C  N10              EVAL      PREM2 = ARRREM(4)
     C  N10              EXSR      PrintDetail2
     C  N10              DELETE    SDFTCSD0
     C                   ENDIF

     C                   READ      SDFTCSL0
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  ReadSDCUSTXC - read SDCUSTXC file                            *
      *****************************************************************

     C     ReadSDCUSTXC  BEGSR

     C     *LOVAL        SETLL     SDCUSXL0
     C                   READ      SDCUSXL0

     C                   EVAL      PCTTX = *BLANKS
     C                   DOW       NOT %EOF(SDCUSXL0)

     C                   EVAL      PKEY1 = XCCUST
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C                   PARM      *BLANK        PKYST
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        CSD007 = 'N'
     C                             AND PRTCD <> *BLANKS
     C                             OR CSD007 = 'Y'
     C                             AND PRTCD <> *BLANKS
     C                             AND PRTCD <> '*CUSCLS'
     C                             AND PRTCD <> '*CUSDEL'
     C                   EVAL      PCTR+=1
     C                   EVAL      PREM = ARRREM(5)
     C                   EVAL      PCUST = PKEY1
     C                   EXSR      PrintDetail1
     C  N10              EVAL      PREM2 = ARRREM(6)
     C  N10              EXSR      PrintDetail2
     C  N10              DELETE    SDCUSTX0
     C                   ENDIF

     C                   READ      SDCUSXL0
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  PrintHeader1 - Print header 1                                *
      *****************************************************************

     C     PrintHeader1  BEGSR

     C                   IF        *IN25 = *ON
     C                   WRITE     UTSD0815H1
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
     C                   WRITE     UTSD0815H2
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *  PrintDetail1  - Print Detail record                          *
      *****************************************************************

     C     PrintDetail1  BEGSR

     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTSD0815D1

     C                   ENDSR

      *****************************************************************
      *  PrintDetail2  - Print Detail record                          *
      *****************************************************************

     C     PrintDetail2  BEGSR

     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTSD0815D2

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
     C                   EVAL      DBPGM = 'UTSD0815'
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
     C                   PARM      'CGL032'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CGL032'
     C                   EVAL      DBASE  = 2
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CGL032 = 'Y'
     C                   ELSE
     C                   EVAL      CGL032 = 'N'
     C                   ENDIF
      *
      ** Check if enhancement CSD007 is on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD007'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CSD007'
     C                   EVAL      DBASE  = 4
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSD007 = 'Y'
     C                   ELSE
     C                   EVAL      CSD007 = 'N'
     C                   ENDIF
      *
      ** Check if enhancement CGL132 is on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL132'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CGL132'
     C                   EVAL      DBASE  = 3
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CGL132 = 'Y'
     C                   ELSE
     C                   EVAL      CGL132 = 'N'
     C                   ENDIF
      *
     C                   EVAL      PCUST = *BLANKS
     C                   EVAL      PCUST = *BLANKS
     C                   EVAL      PREM  = *BLANKS
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
Finastra International Limited 2019
** ARRAY REMARKS
Customer in SDACTXPD but not found in SDCUSTPD.
Record was physically deleted in SDACTXPD.
Customer in SDFTCSPD but not found in SDCUSTPD.
Record was physically deleted in SDFTCSPD.
Customer in SDCUSTXC but not found in SDCUSTPD.
Record was physically deleted in SDCUSTXC.
