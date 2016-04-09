     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Display BIC database plus enquiry')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTM101GEN  - Display BIC Database Plus Enquiry               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG10602           Date 16Feb06               *
      *  Prev Amend No. 221761             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT007  *CREATE    Date 26Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  185107 - Mapping of details from swift message               *
      *  CFT007 - BIC Database Plus                                   *
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
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD) PREFIX(H)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT101DSPD)
 
      * OK Flags for header
     D OKFlagH       E DS                  EXTNAME(FTE101HPD)
 
      * OK Flags for detail
     D OKFlagD       E DS                  EXTNAME(FTE101S1PD)
 
      * Reformatted Address
     D ReformAdd       DS
     D Reform1                 1     35
     D Reform2                36     70
     D Reform3                71    105
     D Reform4               106    140
     D Reform5               141    175
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
 
     D RespMode        S              1
     D DDSName         S             10
     D FuncKey         S              2
 
     D SlashOne        S              1
     D SlashTwo        S              1
     D ReformTmp       S             35
 
      ** Parameters for FT0900
     D Mode            S              1
     D SearchCrit      S             35
     D ChipsID         S             10
     D RetrnCde        S              2
     D ErrorCde        S              7
 
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
     C                   Eval      SearchCrit = *Blanks
 
      ** If the cursor is not in the 1st or 2nd lines of Account With
      ** Institution (35 long), Intermediary (35 long), Account Servicing
      ** Institution (35 long), Ordering Customer, Beneficiary or Sending
      ** Institution, display error.
 
     C                   If        DDSName <> 'SACA35'
     C                             AND DDSName <> 'SACA11'
     C                             AND DDSName <> 'SINST1'
     C                             AND DDSName <> 'SINSTA'
     C                             AND DDSName <> 'SASI35'
     C                             AND DDSName <> 'SACC11'
     C                             AND DDSName <> 'SOCUS1'
     C                             AND DDSName <> 'SOCUS2'
     C                             AND DDSName <> 'SBNA35'
     C                             AND DDSName <> 'SBNB35'
     C                             AND DDSName <> 'SHACSV1'
     C                             AND DDSName <> 'SHACSV2'
     C                             AND DDSName <> 'SHOCUS1'
     C                             AND DDSName <> 'SHOCUS2'
     C                             AND DDSName <> 'SSINST'
     C                   Add       1             Idx
     C                   Eval      FldNamXAr(Idx) = DDSName
     C                   Eval      MsgIdXAr(Idx) = 'RFV0341'
     C                   Return
     C                   Endif
 
      ** If F4 pressed, FT0900 operates in 'in-line prompt' mode
 
     C                   If        FuncKey = '04'
     C                   Eval      Mode = 'P'
     C                   Endif
 
      ** If F16 pressed, FT0900 operates in 'in-line search' mode
 
     C                   If        FuncKey = '16'
     C                   Eval      Mode = 'F'
     C                   Endif
 
      ** Move field contents into the search criteria
 
     C                   Select
 
     C                   When      DDSName = 'SACA35'
     C                   Eval      SearchCrit = PACA35
     C                   Exsr      ChkSlh
 
     C                   When      DDSName = 'SACA11'
     C                   Eval      SearchCrit = PACA11
     C                   Exsr      ChkSlh
 
     C                   When      DDSName = 'SINST1'
     C                   Eval      SearchCrit = PINST1
     C                   Exsr      ChkSlh
 
     C                   When      DDSName = 'SINSTA'
     C                   Eval      SearchCrit = PINSTA
     C                   Exsr      ChkSlh
 
     C                   When      DDSName = 'SASI35'
     C                   Eval      SearchCrit = PASI35
     C                   Exsr      ChkSlh
 
     C                   When      DDSName = 'SACC11'
     C                   Eval      SearchCrit = PACC11
     C                   Exsr      ChkSlh
 
     C                   When      DDSName = 'SOCUS1'
     C                   Eval      SearchCrit = POCUS1
     C                   Exsr      ChkSlh
 
     C                   When      DDSName = 'SOCUS2'
     C                   Eval      SearchCrit = POCUS2
     C                   Exsr      ChkSlh
 
     C                   When      DDSName = 'SBNA35'
     C                   Eval      SearchCrit = PBNA35
     C                   Exsr      ChkSlh
 
     C                   When      DDSName = 'SBNB35'
     C                   Eval      SearchCrit = PBNB35
     C                   Exsr      ChkSlh
 
     C                   When      DDSName = 'SHACSV1'
     C                   Eval      SearchCrit = HPHACSV1
     C                   Exsr      ChkSlh
 
     C                   When      DDSName = 'SHACSV2'
     C                   Eval      SearchCrit = HPHACSV2
     C                   Exsr      ChkSlh
 
     C                   When      DDSName = 'SHOCUS1'
     C                   Eval      SearchCrit = HPHOCUS1
     C                   Exsr      ChkSlh
 
     C                   When      DDSName = 'SHOCUS2'
     C                   Eval      SearchCrit = HPHOCUS2
     C                   Exsr      ChkSlh
 
     C                   When      DDSName = 'SSINST'
     C                   Eval      SearchCrit = HPSINST
     C                   Exsr      ChkSlh
 
     C                   Endsl
 
      ** Call BIC plus enquiry program
 
     C                   Call      'FT0900'
     C                   Parm                    Mode
     C                   Parm                    SearchCrit
     C                   Parm      *Blanks       ReformAdd
     C                   Parm      *Blanks       ChipsID
     C                   Parm      *Blanks       RetrnCde
     C                   Parm      *Blanks       ErrorCde
 
      ** If F3 pressed in BIC plus enquiry program, exit to menu
 
     C                   If        ErrorCde = 'F3'
     C                   Seton                                        LR
     C                   Endif
 
      ** If no errors occured on call of FT0900
 
     C                   If        ErrorCde = *Blanks
 
     C                   If        ChipsID <> *Blanks and RetrnCde <> 'AC'
     C                   If        PTRNCCY = 'USD' and DDSName = 'SHOCUS1'
     C                             or PTRNCCY='USD' and DDSName = 'SHACSV1'
     C                             or PTRNCCY='USD' and DDSName = 'SHACSV2'
     C                             or PTRNCCY = 'USD' and DDSName = 'SSINST'
     C                             or PTRNCCY = 'USD' and DDSName = 'SOCUS1'
     C                             or PTRNCCY = 'USD' and DDSName = 'SASI35'
     C                             or PTRNCCY = 'USD' and DDSName = 'SACC11'
     C                             or PPAYCCY = 'USD' and DDSName = 'SINST1'
     C                             or PPAYCCY = 'USD' and DDSName = 'SACA35'
     C                             or PPAYCCY = 'USD' and DDSName = 'SBNA35'
     C                             or PPAYCCY = 'USD' and DDSName = 'SINSTA'
     C                             or PPAYCCY = 'USD' and DDSName = 'SACA11'
 
     C                   If        RetrnCde = 'BC' or RetrnCde = 'DC'
     C     '//CH'        CAT(P)    ChipsID       Reform1
     C                   Else
     C                   Eval      Reform5 = Reform4
     C                   Eval      Reform4 = Reform3
     C                   Eval      Reform3 = Reform2
     C                   Eval      Reform2 = Reform1
     C     '//CH'        CAT(P)    ChipsID       Reform1
     C                   Endif
 
     C                   Endif
     C                   Endif
 
     C                   If        DDSName = 'SHOCUS2' and RetrnCde = 'BC'
     C                             or DDSName='SHOCUS2' and RetrnCde = 'DC'
     C                             or DDSName='SOCUS2' and RetrnCde = 'BC'
     C                             or DDSName='SOCUS2' and RetrnCde = 'DC'
     C                             or DDSName='SINSTA' and RetrnCde = 'BC'
     C                             or DDSName='SINSTA' and RetrnCde = 'DC'
     C                             or DDSName='SACA11' and RetrnCde = 'BC'
     C                             or DDSName='SACA11' and RetrnCde = 'DC'
     C                             or DDSName='SBNB35' and RetrnCde = 'BC'
     C                             or DDSName='SBNB35' and RetrnCde = 'DC'
     C                             or RetrnCde = 'AC'
     C                   Eval      Reform1 = Reform2
     C                   Eval      Reform2 = Reform3
     C                   Eval      Reform3 = Reform4
     C                   Eval      Reform4 = Reform5
     C                   Eval      Reform5 = *Blanks
     C                   Endif
 
     C                   Exsr      PutSlh
 
     C                   If        DDSName = 'SHOCUS1' or DDSName = 'SSINST'
     C                             or DDSName='SOCUS1' or DDSName='SBNA35'
 
     C                   Select
 
     C                   When      DDSName = 'SHOCUS1'
     C                   Eval      HPHOCUS1 = Reform1
     C                   Eval      HPHOCUS2 = Reform2
     C                   Eval      HPHOCUS3 = Reform3
     C                   Eval      HPHOCUS4 = Reform4
     C                   Eval      HPHOCUS5 = Reform5
 
     C                   When      DDSName = 'SSINST'
     C                   Eval      HPSINST = Reform1
 
     C                   When      DDSName = 'SOCUS1'
     C                   Eval      POCUS1 = Reform1
     C                   Eval      POCUS2 = Reform2
     C                   Eval      POCUS3 = Reform3
     C                   Eval      POCUS4 = Reform4
     C                   Eval      POCUS5 = Reform5
 
     C                   When      DDSName = 'SBNA35'
     C                   Eval      PBNA35 = Reform1
     C                   Eval      PBNB35 = Reform2
     C                   Eval      PBNC35 = Reform3
     C                   Eval      PBND35 = Reform4
     C                   Eval      PBNE35 = Reform5
 
     C                   Endsl
     C                   Endif
 
     C                   If        DDSName = 'SHOCUS2' or DDSName = 'SOCUS2'
     C                             or DDSName='SBNB35'
     C                   Select
 
     C                   When      DDSName = 'SHOCUS1'
     C                   Eval      HPHOCUS2 = Reform1
     C                   Eval      HPHOCUS3 = Reform2
     C                   Eval      HPHOCUS4 = Reform3
     C                   Eval      HPHOCUS5 = Reform4
 
     C                   When      DDSName = 'SOCUS1'
     C                   Eval      POCUS2 = Reform1
     C                   Eval      POCUS3 = Reform2
     C                   Eval      POCUS4 = Reform3
     C                   Eval      POCUS5 = Reform4
 
     C                   When      DDSName = 'SOCUS2'
     C                   Eval      POCUS2 = Reform1
     C                   Eval      POCUS3 = Reform2
     C                   Eval      POCUS4 = Reform3
     C                   Eval      POCUS5 = Reform4
 
     C                   When      DDSName = 'SBNB35'
     C                   Eval      PBNB35 = Reform1
     C                   Eval      PBNC35 = Reform2
     C                   Eval      PBND35 = Reform3
     C                   Eval      PBNE35 = Reform4
 
     C                   Endsl
     C                   Endif
 
     C                   If        DDSName = 'SHACSV1' Or
     C                             DDSName = 'SASI35'  Or
     C                             DDSName = 'SACC11'  Or
     C                             DDSName = 'SACA35'  Or
     C                             DDSName = 'SINST1'  Or
     C                             DDSName = 'SHACSV2'
     C                   If        RetrnCde = 'AC' or RetrnCde = 'A'
     C                   Select
 
     C                   When      DDSName = 'SHACSV1'
     C                   Eval      HPHACSV1 = Reform1
 
     C                   When      DDSName = 'SHACSV2'
     C                   Eval      HPHACSV2 = Reform1
 
     C                   When      DDSName = 'SASI35'
     C                   Eval      PASI35 = Reform1
 
     C                   When      DDSName = 'SACC11'
     C                   Eval      PACC11 = Reform1
 
     C                   When      DDSName = 'SACA35'
     C                   Eval      PACA35 = Reform1
 
     C                   When      DDSName = 'SINST1'
     C                   Eval      PINST1 = Reform1
 
     C                   Endsl
 
     C                   Else
 
     C                   Select
 
     C                   When      DDSName = 'SHACSV1'
     C                   Eval      HPHACSV1 = Reform1
 
     C                   When      DDSName = 'SHACSV2'
     C                   Eval      HPHACSV2 = Reform1
 
     C                   When      DDSName = 'SASI35'
     C                   Eval      PASI35 = Reform1
 
     C                   When      DDSName = 'SACC11'
     C                   Eval      PACC11 = Reform1
 
     C                   When      DDSName = 'SACA35'
     C                   Eval      PACA35 = Reform1
     C                   Eval      PACB35 = Reform2
     C                   Eval      PACC35 = Reform3
     C                   Eval      PACD35 = Reform4
     C                   Eval      PACE35 = Reform5
 
     C                   When      DDSName = 'SINST1'
     C                   Eval      PINST1 = Reform1
     C                   Eval      PINST2 = Reform2
     C                   Eval      PINST3 = Reform3
     C                   Eval      PINST4 = Reform4
     C                   Eval      PINST5 = Reform5
 
     C                   Endsl
     C                   Endif
     C                   Endif
 
     C                   If        DDSName='SACA11' or DDSName = 'SINSTA'
     C                   If        RetrnCde = 'AC' or RetrnCde = 'A'
     C                   Select
 
     C                   When      DDSName = 'SACA11'
     C                   Eval      PACA11 = Reform1
 
     C                   When      DDSName = 'SINSTA'
     C                   Eval      PINSTA = Reform1
 
     C                   Endsl
 
     C                   Else
 
     C                   Select
 
     C                   When      DDSName = 'SACA11'
     C                   Eval      PACA11 = Reform1
     C*                  Eval      PACC35 = Reform2
     C*                  Eval      PACD35 = Reform3
     C*                  Eval      PACE35 = Reform4
 
     C                   When      DDSName = 'SINSTA'
     C                   Eval      PINSTA = Reform1
     C*                  Eval      PINST3 = Reform2
     C*                  Eval      PINST4 = Reform3
     C*                  Eval      PINST5 = Reform4
 
     C                   Endsl
     C                   Endif
     C                   Endif
     C                   Endif
 
     C                   Return
 
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * ChkSlh - Determine how many preceeding slashes there are      *
      *                                                               *
      *****************************************************************
     C     ChkSlh        Begsr
 
     C                   Eval      SlashOne   = *Blanks
     C                   Eval      SlashTwo   = *Blanks
 
     C                   Select
     C                   When      %Subst(SearchCrit:1:2) = '//'
     C                   Eval      SlashTwo = 'Y'
     C                   Eval      SearchCrit=%Subst(SearchCrit:3)
     C                   When      %Subst(SearchCrit:1:1) = '/'
     C                   Eval      SlashOne = 'Y'
     C                   Eval      SearchCrit=%Subst(SearchCrit:2)
     C                   Endsl
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PutSlh - Put Slashes back on                                  *
      *                                                               *
      *****************************************************************
     C     PutSlh        Begsr
 
     C                   Eval      ReformTmp = Reform1
 
     C                   Select
     C                   When      SlashTwo = 'Y'
     C     '//'          Cat(P)    ReformTmp     Reform1
     C                   When      SlashOne = 'Y'
     C     '/'           Cat(P)    ReformTmp     Reform1
     C                   Endsl
 
     C                   Endsr
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
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode
     C                   Parm                    ActionCode
 
      *  Screen fields
     C                   Parm                    HdrRcdIn
     C                   Parm                    DtlRcdIn
     C                   Parm                    FuncKey
 
      * OUTPUTS
 
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName
     C                   Parm                    OKFlagD
     C                   Parm                    OKFlagH
 
 
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
(c) Misys International Banking Systems Ltd. 2001
