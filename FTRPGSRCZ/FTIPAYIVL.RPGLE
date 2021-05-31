     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments Initial validation ctrl')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAYIVL - Incoming Payments Initial Validation             *
      *              Controller                                       *
      *                                                               *
      *  Function: This module validates Incoming Payments initial    *
      *            screen fields (Booking Branch, SWIFT Reference     *
      *            and Sequence Number) for input into the Midas      *
      *            database.                                          *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. AR1088819          Date 03Jun20               *
      *  Prev Amend No. MD039094           Date 01Jul16               *
      *                 MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 247277             Date 24May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 BUG8170            Date 26Sep05               *
      *                 CAP084             Date 25Aug03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1088819 - Issue on job names during SSL enabling of JDBC   *
      *              calls                                            *
      *            - Applied for MD050405                             *
      *  MD039094 - Adjust CFT157 to work with Rabo MHUB              *
      *           - Recompile due to changes in INPAYDD               *
      *           - Applied fix for MD050928                          *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  247277 - Allow for native JDBC driver as well as toolbox.    *
      *  CFT032 - Account line in field 50k in MT103 (recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  BUG8170 - Validation of Fields in FT Incoming Payments       *
      *            Fields Intermediary Bank, SWIFT Reference and      *
      *            SWIFT sequence number should be validated          *
      *            accordingly. Also SWIFT Priority code should       *
      *            appear after Sequence Number field.                *
      *  CAP084 - Thin Client API Wrappers                            *
      *           Do not set SWIFT Reference/Sequence to blanks       *
      *           if called from Midas Plus interface.                *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
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
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,FTIPYIV001
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
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
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments retrieved from file - file format
     D CrIPFilFmt    E DS                  EXTNAME(INPAYDD)
      *
      ** Incoming Payments extra data
     D PExtData      E DS                  EXTNAME(FTIPEXPD)
     D/COPY WNCPYSRC,FTH00364
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
      *
      ** Index for update of error arrays
     D Ix              S              3  0
      *
      ** Response Mode
     D PResponse       S              1A
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,FTIPYIV002
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
      /COPY WNCPYSRC,FTIPYIV003
      *
      ** Perform Booking Branch validation if multibranching.
      *
      /COPY WNCPYSRC,FTIPYIV004
      *
     C                   IF        BGMBIN = 'Y'
      *
     C                   EXSR      SRBkBr
      *
      ** Otherwise, set Booking Branch to Single Branch Code.
      *
     C                   ELSE
      *
     C                   EVAL      DDBRCA = *BLANKS
     C                   EVAL      IPBRCA = BJSBRC
      *
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPYIV005
      *
      ** Perform SWIFT Reference and Sequence No. validation
      ** if module was called from *SIN function.
      *
      /COPY WNCPYSRC,FTIPYIV006
      *
     C                   IF        PMode = '*SIN  '
     C                             or Pmode = '*FRONT'                                       BUG8170
     C                   EXSR      SRSwtR
     C                   ELSE
     C                   IF        PSJobName <> 'QZDASOINIT'                                  CAP084
     C                             AND PSJobName <> 'QSQSRVR'                                 247277
     C                             AND PSJobName <> 'QZDASSINIT'                           AR1088819
     C                   EVAL      DDSWTN = *BLANKS
     C                   EVAL      DDSEQNO = *BLANKS
     C                   ENDIF                                                                CAP084
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPYIV007
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,FTIPYIV008
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBKBR - Booking Branch Validation                           *
      *                                                               *
      *****************************************************************
      *
     C     SRBkBr        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C/COPY WNCPYSRC,FTH00365
     C                   CALLB     'FTVIBRCA'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Booking Branch
     C                   PARM                    DDBRCA
      *
      ** SWIFT Reference
     C                   PARM                    DDSWTN
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
      *
      ** Response Mode
     C                   PARM                    PResponse         1
      *
      ** Linked Program
     C                   PARM                    WLinkPgm
      *
      ** Incoming Payments retrieved from file - file format
     C                   PARM                    CrIPFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** OK Action Code
     C                   PARM                    OKACTN
      *
      ** OK Payment Reference
     C                   PARM                    OKPREF
      *
      ** OK Booking Branch
     C                   PARM                    OKBRCA
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
     C/COPY WNCPYSRC,FTH00366
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSWTR - SWIFT Reference and Sequence No. Validation         *
      *                                                               *
      *****************************************************************
      *
     C     SRSwtR        BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'FTVISWSQ'
      *                             ========
      ** INPUT
      *  =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** SWIFT Reference
     C                   PARM                    DDSWTN
      *
      ** Sequence Number
     C                   PARM                    DDSEQNO
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** OK SWIFT Reference
     C                   PARM                    OKSWTN
      *
      ** OK Sequence No.
     C                   PARM                    OKSEQNO
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
     C
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRESETERRS - Routine to reset Error Information that is     *
      *                received from each validation module           *
      *                                                               *
      *****************************************************************
      *
     C     SRResetErrs   BEGSR
      *
     C                   EVAL      RetCodeOut = *Blanks
      *
      ** Reset error and warning fields/message IDs/message
      ** data (arrays).
      *
     C                   EVAL      FldNamXAr = *BlankS
     C                   EVAL      MsgIDXAr  = *BlankS
     C                   EVAL      MsgDtaXAr = *BlankS
      *
     C                   EVAL      WFldNmXAr = *BlankS
     C                   EVAL      WMsgIDXAr = *BlankS
     C                   EVAL      WMsgDtXAr = *BlankS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDATERRS - Routine to update Error Information with that  *
      *                received back from each validation module      *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdatErrs   BEGSR
      *
      ** Update error fields/message IDs/message data (arrays).
      *
     C                   EVAL      Ix = 1
     C     *Blank        LOOKUP    FldNameArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     FldNamXar     FldNameArr(Ix)
     C                   MOVEA     MsgIDXAr      MsgIdArr(Ix)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set Error Index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FLDNAMEARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             IDX
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       FLDNAMEARR(Ix)
     C                   MOVE      *BLANKS       MSGIDARR(Ix)
     C                   MOVE      *BLANKS       MSGDTAARR(Ix)
     C                   Eval      IDX = ArrayMax - 1
     C                   ENDIF
      *
      ** Update warning fields/message IDs/message data (arrays).
      *
     C                   EVAL      Ix = 1
     C     *Blank        LOOKUP    WFldNamArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     WFldNmXAr     WFldNamArr(Ix)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(Ix)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set Warning Index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    WFLDNAMARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             WIDX
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       WFLDNAMARR(Ix)
     C                   MOVE      *BLANKS       WMSGIDARR(Ix)
     C                   MOVE      *BLANKS       WMSGDTAARR(Ix)
     C                   Eval      WIDX = ArrayMax - 1
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
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode             6
      *
      ** Response Mode
     C                   PARM                    PResponse
      *
      ** SWIFT Reference
     C                   PARM                    DDSWTN           28
      *
      ** Sequence Number
     C                   PARM                    DDSEQNO           2
      *
      ** Booking Branch
     C                   PARM                    DDBRCA            3
      *
      ** Action Code
     C                   PARM                    DDACTN            1
      *
      ** OK Payment Reference
     C                   PARM                    OKPREF            1
      *
      ** Linked Program
     C                   PARM                    WLinkPgm         10
      *
      ** Incoming Payments retrieved from file - file format
     C                   PARM                    CrIPFilFmt
      *
      ** Incoming Payments extra data
     C                   PARM                    PExtData
     C/COPY WNCPYSRC,FTH00367
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC            3
      *
      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN            1
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN             3
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** OK Action Code
     C                   PARM                    OKACTN            1
      *
      ** OK SWIFT Reference
     C                   PARM                    OKSWTN            1
      *
      ** OK Sequence No.
     C                   PARM                    OKSEQNO           1
      *
      ** OK Booking Branch
     C                   PARM                    OKBRCA            1
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
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,FTIPYIV009
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
