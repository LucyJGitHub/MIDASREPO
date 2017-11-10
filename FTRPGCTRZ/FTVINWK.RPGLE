     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Network')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVINWK  - Validate Network                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CFT162             Date 08Sep17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG25103           Date 23Jul09               *
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  BUG25103 - INVALID values for Network and Message Type field *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *                                                               *
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

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

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

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)

      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

      ** Array of Warning in error.
     D WFldNmXAr       S             10A   DIM(XArrayMax)

      ** Array of Warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of Warning message data.
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)

      * Incoming Transaction
     D NwIP7ScnFmt   E DS                  EXTNAME(FTIPY7PD)

      ** Valid Outgoing Payments Extension File (default)
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)

      * Flags to indicate whether transaction fields are valid
     D FTEIPY7       E DS                  EXTNAME(FTEIPY7PD)

      ** External data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIX             S              3P 0

     D PRTCD           S              7A
     D POPTN           S              7A
     D PNWRK           S              6A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *
      ** Initialization
      *
     C                   Eval      RetCodeIn  = *BLANKS
     C                   Eval      FldNamXAr  = *BLANKS
     C                   Eval      MsgIDXAr   = *BLANKS
     C                   Eval      MsgDtaXAr  = *BLANKS
     C                   EVAL      WFldNmXAr  = *BLANKS
     C                   EVAL      WMsgIDXAr  = *BLANKS
     C                   EVAL      WMsgDtaXAr = *BLANKS
     C                   EVAL      WIX = 0
     C                   Eval      Idx = 0

      ** Validate
     C                   Exsr      VINWK

      ** If an error was found, set the return code appropriately
      *
     C                   IF        OKNWRK = 'N'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   ELSE
     C                   EVAL      I2NWRK = PNWRK
     C                   ENDIF

      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VINWK - Validate Network
      *****************************************************************
      *
     C     VINWK         BEGSR
      *
     C                   IF        DDNWRK <> *BLANKS
     C                   CALL      'AONWRKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C     DDNWRK        PARM      DDNWRK        PNWRK
     C                   PARM      *BLANKS       DSFDY
      *
      ** Invalid Network
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      OKNWRK = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDNWRK'      FldNamXAr(Idx)
     C                   MOVEL     DDNWRK        MsgDtaXAr(IDX)
     C                   MOVEL     'ME00138'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ELSE                                                               BUG25103
     C                   EVAL      PNWRK = *BLANKS                                          BUG25103
     C                   ENDIF

     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
     C*
     C     *ENTRY        PLIST

      * INPUTS
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Incoming Payments Lvl 2 Scrn 7 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP7ScnFmt

      * OUTPUTS
      ** Incoming Payments (additional details) for file update
     C                   PARM                    NwIP2FilFmt
      *
      ** Incoming Payments Lvl 2 Scrn 7 error indicators
     C                   Parm                    FTEIPY7
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtaXAr
      *
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2009
