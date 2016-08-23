     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Non-A/c Holder details 3 screen')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDFTNH3DP  - FATCA Customer details 3 Screen                 *
      *                                                               *
      *  Function:  This module displays the third details screen     *
      *             of FATCA customer details screen input function   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD029805           Date 05Sep14               *
      *  Prev Amend No. MD027464           Date 15Aug13               *
      *                 CGL133             Date 01May13               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029805 - GIIN number validation (Recompile)                *
      *  MD027464 - Override/Override comments Blank and Invalid      *
      *             Inputs point to incorrect                         *
      *  CGL133 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Enquiry                            *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDFTNH3DDFCF   E             WORKSTN
 
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
     D PDDGCD1         S              2A
     D PDDGCD2         S              2A
     D PDDGCD3         S              2A
     D PDDGCD4         S              2A
     D PDDGCD5         S              2A
     D PDDIDD1         S              2A
     D PDDIDD2         S              2A
     D PDDIDD3         S              2A
     D PDDIDD4         S              2A
     D PDDIDD5         S              2A
     D PDDJAD1         S              2A
     D PDDJAD2         S              2A
     D PDDJAD3         S              2A
     D PDDJAD4         S              2A
     D PDDJAD5         S              2A
 
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
     C                   ENDIF                                                                CGL133
 
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
     C                   ENDIF                                                                CGL133
 
     C                   EVAL      PDDGCD1 = DDGCD1
     C                   EVAL      PDDGCD2 = DDGCD2
     C                   EVAL      PDDGCD3 = DDGCD3
     C                   EVAL      PDDGCD4 = DDGCD4
     C                   EVAL      PDDGCD5 = DDGCD5
     C                   EVAL      PDDIDD1 = DDIDD1
     C                   EVAL      PDDIDD2 = DDIDD2
     C                   EVAL      PDDIDD3 = DDIDD3
     C                   EVAL      PDDIDD4 = DDIDD4
     C                   EVAL      PDDIDD5 = DDIDD5
     C                   EVAL      PDDJAD1 = DDJAD1
     C                   EVAL      PDDJAD2 = DDJAD2
     C                   EVAL      PDDJAD3 = DDJAD3
     C                   EVAL      PDDJAD4 = DDJAD4
     C                   EVAL      PDDJAD5 = DDJAD5
 
 
      ** Write Message subfile, FATCA details and footer screen
 
     C                   TIME                    #0TIME
     C                   WRITE     SDFTNHTS0
     C                   WRITE     SDFTNHTD1
     C                   WRITE     SDFTNHTF1
 
      ** Read Details Screen, If not write only
 
     C     WriteOnly     IFNE      'Y'
     C                   READ      SDFTNHTD1                              99
     C                   ENDIF
 
      ** If Exit/Previous screen not selected
      ** process user request for data tables with query '?'
 
     C     *INKC         IFEQ      *OFF
     C     *INKQ         ANDEQ     *OFF
     C     *INKS         ANDEQ     *OFF
     C     *INKT         ANDEQ     *OFF
 
     C                   IF        CSD093 = 'Y'
 
     C                   IF        PDDGCD1 <> DDGCD1
     C                   EVAL      DDGCS1 = *BLANKS
     C                   ENDIF
     C                   IF        PDDGCD2 <> DDGCD2
     C                   EVAL      DDGCS2 = *BLANKS
     C                   ENDIF
     C                   IF        PDDGCD3 <> DDGCD3
     C                   EVAL      DDGCS3 = *BLANKS
     C                   ENDIF
     C                   IF        PDDGCD4 <> DDGCD4
     C                   EVAL      DDGCS4 = *BLANKS
     C                   ENDIF
     C                   IF        PDDGCD5 <> DDGCD5
     C                   EVAL      DDGCS5 = *BLANKS
     C                   ENDIF
     C                   IF        PDDIDD1 <> DDIDD1
     C                   EVAL      DDIDS1 = *BLANKS
     C                   ENDIF
     C                   IF        PDDIDD2 <> DDIDD2
     C                   EVAL      DDIDS2 = *BLANKS
     C                   ENDIF
     C                   IF        PDDIDD3 <> DDIDD3
     C                   EVAL      DDIDS3 = *BLANKS
     C                   ENDIF
     C                   IF        PDDIDD4 <> DDIDD4
     C                   EVAL      DDIDS4 = *BLANKS
     C                   ENDIF
     C                   IF        PDDIDD5 <> DDIDD5
     C                   EVAL      DDIDS5 = *BLANKS
     C                   ENDIF
     C                   IF        PDDJAD1 <> DDJAD1
     C                   EVAL      DDJAS1 = *BLANKS
     C                   ENDIF
     C                   IF        PDDJAD2 <> DDJAD2
     C                   EVAL      DDJAS2 = *BLANKS
     C                   ENDIF
     C                   IF        PDDJAD3 <> DDJAD3
     C                   EVAL      DDJAS3 = *BLANKS
     C                   ENDIF
     C                   IF        PDDJAD4 <> DDJAD4
     C                   EVAL      DDJAS4 = *BLANKS
     C                   ENDIF
     C                   IF        PDDJAD5 <> DDJAD5
     C                   EVAL      DDJAS5 = *BLANKS
     C                   ENDIF
 
      ** Override active document
 
     C                   MOVEL     DDGCD1        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDGCD1 = PCODE
     C                   MOVE      PSEQN         DDGCS1
     C                   ENDIF
 
     C                   MOVEL     DDGCD2        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDGCD2 = PCODE
     C                   MOVE      PSEQN         DDGCS2
     C                   ENDIF
 
     C                   MOVEL     DDGCD3        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDGCD3 = PCODE
     C                   MOVE      PSEQN         DDGCS3
     C                   ENDIF
 
     C                   MOVEL     DDGCD4        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDGCD4 = PCODE
     C                   MOVE      PSEQN         DDGCS4
     C                   ENDIF
 
     C                   MOVEL     DDGCD5        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDGCD5 = PCODE
     C                   MOVE      PSEQN         DDGCS5
     C                   ENDIF
 
     C                   MOVEL     DDIDD1        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDIDD1 = PCODE
     C                   MOVE      PSEQN         DDIDS1
     C                   ENDIF
 
     C                   MOVEL     DDIDD2        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDIDD2 = PCODE
     C                   MOVE      PSEQN         DDIDS2
     C                   ENDIF
 
     C                   MOVEL     DDIDD3        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDIDD3 = PCODE
     C                   MOVE      PSEQN         DDIDS3
     C                   ENDIF
 
     C                   MOVEL     DDIDD4        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDIDD4 = PCODE
     C                   MOVE      PSEQN         DDIDS4
     C                   ENDIF
 
     C                   MOVEL     DDIDD5        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDIDD5 = PCODE
     C                   MOVE      PSEQN         DDIDS5
     C                   ENDIF
 
     C                   MOVEL     DDJAD1        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDJAD1 = PCODE
     C                   MOVE      PSEQN         DDJAS1
     C                   ENDIF
 
     C                   MOVEL     DDJAD2        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDJAD2 = PCODE
     C                   MOVE      PSEQN         DDJAS2
     C                   ENDIF
 
     C                   MOVEL     DDJAD3        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDJAD3 = PCODE
     C                   MOVE      PSEQN         DDJAS3
     C                   ENDIF
 
     C                   MOVEL     DDJAD4        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDJAD4 = PCODE
     C                   MOVE      PSEQN         DDJAS4
     C                   ENDIF
 
     C                   MOVEL     DDJAD5        QRYFLD
     C     QRYFLD        IFEQ      '?'
     C                   CALL      'SD000711S'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      DDNAHL        PCUST
     C                   PARM      'N'           PTYPE
     C                   PARM      *BLANKS       PCODE
     C                   PARM      *ZERO         PSEQN
 
     C                   EVAL      DDJAD5 = PCODE
     C                   MOVE      PSEQN         DDJAS5
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
 
     C                   MOVEL     'SDFTNH3DP'   DBPGM
 
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
                                                                                              CGL133
      ** Check if switchable feature CGL133 is switched on.                                   CGL133
                                                                                              CGL133
     C                   EVAL      CGL133 = 'N'                                               CGL133
                                                                                              CGL133
     C                   CALL      'AOSARDR0'                                                 CGL133
     C                   PARM      *BLANKS       @RTCD                                        CGL133
     C                   PARM      '*VERIFY'     @OPTN                                        CGL133
     C                   PARM      'CGL133'      @SARD                                        CGL133
                                                                                              CGL133
      ** Database error                                                                       CGL133
                                                                                              CGL133
     C     @RTCD         IFNE      *BLANKS                                                    CGL133
     C     @RTCD         ANDNE     '*NRF   '                                                  CGL133
     C                   MOVEL     'CGL133'      DBKEY                                        CGL133
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL133
     C                   MOVEL     '003'         DBASE                                        CGL133
     C                   EXSR      SRERR                                                      CGL133
     C                   ENDIF                                                                CGL133
                                                                                              CGL133
     C     @RTCD         IFEQ      *BLANKS                                                    CGL133
     C                   EVAL      CGL133 = 'Y'                                               CGL133
     C                   MOVE      *ON           *IN86                                        CGL133
     C                   MOVE      *ON           *IN87                                        CGL133
     C                   ENDIF                                                                CGL133
 
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
 
     C                   MOVEL     'SDFTCS3DSP'  DBPGM
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
