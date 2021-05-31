     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate cross-validations')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVXVXV - Validate Cross Validations                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. HUT110             Date 21Apr20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 262674             Date 14Nov09               *
      *                 BUG26775           Date 23Nov09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260477             Date 21May09               *
      *                 BUG25085           Date 24Jul08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 CSW208             Date 15Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
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
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 12Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT110 - Upgrade HUT022 to FBM 2.1 SP22                      *
      *           RTGS via SWIFT. Added the following hooks:          *
      *           HUT110_079   HUT110_080   HUT110_081   HUT110_082   *
      *           HUT110_083   HUT110_084   HUT110_085                *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  262674 - Validation of bank to bank information field        *
      *           should not be executed when calling program is      *
      *           FTOPAY2VL.                                          *
      *  BUG26775 - Generation of MT103                               *
      *  260477 - Validation error /INT/ in Bank to Bank: apply 251758*
      *  251758 - initialise Intermediary variable used in validation *
      *           additional entry parameter.                         *
      *  BUG25085 - Misleading error message for Sender to Receiver   *
      *             Cover                                             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  CSW208 - SWIFT 2008 Changes (Recompile)                      *
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
      *  CFT004 - Recompiled for IBAN (International Bank A/C No.)    *
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

      /COPY FTCPYSRC,SFTVALCSLE

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

      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D TranInPrmB    E DS                  EXTNAME(FTOPY1APD)                               BUG26775
     D*TranInSecA****E*DS***               EXTNAME(FTOPY2PD)                    CFT014
     D TranInSecA    E DS                  EXTNAME(FTOPY2PD)                                  251758
     D TranInSecB    E DS                  EXTNAME(FTOPY3PD)
     D TranInThiA    E DS                  EXTNAME(FTOPY4PD)                    CFT014
     D NwOPCScnFmt   E DS                  EXTNAME(FTOPYCPD)                                BUG25085

      * Flags to indicate whether transaction fields are valid
     D*OKFlagsDS*****E*DS***               EXTNAME(FTEOPY2PD)                   CFT014
     D OKFlagsDS1    E DS                  EXTNAME(FTEOPY2PD)                   CFT014
     D OKFlagsDS2    E DS                  EXTNAME(FTEOPY3PD)                   CFT014
     D FTEOPYC       E DS                  EXTNAME(FTEOPYCPD)                               BUG25085

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

     D/COPY WNCPYSRC,HUT110_079                                                               HUT110
     D/COPY FTCPYSRC,SFTADDRILE

     D SACBDS          DS           175
     D  DSACB1                 1     35
     D  DSACB2                36     70

     D SBNCDS          DS           175
     D  DSBNC1                 1     35
     D  DSBNC2                36     70

     D SBBIDS          DS           210
     D  DSBBI1                 1     35
     D  DSBBI2                36     70
     D  DSBBI3                71    105
     D  DSBBI4               106    140
     D  DSBBI5               141    175
     D  DSBBI6               176    210

     D CLSWTK          DS
     D  SW                     1     12

      * Call Parameters for ME0950
      * Input Parameters
     D***I#PARM*         DS           512                                                     CGL029
     D I#PARM          DS           514                                                       CGL029
      * Field to be validated
     D  I#VFLD                 1      5

      * Pay/Receive Settlement (PAY/REC)
     D  I#PR                   6      8

      * Customer/Counterparty Nostro /BIC indentified type
      * Customer/Counterparty/BIC indentified
     D  I#PRTT                 9      9
     D  I#PRTY                10     20

      * Pay Currency
     D  I#PCCY                21     23

      * Receive Currency
     D  I#RCCY                24     26

      * Account Line
     D  I#ACLN                27     61

      * Account Line Character 1
     D  I#ACC1                27     27

      * Account Line Character 2
     D  I#ACC2                28     28

      * Account Line Character 3
     D  I#ACC3                29     29

      * Account Line first 4 characters
     D  I#ACCL                27     30

      * Account Line Clearing System
     D  I#ACCS                29     30

      * Account Line No account data
     D  I#SPC1                31     61

      * Message Type
     D  I#MTYP                62     64

      * Intermediary Institution for Bank to Bank validation
     D  I#INBT                65     65
     D  I#INBK                66     76

      * Account with Institution for Bank to Bank validation
     D  I#AWBT                77     77
     D  I#AWBK                78     88

      * Beneficiary for Bank to Bank validation
     D  I#BENT                89     89
     D  I#BENF                90    100

      * Pay and Receive Settlement Methods
     D  I#RSTM               101    102
     D  I#PSTM               103    104

      * Field 53 and 54 Entered
     D  I#5354               105    105

      * Midas Module
     D  I#MMOD               106    107

      * Pay and Receive Settlement Accounts
     D***I#PYAC*              108    125                                                      CGL029
     D***I#RCAC*              126    143                                                      CGL029
     D  QQPYAC               108    125                                                       CGL029
     D  QQRCAC               126    143                                                       CGL029

      * Transaction Type
     D  I#TTYP               144    145

      * Cover Required ?
     D  I#COVR               146    146

      * Bank to Bank Information
     D  I#BTB                257    466
     D  I#BTB1               257    291
     D  I#BTB2               292    326
     D  I#BTB3               327    361
     D  I#BTB4               362    396
     D  I#BTB5               397    431
     D  I#BTB6               432    466
     D  I#PYAC               467    490                                                       CGL029
     D  I#RCAC               491    514                                                       CGL029

      * Output Parameters
     D O#PARM          DS           512
      * Account Line modified
     D  O#ACLN                 1     35

      * Bank to Bank Information
     D  O#BTB                257    466
     D  O#BTB1               257    291
     D  O#BTB2               292    326
     D  O#BTB3               327    361
     D  O#BTB4               362    396
     D  O#BTB5               397    431
     D  O#BTB6               432    466

      * Error Parameters
     D X#PARM          DS           256
      * Calling Program
     D  X#CPGM                 1     10

      * Error message sent
     D  X#ERRM                12     12

      * Warning message sent
     D  X#WARN                13     13

      * Error index
     D  X#INDX                14     18  0

      * Message text to prefix error message
     D  X#MSGD                19     25
     D  X#MSGF                26     35

      * Fields in error
     D  X#FLDS                36     41

      * Error codes array
     D  X#ERCD                51    200
     D  O#E                   51    200    DIM(50)

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

     D C#CNUM          S             10
     D C#KYST          S              7
     D C#OPTN          S              7
     D C#RTCD          S              7

      * This prog only
     D ADLINE          S              1
     D ADSLON          S              1
     D ##CSID          S              1
                                                                                CFT014
      ** Program message queue                                                  CFT014
     D WPrgQ           S             10A                                        CFT014
                                                                                              CSW203
      ** Flag to indicate if CSW203 is switched on                                            CSW203
     D CSW203          S              1A                                                      CSW203
                                                                                              CSW203
      ** Parameter used as return code for call SWIF2003                                      CSW203
     D PRTCD           S              7A                                                      CSW203
                                                                                              CSW203
     D/COPY WNCPYSRC,HUT110_080                                                               HUT110
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
     C                   Eval      Idx = 0

     C/COPY WNCPYSRC,HUT110_081                                                               HUT110
      * Bank Cross References
     C                   Exsr      VXREF

      ** If an error was found, set the return code appropriately
     C                   If        OKBnc1 = 'N' or
     C                             OKBbi1 = 'N' or
     C                             OKBbi2 = 'N' or
     C                             OKBbi3 = 'N' or
     C                             OKBbi4 = 'N' or
     C                             OKBbi5 = 'N' or
     C**********                   OKBbi6 = 'N'                                             BUG25085
     C                             OKBbi6 = 'N' or                                          BUG25085
     C                             OKCBB1 = 'N' or                                          BUG25085
     C                             OKCBB2 = 'N' or                                          BUG25085
     C                             OKCBB3 = 'N' or                                          BUG25085
     C                             OKCBB4 = 'N' or                                          BUG25085
     C                             OKCBB5 = 'N' or                                          BUG25085
     C                             OKCBB6 = 'N' or                                          BUG25085
     C                             OKOCB1 = 'N' or                                          BUG25085
     C                             OKOCB2 = 'N' or                                          BUG25085
     C                             OKOCB3 = 'N' or                                          BUG25085
     C                             OKOCB4 = 'N' or                                          BUG25085
     C                             OKOCB5 = 'N' or                                          BUG25085
     C                             OKOCB6 = 'N'                                             BUG25085
     C                   Eval      RetCodeIn = 'Error'
     C                   End

      * RETURN

     C                   RETURN
      ******************************************************************
      /EJECT
     C******************************************************************
     C* VXREF   - VALIDATION CROSS VALIDATION                          *
      ******************************************************************
     C*
     C     VXREF         BEGSR

     C                   Eval      DSACB1 = SACB1
     C                   Eval      DSACB2 = SACB2

     C                   Eval      DSBNC1 = SBNC1
     C                   Eval      DSBNC2 = SBNC2

     C                   Eval      DSBBI1 = SBBI1
     C                   Eval      DSBBI2 = SBBI2
     C                   Eval      DSBBI3 = SBBI3
     C                   Eval      DSBBI4 = SBBI4
     C                   Eval      DSBBI5 = SBBI5
     C                   Eval      DSBBI6 = SBBI6

      *  If OTORC1 is keyword MT202 and customer number in Beneficiary
      *  this customer must be a bank
     C                   If        SORC1 = 'MT202' and
     C                             @BNCT = 'C'
     C                             And (WPrgQ = 'FTOPAY2VL')                    CFT014

      * Read SDCUSTPD for bank details
     C                   Movel     SBNCDS        ADDRSS

      *  First 10 characters should be key for SDCUST
     C                   If        ADSLSH <> '/'
     C                   Movel     SBNC1         C#CNUM
     C                   Else
     C                   Movel     SBNC2         C#CNUM
     C                   End

     C                   CALLB     'AOCUSTR0'
     C                   Parm      *Blanks       C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm                    C#CNUM
     C                   Parm      *Blanks       C#KYST
     C     SDCUST        Parm      *Blanks       DSSDY

      * Ordering Bank must be a bank
     C                   If        BBBNBI <> 'Y'
      * Send error to screen
     C                   Move      'N'           OKBnc1
     C                   Add       1             Idx
     C                   Movel     'SBNC1'       FldNamXAr(Idx)
     C                   Movel     'MMA1073'     MsgIdXAr(Idx)
     C                   End

     C                   End

      * No errors
      ** Use condition OKBnc1 <> 'N' since OKBnc1 is not initialized
      ** to 'Y' if calling program is FTOPAY3VL

     C**********         If        OKBnc1 ='Y'
     C                   If        OKBnc1 <> 'N'
     C**********                   OR OKCBB1 <> 'N'                                  BUG25085 262674
     C**********                   OR OKOCB1 <> 'N'                                  BUG25085 262674
     C**********                   And (WPrgQ = 'FTOPAY3VL')                         CFT014 BUG25085
     C**********                   And (WPrgQ = 'FTOPAY3VL'                          BUG25085 262674
     C**********                   OR WPrgQ = 'FTVOCBB'                              BUG25085 262674
     C**********                   OR WPrgQ = 'FTVOCBA')                             BUG25085 262674
     C                             And (WPrgQ = 'FTOPAY3VL')                                  262674
     C                             OR OKCBB1 <> 'N'                                           262674
     C                             AND (WPrgQ = 'FTVOCBB')                                    262674
     C                             OR OKOCB1 <> 'N'                                           262674
     C                             AND (WPrgQ = 'FTVOCBA')                                    262674

      * Call Bank to Bank Validation object
      *
      * Set up parameters
      *
     C                   Movel     *BLANKS       W0RTN
     C                   Clear                   I#PARM
      * Set up Control fields
     C                   Eval      I#VFLD = ':72: '
     C                   Eval      I#PR = 'PAY'
      * Set up Currency fields
     C                   Eval      I#PCCY = SPCCY
     C                   Eval      I#RCCY = SSMCY
      * Set up Intermediary                                                                   251758
     C                   If        @INBT <> *Blanks                                           251758
     C                   Eval      I#INBT = @INBT                                             251758
     C                   Movel     SINB1         ##001A            1                          251758
     C                   If        ##001A = '/'                                               251758
     C                   Movel     SINB2         I#INBK                                       251758
     C                   Else                                                                 251758
     C                   Movel     SINB1         I#INBK                                       251758
     C                   End                                                                  251758
     C                   End                                                                  251758
                                                                                              251758
      * Set up Account with Bank
     C                   If        @ACBT <> *Blanks
     C                   Eval      I#AWBT = @ACBT
     C                   Movel     SACB1         ##001A            1
     C                   If        ##001A = '/'
     C                   Movel     SACB2         I#AWBK
     C                   Else
     C                   Movel     SACB1         I#AWBK
     C                   End
     C                   End

      * Set up Beneficiary
     C                   If        @BNCT <> *Blanks
     C                   Eval      I#BENT = @BNCT
     C                   Movel     SBNC1         ##001A            1
     C                   If        ##001A = '/'
     C                   Movel     SBNC2         I#BENF
     C                   Else
     C                   Movel     SBNC1         I#BENF
     C                   End
     C                   End

      * Move in Bank to Bank Information
     C                   Movel     SBBI1         I#BTB1
     C                   Movel     SBBI2         I#BTB2
     C                   Movel     SBBI3         I#BTB3
     C                   Movel     SBBI4         I#BTB4
     C                   Movel     SBBI5         I#BTB5
     C                   Movel     SBBI6         I#BTB6
     C                   Movel     @STMT         I#PSTM
     C                   Movel     *Blanks       I#RSTM
      * Set up Receive/Settle account information
     C                   Movel     @FRGL         I#RCAC
      * Set up Pay account information
     C                   Movel     @TOGL         I#PYAC
      * If extra message and Rec Corr. then set 5354 field
     C                   If        @SNCT <> *Blanks and
     C                             @RCRT <> *Blanks
     C                   Movel     'Y'           I#5354
     C                   End
      * Transaction Type
     C                   Movel     'OP'          I#TTYP
      * Covered Required
     C                   Movel     SSNMT         I#COVR
      *
      * Set up message type
     C                   Select

     C                   When      SORC1 = 'MT202'
     C                   Movel     '202'         I#MTYP

     C                   Other
                                                                                              CSW203
      ** If CSW203 is installed, set I#MTYP to '103' instead of '100'                         CSW203
                                                                                              CSW203
     C                   IF        CSW203 = 'Y'                                               CSW203
     C                   EVAL      I#MTYP = '103'                                             CSW203
     C                   ELSE                                                                 CSW203
     C                   Movel     '100'         I#MTYP
     C                   ENDIF                                                                CSW203
                                                                                              CSW203
     C                   End

      *                                                                                     BUG26775
      ** Check if Ordering Customer/Beneficiary is a bank                                   BUG26775
      *                                                                                     BUG26775
     C                   CALL      'FT1020'                                                 BUG26775
     C                   PARM      @ORCT         CNTYP             1                        BUG26775
     C                   PARM      SSMCY         CNCCY             3                        BUG26775
     C                   PARM      SORC1         CNTR1            35                        BUG26775
     C                   PARM      SORC2         CNTR2            35                        BUG26775
     C                   PARM      SORC3         CNTR3            35                        BUG26775
     C                   PARM      SORC4         CNTR4            35                        BUG26775
     C                   PARM      SORC5         CNTR5            35                        BUG26775
     C                   PARM      @BNCT         BNTYP             1                        BUG26775
     C                   PARM      SPCCY         BNCCY             3                        BUG26775
     C                   PARM      SBNC1         BNTR1            35                        BUG26775
     C                   PARM      SBNC2         BNTR2            35                        BUG26775
     C                   PARM      SBNC3         BNTR3            35                        BUG26775
     C                   PARM      SBNC4         BNTR4            35                        BUG26775
     C                   PARM      SBNC5         BNTR5            35                        BUG26775
     C                   PARM      'C'           CTYP              1                        BUG26775
      *                                                                                     BUG26775
      ** If Ordering Customer and Beneficiary are both bank, set type to 202                BUG26775
      *                                                                                     BUG26775
     C                   IF        CTYP = 'B'                                               BUG26775
     C                   MOVEL     '202'         I#MTYP                                     BUG26775
     C                   ENDIF                                                              BUG26775
      *                                                                                     BUG26775
     C                   Clear                   O#PARM
     C                   Clear                   X#PARM

      * Send messages to correct calling process
     C                   Movel     'FTVXVXV'     X#CPGM
     C                   Movel     'FT'          I#MMOD
      *
     C                   Movel     'MEC0114'     X#MSGD
     C                   Movel     'MEMSG'       X#MSGF
      *
     C                   CALL      'ME9950'
     C                   Parm                    W0RTN             7
     C                   Parm                    I#PARM                         I Input Parms
     C                   Parm                    O#PARM                         O Output Parms
     C                   Parm                    X#PARM                         E Error Inform
     C                   Parm                    Z#PARM          256            B User Defined

     C                   Movel     O#BTB         SBBIDS

      * On return if errors copy into error array
     C                   If        X#ERRM <> *Blanks

     C                   SELECT                                                             BUG25085
      *                                                                                     BUG25085
      ** Set error message for Sender to Receiver Information Cover B                       BUG25085
      *                                                                                     BUG25085
     C                   WHEN      WPrgQ = 'FTVOCBB'                                        BUG25085
                                                                                            BUG25085
     C                   IF        %SUBST(X#FLDS:1:1) = 'Y'                                 BUG25085
     C                   MOVE      'N'           OKCBB1                                     BUG25085
     C                   ADD       1             Idx                                        BUG25085
     C                   MOVEL     'SCBB1'       FldNamXAr(Idx)                             BUG25085
     C                   MOVEL     'MMA3005'     MsgIdXAr(Idx)                              BUG25085
     C                   ENDIF                                                              BUG25085
                                                                                            BUG25085
     C                   IF        %SUBST(X#FLDS:2:1) = 'Y'                                 BUG25085
     C                   MOVE      'N'           OKCBB2                                     BUG25085
     C                   ADD       1             Idx                                        BUG25085
     C                   MOVEL     'SCBB2'       FldNamXAr(Idx)                             BUG25085
     C                   MOVEL     'MMA3005'     MsgIdXAr(Idx)                              BUG25085
     C                   ENDIF                                                              BUG25085
                                                                                            BUG25085
     C                   IF        %SUBST(X#FLDS:3:1) = 'Y'                                 BUG25085
     C                   MOVE      'N'           OKCBB3                                     BUG25085
     C                   ADD       1             Idx                                        BUG25085
     C                   MOVEL     'SCBB3'       FldNamXAr(Idx)                             BUG25085
     C                   MOVEL     'MMA3005'     MsgIdXAr(Idx)                              BUG25085
     C                   ENDIF                                                              BUG25085
                                                                                            BUG25085
     C                   IF        %SUBST(X#FLDS:4:1) = 'Y'                                 BUG25085
     C                   MOVE      'N'           OKCBB4                                     BUG25085
     C                   ADD       1             Idx                                        BUG25085
     C                   MOVEL     'SCBB4'       FldNamXAr(Idx)                             BUG25085
     C                   MOVEL     'MMA3005'     MsgIdXAr(Idx)                              BUG25085
     C                   ENDIF                                                              BUG25085
                                                                                            BUG25085
     C                   IF        %SUBST(X#FLDS:5:1) = 'Y'                                 BUG25085
     C                   MOVE      'N'           OKCBB5                                     BUG25085
     C                   ADD       1             Idx                                        BUG25085
     C                   MOVEL     'SCBB5'       FldNamXAr(Idx)                             BUG25085
     C                   MOVEL     'MMA3005'     MsgIdXAr(Idx)                              BUG25085
     C                   ENDIF                                                              BUG25085
                                                                                            BUG25085
     C                   IF        %SUBST(X#FLDS:6:1) = 'Y'                                 BUG25085
     C                   MOVE      'N'           OKCBB6                                     BUG25085
     C                   ADD       1             Idx                                        BUG25085
     C                   MOVEL     'SCBB6'       FldNamXAr(Idx)                             BUG25085
     C                   MOVEL     'MMA3005'     MsgIdXAr(Idx)                              BUG25085
     C                   ENDIF                                                              BUG25085
                                                                                            BUG25085
     C                   WHEN      WPrgQ = 'FTVOCBA'                                        BUG25085
      *                                                                                     BUG25085
      ** Set error message for Sender to Receiver Information Cover A                       BUG25085
      *                                                                                     BUG25085
     C                   IF        %SUBST(X#FLDS:1:1) = 'Y'                                 BUG25085
     C                   MOVE      'N'           OKOCB1                                     BUG25085
     C                   ADD       1             Idx                                        BUG25085
     C                   MOVEL     'SOCBB1'      FldNamXAr(Idx)                             BUG25085
     C                   MOVEL     'MMA3004'     MsgIdXAr(Idx)                              BUG25085
     C                   ENDIF                                                              BUG25085
                                                                                            BUG25085
     C                   IF        %SUBST(X#FLDS:2:1) = 'Y'                                 BUG25085
     C                   MOVE      'N'           OKOCB2                                     BUG25085
     C                   ADD       1             Idx                                        BUG25085
     C                   MOVEL     'SOCBB2'      FldNamXAr(Idx)                             BUG25085
     C                   MOVEL     'MMA3004'     MsgIdXAr(Idx)                              BUG25085
     C                   ENDIF                                                              BUG25085
                                                                                            BUG25085
     C                   IF        %SUBST(X#FLDS:3:1) = 'Y'                                 BUG25085
     C                   MOVE      'N'           OKOCB3                                     BUG25085
     C                   ADD       1             Idx                                        BUG25085
     C                   MOVEL     'SOCBB3'      FldNamXAr(Idx)                             BUG25085
     C                   MOVEL     'MMA3004'     MsgIdXAr(Idx)                              BUG25085
     C                   ENDIF                                                              BUG25085
                                                                                            BUG25085
     C                   IF        %SUBST(X#FLDS:4:1) = 'Y'                                 BUG25085
     C                   MOVE      'N'           OKOCB4                                     BUG25085
     C                   ADD       1             Idx                                        BUG25085
     C                   MOVEL     'SOCBB4'      FldNamXAr(Idx)                             BUG25085
     C                   MOVEL     'MMA3004'     MsgIdXAr(Idx)                              BUG25085
     C                   ENDIF                                                              BUG25085
                                                                                            BUG25085
     C                   IF        %SUBST(X#FLDS:5:1) = 'Y'                                 BUG25085
     C                   MOVE      'N'           OKOCB5                                     BUG25085
     C                   ADD       1             Idx                                        BUG25085
     C                   MOVEL     'SOCBB5'      FldNamXAr(Idx)                             BUG25085
     C                   MOVEL     'MMA3004'     MsgIdXAr(Idx)                              BUG25085
     C                   ENDIF                                                              BUG25085
                                                                                            BUG25085
     C                   IF        %SUBST(X#FLDS:6:1) = 'Y'                                 BUG25085
     C                   MOVE      'N'           OKOCB6                                     BUG25085
     C                   ADD       1             Idx                                        BUG25085
     C                   MOVEL     'SOCBB6'      FldNamXAr(Idx)                             BUG25085
     C                   MOVEL     'MMA3004'     MsgIdXAr(Idx)                              BUG25085
     C                   ENDIF                                                              BUG25085
                                                                                            BUG25085
     C                   OTHER                                                              BUG25085
                                                                                            BUG25085
     C/COPY WNCPYSRC,HUT110_082                                                               HUT110
     C                   If        %Subst(X#FLDS:1:1) = 'Y'
      * Send error to screen
     C                   Move      'N'           OKBbi1
     C                   Add       1             Idx
     C                   Movel     'SBBI1'       FldNamXAr(Idx)
     C                   Movel     'MMA1074'     MsgIdXAr(Idx)
     C                   End

     C                   If        %Subst(X#FLDS:2:1) = 'Y'
      * Send error to screen
     C                   Move      'N'           OKBbi2
     C                   Add       1             Idx
     C                   Movel     'SBBI2'       FldNamXAr(Idx)
     C                   Movel     'MMA1074'     MsgIdXAr(Idx)
     C                   End

     C                   If        %Subst(X#FLDS:3:1) = 'Y'
      * Send error to screen
     C                   Move      'N'           OKBbi3
     C                   Add       1             Idx
     C                   Movel     'SBBI3'       FldNamXAr(Idx)
     C                   Movel     'MMA1074'     MsgIdXAr(Idx)
     C                   End

     C                   If        %Subst(X#FLDS:4:1) = 'Y'
      * Send error to screen
     C                   Move      'N'           OKBbi4
     C                   Add       1             Idx
     C                   Movel     'SBBI4'       FldNamXAr(Idx)
     C                   Movel     'MMA1074'     MsgIdXAr(Idx)
     C                   End

     C                   If        %Subst(X#FLDS:5:1) = 'Y'
      * Send error to screen
     C                   Move      'N'           OKBbi5
     C                   Add       1             Idx
     C                   Movel     'SBBI5'       FldNamXAr(Idx)
     C                   Movel     'MMA1074'     MsgIdXAr(Idx)
     C                   End

     C                   If        %Subst(X#FLDS:6:1) = 'Y'
      * Send error to screen
     C                   Move      'N'           OKBbi6
     C                   Add       1             Idx
     C                   Movel     'SBBI6'       FldNamXAr(Idx)
     C                   Movel     'MMA1074'     MsgIdXAr(Idx)
     C                   End

     C/COPY WNCPYSRC,HUT110_083                                                               HUT110
     C                   ENDSL                                                              BUG25085
                                                                                            BUG25085
     C                   End
     C                   End
      *
     C                   ENDSR
     C*****************************************************************
     C* END OF RECEIVER'S CORRESPONDENT VALIDATION                    *
     C*****************************************************************
     C/COPY WNCPYSRC,HUT110_084                                                               HUT110
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
     C                   Parm                    TranInPrmB                                 BUG26775
     C***********        Parm                    TranInSecA                     CFT014
     C                   Parm                    TranInSecA                                   251758
     C                   Parm                    TranInSecB
     C                   Parm                    TranInThiA                     CFT014
     C                   Parm                    WPrgQ                          CFT014

      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

      *  OK Flags
     C***********        Parm                    OKFlagsDS                      CFT014
     C                   Parm                    OKFlagsDS1                     CFT014
     C                   Parm                    OKFlagsDS2                     CFT014

      *  Validation Work Fields
     C                   Parm                    Val@Fields

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
     C/COPY WNCPYSRC,HUT110_085                                                               HUT110
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
