     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details Amend Checking')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSDAMD - SD Customer Details Maintenance                  *
      *                                                               *
      *  Function:  This module compares the fields of an             *
      *             amended Customer against those currently on       *
      *             file. It checks whether all fields amended are    *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             It can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW216             Date 14Mar16               *
      *                 CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 CSW214             Date 25Nov14               *
      *                 CFT050             Date 03Jun13               *
      *                 AR1086546          Date 27Jun13               *
      *                 CLE134             Date 01Aug12               *
      *                 AR855391           Date 27Oct11               *
      *                 CSD090             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15872           Date 12Feb08               *
      *                 CSW207A            Date 02Aug07               *
      *                 CSW207             Date 06Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG13525           Date 05Mar07               *
      *                 CSD079             Date 05Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      *                 175680             Date 08Mar00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 13May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  CFT050 - SWIFTRef Directories upload (Recompile)             *
      *  AR1086546 - Upgrade of CDL025 to MP 1.4 (Child: AR1086547).  *
      *              Applied for MD021813                             *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR855391 - CUSD Overridable Errors not found in EN System    *
      *             (CSD091 - Overrideable Errors Configurability     *
      *             Enabler Phase 2 )                                 *
      *  CSD090 - Customer Segmentation (Recompile)                   *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15872 - Applied fix BUG14992                              *
      *  BUG14992 - Some of CSW207 fields not completely upgraded     *
      *             (Recompile)                                       *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSW207 - SWIFT 2007 Changes (Recompile)                      *
      *  BUG13525 - ECSD Mismatch between XML and RPG (Recompile)     *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CRE007 - Base Rate Tax 2001 - Recompiled.                    *
      *  175680 - PB Customer Maintenance - Fields protection         *
      *  CSD007 - Customer Closing: Recompile.                        *
      *  CDL008 - Continuous Linked Settlement (Recompiled)           *
      *  CAP034 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      * (Current) Customer in Screen Format
     D CustScnFm1    E DS                  EXTNAME(SDCUPRPD)
     D                                     PREFIX(@)
     D CustScnFm2    E DS                  EXTNAME(SDCUSEPD)
     D                                     PREFIX(@)
     D CustScnFm3    E DS                  EXTNAME(SDCUMRPD)
     D                                     PREFIX(@)
     D CustScnBrt    E DS                  EXTNAME(SDCUBRPD)
     D                                     PREFIX(@)
     D CustScnSwft   E DS                  EXTNAME(SDCUSWPD)                                  CSW207
     D                                     PREFIX(@)                                          CSW207
     D CustCuCumi    E DS                  EXTNAME (SDCUMIPD)                                 CSD079
     D                                     PREFIX (@1)                                        CSD079
     D CustCuCuad    E DS                  EXTNAME (SDCUADPD)                                 CSD079
     D                                     PREFIX (@2)                                        CSD079
     D CustCuSfee    E DS                  EXTNAME (SDSFEEPD)                                 CSD079
     D                                     PREFIX (@3)                                        CSD079
     D CustCuChec    E DS                  EXTNAME (SDCHECPD)                                 CSD079
     D                                     PREFIX (@4)                                        CSD079
     D CustCuCusf    E DS                  EXTNAME (SDCUSFPD)                                 CSD079
     D                                     PREFIX (@5)                                        CSD079
     D CustCuCufx    E DS                  EXTNAME (SDCUFXPD)                                 CSD079
     D                                     PREFIX (@6)                                        CSD079
     D CustCuCufd    E DS                  EXTNAME (SDCUFDPD)                                 CSD079
     D                                     PREFIX (@7)                                        CSD079
     D CustCuRwan    E DS                  EXTNAME (SDRWANPD)                                 CSD079
     D                                     PREFIX (@8)                                        CSD079
     D CustCuCufo    E DS                  EXTNAME (SDCUFOPD)                                 CSD079
     D                                     PREFIX (@9)                                        CSD079
     D CustCuCupm    E DS                  EXTNAME (SDCUPMPD)                                 CSD079
     D                                     PREFIX (@10)                                       CSD079
     D CustCuTicd    E DS                  EXTNAME (SDTICDPD)                                 CSD079
     D                                     PREFIX (@11)                                       CSD079
     D CustCuCurx    E DS                  EXTNAME (SDCURXPD)                                 CSD079
     D                                     PREFIX (@12)                                       CSD079
     D CustCuCtnm    E DS                  EXTNAME (SDCCTNPD)                              AR1086546
     D                                     PREFIX (@24)                                    AR1086546
 
      * New Customer in Screen Format
     D NewCusScn1    E DS                  EXTNAME(SDCUPRPD)
     D NewCusScn2    E DS                  EXTNAME(SDCUSEPD)
     D NewCusScn3    E DS                  EXTNAME(SDCUMRPD)
     D NewCusScBr    E DS                  EXTNAME(SDCUBRPD)
     D NewCusSwft    E DS                  EXTNAME(SDCUSWPD)                                  CSW207
     D NewCusCumi    E DS                  EXTNAME (SDCUMIPD)                                 CSD079
     D                                     PREFIX(@12)                                        CSD079
     D NewCusCuad    E DS                  EXTNAME (SDCUADPD)                                 CSD079
     D                                     PREFIX(@13)                                        CSD079
     D NewCusSfee    E DS                  EXTNAME (SDSFEEPD)                                 CSD079
     D                                     PREFIX(@14)                                        CSD079
     D NewCusChec    E DS                  EXTNAME (SDCHECPD)                                 CSD079
     D                                     PREFIX(@15)                                        CSD079
     D NewCusCusf    E DS                   EXTNAME (SDCUSFPD)                                CSD079
     D                                     PREFIX(@16)                                        CSD079
     D NewCusCufx    E DS                   EXTNAME (SDCUFXPD)                                CSD079
     D                                     PREFIX(@17)                                        CSD079
     D NewCusCufd    E DS                   EXTNAME (SDCUFDPD)                                CSD079
     D                                     PREFIX(@18)                                        CSD079
     D NewCusRwan    E DS                   EXTNAME (SDRWANPD)                                CSD079
     D                                     PREFIX(@19)                                        CSD079
     D NewCusCufo    E DS                   EXTNAME (SDCUFOPD)                                CSD079
     D                                     PREFIX(@20)                                        CSD079
     D NewCusCupm    E DS                   EXTNAME (SDCUPMPD)                                CSD079
     D                                     PREFIX(@21)                                        CSD079
     D NewCusTicd    E DS                   EXTNAME (SDTICDPD)                                CSD079
     D                                     PREFIX(@22)                                        CSD079
     D NewCusCuRx    E DS                   EXTNAME (SDCURXPD)                                CSD079
     D                                     PREFIX(@23)                                        CSD079
     D NewCusCtnm    E DS                   EXTNAME (SDCCTNPD)                             AR1086546
     D                                     PREFIX(@25)                                     AR1086546
 
      ** External DS for SAR Details                                                          CSD079
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD079
      * (Current) Customer in File Format
     D CustFilFmt    E DS                  EXTNAME(SDCUSTPD)
 
      * (Current) Base Rate Tax details in File Format
     D BrTxFilFmt    E DS                  EXTNAME(SDCBRTPD)
                                                                                              CSD079
      ** Marketing Information                                                                CSD079
     D CumiFilFmt    E DS                  EXTNAME(SDCMRKPD)                                  CSD079
                                                                                              CSD079
      ** Additional Customer                                                                  CSD079
     D CuadFilFmt    E DS                  EXTNAME(SDACUSPD)                                  CSD079
                                                                                              CSD079
      ** Service Fees                                                                         CSD079
     D SfeeFilFmt    E DS                  EXTNAME(SDCFCDPD)                                  CSD079
                                                                                              CSD079
      ** Cheques and Card Details                                                             CSD079
     D ChecFilFmt    E DS                  EXTNAME(SDCHEQPD)                                  CSD079
                                                                                              CSD079
      ** Safe Details                                                                         CSD079
     D CusfFilFmt    E DS                  EXTNAME(SDSAFEPD)                                  CSD079
                                                                                              CSD079
      ** Risk Weighted Assets                                                                 CSD079
     D RwanFilFmt    E DS                  EXTNAME(SDCRWAPD)                                  CSD079
                                                                                              CSD079
      ** Future and Options                                                                   CSD079
     D CufoFilFmt    E DS                  EXTNAME(SDFOCSPD)                                  CSD079
     D                                     PREFIX(Q_)                                         CSD079
                                                                                              CSD079
      ** Portfolio Management                                                                 CSD079
     D CupmFilFmt    E DS                  EXTNAME(SDPLCSPD)                                  CSD079
      ** Currency/Time of Netting Details                                                  AR1086546
     D CtnmFilFmt    E DS                  EXTNAME(SDCTNMPD)                               AR1086546
                                                                                           AR1086546
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      **  Data structure for Portfolio Management ICD File
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning error message ids etc                                  AR855391
     D WIdx            S              3P 0                                                  AR855391
 
      * Error indicators
     D OKCuPrim      E DS                  EXTNAME(SDECUPRPD)
     D OKCuSeco      E DS                  EXTNAME(SDECUSEPD)
     D OKCuMsrt      E DS                  EXTNAME(SDECUMRPD)
     D OKCuBrtx      E DS                  EXTNAME(SDECUBRPD)
     D OKCuSwft      E DS                  EXTNAME(SDECUSWPD)                                 CSW207
     D OKCuCumi      E DS                  EXTNAME (SDECUMIPD)                                CSD079
     D                                     PREFIX(@23)                                        CSD079
     D OKCuCuad      E DS                  EXTNAME (SDECUADPD)                                CSD079
     D                                     PREFIX(@24)                                        CSD079
     D OKCuSfee      E DS                  EXTNAME (SDESFEEPD)                                CSD079
     D                                     PREFIX(@25)                                        CSD079
     D OKCuChec      E DS                  EXTNAME (SDECHECPD)                                CSD079
     D                                     PREFIX(@26)                                        CSD079
     D OKCuCusf      E DS                  EXTNAME (SDECUSFPD)                                CSD079
     D                                     PREFIX(@27)                                        CSD079
     D OKCuCufx      E DS                  EXTNAME (SDECUFXPD)                                CSD079
     D                                     PREFIX(@28)                                        CSD079
     D OKCuCufd      E DS                  EXTNAME (SDECUFDPD)                                CSD079
     D                                     PREFIX(@29)                                        CSD079
     D OKCuRwan      E DS                  EXTNAME (SDERWANPD)                                CSD079
     D                                     PREFIX(@30)                                        CSD079
     D OKCuCufo      E DS                  EXTNAME (SDECUFOPD)                                CSD079
     D                                     PREFIX(@31)                                        CSD079
     D OKCuCupm      E DS                  EXTNAME (SDECUPMPD)                                CSD079
     D                                     PREFIX(@32)                                        CSD079
     D OKCuTicd      E DS                  EXTNAME (SDETICDPD)                                CSD079
     D                                     PREFIX(@33)                                        CSD079
     D OKCuCulx2     E DS                  EXTNAME (SDECULX2PD)                               CSD079
     D OKCuCulx1     E DS                  EXTNAME (SDECULX1PD)                               CSD079
     D OKCuCtnm      E DS                  EXTNAME (SDECTNMPD)                             AR1086546
     D                                     PREFIX(@34)                                     AR1086546
                                                                                              CSD079
     D CSD079          S              1                                                       CSD079
     D CSL002          S              1                                                       CSD079
     D PRTCD           S              7                                                       CSD079
     D POPTN           S              7                                                       CSD079
     D PSARD           S              6                                                       CSD079
     D PMODE           S              1                                                       CSD079
                                                                                              CSD079
     D CDL002          S              1                                                       CSD079
 
 
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
     C                   MOVEL     *BLANKS       @ERRMSG           7
      *
      **  Compare fields with "amended" values or "changed" values.
      *
     C                   EXSR      COMPFLD
      *
      *  If any errors were found:
      *    Set Amendments OK Indicator to 'N'
      *
     C     Idx           IFGT      0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
      *
      *  If any errors were found:
      *  - and reset of fields in error required, do this
      *
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      RESETFLD
     C                   ENDIF
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * COMPFLD  - Compare certain fields on the current Customer     *
      *            with those "amended".                              *
      *****************************************************************
     C     COMPFLD       BEGSR
      *
      ** Customer Number
     C     DDCUSN        IFNE      @DDCUSN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCUSN'
     C                   EVAL      MsgIDArr(Idx)   = @ERRMSG
     C                   EVAL      MsgDtaArr(Idx)  = 'DDCUSN'
     C                   EVAL      DDCUSNok        = 'N'
      *                                                                         175680
      ** In case od amend, only some field can be amended                       175680
     C     DDPRBA        IFEQ      'Y'                                          175680
     C     DDCNA1        IFNE      @DDCNA1                                      175680
     C     DDCSSN        ORNE      @DDCSSN                                      175680
     C     DDCNA2        ORNE      @DDCNA2                                      175680
     C     DDDRCS        ORNE      @DDDRCS                                      175680
     C     DDLCCD        ORNE      @DDLCCD                                      175680
     C     DDCNA3        ORNE      @DDCNA3                                      175680
     C     DDCNA4        ORNE      @DDCNA4                                      175680
     C     DDCRNM        ORNE      @DDCRNM                                      175680
     C     DDCRTN        ORNE      @DDCRTN                                      175680
     C     DDACOC        ORNE      @DDACOC                                      175680
     C     DDCASC        ORNE      @DDCASC                                      175680
     C     DDCNCZ        ORNE      @DDCNCZ                                      175680
     C     DDBSIN        ORNE      @DDBSIN                                      175680
     C     DDCOLC        ORNE      @DDCOLC                                      175680
     C     DDBNBI        ORNE      @DDBNBI                                      175680
     C     DDLINC        ORNE      @DDLINC                                      175680
     C     DDLICD        ORNE      @DDLICD                                      175680
     C     DDCTNB        ORNE      @DDCTNB                                      175680
     C     DDTAIN        ORNE      @DDTAIN                                      175680
     C     DDREID        ORNE      @DDREID                                      175680
     C     DDCSTY        ORNE      @DDCSTY                                      175680
     C     DDCDEL        ORNE      @DDCDEL                                      175680
     C     DDRWCD        ORNE      @DDRWCD                                      175680
     C     DDMCAC        ORNE      @DDMCAC                                      175680
     C     DDCGRP        ORNE      @DDCGRP                                      175680
     C     DDMTSC        ORNE      @DDMTSC                                      175680
     C                                                                          175680
     C                   MOVEL     @DDCNA1       DDCNA1                         175680
     C                   MOVEL     @DDCSSN       DDCSSN                         175680
     C                   MOVEL     @DDCNA2       DDCNA2                         175680
     C                   MOVEL     @DDDRCS       DDDRCS                         175680
     C                   MOVEL     @DDLCCD       DDLCCD                         175680
     C                   MOVEL     @DDCNA3       DDCNA3                         175680
     C                   MOVEL     @DDCNA4       DDCNA4                         175680
     C                   MOVEL     @DDCRNM       DDCRNM                         175680
     C                   MOVEL     @DDCRTN       DDCRTN                         175680
     C                   MOVEL     @DDACOC       DDACOC                         175680
     C                   MOVEL     @DDCASC       DDCASC                         175680
     C                   MOVEL     @DDCNCZ       DDCNCZ                         175680
     C                   MOVEL     @DDBSIN       DDBSIN                         175680
     C                   MOVEL     @DDCOLC       DDCOLC                         175680
     C                   MOVEL     @DDBNBI       DDBNBI                         175680
     C                   MOVEL     @DDLINC       DDLINC                         175680
     C                   MOVEL     @DDLICD       DDLICD                         175680
     C                   MOVEL     @DDCTNB       DDCTNB                         175680
     C                   MOVEL     @DDTAIN       DDTAIN                         175680
     C                   MOVEL     @DDREID       DDREID                         175680
     C                   MOVEL     @DDCSTY       DDCSTY                         175680
     C                   MOVEL     @DDCDEL       DDCDEL                         175680
     C                   MOVEL     @DDRWCD       DDRWCD                         175680
     C                   MOVEL     @DDMCAC       DDMCAC                         175680
     C                   MOVEL     @DDCGRP       DDCGRP                         175680
     C                   MOVEL     @DDMTSC       DDMTSC                         175680
     C                   ENDIF                                                  175680
     C                   ENDIF                                                  175680
     C                   ENDIF
                                                                                              CSD079
      ** Net Settlement                                                                       CSD079
                                                                                              CSD079
     C                   IF         CDL002 = 'Y' AND CSD079 = 'Y'                             CSD079
     C                              AND @17DDNET = 'N' AND @6DDNET = 'Y'                      CSD079
     C**********         ADD       1             Idx                                 CSD079 AR855391
     C**********         EVAL      FldNameArr(Idx) = 'DDNET'                         CSD079 AR855391
     C**********         EVAL      MsgIDArr(Idx)   = 'USR3140'                       CSD079 AR855391
     C**********         EVAL      MsgDtaArr(Idx)  = 'DDNET'                         CSD079 AR855391
     C**********         EVAL      @28DDNETOK        = 'N'                           CSD079 AR855391
     C                   EVAL      WIdx = WIdx + 1                                          AR855391
     C                   EVAL      WFldNamArr(WIdx) = 'DDNET'                               AR855391
     C                   EVAL      WMsgIDArr(WIdx)  = 'USR3140'                             AR855391
     C                   EVAL      WMsgDtaArr(WIdx)  = 'DDNET'                              AR855391
     C                   EVAL      @28DDNETOK        = 'W'                                  AR855391
     C                   ENDIF                                                                CSD079
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETFLD - Reset fields in Error                              *
      *****************************************************************
     C     RESETFLD      BEGSR
      *
      * Reset fields in error to 'current' values
      *
     C     DDCUSNOK      IFEQ      'N'
     C                   MOVEL     @DDCUSN       DDCUSN
     C                   END
      *
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
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * New Customer in Screen Format :
 Form * - Primary Details
      * - Secondary Details
      * - Message Routing Details
      * - Base Rate Tax Details
     C                   PARM                    NewCusScn1
     C                   PARM                    NewCusScBr
     C                   PARM                    NewCusScn2
     C                   PARM                    NewCusScn3
     C                   PARM                    NewCusSwft                                   CSW207
     C                   PARM                    NewCusCumi                                   CSD079
     C                   PARM                    NewCusCuad                                   CSD079
     C                   PARM                    NewCusSfee                                   CSD079
     C                   PARM                    NewCusCufx                                   CSD079
     C                   PARM                    NewCusCufd                                   CSD079
     C                   PARM                    NewCusChec                                   CSD079
     C                   PARM                    NewCusCusf                                   CSD079
     C                   PARM                    NewCusRwan                                   CSD079
     C                   PARM                    NewCusCufo                                   CSD079
     C                   PARM                    NewCusCupm                                   CSD079
     C                   PARM                    NewCusTicd                                   CSD079
     C                   PARM                    NewCusCuRx                                   CSD079
     C                   PARM                    NewCusCtnm                                AR1086546
      *
      * (Current) Customer in Screen Format :
 Form * - Primary Details
      * - Secondary Details
      * - Message Routing Details
     C                   PARM                    CustScnFm1
     C                   PARM                    CustScnFm2
     C                   PARM                    CustScnFm3
     C                   PARM                    CustScnBrt
     C                   PARM                    CustScnSwft                                  CSW207
     C                   PARM                    CustCuCumi                                   CSD079
     C                   PARM                    CustCuCuad                                   CSD079
     C                   PARM                    CustCuSfee                                   CSD079
     C                   PARM                    CustCuCufx                                   CSD079
     C                   PARM                    CustCuCufd                                   CSD079
     C                   PARM                    CustCuChec                                   CSD079
     C                   PARM                    CustCuCusf                                   CSD079
     C                   PARM                    CustCuRwan                                   CSD079
     C                   PARM                    CustCuCufo                                   CSD079
     C                   PARM                    CustCuCupm                                   CSD079
     C                   PARM                    CustCuTicd                                   CSD079
     C                   PARM                    CustCuCurx                                   CSD079
     C                   PARM                    CustCuCtnm                                AR1086546
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OKCuPrim
     C                   PARM                    OKCuSeco
     C                   PARM                    OKCuMsrt
     C                   PARM                    OKCuBrtx
     C                   PARM                    OKCuSwft                                     CSW207
     C                   PARM                    OKCuCumi                                     CSD079
     C                   PARM                    OKCuCuad                                     CSD079
     C                   PARM                    OKCuSfee                                     CSD079
     C                   PARM                    OKCuCufx                                     CSD079
     C                   PARM                    OKCuCufd                                     CSD079
     C                   PARM                    OKCuChec                                     CSD079
     C                   PARM                    OKCuCusf                                     CSD079
     C                   PARM                    OKCuRwan                                     CSD079
     C                   PARM                    OKCuCufo                                     CSD079
     C                   PARM                    OKCuCupm                                     CSD079
     C                   PARM                    OKCuTicd                                     CSD079
     C                   PARM                    OKCuCulx2                                    CSD079
     C                   PARM                    OKCuCulx1                                    CSD079
     C                   PARM                    OKCuCtnm                                  AR1086546
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/message data (arrays) from/to                           AR855391
      ** caller                                                                             AR855391
                                                                                            AR855391
     C                   PARM                    WFldNamArr                                 AR855391
     C                   PARM                    WMsgIDArr                                  AR855391
     C                   PARM                    WMsgDtaArr                                 AR855391
                                                                                            AR855391
      ** Array index (3P0) from/to caller                                                   AR855391
                                                                                            AR855391
     C                   PARM                    WIdx                                       AR855391
                                                                                            AR855391
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDCUSDAMD'   DBPGM
      *
      **  GET RUNDAT to access MULTI-BRANCHING flag.
      **
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** PORTFOLIO MANAGEMENT DETAILS
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C                   END
                                                                                              CSD079
      ** Check if enhancement CSD079 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'CSD079'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'CSD079'                                          CSD079
     C                   EVAL      DBASE  = 905                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      CSD079 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      CSD079 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     ** Check if enhancement CDL002 is on                                                     CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'CDL002'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'CDL002'                                          CSD079
     C                   EVAL      DBASE  = 906                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      CDL002 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      CDL002 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
