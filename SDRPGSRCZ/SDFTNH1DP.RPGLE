     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Non-A/c Holder details 1 screen')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDFTNH1DP  - FATCA Non-Account Holder details - Primary      *
      *               Screen                                          *
      *                                                               *
      *  Function:  This module displays the 1st details screen       *
      *             of FATCA Non-account holder details screen        *
      *             input function                                    *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD029805           Date 05Sep14               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD029805 - GIIN number validation (Recompile)                *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDFTNH1DDFCF   E             WORKSTN

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

     D @Z0             S              1    DIM(89) CTDATA PERRCD(89)

     D @EI             S              1    DIM(170)

     D P@Mode          S              7A
     D PRtcd           S              7A
     D PCust           S             10A
     D PType           S              1A
     D PCode           S              2A
     D PSeqn           S              3A
     D CSD093          S              1A
     D CGL133          S              1A
     D PDDHMD1         S              2A
     D PDDHMD2         S              2A
     D PDDHMD3         S              2A
     D PDDHMD4         S              2A
     D PDDHMD5         S              2A
     D PDDMCD1         S              2A
     D PDDMCD2         S              2A
     D PDDMCD3         S              2A
     D PDDMCD4         S              2A
     D PDDMCD5         S              2A
     D PDDRPD1         S              2A
     D PDDRPD2         S              2A
     D PDDRPD3         S              2A
     D PDDRPD4         S              2A
     D PDDRPD5         S              2A

     D ReturnDS        DS
     D RetCode                        7A
     D ClsCode                        5A
     D ClsDesc                       50A

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
     C                   ENDIF

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
     C                   Z-ADD     11            E                 2 0

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

     C     'N'           LOOKUP    @EI                                    08

     C                   IF        CGL133 = 'N'
     C                   MOVE      *OFF          *IN86
     C     DDACTI        IFEQ      'E'
     C                   MOVE      *ON           *IN86
     C                   MOVE      *ON           *IN87
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *ON           *IN86
     C                   ENDIF

     C                   EVAL      PDDHMD1 = DDHMD1
     C                   EVAL      PDDHMD2 = DDHMD2
     C                   EVAL      PDDHMD3 = DDHMD3
     C                   EVAL      PDDHMD4 = DDHMD4
     C                   EVAL      PDDHMD5 = DDHMD5
     C                   EVAL      PDDMCD1 = DDMCD1
     C                   EVAL      PDDMCD2 = DDMCD2
     C                   EVAL      PDDMCD3 = DDMCD3
     C                   EVAL      PDDMCD4 = DDMCD4
     C                   EVAL      PDDMCD5 = DDMCD5
     C                   EVAL      PDDRPD1 = DDRPD1
     C                   EVAL      PDDRPD2 = DDRPD2
     C                   EVAL      PDDRPD3 = DDRPD3
     C                   EVAL      PDDRPD4 = DDRPD4
     C                   EVAL      PDDRPD5 = DDRPD5

      ** Write Message subfile, FATCA details and footer screen

     C                   TIME                    #0TIME
     C                   WRITE     SDFTNHPS0
     C                   WRITE     SDFTNHPD1
     C                   WRITE     SDFTNHPF1

      ** Read Details Screen, If not write only

     C     WriteOnly     IFNE      'Y'
     C                   READ      SDFTNHPD1                              99
     C                   ENDIF

      ** If Exit/Previous screen not selected
      ** process user request for data tables with query '?'

     C     *INKC         IFEQ      *OFF
     C     *INKQ         ANDEQ     *OFF
     C     *INKS         ANDEQ     *OFF
     C     *INKT         ANDEQ     *OFF

     C                   IF        PDDHMD1 <> DDHMD1
     C                   EVAL      DDHMS1 = *BLANKS
     C                   ENDIF
     C                   IF        PDDHMD2 <> DDHMD2
     C                   EVAL      DDHMS2 = *BLANKS
     C                   ENDIF
     C                   IF        PDDHMD3 <> DDHMD3
     C                   EVAL      DDHMS3 = *BLANKS
     C                   ENDIF
     C                   IF        PDDHMD4 <> DDHMD4
     C                   EVAL      DDHMS4 = *BLANKS
     C                   ENDIF
     C                   IF        PDDHMD5 <> DDHMD5
     C                   EVAL      DDHMS5 = *BLANKS
     C                   ENDIF
     C                   IF        PDDMCD1 <> DDMCD1
     C                   EVAL      DDMCS1 = *BLANKS
     C                   ENDIF
     C                   IF        PDDMCD2 <> DDMCD2
     C                   EVAL      DDMCS2 = *BLANKS
     C                   ENDIF
     C                   IF        PDDMCD3 <> DDMCD3
     C                   EVAL      DDMCS3 = *BLANKS
     C                   ENDIF
     C                   IF        PDDMCD4 <> DDMCD4
     C                   EVAL      DDMCS4 = *BLANKS
     C                   ENDIF
     C                   IF        PDDMCD5 <> DDMCD5
     C                   EVAL      DDMCS5 = *BLANKS
     C                   ENDIF
     C                   IF        PDDRPD1 <> DDRPD1
     C                   EVAL      DDRPS1 = *BLANKS
     C                   ENDIF
     C                   IF        PDDRPD2 <> DDRPD2
     C                   EVAL      DDRPS2 = *BLANKS
     C                   ENDIF
     C                   IF        PDDRPD3 <> DDRPD3
     C                   EVAL      DDRPS3 = *BLANKS
     C                   ENDIF
     C                   IF        PDDRPD4 <> DDRPD4
     C                   EVAL      DDRPS4 = *BLANKS
     C                   ENDIF
     C                   IF        PDDRPD5 <> DDRPD5
     C                   EVAL      DDRPS5 = *BLANKS
     C                   ENDIF

      ** Classification Code

     C                   MOVEL     DDCLAC        QRYFLD            1
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000100'
     C                   PARM      '*SELECT'     P@Mode
     C                   PARM                    ReturnDS

     C                   EVAL      DDCLAC = ClsCode

     C                   ENDIF

     C                   IF        CSD093 = 'Y'

      ** Override active document

     C                   MOVEL     DDHMD1        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDHMD1 = PCODE
     C                   MOVE      PSEQN         DDHMS1
     C                   ENDIF

     C                   MOVEL     DDHMD2        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDHMD2 = PCODE
     C                   MOVE      PSEQN         DDHMS2
     C                   ENDIF

     C                   MOVEL     DDHMD3        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDHMD3 = PCODE
     C                   MOVE      PSEQN         DDHMS3
     C                   ENDIF

     C                   MOVEL     DDHMD4        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDHMD4 = PCODE
     C                   MOVE      PSEQN         DDHMS4
     C                   ENDIF

     C                   MOVEL     DDHMD5        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDHMD5 = PCODE
     C                   MOVE      PSEQN         DDHMS5
     C                   ENDIF

     C                   MOVEL     DDMCD1        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDMCD1 = PCODE
     C                   MOVE      PSEQN         DDMCS1
     C                   ENDIF

     C                   MOVEL     DDMCD2        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDMCD2 = PCODE
     C                   MOVE      PSEQN         DDMCS2
     C                   ENDIF

     C                   MOVEL     DDMCD3        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDMCD3 = PCODE
     C                   MOVE      PSEQN         DDMCS3
     C                   ENDIF

     C                   MOVEL     DDMCD4        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDMCD4 = PCODE
     C                   MOVE      PSEQN         DDMCS4
     C                   ENDIF

     C                   MOVEL     DDMCD5        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDMCD5 = PCODE
     C                   MOVE      PSEQN         DDMCS5
     C                   ENDIF

     C                   MOVEL     DDRPD1        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDRPD1 = PCODE
     C                   MOVE      PSEQN         DDRPS1
     C                   ENDIF

     C                   MOVEL     DDRPD2        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDRPD2 = PCODE
     C                   MOVE      PSEQN         DDRPS2
     C                   ENDIF

     C                   MOVEL     DDRPD3        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDRPD3 = PCODE
     C                   MOVE      PSEQN         DDRPS3
     C                   ENDIF

     C                   MOVEL     DDRPD4        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDRPD4 = PCODE
     C                   MOVE      PSEQN         DDRPS4
     C                   ENDIF

     C                   MOVEL     DDRPD5        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN

     C                   EVAL      DDRPD5 = PCODE
     C                   MOVE      PSEQN         DDRPS5
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

      ** Clear message subfile
      ** Set screen error indicators off

     C                   MOVEA     @Z0           *IN(10)

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

     C                   MOVEL     'SDFTCSPDSP'  DBPGM

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

      ** Check if switchable feature CSD093 is switched on.

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
     C                   ENDIF

     C                   IF        @RTCD = *BLANKS
     C                   MOVE      *ON           *IN87
     C                   EVAL      CSD093 = 'Y'
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
     C                   ENDIF

     C                   IF        @RTCD = *BLANKS
     C                   MOVE      *ON           *IN86
     C                   MOVE      *ON           *IN87
     C                   EVAL      CGL133 = 'Y'
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

     C                   MOVEL     'SDFTCSPDSP'  DBPGM
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
