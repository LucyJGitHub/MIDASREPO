     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Forecast balance enquiry')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000595 - Midas OF Forecast balance enquiry                 *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD025254           Date 24Feb14               *
      *                 MD024231           Date 06Jan14               *
      *                 MD024147           Date 20Dec13               *
      *                 MD023983           Date 06Dec13               *
      *                 MD023671           Date 21Nov13               *
      *                 MD023556           Date 18Nov13               *
      *                 CGL145B  *CREATE   Date 28Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD025254 - Projected balance for forecast in Forecast        *
      *             Balance Enquiry is not correct                    *
      *  MD024231 - Forecast amount not correct for Nostro account    *
      *  MD024147 - Today's Closing Forecast Balance and Forecast     *
      *             Balance at date displays different figures  in    *
      *             the Forecast Balance Enquiry                      *
      *  MD023983 - Back value date wrongly displayed                 *
      *  MD023671 - Back value Forecast not shown on Enquiry          *
      *  MD023556 - F05 send blank screen                             *
      *  CGL145B - Subsidiaries Daily Sweeping Forecast               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas RE Shadow balances by account details
     FMEMOSL1   IF   E           K DISK    INFSR(*PSSR)

      ** Midas GL Projected Nostro Balances
     FPRONO     IF   E           K DISK    INFSR(*PSSR)

      ** Midas GL Acc movts by value date/DRCR/amount
     FRSACMTL1  IF   E           K DISK    INFSR(*PSSR)

      ** Midas GL Account Balances Today
     FGLACBTL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas SD Identification Types  Maintenance Display
     FGL000595DFCF   E             WORKSTN SFILE(GL000595S1:#1SFRN)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Copyright Statement Array
     D CPY@            S             80A   DIM(1) CTDATA

      ** Local Data Area Data Structure
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)

      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
     D  MBIN                  13     13

      ** Program Status Data Structure
     D PSDS           SDS
     D  PSProcName       *PROC
     D  PSPgmStat        *STATUS
     D  PSJobName            244    253
     D  PSUser               254    263
     D  PSProcPgm            334    343
     D  PSProcMod            344    353

      ** Indicator Array Overlay Data Structure
     D INPTR           S               *   INZ(%ADDR(*IN))
     D                 DS                  BASED(INPTR)
      ** Function Key Indicators
     D  F03                   03     03
     D  F05                   05     05
     D  F13                   13     13
     D  F14                   14     14
     D  F15                   15     15
     D  F16                   16     16

      ** Subfile Management Indicators
     D  ENQMODE               90     90
     D  SFLCLR                91     91
     D  SFLDSP                92     92
     D  SFLEND                93     93
     D  ROLLUP                94     94
     D  SFLNXTCHG             95     95
     D  SFLMSGEND             96     96

      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Midas SD Midas modules Data Structure
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** Midas GL Midas Account file Structure
     D P@FMT1        E DS                  EXTNAME(ACCNTAB)

     D FORI          E DS                  EXTNAME(GLFORITD)

     D* External DTAARA for ZMUSER
     D*
     D ZMUSER          DS            17
     D  DBRN                  11     13

      ** LDA data structure
     D DSLDA           DS
     D  LDADTA                 2     59
     D  ECNUM                  2     11
     D  ECCY                  12     14
     D  EACOD                 15     24
     D  EACSQ                 25     26
     D  ACNT                   2     26
     D  EBRCA                 27     29
     D  EACNT                  2     29
     D  EVDAT                 30     35
     D  ESIGN                 36     36
     D  EAMNT                 37     50
     D  CQNMR                 51     58
     D  SPOS                  59     65
     D  FUNC                  66     68

     D                 DS
     D  PNB                    1     40
     D  PBAL                   1     40P 0
     D                                     DIM(5)
     D  PND                   41     55
     D  PDAT                  41     55P 0
     D                                     DIM(5)

     D AccSel          DS
     D  #1CNUM                 1     10
     D  #1CCY                 11     13
     D  #1ACOD                14     23
     D  #1ACSQ                24     25
     D  #1ACC                  1     25
     D  #1BRCA                26     28
     D  #1ACCB                 1     28
     D  #1VDAT                29     34
     D  #1SIGN                35     35
     D  #1AMNT                36     49

     D AccSav          DS
     D  DDCNUM                 1     10    INZ('9999999999')
     D  DDCCY                 11     13    INZ('999')
     D  DDACOD                14     23    INZ('9999999999')
     D  DDACSQ                24     25    INZ('99')
     D  DDBRCA                26     28    INZ('999')
     D  DDVDAT                29     34    INZ('999999')
     D  DDSIGN                35     35    INZ('9')
     D  DDAMNT                36     49    INZ('99999999999999')

     D AccKey          DS
     D  KkBRCA                 1      3
     D  KkCNUM                 4      9
     D  KkCCY                 10     12
     D  KkACOD                13     22  0
     D  KkACSQ                23     24  0
     D  KkFacn                 1     24
     D  KkVDAT                25     29  0
     D  KkSIGN                30     30
     D  KkAMNT                31     45  0
     D  KkNonb                46     47
     D  KkNon                 46     47  0

      ** Data structure for AOSVALR0 string
     D @SVAL1          DS           200
     D  SVAL1                  1    200
     D  SVAL1_1                1      1

      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A

      ** Standard Utility Parameters
     D PMsgFile        S             10A   INZ('GBSDUSRMSG')
     D PMsgID          S             10A

      ** Parameters for ZDATE2
     D PDaynoIn        S              5P 0
     D PDateOut        S              6  0
     D PADateOut       S              7A

      ** Working Variables
     D PDateRun        S              6  0                                                  MD023671
     D WNARRCnt        S              4P 0
     D W1SFRN          S              4P 0

     D WErrFlg         S              1A
     D WDspFlg         S              1A
     D WBldFlg         S              1A

     D FODATE          S              5P 0                                                  MD023671
     D WWFDAT          S              5P 0
     D PRDATE          S              5P 0
     D ExtFlg          S              1
     D P@RTCD          S              7
     D P@OPTN          S              7
     D P@KEY1          S             10
     D P@KEY2          S              3
     D P@KEY3          S             10
     D P@KEY4          S              2
     D P@KEY5          S              3
     D P@TYPE          S              7
     D P@NOSN          S              2
     D ERRCOD          S              1  0
     D TypeAcc         S              1
     D WWFBal          S             15  0
     D WWProj          S             15  0
     D WWBPro          S             15  0
     D WWTotF          S             15  0
     D BalRun          S             15  0
     D ZFLD15          S             15  0
     D WDECA           S              1  0
     D WSPRA           S             13  8
     D WMDIA           S              1
     D WDECF           S              1  0
     D WSPRF           S             13  8
     D WMDIF           S              1
     D ZECODE          S              1
     D ZOUT21          S             21
     D ZOUT20          S             20
     D ZNEG            S             21
     D WINC            S              1
     D WWAMNT          S             15  0
     D WWDif           S              3  0

      ** Parameter variables for AOSVALR0 string

     D ProcMode        S            190
     D ForecastUn      S             20    INZ('ForecastIncUnmatched')

     DRTNCDE           S              7
     DSVALK2           S             20
     DSVAL2            S            200
     DSVALK3           S             20
     DSVAL3            S            200
     DSVALK4           S             20
     DSVAL4            S            200
     DSVALK5           S             20
     DSVAL5            S            200
     DSVALK6           S             20
     DSVAL6            S            200
     DSVALK7           S             20
     DSVAL7            S            200
     DSVALK8           S             20
     DSVAL8            S            200
     DSVALK9           S             20
     DSVAL9            S            200
     DSVALK0           S             20
     DSVAL10           S            200

      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

     C                   EXSR      SRMain

     C                   EVAL      *INLR = *ON

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Main processing                                     *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR

      ** Do while F3 is not pressed and ExtFlg = 'N'

     C                   DOW       F03 = *OFF and ExtFlg = 'N'

      ** Build subfile if needed

     C                   IF        WBldFlg  = 'Y'
     C                   EXSR      SRBld
     C                   EndIf

      ** Display subfile

     C                   EXSR      SRDsp

      ** If F3

     C                   IF        F03 = *ON
     C                   EVAL      EXTFLG = 'Y'
     C                   EVAL      FUNC = 'F03'
     C                   OUT       DSLDA
     C                   EndIf

      ** If not F3 and not RollUp

     C                   IF        F03 = *OFF AND
     C                             ROLLUP = *OFF

     C                   SELECT

      ** Refresh screen

     C                   WHEN      F05 = *ON
     C                   EXSR      SRRef

      ** If F13 - display Account details

     C                   WHEN      F13 = *ON
     C                   EXSR      SRAccdet

      ** If F14 - display Account movements

     C                   WHEN      F14 = *ON
     C                   EXSR      SRAccmvt

      ** If F15 - projected movements

     C                   WHEN      F15 = *ON
     C                   EXSR      SRProjM

      ** If F16 - item in clearing

     C                   WHEN      F16 = *ON
     C                   EXSR      SRItem

     C                   OTHER

     C                   IF        AccSel <> AccSav

     C/exec SQL
     C+ close C1
     C/end-exec

     C/exec SQL
     C+ close C2
     C/end-exec

      ** Validate the selection fields

     C                   EXSR      SRVal
     C                   Else
     C                   Eval      WBldFlg = 'N'

      ** Reset the subfile error indicators.

     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   End

     C                   ENDSL

     C                   ENDIF

      ** If RollUp continue to build the subfile

     C                   IF        ROLLUP = *ON
     C                   Eval      WBldFlg = 'Y'
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRef - Refresh the subfile                                  *
      *                                                               *
      *****************************************************************
     C     SRRef         BEGSR

      ***Clear*the*subfile.                                                                 MD023556

     C**********         EXSR      SRClr                                                    MD023556

      ** Initialise relevant variables.

     C**********         EVAL      WDspFlg = 'N'                                            MD023556
     C**********         EVAL      WErrFlg = 'N'                                            MD023556
     C                   EVAL      WBldFlg = 'N'
     C                   EVAL      AccSel = AccSav                                          MD023556
                                                                                            MD023556
     C                   If        DDCNUM  = '9999999999'                                   MD023556
     C                             and DDACOD  = '9999999999'                               MD023556
     C                   EVAL      AccSel = *Blanks                                         MD023556
     C                   End                                                                MD023556
                                                                                            MD023556
     C**********         EVAL      SFLDSP = *ON                                             MD023556
     C**********         EVAL      SFLEND = *OFF                                            MD023556
     C**********         EVAL      #1SFRN = *ZERO                                           MD023556
     C**********         EVAL      W1SFRN = *ZERO                                           MD023556

      ** Reset the subfile error indicators.

     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN27 = *OFF

     C**********         EVAL      AccSav = *Blanks                                         MD023556

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClr     - Clears the subfile                               *
      *                                                               *
      *****************************************************************
     C     SRClr         BEGSR

     C                   EVAL      SFLCLR = *ON
     C                   WRITE     GL000595C1
     C                   EVAL      SFLCLR = *OFF

      * Initialise some work fields

     C                   EVAL      WWFDAT = 0

      * Do not display some header fields

     C                   Eval      *IN50 = '0'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBld     - Build the subfile                                *
      *                                                               *
      *****************************************************************
     C     SRBld         BEGSR

      ** Build the subfile only if necessary.

     C                   IF        WDspFlg = 'Y' AND
     C                             ROLLUP = *OFF
     C                   LEAVESR
     C                   ENDIF

      ** Build the subfile starting from the given key
      ** if not Roll up

