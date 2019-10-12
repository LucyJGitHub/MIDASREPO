     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/Deposits TM Database Update')           *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMLDNIUPT - LOANS/DEPOSITS TM DATABASE UPDATE                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 23Feb15               *
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
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 10Nov99               *
      *                 CDL007             Date 05Oct99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 154477             Date 29Jan99               *
      *                 136434             Date 23Jun98               *
      *                 CAP003             Date 05May98               *
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
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to changes in MMDELDPP               *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *           Recompiled due to changes in MMDELDPP               *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDELDPP               *
      *  154477 - Recompile for change to MMVLDNIPD.                  *
      *  136434 - Treasury management updates in error                *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs. (RECOMPILED)                           *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
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
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      **  DEALS FILE - LOANS/DEPOSITS/NAS ISSUED
     D MMDELD        E DS                  EXTNAME(MMDELDPP)
     D  @HKVDY                50     57  0
     D  @HKSLY               179    186  0
     D  @HKNIY               205    212  0
     D  @HKMDY               252    259  0
     D  @DELD1                 1    255
     D  @DELD2               256    447
     D  @DELD3               456    687
     D  @DELD4               688    908
     D  @DELD5               909   1083
     D  @DELD6              1084   1096
     D  @DELD7              1105   1107
     D  @DELD8              1108   1175
     D  @DELD9              1180   1190
     D  @DELD2Ex            1669   1740                                                       CGL029
     D  @DELD3Ex            1741   1776                                                       CGL029
     D  @DELD8Ex            1777   1797                                                       CGL029
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR STANDARD DEAL FORMAT
     D MMSTDL        E DS                  EXTNAME(MMSTDLPP)
     D QQDOR1        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR1        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP1        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP1        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQRON1        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON1        E                     EXTFLD(QQPONS)                                     CGL029
     D QQINS1        E                     EXTFLD(QQINSA)                                     CGL029
     D  @STDL1                 1    255
     D  @STDL2               256    447
     D  @STDL3               723    954
     D  @STDL4               955   1175
     D  @STDL5              1176   1350
     D  @STDL6              1357   1369
     D  @STDL7              1382   1384
     D  @STDL8              1385   1452
     D  @STDL9              1457   1467
     D  @STDL2Ex            1802   1873                                                       CGL029
     D  @STDL3Ex            1910   1945                                                       CGL029
     D  @STDL8Ex            1946   1966                                                       CGL029
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR NA BOUGHT FORMAT
     D MMSTDB        E DS                  EXTNAME(MMSTDBPP)
     D QQDOR2        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR2        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP2        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP2        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQRON2        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON2        E                     EXTFLD(QQPONS)                                     CGL029
     D QQBOR2        E                     EXTFLD(QQBORI)                                     CGL029
     D QQBOP2        E                     EXTFLD(QQBOPI)                                     CGL029
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR NA SOLD FORMAT
     D MMSTDS        E DS                  EXTNAME(MMSTDSPP)
     D QQDOR3        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR3        E                     EXTFLD(QQMORI)                                     CGL029
     D QQBOR3        E                     EXTFLD(QQBORI)                                     CGL029
     D QQBOP3        E                     EXTFLD(QQBOPI)                                     CGL029
     D QQROR3        E                     EXTFLD(QQRORI)                                     CGL029
     D QQROP3        E                     EXTFLD(QQROPI)                                     CGL029
     D QQRON3        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON3        E                     EXTFLD(QQPONS)                                     CGL029
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR DEAL AMENDMENTS
     D MMSTDA        E DS                  EXTNAME(MMSTDAPP)
     D QQDOR4        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR4        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP4        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP4        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQBOR4        E                     EXTFLD(QQBORI)                                     CGL029
     D QQBOP4        E                     EXTFLD(QQBOPI)                                     CGL029
     D QQROR4        E                     EXTFLD(QQRORI)                                     CGL029
     D QQROP4        E                     EXTFLD(QQROPI)                                     CGL029
     D QQRON4        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON4        E                     EXTFLD(QQPONS)                                     CGL029
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURES FOR TEMPLATE FILES FOR
      **  PROJECTED ACCOUNT MOVEMENTS UPDATES
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
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
     C                   PARM      'L'           @ENQ              1
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
     C                   PARM      'L'           @ENQ
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
     C                   PARM      'L'           @ENQ
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
      * GET THE 'AFTER' STATUS OF THE DEAL
      *
     C                   MOVEL     Z#ASTS        MMDELD
      *
      * MOVE DEAL TO STANDARD DEAL
      *
     C                   MOVEL     @DELD1        @STDL1
     C                   MOVEL     @DELD2        @STDL2
     C                   MOVEL     @DELD3        @STDL3
     C                   MOVEL     @DELD4        @STDL4
     C                   MOVEL     @DELD5        @STDL5
     C                   MOVEL     @DELD6        @STDL6
     C                   MOVEL     @DELD7        @STDL7
     C                   MOVEL     @DELD8        @STDL8
     C                   MOVEL     @DELD9        @STDL9
     C                   MOVEL     @DELD2Ex      @STDL2Ex                                     CGL029
     C                   MOVEL     @DELD3Ex      @STDL3Ex                                     CGL029
     C                   MOVEL     @DELD8Ex      @STDL8Ex                                     CGL029
     C                   MOVEL     HKBOKC        IKBOKC
     C                   Z-ADD     HKDVSD        IKDVSD                         136434
     C                   Z-ADD     HKDDND        IKDDND                         136434
     C                   Z-ADD     HKNIPD        IKNIPD                         136434
     C                   Z-ADD     HKSLID        IKSLID                         136434
     C                   Z-ADD     HKMATD        IKMATD                         136434
      *
      * IF INSERT, BYPASS
      *
     C     @@LACT        CABEQ     'I'           BYPASS
      *
      * GET THE 'BEFORE' STATUS OF THE DEAL
      *
     C                   MOVEL     Z#BSTS        MMDELD
      *
      * SET 'BEFORE UPDATE' FIELDS ON THE STANDARD DEAL
      *
     C                   MOVEL     HKORCM        IKBORM
     C                   MOVEL     HKMORI        IKBORI
     C                   MOVEL     HKDCPI        IKBCPI
     C                   MOVEL     HKMOPM        IKBOPM
     C                   MOVEL     HKMOPI        IKBOPI
     C                   MOVEL     HKDCRI        IKBCRI
     C                   Z-ADD     HKAMNP        IKBAMT
     C                   MOVEL     HKCCY         IKBUCY
     C                   MOVEL     HKCNUM        IKBCNM
     C                   Z-ADD     @HKVDY        IKBVDT
     C                   MOVEL     HKDSTS        IKBSTS
     C                   MOVEL     HKCSNM        IKBCSN
     C                   Z-ADD     HKINTR        IKBIRT
     C                   Z-ADD     @HKNIY        IKBNID
     C                   MOVEL     HKIPFQ        IKBIPF
     C                   MOVEL     HKICMT        IKBICM
     C                   Z-ADD     HKIPDM        IKBIDM
     C                   Z-ADD     @HKSLY        IKBLID
     C                   Z-ADD     @HKMDY        IKBMTD
     C                   Z-ADD     HKNTCE        IKBNTC
     C                   MOVEL     HKROBR        IKBROB
     C                   MOVEL     HKPOBR        IKBPOB
     C                   Z-ADD     HKMTTI        IKBMTI
     C                   MOVEL     HKRDFC        IKBRDF
     C                   MOVEL     HKFLID        IKBFLI
     C                   MOVEL     HKFUID        IKBFUI
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
     C*
     C                   ENDSR
     C**********************************************************************
**  CPY@
(c) Finastra International Limited 2001
