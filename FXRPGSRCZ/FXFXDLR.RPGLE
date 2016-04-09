     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Retrieve a record')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange ILE Module                          *
      *                                                               *
      *  FXFXDLR   - FX Foreign Exchange retrieve a record            *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CSW214             Date 25Nov14               *
      *  Prev Amend No. CDL094             Date 30May14               *
      *                 CSW213             Date 03Jun13               *
      *                 CSW212             Date 03May12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 261692             Date 19Nov09               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 BUG4562            Date 10Mar05               *
      *                 BUG4087            Date 26Aug04               *
      *                 CFX114             Date 15Jun04               *
      *                 CTI004             Date 12Apr04               *
      *                 CDL018             Date 03Feb04               *
      *                 TCA002             Date 26Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 16Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on Inputs                             *
      *  261692 - Amended so that system can get the associated       *
      *           front office ID from JAVA.                          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG4562- Retrieve TRAM details                               *
      *  BUG4087- Stopping users updating the same record at the same *
      *           time.                                               *
      *  CFX114 - Core changes for GBO014                             *
      *         - Perform Override when Exchange Rate Tolerance is    *
      *           exceeded.                                           *
      *         - Upgrade to Midasplus                                *
      *  CTI004 - MidasPlus-TI Integration Enhancements               *
      *           FX Deals Integration                                *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TCA002 - 10-Digit Account Code Errors - Retrieve a/c details.*
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Java wrapper project                                *
      *                                                               *
      *****************************************************************
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** SCREEN FORMATS
      **--------------------------------------------------------------------------------------------
 
     D DealScnFmt    E DS                  EXTNAME(FXFXDLPD)
      * Deal in Screen Format
 
     D*TranInCust    E DS                  EXTNAME(SDCUCUPD)                           CER043 CSF011
      ***Customers*Extension*Screen*Format*based*on*SDCUCUPD                           CER043 CSF011
                                                                                              CER043
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** SCREEN RECEIVE INSTRUCTIONS
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** SCREEN PAYMENT INSTRUCTIONS
 
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ** SCREEN FRA/IRS INSTRUCTIONS
 
      **--------------------------------------------------------------------------------------------
      ** FILE FORMATS
      **--------------------------------------------------------------------------------------------
 
     D DealFilFmt    E DS                  EXTNAME(FXDEALPP)
      ** Deal in File Format
     D  FHREC                414    468                                                       TCA002
     D  FHPAY                483   1027                                                       TCA002
     D**FHREC****************400    468                                                       TCA002
     D**FHPAY****************469   1027                                                       TCA002
     D  FH@ISDA             1394   2043                                                       CSW212
 
     D InfData       E DS                  EXTNAME(FXFXIFPD)                                  CTI004
      * FX (FXDL) Extra Data - File (D/B) format                                              CTI004
                                                                                              CTI004
     D ExtData       E DS                  EXTNAME(FXFXEXPD)                                  CSW213
      * FX Extra Data - File (D/B) format                                                     CSW213
                                                                                              CSW213
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
     D**FLREC******************1     69                                                       TCA002
     D  FLREC2                21     75                                                       TCA002
      ** FILE RECEIVE INSTRUCTIONS
 
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
     D**FLPAY******************1    559                                                       TCA002
     D  FLPAY2                21    565                                                       TCA002
      *** FILE PAYMENT INSTRUCTIONS
 
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ***FILE*FRA/IRS*INSTRUCTIONS*************************************                       CSW212
      ** Extended Settlement Instructions                                                     CSW212
     D  FL@ISDA                1    650                                                       CSW212
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER043
      ** External DS for SAR details                                                          CER043
                                                                                              CER043
      ** Midas DL Dealing Reporting Information file                                          CSW213
     D DLRPIFScn1Fmt E DS                  EXTNAME(DLRIS1PD)                                  CSW213
     D DLRPIFScn2Fmt E DS                  EXTNAME(DLRIS2PD)                                  CSW213
     D DLRPIFScn3Fmt E DS                  EXTNAME(DLRIS3PD)                                  CSW213
     D DLRPIFScn4Fmt E DS                  EXTNAME(DLRIS4PD)                                  CSW214
     D DLRPIFFileFmt E DS                  EXTNAME(DLRPIFPD)                                  CSW213
     D PDlRILkpd     E DS                  EXTNAME(DLRILKPD)                                  CSW213
                                                                                              CSW213
      ** Define data structure for InSwift2013                                                CSW213
     D InSwift2013     DS                                                                     CSW213
     D  DLRPIFS1In                         LIKE(DLRPIFScn1Fmt)                                CSW213
     D  DLRPIFS2In                         LIKE(DLRPIFScn2Fmt)                                CSW213
     D  DLRPIFS3In                         LIKE(DLRPIFScn3Fmt)                                CSW213
     D  DLRPIFS4In                         LIKE(DLRPIFScn4Fmt)                                CSW214
                                                                                              CSW213
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
 
      ** DS for access programs - long data structure                                         CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
                                                                                              CGL029
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR DEALING DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CER043
      ** External DS for Customer Details                                                     CER043
      *                                                                                       CER043
      **--------------------------------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Timestamp                                                                           BUG4087
     D @Timestamp      S             26                                                      BUG4087
                                                                                             BUG4087
     D*CER043***       S              1A                                               CER043 CSF011
      *                                                                                       CER043
      ** Parameters for Calling AOCUSTR0                                                      CER043
     D PRtcd           S              7A                                                      CER043
     D POptn           S              7A                                                      CER043
     D PCNum           S             10A                                                      CER043
     D PKey7           S              7A                                                      CER043
                                                                                              CER043
      ** Deal Front Office ID                                                                 CTI004
     D DDFOID          S             20                                                       CTI004
      ** Deal Associated Front Office ID                                                      261692
     D DDAFID          S             20                                                       261692
                                                                                              CTI004
     D GBO014          S             21    INZ('')                                            CFX114
                                                                                              CSW213
      ** Work Variables for DLRPIFR                                                           CSW213
     D PRetCode        S             10                                                       CSW213
     D PModeOp         S              6                                                       CSW213
     D PTranRefOK      S              1                                                       CSW213
     D DFOfcrIDOK      S              1                                                       CSW213
     D WNoRepFlag      S              1                                                       CSW213
                                                                                              CSW213
     D CSW213          S              1                                                       CSW213
                                                                                              CSW213
      **--------------------------------------------------------------------------------------------
 
     C                   CLEAR                   DealFilFmt
     C                   CLEAR                   PDlRILkpd                                    CSW213
                                                                                             CSF011A
     C                   EVAL      DDCRSN = *BLANKS                                          CSF011A
     C                   EVAL      DDCRNM = *BLANKS                                          CSF011A
     C                   EVAL      DDCRTN = *BLANKS                                          CSF011A
                                                                                             CSF011A
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
     C                   EXSR      FXFXDLRED
     C                   ELSE
     C                   MOVEL     DDDLNO_In     @DLRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal read
      * and no error message returned
      *
     C     @DLRED        IFNE      *BLANK
     C     @ERRMS        ANDEQ     *BLANK
      *
      * Retrieve deal details
      *
     C                   MOVEL     @DLRED        DDDLNO
     C                   EXSR      FXFXDLRTV
                                                                                             BUG4562
      *                                                                                      BUG4562
      * Retrieve TRAM details                                                                BUG4562
      *                                                                                      BUG4562
     C                   EXSR      FXFXDLRTT                                                 BUG4562
                                                                                             BUG4562
      *
      * Convert to screeen format
      *
     C     Idx           IFEQ      0
     C                   EXSR      FXFXDLCVT
     C                   EXSR      ZASETINCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDDLNO'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
      *                                                                                       CSW213
      ** Setup fields in link file if CSW213 is on.                                           CSW213
      *                                                                                       CSW213
     C                   IF        CSW213 = 'Y'                                               CSW213
     C                   EXSR      SRGetRPIF                                                  CSW213
     C                   EVAL      DLRPIFS1In = DLRPIFScn1Fmt                                 CSW213
     C                   EVAL      DLRPIFS2In = DLRPIFScn2Fmt                                 CSW213
     C                   EVAL      DLRPIFS3In = DLRPIFScn3Fmt                                 CSW213
     C                   EVAL      DLRPIFS4In = DLRPIFScn4Fmt                                 CSW214
     C                   ENDIF                                                                CSW213
 
     C                   MOVE      FHTMST        @Timestamp                                  BUG4087
      *                                                                                       CER043
      ** Population of Customer Details                                                       CER043
     C**********         IF        CER043 = 'Y'                                        CER043 CSF011
     C**********         EXSR      SrPopCust                                           CER043 CSF011
     C**********         ENDIF                                                         CER043 CSF011
      *                                                                                       CER043
     C                   EXSR      SrCustName                                                 CSF011
     C                   EVAL                    Buffer = DealScnfmt
     C                                           + DDNBRF  + DDNSRF
     C                                           + DDSTS   + BNNMAM
     C**********                                 + BJLCCY                                     CTI004
     C                                           + BJLCCY  + DDFOID                           CTI004
     C                                           + DDAFID                                     261692
     C                                           + GBO014                                     CFX114
     C                                           + CPST     + DSPCP                          BUG4562
     C                                           + BKST     + DSPBK                          BUG4562
     C                                           + @Timestamp                                BUG4087
     C**********                                 + TranIncust                          CER043 CSF011
     C                                           + ##RECS  + ##PAYS
     C                                           + ##FRIS                                     CSW212
     C                                           + InfData                                    CTI004
     C                                           + ExtData + InSwift2013                      CSW213
 
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustname - Get the Customer details                         *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustName    BEGSR                                                                CSF011
                                                                                              CSF011
      ** Customer Number                                                                     CSF011A
                                                                                             CSF011A
     C                   IF        DDCUST <> *BLANKS                                         CSF011A
     C                   EVAL      PCnum = DDCUST                                            CSF011A
     C                   EXSR      SrRtvCust                                                 CSF011A
     C                   IF        PRtcd = *BLANKS                                           CSF011A
     C                   EVAL      DDCRSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCRNM = BBCRNM                                           CSF011A
     C                   EVAL      DDCRTN = BBCRTN                                           CSF011A
     C                   ENDIF                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                       CSF011
      /EJECT                                                                                  CSF011
      **********************************************************************
 
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDDLNO_In         6
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
      * Hook to enable non-core message files to be included
     D/COPY WNCPYSRC,FXFXDLM01
 
      ** ACCESS DEALING DETAILS
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      **********                                                                       CER043 CSF011
      ***Check*if*CER043*is*switched*on********************************                CER043 CSF011
      **********                                                                       CER043 CSF011
     C**********         CALL      'AOSARDR0'                                          CER043 CSF011
     C**********         PARM      *BLANKS       @RTCD                                 CER043 CSF011
     C**********         PARM      '*VERIFY'     @OPTN                                 CER043 CSF011
     C**********         PARM      'CER043'      @SARD             6                   CER043 CSF011
     C*****SCSARD        PARM      SCSARD        DSFDY                                 CER043 CSF011
      **********                                                                       CER043 CSF011
     C**********         IF        @RTCD = *BLANKS                                     CER043 CSF011
     C**********         EVAL      CER043 = 'Y'                                        CER043 CSF011
     C**********         ELSE                                                          CER043 CSF011
     C**********         EVAL      CER043 = 'N'                                        CER043 CSF011
      **********                                                                       CER043 CSF011
     C**********         IF        @RTCD <> '*NRF'                                     CER043 CSF011
     C******LOCK         IN        LDA                                                 CER043 CSF011
     C**********         EVAL      DBKEY = 'CER043'                                    CER043 CSF011
     C**********         EVAL      DBFILE = 'SCSARDPD'                                 CER043 CSF011
     C**********         EVAL      DBASE = 905                                         CER043 CSF011
     C**********         OUT       LDA                                                 CER043 CSF011
     C**********         EXSR      *PSSR                                               CER043 CSF011
     C**********         ENDIF                                                         CER043 CSF011
      **********                                                                       CER043 CSF011
     C**********         ENDIF                                                         CER043 CSF011
      *                                                                                       CSW212
      ** Check if SWIFT 2012  is on                                                           CSW212
      *                                                                                       CSW212
     C                   CALL      'SWIF2012'                                                 CSW212
     C                   PARM      *BLANKS       @RTCD                                        CSW212
      *                                                                                       CSW212
     C     @RTCD         IFEQ      'CSW2012'                                                  CSW212
     C                   MOVEL     'Y'           CSW212            1                          CSW212
     C                   ELSE                                                                 CSW212
     C                   MOVEL     'N'           CSW212                                       CSW212
      *                                                                                       CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
      ** Check if SWIFT 2013  is on                                                           CSW213
      *                                                                                       CSW213
     C                   MOVEL     *BLANKS       CSW213                                       CSW213
     C                   CALL      'SWIF2013'                                                 CSW213
     C                   PARM      *BLANKS       PRtCd                                        CSW213
      *                                                                                       CSW213
     C     PRtCd         IFEQ      'CSW2013'                                                  CSW213
     C                   MOVEL     'Y'           CSW213                                       CSW213
     C                   ELSE                                                                 CSW213
     C                   MOVEL     'N'           CSW213                                       CSW213
      *                                                                                       CSW213
     C                   ENDIF                                                                CSW213
      *                                                                                       CSW213
     C                   ENDSR
      **********************************************************************
     C     FXFXDLRED     BEGSR
 
     C                   CALLB     'FXFXDLRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut       10
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM      DDDLNO_In     DDDLNO            6
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
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
      * DEAL NUMBER READ
     C                   PARM      *BLANK        @DLRED            6
      *
      * Front Office Deal Read
     C                   PARM                    @FTRED           20
 
     C                   ENDSR
      **********************************************************************
     C     FXFXDLRTV     BEGSR
 
     C                   CALLB     'FXFXDLRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeIn        10
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      *BLANK        ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO            6
      *
      * (Midas) Swap/Option Deal Number
     C                   PARM                    DDSDNO            6
      *
      * Booking branch
     C                   PARM                    DDBRSN            3
      *
      * Originating branch
     C                   PARM                    DDORBR            3
      *
      * OUTPUTS
      *
      * (Current) deal in file format
     C                   PARM                    DealFilFmt
      *
      * OK - Action code
     C                   PARM      'Y'           DDActnOK          1
      *
      * OK - Deal Number
     C                   PARM      'Y'           DDDlnoOK          1
      *
      * OK - Booking branch
     C                   PARM      'Y'           DDBrsnOK          1
      *
      * OK - Originating branch
     C                   PARM      'Y'           DDOrbrOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Warning error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM      *BLANKS       WFldNamArr
     C                   PARM      *BLANKS       WMsgIdArr
     C                   PARM      *BLANKS       WMsgDtaArr
 
      ** Warning array index (3P0) from/to caller
 
     C                   PARM      *ZEROS        WIdx
 
     C                   ENDSR
      **********************************************************************
     C     FXFXDLCVT     BEGSR
 
     C                   CALLB     'FXFXDLCVT'
 
      * INPUTS
      * Return Code
     C                   PARM      *BLANK        ReturnCode       10
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
 
      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      * NET BUY/SELL REFERENCE
     C                   PARM                    DDNBRF           19
     C                   PARM                    DDNSRF           19
      * Deal Status
     C                   PARM                    DDSTS            24
                                                                                              CTI004
     C                   Eval      DDFOID = FHFRNT                                            CTI004
     C                   EVAL      DDAFID = FHAFRT                                            261692
     C                   Eval      AUTH = FHAUTH                                              CTI004
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
     C     ZASETINCVT    BEGSR
      *
      * SET UP PAYMENT INSTRUCTIONS FROM DEAL
      *
     C*******************MOVEL     FHPAY         FLPAY                                        TCA002
     C                   MOVEL     FHPSTM        FLPSTM                                       TCA002
     C                   MOVEL     FHPONS        FLPONS                                       TCA002
     C                   MOVEL     FHPAY         FLPAY2                                       TCA002
     C                   MOVEL     FHPOBR        FLPOBR
     C                   MOVEL     FHCVMR        FLCVMR
     C                   MOVEL     FHPSCY        FLPSCY
     C                   MOVEL     FHIC72        FLIC72
      *
      * SET UP RECEIVE INSTRUCTIONS FROM DEAL
      *
     C*******************MOVEL     FHREC         FLREC                                        TCA002
     C                   MOVEL     FHRSTM        FLRSTM                                       TCA002
     C                   MOVEL     FHRONS        FLRONS                                       TCA002
     C                   MOVEL     FHREC         FLREC2                                       TCA002
     C                   MOVEL     FHROBR        FLROBR
     C                   MOVEL     FHRSCY        FLRSCY
     C                   MOVEL     FHRBB1        FLRBB1                                       CDL094
     C                   MOVEL     FHRBB2        FLRBB2                                       CDL094
     C                   MOVEL     FHRBB3        FLRBB3                                       CDL094
     C                   MOVEL     FHRBB4        FLRBB4                                       CDL094
     C                   MOVEL     FHRBB5        FLRBB5                                       CDL094
     C                   MOVEL     FHRBB6        FLRBB6                                       CDL094
      *
     C                   IF        CSW212 = 'Y'                                               CSW212
     C                   MOVEL     FH@ISDA       FL@ISDA                                      CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
     C                   CALLB     'ZASETINCVT'
      *
      ** INPUTS
      *
      ** File Payment Settlement Instruction
     C                   PARM                    ##PAYF
      *
      ** File Receipt Settlement Instruction
     C                   PARM                    ##RECF
      *
      ***File*FRA/IRS*Settlement*Instruction***************************                       CSW212
     C**********         PARM      *BLANK        ##FRIF                                       CSW212
      ** File Extended Settlement Instruction                                                 CSW212
     C                   PARM                    ##FRIF                                       CSW212
      *
      ** OUTPUTS
      ** Screen Payment Settlement Instruction
     C                   PARM      *BLANK        ##PAYS
      *
      ** Screen Receipt Settlement Instruction
     C                   PARM      *BLANK        ##RECS
      *
      ** Screen FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIS
     C                   PARM      DDBCCY        #TRCCY            3                         CSF011A
     C                   PARM      DDSCCY        #TPCCY            3                         CSF011A
      *
     C                   ENDSR
      **********************************************************************                 BUG4562
     C     FXFXDLRTT     BEGSR                                                               BUG4562
                                                                                             BUG4562
     C                   CALLB     'FXFXDLRTT'                                               BUG4562
      *                                                                                      BUG4562
      * INPUTS                                                                               BUG4562
      *                                                                                      BUG4562
      * Return code                                                                          BUG4562
     C                   PARM      *BLANK        RetCodeIn        10                         BUG4562
      *                                                                                      BUG4562
      * Action Code                                                                          BUG4562
     C                   PARM                    DDACTN            1                         BUG4562
      *                                                                                      BUG4562
      * (Midas) Deal Number                                                                  BUG4562
     C                   PARM                    DDDLNO            6                         BUG4562
      *                                                                                      BUG4562
      * Broker                                                                               BUG4562
     C                   PARM                    DDBRKR            4                         BUG4562
      *                                                                                      BUG4562
      * OUTPUTS                                                                              BUG4562
      *                                                                                      BUG4562
      * OK - Action code                                                                     BUG4562
     C                   PARM      'Y'           DDActnOK          1                         BUG4562
      *                                                                                      BUG4562
      * Counterparty Status                                                                  BUG4562
     C                   PARM                    CPST              2                         BUG4562
     C                   PARM                    DSPCP             1                         BUG4562
      *                                                                                      BUG4562
      * Broker Status                                                                        BUG4562
     C                   PARM                    BKST              2                         BUG4562
     C                   PARM                    DSPBK             1                         BUG4562
      *                                                                                      BUG4562
      * Error fields/message IDs/message data (arrays) from/to caller                        BUG4562
     C                   PARM                    FldNameArr                                  BUG4562
     C                   PARM                    MsgIdArr                                    BUG4562
     C                   PARM                    MsgDtaArr                                   BUG4562
      *                                                                                      BUG4562
      * Array index (3P0) from/to caller                                                     BUG4562
     C                   PARM                    Idx                                         BUG4562
                                                                                             BUG4562
      ** Warning error fields/message IDs/message data (arrays) from/to caller               BUG4562
                                                                                             BUG4562
     C                   PARM      *BLANKS       WFldNamArr                                  BUG4562
     C                   PARM      *BLANKS       WMsgIdArr                                   BUG4562
     C                   PARM      *BLANKS       WMsgDtaArr                                  BUG4562
                                                                                             BUG4562
      ** Warning array index (3P0) from/to caller                                            BUG4562
                                                                                             BUG4562
     C                   PARM      *ZEROS        WIdx                                        BUG4562
                                                                                             BUG4562
     C                   ENDSR                                                               BUG4562
      **********************************************************************                 BUG4562
      /EJECT                                                                                  CSW213
      *****************************************************************                       CSW213
      * SRGetRPIF - Set-up Midas DL Transaction Reporting Information *                       CSW213
      *             Link File.                                        *                       CSW213
      *****************************************************************                       CSW213
     C     SRGetRPIF     BEGSR                                                                CSW213
                                                                                              CSW213
      ** Set-up input fields                                                                  CSW213
                                                                                              CSW213
     C                   EVAL      PModeOp = ModeofOp                                         CSW213
     C                   EVAL      RLAPID = 'FXDL'                                            CSW213
     C                   EVAL      RLACTN = DDACTN                                            CSW213
     C                   EVAL      RLBRCA = DDBRSN                                            CSW213
     C                   EVAL      RLTRRF = DDDLNO                                            CSW213
     C                   EVAL      RLLTRF = DDLNKN                                            CSW213
     C                   EVAL      RLDTYP = DDDLTP                                            CSW213
     C                   EVAL      RLDLST = DDDLST                                            CSW213
     C                   EVAL      RLVALD = DDVDAT                                            CSW213
     C                   EVAL      RLCNUM = DDCUST                                            CSW213
     C                   EVAL      RLBCCY = DDBCCY                                            CSW213
     C                   EVAL      RLSCCY = DDSCCY                                            CSW213
     C                   EVAL      RLFOID = FOTRID                                            CSW213
                                                                                              CSW213
     C                   CALL      'DLRPIFR'                                                  CSW213
                                                                                              CSW213
      ** Return code                                                                          CSW213
     C                   PARM      *BLANKS       PRetCode                                     CSW213
                                                                                              CSW213
      ** Mode of operation                                                                    CSW213
     C                   PARM                    PModeOp                                      CSW213
                                                                                              CSW213
      ** RPIF Set up fields                                                                   CSW213
     C                   PARM                    PDlRILkpd                                    CSW213
                                                                                              CSW213
      ** OUTPUTS                                                                              CSW213
      ** Transaction Reference OK Flag                                                        CSW213
     C                   PARM                    PTranRefOK                                   CSW213
                                                                                              CSW213
      ** Front Office ID OK Flag                                                              CSW213
     C                   PARM                    DFOfcrIDOK                                   CSW213
                                                                                              CSW213
      ** No Report Information flag                                                           CSW213
     C                   PARM                    WNoRepFlag                                   CSW213
                                                                                              CSW213
      ** DLRPIF in File Format                                                                CSW213
     C                   PARM                    DLRPIFFileFmt                                CSW213
                                                                                              CSW213
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW213
     C                   PARM                    FldNameArr                                   CSW213
     C                   PARM                    MsgIdArr                                     CSW213
     C                   PARM                    MsgDtaArr                                    CSW213
                                                                                              CSW213
      ** Array index (3P0) from/to caller                                                     CSW213
     C                   PARM                    Idx                                          CSW213
                                                                                              CSW213
      ** Warning error fields/message IDs/message data (arrays) from/to caller                CSW213
     C                   PARM                    WFldNamArr                                   CSW213
     C                   PARM                    WMsgIdArr                                    CSW213
     C                   PARM                    WMsgDtaArr                                   CSW213
                                                                                              CSW213
      ** Warning array index (3P0) from/to caller                                             CSW213
     C                   PARM                    WIdx                                         CSW213
                                                                                              CSW213
      ** Report Information File - Screen Format                                              CSW213
     C                   PARM                    DLRPIFScn1Fmt                                CSW213
     C                   PARM                    DLRPIFScn2Fmt                                CSW213
     C                   PARM                    DLRPIFScn3Fmt                                CSW213
     C                   PARM                    DLRPIFScn4Fmt                                CSW214
     C                   ENDSR                                                                CSW213
      *****************************************************************                       CSW213
      /EJECT                                                                                  CSW213
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      ***********                                                     *                CER043 CSF011
      ***SrPopCust*-*Subroutine*to*Populate*Customer*Details***********                CER043 CSF011
      ***********                                                     *                CER043 CSF011
      ***Called*by:*MAIN*Processing************************************                CER043 CSF011
      ***********                                                     *                CER043 CSF011
      ***Calls:*SrRtvCust**********************************************                CER043 CSF011
      ***********                                                     *                CER043 CSF011
      *****************************************************************                CER043 CSF011
      ***********                                                                      CER043 CSF011
     C*****SrPopCust     BEGSR                                                         CER043 CSF011
      ***********                                                                      CER043 CSF011
     C***********        CLEAR                   TranInCust                            CER043 CSF011
      ***********                                                                      CER043 CSF011
      ***Retrieve*Customer*Details                                                     CER043 CSF011
     C***********        IF        DDCUST <> *BLANKS                                   CER043 CSF011
     C***********        EVAL      PCNum = DDCUST                                      CER043 CSF011
      ***********                                                                      CER043 CSF011
     C***********        EXSR      SrRtvCust                                           CER043 CSF011
     C***********        IF        PRtcd = *BLANKS                                     CER043 CSF011
     C***********        EVAL      DDCSSN = BBCSSN                                     CER043 CSF011
     C***********        EVAL      DDCRNM = BBCRNM                                     CER043 CSF011
     C***********        EVAL      DDCRTN = BBCRTN                                     CER043 CSF011
     C***********        ENDIF                                                         CER043 CSF011
      ***********                                                                      CER043 CSF011
     C***********        ENDIF                                                         CER043 CSF011
      ***********                                                                      CER043 CSF011
     C***********        ENDSR                                                         CER043 CSF011
      *****************************************************************                CER043 CSF011
      /EJECT                                                                                  CER043
      *****************************************************************                       CER043
      *                                                               *                       CER043
      *  SrRtvCust - Subroutine to Retrieve Customer Details          *                       CER043
      *                                                               *                       CER043
      *  Called by: SrPopCust                                         *                       CER043
      *                                                               *                       CER043
      *  Calls: None                                                  *                       CER043
      *                                                               *                       CER043
      *****************************************************************                       CER043
     C     SrRtvCust     BEGSR                                                                CER043
      *                                                                                       CER043
      ** Call AOCUSTR0 to get Customer Details                                                CER043
     C                   CALLB     'AOCUSTR0'                                                 CER043
     C                   PARM      *BLANKS       PRtcd                                        CER043
     C                   PARM      '*KEY   '     POptn                                        CER043
     C                   PARM                    PCNum                                        CER043
     C                   PARM      *BLANKS       PKey7                                        CER043
     C     SDCUST        PARM      SDCUST        DSSDY                                        CER043
                                                                                              CER043
     C                   IF        PRTCD <> *BLANKS AND                                       CER043
     C                             PRTCD <> '*NRF   '                                         CER043
     C     *LOCK         IN        LDA                                                        CER043
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        CER043
     C                   EVAL      DBASE = 904                                                CER043
     C                   EVAL      DBKEY = PCnum                                              CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      *PSSR                                                      CER043
     C                   ENDIF                                                                CER043
      *                                                                                       CER043
     C                   ENDSR                                                                CER043
      *****************************************************************                       CER043
      /EJECT                                                                                  CER043
      *****************************************************************                       CER043
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
