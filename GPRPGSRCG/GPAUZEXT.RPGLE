     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Audit Extract')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUZEXT - Audit Extract                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 249904             Date 08Jun06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG8893            Date 08Jun06               *
      *                 BUG2307            Date 26Apr04               *
      *                 CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  249904 - Recompiled to correct signature violation error     *
      *  BUG8893 - Recompiled due to change in file GPAUJIPD.         *
      *  BUG2307 - Audit reporting errors                             *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGPAUJIPD  IF   E           K DISK    INFSR(*PSSR)
     FGZSDBANKL1IF   E           K DISK    INFSR(*PSSR)
 
 
      * File Details
     D GPAUFL        E DS                  EXTNAME(GPAUFLPD)
 
 
      * Field Attributes
      * Field Shortnames
      * Field Descriptions
      * Field Action Selection
     D/COPY GPCPYSRCG,GPAUFDATB
     D/COPY GPCPYSRCG,GPAUFDSNM
     D/COPY GPCPYSRCG,GPAUFDDES
     D/COPY GPCPYSRCG,GPAUFDASL
 
 
      * Field Contents
     D/COPY GPCPYSRCG,GPAUFDCON
     D #S_FDCON        S            100    DIM(250)                                          BUG2307
 
 
     C                   READ      GPAUJIPD                               99    *
 
     C     *IN99         DOWEQ     '0'
 
      * Audit File - Retrieval
 
     C                   EXSR      AUFL_RTL
 
      * Audit Field Attributes - Retrieval
      * Audit Field Contents - Retrieval
      * Audit Field Action Selection - Retrieval
 
     C                   EXSR      AUFD_RTL
     C                   EXSR      AUFC_RTL
     C                   EXSR      AUAS_RTL
 
      * Adjust entry types
 
     C                   EXSR      ADJ_ENTT
 
      * Write entries
 
     C     JOENTT        IFEQ      'PT'
     C                   MOVEL     *BLANK        #B_FDCON
     C                   EXSR      WRITE_DETAILS
     C     RecordsWrittenIFEQ      'Y'
     C                   EXSR      WRITE_HEADER
     C                   ENDIF
     C                   ENDIF
 
      * Delete entries
 
     C     JOENTT        IFEQ      'DL'
     C                   MOVEL     #_FDCON       #B_FDCON
     C                   MOVEL     *BLANK        #_FDCON
     C                   EXSR      WRITE_DETAILS
     C     RecordsWrittenIFEQ      'Y'
     C                   EXSR      WRITE_HEADER
     C                   ENDIF
     C                   ENDIF
 
      * Update (before) entry
 
     C     JOENTT        IFEQ      'UB'
     C     Rollback      ANDEQ     'N'                                                       BUG2307
     C     JOENTT        OREQ      'UP'                                                      BUG2307
     C     Rollback      ANDEQ     'Y'                                                       BUG2307
     C                   MOVEL     #_FDCON       #B_FDCON
     C                   ENDIF
                                                                                             BUG2307
     C     JOENTT        IFEQ      'UB'                                                      BUG2307
     C     Rollback      ANDEQ     'Y'                                                       BUG2307
     C                   MOVEL     #B_FDCON      #S_FDCON                                    BUG2307
     C                   MOVEL     #_FDCON       #B_FDCON                                    BUG2307
     C                   MOVEL     #S_FDCON      #_FDCON                                     BUG2307
     C                   ENDIF                                                               BUG2307
 
      * Update (after) entry
 
     C     JOENTT        IFEQ      'UP'
     C     Rollback      ANDEQ     'N'                                                       BUG2307
     C     JOENTT        OREQ      'UB'                                                      BUG2307
     C     Rollback      ANDEQ     'Y'                                                       BUG2307
     C                   EXSR      WRITE_DETAILS
     C     RecordsWrittenIFEQ      'Y'
     C                   EXSR      WRITE_HEADER
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      GPAUJIPD                               99    *
     C                   ENDDO
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
      ****************************************************************
      * Audit File - Retrieval
      ****************************************************************
     C     AUFL_RTL      BEGSR
 
     C                   CALLB     'GPAUFLRTL'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           50
      * INPUT
      * File
      * Record
     C                   PARM      JOOBJ         InFile           10
     C                   PARM      JOESD         InRecord       4000
      * OUTPUT
      * File Details
     C                   PARM                    GPAUFL
      * Error
     C     I#RTCD        IFNE      *BLANK
     C                   EVAL      I#ERMS = 'BAD FILE:' + InFile
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
     C                   PARM      JOOBJ         InFile           10
     C                   PARM      AFRCID        InRecordID       15
     C                   PARM      *BLANK        InCategory        1
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
      * Audit Field Action Selection - Retrieval
      ****************************************************************
     C     AUAS_RTL      BEGSR
 
     C                   CALLB     'GPAUASRTL'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           50
      * INPUT
      * File
      * Record ID
     C                   PARM      JOOBJ         InFile           10
     C                   PARM      AFRCID        InRecordID       15
      * OUTPUT
      * Field Action Selection
     C                   PARM                    #_FDACSL
      * Error
     C     I#RTCD        IFNE      *BLANK
     C                   EVAL      I#ERMS = 'BAD SELECTS:'+InFile+InRecordID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Audit Field Contents - Retrieval
      ****************************************************************
     C     AUFC_RTL      BEGSR
 
     C                   CALLB     'GPAUFCRTL'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           50
      * INPUT
      * Base Currency
     C                   PARM      BJCYCD        I#BCCY            3
      * Record
      * Field Attributes
      * Field Shortnames
     C                   PARM      JOESD         InRecord       4000
     C                   PARM                    #_FDATRB
     C                   PARM                    #_FDSNAM
 
      * OUTPUT
      * Field Contents
     C                   PARM                    #_FDCON
      * Error
     C     I#RTCD        IFNE      *BLANK
     C                   EVAL      I#ERMS = 'BAD CONTENT:'+ InRecord
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Audit Change Details - Write
      ****************************************************************
     C     WRITE_DETAILS BEGSR
 
     C                   CALLB     'GPAUCDWRT'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           50
      * INPUT
      * Zone
      * Journal Sequence Number
      * Journal Date
      * Journal Entry Type
     C                   PARM                    I#ZONE           10
     C                   PARM      JOSEQN        I#SEQN           10 0
     C                   PARM      JODATE        I#DATE            6
     C                   PARM      JOENTT        I#ENTT            2
      * Field Attributes
      * Field Shortnames
      * Field Action Selection
     C                   PARM                    #_FDATRB
     C                   PARM                    #_FDSNAM
     C                   PARM                    #_FDACSL
      * Field Contents
     C                   PARM                    #_FDCON
     C                   PARM                    #B_FDCON
      * OUTPUT
      * Branch
      * Reference ID
      * Action code
     C                   PARM                    Branch            3
     C                   PARM                    ReferID          40
     C                   PARM                    Action           10
      * Records Written
     C                   PARM                    RecordsWritten    1
      * Error
     C     I#RTCD        IFNE      *BLANK
     C                   EVAL      I#ERMS = 'WRITE ERROR:'+ InRecord
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                             BUG2307
     C     RollBack      IFEQ      'Y'                                                       BUG2307
     C                   MOVE      '*'           Action                                      BUG2307
     C                   ENDIF                                                               BUG2307
 
     C                   ENDSR
     C****************************************************************
      /SPACE 5
      ****************************************************************
      * Audit Change Header - Write
      ****************************************************************
     C     WRITE_HEADER  BEGSR
 
     C                   CALLB     'GPAUCHWRT'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           50
      * INPUT
      * Zone
      * Run Day Number
     C                   PARM                    I#ZONE           10
     C                   PARM      BJRDNB        I#RDNB            5 0
      * Input
      * Branch
      * Reference ID
      * Action
     C                   PARM      AFINPT        I#INPT            4
     C                   PARM      Branch        I#BRCA            3
     C                   PARM      ReferID       I#REFI           40
     C                   PARM      Action        I#ACTN           10
      * Journal Entry Type
      * Journal User
      * Journal Sequence Number
      * Journal File
      * Journal Job Number
      * Journal Program
      * Journal Date
      * Journal Time
      * Journal Commit ID
     C                   PARM      JOENTT        I#ENTT            2
     C                   PARM      JOUSER        I#USER           10
     C                   PARM      JOSEQN        I#SEQN           10 0
     C                   PARM      JOOBJ         I#FILE           10
     C                   PARM      JONBR         I#JNBR            6 0
     C                   PARM      JOPGM         I#PGM            10
     C                   PARM      JODATE        I#DATE            6
     C                   PARM      JOTIME        I#TIME            6 0
     C                   PARM      JOCCID        I#CCID           10 0
      * Rollback
     C                   PARM      Rollback      I#RLBK            1
      * Record ID
     C                   PARM      AFRCID        I#RCID           15
      * Error
     C     I#RTCD        IFNE      *BLANK
     C                   EVAL      I#ERMS = 'WRITE ERROR:'+ InRecord
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
     C/SPACE 5
      ********************************************************************
      * Adjust entry types
      ********************************************************************
     C     ADJ_ENTT      BEGSR
 
     C                   MOVE      'N'           Rollback          1
 
     C     JOENTT        IFEQ      'DR'
     C                   MOVEL     'DL'          JOENTT
     C                   MOVE      'Y'           Rollback
     C                   ENDIF
     C     JOENTT        IFEQ      'BR'
     C                   MOVEL     'UB'          JOENTT
     C                   MOVE      'Y'           Rollback
     C                   ENDIF
     C     JOENTT        IFEQ      'UR'
     C                   MOVEL     'UP'          JOENTT
     C                   MOVE      'Y'           Rollback
     C                   ENDIF
 
     C     JOENTT        IFEQ      'PX'
     C                   MOVEL     'PT'          JOENTT
     C                   ENDIF
     C                   ENDSR
      ****************************************************************
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
 
     C* GET BANK DETAILS
 
     C     I#ZONE        CHAIN     SDBANKD0                           99        *
 
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'BAD ZONE:' + I#ZONE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
