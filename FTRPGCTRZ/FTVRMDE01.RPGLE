     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Remittance Information-Detail')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVRMDE01 - Validate Remittance Information                  *
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
      *                 CSW208             Date 15Apr08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CAP084             Date 16Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT008  *CREATE    Date 03Dec99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT008 - Funds Transfer/Swift Messages MT102                 *
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
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
 
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H)
 
      * Detail record datastructure
     D DTlRcdIn      E DS                  EXTNAME(FT102DSPD)
 
     D OKFlagHS1     E DS                  EXTNAME(FTE102H1PD)
 
     D OKFlagHs2     E DS                  EXTNAME(FTE102H2PD)
 
     D OKFlagDS1     E DS                  EXTNAME(FTE102S1PD)
 
     D OKFlagDs2     E DS                  EXTNAME(FTE102S2PD)
 
      ** Midas Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
     D Ccy             S              3
 
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
      ** Initialise fields
      *
     C                   EVAL      RetCodeIn  = *Blanks
     C                   EVAL      Idx        = 0
     C                   EVAL      WIx        = 0
      *
      ** Initialise detail screen flags
      *
     C                   EVAL      OkRi1 = 'Y'
     C                   EVAL      OkRi2 = 'Y'
     C                   EVAL      OkRi3 = 'Y'
     C                   EVAL      OkRi4 = 'Y'
      *
      ** Validate field
      *
     C                   EXSR      VALIDATE
 
      * Now validate that all data entered is OK for SWIFT
 
     C                   If        PRemI1  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PRemI1        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C                   Eval      FldNamXAr(Idx) =  DDSName
     C                   EVAL      OkRi1 = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PRemI2  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PRemI2        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C****************** Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PREMI2'                   CAP084
     C                   EVAL      OkRi2 = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PRemI3  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PRemI3        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PREMI3'                   CAP084
     C                   EVAL      OkRi3 = 'N'
     C                   Endif
     C                   Endif
 
     C                   If        PRemI4  <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      PRemI4        Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C*******************Eval      FldNamXAr(Idx) =  DDSName                    CAP084
     C                   Eval      FldNamXAr(Idx) =  'PREMI4'                   CAP084
     C                   EVAL      OkRi4 = 'N'
     C                   Endif
     C                   Endif
      *
      ** Return
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
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     Validate      BEGSR
      *
      ** This is a free format field, but if it is entered then it should
      ** contain either /INV/, /RFB/, or /ROC/. A warning will be sent if
      ** it does not.
      *
     C                   IF        PRemI1 <> *Blanks
      *
     C                   Movel     PRemI1        Fld5              5
      *
     C                   IF        Fld5  = '/INV/' OR
     C                             Fld5  = '/RFB/' OR
     C**********                   Fld5  = '/ROC/'                                            CSW208
     C                             Fld5  = '/ROC/' OR                                         CSW208
     C                             Fld5  = '/IPI/' OR                                         CSW208
     C                             Fld5  = '/TSU/' AND                                        CSW208
     C                             CSW208 = 'Y'                                               CSW208
      *
     C                   Else
      *
     C                   EVAL      WIx            =   WIx + 1
     C                   EVAL      WMsgIdXAr(WIx) =   'RFV0248'
     C                   EVAL      WFldNmXAr(WIx) =   DDSName
     C                   EVAL      WMsgDtXAr(WIx) =   %Subst(PRemI1:1:35)
     C                   EVAL      OkRi1 = 'W'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *Entry        PLIST
      *
      ** INPUTS
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode        1
      *
      ** Screen fields
      *
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
      *
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName          10
     C                   PARM                    OkFlagDS1
     C                   PARM                    OkFlagDs2
     C                   PARM                    OkFlagHS1
     C                   PARM                    OkFlagHs2
                                                                                              CSW208
      *                                                                                       CSW208
      ** Determine if CSW208 is installed                                                     CSW208
      *                                                                                       CSW208
     C                   MOVEL     'N'           CSW208            1                          CSW208
     C                   CALL      'SWIF2008'                                                 CSW208
     C                   PARM      *BLANKS       PRTCD             7                          CSW208
                                                                                              CSW208
     C                   IF        PRTCD = 'CSW2008'                                          CSW208
     C                   MOVEL     'Y'           CSW208                                       CSW208
     C                   ENDIF                                                                CSW208
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
