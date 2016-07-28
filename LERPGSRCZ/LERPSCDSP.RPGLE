     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Repayments Schedule - Display')               *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LERPSCDSP - LE Repayments Schedule - Display                 *
      *                                                               *
      *  Function:  This module displays the main details screen      *
      *             of the Repayments Schedulee input function.       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE154             Date 02Aug12               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP079  *CREATE    Date 01Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE154 - Loan Repayment Schedule Enhancement                 *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CAP079 - Lending API enhancements - Repayments schedule      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLERPSCDDF CF   E             WORKSTN INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the LE standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.
      *
     D/COPY ZACPYSRC,PSDS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
     D @NAR            S             70    DIM(1) CTDATA PERRCD(1)
      *
     D @EI             S              1    DIM(60)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, SHORT data structure
      *
     D ScrRpSc       E DS                  EXTNAME(LERPSCPD)
     D OKScrRpSc     E DS                  EXTNAME(LEERPSCPD)
      *
     D                 DS
     D  D#FOTX                 1     70
     D  D#LNRF                48     53
     D  D#VDAT                55     60
     D  D#LSSQ                65     67
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ***  Main processing
      *
     C                   EXSR      MAIN
      *
      ***  Return
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing                                        *
      *****************************************************************
     C     MAIN          BEGSR
      *
      ***  Move 'OK' flags into array (for checking)
      *
     C                   MOVEA     OKScrRpSc     @EI
      *
      ***  Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUGT     60
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
      *
      ***  Do while error messages found
      ***  write error messages (with or without data) to sub-file
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   ZMSID
     C                   MOVEL     MsgDtaArr(C)  ZMSDA
      *
     C     MsgIdArr(C)   IFNE      *BLANKS
     C                   EXSR      ERRMSG
     C                   END
      *
     C                   ADD       1             C
     C                   END
      *
      ***  Do while warning messages found
      ***  Write warning messages (with or without data) to sub-file
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  ZMSID
     C                   MOVEL     WMsgDtaArr(C) ZMSDA
      *
     C     WMsgIdArr(C)  IFNE      *BLANKS
     C                   EXSR      ERRMSG
     C                   END
      *
     C                   ADD       1             C
     C                   END
      *
      ***  Position cursor on action code if it is blank
      *
     C     DDACTN        COMP      *BLANK                                 68
      *
      ***  Enable key fields (action code, loan number and sequence)
      *
     C     @EKYFD        COMP      'Y'                                6969
      *
      ***  Enable detail fields (all fields except action code, loan number and sequence)
      *
     C     @EDTFD        COMP      'Y'                                7070
      *
      ***  Enable function keys
      *
     C     @EINKN        COMP      'Y'                                    72    F14
     C     @EINKP        COMP      'Y'                                    73    F15
     C     @EINKG        COMP      'Y'                                    74    F07
     C     @EINKH        COMP      'Y'                                    74    F08
     C     @EINKK        COMP      'Y'                                    75    F11
      *
     C     @EINKJ        COMP      'Y'                                    76    F10
      *
      ***  Text
      *
     C                   MOVEL     *BLANKS       D#FOTX
     C     @LSSQ         IFNE      *BLANKS
     C     SaveACTN      ANDEQ     'I'
     C                   MOVEL     @NAR(1)       D#FOTX
     C                   MOVEL     @LNRF         D#LNRF
     C                   MOVEL     @VDAT         D#VDAT
     C                   MOVEL     @LSSQ         D#LSSQ
     C                   MOVEL     *BLANKS       @LNRF
     C                   MOVEL     *BLANKS       @VDAT
     C                   MOVEL     *BLANKS       @LSSQ
     C                   END
      *                                                                                       CLE154
     C                   MOVE      '0'           *IN90                                        CLE154
     C                   IF        CLE154 = 'Y'                                               CLE154
     C                   MOVE      '1'           *IN90                                        CLE154
     C                   ENDIF                                                                CLE154
      *
      ***  Write message sub-file, details and footer screen
      *
     C                   WRITE     LERPSCD1
     C                   WRITE     LERPSCC1
     C                   WRITE     LERPSCF1
     C                   MOVEL     DDACTN        SaveACTN          1
      *
      ***  Read details screen,
      *
      ***  If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      LERPSCD1                               99
     C                   ENDIF
      *
      ***  Clear message subfile
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGMQ        ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
      ***  Set screen error indicators OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      ***  Set return keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKK         @INKK
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKN         @INKN
     C                   MOVE      *INKP         @INKP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ERRMSG  - Output error messages                               *
      *****************************************************************
     C     ERRMSG        BEGSR
      *
      ***  Display error message
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM      'LERPSCDSP'   ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL                         Rel queue
     C                   PARM                    ZMSID             7            Message Id.
     C                   PARM                    ZMSGF                          Message file.
     C                   PARM                    ZMSDA           132            Message data.
     C                   PARM                    ZMSTP             7            Message type.
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing.                                  *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Parameters
      *
     C     *ENTRY        PLIST
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM                    RetCodeIn
      *
      ***  Repayment schedule (in screen format)
     C                   PARM                    ScrRpSc
      *
      ***  Fields in error
     C                   PARM                    OKScrRpSc
      *
      ***  Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      ***  Enabled function keys
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKK            1
     C                   PARM                    @EINKN            1
     C                   PARM                    @EINKP            1
      *
      ***  Succesful insert
     C                   PARM                    @LNRF             6
     C                   PARM                    @VDAT             6
     C                   PARM                    @LSSQ             3
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKK             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKN             1
     C                   PARM                    @INKP             1
      *
      ***  Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LERPSCDSP'   DBPGM
      *
      ***  Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     'GBLERMSGF'   ZMSGF            10
      *                                                                                       CLE154
      ** Check if CLE154 is on                                                                CLE154
      *                                                                                       CLE154
     C                   MOVE      'N'           CLE154            1                          CLE154
     C                   CALLB     'AOSARDR0'                                                 CLE154
     C                   PARM      *BLANK        @RTCD                                        CLE154
     C                   PARM      '*VERIFY'     @OPTN                                        CLE154
     C                   PARM      'CLE154'      @SARD                                        CLE154
      *                                                                                       CLE154
     C     @RTCD         IFEQ      *BLANKS                                                    CLE154
     C                   MOVE      'Y'           CLE154                                       CLE154
     C                   END                                                                  CLE154
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
** @Z0
000000000000000000000000000000000000000000000000000000000000
** @NAR
Sequence no. allocated to last repayment input 666666 666666 is 333
