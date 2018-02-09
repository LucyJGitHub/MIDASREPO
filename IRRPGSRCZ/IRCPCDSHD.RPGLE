     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Cross ccy swaps Principal Change Schedule')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCPCDSHD - Cross Ccy Swaps Principal Change Schedules       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 237748             Date 01Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP041  *CREATE    Date 07Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,IRCPCDS001
 
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
      *
      ** Parameters for ZALIGN
     D PZField         S             16A
     D PZADec          S              1P 0
     D PZADig          S              2P 0
     D PZalignOk       S              1A
      *
      ** Work parameters
     D PAmendOk        S              1A
     D PResetFld       S              1A
     D BJDFIN          S              1A
 
     D WBUYA           S             13P 0
     D AWBUYA          S             13P 0
 
     D WUFEE           S             13P 0
     D AWUFEE          S             13P 0
 
     D PWUCDP          S              1P 0
     D PWTCDP          S              1P 0
 
     D PWPSCY          S              3A
     D PWRSCY          S              3A
 
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
      /COPY WNCPYSRC,IRCPCDS002
 
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
     C                   CLEAR                   URETC
     C                   CLEAR                   UCTLD
     C                   CLEAR                   TRETC
     C                   CLEAR                   TCTLD
 
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
 
     C                   MOVE      '1'           *IN31
 
     C                   DOU       *IN31 = '1'
      **********                                                                              237748
      ***Our*next*principal*change*date*entered.*****************                             237748
      **********                                                                              237748
     C**********         IF        SONPCD <> *BLANKS                                          237748
 
     C                   Z-ADD     #1DLNO        PDNUM
     C                   MOVE      #1DTYP        PDTYP
     C                   MOVE      'U'           POTIN
     C                   MOVE      SONPCD        PCTLD
     C                   MOVE      SVDAT         PVALD
     C                   MOVE      SMDAT         PMATD
     C                   MOVEL     PWPSCY        PCURR
     C                   Z-ADD     PWUCDP        PNBDP
     C                   Z-ADD     #1UPAM        PPAMT
     C                   MOVE      SACTN         PPSCD
     C                   MOVE      *BLANKS       PRETC
      *
      ** Principal change schedule
      *
     C                   EXSR      SRPrChSked
 
     C                   MOVE      PRETC         URETC             7
     C                   MOVE      PCTLD         UCTLD             6
      *
      ** F3 pressed
      *
     C                   IF        PRETC = 'Y2U9999'
     C                   EXSR      SRExit
     C                   ELSE
      *
      ** F12 pressed
      *
     C                   IF        PRETC = 'USR0790'
     C                   MOVE      '1'           *IN31
     C                   EVAL      RetCodeIn = PRETC
     C                   ITER
 
     C                   ELSE
 
     C                   MOVE      '1'           *IN31
 
     C                   ENDIF
 
     C                   ENDIF
 
     C**********         ENDIF                                                                237748
      **********                                                                              237748
      ***Their*next*principal*change*date*entered.******************                          237748
      **********                                                                              237748
     C**********         IF        STNPCD <> *BLANKS                                          237748
 
     C                   Z-ADD     #1DLNO        PDNUM
     C                   MOVE      #1DTYP        PDTYP
     C                   MOVE      'T'           POTIN
     C                   MOVE      STNPCD        PCTLD
     C                   MOVE      SVDAT         PVALD
     C                   MOVE      SMDAT         PMATD
     C                   MOVEL     PWRSCY        PCURR
     C                   Z-ADD     PWTCDP        PNBDP
     C                   Z-ADD     #1TPAM        PPAMT
     C                   MOVE      SACTN         PPSCD
     C                   MOVE      *BLANKS       PRETC
      *
      ** Principal change schedule
      *
     C                   EXSR      SRPrChSked
 
     C                   MOVE      PRETC         TRETC             7
     C                   MOVE      PCTLD         TCTLD             6
      *
      ** F3 pressed
      *
     C                   IF        PRETC = 'Y2U9999'
     C                   EXSR      SRExit
     C                   ELSE
      *
      ** F12 pressed
      *
     C                   IF        PRETC = 'USR0790'
 
     C                   IF        SONPCD <> *BLANKS
     C                   MOVE      '0'           *IN31
     C                   ELSE
     C                   MOVE      '1'           *IN31
     C                   ENDIF
 
     C                   EVAL      RetCodeIn = PRETC
 
     C                   ELSE
 
     C                   MOVE      '1'           *IN31
 
     C                   ENDIF
 
     C                   ENDIF
 
     C**********         ENDIF                                                                237748
      *
     C                   ENDDO
      *
      ** If date has changed, display error message
      *
     C                   IF        URETC = *BLANKS and UCTLD <> SONPCD
     C                   MOVE      UCTLD         SONPCD
     C                   EVAL      OKONPCD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'SONPCD    '
     C                   EVAL      MsgIdXAr(Idx) = 'RS00055'
     C                   GOTO      ESRValPrChD
     C                   ENDIF
      *
     C                   IF        TRETC = *BLANKS and TCTLD <> *BLANKS
     C                             and TCTLD <> STNPCD
     C                   MOVE      TCTLD         STNPCD
     C                   EVAL      OKTNPCD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'SONPCD    '
     C                   EVAL      MsgIdXAr(Idx) = 'RS00055'
     C                   GOTO      ESRValPrChD
     C                   ENDIF
 
     C     ESRValPrChD   ENDSR
      *
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
      *  SRExit - Exit from program if F3 has been pressed            *
      *                                                               *
      *****************************************************************
      *
     C     SRExit        BEGSR
      *
      **   Set F3 return code and end program
      *
     C                   EVAL      RetCodeIn = 'Y2U9999'
      *
     C                   RETURN
      *
     C                   ENDSR
      *
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
     C                   PARM                    RetCodeIn
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** Deal information details
     C                   PARM                    Data
      *
      ** Decimal Places based on Up-Front Pay/Receive (Our)
     C                   PARM                    PWUCDP
      *
      ** Decimal Places based on Up-Front Pay/Receive (Their)
     C                   PARM                    PWTCDP
      *
      ** Effective Settlement Currency (Our)
     C                   PARM                    PWPSCY
      *
      ** Effective Settlement Currency (Their)
     C                   PARM                    PWRSCY
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
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
(c) Finastra International Limited 2001
