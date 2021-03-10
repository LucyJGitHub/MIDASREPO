     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate value date positions')               *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSVDPOS - Validate Value Date Positions                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 14May01               *
      *                 CAP060             Date 14May01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD006 - Market Data Feeds (recompile)                       *
      *  CAP060 - Midas APIs, Security Prices Full API (recompile)    *
      *  CAP137 - Conversion of SE Security Inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas SE Book Position Headers
     FBKPHD     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas SE Book Positions
     FBKPOS     IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
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
      ** Data Structure to hold Coupon/Rate Days array
     D WSCD            S              4A   DIM(12)
      *
      ** Data Structure to hold Coupon/Rate Indicators array
     D WSCR            S              1A   DIM(12)
      *
      ** Data Structure to hold Original Coupon/Rate Days array
     D WOCD            S              4A   DIM(12)
      *
      ** Data Structure to hold Original Coupon/Rate Indicators array
     D WOCR            S              1A   DIM(12)
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
      *
      ** Securities screen 2 details retrieved from file
      ** - screen format
     D CrSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
     D                                     PREFIX(O)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities screen 2 error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of warning error message ids, etc.
     D WIx             S              3P 0

     D WWSCD           S             48A
     D WWSCR           S             12A
     D WWOCD           S             48A
     D WWOCR           S             12A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise work variables.
      *
     C                   EVAL      WIx = 0
      *
     C                   EXSR      SRGetArr
      *
      ** Check if the Security has Live Value Positions for Amend.
      *
     C     DDITLD        IFNE      ODDITLD
     C     DDFCPN        ORNE      ODDFCPN
     C     WWSCD         ORNE      WWOCD
     C     WWSCR         ORNE      WWOCR
     C                   EXSR      SRChkPos
     C                   ENDIF
      *
      ** If an error has been found, set return code appropriately.
      *
     C                   IF        WIx <> 0
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetArr - Get coupon rate/day indicators                    *
      *                                                               *
      *****************************************************************

     C     SRGetArr      BEGSR
      *
     C                   MOVE      DDCD01        WSCD(1)
     C                   MOVE      DDCD02        WSCD(2)
     C                   MOVE      DDCD03        WSCD(3)
     C                   MOVE      DDCD04        WSCD(4)
     C                   MOVE      DDCD05        WSCD(5)
     C                   MOVE      DDCD06        WSCD(6)
     C                   MOVE      DDCD07        WSCD(7)
     C                   MOVE      DDCD08        WSCD(8)
     C                   MOVE      DDCD09        WSCD(9)
     C                   MOVE      DDCD10        WSCD(10)
     C                   MOVE      DDCD11        WSCD(11)
     C                   MOVE      DDCD12        WSCD(12)

     C                   MOVE      DDCR01        WSCR(1)
     C                   MOVE      DDCR02        WSCR(2)
     C                   MOVE      DDCR03        WSCR(3)
     C                   MOVE      DDCR04        WSCR(4)
     C                   MOVE      DDCR05        WSCR(5)
     C                   MOVE      DDCR06        WSCR(6)
     C                   MOVE      DDCR07        WSCR(7)
     C                   MOVE      DDCR08        WSCR(8)
     C                   MOVE      DDCR09        WSCR(9)
     C                   MOVE      DDCR10        WSCR(10)
     C                   MOVE      DDCR11        WSCR(11)
     C                   MOVE      DDCR12        WSCR(12)
      *
     C                   MOVE      ODDCD01       WOCD(1)
     C                   MOVE      ODDCD02       WOCD(2)
     C                   MOVE      ODDCD03       WOCD(3)
     C                   MOVE      ODDCD04       WOCD(4)
     C                   MOVE      ODDCD05       WOCD(5)
     C                   MOVE      ODDCD06       WOCD(6)
     C                   MOVE      ODDCD07       WOCD(7)
     C                   MOVE      ODDCD08       WOCD(8)
     C                   MOVE      ODDCD09       WOCD(9)
     C                   MOVE      ODDCD10       WOCD(10)
     C                   MOVE      ODDCD11       WOCD(11)
     C                   MOVE      ODDCD12       WOCD(12)

     C                   MOVE      ODDCR01       WOCR(1)
     C                   MOVE      ODDCR02       WOCR(2)
     C                   MOVE      ODDCR03       WOCR(3)
     C                   MOVE      ODDCR04       WOCR(4)
     C                   MOVE      ODDCR05       WOCR(5)
     C                   MOVE      ODDCR06       WOCR(6)
     C                   MOVE      ODDCR07       WOCR(7)
     C                   MOVE      ODDCR08       WOCR(8)
     C                   MOVE      ODDCR09       WOCR(9)
     C                   MOVE      ODDCR10       WOCR(10)
     C                   MOVE      ODDCR11       WOCR(11)
     C                   MOVE      ODDCR12       WOCR(12)

     C                   MOVEA     WSCD          WWSCD
     C                   MOVEA     WSCR          WWSCR

     C                   MOVEA     WOCD          WWOCD
     C                   MOVEA     WOCR          WWOCR

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkPos - Check for Value Date Positions                    *
      *                                                               *
      *****************************************************************

     C     SRChkPos      BEGSR

     C     S1SESN        SETLL     BKPHDDF
     C                   EVAL      *IN01 = *OFF

     C                   DOW       *IN01 = *OFF
     C     S1SESN        READE     BKPHDDF                                01

     C                   IF        *IN01 = *OFF AND
     C                             RECI = 'D'
     C     KBPKY         CHAIN     BKPOS                              01

     C                   IF        *IN01 = *OFF AND
     C                             RECI = 'D'

     C                   IF        ECNP <> *ZEROS OR
     C                             NPSN <> *ZEROS
     C                   ADD       1             WIx
     C                   MOVE      'SEA0154'     WMsgIDXAr(WIx)
     C                   EVAL      *IN01 = *ON
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities screen 2 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE2ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Key to access Book Position records
      *
     C     KBPKY         KLIST
     C                   KFLD                    BHSC
     C                   KFLD                    BHBA
     C                   KFLD                    BHBK
     C                   KFLD                    BHMK
     C                   KFLD                    BHTV
     C                   KFLD                    LPSD
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
