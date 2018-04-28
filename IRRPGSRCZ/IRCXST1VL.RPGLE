     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Cross ccy swaps extra settlement inst.')      *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS module                                       *
      *                                                               *
      *  IRCXST1VL - Cross Ccy Swaps Extra Settlement Instructions    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL094             Date 11Jun14               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15233           Date 03Nov07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA071             Date 24Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 31Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 193700             Date 23May01               *
      *                 CIR003  *CREATE    Date 12Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15233 - Agreement Version year missing after input in CIRS*
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA071 - Include branch in the settlement account for        *
      *           settlement method 05.                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Correct parameters on program calls                 *
      *  193700 - Various errors on settlement instructions           *
      *  CIR003 - Principal Exchange on Cross Currencies IRS          *
      *                                                               *
      *****************************************************************
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D PPAYS         E DS                  EXTNAME(SDESSPPD)
     D PRECS         E DS                  EXTNAME(SDESSRPD)
     D PRXIS         E DS                  EXTNAME(SDESSFPD)
     D PPAYF         E DS                  EXTNAME(SDESFPPD)
     D PRECF         E DS                  EXTNAME(SDESFRPD)
     D PRXIF         E DS                  EXTNAME(SDESFFPD)
     D ExtSett1      E DS                  EXTNAME(IRVXSETPD)
     D                                     PREFIX(E1)
     D ExtSett2      E DS                  EXTNAME(IRVXSETPD)
     D                                     PREFIX(E2)
     D**WPRECF**              10     84                                                       CGL029
     D**WPPAYF**              85    653                                                       CGL029
     D**WPRXIF**             654   1303                                                       CGL029
     D  WPRECF                10     90                                                       CGL029
     D  WPPAYF                91    665                                                       CGL029
     D  WPRXIF               666   1315                                                       CGL029
 
     D ExtSett3      E DS                  EXTNAME(IRVXSETPD)
     D                                     PREFIX(E3)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D PDLNO           S              6
     D PVDEI           S              1
     D PMDEI           S              1
     D PPDEI           S              1
     D PRCCY           S              3
     D PPCCY           S              3
     D @MORPI          DS
      ** Midas Our Receive / Pay  Instructions (for Settl Meth = 04 )
     D  @@MORI                 1     12
     D  @@MOPI                13     24
                                                                                              193700
     D WFLGV           S              1                                                       193700
     D WFLGI           S              1                                                       193700
     D WFLGM           S              1                                                       193700
     D WDEAL           S              6                                                       193700
     D WACTN           S              1                                                       193700
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     C*****PACTN         IFEQ      'A'                                                        193700
     C*****PACTN         OREQ      'E'                                                        193700
     C     PACTN         IFEQ      'E'                                                        193700
     C     PACTN         OREQ      'X'
     C                   CLEAR                   PPAYS
     C                   CLEAR                   PRECS
     C                   CLEAR                   PRXIS
     C                   ENDIF
                                                                                              193700
     C     PACTN         IFEQ      'A'                                                        193700
     C     PDLNO         IFNE      WDEAL                                                      193700
     C     PACTN         OREQ      WACTN                                                      193700
     C                   MOVE      PDLNO         WDEAL                                        193700
     C                   MOVE      PACTN         WACTN                                        193700
     C                   MOVE      'Y'           WFLGV                                        193700
     C                   MOVE      'Y'           WFLGI                                        193700
     C                   MOVE      'Y'           WFLGM                                        193700
     C                   ENDIF                                                                193700
     C                   ENDIF                                                                193700
      *
      ** Move fields from DLGXSTPD
      *
     C     PEVNT         IFEQ      'VAL'
     C                   MOVE      'CXSV'        CXST              4
     C     PACTN         IFNE      'I'
     C     PACTN         ANDNE     'A'                                                        193700
     C     MODEofOP      OREQ      '*RPR  '
     C     PACTN         ANDEQ     'X'                                                        193700
     C*****PACTN         OREQ      'I'                                                        193700
     C*****@INKL         ANDEQ     '1'                                                        193700
     C     PACTN         OREQ      'A'                                                        193700
     C     WFLGV         ANDEQ     'Y'                                                        193700
     C                   EXSR      SRMOV1
     C                   MOVE      'N'           WFLGV                                        193700
     C                   ENDIF
     C                   ENDIF
      *
     C     PEVNT         IFEQ      'INT'
     C                   MOVE      'CIRS'        CXST
     C     PACTN         IFNE      'I'
     C     PACTN         ANDNE     'A'                                                        193700
     C     MODEofOP      OREQ      '*RPR  '
     C     PACTN         ANDEQ     'X'                                                        193700
     C*****PACTN         OREQ      'I'                                                        193700
     C*****@INKL         ANDEQ     '1'                                                        193700
     C     PACTN         OREQ      'A'                                                        193700
     C     WFLGI         ANDEQ     'Y'                                                        193700
     C                   EXSR      SRMOV2
     C                   MOVE      'N'           WFLGI                                        193700
     C                   ENDIF
     C                   ENDIF
      *
     C     PEVNT         IFEQ      'MAT'
     C                   MOVE      'CXSM'        CXST
     C     PACTN         IFNE      'I'
     C     PACTN         ANDNE     'A'                                                        193700
     C     MODEofOP      OREQ      '*RPR  '
     C     PACTN         ANDEQ     'X'                                                        193700
     C*****PACTN         OREQ      'I'                                                        193700
     C*****@INKL         ANDEQ     '1'                                                        193700
     C     PACTN         OREQ      'A'                                                        193700
     C     WFLGM         ANDEQ     'Y'                                                        193700
     C                   EXSR      SRMOV3
     C                   MOVE      'N'           WFLGM                                        193700
     C                   ENDIF
     C                   ENDIF
      *
      ** Call ZASETINSIN for display of settlement instructions
      *
     C                   CALLB     'ZASETINSIN'
     C                   PARM      *Blanks       PRetCode         10
     C                   PARM                    PACTN             1
     C                   PARM                    PDLNO             6
     C                   PARM                    PPAY              1
     C                   PARM                    PREC              1
     C                   PARM      CXST          PCALP             4
     C                   PARM                    PPCCY             3
     C                   PARM                    PRCCY             3
     C                   PARM                    PCSNM            10
     C                   PARM      'RX'          PTTYP             2
     C                   PARM                    PFFND             1
     C                   PARM                    PBRCA             3
     C                   PARM                    PDATR             5 0
     C                   PARM                    PDATP             5 0
     C                   PARM                    PPAYS
     C                   PARM                    PRECS
     C                   PARM                    PRXIS
     C                   PARM                    PPAYF
     C                   PARM                    PRECF
     C                   PARM                    PRXIF
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
     C*******************PARM                    @MORPI                                       222373
      *
      ** Update valid file IRVXSETPD
      *
     C     PRetCode      IFEQ      *BLANKS
     C     @INKC         ANDNE     '1'
     C     @INKL         ANDNE     '1'
     C     PACTN         ANDNE     'E'
     C     PACTN         ANDNE     'X'
      *
     C     PEVNT         IFEQ      'VAL'
     C                   EXSR      SRUPD1
     C                   ENDIF
      *
     C     PEVNT         IFEQ      'INT'
     C                   EXSR      SRUPD2
     C                   ENDIF
      *
     C     PEVNT         IFEQ      'MAT'
     C                   EXSR      SRUPD3
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check output
      *
     C     @INKC         IFEQ      '1'
     C                   MOVE      '03'          PFuncKey
     C                   ENDIF
      *
     C     @INKL         IFEQ      '1'
     C                   MOVE      '12'          PFuncKey
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMOV1 - Move Fields for Value Date                           *
      *                                                               *
      *****************************************************************
      *
     C     SRMOV1        BEGSR
      *
     C                   CLEAR                   PPAYS
     C                   CLEAR                   PRECS
     C                   CLEAR                   PRXIS
      *
     C                   MOVEL     E1RXRSTM      DDRSTM
     C     DDRSTM        IFNE      '05'                                                       TDA071
     C                   MOVEL     E1RXRONS      DDRONX
     C                   ELSE                                                                 TDA071
     C                   MOVEL     E1RXROBR      DDRONX                                       TDA071
     C                   MOVE      E1RXRONS      DDRONX                                       TDA071
     C                   ENDIF                                                                TDA071
      *
     C                   CLEAR                   DDRIBN
     C     E1RXRIBN      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E1RXRIBN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDRIBN
     C                   ENDIF
      *
     C                   MOVEL     E1RXRIBA      DDRIBA
      *
     C                   CLEAR                   DDROBN
     C*****E1RXROBN      IFNE      0                                                          CSD027
     C     E1RXROBN      IFNE      *BLANKS                                                    CSD027
     C                   CLEAR                   WKEY1
     C                   MOVEL     E1RXROBN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDROBN
     C                   ENDIF
      *
     C                   CLEAR                   DDROCN
     C*****E1RXROCN      IFNE      0                                                          CSD027
     C     E1RXROCN      IFNE      *BLANKS                                                    CSD027
     C                   CLEAR                   WKEY1
     C                   MOVEL     E1RXROCN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDROCN
     C                   ENDIF
      *
     C                   MOVEL     E1RXRSCY      DDRSCY
     C                   MOVEL     E1RXPSTM      DDPSTM
     C     DDPSTM        IFNE      '05'                                                       TDA071
     C                   MOVEL     E1RXPONS      DDPONX
     C                   ELSE                                                                 TDA071
     C                   MOVEL     E1RXPOBR      DDPONX                                       TDA071
     C                   MOVE      E1RXPONS      DDPONX                                       TDA071
     C                   ENDIF                                                                TDA071
      *
     C                   CLEAR                   DDPIBN
     C     E1RXPIBN      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E1RXPIBN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDPIBN
     C                   ENDIF
      *
     C                   MOVEL     E1RXPIBA      DDPIBA
      *
     C                   CLEAR                   DDPOBN
     C*****E1RXPOBN      IFNE      0                                                          CSD027
     C     E1RXPOBN      IFNE      *BLANKS                                                    CSD027
     C                   CLEAR                   WKEY1
     C                   MOVEL     E1RXPOBN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDPOBN
     C                   ENDIF
      *
     C                   CLEAR                   DDPOCN
     C*****E1RXPOCN      IFNE      0                                                          CSD027
     C     E1RXPOCN      IFNE      *BLANKS                                                    CSD027
     C                   CLEAR                   WKEY1
     C                   MOVEL     E1RXPOCN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDPOCN
     C                   ENDIF
      *
     C                   CLEAR                   DDRCRN
     C     E1RXRCRN      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E1RXRCRN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDRCRN
     C                   ENDIF
      *
     C                   MOVEL     E1RXRCRA      DDRCRA
      *
     C                   CLEAR                   DDRVNO
     C     E1RXRVNO      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E1RXRVNO      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDRVNO
     C                   ENDIF
      *
     C                   CLEAR                   DDAWBN
     C     E1RXAWBN      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E1RXAWBN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDAWBN
     C                   ENDIF
      *
     C                   MOVEL     E1RXAWBA      DDAWBA
      *
     C                   CLEAR                   DDBENN
     C     E1RXBENN      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E1RXBENN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDBENN
     C                   ENDIF
      *
     C                   MOVEL     E1RXBENA      DDBENA
     C                   MOVEL     E1RXDTP1      DDDTP1
     C                   MOVEL     E1RXDTP2      DDDTP2
     C                   MOVEL     E1RXDTP3      DDDTP3
     C                   MOVEL     E1RXDTP4      DDDTP4
     C                   MOVEL     E1RXDCHG      DDDCHG
     C                   MOVEL     E1RXBTB1      DDBTB1
     C                   MOVEL     E1RXBTB2      DDBTB2
     C                   MOVEL     E1RXBTB3      DDBTB3
     C                   MOVEL     E1RXBTB4      DDBTB4
     C                   MOVEL     E1RXBTB5      DDBTB5
     C                   MOVEL     E1RXBTB6      DDBTB6
     C                   MOVEL     E1RXCVMR      DDCVMR
     C                   MOVEL     E1RXPSCY      DDPSCY
     C                   MOVEL     E1RXIC72      DDIC72
     C                   MOVEL     E1RXDSR1      DDDSR1
     C                   MOVEL     E1RXDSR2      DDDSR2
     C                   MOVEL     E1RXDSR3      DDDSR3
     C                   MOVEL     E1RXDSR4      DDDSR4
     C                   MOVEL     E1RXDSR5      DDDSR5
     C                   MOVEL     E1RXDSR6      DDDSR6
     C                   MOVEL     E1RXSSR1      DDSSR1
     C                   MOVEL     E1RXSSR2      DDSSR2
     C                   MOVEL     E1RXSSR3      DDSSR3
     C                   MOVEL     E1RXSSR4      DDSSR4
     C                   MOVEL     E1RXSSR5      DDSSR5
     C                   MOVEL     E1RXSSR6      DDSSR6
     C                   MOVEL     E1RXCND1      DDCND1
     C                   MOVEL     E1RXCND2      DDCND2
     C                   MOVEL     E1RXCND3      DDCND3
     C                   MOVEL     E1RXCND4      DDCND4
     C                   MOVEL     E1RXCND5      DDCND5
     C                   MOVEL     E1RXCND6      DDCND6
      *
     C                   MOVE      *BLANKS       DDISDA
     C                   MOVEL     *BLANKS       DDAGTY
     C                   MOVE      *BLANKS       DDAGDT
     C                   MOVE      *BLANKS       DDAGVV
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMOV2 - Move Fields for Interest Date                        *
      *                                                               *
      *****************************************************************
      *
     C     SRMOV2        BEGSR
      *
     C                   CLEAR                   PPAYS
     C                   CLEAR                   PRECS
     C                   CLEAR                   PRXIS
      *
     C                   MOVEL     E2RXRSTM      DDRSTM
     C     DDRSTM        IFNE      '05'                                                       TDA071
     C                   MOVEL     E2RXRONS      DDRONX
     C                   ELSE                                                                 TDA071
     C                   MOVEL     E2RXROBR      DDRONX                                       TDA071
     C                   MOVE      E2RXRONS      DDRONX                                       TDA071
     C                   ENDIF                                                                TDA071
      *
     C                   CLEAR                   DDRIBN
     C     E2RXRIBN      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E2RXRIBN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDRIBN
     C                   ENDIF
      *
     C                   MOVEL     E2RXRIBA      DDRIBA
      *
     C                   CLEAR                   DDROBN
     C*****E2RXROBN      IFNE      0                                                          CSD027
     C     E2RXROBN      IFNE      *BLANKS                                                    CSD027
     C                   CLEAR                   WKEY1
     C                   MOVEL     E2RXROBN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDROBN
     C                   ENDIF
      *
     C                   CLEAR                   DDROCN
     C*****E2RXROCN      IFNE      0                                                          CSD027
     C     E2RXROCN      IFNE      *BLANKS                                                    CSD027
     C                   CLEAR                   WKEY1
     C                   MOVEL     E2RXROCN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDROCN
     C                   ENDIF
      *
     C                   MOVEL     E2RXRSCY      DDRSCY
     C                   MOVEL     E2RXPSTM      DDPSTM
     C     DDPSTM        IFNE      '05'                                                       TDA071
     C                   MOVEL     E2RXPONS      DDPONX
     C                   ELSE                                                                 TDA071
     C                   MOVEL     E2RXPOBR      DDPONX                                       TDA071
     C                   MOVE      E2RXPONS      DDPONX                                       TDA071
     C                   ENDIF                                                                TDA071
      *
     C                   CLEAR                   DDPIBN
     C     E2RXPIBN      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E2RXPIBN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDPIBN
     C                   ENDIF
      *
     C                   MOVEL     E2RXPIBA      DDPIBA
      *
     C                   CLEAR                   DDPOBN
     C*****E2RXPOBN      IFNE      0                                                          CSD027
     C     E2RXPOBN      IFNE      *BLANKS                                                    CSD027
     C                   CLEAR                   WKEY1
     C                   MOVEL     E2RXPOBN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDPOBN
     C                   ENDIF
      *
     C                   CLEAR                   DDPOCN
     C*****E2RXPOCN      IFNE      0                                                          CSD027
     C     E2RXPOCN      IFNE      *BLANKS                                                    CSD027
     C                   CLEAR                   WKEY1
     C                   MOVEL     E2RXPOCN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDPOCN
     C                   ENDIF
      *
     C                   CLEAR                   DDRCRN
     C     E2RXRCRN      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E2RXRCRN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDRCRN
     C                   ENDIF
      *
     C                   MOVEL     E2RXRCRA      DDRCRA
      *
     C                   CLEAR                   DDRVNO
     C     E2RXRVNO      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E2RXRVNO      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDRVNO
     C                   ENDIF
      *
     C                   CLEAR                   DDAWBN
     C     E2RXAWBN      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E2RXAWBN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDAWBN
     C                   ENDIF
      *
     C                   MOVEL     E2RXAWBA      DDAWBA
      *
     C                   CLEAR                   DDBENN
     C     E2RXBENN      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E2RXBENN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDBENN
     C                   ENDIF
      *
     C                   MOVEL     E2RXBENA      DDBENA
     C                   MOVEL     E2RXDTP1      DDDTP1
     C                   MOVEL     E2RXDTP2      DDDTP2
     C                   MOVEL     E2RXDTP3      DDDTP3
     C                   MOVEL     E2RXDTP4      DDDTP4
     C                   MOVEL     E2RXDCHG      DDDCHG
     C                   MOVEL     E2RXBTB1      DDBTB1
     C                   MOVEL     E2RXBTB2      DDBTB2
     C                   MOVEL     E2RXBTB3      DDBTB3
     C                   MOVEL     E2RXBTB4      DDBTB4
     C                   MOVEL     E2RXBTB5      DDBTB5
     C                   MOVEL     E2RXBTB6      DDBTB6
     C                   MOVEL     E2RXCVMR      DDCVMR
     C                   MOVEL     E2RXPSCY      DDPSCY
     C                   MOVEL     E2RXIC72      DDIC72
     C                   MOVEL     E2RXDSR1      DDDSR1
     C                   MOVEL     E2RXDSR2      DDDSR2
     C                   MOVEL     E2RXDSR3      DDDSR3
     C                   MOVEL     E2RXDSR4      DDDSR4
     C                   MOVEL     E2RXDSR5      DDDSR5
     C                   MOVEL     E2RXDSR6      DDDSR6
     C                   MOVEL     E2RXSSR1      DDSSR1
     C                   MOVEL     E2RXSSR2      DDSSR2
     C                   MOVEL     E2RXSSR3      DDSSR3
     C                   MOVEL     E2RXSSR4      DDSSR4
     C                   MOVEL     E2RXSSR5      DDSSR5
     C                   MOVEL     E2RXSSR6      DDSSR6
     C                   MOVEL     E2RXCND1      DDCND1
     C                   MOVEL     E2RXCND2      DDCND2
     C                   MOVEL     E2RXCND3      DDCND3
     C                   MOVEL     E2RXCND4      DDCND4
     C                   MOVEL     E2RXCND5      DDCND5
     C                   MOVEL     E2RXCND6      DDCND6
      *
     C     E2RXISDA      IFEQ      0
     C                   MOVE      *BLANKS       DDISDA
     C                   ELSE
     C                   MOVEL     E2RXISDA      DDISDA
     C                   ENDIF
      *
     C                   MOVEL     E2RXAGTY      DDAGTY
      *
     C     E2RXAGDT      IFEQ      0
     C                   MOVE      *BLANKS       DDAGDT
     C                   ELSE
     C                   MOVEL     E2RXAGDT      DDAGDT
     C                   ENDIF
      *
     C     E2RXAGVV      IFEQ      0
     C     E2RXAGVC      ANDEQ     0                                                        BUG15233
     C                   MOVE      *BLANKS       DDAGVV
     C                   ELSE
     C                   MOVEL     E2RXAGVC      DDAGVV
     C                   MOVE      E2RXAGVV      DDAGVV
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMOV3 - Move Fields for Maturity Date                        *
      *                                                               *
      *****************************************************************
      *
     C     SRMOV3        BEGSR
      *
     C                   CLEAR                   PPAYS
     C                   CLEAR                   PRECS
     C                   CLEAR                   PRXIS
      *
     C                   MOVEL     E3RXRSTM      DDRSTM
     C     DDRSTM        IFNE      '05'                                                       TDA071
     C                   MOVEL     E3RXRONS      DDRONX
     C                   ELSE                                                                 TDA071
     C                   MOVEL     E3RXROBR      DDRONX                                       TDA071
     C                   MOVE      E3RXRONS      DDRONX                                       TDA071
     C                   ENDIF                                                                TDA071
      *
     C                   CLEAR                   DDRIBN
     C     E3RXRIBN      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E3RXRIBN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDRIBN
     C                   ENDIF
      *
     C                   MOVEL     E3RXRIBA      DDRIBA
      *
     C                   CLEAR                   DDROBN
     C*****E3RXROBN      IFNE      0                                                          CSD027
     C     E3RXROBN      IFNE      *BLANKS                                                    CSD027
     C                   CLEAR                   WKEY1
     C                   MOVEL     E3RXROBN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDROBN
     C                   ENDIF
      *
     C                   CLEAR                   DDROCN
     C*****E3RXROCN      IFNE      0                                                          CSD027
     C     E3RXROCN      IFNE      *BLANKS                                                    CSD027
     C                   CLEAR                   WKEY1
     C                   MOVEL     E3RXROCN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDROCN
     C                   ENDIF
      *
     C                   MOVEL     E3RXRSCY      DDRSCY
     C                   MOVEL     E3RXPSTM      DDPSTM
     C     DDPSTM        IFNE      '05'                                                       TDA071
     C                   MOVEL     E3RXPONS      DDPONX
     C                   ELSE                                                                 TDA071
     C                   MOVEL     E3RXPOBR      DDPONX                                       TDA071
     C                   MOVE      E3RXPONS      DDPONX                                       TDA071
     C                   ENDIF                                                                TDA071
      *
     C                   CLEAR                   DDPIBN
     C     E3RXPIBN      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E3RXPIBN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDPIBN
     C                   ENDIF
      *
     C                   MOVEL     E3RXPIBA      DDPIBA
      *
     C                   CLEAR                   DDPOBN
     C*****E3RXPOBN      IFNE      0                                                          CSD027
     C     E3RXPOBN      IFNE      *BLANKS                                                    CSD027
     C                   CLEAR                   WKEY1
     C                   MOVEL     E3RXPOBN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDPOBN
     C                   ENDIF
      *
     C                   CLEAR                   DDPOCN
     C*****E3RXPOCN      IFNE      0                                                          CSD027
     C     E3RXPOCN      IFNE      *BLANKS                                                    CSD027
     C                   CLEAR                   WKEY1
     C                   MOVEL     E3RXPOCN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDPOCN
     C                   ENDIF
      *
     C                   CLEAR                   DDRCRN
     C     E3RXRCRN      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E3RXRCRN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDRCRN
     C                   ENDIF
      *
     C                   MOVEL     E3RXRCRA      DDRCRA
      *
     C                   CLEAR                   DDRVNO
     C     E3RXRVNO      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E3RXRVNO      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDRVNO
     C                   ENDIF
      *
     C                   CLEAR                   DDAWBN
     C     E3RXAWBN      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E3RXAWBN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDAWBN
     C                   ENDIF
      *
     C                   MOVEL     E3RXAWBA      DDAWBA
      *
     C                   CLEAR                   DDBENN
     C     E3RXBENN      IFNE      *BLANKS
     C                   CLEAR                   WKEY1
     C                   MOVEL     E3RXBENN      WKEY1
     C                   EXSR      SRCONV
     C                   MOVEL     WKEY1         DDBENN
     C                   ENDIF
      *
     C                   MOVEL     E3RXBENA      DDBENA
     C                   MOVEL     E3RXDTP1      DDDTP1
     C                   MOVEL     E3RXDTP2      DDDTP2
     C                   MOVEL     E3RXDTP3      DDDTP3
     C                   MOVEL     E3RXDTP4      DDDTP4
     C                   MOVEL     E3RXDCHG      DDDCHG
     C                   MOVEL     E3RXBTB1      DDBTB1
     C                   MOVEL     E3RXBTB2      DDBTB2
     C                   MOVEL     E3RXBTB3      DDBTB3
     C                   MOVEL     E3RXBTB4      DDBTB4
     C                   MOVEL     E3RXBTB5      DDBTB5
     C                   MOVEL     E3RXBTB6      DDBTB6
     C                   MOVEL     E3RXCVMR      DDCVMR
     C                   MOVEL     E3RXPSCY      DDPSCY
     C                   MOVEL     E3RXIC72      DDIC72
     C                   MOVEL     E3RXDSR1      DDDSR1
     C                   MOVEL     E3RXDSR2      DDDSR2
     C                   MOVEL     E3RXDSR3      DDDSR3
     C                   MOVEL     E3RXDSR4      DDDSR4
     C                   MOVEL     E3RXDSR5      DDDSR5
     C                   MOVEL     E3RXDSR6      DDDSR6
     C                   MOVEL     E3RXSSR1      DDSSR1
     C                   MOVEL     E3RXSSR2      DDSSR2
     C                   MOVEL     E3RXSSR3      DDSSR3
     C                   MOVEL     E3RXSSR4      DDSSR4
     C                   MOVEL     E3RXSSR5      DDSSR5
     C                   MOVEL     E3RXSSR6      DDSSR6
     C                   MOVEL     E3RXCND1      DDCND1
     C                   MOVEL     E3RXCND2      DDCND2
     C                   MOVEL     E3RXCND3      DDCND3
     C                   MOVEL     E3RXCND4      DDCND4
     C                   MOVEL     E3RXCND5      DDCND5
     C                   MOVEL     E3RXCND6      DDCND6
      *
     C                   MOVE      *BLANKS       DDISDA
     C                   MOVEL     *BLANKS       DDAGTY
     C                   MOVE      *BLANKS       DDAGDT
     C                   MOVE      *BLANKS       DDAGVV
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPD1 - Update Routine for Value Date                        *
      *                                                               *
      *****************************************************************
      *
     C     SRUPD1        BEGSR
      *
     C                   MOVE      PDLNO         E1RXDLNO
     C                   MOVE      PEVNT         E1RXEDCD
     C                   Z-ADD     FLRSTM        E1RXRSTM
     C                   MOVE      FLRONS        E1RXRONS
     C                   MOVE      FLRIBN        E1RXRIBN
     C                   MOVE      FLRIBA        E1RXRIBA
     C**********         Z-ADD     FLROBN        E1RXROBN                                     CSD027
     C**********         Z-ADD     FLROCN        E1RXROCN                                     CSD027
     C                   EVAL      E1RXROBN = FLROBN                                          CSD027
     C                   EVAL      E1RXROCN = FLROCN                                          CSD027
     C                   MOVE      FLROBR        E1RXROBR
     C                   MOVE      FLRSCY        E1RXRSCY
     C                   Z-ADD     FLPSTM        E1RXPSTM
     C                   MOVE      FLPONS        E1RXPONS
     C                   MOVE      FLPIBN        E1RXPIBN
     C                   MOVE      FLPIBA        E1RXPIBA
     C**********         Z-ADD     FLPOBN        E1RXPOBN                                     CSD027
     C**********         Z-ADD     FLPOCN        E1RXPOCN                                     CSD027
     C                   EVAL      E1RXPOBN = FLPOBN                                          CSD027
     C                   EVAL      E1RXPOCN = FLPOCN                                          CSD027
     C                   MOVE      FLRCRN        E1RXRCRN
     C                   MOVE      FLRCRA        E1RXRCRA
     C                   MOVE      FLRVNO        E1RXRVNO
     C                   MOVE      FLAWBN        E1RXAWBN
     C                   MOVE      FLAWBA        E1RXAWBA
     C                   MOVE      FLBENN        E1RXBENN
     C                   MOVE      FLBENA        E1RXBENA
     C                   MOVE      FLDTP1        E1RXDTP1
     C                   MOVE      FLDTP2        E1RXDTP2
     C                   MOVE      FLDTP3        E1RXDTP3
     C                   MOVE      FLDTP4        E1RXDTP4
     C                   MOVE      FLDCHG        E1RXDCHG
     C                   MOVE      FLBTB1        E1RXBTB1
     C                   MOVE      FLBTB2        E1RXBTB2
     C                   MOVE      FLBTB3        E1RXBTB3
     C                   MOVE      FLBTB4        E1RXBTB4
     C                   MOVE      FLBTB5        E1RXBTB5
     C                   MOVE      FLBTB6        E1RXBTB6
     C                   MOVE      FLCVMR        E1RXCVMR
     C                   MOVE      FLPOBR        E1RXPOBR
     C                   MOVE      FLPSCY        E1RXPSCY
     C                   MOVE      FLIC72        E1RXIC72
     C                   MOVE      FLDSR1        E1RXDSR1
     C                   MOVE      FLDSR2        E1RXDSR2
     C                   MOVE      FLDSR3        E1RXDSR3
     C                   MOVE      FLDSR4        E1RXDSR4
     C                   MOVE      FLDSR5        E1RXDSR5
     C                   MOVE      FLDSR6        E1RXDSR6
     C                   MOVE      FLSSR1        E1RXSSR1
     C                   MOVE      FLSSR2        E1RXSSR2
     C                   MOVE      FLSSR3        E1RXSSR3
     C                   MOVE      FLSSR4        E1RXSSR4
     C                   MOVE      FLSSR5        E1RXSSR5
     C                   MOVE      FLSSR6        E1RXSSR6
     C                   MOVE      FLCND1        E1RXCND1
     C                   MOVE      FLCND2        E1RXCND2
     C                   MOVE      FLCND3        E1RXCND3
     C                   MOVE      FLCND4        E1RXCND4
     C                   MOVE      FLCND5        E1RXCND5
     C                   MOVE      FLCND6        E1RXCND6
     C                   MOVE      *BLANKS       E1RXISDA
     C                   MOVE      *BLANKS       E1RXAGTY
     C                   MOVE      *BLANKS       E1RXAGDT
     C                   MOVE      *BLANKS       E1RXAGVV
     C                   MOVE      *BLANKS       E1RXAGVC
     C                   MOVE      *BLANKS       E1RXFRNT
     C                   CLEAR                   E1RXTMESTMP
      *
     C                   EVAL      PPAYF = WPPAYF
     C                   EVAL      PRECF = WPRECF
     C                   EVAL      PRXIF = WPRXIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPD2 - Update Routine for Interest Date                     *
      *                                                               *
      *****************************************************************
      *
     C     SRUPD2        BEGSR
      *
     C                   MOVE      'INT'         PEVNT
     C                   MOVE      PDLNO         E2RXDLNO
     C                   MOVE      PEVNT         E2RXEDCD
     C                   Z-ADD     FLRSTM        E2RXRSTM
     C                   MOVE      FLRONS        E2RXRONS
     C                   MOVE      FLRIBN        E2RXRIBN
     C                   MOVE      FLRIBA        E2RXRIBA
     C**********         Z-ADD     FLROBN        E2RXROBN                                     CSD027
     C**********         Z-ADD     FLROCN        E2RXROCN                                     CSD027
     C                   EVAL      E2RXROBN = FLROBN                                          CSD027
     C                   EVAL      E2RXROCN = FLROCN                                          CSD027
     C                   MOVE      FLROBR        E2RXROBR
     C                   MOVE      FLRSCY        E2RXRSCY
     C                   Z-ADD     FLPSTM        E2RXPSTM
     C                   MOVE      FLPONS        E2RXPONS
     C                   MOVE      FLPIBN        E2RXPIBN
     C                   MOVE      FLPIBA        E2RXPIBA
     C**********         Z-ADD     FLPOBN        E2RXPOBN                                     CSD027
     C**********         Z-ADD     FLPOCN        E2RXPOCN                                     CSD027
     C                   EVAL      E2RXPOBN = FLPOBN                                          CSD027
     C                   EVAL      E2RXPOCN = FLPOCN                                          CSD027
     C                   MOVE      FLRCRN        E2RXRCRN
     C                   MOVE      FLRCRA        E2RXRCRA
     C                   MOVE      FLRVNO        E2RXRVNO
     C                   MOVE      FLAWBN        E2RXAWBN
     C                   MOVE      FLAWBA        E2RXAWBA
     C                   MOVE      FLBENN        E2RXBENN
     C                   MOVE      FLBENA        E2RXBENA
     C                   MOVE      FLDTP1        E2RXDTP1
     C                   MOVE      FLDTP2        E2RXDTP2
     C                   MOVE      FLDTP3        E2RXDTP3
     C                   MOVE      FLDTP4        E2RXDTP4
     C                   MOVE      FLDCHG        E2RXDCHG
     C                   MOVE      FLBTB1        E2RXBTB1
     C                   MOVE      FLBTB2        E2RXBTB2
     C                   MOVE      FLBTB3        E2RXBTB3
     C                   MOVE      FLBTB4        E2RXBTB4
     C                   MOVE      FLBTB5        E2RXBTB5
     C                   MOVE      FLBTB6        E2RXBTB6
     C                   MOVE      FLCVMR        E2RXCVMR
     C                   MOVE      FLPOBR        E2RXPOBR
     C                   MOVE      FLPSCY        E2RXPSCY
     C                   MOVE      FLIC72        E2RXIC72
     C                   MOVE      FLDSR1        E2RXDSR1
     C                   MOVE      FLDSR2        E2RXDSR2
     C                   MOVE      FLDSR3        E2RXDSR3
     C                   MOVE      FLDSR4        E2RXDSR4
     C                   MOVE      FLDSR5        E2RXDSR5
     C                   MOVE      FLDSR6        E2RXDSR6
     C                   MOVE      FLSSR1        E2RXSSR1
     C                   MOVE      FLSSR2        E2RXSSR2
     C                   MOVE      FLSSR3        E2RXSSR3
     C                   MOVE      FLSSR4        E2RXSSR4
     C                   MOVE      FLSSR5        E2RXSSR5
     C                   MOVE      FLSSR6        E2RXSSR6
     C                   MOVE      FLCND1        E2RXCND1
     C                   MOVE      FLCND2        E2RXCND2
     C                   MOVE      FLCND3        E2RXCND3
     C                   MOVE      FLCND4        E2RXCND4
     C                   MOVE      FLCND5        E2RXCND5
     C                   MOVE      FLCND6        E2RXCND6
     C                   MOVE      FLISDA        E2RXISDA
     C                   MOVE      FLAGTY        E2RXAGTY
     C                   MOVE      FLAGDT        E2RXAGDT
     C                   MOVE      FLAGVV        E2RXAGVV
     C                   MOVE      FLAGVC        E2RXAGVC
     C                   MOVE      *BLANKS       E2RXFRNT
     C                   CLEAR                   E2RXTMESTMP
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPD3 - Update Routine for Maturity Date                     *
      *                                                               *
      *****************************************************************
      *
     C     SRUPD3        BEGSR
      *
     C                   MOVE      PDLNO         E3RXDLNO
     C                   MOVE      PEVNT         E3RXEDCD
     C                   Z-ADD     FLRSTM        E3RXRSTM
     C                   MOVE      FLRONS        E3RXRONS
     C                   MOVE      FLRIBN        E3RXRIBN
     C                   MOVE      FLRIBA        E3RXRIBA
     C**********         Z-ADD     FLROBN        E3RXROBN                                     CSD027
     C**********         Z-ADD     FLROCN        E3RXROCN                                     CSD027
     C                   EVAL      E3RXROBN = FLROBN                                          CSD027
     C                   EVAL      E3RXROCN = FLROCN                                          CSD027
     C                   MOVE      FLROBR        E3RXROBR
     C                   MOVE      FLRSCY        E3RXRSCY
     C                   Z-ADD     FLPSTM        E3RXPSTM
     C                   MOVE      FLPONS        E3RXPONS
     C                   MOVE      FLPIBN        E3RXPIBN
     C                   MOVE      FLPIBA        E3RXPIBA
     C**********         Z-ADD     FLPOBN        E3RXPOBN                                     CSD027
     C**********         Z-ADD     FLPOCN        E3RXPOCN                                     CSD027
     C                   EVAL      E3RXPOBN = FLPOBN                                          CSD027
     C                   EVAL      E3RXPOCN = FLPOCN                                          CSD027
     C                   MOVE      FLRCRN        E3RXRCRN
     C                   MOVE      FLRCRA        E3RXRCRA
     C                   MOVE      FLRVNO        E3RXRVNO
     C                   MOVE      FLAWBN        E3RXAWBN
     C                   MOVE      FLAWBA        E3RXAWBA
     C                   MOVE      FLBENN        E3RXBENN
     C                   MOVE      FLBENA        E3RXBENA
     C                   MOVE      FLDTP1        E3RXDTP1
     C                   MOVE      FLDTP2        E3RXDTP2
     C                   MOVE      FLDTP3        E3RXDTP3
     C                   MOVE      FLDTP4        E3RXDTP4
     C                   MOVE      FLDCHG        E3RXDCHG
     C                   MOVE      FLBTB1        E3RXBTB1
     C                   MOVE      FLBTB2        E3RXBTB2
     C                   MOVE      FLBTB3        E3RXBTB3
     C                   MOVE      FLBTB4        E3RXBTB4
     C                   MOVE      FLBTB5        E3RXBTB5
     C                   MOVE      FLBTB6        E3RXBTB6
     C                   MOVE      FLCVMR        E3RXCVMR
     C                   MOVE      FLPOBR        E3RXPOBR
     C                   MOVE      FLPSCY        E3RXPSCY
     C                   MOVE      FLIC72        E3RXIC72
     C                   MOVE      FLDSR1        E3RXDSR1
     C                   MOVE      FLDSR2        E3RXDSR2
     C                   MOVE      FLDSR3        E3RXDSR3
     C                   MOVE      FLDSR4        E3RXDSR4
     C                   MOVE      FLDSR5        E3RXDSR5
     C                   MOVE      FLDSR6        E3RXDSR6
     C                   MOVE      FLSSR1        E3RXSSR1
     C                   MOVE      FLSSR2        E3RXSSR2
     C                   MOVE      FLSSR3        E3RXSSR3
     C                   MOVE      FLSSR4        E3RXSSR4
     C                   MOVE      FLSSR5        E3RXSSR5
     C                   MOVE      FLSSR6        E3RXSSR6
     C                   MOVE      FLCND1        E3RXCND1
     C                   MOVE      FLCND2        E3RXCND2
     C                   MOVE      FLCND3        E3RXCND3
     C                   MOVE      FLCND4        E3RXCND4
     C                   MOVE      FLCND5        E3RXCND5
     C                   MOVE      FLCND6        E3RXCND6
     C                   MOVE      *BLANKS       E3RXISDA
     C                   MOVE      *BLANKS       E3RXAGTY
     C                   MOVE      *BLANKS       E3RXAGDT
     C                   MOVE      *BLANKS       E3RXAGVV
     C                   MOVE      *BLANKS       E3RXAGVC
     C                   MOVE      *BLANKS       E3RXFRNT
     C                   CLEAR                   E3RXTMESTMP
      *
     C                   EVAL      PPAYF = WPPAYF
     C                   EVAL      PRECF = WPRECF
     C                   EVAL      PRXIF = WPRXIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCONV - Convert Customer No. to Shortname                    *
      *                                                               *
      *****************************************************************
      *
     C     SRCONV        BEGSR
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WKEY1         @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   MOVE      BBCSSN        WKEY1            10
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * #INIT  - Initial Routine                                      *
      *                                                               *
      *****************************************************************
      *
     C     #INIT         BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRetCode
     C                   PARM                    MODEofOP          6
     C                   PARM                    PEVNT             3
     C                   PARM                    PACTN
     C                   PARM                    PDLNO
     C                   PARM                    PPAY              1
     C                   PARM                    PREC              1
     C                   PARM                    PCSNM
     C                   PARM                    PFFND
     C                   PARM                    PBRCA             3
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
     C                   PARM                    PFuncKey          2
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
