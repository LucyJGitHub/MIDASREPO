     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Deal Amendments TM Database Update')          *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMDEAMUPT - DEAL AMENDMENTS TM DATABASE UPDATE               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 12Nov99               *
      *                 CDL007             Date 12Oct99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to changes in MMDELDPP               *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *           Recompiled due to changes in MMDELDPP               *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDELDPP               *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
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
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      **  DEAMS FILE - DEAL AMENDMENTS
     D MMDEAM        E DS                  EXTNAME(MMDEAMPP)
     D  @HNVDY                49     56  0
     D  @DEAM1                 1    254
     D  @DEAM2               255    299
     D  @DEAM3               300    496
     D  @DEAM4               497    717
     D  @DEAM5               718    927
     D  @DEAM6               928    930
     D  @DEAM7               932    934
     D  @DEAM8               935    942
     D  @DEAM9              1065   1172                                                       CGL029
 
      **  DEALS FILE - LOANS/DEPOSITS & NAS ISSUED
     D MMDELD        E DS                  EXTNAME(MMDELDPP)
     D MMDELDDORI    E                     EXTFLD(QQDORI)                                     CGL029
     D MMDELDMORI    E                     EXTFLD(QQMORI)                                     CGL029
     D MMDELDDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
     D MMDELDMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
     D MMDELDRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D MMDELDPONS    E                     EXTFLD(QQPONS)                                     CGL029
     D  @HKVDY                50     57  0
 
      **  DEALS FILE - NAS PURCHASED
     D MMDENB        E DS                  EXTNAME(MMDENBPP)
     D MMDENBDORI    E                     EXTFLD(DORIQQ)                                     CGL029
     D MMDENBMORI    E                     EXTFLD(MORIQQ)                                     CGL029
     D MMDENBDOPI    E                     EXTFLD(DOPIQQ)                                     CGL029
     D MMDENBMOPI    E                     EXTFLD(MOPIQQ)                                     CGL029
     D MMDENBRONS    E                     EXTFLD(RONSQQ)                                     CGL029
     D MMDENBPONS    E                     EXTFLD(PONSQQ)                                     CGL029
     D  @HLVDY                50     57  0
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR LOANS & DEPOSITS
     D MMSTDL        E DS                  EXTNAME(MMSTDLPP)
     D MMSTDLDORI    E                     EXTFLD(QQDORI)                                     CGL029
     D MMSTDLMORI    E                     EXTFLD(QQMORI)                                     CGL029
     D MMSTDLDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
     D MMSTDLMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
     D MMSTDLRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D MMSTDLPONS    E                     EXTFLD(QQPONS)                                     CGL029
     D MMSTDLINSA    E                     EXTFLD(QQINSA)                                     CGL029
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR NA BOUGHT FORMAT
     D MMSTDB        E DS                  EXTNAME(MMSTDBPP)
     D MMSTDBDORI    E                     EXTFLD(QQDORI)                                     CGL029
     D MMSTDBMORI    E                     EXTFLD(QQMORI)                                     CGL029
     D MMSTDBDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
     D MMSTDBMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
     D MMSTDBBORI    E                     EXTFLD(QQBORI)                                     CGL029
     D MMSTDBBOPI    E                     EXTFLD(QQBOPI)                                     CGL029
     D MMSTDBRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D MMSTDBPONS    E                     EXTFLD(QQPONS)                                     CGL029
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR NA SOLD FORMAT
     D MMSTDS        E DS                  EXTNAME(MMSTDSPP)
     D MMSTDSDORI    E                     EXTFLD(QQDORI)                                     CGL029
     D MMSTDSMORI    E                     EXTFLD(QQMORI)                                     CGL029
     D MMSTDSBORI    E                     EXTFLD(QQBORI)                                     CGL029
     D MMSTDSBOPI    E                     EXTFLD(QQBOPI)                                     CGL029
     D MMSTDSRORI    E                     EXTFLD(QQRORI)                                     CGL029
     D MMSTDSROPI    E                     EXTFLD(QQROPI)                                     CGL029
     D MMSTDSRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D MMSTDSPONS    E                     EXTFLD(QQPONS)                                     CGL029
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR DEAL AMENDMENTS
     D MMSTDA        E DS                  EXTNAME(MMSTDAPP)
     D MMSTDADORI    E                     EXTFLD(QQDORI)                                     CGL029
     D MMSTDAMORI    E                     EXTFLD(QQMORI)                                     CGL029
     D MMSTDADOPI    E                     EXTFLD(QQDOPI)                                     CGL029
     D MMSTDAMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
     D MMSTDABORI    E                     EXTFLD(QQBORI)                                     CGL029
     D MMSTDABOPI    E                     EXTFLD(QQBOPI)                                     CGL029
     D MMSTDARORI    E                     EXTFLD(QQRORI)                                     CGL029
     D MMSTDAROPI    E                     EXTFLD(QQROPI)                                     CGL029
     D MMSTDARONS    E                     EXTFLD(QQRONS)                                     CGL029
     D MMSTDAPONS    E                     EXTFLD(QQPONS)                                     CGL029
     D  @STDA1                 1    254
     D  @STDA2               255    299
     D  @STDA3               573    769
     D  @STDA4               770    990
     D  @STDA5               991   1200
     D  @STDA6              1207   1209
     D  @STDA7              1210   1212
     D  @STDA8              1214   1221
     D  @STDA9              1228   1407                                                       CGL029
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURES FOR TEMPLATE FILES FOR
      **  PROJECTED ACCOUNT MOVEMENTS UPDATES
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
      *
      * SET STANDARD DEALS FILE
      *
     C                   EXSR      SETSTD
      *
      ** CALL MM0075 - FORWARD BOOK UPDATE
      *
     C                   CALL      'MM0075'
     C                   PARM                    @TERM             1
     C                   PARM      'A'           @ENQ              1
     C                   PARM                    MMSTDL
     C                   PARM                    MMSTDB
     C                   PARM                    MMSTDS
     C                   PARM                    MMSTDA
      *
      ** ERROR
      *
     C     @TERM         IFEQ      'E'
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   RETURN
     C                   END
      *
      ** CALL MM0073 - NEAR DATES SUMMARY UPDATE
      *
     C                   CALL      'MM0073'
     C                   PARM                    @TERM
     C                   PARM      'A'           @ENQ
     C                   PARM                    MMSTDL
     C                   PARM                    MMSTDB
     C                   PARM                    MMSTDS
     C                   PARM                    MMSTDA
      *
      ** ERROR
      *
     C     @TERM         IFEQ      'E'
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   RETURN
     C                   END
      *
      ** CALL MM0094 - LIQUIDITY EXPOSURE UPDATE
      *
     C                   CALL      'MM0094'
     C                   PARM                    @TERM
     C                   PARM      'A'           @ENQ
     C                   PARM                    MMSTDL
     C                   PARM                    MMSTDB
     C                   PARM                    MMSTDS
     C                   PARM                    MMSTDA
      *
      ** ERROR
      *
     C     @TERM         IFEQ      'E'
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   RETURN
     C                   END
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETSTD - SET STANDARD DEALS FILE                              *
     C*                                                               *
     C*****************************************************************
     C     SETSTD        BEGSR
      *
      * CLEAR STANDARD DEAL FILES
      *
     C                   CLEAR                   MMSTDL
     C                   CLEAR                   MMSTDB
     C                   CLEAR                   MMSTDS
     C                   CLEAR                   MMSTDA
      *
      * GET THE 'AFTER' STATUS OF THE DEAL AMENDMENT
      *
     C                   MOVEL     Z#ASTS        MMDEAM
      *
      * MOVE DEAL AMENDMENT TO STANDARD DEAL
      *
     C                   MOVEL     @DEAM1        @STDA1
     C                   MOVEL     @DEAM2        @STDA2
     C                   MOVEL     @DEAM3        @STDA3
     C                   MOVEL     @DEAM4        @STDA4
     C                   MOVEL     @DEAM5        @STDA5
     C                   MOVEL     @DEAM6        @STDA6
     C                   MOVEL     @DEAM7        @STDA7
     C                   MOVEL     @DEAM8        @STDA8
      *
      * GET THE RELATED DEAL DETAILS
      *
     C                   MOVEL     Z#WSTS        ##RCID            2
      *
      * RELATED DEAL IS A LOAN/DEPOSIT
      * SET 'RELATED DEAL' FIELDS ON THE STANDARD DEAL
      *
     C     ##RCID        IFEQ      'HK'
     C                   MOVEL     Z#WSTS        MMDELD
     C                   Z-ADD     HKORCM        IGRORM
     C                   MOVEL     HKDORI        IGRORI
     C                   MOVEL     HKDCPI        IGRCPI
     C                   Z-ADD     HKMOPM        IGROPM
     C                   MOVEL     HKDOPI        IGROPI
     C                   MOVEL     HKDCRI        IGRCRI
     C                   Z-ADD     HKAMNP        IGRBAT
     C                   MOVEL     HKCCY         IGRBCY
     C**********         Z-ADD     HKCNUM        IGRCNM                                       CSD027
     C                   EVAL      IGRCNM = HKCNUM                                            CSD027
     C                   Z-ADD     @HKVDY        IGRVDT
     C                   MOVEL     HKDSTS        IGRSTS
     C                   Z-ADD     HKINTR        IGRIRT
     C                   MOVE      HKICMT        IGRICM
     C                   END
      *
      * RELATED DEAL IS A NA PURCHASED
      * SET 'RELATED DEAL' FIELDS ON THE STANDARD DEAL
      *
     C     ##RCID        IFEQ      'HL'
     C                   MOVEL     Z#WSTS        MMDENB
     C                   Z-ADD     HLORCM        IGRORM
     C                   MOVEL     HLDORI        IGRORI
     C                   MOVEL     HLDCPI        IGRCPI
     C                   Z-ADD     HLMOPM        IGROPM
     C                   MOVEL     HLDOPI        IGROPI
     C                   MOVEL     HLDCRI        IGRCRI
     C                   Z-ADD     HLAMNP        IGRBAT
     C                   MOVEL     HLCCY         IGRBCY
     C**********         Z-ADD     HLCNUM        IGRCNM                                       CSD027
     C                   EVAL      IGRCNM = HLCNUM                                            CSD027
     C                   Z-ADD     @HLVDY        IGRVDT
     C                   MOVEL     HLDSTS        IGRSTS
     C                   Z-ADD     HLINTR        IGRIRT
     C                   MOVE      HLICMT        IGRICM
     C                   END
      *
      * IF INSERT, BYPASS
      *
     C     @@LACT        CABEQ     'I'           BYPASS
      *
      * GET THE 'BEFORE' STATUS OF THE DEAL AMENDMENT
      *
     C                   MOVEL     Z#BSTS        MMDEAM
      *
      * SET 'BEFORE UPDATE' FIELDS ON THE STANDARD DEAL
      *
     C                   Z-ADD     HNORCM        IGBORM
     C                   MOVEL     HNMORI        IGBORI
     C                   MOVEL     HNDCPI        IGBCPI
     C                   Z-ADD     HNMOPM        IGBOPM
     C                   MOVEL     HNMOPI        IGBOPI
     C                   MOVEL     HNDCRI        IGBCRI
     C                   Z-ADD     HNAMNP        IGBAMT
     C                   MOVEL     HNCCY         IGBUCY
     C**********         Z-ADD     HNCNUM        IGBCNM                                       CSD027
     C                   EVAL      IGBCNM = HNCNUM                                            CSD027
     C                   MOVEL     HNCSNM        IGBCSN
     C                   Z-ADD     @HNVDY        IGBVDT
     C                   MOVEL     HNDSTS        IGBSTS
     C                   Z-ADD     HNINTR        IGBIRT
     C                   MOVEL     HNOSBR        IGBPOB
     C                   MOVEL     HNOSBR        IGBROB
      *
     C     BYPASS        ENDSR
     C*****************************************************************
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
      *
      ** PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    @@LACT            1
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
     C*
     C                   ENDSR
     C*****************************************************
**  CPY@
(c) Finastra International Limited 2001
