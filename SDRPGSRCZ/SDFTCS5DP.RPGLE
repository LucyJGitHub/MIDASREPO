     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Customer details 5 screen')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDFTCS5DP  - FATCA Customer details 5 Screen                 *
      *                                                               *
      *  Function:  This module displays the fifth details screen     *
      *             of FATCA customer details screen input function   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL132 - Foreign Account Tax Compliance Act                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDFTCS5DDFCF   E             WORKSTN
 
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
 
     D @EI             S              1    DIM(170)
 
     D  P@Mode         S              7A
 
     D CrFaScnFmt    E DS                  EXTNAME(SDFTCRPD)
     D CrCuScnFmt    E DS                  EXTNAME(SDCUPRPD)
     D OKFATCAdet    E DS                  EXTNAME(SDEFTCSPD)
 
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
 
     D  CGL132         S              1A
     D  CGL133         S              1A
 
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
 
     C                   Z-ADD     1             C                 3 0
     C                   Z-ADD     -66           E                 3 0
 
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
 
     D/COPY ZACPYSRC,MSGHNDDSP1
 
      ** Position cursor on first field if no errors
 
     C     'N'           LOOKUP    @EI                                    01
 
     C                   MOVE      *OFF          *IN09
     C     DDACTI        IFEQ      'E'
     C     CGL133        OREQ      'Y'
     C                   MOVE      *ON           *IN09
     C                   ENDIF
 
     C     @EINKX        COMP      'Y'                                    96
 
      ** Write Message subfile, FATCA details and footer screen
 
     C                   TIME                    #0TIME
     C                   WRITE     SDFTCSIS0
     C                   WRITE     SDFTCSID1
     C                   WRITE     SDFTCSIF1
 
      ** Read Details Screen, If not write only
 
     C     WriteOnly     IFNE      'Y'
     C                   READ      SDFTCSID1                              99
     C                   ENDIF
 
      ** Clear message subfile
      ** Set screen error indicators off
 
     C                   MOVEA     @Z0           *IN(02)
 
      ** Set return keys
 
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKR         @INKR
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
     C                   PARM                    @EINKX            1
 
      ** OUTPUT PARAMETERS :
      ** Function Keys
 
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKR             1
     C                   PARM                    @INKS             1
     C                   PARM                    @INKT             1
 
      ** Write screen with no read indicator
     C                   PARM                    WriteOnly         1
 
      ** Initialize program name
 
     C                   MOVEL     'SDFTCS5DP'   DBPGM
 
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
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL132'      @SARD
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CGL132'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      SRERR
     C                   END
 
     C     @RTCD         IFEQ      '       '
     C                   MOVE      'Y'           CGL132
     C                   END
 
      ** Check if switchable feature CGL133 is switched on.
 
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
 
     C     @RTCD         IFEQ      '       '
     C                   MOVE      'Y'           CGL133
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
 
     C                   MOVEL     'SDFTCS5DSP'  DBPGM
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
