     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*S*D****RPGBASEBND****************************************************                       CGP017
/*STD *  RPGBASEMOD                                                   *                       CGP017
/*EXI *  TEXT('Midas GP Fix global data')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPFIXGDTA - Fix Global Data                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGP017             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP017 - Global Layer - GOC0100 Task Split                   *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGPFIXDPD  IF   E           K DISK    INFSR(*PSSR)
     FGPGDRPPD  O  A F   70        DISK    INFSR(*PSSR) USROPN
 
 
     D #_SPOS          S              4  0 DIM(999)
     D #_EPOS          S              4  0 DIM(999)
     D #_FTYP          S              1    DIM(999)
     D Data            S              1    DIM(4000)
 
 
     D GPREPNLOG       DS             2
     D FixDiagnost             1      1
     D UpdDiagnost             2      2
 
 
     D TimeStampD      S             26A   INZ('0001-01-01-00.00.00.666000')
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#FILE           10
     C                   PARM                    IO#BUFFER      4000
 
     C     I#FILE        IFNE      Prev_FILE
     C                   EXSR      GET_FIELDS
     C                   ENDIF
 
     C     FixData       IFEQ      'Y'
 
     C                   MOVEA     IO#BUFFER     Data
     C                   Z-ADD     1             C
     C     #_SPOS(C)     DOUEQ     0
     C     #_SPOS(C)     SUB       1             SP                4 0
     C                   Z-ADD     #_EPOS(C)     EP                4 0
     C     #_FTYP(C)     CASEQ     'P'           PACKED
     C     #_FTYP(C)     CASEQ     'Z'           TIMESTAMP
     C                   ENDCS
     C                   ADD       1             C
     C                   ENDDO
     C                   MOVEA     Data          IO#BUFFER
 
     C                   ENDIF
 
     C                   EXSR      REP_DATA_REP
     C                   RETURN
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * PACKED
      *********************************************************************
     C     PACKED        BEGSR
 
     C                   Z-ADD     SP            Save_SP           4 0
     C                   MOVEL     'N'           BadData           1
 
      * Test if OK
 
     C                   MOVEA     Data(EP)      TEST_P            1
     C                   TESTB     '457'         TEST_P                   99
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     'Y'           BadData
     C                   ENDIF
 
     C                   ADD       1             SP
     C     SP            DOWLT     EP
     C     BadData       ANDEQ     'N'
     C                   MOVEA     Data(SP)      TEST_P
     C                   EXSR      TEST4_BAD_NUM
     C                   ADD       1             SP
     C                   ENDDO
 
      * Fix the bad data
 
     C     BadData       IFEQ      'Y'
     C                   EXSR      REP_BAD_DATA
     C                   Z-ADD     Save_SP       SP
     C     SP            DOWLT     EP
     C                   ADD       1             SP
     C                   BITOFF    '01234567'    Data(SP)
     C                   ENDDO
     C                   BITOFF    '0123'        Data(SP)
     C                   BITON     '4567'        Data(SP)
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * TEST FOR A BAD NUMBER
      *********************************************************************
     C     TEST4_BAD_NUM BEGSR
 
     C                   Z-ADD     *ZERO         TEST_CNT          2 0
 
     C                   TESTB     '0'           TEST_P                   90
     C     *IN90         IFEQ      *ON
     C                   ADD       8             TEST_CNT
     C                   ENDIF
 
     C                   TESTB     '1'           TEST_P                   90
     C     *IN90         IFEQ      *ON
     C                   ADD       4             TEST_CNT
     C                   ENDIF
 
     C                   TESTB     '2'           TEST_P                   90
     C     *IN90         IFEQ      *ON
     C                   ADD       2             TEST_CNT
     C                   ENDIF
 
     C                   TESTB     '3'           TEST_P                   90
     C     *IN90         IFEQ      *ON
     C                   ADD       1             TEST_CNT
     C                   ENDIF
 
     C     TEST_CNT      IFGT      9
     C                   MOVEL     'Y'           BadData
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * TIMESTAMP
      *********************************************************************
     C     TIMESTAMP     BEGSR
 
      * Test if OK
 
     C                   ADD       1             SP
     C                   MOVEA     Data(SP)      TEST_Z5           5
     C                   MOVEL     TEST_Z5       TEST_Z4           4
     C                   MOVE      TEST_Z5       TEST_Z1           1
 
     C                   TESTN                   TEST_Z4              99
     C   99              MOVEL     TEST_Z4       TEST_Z4N          4 0
     C  N99              Z-ADD     0             TEST_Z4N
 
     C     TEST_Z4N      IFLT      1990
     C     TEST_Z4N      ANDNE     1
     C     TEST_Z4N      ORGT      2072
     C     TEST_Z1       ORNE      '-'
     C                   MOVEA     TimeStampD    Data(SP)
     C                   EXSR      REP_BAD_DATA
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * REPORT BAD DATA
      *********************************************************************
     C     REP_BAD_DATA  BEGSR
     C     FixDiagnost   IFEQ      'Y'
     C     File_Open     IFNE      'Y'
     C                   MOVEL     'Y'           File_Open         1
     C                   OPEN      GPGDRPPD
     C                   ENDIF
     C                   EXCEPT    O_BAD_DATA
     C                   ENDIF
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * REPORT DATA REPLICATED
      *********************************************************************
     C     REP_DATA_REP  BEGSR
     C     UpdDiagnost   IFEQ      'Y'
     C     File_Open     IFNE      'Y'
     C                   MOVEL     'Y'           File_Open         1
     C                   OPEN      GPGDRPPD
     C                   ENDIF
     C                   MOVEL     IO#BUFFER     PartialDATA      50
     C                   EXCEPT    O_DATA_REP
     C                   ENDIF
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * GET FIELDS
      *********************************************************************
     C     GET_FIELDS    BEGSR
 
     C                   MOVEL     I#FILE        Prev_FILE        10
     C                   MOVEL     'N'           FixData           1
 
     C                   Z-ADD     0             C                 4 0
     C                   MOVE      *BLANK        #_FTYP
     C                   Z-ADD     *ZERO         #_SPOS
     C                   Z-ADD     *ZERO         #_EPOS
 
     C     GPFIXDK       SETLL     GPFIXDD0
     C     GPFIXDK       READE     GPFIXDD0                               99
     C     *IN99         DOWEQ     *OFF
     C                   MOVEL     'Y'           FixData
     C                   ADD       1             C
     C                   MOVEL     FDFTYP        #_FTYP(C)
     C                   MOVEL     FDSPOS        #_SPOS(C)
     C                   MOVEL     FDEPOS        #_EPOS(C)
     C     GPFIXDK       READE     GPFIXDD0                               99
     C                   ENDDO
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVE      *BLANK        I#RTCD            7
     C                   MOVE      *BLANK        I#ERMS           50
 
      * Get replication diagnostics status
 
     C     *DTAARA       DEFINE                  GPREPNLOG
     C     *LOCK         IN        GPREPNLOG
     C                   OUT       GPREPNLOG
 
      * Key lists
 
     C     GPFIXDK       KLIST
     C                   KFLD                    I#ZONE
     C                   KFLD                    I#FILE
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
     OGPGDRPPD  EADD         O_DATA_REP
     O                       I#ZONE              10
     O                       I#FILE              20
     O                       PartialDATA         70
     O          EADD         O_BAD_DATA
     O                       I#ZONE              10
     O                       I#FILE              20
     O                                           22 '!'
     O                       #_FTYP(C)           24
     O                       #_SPOS(C)     Z     32
     O                       #_EPOS(C)     Z     38
