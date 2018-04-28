     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE retrieve a record')                        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger ILE Module                            *
      *                                                               *
      *  GLBITPR   - GL Batch Item retrieve a record                  *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGL135A            Date 10Jul13               *
      *  Prev Amend No. MD000091           Date 07May13               *
      *                 AR1005162          Date 16Jul12               *
      *                 CSC054             Date 23Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CAP207             Date 10Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23742           Date 09May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246418             Date 20Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CER001             Date 25Apr05               *
      *                 CSC024             Date 07Feb05               *
      *                 BG9185             Date 08Nov05               *
      *                 CMM121             Date 29Jun04               *
      *                 BUG2948            Date 03Jun04               *
      *                 BUG1175R           Date 02Jun04               *
      *                 BUG2427            Date 28May04               *
      *                 BUG2796            Date 20May04               *
      *                 BUG1175            Date 28Apr04               *
      *                 BUG711             Date 18Mar04               *
      *                 CGL029             Date 27Mar04               *
      *                 CAP084  *CREATE    Date 12Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL135A - Accounting Rules Process                           *
      *            Added hooks: CGL135_051, CGL135_052, CGL135_053    *
      *                         CGL135_079                            *
      *  MD000091 - Event Codes Substitution                          *
      *  AR1005162 - Base ccy exchange rate in corrective batch has   *
      *              incorrect number of decimal places               *
      *  CSC054 - Period End Adjustments                              *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on Inputs                             *
      *  CAP207 - Account Balance Check extended to other APIs        *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT075 Mapping error in Journal Entry                *
      *  BUG23742 - Improper handling of Ext Narr from Batch          *
      *             Interface Input                                   *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246418 - CGL013 changes for midas plus                       *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CSC024 - Open Month End (Recompile)                          *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  CMM121 - Core changes for GBO021                             *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added:GLBITPZD01,GLBITPZC02,GLBITPZC03   *
      *         - OUTPUT tag :86: - Information to Account Owners     *
      *  BUG2948 - Different branch code item accepted even if        *
      *           multiple branch indicator is set to 'N'. (recompile)*
      *  BUG1175R-Send correct user id back when batch is in use      *
      *  BUG2427- Update batch in use flag in java                    *
      *  BUG2796- If batch has been submitted for posting the let     *
      *           the user know by sending a message                  *
      *  BUG1175- If setting batch to in use also set up user & tmst  *
      *  BUG711 - Set batch in use when user brings up edit screen    *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - MidasPlus Changes                                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** JE Headers file
     F**********GLJENHL0  IF   E           K DISK    INFSR(*PSSR)                             BUG711
     F**********GLJENHL0  UF   E           K DISK    INFSR(*PSSR)                     BUG711 BUG2427
     FGLJENHL0  IF   E           K DISK    INFSR(*PSSR)                                      BUG2427
      *
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
     D WSysTmSt        S             26Z                                                     BUG1175
      ** User                                                                                BUG1175
     D LUser           S             10A                                                     BUG1175
     D TIMEtime        S               T                                                     BUG1175
     D TIMEchar        S             10A                                                     BUG1175
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------
 
     D BITPScnFmt    E DS                  EXTNAME(GLBITPPD)
      * Deal in screen format
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D BITPFilFmt    E DS                  EXTNAME(GLJENPPD)
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
      ** Deal in file format
 
      *                                                                                       CER001
      ** External DS for Bank Details                                                         CER001
      *                                                                                       CER001
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CER001
      *                                                                                       CER001
      ** First DS for Access programs - short data structure                                  CER001
      *                                                                                       CER001
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER001
      *                                                                                       CER001
     D BITPExFilFmt  E DS                  EXTNAME(GLJPX1PD)                                  CER001
     D ExtData       E DS                  EXTNAME(GLBPEXPD)                                  CER001
     D RegData       E DS                  EXTNAME(GLBPRXPD)                                  CER001
      *                                                                                       246418
      ** JE Additional Info Data for CGL013 - File format of GLJENXPD                         246418
     D BITPXFilFmt   E DS                  EXTNAME(GLJENXPD)                                  246418
      *                                                                                     BUG23742
      ** JE Additional Info Data  - File format of GLMNARPD                                 BUG23742
      *                                                                                     BUG23742
     D GLMNAR        E DS                  EXTNAME(GLMNARPD)                                BUG23742
      *                                                                                     BUG23742
      ** Additional Info Data  - File format of GLMNARPD (770)                              BUG23742
     D GLMNARSCR       DS           770                                                     BUG23742
      *                                                                                     BUG23742
      ** JE Additional Info Data for CGL013 - Screen format of GLBITPXPD                      246418
     D BITPXScnFmt   E DS                  EXTNAME(GLBITPXPD)                                 246418
      *                                                                                       246418
      ** Externally described DS for SAR details                                              246418
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  246418
      *                                                                                       CSC054
      ** Period End Adjustments Fields                                                        CSC054
     D*PEADetail       S             13A                                            CSC054 AR1005162
     D PEADetail       S             15A                                                   AR1005162
     D/COPY WNCPYSRC,GLH00653
      **-----------------------------------------------------------------------
 
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                    BUG1175
      ** Java user information                                                               BUG1175
                                                                                              CSF011
     D AccKeyDs        DS                                                                     CSF011
     D PKACID                        10                                                       CSF011
     D PKCUST                         6                                                       CSF011
     D PKCYCD                         3                                                       CSF011
     D PKACCD                        10                                                       CSF011
     D PKACSN                         2                                                       CSF011
     D PKBRCD                         3                                                       CSF011
     D PKNONB                         2                                                       CSF011
     D PKUCSN                        10                                                       CSF011
     D PKPNOI                         1                                                       CSF011
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CSF011
     D                                     PREFIX(NO_)                                        CSF011
     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                   CSF011
     D                                     PREFIX(AC_)                                        CSF011
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSF011
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
     D SGDNOSTRO       S              1                                                       CMM121
     D SBRNM           S             35                                                       CMM121
     D SBREF           S             35                                                       CMM121
     D/COPY WNCPYSRC,GLBITPZD01
 
      *                                                                                       CER001
      ** Switchable Feature Field                                                             CER001
      *                                                                                       CER001
     D ULX043          S              1                                                       CER001
      *                                                                                       CER001
      ** Parameter Field/s                                                                    CER001
      *                                                                                       CER001
     D PRetCodeIn      S             10                                                       CER001
      *                                                                                       246418
      ** Switchable feature CGL013                                                            246418
     D CGL013          S              1                                                       246418
      *                                                                                     BUG23742
      ** Switchable feature CER030                                                          BUG23742
      *                                                                                     BUG23742
     D CER030          S              1                                                     BUG23742
     D POptn           S              7                                                     BUG23742
     D PRtcd           S              7                                                     BUG23742
     D PSard           S              6                                                     BUG23742
      *                                                                                       246418
     D DDADIN          S              1                                                       246418
     D DDINBI          S              1                                                       CER059
                                                                                              CSF011
     D P@TYP           S             10                                                       CSF011
     D P0RETL          S             10                                                       CSF011
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D P@Str           S             35                                                       CSF011
      *                                                                                       246418
     D/COPY WNCPYSRC,GLH00654
     D/COPY OFCPYSRCZ,CGL135_051                                                             CGL135A
      *                                                                                     MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      *                                                                                     MD000091
      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDBTNB_In         3
     C                   PARM                    DDBINB_In         3
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      *                                                                                       CER001
      ** Access Bank details via access program                                               CER001
      ** (database error handling done in access program)                                     CER001
      *                                                                                       CER001
     C                   CALLB     'AOBANKR0'                                                 CER001
     C                   PARM      '*DBERR '     @RTCD                                        CER001
     C                   PARM      '*FIRST '     @OPTN                                        CER001
     C     SDBANK        PARM      SDBANK        DSFDY                                        CER001
      *                                                                                       CER001
     C     @RTCD         IFNE      *BLANKS                                                    CER001
     C                   MOVEL     'SDBANKPD'    DBFILE                                       CER001
     C                   Z-ADD     1             DBASE                                        CER001
     C                   MOVEL     @OPTN         DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Access SAR details to see if ULX043 is switched on.                                  CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX043                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Access SAR details file to determine if MT94x Messages Generation                    246418
      ** processing is switched ON                                                            246418
      *                                                                                       246418
     C                   EVAL      CGL013 = 'N'                                               246418
     C                   CALLB     'AOSARDR0'                                                 246418
     C                   PARM      *BLANKS       @RTCD                                        246418
     C                   PARM      '*VERIFY'     @OPTN                                        246418
     C                   PARM      'CGL013'      @SARD                                        246418
     C     SCSARD        PARM      SCSARD        DSFDY                                        246418
      *                                                                                       246418
      ** An NRF (No Record Found) return code is valid. Issue database                        246418
      ** error only for error return codes.                                                   246418
      *                                                                                       246418
     C                   IF        @RTCD <> *BLANKS AND                                       246418
     C                             @RTCD <> '*NRF   '                                         246418
     C                   EVAL      DBKEY = 'CGL013'                                           246418
     C                   EVAL      DBFILE = 'SCSARDPD'                                        246418
     C                   EVAL      DBASE = 002                                                246418
     C                   EXSR      *PSSR                                                      246418
     C                   ENDIF                                                                246418
      *                                                                                       246418
     C                   IF        @RTCD = *BLANK                                             246418
     C                   EVAL      CGL013 = 'Y'                                               246418
     C                   ENDIF                                                                246418
      *                                                                                     BUG23742
     C                   CALLB     'AOSARDR0'                                               BUG23742
     C                   PARM      *BLANKS       PRtCd                                      BUG23742
     C                   PARM      '*VERIFY'     POptn                                      BUG23742
     C                   PARM      'CER030'      PSard                                      BUG23742
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG23742
      *                                                                                     BUG23742
     C                   IF        PRtcd = *BLANKS                                          BUG23742
     C                   EVAL      CER030 = 'Y'                                             BUG23742
     C                   ELSEIF    PRtcd <> '*NRF'                                          BUG23742
      *                                                                                     BUG23742
     C     *LOCK         IN        LDA                                                      BUG23742
     C                   EVAL      DBASE = 3                                                BUG23742
     C                   EVAL      DBFile = 'AOSARDR0'                                      BUG23742
     C                   EVAL      DBKEY = '*VERIFY'                                        BUG23742
     C                   OUT       LDA                                                      BUG23742
     C                   EXSR      *PSSR                                                    BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
     C/COPY WNCPYSRC,GLBITPZC02
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'GLUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C/COPY WNCPYSRC,GLH00655
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,GLBITP02
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   BITPFilFmt
     C                   CLEAR                   DDATSN                                      CSF011A
     C                   CLEAR                   DDATNM                                      CSF011A
     C                   CLEAR                   DDATRT                                      CSF011A
     C                   CLEAR                   DDATAN                                      CSF011A
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
     C                   ENDIF
 
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
 
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      GLBITPRED
     C                   ELSE
     C                   MOVEL     DDBTNB_In     @BNRED            3
     C                   MOVEL     DDBINB_In     @INRED            3
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If header read and no error message returned
     C                   IF        ReturnCode = *BLANK and
     C                             @BNRED <> *Blank
      *
      * Retrieve transaction details
     C                   MOVEL     @BNRED        DDBTNB
     C                   MOVEL     @INRED        DDBINB
     C                   MOVEL     @FTRED        APFOTranID       20
     C                   EXSR      GLBITPRTV
      *
      ** If switchable feature is on,                                                         CER001
      **    Retrieve Outgoing Payments Extension Details                                      CER001
      *                                                                                       CER001
     C     ULX043        IFEQ      'Y'                                                        CER001
     C                   EXSR      GLBITP2RV                                                  CER001
     C                   ENDIF                                                                CER001
     C/COPY WNCPYSRC,GLH00656
      *                                                                                       CER001
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      GLBITPCVT
      *                                                                                       CER001
      ** If switchable feature is on,                                                         CER001
      **    Output Extension Data                                                             CER001
      *                                                                                       CER001
     C     ULX043        IFEQ      'Y'                                                        CER001
     C                   EXSR      GLBITP2CT                                                  CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C/COPY WNCPYSRC,GLH00657
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ReturnCode <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDBTNB'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
      *
      ** If batch header is in use then let the user know
      *
     C                   IF        ReturnCode = *BLANK
     C     DDBTNB        CHAIN     GLJENHL0                           20
     C     *IN20         IFEQ      *OFF
     C     BRBTSF        ANDNE     'S'                                                       BUG2796
     C*****BRBIUF        ANDEQ     'Y'                                                        BUG711
     C     BRBIUF        IFEQ      'Y'                                                        BUG711
     C*****BRUSRA        IFEQ      *BLANKS                                          BUG1175 BUG1175R
     C**********         Eval      LUser = BRUSRI                                   BUG1175 BUG1175R
     C**********         ELSE                                                       BUG1175 BUG1175R
     C**********         Eval      LUser = BRUSRA                                   BUG1175 BUG1175R
     C**********         ENDIF                                                      BUG1175 BUG1175R
     C                   Eval      LUser = BRWSID                                           BUG1175R
     C                   MOVEL     'DDBTNB'      FldNameArr(1)
     C**********         MOVEL     'GLX0041'     MsgIDArr(1)                                 BUG1175
     C                   MOVEL     'GLX0422'     MsgIDArr(1)                                 BUG1175
     C                   Eval      TIMEtime = %time(BRTMST)                                  BUG1175
     C                   MOVE      TIMEtime      TIMEchar                                    BUG1175
     C**********         Eval      MsgDtaArr(1) = LUser + ' @ ' + TIMEchar          BUG1175 MD000091
     C                   EVAL      MsgDtaTmp = LUser + ' @ ' + TIMEchar                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(1) = LenStr +%TRIM(MsgDtaTmp)                  MD000091
     C                   MOVE      'E'           DDDLIT
     C                   ELSE                                                                 BUG711
      *                                                                                      BUG1175
     C**********         CALLB     'ZAGENTMSTM'                                      BUG1175 BUG2427
     C**********         PARM                    WSysTmSt                            BUG1175 BUG2427
      *                                                                                      BUG1175
     C**********         Eval      BRTMST = WsysTmSt                                 BUG1175 BUG2427
     C**********         Eval      BRUSRA = USRID                                    BUG1175 BUG2427
     C**********         MOVE      'Y'           BRBIUF                               BUG711 BUG2427
     C                   MOVE      'R'           DDDLIT                                       BUG711
     C**********         UPDATE    @BRREAG                                            BUG711 BUG2427
     C                   ENDIF                                                                BUG711
      *
      * If the batch header status is 'S' then batch has been submitted.                     BUG2796
      * Make sure the user knows this.                                                       BUG2796
     C                   ELSE                                                                BUG2796
     C     BRBTSF        IFEQ      'S'                                                       BUG2796
     C                   MOVEL     'DDBTNB'      FldNameArr(1)                               BUG2796
     C                   MOVEL     'GLX0276'     MsgIDArr(1)                                 BUG2796
     C**********         Eval      MsgDtaArr(1) = BRBTNB                            BUG2796 MD000091
     C                   EVAL      BLen = %Len(%Trim(BRBTNB))                               MD000091
     C                   EVAL      MsgDtaArr(1) = LenStr +%TRIM(BRBTNB)                     MD000091
     C                   ENDIF                                                               BUG2796
     C                   ENDIF
     C                   ENDIF
      *
      ** Let the jsp know that user has pressed button from listview
      *
     C     DDDLIT        IFEQ      *BLANKS
     C                   MOVE      'L'           DDDLIT
     C                   ENDIF
 
      * If additional information is blank then set DDADIN = 'N'                              246418
     C                   IF        CGL013 = 'Y'                                               246418
     C                   IF        DDADI1 = *blanks                                           246418
     C                             and DDADI2 = *blanks                                       246418
     C                             and DDADI3 = *blanks                                       246418
     C                             and DDADI4 = *blanks                                       246418
     C                             and DDADI5 = *blanks                                       246418
     C                             and DDADI6 = *blanks                                       246418
     C                   EVAL      DDADIN = 'N'                                               246418
     C                   ELSE                                                                 246418
     C                   EVAL      DDADIN = 'Y'                                               246418
     C                   ENDIF                                                                246418
     C                   ENDIF                                                                246418
                                                                                              246418
      *                                                                                     BUG23742
      ** If additional information is blank then set DDADIN = 'N'                           BUG23742
      *                                                                                     BUG23742
     C                   IF        CER030 = 'Y'                                             BUG23742
      *                                                                                     BUG23742
     C                   IF        DDADI1 = *BLANKS AND                                     BUG23742
     C                             DDADI2 = *BLANKS AND                                     BUG23742
     C                             DDADI3 = *BLANKS AND                                     BUG23742
     C                             DDADI4 = *BLANKS AND                                     BUG23742
     C                             DDADI5 = *BLANKS AND                                     BUG23742
     C                             DDADI6 = *BLANKS AND                                     BUG23742
     C                             GLMNAR = *BLANKS                                         BUG23742
     C                   EVAL      DDADIN = 'N'                                             BUG23742
     C                   ELSE                                                               BUG23742
     C                   EVAL      DDADIN = 'Y'                                             BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   EVAL      GLMNARSCR = %SUBST(GLMNAR:9)                             BUG23742
                                                                                              CSF011
      ** Populate Customer Name On Inputs fields                                              CSF011
                                                                                              CSF011
     C                   EXSR      SrCustActN                                                 CSF011
                                                                                              CSF011
      * Build buffer with required output
     C                   EVAL                    Buffer = BITPScnFmt
     C                                           + SGDNOSTRO + SBRNM                          CMM121
     C                                           + SBREF                                      CMM121
     C**********                                 + DDADIN + BITPXScnFmt                246418 CER059
     C                                           + DDADIN + DDINBI                            CER059
     C                                           + BITPXScnFmt                                CER059
     C                                           + GLMNARSCR                                BUG23742
     C                                           + PEADetail                                  CSC054
      /COPY OFCPYSRCZ,CGL135_079                                                             CGL135A
     C                                           + RegData                                    CER001
     C                                           + ExtData                                    CER001
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     GLBITPRED     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'GLBITPRED'
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * Batch Number
     C                   PARM      DDBTNB_In     DDBTNB            3
      *
      * Batch Item Number
     C                   PARM      DDBINB_In     DDBINB            3
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * Batch Number Read
     C                   PARM      *BLANK        @BNRED            3
      *
      * Batch Item Read
     C                   PARM      *BLANK        @INRED            3
      *
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
 
     C                   ENDSR
      **********************************************************************
     C     GLBITPRTV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'GLBITPRTV'
 
      * INPUTS
 
      * Return code
     C                   PARM                    ReturnCode
 
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP013
     C                   PARM                    ModeofOp          6            CAP013
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE        1
 
      * Action Code
     C                   PARM                    DDACTN            1
 
      * Action Code
     C                   PARM                    APFOTranID       20
 
      * Batch Header Number
     C                   PARM                    DDBTNB
 
      * Batch Item Number
     C                   PARM                    DDBINB
      *                                                                                     BUG23742
      ** CER030 feature                                                                     BUG23742
      *                                                                                     BUG23742
     C                   PARM                    CER030                                     BUG23742
 
      * OUTPUTS
 
      * (Current) deal in file format
     C                   PARM                    BITPFilFmt
 
      * (Current) Additional Infor in File Format                                             246418
     C                   PARM                    BITPXFilFmt                                  246418
      *                                                                                     BUG23742
      ** MultiCash Narratives - File Format                                                 BUG23742
      *                                                                                     BUG23742
     C                   PARM                    GLMNAR                                     BUG23742
                                                                                              246418
      * OK - Action code
     C                   PARM                    DDActnOK          1
 
      * OK - Batch Number
     C                   PARM                    DDBtnbBK          1
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** MT94x Messages Generation                                                            246418
     C                   PARM                    CGL013                                       246418
     C/COPY WNCPYSRC,GLBITPZC03
     C/COPY OFCPYSRCZ,CGL135_052                                                             CGL135A
 
 
     C                   ENDSR
      **********************************************************************                  CER001
      * Retrieve Outgoing Payments Extension Details                                          CER001
      **********************************************************************                  CER001
     C     GLBITP2RV     BEGSR                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'GLBITP2RV'                                                CER001
     C                   PARM      *BLANKS       PRetCodeIn                                   CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    APFOTranID                                   CER001
     C                   PARM                    DDBTNB                                       CER001
     C                   PARM                    DDBINB                                       CER001
     C                   PARM                    BITPExFilFmt                                 CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      **********************************************************************
     C     GLBITPCVT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'GLBITPCVT'
 
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    BITPFilFmt
      * (Current) item additional informatino in file format                                  246418
     C                   PARM                    BITPXFilFmt                                  246418
      ** MT94x Messages Generation                                                            246418
     C                   PARM                    CGL013                                       246418
 
      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    BITPScnfmt
 
      * (Current) Item Additional Information in screen format                                246418
     C                   PARM                    BITPXScnFmt                                  246418
                                                                                              246418
     C/COPY OFCPYSRCZ,CGL135_053                                                             CGL135A
      ** AMEND CHECKING
     C                   RESET                   ReturnCode
 
     C                   ENDSR
      **********************************************************************                  CER001
      * Output Extension Data                                                                 CER001
      **********************************************************************                  CER001
     C     GLBITP2CT     BEGSR                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'GLBITP2CT'                                                CER001
     C                   PARM      *BLANKS       PRetCodeIn                                   CER001
     C                   PARM                    BJDFIN                                       CER001
     C                   PARM                    BJCYCD                                       CER001
     C                   PARM                    BITPExFilFmt                                 CER001
     C                   PARM                    RegData                                      CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustActN - Get the Customer or Account Details              *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustActN    BEGSR                                                                CSF011
                                                                                              CSF011
      ** Determine type of account                                                            CSF011
                                                                                              CSF011
     C                   CALL      'AOACCTV1'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      *BLANKS       P@TYP                                        CSF011
     C                   PARM      DDACID        P@Str                                        CSF011
     C                   PARM                    DSSDY                                        CSF011
                                                                                              CSF011
     C                   SELECT                                                               CSF011
                                                                                              CSF011
      ** Retail Account, save Customer number. Move account name detail.                      CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*RETAIL'                                          CSF011
     C                   EVAL      ACCNT = DSSDY                                              CSF011
     C                   EVAL      WCustomer = AC_CNUM                                        CSF011
     C                   EVAL      DDATAN    = AC_ANAM                                       CSF011A
                                                                                              CSF011
      ** Nostro, save Customer number. Call Access object for account                         CSF011
      ** details                                                                              CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*NOSTRO'                                          CSF011
     C                   EVAL      SDNOST = DSSDY                                             CSF011
     C                   EVAL      WCustomer = NO_A7CUST                                      CSF011
     C                   CLEAR                   AccKeyDs                                     CSF011
     C                   MOVEL     NO_A7CUST     PKCUST                                       CSF011
     C                   MOVEL     NO_A7CYCD     PKCYCD                                       CSF011
     C                   MOVEL     NO_A7ACCD     PKACCD                                       CSF011
     C                   MOVEL     NO_A7ACSN     PKACSN                                       CSF011
     C                   MOVEL     NO_A7BRCD     PKBRCD                                       CSF011
     C                   EXSR      SRActDtls                                                  CSF011
                                                                                              CSF011
      ** Customer Number, save shortname, report name and town.                               CSF011
      ** Call access object for account details                                               CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*CUSTNO' OR                                       CSF011
     C                             P@TYP = '*SHNAME'                                          CSF011
     C                   EVAL      SDCUST = DSSDY                                             CSF011
     C                   EVAL      DDATSN = BBCSSN                                           CSF011A
     C                   EVAL      DDATNM = BBCRNM                                           CSF011A
     C                   EVAL      DDATRT = BBCRTN                                           CSF011A
     C                   EVAL      WCustomer = *BLANKS                                        CSF011
     C                   CLEAR                   AccKeyDs                                     CSF011
     C                   MOVEL     DDACID        PKCUST                                       CSF011
     C                   MOVEL     DDCYCD        PKCYCD                                       CSF011
     C                   MOVEL     DDACCD        PKACCD                                       CSF011
     C                   MOVEL     DDACSN        PKACSN                                       CSF011
     C                   MOVEL     DDIBCA        PKBRCD                                       CSF011
     C                   EXSR      SRActDtls                                                  CSF011
                                                                                              CSF011
     C                   ENDSL                                                                CSF011
                                                                                              CSF011
      ** Call access object for customer details                                              CSF011
                                                                                              CSF011
     C                   IF         WCustomer <> *BLANKS                                      CSF011
     C                   CALL      'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY'        @OPTN                                        CSF011
     C                   PARM                    WCustomer                                    CSF011
     C                   PARM      *BLANKS       C#KYST                                       CSF011
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
                                                                                              CSF011
     C                   IF        @RTCD = *BLANKS                                            CSF011
     C                   EVAL      DDATSN = BBCSSN                                           CSF011A
     C                   EVAL      DDATNM = BBCRNM                                           CSF011A
     C                   EVAL      DDATRT = BBCRTN                                           CSF011A
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   ENDIF                                                                CSF011
     C                                                                                        CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      *  SRActDtls - Call access object for Account details           *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
                                                                                              CSF011
     C     SRActDtls     BEGSR                                                                CSF011
                                                                                              CSF011
     C                   CALLB     'AOACCTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY   '     POPTN                                        CSF011
     C                   PARM                    PKACID                                       CSF011
     C                   PARM                    PKCUST                                       CSF011
     C                   PARM                    PKCYCD                                       CSF011
     C                   PARM                    PKACCD                                       CSF011
     C                   PARM                    PKACSN                                       CSF011
     C                   PARM                    PKBRCD                                       CSF011
     C     ACCNT         PARM      ACCNT         DSSDY                                        CSF011
                                                                                              CSF011
     C                   IF        @RTCD = *BLANKS                                            CSF011
     C                   EVAL      DDATAN = AC_ANAM                                          CSF011A
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      **********************************************************************
      /EJECT
      **********************************************************************
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
     C/COPY WNCPYSRC,GLH00658
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