B1   C                   IF        WBldFlg = 'Y' and
     C                             ROLLUP = *OFF

     C                   EXSR      SRClr
     C                   EVAL      W1SFRN = *ZERO
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF

     C     TypeAcc       IfEq      'R'                                                      MD023671
                                                                                            MD023671
     C/exec SQL
     C+ open C1
     C/end-exec

     C                   Else                                                               MD023671
                                                                                            MD023671
      ** If it is a Nostro account                                                          MD023671
                                                                                            MD023671
     C/exec SQL
     C+ open C2
     C/end-exec
     C                   End                                                                MD023671

E1   C                   ENDIF

     C                   EVAL      WNARRCnt = *ZERO

      ** Select all the records

     C     TypeAcc       IfEq      'R'

     C/exec SQL
     C+ fetch next
     C+ from C1
     C+ into : FORI
     C/end-exec

     C                   Else

      ** If it is a Nosro account

     C/exec SQL
     C+ fetch next
     C+ from C2
     C+ into : FORI
     C/end-exec

     C                   ENDIF

     C                   DOW       SQLCode <> 100

      ** If the Forecast is defined with a Retail account and the Retail
      ** account ccy is different from Forecast ccy, convert Forecast amount
      ** from Forecast ccy to Retail ccy

      ** If the Forecast is defined with a Nostro account, no need to do a
      ** conversion as Forecast amount is always in the Nostro ccy

