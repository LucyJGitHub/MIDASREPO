     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility details retrieve a record')          *
      *****************************************************************
      *                                                               *
      *  Midas - Module name   ILE Module                             *
      *                                                               *
      *  LEFCIPR   - LE Facilities details retrieve a record           *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD039655           Date 11Feb20               *
      *  Prev Amend No. MD044880           Date 15Jan18               *
      *                 MD046248           Date 27Oct17               *
      *                 LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE147             Date 17Oct11               *
      *                 CSF011             Date 12Sep11               *
      *                 CER049             Date 06Dec10               *
      *                 AR787620           Date 10Jun11               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23786           Date 21Apr09               *
      *                 BUG22074           Date 12Jan09               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG13297A          Date 26Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239211             Date 31Aug06               *
      *                 CSD027A            Date 08May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10540           Date 14Feb06               *
      *                 BUG10093           Date 01Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 CER001             Date 25Apr05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 08Jun05               *
      *                 CLE041             Date 15Oct04               *
      *                 BUG3723 (CLE028)   Date 19Jul04               *
      *                 CAP084  *CREATE    Date 20Nov02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039655 - Facility cannot be rejected.                      *
      *             Pattern fix from MD-29208 and MD-34908.           *
      *           - Applied for MD052591.                             *
      *  MD044880 - BOE Switched On Testing and Fixing                *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BoE Upgrade to MidasPlus                            *
      *           Core hooks added:LEFCIPRD01,LEFCIPRC02,LEFCIPRC03   *
      *                            LEFCIPRC06                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *          - CCR006: SYNMAN Auto-Generated Events Browser       *
      *  CLE147 - Aggregate Facility                                  *
      *  CSF011 - Customer Name on Inputs                             *
      *  CER049 - Stamp Tax                                           *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00356                                 *
      *             WNCPYSRC,LEH00318                                 *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23786 - Incorrect values in Previous and Penultimate Date *
      *             fields when Facility amended in WIP (Recompile)   *
      *  BUG22074 - Action code is invalid. (Recompile)               *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  BUG13297A - Add DDPATH field.                                *
      *  239211 - Recompile over changes in LEFCSPPD.                 *
      *  CSD027A - Conversion Of Customer Number to Alpha (recompile) *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10540 - Add new assignment indicator. (Recompile)         *
      *  BUG10093- Mapping error in FCIP                              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CLE106 - Syndications Manager                                *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  BUG3723 - Recompile due to changes to LEFCSPPD.              *
      *  CAP084 - Midas Plus API development                          *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** SCREEN FORMATS
      **--------------------------------------------------------------------------------------------

     D FacmScnFmt    E DS                  EXTNAME(LEFCPPPD)
      ***  New Fclty in Screen Format - Screen 1
      *
     D FacnScnFmt    E DS                  EXTNAME(LEFCSPPD)
      ***  New Fclty in Screen Format - Screen 2
      *
     D RegData       E DS                  EXTNAME(LEFCRXPD)                                  CER001
      *                                                                                       CER001
      ** Regional data in file format                                                         CER001
      *                                                                                       CER001
     D DsUpScnFmt    E DS                  EXTNAME(LEFCXPPD)                                  CLE106
      *                                                                                       CLE106
      ** New Fclty in Screen Format - Display/Update                                          CLE106
      *                                                                                       CLE106
     D PrtnScnFmt    E DS                  EXTNAME(LEFCZPPD)                                  CLE106
      *                                                                                       CLE106
      **  Participant in Screen Format                                                        CLE106
      *                                                                                       CLE106
     D FCIPNotes     E DS                  EXTNAME(LEFCNTPD) PREFIX(N_)                     BUG10093
      *                                                                                     BUG10093
      ** Facility Notes Data Layout                                                         BUG10093
      *                                                                                     BUG10093
     D InfData       E DS                  EXTNAME(LELEIFPD) PREFIX(IF_)                    BUG10093
      *                                                                                     BUG10093
      ** Interface Data Format Definition File format                                       BUG10093
      *                                                                                     BUG10093
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)                                BUG10093
      *                                                                                     BUG10093
      ** FRA/IRS settlement instructions in screen format                                   BUG10093
      *                                                                                     BUG10093
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)                                BUG10093
      *                                                                                     BUG10093
      ** Receive settlement instructions in screen format                                   BUG10093
      *                                                                                     BUG10093
     D ExtData       E DS                  EXTNAME(LEFCEXPD)                                BUG10093
      *                                                                                     BUG10093
      ** Facility Input Extra Data Layout                                                   BUG10093
      *                                                                                     BUG10093

      **--------------------------------------------------------------------------------------------
      ** FILE FORMATS
      **--------------------------------------------------------------------------------------------

     D FacmFilFmt    E DS                  EXTNAME(FCLTYFM)
      ***  Current Fclty in File Format FM
     D                                     PREFIX(FM)
     D FacnFilFmt    E DS                  EXTNAME(FCLTYFN)
      ***  Current Fclty in File Format FN
     D                                     PREFIX(FN)
      *                                                                                      LLN022A
     D FCIPExFilFmt  E DS                  ExtName(BYFCLTX0)                                 LLN022A
      ** External DS for BYFCLTX0                                                            LLN022A
      *                                                                                      LLN022A
     D FCLXExFilFmt  E DS                  EXTNAME(LEFCX2PD)                                  CER001
      *                                                                                       CER001
      ** ER Facilities details LUX Extension File                                             CER001
      *                                                                                       CER001
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER001
      *                                                                                       CER001
      ** First DS for Access programs - short data structure                                  CER001
      *                                                                                       CER001
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSF011
      * Second DS for Access programs - long data structure                                   CSF011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER001
      *                                                                                       CER001
      ** Switchable features description                                                      CER001
      *                                                                                       CER001
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
      ** External DS for Customer Details                                                     CSF011

      **--------------------------------------------------------------------------------------------

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
     D CLE106          S              1A                                                      CLE106
     D PRTCD           S              7A                                                      CER001
     D POPTN           S              7A                                                      CER001
     D PSARD           S              6A                                                      CER001
     D ULX004          S              1A                                                      CER001
                                                                                              CER049
     DTranStamp        S             51A                                                      CER049
      ** Stamp Tax Details                                                                    CER049
                                                                                              CSF011
     D PCNum           S             10A                                                      CSF011
     D PKey7           S              7A                                                      CSF011
      ** Parameters for Calling AOCUSTR0                                                      CSF011
                                                                                              CSF011
     DCADetails        S             33A                                                      CLE147
      ** Credit Agreement Details                                                             CLE147

      **--------------------------------------------------------------------------------------------

      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   FacmFilFmt
     C                   CLEAR                   FacnFilFmt
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
     C                   EXSR      LEFCIPRED
     C                   ELSE
     C                   MOVEL     DDCSSN_In     @CSRED
     C                   MOVEL     DDFACT_In     @FARED
     C                   MOVEL     DDFCNO_In     @FCRED
     C                   MOVEL     DDBRCA_In     @BRRED            3
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If facility read
      * and no error message returned
      *
     C     @CSRED        IFNE      *BLANK
     C     @ERRMS        ANDEQ     *BLANK
      *
      * Retrieve facility details (all key fields required for call to rtv module)
      *
     C                   MOVEL     @CSRED        DDCSSN
     C                   MOVEL     @FARED        DDFACT
     C                   MOVEL     @FCRED        DDFCNO
     C                   MOVEL     @BRRED        DDBRCA
     C                   EXSR      LEFCIPRTV
      *                                                                                      LLN022A
      ** If LLN007 on in system retrieve BOE details.                                        LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   EVAL      p_ActCode = DDACTN                                        LLN022A
     C                   EVAL      p_FrntOfc = FOTRID                                        LLN022A
     C                   EVAL      p_CustNbr = CNUM                                          LLN022A
     C                   EVAL      p_FacType = DDFACT                                        LLN022A
     C                   EVAL      p_FacSeqn = DDFCNO                                        LLN022A
     C                   EVAL      p_Branch  = DDBRCA                                        LLN022A
                                                                                             LLN022A
     C                   CALLB     'LEFCIPRTV1'                                              LLN022A
     C                   PARM                    p_RetCode        10                         LLN022A
     C                   PARM                    p_ActCode         1                         LLN022A
     C                   PARM                    p_FrntOfc        20                         LLN022A
     C                   PARM                    p_CustNbr         6                         LLN022A
     C                   PARM                    p_FacType         3                         LLN022A
     C                   PARM                    p_FacSeqn         2                         LLN022A
     C                   PARM                    p_Branch          3                         LLN022A
     C                   PARM                    FCIPExFilFmt                                LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   IF        ULX004  = 'Y'                                              CER001
     C                   EXSR      LEFCIP2RV                                                  CER001
     C                   ENDIF                                                                CER001
     C     CLE106        IFEQ      'Y'                                                        CLE106
      *                                                                                       CLE106
      ** Facility UTN was extracted from the FM file format data structure                    CLE106
      *                                                                                       CLE106
     C                   EVAL      DDFUTN = FMPCRF                                            CLE106
     C                   ENDIF                                                                CLE106
      *
      * Convert to screeen format
      *
     C     Idx           IFEQ      0
     C                   EXSR      LEFCIPCVT
      *                                                                                      LLN022A
      ** If LLN007 installed convert BOE fields.                                             LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   CALLB     'LEFCIPCVT1'                                              LLN022A
     C                   PARM                    p_RetCode        10                         LLN022A
     C                   PARM                    p_CustNbr         6                         LLN022A
     C                   PARM                    p_FacType         3                         LLN022A
     C                   PARM                    p_FacSeqn         2                         LLN022A
     C                   PARM                    FCIPExFilFmt                                LLN022A
     C                   PARM                    ExtData                                     LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   IF        ULX004  = 'Y'  And                                         CER001
     C                             DDACTN <> 'I'                                              CER001
     C                   EXSR      LEFCIP2CT                                                  CER001
     C                   ELSE                                                                 CER001
     C                   CLEAR                   RegData                                      CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF

     C                   ENDIF

     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDDLNO'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
                                                                                              CSF011
      ** Population of Facility Customer Details                                              CSF011
                                                                                              CSF011
     C                   EXSR      SrPopCust                                                  CSF011

      * Build buffer with required output
     C                   EVAL           Buffer = FACMScnFmt + FACNScnFmt
     C                                           + DsUpScnFmt                                 CLE106
     C                                           + PrtnScnFmt                                 CLE106
     C**********                                 + RegData                           CER001 BUG10093
     C**********                                 + FCIPNotes  + InfData           BUG10093 BUG13297A
     C                                           + FCIPNotes  + DDPATH                     BUG13297A
     C                                           + TranStamp                                  CER049
     C                                           + CADetails                                  CLE147
     C                                           + InfData                                 BUG13297A
     C                                           + InRecSttmt + InPaySttmt                  BUG10093
     C**********                                 + RegData + ExtData               BUG10093 MD044880
     C                                           + ExtData                                  MD044880
     C                                           + @ACTRV                                   MD039655
     C                                           + RegData                                  MD044880

     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      *  SrPopCust - Subroutine to Populate Customer Name Details     *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
      *                                                                                       CSF011
     C     SrPopCust     BEGSR                                                                CSF011
                                                                                              CSF011
      ** Retrieve Customer Details                                                            CSF011
                                                                                              CSF011
     C                   IF        DDCSSN <> *BLANKS AND                                      CSF011
     C                             DDCSSNOK = 'Y'                                             CSF011
     C                   EVAL      PCNum = DDCSSN                                             CSF011
                                                                                              CSF011
     C                   EXSR      SrRtvCust                                                  CSF011
     C                   IF        PRtcd = *BLANKS                                            CSF011
     C                   EVAL      DDCRSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDCRNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDCRTN  = BBCRTN                                          CSF011A
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                             CSF011A
      ** Retrieve Customer Details for Credit Agreement Customer                             CSF011A
                                                                                             CSF011A
     C                   IF        DDCANM <> *BLANKS                                         CSF011A
     C                   EVAL      PCNum = DDCANM                                            CSF011A
                                                                                             CSF011A
     C                   EXSR      SrRtvCust                                                 CSF011A
     C                   IF        PRtcd = *BLANKS                                           CSF011A
     C                   EVAL      DDCCSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDCCNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDCCTN  = BBCRTN                                          CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                       CSF011
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      *  SrRtvCust - Subroutine to Retrieve Customer Details          *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrRtvCust     BEGSR                                                                CSF011
                                                                                              CSF011
      ** Call AOCUSTR0 to get Customer Details                                                CSF011
                                                                                              CSF011
     C                   CALL      'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       PRtcd                                        CSF011
     C                   PARM      '*KEY   '     POptn                                        CSF011
     C                   PARM                    PCNum                                        CSF011
     C                   PARM      *BLANKS       PKey7                                        CSF011
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDCSSN_In        10
     C                   PARM                    DDFACT_In         3
     C                   PARM                    DDFCNO_In         2
     C                   PARM                    DDBRCA_In         3
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
     C                   PARM                    DDPATH          200                       BUG13297A
                                                                                            MD039655
      ** Reject action                                                                      MD039655
                                                                                            MD039655
     C                   PARM                    @ACTRV            1                        MD039655
      *                                                                                      LLN022A
      ** Access SAR details file to determine if LLN007                                      LLN022A
      ** Bank of England Yellow Book Changes is installed.                                   LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN007            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       @RTCD                                       LLN022A
     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
     C                   PARM      'LLN007'      @SARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
      ** Switchable Feature LLN007 is *ON                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *Blanks                                           LLN022A
     C                   EVAL      LLN007 = 'Y'                                              LLN022A
     C                   ENDIF                                                               LLN022A

      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF '
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
      *                                                                                       CLE106
      ** Determine if CLE106 (Lending Enhancements)                                           CLE106
      *                                                                                       CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *BLANKS       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
                                                                                              CLE106
     C     @RTCD         IFEQ      *BLANKS                                                    CLE106
     C                   MOVE      'Y'           CLE106                                       CLE106
     C                   ELSE                                                                 CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   ENDIF                                                                CLE106

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,LEFCIPM01
      *                                                                                      LLN022A
      **  Add GBBYUSRMSG to MsgFArray if BOE installed                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   EVAL      MsgFArray (%LookUp(*Blanks:MsgFArray)) =                  LLN022A
     C                             'GBBYUSRMSG'                                              LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       CER001
      ** Determine if ULX004 is installed                                                     CER001
      *                                                                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRTCD                                        CER001
     C                   PARM      '*VERIFY'     POPTN                                        CER001
     C                   PARM      'ULX004'      PSARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        @RTCD  <> *BLANK                                           CER001
     C                   EVAL      ULX004  = 'N'                                              CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX004  = 'Y'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ENDSR

      **********************************************************************
     C     LEFCIPRED     BEGSR
      *
     C                   CALLB     'LEFCIPRED'
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
      ***  Facility ref pointer
     C                   PARM      DDCSSN_In     DDCSSN           10
      *
      ***  Facility ref pointer
     C                   PARM      DDFACT_In     DDFACT            3
      *
      ***  Facility ref pointer
     C                   PARM      DDFCNO_In     DDFCNO            2
      *
      * Front Office ID
     C                   PARM                    DDFRTN           20
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
      ***  Facility ref pointer
     C                   PARM                    @CSRED           10
      *
      ***  Facility ref pointer
     C                   PARM                    @FARED            3
      *
      ***  Facility ref pointer
     C                   PARM                    @FCRED            2
      *
      ***  Front Office Fclty Read
     C                   PARM                    @FTRED           20
      *

     C                   ENDSR
      *****************************************************************
      /EJECT
      **********************************************************************
     C     LEFCIPRTV     BEGSR

     C                   MOVEL     DDCSSN        CNUM              6


     C                   CALLB     'LEFCIPRTV'

      * INPUTS

      * Return code
     C                   PARM                    ReturnCode

      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C**********         PARM      ' S'          APRESPMODE        1                          CLE041
     C                   PARM      'S'           APRESPMODE        1                          CLE041

      * Action Code
     C                   PARM                    DDACTN            1

      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * Front Office User
     C                   PARM                    FOUSER           16
      * (Midas) Customer Number
     C     DDCSSN        PARM      CNUM          CSSN             10
      * (Midas) Facility Type
     C                   PARM                    DDFACT            3
      * (Midas) Facility number
     C                   PARM                    DDFCNO            2
      * (Midas) Branch
     C                   PARM                    DDBRCA            3
                                                                                            MD039655
      ** Reject action                                                                      MD039655
                                                                                            MD039655
     C                   PARM                    @ACTRV                                     MD039655
     C/COPY WNCPYSRC,LEH00356

      * OUTPUTS

      * (Current) Facility FM in file format
     C                   PARM                    FacmFilFmt
      * (Current) Facility FN in file format
     C                   PARM                    FacnFilFmt

      * OK - Action code
     C                   PARM                    DDActnOK          1

      * OK - Customer number
     C                   PARM                    DDCSSNOK          1
      * OK - Facility type
     C                   PARM                    DDFACTOK          1
      * OK - Facility number
     C                   PARM                    DDFCNOOK          1
     C/COPY WNCPYSRC,LEH00318
      * Reactivation indicator
     C                   PARM                    WREAC             1
      * New expiry date
     C                   PARM                    WNDTEX            5

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      * Array index (3P0) from/to caller
     C                   PARM                    Idx

     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************                       CER001
     C     LEFCIP2RV     BEGSR                                                                CER001
     C                   CALLB     'LEFCIP2RV'                                                CER001
     C                   PARM                    ReturnCode                                   CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    FOTRID                                       CER001
     C                   PARM                    CNUM                                         CER001
     C                   PARM                    DDFACT                                       CER001
     C                   PARM                    DDFCNO                                       CER001
     C                   PARM                    DDBRCA                                       CER001
     C                   PARM                    FCLXExFilFmt                                 CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************
     C     LEFCIPCVT     BEGSR

     C                   CALLB     'LEFCIPCVT'

      * Match parameter list.... obviously

      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * Facility FM in file formats
     C                   PARM                    FacmFilFmt
      * Facility FN in file formats
     C                   PARM                    FacnFilFmt
      *

      * Output parameters
      *
      * Facility in screen format
     C                   PARM                    FacmScnFmt
     C                   PARM                    FacnScnFmt

      ** AMEND CHECKING
     C                   RESET                   ReturnCode

     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
     C     LEFCIP2CT     BEGSR                                                                CER001
     C                   CALLB     'LEFCIP2CT'                                                CER001
     C                   PARM                    ReturnCode                                   CER001
     C                   PARM                    CNUM                                         CER001
     C                   PARM                    DDFACT                                       CER001
     C                   PARM                    DDFCNO                                       CER001
     C                   PARM                    FCLXExFilFmt                                 CER001
     C                   PARM                    RegData                                      CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
**  CPY@
(c) Finastra International Limited 2003
