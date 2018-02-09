     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Audit Field Values Enquiry')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GO100110 - Audit Field Values Enquiry                        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGO100110DFCF   E             WORKSTN
 
     D/COPY ZACPYSRC,PSDS
 
 
      * Field Shortnames
      * Field Descriptions
     D/COPY GPCPYSRCG,GPAUFDSNM
     D/COPY GPCPYSRCG,GPAUFDDES
 
 
      * Field Contents
     D/COPY GPCPYSRCG,GPAUFDCON
 
 
     D  Field_Details  DS           131
     D Field_Desciptn          1     30
     D Changed_Field          31     31
     D Before_Image           32     80
     D After_Image            81    131
     D Image                  32    131
 
 
     D TOT             S            131    DIM(255)
     D LIN             S              1    DIM(131)
 
 
     D CT              S              1    DIM(131) CTDATA PERRCD(80)
     D CT_BA           S              1    DIM(131) CTDATA PERRCD(80)
 
 
     D                 DS
     D  SC                     1   1965
     D                                     DIM(15)
     D  SC1D                   1     30
     D  SC1I                  32    131
     D  SC2D                 132    161
     D  SC2I                 163    262
     D  SC3D                 263    292
     D  SC3I                 294    393
     D  SC4D                 394    423
     D  SC4I                 425    524
     D  SC5D                 525    554
     D  SC5I                 556    655
     D  SC6D                 656    685
     D  SC6I                 687    786
     D  SC7D                 787    816
     D  SC7I                 818    917
     D  SC8D                 918    947
     D  SC8I                 949   1048
     D  SC9D                1049   1078
     D  SC9I                1080   1179
     D  SC10D               1180   1209
     D  SC10I               1211   1310
     D  SC11D               1311   1340
     D  SC11I               1342   1441
     D  SC12D               1442   1471
     D  SC12I               1473   1572
     D  SC13D               1573   1602
     D  SC13I               1604   1703
     D  SC14D               1704   1733
     D  SC14I               1735   1834
     D  SC15D               1835   1864
     D  SC15I               1866   1965
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      * LOAD DATA
 
     C                   EXSR      LOAD_DATA
 
      * INITIAL SCREEN
 
     C                   Z-ADD     1             SCRCNT
 
      * DETERMINE HIGHEST SCREEN
 
     C                   EXSR      DET_HISCRN
 
      * SCREEN HEADING
 
     C     I#ENTT        IFEQ      'PT'
     C     I#ENTT        OREQ      'DL'
     C     I#ENTT        OREQ      'UP'
     C     I#ACTN        ANDNE     'AMEND'
     C                   MOVEA     CT            CTX
     C                   ELSE
     C                   MOVEA     CT_BA         CTX
     C                   ENDIF
 
      * PREPARE SCREEN
 
     C                   EXSR      PREP_SCRN
 
      * DISPLAY SCREEN
 
     C     *INKC         DOWEQ     '0'
     C     *INKH         ANDEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY
     C                   END
 
      * RETURN COMMAND KEYS
 
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
 
     C                   SETON                                        LR
 
      /SPACE 5
      *****************************************************************
      * Display screen
      *****************************************************************
     C     DSPLAY        BEGSR
 
     C                   TIME                    DDTIME
     C                   WRITE     MAIN
     C                   READ      MAIN                                   99    *
 
      * ROLL UP
 
     C     *IN05         IFEQ      '1'
     C                   ADD       1             SCRCNT
     C     SCRCNT        IFGT      HISCRN
     C                   Z-ADD     1             SCRCNT
     C                   END
     C                   END
 
      * ROLL DOWN
 
     C     *IN06         IFEQ      '1'
     C                   SUB       1             SCRCNT
     C     SCRCNT        IFEQ      *ZERO
     C                   Z-ADD     HISCRN        SCRCNT
     C                   END
     C                   END
 
      * SHOW CHANGED FIELDS ONLY
 
     C     *INKJ         IFEQ      '1'
     C     Show_All_Flds IFEQ      'Y'
     C                   MOVEL     'N'           Show_All_Flds
     C                   ELSE
     C                   MOVEL     'Y'           Show_All_Flds
     C                   ENDIF
     C                   EXSR      LOAD_DATA
     C                   Z-ADD     1             SCRCNT
     C                   EXSR      DET_HISCRN
     C                   END
 
      * PREPARE SCREEN
 
     C                   EXSR      PREP_SCRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Load data
      *****************************************************************
     C     LOAD_DATA     BEGSR
     C                   MOVEL     *BLANK        TOT
     C                   Z-ADD     1             #FD               5 0
     C                   Z-ADD     1             #OFD              5 0
     C     #FD           DOWLE     250
     C     #_FDFDES(#FD) ANDNE     *BLANK
     C                   MOVEL     *BLANK        Field_Details
     C                   MOVEL     #_FDFDES(#FD) Field_Desciptn
     C                   SELECT
     C     I#ENTT        WHENEQ    'PT'
     C                   MOVEL     #_FDCON(#FD)  Image
     C                   MOVE      '='           Changed_Field
     C     I#ENTT        WHENEQ    'DL'
     C                   MOVEL     #B_FDCON(#FD) Image
     C                   MOVE      '='           Changed_Field
     C     I#ENTT        WHENEQ    'UP'
     C     I#ACTN        ANDNE     'AMEND'
     C                   MOVEL     #_FDCON(#FD)  Image
     C                   MOVE      '='           Changed_Field
     C     I#ENTT        WHENEQ    'UP'
     C     I#ACTN        ANDEQ     'AMEND'
     C                   MOVEL     #_FDCON(#FD)  After_Image
     C                   MOVEL     #B_FDCON(#FD) Before_Image
     C     After_Image   IFNE      Before_Image
     C                   MOVE      '>'           Changed_Field
     C                   ENDIF
     C                   ENDSL
     C     Show_All_Flds IFEQ      'Y'
     C     Changed_Field ORNE      *BLANK
     C                   MOVEL     Field_Details TOT(#OFD)
     C                   ADD       1             #OFD
     C                   ENDIF
     C                   ADD       1             #FD
     C                   ENDDO
     C                   SUB       1             #OFD
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Determine Highest Screen
      ********************************************************************
     C     DET_HISCRN    BEGSR
     C     #OFD          DIV       15            HISCRN            2 0
     C                   MVR                     Remainder         2 0    99
     C  N99              ADD       1             HISCRN
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Prepare screen
      ********************************************************************
     C     PREP_SCRN     BEGSR
 
     C                   MOVE      *OFF          *IN
 
     C     SCRCNT        SUB       1             W_LN              3 0          *LINE NO.
     C                   MULT      15            W_LN
     C                   ADD       1             W_LN
 
     C                   Z-ADD     1             CNT               2 0          *COUNT
     C     CNT           DOUGT     15
 
     C                   MOVEA     TOT(W_LN)     LIN
 
      * CHANGED?
 
     C     LIN(31)       IFEQ      '>'
     C                   MOVE      *ON           *IN(CNT)
     C                   ENDIF
 
     C* SET SCREEN FIELDS
 
     C                   MOVEA     LIN           SC(CNT)
     C                   ADD       1             CNT
     C                   ADD       1             W_LN
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR --- INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * INPUT
      * Entry Type
      * Input
      * Input Description
      * Action
      * ID
      * User
      * Run Date
      * Machine Date
      * Time
     C                   PARM                    I#ENTT            2
     C                   PARM                    I#INPT            4
     C                   PARM                    I#DESC           40
     C                   PARM                    I#ACTN           10
     C                   PARM                    I#REFI           40
     C                   PARM                    I#USER           10
     C                   PARM                    I#RUND            7
     C                   PARM                    I#MACD            7
     C                   PARM                    I#STIM            4 0
      * Field Descriptions
     C                   PARM                    #_FDFDES
      * OUTPUT
      * Field Contents
     C                   PARM                    #_FDCON
     C                   PARM                    #B_FDCON
      * OUTPUT
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Set up standard screen fields.
 
     C                   MOVEL     PsJobName     DDJOB
     C                   MOVEL     PsUser        DDUSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   MOVEL     'Y'           Show_All_Flds     1
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
** CT
Field Description              D  A  T  A
 
** CT_BA
Field Description              B  E  F  O  R  E     D  A  T  A
A  F  T  E  R     D  A  T  A
