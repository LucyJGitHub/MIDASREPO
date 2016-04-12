     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans amend checking 2')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIP2AD - Customer loans - Amend Checking for screen 2     *
      *                                                               *
      *  Function:  This module compares the fields of an             *
      *             amended loan against those currently on file.     *
      *             It checks whether all fields amended are          *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             If can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE141             Date 08Feb16               *
      *  Prev Amend No. MD025521           Date 19Aug14               *
      *                 MD000091           Date 09May13               *
      *                 AR804863           Date 10Dec12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247953             Date 25May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244655             Date 21Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 CAP074  *CREATE    Date 10Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions (Recompile)                    *
      *  MD025521 - Recompile due to changes on LECLI2PD.             *
      *  MD000091 - Event Codes Substitution                          *
      *  AR804863 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Pass      *
      *             reject button to correctly revert back amended    *
      *             details. (Child: AR804864)                        *
      *           - Applied for AR910559 (Child: AR910560)            *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247953 - Allow validation of spread indicator to be 'A' when *
      *           it is blank before amendment.                       *
      *  244655 - Error given on spread rate when inputting repayment *
      *           date                                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
      *
     D LoanScnFm2    E DS                  EXTNAME(LECLI2PD)
      ***  (Current) Loan in Screen Format 2
     D                                     PREFIX(@)
      *
     D NewLoanScn2   E DS                  EXTNAME(LECLI2PD)
      ***  New Loan in Screen Format 2
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
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, SHORT data structure
      *
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
      ***  Index for arrays of of error message ids etc
      *
     D OKLnScr2      E DS                  EXTNAME(LEECLI2PD)
      ***  Error indicators screen 2
      *                                                                                     MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      *
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
      *
      ***  Initialization.
      *
     C                   EXSR      INIT
      *
      ***  Compare fields with "amended" values or "changed" values.
      *
     C     @ACTRV        IFNE      'Y'                                                      AR804863
     C                   EXSR      COMPFLD
     C                   ENDIF                                                              AR804863
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
      * Base rate code                          *
      *-----------------------------------------*
      *
     C     DDBRTT        IFNE      @DDBRTT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRTT'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0633'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDBRTT                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDBRTT))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDBRTT)                  MD000091
     C                   EVAL      DDBRTTok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Change indicator                        *
      *-----------------------------------------*
      *
     C     DDCHIN        IFNE      @DDCHIN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCHIN'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0634'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDCHIN                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDCHIN))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDCHIN)                  MD000091
     C                   EVAL      DDCHINok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Rate/spread                             *
      *-----------------------------------------*
      *
      * If screen value is blank, default to 0                                                244655
      *                                                                                       244655
     C     DDRTSP        IFEQ      *BLANKS                                                    244655
     C                   MOVEL     '0'           DDRTSP                                       244655
     C                   ENDIF                                                                244655
      *                                                                                       244655
     C     @DDRTSP       IFEQ      *BLANKS                                                    244655
     C                   MOVEL     '0'           @DDRTSP                                      244655
     C                   ENDIF                                                                244655
      *                                                                                       244655
     C                   CALLB     'ZCMPAMTS'
     C                   PARM      DDRTSP        ZCMPAMT1         25
     C                   PARM      @DDRTSP       ZCMPAMT2         25
     C                   PARM      'N'           ZCMPAMTDif        1

     C     ZCMPAMTDif    IFEQ      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRTSP'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0635'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDRTSP                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDRTSP))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDRTSP)                  MD000091
     C                   EVAL      DDRTSPok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Spread indicator                        *
      *-----------------------------------------*
      *
     C     @DDSPIN       IFNE      *BLANK                                                     247953
     C     DDSPIN        IFNE      @DDSPIN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSPIN'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0636'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDSPIN                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDSPIN))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDSPIN)                  MD000091
     C                   EVAL      DDSPINok        = 'N'
     C                   END
     C                   ELSE                                                                 247953
     C     @DDRTSP       IFNE      *BLANKS                                                    247953
     C     DDSPIN        ANDNE     'A'                                                        247953
     C     DDSPIN        ANDNE     *BLANK                                                     247953
     C                   ADD       1             Idx                                          247953
     C                   EVAL      FldNameArr(Idx) = 'DDSPIN'                                 247953
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0636'                                247953
     C**********         EVAL      MsgDtaArr(Idx)  = @DDSPIN                         247953 MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDSPIN))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDSPIN)                  MD000091
     C                   EVAL      DDSPINok        = 'N'                                      247953
     C                   ENDIF                                                                247953
     C                   ENDIF                                                                247953
      *
      *-----------------------------------------*
      * Calculation                             *
      *-----------------------------------------*
      *
     C     DDCALC        IFNE      @DDCALC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCALC'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0637'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDCALC                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDCALC))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDCALC)                  MD000091
     C                   EVAL      DDCALCok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Int. paid/recd to date                  *
      *-----------------------------------------*
      *
     C                   CALLB     'ZCMPAMTS'
     C                   PARM      DDIPRD        ZCMPAMT1         25
     C                   PARM      @DDIPRD       ZCMPAMT2         25
     C                   PARM      'N'           ZCMPAMTDif        1

     C     ZCMPAMTDif    IFEQ      'Y'
     C     CL_PTYP       ANDNE     80                                                        BUG3721
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDIPRD'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0638'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDIPRD                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDIPRD))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDIPRD)                  MD000091
     C                   EVAL      DDIPRDok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Withholding tax indicator               *
      *-----------------------------------------*
      *
     C     DDWTIN        IFNE      @DDWTIN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDWTIN'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0639'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDWTIN                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDWTIN))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDWTIN)                  MD000091
     C                   EVAL      DDWTINok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Interest captilisation ind.             *
      *-----------------------------------------*
      *
     C     DDINTC        IFNE      @DDINTC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINTC'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0640'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDINTC                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDINTC))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDINTC)                  MD000091
     C                   EVAL      DDINTCok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Round Down Interest Ind.                *
      *-----------------------------------------*
      *
     C     DDRDFC        IFNE      @DDRDFC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRDFC'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0641'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDRDFC                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDRDFC))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDRDFC)                  MD000091
     C                   EVAL      DDRDFCok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Additional Day Indicator                *
      *-----------------------------------------*
      *
     C     DDADDI        IFNE      @DDADDI
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDADDI'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0642'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDADDI                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDADDI))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDADDI)                  MD000091
     C                   EVAL      DDADDIok        = 'N'
     C                   END
                                                                                             BUG3721
      ** Add on Interest                                                                     BUG3721
                                                                                             BUG3721
     C     DDADIF        IFNE      @DDADIF                                                   BUG3721
     C     WPRCS2        ANDEQ     'Y'                                                       BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   EVAL      FldNameArr(Idx) = 'DDADIF'                                BUG3721
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0690'                               BUG3721
     C**********         EVAL      MsgDtaArr(Idx)  = @DDADIF                        BUG3721 MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDADIF))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDADIF)                  MD000091
     C                   EVAL      DDADIFok        = 'N'                                     BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
      ** Add on Charges                                                                      BUG3721
                                                                                             BUG3721
     C     DDADCF        IFNE      @DDADCF                                                   BUG3721
     C     WPRCS2        ANDEQ     'Y'                                                       BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   EVAL      FldNameArr(Idx) = 'DDADCF'                                BUG3721
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0691'                               BUG3721
     C**********         EVAL      MsgDtaArr(Idx)  = @DDADCF                        BUG3721 MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDADCF))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDADCF)                  MD000091
     C                   EVAL      DDADCFok        = 'N'                                     BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
      ** Include Charges in Interest                                                         BUG3721
                                                                                             BUG3721
     C     DDICIF        IFNE      @DDICIF                                                   BUG3721
     C     WPRCS2        ANDEQ     'Y'                                                       BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   EVAL      FldNameArr(Idx) = 'DDICIF'                                BUG3721
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0692'                               BUG3721
     C**********         EVAL      MsgDtaArr(Idx)  = @DDICIF                        BUG3721 MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDICIF))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDICIF)                  MD000091
     C                   EVAL      DDICIFok        = 'N'                                     BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
      ** Charge Amount                                                                       BUG3721
                                                                                             BUG3721
     C                   CALLB     'ZCMPAMTS'                                                BUG3721
     C                   PARM      DDCHGA        ZCMPAMT1                                    BUG3721
     C                   PARM      @DDCHGA       ZCMPAMT2                                    BUG3721
     C                   PARM      'N'           ZCMPAMTDif                                  BUG3721
                                                                                             BUG3721
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG3721
     C     WPRCS2        ANDEQ     'Y'                                                       BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   EVAL      FldNameArr(Idx) = 'DDCHGA'                                BUG3721
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0693'                               BUG3721
     C**********         EVAL      MsgDtaArr(Idx)  = @DDCHGA                        BUG3721 MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDCHGA))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDCHGA)                  MD000091
     C                   EVAL      DDCHGAok        = 'N'                                     BUG3721
     C                   ENDIF                                                               BUG3721
      *
      *-----------------------------------------*
      * Repayment type                          *
      *-----------------------------------------*
      *
     C     DDREPT        IFNE      @DDREPT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDREPT'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0643'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDREPT                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDREPT))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDREPT)                  MD000091
     C                   EVAL      DDREPTok        = 'N'
     C                   END
                                                                                             BUG3721
      ** Loan currency repayment amount                                                      BUG3721
                                                                                             BUG3721
     C                   CALLB     'ZCMPAMTS'                                                BUG3721
     C                   PARM      DDRAMT        ZCMPAMT1                                    BUG3721
     C                   PARM      @DDRAMT       ZCMPAMT2                                    BUG3721
     C                   PARM      'N'           ZCMPAMTDif                                  BUG3721
                                                                                             BUG3721
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG3721
     C     WPRCS2        ANDEQ     'Y'                                                       BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   EVAL      FldNameArr(Idx) = 'DDRAMT'                                BUG3721
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0694'                               BUG3721
     C**********         EVAL      MsgDtaArr(Idx)  = @DDRAMT                        BUG3721 MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDRAMT))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDRAMT)                  MD000091
     C                   EVAL      DDRAMTok        = 'N'                                     BUG3721
     C                   ENDIF                                                               BUG3721
      *
      *-----------------------------------------*
      * Facility Ccy Repayment Amt.             *
      *-----------------------------------------*
      *
     C     DDFCRA        IFNE      @DDFCRA
     C     CLE006        ANDNE     'Y'
     C     CLE007        ANDNE     'Y'
     C     CLE028        ANDNE     'Y'                                                       BUG3721
                                                                                             BUG3721
     C     DDFCRA        ORNE      @DDFCRA                                                   BUG3721
     C     CLE006        ANDNE     'Y'                                                       BUG3721
     C     CLE007        ANDNE     'Y'                                                       BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C     WPRCS2        ANDEQ     'Y'                                                       BUG3721
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFCRA'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0644'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDFCRA                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDFCRA))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDFCRA)                  MD000091
     C                   EVAL      DDFCRAok        = 'N'
     C                   END
                                                                                             BUG3721
      ** Repayment Date                                                                      BUG3721
                                                                                             BUG3721
     C     DDNRPD        IFNE      @DDNRPD                                                   BUG3721
     C     WPRCS2        ANDEQ     'Y'                                                       BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   EVAL      FldNameArr(Idx) = 'DDNRPD'                                BUG3721
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0695'                               BUG3721
     C**********         EVAL      MsgDtaArr(Idx)  = @DDNRPD                        BUG3721 MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDNRPD))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDNRPD)                  MD000091
     C                   EVAL      DDNRPDok        = 'N'                                     BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
      ** Repayment Frequency                                                                 BUG3721
                                                                                             BUG3721
     C     DDRFRQ        IFNE      @DDRFRQ                                                   BUG3721
     C     WPRCS2        ANDEQ     'Y'                                                       BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   EVAL      FldNameArr(Idx) = 'DDRFRQ'                                BUG3721
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0696'                               BUG3721
     C**********         EVAL      MsgDtaArr(Idx)  = @DDRFRQ                        BUG3721 MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDRFRQ))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDRFRQ)                  MD000091
     C                   EVAL      DDRFRQok        = 'N'                                     BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
      ** Repayment Day                                                                       BUG3721
                                                                                             BUG3721
     C     DDRDYN        IFNE      @DDRDYN                                                   BUG3721
     C     WPRCS2        ANDEQ     'Y'                                                       BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   EVAL      FldNameArr(Idx) = 'DDRDYN'                                BUG3721
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0697'                               BUG3721
     C**********         EVAL      MsgDtaArr(Idx)  = @DDRDYN                        BUG3721 MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDRDYN))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDRDYN)                  MD000091
     C                   EVAL      DDRDYNok        = 'N'                                     BUG3721
     C                   ENDIF                                                               BUG3721
      *
      *-----------------------------------------*
      * Bill/Telex                              *
      *-----------------------------------------*
      *
     C     DDBTIN        IFNE      @DDBTIN
     C     P_PTSO        ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBTIN'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0650'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDBTIN                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDBTIN))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDBTIN)                  MD000091
     C                   EVAL      DDBTINok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Billing days                            *
      *-----------------------------------------*
      *
     C     DDBLDY        IFNE      @DDBLDY
     C     P_PTSO        ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBLDY'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0651'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDBLDY                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDBLDY))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDBLDY)                  MD000091
     C                   EVAL      DDBLDYok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Payment Due Day Indicator               *
      *-----------------------------------------*
      *
     C     DDPDDI        IFNE      @DDPDDI
     C     CLE5A7        ANDEQ     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPDDI'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0645'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDPDDI                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDPDDI))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDPDDI)                  MD000091
     C                   EVAL      DDPDDIok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Grace Days for Interest                 *
      *-----------------------------------------*
      *
     C     DDGDIN        IFNE      @DDGDIN
     C     CLE5A7        ANDEQ     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDGDIN'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0646'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDGDIN                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDGDIN))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDGDIN)                  MD000091
     C                   EVAL      DDGDINok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Grace Days for Principal                *
      *-----------------------------------------*
      *
     C     DDGDPR        IFNE      @DDGDPR
     C     CLE5A7        ANDEQ     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDGDPR'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0647'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDGDPR                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDGDPR))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDGDPR)                  MD000091
     C                   EVAL      DDGDPRok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Payment Taken Day Indicator             *
      *-----------------------------------------*
      *
     C     DDPTDI        IFNE      @DDPTDI
     C     CLE5A7        ANDEQ     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPTDI'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0648'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDPTDI                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDPTDI))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDPTDI)                  MD000091
     C                   EVAL      DDPTDIok        = 'N'
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
      ***  Reset fields in error to 'current' values
      *    =========================================
      *
      *-----------------------------------------*
      * Base rate code                          *
      *-----------------------------------------*
      *
     C     DDBRTTok      IFEQ      'N'
     C                   MOVEL     @DDBRTT       DDBRTT
     C                   END
      *
      *-----------------------------------------*
      * Change indicator                        *
      *-----------------------------------------*
      *
     C     DDCHINok      IFEQ      'N'
     C                   MOVEL     @DDCHIN       DDCHIN
     C                   END
      *
      *-----------------------------------------*
      * Rate/spread                             *
      *-----------------------------------------*
      *
     C     DDRTSPok      IFEQ      'N'
     C                   MOVEL     @DDRTSP       DDRTSP
     C                   END
      *
      *-----------------------------------------*
      * Spread indicator                        *
      *-----------------------------------------*
      *
     C     DDSPINok      IFEQ      'N'
     C                   MOVEL     @DDSPIN       DDSPIN
     C                   END
      *
      *-----------------------------------------*
      * Calculation                             *
      *-----------------------------------------*
      *
     C     DDCALCok      IFEQ      'N'
     C                   MOVEL     @DDCALC       DDCALC
     C                   END
      *
      *-----------------------------------------*
      * Int. paid/recd to date                  *
      *-----------------------------------------*
      *
     C     DDIPRDok      IFEQ      'N'
     C     CL_PTYP       ANDNE     80                                                        BUG3721
     C                   MOVEL     @DDIPRD       DDIPRD
     C                   END
      *
      *-----------------------------------------*
      * Withholding tax indicator               *
      *-----------------------------------------*
      *
     C     DDWTINok      IFEQ      'N'
     C                   MOVEL     @DDWTIN       DDWTIN
     C                   END
      *
      *-----------------------------------------*
      * Interest captilisation ind.             *
      *-----------------------------------------*
      *
     C     DDINTCok      IFEQ      'N'
     C                   MOVEL     @DDINTC       DDINTC
     C                   END
      *
      *-----------------------------------------*
      * Round Down Interest Ind.                *
      *-----------------------------------------*
      *
     C     DDRDFCok      IFEQ      'N'
     C                   MOVEL     @DDRDFC       DDRDFC
     C                   END
      *
      *-----------------------------------------*
      * Additional Day Indicator                *
      *-----------------------------------------*
      *
     C     DDADDIok      IFEQ      'N'
     C                   MOVEL     @DDADDI       DDADDI
     C                   END
                                                                                             BUG3721
      ** Add on Interest                                                                     BUG3721
                                                                                             BUG3721
     C     DDADIFok      IFEQ      'N'                                                       BUG3721
     C                   MOVEL     @DDADIF       DDADIF                                      BUG3721
     C                   END                                                                 BUG3721
                                                                                             BUG3721
      ** Add on Charges                                                                      BUG3721
                                                                                             BUG3721
     C     DDADCFok      IFEQ      'N'                                                       BUG3721
     C                   MOVEL     @DDADCF       DDADCF                                      BUG3721
     C                   END                                                                 BUG3721
                                                                                             BUG3721
      ** Include Charges in Interest                                                         BUG3721
                                                                                             BUG3721
     C     DDICIFok      IFEQ      'N'                                                       BUG3721
     C                   MOVEL     @DDICIF       DDICIF                                      BUG3721
     C                   END                                                                 BUG3721
                                                                                             BUG3721
      ** Charge Amount                                                                       BUG3721
                                                                                             BUG3721
     C     DDCHGAok      IFEQ      'N'                                                       BUG3721
     C                   MOVEL     @DDCHGA       DDCHGA                                      BUG3721
     C                   END                                                                 BUG3721
      *
      *-----------------------------------------*
      * Repayment type                          *
      *-----------------------------------------*
      *
     C     DDREPTok      IFEQ      'N'
     C                   MOVEL     @DDREPT       DDREPT
     C                   END
                                                                                             BUG3721
      ** Loan currency repayment amount                                                      BUG3721
                                                                                             BUG3721
     C     DDRAMTok      IFEQ      'N'                                                       BUG3721
     C                   MOVEL     @DDRAMT       DDRAMT                                      BUG3721
     C                   END                                                                 BUG3721
      *
      *-----------------------------------------*
      * Facility Ccy Repayment Amt.             *
      *-----------------------------------------*
      *
     C     DDFCRAok      IFEQ      'N'
     C                   MOVEL     @DDFCRA       DDFCRA
     C                   END
                                                                                             BUG3721
      ** Repayment Date                                                                      BUG3721
                                                                                             BUG3721
     C     DDNRPDok      IFEQ      'N'                                                       BUG3721
     C                   MOVEL     @DDNRPD       DDNRPD                                      BUG3721
     C                   END                                                                 BUG3721
                                                                                             BUG3721
      ** Repayment Frequency                                                                 BUG3721
                                                                                             BUG3721
     C     DDRFRQok      IFEQ      'N'                                                       BUG3721
     C                   MOVEL     @DDRFRQ       DDRFRQ                                      BUG3721
     C                   END                                                                 BUG3721
                                                                                             BUG3721
      ** Repayment Day                                                                       BUG3721
                                                                                             BUG3721
     C     DDRDYNok      IFEQ      'N'                                                       BUG3721
     C                   MOVEL     @DDRDYN       DDRDYN                                      BUG3721
     C                   END                                                                 BUG3721
      *
      *-----------------------------------------*
      * Bill/Telex                              *
      *-----------------------------------------*
      *
     C     DDBTINok      IFEQ      'N'
     C                   MOVEL     @DDBTIN       DDBTIN
     C                   END
      *
      *-----------------------------------------*
      * Billing days                            *
      *-----------------------------------------*
      *
     C     DDBLDYok      IFEQ      'N'
     C                   MOVEL     @DDBLDY       DDBLDY
     C                   END
      *
      *-----------------------------------------*
      * Payment Due Day Indicator               *
      *-----------------------------------------*
      *
     C     DDPDDIok      IFEQ      'N'
     C                   MOVEL     @DDPDDI       DDPDDI
     C                   END
      *
      *-----------------------------------------*
      * Grace Days for Interest                 *
      *-----------------------------------------*
      *
     C     DDGDINok      IFEQ      'N'
     C                   MOVEL     @DDGDIN       DDGDIN
     C                   END
      *
      *-----------------------------------------*
      * Grace Days for Principal                *
      *-----------------------------------------*
      *
     C     DDGDPRok      IFEQ      'N'
     C                   MOVEL     @DDGDPR       DDGDPR
     C                   END
      *
      *-----------------------------------------*
      * Payment Taken Day Indicator             *
      *-----------------------------------------*
      *
     C     DDPTDIok      IFEQ      'N'
     C                   MOVEL     @DDPTDI       DDPTDI
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
     C                   PARM                    NewLoanScn2
      *
      ***  (Current) Customer loan in Screen Format :
     C                   PARM                    LoanScnFm2
      *
      ***  Current Loan in file format
     C                   PARM                    LnCLFilFmt
     C                   PARM                    LnCKFilFmt
      *
      ***  Calling type
     C                   PARM                    LoanType          4
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028            1                         BUG3721
                                                                                             BUG3721
      ** Work fields                                                                         BUG3721
     C                   PARM                    WPRCS2            1                         BUG3721
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV            1                        AR804863
      *
      ***  OUTPUTS
      *
      ***  Error Indicators
     C                   PARM                    OKLnScr2
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
     C                   MOVEL     'LECLIP2AD'   DBPGM
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
      ***  Determine if Customer Lending Enhancement - Others
      ***  feature is installed
      *
     C                   MOVEL     'N'           CLE007            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE007'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CLE007
     C                   END
      *
      ***  Determine if Customer Lending Enhancements - Past Due Account
      ***  feature is installed
      *
     C                   MOVEL     'N'           CLE006            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE006'      @SARD
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CLE006
     C                   END
      *
      ***  Determine if Customer Lending Enhancement - Others
      ***  feature is installed
      *
     C                   MOVEL     'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CLE005
     C                   END
      *
     C                   MOVEL     'N'           CLE5A7            1
     C     CLE005        IFEQ      'Y'
     C     CLE007        ANDEQ     'Y'
     C                   MOVEL     'Y'           CLE5A7
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
(c) Misys International Banking Systems Ltd. 2002