B2   C                   IF        IFCCY <> #1CCY

      * Retrieve the currency decimal places of the Forecast currency

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    IFCCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBKey = IFCCY
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      WDECF = A6NBDP
     C                   EVAL      WSPRF = A6SPRT
     C                   EVAL      WMDIF = A6MDIN

      * Retrieve the cross rate between Forecast ccy and Account ccy

     C                   CALL      'ZXRATE'
     C                   PARM      WSPRF         ZRATE1           13 8
     C                   PARM      WMDIF         ZMDI1             1
     C                   PARM      WSPRA         ZRATE2           13 8
     C                   PARM      WMDIA         ZMDI2             1
     C                   PARM                    ZRATEX           13 8
     C                   PARM                    ZMDIX             1

      * Convert the Forecast amount

     C                   MOVE      IFCCY         ZCCYI
     C                   MOVE      #1CCY         ZCCYO
     C                   MOVE      WDECF         ZCDPI
     C                   MOVE      WDECA         ZCDPO
     C                   Z-ADD     ZRATEX        ZEXCH
     C                   MOVE      ZMDIX         ZMD

     C                   Z-ADD     IFAMNT        ZAMTCI
     C                   CALL      'ZCONVZ1'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
     C                   Z-ADD     ZAMTCO        IFAMNT
E2   C                   ENDIF

      * For Retail account only                                                             MD024231
      *                                                                                     MD024231
      * If the forecast amount is positive, it means that the Retail account is credited
      * If the forecast amount is negative, it means that the Retail account is debited

      * The negative balance is a Credit balance
      * The positive balance is a Debit balance

      * The sign of the Forecast amount must be reversed to be added correctly in the balances

     C     TypeAcc       IfEq      'R'                                                      MD024231
     C                   EVAL      IFAMNT = IFAMNT * -1
     C                   End                                                                MD024231

      * If no amount selected, select all Forecasts

      * If the selected sign is equal to '-', select amount less or equal to selected amount
      * If the selected sign is equal to '+', select amount greater or equal to selected amount
      *  If the selected sign is equal to ' ', select amount equal to selected amount

B2   C                   IF        #1AMNT  = *BLANKS or
     C                             (#1AMNT  <> *BLANKS and #1SIGN = '-'
     C                             and IFAMNT <= WWAMNT) or
     C                             (#1AMNT  <> *BLANKS and #1SIGN = '+'
     C                             and IFAMNT >= WWAMNT) or
     C                             (#1AMNT  <> *BLANKS and #1SIGN = ' '
     C                             and IFAMNT = WWAMNT)
                                                                                            MD023671
      ** If Back-value forecast, process them as Forecast for the Run date                  MD023671
      ** Keep the Forecast date   to be displayed correctly                                 MD023671
                                                                                            MD023671
     C                   Eval      FODATE = IFDATE                                          MD023671
                                                                                            MD023671
B3   C                   If        IFDATE <  BJRDNB                                         MD023671
     C                   Eval      IFDATE = BJRDNB                                          MD023671
B3   C                   End                                                                MD023671

      * The following 2 lines (SRTOTW and SRPROJW) must always be written on the same subfile page

B3   C                   IF        IFDATE <> WWFDAT

B4   C                   IF        WNARRCnt <  7

B5   C                   IF        WWFDAT <> 0
      * It is necessary to write a Total line for the previous Forecast date
     C                   EXSR      SRTotW
E5   C                   ENDIF

     C                   EVAL      WWFDAT = IFDATE

      * Retrieve Projected balance for this date
     C                   EXSR      SRProj

      * Write the Projected balance line in the subfile

     C                   EXSR      SRProjW
X4   C                   Else

B5   C     TypeAcc       IfEq      'R'

     C/exec SQL
     C+ fetch prior
     C+ from C1
     C+ into : FORI
     C/end-exec

X5   C                   Else

      ** If it is a Nosro account

     C/exec SQL
     C+ fetch prior
     C+ from C2
     C+ into : FORI
     C/end-exec

E5   C                   ENDIF

      ** To write always subfile record on the next page, change the Relative record number
     C                   Eval      WWDif = 09 - WNARRCnt

     C                   LeaveSr
E4   C                   ENDIF

E3   C                   ENDIF

      ** Write a detail line for the Forecast
     C                   EXSR      SRForW

      ** Leave the selection if one subfile page has been filled

