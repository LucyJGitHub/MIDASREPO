     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Display BIC database plus enquiry 2')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTM102GEN   - Display BIC Database Plus Enquiry 2            *
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
      *  Prev Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT007  *CREATE    Date 26Jan00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes                                  *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
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
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)
 
      * OK Flags for header
     D OKFlagH       E DS                  EXTNAME(FTE102H1PD)
 
      * OK Flags for detail
     D OKFlagD       E DS                  EXTNAME(FTE102S1PD)
 
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
 
      ** Parameters for FT0900
     D Mode            S              1
     D SearchCrit      S             35
     D ChipsID         S             10
     D RetrnCde        S              2
     D ErrorCde        S              7
     D CSW207          S              1                                                       CSW207
     D RetCd           S              7                                                       CSW207
 
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
 
      ** If the cursor is not in the 1st or 2nd lines of Account With
      ** Institution (35 long), Ordering Institution (35 long), Sending
      ** Institution,  Ordering Customer, Beneficiary, Destination, Sender's
      ** Corrspondent or Receiver's Correspondent, display error.
 
     C                   If        DDSName <> 'HSOINST'
     C                             AND DDSName <> 'STOCUS1'
     C                             AND DDSName <> 'STOCUS2'
     C                             AND DDSName <> 'SSINST'
     C                             AND DDSName <> 'SCCTDST'
     C                             AND DDSName <> 'SSNDCOR'
     C                             AND DDSName <> 'SRCVCOR'
     C                             AND DDSName <> 'SBENF1'
     C                             AND DDSName <> 'SBENF2'
     C                             AND DDSName <> 'SACCI35'
     C                             AND DDSName <> 'SACCI11'
     C                             AND DDSName <> 'SOINS1'
     C                             AND DDSName <> 'SOINST'
     C                             AND DDSName <> 'SORDCU1'
     C                             AND DDSName <> 'SORDCU2'
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
 
     C                   When      DDSName = 'HSOINST'
     C                   Eval      SearchCrit = HPOINST3
 
     C                   When      DDSName = 'STOCUS1'
     C                   Eval      SearchCrit = HPTOCUS1
 
     C                   When      DDSName = 'STOCUS2'
     C                   Eval      SearchCrit = HPTOCUS2
 
     C                   When      DDSName = 'SSINST'
     C                   Eval      SearchCrit = HPSINST
 
     C                   When      DDSName = 'SCCTDST'
     C                   Eval      SearchCrit = HPCCTDST
 
     C                   When      DDSName = 'SSNDCOR'
     C                   Eval      SearchCrit = HPSNDCOR
 
     C                   When      DDSName = 'SRCVCOR'
     C                   Eval      SearchCrit = HPRCVCOR
 
     C                   When      DDSName = 'SBENF1'
     C                   Eval      SearchCrit = PBENF1
 
     C                   When      DDSName = 'SBENF2'
     C                   Eval      SearchCrit = PBENF2
 
     C                   When      DDSName = 'SACCI35'
     C                   Eval      SearchCrit = PACCI35
 
     C                   When      DDSName = 'SACCI11'
     C                   Eval      SearchCrit = PACCI11
 
     C                   When      DDSName = 'SOINST'
     C                   Eval      SearchCrit = PORDI35
 
     C                   When      DDSName = 'SOINS1'
     C                   Eval      SearchCrit = PORDI11
 
     C                   When      DDSName = 'SORDCU1'
     C                   Eval      SearchCrit = PORDCU1
 
     C                   When      DDSName = 'SORDCU2'
     C                   Eval      SearchCrit = PORDCU2
 
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
     C                   If        PCCTCCY = 'USD' and DDSName = 'SSINST'
     C                             or PCCTCCY='USD' and DDSName = 'SCCTDST'
     C                             or PCCTCCY = 'USD' and DDSName = 'SSNDCOR'
     C                             or PCCTCCY = 'USD' and DDSName = 'SRCVCOR'
     C                             or PPAYCCY = 'USD' and DDSName = 'STOCUS1'
     C                             or PPAYCCY = 'USD' and DDSName = 'HSOINST'
     C                             or PPAYCCY = 'USD' and DDSName = 'SBENF1'
     C                             or PPAYCCY = 'USD' and DDSName = 'SACCI35'
     C                             or PPAYCCY = 'USD' and DDSName = 'SACCI11'
     C                             or PPAYCCY = 'USD' and DDSName = 'SOINST'
     C                             or PPAYCCY = 'USD' and DDSName = 'SOINS1'
     C                             or PPAYCCY = 'USD' and DDSName = 'SORDCU1'
 
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
 
     C                   If        DDSName = 'STOCUS2' and RetrnCde = 'BC'
     C                             or DDSName='STOCUS2' and RetrnCde = 'DC'
     C                             or DDSName='SBENF2' and RetrnCde = 'BC'
     C                             or DDSName='SBENF2' and RetrnCde = 'DC'
     C                             or DDSName='SORDCU2' and RetrnCde = 'BC'
     C                             or DDSName='SORDCU2' and RetrnCde = 'DC'
     C                             or RetrnCde = 'AC'
     C                   Eval      Reform1 = Reform2
     C                   Eval      Reform2 = Reform3
     C                   Eval      Reform3 = Reform4
     C                   Eval      Reform4 = Reform5
     C                   Eval      Reform5 = *Blanks
     C                   Endif
 
     C                   If        DDSName = 'SSINST' or DDSName = 'SCCTDST'
     C                             or DDSName='STOCUS1' or DDSName='SSNDCOR'
     C                             or DDSName='SRCVCOR' or DDSName='SBENF1'
     C                             or DDSName='SORDCU1'
     C                   Select
 
     C                   When      DDSName = 'SSINST'
     C                   Eval      HPSINST = Reform1
 
     C                   When      DDSName = 'SCCTDST'
     C                   Eval      HPCCTDST = Reform1
 
     C                   When      DDSName = 'STOCUS1'
     C                   Eval      HPTOCUS1 = Reform1
     C                   Eval      HPTOCUS2 = Reform2
     C                   Eval      HPTOCUS3 = Reform3
     C                   Eval      HPTOCUS4 = Reform4
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   Eval      HPTOCUS5 = Reform4                                         CSW207
     C                   ENDIF                                                                CSW207
 
     C                   When      DDSName = 'SSNDCOR'
     C                   Eval      HPSNDCOR = Reform1
 
     C                   When      DDSName = 'SRCVCOR'
     C                   Eval      HPRCVCOR = Reform1
 
     C                   When      DDSName = 'SBENF1'
     C                   Eval      PBENF1 = Reform1
     C                   Eval      PBENF2 = Reform2
     C                   Eval      PBENF3 = Reform3
     C                   Eval      PBENF4 = Reform4
     C                   Eval      PBENF5 = Reform5
 
     C                   When      DDSName = 'SORDCU1'
     C                   Eval      PORDCU1 = Reform1
     C                   Eval      PORDCU2 = Reform2
     C                   Eval      PORDCU3 = Reform3
     C                   Eval      PORDCU4 = Reform4
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   Eval      PORDCU5 = Reform4                                          CSW207
     C                   ENDIF                                                                CSW207
 
     C                   Endsl
     C                   Endif
 
     C                   If        DDSName = 'STOCUS2' or DDSName = 'SBENF2'
     C                             or DDSName='SORDCU2'
     C                   Select
 
     C                   When      DDSName = 'STOCUS2'
     C                   Eval      HPTOCUS2 = Reform1
     C                   Eval      HPTOCUS3 = Reform2
     C                   Eval      HPTOCUS4 = Reform3
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   Eval      HPTOCUS5 = Reform4                                         CSW207
     C                   ENDIF                                                                CSW207
 
     C                   When      DDSName = 'SBENF2'
     C                   Eval      PBENF2 = Reform1
     C                   Eval      PBENF3 = Reform2
     C                   Eval      PBENF4 = Reform3
     C                   Eval      PBENF5 = Reform4
 
     C                   When      DDSName = 'SORDCU2'
     C                   Eval      PORDCU2 = Reform1
     C                   Eval      PORDCU3 = Reform2
     C                   Eval      PORDCU4 = Reform3
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   Eval      PORDCU5 = Reform4                                          CSW207
     C                   ENDIF                                                                CSW207
 
     C                   Endsl
     C                   Endif
 
     C                   If        DDSName = 'HSOINST' or DDSName = 'SACCI35'
     C                             or DDSName='SOINST' or DDSName = 'PACCI11'
     C                   If        RetrnCde = 'AC' or RetrnCde = 'A'
     C                   Select
 
     C                   When      DDSName = 'HSOINST'
     C                   Eval      HPOINST3 = Reform1
 
     C                   When      DDSName = 'SACCI35'
     C                   Eval      PACCI35 = Reform1
 
     C                   When      DDSName = 'SACCI11'
     C                   Eval      PACCI11 = Reform1
 
     C                   When      DDSName = 'SOINST'
     C                   Eval      PORDI35 = Reform1
 
     C                   Endsl
 
     C                   Else
 
     C                   Select
 
     C                   When      DDSName = 'HSOINST'
     C                   Eval      HPOINST3 = Reform1
 
     C                   When      DDSName = 'SACCI35'
     C                   Eval      PACCI35 = Reform1
 
     C                   When      DDSName = 'SACCI11'
     C                   Eval      PACCI11 = Reform1
 
     C                   When      DDSName = 'SOINS1'
     C                   Eval      PORDI11 = Reform1
 
     C                   When      DDSName = 'SOINST'
     C                   Eval      PORDI35 = Reform1
 
     C                   Endsl
     C                   Endif
     C                   Endif
     C                   Endif
 
 
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
 
      ** Check Swift 2007 is installed                                                        CSW207
                                                                                              CSW207
     C                   Call      'SWIF2007'                                                 CSW207
     C                   PARM                    RetCd                                        CSW207
                                                                                              CSW207
     C                   IF        RetCd = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
 
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
