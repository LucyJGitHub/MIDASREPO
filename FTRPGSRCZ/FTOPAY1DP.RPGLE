     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments level one display')         *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAY1DP  - Outgoing Payments Level One Display             *
      *                                                               *
      *  Function:  This module displays the main details screen      *
      *             of the Outgoing Payments screen input function.   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056850           Date 29Sep20               *
      *  Prev Amend No. ERZ248             Date 18Nov19               *
      *                 260045A            Date 29Jan13               *
      *                 CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD033641           Date 08Apr15               *
      *                 MD027047           Date 19Aug14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23063           Date 20Feb09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 256586             Date 18Sep08               *
      *                 255711             Date 31Jul08               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12862           Date 08Dec06               *
      *                 CDL049             Date 06Jul06               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CSW203             Date 26May03               *
      *                 212656             Date 14Apr03               *
      *                 CFT018             Date 29Nov02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 09Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 22May00               *
      *                 CFT007             Date 03Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP031  *CREATE    Date 04May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056850 - Move hook ERZ248_025 below READ operation of      *
      *             FTOPAY1D1                                         *
      *  ERZ248 - SWIFT UETR via OPAY API                             *
      *           Add hooks ERZ248_021->028, ERZ248_045               *
      *           Amended hooks FTOPA1XC01                            *
      *  260045A - ERZ123: F15 screen enquiry allows all action codes *
      *            (Recompile)                                        *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD033641 - Remove unsupported keywords of HATS. (Recompile)  *
      *  MD027047 - Avoid HATS issue with redisplaying previous screen*
      *             on the stack. End program with SETON LR with no   *
      *             RETURN.                                           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23063 - OPAY generated from Regular Payment has details   *
      *             mixed up in Outgoing Payment Enquiry (Recompile)  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  256586 - Missing field Ref Rate in webfaced FT maintenance.  *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  BUG12862 - Recompiled to pick up the changes in FTOPY1PD     *
      *             introduced by CFT032 enhancement                  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSW203 - SWIFT 2003 Standards Update                         *
      *  212656 - Set up network MOR correctly.                       *
      *  CFT018 - Standard Settlement Instructions for                *
      *           Outgoing Payments                                   *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - FONTIS : dealer's reference field                   *
      *  CFT007 - BIC Database Plus Integration                       *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     F***FTOPAY1DF*CF***E             WORKSTN                                   CFT007
     FFTOPAY1DF CF   E             WORKSTN INFDS(INFDS#)                        CFT007
 
     FMUSER     IF   E           K DISK
 
     FMEINCRL1  IF   E           K DISK
 
      ** Table of field numbers and names                                       CFT007
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)                         CFT007
                                                                                CFT007
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *                                                               *
      *       63  Error in UETR                                       *                       ERZ248
      *       64  Protect UETR Field                                  *                       ERZ248
      *       65  UETR Non-display                                    *                       ERZ248
      *       68  Position cursor on action code (if it is blank)     *
      *       69  Protect deal key fields (action code & deal number) *
      *       70  Protect deal detail fields                          *
      *       71  Enable CF07 - Next Record                           *
      *       72  Enable CF08 - Previous Record                       *
      *       73  Enable CF10 - Confirm Delete                        *
      *       74  Enable CF15 - Select Record                         *
      *       75  Enable CF18 - Next Linked Enquiry Payment           *
      *       76  Enable CF21 - Additional info window                *
      *       77  Enable CF04, BIC DB+ Prompt                         *         CFT007
      *       78  Enable CF16, BIC DB+ Search                         *         CFT007
      *       79  Highlight deal status                               *
      *                                                               *
      *       80  Not multibranching                                  *
      *       81  Originating branch not used                         *
      *       82  Profit centres not used                             *
      *       83  EMU FT Payments and Settlement not installed        *
      *       84  Display notified delivery fields                    *
      *       85  Error on chain                                      *
      *       86  Show/Hide FONTIS: Deal Reference Field              *
      *       87  CFT014 switchable enhancement is installed          *         CFT014
      *       02  CDL049 is ON, display ref rate field                *                       256586
      *       89  validation error in field ref rate                  *                       256586
      *                                                               *
      *       90  Error in call                                       *
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
     D*@NAR************S             52    DIM(3) CTDATA PERRCD(1)              CFT007
 
     D @EI             S              1    DIM(60)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULE DETAILS
                                                                                CFT014
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CFT014
      ** External DS for Midas Switchable Features details                      CFT014
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
     D FTOPAY        E DS                  EXTNAME(FTOPY1PD)
     D FTEOPY        E DS                  EXTNAME(FTEOPY1PD)
     D FTOPAYX       E DS                  EXTNAME(FTOPY1APD)                   CFT014
      ** Payment Extension Details layout                                       CFT014
     D/COPY WNCPYSRC,ERZ248_045                                                               ERZ248
 
     D                 DS
     D**DDFOTX*********        1     52                                         CFT007
     D**DDSIDN*********       13     27                                         CFT007
 
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MPREF                15     30
     D  #MPART                 1      2P 0
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)                     CFT007
      * Display file information data structure                                 CFT007
                                                                                CFT007
     D  FuncText       DS           105                                         CFT007
     D  F3F12text              1     19                                         CFT007
     D  F7text                20     27                                         CFT007
     D  F8text                28     35                                         CFT007
     D  F10text               36     46                                         CFT007
     D  F15text               47     57                                         CFT007
     D  F18text               58     70                                         CFT007
     D  F21text               71     84                                         CFT007
     D  F4text                85     94                                         CFT007
     D  F16text               95    105                                         CFT007
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @MSGR           S              8S 0
 
     D XPREF           S             15A
                                                                                              CSW203
      ** Flag to indicate if CSW203 is switched on                                            CSW203
     D CSW203          S              1A                                                      CSW203
                                                                                              CSW203
     D PRTCD           S              7A                                                      CSW203
 
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
     C                   MOVEA     FTEOPY        @EI
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
      *                                                                         CFT018
      ** Set on indicator to protect action code from input if function         CFT018
      ** has been called in SSI mode                                            CFT018
     C     SSIMode       Ifeq      'Y'                                          CFT018
     C                   Move      *On           *In01                          CFT018
     C                   Else                                                   CFT018
     C                   Move      *Off          *In01                          CFT018
     C                   Endif                                                  CFT018
      *
     C/COPY WNCPYSRC,ERZ248_021                                                               ERZ248
      ** Set up the payment reference to be used by the message handler         CFT007
     C                   EVAL      TranRef = SPREF                              CFT007
     C                   EVAL      ActionCode = SACTION                         CFT007
                                                                                CFT007
      **------------------------------------------------------------------------CFT007
      ** The following /COPY line includes processing for the error and         CFT007
      ** warning messages.                                                      CFT007
     D/COPY ZACPYSRC,MSGHNDDSP1                                                 CFT007
      **------------------------------------------------------------------------CFT007
      *                                                                         CFT007
      ***DO*WHILE*ERROR*MESSAGES FOUND                                          CFT007
      ***WRITE*ERROR*MESSAGES (WITH OR WITHOUT DATA) TO SUBFILE                 CFT007
      ******************                                                        CFT007
     C****************** Z-ADD     1             C                              CFT007
     C*****C************ DOWLE     ArrayMax                                     CFT007
     C*****FldNameArr(C) ANDNE     *BLANKS                                      CFT007
     C****************** MOVEL     MsgIdArr(C)   @MSGID            7            CFT007
     C****************** MOVEL     MsgDtaArr(C)  @MSGDT           45            CFT007
     C*****@MSGDT******* IFEQ      *BLANKS                                      CFT007
     C****************** EXSR      ERRWOD                                       CFT007
     C****************** ELSE                                                   CFT007
     C****************** EXSR      ERRWID                                       CFT007
     C****************** END                                                    CFT007
     C****************** ADD       1             C                              CFT007
     C****************** END                                                    CFT007
      ******************                                                        CFT007
      ***DO*WHILE*WARNING MESSAGES FOUND                                        CFT007
      ***WRITE*WARNING*MESSAGES (WITH OR WITHOUT DATA) TO SUBFILE               CFT007
      ******************                                                        CFT007
     C****************** Z-ADD     1             C                              CFT007
     C*****C************ DOWLE     ArrayMax                                     CFT007
     C*****WFldNamArr(C) ANDNE     *BLANKS                                      CFT007
     C****************** MOVEL     WMsgIdArr(C)  @MSGID            7            CFT007
     C****************** MOVEL     WMsgDtaArr(C) @MSGDT           45            CFT007
     C*****@MSGDT******* IFEQ      *BLANKS                                      CFT007
     C****************** EXSR      ERRWOD                                       CFT007
     C****************** ELSE                                                   CFT007
     C****************** EXSR      ERRWID                                       CFT007
     C****************** END                                                    CFT007
     C****************** ADD       1             C                              CFT007
     C****************** END                                                    CFT007
      ******************                                                        CFT007
      * POSITION CURSOR ON ACTION CODE IF IT IS BLANK
      *
     C     SACTION       COMP      *BLANK                                 68
      *
      * ENABLE KEY FIELDS (ACTION CODE & PAYMENT REF)
      *
     C/COPY WNCPYSRC,FTH00354
     C     @EKYFD        COMP      'Y'                                6969
     C/COPY WNCPYSRC,FTH00355
      *
      * ENABLE DETAIL FIELDS (ALL FIELDS EXCEPT ACTION CODE & PAYMENT REF)
      *
     C     @EDTFD        COMP      'Y'                                7070
      *
      * ENABLE FUNCTION KEYS
      *
     C     @EINKG        COMP      'Y'                                    71
     C     @EINKH        COMP      'Y'                                    72
     C     @EINKJ        COMP      'Y'                                    73
     C     @EINKP        COMP      'Y'                                    74
     C     @EINKS        COMP      'Y'                                    75
     C     @EINKV        COMP      'Y'                                    76
     C     @EINKD        COMP      'Y'                                    77    CFT007
     C     @EINKQ        COMP      'Y'                                    78    CFT007
      *                                                                         CFT007
      * Set up function key footer text                                         CFT007
      *                                                                         CFT007
     C                   Eval      SCCMDTXT = *Blanks                           CFT007
     C                   Eval      %SUBST(SCCMDTXT:1:19) = F3F12text            CFT007
     C                   If        @EINKG = 'Y'                                 CFT007
     C                   Eval      %SUBST(SCCMDTXT:20:8) = F7text               CFT007
     C                   Endif                                                  CFT007
     C                   If        @EINKH = 'Y'                                 CFT007
     C                   Eval      %SUBST(SCCMDTXT:28:8) = F8text               CFT007
     C                   Endif                                                  CFT007
     C                   If        @EINKP = 'Y'                                 CFT007
     C                   Eval      %SUBST(SCCMDTXT:36:11) = F15text             CFT007
     C                   Endif                                                  CFT007
     C                   If        @EINKS = 'Y'                                 CFT007
     C                   Eval      %SUBST(SCCMDTXT:47:13) = F18text             CFT007
     C                   Endif                                                  CFT007
     C                   If        @EINKV = 'Y'                                 CFT007
     C                   Eval      %SUBST(SCCMDTXT:47:14) = F21text             CFT007
     C                   Endif                                                  CFT007
     C                   If        @EINKJ = 'Y'                                 CFT007
     C                   Eval      %SUBST(SCCMDTXT:61:11) = F10text             CFT007
     C                   Endif                                                  CFT007
     C                   If        @EINKD = 'Y'                                 CFT007
     C                   Eval      %SUBST(SCCMDTXT:61:9) = F4text               CFT007
     C                   Endif                                                  CFT007
     C                   If        @EINKQ = 'Y'                                 CFT007
     C                   Eval      %SUBST(SCCMDTXT:70:11) = F16text             CFT007
     C                   Endif                                                  CFT007
      *                                                                         CFT007
      *
      * If action code 'I' and called from swift enquiry
      * Seton IN84 to display Notified delivery fields.
      *
     C     SACTION       IFEQ      'I'
     C     XPREF         ANDNE     *BLANKS
     C                   MOVE      '1'           *IN84
     C                   END
 
      * DEAL STATUS
      *
     C     DDSTS         COMP      *BLANK                             7979
      *
      * TEXT = SUCCESSFUL INSERT
      *
     C     @SITR         IFNE      *BLANK
     C*******************MOVEL     @NAR(1)       DDFOTX                          CFT007
     C*******************MOVEL     @SITR         DDSIDN                          CFT007
     C                   MOVEL     @SITR         #MSDTA                          CFT007
     C** Retrieve the text for FTM2622 using MEC1150                             CFT007
     C*                                                                          CFT007
     C                   CALL      'MEC1150'                            9090     CFT007
     C                   PARM      'FTM2622'     #MSGID                          CFT007
     C                   PARM      'FTUSRMSG'    #MsgFile                        CFT007
     C                   PARM                    #MSDTA                          CFT007
     C                   PARM      *BLANKS       #MSTX1                          CFT007
     C                   PARM      *BLANKS       #MSTX2                          CFT007
     C                   MOVEL     #MSTX1        DDFOTX                          CFT007
     C                   MOVEL     *BLANK        @SITR
     C                   ELSE
      *******************                                                        CFT007
      **TEXT*=*CONFIRM*DELETE                                                    CFT007
      *******************                                                        CFT007
     C*****@EINKJ********IFEQ      'Y'                                           CFT007
     C*******************MOVEL     @NAR(2)       DDFOTX                          CFT007
     C*******************ELSE                                                    CFT007
      *******************                                                        CFT007
      **TEXT*=*Additional Information                                            CFT007
      *******************                                                        CFT007
     C*****@EINKV********IFEQ      'Y'                                           CFT007
     C*******************MOVEL     @NAR(3)       DDFOTX                          CFT007
     C*******************ELSE                                                    CFT007
     C                   MOVEL     *BLANK        DDFOTX
     C*******************END                                                     CFT007
     C*******************END                                                     CFT007
     C                   END
      * Set Screen Error indicator for field Ref Rate                                         256586
     C     'SRRAT     '  LOOKUP    FldNameArr                             89                  256586
     C                   If        *IN89 = *OFF                                               256586
     C     'SRRAT     '  LOOKUP    WFldNamArr                             89                  256586
     C                   EndIf                                                                256586
      *
      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
      *
     C/COPY WNCPYSRC,FTOPA1XC01
     C                   TIME                    DDTIME
     C                   WRITE     FTOPAY1S0
     C/COPY WNCPYSRC,ERZ248_022                                                               ERZ248
     C                   WRITE     FTOPAY1D1
     C/COPY WNCPYSRC,ERZ248_023                                                               ERZ248
     C                   WRITE     FTOPAY1F1
      *
      * READ DETAILS SCREEN,
      *
      * If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C/COPY WNCPYSRC,ERZ248_024                                                               ERZ248
     C*/COPY*WNCPYSRC,ERZ248_025                                                     ERZ248 MD056850
     C                   READ      FTOPAY1D1                              99    *
     C/COPY WNCPYSRC,ERZ248_025                                                             MD056850
     C                   ENDIF
     C/COPY WNCPYSRC,FTOPA1XC02
      *
      * If F21 taken display additional info window
     C     *INKV         IFEQ      '1'
     C                   EXSR      ADDLINFO
     C                   END
 
      * Clear message subfile
      *
     C                   CALL      'ZA0250'
      *
      * SET SCREEN ERROR INDICATORS OFF
      *
     C                   MOVEA     @Z0           *IN(10)
     C/COPY WNCPYSRC,ERZ248_026                                                               ERZ248
      *
      * SET RETURN KEYS
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKD         @INKD                          CFT007
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKP         @INKP
     C                   MOVE      *INKQ         @INKQ                          CFT007
     C                   MOVE      *INKS         @INKS
     C                   MOVE      *INKV         @INKV
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *********************************************************************
      * ADDLINFO - Additional Information window called from primary screen
      *********************************************************************
     C     ADDLINFO      BEGSR
      *
     C** Initilise screen fields
     C*
     C                   MOVE      *BLANKS       SUSRP1
     C                   MOVE      *BLANKS       SUSER1
     C                   MOVE      *BLANKS       SUSRP2
     C                   MOVE      *BLANKS       SUSER2
     C                   MOVE      *BLANKS       SAUP1
     C                   MOVE      *BLANKS       SAUT1
     C                   MOVE      *BLANKS       SAUP2
     C                   MOVE      *BLANKS       SAUT2
     C                   MOVE      *BLANKS       SNMIR
     C                   MOVE      *BLANKS       SNMOR
     C*
     C** Retrieve the user profile names of the input users 1 & 2 and
     C** authorising users 1 & 2 from MUSERDD
     C*
     C                   MOVEL     @USER1        SUSRP1
     C     @USER1        IFNE      *BLANKS
     C     @USER1        CHAIN     MUSER                              85
     C     *IN85         IFEQ      '1'
     C     *IN85         OREQ      '0'
     C     RECI          ANDNE     'D'
     C                   MOVEL     WM2510        SUSER1
     C                   ELSE
     C                   MOVEL     USER1         SUSER1
     C                   END
     C                   END
     C*
     C                   MOVEL     @USER2        SUSRP2
     C     @USER2        IFNE      *BLANKS
     C     @USER2        CHAIN     MUSER                              85
     C     *IN85         IFEQ      '1'
     C     *IN85         OREQ      '0'
     C     RECI          ANDNE     'D'
     C                   MOVEL     WM2510        SUSER2
     C                   ELSE
     C                   MOVEL     USER1         SUSER2
     C                   END
     C                   END
     C*
     C                   MOVEL     @AUTH1        SAUP1
     C     @AUTH1        IFNE      *BLANKS
     C     @AUTH1        CHAIN     MUSER                              85
     C     *IN85         IFEQ      '1'
     C     *IN85         OREQ      '0'
     C     RECI          ANDNE     'D'
     C                   MOVEL     WM2510        SAUT1
     C                   ELSE
     C                   MOVEL     USER1         SAUT1
     C                   END
     C                   END
     C*
     C                   MOVEL     @AUTH2        SAUP2
     C     @AUTH2        IFNE      *BLANKS
     C     @AUTH2        CHAIN     MUSER                              85
     C     *IN85         IFEQ      '1'
     C     *IN85         OREQ      '0'
     C     RECI          ANDNE     'D'
     C                   MOVEL     WM2510        SAUT2
     C                   ELSE
     C                   MOVEL     USER1         SAUT2
     C                   END
     C                   END
     C*
     C** Retrieve MIR and MOR of the transaction from MEINCRPD
     C*
     C     @MSGR         IFNE      *ZEROS
     C     @MSGR         CHAIN     MEINCRL1                           85
     C     *IN85         IFEQ      '1'
     C                   MOVEL     WM2519        SNMIR
     C                   MOVEL     WM2519        SNMOR
     C                   ELSE
     C                   MOVEL     CRMIR         SNMIR
     C**********         MOVEL     CRMIR         SNMOR                                        212656
     C                   MOVEL     CRMOR         SNMOR                                        212656
     C                   END
     C                   END
     C*
     C                   EXFMT     FTOPAY1F3
     C*
      * Process returned command keys
      *  If Cmd12 or enter pressed, return to main details screen;
      *
     C     *INKG         IFEQ      '1'
     C                   MOVE      '0'           *INKG
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      */EJECT************                                                       CFT007
     C*****************************************************************         CFT007
     C******************                                              *         CFT007
     C**ERRWOD**-*OUTPUT ERROR MESSAGES WITHOUT DATA                  *         CFT007
     C******************                                              *         CFT007
     C*****************************************************************         CFT007
     C*****ERRWOD******* BEGSR                                                  CFT007
     C******************                                                        CFT007
     C***Display*error*message                                                  CFT007
     C******************                                                        CFT007
     C****************** MOVEL     *BLANK        ZAMSID                         CFT007
     C****************** MOVEL     @MSGID        ZAMSID                         CFT007
     C****************** CALL      'ZA0240'                                     CFT007
     C****************** PARM                    ZAMSID           10            CFT007
     C******************                                                        CFT007
     C****************** ENDSR                                                  CFT007
     C********************************************************************      CFT007
      */EJECT***********                                                        CFT007
     C*****************************************************************         CFT007
     C******************                                              *         CFT007
     C**ERRWID**-*OUTPUT ERROR MESSAGES WITH DATA                     *         CFT007
     C******************                                              *         CFT007
     C*****************************************************************         CFT007
     C*****ERRWID******* BEGSR                                                  CFT007
     C******************                                                        CFT007
     C***Display*error*message                                                  CFT007
     C******************                                                        CFT007
     C****************** MOVEL     *BLANK        ZAMSID                         CFT007
     C****************** MOVEL     @MSGID        ZAMSID                         CFT007
     C****************** CALL      'ZA0440'                                     CFT007
     C****************** PARM                    ZAMSID           10            CFT007
     C****************** PARM      @MSGDT        ZAMDTA           45            CFT007
     C******************                                                        CFT007
     C****************** ENDSR                                                  CFT007
     C*****************************************************************         CFT007
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
     C                   PARM                    FTOPAY
                                                                                CFT014
      ** Payment Extension Details                                              CFT014
                                                                                CFT014
     C                   PARM                    FTOPAYX                        CFT014
      *
      * STATUS
     C                   PARM                    DDSTS            24
      *
      * FIELDS IN ERROR
     C                   PARM                    FTEOPY
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
      * KD = COMMAND KEY 04 = BIC IN-LINE PROMPT                                CFT007
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KP = COMMAND KEY 15 = BROWSE
      * KQ = COMMAND KEY 16 = BIC IN-LINE SEARCH                                CFT007
      * KS = COMMAND KEY 18 = READ NEXT (from linked enquiry)
      * KV = COMMAND KEY 21 = ADDITIONAL INFORMATION WINDOW
     C                   PARM                    @EINKD            1            CFT007
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKP            1
     C                   PARM                    @EINKQ            1            CFT007
     C                   PARM                    @EINKS            1
     C                   PARM                    @EINKV            1
      *
      * SUCCESFUL INSERT TRANSACTION
     C                   PARM                    @SITR            15
      *
      * Data required for Additional Info window
     C                   PARM                    @USER1           10
     C                   PARM                    @USER2           10
     C                   PARM                    @AUTH1           10
     C                   PARM                    @AUTH2           10
     C                   PARM                    @MSGR
 
      * SWIFT Identifier (if called from SWIFT enquiry)
     C                   PARM                    XPREF
 
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKD             1            CFT007
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
     C                   PARM                    @INKQ             1            CFT007
     C                   PARM                    @INKS             1
     C                   PARM                    @INKV             1
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *                                                                         CFT007
      * Cursor location on screen (from INFDS on display file)                  CFT007
     C                   PARM      @#RWCL        CursorLoc         5 0          CFT007
      *                                                                         CFT018
      * Parameter to indicate program has been called in SSI mode               CFT018
     C                   PARM                    SSIMode           1            CFT018
     C/COPY WNCPYSRC,ERZ248_027                                                               ERZ248
      *
      ** Initialize program name
      *
     C                   MOVEL     'FTOPAY1DP'   DBPGM
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
      ** Check if EMU settlement currency conversion is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU006'      @SARD
     C                   PARM                    DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU006            1
     C                   ELSE
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'N'           CEU006
     C                   ELSE
      *
      * DATABASE ERROR
      *
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '906'         DBASE                          * DBERR 905*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *                                                                         175479
      ** Access SAR details file to see if CGL009 is allowed.                   175479
      *                                                                         175479
     C                   CALLB     'AOSARDR0'                                   175479
     C                   Parm      *BLANKS       @RTCD             7            175479
     C                   Parm      '*VERIFY'     @OPTN             7            175479
     C                   Parm      'CGL009'      @SARD             6            175479
     C                   Parm      *BLANKS       DSFDY                          175479
      *                                                                         175479
     C     @RTCD         Ifeq      *BLANKS                                      175479
      *  Show Deal reference field                                              175479
     C                   SETON                                        86        175479
     C                   MOVE      'Y'           CGL009            1            175479
      *  CGL009 not found                                                       175479
     C                   ELSE                                                   175479
     C                   MOVE      'N'           CGL009                         175479
      *  Hide Deal reference field                                              175479
     C                   SETOFF                                       86        175479
     C                   END                                                    175479
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
     C                   Z-Add     907           DBASE                          CFT014
     C                   Movel     'CFT014'      DBKEY                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        @RTCD = *Blanks                              CFT014
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
     C                   Z-ADD     908           DBASE                          CFT009
     C                   MOVEL     'CFT009'      DBKEY                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        @RTCD = *BLANKS                              CFT009
     C                   MOVEL     'Y'           CFT009            1            CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           CFT009                         CFT009
     C                   ENDIF                                                  CFT009
      ** Access SAR details file to determine if CDL049 is on                                 256586
      ** For display of Reference Rate field                                                  256586
                                                                                              256586
     C                   CALL      'AOSARDR0'                                                 256586
     C                   PARM      *Blanks       @RTCD                                        256586
     C                   PARM      '*VERIFY'     @OPTN                                        256586
     C                   PARM      'CDL049'      @SARD                                        256586
     C     SCSARD        PARM      SCSARD        DSFDY                                        256586
                                                                                              256586
     C                   IF        (@RTCD <> *BLANKS) And                                     256586
     C                             (@RTCD <> '*NRF   ')                                       256586
     C                   MOVEL     'SCSARDPD'    DBFILE                                       256586
     C                   Z-ADD     905           DBASE                                        256586
     C                   MOVEL     'CDL049'      DBKEY                                        256586
     C                   EXSR      *PSSR                                                      256586
     C                   ENDIF                                                                256586
                                                                                              256586
     C                   IF        @RTCD = *BLANKS                                            256586
     C                   Eval      *in02 = *ON                                                256586
     C                   ENDIF                                                                256586
                                                                                              CSW203
     C/COPY WNCPYSRC,FTH00356
      ** Call SWIF2003 to check if CSW203 is installed                                        CSW203
                                                                                              CSW203
     C                   CALL      'SWIF2003'                                                 CSW203
     C                   PARM      *BLANKS       PRTCD                                        CSW203
                                                                                              CSW203
      ** If ret. code is "CSW203", set CSW203 flag to "Y", else set it to "N"                 CSW203
                                                                                              CSW203
     C                   IF        PRTCD = 'CSW2003'                                          CSW203
     C                   EVAL      CSW203 = 'Y'                                               CSW203
     C                   EVAL      *IN67 = *ON                                                CSW203
     C                   ELSE                                                                 CSW203
     C                   EVAL      CSW203 = 'N'                                               CSW203
     C                   EVAL      *IN67 = *OFF                                               CSW203
     C                   ENDIF                                                                CSW203
      *
     C/COPY WNCPYSRC,ERZ248_028                                                               ERZ248
      *
     C** Retrieve the text for FTM2510 using MEC1150
     C*
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'FTM2510'     #MSGID
     C                   PARM      'FTUSRMSG'    #MsgFile
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C*
     C                   MOVEL     #MSTX1        WM2510           28
     C*
     C** Retrieve the text for FTM2519 using MEC1150
     C*
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'FTM2519'     #MSGID
     C                   PARM      'FTUSRMSG'    #MsgFile
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C*
     C                   MOVEL     #MSTX1        WM2519           28
     C*                                                                         CFT007
     C** Retrieve the text for footer function keys using MEC1150               CFT007
     C*                                                                         CFT007
     C                   CALL      'MEC1150'                            9090    CFT007
     C                   PARM      'FTM2616'     #MSGID                         CFT007
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
      * Single-branching (protect booking branch)
      *
     C     BJSBRC        IFNE      *BLANK
     C                   MOVE      '1'           *IN80
     C                   END
      *
      * Originating Branches not used
      *
     C     BKOBRU        IFNE      'Y'
     C     BJSBRC        ORNE      *BLANK
     C                   MOVE      '1'           *IN81
     C                   END
      *
      * Profit Centres not used (protect profit centre)
      *
     C     BKPRCU        IFNE      'Y'
     C                   MOVE      '1'           *IN82
     C                   END
      *
      * EMU settlement currency conversion
      * (protect various fields)
      *
     C     CEU006        IFEQ      'Y'
     C                   MOVE      '1'           *IN83
     C                   END
                                                                                CFT014
      ** Display MT103 fields                                                   CFT014
                                                                                CFT014
     C                   If        CFT014 = 'Y'                                 CFT014
     C                   Eval      *IN87 = *On                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT009
      ** Display FX Spread Set                                                  CFT009
                                                                                CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
     C                   EVAL      *IN88 = *ON                                  CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      *IN88 = *OFF                                 CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT007
      **---------------------------------------------------------------         CFT007
      ** The following /COPY line sets up the fixed data for FT *DSP            CFT007
      ** functions for the message handler, ZAMSGHNDLE.                         CFT007
     C/COPY FTCPYSRC,MSGHNDDATA                                                 CFT007
      **---------------------------------------------------------------         CFT007
 
     C/COPY WNCPYSRC,FTOPA1XC03
     C                   ENDSR
      *****************************************************************
      /EJECT
      **------------------------------------------------------------------------CFT007
      ** The following /COPY line includes the ProcMsgs subroutine              CFT007
      ** to process error and warning messages.                                 CFT007
     D/COPY ZACPYSRC,MSGHNDDSP2                                                 CFT007
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
      *   following compile time array data removed for change CFT007           CFT007
      *   ** @NAR                                                               CFT007
      *   Payment No. 999999999999999 successfully inserted.                    CFT007
      *   F10=CONFIRM DELETE                                                    CFT007
      *   F21=Additional Information                                            CFT007
      ********************************************************************      CFT007
**  CPY@
(c) Finastra International Limited 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
