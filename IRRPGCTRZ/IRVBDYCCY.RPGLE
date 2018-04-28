     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Ccy for business day conv. validation')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRVBDYCCY - Currencies for Business Day Conventions          *
      *               Validation                                      *
      *                                                               *
      *  Function:  This module validates the currency conventions    *
      *             fields                                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Prev Amend No. CIR005   *CREATE   Date 21Jan00               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
      *                                                               *
      *****************************************************************
      /EJECT
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
     D CcyArr          S              3    DIM(10)
     D OkFlagDS        S              1    DIM(10)
     D OkFlagDS1       S              1    DIM(10)
     D OkFlagDS2       S              1    DIM(10)
 
      ** Data structure containing currency details
     D SdCurr        E DS                  EXTNAME(SDCURRPD)
 
      ** External Data Structure for Access Programs (Long)
     D Dssdy         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for Arrays of Error Message IDs Etc.
     D Idx             S              2P 0
     D WIdx            S              2P 0
 
     D WFlag           S              1
     D WCtr            S              2P 0  INZ(0)
     D WCtr2           S              2P 0  INZ(0)
     D WLCtr           S              2P 0  INZ(0)
     D WWCtr           S              2P 0  INZ(0)
 
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
 
     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      OkFlagDS1 = *All'Y'
     C                   Eval      OkFlagDS2 = *All'Y'
     C                   Eval      Idx = 0
     C                   Eval      WIdx = 1
 
      ** Validate Rate Fixing Currencies
 
     C                   MoveA     PCcy1         CcyArr
     C                   Eval      WFlag = 'R'
     C                   Exsr      SrVald
     C                   MoveA     CcyArr        PCcy1
     C                   MoveL     OkFlagDS      OkFlagDS1
 
      ** Validate Payment Currencies
 
     C                   If        PCode = 'B'
     C                   MoveA     PCcy2         CcyArr
     C                   Eval      WFlag = 'P'
     C                   Exsr      SrVald
     C                   MoveA     CcyArr        PCcy2
     C                   MoveL     OkFlagDS      OkFlagDS2
     C                   Endif
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrVald - Validate Currencies                                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrCurr                                                 *
      *                                                               *
      *****************************************************************
 
     C     SrVald        Begsr
 
     C                   Eval      OkFlagDS = *All'Y'
     C                   Eval      WCtr = 10
     C                   Eval      WCtr2 = 0
     C                   Eval      ErrorFound = 'N'
 
     C                   Dow       CcyArr(WCtr) = *Blanks
     C                   Eval      WCtr = WCtr - 1
     C                   If        WCtr = 0
     C                   Leave
     C                   Endif
     C                   Enddo
 
     C                   Select
 
      ** The first currency is mandatory.
 
     C                   When      WCtr = 0
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'MMM0142'
     C                   Eval      ErrorFound = 'Y'
     C                   Eval      OkFlagDS(1) = 'N'
     C                   Eval      WCtr = 1
     C                   Exsr      SrFldN
 
     C                   Other
     C                   Eval      WLCtr = WCtr
     C                   Eval      WCtr = 1
     C                   Dow       WCtr <= WLCtr
     C                   Exsr      SrCurr
     C                   Eval      WCtr = WCtr + 1
     C                   Enddo
 
     C                   If        ErrorFound <> 'Y'
     C                   Eval      WCtr = 1
     C                   Dow       WCtr <= WLCtr
     C                   Eval      WCtr2 = 1
     C                   Dow       (WCtr + WCtr2) <= WLCtr
 
      ** Each currency must be unique within the set.
 
     C                   If        CcyArr(WCtr) = CcyArr(WCtr + WCtr2)
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'MMA0850'
     C                   Eval      ErrorFound = 'Y'
     C                   Eval      OkFlagDS(WCtr + WCtr2) = 'N'
     C                   Exsr      SrFldN
     C                   Endif
     C                   Eval      WCtr2 = WCtr2 + 1
 
     C                   Enddo
     C                   Eval      WCtr = WCtr + 1
     C                   Enddo
 
     C                   Endif
 
     C                   If        WFlag = 'R' and
     C                             ErrorFound <> 'Y'
     C                   Eval      WCtr = 1
     C                   Dow       WCtr <= WLCtr and
     C                             CcyArr(WCtr) <> PLCcy
 
      ** Local currency is not one of the rate fixing curriencies specified
 
     C                   If        WCtr = WLCtr and
     C                             CcyArr(WCtr) <> PLCcy
     C                   Eval      WMsgIdArr(WIdx) = 'MMA0854'
     C                   If        PCode = 'B'
     C                   Eval      WFldNamArr(WIdx) = 'SC1R'
     C                   Else
     C                   Eval      WFldNamArr(WIdx) = 'SCYR1'
     C                   Endif
 
     C                   Eval      WWCtr = 1
     C                   Dow       WWCtr <= WLCtr
     C                   Eval      OkFlagDS(WWCtr) = 'W'
     C                   Eval      WWCtr = WWCtr + 1
     C                   Enddo
     C                   Endif
 
     C                   Eval      WCtr = WCtr + 1
     C                   Enddo
     C                   Endif
 
     C                   Endsl
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCurr - Access Currency Details                              *
      *                                                               *
      * Called by: SrVald                                             *
      *                                                               *
      * Calls: ZAVCURCODE                                             *
      *                                                               *
      *****************************************************************
 
     C     SrCurr        Begsr
 
     C                   CallB     'ZAVCURCODE'
     C                   Parm      *Blanks       PRtcd             7
     C                   Parm                    PMsgId            7
     C                   Parm      CcyArr(WCtr)  PCurr             3
     C     SdCurr        Parm      SdCurr        Dssdy
 
     C                   If        PRtcd <> *Blanks
     C                   Eval      ErrorFound = 'Y'
     C                   Eval      OkFlagDS(WCtr) = 'N'
 
     C                   Select
 
      ** Invalid Currency
     C                   When      PMsgId = 'MMM0202'
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'MMM0202'
     C                   Exsr      SrFldN
 
      ** Screen Currency Field is Blank
     C                   When      PMsgId = 'MMM0142'
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = 'MMM0142'
     C                   Exsr      SrFldN
     C                   Endsl
      *
     C                   Else
     C                   MoveL     A6CYCD        CcyArr(WCtr)
 
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFldN - Passes Appropriate Field Name                        *
      *                                                               *
      * Called by: SrVald, SrCurr                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrFldN        Begsr
 
     C                   If        PCode = 'B'
     C                   If        WFlag = 'R'
 
     C                   Select
     C                   When      WCtr + WCtr2 = 1
     C                   Eval      FldNameArr(Idx) = 'SC1R'
     C                   When      WCtr + WCtr2 = 2
     C                   Eval      FldNameArr(Idx) = 'SC2R'
     C                   When      WCtr + WCtr2 = 3
     C                   Eval      FldNameArr(Idx) = 'SC3R'
     C                   When      WCtr + WCtr2 = 4
     C                   Eval      FldNameArr(Idx) = 'SC4R'
     C                   When      WCtr + WCtr2 = 5
     C                   Eval      FldNameArr(Idx) = 'SC5R'
     C                   When      WCtr + WCtr2 = 6
     C                   Eval      FldNameArr(Idx) = 'SC6R'
     C                   When      WCtr + WCtr2 = 7
     C                   Eval      FldNameArr(Idx) = 'SC7R'
     C                   When      WCtr + WCtr2 = 8
     C                   Eval      FldNameArr(Idx) = 'SC8R'
     C                   When      WCtr + WCtr2 = 9
     C                   Eval      FldNameArr(Idx) = 'SC9R'
     C                   When      WCtr + WCtr2 = 10
     C                   Eval      FldNameArr(Idx) = 'SC0R'
     C                   Endsl
      *
     C                   Else
      *
     C                   Select
     C                   When      WCtr + WCtr2 = 1
     C                   Eval      FldNameArr(Idx) = 'SC1P'
     C                   When      WCtr + WCtr2 = 2
     C                   Eval      FldNameArr(Idx) = 'SC2P'
     C                   When      WCtr + WCtr2 = 3
     C                   Eval      FldNameArr(Idx) = 'SC3P'
     C                   When      WCtr + WCtr2 = 4
     C                   Eval      FldNameArr(Idx) = 'SC4P'
     C                   When      WCtr + WCtr2 = 5
     C                   Eval      FldNameArr(Idx) = 'SC5P'
     C                   When      WCtr + WCtr2 = 6
     C                   Eval      FldNameArr(Idx) = 'SC6P'
     C                   When      WCtr + WCtr2 = 7
     C                   Eval      FldNameArr(Idx) = 'SC7P'
     C                   When      WCtr + WCtr2 = 8
     C                   Eval      FldNameArr(Idx) = 'SC8P'
     C                   When      WCtr + WCtr2 = 9
     C                   Eval      FldNameArr(Idx) = 'SC9P'
     C                   When      WCtr + WCtr2 = 10
     C                   Eval      FldNameArr(Idx) = 'SC0P'
     C                   Endsl
     C                   Endif
      *
     C                   Else
     C                   Select
     C                   When      WCtr + WCtr2 = 1
     C                   Eval      FldNameArr(Idx) = 'SCYR1'
     C                   When      WCtr + WCtr2 = 2
     C                   Eval      FldNameArr(Idx) = 'SCYR2'
     C                   When      WCtr + WCtr2 = 3
     C                   Eval      FldNameArr(Idx) = 'SCYR3'
     C                   When      WCtr + WCtr2 = 4
     C                   Eval      FldNameArr(Idx) = 'SCYR4'
     C                   When      WCtr + WCtr2 = 5
     C                   Eval      FldNameArr(Idx) = 'SCYR5'
     C                   When      WCtr + WCtr2 = 6
     C                   Eval      FldNameArr(Idx) = 'SCYR6'
     C                   When      WCtr + WCtr2 = 7
     C                   Eval      FldNameArr(Idx) = 'SCYR7'
     C                   When      WCtr + WCtr2 = 8
     C                   Eval      FldNameArr(Idx) = 'SCYR8'
     C                   When      WCtr + WCtr2 = 9
     C                   Eval      FldNameArr(Idx) = 'SCYR9'
     C                   When      WCtr + WCtr2 = 10
     C                   Eval      FldNameArr(Idx) = 'SCYR0'
     C                   Endsl
     C                   Endif
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        Begsr
 
     C     *Entry        Plist
     C                   Parm                    RetCodeIn
     C                   Parm                    PCode             1
     C                   Parm                    PLCcy             3
     C                   Parm                    PCcy1            30
     C                   Parm                    PCcy2            30
     C                   Parm                    OkFlagDS1
     C                   Parm                    OkFlagDS2
     C                   Parm                    MsgIdArr
     C                   Parm                    FldNameArr
     C                   Parm                    WMsgIdArr
     C                   Parm                    WFldNamArr
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   Endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
