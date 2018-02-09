     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Further Settle Instructions screen input')    *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  ZAFSETISIN - Further Settlement Instructions                 *
      *                                                               *
      *  Function:  This program allows entry of multiple setllement  *
      *             accounts.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 MD023371           Date 13Nov13               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CDL018  *CREATE    Date 03Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions (Recompile) *
      *  MD023371 - Incorrect total amount is displayed on DEALS      *
      *             ENQUIRY under further settlement details          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FZAFSETISDFCF   E             WORKSTN
      ** Further Settlement Instructions screen
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
      ** Table of field numbers and names
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       85  Protect receipt fields                              *
      *       86  Protect payment fields                              *
      *                                                               *
      *****************************************************************
 
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
 
      ** Include the ZA standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      * Added the following /copy members for new message handling.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
     D/COPY ZACPYSRC,APICTLARR
 
     D/COPY ZACPYSRC,FVAL_ARRAY
 
     D/COPY ZACPYSRC,MSGHNDDCL
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
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
 
     D RER             S              1    DIM(48)
     D PAR             S              1    DIM(48)
     D FNA             S             10    DIM(75)
     D MIA             S              7    DIM(75)
     D UER             S              7    DIM(75) ASCEND
     D @Z0             S              1    DIM(74) CTDATA PERRCD(74)
     D WFldNameArr     S             10    DIM(75)
 
     D NwDlFilFmt    E DS                  EXTNAME(MMVLDNIPD)
      ** Deal in File Format
 
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      ** Screen - Receive Instructions
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      ** Screen - Payment Instructions
 
     D #FRECF        E DS                  EXTNAME(SDFSFRPD)
      ** File - Receive Further Settlement Instructions
 
     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)
      ** File - Payment Further Settlement Instructions
 
     D #FRECS        E DS                  EXTNAME(SDFSSRPD)
      ** Screen - Receive Further Settlement Instructions
 
     D #FPAYS        E DS                  EXTNAME(SDFSSPPD)
      ** Screen - Payment Further Settlement Instructions
 
     D #FRECE        E DS                  EXTNAME(SDFSERPD)
      ** Errors - Receive Further Settlement Instructions
 
     D #FPAYE        E DS                  EXTNAME(SDFSEPPD)
      ** Errors - Payment Further Settlement Instructions
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for General Ledger Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for SAR Details
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D SDDeaAcc      E                     EXTFLD(QQACCD)                                     CGL029
      ** External DS for Dealing details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS FOR Currency Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Customer Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access Programs, Long Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D RUNDAT          DS            13
     D  DDRUNA                 1      7
     D  @MBIN                 13     13
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialisation
 
     C                   EXSR      INIT
 
      ** If not Insert, then retrieve and convert details
 
     C     ##ACTN        IFNE      'I'
 
     C                   CALLB     'ZAFSETICVT'
 
      ** INPUT
      ** Deal Number
     C                   PARM                    ##DLNO
 
      ** Action Code
     C                   PARM                    ##ACTN
 
      ** Payment currency
     C                   PARM                    ##PCCY
 
      ** Receive currency
     C                   PARM                    ##RCCY
 
      ** LDNI Deal details
     C                   PARM                    NwDlFilFmt
 
      ** OUTPUT
      ** Screen - Payment Further Settlement Instructions
     C                   PARM                    #FPAYS
 
      ** Screen - Receive Further Settlement Instructions
     C                   PARM                    #FRECS
 
     C                   ENDIF
 
      ** Work With Further Settlement Instructions
 
     C                   EXSR      WRKSTI
 
      ** Errors outstanding
 
     C     ##ACTN        IFEQ      'I'
     C     ##ACTN        OREQ      'A'
     C     ##ACTN        OREQ      'X'
 
     C     @IDX          IFNE      *ZERO
     C     DDRMAC        OREQ      'Y'
     C     FRAL01        ANDEQ     *BLANK
     C     DDPMAC        OREQ      'Y'
     C     FPAL01        ANDEQ     *BLANK
     C                   MOVEL     '*ERRORS'     RetCodeIn
 
     C                   ELSE
 
     C                   MOVE      '0'           @INKL
 
     C                   ENDIF
     C                   ENDIF
 
      ** Close down program
 
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C                   SETON                                        LR
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      /EJECT
      *****************************************************************
      * WRKSTI - Work With Further Settlement Instructions            *
      *****************************************************************
     C     WRKSTI        BEGSR
 
      ** Set off roll indicators
 
     C                   MOVE      '0'           *IN07
     C                   MOVE      '0'           *IN08
 
      ** Validate for Authorisation
 
     C     ##ACTN        IFEQ      'X'
     C                   EXSR      VALSTI
     C                   EXSR      SETRECE
     C                   EXSR      SETPAYE
     C                   ENDIF
 
      ** Write/Read Payment and Receive Screen
 
     C     DDPMAC        IFEQ      'Y'                                                      MD023371
     C                   EXSR      WRPAYM                                                   MD023371
     C                   ENDIF                                                              MD023371
      *                                                                                     MD023371
     C     DDRMAC        IFEQ      'Y'                                                      MD023371
     C                   EXSR      WRRECP
     C                   ENDIF                                                              MD023371
 
      ** Do While F3 or F12 not taken
 
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C     *INKH         ANDEQ     '0'
      *
     C                   MOVE      '0'           *INKH
      *
      ** Validate settlement Instructions if insert, amend or authorize
      *
     C     ##ACTN        IFEQ      'I'
     C     ##ACTN        OREQ      'A'
     C     ##ACTN        OREQ      'X'
     C                   EXSR      VALSTI
     C                   ENDIF
      *
      ** If rollup, output Payment screen
      *
     C     *IN07         IFEQ      '1'
     C                   EXSR      SETPAYE
     C                   EXSR      WRPAYM
     C                   ENDIF
      *
      ** Write/Read Receive Screen
      ** If not processing Payment screen
      *
     C     *IN07         IFEQ      '0'
     C                   EXSR      SETRECE
     C                   EXSR      WRRECP
     C                   ENDIF
      *
      ** If rolldown, set off roll indicators
      *
     C     *IN08         IFEQ      '1'
     C                   MOVE      '0'           *IN07
     C                   MOVE      '0'           *IN08
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * WRRECP - WRITE/READ Receipt Screen                            *
      *****************************************************************
     C     WRRECP        BEGSR
      *
     C                   TIME                    DDTIME
      *
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   WRITE     #RCDDTL1
      *
     C                   READ      #RCDDTL1                               99
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
      *
      ** Clear screen message queue
      *
     C                   CALL      'ZA0250'
      *
      ** Set OFF Error Indicators
      *
     C                   MOVEA     @Z0           *IN(10)
     C                   MOVEA     @Z0           #FRECE
     C                   MOVEA     @Z0           #FPAYE
     C                   MOVEA     *BLANKS       FNA
     C                   MOVEA     *BLANKS       MIA
     C                   MOVEA     *BLANKS       WFldNameArr
     C                   MOVEA     *BLANKS       WMsgIDArr
     C                   MOVEA     *BLANKS       WMsgDtaArr
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * WRPAYM - WRITE/READ Payment Screen                            *
      *****************************************************************
     C     WRPAYM        BEGSR
      *
     C                   TIME                    DDTIME
      *
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   WRITE     #RCDDTL2
      *
     C                   READ      #RCDDTL2                               99
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
      *
      ** Clear screen message queue
      *
     C                   CALL      'ZA0250'
      *
      ** Set OFF Error Indicators
      *
     C                   MOVEA     @Z0           *IN(10)
     C                   MOVEA     @Z0           #FRECE
     C                   MOVEA     @Z0           #FPAYE
     C                   MOVEA     *BLANKS       FNA
     C                   MOVEA     *BLANKS       MIA
     C                   MOVEA     *BLANKS       WFldNameArr
     C                   MOVEA     *BLANKS       WMsgIDArr
     C                   MOVEA     *BLANKS       WMsgDtaArr
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * VALSTI - Validate Further Settlement Instructions             *
      *****************************************************************
     C     VALSTI        BEGSR
 
      ** Validate Further Settlement Instructions
 
     C                   CALLB     'ZAFSETIVAL'
      *
      ** INPUTS
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Calling program
     C                   PARM                    ##CALP
      *
      ** Payment currency
     C                   PARM                    ##PCCY
      *
      ** Receive currency
     C                   PARM                    ##RCCY
      *
      ** Transaction Type
     C                   PARM                    ##TTYP
      *
      ** Booking branch
     C                   PARM                    ##BRCA
      *
      ** Receipt Date
      ** (must = 99999 if no back valuation validation to be done)
     C                   PARM                    ##DATR
      *
      ** Payment Date
      ** (must = 99999 if no back valuation validation to be done)
     C                   PARM                    ##DATP
      *
      ** Payment - Settle instructions - Screen format
     C                   PARM                    ##PAYS
      *
      ** Receive - Settle instructions - Screen format
     C                   PARM                    ##RECS
      *
      ** Payment - Further Settle instructions - Screen format
     C                   PARM                    #FPAYS
      *
      ** Receive - Further Settle instructions - Screen format
     C                   PARM                    #FRECS
      *
      ** Action Code
     C                   PARM                    ##ACTN
      *
      ** Protect Payment Field
     C                   PARM                    ##PPAY
      *
      ** Protect Receipt Field
     C                   PARM                    ##PREC
      *
      ** LDNI Deal details
     C                   PARM                    NwDlFilFmt
      *
      ** OUTPUTS
      ** Errors in Payment further settle instructions
     C                   PARM                    #FPAYE
      *
      ** Errors in Receive further settle instructions
     C                   PARM                    #FRECE
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FNA
     C                   PARM                    MIA
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *ZERO         @IDX              3 0
      *
      ** Warning Messages
     C                   PARM                    WFldNameArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx              3 0
      *
      ** Payment - Further Settle instructions - File format
     C                   PARM                    #FPAYF
      *
      ** Receive - Further Settle instructions - File format
     C                   PARM                    #FRECF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SETPAYE - Set Payment Error Indicators                        *
      *****************************************************************
     C     SETPAYE       BEGSR
 
     C     ##ACTN        IFEQ      'I'
     C     ##ACTN        OREQ      'A'
     C     ##ACTN        OREQ      'X'
      *
      ** If settlement instructions not valid output error message
      *
     C                   MOVEA     MIA           UER
     C                   Z-ADD     1             Z                 2 0
     C     *BLANK        LOOKUP    UER(Z)                             99
     C     *IN99         IFEQ      '1'
      *
      ** Set ON Payment Error Indicators
      *
     C                   MOVEA     #FPAYE        PAR
     C                   Z-ADD     1             CN                2 0
     C     *IN96         DOUEQ     '0'
     C     'N'           LOOKUP    PAR(CN)                                96
     C   96              MOVEL     '1'           PAR(CN)
     C                   ENDDO
     C                   MOVEA     PAR           *IN(11)
     C/COPY ZACPYSRC,MSGHNDDSP1
      *
      ** DO WHILE error codes returned remain to be processed
      *
     C     Z             DOWLT     51
     C     UER(Z)        ANDNE     *BLANKS
     C                   MOVEL     UER(Z)        @WERR             7
     C                   EXSR      ERROR
     C                   ADD       1             Z
     C                   ENDDO
      *
     C                   ELSE
 
      ** Send Warning Messages
 
     C                   EVAL      Z = 1
 
     C                   DOW       Z < 76 and WMsgIdArr(Z) <> *Blanks
     C                   EVAL      ZAMsgID = WMsgIdArr(Z)
     C                   EVAL      ZAMsgDta = WMsgDtaArr(Z)
     C                   EXSR      SRWarnMsg
     C                   ADD       1             Z
     C                   ENDDO
      *
      ** Display message "Validation Complete - Press F12 to Return"
      *
     C                   MOVEL     'ESM0800'     ZAMSID
      *
     C                   CALL      'ZA0240'
     C                   PARM                    ZAMSID
     C                   MOVEL     *BLANK        ZAMSID
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SETRECE - Set Receipt Error Indicators                        *
      *****************************************************************
     C     SETRECE       BEGSR
 
     C     ##ACTN        IFEQ      'I'
     C     ##ACTN        OREQ      'A'
     C     ##ACTN        OREQ      'X'
      *
      ** If settlement instructions not valid output error message
      *
     C                   MOVEA     MIA           UER
     C                   Z-ADD     1             Z                 2 0
     C     *BLANK        LOOKUP    UER(Z)                             99
     C     *IN99         IFEQ      '1'
      *
      ** Set ON Receipt Error Indicators
      *
     C                   MOVEA     #FRECE        RER
     C                   Z-ADD     1             CN                2 0
     C     *IN96         DOUEQ     '0'
     C     'N'           LOOKUP    RER(CN)                                96
     C   96              MOVEL     '1'           RER(CN)
     C                   ENDDO
     C                   MOVEA     RER           *IN(11)
     C/COPY ZACPYSRC,MSGHNDDSP1
      *
      ** DO WHILE error codes returned remain to be processed
      *
     C     Z             DOWLT     51
     C     UER(Z)        ANDNE     *BLANKS
     C                   MOVEL     UER(Z)        @WERR             7
     C                   EXSR      ERROR
     C                   ADD       1             Z
     C                   ENDDO
      *
     C                   ELSE
 
      ** Send Warning Messages
 
     C                   EVAL      Z = 1
 
     C                   DOW       Z < 76 and WMsgIdArr(Z) <> *Blanks
     C                   EVAL      ZAMsgID = WMsgIdArr(Z)
     C                   EVAL      ZAMsgDta = WMsgDtaArr(Z)
     C                   EXSR      SRWarnMsg
     C                   ADD       1             Z
     C                   ENDDO
      *
      ** Display message "Validation Complete - Press F12 to Return"
      *
     C                   MOVEL     'ESM0800'     ZAMSID
      *
     C                   CALL      'ZA0240'
     C                   PARM                    ZAMSID
     C                   MOVEL     *BLANK        ZAMSID
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWarnMsg - Call Program ZA0350 to send Warning Messages      *
      *                                                               *
      *****************************************************************
     C     SRWarnMsg     BEGSR
 
     C                   CALL      'ZA0350'
     C                   PARM      'DRSMM'       ZAMsgFile        10
     C                   PARM                    ZAMsgId          10
     C                   PARM                    ZAMsgDta         45
 
     C                   EVAL      ZAMsgId = *Blanks
     C                   EVAL      ZAMsgDta = *Blanks
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * ERROR    - Call Program ZA0240 to output Error messages       *
      *****************************************************************
     C     ERROR         BEGSR
 
      ** Display error message
 
     C                   MOVEL     *BLANK        ZAMSID           10
     C                   MOVEL     @WERR         ZAMSID
     C                   CALL      'ZA0240'
     C                   PARM                    ZAMSID
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SETSCNIND - Set Screen Conditioning Indicators                *
      *****************************************************************
     C     SETSCNIND     BEGSR
 
      ** Reset screen 'protect' indicators
 
     C                   MOVEL     '0'           *IN85
     C                   MOVEL     '0'           *IN86
 
      ** If action code is not insert or amend, protect all fields
 
     C     ##ACTN        IFNE      'I'
     C     ##ACTN        ANDNE     'A'
     C                   MOVEL     '1'           *IN85
     C                   MOVEL     '1'           *IN86
     C                   ENDIF
 
      ** If EMU Settlement Currency feature is on
 
     C     CEU003        IFEQ      'Y'
      *
      ** Get receive currency 'in' currency ind
      *
     C     ##RCCY        IFNE      *BLANK
     C                   MOVEL     ##RCCY        @CURR
     C                   EXSR      GETCCYDET
     C                   MOVEL     A6INCY        #RINCY            1
     C                   Z-ADD     A6NBDP        RNBDP             1 0
     C                   ELSE
     C                   MOVEL     *BLANK        #RINCY
     C                   ENDIF
      *
      ** Get payment currency 'in' currency ind
      *
     C     ##PCCY        IFNE      *BLANK
     C                   MOVEL     ##PCCY        @CURR
     C                   EXSR      GETCCYDET
     C                   MOVEL     A6INCY        #PINCY            1
     C                   Z-ADD     A6NBDP        PNBDP             1 0
     C                   ELSE
     C                   MOVEL     *BLANK        #PINCY
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Set indicator to protect receipt instructions if:
      ** . EMU switchable feature not installed
      ** . If calling function is Deal Amendments input
      ** . If calling function is NAs Sold input
      ** . If EMU installed & Rec currency is not an 'in' currency or Euros
      *
     C     ##PREC        IFEQ      'Y'
     C     CEU003        IFNE      'Y'
     C     ##CALP        OREQ      'DEAM'
     C     ##CALP        OREQ      'NASS'
     C     CEU003        OREQ      'Y'
     C     #RINCY        ANDNE     'Y'
     C     ##RCCY        ANDNE     BKEURO
     C                   MOVEL     '1'           *IN85
     C                   ENDIF
     C                   ENDIF
      *
     C     DDRMAC        IFNE      'Y'
     C                   MOVEL     '1'           *IN85
     C                   ENDIF
      *
      ** Set indicator to protect payment instructions if:
      ** . EMU switchable feature not installed
      ** . If calling function is Deal Amendments input
      ** . If calling function is NAs Sold input
      ** . If EMU installed & Pay currency is not an 'in' currency or Euros
      *
     C     ##PPAY        IFEQ      'Y'
     C     CEU003        IFNE      'Y'
     C     ##CALP        OREQ      'DEAM'
     C     ##CALP        OREQ      'NASS'
     C     CEU003        OREQ      'Y'
     C     #PINCY        ANDNE     'Y'
     C     ##PCCY        ANDNE     BKEURO
     C                   MOVEL     '1'           *IN86
     C                   ENDIF
     C                   ENDIF
      *
     C     DDPMAC        IFNE      'Y'
     C                   MOVEL     '1'           *IN86
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * GETCCYDET - Get currency details                              *
      *****************************************************************
     C     GETCCYDET     BEGSR
 
      **  Access Currency Details
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM                    @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @CURR         DBKEY                          *************
     C                   MOVEL     'SDCURRPD'    DBFILE                         * DB ERR 01 *
     C                   Z-ADD     1             DBASE                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * INIT - Initialisation                                         *
      *****************************************************************
     C     INIT          BEGSR
 
      ** Clear Outputs
 
     C                   MOVEL     *BLANK        RetCodeIn
     C                   CLEAR                   #FPAYS
     C                   CLEAR                   #FRECS
     C                   CLEAR                   #FPAYF
     C                   CLEAR                   #FRECF
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
 
      ** Deal Number
 
     C                   MOVEL     ##DLNO        DDDLNO
 
      ** Receipt Unallocated Account and Account 1
 
     C     DDRMAC        IFEQ      'Y'
     C                   MOVEL     DDRONX        DRUAC
     C                   MOVEL     DDRONX        DRAC01
     C                   ENDIF
 
      ** Payment Unallocated Account and Account 1
 
     C     DDPMAC        IFEQ      'Y'
     C                   MOVEL     DDPONX        DPUAC
     C                   MOVEL     DDPONX        DPAC01
     C                   ENDIF
 
      ** Set Screen Conditioning indicators
 
     C                   EXSR      SETSCNIND
 
      ** Determine Deal Type
 
     C     ##ACTN        IFEQ      'I'
     C                   MOVE      IKTYPE        DLTYPE            2
     C                   ELSE
     C                   MOVE      IKMTYP        DLTYPE
     C                   ENDIF
 
      ** Calculate Total of Principal + Interest of Deal
 
     C     IKAMNP        IFLT      0
     C                   Z-SUB     IKAMNP        UAMNP            15 0
     C                   ELSE
     C                   Z-ADD     IKAMNP        UAMNP
     C                   ENDIF
      *
     C     IKMTTI        IFLT      0
     C                   Z-SUB     IKMTTI        UMTTI            15 0
     C                   ELSE
     C                   Z-ADD     IKMTTI        UMTTI
     C                   ENDIF
      *
     C     UAMNP         ADD       UMTTI         TotAmIn          15 0
     C                   MOVE      TotAmIn       PAmtInRec
     C                   MOVE      TotAmIn       PAmtInPay
      *
      ** If 'Interest Paid Seperately' is set to 'Y' only Principal is allowed
      ** If 'Front up Interest' is set to 'Y' only Principal is allowed
      *
     C                   IF        IKIPDS = 'Y' OR IKFUID = 'Y'
     C                   MOVE      UAMNP         PAmtInRec
     C                   MOVE      UAMNP         PAmtInPay
     C                   ENDIF
      *
      ** Output Receipt Total Amount
      *
     C     DDRMAC        IFEQ      'Y'
      *
      ** If Deposit Deal, only Principal is allowed on Receipt side
     C                   IF        DLTYPE = 'IT' OR DLTYPE = 'TD'
     C                   MOVE      UAMNP         PAmtInRec
     C                   ENDIF
      *
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    PAmtInRec        15 0
     C                   PARM                    RNBDP
     C                   PARM                    BNDCSP
     C                   PARM      *BLANK        PAmtOutS         16
     C                   PARM      *BLANK        PAmtOutU         17
      *
     C                   MOVE      PAmtOutS      DRTAMT
     C                   ENDIF
      *
      ** Output Payment Total Amount
      *
     C     DDPMAC        IFEQ      'Y'
      *
      ** If Loan Deal, only Principal is allowed on Payment side
     C                   IF        DLTYPE = 'IP' OR DLTYPE = 'TI'
     C                   MOVE      UAMNP         PAmtInPay
     C                   ENDIF
      *
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    PAmtInPay        15 0
     C                   PARM                    PNBDP
     C                   PARM                    BNDCSP
     C                   PARM      *BLANK        PAmtOutS
     C                   PARM      *BLANK        PAmtOutU
      *
     C                   MOVE      PAmtOutS      DPTAMT
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters passed into the program
 
     C     *ENTRY        PLIST
      *
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Action code
     C                   PARM                    ##ACTN            1
      *
      ** Deal number
     C                   PARM                    ##DLNO            6
      *
      ** Protect Payment
     C                   PARM                    ##PPAY            1
      *
      ** Protect Receive
     C                   PARM                    ##PREC            1
      *
      ** Calling program
     C                   PARM                    ##CALP            4
      *
      ** Payment currency
     C                   PARM                    ##PCCY            3
      *
      ** Receive currency
     C                   PARM                    ##RCCY            3
      *
      ** Transaction Type
     C                   PARM                    ##TTYP            2
      *
      ** Booking branch
     C                   PARM                    ##BRCA            3
      *
      ** Receipt Date
      ** (must = 99999 if no back valuation validation to be done)
     C                   PARM                    ##DATR            5 0
      *
      ** Payment Date
      ** (must = 99999 if no back valuation validation to be done)
     C                   PARM                    ##DATP            5 0
      *
      ** Payment instructions
     C                   PARM                    ##PAYS
      *
      ** Receive instructions
     C                   PARM                    ##RECS
      *
      ** LDNI Deal details
     C                   PARM                    NwDlFilFmt
      *
      ** OUTPUTS
      ** Function Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      ** Payment - Further Settle instructions - File format
     C                   PARM                    #FPAYF
      ** Receive - Further Settle instructions - File format
     C                   PARM                    #FRECF
 
 
      *
      **  Run date in DDMMMYY
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Access Dealing details via access program
      *
     C                   CALLB     'AODEALR0'
     C                   PARM      '*DBERR '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDDEAL        PARM      SDDEAL        DSFDY
      *
      ** Access General Ledger details
      *
     C                   CALLB     'AOGELRR0'
     C                   PARM      '*DBERR  '    PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDGELR        PARM      SDGELR        DSFDY
      *
      ** Check if switchable feature CEU003 is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY '    @OPTN
     C                   PARM      'CEU003'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU003            1
     C                   ELSE
     C                   MOVE      'N'           CEU003
     C                   ENDIF
      *
      ** Initialize program name
      *
     C                   MOVEL     'ZAFSETISIN'  DBPGM
     C                   MOVEL     'ZAFSETISIN'  ##PGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWSID
 
     C/COPY ZACPYSRC,MSGHNDDATA
 
     C                   ENDSR
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,MSGHNDDSP2
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
** @Z0
00000000000000000000000000000000000000000000000000000000000000000000000000
