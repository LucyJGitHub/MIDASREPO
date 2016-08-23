     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate 101 prior to authorisation')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1016VL - Validate prior to authorise.                     *
      *                                                               *
      *  Function: This Program Validates FT MT101 Records for        *
      *            input to the Midas database.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BUG24998           Date 17Jul09               *
      *  Prev Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10602           Date 16Feb06               *
      *                 221761             Date 01Apr04               *
      *                 221538             Date 01Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *  Prev Amend No. 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 17Sep99               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  221538 - Expansion of field details.                         *
      *  CFT009 - Addition of fields for FT fees and charges          *
      *           Recompile                                           *
      *  185107 - Mapping of details from swift message               *
      *  CFT006 - Swift Messages MT101/MT102                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFT101DL0  IF   E           K Disk
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
 
     D OKHdrFlg      E DS                  EXTNAME(FTE101HPD)
     D OKDtl1Flg     E DS                  EXTNAME(FTE101S1PD)
     D OKDtl2Flg     E DS                  EXTNAME(FTE101S2PD)
     D OKDtl3Flg     E DS                  EXTNAME(FTE101S3PD)
 
      * Header record datastructure(s)
     D FileRcd       E DS                  EXTNAME(FT101HPD)
     D HdrScreen     E DS                  EXTNAME(FT101HSPD)
     D  PBRCA_R      E                     EXTFLD(PBRCA)
      * Detail record in screen format
     D DtlScn1       E DS                  EXTNAME(FT101DSPD)
     D  PSNDREF_R    E                     EXTFLD(PSNDREF)
     D DtlRcd        E DS                  EXTNAME(FT101DPD)
     D  PRFTID_R     E                     EXTFLD(RFTID)
     D  INUSER_R     E                     EXTFLD(INUSER)
     D  INDATE_R     E                     EXTFLD(INDATE)
     D  INTIME_R     E                     EXTFLD(INTIME)
     D  UPDUSR_R     E                     EXTFLD(UPDUSR)
     D  UPDDTE_R     E                     EXTFLD(UPDDTE)
     D  UPDTIM_R     E                     EXTFLD(UPDTIM)
 
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
 
     DTotalAmt         S                   Like(PAYAMT)
     DCnvTyp           S              2
     DValErrCde        S             10
     DRtnCodeIn        S              7
     DRespMode         S              1
 
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
 
 
     C                   Clear                   DtlScn1
     C                   Clear                   DtlRcd
 
     C                   Eval      Idx   = *Zeros
     C                   Eval      WIdx  = *Zeros
     C                   Eval      Count = *Zeros
 
     C                   Eval      ValErrCde = *Blanks
     C                   Eval      TotalAmt = *Zeros
 
     C                   CallB     'FTM1011CT'
     C                   Parm                    RetCodeIn
     C                   Parm                    ActionCode                                   221538
     C                   PARM      'SH'          CnvTyp
     C                   Parm                    FileRcd
     C                   Parm      *Blanks       PDATA
     C                   PARM      *BLANKS       PDAT2                                        CSW209
     C                   Parm      0             MGMSGR                         185107
     C                   Parm                    HdrScreen
 
     C                   CallB     'FTM1011VL'   HdrList
     C                   If        Idx = *Zeros
 
     C     PRftId        Setll     FT101DL0
     C     PRftId        Reade     FT101DL0                               99
     C                   DoW       *IN99 = *OFF
 
     C                   Eval      Count = Count + 1
     C                   Eval      InUser = *Blanks
     C                   Eval      UpdUsr = *Blanks
 
     C                   Eval      PRFTID_R = RftId
     C                   Eval      INUSER_R = Inuser
     C                   Eval      INDATE_R = Indate
     C                   Eval      UPDUSR_R = Updusr
     C                   Eval      UPDDTE_R = Upddte
     C                   Eval      UPDTIM_R = Updtim
 
     C                   CallB     'FTM1012CT'
     C                   Parm                    RetCodeIn
     C                   Parm                    ActionCode                                   221538
     C                   Parm      'SC'          CnvTyp
     C                   Parm                    DtlRcd
     C                   Parm      *Blanks       PHEAD
     C                   Parm      *BLANK        PDATA
     C                   PARM      *BLANK        PDAT2                                        CSW209
     C                   Parm                    DtlScn1
 
     C                   CallB     'FTM1013VL'   Scn1List
     C                   If        Idx <> *Zeros
     C                   Leave
     C                   Endif
 
     C                   CallB     'FTM1014VL'   Scn2List
     C                   If        Idx <> *Zeros
     C                   Leave
     C                   Endif
 
     C                   CallB     'FTM1015VL'   Scn3List
     C                   If        Idx <> *Zeros
     C                   Leave
     C                   Endif
 
      * Sum transaction amounts in base ccy
     C                   Exsr      @SumAmt
 
     C     PRftId        Reade     FT101DL0                               99
     C                   Enddo
     C                   Endif
 
      *
     C                   If        Idx   >  0 OR
     C                             Count <= 0
     C                   Eval      ValErrCde = '*VALERROR'
     C                   Return
     C                   Endif
 
     C                   If        TotalAmt > BTAUDT
     C                   Eval      ValErrCde = '*DUALAUTH'
     C                   Endif
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * @SumAmt - Sum details amounts in base currency                *
      *****************************************************************
     C     @SumAmt       Begsr
 
     C                   MOVEL     *Blanks       P#NDCY
     C                   Z-ADD     *Zeros        P#NDAM
     C                   MOVEL     TRNCCY        P#FRCY
     C                   Z-ADD     TRNAMT        P#FRAM
     C                   Z-ADD     BJRDNB        P#FRDT
      * Should give transfer amount out in base currency (not in pay)
     C                   MOVEL     BJCYCD        P#TOCY
     C                   Z-ADD     *Zeros        P#TOAM
     C                   Z-ADD     *Zeros        P#TODT
     C                   MOVEL     'N'           P#OVRT
     C                   Z-ADD     *Zeros        P#PDAM
     C                   Z-ADD     *Zeros        P#RATE
     C                   Z-ADD     Wbtpcrd       P#RTDS
     C                   MOVEL     'Y'           P#SDIN
      *
     C                   CALLB     'FT0010'
     C                   Parm                    P#0010
 
     C                   Eval      TotalAmt = TotalAmt + P#TOAM
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    ValErrCde
     C                   PARM                    ActionCode
     C                   PARM                    FileRcd
 
 
     C     HdrList       PLIST
     C                   PARM                    RtnCodeIn
     C                   PARM                    RespMode
     C                   PARM                    ActionCode
     C                   PARM                    HdrScreen
     C                   PARM                    OkHdrFlg
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
 
     C     Scn1List      PLIST
     C                   PARM                    RtnCodeIn
     C                   PARM                    RespMode
     C                   PARM                    ActionCode
     C                   PARM                    HdrScreen
     C                   PARM                    DtlScn1
     C                   PARM                    OKDtl1Flg
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
 
     C     Scn2List      PLIST
     C                   PARM                    RtnCodeIn
     C                   PARM                    RespMode
     C                   PARM                    ActionCode
     C                   PARM                    HdrScreen
     C                   PARM                    DtlScn1
     C                   PARM                    OKDtl2Flg
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
 
     C     Scn3List      PLIST
     C                   PARM                    RtnCodeIn
     C                   PARM                    RespMode
     C                   PARM                    ActionCode
     C                   PARM                    HdrScreen
     C                   PARM                    DtlScn1
     C                   PARM                    OKDtl3Flg
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
     C                   Eval      DBPgm = 'FTM101SIN'
     C                   Eval      Dbase = 1
     C                   Eval      DBMod = 'FTM1016VL'
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
     C                   Eval      DBPgm = 'FTM101SIN'
     C                   Eval      Dbase = 2
     C                   Eval      DBMod = 'FTM1016VL'
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
(c) Misys International Banking Systems Ltd. 2001
