     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP profit centre')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIPRFC - Validate Profit Centre                            *
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
      *  Last Amend No. MD000091           Date 06May13               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 06Jul06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD009             Date 10Oct00               *
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
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CSD009 - Profit Centre Accounting Default Matrix Enhancement *
      *           Re-compiled due to changes in module AOPRFMR0.      *
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
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     D FTEIPY1       E DS                  EXTNAME(FTEIPY1PD)
      *
      ** External DS for Profit Centres
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      *
      ** DS for access programs - Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
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
      ** Initialise output parameters.
      *
      ** Initialise work variables.
      *
     C                   EVAL      Idx = 0
      *
      ** Validate Profit Centre if used
      *
     C                   EXSR      SRValPrfC
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKPRFC = 'N'
      *
     C                   EVAL      RetCodeIn = 'ERROR'
      *
     C                   ENDIF
      *
     C                   IF        OKPRFC <> 'N'
     C                   MOVE      DDPRFC        IPPRFC
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALPRFC - Profit Centre Validation                         *
      *                                                               *
      *****************************************************************
     C     SRValPrfC     BEGSR
      *
      ** Question mark is valid only on repair and i/c screens input.
      *
     C                   IF        PMODE = '*FRONT'
     C     '?'           SCAN      DDPRFC                                 01
     C                   If        *IN01 = *On
     C                   MOVE      'N'           OKPRFC
     C                   ADD       1             IDx
     C                   MOVEL     'DDPRFC'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0122'     MsgIdXAr(IDx)
     C**********         MOVEL     DDPRFC        MsgDtaXAr(IDx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDPRFC))                               MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(DDPRFC)                   MD000091
     C                   goto      ESRValPrfC
     C                   EndIf
     C                   ENDIF
      *
      ** Profit Centre is Optional input.
      *
      ** If the profit centre field is blank set to a default only if
      ** the Profit Centre Defaults Used flag is set to 'Y'.
      ** This could only happen on an Insert.
      *
     C                   IF        DDACTN = 'I' and
     C                             DDPRFC = *Blanks and
     C                             BKPCDU = 'Y'
      *
      ** Determine parameters to be passed
      *
      ** For Outgoing Payments the Customer and Account Officer will
      ** be blank.
      *
      *
     C                   MOVEL     *Blanks       CUST              6
     C                   MOVEL     *Blanks       ACOF              2
     C                   MOVEL     IPPYTP        TRTP              5
      *
      ** Get default profit centre
      *
     C                   CALLB     'AOPRFMR0'                           90
     C                   PARM      *Blanks       PRTCD             7
     C                   PARM      DDBOKC        PBOKC             2
     C                   PARM      TRTP          PTRTP             5
     C                   PARM      DDPYST        PSUTP             2
     C                   PARM      DDBRCA        PBRAN             3
     C                   PARM      DPPT          PDEPT             3
     C                   PARM      USRID         PUSER            10
     C                   PARM      ACOF          PACOF             2
     C                   PARM      CUST          PCUST             6
     C     DDPRFC        PARM      *Blanks       PPRFC             4
      *
      ** If error on CALL - process as database error
      *
     C                   IF        *In90 = *On
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If return code is not blank - process for an error
      ** If no error then the screen field is filled by passed parameter
      *
     C                   IF        PRTCD = '2'
      *
      ** If entered, the entry must be a valid profit centre
      ** code
     C                   MOVE      'N'           OKPRFC
     C                   ADD       1             Idx
     C                   MOVEL     'DDPRFC'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0039'     MsgIdXAr(Idx)
     C                   GOTO      ESRValPrfC
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Profit Centre
      *
     C                   IF        DDACTN = 'I' and
     C                             DDPRFC <> *Blanks or
     C                             DDACTN = 'A' and
     C                             DDPRFC <> *Blanks or
     C                             DDACTN = 'I' and
     C                             BGN0ST = 'Y' or
     C                             DDACTN = 'A' and
     C                             BGN0ST = 'Y'
      *
     C                   CALLB     'AOPRFCR0'                           90
     C                   PARM      *Blanks       P#RTCD            7
     C                   PARM      '*KEY'        P#OPTN            7
     C                   PARM      DDPRFC        P#PRFC            4
     C     SDPRFC        PARM      SDPRFC        DSFDY
      *
      ** If error on CALL - process as database error
      *
     C                   IF        *IN90 = *On
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If return code is not blank - process for an error
      *
     C                   IF        P#RTCD <> *Blanks
      *
     C                   MOVE      *BLANKS       DDPRFC
      *
      ** If entered, the entry must be a valid profit centre
      ** code
     C                   MOVE      'N'           OKPRFC
     C                   ADD       1             Idx
     C                   MOVEL     'DDPRFC'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0039'     MsgIdXAr(Idx)
      *
     C                   ELSE
      *
     C                   MOVEL     DSPCCD        DDPRFC
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ESRValPrfC    ENDSR
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
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMode             6
      *
      ** STANDING DATA
      ** =============
      *
      ** SDGELR - Profit Centre Def'ts Used
     C                   PARM                    BKPCDU            1
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST            1
      *
      ** ZMUSER - Department Code
     C                   PARM                    DPPT              3
      *
      ** ZMUSER - User ID
     C                   PARM                    USRID            10
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
     C/COPY WNCPYSRC,FTH00380
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
