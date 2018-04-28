     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Rate fix date calc. using bus. day conv')
      *****************************************************************
      *                                                               *
      *  Midas - IRS Validation Module                                *
      *                                                               *
      *  IRRTFXCNV  - Rate Fixing Date Calculation using Business Day *
      *               Conventions.                                    *
      *                                                               *
      *  Function:  This API module will serve as Rate Fix Date cal-  *
      *             culation module using all currencies for Rate     *
      *             Fixing Convention. It replaces Midas subroutine   *
      *             DLBACK and ZBKDT which calculates Rate Fix Date   *
      *             using Sterling, local currency or transaction     *
      *             currency as defined on ICD. This will be made     *
      *             switchable under enhancement number CIR005.       *
      *                                                               *
      *  Called By: IRVRTCHGDT                                        *
      *             IRVSTERMRT                                        *
      *             IRVRATEFIX                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Last Amend No. CIR005  *CREATE    Date 21Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CIR005 - FRA/IRS Business Day Conventions.                   *
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Vale Date for FRAs or Rate Change Date for IRs converted to
      ** Midas Day No. (passed by the calling program)
     D  PDate          S              5  0
 
      ** Rate Fix Days (passed by the calling program)
     D  PRtFxDy        S              2  0
 
      ** Location (passed by the calling program)
     D  PLoc           S              3A
 
      ** Currencies for Rate Fixing Conventions Leg1
     D  PRateCur       S             30A
 
      ** Return paramter for Rate Fix Date (Output)
     D  PRtFxDt        S              5  0
 
      ** Holiday found work field
     D  WHolFnd        S              1A
 
      ** Rate Fixing Convention currency work field
     D  WRtFxCur       S              3A
 
      ** Holiday indicator used by ZCHKH module
     D  WHolInd        S              1A
 
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
 
      ** Rate fix day is entered
 
     C                   Eval      PRtFxDt = PDate
 
     C                   If        PRtFxDy <> 0
     C     1             Do        PRtFxDy
 
      ** Decrement Rate Fix Date by 1 until it is no longer a holiday
      ** from one of the currencies for Rate Fixing Conventions.
 
     C     WHolFnd       DouEq     'N'
 
      ** Set index variables.
 
     C                   Z-Add     1             C                 2 0
     C                   Z-Add     1             S                 2 0
     C                   Z-Add     3             L                 2 0
 
      ** Get first Rate Fixing Convention currency.
 
     C     L             SubSt     PRateCur:S    WRtFxCur
 
     C                   Eval      WHolFnd = 'N'
     C                   Eval      PRtFxDt = PRtFxDt - 1
 
      ** Check Rate Fix Date if not a holiday for all the Rate Fixing
      ** Conventions currencies.
 
     C     C             DowLe     10
     C     WRtFxCur      AndNe     *Blank
     C                   CallB     'ZCHKH'
     C                   Parm                    PRtFxDt
     C                   Parm                    WRtFxCur
     C                   Parm                    PLoc
     C                   Parm                    WHolInd
 
      ** Date is holiday in Rate Fixing Convention currency, set
      ** holiday found indicator to 'Y'.
 
     C                   If        WHolind = 'H'
     C                   Eval      WHolFnd = 'Y'
     C                   EndIf
 
      ** Get next currency.
 
     C                   Eval      C = C+1
     C                   Eval      S = S+3
     C                   If        (C < 10) Or (C = 10)
     C     L             SubSt     PRateCur:S    WRtFxCur
     C                   EndIf
     C                   EndDo
     C                   EndDo
     C                   EndDo
 
     C                   EndIf
 
     C                   Return
 
      *****************************************************************
      *                                                               *
      * SR/*InzSr: Initialisation Routine                             *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *InzSr        BegSr
 
      ** Entry Parameters
 
     C     *Entry        PList
     C                   Parm                    PDate
     C                   Parm                    PRtFxDy
     C                   Parm                    PLoc
     C                   Parm                    PRateCur
     C                   Parm                    PRtFxDt
 
      ** Format Program detail
 
     C                   Eval      DbPgm = 'IRRTFXCNV'
 
     C                   EndSr
 
      ****************************************************************
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
