     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Audit Update Overview Enquiry')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP100108 - Audit Update Overview Enquiry                     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD043639           Date 27Jan17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG2410            Date 30Apr04               *
      *                 CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD043639 - Audit report name is same for all functions.      *
      *             Fix is to rename the Audit report according to    *
      *             function being audited. Change length of HLN.     *
      *  BUG2410 - Improve web-facing display                         *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGPAUCHL0  IF   E           K DISK    INFSR(*PSSR)
     FGPAUIPPD  IF   E           K DISK    INFSR(*PSSR)
     FGO100108DFCF   E             WORKSTN
 
     D/COPY ZACPYSRC,PSDS
 
 
      * Field Attributes
      * Field Shortnames
      * Field Descriptions
     D/COPY GPCPYSRCG,GPAUFDATB
     D/COPY GPCPYSRCG,GPAUFDSNM
     D/COPY GPCPYSRCG,GPAUFDDES
 
 
      * Field Contents
     D/COPY GPCPYSRCG,GPAUFDCON
 
 
     D ArFDCON         S              1    DIM(100)
 
 
     D TOT             S            132    DIM(150)
     D TOTB            S            132    DIM(150)
     D LIN             S              1    DIM(132) ASCEND
 
 
     D S131            S              1    DIM(131)
 
 
     D CT              S              1    DIM(131) CTDATA PERRCD(80)
 
 
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
     D  YYMMDD                 1      6
     D  YY                     1      2  0
     D  MM                     3      4  0
     D  DD                     5      6  0
 
 
     D MON             S              3    DIM(12) CTDATA PERRCD(12)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      * Audit Change Header - Retrieval
 
     C                   EXSR      AUCH_RTL
 
      * Audit Field Attributes - Retrieval
      * Audit Change Details - Retrieval
 
     C                   EXSR      AUFD_RTL
     C                   EXSR      AUCD_RTL
 
      * Outputs
 
     C                   SELECT
     C     AHENTT        WHENEQ    'PT'
     C                   EXSR      OUT_PT
     C     AHENTT        WHENEQ    'DL'
     C                   EXSR      OUT_DL
     C                   OTHER
     C                   EXSR      OUT_UP
     C                   ENDSL
 
      * INITIAL SCREEN
 
     C                   Z-ADD     1             SCRCNT
 
      * DETERMINE HIGHEST SCREEN
 
     C                   EXSR      DET_HISCRN
 
      * SCREEN HEADING
 
     C                   MOVEA     CT            CTX
 
      * PREPARE SCREEN
 
     C                   EXSR      PREP_SCRN
 
     C* DISPLAY SCREEN
 
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY
     C                   ENDDO
 
      * RETURN COMMAND KEYS
 
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
 
     C                   SETON                                        LR
 
      /SPACE 5
      ********************************************************************
      * Display screen
      ********************************************************************
     C     DSPLAY        BEGSR
 
     C                   TIME                    DDTIME
     C                   WRITE     MAIN
     C                   READ      MAIN                                   99    *
 
      * ROLL UP
 
     C     *IN05         IFEQ      '1'
     C                   ADD       1             SCRCNT            2 0
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
 
      * FIELD VALUES
 
     C     *INKH         IFEQ      '1'
     C                   EXSR      FIELD_VALUES
     C                   ENDIF
 
      * TOGGLE BEFORE/AFTER
 
     C     *INKJ         IFEQ      '1'
     C     DDBEFAFT      IFEQ      'BEFORE IMAGE'
     C                   MOVEL     'AFTER IMAGE 'DDBEFAFT
     C                   ELSE
     C     DDBEFAFT      IFEQ      'AFTER IMAGE '
     C                   MOVEL     'BEFORE IMAGE'DDBEFAFT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * PREPARE SCREEN
 
     C                   EXSR      PREP_SCRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ****************************************************************
      * Output PT
      ****************************************************************
     C     OUT_PT        BEGSR
 
      * 'AFTER' image
 
     C                   MOVEL     'A'           Before_After      1
 
     C                   MOVE      *BLANK        TOT
     C**********         Z-ADD     1             HLN               2 0                      MD043639
     C                   Z-ADD     1             HLN               3 0                      MD043639
 
     C                   EXSR      LOAD_NARR
     C                   EXSR      LOAD_FLDS
 
     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Output DL
      ****************************************************************
     C     OUT_DL        BEGSR
 
      * 'BEFORE' image
 
     C                   MOVEL     'B'           Before_After      1
 
     C                   MOVE      *BLANK        TOT
     C**********         Z-ADD     1             HLN               2 0                      MD043639
     C                   Z-ADD     1             HLN               3 0                      MD043639
 
     C                   EXSR      LOAD_NARR
     C                   EXSR      LOAD_FLDS
 
     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Output UP
      ****************************************************************
     C     OUT_UP        BEGSR
 
      * 'BEFORE' image (if amend)
 
     C     AHACTN        IFEQ      'AMEND'
 
     C                   MOVEL     'B'           Before_After      1
     C                   MOVEL     'BEFORE IMAGE'DDBEFAFT
 
     C                   MOVE      *BLANK        TOT
     C**********         Z-ADD     1             HLN               2 0                      MD043639
     C                   Z-ADD     1             HLN               3 0                      MD043639
 
     C                   EXSR      LOAD_NARR
     C                   EXSR      LOAD_FLDS
 
     C                   MOVEL     TOT           TOTB
     C                   MOVEL     'AFTER IMAGE 'DDBEFAFT
 
     C                   ENDIF
 
      * 'AFTER' image
 
     C                   MOVEL     'A'           Before_After      1
 
     C                   MOVE      *BLANK        TOT
     C**********         Z-ADD     1             HLN               2 0                      MD043639
     C                   Z-ADD     1             HLN               3 0                      MD043639
 
     C                   EXSR      LOAD_NARR
     C                   EXSR      LOAD_FLDS
 
     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Audit Change Header - Retrieval
      ****************************************************************
     C     AUCH_RTL      BEGSR
 
     C     GPAUCHK       CHAIN     GPAUCHD0                           H1
 
      * Convert run date
 
     C                   CALLB     'ZDATE2'
     C                   PARM      AHRDNB        ZDAYNO            5 0
     C                   PARM      'D'           ZDATFM            1
     C                   PARM      *ZERO         ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   MOVEL     ZADATE        RUNDAT
 
      * Convert machine date
 
     C                   MOVEL     AHDATE        YYMMDD
     C                   EVAL      MACDAT = %subst(YYMMDD: 5:2)
     C                                      + MON(MM)
     C                                      + %subst(YYMMDD: 1:2)
 
      * Access Input details
 
     C     AHINPT        CHAIN     GPAUIPD0                           99
     C   99              MOVEL     *BLANK        AIDESC
     C   99              MOVEL     ' * UNKNOWN *'AIDESC
      * Time
     C                   MOVEL     AHTIME        DDSTIM
 
     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Audit Field Attributes - Retrieval
      ****************************************************************
     C     AUFD_RTL      BEGSR
 
     C                   CALLB     'GPAUFDRTL'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           50
      * INPUT
      * File
      * Record ID
      * Category (R=report)
     C                   PARM      AHFILE        InFile           10
     C                   PARM      AHRCID        InRecordID       15
     C                   PARM      ' '           InCategory        1
      * OUTPUT
      * Field Attributes
      * Field Shortnames
      * Field Descriptions
     C                   PARM                    #_FDATRB
     C                   PARM                    #_FDSNAM
     C                   PARM                    #_FDFDES
      * Error
     C     I#RTCD        IFNE      *BLANK
     C                   EVAL      I#ERMS = 'BAD FIELDS:'+InFile+InRecordID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Audit Change Details - Retrieval
      ****************************************************************
     C     AUCD_RTL      BEGSR
 
     C                   CALLB     'GPAUCDRTL'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           50
      * INPUT
      * Zone
      * ID
      * Entry Type
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#CID            17 0
     C                   PARM      AHENTT        I#ENTT            2
      * Field Attributes
      * Field Shortnames
     C                   PARM                    #_FDATRB
     C                   PARM                    #_FDSNAM
      * OUTPUT
      * Field Contents
     C                   PARM                    #_FDCON
     C                   PARM                    #B_FDCON
      * Error
     C     I#RTCD        IFNE      *BLANK
     C                   EVAL      I#ERMS = 'BAD DATA:'+InFile+InRecordID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
     C****************************************************************
      /SPACE 5
      ****************************************************************
      * Load Report Narrative to Report
      ****************************************************************
     C     LOAD_NARR     BEGSR
 
     C                   CALLB     'GPAURNLOD'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           50
      * INPUT
      * File
      * Record ID
     C                   PARM      AHFILE        InFile           10
     C                   PARM      AHRCID        InRecordID       15
      * OUTPUT
      * Total Lines
      * Highest Line
     C                   PARM                    TOT
     C**********         PARM                    HLN               2 0                      MD043639
     C                   PARM                    HLN               3 0                      MD043639
      * Error
     C     I#RTCD        IFNE      *BLANK
     C                   EVAL      I#ERMS = 'BAD NARR:'+InFile+InRecordID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Load Fields to Report
      *****************************************************************
     C     LOAD_FLDS     BEGSR
 
     C                   Z-ADD     1             #FD               3 0
     C     #FD           DOWLE     250
     C     #_FDATRB(#FD) ANDNE     *BLANK
 
     C                   MOVEL     #_FDATRB(#FD) #FDATRB
     C     AFLN          IFNE      0
     C                   MOVE      *BLANK        ArFDCON
     C     Before_After  IFEQ      'A'
     C                   MOVEA     #_FDCON(#FD)  ArFDCON
     C                   ELSE
     C                   MOVEA     #B_FDCON(#FD) ArFDCON
     C                   ENDIF
 
     C                   EXSR      ADD_FDCON
     C                   ENDIF
 
     C                   ADD       1             #FD
 
     C                   ENDDO
 
     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Add Field Contents to Report
      ****************************************************************
     C     ADD_FDCON     BEGSR
 
     C* START POINT
 
     C                   Z-ADD     AFPS          X                 3 0
 
     C* GET LINE
 
     C                   MOVEA     TOT(AFLN)     LIN
 
     C* IF AMEND AND FIELD HAS CHANGED OR IF INSERT, DELETE, AUTHORIZE
 
     C     DDBEFAFT      IFNE      *BLANK
     C     #B_FDCON(#FD) ANDNE     #_FDCON(#FD)
     C     DDBEFAFT      OREQ      *BLANK
     C                   SUB       1             X
     C                   MOVE      STRC          LIN(X)
     C                   ADD       1             X
     C                   ENDIF
 
     C* END POINT
 
     C                   Z-ADD     1             Y                 3 0
     C     Y             DOWLE     AFEDTS
     C                   MOVE      ArFDCON(Y)    LIN(X)
     C                   ADD       1             X
     C                   ADD       1             Y
     C                   END
 
     C* IF AMEND AND FIELD HAS CHANGED OR IF INSERT, DELETE, AUTHORIZE
 
     C     DDBEFAFT      IFNE      *BLANK
     C     #B_FDCON(#FD) ANDNE     #_FDCON(#FD)
     C     DDBEFAFT      OREQ      *BLANK
     C     X             IFLE      132
     C                   MOVE      ENDC          LIN(X)
     C                   END
     C                   END
     C* UPDATE
     C                   MOVEA     LIN           TOT(AFLN)
 
     C* HIGHEST LINE?
 
     C     AFLN          IFGT      HLN
     C                   Z-ADD     AFLN          HLN
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Field Values
      ********************************************************************
     C     FIELD_VALUES  BEGSR
     C                   CALL      'GO100110'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           50
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
     C                   PARM      AHENTT        I#ENTT            2
     C                   PARM      AHINPT        I#INPT            4
     C                   PARM      AIDESC        I#DESC           40
     C                   PARM      AHACTN        I#ACTN           10
     C                   PARM      AHREFI        I#REFI           40
     C                   PARM      AHUSER        I#USER           10
     C                   PARM      RUNDAT        I#RUND            7
     C                   PARM      MACDAT        I#MACD            7
     C                   PARM      DDSTIM        I#STIM            4 0
      * Field Descriptions
     C                   PARM                    #_FDFDES
      * OUTPUT
      * Field Contents
     C                   PARM                    #_FDCON
     C                   PARM                    #B_FDCON
      * OUTPUT
      * Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      * Error
     C     I#RTCD        IFNE      *BLANK
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     @INKC         *INKC
     C                   MOVEL     @INKL         *INKL
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Determine Highest Screen
      ********************************************************************
     C     DET_HISCRN    BEGSR
     C     HLN           DIV       15            HISCRN            2 0
     C                   MVR                     Remainder         2 0    99
     C  N99              ADD       1             HISCRN
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Prepare screen
      ********************************************************************
     C     PREP_SCRN     BEGSR
 
     C     SCRCNT        SUB       1             W_LN              3 0          *LINE NO.
     C                   MULT      15            W_LN
     C                   ADD       1             W_LN
 
     C                   Z-ADD     1             CNT               2 0          *COUNT
     C     CNT           DOUGT     15
 
     C     DDBEFAFT      IFEQ      *BLANK
     C     DDBEFAFT      OREQ      'AFTER IMAGE '
     C                   MOVEA     TOT(W_LN)     LIN
     C                   ELSE
     C                   MOVEA     TOTB(W_LN)    LIN
     C                   ENDIF
 
     C* SET SCREEN FIELDS
 
     C                   MOVEA     LIN           S131
     C                   MOVEA     S131          SC(CNT)
     C                   ADD       1             CNT
     C                   ADD       1             W_LN
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * INPUT
      * Zone
     C                   PARM                    I#ZONE           10
      * ID
     C                   PARM                    I#CID            17 0
 
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Initialize program name
 
     C                   MOVEL     'GO100108 '   DDPGM
 
      * Set up standard screen fields.
 
     C                   MOVEL     PsJobName     DDJOB
     C                   MOVEL     PsUser        DDUSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   MOVEL     *BLANK        DDBEFAFT
 
     C                   BITOFF    '01234567'    STRC              1
     C                   BITON     '2'           STRC
     C*******************IF        %SUBST(DDJOB:1:2) <> 'QQ'                                 BUG2410
     C                   BITON     '57'          STRC
     C*******************ENDIF                                                               BUG2410
     C                   BITOFF    '01234567'    ENDC              1
     C                   BITON     '2'           ENDC
     C                   IF        %SUBST(DDJOB:1:2) = 'QQ'                                  BUG2410
     C                   MOVE      *BLANK        STRC                                        BUG2410
     C                   MOVE      *BLANK        ENDC                                        BUG2410
     C                   ENDIF                                                               BUG2410
 
      * Key lists
 
     C     GPAUCHK       KLIST
     C                   KFLD                    I#ZONE
     C                   KFLD                    I#CID
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
** CT
 ... ... 1 ... ... 2 ... ... 3 ... ... 4 ... ... 5 ... ... 6 ... ... 7  ... ...8
 ... ... 9 ... ... 0 ... ... 1 ... ... 2 ... ... 3
** MON
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
