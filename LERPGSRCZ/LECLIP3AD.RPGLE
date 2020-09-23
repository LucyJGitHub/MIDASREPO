     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer loans amend checking 3')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIP3AD - Customer loans - Amend Checking for screen 3     *
      *                                                               *
      *  Function:  This module compares the fields of an             *
      *             amended loan against those currently on file.     *
      *             It checks whether all fields amended are          *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             If can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 MD000091           Date 09May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10391R          Date 17Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 CAP086             Date 08Jun05               *
      *                 225959             Date 23Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP074  *CREATE    Date 10Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions (Recompile)                    *
      *  MD000091 - Event Codes Substitution                          *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10391R - Funding Rate and Funding Spread Rate fields      *
      *              should be shown separately when CLE036 is *ON    *
      *              (Recompile)                                      *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  225959 - Missing CAS00x changes                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
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
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
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
     D LoanScnFm3    E DS                  EXTNAME(LECLI3PD)
      ***  (Current) Loan in Screen Format 3
     D                                     PREFIX(@)
      *
     D NewLoanScn3   E DS                  EXTNAME(LECLI3PD)
      ***  New Loan in Screen Format 3
      *
     D LnCLFilFmt    E DS                  EXTNAME(CLOANCL)
      ***  (Current) Loan CL in File Format
     D                                     PREFIX(CL_)
      *
     D LnCKFilFmt    E DS                  EXTNAME(CLOANCK)
      ***  (Current) Loan CK in File Format
     D                                     PREFIX(CK_)
      *
     D RUNDAT          DS
     D  @MBIN                 13     13
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ***  External DS for general ledger details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  External DS for midas modules details
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ***  External DS for lending ICD details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, SHORT data structure
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
      ***  Index for arrays of of error message ids etc
      *
     D OKLnScr3      E DS                  EXTNAME(LEECLI3PD)
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      ***  Error indicators screen 3
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      *                                                                                     MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
      *
      ***  Initialization.
      *
     C                   EXSR      INIT
      *
      ***  Compare fields with "amended" values or "changed" values.
      *
     C                   EXSR      COMPFLD
      *
      ***  If any errors were found:
      ***  Set Amendments OK Indicator to 'N'
      *
     C     Idx           IFGT      0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
      *
      ***  If any errors were found
      ***  and reset of fields in error required, do this
      *
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      RESETFLD
     C                   ENDIF
      *
      ***  Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      * INIT - Initialization.                                           *
      ********************************************************************
     C     INIT          BEGSR
      *
      ***  Check type of processing
      *
     C                   MOVE      'N'           P_PTPU            1
     C                   MOVE      'N'           P_PTSO            1
     C                   SELECT
     C     LoanType      WHENEQ    'PTPU'
     C                   MOVE      'Y'           P_PTPU
     C     LoanType      WHENEQ    'PTSO'
     C                   MOVE      'Y'           P_PTSO
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * COMPFLD  - Compare certain fields on the current customer     *
      *            loan with those "amended".                         *
      *****************************************************************
     C     COMPFLD       BEGSR
      *
      *-----------------------------------------*
      * Industry                                *
      *-----------------------------------------*
      *
     C     DDLIND        IFNE      @DDLIND
     C     P_PTSO        ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLIND'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0652'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDLIND                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDLIND))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDLIND)                  MD000091
     C                   EVAL      DDLINDok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Originating branch                      *
      *-----------------------------------------*
      *
     C     P_PTSO        IFEQ      'Y'
     C     BKOBRU        OREQ      'N'
     C     BGMBIN        OREQ      'N'
     C     DDORBR        IFNE      @DDORBR
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDORBR'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0653'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDORBR                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDORBR))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDORBR)                  MD000091
     C                   EVAL      DDORBRok        = 'N'
     C                   END
     C                   END
      *
      *-----------------------------------------*
      * Country of risk                         *
      *-----------------------------------------*
      *
     C     P_PTSO        IFEQ      'Y'
     C     DDCRSK        ANDNE     @DDCRSK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCRSK'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0654'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDCRSK                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDCRSK))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDCRSK)                  MD000091
     C                   EVAL      DDCRSKok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Account sequence number                 *
      *-----------------------------------------*
      *
     C     DDACSQ        IFNE      @DDACSQ
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACSQ'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0655'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDACSQ                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDACSQ))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDACSQ)                  MD000091
     C                   EVAL      DDACSQok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Portfolio                               *
      *-----------------------------------------*
      *
     C     DDPTFR        IFNE      @DDPTFR
     C     P_PTPU        IFEQ      'Y'
     C     P_PTSO        OREQ      'Y'
     C     BGN4ST        OREQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPTFR'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0656'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDPTFR                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDPTFR))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDPTFR)                  MD000091
     C                   EVAL      DDPTFRok        = 'N'
     C                   END
     C                   END
      *
      *-----------------------------------------*
      * Booking profit centre                   *
      *-----------------------------------------*
      *
     C     P_PTSO        IFEQ      'Y'
     C     BKPRCU        OREQ      'N'
     C     BKPRCA        OREQ      'N'
     C     DDPRFC        IFNE      @DDPRFC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPRFC'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0657'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDPRFC                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDPRFC))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDPRFC)                  MD000091
     C                   EVAL      DDPRFCok        = 'N'
     C                   END
     C                   END
      *
      *-----------------------------------------*
      * Base ccy                                *
      *-----------------------------------------*
      *
     C                   CALLB     'ZCMPAMTS'
     C                   PARM      DDBCXR        ZCMPAMT1         25
     C                   PARM      @DDBCXR       ZCMPAMT2         25
     C                   PARM      'N'           ZCMPAMTDif        1
 
     C     ZCMPAMTDif    IFEQ      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBCXR'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0658'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDBCXR                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDBCXR))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDBCXR)                  MD000091
     C                   EVAL      DDBCXRok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Base ccy indicator                      *
      *-----------------------------------------*
      *
     C     DDBMIN        IFNE      @DDBMIN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBMIN'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0659'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDBMIN                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDBMIN))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDBMIN)                  MD000091
     C                   EVAL      DDBMINok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Facility ex                             *
      *-----------------------------------------*
      *
     C                   CALLB     'ZCMPAMTS'
     C                   PARM      DDFCXR        ZCMPAMT1         25
     C                   PARM      @DDFCXR       ZCMPAMT2         25
     C                   PARM      'N'           ZCMPAMTDif        1
 
     C     ZCMPAMTDif    IFEQ      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFCXR'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0660'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDFCXR                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDFCXR))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDFCXR)                  MD000091
     C                   EVAL      DDFCXRok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Facility indicator                      *
      *-----------------------------------------*
      *
     C     DDFMIN        IFNE      @DDFMIN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFMIN'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0661'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDFMIN                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDFMIN))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDFMIN)                  MD000091
     C                   EVAL      DDFMINok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Guarantee receiver                      *
      *-----------------------------------------*
      *
     C     DDRECE        IFNE      @DDRECE
     C     BPGIAV        ANDEQ     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRECE'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0662'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDRECE                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDRECE))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDRECE)                  MD000091
     C                   EVAL      DDRECEok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Customer confirmation                   *
      *-----------------------------------------*
      *
     C     DDCOCU        IFNE      @DDCOCU
     C     S01465        ANDEQ     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCOCU'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0663'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDCOCU                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDCOCU))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDCOCU)                  MD000091
     C                   EVAL      DDCOCUok        = 'N'
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETFLD - Reset fields in Error                              *
      *****************************************************************
     C     RESETFLD      BEGSR
      *
      *-----------------------------------------*
      * Industry                                *
      *-----------------------------------------*
      *
     C     DDLINDok      IFEQ      'N'
     C                   MOVEL     @DDLIND       DDLIND
     C                   END
      *
      *-----------------------------------------*
      * Originating branch                      *
      *-----------------------------------------*
      *
     C     DDORBRok      IFEQ      'N'
     C                   MOVEL     @DDORBR       DDORBR
     C                   END
      *
      *-----------------------------------------*
      * Country of risk                         *
      *-----------------------------------------*
      *
     C     DDCRSKok      IFEQ      'N'
     C                   MOVEL     @DDCRSK       DDCRSK
     C                   END
      *
      *-----------------------------------------*
      * Account sequence number                 *
      *-----------------------------------------*
      *
     C     DDACSQok      IFEQ      'N'
     C                   MOVEL     @DDACSQ       DDACSQ
     C                   END
      *
      *-----------------------------------------*
      * Portfolio                               *
      *-----------------------------------------*
      *
     C     DDPTFRok      IFEQ      'N'
     C                   MOVEL     @DDPTFR       DDPTFR
     C                   END
      *
      *-----------------------------------------*
      * Booking profit centre                   *
      *-----------------------------------------*
      *
     C     DDPRFCok      IFEQ      'N'
     C                   MOVEL     @DDPRFC       DDPRFC
     C                   END
      *
      *-----------------------------------------*
      * Base ccy                                *
      *-----------------------------------------*
      *
     C     DDBCXRok      IFEQ      'N'
     C                   MOVEL     @DDBCXR       DDBCXR
     C                   END
      *
      *-----------------------------------------*
      * Base ccy indicator                      *
      *-----------------------------------------*
      *
     C     DDBMINok      IFEQ      'N'
     C                   MOVEL     @DDBMIN       DDBMIN
     C                   END
      *
      *-----------------------------------------*
      * Facility ex                             *
      *-----------------------------------------*
      *
     C     DDFCXRok      IFEQ      'N'
     C                   MOVEL     @DDFCXR       DDFCXR
     C                   END
      *
      *-----------------------------------------*
      * Facility indicator                      *
      *-----------------------------------------*
      *
     C     DDFMINok      IFEQ      'N'
     C                   MOVEL     @DDFMIN       DDFMIN
     C                   END
      *
      *-----------------------------------------*
      * Guarantee receiver                      *
      *-----------------------------------------*
      *
     C     DDRECEok      IFEQ      'N'
     C                   MOVEL     @DDRECE       DDRECE
     C                   END
      *
      *-----------------------------------------*
      * Customer confirmation                   *
      *-----------------------------------------*
      *
     C     DDCOCUok      IFEQ      'N'
     C                   MOVEL     @DDCOCU       DDCOCU
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ***  INPUTS
      *
      ***  Return Code
     C                   PARM                    RetCodeIn
      *
      ***  New Customer loan in Screen Format :
     C                   PARM                    NewLoanScn3
      *
      ***  (Current) Customer loan in Screen Format :
     C                   PARM                    LoanScnFm3
      *
      ***  Current Loan in file format
     C                   PARM                    LnCLFilFmt
     C                   PARM                    LnCKFilFmt
      *
      ***  Calling type
     C                   PARM                    LoanType          4
      *
      ***  OUTPUTS
      *
      ***  Error Indicators
     C                   PARM                    OKLnScr3
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ***  Amendments OK
     C                   PARM                    AmendOk           1
      *
      ***  Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LECLIP3AD'   DBPGM
      *
      ***  Get rundat to access multi-branching flag.
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ***  Access midas module details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ***  Retrieve general ledger details
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '003'         DBASE                          * DBERR 003 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ***  Retrieve Lending ICD
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDCLNDPD'    DBFILE                         *************
     C                   MOVEL     '004'         DBASE                          * DBERR 004 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ***  Determine if BLI Lending Enhancements feature is installed
      *
     C                   MOVEL     'N'           S01465            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01465'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           S01465
     C                   ELSE
     C     @RTCD         IFNE      '*NRF    '
     C     *LOCK         IN        LDA
     C                   MOVEL     'S01465'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   MOVEL     '005'         DBASE                          * DBERR 005 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C                   END
      *
      ***  Determine if CAS001 is installed
      *
     C                   MOVEL     'N'           CAS001            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAS001'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS001
     C                   ELSE
     C     @RTCD         IFNE      '*NRF    '
     C     *LOCK         IN        LDA
     C                   MOVEL     'CAS001'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   MOVEL     '006'         DBASE                          * DBERR 006 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
