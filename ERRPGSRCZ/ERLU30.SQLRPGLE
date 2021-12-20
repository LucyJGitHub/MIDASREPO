     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058079
/*STD *  RPGSQLBND                                                    *                     MD058079
/*EXI *  TEXT('Midas Decision Table - Account Codes')
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ERLU30 - Decision Table - Account Codes                      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD058079           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CER001             Date 25Apr05               *
      *                 ULX046             Date 21Oct02               *
      *                 ULX004             Date 28Oct97               *
      *                 ERL415             Date 22Jul94               *
      *                 ERL200  *CREATE    Date 13Jan93               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058079 - Deliverable Data Split for sundry files           *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  ULX046 - Circulars 2002/170-174-175 Integration              *
      *  ULX004 - Capital Adequacy                                    *
      *         - IML Circular 97/138                                 *
      *  ERL415 - IML codes 1.1 validation                            *
      *  ERL200 - New subfile processing                              *
      *                                                               *
      *****************************************************************
      *
     FERPRDCPD  IF   E           K DISK                                         ULX004
      *                                                                   ULX004
     F*ERLU11PD* IF   E           K DISK                                         ERL415     MD058079
     F*                                                                   ERL415
     FSDACODL1  IF   E           K DISK
     F*
     FERLUACL0  UF A E           K DISK    COMMIT
     F                                     RENAME(ERLUACD0:UPERLUAC)
     FERLUACL1  IF   E           K DISK
     F*
     F******SDBANKPDIF  E           K        DISK                         ULX004
     F*
     FERLU30DF  CF   E             WORKSTN
     F                                     SFILE(ERLU30S1:RRN)
     D*****************************************************************
     D******              PROD   18  52  4 0                       ULX004 ULX004
     D PORT            S              1    DIM(10) CTDATA PERRCD(10)                             ULX
     D AMTY            S              2    DIM(33) CTDATA PERRCD(33)                             ULX
     D AMTY2           S              2    DIM(33) CTDATA PERRCD(33)                             ULX
     D ARR             S              1    DIM(25)                              ARRAY FOR LENGHT
     D*****************************************************************
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
     D  DHNARA                 1     25
     D  DHTYPE                26     26
     D  DHEXTY                27     27
     D  DHDEBI                28     35
     D  DHCRED                36     43
     D***************************************44  44 DHAMTY                ULX004
     D****************************************1  44 SELEC1                ULX004
     D******                                 44  47 DHPRCD        ULX004  ULX004
     D******                                 48  48 DHPORT        ULX004  ULX004
     D******                                  1  48 SELEC1        ULX004  ULX004
     D*D***                                  44  44 DHAMTY        ULX004  ULX046
     D*D***                                  45  48 DHPRCD        ULX004  ULX046
     D*D***                                  49  49 DHPORT        ULX004  ULX046
     D*D***                                   1  49 SELEC1        ULX004  ULX046
     D  DHAMTY                44     45                                         ULX046
     D  DHPRCD                46     49                                         ULX046
     D  DHPORT                50     50                                         ULX046
     D  SELEC1                 1     50                                         ULX046
     D***
     D                 DS
     D  WWNARA                 1     25
     D  WWTYPE                26     26
     D  WWEXTY                27     27
     D  WWDEBI                28     35
     D  WWCRED                36     43
     D***************************************44  44 WWAMTY                ULX004
     D****************************************1  44 SELEC2                ULX004
     D******                                 44  47 WWPRCD                ULX004
     D******                                 48  48 WWPORT                ULX004
     D******                                  1  48 SELEC2                ULX004
     D*D***                                  44  44 WWAMTY         ULX004 ULX046
     D*D***                                  45  48 WWPRCD         ULX004 ULX046
     D*D***                                  49  49 WWPORT         ULX004 ULX046
     D*D***                                   1  49 SELEC2         ULX004 ULX046
     D  WWAMTY                44     45                                         ULX046
     D  WWPRCD                46     49                                         ULX046
     D  WWPORT                50     50                                         ULX046
     D  SELEC2                 1     50                                         ULX046
     D*
     D**  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION:
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *                                                                   ULX004
      **  External DS for Bank Details                                    ULX004
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    ULX004
      *                                                                   ULX004
      * First DS for access programs, SHORT DATA STRUCTURE                ULX004
     D DSFDY         E DS                  EXTNAME(DSFDY)                       ULX004
      *                                                                   ULX004
      * Second DS dor access programs, LONG DATA STRUCTURE                ULX004
     D DSSDY         E DS                  EXTNAME(DSSDY)                       ULX004
     D ERLU11        E DS                  EXTNAME(ERL11JW0)                                MD058079
     I*
     C**************************************************************************
     C* MAIN PROCESSING                                                        *
     C**************************************************************************
     C* CALL INIT SUBROUTINE
     C**************************************************************************
     C*
     C     *ENTRY        PLIST
     C                   PARM                    ACTION            1
     C                   PARM                    #RETRN            1
     C                   PARM                    CTRY              2
     C*
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
     C                   WRITE     ERLU30C0                                     BOTTOM
     C                   EXFMT     ERLU30C1                                     SUBFILE
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
     C     DHACOD        ANDNE     WWACOD
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
     C                   Z-ADD     0             DHACOD
     C                   MOVE      *BLANKS       DHNARA
     C                   MOVE      *BLANKS       DHTYPE
     C                   MOVE      *BLANKS       DHEXTY
     C                   MOVE      *BLANKS       DHDEBI
     C                   MOVE      *BLANKS       DHTYPE
     C*********************MOVE *BLANKS   DHAMTY                          ULX004
     C                   MOVE      *BLANKS       DHAMTY                                        ULX00
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
     C                   WRITE     ERLU30C0                                     BOTTOM
     C                   EXFMT     ERLU30C1                                     SUBFILE
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
     C                   READC     ERLU30S1                               32
     C*
     C     *IN32         DOWEQ     '0'                                          - B3
     C*
     C                   MOVE      '0'           *IN15
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN23
     C                   MOVE      '0'           *IN24
     C                   MOVE      '0'           *IN25
     C                   MOVE      '0'           *IN26
     C                   MOVE      '0'           *IN27                                         ULX00
     C                   MOVE      '0'           *IN28                                         ULX00
     C                   MOVE      '0'           *IN63
     C*
     C     DSACOD        CHAIN     SDACODL1                           88
     C*
     C     DSACOD        IFNE      *BLANKS                                      - B4
     C     *IN88         IFEQ      '1'                                          - B5
     C                   MOVE      '1'           *IN23
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB3003'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *BLANKS       DSNARA
     C                   MOVE      *BLANKS       DSTYPE
     C                   ELSE                                                   - X5
     C     A5TOIN        IFEQ      'Y'                                          - B6
     C                   MOVE      '1'           *IN23
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB3003'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      *BLANKS       DSNARA
     C                   MOVE      *BLANKS       DSTYPE
     C                   ELSE                                                   - X6
     C                   MOVE      A5ACCN        DSNARA
     C                   MOVE      A5ACTY        DSTYPE
     C                   END                                                    - E6
     C                   END                                                    - E5
     C*
     C                   ELSE                                                   - X4
     C*
     C     DSEXTY        IFNE      *BLANKS                                      - B5
     C     DSDEBI        ORNE      *BLANKS
     C     DSCRED        ORNE      *BLANKS
     C                   MOVE      '1'           *IN23
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB3005'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    - E5
     C                   END                                                    - E4
     C*
     C** ALREADY EXISTS ON FILE
     C                   MOVE      DSACOD        XXACOD
     C     XXACOD        CHAIN     ERLUACL1                           88
     C     *IN88         IFEQ      '0'                                          - B4
     C                   MOVE      '1'           *IN23
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB3004'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    - E4
     C*
     C***********DSEXTY    IFNE *BLANKS                    - B4           ERL415
     C***********DSEXTY    ANDNE'Y'                                       ERL415
     C***********DSEXTY    ANDNE'N'                                       ERL415
     C***********          MOVE '1'       *IN21                           ERL415
     C***********          MOVE '1'       *IN63                           ERL415
     C***********          MOVEL'ERB3002' ZAMSID                          ERL415
     C***********          EXSR ZASNMS                                    ERL415
     C***********          END                             - E4           ERL415
     C***********                                                         ERL415
     C***VALIDATION IF FULLY NUMERIC                                      ERL415
     C***********DSDEBI    IFEQ *BLANKS                                   ERL415
     C***********          MOVE *ZEROS    DSDEBI                          ERL415
     C***********          END                                            ERL415
     C***********                                                         ERL415
     C***********DSDEBI    IFNE *ZEROS                     - B4           ERL415
     C***********          MOVELDSDEBI    TEST9   90                      ERL415
     C***********          MOVELTEST9     ALPH8   8                       ERL415
     C***********DSDEBI    IFNE ALPH8                      - B5           ERL415
     C***********          MOVE '1'       *IN24                           ERL415
     C***********          MOVE '1'       *IN63                           ERL415
     C***********          MOVEL'ERB3008' ZAMSID                          ERL415
     C***********          EXSR ZASNMS                                    ERL415
     C***********          END                             - E5           ERL415
     C***********          END                             - E4           ERL415
     C***********                                                         ERL415
     C***********DSCRED    IFEQ *BLANKS                                   ERL415
     C***********          MOVE *ZEROS    DSCRED                          ERL415
     C***********          END                                            ERL415
     C***********                                                         ERL415
     C***********DSCRED    IFNE *ZEROS                     - B4           ERL415
     C***********          MOVELDSCRED    TEST9   90                      ERL415
     C***********          MOVELTEST9     ALPH8   8                       ERL415
     C***********DSCRED    IFNE ALPH8                      - B5           ERL415
     C***********          MOVE '1'       *IN25                           ERL415
     C***********          MOVE '1'       *IN63                           ERL415
     C***********          MOVEL'ERB3008' ZAMSID                          ERL415
     C***********          EXSR ZASNMS                                    ERL415
     C***********          END                             - E5           ERL415
     C***********          END                             - E4           ERL415
     C***********                                                         ERL415
     C***VALIDATE RUBRIC NUMBERS                                          ERL415
     C***********DSEXTY    IFEQ *BLANKS                    - B4           ERL415
     C***********DSDEBI    ANDNE*ZEROS                                    ERL415
     C***********DSEXTY    OREQ *BLANKS                                   ERL415
     C***********DSCRED    ANDNE*ZEROS                                    ERL415
     C***********          MOVE '1'       *IN21                           ERL415
     C***********          MOVE '1'       *IN63                           ERL415
     C***********          MOVEL'ERB3006' ZAMSID                          ERL415
     C***********          EXSR ZASNMS                                    ERL415
     C***********          END                             - E4           ERL415
      ***********                                                         ERL415
      ***Validate*Amount Type                                             ERL415
      ***********                                                         ERL415
     C***********DSAMTY    IFEQ *BLANKS                    - B4           ERL415
     C***********          MOVE 'G'       DSAMTY                          ERL415
     C***********          ELSE                            - X4           ERL415
     C***********DSAMTY    IFNE 'G'                        - B5           ERL415
     C***********DSAMTY    ANDNE'C'                                       ERL415
     C***********DSAMTY    ANDNE'L'                                       ERL415
     C***********          MOVE '1'       *IN26                           ERL415
     C***********          MOVE '1'       *IN63                           ERL415
     C***********          MOVEL'ERL3009' ZAMSID                          ERL415
     C***********          EXSR ZASNMS                                    ERL415
     C***********          END                             - E5           ERL415
     C***********          END                             - E4           ERL415
     C*                                                                   ERL415
     C** VALIDATE INPUT FIELDS                                            ERL415
     C                   EXSR      SRVAL                                                       ERL41
     C*
     C** NO ERRORS
     C     *IN23         IFEQ      '0'                                          - B4
     C     *IN21         ANDEQ     '0'
     C     *IN24         ANDEQ     '0'
     C     *IN25         ANDEQ     '0'
     C     *IN26         ANDEQ     '0'
     C     *IN27         ANDEQ     '0'                                                         ULX00
     C     *IN28         ANDEQ     '0'                                                         ULX00
     C     DSACOD        ANDNE     *BLANKS
     C                   MOVE      DSACOD        VBACOD
     C                   MOVE      DSEXTY        VBEXTT
     C*********************MOVE DSAMTY    VBAMTY                          ULX004
     C                   MOVE      DSAMTY        VBAMTY                                        ULX00
     C                   MOVE      DSPRCD        VBPRCD                                        ULX00
     C                   MOVE      DSPORT        VBPORT                                        ULX00
     C                   MOVE      DSDEBI        VBRBND
     C                   MOVE      DSCRED        VBRBNC
     C                   Z-ADD     BJRDNB        VBLCD
     C                   MOVE      'I'           VBTYLC
     C                   WRITE     UPERLUAC
     C*
     C** WRITE DONE THEN PROTECT RECORD
     C                   MOVE      '1'           *IN15
     C*
     C                   COMMIT
     C                   END                                                    - E4
     C*
     C                   UPDATE    ERLU30S1
     C                   MOVE      '0'           *IN15
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN23
     C                   MOVE      '0'           *IN24
     C                   MOVE      '0'           *IN25
     C                   MOVE      '0'           *IN26
     C                   MOVE      '0'           *IN27                                         ULX00
     C                   MOVE      '0'           *IN28                                         ULX00
     C                   MOVE      '0'           *IN63
     C*
     C** READ NEXT CHANGED RECORD
     C                   READC     ERLU30S1                               32
     C*
     C                   ENDDO                                                  - E3
     C                   END                                                    - E2
     C*
     C** REFRESH ON F9 SCREEN
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
     C                   READC     ERLU30S1                               32
     C*
     C     *IN32         DOWEQ     '0'                                          - B1
     C*
     C** VALIDATION ON RECORD SUBFILE
     C*
     C                   MOVE      '0'           *IN63
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN24
     C                   MOVE      '0'           *IN25
     C                   MOVE      '0'           *IN26
     C                   MOVE      '0'           *IN27                                         ULX00
     C                   MOVE      '0'           *IN28                                         ULX00
     C*
     C     DSSELE        IFNE      'D'                                          - B2
     C     DSSELE        ANDNE     *BLANKS
     C                   MOVE      '1'           *IN20
     C                   MOVE      '1'           *IN63
     C                   MOVEL     'ERB3001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    - E2
     C*
     C***********DSEXTY    IFNE *BLANKS                    - B2           ERL415
     C***********DSEXTY    ANDNE'Y'                                       ERL415
     C***********DSEXTY    ANDNE'N'                                       ERL415
     C***********          MOVE '1'       *IN21                           ERL415
     C***********          MOVE '1'       *IN63                           ERL415
     C***********          MOVEL'ERB3002' ZAMSID                          ERL415
     C***********          EXSR ZASNMS                                    ERL415
     C***********          END                             - E2           ERL415
     C***********                                                         ERL415
     C***VALIDATION IF FULLY NUMERIC                                      ERL415
     C***********DSDEBI    IFEQ *BLANKS                                   ERL415
     C***********          MOVE *ZEROS    DSDEBI                          ERL415
     C***********          END                                            ERL415
     C***********                                                         ERL415
     C***********DSDEBI    IFNE *ZEROS                     - B2           ERL415
     C***********          MOVELDSDEBI    TEST9   90                      ERL415
     C***********          MOVELTEST9     ALPH8   8                       ERL415
     C***********DSDEBI    IFNE ALPH8                      - B3           ERL415
     C***********          MOVE '1'       *IN24                           ERL415
     C***********          MOVE '1'       *IN63                           ERL415
     C***********          MOVEL'ERB3008' ZAMSID                          ERL415
     C***********          EXSR ZASNMS                                    ERL415
     C***********          END                             - E3           ERL415
     C***********          END                             - E2           ERL415
     C***********                                                         ERL415
     C***********DSCRED    IFEQ *BLANKS                                   ERL415
     C***********          MOVE *ZEROS    DSCRED                          ERL415
     C***********          END                                            ERL415
     C***********                                                         ERL415
     C***********DSCRED    IFNE *ZEROS                     - B2           ERL415
     C***********          MOVELDSCRED    TEST9   90                      ERL415
     C***********          MOVELTEST9     ALPH8   8                       ERL415
     C***********DSCRED    IFNE ALPH8                      - B3           ERL415
     C***********          MOVE '1'       *IN25                           ERL415
     C***********          MOVE '1'       *IN63                           ERL415
     C***********          MOVEL'ERB3008' ZAMSID                          ERL415
     C***********          EXSR ZASNMS                                    ERL415
     C***********          END                             - E3           ERL415
     C***********          END                             - E2           ERL415
     C***********                                                         ERL415
     C***VALIDATE RUBRIC NUMBERS                                          ERL415
     C***********DSEXTY    IFEQ *BLANKS                    - B2           ERL415
     C***********DSDEBI    ANDNE*ZEROS                                    ERL415
     C***********DSEXTY    OREQ *BLANKS                                   ERL415
     C***********DSCRED    ANDNE*ZEROS                                    ERL415
     C***********          MOVE '1'       *IN21                           ERL415
     C***********          MOVE '1'       *IN63                           ERL415
     C***********          MOVEL'ERB3006' ZAMSID                          ERL415
     C***********          EXSR ZASNMS                                    ERL415
     C***********          END                             - E2           ERL415
      ***********                                                         ERL415
      ***Validate*Amount Type                                             ERL415
      ***********                                                         ERL415
     C***********DSAMTY    IFEQ *BLANKS                    - B2           ERL415
     C***********          MOVE 'G'       DSAMTY                          ERL415
     C***********          ELSE                            - X2           ERL415
     C***********DSAMTY    IFNE 'G'                        - B3           ERL415
     C***********DSAMTY    ANDNE'C'                                       ERL415
     C***********DSAMTY    ANDNE'L'                                       ERL415
     C***********          MOVE '1'       *IN26                           ERL415
     C***********          MOVE '1'       *IN63                           ERL415
     C***********          MOVEL'ERL3009' ZAMSID                          ERL415
     C***********          EXSR ZASNMS                                    ERL415
     C***********          END                             - E3           ERL415
     C***********          END                             - E2           ERL415
     C*                                                                   ERL415
     C** VALIDATE INPUT FIELDS                                            ERL415
     C                   EXSR      SRVAL                                                       ERL41
     C*
     C** NO ERRORS
     C     *IN20         IFEQ      '0'                                          - B2
     C     *IN21         ANDEQ     '0'
     C     *IN24         ANDEQ     '0'
     C     *IN25         ANDEQ     '0'
     C     *IN26         ANDEQ     '0'
     C     *IN27         ANDEQ     '0'                                                         ULX00
     C     *IN28         ANDEQ     '0'                                                         ULX00
     C*
     C** IF NO ERROR AND 'D' SELECTED ==> DELETE IN FILE
     C     DSSELE        IFEQ      'D'                                          - B3
     C                   MOVE      DSACOD        XXACOD
     C     XXACOD        CHAIN     ERLUACL0                           88
     C     *IN88         IFEQ      '0'                                          - B4
     C                   DELETE    UPERLUAC
     C                   MOVE      '1'           *IN15
     C                   END                                                    - E4
     C                   ELSE                                                   - X3
     C*
     C** UPDATE FILE AND SUBFILE
     C**********           MOVE DSACOD    XXACOD  40                                          CER001
     C                   MOVE      DSACOD        XXACOD           10 0
     C     XXACOD        CHAIN     ERLUACL0                           88
     C     *IN88         IFEQ      '0'                                          - B4
     C                   MOVE      DSEXTY        VBEXTT
     C*********************MOVE DSAMTY    VBAMTY                          ULX004
     C                   MOVE      DSAMTY        VBAMTY                                        ULX00
     C                   MOVE      DSPRCD        VBPRCD                                        ULX00
     C                   MOVE      DSPORT        VBPORT                                        ULX00
     C                   MOVE      DSDEBI        VBRBND
     C                   MOVE      DSCRED        VBRBNC
     C                   Z-ADD     BJRDNB        VBLCD
     C                   MOVE      'A'           VBTYLC
     C                   UPDATE    UPERLUAC
     C                   END                                                    - E4
     C                   END                                                    - E3
     C                   COMMIT
     C                   END                                                    - E2
     C*
     C                   UPDATE    ERLU30S1
     C                   MOVE      '0'           *IN63
     C                   MOVE      '0'           *IN15
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN24
     C                   MOVE      '0'           *IN25
     C                   MOVE      '0'           *IN26
     C                   MOVE      '0'           *IN27                                         ULX00
     C                   MOVE      '0'           *IN28                                         ULX00
     C*
     C** READ NEXT CHANGED RECORD
     C                   READC     ERLU30S1                               32
     C*
     C                   ENDDO                                                  - E1
     C*
     C*
     C                   ENDSR
     C********************************************************************ERL415
     C* VALIDATION SUBROUTINE                                             ERL415
     C********************************************************************ERL415
     C*                                                                   ERL415
     C     SRVAL         BEGSR                                                                 ERL41
     C*                                                                   ERL415
     C** Extract type validation                                          ERL415
     C*                                                                   ERL415
     C     DSEXTY        IFNE      *BLANKS                                      - B1           ERL41
     C     DSEXTY        ANDNE     'Y'                                                         ERL41
     C     DSEXTY        ANDNE     'N'                                                         ERL41
     C                   MOVE      '1'           *IN21                                         ERL41
     C                   MOVE      '1'           *IN63                                         ERL41
     C                   MOVEL     'ERB3002'     ZAMSID                                        ERL41
     C                   EXSR      ZASNMS                                                      ERL41
     C                   END                                                    - E1           ERL41
     C*                                                                   ERL415
     C** DEBIT IML CODE VALIDATION                                        ERL415
     C*                                                                   ERL415
     C** Check if fully numeric                                           ERL415
     C     DSDEBI        IFEQ      *BLANKS                                      - B1           ERL41
     C                   MOVE      *ZEROS        DSDEBI                                        ERL41
     C                   END                                                    - E1           ERL41
     C*                                                                   ERL415
     C     DSDEBI        IFNE      *ZEROS                                       - B1           ERL41
     C                   MOVEL     DSDEBI        TEST9             9 0                         ERL41
     C                   MOVEL     TEST9         ALPH8             8                           ERL41
     C     DSDEBI        IFNE      ALPH8                                        - B2           ERL41
     C                   MOVE      '1'           *IN24                                         ERL41
     C                   MOVE      '1'           *IN63                                         ERL41
     C                   MOVEL     'ERB3008'     ZAMSID                                        ERL41
     C                   EXSR      ZASNMS                                                      ERL41
     C                   END                                                    - E2           ERL41
     C                   END                                                    - E1           ERL41
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
     C*                                                                   ERL415
     C** CREDIT IML CODE VALIDATION                                       ERL415
     C*                                                                   ERL415
     C** Validation if fully numeric                                      ERL415
     C     DSCRED        IFEQ      *BLANKS                                      - B1           ERL41
     C                   MOVE      *ZEROS        DSCRED                                        ERL41
     C                   END                                                    - E1           ERL41
     C*                                                                   ERL415
     C     DSCRED        IFNE      *ZEROS                                       - B1           ERL41
     C                   MOVEL     DSCRED        TEST9             9 0                         ERL41
     C                   MOVEL     TEST9         ALPH8             8                           ERL41
     C     DSCRED        IFNE      ALPH8                                        - B2           ERL41
     C                   MOVE      '1'           *IN25                                         ERL41
     C                   MOVE      '1'           *IN63                                         ERL41
     C                   MOVEL     'ERB3008'     ZAMSID                                        ERL41
     C                   EXSR      ZASNMS                                                      ERL41
     C                   END                                                    - E2           ERL41
     C                   END                                                    - E1           ERL41
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
     C*                                                                   ERL415
     C** Extract type must be entered if IML code entered                 ERL415
     C     DSEXTY        IFEQ      *BLANKS                                      - B1           ERL41
     C     DSDEBI        ANDNE     *ZEROS                                                      ERL41
     C     DSEXTY        OREQ      *BLANKS                                                     ERL41
     C     DSCRED        ANDNE     *ZEROS                                                      ERL41
     C                   MOVE      '1'           *IN21                                         ERL41
     C                   MOVE      '1'           *IN63                                         ERL41
     C                   MOVEL     'ERB3006'     ZAMSID                                        ERL41
     C                   EXSR      ZASNMS                                                      ERL41
     C                   END                                                    - E1           ERL41
      ***********                                                  ERL415 ULX004
      ***Validate Amount Type                                      ERL415 ULX004
      ***********                                                  ERL415 ULX004
     C***********DSAMTY    IFEQ *BLANKS                    - B1    ERL415 ULX004
     C***********          MOVE 'G'       DSAMTY                   ERL415 ULX004
     C***********          ELSE                            - X1    ERL415 ULX004
     C***********DSAMTY    IFNE 'G'                        - B2    ERL415 ULX004
     C***********DSAMTY    ANDNE'C'                                ERL415 ULX004
     C***********DSAMTY    ANDNE'L'                                ERL415 ULX004
     C***********          MOVE '1'       *IN26                    ERL415 ULX004
     C***********          MOVE '1'       *IN63                    ERL415 ULX004
     C***********          MOVEL'ERL3009' ZAMSID                   ERL415 ULX004
     C***********          EXSR ZASNMS                             ERL415 ULX004
     C***********          END                             - E2    ERL415 ULX004
     C***********          END                             - E1    ERL415 ULX004
     C***********                                                  ERL415 ULX004
      *                                                                   ULX004
      **  Validate Amount Type                                            ULX004
      *                                                                   ULX004
     C     DSAMTY        IFEQ      *BLANKS                                      - B1           ULX00
     C*D***                MOVE '0'       DSAMTY                    ULX004ULX046
     C                   MOVE      '00'          DSAMTY                                        ULX04
     C                   ELSE                                                   - X1           ULX00
     C*D***      DSAMTY    LOKUPPORT                     83         ULX004ULX046
     C                   Z-ADD     1             X                 3 0                         ULX04
     C     DSAMTY        LOOKUP    AMTY(X)                                83                   ULX04
     C     *IN83         IFEQ      *OFF                                         - B2           ULX00
     C                   MOVE      '1'           *IN28                                         ULX00
     C                   MOVE      '1'           *IN63                                         ULX00
     C                   MOVEL     'ERL3009'     ZAMSID                                        ULX00
     C                   EXSR      ZASNMS                                                      ULX00
     C                   ELSE                                                                  ULX04
     C                   MOVEL     AMTY2(X)      DSAMTY                                        ULX04
     C                   END                                                    - E2           ULX00
     C                   END                                                    - E1           ULX00
      *                                                                   ULX004
      ** Validate Product Code.                                           ULX004
      *                                                                   ULX004
      ** Validation if fully numeric                                      ULX004
      *                                                                   ULX004
     C     DSPRCD        IFEQ      *BLANKS                                      - B1           ULX00
     C                   MOVE      *ZEROS        DSPRCD                                        ULX00
     C                   END                                                    - E1           ULX00
      *                                                                   ULX004
     C     DSPRCD        IFNE      *ZEROS                                       - B1           ULX00
     C                   MOVEL     DSPRCD        TEST5             5 0                         ULX00
     C                   MOVEL     TEST5         ALPH4             4                           ULX00
     C     DSPRCD        IFNE      ALPH4                                        - B2           ULX00
     C                   MOVE      '1'           *IN26                                         ULX00
     C                   MOVE      '1'           *IN63                                         ULX00
     C                   MOVEL     'ERL0012'     ZAMSID                                        ULX00
     C                   EXSR      ZASNMS                                                      ULX00
     C                   END                                                    - E2           ULX00
     C                   END                                                    - E1           ULX00
      *                                                                   ULX004
     C     DSPRCD        IFNE      *ZEROS                                       - B1           ULX00
     C     *IN27         ANDEQ     '0'                                                         ULX00
     C                   MOVE      DSPRCD        WPRCD             4 0                         ULX00
     C******     WPRCD     LOKUPPROD                     83        ULX004 ULX004
      *                                                                   ULX004
      ** Product*Code*doesn't*exist*on*table.                      ULX004 ULX004
     C******     *IN83     IFEQ '0'                        - B2           ULX004
     C     WPRCD         CHAIN     ERPRDCPD                           82                       ULX00
      ** Product Code doesn't exist                                       ULX004
     C     *IN82         IFEQ      '1'                                          - B2           ULX00
     C                   MOVE      '1'           *IN26                                         ULX00
     C                   MOVE      '1'           *IN63                                         ULX00
     C                   MOVEL     'ERL0013'     ZAMSID                                        ULX00
     C                   EXSR      ZASNMS                                                      ULX00
     C                   END                                                    - E2           ULX00
     C                   END                                                    - E1           ULX00
      *                                                                   ULX004
      ** Validate Portfolio Type.                                         ULX004
      *                                                                   ULX004
     C     DSPORT        IFEQ      *BLANKS                                      - B1           ULX00
     C                   MOVE      *ZEROS        DSPORT                                        ULX00
     C                   ELSE                                                   - E1           ULX00
      *                                                                   ULX004
     C     DSPORT        LOOKUP    PORT                                   83                   ULX00
      *                                                                   ULX004
      ** Portfolio Type doesn't exist on table.                           ULX004
     C     *IN83         IFEQ      '0'                                          - B2           ULX00
     C                   MOVE      '1'           *IN27                                         ULX00
     C                   MOVE      '1'           *IN63                                         ULX00
     C                   MOVEL     'ERL0014'     ZAMSID                                        ULX00
     C                   EXSR      ZASNMS                                                      ULX00
     C                   END                                                    - E2           ULX00
     C                   END                                                    - E1           ULX00
      *                                                                   ULX004
     C                   ENDSR                                                                 ERL41
     C*                                                                   ERL415
     C**************************************************************************
     C* INITIALIZE SUBFILE
     C**************************************************************************
     C*
     C     INISFL        BEGSR
     C*
     C                   MOVE      '0'           *IN80
     C                   MOVE      '0'           *IN81
     C                   WRITE     ERLU30C1
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
     C     SELEC1        IFNE      SELEC2                                       - B1
     C     DHNARA        ANDEQ     *BLANKS
     C     DHTYPE        ANDEQ     *BLANKS
     C     DHEXTY        ANDEQ     *BLANKS
     C     DHDEBI        ANDEQ     *BLANKS
     C     DHCRED        ANDEQ     *BLANKS
     C***********DHAMTY    ANDEQ*BLANKS                                   ULX004
     C     DHAMTY        ANDEQ     *BLANKS                                                     ULX00
     C     DHPRCD        ANDEQ     *BLANKS                                                     ULX00
     C     DHPORT        ANDEQ     *BLANKS                                                     ULX00
     C                   MOVE      SELEC1        SELEC2
     C                   END                                                    - B2
      *                                                                   ULX046
      ** Format the selection field for amount type, to have correct      ULX046
      ** comparisons in the SELEC subroutine                              ULX046
      *                                                                   ULX046
     C     DHAMTY        IFNE      *BLANKS                                                     ULX04
     C                   Z-ADD     1             X                                             ULX04
     C     DHAMTY        LOOKUP    AMTY(X)                                83                   ULX04
     C   83              MOVEL     AMTY2(X)      DHAMTY                                        ULX04
     C                   ENDIF                                                                 ULX04
     C*
     C** RESETUP WORK FIELDS IF POSITION FIELD CHANGED AFTER SELECTION
     C     DHACOD        IFNE      WWACOD                                       - B1
     C     DHNARA        IFNE      *BLANKS                                      - B2
     C     DHEXTY        ORNE      *BLANKS
     C     DHTYPE        ORNE      *BLANKS
     C     DHCRED        ORNE      *BLANKS
     C     DHDEBI        ORNE      *BLANKS
     C***********DHAMTY    ORNE *BLANKS                                   ULX004
     C     DHAMTY        ORNE      *BLANKS                                                     ULX00
     C     DHPRCD        ORNE      *BLANKS                                                     ULX00
     C     DHPORT        ORNE      *BLANKS                                                     ULX00
     C                   MOVE      *BLANKS       WWNARA
     C                   MOVE      *BLANKS       WWEXTY
     C                   MOVE      *BLANKS       WWTYPE
     C                   MOVE      *BLANKS       WWCRED
     C                   MOVE      *BLANKS       WWDEBI
     C***********          MOVE *BLANKS   WWAMTY                          ULX004
     C                   MOVE      *BLANKS       WWAMTY                                        ULX00
     C                   MOVE      *BLANKS       WWPRCD                                        ULX00
     C                   MOVE      *BLANKS       WWPORT                                        ULX00
     C                   END                                                    - E2
     C                   END                                                    - E1
     C*
     C* INIT SCREEN LINE NUMBER
     C                   Z-ADD     0             WWCPT             2 0
     C*
     C* ACCOUNT CODE SELECTED
     C     DHACOD        IFNE      *ZEROS                                       - B1
     C     DHACOD        SETLL     ERLUACL1
     C                   ELSE
     C     *LOVAL        SETLL     ERLUACL1
     C                   END                                                    - E1
     C*
     C* NAME SELECTED
     C     DHNARA        IFNE      *BLANKS                                      - B1
     C                   EXSR      CALLEN
     C                   END                                                    - E1
     C*                                                                   ERL200
     C* ROLLUP PRESSED                                                    ERL200
     C     WWAID         IFEQ      'UP'                                         - B1           ERL20
     C**********           MOVELWWSAV2    DUSELE  40                                   ERL200 CER001
     C                   MOVE      WWSAV2        DUSELE           10 0
     C     DUSELE        SETLL     ERLUACL1                                                    ERL20
     C                   END                                                    - E1           ERL20
     C*
     C* READ RECORD
     C                   READ      ERLUACL1                               30
     C*
     C* LOAD SUBFILE
     C                   MOVE      '0'           *IN63
     C*
     C     *IN30         DOWEQ     '0'                                          - B1
     C     WWCPT         ANDLT     14                                                          ERL20
     C*
     C                   MOVE      VBACOD        DSACOD
     C                   MOVE      VBEXTT        DSEXTY
     C**********           MOVE VBAMTY    DSAMTY                          ULX004
     C                   MOVE      VBAMTY        DSAMTY                                        ULX00
     C                   MOVE      VBPRCD        DSPRCD                                        ULX00
     C                   MOVE      VBPORT        DSPORT                                        ULX00
     C                   MOVE      VBRBND        DSDEBI
     C                   MOVE      VBRBNC        DSCRED
     C*
     C                   MOVE      *BLANKS       DSSELE
     C     DSACOD        CHAIN     SDACODL1                           88
     C     *IN88         IFEQ      '0'                                          - B2
     C*
     C** TAKE NOT-TITLE ONLY
     C     A5TOIN        IFEQ      'Y'                                          - B3
     C                   GOTO      NEXT
     C                   END                                                    - E3
     C*
     C                   MOVE      A5ACCN        DSNARA
     C                   MOVE      A5ACTY        DSTYPE
     C                   ELSE                                                   - X2
     C                   MOVE      *BLANKS       DSNARA
     C                   MOVE      *BLANKS       DSTYPE
     C                   END                                                    - E2
     C*
     C* SELECTION HAS BEEN ENTERRED AND NOT COMING FROM F9
     C***********SELEC1    IFNE SELEC2                     - B2           ERL200
     C     SELEC1        IFNE      *BLANKS                                      - B2           ERL20
     C     IN16          ANDEQ     *BLANKS
     C*
     C** RECORD READ SELECTED OR NOT ???
     C     DHNARA        IFNE      *BLANKS                                      - B3
     C                   MOVE      '0'           *IN90
     C     DHNARA:I      SCAN      A5ACCN                                 90
     C                   END                                                    - E3
     C*
     C                   MOVE      '0'           *IN10
     C                   EXSR      SELEC
     C     *IN10         IFEQ      '1'                                          - B3
     C*
     C* LOAD FIELDS
     C                   ADD       1             RRN                  81
     C                   ADD       1             WWCPT                          SCREEN LINE MBR
     C*
     C* WRITE IN SUBFILE
     C                   WRITE     ERLU30S1
     C*
     C                   END                                                    - E3
     C*
     C                   ELSE                                                   - X2
     C* LOAD FIELDS
     C                   ADD       1             RRN                  81
     C                   ADD       1             WWCPT                          SCREEN LINE MBR
     C*
     C* WRITE IN SUBFILE
     C                   WRITE     ERLU30S1
     C*
     C                   END                                                    - E2
     C*
     C* READ NEXT RECORD
     C     NEXT          TAG
     C                   READ      ERLUACL1                               30
     C**********           Z-ADDVBACOD    WWSAV2  40                                   ERL200 CER001
     C                   Z-ADD     VBACOD        WWSAV2           10 0
     C*
     C                   END                                                    - E1
     C*
     C                   Z-ADD     DHACOD        WWACOD
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
     C* INIT SCREEN LINE NUMBER
     C                   Z-ADD     1             CPT               2 0
     C*
     C* LOAD SUBFILE
     C     CPT           DOWLE     30                                           - B1
     C*
     C                   MOVE      *BLANKS       DSACOD
     C                   MOVE      *BLANKS       DSNARA
     C                   MOVE      *BLANKS       DSEXTY
     C                   MOVE      *BLANKS       DSTYPE
     C                   MOVE      *BLANKS       DSDEBI
     C                   MOVE      *BLANKS       DSCRED
     C**********           MOVE *BLANKS   DSAMTY                          ULX004
     C                   MOVE      *BLANKS       DSAMTY                                        ULX00
     C                   MOVE      *BLANKS       DSPRCD                                        ULX00
     C                   MOVE      *BLANKS       DSPORT                                        ULX00
     C*
     C*
     C* LOAD FIELDS
     C                   ADD       1             RRN                  81
     C                   ADD       1             CPT                            SCREEN LINE MBR
     C*
     C* WRITE IN SUBFILE
     C                   WRITE     ERLU30S1
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
     C     DHNARA        IFNE      *BLANKS                                      - B1
     C     *IN90         IFEQ      '1'                                          - B2
     C*
     C     DHTYPE        IFEQ      *BLANKS                                      - B3
     C     DHEXTY        ANDEQ     *BLANKS
     C     DHDEBI        ANDEQ     *BLANKS
     C     DHCRED        ANDEQ     *BLANKS
     C***********DHAMTY    ANDEQ*BLANKS                                   ULX004
     C     DHAMTY        ANDEQ     *BLANKS                                                     ULX00
     C     DHPRCD        ANDEQ     *BLANKS                                                     ULX00
     C     DHPORT        ANDEQ     *BLANKS                                                     ULX00
     C                   MOVE      '1'           *IN10
     C                   END                                                    - E3
     C*
     C     DHTYPE        IFNE      *BLANKS                                      - B3
     C     DHTYPE        IFEQ      DSTYPE                                       - B4
     C                   MOVE      '1'           *IN10
     C                   ELSE                                                   - X4
     C                   MOVE      '0'           *IN10
     C                   GOTO      ENDSEL
     C                   END                                                    - E4
     C                   END                                                    - E3
     C*
     C     DHEXTY        IFNE      *BLANKS                                      - B3
     C     DHEXTY        IFEQ      DSEXTY                                       - B4
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
     C     DHAMTY        IFNE      *BLANKS                                      - B3           ULX00
     C     DHAMTY        IFEQ      DSAMTY                                       - B4           ULX00
     C                   MOVE      '1'           *IN10                                         ULX00
     C                   ELSE                                                   - X4           ULX00
     C                   MOVE      '0'           *IN10                                         ULX00
     C                   GOTO      ENDSEL                                                      ULX00
     C                   END                                                    - E4           ULX00
     C                   END                                                    - E3           ULX00
     C*                                                                   ULX004
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
     C*                                                                   ULX004
     C                   END                                                    - E2
     C                   GOTO      ENDSEL
     C                   END                                                    - E1
     C*
     C** TYPE SELECTED
     C     DHTYPE        IFNE      *BLANKS                                      - B1
     C     DHTYPE        IFEQ      DSTYPE                                       - B2
     C*
     C     DHNARA        IFEQ      *BLANKS                                      - B3
     C     DHEXTY        ANDEQ     *BLANKS
     C     DHDEBI        ANDEQ     *BLANKS
     C     DHCRED        ANDEQ     *BLANKS
     C     DHPRCD        ANDEQ     *BLANKS                                                     ULX00
     C     DHPORT        ANDEQ     *BLANKS                                                     ULX00
     C                   MOVE      '1'           *IN10
     C                   END                                                    - E3
     C*
     C     DHEXTY        IFNE      *BLANKS                                      - B3
     C     DHEXTY        IFEQ      DSEXTY                                       - B4
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
     C     DHAMTY        IFNE      *BLANKS                                      - B3           ULX00
     C     DHAMTY        IFEQ      DSAMTY                                       - B4           ULX00
     C                   MOVE      '1'           *IN10                                         ULX00
     C                   ELSE                                                   - X4           ULX00
     C                   MOVE      '0'           *IN10                                         ULX00
     C                   GOTO      ENDSEL                                                      ULX00
     C                   END                                                    - E4           ULX00
     C                   END                                                    - E3           ULX00
     C*                                                                   ULX004
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
     C*                                                                   ULX004
     C                   END                                                    - E2
     C                   GOTO      ENDSEL
     C                   END                                                    - E1
     C*
     C** EXTRACT TYPE SELECTED
     C     DHEXTY        IFNE      *BLANKS                                      - B1
     C     DHEXTY        IFEQ      DSEXTY                                       - B2
     C*
     C     DHNARA        IFEQ      *BLANKS                                      - B3
     C     DHTYPE        ANDEQ     *BLANKS
     C     DHDEBI        ANDEQ     *BLANKS
     C     DHCRED        ANDEQ     *BLANKS
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
     C     DHAMTY        IFNE      *BLANKS                                      - B3           ULX00
     C     DHAMTY        IFEQ      DSAMTY                                       - B4           ULX00
     C                   MOVE      '1'           *IN10                                         ULX00
     C                   ELSE                                                   - X4           ULX00
     C                   MOVE      '0'           *IN10                                         ULX00
     C                   GOTO      ENDSEL                                                      ULX00
     C                   END                                                    - E4           ULX00
     C                   END                                                    - E3           ULX00
     C*                                                                   ULX004
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
     C*                                                                   ULX004
     C                   END                                                    - E2
     C                   GOTO      ENDSEL
     C                   END                                                    - E1
     C*
     C** RUBRIC DEBIT SELECTED
     C     DHDEBI        IFNE      *BLANKS                                      - B1
     C     DHDEBI        IFEQ      DSDEBI                                       - B2
     C*
     C     DHNARA        IFEQ      *BLANKS                                      - B3
     C     DHTYPE        ANDEQ     *BLANKS
     C     DHEXTY        ANDEQ     *BLANKS
     C     DHCRED        ANDEQ     *BLANKS
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
     C     DHAMTY        IFNE      *BLANKS                                      - B3           ULX00
     C     DHAMTY        IFEQ      DSAMTY                                       - B4           ULX00
     C                   MOVE      '1'           *IN10                                         ULX00
     C                   ELSE                                                   - X4           ULX00
     C                   MOVE      '0'           *IN10                                         ULX00
     C                   GOTO      ENDSEL                                                      ULX00
     C                   END                                                    - E4           ULX00
     C                   END                                                    - E3           ULX00
     C*                                                                   ULX004
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
     C*                                                                   ULX004
     C                   END                                                    - E2
     C                   GOTO      ENDSEL
     C                   END                                                    - E1
     C*
     C** RUBRIC CREDIT SELECTED
     C     DHCRED        IFNE      *BLANKS                                      - B1
     C     DHCRED        IFEQ      DSCRED                                       - B2
     C*
     C     DHNARA        IFEQ      *BLANKS                                      - B3
     C     DHTYPE        ANDEQ     *BLANKS
     C     DHEXTY        ANDEQ     *BLANKS
     C     DHDEBI        ANDEQ     *BLANKS
     C     DHPRCD        ANDEQ     *BLANKS                                                     ULX00
     C     DHPORT        ANDEQ     *BLANKS                                                     ULX00
     C                   MOVE      '1'           *IN10
     C                   END                                                    - E3
     C*
     C***********DHAMTY    IFNE *BLANKS                    - B3           ULX004
     C***********DHAMTY    IFEQ DSAMTY                     - B4           ULX004
     C     DHAMTY        IFNE      *BLANKS                                      - B3           ULX00
     C     DHAMTY        IFEQ      DSAMTY                                       - B4           ULX00
     C                   MOVE      '1'           *IN10                                         ULX00
     C                   ELSE                                                   - X4           ULX00
     C                   MOVE      '0'           *IN10                                         ULX00
     C                   GOTO      ENDSEL                                                      ULX00
     C                   END                                                    - E4           ULX00
     C                   END                                                    - E3           ULX00
     C*                                                                   ULX004
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
     C*                                                                   ULX004
     C                   END                                                    - E2
     C                   GOTO      ENDSEL                                                      ULX00
     C                   END                                                    - E1
      *
      ***Amount*Type*selected**********                                   ULX004
      **  Amount Type selected                                            ULX004
     C     DHAMTY        IFNE      *BLANKS                                      - B1           ULX00
     C     DHAMTY        IFEQ      DSAMTY                                       - B2           ULX00
     C     DHNARA        IFEQ      *BLANKS                                      - B3           ULX00
     C     DHTYPE        ANDEQ     *BLANKS                                                     ULX00
     C     DHEXTY        ANDEQ     *BLANKS                                                     ULX00
     C     DHDEBI        ANDEQ     *BLANKS                                                     ULX00
     C     DHCRED        ANDEQ     *BLANKS                                                     ULX00
     C     DHPORT        ANDEQ     *BLANKS                                                     ULX00
     C                   MOVE      '1'           *IN10                                         ULX00
     C                   END                                                    - E3           ULX00
     C                   END                                                    - E2           ULX00
     C                   GOTO      ENDSEL                                                      ULX00
     C                   END                                                    - E1           ULX00
      *                                                                   ULX004
      ** Product Code selected                                            ULX004
      *
     C***********DHAMTY    IFNE *BLANKS                    - B1           ULX004
     C***********DHAMTY    IFEQ DSAMTY                     - B2           ULX004
     C     DHPRCD        IFNE      *BLANKS                                      - B1           ULX00
     C     DHPRCD        IFEQ      DSPRCD                                       - B2           ULX00
      *
     C     DHNARA        IFEQ      *BLANKS                                      - B3
     C     DHTYPE        ANDEQ     *BLANKS
     C     DHEXTY        ANDEQ     *BLANKS
     C     DHDEBI        ANDEQ     *BLANKS
     C     DHCRED        ANDEQ     *BLANKS
     C     DHPORT        ANDEQ     *BLANKS                                                     ULX00
     C                   MOVE      '1'           *IN10
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
     C*                                                                   ULX004
     C                   END                                                    - E2
     C                   GOTO      ENDSEL                                                      ULX00
     C                   END                                                    - E1
      *                                                                   ULX004
      ** Portfolio Type selected.                                         ULX004
      *                                                                   ULX004
     C     DHPORT        IFNE      *BLANKS                                      - B1           ULX00
     C     DHPORT        IFEQ      DSPORT                                       - B2           ULX00
      *                                                                   ULX004
     C     DHNARA        IFEQ      *BLANKS                                      - B3           ULX00
     C     DHTYPE        ANDEQ     *BLANKS                                                     ULX00
     C     DHEXTY        ANDEQ     *BLANKS                                                     ULX00
     C     DHDEBI        ANDEQ     *BLANKS                                                     ULX00
     C     DHCRED        ANDEQ     *BLANKS                                                     ULX00
     C     DHPRCD        ANDEQ     *BLANKS                                                     ULX00
     C                   MOVE      '1'           *IN10                                         ULX00
     C                   END                                                    - E3           ULX00
     C*                                                                   ULX004
     C                   END                                                    - E2           ULX00
     C                   END                                                    - E1           ULX00
     C*
     C     ENDSEL        TAG
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
     C                   MOVEL     'ERLU30'      ZAPGM            10            Message queue
     C**********           MOVEL'ERUSRMSG'ZAMSGF 10        Message file                       CER001
     C                   MOVEL     'STUSRMSG'    ZAMSGF           10
     C                   MOVEL     *BLANK        ZAPGRL            5            Rel queue
     C                   MOVEL     *BLANK        ZAMSID            7            Message Id.
     C                   MOVEL     *BLANK        ZAMSDA          132            Message data.
     C                   MOVEL     *BLANK        ZAMSTP            7            Message type.
     C*
     C******               READ SDBANKPD                 88               ULX004
     C*
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
      *                                                                   ULX004
     C                   MOVE      *BLANKS       DHDEBI
     C                   MOVE      *BLANKS       DHCRED
     C                   MOVE      *BLANKS       WWDEBI
     C                   MOVE      *BLANKS       WWCRED
     C*
     C                   Z-ADD     0             DHACOD
     C                   Z-ADD     0             WWACOD            4 0
     C*
     C** SETUP 'ADD' OR 'AMEND' MODE
     C                   READ      ERLUACL1                               88
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
     C                   Z-ADD     25            I                 2 0
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
**CTDATA PORT
0123456789                                                                ULX004
**CTDATA AMTY
00 00 01 11 02 22 03 33 04 44 05 55 06 66 07 77 08 88 09 99 101112        ULX046
**CTDATA AMTY2
000000010101020202030303040404050505060606070707080808090909101112        ULX046
**CTDATA CPY@
(c) Finastra International Limited 2005
