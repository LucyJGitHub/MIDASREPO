     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate 102 prior to authorisation')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1026VL - Validate prior to authorise.                     *
      *                                                               *
      *  Function: This Program Validates FT MT102 Records for        *
      *            input to the Midas database.                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      *                 221538             Date 16Jan04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185935             Date 06Nov00               *
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 17Sep99               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - SWIFT 2007 Changes (Recompiled)                     *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  221538 - Expansion of field details.                         *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  CFT009 - Addition of fields for FT fees and charges          *
      *           Recompile                                           *
      *  185935 - Remove blanking if Update User Profile              *
      *  185107 - Mapping of details from swift message               *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT006 - Swift Messages MT101/MT102                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFT102DL0  IF   E           K Disk    PREFIX(D)
 
     FFT102HL3  IF   E           K DISK    Prefix(H)
 
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
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D OKHdrFlg1     E DS                  EXTNAME(FTE102H1PD)
     D OKHdrFlg2     E DS                  EXTNAME(FTE102H2PD)
 
     D OKDtl1Flg     E DS                  EXTNAME(FTE102S1PD)
     D OKDtl2Flg     E DS                  EXTNAME(FTE102S2PD)
 
      * Warnings to display
     D WrnToDsp        S              1
      ** Index of error message Id arrays
     D IdxErr1         S              3P 0
     D IdxErr2         S                   LIKE(IdxErr1)
 
      ** Index of warning message Id arrays
     D IdxWrn1         S              3P 0
     D IdxWrn2         S                   LIKE(IdxWrn1)
     D FldNmArr1       S                   LIKE(FldNameArr) DIM(ArrayMax)
     D MsgIdArr1       S                   LIKE(MsgIdArr)   DIM(ArrayMax)
     D MsgDtArr1       S                   LIKE(MsgDtaArr)  DIM(ArrayMax)
     D FldNmArr2       S                   LIKE(FldNameArr) DIM(ArrayMax)
     D MsgIdArr2       S                   LIKE(MsgIdArr)   DIM(ArrayMax)
     D MsgDtArr2       S                   LIKE(MsgDtaArr)  DIM(ArrayMax)
     D WFldNmArr1      S                   LIKE(WFldNamArr) DIM(ArrayMax)
     D WMsgIdArr1      S                   LIKE(WMsgIdArr)  DIM(ArrayMax)
     D WMsgDtArr1      S                   LIKE(WMsgDtaArr) DIM(ArrayMax)
     D WFldNmArr2      S                   LIKE(WFldNamArr) DIM(ArrayMax)
     D WMsgIdArr2      S                   LIKE(WMsgIdArr)  DIM(ArrayMax)
     D WMsgDtArr2      S                   LIKE(WMsgDtaArr) DIM(ArrayMax)
 
      * Reinitialise the program
     D Reinit          S              1
     D CurScreen       DS
     D ScreenCur                      2  0
 
      * Header record datastructure(s)
     D HdrFile       E DS                  EXTNAME(FT102HPD)
      **
     D DtlFile       E DS                  EXTNAME(FT102DPD) PREFIX(D)
 
     D HdrScn        E DS                  EXTNAME(FT102HSPD)
     D  PBRCA_R      E                     EXTFLD(PBRCA)
      *
      * Detail record in screen format
     D DtlScn        E DS                  EXTNAME(FT102DSPD) PREFIX(D)
 
      ** External data structure for Bank details ICD file
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Funds Transfer ICD
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D/COPY FTCPYSRC,FT0010D001
 
     D/COPY MECPYSRC,ME1100_ILE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D Count           S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
     D #I              S              2  0
 
     D TotalAmt        S             15  0
     D CnvTyp          S              2
     D ValErrCde       S             10
     D RtnCodeIn       S             10
     D RespMode        S              1
 
      ** Work field for % rate discrepancy
     D WBtpcrd         S              5  2
 
      ** Message reference                                                      185107
     D MgmsgR          S                   LIKE(PhmsgR)                         185107
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   Clear                   DtlScn
     C                   Clear                   DtlFile
 
     C                   Eval      IdxErr1  = *Zeros
     C                   Eval      IdxErr2  = *Zeros
     C                   Eval      Idx      = *Zeros
     C                   Eval      WIdx     = *Zeros
     C                   Eval      Count    = *Zeros
 
     C                   Eval      ValErrCde = *Blanks
     C                   Eval      Totalamt = *Zeros
 
     C                   CallB     'FTM1021CT'
     C                   Parm                    RetCodeIn
     C                   PARM                    ActionCode                                   221538
     C                   Parm      *Blanks       PDATA
     C                   Parm      *Blanks       PDAT2                                        CSW209
     C                   Parm      0             MGMSGR                         185107
     C                   PARM      'SH'          CnvTyp
     C                   Parm                    HdrFile
     C                   Parm                    HdrScn
 
     C                   CallB     'FTM1028VL'   HdrList1
     C                   If        Idx = *Zeros
 
     C                   CallB     'FTM1027VL'   HdrList2
     C                   If        Idx = *Zeros
 
     C     PcctId        SETLL     FT102HL3
     C     PcctId        CHAIN     FT102HL3                           99
     C                   IF        *In99 = *Off
 
     C     PCCTID        Setll     FT102DL0
     C     PCCTID        Reade     FT102DL0                               99
     C                   DoW       *IN99 = *OFF
 
     C                   Eval      Count = Count + 1
     C                   Eval      InUser = *Blanks
     C*******************Eval      UpdUsr = *Blanks                             185935
     C                   Eval      PUpdUsr = *Blanks                            185935
 
     C                   Eval      DPCCTID = CCTID
 
     C                   CallB     'FTM1022CT'
     C                   Parm                    RetCodeIn
     C                   Parm                    ActionCode                                   221538
     C                   Parm      *blanks       PHEAD
     C                   Parm      *blanks       Pdata
     C                   Parm      *blanks       Pdat2                                        CSW209
     C                   Parm      'SC'          CnvTyp
     C                   Parm                    CCTTYP
     C                   Parm                    FilRef
     C                   Parm                    DtlFile
     C                   Parm                    DtlScn
 
     C                   CallB     'FTM1023VL'   CvalList
     C                   If        Idx <> *Zeros
     C                   Leave
     C                   Endif
 
     C                   CallB     'FTM1024VL'   CvalList
     C                   If        Idx <> *Zeros
     C                   Leave
     C                   Endif
 
      ** Total transaction amounts in base ccy
     C                   Exsr      @SumAmt
      *
 
     C     PCCTID        Reade     FT102DL0                               99
     C                   Enddo
     C                   Endif
     C                   Endif
     C                   Endif
 
      *
     C                   If        Idx   >  0 OR
     C                             Count <= 0
     C                   Eval      ValErrCde = '*VALERROR'
     C                   Return
     C                   Endif
 
     C                   If        Totalamt > BTAUDT
     C                   Eval      ValErrCde = '*DUALAUTH'
     C                   Endif
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * @SumAmt - Sum details amounts in base currency                *
      *****************************************************************
      *
     C     @SumAmt       Begsr
      *
     C                   MOVEL     *Blanks       P#NDCY
     C                   Z-ADD     *Zeros        P#NDAM
     C                   MOVEL     DCCTCCY       P#FRCY
     C                   Z-ADD     DCCTAMT       P#FRAM
     C                   Z-ADD     BJRDNB        P#FRDT
     C                   MOVEL     BJCYCD        P#TOCY
     C                   Z-ADD     *Zeros        P#TOAM
     C                   Z-ADD     *Zeros        P#TODT
     C                   MOVEL     'N'           P#OVRT
     C                   Z-ADD     *Zeros        P#PDAM
     C                   Z-ADD     *Zeros        P#RATE
     C                   Z-ADD     WBTpcrd       P#RTDS
     C                   MOVEL     'Y'           P#SDIN
      *
     C                   CALLB     'FT0010'
     C                   Parm                    P#0010
      *
     C                   IF        HCCtCHg = 'OUR' OR DCcyChg = 'OUR'
     C                   Eval      Totalamt = TotalAmt + P#TOAM
     C                   ENDIF
 
      *
     C                   Endsr
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    ValErrCde
     C                   PARM                    ActionCode
     C                   PARM                    HdrFile
     C                   PARM                    DtlFile
 
 
     C     HdrList1      PLIST
     C                   PARM                    RtnCodeIn
     C                   PARM                    RespMode
     C                   PARM                    ActionCode
     C                   PARM                    HdrScn
     C                   PARM                    DtlScn
     C                   PARM                    OkHdrFlg1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
 
     C     HdrList2      PLIST
     C                   PARM                    RtnCodeIn
     C                   PARM                    RespMode
     C                   PARM                    ActionCode
     C                   PARM                    HdrScn
     C                   PARM                    OkHdrFlg2
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
 
     C     CvalList      PLIST
 
     C                   PARM                    RtnCodeIn        10
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode        1
     C                   PARM                    HdrScn
     C                   PARM                    DtlScn
     C                   PARM                    OkDtl1Flg
     C                   PARM                    OkDtl2Flg
     C                   PARM                    OkHdrFlg1
     C                   PARM                    OkHdrFlg2
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
 
      * Get Base Currency
     C                   CallB     'AOBANKR0'
     C                   PARM                    @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C                   PARM      '*Blanks'     SDBANK
 
     C     @RTCD         Ifne      *Blanks
     C                   Eval      DBFile = 'SDBANKPD'
     C                   Eval      DBKey = '*VERIFY'
     C                   Eval      DBPgm = 'FTM102SIN'
     C                   Eval      Dbase = 1
     C                   Eval      DBMod = 'FTM1026VL'
     C                   Eval      DBProc = 'Main'
     C                   Exsr      *PSSR
     C                   Endif
 
      ** Access object for FT ICD
     C                   CALL      'AOFTFRR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDFTFR        PARM      SDFTFR        DSFDY
      *
      * Database error
     C     @RTCD         IFNE      *Blanks
     C                   Eval      DBFile = 'SDFTFRPD'
     C                   Eval      DBKey = '*VERIFY'
     C                   Eval      DBPgm = 'FTM102SIN'
     C                   Eval      Dbase = 2
     C                   Eval      DBMod = 'FTM1026VL'
     C                   Eval      DBProc = 'Main'
     C                   Exsr      *PSSR
     C                   ELSE
     C                   EVAL      WBtPcRd = BtPcRd / 100
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2001
