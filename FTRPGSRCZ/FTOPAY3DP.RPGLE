     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments charges/comms display')     *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAY3DP  - Outgoing Payments Charges/Commissions Display   *
      *                                                               *
      *  Function:  This module displays the charges & commissions    *
      *     details of the Outgoing Payments screen input function.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD027047           Date 19Aug14               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 250600             Date 07Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 09Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 03Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 11May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027047 - Avoid HATS issue with redisplaying previous screen*
      *             on the stack. End program with SETON LR with no   *
      *             RETURN.                                           *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - BIC Database Plus Integration                       *
      *  CFT004 - Recompile, IBAN - International Bank Account Number *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     F***FTOPAY3DF*CF***E             WORKSTN                                   CFT007
     FFTOPAY3DF CF   E             WORKSTN INFDS(INFDS#)                        CFT007
                                                                                CFT007
      ** Table of field numbers and names                                       CFT007
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)                         CFT007
                                                                                CFT007
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       68  Position cursor on action code (if it is blank)     *
      *       69  Protect deal key fields (action code & deal number) *
      *       70  Protect deal detail fields                          *
      ********75**Display*Margin*Info*fields***************************         CFT014
      *       77  Enable CF04, BIC DB+ Prompt                         *         CFT007
      *       78  Enable CF16, BIC DB+ Search                         *         CFT007
      *       79  Highlight deal status                               *
      *                                                               *
      *       80  Not multibranching                                  *
      ********84**SAR*feature*S01494*switched*ON***********************         CFT014
      ********85**SAR*feature*S01499*switched*ON***********************         CFT014
      *       87  CFT014 switchable enhancement is installed          *         CFT014
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
      ********************************************************************
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **---------------------------------------------------------------         CFT007
      ** The following /COPY line includes all the definitions of the error     CFT007
      ** arrays, including the named constant giving the size of                CFT007
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires    CFT007
      ** STD_D_SPEC.                                                            CFT007
     D/COPY ZACPYSRC,FVAL_ARRAY                                                 CFT007
      **---------------------------------------------------------------         CFT007
                                                                                CFT007
      **------------------------------------------------------------------------CFT007
      ** The following /COPY line includes the definitions for error and        CFT007
      ** warning message arrays.                                                CFT007
     D/COPY ZACPYSRC,APICTLARR                                                  CFT007
      **------------------------------------------------------------------------CFT007
                                                                                CFT007
      **------------------------------------------------------------------------CFT007
      ** The following /COPY line includes the definitions for fields           CFT007
      ** required by the message handler.                                       CFT007
     D/COPY ZACPYSRC,MSGHNDDCL                                                  CFT007
      **------------------------------------------------------------------------CFT007
                                                                                CFT007
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
 
     D @EI             S              1    DIM(60)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS
                                                                                CFT014
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CFT014
      ** External DS for Midas Switchable Features details                      CFT014
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D FTOPAY1       E DS                  EXTNAME(FTOPY1PD)
      ** Screen fields (Initial Screen)
     D*FTOPAY2a**    E DS                  EXTNAME(FTOPY2PD)                    CFT014
      ***Screen*fields*(Second*Screen)*********************************         CFT014
     D*FTOPAY2b**    E DS                  EXTNAME(FTOPY3PD)                    CFT014
      ***Screen*fields*(Second*Screen)*********************************         CFT014
     D FTOPAY3       E DS                  EXTNAME(FTOPY4PD)
      ** Screen fields (Charge & Commissions Screen)
                                                                                CFT014
     D FTOPAY1X      E DS                  EXTNAME(FTOPY1APD)                   CFT014
      ** Payment Extension Details layout                                       CFT014
                                                                                CFT014
     D FTOPAY3B      E DS                  EXTNAME(FTOPY5PD)                    CFT014
      ** Payment Extension Details layout                                       CFT014
 
     D FTEOPY1       E DS                  EXTNAME(FTEOPY1PD)
      ** Error Indicators (Screen one)
     D FTEOPY2       E DS                  EXTNAME(FTEOPY2PD)
      ** Error Indicators (Screen two)
     D FTEOPY3       E DS                  EXTNAME(FTEOPY3PD)
      ** Error Indicators (Screen three)
 
      * Validation Work Fields
     D*Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)                  CFT014
 
 
     D                 DS
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)                     CFT007
      * Display file information data structure                                 CFT007
                                                                                CFT007
     D  FuncText       DS            39                                         CFT007
     D  F3F12text              1     19                                         CFT007
     D  F4text                20     28                                         CFT007
     D  F16text               29     39                                         CFT007
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D #MSDTA          S            132                                         CFT007
     D #MSTX1          S            132                                         CFT007
     D #MSTX2          S            512                                         CFT007
                                                                                CFT007
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
      * Main processing
      *
     C                   EXSR      MAIN
      *
      * Return
      *
     C*****@INKC         IFEQ      '1'                                                      MD027047
     C                   SETON                                        LR
     C**********         END                                                                MD027047
     C**********         RETURN                                                             MD027047
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C* MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      * MOVE 'OK' FLAGS INTO ARRAY (FOR CHECKING)
      *
     C                   MOVEA     FTEOPY3       @EI
      *
      * SET SCREEN ERROR INDICATORS ACCORDING TO STATUS OF 'OK' FLAGS
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUGT     60
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
                                                                                CFT007
      ** Set up the payment reference to be used by the message handler         CFT007
     C                   EVAL      TranRef = SPREF                              CFT007
     C                   EVAL      ActionCode = SACTION                         CFT007
                                                                                CFT007
      **------------------------------------------------------------------------CFT007
      ** The following /COPY line includes processing for the error and         CFT007
      ** warning messages.                                                      CFT007
     D/COPY ZACPYSRC,MSGHNDDSP1                                                 CFT007
      **------------------------------------------------------------------------CFT007
      *
      ***DO*WHILE*ERROR*MESSAGES FOUND                                          CFT007
      ***WRITE*ERROR*MESSAGES (WITH OR WITHOUT DATA) TO SUBFILE                 CFT007
      *******************                                                       CFT007
     C*******************Z-ADD     1             C                              CFT007
     C*****C*************DOWLE     ArrayMax                                     CFT007
     C*****FldNameArr(C)*ANDNE     *BLANKS                                      CFT007
     C*******************MOVEL     MsgIdArr(C)   @MSGID            7            CFT007
     C*******************MOVEL     MsgDtaArr(C)  @MSGDT           45            CFT007
     C*****@MSGDT********IFEQ      *BLANKS                                      CFT007
     C*******************EXSR      ERRWOD                                       CFT007
     C*******************ELSE                                                   CFT007
     C*******************EXSR      ERRWID                                       CFT007
     C*******************END                                                    CFT007
     C*******************ADD       1             C                              CFT007
     C*******************END                                                    CFT007
      *******************                                                       CFT007
      ***DO*WHILE*WARNING MESSAGES FOUND                                        CFT007
      ***WRITE*WARNING*MESSAGES (WITH OR WITHOUT DATA) TO SUBFILE               CFT007
      *******************                                                       CFT007
     C*******************Z-ADD     1             C                              CFT007
     C*****C*************DOWLE     ArrayMax                                     CFT007
     C*****WFldNamArr(C)*ANDNE     *BLANKS                                      CFT007
     C*******************MOVEL     WMsgIdArr(C)  @MSGID            7            CFT007
     C*******************MOVEL     WMsgDtaArr(C) @MSGDT           45            CFT007
     C*****@MSGDT********IFEQ      *BLANKS                                      CFT007
     C*******************EXSR      ERRWOD                                       CFT007
     C*******************ELSE                                                   CFT007
     C*******************EXSR      ERRWID                                       CFT007
     C*******************END                                                    CFT007
     C*******************ADD       1             C                              CFT007
     C*******************END                                                    CFT007
      *
      * POSITION CURSOR ON ACTION CODE IF IT IS BLANK
      *
     C     SACTION       COMP      *BLANK                                 68
      *
      * ENABLE DETAIL FIELDS (ALL FIELDS EXCEPT ACTION CODE & PAYMENT REF)
      *
     C     @EDTFD        COMP      'Y'                                7070
      *                                                                         CFT007
      * ENABLE FUNCTION KEYS                                                    CFT007
      *                                                                         CFT007
     C     @EINKD        COMP      'Y'                                    77    CFT007
     C     @EINKQ        COMP      'Y'                                    78    CFT007
      *                                                                         CFT007
      * Set up function key footer text                                         CFT007
      *                                                                         CFT007
     C                   Eval      SCCMDTXT = *Blanks                           CFT007
     C                   Eval      %SUBST(SCCMDTXT:1:19) = F3F12text            CFT007
     C                   If        @EINKD = 'Y'                                 CFT007
     C                   Eval      %SUBST(SCCMDTXT:61:9) = F4text               CFT007
     C                   Endif                                                  CFT007
     C                   If        @EINKQ = 'Y'                                 CFT007
     C                   Eval      %SUBST(SCCMDTXT:70:11) = F16text             CFT007
     C                   Endif                                                  CFT007
      *
      **Determine*whether*FX*margin*fields*to*be*displayed*************         CFT014
     C***********        EXSR      MARGIN                                       CFT014
 
      **Default*output*fields******************************************         CFT014
     C***********        EXSR      DFTOUTFLDS                                   CFT014
 
      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    DDTIME
     C                   WRITE     FTOPAY3S0
     C                   WRITE     FTOPAY3D1
     C                   WRITE     FTOPAY3F1
      *
      * READ DETAILS SCREEN,
      *
      * If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      FTOPAY3D1                              99    *
     C                   ENDIF
      *
      * Clear message subfile
      *
     C                   CALL      'ZA0250'
      *
      * SET SCREEN ERROR INDICATORS OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      * SET RETURN KEYS
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKD         @INKD                          CFT007
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKQ         @INKQ                          CFT007
      *
     C                   ENDSR
      *****************************************************************
     C*/EJECT*************                                                      CFT007
     C*****************************************************************         CFT007
     C*******************                                             *         CFT007
     C**ERRWOD**-*OUTPUT*ERROR MESSAGES WITHOUT DATA                  *         CFT007
     C*******************                                             *         CFT007
     C*****************************************************************         CFT007
     C*****ERRWOD********BEGSR                                                  CFT007
     C*******************                                                       CFT007
     C***Display*error*message                                                  CFT007
     C*******************                                                       CFT007
     C*******************MOVEL     *BLANK        ZAMSID                         CFT007
     C*******************MOVEL     @MSGID        ZAMSID                         CFT007
     C*******************CALL      'ZA0240'                                     CFT007
     C*******************PARM                    ZAMSID           10            CFT007
     C*******************                                                       CFT007
     C*******************ENDSR                                                  CFT007
     C********************************************************************      CFT007
      /EJECT
     C*****************************************************************         CFT014
     C*****************************************************************         CFT014
     C**DFTOUTFLDS*-*Default*Output*fields*****************************         CFT014
     C*****************************************************************         CFT014
     C*****************************************************************         CFT014
     C*****DFTOUTFLDS    BEGSR                                                  CFT014
     C***********                                                               CFT014
      ***Details*of*Charges.*******************************************         CFT014
      ****If*blank*default*to*'BEN'************************************         CFT014
     C*****SDTCH*        IFEQ      *BLANKS                                      CFT014
     C***********        MOVEL     'BEN'         SDTCH                          CFT014
     C***********        END                                                    CFT014
     C***********                                                               CFT014
     C****Currencies***************************************************         CFT014
     C***********        MOVEL     @CCCY         SCCY1                          CFT014
     C***********        MOVEL     @CCCY         SCCY2                          CFT014
     C***********        MOVEL     @CCCY         SCCY3                          CFT014
     C***********        MOVEL     @CCCY         SCCY4                          CFT014
     C***********        MOVEL     @CCCY         SCCY5                          CFT014
     C***********        MOVEL     @CCCY         SCCY6                          CFT014
     C*****@01494        IFEQ      'Y'                                          CFT014
     C***********        MOVEL     @CCCY         SCCY7                          CFT014
     C***********        END                                                    CFT014
     C*****@01499        IFEQ      'Y'                                          CFT014
     C***********        MOVEL     @CCCY         SCCY8                          CFT014
     C***********        END                                                    CFT014
     C***********                                                               CFT014
     C***********        MOVEL     @RCCY         SRCY1                          CFT014
     C***********        MOVEL     @RCCY         SRCY2                          CFT014
     C***********        MOVEL     @RCCY         SRCY3                          CFT014
     C***********        MOVEL     @RCCY         SRCY4                          CFT014
     C***********        MOVEL     @RCCY         SRCY5                          CFT014
     C***********        MOVEL     @RCCY         SRCY6                          CFT014
     C*****@01494        IFEQ      'Y'                                          CFT014
     C***********        MOVEL     @RCCY         SRCY7                          CFT014
     C***********        END                                                    CFT014
     C*****@01499        IFEQ      'Y'                                          CFT014
     C***********        MOVEL     @RCCY         SRCY8                          CFT014
     C***********        END                                                    CFT014
     C***********                                                               CFT014
      ***Default*'Charge*currency'*amounts*****************************         CFT014
     C***********                                                               CFT014
      ***Get*Charges*Currency*decimal*places***************************         CFT014
     C***********                                                               CFT014
     C***********        MOVE      @RCCY         @AJCD             3            CFT014
     C***********        CALLB     'AOCURRR0'                                   CFT014
     C***********        PARM      *BLANK        @RTCD             7            CFT014
     C***********        PARM      '*KEY   '     @OPTN             7            CFT014
     C***********        PARM                    @AJCD                          CFT014
     C*****SDCURR        PARM      SDCURR        DSSDY                          CFT014
     C***********                                                               CFT014
     C***Transfer*Commission*amount*(charges*currency)*****************         CFT014
     C***********                                                               CFT014
     C***********        MOVEL     *BLANKS       STRCM                          CFT014
     C*****@TRCM*        IFNE      0                                            CFT014
     C***********        Z-ADD     @TRCM         @@AMTW                         CFT014
     C***********        Z-ADD     A6NBDP        @@QECN                         CFT014
     C***********        EXSR      FMTAMT                                       CFT014
     C***********        MOVE      @@AMTD        STRCM                          CFT014
     C***********        END                                                    CFT014
      ***********                                                               CFT014
     C**Telex*charge*(charges*currency)********************************         CFT014
     C***********                                                               CFT014
     C***********        MOVEL     *BLANKS       STXCH                          CFT014
     C*****@TXCH*        IFNE      0                                            CFT014
     C***********        Z-ADD     @TXCH         @@AMTW                         CFT014
     C***********        Z-ADD     A6NBDP        @@QECN                         CFT014
     C***********        EXSR      FMTAMT                                       CFT014
     C***********        MOVE      @@AMTD        STXCH                          CFT014
     C***********        END                                                    CFT014
      ***********                                                               CFT014
     C***Cheque*Charge*(charges*currency)******************************         CFT014
     C***********                                                               CFT014
     C***********        MOVEL     *BLANKS       SCQCH                          CFT014
     C*****@CQCH*        IFNE      0                                            CFT014
     C***********        Z-ADD     @CQCH         @@AMTW                         CFT014
     C***********        Z-ADD     A6NBDP        @@QECN                         CFT014
     C***********        EXSR      FMTAMT                                       CFT014
     C***********        MOVE      @@AMTD        SCQCH                          CFT014
     C***********        END                                                    CFT014
      ***********                                                               CFT014
     C***Costs*Abroad*(charges*currency)*******************************         CFT014
     C***********                                                               CFT014
     C***********        MOVEL     *BLANKS       SCSTA                          CFT014
     C*****@CSTA*        IFNE      0                                            CFT014
     C***********        Z-ADD     @CSTA         @@AMTW                         CFT014
     C***********        Z-ADD     A6NBDP        @@QECN                         CFT014
     C***********        EXSR      FMTAMT                                       CFT014
     C***********        MOVE      @@AMTD        SCSTA                          CFT014
     C***********        END                                                    CFT014
      ***********                                                               CFT014
     C***SWIFT*Priority*Charge*(charges*currency)**********************         CFT014
     C***********                                                               CFT014
     C***********        MOVEL     *BLANKS       SSPCH                          CFT014
     C*****@SPCH*        IFNE      0                                            CFT014
     C***********        Z-ADD     @SPCH         @@AMTW                         CFT014
     C***********        Z-ADD     A6NBDP        @@QECN                         CFT014
     C***********        EXSR      FMTAMT                                       CFT014
     C***********        MOVE      @@AMTD        SSPCH                          CFT014
     C***********        END                                                    CFT014
      ***********                                                               CFT014
     C***Miscellaneous*charge*(charges*currency)***********************         CFT014
     C***********                                                               CFT014
     C***********        MOVEL     *BLANKS       SMSCH                          CFT014
     C*****@MSCH*        IFNE      0                                            CFT014
     C***********        Z-ADD     @MSCH         @@AMTW                         CFT014
     C***********        Z-ADD     A6NBDP        @@QECN                         CFT014
     C***********        EXSR      FMTAMT                                       CFT014
     C***********        MOVE      @@AMTD        SMSCH                          CFT014
     C***********        END                                                    CFT014
     C***********                                                               CFT014
     C***FX/Change*Commission*(charges*currency)***********************         CFT014
     C***********                                                               CFT014
     C*****@01494        IFEQ      'Y'                                          CFT014
      ***********                                                               CFT014
     C***********        MOVEL     *BLANKS       SCHCM                          CFT014
     C*****@CHCM*        IFNE      0                                            CFT014
     C***********        Z-ADD     @CHCM         @@AMTW                         CFT014
     C***********        Z-ADD     A6NBDP        @@QECN                         CFT014
     C***********        EXSR      FMTAMT                                       CFT014
     C***********        MOVE      @@AMTD        SCHCM                          CFT014
     C***********        END                                                    CFT014
      ***********                                                               CFT014
     C***********        END                                                    CFT014
     C***********                                                               CFT014
     C***Total*Charge*(charges*currency)*******************************         CFT014
     C***********                                                               CFT014
     C***********        MOVEL     *BLANKS       SVATT                          CFT014
     C*****@VATT*        IFNE      0                                            CFT014
     C***********        Z-ADD     @VATT         @@AMTW                         CFT014
     C***********        Z-ADD     A6NBDP        @@QECN                         CFT014
     C***********        EXSR      FMTAMT                                       CFT014
     C***********        MOVE      @@AMTD        SVATT                          CFT014
     C***********        END                                                    CFT014
      ***********                                                               CFT014
      ***Get*Input*Currency*decimal*places*****************************         CFT014
     C***********                                                               CFT014
     C***********        MOVE      @CCCY         @AJCD             3            CFT014
     C***********        CALLB     'AOCURRR0'                                   CFT014
     C***********        PARM      *BLANK        @RTCD             7            CFT014
     C***********        PARM      '*KEY   '     @OPTN             7            CFT014
     C***********        PARM                    @AJCD                          CFT014
     C*****SDCURR        PARM      SDCURR        DSSDY                          CFT014
     C***********                                                               CFT014
     C***Total*Charge*(input*currency)*********************************         CFT014
     C***********                                                               CFT014
     C***********        MOVEL     *BLANKS       SVATD                          CFT014
     C*****@VATD*        IFNE      0                                            CFT014
     C***********        Z-ADD     @VATD         @@AMTW                         CFT014
     C***********        Z-ADD     A6NBDP        @@QECN                         CFT014
     C***********        EXSR      FMTAMT                                       CFT014
     C***********        MOVE      @@AMTD        SVATD                          CFT014
     C***********        END                                                    CFT014
     C***********                                                               CFT014
     C***********        ENDSR                                                  CFT014
     C********************************************************************      CFT014
      */EJECT****                                                               CFT014
      *****************************************************************         CFT014
      **MARGIN*-*Determine*whether*FX*MARGIN*fields*to*be*displayed****         CFT014
      *****************************************************************         CFT014
     C*****MARGIN        BEGSR                                                  CFT014
      ***********                                                               CFT014
     C***********        MOVE      '0'           *IN75                          CFT014
      ***********                                                               CFT014
     C*****BGN0ST        IFEQ      'Y'                                          CFT014
      ***********                                                               CFT014
      ****Display*fields*for*enquiry***********************************         CFT014
     C*****SACTION       IFEQ      'E'                                          CFT014
     C***********        MOVE      '1'           *IN75                          CFT014
     C***********        ELSE                                                   CFT014
      ***********                                                               CFT014
      ****For*Insert*and*Amend...**************************************         CFT014
      ****Do*not*display*if*pay*and*settle*currencies*are*the*same*and*         CFT014
      ****margin*info*details*are*blanks.******************************         CFT014
     C*****SPCCY*        IFEQ      SSMCY                                        CFT014
     C*****SMBSI*        ANDEQ     *BLANKS                                      CFT014
     C*****SMSIG*        ANDEQ     *BLANKS                                      CFT014
     C***********        MOVE      '0'           *IN75                          CFT014
     C***********        ELSE                                                   CFT014
     C***********        MOVE      '1'           *IN75                          CFT014
     C***********        END                                                    CFT014
      ***********                                                               CFT014
     C***********        END                                                    CFT014
      ***********                                                               CFT014
     C***********        END                                                    CFT014
      ***********                                                               CFT014
     C***********        ENDSR                                                  CFT014
      *****************************************************************         CFT014
      */EJECT****                                                               CFT014
      *****************************************************************         CFT014
      **FMTAMT*-*FORMAT*AMOUNT*FOR*DISPLAY*****************************         CFT014
      *****************************************************************         CFT014
     C*****FMTAMT        BEGSR                                                  CFT014
      ***********                                                               CFT014
     C***********        CALLB     'ZA0920'                                     CFT014
     C***********        PARM      *BLANK        @@RETC           10            CFT014
     C***********        PARM                    @@AMTW           13 0          CFT014
     C***********        PARM                    @@QECN            1 0          CFT014
     C***********        PARM      '.'           BNDCSP            1            CFT014
     C***********        PARM      *BLANK        @@AMTD           14            CFT014
      ***********                                                               CFT014
     C***********        ENDSR                                                  CFT014
      *****************************************************************
     C*/EJECT*************                                                      CFT007
     C*****************************************************************         CFT007
     C*******************                                             *         CFT007
     C**ERRWID**-*OUTPUT*ERROR MESSAGES WITH DATA                     *         CFT007
     C*******************                                             *         CFT007
     C*****************************************************************         CFT007
     C*****ERRWID********BEGSR                                                  CFT007
     C*******************                                                       CFT007
     C***Display*error*message                                                  CFT007
     C*******************                                                       CFT007
     C*******************MOVEL     *BLANK        ZAMSID                         CFT007
     C*******************MOVEL     @MSGID        ZAMSID                         CFT007
     C*******************CALL      'ZA0440'                                     CFT007
     C*******************PARM                    ZAMSID           10            CFT007
     C*******************PARM      @MSGDT        ZAMDTA           45            CFT007
     C*******************                                                       CFT007
     C*******************ENDSR                                                  CFT007
     C********************************************************************      CFT007
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM                    RetCodeIn
      *
      * PAYMENT (IN SCREEN FORMAT)
     C                   PARM                    FTOPAY1
     C***********        PARM                    FTOPAY2a                       CFT014
     C***********        PARM                    FTOPAY2b                       CFT014
     C                   PARM                    FTOPAY3
                                                                                CFT014
      ** Payment Extension Details                                              CFT014
                                                                                CFT014
     C                   PARM                    FTOPAY1X                       CFT014
     C                   PARM                    FTOPAY3B                       CFT014
      *
      * STATUS
     C                   PARM                    DDSTS            24
      *
      * FIELDS IN ERROR
     C                   PARM                    FTEOPY1
     C                   PARM                    FTEOPY2
     C                   PARM                    FTEOPY3
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
      **None************                                                        CFT007
     C                   PARM                    @EINKD            1            CFT007
     C                   PARM                    @EINKQ            1            CFT007
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKD             1            CFT007
     C                   PARM                    @INKL             1
     C                   PARM                    @INKQ             1            CFT007
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *                                                                         CFT007
      * Cursor location on screen (from INFDS on display file)                  CFT007
     C                   PARM      @#RWCL        CursorLoc         5 0          CFT007
      *
      *  Validation Work Fields from/to caller
     C***********        PARM                    Val@Fields                     CFT014
 
      ** Initialize program name
      *
     C                   MOVEL     'FTOPAY3DP'   DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
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
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ***Check*if*BLI*Funds*Transfer*Enhancement*is*installed**********         CFT014
      ***********                                                               CFT014
     C***********        CALLB     'AOSARDR0'                                   CFT014
     C***********        PARM      *BLANKS       @RTCD                          CFT014
     C***********        PARM      '*VERIFY'     @OPTN                          CFT014
     C***********        PARM      'S01494'      @SARD                          CFT014
     C***********        PARM                    DSFDY                          CFT014
     C*****@RTCD*        IFEQ      *BLANK                                       CFT014
     C***********        MOVEL     'Y'           S01494            1            CFT014
     C***********        ELSE                                                   CFT014
     C*****@RTCD*        IFEQ      '*NRF'                                       CFT014
     C***********        MOVE      'N'           S01494                         CFT014
     C***********        ELSE                                                   CFT014
      ***********                                                               CFT014
      **DATABASE*ERROR*************************************************         CFT014
      ***********                                                               CFT014
     C***********        MOVEL     'SCSARDPD'    DBFILE                         ************
     C***********        MOVEL     '906'         DBASE                          *FDBERR 905*
     C***********        MOVEL     @OPTN         DBKEY                          ************
     C***********        EXSR      *PSSR                                        CFT014
     C***********        END                                                    CFT014
     C***********        END                                                    CFT014
      ***********                                                               CFT014
      ***Check*if*BLI*V.A.T.*Processing*is*installed*******************         CFT014
      ***********                                                               CFT014
     C***********        CALLB     'AOSARDR0'                                   CFT014
     C***********        PARM      *BLANKS       @RTCD                          CFT014
     C***********        PARM      '*VERIFY'     @OPTN                          CFT014
     C***********        PARM      'S01499'      @SARD                          CFT014
     C***********        PARM                    DSFDY                          CFT014
     C*****@RTCD*        IFEQ      *BLANK                                       CFT014
     C***********        MOVEL     'Y'           S01499            1            CFT014
     C***********        ELSE                                                   CFT014
     C*****@RTCD*        IFEQ      '*NRF'                                       CFT014
     C***********        MOVE      'N'           S01499                         CFT014
     C***********        ELSE                                                   CFT014
      ***********                                                               CFT014
      **DATABASE*ERROR*************************************************         CFT014
      ***********                                                               CFT014
     C***********        MOVEL     'SCSARDPD'    DBFILE                         ************
     C***********        MOVEL     '907'         DBASE                          *FDBERR 905*
     C***********        MOVEL     @OPTN         DBKEY                          ************
     C***********        EXSR      *PSSR                                        CFT014
     C***********        END                                                    CFT014
     C***********        END                                                    CFT014
      *
      ** Check if FX Margin Processing is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAC001'      @SARD
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAC001            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CAC001
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '907'         DBASE                          * DBERR 905*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
                                                                                CFT014
      ** Access SAR details file to determine if MT103 Generation enhance -     CFT014
      ** ment is switched on.                                                   CFT014
                                                                                CFT014
     C                   Call      'AOSARDR0'                                   CFT014
     C                   Parm      *Blanks       @RTCD                          CFT014
     C                   Parm      '*VERIFY'     @OPTN                          CFT014
     C                   Parm      'CFT014'      @SARD                          CFT014
     C     SCSARD        Parm      SCSARD        DSFDY                          CFT014
                                                                                CFT014
     C                   If        (@RTCD <> *Blanks) And (@RTCD <> '*NRF   ')  CFT014
     C                   Movel     'SCSARDPD'    DBFILE                         CFT014
     C                   Z-Add     908           DBASE                          CFT014
     C                   Movel     'CFT014'      DBKEY                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        @RTCD = *BLANKS                              CFT014
     C                   Movel     'Y'           CFT014            1            CFT014
     C                   Else                                                   CFT014
     C                   Movel     'N'           CFT014                         CFT014
     C                   EndIf                                                  CFT014
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
     C                   Z-ADD     909           DBASE                          CFT009
     C                   MOVEL     'CFT009'      DBKEY                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        @RTCD = *BLANKS                              CFT009
     C                   MOVEL     'Y'           CFT009            1            CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           CFT009                         CFT009
     C                   ENDIF                                                  CFT009
     C*                                                                         CFT007
     C** Retrieve the text for footer function keys using MEC1150               CFT007
     C*                                                                         CFT007
     C                   CALL      'MEC1150'                            9090    CFT007
     C                   PARM      'FTM2618'     #MSGID                         CFT007
     C                   PARM      'FTUSRMSG'    #MsgFile                       CFT007
     C                   PARM                    #MSDTA                         CFT007
     C                   PARM      *BLANKS       #MSTX1                         CFT007
     C                   PARM      *BLANKS       #MSTX2                         CFT007
     C*                                                                         CFT007
     C                   MOVEL     #MSTX1        FuncText                       CFT007
      *
      * Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      * SET SCREEN PROTECT/NON-DISPLY INDICATORS
      *
      *
      ***BLI*Funds*Transfer*Enhancement********************************         CFT014
      ***********                                                               CFT014
     C*****S01494        IFEQ      'Y'                                          CFT014
     C***********        MOVE      '1'           *IN84                          CFT014
     C***********        ELSE                                                   CFT014
     C***********        MOVE      '0'           *IN84                          CFT014
     C***********        END                                                    CFT014
      ***********                                                               CFT014
      ***BLI*V.A.T.*Processing*****************************************         CFT014
      ***********                                                               CFT014
     C*****S01499        IFEQ      'Y'                                          CFT014
     C***********        MOVE      '1'           *IN85                          CFT014
     C***********        ELSE                                                   CFT014
     C***********        MOVE      '0'           *IN85                          CFT014
     C***********        END                                                    CFT014
                                                                                CFT014
      ** Display MT103 fields                                                   CFT014
                                                                                CFT014
     C                   If        CFT014 = 'Y'                                 CFT014
     C                   Eval      *IN87 = *On                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT009
      ** Non display of transfer commission tariff                              CFT009
                                                                                CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
     C                   EVAL      *IN88 = *ON                                  CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      *IN88 = *OFF                                 CFT009
     C                   ENDIF                                                  CFT009
      *
      **---------------------------------------------------------------         CFT007
      ** The following /COPY line sets up the fixed data for FT *DSP            CFT007
      ** functions for the message handler, ZAMSGHNDLE.                         CFT007
     C/COPY FTCPYSRC,MSGHNDDATA                                                 CFT007
      **---------------------------------------------------------------         CFT007
      *                                                                         CFT007
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CFT007
      **------------------------------------------------------------------------CFT007
      ** The following /COPY line includes the ProcMsgs subroutine              CFT007
      ** to process error and warning messages.                                 CFT007
     C/COPY ZACPYSRC,MSGHNDDSP2                                                 CFT007
      **------------------------------------------------------------------------CFT007
      ********************************************************************      CFT007
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
** @Z0
000000000000000000000000000000000000000000000000000000000000
