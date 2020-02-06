     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Security Prices - Display')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEPRCSDSP - SE Market Price Display                          *
      *                                                               *
      *  Function:  This module displays the SE Market Price Screen   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 234675             Date 04Jul05               *
      *                 233698             Date 25May05               *
      *                 232543             Date 14Mar05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 228039             Date 28Jun04               *
      *                 CAS006             Date 21Jan03               *
      *                 213558             Date 09Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD010             Date 03May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 02May01               *
      *                 CAP060  *CREATE    Date 03Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  234675 - Change control for processing type 4 and Dividend   *
      *           EU tax calculation                                  *
      *  233698 - Change Control for CGL031                           *
      *  232543 - Fix for CGL031                                      *
      *  CGL031 - Taxation on Savings Income                          *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  228039 - Prevent the system from falling over a matured      *
      *           security.                                           *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  213558 - Change data feed req id and timestamp to output only*
      *           (recompile)                                         *
      *  CSD010 - Collateralised Lending (Securities and FX Pricing)  *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP060 - Conversion of Midas Screen Input Program into full  *
      *           API, including repair program which CAP030 does not *
      *           include                                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEPRCSDSDFCF   E             WORKSTN
 
      ** Investment Type                                                                      CGL031
     FINVTP     IF   E           K DISK    INFSR(*PSSR)                                       CGL031
                                                                                              CGL031
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
                                                                                              CAS006
     FSECTY     IF   E           K DISK    INFSR(*PSSR)                                       CAS006
      ** Midas SE Securities                                                                  CAS006
                                                                                              CAS006
     FBKPHD     IF   E           K DISK    INFSR(*PSSR)                                       CAS006
      ** Midas SE Book Position Headers                                                       CAS006
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-59 Field Error - highlight screen fields               *
      *       68  Position cursor on action code (if it is blank)     *
      *       69  Protect recd key fields                             *
      *       70  Display only                                        *
      *       71  Enable Function Key - F10                           *
      *       72  Toggle F3 footer text                               *
      *       73  Position cursor on first field if no error          *
      *       74  Enable CF07                                         *
      *       75  Enable CF08                                         *
      *       76  Enable CF15                                         *
      *     80-89 Reference and Part./Non-Part. fields display        *
      *       90  CSD006 - Market Data Feeds                          *
      *       92  Taxation of Savings Income                          *                       CGL031
      *       99  Read error                                          *
      ********************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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
 
     D @EI             S              1    DIM(60)
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
     D @Z10            S              1    DIM(10) CTDATA PERRCD(10)
 
      ** Securities Prices Transaction Details in screen format
     D TRNDETS       E DS                  EXTNAME(SEPRCSPD)
     D   DDTSDT                            OVERLAY(DDDFTS:3)
     D   DDTSTM                            OVERLAY(DDDFTS:9)
 
      ** Securities Prices Transaction Details OK indicators
     D OKTRNDETS     E DS                  EXTNAME(SEEPRCSPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
                                                                                              CSD006
      ** External DS for switchable features                                                  CSD006
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD006
 
      ** Security Trading Detail
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CSD010
     D PRtCd           S              7A                                                      CSD010
     D POption         S              7A                                                      CSD010
     D PSard           S              6A                                                      CSD010
     D CSD010          S              1A                                                      CSD010
     D CAS006          S              1A                                                      CAS006
     D CAC005          S              1A                                                      CAS006
                                                                                              CAS006
      ** Parameters passed to ZEDIT                                                           CAS006
     D PZField         S             16A                                                      CAS006
     D PZADec          S              1  0                                                    CAS006
                                                                                              CAS006
      ** Parameters passed to/from AOBKPCR0                                                   CAS006
     D PPbok           S                   LIKE(DDPBOK)                                       CAS006
     D PPrfc           S                   LIKE(DDPRFC)                                       CAS006
     D PPsbk           S                   LIKE(DDPBOK)                                       CAS006
                                                                                              CAS006
      ** Key Fields of Midas SE Book Position Headers File                                    CAS006
     D KPssn           S                   LIKE(DDPSSN)                                       CAS006
     D KPbra           S                   LIKE(DDPBRA)                                       CAS006
     D KPbok           S                   LIKE(DDPBOK)                                       CAS006
     D KPmkt           S                   LIKE(DDPMKT)                                       CAS006
     D KBhtv           S                   LIKE(BHTV)                                         CAS006
                                                                                              CGL031
      ** Work Variables                                                                       CGL031
     D WPROT           S              1A                                                      CGL031
     D WTYPE           S              2A                                                      CGL031
     D WSITP           S              3A                                                      CGL031
     D WNMCY           S              3A                                                      CGL031
     D WISSP           S             15P 8                                                    CGL031
                                                                                              CGL031
      ** Switchable features                                                                  CGL031
     D CGL031          S              1A                                                      CGL031
 
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
     C     @INKL         IFEQ      '1'
     C                   MOVEL     'Y'           CLRSCRN           1
     C                   ELSE
     C                   MOVEL     'N'           CLRSCRN
     C                   ENDIF
 
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      * MOVE 'OK' FLAGS INTO ARRAY (FOR CHECKING)
      *
     C                   MOVEA     OKTRNDETS     @EI
      *
      * SET SCREEN ERROR INDICATORS ACCORDING TO STATUS OF 'OK' FLAGS
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUEQ     60
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
 
      ** Set up the customer reference to be used by the message handler
     C                   EVAL      TranRef = DDPSSN
     C                   EVAL      ActionCode = DDACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      * Protect all fields
     C                   MOVE      *OFF          *IN70
      *
      * POSITION CURSOR ON ACTION CODE IF IT IS BLANK
      *
     C     DDACTN        COMP      *BLANK                                 68
      *
      * ENABLE KEY FIELDS
      *
     C     @EKYFD        COMP      'Y'                                6969
      *
      * ENABLE DETAIL FIELDS
      *
     C     @EDTFD        COMP      'Y'                                7070
      *
      * ENABLE FUNCTION KEYS
      *
     C     @EINKG        COMP      'Y'                                    74
     C     @EINKH        COMP      'Y'                                    75
     C     @EINKP        COMP      'Y'                                    76
      *
      * RECORD STATUS
      *
     C     DDSTS         COMP      *BLANK                             7979
 
      * Enable Function Key - F10 Delete
     C     @EINKJ        COMP      'Y'                                    71
 
      ** Taxation of Savings Income                                                           CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
                                                                                              CGL031
     C                   EVAL      WTYPE = *Blanks                                            CGL031
                                                                                              CGL031
     C                   EXSR      PROTID                                                     CGL031
                                                                                              CGL031
     C**********         IF        WTYPE = 'FB' AND                                    CGL031 232543
     C**********                   DDPPRT = 'V '                                       CGL031 232543
                                                                                              232543
     C**********         IF        PROT <> '2' AND                                     232543 234675
     C**********                   PROT <> '4'                                         232543 234675
     C                   IF        SETX = 'Y'                                                 234675
                                                                                              CGL031
      ** Fields for CGL031 are made available                                                 CGL031
                                                                                              CGL031
     C                   EVAL      *IN92 = '1'                                                CGL031
                                                                                              233698
     C     WPROT         IFEQ      '7'                                                        233698
     C                   EVAL      *IN80 = '1'                                                233698
     C                   ELSE                                                                 233698
     C                   EVAL      *IN80 = '0'                                                233698
     C                   ENDIF                                                                233698
     C                   ELSE                                                                 CGL031
     C                   EVAL      *IN92 = '0'                                                CGL031
     C                   EVAL      *IN80 = '0'                                                233698
                                                                                              CGL031
     C                   ENDIF                                                                232543
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C**********         ENDIF                                                         CGL031 232543
                                                                                              CGL031
      * Position cursor on first field if no errors
 
     C     'N'           LOOKUP    @EI                                    73
                                                                                              CAS006
      ** If Hedge Accounting Phase B is installed, convert Current                            CAS006
      ** Net Treasury Price Field.                                                            CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y' AND DSPDTL= 'Y'                               CAS006
     C                   IF        DDPPRT = 'V'                                               CAS006
                                                                                              CAS006
     C     DDPSSN        CHAIN     SECTY                                                      CAS006
                                                                                              CAS006
     C**********         IF        NOT %FOUND(SECTY) OR RECI <> 'D'                    CAS006 228039
     C                   IF        NOT %FOUND(SECTY)                                          228039
                                                                                              CAS006
      ** DB Error Processing                                                                  CAS006
                                                                                              CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBASE = 904                                                CAS006
     C                   EVAL      DBKEY = DDPSSN                                             CAS006
     C                   EVAL      DBFILE = 'SECTY'                                           CAS006
     C                   EVAL      DBMOD  = 'SEPRCSDSP'                                       CAS006
     C                   EVAL      DBPGM  = 'SEPRCSDSP'                                       CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVE      *BLANKS       PZField                                      CAS006
     C                   MOVE      MKPN          PZField                                      CAS006
     C                   EVAL      PZaDec = 8                                                 CAS006
                                                                                              CAS006
     C                   CALLB     'ZEDIT'                                                    CAS006
     C                   PARM                    PZField                                      CAS006
     C                   PARM                    PZADec                                       CAS006
                                                                                              CAS006
     C                   EVAL      DDMKPN = PZField                                           CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        DDPPRT = 'DT' OR DDPPRT = 'DV'                             CAS006
                                                                                              CAS006
      ** Convert to pseudo book                                                               CAS006
                                                                                              CAS006
     C                   IF        CAC005 = 'Y'                                               CAS006
     C                   CALL      'AOBKPCR0'                                                 CAS006
     C                   PARM      *BLANKS       @RTCD                                        CAS006
     C                   PARM      '*PSEUDO'     @OPTN                                        CAS006
     C                   PARM      DDPBOK        PPbok                                        CAS006
     C                   PARM      DDPRFC        PPrfc                                        CAS006
     C                   PARM                    PPsbk                                        CAS006
                                                                                              CAS006
     C                   IF        @RTCD = *BLANKS                                            CAS006
     C                   EVAL      KPbok = PPsbk                                              CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      KPbok = *BLANKS                                            CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      KPbok = DDPBOK                                             CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Set up Key Fields                                                                    CAS006
                                                                                              CAS006
     C                   EVAL      KPssn = DDPSSN                                             CAS006
     C                   EVAL      KPbra = DDPBRA                                             CAS006
     C                   EVAL      KPmkt = DDPMKT                                             CAS006
     C                   MOVE      DDPPRT        KBhtv                                        CAS006
                                                                                              CAS006
     C     KBkphd        CHAIN     BKPHD                                                      CAS006
                                                                                              CAS006
     C                   IF        NOT %FOUND(BKPHD) OR RECI <> 'D'                           CAS006
                                                                                              CAS006
      ** DB Error Processing                                                                  CAS006
                                                                                              CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBASE = 905                                                CAS006
     C                   EVAL      DBKEY = KPssn + KPbra + KPbok + KPmkt + KBhtv              CAS006
     C                   EVAL      DBFILE = 'BKPHD'                                           CAS006
     C                   EVAL      DBMOD  = 'SEPRCSDSP'                                       CAS006
     C                   EVAL      DBPGM  = 'SEPRCSDSP'                                       CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVE      *BLANKS       PZField                                      CAS006
     C                   MOVE      LAVN          PZField                                      CAS006
     C                   Z-ADD     8             PZADec                                       CAS006
                                                                                              CAS006
     C                   CALLB     'ZEDIT'                                                    CAS006
     C                   PARM                    PZField                                      CAS006
     C                   PARM                    PZADec                                       CAS006
                                                                                              CAS006
     C                   EVAL      DDMKPN = PZField                                           CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** If Hedge Accounting Phase B is installed and Price Type is                           CAS006
      ** 'V', 'DT' or 'DV', display Credit Risk Spread, Liquidity                             CAS006
      ** Premium and Current Net Treasury Price fields.                                       CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y' AND (DDPPRT = 'V'                             CAS006
     C                             OR DDPPRT = 'DT' OR DDPPRT = 'DV')                         CAS006
     C                   EVAL      *IN72 = *ON                                                CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      *IN72 = *OFF                                               CAS006
     C                   ENDIF                                                                CAS006
 
      * Write message subfile, Securities Details and footer screen
     C                   TIME                    DDTIME
 
     C                   IF        CLRSCRN = 'Y'
     C                   WRITE     CLSCREEN
     C                   ENDIF
 
     C                   IF        DSPDTL= 'N'
     C                   WRITE     SEPRCSS0
     C                   WRITE     SEPRCSF1
     C                   EXFMT     SEPRCSK1
     C                   ENDIF
 
     C                   IF        DSPDTL= 'Y'
     C                   WRITE     SEPRCSK1
     C                   WRITE     SEPRCSS0
     C                   WRITE     SEPRCSF1
     C                   IF        CSD010 = 'Y'                                               CSD010
     C                   EXFMT     SEPRCSD2                                                   CSD010
     C                   ELSE                                                                 CSD010
     C                   EXFMT     SEPRCSD1
     C                   ENDIF                                                                CSD010
     C                   ENDIF
 
      * Set screen error indicators off
     C                   MOVEA     @Z0           *IN(10)
 
      * Set return keys
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKP         @INKP
      *
     C                   ENDSR
 
      ********************************************************************                    CGL031
      /EJECT                                                                                  CGL031
      *****************************************************************                       CGL031
      * PROTID - Determine if Funds or Bonds                                                  CGL031
      *****************************************************************                       CGL031
     C     PROTID        BEGSR                                                                CGL031
                                                                                              CGL031
     C     DDPSSN        CHAIN     SECTY                              90                      CGL031
                                                                                              CGL031
      ** Record Found                                                                         CGL031
                                                                                              CGL031
     C     *IN90         IFEQ      '0'                                                        CGL031
     C                   EVAL      WSITP = SITP                                               CGL031
     C                   EVAL      WNMCY = NMCY                                               CGL031
     C                   EVAL      WISSP = ISSP                                               CGL031
                                                                                              CGL031
      ** Set up key list for Investment Types file                                            CGL031
                                                                                              CGL031
     C     PROTKey       KLIST                                                                CGL031
     C                   KFLD                    WNMCY                                        CGL031
     C                   KFLD                    WSITP                                        CGL031
                                                                                              CGL031
      ** Get the processing type                                                              CGL031
                                                                                              CGL031
     C     PROTKey       CHAIN     INVTP                              90                      CGL031
                                                                                              CGL031
      ** Record Found                                                                         CGL031
                                                                                              CGL031
     C     *IN90         IFEQ      '0'                                                        CGL031
                                                                                              CGL031
     C                   EVAL      WPROT = PROT                                               CGL031
                                                                                              CGL031
     C                   IF        WPROT = '7'                                                CGL031
     C                             OR WPROT = '4' AND SETX = 'Y'                              234675
     C                   EVAL      WTYPE = 'FB'                                               CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   IF        WPROT <> '7' AND                                           CGL031
     C                             WPROT <> '4' AND                                           CGL031
     C                             WPROT <> '2' AND                                           CGL031
     C                             WISSP < 100                                                CGL031
     C                   EVAL      WTYPE = 'FB'                                               CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDSR                                                                CGL031
      *****************************************************************                       CGL031
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      ********************************************************************
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
      * INPUT PARAMETERS :
 
      * Return code
     C                   PARM                    RetCodeIn
 
      ** Transaction Details in screen format
     C                   PARM                    TRNDETS
 
      ** Transaction Details OK indicators
     C                   PARM                    OKTRNDETS
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * Enabled Function Keys
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKP            1
                                                                                              CAS006
      ** SWITCHABLE FEATURES:                                                                 CAS006
      ** ====================                                                                 CAS006
                                                                                              CAS006
      ** Profit Centre Switchable Feature                                                     CAS006
                                                                                              CAS006
     C                   PARM                    CAC005                                       CAS006
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
 
      * OUTPUT PARAMETERS :
 
      * Function Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
      * Recd status
     C                   PARM                    DDSTS
      * Clear Screen
     C                   PARM                    CLRSCRN           1
      * Display Details
     C                   PARM                    DSPDTL            1
      *
      ** Initialise module name
      *
     C                   MOVEL     'SEPRCSDSP'   DBPGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access switchable features file - Market data feed                                   CSD006
      *                                                                                       CSD006
     C                   CALLB     'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD             6                          CSD006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD006
      *                                                                                       CSD006
      ** Set screen conditioning indicator                                                    CSD006
      *                                                                                       CSD006
     C     @RTCD         IFEQ      *BLANKS                                                    CSD006
     C                   EVAL      *IN90 = '0'                                                CSD006
     C                   ELSE                                                                 CSD006
     C                   EVAL      *IN90 = '1'                                                CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD010
      ** Access switchable features file - Collateralised Lending (CSD010)                    CSD010
                                                                                              CSD010
     C                   CALLB     'AOSARDR0'                                                 CSD010
     C                   PARM      *BLANKS       PRtCd                                        CSD010
     C                   PARM      '*VERIFY'     POption                                      CSD010
     C                   PARM      'CSD010'      PSard                                        CSD010
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD010
                                                                                              CSD010
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '                    CSD010
     C                   EVAL      DBASE = 902                                                CSD010
     C                   EVAL      DBKEY = 'CSD010'                                           CSD010
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD010
     C                   EXSR      *PSSR                                                      CSD010
     C                   ENDIF                                                                CSD010
     C                                                                                        CSD010
     C                   IF        PRtCd = *BLANKS                                            CSD010
     C                   EVAL      CSD010 = 'Y'                                               CSD010
     C                   ELSE                                                                 CSD010
     C                   EVAL      CSD010 = 'N'                                               CSD010
     C                   ENDIF                                                                CSD010
                                                                                              CAS006
      ** Access switchable features file - Hedge Accounting Phase B (CAS006)                  CAS006
                                                                                              CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRtCd                                        CAS006
     C                   PARM      '*VERIFY'     POption                                      CAS006
     C                   PARM      'CAS006'      PSard                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRtCd <> *BLANKS AND PRtCd <> '*NRF   '                    CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBASE = 903                                                CAS006
     C                   EVAL      DBKEY = 'CAS006'                                           CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBMOD  = 'SEPRCSDSP'                                       CAS006
     C                   EVAL      DBPGM  = 'SEPRCSDSP'                                       CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        PRtCd  = *BLANKS                                           CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   ENDIF                                                                CAS006
 
      *
      * Check if EXTEL indicator is on, BVEXOP
 
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
 
     C                   IF        BVEXOP = 'Y'
     C                   EVAL      *IN91 = '0'
     C                   ELSE
     C                   EVAL      *IN91 = '1'
     C                   ENDIF
                                                                                              CAS006
      ** Key List for Midas SE Book Position Headers File                                     CAS006
                                                                                              CAS006
     C     KBkphd        KLIST                                                                CAS006
     C                   KFLD                    KPssn                                        CAS006
     C                   KFLD                    KPbra                                        CAS006
     C                   KFLD                    KPbok                                        CAS006
     C                   KFLD                    KPmkt                                        CAS006
     C                   KFLD                    KBhtv                                        CAS006
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
     C                   EVAL      MsgFArray(4) = 'SEUSRMSG'                                  CAS006
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SEPRCSDSP'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminate the program
      *
     C                   RETURN
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
** @Z0
000000000000000000000000000000000000000000000000000000000000
** @Z10
0000000000
