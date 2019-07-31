     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Non-A/c Holder details 4 screen')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDFTNH4DP  - FATCA Customer details 4 Screen                 *
      *                                                               *
      *  Function:  This module displays the fourth details screen    *
      *             of FATCA customer details screen input function   *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD029805           Date 05Sep14               *
      *                 MD027464           Date 15Aug14               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
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

     FSDFTNH4DDFCF   E             WORKSTN

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

     D P@Mode          S              7A
     D PRtcd           S              7A
     D PCust           S             10A
     D PType           S              1A
     D PCode           S              2A
     D PSeqn           S              3A
     D QRYFLD          S              3A
     D CSD093          S              1A
     D CGL133          S              1A
     D PDDTED1         S              2A
     D PDDTED2         S              2A
     D PDDTED3         S              2A
     D PDDTED4         S              2A
     D PDDTED5         S              2A
     D PDDTXD1         S              2A
     D PDDTXD2         S              2A
     D PDDTXD3         S              2A
     D PDDTXD4         S              2A
     D PDDTXD5         S              2A
     D PDDAUD1         S              2A
     D PDDAUD2         S              2A
     D PDDAUD3         S              2A
     D PDDAUD4         S              2A
     D PDDAUD5         S              2A

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
     C**********         Z-ADD     -45           E                 2 0                      MD027464
     C                   Z-ADD     -52           E                 2 0                      MD027464

     C     C             DOUGT     94
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   IF        E > 0
     C                   MOVEL     '1'           *IN(E)
     C                   ELSE                                                               MD027464
     C                   Z-ADD     C             TEMPC             2 0                      MD027464
     C                   ADD       10            TEMPC                                      MD027464
     C                   MOVEL     '1'           *IN(TEMPC)                                 MD027464
     C                   ENDIF
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END

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

     C                   EVAL      PDDTED1 = DDTED1
     C                   EVAL      PDDTED2 = DDTED2
     C                   EVAL      PDDTED3 = DDTED3
     C                   EVAL      PDDTED4 = DDTED4
     C                   EVAL      PDDTED5 = DDTED5
     C                   EVAL      PDDTXD1 = DDTXD1
     C                   EVAL      PDDTXD2 = DDTXD2
     C                   EVAL      PDDTXD3 = DDTXD3
     C                   EVAL      PDDTXD4 = DDTXD4
     C                   EVAL      PDDTXD5 = DDTXD5
     C                   EVAL      PDDAUD1 = DDAUD1
     C                   EVAL      PDDAUD2 = DDAUD2
     C                   EVAL      PDDAUD3 = DDAUD3
     C                   EVAL      PDDAUD4 = DDAUD4
     C                   EVAL      PDDAUD5 = DDAUD5

      ** Write Message subfile, FATCA details and footer screen

     C                   TIME                    #0TIME
     C                   WRITE     SDFTNHFS0
     C                   WRITE     SDFTNHFD1
     C                   WRITE     SDFTNHFF1

      ** Read Details Screen, If not write only

     C     WriteOnly     IFNE      'Y'
     C                   READ      SDFTNHFD1                              99
     C                   ENDIF

      ** If Exit/Previous screen not selected
      ** process user request for data tables with query '?'

     C     *INKC         IFEQ      *OFF
     C     *INKQ         ANDEQ     *OFF
     C     *INKS         ANDEQ     *OFF
     C     *INKT         ANDEQ     *OFF

     C                   IF        CSD093 = 'Y'

     C                   IF        PDDTED1 <> DDTED1
     C                   EVAL      DDTES1 = *BLANKS
     C                   ENDIF
     C                   IF        PDDTED2 <> DDTED2
     C                   EVAL      DDTES2 = *BLANKS
     C                   ENDIF
     C                   IF        PDDTED3 <> DDTED3
     C                   EVAL      DDTES3 = *BLANKS
     C                   ENDIF
     C                   IF        PDDTED4 <> DDTED4
     C                   EVAL      DDTES4 = *BLANKS
     C                   ENDIF
     C                   IF        PDDTED5 <> DDTED5
     C                   EVAL      DDTES5 = *BLANKS
     C                   ENDIF
     C                   IF        PDDTXD1 <> DDTXD1
     C                   EVAL      DDTXS1 = *BLANKS
     C                   ENDIF
     C                   IF        PDDTXD2 <> DDTXD2
     C                   EVAL      DDTXS2 = *BLANKS
     C                   ENDIF
     C                   IF        PDDTXD3 <> DDTXD3
     C                   EVAL      DDTXS3 = *BLANKS
     C                   ENDIF
     C                   IF        PDDTXD4 <> DDTXD4
     C                   EVAL      DDTXS4 = *BLANKS
     C                   ENDIF
     C                   IF        PDDTXD5 <> DDTXD5
     C                   EVAL      DDTXS5 = *BLANKS
     C                   ENDIF
     C                   IF        PDDAUD1 <> DDAUD1
     C                   EVAL      DDAUS1 = *BLANKS
     C                   ENDIF
     C                   IF        PDDAUD2 <> DDAUD2
     C                   EVAL      DDAUS2 = *BLANKS
     C                   ENDIF
     C                   IF        PDDAUD3 <> DDAUD3
     C                   EVAL      DDAUS3 = *BLANKS
     C                   ENDIF
     C                   IF        PDDAUD4 <> DDAUD4
     C                   EVAL      DDAUS4 = *BLANKS
     C                   ENDIF
     C                   IF        PDDAUD5 <> DDAUD5
     C                   EVAL      DDAUS5 = *BLANKS
     C                   ENDIF

      ** Override active document

     C                   MOVEL     DDTED1        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDTED1 = PCODE
     C                   MOVE      PSEQN         DDTES1
     C                   ENDIF

     C                   MOVEL     DDTED2        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDTED2 = PCODE
     C                   MOVE      PSEQN         DDTES2
     C                   ENDIF

     C                   MOVEL     DDTED3        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDTED3 = PCODE
     C                   MOVE      PSEQN         DDTES3
     C                   ENDIF

     C                   MOVEL     DDTED4        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDTED4 = PCODE
     C                   MOVE      PSEQN         DDTES4
     C                   ENDIF

     C                   MOVEL     DDTED5        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDTED5 = PCODE
     C                   MOVE      PSEQN         DDTES5
     C                   ENDIF

     C                   MOVEL     DDTXD1        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDTXD1 = PCODE
     C                   MOVE      PSEQN         DDTXS1
     C                   ENDIF

     C                   MOVEL     DDTXD2        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDTXD2 = PCODE
     C                   MOVE      PSEQN         DDTXS2
     C                   ENDIF

     C                   MOVEL     DDTXD3        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDTXD3 = PCODE
     C                   MOVE      PSEQN         DDTXS3
     C                   ENDIF

     C                   MOVEL     DDTXD4        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDTXD4 = PCODE
     C                   MOVE      PSEQN         DDTXS4
     C                   ENDIF

     C                   MOVEL     DDTXD5        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDTXD5 = PCODE
     C                   MOVE      PSEQN         DDTXS5
     C                   ENDIF

     C                   MOVEL     DDAUD1        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDAUD1 = PCODE
     C                   MOVE      PSEQN         DDAUS1
     C                   ENDIF

     C                   MOVEL     DDAUD2        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDAUD2 = PCODE
     C                   MOVE      PSEQN         DDAUS2
     C                   ENDIF

     C                   MOVEL     DDAUD3        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDAUD3 = PCODE
     C                   MOVE      PSEQN         DDAUS3
     C                   ENDIF

     C                   MOVEL     DDAUD4        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDAUD4 = PCODE
     C                   MOVE      PSEQN         DDAUS4
     C                   ENDIF

     C                   MOVEL     DDAUD5        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDAUD5 = PCODE
     C                   MOVE      PSEQN         DDAUS5
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

     C                   MOVEL     'SDFTNH4DP'   DBPGM

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
     C                   END

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
     C                   END

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

     C                   MOVEL     'SDFTCS4DSP'  DBPGM
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
(c) Finastra International Limited 2013
** @Z0
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
