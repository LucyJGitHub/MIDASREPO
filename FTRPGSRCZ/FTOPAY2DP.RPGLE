     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments level two display')         *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAY2DP  - Outgoing Payments Level Two Display             *
      *                                                               *
      *  Function:  This module displays the secondary details screen *
      *             of the Outgoing Payments screen input function.   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD035776           Date 10Sep15               *
      *                 MD027047           Date 19Aug14               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 15Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 03Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP031  *CREATE    Date 05May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD035776 - User need to press twice on input screen          *
      *           - Remove unsupported keywords of HATS from dspf     *
      *             (Recompile)                                       *
      *  MD027047 - Avoid HATS issue with redisplaying previous screen*
      *             on the stack. End program with SETON LR with no   *
      *             RETURN.                                           *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - BIC Database Plus Integration                       *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     F***FTOPAY2DF*CF***E             WORKSTN                                   CFT007
     FFTOPAY2DF CF   E             WORKSTN INFDS(INFDS#)                        CFT007
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
      *       71  Enable CF07                                         *
      *       72  Enable CF08                                         *
      *       74  Enable CF15                                         *
      *       77  Enable CF04, BIC DB+ Prompt                         *         CFT007
      *       78  Enable CF16, BIC DB+ Search                         *         CFT007
      *       79  Highlight deal status                               *
      *                                                               *
      *       80  Not multibranching                                  *
      *       81  Originating branch not used                         *
      *       82  Profit centres not used                             *
      *       83  EMU FT Payments and Settlement not installed        *
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
     D*@NAR************S             52    DIM(2) CTDATA PERRCD(1)              CFT007
     D*@NAR2***********S             26    DIM(1) CTDATA PERRCD(1)              CFT007
 
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
     D FTOPAY1       E DS                  EXTNAME(FTOPY1PD)
      ** Screen fields (Initial Screen)
     D FTOPAY2a      E DS                  EXTNAME(FTOPY2PD)
      ** Screen fields (Second Screen)
     D FTOPAY2b      E DS                  EXTNAME(FTOPY3PD)
      ** Screen fields (Second Screen)
                                                                                CFT014
     D FTOPAY1X      E DS                  EXTNAME(FTOPY1APD)                   CFT014
      ** Payment Extension Details layout                                       CFT014
 
     D FTEOPY1       E DS                  EXTNAME(FTEOPY1PD)
      ** Error Indicators (Screen one)
     D FTEOPY2       E DS                  EXTNAME(FTEOPY2PD)
      ** Error Indicators (Screen two)
 
     D*****************DS                                                       CFT007
     D**DDFOTX*********        1     52                                         CFT007
     D**DDSIDN*********       13     27                                         CFT007
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)                     CFT007
      * Display file information data structure                                 CFT007
                                                                                CFT007
     D  FuncText       DS            79                                         CFT007
     D  F3F12text              1     19                                         CFT007
     D  F7text                20     27                                         CFT007
     D  F8text                28     35                                         CFT007
     D  F15text               36     46                                         CFT007
     D  F18text               47     59                                         CFT007
     D  F4text                60     68                                         CFT007
     D  F16text               69     79                                         CFT007
 
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
     C                   MOVEA     FTEOPY2       @EI
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
      *                                                                         CFT007
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
      * ENABLE KEY FIELDS (ACTION CODE & PAYMENT REF)
      *
     C     @EKYFD        COMP      'Y'                                6969
      *
      * ENABLE DETAIL FIELDS (ALL FIELDS EXCEPT ACTION CODE & PAYMENT REF)
      *
     C     @EDTFD        COMP      'Y'                                7070
      *
      * ENABLE FUNCTION KEYS
      *
     C     @EINKG        COMP      'Y'                                    71
     C     @EINKH        COMP      'Y'                                    72
     C     @EINKP        COMP      'Y'                                    74
     C     @EINKS        COMP      'Y'                                    76
     C     @EINKD        COMP      'Y'                                    77    CFT007
     C     @EINKQ        COMP      'Y'                                    78    CFT007
      *
      * Set up function key footer text                                         CFT007
     C                                                                          CFT007
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
     C                   If        @EINKD = 'Y'                                 CFT007
     C                   Eval      %SUBST(SCCMDTXT:61:9) = F4text               CFT007
     C                   Endif                                                  CFT007
     C                   If        @EINKQ = 'Y'                                 CFT007
     C                   Eval      %SUBST(SCCMDTXT:70:11) = F16text             CFT007
     C                   Endif                                                  CFT007
      *
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
     C                   MOVEL     *BLANK        DDFOTX
     C                   END
      *******************                                                       CFT007
      **Set*up*text*for*command*key*F18*                                        CFT007
     C******IN76*********IFEQ      '1'                                          CFT007
     C*******************MOVEL     @NAR2(1)      DDCMDTXT                       CFT007
     C*******************ELSE                                                   CFT007
     C*******************MOVEL     *BLANKS       DDCMDTXT                       CFT007
     C*******************END                                                    CFT007
      *
      * WRITE MESSAGE SUBFILE, DETAILS AND FOOTER SCREEN
      *
     C                   TIME                    DDTIME
     C                   WRITE     FTOPAY2S0
     C                   WRITE     FTOPAY2D1
     C                   WRITE     FTOPAY2F1
      *
      * READ DETAILS SCREEN,
      *
      * If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      FTOPAY2D1                              99    *
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
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKP         @INKP
     C                   MOVE      *INKQ         @INKQ                          CFT007
     C                   MOVE      *INKS         @INKS
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
     C                   PARM                    FTOPAY2a
     C                   PARM                    FTOPAY2b
                                                                                CFT014
      ** Payment Extension Details                                              CFT014
                                                                                CFT014
     C                   PARM                    FTOPAY1X                       CFT014
      *
      * STATUS
     C                   PARM                    DDSTS            24
      *
      * FIELDS IN ERROR
     C                   PARM                    FTEOPY1
     C                   PARM                    FTEOPY2
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
     C                   PARM                    @EINKD            1            CFT007
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKP            1
     C                   PARM                    @EINKQ            1            CFT007
     C                   PARM                    @EINKS            1
      *
      * SUCCESFUL INSERT TRANSACTION
     C                   PARM                    @SITR            15
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKD             1            CFT007
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
     C                   PARM                    @INKQ             1            CFT007
     C                   PARM                    @INKS             1
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *                                                                         CFT007
      * Cursor location on screen (from INFDS on display file)                  CFT007
     C                   PARM      @#RWCL        CursorLoc         5 0          CFT007
      *
      ** Initialize program name
      *
     C                   MOVEL     'FTOPAY2DP'   DBPGM
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
     C                   If        @RTCD = *BLANKS                              CFT014
     C                   Movel     'Y'           CFT014            1            CFT014
     C                   Else                                                   CFT014
     C                   Movel     'N'           CFT014                         CFT014
     C                   EndIf                                                  CFT014
      *                                                                         CFT007
      ** Retrieve the text for footer function keys using MEC1150               CFT007
      *                                                                         CFT007
     C                   CALL      'MEC1150'                            9090    CFT007
     C                   PARM      'FTM2617'     #MSGID                         CFT007
     C                   PARM      'FTUSRMSG'    #MsgFile                       CFT007
     C                   PARM                    #MSDTA                         CFT007
     C                   PARM      *BLANKS       #MSTX1                         CFT007
     C                   PARM      *BLANKS       #MSTX2                         CFT007
      *                                                                         CFT007
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
      * Single-branching (do not display Charges to Debit of A/C Branch)
      *
     C     BJSBRC        IFNE      *BLANK
     C                   MOVE      '1'           *IN80
     C                   END
                                                                                CFT014
      ** Display MT103 fields                                                   CFT014
                                                                                CFT014
     C                   If        CFT014 = 'Y'                                 CFT014
     C                   Eval      *IN87 = *On                                  CFT014
     C                   EndIf                                                  CFT014
      *                                                                         CFT007
      **---------------------------------------------------------------         CFT007
      ** The following /COPY line sets up the fixed data for FT *DSP            CFT007
      ** functions for the message handler, ZAMSGHNDLE.                         CFT007
     C/COPY FTCPYSRC,MSGHNDDATA                                                 CFT007
      **---------------------------------------------------------------         CFT007
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CFT007
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
      *   following compile time arrays data removed for change CFT007          CFT007
      *   ** @NAR                                                               CFT007
      *   Payment No. 999999999999999 successfully updated.                     CFT007
      *   F10=CONFIRM DELETE                                                    CFT007
      *   ** @NAR2                                                              CFT007
      *   F18=Next Payment                                                      CFT007
      ********************************************************************      CFT007
**  CPY@
(c) Finastra International Limited 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
