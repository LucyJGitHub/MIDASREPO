     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Non-A/c Holder details 2 screen')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDFTNH2DP  - FATCA Customer details - 2nd Screen             *
      *                                                               *
      *  Function:  This module displays the second details screen    *
      *             of FATCA customer details screen input function   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD029805           Date 05Sep14               *
      *  Prev Amend No. MD027464           Date 15Aug13               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029805 - GIIN number validation (Recompile)                *
      *  MD027464 - Override/Override comments Blank and Invalid      *
      *             Inputs point to incorrect                         *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDFTNH2DDFCF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *       67  Error on Private Banking Field                      *
      *       68  Condition Display of Private Banking Field          *
      *       69  Position cursor on first screen field if no errors  *
      *       70  Protect screen fields                               *
      *       71  Enable function keys F7/F8 (read previous/next)     *
      *       72  Enable function key F10 (delete)                    *
      *       73  Enable function key F23 (further details)           *
      *       81  Condition non display of margin type field          *
      *       82  Condition display of Retail 3 field                 *
      *       83  Condition display of Management Accounts field      *
      *       84  Condition display of COB deletion field             *
      *       85  Condition display of Branch Code field              *
      *       86  Condition display of Suspended Date field           *
      *       88  Condition display of DRS Shortname fields           *
      *       89  Condition display of Base Rate Tax field            *
      *       97  Subfile end                                         *
      *       99  Read error                                          *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D/COPY ZACPYSRC,STDDECLARE
 
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
     D/COPY ZACPYSRC,FVAL_ARRAY
 
     D/COPY ZACPYSRC,APICTLARR
 
     D/COPY ZACPYSRC,MSGHNDDCL
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @Z0             S              1    DIM(95) CTDATA PERRCD(95)
 
     D @EI             S              1    DIM(95)
 
     D QRYFLD          S              1A
     D P@Mode          S              7A
     D PRtcd           S              7A
     D PCust           S             10A
     D PType           S              1A
     D PCode           S              2A
     D PSeqn           S              3A
     D CSD093          S              1A
     D CGL133          S              1A
     D PDDCID1         S              2A
     D PDDCID2         S              2A
     D PDDCID3         S              2A
     D PDDCID4         S              2A
     D PDDCID5         S              2A
     D PDDCBD1         S              2A
     D PDDCBD2         S              2A
     D PDDCBD3         S              2A
     D PDDCBD4         S              2A
     D PDDCBD5         S              2A
     D PDDCDD1         S              2A
     D PDDCDD2         S              2A
     D PDDCDD3         S              2A
     D PDDCDD4         S              2A
     D PDDCDD5         S              2A
 
     D CrFaScnFmt    E DS                  EXTNAME(SDFTNRPD)
     D CrCuScnFmt    E DS                  EXTNAME(SDNAHLPD)
     D OKFATCAdet    E DS                  EXTNAME(SDEFTNHPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the             ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Main processing
 
     C                   EXSR      MAIN
 
      ** Return
 
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
 
     C     MAIN          BEGSR
 
      ** Move 'OK' flags into array (for checking)
 
     C                   MOVEA     OKFATCAdet    @EI
 
      ** Set screen error indicators according to status of 'OK' flags
 
     C                   Z-ADD     1             C                 2 0
     C**********         Z-ADD     -17           E                 2 0                      MD027464
     C                   Z-ADD     -24           E                 2 0                      MD027464
 
     C     C             DOUGT     94
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   IF        E > 0
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
 
     C                   EVAL      *IN86 = '0'
     C                   EVAL      *IN87 = '0'
     C                   IF        CSD093 = 'N'
     C                   EVAL      *IN87 = '1'
     C                   ENDIF
     C                   IF        CGL133 = 'Y'
     C                   EVAL      *IN86 = '1'
     C                   EVAL      *IN87 = '1'
     C                   ENDIF
 
     C                   IF        CGL133 = 'N'
     C                   IF        DDACTI = 'I'
     C                   EVAL      *IN87 = '1'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN87 = '1'
     C                   ENDIF
 
     D/COPY ZACPYSRC,MSGHNDDSP1
 
      ** Position cursor on first field if no errors
 
     C     'N'           LOOKUP    @EI                                    01
 
     C                   IF        CGL133 = 'N'
     C                   MOVE      *OFF          *IN86
     C     DDACTI        IFEQ      'E'
     C                   MOVE      *ON           *IN86
     C                   MOVE      *ON           *IN87
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *ON           *IN86
     C                   ENDIF
 
     C                   EVAL      PDDCID1 = DDCID1
     C                   EVAL      PDDCID2 = DDCID2
     C                   EVAL      PDDCID3 = DDCID3
     C                   EVAL      PDDCID4 = DDCID4
     C                   EVAL      PDDCID5 = DDCID5
     C                   EVAL      PDDCBD1 = DDCBD1
     C                   EVAL      PDDCBD2 = DDCBD2
     C                   EVAL      PDDCBD3 = DDCBD3
     C                   EVAL      PDDCBD4 = DDCBD4
     C                   EVAL      PDDCBD5 = DDCBD5
     C                   EVAL      PDDCDD1 = DDCDD1
     C                   EVAL      PDDCDD2 = DDCDD2
     C                   EVAL      PDDCDD3 = DDCDD3
     C                   EVAL      PDDCDD4 = DDCDD4
     C                   EVAL      PDDCDD5 = DDCDD5
 
     C                   MOVE      *OFF          *IN95
     C     DDACTN        IFEQ      'E'
     C                   MOVE      *ON           *IN95
     C                   ENDIF
 
      ** Write Message subfile, FATCA details and footer screen
 
     C                   TIME                    #0TIME
     C                   WRITE     SDFTNHSS0
     C                   WRITE     SDFTNHSD1
     C                   WRITE     SDFTNHSF1
 
      ** Read Details Screen, If not write only
 
     C     WriteOnly     IFNE      'Y'
     C                   READ      SDFTNHSD1                              99
     C                   ENDIF
 
      ** If Exit/Previous screen not selected
      ** process user request for data tables with query '?'
 
     C     *INKC         IFEQ      *OFF
     C     *INKQ         ANDEQ     *OFF
     C     *INKS         ANDEQ     *OFF
     C     *INKT         ANDEQ     *OFF
 
     C                   IF        CSD093 = 'Y'
 
     C                   IF        PDDCID1 <> DDCID1
     C                   EVAL      DDCIS1 = *BLANKS
     C                   ENDIF
     C                   IF        PDDCID2 <> DDCID2
     C                   EVAL      DDCIS2 = *BLANKS
     C                   ENDIF
     C                   IF        PDDCID3 <> DDCID3
     C                   EVAL      DDCIS3 = *BLANKS
     C                   ENDIF
     C                   IF        PDDCID4 <> DDCID4
     C                   EVAL      DDCIS4 = *BLANKS
     C                   ENDIF
     C                   IF        PDDCID5 <> DDCID5
     C                   EVAL      DDCIS5 = *BLANKS
     C                   ENDIF
     C                   IF        PDDCBD1 <> DDCBD1
     C                   EVAL      DDCBS1 = *BLANKS
     C                   ENDIF
     C                   IF        PDDCBD2 <> DDCBD2
     C                   EVAL      DDCBS2 = *BLANKS
     C                   ENDIF
     C                   IF        PDDCBD3 <> DDCBD3
     C                   EVAL      DDCBS3 = *BLANKS
     C                   ENDIF
     C                   IF        PDDCBD4 <> DDCBD4
     C                   EVAL      DDCBS4 = *BLANKS
     C                   ENDIF
     C                   IF        PDDCBD5 <> DDCBD5
     C                   EVAL      DDCBS5 = *BLANKS
     C                   ENDIF
     C                   IF        PDDCDD1 <> DDCDD1
     C                   EVAL      DDCDS1 = *BLANKS
     C                   ENDIF
     C                   IF        PDDCDD2 <> DDCDD2
     C                   EVAL      DDCDS2 = *BLANKS
     C                   ENDIF
     C                   IF        PDDCDD3 <> DDCDD3
     C                   EVAL      DDCDS3 = *BLANKS
     C                   ENDIF
     C                   IF        PDDCDD4 <> DDCDD4
     C                   EVAL      DDCDS4 = *BLANKS
     C                   ENDIF
     C                   IF        PDDCDD5 <> DDCDD5
     C                   EVAL      DDCDS5 = *BLANKS
     C                   ENDIF
 
      ** Override active document
 
     C                   MOVEL     DDCID1        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDCID1 = PCODE
     C                   MOVE      PSEQN         DDCIS1
     C                   ENDIF
 
     C                   MOVEL     DDCID2        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDCID2 = PCODE
     C                   MOVE      PSEQN         DDCIS2
     C                   ENDIF
 
     C                   MOVEL     DDCID3        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDCID3 = PCODE
     C                   MOVE      PSEQN         DDCIS3
     C                   ENDIF
 
     C                   MOVEL     DDCID4        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDCID4 = PCODE
     C                   MOVE      PSEQN         DDCIS4
     C                   ENDIF
 
     C                   MOVEL     DDCID5        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDCID5 = PCODE
     C                   MOVE      PSEQN         DDCIS5
     C                   ENDIF
 
     C                   MOVEL     DDCBD1        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDCBD1 = PCODE
     C                   MOVE      PSEQN         DDCBS1
     C                   ENDIF
 
     C                   MOVEL     DDCBD2        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDCBD2 = PCODE
     C                   MOVE      PSEQN         DDCBS2
     C                   ENDIF
 
     C                   MOVEL     DDCBD3        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDCBD3 = PCODE
     C                   MOVE      PSEQN         DDCBS3
     C                   ENDIF
 
     C                   MOVEL     DDCBD4        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDCBD4 = PCODE
     C                   MOVE      PSEQN         DDCBS4
     C                   ENDIF
 
     C                   MOVEL     DDCBD5        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDCBD5 = PCODE
     C                   MOVE      PSEQN         DDCBS5
     C                   ENDIF
 
     C                   MOVEL     DDCDD1        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDCDD1 = PCODE
     C                   MOVE      PSEQN         DDCDS1
     C                   ENDIF
 
     C                   MOVEL     DDCDD2        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDCDD2 = PCODE
     C                   MOVE      PSEQN         DDCDS2
     C                   ENDIF
 
     C                   MOVEL     DDCDD3        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDCDD3 = PCODE
     C                   MOVE      PSEQN         DDCDS3
     C                   ENDIF
 
     C                   MOVEL     DDCDD4        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDCDD4 = PCODE
     C                   MOVE      PSEQN         DDCDS4
     C                   ENDIF
 
     C                   MOVEL     DDCDD5        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDCDD5 = PCODE
     C                   MOVE      PSEQN         DDCDS5
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Clear message subfile
      ** Set screen error indicators off
 
     C                   MOVEA     @Z0           *IN(02)
 
      ** Set return keys
 
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKQ         @INKQ
     C                   MOVE      *INKS         @INKS
     C                   MOVE      *INKT         @INKT
 
     C                   ENDSR
 
     D/COPY ZACPYSRC,MSGHNDDSP2
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      * INPUT PARAMETERS :
      * Return code
 
     C                   PARM                    RetCodeIn
 
      ** FATCA Details
     C                   PARM                    CrFaScnFmt
     C                   PARM                    CrCuScnFmt
 
      ** Fields in error
     C                   PARM                    OKFATCAdet
 
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** OUTPUT PARAMETERS :
      ** Function Keys
 
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKQ             1
     C                   PARM                    @INKS             1
     C                   PARM                    @INKT             1
 
      ** Write screen with no read indicator
     C                   PARM                    WriteOnly         1
 
      ** Initialize program name
 
     C                   MOVEL     'SDFTNH2DP'   DBPGM
 
      ** Move user and workstation ID to screen fields.
 
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
 
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
 
      ** Access bank details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if switchable feature CGL132 is switched on.
 
     C                   EVAL      CSD093 = 'N'
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSD093'      @SARD
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CSD093'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      SRERR
     C                   END
 
     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      CSD093 = 'Y'
     C                   MOVE      *ON           *IN87
     C                   ENDIF
 
      ** Check if switchable feature CGL133 is switched on.
 
     C                   EVAL      CGL133 = 'N'
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL133'      @SARD
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CGL133'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   EXSR      SRERR
     C                   END
 
     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      CGL133 = 'Y'
     C                   MOVE      *ON           *IN86
     C                   MOVE      *ON           *IN87
     C                   ENDIF
 
     D/COPY SDCPYSRC,MSGHNDDATA
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
 
     C     SRERR         BEGSR
 
     C                   MOVEL     'SDFTCSSDSP'  DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
 
      **  Terminte the program
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
** @Z0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
