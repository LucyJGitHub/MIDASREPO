     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Withholding Tax Calculation for Dual WHT')    *
      *****************************************************************
      *                                                               *
      *  Midas - Retail and MM Module                                 *
      *                                                               *
      *  GL024000 - Midas Withholding Tax Calculation for Dual WHT    *
      *                                                               *
      *  Function:  This program will will receive the required       *
      *             details in order to calculate Withholding tax     *
      *             amounts and return to the calling program.        *
      *             For Retail Accounts and MM Deposits where tax     *
      *             is applicable details will be output to a new     *
      *             table                                             *
      *                                                               *
      *  Called By: RE3360, RE3664, DL0280, DL5350, AOOUMMU0          *
      *             MMLDNIROD                                         *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD034383           Date 12May15               *
      *                 CGL165  *CREATE    Date 23Feb15               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034383 - Amendment to Tax Calculation Program              *
      *  CGL165 - Dual WIthholding Tax                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *                                                               *
      *****************************************************************
     FSDWTRCL0  IF   E           K DISK
      ** Midas SD Tax Code Details
     FDLDWTXPD  O    E             DISK
      ** Midas DL Daily Witholding Tax File
     FREDWTXPD  O    E             DISK
      ** Midas RE Daily Witholding Tax File
      *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
      *
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
     D  TIME                 282    287
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      *  Midas SD Bank details ICD file
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      *  Midas SD Currency details file
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      *  Short Data Structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      *  Long Data Structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      *  Very Long Data Structure for access programs
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      *  Data Area for database error reporting
     D LDA           E DS                  EXTNAME(LDA)
      *
     D RetCode         S              1A
     D RndDown0        S              1A
     D XINTB           S             15  0
     D XTAXL           S             15  0
     D WTXA            S             15  0
     D STXA            S             15  0
      *
      *****************************************************************
      /EJECT
      *****************************************************************
?     *                M A I N    P R O C E S S I N G
      *****************************************************************
      *
     C                   EXSR      SRPROCESS
      *
     C                   EXSR      SREND
      *
      /EJECT
      *****************************************************************
?     * Process Subroutine
      *****************************************************************
     C     SRPROCESS     BEGSR
      *
      * If Interest is 0 end processing
     C                   IF        P_INTA = 0
     C                   EXSR      SREND
     C                   ENDIF
      *
      * Retrieve Currency Details
     C                   EXSR      CURR_DTL
      *
      * Based on Main Tax Code defined for the account, retrieve tax rate
     C     P_TXC1        CHAIN     SDWTRCL0
B1   C                   IF        %FOUND(SDWTRCL0)
      *
      * Round Down flag at Currency level determines whether tax is
      * rounded down or half rounded
     C     P_INTA        MULT      WTRT          WTXA
     C                   Z-ADD     WTXA          P_TXConvL        13 0
B2   C                   IF        A6RDFC = 'Y'
     C     WTXA          DIV       100           WTXA
     C                   ELSE
     C     WTXA          DIV(H)    100           WTXA
E2   C                   ENDIF
      *
     C                   Z-ADD     WTXA          P_WTXA
      *
      * Check whether interest is < minimum interest
B2   C     MINT          IFNE      0
     C                   EXSR      CONV_AMT_B
      *
     C                   SELECT
     C     B_NBDP        WHENEQ    1
     C     XINTB         DIV       10            XINTB
     C     B_NBDP        WHENEQ    2
     C     XINTB         DIV       100           XINTB
     C     B_NBDP        WHENEQ    3
     C     XINTB         DIV       1000          XINTB
     C                   ENDSL
B3   C                   IF        XINTB < MINT
     C                   Z-ADD     0             P_WTXA
E3   C                   ENDIF
E2   C                   ENDIF
      *
      * Check whether tax in local currency < 0
B2   C                   IF        P_WTXA <> 0
      *
B3   C                   IF        P_CCY <> BJLCCY
     C                   Z-ADD     P_WTXA        InputAmnt
     C                   EXSR      CONV_AMT_L
B4   C                   IF        XTAXL = 0
     C                   Z-ADD     0             P_WTXA
     C                   Z-ADD     0             XWTAXL           13 0
     C                   ELSE
     C                   Z-ADD     XTAXL         XWTAXL
