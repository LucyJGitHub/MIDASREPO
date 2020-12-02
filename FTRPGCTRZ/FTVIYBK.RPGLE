     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate intermediary bank')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVIYBK  - Validate Intermediary Bank                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD021318A          Date 08Aug13               *
      *  Prev Amend No. MD021318           Date 26Jul13               *
      *                 MD046248           Date 27Oct17               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CSD089             Date 07Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 257144             Date 10Oct08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 250600             Date 07Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241855             Date 04Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CSW203             Date 26May03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 22Nov99               *
      *                 CAP031  *CREATE    Date 12Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD021318A - Array index error due to incorrect position of   *
      *              adding 1 to Idx                                  *
      *  MD021318 - OPAY allowed input of account with block debit    *
      *           - Fix is to condition CSD089 overridable error      *
      *             changes when input is from HATS screen            *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CSD089 - Overrideable Errors Phase 2                         *
      *  257144 - Include lower case in ISO validation.               *
      *           Use new /COPY member SFTVALCSLL.                    *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate.(Recompile)     *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  241855 - System is not validating clearing codes for field   *
      *           56A, 56D, 57A and 57D even though it is required    *
      *           by SWIFT to be validated.                           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSW203 - SWIFT 2003 Standards Update                         *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - Recompiled for BIC Database Plus Integration        *
      *  CFT004 - IBAN, International Bank Account Number             *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **********************************************************************
      /EJECT                                                               *
      **********************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     **COPY*FTCPYSRC,SFTVALCSLE                                                               257144
      /COPY FTCPYSRC,SFTVALCSLL                                                               257144
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Warning in error.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of Warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of Warning message data.
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D*TranInThir*   E DS                  EXTNAME(FTOPY4PD)                    CFT014
     D TranInSecA    E DS                  EXTNAME(FTOPY2PD)                    CFT014
     D TranInSecB    E DS                  EXTNAME(FTOPY3PD)                    CFT014
 
      * Flags to indicate whether transaction fields are valid
     D*OKFlagsDS*    E DS                  EXTNAME(FTEOPY3PD)                   CFT014
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY2PD)                   CFT014
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      ** Array of valid swift characters
     D SWCH            S              1    DIM(47) CTDATA PERRCD(47)
 
      ** External data structure for customer number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Midas Counterparty NOSTROS
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
 
      ** Midas BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
 
      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D/COPY FTCPYSRC,SFTADDRILE
 
     D SINBDS          DS           175
     D  DSINB1Pos1             1      1                                         CFT004
     D  DSINB1                 1     35
     D  DSINB2                36     70
     D  DSINB3                71    105
     D  DSINB4               106    140
     D  DSINB5               141    175
 
     D CLSWTK          DS
     D  SW                     1     12
                                                                                CFT014
      ** Input fields passed to ME9940                                          CFT014
                                                                                CFT014
     D***I#PARM          DS           512                                              CFT014 CGL029
     D I#PARM          DS           514                                                       CGL029
      ** Field to be validated                                                  CFT014
     D  I#VFLD                 1      5                                         CFT014
      ** Pay/Receive Settlement (PAY/REC)                                       CFT014
     D  I#PR                   6      8                                         CFT014
      ** Customer/Counterparty Nostro /BIC indentified type                     CFT014
     D  I#PRTT                 9      9                                         CFT014
      ** Customer/Counterparty/BIC indentified                                  CFT014
     D  I#PRTY                10     20                                         CFT014
      ** Pay Currency                                                           CFT014
     D  I#PCCY                21     23                                         CFT014
      ** Receive Currency                                                       CFT014
     D  I#RCCY                24     26                                         CFT014
      ** Account Line                                                           CFT014
     D  I#ACLN                27     61                                         CFT014
      ** Account Line Character 1                                               CFT014
     D  I#ACC1                27     27                                         CFT014
      ** Account Line Character 2                                               CFT014
     D  I#ACC2                28     28                                         CFT014
      ** Account Line Character 3                                               CFT014
     D  I#ACC3                29     29                                         CFT014
      ** Account Line first 4 characters                                        CFT014
     D  I#ACCL                27     30                                         CFT014
      ** Account Line Clearing System                                           CFT014
     D  I#ACCS                29     30                                         CFT014
      ** Account Line No account data                                           CFT014
     D  I#SPC1                31     61                                         CFT014
      ** Message Type                                                           CFT014
     D  I#MTYP                62     64                                         CFT014
      ** Intermediary Institution for Bank to Bank validation                   CFT014
     D  I#INBT                65     65                                         CFT014
     D  I#INBK                66     76                                         CFT014
      ** Account with Institution for Bank to Bank validation                   CFT014
     D  I#AWBT                77     77                                         CFT014
     D  I#AWBK                78     88                                         CFT014
      ** Beneficiary for Bank to Bank validation                                CFT014
     D  I#BENT                89     89                                         CFT014
     D  I#BENF                90    100                                         CFT014
      ** Pay and Receive Settlement Methods                                     CFT014
     D  I#RSTM               101    102                                         CFT014
     D  I#PSTM               103    104                                         CFT014
      ** Field 53 and 54 Entered                                                CFT014
     D  I#5354               105    105                                         CFT014
      ** Midas Module                                                           CFT014
     D  I#MMOD               106    107                                         CFT014
      ** Pay and Receive Settlement Accounts                                    CFT014
     D***I#PYAC               108    125                                               CFT014 CGL029
     D***I#RCAC               126    143                                               CFT014 CGL029
     D  QQPYAC               108    125                                                       CGL029
     D  QQRCAC               126    143                                                       CGL029
      ** Transaction Type                                                       CFT014
     D  I#TTYP               144    145                                         CFT014
      ** Cover Required ?                                                       CFT014
     D  I#COVR               146    146                                         CFT014
      ** Bank to Bank Information                                               CFT014
     D  I#BTB                257    466                                         CFT014
     D  I#BTB1               257    291                                         CFT014
     D  I#BTB2               292    326                                         CFT014
     D  I#BTB3               327    361                                         CFT014
     D  I#BTB4               362    396                                         CFT014
     D  I#BTB5               397    431                                         CFT014
     D  I#BTB6               432    466                                         CFT014
     D  I#PYAC               467    490                                                       CGL029
     D  I#RCAC               491    514                                                       CGL029
                                                                                CFT014
      ** Output Parameters from ME9940                                          CFT014
                                                                                CFT014
     D O#PARM          DS           512                                         CFT014
      ** Account Line modified                                                  CFT014
     D  O#ACLN                 1     35                                         CFT014
      ** Bank to Bank Information                                               CFT014
     D  O#BTB                257    466                                         CFT014
     D  O#BTB1               257    291                                         CFT014
     D  O#BTB2               292    326                                         CFT014
     D  O#BTB3               327    361                                         CFT014
     D  O#BTB4               362    396                                         CFT014
     D  O#BTB5               397    431                                         CFT014
     D  O#BTB6               432    466                                         CFT014
                                                                                CFT014
      ** Error Information to/from ME9940                                       CFT014
                                                                                CFT014
     D X#PARM          DS           256                                         CFT014
      ** Calling Program                                                        CFT014
     D  X#CPGM                 1     10                                         CFT014
      ** Error message sent                                                     CFT014
     D  X#ERRM                12     12                                         CFT014
      ** Warning message sent                                                   CFT014
     D  X#WARN                13     13                                         CFT014
      ** Error index                                                            CFT014
     D  X#INDX                14     18  0                                      CFT014
      ** Message text to prefix error message                                   CFT014
     D  X#MSGD                19     25                                         CFT014
     D  X#MSGF                26     35                                         CFT014
      ** Fields in error                                                        CFT014
     D  X#FLDS                36     41                                         CFT014
      ** Error codes array                                                      CFT014
     D  X#ERCD                51    200                                         CFT014
     D  O#E                   51    200                                         CFT014
 
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
 
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
     D C#CNUM          S             10
     D C#KYST          S              7
     D C#OPTN          S              7
     D C#RTCD          S              7
                                                                                CFT014
      ** Program where the message from ME9940 will be sent                     CFT014
     D WPrgQ           S             10A                                        CFT014
 
     D R               S              2  0
     D Q               S              2  0
 
      * This prog only
     D ADLINE          S              1
     D ADSLON          S              1
     D ##CSID          S              1
 
      ** IBAN character test arrays                                             CFT004
     D Alpha           S              1    DIM(26) CTDATA PERRCD(26)            CFT004
     D Numeric         S              1    DIM(10) CTDATA PERRCD(10)            CFT004
                                                                                              CSW203
      ** Flag to indicate if CSW203 is switched on                                            CSW203
     D CSW203          S              1A                                                      CSW203
                                                                                              CSW203
      ** Parameter used as return code for call SWIF2003                                      CSW203
     D PRTCD           S              7A                                                      CSW203
                                                                                              CSW203
     D PMode           S              6A                                                    MD021318
      **                                                                        CFT004
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *********************************************************************
      /EJECT                                                              *
      *********************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
      *
     C                   Eval      RetCodeIn = *BlankS
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      WFldNmXAr = *Blanks
     C                   Eval      WMsgIDXAr  = *Blanks
     C                   Eval      WMsgDtaXAr = *Blanks
     C                   Eval      Idx = 0
     C                   Eval      WIx = 0
     C                   Eval      AD#1 = 'N'
     C                   Eval      AD#2 = 'N'
     C                   Eval      AD#3 = 'N'
     C                   Eval      AD#4 = 'N'
     C                   Eval      AD#5 = 'N'
     C                   Eval      AD#6 = 'N'
 
      * Validate
     C                   Exsr      VINTBNK
 
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKInb1 = 'N' or
     C                             OKInb2 = 'N' or
     C                             OKInb3 = 'N' or
     C                             OKInb4 = 'N' or
     C                             OKInb5 = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   Else                                                                 CSD089
     C                   If        OKInb1 = 'W' or                                            CSD089
     C                             OKInb2 = 'W' or                                            CSD089
     C                             OKInb3 = 'W' or                                            CSD089
     C                             OKInb4 = 'W' or                                            CSD089
     C                             OKInb5 = 'W'                                               CSD089
     C                   Eval      RetCodeIn = 'Warning'                                      CSD089
     C                   End                                                                  CSD089
     C                   End
 
      * RETURN
      *
     C                   RETURN
      ******************************************************************
      /EJECT
     C******************************************************************
     C* VINTBNK - VALIDATION INTERMEDIARY BANK                         *
      ******************************************************************
     C*
     C     VINTBNK       BEGSR
 
     C                   Eval      DSINB1 = SINB1
     C                   Eval      DSINB2 = SINB2
     C                   Eval      DSINB3 = SINB3
     C                   Eval      DSINB4 = SINB4
     C                   Eval      DSINB5 = SINB5
     C                   Eval      @INBT = *Blanks
 
      *  Receiver's Correspondent is Optional
     C                   If        SINBDS  <> *Blanks
 
     C                   If        @ACBT = *Blanks
      * Send error to screen
     C                   Move      'N'           OKInb1
     C                   Add       1             Idx
     C                   Movel     'SINB1'       FldNamXAr(Idx)
     C                   Movel     'MMA1075'     MsgIdXAr(Idx)
     C                   End
 
      * No error
     C                   If        OKInb1 <> 'N'
 
      *  ? not allowed
     C     '?'           Scan      SINB1         Y#                3 0    90
      *
     C                   If        *IN90 = *On
      * Send error to screen
     C                   Move      'N'           OKInb1
     C                   Add       1             Idx
     C                   Movel     'SINB1'       FldNamXAr(Idx)
     C                   Movel     'MMA1076'     MsgIdXAr(Idx)
     C                   End
 
      * No error
     C                   If        OKInb1 <> 'N'
 
     C                   Movel(P)  SINBDS        ADDRSS
 
      *  If first ten characters used then try to find via SDCUSTPD
     C                   If        ADCH26 = *Blanks and
     C                             ADEXCS = *Blanks and
     C                             ADSLSH <> '/' or
     C                             ADCH36 = *Blanks and
     C                             ADXCS2 = *Blanks and
     C                             ADCHK2 <> *Blanks and
     C                             ADSLSH = '/' and
     C                             ADSLS2 <> '/'
 
      *  First 10 characters should be key for SDCUST
     C                   If        ADSLSH <> '/'
     C                   Movel     ADCHK1        C#CNUM
     C                   Else
     C                   Movel     ADCHK2        C#CNUM
     C                   End
      *
      *  Call to access pgm for Customer details
     C                   CALLB     'AOCUSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm                    C#CNUM
     C                   Parm      *Blanks       C#KYST
     C     SDCUST        Parm      *Blanks       DSSDY
 
     C                   If        C#RTCD = *Blanks
 
      * Overwrite shortname
     C                   If        ADSLSH <> '/'
     C                   Movel(P)  BBCUST        SINB1
     C                   Else
     C                   Movel(P)  BBCUST        SINB2
     C                   End
 
     C                   Eval      @INBT = 'C'
 
     C                   End
     C                   End
     C                   End
     C                   End
      * No errors
     C                   If        OKInb1 <> 'N' and
     C                             @INBT = *Blanks
 
      *  If 1st 11 Chars of 1st line then SWIFT address assumed
      *  Or first is '/' and second is SWIFT Address
 
      *  If field does not begin with '/' and is not longer than 11
      *  characters, validate as a S.W.I.F.T. Address
     C                   If        ADCH26 = *Blanks and
     C                             ADEXSW = *Blanks and
     C                             ADSLSH <> '/' or
     C                             ADCH36 = *Blanks and
     C                             ADEXS2 = *Blanks and
     C                             ADSLSH = '/' and
     C                             ADSLS2 <> '/'
 
      *  First 11 characters should be key for CLSWT.
     C                   If        ADSLSH <> '/'
     C                   Movel     ADCHK1        CLSWTK
     C                   Else
     C                   Movel     ADCHK2        CLSWTK
     C                   End
 
     C                   Exsr      SWIFT
 
     C                   If        ##CSID = 'Y'
 
     C                   If        *IN31 = *On
      * Send error to screen
     C**********         Add       1             Idx                                          CSD089
     C**********         Add       1             WIx                                 CSD089 MD021318
     C                   If        ADSLSH <> '/'
     C**********         Move      'N'           OKInb1                                       CSD089
     C**********         Movel     'SINB1'       FldNamXAr(Idx)                               CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Add       1             Idx                                       MD021318A
     C                   Move      'N'           OKInb1                                     MD021318
     C                   Movel     'SINB1'       FldNamXAr(Idx)                             MD021318
     C                   ELSE                                                               MD021318
     C                   Add       1             WIx                                       MD021318A
     C                   Move      'W'           OKInb1                                       CSD089
     C                   Movel     'SINB1'       WFldNmXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   Else
     C**********         Move      'N'           OKInb2                                       CSD089
     C**********         Movel     'SINB2'       FldNamXAr(Idx)                               CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Add       1             Idx                                       MD021318A
     C                   Move      'N'           OKInb2                                     MD021318
     C                   Movel     'SINB2'       FldNamXAr(Idx)                             MD021318
     C                   ELSE                                                               MD021318
     C                   Add       1             WIx                                       MD021318A
     C                   Move      'W'           OKInb2                                       CSD089
     C                   Movel     'SINB2'       WFldNmXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End
     C**********         Movel     'MMA1077'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C**********         Add       1             Idx                              MD021318 MD021318A
     C                   Movel     'MMA1077'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Movel     'MMA1077'     WMsgIdXAr(WIx)                               CSD089
     C**********         Add       1             WIx                              MD021318 MD021318A
     C                   ENDIF                                                              MD021318
 
     C                   Else
     C                   Eval      @INBT = 'S'
      *
      *  No SWIFT address record.
     C                   If        *IN32 = *On and
     C                             *IN31 = *Off
 
      *  If text changed then warning needs to be changed
     C                   If        ADSLSH <> '/'
     C                   Movel     CLSWTK        @INB1
      * Send warning to screen
     C                   Move      'W'           OKInb1
     C                   Add       1             WIx
     C                   Movel     'MMA1078'     WMsgIdXAr(WIx)
     C                   Movel     'SINB1'       WFldNmXAr(WIx)
 
     C                   Else
     C                   Movel     CLSWTK        @INB2
      * Send warning to screen
     C                   Move      'W'           OKInb2
     C                   Add       1             WIx
     C                   Movel     'MMA1078'     WMsgIdXAr(WIx)
     C                   Movel     'SINB2'       WFldNmXAr(WIx)
     C                   End
 
     C                   End
     C                   End
     C                   End
     C                   End
     C                   End
 
      * No error
     C                   If        OKInb1 <> 'N' and
     C                             OKInb2 <> 'N' and
     C                             @INBT = *Blanks
 
      * Invalid customer number or shortname.
     C                   If        ADCH26 = *Blanks and
     C                             ADEXCS = *Blanks and
     C                             ADSLSH <> '/' or
     C                             ADCH36 = *Blanks and
     C                             ADXCS2 = *Blanks and
     C                             ADCHK2 <> *Blanks and
     C                             ADSLSH = '/' and
     C                             ADSLS2 <> '/'
 
      *  First 10 characters should be key for SDCUST
      * Send error to screen
     C                   Add       1             Idx
     C                   If        ADSLSH <> '/'
     C                   Move      'N'           OKInb1
     C                   Movel     'SINB1'       FldNamXAr(Idx)
     C                   Else
     C                   Move      'N'           OKInb2
     C                   Movel     'SINB2'       FldNamXAr(Idx)
     C                   End
     C                   Movel     'MMA1079'     MsgIdXAr(Idx)
 
     C                   Else
      * Validate as an address
     C                   Eval      ADLINE = 'Y'
     C                   Exsr      ADCHK
                                                                                CFT014
      ** Bilateral agreement exists and account line is a clearing code         CFT014
                                                                                CFT014
     C                   If        (@CFT014 = 'Y') And (@MT103 = 'Y') And       CFT014
     C                             (ADNOSN = '//') And (ADCH26 = *Blank)        CFT014
     C                   Move      'Y'           WCL103            1            CFT014
     C                   Else                                                   CFT014
     C                   Move      'N'           WCL103                         CFT014
     C                   EndIf                                                  CFT014
 
      *  Depending on the indicators, highlight the field in error
     C                   If        *IN91 = *On
     C                             And (@CFT014 = 'N') Or *IN91 = *On           CFT014
     C                             And (@CFT014 = 'Y') And (WCL103 = 'N')       CFT014
      * Send error to screen
     C                   Move      'N'           OKInb1
     C                   Add       1             Idx
     C                   Movel     'SINB1'       FldNamXAr(Idx)
     C                   Movel     'MMA1080'     MsgIdXAr(Idx)
     C                   End
      *
     C                   If        *IN92 = *On
      * Send error to screen
     C                   Move      'N'           OKInb1
     C                   Add       1             Idx
     C                   Movel     'SINB1'       FldNamXAr(Idx)
     C                   Movel     'MMA1081'     MsgIdXAr(Idx)
     C                   End
     C                   End
 
     C                   If        AD#1 = 'Y'
     C**********         Move      'N'           OKInb1                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SINB1'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKInb1                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SINB1'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKInb1                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SINB1'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End
 
     C                   If        AD#2 = 'Y'
     C**********         Move      'N'           OKInb2                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SINB2'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKInb2                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SINB2'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKInb2                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SINB2'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End
 
     C                   If        AD#3 = 'Y'
     C**********         Move      'N'           OKInb3                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SINB3'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKInb3                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SINB3'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKInb3                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SINB3'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End
 
     C                   If        AD#4 = 'Y'
     C**********         Move      'N'           OKInb4                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SINB4'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKInb4                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SINB4'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKInb4                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SINB4'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End
 
     C                   If        AD#5 = 'Y'
     C**********         Move      'N'           OKInb5                                       CSD089
     C**********         Add       1             Idx                                          CSD089
     C**********         Movel     'SINB5'       FldNamXAr(Idx)                               CSD089
     C**********         Movel     'MMA1051'     MsgIdXAr(Idx)                                CSD089
     C                   IF         Pmode = '*SIN  '                                        MD021318
     C                   Move      'N'           OKInb5                                     MD021318
     C                   Add       1             Idx                                        MD021318
     C                   Movel     'SINB5'       FldNamXAr(Idx)                             MD021318
     C                   Movel     'MMA1051'     MsgIdXAr(Idx)                              MD021318
     C                   ELSE                                                               MD021318
     C                   Move      'W'           OKInb5                                       CSD089
     C                   Add       1             WIx                                          CSD089
     C                   Movel     'SINB5'       WFldNmXAr(WIx)                               CSD089
     C                   Movel     'MMA1051'     WMsgIdXAr(WIx)                               CSD089
     C                   ENDIF                                                              MD021318
     C                   End
 
      *  If no errors then customer is an address
     C                   If        OKInb1 = 'Y'and
     C                             OKInb2 = 'Y'and
     C                             OKInb3 = 'Y'and
     C                             OKInb4 = 'Y'and
     C                             OKInb5 = 'Y'and
     C                             @INBT = *Blanks
     C                   Eval      @INBT = 'A'
     C                   End
 
     C                   End
                                                                                CFT014
      ** Entry not allowed if Bank Operation Code is 'SPRI'                     CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   If        (SBOCD = 'SPRI') And (SINB1 <> *Blank)       CFT014
     C                   Move      'N'           OKINB1                         CFT014
     C                   Add       1             Idx                            CFT014
     C                   Movel     'SINB1'       FldNamXAr(Idx)                 CFT014
     C                   Movel     'FTM3212'     MsgIdXAr(Idx)                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** No SWIFT BIC for customer with branch operation code 'SSTD' or         CFT014
      ** 'SPAY'                                                                 CFT014
                                                                                CFT014
     C                   If        (SBOCD = 'SSTD') Or (SBOCD = 'SPAY')         CFT014
                                                                                CFT014
     C                   If        (@INBT = 'C') And (BBCSID = *Blank)          CFT014
     C                   If        (WCL103 <> 'Y')                              CFT014
     C                   Move      'N'           OKINB1                         CFT014
     C                   Add       1             Idx                            CFT014
     C                   Movel     'SINB1'       FldNamXAr(Idx)                 CFT014
     C                   Movel     'FTM3213'     MsgIdXAr(Idx)                  CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Entry type is not a customer of SWIFT, error                           CFT014
                                                                                CFT014
     C                   If        (@INBT <> 'C') And (@INBT <> 'S') And        CFT014
     C                             (WCL103 = 'N')                               CFT014
     C                   Move      'N'           OKINB1                         CFT014
     C                   Add       1             Idx                            CFT014
     C                   Movel     'SINB1'       FldNamXAr(Idx)                 CFT014
     C                   Movel     'FTM3214'     MsgIdXAr(Idx)                  CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Clearing code exists                                                   CFT014
                                                                                CFT014
     C**********         If        (ADNOSN = '//') And (ADCH26 = *Blank)               CFT014 241855
     C                   If        (ADNOSN = '//')                                            241855
     C                   Clear                   I#PARM                         CFT014
     C                   Clear                   O#PARM                         CFT014
     C                   Clear                   X#PARM                         CFT014
     C                   If        WCL103 = 'N'                                 CFT014
                                                                                              CSW203
      ** If CSW203 is installed, set I#MTYP to '103' instead of '100'                         CSW203
                                                                                              CSW203
     C                   IF        CSW203 = 'Y'                                               CSW203
     C                   EVAL      I#MTYP = '103'                                             CSW203
     C                   ELSE                                                                 CSW203
     C                   Eval      I#MTYP = '100'                               CFT014
     C                   ENDIF                                                                CSW203
                                                                                              CSW203
     C                   Else                                                   CFT014
     C                   Eval      I#MTYP = '103'                               CFT014
     C                   Endif                                                  CFT014
     C                   Eval      I#VFLD = 'INBK'                              CFT014
     C                   Eval      I#PR = 'PAY'                                 CFT014
     C                   If        @INBT = 'C'                                  CFT014
     C                   Eval      I#PRTT = 'C'                                 CFT014
     C                   Eval      I#PRTY = C#CNUM                              CFT014
     C                   Else                                                   CFT014
     C                   If        @INBT = 'S'                                  CFT014
     C                   Eval      I#PRTT = 'S'                                 CFT014
     C                   Eval      I#PRTY = CLSWTK                              CFT014
     C                   Else                                                   CFT014
     C                   Eval      I#PRTT = *Blank                              CFT014
     C                   Eval      I#PRTY = *Blank                              CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   Eval      I#PCCY = SPCCY                               CFT014
     C                   Eval      I#RCCY = SSMCY                               CFT014
     C                   Eval      I#ACLN = SINB1                               CFT014
                                                                                CFT014
     C                   Eval      X#CPGM = WPrgQ                               CFT014
     C                   Eval      X#MSGD = 'MEC0016'                           CFT014
     C                   Eval      X#MSGF = 'MEMSG'                             CFT014
                                                                                CFT014
      ** Validate account line                                                  CFT014
                                                                                CFT014
     C                   Call      'ME9940'                                     CFT014
     C                   Parm                    @RCODE                         CFT014
     C                   Parm                    I#PARM                         CFT014
     C                   Parm                    O#PARM                         CFT014
     C                   Parm                    X#PARM                         CFT014
     C                   Parm      *Blank        Z#PARM          256            CFT014
                                                                                CFT014
      ** Error found                                                            CFT014
                                                                                CFT014
     C                   If        X#ERRM <> *Blank                             CFT014
     C                   Eval      OKINB1 = 'N'                                 CFT014
     C                   Eval      Idx = Idx + 1                                CFT014
     C                   Movel     'SINB1'       FldNamXAr(Idx)                 CFT014
     C                   Movel     X#MSGD        MsgIdXAr(Idx)                  CFT014
     C                   Movel     Z#PARM        MsgDtaXAr(Idx)                 CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                                                                          CFT004
      *  If IBAN (International Bank Account Number) is switched on             CFT004
     C                                                                          CFT004
     C                   IF        @CFT004 = 'Y'                                CFT004
                                                                                CFT004
      *  Remove '/' from first position                                         CFT004
                                                                                CFT004
     C                   IF        DSINB1Pos1 = '/'                             CFT004
     C     34            SUBST     DSINB1:2      PIBAN                          CFT004
     C                   ELSE                                                   CFT004
     C                   EVAL      PIBAN = DSINB1                               CFT004
     C                   ENDIF                                                  CFT004
                                                                                CFT004
      *  Format field, removing blanks and IBAN prefix                          CFT004
                                                                                CFT004
     C                   CALL      'AOIBANR3'                                   CFT004
     C                   PARM                    @Rcode            7            CFT004
     C                   PARM                    PIBAN            47            CFT004
     C                   PARM                    POWith           47            CFT004
     C     P@IBAN        PARM                    PONobl           34            CFT004
                                                                                CFT004
      *  If first four characters are 'AANN', proceed with IBAN validn          CFT004
                                                                                CFT004
     C     1             SUBST     P@IBAN:1      IBCTY1            1            CFT004
     C     1             SUBST     P@IBAN:2      IBCTY2            1            CFT004
     C     1             SUBST     P@IBAN:3      IBCHK1            1            CFT004
     C     1             SUBST     P@IBAN:4      IBCHK2            1            CFT004
     C     IBCTY1        LOOKUP    Alpha                                  94    CFT004
     C   94IBCTY2        LOOKUP    Alpha                                  94    CFT004
     C   94IBCHK1        LOOKUP    Numeric                                94    CFT004
     C   94IBCHK2        LOOKUP    Numeric                                94    CFT004
                                                                                CFT004
     C                   IF        *IN94 = *ON                                  CFT004
                                                                                CFT004
     C                   CALL      'AOIBANR5'                           90      CFT004
     C                   PARM      *Blanks       @Rcode                         CFT004
     C                   PARM                    P@IBAN           34            CFT004
                                                                                CFT004
      *  If no warnings, prefix IBAN with '/'                                   CFT004
                                                                                CFT004
     C                   IF        *IN90 = *Off and @Rcode = *Blanks            CFT004
     C     '/'           CAT       P@IBAN        SINB1                          CFT004
     C                   ELSE                                                   CFT004
                                                                                CFT004
      *  Warnings:                                                              CFT004
                                                                                CFT004
     C                   EVAL      OKInb1 = 'N'                                 CFT004
     C                   EVAL      WIx = WIx + 1                                CFT004
     C                   EVAL      WFldNmXAr(WIx) = 'SINB1     '                CFT004
     C                   EVAL      WMsgDtaXAr(WIx) =                            CFT004
     C                             'Intermediary Bank'                          CFT004
     C                   SELECT                                                 CFT004
                                                                                CFT004
      *  Invalid ISO country code                                               CFT004
                                                                                CFT004
     C                   WHEN      @Rcode = '      1'                           CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2400'                   CFT004
                                                                                CFT004
      *  Invalid BBAN length                                                    CFT004
                                                                                CFT004
     C                   WHEN      @Rcode = '      2'                           CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2401'                   CFT004
                                                                                CFT004
      *  Invalid character                                                      CFT004
                                                                                CFT004
     C                   WHEN      @Rcode = '      3'                           CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2402'                   CFT004
                                                                                CFT004
      *  Invalid IBAN length                                                    CFT004
                                                                                CFT004
     C                   WHEN      @Rcode = '      4'                           CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2403'                   CFT004
                                                                                CFT004
      *  Invalid check digit                                                    CFT004
                                                                                CFT004
     C                   WHEN      @Rcode = '      5'                           CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2404'                   CFT004
                                                                                CFT004
      *  Other/non-specific warning                                             CFT004
                                                                                CFT004
     C                   OTHER                                                  CFT004
     C                   EVAL      WMsgIdXAr(WIx) = 'FTM2405'                   CFT004
     C                   ENDSL                                                  CFT004
                                                                                CFT004
     C                   ENDIF                                                  CFT004
     C                   ENDIF                                                  CFT004
     C                   ENDIF                                                  CFT004
     C                                                                          CFT004
     C                   End
 
     C                   ENDSR
     C*****************************************************************
     C* END OF RECEIVER'S CORRESPONDENT VALIDATION                    *
     C*****************************************************************
     C/EJECT
      * Subroutine SWIFT
     E/COPY FTCPYSRC,SFTSWFTCLE
 
      * Subroutine ADCHK
     E/COPY FTCPYSRC,SFTADDRCLE
 
      * Subroutine SWSET
     E/COPY FTCPYSRC,SFTADDRSC1
 
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn
 
      *  Screen fields
     C                   Parm                    TranInPrim
     C***********        Parm                    TranInThir                     CFT014
     C                   Parm                    TranInSecA                     CFT014
     C                   Parm                    TranInSecB                     CFT014
     C                   Parm                    WPrgQ                          CFT014
 
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      ** Screen Input Function                                                              MD021318
     C                   PARM                    PMode                                      MD021318
 
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Call SWIF2003 to check if CSW203 is installed                                        CSW203
                                                                                              CSW203
     C                   CALL      'SWIF2003'                                                 CSW203
     C                   PARM      *BLANKS       PRTCD                                        CSW203
                                                                                              CSW203
      ** If ret. code is "CSW203", set CSW203 flag to "Y", else set it to "N"                 CSW203
                                                                                              CSW203
     C                   IF        PRTCD = 'CSW2003'                                          CSW203
     C                   EVAL      CSW203 = 'Y'                                               CSW203
     C                   ELSE                                                                 CSW203
     C                   EVAL      CSW203 = 'N'                                               CSW203
     C                   ENDIF                                                                CSW203
                                                                                              CSW203
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  SWCH  - Array of valid Swift characters
ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890/-?:().,'+
**  Alpha - Array of alphabetic characters                                      CFT004
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**  Numeric - Array of numeric characters                                       CFT004
0123456789
