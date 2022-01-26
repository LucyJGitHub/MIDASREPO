     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058079
/*STD *  RPGSQLBND                                                    *                     MD058079
/*EXI *  TEXT('Midas Decision Table - Transaction Types')             *
     F********************************************************************
     F*                                                                  *
     F*    MIDAS/ABS - EUROPEAN REPORTING                                *
     F*                                                                  *
     F*    ERLU40 - DECISION TABLE - TRANSACTION TYPES                   *
     F*                                                                  *
      *  (c) Finastra International Limited 2005                      *
     F*                                                                  *
      *  Last Amend No. MD058079           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03May06               *
      *                 BUG10452            Date 09Feb06              *
      *                 CLE042              Date 06Sep05              *
      *                 CER001              Date 25Apr05              *
      *                 ULX047              Date 05Dec02              *
      *                 UPG402              Date 03Oct04              *
     F*                   ULX046              Date 22Oct02               *
     F*                   ADIFIX              Date 03Sep99               *
     F*                   ULX024              Date 03Sep99               *
     F*                   ULX011              Date 22Apr98               *
     F*                   ULX004              Date 10Jan95               *
     F*                   ER0449 TLI          Date 10Jan95               *
     F*                   ERL436 LV           Date 02Sep94               *
     F*                   ERL415 PT           DATE 22JUL94               *
     F*                   ERL386 PT           DATE 01FEB94               *
     F*                   ERL354 TLI          DATE 21JUN93               *
     F*                   ER0324 AF           DATE 02MAR93               *
     F*                   ER0323 TLI          DATE 01MAR93               *
     F*                   ER0314 TLI          DATE 29JAN93               *
     F*                   ERL200 TLI          DATE 13JAN93               *
     F*                   ER0101 ADs          DATE 24NOV92               *
     F*                   ER0100 ADs          DATE 24NOV92               *
     F*                                                                  *
     F*------------------------------------------------------------------*
     F*                                                                  *
      *  MD058079 - Deliverable Data Split for sundry files           *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  BUG10452 - No item reported on CADREPORT job                 *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
     F*    ULX047 - CSSF Market Values Calculation (not possible to      *
     F*             maintain FRA, IRS, floors, caps and collars anymore) *
      *  UPG402 - Recompile due to R4.02 upgrade                      *
     F*    ULX046 - Circulars 2002/170-174-175 Integration               *
     F*    ADIFIX - Rename PLDPCD as different definition in INVTPD      *
     F*             from FDDTSTPD and SDLOANPD                           *
     F*    ULX024 - Trade Innovation/CSSF Reporting Interface            *
     F*    ULX011 - IML Circular 97/138                                  *
     F*    ULX004 - Capital Adequacy                                     *
     F*             To run temporary IML and CAD together.               *
     F*    ER0449 - INCLUDE FIDUCIARY LOANS AND FIDUCIARY DEPOSITS       *
     F*    ERL436 - INCLUDE DISCRETIONARY CUSTOMER ASSETS PROCESSING     *
     F*    ERL415 - IML CODES 1.1 VALIDATION                             *
     F*    ERL386 - INCLUDE CUSTOMER POSITIONS PROCESSING                *
     F*    ERL354 - INCLUDE DEPOT MOVEMENTS PROCESSING                   *
     F*    ER0324 - Extract records if Deal Date reached                 *
     F*    ER0323 - INCLUDE COMMERCIAL LOANS PROCESSING                  *
     F*    ER0314 - SETUP NARRATIVE FIELD TO BLANK                       *
     F*    ERL200 - NEW SUBFILE PROCESSING                               *
     F*    ER0101 - Decision Key length from 6 to 8                      *
     F*           - Instrument Type Key format is changed from 'INSTR '  *
     F*             (inst-type) ) to 'BKINSTRP' (book/inst_type/put_call)*
     F*             (add the new message ERB4011 in xxERUSRMSG)          *
     F*    ER0100 - Missing Deal Types (completetion of fix ER1008)      *
     F*****************************************************************
     F*
     FERPRDCPD  IF   E           K DISK                                         ULX011
      *                                                                   ULX011
     F*ERLU11PD* IF   E           K DISK                                         ERL415     MD058079
     F*                                                                   ERL415
     FERLUTTL0  UF A E           K DISK    COMMIT
     F                                     RENAME(ERLUTTD0:UPERLUTT)
     FERLUTTL1  IF   E           K DISK
     F*
     F******SDBANKPDIF  E           K        DISK                         ULX004
     F*
     FSDBOOKL0  IF   E           K DISK
     F*
     F*DDLSTL1IF  E           K        DISK                               165675
     FSDDLSTL1  IF   E           K DISK                                         ULX047
     F*
     FFDDTSTL1  IF   E           K DISK                                         165675
     F*** 'DL' ***
     F*
     FSDLOANL1  IF   E           K DISK
     F*** 'LE' ***
     F*
     FSDFACTL1  IF   E           K DISK
     F*** 'FC' ***
     F*
     FINVTO     IF   E           K DISK
     F*** 'IV' ***
     F*
     F******INTYP   IF  E           K        DISK                         ULX004
     F*** 'IT' ***
     FERTIPTL0  IF   E           K DISK                                         ULX024
      ***  Midas TI Product Code/Type Combination Table                   ULX024
      *                                                                   ULX024
     FERTIPCPD  IT   F   39        DISK                                         ULX024
      *                                                                   ULX024
     F*
     FERLU40DF  CF   E             WORKSTN
     F                                     SFILE(ERLU40S1:RRN)
     D*****************************************************************
     D******              PROD   18  52  4 0                       ULX004 ULX011
     D PORT            S              1    DIM(10) CTDATA PERRCD(10)                             ULX
     D ARR             S              1    DIM(30)                              ARRAY FOR LENGHT
     D* ARRAY FOR DEAL TYPES
     D******              ARDL   22  22  2                                ER0100
     D ARDL            S              2    DIM(36) CTDATA PERRCD(36)                             ER0
     D ARDP1           S              2    DIM(6) CTDATA PERRCD(6)                               ERL
     D ARDP2           S             17    DIM(6) CTDATA PERRCD(2)                               ERL
     D*
     D********************ARCP    1   1 30                          ERL386ERL436
     D ARCP            S             30    DIM(2) CTDATA PERRCD(1)                               ERL
     D TABIT1          S              8    DIM(22) CTDATA PERRCD(1)             * IT Narratives  ULX
     D TABIT2          S             30    DIM(22) ALT(TABIT1)
     D AMTY            S              2    DIM(33) CTDATA PERRCD(33)                             ULX
     D AMTY2           S              2    DIM(33) CTDATA PERRCD(33)                             ULX
     D****ERTIPCPD        CODE    1  30  4   NARR   35                                        CER001
     D CODE            S              4    DIM(70) FROMFILE(ERTIPCPD) PERRCD(1)
     D NARR            S             35    DIM(70) ALT(CODE)
     D* PROGRAM DATA STRUCTURE
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
     D*
     D LDA            UDS           256
     D  DBFILE               132    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D***
     D                 DS
     D  DHNARA                 1     30
     D  DHEXTT                31     31
     D  DHDEBI                32     39
     D  DHCRED                40     47
     D***************************************48  48 DHAMTY                ULX004
     D****************************************1  48 SELEC1                ULX004
     D******                                 48  51 DHPRCD                ULX011
     D******                                 52  52 DHPORT                ULX011
     D******                                  1  52 SELEC1                ULX011
     D*D***                                  48  48 DHAMTY        ULX011  ULX046
     D*D***                                  49  52 DHPRCD        ULX011  ULX046
     D*D***                                  53  53 DHPORT        ULX011  ULX046
     D*D***                                   1  53 SELEC1        ULX011  ULX046
     D  DHAMTY                48     49                                         ULX046
     D  DHPRCD                50     53                                         ULX046
     D  DHPORT                54     54                                         ULX046
     D  SELEC1                 1     54                                         ULX046
     D***
     D                 DS
     D  WWNARA                 1     30
     D  WWEXTT                31     31
     D  WWDEBI                32     39
     D  WWCRED                40     47
     D***************************************48  48 WWAMTY                ULX004
     D****************************************1  48 SELEC2                ULX004
     D******                                 48  51 WWPRCD                ULX011
     D******                                 52  52 WWPORT                ULX011
     D******                                  1  52 SELEC2                ULX011
     D*D***                                  48  48 WWAMTY         ULX011 ULX046
     D*D***                                  49  52 WWPRCD         ULX011 ULX046
     D*D***                                  53  53 WWPORT         ULX011 ULX046
     D*D***                                   1  53 SELEC2         ULX011 ULX046
     D  WWAMTY                48     49                                         ULX046
     D  WWPRCD                50     53                                         ULX046
     D  WWPORT                54     54                                         ULX046
     D  SELEC2                 1     54                                         ULX046
     D***
     D                 DS
     D  DSMOD                  1      2
     D******                                  3   8 DSTYPE                ER0102
     D**********                              3  10 DSTYPE                             ER0102 CER001
     D  DSTYPE                 3     16
     D  DSTYP1                 3      4
     D  DSTYP2                 5      6
     D  DSTYP3                 7      7                                         ER0324
     D  DSTYP4                 8      8                                         ER0324
     D  DSTYP5                 5      5                                         ULX004
     D  DSTYP6                 6      6                                         ULX004
     D  DSTYP7                 7     10                                         ULX004
     D  DSTYP8                 8     11
     D******                                  1   8 DSKEY                 ER0102
     D**********                              1  10 DSKEY                              ER0102 CER001
     D  DSKEY                  1     16
     D***
     D                 DS
     D  DHMOD                  1      2
     D******                                  3   8 DHTYPE                ER0102
     D**********                              3  10 DHTYPE                             ER0102 CER001
     D  DHTYPE                 3     16
     D******                                  1   8 DHKEY                 ER0102
     D**********                              1  10 DHKEY                              ER0102 CER001
     D  DHKEY                  1     16
     D***
     D                 DS
     D  WWMOD                  1      2
     D******                                  3   8 WWTYPE                ER0102
     D**********                              3  10 WWTYPE                             ER0102 CER001
     D  WWTYPE                 3     16
     D******                                  1   8 WWKEY                 ER0102
     D**********                              1  10 WWKEY                              ER0102 CER001
     D  WWKEY                  1     16
      *                                                                   ULX004
      **  External DS for Bank Details                                    ULX004
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    ULX004
      *                                                                                       CER001
      ** External DS for SAR details                                                          CER001
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *                                                                   ULX004
      * First DS for access programs, SHORT DATA STRUCTURE                ULX004
     D DSFDY         E DS                  EXTNAME(DSFDY)                       ULX004
      *                                                                   ULX004
      * Second DS dor access programs, LONG DATA STRUCTURE                ULX004
     D DSSDY         E DS                  EXTNAME(DSSDY)                       ULX004
     D*
     D ERLU11        E DS                  EXTNAME(ERL11JW0)                                MD058079
     D**  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION:
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     I*****************************************************************
     IINVTPDF                                                                   ADIFIX
      ** Rename PLDPCD waiting for a core correction                      ADIFIX
      *                                                                   ADIFIX
     I              PLDPCD                      IVDPCD                          ADIFIX
     I*
     C**************************************************************************
     C* MAIN PROCESSING                                                        *
     C**************************************************************************
     C* CALL INIT SUBROUTINE
     C**************************************************************************
     C     ERKEY1        KLIST
     C                   KFLD                    DSMOD
     C                   KFLD                    DSTYPE
     C*
     C     ERKEY2        KLIST
     C                   KFLD                    DHMOD
     C                   KFLD                    DHTYPE
     C*
     C     ERKUP         KLIST                                                                 ERL20
     C                   KFLD                    UPMOD             2                           ERL20
     C**********           KFLD           UPTYP   8                                    ERL200 CER001
     C                   KFLD                    UPTYP            14
     C*                                                                   ERL200
     C     KEY4          KLIST
     C                   KFLD                    DSTYP1
     C                   KFLD                    DSTYP2
     C                   KFLD                    DSTYP8
      *                                                                                       CER001
     C     KEY5          KLIST
     C                   KFLD                    DSTYP1
     C                   KFLD                    DSTYP2
     C                   KFLD                    DSTYP8
     C*
     C     *ENTRY        PLIST
     C                   PARM                    ACTION            1
     C                   PARM                    #RETRN            1
     C                   PARM                    CTRY              2
      *                                                                   ULX004
     C                   MOVE      *BLANKS       @RTCD             7            * AO Parameter ULX00
     C                   MOVE      *BLANKS       @OPTN             7            * AO Paramrter ULX00
     C*
     C                   EXSR      INIT                                         INITIATION
     C*
     C                   EXSR      MAIN
     C*
     C** SETUP RETURN CODE
     C     *INKC         IFEQ      '1'
     C                   MOVE      '3'           #RETRN
     C                   END
     C*
     C** END OF PGM
     C                   MOVE      '1'           *INLR
     C                   ROLBK
     C*
     C                   RETURN
     C**************************************************************************
     C** MAIN - MAIN SUBROUTINE
     C**************************************************************************
     C*
     C     MAIN          BEGSR
     C*
     C** ' ADD MODE ' ON FIRST CYCLE
     C     *IN09         IFNE      '1'                                          - B1
     C*
     C                   EXSR      INISFL                                       INIT. SUBFILE
     C                   EXSR      LOASFE                                       LOAD SUBFILE ENQUIRY
     C                   Z-ADD     1             RRN
     C*
     C                   END                                                    - E1
     C*
     C* DO WHILE NOT F3 OR F12 PRESSED
     C     *INKC         DOWEQ     '0'                                          - B1
     C     *IN12         ANDEQ     '0'
     C*
     C                   MOVE      SELEC1        SELEC2
     C*
     C** RESET F9 INDICATOR
     C                   MOVE      '0'           *IN16
     C*
     C* WRITE SUBFILE
     C     *IN09         IFNE      '1'                                          - B2
     C*
     C                   WRITE     ERLU40C0                                     BOTTOM
     C                   EXFMT     ERLU40C1                                     SUBFILE
     C*
     C** CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
     C*                                                                   ERL200
     C** WICH KEY HAS BEEN PRESSED                                        ERL200
     C                   EXSR      PRESS                                                       ERL20
     C*                                                                   ERL200
     C     WWAID         IFEQ      'UP'                                         - B3           ERL20
     C                   Z-ADD     WWRRN         RRN                                           ERL20
     C                   EXSR      LOASFE                                                      ERL20
     C                   END                                                    - E3           ERL20
     C*                                                                   ERL200
     C                   END                                                    - E2
     C*
     C**************************************************************************
     C** F9 HAS BEEN PRESSED
     C**************************************************************************
     C     *IN09         IFEQ      '1'                                          - B2
     C                   EXSR      SRF9
     C                   MOVE      SELEC1        SELEC2
     C     *INKC         IFEQ      '1'                                          - B3
     C                   MOVE      '0'           *IN16
     C                   END                                                    - E3
     C                   END                                                    - E2
     C**************************************************************************
     C** ENTER HAS BEEN PRESSED
     C**************************************************************************
     C     *IN45         IFEQ      '0'                                          - B2
     C     *IN16         ANDEQ     '0'
     C*
     C     *IN45         IFEQ      '0'                                          - B3
     C     DHKEY         ANDNE     WWKEY
     C     *IN45         OREQ      '0'
     C     SELEC1        ANDNE     SELEC2
     C                   EXSR      INISFL
     C                   EXSR      LOASFE
     C                   Z-ADD     1             RRN
     C                   END                                                    - E3
     C*
     C** CHECK IF CHANGES IN SUBFILE
     C                   EXSR      SRCHCK
     C*
     C                   END                                                    - E2
     C**************************************************************************
     C** F5 HAS BEEN PRESSED : REFRESH PROCESSING ==> REBUILD SUBFILE
     C** OR BACK FROM F9 SCREEN WITH F9 OR F12
     C**************************************************************************
     C                   MOVE      *BLANKS       IN16
     C     *IN05         IFEQ      '1'                                          - B2
     C     *IN16         OREQ      '1'
     C                   MOVE      'Y'           IN16              1
     C                   MOVE      '0'           *IN16
     C                   MOVE      *BLANKS       DHKEY
     C                   MOVE      *BLANKS       DHNARA
     C                   MOVE      *BLANKS       DHEXTT
     C                   MOVE      *BLANKS       DHDEBI
     C                   MOVE      *BLANKS       DHCRED
     C*********************MOVE *BLANKS   DHAMTY                          ULX004
     C                   MOVE      *BLANKS       DHAMTY                                        ULX01
     C                   MOVE      *BLANKS       DHPRCD                                        ULX00
     C                   MOVE      *BLANKS       DHPORT                                        ULX00
     C*
     C                   EXSR      INISFL
     C                   EXSR      LOASFE
     C                   Z-ADD     1             RRN
     C                   MOVE      *BLANKS       IN16
     C                   END                                                    - E2
     C*
     C                   END                                                    - E1
     C*
     C                   ENDSR
     C*
     C**************************************************************************
     C* SRF9 - SUBROUTINE EXECUTED IF F9 PRESSED
     C**************************************************************************
     C*
     C     SRF9          BEGSR
     C*
     C                   MOVE      '1'           *IN16
     C*
     C                   EXSR      INISFL
     C                   EXSR      LOASF9
     C                   Z-ADD     1             RRN
     C*
     C     *INKC         DOWEQ     '0'                                          - B1
     C     *IN12         ANDEQ     '0'
     C*
     C* WRITE SUBFILE 'F9'
     C                   WRITE     ERLU40C0                                     BOTTOM
     C                   EXFMT     ERLU40C1                                     SUBFILE
     C*
     C** CLEAR MESSAGES FROM PROGRAM MESSAGE QUEUE
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
     C*
     C** F9 PRESSED ONCE AGAIN = F12 IS SETON
     C     *IN09         IFEQ      '1'                                          - B2
     C                   MOVE      '1'           *IN12
     C                   MOVE      '0'           *IN09
     C                   END                                                    - E2
     C*
     C** ENTER HAS BEEN PRESSED ON 'F9' SCREEN
     C     *IN45         IFEQ      '0'                                          - B2
     C                   READC     ERLU40S1                               32
     C*
     C     *IN32         DOWEQ     '0'                                          - B3
     C*
     C                   MOVE      '0'           *IN15
     C                   MOVE      '0'           *IN22
     C                   MOVE      '0'           *IN23
     C                   MOVE      '0'           *IN24
     C                   MOVE      '0'           *IN25
     C                   MOVE      '0'           *IN26
     C                   MOVE      '0'           *IN27
     C                   MOVE      '0'           *IN28                                         ULX00
     C                   MOVE      '0'           *IN29                                         ULX01
     C                   MOVE      '0'           *IN63
     C                   MOVE      *BLANKS       DSNARA
     C*
     C** VALIDATION ON 'ADD' MODE
     C*
     C** ALREADY EXISTS ON FILE
     C     ERKEY1        CHAIN     ERLUTTL1                           88
     C     *IN88         IFEQ      '0'                                          - B4
     C                   MOVE      '1'           *IN22
     C                   MOVE      '1'           *IN23
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB4001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    - E4
     C*
     C** MODULE IDENTIFIER
     C     DSMOD         IFNE      'DL'                                         - B4
     C     DSMOD         ANDNE     'LE'
     C     DSMOD         ANDNE     'FC'
     C     DSMOD         ANDNE     'IV'
     C     DSMOD         ANDNE     'IT'
     C     DSMOD         ANDNE     'CL'                                                        ER032
     C     DSMOD         ANDNE     'DP'                                                        ERL35
     C     DSMOD         ANDNE     'CP'                                                        ERL38
     C     DSMOD         ANDNE     'DA'                                                        ERL43
     C     DSMOD         ANDNE     'FD'                                                        ER044
     C     DSMOD         ANDNE     'FL'                                                        ER044
     C     DSMOD         ANDNE     'TI'                                                        ULX02
     C                   MOVE      '1'           *IN22
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB4002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   - X4
     C*
     C     DSMOD         IFEQ      'DL'                                         - B5
     C     DSMOD         OREQ      'CL'                                                        ER032
     C*
     C** VALIDATION DEAL TYPE
     C*
     C     DSMOD         IFEQ      'DL'                                         - B7           ER032
     C     DSTYP1        LOOKUP    ARDL                                   50
     C     *IN50         IFEQ      '0'                                          - B6
     C                   MOVE      '1'           *IN23
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB4006'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    - E6
     C                   END                                                    - E7           ER032
     C*
     C** TEST LOAN TYPE FOR COMMERCIAL LOANS                              ER0323
     C     DSMOD         IFEQ      'CL'                                         - B6           ER032
     C     DSTYP1        IFNE      'TE'                                         - B7           ER032
     C     DSTYP1        ANDNE     'RC'                                                        ER032
     C     DSTYP1        ANDNE     'DS'                                                        ER032
     C                   MOVE      '1'           *IN23                                         ER032
     C                   MOVE      '1'           *IN63                                         ER032
     C                   MOVEL     'ERB4006'     ZAMSID                                        ER032
     C                   EXSR      ZASNMS                                                      ER032
     C                   END                                                    - E7           ER032
     C                   END                                                    - E6           ER032
     C*
     C** VALIDATION DEAL SUB-TYPE
     C*
     C***        DSTYP2    CHAINSDDLSTL1             88                   165675
     C     DSTYP1        IFNE      'FR'                                         - B61          ULX04
     C     DSTYP1        ANDNE     'RS'                                                        ULX04
     C     DSTYP1        ANDNE     'RX'                                                        ULX04
     C     DSTYP1        ANDNE     'RR'                                                        ULX04
     C     DSTYP1        ANDNE     'RP'                                                        ULX04
     C     DSTYP1        ANDNE     'RF'                                                        ULX04
     C********** KEY4      CHAINFDDTSTL1             88                                165675 CER001
     C     KEY5          CHAIN     FDDTSTL1                           88
     C     *IN88         IFEQ      '1'                                          - B6
     C                   MOVE      '1'           *IN23
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB4003'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF                                                  - E6           ULX04
     C                   ELSE                                                   - X61          ULX04
     C     DSTYP2        CHAIN     SDDLSTL1                           88                       ULX04
     C     *IN88         IFEQ      '1'                                          - B6           ULX04
     C                   MOVE      '1'           *IN23                                         ULX04
     C                   MOVE      '1'           *IN63                                         ULX04
     C                   MOVEL     'ERB4003'     ZAMSID                                        ULX04
     C                   EXSR      ZASNMS                                                      ULX04
     C                   ENDIF                                                  - E6           ULX04
     C                   ENDIF                                                  - E61          ULX04
     C*********************ELSE                            - X6           ULX047
     C*
     C***FOUR*LAST*POSITIONS*MUST*BE*LEFT*BLANK                    ER0102 ER0324
     C*
     C******               MOVE DSTYPE    BLANK4  4                ER0102 ER0324
     C******     BLANK4    IFNE *BLANKS                    - B7    ER0102 ER0324
     C*                                                                   ER0324
     C******               MOVE '1'       *IN23                           ER0324
     C******               MOVE '1'       *IN63                           ER0324
     C******               MOVEL'ERB4009' ZAMSID                          ER0324
     C******               EXSR ZASNMS                                    ER0324
     C******               ELSE                            - X7           ER0324
     C******               MOVELASDSTN    DSNARA                          ER0324
     C******               END                             - E7           ER0324
     C*                                                                   ER0324
     C** THREE OR FOUR LAST POSITIONS MUST BE LEFT BLANK                  ER0324
     C*                                                                   ER0324
     C     *IN88         IFEQ      *OFF                                                        ULX04
     C*                                                                   ULX047
     C     DSTYP3        IFEQ      'O'                                          - B7           ER032
     C                   MOVE      DSTYPE        BLANK3            3                           ER032
     C*                                                                   ER0324
     C     BLANK3        IFNE      *BLANKS                                      - B8           ER032
     C                   MOVE      '1'           *IN23                                         ER032
     C                   END                                                    - E8           ER032
     C*                                                                   ER0324
     C                   ELSE                                                   - X7           ER032
     C*                                                                   ER0324
     C                   MOVE      DSTYPE        BLANK4            4                           ER032
     C*                                                                   ER0324
     C     BLANK4        IFNE      *BLANKS                                      - B8           ER032
     C                   MOVE      '1'           *IN23                                         ER032
     C                   END
     C*                                                                   ER0324
     C                   END                                                    - E7           ER032
     C*                                                                   ER0324
     C     *IN23         IFEQ      '1'                                          - B7           ER032
     C                   MOVE      '1'           *IN63                                         ER032
     C                   MOVEL     'ERB4009'     ZAMSID                                        ER032
     C                   EXSR      ZASNMS                                                      ER032
     C                   ELSE                                                   - X7           ER032
     C****                 MOVELASDSTN    DSNARA                          ER0324
     C     DSTYP1        IFNE      'FR'                                         - B8           ULX04
     C     DSTYP1        ANDNE     'RS'                                                        ULX04
     C     DSTYP1        ANDNE     'RX'                                                        ULX04
     C     DSTYP1        ANDNE     'RR'                                                        ULX04
     C     DSTYP1        ANDNE     'RP'                                                        ULX04
     C     DSTYP1        ANDNE     'RF'                                                        ULX04
     C                   MOVEL     NARR11        DSNARA                                        16567
     C                   ELSE                                                                  ULX04
     C                   MOVEL     ASDSTN        DSNARA                                        ULX04
     C                   END                                                    - E8           ULX04
     C                   END                                                    - E7           ER032
     C*                                                                   ER0324
     C*
     C                   END                                                    - E6
     C*
     C                   END                                                    - E5
      *                                                                                       CER001
      ** Deal Class required                                                                  CER001
      *                                                                                       CER001
     C     CDL038        IFEQ      'Y'
     C     DSMOD         IFEQ      'DL'
     C     DSMOD         OREQ      'FD'
     C     DSMOD         OREQ      'FL'
     C     DSTYP8        IFEQ      *BLANK
     C                   MOVE      '1'           *IN23
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB4020'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     KEY5          CHAIN     FDDTSTL1                           88
     C     *IN88         IFEQ      '1'
     C                   MOVE      '1'           *IN23
     C                   MOVE      '1'           *IN63
     C**********           MOVEL'ERB4003' ZAMSID                                     CER001 BUG10452
     C                   MOVEL     'ERB4021'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*
     C     DSMOD         IFEQ      'LE'                                         - B5
     C     CLE042        IFEQ      'Y'                                          - B51
     C     DSTYP8        ANDEQ     *BLANK
     C                   MOVE      '1'           *IN23
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB4021'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   - X51
     C     KEY4          CHAIN     SDLOANL1                           88
     C     *IN88         IFEQ      '1'                                          - B6
     C                   MOVE      '1'           *IN23
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB4004'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   - X6
     C*
     C***FOUR*LAST*POSITIONS*MUST*BE*LEFT*BLANK                    ER0102 ER0324
     C*
     C******               MOVE DSTYPE    BLANK4  4                ER0102 ER0324
     C******     BLANK4    IFNE *BLANKS                    - B7    ER0102 ER0324
     C*                                                                   ER0324
     C******               MOVE '1'       *IN23                           ER0324
     C******               MOVE '1'       *IN63                           ER0324
     C******               MOVEL'ERB4009' ZAMSID                          ER0324
     C******               EXSR ZASNMS                                    ER0324
     C******               ELSE                            - X7           ER0324
     C******               MOVELAYLNTD    DSNARA                          ER0324
     C******               END                             - E7           ER0324
     C*                                                                   ER0324
     C** THREE OR FOUR LAST POSITIONS MUST BE LEFT BLANK                  ER0324
     C*                                                                   ER0324
     C     DSTYP3        IFEQ      'O'                                          - B7           ER032
     C                   MOVE      DSTYPE        BLANK3            3                           ER032
     C*                                                                   ER0324
     C     BLANK3        IFNE      *BLANKS                                      - B8           ER032
     C                   MOVE      '1'           *IN23                                         ER032
     C                   END                                                    - E8           ER032
     C*                                                                   ER0324
     C                   ELSE                                                   - X7           ER032
     C*                                                                   ER0324
     C                   MOVE      DSTYPE        BLANK4            4                           ER032
     C*                                                                   ER0324
     C     BLANK4        IFNE      *BLANKS                                      - B8           ER032
     C                   MOVE      '1'           *IN23                                         ER032
     C                   END                                                    - E8           ER032
     C*                                                                   ER0324
     C                   END                                                    - E7           ER032
     C*                                                                   ER0324
     C     *IN23         IFEQ      '1'                                          - B7           ER032
     C                   MOVE      '1'           *IN63                                         ER032
     C                   MOVEL     'ERB4009'     ZAMSID                                        ER032
     C                   EXSR      ZASNMS                                                      ER032
     C                   ELSE                                                   - X7           ER032
     C                   MOVEL     AYLNTD        DSNARA                                        ER032
     C                   END                                                    - E7           ER032
     C*
     C                   END                                                    - E6
     C*
     C                   END                                                    - E51
     C                   END                                                    - E5
     C*
     C     DSMOD         IFEQ      'FC'                                         - B5
     C                   MOVEL     DSTYPE        KEY3
     C     KEY3          CHAIN     SDFACTL1                           88
     C     *IN88         IFEQ      '1'                                          - B6
     C                   MOVE      '1'           *IN23
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB4005'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   - X6
     C*
     C** FIVE LAST POSITIONS MUST BE LEFT BLANK                           ER0102
     C*
     C                   MOVE      DSTYPE        BLANK5            5                           ER010
     C     BLANK5        IFNE      *BLANKS                                      - B7           ER010
     C                   MOVE      '1'           *IN23
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB4005'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   - X7
     C                   MOVEL     AMFCNM        DSNARA
     C                   END                                                    - E7
     C*
     C                   END                                                    - E6
     C*
     C                   END                                                    - E5
     C*
     C     DSMOD         IFEQ      'IV'                                         - B5
     C                   MOVEL     DSTYPE        IVKY12            5
     C                   MOVEL     IVKY12        IVKY1             3
     C                   MOVE      IVKY12        KBOOK             2
     C     IVKY1         CHAIN     INVTO                              88
     C     *IN88         IFEQ      '1'                                          - B6
     C                   MOVE      '1'           *IN23
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB4007'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE                                                   - X6
     C                   MOVEL     INAM          DSNARA
     C                   END                                                    - E6
     C*
     C     KBOOK         CHAIN     SDBOOKL0                           88
     C     *IN88         IFEQ      '1'                                          - B6
     C                   MOVE      '1'           *IN23
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB4010'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    - E6
     C*
     C***THREE*LAST*POSITION*MUST*BE*LEFT*BLANK                    ER0102 ER0324
     C*
     C******               MOVE DSTYPE    BLANK3  3                ER0102 ER0324
     C******     BLANK3    IFNE *BLANKS                    - B6    ER0102 ER0324
     C*                                                                   ER0324
     C******               MOVE '1'       *IN23                           ER0324
     C******               MOVE '1'       *IN63                           ER0324
     C******               MOVEL'ERB4007' ZAMSID                          ER0324
     C******               EXSR ZASNMS                                    ER0324
     C******               END                             - E6           ER0324
     C*                                                                   ER0324
     C** TWO OR THREE LAST POSITIONS MUST BE LEFT BLANK                   ER0324
     C*                                                                   ER0324
     C     DSTYP4        IFEQ      'O'                                          - B6           ER032
     C                   MOVE      DSTYPE        BLANK2            2                           ER032
     C*                                                                   ER0324
     C     BLANK2        IFNE      *BLANKS                                      - B7           ER032
     C                   MOVE      '1'           *IN23                                         ER032
     C                   END                                                    - E7           ER032
     C*                                                                   ER0324
     C                   ELSE                                                   - X6           ER032
     C*                                                                   ER0324
     C                   MOVE      DSTYPE        BLANK3            3                           ER032
     C*                                                                   ER0324
     C     BLANK3        IFNE      *BLANKS                                      - B7           ER032
     C                   MOVE      '1'           *IN23                                         ER032
     C                   END                                                    - E7           ER032
     C*                                                                   ER0324
     C                   END                                                    - E6           ER032
     C*                                                                   ER0324
     C     *IN23         IFEQ      '1'                                          - B6           ER032
     C                   MOVE      '1'           *IN63                                         ER032
     C                   MOVEL     'ERB4007'     ZAMSID                                        ER032
     C                   EXSR      ZASNMS                                                      ER032
     C                   END                                                    - E6           ER032
     C*                                                                   ER0324
     C*
     C                   END                                                    - E5
     C*                                                                   ER0102
     C** For Instruments, the key must have the format:                   ER0102
     C**  - 2A: Book Code                                                 ER0102
     C**  - 1A: Instrument Processing Type (1-8)                          ULX004
     C**  - 1A: OTC-Market Indicator (Y-OTC or N-Market Traded)           ULX004
     C**  - 4A: *blanks                                                   ULX004
     C**  - 5A: Instrument Type ********************************** ER0102 ULX004
     C**  - 2A: Call or Put indicator equal to 'P', 'C', or leave bER0102 ULX004
     C*                                                                   ER0102
     C     DSMOD         IFEQ      'IT'                                         - B5           ER010
     C                   MOVEL     DSTYPE        KBOOK                                         ER010
     C**********           MOVELDSTYPE    ITKEY7  7                ER0102 ULX004
     C**********           MOVE ITKEY7    ITKEY   5                ER0102 ULX004
     C**********           MOVE DSTYPE    CALPUT  1                ER0102 ULX004
     C********** ITKEY     CHAININTYP                88            ER0102 ULX004
     C********** *IN88     IFEQ '1'                        - B6    ER0102 ULX004
     C**********           MOVE '1'       *IN23                    ER0102 ULX004
     C**********           MOVE '1'       *IN63                    ER0102 ULX004
     C**********           MOVEL'ERB4008' ZAMSID                   ER0102 ULX004
     C**********           EXSR ZASNMS                             ER0102 ULX004
     C**********           ELSE                            - X6    ER0102 ULX004
     C**********           MOVELISTN      DSNARA                   ER0102 ULX004
     C**********           END                             - E6    ER0102 ULX004
     C*                                                                   ER0102
     C     KBOOK         CHAIN     SDBOOKL0                           88                       ER010
     C     *IN88         IFEQ      '1'                                          - B6           ER010
     C                   MOVE      '1'           *IN23                                         ER010
     C                   MOVE      '1'           *IN63                                         ER010
     C                   MOVEL     'ERB4010'     ZAMSID                                        ER010
     C                   EXSR      ZASNMS                                                      ER010
     C                   END                                                    - E6           ER010
     C*                                                                   ER0102
     C********** CALPUT    IFNE 'P'                        - B6    ER0102 ULX004
     C********** CALPUT    ANDNE'C'                        - B6    ER0102 ULX004
     C********** CALPUT    ANDNE' '                        - B6    ER0102 ULX004
     C**********           MOVE '1'       *IN23                    ER0102 ULX004
     C**********           MOVE '1'       *IN63                    ER0102 ULX004
     C**********           MOVEL'ERB4011' ZAMSID                   ER0102 ULX004
     C**********           EXSR ZASNMS                             ER0102 ULX004
     C**********           END                             - E6    ER0102 ULX004
     C*                                                                   ER0102
      ** Validate Instrument Processing Type within Transaction           ULX004
      **   Type key                                                       ULX004
      *                                                                   ULX004
     C     DSTYP5        IFLT      '1'                                          *-----6        ULX00
     C     DSTYP5        ORGT      '8'                                                         ULX00
     C                   MOVE      '1'           *IN23                                         ULX00
     C                   MOVE      '1'           *IN63                                         ULX00
     C                   MOVEL     'ERL4031'     ZAMSID                                        ULX00
     C                   EXSR      ZASNMS                                                      ULX00
     C                   ENDIF                                                  *-----6        ULX00
      *                                                                   ULX004
      ** Validate OTC-Market Indicator within Transaction Type key        ULX004
      *                                                                   ULX004
     C     DSTYP6        IFNE      'Y'                                          *-----6        ULX00
     C     DSTYP6        ANDNE     'N'                                                         ULX00
     C                   MOVE      '1'           *IN23                                         ULX00
     C                   MOVE      '1'           *IN63                                         ULX00
     C                   MOVEL     'ERL4032'     ZAMSID                                        ULX00
     C                   EXSR      ZASNMS                                                      ULX00
     C                   ENDIF                                                  *-----6        ULX00
      *                                                                   ULX004
      ** Validate remainder of Transaction Type key                       ULX004
      *                                                                   ULX004
     C     DSTYP7        IFNE      *BLANKS                                      *-----6        ULX00
     C                   MOVE      '1'           *IN23                                         ULX00
     C                   MOVE      '1'           *IN63                                         ULX00
     C                   MOVEL     'ERL4030'     ZAMSID                                        ULX00
     C                   EXSR      ZASNMS                                                      ULX00
     C                   ENDIF                                                  *-----6        ULX00
      *                                                                   ULX004
      ** Validate Instrument Processing Type & OTC-Market Indicator       ULX004
      **   combination within Transaction Type key                        ULX004
      *                                                                   ULX004
     C     DSTYP6        IFEQ      'Y'                                          *-----6        ULX00
     C     DSTYP5        ANDNE     '4'                                                         ULX00
     C     DSTYP5        ANDNE     '5'                                                         ULX00
     C     DSTYP5        ANDNE     '6'                                                         ULX00
     C                   MOVE      '1'           *IN23                                         ULX00
     C                   MOVE      '1'           *IN63                                         ULX00
     C                   MOVEL     'ERL4033'     ZAMSID                                        ULX00
     C                   EXSR      ZASNMS                                                      ULX00
     C                   ENDIF                                                  *-----6        ULX00
      *                                                                   ULX004
      ** Build key to derive narrative for screen display                 ULX004
      *                                                                   ULX004
     C     *IN88         IFEQ      '0'                                          *-----6        ULX00
     C     DSTYP2        CAT(P)    BDHGIN        WW08A                          *create TABIT1 ULX00
     C     WW08A         LOOKUP    TABIT1        TABIT2                   99                   ULX00
      *                                                                   ULX004
     C     *IN99         IFEQ      '1'                                          *----7         ULX00
     C                   MOVE      TABIT2        DSNARA                         * IT Narrative ULX00
     C                   ELSE                                                   X----7         ULX00
     C                   MOVE      *BLANKS       DSNARA                                        ULX00
     C                   ENDIF                                                  *----7         ULX00
     C                   ELSE                                                   X-----6        ULX00
     C                   MOVE      *BLANKS       DSNARA                                        ULX00
     C                   ENDIF                                                  *-----6        ULX00
      *                                                                   ULX004
     C                   END                                                    - E5           ER010
     C*
     C     DSMOD         IFEQ      'DP'                                         - B5           ERL35
     C                   MOVEL     DSTYPE        DPTYP             2                           ERL35
     C     DPTYP         IFNE      'BL'                                         - B6           ERL35
     C     DPTYP         ANDNE     'BB'                                                        ERL35
     C     DPTYP         ANDNE     'RP'                                                        ERL35
     C     DPTYP         ANDNE     'RR'                                                        ERL35
     C     DPTYP         ANDNE     'PD'                                                        ERL35
     C     DPTYP         ANDNE     'PL'                                                        ERL35
     C                   MOVE      '1'           *IN23                                         ERL35
     C                   MOVE      '1'           *IN63                                         ERL35
     C*********************MOVEL'ERB4005' ZAMSID                   ERL354 ERL386
     C                   MOVEL     'ERB4012'     ZAMSID                                        ERL38
     C                   EXSR      ZASNMS                                                      ERL35
     C                   ELSE                                                   - X6           ERL35
     C*                                                                   ERL354
     C** SIX LAST POSITIONS MUST BE LEFT BLANK                            ERL354
     C*                                                                   ERL354
     C                   MOVE      DSTYPE        BLANK6            6                           ERL35
     C     BLANK6        IFNE      *BLANKS                                      - B7           ERL35
     C                   MOVE      '1'           *IN23                                         ERL35
     C                   MOVE      '1'           *IN63                                         ERL35
     C*********************MOVEL'ERB4005' ZAMSID                   ERL354 ERL386
     C                   MOVEL     'ERB4012'     ZAMSID                                        ERL38
     C                   EXSR      ZASNMS                                                      ERL35
     C                   ELSE                                                   - X7           ERL35
     C*                                                                   ERL354
     C** SETUP NARRATIVE FIELD                                            ERL354
     C                   Z-ADD     1             J                 1 0                         ERL35
     C     DPTYP         LOOKUP    ARDP1(J)                               99                   ERL35
     C                   MOVEL     ARDP2(J)      DSNARA                                        ERL35
     C                   END                                                    - E7           ERL35
     C*                                                                   ERL354
     C                   END                                                    - E6           ERL35
     C*                                                                   ERL354
     C                   END                                                    - E5           ERL35
     C*                                                                   ER0XXX
     C** PROCESSING FOR CUSTOMER POSITIONS                                ERL386
     C     DSMOD         IFEQ      'CP'                                         - B5           ERL38
     C*                                                                   ERL386
     C                   MOVEL     DSTYPE        CUSPOS            4                           ERL38
     C     CUSPOS        IFNE      'CPOS'                                       - B6           ERL38
     C                   MOVE      '1'           *IN23                                         ERL38
     C                   MOVE      '1'           *IN63                                         ERL38
     C                   MOVEL     'ERB4013'     ZAMSID                                        ERL38
     C                   EXSR      ZASNMS                                                      ERL38
     C                   ELSE                                                   - X6           ERL38
     C*                                                                   ERL386
     C** FOUR LAST POSITIONS MUST BE LEFT BLANK                           ERL386
     C                   MOVE      DSTYPE        BLANK4                                        ERL38
     C     BLANK4        IFNE      *BLANKS                                      - B7           ERL38
     C                   MOVE      '1'           *IN23                                         ERL38
     C                   MOVE      '1'           *IN63                                         ERL38
     C                   MOVEL     'ERB4013'     ZAMSID                                        ERL38
     C                   EXSR      ZASNMS                                                      ERL38
     C                   ELSE                                                   - X7           ERL38
     C                   MOVEL     ARCP(1)       DSNARA                                        ERL38
     C                   END                                                    - E7           ERL38
     C*                                                                   ERL386
     C                   END                                                    - E6           ERL38
     C*                                                                   ERL386
     C                   END                                                    - E5           ERL38
     C*                                                                   ERL386
     C** PROCESSING FOR DISCRETIONARY CUSTOMER ASSETS                     ERL436
     C     DSMOD         IFEQ      'DA'                                         - B5           ERL43
     C*                                                                   ERL436
     C                   MOVEL     DSTYPE        CUSPOS            4                           ERL43
     C     CUSPOS        IFNE      'DISC'                                       - B6           ERL43
     C                   MOVE      '1'           *IN23                                         ERL43
     C                   MOVE      '1'           *IN63                                         ERL43
     C                   MOVEL     'ERB4014'     ZAMSID                                        ERL43
     C                   EXSR      ZASNMS                                                      ERL43
     C                   ELSE                                                   - X6           ERL43
     C*                                                                   ERL436
     C** FOUR LAST POSITIONS MUST BE LEFT BLANK                           ERL436
     C                   MOVE      DSTYPE        BLANK4                                        ERL43
     C     BLANK4        IFNE      *BLANKS                                      - B7           ERL43
     C                   MOVE      '1'           *IN23                                         ERL43
     C                   MOVE      '1'           *IN63                                         ERL43
     C                   MOVEL     'ERB4014'     ZAMSID                                        ERL43
     C                   EXSR      ZASNMS                                                      ERL43
     C                   ELSE                                                   - X7           ERL43
     C                   MOVEL     ARCP(2)       DSNARA                                        ERL43
     C                   END                                                    - E7           ERL43
     C*                                                                   ERL436
     C                   END                                                    - E6           ERL43
     C*                                                                   ERL436
     C                   END                                                    - E5           ERL43
     C*                                                                   ERL436
     C** PROCESSING FOR FIDUCIARY LOANS AND DEPOSITS                      ER0449
     C     DSMOD         IFEQ      'FD'                                         - B5           ER044
     C     DSMOD         OREQ      'FL'                                                        ER044
     C*                                                                   ER0449
     C** FOR 'FD' TWO FIRST POSITIONS MUST BE 'FD' OR 'FL'                ER0449
     C     DSMOD         IFEQ      'FD'                                         - B6           ER044
     C*                                                                   ER0449
     C     DSTYP1        IFNE      'FD'                                         - B7           ER044
     C     DSTYP1        ANDNE     'FL'                                                        ER044
     C                   MOVE      '1'           *IN23                                         ER044
     C                   MOVE      '1'           *IN63                                         ER044
     C                   MOVEL     'ERB4003'     ZAMSID                                        ER044
     C                   EXSR      ZASNMS                                                      ER044
     C                   ELSE                                                   - X7           ER044
     C*                                                                   ER0449
     C** VALIDATION DEAL SUB-TYPE                                         ER0449
     C*                                                                   ER0449
     C*****      DSTYP2    CHAINSDDLSTL1             88             ER0449165675
     C********** KEY4      CHAINFDDTSTL1             88                                165675 CER001
     C     KEY5          CHAIN     FDDTSTL1                           88
     C     *IN88         IFEQ      '1'                                          - B8           ER044
     C                   MOVE      '1'           *IN23                                         ER044
     C                   MOVE      '1'           *IN63                                         ER044
     C                   MOVEL     'ERB4003'     ZAMSID                                        ER044
     C                   EXSR      ZASNMS                                                      ER044
     C                   ELSE                                                   - X8           ER044
     C*****                MOVELASDSTN    DSNARA                          ER0449
     C                   MOVEL     NARR11        DSNARA                                        16567
     C                   END                                                    - E8           ER044
     C                   END                                                    - E7           ER044
     C*                                                                   ER0449
     C                   ELSE                                                   - X6           ER044
     C*                                                                   ER0449
     C** FOR 'FL' ONLY VALIDATE LOAN TYPE/SUB-TYPE                        ER0449
     C     KEY4          CHAIN     SDLOANL1                           88                       ER044
     C     *IN88         IFEQ      '1'                                          - B7           ER044
     C                   MOVE      '1'           *IN23                                         ER044
     C                   MOVE      '1'           *IN63                                         ER044
     C                   MOVEL     'ERB4004'     ZAMSID                                        ER044
     C                   EXSR      ZASNMS                                                      ER044
     C                   ELSE                                                   - E7           ER044
     C                   MOVEL     AYLNTD        DSNARA                                        ER044
     C                   END                                                    - E7           ER044
     C*                                                                   ER0449
     C                   END                                                    - E6           ER044
     C*                                                                   ER0449
     C** FOUR LAST POSITIONS MUST BE LEFT BLANK FOR 'FD' OR 'FL'          ER0449
     C*                                                                   ER0449
     C                   MOVE      DSTYPE        BLANK4            4                           ER044
     C     BLANK4        IFNE      *BLANKS                                      - B6           ER044
     C*                                                                   ER0449
     C                   MOVE      '1'           *IN23                                         ER044
     C                   MOVE      '1'           *IN63                                         ER044
     C                   MOVEL     'ERB4009'     ZAMSID                                        ER044
     C                   EXSR      ZASNMS                                                      ER044
     C                   END                                                    - E6           ER044
     C*                                                                   ER0449
     C                   END                                                    - E5           ER044
     C*
     C*                                                                   ULX024
     C** Processing for Trade Innovation                                  ULX024
     C     DSMOD         IFEQ      'TI'                                         - B5           ULX02
      *                                                                   ULX024
      ** Work fields setup                                                ULX024
      *                                                                   ULX024
     C     4             SUBST     DSTYPE:1      WF3               4                           ULX02
     C     4             SUBST     DSTYPE:5      WF4               4                           ULX02
     C*          1         SUBSTDSTYPE:8  WF1     1                       ULX024
      *                                                                   ULX024
      ** Validation of the Product Type in first 4 positions              ULX024
      ** => Valid TI Product Type (Internal array)                        ULX024
      *                                                                   ULX024
     C                   Z-ADD     1             X                 2 0                         ULX02
     C     WF3           LOOKUP    CODE(X)                                99                   ULX02
      *                                                                   ULX024
     C     *IN99         IFEQ      '0'                                          - B6           ULX02
     C                   MOVE      '1'           *IN23                                         ULX02
     C                   MOVE      '1'           *IN63                                         ULX02
     C                   MOVEL     'ERB4015'     ZAMSID                                        ULX02
     C                   EXSR      ZASNMS                                                      ULX02
      *                                                                   ULX024
     C                   ELSE                                                   - X6           ULX02
     C                   MOVEA     NARR(X)       DSNARA                         - X6           ULX02
      *                                                                   ULX024
      ** Validation of the Product Type / CSSF Type Combination           ULX024
      **  (Positions 1-4+5-8)                                             ULX024
      ** => Valid Record in ERTIPTL0                                      ULX024
      *                                                                   ULX024
     C     KWF           KLIST                                                                 ULX02
     C                   KFLD                    WF3                                           ULX02
     C                   KFLD                    WF4                                           ULX02
      *                                                                   ULX024
     C     WF4           IFNE      *BLANKS                                      - B7           ULX02
     C     KWF           CHAIN     ERTIPTL0                           99                       ULX02
     C     *IN99         IFEQ      *ON                                          - B8           ULX02
     C                   MOVE      '1'           *IN23                                         ULX02
     C                   MOVE      '1'           *IN63                                         ULX02
     C                   MOVEL     'ERB4016'     ZAMSID                                        ULX02
     C                   EXSR      ZASNMS                                                      ULX02
     C                   ELSE                                                   - X8           ULX02
     C                   MOVEL     ERTIPD        DSNARA                                        ULX02
     C                   END                                                    - E8           ULX02
     C                   END                                                    - E7           ULX02
      *                                                                   ULX024
      ** Validation of last position                                      ULX024
      ** => Blank                                                         ULX024
      *                                                                   ULX024
     C*          WF1       IFNE *BLANK                     - B7           ULX024
     C*                    MOVE '1'       *IN23                           ULX024
     C*                    MOVE '1'       *IN63                           ULX024
     C*                    MOVEL'ERB4017' ZAMSID                          ULX024
     C*                    EXSR ZASNMS                                    ULX024
     C*                    ENDIF                           - E7           ULX024
     C*                                                                   ULX024
     C                   ENDIF                                                  - E6           ULX02
     C*                                                                   ULX024
     C                   ENDIF                                                  - E5           ULX02
     C*                                                                   ULX024
     C                   END                                                    - E4
     C*
     C     DSEXTT        IFEQ      *BLANKS                                      - B4
     C                   MOVE      'N'           DSEXTT
     C                   END                                                    - E4
     C*
     C                   EXSR      SRVAL
     C** NO ERRORS
     C     *IN23         IFEQ      '0'                                          - B4
     C     *IN22         ANDEQ     '0'
     C     *IN24         ANDEQ     '0'
     C     *IN25         ANDEQ     '0'                                                         ERL41
     C     *IN26         ANDEQ     '0'
     C     *IN27         ANDEQ     '0'
     C     *IN28         ANDEQ     '0'                                                         ULX00
     C     *IN29         ANDEQ     '0'                                                         ULX01
     C     DSKEY         ANDNE     *BLANKS
     C                   MOVE      DSMOD         VCMMOD
     C                   MOVE      DSTYPE        VCTTYP
     C*********************MOVE DSAMTY    VCAMTY                          ULX004
     C                   MOVE      DSAMTY        VCAMTY                                        ULX01
     C                   MOVE      DSPRCD        VCPRCD                                        ULX00
     C                   MOVE      DSPORT        VCPORT                                        ULX00
     C                   MOVE      DSEXTT        VCEXTT
     C                   MOVE      DSDEBI        VCRBND
     C                   MOVE      DSCRED        VCRBNC
     C                   Z-ADD     BJRDNB        VCLCD
     C                   MOVE      'I'           VCTYLC
     C                   WRITE     UPERLUTT
     C*
     C** WRITE DONE THEN PROTECT RECORD
     C*
     C                   MOVE      '1'           *IN15
     C*
     C                   COMMIT
     C                   END                                                    - E4
     C*
     C                   UPDATE    ERLU40S1
     C                   MOVE      '0'           *IN15
     C                   MOVE      '0'           *IN22
     C                   MOVE      '0'           *IN23
     C                   MOVE      '0'           *IN24
     C                   MOVE      '0'           *IN25
     C                   MOVE      '0'           *IN26
     C                   MOVE      '0'           *IN27
     C                   MOVE      '0'           *IN28                                         ULX00
     C                   MOVE      '0'           *IN29                                         ULX01
     C                   MOVE      '0'           *IN63
     C*
     C** READ NEXT CHANGED RECORD
     C*
     C                   READC     ERLU40S1                               32
     C*
     C                   ENDDO                                                  - E3
     C                   END                                                    - E2
     C*
     C** REFRESH ON F9 SCREEN
     C*
     C     *IN05         IFEQ      '1'                                          - B2
     C                   EXSR      INISFL
     C                   EXSR      LOASF9
     C                   Z-ADD     1             RRN
     C                   END                                                    - E2
     C*
     C                   END                                                    - E1
     C*
     C     *IN12         IFEQ      '1'
     C                   MOVE      '0'           *IN12
     C                   END
     C*
     C                   ENDSR
     C*
     C**************************************************************************
     C* SRCHCK - SUBROUTINE TO CHECK IF CHANGES IN SUBFILE
     C**************************************************************************
     C*
     C     SRCHCK        BEGSR
     C*
     C** Retrive all changed records
     C*
     C                   READC     ERLU40S1                               32
     C*
     C     *IN32         DOWEQ     '0'                                          - B1
     C*
     C** VALIDATION ON RECORD SUBFILE
     C*
     C                   MOVE      '0'           *IN63
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN24
     C                   MOVE      '0'           *IN25
     C                   MOVE      '0'           *IN26
     C                   MOVE      '0'           *IN27
     C                   MOVE      '0'           *IN28                                         ULX00
     C                   MOVE      '0'           *IN29                                         ULX01
     C*
     C     DSSELE        IFNE      'D'                                          - B2
     C     DSSELE        ANDNE     *BLANKS
     C                   MOVE      '1'           *IN20
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB3001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    - E2
     C*
     C                   EXSR      SRVAL
     C*
     C** NO ERRORS
     C*
     C     *IN20         IFEQ      '0'                                          - B2
     C     *IN24         ANDEQ     '0'
     C     *IN25         ANDEQ     '0'
     C     *IN26         ANDEQ     '0'
     C     *IN27         ANDEQ     '0'
     C     *IN28         ANDEQ     '0'                                                         ULX00
     C     *IN29         ANDEQ     '0'                                                         ULX01
     C*
     C** IF NO ERROR AND 'D' SELECTED ==> DELETE IN FILE
     C*
     C     DSSELE        IFEQ      'D'                                          - B3
     C     ERKEY1        CHAIN     ERLUTTL0                           88
     C     *IN88         IFEQ      '0'                                          - B4
     C                   DELETE    UPERLUTT
     C                   MOVE      '1'           *IN15
     C                   END                                                    - E4
     C                   ELSE                                                   - X3
     C*
     C** UPDATE FILE AND SUBFILE
     C*
     C     ERKEY1        CHAIN     ERLUTTL0                           88
     C     *IN88         IFEQ      '0'                                          - B4
     C*********************MOVE DSAMTY    VCAMTY                          ULX004
     C                   MOVE      DSAMTY        VCAMTY                                        ULX01
     C                   MOVE      DSPRCD        VCPRCD                                        ULX00
     C                   MOVE      DSPORT        VCPORT                                        ULX00
     C                   MOVE      DSEXTT        VCEXTT
     C                   MOVE      DSDEBI        VCRBND
     C                   MOVE      DSCRED        VCRBNC
     C                   Z-ADD     BJRDNB        VCLCD
     C                   MOVE      'A'           VCTYLC
     C                   UPDATE    UPERLUTT
     C                   END                                                    - E4
     C                   END                                                    - E3
     C                   COMMIT
     C                   END                                                    - E2
     C*
     C                   UPDATE    ERLU40S1
     C                   MOVE      '0'           *IN63
     C                   MOVE      '0'           *IN15
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN24
     C                   MOVE      '0'           *IN25
     C                   MOVE      '0'           *IN26
     C                   MOVE      '0'           *IN27
     C                   MOVE      '0'           *IN28                                         ULX00
     C                   MOVE      '0'           *IN29                                         ULX01
     C*
     C** READ NEXT CHANGED RECORD
     C*
     C                   READC     ERLU40S1                               32
     C*
     C                   ENDDO                                                  - E1
     C*
     C                   ENDSR
     C**************************************************************************
     C* INITIALIZE SUBFILE
     C**************************************************************************
     C*
     C     INISFL        BEGSR
     C*
     C                   MOVE      '0'           *IN80
     C                   MOVE      '0'           *IN81
     C                   WRITE     ERLU40C1
     C                   MOVE      '1'           *IN80
     C                   Z-ADD     0             RRN               4 0
     C*
     C                   ENDSR
     C*
     C**************************************************************************
     C* LOAD SUBFILE
     C**************************************************************************
     C*
     C     LOASFE        BEGSR
     C*
     C** IF SELECTION FIELD RESET TO BLANK BY USER ==> SELECT ALL RECORDS
     C*
     C     SELEC1        IFNE      SELEC2                                       - B1
     C     DHNARA        ANDEQ     *BLANKS
     C     DHEXTT        ANDEQ     *BLANKS
     C     DHDEBI        ANDEQ     *BLANKS
     C     DHCRED        ANDEQ     *BLANKS
     C***********DHAMTY    ANDEQ*BLANKS                                   ULX004
     C     DHAMTY        ANDEQ     *BLANKS                                                     ULX01
     C     DHPRCD        ANDEQ     *BLANKS                                                     ULX00
     C     DHPORT        ANDEQ     *BLANKS                                                     ULX00
     C                   MOVE      SELEC1        SELEC2
     C                   END                                                    - E1
      *                                                                   ULX046
      ** Format the selection field for amount type, to have correct      ULX046
      ** comparisons in the SELEC subroutine                              ULX046
      *                                                                   ULX046
     C     DHAMTY        IFNE      *BLANKS                                                     ULX04
     C                   Z-ADD     1             Y                                             ULX04
     C     DHAMTY        LOOKUP    AMTY(Y)                                83                   ULX04
     C   83              MOVEL     AMTY2(Y)      DHAMTY                                        ULX04
     C                   ENDIF                                                                 ULX04
     C*
     C** RESETUP WORK FIELDS IF POSITION CHANGED AFTER SELECTION
     C*
     C     DHKEY         IFNE      WWKEY                                        - B1
     C     DHNARA        IFNE      *BLANKS                                      - B2
     C     DHEXTT        ORNE      *BLANKS
     C     DHCRED        ORNE      *BLANKS
     C     DHDEBI        ORNE      *BLANKS
     C***********DHAMTY    ORNE *BLANKS                                   ULX004
     C     DHAMTY        ORNE      *BLANKS                                                     ULX01
     C     DHPRCD        ORNE      *BLANKS                                                     ULX00
     C     DHPORT        ORNE      *BLANKS                                                     ULX00
     C                   MOVE      *BLANKS       SELEC2
     C                   END                                                    - E2
     C                   END                                                    - E1
     C*
     C** INIT SCREEN LINE NUMBER
     C*
     C                   Z-ADD     0             WWCPT             2 0
     C*
     C** TRANSACTION TYPE SELECTED
     C*
     C     DHKEY         IFNE      *BLANKS                                      - B1
     C     ERKEY2        SETLL     ERLUTTL1
     C                   ELSE                                                   - X1
     C     *LOVAL        SETLL     ERLUTTL1
     C                   END                                                    - E1
     C*
     C** NAME SELECTED
     C*
     C     DHNARA        IFNE      *BLANKS                                      - B1
     C                   EXSR      CALLEN
     C                   END                                                    - E1
     C*                                                                   ERL200
     C* ROLLUP PRESSED                                                    ERL200
     C     WWAID         IFEQ      'UP'                                         - B1           ERL20
     C                   MOVEL     WWSAV1        UPMOD                                         ERL20
     C                   MOVEL     WWSAV2        UPTYP                                         ERL20
     C     ERKUP         SETLL     ERLUTTL1                                                    ERL20
     C                   END                                                    - E1           ERL20
     C*
     C** READ RECORD
     C*
     C                   READ      ERLUTTL1                               30
     C*
     C** LOAD SUBFILE
     C*
     C                   MOVE      '0'           *IN63
     C*
     C     *IN30         DOWEQ     '0'                                          - B1
     C     WWCPT         ANDLT     14                                                          ERL20
     C*
     C                   MOVE      *BLANKS       DSNARA                                        ER031
     C                   MOVE      *BLANKS       DSSELE
     C                   MOVE      VCMMOD        DSMOD
     C                   MOVE      VCTTYP        DSTYPE
     C*********************MOVE VCAMTY    DSAMTY                          ULX004
     C                   MOVE      VCAMTY        DSAMTY                                        ULX01
     C                   MOVE      VCPRCD        DSPRCD                                        ULX00
     C                   MOVE      VCPORT        DSPORT                                        ULX00
     C                   MOVE      VCEXTT        DSEXTT
     C                   MOVE      VCRBND        DSDEBI
     C                   MOVE      VCRBNC        DSCRED
     C*
     C     DSMOD         IFEQ      'DL'                                         - B2
     C     DSMOD         OREQ      'CL'                                                        ER032
     C     DSMOD         OREQ      'FD'                                                        ER044
     C                   MOVEL     DSTYPE        WW4               4
     C                   MOVE      WW4           KEY2              2
     C*****      KEY2      CHAINSDDLSTL1             88                   165675
     C     DSTYP1        IFNE      'FR'                                         - B21          ULX04
     C     DSTYP1        ANDNE     'RS'                                                        ULX04
     C     DSTYP1        ANDNE     'RX'                                                        ULX04
     C     DSTYP1        ANDNE     'RR'                                                        ULX04
     C     DSTYP1        ANDNE     'RP'                                                        ULX04
     C     DSTYP1        ANDNE     'RF'                                                        ULX04
     C********** KEY4      CHAINFDDTSTL1             88                                165675 CER001
     C     KEY5          CHAIN     FDDTSTL1                           88
     C     *IN88         IFEQ      '1'                                          - B3
     C                   MOVE      *BLANKS       DSNARA
     C                   ELSE                                                   - X3
     C****                 MOVELASDSTN    DSNARA                          165675
     C                   MOVEL     NARR11        DSNARA                                        16567
     C                   END                                                    - E3
     C                   END                                                    - E21          ULX04
     C     DSTYP1        IFEQ      'FR'                                         - B21          ULX04
     C     DSTYP1        OREQ      'RS'                                                        ULX04
     C     DSTYP1        OREQ      'RX'                                                        ULX04
     C     DSTYP1        OREQ      'RR'                                                        ULX04
     C     DSTYP1        OREQ      'RP'                                                        ULX04
     C     DSTYP1        OREQ      'RF'                                                        ULX04
     C     DSTYP2        CHAIN     SDDLSTL1                           88                       ULX04
     C     *IN88         IFEQ      '1'                                          - B3           ULX04
     C                   MOVE      *BLANKS       DSNARA                                        ULX04
     C                   ELSE                                                   - X3           ULX04
     C                   MOVEL     ASDSTN        DSNARA                                        ULX04
     C                   END                                                    - E3           ULX04
     C                   END                                                    - E21          ULX04
     C                   END                                                    - E2
     C*
     C     DSMOD         IFEQ      'LE'                                         - B2
     C     DSMOD         OREQ      'FL'                                                        ER044
     C     KEY4          CHAIN     SDLOANL1                           88
     C     *IN88         IFEQ      '1'                                          - B3
     C                   MOVE      *BLANKS       DSNARA
     C                   ELSE                                                   - X3
     C                   MOVEL     AYLNTD        DSNARA
     C                   END                                                    - E3
     C                   END                                                    - E2
     C*
     C     DSMOD         IFEQ      'FC'                                         - B2
     C                   MOVEL     DSTYPE        KEY3              3
     C     KEY3          CHAIN     SDFACTL1                           88
     C     *IN88         IFEQ      '1'                                          - B3
     C                   MOVE      *BLANKS       DSNARA
     C                   ELSE                                                   - X3
     C                   MOVEL     AMFCNM        DSNARA
     C                   END                                                    - E3
     C                   END                                                    - E2
     C*
     C     DSMOD         IFEQ      'IV'                                         - B2
     C                   MOVEL     DSTYPE        IVKY1
     C     IVKY1         CHAIN     INVTO                              88
     C     *IN88         IFEQ      '1'                                          - B3
     C                   MOVE      *BLANKS       DSNARA
     C                   ELSE                                                   - X3
     C                   MOVEL     INAM          DSNARA
     C                   END                                                    - E3
     C                   END                                                    - E2
     C*
     C     DSMOD         IFEQ      'IT'                                         - B2
     C**********           MOVELDSTYPE    ITKEY7                   ER0102 ULX004
     C**********           MOVE ITKEY7    ITKEY                    ER0102 ULX004
     C********** ITKEY     CHAININTYP                88                   ULX004
     C********** *IN88     IFEQ '1'                        - B3           ULX004
     C**********           MOVE *BLANKS   DSNARA                          ULX004
     C**********           ELSE                            - X3           ULX004
     C**********           MOVELISTN      DSNARA                          ULX004
     C**********           END                             - E3           ULX004
      *                                                                   ULX004
      ** Find Book Code to obtain Hedging Indicator (BDGGIN)              ULX004
      *                                                                   ULX004
     C                   MOVEL     DSTYPE        KBOOK                                         ULX00
     C     KBOOK         CHAIN     SDBOOKL0                           88                       ULX00
      *                                                                   ULX004
      ** Build key to derive narrative for screen display                 ULX004
      *                                                                   ULX004
     C     *IN88         IFEQ      '0'                                          *--------3     ULX00
     C     DSTYP2        CAT       BDHGIN        WW08A                          *create TABIT1 ULX00
     C     WW08A         LOOKUP    TABIT1        TABIT2                   99                   ULX00
      *                                                                   ULX004
     C     *IN99         IFEQ      '1'                                          *-------4      ULX00
     C                   MOVE      TABIT2        DSNARA                         * IT Narrative ULX00
     C                   ELSE                                                   X-------4      ULX00
     C                   MOVE      *BLANKS       DSNARA                                        ULX00
     C                   ENDIF                                                  *-------4      ULX00
     C                   ELSE                                                   X--------3     ULX00
     C                   MOVE      *BLANKS       DSNARA                                        ULX00
     C                   ENDIF                                                  *--------3     ULX00
      *                                                                   ULX004
     C                   END                                                    - E2
     C*                                                                   ULX024
     C** Setup Narrative Field for Trade Innovation                       ULX024
     C*                                                                   ULX024
     C     DSMOD         IFEQ      'TI'                                         - B2           ULX02
      *                                                                   ULX024
      ** Work fields setup                                                ULX024
      *                                                                   ULX024
     C     4             SUBST     DSTYPE:1      WF3               4                           ULX02
     C     4             SUBST     DSTYPE:5      WF4               4                           ULX02
     C*          1         SUBSTDSTYPE:8  WF1     1                       ULX024
      *                                                                   ULX024
     C     KWF           CHAIN     ERTIPTL0                           99                       ULX02
     C     *IN99         IFEQ      *OFF                                         - B3           ULX02
     C                   MOVEL     ERTIPD        DSNARA                                        ULX02
     C                   ELSE                                                   - X3           ULX02
     C                   Z-ADD     1             X                 2 0                         ULX02
     C     WF3           LOOKUP    CODE(X)                                99                   ULX02
     C                   MOVEA     NARR(X)       DSNARA                                        ULX02
     C                   END                                                    - E3           ULX02
     C                   END                                                    - E2           ULX02
     C*                                                                   ERL354
     C** SETUP NARRATIVE FIELD FOR DEPOT MOVEMENTS                        ERL354
     C     DSMOD         IFEQ      'DP'                                         - B2           ERL35
     C                   MOVEL     DSTYPE        DPTYP                                         ERL35
     C                   Z-ADD     1             J                                             ERL35
     C     DPTYP         LOOKUP    ARDP1(J)                               99                   ERL35
     C                   MOVEL     ARDP2(J)      DSNARA                                        ERL35
     C                   END                                                    - E2           ERL35
     C*
     C** SETUP NARRATIVE FIELD FOR CUSTOMER POSITION                      ERL386
     C     DSMOD         IFEQ      'CP'                                         - B2           ERL38
     C                   MOVEL     ARCP(1)       DSNARA                                        ERL38
     C                   END                                                    - E2           ERL38
     C** SETUP NARRATIVE FIELD FOR DISCR. CUSTOMER'S ASSETS               ERL436
     C     DSMOD         IFEQ      'DA'                                         - B2           ERL43
     C                   MOVEL     ARCP(2)       DSNARA                                        ERL43
     C                   END                                                    - E2           ERL43
     C*
     C** SELECTION HAS BEEN ENTERRED AND NOT COMING FROM F9
     C*
     C***********SELEC1    IFNE SELEC2                     - B2           ERL200
     C     SELEC1        IFNE      *BLANKS                                      - B2           ERL20
     C     IN16          ANDEQ     *BLANKS
     C*
     C** RECORD READ SELECTED OR NOT ???
     C*
     C     DHNARA        IFNE      *BLANKS                                      - B3
     C                   MOVE      '0'           *IN90
     C     DHNARA:I      SCAN      DSNARA                                 90
     C                   END                                                    - E3
     C*
     C                   MOVE      '0'           *IN10
     C                   EXSR      SELEC
     C     *IN10         IFEQ      '1'                                          - B3
     C*
     C** LOAD FIELDS
     C*
     C                   ADD       1             RRN                  81
     C                   ADD       1             WWCPT                          SCREEN LINE MBR
     C*
     C** WRITE IN SUBFILE
     C*
     C                   WRITE     ERLU40S1
     C*
     C                   END                                                    - E3
     C*
     C                   ELSE                                                   - X2
     C* LOAD FIELDS
     C                   ADD       1             RRN                  81
     C                   ADD       1             WWCPT                          SCREEN LINE MBR
     C*
     C** WRITE IN SUBFILE
     C*
     C                   WRITE     ERLU40S1
     C*
     C                   END                                                    - E2
     C*
     C** READ NEXT RECORD
     C*
     C                   READ      ERLUTTL1                               30
     C                   MOVEL     VCMMOD        WWSAV1            2                           ERL20
     C                   MOVEL     VCTTYP        WWSAV2            8                           ERL20
     C*
     C                   END                                                    - E1
     C*
     C                   MOVE      DHKEY         WWKEY
     C                   Z-ADD     RRN           WWRRN             4 0                         ERL20
     C*
     C                   ENDSR
     C**************************************************************************
     C* LOAD SUBFILE WHEN F9 HAS BEEN PRESSED !
     C**************************************************************************
     C*
     C     LOASF9        BEGSR
     C*
     C                   MOVE      '0'           *IN63
     C*
     C** INIT SCREEN LINE NUMBER
     C*
     C                   Z-ADD     1             CPT               2 0
     C*
     C** LOAD SUBFILE
     C*
     C     CPT           DOWLE     30                                           - B1
     C*
     C                   MOVE      *BLANKS       DSMOD
     C                   MOVE      *BLANKS       DSTYPE
     C                   MOVE      *BLANKS       DSNARA
     C                   MOVE      *BLANKS       DSEXTT
     C                   MOVE      *BLANKS       DSDEBI
     C                   MOVE      *BLANKS       DSCRED
     C***********          MOVE *BLANKS   DSAMTY                          ULX004
     C                   MOVE      *BLANKS       DSAMTY                                        ULX01
     C                   MOVE      *BLANKS       DSPRCD                                        ULX00
     C                   MOVE      *BLANKS       DSPORT                                        ULX00
     C*
     C** LOAD FIELDS
     C*
     C                   ADD       1             RRN                  81
     C                   ADD       1             CPT                            SCREEN LINE MBR
     C*
     C** WRITE IN SUBFILE
     C*
     C                   WRITE     ERLU40S1
     C*
     C                   END                                                    - E1
     C*
     C                   ENDSR
     C**************************************************************************
     C* SELEC SUBROUTINE - SELECTION FOR THE RECORD READ                       *
     C**************************************************************************
     C*
     C     SELEC         BEGSR
     C*
     C** NARRATIVE SELECTED
     C*
     C     DHNARA        IFNE      *BLANKS                                      - B1
     C     *IN90         IFEQ      '1'                                          - B2
     C*
     C     DHDEBI        IFEQ      *BLANKS
     C     DHCRED        ANDEQ     *BLANKS
     C     DHEXTT        ANDEQ     *BLANKS
     C***********DHAMTY    ANDEQ*BLANKS                                   ULX004
     C     DHAMTY        ANDEQ     *BLANKS                                                     ULX01
     C     DHPRCD        ANDEQ     *BLANKS                                                     ULX00
     C     DHPORT        ANDEQ     *BLANKS                                                     ULX00
     C                   MOVE      '1'           *IN10
     C                   END                                                    - E3
     C*
     C     DHEXTT        IFNE      *BLANKS                                      - B3
     C     DHEXTT        IFEQ      DSEXTT                                       - B4
     C                   MOVE      '1'           *IN10
     C                   ELSE                                                   - X4
     C                   MOVE      '0'           *IN10
     C                   GOTO      ENDSEL
     C                   END                                                    - E4
     C                   END                                                    - E3
     C*
     C     DHDEBI        IFNE      *BLANKS                                      - B3
     C     DHDEBI        IFEQ      DSDEBI                                       - B4
     C                   MOVE      '1'           *IN10
     C                   ELSE                                                   - X4
     C                   MOVE      '0'           *IN10
     C                   GOTO      ENDSEL
     C                   END                                                    - E4
     C                   END                                                    - E3
     C*
     C     DHCRED        IFNE      *BLANKS                                      - B3
     C     DHCRED        IFEQ      DSCRED                                       - B4
     C                   MOVE      '1'           *IN10
     C                   ELSE                                                   - X4
     C                   MOVE      '0'           *IN10
     C                   GOTO      ENDSEL
     C                   END                                                    - E4
     C                   END                                                    - E3
     C*
     C***********DHAMTY    IFNE *BLANKS                    - B3           ULX004
     C***********DHAMTY    IFEQ DSAMTY                     - B4           ULX004
     C     DHAMTY        IFNE      *BLANKS                                      - B3           ULX01
     C     DHAMTY        IFEQ      DSAMTY                                       - B4           ULX01
     C                   MOVE      '1'           *IN10                                         ULX01
     C                   ELSE                                                   - X4           ULX01
     C                   MOVE      '0'           *IN10                                         ULX01
     C                   GOTO      ENDSEL                                                      ULX01
     C                   END                                                    - E4           ULX01
     C                   END                                                    - E3           ULX01
     C*                                                                   ULX011
     C     DHPRCD        IFNE      *BLANKS                                      - B3           ULX00
     C     DHPRCD        IFEQ      DSPRCD                                       - B4           ULX00
     C                   MOVE      '1'           *IN10
     C                   ELSE                                                   - X4
     C                   MOVE      '0'           *IN10
     C                   GOTO      ENDSEL
     C                   END                                                    - E4
     C                   END                                                    - E3
     C*                                                                   ULX004
     C     DHPORT        IFNE      *BLANKS                                      - B3           ULX00
     C     DHPORT        IFEQ      DSPORT                                       - B4           ULX00
     C                   MOVE      '1'           *IN10                                         ULX00
     C                   ELSE                                                   - X4           ULX00
     C                   MOVE      '0'           *IN10                                         ULX00
     C                   GOTO      ENDSEL                                                      ULX00
     C                   END                                                    - E4           ULX00
     C                   END                                                    - E3           ULX00
     C*
     C                   END                                                    - E2
     C                   GOTO      ENDSEL
     C                   END                                                    - E1
     C*
     C** EXTRACT TYPE SELECTED
     C     DHEXTT        IFNE      *BLANKS                                      - B1
     C     DHEXTT        IFEQ      DSEXTT                                       - B2
     C*
     C     DHNARA        IFEQ      *BLANKS                                      - B3
     C     DHDEBI        ANDEQ     *BLANKS
     C     DHCRED        ANDEQ     *BLANKS
     C***********DHAMTY    ANDEQ*BLANKS                                   ULX004
     C     DHAMTY        ANDEQ     *BLANKS                                                     ULX01
     C     DHPRCD        ANDEQ     *BLANKS                                                     ULX00
     C     DHPORT        ANDEQ     *BLANKS                                                     ULX00
     C                   MOVE      '1'           *IN10
     C                   END                                                    - E3
     C*
     C     DHDEBI        IFNE      *BLANKS                                      - B3
     C     DHDEBI        IFEQ      DSDEBI                                       - B4
     C                   MOVE      '1'           *IN10
     C                   ELSE                                                   - X4
     C                   MOVE      '0'           *IN10
     C                   GOTO      ENDSEL
     C                   END                                                    - E4
     C                   END                                                    - E3
     C     DHCRED        IFNE      *BLANKS                                      - B3
     C     DHCRED        IFEQ      DSCRED                                       - B4
     C                   MOVE      '1'           *IN10
     C                   ELSE                                                   - X4
     C                   MOVE      '0'           *IN10
     C                   GOTO      ENDSEL
     C                   END                                                    - E4
     C                   END                                                    - E3
     C*
     C***********DHAMTY    IFNE *BLANKS                    - B3           ULX004
     C***********DHAMTY    IFEQ DSAMTY                     - B4           ULX004
     C     DHAMTY        IFNE      *BLANKS                                      - B3           ULX01
     C     DHAMTY        IFEQ      DSAMTY                                       - B4           ULX01
     C                   MOVE      '1'           *IN10                                         ULX01
     C                   ELSE                                                   - X4           ULX01
     C                   MOVE      '0'           *IN10                                         ULX01
     C                   GOTO      ENDSEL                                                      ULX01
     C                   END                                                    - E4           ULX01
     C                   END                                                    - E3           ULX01
     C*                                                                   ULX011
     C     DHPRCD        IFNE      *BLANKS                                      - B3           ULX00
     C     DHPRCD        IFEQ      DSPRCD                                       - B4           ULX00
     C                   MOVE      '1'           *IN10
     C                   ELSE                                                   - X4
     C                   MOVE      '0'           *IN10
     C                   GOTO      ENDSEL
     C                   END                                                    - E4
     C                   END                                                    - E3
     C*                                                                   ULX004
     C     DHPORT        IFNE      *BLANKS                                      - B3           ULX00
     C     DHPORT        IFEQ      DSPORT                                       - B4           ULX00
     C                   MOVE      '1'           *IN10                                         ULX00
     C                   ELSE                                                   - X4           ULX00
     C                   MOVE      '0'           *IN10                                         ULX00
     C                   GOTO      ENDSEL                                                      ULX00
     C                   END                                                    - E4           ULX00
     C                   END                                                    - E3           ULX00
     C*
     C                   END                                                    - E2
     C                   GOTO      ENDSEL
     C                   END                                                    - E1
     C*
     C** RUBRIC DEBIT SELECTED
     C     DHDEBI        IFNE      *BLANKS                                      - B1
     C     DHDEBI        IFEQ      DSDEBI                                       - B2
     C*
     C     DHNARA        IFEQ      *BLANKS                                      - B3
     C     DHCRED        ANDEQ     *BLANKS
     C     DHEXTT        ANDEQ     *BLANKS
     C***********DHAMTY    ANDEQ*BLANKS                                   ULX004
     C     DHAMTY        ANDEQ     *BLANKS                                                     ULX01
     C     DHPRCD        ANDEQ     *BLANKS                                                     ULX00
     C     DHPORT        ANDEQ     *BLANKS                                                     ULX00
     C                   MOVE      '1'           *IN10
     C                   END                                                    - E3
     C*
     C     DHCRED        IFNE      *BLANKS                                      - B3
     C     DHCRED        IFEQ      DSCRED                                       - B4
     C                   MOVE      '1'           *IN10
     C                   ELSE                                                   - X4
     C                   MOVE      '0'           *IN10
     C                   GOTO      ENDSEL
     C                   END                                                    - E4
     C                   END                                                    - E3
     C*
     C***********DHAMTY    IFNE *BLANKS                    - B3           ULX004
     C***********DHAMTY    IFEQ DSAMTY                     - B4           ULX004
     C     DHAMTY        IFNE      *BLANKS                                      - B3           ULX01
     C     DHAMTY        IFEQ      DSAMTY                                       - B4           ULX01
     C                   MOVE      '1'           *IN10                                         ULX01
     C                   ELSE                                                   - X4           ULX01
     C                   MOVE      '0'           *IN10                                         ULX01
     C                   GOTO      ENDSEL                                                      ULX01
     C                   END                                                    - E4           ULX01
     C                   END                                                    - E3           ULX01
     C*                                                                   ULX011
     C     DHPRCD        IFNE      *BLANKS                                      - B3           ULX00
     C     DHPRCD        IFEQ      DSPRCD                                       - B4           ULX00
     C                   MOVE      '1'           *IN10
     C                   ELSE                                                   - X4
     C                   MOVE      '0'           *IN10
     C                   GOTO      ENDSEL
     C                   END                                                    - E4
     C                   END                                                    - E3
     C*                                                                   ULX004
     C     DHPORT        IFNE      *BLANKS                                      - B3           ULX00
     C     DHPORT        IFEQ      DSPORT                                       - B4           ULX00
     C                   MOVE      '1'           *IN10                                         ULX00
     C                   ELSE                                                   - X4           ULX00
     C                   MOVE      '0'           *IN10                                         ULX00
     C                   GOTO      ENDSEL                                                      ULX00
     C                   END                                                    - E4           ULX00
     C                   END                                                    - E3           ULX00
     C*
     C                   END                                                    - E2
     C                   GOTO      ENDSEL
     C                   END                                                    - E1
     C*
     C** RUBRIC CREDIT SELECTED
     C*D***      DHCRED    IFNE *ZEROS                     - B1           ULX046
     C     DHCRED        IFNE      *BLANKS                                      - B1           ULX04
     C     DHCRED        IFEQ      DSCRED                                       - B2
     C*
     C     DHDEBI        IFEQ      *BLANKS
     C***********DHAMTY    ANDEQ*BLANKS                                   ULX004
     C     DHAMTY        ANDEQ     *BLANKS                                                     ULX01
     C     DHPRCD        ANDEQ     *BLANKS                                                     ULX00
     C     DHPORT        ANDEQ     *BLANKS                                                     ULX00
     C                   MOVE      '1'           *IN10
     C                   END                                                    - E3
     C*
     C***********DHAMTY    IFNE *BLANKS                    - B3           ULX004
     C***********DHAMTY    IFEQ DSAMTY                     - B4           ULX004
     C     DHAMTY        IFNE      *BLANKS                                      - B3           ULX01
     C     DHAMTY        IFEQ      DSAMTY                                       - B4           ULX01
     C                   MOVE      '1'           *IN10                                         ULX01
     C                   ELSE                                                   - X4           ULX01
     C                   MOVE      '0'           *IN10                                         ULX01
     C                   GOTO      ENDSEL                                                      ULX01
     C                   END                                                    - E4           ULX01
     C                   END                                                    - E3           ULX01
     C*                                                                   ULX011
     C     DHPRCD        IFNE      *BLANKS                                      - B3           ULX00
     C     DHPRCD        IFEQ      DSPRCD                                       - B4           ULX00
     C                   MOVE      '1'           *IN10
     C                   ELSE                                                   - X4
     C                   MOVE      '0'           *IN10
     C                   GOTO      ENDSEL
     C                   END                                                    - E4
     C                   END                                                    - E3
     C*                                                                   ULX004
     C     DHPORT        IFNE      *BLANKS                                      - B3           ULX00
     C     DHPORT        IFEQ      DSPORT                                       - B4           ULX00
     C                   MOVE      '1'           *IN10                                         ULX00
     C                   ELSE                                                   - X4           ULX00
     C                   MOVE      '0'           *IN10                                         ULX00
     C                   GOTO      ENDSEL                                                      ULX00
     C                   END                                                    - E4           ULX00
     C                   END                                                    - E3           ULX00
     C*
     C                   END                                                    - E2
     C                   GOTO      ENDSEL                                                      ULX00
     C                   END                                                    - E1
      ***********                                                         ULX004
      ***Amount*Type selected                                             ULX004
      ***********                                                         ULX004
     C***********DHAMTY    IFNE *BLANKS                    - B1           ULX004
     C***********DHAMTY    IFEQ DSAMTY                     - B2           ULX004
      ***********                                                         ULX004
     C***********          MOVE '1'       *IN10                           ULX004
     C***********                                                         ULX004
     C***********          END                             - E2           ULX004
     C***********          END                             - E1           ULX004
      *                                                                   ULX004
      **  Amount Type selected                                            ULX011
     C     DHAMTY        IFNE      *BLANKS                                      - B1           ULX01
     C     DHAMTY        IFEQ      DSAMTY                                       - B2           ULX01
     C                   MOVE      '1'           *IN10                                         ULX01
     C                   END                                                    - E2           ULX01
     C                   END                                                    - E1           ULX01
      *                                                                   ULX011
      ** Product Code selected.                                           ULX004
      *                                                                   ULX004
     C     DHPRCD        IFNE      *BLANKS                                      - B1           ULX00
     C     DHPRCD        IFEQ      DSPRCD                                       - B2           ULX00
      *                                                                   ULX004
     C     DHPORT        IFEQ      *BLANKS                                      - B3           ULX00
     C                   MOVE      '1'           *IN10                                         ULX00
     C                   END                                                    - E3           ULX00
     C*                                                                   ULX004
     C     DHPORT        IFNE      *BLANKS                                      - B3           ULX00
     C     DHPORT        IFEQ      DSPORT                                       - B4           ULX00
     C                   MOVE      '1'           *IN10                                         ULX00
     C                   ELSE                                                   - X4           ULX00
     C                   MOVE      '0'           *IN10                                         ULX00
     C                   GOTO      ENDSEL                                                      ULX00
     C                   END                                                    - E4           ULX00
     C                   END                                                    - E3           ULX00
     C*                                                                   ULX004
     C                   END                                                    - E2           ULX00
     C                   END                                                    - E1           ULX00
      *                                                                   ULX004
      ** Portfolio Type selected.                                         ULX004
      *                                                                   ULX004
     C     DHPORT        IFNE      *BLANKS                                      - B1           ULX00
     C     DHPORT        IFEQ      DSPORT                                       - B2           ULX00
     C                   MOVE      '1'           *IN10                                         ULX00
     C                   END                                                    - E2           ULX00
     C                   END                                                    - E1           ULX00
     C*
     C     ENDSEL        TAG
     C*
     C                   ENDSR
     C**************************************************************************
     C* SRVAL - SUBROUTINE TO VALIDATE CREDIT AND DEBIT AND EXTRACT TYPE       *
     C**************************************************************************
     C*
     C     SRVAL         BEGSR
     C*
     C** EXTRACT TYPE MUST BE VALID
     C*
     C     DSEXTT        IFNE      *BLANKS                                      - B1
     C     DSEXTT        ANDNE     'Y'
     C     DSEXTT        ANDNE     'N'
     C                   MOVE      '1'           *IN26
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB3002'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    - E1
     C*
     C     DSEXTT        IFEQ      *BLANKS                                      - B1
     C     DSDEBI        ANDNE     *ZEROS
     C     DSEXTT        OREQ      *BLANKS
     C     DSCRED        ANDNE     *ZEROS
     C                   MOVE      '1'           *IN26
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB3006'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    - E1
     C*
     C** VALIDATION IF FULLY NUMERIC
     C*
     C     DSDEBI        IFEQ      *BLANKS                                      - B1
     C                   MOVE      *ZEROS        DSDEBI
     C                   END                                                    - E1
     C*
     C     DSDEBI        IFNE      *ZEROS                                       - B1
     C                   MOVEL     DSDEBI        TEST9             9 0
     C                   MOVEL     TEST9         ALPH8             8
     C     DSDEBI        IFNE      ALPH8                                        - B2
     C                   MOVE      '1'           *IN24
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB3008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    - E2
     C                   END                                                    - E1
     C*                                                                   ERL415
     C     DSDEBI        IFNE      *ZEROS                                       - B1           ERL41
     C     *IN24         ANDEQ     '0'                                                         ERL41
     C*****DSDEBI        CHAIN     ERLU11PD                           82              ERL41 MD058079
     C/EXEC SQL                                                                             MD058079
     C+ SELECT *                                                                            MD058079
     C+ into :ERLU11                                                                        MD058079
     C+ from ERL11JW0                                                                       MD058079
     C+ where IMCODE = :DSDEBI                                                              MD058079
     C/END-EXEC                                                                             MD058079
     C*                                                                   ERL415
     C** IML code 1.1 must exist                                          ERL415
     C******IN82         IFEQ      '1'                                          - B2  ERL41 MD058079
     C     SQLCODE       IFEQ      100                                                      MD058079
     C                   MOVE      '1'           *IN24                                         ERL41
     C                   MOVE      '1'           *IN63                                         ERL41
     C                   MOVEL     'ERL3010'     ZAMSID                                        ERL41
     C                   EXSR      ZASNMS                                                      ERL41
     C                   ELSE                                                   - X2           ERL41
     C*                                                                   ERL415
     C** IML code 1.1 can not be a 'Sub-total' not managed (action 'X')   ERL415
     C     IMACTI        IFEQ      'X'                                          - B3           ERL41
     C     IMTYPE        ANDEQ     'S'                                                         ERL41
     C                   MOVE      '1'           *IN24                                         ERL41
     C                   MOVE      '1'           *IN63                                         ERL41
     C                   MOVEL     'ERL3011'     ZAMSID                                        ERL41
     C                   EXSR      ZASNMS                                                      ERL41
     C                   END                                                    - E3           ERL41
     C*                                                                   ERL415
     C** IML code 1.1 can not be a 'Dont' not managed (action 'X')        ERL415
     C     IMACTI        IFEQ      'X'                                          - B3           ERL41
     C     IMTYPE        ANDEQ     'I'                                                         ERL41
     C     IMACTI        OREQ      'X'                                                         ERL41
     C     IMTYPE        ANDEQ     'X'                                                         ERL41
     C                   MOVE      '1'           *IN24                                         ERL41
     C                   MOVE      '1'           *IN63                                         ERL41
     C                   MOVEL     'ERL3012'     ZAMSID                                        ERL41
     C                   EXSR      ZASNMS                                                      ERL41
     C                   END                                                    - E3           ERL41
     C*                                                                   ERL415
     C** IML code 1.1 can not be a 'Total' not managed (action 'X')       ERL415
     C     IMACTI        IFEQ      'X'                                          - B3           ERL41
     C     IMTYPE        ANDEQ     'T'                                                         ERL41
     C                   MOVE      '1'           *IN24                                         ERL41
     C                   MOVE      '1'           *IN63                                         ERL41
     C                   MOVEL     'ERL3013'     ZAMSID                                        ERL41
     C                   EXSR      ZASNMS                                                      ERL41
     C                   END                                                    - E3           ERL41
     C                   END                                                    - E2           ERL41
     C                   END                                                    - E1           ERL41
     C*
     C     DSCRED        IFEQ      *BLANKS                                      - B1
     C                   MOVE      *ZEROS        DSCRED
     C                   END                                                    - E1
     C*
     C     DSCRED        IFNE      *ZEROS                                       - B1
     C                   MOVEL     DSCRED        TEST9             9 0
     C                   MOVEL     TEST9         ALPH8             8
     C     DSCRED        IFNE      ALPH8                                        - B2
     C                   MOVE      '1'           *IN25
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB3008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    - E2
     C                   END                                                    - E1
     C*                                                                   ERL415
     C     DSCRED        IFNE      *ZEROS                                       - B1           ERL41
     C     *IN25         ANDEQ     '0'                                          - B1           ERL41
     C*****DSCRED        CHAIN     ERLU11PD                           82              ERL41 MD058079
     C/EXEC SQL                                                                             MD058079
     C+ SELECT *                                                                            MD058079
     C+ into :ERLU11                                                                        MD058079
     C+ from ERL11JW0                                                                       MD058079
     C+ where IMCODE = :DSDEBI                                                              MD058079
     C/END-EXEC                                                                             MD058079
     C*                                                                   ERL415
     C** IML code 1.1 must exist                                          ERL415
     C******IN82         IFEQ      '1'                                          - B2        MD058079
     C     SQLCODE       IFEQ      100                                                      MD058079
     C                   MOVE      '1'           *IN25                                         ERL41
     C                   MOVE      '1'           *IN63                                         ERL41
     C                   MOVEL     'ERL3010'     ZAMSID                                        ERL41
     C                   EXSR      ZASNMS                                                      ERL41
     C                   ELSE                                                   - X2           ERL41
     C*                                                                   ERL415
     C** IML code 1.1 can not be a 'Sub-total' not managed (action 'X')   ERL415
     C     IMACTI        IFEQ      'X'                                          - B3           ERL41
     C     IMTYPE        ANDEQ     'S'                                                         ERL41
     C                   MOVE      '1'           *IN25                                         ERL41
     C                   MOVE      '1'           *IN63                                         ERL41
     C                   MOVEL     'ERL3011'     ZAMSID                                        ERL41
     C                   EXSR      ZASNMS                                                      ERL41
     C                   END                                                    - E3           ERL41
     C*                                                                   ERL415
     C** IML code 1.1 can not be a 'Dont' not managed (action 'X')        ERL415
     C     IMACTI        IFEQ      'X'                                          - B3           ERL41
     C     IMTYPE        ANDEQ     'I'                                                         ERL41
     C     IMACTI        OREQ      'X'                                                         ERL41
     C     IMTYPE        ANDEQ     'X'                                                         ERL41
     C                   MOVE      '1'           *IN25                                         ERL41
     C                   MOVE      '1'           *IN63                                         ERL41
     C                   MOVEL     'ERL3012'     ZAMSID                                        ERL41
     C                   EXSR      ZASNMS                                                      ERL41
     C                   END                                                    - E3           ERL41
     C*                                                                   ERL415
     C** IML code 1.1 can not be a 'Total' not managed (action 'X')       ERL415
     C     IMACTI        IFEQ      'X'                                          - B3           ERL41
     C     IMTYPE        ANDEQ     'T'                                                         ERL41
     C                   MOVE      '1'           *IN25                                         ERL41
     C                   MOVE      '1'           *IN63                                         ERL41
     C                   MOVEL     'ERL3013'     ZAMSID                                        ERL41
     C                   EXSR      ZASNMS                                                      ERL41
     C                   END                                                    - E3           ERL41
     C                   END                                                    - E2           ERL41
     C                   END                                                    - E1           ERL41
      ***********                                                         ULX004
      ***Validate Amount Type                                             ULX004
      ***********                                                         ULX004
     C***********DSAMTY    IFEQ *BLANKS                    - B1           ULX004
     C***********          MOVE 'G'       DSAMTY                          ULX004
     C***********          ELSE                            - X1           ULX004
     C***********DSAMTY    IFNE 'G'                        - B2           ULX004
     C***********DSAMTY    ANDNE'C'                                       ULX004
     C***********DSAMTY    ANDNE'L'                                       ULX004
     C***********          MOVE '1'       *IN27                           ULX004
     C***********          MOVE '1'       *IN63                           ULX004
     C***********          MOVEL'ERL3009' ZAMSID                          ULX004
     C***********          EXSR ZASNMS                                    ULX004
     C***********          END                             - E2           ULX004
     C***********          END                             - E1           ULX004
     C*                                                                   ULX004
      **  Validate Amount Type                                            ULX011
     C     DSAMTY        IFEQ      *BLANKS                                      - B1           ULX01
     C*D***                MOVE '0'       DSAMTY                   ULX011 ULX046
     C                   MOVE      '00'          DSAMTY                                        ULX04
     C                   ELSE                                                   - X1           ULX01
     C*D***      DSAMTY    LOKUPPORT                     83        ULX011 ULX046
     C                   Z-ADD     1             Y                 3 0                         ULX04
     C     DSAMTY        LOOKUP    AMTY(Y)                                83                   ULX04
     C     *IN83         IFEQ      *OFF                                         - B2           ULX01
     C                   MOVE      '1'           *IN29                                         ULX01
     C                   MOVE      '1'           *IN63                                         ULX01
     C                   MOVEL     'ERL3009'     ZAMSID                                        ULX01
     C                   EXSR      ZASNMS                                                      ULX01
     C                   ELSE                                                                  ULX04
     C                   MOVEL     AMTY2(Y)      DSAMTY                                        ULX04
     C                   END                                                    - E2           ULX01
     C                   END                                                    - E1           ULX01
     C*                                                                   ULX011
     C** Validate Product Code.                                           ULX004
     C*                                                                   ULX004
     C** Validation if fully numeric                                      ULX004
     C     DSPRCD        IFEQ      *BLANKS                                      - B1           ULX00
     C                   MOVE      *ZEROS        DSPRCD                                        ULX00
     C                   END                                                    - E1           ULX00
     C*                                                                   ULX004
     C     DSPRCD        IFNE      *ZEROS                                       - B1           ULX00
     C                   MOVEL     DSPRCD        TEST5             5 0                         ULX00
     C                   MOVEL     TEST5         ALPH4             4                           ULX00
     C     DSPRCD        IFNE      ALPH4                                        - B2           ULX00
     C                   MOVE      '1'           *IN27                                         ULX00
     C                   MOVE      '1'           *IN63                                         ULX00
     C                   MOVEL     'ERL0012'     ZAMSID                                        ULX00
     C                   EXSR      ZASNMS                                                      ULX00
     C                   END                                                    - E2           ULX00
     C                   END                                                    - E1           ULX00
     C*                                                                   ULX004
     C     DSPRCD        IFNE      *ZEROS                                       - B1           ULX00
     C     *IN28         ANDEQ     '0'                                                         ULX00
     C                   MOVE      DSPRCD        WPRCD             4 0                         ULX00
     C******     WPRCD     LOKUPPROD                     83        ULX004 ULX011
     C*                                                                   ULX004
      ** Product*Code*doesn't*exist*on*table.                      ULX004 ULX011
     C******     *IN83     IFEQ '0'                        - B2    ULX004 ULX011
     C     WPRCD         CHAIN     ERPRDCPD                           82                       ULX01
      ** Product Code doesn't exist                                       ULX011
     C     *IN82         IFEQ      '1'                                          - B2           ULX01
     C                   MOVE      '1'           *IN27                                         ULX00
     C                   MOVE      '1'           *IN63                                         ULX00
     C                   MOVEL     'ERL0013'     ZAMSID                                        ULX00
     C                   EXSR      ZASNMS                                                      ULX00
     C                   END                                                    - E2           ULX00
     C                   END                                                    - E1           ULX00
     C*                                                                   ULX004
     C** Validate Portfolio Type.                                         ULX004
     C*                                                                   ULX004
     C     DSPORT        IFEQ      *BLANKS                                      - B1           ULX00
     C                   MOVE      *ZEROS        DSPORT                                        ULX00
     C                   ELSE                                                   - E1           ULX00
     C*                                                                   ULX004
     C     DSPORT        LOOKUP    PORT                                   83                   ULX00
     C*                                                                   ULX004
     C** Portfolio Type doesn't exist on table.                           ULX004
     C     *IN83         IFEQ      '0'                                          - B2           ULX00
     C                   MOVE      '1'           *IN28                                         ULX00
     C                   MOVE      '1'           *IN63                                         ULX00
     C                   MOVEL     'ERL0014'     ZAMSID                                        ULX00
     C                   EXSR      ZASNMS                                                      ULX00
     C                   END                                                    - E2           ULX00
     C                   END                                                    - E1           ULX00
     C*
     C                   ENDSR
     C**************************************************************************
     C* INITIAL ROUTINE                                                        *
     C**************************************************************************
     C*
     C     INIT          BEGSR
     C*
     C                   MOVE      CTRY          PARCTR
     C*
     C                   MOVE      '0'           *IN
     C*
     C     ACTION        IFEQ      'E'
     C                   MOVE      '1'           *IN15
     C                   END
     C*
     C*   Select the program MSGQ for error msg.
     C                   MOVEL     '*'           TOPQ             10
     C                   MOVEL     '*PRV'        TOPRQ             5
     C                   MOVEL     '*'           DDPGMQ
     C**********           MOVEL'ERUSRMSG'PMSGF  10                                           CER001
     C                   MOVEL     'STUSRMSG'    PMSGF            10
     C*
     C*   Fill in fields for subroutine ZASNMS
     C                   MOVEL     'ERLU40'      ZAPGM            10            Message queue
     C**********           MOVEL'ERUSRMSG'ZAMSGF 10        Message file                       CER001
     C                   MOVEL     'STUSRMSG'    ZAMSGF           10            Message file
     C                   MOVEL     *BLANK        ZAPGRL            5            Rel queue
     C                   MOVEL     *BLANK        ZAMSID            7            Message Id.
     C                   MOVEL     *BLANK        ZAMSDA          132            Message data.
     C                   MOVEL     *BLANK        ZAMSTP            7            Message type.
     C*
     C******               READ SDBANKPD                 88               ULX004
      *                                                                   ULX004
      **  Get Installation Control Data Record 1                          ULX004
      *                                                                   ULX004
     C                   CALL      'AOBANKR0'                                                  ULX00
     C                   PARM      '*MSG   '     @RTCD             7                           ULX00
     C                   PARM      '*FIRST '     @OPTN             7                           ULX00
     C     SDBANK        PARM      SDBANK        DSFDY                                         ULX00
     C     @RTCD         IFNE      *BLANKS                                      *----------1   ULX00
     C                   Z-ADD     1             DBASE                          ***************ULX00
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DB ERROR 01 *ULX00
     C                   MOVEL     '*FIRST'      DBKEY                          ***************ULX00
     C                   EXSR      *PSSR                                                       ULX00
     C                   ENDIF                                                  *----------1   ULX00
      *                                                                                       CER001
      ** Access AOSARDR0 and check if CDL038 is installed                                     CER001
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C*********************PARM 'ULX004'  @SARD   6                                    CER001 CLE042
     C                   PARM      'CDL038'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CER001
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF    '
     C                   Z-ADD     2             DBASE
     C                   MOVE      'SCSARDPD'    DBFILE
     C                   MOVEL     'CDL038'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDL038            1
     C                   ELSE
     C                   MOVE      'N'           CDL038
     C                   ENDIF
      *                                                                                       CLE042
      ** Access AOSARDR0 and check if CLE042 is installed                                     CLE042
      *                                                                                       CLE042
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE042'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CLE042
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF    '
     C                   Z-ADD     30            DBASE
     C                   MOVE      'SCSARDPD'    DBFILE
     C                   MOVEL     'CLE042'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CLE042
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE042            1
     C                   ELSE
     C                   MOVE      'N'           CLE042
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       DHDEBI
     C                   MOVE      *BLANKS       DHCRED
     C                   MOVE      *BLANKS       WWDEBI
     C                   MOVE      *BLANKS       WWCRED
     C*
     C                   MOVE      *BLANKS       DHMOD
     C                   MOVE      *BLANKS       DHTYPE
     C                   MOVE      *BLANKS       WWMOD             2
     C**********           MOVE *BLANKS   WWTYPE  8                                    ER0102 CER001
     C                   MOVE      *BLANKS       WWTYPE
     C                   MOVE      *BLANKS       WW08A             8                           ULX00
     C*
     C** SETUP 'ADD' OR 'AMEND' MODE
     C*
     C                   READ      ERLUTTL1                               88
     C     *IN88         IFEQ      '1'
     C                   MOVE      '1'           *IN09
     C                   END
     C*
     C                   ENDSR
     C****************************************************************
     C*  ZASNMS : SEND MESSAGE TO PROGRAM'S MESSAGE QUEUE            *
     C****************************************************************
     C     ZASNMS        BEGSR
     C*
     C**   message file specified use PMSGF
     C*
     C                   MOVEL     PMSGF         ZAMSGF
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
     C**
     C**   Clear all fields for default mechanism next time.
     C                   MOVEL     *BLANK        ZAPGM                          Program queue
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file
     C                   MOVEL     *BLANK        ZAMSID                         Message id.
     C**
     C                   ENDSR
     C*
     C*****************************************************************
     C**                                                              *
     C**   *PSSR     - PROGRAM ERROR HANDLING ROUTINE                 *
     C**                                                              *
     C**   CALLS     -                                                *
     C**                                                              *
     C**   CALLED BY -                                                *
     C**                                                              *
     C*****************************************************************
     C*
     C     *PSSR         BEGSR
     C*
     C                   MOVE      'E'           #RETRN
     C                   DUMP
     C*
     C     #PSSR0        ENDSR
     C**************************************************************************
     C* CALLEN - SUBROUTINE TO CALCULATE THE LENGHT OF NARRATIVE INPUT
     C**************************************************************************
     C     CALLEN        BEGSR
     C*
     C                   MOVEA     DHNARA        ARR
     C                   Z-ADD     30            I                 2 0
     C*
     C     ARR(I)        DOWEQ     *BLANKS
     C                   SUB       1             I
     C                   END
     C*
     C                   ENDSR
     C********************************************************************ERL200
      ** PRESS S/R TO MOVE THE APPROPRIATE VALUES INTO FIELD WWAID,       ERL200
      ** DEPENDING ON WHICH FUNCTION KEY HAS BEEN PRESSED.                ERL200
      **                                                                  ERL200
     C*===================================================================ERL200
     C*                                                                   ERL200
     C     PRESS         BEGSR                                                  ** PRESS BSR **ERL20
     C*                                                                   ERL200
     C** If ENTER pressed, the VLDCMDKEY indicator will be off            ERL200
     C*                                                                   ERL200
     C                   MOVE      '  '          WWAID                                         ERL20
     C*                                                                   ERL200
     C     *IN45         IFEQ      '0'                                                         ERL20
     C                   MOVE      'RA'          WWAID             2                           ERL20
     C                   END                                                                   ERL20
     C*                                                                   ERL200
     C** If F3                                                            ERL200
     C*                                                                   ERL200
     C     *INKC         IFEQ      '1'                                                         ERL20
     C                   MOVE      '03'          WWAID                                         ERL20
     C                   END                                                                   ERL20
     C*                                                                   ERL200
     C** If F12                                                           ERL200
     C*                                                                   ERL200
     C     *INKL         IFEQ      '1'                                                         ERL20
     C                   MOVE      '12'          WWAID                                         ERL20
     C                   END                                                                   ERL20
     C*                                                                   ERL200
     C** If ROLLUP pressed                                                ERL200
     C*                                                                   ERL200
     C     *IN35         IFEQ      '1'                                                         ERL20
     C                   MOVE      'UP'          WWAID                                         ERL20
     C                   END                                                                   ERL20
     C*                                                                   ERL200
     C                   ENDSR                                                  ** PRESS ESR **ERL20
     C*                                                                   ERL200
     C*===================================================================ERL200
      **ITIPTDTICILNCDCLDLC1C2BPBDTBDATACSBSBRTSRATR                      ER0100
**CTDATA PORT
0123456789                                                                ULX004
**CTDATA ARDL
ITIPTDTICILNCDCLDLC1C2BPBDTBDATACSBSBRTSRATRCXFSFPOPOTSWSIPIFRRFRPRRRSRX  ER0100
**CTDATA ARDP1
BLBBRPRRPDPL
**CTDATA ARDP2
Bond Lending     Bond Borrowing
Repurchase Order Reverse Repo
Pledged Deposit  Pledged Loan
**CTDATA ARCP
Customer Position                                                         ERL386
Discretionary Customer Assets                                             ERL436
**CTDATA TABIT1
1NY     FUTURE/MARKET TRADED/HEDGING                                      ULX004
1NN     FUTURE/MARKET TRADED/TRADING                                      ULX004
2NY     FUTURE/MARKET TRADED/HEDGING                                      ULX004
2NN     FUTURE/MARKET TRADED/TRADING                                      ULX004
3NY     FUTURE/MARKET TRADED/HEDGING                                      ULX004
3NN     FUTURE/MARKET TRADED/TRADING                                      ULX004
4YY     OPTION/OTC/HEDGING                                                ULX004
4YN     OPTION/OTC/TRADING                                                ULX004
4NY     OPTION/MARKET TRADED/HEDGING                                      ULX004
4NN     OPTION/MARKET TRADED/TRADING                                      ULX004
5YY     OPTION/OTC/HEDGING                                                ULX004
5YN     OPTION/OTC/TRADING                                                ULX004
5NY     OPTION/MARKET TRADED/HEDGING                                      ULX004
5NN     OPTION/MARKET TRADED/TRADING                                      ULX004
6YY     OPTION/OTC/HEDGING                                                ULX004
6YN     OPTION/OTC/TRADING                                                ULX004
6NY     OPTION/MARKET TRADED/HEDGING                                      ULX004
6NN     OPTION/MARKET TRADED/TRADING                                      ULX004
7NY     FUTURE/MARKET TRADED/HEDGING                                      ULX004
7NN     FUTURE/MARKET TRADED/TRADING                                      ULX004
8NY     OPTION/MARKET TRADED/HEDGING                                      ULX004
8NN     OPTION/MARKET TRADED/TRADING                                      ULX004
**CTDATA AMTY
00 00 01 11 02 22 03 33 04 44 05 55 06 66 07 77 08 88 09 99 101112        ULX046
**CTDATA AMTY2
000000010101020202030303040404050505060606070707080808090909101112        ULX046
**CTDATA CPY@
(c) Finastra International Limited 2005
