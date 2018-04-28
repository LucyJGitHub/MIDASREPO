     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Credit Value Date-Detail')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVCRVL02  - Validate Credit Value Date                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT008  *CREATE    Date 25Nov99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT008 - Funds Transfer addition of MT102 messages           *
      *                                                               *
      *****************************************************************
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)
 
      ** External data structure for Bank details ICD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * OK Flags for second screen
     D OKFlagDs2     E DS                  EXTNAME(FTE102S2PD)
 
      * OK Flags for First screen
     D OKFlagDs1     E DS                  EXTNAME(FTE102S1PD)
 
      * OK Flags for second screen - Header
     D OKFlagHs2     E DS                  EXTNAME(FTE102H2PD)
 
      * OK Flags for First screen - Header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
      ** DayNoOut Exported for Credit value day Number for other modules
     D DayNoOUt        S              5  0 Export
 
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
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
     D DateIn          S              6A
     D*DayNoOut*****   S              5  0
     D ErrorFlag       S              1A
 
     D InputDay        S              5  0
     D DaysFwd         S              2  0
     D OutputDay       S              5  0
     D Currency        S              3
     D Location        S              3
 
     D DayNoIn         S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7
 
     D RespMode        S              1
     D DDSName         S             10
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      ** Initialise fileds
      *
     C                   EVAL      RetCodeIn  = *Blanks
     C                   EVAL      Idx        = 0
     C                   EVAL      WIx        = 0
     C                   EVAL      OKCVDT     = 'Y'
      *
      ** Validate (N.B. this field cannot be entered for proc. type 'BO')
      *
     C                   IF        HPccttyp = 'BO'
     C                   IF        PCrdvdt <> *Blanks
     C                   MOVE      'N'           OKCVDT
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0305'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ELSE
     C                   EXSR      Validate
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Validate - Validate field                                     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: ZDATE1, ZFWDT, ZDATE2                                  *
      *                                                               *
      *****************************************************************
      *
     C     Validate      BEGSR
      *
      ** If entered, Credit Value Date must be a valid date and be greater
      ** than or equal to today's date (the rundate).
      *
      ** ENSURE THAT DAY ENTERED IS A WORKING DAY
      *
     C                   IF        PCRDVDT <> *Blanks
      *
      ** Ensure first of all that 6 digits have been entered
      *
     C                   MOVEL     PCRDVDT       DATEL             7 0
     C                   MOVEL     DATEL         Dates             6
      *
     C                   IF        PCRDVDT <> Dates
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0164'
     C                   EVAL      FldNamXAr(Idx) =   PCrdvDt
     C                   EVAL      OkCvdt = 'N'
 
     C                   ELSE
     C                   MOVE      PCRDVDT       DateIn
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM      *Zeros        DayNoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
      *
     C                   IF        ErrorFlag = 'Y'
     C                   MOVE      'N'           OKCVDT
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0164'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   IF        DayNoOut < BJRDNB
     C                   MOVE      'N'           OKCVDT
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0165'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If not entered, Credit Value Date defaults to debit value date plus
      ** one working day if the CCT is in base currency or to debit value
      ** date plus two working days if not in base currency.
      *
     C                   ELSE
      *
      ** Only do this if Transfer Currency is valid and entered.
      *
     C                   IF        PCCTCCY <> *Blanks  AND  OKTCCY = 'Y'
      *
      ** Convert total transfer value date to Midas day format.
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      HPTTVDTE      DateIn
     C                   PARM      *Zeros        DayNoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
      *
      ** Database error
      *
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      DBFile = 'FT102HPD'
     C                   EVAL      DBKey = HPTTVDTE
     C                   EVAL      DBPgm = 'FTV102HSIN'
     C                   EVAL      DBase = 2
     C                   EVAL      DBMod = 'FTVCRVL02'
     C                   EVAL      DBProc = 'Validate'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PCCTCCY = BJCYCD
     C                   EVAL      DaysFwd = 1
     C                   ELSE
     C                   EVAL      DaysFwd = 2
     C                   ENDIF
      *
      ** Calculate the appropriate no of working days forward
      *
     C                   CALLB     'ZFWDT'
     C                   PARM      DayNoOut      InputDay
     C                   PARM                    DaysFwd
     C                   PARM      *Zeros        OutputDay
     C                   PARM      BJCYCD        Currency
     C                   PARM                    Location
      *
      ** Convert the default Credit Value Date to screen format
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      OutPutDay     DayNoIn
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
      *
      ** Load screen field
      *
     C                   MOVE      ZDATE         PCRDVDT
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *Entry        PLIST
      *
      ** INPUTS
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode
     C                   PARM                    ActionCode
      *
      ** Screen fields
      *
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
      *
      ** OUTPUTS
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName
     C                   PARM                    OKFlagDs1
     C                   PARM                    OKFlagDs2
     C                   PARM                    OKFlagHs1
     C                   PARM                    OKFlagHs2
      *
      ** Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM                    @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBPgm = 'FTV102HSIN'
     C                   EVAL      DBase = 1
     C                   EVAL      DBMod = 'FTVCRVL02'
     C                   EVAL      DBProc = '*INZSR'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR                                                  *** InzEnd ***
      *
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
