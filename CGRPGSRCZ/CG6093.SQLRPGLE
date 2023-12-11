     H DEBUG
     H CCSID(*GRAPH:*SRC)
     F*****************************************************************
/*STD *  RPGSQLBND                                                   *
/*EXI *  TEXT('Midas CG Dealing LIBOR confirmation - Extract')       *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CG6093 - Dealing LIBOR confirmation extract                  *
     F*                                                               *
     F*  Function:  This program xxxxxxxxxxxxxxxxxxxxxxxxxxxx         *
     F*  (phase(s))                                                   *
     F*                                                               *
     F*  Called By: mmCnnnn - (program name)                          *
     F*                                                               *
      *  (c) Finastra International Limited 2021                      *
     F*                                                               *
      *  Last Amend No. MD061615           Date 10Nov23               *
      *  Prev Amend No. MD059367 *CREATE   Date 24Dec21               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD061615 - ME_FT_IMM background job is dumping in New York.  *
      *           - Recompile due to changes in ZCCYXR_ILE. ZAMTT     *
      *             field lenght was increased from 15,0 to 16,0.     *
      *  MD059367 - CDL102 - LIBOR Dealing - Correspondence Manager   *
     F*                                                               *
     F*****************************************************************
     FDLCCGDL0  IF   E           K DISK    USROPN
      ** Deal Charges/Commissions  - Extended file - Rtv idx
     F*
      *
      ** Correspondent file by customer number
      *
     FCGCORRL4  IF   E           K DISK    USROPN
     F*
     FDEALS     IF   E           K DISK
     F                                     INFSR(SRFILE)
     FSDSTAAL1  IF   E           K DISK    USROPN
      ** WHT ICD extension file
     FSDBRTDL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      *
     F/SPACE 5
     D/COPY CGCPYSRC,CGPACKEILE
     D/COPY CGCPYSRC,SRERRDLE
     D**  Number Arrays
     D*##NUMA***       S              1    DIM(29)
     D*
     D* ##GRP = Group/RDE Number               ##RDE = RDE + Attributes
     D*
     D ##GRP           S             10    DIM(503) CTDATA PERRCD(1)
     D ##RDEA          S             22    DIM(503) ALT(##GRP)
     D*
     D*
     D*
     D**  Array of Currencies accessed by program
     D ##CY            S              3    DIM(100)
     D*
     D**  Arrays of Deal Type (DTYP) and the associated print item sub-type.
     D***********         ##DT    1  41  2   ##PS   10
     D**********          ##DT    1  47  2   ##PS   10
     D ##DT            S              2    DIM(10) CTDATA PERRCD(1)
     D ##PS            S             10    DIM(10) ALT(##DT)
     D*
     D**  Loan Deal Types.
     D***********         #LN     7   7  2
     D #LN             S              2    DIM(10) CTDATA PERRCD(10)
      *
      ** Arrays used to retrieve percentage of current range for
      ** Deal Principal Amount
      *
     D*
     D**  Copyright array.
     D*
     D*********** DS
     D***********                         B   1   20##OSEQ
     D****Convert Ouput Sequence between Numeric and Binary
     D*
     D                 DS
     D  ##GRPX                 1     10
     D  ##GRPS                 1      6
     D  ##RDEN                 7     10  0
     D**  Look-up string for RDE definition Array
     D*
     D ##SDS           DS
     D**********                              15120 ##S
     D  ##S                    1   5632
     D                                     DIM(22)
     D**  Packed data string.
     D*
     D                 DS
     D  ##W                    1     20
     D                                     DIM(20)
     D  ##WNUM                 1     20  0
     D**  Number Field
     D*
     D                 DS
     D  ##ITMA                 1      8
     D  ##ITEM                 1      8  0
     D** Used to convert item reference from character to numeric
     D*
     D*
     D*---------------------------------------------------------------------
     D* Named constants
     D*
     D W#PTBO          C                   CONST('MMINTERCNF')
     D W#PHON          C                   CONST('Telephone')
     D W#DLSW          C                   CONST('DLFSWIFTConf')
     D C#BASE          C                   CONST('BasCcyTaxRoundDown')
     D C#NBAS          C                   CONST('NBasCcyTaxRoundDown')
     D #SUPRS          C                   CONST('SupCorr4CustwSwiftID')
     D WUSEDL          C                   CONST('GrossMMDepInterest')
     D*
      *
      ** External DS for nostro details
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      *
     D*
     D*---------------------------------------------------------------------
     D ##UDCR        E DS                  EXTNAME(CGUDCRPD)
      ** External DS for incomplete reference
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  External DS for Bank details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACC4       E                     EXTFLD(QQACCD)
      **  External DS for General Ledger details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      **  External DS for Module details
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  QQACC1       E                     EXTFLD(QQACCD)
      **  External DS for Dealing Module details
      *
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQACC2       E                     EXTFLD(QQACCD)
      **  External DS for Trading Module details
      *
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACC3       E                     EXTFLD(QQACCD)
      **  External DS for Retail details
      *
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      **  External DS for Message Management details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      **  External DS for branch details
      *
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)
      **  External DS for customer details
      *
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      **  External DS for base rate details
      *
     D SDCURR        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
      **  External DS for currency details
      *
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** MIDAS Switchable Features Accessed Via Access Program
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Second DS for access programs, long data structure
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      **  Second DS for access programs, long data structure
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)

     D SDACUS        E DS                  EXTNAME(SDACUSPD)
      *
     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
      **  Record format of PF/CGUDTAPD for use as a parameter
      *
     D***##SRDT*     DS                         20
     D ##SRDT          DS                  OCCURS(80)
      **  DS to store subroutine specific data.
      **  - Saved Path
      **  - Previous bind
      **  - This bind
     D  ##SPAT                 1     70
     D  ##PBIN                71     75P 0
     D  ##TBIN                76     80P 0
     D               E DS                  EXTNAME(DLCCGDPD)
      *
      ** Data-structure used to set up arrays ZRA and ZPE from
      ** FID Deposit Commission/Charges type details file
      ** DLCCGDPD, to locate the highest range for Principal amount.
      *
     D  ZRA                   31    142P 0
     D                                     DIM(14) ASCEND
     D  ZPE                  143    202P 0
     D                                     DIM(15)
      *
      *
     D/COPY CGCPYSRC,CGPACKIILE
      *
      ** Temporary DS for SDHSDRTD

     D DlyDS           DS
     D DintStart                      5p 0
     D DintEnd                        5p 0
     D Dintd                          5p 0
     D Dindy                          5p 0
     D Dobdt                          5p 0
     D Dobdy                          5p 0
     D Dbrfr                         17p12
     D Drtap                         17p12
     D Dcalm                          4a
     D Davcr                         17p12
     D Dcmrt                         17p12
     D Dsmav                         17p12

     D CPYR            DS
      **  Data Structure for Compilation - Copyright Insertion
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
      ** Parameters for call to CG4985.
     D P1PARM          DS           768
      * Pay - Settlement method
     D  P1PSTM                 1      2  0
      * Pay - Our Nostro
     D**********                              3  14 P1PONS
     D  P1POQQ                 3     14
      * Pay - Intermidiary bank no
     D  P1PIBN                15     25
      * Pay - Intermidiary account no
     D  P1PIBA                26     60
      * Pay - Ordering bank No
     D**********                             61  690P1POBN
     D  P1POBN                61     69
      * Pay - Ordering customer no
     D**********                             70  780P1POCN
     D  P1POCN                70     78
      * Receiver Correspondent no
     D  P1RCRN                79     89
      * Receiver Correspondent a/c line
     D  P1RCRA                90    124
      * Receiver Number
     D  P1RVNO               125    135
      * A/C with bank no
     D  P1AWBN               136    146
      * A/C with bank a/c line
     D  P1AWBA               147    181
      * Beneficiary number
     D  P1BENN               182    192
      * Beneficiary account line
     D  P1BENA               193    227
      * Details of pay 1
     D  P1DTP1               228    262
      * Details of pay 2
     D  P1DTP2               263    297
      * Details of pay 3
     D  P1DTP3               298    332
      * Details of pay 4
     D  P1DTP4               333    367
      * Details of Charges
     D  P1DCHG               368    370
      * Bank to bank info - 1
     D  P1BTB1               371    405
      * Bank to bank info - 2
     D  P1BTB2               406    440
      * Bank to bank info - 3
     D  P1BTB3               441    475
      * Bank to bank info - 4
     D  P1BTB4               476    510
      * Bank to bank info - 5
     D  P1BTB5               511    545
      * Bank to bank info - 6
     D  P1BTB6               546    580
      * Currency
     D  P1CCY                581    583
      *
      ** 087000 - include additional details to allow determination
      ** of prime retail account for settlement method 04.
     D  P1CNUM               584    589
     D  P1ACCD               590    599
     D  P1BRCH               600    602
     D  P1PONS               603    620
      *
      ** Parameters for call to CG4985.
      **
     D P3PARM          DS           256
      * Output Sequence
     D  P1OSEQ                 1      9  0
      * UDC item number
     D  P1ITEM                10     17  0
      * This bind level
     D  P1TBIN                18     25  0
      * Previous bind level
     D  P1PBIN                26     33  0
      *
      **  Parameters for call to CG4975.
      **
     D P6PARM          DS           256
      * Receipt - Settlement method
     D  P1RSTM                 1      2  0
      * Receipt - Our Nostro
     D  P1ROQQ                 3     14
      * Receipt - Intermidiary bank no
     D  P1RIBN                15     25
      * Receipt - Intermidiary account no
     D  P1RIBA                26     60
      * Receipt - Ordering bank No
     D  P1ROBN                61     69
      * Receipt - Ordering customer no
     D  P1ROCN                70     78
      * Branch
     D  R1BRCH                79     81
      * Currency
     D  R1CCY                 82     84
      *
      ** 087000 - include additional details to allow determination
      ** of prime retail account for settlement method 04.
     D  R1CNUM                85     90
     D  R1ACCD                91    100
     D  P1RONS               101    118
      *
     D ##ADS           DS          5120
      *
      ** Parameters for call to CG4975.
      **
     D P5PARM          DS           256
      * Output Sequence
     D  R1OSEQ                 1      9  0
      * UDC item number
     D  R1ITEM                10     17  0
      * This bind level
     D  R1TBIN                18     25  0
      * Previous bind level
     D  R1PBIN                26     33  0
     D P7PARM          DS           256
      * Account Officer
     D  P1ACOF                 1      2
      *
     D                 DS
     D  P@ASEQ                 5      6  0
     D  P@CNUM                 7     12
     D  P@STYP                13     14  0
     D  P@ACCT                15     24  0
      *
     D  XCINPDT        S              5  0
     D WPARML          C                   CONST('LECalcBasis6LeapYear')
      *
     D/COPY ZSRSRC,ZINTDYZ1LE
     D/COPY ZSRSRC,ZDATE9Z2LE
     D/COPY ZSRSRC,ZDAT10Z1LE
      *
      ** DS for AOSVALR0
      *
     D SVAL1           DS           200
     D  SVAL11                 1      1
     I/COPY ZSRSRC,ZPOWERZ1IL
     I/COPY ZSRSRC,ZDATE9Z1LE
     IDEALSDBF      01
     IDEALSDCF      02
     IDEALSDDF      03
     IDEALSDEF      04
     I              SCUS                        CNUM
     IDEALSDGF      05
      *****************************************************************
      * Process     :  MAINLINE                                       *
      * Function    :  Mainline processing                            *
      *                                                               *
      * Called by   :  None                                           *
      * Calls       :  SRINIT - Initial Processing - On First Call    *
      *                SRINZ  - Initialise Fields on Each Invocation  *
      *                SRMAIN - Main Processing                       *
      *****************************************************************
      *
      **  Parameter list for current program invocation.
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7
     C                   PARM                    W0CMT             3
     C                   PARM                    ##COPD            1
     C                   PARM                    XDLNO             6 0
     C                   PARM                    XCINPSD           5 0
     C                   PARM                    XKEY3             3
      *
     C                   movel     XKEY3         KEY3              3
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      *................................................................
      *
      **  Initial processing - Once Only
     C     ##INIT        IFEQ      *BLANK
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT            1
     C                   ENDIF
      *
      **  Initialisation processing
     C                   EXSR      SRINZ
      *
      **  Main processing
     C                   EXSR      SRMAIN
      *
      *................................................................
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      **  Terminate program
     C                   RETURN
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRMAIN                                         *
      * Function    :  Main processing                                *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :                                                 *
      *****************************************************************
     C     SRMAIN        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRMAIN'      @STK(Q)
      *
      *................................................................
      *
      ** Access Deal
      *
     C                   EXSR      SRDEAL
      *
      *
      **  Generate reference number by writing to PF/CGUDCRPD
      **  If no confirmation to be produced, then bypass
      *
     C     *LIKE         DEFINE    DTYP          ##DTYP
     C                   MOVEL     DTYP          ##DTYP
     C                   MOVE      'N'           ##COPD
      *
     C                   EXSR      SRGENR
     C     ##COPD        CABEQ     'N'           EXMAIN
      *
      *
     C                   EXSR      DMMICF
      *................................................................
      *
     C     EXMAIN        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  DMMICF                                         *
      * Function    :  Loan & Deposit Interest Advices                *
      *                                                               *
      * Called by   :  SRXLDI                                         *
      * Calls       :                                                 *
      *****************************************************************
     C     DMMICF        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'DMMICF'      @STK(Q)
      *
      *................................................................
      *
      **  Set up Path.
     C                   MOVEL     '\dMMICF'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS
      *
      **  Store Path
     C     1             OCCUR     ##SRDT
     C                   MOVEL     S#PATH        ##SPAT
      *
      *
      ** Branch Details
     C                   EXSR      BRANCH
      *
      ** Base Deal Event Details
     C                   EXSR      D@BASM
      *
      ** Loan & Deposit Settlement Details
     C                   EXSR      D@LADS
      *
      ** Receive Settlement Ins required if interest due for loan
     C                   Z-ADD     1             #1
     C     ##DTYP        LOOKUP    #LN(#1)                                99    * loan
     C     *IN99         IFEQ      '1'
     C                   MOVEL     CCY           ##CCY
      *
      ** Set the Receipt Settlement Currency
      *
     C                   MOVE      STCY          ##RSCY            3
      *
     C                   EXSR      D@RECS
      *
      ** Extended Settlement Receipts
     C                   EXSR      EX@REC
      *
     C                   END
      *
      ** Payment Settlement Ins required if interest due for deposit
     C                   Z-ADD     1             #1
     C     ##DTYP        LOOKUP    #LN(#1)                                99    * loan
     C     *IN99         IFEQ      '0'
     C                   MOVEL     CCY           ##CCY
      *
      ** Set the Payment Settlement Currency
      *
     C                   MOVE      STCY          ##PSCY            3
      *
     C                   EXSR      D@PAYS
      *
      ** Extended Settlement Payments
     C                   EXSR      EX@PAY
      *
      *
     C                   END
      *
      *
      ** If CER038 is installed
      *
     C     CER038        IFEQ      'Y'
     C     IMET          IFEQ      '01'
     C     IMET          OREQ      '08'
     C     IMET          OREQ      '14'
      *
      ** Extract Alternative Interest settlements
      *
     C                   EXSR      CGINPS
      *
     C                   ENDIF
     C                   ENDIF
      ** Customer Details
     C                   EXSR      CUST
      *
      ** Counterparty Account Officer Details
     C                   EXSR      ACOF
      *
      ** Other Deal Details
     C                   EXSR      D@OTH1
      *
      ** Retrieve Receive Details for CDL094
     C     CDL094        IFEQ      'Y'
     C                   MOVEL(P)  CCY           @NSKYB
     C                   EXSR      RTVRCV
     C                   ENDIF
     C*
      *
      ** If CER038 is installed
      *
     C     CER038        IFEQ      'Y'
      *
      ** Open Correspondent file
      *
     C                   OPEN      CGCORRL4
      *
      ** Extract new Fields
      *
     C                   MOVE      ORBR          WBRNCH            3
     C                   EXSR      CGBRCH
      *
      ** Close Correspondent file
      *
     C                   CLOSE     CGCORRL4
      *
     C                   ENDIF
      *
      * Repeating LIBOR details
     C                   EXSR      LIBOR
      *................................................................
      *
     C     EXMMIC        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
     C*
     C/COPY CGCPYSRC,CGBRCH
     C/COPY CGCPYSRC,CGDLAD
     C/COPY CGCPYSRC,CGINPS
     C*
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  BRANCH                                         *
      * Function    :  Branch Details                                 *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *****************************************************************
     C     BRANCH        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'BRANCH'      @STK(Q)
      *
      *................................................................
      *
      **  Retrieve subroutine specific data.
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
      *
      **  Set up Path.
     C                   MOVEL     '\BRANCH'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS
      *
      **  Retrieve RDE information for RDEs in group set
      *
     C                   MOVEL     @STK(Q)       ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Get Branch Details
      *
     C     BRCA          IFNE      ##BRCD
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*MSG    '    ##RTCD
     C                   PARM      '*KEY    '    ##OPTN
     C                   PARM      BRCA          ##BRCD            3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      ** DATABASE ERROR
      *
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDBRCHPD'    W0FILE
     C                   MOVEL     BRCA          W0KEY
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Get Customer Details for Branch Internal Customer
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      A8BICN        ##KEY1           10
     C                   PARM      *BLANKS       ##KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** DATABASE ERROR
      *
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     A8BICN        W0KEY
     C                   Z-ADD     2             W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Store Booking Branch, Branch Internal Customer Number and Name
      *
     C     *LIKE         DEFINE    BRCA          BBBRCA
     C                   MOVEL     BRCA          BBBRCA
     C     *LIKE         DEFINE    BBCUST        BBBICN
     C                   MOVEL     BBCUST        BBBICN
     C     *LIKE         DEFINE    BBCRNM        BICRNM
     C                   MOVEL     BBCRNM        BICRNM
      *
      ** Store : Sender's (i.e. Branch)
      **             SWIFT TID Address,
      **             STTX Address
      **             Telex Address
      ** (All used in message routing)
      *
     C                   MOVEL     A8BTID        ##SCSD
     C                   MOVEL     BBSTAD        ##SSTD
     C                   MOVEL     BBTXA1        ##STXA
     C                   END
      *
      ** Branch
     C                   MOVEL     A8BRCD        ##D(1)
      *
      ** Branch Name
     C                   MOVEL     A8BRNM        ##D(2)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
      *................................................................
      *
     C     EXBRCH        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  CUST                                           *
      * Function    :  Customer Details                               *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *****************************************************************
     C     CUST          BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'CUST  '      @STK(Q)
      *
      *................................................................
      *
      **  Retrieve subroutine specific data.
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
      *
      **  Set up Path.
     C                   MOVEL     '\CUST  '     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS
      *
      **  Retrieve RDE information for RDEs in group set
      *
     C                   MOVEL     @STK(Q)       ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Get Customer Details
      *
     C                   MOVEL     CNUM          ##KEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM                    ##KEY1
     C                   PARM      *BLANKS       ##KYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** DATABASE ERROR
      *
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCUSTPD'    W0FILE                         ******
     C                   MOVEL     CNUM          W0KEY                          * DB E
     C                   Z-ADD     4             W0ERNB                         ******
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Store Customer Name
      *
     C     *LIKE         DEFINE    BBCRNM        CPCRNM
     C                   MOVEL     BBCRNM        CPCRNM
      *
      ** Store : Destination Customer's (i.e. Counterparty)
      **             SWIFT TID Address,
      **             STTX Address
      **             Telex Address
      **             Default Network for MTnnn messages
      ** (All used in message routing)
      *
     C                   MOVEL     BBCSID        ##DCSD
     C                   MOVEL     BBSTAD        ##DSTD
     C                   MOVEL     BBTXA1        ##DTXA
     C                   MOVEL     BBDNW3        ##DDNW                         *MT300
      *
      ** Determine Message Routing
      *
     C                   CALL      'CG99DTMR'                           99      *
     C                   PARM                    ##SCSD           12            *Send.
     C                   PARM                    ##SSTD           12            *Send.
     C                   PARM                    ##STXA           10            *Send.
     C                   PARM                    ##DCSD           12            *Dest.
     C                   PARM                    ##DSTD           12            *Dest.
     C                   PARM                    ##DTXA           10            *Dest.
     C                   PARM                    ##DDNW            6            *Dest.
     C                   PARM      BGMSDL        ##MSDL            1            *Midas
     C                   PARM      BGMTMI        ##MTMI            1            *Midas
     C                   PARM      BLSWPY        ##SWPY            1 0          *SWIFT
     C                   PARM      BLTXPY        ##TXPY            1 0          *TELEX
     C                   PARM      *BLANK        ##NETW            6            *Netwo
     C                   PARM      *BLANK        ##RTCD            7
      *
     C     *IN99         IFEQ      '1'
     C     ##RTCD        ORNE      *BLANK
      *
      ** DATABASE ERROR
      *
     C                   MOVEL     'CG99DTMR'    W0FILE                         ***************
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 05 *
     C                   Z-ADD     5             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** Customer
     C                   MOVEL     BBCUST        ##D(1)
      *
      ** Customer Name
     C                   MOVEL     BBCRNM        ##D(2)
      *
      ** Customer Address Line 1
     C                   MOVEL     BBCNA1        ##D(3)
      *
      ** Customer Address Line 2
     C                   MOVEL     BBCNA2        ##D(4)
      *
      ** Customer Address Line 3
     C                   MOVEL     BBCNA3        ##D(5)
      *
      ** Customer Address Line 4
     C                   MOVEL     BBCNA4        ##D(6)
      *
      ** Customer Town
     C                   MOVEL     BBCRTN        ##D(7)
      *
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
      *................................................................
      *
     C     EXCUST        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  ACOF                                           *
      * Function    :  Account Officer Details                        *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *****************************************************************
     C     ACOF          BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'ACOF  '      @STK(Q)
      *
      *................................................................
      *
      **  Retrieve subroutine specific data.
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
      *
      **  Set up data.
     C                   CLEAR                   P7PARM
     C                   MOVEL     BBACOC        P1ACOF
      *
     C                   CLEAR                   P4PARM
     C                   MOVEL     S#PATH        P4PARM
      *
     C                   CLEAR                   P5PARM
     C                   Z-ADD     ##OSEQ        R1OSEQ
     C                   Z-ADD     ##ITEM        R1ITEM
     C                   Z-ADD     DETBIN        R1TBIN
     C                   Z-ADD     DEPBIN        R1PBIN
      *
     C                   CALL      'CG4976'
     C                   PARM      *BLANKS       W0RTN             7
     C                   PARM                    P7PARM
     C                   PARM                    P4PARM          140            Path
     C                   PARM                    W0CMT             3
     C                   PARM                    P5PARM
     C                   PARM                    ##REFR                         Referen
     C                   PARM                    P@ICR                          Increme
     C                   PARM      'N'           ##MAST                         Call Ma
      *
      **  Reset Sequence number.
     C                   Z-ADD     R1OSEQ        ##OSEQ
     C                   Z-ADD     R1TBIN        DETBIN
     C                   Z-ADD     R1PBIN        DEPBIN
      *
      *................................................................
      *
     C     EXACOF        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  D@BASM                                         *
      * Function    :  Base Deal Event Details                        *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *****************************************************************
     C     D@BASM        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'D_BASM'      @STK(Q)
      *
      *................................................................
      *
      **  Retrieve subroutine specific data.
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
      *
      **  Set up Path.
     C                   MOVEL     '\D_BASM'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS
      *
      **  Retrieve RDE information for RDEs in group set
      *
     C                   MOVEL     @STK(Q)       ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Deal Number
     C                   MOVEL     DLNO          ##D(1)
      *
      ** Deal Date
     C                   MOVEL     DDAT          ##D(2)
      *
      ** Event Date
     C                   MOVEL     BJRDNB        ##D(3)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
      *................................................................
      *
     C     EXBASM        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  D@LADS                                         *
      * Function    :  Loan & Deposit Settlement Details              *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *****************************************************************
     C     D@LADS        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'D_LADS'      @STK(Q)
      *
      *................................................................
      *
      **  Retrieve subroutine specific data.
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
      *
      **  Set up Path.
     C                   MOVEL     '\D_LADS'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS
      *
      **  Retrieve RDE information for RDEs in group set
      *
     C                   MOVEL     @STK(Q)       ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Next Interest Payment date = event date
     C                   MOVEL     BJRDNB        ##D(1)
      *
      ** Last Interest Payment date
     C                   MOVEL     SLID          ##D(2)
      *
      ** Currency
     C                   MOVEL     CCY           ##D(3)
      *
      ** Principal
      ** (as calculated)
     C                   MOVEL     PCPL          ##D(4)
     C                   MOVEL     CCY           ##CCY
     C                   EXSR      SRDCDT
     C                   MOVE      A6NBDP        ##D(4)
      *
      ** Value Date
     C                   MOVEL     VDAT          ##D(5)
      *
     C                   z-add     0             XEAMT            13 0
      ** Extract interest from Account Key
      ** Consisder CD and TD
     C                   select
     C                   when      DTYP = 'CD' or DTYP = 'TD'
      * If switchable core feature Withholding Tax (S01460) is implemented, extract
      * net interest amount from C D I Y Y b b b b N key
     C                   If        S01460 = 'Y'
     C/exec SQL
     C+ select EAMT into :XEAMT
     C+ from DLKYLBPD
     C+ where DLNO = :XDLNO and substr(AKEY,3,1) = :KEY3
     C+ and substr(AKEY,10,1) = 'N'
     C/end-exec
     C                   else
      * If switchable core feature Tiered Withholding Tax (CDL013) is implemented, extr
      * net interest amount from C D I Y Y b b b b N key
      * unless GrossMMDepInterest is G, in that case, extract
      * Interest due not taxable from C D I Y Y b b b b I and
      * Interest due taxable (Gross) from C D I Y Y b b G T I
     C                   If        CDL013 = 'Y'
     C                   If        WDLCUS = 'G'
     C/exec SQL
     C+ select EAMT into :XEAMT
     C+ from DLKYLBPD
     C+ where DLNO = :XDLNO and substr(AKEY,3,1) = :KEY3
     C+ and substr(AKEY,10,1) = 'G'
     C/end-exec
     C                   else
     C/exec SQL
     C+ select EAMT into :XEAMT
     C+ from DLKYLBPD
     C+ where DLNO = :XDLNO and substr(AKEY,3,1) = :KEY3
     C+ and substr(AKEY,10,1) = 'I'
     C/end-exec
     C                   ENDIF
     C                   else

      * If switchable core feature Tax on Savings Income European Directive (CGL035) is
      * extract Net Interest amount paid (deal currency) from
      * C D I Y Y b b b U N key
     C                   If        CGL035 = 'Y'
     C/exec SQL
     C+ select EAMT into :XEAMT
     C+ from DLKYLBPD
     C+ where DLNO = :XDLNO and substr(AKEY,3,1) = :KEY3
     C+ and substr(AKEY,10,1) = 'N'
     C/end-exec
     C                   else

      * If switchable core feature Withholding Tax Management (CER048) is implemented,
      * Gross Interest amount paid from C D I Y Y b b b B I key
     C                   If        CER048 = 'Y'
     C/exec SQL
     C+ select EAMT into :XEAMT
     C+ from DLKYLBPD
     C+ where DLNO = :XDLNO and substr(AKEY,3,1) = :KEY3
     C+ and substr(AKEY,10,1) = 'I'
     C/end-exec
     C                   else

      * If switchable core feature Church Tax (CER054) is implemented, extract
      * Gross Interest amount paid from C D I Y Y b b b B I key
     C                   If        CER054 = 'Y'
     C/exec SQL
     C+ select EAMT into :XEAMT
     C+ from DLKYLBPD
     C+ where DLNO = :XDLNO and substr(AKEY,3,1) = :KEY3
     C+ and substr(AKEY,10,1) = 'I'
     C/end-exec
     C                   else

      * If switchable core feature Dual Withholding Tax (CGL165) is implemented, extrac
      * Net interest amount paid from C D I Y Y b b b b N key
     C                   If        CGL165 = 'Y'
     C/exec SQL
     C+ select EAMT into :XEAMT
     C+ from DLKYLBPD
     C+ where DLNO = :XDLNO and substr(AKEY,3,1) = :KEY3
     C+ and substr(AKEY,10,1) = 'N'
     C/end-exec
     C                   else
      * If none of the features are on, extract interest from
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   OTHER
      * extract interest amount from d d I s s b b b b I
     C/exec SQL
     C+ select EAMT into :XEAMT
     C+ from DLKYLBPD
     C+ where DLNO = :XDLNO and substr(AKEY,3,1) = :KEY3
     C+ and substr(AKEY,10,1) = 'I'
     C/end-exec
     C                   ENDSL
      ** Gross Interest
      ** (as calculated)
     C                   MOVEL     XEAMT         ##D(6)
     C                   MOVE      A6NBDP        ##D(6)
      *
      ** DETERMINE TAX AMOUNT
     C                   Z-ADD     *ZERO         ##TAXA           13 0
     C                   Z-ADD     *ZERO         WNTAMT           13 0
     C                   Z-ADD     *ZERO         WSTAX            13 0
     C                   Z-ADD     *ZERO         WNSTAX           13 0
     C                   Z-ADD     *ZERO         WTTAX            13 0
     C                   Z-ADD     *ZERO         WNTTAX           13 0
     C                   MOVE      *BLANK        WSTAT            13 0
      *
      *
      *
      ** Tax Indicator
     C                   MOVEL     TAXI          ##D(9)
      *
      ** Loan/Deposit Indicator
     C                   Z-ADD     1             #1
     C     ##DTYP        LOOKUP    #LN(#1)                                99    *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'L'           ##D(10)
     C                   ELSE
     C                   MOVEL     'D'           ##D(10)
     C                   END
      *
      ** Currency Description
     C                   MOVEL     A6CYNM        ##D(11)
      *
      ** Precious Metal Indicator
     C                   MOVEL     A6PMRT        ##D(12)
      *
      ** Conf. narrative
     C                   MOVEL     CNNA          ##D(13)
      *
      ** Net Interest in Settlement Currency; calculate using D@EURO
      *
     C*    STCY          IFNE      *BLANKS
     C**********           MOVE ##NETA    P@FRAM
     C*                  Z-ADD     ##NETA        P@FRAM
     C*                  MOVE      CCY           P@FRCY
     C*                  MOVE      STCY          P@TOCY
     C*                  EXSR      D@EURO
     C*                  MOVEL     ##OUTA        ##D(14)
     C*                  MOVEL     STCY          ##CCY
     C*                  EXSR      SRDCDT
     C*                  MOVE      A6NBDP        ##D(14)
     C*                  ENDIF
     C*
     C     CEU014        IFEQ      'Y'
     C*
     C* If the Event currency is 'In' or 'Euro' currency, convert
     C*  Net Interest amount to Equivalent currency.
     C*
     C                   MOVE      *BLANKS       EQCY              3
     C                   MOVE      CCY           ##CCY
     C                   EXSR      SRDCDT
     C*
     C* If the Event currency is 'In', the Equivalent currency is
     C*  Euros.
     C     A6INCY        IFEQ      'Y'
     C                   MOVE      BKEURO        EQCY
     C                   ENDIF
     C*
     C*
     C* Equivalent currency and description
     C                   MOVEL     EQCY          ##D(16)
     C                   MOVEL     A6CYNM        ##D(17)
     C                   ENDIF
     C*
     C*
      *
      ** Local Currency
      *
     C                   MOVEL     BJCYCD        ##D(18)
      *
     C                   MOVEL     BJCYCD        ##CCY
     C                   EXSR      SRDCDT
      *
      ** Currency Rate
      *
     C                   MOVEL     A6SPRT        ##D(19)
     C                   MOVE      8             ##D(19)
      *
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
      *
     C                   EXSR      SRADTA
     C                   MOVEL     ##SDS         ##ADS
      *
      **  Retrieve RDE information for RDEs in group set
      *
     C                   Z-ADD     21            ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Resident/ Non-Resident Flag
      *
     C*                  MOVEL     RESID         ##D(1)
      *
      ** Customer Tax Status
      *
     C*                  MOVEL     WSTAT         ##D(2)
      *
      ** Interest Payment Frequency
      *
     C                   MOVEL     IPFR          ##D(3)
      *
      ** Base Rate Name
      *
     C                   MOVEL     CCY           ##CYCD            3
     C********** BRTT          IFEQ      0                                           MD
     C     BRTT          IFEQ      *BLANKS
     C                   MOVEL     *BLANKS       ##D(4)
     C                   ELSE
     C                   MOVEL     BRTT          ##BSRC            2
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM                    ##CYCD
     C                   PARM                    ##BSRC
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
      ** DATABASE ERROR
      *
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDBSRTPD'    W0FILE
     C                   MOVEL     ##BSRC        W0KEY
     C                   Z-ADD     62            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVEL     BABSRN        ##D(4)
     C                   ENDIF
      *
      ** Spread Rate
      *
     C                   MOVEL     *BLANKS       R#DATA
     C                   MOVEL     RTSP          R#DATA
     C                   MOVEL     R#DATA        ##D(5)
     C                   MOVEL     *BLANKS       R#DATA
      *
      ** Interest Calculation Basis
      *
     C                   MOVEL     ICBS          ##D(6)
      *
      *
      **  Benchmark Adjustment
      *
     C                   MOVEL     BADJ          ##D(7)
      *
      **  Day Basis for Average
      *
     C                   MOVEL     DBAV          ##D(8)
      *
      **  Floor
      *
     C                   MOVEL     FLOR          ##D(9)
      *
      **  Lockout days
     C                   MOVEL     LODY          ##D(10)
      *
      **  Lookback days
      *
     C                   MOVEL     LBDY          ##D(11)
      *
      **  Observation Period Shift
      *
     C                   MOVEL     OPSH          ##D(12)
      *
      **  Risk Free Rate
      *
     C                   MOVEL     RFRR          ##D(13)
      *
      **  Rates Known Indicator
      *
     C                   MOVEL     RTKN          ##D(14)
      *
      **  Rate rounding decimals
      *
     C                   MOVEL     RRDP          ##D(15)
      *
      **  Calculation Method
      *
     C                   MOVEL     CALM          ##D(16)
      *
      ** Maturity Date
     C                   MOVEL     MDAT          ##D(17)
      *
      ** Base Rate Code
     C                   MOVEL     ##BSRC        ##D(18)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
      *................................................................
      *
     C     EXLADS        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  D@OTH1                                         *
      * Function    :  Other Deal Details                             *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *****************************************************************
     C     D@OTH1        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'D_OTH1'      @STK(Q)
      *
      *................................................................
      *
      **  Retrieve subroutine specific data.
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
      *
      **  Set up Path.
     C                   MOVEL     '\D_OTH1'     ##PNAM            7
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS
      *
      **  Retrieve RDE information for RDEs in group set
      *
     C                   MOVEL     @STK(Q)       ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Cancel/Amend
      *
     C     CHTP          IFEQ      'R'
     C     CHTP          OREQ      'A'
     C                   MOVEL     CHTP          ##D(1)
     C                   END
      *
      ** Federal funds
     C                   EXSR      SRDFED
     C                   MOVEL     ##FEDL        ##D(2)                         FROM SR
      *
      ** Auto-transmission
     C                   EXSR      SRDAUT
     C                   MOVEL     ##AUTO        ##D(3)                         FROM SR
      *
      ** Deal Type
     C                   MOVEL     DTYP          ##D(4)
      *
      ** Deal Sub Type
     C                   MOVEL     DLST          ##D(5)
      *
      ** Blocked Flag
     C                   MOVEL     FSBLKA        ##D(6)
      *
      ** Fix Base Rate flag
     C                   MOVEL     FSFBRT        ##D(7)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
      *................................................................
      *
     C     EXOTH1        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  RTVRCV                                         *
      * Function    :  Retrieve Receive Details for CDL094            *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *                                                               *
      *****************************************************************
     C     RTVRCV        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'RTVRCV'      @STK(Q)
      *
      *................................................................
      *
      **  Retrieve subroutine specific data.
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
      *
      **  Set up Path.
     C                   MOVEL     '\RTVRCV'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS
      *
      **  Retrieve RDE information for RDEs in group set
      *
     C                   MOVEL     @STK(Q)       ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Retrieve Receive Details (Bank to Bank information, Intermediary,
      ** Beneficiary, Delivery Agent, Account lines)
     C                   MOVEL(P)  RBTB1         ##D(1)
     C                   MOVEL(P)  RBTB2         ##D(2)
     C                   MOVEL(P)  RBTB3         ##D(3)
     C                   MOVEL(P)  RBTB4         ##D(4)
     C                   MOVEL(P)  RBTB5         ##D(5)
     C                   MOVEL(P)  RBTB6         ##D(6)
      *
     C     RSTM          IFEQ      08
      *
      ** Call AONOSTR1 to retrieve receive details
     C                   CALL      'AONOSTR1'
     C                   PARM      '*MSG   '     ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM      *BLANKS       @NSKYA            6
     C                   PARM                    @NSKYB            3
     C                   PARM      *BLANKS       @NSKYC           10
     C                   PARM      *BLANKS       @NSKYD            2
     C                   PARM      RONS          @NSKYE            2
     C                   PARM      *BLANKS       @KEYF             3
     C                   PARM      *BLANKS       @KEYG            10
     C                   PARM      *BLANKS       @KEYH             1
     C     SDNOST        PARM      SDNOST        DSSDY
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL(P)  A7RF56        ##D(7)
     C                   MOVEL(P)  A7RA56        ##D(8)
     C                   MOVEL(P)  A7RF57        ##D(9)
     C                   MOVEL(P)  A7RA57        ##D(10)
     C                   MOVEL(P)  A7RF58        ##D(11)
     C                   MOVEL(P)  A7RA58        ##D(12)
     C                   ENDIF
     C                   ENDIF
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
      *................................................................
      *
     C     EXRCV         TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  D@PAYS                                         *
      * Function    :  Payment Settlement Instructions                *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *****************************************************************
     C     D@PAYS        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'D_PAYS'      @STK(Q)
      *
      *................................................................
      *
     C                   MOVEL     'N'           WFFLG             1
      **  Retrieve subroutine specific data.
     C     WFFLG         IFNE      'Y'
     C     1             OCCUR     ##SRDT
     C                   ELSE
     C     5             OCCUR     ##SRDT
     C                   ENDIF
     C                   MOVEL     ##SPAT        S#PATH
      *
      **  Set up Path.
     C                   MOVEL     '\D_PAYS'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS
      *
      **  Set up binds from passed in values if fee details exist
      *
     C     WFFLG         IFEQ      'Y'
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
     C                   ENDIF
      *
      **  Retrieve RDE information for RDEs in group set
      *
     C                   MOVEL     @STK(Q)       ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** DETERMINE SETTLEMENT INSTRUCTION FIELDS
      *
     C                   MOVEL     'P'           ##PYRC                         *Pay/Rec
     C*
     C     CEU003        IFEQ      'Y'
     C     ##PSCY        ANDNE     *BLANKS
     C                   MOVEL     ##PSCY        ##CCY
     C                   ELSE
     C                   MOVEL     ##CCY         ##CCY                          *Settlem
     C                   ENDIF
     C*
     C                   MOVEL     'N'           ##ROLL                         *Rollove
      *
     C                   MOVEL     PSTM          ##SETP                         *Settlem
     C                   MOVEL     POBR          ##STBR                         *Settlem
     C                   MOVEL     PONS          ##OURN                         *Our nos
     C     RVNO          IFNE      *BLANK                                       * RECEIV
     C     RCRN          IFNE      *BLANK                                       * RECEIV
     C                   MOVEL     RCRN          ##THRN                         *Their n
     C                   ELSE
     C                   MOVEL     *HIVAL        ##THRN                         *Their n
     C                   END                                                     = OUR N
     C                   ELSE
     C                   MOVEL     AWBN          ##THRN                         *Their n
     C                   END
     C                   MOVEL     BENN          ##FACO                         *For acc
     C                   EXSR      SRDSET
      *
      **  Payment - Our A/C - Line 1
     C                   MOVEL     ##OAC1        ##D(1)
      *
      **  Payment - Our A/C - Line 2
     C                   MOVEL     ##OAC2        ##D(2)
      *
      **  Payment - Our Nostro Name
     C                   MOVEL     ##ONN         ##D(3)
      *
      **  Payment - Our Nostro Town
     C                   MOVEL     ##ONT         ##D(4)
      *
      **  Payment - Our A/C (Gen.Led.)
     C                   MOVEL     ##OGA         ##D(5)
      *
      **  Payment - Our A/C (Retail)
     C                   MOVEL     ##ORA         ##D(6)
      *
      **  Payment - Their A/C - Line 1
     C                   MOVEL     ##TAC1        ##D(7)
      *
      **  Payment - Their A/C - Line 2
     C                   MOVEL     ##TAC2        ##D(8)
      *
      **  Payment - Their Nostro Name
     C                   MOVEL     ##TNN         ##D(9)
      *
      **  Payment - Their Nostro Town
     C                   MOVEL     ##TNT         ##D(10)
      *
      **  Payment - For A/C Of - Line 1
     C                   MOVEL     ##FAL1        ##D(11)
      *
      **  Payment - For A/C Of - Line 2
     C                   MOVEL     ##FAL2        ##D(12)
      *
      **  Payment - For A/C Of Name
     C                   MOVEL     ##FAN         ##D(13)
      *
      **  Payment - For A/C Of Town
     C                   MOVEL     ##FAT         ##D(14)
      *
      **  Special Instructions
     C                   MOVEL     SPI           ##D(15)
      *
     C     ##PSCY        IFNE      *BLANKS
      *
      ** Payment Settlement Currency
     C                   MOVEL     ##PSCY        ##D(16)
      *
      ** Payment Settlement Currency Description
     C                   MOVEL     ##PSCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6CYNM        ##D(17)
     C                   ENDIF
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
      *................................................................
      *
     C     EXPAYS        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  EX@PAY                                         *
      * Function    :  Other payment settlement instructions          *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *****************************************************************
     C     EX@PAY        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'EX@PAY'      @STK(Q)
      *
      *................................................................
      *
      **  Retrieve subroutine specific data.
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
      *
      **  Set up Path.
     C                   MOVEL     '\ex_pay'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS
      *
      **  Set up data.
     C                   EXSR      MOVDTA
      *
     C                   CALL      'CG4985'
     C                   PARM      *BLANKS       W0RTN             7
     C                   PARM                    P1PARM
     C                   PARM                    P2PARM          140            Path
     C                   PARM                    W0CMT             3
     C                   PARM                    P3PARM
     C                   PARM                    ##REFR                         Referenc
     C                   PARM                    P@ICR                          Incremen
     C                   PARM      'N'           ##MAST                         Call Mas
      *
      **  Reset Sequence number.
     C                   Z-ADD     P1OSEQ        ##OSEQ
     C                   Z-ADD     P1TBIN        DETBIN
     C                   Z-ADD     P1PBIN        DEPBIN
      *
      *................................................................
      *
     C     EXXPAY        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  D@RECS                                         *
      * Function    :  Receive Settlement Instructions                *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *****************************************************************
     C     D@RECS        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'D_RECS'      @STK(Q)
      *
      *................................................................
      *
      **  Retrieve subroutine specific data.
     C     WFFLG         IFNE      'Y'
     C     1             OCCUR     ##SRDT
     C                   ELSE
     C     4             OCCUR     ##SRDT
     C                   ENDIF
     C                   MOVEL     ##SPAT        S#PATH
      *
      **  Set up Path.
     C                   MOVEL     '\D_RECS'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS
      *
      **  Set up binds from passed in values if fee details exist
      *
     C     WFFLG         IFEQ      'Y'
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
     C                   ENDIF
      *
      **  Retrieve RDE information for RDEs in group set
      *
     C                   MOVEL     @STK(Q)       ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** DETERMINE SETTLEMENT INSTRUCTION FIELDS
      *
     C                   MOVEL     'R'           ##PYRC                         *Pay/Rec
     C*
     C     CEU003        IFEQ      'Y'
     C     ##RSCY        ANDNE     *BLANKS
     C                   MOVEL     ##RSCY        ##CCY
     C                   ELSE
     C                   MOVEL     ##CCY         ##CCY                          *Settlem
     C                   ENDIF
     C*
     C                   MOVEL     'N'           ##ROLL                         *Rollove
      *
     C                   MOVEL     RSTM          ##SETP                         *Settlem
     C                   MOVEL     ROBR          ##STBR                         *Settlem
     C                   MOVEL     RONS          ##OURN                         *Our nos
     C                   MOVEL     RIBN          ##THRN                         *Their n
     C                   MOVEL     *BLANK        ##FACO                         *For acc
     C                   EXSR      SRDSET
      *
      **  Receive - Our A/C - Line 1
     C                   MOVEL     ##OAC1        ##D(1)
      *
      **  Receive - Our A/C - Line 2
     C                   MOVEL     ##OAC2        ##D(2)
      *
      **  Receive - Our Nostro Name
     C                   MOVEL     ##ONN         ##D(3)
      *
      **  Receive - Our Nostro Town
     C                   MOVEL     ##ONT         ##D(4)
      *
      **  Receive - Our A/C (Gen.Led.)
     C                   MOVEL     ##OGA         ##D(5)
      *
      **  Receive - Our A/C (Retail)
     C                   MOVEL     ##ORA         ##D(6)
      *
      **  Receive - Their A/C - Line 1
     C                   MOVEL     ##TAC1        ##D(7)
      *
      **  Receive - Their A/C - Line 2
     C                   MOVEL     ##TAC2        ##D(8)
      *
      **  Receive - Their Nostro Name
     C                   MOVEL     ##TNN         ##D(9)
      *
      **  Receive - Their Nostro Town
     C                   MOVEL     ##TNT         ##D(10)
      *
     C     ##RSCY        IFNE      *BLANKS
      *
      ** Receipt Settlement Currency
     C                   MOVEL     ##RSCY        ##D(11)
      *
      ** Receipt Settlement Currency Description
     C                   MOVEL     ##RSCY        ##CCY
     C                   EXSR      SRDCDT
     C                   MOVEL     A6CYNM        ##D(12)
     C                   ENDIF
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
      *................................................................
      *
     C     EXRECS        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  EX@REC                                         *
      * Function    :  Other receipt settlement instructions          *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *****************************************************************
     C     EX@REC        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'EX@REC'      @STK(Q)
      *
      *................................................................
      *
      **  Retrieve subroutine specific data.
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
      *
      **  Set up Path.
     C                   MOVEL     '\ex_rec'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS
      *
      **  Set up data.
     C                   EXSR      MOVDTB
      *
     C                   CALL      'CG4975'
     C                   PARM      *BLANKS       W0RTN             7
     C                   PARM                    P6PARM
     C                   PARM                    P4PARM          140            Path
     C                   PARM                    W0CMT             3
     C                   PARM                    P5PARM
     C                   PARM                    ##REFR                         Referenc
     C                   PARM                    P@ICR                          Incremen
     C                   PARM      'N'           ##MAST                         Call Mas
      *
      **  Reset Sequence number.
     C                   Z-ADD     R1OSEQ        ##OSEQ
     C                   Z-ADD     R1TBIN        DETBIN
     C                   Z-ADD     R1PBIN        DEPBIN
      *
      *................................................................
      *
     C     EXXREC        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRDAUT                                         *
      * Function    :  Determine if Auto-Transmission of Confirmation *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :                                                 *
      *****************************************************************
     C     SRDAUT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRDAUT'      @STK(Q)
      *
      *................................................................
      *
     C                   MOVEL     'N'           ##AUTO            1
      *
     C     BGSWDL        IFEQ      'Y'                                          * SWIFT/
     C     BGMTDL        OREQ      'Y'                                          * MIDAS/
      *
     C     *IN02         IFEQ      '1'                                          * LOAN/D
      *
     C     CSW005        OREQ      'Y'                                          *  CSW00
     C     *IN05         ANDEQ     *ON                                          * FRA/IR
     C     DTYP          ANDEQ     'FR'                                         *  Fwd R
      *
     C     CSW005        OREQ      'Y'                                          *  CSW00
     C     *IN05         ANDEQ     *ON                                          * FRA/IR
     C     DTYP          ANDEQ     'RS'                                         *  Singl
      *
     C     CSW005        OREQ      'Y'                                          *  CSW00
     C     *IN05         ANDEQ     *ON                                          * FRA/IR
     C     DTYP          ANDEQ     'RX'                                         *  Cross
      *
     C     CSW011        OREQ      'Y'                                          *  CSW01
     C     CSW005        ANDNE     'Y'                                          *  CSW00
     C     *IN05         ANDEQ     *ON                                          * FRA/IR
     C     DTYP          ANDEQ     'FR'                                         *  FRA
      *
      ** FX deals confirmation
      *
     C     *IN01         OREQ      '1'
     C     DTYP          ANDEQ     'OP'
      *
     C     ##NETW        IFNE      'PAPER '                                     * NETWOR
     C     ##NETW        OREQ      'PAPER '                                     * NETWOR
     C     ENFFCR        ANDNE     'Y'                                          * FREE F
     C                   MOVEL     'Y'           ##AUTO
     C                   END
      *
     C                   END
     C                   END
     C*
      *
      *................................................................
      *
     C     EXDAUT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRDFED                                         *
      * Function    :  Determine if Federal Funds                     *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *****************************************************************
     C     SRDFED        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRDFED'      @STK(Q)
      *
      *................................................................
      *
     C                   MOVEL     'N'           ##FEDL            1
      *
      * CHECK APPROPRIATE BIT OF DEAL STATIC INDICATORS
      *
     C   01              TESTB     '2'           DSTI                     99    * PUCY =
     C   01
     CANN99              TESTB     '3'           DSTI                     99    * SLCY =
     C   02              TESTB     '2'           DSTI                     99    * DEPOSI
     C   02
     CANN99              TESTB     '3'           DSTI                     99    * LOAN
     C   03              TESTB     '3'           DSTI                     99    * NAB
     C   04              TESTB     '3'           DSTI                     99    * NAS
     C   05              TESTB     '2'           UDSTI                    99    * FRA/IR
     C   05
     CANN99              TESTB     '2'           TDSTI                    99    * FRA/IR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'Y'           ##FEDL
     C                   END
      *
      *................................................................
      *
     C     EXDFED        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCURR - Retrieve Currency Details                           *
      *                                                               *
      *****************************************************************
     C     SRCURR        BEGSR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     PCCY          DBKEY
     C                   MOVEL     '067'         DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INU7
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRDSET                                         *
      * Function    :  Determine Settlement Instruction Fields        *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :                                                 *
      *****************************************************************
     C     SRDSET        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRDSET'      @STK(Q)
      *
      *................................................................
      *
     C                   CALL      'CG99DSET'                           99      *
      *
     C** In
      *
     C                   PARM                    ##PYRC            1            *Pay/Rec
     C                   PARM                    ##CCY             3            *Settlem
     C                   PARM                    ##ROLL            1            *Rollove
     C                   PARM                    ##SETP            2            *Settlem
     C                   PARM                    ##STBR            3            *Settlem
     C                   PARM                    ##OURN           18
     C                   PARM                    ##THRN           10            *Their n
     C                   PARM                    ##FACO           10            *For acc
     C                   PARM      BBBRCA        ##BKBR            3            *Booking
     C                   PARM      BBBICN        ##BKBB            6            *Booking
     C                   PARM      ##CUST        ##CNTP            6            *Custome
     C                   PARM      BNACCD        ##CSAC           10
     C                   PARM      BMACCD        ##CADC           10
     C                   PARM      BKACCD        ##COMS           10
     C                   PARM      BLACCD        ##DEFA           10
     C                   PARM      BJLCCY        ##LOCY            3            *Local C
     C                   PARM      BLONOC        ##ONOC            1            *Ourselv
      *
      ** Out
      *
     C                   PARM      *BLANKS       ##OAC1            3            *Our Lin
     C                   PARM      *BLANKS       ##OAC2            3            *Our Lin
     C                   PARM      *BLANKS       ##ONN            30            *Our Nos
     C                   PARM      *BLANKS       ##ONT            20            *Our Nos
     C                   PARM      *BLANKS       ##OGA            24            *Our GL
     C                   PARM      *BLANKS       ##ORA            20            *Our RE
     C                   PARM      *BLANKS       ##TAC1            3            *Thr Lin
     C                   PARM      *BLANKS       ##TAC2            3            *Thr Lin
     C                   PARM      *BLANKS       ##TNN            30            *Thr Nos
     C                   PARM      *BLANKS       ##TNT            20            *Thr Nos
     C                   PARM      *BLANKS       ##FAL1            3            *FACO Li
     C                   PARM      *BLANKS       ##FAL2            3            *FACO Li
     C                   PARM      *BLANKS       ##FAN            30            *FACO Na
     C                   PARM      *BLANKS       ##FAT            20            *FACO To
     C                   PARM      *BLANKS       ##RTCD            7            *Return
      *
     C     *IN99         IFEQ      '1'
     C     ##RTCD        ORNE      *BLANK
      *
      ** DATABASE ERROR
      *
     C                   MOVEL     'CG99DSET'    W0FILE                         ***************
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 12 *
     C                   Z-ADD     12            W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *................................................................
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRDEAL                                         *
      * Function    :  Access Deal                                    *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *****************************************************************
     C     SRDEAL        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRDEAL'      @STK(Q)
      *
      *................................................................
      *
     C     XDLNO         CHAIN     DEALS                              99
      *
      ** IF DEAL NOT FOUND, OR INVALID FORMAT ACCESSED
      *
     C     *IN99         IFEQ      '1'
      *
      ** DATABASE ERROR
      *
     C                   MOVEL     'DEALS   '    W0FILE                         ***************
     C                   MOVEL     DLNO          W0KEY                          * DB ERROR 13 *
     C                   Z-ADD     13            W0ERNB                         ***************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *---------------------------------------------------------------*
      *
     C     EXDEAL        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C********************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  MOVDTA                                         *
      * Function    :  Set up parameters for call to CG4985.          *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *****************************************************************
     C     MOVDTA        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'MOVDTA'      @STK(Q)
      *
      *................................................................
      *
     C                   CLEAR                   P1PARM
     C                   Z-ADD     PSTM          P1PSTM
     C                   MOVEL     PONS          P1PONS
     C                   MOVEL     PIBN          P1PIBN
     C                   MOVEL     PIBA          P1PIBA
     C                   MOVE(P)   POBN          P1POBN
     C                   MOVE(P)   POCN          P1POCN
     C                   MOVEL     RCRN          P1RCRN
     C                   MOVEL     RCRA          P1RCRA
     C                   MOVEL     RVNO          P1RVNO
     C                   MOVEL     AWBN          P1AWBN
     C                   MOVEL     AWBA          P1AWBA
     C                   MOVEL     BENN          P1BENN
     C                   MOVEL     BENA          P1BENA
     C                   MOVEL     DTP1          P1DTP1
     C                   MOVEL     DTP2          P1DTP2
     C                   MOVEL     DTP3          P1DTP3
     C                   MOVEL     DTP4          P1DTP4
     C                   MOVEL     DCHG          P1DCHG
     C                   MOVEL     BTB1          P1BTB1
     C                   MOVEL     BTB2          P1BTB2
     C                   MOVEL     BTB3          P1BTB3
     C                   MOVEL     BTB4          P1BTB4
     C                   MOVEL     BTB5          P1BTB5
     C                   MOVEL     BTB6          P1BTB6
      *
     C*
     C     CEU003        IFEQ      'Y'
     C     STCY          ANDNE     *BLANKS
     C                   MOVEL     STCY          P1CCY
     C                   ELSE
     C                   MOVEL     CCY           P1CCY
     C                   ENDIF
     C*
      *
     C                   CLEAR                   P2PARM
     C                   MOVEL     S#PATH        P2PARM
      *
     C                   CLEAR                   P3PARM
     C                   Z-ADD     ##OSEQ        P1OSEQ
     C                   Z-ADD     ##ITEM        P1ITEM
     C                   Z-ADD     DETBIN        P1TBIN
     C                   Z-ADD     DEPBIN        P1PBIN
      *
     C                   MOVEL     CNUM          P1CNUM
     C                   MOVEL     BMACCD        P1ACCD
      *
      *................................................................
      *
     C     EXVDTA        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  MOVDTB                                         *
      * Function    :  Set up parameters for call to CG4975.          *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *****************************************************************
     C     MOVDTB        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'MOVDTB'      @STK(Q)
      *
      *................................................................
      *
     C                   CLEAR                   P6PARM
     C                   Z-ADD     RSTM          P1RSTM
     C                   MOVEL     RONS          P1RONS
     C                   MOVEL     RIBN          P1RIBN
     C                   MOVEL     RIBA          P1RIBA
     C                   MOVE(P)   ROBN          P1ROBN
     C                   MOVE(P)   ROCN          P1ROCN
      *
     C**  If EMU CEU003 is installed, use settlement currency if
     C**  defined.
     C*
     C                   SELECT
     C     *IN02         WHENEQ    *ON
     C     *IN03         OREQ      *ON
     C     *IN04         OREQ      *ON
     C*
     C     CEU003        IFEQ      'Y'
     C     STCY          ANDNE     *BLANKS
     C                   MOVEL     STCY          R1CCY
     C                   ELSE
     C                   MOVEL     CCY           R1CCY
     C                   ENDIF
     C*
     C     *IN01         WHENEQ    *ON
     C*
     C     CEU003        IFEQ      'Y'
     C     RSCY          ANDNE     *BLANKS
     C                   MOVEL     RSCY          R1CCY
     C                   ELSE
     C                   MOVEL     SLCY          R1CCY
     C                   ENDIF
     C*
     C     *IN05         WHENEQ    *ON
     C*
     C     CEU003        IFEQ      'Y'
     C     RSCY          ANDNE     *BLANKS
     C                   MOVEL     RSCY          R1CCY
     C                   ELSE
     C                   MOVEL     TCUCY         R1CCY
     C                   ENDIF
     C*
     C                   ENDSL
      *
     C                   CLEAR                   P4PARM
     C                   MOVEL     S#PATH        P4PARM
      *
     C                   CLEAR                   P5PARM
     C                   Z-ADD     ##OSEQ        R1OSEQ
     C                   Z-ADD     ##ITEM        R1ITEM
     C                   Z-ADD     DETBIN        R1TBIN
     C                   Z-ADD     DEPBIN        R1PBIN
      *
      ** 087000 - set up details for primary retail account
     C                   MOVEL     CNUM          R1CNUM
     C                   MOVEL     BMACCD        R1ACCD
      *
      *................................................................
      *
     C     EXVDTB        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRGENR                                         *
      * Function    :  Generate reference number                      *
      *                by writing to PF/CGUDCRPD                      *
      *                                                               *
      * Called by   :  SRMAIN - Main Processing                       *
      * Calls       :  CG9010 - Create reference record               *
      *****************************************************************
     C     SRGENR        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRGENR'      @STK(Q)
      *
      *................................................................
      *
      *
      *
      **  Generate reference number and check if further processing
      **  required. Set up all available information in the record
      **  format before calling.
      *
     C                   MOVEL     BRCA          DRBRCA
     C                   MOVEL     ORBR          DRORBR
     C                   MOVEL     'DL'          DRMODI
     C                   MOVEL     XDLNO         DRMTRN
     C                   MOVEL     *BLANK        DRMACT
      *
      ** Print Type
      *
     C                   MOVEL     W#PTBO        DRPTYP                         * Buy-O
     C*
     C*
      *
      ** Print Sub Type
      *
     C                   Z-ADD     1             #1
     C     ##DTYP        LOOKUP    ##DT(#1)                               99    *
     C                   MOVEL     ##PS(#1)      DRPSTP                         *
      *
     C                   MOVEL     CNUM          ##CUST
      *
     C                   CALL      'CG9010'
     C                   PARM                    ##RTCD            7
     C                   PARM      '*GEN'        ##MODE           10
     C                   PARM      W0CMT         ##CMT             3
     C                   PARM                    ##CUST            6
     C                   PARM                    ##UDCR
     C                   PARM                    ##ITMA            8
      *
      **  Blank return code implies generate correspondence.
      **  CGD1270 => no error, but suppress output for this transaction.
      *
     C     ##RTCD        IFEQ      *BLANK
      *
     C                   MOVE      'Y'           ##COPD
      *
      ** Pass reference as PRINTTYPE:SUBTYPE.
      *
     C     DRPTYP        CAT(P)    ':':0         COLON            11
     C     COLON         CAT(P)    DRPSTP:0      ##REFR
      *
     C                   EXSR      WRAPRF
      *
     C                   ELSE
      *
     C     ##RTCD        IFNE      'CGD1270'
     C                   MOVEL     'CG9010  '    W0FILE
     C                   MOVEL     ##RTCD        W0KEY                          *******
     C                   Z-ADD     15            W0ERNB                         * DB ER
     C                   MOVEL     'CGD1286'     W0MSGD                         *******
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
      *................................................................
      *
     C     EXGENR        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Subroutine  :  SRRRDE                                         *
      * Function    :  Retrieve RDE information for RDEs in group set *
      *                                                               *
      * Called by   :  Simple group set subroutines                   *
      * Calls       :  -                                              *
      *****************************************************************
     C     SRRRDE        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRRRDE'      @STK(Q)
      *
      *................................................................
      *
      **  Reset
     C                   MOVEL     *BLANK        ##R
     C                   MOVEL     *BLANK        ##D
     C                   MOVEL     *BLANK        ##S
      *
      **  Get information about next 20 RDEs in group set from compile
      **  time arrays
     C                   Z-ADD     0             #1
     C     *IN99         DOUEQ     '0'
     C     #1            OREQ      20
     C                   Z-ADD     1             #2
     C     ##GRPX        LOOKUP    ##GRP(#2)                              99    *
     C     *IN99         IFEQ      '1'
     C                   ADD       1             #1
     C                   MOVEL     ##RDEA(#2)    ##R(#1)
     C                   ADD       1             ##RDEN
     C                   ENDIF
     C                   ENDDO
      *
      *................................................................
      *
     C     EXRRDE        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Subroutine  :  SRADTA                                         *
      * Function    :  Accumulate RDEs and associated data for output *
      *                                                               *
      * Called by   :  Simple group set subroutines                   *
      * Calls       :  CG3999 - Format and Pack Data                  *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     SRADTA        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRADTA'      @STK(Q)
      *
      *................................................................
      *
      **  Reformat RDE data
      *
     C                   EXSR      SRRFMN
      *
      **  Pack RDEs and associated data into data string
     C                   CLEAR                   ##SDS
      *
      ** Set-up Action Code parameter W0ACT
      *
     C     CCG015        IFEQ      'Y'
     C                   MOVE      '*NEWARR '    W0ACT
     C                   MOVEL     S#PATH        W0SPAT
     C                   ELSE
     C                   MOVE      '*PACK   '    W0ACT
     C                   MOVEL     *BLANKS       W0SPAT
     C                   ENDIF
      *
     C                   CALL      'CG3999'
     C                   PARM      *BLANK        ##RTCD
     C                   PARM                    W0ACT
     C                   PARM                    ##R
     C                   PARM                    ##D
     C                   PARM                    ##S
     C                   PARM                    W0SPAT           70
     C                   PARM                    ##RN
     C                   PARM                    ##DN
     C                   PARM                    ##FM
      *
      **  Database error
     C     ##RTCD        IFNE      *BLANK
      *
     C                   MOVEL     'CG3999  '    W0FILE                         ********
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERR
     C                   Z-ADD     16            W0ERNB                         ********
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Write a XML record for RDE.
      *
     C                   EXSR      WRTRDE
      *
      **  Initialise Write Format Parameter.
     C                   CLEAR                   W0FMT
      *
      **  Set up Control Information.
     C                   Z-ADD     ##ITEM        DEITEM
     C                   ADD       1             ##OSEQ
     C                   Z-ADD     ##OSEQ        DEOSEQ
     C                   Z-ADD     1             DEPBIN
     C                   Z-ADD     1             DETBIN
     C                   MOVE      'FR'          DEFSLI
     C                   MOVE      *BLANKS       W0PATH
     C                   MOVEL     S#PATH        W0PATH
      *
      **  Append Data from pack routine.
     C     W0FMT         CAT       ##SDS:0       W0FMT
      *
      *................................................................
      *
     C     EXADTA        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Subroutine  :  SRRLA                                          *
      * Function    :  Subroutine to convert range limits amount held *
      *                on FID charges/comm. file, from base currency  *
      *                to deal currency, if Commission tables in base *
      *                currency.                                      *
      *                                                               *
      * Called by   :  FIDUC                                          *
      * Calls       :                                                 *
      *****************************************************************
     C     SRRLA         BEGSR
      *
      **  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRRLA'       @STK(Q)
      *
     C                   Z-ADD     A6SPRT        ZEXCH
      *
     C     A6MDIN        IFEQ      'D'
     C                   MOVE      'D'           ZMD
     C                   ELSE
     C                   MOVE      'M'           ZMD
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        ZCDPO
      *
      ** Get base currency details
      *
     C                   MOVEL     BJCYCD        ##CCY
     C                   EXSR      SRDCDT
      *
     C                   Z-ADD     A6NBDP        ZCDPI
      *
      ** Process all array entries.
      *
     C                   Z-ADD     0             I                 2 0
      *
     C     1             DO        14            I
     C                   Z-ADD     ZRA(I)        ZAMTCI
      *
      ** Convert range limit amount from Base currency to Deal currency
      *
     C                   EXSR      ZCONVN
      *
     C                   Z-ADD     ZAMTCO        ZRA(I)
      *
     C                   ENDDO
      *
      **  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Subroutine  :  SRRFMN                                         *
      * Function    :  Reformat RDE data                              *
      *                                                               *
      * Called by   :  SRADTA                                         *
      * Calls       :                                                 *
      *****************************************************************
     C     SRRFMN        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRRFMN'      @STK(Q)
      *
      *................................................................
      *
      ** Loop through RDE's and data
      *
     C                   Z-ADD     0             #1
     C     #1            DOUEQ     20
     C                   ADD       1             #1
     C                   MOVEL     ##R(#1)       R#DEFN
     C                   MOVEL     ##D(#1)       R#DATA
      *
      ** If data present and RDE is edited
      *
     C     R#DATA        IFNE      *BLANK
     C     ##RDEC        ANDNE     *BLANK
      *
      * Reformat Amount
     C                   Z-ADD     1             #2
     C     *BLANK        LOOKUP    ##NUMA(#2)                             99    *
     C                   Z-ADD     20            #3
     C                   Z-ADD     0             ##WNUM
     C     #2            DOWGT     1
     C     #2            ANDLE     20
     C     #3            ANDGT     1
     C                   SUB       1             #2
     C                   MOVEL     ##NUMA(#2)    ##W(#3)
     C                   SUB       1             #3
     C                   ENDDO
      *
      * Sign the amount
     C     ##SIGN        IFEQ      '-'
     C                   Z-SUB     ##WNUM        ##NUMB
     C                   ELSE
     C                   Z-ADD     ##WNUM        ##NUMB
     C                   END
      *
      * Default Edit Type
     C     ##EDTT        IFEQ      *BLANK
     C                   MOVEL     ##RDET        ##EDTT
     C                   END
      *
      * Default Decimal Places
     C     ##DCPA        IFEQ      *BLANK
     C                   MOVEL     ##RDED        ##DCPA
     C                   END
      * New RDE data
     C                   MOVEL     R#DATA        ##D(#1)
     C                   ENDIF
     C                   ENDDO
      *
      *................................................................
      *
     C     EXRFMN        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Subroutine  :  SRODTA                                         *
      * Function    :  Output Accumulated data to PF/CGUDTAPD         *
      *                                                               *
      * Called by   :  Simple group set subroutines                   *
      * Calls       :  CG9020 - Output Data to CGUDTAPD               *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     SRODTA        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRODTA'      @STK(Q)
      *
      *................................................................
      *
      ** Run CG9020 only if switchable feature CCG015 is *OFF.
      *
     C     CCG015        IFEQ      'N'
      *
      **  Output PF/CGUDTAPD Record.
     C                   CALL      'CG9020'
     C                   PARM      *BLANK        ##RTCD
     C                   PARM      '*WRITE  '    W0ACT
     C                   PARM                    W0PATH          256
     C                   PARM                    W0FMT
     C                   PARM      *BLANK        W0TITL            7
     C                   PARM      *BLANK        W0ULIN            7
     C                   PARM                    W0CMT
      *
      **  Database error
     C     ##RTCD        IFNE      *BLANK
      *
     C                   MOVEL     'CG9020  '    W0FILE                         ********
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERR
     C                   Z-ADD     17            W0ERNB                         ********
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
      *................................................................
      *
     C     EXODTA        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRDCDT                                         *
      * Function    :  Determine Currency Details                     *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *****************************************************************
     C     SRDCDT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRDCDT'      @STK(Q)
      *
      *................................................................
      *
      **  Access array of Currency Details already loaded
     C                   Z-ADD     1             C                 3 0
     C     ##CCY         LOOKUP    ##CY(C)                                99
      *
      **  If no match is found determine the next free space in the
      **  loaded currency array.
     C     *IN99         IFEQ      *OFF
     C                   Z-ADD     1             C
     C     *BLANK        LOOKUP    ##CY(C)                                99
      *
      **  If no space is left, set the Currency Data data structure to
      **  the 101st occurrence so that when the new details are
      **  retrieved no existing details are overwritten.
     C     *IN99         IFEQ      *OFF
     C     101           OCCUR     SDCURR
      *
      **  If a space is found, set up the new currency into the array
      **  and position the Currency Data data structure on the
      **  occurrence matching the array index.
     C                   ELSE
     C                   MOVE      ##CCY         ##CY(C)
     C     C             OCCUR     SDCURR
     C                   ENDIF
      *
      **  Retrieve the currency details.
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       ##RTCD                         B:Return
     C                   PARM      '*KEY'        ##OPTN                         I:Option
     C                   PARM      ##CCY         ##CCYP            3            I:Curren
     C     SDCURR        PARM      *BLANK        DSSDY                          O:Format
      *
      **  Database Error
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    W0FILE
     C                   MOVEL     ##CCY         W0KEY                          ********
     C                   Z-ADD     18            W0ERNB                         * DB ERR
     C                   MOVEL     'MEM5004'     W0MSGD                         ********
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      **  If the currency has been retrieved earlier, position the
      **  Currency Data data structure on the relevant occurrence.
     C                   ELSE
     C     C             OCCUR     SDCURR
     C                   ENDIF
     C*
     C     EXDCDT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  D@EURO                                         *
      * Function    :  EURO Currency Conversion:                      *
      * Converts amount P@FRAM in ccy CCY to amount ##OUTA in ccy STCY*
      * Called by   :  D@DAPC                                         *
      *                D@FRAS                                         *
      *                D@LADS                                         *
      *                D@IRXO                                         *
      *                D@IRXT                                         *
      *                D@CFCS                                         *
      *                D@LAD                                          *
      *                D@FRX                                          *
      *                                                               *
      * Calls       :  EU0200                                         *
      *                SRERR                                          *
      *****************************************************************
     C     D@EURO        BEGSR
      *
     C                   Z-ADD     0             ##OUTA           13 0
     C                   CALL      'EU0200'
     C                   PARM      *BLANKS       P@RTCD            7            Return C
     C                   PARM                    P@FRAM           18 3          FROM Ccy
     C                   PARM                    P@FRCY            3            FROM Cur
     C                   PARM                    P@TOCY            3            TO Curre
     C                   PARM                    P@OUTA           15 0          Outright
     C                   PARM                    P@INTA           18 3          Interim
     C                   PARM                    P@EXRT           15 9          Exchange
     C                   PARM                    P@MDIN            1            Mult/Div
      *
      ** Database error handling:
      *
     C     P@RTCD        IFEQ      '*ERROR*'
     C                   MOVEL     'EU0200  '    W0FILE
     C                   MOVEL     '*CALL   '    W0KEY                          ********
     C                   Z-ADD     31            W0ERNB                         * DB ERR
     C                   MOVEL     'MEM5003'     W0MSGD                         ********
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
      *
      ** Otherwise, store amount in settlement currency as ##OUTA
      *
     C                   ELSE
     C                   MOVE      P@OUTA        ##OUTA
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRINIT                                         *
      * Function    :  Initial processing                             *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :                                                 *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *................................................................
      *
      ** CALL ACCESS PROGRAM FOR BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      '*FIRST  '    ##OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C     ##RTCD        IFNE      *BLANK
      *
      ** DATABASE ERROR
      *
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ********
     C                   Z-ADD     19            W0ERNB                         * DB ERR
     C                   MOVEL     'MEM5003'     W0MSGD                         ********
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C     BJDFIN        COMP      'M'                                    98    MMDDYY,
     C*
     C**   DETERMINE NUMBER OF DECIMAL PLACES - BASE CURRENCY
     C*
     C                   MOVEL     BJCYCD        ##CCY
     C                   EXSR      SRDCDT
     C                   Z-ADD     A6NBDP        BASCDP            1 0
      *
      ** CALL ACCESS PROGRAM FOR GENERAL LEDGER DETAILS
      *
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
     C*
     C     ##RTCD        IFNE      *BLANK
      *
      ** DATABASE ERROR
      *
     C                   MOVEL     'AOGELRR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ********
     C                   Z-ADD     20            W0ERNB                         * DB ERR
     C                   MOVEL     'MEM5003'     W0MSGD                         ********
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      ** CALL ACCESS PROGRAM FOR MIDAS MODULES DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C*
     C     ##RTCD        IFNE      *BLANK
      *
      ** DATABASE ERROR
      *
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ********
     C                   Z-ADD     21            W0ERNB                         * DB ERR
     C                   MOVEL     'MEM5003'     W0MSGD                         ********
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C** CALL ACCESS PROGRAM FOR DEALING DATA DETAILS
     C*
     C                   CALL      'AODEALR1'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDDEAL        PARM      SDDEAL        DSSDY
     C*
     C     ##RTCD        IFNE      *BLANK
      *
      ** DATABASE ERROR
      *
     C                   MOVEL     'AODEALR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ********
     C                   Z-ADD     22            W0ERNB                         * DB ERR
     C                   MOVEL     'MEM5003'     W0MSGD                         ********
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C** CALL ACCESS PROGRAM FOR TRADING DATA DETAILS
     C*
     C                   CALL      'AOTRADR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
     C*
     C     ##RTCD        IFNE      *BLANK
      *
      ** DATABASE ERROR
      *
     C                   MOVEL     'AOTRADR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ********
     C                   Z-ADD     23            W0ERNB                         * DB ERR
     C                   MOVEL     'MEM5003'     W0MSGD                         ********
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C** CALL ACCESS PROGRAM FOR RETAIL DETAILS
     C*
     C     BGRTBN        IFEQ      'Y'
     C     BGIOAC        OREQ      'Y'
     C                   CALL      'AORETLR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
     C*
     C     ##RTCD        IFNE      *BLANK
      *
      ** DATABASE ERROR
      *
     C                   MOVEL     'AORETLR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ********
     C                   Z-ADD     24            W0ERNB                         * DB ERR
     C                   MOVEL     'MEM5003'     W0MSGD                         ********
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   END
     C*
     C** CALL ACCESS PROGRAM FOR MESSAGE DETAILS
     C*
     C     BGSWDL        IFEQ      'Y'
     C                   CALL      'AOMGMER0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN
     C     SDMGME        PARM      SDMGME        DSFDY
     C*
     C     ##RTCD        IFNE      *BLANK
      *
      ** DATABASE ERROR
      *
     C                   MOVEL     'AOMGMER0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ********
     C                   Z-ADD     25            W0ERNB                         * DB ERR
     C                   MOVEL     'MEM5003'     W0MSGD                         ********
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   END
      *
      ** Check if CDL013 is installed
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CDL013'      @SARD             6
     C                   PARM                    DSFDY
      *
      ** If CDL013 NOT installed, set CAR indicator to '0'
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      '0'           CDL013            1
      *
      ** If CDL013 installed
     C                   ELSE
      *
      ** Set CAR indicator to '1', set Tax Indicator ON and
      ** declare work field to access WHT ICD extension file.
     C                   MOVE      '1'           CDL013
     C                   MOVE      *ON           *IN86
     C                   MOVEL(P)  'RETAIL'      WTYPE            10
      *
      ** Open & access WHT ICD extension file to retrieve WHT rate
     C                   OPEN      SDSTAAL1
     C     WTYPE         CHAIN     SDSTAAL1                           60
      *
      ** If CHAIN failed
     C     *IN60         IFEQ      '1'
     C                   MOVEL     'SDSTAAL1'    W0FILE                         ********
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERR
     C                   Z-ADD     41            W0ERNB                         ********
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDIF
     C*
     C** ACCESS SAR DETAILS FILE TO DETERMINE IF BRT SAR IS INSTALLED
     C*
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'S01383'      ##SARD            6
      *
      ** DATABASE ERROR
      *
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE                         ********
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERR
     C                   Z-ADD     26            W0ERNB                         ********
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   END
     C*
     C** IF BRT SAR INSTALLED, ACCESS BRT INSTALLATION CONTROL DATA
     C*
     C     S01383        IFEQ      'Y'
     C                   MOVE      'D'           KRECI             1
     C     KRECI         CHAIN     SDBRTDD0                           99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'SDBRTDPD'    W0FILE                         ********
     C                   MOVEL     'D    '       W0KEY                          * DB ERR
     C                   Z-ADD     27            W0ERNB                         ********
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   END
      *
      ** Access SAR details file to determine if CIR001 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CIR001'      ##SARD
      *
      ** DATABASE ERROR
      *
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE                         ********
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERR
     C                   Z-ADD     28            W0ERNB                         ********
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CIR001            1
     C                   ELSE
     C                   MOVEL     'N'           CIR001
     C                   END
      *
      ** Access SAR details file to determine if CSW005 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CSW005'      ##SARD
      *
      ** DATABASE ERROR
      *
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE                         ********
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERR
     C                   Z-ADD     29            W0ERNB                         ********
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C*
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CSW005            1
     C                   ELSE
     C                   MOVEL     'N'           CSW005
     C                   END
      *
      ** Access SAR details file to determine if CSW011 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CSW011'      ##SARD
      *
      ** DATABASE ERROR
      *
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE                         ********
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERR
     C                   Z-ADD     30            W0ERNB                         ********
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C*
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CSW011            1
     C                   ELSE
     C                   MOVEL     'N'           CSW011
     C                   END
      *
      ** Access SAR details file to determine if CEU014 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CEU014'      ##SARD
      *
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU014            1
     C                   ELSE
     C                   MOVEL     'N'           CEU014
     C                   END
     C*
     C** Access Switchable Features file to determine if CEU015 is on.
     C*
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CEU015'      ##SARD
      *
      ** Database error:
      *
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE                         ********
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERR
     C                   Z-ADD     33            W0ERNB                         ********
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C*
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU015            1
     C                   ENDIF
     C*
     C*
     C**  Check if CEU003 is installed
     C*
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CEU003'      @SARD             6
     C*
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU003            1
     C                   ELSE
     C                   MOVE      'N'           CEU003
     C                   ENDIF
      *
      ** Access Switchable Features file to determine if CDL006 is on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CDL006'      ##SARD
      *
      ** Database error:
      *
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE                         ********
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERR
     C                   Z-ADD     34            W0ERNB                         ********
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CDL006            1
     C                   ELSE
     C                   MOVEL     'N'           CDL006
     C                   ENDIF
      *
      ** If CDL006 is installed and DLCCGTL0 not opened, open the file
      *
     C     CDL006        IFEQ      'Y'
     C     WOPEN         ANDNE     'Y'
     C                   OPEN      DLCCGDL0
     C                   MOVE      'Y'           WOPEN             1
     C                   ENDIF
      *
      ** Access SAR details file to determine if CCG015 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CCG015'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSSDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE                         ********
     C                   MOVEL     '*CALL'       W0KEY                          * DBERR
     C                   Z-ADD     35            W0ERNB                         ********
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   MOVEL     'N'           CCG015            1
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CCG015
     C                   ENDIF
      *
      ** Access SAR details file to determine if CDL016 (Automatic
      ** Rollover of Fixed Term Loan/Deposit) is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CDL016'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE                         ********
     C                   MOVEL     '*CALL'       W0KEY                          * DBERR
     C                   Z-ADD     36            W0ERNB                         ********
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   MOVEL     'N'           CDL016            1
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CDL016
     C                   ENDIF
      *
      ** Access SAR details file to determine if CDL018 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CDL018'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSSDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE                         ********
     C                   MOVEL     '*CALL'       W0KEY                          * DBERR
     C                   Z-ADD     37            W0ERNB                         ********
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   MOVEL     'N'           CDL018            1
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CDL018
     C                   ENDIF
      ** Access SAR details file to determine if CDL019 (Allow Base
      ** Rate Changes on Fixed Term Loan/Deposit) is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CDL019'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE                         ********
     C                   MOVEL     '*CALL'       W0KEY                          * DBERR
     C                   Z-ADD     38            W0ERNB                         ********
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   MOVEL     'N'           CDL019            1
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CDL019
     C                   ENDIF
      *
      ** Access SAR details file to determine if S01460 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'S01460'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSSDY
      *
     C                   MOVEL     'N'           S01460            1
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01460
     C                   ENDIF
      *
      ** Access SAR details file to determine if CGL031 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CGL031'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSSDY
      *
     C                   MOVEL     'N'           CGL031            1
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CGL031
     C                   ENDIF
      *
      ** Access SAR details file to determine if CGL035 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CGL035'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSSDY
      *
     C                   MOVEL     'N'           CGL035            1
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CGL035
     C                   ENDIF
      *
      ** Access SAR details file to determine if CDL013 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CDL013'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSSDY
      *
     C                   MOVEL     'N'           CDL013            1
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CDL013
     C                   ENDIF
      *
      ** Access System Values
      *
     C     CDL013        IFEQ      'Y'
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      WUSEDL        P@OP01           20
     C                   PARM                    P@VL01          200
     C                   PARM      *BLANK        P@OP02           20
     C                   PARM                    P@VL02          200
     C                   PARM      *BLANK        P@OP03           20
     C                   PARM                    P@VL03          200
     C                   PARM      *BLANK        P@OP04           20
     C                   PARM                    P@VL04          200
     C                   PARM      *BLANK        P@OP05           20
     C                   PARM                    P@VL05          200
     C                   PARM      *BLANK        P@OP06           20
     C                   PARM                    P@VL06          200
     C                   PARM      *BLANK        P@OP07           20
     C                   PARM                    P@VL07          200
     C                   PARM      *BLANK        P@OP08           20
     C                   PARM                    P@VL08          200
     C                   PARM      *BLANK        P@OP09           20
     C                   PARM                    P@VL09          200
     C                   PARM      *BLANK        P@OP10           20
     C                   PARM                    P@VL10          200
      *
     C     P@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDSVALPD'    DBFILE                         ********
     C                   MOVEL     '*CALL'       DBKEY                          * DBERRO
     C                   MOVEL     '115'         DBASE                          ********
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     P@VL01        WDLCUS            1
     C                   ENDIF
      *
      *
      ** Access SAR details file to determine if CDL033 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CDL033'      ##SARD
      *
      ** Database Error
      *
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     37            W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CDL033            1
     C                   ELSE
     C                   MOVEL     'N'           CDL033
     C                   END
      ** Key in accessing LF/DLCCGDL0
      *
     C     KDLCCG        KLIST
     C                   KFLD                    KCYCD             3
     C                   KFLD                    FCMC
      *
      * SETLL
     C     KDTSL         KLIST
     C                   KFLD                    W0DLNO            6 0
     C                   KFLD                    W0OTIN            1
     C                   KFLD                    W0RCIP            1
     C                   KFLD                    W0PRDT            5 0
      *
     C     KSCIN         KLIST
     C                   KFLD                    BJRDNB
     C                   KFLD                    KMODI             1
     C                   KFLD                    DLNO
      *
      ** Check if SWIFT 2008 is switched on
      ** - If SWIFT 2008 is switched on, check current setup for
      ** system value DLFSWIFTConf
      *
     C                   MOVEL     'N'           CSW208            1
     C                   MOVEL     'N'           DLSWCF            1
     C                   CALL      'SWIF2008'
     C                   PARM      *BLANKS       PRTCD
      *
     C     PRTCD         IFEQ      'CSW2008'
     C                   MOVEL     'Y'           CSW208
     C                   CALL      'AOSVALR0'
     C                   PARM                    P@RTCD            7
     C                   PARM      W#DLSW        P@OP01           20
     C     SVAL1         PARM                    P@VL01          200
     C                   PARM      *BLANK        P@OP02           20
     C                   PARM                    P@VL02          200
     C                   PARM      *BLANK        P@OP03           20
     C                   PARM                    P@VL03          200
     C                   PARM      *BLANK        P@OP04           20
     C                   PARM                    P@VL04          200
     C                   PARM      *BLANK        P@OP05           20
     C                   PARM                    P@VL05          200
     C                   PARM      *BLANK        P@OP06           20
     C                   PARM                    P@VL06          200
     C                   PARM      *BLANK        P@OP07           20
     C                   PARM                    P@VL07          200
     C                   PARM      *BLANK        P@OP08           20
     C                   PARM                    P@VL08          200
     C                   PARM      *BLANK        P@OP09           20
     C                   PARM                    P@VL09          200
     C                   PARM      *BLANK        P@OP10           20
     C                   PARM                    P@VL10          200
      *
     C     P@RTCD        IFNE      *BLANKS
     C     P@RTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SDSVALPD'    W0FILE                         ********
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERR
     C                   Z-ADD     36            W0ERNB                         ********
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     P@RTCD        IFEQ      *BLANKS
     C     SVAL11        ANDEQ     'Y'
     C                   MOVEL     SVAL11        DLSWCF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check if CAS009 is switched on
      *
     C                   MOVEL     'N'           CAS009            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CAS009'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSSDY
      *
     C     P@RTCD        IFNE      *BLANKS
     C     P@RTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE                         ********
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERR
     C                   Z-ADD     37            W0ERNB                         ********
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVEL     'Y'           CAS009
     C                   ENDIF
      *
      ** Define work fields
      *
     C     *LIKE         DEFINE    DEPBIN        ##BNDC
     C     *LIKE         DEFINE    DEPBIN        S#PBIN
     C     *LIKE         DEFINE    DETBIN        S#TBIN
     C     *LIKE         DEFINE    PFREQ         W#FREQ
     C     *LIKE         DEFINE    PDAYNO        W#DAYN
     C     *LIKE         DEFINE    PMDAY         W#MDAY
     C     *LIKE         DEFINE    PCCY          W#CCY
      *
      ** Check if CDL081 is installed
      *
     C                   MOVE      'N'           CDL081            1
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CDL081'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   Z-ADD     45            W0ERNB
     C                   MOVEL     'CDL081'      W0KEY
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDL081
     C                   ENDIF
      *
      ** Access withholding tax round down system values if CDL081 is on
      *
     C     CDL081        IFEQ      'Y'
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      C#BASE        SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM      C#NBAS        SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM      *BLANK        SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM      *BLANK        SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM      *BLANK        SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM      *BLANK        SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM      *BLANK        SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM      *BLANK        SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM      *BLANK        SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM      *BLANK        SVALK0           20
     C                   PARM                    SVAL10          200
      *
     C     PRTCD         IFNE      *BLANKS
     C     SVAL1         IFEQ      '*NRF'
     C                   MOVEL     SVALK1        W0KEY
     C                   ENDIF
     C     SVAL2         IFEQ      '*NRF'
     C                   MOVEL     SVALK2        W0KEY
     C                   ENDIF
     C                   Z-ADD     46            W0ERNB
     C                   MOVE      'SDSVALPD'    W0FILE
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Setup tax amount rounding down indicators
      *
     C                   MOVEL     SVAL1         W#BSRD            1
     C                   MOVEL     SVAL2         W#NBRD            1
     C                   ENDIF
     C*
      *
     C                   MOVE      'N'           CER038            1
      *
      ** Test if CER038 is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CER038'      @SARD             6
     C                   PARM                    DSFDY
      *
      ** If CER038 is installed
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER038            1
     C                   ELSE
     C                   MOVE      'N'           CER038
     C                   ENDIF
      *
     C                   MOVE      'N'           CER043            1
      *
      ** Test if CER043 is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CER043'      @SARD             6
     C                   PARM                    DSFDY
      *
      ** If CER043 is installed
      *
     C     @RTCD         IFEQ      *BLANKS
      *
     C                   MOVE      'Y'           CER043            1
      *
     C                   ELSE
     C                   MOVE      'N'           CER043
      *
     C                   ENDIF
      *
      ** Test if CER048 is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CER048'      @SARD             6
     C                   PARM                    DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     'CER048'      W0KEY
     C                   Z-ADD     38            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** If CER048 is installed
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER048            1
      *
     C                   ELSE
     C                   MOVE      'N'           CER048
     C                   ENDIF
      *
      ** Test if CER054 is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CER054'      @SARD             6
     C                   PARM                    DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     'CER054'      W0KEY
     C                   Z-ADD     39            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER054            1
      *
     C                   ELSE
     C                   MOVE      'N'           CER054
     C                   ENDIF
      *
      ** Test if CER049 is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CER049'      @SARD
     C                   PARM                    DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     'CER049'      W0KEY
     C                   Z-ADD     42            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER049            1
      *
     C                   ELSE
     C                   MOVE      'N'           CER049
     C                   ENDIF
      *
      ** Check if CRE073 is ON
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRE073'      @SARD
     C                   PARM                    DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     'CER073'      W0KEY
     C                   Z-ADD     50            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CRE073            1
     C                   ELSE
     C                   MOVE      'N'           CRE073
     C                   ENDIF
      *
      ** Check if CER069 is ON
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CER069'      @SARD
     C                   PARM                    DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     'CER069'      W0KEY
     C                   Z-ADD     51            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER069            1
     C                   ELSE
     C                   MOVE      'N'           CER069
     C                   ENDIF
      *
      ** Key List For SDCSINLE
      *
      *
      ** Check if CDL094 is ON
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL094'      @SARD
     C                   PARM                    DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF    '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     'CDL094'      W0KEY
     C                   Z-ADD     51            W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDL094            1
     C                   ELSE
     C                   MOVE      'N'           CDL094
     C                   ENDIF
      *
      ** Check if CDL096 - Business Day Conventions for MM Deals - is switched on
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL096'      @SARD
     C                   PARM                    DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDL096            1
     C                   ELSE
     C                   MOVE      'N'           CDL096
     C                   ENDIF
      *
      ** If CER038 is switched on, check if Suppress Correspondence for
      ** Customer with Swift ID is 'Y/N'
      *
     C     CER038        IFEQ      'Y'
     C                   MOVEL     *BLANKS       SUPCON            1
     C                   CALL      'AOSVALR0'
     C                   PARM                    P@RTCD
     C                   PARM      #SUPRS        P@OP01
     C     SVAL1         PARM                    P@VL01
     C                   PARM      *BLANK        P@OP02
     C                   PARM                    P@VL02
     C                   PARM      *BLANK        P@OP03
     C                   PARM                    P@VL03
     C                   PARM      *BLANK        P@OP04
     C                   PARM                    P@VL04
     C                   PARM      *BLANK        P@OP05
     C                   PARM                    P@VL05
     C                   PARM      *BLANK        P@OP06
     C                   PARM                    P@VL06
     C                   PARM      *BLANK        P@OP07
     C                   PARM                    P@VL07
     C                   PARM      *BLANK        P@OP08
     C                   PARM                    P@VL08
     C                   PARM      *BLANK        P@OP09
     C                   PARM                    P@VL09
     C                   PARM      *BLANK        P@OP10
     C                   PARM                    P@VL10
      *
     C     P@RTCD        IFNE      *BLANKS
     C     P@RTCD        ANDNE     '*NRF   '
     C                   MOVEL     'SDSVALPD'    W0FILE                         ********
     C                   MOVEL     '*CALL'       W0KEY                          * DBERRO
     C                   Z-ADD     50            W0ERNB                         ********
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVEL     SVAL11        SUPCON
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access SAR details file to determine if CER050 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CER050'      ##SARD
      *
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CER050            1
     C                   ELSE
     C                   MOVEL     'N'           CER050
     C                   ENDIF
      *
      ** Access SAR details file to determine if CGL165 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     ##RTCD
     C                   PARM      '*VERIFY'     ##OPTN
     C                   PARM      'CGL165'      ##SARD
      *
     C     ##RTCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           CGL165            1
     C                   ELSE
     C                   MOVEL     'N'           CGL165
     C                   ENDIF
      *
      ** Retrieve system value setting
      *
     C                   MOVEL     WPARML        P@OP01
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       W0RTCD            7
     C                   PARM                    P@OP01           20
     C                   PARM                    P@VL01          200
     C                   PARM                    P@OP02           20
     C                   PARM                    P@VL02          200
     C                   PARM                    P@OP03           20
     C                   PARM                    P@VL03          200
     C                   PARM                    P@OP04           20
     C                   PARM                    P@VL04          200
     C                   PARM                    P@OP05           20
     C                   PARM                    P@VL05          200
     C                   PARM                    P@OP06           20
     C                   PARM                    P@VL06          200
     C                   PARM                    P@OP07           20
     C                   PARM                    P@VL07          200
     C                   PARM                    P@OP08           20
     C                   PARM                    P@VL08          200
     C                   PARM                    P@OP09           20
     C                   PARM                    P@VL09          200
     C                   PARM                    P@OP10           20
     C                   PARM                    P@VL10          200
      *
      ** If system value is not found then default value to 'N'
      *
     C     W0RTCD        IFNE      '       '
     C                   MOVE      'N'           WCALC6
     C                   ELSE
     C                   MOVEL     P@VL01        WCALC6
     C                   ENDIF
      *
      *................................................................
      *
     C     EXINIT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRINZ                                          *
      * Function    :  Initialise Fields on Program Invocation        *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRINZ         BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRINZ '      @STK(Q)
      *
      *................................................................
      *
      **  Initialise work fields
     C                   Z-ADD     *ZEROS        ##W050            5 0
     C                   Z-ADD     *ZEROS        ##W150           15 0
     C                   Z-ADD     *ZEROS        #1                6 0
     C                   Z-ADD     *ZEROS        #2                6 0
     C                   Z-ADD     *ZEROS        #3                6 0
     C                   MOVE      *BLANKS       S#PATH          256
     C     *LIKE         DEFINE    DEOSEQ        ##OSEQ
      *
      **  Initialise output sequence (to CGUDTAPD)
     C                   Z-ADD     *ZEROS        ##OSEQ
      *
      ** Initialise XML increment
      *
     C                   EXSR      INIXML
      *
      *................................................................
      *
     C     EXINZ         TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  INCUST                                         *
      * Function    :  Retrieve 'In' currency details of customer     *
      *                                                               *
      * Called by   :  D@CFCS, D@DAPC, D@FRAS, D@FRX, D@IRXO,         *
      *                D@IRXT, D@LAD, D@LADS, BYOUT, UPFEE            *
      * Calls       :  AOCUSTR0                                       *
      *****************************************************************
     C     INCUST        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'INCUST'      @STK(Q)
      *
      *................................................................
      *
      ** Get Customer Details
      *
     C                   MOVEL     CNUM          ##KEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM                    ##KEY1
     C                   PARM      *BLANKS       ##KYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** DATABASE ERROR
      *
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCUSTPD'    W0FILE                         ***
     C                   MOVEL     CNUM          W0KEY                          * D
     C                   Z-ADD     32            W0ERNB                         ***
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *................................................................
      *
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
      /SPACE 5
     C/COPY ZSRSRC,ZCCYXR_ILE
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRSDAT                                         *
      * Function    :  Calculate next payment date from a frequency   *
      *                                                               *
      * Called by   :  SRFEE                                          *
      * Calls       :  ZFREQB                                         *
      *****************************************************************
     C     SRSDAT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRSDAT'      @STK(Q)
      *
      *................................................................
      *
     C                   CALL      'ZFREQB'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      W#FREQ        PFREQ             1
     C                   PARM      W#DAYN        PDAYNO            5 0
     C                   PARM      W#MDAY        PMDAY             2 0
     C                   PARM      W#CCY         PCCY              3
     C                   PARM      *BLANKS       PLOC              3
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'ZFREQB  '    W0FILE
     C                   MOVEL     W#DAYN        W0KEY                          ***
     C                   Z-ADD     38            W0ERNB                         * D
     C                   MOVEL     'MEM5004'     W0MSGD                         ***
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      *................................................................
      *
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  LIBOR                                          *
      * Function    :  Repeating LIBOR details                        *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :                                                 *
      *****************************************************************
     C     LIBOR         BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'LIBOR'       @STK(Q)
      *
      *
      *................................................................
      *
      *
      *
     C                   eval      XCINPDT = 0
     C/exec SQL
     C+ declare SDHS cursor for
     C+ select
     C+   CINPSD
     C+ , CINPED
     C+ , CINPDT
     C+ , CINPDY
     C+ , COBPDT
     C+ , COBPDY
     C+ , CPBRFR
     C+ , CRTEAP
     C+ , CCALCM
     C+ , CAVCRT
     C+ , CDCMRT
     C+ , CSMPAV
     C+ from SDHSDRTD
     C+ where
     C+     CMODID = 'DL'
     C+ and CTRNID = :XDLNO
     C+ and CINPSD = :XCINPSD
     C+ order by
     C+     CINPDT asc
     C/end-exec

     C/exec SQL
     C+ open SDHS
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from SDHS
     C+ into :DlyDS
     C/end-exec

     C                   DOW       SQLCOD <> 100
     C                   eval      XCINPDT = Dintd

      *
      *
      **  Set up Path.
      **  Retrieve subroutine specific data.
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
      *
      **  Set up Path.
     C                   MOVEL     '\LIBOR '     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS
      *
     C                   MOVEL     '\LIBREV'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   Z-ADD     0             R1                3 0

      **  Interest Period Start Date

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE            10
     C                   MOVEL     'INT PRD '    #@RDE
     C                   MOVE      'ST'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     DintStart     ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Interest Period End Date

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT PRD '    #@RDE
     C                   MOVE      'ED'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     DintEnd       ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Interest Period Date

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT PRD '    #@RDE
     C                   MOVE      'DT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Dintd         ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Interest Period Days

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'INT PRD '    #@RDE
     C                   MOVE      'DS'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Dindy         ##DATA
     C                   MOVEL     'Number'      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Observation Period Date

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'OBS PRD '    #@RDE
     C                   MOVE      'DT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Dobdt         ##DATA
     C                   MOVEL     'Date  '      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Observation Period Days

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'OBS PRD '    #@RDE
     C                   MOVE      'DS'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Dobdy         ##DATA
     C                   MOVEL     'Number'      ##RDEC
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Published Risk Free Rate

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'RSK FREE'    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Dbrfr         ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '9'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Rate Applied

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'RATE APP'    #@RDE
     C                   MOVE      'LD'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Drtap         ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '9'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Calculation Method
     C*
     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'CALC MET'    #@RDE
     C                   MOVE      'HD'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Dcalm         R#DATA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Average Compounded Rate

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'AVG CMP '    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Davcr         ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '9'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Daily Compounded Rate

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'DLY CMP '    #@RDE
     C                   MOVE      'RT'          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Dcmrt         ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '9'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)

      **  Simple Average

     C                   ADD       1             R1
     C                   CLEAR                   R#DATA
     C                   CLEAR                   R#DEFN
     C                   CLEAR                   #@RDE
     C                   MOVEL     'SMPL AVR'    #@RDE
     C                   MOVE      'G '          #@RDE
     C     ##RDE         CAT       #@RDE:1       ##RDE
     C                   MOVEL     Dsmav         ##DATA
     C                   MOVEL     'Rate  '      ##RDEC
     C                   MOVEL     'L'           ##RDET
     C                   MOVEL     '9'           ##DCPA
     C                   MOVEL     R#DATA        ##D(R1)
     C                   MOVEL     R#DEFN        ##R(R1)
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
     C                   EXSR      POPGRS
      *
     C/exec SQL
     C+ fetch next
     C+ from SDHS
     C+ into :DlyDS
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close SDHS
     C/end-exec
      *
      *
     C                   Z-ADD     1             ##TBIN
      *
      *................................................................
      *
     C     EXTSTM        TAG
      *
      **  Unwind subroutine stack name
      *
     C**********           EXSR POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
     C/COPY CGCPYSRC,SRERRPSSRL
     C/SPACE 5
     C/COPY CGCPYSRC,SRERRCLE
     C/SPACE 5                                                            CDL006
     C/COPY ZSRSRC,GLINTCZ1LE
     C/SPACE 5                                                            CDL006
     C/COPY ZSRSRC,ZINTDYZ2LE
     C/SPACE 5                                                            CDL006
     C/COPY ZSRSRC,ZCONVNZ1LE
     C/SPACE 5                                                            CDL006
     C/COPY ZSRSRC,ZDATE9Z3LE
     C/SPACE 5                                                            CDL006
     C/COPY ZSRSRC,ZDAT10Z2LE
     C/SPACE 5                                                            CCG015
     C/COPY CGCPYSRC,CGNWEXCILE
     C/EJECT
     O/SPACE 5
      *
      ** Changed 'DATE' and 'AMOUNT' format to 'Date' and 'Amount' respectively
      ** Also adjusted the placing of format codes to their correct position
      ** Changed RDE from ACCOUNTG to ACCOUNT
      *
** ##GRP/##RDEA
BRANCH0001 BRANCH
BRANCH0002 BRANCH NAM
BROKER0001 BROKER
BROKER0002 BROKER NAM
BROKER0003 BROKER TWN
CUST  0001 CUSTOMER
CUST  0002 CUST_NAME
CUST  0003 CUST_ADR1
CUST  0004 CUST_ADR2
CUST  0005 CUST_ADR3
CUST  0006 CUST_ADR4
CUST  0007 CUST_TOWN
D_BASE0001 DEALNUMBER
D_BASE0002 DEAL DATE  Date
D_BASE0003 VALUE DATE Date
D_BASM0001 DEALNUMBER
D_BASM0002 DEAL DATE  Date
D_BASM0003 EVENT_DATE Date
D_BYSL0001 BUYER NAM
D_BYSL0002 SELLER NAM
D_CFC 0001 CURRENCY
D_CFC 0002 PRINCIPAL  AmountL
D_CFC 0003 FLOOR RAT  Rate  L7
D_CFC 0004 CEILG RAT  Rate  L7
D_CFC 0005 BASERATTYP
D_CFC 0006 BASERATNAM
D_CFC 0007 SPREAD     Rate  L7
D_CFC 0008 AV RATE
D_CFC 0009 BUY/SELL
D_CFC 0010 CCY_DESC
D_CFC 0011 PREC_METIN
D_CFC 0012 CCY_DESC_
D_CFCS0001 NXT IPDATE Date
D_CFCS0002 LST IPDATE Date
D_CFCS0003 GRS INTRST AmountL
D_CFCS0004 NET INTRST AmountL
D_CFCS0005 TAX        AmountL
D_CFCS0006 TAXI
D_CFCS0007 PAY BYUS
D_CFCS0008 PAY BYTHEM
D_CFCS0009 CCY_DESC
D_CFCS0010 PREC_METIN
D_CFCS0011 NI_SC      AmountL
D_CFCS0012 NI_EQCY    AmountL
D_CFCS0013 EQUIV_CCY
D_CFCS0014 EQUIV_CCYD
D_DAPC0001 CURRENCY
D_DAPC0002 PRINC STRT AmountL
D_DAPC0003 AMNT IN/DE AmountL
D_DAPC0004 PRINCIPAL  AmountL
D_DAPC0005 CCY_DESC
D_DAPC0006 PREC_METIN
D_DAPC0007 CONFNARR
D_DAPC0008 AMT_SC     AmountL
D_DAPC0009 AMT_EQCY   AmountL
D_DAPC0010 EQUIV_CCY
D_DAPC0011 EQUIV_CCYD
D_DARC0001 CURRENCY
D_DARC0002 INT RATE   Rate  L7
D_DARC0003 CCY_DESC
D_DARC0004 PREC_METIN
D_DARC0005 CONFNARR
D_DARC0006 PRINCIPAL  AmountL
D_DARC0007 CONTSPR    Rate  L7
D_DARC0008 RNDMTD
D_DARC0009 RNDFRCD
D_DARC0010 CRE073F
D_DARC0011 BASE RATE
D_DARC0012 SPREADRATE Rate  L7
D_DARC0013 CALCBASIS
D_FLUF0001 FIRSTLAST
D_FLUF0002 UPFRONT
D_FRA 0001 CURRENCY
D_FRA 0002 PRINCIPAL  AmountL
D_FRA 0003 CONTPERIOD AmountL
D_FRA 0004 RATEFIXDTE Date
D_FRA 0005 BASERATTYP
D_FRA 0006 BASERATNAM
D_FRA 0007 CONTRATE   Rate  L7
D_FRA 0008 INT CALBAS
D_FRA 0009 BUY/SELL
D_FRA 0010 CCY_DESC
D_FRA 0011 PREC_METIN
D_FRAS0001 SETTL RATE Rate  L7
D_FRAS0002 SETTL AMNT AmountL
D_FRAS0003 PAY BYUS
D_FRAS0004 PAY BYTHEM
D_FRAS0005 SAMT_SC    AmountL
D_FRAS0006 SAMT_EQCY  AmountL
D_FRAS0007 EQUIV_CCY
D_FRAS0008 EQUIV_CCYD
D_FRX 0001 PURCH CCY
D_FRX 0002 PURCH AMNT AmountL
D_FRX 0003 EXCH RATE  Xrate L8
D_FRX 0004 SALE CCY
D_FRX 0005 SALE AMNT  AmountL
D_FRX 0006 SALE CCYDS
D_FRX 0007 PREC_METIN
D_FRX 0008 PURCH CCYD
D_FRX 0009 PAMT_SC    AmountL
D_FRX 0010 SLAMT_SC   AmountL
D_FRX 0011 PAMT_EQCY  AmountL
D_FRX 0012 P_EQV_CCY
D_FRX 0013 P_EQV_CCYD
D_FRX 0014 SLAMT_EQCY AmountL
D_FRX 0015 S_EQV_CCY
D_FRX 0016 S_EQV_CCYD
D_IRXO0001 OUR NIDATE Date
D_IRXO0002 OUR LIDATE Date
D_IRXO0003 OUR CCY
D_IRXO0004 OUR PRIN   AmountL
D_IRXO0005 OUR GRSINT AmountL
D_IRXO0006 OUR NETINT AmountL
D_IRXO0007 OUR TAX    AmountL
D_IRXO0008 OUR NETPAY AmountL
D_IRXO0009 OUR CCYDSC
D_IRXO0010 PREC_METIN
D_IRXO0011 ONP_SC     AmountL
D_IRXO0012 ONP_EQCY   AmountL
D_IRXO0013 EQUIV_CCY
D_IRXO0014 EQUIV_CCYD
D_IRXT0001 THR NIDATE Date
D_IRXT0002 THR LIDATE Date
D_IRXT0003 THR CCY
D_IRXT0004 THR PRIN   AmountL
D_IRXT0005 THR GRSINT AmountL
D_IRXT0006 THR NETPAY AmountL
D_IRXT0007 THR CCYDSC
D_IRXT0008 PREC_METIN
D_IRXT0009 TNP_SC     AmountL
D_IRXT0010 TNP_EQCY   AmountL
D_IRXT0011 EQUIV_CCY
D_IRXT0012 EQUIV_CCYD
D_LAD 0001 CURRENCY
D_LAD 0002 PRINCIPAL  AmountL
D_LAD 0003 INT RATE   Rate  L7
D_LAD 0004 GRS INTRST AmountL
D_LAD 0005 NET INTRST AmountL
D_LAD 0006 TAX        AmountL
D_LAD 0007 TAXI
D_LAD 0008 NET TOTAL  AmountL
D_LAD 0009 TOTINTOVR
D_LAD 0010 LOAN/DEPOS
D_LAD 0011 CCY_DESC
D_LAD 0012 PREC_METIN
D_LAD 0013 INTPAY_SEP
D_LAD 0014 LST IPDATE Date
D_LAD 0015 CONFNARR
D_LAD 0016 C.D. REF
D_LAD 0017 N_TOT_SC   AmountL
D_LAD 0018 N_TOT_EQCY AmountL
D_LAD 0019 EQUIV_CCY
D_LAD 0020 EQUIV_CCYD
D_LAD 0021 CCY_LOCAL
D_LAD 0022 CCY_RAT_L  Rate  L7
D_LAD 0023 TAX_LOCAL  AmountL
D_LAD 0024 RESIDENT
D_LAD 0025 CONTSPR    Rate  L7
D_LAD 0026 RNDMTD
D_LAD 0027 RNDFRCD
D_LAD 0028 CRE073F
D_LAD 0029 BASE RATE
D_LAD 0030 SPREADRATE Rate  L7
D_LAD 0031 CALCBASIS
D_APR 0001 ZI_AAPR    Rate  L2
D_LADC0001 INT CAP IN
D_LADC0002 INT CAP    AmountL
D_LADC0003 NEW PRIN   AmountL
D_LADE0001 PRNC_EQCY  AmountL
D_LADE0002 G_INT_EQCY AmountL
D_LADE0003 CUST_STAT
D_LADE0004 CGL031
D_LADS0001 NXT IPDATE Date
D_LADS0002 LST IPDATE Date
D_LADS0003 CURRENCY
D_LADS0004 PRINCIPAL  AmountL
D_LADS0005 VALUE DATE Date
D_LADS0006 GRS INTRST Amount
D_LADS0007 NET INTRST Amount
D_LADS0008 TAX        Amount
D_LADS0009 TAXI
D_LADS0010 LOAN/DEPOS
D_LADS0011 CCY_DESC
D_LADS0012 PREC_METIN
D_LADS0013 CONFNARR
D_LADS0014 NI_SC      Amount
D_LADS0015 NI_EQCY    AmountL
D_LADS0016 EQUIV_CCY
D_LADS0017 EQUIV_CCYD
D_LADS0018 CCY_LOCAL
D_LADS0019 CCY_RAT_L  Rate  L7
D_LADS0020 TAX_LOCAL  AmountL
D_LADS0021 RESIDENT
D_LADS0022 CUST_STAT
D_LADS0023 OUR IPFREQ
D_LADS0024 BASE RATE
D_LADS0025 SPREADRATE Rate  L7
D_LADS0026 CALCBASIS
D_LADS0027 BENCH ADJ  Rate  L7
D_LADS0028 DAYS B AVG
D_LADS0029 FLOOR      Rate  L7
D_LADS0030 LOCK OUT D
D_LADS0031 LOOK BACK
D_LADS0032 OBS PER SH
D_LADS0033 RSK FREERT
D_LADS0034 RT KNW IND
D_LADS0035 RT RDNG DC
D_LADS0036 CALC METHD
D_LADS0037 MATUR DATE Date
D_LADS0038 BASERATTYP
D_OPTD0001 OPT TODATE Date
D_OTH10001 CANC/AMEND
D_OTH10002 FEDERAL
D_OTH10003 AUTO-TRAN
D_OTH10004 DEAL TYPE
D_OTH10005 DEALSUBTYP
D_OTH10006 BLOCK_FLAG
D_OTH10007 FIX_BSRT
D_OTH20001 CANC/AMEND
D_OTH20002 FEDERAL
D_OTH20003 AUTO-TRAN
D_OTH20004 DEAL TYPE
D_OTH20005 DEALSUBTYP
D_OTH20006 DEALAMDTYP
D_PAY?0001 PAY BYUS
D_PAY?0002 PAY BYTHEM
D_PAY?0003 PAY USTHEM
D_PAYS0001 S_PAYOURA1
D_PAYS0002 S_PAYOURA2
D_PAYS0003 S_PAYOURNN
D_PAYS0004 S_PAYOURNT
D_PAYS0005 S_PAYOURXG
D_PAYS0006 S_PAYOURXR
D_PAYS0007 S_PAYTHRA1
D_PAYS0008 S_PAYTHRA2
D_PAYS0009 S_PAYTHRNN
D_PAYS0010 S_PAYTHRNT
D_PAYS0011 S_PAYZFAL1
D_PAYS0012 S_PAYZFAL2
D_PAYS0013 S_PAYZFAON
D_PAYS0014 S_PAYZFAOT
D_PAYS0015 S_SPEC_INS
D_PAYS0016 P_SCCY
D_PAYS0017 P_SCCYD
D_RECS0001 S_RECOURA1
D_RECS0002 S_RECOURA2
D_RECS0003 S_RECOURNN
D_RECS0004 S_RECOURNT
D_RECS0005 S_RECOURXG
D_RECS0006 S_RECOURXR
D_RECS0007 S_RECTHRA1
D_RECS0008 S_RECTHRA2
D_RECS0009 S_RECTHRNN
D_RECS0010 S_RECTHRNT
D_RECS0011 R_SCCY
D_RECS0012 R_SCCYD
D_ROLL0001 ROLLBYDLNO
D_ROLL0002 ROLLCAPCHG AmountL
D_ROLL0003 ROLLCAPIND
D_ROLL0004 ROLLBYEQAM AmountL
D_ROLL0005 ROLLBYEQCY
D_RRDT0001 NXT RCDATE Date
D_RRDT0002 FOL RCDATE Date
D_RRDT0003 CURRENCY
D_RRDT0004 BASERATTYP
D_RRDT0005 BASERATNAM
D_RRDT0006 INT RATE   Rate  L7
D_RRDT0007 OURS/THEIR
D_RRDT0008 CCY_DESC
D_RRDT0009 PREC_METIN
MATURD0001 MATUR DATE Date
NOTICD0001 NOTICEDAYS
D_IRSO0001 OUR CCY
D_IRSO0002 OUR PRIN   AmountL
D_IRSO0003 OUR BASTYP
D_IRSO0004 OUR BASNAM
D_IRSO0005 OUR FIXRAT Rate  L7
D_IRSO0006 OUR SPREAD Rate  L7
D_IRSO0007 OUR_CALC_B
D_IRST0001 THR CCY
D_IRST0002 THR PRIN   AmountL
D_IRST0003 THR BASTYP
D_IRST0004 THR BASNAM
D_IRST0005 THR FIXRAT Rate  L7
D_IRST0006 THR SPREAD Rate  L7
D_IRST0007 THR_CALC_B
D_ONTN0001 OUR NAME
D_ONTN0002 THR NAME
D_EIRO0001 OUR EFFRAT Rate  L7
D_EIRO0002 OUR STR EF
D_EIRT0001 THR EFFRAT Rate  L7
D_EIRT0002 THR STR EF
D_IPYO0001 OUR NIDATE Date
D_IPYO0002 OUR IPFREQ
D_IPYO0003 OUR IPDAY
D_IPYO0004 OUR INPM
D_IPYT0001 THR NIDATE Date
D_IPYT0002 THR IPFREQ
D_IPYT0003 THR IPDAY
D_IPYT0004 THR INPM
D_RCHO0001 OUR NRDATE Date
D_RCHO0002 OUR RCFREQ
D_RCHO0003 OUR RCDAY
D_RCHT0001 THR NRDATE Date
D_RCHT0002 THR RCFREQ
D_RCHT0003 THR RCDAY
BYOUT 0001 BO_DDAT    Date
BYOUT 0002 BO_VDAT    Date
BYOUT 0003 BO_AMNT    AmountL
BYOUT 0004 BO_PYRC
BYOUT 0005 BO_AM_SCCY AmountL
BYOUT 0006 BO_AM_EQCY AmountL
BYOUT 0007 EQUIV_CCY
BYOUT 0008 EQUIV_CCYD
UPFEE 0001 UF_VDAT    Date
UPFEE 0002 UF_AMNT    AmountL
UPFEE 0003 UF_PYRC
UPFEE 0004 UF_AM_SCCY AmountL
UPFEE 0005 UF_AM_EQCY AmountL
UPFEE 0006 EQUIV_CCY
UPFEE 0007 EQUIV_CCYD
FIDUC 0001 ZFIDNE_AMV AmountL
FIDUC 0002 CHARGE_AMT AmountL
FIDUC 0003 COMMIS_AMT AmountL
FIDUC 0004 ZFIDCO_RAT Rate  L7
FIDUC 0005 NET_AMOUNT AmountL
FIDUC 0006 ZFIDFI_DEP
D_EMDT0001 EM_DATE    Date
D_EMDT0002 EM_PNLTYPR
D_EMDT0003 EM_BRTE
D_EMDT0004 EM_INPUSR
D_EMDT0005 EM_AUTUSR
D_EMDT0006 EM_PNLTYAM
d_RMDT0001 MAC_RMACI
d_RMDT0002 MAC_RUNAC
RMAC010001 MAC_RACT1
RMAC010002 MAC_RALL1
RMAC010003 MAC_RPCT1  AmountL
RMAC010004 MAC_RAMT1  AmountL
RMAC020001 MAC_RACT2
RMAC020002 MAC_RALL2
RMAC020003 MAC_RPCT2  AmountL
RMAC020004 MAC_RAMT2  AmountL
RMAC030001 MAC_RACT3
RMAC030002 MAC_RALL3
RMAC030003 MAC_RPCT3  AmountL
RMAC030004 MAC_RAMT3  AmountL
RMAC040001 MAC_RACT4
RMAC040002 MAC_RALL4
RMAC040003 MAC_RPCT4  AmountL
RMAC040004 MAC_RAMT4  AmountL
RMAC050001 MAC_RACT5
RMAC050002 MAC_RALL5
RMAC050003 MAC_RPCT5  AmountL
RMAC050004 MAC_RAMT5  AmountL
RMAC060001 MAC_RACT6
RMAC060002 MAC_RALL6
RMAC060003 MAC_RPCT6  AmountL
RMAC060004 MAC_RAMT6  AmountL
RMAC070001 MAC_RACT7
RMAC070002 MAC_RALL7
RMAC070003 MAC_RPCT7  AmountL
RMAC070004 MAC_RAMT7  AmountL
RMAC080001 MAC_RACT8
RMAC080002 MAC_RALL8
RMAC080003 MAC_RPCT8  AmountL
RMAC080004 MAC_RAMT8  AmountL
RMAC090001 MAC_RACT9
RMAC090002 MAC_RALL9
RMAC090003 MAC_RPCT9  AmountL
RMAC090004 MAC_RAMT9  AmountL
RMAC100001 MAC_RACT10
RMAC100002 MAC_RALL10
RMAC100003 MAC_RPCT10 AmountL
RMAC100004 MAC_RAMT10 AmountL
RMAC110001 MAC_RACT11
RMAC110002 MAC_RALL11
RMAC110003 MAC_RPCT11 AmountL
RMAC110004 MAC_RAMT11 AmountL
RMAC120001 MAC_RACT12
RMAC120002 MAC_RALL12
RMAC120003 MAC_RPCT12 AmountL
RMAC120004 MAC_RAMT12 AmountL
d_PMDT0001 MAC_PMACI
d_PMDT0002 MAC_PUNAC
PMAC010001 MAC_PACT1
PMAC010002 MAC_PALL1
PMAC010003 MAC_PPCT1  AmountL
PMAC010004 MAC_PAMT1  AmountL
PMAC020001 MAC_PACT2
PMAC020002 MAC_PALL2
PMAC020003 MAC_PPCT2  AmountL
PMAC020004 MAC_PAMT2  AmountL
PMAC030001 MAC_PACT3
PMAC030002 MAC_PALL3
PMAC030003 MAC_PPCT3  AmountL
PMAC030004 MAC_PAMT3  AmountL
PMAC040001 MAC_PACT4
PMAC040002 MAC_PALL4
PMAC040003 MAC_PPCT4  AmountL
PMAC040004 MAC_PAMT4  AmountL
PMAC050001 MAC_PACT5
PMAC050002 MAC_PALL5
PMAC050003 MAC_PPCT5  AmountL
PMAC050004 MAC_PAMT5  AmountL
PMAC060001 MAC_PACT6
PMAC060002 MAC_PALL6
PMAC060003 MAC_PPCT6  AmountL
PMAC060004 MAC_PAMT6  AmountL
PMAC070001 MAC_PACT7
PMAC070002 MAC_PALL7
PMAC070003 MAC_PPCT7  AmountL
PMAC070004 MAC_PAMT7  AmountL
PMAC080001 MAC_PACT8
PMAC080002 MAC_PALL8
PMAC080003 MAC_PPCT8  AmountL
PMAC080004 MAC_PAMT8  AmountL
PMAC090001 MAC_PACT9
PMAC090002 MAC_PALL9
PMAC090003 MAC_PPCT9  AmountL
PMAC090004 MAC_PAMT9  AmountL
PMAC100001 MAC_PACT10
PMAC100002 MAC_PALL10
PMAC100003 MAC_PPCT10 AmountL
PMAC100004 MAC_PAMT10 AmountL
PMAC110001 MAC_PACT11
PMAC110002 MAC_PALL11
PMAC110003 MAC_PPCT11 AmountL
PMAC110004 MAC_PAMT11 AmountL
PMAC120001 MAC_PACT12
PMAC120002 MAC_PALL12
PMAC120003 MAC_PPCT12 AmountL
PMAC120004 MAC_PAMT12 AmountL
FRCD  0001 RT CHG DAT Date
FRCD  0002 RT CHG FRQ
FRCD  0003 RT CHG DAY
FRCD  0004 SH RATE FL
FRCD  0005 SH RATE    Rate  L7
FRCD  0006 ACC INTRST AmountL
FRCD  0007 ACC COF    AmountL
FRCD  0008 SH RATE VA
FRCD  0009 FX RATE VA
FRCD  0010 RT FIX DAY
FRCD  0011 RT FIX DAT Date
FRCD  0012 RT FIX PRF
FRCD  0013 FIX BASE R Rate  L7
FRCD  0014 FWD YLD CU
FRCD  0015 CURRENCY
DL_FED0001 DL_FEESDNO
DL_FED0002 DL_FEEFCOD
DL_FED0003 DL_FEEFCCY
DL_FED0004 DL_FEEFCYD
DL_FED0005 DL_FEEFAMT AmountL
DL_FED0006 DL_FEEDTE  Date
DL_FED0007 DL_FEEECYD
DL_FED0008 DL_FEEEAMT AmountL
CGSTAX0001 SEC_TAXA   AmountL
CGSTAX0002 SEC_TAXB
CGSTAX0003 SEC_TXAC
CGSTAX0004 SEC_TAXR   Rate  L4
CGSTAX0005 CER048
CGSTAX0006 THRSH_METH
CGSTAX0007 ZZFGINTC   AmountL
CGSTAX0008 ZZFGINTD   AmountL
CGSTAX0009 ZZFTINTC   AmountL
CGSTAX0010 ZZFTINTD   AmountL
CGSTAX0011 ZZFWHTC    AmountL
CGSTAX0012 ZZFWHTB    AmountL
CGSTAX0013 ZZFSCNC    AmountL
CGSTAX0014 ZZFSCNB    AmountL
CGSTAX0015 ZZFNINTC   AmountL
CGSTAX0016 ZZFNINTD   AmountL
CGTTAX0001 ZZFCHTC    AmountL
CGTTAX0002 ZZFCHTB    AmountL
CGTTAX0003 ZZFCHRT    Rate  L5
CGTTAX0004 THD_TAXB
CGTTAX0005 THD_TXAC
CGTTAX0006 THD_STAC
CGTTAX0007 THD_RELA
LNSTAX0001 ZSTAXFLG
LNSTAX0002 ZTAXPRFLG
LNSTAX0003 ZTAXPRDTE  Date                                                           CE
LNSTAX0004 ZTAXAVFLG
LNSTAX0005 ZTAXAVDTE  Date                                                           CE
LNSTAX0006 ZTAXINFLG
LNSTAX0007 ZTAXINDTE  Date                                                           CE
LNSTAX0008 ACCOUNT                                                                   CE
LNSTAX0009 Z_TAX_AMT  AmountL                                                        CE
LNSTAX0010 ZTAXINAMT  AmountL                                                        CE
LNSTAX0011 ZTAXAVAMT  AmountL                                                        CE
RTVRCV0001 RBTB1
RTVRCV0002 RBTB2
RTVRCV0003 RBTB3
RTVRCV0004 RBTB4
RTVRCV0005 RBTB5
RTVRCV0006 RBTB6
RTVRCV0007 A7RF56
RTVRCV0008 A7RA56
RTVRCV0009 A7RF57
RTVRCV0010 A7RA57
RTVRCV0011 A7RF58
RTVRCV0012 A7RA58
**  Table of Deal Type vs related Print Item Sub Type
CDCALL_TAKE
CICD_ISSUED
CLCALL_LOAN
DLDEMAN_LOAN
IPIBANK_PLAC
ITIBANK_TAKE
TDTIME_TAKE
TITIME_PLACE
ILINFUN_LOAN
IDINFUN_DEPO
** Loan Deal Types
IPTICLLNDLILPLFLDPLP
** ##CPY  **      OBJECT COPYRIGHT
(c) Finastra International Limited 2001
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
