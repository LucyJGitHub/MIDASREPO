     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits validation 2')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNIVL2 - MM Loans/Deposits Validation Screen 2            *
      *                                                               *
      *  Function: This Program Validates MM Deals for Input into     *
      *            the Midas database.                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 MD027019           Date 19May14               *
      *                 MD023258           Date 06Nov13               *
      *                 AR1081796          Date 25Jan13               *
      *                 AR1069531          Date 11Feb13               *
      *                 AR851172           Date 09Feb13               *
      *                 AR1068444          Date 18Dec12               *
      *                 AR910937           Date 27Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR853445           Date 05Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 263678             Date 05Feb10               *
      *                 259981             Date 15May09               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24317           Date 13Jul09               *
      *                 BUG22384           Date 23Jan09               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247452             Date 28Jun07               *
      *                 248701             Date 26Jun06               *
      *                 249964             Date 05Sep07               *
      *                 BUG13223           Date 08Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 BUG11298           Date 02May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10810           Date 21Mar06               *
      *                 CDL038             Date 10May05               *
      *                 BUG8032            Date 30Jul05               *
      *                 CDL033             Date 10Feb05               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL016  *CREATE    Date 03Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD027019 - Apply CDL093 Interest Calculation 9 Processing    *
      *  MD023258 - Duplicate error message shown for actual interest *
      *             rate field                                        *
      *  AR1081796 - Short term rate error                            *
      *  AR1069531 - Zero interest dealing transactions               *
      *  AR851172 - Only validate fields introduced by CDL033 when    *
      *             this feature is switched ON. (Child: AR954186)    *
      *  AR1068444 - Not computing total interest when Base Rate is   *
      *              populated                                        *
      *  AR910937 - Discrepancies in Total Interest Field when base   *
      *             rate was used                                     *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR853445 - Error encountered when maturing a CD/CL deal      *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  263678 - Incorrect defaulting of fixed base rate resulting   *
      *           to wrong interest calculation Apply fix 263046.     *
      *           Add a condition to handle warning messages when     *
      *           passed by MMVFIXBSRT.                               *
      *  259981 - Use Base Rate at Value Date for computation of the  *
      *           Total Interest                                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24317 - Entry of zero on Short term rate field produces   *
      *             errors.                                           *
      *  BUG22384 - Cannot authorize/edit loan/deposit deals.         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247452 -  Short term not reflected in Actual Interest Rate.  *
      *  248701 -(BUG10810)- BAD Incorporation of Fields in           *
      *           OKFLAGSDS Cause shift of data in Parameters of      *
      *           Calling Programs  -                                 *
      *           OKFLAGSDS must be based on MMELDN2PD Layout         *
      *  249964 - Applied fix 242632.                                 *
      *  242632 - Access Midas SD FRA/IRS ICD data only if FRA/IRS    *
      *           Module is installed.                                *
      *  BUG13223 - Unable to Authorize if Short term rate equal to   *
      *              Actual Interest Rate.                            *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  BUG11298 - Total interest does not matched that calculated.  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10810 - Actual intest rate does not display the short     *
      *             term rate entered                                 *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG8032- Incorrect validation of CDL033 fields for deal type *
      *           other than CF.                                      *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  CDL016 - Autumatic Rollover of Fixed Term Loan/Deposit       *
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

      ** Include the MM standard declares
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

      **-----------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------

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

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  CDL020
      ** External DS for dealing details                                                      CDL020
                                                                                              CDL020
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CDL020
      ** External DS For midas modules details                                                CDL020
                                                                                              CDL020
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)                                  CDL033
      ** External DS for FRA/IRS I.C.D. details                                               CDL033
                                                                                              CDL033
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)                                  CDL033
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CDL033
      ** External DS for trading details                                                      CDL033
                                                                                              CDL033
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access Programs, Short Data Structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access Programs, Long Data Structure

     D DSLDY         E DS                  EXTNAME(DSLDY)
      * Third DS for Access Programs, Very Long Data Structure

     D ValidDeal     E DS                  EXTNAME(MMVLDNIPD)
      * Valid Deals layout

     D TranIn        E DS                  EXTNAME(MMLDNIPD)
      * Incoming Transaction

     D InfData       E DS                  EXTNAME(MMLDIFPD)
     D                                     PREFIX(IF_)
      * MM Extra Data - File (D/B) format

     D ExtData       E DS                  EXTNAME(MMLDEXPD)
      * MM Extra Data - File (D/B) format

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                BUG10810
      ** External DS for SAR Details                                                        BUG10810
                                                                                            BUG10810
      *                                                                                       CDL093
     D WDATE9          DS             6                                                       CDL093
     D  WDD9                   1      2  0                                                    CDL093
     D  WMM9                   3      4  0                                                    CDL093
     D  WYY9                   5      6  0                                                    CDL093
      *                                                                                       CDL093
      **  Front Office (2 First characters determine System Front Office)
     D FrontOffice     DS            20
     D  W_System               1      2

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      **                                                                                      CDL093
     D BChar           DS                                                                     CDL093
     D   BLen                  1      2B 0                                                    CDL093
     D   LenStr                1      2                                                       CDL093

      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
     D     Msg5        S                   LIKE(#MsgID)
     D     Msg6        S                   LIKE(#MsgID)
     D     Msg7        S                   LIKE(#MsgID)

      ** Warning error message fields received as parameters
     D     WMSGID1     S                   LIKE(#MsgID)
     D     WMSGID2     S                   LIKE(#MsgID)
     D     WMSGID3     S                   LIKE(#MsgID)
     D     WMSGID4     S                   LIKE(#MsgID)
     D     WMSGID5     S                   LIKE(#MsgID)
     D     WMSGID6     S                   LIKE(#MsgID)
     D     WMSGID7     S                   LIKE(#MsgID)

      ** Error message substitution data received as a parameter
     D MSGDATA         S                   LIKE(#MsgData)
     D MSGDATA2        S                   LIKE(#MsgData)
     D MSGDATA3        S                   LIKE(#MsgData)
     D MSGDATA4        S                   LIKE(#MsgData)
                                                                                              CDL033
      ** Error message substitution data received as a parameter                              CDL033
     D WRCDT           S                   LIKE(IKRCDT)                                       CDL033
     D WSTRT           S                   LIKE(IKSTRT)                                       CDL033
                                                                                              CDL033
      ** Parameter Fields fo MMVFWDYLD                                                        CDL033
     D Rtncde          S              7                                                       CDL033
     D Fwdyld          S              5                                                       CDL033
     D Deltyp          S              2                                                       CDL033
     D Dlstyp          S              2                                                       CDL033
     D MsgId           S              7                                                       CDL033
     D Msgdta          S             45                                                       CDL033
                                                                                              CDL033
      ** Parameter Fields fo ZALIGN                                                           CDL033
     D ZALIGNok        S              1                                                       CDL033
     D Zfield          S             16A                                                      CDL033
     D ZADEC           S              1P 0                                                    CDL033
     D ZADIG           S              2P 0                                                    CDL033
                                                                                              CDL033
      ** Parameter Fields fo ZA0921                                                           247452
     D PAmtIn          S             15P 0                                                    247452
     D PNoOfDecPl      S              1P 0                                                    247452
     D PAmtOutS        S             16A                                                      247452
     D PAmtOutU        S             17A                                                      247452
                                                                                              247452
      ** Fields used to setup valid file records                                              CDL033
     D ZINDT           S                   LIKE(IKRCDT)                                       CDL033
     D ZRFDY           S                   LIKE(IKFXDM)                                       CDL033
     D ZRFDT           S                   LIKE(IKRCDT)                                       CDL033
     D ZWKFLD          S                   LIKE(IKFXDM)                                       CDL033
     D ZCCY            S                   LIKE(IKCCY)                                        CDL033
     D ZLOC            S              3                                                       CDL033
                                                                                              CDL033
     D WINFD           S                   LIKE(IKINFD)                                       CDL033
                                                                                              CDL033
      ** Error Flag for call to Standard routines                                             CDL033
     D ErrorFlag       S              1A   INZ('N')                                           CDL033

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS       DS
     D  DDSOFDOK                      1A
     D  DDFBRTOK                      1A                                                      CDL019
     D  DDAIROK                       1A                                                      CDL020
     D  DDRcDtOk                      1A                                                      CDL033
     D  DDRcfROk                      1A                                                      CDL033
     D  DDRcDmOk                      1A                                                      CDL033
     D  DDStRtOk                      1A                                                      CDL033
     D  DDFxDmOk                      1A                                                      CDL033
     D  DDFYldOk                      1A                                                      CDL033
      *                                                                                       248701
      ** put BUG10810 used fields outside *entry Paramater OKFLAGSDS - start                  248701
      ** is Equivalent to Defined each of below fields as standalone definition               248701
     D OKFLDS_ER08     DS                                                                     248701
     D  WValidOk                      1A                                                      CDL033
     D  DDAmnpOK                      1A                                                    BUG10810
     D  DDBsRCOK                      1A                                                    BUG10810
     D  DDCcyOK                       1A                                                    BUG10810
     D  DDICMtOK                      1A                                                    BUG10810
     D  DDMDatOK                      1A                                                    BUG10810
     D  DDNtceOK                      1A                                                    BUG10810
     D  DDSpRtOK                      1A                                                    BUG10810
     D  DDTotIOK                      1A                                                    BUG10810
     D  DDVDatOK                      1A                                                    BUG10810
      *                                                                                       248701
      ** put BUG10810 used fields outside *entry Paramater OKFLAGSDS - end                    248701

      ** Receive / Pay Settlement Currency, Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D RecNostro       S             18A                                                      CDL038
     D*RecNostro*******S             12A                                                      CDL038
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D PayNostro       S             18A                                                      CDL038
     D*PayNostro*******S             12A                                                      CDL038

      ** Numeric version of spread/rate
     D @SPRD           S             11P 7

      ** A code to indicate the calling function to the lower level modules
     D LDNI            S              4A   INZ('LDNI')

      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A

      ** Parameter list for ZA0840                                                          BUG24317
      ** =========================                                                          BUG24317
      ** Return code for numeric validation module call                                     BUG24317
     D @Rtcde          S             10A                                                    BUG24317
      ** Alpha field for numeric validation                                                 BUG24317
     D @@ALPH          S             16A                                                    BUG24317
      ** Number of decimal places field for numeric validation                              BUG24317
     D @@IDP           S              2  0                                                  BUG24317
      ** Number of integers field for numeric validation                                    BUG24317
     D @@IINT          S              2  0                                                  BUG24317
      ** Millions/Thousands id (Y=function on)                                              BUG24317
     D @@MTID          S              1A                                                    BUG24317
      ** Amount calculation field                                                           BUG24317
     D @@AMT           S             15  0                                                  BUG24317
      ** Error return code for ZA0840 module                                                BUG24317
     D @@ERCD          S              1  0                                                  BUG24317
     D W@AMNP          S             15P 0                                                  AR910937
     D CDL093          S              1A                                                      CDL093
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

     D/COPY ZSRSRC,ZFEB29Z1LE                                                                 CDL093
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 CDL093
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 CDL093
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      * Call Validation Modules in Sequence

      *  *--------------------------*
      *  * Validate Source of Funds *
      *  *--------------------------*

     C     CDL016        IFEQ      'Y'

     C                   EXSR      RESETERRS

     C                   CALLB     'MMVSRCFUND'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDTYPE
     C                   PARM                    DDSOFD

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSOFD'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDSOFDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

     C                   ENDIF

                                                                                              CDL019
      *  *------------------------*                                                           CDL019
      *  * Validate Fix Base Rate *                                                           CDL019
      *  *------------------------*                                                           CDL019
                                                                                              CDL019
     C     CDL019        IFEQ      'Y'                                                        CDL019
                                                                                              CDL019
     C                   EXSR      RESETERRS                                                  CDL019
                                                                                              CDL019
     C                   CALLB     'MMVFIXBSRT'                                               CDL019
     C                   PARM                    ReturnCode                                   CDL019
     C                   PARM                    MSG1                                         CDL019
     C                   PARM                    DDFBRT                                       CDL019
     C                   PARM                    DDTYPE                                       CDL019
     C                   PARM                    DDSTYP                                       CDL019
     C                   PARM                    DDCLAS                                       CDL038
     C                   PARM                    DDBSRC                                       CDL019
     C                   PARM                    IKMATD                                       CDL019
                                                                                              CDL019
     C                   IF        MSG1 <> *Blanks                                            CDL019
     C                   IF        ReturnCode = 'Warning'                                     263678
     C                   EVAL      WIdx = WIdx + 1                                            263678
     C                   EVAL      WFldNamArr(WIdx) = 'DDFBRT'                                263678
     C                   EVAL      WMsgIDArr(WIdx) = MSG1                                     263678
     C                   ELSE                                                                 263678
     C                   EVAL      Idx = Idx + 1                                              CDL019
     C                   EVAL      FldNameArr(Idx) = 'DDFBRT'                                 CDL019
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL019
     C                   ENDIF                                                                263678
     C                   ENDIF                                                                CDL019
                                                                                              CDL019
      ** Use the return code's value to set the field's OK flag                               CDL019
     C                   CALLB     'ZASETOKFLG'                                               CDL019
     C                   PARM                    DDFBRTOK                                     CDL019
     C                   PARM                    ReturnCode                                   CDL019
     C                   PARM                    WarnGlobal                                   CDL019
                                                                                              CDL019
     C                   ENDIF                                                                CDL019
                                                                                              CDL020
      *  *-------------------------------*                                                    CDL020
      *  * Validate Actual Interest Rate *                                                    CDL020
      *  *-------------------------------*                                                    CDL020
                                                                                              CDL020
                                                                                            BUG10810
      ** Convert validation of Actual Interest rate into a                                  BUG10810
      ** subroutine (ValidActInt)                                                           BUG10810
                                                                                            BUG10810
     C                   EXSR      ValidActInt                                              BUG10810
                                                                                            BUG10810
     C*****CDL020        IFEQ      'Y'                                               CDL020 BUG10810
                                                                                              CDL020
     C**********         EXSR      RESETERRS                                         CDL020 BUG10810
                                                                                              CDL020
     C**********         CALLB     'MMVACTINTR'                                      CDL020 BUG10810
     C**********         PARM                    ReturnCode                          CDL020 BUG10810
     C**********         PARM                    MSG1                                CDL020 BUG10810
     C**********         PARM                    DDAIR                               CDL020 BUG10810
     C**********         PARM                    BGN0ST                              CDL020 BUG10810
     C**********         PARM                    BNDCSP                              CDL020 BUG10810
     C**********         PARM                    DDCCY                               CDL020 BUG10810
     C**********         PARM                    DDBSRC                              CDL020 BUG10810
     C**********         PARM                    IKDVSD                              CDL020 BUG10810
     C**********         PARM                    BJRDNB                              CDL020 BUG10810
     C**********         PARM                    IKSPRD                              CDL020 BUG10810
     C**********         PARM                    IKINTR                              CDL020 BUG10810
                                                                                              CDL020
     C**********         IF        MSG1 <> *Blanks                                   CDL020 BUG10810
     C**********         EVAL      Idx = Idx + 1                                     CDL020 BUG10810
     C**********         EVAL      FldNameArr(Idx) = 'DDAIR'                         CDL020 BUG10810
     C**********         EVAL      MsgIDArr(Idx) = MSG1                              CDL020 BUG10810
     C**********         ENDIF                                                       CDL020 BUG10810
                                                                                              CDL020
      ***Use*the*return*code's*value*to*set*the*field's*OK*flag***                   CDL020 BUG10810
     C**********         CALLB     'ZASETOKFLG'                                      CDL020 BUG10810
     C**********         PARM                    DDAIROK                             CDL020 BUG10810
     C**********         PARM                    ReturnCode                          CDL020 BUG10810
     C**********         PARM                    WarnGlobal                          CDL020 BUG10810
                                                                                              CDL020
     C**********         ENDIF                                                       CDL020 BUG10810
                                                                                              CDL033
      **-----------------------------------------*                                            CDL033
      ** Validation for the six additional fields                                             CDL033
      **-----------------------------------------*                                            CDL033
                                                                                              CDL033
     C                   MOVE      'N'           WValidOk                                     CDL033
                                                                                            BUG24317
     C                   IF        CDL033 = 'Y'                                             AR853445
     C                   IF        DDTYPE <> 'CD'                                           AR853445
     C                             AND DDTYPE <> 'CL'                                       AR853445
     C                             AND DDTYPE <> 'DL'                                       AR853445
     C                             AND DDTYPE <> *BLANKS                                    AR853445
     C**********         EXSR      ValidStRt                                       BUG24317 AR851172
     C                   ENDIF                                                              AR853445
     C                   ENDIF                                                              AR853445
      *                                                                                     AR851172
      ** Format Short Term Rate                                                             AR851172
      *                                                                                     AR851172
     C                   EVAL      WSTRT = *Zero                                            AR851172
      *                                                                                     AR851172
     C                   IF        CDL033 = 'Y' and DDSTRT <> *Blanks                       AR851172
      *                                                                                     AR851172
     C                   MOVEL     *BLANKS       ZFIELD                                     AR851172
     C                   CALLB     'ZALIGN'                                                 AR851172
     C                   PARM      *BLANK        ZALIGNok                                   AR851172
     C                   PARM      DDSTRT        ZFIELD                                     AR851172
     C                   PARM      7             ZADEC                                      AR851172
     C                   PARM      4             ZADIG                                      AR851172
      *                                                                                     AR851172
     C                   IF        ZALIGNok = 'N'                                           AR851172
     C                   EVAL      Idx = Idx + 1                                            AR851172
     C                   EVAL      FldNameArr(Idx) = 'DDSTRT'                               AR851172
     C                   EVAL      MsgIDArr(Idx) = 'FLR0014'                                AR851172
     C                   EVAL      ReturnCode = 'Error'                                     AR851172
     C                   ELSE                                                               AR851172
     C                   MOVE      ZFIELD        WSTRT                                      AR851172
     C                   ENDIF                                                              AR851172
      *                                                                                     AR851172
     C                   CALLB     'ZASETOKFLG'                                             AR851172
     C                   PARM      'Y'           DDStRtOK                                   AR851172
     C                   PARM                    ReturnCode                                 AR851172
     C                   PARM                    WarnGlobal                                 AR851172
      *                                                                                     AR851172
     C                   ENDIF                                                              AR851172
                                                                                            BUG24317
     C**********         IF        DDSTRT = '.0000000    '                         BUG22384 AR851172
     C**********         EVAL      DDSTRT = *Blanks                                BUG22384 AR851172
     C**********         ENDIF                                                     BUG22384 AR851172
     C                   IF        CDL033 = 'Y' AND                                           CDL033
     C                             (DDTYPE = 'CF' OR                                          CDL033
     C**********                   (DDTYPE = 'CI' AND DDBSRC <> '  ') OR              CDL033 BUG8032
     C                             (DDTYPE = 'CI' AND DDBSRC <> '  '  AND                    BUG8032
     C                             (DDRCFR <> '  ' OR DDRCDT <> '  '  OR                     BUG8032
     C**********                    DDRCDM <> '  ' OR (DDSTRT <> '0.0000000' AND    BUG8032 BUG24317
     C                              DDRCDM <> '  ' OR (WSTRT <> 0.0000000  AND              BUG24317
     C                              DDSTRT <> '         ') OR DDFXDM <> '  ' OR              BUG8032
     C                              DDFYLD <> '  ')) OR                                      BUG8032
     C**********                   (DDTYPE = 'IP' AND DDBSRC <> '  ') OR              CDL033 BUG8032
     C                             (DDTYPE = 'IP' AND DDBSRC <> '  '  AND                    BUG8032
     C                             (DDRCFR <> '  ' OR DDRCDT <> '  '  OR                     BUG8032
     C**********                    DDRCDM <> '  ' OR (DDSTRT <> '0.0000000' AND    BUG8032 BUG24317
     C                              DDRCDM <> '  ' OR (WSTRT <> 0.0000000  AND              BUG24317
     C                              DDSTRT <> '         ') OR DDFXDM <> '  ' OR              BUG8032
     C                              DDFYLD <> '  ')) OR                                      BUG8032
     C**********                   (DDTYPE = 'IT' AND DDBSRC <> '  ') OR              CDL033 BUG8032
     C                             (DDTYPE = 'IT' AND DDBSRC <> '  '  AND                    BUG8032
     C                             (DDRCFR <> '  ' OR DDRCDT <> '  '  OR                     BUG8032
     C**********                    DDRCDM <> '  ' OR (DDSTRT <> '0.0000000' AND    BUG8032 BUG24317
     C                              DDRCDM <> '  ' OR (WSTRT <> 0.0000000  AND              BUG24317
     C                              DDSTRT <> '         ') OR DDFXDM <> '  ' OR              BUG8032
     C                              DDFYLD <> '  ')) OR                                      BUG8032
     C**********                   (DDTYPE = 'TI' AND DDBSRC <> '  ') OR              CDL033 BUG8032
     C                             (DDTYPE = 'TI' AND DDBSRC <> '  '  AND                    BUG8032
     C                             (DDRCFR <> '  ' OR DDRCDT <> '  '  OR                     BUG8032
     C**********                    DDRCDM <> '  ' OR (DDSTRT <> '0.0000000' AND    BUG8032 BUG24317
     C                              DDRCDM <> '  ' OR (WSTRT <> 0.0000000  AND              BUG24317
     C                              DDSTRT <> '         ') OR DDFXDM <> '  ' OR              BUG8032
     C                              DDFYLD <> '  ')) OR                                      BUG8032
     C**********                   (DDTYPE = 'TD' AND DDBSRC <> '  ') OR              CDL033 BUG8032
     C                             (DDTYPE = 'TD' AND DDBSRC <> '  '  AND                    BUG8032
     C                             (DDRCFR <> '  ' OR DDRCDT <> '  '  OR                     BUG8032
     C**********                    DDRCDM <> '  ' OR (DDSTRT <> '0.0000000' AND    BUG8032 BUG24317
     C                              DDRCDM <> '  ' OR (WSTRT <> 0.0000000  AND              BUG24317
     C                              DDSTRT <> '         ') OR DDFXDM <> '  ' OR              BUG8032
     C                              DDFYLD <> '  ')) OR                                      BUG8032
     C                             (DDRCFR <> '  ' OR DDRCDT <> '  '  OR                      CDL033
     C**********                    DDRCDM <> '  ' OR (DDSTRT <> '0.0000000' AND     CDL033 BUG24317
     C                              DDRCDM <> '  ' OR (WSTRT <> 0.0000000  AND              BUG24317
     C                              DDSTRT <> '         ') OR DDFXDM <> '  ' OR               CDL033
     C                              DDFYLD <> '  '))
      *                                                                                       CDL033
     C                   EXSR      ValidRcfR                                                  CDL033
     C                   EXSR      ValidRcDt                                                  CDL033
     C                   EXSR      ValidRcDm                                                  CDL033
     C**********         EXSR      ValidStRt                                         CDL033 BUG24317
     C                   EXSR      ValidStRt                                                AR851172
                                                                                            BUG10810
      ** If there is a Short Term rate entered,                                             BUG10810
      ** use this to populate Actual Interest field and then                                BUG10810
      ** Recompute Total Interest                                                           BUG10810
                                                                                            BUG10810
     C     WSTRT         IFNE      0                                                        BUG10810
     C                   Z-ADD     0             IKINTR                                     BUG10810
     C**********         MOVE      WSTRT         IKINTR                              BUG10810 247452
     C                   MOVE      WSTRT         IKINTR                                       247452
     C                   Z-ADD     0             PAmtIn                                       247452
     C                   MOVE      WSTRT         PAmtIn                                       247452
     C                   Z-ADD     7             PNoOfDecPl                                   247452
     C                   CALLB     'ZA0921'                                                   247452
     C                   PARM      *BLANK        RetCodeIn                                    247452
     C                   PARM                    PAmtIn           15 0                        247452
     C                   PARM                    PNoOfDecPl        1 0                        247452
     C                   PARM                    BNDCSP                                       247452
     C                   PARM      *BLANK        PAmtOutS         16                          247452
     C                   PARM      *BLANK        PAmtOutU         17                          247452
     C                   MOVE      PAmtOutS      DDAIR                                        247452
     C                   MOVE      PAmtOutU      DDAIR                                        247452
                                                                                              247452
     C                   EXSR      ValidActInt                                              BUG10810
                                                                                            BUG10810
     C                   EXSR      RESETERRS                                                BUG10810
                                                                                              259981
     C                   ENDIF                                                                259981
     C                   ENDIF                                                                259981
                                                                                              259981
     C     DDAIR         IFNE      *BLANKS                                                    259981
     C     CDL020        ANDEQ     'Y'                                                        259981
     C     WSTRT         ORNE      0                                                          259981
     C     CDL033        ANDEQ     'Y'                                                      AR851172
                                                                                            AR910937
     C                   Z-ADD     IKAMNP        W@AMNP                                    AR1068444
     C                   IF        IKAMNP < 0                                               AR910937
     C                   Z-SUB     IKAMNP        W@AMNP                                     AR910937
     C                   ENDIF                                                              AR910937
      * Ascertain if there is a 29FEB in the period                                           CDL093
     C                   MOVE      *BLANKS       #29FEB            1                          CDL093
     C                   Z-ADD     IKDVSD        @@DAYN            5 0                        CDL093
     C                   EXSR      ZDATE9                                                     CDL093
     C                   Z-ADD     @@VDT         ZZStartDate                                  CDL093
      *                                                                                       CDL093
     C                   Z-ADD     IKMATD        @@DAYN                                       CDL093
     C                   EXSR      ZDATE9                                                     CDL093
     C                   Z-ADD     @@VDT         ZZEndDate                                    CDL093
                                                                                              CDL093
     C                   EXSR      #FEB29                                                     CDL093
     C                   MOVE      ' '           WRK9              1                          CDL093
     C                   IF        DDICMT = '9'                                               CDL093
     C                             AND (DDTYPE = 'IP' OR DDTYPE = 'IT' OR                     CDL093
     C                                  DDTYPE = 'TD' OR DDTYPE = 'TI')                       CDL093
     C                             AND IKNIPD <> 0                                            CDL093
     C                             AND #29Feb = 'Y'                                           CDL093
     C                   IF        DDTOTI = *BLANKS OR DDTOTI = '*'                           CDL093
     C                             OR DDTOTI = '0'                                            CDL093
     C                   MOVE      '*'           WRK9                                         CDL093
     C                   ELSE                                                                 CDL093
      *                                                                                       CDL093
     C                   MOVEL     *BLANKS       ZFIELD                                       CDL093
     C                   MOVEL     DDTOTI        ZFIELD                                       CDL093
     C                   CALLB     'ZALIGN'                                                   CDL093
     C                   PARM                    ZALIGNOK          1                          CDL093
     C                   PARM                    ZFIELD           16                          CDL093
     C                   PARM      IKCYDP        ZADEC             1 0                        CDL093
     C                   PARM      12            ZADIG             2 0                        CDL093
                                                                                              CDL093
     C                   MOVE      ZFIELD        IKMTTI                                       CDL093
     C                   ENDIF                                                                CDL093
     C                   MOVE      ' '           NxtFeb29          1                          CDL093
     C                   GOTO      TAGCALC9                                                   CDL093
     C                   ENDIF                                                                CDL093
      *                                                                                       CDL093
                                                                                            BUG10810
      ** If RepoFlag is Set to 'Y' call New Module MMVTOIT   to process                     BUG10810
      ** Call Loans and Deposits differently                                                BUG10810
                                                                                            BUG10810
     C                   IF        RepoFlag = 'Y'                                           BUG10810
                                                                                            BUG10810
     C                   EXSR      RESETERRS                                                MD023258
     C                   CALLB     'MMVTOIT'                                                BUG10810
     C                   PARM                    ReturnCode                                 BUG10810
     C                   PARM                    MSG1                                       BUG10810
      ** Message data (45A)                                                                 BUG10810
     C                   PARM                    MSGDATA                                    BUG10810
      ** Total interest amount returned from this module (15,0P)                            BUG10810
     C                   PARM                    IKMTTI                                     BUG10810
      ** Total interest amount (14A, from transaction)                                      BUG10810
     C                   PARM                    DDTOTI                                     BUG10810
      ** Default interest for CL and CD deals with zero notice days                         BUG10810
      ** feature flag (1A, from SCSARDPD)                                                   BUG10810
     C                   PARM                    S01468                                     BUG10810
      ** Deal notice days (3A, from transaction)                                            BUG10810
     C                   PARM                    DDNTCE                                     BUG10810
      ** Deal type (2A, from transaction)                                                   BUG10810
     C                   PARM                    DDTYPE                                     BUG10810
      ** Interest rate (11,7P,)                                                             BUG10810
     C                   PARM                    IKINTR                                     BUG10810
      ** Deal amount (15,0P, from caller)                                                   BUG10810
     C**********         PARM                    IKAMNP                            BUG10910 AR910937
     C                   PARM                    W@AMNP                                     AR910937
      ** Interest calculation method (1A, from transaction)                                 BUG10810
     C                   PARM                    DDICMT                                     BUG10810
      ** Deal value date in Midas day number format (5,0P, )                                BUG10810
     C                   PARM                    IKDVSD                                     BUG10810
      ** Currency FldNameArr OK flag (1A, )                                                 BUG10810
     C                   PARM      'Y'           DDCcyOK                                    BUG10810
      ** Number of decimal places in deal currency (1,0S, from SDCURRPD)                    BUG10810
     C                   PARM                    IKCYDP                                     BUG10810
      ** Value date field OK (1A, )                                                         BUG10810
     C                   PARM                    DDVDatOK                                   BUG10810
      ** Notice days field OK (1A, )                                                        BUG10810
     C                   PARM                    DDNtceOK                                   BUG10810
      ** Amount field OK (1A, )                                                             BUG10810
     C                   PARM                    DDAMNPOK                                   BUG10810
      ** Base Rate field OK (1A, )                                                          BUG10810
     C                   PARM                    DDBsRCOK                                   BUG10810
      ** Spread/Rate field OK (1A, )                                                        BUG10810
     C                   PARM                    DDSpRtOK                                   BUG10810
      ** Calculation method field OK (1A, )                                                 BUG10810
     C                   PARM                    DDICMTOK                                   BUG10810
      ** Maturity date (6A, from transaction)                                               BUG10810
     C                   PARM                    DDMDAT                                     BUG10810
      ** Maturity date in Midas day number format (5,0P, )                                  BUG10810
     C                   PARM                    IKMATD                                     BUG10810
      ** Maturity date field OK (1A, )                                                      BUG10810
     C                   PARM                    DDMDatOK                                   BUG10810
      ** Notice days (3,0S, )                                                               BUG10810
     C                   PARM                    IKNTCE                                     BUG10810
      ** First and last day interest flag (1A, from transaction)                            BUG10810
     C                   PARM                    DDFLID                                     BUG10810
      ** Round-down interest flag (1A, from transaction)                                    BUG10810
     C                   PARM                    DDRDFC                                     BUG10810
      ** Decimal separator (1A, from SDDEALPD)                                              BUG10810
     C                   PARM                    BNDCSP                                     BUG10810
                                                                                            BUG10810
     C                   ELSE                                                               BUG10810
                                                                                            BUG10810
     C                   EXSR      RESETERRS                                                MD023258
     C                   CALLB     'ZAVTOTINT'                                              BUG10810
     C                   PARM                    ReturnCode                                 BUG10810
     C                   PARM                    MSG1                                       BUG10810
      ** Action Code (1A, from caller)                                                      BUG10810
     C                   PARM                    DDACTN                                     BUG10810
      ** Message data (45A)                                                                 BUG10810
     C                   PARM                    MSGDATA                                    BUG10810
      ** Total interest amount returned from this module (15,0P                             BUG10810
     C                   PARM                    IKMTTI                                     BUG10810
      ** Total interest amount (14A, from transaction)                                      BUG10810
     C                   PARM                    DDTOTI                                     BUG10810
      ** Default interest for CL and CD deals with zero notice days                         BUG10810
      ** feature flag (1A, from SCSARDPD)                                                   BUG10810
     C                   PARM                    S01468                                     BUG10810
      ** Deal notice days (3A, from transaction)                                            BUG10810
     C                   PARM                    DDNTCE                                     BUG10810
      ** Deal type (2A, from transaction)                                                   BUG10810
     C                   PARM                    DDTYPE                                     BUG10810
      ** Interest rate (11,7P,)                                                             BUG10810
     C                   PARM                    IKINTR                                     BUG10810
      ** Deal amount (15,0P, from caller)                                                   BUG10810
     C**********         PARM                    IKAMNP                            BUG10810 AR910937
     C                   PARM                    W@AMNP                                     AR910937
      ** Interest calculation method (1A, from transaction)                                 BUG10810
     C                   PARM                    DDICMT                                     BUG10810
      ** Deal value date in Midas day number format (5,0P, )                                BUG10810
     C                   PARM                    IKDVSD                                     BUG10810
      ** Currency FldNameArr OK flag (1A, )                                                 BUG10810
     C                   PARM      'Y'           DDCcyOK                                    BUG10810
      ** Number of decimal places in deal currency (1,0S, from SDCURRPD)                    BUG10810
     C                   PARM                    IKCYDP                                     BUG10810
      ** Value date field OK (1A, )                                                         BUG10810
     C                   PARM                    DDVDatOK                                   BUG10810
      ** Notice days field OK (1A, )                                                        BUG10810
     C                   PARM                    DDNtceOK                                   BUG10810
      ** Amount field OK (1A, )                                                             BUG10810
     C                   PARM                    DDAMNPOK                                   BUG10810
      ** Base Rate field OK (1A, )                                                          BUG10810
     C                   PARM                    DDBsRCOK                                   BUG10810
      ** Spread/Rate field OK (1A, )                                                        BUG10810
     C                   PARM                    DDSpRtOK                                   BUG10810
      ** Calculation method field OK (1A, )                                                 BUG10810
     C                   PARM                    DDICMTOK                                   BUG10810
      ** Maturity date (6A, from transaction)                                               BUG10810
     C                   PARM                    DDMDAT                                     BUG10810
      ** Maturity date in Midas day number format (5,0P, )                                  BUG10810
     C                   PARM                    IKMATD                                     BUG10810
      ** Maturity date field OK (1A, )                                                      BUG10810
     C                   PARM                    DDMDatOK                                   BUG10810
      ** Notice days (3,0S, )                                                               BUG10810
     C                   PARM                    IKNTCE                                     BUG10810
      ** First and last day interest flag (1A, from transaction)                            BUG10810
     C                   PARM                    DDFLID                                     BUG10810
      ** Round-down interest flag (1A, from transaction)                                    BUG10810
     C                   PARM                    DDRDFC                                     BUG10810
      ** Decimal separator (1A, from SDDEALPD)                                              BUG10810
     C                   PARM                    BNDCSP                                     BUG10810
     C                   ENDIF                                                              BUG10810
      *                                                                                       CDL093
     C     TAGCALC9      TAG                                                                  CDL093
     C                   IF        DDICMT = '9'                                               CDL093
     C                             AND (DDTYPE = 'IP' OR DDTYPE = 'IT' OR                     CDL093
     C                                  DDTYPE = 'TD' OR DDTYPE = 'TI')                       CDL093
     C                             AND IKNIPD <> 0                                            CDL093
     C                             AND #29Feb = 'Y'                                           CDL093
      * Call program to calculate interest based on Interest Calculation 9                    CDL093
     C                   MOVE      DDIPDM        @@IPDM            2 0                        CDL093
     C                   CALL      'MM001031'                                                 CDL093
     C                   PARM                    IKDVSD                                       CDL093
     C                   PARM                    IKMATD                                       CDL093
     C                   PARM                    IKNIPD                                       CDL093
     C                   PARM                    DDICMT                                       CDL093
     C                   PARM                    DDIPFQ                                       CDL093
     C                   PARM                    W@AMNP                                       CDL093
     C                   PARM                    IKINTR                                       CDL093
     C                   PARM                    DDRDFC                                       CDL093
     C                   PARM                    DDFLID                                       CDL093
     C                   PARM                    @@IPDM                                       CDL093
     C                   PARM                    WTOTI9           15 0                        CDL093
      *                                                                                       CDL093
     C                   EVAL      Amount13 = WTOTI9                                          CDL093
     C                   EVAL      NbrDecPl1 = IKCYDP                                         CDL093
     C                   CLEAR                   ReturnCode                                   CDL093
                                                                                              CDL093
     C                   CALLB     'ZA0920'                                                   CDL093
     C                   PARM                    ReturnCode       10                          CDL093
     C                   PARM                    Amount13         13 0                        CDL093
     C                   PARM                    NbrDecPl1         1 0                        CDL093
     C                   PARM                    BNDCSP                                       CDL093
     C                   PARM                    AmountOut        14                          CDL093
                                                                                              CDL093
     C                   IF        WRK9 = '*'                                                 CDL093
     C                   MOVEL     AmountOut     DDTOTI                                       CDL093
     C                   ENDIF                                                                CDL093
      *                                                                                       CDL093
      * If entered interest does not match calculated, set up error message                   CDL093
      * specifying this with the correct formatted interest amount                            CDL093
     C                   IF        WTOTI9 <> IKMTTI                                           CDL093
     C                             AND IKMTTI <> 0                                            CDL093
     C                   EVAL      Msg1 = 'MMM0453'                                           CDL093
     C                   MOVEL     AmountOut     MsgData                                      CDL093
     C                   ENDIF                                                                CDL093
      *                                                                                       CDL093
     C                   ENDIF                                                                CDL093
      *                                                                                       CDL093
                                                                                            BUG10810
     C     MSG1          IFNE      *BLANK                                                   BUG10810
     C                   ADD       1             Idx                                        BUG10810
     C                   EVAL      FldNameArr(Idx) = 'DDTOTI'                               BUG10810
     C                   EVAL      MsgIDArr(Idx) = MSG1                                     BUG10810
     C                   ENDIF                                                              BUG10810
     C     MSGDATA       IFNE      *BLANK                                                   BUG10810
     C**********         MOVEA     MSGDATA       MsgDtaArr(Idx)                      BUG10810 CDL093
     C                   EVAL      Blen = %Len(%Trim(MsgData))                                CDL093
     C                   EVAL      MsgDtaArr(Idx) = LenStr + %Trim(MsgData)                   CDL093
     C                   ENDIF                                                              BUG10810
                                                                                            BUG10810
      ** Use the return code's value to set the field's OK flag                             BUG10810
                                                                                            BUG10810
     C                   CALLB     'ZASETOKFLG'                                             BUG10810
     C                   PARM                    DDTotIOK                                   BUG10810
     C                   PARM                    ReturnCode                                 BUG10810
     C                   PARM                    WarnGlobal                                 BUG10810
                                                                                            BUG10810
      ** Set the negative indicator in step with the sign of the interest amount            BUG10810
                                                                                            BUG10810
     C     IKMTTI        IFLT      0                                                        BUG10810
     C                   MOVE      'Y'           DDNGVI                                     BUG10810
     C                   ELSE                                                               BUG10810
     C                   MOVE      ' '           DDNGVI                                     BUG10810
     C                   ENDIF                                                              BUG10810
     C                   ENDIF                                                              BUG10810
                                                                                            BUG10810
     C                   IF        CDL033 = 'Y'                                             AR851172
     C                   EXSR      ValidFxDm                                                  CDL033
     C                   EXSR      ValidFYld                                                  CDL033
     C                   MOVE      'Y'           WValidOk                                     CDL033
     C                   ENDIF                                                              AR851172
      *                                                                                       CDL033
                                                                                              247452
     C                   IF        DDTYPE = 'IP' or DDTYPE = 'TI'                             247452
     C                   IF        IKAMNP > 0                                                 247452
     C                   Z-SUB     IKAMNP        IKAMNP                                       247452
     C                   ENDIF                                                                247452
     C                   IF        IKMTTI < 0                                                 247452
     C                   Z-SUB     IKMTTI        IKMTTI                                       247452
     C                   ENDIF                                                                247452
                                                                                              247452
     C                   ELSE                                                                 247452
                                                                                              247452
     C                   IF        IKAMNP < 0                                                 247452
     C                   Z-SUB     IKAMNP        IKAMNP                                       247452
     C                   ENDIF                                                                247452
     C                   IF        IKMTTI > 0                                                 247452
     C                   Z-SUB     IKMTTI        IKMTTI                                       247452
     C                   ENDIF                                                                247452
     C                   ENDIF                                                                247452
                                                                                              247452
     C**********         ENDIF                                                         CDL033 259981

      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*

     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR

      ** Set up Source of Funds field if CDL016 is on

     C                   IF        CDL016='Y'
     C                   MOVE      DDSOFD        IKSOFD
     C                   ENDIF
                                                                                              CDL019
      ** Set up Fix Base Rate field if CDL019 is on                                           CDL019
                                                                                              CDL019
     C                   IF        CDL019='Y'                                                 CDL019
     C                   MOVE      DDFBRT        IKFBRT                                       CDL019
     C                   ENDIF                                                                CDL019
                                                                                              CDL033
      ** Set up Floating Rate field if CDL033 is on                                           CDL033
                                                                                              CDL033
     C                   IF        CDL033 = 'Y' and WValidOk = 'Y' and                        CDL033
     C                             (DDTYPE = 'CF' or                                          CDL033
     C                              DDTYPE = 'CI' or                                          CDL033
     C                              DDTYPE = 'IP' or                                          CDL033
     C                              DDTYPE = 'IT' or                                          CDL033
     C                              DDTYPE = 'TI' or                                          CDL033
     C                              DDTYPE = 'TD')                                            CDL033
                                                                                              CDL033
     C                   MOVE      WRCDT         IKRCDT                                       CDL033
     C                   MOVE      DDRCFR        IKRCFR                                       CDL033
     C                   MOVE      DDRCDM        IKRCDM                                       CDL033
     C                   MOVE      WSTRT         IKSTRT                                       CDL033
      *                                                                                       CDL033
      ** Rate Fix Day                                                                         CDL033
      *                                                                                       CDL033
     C                   MOVE      DDFXDM        IKFXDM                                       CDL033
     C                   MOVE      FWDYLD        IKFYLD                                       CDL033
     C                   MOVE      *Blank        IKBSVF                                       CDL033
     C                   Z-ADD     *ZERO         IKINFD                                       CDL033
     C                   MOVE      *Blank        IKINFF                                       CDL033
                                                                                              CDL033
     C                   IF        DDACTN = 'I'                                               CDL033
                                                                                              CDL033
     C                   EVAL      IKSTRF = *Blank                                            CDL033
     C                   EVAL      IKSTVF = *Blank                                            CDL033
                                                                                              CDL033
     C                   MOVE      *Zeros        IKAILC                                       CDL033
     C                   MOVE      *Zeros        IKACDA                                       CDL033
     C                   MOVE      *Zeros        IKBSRF                                       CDL033
     C                   BITOFF    '01234567'    IKFRCI                                       CDL033
                                                                                              CDL033
     C                   IF        WSTRT  <> STRate                                           CDL033
     C                             OR STRate <> *zeros                                      BUG13223
     C                   EVAL      IKSTRF = 'Y'                                               CDL033
     C                   EVAL      IKSTVF = 'Y'                                               CDL033
     C                   EVAL      IKBSVF = 'Y'                                               CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Calculate rate fix date based on value date or                                       CDL033
      ** rate change date.                                                                    CDL033
      *                                                                                       CDL033
     C                   Z-ADD     IKFXDM        ZRFDY                                        CDL033
     C                   MOVE      DDCCY         ZCCY                                         CDL033
      *                                                                                       CDL033
     C                   Z-ADD     WRCDT         ZINDT                                        CDL033
     C                   EXSR      DLBACK                                                     CDL033
      *                                                                                       CDL033
      ** If deal is not backvalued and short term rate on value                               CDL033
      ** date flag has not been set, rate fix date must be that                               CDL033
      ** associated with the value date.                                                      CDL033
      *                                                                                       CDL033
     C     ZRFDT         IFGE      BJRDNB                                                     CDL033
     C     IKSTVF        ANDEQ     *BLANKS                                                    CDL033
      *                                                                                       CDL033
     C                   Z-ADD     ZRFDT         IKINFD                                       CDL033
     C                   MOVE      *BLANK        IKBSVF                                       CDL033
      *                                                                                       CDL033
     C                   ELSE                                                                 CDL033
      *                                                                                       CDL033
      ** Else, rate fix date must be that associated with the                                 CDL033
      ** rate change date.                                                                    CDL033
      *                                                                                       CDL033
     C     IKRCDT        IFNE      *ZERO                                                      CDL033
     C                   Z-ADD     IKRCDT        ZINDT                                        CDL033
     C                   EXSR      DLBACK                                                     CDL033
     C                   Z-ADD     ZRFDT         IKINFD                                       CDL033
                                                                                              CDL033
     C     IKINFD        IFLT      BJRDNB                                                     CDL033
     C                   Z-ADD     *ZERO         IKINFD                                       CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ELSE                                                                 CDL033
     C                   Z-ADD     *ZERO         IKINFD                                       CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Set fixed base rate applied on value date flag                                       CDL033
      ** to 'Y' to indicate that the rate for value date                                      CDL033
      ** of deal does not need to be fixed (rate will be                                      CDL033
      ** the current effective rate).                                                         CDL033
      *                                                                                       CDL033
     C                   MOVE      'Y'           IKBSVF                                       CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** If rate fix date has changed, allow this event                                       CDL033
      ** to be processed again during COB (DL0250).                                           CDL033
      *                                                                                       CDL033
     C     IKINFD        IFNE      WINFD                                                      CDL033
     C                   MOVE      *BLANK        IKINFF                                       CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Last change date                                                                     CDL033
      *                                                                                       CDL033
     C                   Z-ADD     BJRDNB        IKLCD                                        CDL033
      *                                                                                       CDL033
      ** Last change action                                                                   CDL033
      *                                                                                       CDL033
     C                   MOVE      DDACTN        IKCHTP                                       CDL033
      *                                                                                       CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   ENDIF                                                                CDL033

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
     C                   PARM                    InfData
      * Receive Settlement Ccy, Method & Nostro and  Pay Settlement Ccy,
      * Method & Nostro, from default or valid deal
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM                    PaySetCcy
     C                   PARM                    PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM                    FrontOffice
     C                   PARM                    ExtData
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Deals layout (DS) from/to caller
     C                   PARM                    ValidDeal
     C                   PARM                    RepoFlag          1
      *
      * Autumatic Rollover of Fixed Term Loan/Deposit
     C                   PARM                    CDL016            1
      *                                                                                       CDL019
      * Allow Base Rate Changes on Fixed Deposits/Loans                                       CDL019
     C                   PARM                    CDL019            1                          CDL019
      *                                                                                       CDL020
      * Apply Base Rate at Value Date                                                         CDL020
     C                   PARM                    CDL020            1                          CDL020
      *                                                                                       CDL033
      ** Hedge Accounting Enhancement                                                         CDL033
      *                                                                                       CDL033
     C                   PARM                    CAS005            1                          CDL033
      *                                                                                       CDL033
      ** Floating Rate CDs Issued                                                             CDL033
      *                                                                                       CDL033
     C                   PARM                    CDL033            1                          CDL033
      *                                                                                       CDL033
      ** New Field STRate                                                                     CDL033
      *                                                                                       CDL033
     C                   PARM                    STRate           11 7                        CDL033
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMLDNIVL2'   DBPGM
     C                   OUT       LDA
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS                                                    242632
     C                   MOVEL     @OPTN         DBKEY                                        242632
     C                   MOVEL     'SDBANKPD'    DBFILE                                       242632
     C                   MOVEL     '900'         DBASE                                        242632
     C                   EXSR      *PSSR                                                      242632
     C                   ENDIF                                                                242632
      *                                                                                       CDL020
      ** Access MIDAS Modules details via access program                                      CDL020
      *  (database error handling done in access program)                                     CDL020
     C                   CALLB     'AOMMODR0'                                                 CDL020
     C                   PARM      '*DBERR '     @RTCD             7                          CDL020
     C                   PARM      '*FIRST '     @OPTN             7                          CDL020
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CDL020
     C     @RTCD         IFNE      *BLANKS                                                    242632
     C                   MOVEL     @OPTN         DBKEY                                        242632
     C                   MOVEL     'SDMMODPD'    DBFILE                                       242632
     C                   MOVEL     '901'         DBASE                                        242632
     C                   EXSR      *PSSR                                                      242632
     C                   ENDIF                                                                242632
      *                                                                                       CDL020
      ** Access Dealing details via access program                                            CDL020
      *  (database error handling done in access program)                                     CDL020
     C                   CALLB     'AODEALR0'                                                 CDL020
     C                   PARM      '*DBERR '     @RTCD             7                          CDL020
     C                   PARM      '*FIRST '     @OPTN             7                          CDL020
     C     SDDEAL        PARM      SDDEAL        DSFDY                                        CDL020
     C     @RTCD         IFNE      *BLANKS                                                    242632
     C                   MOVEL     'SDDEALPD'    DBFILE                                       242632
     C                   MOVEL     '902'         DBASE                                        242632
     C                   MOVEL     @OPTN         DBKEY                                        242632
     C                   EXSR      *PSSR                                                      242632
     C                   ENDIF                                                                242632
      *                                                                                       CDL033
      ** Access Dealing details via access program                                            CDL033
      *  (database error handling done in access program)                                     CDL033
      ** only when FRA/IRS in installed                                                       242632
     C     BGFIIN        IFEQ      'Y'                                                        242632
     C                   CALLB     'AOFAISR0'                                                 CDL033
     C                   PARM      '*DBERR '     @RTCD                                        CDL033
     C                   PARM      '*FIRST '     @OPTN                                        CDL033
     C     SDFAIS        PARM      SDFAIS        DSFDY                                        CDL033
     C     @RTCD         IFNE      *BLANKS                                                    242632
     C                   MOVEL     'SDFAISPD'    DBFILE                                       242632
     C                   MOVEL     '903'         DBASE                                        242632
     C                   MOVEL     @OPTN         DBKEY                                        242632
     C                   EXSR      *PSSR                                                      242632
     C                   ENDIF                                                                242632
     C                   ENDIF                                                                242632
      *                                                                                       CDL033
      ** Access Dealing details via access program                                            CDL033
      *  (database error handling done in access program)                                     CDL033
     C                   CALLB     'AOTRADR0'                                                 CDL033
     C                   PARM      '*DBERR '     @RTCD                                        CDL033
     C                   PARM      '*FIRST '     @OPTN                                        CDL033
     C     SDTRAD        PARM      SDTRAD        DSFDY                                        CDL033
     C     @RTCD         IFNE      *BLANKS                                                    242632
     C                   MOVEL     'SDTRADPD'    DBFILE                                       242632
     C                   MOVEL     '904'         DBASE                                        242632
     C                   MOVEL     @OPTN         DBKEY                                        242632
     C                   EXSR      *PSSR                                                      242632
     C                   ENDIF                                                                242632
      *
      ** Set up the name of the MSGF from which the message handler will
      ** get the messages
     C                   EVAL      #MsgFile = 'DRSMM'

                                                                                            BUG10810
      ** Access SAR details file to determine if S01468 (changed                            BUG10810
      ** validation for total interest field) is on.                                        BUG10810
                                                                                            BUG10810
     C                   CALLB     'AOSARDR0'                                               BUG10810
     C                   PARM      *BLANKS       @RTCD                                      BUG10810
     C                   PARM      '*VERIFY'     @OPTN                                      BUG10810
     C                   PARM      'S01468'      @SARD                                      BUG10810
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG10810
     C     @RTCD         IFNE      *BLANKS                                                  BUG10810
     C     @RTCD         ANDNE     '*NRF   '                                                BUG10810
     C     *LOCK         IN        LDA                                                      BUG10810
     C                   MOVEL     'SCSARDPD'    DBFILE                                     BUG10810
     C                   MOVEL     '003'         DBASE                                      BUG10810
     C                   MOVEL     'S01468'      DBKEY                                      BUG10810
     C                   OUT       LDA                                                      BUG10810
     C                   MOVE      *ON           *INU7                                      BUG10810
     C                   MOVE      *ON           *INU8                                      BUG10810
     C                   MOVE      *ON           *INLR                                      BUG10810
     C                   EXSR      #TERM                                                    BUG10810
     C                   ENDIF                                                              BUG10810
                                                                                            BUG10810
     C     @RTCD         IFEQ      *BLANK                                                   BUG10810
     C                   MOVEL     'Y'           S01468            1                        BUG10810
     C                   ELSE                                                               BUG10810
     C                   MOVEL     'N'           S01468                                     BUG10810
     C                   ENDIF                                                              BUG10810
                                                                                            BUG10810
      ** Check if CDL093 is installed                                                         CDL093
                                                                                              CDL093
     C                   CALLB     'AOSARDR0'                                                 CDL093
     C                   PARM      *BLANKS       @RTCD                                        CDL093
     C                   PARM      '*VERIFY'     @OPTN                                        CDL093
     C                   PARM      'CDL093'      @SARD                                        CDL093
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL093
                                                                                              CDL093
     C                   IF        @RTCD = *Blanks                                            CDL093
     C                   EVAL      CDL093 = 'Y'                                               CDL093
     C                   ELSE                                                                 CDL093
     C                   EVAL      CDL093 = 'N'                                               CDL093
     C                   ENDIF                                                                CDL093
                                                                                              CDL093
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      * Called by: Main processing, before each validation module     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     RESETERRS     BEGSR

     C                   RESET                   Msg1
     C                   RESET                   Msg2
     C                   RESET                   Msg3
     C                   RESET                   Msg4
     C                   RESET                   Msg5
     C                   RESET                   Msg6
     C                   RESET                   Msg7

     C                   RESET                   WMsgID1
     C                   RESET                   WMsgID2
     C                   RESET                   WMsgID3
     C                   RESET                   WMsgID4

     C                   RESET                   MSGDATA

     C                   EVAL      ReturnCode= *Blanks

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #TERM    - Termination processing.                            *
      *                                                               *
      *****************************************************************
     C     #TERM         BEGSR
      *
      **  Terminate program
      *
     C     *INU7         IFEQ      '1'
     C                   DUMP
     C                   END
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************                       CDL033
      /EJECT                                                                                  CDL033
      *****************************************************************                       CDL033
      *                                                               *                       CDL033
      * ValidRcDt  - Subroutine to validate Rate Change Date          *                       CDL033
      *                                                               *                       CDL033
      *****************************************************************                       CDL033
      *                                                                                       CDL033
     C     ValidRcDt     BEGSR                                                                CDL033
      *                                                                                       CDL033
     C                   EXSR      RESETERRS                                                  CDL033
     C                   DO                                                                   CDL033
      *                                                                                       CDL033
      ** If Rate Change Date is blank and Rate Change Freq. is not blank                      CDL033
      *                                                                                       CDL033
     C                   IF        DDRCDT = *Blanks AND                                       CDL033
     C                             DDRCFR <> *Blanks AND DDRCFROK='Y'                         CDL033
     C                   EVAL      Idx = Idx + 1                                              CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDRCDT'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = 'FLR0021'                                  CDL033
     C                   EVAL      ReturnCode = 'Error'                                       CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** If Rate Change Date is not blank but Base Rate code is blank                         CDL033
      *                                                                                       CDL033
     C                   IF        DDBSRC = *Blanks                                           CDL033
     C                   EVAL      Idx = Idx + 1                                              CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDRCDT'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = 'FLR0003'                                  CDL033
     C                   EVAL      ReturnCode = 'Error'                                       CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** If Rate Change Date is not blank, ensure that it is in valid format                  CDL033
     C                   CALLB     'ZDATE1'                                                   CDL033
     C                   PARM                    DDRCDT                                       CDL033
     C                   PARM                    ZDayNo                                       CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM                    ErrorFlag                                    CDL033
     C                   IF        ErrorFlag = 'Y'                                            CDL033
     C                   EVAL      Idx = Idx + 1                                              CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDRCDT'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = 'FLR0005'                                  CDL033
     C                   EVAL      ReturnCode = 'Error'                                       CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   EVAL      WRCDT = ZDayNo                                             CDL033
      *                                                                                       CDL033
      ** Rate Change Date should be greater than or equal to Value Date and less than         CDL033
      ** Maturity Date and greater than or equal to rundate                                   CDL033
      *                                                                                       CDL033
     C                   IF         WRCDT <  IKDVSD  OR                                       CDL033
     C                              WRCDT <  BJRDNB  OR                                       CDL033
     C                              WRCDT >= IKMATD                                           CDL033
     C                   EVAL      Idx = Idx + 1                                              CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDRCDT'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = 'FLR0006'                                  CDL033
     C                   EVAL      ReturnCode = 'Error'                                       CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Determine if Rate Change Date is holiday in the local currency                       CDL033
      *                                                                                       CDL033
     C                   IF        DDRCDT <> *Blanks AND                                      CDL033
     C                             (DDRCFR <> 'Z' AND DDRCFROK='Y')                           CDL033
                                                                                              CDL033
     C                   CALLB     'ZCHKH'                                                    CDL033
     C                   PARM      WRCDT         ZDAYNO            5 0                        CDL033
     C                   PARM      DDCCY         ZCCY                                         CDL033
     C                   PARM      *BLANK        ZLOC                                         CDL033
     C                   PARM      *BLANK        ZIND              1                          CDL033
      *                                                                                       CDL033
      ** Rate Change Date must NOT be a holiday in the local currency                         CDL033
      *                                                                                       CDL033
     C     ZIND          IFEQ      'H'                                                        CDL033
     C                   EVAL      WIdx = WIdx + 1                                            CDL033
     C                   EVAL      WFldNamArr(WIdx) = 'DDRCDT'                                CDL033
     C                   EVAL      WMsgIDArr(WIdx) = 'FLR0018'                                CDL033
     C                   EVAL      ReturnCode = 'Error'                                       CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   ENDDO                                                                CDL033
      *                                                                                       CDL033
      ** If error                                                                             CDL033
      *                                                                                       CDL033
     C                   CALLB     'ZASETOKFLG'                                               CDL033
     C                   PARM      'Y'           DDRcDtOK                                     CDL033
     C                   PARM                    ReturnCode                                   CDL033
     C                   PARM                    WarnGlobal                                   CDL033
      *                                                                                       CDL033
     C                   ENDSR                                                                CDL033
      *****************************************************************                       CDL033
      /EJECT                                                                                  CDL033
      *****************************************************************                       CDL033
      *                                                               *                       CDL033
      * ValidRcFr  - Subroutine to validate Rate Change frequency     *                       CDL033
      *                                                               *                       CDL033
      *****************************************************************                       CDL033
                                                                                              CDL033
     C     ValidRcFr     BEGSR                                                                CDL033
                                                                                              CDL033
     C                   EXSR      RESETERRS                                                  CDL033
      *                                                                                       CDL033
     C                   DO                                                                   CDL033
      *                                                                                       CDL033
      ** If Rate Change Frequency is blank                                                    CDL033
      *                                                                                       CDL033
     C                   IF        DDRCFR = *Blanks                                           CDL033
     C                   EVAL      Idx = Idx + 1                                              CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDRCFR'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = 'FLR0009'                                  CDL033
     C                   EVAL      ReturnCode = 'Error'                                       CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** If Rate Change Frequency is not blank                                                CDL033
      *                                                                                       CDL033
     C                   IF        DDRCFR <> 'M' AND                                          CDL033
     C                             DDRCFR <> 'Q' AND                                          CDL033
     C                             DDRCFR <> 'X' AND                                          CDL033
     C                             DDRCFR <> 'Y' AND                                          CDL033
     C                             DDRCFR <> 'Z'                                              CDL033
     C                   EVAL      Idx = Idx + 1                                              CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDRCFR'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = 'FLR0007'                                  CDL033
     C                   EVAL      ReturnCode = 'Error'                                       CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   ENDDO                                                                CDL033
      *                                                                                       CDL033
     C                   CALLB     'ZASETOKFLG'                                               CDL033
     C                   PARM      'Y'           DDRcfROk                                     CDL033
     C                   PARM                    ReturnCode                                   CDL033
     C                   PARM                    WarnGlobal                                   CDL033
                                                                                              CDL033
     C                   ENDSR                                                                CDL033
      *****************************************************************                       CDL033
      /EJECT                                                                                  CDL033
      *****************************************************************                       CDL033
      *                                                               *                       CDL033
      * ValidRcDm  - Subroutine to validate Rate Change Day           *                       CDL033
      *                                                               *                       CDL033
      *****************************************************************                       CDL033
                                                                                              CDL033
     C     ValidRcDm     BEGSR                                                                CDL033
                                                                                              CDL033
     C                   EXSR      RESETERRS                                                  CDL033
      *                                                                                       CDL033
      ** If Rate Change Day is not blank and Rate Change Frequency is 'Z                      CDL033
      *                                                                                       CDL033
     C                   Z-ADD     *ZERO         ##RCDM            2 0                        CDL033
                                                                                              CDL033
     C                   DO                                                                   CDL033
                                                                                              CDL033
     C                   IF        DDRCFR =  'Z'                                              CDL033
                                                                                              CDL033
     C                   IF        DDRCDM <> *Blanks                                          CDL033
     C                   EVAL      Idx = Idx + 1                                              CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDRCDM'                                 CDL033
     C                   EVAL      MsgIDArr(Idx)   = 'FLR0012'                                CDL033
     C                   EVAL      ReturnCode      = 'Error'                                  CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ELSE                                                                 CDL033
                                                                                              CDL033
     C                   IF        DDRCDM =  *Blanks                                          CDL033
                                                                                              CDL033
     C                   EVAL      Idx = Idx + 1                                              CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDRCDM'                                 CDL033
     C                   EVAL      MsgIDArr(Idx)   = 'FLR0013'                                CDL033
     C                   EVAL      ReturnCode      = 'Error'                                  CDL033
     C                   LEAVE                                                                CDL033
                                                                                              CDL033
     C                   ELSE                                                                 CDL033
      *                                                                                       CDL033
      ** It must be within the range of 0-31                                                  CDL033
      *                                                                                       CDL033
     C                   MOVEL     *BLANKS       ZFIELD                                       CDL033
     C                   CALLB     'ZALIGN'                                                   CDL033
     C                   PARM      *BLANK        ZALIGNok                                     CDL033
     C                   PARM      DDRCDM        ZFIELD                                       CDL033
     C                   PARM      0             ZADEC                                        CDL033
     C                   PARM      2             ZADIG                                        CDL033
                                                                                              CDL033
     C                   IF        ZALIGNok <> 'N'                                            CDL033
                                                                                              CDL033
     C                   MOVE      ZFIELD        ##RCDM                                       CDL033
     C                   IF        ##RCDM < 0 OR                                              CDL033
     C                             ##RCDM > 31                                                CDL033
     C                   EVAL      Idx = Idx + 1                                              CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDRCDM'                                 CDL033
     C                   EVAL      MsgIDArr(Idx)   = 'FLR0010'                                CDL033
     C                   EVAL      ReturnCode      = 'Error'                                  CDL033
     C                   LEAVE                                                                CDL033
     C                   ELSE                                                                 CDL033
      ** Update the screen field if no validation error.                                      CDL033
     C                   MOVE      ##RCDM        DDRCDM                                       CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** It must correspond to number of day in a month.                                      CDL033
      *                                                                                       CDL033
     C                   ELSE                                                                 CDL033
                                                                                              CDL033
     C                   EVAL      Idx = Idx + 1                                              CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDRCDM'                                 CDL033
     C                   EVAL      MsgIDArr(Idx)   = 'FLR0011'                                CDL033
     C                   EVAL      ReturnCode      = 'Error'                                  CDL033
     C                   LEAVE                                                                CDL033
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ENDDO                                                                CDL033
      *                                                                                       CDL033
     C                   CALLB     'ZASETOKFLG'                                               CDL033
     C                   PARM      'Y'           DDRcDmOK                                     CDL033
     C                   PARM                    ReturnCode                                   CDL033
     C                   PARM                    WarnGlobal                                   CDL033
      *                                                                                       CDL033
     C                   ENDSR                                                                CDL033
      *****************************************************************                       CDL033
      /EJECT                                                                                  CDL033
      *****************************************************************                       CDL033
      *                                                               *                       CDL033
      * ValidStRt  - Subroutine to validate Short Term Rate           *                       CDL033
      *                                                               *                       CDL033
      *****************************************************************                       CDL033
                                                                                              CDL033
     C     ValidStRt     BEGSR                                                                CDL033
                                                                                              CDL033
     C                   EXSR      RESETERRS                                                  CDL033
                                                                                              CDL033
     C                   Eval      WSTRT = *Zero                                            BUG11298
      *                                                                                       CDL033
      ** Short Term Rate should be in valid format                                            CDL033
     C                   Z-ADD     0             @@AMT                                      BUG24317
     C                   Z-ADD     0             @@ERCD                                     BUG24317
     C                   MOVEL     *BLANKS       @@ALPH                                     BUG24317
     C                   MOVEL     DDSTRT        @@ALPH                                     BUG24317
     C                   Z-ADD     4             @@IINT                                     BUG24317
     C                   Z-ADD     7             @@IDP                                      BUG24317
     C                   CALLB     'ZA0840'                                                 BUG24317
     C                   PARM                    @Rtcde                                     BUG24317
     C                   PARM                    @@ALPH                                     BUG24317
     C                   PARM                    @@IDP                                      BUG24317
     C                   PARM                    @@IINT                                     BUG24317
     C                   PARM                    @@MTID                                     BUG24317
     C                   PARM                    @@ERCD                                     BUG24317
     C                   PARM                    @@AMT                                      BUG24317
     C                   PARM                    BNDCSP                                     BUG24317
                                                                                            BUG24317
     C     @@ERCD        IFNE      0                                                        BUG24317
     C                   EVAL      Idx = Idx + 1                                            BUG24317
     C                   EVAL      FldNameArr(Idx) = 'DDSTRT'                               BUG24317
     C                   EVAL      MsgIDArr(Idx) = 'FLR0014'                                BUG24317
     C                   EVAL      ReturnCode = 'Error'                                     BUG24317
     C                   ELSE                                                               BUG24317
     C                   MOVE      @@AMT         WSTRT                                      BUG24317
     C                   ENDIF                                                              BUG24317
      *                                                                                       CDL033
     C**********         IF        DDSTRT = *Blanks or                              CDL033 AR1069531
     C**********                   DDSTRT = '0.0000000   '                           CDL033 BUG24317
     C**********                   WSTRT = 0.0000000                              BUG24317 AR1069531
     C**********         IF        DDSTRT = *Blanks                              AR1069531 AR1081796
     C                   IF        DDSTRT = *Blanks OR                                     AR1081796
     C                             WSTRT = 0.0000000                                       AR1081796
     C                   IF        DDBSRC <> *Blanks                                          CDL033
      *                                                                                       CDL033
      ** Convert rate change date to valid format                                             CDL033
      *                                                                                       CDL033
     C                   CALLB     'ZDATE1'                                                   CDL033
     C                   PARM                    DDVDAT                                       CDL033
     C                   PARM                    ZDayNo                                       CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM                    ErrorFlag                                    CDL033
      *                                                                                       CDL033
     C                   IF        ErrorFlag = 'Y'                                            CDL033
     C                   EVAL      Idx = Idx + 1                                              CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDRCDT'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = 'FLR0005'                                  CDL033
     C                   EVAL      ReturnCode = 'Error'                                       CDL033
      *                                                                                       CDL033
     C                   ELSE                                                                 CDL033
      *                                                                                       CDL033
     C                   Z-ADD     ZDayNo        ZINDT                                        CDL033
     C                   MOVE      DDFXDM        ZRFDY                                        CDL033
      *                                                                                       CDL033
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.                          CDL033
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',                            CDL033
      ** 'local currency code' or 'screen currency code' respectively                         CDL033
      *                                                                                       CDL033
     C                   IF        BQCRFH = 'F'                                               CDL033
     C                   MOVE      BLCYCD        ZCCY                                         CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   IF        BQCRFH = 'L'                                               CDL033
     C                   MOVE      BJLCCY        ZCCY                                         CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   IF        BQCRFH = 'D' OR BQCRFH = ' '                               CDL033
     C                   MOVE      DDCCY         ZCCY                                         CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   MOVE      *BLANKS       ZLOC                                         CDL033
     C                   EXSR      DLBACK                                                     CDL033
     C                   IF        ZRFDT < BJRDNB                                             CDL033
     C                   EVAL      Idx = Idx + 1                                              CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDSTRT'                                 CDL033
     C                   EVAL      MsgIDArr(Idx)   = 'FLR0022'                                CDL033
     C                   EVAL      ReturnCode      = 'Error'                                  CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   ELSE                                                                 CDL033
     C                   IF        DDBSRC = *BLANKS                                           CDL033
     C                   EVAL      Idx = Idx + 1                                              CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDBSRC'                                 CDL033
     C                   EVAL      MsgIDArr(Idx)   = 'FLR0023'                                CDL033
     C                   EVAL      ReturnCode      = 'Error'                                  CDL033
     C**********         ELSE                                                        CDL033 BUG24317
     C**********         MOVEL     *BLANKS       ZFIELD                              CDL033 BUG24317
     C**********         CALLB     'ZALIGN'                                          CDL033 BUG24317
     C**********         PARM      *BLANK        ZALIGNok                            CDL033 BUG24317
     C**********         PARM      DDSTRT        ZFIELD                              CDL033 BUG24317
     C**********         PARM      7             ZADEC                               CDL033 BUG24317
     C**********         PARM      4             ZADIG                               CDL033 BUG24317
                                                                                              CDL033
     C**********         IF        ZALIGNok = 'N'                                    CDL033 BUG24317
     C**********         EVAL      Idx = Idx + 1                                     CDL033 BUG24317
     C**********         EVAL      FldNameArr(Idx) = 'DDSTRT'                        CDL033 BUG24317
     C**********         EVAL      MsgIDArr(Idx) = 'FLR0014'                         CDL033 BUG24317
     C**********         EVAL      ReturnCode = 'Error'                              CDL033 BUG24317
     C**********         ELSE                                                        CDL033 BUG24317
     C**********         MOVE      ZFIELD        WSTRT                               CDL033 BUG24317
     C**********         ENDIF                                                       CDL033 BUG24317
      *                                                                                       CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   CALLB     'ZASETOKFLG'                                               CDL033
     C                   PARM      'Y'           DDStRtOK                                     CDL033
     C                   PARM                    ReturnCode                                   CDL033
     C                   PARM                    WarnGlobal                                   CDL033
                                                                                              CDL033
     C                   ENDSR                                                                CDL033
      *****************************************************************                       CDL033
      /EJECT                                                                                  CDL033
      *****************************************************************                       CDL033
      *                                                               *                       CDL033
      * ValidFxDm  - Subroutine to validate Rate Fix Days             *                       CDL033
      *                                                               *                       CDL033
      *****************************************************************                       CDL033
                                                                                              CDL033
     C     ValidFxDm     BEGSR                                                                CDL033
                                                                                              CDL033
     C                   EXSR      RESETERRS                                                  CDL033
                                                                                              CDL033
     C                   Z-ADD     *ZEROS        ##FXDM            2 0                        CDL033
      *                                                                                       CDL033
      ** If Rate fix days is not blank and Base Rate Code is blank                            CDL033
      *                                                                                       CDL033
     C                   DO                                                                   CDL033
      *                                                                                       CDL033
     C                   IF        DDFXDM <> *blanks AND                                      CDL033
     C                             DDBSRC  = *blanks                                          CDL033
     C                   EVAL      Idx             =  Idx + 1                                 CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDFXDM'                                 CDL033
     C                   EVAL      MsgIDArr(Idx)   = 'FLR0015'                                CDL033
     C                   EVAL      ReturnCode      = 'Error'                                  CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   IF        DDFXDM <> *Blanks                                          CDL033
      *                                                                                       CDL033
      ** It must be within the range of 0-31                                                  CDL033
      *                                                                                       CDL033
     C                   MOVEL     *BLANKS       ZFIELD                                       CDL033
     C                   CALLB     'ZALIGN'                                                   CDL033
     C                   PARM      *BLANK        ZALIGNok                                     CDL033
     C                   PARM      DDFXDM        ZFIELD                                       CDL033
     C                   PARM      0             ZADEC                                        CDL033
     C                   PARM      2             ZADIG                                        CDL033
                                                                                              CDL033
     C                   IF        ZALIGNok =  'Y'                                            CDL033
                                                                                              CDL033
     C                   MOVE      ZFIELD        ##FXDM                                       CDL033
                                                                                              CDL033
     C                   IF        ##FXDM < 1 or                                              CDL033
     C                             ##FXDM >99                                                 CDL033
     C                   EVAL      Idx             =  Idx + 1                                 CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDFXDM'                                 CDL033
     C                   EVAL      MsgIDArr(Idx)   = 'FLR0017'                                CDL033
     C                   EVAL      ReturnCode      = 'Error'                                  CDL033
     C                   LEAVE                                                                CDL033
     C                   ELSE                                                                 CDL033
      ** Update the screen field if no validation error encountered.                          CDL033
     C                   MOVE      ##FXDM        DDFXDM                                       CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ELSE                                                                 CDL033
                                                                                              CDL033
     C                   EVAL      Idx             =  Idx + 1                                 CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDFXDM'                                 CDL033
     C                   EVAL      MsgIDArr(Idx)   = 'FLR0016'                                CDL033
     C                   EVAL      ReturnCode      = 'Error'                                  CDL033
     C                   LEAVE                                                                CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ENDDO                                                                CDL033
                                                                                              CDL033
     C                   CALLB     'ZASETOKFLG'                                               CDL033
     C                   PARM      'Y'           DDFxDmOK                                     CDL033
     C                   PARM                    ReturnCode                                   CDL033
     C                   PARM                    WarnGlobal                                   CDL033
                                                                                              CDL033
     C                   ENDSR                                                                CDL033
      *****************************************************************                       CDL033
      /EJECT                                                                                  CDL033
      *****************************************************************                       CDL033
      *                                                               *                       CDL033
      * ValidFYId  - Subroutine to validate Forward Yield Curve       *                       CDL033
      *                                                               *                       CDL033
      *****************************************************************                       CDL033
                                                                                              CDL033
     C     ValidFYld     BEGSR                                                                CDL033
                                                                                              CDL033
     C                   EXSR      RESETERRS                                                  CDL033
                                                                                              CDL033
     C                   CALLB     'MMVFWDYLD'                                                CDL033
     C                   PARM      *Blanks       RTNCDE                                       CDL033
     C                   PARM      DDFYLD        FWDYLD                                       CDL033
     C                   PARM      DDTYPE        Deltyp                                       CDL033
     C                   PARM      DDSTYP        Dlstyp                                       CDL033
     C                   PARM                    CAS005                                       CDL033
     C                   PARM      *Blank        MSGID                                        CDL033
     C                   PARM      *Blank        MSGDTA                                       CDL033
                                                                                              CDL033
     C                   IF        RTNCDE <> *Blanks                                          CDL033
     C                   EVAL      Idx = Idx + 1                                              CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDFYLD'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = MSGID                                      CDL033
     C                   EVAL      MsgDtaArr(Idx) = MSGDTA                                    CDL033
     C                   EVAL      ReturnCode = 'Error'                                       CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   CALLB     'ZASETOKFLG'                                               CDL033
     C                   PARM      'Y'           DDFYldOK                                     CDL033
     C                   PARM                    ReturnCode                                   CDL033
     C                   PARM                    WarnGlobal                                   CDL033
                                                                                              CDL033
     C                   ENDSR                                                                CDL033
      *****************************************************************                     BUG10810
      /EJECT                                                                                BUG10810
      *****************************************************************                     BUG10810
      *                                                               *                     BUG10810
      * ValidActInt- Subroutine to validate Actual Interest rate      *                     BUG10810
      *                                                               *                     BUG10810
      *****************************************************************                     BUG10810
                                                                                            BUG10810
     C     ValidActInt   BEGSR                                                              BUG10810
                                                                                            BUG10810
     C     CDL020        IFEQ      'Y'                                                      BUG10810
                                                                                            BUG10810
     C                   EXSR      RESETERRS                                                BUG10810
                                                                                            BUG10810
     C                   CALLB     'MMVACTINTR'                                             BUG10810
     C                   PARM                    ReturnCode                                 BUG10810
     C                   PARM                    MSG1                                       BUG10810
     C                   PARM                    DDAIR                                      BUG10810
     C                   PARM                    BGN0ST                                     BUG10810
     C                   PARM                    BNDCSP                                     BUG10810
     C                   PARM                    DDCCY                                      BUG10810
     C                   PARM                    DDBSRC                                     BUG10810
     C                   PARM                    IKDVSD                                     BUG10810
     C                   PARM                    BJRDNB                                     BUG10810
     C                   PARM                    IKSPRD                                     BUG10810
     C                   PARM                    IKINTR                                     BUG10810
                                                                                            BUG10810
     C                   IF        MSG1 <> *Blanks                                          BUG10810
     C                   EVAL      Idx = Idx + 1                                            BUG10810
     C                   EVAL      FldNameArr(Idx) = 'DDAIR'                                BUG10810
     C                   EVAL      MsgIDArr(Idx) = MSG1                                     BUG10810
     C                   ENDIF                                                              BUG10810
                                                                                            BUG10810
      ** Use the return code's value to set the field's OK flag                             BUG10810
     C                   CALLB     'ZASETOKFLG'                                             BUG10810
     C                   PARM                    DDAIROK                                    BUG10810
     C                   PARM                    ReturnCode                                 BUG10810
     C                   PARM                    WarnGlobal                                 BUG10810
                                                                                            BUG10810
     C                   ENDIF                                                              BUG10810
                                                                                            BUG10810
     C                   ENDSR                                                              BUG10810
      *****************************************************************                       CDL033
      *                                                               *                       CDL033
      *   DLBACK - To calculate Rate Fix Date                         *                       CDL033
      *                                                               *                       CDL033
      *****************************************************************                       CDL033
      *                                                                                       CDL033
     C     DLBACK        BEGSR                                                                CDL033
      *                                                                                       CDL033
      ** Input field ZLOC contains the relevant Branch Location                               CDL033
      *                                                                                       CDL033
      ** Initialise Work Field                                                                CDL033
      *                                                                                       CDL033
     C                   Z-ADD     0             ZWKFLD                                       CDL033
      *                                                                                       CDL033
      ** Set Rate Fix Date equal to Input Date                                                CDL033
      *                                                                                       CDL033
     C                   Z-ADD     ZINDT         ZRFDT             5 0                        CDL033
      *                                                                                       CDL033
      ** Perform the following processing until the work field is                             CDL033
      ** greater than or equal to the Rate Fix Days                                           CDL033
      *                                                                                       CDL033
     C     ZWKFLD        DOUGE     ZRFDY                                                      CDL033
      *                                                                                       CDL033
      ** If the Rate Fix Days are not equal to zero subtract 1                                CDL033
      ** from the Rate Fix Date                                                               CDL033
      *                                                                                       CDL033
     C     ZRFDY         IFNE      0                                                          CDL033
     C                   SUB       1             ZRFDT                                        CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** The following is repeated until the resultant date is                                CDL033
      ** proved to be a working day in the relevant currency and                              CDL033
      ** location.                                                                            CDL033
      ** Call ZCHKH to check Rate Fix Date for a holiday                                      CDL033
      *                                                                                       CDL033
     C     ZIND          DOUEQ     'W'                                                        CDL033
      *                                                                                       CDL033
     C                   CALLB     'ZCHKH'                                                    CDL033
     C                   PARM      ZRFDT         ZDAYNO            5 0                        CDL033
     C                   PARM      DDCCY         ZCCY              3                          CDL033
     C                   PARM      *BLANK        ZLOC              3                          CDL033
     C                   PARM      *BLANK        ZIND              1                          CDL033
      *                                                                                       CDL033
      ** If date is a Holiday (ZIND = 'H'), Subtract 1 from Rate Fix Date                     CDL033
      ** Subtract 1 from Rate Fix Date                                                        CDL033
      *                                                                                       CDL033
     C     ZIND          IFEQ      'H'                                                        CDL033
     C                   SUB       1             ZRFDT                                        CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   ENDDO                                                                CDL033
      *                                                                                       CDL033
      ** When a working day has been found, add 1 to the Work Field                           CDL033
      *                                                                                       CDL033
     C                   ADD       1             ZWKFLD                                       CDL033
     C                   ENDDO                                                                CDL033
      *                                                                                       CDL033
     C                   ENDSR                                                                CDL033
     C/COPY ZSRSRC,ZFEB29Z2LE                                                                 CDL093
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 CDL093
      ********************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,DBERREXIT
      ********************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
     X/COPY ZSRSRC,ZDATE9Z4                                                                   CDL093
