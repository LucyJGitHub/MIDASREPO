     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Forecast Avail. Balance Calculation - I/C')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000501 - Midas OF Forecast Avail. Bal. Calculation - I/C   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CGL153             Date 05Feb14               *
      *  Prev Amend No. MD024950           Date 11Feb14               *
      *                 MD024013           Date 12Dec13               *
      *                 MD023692           Date 22Nov13               *
      *                 CGL145B  *CREATE   Date 28Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL153 - Bank Position Report                                *
      *  MD024590 - Incorrect available balance for forecast          *
      *  MD024013 - Conversion rate not correct                       *
      *  MD023692- Available balance not updated correctly            *
      *  CGL145B - Subsidiaries Daily Sweeping Forecast (Drop 3)      *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Account Details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(A_)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     ** File DS
     **   Midas OF Midas OF Forecast Available Balance Table
     D FOAVT         E DS                  EXTNAME(GLFOAVTD)
 
 
      ** Parameter data
     D InParm          DS           500
     D  ActnCode               1      1
     D  Status                 2     11
     D  BrchCode              12     14
     D  CustNum               15     20
     D  Currency              21     23
     D  AccntCodeX            24     33
     D  AccntSeqX             34     35
     D  FCastCCY              36     38
     D  IndFCastDatX          39     43
     D  FCastAmtX             44     58
     D  ActlAmtX              59     73
     D  ActlZero              74     74
     D  PrjctRetl             75     75
     D  OFCastAmtX            76     90
     D  OActlAmtX             91    105
     D  OActlZero            106    106
     D  OPrjctRetl           107    107
     D  PNostroCode          108    109                                                       CGL153
     D  PAProjNos            110    110                                                       CGL153
     D  POProjNos            111    111                                                       CGL153
     D**Filler**             108    500                                                       CGL153
     D  Filler               112    500                                                       CGL153
 
      ** Data structure for AOSVALR0 string
     D @SVAL1          DS           200
     D  SVAL1                  1    200
     D  SVAL1_1                1      1
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRtCd           S              7
     D POptn           S              7
     D PCcy            S              3
 
      ** Processing mode
     D ProcMode        S            190
 
      ** Forecast Include Unmatched in Projected Balance
     D WFIUPB          S              1A
 
      ** Parameter variables for AOSVALR0 string
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
 
      ** Paramaters for ZXRATE                                                              MD024013
     D  ZRATE1         S             13P 8                                                  MD024013
     D  ZMDI1          S              1A                                                    MD024013
     D  ZRATE2         S             13P 8                                                  MD024013
     D  ZMDI2          S              1A                                                    MD024013
     D  ZRATEX         S             13P 8                                                  MD024013
     D  ZMDIX          S              1A                                                    MD024013
                                                                                            MD024013
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
     D WRun            S              1A   Inz
     D WConvFAmt       S             15  0
     D WConvOFAmt      S             15  0
     D PRFAVAIL        S             15  0                                                  MD023692
     D WAFAVAIL        S             15  0
     D WAFDATE         S              5  0
     D IndFCastDat     S              5  0 INZ(0)
     D FCastAmt        S             15  0 INZ(0)
     D ActlAmt         S             15  0 INZ(0)
     D AccntCode       S             10  0 INZ(0)
     D AccntSeq        S              2  0 INZ(0)
     D OFCastAmt       S             15  0 INZ(0)
     D OActlAmt        S             15  0 INZ(0)
     D TOTAM           S             15  0 INZ(0)
     D WFCCUS          S              6A
     D WFACT           S              3  0
     D WFCNO           S              2  0
     D WFrXrate        S                   LIKE(A6SPRT)
     D WFrMDIn         S                   LIKE(A6MDIN)
     D WFrDecPlace     S                   LIKE(A6NBDP)
     D WToXrate        S                   LIKE(A6SPRT)                                     MD024013
     D WToMDIn         S                   LIKE(A6MDIN)                                     MD024013
     D WToDecPlace     S                   LIKE(A6NBDP)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *InzSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Check Transaction Received
 
     C                   EXSR      SRCheck
 
      ** End Program
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      *                                                               *
      *  SRCheck - Check Transaction Received                         *
      *                                                               *
      *****************************************************************
     C     SRCheck       BEGSR
 
     C                   EVAL      TOTAM = *Zeros
 
      ** Convert only if amounts passed are non blanks
 
     C                   IF        IndFCastDatX <> *Blanks
     C                   EVAL      IndFCastDat = %Dec(%Trim(IndFCastDatX):5:0)
     C                   ENDIF
 
     C                   IF        FCastAmtX <> *Blanks
     C                   EVAL      FCastAmt = %Dec(%Trim(FCastAmtX):15:0)
     C                   ENDIF
 
     C                   IF        ActlAmtX <> *Blanks
     C                   EVAL      ActlAmt = %Dec(%Trim(ActlAmtX):15:0)
     C                   ENDIF
 
     C                   IF        AccntCodeX <> *Blanks
     C                   EVAL      AccntCode = %Dec(%Trim(AccntCodeX):10:0)
     C                   ENDIF
 
     C                   IF        AccntSeqX <> *Blanks
     C                   EVAL      AccntSeq = %Dec(%Trim(AccntSeqX):2:0)
     C                   ENDIF
 
     C                   IF        OFCastAmtX <> *Blanks
     C                   EVAL      OFCastAmt = %Dec(%Trim(OFCastAmtX):15:0)
     C                   ENDIF
 
     C                   IF        OActlAmtX <> *Blanks
     C                   EVAL      OActlAmt = %Dec(%Trim(OActlAmtX):15:0)
     C                   ENDIF
 
      * Verify that the transaction received must be processed
 
      ** 'Projected on Retail' is 'N' or 'Actual is Zero' is 'Y'
      **  or 'Actual Amount' is not 0
      **  No processing to do for Actual amount
      **  In Amend mode processing to do for Original amount
 
     C                   IF        PrjctRetl = 'N' Or ActlZero = 'Y' Or
     C                             ActlAmt <> 0
 
      ** Action Code is Amend
 
     C                   IF        ActnCode = 'A'
     C                   EXSR      SRAmO
     C                   ENDIF
 
     C                   LEAVESR
     C                   ENDIF
 
      ** 'Projected on Retail' is 'Y' and  'Actual is Zero' is not 'Y'
      **  and 'Actual Amount' is 0
 
      ** Convert Forecast Currency if not equal
      ** to Account Currency
 
     C                   IF        Currency <> FCastCCY
     C                   EXSR      SRConvert
     C                   ELSE
     C                   EVAL      WConvFAmt  = FCastAmt
     C                   EVAL      WConvOFAmt = OFCastAmt
     C                   ENDIF
 
     C/exec SQL
     C+ declare LIST1 cursor for
     C+ select * from GLFOAVTD
     C+ where AFBRCA = :BrchCode and
     C+ AFCNUM = :CustNum and
     C+ AFCCY = :Currency and
     C+ AFACOD = :AccntCode and
     C+ AFACSQ = :AccntSeq and
     C+ AFDATE = :IndFCastDat
     C/end-exec
 
     C/exec SQL
     C+ open LIST1
     C/end-exec
 
      ** Handle SQL Error (If not %EOF)
 
     C                   IF        SQLCOD < 0
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C/exec SQL
     C+ fetch next
     C+ from LIST1
     C+ into: FOAVT
     C/end-exec
 
      **  Status is not 'Reject'
 
     C                   IF        Status <> 'REJECT'
                                                                                            MD024950
     C                   IF        Status = 'COMPLETE' AND WConvFAmt < 0                    MD024950
     C                             OR Status = 'AUTHORISE' AND WConvFAmt > 0                MD024950
 
      ** Action Code is Insert
 
     C                   IF        ActnCode = 'I'
     C                   EXSR      SRIn
     C                   ENDIF
 
      ** Action Code is Amend
 
     C                   IF        ActnCode = 'A'
     C                   EXSR      SRAm
     C                   ENDIF
 
      ** Action Code is Delete
 
     C                   IF        ActnCode = 'D'
     C                   EXSR      SRDe
     C                   ENDIF
 
     C                   ENDIF                                                              MD024950
                                                                                            MD024950
     C                   ELSE
 
      **  Status is 'Reject'
 
      ** Action Code is Insert
 
     C                   IF        ActnCode = 'I'
     C                   EXSR      SRInRej
     C                   ENDIF
 
      ** Action Code is Amend
 
     C                   IF        ActnCode = 'A'
     C                   EXSR      SRAmRej
     C                   ENDIF
 
      ** Action Code is Delete
 
     C                   IF        ActnCode = 'D'
     C                   EXSR      SRDeRej
     C                   ENDIF
 
     C                   ENDIF
 
     C/exec SQL
     C+ close LIST1
     C/end-exec
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmO - Amend Original Data in GLFOAVTD                      *
      *                                                               *
      *****************************************************************
     C     SRAmO         BEGSR
 
     C                   IF        OPrjctRetl = 'Y' And  OActlZero <> 'Y' And
     C                             OActlAmt = 0
 
     C/exec SQL
     C+ declare LIST2 cursor for
     C+ select * from GLFOAVTD
     C+ where AFBRCA = :BrchCode and
     C+ AFCNUM = :CustNum and
     C+ AFCCY = :Currency and
     C+ AFACOD = :AccntCode and
     C+ AFACSQ = :AccntSeq and
     C+ AFDATE = :IndFCastDat
     C/end-exec
 
     C/exec SQL
     C+ open LIST2
     C/end-exec
 
      ** Handle SQL Error (If not %EOF)
 
     C                   IF        SQLCOD < 0
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C/exec SQL
     C+ fetch next
     C+ from LIST2
     C+ into: FOAVT
     C/end-exec
 
      ** If record found in GLFOAVTD
 
     C                   IF        SQLCOD = 0
 
      ** Convert Forecast Currency if not equal
      ** to Account Currency
 
     C                   IF        Currency <> FCastCCY
     C                   EXSR      SRConvert
     C                   ELSE
     C                   EVAL      WConvFAmt  = FCastAmt
     C                   EVAL      WConvOFAmt = OFCastAmt
     C                   ENDIF
 
     C                   EVAL      WAFAVAIL = *ZEROS
     C                   EVAL      WAFAVAIL = AFAVAIL - WConvOFAmt
     C                   EVAL      TOTAM = TOTAM - WConvOFAmt
 
      ** Update Forecast Available Amount
 
     C/exec SQL
     C+ update GLFOAVTD set AFAVAIL = :WAFAVAIL
     C+ where AFBRCA = :BrchCode and
     C+ AFCNUM = :CustNum and
     C+ AFCCY = :Currency and
     C+ AFACOD = :AccntCode and
     C+ AFACSQ = :AccntSeq and
     C+ AFDATE = :IndFCastDat
     C/end-exec
 
      ** Update the Available Balance for other forward dates
     C                   EXSR      SRForw
 
     C                   ENDIF
 
     C/exec SQL
     C+ close LIST2
     C/end-exec
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIn - Insert Subroutine (Add/Update Record)                 *
      *                                                               *
      *****************************************************************
     C     SRIn          BEGSR
 
 
      ** If record found in GLFOAVTD, then update
 
     C                   IF        SQLCOD = 0
 
     C                   EVAL      WAFAVAIL = *ZEROS
     C                   EVAL      WAFAVAIL = AFAVAIL + WConvFAmt
     C                   EVAL      TOTAM = TOTAM + WConvFAmt
 
      ** Update Forecast Available Amount
 
     C/exec SQL
     C+ update GLFOAVTD set AFAVAIL = :WAFAVAIL
     C+ where AFBRCA = :BrchCode and
     C+ AFCNUM = :CustNum and
     C+ AFCCY = :Currency and
     C+ AFACOD = :AccntCode and
     C+ AFACSQ = :AccntSeq and
     C+ AFDATE = :IndFCastDat
     C/end-exec
 
     C                   ENDIF
 
      ** If record not found in GLFOAVTD, then create
 
     C                   IF        SQLCOD = 100
 
      ** Retrieve previous Forecast if exists                                               MD023692
                                                                                            MD023692
     C                   EXSR      SRPrev                                                   MD023692
                                                                                            MD023692
     C                   EVAL      WAFAVAIL = *ZEROS
     C**********         EVAL      WAFAVAIL = WConvFAmt                                     MD023692
     C                   EVAL      WAFAVAIL = WConvFAmt + PRFAVAIL                          MD023692
     C                   EVAL      TOTAM = TOTAM + WConvFAmt
 
      ** Get Facility Details
 
     C                   EXSR      SRGetFcltyDtl
 
      ** Insert Forecast Entry
 
     C/exec SQL
     C+ insert into GLFOAVTD
     C+ (
     C+   AFBRCA
     C+ , AFCNUM
     C+ , AFCCY
     C+ , AFACOD
     C+ , AFACSQ
     C+ , AFDATE
     C+ , AFAVAIL
     C+ , AFFCCUS
     C+ , AFFACT
     C+ , AFFCNO
     C+ )
     C+ Values
     C+ (
     C+   :BrchCode
     C+ , :CustNum
     C+ , :Currency
     C+ , :AccntCode
     C+ , :AccntSeq
     C+ , :IndFCastDat
     C+ , :WAFAVAIL
     C+ , :WFCCUS
     C+ , :WFACT
     C+ , :WFCNO
     C+ )
     C/end-exec
     C                   ENDIF
 
      ** Update the Available Balance for other forward dates
     C                   EXSR      SRForw
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAm - Amend Record in GLFOAVTD                              *
      *                                                               *
      *****************************************************************
     C     SRAm          BEGSR
 
      ** If record found in GLFOAVTD
 
     C                   IF        SQLCOD = 0
 
     C                   EVAL      WAFAVAIL = *ZEROS
     C                   EVAL      WAFAVAIL = AFAVAIL - WConvOFAmt
     C                   EVAL      WAFAVAIL = WAFAVAIL + WConvFAmt
     C                   EVAL      TOTAM = TOTAM - WConvOFAmt
     C                   EVAL      TOTAM = TOTAM + WConvFAmt
 
      ** Update Forecast Available Amount
 
     C/exec SQL
     C+ update GLFOAVTD set AFAVAIL = :WAFAVAIL
     C+ where AFBRCA = :BrchCode and
     C+ AFCNUM = :CustNum and
     C+ AFCCY = :Currency and
     C+ AFACOD = :AccntCode and
     C+ AFACSQ = :AccntSeq and
     C+ AFDATE = :IndFCastDat
     C/end-exec
 
      ** Update the Available Balance for other forward dates
     C                   EXSR      SRForw
 
     C                   ENDIF
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDe - Delete Record in GLFOAVTD                             *
      *                                                               *
      *****************************************************************
     C     SRDe          BEGSR
 
      ** If record found in GLFOAVTD
 
     C                   IF        SQLCOD = 0
 
     C                   EVAL      WAFAVAIL = *ZEROS
     C                   EVAL      WAFAVAIL = AFAVAIL - WConvFAmt
     C                   EVAL      TOTAM = TOTAM - WConvFAmt
 
      ** Update Forecast Available Amount
 
     C/exec SQL
     C+ update GLFOAVTD set AFAVAIL = :WAFAVAIL
     C+ where AFBRCA = :BrchCode and
     C+ AFCNUM = :CustNum and
     C+ AFCCY = :Currency and
     C+ AFACOD = :AccntCode and
     C+ AFACSQ = :AccntSeq and
     C+ AFDATE = :IndFCastDat
     C/end-exec
 
      ** Update the Available Balance for other forward dates
     C                   EXSR      SRForw
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInRej - Reject the Inserted Record in GLFOAVTD             *
      *                                                               *
      *****************************************************************
     C     SRInRej       BEGSR
 
      ** If record found in GLFOAVTD
 
     C                   IF        SQLCOD = 0
 
     C                   EVAL      WAFAVAIL = *ZEROS
     C                   EVAL      WAFAVAIL = AFAVAIL - WConvFAmt
     C                   EVAL      TOTAM = TOTAM - WConvFAmt
 
      ** Update Forecast Available Amount
 
     C/exec SQL
     C+ update GLFOAVTD set AFAVAIL = :WAFAVAIL
     C+ where AFBRCA = :BrchCode and
     C+ AFCNUM = :CustNum and
     C+ AFCCY = :Currency and
     C+ AFACOD = :AccntCode and
     C+ AFACSQ = :AccntSeq and
     C+ AFDATE = :IndFCastDat
     C/end-exec
 
      ** Update the Available Balance for other forward dates
     C                   EXSR      SRForw
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmRej - Reject the Amended Record in GLFOAVTD              *
      *                                                               *
      *****************************************************************
     C     SRAmRej       BEGSR
 
      ** If record found in GLFOAVTD
 
     C                   IF        SQLCOD = 0
 
     C                   EVAL      WAFAVAIL = *ZEROS
     C                   EVAL      WAFAVAIL = AFAVAIL - WConvFAmt
     C                   EVAL      WAFAVAIL = WAFAVAIL - WConvOFAmt
     C                   EVAL      TOTAM = TOTAM - WConvFAmt
     C                   EVAL      TOTAM = TOTAM + WConvOFAmt
 
      ** Update Forecast Available Amount
 
     C/exec SQL
     C+ update GLFOAVTD set AFAVAIL = :WAFAVAIL
     C+ where AFBRCA = :BrchCode and
     C+ AFCNUM = :CustNum and
     C+ AFCCY = :Currency and
     C+ AFACOD = :AccntCode and
     C+ AFACSQ = :AccntSeq and
     C+ AFDATE = :IndFCastDat
     C/end-exec
 
      ** Update the Available Balance for other forward dates
     C                   EXSR      SRForw
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDeRej - Reject the Deleted Record in GLFOAVTD              *
      *                                                               *
      *****************************************************************
     C     SRDeRej       BEGSR
 
      ** If record found in GLFOAVTD
 
     C                   IF        SQLCOD = 0
 
     C                   EVAL      WAFAVAIL = *ZEROS
     C                   EVAL      WAFAVAIL = AFAVAIL + WConvFAmt
     C                   EVAL      TOTAM = TOTAM + WConvFAmt
 
      ** Update Forecast Available Amount
 
     C/exec SQL
     C+ update GLFOAVTD set AFAVAIL = :WAFAVAIL
     C+ where AFBRCA = :BrchCode and
     C+ AFCNUM = :CustNum and
     C+ AFCCY = :Currency and
     C+ AFACOD = :AccntCode and
     C+ AFACSQ = :AccntSeq and
     C+ AFDATE = :IndFCastDat
     C/end-exec
 
      ** Update the Available Balance for other forward dates
     C                   EXSR      SRForw
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************                     MD023692
      /EJECT                                                                                MD023692
      *****************************************************************                     MD023692
      *                                                               *                     MD023692
      *  SRPrev - Retrieve the previous Available balance record      *                     MD023692
      *                                                               *                     MD023692
      *****************************************************************                     MD023692
     C     SRPrev        BEGSR                                                              MD023692
                                                                                            MD023692
      ** Set file pointer to first record of GLFOAVTD                                       MD023692
                                                                                            MD023692
     C/exec SQL                                                                             MD023692
     C+ declare LIST4 cursor for                                                            MD023692
     C+ select * from GLFOAVTD                                                              MD023692
     C+ where AFBRCA = :BrchCode and                                                        MD023692
     C+ AFCNUM = :CustNum and                                                               MD023692
     C+ AFCCY = :Currency and                                                               MD023692
     C+ AFACOD = :AccntCode and                                                             MD023692
     C+ AFACSQ = :AccntSeq                                                                  MD023692
     C+ order by                                                                            MD023692
     C+       AFDATE                                                                        MD023692
     C/end-exec                                                                             MD023692
                                                                                            MD023692
     C/exec SQL                                                                             MD023692
     C+ open LIST4                                                                          MD023692
     C/end-exec                                                                             MD023692
                                                                                            MD023692
      ** Handle SQL Error (If not %EOF)                                                     MD023692
                                                                                            MD023692
     C                   IF        SQLCOD < 0                                               MD023692
                                                                                            MD023692
     C     *LOCK         IN        LDA                                                      MD023692
     C                   EVAL      DBASE = 5                                                MD023692
     C                   EVAL      DBFILE = 'SQL STM'                                       MD023692
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                             MD023692
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)                   MD023692
     C                   OUT       LDA                                                      MD023692
     C                   EXSR      *PSSR                                                    MD023692
                                                                                            MD023692
     C                   ENDIF                                                              MD023692
                                                                                            MD023692
     C/exec SQL                                                                             MD023692
     C+ fetch next                                                                          MD023692
     C+ from LIST4                                                                          MD023692
     C+ into: FOAVT                                                                         MD023692
     C/end-exec                                                                             MD023692
                                                                                            MD023692
      ** Read Total Forecast Table until Forecast date  IndFCastDat                         MD023692
                                                                                            MD023692
     C                   Z-ADD     0             PRFAVAIL                                   MD023692
                                                                                            MD023692
     C                   DOW       SQLCode <> 100 and AFDATE <= IndFCastDat                 MD023692
                                                                                            MD023692
     C                   Z-ADD     AFAVAIL       PRFAVAIL                                   MD023692
                                                                                            MD023692
     C/exec SQL                                                                             MD023692
     C+ fetch next                                                                          MD023692
     C+ from LIST4                                                                          MD023692
     C+ into: FOAVT                                                                         MD023692
     C/end-exec                                                                             MD023692
                                                                                            MD023692
     C                   ENDDO                                                              MD023692
                                                                                            MD023692
     C/exec SQL                                                                             MD023692
     C+ close LIST4                                                                         MD023692
     C/end-exec                                                                             MD023692
                                                                                            MD023692
     C                   ENDSR                                                              MD023692
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRForw - Update the Available Bal. for other Forward Dates   *
      *                                                               *
      *****************************************************************
     C     SRForw        BEGSR
 
      ** Set file pointer to first record of GLFOAVTD
 
     C/exec SQL
     C+ declare LIST3 cursor for
     C+ select * from GLFOAVTD
     C+ where AFBRCA = :BrchCode and
     C+ AFCNUM = :CustNum and
     C+ AFCCY = :Currency and
     C+ AFACOD = :AccntCode and
     C+ AFACSQ = :AccntSeq
     C+ order by
     C+       AFDATE
     C/end-exec
 
     C/exec SQL
     C+ open LIST3
     C/end-exec
 
      ** Handle SQL Error (If not %EOF)
 
     C                   IF        SQLCOD < 0
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C/exec SQL
     C+ fetch next
     C+ from LIST3
     C+ into: FOAVT
     C/end-exec
 
      ** Read Total Forecast Table until end of file
 
     C                   DOW       SQLCode <> 100
 
     C                   IF        AFDATE > IndFCastDat
 
     C                   EVAL      WAFDATE = *ZEROS
     C                   EVAL      WAFDATE = AFDATE
     C                   EVAL      WAFAVAIL = *ZEROS
     C                   EVAL      WAFAVAIL = AFAVAIL + TOTAM
 
      ** Update Forecast Available Amount
 
     C/exec SQL
     C+ update GLFOAVTD set AFAVAIL = :WAFAVAIL
     C+ where AFBRCA = :BrchCode and
     C+ AFCNUM = :CustNum and
     C+ AFCCY = :Currency and
     C+ AFACOD = :AccntCode and
     C+ AFACSQ = :AccntSeq and
     C+ AFDATE = :WAFDATE
     C/end-exec
 
     C                   ENDIF
 
     C/exec SQL
     C+ fetch next
     C+ from LIST3
     C+ into: FOAVT
     C/end-exec
 
     C                   ENDDO
 
     C/exec SQL
     C+ close LIST3
     C/end-exec
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConvert - Convert Forecast Amount to Account Currency      *
      *                                                               *
      *****************************************************************
     C     SRConvert     BEGSR
 
      ** Retrieve currency details for FROM currency (Forecast Currency)
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      FCastCCY      PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = FCastCCY
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 10
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WFrXrate = A6SPRT
     C                   EVAL      WFrMDIn  = A6MDIN
     C                   EVAL      WFrDecPlace = A6NBDP
     C                   ENDIF
 
      ** Retrieve currency details for TO currency (Account Currency)
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      Currency      PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = Currency
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 11
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WToXrate = A6SPRT                                        MD024013
     C                   EVAL      WToMDIn  = A6MDIN                                        MD024013
     C                   EVAL      WToDecPlace = A6NBDP
     C                   ENDIF
 
      *                                                                                     MD024013
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
                                                                                            MD024013
      ** Convert Forecast Amount
 
     C                   CALL      'ZCONVZ1'
     C                   PARM      FCastAmt      PAmnt
     C**********         PARM      WFrXRate      PFrXRate                                   MD024013
     C**********         PARM      WFrMDIn       PFrMDIn                                    MD024013
     C                   PARM                    Zexch                                      MD024013
     C                   PARM                    Zmd                                        MD024013
     C                   PARM      FCastCCY      PFrCCY
     C                   PARM      Currency      PToCCY
     C                   PARM      WFrDecPlace   PFrDecPlace
     C                   PARM      WToDecPlace   PToDecPlace
     C                   PARM                    POutAmt
 
     C                   EVAL      WConvFAmt = POutAmt
 
      ** Convert Original Forecast Amount
 
     C                   CALL      'ZCONVZ1'
     C                   PARM      OFCastAmt     PAmnt
     C**********         PARM      WFrXRate      PFrXRate                                   MD024013
     C**********         PARM      WFrMDIn       PFrMDIn                                    MD024013
     C                   PARM                    Zexch                                      MD024013
     C                   PARM                    Zmd                                        MD024013
     C                   PARM      FCastCCY      PFrCCY
     C                   PARM      Currency      PToCCY
     C                   PARM      WFrDecPlace   PFrDecPlace
     C                   PARM      WToDecPlace   PToDecPlace
     C                   PARM                    POutAmt
 
     C                   EVAL      WConvOFAmt = POutAmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetFcltyDtl - Get Facility Details                         *
      *                                                               *
      *****************************************************************
     C     SRGetFcltyDtl BEGSR
 
     C                   MOVE      *Blanks       WFCCUS
     C                   MOVE      *Zeros        WFACT
     C                   MOVE      *Zeros        WFCNO
     C                   MOVE      CustNum       @CUST             6
     C                   MOVE      Currency      @CCY              3
     C                   MOVE      AccntCode     @ACCD            10
     C                   MOVE      AccntSeq      @ACSN             2
     C                   MOVE      BrchCode      @BRCA             3
 
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      *BLANKS       @ACNO            10
     C                   PARM                    @CUST
     C                   PARM                    @CCY
     C                   PARM                    @ACCD
     C                   PARM                    @ACSN
     C                   PARM                    @BRCA
     C     SDACCT        PARM      SDACCT        DSSDY
 
     C     PRTCD         IFEQ      *BLANKS
     C                   EVAL      WFCCUS = A_FCCU
     C                   EVAL      WFACT = A_FACT
     C                   EVAL      WFCNO = A_FCNO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *InzSr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    InParm
 
      ** Set off program indicators
 
     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
      ** Access Bank details
      **   Retrieve Run day number
 
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
 
      * Retrieve the system value
 
     C                   EVAL      ProcMode = 'ForecastIncUnmatched'
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
 
     C                   EVAL      WFIUPB = SVAL1
 
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
     C                   EVAL      PRTCD = '*ERROR'
 
     C                   RETURN
 
     C                   ENDSR