B3   C                   IF        WNARRCnt = 09

      ** Check first if there are more records available.

     C     TypeAcc       IfEq      'R'

     C/exec SQL
     C+ fetch next
     C+ from C1
     C+ into : FORI
     C/end-exec

     C                   Else

     C/exec SQL
     C+ fetch next
     C+ from C2
     C+ into : FORI
     C/end-exec

     C                   ENDIF

B4   C                   If        SQLCode = 100
     C                   LEAVE
X4   C                   ELSE

B5   C     TypeAcc       IfEq      'R'

     C/exec SQL
     C+ fetch prior
     C+ from C1
     C+ into : FORI
     C/end-exec

X5   C                   Else

     C/exec SQL
     C+ fetch prior
     C+ from C2
     C+ into : FORI
     C/end-exec

E5   C                   ENDIF
E4   C                   ENDIF

     C                   LEAVESR
E3   C                   ENDIF
E2   C                   ENDIF

      ** Initialise subfile fields
     C                   EXSR      SRSubC

     C     TypeAcc       IfEq      'R'

     C/exec SQL
     C+ fetch next
     C+ from C1
     C+ into : FORI
     C/end-exec

     C                   Else

     C/exec SQL
     C+ fetch next
     C+ from C2
     C+ into : FORI
     C/end-exec

     C                   ENDIF

