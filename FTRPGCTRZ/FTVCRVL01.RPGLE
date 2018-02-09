     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Credit Value Date')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVCRVL01  - Validate Credit Value Date                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 221761             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 01Nov99               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CFT006 - Funds Transfer addition of MT101 messages           *
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
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
     D  PSNDREF_H    E                     EXTFLD(PSNDREF)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT101DSPD)
 
      ** External data structure for Bank details ICD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * OK Flags for second screen
     D OKFlags       E DS                  EXTNAME(FTE101S2PD)
 
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
     D DayNoOut        S              5P 0
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
 
     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      Idx        = 0
     C                   Eval      WIx        = 0
     C                   Eval      OKCDDT     = 'Y'
 
      ** Validate (N.B. this field cannot be entered for proc. type 'RO')
     C                   IF        PPTYP = 'RI'
     C                   EXSR      Validate
     C                   ENDIF
 
     C                   Return
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
     C     Validate      BEGSR
      *
      ** If entered, Credit Value Date must be a valid date and be greater
      ** than or equal to today's date (the rundate).
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
     C                   EVAL      OkCddt = 'N'
 
     C                   ELSE
     C                   MOVE      PCRDVDT       DateIn
     C                   MOVE      *Zeros        DayNoOut
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM                    DayNoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
      *
     C                   IF        ErrorFlag = 'Y'
     C                   MOVE      'N'           OKCDDT
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0164'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   IF        DayNoOut < BJRDNB
     C                   MOVE      'N'           OKCDDT
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0165'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** If not entered, Credit Value Date defaults to debit value date plus
      ** one working day if the RFT is in base currency or to debit value
      ** date plus two working days if not in base currency.
     C                   ELSE
      *
      ** Only do this if Transfer Currency is valid and entered.
     C                   IF        PTRNCCY <> *Blanks  AND  OKTRCY = 'Y'
      *
      ** Convert debit value date to Midas day format.
     C                   CALLB     'ZDATE1'
     C                   PARM      PDBTVDT       DateIn
     C                   PARM      *Zeros        DayNoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
      *
      ** Database error
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      DBFile = 'FT101HPD'
     C                   EVAL      DBKey = PDBTVDT
     C                   EVAL      DBPgm = 'FTV101HSIN'
     C                   EVAL      DBase = 2
     C                   EVAL      DBMod = 'FTVCRVL01'
     C                   EVAL      DBProc = 'Validate'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PTRNCCY = BJCYCD
     C                   EVAL      DaysFwd = 1
     C                   ELSE
     C                   EVAL      DaysFwd = 2
     C                   ENDIF
      *
      ** Calculate the appropriate no of working days forward
     C                   CALLB     'ZFWDT'
     C                   PARM      DayNoOut      InputDay
     C                   PARM                    DaysFwd
     C                   PARM                    OutputDay
     C                   PARM      BJCYCD        Currency
     C                   PARM                    Location
      *
      ** Convert the default Credit Value Date to screen format
     C                   CALLB     'ZDATE2'
     C                   PARM      OutPutDay     DayNoIn
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
      *
      ** Load screen field
     C                   MOVE      ZDATE         PCRDVDT
      *
     C                   ENDIF
      *
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      * INPUTS
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode
     C                   Parm                    ActionCode
 
      *  Screen fields
     C                   Parm                    HdrRcdIn
     C                   PARM                    DtlRcdIn
 
      * OUTPUTS
 
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName
     C                   PARM                    OKFlags
 
      * Access bank details
     C                   CallB     'AOBANKR0'
     C                   PARM                    @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBPgm = 'FTV101HSIN'
     C                   EVAL      DBase = 1
     C                   EVAL      DBMod = 'FTVCRVL01'
     C                   EVAL      DBProc = '*INZSR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
