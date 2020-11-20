     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD MD-57165 Data Patch Program')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  UTLE0855 - Midas SD Data Patch Program                       *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD057165  *CREATE  Date 18Nov20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD057165 - SP23 Correspondence manager cob failure after     *
      *             input of new fee                                  *
      *                                                               *
      *****************************************************************

     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     FLEFEEDLD  IF   E           K DISK    INFSR(*PSSR)
     FLEFEEQL0  UF   E           K DISK    INFSR(*PSSR)
     FUTLE0855P1O    E             PRINTER OFLIND(*IN25)

      ** =======
      ** D-specs
      ** =======


     D/COPY ZACPYSRC,STD_D_SPEC

     D ARRREM          S             60    DIM(15) CTDATA PERRCD(1)

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
     C                   EXSR      ReadUTLE0855
      ** Print Total
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTLE0855T
      ** Print End of Report
     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTLE0855E

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *  ReadUTLE0855   - read UTLE0855 logical file                  *
      *****************************************************************

     C     ReadUTLE0855  BEGSR

     C     *LOVAL        SETLL     LEFEEQL0
     C                   READ      LEFEEQL0

     C                   DOW       NOT %EOF(LEFEEQL0)

     C                   IF        FQLOAN <> *BLANKS
     C                   EVAL      PLNRF = FQLOAN
     C                   EVAL      POLNO = FQCNUM
     C                   EVAL      PFSEQ = FQFSEQ
     C     LEFEEDKEY     CHAIN     LEFEEDLD
     C                   IF        %FOUND(LEFEEDLD)
     C                   IF        FQCNUM <> FECNUM
     C                   EVAL      PCNUM = FECNUM
     C     FELOAN        CHAIN     CLOAN
     C                   IF        %FOUND(CLOAN)
     C                   EVAL      PPTYP = PTYP
     C                   EVAL      PCTR+=1
     C                   EVAL      PREM1 = ARRREM(1)
     C                   EXSR      PrintDetail1
     C  N10              EVAL      PREM2 = ARRREM(2)
     C  N10              EXSR      PrintDetail2
     C  N10              EVAL      FQCNUM = CNUM
     C  N10              UPDATE    LEFEEQD0
     C                   ELSE
     C                   EVAL      PREM1 = ARRREM(3)
     C                   EXSR      PrintDetail1
     C                   EVAL      PREM2 = ARRREM(4)
     C                   EXSR      PrintDetail2
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'UTLE0855'
     C                   EVAL      DBFILE = 'CLOAN'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = LNRF
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   READ      LEFEEQL0
     C                   ENDDO


     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  PrintHeader1 - Print header 1                                *
      *****************************************************************

     C     PrintHeader1  BEGSR

     C                   IF        *IN25 = *ON
     C                   WRITE     UTLE0855H1
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
     C                   WRITE     UTLE0855H2
     C                   EVAL      *IN25 = *OFF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *  PrintDetail1  - Print Detail record                          *
      *****************************************************************

     C     PrintDetail1  BEGSR

     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTLE0855D1
     C                   EXSR      ClearDetail1

     C                   ENDSR

      *****************************************************************
      *  PrintDetail2  - Print Detail record                          *
      *****************************************************************

     C     PrintDetail2  BEGSR

     C                   EXSR      PrintHeader1
     C                   EXSR      PrintHeader2
     C                   WRITE     UTLE0855D2
     C                   EXSR      ClearDetail2

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  ClearDetail1 - Clear Detail Fields                           *
      *****************************************************************

     C     ClearDetail1  BEGSR
      *
     C                   EVAL      PLNRF = *BLANKS
     C                   EVAL      PCNUM = *BLANKS
     C                   EVAL      POLNO = *BLANKS
     C                   EVAL      PPTYP = 0
     C                   EVAL      PFSEQ = 0
     C                   EVAL      PREM1 = *BLANKS
      *
     C                   ENDSR


      *****************************************************************
      /EJECT
      *****************************************************************
      *  ClearDetail2 - Clear Detail Fields                           *
      *****************************************************************

     C     ClearDetail2  BEGSR
      *
     C                   EVAL      PREM2 = *BLANKS
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************

     C     *INZSR        BEGSR

     C     LEFEEDKEY     KLIST
     C                   KFLD                    FQLOAN
     C                   KFLD                    FQFSEQ

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
     C                   EVAL      DBPGM = 'UTLE0855'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EXSR      ClearDetail1
     C                   EXSR      ClearDetail2
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
Finastra International Limited 2020
** ARRAY REMARKS
Fee customer is not equal from fee customer extension.
Fee extension customer has been amended to Fee customer.
Loan customer is not found in CLOANCL.
Please investigate what happened, program terminated.
