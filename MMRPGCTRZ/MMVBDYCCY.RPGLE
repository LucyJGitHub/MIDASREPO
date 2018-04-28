     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Ccy for business day conv. validation')       *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVBDYCCY - Currencies for Business Day Conventions          *
      *               Validation                                      *
      *                                                               *
      *  Function:  This module validates the currency conventions    *
      *             fields                                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CDL096  *CREATE    Date 22Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
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
 
      ** Payment Currency Array
     D CcyArr          S              3    DIM(10)
 
      ** Payment Currency Field Names
     D CcyFldDS        DS
     D   CCY1                        10    Inz('DDC1PC')
     D   CCY2                        10    Inz('DDC2PC')
     D   CCY3                        10    Inz('DDC3PC')
     D   CCY4                        10    Inz('DDC4PC')
     D   CCY5                        10    Inz('DDC5PC')
     D   CCY6                        10    Inz('DDC6PC')
     D   CCY7                        10    Inz('DDC7PC')
     D   CCY8                        10    Inz('DDC8PC')
     D   CCY9                        10    Inz('DDC9PC')
     D   CCY0                        10    Inz('DDC0PC')
     D  CcyFld                       10    Overlay(CcyFldDs)
     D                                     Dim(%Elem(CcyArr))
     D PLCcy           S              3
     D PDLCcy          S              3
     D PIKNIPD         S                   LIKE(A6LCD)
     D PCurrency       S             30
     D SetDefault      S              1    Inz('Y')
     D PDDIPFQ         S                   Like(DDIPFQ)
     D PDDNDAT         S                   Like(DDNDAT)
     D OkFlagDS        S              1    DIM(10)
 
     D RtnSysVal       S            200
     D x               S              3U 0
 
      * Constant to hold input parameter for AOSVALR0
     D RtvCnvDft       C                   Const('MMBusDayConvDefault')
 
      ** Data structure for Midas MM API LDNI format definition
     D MMLDNI        E DS                  EXTNAME(MMLDNIPD)
 
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
 
     D/COPY ZACPYSRC,PRGETMDSVL
 
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
     C                   Eval      Idx = 0
     C                   Eval      WIdx = 0
     C                   Eval      ErrorFound = 'N'
     C                   Eval      OkFlagDS = *All'Y'
     C                   Clear                   FldNameArr
     C                   Clear                   WMsgIdArr
     C                   Clear                   WFldNamArr
     C                   Clear                   WMsgDtaArr
 
      ** If no Interest Payment Frequency passed,
      ** Business Day Convention entries are not relevant.
      ** return no error
     C                   If        PDDIPFQ = *BLANK
     C                   Return
     C                   EndIf
 
      ** Interest Payment Frequency passed.
      ** Set Deal Currency as default if SetDefault = 'Y'
      **   then exit (skip other checks as
      **   we only have one valid currency)
 
     C                   If        SetDefault = 'Y'
     C                             and PCurrency = *BLANK
     C                   Eval      PCurrency = PDLCcy
     C                   Eval      CcyArr(1) = PDLCcy
 
     C                   Else
 
      ** Validate Payment Currencies
 
     C                   MoveA     PCurrency     CcyArr
     C                   Exsr      SrVald
     C                   MoveA     CcyArr        PCurrency
 
     C                   EndIf
 
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
      ** (If SetDefault = 'N' no default value is provided
      **  and blank currency is blocked)
 
     C                   When      WCtr = 0
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIdArr(Idx) = '5047405'
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
 
     C                   EndIf
 
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
 
     C                   Select
     C                   When      WCtr + WCtr2 = 1
     C                   Eval      FldNameArr(Idx) = 'DDC1PC'
     C                   When      WCtr + WCtr2 = 2
     C                   Eval      FldNameArr(Idx) = 'DDC2PC'
     C                   When      WCtr + WCtr2 = 3
     C                   Eval      FldNameArr(Idx) = 'DDC3PC'
     C                   When      WCtr + WCtr2 = 4
     C                   Eval      FldNameArr(Idx) = 'DDC4PC'
     C                   When      WCtr + WCtr2 = 5
     C                   Eval      FldNameArr(Idx) = 'DDC5PC'
     C                   When      WCtr + WCtr2 = 6
     C                   Eval      FldNameArr(Idx) = 'DDC6PC'
     C                   When      WCtr + WCtr2 = 7
     C                   Eval      FldNameArr(Idx) = 'DDC7PC'
     C                   When      WCtr + WCtr2 = 8
     C                   Eval      FldNameArr(Idx) = 'DDC8PC'
     C                   When      WCtr + WCtr2 = 9
     C                   Eval      FldNameArr(Idx) = 'DDC9PC'
     C                   When      WCtr + WCtr2 = 10
     C                   Eval      FldNameArr(Idx) = 'DDC0PC'
     C                   Endsl
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
     C                   Parm                    PLCcy
     C                   Parm                    PDLCcy
     C                   Parm                    PCurrency
     C                   Parm                    PDDIPFQ
     C                   Parm                    PIKNIPD
     C                   Parm                    OkFlagDS
     C                   Parm                    MsgIdArr
     C                   Parm                    FldNameArr
     C                   Parm                    WMsgIdArr
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgDtaArr
 
     C                   CALLP     GetMidasSysVal(RtvCnvDft:
     C                                            RtnSysVal)
 
     C                   IF        RtnSysVal = '*NRF'
 
     C                   EVAL      DBPGM = PSPROCPGM
     C                   EVAL      DBKEY = RtvCnvDft
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   EVAL      SetDefault = RtnSysVal
     C                   EndIf
 
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
     C/COPY ZACPYSRC,PIGETMDSVL
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2014
