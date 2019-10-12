     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                       CER070
/*STD *  RPGBASEMOD                                                   *                       CER070
/*EXI *  TEXT('Midas ER Transaction/Account Bal. Extract Process')    *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000193 - Midas ER Transaction/Account Bal. Extract Process *
      *                                                               *
      *  Function: This program creates Transaction and Account       *
      *            Balances extract files for GRI reporting.          *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 MD030247           Date 26Jan15               *
      *                 MD030946           Date 11Dec14               *
      *                 CER070             Date 19Aug14               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26870A          Date 15Jan10               *
      *                 BUG26870           Date 08Jan10               *
      *                 BUG26779           Date 27Nov09               *
      *                 BUG26539           Date 22Oct09               *
      *                 BUG26308           Date 06Oct09               *
      *                 BUG26254           Date 01Oct09               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD030247 - Increase size of GSRE to 21.                      *
      *             Applied for MD032081                              *
      *  MD030946 - Set B3KONK to 'N' rather than blank to prevent    *
      *             problem in MERIDIAN. Applied for MD031621.        *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0                      *
      *           Change compilation directive from RPGBASEBND to     *
      *           RPGBASEMOD and create associated program.           *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT062: Changed Customer No. to alphanumeric         *
      *           (Recompile)                                         *
      *         - LT081: ERC000190-00001 failed.                      *
      *           B4FILN is used as BRCA field in ER000197.           *
      *  BUG26870A - Part Sold Loans should not have a negative sign  *
      *  BUG26870 - Loans must have a negative sign                   *
      *  BUG26779 - Change Request on GSART Table                     *
      *  BUG26539 - Interest date adjustment is incorrect             *
      *  BUG26308 - Change Request - BAIS Mapping table enhancement   *
      *  BUG26254 - Amount is not reflected to csv file extract.      *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    LR - Last record indicator (program termination)           *
      *    U7 and U8 - DB error processing indicator                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcess - Processing subroutine                            *
      *  SRFmtAccTran - Write record to ERGSTIPD                      *
      *  SRFmtAccBal - Write record to ERGSTSPD                       *
      *  SRFmtAccGL -  Write record to ERBILIPD                       *
      *  SRDate - Convert Midas date to YYYYMMDD format               *
      *  SRAudit - Write audit report                                 *
      *  *INZSR  - Initialise                                         *
      *  *PSSR   - Error processing                                   *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas ER BAIS Module Mapping Table

     FERBMODPD  IT   F    4        DISK

      ** Midas GL Accounts by branch

     FACCBR     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AC)

      ** Midas RE Retail accrued Int. to date File

     FREACR     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(REACRAF)
     F                                     IGNORE(REACRZF)

      ** Midas DL Money market & loans deals details

     FDEALSDC   IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(DL)
                                                                                            BUG26870
      ** Midas MM Loan/deposit/CD issued                                                    BUG26870
                                                                                            BUG26870
     FMMDELDL2  IF   E           K DISK    INFSR(*PSSR)                                     BUG26870

      ** Midas LE Customer loans

     FCLOANCL   IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(LE)

      ** Midas ER Account Code Decision Table File

     FERDEACL1  IF   E           K DISK    INFSR(*PSSR)

      ** Midas ER Transaction Type Decision Table File

     FERDETTL1  IF   E           K DISK    INFSR(*PSSR)

      ** Midas ER GRI Master Account/Transaction Balances File

     FERGSTSPD  O    E             DISK

      ** Midas ER GRI Master Account/Transaction File

     FERGSTIPD  O    E             DISK

      ** Midas ER GRI GL Accounts File

     FERBILIPD  O    E             DISK

      ** Midas ER Transaction/Account Balances Extract Audit

     FER000193AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

      ** Array containing Copyright statement

     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

      ** Array from file

     D                 DS
     D ArrModules                     4A   DIM(4) FROMFILE(ERBMODPD)
     D ArMMOD                         2A   OVERLAY(ArrModules:1)
     D ArBAMO                         2A   OVERLAY(ArrModules:*NEXT)

      ** Local data area for database error details

     D LDA           E DS           256    EXTNAME(LDA)

      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      ** Program Status Data Structure

     D/COPY ZACPYSRC,PSDS

      ** Externally described DS for bank details

     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Externally described DS for Currency Codes

     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Externally described DS for Additional Customer Details

     D SDACUS        E DS                  EXTNAME(SDACUSPD)

      ** Externally described DS for System Values

     D SDSVAL        E DS                  EXTNAME(SDSVALPD)

      ** DS for access objects - Long data structure

     D DSLDY         E DS                  EXTNAME(DSLDY)

      ** DS for access objects

     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              CER070
      ** External DS for SAR Details                                                          CER070
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER070

      ** File Information Data Structure for SD0760P1.

     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** File Information Data Structure for ER000193AU.

     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0

      ** Indicator Array

     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             02     02
     D  RecNotFnd             03     03

      ** Account Ref DS

     D*AcctRef**       DS            20                                                     MD030247
     D AcctRef         DS            21                                                     MD030247
     D**ACust***               1      6S 0                                                  MD030247
     D  ACust                  1      6                                                     MD030247
     D  ACcy                   7      9
     D**AAcod***              10     18S 0                                                  MD030247
     D**AAcsq***              19     20S 0                                                  MD030247
     D  AAcod                 10     19S 0                                                  MD030247
     D  AAcsq                 20     21S 0                                                  MD030247
      *                                                                                       CER070
      ** Parameters for ZDATE9                                                                CER070
      *                                                                                       CER070
     D PZDayNo         S              5P 0                                                    CER070
     D PZDate1         S              8S 0                                                    CER070
     D PErrorFlag      S              1A                                                      CER070

      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+

      ** True and False can be used for indicators being on or off.

     D True            C                   *On
     D False           C                   *Off

      ** Constants for system values

     D WKeySysVal1     C                   CONST('BundBILKTCode')
     D WKeySysVal2     C                   CONST('BundClientId')

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for access object programs

     D PRtcd           S              7
     D PDayno          S              5A
     D PFDate          S               D   DATFMT(*ISO)
     D PCDate          S             10A
     D POptn           S              7
     D PCust           S              6
     D PSARd           S              6
     D PSValK1         S             20A
     D PSVal1          S            200A
     D PSValK2         S             20A
     D PSVal2          S            200A
     D PSValK3         S             20A
     D PSVal3          S            200A
     D PSValK4         S             20A
     D PSVal4          S            200A
     D PSValK5         S             20A
     D PSVal5          S            200A
     D PSValK6         S             20A
     D PSVal6          S            200A
     D PSValK7         S             20A
     D PSVal7          S            200A
     D PSValK8         S             20A
     D PSVal8          S            200A
     D PSValK9         S             20A
     D PSVal9          S            200A
     D PSValK0         S             20A
     D PSVal0          S            200A

      ** Parameter list fields

     D PCurr           S              3

      ** Other fields used

     D WBDate          S               D   DATFMT(*ISO)                                     BUG26308
     D WEDate          S               D   DATFMT(*ISO)                                     BUG26308
     D WFDate          S               D   DATFMT(*ISO)                                     BUG26308
     D WYr1            S              4S 0                                                  BUG26308
     D WYr2            S              4S 0                                                  BUG26308
     D WMo1            S              2S 0                                                  BUG26308
     D WMo2            S              2S 0                                                  BUG26308
     D WCYr            S              4A                                                    BUG26308
     D WLeap           S              1A                                                    BUG26308
     D WRun            S              1
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D WMod            S              2
     D WSdate          S              5  0
     D WMdate          S              5  0
     D WBal            S             15  0
     D WNetAcc         S             15  0
     D WTotCAcc        S             15  0
     D WTotDAcc        S             15  0
     D WIx             S              1  0
     D WCcy            S              3
     D WAcct           S             10

     D KMMOD           S              2
     D KTRTY           S              2
     D KTRST           S              2
     D KTRCL           S              4

      ** Pointer for the indicator Array

     D IndicatorP      S               *   INZ(%Addr(*IN))

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   EXSR      SRProcess
     C                   EVAL      *INLR  = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Processing subroutine                            *
      *                                                               *
      *****************************************************************

     C     SRProcess     BEGSR

      ** Process Account Balances
      ** Set file pointer to first record and do initial read.

     C     *LOVAL        SETLL     ACCBR
     C                   READ      ACCBR

     C                   DOW       NOT %EOF(ACCBR)

     C                   IF        ACRECI = 'D'

      ** Process only records to be Extracted to GRI.

     C                   MOVE      ACACOD        WAcct
     C     WAcct         CHAIN     ERDEACL1
     C                   IF        %FOUND() AND
     C                             N3GRI = 'Y'

     C                   MOVE      ACCNUM        PCust
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCust
     C     SDACUS        PARM      SDACUS        DSLDY

     C                   IF        PRtcd   = *BLANKS

     C                   IF        E5BEXT  = 'Y'

     C                   EVAL      WNetAcc = 0
     C     KACCT         CHAIN     REACR
     C                   IF        %FOUND()

     C                   EVAL      WTotDAcc = DAIC1 + MADI + GADI
     C                   EVAL      WTotCAcc = CAIC1 + MACI + GACI

     C                   EVAL      WNetAcc  = WTotDAcc - WTotCAcc
     C                   ENDIF

     C                   EVAL      WBal = ACLDBL - WNetAcc
     C                   IF        WBal <> 0
     C                   EVAL      WMod = 'RE'
     C                   EXSR      SRFmtAccTran
     C                   EXSR      SRFmtAccBal
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Read next record.

     C                   READ      ACCBR

     C                   ENDDO

      ** Process Transaction Details - DL
      ** Set file pointer to first record and do initial read.

     C                   EVAL      WMod = 'MM'
     C                   READ      DEALSDC

     C                   DOW       NOT %EOF()

     C                   IF        DLRECI = 'D'

     C                   EVAL      KMMOD = WMod
     C                   EVAL      KTRTY = DLDTYP
     C                   EVAL      KTRST = DLDLST
     C                   EVAL      KTRCL = DLCLAS
     C     KTRAN         CHAIN     ERDETTL1

     C                   IF        %FOUND() AND
     C                             N4GRI = 'Y'
     C                   MOVE      DLCNUM        PCust
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCust
     C     SDACUS        PARM      SDACUS        DSLDY

     C                   IF        PRtcd   = *BLANKS

     C                   IF        E5BEXT  = 'Y'
     C                   EXSR      SRFmtAccTran
     C                   EXSR      SRFmtAccBal
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   READ      DEALSDC
     C                   ENDDO

      ** Process Transaction Details - LE
      ** Set file pointer to first record and do initial read.

     C                   EVAL      WMod = 'LE'
     C                   READ      CLOANCL

     C                   DOW       NOT %EOF()

     C                   IF        LERECI = 'D' AND
     C                             LELSTS = 'A'

     C                   EVAL      KMMOD = WMod
     C                   EVAL      KTRTY = LELTYP
     C                   EVAL      KTRST = LESUTP
     C                   EVAL      KTRCL = LECLAS
     C     KTRAN         CHAIN     ERDETTL1

     C                   IF        %FOUND() AND
     C                             N4GRI = 'Y'
     C                   MOVE      LECNUM        PCust
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCust
     C     SDACUS        PARM      SDACUS        DSLDY

     C                   IF        PRtcd   = *BLANKS

     C                   IF        E5BEXT  = 'Y'
     C                   EXSR      SRFmtAccTran
     C                   EXSR      SRFmtAccBal
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   READ      CLOANCL
     C                   ENDDO

      ** Write to Extract file ERBILIPD

     C                   EXSR      SRFmtAccGL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAccTran -  Write record to ERGSTIPD                     *
      *                                                               *
      *****************************************************************

     C     SRFmtAccTran  BEGSR

     C                   CLEAR                   ERGSTID0

     C                   EVAL      B3MDAN = PSVal2
     C                   SELECT

     C                   WHEN      WMod   = 'RE'
     C                   EVAL      B3FILN = ACBRCA
     C**********         EVAL      B3KDNR = ACCNUM                                            CER059
     C                   MOVEL     ACCNUM        B3KDNR                                       CER059
     C                   IF        ACACNO = 0
     C**********         EVAL      ACust  = ACCNUM                                            CER059
     C                   MOVEL     ACCNUM        ACust                                        CER059
     C                   EVAL      ACcy   = ACCCY
     C                   EVAL      AAcod  = ACACOD
     C                   EVAL      AAcsq  = ACACSQ
     C                   EVAL      B3GSRE = AcctRef
     C                   ELSE
     C                   MOVEL     ACACNO        B3GSRE
     C                   ENDIF
     C                   EVAL      B3GSKL = N3BUCL
     C                   MOVE      N3BUSU        B3SUKL
     C                   EVAL      B3GSAR = N3BUTY                                          BUG26779
     C                   EVAL      WCcy   = ACCCY
     C                   EVAL      WSDate = ACDACO
     C                   EVAL      B3DXBS = 0
     C********           EVAL      B3KONK = ' '                                      CER070 MD030946
     C                   EVAL      B3KONK = 'N'                                             MD030946

     C                   WHEN      WMod   = 'MM'
     C                   EVAL      B3FILN = DLBRCA
     C**********         EVAL      B3KDNR = DLCNUM                                            CER059
     C                   MOVEL     DLCNUM        B3KDNR                                       CER059
     C                   MOVEL     DLDLNO        B3GSRE
     C                   EVAL      B3GSKL = N4BUCL
     C                   MOVE      N4BUSU        B3SUKL
     C                   EVAL      B3GSAR = N4BUTY                                          BUG26779
     C                   EVAL      WCcy   = DLCCY
     C                   EVAL      WSDate = DLVDAT
     C                   EVAL      WMDate = DLMDAT
     C**********         EVAL      B3KONK = ' '                                      CER070 MD030946
     C                   EVAL      B3KONK = 'N'                                             MD030946

     C                   WHEN      WMod   = 'LE'
     C                   EVAL      B3FILN = LEBRCA
     C**********         EVAL      B3KDNR = LECNUM                                            CER059
     C                   MOVEL     LECNUM        B3KDNR                                       CER059
     C                   MOVEL     LELNRF        B3GSRE
     C                   EVAL      B3GSKL = N4BUCL
     C                   MOVE      N4BUSU        B3SUKL
     C                   EVAL      B3GSAR = N4BUTY                                          BUG26779
     C                   EVAL      WCcy   = LECCY
     C                   EVAL      WSDate = LEVDAT
     C                   EVAL      WMDate = LEMDAT
                                                                                              CER070
      ** If "CLE006 - Syndication" is installed and "Linked to Syndicate" 'Y'                 CER070
     C                   IF        CLE006 = 'Y' AND                                           CER070
     C                             LELNKS = 'Y'                                               CER070
     C                   EVAL      B3KONK = 'J'                                               CER070
     C                   ELSE                                                                 CER070
     C                   EVAL      B3KONK = 'N'                                               CER070
     C                   ENDIF                                                                CER070
     C                   ENDSL

     C                   EVAL      B3WHIS = WCcy
     C                   MOVE      WSDate        PDayno
     C                   EXSR      SRDate
     C                   MOVE      PFDate        B3DXVN
     C                   IF        WMDate = 0
     C                   IF        WMod  <> 'RE'
     C                   EVAL      B3DXBS = 99999999
     C                   ENDIF
     C                   ELSE
     C                   MOVE      WMDate        PDayno
     C                   EXSR      SRDate
     C                   MOVE      PFDate        B3DXBS
     C                   ENDIF

     C                   EVAL      WIx    = %LOOKUP(WMod:ArMMOD:1)
     C                   IF        WIx   <> 0
     C                   EVAL      B3MODU = ArBAMO(WIx)
     C                   ENDIF
     C                   IF        WMod   = 'RE' AND
     C                             N3BUCL = 'SK'
     C                   EVAL      B3MODU = N3BUCL
     C                   ENDIF
     C                   IF        WMod   = 'RE'
     C                   EVAL      B3KTON = ACACNO
     C                   ENDIF
     C                   MOVEL     PSVal1        B3BILK
     C                   EVAL      B3GSAR = '00'
     C                   EVAL      B3VERK = '0'
     C                   EVAL      B3KZRE = 'J'
     C                   EVAL      B3HBKZ = 'A'
     C                   EVAL      B3KZLS = 'N'
     C                   EVAL      B3HAFI = 'N'
     C                   EVAL      B3AWVK = 'K'

     C                   EVAL      B3AUSF = 'N'
     C                   EVAL      B3RANG = 1
     C                   EVAL      B3IFNA = 'MIDAS PLUS'
     C                   EVAL      B3KZUE = 'N'                                             BUG26308
                                                                                            BUG26308
     C                   IF        WMod   = 'MM' AND                                        BUG26308
     C                             DLNOTD > 0                                               BUG26308
     C                   EVAL      B3KFRI = 24                                              BUG26308
     C                   IF        DLNOTD > 365                                             BUG26308
     C                   MOVE      BJRDNB        PDayno                                     BUG26308
     C                   EXSR      SRDate                                                   BUG26308
     C                   MOVE      PFDate        WBDate                                     BUG26308
     C                   EVAL      WEDate = WBDate + %DAYS(DLNOTD)                          BUG26308
     C                   EXSR      SRLeap                                                   BUG26308
     C                   IF        WLeap  =  'Y'                                            BUG26308
     C                   IF        DLNOTD > 366                                             BUG26308
     C                   EVAL      B3KFRI = 31                                              BUG26308
     C                   ENDIF                                                              BUG26308
     C                   IF        DLNOTD > 731                                             BUG26308
     C                   EVAL      B3KFRI = 41                                              BUG26308
     C                   ENDIF                                                              BUG26308
     C                   ELSE                                                               BUG26308
     C                   EVAL      B3KFRI = 31                                              BUG26308
     C                   IF        DLNOTD > 730                                             BUG26308
     C                   EVAL      B3KFRI = 41                                              BUG26308
     C                   ENDIF                                                              BUG26308
     C                   ENDIF                                                              BUG26308
     C                   ENDIF                                                              BUG26308
     C                   ENDIF                                                              BUG26308
                                                                                            BUG26308
     C                   IF        WMod   = 'LE' AND                                        BUG26308
     C                             LECCY  = 'EUR'                                           BUG26308
     C                             AND LERLDT <> 0                                          BUG26539
     C                   MOVE      LERLDT        PDayno                                     BUG26308
     C                   EXSR      SRDate                                                   BUG26308
     C                   MOVE      PFDate        B3DXZA                                     BUG26308
     C                   ENDIF                                                              BUG26308
                                                                                              CER070
     C                   MOVE      PZDate1       B3DLDT                                       CER070
     C                   EVAL      B3RISK = E5RIGR                                            CER070

     C                   WRITE     ERGSTID0

     C                   ENDSR
                                                                                            BUG26308
      *****************************************************************                     BUG26308
      /EJECT                                                                                BUG26308
      *****************************************************************                     BUG26308
      *                                                               *                     BUG26308
      *  SRLeap - Check February 29 within a period                   *                     BUG26308
      *                                                               *                     BUG26308
      *****************************************************************                     BUG26308
                                                                                            BUG26308
     C     SRLeap        BEGSR                                                              BUG26308
     C                   EVAL      WLeap  = 'N'                                             BUG26308
     C                   EVAL      WYr1   = %SUBDT(WBDate:*YEARS)                           BUG26308
                                                                                            BUG26308
      ** If start date greater than Feb 28, start on the next year                          BUG26308
                                                                                            BUG26308
     C                   EVAL      WCYr   = %CHAR(WYr1)                                     BUG26308
     C                   EVAL      WFDate = %DATE(WCYr+'-02-28')                            BUG26308
     C                   IF        WBDate > WFDate                                          BUG26308
     C                   EVAL      WYr1  += 1                                               BUG26308
     C                   ENDIF                                                              BUG26308
     C                   EVAL      WYr2   = %SUBDT(WEDate:*YEARS)                           BUG26308
                                                                                            BUG26308
     C                   DOW       WYr1  <= WYr2                                            BUG26308
                                                                                            BUG26308
     C                   EVAL      WCYr   = %CHAR(WYr1)                                     BUG26308
     C                   EVAL      WFDate = %DATE(WCYr+'-02-28')                            BUG26308
     C                   EVAL      WMo1   = %SUBDT(WFDate:*M)                               BUG26308
     C                   EVAL      WMo2   = %SUBDT(WFDate+%DAYS(1):*M)                      BUG26308
                                                                                            BUG26308
      ** Leap Year                                                                          BUG26308
                                                                                            BUG26308
     C                   IF        WMo1   = WMo2                                            BUG26308
     C                   EVAL      WLeap  = 'Y'                                             BUG26308
     C                   LEAVE                                                              BUG26308
     C                   ENDIF                                                              BUG26308
                                                                                            BUG26308
     C                   EVAL      WYr1  += 1                                               BUG26308
                                                                                            BUG26308
     C                   ENDDO                                                              BUG26308
     C                   ENDSR                                                              BUG26308

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAccBal  -  Write record to ERGSTSPD                     *
      *                                                               *
      *****************************************************************

     C     SRFmtAccBal   BEGSR

     C                   CLEAR                   ERGSTSD0

      ** Get Number of decimal places for the Currency

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WCcy          PCurr
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = PCurr
     C                   EVAL      DBPGM  = 'ER000193'
     C                   EVAL      DBASE  = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      B4NBDP = A6NBDP

     C                   EVAL      B4MDAN = PSVal2
     C**********         EVAL      B4FILN = B3FILN                                          BUG26308
     C                   EVAL      B4FILN = B3FILN                                            CER059
     C                   EVAL      B4MODU = B3MODU
     C                   EVAL      B4KDNR = B3KDNR
     C                   EVAL      B4KTON = B3KTON
     C                   EVAL      B4GSRE = B3GSRE

     C                   SELECT
     C                   WHEN      WMod   = 'RE'
     C                   EVAL      B4ABGB = ACLDBL

      *                                                                                     BUG26254
      ** In Money Market, use Principal (PCPL) rather than Original principal amount (OPAM) BUG26254
      *                                                                                     BUG26254
     C                   WHEN      WMod   = 'MM'
     C**********         EVAL      WBal   = DLOPAM                                          BUG26254
     C     DLDLNO        CHAIN     MMDELDL2                                                 BUG26870
     C                   IF        HKAMNP >= 0                                              BUG26870
     C                   EVAL      WBal   = DLPCPL                                          BUG26254
     C                   ELSE                                                               BUG26870
     C                   EVAL      WBal   = 0 - DLPCPL                                      BUG26870
     C                   ENDIF                                                              BUG26870

     C                   WHEN      WMod   = 'LE'
     C**********         EVAL      WBal   = LECPAM                                          BUG26870
     C                   IF        LEPTYP = 66                                             BUG26870A
     C                             OR LEPTYP = 67                                          BUG26870A
     C                             OR LEPTYP = 69                                          BUG26870A
     C                             OR LEPTYP = 72                                          BUG26870A
     C                   EVAL      WBal   = LECPAM                                         BUG26870A
     C                   ELSE                                                              BUG26870A
     C                   EVAL      WBal   = 0 - LECPAM                                      BUG26870
     C                   ENDIF                                                             BUG26870A
     C                   ENDSL

     C                   EVAL      B4SLDU = WBal
     C                   IF        WMod   = 'MM' AND                                        BUG26308
     C                             DLNOTD > 0                                               BUG26308
     C                   EVAL      B4GKBT = B4SLDU                                          BUG26308
     C                   ENDIF                                                              BUG26308

     C                   EVAL      B4IFNA = 'MIDAS PLUS'
                                                                                              CER070
     C                   MOVE      PZDate1       B4DLDT                                       CER070

     C                   WRITE     ERGSTSD0

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAccGL -  Write record to ERBILIPD                       *
      *                                                               *
      *****************************************************************

     C     SRFmtAccGL    BEGSR

     C                   CLEAR                   ERBILID0

     C                   EVAL      B5MDAN = PSVal2
     C                   MOVEL     PSVal1        B5BILK
     C                   EVAL      B5IFNA = 'MIDAS PLUS'
     C                   MOVE      PZDate1       B5DLDT                                       CER070

     C                   WRITE     ERBILID0

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDate - Convert Midas date to YYYYMMDD format               *
      *                                                               *
      *****************************************************************

     C     SRDate        BEGSR

     C                   CALL      'ZACVTDATE'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    PDayno
     C                   PARM                    PFDate
     C                   PARM      *BLANKS       PCDate

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************

     C     SRAudit       BEGSR

     C                   OPEN      ER000193AU

     C                   WRITE     HEADAU

      ** If there is a DB Error, Output the DB Error Information.

     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     KACCT         KLIST
     C                   KFLD                    ACCNUM
     C                   KFLD                    ACCCY
     C                   KFLD                    ACACOD
     C                   KFLD                    ACACSQ
     C                   KFLD                    ACBRCA

     C     KTRAN         KLIST
     C                   KFLD                    KMMOD
     C                   KFLD                    KTRTY
     C                   KFLD                    KTRST
     C                   KFLD                    KTRCL

     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error.

     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CER070
     C                   EVAL      PZDayNo = BJRDNB                                           CER070
                                                                                              CER070
     C                   CALLB     'ZDATE9'                                                   CER070
     C                   PARM                    PZDayNo                                      CER070
     C                   PARM      *ZEROS        PZDate1                                      CER070
     C                   PARM      *BLANKS       PErrorFlag                                   CER070
                                                                                              CER070
     C                   IF        PErrorFlag = '0'                                           CER070
     C                   MOVE      PZDate1       B3DLDT                                       CER070
     C                   ENDIF                                                                CER070
                                                                                              CER070
      ** Check if "CLE006 - Syndication" is installed                                         CER070
                                                                                              CER070
     C                   CALL      'AOSARDR0'                                                 CER070
     C                   PARM      *BLANKS       PRtCd                                        CER070
     C                   PARM      '*VERIFY'     POptn                                        CER070
     C                   PARM      'CLE006'      PSarD                                        CER070
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER070
                                                                                              CER070
     C     PRtCd         IFEQ      *BLANK                                                     CER070
     C                   MOVEL     'Y'           CLE006            1                          CER070
     C                   ELSE                                                                 CER070
     C                   MOVEL     'N'           CLE006                                       CER070
     C                   ENDIF                                                                CER070

      ** Retrieve system values.

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      WKeySysVal1   PSValK1
     C                   PARM                    PSVal1
     C                   PARM      WKeySysVal2   PSValK2
     C                   PARM                    PSVal2
     C                   PARM                    PSValK3
     C                   PARM                    PSVal3
     C                   PARM                    PSValK4
     C                   PARM                    PSVal4
     C                   PARM                    PSValK5
     C                   PARM                    PSVal5
     C                   PARM                    PSValK6
     C                   PARM                    PSVal6
     C                   PARM                    PSValK7
     C                   PARM                    PSVal7
     C                   PARM                    PSValK8
     C                   PARM                    PSVal8
     C                   PARM                    PSValK9
     C                   PARM                    PSVal9
     C                   PARM                    PSValK0
     C                   PARM                    PSVal0

      ** If the system value is not found then issue a database error.

     C                   IF        PRtcd    <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBase = 002

     C                   SELECT
     C                   WHEN      PSVal1 = '*NRF'
     C                   EVAL      DBKey = PSValK1
     C                   WHEN      PSVal2 = '*NRF'
     C                   EVAL      DBKey = PSValK2
     C                   ENDSL

     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Report Work fields.

     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0

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

     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2009
