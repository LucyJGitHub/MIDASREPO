     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate ordering institution - detail')      *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVODIS01 - Validate Detail Ordering Institution             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD034726           Date 18Jun15               * 
      *  Prev Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25884           Date 08Sep09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15291           Date 12Nov07               *
      *                 BUG15279           Date 08Nov07               *
      *                 BUG15198           Date 02Nov07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184049             Date 26Sep00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSW200             Date 21Aug00               *
      *                 178114             Date 20Apr00               *
      *                 CFT008  *CREATE    Date 06Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD034726 - Incorrect field highlighted for Ordering          *
      *             Institution 1 error                               *      
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG25884 - When a valid IBAN is entered in Ordering Customer *
      *             header, Ordering Institution should not be        *
      *             mandatory.                                        *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15291 - The system does not accept (/) followed by        *
      *             a valid IBAN  as a valid account.                 *
      *  BUG15279 - Error exist in pay currency                       *
      *  BUG15198 - No MT102/Error generating MT102 message for       *
      *             outgoing CCTD                                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184049 - Function leaves ordering institution account type   *
      *           according to ordering customer account when an      *
      *           ordering institution account not found.             *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CSW200 - SWIFT 2000 enhancements                             *
      *  178114 - GEMS Error Number - Ordering institution highlighted*
      *           in error when retail account number entered, with   *
      *           msg 'RFV0377'.                                      *
      *  CFT008 - Funds Transfer/Swift Messages MT102                 *
      *                                                               *
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H)
 
      ** Detail record datastructure
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)
 
      ** External Data structure to hold the outgoing record format
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for access programs (Long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * OK Flags for first screen - Detail
     D OKFlagDs1     E DS                  EXTNAME(FTE102S1PD)
 
      * OK Flags for Second screen - Detail
     D OKFlagDs2     E DS                  EXTNAME(FTE102S2PD)
 
      * OK Flags for first screen - Header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
      * OK Flags for Second screen - Header
     D OKFlagHs2     E DS                  EXTNAME(FTE102H2PD)
 
     D N@FMT         E DS                  EXTNAME(SDNOSTPD)
 
      ** External data structure for Customer standing data
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CFT004          S              1    INZ(' ')
     D wvalid          S              1
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
      ** Field in error
     D DDsName         S             10
 
     D  WCust          S                   Like(CNUM)
     D  @Type          S                   Like(@Rtcd)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      ** Initialise fields
      *
     C                   EVAL      RetCodeIn  = *Blanks
     C                   EVAL      Idx        = 0
     C                   EVAL      WIx        = 0
     C                   EVAL      Okoi35     = 'Y'
     C                   EVAL      OKoi11     = 'Y'
     C                   EVAL      PType      = *Blanks
     C                   EVAL      POrdITp    = *Blanks
     C                   EVAL      BBCSID     = *Blanks
     C**********         EVAL      Wcust      = *Zeros                                        CSD027
     C                   EVAL      Wcust      = *Blanks                                       CSD027
      *
      ** Main processing
      *
     C                   EXSR      VALIDATE
      *
      ** Valid Account
      *
     C*******************IF        OKOi35 <> 'N' AND OKoi11 <> 'N'                184049
      *******************                                                         184049
     C*******************EXSR      ValAcct                                  178114184049
     C*******************SELECT                                                   184049
     C*******************WHEN      PType = 'IBAN'                                 184049
     C*******************EVAL      POrdItp = 'I'                                  184049
     C*******************WHEN      PType = '*LEDGER'                              184049
     C*******************EVAL      POrdItp = 'G'                                  184049
     C*******************WHEN      PType = '*NOSTRO'                              184049
     C*******************EVAL      POrdItp = 'F'                                  184049
     C*******************WHEN      PType = '*RETAIL'                              184049
     C*******************EVAL      POrdItp = 'R'                                  184049
     C*******************ENDSL                                                    184049
      *******************                                                         184049
     C*******************ENDIF                                                    184049
      *
 
      * Now validate that all data entered is OK for SWIFT
 
     C                   If        POrdi35 <> *Blanks
     C                   CallB     'FTVSFTX01'
     C                   Parm                    RetCdeIn         10
     C                   Parm      POrdi35       Swift_Text       50
     C                   If        RetCdeIn = 'Error'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =  'RFV0364'
     C                   Eval      FldNamXAr(Idx) =  DDSName
     C                   EVAL      Okoi35     = 'N'
     C                   Endif
     C                   Endif
 
 
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALIDATE - Main validation processing                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: ValAcct                                                *
      *                                                               *
      *****************************************************************
      *
     C     VALIDATE      BEGSR
      *
      ** If this field has already been entered in the header, entry here is
      ** prohibited.  Otherwise, this entry is conditional.
      *
     C                   IF        HPOinst3 <> *Blanks
      *
     C                   IF        POrdi35 <> *Blanks
     C                   EVAL      Okoi35 = 'N'
     C                   EVAL      Idx            = Idx + 1
     C                   EVAL      RetCodeIn      =   '*Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0251'
     C                   EVAL      FldNamXAr(Idx) =   DDSName
     C                   ENDIF
      *
     C                   IF        POrdi11 <> *Blanks
     C                   EVAL      Okoi11 = 'N'
     C                   EVAL      Idx            = Idx + 1
     C                   EVAL      RetCodeIn      =   '*Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0251'
     C                   EVAL      FldNamXAr(Idx) =   'PORDI11'
     C                   ENDIF
      *
     C                   ELSE
      *
      * If entered, check to see if an account.  If so, ensure that has BIC
      *
     C                   If        %Subst(POrdi35:1:2) <> '//'  AND
     C                             POrdi35 <> *Blanks
     C                   SELECT                                                 178114
     C                   WHEN      %Subst(POrdi35:1:1) <> '/'  AND              178114
     C                             POrdi35 <> *Blanks                           178114
     C                   EVAL      PAcct = POrdi35                              178114
     C                   WHEN      %Subst(POrdi35:1:1) = '/'  AND               178114
     C                             POrdi35 <> *Blanks                           178114
     C                   EVAL      PAcct = %Subst(POrdi35:2)                    178114
     C                   ENDSL                                                  178114
      *                                                                         178114
     C                   EXSR      ValAcct                                      178114
     C                   If        Wvalid = 'Y'                                 178114
     C                   Movel     WCust         @Key
     C
     C                   CallB     'AOCUSTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm                    @Key             10
     C                   Parm                    @Keyst            7
     C     SDCUST        Parm      *Blanks       DSSDY
 
     C                   If        @Rtcd  <> *Blanks  OR
     C                             BBCSID = *Blanks
 
     C                   Eval      Okoi35 = 'N'
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0377'
     C                   Eval      FldNamXAr(Idx) =   DDSName
 
     C                   Endif
 
     C                   SELECT                                                   184049
     C                   WHEN      PType = 'IBAN'                                 184049
     C                   EVAL      POrdItp = 'I'                                  184049
     C                   WHEN      PType = '*LEDGER'                              184049
     C                   EVAL      POrdItp = 'G'                                  184049
     C                   WHEN      PType = '*NOSTRO'                              184049
     C                   EVAL      POrdItp = 'F'                                  184049
     C                   WHEN      PType = '*RETAIL'                              184049
     C                   EVAL      POrdItp = 'R'                                  184049
     C                   ENDSL                                                    184049
      ** Invalid account                                                                    BUG15198
     C                   Else                                                               BUG15198
     C                   IF        PORDI35 <> *Blanks And                                   BUG15198
     C                             PCCTTYP = 'BO'                                           BUG15198
     C                   EVAL      Okoi35 = 'N'                                             BUG15198
     C                   EVAL      Idx            = Idx + 1                                 BUG15198
     C                   EVAL      RetCodeIn      =   '*Error'                              BUG15198
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0240'                             BUG15198
     C                   EVAL      FldNamXAr(Idx) =   'PORDI35'                             BUG15198
     C                   ENDIF                                                              BUG15198
      *                                                                                     BUG15198
     C                   Endif
     C                   Endif
      *
      ** It must be entered if there isn't a valid account in one of th
      ** ordering customer fields
      *
     C                   IF        POrdi35 = *blanks AND POrdi11 = *Blanks
     C                   SELECT
     C                   WHEN      HPTocus1 <> *blanks
     C                   IF        %SUBST(HPTocus1:1:1) = '/'                               BUG25884
     C                   EVAL      PAcct = %SUBST(HPTocus1:2:34)                            BUG25884
     C                   ELSE                                                               BUG25884
     C                   EVAL      PAcct = HPTocus1
     C                   ENDIF                                                              BUG25884
     C                   WHEN      POrdCu1 <> *blanks
     C                   IF        %SUBST(POrdCu1:1:1) = '/'                                BUG15291
     C                   EVAL      PAcct = %SUBST(POrdCu1:2:%LEN(POrdCu1) -1)               BUG15291
     C                   ELSE                                                               BUG15291
     C                   EVAL      PAcct = POrdCu1
     C                   ENDIF                                                              BUG15291
     C                   ENDSL
     C                   EXSR      ValAcct
     C                   EVAL      Ptype = *Blanks
      *
     C                   IF        WValid = 'N'   AND
     C                             PCCTTYP = 'BO'
     C                   EVAL      Okoi35 = 'N'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0343'
     C                   EVAL      FldNamXAr(Idx) =   'POrdi35'
     C                   ENDIF
     C                   ELSE
      *
      ** It must not be the same as the sending institution
      *
     C                   SELECT
      *
     C                   WHEN      HPSINST = POrdI35 AND HPSinst <> *Blanks
     C                   EVAL      OkOi35 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      RetCodeIn = 'Error'
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0237'
      *
     C                   WHEN      HPSINST = POrdI11 AND HPsinst <> *blanks
     C                   EVAL      OkOi11 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      RetCodeIn = 'Error'
     C                   EVAL      FldNamXAr(Idx) = 'POrdI11'
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0237'
      *
     C                   OTHER
      *
     C                   IF        POrdI35 <> *Blanks
      *
     C                   SELECT
     C                   WHEN      HPTocus1 <> *blanks
     C                   EVAL      PAcct = HPTocus1
     C                   WHEN      POrdCu1 <> *blanks
     C                   EVAL      PAcct = POrdCu1
     C                   ENDSL
      *
     C                   EXSR      ValAcct
     C                   EVAL      Ptype = *Blanks
      *
     C                   SELECT
     C                   WHEN      Hpccttyp = 'BI' OR HPccttyp = 'BO' AND
     C                             WValid = 'Y'
     C                   SELECT
     C                   WHEN      %Subst(POrdI35:1:2) = '//'
     C                   CALLB     'FTVBCCC01'
     C                   PARM      'DETAIL'      BicRetCode       10
     C                   PARM      POrdI35       ClrOrAcc         35
     C                   PARM      POrdI11       BicCSname        11
     C                   Parm                    DDSName                        CSW200
      *
     C                   SELECT
     C                   WHEN      BicRetCode = '*INVALIDCC'
     C                   EVAL      OKoi35 = 'N'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0238'
     C                   EVAL      FldNamXAr(Idx) =   DDSName
      *
     C                   WHEN      BicRetCode = '*11ERROR '
     C                   EVAL      Okoi11 = 'N'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0317'
     C                   EVAL      FldNamXAr(Idx) =   'POrdi11'
      *
     C                   WHEN      BicRetCode = '*BLANKERR'
     C                   EVAL      Okoi35 = 'N'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0366'
     C**********         EVAL      FldNamXAr(Idx) =   'POrdi11'                             MD034726
     C                   EVAL      FldNamXAr(Idx) =   'POrdi35'                             MD034726
      *
     C                   WHEN      BicRetCode = '*DIGITERR'
     C                   EVAL      OKoi35 = 'N'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0119'
     C                   EVAL      FldNamXAr(Idx) =   DDSName
     C                   ENDSL
      *
      *
     C**********:        WHEN      %Subst(POrdI35:1:1) = '/'  AND               178114
     C***********                  %Subst(POrdI35:2:1) <> '/'                   178114
     C                   OTHER                                                  178114
      *
      ** If account identifier then second field must be blank
      *
     C                   IF        PordI11 <> *Blanks
     C                   EVAL      Okoi11 = 'N'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0241'
     C                   EVAL      FldNamXAr(Idx) =   'POrdI11'
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   WHEN      Hpccttyp = 'BO' AND WValid ='N'
      *
     C********           IF        %SUBST(POrdi35:1) = '/'                      178114
     C********           EVAL      Okoi35 = 'N'                                 178114
     C*********          EVAL      Idx            =   Idx+1                     178114
     C********           EVAL      RetCodeIn      =   'Error'                   178114
     C********           EVAL      MsgIdXAr(Idx)  =   'RFV0315'                 178114
     C*******            EVAL      FldNamXAr(Idx) =   DDSName                   178114
     C*********          ELSE                                                   178114
     C                   IF        %SUBST(POrdi35:1:1) <> '/'                   178114
     C                   EVAL      PAcct = POrdi35                              178114
     C                   ENDIF                                                  178114
     C                   IF        %SUBST(POrdi35:1:1) = '/'                    178114
     C                   EVAL      PAcct = %Subst(POrdi35:2)                    178114
     C                   ENDIF                                                  178114
     C                   EXSR      ValAcct
      *
      ** Invalid Account
      *
     C                   IF        Wvalid = 'N'
     C                   EVAL      Okoi35 = 'N'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0240'
     C                   EVAL      FldNamXAr(Idx) =   DDSName
     C                   ELSE
      *
      ** Valid account. If starts with a '/', remove it.
      *
     C                   If        %Subst(POrdi35:1:1) = '/'
     C                   Eval       POrdi35 = %Subst(POrdi35:2)
     C                   Endif
 
      *
      ** Second field must be blank
      *
     C                   IF        POrdi11 <> *Blanks
     C                   EVAL      Okoi11 = 'N'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0241'
     C                   EVAL      FldNamXAr(Idx) =   'POrdI11'
     C                   ELSE
      *
     C                   SELECT
     C                   WHEN      PType = 'IBAN'
     C                   EVAL      POrdItp = 'I'
     C                   WHEN      PType = '*LEDGER'
     C                   EVAL      POrdItp = 'G'
     C                   WHEN      PType = '*NOSTRO'
     C                   EVAL      POrdItp = 'F'
     C                   WHEN      PType = '*RETAIL'
     C                   EVAL      POrdItp = 'R'
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C********           ENDIF                                                  178114
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
      ** If only the second field has been entered
      *
     C                   IF        POrdI11 <> *Blanks AND POrdI35 = *Blanks
      *
     C                   SELECT
     C                   WHEN      HPTocus1 <> *blanks
     C                   EVAL      PAcct = HPTocus1
     C                   WHEN      POrdCu1 <> *blanks
     C                   EVAL      PAcct = POrdCu1
     C                   ENDSL
      *
     C                   EXSR      ValAcct
     C                   EVAL      Ptype = *Blanks
      *
     C                   SELECT
     C                   WHEN      Hpccttyp = 'BO' AND WValid = 'N'
     C                   EVAL      OKoi11 = 'N'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0316'
     C                   EVAL      FldNamXAr(Idx) =   'POrdI11'
      *
     C                   WHEN      Hpccttyp = 'BI' OR HPCcttyp = 'BO' AND
     C                             WValid = 'Y'
     C                   CALLB     'FTVBCCC01'
     C                   PARM      'DETAIL'      BicRetCode       10
     C                   PARM      POrdI35       ClrOrAcc         35
     C                   PARM      POrdI11       BicCSname        11
     C                   Parm                    DDSName                        CSW200
      *
     C                   IF        BicRetCode = '*11ERROR '
     C                   EVAL      Okoi11 = 'N'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0317'
     C                   EVAL      FldNamXAr(Idx) =   'PORdi11'
     C                   ENDIF
      *
     C                   IF        BicRetCode = '*BLANKERR'
     C                   EVAL      Okoi35 = 'N'
     C                   EVAL      Idx            =   Idx+1
     C                   EVAL      RetCodeIn      =   'Error'
     C                   EVAL      MsgIdXAr(Idx)  =   'RFV0366'
     C**********         EVAL      FldNamXAr(Idx) =   'PORdi11'                             MD034726
     C                   EVAL      FldNamXAr(Idx) =   'PORdi35'                             MD034726
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValAcct- Checks for valid account                             *
      *                                                               *
      * Called by: Validate                                           *
      *                                                               *
      * Calls: AOIBANR2, AOACCTV1                                     *
      *                                                               *
      *****************************************************************
      *
     C     ValAcct       BEGSR
      *
     C                   EVAL      PType = *Blanks
     C                   EVAL      wvalid = 'Y'
      *
      ** CFT is switched on
      *
     C                   IF        CFT004 = 'Y'
      *
      ** Validate Account
      *
     C                   CALLB     'AOIBANR2'
     C                   PARM      *Blanks       PRtcd
     C                   PARM                    PAcct            35
     C     Accnt         PARM      Accnt         DSSDY
      *
     C                   IF        PRtcd = *Blanks
     C                   EVAL      PType = 'IBAN'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PType <> 'IBAN'
      *
      ** Validate Account
      *
     C                   CALLB     'AOACCTV1'
     C                   PARM      *Blanks       PRtcd             7            B:Return code
     C                   PARM                    PType             7            I:A/c ID
     C                   PARM                    PAcct            35            I:A/c Currency
     C                   PARM      *Blanks       DSSDY                          I:A/c code
     C                   ENDIF
      *
      ** Invalid Account
      *
     C                   IF        PType <> 'IBAN' and
     C                             PType <> '*NOSTRO'  and
     C                             PType <> '*RETAIL'  and
     C                             PType <> '*LEDGER' or
     C                             PRtcd <> *Blanks
     C                   EVAL      Wvalid = 'N'
     C                   Else
     C                   SELECT
     C                   WHEN      %SUBST(POrdCu1:1:1) = '/' and                            BUG15279
     C                             PORDI35 = *Blanks                                        BUG15279
     C                   If        PTYPE = '*NOSTRO' Or                                     BUG15279
     C                             PTYPE = '*LEDGER'                                        BUG15279
     C                   EVAL      Wvalid = 'N'                                             BUG15279
     C                   EndIf                                                              BUG15279
 
     C                   WHEN      PTYPE = '*NOSTRO'
     C                   EVAL      N@FMT = DSSDY
     C                   Movel     A7Cust        WCust
 
     C                   WHEN      PTYPE = '*RETAIL'
     C                   EVAL      ACCNT = DSSDY
     C                   Eval      Wcust = CNUM
 
     C                   WHEN      PTYPE = '*LEDGER'
     C                   Eval      ACCNT = DSSDY
     C                   Eval      Wcust = CNUM
 
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDSR
      *
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
      *
     C     *INZSR        BEGSR
      *
     C     *Entry        PLIST
      *
      ** INPUTS
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode
      *
      ** Screen fields
      *
     C                   PARM                    HdrRcdIn
      *
     C                   PARM                    DtlRcdIn
      *
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName          10
      *
      ** OK Flags Data Structure - Screen 1 only
      *
     C                   PARM                    OKFlagDS1
     C                   PARM                    OKFlagDS2
     C                   PARM                    OKFlagHS1
     C                   PARM                    OKFlagHS2
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CFT004'      PSARD             6
     C                   PARM                    DSFDY
      *
     C                   EVAL      CFT004 = 'N'
     C                   IF        PRTCD = *Blanks
     C                   EVAL      CFT004 = 'Y'
     C                   ENDIF
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR                                                  *** InzEnd ***
      *
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
