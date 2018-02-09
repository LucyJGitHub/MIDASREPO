     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Report Layout Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0013 - Report Layout Maintenance                         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGPAU0013DFCF   E             WORKSTN
     FGPAUFDL3  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPAUFDD0:GPAUFDDS)
     FGPAUFDL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GPAUFDD0:GPAUFDDL)
     FGPAURNL1  UF A E           K DISK    INFSR(*PSSR)
 
     D S131            S              1    DIM(131)
     D TOT             S            132    DIM(150)
     D BLK             S              1    DIM(132)
     D LIN             S              1    DIM(132) ASCEND
     D SLIN            S              1    DIM(132) ASCEND
 
     D CT              S              1    DIM(131) CTDATA PERRCD(80)
     D ERR             S             76    DIM(15) CTDATA PERRCD(1)
 
     D                 DS
     D  SS_DATA                1    128
     D  SSEDTW                99    124
     D  SSEDTS               125    128  0
 
     D                 DS
     D  AF_DATA                1    128
     D  AFFDES                11     40
     D  AFTYPE                41     41
     D  AFDIG                 42     45  0
     D  AFDEC                 46     47  0
     D  AFCOL1                48     64
     D  AFCOL2                65     81
     D  AFCOL3                82     98
     D  AFEDTW                99    124
     D  AFEDTS               125    128  0
 
     D                 DS
     D  SC                     1   1965
     D                                     DIM(15)
     D  SC1                    1    131
     D  SC2                  132    262
     D  SC3                  263    393
     D  SC4                  394    524
     D  SC5                  525    655
     D  SC6                  656    786
     D  SC7                  787    917
     D  SC8                  918   1048
     D  SC9                 1049   1179
     D  SC10                1180   1310
     D  SC11                1311   1441
     D  SC12                1442   1572
     D  SC13                1573   1703
     D  SC14                1704   1834
     D  SC15                1835   1965
     D                 DS
     D  FMLPA                  1      6
     D  FMLNA                  1      2
     D  FMPSA                  4      6
     D                 DS
     D  TOLPA                  1      6
     D  TOLNA                  1      2
     D  TOPSA                  4      6
     D                 DS
     D  FMLP                   1      6  0
     D  FMLN                   1      3  0
     D  FMPS                   4      6  0
     D  FMSNAM                 7     16
     D                 DS
     D  TOLP                   1      6  0
     D  TOLN                   1      3  0
     D  TOPS                   4      6  0
 
     D PSDS           SDS
     D  ERROR            *STATUS
     D  WKSID                244    253
     D  USRID                254    263
 
     C* INITIAL PROCESSING
 
     C                   EXSR      INIT
 
     C** LOAD UP DETAILS ON FROM GPAUFDPD AND GPAURNPD
 
     C                   Z-ADD     1             HISCRN            2 0
     C                   EXSR      RPLOAD
     C                   Z-ADD     1             SCRCNT
 
     C* SCREEN HEADING
 
     C                   MOVEA     CT            CTX
 
     C** GET DETAILS FOR OUPUT TO SCREEN
 
     C                   Z-ADD     1             AFLN                           *LINE NO.
     C                   EXSR      PREP_SCRN
 
     C* NON-DISPLAY FROM/TO LINES/POSITIONS
 
     C                   MOVEA     '11'          *IN(21)
 
     C* DISPLAY THE SCREEN
 
     C                   Z-ADD     99            ER                2 0
     C     ER            DOWNE     *ZERO
     C                   EXSR      DSPLAY
     C                   END
 
     C                   SETON                                        LR
 
      /SPACE 5
      ********************************************************************
      * Display screen
      ********************************************************************
     C     DSPLAY        BEGSR
     C                   EXSR      EDTFAT
     C                   WRITE     MAIN
     C                   READ      MAIN                                   99    *
     C* CK/3
     C     *INKC         IFEQ      '1'
     C                   MOVEL     'EXIT  '      RETC
     C                   Z-ADD     *ZERO         ER
     C                   ELSE
     C* CK/10
     C     *INKJ         IFEQ      '1'
     C                   Z-ADD     *ZERO         FMLP
     C                   Z-ADD     *ZERO         TOLP
     C                   MOVEA     '11'          *IN(21)
     C                   Z-ADD     99            ER
     C                   ELSE
     C* CK/12
     C     *INKL         IFEQ      '1'
     C                   EXSR      UPDFIL
     C                   MOVEL     'ABAND '      RETC
     C                   Z-ADD     *ZERO         ER
     C                   ELSE
 
     C** ROLL UP
 
     C     *IN05         IFEQ      '1'
     C                   ADD       1             SCRCNT            2 0
     C     SCRCNT        IFGT      10
     C                   Z-ADD     1             SCRCNT
     C                   END
     C                   END
 
     C** ROLL DOWN
 
     C     *IN06         IFEQ      '1'
     C                   SUB       1             SCRCNT
     C     SCRCNT        IFEQ      *ZERO
     C                   Z-ADD     HISCRN        SCRCNT
     C                   END
     C                   END
 
     C* ROLL UP OR DOWN
 
     C     *IN05         IFEQ      '1'
     C     *IN06         OREQ      '1'
 
     C* GET SCREEN FOR NEW SCREEN NUMBER
 
     C     SCRCNT        SUB       1             AFLN
     C                   MULT      15            AFLN
     C                   ADD       1             AFLN
     C                   EXSR      PREP_SCRN
     C                   Z-ADD     99            ER
     C* ENTER
     C                   ELSE
     C                   EXSR      VALDSP
     C     *INKF         IFEQ      '1'
     C                   EXSR      UPDFIL
     C                   Z-ADD     *ZERO         ER
     C                   ELSE
     C  NKC              Z-ADD     99            ER
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate display
      ********************************************************************
     C     VALDSP        BEGSR
 
     C* START LINE OF THIS SCREEN
 
     C     SCRCNT        SUB       1             AFLN
     C                   MULT      15            AFLN
     C                   ADD       1             AFLN
 
     C* TAKE SCREEN & UPDATE TOTAL
 
     C                   EXSR      UPDTOT
 
     C* START LINE OF THIS SCREEN
 
     C     SCRCNT        SUB       1             AFLN
     C                   MULT      15            AFLN
     C                   ADD       1             AFLN
 
     C* END LINE OF THIS SCREEN
 
     C                   Z-ADD     SCRCNT        ELN               2 0
     C                   MULT      15            ELN
 
     C* PROCESS EACH LINE ON THIS SCREEN
 
     C     AFLN          DOUGT     ELN
     C                   MOVEA     TOT(AFLN)     LIN
     C                   EXSR      PROLIN
     C                   ADD       1             AFLN
     C                   END
 
     C* IF FROM & TO POINT PRESENT PROCESS MOVE
 
     C     FMLP          IFNE      *ZERO
     C     TOLP          ANDNE     *ZERO
     C                   EXSR      PROMOV
     C                   END
 
     C* START LINE OF THIS SCREEN
 
     C     SCRCNT        SUB       1             AFLN
     C                   MULT      15            AFLN
     C                   ADD       1             AFLN
 
     C* TAKE NEW TOTAL AND UPDATE SCREEN
 
     C                   EXSR      PREP_SCRN
 
     C* IF ACTION SELECTED THEN PROCESS ACTION SCREEN
 
     C     ACSNAM        IFNE      *BLANK
     C                   EXSR      PROACT
     C                   END
 
     C* FROM OR TO POINTS DEFINED
 
     C     FMLP          COMP      *ZERO                                  21    *
     C     TOLP          COMP      *ZERO                                  22    *
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Prepare screen
      ********************************************************************
     C     PREP_SCRN     BEGSR
 
     C                   Z-ADD     1             CNT               2 0          *COUNT
     C     CNT           DOUGT     15
     C                   MOVEA     TOT(AFLN)     LIN
 
     C* SET SCREEN FIELDS
 
     C                   MOVEA     LIN           S131
     C                   MOVEA     S131          SC(CNT)
     C                   ADD       1             CNT
     C                   ADD       1             AFLN
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Update total screen
      ********************************************************************
     C     UPDTOT        BEGSR
 
     C                   Z-ADD     1             CNT                            *COUNT
     C     CNT           DOUGT     15
     C                   MOVEA     TOT(AFLN)     LIN
     C                   MOVEL     SC(CNT)       WK131           131
     C                   MOVEA     WK131         LIN
     C                   MOVEA     LIN           TOT(AFLN)
     C                   ADD       1             CNT
     C                   ADD       1             AFLN
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Report load
      ********************************************************************
     C     RPLOAD        BEGSR
 
     C* GET FIELDS
 
     C     GPAUFLK       SETLL     GPAUFDDL
     C     GPAUFLK       READE     GPAUFDDL                               99    *
 
     C* DO WHILE NOT EOF
 
     C     *IN99         DOWEQ     '0'
 
     C                   EXSR      FMTF
 
     C* HIGHEST LINE/SCREEN?
 
     C                   EXSR      DETHIL
     C     GPAUFLK       READE     GPAUFDDL                               99    *
     C                   END
 
     C* GET NARRATIVE
 
     C     GPAUFLK       SETLL     GPAURND0
     C     GPAUFLK       READE     GPAURND0                               99    *
 
     C* DO WHILE NOT EOF
 
     C     *IN99         DOWEQ     '0'
 
     C                   EXSR      FMTN
 
     C* HIGHEST LINE/SCREEN?
 
     C                   EXSR      DETHIL
     C     GPAUFLK       READE     GPAURND0                               99    *
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Determine highest line
      ********************************************************************
     C     DETHIL        BEGSR
     C     AFLN          IFGT      HLN
     C                   Z-ADD     AFLN          HLN               2 0
     C                   SELECT
     C     HLN           WHENLE    15
     C                   Z-ADD     1             HISCRN
     C     HLN           WHENLE    30
     C                   Z-ADD     2             HISCRN
     C     HLN           WHENLE    45
     C                   Z-ADD     3             HISCRN
     C     HLN           WHENLE    60
     C                   Z-ADD     4             HISCRN
     C     HLN           WHENLE    75
     C                   Z-ADD     5             HISCRN
     C     HLN           WHENLE    90
     C                   Z-ADD     6             HISCRN
     C     HLN           WHENLE    105
     C                   Z-ADD     7             HISCRN
     C     HLN           WHENLE    120
     C                   Z-ADD     8             HISCRN
     C     HLN           WHENLE    135
     C                   Z-ADD     9             HISCRN
     C                   OTHER
     C                   Z-ADD     10            HISCRN
     C                   ENDSL
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Format field
      ********************************************************************
     C     FMTF          BEGSR
 
     C* START POINT
 
     C                   Z-ADD     AFPS          X                 3 0
 
     C* GET LINE
 
     C                   MOVEA     TOT(AFLN)     LIN
 
     C* RPG FIELD DELINEATOR (POSITION BEFORE RPG FIELD)
 
     C                   SUB       1             X
     C                   MOVE      STRC          LIN(X)
     C                   ADD       1             X
 
     C* END POINT
 
     C     X             ADD       AFEDTS        Y                 3 0
     C     X             DOUEQ     Y
     C                   MOVE      *BLANK        LIN(X)
     C                   ADD       1             X
     C                   END
 
     C* END CHAR
 
     C     X             IFLE      132
     C     LIN(X)        IFNE      '?'
     C     LIN(X)        ANDNE     '-'
     C     LIN(X)        ANDNE     '='
     C                   MOVE      ENDC          LIN(X)
     C                   END
     C                   END
     C* UPDATE
     C                   MOVEA     LIN           TOT(AFLN)
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Format narrative
      ********************************************************************
     C     FMTN          BEGSR
 
     C* START POINT
 
     C                   Z-ADD     AFPS          X                 3 0
 
     C* GET LINE
 
     C                   MOVEA     TOT(AFLN)     SLIN
     C                   MOVEA     TOT(AFLN)     LIN
 
     C* DESCRIPTION
 
     C                   MOVEA     AFNARR        LIN(X)
 
     C* END POINT
 
     C                   ADD       AFDIG         X
     C     X             IFLE      132
     C                   MOVEA     SLIN(X)       LIN(X)
     C                   END
     C* UPDATE
     C                   MOVEA     LIN           TOT(AFLN)
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Process line
      ********************************************************************
     C     PROLIN        BEGSR
 
     C* CLEAR START & END CHARACTERS FROM LINE BEING PROCESSED
 
     C                   EXSR      CLSTRC
     C                   EXSR      CLENDC
 
     C* UPDATE TOTAL
 
     C                   MOVEA     LIN           TOT(AFLN)
 
      * FIRST RESTORE FIELDS FROM GPAUFDPD
      * & LOOK FOR 'FROM' LINE (-) OR 'ACTION' (?)
 
     C* (READ EQUAL WITHIN FILE AND LINE)
 
     C     GPAUFDXK      SETLL     GPAUFDDL
     C     GPAUFDXK      READE     GPAUFDDL                               99    *
     C     *IN99         DOWEQ     '0'
 
     C* 'FROM' LINE?
     C* POSITION,FIELD NO.
 
     C     AFPS          SUB       1             X
     C     LIN(X)        IFEQ      '-'
     C     FMLP          ANDEQ     *ZERO
     C                   Z-ADD     AFLN          FMLN
     C                   Z-ADD     AFPS          FMPS
     C                   MOVEL     AFSNAM        FMSNAM
     C                   END
     C     LIN(X)        IFEQ      '?'
     C     ACSNAM        ANDEQ     *BLANK
     C                   MOVEL     AFSNAM        ACSNAM           10
     C                   END
     C                   EXSR      FMTF
     C     GPAUFDXK      READE     GPAUFDDL                               99    *
     C                   END
 
     C* LOOK FOR FIELDS TO BE INSERTED (?)
 
     C     *IN99         DOUEQ     '0'
     C                   Z-ADD     1             AFPS
     C     '?'           LOOKUP    LIN(AFPS)                              99    *
     C     *IN99         IFEQ      '1'
     C     ACSNAM        IFEQ      *BLANK
     C     AFPS          ANDLT     132
     C                   MOVEL     '?'           ACSNAM
     C                   Z-ADD     AFLN          ILN               3 0
     C     AFPS          ADD       1             IPS               3 0
     C                   END
     C                   MOVE      *BLANK        LIN(AFPS)
     C                   END
     C                   END
 
     C* NOW LOOK FOR 'TO' LINE (=)
 
     C     *IN99         DOUEQ     '0'
     C                   Z-ADD     1             AFPS
     C     '='           LOOKUP    LIN(AFPS)                              99    *
     C     *IN99         IFEQ      '1'
     C     TOLP          IFEQ      *ZERO
     C                   Z-ADD     AFLN          TOLN
     C     AFPS          ADD       1             TOPS
     C                   END
     C                   MOVE      *BLANK        LIN(AFPS)
     C                   END
     C                   END
 
     C* CLEAR OUT ANY EXTRA FROM LINES (-)
 
     C     *IN99         DOUEQ     '0'
     C                   Z-ADD     1             AFPS
     C     '-'           LOOKUP    LIN(AFPS)                              99    *
     C     *IN99         IFEQ      '1'
     C                   MOVE      *BLANK        LIN(AFPS)
     C                   END
     C                   END
 
     C* UPDATE TOTAL
 
     C                   MOVEA     LIN           TOT(AFLN)
 
     C* NOW RESTORE FIELDS FROM GPAUFDPD AGAIN
 
     C     GPAUFDXK      SETLL     GPAUFDDL
     C     GPAUFDXK      READE     GPAUFDDL                               99    *
     C     *IN99         DOWEQ     '0'
     C                   EXSR      FMTF
     C     GPAUFDXK      READE     GPAUFDDL                               99    *
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Process movement
      ********************************************************************
     C     PROMOV        BEGSR
 
     C* PROCESS MOVEMENT OF FIELD
 
     C                   MOVEL     FMSNAM        AFSNAM
     C     GPAUFDK       CHAIN     GPAUFDDS                           99
 
     C                   Z-ADD     AFLN          OLLN              3 0          OLD LINE
     C                   Z-ADD     AFPS          OLPS              3 0          OLD POSITION
 
     C                   Z-ADD     TOLN          AFLN                           NEW LINE
     C                   Z-ADD     TOPS          AFPS                           NEW POSITION
     C     TOPS          ADD       AFEDTS        NWEP              3 0          NEW END POSITION
     C                   SUB       1             NWEP
 
     C* CHECK THAT THE FIELD WILL NOT NOW OVERLAP ANOTHER FIELD
     C* (UNLESS THAT FIELD IS THE SAME FIELD BUT IN ITS OLD POSITION)
 
     C                   MOVEA     TOT(AFLN)     LIN
     C     AFPS          ADD       1             Y
     C     Y             IFLE      132
     C     STRC          LOOKUP    LIN(Y)                                 99    *
     C     *IN99         IFEQ      '1'
     C                   ADD       1             Y
     C     AFLN          IFEQ      OLLN
     C     Y             ANDEQ     OLPS
     C                   MOVE      '0'           *IN99
     C                   END
     C                   SUB       1             Y
     C                   END
     C                   END
 
     C* RELEASE GPAUFDPD IF START POSN IS 1 OR END POSN IS BEYOND END OF LINE
     C*               OR IF FIELD OVERLAPS ANOTHER FIELD
 
     C     AFPS          IFEQ      1                                            B1
     C     NWEP          ORGT      132
     C     *IN99         OREQ      '1'
     C     Y             ANDLE     NWEP
     C                   EXCEPT    FLDREL                                       * RELEASE
     C                   ELSE                                                   X1
 
     C* UPDATE START AND END POSITION ON GPAUFDPD
 
     C                   EXCEPT    FLDUPD                                       * UPDATE
     C                   END                                                    E1
 
     C* CLEAR START & END CHARACTERS ON 'FROM LINE'
 
     C                   Z-ADD     FMLN          AFLN
     C                   MOVEA     TOT(AFLN)     LIN
     C                   EXSR      CLSTRC
     C                   EXSR      CLENDC
     C                   MOVEA     LIN           TOT(AFLN)
 
     C* RESTORE FIELDS FROM GPAUFDPD ON 'FROM LINE'
 
     C     GPAUFDXK      SETLL     GPAUFDDL
     C     GPAUFDXK      READE     GPAUFDDL                               99    *
     C     *IN99         DOWEQ     '0'
     C                   EXSR      FMTF
     C     GPAUFDXK      READE     GPAUFDDL                               99    *
     C                   END
 
     C* CLEAR START & END CHARACTERS ON 'TO LINE'
 
     C                   Z-ADD     TOLN          AFLN
     C                   MOVEA     TOT(AFLN)     LIN
     C                   EXSR      CLSTRC
     C                   EXSR      CLENDC
     C                   MOVEA     LIN           TOT(AFLN)
 
     C* RESTORE FIELDS FROM GPAUFDPD ON 'TO LINE'
 
     C     GPAUFDXK      SETLL     GPAUFDDL
     C     GPAUFDXK      READE     GPAUFDDL                               99    *
     C     *IN99         DOWEQ     '0'
     C                   EXSR      FMTF
     C     GPAUFDXK      READE     GPAUFDDL                               99    *
     C                   END
 
     C* RESET FROM AND TO LINE/POSITION
 
     C                   Z-ADD     *ZERO         FMLP
     C                   MOVEL     *BLANK        FMSNAM
     C                   Z-ADD     *ZERO         TOLP
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Process action
      ********************************************************************
     C     PROACT        BEGSR
 
     C* CLEAR SCREEN
 
     C                   MOVEA     '000'         *IN(41)
     C                   MOVEA     '00'          *IN(71)
     C                   WRITE     CLEAR
 
     C** GET FIELD DETAILS (IF PRESENT)
 
     C                   MOVEL     ACSNAM        AFSNAM
     C                   MOVE      *BLANK        AF_DATA
     C     GPAUFDK       CHAIN     GPAUFDDS                           90        *
     C                   MOVEL     AF_DATA       SS_DATA
 
     C* SET ACTION CODE
 
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'I'           SSACTN
     C                   MOVE      '1'           *IN(71)                        *PROTECT ACTN
     C                   ELSE
     C                   MOVEL     'A'           SSACTN
     C                   MOVE      '1'           *IN(72)                        *PROTECT AFSNAM
     C                   END
 
     C* DETERMINE FORMAT
 
     C                   EXSR      DETFMT
 
     C** DO WHILE NOT CK/3, CK/12 AND ENTER WITH ERRORS
 
     C                   Z-ADD     99            ER
     C                   MOVEL     *BLANK        DDERR
     C     ER            DOWNE     *ZERO
 
     C** OUTPUT ACTION SCREEN
 
     C                   WRITE     MESSAG
     C                   EXFMT     ACTION
     C                   Z-ADD     *ZERO         ER
     C                   MOVEL     *BLANK        DDERR
     C* CK/3
     C     *INKC         IFEQ      '1'
     C                   MOVEL     'EXIT  '      RETC
     C                   ELSE
 
     C* VALIDATE ACTION DETAILS
 
     C  NKL              EXSR      VALACT
     C                   END
     C                   END
     C                   MOVEL     *BLANK        ACSNAM
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Validate action
      ********************************************************************
     C     VALACT        BEGSR
     C                   MOVEA     '000'         *IN(41)
 
     C** VALIDATE ACTION CODE
 
     C     SSACTN        IFNE      'I'
     C     SSACTN        ANDNE     'E'
     C     SSACTN        ANDNE     'A'
     C     SSACTN        ANDNE     'D'
     C     ER            IFEQ      0
     C                   Z-ADD     1             ER
     C                   END
     C                   MOVE      '1'           *IN41
     C                   END
 
     C** VALIDATE SHORTNAME (IF INSERT)
 
     C     *IN72         IFEQ      '0'                                          B1
 
     C* DISPLAY REPORT FIELDS IF DESIRED
 
     C     AFSNAM        IFEQ      '?'                                          B2
     C                   CALL      'GPAU0014'                           9999    *
     C                   PARM      *BLANK        RETC
     C                   PARM                    I#RECD_TYPE       3
     C                   PARM                    AFFILE
     C                   PARM                    AFRCID
     C                   PARM      *BLANK        AFSNAM
     C                   EXSR      CHKERR
     C     RETC          IFEQ      'EXIT  '
     C                   MOVE      '1'           *INKC
     C                   Z-ADD     *ZERO         ER
     C                   GOTO      EVALAC
     C                   END
     C                   END                                                    E2
 
     C* SHORTNAME MUST EXIST ON GPAUFDPD WITH AFLN = ZERO
 
     C                   MOVEL     *BLANK        AF_DATA
     C     GPAUFDK       CHAIN     GPAUFDDS                           99
     C                   MOVEL     AF_DATA       SS_DATA
     C     *IN99         IFEQ      '1'                                          B2
     C     AFLN          ORNE      *ZERO
     C     ER            IFEQ      0
     C                   Z-ADD     2             ER
     C                   END
     C                   MOVE      '1'           *IN42
     C                   END                                                    E2
 
     C* DETERMINE FORMAT
 
     C                   EXSR      DETFMT
 
     C* LINE/POSITION FOR INSERTS
 
     C                   Z-ADD     ILN           AFLN
     C                   Z-ADD     IPS           AFPS
     C* NOT INSERT
     C                   ELSE                                                   X1
     C                   Z-ADD     AFLN          ILN
     C     SSACTN        IFEQ      'I'                                          B2
     C                   MOVEL     'A'           SSACTN
     C                   END                                                    E2
     C                   END                                                    E1
 
     C* EDIT WORD VALIDATION
 
     C                   CALLB     'GPAUEDWVL'
     C                   PARM      AFFILE        I#FILE           10
     C                   PARM      AFRCID        I#RCID           15
     C                   PARM      SSEDTW        I#EDTW           26
     C                   PARM      AFTYPE        I#TYPE            1
     C                   PARM      AFDIG         I#DIG             4 0
     C                   PARM      AFDEC         I#DEC             2 0
     C                   PARM      AFFDES        I#FDES           30
     C                   PARM                    O#VERR           50
     C                   PARM                    O#EDTS            4 0
      * ERRORS
     C     ER            IFEQ      0
     C                   SELECT
     C     O#VERR        WHENEQ    'ALPHAMERIC'
     C                   Z-ADD     3             ER                   43
     C     O#VERR        WHENEQ    'NUMERIC'
     C                   Z-ADD     4             ER                   43
     C     O#VERR        WHENEQ    'DAYNUMBER'
     C                   Z-ADD     5             ER                   43
     C     O#VERR        WHENEQ    'BASECCY'
     C                   Z-ADD     6             ER                   43
     C     O#VERR        WHENEQ    'MISSING'
     C                   Z-ADD     7             ER                   43
     C     O#VERR        WHENEQ    'CHARACTERS_T'
     C                   Z-ADD     8             ER                   43
     C     O#VERR        WHENEQ    'INVCHARACTER'
     C                   Z-ADD     9             ER                   43
     C     O#VERR        WHENEQ    'ONE0ONLY'
     C                   Z-ADD     10            ER                   43
     C     O#VERR        WHENEQ    'FIELDSIZE'
     C                   Z-ADD     11            ER                   43
     C     O#VERR        WHENEQ    'CHARACTERS_F'
     C                   Z-ADD     12            ER                   43
     C     O#VERR        WHENEQ    'INVALIDFIELD'
     C                   Z-ADD     13            ER                   43
     C                   ENDSL
     C                   ENDIF
      * Edit Word
     C                   MOVEL     I#EDTW        SSEDTW
      * Edit Size
     C                   Z-ADD     O#EDTS        SSEDTS
 
     C* ENSURE END POSITION OF FIELD IS NOT BEYOND THE END OF PAGE
 
     C     AFPS          ADD       SSEDTS        Y
     C                   SUB       1             Y
     C     Y             IFGT      132
     C     ER            IFEQ      0
     C                   Z-ADD     14            ER
     C                   END
     C                   MOVE      '1'           *IN43
     C                   END
 
     C* ENSURE THIS FIELD DOES NOT OVERLAP ANY OTHER FIELD ON THIS LINE
 
     C                   MOVEA     TOT(AFLN)     LIN
     C     AFPS          ADD       1             X
     C     X             IFLE      132
     C     STRC          LOOKUP    LIN(X)                                 99    *
     C     *IN99         IFEQ      '1'
     C     X             ANDLE     Y
     C     ER            IFEQ      0
     C                   Z-ADD     15            ER
     C                   END
     C                   MOVE      '1'           *IN43
     C                   END
     C                   END
 
     C* IF ERROR, OUTPUT MESSAGE
 
     C     ER            IFNE      *ZERO                                        *B1
     C                   MOVEA     ERR(ER)       DDERR
     C                   ELSE                                                   *X1
 
     C** ELSE UPDATE RPG FIELD (IF INSERT, AMEND OR DELETE)
 
     C     SSACTN        IFEQ      'I'                                          *B2
     C     SSACTN        OREQ      'A'
     C     SSACTN        OREQ      'D'
 
     C* ACCESS FIELD RECORD
 
     C     GPAUFDK       CHAIN     GPAUFDDS                           90        *
 
     C* DELETE
 
     C     SSACTN        IFEQ      'D'                                          *B3
     C                   Z-ADD     99999         AFRSEQ
     C                   Z-ADD     *ZERO         AFLN
     C                   Z-ADD     *ZERO         AFPS
     C                   END                                                    *E3
 
     C* INSERT
 
     C     SSACTN        IFEQ      'I'                                          *B3
     C                   Z-ADD     99998         AFRSEQ
     C                   Z-ADD     ILN           AFLN
     C                   Z-ADD     IPS           AFPS
     C                   END                                                    *E3
 
     C* UPDATE FIELD RECORD
 
     C  N90              MOVEL     SS_DATA       AF_DATA
     C  N90              EXCEPT    FLDUPD
 
     C* CLEAR START & END CHARACTERS FROM LINE JUST PROCESSED
 
     C                   Z-ADD     ILN           AFLN
     C                   MOVEA     TOT(AFLN)     LIN
     C                   EXSR      CLSTRC
     C                   EXSR      CLENDC
     C                   MOVEA     LIN           TOT(AFLN)
 
     C* RESTORE FIELDS FROM GPAUFDPD FOR LINE JUST PROCESSED
 
     C     GPAUFDXK      SETLL     GPAUFDDL
     C     GPAUFDXK      READE     GPAUFDDL                               99    *
     C     *IN99         DOWEQ     '0'
     C                   EXSR      FMTF
     C     GPAUFDXK      READE     GPAUFDDL                               99    *
     C                   END
 
     C* TAKE NEW TOTAL AND UPDATE SCREEN
 
     C* START LINE OF THIS SCREEN
 
     C     SCRCNT        SUB       1             AFLN
     C                   MULT      15            AFLN
     C                   ADD       1             AFLN
     C                   EXSR      PREP_SCRN
     C                   END                                                    *E2
     C                   END                                                    *E1
 
     C     EVALAC        ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Update file
      ********************************************************************
     C     UPDFIL        BEGSR
 
     C** READ THROUGH TOTAL ARRAY & OUTPUT NARRATIVE TO GPAURNPD
 
     C                   Z-ADD     *ZERO         AFLN
     C                   Z-ADD     *ZERO         AFFLDN
 
     C** PROCESS ALL LINES
 
     C     AFLN          DOUEQ     150
     C                   ADD       1             AFLN
     C                   MOVEA     TOT(AFLN)     LIN
 
     C** FIRST REPLACE ALL RPG FIELDS WITH START CHARACTER (HIGH INTENS.)
 
     C                   Z-ADD     1             X
     C     *IN99         DOUEQ     '0'
     C     X             IFLT      132
     C     STRC          LOOKUP    LIN(X)                                 99    *
     C                   ELSE
     C                   MOVE      '0'           *IN99
     C                   END
     C     *IN99         IFEQ      '1'
     C     *IN99         DOUEQ     '1'
     C     LIN(X)        COMP      ENDC                                   99    *
     C                   MOVE      STRC          LIN(X)
     C     X             IFLT      132
     C                   ADD       1             X
     C                   ELSE
     C                   MOVE      '1'           *IN99
     C                   END                                                    * X < 132
     C                   END                                                    * *IN99 DOUEQ '1'
     C                   END                                                    * *IN99 IFEQ '1'
     C                   END                                                    * *IN99 DOUEQ '0'
 
     C* PROCESS EVERY CHARACTER OF LINE
 
     C                   Z-ADD     1             X
     C     X             DOUGT     132
 
     C** NOW LOOK FOR NARRATIVE
 
     C     ' '           LOOKUP    LIN(X)                             99        *
     C     *IN99         IFEQ      '1'
     C                   MOVE      *BLANK        SLIN
     C                   MOVEA     LIN(X)        SLIN
     C                   Z-ADD     AFLN          SLN               3 0           SAVE:LINE
     C                   Z-ADD     X             SPS               3 0                POSITION
 
     C** GO TO NEXT INPUT FIELD,IF PRESENT, AND BLANK OUT BEYOND IT
 
     C                   Z-ADD     1             Y
     C     STRC          LOOKUP    SLIN(Y)                                99    *
     C   99              MOVEA     BLK           SLIN(Y)
 
     C* DETERMINE LENGTH OF NARRATIVE
 
     C                   Z-ADD     132           Y
     C                   Z-ADD     132           SAFDIG            4 0
     C     Y             DOUEQ     *ZERO
     C     SLIN(Y)       IFEQ      *BLANK
     C                   SUB       1             Y
     C                   SUB       1             SAFDIG                         *LENGTH
     C                   ELSE
     C                   Z-ADD     *ZERO         Y
     C                   END
     C                   END
     C     SAFDIG        IFGT      24
     C                   Z-ADD     24            SAFDIG
     C                   END
     C                   ADD       SAFDIG        X
 
     C** GET NEXT NARRATIVE RECORD AND UPDATE IT
 
     C                   ADD       1             AFFLDN
     C     GPAURNK       CHAIN     GPAURND0                           90        *
     C                   MOVEA     SLIN          AFNARR                         * NARRATIVE
     C                   Z-ADD     SAFDIG        AFDIG                          * DIGITS (SIZE)
     C                   Z-ADD     SLN           AFLN                           * LINE
     C                   Z-ADD     SPS           AFPS                           * POSITION
     C  N90              UPDATE    GPAURND0
     C   90              WRITE     GPAURND0
     C                   ELSE
     C                   Z-ADD     133           X
     C                   END                                                    * *IN99 IFEQ '1'
     C                   END                                                    * X DO> 132
     C                   END                                                    * AFLN DO=150
 
     C** NOW GET RID OF REDUNDANT NARRATIVE RECORDS
 
     C                   ADD       1             AFFLDN
     C     GPAURNK       SETLL     GPAURND0
     C     GPAUFLK       READE     GPAURND0                               90    *
     C     *IN90         DOWEQ     '0'
     C                   DELETE    GPAURND0
     C     GPAUFLK       READE     GPAURND0                               90    *
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Determine format
      ********************************************************************
     C     DETFMT        BEGSR
 
     C* FIELD FORMAT
 
     C                   CALLB     'GPAUEFFMT'
     C                   PARM      AFTYPE        I#TYPE            1
     C                   PARM      AFDIG         I#DIG             4 0
     C                   PARM      AFDEC         I#DEC             2 0
     C                   PARM                    SSFFMT
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Edit from/to line/position
      ********************************************************************
     C     EDTFAT        BEGSR
     C                   MOVEL     '  /   '      FMLPA
     C                   MOVEL     '  /   '      TOLPA
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      FMLN          ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        FMLNA
     C                   MOVE      FMPS          ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        FMPSA
     C                   MOVE      TOLN          ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        TOLNA
     C                   MOVE      TOPS          ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        TOPSA
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Clear out any start characters
      ********************************************************************
     C     CLSTRC        BEGSR
     C     *IN99         DOUEQ     '0'
     C                   Z-ADD     1             X
     C     STRC          LOOKUP    LIN(X)                                 99    *
     C     *IN99         IFEQ      '1'
     C                   MOVE      *BLANK        LIN(X)
     C                   END
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Clear out any end characters
      ********************************************************************
     C     CLENDC        BEGSR
     C     *IN99         DOUEQ     '0'
     C                   Z-ADD     1             X
     C     ENDC          LOOKUP    LIN(X)                                 99    *
     C     *IN99         IFEQ      '1'
     C                   MOVE      *BLANK        LIN(X)
     C                   END
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Initial processing
      ********************************************************************
     C     INIT          BEGSR
 
     C*  PARAMETERS PASSED
 
     C     *ENTRY        PLIST
     C                   PARM                    RETC              6
     C                   PARM                    AFFILE
     C                   PARM                    AFRCID
     C                   PARM                    AFDESC
 
     C                   Z-ADD     *ZERO         FMLP
     C                   Z-ADD     *ZERO         TOLP
     C                   BITOFF    '01234567'    STRC              1
     C                   BITON     '257'         STRC
     C                   BITOFF    '01234567'    ENDC              1
     C                   BITON     '2'           ENDC
 
     C* KEY LISTS
 
     C     GPAUFLK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C     GPAUFDK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C                   KFLD                    AFSNAM
     C     GPAUFDXK      KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C                   KFLD                    AFLN
     C     GPAURNK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFRCID
     C                   KFLD                    AFFLDN
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Edit field
      ********************************************************************
     C     ZEDIT         BEGSR
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * Check for error
      ********************************************************************
     C     CHKERR        BEGSR
 
     C* ERROR ON CALL OF PROGRAM
 
     C     *IN99         IFEQ      '1'
     C     ERROR         ANDNE     1
     C                   EXSR      *PSSR
     C                   END
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * *PSSR processing
      ********************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   MOVEL     '*CANCL'      RETURN            6
     C                   ENDSR     RETURN
      **********************************************************************
     OGPAUFDDS  E            FLDUPD
     O                       AFEDTW
     O                       AFEDTS
     O                       AFRSEQ
     O                       AFLN
     O                       AFPS
     O          E            FLDREL
** CT
 ... ... 1 ... ... 2 ... ... 3 ... ... 4 ... ... 5 ... ... 6 ... ... 7  ... ...8
 ... ... 9 ... ... 0 ... ... 1 ... ... 2 ... ... 3
** ERR
Action code must be 'I', 'A' 'E' or 'D'
Field is not defined as a report field, or is already used on the report
An Edit Word cannot be defined against an alphameric field
An Edit Word cannot be defined for a numeric field > 17 bytes in length
Day number conversion requires the field to be 5 digits and numeric
Base currency editing requires the field to be at least 11 digits & numeric
Missing inverted commas around Edit Word (eg '   , 0 .  -')
Characters are defined after the second inverted comma
Valid characters are blank, '0', ',', '.' and '-'
Only one '0' (for zero suppress) is allowed in an edit word
Edit word does not match field size
Characters are defined after what appears to be an RPG field name
Invalid RPG field name
This field now extends to beyond the end of the report page
This field now overlaps another field
