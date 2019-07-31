     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Forecast Total Avail Balance Rebuild-COB')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000602 - Midas OF Forecast Total Available Balance         *
      *             Rebuild (COB)                                     *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD036002A          Date 01Oct15               *
      *                 MD036002           Date 28Sep15               *
      *                 MD024013           Date 12Dec13               *
      *                 MD023548           Date 20Nov13               *
      *                 CGL145B  *Create   Date 29Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036002A - component still fails even if record is found in *
      *              GLACNTQD                                         *
      *  MD036002 - decimal data error due to null values in FBDAT*   *
      *             fields during insert in GLFTABTDD (caused by      *
      *             GLACNTQD record not found)                        *
      *  MD024013 - Conversion rate not correct                       *
      *  MD023548 - WDAYF too small to hold the result                *
      *  CGL145B - Subsidiaries Daily Sweeping Forecast               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)

      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Midas OF Individual Forecast
     D FORIT         E DS                  EXTNAME(GLFORITD)

      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Copyright array
     D A@CPY           DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)

      ** Local Data Area for database error details
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)

      ** Account
     D KAccnt          DS
     D  KBRCA                  1      3
     D  KCNUM                  4      9
     D  KCCY                  10     12
     D  KACOD                 13     22  0
     D  KACSQ                 23     24  0

     D F1BRCA          S              3A
     D F1CNUM          S              6A
     D F1CCY           S              3A
     D F1ACOD          S             10  0
     D F1ACSQ          S              2  0

     D                 DS
     D  F1DAT0                 1      3P 0
     D  F1DAT1                 4      6P 0
     D  F1DAT2                 7      9P 0
     D  F1DAT3                10     12P 0
     D  F1DAT4                13     15P 0
     D  F1DAT5                16     18P 0
     D  F1DAT6                19     21P 0
     D  F1DAT7                22     24P 0
     D  F1DAT8                25     27P 0
     D  F1DAT9                28     30P 0
     D  F1DATS                 1     30P 0
     D                                     DIM(10) ASCEND

     D                 DS
     D  FBDAT0                 1      5  0
     D  FBDAT1                 6     10  0
     D  FBDAT2                11     15  0
     D  FBDAT3                16     20  0
     D  FBDAT4                21     25  0
     D  FBDAT5                26     30  0
     D  FBDAT6                31     35  0
     D  FBDAT7                36     40  0
     D  FBDAT8                41     45  0
     D  FBDAT9                46     50  0
     D  FBDATS                 1     50  0
     D                                     DIM(10) ASCEND

     DForeBal          DS
     D  FBFTB0                 1     15  0
     D  FBFTB1                16     30  0
     D  FBFTB2                31     45  0
     D  FBFTB3                46     60  0
     D  FBFTB4                61     75  0
     D  FBFTB5                76     90  0
     D  FBFTB6                91    105  0
     D  FBFTB7               106    120  0
     D  FBFTB8               121    135  0
     D  FBFTB9               136    150  0
     D  FBFTBS                 1    150  0
     D                                     DIM(10) ASCEND

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for access object programs
     D PRtCd           S              7
     D POptn           S              7
     D PCcy            S              3
                                                                                            MD024013
      ** Paramaters for ZXRATE                                                              MD024013
     D  ZRATE1         S             13P 8                                                  MD024013
     D  ZMDI1          S              1A                                                    MD024013
     D  ZRATE2         S             13P 8                                                  MD024013
     D  ZMDI2          S              1A                                                    MD024013
     D  ZRATEX         S             13P 8                                                  MD024013
     D  ZMDIX          S              1A                                                    MD024013

      ** Parameters for ZCONVZ1
     D ZEXCH           S             13  8                                                  MD024013
     D ZMD             S              1                                                     MD024013
     D PAmnt           S             15  0
     D PFrXRate        S             13  8
     D PFrMDIn         S              1
     D PFrCCY          S              3
     D PToCCY          S              3
     D PFrDecPlace     S              1  0
     D PToDecPlace     S              1  0
     D POutAmt         S             15  0

      ** Other fields used
     D X               S              2  0
     D WRun            S              1A   Inz
     D ABCCR           S              1A
     D ABCDR           S              1A
     D WkProcType      S              1A
     D WIncl           S              1A
     D WOnce           S              1A
     D***WDayF**         S              1  0                                                MD023548
     D WDayF           S              2  0                                                  MD023548
     D WConvFAmt       S             15  0
     D WFrXrate        S                   LIKE(A6SPRT)
     D WFrMDIn         S                   LIKE(A6MDIN)
     D WFrDecPlace     S                   LIKE(A6NBDP)
     D WToXrate        S                   LIKE(A6SPRT)                                     MD024013
     D WToMDIn         S                   LIKE(A6MDIN)                                     MD024013
     D WToDecPlace     S                   LIKE(A6NBDP)
     D PSysVal         S             20    DIM(10)
     D PCurSet         S            200    DIM(10)
     D SVFACN          S             24A
     D SVSQLCode       S             10  0
     D P#Error         S              1A                                                    MD036002

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      *  MAIN PROCEDURE                                               *
      *****************************************************************

     C                   EXSR      SRReadFORI

     C                   EVAL      *INLR = *ON

     C                   RETURN
      *****************************************************************
      *  PROGRAM END                                                  *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadFORI - Subroutine to read Individual Foreacasts        *
      *                                                               *
      *****************************************************************
     C     SRReadFORI    BEGSR

      ** Set file pointer to first record and do initial read
      ** Include forecast transactions that are:
      ** Live, Actual Amount = 0, Actual is Zero Flag = N,
      ** Project on Retail = 'Y'

     C/exec SQL
     C+ declare CUR1 cursor for
     C+ select * from GLFORITD
     C+ where
     C+       IFRECI  = 'D' and
     C+       IFFACN <> ' ' and
     C+       IFACTL  =  0  and
     C+       IFPROR  = 'Y' and
     C+       IFACZR  = 'N'
     C+ order by
     C+       IFFACN
     C/end-exec

     C/exec SQL
     C+ open CUR1
     C/end-exec

      ** Handle SQL Error (if not %EOF)

     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBase = 3
     C                   EVAL      DBFile = 'SQL STM'
     C                   EVAL      DBKey = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from CUR1
     C+ into :FORIT
     C/end-exec

      ** Read Individual forecast table until end of file

     C                   DOW       SQLCode <> 100

      ** Accumulate for this account
     C                   EVAL      FBFTBS = *ZEROS
     C                   EVAL      SVFACN = IFFACN
     C                   EVAL      WOnce =  'N'

     C                   DOW       IFFACN = SVFACN AND
     C                             SQLCode <> 100

      ** Access Account extension record for the Forecast Dates

     C                   IF        WOnce =  'N'
     C                   EXSR      SRReadCNTQ
     C                   EVAL      WOnce =  'Y'
     C                   ENDIF

      ** Process Individual forecasts

     C                   EXSR      SRProcFORI

     C/exec SQL
     C+ fetch next
     C+ from CUR1
     C+ into :FORIT
     C/end-exec

     C                   ENDDO

      ** Output to Total forecasts table

     C                   EVAL      SVSQLCode = SQLCode
     C                   EXSR      SROutTABF
     C                   EVAL      SQLCode = SVSQLCode

     C                   ENDDO

      ** Handle SQL Error (if %EOF)

     C                   IF        SQLCode < 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBase = 4
     C                   EVAL      DBFile = 'SQL STM'
     C                   EVAL      DBKey = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C/exec SQL
     C+ close CUR1
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadCNTQ - Access Account Extension File                   *
      *                                                               *
      *****************************************************************
     C     SRReadCNTQ    BEGSR

     C                   EVAL      KAccnt = IFFACN

     C/exec SQL
     C+ select
     C+       F1BRCA
     C+     , F1CNUM
     C+     , F1CCY
     C+     , F1ACOD
     C+     , F1ACSQ
     C+     , F1DAT0
     C+     , F1DAT1
     C+     , F1DAT2
     C+     , F1DAT3
     C+     , F1DAT4
     C+     , F1DAT5
     C+     , F1DAT6
     C+     , F1DAT7
     C+     , F1DAT8
     C+     , F1DAT9
     C+ into
     C+       :F1BRCA
     C+     , :F1CNUM
     C+     , :F1CCY
     C+     , :F1ACOD
     C+     , :F1ACSQ
     C+     , :F1DAT0
     C+     , :F1DAT1
     C+     , :F1DAT2
     C+     , :F1DAT3
     C+     , :F1DAT4
     C+     , :F1DAT5
     C+     , :F1DAT6
     C+     , :F1DAT7
     C+     , :F1DAT8
     C+     , :F1DAT9
     C+ from GLACNTQD
     C+ where
     C+       F1BRCA = :KBRCA and
     C+       F1CNUM = :KCNUM and
     C+       F1CCY  = :KCCY  and
     C+       F1ACOD = :KACOD and
     C+       F1ACSQ = :KACSQ
     C/end-exec

      ** Handle SQL Error (if %EOF) or record not found                                     MD036002
                                                                                            MD036002
     C                   EVAL      P#Error = 'N'                                            MD036002
     C**********         IF        SQLCode < 100 or SQLCode = 100                 MD036002 MD036002A
     C                   IF        SQLCOD = 100                                            MD036002A
     C     *LOCK         IN        LDA                                                      MD036002
     C                   EVAL      P#Error = 'Y'                                            MD036002
     C                   EVAL      DBase = 7                                                MD036002
     C                   EVAL      DBFile = 'GLACNTQD'                                      MD036002
     C                   EVAL      DBKey =  KBRCA + KCNUM + KCCY                            MD036002
     C                                   + %char(KACOD) + %char(KACSQ)                      MD036002
     C                   OUT       LDA                                                      MD036002
     C                   EXSR      *PSSR                                                    MD036002
     C                   ENDIF                                                              MD036002

      ** Set Forecast Dates from Available balance dates

     C                   EVAL      X = 1
     C                   DOW       X <= 10
     C                   EVAL      FBDATS(X) = F1DATS(X)
     C                   EVAL      X = X + 1
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcFORI - Process individual forecasts                    *
      *                                                               *
      *****************************************************************
     C     SRPRocFORI    BEGSR

      ** Convert Forecast Amount to Account Currency

     C                   IF        IFCCY <> F1CCY
     C                   EXSR      SRConvert
     C                   ELSE
     C                   EVAL      WConvFAmt  = IFAMNT
     C                   ENDIF

      ** Compute for Forecast Total Available Balance

     C                   EXSR      SRForeBal

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConvert - Convert Forecast Amount to Account Currency      *
      *                                                               *
      *****************************************************************
     C     SRConvert     BEGSR

      ** Retrieve currency details for FROM currency

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      IFCCY         PCcy
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PrtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = IFCCY
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WFrXrate = A6SPRT
     C                   EVAL      WFrMDIn  = A6MDIN
     C                   EVAL      WFrDecPlace = A6NBDP
     C                   ENDIF

      ** Retrieve currency details for TO currency

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POPTN
     C                   PARM      F1CCY         PCCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = KCCY
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WToXrate = A6SPRT                                        MD024013
     C                   EVAL      WToMDIn  = A6MDIN                                        MD024013
     C                   EVAL      WToDecPlace = A6NBDP
     C                   ENDIF

     C                   Z-ADD     WFrXrate      ZRATE1                                     MD024013
     C                   MOVE      WFrMDIn       ZMDI1                                      MD024013
     C                   Z-ADD     WToXrate      ZRATE2                                     MD024013
     C                   MOVE      WToMDIn       ZMDI2                                      MD024013
     C                   CALL      'ZXRATE'                                                 MD024013
     C                   PARM                    ZRATE1                                     MD024013
     C                   PARM                    ZMDI1                                      MD024013
     C                   PARM                    ZRATE2                                     MD024013
     C                   PARM                    ZMDI2                                      MD024013
     C                   PARM                    ZRATEX                                     MD024013
     C                   PARM                    ZMDIX                                      MD024013
                                                                                            MD024013
     C                   Z-ADD     ZRATEX        ZEXCH                                      MD024013
     C                   MOVE      ZMDIX         ZMD                                        MD024013
      *                                                                                     MD024013
      ** Convert Forecast Amount

     C                   CALL      'ZCONVZ1'
     C                   PARM      IFAMNT        PAmnt
     C**********         PARM      WFrXRate      PFrXRate                                   MD024013
     C**********         PARM      WFrMDIn       PFrMDIn                                    MD024013
     C                   PARM                    Zexch                                      MD024013
     C                   PARM                    Zmd                                        MD024013
     C                   PARM      IFCCY         PFrCCY
     C                   PARM      F1CCY         PToCCY
     C                   PARM      WFrDecPlace   PFrDecPlace
     C                   PARM      WToDecPlace   PToDecPlace
     C                   PARM                    POutAmt

     C                   EVAL      WConvFAmt = POutAmt

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRForeBal - Calculate Forecast Total Available Balance       *
      *                                                               *
      *****************************************************************
     C     SRForeBal     BEGSR

      ** Set Processing type

     C                   IF        IFAMNT < 0
     C                   EVAL      WkProcType = ABCDR
     C                   ELSE
     C                   EVAL      WkProcType = ABCCR
     C                   ENDIF

      ** Update Balances

     C                   EVAL      X = 1

     C                   DOW       X <= WDayF

     C                   SELECT

     C                   WHEN      WKProcType = '1'
     C                   IF        (IFDATE >= BJRDNB AND WIncl = 'N')
     C                             OR
     C                             WIncl = 'Y'
     C                   EXSR      SRCalFBal
     C                   ENDIF


     C                   WHEN      WKProcType = '2'
     C                   IF        (IFDATE >= FBDATS(X) AND WIncl = 'N')
     C                             OR
     C                             (IFDATE <= FBDATS(X) AND WIncl = 'Y')
     C                   EXSR      SRCalFBal
     C                   ENDIF

     C                   WHEN      WKProcType = '3'
     C                   IF        (IFDATE = BJRDNB AND WIncl = 'N')
     C                             OR
     C                             (IFDATE <= BJRDNB AND WIncl = 'Y')
     C                   EXSR      SRCalFBal
     C                   ENDIF

     C                   WHEN      WKProcType = '4'
     C                   ENDSL

     C                   ADD       1             X

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCalFBal - Subroutine to Calculate Forecast Balance         *
      *                                                               *
      *****************************************************************
     C     SRCalFBal     BEGSR

      ** Update Forecast Balances

     C                   EVAL      FBFTBS(X)  = FBFTBS(X)  + WConvFAmt

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROutTABF - Subroutine to output to Total Forecasts table    *
      *                                                               *
      *****************************************************************
     C     SROutTABF     BEGSR

     C/exec SQL
     C+ insert into GLFTABTD
     C+    ( FBBRCA
     C+     ,FBCNUM
     C+     ,FBCCY
     C+     ,FBACOD
     C+     ,FBACSQ
     C+     ,FBDAT0
     C+     ,FBDAT1
     C+     ,FBDAT2
     C+     ,FBDAT3
     C+     ,FBDAT4
     C+     ,FBDAT5
     C+     ,FBDAT6
     C+     ,FBDAT7
     C+     ,FBDAT8
     C+     ,FBDAT9
     C+     ,FBFTB0
     C+     ,FBFTB1
     C+     ,FBFTB2
     C+     ,FBFTB3
     C+     ,FBFTB4
     C+     ,FBFTB5
     C+     ,FBFTB6
     C+     ,FBFTB7
     C+     ,FBFTB8
     C+     ,FBFTB9)
     C+ values
     C+    ( :KBRCA
     C+     ,:KCNUM
     C+     ,:KCCY
     C+     ,:KACOD
     C+     ,:KACSQ
     C+     ,:FBDAT0
     C+     ,:FBDAT1
     C+     ,:FBDAT2
     C+     ,:FBDAT3
     C+     ,:FBDAT4
     C+     ,:FBDAT5
     C+     ,:FBDAT6
     C+     ,:FBDAT7
     C+     ,:FBDAT8
     C+     ,:FBDAT9
     C+     ,:FBFTB0
     C+     ,:FBFTB1
     C+     ,:FBFTB2
     C+     ,:FBFTB3
     C+     ,:FBFTB4
     C+     ,:FBFTB5
     C+     ,:FBFTB6
     C+     ,:FBFTB7
     C+     ,:FBFTB8
     C+     ,:FBFTB9 )
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Set off program indicators

     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

      ** Access Bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      PSysVal(1) = 'ABCForecastDR'
     C                   EVAL      PSysVal(2) = 'ABCForecastCR'
     C                   EVAL      PSysVal(3) = 'ABCNoDaysForward'
     C                   EVAL      PSysVal(4) = 'ForecastIncUnmatched'

      ** Retrieve System Values

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    PSysVal(1)
     C                   PARM                    PCurSet(1)
     C                   PARM                    PSysVal(2)
     C                   PARM                    PCurSet(2)
     C                   PARM                    PSysVal(3)
     C                   PARM                    PCurSet(3)
     C                   PARM                    PSysVal(4)
     C                   PARM                    PCurSet(4)
     C                   PARM                    PSysVal(5)
     C                   PARM                    PCurSet(5)
     C                   PARM                    PSysVal(6)
     C                   PARM                    PCurSet(6)
     C                   PARM                    PSysVal(7)
     C                   PARM                    PCurSet(7)
     C                   PARM                    PSysVal(8)
     C                   PARM                    PCurSet(8)
     C                   PARM                    PSysVal(9)
     C                   PARM                    PCurSet(9)
     C                   PARM                    PSysVal(10)
     C                   PARM                    PCurSet(10)

      ** Check if database error occured

     C                   FOR       X = 1 TO 10

     C                   IF        PCurSet(X) = '*NRF' OR
     C                             PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF'

     C     *LOCK         IN        LDA
     C                   EVAL      DBKey   = PSysVal(X)
     C                   EVAL      DBFile  = 'SDSVALPD'
     C                   EVAL      DBase   = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDFOR

     C                   EVAL      ABCDR = PCurSet(1)
     C                   EVAL      ABCCR = PCurSet(2)
     C                   EVAL      WDayF = %INT(%TRIM(PCurSet(3))) + 1
     C                   EVAL      WIncl = PCurSet(4)

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *Blanks
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On

     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2013