E1   C                   ENDDO

      ** If it is the end of the file GLFORITD    and the field WWTOTF is not equal
      ** to zero, write a Total line

     C                   If        SQLCode = 100 and WWTOTF <>0
     C                   EXSR      SRTotW
     C                   ENDIF

      ** No details to display.

     C                   IF        W1SFRN = *ZERO
     C                   EVAL      PMsgID = 'USR4732'
     C                   EXSR      SRSndErr
     C                   EVAL      SFLDSP = *OFF
     C                   ENDIF

     C                   EVAL      ROLLUP = *OFF
     C                   EVAL      SFLEND = *ON

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSubC    - Initialise subfile fields                        *
      *                                                               *
      *****************************************************************
     C     SRSubC        BEGSR

     C                   EVAL      S1Date = *Blanks
     C                   EVAL      S1Opty = *Blanks
     C                   EVAL      S1Narr = *Blanks
     C                   EVAL      S1Amnt = *Blanks

     C                   EVAL      *IN51  = '0'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProj    - Retrieve Projected balance                       *
      *                                                               *
      *****************************************************************
     C     SRProj        BEGSR

      * The projected balance is equal to the Opening balance from GLACBTPD (field WWPROJ)
      * plus all the movements coming from RSACMTPD until the Forecast Value date
     C                   EVAL      KkVdat = PRDate

     C     KeyAc2V       SETGT     RSACMTL1

     C     KeyAc2        READE     RSACMTL1

     C                   DOW       NOT %EOF and VUDT <= IFDATE

     C                   IF        DORC = 0
     C                   Add       MVAM          WWPROJ
     C                   Else
     C                   Sub       MVAM          WWPROJ
     C                   End

     C     KeyAc2        READE     RSACMTL1
     C                   Enddo

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProjW   - Write Projected balance line                     *
      *                                                               *
      *****************************************************************
     C     SRProjW       BEGSR

      * Convert date in screen format

     C                   CALL      'ZDATE2'
     C**********         PARM      IFDATE        PDaynoIn                                   MD023671
     C**********         PARM      FODATE        PDaynoIn                          MD023671 MD023983
     C                   PARM      IFDATE        PDaynoIn                                   MD023983
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM      *BLANKS       PADateOut

     C                   MOVE      PDateOut      S1DATE

     C                   EVAL      S1OPTY = 'Projected balance'
     C                   EVAL      S1NARR = *Blanks

     C                   MOVE      *BLANKS       ZFLD15
     C********           MOVE      WWPROJ        ZFLD15
     C     IFDATE        IFEQ      BJRDNB                                                   MD024147
     C                   ADD       CLBLN         WWBPRO                                     MD024147
     C                   ELSE                                                               MD024147
     C**********         ADD       WWPROJ        WWBPRO                                     MD025254
     C     WWTOTF        ADD       WWPROJ        WWBPRO                                     MD025254
     C                   END                                                                MD024147
     C                   MOVE      WWBPRO        ZFLD15
     C                   EXSR      ZSEdit
     C                   MOVE      ZOUT21        S1AMNT

     C                   EVAL      W1SFRN = W1SFRN + 1
     C                   EVAL      #1SFRN = W1SFRN
     C                   EVAL      WNARRCnt = WNARRCnt + 1

      * Write on a new page if necessary

     C                   EVAL      W1SFRN = W1SFRN + WWDif
     C                   EVAL      #1SFRN = W1SFRN
     C                   EVAL      WWDif  = 0

     C                   WRITE     GL000595S1

      *  Add the projected balance in the Total balance field WWTOTF

     C***                Add       WWPROJ        WWTotF                                     MD024147
     C     IFDATE        IFEQ      BJRDNB                                                   MD025254
     C                   Add       WWBPRO        WWTotF                                     MD024147
     C                   ELSE                                                               MD025254
     C                   Z-ADD     WWBPRO        WWTOTF                                     MD025254
     C                   ENDIF                                                              MD025254

      *  Re-initialise field WWPROJ
     C                   Z-Add     0             WWPROJ

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRForW    - Write a Forecast line detail                     *
      *                                                               *
      *****************************************************************
     C     SRForW        BEGSR

      * Convert date in screen format

     C                   CALL      'ZDATE2'
     C**********         PARM      IFDATE        PDaynoIn                                   MD023983
     C                   PARM      FODATE        PDaynoIn                                   MD023983
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM      *BLANKS       PADateOut

     C                   MOVE      PDateOut      S1DATE

     C                   EVAL      S1OPTY = IFOPTY
     C                   EVAL      S1NARR = IFNARR

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      IFAMNT        ZFLD15
     C                   EXSR      ZSEdit
     C                   MOVE      ZOUT21        S1AMNT

     C                   EVAL      W1SFRN = W1SFRN + 1
     C                   EVAL      #1SFRN = W1SFRN
     C                   EVAL      WNARRCnt = WNARRCnt + 1

      * Write on a new page if necessary

     C                   EVAL      W1SFRN = W1SFRN + WWDif
     C                   EVAL      #1SFRN = W1SFRN
     C                   EVAL      WWDif  = 0

     C                   WRITE     GL000595S1

      *  Add the amount in the total balance field WWTOTF

     C                   Add       IFAMNT        WWTotF

      *  Keep the Forecast Value date in the field PRDATE

     C                   Eval      PRDATE = IFDATE

      *  If the Forecast Value date is equal to the Run date, add the Forecast amount
      *  in the field BalRun (used to calculate the Closing Forecast balance of the day)

     C                   IF        IFDATE = BJRDNB
     C                   Add       IFAMNT        BalRun
     C                   End

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTotW    - Write Total Forecast balance for the Value date  *
      *                                                               *
      *****************************************************************
     C     SRTotW        BEGSR

     C                   MOVE      *Blanks       S1DATE
     C                   EVAL      *IN51  = '1'

     C                   EVAL      S1OPTY = 'Forecast balance at end of'
     C**********         Movel     PDateOut      S1NARR                                     MD023671
                                                                                            MD023671
      ** When the date is Backvalue (do to BV Forecast) Display the system Run date         MD023671
                                                                                            MD023671
     C                   IF        WWFDAT <= BJRDNB                                         MD023671
     C                   Movel     PDateRun      S1NARR                                     MD023671
     C                   Else                                                               MD023671
     C                   Movel     PDateOut      S1NARR                                     MD023671
     C                   End                                                                MD023671

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WWTOTF        ZFLD15
     C                   EXSR      ZSEdit
     C                   MOVE      ZOUT21        S1AMNT

     C                   EVAL      W1SFRN = W1SFRN + 1
     C                   EVAL      #1SFRN = W1SFRN
     C                   EVAL      WNARRCnt = WNARRCnt + 1

      * Write on a new page if necessary

     C                   EVAL      W1SFRN = W1SFRN + WWDif
     C                   EVAL      #1SFRN = W1SFRN
     C                   EVAL      WWDif  = 0

     C                   WRITE     GL000595S1

      *  If it is End of the file

     C                   If        SQLCode = 100
     C                   Z-Add     0             WWTOTF
     C                   End

     C                   EVAL      *IN51  = '0'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDsp - Display the Forecast Balance subfile                 *
      *                                                               *
      *****************************************************************
     C     SRDsp         BEGSR
                                                                                            MD023671
      ** Reset Selected Value date if needed                                                MD023671
                                                                                            MD023671
     C                   IF        #1VDAT  = '010172'                                       MD023671
     C                   EVAL      #1VDAT = '      '                                        MD023671
     C                   End                                                                MD023671

      ** Set up the Total balances to display if no error

     C                   IF        WErrFlg = 'N'
     C                   Exsr      SRTotB
     C                   End

      ** No details to display.

     C                   IF        W1SFRN = *ZERO
     C                   EVAL      SFLDSP = *OFF
     C                   ENDIF

      ** Display the screen

     C                   WRITE     GL000595F1
     C                   WRITE     GL000595C2
     C                   WRITE     GL000595F2
     C                   EXFMT     GL000595C1

      ** Clear messages from the program message queue.

     C                   CALL      'ZA0250'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal - Validates the selection fields                       *
      *                                                               *
      *****************************************************************
     C     SRVal         BEGSR

      ** Initialise error indicators

     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      WErrFlg = 'N'

      ** Initialise all work fields

     C                   EVAL      WWFDAT = 0
     C                   EVAL      WWDif  = 0
     C                   EVAL      PRDATE = BJRDNB - 1
     C                   EVAL      WWBPRO = 0
     C                   EVAL      WWPROJ = 0
     C                   EVAL      WWTOTF = 0
     C                   EVAL      BalRun = 0

      ********************
      ** Validate Account
      ********************
     C                   IF        #1CNUM = *Blanks

      ** Customer number must not be blanks

     C                   EVAL      *IN20 = *ON
     C                   EVAL      WErrFlg = 'Y'
     C                   EVAL      WBldFlg = 'N'
     C                   EVAL      PMsgID = 'USR5019'
     C                   EXSR      SRSndErr
     C                   LeaveSR
     C                   ENDIF

      ** Initialise Input branch if needed

     C                   IF        #1BRCA = *Blanks and #1ACC <> *Blanks
     C                   EVAL      #1BRCA = WUserBrch
     C                   ENDIF

      ** Access the Account details

     C                   CALL      'AOACCTV0'
     C                   PARM      '       '     P@RTCD
     C                   PARM      #1CNUM        P@KEY1
     C                   PARM      #1CCY         P@KEY2
     C                   PARM      #1ACOD        P@KEY3
     C                   PARM      #1ACSQ        P@KEY4
     C                   PARM      #1BRCA        P@KEY5
     C                   PARM                    P@TYPE
     C                   PARM                    P@NOSN
     C     P@FMT1        PARM      P@FMT1        DSSDY
     C*
     C     P@RTCD        IFNE      *BLANKS
     C     P@RTCD        ANDNE     '*ACST  '
     C                   EVAL      *IN20 = *ON
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN23 = *ON
     C                   EVAL      *IN24 = *ON
     C                   EVAL      WErrFlg = 'Y'
     C                   EVAL      WBldFlg = 'N'
     C                   EVAL      PMsgID = 'USR5020'
     C                   EXSR      SRSndErr
     C                   LeaveSR
     C                   ELSE

     C**  CHECK TO SEE IF USER IS AUTHORISED TO BRANCH ASSOCIATED WITH
     C**  REQUESTED ACCOUNT

     C     MBIN          IFEQ      'Y'
     C                   CALL      'ZVBBU'
     C                   PARM                    #1BRCA
     C                   PARM      *ZERO         ERRCOD
     C*
     C     ERRCOD        IFNE      0
     C                   EVAL      *IN24 = *ON
     C                   EVAL      WErrFlg = 'Y'
     C                   EVAL      WBldFlg = 'N'
     C                   EVAL      PMsgID = 'USR5021'
     C                   EXSR      SRSndErr
     C                   LeaveSR
     C                   END
     C                   END

     C                   ENDIF

      * CHECK TYPE OF INPUT FROM RETURNED VALUE, IF NOSTRO CODE OR
      * SHORTNAME OR RETAIL NO., BLANK OUT OTHER INPUT FIELDS

     C     P@TYPE        IFEQ      '*NOSHNM'
     C     P@TYPE        OREQ      '*NOSTRO'
     C     P@TYPE        OREQ      '*RETAIL'
     C                   Eval      #1BRCA  = BRCA
     C                   Eval      #1CNUM  = CNUM
     C                   Eval      #1CCY   = CCY
     C                   Move      ACOD          #1ACOD
     C                   Move      ACSQ          #1ACSQ
     C                   END

      * Check the field P@NOSN returned by AOACCTV0

     C     P@NOSN        IFNE      *BLANK
     C                   Eval      TypeAcc = 'N'
     C                   ELSE

      * Check the field ATYP returned by AOACCTV0

     C     ATYP          IFEQ      'R'
     C                   Eval      TypeAcc = 'R'
     C                   ELSE

      * Send error message: Acount must be a Nostro or a Retail account

     C                   EVAL      *IN20 = *ON
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN23 = *ON
     C                   EVAL      *IN24 = *ON
     C                   EVAL      WErrFlg = 'Y'
     C                   EVAL      WBldFlg = 'N'
     C                   EVAL      PMsgID = 'USR5022'
     C                   EXSR      SRSndErr
     C                   LeaveSR
     C                   END
     C                   END

      * Convert the input fields in the correct format to access the files

     C                   EXSR      SrCvt

      * Move the Account name to the screen field

     C                   Eval      DDANAM = ANAM

      * Retrieve the currency decimal places of the Account currency

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    #1CCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBKey = #1CCY
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      WDECA = A6NBDP
     C                   EVAL      WSPRA = A6SPRT
     C                   EVAL      WMDIA = A6MDIN

      * Retrieve the Opening Cleared balance

     C                   Eval      DDCLBL = *Blanks

     C     KeyAc1        CHAIN     GLACBTL0

     C                   IF        %FOUND(GLACBTL0)

      * Edit the Opening Balance

     C                   MOVE      CLBL          ZFLD15
     C                   EXSR      ZSEdit
     C                   MOVE      ZOUT21        DDCLBL

      * Keep the Opening Balance in a work field

     C                   Z-add     CLBL          WWPROJ
     C                   END

      * If the selected account is a Retail account, retrieve the Closing
      * Clear balance from MEMOS

     C                   Eval      DDPROJC = *Blanks

     C     TypeAcc       IfEq      'R'

     C     KeyAc1        CHAIN     MEMOSL1

     C                   IF        %FOUND(MEMOSL1)

      * Edit the Closing Clear balance

     C                   MOVE      CLBLN         ZFLD15
     C                   EXSR      ZSEdit
     C                   MOVE      ZOUT21        DDPROJC
     C                   END

     C                   END

      * If the selected account is a Nostro account, retrieve the Closing
      * Clear balance from PRONO
     C     TypeAcc       IfEq      'N'

     C     KeyProno      CHAIN     PRONO

     C                   IF        %FOUND(PRONO)

      *  Look up the run date in the nostro balance posting date
      *  array to get the corresponding projected closing ledger
      *  balance of account movements as of run date.

     C                   Z-ADD     1             E                 1 0
     C     BJRDNB        LOOKUP    PDAT(E)                                70
     C                   Z-ADD     PBAL(E)       ZFLD15
     C                   EXSR      ZSEdit
     C                   MOVE      ZOUT21        DDPROJC
     C                   Z-ADD     PBAL(E)       CLBLN
     C                   Else
     C                   Z-ADD     0             PDAT(5)
     C                   END

     C                   END

      ****************
      ** Validate Date
      ****************

     C                   IF        #1VDAT = *Blanks
      ***Move*System*Run*date*in*it*********************************************            MD023671
      ** Move System Run date in it if the system value ForecastIncUnmatched='N'            MD023671
      ** Move *Blanks if the system value ForecastIncUnmatched='Y'                          MD023671
                                                                                            MD023671
     C                   IF        WINC   = 'N'                                             MD023671
     C**********         Move      PDateOut      #1VDAT                                     MD023671
     C                   Move      PDateRun      #1VDAT                                     MD023671
     C                   Else                                                               MD023671
     C                   Move      '010172'      #1VDAT                                     MD023671
     C                   Endif                                                              MD023671
     C                   ENDIF

     C                   MOVE      #1VDAT        DATEA             6
     C                   TESTN                   DATEA                9798

     C                   MOVE      DATEA         DATEN
     C                   CALL      'ZDATE1'
     C                   PARM      *Blanks       ErrorFlag         7
     C                   PARM                    DATEN             6 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDAYNO            5 0

     C                   EVAL      KkVdat = ZDAYNO

      ** Invalid format or not numeric
     C     ErrorFlag     IFNE      *Blanks
     C     *IN97         OREQ      '0'
     C     *IN98         ANDEQ     '0'
     C                   EVAL      *IN25 = *ON
     C                   EVAL      WErrFlg = 'Y'
     C                   EVAL      WBldFlg = 'N'
     C                   EVAL      PMsgID = 'USR5023'
     C                   EXSR      SRSndErr
     C                   LeaveSR
     C                   ENDIF

      ** If Retail account, the date must be less or equal to the Run date

     C                   IF        TypeAcc = 'R' and ZDAYNO > BJRDNB
     C                   EVAL      *IN25 = *ON
     C                   EVAL      WErrFlg = 'Y'
     C                   EVAL      WBldFlg = 'N'
     C                   EVAL      PMsgID = 'USR5024'
     C                   EXSR      SRSndErr
     C                   LeaveSR
     C                   ENDIF

      ** If Nostro account, the date must be less or equal to the 4th next working day

     C                   IF        TypeAcc = 'N' and ZDAYNO > PDAT(5)
     C                   EVAL      *IN25 = *ON
     C                   EVAL      WErrFlg = 'Y'
     C                   EVAL      WBldFlg = 'N'
     C                   EVAL      PMsgID = 'USR5025'
     C                   EXSR      SRSndErr
     C                   LeaveSR
     C                   ENDIF

      ***************************
      ** Validate Amount and sign
      ***************************

      ** Sign must be '+', '-' or ' '
     C                   IF        #1SIGN <> '+' and #1SIGN <> '-'
     C                             and #1SIGN <> ' '
     C                   EVAL      *IN26 = *ON
     C                   EVAL      WErrFlg = 'Y'
     C                   EVAL      WBldFlg = 'N'
     C                   EVAL      PMsgID = 'USR5026'
     C                   EXSR      SRSndErr
     C                   LeaveSR
     C                   ENDIF

      ** Amount must be a valid amount in the account ccy
     C                   MOVEl(P)  #1AMNT        ZFIELD           16
     C                   Z-ADD     WDECA         ZADEC             1 0
     C                   Eval      ZADIG = 13 - ZADEC
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANK        PRTCD             7
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG             2 0
     C                   PARM      *BLANKS       ZAVAL            16
     C                   MOVEL     ZAVAL         WWAMNT
      *
     C                   If        PRTCD <> *Blanks
     C                   EVAL      *IN27 = *ON
     C                   EVAL      WBldFlg = 'N'
     C                   EVAL      WErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR5027'
     C                   EXSR      SRSndErr
     C                   LeaveSR
     C                   ENDIF

      ** If the sign is not blank, amount must be filled
     C                   IF        #1SIGN <> ' ' and #1AMNT = *Blanks
     C                   EVAL      *IN27 = *ON
     C                   EVAL      WBldFlg = 'N'
     C                   EVAL      WErrFlg = 'Y'
     C                   EVAL      PMsgID = 'USR5028'
     C                   EXSR      SRSndErr
     C                   LeaveSR
     C                   ENDIF

      ** If no error change the flag to build the subfile
     C                   EVAL      WBldFlg = 'Y'

      ** Save the selection fields
     C                   EVAL      AccSav  = AccSel

      ** Save the customer
     C                   MOVEL     DDCNUM        DDCNUM6

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvt   - Convert screen format to File format               *
      *                                                               *
      *****************************************************************
     C     SRCvt         BEGSR

     C                   EVAL      KkBRCA = BRCA
     C                   EVAL      KkCNUM = CNUM
     C                   EVAL      KkCCY  = CCY
     C                   EVAL      KkAcod = ACOD
     C                   EVAL      KkAcsq = ACSQ

     C                   EVAL      KkNonb = P@NOSN
     C                   Move      P@NOSN        KkNon

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTotB - Set up Total balances                               *
      *                                                               *
      *****************************************************************
     C     SRTotB        BEGSR

      ** If the subfile is built (i.e the field WBldFlg = 'Y')

     C                   IF        WBldFlg = 'Y'
     C                   Eval      *IN50 = '1'
     C                   EVAL      WBldFlg = 'N'
     C                   End

      ** Z-Add the field CLBLN in WWFBAL

     C                   Z-add     CLBLN         WWFBAL

      ** Add the Total Forecast for the Run date (field BALRUN) in WWFBAL

     C                   Add       BalRun        WWFBAL

      ** Edit the field WWFBAL

     C                   Eval      DDFORC = *Blanks

     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WWFBAL        ZFLD15
     C                   EXSR      ZSEdit
     C                   MOVE      ZOUT21        DDFORC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAccDet - Account detail enquiry                            *
      *                                                               *
      *****************************************************************
     C     SRAccDet      BEGSR

      ** F13 on screen - Account details

     C                   IF        *INKM = '1'
     C                   EVAL      FUNC = 'F13'
     C                   OUT       DSLDA
     C                   EVAL      EXTFLG = 'Y'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAccMvt - Account movement enquiry                          *
      *                                                               *
      *****************************************************************
     C     SRAccMvt      BEGSR

      ** F14 on screen - Account movement details

     C                   IF        *INKN = '1'
     C                   EVAL      FUNC = 'F14'
     C                   OUT       DSLDA
     C                   EVAL      EXTFLG = 'Y'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProjM  - Projected movements enquiry                       *
      *                                                               *
      *****************************************************************
     C     SRProjM       BEGSR

      ** F15 on screen - Projected movements

     C                   IF        *INKP = '1'
     C                   EVAL      FUNC = 'F15'
     C                   OUT       DSLDA
     C                   EVAL      EXTFLG = 'Y'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRItem   - Item in clearing enquiry                          *
      *                                                               *
      *****************************************************************
     C     SRItem        BEGSR

      ** F16 on screen - Item in clearing

     C                   IF        *INKQ = '1'
     C                   EVAL      FUNC = 'F16'
     C                   OUT       DSLDA
     C                   EVAL      EXTFLG = 'Y'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndErr - Sends error messages to the program message       *
      *             queue via ZA0340.                                 *
      *                                                               *
      *****************************************************************
     C     SRSndErr      BEGSR

     C                   CALL      'ZA0340'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgID

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZSEdit - Edit amount                                         *
      *                                                               *
      *****************************************************************
     C     ZSEdit        BEGSR

     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    WDECA
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Handles the initial processing                      *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR

      ** Initialise relevant variables.

     C                   EVAL      W1SFRN = *ZERO
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      SFLEND = *OFF

      ** Initialise processing flags.

     C                   EVAL      WDspFlg = 'N'
     C                   EVAL      WBldFlg = 'N'

      ** Initialise selection fields

     C                   EVAL      AccSel  = *Blanks

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      * Access the data area DSLDA to retrieve the selected account:
     C     *DTAARA       DEFINE    *LDA          DSLDA

     C                   IN        DSLDA

      **   Access RUNDAT for multibranching indicator

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

      ** Set the program, module, and procedure names for DB error handling.

     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName

      ** Access bank details.

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      * Retrieve the system value

     C                   EVAL      ProcMode = ForecastUn
     C                   CALL      'AOSVALR0'
     C                   PARM                    RTNCDE
     C                   PARM                    ProcMode
     C                   PARM                    SVAL1
     C                   PARM                    SVALK2
     C                   PARM                    SVAL2
     C                   PARM                    SVALK3
     C                   PARM                    SVAL3
     C                   PARM                    SVALK4
     C                   PARM                    SVAL4
     C                   PARM                    SVALK5
     C                   PARM                    SVAL5
     C                   PARM                    SVALK6
     C                   PARM                    SVAL6
     C                   PARM                    SVALK7
     C                   PARM                    SVAL7
     C                   PARM                    SVALK8
     C                   PARM                    SVAL8
     C                   PARM                    SVALK9
     C                   PARM                    SVAL9
     C                   PARM                    SVALK0
     C                   PARM                    SVAL10

      * If the system value is not found then issue a database error

     C     RTNCDE        IFNE      '       '
     C                   EXSR      *PSSR
     C                   ENDIF

      * Get the Forecast Include Unmatched in Projected Balance

     C                   MOVEL     SVAL1         WINC

      ** Set the system information display fields.

     C                   EVAL      DDRUNA = BJMRDT
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDWSID = PSJobName
     C                   EVAL      #2PGMQ = PSProcMod

      * Retrieve the default branch for the current user
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
     C                   MOVE      DBRN          WUserBrch         3

      * Convert System run date in screen format
     C                   CALL      'ZDATE2'
     C                   PARM      BJRDNB        PDaynoIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM      *BLANKS       PADateOut
                                                                                            MD023671
     C                   EVAL      PDateRun = PDateOut                                      MD023671

      * Initialise the Value date received only if the account received is not blank
     C                   IF        EACNT  <> *Blanks and EVDAT = *Blanks

      * Move System Run date in it if the system Value ForecastIncUnmatched = 'N'
      * Else move *zero/blanks

     C                   IF        WINC = 'N'
     C                   Move      PDateOut      EVDAT
     C                   Else
     C**********         EVAL      EVDAT = *Blanks                                          MD023671
     C                   EVAL      EVDAT = '010172'                                         MD023671
     C                   END

     C                   ENDIF

      * Initialise work fields
     C                   EVAL      PRDATE = BJRDNB - 1
     C                   EVAL      ExtFlg = 'N'

      * Declare cursor C1 for Forecast file sorted by Retail account

     C/exec sql
     C+ declare C1 Scroll Cursor
     C+  for select *
     C+  from GLFORITD
     C+  where IFRECI = 'D' and IFPROR = 'Y' and IFACTL = 0
     C+                 and IFACZR <> 'Y' and IFFACN Like :KkFacn
     C+                 and IFDATE >= :KkVdat
     C+  order by
     C+  IFFACN, IFDATE
     C/end-exec

      * Declare cursor C2 for Forecast file sorted by Nostro account

     C/exec sql
     C+ declare C2 Scroll Cursor
     C+  for select *
     C+  from GLFORITD
     C+  where IFRECI = 'D' and IFPRON = 'Y' and IFACTL = 0
     C+                 and IFACZR <> 'Y' and IFCCY Like :KkCcy
     C+                 and IFNosC Like:KkNonb and IFDATE >= :KkVdat
     C+  order by
     C+  IFCCY, IFNOSC, IFDATE
     C/end-exec

      ** Define the key list

     C     KeyAc1        KLIST
     C                   KFLD                    KkCnum
     C                   KFLD                    KkCcy
     C                   KFLD                    KkAcod
     C                   KFLD                    KkAcsq
     C                   KFLD                    KkBrca

     C     KeyAc2        KLIST
     C                   KFLD                    KkBrca
     C                   KFLD                    KkCnum
     C                   KFLD                    KkCcy
     C                   KFLD                    KkAcod
     C                   KFLD                    KkAcsq

     C     KeyAc2V       KLIST
     C                   KFLD                    KkBrca
     C                   KFLD                    KkCnum
     C                   KFLD                    KkCcy
     C                   KFLD                    KkAcod
     C                   KFLD                    KkAcsq
     C                   KFLD                    KkVdat

     C     KeyProno      KLIST
     C                   KFLD                    KkCcy
     C                   KFLD                    KkNon

     C                   EVAL      SFLMSGEND = *ON

     C                   EXSR      SRInit

     C                   EXSR      SRClr

      * If the account received is not blank, validate received data
     C                   IF        EACNT  <> *Blanks

     C                   EVAL      #1CNUM = ECNUM
     C                   EVAL      #1CCY  = ECCY
     C                   EVAL      #1ACOD = EACOD
     C                   EVAL      #1ACSQ = EACSQ
     C                   EVAL      #1BRCA = EBRCA

     C                   EXSR      SRVal
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   DUMP

     C                   CALL      'DBERRCTL'

     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2013
