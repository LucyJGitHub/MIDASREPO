     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM: MM0089 S/R to calc interest at maturity')    *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MM1010 - Calculate Interest at Maturity                      *
      *             - Subroutine from MM0089                          *
      *                                                               *
      *  Function:  This module receives a number of parameters:      *
      *              - total interest                                 *
      *              - interest to date                               *
      *              - interest payment frequency                     *
      *              - next interest payment date                     *
      *              - value date                                     *
      *              - interest calculation method                    *
      *              - deal amount                                    *
      *              - effective interest rate                        *
      *              - taxable indicator                              *
      *              - deal number                                    *
      *              - maturity date for BRT calculation              *
      *              - BRT tax rate                                   *
      *              - BRT tax rate multiplied by 1 or 0.5            *
      *             From these it calulates the interest at maturity  *
      *             which it returns as another parameter.            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CDL094             Date 11Jun14               *
      *  Prev Amend No. BUG28052           Date 22Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CDL081             Date 14Dec09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL013             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 222373             Date 27Oct03               *
      *                 CAP076             Date 03Jun02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 02Sep97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  BUG28052 - MMM0188 Incorrect new deals principal             *
      *  CDL081 - Tiered withholding tax rounding upgrade             *
      *  CDL013 - Tiered Withholding Tax                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  222373 - Parameter Mismatch                                  *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *           Recompile due to change in MM1030                   *
      *           (new parameter to ZINTDY)                           *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDEAMPP *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FSDCBRTL1  IF   E           K DISK    INFSR(*PSSR)
 
     FMMDEAMLL  IF   E           K DISK    INFSR(*PSSR)
     FSDSTAAL1  IF   E           K DISK    INFSR(*PSSR)                                      CDL013
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Map variable names to indicators to allow use of names instead
      ** of numbers; base the following data structure on a pointer to
      ** the indicator array.
     D Indicators      DS                  BASED(pIndicator)
 
      ** Set the indicator array pointer
     D pIndicator      S               *   INZ(%Addr(*In))
 
     D                 DS
      **  Data structure for SR. MM1010 - Date field YYMMDD.
     D  HNDATE                 1      8  0
     D  HNVDYY                 1      4  0
     D  HNVDMM                 5      6  0
     D  HNVDDD                 7      8  0
                                                                                             CDL013
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                 CDL013
      ** Data Structure for Access Program for Bank Details                                  CDL013
                                                                                             CDL013
                                                                                             CDL013
      ** External data structure for Currencies file                                         CDL013
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                 CDL013
                                                                                             CDL013
      ** External data structure for access programs                                         CDL013
     D DSFDY         E DS                  EXTNAME(DSFDY)                                    CDL013
                                                                                             CDL013
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 CDL081
 
     D @M              S              2  0 DIM(12) CTDATA PERRCD(12)
      **  Array for SR. MM1004 - Days in a month.  (Compile time array)
 
      **  Data structure for SR. MM1004 - Manipulate date input.
     D @@WKDS          DS
     D  @@WKDT                 1      8  0
     D  @@WKYY                 1      4  0
     D  @@WKY                  3      4  0
     D  @@WKM                  5      6  0
     D  @@WKD                  7      8  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Input field @@TINT - Total interest
     D @@TINT          S             15P 0
      * Input field @@INTD - Interest to date
     D @@INTD          S             13P 0
      * Input-field @@INFQ - interest payment frequency
     D @@INFQ          S              1A
      * Input field @@NXIP - Next interest payment date
     D @@NXIP          S              5P 0
      * Input field @@VDAT - value date
     D @@VDAT          S              5P 0
      * Input field @@INCM - interest calculation method
     D @@INCM          S              1A
      * Input field @@DLAM - deal amount
     D @@DLAM          S             15P 0
      * Input field @@EIRT - effective interest rate
     D @@EIRT          S             11P 7
      * Input field @@RDFC - round down inteerst indicator
     D @@RDFC          S              1A
      * Input field @@MTXI - taxable indicator
     D @@MTXI          S              1A
      * Input field @@DEAL - deal number (6N)
     D @@DEAL          S              6P 0
      * Input field @@BRMD - maturity date for BRT calculation
     D @@BRMD          S              5P 0
      * Input field BNHKTR (Hong Kong Tax Rate) from Dealing ICD
C    D BNHKTR          S              5P 2
      * Input field S01383 indicator
     D S01383          S              1A
      * Input field BRTR (BRT Rate) from BRT ICD
C    D BRTR            S              7P 5
      * Input field DEFF (Date Effective From) from BRT ICD
C    D DEFF            S              5P 0
      * Input field PBRTR (BRT Rate - Previous) from BRT ICD
