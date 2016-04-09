     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Single Ccy Swaps Principal Change Sked')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRSPCDSHD - Single Ccy Swaps Principal Change Schedules      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. 237748             Date 01Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CAP041  *CREATE    Date 07Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  237748 - Principal change schedule not displayed when all    *
      *           principal changes have passed.  Display the screen  *
      *           even if no principal change dates exist.            *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date.                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
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
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Transaction Details in screen format
     D NwFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
      *
      ** Transaction Details OK indicators
     D OKFEBO        E DS                  EXTNAME(IREFEBOPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D/COPY QWINDSRC,IRSIRSGDTA
      *
      ** Index for arrays of of error message ids etc
     D IDx             S              3P 0
     D WIDx            S              3P 0
 
     D PWPSCY          S              3A
     D PWUCDP          S              1P 0
     D CIR006          S              1A
     D BJDFIN          S              1A
     D SACTN           S                   LIKE(#1ACTN) INZ(*BLANKS)
     D SMDAT           S                   LIKE(PVALD)  INZ(*BLANKS)
     D SVDAT           S                   LIKE(PMATD)  INZ(*BLANKS)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization.
      *
     C                   MOVE      *BLANK        RetCodeIn
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
      *
      ** Validate principal change dates.
      *
     C                   EXSR      SRValPrChD
      *
      ** Return.
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValPrChD - Validate principal change dates                 *
      *                                                               *
      *****************************************************************
 
     C     SRValPrChD    BEGSR
 
     C                   EVAL      SACTN = #1ACTN
     C                   MOVE      #1VDAT        ZDAYNO
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   MOVE      ZDATE         SVDAT
     C                   MOVE      #1MDAT        ZDAYNO
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   MOVE      ZDATE         SMDAT
 
     C*****SONPCD        IFNE      *BLANKS                                                    237748
 
     C     #1DTYP        IFEQ      'RS'
 
     C     CIR006        OREQ      'Y'
     C     #1DTYP        ANDEQ     'RP'
 
     C     CIR006        OREQ      'Y'
     C     #1DTYP        ANDEQ     'RR'
 
     C     CIR006        OREQ      'Y'
     C     #1DTYP        ANDEQ     'RF'
 
     C                   Z-ADD     #1DLNO        PDNUM
     C                   MOVE      #1DTYP        PDTYP
     C                   MOVE      *BLANKS       POTIN
     C                   MOVE      SONPCD        PCTLD
     C                   MOVE      SVDAT         PVALD
     C                   MOVE      SMDAT         PMATD
     C                   MOVEL     PWPSCY        PCURR
     C                   Z-ADD     PWUCDP        PNBDP
     C                   Z-ADD     #1UPAM        PPAMT
     C                   MOVE      #1ACTN        PPSCD
     C                   MOVE      *BLANKS       PRETC
      *
      ** Principal change schedule.
      *
     C                   EXSR      SRPrChSked
      *
      ** F3 pressed.
      *
     C     PRETC         IFEQ      'Y2U9999'
     C                   GOTO      ESRValPrChD
     C                   ENDIF
      *
      ** F12 pressed.
      *
     C     PRETC         IFEQ      'USR0790'
     C                   GOTO      ESRValPrChD
     C                   ENDIF
      *
      ** If date has changed, display error message.
      *
     C     PRETC         IFEQ      *BLANKS
     C     PCTLD         ANDNE     SONPCD
     C                   MOVE      PCTLD         SONPCD
     C                   EVAL      OKONPCD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'SONPCD    '
     C                   EVAL      MsgIdXAr(Idx) = 'RS00055'
     C                   GOTO      ESRValPrChD
     C                   ENDIF
 
     C                   ENDIF
 
     C*********         ENDIF                                                                 237748
 
     C     ESRValPrChD   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrChSked - Process principal change date scheduler         *
      *                                                               *
      *****************************************************************
     C     SRPrChSked    BEGSR
 
     C                   CALL      'DL4020'
     C                   PARM                    PDNUM             6 0
     C                   PARM                    PDTYP             2
     C                   PARM                    POTIN             1
     C                   PARM                    PCTLD             6
     C                   PARM                    PVALD             6
     C                   PARM                    PMATD             6
     C                   PARM                    PCURR             3
     C                   PARM                    PNBDP             1 0
     C                   PARM                    PPAMT            15 0
     C                   PARM                    PPSCD             1
     C                   PARM                    PRETC             7
 
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
      ** Return Code
     C                   PARM                    PRETC
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** Settlement currency
     C                   PARM                    PWPSCY
      *
      ** Decimal Places based on Up-Front Pay/Receive (Our)
     C                   PARM                    PWUCDP
      *
      ** STANDING DATA
      ** =============
     C                   PARM                    BJDFIN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** FRA/IRS Amortisation of Caps/Collars/Floors &
      ** Individual Compounding Swaps
     C                   PARM                    CIR006
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Deal information details
     C                   PARM                    Data
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
