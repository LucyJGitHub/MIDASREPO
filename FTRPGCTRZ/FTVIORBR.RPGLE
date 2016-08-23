     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP originating branch')              *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIORBR - Validate Originating Branch                       *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD000091           Date 07May13               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 240689             Date 13Jul06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  240689 - Parameters missings.  Applied fix 210654.          *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT. (Recompiled)            *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
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
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      ** Incoming Payments Lvl 1 Scrn 1/2 details from Incoming trans.                        240689
     D NwIP1aScnFmt  E DS                  EXTNAME(FTIPY1APD)                                 240689
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     D FTEIPY1       E DS                  EXTNAME(FTEIPY1PD)
      *
      ** Externally described DS for Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
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
      ** Initialise work variable.
      *
     C                   EVAL      Idx = 0
      *
      ** Validate Originating Branch.
      *
     C                   EXSR      SRValOrBr
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File field.
      *
     C                   IF        OKORBR = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   IF        OKORBR <> 'N'
     C                   MOVE      DDORBR        IPORBR
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALORBR - Originating Branch Validation                    *
      *                                                               *
      *****************************************************************
      *
     C     SRValOrBr     BEGSR
      *
      ** If no entry has been made to Originating Branch, use
      ** Booking Branch.
      *
     C                   IF        DDORBR = *BLANKS and
     C                             OKBRCA <> 'N'
     C                   MOVE      DDBRCA        DDORBR
     C                   ENDIF
      *
      ** Check for question mark.
      *
     C     '?'           SCAN      DDORBR                                 01
      *
      ** Question mark is invalid on *CTL function.
      *
     C                   IF        PMODE = '*FRONT' and
     C                             *IN01 = *On
     C                   MOVE      'N'           OKORBR
     C                   ADD       1             Idx
     C                   MOVEL     'DDORBR'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0082'     MsgIdXAr(Idx)
     C                   GOTO      EValOrBr
     C                   ENDIF
      *
      ** Check if Originating Branch is existing.
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtCd             7
     C                   PARM      '*KEY   '     POptn             7
     C                   PARM      DDORBR        PBrCd             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
     C                   IF        PRtCd <> *Blanks
      *
      ** Default Originating Branch to Booking Branch if entry
      ** is question mark and no selection has been made.
      *
     C                   IF        *IN01 = *On and
     C                             OKBRCA <> 'N'
     C                   MOVE      DDBRCA        DDORBR
     C                   ELSE
     C                   MOVE      'N'           OKORBR
     C                   ADD       1             Idx
     C                   MOVEL     'DDORBR'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0085'     MsgIdXAr(Idx)
     C**********         MOVEL     DDORBR        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDORBR))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDORBR)                   MD000091
     C                   GOTO      EValOrBr
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   EVAL      DDORBR = A8BRCD
      *
     C                   ENDIF
      *
      ** Error if entry is still blank up to this point.
      *
     C                   IF        DDORBR = *BLANKS
     C                   MOVE      'N'           OKORBR
     C                   ADD       1             Idx
     C                   MOVEL     'DDORBR'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0082'     MsgIdXAr(Idx)
     C                   GOTO      EValOrBr
     C                   ENDIF
      *
      ** If Originating Branch User Validation required,
      ** check user has authority to Originating Branch.
      *
     C                   IF        BKOBUV = 'Y' and
     C                             PResponse = 'S'
      *
     C                   CALL      'ZVOBU'
     C                   PARM      DDORBR        ZOBRX             3
     C                   PARM                    ERR               1 0
      *
      ** User is not authorised to any Originating branches.
      *
     C                   IF        ERR = 1
     C                   MOVE      'N'           OKORBR
     C                   ADD       1             Idx
     C                   MOVEL     'DDORBR'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0083'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** User is not authorised to this particular Originating
      ** Branch.
      *
     C                   IF        ERR = 2
     C                   MOVE      'N'           OKORBR
     C                   ADD       1             Idx
     C                   MOVEL     'DDORBR'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0084'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EValOrBr      ENDSR
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
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *                                                                                       240689
      ** Incoming Payments Lvl 1 Scrn file 2 details from                                     240689
      ** Incoming transactions - screen format                                                240689
     C                   PARM                    NwIP1AScnFmt                                 240689
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode             6
      *
      ** Response Mode
     C                   PARM                    PResponse         1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDGELR - Originating Branch/User Vald Req.
     C                   PARM                    BKOBUV            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                              240689
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtXAr                                    240689
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
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
(c) Misys International Banking Systems Ltd. 2001
