     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
 
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Debit Value Date')
 
      *  Midas - Standard subprograms                                 *
 
      *  FTVDBVL01  - Validate Debit Value Date
 
      *  (c) Finastra International Limited 2001                      *
 
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
 
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
 
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
      *                 CFT006  *CREATE    Date 15Jul99               *
      *  Prev Amend No.                    Date ddmmmyy               *
 
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
 
     D GenOkFlag       S              1    Import
 
     D ErrorInd        S              1
 
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
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
     D WIdx            S              3P 0
 
     D DAyNum          S              5  0
     D Err_Out         S              1
     D ZDATE           S              6  0
     D Filler          S              7
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
 
      * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
     C                   EVAL      RetCodeIn  = *BlankS
     C                   EVAL      Idx        = 0
     C                   EVAL      WIdx        = 0
 
     C                   EVAL      GenOkFlag = 'Y'
     C                   EVAL      ErrorInd = 'N'
 
      * Can only be entered where transfer type = 'RI'
 
     C                   IF        PPTYP = 'RO'       and
     C                             PDBTVDT <> *Blanks
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0010'
     C                   EVAL      FldNamXAr(Idx) =   DDSName
     C                   EVAL      GenOkFlag = 'N'
     C                   RETURN
     C                   ENDIF
 
      * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
     C                   IF        PPTYP = 'RI'
 
      * Default to larger of the requested execution date or todays run date
 
      * Get todays run date
 
     C                   CALLB     'AOBANKR0'
     C                   PARM                    @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C                   PARM      '*Blanks'     SDBANK
 
     C     @RTCD         IFNE      *Blanks
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = '*VERIFY'
     C                   EVAL      DBPgm = 'FTV101HVAL'
     C                   EVAL      Dbase = 1
     C                   EVAL      DBMod = 'FTVDBTVDTE'
     C                   EVAL      DBProc = 'Main'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *
      ** If the date is entered then must be greater then the current
      ** processing date
      *
     C                   IF        Pdbtvdt <> *Blanks
      *
      ** Ensure first of all that 6 digits have been entered
      *
     C                   MOVEL     PDbtvdt       Datel             7 0
     C                   MOVEL     Datel         Dates             6
      *
     C                   IF        PDbtvdt <> Dates
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0332'
     C                   EVAL      FldNamXAr(Idx) =   DDSName
     C                   EVAL      GenOkFlag = 'N'
 
     C                   ELSE
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDbtvDt
     C                   PARM      *Zeros        DayNum            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    Err_Out           1
 
     C                   IF        Err_Out <> 'N'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0332'
     C                   EVAL      FldNamXAr(Idx) =   DDSName
     C                   EVAL      GenOkFlag = 'N'
 
     C                   ELSE
 
     C                   IF        DayNum < BJrdnb
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0197'
     C                   EVAL      FldNamXAr(Idx) =   DDSName
     C                   EVAL      GenOkFlag = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If the date is blank then default it to whichever is the later of
      ** the two dates (current processing or requested execution)
      *
     C                   ELSE
      *
     C                   IF        PExDate <> *Blanks
      *
      ** Ensure first of all that 6 digits have been entered
      *
     C                   MOVEL     PExDate       DATEL             7 0
     C                   MOVEL     DATEL         Dates             6
     C                   IF        PExDate <> Dates
     C                   EVAL      ErrorInd = 'Y'
     C                   ELSE
     C                   MOVE      PEXDate       ZDate
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PExDate
     C                   PARM      *Zeros        DayNum            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    Err_Out           1
 
     C                   IF        Err_Out <> 'N'
     C                   EVAL      ErrorInd = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Check to see which is the later of the two dates
      *
     C                   IF        ErrorInd <> 'Y'
     C                   IF        DayNum < BJRdNb
     C                   CALLB     'ZDATE2'                             H1
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C                   PARM                    ZDate
     C                   PARM                    Filler
 
     C     *InH1         IFEQ      *On
     C                   EVAL      DBFile = 'ZDATE2'
     C                   EVAL      DBKey = 'Call'
     C                   EVAL      DBPgm = 'FTV101HVAL'
     C                   EVAL      Dbase = 2
     C                   EVAL      DBMod = 'FTVDBTVDTE'
     C                   EVAL      DBProc = 'Main'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     ZDate         PDbtvdt
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   CALLB     'ZDATE2'                             H1
     C                   PARM                    DayNum
     C                   PARM                    BJDFIN
     C                   PARM                    ZDate
     C                   PARM                    Filler
 
     C     *InH1         IFEQ      *On
     C                   EVAL      DBFile = 'ZDATE2'
     C                   EVAL      DBKey = 'Call'
     C                   EVAL      DBPgm = 'FTV101HVAL'
     C                   EVAL      Dbase = 2
     C                   EVAL      DBMod = 'FTVDBTVDTE'
     C                   EVAL      DBProc = 'Main'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     ZDate         PDbtvdt
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
 
      * If execution date < todays run date, convert and
      * Reformat run date to be dd/mm/yy
     C                   ENDIF
 
     C                   Return
      *****************************************************************
      /EJECT
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
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode
     C                   PARM                    ActionCode
 
      *  Screen fields
     C                   PARM                    HdrRcdIn
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName
 
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
