     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Cross ccy extra settlements prompt screen')   *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS module                                       *
      *                                                               *
      *  IRCXSTSIN - Cross Currency Extra Settlements Prompt Screen   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD029954           Date 25Nov14               *
      *  Prev Amend No. MD029216           Date 07Aug14               *
      *                 MD027784           Date 26Jun14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11381           Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209427             Date 12Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CIR008             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 193700             Date 23May01               *
      *                 CIR003  *CREATE    Date 12Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029954 - F3 Function Key error in Deals Enquiry            *
      *  MD029216 - Navigation Issues on Deals Enquiry for CIRS       *
      *             Transactions                                      *
      *  MD027784 - Use defaults from FRA/IRS ICD                     *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  BUG11381-Unable to correctly process after the execution     *
      *           of the Settlement screen.                           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  209427 - Screen looping when authorising a cross currency    *
      *           deal                                                *
      *  CIR008 - FRA/IRS Deals Authorisations                        *
      *  193700 - Various errors on settlement instructions           *
      *  CIR003 - Principal Exchange on Cross Currencies IRS          *
      *                                                               *
      *****************************************************************
     FIRCXSTDSDFCF   E             WORKSTN
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
     D PPAYS         E DS                  EXTNAME(SDESSPPD)
     D PRECS         E DS                  EXTNAME(SDESSRPD)
     D PRXIS         E DS                  EXTNAME(SDESSFPD)
     D  WAGVC                         2A   OVERLAY( DDAGVV )                                MD027784
     D  WAGVV                         2A   OVERLAY( DDAGVV : *NEXT )                        MD027784
     D WPPAYS        E DS                  EXTNAME(SDESSPPD)
     D                                     PREFIX(W0)
     D WPRECS        E DS                  EXTNAME(SDESSRPD)
     D                                     PREFIX(W0)
     D WPRXIS        E DS                  EXTNAME(SDESSFPD)
     D                                     PREFIX(W0)
     D WVPAYS        E DS                  EXTNAME(SDESSPPD)                                  193700
     D                                     PREFIX(W1)                                         193700
     D WVRECS        E DS                  EXTNAME(SDESSRPD)                                  193700
     D                                     PREFIX(W1)                                         193700
     D WMPAYS        E DS                  EXTNAME(SDESSPPD)                                  193700
     D                                     PREFIX(W2)                                         193700
     D WMRECS        E DS                  EXTNAME(SDESSRPD)                                  193700
     D                                     PREFIX(W2)                                         193700
     D PPAYF         E DS                  EXTNAME(SDESFPPD)
     D PRECF         E DS                  EXTNAME(SDESFRPD)
     D PRXIF         E DS                  EXTNAME(SDESFFPD)
     D ExtSett1      E DS                  EXTNAME(IRVXSETPD)
     D                                     PREFIX(E1)
     D ExtSett2      E DS                  EXTNAME(IRVXSETPD)
     D                                     PREFIX(E2)
     D**WRXIF***             654   1303                                                       CGL029
     D  WRXIF                666   1315                                                       CGL029
     D ExtSett3      E DS                  EXTNAME(IRVXSETPD)
     D                                     PREFIX(E3)
                                                                                              CIR008
      ** External DS for SAR Details                                                          CIR008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CIR008
                                                                                              CIR008
      ** Short DS for Access Programs                                                         CIR008
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CIR008
 
     D PPrEx           DS             3
     D  WVDIN                  1      1
     D  WININ                  2      2
     D  WMTIN                  3      3
 
     D PPrOk           DS             3
     D  WVDOK                  1      1
     D  WINOK                  2      2
     D  WMTOK                  3      3
 
     D RUNDAT          DS            13
     D  DDRUNA                 1      7
     D  @MBIN                 13     13
 
     D PDLNO           S              6
     D PVDEI           S              1
     D PMDEI           S              1
     D PPDEI           S              1
     D PUCCY           S              3
     D PTCCY           S              3
     D PFuncKey        S              2
     D PEvnt           S              3
     D Idx             S              2  0
     D Idx2            S              2  0
     D WEXST           S              1
                                                                                              193700
     D PTYPE           S              4                                                       193700
     D PDTYP           S              2                                                       193700
     D PISDA           S              4                                                       193700
     D PAGTY           S              6                                                       193700
     D PAGDT           S              6                                                       193700
     D PAGVV           S              2                                                       193700
     D PAGVC           S              2                                                       193700
     D WPCCY           S              3                                                       193700
     D WRCCY           S              3                                                       193700
     D WCSNM           S             10                                                       193700
     D WVFLG           S              1                                                       193700
     D WIFLG           S              1                                                       193700
     D WMFLG           S              1                                                       193700
     D WDLNO           S              6                                                       193700
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CIR008
     D CIR008          S              1                                                       CIR008
     D POption         S              7                                                       CIR008
     D PSard           S              6                                                       CIR008
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
 
     D CSW213          S              1A                                                    MD029216
     D PRTCD           S              7A                                                    MD029216
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Perform processing for the initial display of the screen
      *
     C                   EXSR      SRINIT
      *
     C     *INKC         IFEQ      '1'
     C                   MOVE      '03'          PFuncKey
     C                   ENDIF
      *
     C     *INKL         IFEQ      '1'
     C                   MOVE      '12'          PFuncKey
     C                   ENDIF
      *
     C     *INKC         DOWEQ     *OFF
     C     *INKL         ANDEQ     *OFF
     C     MODEofOP      ANDNE     '*RPR  '
     C     PACTN         ANDNE     'E'
     C     CIR008        ANDEQ     'N'                                                        CIR008
     C     *INKC         OREQ      *OFF                                                       CIR008
     C     *INKL         ANDEQ     *OFF                                                       CIR008
     C     MODEofOP      ANDNE     '*RPR  '                                                   CIR008
     C     PACTN         ANDNE     'E'                                                        CIR008
     C     PACTN         ANDNE     'X'                                                        CIR008
     C     CIR008        ANDEQ     'Y'                                                        CIR008
      *
     C                   EXSR      SRCLER
      *
     C                   MOVE      SVALD         WVDIN
     C                   MOVE      SINTD         WININ
     C                   MOVE      SMATD         WMTIN
      *
     C                   MOVE      *BLANK        WVDOK
     C                   MOVE      *BLANK        WINOK
     C                   MOVE      *BLANK        WMTOK
      *
      ** Call validation module IRVXSET01
      *
     C     PACTN         IFNE      'E'
     C     CIR008        ANDEQ     'N'                                                        CIR008
     C     PACTN         ORNE      'E'                                                        CIR008
     C     PACTN         ANDNE     'X'                                                        CIR008
     C     CIR008        ANDEQ     'Y'                                                        CIR008
      *
     C                   CALLB     'IRVXSET01'
     C                   PARM                    PVDEI
     C                   PARM                    PMDEI
     C                   PARM                    PPDEI
     C                   PARM                    PPrEx
     C                   PARM                    PPrOk
     C                   PARM                    MsgIdArr
      *
     C                   ENDIF
      *
     C     MsgIdArr(1)   IFEQ      *BLANK
     C     WVDOK         ANDEQ     *BLANK
     C     WINOK         ANDEQ     *BLANK
     C     WMTOK         ANDEQ     *BLANK
     C                   EXSR      SREXTS
     C                   ELSE
     C                   EXSR      SRPERR
     C                   ENDIF
      *
     C     PFuncKey      IFEQ      *BLANKS
     C     PRetCode      ANDEQ     *BLANKS
     C     WVDOK         ANDEQ     *BLANK
     C     WINOK         ANDEQ     *BLANK
     C     WMTOK         ANDEQ     *BLANK
      *
     C     PACTN         IFEQ      'E'
     C                   MOVE      '12'          PFuncKey
     C                   ENDIF
      *
     C                   LEAVE
     C                   ENDIF
      *
     C     PFuncKey      IFNE      '03'
      *
     C                   TIME                    STIME
     C                   WRITE     IRCXSTF0
      *
      ** Display error message
      *
     C     WEXST         IFEQ      'Y'
     C     PRetCode      ANDEQ     '*ERRORS'
      *
     C                   MOVEL     'MMM0796'     ZAMSID
      *
     C                   CALL      'ZA0240'
     C                   PARM                    ZAMSID
      *
     C                   ENDIF
      *
     C                   WRITE     #MSGCTL
     C                   READ      IRCXSTF0                               30
                                                                                              193700
     C     *INKC         IFNE      '1'                                                        193700
     C     *INKL         ANDNE     '1'                                                        193700
                                                                                              193700
     C     SVALD         IFNE      WVDIN                                                      193700
     C     SVALD         ANDEQ     'Y'                                                        193700
     C                   MOVE      'Y'           WVFLG                                        193700
     C                   ENDIF                                                                193700
                                                                                              193700
     C     SINTD         IFNE      WININ                                                      193700
     C     SINTD         ANDEQ     'Y'                                                        193700
     C                   MOVE      'Y'           WIFLG                                        193700
     C                   ENDIF                                                                193700
                                                                                              193700
     C     SMATD         IFNE      WMTIN                                                      193700
     C     SMATD         ANDEQ     'Y'                                                        193700
     C                   MOVE      'Y'           WMFLG                                        193700
     C                   ENDIF                                                                193700
                                                                                              193700
     C                   ENDIF                                                                193700
      *
     C     *INKC         IFEQ      '1'
     C                   MOVE      '03'          PFuncKey
     C                   ENDIF
      *
     C     *INKL         IFEQ      '1'
     C                   MOVE      '12'          PFuncKey
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     MODEofOP      IFEQ      '*RPR  '
     C     PACTN         OREQ      'E'
     C     PACTN         OREQ      'X'                                                        CIR008
     C     CIR008        ANDEQ     'Y'                                                        CIR008
     C                   EXSR      SRRPRF
     C                   ENDIF
     C
     C                   EVAL      RetCodeIn = PRetCode                                     BUG11381
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREXTS - Call Extended Settlements Program                    *
      *                                                               *
      *****************************************************************
      *
     C     SREXTS        BEGSR
      *
      ** Save values for restore upon insert
      *
     C**********         MOVE      PPAYS         WPPAYS                                       193700
     C**********         MOVE      PRECS         WPRECS                                       193700
     C**********         MOVE      PRXIS         WPRXIS                                       193700
      *
     C                   Z-ADD     1             Idx
      *
     C     Idx           DOUGT     3
      *
     C                   SELECT
     C     Idx           WHENEQ    1
     C                   MOVE      WVDIN         WPPrEx            1
     C     Idx           WHENEQ    2
     C                   MOVE      WININ         WPPrEx
     C     Idx           WHENEQ    3
     C                   MOVE      WMTIN         WPPrEx
     C                   ENDSL
      *
      ** Restore original values for next screen
      *
     C*****PACTN         IFEQ      'I'                                                        193700
      *
     C*****WPPAYS        IFNE      PPAYS                                                      193700
     C*****WPRECS        ORNE      PRECS                                                      193700
     C*****WPRXIS        ORNE      PRXIS                                                      193700
     C**********         MOVE      WPPAYS        PPAYS                                        193700
     C**********         MOVE      WPRECS        PRECS                                        193700
     C**********         MOVE      WPRXIS        PRXIS                                        193700
     C**********         ENDIF                                                                193700
      *
     C**********         ENDIF                                                                193700
      *
     C     WPPrEx        IFEQ      'Y'
      *
      ** Value Date flag
      *
     C     Idx           IFEQ      1
     C                   MOVE      'VAL'         PEvnt
     C                   MOVE      PUCCY         PRCCY             3
     C                   MOVE      PTCCY         PPCCY             3
      *                                                                                       193700
      ** Default settlement details when action is insert                                     193700
      *                                                                                       193700
     C     PACTN         IFEQ      'I'                                                        193700
     C     WVFLG         ANDEQ     'Y'                                                        193700
     C                   EXSR      SRSetDft                                                   193700
     C                   MOVE      'N'           WVFLG                                        193700
     C                   ELSE                                                                 193700
     C                   MOVEL     WVPAYS        PPAYS                                        193700
     C                   MOVEL     WVRECS        PRECS                                        193700
     C                   ENDIF                                                                193700
                                                                                              193700
     C                   ENDIF
      *
      ** Interest Date flag
      *
     C     Idx           IFEQ      2
     C                   MOVE      'INT'         PEvnt
     C                   MOVE      PTCCY         PRCCY
     C                   MOVE      PUCCY         PPCCY
      *                                                                                       193700
      ** Default settlement details when action is insert                                     193700
      *                                                                                       193700
     C     PACTN         IFEQ      'I'                                                        193700
     C     WIFLG         ANDEQ     'Y'                                                        193700
     C                   EXSR      SRSetDft                                                   193700
     C                   MOVE      'N'           WIFLG                                        193700
     C                   ELSE                                                                 193700
     C                   MOVEL     WPPAYS        PPAYS                                        193700
     C                   MOVEL     WPRECS        PRECS                                        193700
     C                   MOVEL     WPRXIS        PRXIS                                        193700
     C                   ENDIF                                                                193700
                                                                                              193700
     C                   ENDIF
      *
      ** Maturity Date flag
      *
     C     Idx           IFEQ      3
     C                   MOVE      'MAT'         PEvnt
     C                   MOVE      PTCCY         PRCCY
     C                   MOVE      PUCCY         PPCCY
      *                                                                                       193700
      ** Default settlement details when action is insert                                     193700
      *                                                                                       193700
     C     PACTN         IFEQ      'I'                                                        193700
     C     WMFLG         ANDEQ     'Y'                                                        193700
     C     WININ         ANDEQ     'N'                                                        193700
     C                   EXSR      SRSetDft                                                   193700
     C                   MOVE      'N'           WMFLG                                        193700
     C                   ELSE                                                                 193700
     C     PACTN         IFEQ      'I'                                                        193700
     C     WMFLG         ANDEQ     'Y'                                                        193700
     C     WININ         ANDEQ     'Y'                                                        193700
     C                   MOVEL     WPPAYS        PPAYS                                        193700
     C                   MOVEL     WPRECS        PRECS                                        193700
     C                   MOVE      'N'           WMFLG                                        193700
     C                   ELSE                                                                 193700
     C                   MOVEL     WMPAYS        PPAYS                                        193700
     C                   MOVEL     WMRECS        PRECS                                        193700
     C                   ENDIF                                                                193700
     C                   ENDIF                                                                193700
                                                                                              193700
     C                   ENDIF
      *
      ** Call module IRCXST1VL for display of extended settlement details
      *
     C                   CALLB     'IRCXST1VL'
     C                   PARM      *BLANKS       PRetCode         10
     C                   PARM                    MODEofOP
     C                   PARM                    PEvnt
     C                   PARM                    PACTN
     C                   PARM                    PDLNO
     C                   PARM                    PPAY              1
     C                   PARM                    PREC              1
     C                   PARM                    PCSNM
     C                   PARM                    PFFND
     C                   PARM                    PBRCA
     C                   PARM                    PDATR             5 0
     C                   PARM                    PDATP             5 0
     C                   PARM                    PPAYS
     C                   PARM                    PRECS
     C                   PARM                    PRXIS
     C                   PARM                    PRCCY
     C                   PARM                    PPCCY
     C                   PARM                    PPAYF
     C                   PARM                    PRECF
     C                   PARM                    PRXIF
     C                   PARM                    ExtSett1
     C                   PARM                    ExtSett2
     C                   PARM                    ExtSett3
     C                   PARM      *BLANKS       PFuncKey
                                                                                              193700
     C     PFunckey      IFNE      '03'                                                       193700
                                                                                              193700
     C                   SELECT                                                               193700
     C     PEVNT         WHENEQ    'VAL'                                                      193700
     C                   MOVEL     PPAYS         WVPAYS                                       193700
     C                   MOVEL     PRECS         WVRECS                                       193700
                                                                                              193700
     C     PEVNT         WHENEQ    'INT'                                                      193700
     C                   MOVEL     PPAYS         WPPAYS                                       193700
     C                   MOVEL     PRECS         WPRECS                                       193700
     C                   MOVEL     PRXIS         WPRXIS                                       193700
                                                                                              193700
     C     PEVNT         WHENEQ    'MAT'                                                      193700
     C                   MOVEL     PPAYS         WMPAYS                                       193700
     C                   MOVEL     PRECS         WMRECS                                       193700
     C                   ENDSL                                                                193700
     C                   ENDIF                                                                193700
      *
     C                   ENDIF
      *
     C     PFuncKey      IFEQ      '03'
     C                   MOVE      '1'           *INKC
     C                   LEAVE
     C                   ENDIF
      *
     C     PFuncKey      IFEQ      '12'
     C     CSW213        IFEQ      'Y'                                                      MD029216
     C     PACTN         ANDEQ     'E'                                                      MD029216
     C     PEVNT         ANDEQ     'VAL'                                                    MD029216
     C                   Z-ADD     0             IDX                                        MD029216
     C                   MOVE      '  '          PFuncKey                                   MD029216
     C                   ELSE                                                               MD029216
     C                   MOVE      '1'           *INKL
     C                   SUB       1             Idx
     C                   ENDIF                                                              MD029216
     C                   ENDIF
      *
     C     Idx           IFLE      0
     C                   LEAVE
     C                   ENDIF
      *
     C     PFuncKey      IFNE      '12'
     C                   ADD       1             Idx
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   MOVE      'Y'           WEXST
      *
     C     PRetCode      IFEQ      *BLANKS
      *
     C     PVDEI         IFEQ      'Y'
     C     WVDIN         ANDNE     'Y'
     C     PACTN         ANDEQ     'I'
     C     PPDEI         OREQ      'Y'
     C     WVDIN         ANDNE     'Y'
     C     PACTN         ANDEQ     'I'
     C                   CLEAR                   ExtSett1
     C                   MOVE      PDLNO         E1RXDLNO
     C                   MOVE      'VAL'         E1RXEDCD
     C                   ENDIF
      *
     C     WININ         IFNE      'Y'
     C     PACTN         ANDEQ     'I'
     C                   CLEAR                   ExtSett2
     C                   MOVE      PDLNO         E2RXDLNO
     C                   MOVE      'INT'         E2RXEDCD
      *
     C     FLISDA        IFEQ      *BLANKS
     C                   MOVEL     '1991'        FLISDA
     C                   ENDIF
      *
     C     FLAGTY        IFEQ      *BLANKS
     C                   MOVEL     'ISDA'        FLAGTY
     C                   ENDIF
      *
     C     FLAGDT        IFEQ      *BLANKS
     C                   MOVEL     '871012'      FLAGDT
     C                   ENDIF
      *
     C     FLAGVV        IFEQ      *BLANKS
     C                   MOVEL     '87'          FLAGVV
     C                   ENDIF
      *
     C     FLAGVC        IFEQ      *BLANKS
     C                   MOVEL     '19'          FLAGVC
     C                   ENDIF
     C                   MOVEL     PRXIF         WRXIF
     C                   ENDIF
      *
     C     PMDEI         IFEQ      'Y'
     C     WMTIN         ANDNE     'Y'
     C     PACTN         ANDEQ     'I'
     C     PPDEI         OREQ      'Y'
     C     WMTIN         ANDNE     'Y'
     C     PACTN         ANDEQ     'I'
     C                   CLEAR                   ExtSett3
     C                   MOVE      PDLNO         E3RXDLNO
     C                   MOVE      'MAT'         E3RXEDCD
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPERR - Process Error Messages                               *
      *                                                               *
      *****************************************************************
      *
     C     SRPERR        BEGSR
      *
     C                   Z-ADD     1             Idx
      *
      ** Display error message
      *
     C     MsgIdArr(Idx) DOWNE     *BLANKS
      *
     C                   MOVE      *BLANKS       ZAMSID           10
     C                   MOVEL     MSgIdArr(Idx) ZAMSID
      *
     C                   CALL      'ZA0240'
     C                   PARM                    ZAMSID
      *
     C                   ADD       1             Idx
      *
     C                   ENDDO
      *
     C                   Z-ADD     0             Idx
     C                   Z-ADD     20            Idx2
      *
      ** Set on error indicators
      *
     C     Idx           DOWLT     3
      *
     C                   ADD       1             Idx
     C                   ADD       1             Idx2
      *
     C                   SELECT
     C     Idx           WHENEQ    1
     C                   MOVE      WVDOk         WPPrOk            1
     C     Idx           WHENEQ    2
     C                   MOVE      WINOk         WPPrOk
     C     Idx           WHENEQ    3
     C                   MOVE      WMTOK         WPPrOk
     C                   ENDSL
      *
     C     WPPrOk        IFEQ      'N'
     C                   MOVE      '1'           *IN(Idx2)
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * SRRPRF - Call Extended Settlements Program for Repair         *
      *          and Enquiry                                          *
      *                                                               *
      *****************************************************************
     C     SRRPRF        BEGSR
     C
     C                   Z-ADD     1             Idx
      *
     C     Idx           DOUGT     3
      *
     C                   SELECT
     C     Idx           WHENEQ    1
     C                   MOVE      SVALD         WPPrEx
     C     Idx           WHENEQ    2
     C                   MOVE      SINTD         WPPrEx
     C     Idx           WHENEQ    3
     C                   MOVE      SMATD         WPPrEx
     C                   ENDSL
      *
     C     WPPrEx        IFEQ      'Y'
      *
      ** Value Date flag
      *
     C     Idx           IFEQ      1
     C                   MOVE      'VAL'         PEvnt
     C                   MOVE      PUCCY         PRCCY
     C                   MOVE      PTCCY         PPCCY
     C                   ENDIF
      *
      ** Interest Date flag
      *
     C     Idx           IFEQ      2
     C                   MOVE      'INT'         PEvnt
     C                   MOVE      PTCCY         PRCCY
     C                   MOVE      PUCCY         PPCCY
     C                   ENDIF
      *
      ** Maturity Date flag
      *
     C     Idx           IFEQ      3
     C                   MOVE      'MAT'         PEvnt
     C                   MOVE      PTCCY         PRCCY
     C                   MOVE      PUCCY         PPCCY
     C                   ENDIF
      *
      ** Call module IRCXST1VL for display of extended settlement details
      *
     C                   CALLB     'IRCXST1VL'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    MODEofOP
     C                   PARM                    PEvnt
     C                   PARM                    PACTN
     C                   PARM                    PDLNO
     C                   PARM                    PPAY
     C                   PARM                    PREC
     C                   PARM                    PCSNM
     C                   PARM                    PFFND
     C                   PARM                    PBRCA
     C                   PARM                    PDATR
     C                   PARM                    PDATP
     C                   PARM                    PPAYS
     C                   PARM                    PRECS
     C                   PARM                    PRXIS
     C                   PARM                    PRCCY
     C                   PARM                    PPCCY
     C                   PARM                    PPAYF
     C                   PARM                    PRECF
     C                   PARM                    PRXIF
     C                   PARM                    ExtSett1
     C                   PARM                    ExtSett2
     C                   PARM                    ExtSett3
     C                   PARM      *BLANKS       PFuncKey
      *
     C                   ENDIF
      *
     C     PFuncKey      IFEQ      '03'
     C                   MOVE      '1'           *INKC
     C                   LEAVE
     C                   ENDIF
      *
     C     PFuncKey      IFEQ      '12'
      ** Override if F12 was pressed on 3rd screen of ZASETINSIN                            MD029216
      ** to prevent the displaying of 2nd screen                                            MD029216
     C     CSW213        IFEQ      'Y'                                                      MD029216
     C     PACTN         ANDEQ     'E'                                                      MD029216
     C     PEVNT         ANDEQ     'MAT'                                                    MD029216
     C                   Z-ADD     0             IDX                                        MD029216
     C                   ELSE                                                               MD029216
     C                   MOVE      '1'           *INKL
     C                   SUB       1             Idx
     C                   ENDIF                                                              MD029216
     C                   ENDIF
      *
     C     Idx           IFLE      0
     C                   LEAVE
     C                   ENDIF
      *
     C     PFuncKey      IFNE      '12'
     C                   ADD       1             Idx
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     PFuncKey      IFEQ      *BLANKS
     C     PACTN         IFEQ      'E'
     C*****PACTN         OREQ      'X'                                                        209427
     C                   MOVE      '12'          PFuncKey
     C                   ENDIF
     C                   ELSE                                                               MD029216
      ** Override if F12 was pressed on 1st screen of ZASETINSIN                            MD029216
      ** to prevent the displaying of RPIF screen from DL0170                               MD029216
     C     CSW213        IFEQ      'Y'                                                      MD029216
     C     PACTN         ANDEQ     'E'                                                      MD029216
     C     PEVNT         ANDEQ     'VAL'                                                    MD029216
     C     PFuncKey      ANDEQ     '12'                                                     MD029954
     C                   Z-ADD     0             IDX                                        MD029216
     C                   MOVE      '  '          PFuncKey                                   MD029216
     C                   ENDIF                                                              MD029216
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  193700
      *****************************************************************                       193700
      *                                                               *                       193700
      * SRSetDft - Settlement Defaulting                              *                       193700
      *                                                               *                       193700
      *****************************************************************                       193700
                                                                                              193700
     C     SRSetDft      BEGSR                                                                193700
                                                                                              193700
     C                   CALLB     'ZASETINDFT'                                               193700
      *                                                                                       193700
      ** Output                                                                               193700
      ** Calling function type                                                                193700
     C                   PARM      'CIRS'        PTYPE                                        193700
      ** Payment currency (or deal cuurency if only one currency on deal)                     193700
     C                   PARM                    PPCCY                                        193700
      ** Receive currency (only if deal has two currencies)                                   193700
     C                   PARM                    PRCCY                                        193700
      ** Customer (shortname or number)                                                       193700
     C                   PARM                    PCSNM                                        193700
      ** Deal type                                                                            193700
     C                   PARM      'RX'          PDTYP                                        193700
      ** Federal Funds Ind.                                                                   193700
     C                   PARM                    PFFND                                        193700
      ** ISDA Rules for FRA/IRS deals only                                                    193700
      ** Version of ISDA Rules govern                                                         193700
     C**********         PARM                    PISDA                               193700 MD027784
     C                   PARM      DDISDA        PISDA                                      MD027784
      ** Type of ISDA agreement                                                               193700
     C**********         PARM                    PAGTY                               193700 MD027784
     C                   PARM      DDAGTY        PAGTY                                      MD027784
      ** Date of ISDA Agreement                                                               193700
     C**********         PARM                    PAGDT                               193700 MD027784
     C                   PARM      DDAGDT        PAGDT                                      MD027784
      ** Version of ISDA Agreement                                                            193700
     C**********         PARM                    PAGVV                               193700 MD027784
     C                   PARM      WAGVV         PAGVV                                      MD027784
      ** Version of ISDA Agreement century                                                    193700
     C**********         PARM                    PAGVC                               193700 MD027784
     C                   PARM      WAGVC         PAGVC                                      MD027784
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C                   PARM      *BLANK        BlankSTYP                                    CSD095
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C                   PARM      *BLANK        BlankBRCA                                    CSD095
                                                                                              193700
      ** Return                                                                               193700
      ** Defaulted Payment Settlement Instruction in file format                              193700
     C                   PARM                    PPAYF                                        193700
      ** Defaulted Receipt Settlement Instruction in file format                              193700
     C                   PARM                    PRECF                                        193700
      ** Defaulted FRA/IRS Settlement Instruction in file format                              193700
     C                   PARM                    PRXIF                                        193700
                                                                                              193700
      *  The defaulted instructions are in file format, but the                               193700
      *   Settlements validation requires that they are in the input format.                  193700
      *  Therefore run them through a conversion module.                                      193700
                                                                                              193700
     C                   CALLB     'ZASETINCVT'                                               193700
      ** Defaulted Settlement Instructions in file format                                     193700
     C                   PARM                    PPAYF                                        193700
     C                   PARM                    PRECF                                        193700
     C                   PARM                    PRXIF                                        193700
                                                                                              193700
      ** Defaulted Settlement Instruction in input format                                     193700
     C                   PARM                    PPAYS                                        193700
     C                   PARM                    PRECS                                        193700
     C                   PARM                    PRXIS                                        193700
     C                   PARM      PRCCY         InRCCY                                      CSF011A
     C                   PARM      PPCCY         InPCCY                                      CSF011A
                                                                                              193700
     C                   ENDSR                                                                193700
      *****************************************************************                       193700
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCLER - Clear Program Message Queue                          *
      *                                                               *
      *****************************************************************
      *
     C     SRCLER        BEGSR
      *
     C                   CALL      'ZA0250'
      *
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN22
     C                   MOVE      '0'           *IN23
      *
     C                   CLEAR                   MsgIdArr
     C                   MOVE      *BLANKS       PFuncKey
     C                   MOVE      *BLANKS       WEXST
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initial Processing for Screen Display                *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C                   MOVE      DDRUNA        SRUNA
     C                   MOVE      PSUser        SUSER
     C                   MOVE      PSJobName     SWSID
     C                   MOVEL     '*'           ##PGM
      *
     C                   MOVE      PDLNO         SDLNO
     C                   MOVE      '0'           *IN09
     C                   MOVE      '0'           *INKC
     C                   MOVE      '0'           *INKL
      *
     C     PACTN         IFEQ      'I'
     C     MODEofOP      ANDNE     '*RPR  '
     C                   CLEAR                   ExtSett1
     C                   CLEAR                   ExtSett2
     C                   CLEAR                   ExtSett3
     C                   MOVE      'Y'           SVALD
     C                   MOVE      'Y'           SINTD
     C                   MOVE      'Y'           SMATD
     C     PDLNO         IFNE      WDLNO                                                      193700
     C     PCSNM         ORNE      WCSNM                                                      193700
     C     PPCCY         ORNE      WPCCY                                                      193700
     C     PRCCY         ORNE      WRCCY                                                      193700
     C                   MOVE      PCSNM         WCSNM                                        193700
     C                   MOVE      PPCCY         WPCCY                                        193700
     C                   MOVE      PRCCY         WRCCY                                        193700
     C                   MOVE      'Y'           WVFLG                                        193700
     C                   MOVE      'Y'           WIFLG                                        193700
     C                   MOVE      'Y'           WMFLG                                        193700
     C                   ENDIF                                                                193700
     C                   ENDIF
      *
     C     PACTN         IFEQ      'E'
     C     PACTN         OREQ      'A'
     C     MODEofOP      OREQ      '*RPR  '
     C     PACTN         OREQ      'X'                                                        CIR008
     C     CIR008        ANDEQ     'Y'                                                        CIR008
      *
     C                   MOVE      'N'           SVALD
     C                   MOVE      'N'           SMATD
     C                   MOVE      'Y'           SINTD
      *
     C     PVDEI         IFEQ      'Y'
     C     PPDEI         OREQ      'Y'
     C                   MOVE      'Y'           SVALD
     C                   ENDIF
      *
     C     PMDEI         IFEQ      'Y'
     C     PPDEI         OREQ      'Y'
     C                   MOVE      'Y'           SMATD
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      PDLNO         WDLNO                                        193700
     C     MODEofOP      IFNE      '*RPR  '
     C     PACTN         ANDNE     'E'
     C     CIR008        ANDEQ     'N'                                                        CIR008
     C     MODEofOP      ORNE      '*RPR  '                                                   CIR008
     C     PACTN         ANDNE     'E'                                                        CIR008
     C     PACTN         ANDNE     'X'                                                        CIR008
     C     CIR008        ANDEQ     'Y'                                                        CIR008
     C                   TIME                    STIME
     C                   WRITE     IRCXSTF0
     C                   WRITE     #MSGCTL
     C                   READ      IRCXSTF0                               30
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Routine                                      *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    MODEofOP          6
     C                   PARM                    PACTN             1
     C                   PARM                    PDLNO
     C                   PARM                    PPPAY             1
     C                   PARM                    PPREC             1
     C                   PARM                    PCSNM            10
     C                   PARM                    PFFND             1
     C                   PARM                    PBRCA             3
     C                   PARM                    PDATR
     C                   PARM                    PDATP
     C                   PARM                    PPAYS
     C                   PARM                    PRECS
     C                   PARM                    PRXIS
     C                   PARM                    PVDEI
     C                   PARM                    PMDEI
     C                   PARM                    PPDEI
     C                   PARM                    PUCCY
     C                   PARM                    PTCCY
     C                   PARM                    PPREX
     C                   PARM                    PPAYF
     C                   PARM                    PRECF
     C                   PARM                    PRXIF
     C                   PARM                    ExtSett1
     C                   PARM                    ExtSett2
     C                   PARM                    ExtSett3
     C                   PARM                    PFuncKey
                                                                                              CIR008
      ** Check if FRA/IRS Deals Authorisations is installed                                   CIR008
                                                                                              CIR008
     C                   EVAL      CIR008 = 'N'                                               CIR008
     C                   CALL      'AOSARDR0'                                                 CIR008
     C                   PARM      *BLANKS       PRetCode                                     CIR008
     C                   PARM      '*VERIFY'     POption                                      CIR008
     C                   PARM      'CIR008'      PSard                                        CIR008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR008
                                                                                              CIR008
     C                   IF        PRetCode = *BLANKS                                         CIR008
     C                   EVAL      CIR008 = 'Y'                                               CIR008
     C                   ELSE                                                                 CIR008
     C                   IF        PRetCode <> '*NRF   '                                      CIR008
     C     *LOCK         IN        LDA                                                        CIR008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR008
     C                   EVAL      DBASE = 1                                                  CIR008
     C                   EVAL      DBKEY = 'CIR008'                                           CIR008
     C                   OUT       LDA                                                        CIR008
     C                   EXSR      *PSSR                                                      CIR008
     C                   ENDIF                                                                CIR008
     C                   ENDIF                                                                CIR008
      *                                                                                     MD029216
      ** Check if SWIFT 2013  is on                                                         MD029216
      *                                                                                     MD029216
     C                   CALL      'SWIF2013'                                               MD029216
     C                   PARM      *BLANKS       PRTCD                                      MD029216
      *                                                                                     MD029216
     C                   IF        PRTCD = 'CSW2013'                                        MD029216
     C                   EVAL      CSW213  = 'Y'                                            MD029216
     C                   ELSE                                                               MD029216
     C                   EVAL      CSW213  = 'N'                                            MD029216
     C                   ENDIF                                                              MD029216
      *
     C                   ENDSR
      *
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
