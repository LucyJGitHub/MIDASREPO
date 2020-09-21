     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Update Nostro Group Totals (Update Pgm)')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL009071 - Nostro Group Total Update                         *
      *                                                               *
      *  Function:  This program will update the Nostro Group Total   *
      *             in GLFRBLTD.                                      *
      *                                                               *
      *  Called By: GLC009061 and GLC009062                           *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD028029           Date 07Jul14               *
      *                 MD027684A          Date 26Jun14               *
      *                 MD027684           Date 24Jun14               *
      *                 MD027292           Date 06Jun14               *
      *                 MD027208C          Date 05Jun14               *
      *                 MD027208B          Date 03Jun14               *
      *                 MD027273           Date 30May14               *
      *                 MD027208A          Date 30May14               *
      *                 MD027224           Date 28May14               *
      *                 MD027208           Date 27May14               *
      *                 MD026872           Date 12May14               *
      *                 CGL155   *Create   Date 24Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD028029 - Group total balance updated with real time posting*
      *             for new account.                                  *
      *  MD027684A - Incorrect amount shown in group total balance.   *
      *  MD027684 - Incorrect amount shown in group total balance.    *
      *  MD027292 - Difference of 0.01 when converting amounts        *
      *             and amend retrieval of CLBL for AcctBalance       *
      *  MD027208C - No a/c balance when not in PRONO or RSACMTPD     *
      *  MD027208B - Recalculate when GLRTNOTD is updated             *
      *  MD027273 - Only subtract CLBL for the 1st date, the run date *
      *  MD027208A - Only add up RT postings for the run date         *
      *  MD027224 - Use Total forecast instead of o/s forecast in     *
      *             calculation of Nostro Group Totals                *
      *  MD027208 - RT postings not included in Nostro Group Totals   *
      *  MD026872 - System generated dump                             *
      *  CGL155 - Forecast Group Limits                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         Error Indicator                                 *
      *    60         End-of-File Indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  Main routine                                                 *
      *  *INZSR         - Initialise                                  *
      *  *PSSR          - Error handling subroutine                   *
      *  SrACCNTAB      - Process ACCNTAB record                      *
      *  SrPRONOPN      - Process PRONOPN record                      *
      *  SrSDNOSTPD     - Process SDNOSTPD record                     *
      *  SrSDCURRPD     - Process SDCURRPD record                     *
      *  SrGLTNOSTD     - Process GLTNOSTD record                     *
      *  SrGLFORTTD     - Process GLFORTTD record                     *                     MD027224
      *  SrSDNGLHTD     - Process SDNGLHTD record                     *
      *  SrRSACMTPD     - Process RSACMTPD record                     *
      *  SrGLRTNOTD     - Process GLRTNOTD record                     *                    MD027208B
      *  SrUpdate       - Update GLFRBLTD                             *
      *  SrPronoBal     - Get totals of PRONOPN                       *
      *  SrTnostBal     - Get totals of GLTNOSTD                      *
      *  SrForttBal     - Get totals of GLFORTTD                      *                     MD027224
      *  SrCalcTot      - Calculate group total                       *
      *  SrLccyDat      - Get Limit currency dates                    *
      *  SrDelGTot      - Delete group from GLFRBLTD                  *
      *  SrReBuild      - Rebuild whole of GLFRBLTD                   *
      *  SrConvert      - Convert amounts                             *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D AccBeforeImg  E DS                  EXTNAME(ACCNTAB) PREFIX(BA)
      **  External DS for Before Image ACCNTAB

     D AccAfterImg   E DS                  EXTNAME(ACCNTAB) PREFIX(AA)
      **  External DS for After Image ACCNTAB

     D ProBeforeImg  E DS                  EXTNAME(PRONOPN) PREFIX(BP)
      **  External DS for Before Image PRONOPN

     D ProAfterImg   E DS                  EXTNAME(PRONOPN) PREFIX(AP)
      **  External DS for After Image PRONOPN

     D NosBeforeImg  E DS                  EXTNAME(SDNOSTPD) PREFIX(BN)
      **  External DS for Before Image SDNOSTPD

     D NosAfterImg   E DS                  EXTNAME(SDNOSTPD) PREFIX(AN)
      **  External DS for After Image SDNOSTPD

     D CurBeforeImg  E DS                  EXTNAME(SDCURRPD) PREFIX(BC)
      **  External DS for Before Image SDCURRPD

     D CurAfterImg   E DS                  EXTNAME(SDCURRPD) PREFIX(AC)
      **  External DS for After Image SDCURRPD

     D TNoBeforeImg  E DS                  EXTNAME(GLTNOSTD) PREFIX(BT)
      **  External DS for Before Image GLTNOSTD

     D TnoAfterImg   E DS                  EXTNAME(GLTNOSTD) PREFIX(AT)
      **  External DS for After Image GLTNOSTD

     D GLHBeforeImg  E DS                  EXTNAME(SDNGLHTD) PREFIX(BH)
      **  External DS for Before Image SDNGLHTD

     D GLHAfterImg   E DS                  EXTNAME(SDNGLHTD) PREFIX(AH)
      **  External DS for After Image SDNGLHTD

     D RsaBeforeImg  E DS                  EXTNAME(RSACMTPD) PREFIX(BR)
      **  External DS for Before Image RSACMTPD

     D RsaAfterImg   E DS                  EXTNAME(RSACMTPD) PREFIX(AR)
      **  External DS for After Image RSACMTPD
                                                                                            MD027224
     D FoTBeforeImg  E DS                  EXTNAME(GLFORTTD) PREFIX(BF)                     MD027224
      **  External DS for Before Image GLFORTTD                                             MD027224
                                                                                            MD027224
     D FoTAfterImg   E DS                  EXTNAME(GLFORTTD) PREFIX(AF)                     MD027224
      **  External DS for After Image GLFORTTD                                              MD027224
                                                                                           MD027208B
     D RTpBeforeImg  E DS                  EXTNAME(GLRTNOTD) PREFIX(BZ)                    MD027208B
      **  External DS for Before Image GLRTNOTD                                            MD027208B
                                                                                           MD027208B
     D RTpAfterImg   E DS                  EXTNAME(GLRTNOTD) PREFIX(AZ)                    MD027208B
      **  External DS for After Image GLRTNOTD                                             MD027208B

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External data structures for Currency Details

     D GLPRON        E DS                  EXTNAME(GLPRONOW0)
      ***  External data structures for PRONOPN

     D SDSTAT        E DS                  EXTNAME(SDSTAT)
      ** Data Area for Standing Data Details

     D NGLD          E DS                  EXTNAME(SDNGLDTD)
      ** External DS for SDNGLDTD details

     D DSZN          E DS                  EXTNAME(GPZONEPD)
      ** External DS for GPZONEPD details

     D NGLH          E DS                  EXTNAME(SDNGLHTD)
      ** External DS for SDNGLHTD details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access programs, long data structure

     D/COPY ZACPYSRC,PSDS
      ** The Following /COPY Line Includes All The Defined Fields In
      ** The PSDS.  They Have Meaningful Names, Prefixed By 'PS'.

      ** +--------------------------------------+
      ** ¦ Arrays AND Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D FGLData         DS

      ** Event Type
     D  WEventType             1     20
     D  WTrigEvent            21     21

      ** Event Detail
     D  WDetail               22   4021
     D  WAfter                22   2021
     D  WBefore             2022   4021

     D LISTB_DS        DS
     D  WGrpc                  1     10
     D  WCcy                  11     13
     D  WNosn                 14     15
     D**BalAdj                16     23P 0                                                  MD027292
     D**Bal00Adj              24     31P 0                                                  MD027292
     D**BalAdj                16     23P 3                                        MD027292 MD027684A
     D**Bal00Adj              24     31P 3                                        MD027292 MD027684A
     D  BalAdj                16     23P 0                                                 MD027684A
     D  Bal00Adj              24     31P 0                                                 MD027684A
     D  WPnd0                 32     34P 0
     D**Bal01Adj              35     42P 0                                                  MD027292
     D**Bal01Adj              35     42P 3                                        MD027292 MD027684A
     D  Bal01Adj              35     42P 0                                                 MD027684A
     D  WPnd1                 43     45P 0
     D**Bal02Adj              46     53P 0                                                  MD027292
     D**Bal02Adj              46     53P 3                                        MD027292 MD027684A
     D  Bal02Adj              46     53P 0                                                 MD027684A
     D  WPnd2                 54     56P 0
     D**Bal03Adj              57     64P 0                                                  MD027292
     D**Bal03Adj              57     64P 3                                        MD027292 MD027684A
     D  Bal03Adj              57     64P 0                                                 MD027684A
     D  WPnd3                 65     67P 0
     D**Bal04Adj              68     75P 0                                                  MD027292
     D**Bal04Adj              68     75P 3                                        MD027292 MD027684A
     D  Bal04Adj              68     75P 0                                                 MD027684A
     D  WPnd4                 76     78P 0
     D**BalAdjB               79     86P 0                                                  MD027292
     D**BalAdjB               79     86P 3                                        MD027292 MD027684A
     D  BalAdjB               79     86P 0                                                 MD027684A

     D LISTD_DS        DS
     D  WDCcy                  1      3
     D  WDNosn                 4      5
     D**DBal00Adj              6     13P 0                                                  MD027292
     D**DBal00Adj              6     13P 3                                        MD027292 MD027684A
     D  WNCDat0               14     16P 0
     D**DBal01Adj             17     24P 0                                                  MD027292
     D**DBal01Adj             17     24P 3                                        MD027292 MD027684A
     D  WNCDat1               25     27P 0
     D**DBal02Adj             28     35P 0                                                  MD027292
     D**DBal02Adj             28     35P 3                                        MD027292 MD027684A
     D  WNCDat2               36     38P 0
     D**DBal03Adj             39     46P 0                                                  MD027292
     D**DBal03Adj             39     46P 3                                        MD027292 MD027684A
     D  WNCDat3               47     49P 0
     D**DBal04Adj             50     57P 0                                                  MD027292
     D**DBal04Adj             50     57P 3                                        MD027292 MD027684A
     D  WNCDat4               58     60P 0
     D  DBal00Adj              6     13P 0                                                 MD027684A
     D  DBal01Adj             17     24P 0                                                 MD027684A
     D  DBal02Adj             28     35P 0                                                 MD027684A
     D  DBal03Adj             39     46P 0                                                 MD027684A
     D  DBal04Adj             50     57P 0                                                 MD027684A

     D LISTE_DS        DS
     D  RGrpc                  1     10
     D  RCcy                  11     13
     D  RNosn                 14     15
     D**RBalAdj               16     23P 0                                                  MD027292
     D**RBal00Adj             24     30P 0                                                  MD027292
     D**RBalAdj               16     23P 3                                        MD027292 MD027684A
     D**RBal00Adj             24     30P 3                                        MD027292 MD027684A
     D  RBalAdj               16     23P 0                                                 MD027684A
     D  RBal00Adj             24     30P 0                                                 MD027684A
     D  WVudt                 31     33P 0
     D**RBalAdjB              34     41P 0                                                  MD027292
     D**RBalAdjB              34     41P 3                                        MD027292 MD027684A
     D  RBalAdjB              34     41P 0                                                 MD027684A
                                                                                            MD027208
     D LISTG_DS        DS                                                                   MD027208
     D  TGrpc                  1     10                                                     MD027208
     D  TCcy                  11     13                                                     MD027208
     D  TNosn                 14     15                                                     MD027208
     D**TBal00Adj             16     24P 0                                         MD027208 MD027292
     D**TVudt                 25     27P 0                                         MD027208 MD027292
     D**TBal00Adj             16     30  3                                        MD027292 MD027684A
     D  TBal00Adj             16     30  0                                                 MD027684A
     D  TVudt                 31     35  0                                                  MD027292
                                                                                            MD027224
     D LISTH_DS        DS                                                                   MD027224
     D  FGrpc                  1     10                                                     MD027224
     D  FCcy                  11     13                                                     MD027224
     D  FNosn                 14     15                                                     MD027224
     D**FBal00Adj             16     24P 0                                         MD027224 MD027292
     D**FDate                 25     27P 0                                         MD027224 MD027292
     D**FBal00Adj             16     23P 3                                        MD027292 MD027684A
     D  FBal00Adj             16     23P 0                                                 MD027684A
     D  FDate                 24     26P 0                                                  MD027292
                                                                                           MD027208C
     D LISTI_DS        DS                                                                  MD027208C
     D  IGrpc                  1     10                                                    MD027208C
     D  ICcy                  11     13                                                    MD027208C
     D  INosn                 14     15                                                    MD027208C
     D**IBalClAdj             16     23P 0                                                 MD027208C
     D**IBal00Adj             24     31P 0                                                 MD027208C
     D**IBalClAdj             16     23P 3                              MD027208C MD027292 MD027684A
     D**IBal00Adj             24     31P 3                              MD027208C MD027292 MD027684A
     D  IBalClAdj             16     23P 0                                                 MD027684A
     D  IBal00Adj             24     31P 0                                                 MD027684A

     DMPHAS            DS             1
     DPHASE1                   1      1

     D GLACNT        E DS                  EXTNAME(ACCNTAB) PREFIX(Acct)
      ** Account details

     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ** Nostro details

     D TNOS          E DS                  EXTNAME(GLTNOSTD)
      ** Total Outstanding Forecasts
                                                                                            MD027224
     D FORT          E DS                  EXTNAME(GLFORTTD)                                MD027224
      ** Total Forecasts                                                                    MD027224

     D LDA             DS           256
      ** Local data area for database error details

     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBTXT                184    256

     D*PronoBalance    S             15P 0 DIM(5)                                           MD027292
     D*PronoBalanceL   S             15P 0 DIM(5)                                           MD027292
     D*AcctBalance     S             15P 0 DIM(5)                                           MD027292
     D*AcctBalanceL    S             15P 0 DIM(5)                                           MD027292
     D*OForBalance     S             15P 0 DIM(5)                                           MD027292
     D*OForBalanceL    S             15P 0 DIM(5)                                           MD027292
     D*TotBalance      S             15P 0 DIM(5)                                           MD027292
     D*TotBalanceL     S             15P 0 DIM(5)                                           MD027292
     D*RTimBalance     S             15P 0 DIM(5)                                  MD027208 MD027292
     D*RTimBalanceL    S             15P 0 DIM(5)                                  MD027208 MD027292
     D*ForTBalance     S             15P 0 DIM(5)                                  MD027224 MD027292
     D*ForTBalanceL    S             15P 0 DIM(5)                                  MD027224 MD027292
     D*PronoBalance    S             15P 3 DIM(5)                                 MD027292 MD027684A
     D*PronoBalanceL   S             15P 3 DIM(5)                                 MD027292 MD027684A
     D*AcctBalance     S             15P 3 DIM(5)                                 MD027292 MD027684A
     D*AcctBalanceL    S             15P 3 DIM(5)                                 MD027292 MD027684A
     D*OForBalance     S             15P 3 DIM(5)                                 MD027292 MD027684A
     D*OForBalanceL    S             15P 3 DIM(5)                                 MD027292 MD027684A
     D*TotBalance      S             15P 3 DIM(5)                                 MD027292 MD027684A
     D*TotBalanceL     S             15P 3 DIM(5)                                 MD027292 MD027684A
     D*RTimBalance     S             15S 3 DIM(5)                                 MD027292 MD027684A
     D*RTimBalanceL    S             15S 3 DIM(5)                                 MD027292 MD027684A
     D*ForTBalance     S             15P 3 DIM(5)                                 MD027292 MD027684A
     D*ForTBalanceL    S             15P 3 DIM(5)                                 MD027292 MD027684A
     D PronoBalance    S             15P 0 DIM(5)                                          MD027684A
     D PronoBalanceL   S             15P 0 DIM(5)                                          MD027684A
     D AcctBalance     S             15P 0 DIM(5)                                          MD027684A
     D AcctBalanceL    S             15P 0 DIM(5)                                          MD027684A
     D TotBalance      S             15P 0 DIM(5)                                          MD027684A
     D TotBalanceL     S             15P 0 DIM(5)                                          MD027684A
     D RTimBalance     S             15S 0 DIM(5)                                          MD027684A
     D RTimBalanceL    S             15S 0 DIM(5)                                          MD027684A
     D ForTBalance     S             15P 0 DIM(5)                                          MD027684A
     D ForTBalanceL    S             15P 0 DIM(5)                                          MD027684A

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRtCd           S              7A
     D POptn           S              7A
     D PAcno           S             10A
     D PCusn           S              6A
     D PCurr           S              3A
     D PACod           S             10A
     D PASeq           S              2A
     D PBrch           S              3A
     D PSard           S              6A
     D PNonb           S              2A
     D PCssn           S             10A
     D PPNoi           S              1A
     D PGrpc           S             10A
     D PLCcy           S              3A
     D PDate           S              5  0
     D PLBal           S             15  0
     D PFBal           S             15  0
     D PPBal           S             15  0
     D PTBal           S             15  0
     D PZone           S             10A
     D PRBal           S             15  0                                                MD027208
     D*PLBalS          DS                                                         MD027684 MD027684A
     D**PLBalS0                1     12  0                                        MD027684 MD027684A
     D**PLBalS1                1     13  1                                        MD027684 MD027684A
     D**PLBalS2                1     14  2                                        MD027684 MD027684A
     D**PLBalS3                1     15  3                                        MD027684 MD027684A
     D*PFBalS          DS                                                         MD027684 MD027684A
     D**PFBalS0                1     12  0                                        MD027684 MD027684A
     D**PFBalS1                1     13  1                                        MD027684 MD027684A
     D**PFBalS2                1     14  2                                        MD027684 MD027684A
     D**PFBalS3                1     15  3                                        MD027684 MD027684A
     D*PPBalS          DS                                                         MD027684 MD027684A
     D**PPBalS0                1     12  0                                        MD027684 MD027684A
     D**PPBalS1                1     13  1                                        MD027684 MD027684A
     D**PPBalS2                1     14  2                                        MD027684 MD027684A
     D**PPBalS3                1     15  3                                        MD027684 MD027684A
     D*PTBalS          DS                                                         MD027684 MD027684A
     D**PTBalS0                1     12  0                                        MD027684 MD027684A
     D**PTBalS1                1     13  1                                        MD027684 MD027684A
     D**PTBalS2                1     14  2                                        MD027684 MD027684A
     D**PTBalS3                1     15  3                                        MD027684 MD027684A
     D*PRBalS          DS                                                         MD027684 MD027684A
     D**PRBalS0                1     12  0                                        MD027684 MD027684A
     D**PRBalS1                1     13  1                                        MD027684 MD027684A
     D**PRBalS2                1     14  2                                        MD027684 MD027684A
     D**PRBalS3                1     15  3                                        MD027684 MD027684A

     D PrvGrpc         S             10A

     D LDat0           S              5P 0 INZ(0)
     D LDat1           S              5P 0 INZ(0)
     D LDat2           S              5P 0 INZ(0)
     D LDat3           S              5P 0 INZ(0)
     D LDat4           S              5P 0 INZ(0)

     D FromCcy         S              3A
     D ToCcy           S              3A
     D FromAmt         S             15  0 INZ(0)
     D ToAmt           S             15  0 INZ(0)
     D WRate           S             13  8 INZ(0)
     D WMdin           S              1A
     D WMdin1          S              1A
     D WMdin2          S              1A
     D XMdin1          S              1A
     D XMdin2          S              1A
     D WNbdp1          S              1  0 INZ(0)
     D WNbdp2          S              1  0 INZ(0)
     D WRate1          S             13  8 INZ(0)
     D WRate2          S             13  8 INZ(0)
     D XRate1          S             13  8 INZ(0)
     D XRate2          S             13  8 INZ(0)
     D Given           S              1A

     D GRPC            S             10    DIM(9999)

     D ZdayNo          S              5P 0 INZ(0)
     D ZDyNbr          S              5P 0 INZ(0)
     D ZNrDys          S              2P 0 INZ(0)
     D ZCcy            S              3A
     D ZLoc            S              3A   INZ(*Blanks)

     D WRun            S              1A
     D WUpdate         S              1A   INZ(*Blanks)
     D Returncode      S              6A
     D Idx             S              4S 0

      *****************************************************************
      /EJECT
      *****************************************************************
      *  MAIN - Processing                                            *
      *****************************************************************

     C/exec SQL
     C+ set option commit = *CHG
     C/end-exec

     C     FGLData       Ifeq      *Blanks

     C     Phase1        Ifne      'A'
     C     Phase1        andne     'G'
     C                   Exsr      SrReBuild
     C                   Endif

     C                   Else

     C                   SELECT

     C                   WHEN      WEventType = 'MNT_ACCNTAB'
     C                   EXSR      SrACCNTAB

     C                   WHEN      WEventType = 'MNT_PRONOPN'
     C                   EXSR      SrPRONOPN

     C                   WHEN      WEventType = 'MNT_SDNOSTPD'
     C                   EXSR      SrSDNOSTPD

     C                   WHEN      WEventType = 'MNT_SDCURRPD'
     C                   EXSR      SrSDCURRPD

     C********           WHEN      WEventType = 'MNT_GLTNOSTD'                              MD027224
     C********           EXSR      SrGLTNOSTD                                               MD027224
     C                   WHEN      WEventType = 'MNT_GLFORTTD'                              MD027224
     C                   EXSR      SrGLFORTTD                                               MD027224

     C                   WHEN      WEventType = 'MNT_SDNGLHTD'
     C                   EXSR      SrSDNGLHTD

     C                   WHEN      WEventType = 'MNT_RSACMTPD_BEFORE' or
     C                             WEventType = 'MNT_RSACMTPD_AFTER' or
     C                             WEventType = 'MNT_RSACMTPD_BOTH'
     C                   EXSR      SrRSACMTPD
                                                                                           MD027208B
     C                   WHEN      WEventType = 'MNT_GLRTNOTD'                             MD027208B
     C                   EXSR      SrGLRTNOTD                                              MD027208B

     C                   Endsl

     C                   Endif

     C                   IF        WUpdate = 'Y'
     C                   Commit
     C                   ENDIF

      ** Terminate program

     C                   Eval      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrACCNTAB   - Process ACCNTAB changes                         *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrACCNTAB     BEGSR

     C                   EVAL      AccBeforeImg = WBefore
     C                   EVAL      AccAfterImg = WAfter

      ***Recalculate*Group*Total*if*LDBL*has*changed                                       MD027208
      ** Recalculate Group Total if CLBL has changed                                       MD027208

     C*****BALdbl        Ifne      AALdbl                                                  MD027208
     C     BACLBL        Ifne      AACLBL                                                  MD027208

      ** Retrieve Nostro Code of the account

     C                   EVAL      PCusn = AACnum
     C                   EVAL      PCurr = AACcy
     C                   EVAL      PBrch = AABrca
     C                   MOVE(P)   AAAcod        PACod
     C                   MOVE(P)   AAAcsq        PASeq

     C                   Call      'AONOSTR0'    PAoNost
     C**********         If        PRtCd <> *BLANKS                                         MD026872
     C******Lock         In        LDA                                                      MD026872
     C**********         eval      DBPGM = 'GL009071'                                       MD026872
     C**********         eval      DBFILE = 'SDNOSTPD'                                      MD026872
     C**********         eval      DBKEY = PCusn + PCurr + PACod +                          MD026872
     C**********                           PASeq + PBrch                                    MD026872
     C**********         eval      DBASE = 2                                                MD026872
     C**********         Out       LDA                                                      MD026872
     C**********         exsr      *PSSR                                                    MD026872
     C**********         Endif                                                              MD026872

      ** Check if Nostro code belongs to a Nostro Group and retrieve Limit Ccy if so

     C                   IF        PRTCD = *BLANKS                                          MD026872
     C/exec SQL
     C+ select * into :NGLD from SDNGLDTD
     C+ where
     C+       NCNCCY = :PCurr
     C+   and NCNOSC = :A7NONB
     C+   and NCRECI = 'D'
     C/end-exec

     C                   If        SQLCODE = 0
     C                   eval      PGrpc = NCGRPC

     C/exec SQL
     C+ select * into :NGLH from SDNGLHTD
     C+ where
     C+       NGGRPC = :PGrpc
     C+   and NGRECI = 'D'
     C/end-exec

     C                   If        SQLCODE = 0
     C                   eval      PLCcy = NGLCcy
     C                   Exsr      SrLCcyDat
     C                   Endif

     C                   Exsr      SrPronoBal
     C********           Exsr      SrTNostBal                                               MD027224
     C                   Exsr      SrFortTBal                                               MD027224
     C                   Exsr      SrCalcTot

     C                   EXSR      SrUpdate

     C                   Endif
     C                   Endif

     C                   ENDIF                                                              MD026872

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPRONOPN   - Process PRONOPN changes                         *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrPRONOPN     BEGSR

     C                   EVAL      ProBeforeImg = WBefore
     C                   EVAL      ProAfterImg = WAfter

      ** Check if Nostro code belongs to a Nostro Group and retrieve Limit Ccy if so

     C/exec SQL
     C+ select * into :NGLD from SDNGLDTD
     C+ where
     C+       NCNCcy = :APCcy
     C+   and NCNOSC = :APNosn
     C+   and NCRECI = 'D'
     C/end-exec

     C                   If        SQLCODE = 0
     C                   eval      PGrpc = NCGRPC

     C/exec SQL
     C+ select * into :NGLH from SDNGLHTD
     C+ where
     C+       NGGRPC = :PGrpc
     C+   and NGRECI = 'D'
     C/end-exec

     C                   If        SQLCODE = 0
     C                   eval      PLCcy = NGLCcy
     C                   Exsr      SrLCcyDat
     C                   Endif


     C                   Exsr      SrPronoBal
     C********           Exsr      SrTNostBal                                               MD027224
     C                   Exsr      SrFortTBal                                               MD027224
     C                   Exsr      SrCalcTot

     C                   EXSR      SrUpdate

     C                   Endif

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSDNOSTPD  - Process SDNOSTPD changes                        *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrSDNOSTPD    BEGSR

     C                   EVAL      NosBeforeImg = WBefore
     C                   EVAL      NosAfterImg = WAfter

      ** Check if Nostro code belongs to a Nostro Group and retrieve Limit Ccy if so

     C/exec SQL
     C+ select * into :NGLD from SDNGLDTD
     C+ where
     C+       NCNCcy = :ANA7Cycd
     C+   and NCNOSC = :ANA7Nonb
     C+   and NCRECI = 'D'
     C/end-exec

     C                   If        SQLCODE = 0
     C                   eval      PGrpc = NCGRPC

     C/exec SQL
     C+ select * into :NGLH from SDNGLHTD
     C+ where
     C+       NGGRPC = :PGrpc
     C+   and NGRECI = 'D'
     C/end-exec

     C                   If        SQLCODE = 0
     C                   eval      PLCcy = NGLCcy
     C                   Exsr      SrLCcyDat
     C                   Endif

     C                   Exsr      SrPronoBal
     C********           Exsr      SrTNostBal                                               MD027224
     C                   Exsr      SrFortTBal                                               MD027224
     C                   Exsr      SrCalcTot

     C                   EXSR      SrUpdate

     C                   Endif

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSDCURRPD  - Process SDCURRPD changes                        *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrSDCURRPD    BEGSR

     C                   movel     *Blanks       GRPC

     C                   EVAL      CurBeforeImg = WBefore
     C                   EVAL      CurAfterImg = WAfter

      ** Recalculate Groups affected Totals if A6SPRT has changed

     C     BCA6Sprt      Ifne      ACA6Sprt

      ** Determine all those Group codes affected by the Currency being changed

     C/exec SQL
     C+ declare LISTA cursor for
     C+ select * from SDNGLDTD
     C+ where
     C+       NCNCCY = :ACA6CYCD
     C+   and NCRECI = 'D'
     C/end-exec

     C/exec SQL
     C+ open LISTA
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LISTA
     C+ into :NGLD
     C/end-exec

     C                   eval      PrvGrpc = *Blanks
     C                   eval      Idx = 0

     C                   DOW       SQLCode <> 100

     C     NCGRPC        Ifne      PrvGrpc
     C     NCGRPC        LOOKUP    GRPC                                   80
     C     *In80         Ifeq      *Off
     C                   add       1             Idx
     C                   movea     NCGRPC        Grpc(Idx)
     C                   Endif
     C                   Endif

     C                   eval      PrvGrpc = NCGRPC

     C/exec SQL
     C+ fetch next from LISTA
     C+ into :NGLD
     C/end-exec

     C                   ENDDO

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCode < 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ close LISTA
     C/end-exec

      ** Determine all those Group codes whose limit ccy is the currency being changed

     C/exec SQL
     C+ declare LISTF cursor for
     C+ select * from SDNGLHTD
     C+ where
     C+       NGLCCY = :ACA6CYCD
     C+   and NGRECI = 'D'
     C/end-exec

     C/exec SQL
     C+ open LISTF
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 15
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LISTF
     C+ into :NGLH
     C/end-exec

     C                   DOW       SQLCode <> 100

     C     NGGRPC        Ifne      PrvGrpc
     C     NGGRPC        LOOKUP    GRPC                                   80
     C     *In80         Ifeq      *Off
     C                   add       1             Idx
     C                   movea     NGGRPC        Grpc(Idx)
     C                   Endif
     C                   Endif

     C                   eval      PrvGrpc = NGGRPC

     C/exec SQL
     C+ fetch next from LISTF
     C+ into :NGLH
     C/end-exec

     C                   ENDDO

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCode < 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 18
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ close LISTF
     C/end-exec

     C     Idx           Ifgt      0

      ** Process all Group codes in array

     C                   z-add     1             Idx
     C                   eval      PGrpc = GRPC(Idx)

     C                   DOW       PGrpc <> *Blanks

     C/exec SQL
     C+ select * into :NGLH from SDNGLHTD
     C+ where
     C+       NGGRPC = :PGrpc
     C+   and NGRECI = 'D'
     C/end-exec

     C                   If        SQLCODE = 0
     C                   eval      PLCcy = NGLCcy
     C                   Exsr      SrLCcyDat
     C                   Endif

     C                   Exsr      SrPronoBal
     C********           Exsr      SrTNostBal                                               MD027224
     C                   Exsr      SrFortTBal                                               MD027224
     C                   Exsr      SrCalcTot

     C                   EXSR      SrUpdate

     C                   add       1             Idx
     C                   eval      PGrpc = GRPC(Idx)
     C                   Enddo
     C                   EndIf

     C                   EndIf

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGLTNOSTD  - Process GLTNOSTD changes                        *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrGLTNOSTD    BEGSR

     C                   EVAL      TnoBeforeImg = WBefore                                   MD027208
     C                   EVAL      TnoAfterImg = WAfter                                     MD027208

      ** Check if Nostro code belongs to a Nostro Group and retrieve Limit Ccy if so

     C/exec SQL
     C+ select * into :NGLD from SDNGLDTD
     C+ where
     C+       NCNCCY = :ATNCCYCD
     C+   and NCNOSC = :ATNCNONB
     C+   and NCRECI = 'D'
     C/end-exec

     C                   If        SQLCODE = 0
     C                   eval      PGrpc = NCGRPC

     C/exec SQL
     C+ select * into :NGLH from SDNGLHTD
     C+ where
     C+       NGGRPC = :PGrpc
     C+   and NGRECI = 'D'
     C/end-exec

     C                   If        SQLCODE = 0
     C                   eval      PLCcy = NGLCcy
     C                   Exsr      SrLCcyDat
     C                   Endif

     C                   Exsr      SrPronoBal
     C********           Exsr      SrTNostBal                                               MD027224
     C                   Exsr      SrFortTBal                                               MD027224
     C                   Exsr      SrCalcTot

     C                   EXSR      SrUpdate

     C                   Endif

     C                   Endsr
                                                                                            MD027224
      *****************************************************************                     MD027224
      /EJECT                                                                                MD027224
      *****************************************************************                     MD027224
      *                                                               *                     MD027224
      * SrGLFORTTD  - Process GLFORTTD changes                        *                     MD027224
      *                                                               *                     MD027224
      * Called by: Main routine                                       *                     MD027224
      *                                                               *                     MD027224
      * Calls: None                                                   *                     MD027224
      *                                                               *                     MD027224
      *****************************************************************                     MD027224
                                                                                            MD027224
     C     SrGLFORTTD    BEGSR                                                              MD027224
                                                                                            MD027224
     C                   EVAL      FoTBeforeImg = WBefore                                   MD027224
     C                   EVAL      FoTAfterImg = WAfter                                     MD027224
                                                                                            MD027224
      ** Check if Nostro code belongs to a Nostro Group and retrieve Limit Ccy if so        MD027224
                                                                                            MD027224
     C/exec SQL                                                                             MD027224
     C+ select * into :NGLD from SDNGLDTD                                                   MD027224
     C+ where                                                                               MD027224
     C+       NCNCCY = :AFTFCCY                                                             MD027224
     C+   and NCNOSC = :AFTFNOSC                                                            MD027224
     C+   and NCRECI = 'D'                                                                  MD027224
     C/end-exec                                                                             MD027224
                                                                                            MD027224
     C                   If        SQLCODE = 0                                              MD027224
     C                   eval      PGrpc = NCGRPC                                           MD027224
                                                                                            MD027224
     C/exec SQL                                                                             MD027224
     C+ select * into :NGLH from SDNGLHTD                                                   MD027224
     C+ where                                                                               MD027224
     C+       NGGRPC = :PGrpc                                                               MD027224
     C+   and NGRECI = 'D'                                                                  MD027224
     C/end-exec                                                                             MD027224
                                                                                            MD027224
     C                   If        SQLCODE = 0                                              MD027224
     C                   eval      PLCcy = NGLCcy                                           MD027224
     C                   Exsr      SrLCcyDat                                                MD027224
     C                   Endif                                                              MD027224
                                                                                            MD027224
     C                   Exsr      SrPronoBal                                               MD027224
     C                   Exsr      SrFortTBal                                               MD027224
     C                   Exsr      SrCalcTot                                                MD027224
                                                                                            MD027224
     C                   EXSR      SrUpdate                                                 MD027224
                                                                                            MD027224
     C                   Endif                                                              MD027224
                                                                                            MD027224
     C                   Endsr                                                              MD027224

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSDNGLHTD  - Process SDNGLHTD changes                        *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrSDNGLHTD    BEGSR

     C                   EVAL      GLhBeforeImg = WBefore
     C                   EVAL      GLhAfterImg = WAfter

     C                   If        BHNGRECI = 'D'
     C                             and AHNGRECI = '*'

     C                   eval      PGrpc = BHNGGRPC
     C                   exsr      SrDelGTot

     C                   else

     C                   eval      PGrpc = AHNGGRPC
     C                   eval      PLCcy = AHNGLCCY
     C                   Exsr      SrLCcyDat
     C                   Exsr      SrPronoBal
     C********           Exsr      SrTNostBal                                               MD027224
     C                   Exsr      SrFortTBal                                               MD027224
     C                   Exsr      SrCalcTot
     C                   Exsr      SrUpdate

     C                   Endif

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRSACMTPD  - Process RSACMTPD changes                        *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrRSACMTPD    BEGSR

     C                   EVAL      RsaBeforeImg = WBefore
     C                   EVAL      RsaAfterImg = WAfter

      ** Retrieve Nostro Code of the Before Image account

     C                   If        WEventType = 'MNT_RSACMTPD_BEFORE' or
     C                             WEventType = 'MNT_RSACMTPD_BOTH'

     C                   EVAL      PCusn = BRCusn
     C                   EVAL      PCurr = BRCcyd
     C                   EVAL      PBrch = BRBrca
     C                   MOVE(P)   BRAcde        PACod
     C                   MOVE(P)   BRAsnc        PASeq

     C                   Call      'AONOSTR0'    PAoNost
     C                   If        PRtCd <> *BLANKS
     C     *Lock         In        LDA
     C                   eval      DBPGM = 'GL009071'
     C                   eval      DBFILE = 'SDNOSTPD'
     C                   eval      DBKEY = PCusn + PCurr + PACod +
     C                                     PASeq + PBrch
     C                   eval      DBASE = 16
     C                   Out       LDA
     C                   exsr      *PSSR
     C                   Endif

      ** Check if Nostro code belongs to a Nostro Group and retrieve Limit Ccy if so

     C/exec SQL
     C+ select * into :NGLD from SDNGLDTD
     C+ where
     C+       NCNCCY = :PCurr
     C+   and NCNOSC = :A7NONB
     C+   and NCRECI = 'D'
     C/end-exec

     C                   If        SQLCODE = 0
     C                   eval      PGrpc = NCGRPC

     C/exec SQL
     C+ select * into :NGLH from SDNGLHTD
     C+ where
     C+       NGGRPC = :PGrpc
     C+   and NGRECI = 'D'
     C/end-exec

     C                   If        SQLCODE = 0
     C                   eval      PLCcy = NGLCcy
     C                   Exsr      SrLCcyDat
     C                   Endif

     C                   Exsr      SrPronoBal
     C********           Exsr      SrTNostBal                                               MD027224
     C                   Exsr      SrFortTBal                                               MD027224
     C                   Exsr      SrCalcTot

     C                   EXSR      SrUpdate

     C                   Endif
     C                   Endif

      ** Retrieve Nostro Code of the After Image account

     C                   If        WEventType = 'MNT_RSACMTPD_AFTER' or
     C                             WEventType = 'MNT_RSACMTPD_BOTH'

     C                   EVAL      PCusn = ARCusn
     C                   EVAL      PCurr = ARCcyd
     C                   EVAL      PBrch = ARBrca
     C                   MOVE(P)   ARAcde        PACod
     C                   MOVE(P)   ARAsnc        PASeq

     C                   Call      'AONOSTR0'    PAoNost
     C                   If        PRtCd <> *BLANKS
     C     *Lock         In        LDA
     C                   eval      DBPGM = 'GL009071'
     C                   eval      DBFILE = 'SDNOSTPD'
     C                   eval      DBKEY = PCusn + PCurr + PACod +
     C                                     PASeq + PBrch
     C                   eval      DBASE = 17
     C                   Out       LDA
     C                   exsr      *PSSR
     C                   Endif

      ** Check if Nostro code belongs to a Nostro Group and retrieve Limit Ccy if so

     C/exec SQL
     C+ select * into :NGLD from SDNGLDTD
     C+ where
     C+       NCNCCY = :PCurr
     C+   and NCNOSC = :A7NONB
     C+   and NCRECI = 'D'
     C/end-exec

     C                   If        SQLCODE = 0
     C                   eval      PGrpc = NCGRPC

     C/exec SQL
     C+ select * into :NGLH from SDNGLHTD
     C+ where
     C+       NGGRPC = :PGrpc
     C+   and NGRECI = 'D'
     C/end-exec

     C                   If        SQLCODE = 0
     C                   eval      PLCcy = NGLCcy
     C                   Exsr      SrLCcyDat
     C                   Endif

     C                   Exsr      SrPronoBal
     C********           Exsr      SrTNostBal                                               MD027224
     C                   Exsr      SrFortTBal                                               MD027224
     C                   Exsr      SrCalcTot

     C                   EXSR      SrUpdate

     C                   Endif
     C                   Endif

     C                   ENDSR
                                                                                           MD027208B
      *****************************************************************                    MD027208B
      /EJECT                                                                               MD027208B
      *****************************************************************                    MD027208B
      *                                                               *                    MD027208B
      * SrGLRTNOTD  - Process GLRTNOTD changes                        *                    MD027208B
      *                                                               *                    MD027208B
      * Called by: Main routine                                       *                    MD027208B
      *                                                               *                    MD027208B
      * Calls: None                                                   *                    MD027208B
      *                                                               *                    MD027208B
      *****************************************************************                    MD027208B
                                                                                           MD027208B
     C     SrGLRTNOTD    BEGSR                                                             MD027208B
                                                                                           MD027208B
     C                   EVAL      RtPBeforeImg = WBefore                                  MD027208B
     C                   EVAL      RtPAfterImg = WAfter                                    MD027208B
                                                                                           MD027208B
      ** Check if Nostro code belongs to a Nostro Group and retrieve Limit Ccy if so       MD027208B
                                                                                           MD027208B
     C/exec SQL                                                                            MD027208B
     C+ select * into :NGLD from SDNGLDTD                                                  MD027208B
     C+ where                                                                              MD027208B
     C+       NCNCCY = :AZRTCYCD                                                           MD027208B
     C+   and NCNOSC = :AZRTNONB                                                           MD027208B
     C+   and NCRECI = 'D'                                                                 MD027208B
     C/end-exec                                                                            MD027208B
                                                                                           MD027208B
     C                   If        SQLCODE = 0                                             MD027208B
     C                   eval      PGrpc = NCGRPC                                          MD027208B
                                                                                           MD027208B
     C/exec SQL                                                                            MD027208B
     C+ select * into :NGLH from SDNGLHTD                                                  MD027208B
     C+ where                                                                              MD027208B
     C+       NGGRPC = :PGrpc                                                              MD027208B
     C+   and NGRECI = 'D'                                                                 MD027208B
     C/end-exec                                                                            MD027208B
                                                                                           MD027208B
     C                   If        SQLCODE = 0                                             MD027208B
     C                   eval      PLCcy = NGLCcy                                          MD027208B
     C                   Exsr      SrLCcyDat                                               MD027208B
     C                   Endif                                                             MD027208B
                                                                                           MD027208B
     C                   Exsr      SrPronoBal                                              MD027208B
     C                   Exsr      SrFortTBal                                              MD027208B
     C                   Exsr      SrCalcTot                                               MD027208B
                                                                                           MD027208B
     C                   EXSR      SrUpdate                                                MD027208B
                                                                                           MD027208B
     C                   Endif                                                             MD027208B
                                                                                           MD027208B
     C                   Endsr                                                             MD027208B

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrReBuild   - Rebuild whole of GLFRBLTD                       *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrReBuild     BEGSR

     C/exec SQL
     C+ declare LISTC cursor for
     C+ select * from SDNGLHTD
     C+ where
     C+       NGRECI = 'D'
     C/end-exec

     C/exec SQL
     C+ open LISTC
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 5
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LISTC
     C+ into :NGLH
     C/end-exec

     C                   DOW       SQLCode <> 100

     C                   eval      PGrpc = NGGRPC
     C                   eval      PLCcy = NGLCcy
     C                   Exsr      SrLCcyDat

     C                   Exsr      SrPronoBal
     C********           Exsr      SrTNostBal                                               MD027224
     C                   Exsr      SrFortTBal                                               MD027224
     C                   Exsr      SrCalcTot

     C                   Exsr      SrUpdate

     C/exec SQL
     C+ fetch next from LISTC
     C+ into :NGLH
     C/end-exec

     C                   ENDDO

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCode < 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 6
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ close LISTC
     C/end-exec

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDelGTot  -Delete Group Total record                         *
      *                                                               *
      * Called by: SrSDNGLHTD                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrDelGTot     BEGSR

     C/exec SQL
     C+ delete from GLFRBLTD
     C+ where
     C+       FCGRPC = :PGrpc
     C/end-exec

     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPronoBal  - Calculate total of PRONO Balances for the Group *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrPronoBal    BEGSR

     C                   z-add     0             PronoBalance
     C                   z-add     0             AcctBalance
     C                   z-add     0             RTimBalance                                MD027208
     C********           move      *Blanks       Prono_F                          MD027208C MD027292
     C********           move      *Blanks       Rsacm_F                          MD027208C MD027292
                                                                                            MD027292
      ** Retrieve accounts balances independently of PRONOPN/RSACMTPD                       MD027292
                                                                                            MD027292
     C/exec SQL                                                                             MD027292
     C+ declare LISTI cursor for                                                            MD027292
     C+ SELECT NCGRPC, a.a7cycd, a.a7nonb, b.clbl,                                          MD027292
     C***CASE WHEN a6mdin = 'M' THEN b.clbl * a6sprt                              MD027292 MD027684A
     C****ELSE b.clbl / a6sprt END AS IBal00Adj                                   MD027292 MD027684A
     C+  b.clbl AS IBal00Adj                                                               MD027684A
     C+ FROM SDNGLDTD                                                                       MD027292
     C+ INNER JOIN sdnostpd a ON NCNCCY = a.A7cycd and NCNOSC = a.a7NONB                    MD027292
     C+ INNER JOIN sdcurrpd ON a.a7cycd = a6cycd                                            MD027292
     C+ INNER JOIN accntab b ON b.brca = a.a7brcd AND b.cnum = a.a7cust AND                 MD027292
     C+ b.CCY = a.a7cycd AND b.acod = A.a7accd AND b.acsq = a.a7acsn                        MD027292
     C+ where NCGRPC = :PGrpc                                                               MD027292
     C/end-exec                                                                             MD027292
                                                                                            MD027292
     C/exec SQL                                                                             MD027292
     C+ open LISTI                                                                          MD027292
     C/end-exec                                                                             MD027292
                                                                                            MD027292
      ** Handle SQL Error (if not %EOF)                                                     MD027292
     C                   If        SQLCOD < 0                                               MD027292
     C     *LOCK         IN        LDA                                                      MD027292
     C                   EVAL      DBASE = 23                                               MD027292
     C                   EVAL      DBFILE = 'SQL STM'                                       MD027292
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                             MD027292
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)                   MD027292
     C                   OUT       LDA                                                      MD027292
     C                   EXSR      *PSSR                                                    MD027292
     C                   EndIf                                                              MD027292
                                                                                            MD027292
     C/exec SQL                                                                             MD027292
     C+ fetch next                                                                          MD027292
     C+ from LISTI                                                                          MD027292
     C+ into :LISTI_DS                                                                      MD027292
     C/end-exec                                                                             MD027292
                                                                                            MD027292
     C                   DOW       SQLCode <> 100                                           MD027292
                                                                                            MD027292
     C                   If        Iccy <> PLCcy                                           MD027684A
                                                                                           MD027684A
     C                   eval      FromCcy = Iccy                                          MD027684A
     C                   eval      ToCcy = PLccy                                           MD027684A
     C                   eval      Given = 'N'                                             MD027684A
     C                   eval(H)   FromAmt = IBal00Adj                                     MD027684A
     C                   eval      ToAmt = 0                                               MD027684A
     C                   exsr      SRConvert                                               MD027684A
     C                   eval(H)   IBal00Adj = ToAmt                                       MD027684A
                                                                                           MD027684A
     C                   endif                                                             MD027684A
                                                                                           MD027684A
     C**********         If        Iccy = BJCYCD and                              MD027292 MD027684A
     C**********                   Iccy <> PLCcy                                  MD027292 MD027684A
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   IBal00Adj = IBal00Adj                          MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   IBal00Adj = IBal00Adj / 10                     MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   IBal00Adj = IBal00Adj / 100                    MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   IBal00Adj = IBal00Adj / 1000                   MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Endif                                                    MD027292 MD027684A
                                                                                            MD027292
     C                   eval      AcctBalance(1) = AcctBalance(1) + IBal00Adj              MD027292
     C                   eval      AcctBalance(2) = AcctBalance(2) + IBal00Adj              MD027292
     C                   eval      AcctBalance(3) = AcctBalance(3) + IBal00Adj              MD027292
     C                   eval      AcctBalance(4) = AcctBalance(4) + IBal00Adj              MD027292
     C                   eval      AcctBalance(5) = AcctBalance(5) + IBal00Adj              MD027292
                                                                                            MD027292
     C/exec SQL                                                                             MD027292
     C+ fetch next from LISTI                                                               MD027292
     C+ into :LISTI_DS                                                                      MD027292
     C/end-exec                                                                             MD027292
                                                                                            MD027292
     C                   ENDDO                                                              MD027292
                                                                                            MD027292
      ** Handle SQL Error (if not %EOF)                                                     MD027292
     C                   If        SQLCode < 100                                            MD027292
     C     *LOCK         IN        LDA                                                      MD027292
     C                   EVAL      DBASE = 24                                               MD027292
     C                   EVAL      DBFILE = 'SQL STM'                                       MD027292
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                             MD027292
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)                   MD027292
     C                   OUT       LDA                                                      MD027292
     C                   EXSR      *PSSR                                                    MD027292
     C                   EndIf                                                              MD027292
                                                                                            MD027292
     C/exec SQL                                                                             MD027292
     C+ close LISTI                                                                         MD027292
     C/end-exec                                                                             MD027292

     C/exec SQL
     C+ declare LISTB cursor for
     C**SELECT*NCGRPC,*a.ccy,*a.nosn,*b.ldbl,                                               MD027208
     C+ SELECT NCGRPC, a.ccy, a.nosn, b.clbl,                                               MD027208
     C***CASE WHEN a6mdin = 'M' THEN a.pnb0 * a6sprt                                       MD027684A
     C****ELSE a.pnb0 / a6sprt END AS bal00adj, a.pnd0,                                    MD027684A
     C***CASE WHEN a6mdin = 'M' THEN (a.pnb1-a.pnb0) * a6sprt                              MD027684A
     C****ELSE (a.pnb1-a.pnb0) / a6sprt END AS bal01adj, a.pnd1,                           MD027684A
     C***CASE WHEN a6mdin = 'M' THEN (a.pnb2-a.pnb1) * a6sprt                              MD027684A
     C****ELSE (a.pnb2-a.pnb1) / a6sprt END AS bal02adj, a.pnd2,                           MD027684A
     C***CASE WHEN a6mdin = 'M' THEN (a.pnb3-a.pnb2) * a6sprt                              MD027684A
     C****ELSE (a.pnb3-a.pnb2) / a6sprt END AS bal03adj, a.pnd3,                           MD027684A
     C***CASE WHEN a6mdin = 'M' THEN (a.pnb4-a.pnb3) * a6sprt                              MD027684A
     C****ELSE (a.pnb4-a.pnb3) / a6sprt END AS bal04adj, a.pnd4,                           MD027684A
     C***CASE*WHEN*a6mdin*=*'M'*THEN*b.ldbl***a6sprt                                        MD027208
     C****ELSE*b.ldbl*/*a6sprt*END*AS*baladjb                                               MD027208
     C***CASE WHEN a6mdin = 'M' THEN b.clbl * a6sprt                              MD027208 MD027684A
     C****ELSE b.clbl / a6sprt END AS baladjb                                     MD027208 MD027684A
     C+  a.pnb0 AS bal00adj, a.pnd0,                                                       MD027684A
     C+  a.pnb1-a.pnb0 AS bal01adj, a.pnd1,                                                MD027684A
     C+  a.pnb2-a.pnb1 AS bal02adj, a.pnd2,                                                MD027684A
     C+  a.pnb3-a.pnb2 AS bal03adj, a.pnd3,                                                MD027684A
     C+  a.pnb4-a.pnb3 AS bal04adj, a.pnd4,                                                MD027684A
     C+  b.clbl AS baladjb                                                                 MD027684A
     C+ FROM SDNGLDTD
     C+ INNER JOIN glpronow0 a ON NCNCCY = a.CCY and NCNOSC = DIGITS(a.NOSN)
     C+ INNER JOIN sdcurrpd ON a.ccy = a6cycd
     C+ INNER JOIN sdnostpd ON a.ccy = a7cycd AND a.nosn = a7nonb
     C+ INNER JOIN accntab b ON b.brca = A7brcd AND b.cnum = a7cust AND
     C+ b.CCY = a7cycd AND b.acod = A7accd AND b.acsq = a7acsn
     C+ where NCGRPC = :PGrpc
     C/end-exec

     C/exec SQL
     C+ open LISTB
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 7
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LISTB
     C+ into :LISTB_DS
     C/end-exec
     C********           If        SQLCOD = 100                                   MD027208C MD027292
     C********           move      'Y'           Prono_F           1              MD027208C MD027292
     C********           Endif                                                    MD027208C MD027292

     C                   DOW       SQLCode <> 100
                                                                                            MD027292
     C                   If        Wccy <> PLCcy                                           MD027684A
                                                                                           MD027684A
     C                   eval      FromCcy = Wccy                                          MD027684A
     C                   eval      ToCcy = PLccy                                           MD027684A
     C                   eval      Given = 'N'                                             MD027684A
                                                                                           MD027684A
     C                   eval(H)   FromAmt = Bal00Adj                                      MD027684A
     C                   eval      ToAmt = 0                                               MD027684A
     C                   exsr      SRConvert                                               MD027684A
     C                   eval(H)   Bal00Adj = ToAmt                                        MD027684A
                                                                                           MD027684A
     C                   eval(H)   FromAmt = Bal01Adj                                      MD027684A
     C                   eval      ToAmt = 0                                               MD027684A
     C                   exsr      SRConvert                                               MD027684A
     C                   eval(H)   Bal01Adj = ToAmt                                        MD027684A
                                                                                           MD027684A
     C                   eval(H)   FromAmt = Bal02Adj                                      MD027684A
     C                   eval      ToAmt = 0                                               MD027684A
     C                   exsr      SRConvert                                               MD027684A
     C                   eval(H)   Bal02Adj = ToAmt                                        MD027684A
                                                                                           MD027684A
     C                   eval(H)   FromAmt = Bal03Adj                                      MD027684A
     C                   eval      ToAmt = 0                                               MD027684A
     C                   exsr      SRConvert                                               MD027684A
     C                   eval(H)   Bal03Adj = ToAmt                                        MD027684A
                                                                                           MD027684A
     C                   eval(H)   FromAmt = Bal04Adj                                      MD027684A
     C                   eval      ToAmt = 0                                               MD027684A
     C                   exsr      SRConvert                                               MD027684A
     C                   eval(H)   Bal04Adj = ToAmt                                        MD027684A
                                                                                           MD027684A
     C                   eval(H)   FromAmt = BalAdjB                                       MD027684A
     C                   eval      ToAmt = 0                                               MD027684A
     C                   exsr      SRConvert                                               MD027684A
     C                   eval(H)   BalAdjB = ToAmt                                         MD027684A
                                                                                           MD027684A
     C                   endif                                                             MD027684A
                                                                                           MD027684A
     C**********         If        Wccy = BJCYCD and                              MD027292 MD027684A
     C**********                   Wccy <> PLCcy                                  MD027292 MD027684A
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   Bal00Adj = Bal00Adj                            MD027292 MD027684A
     C**********         EVAL(H)   Bal01Adj = Bal01Adj                            MD027292 MD027684A
     C**********         EVAL(H)   Bal02Adj = Bal02Adj                            MD027292 MD027684A
     C**********         EVAL(H)   Bal03Adj = Bal03Adj                            MD027292 MD027684A
     C**********         EVAL(H)   Bal04Adj = Bal04Adj                            MD027292 MD027684A
     C**********         EVAL(H)   BalAdjB = BalAdjB                              MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   Bal00Adj = Bal00Adj / 10                       MD027292 MD027684A
     C**********         EVAL(H)   Bal01Adj = Bal01Adj / 10                       MD027292 MD027684A
     C**********         EVAL(H)   Bal02Adj = Bal02Adj / 10                       MD027292 MD027684A
     C**********         EVAL(H)   Bal03Adj = Bal03Adj / 10                       MD027292 MD027684A
     C**********         EVAL(H)   Bal04Adj = Bal04Adj / 10                       MD027292 MD027684A
     C**********         EVAL(H)   BalAdjB = BalAdjB / 10                         MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   Bal00Adj = Bal00Adj / 100                      MD027292 MD027684A
     C**********         EVAL(H)   Bal01Adj = Bal01Adj / 100                      MD027292 MD027684A
     C**********         EVAL(H)   Bal02Adj = Bal02Adj / 100                      MD027292 MD027684A
     C**********         EVAL(H)   Bal03Adj = Bal03Adj / 100                      MD027292 MD027684A
     C**********         EVAL(H)   Bal04Adj = Bal04Adj / 100                      MD027292 MD027684A
     C**********         EVAL(H)   BalAdjB = BalAdjB / 100                        MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   Bal00Adj = Bal00Adj / 1000                     MD027292 MD027684A
     C**********         EVAL(H)   Bal01Adj = Bal01Adj / 1000                     MD027292 MD027684A
     C**********         EVAL(H)   Bal02Adj = Bal02Adj / 1000                     MD027292 MD027684A
     C**********         EVAL(H)   Bal03Adj = Bal03Adj / 1000                     MD027292 MD027684A
     C**********         EVAL(H)   Bal04Adj = Bal04Adj / 1000                     MD027292 MD027684A
     C**********         EVAL(H)   BalAdjB = BalAdjB / 1000                       MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Endif                                                    MD027292 MD027684A

      ** Limit Ccy Run date

     C                   SELECT
     C     Ldat0         Wheneq    WPnd0
     C                   eval      PronoBalance(1) = PronoBalance(1) + Bal00Adj
     C********           eval      AcctBalance(1) = AcctBalance(1) + BalAdjB                MD027292
     C     Ldat0         Wheneq    WPnd1
     C                   eval      PronoBalance(1) = PronoBalance(1) + Bal01Adj
     C********           eval      AcctBalance(1) = AcctBalance(1) + BalAdjB                MD027292
     C     Ldat0         Wheneq    WPnd2
     C                   eval      PronoBalance(1) = PronoBalance(1) + Bal02Adj
     C********           eval      AcctBalance(1) = AcctBalance(1) + BalAdjB                MD027292
     C     Ldat0         Wheneq    WPnd3
     C                   eval      PronoBalance(1) = PronoBalance(1) + Bal03Adj
     C********           eval      AcctBalance(1) = AcctBalance(1) + BalAdjB                MD027292
     C     Ldat0         Wheneq    WPnd4
     C                   eval      PronoBalance(1) = PronoBalance(1) + Bal04Adj
     C********           eval      AcctBalance(1) = AcctBalance(1) + BalAdjB                MD027292
     C                   ENDSL

      ** Limit Ccy Run date + 1

     C                   SELECT
     C     Ldat1         Wheneq    WPnd0
     C                   eval      PronoBalance(2) = PronoBalance(2) + Bal00Adj
     C********           eval      AcctBalance(2) = AcctBalance(2) + BalAdjB                MD027292
     C     Ldat1         Wheneq    WPnd1
     C                   eval      PronoBalance(2) = PronoBalance(2) + Bal01Adj
     C********           eval      AcctBalance(2) = AcctBalance(2) + BalAdjB                MD027292
     C     Ldat1         Wheneq    WPnd2
     C                   eval      PronoBalance(2) = PronoBalance(2) + Bal02Adj
     C********           eval      AcctBalance(2) = AcctBalance(2) + BalAdjB                MD027292
     C     Ldat1         Wheneq    WPnd3
     C                   eval      PronoBalance(2) = PronoBalance(2) + Bal03Adj
     C********           eval      AcctBalance(2) = AcctBalance(2) + BalAdjB                MD027292
     C     Ldat1         Wheneq    WPnd4
     C                   eval      PronoBalance(2) = PronoBalance(2) + Bal04Adj
     C********           eval      AcctBalance(2) = AcctBalance(2) + BalAdjB                MD027292
     C                   ENDSL

      ** Limit Ccy Run date + 2

     C                   SELECT
     C     Ldat2         Wheneq    WPnd0
     C                   eval      PronoBalance(3) = PronoBalance(3) + Bal00Adj
     C********           eval      AcctBalance(3) = AcctBalance(3) + BalAdjB                MD027292
     C     Ldat2         Wheneq    WPnd1
     C                   eval      PronoBalance(3) = PronoBalance(3) + Bal01Adj
     C********           eval      AcctBalance(3) = AcctBalance(3) + BalAdjB                MD027292
     C     Ldat2         Wheneq    WPnd2
     C                   eval      PronoBalance(3) = PronoBalance(3) + Bal02Adj
     C********           eval      AcctBalance(3) = AcctBalance(3) + BalAdjB                MD027292
     C     Ldat2         Wheneq    WPnd3
     C                   eval      PronoBalance(3) = PronoBalance(3) + Bal03Adj
     C********           eval      AcctBalance(3) = AcctBalance(3) + BalAdjB                MD027292
     C     Ldat2         Wheneq    WPnd4
     C                   eval      PronoBalance(3) = PronoBalance(3) + Bal04Adj
     C********           eval      AcctBalance(3) = AcctBalance(3) + BalAdjB                MD027292
     C                   ENDSL

      ** Limit Ccy Run date + 3

     C                   SELECT
     C     Ldat3         Wheneq    WPnd0
     C                   eval      PronoBalance(4) = PronoBalance(4) + Bal00Adj
     C********           eval      AcctBalance(4) = AcctBalance(4) + BalAdjB                MD027292
     C     Ldat3         Wheneq    WPnd1
     C                   eval      PronoBalance(4) = PronoBalance(4) + Bal01Adj
     C********           eval      AcctBalance(4) = AcctBalance(4) + BalAdjB                MD027292
     C     Ldat3         Wheneq    WPnd2
     C                   eval      PronoBalance(4) = PronoBalance(4) + Bal02Adj
     C********           eval      AcctBalance(4) = AcctBalance(4) + BalAdjB                MD027292
     C     Ldat3         Wheneq    WPnd3
     C                   eval      PronoBalance(4) = PronoBalance(4) + Bal03Adj
     C********           eval      AcctBalance(4) = AcctBalance(4) + BalAdjB                MD027292
     C     Ldat3         Wheneq    WPnd4
     C                   eval      PronoBalance(4) = PronoBalance(4) + Bal04Adj
     C********           eval      AcctBalance(4) = AcctBalance(4) + BalAdjB                MD027292
     C                   ENDSL

      ** Limit Ccy Run date + 4

     C                   SELECT
     C     Ldat4         Wheneq    WPnd0
     C                   eval      PronoBalance(5) = PronoBalance(5) + Bal00Adj
     C********           eval      AcctBalance(5) = AcctBalance(5) + BalAdjB                MD027292
     C     Ldat4         Wheneq    WPnd1
     C                   eval      PronoBalance(5) = PronoBalance(5) + Bal01Adj
     C********           eval      AcctBalance(5) = AcctBalance(5) + BalAdjB                MD027292
     C     Ldat4         Wheneq    WPnd2
     C                   eval      PronoBalance(5) = PronoBalance(5) + Bal02Adj
     C********           eval      AcctBalance(5) = AcctBalance(5) + BalAdjB                MD027292
     C     Ldat4         Wheneq    WPnd3
     C                   eval      PronoBalance(5) = PronoBalance(5) + Bal03Adj
     C********           eval      AcctBalance(5) = AcctBalance(5) + BalAdjB                MD027292
     C     Ldat4         Wheneq    WPnd4
     C                   eval      PronoBalance(5) = PronoBalance(5) + Bal04Adj
     C********           eval      AcctBalance(5) = AcctBalance(5) + BalAdjB                MD027292
     C                   ENDSL

     C/exec SQL
     C+ fetch next from LISTB
     C+ into :LISTB_DS
     C/end-exec

     C                   ENDDO

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCode < 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 8
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ close LISTB
     C/end-exec

      ** Check for Nostro Codes which might not yet have a record in PRONOPN

     C/exec SQL
     C+ declare LISTE cursor for
     C**SELECT*NCGRPC,*a.ccyd,*a.a7nonb,*b.ldbl,                                            MD027208
     C+ SELECT NCGRPC, a.ccyd, a.a7nonb, b.clbl,                                            MD027208
     C***CASE WHEN a6mdin = 'M' THEN a.TMVAM * a6sprt                                      MD027684A
     C****ELSE a.TMVAM / a6sprt END AS Rbal00adj, a.Vudt,                                  MD027684A
     C***CASE*WHEN*a6mdin*=*'M'*THEN*b.ldbl***a6sprt                                        MD027208
     C****ELSE*b.ldbl*/*a6sprt*END*AS*RbaladjB                                              MD027208
     C***CASE WHEN a6mdin = 'M' THEN b.clbl * a6sprt                              MD027208 MD027684A
     C****ELSE b.clbl / a6sprt END AS RbaladjB                                    MD027208 MD027684A
     C+  a.TMVAM AS Rbal00adj, a.Vudt,                                                     MD027684A
     C+  b.clbl AS RbaladjB                                                                MD027684A
     C+ FROM SDNGLDTD
     C+ INNER JOIN glRSACMw1 a ON NCNCCY = a.CCYD and NCNOSC = a.A7NONB
     C+ INNER JOIN sdcurrpd ON a.ccyd = a6cycd
     C+ INNER JOIN accntab b ON b.brca = a.brca AND b.cnum = a.cusn AND
     C+ b.CCY = a.ccyd AND b.acod = A.acde AND b.acsq = a.asnc
     C+ where NCGRPC = :PGrpc
     C/end-exec

     C/exec SQL
     C+ open LISTE
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 13
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LISTE
     C+ into :LISTE_DS
     C/end-exec
     C********           If        SQLCOD = 100                                 MD027208C  MD027292
     C********           move      'Y'           Rsacm_F           1            MD027208C  MD027292
     C********           Endif                                                  MD027208C  MD027292

     C                   DOW       SQLCode <> 100

     C                   If        Rccy <> PLCcy                                           MD027684A
                                                                                           MD027684A
     C                   eval      FromCcy = Rccy                                          MD027684A
     C                   eval      ToCcy = PLccy                                           MD027684A
     C                   eval      Given = 'N'                                             MD027684A
                                                                                           MD027684A
     C                   eval(H)   FromAmt = RBal00Adj                                     MD027684A
     C                   eval      ToAmt = 0                                               MD027684A
     C                   exsr      SRConvert                                               MD027684A
     C                   eval(H)   RBal00Adj = ToAmt                                       MD027684A
                                                                                           MD027684A
     C                   eval(H)   FromAmt = RBalAdjB                                      MD027684A
     C                   eval      ToAmt = 0                                               MD027684A
     C                   exsr      SRConvert                                               MD027684A
     C                   eval(H)   RBalAdjB = ToAmt                                        MD027684A
                                                                                           MD027684A
     C                   endif                                                             MD027684A
                                                                                           MD027684A
     C**********         If        Rccy = BJCYCD and                              MD027292 MD027684A
     C**********                   Rccy <> PLCcy                                  MD027292 MD027684A
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   RBal00Adj = RBal00Adj                          MD027292 MD027684A
     C**********         EVAL(H)   RBalAdjB = RBalAdjB                            MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   RBal00Adj = RBal00Adj / 10                     MD027292 MD027684A
     C**********         EVAL(H)   RBalAdjB = RBalAdjB / 10                       MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   RBal00Adj = RBal00Adj / 100                    MD027292 MD027684A
     C**********         EVAL(H)   RBalAdjB = RBalAdjB / 100                      MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   RBal00Adj = RBal00Adj / 1000                   MD027292 MD027684A
     C**********         EVAL(H)   RBalAdjB = RBalAdjB / 1000                     MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Endif                                                    MD027292 MD027684A

     C                   SELECT
      ** Limit Ccy Run date
     C     Ldat0         Wheneq    WVudt
     C                   eval      PronoBalance(1) = PronoBalance(1) + RBal00Adj
     C**********                    + RBalAdjB                                              MD028029
     C********           eval      AcctBalance(1) = AcctBalance(1) + RBalAdjB               MD027292

      ** Limit Ccy Run date + 1
     C     Ldat1         Wheneq    WVudt
     C                   eval      PronoBalance(2) = PronoBalance(2) + RBal00Adj
     C**********                    + RBalAdjB                                              MD028029
     C********           eval      AcctBalance(2) = AcctBalance(2) + RBalAdjB               MD027292

      ** Limit Ccy Run date + 2
     C     Ldat2         Wheneq    WVudt
     C                   eval      PronoBalance(3) = PronoBalance(3) + RBal00Adj
     C**********                    + RBalAdjB                                              MD028029
     C********           eval      AcctBalance(3) = AcctBalance(3) + RBalAdjB               MD027292

      ** Limit Ccy Run date + 3
     C     Ldat3         Wheneq    WVudt
     C                   eval      PronoBalance(4) = PronoBalance(4) + RBal00Adj
     C**********                    + RBalAdjB                                              MD028029
     C********           eval      AcctBalance(4) = AcctBalance(4) + RBalAdjB               MD027292

      ** Limit Ccy Run date + 4
     C     Ldat4         Wheneq    WVudt
     C                   eval      PronoBalance(5) = PronoBalance(5) + RBal00Adj
     C**********                    + RBalAdjB                                              MD028029
     C********           eval      AcctBalance(5) = AcctBalance(5) + RBalAdjB               MD027292
     C                   ENDSL

     C/exec SQL
     C+ fetch next from LISTE
     C+ into :LISTE_DS
     C/end-exec

     C                   ENDDO

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCode < 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 14
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf

     C/exec SQL
     C+ close LISTE
     C/end-exec
      ********                                                                    MD027208C MD027292
      ** Retrieve accounts balances if no record in PRONOPN nor in RSACMTPD       MD027208C MD027292
     C********           If        Prono_F = 'Y'                                  MD027208C MD027292
     C********                     and Rsacm_F = 'Y'                              MD027208C MD027292
      ********                                                                    MD027208C MD027292
     C*exec SQL                                                                   MD027208C MD027292
     C**declare LISTI cursor for                                                  MD027208C MD027292
     C**SELECT NCGRPC, a.a7cycd, a.a7nonb, b.clbl,                                MD027208C MD027292
     C***CASE WHEN a6mdin = 'M' THEN b.clbl * a6sprt                              MD027208C MD027292
     C****ELSE b.clbl / a6sprt END AS IBal00Adj                                   MD027208C MD027292
     C**FROM SDNGLDTD                                                             MD027208C MD027292
     C**INNER JOIN sdnostpd a ON NCNCCY = a.A7cycd and NCNOSC = a.a7NONB          MD027208C MD027292
     C**INNER JOIN sdcurrpd ON a.a7cycd = a6cycd                                  MD027208C MD027292
     C**INNER JOIN accntab b ON b.brca = a.a7brcd AND b.cnum = a.a7cust AND       MD027208C MD027292
     C**b.CCY = a.a7cycd AND b.acod = A.a7accd AND b.acsq = a.a7acsn              MD027208C MD027292
     C**where NCGRPC = :PGrpc                                                     MD027208C MD027292
     C*end-exec                                                                   MD027208C MD027292
      ********                                                                    MD027208C MD027292
     C*exec SQL                                                                   MD027208C MD027292
     C**open LISTI                                                                MD027208C MD027292
     C*end-exec                                                                   MD027208C MD027292
      ********                                                                    MD027208C MD027292
      ***Handle SQL Error (if not %EOF)                                           MD027208C MD027292
     C********           If        SQLCOD < 0                                     MD027208C MD027292
     C******LOCK         IN        LDA                                            MD027208C MD027292
     C********           EVAL      DBASE = 23                                     MD027208C MD027292
     C********           EVAL      DBFILE = 'SQL STM'                             MD027208C MD027292
     C********           EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                   MD027208C MD027292
     C********                           + ';  SQLCOD : ' + %char(SQLCOD)         MD027208C MD027292
     C********           OUT       LDA                                            MD027208C MD027292
     C********           EXSR      *PSSR                                          MD027208C MD027292
     C********           EndIf                                                    MD027208C MD027292
      ********                                                                    MD027208C MD027292
     C*exec SQL                                                                   MD027208C MD027292
     C**fetch next                                                                MD027208C MD027292
     C**from LISTI                                                                MD027208C MD027292
     C**into :LISTI_DS                                                            MD027208C MD027292
     C*end-exec                                                                   MD027208C MD027292
      ********                                                                    MD027208C MD027292
     C********           DOW       SQLCode <> 100                                 MD027208C MD027292
      ********                                                                    MD027208C MD027292
     C********           eval      AcctBalance(1) = AcctBalance(1) + IBal00Adj    MD027208C MD027292
     C********           eval      AcctBalance(2) = AcctBalance(2) + IBal00Adj    MD027208C MD027292
     C********           eval      AcctBalance(3) = AcctBalance(3) + IBal00Adj    MD027208C MD027292
     C********           eval      AcctBalance(4) = AcctBalance(4) + IBal00Adj    MD027208C MD027292
     C********           eval      AcctBalance(5) = AcctBalance(5) + IBal00Adj    MD027208C MD027292
      ********                                                                    MD027208C MD027292
     C*exec SQL                                                                   MD027208C MD027292
     C**fetch next from LISTI                                                     MD027208C MD027292
     C**into :LISTI_DS                                                            MD027208C MD027292
     C*end-exec                                                                   MD027208C MD027292
      ********                                                                    MD027208C MD027292
     C********           ENDDO                                                    MD027208C MD027292
      ********                                                                    MD027208C MD027292
      ***Handle SQL Error (if not %EOF)                                           MD027208C MD027292
     C********           If        SQLCode < 100                                  MD027208C MD027292
     C******LOCK         IN        LDA                                            MD027208C MD027292
     C********           EVAL      DBASE = 24                                     MD027208C MD027292
     C********           EVAL      DBFILE = 'SQL STM'                             MD027208C MD027292
     C********           EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                   MD027208C MD027292
     C********                           + ';  SQLCOD : ' + %char(SQLCOD)         MD027208C MD027292
     C********           OUT       LDA                                            MD027208C MD027292
     C********           EXSR      *PSSR                                          MD027208C MD027292
     C********           EndIf                                                    MD027208C MD027292
      ********                                                                    MD027208C MD027292
     C*exec SQL                                                                   MD027208C MD027292
     C**close LISTI                                                               MD027208C MD027292
     C*end-exec                                                                   MD027208C MD027292
     C********           Endif                                                    MD027208C MD027292
                                                                                            MD027208
      ** Get RT postings totals from GLRTNOTD                                               MD027208
                                                                                            MD027208
     C/exec SQL                                                                             MD027208
     C+ declare LISTG cursor for                                                            MD027208
     C+ SELECT NCGRPC, a.rtcycd, a.rtnonb,                                                  MD027208
     C***CASE WHEN a6mdin = 'M' THEN a.rtpsta * a6sprt                            MD027208 MD027684A
     C****ELSE a.rtpsta / a6sprt END AS TBal00adj, a.rtvdat                       MD027208 MD027684A
     C+  rtpsta AS TBal00adj, a.rtvdat                                                     MD027684A
     C+ FROM SDNGLDTD                                                                       MD027208
     C+ INNER JOIN glrtnotd a ON NCNCCY = a.rtcycd and NCNOSC = a.rtNONB                    MD027208
     C+ INNER JOIN sdcurrpd ON a.rtcycd = a6cycd                                            MD027208
     C+ where NCGRPC = :PGrpc                                                               MD027208
     C/end-exec                                                                             MD027208
                                                                                            MD027208
     C/exec SQL                                                                             MD027208
     C+ open LISTG                                                                          MD027208
     C/end-exec                                                                             MD027208
                                                                                            MD027208
      ** Handle SQL Error (if not %EOF)                                                     MD027208
     C                   If        SQLCOD < 0                                               MD027208
     C     *LOCK         IN        LDA                                                      MD027208
     C********           EVAL      DBASE = 18                                     MD027208 MD027208C
     C                   EVAL      DBASE = 22                                              MD027208C
     C                   EVAL      DBFILE = 'SQL STM'                                       MD027208
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                             MD027208
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)                   MD027208
     C                   OUT       LDA                                                      MD027208
     C                   EXSR      *PSSR                                                    MD027208
     C                   EndIf                                                              MD027208
                                                                                            MD027208
     C/exec SQL                                                                             MD027208
     C+ fetch next                                                                          MD027208
     C+ from LISTG                                                                          MD027208
     C+ into :LISTG_DS                                                                      MD027208
     C/end-exec                                                                             MD027208
                                                                                            MD027208
     C                   DOW       SQLCode <> 100                                           MD027208
                                                                                            MD027292
     C                   If        Tccy <> PLCcy                                           MD027684A
                                                                                           MD027684A
     C                   eval      FromCcy = Tccy                                          MD027684A
     C                   eval      ToCcy = PLccy                                           MD027684A
     C                   eval      Given = 'N'                                             MD027684A
     C                   eval(H)   FromAmt = TBal00Adj                                     MD027684A
     C                   eval      ToAmt = 0                                               MD027684A
     C                   exsr      SRConvert                                               MD027684A
     C                   eval(H)   TBal00Adj = ToAmt                                       MD027684A
                                                                                           MD027684A
     C                   endif                                                             MD027684A
                                                                                           MD027684A
     C**********         If        Tccy = BJCYCD and                              MD027292 MD027684A
     C**********                   Tccy <> PLCcy                                  MD027292 MD027684A
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   TBal00Adj = TBal00Adj                          MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   TBal00Adj = TBal00Adj / 10                     MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   TBal00Adj = TBal00Adj / 100                    MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   TBal00Adj = TBal00Adj / 1000                   MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Endif                                                    MD027292 MD027684A
                                                                                            MD027208
     C                   SELECT                                                             MD027208
      ** Limit Ccy Run date                                                                 MD027208
     C     Ldat0         Wheneq    TVudt                                                    MD027208
     C                   eval      RTimBalance(1) = RTimBalance(1) + TBal00Adj              MD027208
                                                                                            MD027208
      ** Limit Ccy Run date + 1                                                             MD027208
     C*****Ldat1         Wheneq    TVudt                                          MD027208 MD027208A
     C********           eval      RTimBalance(2) = RTimBalance(2) + TBal00Adj    MD027208 MD027208A
                                                                                            MD027208
      ** Limit Ccy Run date + 2                                                             MD027208
     C*****Ldat2         Wheneq    TVudt                                          MD027208 MD027208A
     C********           eval      RTimBalance(3) = RTimBalance(3) + TBal00Adj    MD027208 MD027208A
                                                                                            MD027208
      ** Limit Ccy Run date + 3                                                             MD027208
     C*****Ldat3         Wheneq    TVudt                                          MD027208 MD027208A
     C********           eval      RTimBalance(4) = RTimBalance(4) + TBal00Adj    MD027208 MD027208A
                                                                                            MD027208
      ** Limit Ccy Run date + 4                                                             MD027208
     C*****Ldat4         Wheneq    TVudt                                          MD027208 MD027208A
     C********           eval      RTimBalance(5) = RTimBalance(5) + TBal00Adj    MD027208 MD027208A
     C                   ENDSL                                                              MD027208
                                                                                            MD027208
     C/exec SQL                                                                             MD027208
     C+ fetch next from LISTG                                                               MD027208
     C+ into :LISTG_DS                                                                      MD027208
     C/end-exec                                                                             MD027208
                                                                                            MD027208
     C                   ENDDO                                                              MD027208
                                                                                            MD027208
      ** Handle SQL Error (if not %EOF)                                                     MD027208
     C                   If        SQLCode < 100                                            MD027208
     C     *LOCK         IN        LDA                                                      MD027208
     C                   EVAL      DBASE = 19                                               MD027208
     C                   EVAL      DBFILE = 'SQL STM'                                       MD027208
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                             MD027208
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)                   MD027208
     C                   OUT       LDA                                                      MD027208
     C                   EXSR      *PSSR                                                    MD027208
     C                   EndIf                                                              MD027208
                                                                                            MD027208
     C/exec SQL                                                                             MD027208
     C+ close LISTG                                                                         MD027208
     C/end-exec                                                                             MD027208
                                                                                            MD027208
     C                   Endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTNostBal  - Calculate total of GLTNOSTD balances for the    *
      *               Group                                           *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      ***********                                                                          MD027684A
     C*****SrTNostBal    BEGSR                                                             MD027684A
      ***********                                                                          MD027684A
     C***********        z-add     0             OForBalance                               MD027684A
      ***********                                                                          MD027684A
     C*exec*SQL                                                                            MD027684A
     C**declare LISTD cursor for                                                           MD027684A
     C**SELECT nccycd, ncnonb,                                                             MD027684A
     C***CASE WHEN a6mdin = 'M' THEN ncamt0 * a6sprt                                       MD027684A
     C****ELSE ncamt0 / a6sprt END AS dbal00adj, NCDAT0,                                   MD027684A
     C***CASE WHEN a6mdin = 'M' THEN ncamt1 * a6sprt                                       MD027684A
     C****ELSE ncamt1 / a6sprt END AS dbal01adj, NCDAT1,                                   MD027684A
     C***CASE WHEN a6mdin = 'M' THEN ncamt2 * a6sprt                                       MD027684A
     C****ELSE ncamt2 / a6sprt END AS dbal02adj, NCDAT2,                                   MD027684A
     C***CASE WHEN a6mdin = 'M' THEN ncamt3 * a6sprt                                       MD027684A
     C****ELSE ncamt3 / a6sprt END AS dbal03adj, NCDAT3,                                   MD027684A
     C***CASE WHEN a6mdin = 'M' THEN ncamt4 * a6sprt                                       MD027684A
     C****ELSE ncamt4 / a6sprt END AS dbal04adj, NCDAT4                                    MD027684A
     C**FROM sdngldtd                                                                      MD027684A
     C**INNER JOIN gltnostd ON ncnccy = nccycd and ncnosc = ncnonb                         MD027684A
     C**INNER JOIN sdcurrpd ON nccycd = a6cycd                                             MD027684A
     C**where NCGRPC = :PGrpc                                                              MD027684A
     C*end-exec                                                                            MD027684A
      ***********                                                                          MD027684A
     C*exec*SQL                                                                            MD027684A
     C**open LISTD                                                                         MD027684A
     C*end-exec                                                                            MD027684A
      ***********                                                                          MD027684A
      ***Handle*SQL Error (if not %EOF)                                                    MD027684A
     C***********        If        SQLCOD < 0                                              MD027684A
     C******LOCK         IN        LDA                                                     MD027684A
     C***********        EVAL      DBASE = 9                                               MD027684A
     C***********        EVAL      DBFILE = 'SQL STM'                                      MD027684A
     C***********        EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                            MD027684A
     C***********                        + ';  SQLCOD : ' + %char(SQLCOD)                  MD027684A
     C***********        OUT       LDA                                                     MD027684A
     C***********        EXSR      *PSSR                                                   MD027684A
     C***********        EndIf                                                             MD027684A
      ***********                                                                          MD027684A
     C*exec*SQL                                                                            MD027684A
     C**fetch next                                                                         MD027684A
     C**from LISTD                                                                         MD027684A
     C**into :LISTD_DS                                                                     MD027684A
     C*end-exec                                                                            MD027684A
      ***********                                                                          MD027684A
     C***********        DOW       SQLCode <> 100                                          MD027684A
      ***********                                                                          MD027684A
      ***Limit Ccy Run date                                                                MD027684A
      ***********                                                                          MD027684A
     C***********        SELECT                                                            MD027684A
     C*****Ldat0         Wheneq    WNCDat0                                                 MD027684A
     C***********        eval      OForBalance(1) = OForBalance(1) + DBal00Adj             MD027684A
     C*****Ldat0         Wheneq    WNCDat1                                                 MD027684A
     C***********        eval      OForBalance(1) = OForBalance(1) + DBal01Adj             MD027684A
     C*****Ldat0         Wheneq    WNCDat2                                                 MD027684A
     C***********        eval      OForBalance(1) = OForBalance(1) + DBal02Adj             MD027684A
     C*****Ldat0         Wheneq    WNCDat3                                                 MD027684A
     C***********        eval      OForBalance(1) = OForBalance(1) + DBal03Adj             MD027684A
     C*****Ldat0         Wheneq    WNCdat4                                                 MD027684A
     C***********        eval      OForBalance(1) = OForBalance(1) + DBal04Adj             MD027684A
     C***********        ENDSL                                                             MD027684A
      ***********                                                                          MD027684A
      ***Limit Ccy Run date + 1                                                            MD027684A
      ***********                                                                          MD027684A
     C***********        SELECT                                                            MD027684A
     C*****Ldat1         Wheneq    WNCDat0                                                 MD027684A
     C***********        eval      OForBalance(2) = OForBalance(2) + DBal00Adj             MD027684A
     C*****Ldat1         Wheneq    WNCDat1                                                 MD027684A
     C***********        eval      OForBalance(2) = OForBalance(2) + DBal01Adj             MD027684A
     C*****Ldat1         Wheneq    WNCDat2                                                 MD027684A
     C***********        eval      OForBalance(2) = OForBalance(2) + DBal02Adj             MD027684A
     C*****Ldat1         Wheneq    WNCDat3                                                 MD027684A
     C***********        eval      OForBalance(2) = OForBalance(2) + DBal03Adj             MD027684A
     C*****Ldat1         Wheneq    WNCdat4                                                 MD027684A
     C***********        eval      OForBalance(2) = OForBalance(2) + DBal04Adj             MD027684A
     C***********        ENDSL                                                             MD027684A
      ***********                                                                          MD027684A
      ***Limit Ccy Run date + 2                                                            MD027684A
      ***********                                                                          MD027684A
     C***********        SELECT                                                            MD027684A
     C*****Ldat2         Wheneq    WNCDat0                                                 MD027684A
     C***********        eval      OForBalance(3) = OForBalance(3) + DBal00Adj             MD027684A
     C*****Ldat2         Wheneq    WNCDat1                                                 MD027684A
     C***********        eval      OForBalance(3) = OForBalance(3) + DBal01Adj             MD027684A
     C*****Ldat2         Wheneq    WNCDat2                                                 MD027684A
     C***********        eval      OForBalance(3) = OForBalance(3) + DBal02Adj             MD027684A
     C*****Ldat2         Wheneq    WNCDat3                                                 MD027684A
     C***********        eval      OForBalance(3) = OForBalance(3) + DBal03Adj             MD027684A
     C*****Ldat2         Wheneq    WNCdat4                                                 MD027684A
     C***********        eval      OForBalance(3) = OForBalance(3) + DBal04Adj             MD027684A
     C***********        ENDSL                                                             MD027684A
      ***********                                                                          MD027684A
      ***Limit Ccy Run date + 3                                                            MD027684A
      ***********                                                                          MD027684A
     C***********        SELECT                                                            MD027684A
     C*****Ldat3         Wheneq    WNCDat0                                                 MD027684A
     C***********        eval      OForBalance(4) = OForBalance(4) + DBal00Adj             MD027684A
     C*****Ldat3         Wheneq    WNCDat1                                                 MD027684A
     C***********        eval      OForBalance(4) = OForBalance(4) + DBal01Adj             MD027684A
     C*****Ldat3         Wheneq    WNCDat2                                                 MD027684A
     C***********        eval      OForBalance(4) = OForBalance(4) + DBal02Adj             MD027684A
     C*****Ldat3         Wheneq    WNCDat3                                                 MD027684A
     C***********        eval      OForBalance(4) = OForBalance(4) + DBal03Adj             MD027684A
     C*****Ldat3         Wheneq    WNCdat4                                                 MD027684A
     C***********        eval      OForBalance(4) = OForBalance(4) + DBal04Adj             MD027684A
     C***********        ENDSL                                                             MD027684A
      ***********                                                                          MD027684A
      ***Limit Ccy Run date + 4                                                            MD027684A
      ***********                                                                          MD027684A
     C***********        SELECT                                                            MD027684A
     C*****Ldat4         Wheneq    WNCDat0                                                 MD027684A
     C***********        eval      OForBalance(5) = OForBalance(5) + DBal00Adj             MD027684A
     C*****Ldat4         Wheneq    WNCDat1                                                 MD027684A
     C***********        eval      OForBalance(5) = OForBalance(5) + DBal01Adj             MD027684A
     C*****Ldat4         Wheneq    WNCDat2                                                 MD027684A
     C***********        eval      OForBalance(5) = OForBalance(5) + DBal02Adj             MD027684A
     C*****Ldat4         Wheneq    WNCDat3                                                 MD027684A
     C***********        eval      OForBalance(5) = OForBalance(5) + DBal03Adj             MD027684A
     C*****Ldat4         Wheneq    WNCdat4                                                 MD027684A
     C***********        eval      OForBalance(5) = OForBalance(5) + DBal04Adj             MD027684A
     C***********        ENDSL                                                             MD027684A
      ***********                                                                          MD027684A
     C*exec*SQL                                                                            MD027684A
     C**fetch next from LISTD                                                              MD027684A
     C**into :LISTD_DS                                                                     MD027684A
     C*end-exec                                                                            MD027684A
      ***********                                                                          MD027684A
     C***********        ENDDO                                                             MD027684A
      ***********                                                                          MD027684A
      ***Handle SQL Error (if not %EOF)                                                    MD027684A
     C***********        If        SQLCode < 100                                           MD027684A
     C******LOCK         IN        LDA                                                     MD027684A
     C***********        EVAL      DBASE = 10                                              MD027684A
     C***********        EVAL      DBFILE = 'SQL STM'                                      MD027684A
     C***********        EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                            MD027684A
     C***********                        + ';  SQLCOD : ' + %char(SQLCOD)                  MD027684A
     C***********        OUT       LDA                                                     MD027684A
     C***********        EXSR      *PSSR                                                   MD027684A
     C***********        EndIf                                                             MD027684A
      ***********                                                                          MD027684A
     C*exec*SQL                                                                            MD027684A
     C**close LISTD                                                                        MD027684A
     C*end-exec                                                                            MD027684A
      ***********                                                                          MD027684A
     C***********        Endsr                                                             MD027684A
                                                                                            MD027224
      *****************************************************************                     MD027224
      /EJECT                                                                                MD027224
      *****************************************************************                     MD027224
      *                                                               *                     MD027224
      * SrFortTBal  - Calculate total of GLFORTTD balances for the    *                     MD027224
      *               Group                                           *                     MD027224
      * Calls: None                                                   *                     MD027224
      *                                                               *                     MD027224
      *****************************************************************                     MD027224
                                                                                            MD027224
     C     SrFortTBal    BEGSR                                                              MD027224
                                                                                            MD027224
     C                   z-add     0             ForTBalance                                MD027224
                                                                                            MD027224
     C/exec SQL                                                                             MD027224
     C+ declare LISTH cursor for                                                            MD027224
     C+ SELECT NCGRPC, a.tfccy, a.tfnosc,                                                   MD027224
     C***CASE WHEN a6mdin = 'M' THEN a.tfamnt * a6sprt                            MD027292 MD027684A
     C****ELSE a.tfamnt / a6sprt END AS Fbal00adj, a.tfdate                       MD027292 MD027684A
     C+  a.tfamnt AS Fbal00adj, a.tfdate                                                   MD027684A
     C+ FROM sdngldtd                                                                       MD027224
     C+ INNER JOIN glforttd a ON ncnccy = a.tfccy and ncnosc = a.tfnosc                     MD027224
     C+ INNER JOIN sdcurrpd ON a.tfccy = a6cycd                                             MD027224
     C+ where NCGRPC = :PGrpc and a.tfdate >= :BJRDNB                                       MD027224
     C/end-exec                                                                             MD027224
                                                                                            MD027224
     C/exec SQL                                                                             MD027224
     C+ open LISTH                                                                          MD027224
     C/end-exec                                                                             MD027224
                                                                                            MD027224
      ** Handle SQL Error (if not %EOF)                                                     MD027224
     C                   If        SQLCOD < 0                                               MD027224
     C     *LOCK         IN        LDA                                                      MD027224
     C                   EVAL      DBASE = 20                                               MD027224
     C                   EVAL      DBFILE = 'SQL STM'                                       MD027224
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                             MD027224
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)                   MD027224
     C                   OUT       LDA                                                      MD027224
     C                   EXSR      *PSSR                                                    MD027224
     C                   EndIf                                                              MD027224
                                                                                            MD027224
     C/exec SQL                                                                             MD027224
     C+ fetch next                                                                          MD027224
     C+ from LISTH                                                                          MD027224
     C+ into :LISTH_DS                                                                      MD027224
     C/end-exec                                                                             MD027224
                                                                                            MD027224
     C                   DOW       SQLCode <> 100                                           MD027224
                                                                                            MD027292
     C                   If        Fccy <> PLCcy                                           MD027684A
                                                                                           MD027684A
     C                   eval      FromCcy = Fccy                                          MD027684A
     C                   eval      ToCcy = PLccy                                           MD027684A
     C                   eval      Given = 'N'                                             MD027684A
     C                   eval(H)   FromAmt = FBal00Adj                                     MD027684A
     C                   eval      ToAmt = 0                                               MD027684A
     C                   exsr      SRConvert                                               MD027684A
     C                   eval(H)   FBal00Adj = ToAmt                                       MD027684A
                                                                                           MD027684A
     C                   endif                                                             MD027684A
                                                                                           MD027684A
     C**********         If        Fccy = BJCYCD and                               MD027292 MD027684
     C**********                   Fccy <> PLCcy                                   MD027292 MD027684
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FBal00Adj = FBal00Adj                          MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FBal00Adj = FBal00Adj / 10                     MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FBal00Adj = FBal00Adj / 100                    MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FBal00Adj = FBal00Adj / 1000                   MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Endif                                                     MD027292 MD027684
                                                                                            MD027224
      ** Limit Ccy Run date                                                                 MD027224
                                                                                            MD027224
     C                   SELECT                                                             MD027224
      ** Limit Ccy Run date                                                                 MD027224
     C     Ldat0         Wheneq    FDate                                                    MD027224
     C                   eval      ForTBalance(1) = ForTBalance(1) + FBal00Adj              MD027224
                                                                                            MD027224
      ** Limit Ccy Run date + 1                                                             MD027224
     C     Ldat1         Wheneq    FDate                                                    MD027224
     C                   eval      ForTBalance(2) = ForTBalance(2) + FBal00Adj              MD027224
                                                                                            MD027224
      ** Limit Ccy Run date + 2                                                             MD027224
     C     Ldat2         Wheneq    FDate                                                    MD027224
     C                   eval      ForTBalance(3) = ForTBalance(3) + FBal00Adj              MD027224
                                                                                            MD027224
      ** Limit Ccy Run date + 3                                                             MD027224
     C     Ldat3         Wheneq    FDate                                                    MD027224
     C                   eval      ForTBalance(4) = ForTBalance(4) + FBal00Adj              MD027224
                                                                                            MD027224
      ** Limit Ccy Run date + 4                                                             MD027224
     C     Ldat4         Wheneq    FDate                                                    MD027224
     C                   eval      ForTBalance(5) = ForTBalance(5) + FBal00Adj              MD027224
     C                   ENDSL                                                              MD027224
                                                                                            MD027224
     C/exec SQL                                                                             MD027224
     C+ fetch next from LISTH                                                               MD027224
     C+ into :LISTH_DS                                                                      MD027224
     C/end-exec                                                                             MD027224
                                                                                            MD027224
     C                   ENDDO                                                              MD027224
                                                                                            MD027224
      ** Handle SQL Error (if not %EOF)                                                     MD027224
     C                   If        SQLCode < 100                                            MD027224
     C     *LOCK         IN        LDA                                                      MD027224
     C                   EVAL      DBASE = 21                                               MD027224
     C                   EVAL      DBFILE = 'SQL STM'                                       MD027224
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                             MD027224
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)                   MD027224
     C                   OUT       LDA                                                      MD027224
     C                   EXSR      *PSSR                                                    MD027224
     C                   EndIf                                                              MD027224
                                                                                            MD027224
     C/exec SQL                                                                             MD027224
     C+ close LISTH                                                                         MD027224
     C/end-exec                                                                             MD027224
                                                                                            MD027224
     C                   Endsr                                                              MD027224

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLCcyDat - Get Limit currency dates                          *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrLCcyDat     BEGSR

      ** Get dates for the Limit Currency
     C                   z-add     BJRDNB        LDat0

     C                   z-add     BJRDNB        ZDayNo
     C                   z-add     1             ZNrDys
     C                   move      PLccy         ZCcy
     C                   Exsr      ZFWDT
     C                   z-add     ZDyNbr        LDat1

     C                   z-add     2             ZNrDys
     C                   Exsr      ZFWDT
     C                   z-add     ZDyNbr        LDat2

     C                   z-add     3             ZNrDys
     C                   Exsr      ZFWDT
     C                   z-add     ZDyNbr        LDat3

     C                   z-add     4             ZNrDys
     C                   Exsr      ZFWDT
     C                   z-add     ZDyNbr        LDat4

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCalcTot - Calculate Total                                   *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrCalcTot     BEGSR

     C                   z-add     0             TotBalance

      ** Calculate Totals for the group code

     C                   If        PronoBalance(1) <> 0
     C                   eval      TotBalance(1) = PronoBalance(1) -
     C********                                 AcctBalance(1) + OForBalance(1)              MD027224
     C                                         AcctBalance(1) + ForTBalance(1)              MD027224
     C                                         + RTimBalance(1)                             MD027208
     C                   else
     C                   eval      TotBalance(1) = PronoBalance(1)
     C********                                  + OForBalance(1)                            MD027224
     C                                         - AcctBalance(1)                            MD027208C
     C                                          + ForTBalance(1)                            MD027224
     C                                         + RTimBalance(1)                            MD027208C
     C                   Endif

     C********           eval      TotBalance(2) = PronoBalance(2) -                        MD023273
     C                   eval      TotBalance(2) = PronoBalance(2)                          MD023273
     C********                                 AcctBalance(2) + OForBalance(2)              MD027224
     C********                                 AcctBalance(2) + ForTBalance(2)     MD027224 MD023273
     C                                         + ForTBalance(2)                             MD023273
     C********                                 + RTimBalance(2)                   MD027208 MD027208A

     C********           eval      TotBalance(3) = PronoBalance(3) -                        MD023273
     C                   eval      TotBalance(3) = PronoBalance(3)                          MD023273
     C********                                 AcctBalance(3) + OForBalance(3)              MD027224
     C********                                 AcctBalance(3) + ForTBalance(3)     MD027224 MD023273
     C                                         + ForTBalance(3)                             MD023273
     C********                                 + RTimBalance(3)                   MD027208 MD027208A

     C********           eval      TotBalance(4) = PronoBalance(4) -                        MD023273
     C                   eval      TotBalance(4) = PronoBalance(4)                          MD023273
     C********                                 AcctBalance(4) + OForBalance(4)              MD027224
     C********                                 AcctBalance(4) + ForTBalance(4)     MD027224 MD023273
     C                                         + ForTBalance(4)                             MD023273
     C********                                 + RTimBalance(4)                   MD027208 MD027208A

     C********           eval      TotBalance(5) = PronoBalance(5) -                        MD023273
     C                   eval      TotBalance(5) = PronoBalance(5)                          MD023273
     C********                                 AcctBalance(5) + OForBalance(5)              MD027224
     C********                                 AcctBalance(5) + ForTBalance(5)     MD027224 MD023273
     C                                         + ForTBalance(5)                             MD023273
     C********                                 + RTimBalance(5)                   MD027208 MD027208A
      **********                                                                           MD027684A
      ***Convert to Limit Ccy                                                              MD027684A
      **********                                                                           MD027684A
     C*****BJCYCD        Ifne      PLCcy                                                   MD027684A
      **********                                                                           MD027684A
     C**********         EVAL      FromCcy = BJCYCD                                        MD027684A
     C**********         EVAL      ToCcy =PLCcy                                            MD027684A
     C**********         eval      Given = 'N'                                             MD027684A
      **********                                                                           MD027684A
      ***Ledger Balance                                                                    MD027684A
     C********           EVAL      FromAmt = AcctBalance(1)                                 MD027292
     C**********         EVAL(H)   FromAmt = AcctBalance(1)                                MD027684A
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(1)                       MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(1) * 10                  MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(1) * 100                 MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(1) * 1000                MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                               MD027684A
     C********           EVAL      AcctBalanceL(1) = ToAmt                                  MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(1) = ToAmt                        MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(1) = ToAmt / 10                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(1) = ToAmt / 100                  MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(1) = ToAmt / 10000                MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                           MD027684A
     C********           EVAL      FromAmt = AcctBalance(2)                                 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(2)                       MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(2) * 10                  MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(2) * 100                 MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(2) * 1000                MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                               MD027684A
     C********           EVAL      AcctBalanceL(2) = ToAmt                                  MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(2) = ToAmt                        MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(2) = ToAmt / 10                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(2) = ToAmt / 100                  MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(2) = ToAmt / 1000                 MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                           MD027684A
     C********           EVAL      FromAmt = AcctBalance(3)                                 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(3)                       MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(3) * 10                  MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(3) * 100                 MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(3) * 1000                MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                               MD027684A
     C********           EVAL      AcctBalanceL(3) = ToAmt                                  MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(3) = ToAmt                        MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(3) = ToAmt / 10                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(3) = ToAmt / 100                  MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(3) = ToAmt / 1000                 MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                           MD027684A
     C********           EVAL      FromAmt = AcctBalance(4)                                 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(4)                       MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(4) * 10                  MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(4) * 100                 MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(4) * 1000                MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                               MD027684A
     C********           EVAL      AcctBalanceL(4) = ToAmt                                  MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(4) = ToAmt                        MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(4) = ToAmt / 10                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(4) = ToAmt / 100                  MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                                        MD027292
     C**********         EVAL(H)   AcctBalanceL(4) = ToAmt / 1000                           MD027292
     C**********         Endsl                                                              MD027292
      **********                                                                           MD027684A
     C********           EVAL      FromAmt = AcctBalance(5)                                 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(5)                       MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(5) * 10                  MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(5) * 100                 MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = AcctBalance(5) * 1000                MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                               MD027684A
     C********           EVAL      AcctBalanceL(5) = ToAmt                                  MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(5) = ToAmt                        MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(5) = ToAmt / 10                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(5) = ToAmt / 100                  MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   AcctBalanceL(5) = ToAmt / 1000                 MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                           MD027684A
      ***Prono Total Balance                                                               MD027684A
     C********           EVAL      FromAmt = PronoBalance(1)                                MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(1)                      MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(1) * 10                 MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(1) * 100                MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(1) * 1000               MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                               MD027684A
     C********           EVAL      PronoBalanceL(1) = ToAmt                                 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(1) = ToAmt                       MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(1) = ToAmt / 10                  MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(1) = ToAmt / 100                 MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(1) = ToAmt / 1000                MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                  MD027292 MD027684A
     C********           EVAL      FromAmt = PronoBalance(2)                                MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(2)                      MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(2) * 10                 MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(2) * 100                MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(2) * 1000               MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                      MD027292 MD027684A
     C********           EVAL      PronoBalanceL(2) = ToAmt                                 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(2) = ToAmt                       MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(2) = ToAmt / 10                  MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(2) = ToAmt / 100                 MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(2) = ToAmt / 100                 MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A

     C********           EVAL      FromAmt = PronoBalance(3)                      MD027292 MD027684A
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(3)                      MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(3) * 10                 MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(3) * 100                MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(3) * 1000               MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                      MD027292 MD027684A
     C********           EVAL      PronoBalanceL(3) = ToAmt                                 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(3) = ToAmt                       MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(3) = ToAmt / 10                  MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(3) = ToAmt / 100                 MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(3) = ToAmt / 1000                MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                           MD027684A
     C********           EVAL      FromAmt = PronoBalance(4)                                MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(4)                      MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(4) * 10                 MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(4) * 100                MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(4) * 1000               MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                               MD027684A
     C********           EVAL      PronoBalanceL(4) = ToAmt                                 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(4) = ToAmt                       MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(4) = ToAmt / 10                  MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(4) = ToAmt / 100                 MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(4) = ToAmt / 1000                MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                           MD027684A
     C********           EVAL      FromAmt = PronoBalance(5)                                MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(5)                      MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(5) * 10                 MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(5) * 100                MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = PronoBalance(5) * 1000               MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                      MD027292 MD027684A
     C********           EVAL      PronoBalanceL(5) = ToAmt                                 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(5) = ToAmt                       MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(5) = ToAmt / 10                  MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(5) = ToAmt / 100                 MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   PronoBalanceL(5) = ToAmt / 1000                MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                  MD027292 MD027684A
      ***Forecast Total Balance                                                            MD027684A
     C********           EVAL      FromAmt = OForBalance(1)                                 MD027224
     C********           EVAL      FromAmt = ForTBalance(1)                        MD027224 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(1)                       MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(1) * 10                  MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(1) * 100                 MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL      FromAmt = ForTBalance(1) * 1000                MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                      MD027292 MD027684A
     C********           EVAL      OForBalanceL(1) = ToAmt                                  MD027224
     C********           EVAL      ForTBalanceL(1) = ToAmt                         MD027224 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(1) = ToAmt                        MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(1) = ToAmt / 10                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(1) = ToAmt / 100                  MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(1) = ToAmt / 1000                 MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                           MD027684A
     C********           EVAL      FromAmt = OForBalance(2)                                 MD027224
     C********           EVAL      FromAmt = ForTBalance(2)                        MD027224 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(2)                       MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(2) * 10                  MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(2) * 100                 MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(2) * 1000                MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                      MD027292 MD027684A
     C********           EVAL      OForBalanceL(2) = ToAmt                                  MD027224
     C********           EVAL      ForTBalanceL(2) = ToAmt                         MD027224 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(2) = ToAmt                        MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(2) = ToAmt / 10                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(2) = ToAmt / 100                  MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(2) = ToAmt / 1000                 MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                           MD027684A
     C********           EVAL      FromAmt = OForBalance(3)                                 MD027224
     C********           EVAL      FromAmt = ForTBalance(3)                        MD027224 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(3)                       MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(3) * 10                  MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(3) * 100                 MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(3) * 1000                MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                               MD027684A
     C********           EVAL      OForBalanceL(3) = ToAmt                                  MD027224
     C********           EVAL      ForTBalanceL(3) = ToAmt                         MD027224 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(3) = ToAmt                        MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(3) = ToAmt / 10                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(3) = ToAmt / 100                  MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(3) = ToAmt / 1000                 MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                           MD027684A
     C********           EVAL      FromAmt = OForBalance(4)                                 MD027224
     C********           EVAL      FromAmt = ForTBalance(4)                        MD027224 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(4)                       MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(4) * 10                  MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(4) * 100                 MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(4) * 1000                MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                               MD027684A
     C********           EVAL      OForBalanceL(4) = ToAmt                                  MD027224
     C********           EVAL      ForTBalanceL(4) = ToAmt                         MD027224 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(4) = ToAmt                        MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(4) = ToAmt / 10                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(4) = ToAmt / 100                  MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(4) = ToAmt / 1000                 MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                           MD027684A
     C********           EVAL      FromAmt = OForBalance(5)                                 MD027224
     C********           EVAL      FromAmt = ForTBalance(5)                        MD027224 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(5)                       MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(5) * 10                  MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(5) * 100                 MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ForTBalance(5) * 1000                MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                               MD027684A
     C********           EVAL      OForBalanceL(5) = ToAmt                                  MD027224
     C********           EVAL      ForTBalanceL(5) = ToAmt                         MD027224 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(5) = ToAmt                        MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(5) = ToAmt / 10                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(5) = ToAmt / 100                  MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   ForTBalanceL(5) = ToAmt / 1000                 MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                           MD027684A
      ***RT*postings Total Balance                                                MD027208 MD027684A
     C********           EVAL      FromAmt = RTimBalance(1)                        MD027208 MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = RTimBalance(1)                       MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = RTimBalance(1) * 10                  MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = RTimBalance(1) * 100                 MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = RTimBalance(1) * 1000                MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                               MD027684A
     C********           EVAL      RTimBalanceL(1) = ToAmt                                  MD027208
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   RTimBalanceL(1) = ToAmt                        MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   RTimBalanceL(1) = ToAmt / 10                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   RTimBalanceL(1) = ToAmt / 100                  MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   RTimBalanceL(1) = ToAmt / 1000                 MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                           MD027684A
     C********           EVAL      FromAmt = RTimBalance(2)                       MD027208 MD027208A
     C********           Exsr      SRConvert                                      MD027208 MD027208A
     C********           EVAL      RTimBalanceL(2) = ToAmt                        MD027208 MD027208A
                                                                                            MD027208
     C********           EVAL      FromAmt = RTimBalance(3)                       MD027208 MD027208A
     C********           Exsr      SRConvert                                      MD027208 MD027208A
     C********           EVAL      RTimBalanceL(3) = ToAmt                        MD027208 MD027208A
                                                                                            MD027208
     C********           EVAL      FromAmt = RTimBalance(4)                       MD027208 MD027208A
     C********           Exsr      SRConvert                                      MD027208 MD027208A
     C********           EVAL      RTimBalanceL(4) = ToAmt                        MD027208 MD027208A
                                                                                            MD027208
     C********           EVAL      FromAmt = RTimBalance(5)                       MD027208 MD027208A
     C********           Exsr      SRConvert                                      MD027208 MD027208A
     C********           EVAL      RTimBalanceL(5) = ToAmt                        MD027208 MD027208A
      **********                                                                           MD027684A
      ***Group*Total Balance                                                               MD027684A
     C********           EVAL      FromAmt = ToTBalance(1)                                  MD027292
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(1)                        MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(1) * 10                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(1) * 100                  MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(1) * 1000                 MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                               MD027684A
     C********           EVAL      TotBalanceL(1) = ToAmt                         MD027292 MD027684A
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(1) = ToAmt                         MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(1) = ToAmt / 10                    MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(1) = ToAmt / 100                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(1) = ToAmt / 1000                  MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                           MD027684A
     C********           EVAL      FromAmt = ToTBalance(2)                        MD027292 MD027684A
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(2)                        MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(2) * 10                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(2) * 100                  MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(2) * 1000                 MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                               MD027684A
     C********           EVAL      TotBalanceL(2) = ToAmt                         MD027292 MD027684A
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(2) = ToAmt                         MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(2) = ToAmt / 10                    MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(2) = ToAmt / 100                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(2) = ToAmt / 1000                  MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                           MD027684A
     C********           EVAL      FromAmt = ToTBalance(3)                        MD027292 MD027684A
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(3)                        MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(3) * 10                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(3) * 100                  MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(3) * 1000                 MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                               MD027684A
     C********           EVAL      TotBalanceL(3) = ToAmt                         MD027292 MD027684A
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(3) = ToAmt                         MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(3) = ToAmt / 10                    MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(3) = ToAmt / 100                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(3) = ToAmt / 1000                  MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                           MD027684A
     C********           EVAL      FromAmt = ToTBalance(4)                        MD027292 MD027684A
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(4)                        MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(4) * 10                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(4) * 100                  MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(4) * 1000                 MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                               MD027684A
     C********           EVAL      TotBalanceL(4) = ToAmt                         MD027292 MD027684A
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(4) = ToAmt                         MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(4) = ToAmt / 10                    MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(4) = ToAmt / 100                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(4) = ToAmt / 1000                  MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                           MD027684A
     C********           EVAL      FromAmt = ToTBalance(5)                        MD027292 MD027684A
     C**********         Select                                                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(5)                        MD027292 MD027684A
     C*****Bjnbdp        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(5) * 10                   MD027292 MD027684A
     C*****Bjnbdp        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(5) * 100                  MD027292 MD027684A
     C*****Bjnbdp        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   FromAmt = ToTBalance(5) * 1000                 MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
     C**********         Exsr      SRConvert                                               MD027684A
     C********           EVAL      TotBalanceL(5) = ToAmt                         MD027292 MD027684A
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(5) = ToAmt                         MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(5) = ToAmt / 10                    MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(5) = ToAmt / 100                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         EVAL(H)   TotBalanceL(5) = ToAmt / 1000                  MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A
      **********                                                                           MD027684A
     C**********         Else                                                              MD027684A
      *
      ** General Ledger Total Balance
     C                   EVAL      AcctBalanceL(1) = AcctBalance(1)
     C                   EVAL      AcctBalanceL(2) = AcctBalance(2)
     C                   EVAL      AcctBalanceL(3) = AcctBalance(3)
     C                   EVAL      AcctBalanceL(4) = AcctBalance(4)
     C                   EVAL      AcctBalanceL(5) = AcctBalance(5)

      ** Prono Total Balance
     C                   EVAL      PronoBalanceL(1) = PronoBalance(1)
     C                   EVAL      PronoBalanceL(2) = PronoBalance(2)
     C                   EVAL      PronoBalanceL(3) = PronoBalance(3)
     C                   EVAL      PronoBalanceL(4) = PronoBalance(4)
     C                   EVAL      PronoBalanceL(5) = PronoBalance(5)

      ** Forecast Total Balance
     C********           EVAL      OForBalanceL(1) = OForBalance(1)                         MD027224
     C********           EVAL      OForBalanceL(2) = OForBalance(2)                         MD027224
     C********           EVAL      OForBalanceL(3) = OForBalance(3)                         MD027224
     C********           EVAL      OForBalanceL(4) = OForBalance(4)                         MD027224
     C********           EVAL      OForBalanceL(5) = OForBalance(5)                         MD027224
     C                   EVAL      ForTBalanceL(1) = ForTBalance(1)                         MD027224
     C                   EVAL      ForTBalanceL(2) = ForTBalance(2)                         MD027224
     C                   EVAL      ForTBalanceL(3) = ForTBalance(3)                         MD027224
     C                   EVAL      ForTBalanceL(4) = ForTBalance(4)                         MD027224
     C                   EVAL      ForTBalanceL(5) = ForTBalance(5)                         MD027224
                                                                                            MD027208
      ***Forecast*Total*Balance                                                   MD027208 MD027208A
      ** Real Time Post Total Balance                                                      MD027208A
     C                   EVAL      RTimBalanceL(1) = RTimBalance(1)                        MD027208
     C********           EVAL      RTimBalanceL(2) = RTimBalance(2)               MD027208 MD027208A
     C********           EVAL      RTimBalanceL(3) = RTimBalance(3)               MD027208 MD027208A
     C********           EVAL      RTimBalanceL(4) = RTimBalance(4)               MD027208 MD027208A
     C********           EVAL      RTimBalanceL(5) = RTimBalance(5)               MD027208 MD027208A

      ** Group Total Balance
     C                   EVAL      TotBalanceL(1) = TotBalance(1)
     C                   EVAL      TotBalanceL(2) = TotBalance(2)
     C                   EVAL      TotBalanceL(3) = TotBalance(3)
     C                   EVAL      TotBalanceL(4) = TotBalance(4)
     C                   EVAL      TotBalanceL(5) = TotBalance(5)

     C**********         Endif                                                             MD027684A

     C                   eval      Given = *Blanks

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUpdate  - Update GLFRBLTD                                   *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrUpdate      BEGSR

     C                   Exsr      SrDelGTot

     C                   z-add     1             WCount            1 0
     C                   Dow       WCount <= 5

     C                   Select
     C     WCount        Wheneq    1
     C                   eval      PDate = LDat0
     C**********         eval      PLBal = AcctBalanceL(1)                                  MD027684
     C**********         eval      PPBal = PronoBalanceL(1)                                 MD027684
     C********           eval      PFBal = OForBalanceL(1)                                  MD027224
     C**********         eval      PFBal = ForTBalanceL(1)                         MD027224 MD027684
     C**********         eval      PTBal = TotBalanceL(1)                                   MD027684
     C**********         eval      PRBal = RTimBalanceL(1)                         MD027208 MD027684
     C**********         eval      PLBalS3 = AcctBalanceL(1)                      MD027684 MD027684A
     C**********         eval      PPBalS3 = PronoBalanceL(1)                     MD027684 MD027684A
     C**********         eval      PFBalS3 = ForTBalanceL(1)                      MD027684 MD027684A
     C**********         eval      PTBalS3 = TotBalanceL(1)                       MD027684 MD027684A
     C**********         eval      PRBalS3 = RTimBalanceL(1)                      MD027684 MD027684A
     C                   eval      PLBal = AcctBalanceL(1)                                 MD027684A
     C                   eval      PPBal = PronoBalanceL(1)                                MD027684A
     C                   eval      PFBal = ForTBalanceL(1)                                 MD027684A
     C                   eval      PTBal = TotBalanceL(1)                                  MD027684A
     C                   eval      PRBal = RTimBalanceL(1)                                 MD027684A
     C     WCount        Wheneq    2
     C                   eval      PDate = LDat1
     C**********         eval      PLBal = AcctBalanceL(2)                                  MD027684
     C**********         eval      PPBal = PronoBalanceL(2)                                 MD027684
     C********           eval      PFBal = OForBalanceL(2)                                  MD027224
     C**********         eval      PFBal = ForTBalanceL(2)                         MD027224 MD027684
     C**********         eval      PTBal = TotBalanceL(2)                                   MD027684
     C********           eval      PRBal = RTimBalanceL(2)                        MD027208 MD027208A
     C**********         eval      PRBal = 0                                      MD027208A MD027684
     C**********         eval      PLBalS3 = AcctBalanceL(2)                      MD027684 MD027684A
     C**********         eval      PPBalS3 = PronoBalanceL(2)                     MD027684 MD027684A
     C**********         eval      PFBalS3 = ForTBalanceL(2)                      MD027684 MD027684A
     C**********         eval      PTBalS3 = TotBalanceL(2)                       MD027684 MD027684A
     C**********         eval      PRBalS3 = 0                                    MD027684 MD027684A
     C                   eval      PLBal = AcctBalanceL(2)                                 MD027684A
     C                   eval      PPBal = PronoBalanceL(2)                                MD027684A
     C                   eval      PFBal = ForTBalanceL(2)                                 MD027684A
     C                   eval      PTBal = TotBalanceL(2)                                  MD027684A
     C                   eval      PRBal = 0                                               MD027684A
     C     WCount        Wheneq    3
     C                   eval      PDate = LDat2
     C***********        eval      PLBal = AcctBalanceL(3)                                  MD027684
     C***********        eval      PPBal = PronoBalanceL(3)                                 MD027684
     C********           eval      PFBal = OForBalanceL(3)                                  MD027224
     C***********        eval      PFBal = ForTBalanceL(3)                         MD027224 MD027684
     C***********        eval      PTBal = TotBalanceL(3)                                   MD027684
     C********           eval      PRBal = RTimBalanceL(3)                        MD027208 MD027208A
     C***********        eval      PRBal = 0                                      MD027208A MD027684
     C**********         eval      PLBalS3 = AcctBalanceL(3)                      MD027684 MD027684A
     C**********         eval      PPBalS3 = PronoBalanceL(3)                     MD027684 MD027684A
     C**********         eval      PFBalS3 = ForTBalanceL(3)                      MD027684 MD027684A
     C**********         eval      PTBalS3 = TotBalanceL(3)                       MD027684 MD027684A
     C**********         eval      PRBalS3 = 0                                    MD027684 MD027684A
     C                   eval      PLBal = AcctBalanceL(3)                                 MD027684A
     C                   eval      PPBal = PronoBalanceL(3)                                MD027684A
     C                   eval      PFBal = ForTBalanceL(3)                                 MD027684A
     C                   eval      PTBal = TotBalanceL(3)                                  MD027684A
     C                   eval      PRBal = 0                                               MD027684A
     C     WCount        Wheneq    4
     C                   eval      PDate = LDat3
     C***********        eval      PLBal = AcctBalanceL(4)                                  MD027684
     C***********        eval      PPBal = PronoBalanceL(4)                                 MD027684
     C********           eval      PFBal = OForBalanceL(4)                                  MD027224
     C***********        eval      PFBal = ForTBalanceL(4)                         MD027224 MD027684
     C***********        eval      PTBal = TotBalanceL(4)                                   MD027684
     C********           eval      PRBal = RTimBalanceL(4)                        MD027208 MD027208A
     C***********        eval      PRBal = 0                                      MD027208A MD027684
     C**********         eval      PLBalS3 = AcctBalanceL(4)                      MD027684 MD027684A
     C**********         eval      PPBalS3 = PronoBalanceL(4)                     MD027684 MD027684A
     C**********         eval      PFBalS3 = ForTBalanceL(4)                      MD027684 MD027684A
     C**********         eval      PTBalS3 = TotBalanceL(4)                       MD027684 MD027684A
     C**********         eval      PRBalS3 = 0                                    MD027684 MD027684A
     C                   eval      PLBal = AcctBalanceL(4)                                 MD027684A
     C                   eval      PPBal = PronoBalanceL(4)                                MD027684A
     C                   eval      PFBal = ForTBalanceL(4)                                 MD027684A
     C                   eval      PTBal = TotBalanceL(4)                                  MD027684A
     C                   eval      PRBal = 0                                               MD027684A
     C     WCount        Wheneq    5
     C                   eval      PDate = LDat4
     C***********        eval      PLBal = AcctBalanceL(5)                                  MD027684
     C***********        eval      PPBal = PronoBalanceL(5)                                 MD027684
     C********           eval      PFBal = OForBalanceL(5)                                  MD027224
     C***********        eval      PFBal = ForTBalanceL(5)                         MD027224 MD027684
     C***********        eval      PTBal = TotBalanceL(5)                                   MD027684
     C********           eval      PRBal = RTimBalanceL(5)                        MD027208 MD027208A
     C***********        eval      PRBal = 0                                      MD027208A MD027684
     C**********         eval      PLBalS3 = AcctBalanceL(5)                      MD027684 MD027684A
     C**********         eval      PPBalS3 = PronoBalanceL(5)                     MD027684 MD027684A
     C**********         eval      PFBalS3 = ForTBalanceL(5)                      MD027684 MD027684A
     C**********         eval      PTBalS3 = TotBalanceL(5)                       MD027684 MD027684A
     C**********         eval      PRBalS3 = 0                                    MD027684 MD027684A
     C                   eval      PLBal = AcctBalanceL(5)                                 MD027684A
     C                   eval      PPBal = PronoBalanceL(5)                                MD027684A
     C                   eval      PFBal = ForTBalanceL(5)                                 MD027684A
     C                   eval      PTBal = TotBalanceL(5)                                  MD027684A
     C                   eval      PRBal = 0                                               MD027684A
     C                   Endsl
      **********                                                                  MD027292 MD027684A
     C**********         Select                                                   MD027292 MD027684A
     C*****WNbdp2        Wheneq    0                                              MD027292 MD027684A
     C**********         eval      PLBalS0 = PLBalS3                              MD027292 MD027684A
     C**********         eval      PPBalS0 = PPBalS3                              MD027292 MD027684A
     C**********         eval      PFBalS0 = PFBalS3                              MD027292 MD027684A
     C**********         eval      PTBalS0 = PTBalS3                              MD027292 MD027684A
     C**********         eval      PRBalS0 = PRBalS3                              MD027292 MD027684A
     C**********         move      PLBalS0       PLBal                            MD027292 MD027684A
     C**********         move      PPBalS0       PPBal                            MD027292 MD027684A
     C**********         move      PFBalS0       PFBal                            MD027292 MD027684A
     C**********         move      PTBalS0       PTBal                            MD027292 MD027684A
     C**********         move      PRBalS0       PRBal                            MD027292 MD027684A
     C*****WNbdp2        Wheneq    1                                              MD027292 MD027684A
     C**********         eval      PLBalS1 = PLBalS3                              MD027292 MD027684A
     C**********         eval      PPBalS1 = PPBalS3                              MD027292 MD027684A
     C**********         eval      PFBalS1 = PFBalS3                              MD027292 MD027684A
     C**********         eval      PTBalS1 = PTBalS3                              MD027292 MD027684A
     C**********         eval      PRBalS1 = PRBalS3                              MD027292 MD027684A
     C**********         move      PLBalS1       PLBal                            MD027292 MD027684A
     C**********         move      PPBalS1       PPBal                            MD027292 MD027684A
     C**********         move      PFBalS1       PFBal                            MD027292 MD027684A
     C**********         move      PTBalS1       PTBal                            MD027292 MD027684A
     C**********         move      PRBalS1       PRBal                            MD027292 MD027684A
     C*****WNbdp2        Wheneq    2                                              MD027292 MD027684A
     C**********         eval      PLBalS2 = PLBalS3                              MD027292 MD027684A
     C**********         eval      PPBalS2 = PPBalS3                              MD027292 MD027684A
     C**********         eval      PFBalS2 = PFBalS3                              MD027292 MD027684A
     C**********         eval      PTBalS2 = PTBalS3                              MD027292 MD027684A
     C**********         eval      PRBalS2 = PRBalS3                              MD027292 MD027684A
     C**********         move      PLBalS2       PLBal                            MD027292 MD027684A
     C**********         move      PPBalS2       PPBal                            MD027292 MD027684A
     C**********         move      PFBalS2       PFBal                            MD027292 MD027684A
     C**********         move      PTBalS2       PTBal                            MD027292 MD027684A
     C**********         move      PRBalS2       PRBal                            MD027292 MD027684A
     C*****WNbdp2        Wheneq    3                                              MD027292 MD027684A
     C**********         move      PLBalS3       PLBal                            MD027292 MD027684A
     C**********         move      PPBalS3       PPBal                            MD027292 MD027684A
     C**********         move      PFBalS3       PFBal                            MD027292 MD027684A
     C**********         move      PTBalS3       PTBal                            MD027292 MD027684A
     C**********         move      PRBalS3       PRBal                            MD027292 MD027684A
     C**********         Endsl                                                    MD027292 MD027684A

     C/Exec SQL
     C+ insert into GLFRBLTD
     C+ (
     C+  FCGRPC
     C+ ,FCGCCY
     C+ ,FCDATE
     C+ ,FCLBAL
     C+ ,FCPBAL
     C+ ,FCFBAL
     C+ ,FCTBAL
     C+ ,FCZONE
     C+ ,FCRTBL                                                                             MD027208
     C+ )
     C+ Values
     C+ (
     C+  :PGrpc
     C+ ,:PLCcy
     C+ ,:PDate
     C+ ,:PLBal
     C+ ,:PPBal
     C+ ,:PFBal
     C+ ,:PTBal
     C+ ,:PZone
     C+ ,:PRBal                                                                             MD027208
     C+ )
     C/End-Exec

     C                   add       1             WCount
     C                   Enddo

     C                   eval      WUpdate = 'Y'

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRConvert - Convert Currency                                  *
      *                                                               *
      *****************************************************************

     C     SRConvert     BEGSR

      ** If one of currencies is blank, skip conversion

     C                   If        FromCcy = *Blanks or ToCcy = *Blanks
     C                   eval      ToAmt = 0
     C                   Else

      ** From currency
     C                   Call      'AOCURRR0'
     C                   Parm      *Blanks       Prtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm                    FromCcy
     C     SDCURR        Parm      SDCURR        DSSDY

     C                   If        PRtcd <> *BLANKS
     C                   Eval      DBFILE = 'SDCURRPD'
     C                   Eval      DBASE = 11
     C                   Eval      DBKEY = FromCcy
     C                   Exsr      *PSSR
     C                   Endif

     C                   Eval      WNbdp1 = A6NBDP
     C                   If        Given = 'N'
     C                   eval      WRate1 = A6SPRT
     C                   eval      WMdin1 = A6MDIN
     C                   Endif

      ** To currency
     C                   Call      'AOCURRR0'
     C                   Parm      *Blanks       PRtcd
     C                   Parm      '*KEY   '     POptn
     C                   Parm                    ToCcy
     C     SDCURR        Parm      SDCURR        DSSDY

     C                   If        PRTCD <> *BLANKS
     C                   Eval      DBFILE = 'SDCURRPD'
     C                   Eval      DBASE = 12
     C                   Eval      DBKEY = ToCcy
     C                   Exsr      *PSSR
     C                   Endif

     C                   EVAL      WNbdp2 = A6NBDP
     C                   If        Given = 'N'
     C                   eval      WRate2 = A6SPRT
     C                   eval      WMdin2 = A6MDIN
     C                   Endif

     C                   If        Given = 'N'

      ** Get exchange rate

     C                   eval      XMDIN1 = WMDIN1
     C                   eval      XMDIN2 = WMDIN2
     C                   eval      XRate1 = WRate1
     C                   eval      XRate2 = WRate2

     C                   Call      'ZXRATE'
     C                   Parm                    XRate1
     C                   Parm                    XMDIN1
     C                   Parm                    XRate2
     C                   Parm                    XMDIN2
     C                   Parm                    WRATE
     C                   Parm                    WMDIN
     C                   Endif

      ** Convert amount
     C                   Call      'ZCONVZ1'
     C                   Parm                    FromAmt
     C                   Parm                    WRate
     C                   Parm                    WMdin
     C                   Parm                    FromCcy
     C                   Parm                    ToCcy
     C                   Parm                    WNbdp1
     C                   Parm                    WNbdp2
     C                   Parm                    ToAmt

     C                   Endif

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZFWDT    - Get next Nth working day                           *
      *                                                               *
      *****************************************************************

     C     ZFWDT         BEGSR

     C                   CALL      'ZFWDT'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZNRDYS
     C                   PARM      *ZERO         ZDYNBR
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *        AOSARDR0                                               *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    FGLData

     C     PAccntab      PLIST
     C                   PARM      '*BLANKS'     PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PAcno
     C                   PARM                    PCusn
     C                   PARM                    PCurr
     C                   PARM                    PACod
     C                   PARM                    PASeq
     C                   PARM                    PBrch
     C     GLACNT        PARM      '*BLANKS'     DSSDY

     C     PAoNost       PLIST
     C                   PARM      '*BLANKS'     PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCusn
     C                   PARM                    PCurr
     C                   PARM                    PAcod
     C                   PARM                    PASeq
     C                   PARM                    PNonb
     C                   PARM                    PBrch
     C                   PARM                    PCssn
     C                   PARM                    PPNoi
     C     SDNOST        PARM      SDNOST        DSFDY

      ** Read in data area

     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = 'GL009071'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBTXT  = *BLANKS
     C                   EVAL      DBASE  = 0
     C                   OUT       LDA

     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT

      ** Access Bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBPGM  =  'AOBANKR0'
     C                   EVAL      DBASE  =  1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                           MD027292
     C                   Call      'AOCURRR0'                                              MD027292
     C                   Parm      *Blanks       Prtcd                                     MD027292
     C                   Parm      '*KEY   '     POptn                                     MD027292
     C                   Parm                    BJCYCD                                    MD027292
     C     SDCURR        Parm      SDCURR        DSSDY                                     MD027292
                                                                                           MD027292
     C                   If        PRtcd <> *BLANKS                                        MD027292
     C                   Eval      DBFILE = 'SDCURRPD'                                     MD027292
     C                   Eval      DBASE = 23                                              MD027292
     C                   Eval      DBKEY = BJCYCD                                          MD027292
     C                   Exsr      *PSSR                                                   MD027292
     C                   else                                                              MD027292
     C                   z-add     A6NBDP        BJNBDP            1 0                     MD027292
     C                   Endif                                                             MD027292

     C     *DTAARA       DEFINE                  MPHAS
     C                   IN        MPHAS

     C/exec SQL
     C+ select * into :DSZN from GPZONEPD
     C+ where
     C+       ZOMSYS = :LIBR
     C/end-exec

     C                   If        SQLCODE = 0
     C                   eval      PZone = ZOZONE
     C                   Endif


     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   ROLBK
     C                   RETURN

     C                   ENDSR

