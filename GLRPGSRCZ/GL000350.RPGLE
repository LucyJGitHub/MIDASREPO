     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND
/*EXI *  TEXT('Midas GL AWV Report')                                  *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000350 - Midas GL AWV Report                               *
      *                                                               *
      *  Function: The module is to extract the fields from AWV table *
      *            with 'DL' for Dealing, 'LE' for Customer Lending   *
      *            'RE' for Retail.                                   *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Called by: GLC000350                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *               . CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26866           Date 12Dec09               *
      *                 BUG26298           Date 06Oct09               *
      *                 BUG24479           Date 22Jun09               *
      *                 BUG24437           Date 24Jun09               *
      *                 BUG24174           Date 03Jun09               *
      *                 BUG24010           Date 15May09               *
      *                 BUG23498           Date 08Apr09               *
      *                 BUG23274           Date 06Mar09               *
      *                 BUG23273           Date 06Mar09               *
      *                 CER044  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26866 - Additional AWV Extract Information                *
      *  BUG26298 - Enable export to Meridian                         *
      *  BUG24479 - Dealing Transaction errors in AWV Report          *
      *  BUG24437 - Interest Payments via MAPY not captured           *
      *           in AWV report and various errors                    *
      *  BUG24174 - Retail Interest accounts details not captured     *
      *             correctly                                         *
      *  BUG24010 - Posting Amounts should state DR or CR balance     *
      *  BUG23498 - AWV Bundesbank Report - Report not filtering by   *
      *             Customer Residency Status                         *
      *  BUG23274 - Incorrect value in field 'Account'                *
      *  BUG23273 - AWV Bundesbank Report - Posting Amount Editting & *
      *             Field Realignment                                 *
      *  CRE044 - German Features LF035-00 AWV Reporting              *
      *                                                               *
      *************************************************************** *
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  U7+U8 - Database Error Indicator                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SrPopulate - Subroutine to populate the Extracts detail      *
      *               Report by extracting the values from AWV        *
      *               Extract file & AWV Extract Extension file.      *
      *  SrAudit - Subroutine to print the number of postings         *
      *            for Dealing, Customer Lending and Retailing        *
      *  SRZsEdit - Convert amount from file format to screen format  *
      *  SRPopulate2 - Subroutine to populate GLAWAEPD for Meridian   *
      *  SRZDate - Subroutine to format date                          *
      *  *INZSR - Initialisation Subroutine                           *
      *  *PSSR - Error processing                                     *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      * +--------------------------------------+
      * ¦ F-specs                              ¦
      * ¦ =======                              ¦
      * +--------------------------------------+
      *                                                                                     BUG26866
      ** Midas ER BAIS Module Mapping Table                                                 BUG26866
      *                                                                                     BUG26866
     FERBMODPD  IT   F    4        DISK                                                     BUG26866
      *                                                                                     BUG26866
      ** Midas DL Deals file                                                                BUG26866
      *                                                                                     BUG26866
     FDEALS     IF   E           K DISK    INFSR(*PSSR)                                     BUG26866
     F                                     PREFIX(DL)                                       BUG26866
      *                                                                                     BUG26866
      ** Midas ER Account Code Decision Table                                               BUG26866
      *                                                                                     BUG26866
     FERDEACL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG26866
      *                                                                                     BUG26866
      ** Midas ER Transaction Type Decision Table                                           BUG26866
      *                                                                                     BUG26866
     FERDETTL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG26866
      *
      ** Midas GL AWV Extract
      *
     FGLAWVEL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(G)
      *
      ** Midas GL AWV Extract Extension
      *
     FGLAWVXL1  IF   E           K DISK    INFSR(*PSSR)
      **********                                                                            BUG24174
      ***Midas*GL*AWV*Extract*Extension                                                     BUG24174
      **********                                                                            BUG24174
     F***GLAWVXL0  IF   E           K DISK    INFSR(*PSSR)                                  BUG24174
     F**********                           RENAME(GLAWVXD0:GLAWVXD1)                        BUG24174
     F**********                           PREFIX(A)                                        BUG24174
      *                                                                                     BUG26298
      ** Midas GL AWV Extract for Lending - for Meridian                                    BUG26298
      *                                                                                     BUG26298
     FGLAWAEPD  O    E             DISK    PREFIX(E1)                                       BUG26298
      *
      ** Midas GL AWV Extracts Detail Report
      *
     FGL000350P1O    E             PRINTER OFLIND(INOF)
     F                                     INFDS(SPOOL1)
      *
      ** Midas GL AWV Extracts Audit Report
      *
     FGL000350AUO    E             PRINTER
     F                                     INFDS(SPOOLAU)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** File Information Data Structure for GL000350P1
      *
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      ** File Information Data Structure for GL000350AU
      *
     D SPOOLAU         DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D  OFLLNU               188    189B 0
     D  PRTLNU               367    368B 0
      *
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the standard declares
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS. They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D                 DS                                                                   BUG26866
     D ArrModules                     4A   DIM(4) FROMFILE(ERBMODPD)                        BUG26866
     D ArMMOD                         2A   OVERLAY(ArrModules:1)                            BUG26866
     D ArBAMO                         2A   OVERLAY(ArrModules:*NEXT)                        BUG26866
      *
      ** First DS for access programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      *
      ** Second DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Currency Code
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** External data structures for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *                                                                                     BUG26866
      ** Country Codes                                                                      BUG26866
      *                                                                                     BUG26866
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)                                BUG26866
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameter Variables to call 'AOSVALR0'
      *
     D PSValK1         S             20A
     D PSValK2         S             20A
     D PSValK3         S             20A
     D PSValK4         S             20A
     D PSValK5         S             20A
     D PSValK6         S             20A
     D PSValK7         S             20A
     D PSValK8         S             20A
     D PSValK9         S             20A
     D PSValK10        S             20A
     D PSVal1          S            200A
     D PSVal2          S            200A
     D PSVal3          S            200A
     D PSVal4          S            200A
     D PSVal5          S            200A
     D PSVal6          S            200A
     D PSVal7          S            200A
     D PSVal8          S            200A
     D PSVal9          S            200A
     D PSVal10         S            200A
      *
      ** Parameters for ZSFILE
      *
     D PRSeq           S              5A
     D PEnty           S              3A
     D PFile           S             10A
     D PSNum           S              6  0
     D PSErr           S              1A
      *                                                                                     BUG23273
      ** Parametrs for ZSEDIT                                                               BUG23273
      *                                                                                     BUG23273
     D PZFld15         S             15P 0                                                  BUG23273
     D PZDecs          S              1P 0                                                  BUG23273
     D PZeCode         S              1A                                                    BUG23273
     D PZout21         S             21A                                                    BUG23273
      *
      ** Other work variable
      *
     D PRtcd           S              7A
     D WCtry           S              2A                                                    BUG26866
     D WMod            S              2A                                                    BUG26866
     D WIx             S              1  0                                                  BUG26866
     D WBUCL           S              2A                                                    BUG26866
     D WBUSU           S              2A                                                    BUG26866
     D WBUTY           S              2A                                                    BUG26866
     D WDLNO           S              6S 0                                                  BUG26866
     D WType           S              2A                                                    BUG26866
     D WStyp           S              2A                                                    BUG26866
     D WRun            S              1A
     D WNbrCnt         S              6  0
     D WForCnt         S              6  0
     D WDlCnt          S              6  0
     D WElCnt          S              6  0
     D WReCnt          S              6  0
     D POptn           S              7A
     D RCcY            S              3A
     D WCcY1           S              3A
     D WCcY2           S              3A
     D WCcy            S              3A                                                    BUG23274
     D WBrca           S              3A                                                    BUG23274
     D WAcSq           S              2A                                                    BUG23274
     D WAcNo           S             10A                                                    BUG23274
     D WCNum           S              6A                                                    BUG23274
     D WTrNo           S             10A                                                    BUG23274
     D WPNar           S             30A                                                    BUG23274
     D WPsRc           S              2A                                                    BUG23274
                                                                                            BUG26866
      ** Constants for system values                                                        BUG26866
                                                                                            BUG26866
     D WKeySysVal1     C                   CONST('BundClientId')                            BUG26866
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------*
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Key kist for GLAWVXL1
      *
     C     KWvxL1        KLIST
     C                   KFLD                    GCNUM
     C                   KFLD                    GTRNO
     C                   KFLD                    GACNO                                      BUG24437
     C     KTRCL         KLIST                                                              BUG26866
     C                   KFLD                    WMod                                       BUG26866
     C                   KFLD                    WType                                      BUG26866
     C                   KFLD                    WStyp                                      BUG26866
      **********                                                                            BUG24174
      ***Key*kist*for*GLAWVXL0                                                              BUG24174
      **********                                                                            BUG24174
     C*****KWxxL0        KLIST                                                              BUG24174
     C**********         KFLD                    GCNUM                                      BUG24174
     C**********         KFLD                    AACNO                                      BUG24174
      **********                                                                            BUG24174
     C**********         EXSR      *INZSR                                                   BUG24174
      **********                                                                            BUG24174
     C     *LOVAL        SETLL     GLAWVEL0
     C                   READ      GLAWVEL0
      *
     C                   DOW       NOT %EOF
      *                                                                                     BUG23498
     C                   IF        GRFLG = 'Y'                                              BUG23498
      *                                                                                     BUG23498
     C**********         IF        GRTYP = *BLANKS                                          BUG24174
     C     KWvxL1        CHAIN     GLAWVXL1
      *                                                                                     BUG23274
      ** Populate 'Account' related fields                                                  BUG23274
      *                                                                                     BUG23274
     C                   EVAL      WBrca = BRCA                                             BUG23274
     C                   MOVE      GCNUM         WCNum                                      BUG23274
     C                   EVAL      WCcy = GCCY                                              BUG23274
     C                   EVAL      WAcNo = ACNO                                             BUG23274
     C                   MOVE      ACSQ          WAcSq                                      BUG23274
      *                                                                                     BUG23274
     C                   EVAL      WPNar = PNAR                                             BUG23274
     C                   EVAL      WPsRc = PSRC                                             BUG23274
     C                   EVAL      WTrNo = TRNO                                             BUG23274
      *                                                                                     BUG23274
     C                   EVAL      WCcy1 = GCCY
     C                   IF        PSRC = 'DL'
     C                                                                                      BUG26866
     C                   MOVEL     TRNO          WDLNO                                      BUG26866
     C     WDLNO         SETLL     DEALSDCF                                                 BUG26866
     C                   IF        %EQUAL()                                                 BUG26866
     C                   EVAL      WMod = 'MM'                                              BUG26866
     C                   ENDIF                                                              BUG26866
     C     WDLNO         SETLL     DEALSDBF                                                 BUG26866
     C                   IF        %EQUAL()                                                 BUG26866
     C                   EVAL      WMod = 'FX'                                              BUG26866
     C                   ENDIF                                                              BUG26866
     C                   EVAL      WDlCnt = WDlCnt + 1
     C                   ENDIF
      *
     C                   IF        PSRC = 'LE'
     C                   EVAL      WMod = 'LE'                                              BUG26866
     C                   EVAL      WElCnt = WElCnt + 1
     C                   ENDIF
      *
     C**********         ELSE                                                               BUG24174
     C**********         IF        GRTYP <> *BLANKS                                         BUG24174
     C**********         MOVE      GTRNO         AACNO                                      BUG24174
     C*****KWxxL0        CHAIN     GLAWVXL0                                                 BUG24174
      **********                                                                   BUG23274 BUG24174
      ***Populate*'Account'*related*fields                                         BUG23274 BUG24174
      **********                                                                   BUG23274 BUG24174
     C**********         EVAL      WBrca = ABRCA                                   BUG23274 BUG24174
     C**********         MOVE      GCNUM         WCNum                             BUG23274 BUG24174
     C**********         EVAL      WCcy = GCCY                                     BUG23274 BUG24174
     C**********         EVAL      WAcNo = AACNO                                   BUG23274 BUG24174
     C**********         MOVE      AACSQ         WAcSq                             BUG23274 BUG24174
      **********                                                                   BUG23274 BUG24174
     C**********         EVAL      WPNar = APNAR                                   BUG23274 BUG24174
     C**********         EVAL      WPsRc = APSRC                                   BUG23274 BUG24174
     C**********         EVAL      WTrNo = ATRNO                                   BUG23274 BUG24174
      **********                                                                   BUG23274 BUG24174
     C**********         IF        APSRC = 'RE'                                             BUG24174
     C                   IF        PSRC = 'RE'                                              BUG24174
     C                   EVAL      WMod = 'RE'                                              BUG26866
     C
     C                   EVAL      WReCnt = WReCnt + 1
     C                   ENDIF
                                                                                            BUG26866
     C                   EVAL      WBUCL = *BLANKS                                          BUG26866
     C                   EVAL      WBUSU = *BLANKS                                          BUG26866
     C                   EVAL      WBUTY = *BLANKS                                          BUG26866
     C                   IF        PSRC = 'DL' OR                                           BUG26866
     C                             PSRC = 'LE'                                              BUG26866
     C                   EXSR      SrTrClass                                                BUG26866
     C                   ELSE                                                               BUG26866
     C                   EXSR      SrAcClass                                                BUG26866
     C                   ENDIF                                                              BUG26866
      *
     C                   EVAL      WNbrCnt = WNbrCnt + 1
     C**********         ENDIF                                                              BUG24174
     C**********         ENDIF                                                              BUG24174
      *
      ** Populate the data in the printer file.
      *
     C                   EXSR      SrPopulate
      *
     C                   EVAL      WCcy2 = GCCY
      *                                                                                     BUG26298
      ** Populate GLAWAEPD for Meridian                                                     BUG26298
      *                                                                                     BUG26298
     C                   EXSR      SrPopulate2                                              BUG26298
      *                                                                                     BUG23498
     C                   ENDIF                                                              BUG23498
      *                                                                                     BUG23498
     C                   READ      GLAWVEL0
      *
     C                   ENDDO
      *
     C                   EXSR      SrAudit
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      'RptgCcy'     PSValK1
     C                   PARM                    PSVal1
     C**********         PARM      *BLANKS       PSValK2                                    BUG26866
     C                   PARM      WKeySysVal1   PSValK2                                    BUG26866
     C                   PARM                    PSVal2
     C                   PARM      *BLANKS       PSValK3
     C                   PARM                    PSVal3
     C                   PARM      *BLANKS       PSValK4
     C                   PARM                    PSVal4
     C                   PARM      *BLANKS       PSValK5
     C                   PARM                    PSVal5
     C                   PARM      *BLANKS       PSValK6
     C                   PARM                    PSVal6
     C                   PARM      *BLANKS       PSValK7
     C                   PARM                    PSVal7
     C                   PARM      *BLANKS       PSValK8
     C                   PARM                    PSVal8
     C                   PARM      *BLANKS       PSValK9
     C                   PARM                    PSVal9
     C                   PARM      *BLANKS       PSValK10
     C                   PARM                    PSVal10
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'GL000350'
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = %TRIM(PSValK1)
     C                   OUT       LDA
      *
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Get info from the SDBANKPD
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANKS'     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** If error, than do
      *
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Setup indicators for printing header of the report
      *
     C                   EVAL      INOF = *ON
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PRSeq
     C                   PARM      *BLANKS       PEnty
     C                   PARM      SFILE1        PFile
     C                   PARM      SFNUM1        PSNum
     C                   PARM      *BLANKS       PSErr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C                   IF        PSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDIF
     C                   ENDSR
      *                                                                                     BUG26866
      *****************************************************************                     BUG26866
      /EJECT                                                                                BUG26866
      *****************************************************************                     BUG26866
      *                                                               *                     BUG26866
      *  SrTrClass - Subroutine to get transaction type Class,        *                     BUG26866
      *               Subclass and Type                               *                     BUG26866
      *                                                               *                     BUG26866
      *  Called by: Main                                              *                     BUG26866
      *                                                               *                     BUG26866
      *  Calls: None                                                  *                     BUG26866
      *                                                               *                     BUG26866
      *****************************************************************                     BUG26866
     C     SrTrClass     BEGSR                                                              BUG26866
     C                   EVAL      WType = GTYPE                                            BUG26866
     C                   EVAL      WStyp = GSTYP                                            BUG26866
     C     KTRCL         CHAIN     ERDETTL1                                                 BUG26866
     C                   IF        %FOUND()                                                 BUG26866
     C                   EVAL      WBUCL = N4BUCL                                           BUG26866
     C                   MOVE      N4BUSU        WBUSU                                      BUG26866
     C                   EVAL      WBUTY = N4BUTY                                           BUG26866
     C                   ENDIF                                                              BUG26866
     C                   ENDSR                                                              BUG26866
      *                                                                                     BUG26866
      *****************************************************************                     BUG26866
      /EJECT                                                                                BUG26866
      *****************************************************************                     BUG26866
      *                                                               *                     BUG26866
      *  SrAcClass - Subroutine to get Account Class, Subclass and    *                     BUG26866
      *               Type                                            *                     BUG26866
      *                                                               *                     BUG26866
      *  Called by: Main                                              *                     BUG26866
      *                                                               *                     BUG26866
      *  Calls: None                                                  *                     BUG26866
      *                                                               *                     BUG26866
      *****************************************************************                     BUG26866
     C     SrAcClass     BEGSR                                                              BUG26866
     C     ACNO          CHAIN     ERDEACL1                                                 BUG26866
     C                   IF        %FOUND()                                                 BUG26866
     C                   EVAL      WBUCL = N3BUCL                                           BUG26866
     C                   MOVE      N3BUSU        WBUSU                                      BUG26866
     C                   EVAL      WBUTY = N3BUTY                                           BUG26866
     C                   ENDIF                                                              BUG26866
     C                   ENDSR                                                              BUG26866
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPopulate - Subroutine to populate the Extracts detail      *
      *               Report by extracting the values from AWV        *
      *               Extract file & AWV Extract Extension file.      *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrPopulate    BEGSR
      *
     C                   EVAL      RCcy = GCCY
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    RCcY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   EVAL      RCYNM = A6CYNM
      *
     C                   IF        PSVal1 = GCCY
     C                   EVAL      RLFCF = 'LOCAL'
     C                   ELSE
      *
     C                   IF        PSVal1 <> GCCY
     C                   EVAL      WForCnt = WForCnt + 1
     C                   EVAL      RLFCF = 'FOREIGN'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        (WNbrCnt = 1 OR INOF = *ON OR
     C                             WForCnt = 1 OR WCcy1 <> WCcy2)
     C                   WRITE     GL00350R0
     C                   EVAL      INOF = *OFF
     C                   ENDIF
      *
     C**********         EVAL      RBRCH = BRCA                                             BUG23274
     C                   EVAL      RBRCH = WBrca                                            BUG23274
      *
     C**********         IF        GRFLG = 'Y'                                              BUG23498
     C**********         EVAL      RRESF = 'YES'                                            BUG23498
     C**********         ELSE                                                               BUG23498
     C**********         EVAL      RRESF = 'NO'                                             BUG23498
     C**********         ENDIF                                                              BUG23498
      *
     C**********         EVAL      RACNT = BRCA + %CHAR(GCNUM) +                            BUG23274
     C**********                           GCCY + ACNO +                                    BUG23274
     C**********                           %CHAR(ACSQ)                                      BUG23274
      *                                                                                     BUG23274
     C                   EVAL      RACNT = WBrca + '-' + WCNum + '-' +                      BUG23274
     C                                     WCcy + '-' + WAcNo + '-' +                       BUG23274
     C                                     WAcSq                                            BUG23274
      *                                                                                     BUG23274
      *                                                                                     BUG23273
      ** Format the Posting Amount                                                          BUG23273
      *                                                                                     BUG23273
     C**********         EVAL      RPAMT = %CHAR(GPAMT)                                     BUG23273
     C                   EVAL      PZDecs = A6NBDP                                          BUG23273
     C                   EVAL      PZeCode = 'J'                                            BUG23273
     C                   MOVE      GPAMT         PZFld15                                    BUG23273
     C                   EXSR      SRZsEdit                                                 BUG23273
     C                   EVALR     RPAMT = %TRIM(PZout21)                                   BUG23273
      *                                                                                     BUG23273
      ** Replace 1/0 1 = 'CR' and 0 = 'DR'                                                  BUG24010
     C***********        EVAL      RDRCR = GDCIN                                            BUG24010
     C                   EVAL      RDRCR = 'DR'                                             BUG24010
     C                   IF        GDCIN = '1'                                              BUG24010
     C                   EVAL      RDRCR = 'CR'                                             BUG24010
     C                   ENDIF                                                              BUG24010
      *                                                                                     BUG24479
      ** Indicate whether amount is Principal or Interest                                   BUG24479
      *                                                                                     BUG24479
     C                   EVAL      RPTYP = 'P'                                              BUG24479
     C                   IF        GPTYP = 'I'                                              BUG24479
     C                   EVAL      RPTYP = 'I'                                              BUG24479
     C                   ENDIF                                                              BUG24479
      *                                                                                     BUG24010
     C**********         EVAL      RPNAR = PNAR                                             BUG23274
     C**********         EVAL      RTRNO = TRNO                                             BUG23274
     C                   EVAL      RPNAR = WPNar                                            BUG23274
     C                   EVAL      RTRNO = WTrNo                                            BUG23274
      *
     C**********         IF        PSRC = 'DL' OR PSRC = 'LE'                               BUG23274
     C                   IF        WPsRc = 'DL' OR WPsRc = 'LE'                             BUG23274
     C**********         EVAL      RDTST = GTYPE + GSTYP                                    BUG23273
     C                   EVAL      RDTST = GTYPE + '/' + GSTYP                              BUG23273
     C                   ELSE
      *
     C**********         IF        PSRC = 'RE'                                              BUG23274
     C                   IF        WPsRc = 'RE'                                             BUG23274
     C                   EVAL      RDTST = GRTYP
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   WRITE     GL00350R1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrAudit - Subroutine to print the number of postings         *
      *            for Dealing, Customer Lending and Retailing        *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR
      *
     C                   EVAL      RDLIN = WDlCnt
     C                   EVAL      RLEDN = WElCnt
     C                   EVAL      RRETL = WReCnt
     C                   EVAL      ROVRL = WDlCnt + WElCnt + WReCnt
     C                   WRITE     HEADAU
     C                   WRITE     DETAILAU
      *
     C                   ENDSR
      *****************************************************************                     BUG23273
      /EJECT                                                                                BUG23273
      *****************************************************************                     BUG23273
      *                                                               *                     BUG23273
      *  SRZsEdit - Convert amount from file format to screen format  *                     BUG23273
      *                                                               *                     BUG23273
      *  Called by: SrPopulate                                        *                     BUG23273
      *                                                               *                     BUG23273
      *  Calls: None                                                  *                     BUG23273
      *                                                               *                     BUG23273
      *****************************************************************                     BUG23273
      *                                                                                     BUG23273
     C     SRZSEdit      BEGSR                                                              BUG23273
      *                                                                                     BUG23273
     C                   CALL      'ZSEDIT'                                                 BUG23273
      *                                                                                     BUG23273
     C                   PARM                    PZFld15                                    BUG23273
     C                   PARM                    PZDecs                                     BUG23273
     C                   PARM                    PZeCode                                    BUG23273
     C                   PARM                    PZout21                                    BUG23273
      *                                                                                     BUG23273
     C                   ENDSR                                                              BUG23273
      *                                                                                     BUG23273
      *****************************************************************                     BUG26298
      /EJECT                                                                                BUG26298
      *****************************************************************                     BUG26298
      *                                                               *                     BUG26298
      *  SrPopulate2 - Populate GLAWAEPD for Meridian                 *                     BUG26298
      *                                                               *                     BUG26298
      *****************************************************************                     BUG26298
      *                                                                                     BUG26298
     C     SrPopulate2   BEGSR                                                              BUG26298
      *                                                                                     BUG26298
      ** Populate GLAWAEPD for Meridian                                                     BUG26298
      *                                                                                     BUG26298
     C                   MOVE      *BLANKS       E1CNUM                                     BUG26298
     C                   MOVE      GCNUM         E1CNUM                                     BUG26298
     C                   EVAL      E1CCY = GCCY                                             BUG26298
     C                   EVAL      E1TRNO = GTRNO                                           BUG26298
     C                   EVAL      E1TYPE = GTYPE                                           BUG26298
     C                   EVAL      E1STYP = GSTYP                                           BUG26298
     C                   EVAL      E1PDAT = GPDAT                                           BUG26298
     C                   EVAL      E1DDAT = GDDAT                                           BUG26298
     C                   EVAL      E1MDAT = GMDAT                                           BUG26298
      *                                                                                     BUG26298
     C                   EVAL      E1NBDP = A6NBDP                                          BUG26298
     C                   EVAL      E1PAMT = GPAMT                                           BUG26298
      *                                                                                     BUG26298
     C                   EVAL      E1PTYP = GPTYP                                           BUG26298
     C                   EVAL      E1ACNO = GACNO                                           BUG26298
     C                   EVAL      E1GVCC = GGVCC                                           BUG26298
     C                   EVAL      E1RTYP = GRTYP                                           BUG26298
     C                   EVAL      E1DCIN = GDCIN                                           BUG26298
     C                   EVAL      E1RFLG = GRFLG                                           BUG26298
     C                   EVAL      E1BNBI = GBNBI                                           BUG26298
     C                   EVAL      E1COLC = GCOLC                                           BUG26298
      *                                                                                     BUG26866
     C                   CALL      'AOCTRYR0'                                               BUG26866
     C                   PARM      *BLANKS       PRtCd                                      BUG26866
     C                   PARM      '*KEY   '     POptn                                      BUG26866
     C                   PARM      E1COLC        WCtry                                      BUG26866
     C     SDCTRY        PARM      SDCTRY        DSFDY                                      BUG26866
      *                                                                                     BUG26866
     C                   IF        PRtCd <> *BLANKS                                         BUG26866
     C                   EVAL      DBFILE = 'SDCTRYPD'                                      BUG26866
     C                   EVAL      DBASE  = 002                                             BUG26866
     C                   EVAL      DBKEY  = WCtry                                           BUG26866
     C                   EXSR      *PSSR                                                    BUG26866
     C                   ENDIF                                                              BUG26866
     C                   MOVE      A4GRIC        E1GRIC                                     BUG26866
      *                                                                                     BUG26866
     C                   EVAL      E1LINC = GLINC                                           BUG26298
     C                   EVAL      E1REVI = GREVI                                           BUG26298
                                                                                            BUG26866
     C                   EVAL      E1MDAN = PSVal2                                          BUG26866
     C                   EVAL      WIx    = %LOOKUP(WMod:ArMMOD:1)                          BUG26866
     C                   IF        WIx   <> 0                                               BUG26866
     C                   EVAL      E1MODU = ArBAMO(WIx)                                     BUG26866
     C                   ELSE                                                               BUG26866
     C                   EVAL      E1MODU = *BLANKS                                         BUG26866
     C                   ENDIF                                                              BUG26866
     C                   EVAL      E1FILN = BRCA                                            BUG26866
     C                   EVAL      E1BUCL = WBUCL                                           BUG26866
     C                   EVAL      E1BUSU = WBUSU                                           BUG26866
     C                   EVAL      E1BUTY = WBUTY                                           BUG26866
     C                   WRITE     GLAWAED0                                                 BUG26298
      *                                                                                     BUG26298
     C                   ENDSR                                                              BUG26298
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