E4   C                   ENDIF
     C                   ELSE
     C                   Z-ADD     P_WTXA        XWTAXL
E3   C                   ENDIF
      *
     C                   ELSE
     C                   Z-ADD     0             XWTAXL
E2   C                   ENDIF
      *
E1   C                   ENDIF
      *
      * If Secondary Tax Code defined defined for the account, retreive tax rate
 
B1   C     P_TXC2        IFNE      *BLANKS
     C     P_TXC2        CHAIN     SDWTRCL0
B2   C                   IF        %FOUND(SDWTRCL0)
      *
      * Round Down flag at Currency level determines whether tax is
      * rounded down or half rounded
     C     P_INTA        MULT      WTRT          STXA
     C                   Z-ADD     STXA          P_TXConvL        13 0
B3   C                   IF        A6RDFC = 'Y'
     C     STXA          DIV       100           STXA
     C                   ELSE
     C     STXA          DIV(H)    100           STXA
E3   C                   ENDIF
      *
      * Check whether interest is < minimum interest
     C                   Z-ADD     STXA          P_STXA
      *
B3   C     MINT          IFNE      0
     C                   EXSR      CONV_AMT_B
      *
     C                   SELECT
     C     B_NBDP        WHENEQ    1
     C     XINTB         DIV       10            XINTB
     C     B_NBDP        WHENEQ    2
     C     XINTB         DIV       100           XINTB
     C     B_NBDP        WHENEQ    3
     C     XINTB         DIV       1000          XINTB
     C                   ENDSL
B4   C                   IF        XINTB < MINT
     C                   Z-ADD     0             P_STXA
E4   C                   ENDIF
E3   C                   ENDIF
      *
      * Check whether tax in local currency < 0
B3   C                   IF        P_STXA <> 0
      *
B4   C                   IF        P_CCY <> BJLCCY
     C                   Z-ADD     P_STXA        InputAmnt
     C                   EXSR      CONV_AMT_L
B5   C                   IF        XTAXL = 0
     C                   Z-ADD     0             P_STXA
     C                   Z-ADD     0             XSTAXL           13 0
     C                   ELSE
     C                   Z-ADD     XTAXL         XSTAXL
E5   C                   ENDIF
     C                   ELSE
     C                   Z-ADD     P_STXA        XSTAXL
E4   C                   ENDIF
      *
     C                   ELSE
     C                   Z-ADD     0             XSTAXL
E3   C                   ENDIF
      *
E2   C                   ENDIF
      *
