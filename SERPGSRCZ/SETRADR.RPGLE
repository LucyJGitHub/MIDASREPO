     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities trade - retrieve a record')        *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADR - SE Securities Trade retrieve a record              *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR903401           Date 30Jan12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CER049             Date 06Dec10               *
      *                 AR698195B          Date 20Jan11               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206E            Date 24Aug06               *
      *                 BUG11194           Date 24Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10202           Date 29Jan06               *
      *                 BUG9961            Date 19Jan06               *
      *                 CAP087             Date 17Aug05               *
      *                 BUG9584            Date 25Apr05               *
      *                 CER001             Date 25Apr05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG6496R           Date 10Jun05               *
      *                 BUG6496            Date 24Apr05               *
      *                 BUG5557            Date 26Jan05               *
      *                 MLFIX1             Date 26May04               *
      *                 BUG1569            Date 17Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 14Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  AR903401 - Incorrect Customer Name details during enquiry    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on Inputs                             *
      *  CER049 - Stamp Tax                                           *
      *  AR698195B - Added Front Office field on the buffer for TRADS *
      *             (Child: AR698196)                                 *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  BUG11194 - SEFRN- Purchased Interest not recalculated when   *
      *             trade value date is changed
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10202- Mapping error in TRAD                              *
      *  BUG9961- Parameter mismatch for ZDYYR due to changes made    *
      *           by CSE071 and CAP087.                               *
      *  CAP087  - Enable the use of SETRADVU to process Buy/Sell     *
      *            trades.                                            *
      *  BUG9584- Mapping correction with Java.                       *
      *  CER001 - LUX Upgrade to MidasPlus.                           *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG6496R- Retrieve value for net treasury coupon rate        *
      *  BUG6496 - Missing CAS006 fields in Securities and Trades     *
      *            Maintenance.                                       *
      *  BUG5557 - Information for TRADSDX2 are being dropped during  *
      *            insert. Incorrect setup CSW003.                    *
      *  MLFIX1 - Add investment type to output message for           *
      *           management limit.                                   *
      *  BUG1569- Stopping user updating the same record at the same  *
      *           time.                                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Security Diary Events                                                              BUG6496R
     FSECEO     IF   E           K DISK    INFSR(*PSSR)                                     BUG6496R
     F                                     PREFIX(SE_)                                      BUG6496R
                                                                                            BUG6496R
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
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------
 
      * Securities screen format
      ** Securities screen 1 details from incoming transaction
      ** - screen format
 
      * New Trade in Screen Format - Primary Details
     D NewTrPrim     E DS                  EXTNAME(SETRPRPD)
      * New Trade in Screen Format - Secondary Details
     D NewTrSeco     E DS                  EXTNAME(SETRSEPD)
      * New Trade in Screen Format - Previous Entries for Int Recalculation                 BUG11194
     D NewTrPrev     E DS                  EXTNAME(SETRPVPD)                                BUG11194
      * New Trade in Screen Format - Exchange Rate Details
     D NewTrExch     E DS                  EXTNAME(SETREXPD)
      * New Trade in Screen Format - Settlement Details
     D NewTrSett     E DS                  EXTNAME(SETRSTPD)
     D DDCLTY2       E                     EXTFLD(DDCLTY)
      ** (Current) Trade in Screen Format - Third screen details
     D NewTrThir     E DS                  EXTNAME(SETRTHPD)
      * New Trade in Screen Format - Charge & Commission Details
     D NewTrChCm     E DS                  EXTNAME(SETRCCPD)
      * New TradeX1  Screen Format - SWIFT Details
     D NewTrSwftA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(A_)
      * New Trade in Screen Format - SWIFT Details
     D NewTrSwftB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(B_)
     D NewX2SwftA    E DS                  EXTNAME(SETESDPD)
     D                                     PREFIX(A_)
      * New TradeX2  Screen Format - SWIFT Details
     D NewX2SwftB    E DS                  EXTNAME(SETESDPD)
     D                                     PREFIX(B_)
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
      * Current Trade in File Format
     D CrTrFilFmt    E DS                  EXTNAME(TRADSD)
     D                                     PREFIX(C_)
      * Current Trade in File Format (Extension File)
     D CT1AFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(CA_)
      * Current Trade in File Format (Extension File)
     D CT1BFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(CB_)
     D TX2AFilFmt    E DS                  EXTNAME(TRADSDX2)
     D                                     PREFIX(A_)
     D TX2BFilFmt    E DS                  EXTNAME(TRADSDX2)
     D                                     PREFIX(B_)
      *                                                                                       CER001
      ** TRAD Extension File Format                                                           CER001
      *                                                                                       CER001
     D TRADLUXFilFmt E DS                  EXTNAME(SETRX1PD)                                  CER001
      *                                                                                       CER001
      ** Extra data in file format (Regional)                                                 CER001
      *                                                                                       CER001
     D RegData       E DS                  EXTNAME(SETDRXPD)                                  CER001
      ** Stamp Tax                                                                            CER049
     D StampTax      E DS                  EXTNAME(TRADSDQD)                                  CER049
 
      ** Externally described DS for midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Externally described DS for bank details                                             CAP087
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CAP087
                                                                                              CAP087
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
     D  QQDFA2       E                     EXTFLD(QQDFAC)                                     CSF011
      ** Externally described DS for customer details                                         CSF011
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D SEC_RECI      E                     EXTFLD(RECI)
     D SEC_ZZ005     E                     EXTFLD(ZZ005)
     D SEC_LCD       E                     EXTFLD(LCD)
     D SEC_CHTP      E                     EXTFLD(CHTP)
     D SEC_TNLU      E                     EXTFLD(TNLU)
     D SEC_REPI      E                     EXTFLD(REPI)
     D SEC_FRNT      E                     EXTFLD(FRNT)
     D SEC_REPA      E                     EXTFLD(REPA)
     D SEC_TMST      E                     EXTFLD(TMST)
     D SEC_SEZONE    E                     EXTFLD(SEZONE)
     D  CDArr                183    230                                                       CAP087
     D  CRArr                231    242                                                       CAP087
 
     D INVTP         E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
     D INV_NDEC      E                     EXTFLD(NDEC)
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** Externally described DS for securities trading ICD details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access programs - long data structure
 
     D InfData       E DS                  EXTNAME(SETRIFPD)                                 BUG9584
      *                                                                                      BUG9584
      ** SE Other Data - File (D/B) format                                                   BUG9584
      *                                                                                      BUG9584
      **-----------------------------------------------------------------------
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CSF011
     D                                     PREFIX(NO_)                                        CSF011
     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                   CSF011
     D                                     PREFIX(AC_)                                        CSF011
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      **-----------------------------------------------------------------------
      *
     D CSW003          S              1A
     D CAS006          S              1A
     D ULX603          S              1A                                                      CER001
     D CSW206          S              1A                                                     CSW206E
     D CSW210          S              1A                                                      CSW210
     D DDPRICN         S             17A
     D DDHACR          S             13A                                                     BUG6496
     D ZFLD15          S             15  0                                                  BUG6496R
     D ZDECS           S              1  0                                                  BUG6496R
     D ZECODE          S              1                                                     BUG6496R
     D ZOUT21          S             21                                                     BUG6496R
     D WrkNTCR         S             11  7                                                  BUG6496R
                                                                                              CAP087
      * No of Interest Days in year                                                           CAP087
     D DaysInYear      S              3  0                                                    CAP087
     D Out_DaysYear    S              3A                                                      CAP087
                                                                                              CAP087
     D Trade_Value     S             15  0                                                    CAP087
     D Out_Value       S             15A                                                      CAP087
     D CGL031          S              1A                                                      CGL031
 
      *
     D @FTRED          S             20A
     D @RDFWD          S              1A
     D @RDBCK          S              1A
     D @RSMD           S              1A
     D DDFRTN          S             20A
     D DDSRNME         S             41A
     D DDWTAX          S             15A
     D FOTRID          S             20A
     D OKACTN          S              1A
     D OKTDRF          S              1A
     D PErrMs          S              7A
     D PMode           S              6A   INZ('      ')
     D POptn           S              7A
     D PFBYSL          S              1A   INZ(' ')
     D PTrSnSel        S              6A
     D PRtCd           S              7A                                                      CGL031
     D PSard           S              6A                                                      CGL031
      ** Front office id variable.                                                         AR698195B
     D DDFRNT          S             20A                                                   AR698195B
      ** Automatic Authorisation variable.                                                 AR698195B
     D AAuth           S              1A                                                   AR698195B
      *
      ** Data structure for key fields and key selections
                                                                                              CSF011
     D WNumDetlIn      S           1000A                                                      CSF011
     D CusIdx          S              4S 0 INZ(1)                                             CSF011
     D CusIdx2         S              4S 0 INZ(1)                                             CSF011
     D CusLength       S              2S 0 INZ(40)                                            CSF011
     D AccLength       S              2S 0 INZ(72)                                            CSF011
     D ACusLngth       S              2S 0 INZ(52)                                            CSF011
     D W@Len           S              2S 0                                                    CSF011
     D NoOfCusField    S              2S 0 INZ(21)                                            CSF011
     D NoOfCusField2   S              2S 0 INZ(13)                                           CSF011A
     D CusOrAcc        C                   CONST('CAABBBBBBBBBBBBBBBBBB')                     CSF011
     D P@TYP           S             10                                                       CSF011
     D P@Str           S             35                                                       CSF011
     D P0RETL          S             10                                                       CSF011
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D W@Abc           S              1                                                       CSF011
     D WBrch           S              3                                                       CSF011
 
 
      ** +--- Start of main processing -----------------------------------+
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   CrTrFilFmt
     C                   CLEAR                   CT1AFilFmt
     C                   CLEAR                   CT1BFilFmt
     C                   CLEAR                   TX2AFilFmt
     C                   CLEAR                   TX2BFilFmt
     C                   MOVE      *BLANKS       ReturnCode
 
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
     C                   EXSR      SETRADRED
     C                   MOVEL     PTrSnSel      DDTDRF
     C                   ELSE
     C                   MOVEL     DDTDRF_In     DDTDRF
     C                   MOVEL     *BLANK        PErrMs
     C                   ENDIF
      *
      * If deal read and no error message returned
     C                   IF        ReturnCode = *BLANK and
     C                             DDTDRF <> *Blank
      *
      * Retrieve deal details (all key fields required for call to rtv module)
     C                   EXSR      SETRADRTV
     C                   IF        ULX603 = 'Y'                                               CER001
     C                   EXSR      SETRAD2RV                                                  CER001
     C                   ENDIF                                                                CER001
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      SETRADCVT
     C                   IF        ULX603 = 'Y'                                               CER001
     C                   EXSR      SETRAD2CT                                                  CER001
     C                   ENDIF                                                                CER001
     C                   EXSR      RtNetCpn                                                 BUG6496R
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ReturnCode <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDTDRF'      FldNameArr(1)
     C                   MOVEL     PErrMs        MsgIDArr(1)
     C                   ENDIF
      *                                                                                       CAP087
      * Calculate Days in Year                                                                CAP087
     C                   IF        Idx = 0                                                    CAP087
     C                   EXSR      CalcDays                                                   CAP087
     C                   ENDIF                                                                CAP087
                                                                                              CSF011
     C                   EXSR      SrCustName                                                 CSF011
     C                   EXSR      SrCustName2                                               CSF011A
                                                                                              CSF011
 
      * Build buffer with required output
      ** RegData is being used for regional enhancement and therefore should                BUG10202
      ** always be the last data to form the buffer if no ExtData included                  BUG10202
      ** otherwise it should be positioned before ExtData                                   BUG10202
     C                   MOVE      C_TMST        @TimeStamp       26                         BUG1569
     C                   EVAL      Buffer = NewTrPrim + NewTrSeco +
     C                                      NewTrPrev             +                         BUG11194
     C                                      NewTrExch + NewTrSett +
     C                                      NewTrChCm + NewTrSwftA +
     C                                      NewTrSwftB +
     C**********                            NewX2SwftA + NewX2SwftB +                        CSF011A
     C                                    NewX2SwftA + %SUBST(NewX2SwftB:1:2228)             CSF011A
     C************                          NewTrThir +                                      BUG1569
     C**********                            NewTrThir +  @TimeStamp +                BUG1569 CSF011A
     C**********                            SPBS + STBS + PROT + NomCcySWCY +                CSF011A
     C**********                            CustClass  + BVAUTH +                            CSF011A
     C**********                            DDCPNR + DDTCTR + DDCFCT +                       CSF011A
     C**********                            A_DDROUS + A_DDROTS +                            CSF011A
     C**********                            A_DDROUC + A_DDROTC +                            CSF011A
     C**********                            B_DDROUS + B_DDROTS +                            CSF011A
     C**********                            B_DDROUC + B_DDROTC +                            CSF011A
     C**********                            DDSPXR + DDSPMD + DDWTAX +                       CSF011A
     C************                          BKEURO + DDSTAT + DDAUTH                          MLFIX1
     C**********                            BKEURO + DDSTAT + DDAUTH +                MLFIX1 CSF011A
     C**********                            SITP                                      MLFIX1 CSF011A
     C**********                            + DDPRICN + DDHACR                        BUG6496 CER001
     C**********                            + DDPRICN + DDHACR + RegData              CER001 BUG9584
     C**********                            + DDPRICN + DDHACR + InfData            BUG9584 BUG10202
     C**********                            + RegData                               BUG9584 BUG10202
     C**********                            + DDPRICN + DDHACR                      BUG10202 CSF011A
     C**********                            + Out_Value + Out_DaysYear                CAP087 CSF011A
     C**********                            + RegData                            BUG010202 AR698195B
     C**********                            + DDFRNT + AAuth + Regdata              AR698195B CER049
     C**********                            + DDFRNT + StampTax                       CER049 CSF011A
     C**********                            + AAuth                                   CER049 CSF011A
     C**********                            + Regdata                                 CER049 CSF011A
     C                   EVAL      Buffer2 = %SUBST(NewX2SwftB:2229:211)                     CSF011A
     C                                    + NewTrThir +  @TimeStamp                          CSF011A
     C                                    + SPBS + STBS + PROT + NomCcySWCY                  CSF011A
     C                                    + CustClass  + BVAUTH                              CSF011A
     C                                    + DDCPNR + DDTCTR + DDCFCT                         CSF011A
     C                                    + A_DDROUS + A_DDROTS                              CSF011A
     C                                    + A_DDROUC + A_DDROTC                              CSF011A
     C                                    + B_DDROUS + B_DDROTS                              CSF011A
     C                                    + B_DDROUC + B_DDROTC                              CSF011A
     C                                    + DDSPXR + DDSPMD + DDWTAX                         CSF011A
     C                                    + BKEURO + DDSTAT + DDAUTH                         CSF011A
     C                                    + SITP   + DDPRICN                                 CSF011A
     C                                    + DDHACR + Out_Value + Out_DaysYear                CSF011A
     C                                    + DDFRNT + StampTax + AAuth + Regdata              CSF011A
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     SETRADRED     BEGSR
      *
     C                   MOVE      *BLANKS       ReturnCode
      *
     C                   CALLB     'SETRADRED'
      *
      * INPUT PARAMETERS
      *
      * Return Code
     C                   PARM                    ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      PMode
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * TRADE REF. POINTER
     C                   PARM                    DDTDRF_In
      *
      * Front Office ID
     C                   PARM                    DDFRTN
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK
      *
      * OUTPUT PARAMETERS
      *
      * Error message
     C                   PARM      *BLANK        PErrMs
      *
      * TRADE REF. READ
     C                   PARM      *BLANK        PTrSnSel
      *
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED
 
     C                   ENDSR
      **********************************************************************
     C     SETRADRTV     BEGSR
 
     C                   MOVE      *BLANKS       ReturnCode
     C                   EVAL      Idx = 0
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
      *
     C                   CALLB     'SETRADRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        ReturnCode
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      '      '      PMode
      * Response mode
     C                   PARM      'S'           @RSMD
      * Action Code
     C                   PARM                    DDACTN
      * Front Office Transaction ID
     C                   PARM                    FOTRID
      * (Midas) Trade Reference
     C                   PARM                    DDTDRF
      * MT5XX - Phase 2 Message Generation is on.
     C                   PARM                    CSW003
      *
      * Buy-sell back
     C                   PARM                    PFBYSL
      *
      * Trade Reference
     C                   PARM                    DDTDRF
      * OUTPUTS :
      * (Current) TRADE in file format
     C                   PARM                    CrTrFilFmt
     C                   PARM                    CT1AFilFmt
     C                   PARM                    CT1BFilFmt
      * OK - Action code
     C                   PARM      *BLANK        OKACTN
      * OK - Trade Reference
     C                   PARM      *BLANK        OKTDRF
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
 
      * Get TRADSDX2 records
 
     C                   CALLB     'SETRADRTV2'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * (Midas) Trade Reference
     C                   PARM                    DDTDRF
      * MT5XX - Phase 2 Message Generation is on.
     C                   PARM                    CSW003
      * OUTPUTS :
      * (Current) TRADSDX2 in file format
     C                   PARM                    TX2AFilFmt
     C                   PARM                    TX2BFilFmt
 
     C                   ENDSR
      **********************************************************************
     C     SETRADCVT     BEGSR
 
     C                   MOVE      *BLANKS       ReturnCode
      *
     C                   CALLB     'SETRADCVT'
      *
      * INPUTS :
      * Return Code
      * TRADE in file format
     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    CrTrFilFmt
     C                   PARM                    CT1AFilFmt
     C                   PARM                    CT1BFilFmt
      ** Hedge Accounting Phase B
 
     C                   PARM                    CAS006
                                                                                              CGL031
      ** Taxation of Savings Income                                                           CGL031
     C                   PARM                    CGL031                                       CGL031
 
      * OUTPUTS
      * Trade - screen formats
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrThir
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrChCm
     C                   PARM                    NewTrSwftA
     C                   PARM                    NewTrSwftB
 
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
 
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
 
      ** Settlement Currency Details
     C                   PARM                    SetCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      * Trade Status
      * Trade Authorized/Not Authorized
     C                   PARM                    DDSTAT            9
     C                   PARM                    DDAUTH           14
      * Security report name
      * Customer report name
     C                   PARM                    DDSRNME
     C                   PARM                    DDCRNM           20
      * Coupon Rate
      * Current Factor
      * Margin Amount
      * Portfolio Exchange Rate
      * Portfolio M/D Ind
      * Trade Countervalue
      * Withholding Tax
     C                   PARM                    DDCPNR           13
     C                   PARM                    DDCFCT           12
     C                   PARM                    DDMAMT           18
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    DDTCTR           21
     C                   PARM                    DDWTAX
     C                   PARM                    DDPRICN
      * SCREEN A
      * Destination of Settlement
      * Destination of Confirmation
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      * SCREEN B
      * Destination of Settlement
      * Destination of Confirmation
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
     C                   PARM                    DDFRNT                                    AR698195B
 
      * Converse TRADSDX2 into Screen Format
 
     C                   CALLB     'SETRADCVT2'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * (Current) TRADSDX2 in file format
     C                   PARM                    TX2AFilFmt
     C                   PARM                    TX2BFilFmt
     C                   PARM                    CSW206                                      CSW206E
     C                   PARM                    CSW210                                       CSW210
      * OUTPUTS :
      * (Screen) TRADSDX2
     C                   PARM                    NewX2SwftA
     C                   PARM                    NewX2SwftB
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************                       CER001
      *                                                                                       CER001
      * SETRAD2RV - Retrieve TRAD Extension File                                              CER001
      *                                                                                       CER001
      *****************************************************************                       CER001
     C     SETRAD2RV     BEGSR                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'SETRAD2RV'                                                CER001
     C                   PARM      *BLANKS       RetCodeOut                                   CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM      *BLANKS       FOTRID                                       CER001
     C                   PARM                    DDTDRF                                       CER001
     C                   PARM                    TRADLUXFilFmt                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
      * SETRAD2CT - Convert TRAD Extension File to Screen Format                              CER001
      *                                                                                       CER001
      *****************************************************************                       CER001
     C     SETRAD2CT     BEGSR                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'SETRAD2CT'                                                CER001
     C                   PARM                    RetCodeOut                                   CER001
     C                   PARM                    DDTDRF                                       CER001
     C                   PARM                    TRADLUXFilFmt                                CER001
     C                   PARM                    RegData                                      CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CAP087
      *****************************************************************                       CAP087
      * CalcDays - Calculate Days in a Year                                                   CAP087
      *****************************************************************                       CAP087
     C     CalcDays      BEGSR                                                                CAP087
                                                                                              CAP087
      ** For non-interest bearing securities, some of the parameters for                      CAP087
      ** ZDYYR are unknown.  In this case, set Divisor Basis to '3' and                       CAP087
      ** Next Coupon Date to the Value Date of the Buy-Sell Back.                             CAP087
     C                   IF        PROT = '2' or PROT = '4' or PROT = '7'                     CAP087
     C                   EVAL      DVBS = '3'                                                 CAP087
     C                   EVAL      NCD = C_TDVD                                               CAP087
     C                   ENDIF                                                                CAP087
                                                                                              CAP087
     C                   CALLB     'ZDYYR'                                                    CAP087
     C                   PARM                    DYBS                                         CAP087
     C                   PARM                    DVBS                                         CAP087
     C                   PARM                    ISSD                                         CAP087
     C                   PARM                    ITLD                                         CAP087
     C                   PARM                    LCPN                                         CAP087
     C                   PARM                    FCPN                                         CAP087
     C                   PARM                    MATY                                         CAP087
     C                   PARM                    IADJ                                         CAP087
     C                   PARM                    CDArr                                        CAP087
     C                   PARM                    CRArr                                        CAP087
     C                   PARM                    CPNR                                         CAP087
     C                   PARM                    DADJN             1                          CAP087
     C                   PARM                    NCD               5 0                        CAP087
     C                   PARM                    ECD               5 0                        CAP087
     C                   PARM                    BJDFIN                                       CAP087
                                                                                             BUG9961
      ** Holiday Currencies                                                                  BUG9961
                                                                                             BUG9961
     C                   PARM                    HCY1              3                         BUG9961
     C                   PARM                    HCY2              3                         BUG9961
     C                   PARM                    HCY3              3                         BUG9961
     C                   PARM                    HCY4              3                         BUG9961
     C                   PARM                    HCY5              3                         BUG9961
     C                   PARM                    HCY6              3                         BUG9961
     C                   PARM                    HCY7              3                         BUG9961
     C                   PARM                    HCY8              3                         BUG9961
     C                   PARM                    HCY9              3                         BUG9961
     C                   PARM      *Zeros        ZINTDD            5 0                        CAP087
     C                   PARM                    LCDD5             5 0                        CAP087
                                                                                              CAP087
     C                   Z-ADD     ZINTDD        DaysInYear                                   CAP087
     C                   MOVE      DaysInYear    Out_DaysYear                                 CAP087
                                                                                              CAP087
     C                   Z-ADD     C_TCSR        Trade_Value                                  CAP087
     C                   MOVE      *BLANKS       ZFIELD                                       CAP087
     C                   MOVE      Trade_Value   ZFIELD                                       CAP087
     C                   Z-ADD     NomCcyDec     ZADEC                                        CAP087
     C                   CALLB     'ZEDIT'                                                    CAP087
     C                   PARM                    ZFIELD           16                          CAP087
     C                   PARM                    ZADEC             1 0                        CAP087
     C                   MOVE      ZFIELD        Out_Value                                    CAP087
                                                                                              CAP087
     C                   ENDSR                                                                CAP087
      *****************************************************************                       CAP087
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustname - Get the Customer details                         *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustName    BEGSR                                                                CSF011
      ** Customer fields for retrieval of details                                             CSF011
     C                   EVAL      %SUBST(WNumDetlIn:1:35)   = DDCNUM                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:36:35)  = DDPYFM                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:71:35)  = DDPAYT                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:106:35) = DDTDFA                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:141:35) = DDDELF                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:176:35) = DDDELT                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:211:35) = DDDFFA                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:246:35) = DDDTFA                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:281:35) = A_ESAP1N                       CSF011
     C                   EVAL      %SUBST(WNumDetlIn:316:35) = A_ESAP2N                       CSF011
     C                   EVAL      %SUBST(WNumDetlIn:351:35) = A_ESAWIN                       CSF011
     C                   EVAL      %SUBST(WNumDetlIn:386:35) = A_ESBOFN                       CSF011
     C                   EVAL      %SUBST(WNumDetlIn:421:35) = A_ESIPYN                       CSF011
     C                   EVAL      %SUBST(WNumDetlIn:456:35) = A_ESINVE                       CSF011
     C                   EVAL      %SUBST(WNumDetlIn:491:35) = A_ESSA1N                      CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:526:35) = A_ESSKAN                       CSF011
     C                   EVAL      %SUBST(WNumDetlIn:561:35) = A_ESCCTN                       CSF011
     C                   EVAL      %SUBST(WNumDetlIn:596:35) = A_ESRSSN                       CSF011
     C                   EVAL      %SUBST(WNumDetlIn:631:35) = A_T2IMD1                       CSF011
     C                   EVAL      %SUBST(WNumDetlIn:666:35) = A_T2IMD2                       CSF011
     C                   EVAL      %SUBST(WNumDetlIn:701:35) = A_ESPSET                       CSF011
     C                   EVAL      CusIdx = 1                                                 CSF011
                                                                                              CSF011
     C                   DOW       CusIdx <= NoOfCusField                                     CSF011
                                                                                              CSF011
     C                   EVAL      P@Str = %SUBST(WNumDetlIn:CusIdx2:35)                      CSF011
     C                   EVAL      W@Abc = %SUBST(CusOrAcc:CusIdx:1)                          CSF011
                                                                                              CSF011
     C                   IF        P@Str <> *BLANKS                                           CSF011
                                                                                              CSF011
     C                   IF        W@Abc = 'C' OR W@Abc  = 'B'                                CSF011
     C                   EVAL      WCustomer = *BLANKS                                       CSF011A
                                                                                              CSF011
      ** Customer Type                                                                        CSF011
                                                                                              CSF011
     C                   CALL      'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY'        @OPTN                                        CSF011
     C                   PARM                    P@Str                                       CSF011A
     C                   PARM      *BLANKS       C#KYST                                       CSF011
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   CALL      'AOIBANR2'                                                CSF011A
     C                   PARM      *Blanks       @RTCD                                       CSF011A
     C                   PARM                    P@Str                                       CSF011A
     C                   PARM                    DSSDY                                       CSF011A
                                                                                              CSF011
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      ACCNT = DSSDY                                             CSF011A
     C                   EVAL      WCustomer = AC_CNUM                                       CSF011A
                                                                                              CSF011
     C                   ELSE                                                                 CSF011
                                                                                              CSF011
     C                   EVAL      WBrch = DDBRCD                                             CSF011
                                                                                              CSF011
      ** Pay from branch for GL Accounts                                                      CSF011
     c                   IF        CusIdx = 2 AND DDPYFB <> *BLANKS                           CSF011
     C                   EVAL      WBrch = DDPYFB                                             CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
      ** Pay to branch for GL Accounts                                                        CSF011
     c                   IF        CusIdx = 3 AND DDPYTB <> *BLANKS                           CSF011
     C                   EVAL      WBrch = DDPYTB                                             CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
      ** Account Type                                                                         CSF011
      ** Nostro Account                                                                       CSF011
     C                   SELECT                                                              CSF011A
     C                   WHEN      %LEN(%TRIM(P@Str)) = 2                                    CSF011A
     C                   EVAL      P@Str = DDSETC + %SUBST(P@Str:1:2)                         CSF011
      ** GL Accounts                                                                          CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 18                                   CSF011A
     C                   EVAL      P@Str = WBrch + %SUBST(P@Str:1:6) +                        CSF011
     C                                     DDSETC + %SUBST(P@Str:7:12)                        CSF011
     C                   ENDSL                                                               CSF011A
                                                                                              CSF011
     C                   CALL      'AOACCTV1'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      *BLANKS       P@TYP                                        CSF011
     C                   PARM                    P@Str                                        CSF011
     C                   PARM                    DSSDY                                        CSF011
                                                                                              CSF011
      ** Retrieve Account Details, Customer Shortname, Report Name,                           CSF011
      ** and Town, Account Name and Swift ID                                                  CSF011
                                                                                              CSF011
     C                   SELECT                                                               CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*RETAIL' OR                                       CSF011
     C                             P@TYP = '*LEDGER'                                          CSF011
     C                   EVAL      ACCNT = DSSDY                                              CSF011
     C                   EVAL      WCustomer = AC_CNUM                                        CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*NOSTRO'                                          CSF011
     C                   EVAL      SDNOST = DSSDY                                             CSF011
     C                   EVAL      WCustomer = NO_A7CUST                                      CSF011
     C                   CALL      'AOACCTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY   '     @OPTN                                        CSF011
     C                   PARM      *BLANKS       P0RETL                                       CSF011
     C                   PARM                    NO_A7CUST                                    CSF011
     C                   PARM                    NO_A7CYCD                                    CSF011
     C                   PARM                    NO_A7ACCD                                    CSF011
     C                   PARM                    NO_A7ACSN                                    CSF011
     C                   PARM                    NO_A7BRCD                                    CSF011
     C     ACCNT         PARM                    DSSDY                                        CSF011
     C                   WHEN      P@TYP = '*CUSTNO' OR                                      CSF011A
     C                             P@TYP = '*SHNAME'                                         CSF011A
     C                   EVAL      SDCUST = DSSDY                                            CSF011A
     C                   EVAL      WCustomer = *BLANKS                                       CSF011A
                                                                                             CSF011A
     C                   WHEN      P@TYP = '*NRF   '                                         CSF011A
     C                   EVAL      WCustomer = *BLANKS                                       CSF011A
     C                   ENDSL                                                                CSF011
                                                                                              CSF011
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   IF         WCustomer <> *BLANKS                                     CSF011A
     C                   CALL      'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY'        @OPTN                                        CSF011
     C                   PARM                    WCustomer                                    CSF011
     C                   PARM      *BLANKS       C#KYST                                       CSF011
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
     C                   ENDIF                                                               CSF011A
                                                                                              CSF011
     C                   IF        @RTCD = *BLANKS                                            CSF011
     C                   EXSR      SrXferCustName                                            CSF011A
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
      ** Increment counter fields                                                             CSF011
                                                                                              CSF011
     C                   IF        W@Abc = 'A'                                                CSF011
     C                   Z-ADD     AccLength     W@Len                                        CSF011
     C                   ELSEIF    W@Abc = 'B'                                                CSF011
     C                   Z-ADD     ACusLngth     W@Len                                        CSF011
     C                   ELSE                                                                 CSF011
     C                   Z-ADD     CusLength     W@Len                                        CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                               CSF011A
                                                                                              CSF011
     C                   EVAL      CusIdx = Cusidx + 1                                        CSF011
     C                   EVAL      CusIdx2 = Cusidx2 + 35                                     CSF011
                                                                                              CSF011
     C                   ENDDO                                                                CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * SrXferCustName - Transfer Customer Details to Security Detls  *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     SrXferCustNameBEGSR                                                               CSF011A
                                                                                            AR903401
     C                   SELECT                                                             AR903401
                                                                                            AR903401
      ** Counterparty                                                                        CSF011A
     C                   WHEN      CusIdx = 1                                               AR903401
     C                   EVAL      DDCTSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCTNM = BBCRNM                                           CSF011A
     C                   EVAL      DDCTTN = BBCRTN                                           CSF011A
      ** Pay From                                                                            CSF011A
     C                   WHEN      CusIdx = 2                                               AR903401
     C                   EVAL      DDPFSN = BBCSSN                                           CSF011A
     C                   EVAL      DDPFNM = BBCRNM                                           CSF011A
     C                   EVAL      DDPFTN = BBCRTN                                           CSF011A
     C                   EVAL      DDPFAN = AC_ANAM                                          CSF011A
     C                   EVAL      DDPFSW = BBCSID                                           CSF011A
      ** Pay To                                                                              CSF011A
     C                   WHEN      CusIdx = 3                                               AR903401
     C                   EVAL      DDPTSN = BBCSSN                                           CSF011A
     C                   EVAL      DDPTNM = BBCRNM                                           CSF011A
     C                   EVAL      DDPTTN = BBCRTN                                           CSF011A
     C                   EVAL      DDPTAN = AC_ANAM                                          CSF011A
     C                   EVAL      DDPTSW = BBCSID                                           CSF011A
      ** Pay to for Account Of                                                               CSF011A
     C                   WHEN      CusIdx = 4                                               AR903401
     C                   EVAL      DDFASN = BBCSSN                                           CSF011A
     C                   EVAL      DDFANM = BBCRNM                                           CSF011A
     C                   EVAL      DDFATN = BBCRTN                                           CSF011A
     C                   EVAL      DDFASW = BBCSID                                           CSF011A
      ** Deliver From                                                                        CSF011A
     C                   WHEN      CusIdx = 5                                               AR903401
     C                   EVAL      DDDFSN = BBCSSN                                           CSF011A
     C                   EVAL      DDDFNM = BBCRNM                                           CSF011A
     C                   EVAL      DDDFTN = BBCRTN                                           CSF011A
     C                   EVAL      DDDFSW = BBCSID                                           CSF011A
      ** Deliver To                                                                          CSF011A
     C                   WHEN      CusIdx = 6                                               AR903401
     C                   EVAL      DDDTSN = BBCSSN                                           CSF011A
     C                   EVAL      DDDTNM = BBCRNM                                           CSF011A
     C                   EVAL      DDDTTN = BBCRTN                                           CSF011A
     C                   EVAL      DDDTSW = BBCSID                                           CSF011A
      ** Deliver from for Account Of                                                         CSF011A
     C                   WHEN      CusIdx = 7                                               AR903401
     C                   EVAL      DDVFSN = BBCSSN                                           CSF011A
     C                   EVAL      DDVFNM = BBCRNM                                           CSF011A
     C                   EVAL      DDVFTN = BBCRTN                                           CSF011A
     C                   EVAL      DDVFSW = BBCSID                                           CSF011A
      ** Deliver to for Account Of                                                           CSF011A
     C                   WHEN      CusIdx = 8                                               AR903401
     C                   EVAL      DDVTSN = BBCSSN                                           CSF011A
     C                   EVAL      DDVTNM = BBCRNM                                           CSF011A
     C                   EVAL      DDVTTN = BBCRTN                                           CSF011A
     C                   EVAL      DDVTSW = BBCSID                                           CSF011A
      ** Account for Payment 1                                                               CSF011A
     C                   WHEN      CusIdx = 9                                               AR903401
     C                   EVAL      A_ESP1SN = BBCSSN                                         CSF011A
     C                   EVAL      A_ESP1NM = BBCRNM                                         CSF011A
     C                   EVAL      A_ESP1TN = BBCRTN                                         CSF011A
     C                   EVAL      A_ESP1SW = BBCSID                                         CSF011A
      ** Account for Payment 2                                                               CSF011A
     C                   WHEN      CusIdx = 10                                              AR903401
     C                   EVAL      A_ESP2SN = BBCSSN                                         CSF011A
     C                   EVAL      A_ESP2NM = BBCRNM                                         CSF011A
     C                   EVAL      A_ESP2TN = BBCRTN                                         CSF011A
     C                   EVAL      A_ESP2SW = BBCSID                                         CSF011A
      ** Account with Institution                                                            CSF011A
     C                   WHEN      CusIdx = 11                                              AR903401
     C                   EVAL      A_ESAWSN = BBCSSN                                         CSF011A
     C                   EVAL      A_ESAWNM = BBCRNM                                         CSF011A
     C                   EVAL      A_ESAWTN = BBCRTN                                         CSF011A
     C                   EVAL      A_ESAWSW = BBCSID                                         CSF011A
      ** Beneficiary Money                                                                   CSF011A
     C                   WHEN      CusIdx = 12                                              AR903401
     C                   EVAL      A_ESBOSN = BBCSSN                                         CSF011A
     C                   EVAL      A_ESBONM = BBCRNM                                         CSF011A
     C                   EVAL      A_ESBOTN = BBCRTN                                         CSF011A
     C                   EVAL      A_ESBOSW = BBCSID                                         CSF011A
      ** Instructing Party                           I                                       CSF011A
     C                   WHEN      CusIdx = 13                                              AR903401
     C                   EVAL      A_ESIPSN = BBCSSN                                         CSF011A
     C                   EVAL      A_ESIPNM = BBCRNM                                         CSF011A
     C                   EVAL      A_ESIPTN = BBCRTN                                         CSF011A
     C                   EVAL      A_ESIPSW = BBCSID                                         CSF011A
      ** Investor                                                                            CSF011A
     C                   WHEN      CusIdx = 14                                              AR903401
     C                   EVAL      A_ESIVSN = BBCSSN                                         CSF011A
     C                   EVAL      A_ESIVNM = BBCRNM                                         CSF011A
     C                   EVAL      A_ESIVTN = BBCRTN                                         CSF011A
     C                   EVAL      A_ESIVSW = BBCSID                                         CSF011A
      ** Counterparty safekeeper                                                             CSF011A
     C                   WHEN      CusIdx = 15                                              AR903401
     C                   EVAL      A_ESCSSN = BBCSSN                                         CSF011A
     C                   EVAL      A_ESCSNM = BBCRNM                                         CSF011A
     C                   EVAL      A_ESCSTN = BBCRTN                                         CSF011A
     C                   EVAL      A_ESCSSW = BBCSID                                         CSF011A
      ** Safekeeping                                                                         CSF011A
     C                   WHEN      CusIdx = 16                                              AR903401
     C                   EVAL      A_ESSKSN = BBCSSN                                         CSF011A
     C                   EVAL      A_ESSKNM = BBCRNM                                         CSF011A
     C                   EVAL      A_ESSKTN = BBCRTN                                         CSF011A
     C                   EVAL      A_ESSKSW = BBCSID                                         CSF011A
      ** Clearing Correspondent                                                              CSF011A
     C                   WHEN      CusIdx = 17                                              AR903401
     C                   EVAL      A_ESCRSN = BBCSSN                                         CSF011A
     C                   EVAL      A_ESCRNM = BBCRNM                                         CSF011A
     C                   EVAL      A_ESCRTN = BBCRTN                                         CSF011A
     C                   EVAL      A_ESCRSW = BBCSID                                         CSF011A
      ** Receiver of Securities                                                              CSF011A
     C                   WHEN      CusIdx = 18                                              AR903401
     C                   EVAL      A_ESRESN = BBCSSN                                         CSF011A
     C                   EVAL      A_ESRENM = BBCRNM                                         CSF011A
     C                   EVAL      A_ESRETN = BBCRTN                                         CSF011A
     C                   EVAL      A_ESRESW = BBCSID                                         CSF011A
      ** Intermediary 1                                                                      CSF011A
     C                   WHEN      CusIdx = 19                                              AR903401
     C                   EVAL      A_ESI1SN = BBCSSN                                         CSF011A
     C                   EVAL      A_ESI1NM = BBCRNM                                         CSF011A
     C                   EVAL      A_ESI1TN = BBCRTN                                         CSF011A
     C                   EVAL      A_ESI1SW = BBCSID                                         CSF011A
      ** Intermediary 2                                                                      CSF011A
     C                   WHEN      CusIdx = 20                                              AR903401
     C                   EVAL      A_ESI2SN = BBCSSN                                         CSF011A
     C                   EVAL      A_ESI2NM = BBCRNM                                         CSF011A
     C                   EVAL      A_ESI2TN = BBCRTN                                         CSF011A
     C                   EVAL      A_ESI2SW = BBCSID                                         CSF011A
      ** Placement of Settlement                                                             CSF011A
     C                   WHEN      CusIdx = 21                                              AR903401
     C                   EVAL      A_ESPSSN = BBCSSN                                         CSF011A
     C                   EVAL      A_ESPSNM = BBCRNM                                         CSF011A
     C                   EVAL      A_ESPSTN = BBCRTN                                         CSF011A
     C                   EVAL      A_ESPSSW = BBCSID                                         CSF011A
     C                   ENDSL                                                              AR903401
     C                                                                                       CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * SrCustname2 - Get the Customer details for Settle Details 2   *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     SrCustName2   BEGSR                                                               CSF011A
     C                   CLEAR                   WNumDetlIn                                  CSF011A
      ** Customer fields for retrieval of details                                            CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:1:35)   = B_ESAP1L                      CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:36:35)  = B_ESAP2N                      CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:71:35)  = B_ESAWIN                      CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:106:35) = B_ESBOFN                      CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:141:35) = B_ESIPYN                      CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:176:35) = B_ESINVE                      CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:211:35) = B_ESSA1N                      CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:246:35) = B_ESSKAN                      CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:281:35) = B_ESCCTN                      CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:316:35) = B_ESRSSN                      CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:351:35) = B_ESIMMD1                     CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:386:35) = B_ESIMMD2                     CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:421:35) = B_ESPSET                      CSF011A
     C                   EVAL      CusIdx = 1                                                CSF011A
     C                   EVAL      CusIdx2 = 1                                               CSF011A
                                                                                             CSF011A
     C                   DOW       CusIdx <= NoOfCusField2                                   CSF011A
                                                                                             CSF011A
     C                   EVAL      P@Str = %SUBST(WNumDetlIn:CusIdx2:35)                     CSF011A
                                                                                             CSF011A
     C                   IF        P@Str <> *BLANKS                                          CSF011A
                                                                                             CSF011A
     C                   CALL      'AOCUSTR0'                                                CSF011A
     C                   PARM      *BLANKS       @RTCD                                       CSF011A
     C                   PARM      '*KEY'        @OPTN                                       CSF011A
     C                   PARM                    P@Str                                       CSF011A
     C                   PARM      *BLANKS       C#KYST                                      CSF011A
     C     SDCUST        PARM      SDCUST        DSSDY                                       CSF011A
                                                                                             CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EXSR      SrXferCustNam2                                            CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Increment counter fields                                                            CSF011A
                                                                                             CSF011A
     C                   EVAL      CusIdx = Cusidx + 1                                       CSF011A
     C                   EVAL      CusIdx2 = Cusidx2 + 35                                    CSF011A
                                                                                             CSF011A
     C                   ENDDO                                                               CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * SrXferCustNam2 - Transfer Customer Details to Security Detls2 *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     SrXferCustNam2BEGSR                                                               CSF011A
     C                   SELECT                                                              CSF011A
      ** Account for Payment 1                                                               CSF011A
     C                   WHEN      CusIdx = 1                                                CSF011A
     C                   EVAL      B_ESP1SN = BBCSSN                                         CSF011A
     C                   EVAL      B_ESP1NM = BBCRNM                                         CSF011A
     C                   EVAL      B_ESP1TN = BBCRTN                                         CSF011A
     C                   EVAL      B_ESP1SW = BBCSID                                         CSF011A
      ** Account for Payment 2                                                               CSF011A
     C                   WHEN      CusIdx = 2                                                CSF011A
     C                   EVAL      B_ESP2SN = BBCSSN                                         CSF011A
     C                   EVAL      B_ESP2NM = BBCRNM                                         CSF011A
     C                   EVAL      B_ESP2TN = BBCRTN                                         CSF011A
     C                   EVAL      B_ESP2SW = BBCSID                                         CSF011A
      ** Account with Institution                                                            CSF011A
     C                   WHEN      CusIdx = 3                                                CSF011A
     C                   EVAL      B_ESAWSN = BBCSSN                                         CSF011A
     C                   EVAL      B_ESAWNM = BBCRNM                                         CSF011A
     C                   EVAL      B_ESAWTN = BBCRTN                                         CSF011A
     C                   EVAL      B_ESAWSW = BBCSID                                         CSF011A
      ** Beneficiary Money                                                                   CSF011A
     C                   WHEN      CusIdx = 4                                                CSF011A
     C                   EVAL      B_ESBOSN = BBCSSN                                         CSF011A
     C                   EVAL      B_ESBONM = BBCRNM                                         CSF011A
     C                   EVAL      B_ESBOTN = BBCRTN                                         CSF011A
     C                   EVAL      B_ESBOSW = BBCSID                                         CSF011A
      ** Instructing Party                           I                                       CSF011A
     C                   WHEN      CusIdx = 5                                                CSF011A
     C                   EVAL      B_ESIPSN = BBCSSN                                         CSF011A
     C                   EVAL      B_ESIPNM = BBCRNM                                         CSF011A
     C                   EVAL      B_ESIPTN = BBCRTN                                         CSF011A
     C                   EVAL      B_ESIPSW = BBCSID                                         CSF011A
      ** Investor                                                                            CSF011A
     C                   WHEN      CusIdx = 6                                                CSF011A
     C                   EVAL      B_ESIVSN = BBCSSN                                         CSF011A
     C                   EVAL      B_ESIVNM = BBCRNM                                         CSF011A
     C                   EVAL      B_ESIVTN = BBCRTN                                         CSF011A
     C                   EVAL      B_ESIVSW = BBCSID                                         CSF011A
      ** Counterparty safekeeper                                                             CSF011A
     C                   WHEN      CusIdx = 7                                                CSF011A
     C                   EVAL      B_ESCSSN = BBCSSN                                         CSF011A
     C                   EVAL      B_ESCSNM = BBCRNM                                         CSF011A
     C                   EVAL      B_ESCSTN = BBCRTN                                         CSF011A
     C                   EVAL      B_ESCSSW = BBCSID                                         CSF011A
      ** Safekeeping                                                                         CSF011A
     C                   WHEN      CusIdx = 8                                                CSF011A
     C                   EVAL      B_ESSKSN = BBCSSN                                         CSF011A
     C                   EVAL      B_ESSKNM = BBCRNM                                         CSF011A
     C                   EVAL      B_ESSKTN = BBCRTN                                         CSF011A
     C                   EVAL      B_ESSKSW = BBCSID                                         CSF011A
      ** Clearing Correspondent                                                              CSF011A
     C                   WHEN      CusIdx = 9                                                CSF011A
     C                   EVAL      B_ESCRSN = BBCSSN                                         CSF011A
     C                   EVAL      B_ESCRNM = BBCRNM                                         CSF011A
     C                   EVAL      B_ESCRTN = BBCRTN                                         CSF011A
     C                   EVAL      B_ESCRSW = BBCSID                                         CSF011A
      ** Receiver of Securities                                                              CSF011A
     C                   WHEN      CusIdx = 10                                               CSF011A
     C                   EVAL      B_ESRESN = BBCSSN                                         CSF011A
     C                   EVAL      B_ESRENM = BBCRNM                                         CSF011A
     C                   EVAL      B_ESRETN = BBCRTN                                         CSF011A
     C                   EVAL      B_ESRESW = BBCSID                                         CSF011A
      ** Intermediary 1                                                                      CSF011A
     C                   WHEN      CusIdx = 11                                               CSF011A
     C                   EVAL      B_ESI1SN = BBCSSN                                         CSF011A
     C                   EVAL      B_ESI1NM = BBCRNM                                         CSF011A
     C                   EVAL      B_ESI1TN = BBCRTN                                         CSF011A
     C                   EVAL      B_ESI1SW = BBCSID                                         CSF011A
      ** Intermediary 2                                                                      CSF011A
     C                   WHEN      CusIdx = 12                                               CSF011A
     C                   EVAL      B_ESI2SN = BBCSSN                                         CSF011A
     C                   EVAL      B_ESI2NM = BBCRNM                                         CSF011A
     C                   EVAL      B_ESI2TN = BBCRTN                                         CSF011A
     C                   EVAL      B_ESI2SW = BBCSID                                         CSF011A
      ** Placement of Settlement                                                             CSF011A
     C                   WHEN      CusIdx = 13                                               CSF011A
     C                   EVAL      B_ESPSSN = BBCSSN                                         CSF011A
     C                   EVAL      B_ESPSNM = BBCRNM                                         CSF011A
     C                   EVAL      B_ESPSTN = BBCRTN                                         CSF011A
     C                   EVAL      B_ESPSSW = BBCSID                                         CSF011A
     C                   ENDSL                                                               CSF011A
     C                                                                                       CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                       CSF011
      /EJECT                                                                                  CER001
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
      ** Entry parameters.
      *
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDTDRF_In         6
     C                   PARM                    Buffer         6000
     C                   PARM                    Buffer2        3999                         CSF011A
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SEUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,SETRADM01
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *                                                                                       CAP087
      * Access bank details via access program                                                CAP087
      * (database error handling done in access program)                                      CAP087
     C                   CALLB     'AOBANKR0'                                                 CAP087
     C                   PARM      '*DBERR '     @RTCD             7                          CAP087
     C                   PARM      '*FIRST '     @OPTN             7                          CAP087
     C     SDBANK        PARM      SDBANK        DSFDY                                        CAP087
      *
      ** Access midas modules details to determine if strategic
      ** risk management indicator is on.
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access ICD details for securities trading.
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*FIRST '     POptn
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Setup Authorisation level
      *
     C                   IF        ReturnCode <> *BLANKS
     C                   EVAL      BVAUTH = '50'
     C                   ENDIF
      *
      ** Access SAR details file to determine if CSW003
      ** (MT5XX - Phase 2 message generation) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSW003'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C*****@RTCD         IFEQ      *BLANK                                                    BUG5557
     C     ReturnCode    IFEQ      *BLANK                                                    BUG5557
     C                   MOVEL     'Y'           CSW003
     C                   ELSE
     C                   MOVEL     'N'           CSW003
     C                   END
      *
      ** Check if enhancement CAS006 (Hedge Accounting Phase B) is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CAS006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      CAS006 = 'Y'
     C                   ELSE
     C                   EVAL      CAS006 = 'N'
     C                   ENDIF
      *                                                                                       CER001
      ** Check if ULX603 is installed                                                         CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX603'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS AND @RTCD <> '*NRF   '                    CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX603'                                          CER001
     C                   EVAL      DBASE  = 903                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   EVAL      ULX603 = 'Y'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX603 = 'N'                                               CER001
     C                   ENDIF                                                                CER001
                                                                                            BUG6496R
     C     KSECEO        KLIST                                                              BUG6496R
     C                   KFLD                    SE_SDSN                                    BUG6496R
     C                   KFLD                    SE_SDET                                    BUG6496R
     C                   KFLD                    SE_SDED                                    BUG6496R
      ** Check if CGL031 is enabled.                                                          CGL031
                                                                                              CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtCd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
     C                   EVAL      CGL031 = 'N'                                               CGL031
                                                                                              CGL031
     C                   IF        PRtCd = *BLANKS                                            CGL031
     C                   EVAL      CGL031 = 'Y'                                               CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
     C                   IF        PRtCd <> '*NRF   '                                         CGL031
     C     *LOCK         IN        LDA                                                        CGL031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
     C                   EVAL      DBKey = PSARD                                              CGL031
     C                   EVAL      DBase = 101                                                CGL031
     C                   OUT       LDA                                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   CALL      'SWIF2006'                                                CSW206E
     C                   PARM      *BLANKS       PRTCD                                       CSW206E
                                                                                             CSW206E
     C                   IF        PRTCD = 'CSW2006'                                         CSW206E
     C                   EVAL      CSW206 = 'Y'                                              CSW206E
     C                   ELSE                                                                CSW206E
     C                   EVAL      CSW206 = 'N'                                              CSW206E
     C                   ENDIF                                                               CSW206E
      *                                                                                       CSW210
      ** Check to see if switchable feature CSW210 is on or if date is                        CSW210
      ** equal or greater than 20 November 2010.                                              CSW210
      *                                                                                       CSW210
     C                   CALL      'SWIF2010'                                                 CSW210
     C                   PARM      *BLANKS       PRTCD                                        CSW210
                                                                                              CSW210
     C                   IF        PRTCD = 'CSW2010'                                          CSW210
     C                   EVAL      CSW210 = 'Y'                                               CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      CSW210 = 'N'                                               CSW210
     C                   ENDIF                                                                CSW210
 
     C                   ENDSR
 
      *****************************************************************                     BUG6496R
      *                                                               *                     BUG6496R
      *  RtNetCpn - Retrieve Net Treasury Coupon Rate                 *                     BUG6496R
      *                                                               *                     BUG6496R
      *****************************************************************                     BUG6496R
                                                                                            BUG6496R
     C     RtNetCpn      BEGSR                                                              BUG6496R
                                                                                            BUG6496R
      ** Get Net Treasury Coupon Rate                                                       BUG6496R
                                                                                            BUG6496R
     C                   EVAL      SE_SDSN = DDSESN                                         BUG6496R
     C                   EVAL      SE_SDET = 'IR'                                           BUG6496R
     C                   EVAL      SE_SDED = C_TDVD                                         BUG6496R
                                                                                            BUG6496R
     C     KSECEO        SETLL     SEDEVDF                                                  BUG6496R
     C                   READ      SEDEVDF                                01                BUG6496R
                                                                                            BUG6496R
     C                   IF        *IN01 = *OFF  AND  SE_SDSN = DDSESN  AND                 BUG6496R
     C                             SE_SDET = 'IR'                                           BUG6496R
     C                   EVAL      WrkNTCR = SE_SDNN                                        BUG6496R
     C                   ELSE                                                               BUG6496R
     C                   EVAL      WrkNTCR = CPNN                                           BUG6496R
     C                   ENDIF                                                              BUG6496R
                                                                                            BUG6496R
      ** Format screen field                                                                BUG6496R
                                                                                            BUG6496R
     C                   IF        WrkNTCR <> 0                                             BUG6496R
     C                   MOVE      *BLANKS       ZFLD15                                     BUG6496R
     C                   MOVE      WrkNTCR       ZFLD15                                     BUG6496R
     C                   EVAL      ZDECS = 7                                                BUG6496R
     C                   EVAL      ZECODE = *BLANK                                          BUG6496R
                                                                                            BUG6496R
     C                   CALLB     'ZSEDIT'                                                 BUG6496R
     C                   PARM                    ZFLD15                                     BUG6496R
     C                   PARM                    ZDECS                                      BUG6496R
     C                   PARM                    ZECODE                                     BUG6496R
     C                   PARM                    ZOUT21                                     BUG6496R
                                                                                            BUG6496R
     C                   MOVE      ZOUT21        DDHACR                                     BUG6496R
     C                   ENDIF                                                              BUG6496R
                                                                                            BUG6496R
     C                   ENDSR                                                              BUG6496R
      *****************************************************************
      /EJECT
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
