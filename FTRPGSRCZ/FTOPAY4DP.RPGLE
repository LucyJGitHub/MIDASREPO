     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing Payments Charges/Commsns display')   *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAY4DP - Outgoing Payments Charges/Commissions Display    *
      *                                                               *
      *  Function:  This API module will serve as the screen display/ *
      *             input module of Charges and Commissions relocated *
      *             here mainly from screen 2 level 2 and some other  *
      *             charges details from screen 1 level 2 to give     *
      *             way to all MT103 additional details.              *
      *                                                               *
      *  Called By: FTOPAY1SN                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD035776           Date 10Sep15               *
      *  Prev Amend No. AR898162           Date 25Nov14               *
      *                 MD027047           Date 19Aug14               *
      *                 MD020737           Date 10Jun13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 250600             Date 07Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG433             Date 05Dec05               *
      *                 CDL049             Date 06Jul06               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 01Aug03               *
      *                 219241             Date 01Jul03               *
      *                 212647             Date 09Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 197845             Date 26Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 09Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *Create    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD035776 - User need to press twice on input screen          *
      *           - Remove unsupported keywords of HATS from dspf     *
      *             (Recompile)                                       *
      *  AR898162 - Charge codes passed via API are lost              *
      *             (Child: AR898163)                                 *
      *  MD027047 - Avoid HATS issue with redisplaying previous screen*
      *             on the stack. End program with SETON LR with no   *
      *             RETURN.                                           *
      *  MD020737 - System is not applying FT Commission to OPAY      *
      *             transaction.                                      *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG433 - Recompiled due to change in FTPCHGPD                *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - MidasPlus Changes                                   *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value                                        *
      *  212647 - Charges are not shown correctly on the screen.      *
      *  197845 - STRCD must be updated with the new recalculated     *
      *           value.                                              *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTOPAY4DF CF   E             WORKSTN INFDS(INFDS#)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *                                                                         CFT009
      ** Payment Charge defintion file                                          CFT009
     FFTPCHGL0  IF   E           K DISK    INFSR(*PSSR)                         CFT009
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       68  Position cursor on action code (if it is blank)     *
      *       69  Protect deal key fields (action code & deal number) *
      *       70  Protect deal detail fields                          *
      *       77  Enable CF04, BIC DB+ Prompt                         *
      *       78  Enable CF16, BIC DB+ Search                         *
      *       79  Highlight deal status                               *
      *                                                               *
      *       80  Not multibranching                                  *
      *       84  SAR feature S01494 switched ON                      *
      *       85  SAR feature S01499 switched ON                      *
      *       87  CFT014 switchable enhancement is installed          *
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
      *                                                               *
      *****************************************************************
      /EJECT
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **---------------------------------------------------------------
 
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
 
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
 
      * Miscellaneous Charge descriptions                                       CFT009
     D DESC            S             30    DIM(5) CTDATA PERRCD(1)              CFT009
     D @EI             S              1    DIM(60)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for General Ledger details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for Currency details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas Module details
 
     DSDMGME         E DS                  EXTNAME(SDMGMEPD)                                  219241
      ** External DS for Midas Message Management ICD                                         219241
                                                                                              219241
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for Midas Switchable Features details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, long data structure
 
     D FTOPAY1       E DS                  EXTNAME(FTOPY1PD)
      ** Screen fields (Initial Screen)
     D FTOPAY2a      E DS                  EXTNAME(FTOPY2PD)
      ** Screen fields (Second Screen)
     D FTOPAY2b      E DS                  EXTNAME(FTOPY3PD)
      ** Screen fields (Second Screen)
     D FTOPAY3       E DS                  EXTNAME(FTOPY4PD)
      ** Screen fields (Charge & Commissions Screen)
 
     D FTOPAY1X      E DS                  EXTNAME(FTOPY1APD)
      ** Payment Extension Details layout
 
     D FTOPAY3B      E DS                  EXTNAME(FTOPY5PD)
      ** Payment Extension Details layout
 
     D FTOPAY3C      E DS                  EXTNAME(FTOPY6PD)
      ** Payment Extension Details layout
 
     D FTEOPY1       E DS                  EXTNAME(FTEOPY1PD)
      ** Error Indicators (Screen one)
     D FTEOPY2       E DS                  EXTNAME(FTEOPY2PD)
      ** Error Indicators (Screen two)
     D FTEOPY3       E DS                  EXTNAME(FTEOPY3PD)
      ** Error Indicators (Screen three)
     D FTEOPY4       E DS                  EXTNAME(FTEOPY4PD)
      ** Error Indicators (Screen four)
 
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
      ** Validation Work Fields
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
 
     D**FuncText       DS            56                                                       CER030
     D  FuncText       DS            76                                                       CER030
     D  F3F12text              1     19
     D  F4text                20     29
     D  F16text               30     40
     D  F19text               41     56
     D  F19text1              41     76                                                       CER030
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D #MSDTA          S            132
     D #MSTX1          S            132
     D #MSTX2          S            512
     D PRTCD           S              7                                                       219241
     D POPTN           S              7                                                       219241
      *                                                                                       CER030
      ** Fields added for CER030                                                              CER030
      *                                                                                       CER030
     D PSard           S              6A                                                      CER030
     D CER031          S              1A                                                      CER030
     D CER030          S              1A                                                      CER030
     D CGL013          S              1A                                                      CER030
      *                                                                                       CFT120
      ** CFT120 switchable field                                                              CFT120
      *                                                                                       CFT120
     D CFT120          S              1A                                                      CFT120
 
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
 
      ** Main processing
 
     C                   ExSr      SrMain
 
      ** Command F3 pressed, exit
 
     C**********         If        @INKC = *On                                              MD027047
     C                   Eval      *INLR = *On
     C**********         EndIf                                                              MD027047
 
     C**********         Return                                                             MD027047
 
      *****************************************************************
      /Title Sr/SrMain
      *****************************************************************
      *                                                               *
      * SR/SrMain    - Main processing                                *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrMain        BegSr
 
      ** Move 'OK' flags into array for checking
 
     C                   MoveA     FTEOPY4       @EI
 
      ** Set screen error indicators according to status of 'OK' flags
 
     C                   Z-Add     1             C                 2 0
     C                   Z-Add     10            E                 2 0
 
     C                   DoU       C > 60
     C                   If        (@EI(C) = 'N') Or (@EI(C) = 'W')
     C                   Eval      *IN(E) = *On
     C                   EndIf
     C                   Eval      C = C + 1
     C                   Eval      E = E + 1
     C                   Enddo
 
      *                                                                                       CFT120
      ** Set error code for OP Template screen for Charges to Debit                           CFT120
      ** Currency (DDCDRC)                                                                    CFT120
      *                                                                                       CFT120
     C                   If        CFT120 = 'Y'                                               CFT120
     C                   If        OKCdrc = 'N'                                               CFT120
     C                   Eval      *IN65  = *On                                               CFT120
     C                   EndIf                                                                CFT120
     C                   EndIf                                                                CFT120
      *                                                                                       CFT120
      ** Set up the payment reference to be used by the message handler
 
     C                   Eval      TranRef = SPREF
     C                   Eval      ActionCode = SACTION
 
      **---------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
      **---------------------------------------------------------------
 
      ** Position cursor on action code if it is blank
 
     C     SAction       Comp      *BLANK                                 68
 
      ** Enable detail fields (all fields except action code & payment
      ** Reference
 
     C     @EDTFD        Comp      'Y'                                7070
 
      ** Enable function keys
 
     C     @EINKD        Comp      'Y'                                    77
     C     @EINKQ        Comp      'Y'                                    78
     C     @EINKT        Comp      'Y'                                    75
 
      ** Set up function key footer text
 
     C                   Eval      SCCMDTXT = *Blanks
     C                   Eval      %SUBST(SCCMDTXT:1:19) = F3F12text
     C                   If        @EINKD = 'Y'
     C                   Eval      %SUBST(SCCMDTXT:60:9) = F4text
     C                   Endif
     C                   If        @EINKQ = 'Y'
     C                   Eval      %SUBST(SCCMDTXT:70:10) = F16text
     C                   Endif
      *                                                                                       CER030
     C                   IF        (@EINKT = 'Y') AND (CER030 ='Y' OR                         CER030
     C                             CER031 = 'Y' OR CGL013 ='Y')                               CER030
     C                   EVAL      %SUBST(SCCMDTXT:41:37) = F19text1                          CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   If        (@EINKT = 'Y') And (BGN0ST = 'Y')
     C                   Eval      %SUBST(SCCMDTXT:41:16) = F19text
     C                   Endif
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
 
      ** Default output fields
 
     C                   ExSr      SrDftOFlds
 
      ** Write message subfile, details and footer screen
 
     C                   Time                    DDTime
      *                                                                         CFT009
      ** Save Charges to the debit of field - we need to know if it             CFT009
      ** changes and we need to re-call ft000981 in validation modules          CFT009
      ** if it has.                                                             CFT009
     C     *LIKE         DEFINE    SCDRO         PrvCDRO                        CFT009
     C                   EVAL      PrvCDRO = SCDRO                              CFT009
     C                   IF        CFT120 = 'Y'                                               CFT120
     C     *LIKE         DEFINE    SCDRC         PrvCDRC                                      CFT120
     C                   EVAL      PrvCDRC = SCDRC                                            CFT120
     C                   ENDIF                                                                CFT120
                                                                                CFT009
     C                   Write     FTOPAY4S0
     C                   Write     FTOPAY4D1
     C                   Write     FTOPAY4F1
 
      ** Read details screen
 
     C                   If        WriteOnly <> 'Y'
     C                   Read      FTOPAY4D1                              01
     C                   EndIf
      *                                                                         CFT009
      ** Check if new value entered for Charges to the debit of                 CFT009
     C                   IF        PrvCDRO <> SCDRO                             CFT009
     C                             and CFT009 = 'Y'                             CFT009
     C                             Or  PrvCDRC <> SCDRC                                       CFT120
     C                             and CFT009 = 'Y' and CFT120 = 'Y'                          CFT120
     C                   EVAL      PCDROCHG = 'Y'                               CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      PCDROCHG = *blanks                           CFT009
     C                   ENDIF                                                  CFT009
 
      ** Clear message subfile
 
     C                   Call      'ZA0250'
 
      ** Set screen error indicators off
 
     C                   MoveA     @Z0           *IN(10)
 
      ** Set return keys
 
     C                   Move      *INKC         @INKC
     C                   Move      *INKD         @INKD
     C                   Move      *INKL         @INKL
     C                   Move      *INKQ         @INKQ
     C                   Move      *INKT         @INKT                          CFT014
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrDftOFlds
      *****************************************************************
      *                                                               *
      * SR/SrDftOFlds - Default Output Fields                         *
      *                                                               *
      * Called By: SrMain subroutine                                  *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SrDftOFlds    BegSr
 
      ** Details of Charges
 
     C                   If        SDTCH = *Blanks
                                                                                              219241
      ** If CFT014 is installed, retrieve the default value from the                          219241
      ** Message Management ICD                                                               219241
                                                                                              219241
     C                   IF        CFT014 = 'Y'                                               219241
     C                   EVAL      SDTCH = ENDCHG                                             219241
     C                   ELSE                                                                 219241
     C                   Eval      SDTCH = 'BEN'
     C/COPY WNCPYSRC,FTOPA4XC01
     C                   ENDIF                                                                219241
                                                                                              219241
     C                   EndIf
 
      ** Currencies
 
     C                   Eval      SCCY1 = @CCCY
     C                   Eval      SCCY2 = @CCCY
     C                   Eval      SCCY3 = @CCCY
     C                   Eval      SCCY4 = @CCCY
     C                   Eval      SCCY5 = @CCCY
     C                   Eval      SCCY6 = @CCCY
 
     C                   If        @01494 = 'Y'
     C                   Eval      SCCY7 = @CCCY
     C                   EndIf
     C                   If        @01499 = 'Y'
     C                             AND CFT009 = 'N' OR CFT010 = 'Y'             CFT009
     C                   Eval      SCCY8 = @CCCY
     C                   EndIf
                                                                                CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
     C                   EVAL      CCY9 = @CCCY                                 CFT009
     C                   EVAL      CCY10 = @CCCY                                CFT009
     C                   EVAL      CCY11 = @CCCY                                CFT009
     C                   EVAL      CCY12 = @CCCY                                CFT009
     C                   EVAL      CCY13 = @CCCY                                CFT009
     C                   EVAL      CCY14 = @CCCY                                CFT009
     C                   EVAL      RCY9 = @RCCY                                 CFT009
     C                   EVAL      RCY10 = @RCCY                                CFT009
     C                   EVAL      RCY11 = @RCCY                                CFT009
     C                   EVAL      RCY12 = @RCCY                                CFT009
     C                   EVAL      RCY13 = @RCCY                                CFT009
     C                   EVAL      RCY14 = @RCCY                                CFT009
     C                   ENDIF                                                  CFT009
 
     C                   Eval      SRCY1 = @RCCY
     C                   Eval      SRCY2 = @RCCY
     C                   Eval      SRCY3 = @RCCY
     C                   Eval      SRCY4 = @RCCY
     C                   Eval      SRCY5 = @RCCY
     C                   Eval      SRCY6 = @RCCY
 
     C                   If        @01494 = 'Y'
     C                   Eval      SRCY7 = @RCCY
     C                   EndIf
     C                   If        @01499 = 'Y'
     C                             AND CFT009 = 'N' OR CFT010 = 'Y'             CFT009
     C                   Eval      SRCY8 = @RCCY
     C                   EndIf
 
      ***Pay*currency*equivalent*of*charge*****************************              197845 AR898162
      *                                                                                      197845
     C**********         Eval      @AJCD = @CCCY                                     197845 AR898162
     C**********         CallB     'AOCURRR0'                                        197845 AR898162
     C**********         Parm      *Blank        @RTCD                               197845 AR898162
     C**********         Parm      '*KEY   '     @OPTN                               197845 AR898162
     C**********         Parm                    @AJCD                               197845 AR898162
     C*****SDCURR        Parm      SDCURR        DSSDY                               197845 AR898162
      *                                                                                      197845
      ***Transfer*commission*amount*(pay*ccy*equiv)********************              197845 AR898162
      *                                                                                      197845
     C**********         Eval      STRCD = *Blanks                                   197845 AR898162
     C**********         If        @TRCD <> *Zero                                    197845 AR898162
     C**********         Z-Add     @TRCD         @@AMTW                              197845 AR898162
     C**********         Else                                                        212647 MD020737
     C**********         Z-Add     *Zero         @@AMTW                              212647 MD020737
     C**********         Endif                                                       212647 MD020737
     C**********         Z-Add     A6NBDP        @@QECN                              197845 AR898162
     C**********         ExSr      SrFmtAmt                                          197845 AR898162
     C**********         Move      @@AMTD        STRCD                               197845 AR898162
     C**********         EndIf                                                         197845 212647
     C**********         ENDIF                                                     MD020737 AR898162
      *                                                                                      197845
      ** Default charge currency amounts
 
     C                   Eval      @AJCD = @RCCY
     C                   CallB     'AOCURRR0'
     C                   Parm      *Blank        @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    @AJCD             3
     C     SDCURR        Parm      SDCURR        DSSDY
 
      ** Transfer commission amount (charges currency
 
     C                   Eval      STRCM = *Blanks
     C                   If        @TRCM <> *Zero
     C                   Z-Add     @TRCM         @@AMTW
     C                   Else                                                                 212647
     C                   Z-Add     *Zero         @@AMTW                                       212647
     C                   Endif                                                                212647
     C                   Z-Add     A6NBDP        @@QECN
     C                   ExSr      SrFmtAmt
     C                   Move      @@AMTD        STRCM
     C**********         EndIf                                                                212647
 
      ** Telex charge (charges currency)
 
     C                   Eval      STXCH = *Blanks
     C                   If        @TXCH <> *Zero
     C                   Z-Add     @TXCH         @@AMTW
     C                   Else                                                                 212647
     C                   Z-Add     *Zero         @@AMTW                                       212647
     C                   Endif                                                                212647
     C                   Z-Add     A6NBDP        @@QECN
     C                   ExSr      SrFmtAmt
     C                   Move      @@AMTD        STXCH
     C**********         EndIf                                                                212647
 
      ** Cheque Charge (charges currency)
 
     C                   Eval      SCQCH = *Blanks
     C                   If        @CQCH <> *Zero
     C                   Z-Add     @CQCH         @@AMTW
     C                   Else                                                                 212647
     C                   Z-Add     *Zero         @@AMTW                                       212647
     C                   Endif                                                                212647
     C                   Z-Add     A6NBDP        @@QECN
     C                   ExSr      SrFmtAmt
     C                   Move      @@AMTD        SCQCH
     C**********         EndIf                                                                212647
 
      ** Costs abroad (charges currency)
 
     C                   Eval      SCSTA = *Blanks
     C                   If        @CSTA <> *Zero
     C                   Z-Add     @CSTA         @@AMTW
     C                   Else                                                                 212647
     C                   Z-Add     *Zero         @@AMTW                                       212647
     C                   Endif                                                                212647
     C                   Z-Add     A6NBDP        @@QECN
     C                   ExSr      SrFmtAmt
     C                   Move      @@AMTD        SCSTA
     C**********         EndIf                                                                212647
 
      ** SWIFT priority charge (charges currency)
 
     C                   Eval      SSPCH = *Blanks
     C                   If        @SPCH <> *Zero
     C                   Z-Add     @SPCH         @@AMTW
     C                   Else                                                                 212647
     C                   Z-Add     *Zero         @@AMTW                                       212647
     C                   Endif                                                                212647
     C                   Z-Add     A6NBDP        @@QECN
     C                   ExSr      SrFmtAmt
     C                   Move      @@AMTD        SSPCH
     C**********         EndIf                                                                212647
 
      ** Miscellaneous charge (charges currency)
 
     C                   Eval      SMSCH = *Blanks
     C                   If        @MSCH <> *Zero
     C                   Z-Add     @MSCH         @@AMTW
     C                   Else                                                                 212647
     C                   Z-Add     *Zero         @@AMTW                                       212647
     C                   Endif                                                                212647
     C                   Z-Add     A6NBDP        @@QECN
     C                   ExSr      SrFmtAmt
     C                   Move      @@AMTD        SMSCH
     C**********         EndIf                                                                212647
 
      ** Miscellaneous charge (charges currency)
 
     C                   If        @01494 = 'Y'
     C                   Eval      SCHCM = *Blanks
     C                   If        @CHCM <> *Zero
     C                   Z-Add     @CHCM         @@AMTW
     C                   Else                                                                 212647
     C                   Z-Add     *Zero         @@AMTW                                       212647
     C                   Endif                                                                212647
     C                   Z-Add     A6NBDP        @@QECN
     C                   ExSr      SrFmtAmt
     C                   Move      @@AMTD        SCHCM
     C**********         EndIf                                                                212647
     C                   EndIf
 
     C                   IF        CFT009 = 'Y'                                 CFT009
                                                                                CFT009
      ** SWIFT standard charge (charges currency)                               CFT009
                                                                                CFT009
     C                   EVAL      STCH = *BLANKS                               CFT009
     C                   IF        @SSCH <> *ZERO                               CFT009
     C                   Z-ADD     @SSCH         @@AMTW                         CFT009
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @@AMTW                                       212647
     C                   ENDIF                                                                212647
     C                   Z-ADD     A6NBDP        @@QECN                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      @@AMTD        STCH                           CFT009
     C**********         ENDIF                                                  CFT009        212647
                                                                                CFT009
      ** Miscellaneous charge 1 (charges currency)                              CFT009
                                                                                CFT009
     C                   EVAL      M1CH = *BLANKS                               CFT009
     C                   IF        @M1CH <> *ZERO                               CFT009
     C                   Z-ADD     @M1CH         @@AMTW                         CFT009
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @@AMTW                                       212647
     C                   ENDIF                                                                212647
     C                   Z-ADD     A6NBDP        @@QECN                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      @@AMTD        M1CH                           CFT009
     C**********         ENDIF                                                         CFT009 212647
                                                                                CFT009
      ** Miscellaneous charge 2 (charges currency)                              CFT009
                                                                                CFT009
     C                   EVAL      M2CH = *BLANKS                               CFT009
     C                   IF        @M2CH <> *ZERO                               CFT009
     C                   Z-ADD     @M2CH         @@AMTW                         CFT009
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @@AMTW                                       212647
     C                   ENDIF                                                                212647
     C                   Z-ADD     A6NBDP        @@QECN                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      @@AMTD        M2CH                           CFT009
     C**********         ENDIF                                                         CFT009 212647
                                                                                CFT009
      ** Miscellaneous charge 3 (charges currency)                              CFT009
                                                                                CFT009
     C                   EVAL      M3CH = *BLANKS                               CFT009
     C                   IF        @M3CH <> *ZERO                               CFT009
     C                   Z-ADD     @M3CH         @@AMTW                         CFT009
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @@AMTW                                       212647
     C                   ENDIF                                                                212647
     C                   Z-ADD     A6NBDP        @@QECN                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      @@AMTD        M3CH                           CFT009
     C**********         ENDIF                                                         CFT009 212647
                                                                                CFT009
      ** Miscellaneous charge 4 (charges currency)                              CFT009
                                                                                CFT009
     C                   EVAL      M4CH = *BLANKS                               CFT009
     C                   IF        @M4CH <> *ZERO                               CFT009
     C                   Z-ADD     @M4CH         @@AMTW                         CFT009
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @@AMTW                                       212647
     C                   ENDIF                                                                212647
     C                   Z-ADD     A6NBDP        @@QECN                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      @@AMTD        M4CH                           CFT009
     C**********         ENDIF                                                         CFT009 212647
                                                                                CFT009
      ** Miscellaneous charge 5 (charges currency)                              CFT009
                                                                                CFT009
     C                   EVAL      M5CH = *BLANKS                               CFT009
     C                   IF        @M5CH <> *ZERO                               CFT009
     C                   Z-ADD     @M5CH         @@AMTW                         CFT009
     C                   ELSE                                                                 212647
     C                   Z-ADD     *ZERO         @@AMTW                                       212647
     C                   ENDIF                                                                212647
     C                   Z-ADD     A6NBDP        @@QECN                         CFT009
     C                   EXSR      SRFMTAMT                                     CFT009
     C                   MOVE      @@AMTD        M5CH                           CFT009
     C**********         ENDIF                                                         CFT009 212647
     C                   ENDIF                                                  CFT009
 
      ** Total charge (charges currency)
 
     C                   Eval      SVATT = *Blanks
     C                   If        @VATT <> *Zero
     C                   Z-Add     @VATT         @@AMTW
     C                   Else                                                                 212647
     C                   Z-Add     *Zero         @@AMTW                                       212647
     C                   Endif                                                                212647
     C                   Z-Add     A6NBDP        @@QECN
     C                   ExSr      SrFmtAmt
     C                   Move      @@AMTD        SVATT
     C**********         EndIf                                                                212647
 
      ** Get input currency decimal places
 
     C                   Eval      @AJCD = @CCCY
     C                   CallB     'AOCURRR0'
     C                   Parm      *Blank        @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    @AJCD             3
     C     SDCURR        Parm      SDCURR        DSSDY
 
      ** Total charge (input currency)
 
     C                   Eval      SVATD = *Blanks
     C                   If        @VATD <> *Zero
     C                   Z-Add     @VATD         @@AMTW
     C                   Else                                                                 212647
     C                   Z-Add     *Zero         @@AMTW                                       212647
     C                   Endif                                                                212647
     C                   Z-Add     A6NBDP        @@QECN
     C                   ExSr      SrFmtAmt
     C                   Move      @@AMTD        SVATD
     C**********         EndIf                                                                212647
 
      ** Default Receiver's Charges currency to pay currency
 
     C                   If        @CFT014 = 'Y'
     C                   Eval      SRCCY = SPCCY
     C                   EndIf
 
      ** Miscellaneous Charge descriptions                                      CFT009
                                                                                CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
                                                                                CFT009
     C     M1CDE         CHAIN     FTPCHGL0                                     CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
     C                   EVAL      M1DESC = CHDESC                              CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      M1DESC = DESC(1)                             CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C     M2CDE         CHAIN     FTPCHGL0                                     CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
     C                   EVAL      M2DESC = CHDESC                              CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      M2DESC = DESC(2)                             CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C     M3CDE         CHAIN     FTPCHGL0                                     CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
     C                   EVAL      M3DESC = CHDESC                              CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      M3DESC = DESC(3)                             CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C     M4CDE         CHAIN     FTPCHGL0                                     CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
     C                   EVAL      M4DESC = CHDESC                              CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      M4DESC = DESC(4)                             CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C     M5CDE         CHAIN     FTPCHGL0                                     CFT009
                                                                                CFT009
     C                   IF        %FOUND                                       CFT009
     C                   EVAL      M5DESC = CHDESC                              CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      M5DESC = DESC(5)                             CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
     C                   EndSr
 
      *****************************************************************
      /Title Sr/SrFmtAmt
      *****************************************************************
      *                                                               *
      * SR/SrFmtAmt   - Format Amount for Display                     *
      *                                                               *
      * Called By: SrDftOFlds subroutine                              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SrFmtAmt      BegSr
 
      ** Use ZA0920 to format the amount
 
     C                   CallB     'ZA0920'
     C                   Parm      *BLANK        @@RETC           10
     C                   Parm                    @@AMTW           13 0
     C                   Parm                    @@QECN            1 0
     C                   Parm      '.'           BNDCSP            1
     C                   Parm      *BLANK        @@AMTD           14
 
     C                   EndSr
 
      *****************************************************************
      /Title Sr/*InzSr
      *****************************************************************
      *                                                               *
      * SR/*InzSr     - Initial Processing                            *
      *                                                               *
      * Called By: Automatically executed when program starts         *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     *InzSr        BegSr
 
      ** Receive input parameters
 
     C     *Entry        Plist
     C                   Parm                    RetCodeIn
     C                   PARM                    FTOPAY1
     C                   PARM                    FTOPAY1X
     C                   PARM                    FTOPAY2a
     C                   PARM                    FTOPAY2b
     C                   PARM                    FTOPAY3
     C                   PARM                    FTOPAY3B
     C                   PARM                    FTOPAY3C
     C                   PARM                    DDSTS            24
     C                   PARM                    FTEOPY1
     C                   PARM                    FTEOPY2
     C                   PARM                    FTEOPY3
     C                   PARM                    FTEOPY4
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
     C                   PARM                    @EINKD            1
     C                   PARM                    @EINKQ            1
     C                   PARM                    @EINKT            1
     C                   PARM                    @INKC             1
     C                   PARM                    @INKD             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKQ             1
     C                   PARM                    @INKT             1            CFT014
     C                   PARM                    WriteOnly         1
     C                   PARM      @#RWCL        CursorLoc         5 0
     C                   PARM                    Val@Fields
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
 
      ** Access Bank Details via Access Object AOBANKR0
 
     C                   Call      'AOBANKR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C     @RTCD         IfNe      *BLANKS
     C                   MoveL     'SDBANKPD'    DBFILE
     C                   Z-Add     1             DBASE
     C                   MoveL     @Optn         DBKEY
     C                   Exsr      *PSSR
     C                   EndIf
 
      ** Access General Ledger details
 
     C**********         Call      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C*****SDGELR        Parm      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
     C     @RTCD         IfNe      *Blanks
     C                   Movel     'SDGELRPD'    DBFILE
     C                   Z-Add     2             DBASE
     C                   Movel     @OPTN         DBKEY
     C                   ExSr      *PSSR
     C                   EndIf
 
      ** Access Module Details
 
     C                   Call      'AOMMODR0'
     C                   Parm      *Blanks       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C     @RTCD         IfNe      *Blanks
     C                   Movel     'SDMMODPD'    DBFILE
     C                   Z-Add     3             DBASE
     C                   Movel     @Optn         DBKEY
     C                   ExSr      *PSSR
     C                   EndIf
 
      ** Check if BLI Funds Transfer Enhancement is installed
 
     C                   Call      'AOSARDR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01494'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        (@RTCD <> *Blanks) And (@RTCD <> '*NRF   ')
     C                   Movel     'SCSARDPD'    DBFILE
     C                   Z-Add     4             DBASE
     C                   Movel     'S01494'      DBKEY
     C                   ExSr      *PSSR
     C                   EndIf
 
     C                   If        @RTCD = *BLANKS
     C                   Movel     'Y'           S01494            1
     C                   Else
     C                   Movel     'N'           S01494
     C                   EndIf
 
      ** Check if BLI V.A.T Processing is installed
 
     C                   Call      'AOSARDR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01499'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        (@RTCD <> *Blanks) And (@RTCD <> '*NRF   ')
     C                   Movel     'SCSARDPD'    DBFILE
     C                   Z-Add     5             DBASE
     C                   Movel     'S01499'      DBKEY
     C                   ExSr      *PSSR
     C                   EndIf
 
     C                   If        @RTCD = *BLANKS
     C                   Movel     'Y'           S01499            1
     C                   Else
     C                   Movel     'N'           S01499
     C                   EndIf
 
      ** Check if MT103 enhancement is installed
 
     C                   Call      'AOSARDR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT014'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        (@RTCD <> *Blanks) And (@RTCD <> '*NRF   ')
     C                   Movel     'SCSARDPD'    DBFILE
     C                   Z-Add     6             DBASE
     C                   Movel     'CFT014'      DBKEY
     C                   ExSr      *PSSR
     C                   EndIf
 
     C                   If        @RTCD = *BLANKS
     C                   Movel     'Y'           CFT014            1
     C                   Else
     C                   Movel     'N'           CFT014
     C                   EndIf
                                                                                              219241
      ** Get Message Management Details if CFT014 is installed.                               219241
                                                                                              219241
     C                   IF        CFT014 = 'Y'                                               219241
                                                                                              219241
     C                   CALL      'AOMGMER1'                                                 219241
     C                   PARM      *BLANKS       PRTCD                                        219241
     C                   PARM      '*FIRST'      POPTN                                        219241
     C     SDMGME        PARM      SDMGME        DSSDY                                        219241
                                                                                              219241
     C                   IF        PRTCD <> *BLANKS                                           219241
     C                   EVAL      DBFILE = 'SDMGMEPD'                                        219241
     C                   EVAL      DBASE = 9                                                  219241
     C                   EVAL      DBKEY = POPTN                                              219241
     C                   EXSR      *PSSR                                                      219241
     C                   ENDIF                                                                219241
                                                                                              219241
     C                   ENDIF                                                                219241
                                                                                CFT009
      ** Access SAR details file to determine if Fees & Charges feature         CFT009
      ** is switched on.                                                        CFT009
                                                                                CFT009
     C                   CALL      'AOSARDR0'                                   CFT009
     C                   PARM      *Blanks       @RTCD                          CFT009
     C                   PARM      '*VERIFY'     @OPTN                          CFT009
     C                   PARM      'CFT009'      @SARD                          CFT009
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT009
                                                                                CFT009
     C                   IF        (@RTCD <> *BLANKS) And                       CFT009
     C                             (@RTCD <> '*NRF   ')                         CFT009
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT009
     C                   Z-ADD     7             DBASE                          CFT009
     C                   MOVEL     'CFT009'      DBKEY                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        @RTCD = *BLANKS                              CFT009
     C                   MOVEL     'Y'           CFT009            1            CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           CFT009                         CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ** Access SAR details file to determine if Fees & Charges feature         CFT009
      ** (VAT component) is switched on.                                        CFT009
                                                                                CFT009
     C                   CALL      'AOSARDR0'                                   CFT009
     C                   PARM      *Blanks       @RTCD                          CFT009
     C                   PARM      '*VERIFY'     @OPTN                          CFT009
     C                   PARM      'CFT010'      @SARD                          CFT009
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT009
                                                                                CFT009
     C                   IF        (@RTCD <> *BLANKS) And                       CFT009
     C                             (@RTCD <> '*NRF   ')                         CFT009
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT009
     C                   Z-ADD     8             DBASE                          CFT009
     C                   MOVEL     'CFT010'      DBKEY                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        @RTCD = *BLANKS                              CFT009
     C                   MOVEL     'Y'           CFT010            1            CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           CFT010                         CFT009
     C                   ENDIF                                                  CFT009
     C/COPY WNCPYSRC,FTOPA4XC02
 
      *                                                                                       CER030
      ** Check the switchable feature CER031                                                  CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRTCD                                        CER030
     C                   PARM      '*VERIFY'     POPTN                                        CER030
     C                   PARM      'CER031'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER031 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 010                                                CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER031 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check the switchable feature CER030                                                  CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRTCD                                        CER030
     C                   PARM      '*VERIFY'     POPTN                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 011                                                CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER030 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check the switchable feature CGL013                                                  CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRTCD                                        CER030
     C                   PARM      '*VERIFY'     POPTN                                        CER030
     C                   PARM      'CGL013'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CGL013 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF'                                            CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 012                                                CER030
     C                   EVAL      DBKEY = '*VERIFY'                                          CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CGL013 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CFT120
      ** Check the switchable feature CFT120                                                  CFT120
      *                                                                                       CFT120
     C                   CALLB     'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       PRTCD                                        CFT120
     C                   PARM      '*VERIFY'     POPTN                                        CFT120
     C                   PARM      'CFT120'      PSard                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        PRtcd = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   EVAL      *IN86 = *ON                                                CFT120
     C                   ELSE                                                                 CFT120
      *                                                                                       CFT120
     C                   IF        PRtcd <> '*NRF'                                            CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBASE = 013                                                CFT120
     C                   EVAL      DBKEY = 'CFT120'                                           CFT120
     C                   EXSR      *PSSR                                                      CFT120
      *                                                                                       CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   EVAL      *IN86 = *OFF                                               CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
      ** Retrieve the text for footer function keys using MEC1150
 
     C                   IF        (CER030 = 'Y' OR CER031 ='Y' OR                            CER030
     C                             CGL013 = 'Y')                                              CER030
     C                   EVAL      #MSGID = 'FTM5053'                                         CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      #MSGID = 'FTM2618'                                         CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   Call      'MEC1150'                            9090
     C**********         Parm      'FTM2618'     #MSGID                                       CER030
     C                   Parm                    #MSGID                                       CER030
     C                   Parm      'FTUSRMSG'    #MsgFile
     C                   Parm                    #MSDTA
     C                   Parm      *Blanks       #MSTX1
     C                   Parm      *Blanks       #MSTX2
 
     C                   Movel     #MSTX1        FuncText
 
      ** Message subfile control
 
     C                   Move      True          *IN97
     C                   Movel     '*'           DDPGMQ
 
      ** Set screen protect/non-display indicators
 
     C                   If        S01494 = 'Y'
     C                   Move      True          *IN84
     C                   Else
     C                   Move      False         *IN84
     C                   EndIf
 
     C                   If        S01499 = 'Y'
     C                   Move      True          *IN85
     C                   Else
     C                   Move      False         *IN85
     C                   EndIf
 
     C                   If        CFT014 = 'Y'
     C                   Move      True          *IN87
     C                   Else
     C                   Move      False         *IN87
     C                   EndIf
                                                                                CFT009
      ** Display Extra charges                                                  CFT009
                                                                                CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
     C                   EVAL      *IN71 = *ON                                  CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      *IN71 = *OFF                                 CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ** Display VAT component of the extra charges                             CFT009
                                                                                CFT009
     C                   IF        CFT010 = 'Y'                                 CFT009
     C                   EVAL      *IN72 = *ON                                  CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      *IN72 = *OFF                                 CFT009
     C                   ENDIF                                                  CFT009
 
      **---------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for FT *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     C/COPY FTCPYSRC,MSGHNDDATA
     C/COPY WNCPYSRC,FTH00482
      **---------------------------------------------------------------
 
     C                   EndSr
 
      *****************************************************************
      /EJECT
      **---------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP2
      **---------------------------------------------------------------
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
(c) Misys International Banking Systems Ltd. 2001
**  @Z0
000000000000000000000000000000000000000000000000000000000000
**  DESC
Miscellaneous Charge 1                                                    CFT009
Miscellaneous Charge 2                                                    CFT009
Miscellaneous Charge 3                                                    CFT009
Miscellaneous Charge 4                                                    CFT009
Miscellaneous Charge 5                                                    CFT009
