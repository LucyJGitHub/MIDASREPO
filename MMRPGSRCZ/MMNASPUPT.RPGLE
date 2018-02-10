     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NA's Purchased TM Database Update')
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMNASPUPT - NAS PURCHASED TM DATABASE UPDATE                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CAP086             Date 08Jun05               *
      *                 TDA012             Date 23Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  TDA012 - Fix 10-digit account code processing.               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
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
      *
      **  DEALS FILE - NAS PURCHASED
     D MMDENB        E DS                  EXTNAME(MMDENBPP)
     D  @HLVDY                50     57  0
     D  @HLNIY               179    186  0
     D  @HLSLY               223    230  0
     D  @HLMDY               265    272  0
     D  @DENB1                 1    255
     D  @DENB2               256    458
     D  @DENB3               463    608
     D  @DENB4               609    842
     D  @DENB5               843   1090
     D  @DENB6              1091   1104
     D  @DENB7              1105   1122
     D  @DENB8              1123   1133
     D**@DENB2Ex            1245   1316                                                CGL029 TDA012
     D**@DENB3Ex            1317   1352                                                CGL029 TDA012
     D  @DENB2Ex            1260   1331                                                       TDA012
     D  @DENB3Ex            1332   1367                                                       TDA012
      *
      **  DEALS FILE - NAS SOLD
     D MMDENS        E DS                  EXTNAME(MMDENSPP)
     D QQDOR1        E                     EXTFLD(DORIQQ)                                     CGL029
     D QQMOR1        E                     EXTFLD(MORIQQ)                                     CGL029
     D QQRON1        E                     EXTFLD(RONSQQ)                                     CGL029
     D QQPON1        E                     EXTFLD(PONSQQ)                                     CGL029
     D  @HMVDY                50     57  0
      *
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR LOANS & DEPOSITS
     D MMSTDL        E DS                  EXTNAME(MMSTDLPP)
     D QQDOR2        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR2        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP2        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP2        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQRON2        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON2        E                     EXTFLD(QQPONS)                                     CGL029
      *
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR NA BOUGHT FORMAT
     D MMSTDB        E DS                  EXTNAME(MMSTDBPP)
     D QQDOR3        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR3        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP3        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP3        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQRON3        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON3        E                     EXTFLD(QQPONS)                                     CGL029
     D QQBOR3        E                     EXTFLD(QQBORI)                                     CGL029
     D QQBOP3        E                     EXTFLD(QQBOPI)                                     CGL029
     D  @STDB1                 1    255
     D  @STDB2               256    458
     D  @STDB3               860   1005
     D  @STDB4              1006   1239
     D  @STDB5              1240   1487
     D  @STDB6              1494   1507
     D  @STDB7              1509   1526
     D  @STDB8              1527   1537
     D  @STDB2Ex            1551   1622                                                       CGL029
     D  @STDB3Ex            1695   1730                                                       CGL029
      *
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR NA SOLD FORMAT
     D MMSTDS        E DS                  EXTNAME(MMSTDSPP)
     D QQDOR4        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR4        E                     EXTFLD(QQMORI)                                     CGL029
     D QQBOR4        E                     EXTFLD(QQBORI)                                     CGL029
     D QQBOP4        E                     EXTFLD(QQBOPI)                                     CGL029
     D QQROR4        E                     EXTFLD(QQRORI)                                     CGL029
     D QQROP4        E                     EXTFLD(QQROPI)                                     CGL029
     D QQRON4        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON4        E                     EXTFLD(QQPONS)                                     CGL029
      *
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR DEAL AMENDMENTS
     D MMSTDA        E DS                  EXTNAME(MMSTDAPP)
     D QQDOR5        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR5        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP5        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP5        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQBOR5        E                     EXTFLD(QQBORI)                                     CGL029
     D QQBOP5        E                     EXTFLD(QQBOPI)                                     CGL029
     D QQROR5        E                     EXTFLD(QQRORI)                                     CGL029
     D QQROP5        E                     EXTFLD(QQROPI)                                     CGL029
     D QQRON5        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON5        E                     EXTFLD(QQPONS)                                     CGL029
      *
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
     C                   PARM      'B'           @ENQ              1
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
     C                   PARM      'B'           @ENQ
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
     C                   PARM      'B'           @ENQ
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
     C                   MOVEL     Z#ASTS        MMDENB
      *
      * MOVE DEAL TO STANDARD DEAL
      *
     C                   MOVEL     @DENB1        @STDB1
     C                   MOVEL     @DENB2        @STDB2
     C                   MOVEL     @DENB3        @STDB3
     C                   MOVEL     @DENB4        @STDB4
     C                   MOVEL     @DENB5        @STDB5
     C                   MOVEL     @DENB6        @STDB6
     C                   MOVEL     @DENB7        @STDB7
     C                   MOVEL     @DENB8        @STDB8
     C                   MOVEL     @DENB2Ex      @STDB2Ex                                     CGL029
     C                   MOVEL     @DENB3Ex      @STDB3Ex                                     CGL029
     C                   MOVEL     HLBOKC        IHBOKC
      *
      * GET THE RELATED DEAL DETAILS
      *
     C                   MOVEL     Z#WSTS        ##RCID            2
      *
      * IF PRESENT
      * SET 'RELATED DEAL' FIELDS ON THE STANDARD DEAL
      *
     C     ##RCID        IFNE      *BLANK
     C                   MOVEL     Z#WSTS        MMDENS
     C                   Z-ADD     @HMVDY        IHRVDT
     C                   Z-ADD     HMAMNP        IHRBAT
     C                   END
      *
      * IF INSERT, BYPASS
      *
     C     @@LACT        CABEQ     'I'           BYPASS
      *
      * GET THE 'BEFORE' STATUS OF THE DEAL
      *
     C                   MOVEL     Z#BSTS        MMDENB
      *
      * SET 'BEFORE UPDATE' FIELDS ON THE STANDARD DEAL
      *
     C                   MOVEL     HLORCM        IHBORM
     C                   MOVEL     HLMORI        IHBORI
     C                   MOVEL     HLDCPI        IHBCPI
     C                   MOVEL     HLMOPM        IHBOPM
     C                   MOVEL     HLMOPI        IHBOPI
     C                   MOVEL     HLDCRI        IHBCRI
     C                   Z-ADD     HLAMNP        IHBAMT
     C                   MOVEL     HLCCY         IHBUCY
     C                   MOVEL     HLCNUM        IHBCNM
     C                   Z-ADD     @HLVDY        IHBVDT
     C                   MOVEL     HLDSTS        IHBSTS
     C                   MOVEL     HLCSNM        IHBCSN
     C                   Z-ADD     HLINTR        IHBIRT
     C                   Z-ADD     @HLNIY        IHBNID
     C                   MOVEL     HLIPFQ        IHBIPF
     C                   MOVEL     HLICMT        IHBICM
     C                   Z-ADD     HLIPDM        IHBIDM
     C                   Z-ADD     HLFVAL        IHBFVL
     C                   Z-ADD     HLFRAT        IHBFRT
     C                   MOVEL     HLISUR        IHBISR
     C                   Z-ADD     @HLSLY        IHBLID
     C                   Z-ADD     @HLMDY        IHBMTD
     C                   MOVEL     HLROBR        IHBROB
     C                   MOVEL     HLPOBR        IHBPOB
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
