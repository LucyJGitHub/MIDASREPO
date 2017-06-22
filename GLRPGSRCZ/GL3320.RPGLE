     H DEBUG
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                       CGL120
/*STD *  RPGBASEBNC                                                   *                       CGL120
/*EXI *  TEXT('Midas GL Account balances extract')                    *
     F*****************************************************************
     F*                                                               *
     F*  Midas - General Ledger Module
     F*                                                               *
     F*  GL3320 - ACCOUNT BALANCES EXTRACT                            *
     F*                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                               *
      *  Last Amend No. MD033583           Date 03Jun15               *
      *  Prev Amend No. 253181             Date 26Apr16               *
      *                 MD031642           Date 15Dec14               *
      *                 CRE095             Date 25Apr14               *
      *                 MD033737           Date 05May15               *
      *                 CGL165             Date 17Feb15               *
      *                 235284             Date 16Feb15               *
      *                 MD024120A          Date 19Aug14               *
      *                 MD024120           Date 12Dec13               *
      *                 CRE090             Date 14Feb14               *
      *                 AR1095876          Date 30Sep13               *
      *                 MD020566           Date 21May13               *
      *                 AR1097401          Date 24Apr13               *
      *                 AR1097218          Date 05Apr13               *
      *                 AR1097385          Date 01Apr13               *
      *                 CGL142             Date 06Aug12               *
      *                 CGP017             Date 06Aug12               *
      *                 CGL120             Date 06Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR899028           Date 25Jan12               *
      *                 AR847269           Date 09Nov11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CER042             Date 11May11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26706A          Date 04Jan10               *
      *                 BUG26706           Date 17Nov09               *
      *                 BUG26202           Date 06Oct09               *
      *                 BUG23075           Date 06Mar09               *
      *                 CER036             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 04Jan10               *
      *                 CGP013             Date 20Feb09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 254563             Date 03Jun08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG7418            Date 08Jun05               *
      *                 CLE040             Date 05Jul04               *
      *                 BUG3330            Date 22Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185118             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 137916             Date 18Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                 CEU013             Date 28May98               *
     F*                 S01408             Date 02Feb98               *
     F*                 CTI001             DATE 02NOV97               *
     F*                 CFF004             DATE 02OCT96               *
     F*                 S01408             DATE 20JUN96               *
     F*                 S01408             DATE 22AUG95               *
     F*                 091250             DATE 24FEB95               *
     F*                 085378             DATE 06JUN95               *
     F*                 085140             DATE 17MAR95               *
     F*                 S01408             DATE 10APR95               *
     F*                 080809             DATE 03JAN95               *
     F*                 S01486             DATE 12JAN95               *
     F*                 076177             DATE 20SEP94               *
     F*                 052664             DATE 02SEP93               *
     F*                 S01413 *CREATE     DATE 13APR93               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD033583 - Performance - ABEXAG - Reuse deleted records      *
      *             (Recompile)                                       *     
      *  253181 - Delete record from the shadow file REMEMLPD when    *
      *           account has been dropped from ACCNTAB               *
      *         - Applied for MD022061                                *
      *  MD031642 - Error when no record exists between the first and *
      *             last RRNs for a task split job.                   *
      *  CRE095 - Rate Fixing for RE Accounts (Recompile)             *
      *  MD033737 - GLC3320T2 00009 looping during COB                *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  235284 - If present, include Next Capitalisation Date when   *
      *           determining whether an account is due to capitalise *
      *           for frequency 'Z' otherwise there can be a mismatch *
      *           between the processing for interest capitalisation  *
      *           and charges capitalisation (the former checks also  *
      *           the next capitalisation date whilst the latter      *
      *           does not).                                          *
      *         - Applied for MD031575                                *
      *  MD024120A - Error encountered on GLACBAPD update             *
      *  MD024120 - GLC3320 Performance Issues                        *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  MD020566 - GLACC2AC record locking on GLC3320 Task Split     *
      *  AR1097401 - Do not process READ unless RRN Lt GLTERN         *
      *  AR1097218 - GLC0720 seq 10001 failed Out of Balance          *
      *  AR1097385 - Removed checking for CGL001                      *
      *  CGL142 - Tactical COB changes GL                             *
      *  CGP017 - Global Layer - GOC0100 Task Split (Recompile)       *
      *  CGL120 - GL COB Components Task Split                        *
      *         - Incorporate CLE148                                  *
      *         - Incorporate CGP017                                  *
      *         - Incorporate AR694767                                *
      *         - Incorporate CGL102CR1                               *
      *         - Incorporate 258390                                  *
      *         - Incorporate CGL102                                  *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  AR847269 - Column F1DACN not in specified tables (Recompile) *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179) (Recompile)                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26706A - Retail Account was not removed in AMAD           *
      *  BUG26706 - Retail Account was not removed in AMAD            *
      *  BUG26202 - CGC4700 00001                                     *
      *  BUG23075 - Undeleted Transaction in REIACD                   *
      *  CER036 - Purging of Deleted Accounts                         *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CGP013 - Task Split for Accounts Global Update               *
      *  254563 - FOOB in GL0600. Applied fix 253058.                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7418- Delete GLACNTQD extension file record               *
      *           unconditionally as we are freeing up the account    *
      *           reference for re-use.                               *
      *  CLE040 - Collateralised Lending Phase 2 (Recompile)          *
      *  BUG3330 - Print report headings properly and page numbering  *
      *            for GL3320AU.                                      *
      *  CLE025 - Credit Lines                                        *
      *  CGL029 - Increase Account Code to 10 digits                  *
     F*  185118 - Applied 170166, 158002 131547                       *
     F*           Real time postings opened today were appearing on   *
     F*           the report twice. Excludes realtime postings from   *
     F*           Opening Balances.                                   *
     F*  137916 - Added a parameter (ACNO) when calling GL3320D       *
     F*           to update PBUDCPD when dropping records for         *
     F*           closed accounts                                     *
     F*  CEU013 - EMU Account Posting narrative - recompile           *
     F*  S01408 - Move GL3320F001 to match position in release 1      *
     F*  CTI001 - Midas / Trade Innovation Interface Phase 1          *
     F*  CFF004 - Increase in size of Price Fields,(Recompiled Only)  *
     F*  S01408 - Addition of core hook GL3320IIP1                    *
     F*  S01408 - Addition of core hook GL3320CCP4                    *
     F*  091250 - Print Files GL3320P1 renamed to GL3320A1 as this    *
     F*           is an audit report.                                 *
     F*  085378 - RMVJRNCHG failed in GLC3320 in case of db error     *
     F*           due to file REHISL still open by GL3320D            *
     F*  085140 - If file controls out of balance, print details      *
     F*           of actual as well as number on file.                *
     F*  S01408 - Addition of core hooks GL3320FFPG                   *
     F*                                  GL3320CCPG                   *
     F*                                  GL3320CCP1                   *
     F*                                  GL3320CCP2                   *
     F*                                  GL3320CCP3                   *
     F*                                  GL3320OOPG                   *
     F*  080809 - Remove access to Retail3 ICD file as this file is   *
     F*           no longer used in this program and causes a DB error*
     F*           if Retail3 not switched on.                         *
     F*  S01486 - Portfolio Management Upgrade to Release 10.         *
     F*  076177 - Daily Journal Opening Balances include Real Time    *
     F*           Postings                                            *
     F*  052664 - Set ADTY to 'Y' if APDA is Less than the Next       *
     F*           Working Date for Retail Accounts. This is to        *
     F*           Force RE3662 to Process these A/c's to Correct      *
     F*           the Incorrect Calculation of Accrued Interest.      *
     F*  S01413 - Retail 3 Incorporation                              *
     F*                                                               *
     F*****************************************************************
     F***ACBRC***IP**F     424 10AI    23 DISK                            S01486
     F***ACBRC***IP  F     428 10AI    23 DISK                                         S01486 CGL029
     F***ACBRC*    IP   F  573    10AIDISK    KEYLOC(23)                               CGL029 CGL120
     F***GLACBAPD  IP   F  573    10AIDISK    KEYLOC(23)                               CGL120 CGL120
     F***GLACBAPD  IP   E           K DISK                                           CGL120 MD024120
     F***GLACBAPD  UP   E             DISK                                        MD024120 MD024120A
     FGLACBAPD  UF   E             DISK                                                    MD024120A
     FACCNTAB   IF   F  647        DISK    RECNO(RRN)                                         CGL120
     FAPOSTL1   IF   E           K DISK                                                     BUG26706
     F                                     IGNORE(GLACPHPF)                                 BUG26706
     F***STMT1     IF   E           K DISK                                           BUG26706 CGL142
     FSTMT1     IF A E           K DISK    COMMIT                                             CGL142
     F***ACCNTAA   UF   F  400        DISK                                                    CGL120
     F***ACCNTAA   UF   F  400        DISK    COMMIT                                   CGL120 CGL142
     FACCNTAA   IF   F  400        DISK                                                       CGL142
     F***ACCNTAC   UF   F  403        DISK                                                    CGL120
     F***ACCNTAC   UF   F  403        DISK    COMMIT                                   CGL120 CGL142
     F***GLACC2AC  UF A E             DISK    COMMIT                                 CGL142 MD020566
     FGLACC2AC  O    E             DISK    COMMIT                                           MD020566
     F                                     PREFIX(AC_)                                        CGL142
     F***ACCNT   UF  F     424 18AI     2 DISK
     F***ACCNT**   UF   F  573    24AIDISK    KEYLOC(2)                                CGL029 CGL120
     FACCNT     UF   F  573    24AIDISK    COMMIT                                             CGL120
     F                                     KEYLOC(2)                                          CGL120
     F/COPY WNCPYSRC,GLH00529
     F***GLACNTL4  UF   E           K DISK                                             CLE025 CGL120
     FGLACNTL4  UF   E           K DISK    COMMIT                                             CGL120
     F/COPY WNCPYSRC,GL3320F001                                           S01408
     FGLACBTL0  IF   E           K DISK                                         076177
     F***ABEXHH*   O    F   40        DISK                                                    CGL120
     F***ABEXAG* O   F      40            DISK                                                CGL029
     F***ABEXZY* O   F      40            DISK                                                CGL029
     F***ABEXAG*   O    F   50        DISK                                             CGL029 CGL120
     FABEXAG    O    F   50        DISK    COMMIT                                             CGL120
     F***ABEXZY*   O    F   50        DISK                                             CGL029 CGL120
     F***ABEXZY    UF   F   50        DISK    COMMIT                                   CGL120 CGL142
     F***GLABEXZY  UF A E             DISK    COMMIT                                 CGL142 MD024120
     FGLABEXZY  O    E             DISK    COMMIT                                           MD024120
     F                                     PREFIX(ZY_)                                        CGL142
     F***REIAC** UF  F     143 18AI     2 DISK                           U5                   CGL029
     FREIAC     UF   F  218    24AIDISK    KEYLOC(2)                                          CGL029
     F                                     EXTIND(*INU5)
     F                                     COMMIT                                             CGL120
     FREHISBL   UF   E           K DISK    EXTIND(*INU5)
     F                                     COMMIT                                             CGL120
      *                                                                                       253181
      ** Midas Outward Clearing Shadow File                                                   253181
     FREMEMLL0  UF   E           K DISK    USROPN                                             253181
     F                                     COMMIT                                             253181
      *                                                                                       253181
     FPMMFHLL1  UF   E           K DISK    USROPN                               S01486
     F                                     COMMIT                                             CGL120
     FACNTDLPD  O    E             DISK    USROPN                                             CGP013
     F                                     RENAME(ACNTDLPDF:ACNTDLPF)                         CGP013
     F                                     COMMIT                                             CGL120
     F*L3320P1O***F     132     OF     PRINTER      KINFDS SPOOL          091250
     FGL3320A1  O    F  132        PRINTER INFDS(SPOOL)                         091250
     F                                     USROPN                                             CGL142
     F                                     OFLIND(*INOF)
     FGL3320AU  O    F  132        PRINTER INFDS(SPOOLU)
     F                                     OFLIND(*INOV)
     FREACX1PD  IF   E           K DISK                                                       CGL142
     F                                     RENAME(ACCNTBF6:REACX1PF)                          CGL142
     FREANX1PD  O    E             DISK    COMMIT                                             CGL142
     F***GLSTMTZX  UF A E             DISK    COMMIT                                 CGL142 MD024120
     FGLSTMTZX  O    E             DISK    COMMIT                                           MD024120
     FCACCNTAB  O    F   24        DISK    COMMIT                                             CGL142
     FACCNTL0   UF   E           K DISK    COMMIT                                             CGL142
     F                                     RENAME(ACCNTABF:ACCNTL0F)                          CGL142
     F*                                                                   S01408
     F/COPY WNCPYSRC,GL3320FFPG                                           S01408
     F*                                                                   S01408
     F/EJECT
     F*****************************************************************
     F*                                                               *
     F*   Function of Indicators                                      *
     F*                                                               *
     F*   01/02-CONTROL FIRST PAGE PRINTING                           *
     F*   03   - FIRST CYCLE INDICATOR                                *
     F*   04   - ACCOUNTS MASTER DETAIL RECORD                        *
     F*   05   - CLOSED ACCOUNT                                       *
     F*   07   - ACCOUNTS CATCHALL                                    *
     F*   10   - RETAIL INT. & CHARGES DETAIL                         *
     F*   11   - RETAIL INT. & CHARGES TRAILER                        *
     F*   14   - RETAIL INT. & CHARGES CLOSED RECORD                  *
     F*                                                               *
     F*   22   - RETAIL ACCOUNT NUMBER EXISTS                         *
     F*   23   - ORDERED INDICATOR ON ACCOUNT MASTER HEADER IS BLANK  *
     F*   29   - LEDGER BALANCE IN CREDIT                             *
     F*   30   - NO A/C'S REMOVED                                     *
     F*   31   - NO RECORD FOUND ON STMT1                             *                     BUG26706
     F*   32   - NO RECORD FOUND ON APOSTPD                           *                     BUG26706
     F*   35   - NO RECORD FOUND ON GLACBTL0                          *   076177
0042 F*   36   - CURRENT LEDGER BALANCE IN CREDIT                     *   076177
     F*   41   - RETAIL ACCOUNT                                       *
     F*   42   - ACCOUNT CLOSED MORE THAN AN YEAR AGO                 *
     F*   44   - CHAIN FAIL ON REIAC                                  *
     F*   45   - CHAIN FAIL ON REHISBL                                *
     F*   46   - RUN DATE IS NEXT CAPITALISATION DATE - DEBIT         *
     F*   47   - RUN DATE IS NEXT CAPITALISATION DATE - CREDIT        *
     F*   55   - DIFFERENCE NOT ZERO IN COMP SUBR.                    *
     F*   59   - NO. OF A/C'S OUT OF BALANCE                          *
     F*   60   - CHAIN fail on PMMFHLL1.                              *   S01486
     F*   61   - HASH TOTALS OUT OF BALANCE                           *
     F*   62   - ACCRUALS PROFIT DATE < DATE NEXT WORKING DAY         *
     F*   63   - WORK IND. USED TO DETERMINE IF CAPITAL IS DUE        *
     F*                                                               *
     F*  90-99 - USED IN STANDARD SUBROUTINES                         *
     F*                                                               *
     F****U1***-*ORDERED*IND.*BLANK*-*RE-ORGANISATION*NEEDED***********                       CGL142
     F*   U1   - STATEMENT PRODUCTION REQUIRED                        *                       CGL142
     F*   U3   - AT LEAST ONE RETAIL ACCOUNT FLAGGED FOR CLOSING      *
     F*   U5   - RETAIL II                                            *
     F*   U7   - DATABASE ERROR                                       *
     F*   U8   - FILE CONTROLS OUT OF BALANCE                         *
     F*                                                               *
     F*****************************************************************
     F/EJECT
     F*****************************************************************
     F*                                                               *
     F*  Subroutine Index                                             *
     F*                                                               *
     F*  HASH   - Hash Totals                                         *
     F*  COMP   - check diff bet. integer & dec. part of control total*
     F*  GLZADD - Add an amount to total                              *
     F*  GLZCMP - Compare an amount to total                          *
     F*  GLZSUM - Carry out addition for subroutine                   *
     F*  ZDATE2 - Convert day number to date format                   *
     F*  *PSSR  - Abnormal error conditions                           *
     F*                                                               *
     F*****************************************************************
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D** FORMAT SE DETAILS FOR OUTPUT  (SR/ZFRELN)                        S01486
     D**********          ZLI        20  1                                             S01486 CGL029
     D ZLI             S              1    DIM(26)                                            CGL029
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)              ZDATE SR. ARRAY
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)            ZDATE SR. ARRAY
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY
     D INT             S             15  0 DIM(6)
     D DEC             S              3  0 DIM(6)
     D CommitCtr       S             10I 0 INZ                                              MD024120
     D*                                                        Key - ACCNT
     D***ACCNTK*     DS                             18                                        CGL029
     D ACCNTK          DS            24                                                       CGL029
     D**********                              1   60CNUM                                      CSD027
     D  CNUM                   1      6                                                       CSD027
     D  CCY                    7      9
     D**********                             10  130ACOD                                      CGL029
     D**********                             14  150ACSQ                                      CGL029
     D**********                             16  18 BRCA                                      CGL029
     D  ACOD                  10     19  0                                                    CGL029
     D  ACSQ                  20     21  0                                                    CGL029
     D  BRCA                  22     24                                                       CGL029
     D*
     D** Local Data Area
     D*
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D*
     D SPOOL           DS
     D*
     D**  Data structure for detail spool file information
     D*
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D SPOOLU          DS
     D*
     D**  Data structure for audit spool file information
     D*
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D** Date Area RUNDAT
     D*
     D RUNDT           DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  AGDFF                 12     12
     D  MBIN                  13     13
     D                 DS                                                                     CGL120
     D  WACSQ                  1      2  0                                                    CGL120
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D  TITL         E                     EXTFLD(BJURPT)
     D  DATF         E                     EXTFLD(BJDFIN)
     D  DFBR         E                     EXTFLD(BJSBRC)
     D  SFLG         E                     EXTFLD(BJSUC)
     D  LCD          E                     EXTFLD(BJLCD)
     D  CHTP         E                     EXTFLD(BJTYLC)
     D  DNWD         E                     EXTFLD(BJDNWD)
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
     D  MODI1        E                     EXTFLD(BGSDGL)
     D  MODI2        E                     EXTFLD(BGDLFX)
     D  MODI3        E                     EXTFLD(BGSYLN)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  APDA         E                     EXTFLD(BKAPDT)
      *                                                                                       CLE025
      ** Data structure for SAR details                                                       CLE025
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE025
     D  SCLCD        E                     EXTFLD(LCD)                                        CLE025
      *                                                                                       CLE025
     D*SDRETL***E*DSSDRETLPD                                              080809
     D********      BMLDAI                          LDAC                  080809
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CGL142
     D*
     D** Data Structure for Bank details
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D*
     D** First DS for access programs, short data structure
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D ALL9            S             10S 0 INZ(9999999999)                                 AR1097401
     D*
     D** Second DS for access programs, long data structure
     D*
     D*                                                                   S01408
     D/COPY WNCPYSRC,GL3320IIP1                                           S01408
     D*                                                                   S01408
     D***PSYSVL*         C                   CONST('DeletionDays')                   CER036 MD024120
      ** Parameters for AOSVALR0                                                            MD024120
     D PRtCd           S              7A   INZ                                              MD024120
     D POPT            S             20A   INZ DIM( 10 )                                    MD024120
     D PVAL            S            200A   INZ DIM( 10 )                                    MD024120
                                                                                            MD024120
     D WDELD           S              5I 0 INZ                                              MD024120
     D TSCommitLimit   S                   INZ LIKE( CommitCtr )                            MD024120
     D PerformLRPrc    S               N                                                   MD024120A
     D LastRRN         S                   INZ LIKE( GLTERN )                              MD024120A
     D RRN             S                   INZ LIKE( GLFERN )                               MD033737
     D True            C                   CONST( *ON )                                    MD024120A
     D False           C                   CONST( *OFF )                                   MD024120A
                                                                                            MD024120
     I/EJECT
     I*
     I** Accounts Master - Header
     I*
     IACCNTAA   NS
     I                                  1    1  HHI
     I                                  1  256  ACREC
     I                                257  400  ACREC2
     I                                 23   23  ORDI                    23
     I*
     I** Accounts Master - Detail
     I*
     I***ACBRC**   NS  04    1 CD                                                             CGL120
     IACCNTAB   NS  04    1 CD                                                                CGL120
     I         OR   05    1 CC
     I                                  1  647  ACCTRCD                                       CGL142
     I                                  1    1  RECIAM
     I**********                              2   70CNUM                                      CSD027
     I                                  2    7  CNUM                                          CSD027
     I**********                        8   10  CCY           L2                              CGL120
     I                                  8   10  CCY                                           CGL120
     I**********                             11  140ACOD  L1                                  CGL029
     I                                 11   14 0ACODQQ                                        CGL029
     I                                 15   16 0ACSQ
     I**********                      554  563 0ACOD          L1                       CGL029 CGL120
     I                                554  563 0ACOD                                          CGL120
     I**********                              2  16 ACKYX                                     CGL029
     I                                  2   10  ACKYX                                         CGL029
     I**********                       23   25  BRCA          L3                              CGL120
     I                                 23   25  BRCA                                          CGL120
     I                                 26   26  ATYP
     I                                 29   29  ACST
     I                             P   33   35 0DACC
     I                             P   56   63 0LDBL                  29
     I                                 72   72  STFQ                                          CGL142
     I                             P   75   77 0LSTD                                          CGL142
     I                             P   78   80 0NSTD                                          CGL142
     I                             P   81   82 0LSTP                                          CGL142
     I                             P   83   90 0CFSB                                          CGL142
     I                             P  110  117 0YTDB                                          CGL142
     I                                118  118  GLBT                                          CGL142
     I                             P  135  137 0ORED
     I                                190  199 0ACNO                22
     I                                253  253 0DRIC
     I                                254  254  DRIF
     I                             P  257  259 0NDID
     I                             P  260  262 0LDID
     I                                303  303  DDIS
     I                                329  329 0CRIC
     I                                330  330  CRIF
     I                             P  333  335 0NCID
     I                             P  336  338 0LCID
     I                                379  379  CDIS
     I                             P  394  396 0LCD
     I                                397  397  CHTP
     I**********                            419 4220LTAC                                      CGL029
     I                                419  422 0LTACQQ                                        CGL029
     I                                425  428  PTFR                            S01486
     I                                  1  256  ACREC
     I                                257  400  ACREC2
     I                                564  573 0LTAC                                          CGL029
     I*
     I** Catchall
     I*
     I          NS  07
     I*
     I** Account Master - Trailer
     I*
     I***ACCNTAC   NS                                                                         CGL142
     I**********                        1    1  TTI                                           CGL142
     I**********                        2    8  ACMTKY                                        CGL142
     I**********                   P   23   25 0NORE                                          CGL142
     I**********                   P   29   31 0NOOA                                          CGL142
     I**********                   P   32   34 0NINU                                          CGL142
     I**********                   P   35   37 0NOAM                                          CGL142
     I**********                   P   38   40 0NOCL                                          CGL142
     I**********                   P   41   43 0NOAU                                          CGL142
     I**********                   P   44   46 0NINP                                          CGL142
     I**********                   P   47   49 0NORD                                          CGL142
     I**********                   P   50   52 0NOCF                                          CGL142
     I**********                   P   53   55 0NAMP                                          CGL142
     I**********                   P   56   58 0NAUP                                          CGL142
     I**********                   P   59   66  INT(1)                                        CGL142
     I**********                   P   67   68  DEC(1)                                        CGL142
     I**********                   P   69   76  INT(2)                                        CGL142
     I**********                   P   77   78  DEC(2)                                        CGL142
     I**********                   P  395  397 0LCD                                           CGL142
     I**********                   P  398  400 0TNLU                                          CGL142
     I**********                   P  401  403 0NRET                                          CGL142
     I**********                        1  256  ACREC                                         CGL142
     I**********                      257  400  ACREC2                                        CGL142
     I*
     I** Catchall
     I*
     IACCNT     NS
     I                                  1    1  RECI
     I**********                              2   70CNUM                                      CSD027
     I                                  2    7  CNUM                                          CSD027
     I                                  8   10  CCY
     I**********                             11  140ACOD                                      CGL029
     I                                 15   16 0ACSQ
     I                                 23   25  BRCA
     I                                554  563 0ACOD                                          CGL029
     I***ABEXZY*   NS                                                                  CGL120 CGL142
     I**********                        1    1  TTI                                    CGL120 CGL142
     I**********                   P    2    4 0ZYREC                                  CGL120 CGL142
     I**********                   P    5   12 0ZYINT5                                 CGL120 CGL142
     I**********                   P   13   14 0ZYDEC5                                 CGL120 CGL142
     I**********                   P   15   22 0ZYINT6                                 CGL120 CGL142
     I**********                   P   23   24 0ZYDEC6                                 CGL120 CGL142
     I*                                                                   076177
     IGLACBLF                                                                   076177
     I** Start of Day Account Balances                                    076177
     I              RECI                        RECISB                          076177
     I*
     I** Retail Interest and Charges File
     I*
     IREIAC     NS  14    1 CC
     I          NS  10    1 CD
     I*
     I** REIAC trailer
     I*
     I          NS  11    1 CZ
     I                                  1    1  RECID
     I*
     I** Catchall
     I*
     I          NS
     IREHISPPF
     I              BRCA                        BBRCA
     I              CNUM                        BCNUM
     I              CCY                         BCCY
     I              ACOD                        BACOD
     I              ACSQ                        BACSQ
     I/COPY WNCPYSRC,GL3320I001
     C/EJECT
     C                   MOVEA     CPY@          BIS@             80
     C**********         Z-ADD     0             RRN               9 0               CGL120 MD033737
     C                   Z-ADD     0             RRN                                        MD033737
     C                   MOVE      *BLANKS       OP_PRTF           1                          CGL142
     C*
     C   01              SETOFF                                       02        * Control First
     C  N01              SETON                                        0201      * Page Print
     C*
     C   03              GOTO      DETAIL
     C*
     C** First cycle processing
     C*
     C                   SETON                                        03
     C*                                                                   076177
     C** Receive parameter                                                076177
     C*                                                                   076177
     C     *ENTRY        PLIST                                                                076177
     C                   PARM                    MODE              1                          076177
     C*                                                                   076177
     C**   Define GLACBTL0 Keylist                                        076177
     C     KLIST         KLIST                                                                076177
     C                   KFLD                    CNUM                                         076177
     C                   KFLD                    CCY                                          076177
     C                   KFLD                    ACOD                                         076177
     C                   KFLD                    ACSQ                                         076177
     C                   KFLD                    BRCA                                         076177
     C*                                                                   076177
     C*
     C** Parameter list
     C*
     C     RKEY          KLIST                                                  * Key - REHISBL
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C     MFHLKY        KLIST                                                                S01486
     C                   KFLD                    QFCNUM                                       S01486
     C                   KFLD                    QFMODI                                       S01486
     C                   KFLD                    QFTRNB                                       S01486
     C                   KFLD                    QFTDSS                                       S01486
     C                   KFLD                    QFTXT2                                       S01486
     C                   KFLD                    QFPTFR                                       S01486
     C*                                                                   S01486
     C     MFHLK1        KLIST                                                                S01486
     C                   KFLD                    QFCNUM                                       S01486
     C                   KFLD                    QFMODI                                       S01486
     C                   KFLD                    QFTRNB                                       S01486
      *                                                                                       CLE025
      ** Key list for Account Master Extension file                                           CLE025
      *                                                                                       CLE025
     C     KACEX         KLIST                                                                CLE025
     C                   KFLD                    F1CNUM                                       CLE025
     C                   KFLD                    F1CCY                                        CLE025
     C                   KFLD                    F1ACOD                                       CLE025
     C                   KFLD                    F1ACSQ                                       CLE025
     C                   KFLD                    F1BRCA                                       CLE025
      *                                                                                       CLE025
     C     STMK          KLIST                                                              BUG26706
     C                   KFLD                    BRCA                                       BUG26706
     C                   KFLD                    CNUM                                       BUG26706
     C                   KFLD                    CCY                                        BUG26706
     C                   KFLD                    ACOD                                       BUG26706
     C                   KFLD                    ACSQ                                       BUG26706
     C                   KFLD                    ATYP                                       BUG26706
      *                                                                                     BUG26706
     C     APSK          KLIST                                                              BUG26706
     C                   KFLD                    BRCA                                       BUG26706
     C                   KFLD                    CNUM                                       BUG26706
     C                   KFLD                    CCY                                        BUG26706
     C                   KFLD                    ACOD                                       BUG26706
     C                   KFLD                    ACSQ                                       BUG26706
     C/COPY WNCPYSRC,GL3320C001
     C*
     C** Access Data Area RUNDAT
     C*
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE    RUNDAT        RUNDT
     C                   IN        RUNDT
     C*
     C** Set up *IN98 based on date format
     C*
     C     AGDFF         IFEQ      'M'
     C                   MOVE      '1'           *IN98
     C                   ELSE
     C                   MOVE      '0'           *IN98
     C                   ENDIF
     C                   MOVE      ' '           BLK200          200
     C*
     C** SDBANKPD
     C*
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE                         ***************
     C                   MOVEL     @OPTN         DBKEY                          * DBERROR 001 *
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL     'GL3320'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
     C** SDMMODPD
     C*
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDMMODPD'    DBFILE                         ***************
     C                   MOVEL     @OPTN         DBKEY                          * DBERROR 002 *
     C                   Z-ADD     2             DBASE                          ***************
     C                   MOVEL     'GL3320'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
     C/COPY WNCPYSRC,GL3320C004
      *                                                                   S01486
      ** Open file if PM on                                               S01486
      *                                                                   S01486
     C     BGPFMG        IFEQ      'Y'                                                        S01486
     C                   OPEN      PMMFHLL1                                                   S01486
     C                   END                                                                  S01486
     C** SDGELRPD
     C*
     C/COPY WNCPYSRC,GL3320C010
     C**********           CALL 'AOGELRR0'                                                    CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C********** SDGELR    PARM SDGELR    DSFDY                                               CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
     C/COPY WNCPYSRC,GL3320C011
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDGELRPD'    DBFILE                         ***************
     C                   MOVEL     @OPTN         DBKEY                          * DBERROR 003 *
     C                   Z-ADD     3             DBASE                          ***************
     C                   MOVEL     'GL3320'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER036
     C**********         MOVEL     PSYSVL        PSVLK1                              CER036 MD024120
     C                   EVAL      POPT( 1 ) = 'DeletionDays'                               MD024120
     C                   EVAL      POPT( 2 ) = 'TSCommitGLC3320'                            MD024120
      *                                                                                       CER036
      ** Fetch system values                                                                  CER036
      *                                                                                       CER036
     C                   CALL      'AOSVALR0'                                                 CER036
     C**********         PARM      *BLANKS       PRTCD             7                 CER036 MD024120
     C**********         PARM                    PSVLK1           20                 CER036 MD024120
     C**********         PARM                    PSVL1           200                 CER036 MD024120
     C**********         PARM      *BLANKS       PSVLK2           20                 CER036 MD024120
     C**********         PARM                    PSVL2           200                 CER036 MD024120
     C**********         PARM      *BLANKS       PSVLK3           20                 CER036 MD024120
     C**********         PARM                    PSVL3           200                 CER036 MD024120
     C**********         PARM      *BLANKS       PSVLK4           20                 CER036 MD024120
     C**********         PARM                    PSVL4           200                 CER036 MD024120
     C**********         PARM      *BLANKS       PSVLK5           20                 CER036 MD024120
     C**********         PARM                    PSVL5           200                 CER036 MD024120
     C**********         PARM      *BLANKS       PSVLK6           20                 CER036 MD024120
     C**********         PARM                    PSVL6           200                 CER036 MD024120
     C**********         PARM      *BLANKS       PSVLK7           20                 CER036 MD024120
     C**********         PARM                    PSVL7           200                 CER036 MD024120
     C**********         PARM      *BLANKS       PSVLK8           20                 CER036 MD024120
     C**********         PARM                    PSVL8           200                 CER036 MD024120
     C**********         PARM      *BLANKS       PSVLK9           20                 CER036 MD024120
     C**********         PARM                    PSVL9           200                 CER036 MD024120
     C**********         PARM      *BLANKS       PSVLK0           20                 CER036 MD024120
     C**********         PARM                    PSVL0           200                 CER036 MD024120
     C                   PARM      *BLANKS       PRtCd                                      MD024120
     C                   PARM                    POPT( 1 )                                  MD024120
     C                   PARM                    PVAL( 1 )                                  MD024120
     C                   PARM                    POPT( 2 )                                  MD024120
     C                   PARM                    PVAL( 2 )                                  MD024120
     C                   PARM                    POPT( 3 )                                  MD024120
     C                   PARM                    PVAL( 3 )                                  MD024120
     C                   PARM                    POPT( 4 )                                  MD024120
     C                   PARM                    PVAL( 4 )                                  MD024120
     C                   PARM                    POPT( 5 )                                  MD024120
     C                   PARM                    PVAL( 5 )                                  MD024120
     C                   PARM                    POPT( 6 )                                  MD024120
     C                   PARM                    PVAL( 6 )                                  MD024120
     C                   PARM                    POPT( 7 )                                  MD024120
     C                   PARM                    PVAL( 7 )                                  MD024120
     C                   PARM                    POPT( 8 )                                  MD024120
     C                   PARM                    PVAL( 8 )                                  MD024120
     C                   PARM                    POPT( 9 )                                  MD024120
     C                   PARM                    PVAL( 9 )                                  MD024120
     C                   PARM                    POPT( 10 )                                 MD024120
     C                   PARM                    PVAL( 10 )                                 MD024120
      *                                                                                       CER036
     C*****PRTCD         IFNE      *BLANKS                                           CER036 MD024120
     C                   IF        PRtCd <> *BLANKS                                         MD024120
      *                                                                                       CER036
     C     *LOCK         IN        LDA                                                        CER036
     C                   MOVEL     'SDSVALPD'    DBFILE                                       CER036
     C**********         MOVEL     PSVLK1        DBKEY                               CER036 MD024120
     C                   EVAL      DBKEY = 'POPT'                                           MD024120
     C                   Z-ADD     012           DBASE                                        CER036
     C                   MOVEL     'GL3320'      DBPGM                                        CER036
     C                   OUT       LDA                                                        CER036
     C                   EXSR      *PSSR                                                      CER036
      *                                                                                       CER036
     C                   ELSE                                                                 CER036
      *                                                                                       CER036
     C**********         MOVEL     PSVL1         WDELD             3 0               CER036 MD024120
     C                   EVAL      WDELD = %DEC( PVAL( 1 ) : 3 : 0 )                        MD024120
     C                   EVAL      TSCommitLimit = %DEC( PVAL( 2 ) : 6 : 0 )                MD024120
      *                                                                                       CER036
     C                   ENDIF                                                                CER036
      *                                                                                       CER036
     C                   MOVEL     'N'           CER036                                       CER036
      *                                                                                       CER036
      ** Check if CER036 (DeletionDays) is installed                                          CER036
      *                                                                                       CER036
     C                   CALL      'AOSARDR0'                                                 CER036
     C                   PARM      *BLANKS       PRTCD                                        CER036
     C                   PARM      '*VERIFY'     POPTN             7                          CER036
     C                   PARM      'CER036'      PSARD             6                          CER036
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER036
      *                                                                                       CER036
     C     PRTCD         IFNE      *BLANKS                                                    CER036
     C     PRTCD         ANDNE     '*NRF   '                                                  CER036
     C     *LOCK         IN        LDA                                                        CER036
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER036
     C                   MOVEL     PSARD         DBKEY                                        CER036
     C                   Z-ADD     013           DBASE                                        CER036
     C                   MOVEL     'GL3320'      DBPGM                                        CER036
     C                   OUT       LDA                                                        CER036
     C                   EXSR      *PSSR                                                      CER036
     C                   ENDIF                                                                CER036
      *                                                                                       CER036
     C     PRTCD         IFEQ      *BLANKS                                                    CER036
     C                   MOVEL     'Y'           CER036            1                          CER036
     C                   ENDIF                                                                CER036
      *                                                                                       CLE025
      ** Check if CLE025 (Credit Lines) is installed                                          CLE025
      *                                                                                       CLE025
     C                   CALL      'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       @RTCD                                        CLE025
     C                   PARM      '*VERIFY'     @OPTN                                        CLE025
     C                   PARM      'CLE025'      @SARD             6                          CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
      *                                                                                       CLE025
     C     @RTCD         IFNE      *BLANKS                                                    CLE025
     C     @RTCD         ANDNE     '*NRF   '                                                  CLE025
     C     *LOCK         IN        LDA                                                        CLE025
     C                   MOVEL(P)  'SCSARDPD'    DBFILE                                       CLE025
     C                   MOVEL(P)  @SARD         DBKEY                                        CLE025
     C                   Z-ADD     011           DBASE                                        CLE025
     C                   MOVEL(P)  'GL3320'      DBPGM                                        CLE025
     C                   OUT       LDA                                                        CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
      *                                                                                       CLE025
     C     @RTCD         IFEQ      *BLANKS                                                    CLE025
     C                   MOVEL     'Y'           CLE025            1                          CLE025
     C                   ELSE                                                                 CLE025
     C                   MOVEL     'N'           CLE025                                       CLE025
     C                   ENDIF                                                                CLE025
     C/COPY WNCPYSRC,GLH00530
      *                                                                                       CGP013
      ** Check if CGP013 is installed                                                         CGP013
      *                                                                                       CGP013
     C                   CALL      'AOSARDR0'                                                 CGP013
     C                   PARM      *BLANKS       @RTCD                                        CGP013
     C                   PARM      '*VERIFY'     @OPTN                                        CGP013
     C                   PARM      'CGP013'      @SARD             6                          CGP013
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGP013
      *                                                                                       CGP013
     C     @RTCD         IFNE      *BLANKS                                                    CGP013
     C     @RTCD         ANDNE     '*NRF   '                                                  CGP013
     C     *LOCK         IN        LDA                                                        CGP013
     C                   MOVEL(P)  'SCSARDPD'    DBFILE                                       CGP013
     C                   MOVEL(P)  @SARD         DBKEY                                        CGP013
     C                   Z-ADD     012           DBASE                                        CGP013
     C                   MOVEL(P)  'GL3320'      DBPGM                                        CGP013
     C                   OUT       LDA                                                        CGP013
     C                   EXSR      *PSSR                                                      CGP013
     C                   ENDIF                                                                CGP013
      *                                                                                       CGP013
     C     @RTCD         IFEQ      *BLANKS                                                    CGP013
     C                   MOVEL     'Y'           CGP013            1                          CGP013
     C                   OPEN      ACNTDLPD                                                   CGP013
     C                   ELSE                                                                 CGP013
     C                   MOVEL     'N'           CGP013                                       CGP013
     C                   ENDIF                                                                CGP013
                                                                                              CGL142
     C                   CALL      'AOSARDR0'                                                 CGL142
     C                   PARM      *BLANKS       @RTCD                                        CGL142
     C                   PARM      '*VERIFY'     @OPTN                                        CGL142
     C                   PARM      'ULX004'      @SARD                                        CGL142
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL142
                                                                                              CGL142
     C     @RTCD         IFEQ      *BLANKS                                                    CGL142
     C                   MOVEL     'Y'           ULX004            1                          CGL142
     C                   ELSE                                                                 CGL142
     C                   MOVEL     'N'           ULX004                                       CGL142
     C                   ENDIF                                                                CGL142
                                                                                              CGL142
     C**********         CALL      'AOSARDR0'                                       CGL142 AR1097385
     C**********         PARM      *BLANKS       @RTCD                              CGL142 AR1097385
     C**********         PARM      '*VERIFY'     @OPTN                              CGL142 AR1097385
     C**********         PARM      'CGL001'      @SARD                              CGL142 AR1097385
     C*****SCSARD        PARM      SCSARD        DSFDY                              CGL142 AR1097385
                                                                                    CGL142 AR1097385
     C*****@RTCD         IFEQ      *BLANKS                                          CGL142 AR1097385
     C**********         MOVEL     'Y'           CGL001            1                CGL142 AR1097385
     C**********         ELSE                                                       CGL142 AR1097385
     C**********         MOVEL     'N'           CGL001                             CGL142 AR1097385
     C**********         ENDIF                                                      CGL142 AR1097385
                                                                                              CGL142
     C                   CALL      'AOSARDR0'                                                 CGL142
     C                   PARM      *BLANKS       @RTCD                                        CGL142
     C                   PARM      '*VERIFY'     @OPTN                                        CGL142
     C                   PARM      'CGL048'      @SARD                                        CGL142
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL142
                                                                                              CGL142
     C     @RTCD         IFEQ      *BLANKS                                                    CGL142
     C                   MOVEL     'Y'           CGL048            1                          CGL142
     C                   ELSE                                                                 CGL142
     C                   MOVEL     'N'           CGL048                                       CGL142
     C                   ENDIF                                                                CGL142
                                                                                              CGL142
     C                   CALL      'AOSARDR0'                                                 CGL142
     C                   PARM      *BLANKS       @RTCD                                        CGL142
     C                   PARM      '*VERIFY'     @OPTN                                        CGL142
     C                   PARM      'CSD023'      @SARD                                        CGL142
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL142
                                                                                              CGL142
     C     @RTCD         IFEQ      *BLANKS                                                    CGL142
     C                   MOVEL     'Y'           CSD023            1                          CGL142
     C                   ELSE                                                                 CGL142
     C                   MOVEL     'N'           CSD023                                       CGL142
     C                   ENDIF                                                                CGL142
                                                                                              253181
      ** Check if the 2 o'clock flag (SAR CRE023) is switched on                              253181
                                                                                              253181
     C                   MOVE      *BLANKS       @RTCD                                        253181
     C                   MOVEL     *BLANKS       CRE023            1                          253181
     C                   CALL      'AOSARDR0'                                                 253181
     C                   PARM      *BLANKS       @RTCD                                        253181
     C                   PARM      '*VERIFY'     @OPTN                                        253181
     C                   PARM      'CRE023'      @SARD                                        253181
     C                   PARM      *BLANKS       DSFDY                                        253181
                                                                                              253181
     C     @RTCD         IFEQ      *BLANK                                                     253181
     C                   OPEN      REMEMLL0                                                   253181
     C                   MOVEL     'Y'           CRE023                                       253181
     C                   ELSE                                                                 253181
     C                   MOVEL     'N'           CRE023                                       253181
     C                   END                                                                  253181
     C*
     C***SDRETLPD                                                         080809
     C*******                                                             080809
     C*******              CALL 'AORETLR0'                                080809
     C*******              PARM '*MSG   ' @RTCD                           080809
     C*******              PARM '*FIRST ' @OPTN                           080809
     C*******    SDRETL    PARM SDRETL    DSFDY                           080809
     C*******    @RTCD     IFNE *BLANK                                    080809
     C*******    *LOCK     IN   LDA                                       080809
     C*******              MOVEL'SDRETLPD'DBFILE           ***************080809
     C*******              MOVEL@OPTN     DBKEY            * DBERROR 004 *080809
     C*******              Z-ADD4         DBASE            ***************080809
     C*******              MOVEL'GL3320'  DBPGM                           080809
     C*******              OUT  LDA                                       080809
     C*******              EXSR *PSSR                                     080809
     C*******              ENDIF                                          080809
     C     APDA          COMP      DNWD                                 62
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL3320CCP1                                           S01408
     C*                                                                   S01408
     C*
     C** Seton Switch 1 if order indicator is blank
     C*
     C                   READ      ACCNTAA                                99
     C  N99HHI           COMP      'H'                                9999
     C     *IN99         IFEQ      *ON
     C                   SETON                                        U7LR
     C     *LOCK         IN        LDA
     C                   MOVEL     'ACCNT'       DBFILE                         ***************
     C                   MOVE      BLK200        DBKEY                          * DBERROR 005 *
     C                   MOVEL     'HEADER'      DBKEY                          ***************
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'GL3320'      DBPGM
     C                   OUT       LDA
     C                   GOTO      ENDF
     C                   ENDIF
     C***23*****         SETON                                        U1   * blank order ind. CGL142
     C*                                                                                       CGL120
     C**********         UNLOCK    ACCNTAA                                             CGL120 CGL142
     C*                                                    * reorg needed
     C** Define zero fields
     C*
     C                   Z-ADD     0             ZER15            15 3
     C                   Z-ADD     0             ZER13            13 3
     C                   Z-ADD     0             ZERO5             5 0
     C                   Z-ADD     0             ZERO15           15 0
     C                   Z-ADD     0             TNSAW             5 0                        CGL142
     C/COPY WNCPYSRC,GL3320C007
     C*
     C     DETAIL        TAG                                                    **DETAIL TAG**
     C     1             CHAIN(N)  GLACBAPD                                                MD024120A
     C                   IF        NOT %FOUND( GLACBAPD )                                  MD024120A
     C                   EVAL      PerformLRPrc = True                                     MD024120A
     C                   ENDIF                                                             MD024120A
                                                                                           MD024120A
     C                   IF        %FOUND( GLACBAPD )                                      MD024120A
      *                                                                                     MD033737
     C                   IF        GLFERN = ALL9                                            MD033737
     C                   EVAL      RRN = GLFERN                                             MD033737
     C                   EVAL      LastRRN = GLTERN                                         MD033737
     C                   EVAL      PerformLRPrc = True                                      MD033737
     C                   ELSE                                                               MD033737
      *
     C     GLTERN        IFNE      ALL9                                                    AR1097401
     C     PerformLRPrc  ANDNE     True                                                     MD033737
     C     GLTERN        SETGT     ACCNTAB                                                 AR1097401
     C                   READP(N)  ACCNTAB                                                 AR1097401
     C                   IF        NOT %EOF                                                AR1097401
     C                   EVAL      GLTERN = RRN                                            AR1097401
     C                   ENDIF                                                             AR1097401
     C                   ENDIF                                                             AR1097401
     C                   EVAL      LastRRN = GLTERN                                        MD024120A
     C     GLFERN        SETLL     ACCNTAB                                                    CGL120
     C                   SETOFF                                       0405                    CGL120
     C                   READ      ACCNTAB                                                    CGL120
     C                   ENDIF                                                             MD024120A
      *                                                                                     MD033737
     C                   ENDIF                                                              MD033737
                                                                                           MD024120A
     C                   Z-ADD     0             NoRec             5 0                      MD031642
     C**********         DOW       NOT %EOF(ACCNTAB) AND RRN <= GLTERN              CGL120 MD024120A
     C                   DOW       NOT %EOF(ACCNTAB) AND RRN <= LastRRN                    MD024120A
     C                             AND NOT PerformLRPrc                                    MD024120A
                                                                                              CGL142
     C                   EVAL      NoRec = NoRec + 1                                        MD031642
      ** Ignore X records from ZACCNTAB                                                       CGL142
                                                                                              CGL142
     C     RECIAM        IFNE      'X'                                                        CGL142
     C*
     C** Reset indicators
     C*
     C                   SETOFF                                       42
     C   U5              SETOFF                                       4647
     C*
     C** Ignore non-detail records
     C*
     C   07              GOTO      END
     C*
     C** Setup key for REIAC
     C*
     C**********           MOVELACKYX     ACKY   18                                           CGL029
     C                   MOVEL     ACOD          WACAS            12                          CGL029
     C                   MOVE      ACSQ          WACAS                                        CGL029
     C                   MOVEL     ACKYX         WACKYX           21                          CGL029
     C                   MOVE      WACAS         WACKYX           21                          CGL029
     C                   MOVEL     WACKYX        ACKY             24                          CGL029
     C                   MOVE      BRCA          ACKY
     C*
     C** Accumulate ledger balances for ABEXAG
     C*
     C** Access Start of business Ledger Balance for ABEX                 076177
     C** to get balances before Real Time Postings Applied.               076177
     C*                                                                   076177
     C                   Z-ADD     LDBL          SLDBL            15 0                        076177
     C                   MOVE      *IN29         *IN36                                        076177
     C*                                                                   076177
     C                   MOVE      '0'           *IN35                                        185118
     C     MODE          IFEQ      '1'                                                        076177
     C     KLIST         CHAIN     GLACBLF                            3535                    076177
     C*                                                                   076177
     C     *IN35         IFEQ      '0'                                                        076177
     C*                                                                   076177
     C     LDBL          IFGE      *ZERO                                                      076177
     C                   MOVE      '0'           *IN29                                        076177
     C                   ELSE                                                                 076177
     C                   MOVE      '1'           *IN29                                        076177
     C                   END                                                                  076177
     C*                                                                   076177
     C                   END                                                                  076177
     C                   END                                                                  076177
     C*                                                                   076177
     C***29******          ADD  LDBL      CRBL   150                      185118
     C**N29******          ADD  LDBL      DRBL   150                      185118
     C***29*****                                                                              CGL120
     C***ANN35**            ADD       LDBL          CRBL             15 0              185118 CGL120
     C**N29*****                                                                              CGL120
     C***ANN35**            ADD       LDBL          DRBL             15 0              185118 CGL120
     C*
     C** Test to see whether the account is retail/non-retail
     C*
     C     ATYP          COMP      'R'                                    41
     C*
     C** Check whether account was closed more than a year ago
     C*
     C   05RUND          SUB       DACC          GTDAT             5 0
     C/COPY WNCPYSRC,GL3320C003
      *                                                                                       CER036
     C     CER036        IFEQ      'Y'                                                        CER036
      *                                                                                       CER036
     C     WDELD         IFGT      *ZEROS                                                     CER036
     C     DNWD          SUB       DACC          WDUR              5 0                      BUG23075
      *                                                                                       CER036
     C     *IN05         IFEQ      *ON                                                        CER036
     C********** GTDAT     ANDGTWDELD                                                CER036 BUG23075
     C     WDUR          ANDGE     WDELD                                                    BUG23075
     C********** DACC      ANDNEBJRDNB                                             BUG26202 BUG26706
     C********** STMK      SETLLSTMT1                31                           BUG26706 BUG26706A
     C********** APSK      SETLLAPOSTL1              32                           BUG26706 BUG26706A
     C     STMK          CHAIN     STMT1                              31                   BUG26706A
     C     APSK          CHAIN     APOSTL1                            32                   BUG26706A
     C     *IN31         IFEQ      *ON                                                      BUG26706
     C     *IN32         ANDEQ     *ON                                                      BUG26706
      *                                                                                       CER036
     C                   SETON                                        42                      CER036
      *                                                                                       CER036
     C                   ELSE                                                                 CER036
      *                                                                                       CER036
     C                   SETOFF                                       42                      CER036
      *                                                                                       CER036
     C                   ENDIF                                                                CER036
     C                   ENDIF                                                                CER036
     C                   ENDIF                                                              BUG26706
      *                                                                                       CER036
     C                   ELSE                                                                 CER036
      *                                                                                       CER036
     C   05GTDAT         COMP      365                                42
      *                                                                                       CER036
     C                   ENDIF                                                                CER036
      *                                                                   S01408
     C/COPY WNCPYSRC,GL3320CCP4                                           S01408
      *                                                                   S01408
     C*
     C** Accumulate number of records being dropped
     C*
     C     *IN42         IFEQ      *ON
     C*
     C** Calling of RPG/GL3320D to drop the postings, with parameters
     C***from*file*ACBRC***********************************************                       CGL120
      ** from file GLACBAPD                                                                   CGL120
     C*
     C                   MOVE      BRCA          @BRCA
     C                   MOVE      CNUM          @CNUM
     C                   MOVE      ACOD          @ACOD
     C                   MOVE      ACSQ          @ACSQ
     C                   MOVE      ACNO          @ACNO                                        137916
     C                   MOVE      ACNO          KACNO            10 0                        253181
     C                   CALL      'GL3320D'
     C                   PARM      *BLANKS       @TERM             1
     C                   PARM                    @BRCA             3
     C                   PARM                    @CNUM             6
     C                   PARM      CCY           @CCY              3
     C**********           PARM           @ACOD   4                                           CGL029
     C                   PARM                    @ACOD            10                          CGL029
     C                   PARM                    @ACSQ             2
     C                   PARM                    @ACNO            10                          137916
     C     @TERM         IFEQ      'E'
     C                   SETON                                        U7LR
     C     *LOCK         IN        LDA
     C                   MOVEL     *BLANKS       DBFILE                         ***************
     C                   MOVE      BLK200        DBKEY                          * DBERROR 006 *
     C                   MOVEL     'TERM E'      DBKEY                          ***************
     C                   Z-ADD     6             DBASE
     C                   MOVEL     'GL3320D'     DBPGM
     C                   OUT       LDA
     C                   GOTO      ENDF
     C                   ENDIF
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL3320CCPG                                           S01408
     C*                                                                   S01408
      ** If CRE023 is on, chain acno to file REMEMLPD and delete it                           253181
      *                                                                                       253181
     C     CRE023        IFEQ      'Y'                                                        253181
     C                   SETOFF                                       37                      253181
     C     KACNO         CHAIN     REMEMLL0                           37                      253181
     C     *IN37         IFEQ      '0'                                                        253181
     C                   DELETE    REMEMLL0                                                   253181
     C                   END                                                                  253181
     C                   END                                                                  253181
     C*
     C                   ADD       1             NODROP            5 0
     C     ATYP          IFEQ      'R'
     C                   ADD       1             REDROP            5 0
     C                   ENDIF
     C*
     C** Convert date closed to DDMMMYY
     C*
     C                   Z-ADD     DACC          ZDAYNO
     C                   EXSR      ZDATE2
     C     ACCNTK        CHAIN     ACCNT                              99
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL3320CCP2                                           S01408
     C*                                                                   S01408
     C                   EXCEPT    DELACC
      *                                                                                       CGP013
      * Write to file of deleted accounts if global update task-split is present              CGP013
     C     CGP013        IFEQ      'Y'                                                        CGP013
     C                   WRITE     ACNTDLPF                                                   CGP013
     C                   ENDIF                                                                CGP013
      *                                                                                       CLE025
      ** Also delete from the Extension file                                                  CLE025
      *                                                                                       CLE025
     C********** CLE025    IFEQ 'Y'                                                   CLE025 BUG7418
     C**********           Z-ADDCNUM      F1CNUM                                       CLE025 CSD027
     C                   MOVE      CNUM          F1CNUM                                       CSD027
     C                   MOVE      CCY           F1CCY                                        CLE025
     C                   Z-ADD     ACOD          F1ACOD                                       CLE025
     C                   Z-ADD     ACSQ          F1ACSQ                                       CLE025
     C                   MOVE      BRCA          F1BRCA                                       CLE025
     C     KACEX         CHAIN     GLACNTL4                           81                      CLE025
     C     *IN81         IFEQ      *OFF                                                       CLE025
     C                   DELETE    GLACNTL4                                                   CLE025
     C/COPY WNCPYSRC,GLH00531
     C                   ENDIF                                                                CLE025
     C**********           ENDIF                                                      CLE025 BUG7418
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL3320CCP3                                           S01408
     C*                                                                   S01408
     C*
     C** IF PORTFOLIO REFERENCE NOT BLANK DELETE ALL HOLDINGS FOR THE     S01486
     C** DEAL FROM LF/PMMFHLL1                                            S01486
     C     BGPFMG        IFEQ      'Y'                                                        S01486
     C     PTFR          IFNE      *BLANKS                                                    S01486
     C                   MOVE      CNUM          QFCNUM                                       S01486
     C                   MOVE      'RE'          QFMODI                                       S01486
     C                   MOVE      '000000'      QFTRNB                                       S01486
     C                   MOVE      *BLANKS       QFTDSS                                       S01486
     C                   MOVE      *LOVAL        QFPTFR                                       S01486
     C*                                                                   S01486
     C**********           Z-ADDCNUM      ZCNUM                                        S01486 CSD027
     C                   MOVE      CNUM          ZCNUM                                        CSD027
     C                   MOVEL     CCY           ZCCY                                         S01486
     C                   MOVEL     ACOD          ZACOD                                        S01486
     C                   MOVEL     ACSQ          ZACSQ                                        S01486
     C                   EXSR      ZFRELN                                                     S01486
     C                   MOVEL     ZLIN          QFTXT2                                       S01486
     C*                                                                   S01486
     C** SET FILE POINTER BEFORE FIRST RECORD FOR DEAL                    S01486
     C     MFHLKY        SETLL     PMMFHLL1                                                   S01486
     C     MFHLK1        READE     PMMFHLL1                               60                  S01486
     C*                                                                   S01486
     C     *IN60         DOWEQ     '0'                                                        S01486
     C                   DELETE    PMHOLDP0                                                   S01486
     C     MFHLK1        READE     PMMFHLL1                               60                  S01486
     C                   END                                                                  S01486
     C*                                                                   S01486
     C                   END                                                                  S01486
     C                   END                                                                  S01486
     C/COPY WNCPYSRC,GL3320C002
     C                   ENDIF
     F*CO*Y*WNC*YS*C*GL3320F001                                           S01408
     C/COPY WNCPYSRC,GL3320C006
     C*
     C** If the account was closed more than a year ago, delete the
     C** related REIAC record
     C*
     C   U5              DO
     C                   SETOFF                                       44
     C   41
     CAN 42ACKY          CHAIN     REIAC                              44
     C     *IN44         IFEQ      *ON
     C                   SETON                                        U7LR
     C     *LOCK         IN        LDA
     C                   MOVEL     'REIAC'       DBFILE                         ***************
     C                   MOVE      BLK200        DBKEY                          * DBERROR 007 *
     C                   MOVEL     ACKY          DBKEY                          ***************
     C                   Z-ADD     7             DBASE
     C                   MOVEL     'GL3320'      DBPGM
     C                   OUT       LDA
     C                   GOTO      ENDF
     C                   ENDIF
     C*
     C** If record is being dropped, update REIACD with * in RECI
     C*
     C     *IN41         IFEQ      *ON
     C     *IN42         ANDEQ     *ON
     C     *IN10         IFEQ      *ON
     C     *IN14         OREQ      *ON
     C                   EXCEPT    RECIA
     C/COPY WNCPYSRC,GL3320C005
     C                   ENDIF
     C                   ENDIF
     C*
     C** Check next cap. date to see if cap. due for debit or credit
     C*
     C   05                                                                     NOT DETAIL
     CORN41              GOTO      END                                          OR RETAIL
     C*
     C                   Z-ADD     0             WKDT              5 0
     C     ACST          COMP      'C'                                    63
     C   63              GOTO      FLAG
     C*
     C     NDID          COMP      0                                      63
     C   63              GOTO      DRDEM
     C*
     C   62NDID          COMP      APDA                                 4646
     C  N62NDID          COMP      DNWD                                 46
     C*
     C     *IN46         IFEQ      *ON
     C                   MOVE      'Y'           DDIS
     C                   ENDIF
     C*
     C  N46DDIS          COMP      'D'                                    46
     C*
     C     DRDEM         TAG                                                    **DRDEM TAG**
     C     DDIS          COMP      'D'                                    46
     C   46              GOTO      CRCHK
     C*
     C     DRIF          COMP      'Z'                                    63
     C/COPY WNCPYSRC,GL3320C012
     C     NDID          IFEQ      0                                                          235284
     C   63LDID          ADD       183           WKDT
     C   63WKDT          COMP      DNWD                                 46
     C   46              MOVE      'D'           DDIS
     C                   ELSE                                                                 235284
     C   63                                                                                   235284
     CAN 62NDID          COMP      APDA                                 46                    235284
     C   63                                                                                   235284
     CANN62NDID          COMP      DNWD                                 46                    235284
     C   46              MOVE      'D'           DDIS                                         235284
     C                   END                                                                  235284
     C/COPY WNCPYSRC,GL3320C013
     C*
     C     CRCHK         TAG                                                    **CRCHK TAG**
     C*
     C     NCID          COMP      0                                      63
     C   63              GOTO      CRDEM
     C*
     C   62NCID          COMP      APDA                                 4747
     C  N62NCID          COMP      DNWD                                 47
     C*
     C     *IN47         IFEQ      *ON
     C                   MOVE      'Y'           CDIS
     C                   ENDIF
     C*
     C  N47CDIS          COMP      'D'                                    47
     C                   GOTO      PASS
     C*
     C     CRDEM         TAG                                                    **CRDEM TAG**
     C*
     C     CDIS          COMP      'D'                                    47
     C   47              GOTO      PASS
     C*
     C     CRIF          COMP      'Z'                                    63
     C/COPY WNCPYSRC,GL3320C014
     C     NCID          IFEQ      0                                                          235284
     C   63LCID          ADD       183           WKDT
     C   63WKDT          COMP      DNWD                                 47
     C   47              MOVE      'D'           CDIS
     C                   ELSE                                                                 235284
     C   63                                                                                   235284
     CAN 62NCID          COMP      APDA                                 47                    235284
     C   63                                                                                   235284
     CANN62NCID          COMP      DNWD                                 47                    235284
     C   47              MOVE      'D'           CDIS                                         235284
     C                   END                                                                  235284
     C                   GOTO      PASS
     C/COPY WNCPYSRC,GL3320C015
     C*
     C     FLAG          TAG                                                    **FLAG TAG**
     C                   SETON                                        4647
     C                   MOVE      'C'           DDIS
     C                   MOVE      'C'           CDIS
     C                   SETON                                        U3
     C*
     C     PASS          TAG                                                    **PASS TAG**
     C*
     C** Do not allow combination of management and other capitalisation
     C*
     C     DDIS          IFEQ      'C'
     C     DDIS          OREQ      'D'
     C     DDIS          OREQ      'Y'
     C     CDIS          IFEQ      'M'
     C                   MOVE      ' '           CDIS
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C     CDIS          IFEQ      'C'
     C     CDIS          OREQ      'D'
     C     CDIS          OREQ      'Y'
     C     DDIS          IFEQ      'M'
     C                   MOVE      ' '           DDIS
     C                   ENDIF
     C*
     C                   ENDIF
     C/COPY WNCPYSRC,GL3320C009
     C*
     C** Obtain REHISB record for update
     C*
     C     DDIS          IFNE      ' '
     C     CDIS          ORNE      ' '
     C     *IN41         OREQ      '1'                                                        052664
     C     APDA          ANDLE     DNWD                                                       052664
     C*
     C     RKEY          CHAIN     REHISPPF                           45
     C     *IN45         IFEQ      *ON
     C                   SETON                                        U7LR
     C     *LOCK         IN        LDA
     C                   MOVEL     'REHIS'       DBFILE                         ***************
     C                   MOVE      BLK200        DBKEY                          * DBERROR 008 *
     C                   MOVEL     ACKY          DBKEY                          ***************
     C                   Z-ADD     8             DBASE
     C                   MOVEL     'GL3320'      DBPGM
     C                   OUT       LDA
     C                   GOTO      ENDF
     C                   ENDIF
     C*
     C                   MOVE      'Y'           ADTY
     C                   MOVE      DDIS          DICI
     C                   MOVE      CDIS          CICI
     C                   UPDATE    REHISPPF
     C*
     C/COPY WNCPYSRC,GL3320C008
     C     *IN46         IFEQ      *ON
     C     *IN47         OREQ      *ON
     C     RECCP         ADD       1             RECCP             5 0          CAPIT WRITTEN
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C     END           TAG                                                    **END TAG**
     C*
     C** Force end of processing on trailer
     C*
     C   07              GOTO      ENDF
     C*
     C** Control Totals - Accounts Master
     C*
     C   04
     CANN42
     COR 05
     CANN42              ADD       1             RECWR             5 0
     C*
     C** Control Totals - Accounts Balances Extract File
     C*
     C   04RECEX         ADD       2             RECEX             5 0          ABEX WRITTEN
     C   U1
     CAN 42RECRM         ADD       1             RECRM             5 0          ACCNT REMOVED
     C   U5              DO
     C   10
     CAN 41
     CAN 42RECDE         ADD       1             RECDE             5 0          REIAC DELETED
     C                   ENDDO
     C                   ENDDO
     C*
     C** Hash Totals
     C*
     C                   ADD       1             RECRD             5 0          RECS READ
     C                   ADD       1             RECRD7            7 0          RECS READ     254563
     C   05              GOTO      ENDF
     C*
     C***********          MOVE LDBL      ZZAMT                           076177
     C***29******          Z-SUBZZAMT     ZZAMT                           076177
     C***********          Z-ADD3         X                               076177
     C***29******          Z-ADD4         X                               076177
     C***********          EXSR HASH                                      076917
     C                   MOVE      SLDBL         ZZAMT                                        076177
     C   36              Z-SUB     ZZAMT         ZZAMT                                        076177
     C                   Z-ADD     3             X                                            076177
     C   36              Z-ADD     4             X                                            076177
     C                   EXSR      HASH                                                       076177
      *                                                                   076177
     C                   MOVE      LDBL          ZZAMT                                        076177
     C***29******          Z-SUBZZAMT     ZZAMT                    076177 185118
     C   29
     CANN35              Z-SUB     ZZAMT         ZZAMT                                        185118
     C                   Z-ADD     5             X
     C***29******          Z-ADD6         X                               185118
     C   29
     CANN35              Z-ADD     6             X                                            185118
     C***********ZZAMT     ADD  ZZAMT     ZZAMT                           185118
     C***********          EXSR HASH                                      185118
     C  N35              EXSR      HASH                                                       185118
     C                   Z-ADD     5             X                                            185118
     C   29
     CANN35              Z-ADD     6             X                                            185118
     C  N35              EXSR      HASH                                                       185118
     C*
     C     ENDF          TAG                                                    **ENDF TAG**
      *
     C                   IF        *IN04 = *ON                                                CGL120
     C                   EXCEPT    ABEXDT                                                     CGL120
     C                   ENDIF                                                                CGL120
      *
     C   U1              IF        *IN05 AND *IN42 = *ON                                      CGL120
     C     OP_PRTF       IFEQ      *BLANKS                                                    CGL142
     C                   OPEN      GL3320A1                                                   CGL142
     C                   MOVE      'Y'           OP_PRTF                                      CGL142
     C                   ENDIF                                                                CGL142
     C                   EXCEPT    BALEXD                                                     CGL120
     C                   SETOFF                                       02                      CGL120
     C                   ENDIF                                                                CGL120
      *
     C                   IF        *IN04 = *ON                                                CGL142
                                                                                              CGL142
      ** Write to REANX1PD                                                                    CGL142
                                                                                              CGL142
     C     BGLRIN        IFEQ      'Y'                                                        CGL142
     C     ULX004        ANDEQ     'Y'                                                        CGL142
     C                   EXSR      EXTEN                                                      CGL142
     C                   ENDIF                                                                CGL142
                                                                                              CGL142
      ** Check for closing accounts                                                           CGL142
                                                                                              CGL142
     C                   EXSR      ACCCLO                                                     CGL142
     C     ACCLO@        IFEQ      'Y'                                                        CGL142
     C                   EXCEPT    CACCNT                                                     CGL142
     C                   ENDIF                                                                CGL142
                                                                                              CGL142
      ** Write to STMTAH                                                                      CGL142
                                                                                              CGL142
     C*****CGL001        IFEQ      'Y'                                              CGL142 AR1097385
     C*****STFQ          ANDEQ     'N'                                              CGL142 AR1097385
     C     STFQ          IFEQ      'N'                                                     AR1097385
                                                                                              CGL142
     C                   MOVE      GLBT          SVGLBT                                       CGL142
     C     KLIST         CHAIN     ACCNTL0                                                    CGL142
     C                   IF        %FOUND(ACCNTL0)                                            CGL142
     C                   Z-ADD     LDBL          CFSB                                         CGL142
     C                   Z-ADD     DNWD          NSTD                                         CGL142
     C                   Z-ADD     RUND          LSTD                                         CGL142
     C                   MOVE      SVGLBT        GLBT                                         CGL142
     C                   UPDATE    ACCNTL0F                                                   CGL142
     C                   ENDIF                                                                CGL142
                                                                                              CGL142
     C                   ELSE                                                                 CGL142
     C                   EXSR      BALSTA                                                     CGL142
     C                   IF        GLBT <> SVGLBT                                             CGL142
     C                   MOVE      GLBT          SVGLBT                                       CGL142
     C     KLIST         CHAIN     ACCNTL0                                                    CGL142
     C                   IF        %FOUND(ACCNTL0)                                            CGL142
     C                   MOVE      SVGLBT        GLBT                                         CGL142
     C                   UPDATE    ACCNTL0F                                                   CGL142
     C                   ENDIF                                                                CGL142
     C                   ENDIF                                                                CGL142
     C                   ENDIF                                                                CGL142
                                                                                              CGL142
     C                   ENDIF                                                                CGL142
     C                   ENDIF                                                                CGL142
                                                                                              CGL142
     C                   EVAL      CommitCtr = CommitCtr + 1                                MD024120
     C                   IF        CommitCtr = TSCommitLimit                                MD024120
     C     1             CHAIN     GLACBAPD                                                MD024120A
     C                   IF        NOT %FOUND( GLACBAPD )                                  MD024120A
     C     *LOCK         IN        LDA                                                     MD024120A
     C                   EVAL      DBASE = 16                                              MD024120A
     C                   EVAL      DBFILE = 'GLACBAPD'                                     MD024120A
     C                   EVAL      DBKEY = '*EMPTY'                                        MD024120A
     C                   EVAL      DBPGM = 'GL3320'                                        MD024120A
     C                   EVAL      *INU7 = *ON                                             MD024120A
     C                   EVAL      *INU8 = *ON                                             MD024120A
     C                   EXSR      *PSSR                                                   MD024120A
     C                   ENDIF                                                             MD024120A
     C                   EVAL      GLFERN = RRN                                             MD024120
     C                   UPDATE    GLACBAF                                                  MD024120
     C                   COMMIT                                                             MD024120
     C                   EVAL      CommitCtr = 0                                            MD024120
     C                   ENDIF                                                              MD024120
                                                                                            MD024120
     C                   SETOFF                                       0405                    CGL120
     C*****RRN**         IFLT      GLTERN                                        AR1097401 MD024120A
     C                   IF        RRN < LastRRN                                           MD024120A
     C                   READ      ACCNTAB                                                    CGL120
     C                   ELSE                                                              AR1097401
     C                   EVAL      PerformLRPrc = True                                     MD024120A
     C**********         LEAVE                                                   AR1097401 MD024120A
     C                   ENDIF                                                             AR1097401
      *
     C                   ENDDO                                                                CGL120
                                                                                           MD024120A
     C                   IF           PerformLRPrc                                         MD024120A
     C                             OR %EOF( ACCNTAB )                                      MD024120A
     C                             OR NoRec = 0                                             MD031642
     C                   EVAL      *INLR = *ON                                             MD024120A
     C                   ENDIF                                                             MD024120A
                                                                                           MD024120A
     C/EJECT
     C********************************************************************
     C****                                                            ****
     C****  S U B R O U T I N E S  &  C O N T R O L   B R E A K S     ****
     C****                                                            ****
     C********************************************************************
     C/SPACE 2
     C*
     C** End program if database error
     C*
     C***LR*****            READ      ABEXZY                                 99        CGL120 CGL142
     C***LRN99TTI           COMP      'T'                                9999          CGL120 CGL142
     C***LR*99**            MOVEL     'ABEXZY'      DBFILE                             CGL120 CGL142
     C***LR****IN99         IFEQ      *OFF                                             CGL120 CGL142
     C***LR*****            READ      ACCNTAC                                99               CGL142
     C***LRN99TTI           COMP      'T'                                9999                 CGL142
     C***LR*99**            MOVEL     'ACCNT'       DBFILE                             CGL120 CGL142
     C***LR                 ENDIF                                                      CGL120 CGL142
      *                                                                                       CGL120
     C***LR****IN99         IFEQ      *ON                                                     CGL142
     C***LR*****            SETON                                        U7LR                 CGL142
     C***LR****LOCK         IN        LDA                                                     CGL142
     C***LR*****            MOVEL     'ACCNT'       DBFILE                         ***********CGL120
     C***LR*****            MOVE      BLK200        DBKEY                          * DBERROR 0CGL142
     C***LR*****            MOVEL     'TRAILER'     DBKEY                          ***********CGL142
     C***LR*****            Z-ADD     9             DBASE                                     CGL142
     C***LR*****            MOVEL     'GL3320'      DBPGM                                     CGL142
     C***LR*****            OUT       LDA                                                     CGL142
     C***LR*****            ENDIF                                                             CGL142
     C***LR*U7***             GOTO FINAL                                  085378
     C*
     C** Calling of RPG/GL3320D with parameters to blanks & termination
     C** parameter to 'T', to close open files
     C*
     C***LR******   *IN99     IFEQ *OFF                                   085378
     CLR                 CALL      'GL3320D'
     CLR                 PARM      'T'           @TERM
     CLR                 PARM      *BLANKS       @BRCA
     C***LR*****           PARM *ZEROS    @CNUM                                               CSD027
     CLR                 PARM      *BLANKS       @CNUM                                        CSD027
     CLR                 PARM      *BLANKS       @CCY
     CLR                 PARM      *ZEROS        @ACOD
     CLR                 PARM      *ZEROS        @ACSQ
     CLR                 PARM      *ZEROS        @ACNO                                        137916
     C*
     CLR   @TERM         IFEQ      'E'
     CLR                 SETON                                        U7LR
     CLR   *LOCK         IN        LDA
     CLR                 MOVEL     *BLANKS       DBFILE                         ***************
     CLR                 MOVE      BLK200        DBKEY                          * DBERROR 010 *
     CLR                 MOVEL     'TERM E'      DBKEY                          ***************
     CLR                 Z-ADD     10            DBASE
     CLR                 MOVEL     'GL3320D'     DBPGM
     CLR                 OUT       LDA
     CLR                 ENDIF
     C*
     C***LR******             ENDIF                                       085378
     C*
     CLR U7              GOTO      FINAL
     C*
     C** Total Time Calculations - File Controls
     C*
     C***LR*****            ADD       2             RECEX                                     CGL120
     C*
     C** Account Master
     C*
     C*
     C** Increment record counts for header and trailer
     C*
     C***LR*****            READ      GLACC2AC                               99      CGL142 MD020566
     CLR                 ADD       2             RECRD
     CLR                 ADD       2             RECRD7                                       254563
     CLR                 ADD       2             RECWR
     C***LR*****            IF        NORE >= NODROP                                   CGL120 CGL142
     C***LR***NORE          SUB       NODROP        RECAFT            5 0                     CGL142
     C***LR*****            ELSE                                                       CGL120 CGL142
     C***LR*****            EVAL      RECAFT = 100000 + NORE - NODROP                  CGL120 CGL142
     C***LR*****            ENDIF                                                      CGL120 CGL142
     C***LR*****            IF        NRET >= REDROP                                   CGL120 CGL142
     C***LR***NRET          SUB       REDROP        RETAFT            5 0                     CGL142
     C***LR*****            ELSE                                                       CGL120 CGL142
     C***LR*****            EVAL      RETAFT = 100000 + NRET - REDROP                  CGL120 CGL142
     C***LR*****            ENDIF                                                      CGL120 CGL142
     C***LR***NORE          ADD       NINU          ACCREC            5 0                     CGL142
     C***LR***ACCREC        ADD       NINP          ACCREC                                    CGL142
     C***LR***RECRD         COMP      ACCREC                             5959                 CGL142
     C***LR****IN99         IFEQ      *OFF                                           CGL142 MD020566
     C***LR*****            ADD       NODROP        AC_NODROP                        CGL142 MD020566
     C***LR*****            ADD       REDROP        AC_REDROP                        CGL142 MD020566
     C***LR*****            UPDATE    GLACCTCF                                       CGL142 MD020566
     C***LR*****            ELSE                                                     CGL142 MD020566
     CLR                 Z-ADD     NODROP        AC_NODROP                                    CGL142
     CLR                 Z-ADD     REDROP        AC_REDROP                                    CGL142
     CLR                 WRITE     GLACCTCF                                                   CGL142
     C***LR*****            ENDIF                                                    CGL142 MD020566
     C*
     C***LR*59**            SETON                                        U8                   CGL120
     C*
     C***LR***RECRD         IFEQ      ACCREC                                           254563 CGL120
     C***LR*****            SUB       NODROP        RECRD7                             254563 CGL120
     C***LR*****            SUB       NINU          RECRD7                             254563 CGL120
     C***LR*****            SUB       NINP          RECRD7                             254563 CGL120
     C***LR*****            Z-ADD     RECRD7        RECAFT                             254563 CGL120
     C***LR*****            ENDIF                                                      254563 CGL120
      *                                                                                       254563
     CLR                 Z-ADD     1             X
     CLR                 Z-ADD     3             Y
     CLR                 EXSR      COMP
     C*
     C***LR*55**            SETON                                        61U8                 CGL120
     CLR 55              SETON                                        61                      CGL120
     C*
     CLR                 Z-ADD     2             X                 2 0
     CLR                 Z-ADD     4             Y                 2 0
     CLR                 EXSR      COMP
     C*
     C***LR*55**            SETON                                        61U8                 CGL120
     CLR 55              SETON                                        61                      CGL120
     CLR   RECRM         COMP      0                                      30
     CLR                 Z-ADD     RECEX         RECEXP            5 0                        CGL120
     CLR                 EVAL      ZY_NORE = 0                                              MD024120
     CLR                 EVAL      ZY_DHDC = 0                                              MD024120
     CLR                 EVAL      ZY_DHWN = 0                                              MD024120
     CLR                 EVAL      ZY_CHWN = 0                                              MD024120
     CLR                 EVAL      ZY_CHDC = 0                                              MD024120
     C***LR*****            READ      GLABEXZY                               99      CGL142 MD024120
     C***LR*****            ADD       ZYREC         RECEX                              CGL120 CGL142
     CLR                 ADD       ZY_NORE       RECEX                                        CGL142
     C***LR***DEC(5)        ADD       ZYDEC5        WRKN40            4 0              CGL120 CGL142
     CLR   DEC(5)        ADD       ZY_DHDC       WRKN40            4 0                        CGL142
     CLR   WRKN40        IFLT      1000                                                       CGL120
     C***LR*****            ADD       ZYINT5        INT(5)                             CGL120 CGL142
     CLR                 ADD       ZY_DHWN       INT(5)                                       CGL142
     C***LR                 ADD       ZYDEC5        DEC(5)                             CGL120 CGL142
     CLR                 ADD       ZY_DHDC       DEC(5)                                       CGL142
     CLR                 ELSE                                                                 CGL120
     CLR   WRKN40        SUB       1000          WRKN40                                       CGL120
     C***LR*****            ADD       ZYINT5        INT(5)                             CGL120 CGL142
     CLR                 ADD       ZY_DHWN       INT(5)                                       CGL142
     CLR                 ADD       1             INT(5)                                       CGL120
     CLR                 Z-ADD     WRKN40        DEC(5)                                       CGL120
     CLR                 ENDIF                                                                CGL120
     C***LR***DEC(6)        ADD       ZYDEC6        WRKN40            4 0              CGL120 CGL142
     CLR   DEC(6)        ADD       ZY_CHDC       WRKN40            4 0                        CGL142
     CLR   WRKN40        IFLT      1000                                                       CGL120
     C***LR*****            ADD       ZYINT6        INT(6)                             CGL120 CGL142
     CLR                 ADD       ZY_CHWN       INT(6)                                       CGL142
     C***LR*****            ADD       ZYDEC6        DEC(6)                             CGL120 CGL142
     CLR                 ADD       ZY_CHDC       DEC(6)                                       CGL142
     CLR                 ELSE                                                                 CGL120
     CLR   WRKN40        SUB       1000          WRKN40                                       CGL120
     C***LR*****            ADD       ZYINT6        INT(6)                             CGL120 CGL142
     CLR                 ADD       ZY_CHWN       INT(6)                                       CGL142
     CLR                 ADD       1             INT(6)                                       CGL120
     CLR                 Z-ADD     WRKN40        DEC(6)                                       CGL120
     CLR                 ENDIF                                                                CGL120
     C*
     CLR                 Z-ADD     RECEX         ZY_NORE                                      CGL142
     CLR                 Z-ADD     INT(5)        ZY_DHWN                                      CGL142
     CLR                 Z-ADD     DEC(5)        ZY_DHDC                                      CGL142
     CLR                 Z-ADD     INT(6)        ZY_CHWN                                      CGL142
     CLR                 Z-ADD     DEC(6)        ZY_CHDC                                      CGL142
     CLR                 WRITE     GLABEXZF                                                   CGL142
                                                                                              CGL142
      ** Update STMTZX trailer                                                                CGL142
                                                                                              CGL142
     CLR   TNSAW         IFGT      0                                                          CGL142
     C***LR*****            READ      GLSTMTZX                               99   AR1097218 MD024120
     C***LR*****            ADD       TNSAW         NORE1                            CGL142 MD024120
     CLR                 EVAL      NORE1 = TNSAW                                            MD024120
     C***LR*****            IF        *IN99 = '0'                                 AR1097218 MD024120
     CLR                 WRITE     GLSTMTXF                                                   CGL142
     C***LR*****            ENDIF                                                    CGL142 MD024120
     CLR                 ENDIF                                                             AR1097218
                                                                                              CGL142
     CLR   OP_PRTF       IFEQ      'Y'                                                        CGL142
     CLR                 CLOSE     GL3320A1                                                   CGL142
     CLR                 ENDIF                                                                CGL142
     CLR   FINAL         TAG                                                    **FINAL TAG**
     C*
     C*****************************************************************
     C/SPACE 2
     C********************************************************************
     C*
     C     HASH          BEGSR                                                  *** HASH ***
     C*
     C                   Z-ADD     INT(X)        ZZTOTI
     C                   Z-ADD     DEC(X)        ZZTOTD
     C*
     C                   EXSR      GLZADD
     C*
     C                   Z-ADD     ZZTOTI        INT(X)
     C                   Z-ADD     ZZTOTD        DEC(X)
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/SPACE 2
     C********************************************************************
     C*
     C     COMP          BEGSR                                                  *** COMP ***
     C*
     C                   Z-ADD     INT(X)        ZZTOTI
     C                   Z-ADD     DEC(X)        ZZTOTD
     C*
     C                   Z-ADD     INT(Y)        ZZINT
     C                   Z-ADD     DEC(Y)        ZZDEC
     C*
     C                   EXSR      GLZCMP
     C*
     C     ZZDIFI        COMP      0                                  5555
     C  N55ZZDIFD        COMP      0                                  5555
     C**
     C                   ENDSR
     C*
      *****************************************************************                       CGL142
      /EJECT                                                                                  CGL142
      *****************************************************************                       CGL142
      *                                                               *                       CGL142
      *  EXTEN - Reset if found in REACX1PD                           *                       CGL142
      *                                                               *                       CGL142
      *****************************************************************                       CGL142
                                                                                              CGL142
     C     EXTEN         BEGSR                                                                CGL142
                                                                                              CGL142
     C     KLIST         CHAIN     REACX1PD                           99                      CGL142
     C     *IN99         IFEQ      '1'                                                        CGL142
     C                   Z-ADD     0             WE1UAC                                       CGL142
     C                   Z-ADD     0             WELUSU                                       CGL142
     C                   Z-ADD     0             WELURA                                       CGL142
     C                   Z-ADD     0             WECOAM                                       CGL142
     C                   MOVE      *BLANKS       WECOAC                                       CGL142
     C                   MOVE      *BLANKS       WECOBR                                       CGL142
     C                   MOVE      '0'           *IN99                                        CGL142
     C                   ENDIF                                                                CGL142
                                                                                              CGL142
     C                   MOVE      ATYP          WEATYP                                       CGL142
     C                   MOVE      BRCA          WEBRCA                                       CGL142
     C                   MOVE      CCY           WECCYC                                       CGL142
     C                   Z-ADD     ACOD          WEACOD                                       CGL142
     C                   MOVE      CNUM          WECNUM                                       CGL142
     C                   Z-ADD     ACSQ          WEACSQ                                       CGL142
                                                                                              CGL142
     C                   WRITE     ACCNTBF6                                                   CGL142
                                                                                              CGL142
     C                   ENDSR                                                                CGL142
      *****************************************************************                       CGL142
      /EJECT                                                                                  CGL142
      *****************************************************************                       CGL142
      *                                                               *                       CGL142
      *  ACCCLO                                                       *                       CGL142
      *                                                               *                       CGL142
      *****************************************************************                       CGL142
                                                                                              CGL142
     C     ACCCLO        BEGSR                                                                CGL142
                                                                                              CGL142
     C                   MOVE      'N'           ACCLO@            1                          CGL142
     C                   MOVE      *BLANKS       SVGLBT            1                          CGL142
     C                   MOVE      GLBT          SVGLBT                                       CGL142
                                                                                              CGL142
 s1  C     CSD023        IFEQ      'Y'                                                        CGL142
                                                                                              CGL142
     C                   MOVE      CNUM          @CUST1            6                          CGL142
 s2  C     @CUST1        IFNE      @CUST                                                      CGL142
     C                   MOVE      *BLANKS       @CUST                                        CGL142
     C                   MOVEL     CNUM          @CUST                                        CGL142
     C                   CALL      'AOCUSTR2'                                                 CGL142
     C                   PARM      '*MSG   '     @RTCD             7                          CGL142
     C                   PARM      '*KEY   '     @OPTN             7                          CGL142
     C                   PARM                    @CUST            10                          CGL142
     C                   PARM                    @KYST             7                          CGL142
     C     SDCUST        PARM      SDCUST        DSSDY                                        CGL142
                                                                                              CGL142
 s3  C     @RTCD         IFNE      *BLANKS                                                    CGL142
     C     @RTCD         ANDNE     '*NRF   '                                                  CGL142
     C                   MOVEL     'SDCUSTPD'    DBFILE                                       CGL142
     C                   Z-ADD     900           DBASE                                        CGL142
     C                   MOVEL     @CUST         DBKEY                                        CGL142
     C                   SETON                                        U7U8LR                  CGL142
     C                   EXSR      *PSSR                                                      CGL142
 e3  C                   ENDIF                                                                CGL142
                                                                                              CGL142
 e2  C                   ENDIF                                                                CGL142
                                                                                              CGL142
 s2  C     BBTYLC        IFEQ      'A'                                                        CGL142
     C     BBLCD         ANDEQ     BJRDNB                                                     CGL142
     C     BBCLST        ANDEQ     'Y'                                                        CGL142
     C     BBCLDT        ANDEQ     BJRDNB                                                     CGL142
     C     ACST          ANDNE     'C'                                                        CGL142
     C                   MOVE      'Y'           ACCLO@                                       CGL142
 e2  C                   ENDIF                                                                CGL142
                                                                                              CGL142
 e1  C                   ENDIF                                                                CGL142
                                                                                              CGL142
     C     RECIAM        IFEQ      'D'                                                        CGL142
     C     ACST          ANDEQ     'C'                                                        CGL142
     C     RECIAM        OREQ      'D'                                                        CGL142
     C     ACCLO@        ANDEQ     'Y'                                                        CGL142
     C     CSD023        ANDEQ     'Y'                                                        CGL142
     C                   BITON     '1'           GLBT                                         CGL142
                                                                                              CGL142
     C                   MOVE      'Y'           ACCLO@                                       CGL142
                                                                                              CGL142
     C                   ENDIF                                                                CGL142
                                                                                              CGL142
     C                   ENDSR                                                                CGL142
      *****************************************************************                       CGL142
      /EJECT                                                                                  CGL142
      *****************************************************************                       CGL142
      *                                                               *                       CGL142
      *  BALSTA - Determining accounts for balance statement          *                       CGL142
      *                                                               *                       CGL142
      *****************************************************************                       CGL142
                                                                                              CGL142
     C     BALSTA        BEGSR                                                                CGL142
                                                                                              CGL142
     C                   SETOFF                                       86                      CGL142
                                                                                              CGL142
     C     NSTD          COMP      0                                      43                  CGL142
     C     NSTD          COMP      DNWD                                 65                    CGL142
     C   43                                                                                   CGL142
     CAN 65              SETOFF                                       65                      CGL142
     C  N65APDA          COMP      DNWD                                 66                    CGL142
     C  N65                                                                                   CGL142
     CAN 66STFQ          COMP      'A'                                    65                  CGL142
     C  N65              TESTB     '0'           GLBT                     65                  CGL142
     C  N65              TESTB     '1'           GLBT                     65                  CGL142
                                                                                              CGL142
     C     CGL048        IFEQ      'N'                                                        CGL142
     C                   SETOFF                                       67                      CGL142
     C     STFQ          COMP      'Z'                                    66                  CGL142
     C     LSTD          ADD       183           WKLD              5 0                        CGL142
     C  N65                                                                                   CGL142
     CAN 66                                                                                   CGL142
     CAN 43WKLD          COMP      RUND                                 6767                  CGL142
     C   67              BITON     '1'           GLBT                                         CGL142
     C   67                                                                                   CGL142
     COR 65              SETON                                        86                      CGL142
     C                   SETOFF                                       676665                  CGL142
     C                   ELSE                                                                 CGL142
     C   65              SETON                                        86                      CGL142
     C                   SETOFF                                       6665                    CGL142
     C                   ENDIF                                                                CGL142
                                                                                              CGL142
     C     *IN86         IFEQ      *ON                                                        CGL142
                                                                                              CGL142
     C                   TESTB     '0'           GLBT                     49                  CGL142
     C     *IN49         IFEQ      '1'                                                        CGL142
     C                   MOVE      'Y'           MSFL                                         CGL142
     C                   ELSE                                                                 CGL142
     C                   MOVE      'N'           MSFL                                         CGL142
     C                   ENDIF                                                                CGL142
                                                                                              CGL142
     C     MODE          IFEQ      '1'                                                        CGL142
     C                   MOVE      'D'           RECI                                         CGL142
     C                   WRITE     STMTAHF                                                    CGL142
     C     TNSAW         ADD       1             TNSAW                                        CGL142
     C                   ENDIF                                                                CGL142
     C                   ENDIF                                                                CGL142
                                                                                              CGL142
     C                   ENDSR                                                                CGL142
     C********************************************************************
     C/SPACE 2
     C********************************************************************
     C* SUBROUTINE TO ADD AN AMOUNT (ZZAMT) TO THE TOTAL (ZZTOTI,ZZTOTD)
     C*   IND '99' IS SET BY AN OVERFLOW ERROR
     C*
     C     GLZADD        BEGSR                                                  *** GLZADD ****
     C*
     C                   Z-ADD     ZZAMT         ZZAMT            15 3    91    -DEFINE ZZAMT
     C   91              GOTO      ZZAEND                                       AMT = 0.BYPASS
     C*
     C* SPLIT ZZAMT INTO INTEGER AND DECIMAL FIELDS
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0          INTEGER FIELD
     C                   Z-ADD     ZZAMT         ZZWK1             3 3
     C                   MOVE      ZZWK1         ZZAMTD            3 0          DECIMAL FIELD
     C* BOTH ZZAMTI AND ZZAMTD CONTAIN A 'SIGN' ZONE NOW
     C*
     C                   EXSR      GLZSUM
     C     ZZAEND        ENDSR                                                  ** ZZAEND TAG *
     C*
     C********************************************************************
     C/SPACE 2
     C********************************************************************
     C* SUBROUTINE TO COMPARE AN AMOUNT TO THE TOTAL.
     C*      PARAMETERS. I/P - ZZINT - THE INTEGER PORTION OF THE NUMBER.
     C*                  I/P - ZZDEC - THE DECIMAL PORTION OF THE NUMBER.
     C*                  O/P - ZZDIFI - IS THE INTEGER DIFFERENCE.
     C*                  O/P - ZZDIFD - IS THE DECIMAL DIFFERENCE.
     C*                  O/P - ZZNEGD - FOR IMMEDIATE PRINTING ONLY.
     C*                  O/P - 96 IS SET IF DIFFERENCE IS NEGATIVE.
     C*
     C*    IF AN ERROR HAS OCCURED ZZDIFI AND ZZDIFD WILL BE ZERO.
     C*        '99' - OVERFLOW ERROR
     C*        '97' - THE 'SIGN' ZONES OF ZZINT AND ZZDEC ARE DIFFERENT
     C*
     C     GLZCMP        BEGSR                                                  *** GLZCMP ****
     C                   SETOFF                                       9799
     C                   Z-ADD     ZZDEC         ZZDEC             3 0919293    DEFINE ZZDEC
     C                   Z-ADD     ZZINT         ZZINT            15 0949596    DEFINE ZZINT
     C* IF SIGN ZONES DIFFER, SET 97, & RETURN ZERO.
     C   91
     CAN 95
     COR 92
     CAN 94              SETON                                        97        ERROR -MIXED
     C*                                                           STATUS
     C   97              GOTO      ZZQUIT                                       BRANCH TO ADMIT
     C*
     C*  SPECIAL CASES DEALT WITH FIRST
     C*      EITHER AMOUNTS EQ '0' OR BOTH AMOUNTS 'EQ'
     C                   SETOFF                                       9192
     C                   SETOFF                                       9495
     C   93
     CAN 96              SETON                                        91        * IF I/P FIELD
     C   91              Z-ADD     ZZTOTI        ZZDIFI           15 0          *    ZERO
     C   91              Z-ADD     ZZTOTD        ZZDIFD            3 0          *
     C   91              GOTO      ZZSIGN
     C*
     C     ZZTOTI        COMP      ZZINT                                  91    * IF FIELDS EQ
     C   91ZZTOTD        COMP      ZZDEC                                  91    *
     C   91              Z-ADD     0             ZZDIFI                         *
     C   91              Z-ADD     0             ZZDIFD                         *
     C   91              GOTO      ZZCEND
     C*
     C     ZZTOTI        COMP      0                                      91    * IF TOTAL
     C   91ZZTOTD        COMP      0                                      91    *    ZERO
     C   91              Z-SUB     ZZINT         ZZDIFI                         *
     C   91              Z-SUB     ZZDEC         ZZDIFD                         *
     C**
     C     ZZSIGN        TAG                                                    *** ZZSIGN ****
     C*
     C**   IF ZZDIFD IS ZERO, AND ZZDIFI IS NEG. SET UP ZZNEGD.
     C                   SETOFF                                       96
     C   91ZZDIFD        COMP      0                                      94
     C   94ZZDIFI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD            5
     C   91              GOTO      ZZCEND
     C*      END OF SPECIAL CASES
     C*
     C* IF ZZTOTALS EQ 'B' AND ZZINT,ZZDEC EQ 'A'   THEN -
     C*  TO COMPARE 'A' WITH 'B'
     C*     1. STORE ORIGINAL VALUE OF 'B'.
     C*     2. NEGATE 'A'.
     C*     3. ADD 'A' TO 'B'.
     C*     4. 'B' IS NOW THE DIFFERENCE. STORE 'B' IN FIELD 'C'.
     C*     5. RESTORE 'B'.
     C*            N.B. 'A' EQ ZZINT AND ZZDEC
     C*                 'B' EQ ZZTOTI AND ZZTOTD
     C*                 'C' EQ ZZDIFI AND ZZDIFD
     C*
     C*    STEP #1
     C                   Z-ADD     ZZTOTI        ZZSTRI           15 0
     C                   Z-ADD     ZZTOTD        ZZSTRD            3 0
     C*    STEP #2
     C                   Z-SUB     ZZINT         ZZAMTI           15 0
     C                   Z-SUB     ZZDEC         ZZAMTD            3 0
     C*    STEP #3
     C                   EXSR      GLZSUM
     C   99              GOTO      ZZQUIT
     C*    STEP #4
     C                   Z-ADD     ZZTOTI        ZZDIFI
     C                   MOVE      ZZTOTD        ZZDIFD
     C*    STEP #5
     C                   Z-ADD     ZZSTRI        ZZTOTI           15 0
     C                   Z-ADD     ZZSTRD        ZZTOTD            3 0
     C                   GOTO      ZZCEND                                       BYPASS ADMIT
     C     ZZQUIT        TAG                                                    ** ZZQUIT TAG**
     C                   Z-ADD     0             ZZDIFI
     C                   Z-ADD     0             ZZDIFD
     C     ZZCEND        ENDSR                                                  ** ZZCEND TAG**
     C*
     C********************************************************************
     C/SPACE 2
     C********************************************************************
     C* SUBROUTINE TO CARRY OUT THE ADDITION FOR SUBROUTINES -
     C*                        GLZADD, GLZSUB, GLZCMP.
     C*          PARAMETERS PASSED -
     C*                     I/P ZZAMTI ZZAMTD
     C*                     O/P ZZTOTI ZZTOTD ZZNEGD IND 96 IND 99.
     C*
     C     GLZSUM        BEGSR                                                  *** GLZSUM ****
     C*
     C                   Z-ADD     ZZTOTI        ZZTOTI           15 0          DEFINE ZZTOTI
     C                   Z-ADD     ZZTOTD        ZZTOTD            3 0          DEFINE ZZTOTD
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599
     C*
     C*    DETERMINE SIGN OF ZZAMTI & D,   92 IF NEG
     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND                                       ZERO BYPASS
     C*
     C*    DETERMINE SIGN OF ZZTOTI & D, 91 IF NEG.
     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193
     C*
     C*    IF ZZTOTAL IS ZERO, RETURN ZZAMOUNT.
     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND                                       ZERO BYPASS
     C*    IF SIGNS DIFFER BYPASS OVERFLOW CHECKS.
     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
     C*
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     C     ZZWK2         COMP      999                                93        '93' = CARRY
     C  N93ZZWK2         COMP      -999                                 93             INTO INTEGER.
     C*
     C   93
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0          ADD 'CARRY' +VE
     C   93
     CAN 92ZZAMTI        SUB       1             ZZWK3                          SUB 'CARRY' -VE
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3
     C*
     C* IF THE MODULUS OF ZZWK3 IS LT MOD. ZZTOTI THEN O/F HAS OCCURED
     C  N92ZZWK3         COMP      ZZTOTI                               99      -92 MEANS NOS.
     C   92ZZWK3         COMP      ZZTOTI                             99                    NEGATIVE
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI
     C*
     C* IF O/F ZEROIZE ZZAMT , IND '99' SET AND ZZTOT FIELDS LEFT INTACT.
     C   99              Z-ADD     0             ZZAMT            15 3
     C                   GOTO      ZZSEND
     C*
     C* THE 'SIGNS' ARE DIFFERENT
     C     ZZOFPS        TAG                                                    ** ZZOFPS TAG**
     C* IF ZZAMT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZTOT
     C*
     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0
     C*
     C* IF ZZTOT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZAMT.
     C*
     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD
     C* BOTH ZZAMT AND ZZTOT ARE NOW POSITIVE.
     C*
     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95
     C*
     C* IF ZZTOT EQ. ZZAMT RETURN ZERO.
     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND
     C*
     C* IF ZZTOT GT. ZZAMT.
     C   93ZZAMTD        COMP      ZZTOTD                             94
     C   93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     C   93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C   93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     C   93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
     C*
     C*
     C* IF ZZAMT GT. ZZTOT.
     C  N93ZZTOTD        COMP      ZZAMTD                             94
     C  N93
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     C  N93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     C  N93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     C  N93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C  N93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     C  N93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
     C*
     C* REVERSE SIGN OF ZZTOT IF LARGER I/P FIELDS WERE NEGATIVE
     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD
     C**
     C**   RESTORE SIGN OF ZZAMTI & ZZAMTD IF IT WAS REVERSED.
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
     C     ZZSEND        TAG                                                    ** ZZSEND TAG *
     C**
     C**   IF ZZTOTD IS ZERO, AND ZZTOTI IS NEG. SET UP ZZNEGD.
     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD            5
     C                   ENDSR                                                           ** ENDSR **
     C********************************************************************
     C/SPACE 2
     C********************************************************************
     C**
     C**   SR. TO CONVERT A DAY NUMBER TO DATE FORMATS.
     C**
     C     ZDATE2        BEGSR                                                  ZDATE2 BEGSR
     C**
     C**   CLEAR DATE FIELDS.
     C                   Z-ADD     0             ZDATE             6 0
     C                   MOVEL     '       '     ZADATE            7
     C**
     C**   CALCULATION TO DEFINE INPUT DAY NUMBER.
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C**
     C**   DETERMINE YEAR NUMBER.
     C**
     C**   ADJUST DAY NUMBER IN CASE LAST DAY OF YEAR.
     C     ZDAYNO        SUB       1             ZDAYN1            5 0  99
     C   99              GOTO      ZDEND2
     C**
     C**   CALCULATE NUMBER OF 4 YEAR SPANS SINCE 31/12/1971.
     C     ZDAYN1        DIV       1461          ZLYR              2 0
     C                   MVR                     ZDAYN1                         SAVE REMAINING
     C**                                                   DAYS.
     C**   CALCULATE NUMBER OF REMAINING YEARS.
     C                   Z-ADD     1             ZWRK2             2 0
     C     ZDTAG1        TAG                                                    ZDTAG1 TAG
     C     ZDAYN1        COMP      ZYDY(ZWRK2)                          90
     C  N90ZWRK2         ADD       1             ZWRK2
     C  N90              GOTO      ZDTAG1
     C     ZWRK2         SUB       1             ZWRK2                    91    LEAP YR, 91 ON.
     C**
     C**   DECREMENT DAY NO. BY DAYS IN REMAINING YEARS.
     C  N91ZDAYN1        SUB       ZYDY(ZWRK2)   ZDAYN1
     C**
     C**   CALCULATE ACTUAL YEAR NUMBER.
     C     ZLYR          MULT      4             ZWRK3             3 0
     C     ZWRK3         ADD       72            ZWRK3                          BASE IS 1972.
     C                   Z-ADD     ZWRK3         ZYEAR             2 0
     C     ZYEAR         ADD       ZWRK2         ZYEAR                          YEAR.
     C**
     C**   DETERMINE MONTH NUMBER.
     C**
     C**   ADJUST DAY NO. IN CASE LAST DAY OF LEAP YEAR FEBRUARY.
     C                   SETOFF                                       9293
     C   91ZDAYN1        COMP      59                                   9293
     C   91
     CANN92ZDAYN1        SUB       1             ZDAYN1
     C**
     C**   CALCULATE MONTH NUMBER.
     C                   Z-ADD     2             ZWRK2
     C     ZDTAG2        TAG                                                    ZDTAG2 TAG
     C     ZDAYN1        COMP      ZMDY(ZWRK2)                          94
     C  N94ZWRK2         ADD       1             ZWRK2
     C  N94              GOTO      ZDTAG2
     C     ZWRK2         SUB       1             ZWRK2
     C**
     C                   Z-ADD     ZWRK2         ZMTH              2 0          MONTH.
     C**
     C**   DETERMINE DAY OF MONTH.
     C**
     C**   ADD BACK LAST DAY OF YEAR ADJUSTMENT.
     C     ZDAYN1        ADD       1             ZDAYN1
     C**
     C**   CALCULATE DAY OF MONTH.
     C     ZDAYN1        SUB       ZMDY(ZWRK2)   ZDAY              2 0          DAY.
     C**
     C**   ADD BACK LEAP YEAR 29TH FEBUARY ADJUSTMENT, IF REQUIRED.
     C   93ZDAY          ADD       1             ZDAY
     C**
     C**   FORMAT DATE, DDMMYY OR MMDDYY.
     C  N98              MOVEL     ZDAY          ZWRK4             4 0
     C   98              MOVE      ZDAY          ZWRK4
     C  N98              MOVE      ZMTH          ZWRK4
     C   98              MOVEL     ZMTH          ZWRK4
     C                   MOVEL     ZWRK4         ZDATE
     C                   MOVE      ZYEAR         ZDATE
     C**
     C**   FORMAT ALPHA DATE, DDMMMYY.
     C     ZDAY          COMP      10                                   95
     C                   MOVEL     ZDAY          ZWRK5             5
     C   95              MOVEL     ' '           ZWRK5
     C                   MOVE      ZMNM(ZMTH)    ZWRK5
     C                   MOVEL     ZWRK5         ZADATE
     C                   MOVE      ZYEAR         ZADATE
     C**
     C     ZDEND2        ENDSR                                                  ZDEND2 ENDSR
     C**
     C**
     C********************************************************************B08253
     C/SPACE 2
     C*****************************************************************
     C*
     C     *PSSR         BEGSR                                                  ***PSSR BEGSR**
     C*
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
     C                   SETON                                        U7LR
     C                   ENDSR
     C********************************************************************S01486
      /EJECT                                                              S01486
     C***/COPY*PMCPYSRC,ZFRELN                                                         S01486 CGL120
     C/COPY PMCPYSRC,ZFRELNLE                                                                 CGL120
     C*****************************************************************
     O*
     O** New Account Master
     O*
     O*
     O** Extract each open account onto ACORD
     O*
     O***ACCNTAA   D    LR U1NU7                                                              CGL142
     O**********             ACREC              256                                           CGL142
     O**********                                 23 'Y'                                       CGL142
     O**********             ACREC2             400                                           CGL142
     OACCNT     EDEL         DELACC
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL3320OOPG                                           S01408
     O*                                                                   S01408
     O***ACCNTAC   T    LR U1NU7                                                              CGL142
     O**********             ACREC              256                                           CGL142
     O**********             ACREC2             400                                           CGL142
     O**********             RECAFT              25P                                          CGL142
     O**********             RETAFT             403P                                          CGL142
     O*
     O** Retail Account Numbers
     O*
     OREIAC     E            RECIA
     O                                            1 '*'
     O*
     O** Account Extract File
     O*
     OCACCNTAB  E            CACCNT                                                           CGL142
     O                       BRCA                 3                                           CGL142
     O                       CNUM                 9                                           CGL142
     O                       CCY                 12                                           CGL142
     O                       ACOD                22                                           CGL142
     O                       ACSQ                24                                           CGL142
     O*
     O** For each open account-two records are extracted to accounts
     O** extract file
     O*
     O***ABEXHH*   H    1P                                                                    CGL120
     O**********                                  1 'H'                                       CGL120
     O***ABEXAG*   D    04                                                                    CGL120
     OABEXAG    E            ABEXDT                                                           CGL120
     O                                            1 'D'
     O                       BRCA                 4
     O                       CCY                  7
     O**********               ACOD      11                                                   CGL029
     O                       ACODQQ              11                                           CGL029
     O                                           12 '0'
     O                     41                    12 '1'
     O                       CNUM                18
     O                       ACSQ                20
     O                       ZERO15              28P
     O                       ZERO15              36P
     O***********         29   LDBL      28P                              185118
     O***********        N29   LDBL      36P                              185118
     O              N35 29   LDBL                28P                            185118
     O              N35N29   LDBL                36P                            185118
     O                       ACOD                50                                           CGL029
     O***ABEXAG    T    L1                                                                    CGL120
     O**********                                  1 'E'                                       CGL120
     O**********             BRCA                 4                                           CGL120
     O**********             CCY                  7                                           CGL120
     O**********               ACOD      11                                                   CGL029
     O**********             ACODQQ              11                                    CGL029 CGL120
     O**********                                 20 '000000000'                               CGL120
     O**********             ZERO15              28P                                          CGL120
     O**********             ZERO15              36P                                          CGL120
     O**********             CRBL           B    28P                                          CGL120
     O**********             DRBL           B    36P                                          CGL120
     O**********             ACOD                50                                    CGL029 CGL120
     O***ABEXZY    T    LR                                                                    CGL142
     O**********                                  1 'T'                                       CGL142
     O**********             RECEX                4P                                          CGL142
     O**********             INT(5)              12P                                          CGL142
     O**********             DEC(5)              14P                                          CGL142
     O**********             INT(6)              22P                                          CGL142
     O**********             DEC(6)              24P                                          CGL142
     O/SPACE 2
     O*L3320P1D**203***02                                                 091250
     O***GL3320A1  D    02                     2 03                                    091250 CGL120
     OGL3320A1  E    02      BALEXD         2 03                                              CGL120
     O         OR    OF
     O*****************                  25 'REFERENCE GL3320P1'          091250
     O                                           25 'REFERENCE GL3320A1'        081250
     O                       TITL                89
     O                                          104 'DATE'
     O                       RUNA               113
     O                                          122 'PAGE'
     O                       PAGE          Z    127
     O**********D    02                     1                                                 CGL120
     O          E    02      BALEXD         1                                                 CGL120
     O         OR    OF
     O                                           70 'ACCOUNT BALANCES EXTRACT'
     O                                           79 'CONTROLS'
     O**********D    02                     2                                                 CGL120
     O          E    02      BALEXD         2                                                 CGL120
     O         OR    OF
     O                                           70 '------------------------'
     O                                           79 '---------'
     O**********D    02 U1                  2                                                 CGL120
     O          E    02 U1   BALEXD         2                                                 CGL120
     O         OR    OF U1
     O                                           24 'ACCOUNTS MASTER FILE REO'
     O                                           46 'RGANIZATION - ACCOUNTS'
     O                                           54 'REMOVED'
     O**********D    02 U1                  1                                                 CGL120
     O          E    02 U1   BALEXD         1                                                 CGL120
     O         OR    OF U1
     O                                            8 'BRNCH'
     O**********                         30 'CUST.   CCY  A/C  SEQ'                           CGL029
     O**********                         49 'RETAIL A/C'                                      CGL029
     O**********                         63 'DATE'                                            CGL029
     O                                           20 'CUST.   CCY'                             CGL029
     O                                           37 'ACCOUNT    SEQ'                          CGL029
     O                                           55 'RETAIL A/C'                              CGL029
     O                                           69 'DATE'                                    CGL029
     O**********D    02 U1                  2                                                 CGL120
     O          E    02 U1   BALEXD         2                                                 CGL120
     O         OR    OF U1
     O**********                         26 'NUMBER       CODE'                               CGL029
     O**********                         45 'NUMBER'                                          CGL029
     O**********                         65 'CLOSED'                                          CGL029
     O                                           15 'NUMBER'                                  CGL029
     O                                           27 'CODE'                                    CGL029
     O                                           51 'NUMBER'                                  CGL029
     O                                           71 'CLOSED'                                  CGL029
     O**********D    U1 05 42               1                                                 CGL120
     O          EF   U1 05 42BALEXD         1                                                 CGL120
     O                       BRCA                 7
     O                       CNUM                15
     O                       CCY                 20
     O**********               ACOD      26                                                   CGL029
     O**********               ACSQ      30                                                   CGL029
     O**********             22ACNO      49                                                   CGL029
     O**********               ZADATE    66                                                   CGL029
     O                       ACOD                32                                           CGL029
     O                       ACSQ                36                                           CGL029
     O                     22ACNO                55                                           CGL029
     O                       ZADATE              72                                           CGL029
     O*****************************************************************
     O* CONTROL TOTALS
     O*****************************************************************
     O***GL3320AUT  203   LR U1                                                              BUG3330
     OGL3320AU  T    LR                     2 03                                             BUG3330
     O                                           25 'REFERENCE GL3320AU'
     O                       TITL                89
     O                                          104 'DATE'
     O                       RUNA               113
     O                                          122 'PAGE'
     O**********               PAGE  Z  127                                                  BUG3330
     O                       PAGE1         Z    127                                          BUG3330
     O********T* 1     LR U1                                                                 BUG3330
     O          T    LR                     1                                                BUG3330
     O                                           70 'ACCOUNT BALANCES EXTRACT'
     O                                           79 'CONTROLS'
     O********T* 2     LR U1                                                                 BUG3330
     O          T    LR                     2                                                BUG3330
     O                                           70 '------------------------'
     O                                           79 '---------'
     O          T    LR                     2 18
     O                                           18 'DATA BASE CONTROLS'
     O          T    LR                     2
     O                                           29 '-ACCOUNTS MASTER FILE'
     O          T    LR                     1
     O                                           36 'NUMBER OF RECORDS READ'
     O**********               RECRD 3   49                                                   254563
     O                       RECRD7              49                                           254563
     O**********                                 67 'VALUE OF LIVE'                           CGL120
     O**********                                 79 'ACCOUNTS DR'                             CGL120
     O**********             DEC(3)             103 '0   '                                    CGL120
     O**********             INT(3)        Z    100                                           CGL120
     O          T    LR                     1
     O                                           38 'NUMBER OF RECORDS REMOVE'
     O                                           39 'D'
     O                       RECRM         3     49
     O**********                                 79 'CR'                                      CGL120
     O**********             DEC(4)             103 '0   '                                    CGL120
     O**********             INT(4)        Z    100                                           CGL120
     O          T    LR                     2
     O                                           38 'NUMBER OF RECORDS REMAIN'
     O                                           41 'ING'
     O                       RECWR         3     49
     O          T    LR                     2
     O               U5                          78 '-RETAIL INTEREST & CHARG'
     O               U5                          85 'ES FILE'
     O          T    LR                     2
     O                                           38 'NUMBER OF RECORDS DELETE'
     O                                           39 'D'
     O               U5      RECDE         3     94
     O          T    LR                     2
     O                                           30 '-ACCOUNTS EXTRACT FILE'
     O               U5                          78 '-RETAIL ACCOUNTS CAPITAL'
     O               U5                          93 'ISED TODAY FILE'
     O          T    LR                     3
     O                                           38 'NUMBER OF RECORDS WRITTE'
     O                                           39 'N'
     O**********             RECEX         3     49                                           CGL120
     O                       RECEXP        3     49                                           CGL120
     O               U5                          84 'NUMBER OF RECORDS WRITTE'
     O               U5                          85 'N'
     O               U5      RECCP         3     94
     O*****************************************************************
     O***  F I L E    C O N T R O L S
     O*****************************************************************
     O**********T    LR                     2 40                                              CGL120
     O**********                                 13 'FILE CONTROLS'                           CGL120
     O**********T    LR                     2                                                 CGL120
     O**********                                 29 'ACCOUNT MASTER FILE'                     CGL120
     O          T    LR                     1                                   085140
     O**********                                 32 'NUMBER OF RECORDS'                085140 CGL120
     O**********                                 42 '- ACTUAL '                        085140 CGL120
     O**********             RECRD         3     49                                    085140 CGL120
     O**********                                 67 'VALUE OF LIVE'                    085140 CGL120
     O**********                                 79 'ACCOUNTS DR'                      085140 CGL120
     O**********             DEC(3)             103 '0   '                             085140 CGL120
     O**********             INT(3)        Z    100                                    085140 CGL120
     O**********T    LR                     2                                          085140 CGL120
     O**********                                 79 'CR'                               085140 CGL120
     O**********             DEC(4)             103 '0   '                             085140 CGL120
     O**********             INT(4)        Z    100                                    085140 CGL120
     O**********T    LR                     1
     O************                       32 '-NUMBER OF RECORDS'          085140
     O**********                                 32 'NUMBER OF RECORDS'         085140        CGL120
     O**********                                 42 '- ON FILE'                 085140        CGL120
     O**********             ACCREC        3     49                                           CGL120
     O**********                                 67 'VALUE OF LIVE'                           CGL120
     O**********                                 79 'ACCOUNTS DR'                             CGL120
     O**********             DEC(1)             103 '0   '                                    CGL120
     O**********             INT(1)        Z    100                                           CGL120
     O**********T    LR                     2                                                 CGL120
     O**********                                 79 'CR'                                      CGL120
     O**********             DEC(2)             103 '0   '                                    CGL120
     O**********             INT(2)        Z    100                                           CGL120
     O**********T    LR                     2                                                 CGL120
     O**********     59                          49 '***  OUT OF BALANCE  ***'                CGL120
     O**********     61                         103 '***  OUT OF BALANCE  ***'                CGL120
     O*****************************************************************
     O*    DATABASE ERROR OUTPUT
     O*****************************************************************
     O          T    LR U7               3
     O                                           51 '*** REFERENCE GL3320'
     O                                           71 'DATABASE ERROR AT'
     O                       DBASE               76
     O          T    LR U7               1
     O                                           37 'FILENAME'
     O                       DBFILE              47
     O                                           53 'KEY'
     O                       DBKEY               86
     O          T    LR 30 U1            3
     O                                           66 '*** NO ACCOUN'
     O                                           80 'TS REMOVED ***'
     O          T    LR                     2                                              CGL142
     O                                           22 'NUMBER OF STATEMENT'                  CGL142
     O                                           39 'ACCOUNTS WRITTEN'                     CGL142
     O                       TNSAW         1     49                                        CGL142
** CPY@   **      OBJECT COPYRIGHT
(c) Misys International Banking Systems Ltd. 2001
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
