     H DEBUG
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD058081
/*STD *  RPGSQLBND                                                    *                     MD058081
/*EXI *  TEXT('Midas ME SWIFT ISO country codes set-up')              *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME001743 - ME Update MEISOCPD                                *
      *                                                               *
      *  Function:  This program setup FATF code for ISO Country code *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD058081           Date 11May21               *
      *  Prev Amend No. MD060760           Date 10Nov22               *
      *                 MD046248           Date 27Oct17               *
      *                 CSW213             Date 03Jun13               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13798           Date 24Apr07               *
      *                 BUG15045           Date 19Oct07               *
      *                 250600             Date 05Oct07               *
      *                 BUG14042           Date 24May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032  *CREATE    Date 11Sep06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  MD060760 - Recompiled due to MEBICCL0 key change             *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW213 - SWIFT Changes 2013 (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  BUG13798 - CFT032 errors. Applied as BUG14042.               *
      *  BUG15045 - Missing Ordering Customer field in MT103          *
      *  250600 - Defaulting of MiFId flag                            *
      *  BUG14042 - CFT032 errors ; applied fix 13798                 *
      *  CFT032 - Account line in field 50X in MT103                  *
      *                                                               *
      *****************************************************************
      *
     FSDCTRYL0  IF   E           K DISK
      *
     F*MEISOCL0* UF A E           K DISK                                                    MD058081
     F*                                    COMMIT
     F**********                           INFSR(*PSSR)                                     MD058081

      ** Array containing Copyright statement

     D A@CPY           DS
     D  CPY@                   1     80    DIM(1) CTDATA PERRCD(1)

      ** Local data area for database error details

     D TRANS           S              2    DIM(44) CTDATA PERRCD(44)                          250600
     D MIFID           S              2    DIM(30) CTDATA PERRCD(30)                          250600
     D FATF            S              2    DIM(48) CTDATA PERRCD(48)                          250600
     D EEAM            S              2    DIM(30) CTDATA PERRCD(30)                          250600
     D WLDA          E DS                  EXTNAME(LDA)

      ** Data Area giving Installation Control Details

     D RUNDAT        E DS                  EXTNAME(RUNDAT)

      ** Externally described DS for SAR details

     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** DS for Access Objects - short data structure

     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Bank's data structure

     D SDBANK        E DS                  EXTNAME(SDBANKPD)

     D MEISOC        E DS                  EXTNAME(MEISOJW0)                                MD058081
      ** Program Status Data Structure

     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263

     D Arr_ISOC        S              2A   DIM(60) CTDATA PERRCD(1)                         BUG14042
     D WBJMRDT         S              7
     D PRTCD           S              7
     D POPTN           S              7
     D CFT017          S              1
     D PSARD           S              6
     D WERR            S              1
     D WRUN            S              1
     D WTIME           S              6  0

      ** Set up copyright parameter

     C                   MOVEA     CPY@          CPY2@            80

     C                   EXSR      SRINIT

     C                   EXSR      SRDFLT

     C                   EXSR      SRSETVAL

      ** If error is encountered, roll back the values, else commit

     C*    WERR          IFEQ      'Y'
     C*                  ROLBK
     C*                  ELSE
     C*                  COMMIT
     C*                  ENDIF

     C                   MOVE      *ON           *INLR

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initial subroutine                                   *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR

     C     *DTAARA       DEFINE    LDA           WLDA
     C     *LOCK         IN        WLDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBPGM = 'ME001743'
     C                   OUT       WLDA

     C                   TIME                    WTIME

      ** Get Bank's Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      *  If return with an error (LR seton in called program) then
      *  process for database error.

     C     PRTCD         IFNE      *BLANK
     C     *LOCK         IN        WLDA
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   OUT       WLDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Get Midas Rundate

     C                   EVAL      WBJMRDT = BJMRDT

      ** Call access object to find out if switchable feature CFT017 is installed

     C                   EVAL      CFT017 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFT017'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF'
     C     *LOCK         IN        WLDA
     C                   EVAL      DBKEY = 'CFT017'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 2
     C                   OUT       WLDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      CFT017 = 'Y'
     C                   ENDIF                                                              CFT017

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDFLT - Set value for FATF to 'N'                            *
      *                                                               *
      *****************************************************************
      *
     C     SRDFLT        BEGSR

     C******LOVAL        SETLL     MEISOCL0                                                 MD058081
     C**********         READ      MEISOCL0                             0504                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ close ACursor                                                                       MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ declare ACursor cursor    for                                                       MD058081
     C+ select * from MEISOXTD                                                              MD058081
     C+ order by M3ISOC                                                                     MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ open ACursor                                                                        MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ACursor into :MEISOC                                                MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081

     C**********         IF        *IN05 = *ON                                              MD058081
     C                   IF        SQLCODE <> 0  and SQLCODE <> 100                         MD058081
     C     *LOCK         IN        WLDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'MEISOCPD'
     C                   EVAL      DBKEY = *BLANKS
     C                   OUT       WLDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C**********         DOW       *IN04 = *OFF                                             MD058081
     C                   DOW       SQLCODE = 0                                              MD058081

     C*********          EVAL      M3FATF = 'N'                                               250600
     C*****M3ISOC        CHAIN     SDCTRYL0                                                 BUG14042
     C**********         IF        %FOUND(SDCTRYL0)                                         BUG14042
     C**********         EVAL      M3FATF = 'Y'                                             BUG14042
     C**********         ENDIF                                                              BUG14042
      *                                                                                     BUG14042
      ***Do*not*use*SDCTRYL0*for*M3FATF*field,*use*the*ISO*countries                 BUG14042 250600
      ****stated*below*the*program                                                   BUG14042 250600
      *                                                                                     BUG14042
     C*****M3ISOC        LookUp    Arr_ISOC                               05         BUG14042 250600
     C**********         If        *IN05 = *ON                                       BUG14042 250600
     C**********         Eval      M3FATF = 'Y'                                      BUG14042 250600
     C**********         EndIf                                                       BUG14042 250600
     C     M3ISOC        CHAIN     SDCTRYL0                                                   250600
     C                   IF        %FOUND(SDCTRYL0)                                           250600
     C                   IF        M3FATF <> 'Y' and M3FATF <> 'N'                            250600
     C     M3ISOC        LOOKUP    FATF                                   94                  250600
     C                   IF        *IN94 = *ON                                                250600
     C                   EVAL      M3FATF = 'Y'                                               250600
     C                   ELSE                                                                 250600
     C                   EVAL      M3FATF = 'D'                                               250600
     C                   ENDIF                                                                250600
     C                   ENDIF                                                                250600
                                                                                              250600
     C                   IF        M3MFID <> 'Y' and M3MFID <> 'N'                            250600
     C     M3ISOC        LOOKUP    MIFID                                  94                  250600
     C                   IF        *IN94 = *ON                                                250600
     C                   EVAL      M3MFID = 'Y'                                               250600
     C                   ELSE                                                                 250600
     C                   EVAL      M3MFID = 'Y'                                               250600
     C                   ENDIF                                                                250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
     C                   IF        M3EEAM <> 'Y' and M3EEAM <> 'N'                            250600
     C     M3ISOC        LOOKUP    EEAM                                   94                  250600
     C                   IF        *IN94 = *ON                                                250600
     C                   EVAL      M3EEAM = 'Y'                                               250600
     C                   ELSE                                                                 250600
     C                   EVAL      M3EEAM = 'N'                                               250600
     C                   ENDIF                                                                250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
     C                   IF        M3SCHT <> 'Y' and M3SCHT <> 'N'                            250600
     C     M3ISOC        LOOKUP    TRANS                                  94                  250600
     C                   IF        *IN94 = *ON                                                250600
     C                   EVAL      M3SCHT = 'Y'                                               250600
     C                   ELSE                                                                 250600
     C                   EVAL      M3SCHT = 'N'                                               250600
     C                   ENDIF                                                                250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
     C**********         UPDATE    @ISOCL0                              05                  MD058081
     C/EXEC SQL                                                                             MD058081
     C+ update MEISOXTD set                                                                 MD058081
     C+   M3EEAM = :M3EEAM                                                                  MD058081
     C+ , M3FATF = :M3FATF                                                                  MD058081
     C+ , M3MFID = :M3MFID                                                                  MD058081
     C+ , M3SCHT = :M3SCHT                                                                  MD058081
     C+ where current of ACursor                                                            MD058081
     C/END-EXEC                                                                             MD058081

     C*********          IF        *IN05 = *ON                                              MD058081
     C                   IF        SQLCODE <> 0                                             MD058081
     C                   EVAL      WERR = 'Y'
     C     *LOCK         IN        WLDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'MEISOCPD'
     C                   EVAL      DBKEY = *BLANKS
     C                   OUT       WLDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C**********         READ      MEISOCL0                             0504                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ACursor into :MEISOC                                                MD058081
     C/END-EXEC                                                                             MD058081

     C**********         IF        *IN05 = *ON                                              MD058081
     C                   IF        SQLCODE <> 0  and SQLCODE <> 100                         MD058081
     C     *LOCK         IN        WLDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'MEISOCPD'
     C                   EVAL      DBKEY = *BLANKS
     C                   OUT       WLDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDDO

     C/EXEC SQL                                                                             MD058081
     C+ close ACursor                                                                       MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETVAL - Set value for MEISOCL0                             *
      *                                                               *
      *****************************************************************
      *
     C     SRSETVAL      BEGSR

     C     *LOVAL        SETLL     SDCTRYL0
     C                   READ      SDCTRYL0                             0504

     C                   IF        *IN05 = *ON
     C     *LOCK         IN        WLDA
     C                   EVAL      DBASE = 6
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBKEY = *BLANKS
     C                   OUT       WLDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   DOW       *IN04 = *OFF

     C*****A4ISOC        CHAIN     MEISOCL0                                                 MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEISOC                                                                        MD058081
     C+ from MEISOJW0                                                                       MD058081
     C+ where M3ISOC = :A4ISOC                                                              MD058081
     C/END-EXEC                                                                             MD058081
     C**********         IF        NOT %FOUND(MEISOCL0)                                     MD058081
     C                   IF        SQLCODE = 100                                            MD058081
     C                   EVAL      M3ISOC = A4ISOC
     C                   EVAL      M3ISOD = A4CNNM
     C**********         EVAL      M3SCHT = 'N'                                               250600
     C     A4ISOC        LOOKUP    FATF                                   94                  250600
     C                   IF        *IN94 = *ON                                                250600
     C                   EVAL      M3FATF = 'Y'                                               250600
     C                   ELSE                                                                 250600
     C                   EVAL      M3FATF = 'D'                                               250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
     C     A4ISOC        LOOKUP    MIFID                                  94                  250600
     C                   IF        *IN94 = *ON                                                250600
     C                   EVAL      M3MFID = 'Y'                                               250600
     C                   ELSE                                                                 250600
     C                   EVAL      M3MFID = 'Y'                                               250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
     C     A4ISOC        LOOKUP    EEAM                                   94                  250600
     C                   IF        *IN94 = *ON                                                250600
     C                   EVAL      M3EEAM = 'Y'                                               250600
     C                   ELSE                                                                 250600
     C                   EVAL      M3EEAM = 'N'                                               250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
     C     A4ISOC        LOOKUP    TRANS                                  94                  250600
     C                   IF        *IN94 = *ON                                                250600
     C                   EVAL      M3SCHT = 'Y'                                               250600
     C                   ELSE                                                                 250600
     C                   EVAL      M3SCHT = 'N'                                               250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
     C                   EVAL      M3ACJN = WSID
     C                   EVAL      M3ACUN = USER
     C                   EVAL      M3ACTM = WTIME
     C                   EVAL      M3ACDA = WBJMRDT
     C                   EVAL      M3ACTY = 'I'
     C**********         IF        CFT017 = 'Y'                                               250600
     C**********         EVAL      M3EEAM = 'N'                                               250600
     C**********         ENDIF                                                                250600
      *                                                                              BUG14042 250600
     C**********         Eval      M3FATF = 'N'                                      BUG14042 250600
     C*****M3ISOC        LookUp    Arr_ISOC                               05         BUG14042 250600
     C**********         If        *IN05 = *ON                                       BUG14042 250600
     C**********         Eval      M3FATF = 'Y'                                      BUG14042 250600
     C**********         EndIf                                                       BUG14042 250600

     C**********         WRITE     @ISOCL0                              06                  MD058081
     C/EXEC SQL                                                                             MD058081
     C+ insert into MEISOBTD                                                                MD058081
     C+ (                                                                                   MD058081
     C+   M3ISOC                                                                            MD058081
     C+  ,M3ISOD                                                                            MD058081
     C+  ,M3SCHT                                                                            MD058081
     C+  ,M3ACJN                                                                            MD058081
     C+  ,M3ACUN                                                                            MD058081
     C+  ,M3ACTM                                                                            MD058081
     C+  ,M3ACDA                                                                            MD058081
     C+  ,M3ACTY                                                                            MD058081
     C+  ,M3EEAM                                                                            MD058081
     C+  ,M3FATF                                                                            MD058081
     C+  ,M3MFID                                                                            MD058081
     C+  ,M3M205                                                                            MD058081
     C+  ,M3SEPA                                                                            MD058081
     C+  ,M3IBAC                                                                            MD058081
     C+  ,M3IBAR                                                                            MD058081
     C+  ,M3OCDT                                                                            MD058081
     C+  ,M3MCDT                                                                            MD058081
     C+  ,M3CCSP                                                                            MD058081
     C+  ,M3CCLN                                                                            MD058081
     C+  ,M3ICSP                                                                            MD058081
     C+  ,M3ICLN                                                                            MD058081
     C+  ,M3BBSP                                                                            MD058081
     C+  ,M3BBLN                                                                            MD058081
     C+  ,M3BISP                                                                            MD058081
     C+  ,M3BILN                                                                            MD058081
     C+  ,M3BRSP                                                                            MD058081
     C+  ,M3BRLN                                                                            MD058081
     C+  ,M3INLN                                                                            MD058081
     C+  ,M3ACSP                                                                            MD058081
     C+  ,M3ACLN                                                                            MD058081
     C+  ,M3TBLN                                                                            MD058081
     C+  ,M3TILN                                                                            MD058081
     C+  ,M3MODE                                                                            MD058081
     C+ )                                                                                   MD058081
     C+ Values                                                                              MD058081
     C+ (                                                                                   MD058081
     C+   :M3ISOC                                                                           MD058081
     C+  ,:M3ISOD                                                                           MD058081
     C+  ,:M3SCHT                                                                           MD058081
     C+  ,:M3ACJN                                                                           MD058081
     C+  ,:M3ACUN                                                                           MD058081
     C+  ,:M3ACTM                                                                           MD058081
     C+  ,:M3ACDA                                                                           MD058081
     C+  ,:M3ACTY                                                                           MD058081
     C+  ,:M3EEAM                                                                           MD058081
     C+  ,:M3FATF                                                                           MD058081
     C+  ,:M3MFID                                                                           MD058081
     C+  ,:M3M205                                                                           MD058081
     C+  ,:M3SEPA                                                                           MD058081
     C+  ,:M3IBAC                                                                           MD058081
     C+  ,:M3IBAR                                                                           MD058081
     C+  ,:M3OCDT                                                                           MD058081
     C+  ,:M3MCDT                                                                           MD058081
     C+  ,:M3CCSP                                                                           MD058081
     C+  ,:M3CCLN                                                                           MD058081
     C+  ,:M3ICSP                                                                           MD058081
     C+  ,:M3ICLN                                                                           MD058081
     C+  ,:M3BBSP                                                                           MD058081
     C+  ,:M3BBLN                                                                           MD058081
     C+  ,:M3BISP                                                                           MD058081
     C+  ,:M3BILN                                                                           MD058081
     C+  ,:M3BRSP                                                                           MD058081
     C+  ,:M3BRLN                                                                           MD058081
     C+  ,:M3INLN                                                                           MD058081
     C+  ,:M3ACSP                                                                           MD058081
     C+  ,:M3ACLN                                                                           MD058081
     C+  ,:M3TBLN                                                                           MD058081
     C+  ,:M3TILN                                                                           MD058081
     C+  ,'B'                                                                               MD058081
     C+ )                                                                                   MD058081
     C/END-EXEC                                                                             MD058081
     C/EXEC SQL                                                                             MD058081
     C+ insert into MEISOXTD                                                                MD058081
     C+ (                                                                                   MD058081
     C+   M3ISOC                                                                            MD058081
     C+  ,M3ISOD                                                                            MD058081
     C+  ,M3SCHT                                                                            MD058081
     C+  ,M3ACJN                                                                            MD058081
     C+  ,M3ACUN                                                                            MD058081
     C+  ,M3ACTM                                                                            MD058081
     C+  ,M3ACDA                                                                            MD058081
     C+  ,M3ACTY                                                                            MD058081
     C+  ,M3EEAM                                                                            MD058081
     C+  ,M3FATF                                                                            MD058081
     C+  ,M3MFID                                                                            MD058081
     C+  ,M3M205                                                                            MD058081
     C+  ,M3SEPA                                                                            MD058081
     C+  ,M3IBAC                                                                            MD058081
     C+  ,M3IBAR                                                                            MD058081
     C+  ,M3OCDT                                                                            MD058081
     C+  ,M3MCDT                                                                            MD058081
     C+  ,M3CCSP                                                                            MD058081
     C+  ,M3CCLN                                                                            MD058081
     C+  ,M3ICSP                                                                            MD058081
     C+  ,M3ICLN                                                                            MD058081
     C+  ,M3BBSP                                                                            MD058081
     C+  ,M3BBLN                                                                            MD058081
     C+  ,M3BISP                                                                            MD058081
     C+  ,M3BILN                                                                            MD058081
     C+  ,M3BRSP                                                                            MD058081
     C+  ,M3BRLN                                                                            MD058081
     C+  ,M3INLN                                                                            MD058081
     C+  ,M3ACSP                                                                            MD058081
     C+  ,M3ACLN                                                                            MD058081
     C+  ,M3TBLN                                                                            MD058081
     C+  ,M3TILN                                                                            MD058081
     C+  ,M3MODE                                                                            MD058081
     C+ )                                                                                   MD058081
     C+ Values                                                                              MD058081
     C+ (                                                                                   MD058081
     C+   :M3ISOC                                                                           MD058081
     C+  ,:M3ISOD                                                                           MD058081
     C+  ,:M3SCHT                                                                           MD058081
     C+  ,:M3ACJN                                                                           MD058081
     C+  ,:M3ACUN                                                                           MD058081
     C+  ,:M3ACTM                                                                           MD058081
     C+  ,:M3ACDA                                                                           MD058081
     C+  ,:M3ACTY                                                                           MD058081
     C+  ,:M3EEAM                                                                           MD058081
     C+  ,:M3FATF                                                                           MD058081
     C+  ,:M3MFID                                                                           MD058081
     C+  ,:M3M205                                                                           MD058081
     C+  ,:M3SEPA                                                                           MD058081
     C+  ,:M3IBAC                                                                           MD058081
     C+  ,:M3IBAR                                                                           MD058081
     C+  ,:M3OCDT                                                                           MD058081
     C+  ,:M3MCDT                                                                           MD058081
     C+  ,:M3CCSP                                                                           MD058081
     C+  ,:M3CCLN                                                                           MD058081
     C+  ,:M3ICSP                                                                           MD058081
     C+  ,:M3ICLN                                                                           MD058081
     C+  ,:M3BBSP                                                                           MD058081
     C+  ,:M3BBLN                                                                           MD058081
     C+  ,:M3BISP                                                                           MD058081
     C+  ,:M3BILN                                                                           MD058081
     C+  ,:M3BRSP                                                                           MD058081
     C+  ,:M3BRLN                                                                           MD058081
     C+  ,:M3INLN                                                                           MD058081
     C+  ,:M3ACSP                                                                           MD058081
     C+  ,:M3ACLN                                                                           MD058081
     C+  ,:M3TBLN                                                                           MD058081
     C+  ,:M3TILN                                                                           MD058081
     C+  ,'B'                                                                               MD058081
     C+ )                                                                                   MD058081
     C/END-EXEC                                                                             MD058081

     C**********         IF        *IN06 = *ON                                              MD058081
     C                   IF        SQLCODE <> 0                                             MD058081
     C                   EVAL      WERR = 'Y'
     C     *LOCK         IN        WLDA
     C                   EVAL      DBASE = 7
     C                   EVAL      DBFILE = 'MEISOCPD'
     C                   EVAL      DBKEY = *BLANKS
     C                   OUT       WLDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

     C                   READ      SDCTRYL0                             0504

     C                   IF        *IN05 = *ON
     C     *LOCK         IN        WLDA
     C                   EVAL      DBASE = 8
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBKEY = *BLANKS
     C                   OUT       WLDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDDO

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
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR

     C                   ROLBK
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP

     C                   CALL      'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR
      ********************************************************************
      **  MIFID                                                                             BUG15045
      ****ATBEBGCYCZDEDKEEELESFIFRGBHUIEISITLILTLULVMTNLNOPLPTROSESISK                      BUG15045
      **  FATF                                                                              BUG15045
      ****AEARATAUBEBHBRCACHCNCYCZDEDKEEFIFRGBGRHKHUIEISITJPKWLTLULVMTMXNLNONZOMPLPTQARUSASGBUG15045
**  CPY@
(c) Finastra International Limited 2006
**  TRANS
ADATBEBGBVCHCYCZDEDKESEEFIFRGBGFGIGPGRHUIEISITLILTLULVMCMQMTNLNOPLPMPTREROSESISJSKSMTFVA
**  MIFID
ATBEBGCYCZDEDKEEELESFIFRGBHUIEISITLILTLULVMTNLNOPLPTROSESISK
**  FATF
AEARATAUBEBHBRCACHCNCYCZDEDKEEFIFRGBGRHKHUIEISITJPKWLTLULVMTMXNLNONZOMPLPTQARUSASGSJSKSPSWTRUSZA
**  EEAM
ATBEBGCYCZDEDKEEELESFIFRGBHUIEISITLILTLULVMTNLNOPLPTROSESISK
** Arr_ISOC
AD
BV
CH
DE
DK
ES
FI
FR
GB
GF
GI
GP
GT
IE
IS
IT
LI
LU
MC
MQ
NL
NO
PM
PT
RE
SE
SJ
SM
TF
VA
BE
AT
CY
CZ
EE
HU
LT
LV
MT
PL
SI
SK
AE
AR
AU
BH
BR
CA
HK
JP
KW
MX
OM
QA
RU
SA
SG
TR
US
ZA
