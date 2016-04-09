     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans BoE Input')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LECLIPRPR1 - LE Customer Loans BoE Input                     *
      *                                                               *
      *  Function:  This will handle the processing of transactions   *
      *               on customer loans entered via RPR for           *
      *               BoE Customer Loans.                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. MD034876           Date 01Jul15               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. LLN022  *CREATE    Date 24Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD034876 - BOE Upgrade to FBM2.1 Compatibility Amendments    *
      *  LLN022 - Upgrade BoE to MidasPlus                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *  Extension file (retrieval)
      *
     FLEICLIPY0 IF   E           K DISK
     F                                     INFSR(*PSSR)
      ** Display File for Window
      *
     F***LELOAN#0* CF   E             WORKSTN                                               MD034876
     FLELOANDF  CF   E             WORKSTN                                                  MD034876
     F                                     INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *
      *  +--------------------------------------+
      *  ¦ Automatically included D-specs       ¦
      *  ¦ ==============================       ¦
      *  +--------------------------------------+
      *
      **--------------------------------------------------------------------------------------------
      *  The following /COPY line includes (among others) the LDA layout
      *  and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      *  The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      *  The following /COPY line includes all the defined fields in the
      *  Program Status Data Structures.  They have meaningful
      *  names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      *  The following /COPY line includes the definitions for error and
      *  warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      *  +--------------------------------------+
      *  ¦ End of automatically included D-specs¦
      *  ¦ =====================================¦
      *  +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      *  +--------------------------------------+
      *  ¦ Manually included D-specs            ¦
      *  ¦ =========================            ¦
      *  +--------------------------------------+

      *  +--------------------------------------+
      *  ¦ Named constants                      ¦
      *  ¦ ===============                      ¦
      *  +--------------------------------------+

      *  +--------------------------------------+
      *  ¦ Arrays and Data Structures           ¦
      *  ¦ ==========================           ¦
      *  +--------------------------------------+
      *
      ** Add 1 onto elements in array for each field on window
     D @EI             S              1    DIM(50)

      *
     D SPARE2          S            256A
      *

      *
      ** Copyright array
     D A@CPY           DS
      *
      ** Datastructure to define input parameter DATA
      /COPY QWINDSRC,LECLIPDTA
      *
      ** First DS for Access programs, Short data structure.
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for Access programs, Long data structure.
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details
      *
      ** NEW Loan Details in File Format
     D NwCLIPFilFmt  E DS                  EXTNAME(LEVCLIPX0)
      *
      ** NEW Loan Details in Screen Format
     D NwCLIPScnFmt  E DS                  EXTNAME(LECLEXPD)
      *
      **  Error indicators (OK#S)
     D OKFLAGS       E DS                  EXTNAME(LEECLIPX0)

      *  +--------------------------------------+
      *  ¦ Declared variables                   ¦
      *  ¦ ==================                   ¦
      *  +--------------------------------------+

      ** Action Code
     D ACTN            S              1A
     D W0RTN           S              7A
     D W8RTN           S              7A
     D WLEN            S              3S 0
     D WWID            S              3S 0
     D WProcess        S              1
     D TITLE           S              7A
     D TEXT            S            132A

      ** Standards Input Parameters
     D SROW            S              3  0
     D SCOL            S              3  0

      ** Standards Output Parameters
     D @INKC           S              1
     D @INKL           S              1

     D Idx             S              3P 0 INZ(0)
     D WIdx            S              3P 0 INZ(0)

     D PRtCd           S              7A
      ** Front Office ID
     D PL1AFRT         S             20A
      ** Timestamp
     D PL1TMST         S             26Z

      *  +--------------------------------------+
      *  ¦ End of D-specs                       ¦
      *  ¦ ==============                       ¦
      *  +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
      *
      *****************************************************************
      *                                                               *
      *  Main Loop                                                    *
      *                                                               *
      *  Calls: SRINIT                                                *
      *         SRCLEAR                                               *
      *         SRVCLR                                                *
      *         SREXIT                                                *
      *         SRPREV                                                *
      *         SRVALID                                               *
      *         SRTERM                                                *
      *                                                               *
      *****************************************************************
      *
      ** Initialise data
      *
     C                   EXSR      SRINIT
      *
      ** Do while screen: Key Details Screen
      *
     C                   DOU       WProcess = 'N'
      *
      ** Set screen error indicators according to status of 'OK' flags
      *
     C                   MOVEA     OKFLAGS       @EI
      *
      ** Initialise variables
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     50            E                 2 0
      *
      ** Do until greater than 10
      *
     C     C             DOUGT     10
      *
      ** If array field value is 'N' or 'W'
      *
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
      *
      ** Increment variables by 1
      *
     C                   ADD       1             C
     C                   ADD       1             E
      *
     C                   ENDDO
      *
      ** Do while error messages found write error messages to subfile
      *
     C                   Z-ADD     1             C
      *
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   ZAMSID
     C                   MOVEL     MsgDtaArr(C)  ZAMSDA
     C                   EXSR      ZASNMS
     C                   ADD       1             C
     C                   ENDDO
      *
      ** Do while warning messages found write warning messages to subfile
      *
     C                   Z-ADD     1             C
      *
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  ZAMSID
     C                   MOVEL     WMsgDtaArr(C) ZAMSDA
     C                   EXSR      ZASNMS
     C                   ADD       1             C
     C                   ENDDO
      *
      ** Write message subfile and window details screen
      *
     C                   IF        Idx > 0
     C                   WRITE     WINDOWF
     C                   WRITE     #MSGCTL
     C                   ENDIF
      *
      ** Display the window
      *
     C                   EXFMT     WINDOWF
      *
      ** Clear the message subfile
      *
     C                   EXSR      SRCLEAR
      *
      ** Set return keys
      *
     C                   EVAL      @INKC = *INKC
     C                   EVAL      @INKL = *INKC
      *
      ** Initialise the variables
      *
     C                   EXSR      SRVCLR
      *
      ** If F3 is pressed
      *
     C     *INKC         CASEQ     '1'           SREXIT
      *
      ** If F12 is pressed
      *
     C     *INKL         CASEQ     '1'           SRPREV
      *
      ** If other keys other than F3 & F12 is pressed
      *
     C                   CAS                     SRVALID
      *
     C                   ENDCS
      *
     C                   ENDDO
      *
      ** Exit from program
      *
     C                   EXSR      SRTERM
      *
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Entry Parameters
     C     *ENTRY        PLIST
     C                   PARM                    ACTN
     C                   PARM                    DATA
     C                   PARM                    W8RTN
     C                   PARM                    WLEN
     C                   PARM                    WWID
     C                   PARM                    SROW
     C                   PARM                    SCOL
     C                   PARM                    TITLE
     C                   PARM                    SPARE2
      *
      ** Bank ICD
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Define window position
      *
     C                   MOVE      SROW          SWROW
     C                   MOVE      SCOL          SWCOL
      *
      ** Initialize program name
      *
     C                   MOVEL     'LECLIPRPR1'  L#PGM

     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRINIT - Initialisation                                       *
      *                                                               *
      *  Calls: SREMOVI                                               *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Define window position
      *
     C                   EVAL      SWROW = SROW
     C                   EVAL      SWCOL = SCOL
      *
      ** Retrieve title for window
      *
     C                   EVAL      ZAMSGF = 'GBBYUSRMSG'
     C                   CALL      'SDRTVTXT'
     C                   PARM                    TITLE
     C                   PARM                    ZAMSGF
     C                   PARM                    TEXT
     C                   MOVEL     TEXT          L#TITL
      *
      ** Set up KLIST
      *
     C     K1KEY         KLIST
     C                   KFLD                    PL1AFRT
     C                   KFLD                    PL1TMST
      *
      ** Protect input fields if enquiry,
      **  else make sure they are highlighted on window
      **
      ** Get the Loan details from LEICLIPY0
      *
     C     K1KEY         CHAIN     LEICLIPY0                          86
     C     *IN86         IFEQ      *OFF
      *
      ** Moving fields into screen fields
     C                   EVAL      L#LNTP = LILNTP
     C                   EVAL      L#FMAT = LIFMAT
     C                   EVAL      LLNTPX = LILNTP
     C                   EVAL      LFMATX = LIFMAT
     C                   MOVE      LILNRF        BYLNRF
     C                   ELSE
     C                   EVAL      L#LNTP = *blanks
     C                   EVAL      L#FMAT = *blanks
     C                   EVAL      LLNTPX = *blanks
     C                   EVAL      LFMATX = *blanks
     C**********         EVAL      BYLNRF = 0                                               MD034876
     C                   EVAL      BYLNRF = *blanks                                         MD034876
      *
     C                   ENDIF
      *
     C                   EXSR      SRVCLR
      *
     C                   IF        ACTN   <> 'E'
     C                   CALLB     'LECLIPVAL1'
     C                   PARM                    ACTN
     C                   PARM                    DATA
     C                   PARM                    NwCLIPScnFmt
     C                   PARM                    BJDFIN
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwCLIPFilFmt
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      * SRCLEAR - Clear the message subfile                           *
      *                                                               *
      *  Called by: MAIN LOOP                                         *
      *             SRPREV                                            *
      *                                                               *
      *****************************************************************
     C     SRCLEAR       BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSProcName    ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
     C                   ENDSR
      *
      *****************************************************************
      * SREXIT - F3 is pressed                                        *
      *                                                               *
      *  Called by: MAIN LOOP                                         *
      *                                                               *
      *****************************************************************
     C     SREXIT        BEGSR
      *
      ** Set F3 return code and end program
      *
     C                   EVAL      W8RTN = 'Y2U9999'
     C                   EVAL      WProcess = 'N'
      *
     C                   ENDSR
      *
      *****************************************************************
      * SRPREV - F12 is pressed                                       *
      *                                                               *
      *  Called by: MAIN LOOP                                         *
      *                                                               *
      *  Calls: SRCLEAR                                               *
      *                                                               *
      *****************************************************************
     C     SRPREV        BEGSR
      *
      ** Set F12 return code and end program
      *
     C                   EVAL      W8RTN = 'USR0790'
     C                   EXSR      SRCLEAR
     C                   EVAL      WProcess = 'N'
      *
     C                   ENDSR
      *
      *****************************************************************
      * SRVCLR - F12 is pressed
      *                                                               *
      *  Called by: MAIN LOOP                                         *
      *                                                               *
      *****************************************************************
     C     SRVCLR        BEGSR
      *
      ** Function Keys
      *
     C                   MOVE      *ALL'0'       *IN
      *
      ** Reset Errors
      *
     C                   MOVE      *ALL'Y'       OKFLAGS
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIDArr  = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
     C                   EVAL      W8RTN      = *BLANK
     C                   EVAL      Idx        = 0
     C                   EVAL      WIdx       = 0
      *
     C                   IF        ACTN = 'E'
     C                   MOVE      '1'           *IN20
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * SRVALID - If function key (other than F3 & F12) or Enter is   *
      *           pressed                                             *
      *                                                               *
      *  Called by: MAIN LOOP                                         *
      *                                                               *
      *****************************************************************
     C     SRVALID       BEGSR
      *
     C
     C                   IF        ACTN     = 'E'
      *
     C                   EVAL      WProcess = 'N'
      *
     C                   ELSE
      *
     C                   EVAL      LLNTPX = L#LNTP
     C                   EVAL      LFMATX = L#FMAT
      *
      ** Call LEPCLIPVAL1
      *
     C                   CALLB     'LECLIPVAL1'
     C                   PARM                    ACTN
     C                   PARM                    DATA
     C                   PARM                    NwCLIPScnFmt
     C                   PARM                    BJDFIN
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwCLIPFilFmt
      *
      ** No errors so update the extension file
      *
     C                   IF        Idx = 0
     C                   EVAL      WProcess = 'N'
     C                   EVAL      BYLNTP = LLNTPX
     C                   EVAL      BYFMAT = LFMATX
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      * ZASNMS - Send message to program's message queue              *
      *                                                               *
      *  Called by: MAIN LOOP                                         *
      *                                                               *
      *****************************************************************
     C     ZASNMS        BEGSR
      *
      **Send message to program's message queue.
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM      L#PGM         ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
      *
     C                   ENDSR
      *****************************************************************
      * SRTERM - Seton LR and return                                  *
      *                                                               *
      *  Called by: MAIN LOOP                                         *
      *                                                               *
      *****************************************************************
     C     SRTERM        BEGSR
      *
     C                   SETON                                            LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  Program, module and procedure names for database error processing.
      *  =================================================================
      *  The following /COPY sets these values, and also defines LDA as
      *  an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
