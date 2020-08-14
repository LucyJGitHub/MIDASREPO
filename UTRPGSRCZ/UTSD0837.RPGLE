     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  UTSD0837 - Midas SD Data Patch Program                       *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD053260  *CREATE  Date 12Jul19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053260 - FBM COB - Component SDC000817 00001 terminated    *
      *             abnormally. Database error in file SDCUSTPD,      *
      *             key 000992, in , at 001                           *
      *                                                               *
      *****************************************************************
 
     FSDINPHL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     EXTMBR('*ALL')
     F                                     INFDS(INFDS)
 
     FUTSD0837P1O    E             PRINTER OFLIND(*IN25)
 
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
 
     D INFDS           DS
     D  MEMBER               129    138A
 
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
 
     D CER048          S              1
 
     D/COPY ZSRSRC,ZHOLILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Initialize total counter
     C                   EVAL      PCTR1 = 0
     C                   EVAL      PCTR2 = 0
      *
     C                   EVAL      *IN10 = *OFF
     C                   IF        PMODE = 'A'
     C                             OR PMODE = 'a'
     C                   EVAL      *IN10 = *ON
     C                   ENDIF
      *
      ** Print Header
     C                   EVAL      *IN25 = *ON
     C                   EXSR      PrintHeader1
     C                   EVAL      *IN25 = *ON
     C                   EXSR      PrintHeader2
     C                   Z-ADD     1             INTHDG            1 0
      *
     C                   IF        CER048 = 'Y'
     C                   EXSR      ReadSDINPHPD
     C                   ENDIF
      *
      ** Print Total
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTSD0837T1
      *
      ** Print Grand Total
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTSD0837T2
      *
      ** Print End of Report
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTSD0837E
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * ReadSDINPHPD - read SDINPHPD file                             *
      *****************************************************************
 
     C     ReadSDINPHPD  BEGSR
 
     C                   OPEN      SDINPHL0
     C     *LOVAL        SETLL     SDINPHL0
     C                   READ      SDINPHL0
 
     C                   DOW       NOT %EOF(SDINPHL0)
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      TICUST        PKEY1
     C                   PARM      *BLANK        PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*CUSCLS'
     C                             AND PRTCD <> '*CUSDEL'
      *
     C                   MOVE      INFDS         WFMBR
     C                   IF        WFMBR <> PMBR
     C                   IF        INTHDG = 1
     C                   Z-ADD     0             INTHDG            1 0
     C                   ELSE
     C                   EXSR      PrintHeader1
     c                   EXSR      PrintHeader2
     C                   WRITE     UTSD0837T1
     C                   EVAL      PCTR1 = 0
      *
     C                   EVAL      *IN25 = *ON
     C                   EXSR      PrintHeader1
     C                   EVAL      *IN25 = *ON
     c                   EXSR      PrintHeader2
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      PCTR1+=1
     C                   EVAL      PCTR2+=1
      *
     C                   EVAL      PCUST = PKEY1
     C                   EVAL      PREM  = ARRREM(1)
     C                   MOVE      INFDS         PMBR
     C                   EXSR      PrintDetail1
     C  N10              EVAL      PREM2 = ARRREM(2)
     C  N10              EXSR      PrintDetail2
     C  N10              DELETE    SDINPHD0
     C                   ENDIF
 
     C                   READ      SDINPHL0
     C                   ENDDO
     C                   CLOSE     SDINPHL0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  PrintHeader1 - Print header 1                                *
      *****************************************************************
 
     C     PrintHeader1  BEGSR
 
     C                   IF        *IN25 = *ON
     C                   WRITE     UTSD0837H1
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
     C                   WRITE     UTSD0837H2
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *  PrintDetail1  - Print Detail record                          *
      *****************************************************************
 
     C     PrintDetail1  BEGSR
 
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTSD0837D1
 
     C                   ENDSR
 
      *****************************************************************
      *  PrintDetail2  - Print Detail record                          *
      *****************************************************************
 
     C     PrintDetail2  BEGSR
 
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTSD0837D2
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PMODE
 
      ** Check if CER048 is on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CER048'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '
     C                   EVAL      DBPGM  = 'UTSD0837'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBKEY  = 'CER048'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CER048 = 'Y'
     C                   ELSE
     C                   EVAL      CER048 = 'N'
     C                   ENDIF
      *
     C                   EVAL      PCUST = *BLANKS
     C                   EVAL      PREM  = *BLANKS
     C                   EVAL      PMBR  = *BLANKS
     C                   MOVEL     *BLANKS       WFMBR            10
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
Customer in SDINPHPD but not found in SDCUSTPD.
Record was physically deleted in SDINPHPD.