E1   C                   ENDIF
      *
      * If called from a Capitalisation process then output details to new table
     C                   IF        P_CALPGM = 'RE3664' or P_CALPGM = 'DL0280'
     C                   EXSR      OUTPUT_TAX
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
?     * Output Tax Details to new table
      *****************************************************************
     C     OUTPUT_TAX    BEGSR
      *
      * If retail capitalisation details output to RE Daily WHT file
      * else output to DL Daily WHT file
     C                   IF        P_CALPGM = 'RE3664'
      *
     C                   MOVE      'D'           RECI
     C                   MOVE      P_BRCA        BRCA
     C                   MOVE      P_CNUM        CNUM
     C                   MOVE      P_CCY         CCY
     C                   MOVE      P_ACOD        ACOD
     C                   MOVE      P_ACSQ        ASEQ
     C                   MOVE      P_TXC1        TTXC1
     C                   MOVE      P_TXC2        TTXC2
     C                   Z-ADD     P_WTXA        TTXC1A
     C                   Z-ADD     XWTAXL        TTXC1L
     C                   Z-ADD     P_STXA        TTXC2A
     C                   Z-ADD     XSTAXL        TTXC2L
     C                   Z-ADD     P_INTA        TIDUE
     C                   Z-ADD     P_CPDT        TVALD
      *
      * Net Interest Paid
     C     TIDUE         SUB       P_WTXA        TIPAD
     C     TIPAD         SUB       P_STXA        TIPAD
      *
     C                   WRITE     REDWTXD0
     C                   ELSE
      *
     C                   MOVE      'D'           RECI
     C                   MOVE      P_BRCA        BRCD
     C                   MOVE      P_CNUM        CNUM
     C                   MOVE      P_CCY         CCY
     C                   MOVEL     P_DLACNO      DLNO
     C                   MOVEL     P_DTYP        DTYP
     C                   MOVE      P_TXC1        TTXC1
     C                   MOVE      P_TXC2        TTXC2
     C                   Z-ADD     P_WTXA        TTXC1A
     C                   Z-ADD     XWTAXL        TTXC1L
     C                   Z-ADD     P_STXA        TTXC2A
     C                   Z-ADD     XSTAXL        TTXC2L
     C                   Z-ADD     P_INTA        TIDUE
     C                   Z-ADD     P_VDAT        VDAT
     C                   Z-ADD     P_MDAT        MDAT
     C                   Z-ADD     P_INTR        INTR
     C                   Z-ADD     P_PCPL        PCPL
      *
      * Net Interest Paid
     C     TIDUE         SUB       P_WTXA        TIPAD
     C     TIPAD         SUB       P_STXA        TIPAD
      *
     C                   WRITE     DLDWTXD0
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
?     * Obtain Currency Details
      *****************************************************************
     C     CURR_DTL      BEGSR
      *
     C                   CALL      'AOCURRR1'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      P_CCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSLDY
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
?     * Convert Amounts to Base Currency
      *****************************************************************
     C     CONV_AMT_B    BEGSR
      *
     C                   IF        P_CCY = BJCYCD
     C                   Z-ADD     P_INTA        XINTB
     C                   ELSE
      * Convert Gross Interest
     C                   CALL      'ZCONVZ1'
     C                   PARM      P_INTA        InputAmnt        15 0
     C                   PARM      A6TXCR        ExchRate         13 8
     C                   PARM      A6MDIN        MultDivInd        1
     C                   PARM      P_CCY         FrCurrency        3
     C                   PARM      BJCYCD        ToCurrency        3
     C                   PARM      A6NBDP        FrDecPlace        1 0
     C                   PARM      B_NBDP        ToDecPlace        1 0
     C                   PARM                    OutputAmnt       15 0
     C                   EVAL      XINTB = OutputAmnt
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
?     * Convert Amounts to Local Currency
      *****************************************************************
     C     CONV_AMT_L    BEGSR
      *
      * Convert Tax Amount
     C                   CALL      'ZCCYCN'
     C                   PARM                    InputAmnt        15 0
     C                   PARM      P_CCY         FrCurrency        3
     C                   PARM      BJLCCY        ToCurrency        3
     C                   PARM      A6TXCR        FrExchRate       13 8
     C                   PARM      L_TXCR        ToExchRate       13 8
     C                   PARM      A6MDIN        FrMultDivInd      1
     C                   PARM      L_MDIN        ToMultDivInd      1
     C                   PARM      A6NBDP        FrDecPlace        1 0
     C                   PARM      L_NBDP        ToDecPlace        1 0
     C                   PARM                    OutputAmnt       15 0
     C                   PARM                    CrExchRate       13 8
     C                   PARM                    CrMultDivInd      1
     C                   EVAL      XTAXL = OutputAmnt
      *
      * If Current Value of WHTLocalCcyRoundDown is 'Y' need to re-check
      * to see if Local Currency Value rounded down is 0
     C     RndDown0      IFEQ      'Y'
     C                   Z-ADD     P_TXConvL     InputAmnt
     C                   CALL      'ZCCYCN'
     C                   PARM                    InputAmnt        15 0
     C                   PARM      P_CCY         FrCurrency        3
     C                   PARM      BJLCCY        ToCurrency        3
     C                   PARM      A6TXCR        FrExchRate       13 8
     C                   PARM      L_TXCR        ToExchRate       13 8
     C                   PARM      A6MDIN        FrMultDivInd      1
     C                   PARM      L_MDIN        ToMultDivInd      1
     C                   PARM      A6NBDP        FrDecPlace        1 0
     C                   PARM      L_NBDP        ToDecPlace        1 0
     C                   PARM                    OutputAmnt       15 0
     C                   PARM                    CrExchRate       13 8
     C                   PARM                    CrMultDivInd      1
     C     OutputAmnt    DIV       100           WXTAXL           13 0
      *
     C                   IF        WXTAXL = 0
     C                   Z-ADD     0             XTAXL
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
?     * Exit from program
      *****************************************************************
     C     SREND         BEGSR
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
?     * Initialization routine
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      * Inputs
     C                   PARM                    RetCode                        Return Code
     C                   PARM                    P_CALPGM          6            Calling Program
     C                   PARM                    P_BRCA            3            Branch Code
     C                   PARM                    P_CNUM            6            Customer No
     C                   PARM                    P_DLACNo         10            A/C Number
     C                   PARM                    P_CCY             3            A/C CCY
     C                   PARM                    P_INTA           15 0          Interest Amt
     C                   PARM                    P_TXC1            2            Main Tax Code
     C                   PARM                    P_TXC2            2            Secondary Tax Code
     C                   PARM                    P_CPDT            5 0          Capitalisation Date
     C                   PARM                    P_VDAT            5 0          Val Date (Deal Only)
     C                   PARM                    P_MDAT            5 0          Mat Date (Deal Only)
     C                   PARM                    P_INTR           11 7          Int Rate (Deal Only)
     C                   PARM                    P_DTYP            2            Deal Typ (Deal Only)
     C                   PARM                    P_PCPL           15 0          Prin Amt (Deal Only)
     C                   PARM                    P_ACOD           10            A/C Code (A/C Only)
     C                   PARM                    P_ACSQ            2 0          A/C Seq (A/C Only)
      * Outputs
     C                   PARM                    P_WTXA           15 0          WHT Amt
     C                   PARM                    P_STXA           15 0          Municipality Tax Amt
      *
     C                   Z-ADD     0             P_WTXA                                     MD034383
     C                   Z-ADD     0             P_STXA                                     MD034383
      * Retrieve LDA
     C     *DTAARA       DEFINE                  LDA
     C                   IN        LDA
      *
      * Retrieve Run Date and base Currency Code
     C                   Call      'AOBANKR0'
     C                   Parm      '*DBERR '     RTCD              7
     C                   Parm      '*FIRST '     OPTN              7
     C     SDBANK        Parm      SDBANK        DSFDY
      *
      * Obtain Base Currency details
     C                   CALL      'AOCURRR1'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BJCYCD        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSLDY
      *
     C                   Z-ADD     A6NBDP        B_NBDP            1 0
      *
      * Obtain Local Currency Details
     C                   CALL      'AOCURRR1'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BJLCCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSLDY
      *
     C                   Z-ADD     A6NBDP        L_NBDP            1 0
     C                   Z-ADD     A6TXCR        L_TXCR           13 8
     C                   MOVEL     A6MDIN        L_MDIN            1
      *
      * Obtain Currency Value of System Value WHTLocalCcyRoundDown
     C                   Eval      P@Op01 = 'WHTLocalCcyRoundDown'
     C                   Call      'AOSVALR0'
     C                   Parm      *Blanks       P@Rtcd            7
     C                   Parm                    P@Op01           20
     C                   Parm      *Blanks       P@Vl01          200
     C                   Parm      *Blanks       P@Op02           20
     C                   Parm      *Blanks       P@Vl02          200
     C                   Parm      *Blanks       P@Op03           20
     C                   Parm      *Blanks       P@Vl03          200
     C                   Parm      *Blanks       P@Op04           20
     C                   Parm      *Blanks       P@Vl04          200
     C                   Parm      *Blanks       P@Op05           20
     C                   Parm      *Blanks       P@Vl05          200
     C                   Parm      *Blanks       P@Op06           20
     C                   Parm      *Blanks       P@Vl06          200
     C                   Parm      *Blanks       P@Op07           20
     C                   Parm      *Blanks       P@Vl07          200
     C                   Parm      *Blanks       P@Op08           20
     C                   Parm      *Blanks       P@Vl08          200
     C                   Parm      *Blanks       P@Op09           20
     C                   Parm      *Blanks       P@Vl09          200
     C                   Parm      *Blanks       P@Op10           20
     C                   Parm      *Blanks       P@Vl10          200
 
      **  If the Return Code is blank, set Default Priorities
     C                   If        P@Rtcd = *Blanks
     C                   Eval      RndDown0 = P@Vl01
     C                   EndIf
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
?     * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
