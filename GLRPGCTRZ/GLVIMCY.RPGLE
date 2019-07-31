     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JE Item Original Ccy/Amount')        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVIMCY    - Validate Journal Batch Entry Item Original      *
      *               Currency and Amount                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 08May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 238620             Date 16Mar06               *
      *                 CSD031             Date 10Apr06               *
      *                 TCA102             Date 02Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  238620 - Include warning message arrays into output parms.   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  TCA102 - Various errors on Journal Entry input (Recompile).  *
      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
      ** Valid JE Item (DS) - for file update
     D PVBITP        E DS                  EXTNAME(GLVBITPPD)
      *
      ** Externally described DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for Access Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      ** Index for arrays of warning message ids, etc.
     D WIx             S              3P 0
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      *                                                                                     MD000091
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
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIx
      *
     C                   CLEAR                   WORAMT           15 0
     C                   CLEAR                   WINCY
     C                   CLEAR                   WNBDP
     C                   CLEAR                   WCcyNRF           1
      *
      ** Validate Original Currency and Amount.
      *
     C                   EXSR      SRProc
      *
     C     DDOamtOK      IFEQ      'N'
     C     DDOccyOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   EVAL      B2OAMT = WORAMT
     C                   EVAL      B2OCCY = DDOCCY
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process Original Currency/Amount input              *
      *                                                               *
      *****************************************************************
      *
     C     SRProc        BEGSR
      *
      ** Get Currency and Amount details.
      *
     C                   EXSR      SRGetOCcy
     C                   EXSR      SRGetOAmt
      *
      *----------------------------------------------------------------
      ** Input is allowed only if Currency is 'Euro'
      ** or 'In' Currency.
      *----------------------------------------------------------------
      *
     C     PINCY         IFEQ      'Y'
     C     B2CYCD        OREQ      BKEURO
      *
      ** Generate error if Original Currency is not existing.
      *
     C     WCcyNRF       IFNE      *BLANKS
     C                   MOVE      'N'           DDOccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDOCCY'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0400'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** Validate Original Currency and then, validate Original
      ** Currency and Amount combination.
      *
     C                   EXSR      SRVOCcy
      *
     C                   ELSE
      *
      *----------------------------------------------------------------
      ** Otherwise, generate error message if Original Currency
      ** or Amount is not blank.
      *----------------------------------------------------------------
      *
     C     DDOCCY        IFNE      *BLANKS
     C                   MOVE      'N'           DDOccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDOCCY'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0408'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C     DDOAMT        IFNE      *BLANKS
     C                   MOVE      'N'           DDOamtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDOAMT'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0398'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetOCcy - Validate Original Currency                       *
      *                                                               *
      *****************************************************************
      *
     C     SRGetOCcy     BEGSR
      *
     C     DDOCCY        IFNE      *BLANKS
      *
      ** Check if value entered is question mark.
      *
     C     '?'           SCAN      DDOCCY                                 01
      *
      ** Error if value entered is '?'.
      *
     C     *IN01         IFEQ      *ON
     C                   MOVEL     '*ERROR '     PRTCD
     C                   ELSE
      *
      ** Otherwise, access Currency file for details.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      DDOCCY        PCYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     A6NBDP        WNBDP
     C                   MOVEL     A6INCY        WINCY
     C                   ELSE
     C                   MOVE      'Y'           WCcyNRF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetOAmt - Get Original Amount details                      *
      *                                                               *
      *****************************************************************
      *
     C     SRGetOAmt     BEGSR
      *
     C     DDOAMT        IFNE      *BLANKS
      *
      ** Get number of decimal places.
      *
     C                   SELECT
     C     WNBDP         WHENEQ    *ZERO
     C                   Z-ADD     *ZERO         ZADEC
     C                   Z-ADD     15            ZADIG
     C     WNBDP         WHENEQ    1
     C                   Z-ADD     1             ZADEC
     C                   Z-ADD     14            ZADIG
     C     WNBDP         WHENEQ    2
     C                   Z-ADD     2             ZADEC
     C                   Z-ADD     13            ZADIG
     C     WNBDP         WHENEQ    3
     C                   Z-ADD     3             ZADEC
     C                   Z-ADD     12            ZADIG
     C                   ENDSL
      *
      ** Check if Amount is in valid format.
      *
     C                   MOVE(P)   DDOAMT        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOK          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C     ZalignOK      IFEQ      'Y'
     C                   MOVE      ZFIELD        WORAMT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVOCcy - Validate Original Currency                         *
      *                                                               *
      *****************************************************************
      *
     C     SRVOCcy       BEGSR
      *
      *----------------------------------------------------------------
      ** Error if Original Currency is blanks but Amount is entered.
      *----------------------------------------------------------------
      *
     C     DDOCCY        IFEQ      *BLANKS
     C     DDOAMT        ANDNE     *BLANKS
     C                   MOVE      'N'           DDOamtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDOCCY'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0402'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      *----------------------------------------------------------------
      ** Validate Original Currency if not blanks.
      *----------------------------------------------------------------
      *
     C     DDOCCY        IFNE      *BLANKS
      *
     C                   SELECT
      *
      ** Original Currency must not be same as Account Currency.
      *
     C     DDOCCY        WHENEQ    B2CYCD
     C                   MOVE      'N'           DDOamtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDOCCY'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0399'     MsgIdXAr(Idx)
      *
      ** Original Currency must be either 'EURO' or 'In' Currency.
      *
     C     DDOCCY        WHENNE    BKEURO
     C     WINCY         ANDNE     'Y'
     C                   MOVE      'N'           DDOccyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDOCCY'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0404'     MsgIdXAr(Idx)
      *
      ** Error if Original Amount is blanks but Currency is entered.
      *
     C     DDOAMT        WHENEQ    *BLANKS
     C                   MOVE      'N'           DDOamtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDOAMT'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0401'     MsgIdXAr(Idx)
      *
      ** Validate Original Currency and Amount combination.
      *
     C                   OTHER
     C                   EXSR      SRVCyAm
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCyAm - Validate Original Currency and Amount combination  *
      *                                                               *
      *****************************************************************
      *
     C     SRVCyAm       BEGSR
      *
      ** If Euro or In Currency and Amount entered, generate
      ** error if Amount not valid.
      *
     C     ZalignOK      IFNE      'Y'
     C     WORAMT        ORLE      *ZERO
     C                   MOVE      'N'           DDOamtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDOAMT'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0403'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      *----------------------------------------------------------------
      ** If no errors found, perform Currency Amount conversion.
      *----------------------------------------------------------------
      *
     C     DDOamtOK      IFEQ      'Y'
     C     DDOccyOK      ANDEQ     'Y'
      *
      ** If Posting Currency or Original Currency is Euro, call
      ** conversion program once.
      *
     C     B2CYCD        IFEQ      BKEURO
     C     DDOCCY        OREQ      BKEURO
     C                   Z-ADD     B2PTAM        WFRAM            18 3
     C                   MOVEL     B2CYCD        WFRCY             3
     C                   MOVEL     DDOCCY        WTOCY             3
     C                   EXSR      SREucvt
      *
     C                   ELSE
      *
      ** If Posting Currency and Original Currency are 'In' Currencies,
      ** then conversion program is called twice.
      ** The first call converts the Posting Amount to Euro Currency.
      ** The second call converts the Euro Currency amount to 'In'
      ** Currency Original Amount.
      *
     C                   Z-ADD     B2PTAM        WFRAM
     C                   MOVEL     B2CYCD        WFRCY
     C                   MOVEL     BKEURO        WTOCY
     C                   EXSR      SREUCVT
     C                   Z-ADD     WOUTA         WFRAM
     C                   MOVEL     BKEURO        WFRCY
     C                   MOVEL     DDOCCY        WTOCY
     C                   EXSR      SREucvt
     C                   ENDIF
      *
      ** Check if there is difference between the converted
      ** Amount and the entered Original Amount.
      *
     C                   Z-ADD     WOUTA         WOAMT            15 0
     C     WORAMT        SUB       WOAMT         WDIFF            15 0
      *
     C     WDIFF         IFGT      1
     C     WDIFF         ORLT      -1
     C                   MOVE(P)   WOAMT         ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      WNBDP         ZADEC             1 0
     C                   MOVE      'W'           DDOamtOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDOAMT'      WFldNmXAr(WIx)
     C                   MOVEL     'GLX0406'     WMsgIdXAr(WIx)
     C**********         MOVEL     ZFIELD        WMsgDtXAr(WIx)                      238620 MD000091
     C                   EVAL      BLen = %Len(%Trim(ZFIELD))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(ZFIELD)                   MD000091
     C**********         MOVE      ZFIELD        WMsgDtXAr(WIx)                               238620
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREucvt - Convert Euro to 'In' Currency and vice versa       *
      *                                                               *
      *****************************************************************
      *
     C     SREucvt       BEGSR
      *
     C                   Z-ADD     0             WOUTA            15 0
     C                   Z-ADD     0             WINTA            18 3
      *
     C                   CALL      'EU0200'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      WFRAM         PFRAM            18 3
     C                   PARM      WFRCY         PFRCY             3
     C                   PARM      WTOCY         PTOCY             3
     C     WOUTA         PARM      WOUTA         POUTA            15 0
     C     WINTA         PARM      WINTA         PINTA            18 3
     C                   PARM                    PEXRT            15 9
     C                   PARM                    PMDIN             1
      *
     C     PRTCD         IFEQ      '*ERROR*'
     C                   MOVE      'N'           DDOamtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDOAMT'      FldNamXAr(Idx)
     C                   MOVEL     'GLX0405'     MsgIdXAr(Idx)
     C**********         MOVEL     'EU0200'      MsgDtaXAr(Idx)                             MD000091
     C                   MOVEL     'EU0200'      MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ENDIF
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
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Original Currency
     C                   PARM                    DDOCCY            3
      *
      ** Original Amount
     C                   PARM                    DDOAMT           16
      *
      ** In Currency flag
     C                   PARM                    PINCY             1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO            3
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *                                                                                       238620
      ** Warning flds/message IDs/message data (arrays) from/to caller                        238620
     C                   PARM                    WFldNmXAr                                    238620
     C                   PARM                    WMsgIDXAr                                    238620
     C                   PARM                    WMsgDtXAr                                    238620
      *
      ** Original Currency - OK indicator
     C                   PARM                    DDOccyOK          1
      *
      ** Original Amount - OK indicator
     C                   PARM                    DDOamtOK          1
      *
      ** Valid JE Item (DS) - for file update
     C                   PARM                    PVBITP
      *
     C     *LIKE         DEFINE    A6NBDP        WNBDP
     C     *LIKE         DEFINE    A6INCY        WINCY
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
