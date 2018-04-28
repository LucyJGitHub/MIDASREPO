     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Message Type')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIMTP  - Validate Message Type                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG25340           Date 05Aug09               *
      *                 BUG25103           Date 23Jul09               *
      *                 CSW209  *CREATE    Date 01Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  BUG25340 - Incoming message type field should be blanks      *
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
     D NwIP2ScnFmt   E DS                  EXTNAME(FTIPY2PD)
     D NwIP7ScnFmt   E DS                  EXTNAME(FTIPY7PD)
 
      ** Valid Incoming Payments File
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
 
      * Flags to indicate whether transaction fields are valid
     D FTEIPY7       E DS                  EXTNAME(FTEIPY7PD)
 
      ** External data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Ordering Bank data structure
     D ORDBNK          DS           175
     D  WOBK1                  1     35
     D  WOBK2                 36     70
     D  WOBK3                 71    105
     D  WOBK4                106    140
     D  WOBK5                141    175
 
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
     D PMTPY           S              3A
 
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
     C                   EVAL      PMTPY = *BLANKS                                          BUG25340
 
      ** Validate
     C                   Exsr      VIMTP
 
      ** If an error was found, set the return code appropriately
      *
     C                   IF        OKMTPY = 'N'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   ELSE
     C                   EVAL      IPINMTPY = PMTPY
     C                   ENDIF
 
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VIMTP - Validate Message Type
      *****************************************************************
      *
     C     VIMTP         BEGSR
      *
     C                   MOVEL     DDOBK1        WOBK1
     C                   MOVEL     DDOBK2        WOBK2
     C                   MOVEL     DDOBK3        WOBK3
     C                   MOVEL     DDOBK4        WOBK4
     C                   MOVEL     DDOBK5        WOBK5
      *
     C                   IF        DDMTPY <> *BLANKS
     C                   CALL      'AOMTPYR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C     DDMTPY        PARM      DDMTPY        PMTPY
     C                   PARM      *BLANKS       DSFDY
      *
      ** Invalid Message Type
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      OKMTPY = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDMTPY'      FldNamXAr(Idx)
     C                   MOVEL     DDMTPY        MsgDtaXAr(IDX)
     C                   MOVEL     'ME00139'     MsgIDXAr(Idx)
      *
      ** Ordering Bank is mandatory for SWIFT 205
      *
     C                   ELSEIF    DDNWRK = 'SWIFT' AND
     C                             DDMTPY = '205'   AND
     C                             ORDBNK = *BLANKS
     C                   EVAL      OKMTPY = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDMTPY'      FldNamXAr(Idx)
     C                   MOVEL     DDMTPY        MsgDtaXAr(IDX)
     C                   MOVEL     'ME00169'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ELSE                                                               BUG25103
     C                   EVAL      PMTPY = *BLANKS                                          BUG25103
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
      ** Incoming Payments details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP2ScnFmt
     C                   PARM                    NwIP7ScnFmt
 
      * OUTPUTS
      ** Incoming Payments (additional details) for file update
     C                   PARM                    NwIPFilFmt
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
