     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP ordering customer')               *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIORCS - Validate Ordering Customer                        *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. AR924684           Date 10Nov14               *
      *  Prev Amend No. MD023389           Date 13Nov13               *
      *                 MD000091           Date 06May13               *
      *                 MD019874           Date 24Apr13               *
      *                 259953A            Date 23Jan13               *
      *                 259953             Date 23Jan13               *
      *                 CFT148             Date 23Jan13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25973           Date 17Sep09               *
      *                 BUG24977           Date 15Jul09               *
      *                 BUG24909           Date 15Jul09               *
      *                 BUG24494           Date 23Jun09               *
      *                 BUG25095           Date 22Jul09               *
      *                 BUG24654           Date 30Jul09               *
      *                 257144             Date 10Oct08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG20741           Date 11Sep08               *
      *                 256564             Date 17Sep08               *
      *                 256617             Date 19Sep08               *
      *                 254945             Date 17Jun08               *
      *                 CPK028             Date 29Jan08               *
      *                 BUG15193           Date 31Oct07               *
      *                 BUG15192           Date 31Oct07               *
      *                 BUG15121           Date 24Oct07               *
      *                 BUG15081           Date 23Oct07               *
      *                 BUG15065           Date 20Oct07               *
      *                 BUG15045           Date 19Oct07               *
      *                 BUG15037           Date 16Oct07               *
      *                 BUG15029           Date 16Oct07               *
      *                 250804A            Date 11Oct07               *
      *                 250600             Date 30Sep07               *
      *                 BUG14881           Date 19Sep07               *
      *                 BUG14856           Date 14Sep07               *
      *                 BUG14593           Date 12Aug07               *
      *                 CSW207A            Date 06Aug07               *
      *                 CSW207             Date 17Jun07               *
      *                 BUG13025           Date 10Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 223728             Date 06Jun06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR924684 - Text following account is wrongly validated as a  *
      *             BIC. (Child: AR924685)                            *
      *  MD023389 - No Error Description for invalid SWIFT in         *
      *             Ordering Customer field.                          *
      *  MD000091 - Event Codes Substitution                          *
      *  MD019874 - Response with '&' causes exception error in       *
      *             Benchmarking                                      *
      *  259953A- CFT148 : Remove IBAN validation for 50F and for     *
      *           Core set ORCT value in case of Warning message      *
      *           Added hooks: CFT148_020, CFT148_021                 *
      *  259953 - CFT148 : FT Cannot view IPAY on enquiry screen      *
      *           Amended hook: CFT148_023 (Recompile)                *
      *  CFT148 - FT Remove Validation on Field 50F                   *
      *           Added hooks: CFT148_023, CFT148_022                 *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  BUG25973 - When Ordering Customer L1 is equal to valid IBAN  *
      *             without slash followed by 1/, 6/, 6/ the system   *
      *             accepts the transaction                           *
      *  BUG24977 - Only 1 error should be displayed                  *
      *             partially applied BUG24871                        *
      *  BUG24909 - Incorrect error message was displayed when        *
      *             Incoming payments ordering customer was keyed-in. *
      *  BUG24494 - Ordering Customer: Address line starts with "/"   *
      *             but not second line entered.                      *
      *  BUG25095 - Error in ordering customer                        *
      *  BUG24654 - Warning message 'Format not configured for        *
      *             Ordering Customer' is inconsistent.               *
      *  257144 - Include lower case in ISO validation.               *
      *           Use new /COPY member SFTVALCSLL.                    *
      *  BUG20741 - After authorising transaction the system blanks   *
      *             Ordering Customer fields.                         *
      *             Applied as 254945                                 *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  256617 - Applied fix 253427.                                 *
      *           Enhance BUG15193 such that Ordering Customer will   *
      *           be validated accordingly.                           *
      *  254945 - FT Incoming on authorization screen missed          *
      *           ordering customer                                   *
      *  CPK028 - Conversion of Customer Number to Alpha.             *
      *  BUG15193 - Wrong ordering customer type when ordering        *
      *             customer line 2 contains a valid SWIFT ID         *
      *  BUG15192 - Incorrect Error message during input of full      *
      *             address.                                          *
      *  BUG15121 - Validation error in address is being displayed    *
      *             for a valid 50F format.                           *
      *  BUG15081 - Customer swift ID as ordering customer become     *
      *             blank after completion.                           *
      *  BUG15065 - Error in validation of OPAY                       *
      *  BUG15045 - System does not accept an External account input  *
      *             in Ordering customer field                        *
      *  BUG15037 - Error message should be a warning                 *
      *  BUG15029 - Warning message displayed was "ERROR - Message    *
      *             not found                                         *
      *  250804A - Fix various CFT032/CSW207 Errors                   *
      *  250600 - Fix to CFT032                                       *
      *  BUG14881 - Retail Number is used for Ordering Customer:      *
      *             Error:  50F format is invalid and                 *
      *  BUG14856 - Missing/blank data is allowed in                  *
      *             "Ordering Customer" format                        *
      *  BUG14593 - SWIFT 2007 error in SP08                          *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  BUG13025 - Ordering customer is removed after authorisation  *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  223728 - Warning Message should not keep the user from       *
      *           inserting the transaction. Use correct error arrays.*
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Payments Lvl 1 1/2 Scrn details from incoming transaction
      ** - screen format
     D NwIP2ScnFmt   E DS                  EXTNAME(FTIPY2PD)
     D NwIP3ScnFmt   E DS                  EXTNAME(FTIPY3PD)                                  CFT032
      *
     D WCNUM           S              6A                                                     CSW207A
     D WACOD           S             10A                                                     CSW207A
     D WACSQ           S              2A                                                     CSW207A
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments Lvl 2 Scrn error indicators
     D FTEIPY2       E DS                  EXTNAME(FTEIPY2PD)
      *
      ** Used for SWIFT validation
     D ADLINE          S              1
     D ADSLON          S              1
     D ##CSID          S              1
      *
     **COPY*FTCPYSRC,SFTVALCSLE                                                               257144
      /COPY FTCPYSRC,SFTVALCSLL                                                               257144
      *
      /COPY FTCPYSRC,SFTADDRILE
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Complete Ordering Bank
     D WDORC           DS           175
     D   WDORC1                1     35
     D   WDORC2               36     70
     D   WDORC3               71    105
     D   WDORC4              106    140
     D   WDORC5              141    175                                                       CFT032
                                                                                              CFT032
     D Alpha           S              1    DIM(26) CTDATA PERRCD(26)                          CFT032
     D Numeric         S              1    DIM(10) CTDATA PERRCD(10)                          CFT032
     D CFT004          S              1                                                       CFT032
     D PRTCD           S              7                                                       CFT032
     D POPTN           S              7                                                       CFT032
     D PSARD           S              6                                                       CFT032
     D IBCHK1          S              1                                                       CFT032
     D IBCHK2          S              1                                                       CFT032
     D IBCTY1          S              1                                                       CFT032
     D IBCTY2          S              1                                                       CFT032
     D WIx             S              3P 0                                                    CFT032
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)                      CFT032
     D                                                                                        CSW207
      * Swift 2007 Validation Program parameters                                              CSW207
     D PAccount        S             34A                                                      CSW207
     D PAcType         S              1A                                                      CSW207
     D PCust           S              6A                                                      CSW207
     D*WCustomer       S              6S 0                                             250600 CPK028
     D WCustomer       S              6A                                                      CPK028
     D PNonActH        S             10A                                                      CSW207
     D PNetwork        S              6A                                                      CSW207
     D PMsgTyp         S              3A                                                      CSW207
     D PMsgTag         S              5A                                                      CSW207
     D PBrch           S              3A                                                      CSW207
     D PCountry        S              2A                                                      CSW207
     D PCurr           S              3A                                                      CSW207
     D PNostro         S              2A                                                      CSW207
     D P50FmtF1        S             35A                                                      CSW207
     D P50FmtF2        S             35A                                                      CSW207
     D P50FmtF3        S             35A                                                      CSW207
     D P50FmtF4        S             35A                                                      CSW207
     D P50FmtF5        S             35A                                                      CSW207
     D PVType          S              4A                                                      CSW207
     D PMsgID          S              7A                                                      CSW207
     D PErtp           S              1A                                                      CSW207
     D CSW207          S              1A                                                      CSW207
     D PModI           S              2A                                                      CSW207
     D POut1           S             35A                                                      CSW207
     D POut2           S             35A                                                      CSW207
     D POut3           S             35A                                                      CSW207
     D POut4           S             35A                                                      CSW207
     D POut5           S             35A                                                      CSW207
                                                                                              CFT032
      ** DS for Access Objects - short data structure                                         CFT032
                                                                                              CFT032
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CFT032
                                                                                              CFT032
      ** Externally described DS for SAR details                                              CFT032
                                                                                              CFT032
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT032
      *
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Data structure for Nostro details                                                    250600
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  250600
                                                                                              250600
      ** Externally described DS for Counterparty Nostros
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      ** Externally described DS for BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      *
      ** DS for Access Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      *  External Data structure to hold the outgoing record format                          CSW207A
     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                  CSW207A
     D   ACBRCA      E                     EXTFLD(BRCA)                                      CSW207A
     D   ACPRFC      E                     EXTFLD(PRFC)                                      CSW207A
     D   ACLCD       E                     EXTFLD(LCD)                                       CSW207A
     D IMACNT          DS            24                                                       250600
     D**IMCNUM**               1      6  0                                             250600 CPK028
     D  IMCNUM                 1      6                                                       CPK028
     D  IMCCY                  7      9                                                       250600
     D  IMACOD                10     19  0                                                    250600
     D  IMACSQ                20     21  0                                                    250600
     D  IMBRCA                22     24                                                       250600
      *                                                                                      CSW207A
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
      *                                                                                     MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
      *
     C                   Z-ADD     0             IDx
     C                   Z-ADD     0             WIx                                        BUG14593
      *
     C                   CLEAR                   WDORC
     C                   MOVEL     DDORC1        WDORC1
     C                   MOVEL     DDORC2        WDORC2
     C                   MOVEL     DDORC3        WDORC3
     C                   MOVEL     DDORC4        WDORC4
     C                   EVAL      WDORC5 = DDORC5                                            CFT032
     C                   MOVEL     *BLANKS       WPORCT            1
     C**********         MOVEL     *BLANKS       WADCK             1                          250600
     C                   MOVEL     'Y'           WADCK             1                          250600
      *
      ** Validate Ordering Customer
      *
     C                   EXSR      SRValORCU
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKORC1 = 'N' OR
     C                             OKORC2 = 'N' OR
     C                             OKORC3 = 'N' OR
     C**********                   OKORC4 = 'N'                                               CFT032
     C                             OKORC4 = 'N' OR                                            CFT032
     C                             OKORC5 = 'N'                                               CFT032
     C**********                   Or OKORC1 = 'W'                                 BUG14593 BUG15081
     C**********                   Or OKORC2 = 'W'                                 BUG14593 BUG15081
     C**********                   Or OKORC3 = 'W'                                 BUG14593 BUG15081
     C**********                   Or OKORC4 = 'W'                                 BUG14593 BUG15081
     C**********                   Or OKORC5 = 'W'                                 BUG14593 BUG15081
      *
     C                   EVAL      RetCodeIn = 'ERROR'
      *                                                                                     BUG13025
      ** Save Ordering customer eventhough warning message will be display                  BUG13025
      *                                                                                     BUG13025
     C                   If        CFT004 = 'Y'                                             BUG13025
     C                             And WIx > 0                                              BUG13025
     C                   Eval      IPORC1 = DDORC1                                          BUG13025
     C                   Eval      IPORC2 = DDORC2                                          BUG13025
     C                   Eval      IPORC3 = DDORC3                                          BUG13025
     C                   Eval      IPORC4 = DDORC4                                          BUG13025
     C                   Eval      IPORC5 = DDORC5                                          BUG13025
     C                   Eval      IPORCT = WPORCT                                          BUG13025
     C                   EndIf                                                              BUG13025
      *
     C                   ELSE
      *
     C                   IF        OKORC1 = 'W' OR                                          BUG15081
     C                             OKORC2 = 'W' OR                                          BUG15081
     C                             OKORC3 = 'W' OR                                          BUG15081
     C                             OKORC4 = 'W' OR                                          BUG15081
     C                             OKORC5 = 'W'                                             BUG15081
     C                   EVAL      RetCodeIn = 'ERROR'                                      BUG15081
     C                   ENDIF                                                              BUG15081
     C                   MOVE      DDORC1        IPORC1
     C                   MOVE      DDORC2        IPORC2
     C                   MOVE      DDORC3        IPORC3
     C                   MOVE      DDORC4        IPORC4
     C                   EVAL      IPORC5 = DDORC5                                            CFT032
     C                   MOVEL     WPORCT        IPORCT
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValORCU - Validate Ordering Customer                       *
      *                                                               *
      *****************************************************************
     C     SRValORCU     BEGSR
      *
      ** Ordering Customer is mandatory except for MT20* messages
      *
     C     WDORC         IFEQ      *BLANKS
      *
      ** Allow blanks in Ordering Customer fields if Incoming Payment
      ** record is been created from incoming swift message:
      ** MT200, MT201, MT202, MT203 or MT205.
      *
     C     PDMTPY        IFNE      '200'
     C     PDMTPY        ANDNE     '201'
     C     PDMTPY        ANDNE     '202'
     C     PDMTPY        ANDNE     '203'
     C     PDMTPY        ANDNE     '205'
     C     PDMTPY        ANDNE     '210'                                                      250600
     C     PDMTPY        ANDNE     'B22'
     C                   MOVEL     'N'           OKORC1
     C                   MOVEL     'N'           OKORC2
     C                   MOVEL     'N'           OKORC3
     C                   MOVEL     'N'           OKORC4
     C*****              MOVEL     'N'           OKORC5                         CFT014
     C                   EVAL      OKORC5 = 'N'                                               CFT032
     C                   ADD       1             IDX
     C                   MOVEL     'DDORC1'      FldNamXAR(IDX)
     C**********         MOVEL     DDORC1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDORC1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDORC1)                   MD000091
     C                   MOVEL     'FTM2066'     MsgIdXAr(IDX)
     C                   ENDIF
      *
     C                   GOTO      EXORC
      *
     C                   ENDIF
      ***Validate*Account                                                             CSW207A 250600
     C**********         EVAL      PTYPE = *Blanks                                    CSW207A 250600
     C**********         CallB     'AOACCTV1'                                         CSW207A 250600
     C**********         Parm      *Blanks       PRTCD                                CSW207A 250600
     C**********         Parm                    PTYPE             7                  CSW207A 250600
     C**********         Parm      DDORC1        PACCT            35                  CSW207A 250600
     C**********         Parm                    DSSDY                                CSW207A 250600
                                                                                             CSW207A
     C**********         EVAL      PAcType = ' '                                      CSW207A 250600
     C**********         EVAL      PAccount = *Blanks                                 CSW207A 250600
     C**********         SELECT                                                       CSW207A 250600
     C**********         WHEN      PTYPE = '*CUSTNO'                                  CSW207A 250600
     C**********         EVAL      PAcType = 'C'                                      CSW207A 250600
     C**********         WHEN      PTYPE = '*RETAIL'                                  CSW207A 250600
     C**********         EVAL      PAcType = 'R'                                      CSW207A 250600
     C**********         WHEN      PTYPE = '*LEDGER'                                  CSW207A 250600
     C**********         EVAL      PAcType = 'G'                                      CSW207A 250600
     C**********         ENDSL                                                        CSW207A 250600
                                                                                             CSW207A
     C**********         If        PAcType = *Blanks                                  CSW207A 250600
     C**********         If        %SUBST(DDORC1:1:1) = '/'                           CSW207A 250600
     C**********         Eval      PACCT = %SUBST(DDORC1:2)                           CSW207A 250600
     C**********         Endif                                                        CSW207A 250600
                                                                                             CSW207A
     C**********         If        PRTCD <> *BLANKS                                   CSW207A 250600
     C**********         CALLB     'AOIBANR2'                                         CSW207A 250600
     C**********         PARM      *Blanks       PRTCD                                CSW207A 250600
     C**********         PARM                    PACCT                                CSW207A 250600
     C*****Accnt         PARM      Accnt         Dssdy                                CSW207A 250600
                                                                                             CSW207A
     C**********         IF        PRtcd = *Blanks                                    CSW207A 250600
     C**********         Eval      PAcType = 'I'                                      CSW207A 250600
     C**********         Move      CNUM          WCNUM                                CSW207A 250600
     C**********         Move      ACOD          WACOD                                CSW207A 250600
     C**********         Move      ACSQ          WACSQ                                CSW207A 250600
     C**********         Eval      PAccount = ACBRCA + WCNUM + CCY                    CSW207A 250600
     C**********                        + WACOD + WACSQ                               CSW207A 250600
     C**********         Eval      PCountry = %Subst(PACCT:1:2)                       CSW207A 250600
                                                                                             CSW207A
      **********         Else                                                         CSW207A 250600
      *                                                                                      CSW207A
      ***Check*external*IBAN                                                          CSW207A 250600
      *                                                                                      CSW207A
     C**********         Call      'AOIBANR5'                                         CSW207A 250600
     C**********         Parm      *Blanks       PRTCD                                CSW207A 250600
     C**********         Parm                    PACCT                                CSW207A 250600
     C**********         If        PRTCD = *Blanks                                    CSW207A 250600
     C**********         Call      'AOIBANR4'                                         CSW207A 250600
     C**********         Parm      *Blanks       PRTCD                                CSW207A 250600
     C**********         Parm      '*KEY'        POPTN                                CSW207A 250600
     C**********         Parm                    PACCT                                CSW207A 250600
     C*****Accnt         Parm      Accnt         Dssdy                                CSW207A 250600
     C**********         If        PRTCD = *Blanks                                    CSW207A 250600
     C**********         Eval      PAcType = 'I'                                      CSW207A 250600
     C**********         Move      CNUM          WCNUM                                CSW207A 250600
     C**********         Move      ACOD          WACOD                                CSW207A 250600
     C**********         Move      ACSQ          WACSQ                                CSW207A 250600
     C**********         Eval      PAccount = ACBRCA + WCNUM + CCY                    CSW207A 250600
     C**********                        + WACOD + WACSQ                               CSW207A 250600
     C**********         Eval      PCountry = %Subst(PACCT:1:2)                       CSW207A 250600
     C**********         EndIf                                                        CSW207A 250600
     C**********         EndIf                                                        CSW207A 250600
     C**********         EndIf                                                        CSW207A 250600
     C**********         EndIf                                                        CSW207A 250600
     C**********         EndIf                                                        CSW207A 250600
      *
     C**********         IF        CSW207 = 'Y'                                        CSW207 250600
     C**********         CALL      'FT001000'                                          CSW207 250600
     C**********         PARM      *BLANKS       PRTCD                                 CSW207 250600
     C**********         PARM                    PMsgID                                CSW207 250600
     C**********         PARM                    PErTp                                 CSW207 250600
     C**********         PARM      'TRAN'        PVType                                CSW207 250600
     C**********         PARM      DDORC1        P50FmtF1                              CSW207 250600
     C**********         PARM      DDORC2        P50FmtF2                              CSW207 250600
     C**********         PARM      DDORC3        P50FmtF3                              CSW207 250600
     C**********         PARM      DDORC4        P50FmtF4                              CSW207 250600
     C**********         PARM      DDORC5        P50FmtF5                              CSW207 250600
     C**********         PARM                    PAcType                               CSW207 250600
     C**********         PARM                    PAccount                              CSW207 250600
     C**********         PARM                    PCust                                 CSW207 250600
     C**********         PARM                    PNonActH                              CSW207 250600
     C**********         PARM                    PNetwork                              CSW207 250600
     C**********         PARM      '103'         PMsgTyp                               CSW207 250600
     C**********         PARM      ':50F:'       PMsgTag                               CSW207 250600
     C**********         PARM                    PCountry                              CSW207 250600
     C**********         PARM                    PBrch                               CSW207 BUG14593
     C**********         PARM      IPBRCA        PBrch                               BUG14593 250600
     C**********         PARM      IPPCCY        PCurr                                 CSW207 250600
     C**********         PARM                    PNostro                               CSW207 250600
     C**********         PARM                    PModI                                 CSW207 250600
     C**********         PARM                    POut1                                 CSW207 250600
     C**********         PARM                    POut2                                 CSW207 250600
     C**********         PARM                    POut3                                 CSW207 250600
     C**********         PARM                    POut4                                 CSW207 250600
     C**********         PARM                    POut5                                 CSW207 250600
                                                                                              CSW207
     C**********         IF        PRTCD <> *BLANKS                                    CSW207 250600
                                                                                              CSW207
     C**********         IF        PErTp = 'E'                                         CSW207 250600
     C**********         ADD       1             IDX                                   CSW207 250600
     C**********         MOVEL     PMsgID        MsgIdXAr(IDX)                         CSW207 250600
                                                                                              CSW207
     C**********         EVAL      FldNamXAR(IDX) = 'DDORC1'                           CSW207 250600
     C**********         EVAL      OKORC1 = 'N'                                        CSW207 250600
     C**********         EVAL      OKORC2 = 'N'                                        CSW207 250600
     C**********         EVAL      OKORC3 = 'N'                                        CSW207 250600
     C**********         EVAL      OKORC4 = 'N'                                        CSW207 250600
     C**********         EVAL      OKORC5 = 'N'                                        CSW207 250600
                                                                                              CSW207
     C**********         GOTO      EXORC                                               CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
                                                                                              CSW207
     C**********         IF        PErTp = 'W'                                         CSW207 250600
     C**********         ADD       1             WIx                                   CSW207 250600
     C**********         MOVEL     PMsgID        MsgIdXAr(WIx)                       CSW207 BUG14593
     C**********         MOVEL     PMsgID        MsgIdXAr(WIx)                       CSW207 BUG14593
                                                                                              CSW207
     C**********         EVAL      WFldNmXAR(WIx) = 'DDORC1'                           CSW207 250600
     C**********         EVAL      OKORC1 = 'W'                                        CSW207 250600
     C**********         EVAL      OKORC2 = 'W'                                        CSW207 250600
     C**********         EVAL      OKORC3 = 'W'                                        CSW207 250600
     C**********         EVAL      OKORC4 = 'W'                                        CSW207 250600
     C**********         EVAL      OKORC5 = 'W'                                        CSW207 250600
                                                                                              CSW207
     C**********         GOTO      EXORC                                               CSW207 250600
     C**********         ENDIF                                                         CSW207 250600
                                                                                              CSW207
     C**********         ENDIF                                                         CSW207 250600
                                                                                              CSW207
     C**********         ENDIF                                                         CSW207 250600
                                                                                              CSW207
     C                   MOVEL     *BLANKS       ADDRSS
     C                   MOVEL     WDORC         ADDRSS
      *
      ** If first ten characters used then try to find via SDCUSTPD
      *
     C     ADCH26        IFEQ      *BLANKS
     C     ADEXCS        ANDEQ     *BLANKS
     C     ADSLSH        ANDNE     '/'
     C     ADCH36        OREQ      *BLANKS
     C     ADXCS2        ANDEQ     *BLANKS
     C     ADCHK2        ANDNE     *BLANKS
     C     ADSLSH        ANDEQ     '/'
     C     ADSLS2        ANDNE     '/'
      *
      ** First 10 characters should be key for SDCUST
      *
     C     ADSLSH        IFNE      '/'
     C                   MOVEL     ADCHK1        PCNUM
     C                   ELSE
     C                   MOVEL     ADCHK2        PCNUM
     C                   ENDIF
      *
     C     '?'           SCAN      DDORC1                                 01
      *
      ** Question mark is invalid on *CTL function.
      *
     C                   IF        PMODE = '*FRONT' and *IN01 = *On
     C                   MOVE      'N'           OKORC1
     C                   MOVEL     'N'           OKORC2
     C                   MOVEL     'N'           OKORC3
     C                   MOVEL     'N'           OKORC4
     C*****              MOVEL     'N'           OKORC5                         CFT014
     C                   EVAL      OKORC5 = 'N'                                               CFT032
     C                   ADD       1             Idx
     C                   MOVEL     'DDORC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTM2242'     MsgIdXAr(Idx)
     C                   GOTO      EXORC
     C                   ENDIF
      *
      ** Call to access pgm for Customer details
      *
     C                   CALLB     'AOCUSTR0'                           9090
     C                   PARM      *BLANKS       PRtcd             7
     C                   PARM      '*KEY   '     POptn             7
     C                   PARM                    PCNUM            10
     C                   PARM      *BLANKS       PKyst             7
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     POptn         DBKey
     C                   MOVEL     'AOCUSTR0'    DBFile
     C                   Z-ADD     001           DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRtcd         IFEQ      *BLANKS
      *
      ** Overwrite shortname
      *
     C     ADSLSH        IFNE      '/'
     C                   MOVEL     *BLANKS       DDORC1
     C                   MOVEL     BBCUST        DDORC1
     C                   ELSE
     C                   MOVEL     *BLANKS       DDORC2
     C                   MOVEL     BBCUST        DDORC2
     C                   ENDIF
      *
     C                   MOVEL     'C'           WPORCT
      *
      ** Valid information exit
      *
     C                   GOTO      EXORC
      *
     C                   ELSE
      *
     C                   IF        PRtcd = '*NOSEL ' and *IN01 = *On
      *
      ** Clear display fields.
      *
     C     ADSLSH        IFNE      '/'
     C                   MOVEL     *BLANKS       DDORC1
     C                   ELSE
     C                   MOVEL     *BLANKS       DDORC2
     C                   ENDIF
      *
     C                   MOVEL     'N'           OKORC1
     C                   MOVEL     'N'           OKORC2
     C                   MOVEL     'N'           OKORC3
     C                   MOVEL     'N'           OKORC4
     C*****              MOVEL     'N'           OKORC5                         CFT014
     C                   EVAL      OKORC5 = 'N'                                               CFT032
     C                   ADD       1             IDX
     C                   MOVEL     'DDORC1'      FldNamXAR(IDX)
     C**********         MOVEL     DDORC1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDORC1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDORC1)                   MD000091
     C                   MOVEL     'FTM2066'     MsgIdXAr(IDX)
     C                   GOTO      EXORC
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If 1st 11 Chars of 1st line then SWIFT address assumed
      ** Old Midas function, really just an address
      *
     C*****ADCH26        IFEQ      *BLANKS                                                  BUG15193
     C*****ADEXSW        ANDEQ     *BLANKS                                                  BUG15193
     C     ADEXSW        IFEQ      *BLANKS                                                  BUG15193
     C     ADCH26        ANDEQ     *BLANKS                                                    256617
     C     ADSLSH        OREQ      '/'                                                        256617
     C     ADEXS2        ANDEQ     *BLANKS                                                    256617
     C     ADCH36        ANDEQ     *BLANKS                                                    256617
      *
      ** First 11 characters should be key for CLSWT.
      *
     C                   MOVEL     DDORC1        CLSWTK           12
     C     DDORC2        IFNE      *BLANKS                                                  BUG15193
     C                   MOVEL     DDORC2        CLSWTK                                     BUG15193
     C                   ENDIF                                                              BUG15193
      *
     C                   EXSR      SWIFT
      *
     C     ##CSID        IFEQ      'Y'
     C                   If        ADSLSH = '/'and *IN31=*Off and *IN32=*Off                AR924684
     C                             or ADSLSH <> '/'                                         AR924684
     C     *IN31         IFEQ      '1'
     C                   MOVEL     'N'           OKORC1
     C                   ADD       1             IDX
     C**********         MOVEL     DDORC1        FldNamXAr(IDX)                             MD023389
     C                   MOVEL     'DDORC1'      FldNamXAr(IDX)                             MD023389
     C**********         MOVEL     CLSWTK        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(CLSWTK))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(CLSWTK)                   MD000091
     C                   MOVEL     'FTM2067'     MsgIdXAr(IDX)
     C                   GOTO      EXORC
     C                   END
      *
      ** No SWIFT address record.
      *
     C     *IN32         IFEQ      '1'
     C     *IN31         ANDEQ     '0'
     C                   MOVEL     'N'           OKORC1
     C                   ADD       1             IDX
     C***********        MOVEL     'DDORC1'      FldNamXAR(IDX)                               223728
     C***********        MOVEL     CLSWTK        MsgDtaXAr(IDX)                               223728
     C***********        MOVEL     'FTM2068'     MsgIdXAr(IDX)                                223728
     C                   MOVEL     'DDORC1'      WFldNmXAr(IDX)                               223728
     C**********         MOVEL     CLSWTK        WMsgDtXAr(IDX)                      223728 MD000091
     C                   EVAL      BLen = %Len(%Trim(CLSWTK))                               MD000091
     C                   EVAL      WMsgDtXAr(IDX) = LenStr +%TRIM(CLSWTK)                   MD000091
     C                   MOVEL     'FTM2068'     WMsgIDXAr(IDX)                               223728
     C                   GOTO      EXORC
     C                   ENDIF
      *
     C                   MOVEL     'S'           WPORCT
      *
      ** Exit as validation complete for S.W.I.F.T.
      *
     C                   GOTO      EXORC
      *
     C                   EndIf                                                              AR924684
     C                   ENDIF
      *
     C                   ENDIF
                                                                                              CFT032
     C                   IF        CFT004 = 'Y'                                               CFT032
     C                   IF        %SUBST(WDORC1:1:1) = '/'                                   CFT032
     C                   EVAL      PIBAN = %SUBST(WDORC1:2:34)                                CFT032
                                                                                              CFT032
     C                   CALL      'AOIBANR3'                                                 CFT032
     C                   PARM                    @Rcode            7                          CFT032
     C                   PARM                    PIBAN            47                          CFT032
     C                   PARM                    POWith           47                          CFT032
     C     P@IBAN        PARM                    PONobl           34                          CFT032
                                                                                              CFT032
      ** If first four characters are 'AANN', proceed with IBAN                               CFT032
      ** validation.                                                                          CFT032
                                                                                              CFT032
     C                   EVAL      IBCTY1 = %SUBST(P@IBAN:1:1)                                CFT032
     C                   EVAL      IBCTY2 = %SUBST(P@IBAN:2:1)                                CFT032
     C                   EVAL      IBCHK1 = %SUBST(P@IBAN:3:1)                                CFT032
     C                   EVAL      IBCHK2 = %SUBST(P@IBAN:4:1)                                CFT032
     C     IBCTY1        LOOKUP    Alpha                                  94                  CFT032
     C   94IBCTY2        LOOKUP    Alpha                                  94                  CFT032
     C   94IBCHK1        LOOKUP    Numeric                                94                  CFT032
     C   94IBCHK2        LOOKUP    Numeric                                94                  CFT032
                                                                                              CFT032
     C                   IF        *IN94 = *ON                                                CFT032
     C                             AND DDORC2 <> *BLANKS                                    BUG24494
                                                                                              CFT032
     C                   CALL      'AOIBANR5'                           90                    CFT032
     C                   PARM      *BLANKS       @Rcode                                       CFT032
     C                   PARM                    P@IBAN           34                          CFT032
                                                                                              CFT032
     C/COPY OFCPYSRCZ,CFT148_020                                                             259953A
      ** If no warnings, prefix IBAN with '/'                                                 CFT032
                                                                                              CFT032
     C                   IF        *IN90 = *OFF AND @Rcode = *BLANKS                          CFT032
     C*****'/'**         CAT       P@IBAN        WDORC5                                CFT032 250600
     C     '/'           CAT       P@IBAN        WDORC1                                       250600
     C**********         EVAL      PAcType = 'I'                                     CSW207A CSW207A
     C                   ELSE                                                                 CFT032
                                                                                              CFT032
      ** Warnings:                                                                            CFT032
                                                                                              CFT032
     C**********         EVAL      OKORC5 = 'N'                                        CFT032 250600
     C**********         EVAL      OKORC1 = 'N'                                        250600 254945
     C                   EVAL      OKORC1 = 'W'                                               254945
     C                   EVAL      WIx = WIx + 1                                              CFT032
     C**********         EVAL      WFldNmXAr(WIx) = 'WDORC5    '                       CFT032 250600
     C                   EVAL      WFldNmXAr(WIx) = 'WDORC1    '                              250600
     C**********         EVAL      WMsgDtXAr(WIx) =                                  CFT032 MD000091
     C**********                   'Ordering Customer'                               CFT032 MD000091
     C                   EVAL      MsgDtaTmp = 'Ordering Customer'                          MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtXAr(Idx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   SELECT                                                               CFT032
                                                                                              CFT032
      *  Invalid ISO country code                                                             CFT032
                                                                                              CFT032
     C                   WHEN      @Rcode = '      1'                                         CFT032
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2400'                                 CFT032
                                                                                              CFT032
      *  Invalid BBAN length                                                                  CFT032
                                                                                              CFT032
     C                   WHEN      @Rcode = '      2'                                         CFT032
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2401'                                 CFT032
                                                                                              CFT032
      *  Invalid character                                                                    CFT032
                                                                                              CFT032
     C                   WHEN      @Rcode = '      3'                                         CFT032
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2402'                                 CFT032
                                                                                              CFT032
      *  Invalid IBAN length                                                                  CFT032
                                                                                              CFT032
     C                   WHEN      @Rcode = '      4'                                         CFT032
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2403'                                 CFT032
                                                                                              CFT032
      *  Invalid check digit                                                                  CFT032
                                                                                              CFT032
     C                   WHEN      @Rcode = '      5'                                         CFT032
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2404'                                 CFT032
                                                                                              CFT032
      *  Other/non-specific warning                                                           CFT032
                                                                                              CFT032
     C                   OTHER                                                                CFT032
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2405'                                 CFT032
     C                   ENDSL                                                                CFT032
     C                   ENDIF                                                                CFT032
     C                   ENDIF                                                                CFT032
     C                   ENDIF                                                                CFT032
     C                   ENDIF                                                                CFT032
      *
      ** Validate as an address
      *
     C     WADCK         IFNE      'Y'
     C                   MOVEL     'A'           WPORCT
     C                   GOTO      EXORC
     C                   ENDIF
      *
     C                   MOVEL     'Y'           ADLINE
     C                   EXSR      ADCHK
      *
      ** Depending on the indicators, highlight the field in error
      *
     C     *IN91         IFEQ      '1'
     C     CSW207        ANDEQ     'N'                                                       250804A
     C                   MOVEL     'N'           OKORC1
     C                   ADD       1             IDX
     C                   MOVEL     'DDORC1'      FldNamXAR(IDX)
     C**********         MOVEL     DDORC1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDORC1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDORC1)                   MD000091
     C                   MOVEL     'FTM2152'     MsgIdXAr(IDX)
     C                   ENDIF
      *
     C     *IN92         IFEQ      '1'
     C                   MOVEL     'N'           OKORC1
     C                   ADD       1             IDX
     C                   MOVEL     'DDORC1'      FldNamXAR(IDX)
     C**********         MOVEL     DDORC1        MsgDtaXAr(IDX)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDORC1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDORC1)                   MD000091
     C                   MOVEL     'FTM2153'     MsgIdXAr(IDX)
     C                   ENDIF
      *
     C     AD#1          IFEQ      'Y'
     C                   MOVEL     'N'           OKORC1
     C                   ENDIF
      *
     C     AD#2          IFEQ      'Y'
     C                   MOVEL     'N'           OKORC2
     C                   ENDIF
      *
     C     AD#3          IFEQ      'Y'
     C                   MOVEL     'N'           OKORC3
     C                   ENDIF
      *
     C     AD#4          IFEQ      'Y'
     C                   MOVEL     'N'           OKORC4
     C                   ENDIF
                                                                                              CFT032
     C                   IF        AD#5 = 'Y'                                                 CFT032
     C                   EVAL      OKORC5 = 'N'                                               CFT032
     C                   ENDIF                                                                CFT032
                                                                                              CFT032
     C                   IF        CSW207 = 'N'                                               250600
     C                   IF        PNWRK = 'SWIFT ' OR PNWRK = '      '                       250600
     C                   IF        %SUBST(WDORC1:1:1) <> '/' AND                              CFT032
     C                             WDORC5 <> *BLANKS                                          CFT032
     C                   EVAL      IDX = IDX + 1                                              CFT032
     C                   EVAL      FldNamXAR(IDX) = 'WDORC5'                                  CFT032
     C**********         EVAL      MsgDtaXAr(IDX) = WDORC5                           CFT032 MD000091
     C                   EVAL      BLen = %Len(%Trim(WDORC5))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(WDORC5)                   MD000091
     C                   EVAL      MsgIdXAr(IDX) = 'FTM0111'                                  CFT032
     C                   ENDIF                                                                CFT032
     C                   ENDIF                                                                250600
     C                   ENDIF                                                                250600
      *
      ** If no errors then customer is an address
      *
     C                   IF        OKORC1 <> 'N' and
     C                             OKORC2 <> 'N' and
     C                             OKORC3 <> 'N' and
     C**********                   OKORC4 <> 'N'                                              CFT032
     C                             OKORC4 <> 'N' and                                          CFT032
     C                             OKORC5 <> 'N'                                              CFT032
     C                   MOVEL     'A'           WPORCT
     C/COPY OFCPYSRCZ,CFT148_021                                                             259953A
     C                   ENDIF
      *                                                                                       250600
     C     EXORC         TAG                                                                  250600
     C                   IF        CSW207 = 'Y'                                               250600
      *                                                                                       250600
     C                   IF        OKORC1 <> 'N' and                                          250600
     C                             OKORC2 <> 'N' and                                          250600
     C                             OKORC3 <> 'N' and                                          250600
     C                             OKORC4 <> 'N' and                                          250600
     C                             OKORC5 <> 'N'                                              250600
      *                                                                                       250600
     C                   MOVEL     PDBACT        IMACNT                                       250600
     C                   MOVEL     IMCNUM        PCUST                                        250600
     C                   MOVEL     IMCCY         PCYCD                                        250600
     C                   MOVEL     IMACOD        PACCD                                        250600
     C                   MOVEL     IMACSQ        PACSQ                                        250600
     C                   MOVEL     IMBRCA        PBRCD                                        250600
      *                                                                                       250600
      ** Check if entry is an existing nostro identifier                                      250600
     C                   CALL      'AONOSTR0'                                                 250600
     C                   PARM      *BLANKS       @RTCD                                        250600
     C                   PARM      '*KEY   '     @OPTN                                        250600
     C                   PARM                    PCUST             6                          250600
     C                   PARM                    PCYCD             3                          250600
     C                   PARM                    PACCD             4                          250600
     C                   PARM                    PACSQ             2                          250600
     C                   PARM      *BLANKS       PNONB             2                          250600
     C                   PARM                    PBRCD             3                          250600
     C                   PARM      *BLANKS       PCSSN            10                          250600
     C                   PARM      *BLANKS       PPNOI             1                          250600
     C     SDNOST        PARM      *BLANKS       DSFDY                                        250600
     C                   IF        (@RTCD <> *BLANKS)                                         250600
     C                   MOVEL     *BLANKS       A7NONB                                       250600
     C                   MOVEL     *BLANKS       A7CYCD                                       250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
     C                   If        PDMTPY <> *BLANKS                                          250600
     C                   EVAL      PMsgTyp = PDMTPY                                           250600
     C                   ELSE                                                                 250600
     C                   EVAL      PMsgTyp = '103'                                            250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
     C                   EVAL      PMsgTag = ':50F:'                                          250600
     C                   EVAL      PAcType  = WPORCT                                          250600
     C                   EVAL      PAccount = *BLANKS                                         250600
      *                                                                                     BUG24654
      ** If account type is an address, customer should be blank.                           BUG24654
      *                                                                                     BUG24654
     C                   If        WPORCT = 'A'                                             BUG24654
     C                   EVAL      PCust    = *Blanks                                       BUG24654
     C                   Else                                                               BUG24654
     C                   EVAL      PCust    = BBCUST                                          250600
     C                   Endif                                                              BUG24654
      *                                                                                     BUG24654
     C                   EVAL      PNonActH = *BLANKS                                         250600
      *                                                                                       250600
     C                   IF        PNWRK <> *BLANKS                                           250600
     C                   EVAL      PNetwork = PNWRK                                           250600
     C                   ELSE                                                                 250600
     C                   EVAL      PNetwork = 'SWIFT'                                         250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
     C                   IF        IPSNTP = 'S'                                               250600
     C                   EVAL      PCountry = %Subst(IPSND1:5:2)                              250600
     C                   ELSE                                                                 250600
     C                   IF        IPSNTP = 'A'                                               250600
     C                   EVAL      PCountry = *BLANKS                                         250600
     C                   ELSE                                                                 250600
     C                   Call      'AOACCTV1'                                                 250600
     C                   Parm      *Blanks       @RtCd                                        250600
     C                   Parm      *Blanks       P@Typ            10                          250600
     C                   Parm      IPSND1        P@Str            35                          250600
     C                   Parm                    DSSDY                                        250600
                                                                                              250600
     C                   Select                                                               250600
     C                   When      P@Typ = '*RETAIL' Or                                       250600
     C                             P@Typ = '*LEDGER'                                          250600
     C                   Eval      ACCNT   = DSSDY                                            250600
     C                   Eval      WCustomer = CNUM                                           250600
     C                   When      P@Typ = '*NOSTRO'                                          250600
     C                   Eval      SDNOST = DSSDY                                             250600
     C                   MOVE      A7CUST        WCustomer                                    250600
     C                   When      P@Typ = '*CUSTNO' Or                                       250600
     C                             P@Typ = '*SHNAME'                                          250600
     C                   Eval      SDCUST = DSSDY                                             250600
     C                   MOVE      BBCUST        WCustomer                                    250600
     C                   EndSl                                                                250600
                                                                                              250600
     C                   MOVEL     WCustomer     WCust10          10                          250600
     C                   Call      'AOCUSTR0'                                                 250600
     C                   Parm      *Blanks       @RtCd             7                          250600
     C                   Parm      '*KEY'        @Optn             7                          250600
     C                   Parm      WCust10       C#Key1           10                          250600
     C                   Parm      *Blanks       C#Kyst            7                          250600
     C     SDCUST        Parm      SDCUST        DSSDY                                        250600
                                                                                              250600
     C                   If        @RtCD = *Blanks                                            250600
     C                   Eval      PCountry = BBCOLC                                          250600
     C                   EndIf                                                                250600
                                                                                              250600
     C                   ENDIF                                                                250600
     C                   ENDIF                                                                250600
     C                   EVAL      PBrch    = IPBRCA                                          250600
      *                                                                                       250600
     C                   IF        PCYCD <> *BLANKS                                           250600
     C                   EVAL      PCurr    = A7CYCD                                          250600
     C                   ELSE                                                                 250600
     C                   EVAL      PCurr    = IPSMCY                                          250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
     C                   IF        A7NONB <> *BLANKS                                          250600
     C                   EVAL      PNostro  = A7NONB                                          250600
     C                   ELSE                                                                 250600
     C                   EVAL      PNostro  = *BLANKS                                         250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
     C**********         EVAL      PModI    = 'FT'                                   250600 BUG25973
     C                   EVAL      PModI    = 'IN'                                          BUG25973
      *                                                                                       250600
     C                   CALL      'FT001000'                                                 250600
     C                   PARM      *BLANKS       PRTCD                                        250600
     C                   PARM                    PMsgID                                       250600
     C                   PARM                    PErTp                                        250600
     C                   PARM      'TRAN'        PVType                                       250600
     C                   PARM      DDORC1        P50FmtF1                                     250600
     C                   PARM      DDORC2        P50FmtF2                                     250600
     C                   PARM      DDORC3        P50FmtF3                                     250600
     C                   PARM      DDORC4        P50FmtF4                                     250600
     C                   PARM      DDORC5        P50FmtF5                                     250600
     C                   PARM                    PAcType                                      250600
     C                   PARM                    PAccount                                     250600
     C                   PARM                    PCust                                        250600
     C                   PARM                    PNonActH                                     250600
     C                   PARM                    PNetwork                                     250600
     C                   PARM                    PMsgTyp                                      250600
     C                   PARM                    PMsgTag                                      250600
     C                   PARM                    PCountry                                     250600
     C                   PARM                    PBrch                                        250600
     C                   PARM                    PCurr                                        250600
     C                   PARM                    PNostro                                      250600
     C                   PARM                    PModI                                        250600
     C                   PARM                    POut1                                        250600
     C                   PARM                    POut2                                        250600
     C                   PARM                    POut3                                        250600
     C                   PARM                    POut4                                        250600
     C                   PARM                    POut5                                        250600
     C/COPY OFCPYSRCZ,CFT148_023                                                              CFT148
      *                                                                                       250600
     C                   IF        PRTCD <> *BLANKS                                           250600
      *                                                                                       250600
     C                   IF        PMsgID= 'FTS0055'                                        BUG15037
     C                   Eval      PErTp = 'W'                                              BUG15037
      *                                                                                     BUG24909
      ** Include address error if existing                                                  BUG24909
      *                                                                                     BUG24909
     C                   If        %SUBST(DDORC1:1:1) = '/'                                 BUG24909
     C                             And DDORC2 = *BLANKS                                     BUG24909
     C                   Eval      PMsgID ='FTM2152'                                        BUG24909
     C                   Eval      PErTp = 'E'                                              BUG24909
     C                   EndIf                                                              BUG24909
     C                   ENDIF                                                              BUG15037
      *                                                                                     BUG15045
     C                   IF        PMsgID= 'FTS0052'                                        BUG15045
     C                             And PAcType <> 'A'                                       BUG15045
     C                   Eval      PErTp = ' '                                              BUG15045
     C                   ENDIF                                                              BUG15045
      *                                                                                     BUG25095
     C                   IF        PMsgID= 'FTS0003' And                                    BUG25095
     C                             %SUBST(P50FmtF1:1:1) = '/' And                           BUG25095
     C                             %SUBST(P50FmtF2:1:2) <> '1/'                             BUG25095
     C                   EVAL      PMsgID = 'FTS0060'                                       BUG25095
     C                   EVAL      PErTp = 'W'                                              BUG25095
     C                   ENDIF                                                              BUG25095
      * For incoming payment do not block input if entry is mandatory but warn the user.      250600
     C**********         IF        PErTp = 'E' OR PErTp = 'W'                        250600 BUG15037
     C                   Select                                                             BUG15037
      *                                                                                       250600
     C                   When      PErTp = 'W'                                              BUG15037
     C                   ADD       1             WIx                                          250600
     C                   MOVEL     PMsgID        WMsgIdXar(WIx)                               250600
      *                                                                                     BUG15029
     C                   If        PMsgID = 'FTS0053'                                       BUG15029
     C**********         Eval      WMsgDtaXAr(WIx) =PNetwork                       BUG15029 MD000091
     C                   EVAL      BLen = %Len(%Trim(PNetwork))                             MD000091
     C                   EVAL      WMsgDtaXAr(WIx) = LenStr +%TRIM(PNetwork)                MD000091
     C                   ElseIf    PMsgID = 'FTS0054'                                       BUG15029
     C**********         Eval      WMsgDtaXAr(WIx) =PMsgTag                        BUG15029 MD000091
     C                   EVAL      BLen = %Len(%Trim(PMsgTag))                              MD000091
     C                   EVAL      WMsgDtaXAr(WIx) = LenStr +%TRIM(PMsgTag)                 MD000091
     C                   Endif                                                              BUG15029
      *                                                                                       250600
     C                   EVAL      WFldNmXAR(WIx) = 'DDORC1'                                  250600
     C**********         EVAL      WMsgDtXar(WIx) = DDORC1                         MD019874 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDORC1))                               MD000091
     C                   EVAL      WMsgDtXar(WIx) = LenStr +%TRIM(DDORC1)                   MD000091
     C                   EVAL      OKORC1 = 'W'                                               250600
     C                   EVAL      OKORC2 = 'W'                                               250600
     C                   EVAL      OKORC3 = 'W'                                               250600
     C                   EVAL      OKORC4 = 'W'                                               250600
     C                   EVAL      OKORC5 = 'W'                                               250600
      *                                                                                     BUG15037
     C                   When      PErTp = 'E'                                              BUG15037
     C                   ADD       1             IDX                                        BUG15037
     C                   MOVEL     PMsgID        MsgIdXar(IDX)                              BUG15037
      *                                                                                     BUG15037
     C                   If        PMsgID = 'FTS0053'                                       BUG15037
     C**********         Eval      MsgDtaXAr(IDX) =PNetwork                        BUG15037 MD000091
     C                   EVAL      BLen = %Len(%Trim(PNetwork))                             MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(PNetwork)                 MD000091
     C                   ElseIf    PMsgID = 'FTS0054'                                       BUG15037
     C**********         Eval      MsgDtaXAr(IDX) =PMsgTag                         BUG15037 MD000091
     C                   EVAL      BLen = %Len(%Trim(PMsgTag))                              MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(PMsgTag)                  MD000091
     C                   ElseIf    PMsgID = 'FTM2152'                                       BUG24909
     C**********         Eval      MsgDtaXAr(IDX) = DDORC1                         BUG24909 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDORC1))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(DDORC1)                   MD000091
     C                   Endif                                                              BUG15037
      *                                                                                     BUG15037
     C                   EVAL      FldNamXAR(IDX) = 'DDORC1'                                BUG15037
     C                   EVAL      OKORC1 = 'N'                                             BUG15037
     C                   EVAL      OKORC2 = 'N'                                             BUG15037
     C                   EVAL      OKORC3 = 'N'                                             BUG15037
     C                   EVAL      OKORC4 = 'N'                                             BUG15037
     C                   EVAL      OKORC5 = 'N'                                             BUG15037
      *                                                                                     BUG15037
     C                   EndSl                                                              BUG15037
      *                                                                                       250600
     C**********         ENDIF                                                       250600 BUG15037
      ** Skip validation to avoid display of inappropriate message.
      **********                                                                   BUG15121 BUG15192
      ***Include*address*error*if*existing*                                        BUG15121 BUG15192
      **********                                                                   BUG15121 BUG15192
     C******IN91         IFEQ      '1'                                             BUG15121 BUG15192
     C**********         MOVEL     'N'           OKORC1                            BUG15121 BUG15192
     C**********         ADD       1             IDX                               BUG15121 BUG15192
     C**********         MOVEL     'DDORC1'      FldNamXAR(IDX)                    BUG15121 BUG15192
     C**********         MOVEL     DDORC1        MsgDtaXAr(IDX)                    BUG15121 BUG15192
     C**********         MOVEL     'FTM2152'     MsgIdXAr(IDX)                     BUG15121 BUG15192
     C**********         ENDIF                                                     BUG15121 BUG15192
      *                                                                                       250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
     C                   IF        PNWRK = 'SWIFT ' OR PNWRK = '      '                       250600
     C                   IF        %SUBST(WDORC1:1:1) <> '/' AND                              250600
     C                             WDORC5 <> *BLANKS                                          250600
     C                   If        %SUBST(DDORC5:1:2) <> '1/' And                           BUG15065
     C                             %SUBST(DDORC5:1:2) <> '2/' And                           BUG15065
     C                             %SUBST(DDORC5:1:2) <> '3/' And                           BUG15065
     C                             %SUBST(DDORC5:1:2) <> '4/' And                           BUG15065
     C                             %SUBST(DDORC5:1:2) <> '5/' And                           BUG15065
     C                             %SUBST(DDORC5:1:2) <> '6/' And                           BUG15065
     C                             %SUBST(DDORC5:1:2) <> '7/' And                           BUG15065
     C                             %SUBST(DDORC2:1:2) <> '1/' And                           BUG24977
     C                             %SUBST(DDORC5:1:2) <> '8/'                               BUG15065
     C                   EVAL      OKORC1 = 'N'                                             BUG15192
     C                   EVAL      IDX = IDX + 1                                              250600
     C                   EVAL      FldNamXAR(IDX) = 'WDORC5'                                  250600
     C**********         EVAL      MsgDtaXAr(IDX) = WDORC5                           250600 MD000091
     C                   EVAL      BLen = %Len(%Trim(WDORC5))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(WDORC5)                   MD000091
     C                   EVAL      MsgIdXAr(IDX) = 'FTM0111'                                  250600
     C                   ENDIF                                                                250600
     C                   ENDIF                                                              BUG15065
      *                                                                                       250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
      ** Skip validation to avoid display of inappropriate message.
     C**********         If        %SUBST(DDORC5:1:2) <> '1/' And                  BUG15065 BUG15192
     C**********                   %SUBST(DDORC5:1:2) <> '2/' And                  BUG15065 BUG15192
     C**********                   %SUBST(DDORC5:1:2) <> '3/' And                  BUG15065 BUG15192
     C**********                   %SUBST(DDORC5:1:2) <> '4/' And                  BUG15065 BUG15192
     C**********                   %SUBST(DDORC5:1:2) <> '5/' And                  BUG15065 BUG15192
     C**********                   %SUBST(DDORC5:1:2) <> '6/' And                  BUG15065 BUG15192
     C**********                   %SUBST(DDORC5:1:2) <> '7/' And                  BUG15065 BUG15192
     C**********                   %SUBST(DDORC5:1:2) <> '8/'                      BUG15065 BUG15192
     C******IN91         IFEQ      '1'                                              250804A BUG15192
     C**********         MOVEL     'N'           OKORC1                             250804A BUG15192
     C**********         ADD       1             IDX                                250804A BUG15192
     C**********         MOVEL     'DDORC1'      FldNamXAR(IDX)                     250804A BUG15192
     C**********         MOVEL     DDORC1        MsgDtaXAr(IDX)                     250804A BUG15192
     C**********         MOVEL     'FTM2152'     MsgIdXAr(IDX)                      250804A BUG15192
     C**********         ENDIF                                                      250804A BUG15192
     C**********         ENDIF                                                       250600 BUG15192
     C                   ENDIF                                                              BUG15065
      *                                                                                       250600
     C                   ENDIF                                                                250600
      *                                                                                       250600
     C     EXOR2         TAG                                                                  250600
     C                   ENDSR                                                                250600
      *
     C*****EXORC         ENDSR                                                                250600
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTADDRSC1
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTADDRCLE
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY FTCPYSRC,SFTSWFTCLE
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Incoming Payments Lvl 2 Scrn 1/1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP2ScnFmt
     C                   PARM                    NwIP3ScnFmt                                  CFT032
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode             6
      *
      ** Message Type
     C                   PARM                    PDMTPY            3
      *                                                                                       250600
      ** Debit Account                                                                        250600
     C                   PARM                    PDBACT           24                          250600
      *                                                                                       250600
      ** Credit Account                                                                       250600
     C                   PARM                    PCDACT           24                          250600
      *                                                                                       250600
      ** Network                                                                              250600
     C                   PARM                    PNWRK             6                          250600
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Incoming Payments Lvl 2 Scrn 1 error indicators
     C                   PARM                    FTEIPY2
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
                                                                                              CFT032
      ** Access SAR file to determine if CFT004 is ON                                         CFT032
                                                                                              CFT032
     C                   CALLB     'AOSARDR0'                                                 CFT032
     C                   PARM      *BLANKS       PRTCD                                        CFT032
     C                   PARM      '*VERIFY'     POPTN                                        CFT032
     C                   PARM      'CFT004'      PSARD                                        CFT032
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT032
      *                                                                                       CFT032
      ** An NRF (No Record Found) return code is valid.                                       CFT032
      ** Issue database error only for error return codes.                                    CFT032
      *                                                                                       CFT032
     C                   IF        PRTCD <> *BLANKS AND                                       CFT032
     C                             PRTCD <> '*NRF   '                                         CFT032
     C                   EVAL      DBKEY = 'CFT004'                                           CFT032
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT032
     C                   EVAL      DBASE = 1                                                  CFT032
     C                   EXSR      *PSSR                                                      CFT032
     C                   ENDIF                                                                CFT032
      *                                                                                       CFT032
     C                   IF        PRTCD = *BLANKS                                            CFT032
     C                   EVAL      CFT004 = 'Y'                                               CFT032
     C                   ELSE                                                                 CFT032
     C                   EVAL      CFT004 = 'N'                                               CFT032
     C                   ENDIF                                                                CFT032
                                                                                              CSW207
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRTCD                                        CSW207
      *                                                                                       CSW207
     C                   IF        PRTCD = *BLANKS                                            CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ENDIF                                                                CSW207
     C/COPY OFCPYSRCZ,CFT148_022                                                              CFT148
      *
      ** Program, module and procedure names for DBase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
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
**  Alpha - Array of alphabetic characters                                                    CFT032
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**  Numeric - Array of numeric characters                                                     CFT032
0123456789
