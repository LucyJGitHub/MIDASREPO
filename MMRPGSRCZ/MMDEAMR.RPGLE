     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Deal amendments retrieve a record')           *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market                                         *
      *                                                               *
      *  MMDEAMR - MM Deal Amendments retrieve a record               *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. 260173             Date 22May20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 30May14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239400             Date 26Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9891            Date 16Jan06               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 BUG6534            Date 08Apr05               *
      *                 BUG6012            Date 18Feb05               *
      *                 BUG4146            Date 31Aug04               *
      *                 BUG2774            Date 25May04               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 TCA002             Date 26Mar04               *
      *                 CAP084  *CREATE    Date 07Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  260173 - Introduce new parameter in DEAM API to be used in   *
      *           the validation of action code during reversal       *
      *           authorization. Apply fix 258724.                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  239400 - Add Front Office ID to be used by SOAP Interface    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9891 - Recompile                                          *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG6534 - Condition settlement tabs on a Loan/Deposit        *
      *            indicator LONDEP.                                  *
      *  BUG6012 - Add interface and extension data to buffer         *
      *  BUG4146 - Stopping two users to update the same record at the*
      *            same time.                                         *
      *  BUG2774 - Error in Settlement Details.                       *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  TCA002 - 10-Digit Account Code Errors - Retrieve a/c details.*
      *  CAP084 - API wrapper project                                 *
      *                                                               *
      *****************************************************************

     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)                                      BUG6534
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------

      ** Program Status Data Structure                                                       BUG6534
      ** =============================                                                       BUG6534
      ** The following /COPY line includes all the defined fields in the                     BUG6534
      ** PSDS.  They have meaningful names, prefixed by 'PS'.                                BUG6534
                                                                                             BUG6534
     D/COPY ZACPYSRC,PSDS                                                                    BUG6534
      ** The following /COPY line includes definitions for the above fields                  BUG6534
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the                         BUG6534
      ** corresponding fields in the PSDS /COPY member, so that member                       BUG6534
      ** must be included where this one is used.                                            BUG6534
                                                                                             BUG6534
     D/COPY ZACPYSRC,PROCPARMS                                                               BUG6534
                                                                                             BUG6534
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** SCREEN FORMATS
      **-----------------------------------------------------------------------

     D DealScnFmt    E DS                  EXTNAME(MMDEAMPD)
      * Deal in Screen Format

     D InfData       E DS                  EXTNAME(MMDAIFPD)                                 BUG6012
      * Interface file data                                                                  BUG6012
                                                                                             BUG6012
     D ExtData       E DS                  EXTNAME(MMDAEXPD)                                 BUG6012
      * Extension data                                                                       BUG6012
                                                                                             BUG6012
     D TranInCust    E DS                  EXTNAME(SDCUCUPD)                                  CER043
      ** Customers Extension Screen Format based on SDCUCUPD                                  CER043
                                                                                              CER043
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** SCREEN RECEIVE INSTRUCTIONS

     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** SCREEN PAYMENT INSTRUCTIONS

     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      ** SCREEN FRA/IRS INSTRUCTIONS

      **-----------------------------------------------------------------------
      ** FILE FORMATS
      **-----------------------------------------------------------------------

     D DealFilFmt    E DS                  EXTNAME(MMDEAMPP)
      ** Deal in File Format

     D*MMVDRecIns***         314    368                                               TCA002 BUG2774
     D*MMVDPayIns***         383    927                                               TCA002 BUG2774
     D MMVDRecIns            314    382                                                      BUG2774
     D MMVDPayIns            383    941                                                      BUG2774
     D*MMVDRecIns************300    368                                                       TCA002
     D*MMVDPayIns************369    927                                                       TCA002
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)

     D**FHREC****************400    468                                                       TCA002
     D**FHPAY****************469   1027                                                       TCA002

     D ##RECF        E DS                  EXTNAME(SDESFRPD)
     D**FLREC******************1     69                                                       TCA002
     D  FLREC2                21     75                                                       TCA002
      ** FILE RECEIVE INSTRUCTIONS

     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
     D**FLPAY******************1    559                                                       TCA002
     D  FLPAY2                21    565                                                       TCA002
      *** FILE PAYMENT INSTRUCTIONS

     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      ** FILE FRA/IRS INSTRUCTIONS

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER043
      ** External DS for SAR details                                                          CER043
                                                                                              CER043
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER043
      * First DS for Access programs - short data structure                                   CER043
                                                                                              CER043
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CER043
      * Second DS for Access programs - long data structure                                   CER043
                                                                                              CER043
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CER043
      ** External DS for Customer Details                                                     CER043
                                                                                              CER043
      **-----------------------------------------------------------------------

     D CER043          S              1A                                                      CER043
      *                                                                                       CER043
      ** Parameters for Calling AOCUSTR0                                                      CER043
     D PRtcd           S              7A                                                      CER043
     D POptn           S              7A                                                      CER043
     D PCNum           S             10A                                                      CER043
     D PKey7           S              7A                                                      CER043
                                                                                              CER043
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
     D LONDEP          S              1                                                      BUG6534
     D DEALNR          S              6  0                                                   BUG6534
     D DDFOID          S             20                                                       239400
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A

      **-----------------------------------------------------------------------

     C                   CLEAR                   DealFilFmt
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
     C                   EXSR      MMDEAMRED
     C                   ELSE
     C                   MOVEL     DDDLNO_In     @DLRED
     C                   MOVEL     DDVDAT_IN     @VDRED
     C                   MOVEL     DDDS38_In     @SQRED
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
     C                   MOVEL     @FTRED        APFOTranID
     C                   MOVEL     @FARED        APFOAsocID
     C                   MOVEL     @VDRED        DDVDAT
     C                   MOVEL     @SQRED        DDDS38
     C                   EXSR      MMDEAMRTV
      *
      * Convert to screeen format
      *
     C     Idx           IFEQ      0
     C                   EXSR      MMDEAMCVT
     C                   EXSR      ZASETINCVT
      *                                                                                      BUG6534
      * Distinguish loans from deposits for conditioning settlement tabs.                    BUG6534
     C                   MOVEL     ' '           LONDEP                                      BUG6534
     C                   IF        DDDLNO    <> *BLANKS                                      BUG6534
     C                   MOVEL     DDDLNO        DEALNR                                      BUG6534
     C     DEALNR        CHAIN     MMDEALLL                           30                     BUG6534
      *                                                                                      BUG6534
     C                   IF        HKMTYP = 'IT' OR HKMTYP = 'TD'                            BUG6534
     C                             OR HKMTYP = 'CI' OR HKMTYP = 'CD'                         BUG6534
     C                   MOVEL     'D'           LONDEP                                      BUG6534
     C                   ELSE                                                                BUG6534
     C                   MOVEL     'L'           LONDEP                                      BUG6534
     C                   ENDIF                                                               BUG6534
     C                   ENDIF                                                               BUG6534
      *                                                                                      BUG6534
     C                   ENDIF

     C                   ENDIF

     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDDLNO'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF

     C                   MOVEL     HNTMST        @TimeStamp       26                         BUG4146
      *                                                                                       CER043
      ** Population of Customer Details                                                       CER043
     C                   IF        CER043 = 'Y'                                               CER043
     C                   EXSR      SrPopCust                                                  CER043
     C                   ENDIF                                                                CER043
      *                                                                                       CER043
     C                   EVAL                    Buffer = DealScnfmt
     C**********                                          + @TimeStamp               BUG4146 BUG6534
     C**********                                 + @TimeStamp + LONDEP                BUG6534 CER043
     C                                           + @TimeStamp                                 CER043
     C                                           + TranIncust                                 CER043
     C                                           + LONDEP                                     CER043
     C                                           + DDFOID                                     239400
     C                                           + @ACTRV                                     260173
     C                                           + ##RECS  + ##PAYS
     C                                           + InfData                                   BUG6012
     C                                           + ExtData                                   BUG6012

     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDDLNO_In         6
     C                   PARM                    DDVDAT_In         6
     C                   PARM                    DDDS38_In         3
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
     C                   PARM                    @ACTRV            1                          260173

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'

      *                                                                                       CER043
      ** Check if CER043 is switched on                                                       CER043
                                                                                              CER043
     C                   CALL      'AOSARDR0'                                                 CER043
     C                   PARM      *BLANKS       PRTCD                                        CER043
     C                   PARM      '*VERIFY'     POPTN                                        CER043
     C                   PARM      'CER043'      PSARD             6                          CER043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
                                                                                              CER043
     C                   IF        PRTCD = *BLANKS                                            CER043
     C                   EVAL      CER043 = 'Y'                                               CER043
     C                   ELSE                                                                 CER043
     C                   EVAL      CER043 = 'N'                                               CER043
                                                                                              CER043
     C                   IF        PRTCD <> '*NRF'                                            CER043
     C     *LOCK         IN        LDA                                                        CER043
     C                   EVAL      DBKEY = 'CER043'                                           CER043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
     C                   EVAL      DBASE = 901                                                CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      *PSSR                                                      CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   ENDIF                                                                CER043
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,MMDEAMM01

     C                   ENDSR

      **********************************************************************
      /EJECT
      **********************************************************************
     C     MMDEAMRED     BEGSR
      *
     C                   CALLB     'MMDEAMRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM      DDDLNO_In     DDDLNO            6
      *
      * Front Office ID
     C                   PARM                    DDFRTN           20
     C                   PARM      DDVDAT_In     DDVDAT            6
     C                   PARM      DDDS38_In     DDDS38            3
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
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
      *
      * Front Office Associated ID READ
     C                   PARM      *BLANK        @FARED           20
      *
      * VALUE DATE READ
     C                   PARM      *BLANK        @VDRED            6
      *
      * SEQUENCE NUMBER READ
     C                   PARM      *BLANK        @SQRED            3

     C                   ENDSR
      **********************************************************************
     C     MMDEAMRTV     BEGSR

     C                   CALLB     'MMDEAMRTV'

      * INPUTS

      * Return code
     C                   PARM                    ReturnCode

      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE        1

      * Action Code
     C                   PARM                    DDACTN            1

      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20

      * Front Office Associated Transaction Id
     C                   PARM                    APFOAsocID       20

      * (Midas) Deal Number
     C                   PARM                    DDDLNO

      * Value Date
     C                   PARM                    DDVDAT
      *
      * Sequence Number
     C                   PARM                    DDDS38
      *
      * Deal Amendment Amount
     C                   PARM                    DDAMNP
      *
      * Deal Amendment Type
     C                   PARM                    DDMTYP
      * Action Code (Reversal transaction)                                                    260173
     C                   PARM                    @ACTRV                                       260173

      * OUTPUTS

      * (Current) deal in file format
     C                   PARM                    DealFilFmt

      * OK - Action code
     C                   PARM                    DDActnOK          1

      * OK - Deal Number
     C                   PARM                    DDDlnoOK          1

      * OK - Value Date
     C                   PARM                    DDVDatOK          1

      * OK - Sequence Number
     C                   PARM                    DDDS38OK          1

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM                    Idx

     C                   ENDSR
      *****************************************************************
     C     MMDEAMCVT     BEGSR

     C                   CALLB     'MMDEAMCVT'

      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt

      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      * Deal Status
     C                   PARM                    DDSTS            24

      ** AMEND CHECKING
     C                   RESET                   ReturnCode

     C                   EVAL      DDFOID = HNFRNT                                            239400
                                                                                              239400
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     ZASETINCVT    BEGSR
      *
      * SET UP PAYMENT INSTRUCTIONS FROM DEAL
      *
     C*******************MOVEL     MMVDPayIns    FLPAY                                        TCA002
     C                   MOVEL     HNPSTM        FLPSTM                                       TCA002
     C                   MOVEL     HNPONS        FLPONS                                       TCA002
     C                   MOVEL     MMVDPayIns    FLPAY2                                       TCA002
     C                   MOVEL     HNOSBR        FLPOBR
     C                   MOVEL     HNCVMR        FLCVMR
     C                   MOVEL     HNSTCY        FLPSCY
     C                   MOVEL     HNIC72        FLIC72
      *
      * SET UP RECEIVE INSTRUCTIONS FROM DEAL
      *
     C*******************MOVEL     MMVDRecIns    FLREC                                        TCA002
     C                   MOVEL     HNRSTM        FLRSTM                                       TCA002
     C                   MOVEL     HNRONS        FLRONS                                       TCA002
     C                   MOVEL     MMVDRecIns    FLREC2                                       TCA002
     C                   MOVEL     HNOSBR        FLROBR
     C                   MOVEL     HNSTCY        FLRSCY
     C                   MOVEL     HNRBB1        FLRBB1                                       CDL094
     C                   MOVEL     HNRBB2        FLRBB2                                       CDL094
     C                   MOVEL     HNRBB3        FLRBB3                                       CDL094
     C                   MOVEL     HNRBB4        FLRBB4                                       CDL094
     C                   MOVEL     HNRBB5        FLRBB5                                       CDL094
     C                   MOVEL     HNRBB6        FLRBB6                                       CDL094
      *
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
      ** File FRA/IRS Settlement Instruction
     C                   PARM      *BLANK        ##FRIF
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
     C                   PARM      DDCCY         InRCCY                                      CSF011A
     C                   PARM      DDCCY         InPCCY                                      CSF011A
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                 BUG6534
     C/COPY ZACPYSRC,PSSR_ILE                                                                BUG6534
      ********************************************************************                   BUG6534
      /EJECT                                                                                  CER043
      *****************************************************************                       CER043
      *                                                               *                       CER043
      *  SrPopCust - Subroutine to Populate Customer Details          *                       CER043
      *                                                               *                       CER043
      *  Called by: MAIN Processing                                   *                       CER043
      *                                                               *                       CER043
      *  Calls: SrRtvCust                                             *                       CER043
      *                                                               *                       CER043
      *****************************************************************                       CER043
      *                                                                                       CER043
     C     SrPopCust     BEGSR                                                                CER043
      *                                                                                       CER043
     C                   CLEAR                   TranInCust                                   CER043
      *                                                                                       CER043
      ** Retrieve Customer Details                                                            CER043
     C                   IF        DDCSNM <> *BLANKS                                          CER043
     C                   EVAL      PCNum = DDCSNM                                             CER043
      *                                                                                       CER043
     C                   EXSR      SrRtvCust                                                  CER043
     C                   IF        PRtcd = *BLANKS                                            CER043
     C                   EVAL      DDCSSN = BBCSSN                                            CER043
     C                   EVAL      DDCRNM = BBCRNM                                            CER043
     C                   EVAL      DDCRTN = BBCRTN                                            CER043
     C                   ENDIF                                                                CER043
      *                                                                                       CER043
     C                   ENDIF                                                                CER043
      *                                                                                       CER043
     C                   ENDSR                                                                CER043
      *****************************************************************                       CER043
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
      *                                                                                       CER043
     C                   ENDSR                                                                CER043
      *****************************************************************                       CER043
      /EJECT                                                                                  CER043
      *****************************************************************                       CER043
**  CPY@
(c) Finastra International Limited 2003