C    D PBRTR           S              7P 5
      * I/P field IKCNUM (Converted Customer No.) from Cust. No. validation
C    D*IKCNUM***       S              6S 0                                                    CSD027
C    D IKCNUM          S              6A                                                      CSD027
 
      * Input field ZCCY (Currency code) set up in calling routine
C    D ZCCY            S              3A
      * Input field ZLOC (Location code) set up in calling routine
C    D ZLOC            S              3A
 
      * Output field @@INMT - Interest at Maturity
     D @@INMT          S             15P 0
 
      * Work field @@INTR used for call to MM1030
     D @@INTR          S             15P 0
 
      ** Work field @@TXAM used for Tax amount                                              BUG28052
     D @@TXAM          S             13P 0                                                  BUG28052
                                                                                            BUG28052
      * Work fields IN80 &IN82, whose purpose not totally clear.
      *  IN82 is set & used in this module, IN80 is set but never used.
      *  IN80 & IN82 are also in ZA0840, but both are reset there before
      *  being used.
     D IN80            S              1P 0
     D IN82            S              1P 0
 
      * Work field @@STRT used for call to ZDATE9, defined here to make it
      *  signed (rather than packed) to avoid problems
     D @@STRT          S              8S 0
      *                                                                                       CDL013
      ** Withholding tax Flag                                                                 CDL013
     D CDL013          S              1A                                                      CDL013
                                                                                              CDL013
     D PRTCD           S              7A                                                      CDL081
     D POPTN           S              7A                                                      CDL081
     D PSARD           S              6A                                                      CDL081
     D W#BSRD          S              1A                                                      CDL081
     D W#NBRD          S              1A                                                      CDL081
     D CDL081          S              1A                                                      CDL081
                                                                                              CDL081
     D P@RTCD          S              7A                                                      CDL081
     D P@OP01          S             20A                                                      CDL081
     D P@VL01          S            200A                                                      CDL081
     D P@OP02          S             20A                                                      CDL081
     D P@VL02          S            200A                                                      CDL081
     D P@OP03          S             20A                                                      CDL081
     D P@VL03          S            200A                                                      CDL081
     D P@OP04          S             20A                                                      CDL081
     D P@VL04          S            200A                                                      CDL081
     D P@OP05          S             20A                                                      CDL081
     D P@VL05          S            200A                                                      CDL081
     D P@OP06          S             20A                                                      CDL081
     D P@VL06          S            200A                                                      CDL081
     D P@OP07          S             20A                                                      CDL081
     D P@VL07          S            200A                                                      CDL081
     D P@OP08          S             20A                                                      CDL081
     D P@VL08          S            200A                                                      CDL081
     D P@OP09          S             20A                                                      CDL081
     D P@VL09          S            200A                                                      CDL081
     D P@OP10          S             20A                                                      CDL081
     D P@VL10          S            200A                                                      CDL081
                                                                                              CDL081
     D C#BASE          C                   CONST('BasCcyTaxRoundDown')                        CDL081
     D C#NBAS          C                   CONST('NBasCcyTaxRoundDown')                       CDL081
 
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
 
     C*   MM1010 - CALCULATION OF INTEREST AT MATURITY                *
     C*                                                               *
     C*  FILES EXPECTED  -  SDDEALPD                                  *
     C*                  -  MMDEAMLL  DEAL AMENDMENTS FILE            *
     C*                  -  SDCBRTL1  BRT CUSTOMER DETAILS FILE       *
     C*                                                               *
     C*  CALLED BY    -                                               *
     C*                                                               *
     C*  CALLS        -  MM1030, CALCULATE INTEREST.                  *
     C*               -  MM1004, DETERMINE DATE OF NEXT PAYMENT.      *
     C*                                                               *
     C*  FIELDS INPUT @@TINT - TOTAL INTEREST                         *
     C*               @@INTD - INTEREST TO DATE                       *
     C*               @@INFQ - INTEREST PAYMENT FREQUENCY             *
     C*               @@NXIP - NEXT INTEREST PAYMENT DATE             *
     C*               @@VDAT - VALUE DATE                             *
     C*               @@INCM - INTEREST CALCULATION METHOD            *
     C*               @@DLAM - DEAL AMOUNT                            *
     C*               @@EIRT - EFFECTIVE INTEREST RATE                *
     C*               @@MTXI - TAXABLE INDICATOR                      *
     C*               @@DEAL - DEAL NUMBER   6N                       *
     C*               @@BRMD - MATURITY DATE FOR BRT CALCULATION      *
     C*               @BRTRT - BRT TAX RATE FROM LF/SDBRTDL1          *
     C*               @BTAXR - @BRTRT MULT. BY 1 OR 0.5               *
     C*                                                               *
     C*  FIELD OUTPUT @@INMT - INTEREST AT MATURITY                   *
     C*                                                               *
     C*  WORKFIELDS   @O     - ARRAY FIELD HOLDING FORMATTED AMOUNT   *
     C*               @@A    - INDEX FIELD FOR REFERENCING @O         *
     C*                                                               *
     C*****************************************************************
     C*
     C*   INITIALISE FIELDS
     C                   Z-ADD     *ZEROS        @@NPDT            5 0
     C                   Z-ADD     @@DEAL        @@DEAL            6 0
     C*
     C*
     C*   CALCULATE TAX AMOUNT
     C*   (ZERO IF TAX INDICATOR IS NOT 'Y')
     C*
     C***/COPY WNCPYSRC,MM0089CP84
     C*
      *                                                                                      CDL013
      *** if CAR CDL013 is installed.                                                        CDL013
     C     CDL013        IFEQ      'Y'                                                       CDL013
      *                                                                                      CDL013
      *** if Tax indicator is ZERO set WHT rate to ZERO.                                     CDL013
     C     @@MTXI        IFEQ      '0'                                                       CDL013
     C                   Z-ADD     0             ULWHTR            5 2                       CDL013
     C                   ELSE                                                                CDL013
      *                                                                                      CDL013
      *** Set WHT rate.                                                                      CDL013
     C                   SELECT                                                              CDL013
     C     @@MTXI        WHENEQ    '1'                                                       CDL013
     C                   Z-ADD     ETXR1         ULWHTR                                      CDL013
     C     @@MTXI        WHENEQ    '2'                                                       CDL013
     C                   Z-ADD     ETXR2         ULWHTR                                      CDL013
     C     @@MTXI        WHENEQ    '3'                                                       CDL013
     C                   Z-ADD     ETXR3         ULWHTR                                      CDL013
     C     @@MTXI        WHENEQ    '4'                                                       CDL013
     C                   Z-ADD     ETXR4         ULWHTR                                      CDL013
     C     @@MTXI        WHENEQ    '5'                                                       CDL013
     C                   Z-ADD     ETXR5         ULWHTR                                      CDL013
     C     @@MTXI        WHENEQ    '6'                                                       CDL013
     C                   Z-ADD     ETXR6         ULWHTR                                      CDL013
     C     @@MTXI        WHENEQ    '7'                                                       CDL013
     C                   Z-ADD     ETXR7         ULWHTR                                      CDL013
     C     @@MTXI        WHENEQ    '8'                                                       CDL013
     C                   Z-ADD     ETXR8         ULWHTR                                      CDL013
     C     @@MTXI        WHENEQ    '9'                                                       CDL013
     C                   Z-ADD     ETXR9         ULWHTR                                      CDL013
     C                   ENDSL                                                               CDL013
      *                                                                                      CDL013
     C                   ENDIF                                                               CDL013
      *                                                                                      CDL013
      *** If WHT rate is ZERO set tax amount to ZERO.                                        CDL013
     C     ULWHTR        IFEQ      *ZERO                                                     CDL013
     C                   Z-ADD     0             @@TXAM                                      CDL013
      *                                                                                      CDL013
      *** otherwise calculate tax amount.                                                    CDL013
     C                   ELSE                                                                CDL013
      *                                                                                      CDL013
      ** access currency file to get number of decimal places                                CDL013
      ** for the broker currency                                                             CDL013
      *  (database error handling done in access program)                                    CDL013
     C                   CALL      'AOCURRR0'                                                CDL013
     C                   PARM      '*DBERR '     @RTCD             7                         CDL013
     C                   PARM      '*KEY   '     @OPTN             7                         CDL013
     C                   PARM      ZCCY          @AJCD             3                         CDL013
     C     SDCURR        PARM      SDCURR        DSFDY                                       CDL013
      *                                                                                      CDL013
      *** if Deal Ccy is equal to Base Ccy round down Interest Amount.                       CDL013
      *** and CDL081 is off                                                                  CDL081
      *                                                                                      CDL081
     C     ZCCY          IFEQ      BJCYCD                                                    CDL013
     C     CDL081        ANDEQ     'N'                                                       CDL081
      *                                                                                      CDL013
      *** set work adjustment field according to decimal places.                             CDL013
     C                   SELECT                                                              CDL013
     C     A6NBDP        WHENEQ    1                                                         CDL013
     C                   Z-ADD     10            ULWKAD            4 0                       CDL013
     C     A6NBDP        WHENEQ    2                                                         CDL013
     C                   Z-ADD     100           ULWKAD                                      CDL013
     C     A6NBDP        WHENEQ    3                                                         CDL013
     C                   Z-ADD     1000          ULWKAD                                      CDL013
     C     A6NBDP        WHENEQ    0                                                         CDL013
     C                   Z-ADD     1             ULWKAD                                      CDL013
     C                   ENDSL                                                               CDL013
      *                                                                                      CDL013
      *** round down Interest Amount.                                                        CDL013
     C     @@TINT        DIV       ULWKAD        ULTINT           15 0                       CDL013
     C                   MULT      ULWKAD        ULTINT                                      CDL013
      *                                                                                      CDL013
      *** calculate and then round down Tax Amount.                                          CDL013
     C     ULTINT        MULT      ULWHTR        @@TXAM                                      CDL013
     C                   DIV       100           @@TXAM                                      CDL013
     C     @@TXAM        DIV       ULWKAD        ULTXAM           15 0                       CDL013
     C     ULTXAM        MULT      ULWKAD        @@TXAM                                      CDL013
      *                                                                                      CDL013
      *** otherwise (Deal Ccy NOT = Base Ccy) calculate Tax amount                           CDL013
      *** without rounding down.                                                             CDL013
     C                   ELSE                                                                CDL013
     C     @@TINT        MULT      ULWHTR        @@TXAM                                      CDL013
                                                                                             CDL081
      ** Check if tax amount is to be rounded down                                           CDL081
                                                                                             CDL081
     C     ZCCY          IFEQ      BJCYCD                                                    CDL081
     C     CDL081        ANDEQ     'Y'                                                       CDL081
     C     W#BSRD        ANDEQ     'Y'                                                       CDL081
     C     ZCCY          ORNE      BJCYCD                                                    CDL081
     C     CDL081        ANDEQ     'Y'                                                       CDL081
     C     W#NBRD        ANDEQ     'Y'                                                       CDL081
     C                   DIV       100           @@TXAM                                      CDL081
     C                   ELSE                                                                CDL081
     C                   DIV(H)    100           @@TXAM                     H                CDL013
     C                   ENDIF                                                               CDL081
     C                   ENDIF                                                               CDL013
      *                                                                                      CDL013
     C                   ENDIF                                                               CDL013
      *                                                                                      CDL013
      *** otherwise perform Original Tax calculations.                                       CDL013
     C                   ELSE                                                                CDL013
      *                                                                                      CDL013
     C*
     C     @@MTXI        IFEQ      *BLANKS
     C     @@MTXI        OREQ      'X'
     C     @@MTXI        OREQ      'N'
     C**********         Z-ADD     *ZEROS        @@TXAM           15 5                      BUG28052
     C                   Z-ADD     *ZEROS        @@TXAM                                     BUG28052
     C                   ELSE
      *                    ****
     C                   Z-ADD     *ZEROS        @@TXAM
     C*
     C** IF BRT SAR INSTALLED
     C*
     C     S01383        IFEQ      'Y'
     C*
     C     @@BRMD        IFGT      0
     C*
     C     @@BRMD        IFGE      DEFF
     C                   Z-ADD     BRTR          @BRTRT            7 5
     C                   ELSE
     C                   Z-ADD     PBRTR         @BRTRT
     C                   END
     C*
     C** ACCESS SDCBRTL1 FOR DEAL CUSTOMER'S BRT TAX INDICATOR (TAXIND)
     C** Only continue if record found on SDCBRTL1
     C*
     C     IKCNUM        CHAIN     SDCBRTL1                           65
     C*
     C     *IN65         IFEQ      '0'
     C     XRECI         ANDEQ     'D'
     C*
     C     TAXIND        IFEQ      'L'
     C     TAXIND        OREQ      'P'
     C*
     C** TAX RATE FOR PART-LIABLE CUSTOMERS IS HALF THE BASIC RATE.
     C*
     C     TAXIND        IFEQ      'L'
     C                   Z-ADD     @BRTRT        @BTAXR            8 6
     C                   ELSE
     C     0.5           MULT      @BRTRT        @BTAXR
     C                   END
     C*
     C     @@TINT        MULT(H)   @BTAXR        @@TXAW           15 5
     C     @@TXAW        DIV(H)    100           @@TXAM
     C                   END
     C*
     C                   END
     C                   END
     C*
     C** ELSE BRT SAR NOT INSTALLED
     C*
     C                   ELSE
     C     @@TINT        MULT(H)   BNHKTR        @@TXAW
     C     @@TXAW        DIV(H)    100           @@TXAM
     C                   END
     C                   END
      *                                                                                       CDL013
     C                   ENDIF                                                                CDL013
      *                                                                                       CDL013
     C*
     C***/COPY WNCPYSRC,MM0089CP85
     C*
     C*
     C*  FIND INTEREST AT MATURITY - NO INTERIM PAYMENTS
     C*
     C     @@NXIP        IFEQ      *ZEROS
     C     FXKEY         KLIST
     C                   KFLD                    @@DEAL
      *  CHECK THERE ARE NO DEAL AMENDMENTS
     C     @@DEAL        CHAIN     MMDEAMLL                           90
     C     *IN90         IFEQ      '1'
     C     @@TINT        SUB       @@INTD        @@INMT           15 0
     C                   SUB       @@TXAM        @@INMT
     C                   GOTO      M11010
     C                   END
      *
     C                   END
      *
      *  CHECK THERE ARE NO DEAL AMENDMENTS
     C     @@DEAL        CHAIN     MMDEAMLL                           90
      *  IF THERE ARE GET THE LATEST
     C     *IN90         IFEQ      '0'
     C     @@EOF         DOUEQ     'Y'
     C     @@DEAL        READE     MMDEAMLL                               90
     C   90              MOVE      'Y'           @@EOF             1
     C                   END
      *REFORMAT DATE FROM YYYMMDD TO MIDAS FORM
     C** REFORMAT DEAM VALUE DATE
     C                   CALLB     'ZDATE10'
     C                   PARM                    HNDATE
      *   STORE DATE
     C                   PARM                    @@ENDD            5 0
     C                   ELSE
      *  IF NO AMENDMENTS  ****
      *  DETERMINE END DATE
      *
     C     @@NXIP        IFNE      *ZEROS
     C     @@INFQ        IFEQ      *BLANKS
     C*   LOAD FIELD
     C                   Z-ADD     @@NXIP        @@ENDD
     C                   ELSE
     C*                    ****
     C                   CALLB     'ZDATE9'
     C                   PARM                    @@NXIP
      *  LOAD INPUT PARAMETER
     C                   PARM                    @@STRT
     C                   PARM                    @@RTN             1                          222373
     C                   MOVE      @@INFQ        @@FREQ            1
     C*  CALL COMMON ROUTINE
     C                   EXSR      MM1004
     C*  LOAD RETURNED PARAMETER - AND REFORMAT
     C                   CALLB     'ZDATE10'
     C                   PARM                    @@NDAT
     C                   PARM                    @@ENDD
      *
     C                   END
     C                   END
     C                   END
      *
      *   CALCULATE INTEREST THAT WILL BE PAID PRIOR TO MATURITY
      *
      *   LOAD PARAMETERS
      *   ===============
      *
     C                   CALLB     'MM1030'
     C                   PARM                    @@VDAT
     C                   PARM                    @@ENDD
     C                   PARM                    @@INCM
     C                   PARM                    @@DLAM
     C                   PARM                    @@EIRT
     C                   PARM                    @@RDFC
     C                   PARM                    @@INTR
     C*
     C*   CALL COMMON ROUTINE
     C*
     C*   CALCULATE INTEREST AT MATURITY
     C**  ASSUME BRT TAX RATE SAME AT PRIOR PAYMENT AS AT MATURITY
     C*
     C     @@TINT        SUB       @@INTR        @@INMT
     C     @@INMT        SUB       @@TXAM        @@INMT
      *
      *  DEFINE INPUT FIELDS WHICH HAVE NOT BEEN DEFINED ALREADY
     C                   GOTO      M11010
     C                   Z-ADD     0             @@TINT           15 0
     C                   Z-ADD     0             @@INTD           13 0
     C                   MOVE      *BLANK        @@INFQ            1
     C                   Z-ADD     0             @@NXIP            5 0
     C                   Z-ADD     0             @@VDAT            5 0
     C                   MOVE      *BLANK        @@INCM            1
     C                   Z-ADD     0             @@DLAM           15 0
     C                   Z-ADD     0             @@EIRT           11 7
     C                   MOVE      *BLANK        @@MTXI            1
 
     C     M11010        TAG
 
     C********************************************************************
 
     C                   RETURN
 
     C********************************************************************
     C*
     C* MM1004 - CALCULATE THE NEXT INTEREST PAYMENT DATE
     C*
     C* CALLED BY :
     C*
     C* CALLS :  ZDATE10, A COMMON ROUTINE TO CONVERT DATE IN YYYYMMDD
     C*          FORMAT TO MIDAS DAY NUMBER.
     C*       :  ZDATE9, A COMMON ROUTINE TO CONVERT MIDAS DAY NUMBER
     C*          TO DATE FORMAT OF YYYYMMDD.
     C*       :  ZCHKH,  A COMMON ROUTINE TO DETERMINE WHETHER A DATE
     C*          IS A WORKING DAY OR A HOLIDAY.
     C*
     C* INPUT  : @@STRT START DATE                           (8N)
     C*          @@FREQ PAYMENT FREQUENCY                    (1A)
     C*          @@MDAY INTEREST PAYMENT DAY IN THE MONTH    (2N)
     C*          @@MDAT MATURITY DATE                        (8N)
     C*          ZCCY   CURRENCY CODE                        (3A)
     C*          ZLOC   LOCATION CODE                        (3A)
     C*
     C* OUTPUT : @@NDAT NEXT PAYMENT DATE (MIDAS DAY NUMBER) (8N)
     C*
     C* USES :   ZZDTIN DATE PASSED TO              ZDATE10  (8N)
     C*          ZZMDNO MIDAS DAY NUMBER FROM       ZDATE10  (5N)
     C*          @@DAYN DAY NUMBER PASSED TO        ZDATE9   (5N)
     C*          @@VDT  DATE IN FORMAT YYYYMMDD     ZDATE9   (8N)
     C*          @@DNO  WORK FIELD - DAY NUMBER              (5N)
     C*          @@CCY  CURRENCY CODE                        (3A)
     C*          @@WF16 WORK FIELD - # DAYS IN THE MONTH     (2N)
     C*          @@HWIN WORK FIELD - HOLIDAY/WORK INDICATOR  (1A)
     C*          @@WKDT WORK FIELDS DS TO MANIPULATE DATE    (8N)
     C*          @@WKYY WORK FIELDS DS  - YEAR FIELD YYYY    (4N)
     C*          @@WKY  WORK FIELDS DS  - YEAR FIELD   YY    (2N)
     C*          @@WKM  WORK FIELDS DS  - MONTH FIELD        (2N)
     C*          @@WKD  WORK FIELDS DS  - DAY FIELD          (2N)
     C*          @@WKD2 WORK FIELDS - MAXIMUM DAYS IN MONTH  (2N)
     C*          @@REM2 LEAP YEAR CALCS - REMAINDER FIELD    (3N)
     C*
     C********************************************************************
     C     MM1004        BEGSR
     C*
     C** Re-set the indicators used within this subroutine.
     C                   MOVE      '0'           *IN80
     C                   MOVE      '0'           *IN82
     C*
     C** Move the start date input into a working fields DS.
     C                   MOVE      @@STRT        @@WKDS
     C*
     C** IF     the interest payment day in month is blank
     C**        THEN     substitue day from start date into that field.
     C** END
     C*
     C     @@MDAY        IFEQ      0
     C                   Z-ADD     @@WKD         @@MDAY            2 0
     C                   END
     C*
     C** IF     the payment frequency is blank
     C**        THEN next interest date is set to maturity date
     C** END
     C*
     C     @@FREQ        IFEQ      *BLANK
     C                   Z-ADD     @@MDAT        @@NDAT
     C                   GOTO      M10049
     C                   END
     C*
     C** IF     the payment frequency is monthly
     C**        THEN     increment the month by 1.
     C** END
     C     @@FREQ        IFEQ      'M'
     C                   ADD       1             @@WKM
     C                   END
     C*
     C** IF     the payment frequency is quarterly.
     C**        THEN     increment the month by 3.
     C** END
     C     @@FREQ        IFEQ      'Q'
     C                   ADD       3             @@WKM
     C                   END
     C*
     C** IF     the payment frequency is six-monthly
     C**        THEN     increment the month by 6.
     C** END
     C     @@FREQ        IFEQ      'X'
     C                   ADD       6             @@WKM
     C                   END
     C*
     C** IF     the payment frequency is yearly
     C**        THEN     increment the year by 1.
     C** END
     C     @@FREQ        IFEQ      'Y'
     C                   ADD       1             @@WKYY
     C                   END
     C*
     C** Substitute day in month into the day field.
     C*
     C                   Z-ADD     @@MDAY        @@WKD
     C*
     C** IF     the new month now exceeds 12
     C**        THEN     subtract 12 from the month
     C**                 increment the year by 1
     C** END
     C*
     C     @@WKM         IFGT      12
     C     @@WKM         SUB       12            @@WKM
     C                   ADD       1             @@WKYY
     C                   END
     C*
     C** IF     the days now exceed the number of days for that month
     C**        THEN     substitue the maximum # of days to that field
     C**              IF     leap year and month is February
     C**                     THEN     add an extra day to the day field
     C**              END
     C** END
     C*
     C                   MOVE      @M(@@WKM)     @@WKD2            2 0
     C     @@WKD2        IFEQ      0
     C                   Z-ADD     1             IN80
     C                   ELSE
     C                   Z-ADD     0             IN80
     C                   END
     C     @@WKD         IFGT      @@WKD2
     C                   Z-ADD     @@WKD2        @@WKD
     C*
     C** Test for leap year, and turn of century leap year.
     C** NB: only every 400 years is a leap year.
     C     @@WKY         IFEQ      0
     C     @@WKYY        DIV       400           @@WF16            3 0
     C                   MVR                     @@REM2            3 0
     C                   ELSE
     C     @@WKYY        DIV       4             @@WF16
     C                   MVR                     @@REM2
     C                   END
     C     @@REM2        IFEQ      0
     C                   Z-ADD     1             IN82
     C                   ELSE
     C                   Z-ADD     0             IN82
     C                   END
     C*
     C     IN82          IFEQ      1
     C     @@WKM         IFEQ      2
     C                   ADD       1             @@WKD
     C                   END
     C                   END
     C*
     C                   END
     C*
     C** Convert payment date to midas format.
     C*
     C                   CALLB     'ZDATE10'
     C                   PARM                    @@WKDT
     C                   PARM                    @@DNO             5 0
     C*
     C** DOWHILE     payment date is NOT a valid woking day
     C**             increment the day number
     C** WEND
     C*
     C     @@HWIN        DOUEQ     'W'
     C                   CALLB     'ZCHKH'
     C                   PARM                    @@DNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    @@HWIN            1
     C     @@HWIN        IFNE      'W'
     C                   ADD       1             @@DNO
     C                   END
     C                   END
     C*
     C** Convert payment day number back to YYYYMMDD format.
     C*
     C                   CALLB     'ZDATE9'
     C                   PARM                    @@DNO
     C                   PARM                    @@NDAT            8 0
     C                   PARM                    @@RTN                                        222373
     C                   GOTO      M10049
     C*
     C**  Unexecuted code to define fields
     C                   MOVEL     @@FREQ        @@FREQ            1
     C                   MOVEL     @@STRT        @@STRT            8 0
     C                   MOVEL     @@MDAT        @@MDAT            8 0
     C                   MOVEL     @@CCY         @@CCY             3
      *
     C     M10049        ENDSR
      *****************************************************************
 
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
 
     C     *entry        PLIST
      *         Input field @@TINT - Total interest
     C                   PARM                    @@TINT
      *         Input field @@INTD - Interest to date
     C                   PARM                    @@INTD
      *         Input-field @@INFQ - interest payment frequency
     C                   PARM                    @@INFQ
      *         Input field @@NXIP - Next interest payment date
     C                   PARM                    @@NXIP
      *         Input field @@VDAT - value date
     C                   PARM                    @@VDAT
      *         Input field @@INCM - interest calculation method
     C                   PARM                    @@INCM
      *         Input field @@DLAM - deal amount
     C                   PARM                    @@DLAM
      *         Input field @@EIRT - effective interest rate
     C                   PARM                    @@EIRT
      *         Input field @@RDFC - round down inteerst indicator
     C                   PARM                    @@RDFC
      *         Input field @@MTXI - taxable indicator
     C                   PARM                    @@MTXI
      *         Input field @@DEAL - deal number (6N)
     C                   PARM                    @@DEAL
      *         Input field @@BRMD - maturity date for BRT calculation
     C                   PARM                    @@BRMD
      *         Input field BNHKTR (Hong Kong Tax Rate) from Dealing ICD
     C                   PARM                    BNHKTR
 
      *         Input field S01383 indicator
     C                   PARM                    S01383
      *         Input field BRTR (BRT Rate) from BRT ICD
     C                   PARM                    BRTR
      *         Input field DEFF (Date Effective From) from BRT ICD
     C                   PARM                    DEFF
      *         Input field PBRTR (BRT Rate - Previous) from BRT ICD
     C                   PARM                    PBRTR
      * I/P field IKCNUM (Converted Customer No.) from Cust. No. validation
     C                   PARM                    IKCNUM
 
      *         Input field ZCCY (Currency code) set up in calling routine
     C                   PARM                    ZCCY
      *         Input field ZLOC (Location code) set up in calling routine
     C                   PARM                    ZLOC
 
      *         Output field @@INMT - Interest at Maturity
     C                   PARM                    @@INMT
     C                   PARM                    CDL013                                       CDL013
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
     C     CDL013        IFEQ      'Y'                                                        CDL013
      *                                                                                       CDL013
      *** Access WHT ICD record to determine WHT rate.                                        CDL013
     C                   MOVEL     *BLANKS       ULSTAX           10                          CDL013
     C                   MOVEL     'RETAIL'      ULSTAX                                       CDL013
     C     ULSTAX        CHAIN     SDSTAAL1                           88                      CDL013
      *                                                                                       CDL013
     C     *IN88         IFEQ      '1'                                                        CDL013
     C                   MOVE      '1'           *INLR                                        CDL013
     C                   MOVE      '1'           *INU7                                        CDL013
     C                   MOVE      '1'           *INU8                                        CDL013
     C                   ENDIF                                                                CDL013
      *                                                                                       CDL013
      **  Access Bank Details via Access Object                                               CDL013
      *  (database error handling done in access program)                                     CDL013
     C                   CALLB     'AOBANKR0'                                                 CDL013
     C                   PARM      '*DBERR'      @RTCD             7                          CDL013
     C                   PARM      '*FIRST '     @OPTN             7                          CDL013
     C     SDBANK        PARM      SDBANK        DSFDY                                        CDL013
      *                                                                                       CDL013
      *                                                                                       CDL013
     C                   ENDIF                                                                CDL013
                                                                                              CDL081
      ** Check if CDL081 is installed                                                         CDL081
                                                                                              CDL081
     C                   EVAL      CDL081 = 'N'                                               CDL081
     C                   CALLB     'AOSARDR0'                                                 CDL081
     C                   PARM      *BLANKS       PRTCD                                        CDL081
     C                   PARM      '*VERIFY'     POPTN                                        CDL081
     C                   PARM      'CDL081'      PSARD                                        CDL081
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL081
                                                                                              CDL081
     C                   IF        PRTCD <> *BLANKS                                           CDL081
     C                             AND PRTCD <> '*NRF'                                        CDL081
     C     *LOCK         IN        LDA                                                        CDL081
     C                   EVAL      DBASE  = 001                                               CDL081
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL081
     C                   EVAL      DBKEY  = PSARD                                             CDL081
     C                   EVAL      DBPGM  = 'MM1010'                                          CDL081
     C                   OUT       LDA                                                        CDL081
     C                   EXSR      *PSSR                                                      CDL081
     C                   ENDIF                                                                CDL081
                                                                                              CDL081
     C                   IF        PRTCD = *BLANKS                                            CDL081
     C                   EVAL      CDL081 = 'Y'                                               CDL081
     C                   ENDIF                                                                CDL081
                                                                                              CDL081
      ** Access withholding tax round down system values if CDL081 is on                      CDL081
                                                                                              CDL081
     C                   IF        CDL081 = 'Y'                                               CDL081
     C                   CALLB     'AOSVALR0'                                                 CDL081
     C                   PARM      *BLANKS       P@RTCD                                       CDL081
     C                   PARM      C#BASE        P@OP01                                       CDL081
     C                   PARM                    P@VL01                                       CDL081
     C                   PARM      C#NBAS        P@OP02                                       CDL081
     C                   PARM                    P@VL02                                       CDL081
     C                   PARM                    P@OP03                                       CDL081
     C                   PARM                    P@VL03                                       CDL081
     C                   PARM                    P@OP04                                       CDL081
     C                   PARM                    P@VL04                                       CDL081
     C                   PARM                    P@OP05                                       CDL081
     C                   PARM                    P@VL05                                       CDL081
     C                   PARM                    P@OP06                                       CDL081
     C                   PARM                    P@VL06                                       CDL081
     C                   PARM                    P@OP07                                       CDL081
     C                   PARM                    P@VL07                                       CDL081
     C                   PARM                    P@OP08                                       CDL081
     C                   PARM                    P@VL08                                       CDL081
     C                   PARM                    P@OP09                                       CDL081
     C                   PARM                    P@VL09                                       CDL081
     C                   PARM                    P@OP10                                       CDL081
     C                   PARM                    P@VL10                                       CDL081
                                                                                              CDL081
     C                   IF        P@RTCD <> *BLANKS                                          CDL081
     C     *LOCK         IN        LDA                                                        CDL081
     C                   IF        P@VL01 = '*NRF'                                            CDL081
     C                   EVAL      DBKEY  = P@OP01                                            CDL081
     C                   ENDIF                                                                CDL081
     C                   IF        P@VL02 = '*NRF'                                            CDL081
     C                   EVAL      DBKEY  = P@OP02                                            CDL081
     C                   ENDIF                                                                CDL081
     C                   EVAL      DBASE  = 002                                               CDL081
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL081
     C                   EVAL      DBPGM  = 'MM1010'                                          CDL081
     C                   OUT       LDA                                                        CDL081
     C                   EXSR      *PSSR                                                      CDL081
     C                   ENDIF                                                                CDL081
                                                                                              CDL081
      ** Setup tax amount rounding down indicators                                            CDL081
                                                                                              CDL081
     C                   EVAL      W#BSRD = P@VL01                                            CDL081
     C                   EVAL      W#NBRD = P@VL02                                            CDL081
     C                   ENDIF                                                                CDL081
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @M  USED BY SR. MM1004 - DAYS IN A MONTH
312831303130313130313031
