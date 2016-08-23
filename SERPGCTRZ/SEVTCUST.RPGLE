     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate trade customer')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVTCUST - Validate Trade Customer                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. 256763             Date 26Mar15               *
      *  Prev Amend No. MD000091           Date 15May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245173             Date 23Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8101            Date 04Aug05               *
      *                 BUG8039            Date 02Aug05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 208192             Date 22Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 190779             Date 19Jun01               *
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 28Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 31Aug99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 20Mar98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256763 - SE2640P1 imbalance due to wrong depot position.     *
      *           Reverse fix 233083. Applied for MD033734.           *
      *  MD000091 - Event Codes Substitution                          *
      *  245173 - Apply fixes 233083 and EMFIX                        *
      *  233083 - Reverse fix 208192 to allow internal customer       *
      *  EMFIX   - Should accept classification 'S' if Tof is on.     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8101 - Correction to IF/OR conditioning for BUG8039       *
      *  BUG8039 - Counterparty mandatory on incomplete deals as no   *
      *            longer amendable on second screen                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  208192 - TRIP/TRDN, wrong input write-protects settlement    *
      *           details.  Fix is to amend validation for error id   *
      *           'MMA0116' by adding condition to issue error if     *
      *           action is 'I'nsert, customer is 'I'nternal and if   *
      *           PB Order Number is blank.                           *
      *  CAP067 - Repurchase Agreements API.                          *
      *  190779 - ? processing calls incorrect screen.                *
      *  CSE022 - Depository Definition Enhancement                   *
      *  CPB002 - If PB order number is not 000000 and not 999999,    *
      *           the trade is coming from Tof and is related to a    *
      *           book transfer. In this case, allow the internal     *
      *           customer number as counterparty                     *
      *  CSE023 - Treaty Withholding Tax.                             *
      *  CPB001 - 'Private Banking' Module                            *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
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
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
 
      ** Customer file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Securities clients
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** PM Customer Details
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
 
      ** DS for Access Programs, (Short DS)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for Access Programs, (Long DS)
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                CPB001
      ** DS for Access Programs, (very Long DS)                                 CPB001
     D DSLDY         E DS                  EXTNAME(DSLDY)                       CPB001
                                                                                              CSD025
      ** Externally described DS for SAR details                                              CSD025
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD025
 
    2** Input parameters on call to AOPLCSR1
 
     D I@PARM          DS           256
     D  I#PORS                 1      1
     D  I#R997                 2      5
     D  I#CUST                 6     15
     D  I#BRCA                16     18
     D  I#BOOK                19     20
     D  I#PTFR                21     24
     D  I#CPGM                25     34
      *
      ** Output parameters on call to AOPLCSR1
      *
     D O@PARM          DS           256
     D  O#BOOK                 1      2
     D  O#PTFR                 3      6
     D  O#BICN                 7     12
     D  O#CRNM                13     22
     D  O#ACOF                23     24
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D*TCNR*****       S              6S 0                                                    CSD027
     D TCNR            S              6A                                                      CSD027
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      ** Clear output trade fields
 
     C**********         Z-ADD     *ZERO         TCNR                                         CSD027
     C                   EVAL      TCNR = *BLANKS                                             CSD027
     C                   CLEAR                   CustDts
      *
      ** VALIDATION
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      CNUMV
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCNUMOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     CNUMV         BEGSR
 
      * If '?' entered, display securities customers
      *                                                                                       190779
      * Only allow search against the first character as searching with                       190779
      * other characters i.e ?00505 displays different screen.                                190779
      *                                                                                       190779
     C                   IF        %subst(DDCNUM:1:1) =  '?'                                  190779
     C                   MOVE      *Blanks       DDCNUM                                       190779
     C                   MOVEL     '?'           DDCNUM                                       190779
     C                   END                                                                  190779
      *                                                                                       190779
 
     C     DDCNUM        IFEQ      '?'
     C                   MOVEL     *BLANK        DDCNUM
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD                                         S0111
     C                   PARM      '*KEY   '     @OPTN                                         S0111
     C                   PARM      '?      '     @SCKY                                         S0111
     C     SDSECS        PARM      SDSECS        DSSDY                                         S0111
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BFCUST        DDCNUM
     C                   END
     C                   END
      *
      ** Client Number/Name
      *
      ** .. mandatory if Incomplete Indicator = 'C'
      *
     C     DDINCS        IFEQ      'C'
     C     DDCNUM        ANDEQ     *BLANKS                                                   BUG8101
     C     DDINCS        OREQ      'I'                                                       BUG8039
     C     DDCNUM        ANDEQ     *BLANKS
     C                   MOVE      'N'           DDCnumOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCNUM'      FldNamXAr(Idx)
      **********         MOVEL     'MMA0115'     MsgIdXAr(Idx)                               BUG8039
     C                   MOVEL     'SEA0124'     MsgIdXAr(Idx)                               BUG8039
     C                   END
 
      * If entered, must be a valid shortname or number on SDCUSTPD
 
     C     DDCNUM        IFNE      *BLANKS
 
     C*****              CALLB     'AOCUSTR0'                                                 CSD025
     C                   CALLB     'AOCUSTR1'                                                 CSD025
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCNUM        @KEY1            10                           S0111
     C                   PARM                    @KYST             7                           S0111
     C*****SDCUST        PARM      SDCUST        DSSDY                          O:Format      CSD025
     C     SDCUST        PARM      SDCUST        DSLDY                          O:Format      CSD025
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDCnumOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCNUM'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0116'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVEL     BBCOLC        CustCOLC                       CSE023
      *
      ** .. and must be a valid client number on SDSECSPD
      *
     C                   CALLB     'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD                                         S0111
     C                   PARM      '*KEY   '     @OPTN                                         S0111
     C                   PARM      BBCUST        @SCKY             6                           S0111
     C     SDSECS        PARM      SDSECS        DSSDY                                         S0111
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDCnumOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCNUM'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0116'     MsgIdXAr(Idx)
     C                   ELSE
 
      ** Must be a valid classification
 
     C     BFCLAS        IFEQ      'I'
     C     DDACTN        ANDEQ     'I'
     C     DDORDE        ANDEQ     '000000'                                                   CPB002
     C     BFCLAS        OREQ      'I'                                                        CPB002
     C     DDACTN        ANDEQ     'I'                                                        CPB002
     C     DDORDE        ANDEQ     '999999'                                                   CPB002
     C***  BFCLAS        OREQ      'I'                                                 208192 233083
     C***  DDACTN        ANDEQ     'I'                                                 208192 233083
     C***  DDORDE        ANDEQ     '      '                                            208192 233083
     C     BFCLAS        OREQ      'I'                                                        256763
     C     DDACTN        ANDEQ     'I'                                                        256763
     C     DDORDE        ANDEQ     '      '                                                   256763
     C     BFCLAS        OREQ      'C'
     C*****BFCLAS        OREQ      'K'                                                        CSE022
     C     BFCLAS        OREQ      'E'
     C     BFCLAS        OREQ      'X'
     C                   MOVE      'N'           DDCnumOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCNUM'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0116'     MsgIdXAr(Idx)
     C                   ELSE
      *                                                                                       CAP067
      ** If transaction comes from buy-sell back API and is the first leg,                    CAP067
      ** store trade customer                                                                 CAP067
      *                                                                                       CAP067
     C     PFBYSL        IFEQ      'Y'                                                        CAP067
     C                   MOVE      BFCUST        PFTCNR                                       CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
      ** If transaction comes from buy-sell back API and is the second leg,                   CAP067
      ** it must be the same as the its first leg's Counterparty, else error                  CAP067
      *                                                                                       CAP067
     C     PFBYSL        IFEQ      'N'                                                        CAP067
     C**********         MOVE      BFCUST        WKTCNR            6 0                 CAP067 CSD027
     C                   MOVE      BFCUST        WKTCNR            6                          CSD027
     C     WKTCNR        IFNE      PFTCNR                                                     CAP067
     C                   MOVEL     'N'           DDCnumOK                                     CAP067
     C                   ADD       1             Idx                                          CAP067
     C                   MOVEL     'DDCNUM'      FldNamXAr(Idx)                               CAP067
     C                   MOVEL     'MMA1216'     MsgIdXAr(Idx)                                CAP067
     C                   ENDIF                                                                CAP067
     C                   ENDIF                                                                CAP067
      *
      * Update trade counterparty and store counterparty details
      *
     C                   MOVE      BFCUST        TCNR
     C                   MOVE      BFCUST        CustNum
     C                   MOVE      BFACCD        CustAccd                                      S0111
     C                   MOVE      BFCYCD        CustCurr                                      S0111
     C                   MOVE      BFACSN        CustAcsq                                      S0111
     C                   MOVE      BFCLAS        CustClass                                     S0111
     C                   MOVEL     BFNDR1        BFDRF1                                       CSE022
     C                   MOVEL     BFNDR2        BFDRF2                                       CSE022
     C                   MOVE      BFDRF1        CustDpRef1                                    S0111
     C                   MOVE      BFDRF2        CustDpRef2                                    S0111
     C                   MOVE      BFPNP1        CustPNP1                                      S0111
     C                   MOVE      BFPNP2        CustPNP2                                      S0111
     C                   MOVE      BFTCD         CustTAXC                                      S0111
     C                   MOVE      BFASIN        CustAUTS                               E17228 S0111
     C                   MOVE      BFTDCG        CustTDCG                                      07845
      *
      * If customer portfolios installed, and customer is a PM customer
      * Set PM customer details
      *
     C     BGPFMG        IFEQ      'Y'
     C     FCPORS        ANDNE     'B'
     C                   EXSR      AOPLCS
     C     ERPLCS        IFNE      'PMA0008'
     C     ERPLCS        ANDNE     'PMA0009'
     C                   MOVEL     'Y'           CustPM                                        07845
     C                   MOVEL     QBCSBY        CustPMCSBY                                    07845
     C                   MOVEL     QBBYDP        CustPMBYDP                                    07845
     C                   MOVEL     QBDFPO        CustPMDFPO                                    07845
     C                   END
     C                   END
      *                                                                         CPB001
      * If Private Banking Module installed, and customer is a PB customer      CPB001
      * Set PB customer details                                                 CPB001
      *                                                                         CPB001
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C                   CALLB     'AOCUSTR1'                                   CPB001
     C                   PARM      *BLANKS       @RTCD                          CPB001
     C                   PARM      '*KEY   '     @OPTN                          CPB001
     C                   PARM      DDCNUM        @KEY1                          CPB001
     C                   PARM                    @KYST                          CPB001
     C     SDCUST        PARM      SDCUST        DSLDY                          CPB001
                                                                                CPB001
     C     @RTCD         IFEQ      *BLANKS                                      CPB001
     C     BBPRBA        ANDEQ     'Y'                                          CPB001
     C                   MOVEL     'Y'           CustPB                         CPB001
     C                   ENDIF                                                  CPB001
     C                   ENDIF                                                  CPB001
     C                   END
     C                   END
     C                   END
     C                   END
 
     C                   IF        CSD025 = 'Y'                                               CSD025
     C                             and BBDEAC = 'Y' and DDACTN = 'I'                          CSD025
     C                   MOVEL     'N'           DDCnumOK                                     CSD025
     C                   ADD       1             Idx                                          CSD025
     C                   MOVEL     'DDCNUM'      FldNamXAr(Idx)                               CSD025
     C                   EVAL      MsgIdXAr(IDx) = 'ABM0027'                                  CSD025
     C**********         EVAL      MsgDtaXAr(IDx) = BBCUST                           CSD025 MD000091
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(BBCUST)                   MD000091
     C                   ENDIF                                                                CSD025
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  AOPLCS - Subroutine to call AOPLCSR1                         *
      *                                                               *
      *****************************************************************
     C     AOPLCS        BEGSR
      *
     C                   MOVEL     FCPORS        I#PORS
     C                   MOVEL     FCR997        I#R997
     C                   MOVEL     TCNR          I#CUST
     C                   MOVEL     *BLANKS       I#BRCA
     C                   MOVEL     *BLANKS       I#BOOK
     C                   MOVEL     *BLANKS       I#PTFR
     C                   MOVEL     *BLANKS       I#CPGM
      *
     C                   CALL      'AOPLCSR1'
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM                    I@PARM                         I:Parameters
     C                   PARM      *BLANKS       O@PARM                         O:Parameters
     C     SDPLCS        PARM      SDPLCS        DSFDY                          O:Format
      *
     C                   MOVEL     P@RTCD        ERPLCS            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDCNUM           10
     C                   PARM                    DDACTN            1
     C                   PARM                    DDINCS            1
      *                                                                                       CAP067
      ** First Buy-sell back indicator                                                        CAP067
     C                   PARM                    PFBYSL            1                          CAP067
      *                                                                                       CAP067
      ** First Buy-sell counterparty                                                          CAP067
     C**********         PARM                    PFTCNR            6 0                 CAP067 CSD027
     C                   PARM                    PFTCNR            6                          CSD027
      *
      ** ICD
     C                   PARM                    BGPFMG            1
     C                   PARM                    FCPORS            1
     C                   PARM                    FCR997            4
     C                   PARM                    BGN4ST            1                          CPB001
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Customer - OK
     C                   PARM                    DDCNUMOK          1
      *
      ** Trade Counterparty
      *
     C                   PARM                    TCNR
      *
      ** Trade Counterparty details
     C                   PARM                    CustDts                                       S0111
      *                                                                                       CPB002
      ** PB Order Number                                                                      CPB002
     C                   PARM                    DDORDE            6
      *
      ** Check if CSD025 (Customer De-Activation) is active                                   CSD025
      *                                                                                       CSD025
     C                   CALLB     'AOSARDR0'                                                 CSD025
     C                   PARM      *BLANKS       PRtCd             7                          CSD025
     C                   PARM      '*VERIFY'     POptn             7                          CSD025
     C                   PARM      'CSD025'      PSARD             6                          CSD025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD025
                                                                                              CSD025
     C                   MOVE      'N'           CSD025            1                          CSD025
     C                   IF        PRtCd = *Blanks                                            CSD025
     C                   EVAL      CSD025 = 'Y'                                               CSD025
     C                   ENDIF                                                                CSD025
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
