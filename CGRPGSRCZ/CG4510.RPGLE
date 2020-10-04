     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                     MD056543
/*STD *  RPGBASEBND                                                   *                     MD056543
/*EXI *  TEXT('Midas CG General ledger statements')                   *
/*OVRF*: OVRDBF FILE(GLAPSGL0) TOFILE(GLAPSGAL0)                    : *                       216937
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG4510 - General Ledger statements                           *
      *                                                               *
      *  Function:  This program, given a full Account Identifier,    *
      *             extracts all the data required to construct the   *
      *             relevant statement.                               *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD055869           Date 03Jun20               *
      *                 AR325224           Date 19May20               *
      *                 MD054681           Date 01Jun20               *
      *                 CMG008             Date 20Feb20               *
      *                 MD043394           Date 13Sep17               *
      *                 MD046248           Date 27Oct17               *
      *                 239823             Date 25Nov14               *
      *                 230129             Date 25Nov14               *
      *                 218143             Date 17Oct14               *
      *                 AR881900           Date 19Dec11               *
      *                 AR864876           Date 18Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 AR787620           Date 10Jun11               *
      *                 AR750273B          Date 09Jun11               *
      *                 CRE075             Date 06Dec10               *
      *                 AR676213           Date 19Nov10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26680           Date 17Nov09               *
      *                 BUG25261           Date 31Jul09               *
      *                 BUG24792           Date 07Jul09               *
      *                 BUG24460           Date 19Jun09               *
      *                 BUG23984           Date 11May09               *
      *                 BUG23445A          Date 19Apr09               *
      *                 BUG23277A          Date 20Apr09               *
      *                 BUG23277           Date 07Apr09               *
      *                 BUG23572           Date 27Mar09               *
      *                 BUG23445           Date 19Mar09               *
      *                 BUG23216           Date 04Mar09               *
      *                 BUG23197           Date 03MAR09               *
      *                 CER038             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 17Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9646            Date 20Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 216937             Date 28Apr03               *
      *                 216006             Date 28Apr03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015             Date 25Jun01               *
      *                 173553             Date 22Nov01               *
      *                 153543             Date 22Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 153769             Date 17May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      *                 167545             Date 31Jan01               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 04Aug99               *
      *                 CGL007             Date 26Mar99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 152219             Date 04Jan99               *
      *                 CEU014             Date 04Jun98               *
      *                 CEU013             DATE 20APR98               *
      *                 S01408             DATE 20FEB97               *
      *                 103215             DATE 23MAY96               *
      *                 089776             DATE 17APR96               *
      *                 086918             DATE 02MAY95               *
      *                 086780             DATE 28APR95               *
      *                 086163             DATE 19MAR95               *
      *                 083782             DATE 16FEB95               *
      *                 082060             DATE 24JAN95               *
      *                 080131                  12DEC94               *
      *                 079997                  12DEC94               *
      *                 S01522                  22NOV94               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD and CGCDSHPD *
      *             to readable unicode equivalent.                   *
      *  MD055869 - FM2.1 SP21 ACCNTAB-7 Discrepancies on Year To     *
      *             Date Balance (ACCNTAB.TYDB)                       *
      *           - Reversed Fix 230129                               *
      *  AR325224 - Correct LSTP processing (same as GL0420). Applied *
      *             fix 231658.                                       *
      *           - Applied for MD-55789                              *
      *  MD054681 - Wrong values on account statement.                *
      *           - ##VAEC and ##VAED result fields lenght was        *
      *             patterned to SDCFSB (15P) istead of PSTA (13P).   *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD043394 - For STFQ='E', NSTD must be adjusted here the same *
      *             way as in GL0420. Frequency to be used is 'L'     *
      *             (Last Calenday Day of the Month) as well          *
      *  MD046248 - Finastra Rebranding                               *
      *  239823 - For statement turnover reports, use the last        *
      *           movement date from the PF/GLACBTPD instead of the   *
      *           last statement date from the PF/ACCNTAB for the     *
      *           brought forward date.                               *
      *         - Applied for MD029255.                               *
      *  230129 - Year to date balance is extracted instead of        *
      *           cleared balance.                                    *
      *         - Applied for MD029255.                               *
      *  218143 - B/F and C/F balance is not correct.                 *
      *         - Applied for MD029255.                               *
      *  AR881900 - Extended narratives on screen differ from         *
      *             Extended narratives on statement (Child:AR881901) *
      *  AR864876 - Extra page number not updated (Child:AR864877)    *
      *  CRE073 - Portuguese Feature - Interest Rate Rounding         *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,CGH00001                                 *
      *  AR750273B - Components failed due to closed customer         *
      *              (Child: AR750274)                                *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *           (Child: AR676229)                                   *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26680 - Additional Information not in statement           *
      *  BUG25261 - DL and LE transactions have Posting Narratives    *
      *  BUG24792 - Next Statement date on ACCNTAB is incorrect       *
      *           - Applied fix 239343. Replace FOK015 with CGL013    *
      *         - Correct update of ACCNTAB for Multicash accounts    *
      *           Changes for FOK015=Multicash stmt.frequency         *
      *  BUG24460 - Batch with MTcash Narrative22x35 input are missing*
      *  BUG23984 - Account Statement Correspondence has wrong Branch *
      *             Internal Customer details (Recompile)             *
      *  BUG23445A - Paper statements were not reformatted based on   *
      *              network *PAPER                                   *
      *  BUG23277A - Populate Posting Narrative in g_SPS3 Subroutine  *
      *  BUG23277 - Populate Posting Narrative in g_SPS3 Subroutine   *
      *  BUG23572 - CHIPSABA Not Accept '0' on screen, so that populat*
      *             with blanks when '0' values in database(Recompile)*
      *  BUG23445 - Format network according to network Paper if      *
      *             Account is linked                                 *
      *  BUG23216 - Populate Actual Customer Detail in Customer       *
      *             information instead of Branch internal Customer   *
      *             (Recompile)                                       *
      *  BUG23197 - Pass blank parameter to the MG001900(Output       *
      *             parameter)                                        *
      *  CER038 - Additional fields added to Correspondence           *
      *           (Includes CER031-Multi-narrative Enhancement)       *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CAP204 - Retail Account Transfer                             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9646- Changes in CGPACKE causes programs not to compile   *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216937 - For group account replicated postings, extract      *
      *           source account                                      *
      *  216006 - Extract group account text in the statement         *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *  173553 - Wrong sign in RDEs POST_EQCY and ORIG_AMNT          *
      *  153543 - Dont calculate POST_EQCY,if information is already  *
      *           stored as ORIG_CCY (avoid rounding differences)     *
      *  153769 - If account in EUR and 'Designated In Currency'      *
      *           BBDINC is defined, then balances must be extracted  *
      *           in that currency. Also currency details must be     *
      *           accessed by Subroutine SRDCDT.                      *
      *  CSD006 - Recompiled over changed SDCURRPD.                   *
      *  167545 - Extract trade reference number securities postings. *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *           International Bank Account Numbers (IBAN)           *
      *  CGL007 - Account Postings Enquiry (Recompile)                *
      *  152219 - EMU Balances in euro are calculated incorrectly.    *
      *  CEU014 - EMU User Defined Correspondence changes             *
      *  CEU013 - EMU Account Postings Narrative                      *
      *  S01408 - Core hook CG4510F001 added manually to replace      *
      *           'CG4510*001' created by hooks automation in error.  *
      *  103215 - Recompile IGNDECERR(*YES) to prevent pgm crashing   *
      *           with Decimal Data Error.                            *
      *  089776 - Add 'Account officer' details                       *
      *  086918 - Add customer town RDE to Group set CUST.            *
      *  086780 - Add precious metal indicator                        *
      *  086163 - Use new files for rates and postings                *
      *  083782 - Set frequency to "D" for Turnover                   *
      *  082060 - Redefine Binary fields as Decimal (9,0 Packed)      *
      *  080131 - Only calculate clearing amounts for Retail A/Cs     *
      *  079997 - Standardise full Account format                     *
      *  S01522 - User Defined Correspondence                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *                                                               *
      *  51   -    No Record found on LF/REIAC                        *
      *  52   -    No Record found on PF/GLAPSTPD                     *   CEU013
      *  55   -    End of File/No Record Found on LF/APOST            *
      *  56   -    Chain fail on LF/GLACBTL0                          *                       239823
      *  60   -    Successful Look-Up Indicator                       *
      *  70   -    Test Bit Indicator                                 *
      *  90   -    ROLBK indicator                                    *
      *                                                               *
      *  99   -    General work indicator                             *
      *                                                               *
      *****************************************************************
     F*COPY*WNCPYSRC*CG4510*001                                                               S01408
     F/COPY WNCPYSRC,CG4510F001                                                               S01408
      *                                                                                       CER038
      ** Correspondent file by customer number                                                CER038
      *                                                                                       CER038
     FCGCORRL4  IF   E           K DISK    USROPN                                             CER038
      *                                                                                       CER038
     FREIAC     IF   E           K DISK
     F                                     INFSR(SRFILE)
     F*APOST***IF  E           K        DISK                                                  086163
     F/COPY WNCPYSRC,CG4510F004
     FGLSTMTP   IF   E           K DISK                                                       086163
     F                                     INFSR(SRFILE)
     FGLSTMTR   IF   E           K DISK                                                       086163
     F                                     INFSR(SRFILE)                                      086163
     F/COPY WNCPYSRC,CG4510F002
     FSDACOFL0  IF   E           K DISK    INFSR(SRFILE)                                      089776
     FGLAPSTPD  IF   E           K DISK                                                       CEU013
     F                                     INFSR(SRFILE)                                      CEU013
     FGLAPSGL0  IF   E           K DISK                                                       216937
     FSDCMANL0  IF   E           K DISK                                                       216006
     FREGAHLJ2  IF   E           K DISK                                                       216006
      *                                                                                     BUG23445
      ** Midas GL Network accounts - MT94x - retrieval                                      BUG23445
      *                                                                                     BUG23445
     F*GLNW94L1IF  E           K        DISK                                      BUG23445 BUG23445A
     FGLNWACL1  IF   E           K DISK                                                    BUG23445A
      *                                                                                     BUG24792
      ** Midas GL Network accounts - MT94x - retrieval                                      BUG24792
      *                                                                                     BUG23445
     FGLNW94L8  IF   E           K DISK                                                     BUG23445
      *                                                                                     BUG23445
      ** GL MultiCash Narratives File                                                       BUG24460
      *                                                                                     BUG24460
     FGLMNARL1  IF   E           K DISK                                                     BUG24460
      *                                                                                     BUG24460
      ** Midas GL Journal entry - add. inf. - retrieval                                     BUG26680
      *                                                                                     BUG26680
     F***GLJENXL2IF  E           K        DISK                                     BUG26680 AR881900
     FGLJENXL1  IF   E           K DISK                                                     AR881900
      *                                                                                     BUG26680
     FGLJEHXL2  IF   E           K DISK                                                     BUG26680
     FGLACBTL0  IF   E           K DISK                                                       239823
     F/COPY WNCPYSRC,CG4510F003
     F/SPACE 5
     F/COPY WNCPYSRC,CG4510F005
     D*COPY*CGCPYSRC,CGPACKE                                                                MD056543
     D/COPY CGCPYSRC,CGPACKEILE                                                             MD056543
     D/COPY WNCPYSRC,CG4510E006
     D*COPY*CGCPYSRC,SRERRE                                                                 MD056543
     D/COPY CGCPYSRC,SRERRDLE                                                               MD056543
     D/COPY WNCPYSRC,CG4510E003
     D**  Number Arrays
     D/COPY WNCPYSRC,CG4510E005
     D*##NUMA***       S              1    DIM(29)                                          MD056543
     D*
     D**  ##GRP = Group/RDE Number             ##RDEA = RDE + Attributes
     D*
     D********************##GRP   1  52 10   ##RDEA 22                                        086780
     D********************##GRP   1  53 10   ##RDEA 22                                  086780086918
     D******************* ##GRP   1  54 10   ##RDEA 22                                  086918089776
     D/COPY WNCPYSRC,CG4510E001
     D***********         ##GRP   1  59 10   ##RDEA 22                                  089776CEU013
     D***********         ##GRP   1  66 10   ##RDEA 22                                  CEU013CEU014
     D***********         ##GRP   1  69 10   ##RDEA 22                                 CEU014 CFT004
     D***********         ##GRP   1  70 10   ##RDEA 22                                        CFT004
     D**********          ##GRP   1  75 10   ##RDEA 22                                  CFT004CER038
     D**********          ##GRP   1  95 10   ##RDEA 22                               CER038 BUG24460
     D**********          ##GRP   1  97 10   ##RDEA 22                               BUG24460 CRE073
     D ##GRP           S             10    DIM(106) CTDATA PERRCD(1)                          CRE073
     D ##RDEA          S             22    DIM(106) ALT(##GRP)                                CRE073
     D/COPY WNCPYSRC,CG4510E002
     D*
     D**  Array of Currencies accessed by program
     D ##CY            S              3    DIM(100)
     D*
     D**  Arrays of Generated Entry Type (GETP) and the associated
     D**  module. (As used on APOST).
     D**********          ##GE    1  20  1   ##MD    2                                        CAP204
     D ##GE            S              1    DIM(21) CTDATA PERRCD(1)                           CAP204
     D ##MD            S              2    DIM(21) ALT(##GE)                                  CAP204
     D*
     D**  Copyright array.
      *                                                                                       CER038
     D FLDNAM          S             10    DIM(40)                                            CER038
     D MSGID           S              7    DIM(40)                                            CER038
     D MSGDTA          S             45    DIM(40)                                            CER038
     D WFLDNM          S             10    DIM(40)                                            CER038
     D WMGID           S              7    DIM(40)                                            CER038
     D WMGDTA          S             45    DIM(40)                                            CER038
      *                                                                                       CER038
      ** Array for 22 * 35                                                                  BUG24460
      *                                                                                     BUG24460
     D EXT             S             35    DIM(22)                                          BUG24460
     D*                                                                                     BUG24460
     D*********** DS                                                                          082060
     D***********                         B   1   20##OSEQ                                    082060
     D****Convert Output Sequence between Numeric and Binary                                  082060
     D*
     D                 DS
     D  ##GRPX                 1     10
     D  ##GRPS                 1      6
     D  ##RDEN                 7     10  0
     D**  Look-up string for RDE definition Array
     D*
     D ##SDS           DS
     D/COPY WNCPYSRC,CG4510I006
     D**********                              15120 ##S                                      BUG9646
     D  ##S                    1   5632                                                      BUG9646
     D                                     DIM(22)                                          MD056543
     D/COPY WNCPYSRC,CG4510I007
     D**  Packed data string.
     D*
     D                 DS
     D/COPY WNCPYSRC,CG4510I008
     D  ##W                    1     20
     D                                     DIM(20)
     D  ##WNUM                 1     20  0
     D/COPY WNCPYSRC,CG4510I009
     D**  Number Field
     D*
     D                 DS
     D  ##ITMA                 1      8
     D  ##ITEM                 1      8  0
     D** Used to convert item reference from character to numeric
     D*                                                                                       216937
     D                 DS                                                                     216937
     D**********                              1  18 SRCGL                              216937 CGL029
     D  SRCGL                  1     34                                                       CSD027
     D  AGSBRC                 1      3                                                       216937
     D**********                              4   90AGSCUS                             216937 CSD027
     D  AGSCUS                 4      9                                                       CSD027
     D  AGSCCY                10     12                                                       216937
     D**********                             13  160AGSACD                             216937 CGL029
     D**********                             17  180AGSASN                             216937 CGL029
     D**********                             19  280AGSRNO                             216937 CGL029
     D**********                             19  28 SRCRET                             216937 CGL029
     D  AGSACD                13     22  0
     D  AGSASN                23     24  0
     D  AGSRNO                25     34  0
     D  SRCRET                25     34
     D                 DS                                                                     216006
     D  CMTXTG                 1    200                                                       216006
     D  WCMTX1                 1     65                                                       216006
     D  WCMTX2                66    130                                                       216006
     D  WCMTX3               131    195                                                       216006
     D  WCMTX4               196    260                                                       216006
     D*
     D ##UDCR        E DS                  EXTNAME(CGUDCRPD)
      ** External DS for incomplete reference
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  External DS for bank details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      **  External DS for branch details
      *
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
      **  External DS for account details
     D  LSTDAB       E                     EXTFLD(LSTD)
     D  NSTDAB       E                     EXTFLD(NSTD)
     D  LSTPAB       E                     EXTFLD(LSTP)
     D  CFSBAB       E                     EXTFLD(CFSB)
     D  YTDBAB       E                     EXTFLD(YTDB)
     D  GLBTAB       E                     EXTFLD(GLBT)
      *
     D SDCURR        E DS                  OCCURS(101) EXTNAME(SDCURRPD)
      **  External DS for currency details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)
      **  External DS for Customer details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      **  External DS for General Ledger Details
     D  QQACCX       E                     EXTFLD(QQACCD)                                   BUG23345
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT004
      ** MIDAS Switchable Features Accessed Via Access Program                                CFT004
      *                                                                                       CFT004
     D  LCX          E                     EXTFLD(LCD)                                        CFT004
     D/COPY WNCPYSRC,CG4510I003
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Second DS for access programs, long data structure
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   AR864876
      **  Third DS for access programs, very long data structure                            AR864876
      *                                                                                     AR864876
     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)                                AR864876
     D*                                                                                     AR864876
     D** Message network details                                                            AR864876
     D*                                                                                     AR864876
     D DSPARM        E DS                  EXTNAME(CGSTMTL1)
      **  External DS for parameters based on PF/STMTAH
     D************************************** 25  42 ##ACID                                    079997
     D**********                             28  42 ##ACI2                                    CGL029
     D  ##ACI2                28     48
     D  ##BRCA                25     27
     D**********                             28  330##CNUM                                    CSD027
     D  ##CNUM                28     33                                                       CSD027
     D  ##CNMA                28     33                                         N/Used
     D  ##CCY                 34     36
     D**********                             37  400##ACOD                                    CGL029
     D**********                             41  420##ACSQ                                    CGL029
     D  ##ACOD                37     46  0                                                    CGL029
     D  ##ACSQ                47     48  0                                                    CGL029
     D/COPY WNCPYSRC,CG4510I005
      *
     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
      **  Record format of PF/CGUDTAPD for use as a parameter
      *
     D                 DS
      **  DS to obtain Transaction Ref from DLREF
     D  DLREF                  1      8                                         N/Used
     D  ##TREF                 2      7                                         N/Used
      *
     D                 DS
      **  DS to obtain Batch Number and Batch Item Number
     D  SPOS                   1      7                                         N/Used
     D  ##BANO                 1      3                                         N/Used
     D  ##BITM                 4      6                                         N/Used
      *
     D ##SRDT          DS                  OCCURS(20)
      **  DS to store subroutine specific data.
      **  - Previous Bind
      **  - This Bind
      **  - Saved Path
     D**************                      B   1   20##PBIN                                    082060
     D**************                      B   3   40##TBIN                                    082060
     D**************                          5  74 ##SPAT                                    082060
     D  ##PBIN                 1      5P 0                                                    082060
     D  ##TBIN                 6     10P 0                                                    082060
     D  ##SPAT                11     80                                                       082060
     D*COPY*CGCPYSRC,CGPACKI                                                                MD056543
     D/COPY CGCPYSRC,CGPACKIILE                                                             MD056543
      *
      **  Define constant fields
     D C#STMT          C                   CONST('STATEMENT ')
     D C#NORM          C                   CONST('NORMAL    ')
     D C#TURN          C                   CONST('TURNOVER  ')
     D/COPY WNCPYSRC,CG4510I004
      *
     D CPYR            DS
      **  Data Structure for Compilation - Copyright Insertion
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *                                                                                       CER038
     D                 DS                                                                     CER038
     D  PACCD                  1     10  0                                                    CER038
      *                                                                                       CER038
     D  PACSQ                 11     12  0                                                    CER038
      *
     I/COPY WNCPYSRC,CG4510E004
      *                                                                                       239823
      ** Rename GLACBTL0 fields                                                               239823
      *                                                                                       239823
     IGLACBLF
     I              RECI                        GRECI
     I              LDBL                        GLDBL
     I              CLBL                        GCLBL
     I              LMVD                        GLMVD
     I/SPACE 5
     I/COPY WNCPYSRC,CG4510I002
     I*COPY*CGCPYSRC,SRERRI                                                                 MD056543
      *
     I/COPY WNCPYSRC,CG4510I001
     C/SPACE 5
      *****************************************************************
      *                                                               *
      *   Index to subroutines                                        *
      *   --------------------                                        *
      *                                                               *
      *   G#STMT - Main processing - top level group set              *
      *   G#SHDR - Header (simple)                                    *
      *   BRANCH - Branch Details (Simple)                            *
      *   ACCNT  - Account Details (Simple)                           *
      *   CUST   - Customer Details (Simple)                          *
      *   CCYGS  - Currency Details (Simple)                          *
      *   G#SPS1 - Posting group set 1 (complex)                      *
      *   G#SRC1 - Debit Rate change group set 1 (complex)            *
      *   G#SCC1 - Credit Rate change group set 1 (complex)           *
      *   G#SFTR - Footer (simple)                                    *
      *   SRNSTD - Calculate Next Statement Date                      *
      *   G#SOPB - Opening balance (simple)                           *
      *   G#SPS2 - Posting group set 2 (complex)                      *
      *   SRFLDT - Find First and Last Posting Date                   *
      *   SRCCLR - Calculate Clearing Amounts                         *
      *   G#SCLR - Cleared Balances Open/Closing (simple)             *
      *   G#SCLB - Closing balance (simple)                           *
      *   G#SBRK - Item/Value Breakdown (simple)                      *
      *   G#SRC2 - Debit Rate change group set 2 (simple)             *
      *   G#SCC2 - Credit Rate change group set 2 (simple)            *
      *   G#SPS3 - Posting group set 3 (simple)                       *
      *   SRGENR - Generate reference record                          *
      *   SRRRDE - Retrieve RDE information for RDE in group set      *
      *   SRADTA - Accumulate RDEs & associated data for Output       *
      *   SRRFMN - Reformat RDE data                                  *
      *   SRODTA - Output Accumulated Data to PF/CGUDTAPD             *
      *   SRDCDT - Determine Currency Details                         *
      *   SRINIT - Initial processing - On First Call                 *
      *   SRINZ  - Initialise Fields on Each Invocation               *
      *   *PSSR  - Exception/Error Handling                           *
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Process     :  MAINLINE                                       *
      * Function    :  Mainline processing                            *
      *                                                               *
      * Called by   :  None                                           *
      * Calls       :  SRINIT - Initial Processing - On First Call    *
      *                SRINZ  - Initialise Fields on Each Invocation  *
      *                G#STMT - Main Processing - Top Level Group Set *
      *****************************************************************
      *
      **  Parameter list for current program invocation.
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0CMT             3
     C                   PARM                    DSPARM
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
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
      **  Main processing - top level group set
     C                   EXSR      G#STMT
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
      * Subroutine  :  G#STMT                                         *
      * Function    :  Main processing - top level group set          *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  SRGENR - Generate reference record             *
      *                G#SHDR - Header (simple)                       *
      *                BRANCH - Branch Details (simple)               *
      *                ACCNT  - Account Details (simple)              *
      *                CUST   - Customer Details (simple)             *
      *                CCYGS  - Currency Details (simple)             *
      *                G#SPS1 - Posting group set 1 (complex)         *
      *                G#SRC1 - Rate change group set 1 (complex)     *
      *                G#SFTR - Footer (simple)                       *
      *                SRNSTD - Calculate Next Statement Date         *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     G#STMT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'g_STMT'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     1             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\g_STMT'     ##PNAM            7
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Determine whether the Statement is due...
     C                   MOVE      *BLANK        ##PROC            1
     C                   MOVE      *BLANK        ##DEMA            1
     C                   MOVE      *BLANK        ##MANA            1
     C                   MOVE      *BLANK        SDMSFL
      *
      **  ... If the Next Statement Date is before the Date of Next
      **      Working Day.
     C     SDNSTD        IFLT      BJDNWD
     C                   MOVE      'Y'           ##PROC
     C                   ENDIF
      *
      **  ... If a Demand Statement has been requested.
     C     ##PROC        IFNE      'Y'
     C                   MOVE      *OFF          *IN70
     C                   TESTB     '1'           SDGLBT                   70
     C     *IN70         IFEQ      *ON
     C                   MOVE      'Y'           ##DEMA
     C                   MOVE      'D'           SDMSFL
     C                   MOVE      'Y'           ##PROC
     C                   ENDIF
     C                   ENDIF
      *
      **  ... If a Management Statement has been requested.
     C     ##PROC        IFNE      'Y'
     C                   MOVE      *OFF          *IN70
     C                   TESTB     '0'           SDGLBT                   70
     C     *IN70         IFEQ      *ON
     C                   MOVE      'Y'           ##MANA
     C                   MOVE      'M'           SDMSFL
     C                   MOVE      'Y'           ##PROC
     C                   ENDIF
     C                   ENDIF
      *
      **  If the Statement is due, continue processing
     C     ##PROC        IFEQ      'Y'
      *
      **  Generate reference number by writing to PF/CGUDCRPD
      **  If the statement is to be produced, then produce it
      *
     C                   EXSR      SRGENR
     C     ##PROC        IFEQ      'Y'
     C                   EXSR      PSHGRS                                                     CCG015
      *
      **  Header (simple)
     C                   EXSR      G#SHDR
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      **  Branch Details (simple)
     C                   EXSR      BRANCH
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      **  Account Details (simple)
     C                   EXSR      ACCNT
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      **  Customer Details (simple)
     C                   EXSR      CUST
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
     C/COPY WNCPYSRC,CG4510C024
      *                                                                                       089776
      ** Counterparty Account Officer Details                                                 089776
     C                   EXSR      ACOF                                                       089776
     C     1             OCCUR     ##SRDT                                        1            089776
     C                   MOVEL     ##SPAT        S#PATH                          1            089776
     C                   Z-ADD     ##PBIN        S#PBIN                                       089776
     C                   Z-ADD     ##TBIN        S#TBIN                                       089776
      *
      **  Currency Details (simple)
     C                   EXSR      CCYGS
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
     C                   Z-ADD     ##PBIN        S#PBIN
     C/COPY WNCPYSRC,CGH00009
     C                   Z-ADD     ##TBIN        S#TBIN
      *
     C/COPY WNCPYSRC,CG4510C003
      *                                                                                       CER038
      ** If CER038 is installed                                                               CER038
      *                                                                                       CER038
     C     CER038        IFEQ      'Y'                                                        CER038
      *                                                                                       CER038
      ** Open Correspondent file                                                              CER038
      *                                                                                       CER038
     C                   OPEN      CGCORRL4                                                   CER038
     C                   MOVE      BRCA          WBRNCH                                       CER038
      *                                                                                       CER038
      ** Extract new Fields                                                                   CER038
      *                                                                                       CER038
     C                   EXSR      CGACBR                                                     CER038
     C     1             OCCUR     ##SRDT                                                     CER038
     C                   MOVEL     ##SPAT        S#PATH                                       CER038
     C                   Z-ADD     ##PBIN        S#PBIN                                       CER038
     C                   Z-ADD     ##TBIN        S#TBIN                                       CER038
      *                                                                                       CER038
      ** Close Correspondent file                                                             CER038
      *                                                                                       CER038
     C                   CLOSE     CGCORRL4                                                   CER038
      *                                                                                       CER038
     C                   ENDIF                                                                CER038
      *                                                                                       CER038
     C********** CER031    IFEQ 'Y'                                                  CER038 BUG23277
     C**********           EXSR PSNARR                                               CER038 BUG23277
     C********** 1         OCUR ##SRDT                                               CER038 BUG23277
     C**********           MOVEL##SPAT    S#PATH                                     CER038 BUG23277
     C**********           MOVEL##PBIN    S#PBIN                                     CER038 BUG23277
     C**********           MOVEL##TBIN    S#TBIN                                     CER038 BUG23277
     C**********           ENDIF                                                     CER038 BUG23277
      *                                                                                       CER038
      **  Posting Group Set 1 (complex)
      *
      **  Increment Bind Levels for Complex Set only
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
     C                   EXSR      G#SPS1
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
     C                   Z-ADD     ##PBIN        S#PBIN
     C/COPY WNCPYSRC,CGH00006
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      **  Debit Rate Change Group Set 1 (complex)
     C/COPY WNCPYSRC,CG4510C033
     C                   EXSR      G#SRC1
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      **  Credit Rate Change Group Set 1 (complex)
     C                   EXSR      G#SCC1
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
     C/COPY WNCPYSRC,CG4510C034
      *
      **  Footer (simple)
     C                   EXSR      G#SFTR
     C     1             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Set up return parameters according to Statement Mode ...
      **  ... Initialise with input values.
     C                   Z-ADD     SDLSTD        SDULSD
     C                   Z-ADD     SDNSTD        SDUNXD
     C                   Z-ADD     SDLSTP        SDULSP
     C                   Z-ADD     SDCFSB        SDUCFB
     C                   Z-ADD     SDYTDB        SDUYTD
     C                   MOVE      SDGLBT        SDUGLB
      *
      **  ... Normal Mode - Next Statement Date before Date of Next
      **      Working Day.
      **  ... Demand Mode
      **  ... (Management Mode or no statement - no update)
     C     ##PROC        IFEQ      'Y'
     C     SDMSFL        ANDNE     'M'
      *
      **  Set up Last Statement Date.
     C                   Z-ADD     BJRDNB        SDULSD
      *
      **  Set up Next Statement Date (Only for 'Normal' Mode)
     C     SDMSFL        IFEQ      *BLANK
     C                   EXSR      SRNSTD
     C                   Z-ADD     ##NSTD        SDUNXD
     C                   ENDIF
      *
      **  Set up Last Page Number
     C                   Z-ADD     ##LSTT        SDULSP
      *
      **  Set up Carried Forward Statement Balance
     C                   Z-ADD     ##CFB         SDUCFB
      *
      **  Set up Carried Forward Cleared Balance
     C                   Z-ADD     ##CFCB        SDUYTD
      *
     C                   EXSR      POPGRS                                                     CCG015
     C                   ENDIF
      *
      **  Reset the Management and Demand Statement Bits in all cases.
     C                   BITOFF    '01'          SDUGLB
      *
      *................................................................
      *
     C     EXSTMT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  G#SHDR                                         *
      * Function    :  Header (simple)                                *
      *                 - Extract RDEs for statement header           *
      *                                                               *
      * Called by   :  G#STMT - Top level group set                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRADTA - Format Extract Data                   *
      *                SRODTA - Output Extract Data                   *
      *                AOACCTR0 - Obtain Account Details              *
      *****************************************************************
     C     G#SHDR        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'g_SHDR'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     2             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\g_SHDR'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Retrieve RDE information for RDEs in group set
     C                   MOVEL     'g_SHDR'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Access account details (LF/ACCNT)
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY    '    ##OPTN
     C                   PARM      *BLANKS       ##RETL           10
     C                   PARM      SDCNUM        ##CNUM
     C                   PARM      SDCCY         ##CCY
     C                   PARM      SDACOD        ##ACOD
     C                   PARM      SDACSQ        ##ACSQ
     C                   PARM      SDBRCA        ##BRCA
     C     SDACCT        PARM      SDACCT        DSSDY
      *
      **  If account master record not found, database error
     C     ##RTCD        IFNE      *BLANK
      *
     C                   MOVEL     'AOACCTR0'    W0FILE
     C**********           MOVEL##ACI2    ##WK18 18                                           CGL029
     C                   MOVEL     ##ACI2        ##WK18           24                          CGL029
     C                   MOVE      ##BRCA        ##WK18
     C                   MOVEL     ##WK18        W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      **  Set up Statement Date
     C                   MOVEL     BJRDNB        ##D(1)
      *
      **  Set up Last Statement Date
      **  For turnover statements, use the last movement date instead                         239823
      **  of the last statement date.                                                         239823
      *                                                                                       239823
     C     STFQ          IFEQ      'E'                                                        239823
     C     SDPSTP        ANDEQ     C#TURN                                                     239823
     C     KGLAC         CHAIN     GLACBTL0                           56                      239823
     C     *IN56         IFEQ      '0'                                                        239823
     C     GLMVD         ANDGT     0                                                          239823
     C                   MOVEL     GLMVD         ##D(2)                                       239823
     C                   ELSE                                                                 239823
     C                   MOVEL     DACO          ##D(2)                                       239823
     C                   ENDIF                                                                239823
     C                   ELSE                                                                 239823
     C                   MOVEL     LSTDAB        ##D(2)
     C                   ENDIF                                                                239823
      *
      **  Set up Statement Number
     C     SDLSTP        IFEQ      999                                                      AR325224
     C                   Z-ADD     1             ##LSTT                                     AR325224
     C                   ELSE                                                               AR325224
     C     SDLSTP        ADD       1             ##LSTT
     C                   ENDIF                                                              AR325224
     C                   MOVEL     ##LSTT        ##D(3)
     C                   MOVE      '0'           ##D(3)
      *
      **  Set up Demand Statement Indicator
     C                   MOVEL     ##DEMA        ##D(4)
      *
      **  Set up Management Statement Indicator
     C                   MOVEL     ##MANA        ##D(5)
     C/COPY WNCPYSRC,CG4510C025
      *
      **  Set up First/Subsequent/Last Indicator
     C                   MOVE      'FR'          ##FSLI
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
      *................................................................
      *
     C     EXSHDR        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS                                                     CCG015
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/COPY WNCPYSRC,CG4510C001
     C/COPY CGCPYSRC,CGACBR                                                                   CER038
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  BRANCH                                         *
      * Function    :  Branch Details (Simple)                        *
      *                - Obtain Branch Details                        *
      *                                                               *
      * Called by   :  G#STMT - Top level group set                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRADTA - Format Extract Data                   *
      *                SRODTA - Output Extract Data                   *
      *                AOBRCHR0 - Obtain Branch Details               *
      *****************************************************************
     C     BRANCH        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'BRANCH'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     3             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\BRANCH'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'BRANCH'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Get Branch Details if the Branch has changed
     C     SDBRCA        IFNE      ##BRCD
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG    '    ##RTCD
     C                   PARM      '*KEY    '    ##OPTN
     C                   PARM      SDBRCA        ##BRCD
     C********** SDBRCH    PARM SDBRCH    DSFDY                                               CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      **  Database Error
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDBRCHPD'    W0FILE
     C                   MOVEL     SDBRCA        W0KEY                          ***************
     C                   Z-ADD     2             W0ERNB                         * DB ERROR 02 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C/COPY WNCPYSRC,CG4510C014
     C                   ENDIF
      *
      **  Set up Branch Code
     C                   MOVEL     A8BRCD        ##D(1)
      *
      **  Set up Branch Name
     C                   MOVEL     A8BRNM        ##D(2)
     C/COPY WNCPYSRC,CG4510C015
      *
      **  Set up First/Subsequent/Last Indicator
     C                   MOVE      'FR'          ##FSLI
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
     C                   EXSR      POPGRS                                                     CCG015
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5                                                                                CER038
      *****************************************************************                       CER038
      * Subroutine  :  PSNARR                                         *                       CER038
      * Function    :  Extract Posting Narratives                     *                       CER038
      *                                                               *                       CER038
      *                                                               *                       CER038
      * Called by   :  G#STMT - Top level group set                   *                       CER038
      * Calls       :  SRRRDE - Retrieve RDE Information              *                       CER038
      *                SRADTA - Format Extract Data                   *                       CER038
      *                SRODTA - Output Extract Data                   *                       CER038
      *                SRERR  - Database Error                        *                       CER038
      *****************************************************************                       CER038
      *                                                                                       CER038
     C     PSNARR        BEGSR                                                                CER038
      *                                                                                       CER038
      ** Set up subroutine stack name                                                         CER038
      *                                                                                       CER038
     C                   ADD       1             Q                                            CER038
     C                   MOVEL     'PSNARR'      @STK(Q)                                      CER038
      *                                                                                       CER038
      ** Retrieve subroutine specific data                                                    CER038
      *                                                                                       CER038
     C     14            OCCUR     ##SRDT                                                     CER038
      *                                                                                       CER038
      ** Setup path                                                                           CER038
      *                                                                                       CER038
     C                   MOVEL     '\PSNARR'     ##PNAM                                       CER038
     C     S#PATH        CAT       ##PNAM:0      S#PATH                                       CER038
     C                   EXSR      PSHGRS                                                     CER038
     C                   MOVEL     S#PATH        ##SPAT                                       CER038
      *                                                                                       CER038
      ** Set up Binds from passed in values.                                                  CER038
      *                                                                                       CER038
     C                   MOVEL     S#PBIN        ##PBIN                                       CER038
     C                   MOVEL     S#TBIN        ##TBIN                                       CER038
      *                                                                                       CER038
      ** Retrieve RDE info                                                                    CER038
      *                                                                                       CER038
     C                   MOVEL     'PSNARR'      ##GRPS                                       CER038
     C                   Z-ADD     1             ##RDEN                                       CER038
     C                   EXSR      SRRRDE                                                     CER038
      *                                                                                     BUG25261
      ** Clear parameters                                                                   BUG25261
      *                                                                                     BUG25261
     C                   MOVE      *BLANKS       PNAR1                                      BUG25261
     C                   MOVE      *BLANKS       PNAR2                                      BUG25261
     C                   MOVE      *BLANKS       PNAR3                                      BUG25261
     C                   MOVE      *BLANKS       PNAR4                                      BUG25261
     C                   MOVE      *BLANKS       PNAR5                                      BUG25261
     C                   MOVE      *BLANKS       PNAR6                                      BUG25261
      *                                                                                       CER038
      ** Retrieve posting narratives from GLAPSTPD                                            CER038
      *                                                                                       CER038
     C********** ##ACKY    CHAINAPOSTPDF             55                              CER038 BUG23277
     C********** *IN55     IFEQ *OFF                                                 CER038 BUG23277
     C********** ##POST    CHAINGLAPSTPF             52                              CER038 BUG23277
     C********** *IN52     IFEQ *OFF                                                 CER038 BUG23277
      *                                                                                     BUG26680
     C                   MOVE      *BLANK        WMT22                                      BUG26680
     C                   MOVEL     ##BITM        W#BITM                                     BUG26680
     C                   MOVE      'N'           WHSTX             1                        BUG26680
     C********** KJNAR     CHAINGLJENXL2             52                            BUG26680 AR881900
     C     KJNAR#        CHAIN     GLJENXL1                           52                    AR881900
     C     *IN52         IFEQ      *ON                                                      BUG26680
     C     KJNAR#        CHAIN     GLJEHXL2                           52                    BUG26680
     C     *IN52         IFEQ      *OFF                                                     BUG24460
     C                   MOVE      'Y'           WHSTX                                      BUG26680
     C                   ENDIF                                                              BUG26680
     C                   ENDIF                                                              BUG26680
      *                                                                                       CER038
      ** Setup Narratives                                                                     CER038
      *                                                                                       CER038
     C     *IN52         IFEQ      *OFF                                                     BUG24460
     C     CER031        ANDEQ     'Y'                                                      BUG24460
      **********                                                                            BUG26680
     C                   MOVEL     BAADI1        PNAR1                                      BUG26680
     C                   MOVEL     BAADI2        PNAR2                                      BUG26680
     C                   MOVEL     BAADI3        PNAR3                                      BUG26680
     C                   MOVEL     BAADI4        PNAR4                                      BUG26680
     C                   MOVEL     BAADI5        PNAR5                                      BUG26680
     C                   MOVEL     BAADI6        PNAR6                                      BUG26680
      *                                                                                     BUG26680
     C     WHSTX         IFEQ      'Y'                                                      BUG26680
     C                   MOVEL     HAADI1        PNAR1                                      BUG26680
     C                   MOVEL     HAADI2        PNAR2                                      BUG26680
     C                   MOVEL     HAADI3        PNAR3                                      BUG26680
     C                   MOVEL     HAADI4        PNAR4                                      BUG26680
     C                   MOVEL     HAADI5        PNAR5                                      BUG26680
     C                   MOVEL     HAADI6        PNAR6                                      BUG26680
     C                   ENDIF                                                              BUG26680
      *                                                                                     BUG26680
     C**********           MOVELPSNAR1    PNAR1                                      CER038 BUG26680
     C**********           MOVELPSNAR2    PNAR2                                      CER038 BUG26680
     C**********           MOVELPSNAR3    PNAR3                                      CER038 BUG26680
     C**********           MOVELPSNAR4    PNAR4                                      CER038 BUG26680
     C**********           MOVELPSNAR5    PNAR5                                      CER038 BUG26680
     C**********           MOVELPSNAR6    PNAR6                                      CER038 BUG26680
      *                                                                                     BUG24460
     C                   ELSE                                                               BUG24460
      *                                                                                     BUG24460
     C                   MOVEL     ##BITM        W#BITM                                     BUG24460
      *                                                                                     BUG24460
     C     KLNAR         CHAIN     GLMNARL1                           97                    BUG24460
     C     *IN97         IFEQ      *OFF                                                     BUG24460
     C     CER030        ANDEQ     'Y'                                                      BUG24460
     C                   EXSR      SREVNA                                                   BUG24460
     C                   MOVEL     'Y'           WMT22             1                        BUG24460
     C                   ENDIF                                                              BUG24460
      *                                                                                     BUG24460
     C                   ENDIF                                                              BUG24460
      *                                                                                       CER038
      ** Setup Account information fields                                                     CER038
      *                                                                                       CER038
     C                   MOVEL     ##BRCA        PBRCA                                        CER038
     C                   MOVEL     ##CNUM        PCUSNO                                       CER038
     C                   MOVEL     ##CCY         PCUCD                                        CER038
     C                   MOVEL     ##ACOD        PACCD                                        CER038
     C                   MOVEL     ##ACSQ        PACSQ                                        CER038
     C                   MOVEL     '*FORMAT'     POPTN                                        CER038
      *                                                                                     BUG23445
      ** Format according to network Paper if Account is linked                             BUG23445
      *                                                                                     BUG23445
     C                   MOVEL     *BLANKS       PNTWK                                      BUG23445
     C     CGL013        IFEQ      'Y'                                                      BUG23445
     C                   MOVEL     'PAPER'       KNWRK             6                        BUG23445
     C                   MOVE      PACCD         KACCD            10 0                      BUG23445
     C                   MOVE      PACSQ         KACSQ             2 0                      BUG23445
     C********** KACCT     CHAINGLNW94L1             95                           BUG23445 BUG23445A
     C     KACCT         CHAIN     GLNWACL1                           95                   BUG23445A
     C     *IN95         IFEQ      *OFF                                                     BUG23445
     C**********           MOVELN4NWRK    PNTWK                                   BUG23445 BUG23445A
     C                   MOVEL     NANWRK        PNTWK                                     BUG23445A
     C                   ENDIF                                                              BUG23445
     C                   ENDIF                                                              BUG23445
      *                                                                                     BUG24460
      ** Set Flag for Accumulate RDE's and data when RDE's > than 21                        BUG24460
      *                                                                                     BUG24460
     C                   MOVEL     *BLANKS       WACUM             1                        BUG24460
      *                                                                                     BUG24460
     C     WMT22         IFEQ      'Y'                                                      BUG24460
     C                   MOVEL     'Y'           WACUM                                      BUG24460
      *                                                                                     BUG24460
      ** Call the MG001901 access object to format the extended                             BUG24460
      ** narratives                                                                         BUG24460
      *                                                                                     BUG24460
     C                   CALL      'MG001901'                                               BUG24460
     C                   PARM      *BLANKS       PRTCD2                                     BUG24460
     C                   PARM                    POPTN                                      BUG24460
     C                   PARM                    PNTWK                                      BUG24460
     C                   PARM                    PMGTYP                                     BUG24460
     C                   PARM                    PBRCA                                      BUG24460
     C                   PARM                    PCUSNO                                     BUG24460
     C                   PARM                    PCUCD                                      BUG24460
     C                   PARM                    PACCD                                      BUG24460
     C                   PARM                    PACSQ                                      BUG24460
     C                   PARM                    PDCIN                                      BUG24460
     C                   PARM                    PTRTP                                      BUG24460
      *                                                                                     BUG24460
      ** Extended Narratives of length 22 * 35                                              BUG24460
      *                                                                                     BUG24460
     C                   PARM                    EXT                                        BUG24460
      *                                                                                     BUG24460
     C                   PARM      *BLANKS       PRTF1                                      BUG24460
     C                   PARM      *BLANKS       PRTF2                                      BUG24460
     C                   PARM      *BLANKS       PRTF3                                      BUG24460
     C                   PARM      *BLANKS       PRTF4                                      BUG24460
     C                   PARM      *BLANKS       PRTF5                                      BUG24460
     C                   PARM      *BLANKS       PRTF6                                      BUG24460
     C                   PARM      *BLANKS       PRTF7                                      BUG24460
     C                   PARM      *BLANKS       PRTF8                                      BUG24460
     C                   PARM      *BLANKS       PRTF9                                      BUG24460
     C                   PARM      *BLANKS       PRTF10                                     BUG24460
     C                   PARM      *BLANKS       PRTF11                                     BUG24460
     C                   PARM      *BLANKS       PRTF12                                     BUG24460
     C                   PARM      *BLANKS       PRTF13                                     BUG24460
     C                   PARM      *BLANKS       PRTF14                                     BUG24460
     C                   PARM      *BLANKS       PRTF15                                     BUG24460
     C                   PARM      *BLANKS       PRTF16                                     BUG24460
     C                   PARM      *BLANKS       PRTF17                                     BUG24460
     C                   PARM      *BLANKS       PRTF18                                     BUG24460
     C                   PARM      *BLANKS       PRTF19                                     BUG24460
     C                   PARM      *BLANKS       PRTF20                                     BUG24460
     C                   PARM      *BLANKS       PRTF21           70                        BUG24460
     C                   PARM      *BLANKS       PRTF22           70                        BUG24460
     C                   PARM                    IDX                                        BUG24460
     C                   PARM                    FLDNAM                                     BUG24460
     C                   PARM                    MSGID                                      BUG24460
     C                   PARM                    MSGDTA                                     BUG24460
     C                   PARM                    WFLDNM                                     BUG24460
     C                   PARM                    WMGID                                      BUG24460
     C                   PARM                    WMGDTA                                     BUG24460
      *                                                                                     BUG24460
     C     PRTCD2        IFEQ      *BLANKS                                                  BUG24460
     C     PRTCD2        OREQ      '*FORMAT'                                                BUG24460
      *                                                                                     BUG24460
     C                   MOVEL     PRTF1         ##D(1)                                     BUG24460
     C                   MOVEL     PRTF2         ##D(2)                                     BUG24460
     C                   MOVEL     PRTF3         ##D(3)                                     BUG24460
     C                   MOVEL     PRTF4         ##D(4)                                     BUG24460
     C                   MOVEL     PRTF5         ##D(5)                                     BUG24460
     C                   MOVEL     PRTF6         ##D(6)                                     BUG24460
     C                   MOVEL     PRTF7         ##D(7)                                     BUG24460
     C                   MOVEL     PRTF8         ##D(8)                                     BUG24460
     C                   MOVEL     PRTF9         ##D(9)                                     BUG24460
     C                   MOVEL     PRTF10        ##D(10)                                    BUG24460
     C                   MOVEL     PRTF11        ##D(11)                                    BUG24460
     C                   MOVEL     PRTF12        ##D(12)                                    BUG24460
     C                   MOVEL     PRTF13        ##D(13)                                    BUG24460
     C                   MOVEL     PRTF14        ##D(14)                                    BUG24460
     C                   MOVEL     PRTF15        ##D(15)                                    BUG24460
     C                   MOVEL     PRTF16        ##D(16)                                    BUG24460
     C                   MOVEL     PRTF17        ##D(17)                                    BUG24460
     C                   MOVEL     PRTF18        ##D(18)                                    BUG24460
     C                   MOVEL     PRTF19        ##D(19)                                    BUG24460
     C                   MOVEL     PRTF20        ##D(20)                                    BUG24460
      *                                                                                     BUG24460
     C                   ELSE                                                               BUG24460
      *                                                                                     BUG24460
     C                   MOVEL     'MG001901'    W0FILE                                     BUG24460
     C                   MOVEL     EXT(1)        W0KEY                                      BUG24460
     C                   Z-ADD     36            W0ERNB                                     BUG24460
     C                   MOVEL     'MEM5003'     W0MSGD                                     BUG24460
     C                   MOVEL     'MIDAS'       W0MSGF                                     BUG24460
     C                   EXSR      SRERR                                                    BUG24460
     C                   ENDIF                                                              BUG24460
      *                                                                                     BUG24460
     C                   ELSE                                                               BUG24460
      *                                                                                       CER038
     C                   CALL      'MG001900'                                                 CER038
     C                   PARM                    PRTCD2           10                          CER038
     C                   PARM                    POPTN             7                          CER038
     C                   PARM                    PNTWK             6                          CER038
     C                   PARM                    PMGTYP            3                          CER038
     C                   PARM                    PBRCA             3                          CER038
     C**********           PARM           PCUSNO  60                                   CER038 CER059
     C                   PARM                    PCUSNO            6                          CER059
     C                   PARM                    PCUCD             3                          CER038
     C                   PARM                    PACCD                                        CER038
     C                   PARM                    PACSQ                                        CER038
     C                   PARM                    PDCIN             1                          CER038
     C                   PARM                    PTRTP             5                          CER038
     C                   PARM                    PNAR1            65                          CER038
     C                   PARM                    PNAR2            65                          CER038
     C                   PARM                    PNAR3            65                          CER038
     C                   PARM                    PNAR4            65                          CER038
     C                   PARM                    PNAR5            65                          CER038
     C                   PARM                    PNAR6            65                          CER038
     C**********           PARM           PRTF1  70                                  CER038 BUG23197
     C**********           PARM           PRTF2  70                                  CER038 BUG23197
     C**********           PARM           PRTF3  70                                  CER038 BUG23197
     C**********           PARM           PRTF4  70                                  CER038 BUG23197
     C**********           PARM           PRTF5  70                                  CER038 BUG23197
     C**********           PARM           PRTF6  70                                  CER038 BUG23197
     C**********           PARM           PRTF7  70                                  CER038 BUG23197
     C**********           PARM           PRTF8  70                                  CER038 BUG23197
     C**********           PARM           PRTF9  70                                  CER038 BUG23197
     C**********           PARM           PRTF10 70                                  CER038 BUG23197
     C**********           PARM           PRTF11 70                                  CER038 BUG23197
     C**********           PARM           PRTF12 70                                  CER038 BUG23197
     C**********           PARM           PRTF13 70                                  CER038 BUG23197
     C**********           PARM           PRTF14 70                                  CER038 BUG23197
     C**********           PARM           PRTF15 70                                  CER038 BUG23197
     C**********           PARM           PRTF16 70                                  CER038 BUG23197
     C**********           PARM           PRTF17 70                                  CER038 BUG23197
     C**********           PARM           PRTF18 70                                  CER038 BUG23197
     C**********           PARM           PRTF19 70                                  CER038 BUG23197
     C**********           PARM           PRTF20 70                                  CER038 BUG23197
     C                   PARM      *BLANKS       PRTF1            70                        BUG23197
     C                   PARM      *BLANKS       PRTF2            70                        BUG23197
     C                   PARM      *BLANKS       PRTF3            70                        BUG23197
     C                   PARM      *BLANKS       PRTF4            70                        BUG23197
     C                   PARM      *BLANKS       PRTF5            70                        BUG23197
     C                   PARM      *BLANKS       PRTF6            70                        BUG23197
     C                   PARM      *BLANKS       PRTF7            70                        BUG23197
     C                   PARM      *BLANKS       PRTF8            70                        BUG23197
     C                   PARM      *BLANKS       PRTF9            70                        BUG23197
     C                   PARM      *BLANKS       PRTF10           70                        BUG23197
     C                   PARM      *BLANKS       PRTF11           70                        BUG23197
     C                   PARM      *BLANKS       PRTF12           70                        BUG23197
     C                   PARM      *BLANKS       PRTF13           70                        BUG23197
     C                   PARM      *BLANKS       PRTF14           70                        BUG23197
     C                   PARM      *BLANKS       PRTF15           70                        BUG23197
     C                   PARM      *BLANKS       PRTF16           70                        BUG23197
     C                   PARM      *BLANKS       PRTF17           70                        BUG23197
     C                   PARM      *BLANKS       PRTF18           70                        BUG23197
     C                   PARM      *BLANKS       PRTF19           70                        BUG23197
     C                   PARM      *BLANKS       PRTF20           70                        BUG23197
     C                   PARM                    IDX               3 0                      BUG23197
     C                   PARM                    FLDNAM                                     BUG23197
     C                   PARM                    MSGID                                      BUG23197
     C                   PARM                    MSGDTA                                     BUG23197
     C                   PARM                    WFLDNM                                     BUG23197
     C                   PARM                    WMGID                                      BUG23197
     C                   PARM                    WMGDTA                                     BUG23197
      *                                                                                       CER038
     C     PRTCD2        IFEQ      ' '                                                        CER038
     C     PRTCD2        OREQ      '*FORMAT'                                                  CER038
     C                   MOVEL     PRTF1         ##D(1)                                       CER038
     C                   MOVEL     PRTF2         ##D(2)                                       CER038
     C                   MOVEL     PRTF3         ##D(3)                                       CER038
     C                   MOVEL     PRTF4         ##D(4)                                       CER038
     C                   MOVEL     PRTF5         ##D(5)                                       CER038
     C                   MOVEL     PRTF6         ##D(6)                                       CER038
     C                   MOVEL     PRTF7         ##D(7)                                       CER038
     C                   MOVEL     PRTF8         ##D(8)                                       CER038
     C                   MOVEL     PRTF9         ##D(9)                                       CER038
     C                   MOVEL     PRTF10        ##D(10)                                      CER038
     C                   MOVEL     PRTF11        ##D(11)                                      CER038
     C                   MOVEL     PRTF12        ##D(12)                                      CER038
     C                   MOVEL     PRTF13        ##D(13)                                      CER038
     C                   MOVEL     PRTF14        ##D(14)                                      CER038
     C                   MOVEL     PRTF15        ##D(15)                                      CER038
     C                   MOVEL     PRTF16        ##D(16)                                      CER038
     C                   MOVEL     PRTF17        ##D(17)                                      CER038
     C                   MOVEL     PRTF18        ##D(18)                                      CER038
     C                   MOVEL     PRTF19        ##D(19)                                      CER038
     C                   MOVEL     PRTF20        ##D(20)                                      CER038
      *                                                                                       CER038
     C                   ELSE                                                                 CER038
     C                   MOVEL     'MG001900'    W0FILE                                       CER038
     C                   MOVEL     PNAR1         W0KEY                                        CER038
     C**********           Z-ADD31        W0ERNB                                    CER038 AR750273B
     C                   Z-ADD     44            W0ERNB                                    AR750273B
     C                   MOVEL     'MEM5003'     W0MSGD                                       CER038
     C                   MOVEL     'MIDAS'       W0MSGF                                       CER038
     C                   EXSR      SRERR                                                      CER038
     C                   ENDIF                                                                CER038
     C                   ENDIF                                                              BUG24460
     C**********           ENDIF                                                     CER038 BUG23277
     C**********           ENDIF                                                     CER038 BUG23277
      *                                                                                       CER038
      ** Accumulate RDEs and associated data and output to                                    CER038
      ** PF/ CGUDTAPD                                                                         CER038
      *                                                                                       CER038
     C                   EXSR      SRADTA                                                     CER038
      *                                                                                     BUG24460
     C     WACUM         IFEQ      'Y'                                                      BUG24460
      *                                                                                     BUG24460
      ** Retrieve RDE information for RDEs in group set                                     BUG24460
      *                                                                                     BUG24460
     C                   MOVEL     @STK(Q)       ##GRPS                                     BUG24460
     C                   Z-ADD     21            ##RDEN                                     BUG24460
     C                   EXSR      SRRRDE                                                   BUG24460
      *                                                                                     BUG24460
     C                   MOVEL     PRTF21        ##D(1)                                     BUG24460
     C                   MOVEL     PRTF22        ##D(2)                                     BUG24460
      *                                                                                     BUG24460
     C                   EXSR      SRADTA                                                   BUG24460
      *                                                                                     BUG24460
     C                   MOVEL     *BLANKS       EXT                                        BUG24460
     C                   MOVEL     *BLANKS       WACUM                                      BUG24460
      *                                                                                     BUG24460
     C                   ENDIF                                                              BUG24460
      *                                                                                     BUG24460
     C                   EXSR      SRODTA                                                   BUG24460
      *                                                                                       CER038
     C     EXNARR        TAG                                                                  CER038
      *                                                                                       CER038
      ** Unwind subroutine stack name                                                         CER038
      *                                                                                       CER038
     C                   EXSR      POPGRS                                                     CER038
     C                   MOVEA     ' '           @STK(Q)                                      CER038
     C                   SUB       1             Q                                            CER038
      *                                                                                       CER038
     C                   ENDSR                                                                CER038
      *****************************************************************                       CER038
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  ACCNT                                          *
      * Function    :  Account Details (Simple)                       *
      *                - Obtain Account Details                       *
      *                                                               *
      * Called by   :  G#STMT - Top level group set                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRADTA - Format Extract Data                   *
      *                SRODTA - Output Extract Data                   *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     ACCNT         BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'ACCNT '      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     4             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\ACCNT '     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'ACCNT '      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  If the Account is Retail, access the Retail Interest and
      **  Charges on Accounts file, LF/REIACD
     C**********           MOVEL##ACI2    ##ACID 18                                    079997 CGL029
     C                   MOVEL     ##ACI2        ##ACID           24                          CGL029
     C                   MOVE      ##BRCA        ##ACID                                       079997
     C     SDATYP        IFEQ      'R'
     C     ##REKY        CHAIN     REIAC                              51
      *
      **  If record not found, database error
     C     *IN51         IFEQ      *ON
     C                   MOVEL     'REIAC   '    W0FILE
     C******************** MOVEL##ACI2    ##WK18                                              079997
     C******************** MOVE ##BRCA    ##WK18                                              079997
     C******************** MOVEL##WK18    W0KEY            ***************                    079997
     C                   MOVEL     ##ACID        W0KEY                          **************079997
     C                   Z-ADD     3             W0ERNB                         * DB ERROR 03 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
      **  Set up Account Identifier
     C                   MOVEL     ##ACID        ##D(1)
      *
      **  Set up Retail Account Number
     C     ACNO          IFNE      *ZEROS
     C                   MOVEL     ACNO          ##D(2)
     C                   ENDIF
      *
      **  Set up Account Name
     C                   MOVEL     ANAM          ##D(3)
      *
      **  Set up Account Type
     C                   MOVEL     SDATYP        ##D(4)
     C/COPY WNCPYSRC,CG4510C027
      *                                                                                       CEU013
     C     CEU013        IFEQ      'Y'                                                        CEU013
      **  Set up Statement Balances in Euros Indicator                                        CEU013
     C                   MOVEL     EUSB          ##D(5)                                       CEU013
     C                   ENDIF                                                                CEU013
      *                                                                                       CFT004
      ** Set up International Bank Account Number (IBAN)                                      CFT004
      *                                                                                       CFT004
     C     CFT004        IFEQ      'Y'                                                        CFT004
     C                   MOVE      *BLANKS       PIWITH                                       CFT004
     C     IBAN          IFNE      *BLANKS                                                    CFT004
     C                   CALL      'AOIBANR3'                                                 CFT004
     C                   PARM      *BLANKS       PRTCD             7                          CFT004
     C                   PARM      IBAN          PIBAN            47                          CFT004
     C                   PARM                    PIWITH           47                          CFT004
     C                   PARM      *BLANKS       PINOBL           34                          CFT004
     C                   ENDIF                                                                CFT004
     C                   MOVEL     PIWITH        ##D(6)                                       CFT004
     C                   ENDIF                                                                CFT004
     C/COPY WNCPYSRC,CG4510C009
      *
      **  Set up First/Subsequent/Last Indicator
     C                   MOVE      'FR'          ##FSLI
      *                                                                                       CRE073
      ** Set up CRE073 Flag                                                                   CRE073
      *                                                                                       CRE073
     C                   MOVEL     CRE073        ##D(7)                                       CRE073
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
      *................................................................
      *
     C     EXACCN        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS                                                     CCG015
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  CUST                                           *
      * Function    :  Customer Details (Simple)                      *
      *                - Obtain Customer Details                      *
      *                                                               *
      * Called by   :  G#STMT - Top level group set                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRADTA - Format Extract Data                   *
      *                SRODTA - Output Extract Data                   *
      *                SRERR  - Database Error                        *
      *                AOCUSTR0 - Obtain Customer Details             *
      *****************************************************************
     C     CUST          BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'CUST  '      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     5             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\CUST  '     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'CUST  '      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Access Customer Details if the Customer has changed.
      **  (LF/SDCUSTL1)
     C     ##CNMA        IFNE      BBCUST
     C                   MOVE      *BLANKS       ##KEY1
     C                   MOVE      SDCNUM        ##KEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*KEY   '     ##OPTN
     C                   PARM                    ##KEY1           10
     C                   PARM      *BLANKS       ##KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      **  If not found, Database Error.
     C     ##RTCD        IFNE      *BLANK
     C     ##RTCD        ANDNE     '*CUSCLS'
     C     ##RTCD        ANDNE     '*CUSDEL'
     C                   MOVEL     'SDCUSTPD'    W0FILE
     C                   MOVEL     SDCNUM        W0KEY                          ***************
     C                   Z-ADD     4             W0ERNB                         * DB ERROR 04 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
      **  Set up Customer Number
     C                   MOVEL     BBCUST        ##D(1)
      *
      **  Set up Customer Name
     C                   MOVEL     BBCRNM        ##D(2)
      *
      **  Set up Customer Address Line 1
     C                   MOVEL     BBCNA1        ##D(3)
      *
      **  Set up Customer Address Line 2
     C                   MOVEL     BBCNA2        ##D(4)
      *
      **  Set up Customer Address Line 3
     C                   MOVEL     BBCNA3        ##D(5)
      *
      **  Set up Customer Address Line 4
     C                   MOVEL     BBCNA4        ##D(6)
      *                                                                   086918
      ** Customer Town                                                    086918
     C                   MOVEL     BBCRTN        ##D(7)                                        08691
      *
     C/COPY WNCPYSRC,CG4510C016
      **  Set up First/Subsequent/Last Indicator
     C                   MOVE      'FR'          ##FSLI
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
     C                   EXSR      POPGRS                                                     CCG015
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  089776
      *****************************************************************                       089776
      * Subroutine  :  ACOF                                           *                       089776
      * Function    :  Account Officer Details                        *                       089776
      *                                                               *                       089776
      * Called by   :  SRRMDR - Common Group Set Routine              *                       089776
      * Calls       :  SRRRDE - Retrieve RDE Information              *                       089776
      *                SRADTA - Format Extract Data                   *                       089776
      *                SRODTA - Output Extract Data                   *                       089776
      *                SRERR  - Database Error                        *                       089776
      *****************************************************************                       089776
     C     ACOF          BEGSR                                                                089776
      *                                                                                       089776
      **  Set up subroutine stack name                                                        089776
      *                                                                                       089776
     C                   ADD       1             Q                                            089776
     C                   MOVEL     'ACOF  '      @STK(Q)                                      089776
      *                                                                                       089776
      **  Retrieve subroutine specific data.                                                  089776
      *                                                                                       089776
     C     20            OCCUR     ##SRDT                                                     089776
      *                                                                                       089776
      **  Set up Path.                                                                        089776
      *                                                                                       089776
     C                   MOVEL     '\ACOF  '     ##PNAM                                       089776
     C     S#PATH        CAT       ##PNAM:0      S#PATH                                       089776
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT                                       089776
     C                   Z-ADD     S#PBIN        ##PBIN                                       089776
     C                   Z-ADD     S#TBIN        ##TBIN                                       089776
      *................................................................                       089776
      *                                                                                       089776
      **  Retrieve RDE information for RDE's in Group Set                                     089776
      *                                                                                       089776
     C                   MOVEL     'ACOF  '      ##GRPS                                       089776
     C                   Z-ADD     1             ##RDEN                                       089776
     C                   EXSR      SRRRDE                                                     089776
      *                                                                                       089776
      **  Do not process if Account Officer blank.                                            089776
     C     BBACOC        IFEQ      *BLANKS                                                    089776
     C                   GOTO      EXACOF                                                     089776
     C                   ENDIF                                                                089776
      *                                                                                       089776
      **  Account Officer details                                                             089776
     C     BBACOC        CHAIN     SDACOFL0                           50                      089776
      *                                                                                       089776
      **  Account Officer details not found                                                   089776
     C     *IN50         IFEQ      '1'                                                        089776
     C                   GOTO      EXACOF                                                     089776
     C                   END                                                                  089776
      *                                                                                       089776
      **  Account Officer Code                                                                089776
     C                   MOVEL     AZACOC        ##D(1)                                       089776
      *                                                                                       089776
      **  Account Officer Dept                                                                089776
     C                   MOVEL     AZDPCD        ##D(2)                                       089776
      *                                                                                       089776
      **  Account Officer Name                                                                089776
     C                   MOVEL     AZACON        ##D(3)                                       089776
      *                                                                                       089776
      **  Account Officer Telephone Number                                                    089776
     C                   MOVEL     AZAPHN        ##D(4)                                       089776
      *                                                                                       089776
      **  Account Officer Telephone Extension                                                 089776
     C                   MOVEL     AZAEXT        ##D(5)                                       089776
      *                                                                                       089776
      **  Set up First/Subsequent/Last Indicator                                              089776
     C                   MOVE      'FR'          ##FSLI                                       089776
      *                                                                                       089776
      **  Accumulate RDE's and associated data and output to                                  089776
      **  PF/CGUDTAPD.                                                                        089776
     C                   EXSR      SRADTA                                                     089776
     C                   EXSR      SRODTA                                                     089776
      *                                                                                       089776
      *................................................................                       089776
      *                                                                                       089776
      **  Unwind subroutine stack name                                                        089776
      *                                                                                       089776
     C     EXACOF        TAG                                                                  089776
     C                   EXSR      POPGRS                                                     089776
     C                   MOVEA     *BLANKS       @STK(Q)                                      089776
     C                   SUB       1             Q                                            089776
      *                                                                                       089776
     C                   ENDSR                                                                089776
      *****************************************************************                       089776
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  CCYGS                                          *
      * Function    :  Currency Details (Simple)                      *
      *                - Obtain Customer Details                      *
      *                                                               *
      * Called by   :  G#STMT - Top level group set                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRDCDT - Determine Currency Details            *
      *                SRADTA - Format Extract Data                   *
      *                SRODTA - Output Extract Data                   *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     CCYGS         BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'CCYGS '      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     6             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\CCY   '     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'CCY   '      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Determine Currency Details
     C                   MOVE      ##CCY         CCYDS             3                          153769
     C                   EXSR      SRDCDT
      *
      **  Set up Currency Code
     C                   MOVEL     A6CYCD        ##D(1)
      *
      **  Set up Currency Description
     C                   MOVEL     A6CYNM        ##D(2)
      *                                                                                       086780
      **  Set up Precious metal indicator                                                     086780
     C                   MOVEL     A6PMRT        ##D(3)                                       086780
      *
      **  Set up First/Subsequent/Last Indicator
     C                   MOVE      'FR'          ##FSLI
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
      *................................................................
      *
     C     EXCCY         TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS                                                     CCG015
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  G#SPS1                                         *
      * Function    :  Posting group set 1 (complex)                  *
      *                                                               *
      * Called by   :  G#STMT - Top level group set                   *
      * Calls       :  G#SOPB - Opening balance (simple)              *
      *                G#SPS2 - Posting group set 2 (complex)         *
      *                G#SCLR - Cleared Balances Open/Closing (simple)*
      *                G#SCLB - Closing balance (simple)              *
      *                G#SBRK - Item/Value Breakdown (simple)         *
      *****************************************************************
     C     G#SPS1        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'g_SPS1'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     7             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\g_SPS1'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Call subroutine for Opening Balance (simple)
     C                   EXSR      G#SOPB
     C     7             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      **  Call subroutine for Posting Group Set 2 (complex)
     C                   EXSR      G#SPS2
     C     7             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      **  Call subroutine for Cleared Balances Open/Closing (simple)
     C                   EXSR      G#SCLR
     C     7             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      **  Call subroutine for Closing Balance (simple)
     C                   EXSR      G#SCLB
     C     7             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      **  Call subroutine for Item/Val. Breakdown (simple)
     C                   EXSR      G#SBRK
     C     7             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
      *................................................................
      *
     C     EXSPS1        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS                                                     CCG015
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  G#SRC1                                         *
      * Function    :  Debit Rate change group set 1 (complex)        *
      *                                                               *
      * Called by   :  G#STMT - Top level group set                   *
      * Calls       :  G#SRC2 - Debit Rate Change Group Set 2 (simple)*
      *****************************************************************
     C     G#SRC1        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'g_SRC1'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     8             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\g_SRC1'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Initialise the First/Last/Subsequent Flag.
     C                   MOVE      'FR'          ##FSLI
      *
      **  Position the Postings file before the first posting for this
      **  Account, starting on the Last Statement Date, and find the
      **  first record with matching key.
      **  (NOTE: not Account Postings)
     C                   Z-ADD     SDLSTD        ##PSTD
     C     ##ACDK        SETGT     APOSTRAF
     C     ##ACKY        READE     APOSTRAF                               55
      *
      **  For each posting...
     C     *IN55         DOWEQ     *OFF
      *
      **  If the Posting Date is between the Last Statement Date and
      **  the Current Statement Date and is a Debit Change ...
      *
      **  Or if the Posting Date is on the Last Statement Date and the
      **  Last Statement Date matches the Date Account Opened and the
      **  Last Page Number is zero (ie Posting not processed) and is
      **  a Debit Change ...
      *
      **  ... process the posting further.
     C     PSTD          IFGT      SDLSTD
     C     PSTD          ANDLE     BJRDNB
     C     DRCR          ANDEQ     *ZEROS
      *
     C     PSTD          OREQ      SDLSTD
     C     DACO          ANDEQ     SDLSTD
     C     SDLSTP        ANDEQ     *ZEROS
     C     DRCR          ANDEQ     *ZEROS
      *
      **  If the Debit Interest Calculation Type is '00' ...
      *
      **  ... Process Posting Group Set 3 (simple)
     C     DICT          IFEQ      *ZEROS
      *
      **  If data has been formatted but not written, process it.
      **  (Note that this will not execute on first pass through SR and
      **   that data relates to previous record to be extracted read.)
     C     ##RFMT        IFEQ      'Y'
      *
      **  Output the Data.
     C                   EXSR      SRODTA
      *
      **  Set the First/Last/Subsequent Flag for Subsequent runs.
     C                   MOVE      'SU'          ##FSLI
      *
     C                   ENDIF
      *
      **  Increment Bind Levels.
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
     C                   EXSR      G#SRC2
      *
     C     8             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
     C                   ENDIF
     C                   ENDIF
      *
      **  Read next posting for account
     C     ##ACKY        READE     APOSTRAF                               55
      *
     C                   ENDDO
      *
      **  If data has been formatted but not written, process it.
      **  (Note that data relates to previous read.)
     C     ##RFMT        IFEQ      'Y'
      *
      **  The last record has been processed - set the First/Last/Subs
      **  Flag accordingly.
     C                   MOVE      'LA'          DEFSLI
      *
      **  Output the Data.
     C                   EXSR      SRODTA
      *
     C                   ENDIF
      *
      *................................................................
      *
     C     EXSRC1        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS                                                     CCG015
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  G#SCC1                                         *
      * Function    :  Credit Rate change group set 1 (complex)       *
      *                                                               *
      * Called by   :  G#STMT - Top level group set                   *
      * Calls       :  G#SCC2 - Credit Rate Change Grp Set 2 (simple) *
      *****************************************************************
     C     G#SCC1        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'g_SCC1'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     9             OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\g_SCC1'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Initialise the First/Last/Subsequent Flag.
     C                   MOVE      'FR'          ##FSLI
      *
      **  Position the Postings file before the first posting for this
      **  Account, starting on the Last Statement Date, and find the
      **  first record with matching key.
      **  (NOTE: not Account Postings)
     C                   Z-ADD     SDLSTD        ##PSTD
     C     ##ACDK        SETGT     APOSTRAF
     C     ##ACKY        READE     APOSTRAF                               55
      *
      **  For each posting...
     C     *IN55         DOWEQ     *OFF
      *
      **  If the Posting Date is between the Last Statement Date and
      **  the Current Statement Date and is a Credit Change ...
      *
      **  Or if the Posting Date is on the Last Statement Date and the
      **  Last Statement Date matches the Date Account Opened and the
      **  Last Page Number is zero (ie Posting not processed) and is
      **  a Credit Change ...
      *
      **  ... process the posting further.
     C     PSTD          IFGT      SDLSTD
     C     PSTD          ANDLE     BJRDNB
     C     DRCR          ANDEQ     1
      *
     C     PSTD          OREQ      SDLSTD
     C     DACO          ANDEQ     SDLSTD
     C     SDLSTP        ANDEQ     *ZEROS
     C     DRCR          ANDEQ     1
      *
      **  If the Credit Interest Calculation Type is '00' ...
      *
      **  ... Process Posting Group Set 3 (simple)
     C     CICT          IFEQ      *ZEROS
      *
      **  If data has been formatted but not written, process it.
      **  (Note that this will not execute on first pass through SR and
      **   that data relates to previous record to be extracted read.)
     C     ##RFMT        IFEQ      'Y'
      *
      **  Output the Data.
     C                   EXSR      SRODTA
      *
      **  Set the First/Last/Subsequent Flag for Subsequent runs.
     C                   MOVE      'SU'          ##FSLI
      *
     C                   ENDIF
      *
      **  Increment Bind Levels.
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
      *
     C                   EXSR      G#SCC2
      *
     C     9             OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
      *
     C                   ENDIF
     C                   ENDIF
      *
      **  Read next posting for account
     C     ##ACKY        READE     APOSTRAF                               55
      *
     C                   ENDDO
      *
      **  If data has been formatted but not written, process it.
      **  (Note that data relates to previous read.)
     C     ##RFMT        IFEQ      'Y'
      *
      **  The last record has been processed - set the First/Last/Subs
      **  Flag accordingly.
     C                   MOVE      'LA'          DEFSLI
      *
      **  Output the Data.
     C                   EXSR      SRODTA
      *
     C                   ENDIF
      *
      *................................................................
      *
     C     EXSCC1        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS                                                     CCG015
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  G#SFTR                                         *
      * Function    :  Footer (simple)                                *
      *                                                               *
      * Called by   :  G#STMT - Top level group set                   *
      * Calls       :  -                                              *
      *****************************************************************
     C     G#SFTR        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'g_SFTR'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     10            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\g_SFTR'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
     C/COPY WNCPYSRC,CG4510C017
      *
      *................................................................
      *
      ** Extract RDEs for footer
      *******(This*SR*left*intentionally*blank*-*included*for                                 216006
      ********completeness*and*for*future*modification.)****                                  216006
      *                                                                                       216006
      **  Retrieve RDE information for RDEs in group set                                      216006
     C                   MOVEL     'g_SFTR'      ##GRPS                                       216006
     C                   Z-ADD     1             ##RDEN                                       216006
     C                   EXSR      SRRRDE                                                     216006
      *                                                                                       216006
     C*  Check if part of group account hierarchy                                             216006
      *                                                                                       216006
     C     CRE008        IFEQ      'Y'                                                        216006
     C     ##REKY        CHAIN     REGAHLJ2                           80                      216006
     C     *IN80         IFEQ      '1'                                                        216006
     C                   MOVEL     WCMTX1        ##D(1)                                       216006
     C                   MOVEL     WCMTX2        ##D(2)                                       216006
     C                   MOVEL     WCMTX3        ##D(3)                                       216006
     C                   MOVEL     WCMTX4        ##D(4)                                       216006
     C                   ENDIF                                                                216006
     C                   ENDIF                                                                216006
      *                                                                                       216006
      **  Accumulate RDE's and associated data and output to                                  216006
      **  PF/CGUDTAPD.                                                                        216006
     C                   EXSR      SRADTA                                                     216006
     C                   EXSR      SRODTA                                                     216006
      *................................................................
      *
     C     EXSFTR        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS                                                     CCG015
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRNSTD                                         *
      * Function    :  Calculate Next Statement Date                  *
      *                                                               *
      * Called by   :  G#STMT - Top level group set                   *
      * Calls       :  SRERR  - Database Error                        *
      *                CG99FREQ - Frequency Processing                *
      *****************************************************************
     C     SRNSTD        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRNSTD'      @STK(Q)
      *
      *................................................................
      *
      **  If the Statement Frequency is 'E' - Turnover - set up the
      **  data according to whether the extract is for 'Turnover' or
      **  'Normal' mode.
     C                   MOVEL     STFQ          STFQE             1                        BUG24792
      *                                                                                     BUG24792
     C     STFQ          IFEQ      'E'
     C     SDPSTP        IFEQ      C#NORM
     C**********           MOVE 'M'       STFQ                                              MD043394
     C                   MOVE      'L'           STFQ                                       MD043394
     C                   ELSE
     C                   MOVE      'D'           STFQ                                         083782
     C                   Z-ADD     BJRDNB        SDNSTD
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG24792
      * but consider a Multicash-frequency <> E to be used instead of                       BUG24792
      * STFQ on ACCNTAB                                                                     BUG24792
     C     CGL013        IFEQ      'Y'                                                      BUG24792
     C     CER030        ANDEQ     'Y'                                                      AR864876
     C     SDATYP        ANDEQ     'R'                                          Retail acc. BUG24792
     C     STFQE         IFEQ      'E'                                          on ACCNTAB  BUG24792
     C     SDPSTP        ANDEQ     C#NORM                                       NORMAL      BUG24792
     C     ##ACKY        CHAIN     GLNW94L8                           52                    BUG24792
     C     *IN52         IFEQ      *OFF                                                     BUG24792
     C     N40SFR        ANDNE     ' '                                          MC frequencyBUG24792
     C     N40SFR        ANDNE     'E'                                          overrides   BUG24792
      *                                                                                     AR864876
     C                   CALL      'AONWRKR1'                                               AR864876
     C                   PARM      *BLANKS       ##RTCD                                     AR864876
     C                   PARM      '*KEY'        ##OPTN                                     AR864876
     C                   PARM      N4NWRK        PNWRK             6                        AR864876
     C     SDNWRK        PARM                    DSLDY                                      AR864876
     C     ##RTCD        IFEQ      *BLANKS                                                  AR864876
     C     EDMCNW        ANDEQ     'Y'                                                      AR864876
     C                   MOVE      N40SFR        STFQ                           GLNW94L8    BUG24792
     C                   Z-ADD     BJRDNB        SDNSTD                         today       BUG24792
     C                   ENDIF                                                              AR864876
     C                   ENDIF                                                              BUG24792
     C                   ENDIF                                                              BUG24792
     C                   ENDIF                                                              BUG24792
      *
      **  If the Statement Frequency is 'Z' - On Demand - set the
      **  Next Statement Date to zero.
     C     STFQ          IFEQ      'Z'
     C                   Z-ADD     *ZEROS        ##NSTD
      *
      **  If the Statement Frequency is any other value, calculate the
      **  Next Statement Date.
     C                   ELSE
      *
      **  If the Statement Frequency is 'A' - Accrual Profit/End of
      **  Period, set the Next Statement Date to the current value
      **  of the Accrual/Profit Date.
     C     STFQ          IFEQ      'A'
     C                   Z-ADD     BKAPDT        ##NSTD
     C                   MOVEL     BKAPFQ        W0FREQ
     C                   Z-ADD     BKAPFD        W0MDAY
      *
      **  Otherwise initialise the Next Statement Date to the Current
      **  value.
     C                   ELSE
     C                   Z-ADD     SDNSTD        ##NSTD
     C                   MOVEL     STFQ          W0FREQ
     C                   Z-ADD     STDY          W0MDAY
     C/COPY WNCPYSRC,CG4510C078
     C                   ENDIF
      *
      **  Set up static parameters.
     C                   MOVE      BJLCCY        W0CCY
     C                   MOVE      BJSLCD        W0LOC
      *
      **  Keep calculating the Next Statement Date until a value
      **  not less than the Date of Next Working Day is found.
     C     ##NSTD        DOWLT     BJDNWD
     C                   Z-ADD     ##NSTD        W0RDNB
      *
     C                   CALL      'CG99FREQ'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*NEWDATE'    W0ACT             8
     C                   PARM                    W0FREQ           10
     C                   PARM                    W0RDNB            5 0
     C                   PARM                    W0MDAY            2 0
     C                   PARM                    W0CCY             3
     C                   PARM                    W0LOC             3
     C                   PARM                    W0EXT           256
      *
      **  Error in called program.
     C     ##RTCD        IFNE      *BLANK
      *
     C                   MOVEL     'CG99FREQ'    W0FILE                         ***************
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 05 *
     C                   Z-ADD     5             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   Z-ADD     W0RDNB        ##NSTD
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      *................................................................
      *
     C     EXNSTD        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  G#SOPB                                         *
      * Function    :  Opening balance (simple)                       *
      *                                                               *
      * Called by   :  G#SPS1 - Posting group set 1                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRADTA - Format Extract Data                   *
      *                SRODTA - Output Extract Data                   *
      *                SRERR  - Database Error                        *
      *****************************************************************
      *
     C     G#SOPB        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'g_SOPB'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     11            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\g_SOPB'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'g_SOPB'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      ** Access Posting Currency Details                                                      153769
     C                   MOVE      ##CCY         CCYDS                                        153769
     C                   EXSR      SRDCDT                                                     153769
      *
      **  Set up B/Fwd Balance
     C/COPY WNCPYSRC,CG4510C048
     C                   MOVEL     SDCFSB        ##D(1)
     C/COPY WNCPYSRC,CG4510C049
     C                   MOVE      A6NBDP        ##D(1)
      *
      **  Set up B/Fwd Cleared Balance
     C/COPY WNCPYSRC,CG4510C050
     C**********           MOVELSDYTDB    ##D,2                                               230129
     C**********           MOVELSDCFSB    ##D,2                                      230129 MD055869
     C                   MOVEL     SDYTDB        ##D(2)                                     MD055869
     C/COPY WNCPYSRC,CG4510C051
     C                   MOVE      A6NBDP        ##D(2)
      *                                                                                       CEU013
     C     CEU013        IFEQ      'Y'                                                        CEU013
     C     A6INCY        ANDEQ     'Y'                                                        CEU013
     C     BJRDNB        ANDGE     A6TPSD                                                     CEU013
     C     BKEURO        ANDNE     *BLANKS                                                    CEU013
      **  Set up B/Fwd Balance (Euros)                                                        CEU013
     C********** A6EUMD    IFEQ 'D'                                                     CEU014152219
     C********** A6EUER    ANDNE0                                                       CEU014152219
     C********** SDCFSB    DIV  A6EUER    W#EBAL                                        CEU014152219
     C**********           ELSE                                                         CEU014152219
     C********** SDCFSB    MULT A6EUER    W#EBAL                                        CEU013152219
     C**********           ENDIF                                                        CEU014152219
     C**********           MOVELW#EBAL    ##D,3                                         CEU013152219
     C                   Z-ADD     SDCFSB        P@FRAM                                       152219
     C                   MOVE      A6CYCD        P@FRCY                                       152219
     C                   MOVE      BKEURO        P@TOCY                                       152219
     C                   EXSR      R@EURO                                                     152219
     C                   MOVEL     ##OUTA        ##D(3)                                       152219
     C                   MOVEL     ##OUTA        ##D(1)                                       218143
     C                   MOVE      W#NBDP        ##D(3)                                       CEU013
      *                                                                                       CEU013
      **  Set up B/Fwd Cleared Balance (Euros)                                                CEU013
     C********** A6EUMD    IFEQ 'D'                                                     CEU014152219
     C********** A6EUER    ANDNE0                                                       CEU014152219
     C********** SDYTDB    DIV  A6EUER    W#EBAL                                        CEU014152219
     C**********           ELSE                                                         CEU014152219
     C********** SDYTDB    MULT A6EUER    W#EBAL                                        CEU013152219
     C**********           ENDIF                                                        CEU014152219
     C**********           MOVELW#EBAL    ##D,4                                         CEU013152219
     C**********           Z-ADDSDYTDB    P@FRAM                                       152219 230129
     C**********           Z-ADDSDCFSB    P@FRAM                                     230129 MD055869
     C                   Z-ADD     SDYTDB        P@FRAM                                     MD055869
     C                   MOVE      A6CYCD        P@FRCY                                       152219
     C                   MOVE      BKEURO        P@TOCY                                       152219
     C                   EXSR      R@EURO                                                     152219
     C                   MOVEL     ##OUTA        ##D(4)                                       152219
     C                   MOVEL     ##OUTA        ##D(2)                                       218143
     C                   MOVE      W#NBDP        ##D(4)                                       CEU013
     C**********           ENDIF                                                       CEU013 153769
     C                   ELSE                                                                 153769
     C     CEU014        IFEQ      'Y'                                                        153769
     C                   MOVE      *BLANKS       EQCY                                         153769
     C     ##CCY         IFEQ      BKEURO                                                     153769
      *                                                                                       153769
      ** Get Customer Details                                                                 153769
      *                                                                                       153769
     C                   MOVEL     CNUM          ##KEY1                                       153769
     C                   CALL      'AOCUSTR0'                                                 153769
     C                   PARM      *BLANKS       ##RTCD                                       153769
     C                   PARM      '*KEY   '     ##OPTN                                       153769
     C                   PARM                    ##KEY1           10                          153769
     C                   PARM      *BLANKS       ##KYST            7                          153769
     C     SDCUST        PARM      SDCUST        DSSDY                                        153769
      *                                                                                       153769
      ** DATABASE ERROR                                                                       153769
      *                                                                                       153769
     C     ##RTCD        IFNE      *BLANK                                                  AR750273B
     C     ##RTCD        ANDNE     '*CUSCLS'                                               AR7153769
     C     ##RTCD        ANDNE     '*CUSDEL'                                                  153769
     C                   MOVEL     'SDCUSTPD'    W0FILE                                       153769
     C                   MOVEL     CNUM          W0KEY                          **************153769
     C                   Z-ADD     11            W0ERNB                         * DB ERROR 11 153769
     C                   MOVEL     'MEM5004'     W0MSGD                         **************153769
     C                   MOVEL     'MIDAS  '     W0MSGF                                       153769
     C                   EXSR      SRERR                                                      153769
     C                   END                                                                  153769
     C                   MOVE      BBDINC        EQCY                                         153769
     C                   ENDIF                                                                153769
     C     EQCY          IFNE      *BLANKS                                                    153769
      *                                                                                       153769
      ** Access Equivalent Currency Details                                                   153769
     C                   MOVE      EQCY          CCYDS                                        153769
     C                   EXSR      SRDCDT                                                     153769
      *                                                                                       153769
     C                   Z-ADD     SDCFSB        P@FRAM                                       153769
     C                   MOVE      ##CCY         P@FRCY                                       153769
     C                   MOVE      EQCY          P@TOCY                                       153769
     C                   EXSR      R@EURO                                                     153769
     C                   MOVEL     ##OUTA        ##D(3)                                       153769
     C                   MOVE      A6NBDP        ##D(3)                                       153769
      *                                                                                       153769
     C                   Z-ADD     SDYTDB        P@FRAM                                       153769
     C                   MOVE      ##CCY         P@FRCY                                       153769
     C                   MOVE      EQCY          P@TOCY                                       153769
     C                   EXSR      R@EURO                                                     153769
     C                   MOVEL     ##OUTA        ##D(4)                                       153769
     C                   MOVE      A6NBDP        ##D(4)                                       153769
     C                   ENDIF                                                                153769
     C                   ENDIF                                                                153769
     C                   ENDIF                                                                153769
      *                                                                                       153769
     C/COPY WNCPYSRC,CG4510C012
      **  Initialise Account Balance
     C                   Z-ADD     SDCFSB        ##ACBL
      *
      **  Initialise Cleared Balance
     C**********           Z-ADDSDYTDB    ##CLBL                                              230129
     C**********           Z-ADDSDCFSB    ##CLBL                                     230129 MD055869
     C                   Z-ADD     SDYTDB        ##CLBL                                     MD055869
      *
      **  Set up First/Subsequent/Last Indicator
     C                   MOVE      'FR'          ##FSLI
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
      *................................................................
      *
     C     EXSOPB        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS                                                     CCG015
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  G#SPS2                                         *
      * Function    :  Posting group set 2 (complex)                  *
      *                 - Read all postings for a/c and call          *
      *                   appropriate formatting subroutine           *
      *                                                               *
      * Called by   :  G#SPS1 - Posting group set 1                   *
      * Calls       :  G#SPS3 - Posting group set 3 (simple)          *
      *                SRCCLR - Calculate Cleared Amounts             *
      *****************************************************************
     C     G#SPS2        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'g_SPS2'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     12            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\g_SPS2'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Initialise the First/Last/Subsequent Flag.
     C                   MOVE      'FR'          ##FSLI
      *
      **  Find the Posting Date of the First and Last Posting for this
      **  Statement.
     C                   EXSR      SRFLDT
      *
      **  Position the Postings file before the first posting for this
      **  Account, and find the first record with matching key.
      **  (NOTE: not Rate Change Postings)
     C/COPY WNCPYSRC,CG4510C035
     C     ##ACKY        SETLL     APOSTPDF
     C     ##ACKY        READE     APOSTPDF                               55
     C/COPY WNCPYSRC,CG4510C028
      *
      **  For each posting...
     C     *IN55         DOWEQ     *OFF
      *
      **  Calculate Cleared Amounts.
     C                   EXSR      SRCCLR
      *
      **  If the Posting Date is between the Last Statement Date and
      **  the Current Statement Date ...
      *
      **  Or if the Posting Date is on the Last Statement Date and the
      **  Last Statement Date matches the Date Account Opened and the
      **  Last Page Number is zero ...
      *
      **  ... Posting Group Set 3 (simple)
     C     PSTD          IFGT      SDLSTD
     C     PSTD          ANDLE     BJRDNB
      *
     C     PSTD          OREQ      SDLSTD
     C     DACO          ANDEQ     SDLSTD
     C     SDLSTP        ANDEQ     *ZEROS
      *
      **  If data has been formatted but not written, process it.
      **  (Note that this will not execute on first pass through SR and
      **   that data relates to previous record to be extracted read.)
     C     ##RFMT        IFEQ      'Y'
      *
      **  Output the Data.
     C                   EXSR      SRODTA
      *
      **  Set the First/Last/Subsequent Flag for Subsequent runs.
     C                   MOVE      'SU'          ##FSLI
      *
     C                   ENDIF
      *
      **  Increment Bind Levels.
     C                   Z-ADD     ##TBIN        S#PBIN
     C                   ADD       1             ##BNDC
     C                   Z-ADD     ##BNDC        S#TBIN
     C/COPY WNCPYSRC,CG4510C004
      *
     C                   EXSR      G#SPS3
      *
     C     12            OCCUR     ##SRDT
     C                   MOVEL     ##SPAT        S#PATH
     C                   Z-ADD     ##PBIN        S#PBIN
     C                   Z-ADD     ##TBIN        S#TBIN
     C/COPY WNCPYSRC,CG4510C002
     C                   ENDIF
      *
      **  Read next posting for account
     C/COPY WNCPYSRC,CG4510C036
     C     ##ACKY        READE     APOSTPDF                               55
     C/COPY WNCPYSRC,CG4510C029
      *
     C                   ENDDO
      *
      **  If data has been formatted but not written, process it.
      **  (Note that data relates to previous read.)
     C     ##RFMT        IFEQ      'Y'
      *
      **  The last record has been processed - set the First/Last/Subs
      **  Flag accordingly.
     C                   MOVE      'LA'          DEFSLI
      *
      **  Output the Data.
     C                   EXSR      SRODTA
      *
     C                   ENDIF
      *
      *................................................................
      *
     C     EXSPS2        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS                                                     CCG015
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRFLDT                                         *
      * Function    :  First and Last Posting Date                    *
      *                 - Obtain Posting Date of First and Last       *
      *                   Posting for Statement.                      *
      *                                                               *
      * Called by   :  G#SPS2 - Posting group set 2                   *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRFLDT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRFLDT'      @STK(Q)
      *
      *................................................................
      *
      **  Initialise the First and Last Posting Dates to the Run Date
      **  in case no postings are to be output.
     C                   Z-ADD     BJRDNB        ##FPDT
     C                   Z-ADD     BJRDNB        ##LPDT
      *
      **  Position the Postings file before the first posting for this
      **  Account after the Last Statement Date, and find the first
      **  Posting to appear on the Statement.
      **  (NOTE: not Rate Change Postings)
     C                   Z-ADD     SDLSTD        ##PSTD
     C     ##ACDK        SETGT     APOSTPDF
     C     ##ACKY        READE     APOSTPDF                               55
     C/COPY WNCPYSRC,CG4510C030
      *
      **  If a record is found and the Posting will be included ...
      *
      **  ... save Posting Date.
     C     *IN55         IFEQ      *OFF
     C     PSTD          ANDLE     BJRDNB
     C                   Z-ADD     PSTD          ##FPDT
     C                   ENDIF
      *
      **  Position the Postings file after the last posting for this
      **  Account to be included on the Statement and access that
      **  Posting.
      **  (NOTE: not Rate Change Postings)
     C                   Z-ADD     BJRDNB        ##PSTD
     C     ##ACDK        SETGT     APOSTPDF
     C     ##ACKY        READPE    APOSTPDF                               55
     C/COPY WNCPYSRC,CG4510C031
      *
      **  If a record is found and the Posting will be included ...
      *
      **  ... save Posting Date.
     C     *IN55         IFEQ      *OFF
     C     PSTD          ANDGT     SDLSTD
     C                   Z-ADD     PSTD          ##LPDT
     C                   ENDIF
      *
      *................................................................
      *
     C     EXFLDT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRCCLR                                         *
      * Function    :  Calculate Clearing Amounts                     *
      *                 - Find Amounts Clearing Before and After      *
      *                   extracted Posting                           *
      *                                                               *
      * Called by   :  G#SPS2 - Posting group set 2 (Complex)         *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRCCLR        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRCCLR'      @STK(Q)
      *
      *................................................................
      *                                                                                       080131
      **  If the Account is not Retail by-pass Cleared Balance Process.                       080131
     C     SDATYP        IFNE      'R'                                                        080131
     C                   GOTO      EXCCLR                                                     080131
     C                   ENDIF                                                                080131
      *
      **  Find Amounts Clearing before the first posting but since the
      **  Last Statement Date.
      *
      **  If the Posting Date is not after the Last Statement Date and
      **     the Value Date is after the Last Statement Date but before
      **     the first Posting Date ...
     C     PSTD          IFLE      SDLSTD
     C     VALD          ANDGT     SDLSTD
     C     VALD          ANDLT     ##FPDT
      *
      **  ... total the Clearing Amounts.
     C     DRCR          IFEQ      *ZEROS
     C                   ADD       PSTA          ##OCLD
     C                   ELSE
     C                   SUB       PSTA          ##OCLC
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Find Amounts Clearing during the period for which postings
      **  exist.
      *
      **  If the Value Date is between the First Statement Date and the
      **  Last and the Posting is dated before Run Date...
     C     VALD          IFGE      ##FPDT
     C     VALD          ANDLE     ##LPDT
     C     PSTD          ANDLE     BJRDNB
      *
      **  ... total the Clearing Amounts.
     C     DRCR          IFEQ      *ZEROS
     C                   ADD       PSTA          ##DCLD
     C                   ELSE
     C                   SUB       PSTA          ##DCLC
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Find Amounts Clearing after the period for which postings
      **  exist.
      *
      **  If the Value Date is after the Last Posting Date but before
      **     the Run Date, and the value Date is after the Posting Date
     C     VALD          IFGT      ##LPDT
     C     VALD          ANDLE     BJRDNB
     C     VALD          ANDGT     PSTD
      *
      **  ... total the Clearing Amounts.
     C     DRCR          IFEQ      *ZEROS
     C                   ADD       PSTA          ##CCLD
     C                   ELSE
     C                   SUB       PSTA          ##CCLC
     C                   ENDIF
      *
     C                   ENDIF
      *
      *................................................................
      *
     C     EXCCLR        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  G#SCLR                                         *
      * Function    :  Cleared Balances Open/Closing (simple)         *
      *                                                               *
      * Called by   :  G#SPS1 - Posting group set 1                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRADTA - Format Extract Data                   *
      *                SRODTA - Output Extract Data                   *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     G#SCLR        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'g_SCLR'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     13            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\g_SCLR'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'g_SCLR'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Opening Cleared Amount - Credit
     C/COPY WNCPYSRC,CG4510C052
     C                   MOVEL     ##OCLC        ##D(1)
     C/COPY WNCPYSRC,CG4510C053
     C                   MOVE      A6NBDP        ##D(1)
      *
      **  Set up Opening Cleared Amount - Debit
     C/COPY WNCPYSRC,CG4510C054
     C                   MOVEL     ##OCLD        ##D(2)
     C/COPY WNCPYSRC,CG4510C055
     C                   MOVE      A6NBDP        ##D(2)
      *
      **  Set up Cleared Balance Before First Posting
     C********** SDYTDB    ADD  ##OCLC    ##CFCB                                              230129
     C********** SDCFSB    ADD  ##OCLC    ##CFCB                                     230129 MD055869
     C     SDYTDB        ADD       ##OCLC        ##CFCB                                     MD055869
     C                   ADD       ##OCLD        ##CFCB
     C/COPY WNCPYSRC,CG4510C056
     C                   MOVEL     ##CFCB        ##D(3)
     C/COPY WNCPYSRC,CG4510C057
     C                   MOVE      A6NBDP        ##D(3)
      *
      **  Set up Cleared After Balance Last Posting
     C                   ADD       ##DCLC        ##CFCB
     C                   ADD       ##DCLD        ##CFCB
     C/COPY WNCPYSRC,CG4510C058
     C                   MOVEL     ##CFCB        ##D(4)
     C/COPY WNCPYSRC,CG4510C059
     C                   MOVE      A6NBDP        ##D(4)
      *
      **  Set up Closing Cleared Amount - Credit
     C/COPY WNCPYSRC,CG4510C060
     C                   MOVEL     ##CCLC        ##D(5)
     C/COPY WNCPYSRC,CG4510C061
     C                   MOVE      A6NBDP        ##D(5)
      *
      **  Set up Closing Cleared Amount - Debit
     C/COPY WNCPYSRC,CG4510C062
     C                   MOVEL     ##CCLD        ##D(6)
     C/COPY WNCPYSRC,CG4510C063
     C                   MOVE      A6NBDP        ##D(6)
      *
      **  Set up First/Subsequent/Last Indicator
     C                   MOVE      'FR'          ##FSLI
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
      *................................................................
      *
     C     EXSCLR        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS                                                     CCG015
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  G#SCLB                                         *
      * Function    :  Closing balance (simple)                       *
      *                                                               *
      * Called by   :  G#SPS1 - Posting group set 1                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRADTA - Format Extract Data                   *
      *                SRODTA - Output Extract Data                   *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     G#SCLB        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'g_SCLB'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     15            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\g_SCLB'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'g_SCLB'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *                                                                                       153769
      ** Access Posting Currency Details                                                      153769
     C                   MOVE      ##CCY         CCYDS                                        153769
     C                   EXSR      SRDCDT                                                     153769
      *
      **  Set up C/Fwd Balance
     C                   Z-ADD     ##ACBL        ##CFB
     C/COPY WNCPYSRC,CG4510C064
     C                   MOVEL     ##CFB         ##D(1)
     C/COPY WNCPYSRC,CG4510C065
     C                   MOVE      A6NBDP        ##D(1)
      *
      **  Set up C/Fwd Cleared Balance
     C                   ADD       ##CCLC        ##CFCB
     C                   ADD       ##CCLD        ##CFCB
     C/COPY WNCPYSRC,CG4510C066
     C                   MOVEL     ##CFCB        ##D(2)
     C/COPY WNCPYSRC,CG4510C067
     C                   MOVE      A6NBDP        ##D(2)
      *                                                                                       CEU013
      ** If Currency is 'In', Date is within the transition period                            CEU013
      ** and Ccy code for Euro is not blank then set up B/Fwd Balances                        CEU013
      ** (Euros)                                                                              CEU013
     C     CEU013        IFEQ      'Y'                                                        CEU013
     C     A6INCY        ANDEQ     'Y'                                                        CEU013
     C     BJRDNB        ANDGE     A6TPSD                                                     CEU013
     C     BKEURO        ANDNE     *BLANKS                                                    CEU013
      **  Set up B/Fwd Balance (Euros)                                                        CEU013
     C********** A6EUMD    IFEQ 'D'                                                     CEU014152219
     C********** A6EUER    ANDNE0                                                       CEU014152219
     C********** ##CFB     DIV  A6EUER    W#EBAL                                        CEU014152219
     C**********           ELSE                                                         CEU014152219
     C********** ##CFB     MULT A6EUER    W#EBAL                                        CEU013152219
     C**********           ENDIF                                                        CEU014152219
     C**********           MOVELW#EBAL    ##D,3                                         CEU013152219
     C                   Z-ADD     ##CFB         P@FRAM                                       152219
     C                   MOVE      A6CYCD        P@FRCY                                       152219
     C                   MOVE      BKEURO        P@TOCY                                       152219
     C                   EXSR      R@EURO                                                     152219
     C                   MOVEL     ##OUTA        ##D(3)                                       152219
     C                   MOVEL     ##OUTA        ##D(1)                                       218143
     C                   MOVE      W#NBDP        ##D(3)                                       CEU013
      *                                                                                       CEU013
      **  Set up B/Fwd Cleared Balance (Euros)                                                CEU013
     C********** A6EUMD    IFEQ 'D'                                                     CEU014152219
     C********** A6EUER    ANDNE0                                                       CEU014152219
     C********** ##CFCB    DIV  A6EUER    W#EBAL                                        CEU014152219
     C**********           ELSE                                                         CEU014152219
     C********** ##CFCB    MULT A6EUER    W#EBAL                                        CEU013152219
     C**********           ENDIF                                                        CEU014152219
     C**********           MOVELW#EBAL    ##D,4                                         CEU013152219
     C                   Z-ADD     ##CFCB        P@FRAM                                       152219
     C                   MOVE      A6CYCD        P@FRCY                                       152219
     C                   MOVE      BKEURO        P@TOCY                                       152219
     C                   EXSR      R@EURO                                                     152219
     C                   MOVEL     ##OUTA        ##D(4)                                       152219
     C                   MOVEL     ##OUTA        ##D(2)                                       218143
     C                   MOVE      W#NBDP        ##D(4)                                       CEU013
     C**********           ENDIF                                                      CEU013 1537699
      *
     C                   ELSE                                                                 153769
     C     CEU014        IFEQ      'Y'                                                        153769
     C                   MOVE      *BLANKS       EQCY                                         153769
     C     ##CCY         IFEQ      BKEURO                                                     153769
      *                                                                                       153769
      ** Get Customer Details                                                                 153769
      *                                                                                       153769
     C                   MOVEL     CNUM          ##KEY1                                       153769
     C                   CALL      'AOCUSTR0'                                                 153769
     C                   PARM      *BLANKS       ##RTCD                                       153769
     C                   PARM      '*KEY   '     ##OPTN                                       153769
     C                   PARM                    ##KEY1           10                          153769
     C                   PARM      *BLANKS       ##KYST            7                          153769
     C     SDCUST        PARM      SDCUST        DSSDY                                        153769
      *                                                                                       153769
      ** DATABASE ERROR                                                                       153769
      *                                                                                       153769
     C     ##RTCD        IFNE      *BLANK                                                     153769
     C     ##RTCD        ANDNE     '*CUSCLS'                                               AR750273B
     C     ##RTCD        ANDNE     '*CUSDEL'                                               AR750273B
     C                   MOVEL     'SDCUSTPD'    W0FILE                                       153769
     C                   MOVEL     CNUM          W0KEY                          **************153769
     C                   Z-ADD     11            W0ERNB                         * DB ERROR 11 153769
     C                   MOVEL     'MEM5004'     W0MSGD                         **************153769
     C                   MOVEL     'MIDAS  '     W0MSGF                                       153769
     C                   EXSR      SRERR                                                      153769
     C                   END                                                                  153769
     C                   MOVE      BBDINC        EQCY                                         153769
     C                   ENDIF                                                                153769
     C     EQCY          IFNE      *BLANKS                                                    153769
      *                                                                                       153769
      ** Access Equivalent Currency Details                                                   153769
     C                   MOVE      EQCY          CCYDS                                        153769
     C                   EXSR      SRDCDT                                                     153769
      *                                                                                       153769
     C                   Z-ADD     ##CFB         P@FRAM                                       153769
     C                   MOVE      ##CCY         P@FRCY                                       153769
     C                   MOVE      EQCY          P@TOCY                                       153769
     C                   EXSR      R@EURO                                                     153769
     C                   MOVEL     ##OUTA        ##D(3)                                       153769
     C                   MOVE      A6NBDP        ##D(3)                                       153769
      *                                                                                       153769
     C                   Z-ADD     ##CFCB        P@FRAM                                       153769
     C                   MOVE      ##CCY         P@FRCY                                       153769
     C                   MOVE      EQCY          P@TOCY                                       153769
     C                   EXSR      R@EURO                                                     153769
     C                   MOVEL     ##OUTA        ##D(4)                                       153769
     C                   MOVE      A6NBDP        ##D(4)                                       153769
     C                   ENDIF                                                                153769
     C                   ENDIF                                                                153769
     C                   ENDIF                                                                153769
      *                                                                                       153769
     C/COPY WNCPYSRC,CG4510C013
      **  Set up First/Subsequent/Last Indicator
     C                   MOVE      'FR'          ##FSLI
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
      *................................................................
      *
     C     EXSCLB        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS                                                     CCG015
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  G#SBRK                                         *
      * Function    :  Item/Value Breakdown (Simple)                  *
      *                                                               *
      * Called by   :  G#SPS1 - Posting group set 1                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRADTA - Format Extract Data                   *
      *                SRODTA - Output Extract Data                   *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     G#SBRK        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'g_SBRK'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     15            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\g_SBRK'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'g_SBRK'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Number of Entries - Credit
     C                   MOVEL     ##NOEC        ##D(1)
     C                   MOVE      '0'           ##D(1)
      *
      **  Set up Value of Entries - Credit
     C/COPY WNCPYSRC,CG4510C068
     C                   MOVEL     ##VAEC        ##D(2)
     C/COPY WNCPYSRC,CG4510C069
     C                   MOVE      A6NBDP        ##D(2)
      *
      **  Set up Number of Entries - Debit
     C                   MOVEL     ##NOED        ##D(3)
     C                   MOVE      '0'           ##D(3)
      *
      **  Set up Value of Entries - Debit
     C/COPY WNCPYSRC,CG4510C070
     C                   MOVEL     ##VAED        ##D(4)
     C/COPY WNCPYSRC,CG4510C071
     C                   MOVE      A6NBDP        ##D(4)
      *
      **  Set up First/Subsequent/Last Indicator
     C                   MOVE      'FR'          ##FSLI
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
     C                   EXSR      SRODTA
      *
      *................................................................
      *
     C     EXSBRK        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS                                                     CCG015
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  G#SRC2                                         *
      * Function    :  Debit Rate change group set 2 (simple)         *
      *                                                               *
      * Called by   :  G#SRC1 - Debit Rate change group set 1         *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRADTA - Format Extract Data                   *
      *                SRODTA - Output Extract Data                   *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     G#SRC2        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'g_SRC2'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     16            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\g_SRC2'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'g_SRC2'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Posting Date
     C                   MOVEL     PSTD          ##D(1)
      *
      **  Set up Value Date
     C                   MOVEL     VALD          ##D(2)
      *
      **  Set up Rate Change - Rate
     C                   MOVEL     INRT          ##D(3)
      *
      **  Set up Debit/Credit Flag
     C                   MOVEL     'D'           ##D(4)
      *                                                                                       CRE073
      ** Set up Debit Interest Rate Rounding                                                  CRE073
      *                                                                                       CRE073
     C     CRE073        IFEQ      'Y'                                                        CRE073
      *                                                                                       CRE073
      ** Set up Debit Contractual Spread                                                      CRE073
      *                                                                                       CRE073
     C                   MOVEL     DCSP          ##D(5)                                       CRE073
      *                                                                                       CRE073
      ** Set up Debit Contractual Spread Sign                                                 CRE073
      *                                                                                       CRE073
     C                   MOVEL     DCSG          ##D(6)                                       CRE073
      *                                                                                       CRE073
      ** Set up Debit Rounding Method                                                         CRE073
      *                                                                                       CRE073
     C                   MOVEL     DRMT          ##D(7)                                       CRE073
      *                                                                                       CRE073
      ** Set up Debit Rounding Fraction/Decimal                                               CRE073
      *                                                                                       CRE073
     C                   MOVEL     DRFD          ##D(8)                                       CRE073
      *                                                                                       CRE073
     C                   ENDIF                                                                CRE073
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
      *
      *................................................................
      *
     C     EXSRC2        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS                                                     CCG015
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  G#SCC2                                         *
      * Function    :  Credit Rate change group set 2 (simple)        *
      *                                                               *
      * Called by   :  G#SRC1 - Credit Rate change group set 1        *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRADTA - Format Extract Data                   *
      *                SRODTA - Output Extract Data                   *
      *                SRERR  - Database Error                        *
      *****************************************************************
     C     G#SCC2        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'g_SCC2'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     17            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\g_SCC2'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'g_SCC2'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
      **  Set up Posting Date
     C                   MOVEL     PSTD          ##D(1)
      *
      **  Set up Value Date
     C                   MOVEL     VALD          ##D(2)
      *
      **  Set up Rate Change - Rate
     C                   MOVEL     INRT          ##D(3)
      *
      **  Set up Debit/Credit Flag
     C                   MOVEL     'C'           ##D(4)
      *                                                                                       CRE073
      ** Set up Credit Interest Rate Rounding                                                 CRE073
      *                                                                                       CRE073
     C     CRE073        IFEQ      'Y'                                                        CRE073
      *                                                                                       CRE073
      ** Set up Debit Contractual Spread                                                      CRE073
      *                                                                                       CRE073
     C                   MOVEL     CCSP          ##D(5)                                       CRE073
      *                                                                                       CRE073
      ** Set up Debit Contractual Spread Sign                                                 CRE073
      *                                                                                       CRE073
     C                   MOVEL     CCSG          ##D(6)                                       CRE073
      *                                                                                       CRE073
      ** Set up Debit Rounding Method                                                         CRE073
      *                                                                                       CRE073
     C                   MOVEL     CRMT          ##D(7)                                       CRE073
      *                                                                                       CRE073
      ** Set up Debit Rounding Fraction/Decimal                                               CRE073
      *                                                                                       CRE073
     C                   MOVEL     CRFD          ##D(8)                                       CRE073
      *                                                                                       CRE073
     C                   ENDIF                                                                CRE073
      *
      **  Accumulate RDE's and associated data and output to
      **  PF/CGUDTAPD.
     C                   EXSR      SRADTA
      *
      *................................................................
      *
     C     EXSCC2        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS                                                     CCG015
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  G#SPS3                                         *
      * Function    :  Posting group set 3 (simple)                   *
      *                                                               *
      * Called by   :  G#SPS2 - Posting group set 2                   *
      * Calls       :  SRRRDE - Retrieve RDE Information              *
      *                SRADTA - Format Extract Data                   *
      *                SRODTA - Output Extract Data                   *
      *                SRERR  - Database Error                        *
      *****************************************************************
      *
     C     G#SPS3        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'g_SPS3'      @STK(Q)
      *
      **  Retrieve subroutine specific data.
     C     18            OCCUR     ##SRDT
      *
      **  Set up Path.
     C                   MOVEL     '\g_SPS3'     ##PNAM
     C     S#PATH        CAT       ##PNAM:0      S#PATH
     C                   EXSR      PSHGRS                                                     CCG015
     C                   MOVEL     S#PATH        ##SPAT
      *
      **  Set up Binds from passed in values.
     C                   Z-ADD     S#PBIN        ##PBIN
     C                   Z-ADD     S#TBIN        ##TBIN
      *
      *................................................................
      *
      **  Retrieve RDE information for RDE's in Group Set
     C                   MOVEL     'g_SPS3'      ##GRPS
     C                   Z-ADD     1             ##RDEN
     C                   EXSR      SRRRDE
      *
     C/COPY WNCPYSRC,CG4510C010
      **  Update Account Ledger balance for Posting
     C     DRCR          IFEQ      *ZEROS
     C                   ADD       PSTA          ##ACBL
     C                   ELSE
     C                   SUB       PSTA          ##ACBL
     C                   ENDIF
      *
      **  Update Item/Value Breakdown figures for Posting
     C     DRCR          IFEQ      *ZEROS
     C                   ADD       1             ##NOED
     C                   ADD       PSTA          ##VAED
     C                   ELSE
     C                   ADD       1             ##NOEC
     C                   SUB       PSTA          ##VAEC
     C                   ENDIF
     C/COPY WNCPYSRC,CG4510C011
      *
      ** Access Posting Currency Details                                                      153769
     C                   MOVE      ##CCY         CCYDS                                        153769
     C                   EXSR      SRDCDT                                                     153769
      *                                                                                       153769
      **  Set up Posting Date
     C                   MOVEL     PSTD          ##D(1)
      *
      **  Set up Value Date
     C                   MOVEL     VALD          ##D(2)
     C/COPY WNCPYSRC,CG4510C018
      *
      **  Set up Cheque Number
     C     CHQN          IFNE      *ZEROS
     C                   MOVEL     CHQN          ##D(3)
     C                   ENDIF
      *
      **  Set up Posting Narrative
     C/COPY WNCPYSRC,CG4510C019
     C                   MOVEL     PNAR          ##D(4)
     C/COPY WNCPYSRC,CG4510C020
      *
      **  Set up Posting Amount
     C     DRCR          IFNE      *ZEROS
     C                   Z-SUB     PSTA          PSTA
     C                   ENDIF
     C                   Z-ADD     PSTA          PSTAX                                        173553
      *
     C/COPY WNCPYSRC,CG4510C072
     C                   MOVEL     PSTA          ##D(5)
     C/COPY WNCPYSRC,CG4510C073
     C                   MOVE      A6NBDP        ##D(5)
      *
      **  Set up Posting - Generation Type
     C                   MOVEL     GETP          ##D(6)
      *
      **  Set up Posting - Module ...
      **  ... use the Generation Type to retrieve the Module ID.
     C                   Z-ADD     1             G                 3 0
     C     GETP          LOOKUP    ##GE(G)                                60
     C     *IN60         IFEQ      *OFF
     C                   MOVEL     '  '          ##D(7)
     C                   ELSE
     C                   MOVEL     ##MD(G)       ##D(7)
     C                   ENDIF
      *
      **  Set up Posting transaction Number ...
      **  ...If the Module is Dealing or Lending obtain the Transaction
      **     Number from DLREF.
     C     ##MD(G)       IFEQ      'DL'
     C     *IN60         ANDEQ     *ON
     C     ##MD(G)       OREQ      'LE'
     C     *IN60         ANDEQ     *ON
     C                   MOVEL     ##TREF        ##D(8)
     C                   ENDIF
      *
      **  ... If the Module is Funds Transfer obtain the Transaction
      **      Number from PREF.
     C     ##MD(G)       IFEQ      'FT'
     C     *IN60         ANDEQ     *ON
     C                   MOVEL     PREF          ##D(8)
     C                   ENDIF
      *                                                                                       167545
      **  ... If the Module is Securities obtain the Transaction                              167545
      **      Number from OTRF.                                                               167545
      *                                                                                       167545
     C     ##MD(G)       IFEQ      'SE'                                                       167545
     C     *IN60         ANDEQ     *ON                                                        167545
     C                   MOVEL     OTRF          ##D(8)                                       167545
     C                   ENDIF                                                                167545
      *
      **  ... If the Module is General Ledger obtain the Transaction                          CAP204
      **      Number from OTRF.                                                               CAP204
      *                                                                                       CAP204
     C     ##MD(G)       IFEQ      'GL'                                                       CAP204
     C     GETP          ANDEQ     'L'                                                        CAP204
     C     CAP204        ANDEQ     'Y'                                                        CAP204
     C     *IN60         ANDEQ     *ON                                                        CAP204
     C                   MOVEL     OTRF          ##D(8)                                       CAP204
     C                   ENDIF                                                                CAP204
      *                                                                                       CAP204
      **  Set up Posting - Batch Number and Batch Item Number ...
      **  ... If Generated Entry Type blank, Posting relates to a Batch
     C     GETP          IFEQ      *BLANK
     C                   MOVEL     ##BANO        ##D(9)
     C                   MOVEL     ##BITM        ##D(10)
     C                   ENDIF
      *
      **  Set up Account Balance
     C/COPY WNCPYSRC,CG4510C074
     C                   MOVEL     ##ACBL        ##D(11)
     C/COPY WNCPYSRC,CG4510C075
     C                   MOVE      A6NBDP        ##D(11)
      *                                                                                       CEU013
     C/COPY WNCPYSRC,CG4510C026
     C     CEU013        IFEQ      'Y'                                                        CEU013
      **  Access the Account Postins Extension file. If a record is found                     CEU013
      **  set up elements 12 and 13 of group set g_SPS3.                                      CEU013
     C     ##POST        CHAIN     GLAPSTPF                           52                      CEU013
      *                                                                                       CEU013
     C     *IN52         IFEQ      '0'                                                        CEU013
     C                   MOVEL     OCCY          ##D(12)                                      CEU013
      *reverse sign for credit                                                                173553
     C     DRCR          IFNE      *ZEROS                                                     173553
     C                   Z-SUB     OAMT          OAMT                                         173553
     C                   ENDIF                                                                173553
     C                   MOVEL     OAMT          ##D(13)                                      CEU013
     C                   MOVEL     OAMT          ##D(13)                                      CEU013
      *                                                                                       CEU013
      ***Retrieve*Original*Currency*Details                                            CEU013 153769
     C**********           CALL 'AOCURRR0'                                             CEU013 153769
     C**********           PARM *BLANKS   ##RTCD           B:Return Cd                 CEU013 153769
     C**********           PARM '*KEY'    ##OPTN           I:Option                    CEU013 153769
     C**********           PARM OCCY      ##CCYP           I:Currency Code             CEU013 153769
     C********** SDCURR    PARM *BLANK    DSSDY            O:Format                    CEU013 153769
      **********                                                                       CEU013 153769
      ****Database*Error                                                               CEU013 153769
     C********** ##RTCD    IFNE *BLANK                                                 CEU013 153769
     C**********           MOVEL'SDCURRPD'W0FILE                                       CEU013 153769
     C**********           MOVELOCCY      W0KEY            ***************             CEU013 153769
     C**********           Z-ADD14        W0ERNB           * DB ERROR 14 *             CEU013 153769
     C**********           MOVEL'MEM5004' W0MSGD           ***************             CEU013 153769
     C**********           MOVEL'MIDAS  ' W0MSGF                                       CEU013 153769
     C**********           EXSR SRERR                                                  CEU013 153769
     C**********           ENDIF                                                       CEU013 153769
      ** Access Original Currency Details                                                     153769
     C                   MOVE      OCCY          CCYDS                                        153769
     C                   EXSR      SRDCDT                                                     153769
     C/COPY WNCPYSRC,CG4510C076
      *                                                                                       153769
     C                   MOVE      A6NBDP        ##D(13)                                      CEU013
      *                                                                                       CEU013
      **  Access Posting Currency Details                                                     153769
     C                   MOVE      ##CCY         CCYDS                                        153769
     C                   EXSR      SRDCDT                                                     153769
      *                                                                                       153769
      ***Retrieve*Posting*Currency*Details                                             CEU013 153769
     C**********           CALL 'AOCURRR0'                                             CEU013 153769
     C**********           PARM *BLANKS   ##RTCD           B:Return Cd                 CEU013 153769
     C**********           PARM '*KEY'    ##OPTN           I:Option                    CEU013 153769
     C**********           PARM ##CCY     ##CCYP           I:Currency Code             CEU013 153769
     C********** SDCURR    PARM *BLANK    DSSDY            O:Format                    CEU013 153769
      **********                                                                       CEU013 153769
      ****Database*Error                                                               CEU013 153769
     C********** ##RTCD    IFNE *BLANK                                                 CEU013 153769
     C**********           MOVEL'SDCURRPD'W0FILE                                       CEU013 153769
     C**********           MOVEL##CCY     W0KEY            ***************             CEU013 153769
     C**********           Z-ADD15        W0ERNB           * DB ERROR 15 *             CEU013 153769
     C**********           MOVEL'MEM5004' W0MSGD           ***************             CEU013 153769
     C**********           MOVEL'MIDAS  ' W0MSGF                                       CEU013 153769
     C**********           EXSR SRERR                                                  CEU013 153769
     C**********           ENDIF                                                       CEU013 153769
      **********                                                                       CEU013 153769
     C                   ENDIF                                                                CEU013
     C                   ENDIF                                                                CEU013
      *                                                                                       CEU013
     C/COPY WNCPYSRC,CG4510C037
     C     CEU014        IFEQ      'Y'                                                        CEU013
      *                                                                                       153769
      **  Access Posting Currency Details                                                     153769
     C                   MOVE      ##CCY         CCYDS                                        153769
     C                   EXSR      SRDCDT                                                     153769
      *                                                                                       153769
     C                   MOVE      *BLANKS       EQCY                                         CEU014
     C     A6INCY        IFEQ      'Y'                                                        CEU014
     C                   MOVE      BKEURO        EQCY                                         CEU014
     C                   ENDIF                                                                CEU014
     C     ##CCY         IFEQ      BKEURO                                                     CEU014
      *                                                                                       CEU014
      ** Get Customer Details                                                                 CEU014
      *                                                                                       CEU014
     C                   MOVEL     CNUM          ##KEY1                                       CEU014
     C                   CALL      'AOCUSTR0'                                                 CEU014
     C                   PARM      *BLANKS       ##RTCD                                       CEU014
     C                   PARM      '*KEY   '     ##OPTN                                       CEU014
     C                   PARM                    ##KEY1           10                          CEU014
     C                   PARM      *BLANKS       ##KYST            7                          CEU014
     C     SDCUST        PARM      SDCUST        DSSDY                                        CEU014
      *                                                                                       CEU014
      ** DATABASE ERROR                                                                       CEU014
      *                                                                                       CEU014
     C     ##RTCD        IFNE      *BLANK                                                     CEU014
     C     ##RTCD        ANDNE     '*CUSCLS'                                               AR750273B
     C     ##RTCD        ANDNE     '*CUSDEL'                                               AR750273B
     C                   MOVEL     'SDCUSTPD'    W0FILE                                       CEU014
     C                   MOVEL     CNUM          W0KEY                          **************CEU014
     C                   Z-ADD     11            W0ERNB                         * DB ERROR 11 CEU014
     C                   MOVEL     'MEM5004'     W0MSGD                         **************CEU014
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CEU014
     C                   EXSR      SRERR                                                      CEU014
     C                   END                                                                  CEU014
     C                   MOVE      BBDINC        EQCY                                         CEU014
     C                   ENDIF                                                                CEU014
     C     EQCY          IFNE      *BLANKS                                                    CEU014
      *                                                                                       CEU014
      ***Retrieve*Equivalent*Currency*Details                                          CEU014 153769
     C**********           CALL 'AOCURRR0'                                             CEU014 153769
     C**********           PARM *BLANKS   ##RTCD           B:Return Cd                 CEU014 153769
     C**********           PARM '*KEY'    ##OPTN           I:Option                    CEU014 153769
     C**********           PARM EQCY      ##CCYP           I:Currency Code             CEU014 153769
     C********** SDCURR    PARM *BLANK    DSSDY            O:Format                    CEU014 153769
      **********                                                                       CEU014 153769
      **  Database Error                                                               CEU014 153769
     C*********  ##RTCD    IFNE *BLANK                                                 CEU014 153769
     C*********            MOVEL'SDCURRPD'W0FILE                                       CEU014 153769
     C*********            MOVELEQCY      W0KEY            ***************             CEU014 153769
     C*********            Z-ADD16        W0ERNB           * DB ERROR 16 *             CEU014 153769
     C*********            MOVEL'MEM5004' W0MSGD           ***************             CEU014 153769
     C*********            MOVEL'MIDAS  ' W0MSGF                                       CEU014 153769
     C*********            EXSR SRERR                                                  CEU014 153769
     C*********            ENDIF                                                       CEU014 153769
      *                                                                                       CEU014
      *                                                                                       153769
      **  Access Equivalent Currency Details                                                  153769
     C                   MOVE      EQCY          CCYDS                                        153769
     C                   EXSR      SRDCDT                                                     153769
      *                                                                                       153769
      **  Convert posting amt.into eq.ccy only if this information is not                     153543
      **  already available as original ccy.In that case,it can be                            153543
      **  retrieved from file GLAPSTP.                                                        153543
     C                   MOVEL     *BLANKS       ##D(14)                                      153543
     C     EQCY          IFEQ      OCCY                                                       153543
     C     OAMT          ANDNE     0                                                          153543
     C     CEU013        ANDEQ     'Y'                                                        153543
     C     ##POST        CHAIN     GLAPSTPF                           52                      153543
     C     *IN52         IFEQ      '0'                                                        153543
      *                                                                                       173553
      **  Reverse sign for credit                                                             173553
     C     DRCR          IFNE      *ZEROS                                                     173553
     C                   Z-SUB     OAMT          OAMT                                         173553
     C                   ENDIF                                                                173553
      *                                                                                       153543
     C                   MOVEL     OAMT          ##D(14)                        ORIG.CCY AMNT 153543
     C                   MOVE      A6NBDP        ##D(14)                                      153543
     C                   ENDIF                                                  *IN52         153543
     C                   ENDIF                                                  EQCY...       173553
      *                                                                                       173553
      **  RDE POST_EQCY is still empty, then convert posting amount                           173553
     C     ##D(14)       IFEQ      *BLANKS                                                    173553
     C**********           Z-ADDPSTA      P@FRAM                                       CEU014 173553
     C                   Z-ADD     PSTAX         P@FRAM                                       173553
     C                   MOVE      ##CCY         P@FRCY                                       CEU014
     C                   MOVE      EQCY          P@TOCY                                       CEU014
     C                   EXSR      R@EURO                                                     CEU014
     C                   MOVEL     ##OUTA        ##D(14)                                      CEU014
     C                   MOVE      A6NBDP        ##D(14)                                      CEU014
     C                   ENDIF                                                                173553
     C*
     C                   MOVEL     EQCY          ##D(15)                                      CEU014
     C                   MOVEL     A6CYNM        ##D(16)                                      CEU014
     C                   ENDIF                                                                CEU014
      *                                                                                       CEU014
      ***Retrieve*Posting*Currency*Details                                             CEU014 153769
     C**********           CALL 'AOCURRR0'                                             CEU014 153769
     C**********           PARM *BLANKS   ##RTCD           B:Return Cd                 CEU014 153769
     C**********           PARM '*KEY'    ##OPTN           I:Option                    CEU014 153769
     C**********           PARM ##CCY     ##CCYP           I:Currency Code             CEU014 153769
     C********** SDCURR    PARM *BLANK    DSSDY            O:Format                    CEU014 153769
      **********                                                                       CEU014 153769
      ****Database*Error                                                               CEU014 153769
     C********** ##RTCD    IFNE *BLANK                                                 CEU014 153769
     C**********           MOVEL'SDCURRPD'W0FILE                                       CEU014 153769
     C**********           MOVEL##CCY     W0KEY            ***************             CEU014 153769
     C**********           Z-ADD17        W0ERNB           * DB ERROR 15 *             CEU014 153769
     C**********           MOVEL'MEM5004' W0MSGD           ***************             CEU014 153769
     C**********           MOVEL'MIDAS  ' W0MSGF                                       CEU014 153769
     C**********           EXSR SRERR                                                  CEU014 153769
     C**********           ENDIF                                                       CEU014 153769
      **  Access Posting Currency Details                                                     153769
     C                   MOVE      ##CCY         CCYDS                                        153769
     C                   EXSR      SRDCDT                                                     153769
      *                                                                                       CEU014
     C                   ENDIF                                                                CEU014
     C*                                                                                       CEU014
     C*  Extract Originating Account if posting is GA replicated                              216937
     C     CRE008        IFEQ      'Y'                                                        216937
     C     XRFI          IFNE      *BLANKS                                                    216937
     C     XRFN          ANDNE     *ZERO                                                      216937
     C     ##POST        CHAIN     GLAPSGL0                           80                      216937
     C     *IN80         IFEQ      '0'                                                        216937
     C     AGSRNO        IFGT      0                                                          216937
     C                   MOVEL     SRCRET        ##D(17)                                      216937
     C                   ELSE                                                                 216937
     C                   MOVEL     SRCGL         ##D(17)                                      216937
     C                   ENDIF                                                                216937
     C                   ENDIF                                                                216937
     C                   ENDIF                                                                216937
     C                   ENDIF                                                                216937
     C*                                                                                       216937
      **  Accumulate RDE's and associated data and output to                               BUG23277A
      **  PF/CGUDTAPD.                                                                     BUG23277A
     C                   EXSR      SRADTA                                                  BUG23277A
      *
     C     CER031        IFEQ      'Y'                                                      BUG23277
     C     CER030        OREQ      'Y'                                                      BUG24460
     C                   EXSR      PSNARR                                                   BUG23277
     C/COPY WNCPYSRC,CGH00011
     C     18            OCCUR     ##SRDT                                                   BUG23277
     C                   MOVEL     ##SPAT        S#PATH                                     BUG23277
     C                   MOVEL     ##PBIN        S#PBIN                                     BUG23277
     C                   MOVEL     ##TBIN        S#TBIN                                     BUG23277
     C                   ENDIF                                                              BUG23277
      *                                                                                     BUG23277
     C/COPY WNCPYSRC,CG4510C005
      **********                                                                           BUG23277A
      ****Accumulate RDE's and associated data and output to                               BUG23277A
      ****PF/CGUDTAPD.                                                                     BUG23277A
     C**********           EXSR SRADTA                                                     BUG23277A
      **********                                                                           BUG23277A
     C/COPY WNCPYSRC,CGH00001
      *................................................................
      *
     C     EXSPS3        TAG
      *
      **  Unwind subroutine stack name
     C                   EXSR      POPGRS                                                     CCG015
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************                       CEU014
      * Subroutine  :  R@EURO                                         *                       CEU014
      * Function    :  EURO Currency Conversion:                      *                       CEU014
      *                Converts P@FRAM in P@FRCY to ##OUTA in P@TOCY  *                       CEU014
      * Called by   :  G#SPS3                                         *                       CEU014
      *                                                               *                       CEU014
      * Calls       :  EU0200                                         *                       CEU014
      *                SRERR                                          *                       CEU014
      *****************************************************************                       CEU014
     C     R@EURO        BEGSR                                                                CEU014
      *                                                                                       CEU014
     C                   Z-ADD     0             ##OUTA           13 0                        CEU014
     C                   CALL      'EU0200'                                                   CEU014
     C                   PARM      *BLANKS       P@RTCD            7            Return Code   CEU014
     C                   PARM                    P@FRAM           18 3          FROM Ccy Amou CEU014
     C                   PARM                    P@FRCY            3            FROM Currency CEU014
     C                   PARM                    P@TOCY            3            TO Currency   CEU014
     C                   PARM                    P@OUTA           15 0          Outright Amou CEU014
     C                   PARM                    P@INTA           18 3          Interim Amoun CEU014
     C                   PARM                    P@EXRT           15 9          Exchange Rate CEU014
     C                   PARM                    P@MDIN            1            Mult/Div Ind. CEU014
      *                                                                                       CEU014
      ** Database error handling:                                                             CEU014
      *                                                                                       CEU014
     C     P@RTCD        IFEQ      '*ERROR*'                                                  CEU014
     C                   MOVEL     'EU0200  '    W0FILE                                       CEU014
     C                   MOVEL     '*CALL   '    W0KEY                          **************CEU014
     C                   Z-ADD     12            W0ERNB                         * DB ERROR 12 CEU014
     C                   MOVEL     'MEM5003'     W0MSGD                         **************CEU014
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CEU014
     C                   EXSR      SRERR                                                      CEU014
      *                                                                                       CEU014
      ** Otherwise, store amount in settlement currency as ##OUTA                             CEU014
      *                                                                                       CEU014
     C                   ELSE                                                                 CEU014
     C                   MOVE      P@OUTA        ##OUTA                                       CEU014
     C                   ENDIF                                                                CEU014
      *                                                                                       CEU014
     C                   ENDSR                                                                CEU014
      *****************************************************************                       CEU014
     C/EJECT                                                                                  CEU014
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
      **  Generate reference number and check if further processing
      **  required. Set up all available information in the record
      **  format before calling.
      *
     C                   MOVEL     SDBRCA        DRBRCA
     C                   MOVEL     SDBRCA        DRORBR
     C                   MOVEL     'GL'          DRMODI
     C                   CLEAR                   DRMTRN
     C******************** MOVEL##ACID    DRMACT                                              079997
     C                   MOVEL     ##ACI2        DRMACT                                       079997
     C                   MOVE      ##BRCA        DRMACT                                       079997
     C                   MOVEL     SDPTYP        DRPTYP
     C                   MOVEL     SDPSTP        DRPSTP
     C                   MOVEL     'N'           DRATRM
     C/COPY WNCPYSRC,CG4510C023
      *
     C                   CALL      'CG9010'
     C                   PARM                    ##RTCD            7
     C                   PARM      '*GEN'        ##MODE           10
     C                   PARM      W0CMT         ##CMT             3
     C                   PARM      ##CNMA        ##CUST            6
     C                   PARM                    ##UDCR
     C                   PARM                    ##ITMA            8
      *
      **  Blank return code implies generate correspondence.
      **  CGD1270 => no error, but suppress output for this transaction.
      *
     C     ##RTCD        IFNE      *BLANK
      *
     C     ##RTCD        IFEQ      'CGD1270'
     C                   MOVE      'N'           ##PROC
     C                   ELSE
      *
     C                   MOVEL     'CG9010  '    W0FILE
     C                   MOVEL     ##RTCD        W0KEY                          ***************
     C                   Z-ADD     6             W0ERNB                         * DB ERROR 06 *
     C                   MOVEL     'CGD1286'     W0MSGD                         ***************
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ELSE                                                                 CCG015
      *                                                                                       CCG015
      ** If CCG015 is on, wrap the extraction                                                 CCG015
      *                                                                                       CCG015
      ** Pass reference as printtype:subtype                                                  CCG015
      *                                                                                       CCG015
     C     DRPTYP        CAT(P)    ':':0         COLON            11                          CCG015
     C     COLON         CAT(P)    DRPSTP:0      ##REFR                                       CCG015
     C                   EXSR      WRAPRF                                                     CCG015
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
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRRRDE                                         *
      * Function    :  Retrieve RDE information for RDEs in group set *
      *                                                               *
      * Called by   :  simple group set subroutines                   *
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
     C/COPY WNCPYSRC,CG4510C038
     C     #1            OREQ      20
     C/COPY WNCPYSRC,CG4510C039
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
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRADTA                                         *
      * Function    :  Accumulate RDEs and associated data for output *
      *                                                               *
      * Called by   :  simple group set subroutines                   *
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
      *                                                                                       CCG015
     C     CCG015        IFEQ      'Y'                                                        CCG015
     C                   MOVE      '*NEWARR '    W0ACT                                        CCG015
     C                   MOVEL     S#PATH        W0SPAT                                       CCG015
     C                   ELSE                                                                 CCG015
     C                   MOVE      '*PACK   '    W0ACT                                        CCG015
     C                   MOVEL     *BLANKS       W0SPAT                                       CCG015
     C                   ENDIF                                                                CCG015
      *                                                                                       CCG015
     C/COPY WNCPYSRC,CG4510C040
     C                   CALL      'CG3999'
     C/COPY WNCPYSRC,CG4510C041
     C                   PARM      *BLANK        ##RTCD
     C*********************PARM '*PACK   'W0ACT                                               CCG015
     C                   PARM                    W0ACT                                        CCG015
     C                   PARM                    ##R                                          CCG015
     C                   PARM                    ##D                                          CCG015
     C                   PARM                    ##S                                          CCG015
     C                   PARM                    W0SPAT           70                          CCG015
     C                   PARM                    ##RN                                         CCG015
     C                   PARM                    ##DN                                         CCG015
     C                   PARM                    ##FM                                         CCG015
      *
      **  Database error
     C     ##RTCD        IFNE      *BLANK
      *
     C                   MOVEL     'CG3999  '    W0FILE                         ***************
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 07 *
     C                   Z-ADD     7             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CCG015
      ** Write a XML record for RDE                                                           CCG015
      *                                                                                       CCG015
     C                   EXSR      WRTRDE                                                     CCG015
      *
      **  Initialise Write Format Parameter.
     C                   CLEAR                   W0FMT
      *
      **  Set up Control Information.
     C                   Z-ADD     ##ITEM        DEITEM
     C                   ADD       1             ##OSEQ
     C                   Z-ADD     ##OSEQ        DEOSEQ
     C                   Z-ADD     ##PBIN        DEPBIN
     C                   Z-ADD     ##TBIN        DETBIN
     C                   MOVE      ##FSLI        DEFSLI
     C                   MOVE      *BLANKS       W0PATH
     C                   MOVEL     S#PATH        W0PATH
      *
      **  Append Data from pack routine.
     C     W0FMT         CAT       ##SDS:0       W0FMT
      *
      **  Set Flag to show record formatted
     C                   MOVE      'Y'           ##RFMT            1
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
     C/COPY WNCPYSRC,CG4510C042
     C     #1            DOUEQ     20
     C/COPY WNCPYSRC,CG4510C043
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
     C/COPY WNCPYSRC,CG4510C044
     C                   Z-ADD     20            #3
     C/COPY WNCPYSRC,CG4510C045
     C                   Z-ADD     0             ##WNUM
     C/COPY WNCPYSRC,CG4510C046
     C     #2            DOWGT     1
     C     #2            ANDLE     20
     C     #3            ANDGT     1
     C/COPY WNCPYSRC,CG4510C047
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
      * Called by   :  simple group set subroutines                   *
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
      **  Output PF/CGUDTAPD Record.
      **  ONLY IF CCG015 IS OFF                                                               CCG015
     C     CCG015        IFEQ      'N'                                                        CCG015
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
     C                   MOVEL     'CG9020  '    W0FILE                         ***************
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 08 *
     C                   Z-ADD     8             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF                                                                CCG015
      *
      **  Reset Flag to show formatted data output.
     C                   MOVE      *BLANKS       ##RFMT
      *
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
     C********** ##CCY     LOKUP##CY,C                   99                                   153769
     C     CCYDS         LOOKUP    ##CY(C)                                99                  153769
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
     C*********            MOVE ##CCY     ##CY,C                                              153769
     C                   MOVE      CCYDS         ##CY(C)                                      153769
     C     C             OCCUR     SDCURR
     C                   ENDIF
      *
      **  Retrieve the currency details.
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       ##RTCD                         B:Return Cd
     C                   PARM      '*KEY'        ##OPTN                         I:Option
     C**********           PARM ##CCY     ##CCYP           I:Currency Code                    153769
     C                   PARM      CCYDS         ##CCYP                         I:Currency Co 153769
     C     SDCURR        PARM      *BLANK        DSSDY                          O:Format
      *
      **  Database Error
     C     ##RTCD        IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    W0FILE
     C**********           MOVEL##CCY     W0KEY            ***************                    153769
     C                   MOVEL     CCYDS         W0KEY                          **************153769
     C                   Z-ADD     9             W0ERNB                         * DB ERROR 09 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C/COPY WNCPYSRC,CG4510C007
      *
      **  If the currency has been retrieved earlier, position the
      **  Currency Data data structure on the relevant occurrence.
     C                   ELSE
     C     C             OCCUR     SDCURR
     C/COPY WNCPYSRC,CG4510C077
     C                   ENDIF
     C*
     C     EXDCDP        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRINIT                                         *
      * Function    :  Initial processing - First Call Only           *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  AOBANKR0 - Obtain Bank details                 *
      *                AOGELRR0 - Obtain General Ledger Details       *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *................................................................
      *
      **  Define Fields
     C     *LIKE         DEFINE    SDLSTD        ##LSTD
     C     *LIKE         DEFINE    SDNSTD        ##NSTD
     C     *LIKE         DEFINE    SDLSTP        ##LSTP
     C     *LIKE         DEFINE    SDCFSB        ##CFSB
     C     *LIKE         DEFINE    SDYTDB        ##YTDB
      *
     C     *LIKE         DEFINE    PSTA          PSTAX                                        173553
      *
     C     *LIKE         DEFINE    CCY           ##CCYB
     C     *LIKE         DEFINE    CCY           ##CCYP
     C     *LIKE         DEFINE    BRCA          ##BRCD
     C     *LIKE         DEFINE    PSTD          ##PSTD
     C     *LIKE         DEFINE    PSTD          ##FPDT
     C     *LIKE         DEFINE    PSTD          ##LPDT
     C     *LIKE         DEFINE    SDLSTP        ##LSTT
     C     *LIKE         DEFINE    PSTA          ##OCLC
     C     *LIKE         DEFINE    PSTA          ##OCLD
     C     *LIKE         DEFINE    PSTA          ##CCLC
     C     *LIKE         DEFINE    PSTA          ##CCLD
     C     *LIKE         DEFINE    PSTA          ##DCLC
     C     *LIKE         DEFINE    PSTA          ##DCLD
     C     *LIKE         DEFINE    PSTA          ##CFB
     C     *LIKE         DEFINE    PSTA          ##CFCB
     C     *LIKE         DEFINE    PSTA          ##NOEC
     C********** *LIKE     DEFN PSTA      ##VAEC                                            MD054681
     C     *LIKE         DEFINE    SDCFSB        ##VAEC                                     MD054681
     C     *LIKE         DEFINE    PSTA          ##NOED
     C********** *LIKE     DEFN PSTA      ##VAED                                            MD054681
     C     *LIKE         DEFINE    SDCFSB        ##VAED                                     MD054681
     C     *LIKE         DEFINE    PSTA          ##ACBL
     C     *LIKE         DEFINE    PSTA          ##CLBL
     C     *LIKE         DEFINE    DERPTH        ##RPTH
     C     *LIKE         DEFINE    DENPTH        ##NPTH
     C     *LIKE         DEFINE    DEFSLI        ##FSLI
     C                   MOVE      *BLANKS       S#PATH          256
     C     *LIKE         DEFINE    DEPBIN        ##BNDC
     C     *LIKE         DEFINE    DEPBIN        S#PBIN
     C     *LIKE         DEFINE    DETBIN        S#TBIN
     C     *LIKE         DEFINE    DEOSEQ        ##OSEQ                                       082060
     C     *LIKE         DEFINE    CCY           W#CCY                                        CEU013
     C     *LIKE         DEFINE    SDCFSB        W#EBAL                                       CEU013
     C     *LIKE         DEFINE    A6NBDP        W#NBDP                                       CEU013
     C     *LIKE         DEFINE    SDLSTP        W#BITM                                     BUG24460
     C*                                                                                       CEU014
     C**  Define Equivalent Currency                                                          CEU014
     C     *LIKE         DEFINE    CCY           EQCY                                         CEU014
      *
      **  Key list for full Account plus Posting Date
     C     ##ACDK        KLIST
     C                   KFLD                    ##BRCA
     C                   KFLD                    ##CNUM
     C                   KFLD                    ##CCY
     C                   KFLD                    ##ACOD
     C                   KFLD                    ##ACSQ
     C                   KFLD                    ##PSTD
      *
      **  Key list for full Account
     C     ##ACKY        KLIST
     C                   KFLD                    ##BRCA
     C                   KFLD                    ##CNUM
     C                   KFLD                    ##CCY
     C                   KFLD                    ##ACOD
     C                   KFLD                    ##ACSQ
      *
      **  Key list for LF/REIACD
     C     ##REKY        KLIST
     C                   KFLD                    ##CNUM
     C                   KFLD                    ##CCY
     C                   KFLD                    ##ACOD
     C                   KFLD                    ##ACSQ
     C                   KFLD                    ##BRCA
      *                                                                                       CEU013
      **  Key list for PF/GLAPSTPD                                                            CEU013
     C     ##POST        KLIST                                                                CEU013
     C                   KFLD                    XRFI                                         CEU013
     C                   KFLD                    XRFN                                         CEU013
      *                                                                                       239823
      ** Define KLIST for GLACBTL0                                                            239823
      *                                                                                       239823
     C     KGLAC         KLIST                                                                239823
     C                   KFLD                    CNUM                                         239823
     C                   KFLD                    CCY                                          239823
     C                   KFLD                    ACOD                                         239823
     C                   KFLD                    ACSQ                                         239823
     C                   KFLD                    BRCA                                         239823
     C/COPY WNCPYSRC,CG4510C032
      *
      **  Call access program for Bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      '*FIRST  '    ##OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Database error
     C     ##RTCD        IFNE      *BLANK
      *
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     10            W0ERNB                         * DB ERROR 10 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      **  Call access program for General Ledger details
     C**********           CALL 'AOGELRR0'                                                    CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*MSG   '     ##RTCD
     C                   PARM      '*FIRST '     ##OPTN
     C********** SDGELR    PARM SDGELR    DSFDY                                               CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      **  Database error
     C     ##RTCD        IFNE      *BLANK
      *
     C                   MOVEL     'AOGELRR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     11            W0ERNB                         * DB ERROR 11 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CEU013
      ** Access SAR details file to determine if CEU013 is installed.                         CEU013
      *                                                                                       CEU013
     C                   CALL      'AOSARDR0'                                                 CEU013
     C                   PARM      '       '     ##RTCD                                       CEU013
     C                   PARM      '*VERIFY'     ##OPTN                                       CEU013
     C                   PARM      'CEU013'      ##SARD            6                          CEU013
      *                                                                                       CEU013
      ** DATABASE ERROR                                                                       CEU013
      *                                                                                       CEU013
     C     ##RTCD        IFNE      *BLANK                                                     CEU013
     C     ##RTCD        ANDNE     '*NRF   '                                                  CEU013
     C                   MOVEL     'SCSARDPD'    W0FILE                         **************CEU013
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 12 CEU013
     C                   Z-ADD     12            W0ERNB                         **************CEU013
     C                   MOVEL     'MEM5003'     W0MSGD                                       CEU013
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CEU013
     C                   EXSR      SRERR                                                      CEU013
     C                   END                                                                  CEU013
     C*                                                                                       CEU013
     C     ##RTCD        IFEQ      *BLANK                                                     CEU013
     C                   MOVEL     'Y'           CEU013            1                          CEU013
     C                   ELSE                                                                 CEU013
     C                   MOVEL     'N'           CEU013                                       CEU013
     C                   END                                                                  CEU013
      *                                                                                       CEU013
      **  Retrieve the Euro currency details for later use.                                   CEU013
      *                                                                                       CEU013
     C     CEU013        IFEQ      'Y'                                                        CEU013
     C     BKEURO        ANDNE     *BLANKS                                                    CEU013
     C                   MOVE      BKEURO        W#CCY                                        CEU013
      *                                                                                       CEU013
     C**********           CALL 'AOCURRR0'                                             CEU013 153769
     C**********           PARM *BLANKS   ##RTCD           B:Return Cd                 CEU013 153769
     C**********           PARM '*KEY'    ##OPTN           I:Option                    CEU013 153769
     C**********           PARM W#CCY     ##CCYP           I:Currency Code             CEU013 153769
     C********** SDCURR    PARM *BLANK    DSSDY            O:Format                    CEU013 153769
      **********                                                                       CEU013 153769
      ****Database*Error                                                               CEU013 153769
     C********** ##RTCD    IFNE *BLANK                                                 CEU013 153769
     C**********           MOVEL'SDCURRPD'W0FILE                                       CEU013 153769
     C**********           MOVELW#CCY     W0KEY            ***************             CEU013 153769
     C**********           Z-ADD13        W0ERNB           * DB ERROR 13 *             CEU013 153769
     C**********           MOVEL'MEM5004' W0MSGD           ***************             CEU013 153769
     C**********           MOVEL'MIDAS  ' W0MSGF                                       CEU013 153769
     C**********           EXSR SRERR                                                  CEU013 153769
     C**********           ENDIF                                                       CEU013 153769
      **  Access the Euro currency details for later use                                      153769
      *                                                                                       153769
     C                   MOVE      W#CCY         CCYDS                                        153769
     C                   EXSR      SRDCDT                                                     153769
      *                                                                                       153769
     C                   Z-ADD     A6NBDP        W#NBDP                                       CEU013
     C                   ENDIF                                                                CEU013
      *                                                                                       CEU013
      *                                                                                       CEU014
      ** Access SAR details file to determine if CEU014 is installed.                         CEU014
      *                                                                                       CEU014
     C                   CALL      'AOSARDR0'                                                 CEU014
     C                   PARM      '       '     ##RTCD                                       CEU014
     C                   PARM      '*VERIFY'     ##OPTN                                       CEU014
     C                   PARM      'CEU014'      ##SARD            6                          CEU014
      *                                                                                       CEU014
      ** DATABASE ERROR                                                                       CEU014
      *                                                                                       CEU014
     C     ##RTCD        IFNE      *BLANK                                                     CEU014
     C     ##RTCD        ANDNE     '*NRF   '                                                  CEU014
     C                   MOVEL     'SCSARDPD'    W0FILE                         **************CEU014
     C                   MOVEL     '*CALL'       W0KEY                          * DB ERROR 09 CEU014
     C                   Z-ADD     09            W0ERNB                         **************CEU014
     C                   MOVEL     'MEM5003'     W0MSGD                                       CEU014
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CEU014
     C                   EXSR      SRERR                                                      CEU014
     C                   END                                                                  CEU014
     C*                                                                                       CEU014
     C     ##RTCD        IFEQ      *BLANK                                                     CEU014
     C                   MOVEL     'Y'           CEU014            1                          CEU014
     C                   ELSE                                                                 CEU014
     C                   MOVEL     'N'           CEU014                                       CEU014
     C                   END                                                                  CEU014
      *                                                                                       CFT004
      ** Access SAR details file to determine if CFT004 is installed.                         CFT004
      *                                                                                       CFT004
     C                   CALL      'AOSARDR0'                                                 CFT004
     C                   PARM      *BLANKS       PRTCD             7                          CFT004
     C                   PARM      '*VERIFY'     POPTN             7                          CFT004
     C                   PARM      'CFT004'      PSARD             6                          CFT004
     C     SCSARD        PARM      SCSARD        DSSDY                                        CFT004
      *                                                                                       CFT004
      ** Database Error                                                                       CFT004
      *                                                                                       CFT004
     C     PRTCD         IFNE      *BLANK                                                     CFT004
     C     PRTCD         ANDNE     '*NRF   '                                                  CFT004
     C                   MOVEL     'SCSARDPD'    W0FILE                         ************  CFT004
     C                   MOVEL     '*CALL'       W0KEY                          * DBERR 18 *  CFT004
     C                   Z-ADD     18            W0ERNB                         ************  CFT004
     C                   MOVEL     'MEM5003'     W0MSGD                                       CFT004
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CFT004
     C                   EXSR      SRERR                                                      CFT004
     C                   END                                                                  CFT004
      *                                                                                       CFT004
     C                   MOVEL     'N'           CFT004                                       CFT004
     C     PRTCD         IFEQ      *BLANK                                                     CFT004
     C                   MOVEL     'Y'           CFT004            1                          CFT004
     C                   ENDIF                                                                CFT004
      *                                                                                       CCG015
      ** Access SAR details file to determine if CCG015 is installed.                         CCG015
      *                                                                                       CCG015
     C                   CALL      'AOSARDR0'                                                 CCG015
     C                   PARM      *BLANKS       PRTCD             7                          CCG015
     C                   PARM      '*VERIFY'     POPTN             7                          CCG015
     C                   PARM      'CCG015'      PSARD             6                          CCG015
     C     SCSARD        PARM      SCSARD        DSSDY                                        CCG015
      *                                                                                       CCG015
      ** Database Error                                                                       CCG015
      *                                                                                       CCG015
     C     PRTCD         IFNE      *BLANK                                                     CCG015
     C     PRTCD         ANDNE     '*NRF   '                                                  CCG015
     C                   MOVEL     'SCSARDPD'    W0FILE                         ************  CCG015
     C                   MOVEL     '*CALL'       W0KEY                          * DBERR 19 *  CCG015
     C                   Z-ADD     19            W0ERNB                         ************  CCG015
     C                   MOVEL     'MEM5003'     W0MSGD                                       CCG015
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CCG015
     C                   EXSR      SRERR                                                      CCG015
     C                   END                                                                  CCG015
      *                                                                                       CCG015
     C                   MOVEL     'N'           CCG015                                       CCG015
     C     PRTCD         IFEQ      *BLANK                                                     CCG015
     C                   MOVEL     'Y'           CCG015            1                          CCG015
     C                   ENDIF                                                                CCG015
     C*                                                                                       216006
     C                   CALL      'AOSARDR0'                                                 216006
     C                   PARM      *BLANKS       PRTCD             7                          216006
     C                   PARM      '*VERIFY'     POPTN             7                          216006
     C                   PARM      'CRE008'      PSARD             6                          216006
     C     SCSARD        PARM      SCSARD        DSSDY                                        216006
      *                                                                                       216006
      ** Database Error                                                                       216006
      *                                                                                       216006
     C     PRTCD         IFNE      *BLANK                                                     216006
     C     PRTCD         ANDNE     '*NRF   '                                                  216006
     C                   MOVEL     'SCSARDPD'    W0FILE                         ************  216006
     C                   MOVEL     '*CALL'       W0KEY                          * DBERR 30 *  216006
     C                   Z-ADD     30            W0ERNB                         ************  216006
     C                   MOVEL     'MEM5003'     W0MSGD                                       216006
     C                   MOVEL     'MIDAS  '     W0MSGF                                       216006
     C                   EXSR      SRERR                                                      216006
     C                   END                                                                  216006
      *                                                                                       216006
     C                   MOVEL     'N'           CRE008                                       216006
     C     PRTCD         IFEQ      *BLANK                                                     216006
     C                   MOVEL     'Y'           CRE008            1                          216006
     C     *LOVAL        SETLL     SDCMANL0                                                   216006
     C                   READ      SDCMANL0                               80                  216006
     C     *IN80         IFEQ      *ON                                                        216006
     C                   MOVEL     'SDCMANL0'    W0FILE                         ************  216006
     C                   MOVEL     '*FIRST'      W0KEY                          * DBERR 31 *  216006
     C                   Z-ADD     31            W0ERNB                         ************  216006
     C                   MOVEL     'MEM5003'     W0MSGD                                       216006
     C                   MOVEL     'MIDAS  '     W0MSGF                                       216006
     C                   EXSR      SRERR                                                      216006
     C                   END                                                                  216006
     C                   ENDIF                                                                216006
      *                                                                                       CAP204
      ** Access SAR details file to determine if CAP204 is installed.                         CAP204
      *                                                                                       CAP204
     C                   CALL      'AOSARDR0'                                                 CAP204
     C                   PARM      *BLANKS       PRTCD             7                          CAP204
     C                   PARM      '*VERIFY'     POPTN             7                          CAP204
     C                   PARM      'CAP204'      PSARD             6                          CAP204
     C     SCSARD        PARM      SCSARD        DSSDY                                        CAP204
      *                                                                                       CAP204
      ** Database Error                                                                       CAP204
      *                                                                                       CAP204
     C     PRTCD         IFNE      *BLANK                                                     CAP204
     C     PRTCD         ANDNE     '*NRF   '                                                  CAP204
     C                   MOVEL     'SCSARDPD'    W0FILE                         ************  CAP204
     C                   MOVEL     '*CALL'       W0KEY                          * DBERR 20 *  CAP204
     C                   Z-ADD     20            W0ERNB                         ************  CAP204
     C                   MOVEL     'MEM5003'     W0MSGD                                       CAP204
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CAP204
     C                   EXSR      SRERR                                                      CAP204
     C                   END                                                                  CAP204
      *                                                                                       CAP204
     C                   MOVEL     'N'           CAP204                                       CAP204
     C     PRTCD         IFEQ      *BLANK                                                     CAP204
     C                   MOVEL     'Y'           CAP204            1                          CAP204
     C                   ENDIF                                                                CAP204
      *                                                                                       CEU014
     C                   CALL      'AOSARDR0'                                                 CER038
     C                   PARM      *BLANKS       PRTCD                                        CER038
     C                   PARM      '*VERIFY'     POPTN                                        CER038
     C                   PARM      'CER038'      PSARD                                        CER038
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER038
      *                                                                                       CER038
     C     PRTCD         IFNE      *BLANKS                                                    CER038
     C     PRTCD         ANDNE     '*NRF    '                                                 CER038
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CER038
     C                   MOVEL     'CER038'      W0KEY                                        CER038
     C                   Z-ADD     32            W0ERNB                                       CER038
     C                   MOVEL     'MEM5003'     W0MSGD                                       CER038
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CER038
     C                   EXSR      SRERR                                                      CER038
     C                   ENDIF                                                                CER038
      *                                                                                       CER038
     C     PRTCD         IFEQ      *BLANKS                                                    CER038
     C                   MOVE      'Y'           CER038            1                          CER038
     C                   ELSE                                                                 CER038
      *                                                                                       CER038
     C                   MOVE      'N'           CER038                                       CER038
     C                   ENDIF                                                                CER038
      *                                                                                       CER038
     C                   CALL      'AOSARDR0'                                                 CER038
     C                   PARM      *BLANKS       PRTCD                                        CER038
     C                   PARM      '*VERIFY'     POPTN                                        CER038
     C                   PARM      'CER031'      PSARD                                        CER038
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER038
      *                                                                                       CER038
     C     PRTCD         IFNE      *BLANKS                                                    CER038
     C     PRTCD         ANDNE     '*NRF    '                                                 CER038
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CER038
     C                   MOVEL     'CER031'      W0KEY                                        CER038
     C                   Z-ADD     33            W0ERNB                                       CER038
     C                   MOVEL     'MEM5003'     W0MSGD                                       CER038
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CER038
     C                   EXSR      SRERR                                                      CER038
     C                   ENDIF                                                                CER038
      *                                                                                       CER038
     C     PRTCD         IFEQ      *BLANKS                                                    CER038
     C                   MOVE      'Y'           CER031            1                          CER038
     C                   ELSE                                                                 CER038
      *                                                                                       CER038
     C                   MOVE      'N'           CER031                                       CER038
     C                   ENDIF                                                                CER038
      *                                                                                       CER038
      ** Access Switchable Features file and check if CCG015 is                             BUG23445
      ** installed                                                                          BUG23445
      *                                                                                     BUG23445
     C                   CALL      'AOSARDR0'                                               BUG23445
     C                   PARM      *BLANKS       PRTCD                                      BUG23445
     C                   PARM      '*VERIFY'     POPTN                                      BUG23445
     C                   PARM      'CGL013'      PSARD                                      BUG23445
      *                                                                                     BUG23445
     C     PRTCD         IFEQ      *BLANK                                                   BUG23445
     C                   MOVE      'Y'           CGL013            1                        BUG23445
     C                   ELSE                                                               BUG23445
     C                   MOVE      'N'           CGL013                                     BUG23445
     C     PRTCD         IFNE      '*NRF   '                                                BUG23445
     C                   MOVEL     'SCSARDPD'    W0FILE                                     BUG23445
     C                   MOVEL     '*CALL'       W0KEY                                      BUG23445
     C                   Z-ADD     34            W0ERNB                                     BUG23445
     C                   MOVEL     'MEM5003'     W0MSGD                                     BUG23445
     C                   MOVEL     'MIDAS  '     W0MSGF                                     BUG23445
     C                   EXSR      SRERR                                                    BUG23445
     C                   ENDIF                                                              BUG23445
     C                   ENDIF                                                              BUG23445
      *                                                                                     BUG24460
      ** Access Switchable Features file and check if CER030 is                             BUG24460
      ** installed                                                                          BUG24460
      *                                                                                     BUG24460
     C                   CALL      'AOSARDR0'                                               BUG24460
     C                   PARM      *BLANKS       PRTCD                                      BUG24460
     C                   PARM      '*VERIFY'     POPTN                                      BUG24460
     C                   PARM      'CER030'      PSARD                                      BUG24460
      *                                                                                     BUG24460
     C     PRTCD         IFEQ      *BLANK                                                   BUG24460
     C                   MOVE      'Y'           CER030            1                        BUG24460
     C                   ELSE                                                               BUG24460
     C                   MOVE      'N'           CER030                                     BUG24460
     C     PRTCD         IFNE      '*NRF   '                                                BUG24460
     C                   MOVEL     'SCSARDPD'    W0FILE                                     BUG24460
     C                   MOVEL     '*CALL'       W0KEY                                      BUG24460
     C                   Z-ADD     35            W0ERNB                                     BUG24460
     C                   MOVEL     'MEM5003'     W0MSGD                                     BUG24460
     C                   MOVEL     'MIDAS  '     W0MSGF                                     BUG24460
     C                   EXSR      SRERR                                                    BUG24460
     C                   ENDIF                                                              BUG24460
     C                   ENDIF                                                              BUG24460
      *                                                                                       CRE073
      ** Access Switchable Features file and check if CRE073 is                               CRE073
      ** installed                                                                            CRE073
      *                                                                                       CRE073
     C                   CALL      'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM      '*VERIFY'     POPTN                                        CRE073
     C                   PARM      'CRE073'      PSARD                                        CRE073
      *                                                                                       CRE073
     C     PRTCD         IFEQ      *BLANK                                                     CRE073
     C                   MOVE      'Y'           CRE073            1                          CRE073
     C                   ELSE                                                                 CRE073
     C                   MOVE      'N'           CRE073                                       CRE073
     C     PRTCD         IFNE      '*NRF   '                                                  CRE073
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CRE073
     C                   MOVEL     '*CALL'       W0KEY                                        CRE073
     C                   Z-ADD     37            W0ERNB                                       CRE073
     C                   MOVEL     'MEM5003'     W0MSGD                                       CRE073
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CRE073
     C                   EXSR      SRERR                                                      CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                     BUG23445
      ***Keylist*for*file**GLNW94L1                                               BUG23445 BUG23445A
      ** Keylist for file  GLNWACL1                                                        BUG23445A
      *                                                                                     BUG23445
     C     KACCT         KLIST                                                              BUG23445
     C                   KFLD                    KNWRK                                      BUG23445
     C                   KFLD                    PBRCA                                      BUG23445
     C                   KFLD                    PCUSNO                                     BUG23445
     C                   KFLD                    PCUCD                                      BUG23445
     C                   KFLD                    KACCD                                      BUG23445
     C                   KFLD                    KACSQ                                      BUG23445
      *                                                                                     BUG23445
      ** Keylist for file GLMNARL1                                                          BUG24460
      *                                                                                     BUG24460
     C     KLNAR         KLIST                                                              BUG24460
     C                   KFLD                    PSTD                                       BUG24460
     C                   KFLD                    ##BANO                                     BUG24460
     C                   KFLD                    W#BITM                                     BUG24460
      *                                                                                     BUG24460
     C     KJNAR         KLIST                                                              BUG26680
     C                   KFLD                    ##BANO                                     BUG26680
     C                   KFLD                    W#BITM                                     BUG26680
      *                                                                                     BUG24460
     C     KJNAR#        KLIST                                                              BUG26680
     C                   KFLD                    PSTD                                       BUG26680
     C                   KFLD                    ##BANO                                     BUG26680
     C                   KFLD                    W#BITM                                     BUG26680
      *                                                                                     BUG26680
     C/COPY WNCPYSRC,CG4510C008
      *
      **  Copyright
     C                   MOVEA     ##CPY         ##BIS            80
     C/COPY WNCPYSRC,CG4510C006
      *
      *................................................................
      *
     C     EXINIT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
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
     C                   Z-ADD     *ZEROS        #1                6 0
     C                   Z-ADD     *ZEROS        #2                6 0
     C                   Z-ADD     *ZEROS        #3                6 0
     C                   MOVE      *BLANKS       S#PATH
      *
     C                   Z-ADD     *ZEROS        ##OSEQ
      *
     C                   Z-ADD     *ZEROS        ##LSTD
     C                   Z-ADD     *ZEROS        ##NSTD
     C                   Z-ADD     *ZEROS        ##LSTP                                       Output
     C                   Z-ADD     *ZEROS        ##CFSB                                       Output
     C                   Z-ADD     *ZEROS        ##YTDB                                       Output
      *
     C                   Z-ADD     *ZEROS        ##ACBL                                       Output
     C                   Z-ADD     *ZEROS        ##CCLC                                       Output
     C                   Z-ADD     *ZEROS        ##CCLD                                       Output
     C                   Z-ADD     *ZEROS        ##DCLC                                       Output
     C                   Z-ADD     *ZEROS        ##DCLD                                       Output
     C                   Z-ADD     *ZEROS        ##CFB                                        Output
     C                   Z-ADD     *ZEROS        ##CFCB                                       Output
     C                   Z-ADD     *ZEROS        ##NOED                                       Output
     C                   Z-ADD     *ZEROS        ##NOEC                                       Output
     C                   Z-ADD     *ZEROS        ##VAED                                       Output
     C                   Z-ADD     *ZEROS        ##VAEC                                       Output
     C                   Z-ADD     *ZEROS        ##OCLC                                       Output
     C                   Z-ADD     *ZEROS        ##OCLD                                       Output
     C/COPY WNCPYSRC,CG4510C021
      *
      **  Initialise Binds.
     C                   Z-ADD     1             S#PBIN
     C                   Z-ADD     1             S#TBIN
     C                   Z-ADD     1             ##BNDC
      *                                                                                       CCG015
      **  Initialise XML increment                                                            CCG015
     C                   EXSR      INIXML                                                     CCG015
      *
     C     EXINZ         TAG
      *
      *................................................................
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************                     BUG24460
      /EJECT                                                                                BUG24460
      *****************************************************************                     BUG24460
      *                                                               *                     BUG24460
      *  SREVNA   - Evaluate Additional Narrative Details             *                     BUG24460
      *                                                               *                     BUG24460
      *  Called by: PSNARR                                            *                     BUG24460
      *                                                               *                     BUG24460
      *  Calls: None                                                  *                     BUG24460
      *                                                               *                     BUG24460
      *****************************************************************                     BUG24460
     C     SREVNA        BEGSR                                                              BUG24460
      *                                                                                     BUG24460
     C                   MOVEL     BAEX1         EXT(1)                                     BUG24460
     C                   MOVEL     BAEX2         EXT(2)                                     BUG24460
     C                   MOVEL     BAEX3         EXT(3)                                     BUG24460
     C                   MOVEL     BAEX4         EXT(4)                                     BUG24460
     C                   MOVEL     BAEX5         EXT(5)                                     BUG24460
     C                   MOVEL     BAEX6         EXT(6)                                     BUG24460
     C                   MOVEL     BAEX7         EXT(7)                                     BUG24460
     C                   MOVEL     BAEX8         EXT(8)                                     BUG24460
     C                   MOVEL     BAEX9         EXT(9)                                     BUG24460
     C                   MOVEL     BAEX10        EXT(10)                                    BUG24460
     C                   MOVEL     BAEX11        EXT(11)                                    BUG24460
     C                   MOVEL     BAEX12        EXT(12)                                    BUG24460
     C                   MOVEL     BAEX13        EXT(13)                                    BUG24460
     C                   MOVEL     BAEX14        EXT(14)                                    BUG24460
     C                   MOVEL     BAEX15        EXT(15)                                    BUG24460
     C                   MOVEL     BAEX16        EXT(16)                                    BUG24460
     C                   MOVEL     BAEX17        EXT(17)                                    BUG24460
     C                   MOVEL     BAEX18        EXT(18)                                    BUG24460
     C                   MOVEL     BAEX19        EXT(19)                                    BUG24460
     C                   MOVEL     BAEX20        EXT(20)                                    BUG24460
     C                   MOVEL     BAEX21        EXT(21)                                    BUG24460
     C                   MOVEL     BAEX22        EXT(22)                                    BUG24460
      *                                                                                     BUG24460
     C                   ENDSR                                                              BUG24460
      *****************************************************************
     C/COPY WNCPYSRC,CG4510C022
     C/SPACE 5
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD056543
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD056543
     C/SPACE 5
     C*COPY*CGCPYSRC,SRERRC                                                                 MD056543
     C/COPY CGCPYSRC,SRERRCLE                                                               MD056543
     O/SPACE 5
     O/COPY WNCPYSRC,CG4510O001
     O/SPACE 5                                                            CCG015
     O*COPY*CGCPYSRC,CGNWEX                                                          CCG015 MD056543
     O/COPY CGCPYSRC,CGNWEXCILE                                                             MD056543
**CTDATA ##GRP
g_SHDR0001 STMT_DATE  Date
g_SHDR0002 STMT_LSD   Date
g_SHDR0003 STMT_NUMBR AmountL
g_SHDR0004 STMT_DEMAN
g_SHDR0005 STMT_MANAG
BRANCH0001 BRANCH
BRANCH0002 BRANCH NAM
ACCNT 0001 ACCOUNT
ACCNT 0002 RETL_ACNO
ACCNT 0003 ACC_NAME
ACCNT 0004 ACC_TYPE
ACCNT 0005 BAL_EURO                                                       CEU013
ACCNT 0006 IBAN                                                           CFT004
ACCNT 0007 CRE073F                                                                            CRE073
     X/COPY WNCPYSRC,CGH00013
CUST  0001 CUSTOMER
CUST  0002 CUST_NAME
CUST  0003 CUST_ADR1
CUST  0004 CUST_ADR2
CUST  0005 CUST_ADR3
CUST  0006 CUST_ADR4
CUST  0007 CUST_TOWN                                                      086918
ACOF  0001 ACOF_CODE                     Account Officer Code             089776
ACOF  0002 ACOF_DEPT                     Account Officer Dept             089776
ACOF  0003 ACOF_NAME                     Account Officer Name             089776
ACOF  0004 ACOF_TELP                     Account Officer Telephone Num.   089776
ACOF  0005 ACOF_TELX                     Account Officer Telephone Ext.   089776
CCY   0001 CURRENCY
CCY   0002 CCY_DESC
CCY   0003 PREC_METIN                                                     086780
g_SOPB0001 STMT_BFBAL AmountL
g_SOPB0002 STMT_BFCBL AmountL
g_SOPB0003 EURO_BFBAL AmountL                                             CEU013
g_SOPB0004 EURO_BFCBL AmountL                                             CEU013
g_SPS30001 POST_DATE  Date
g_SPS30002 VALUE DATE Date
g_SPS30003 CHQ_NUMBER
g_SPS30004 POST_NARR
g_SPS30005 POST_AMT   AmountL
g_SPS30006 POST_GETP
g_SPS30007 POST_MODUL
g_SPS30008 POST_TNUM
g_SPS30009 POST_BCHN
g_SPS30010 POST_BITEM
g_SPS30011 STMT_ACBL  AmountL
g_SPS30012 ORIG_CCY                                                       CEU013
g_SPS30013 ORIG_AMNT  AmountL                                             CEU013
g_SPS30014 POST_EQCY  AmountL                                             CEU014
g_SPS30015 EQUIV_CCY                                                      CEU014
g_SPS30016 EQUIV_CCYD                                                     CEU014
g_SPS30017 ORIG_ACCT                                                      216937
g_SCLR0001 HDR_CRCLR  AmountL
g_SCLR0002 HDR_DRCLR  AmountL
g_SCLR0003 START_CLR  AmountL
g_SCLR0004 END_CLR    AmountL
g_SCLR0005 TOT_CRCLR  AmountL
g_SCLR0006 TOT_DRCLR  AmountL
g_SCLB0001 STMT_CFBAL AmountL
g_SCLB0002 STMT_CFCBL AmountL
g_SCLB0003 EURO_CFBAL AmountL                                             CEU013
g_SCLB0004 EURO_CFCBL AmountL                                             CEU013
g_SBRK0001 TOT_CRENT  AmountL
g_SBRK0002 TOT_CRVAL  AmountL
g_SBRK0003 TOT_DRENT  AmountL
g_SBRK0004 TOT_DRVAL  AmountL
g_SRC20001 POST_DATE  Date
g_SRC20002 VALUE DATE Date
g_SRC20003 POST_RATE  Rate  L7
g_SRC20004 DR/CR
g_SRC20005 DCONTRSPR  Rate  L7                                                                CRE073
g_SRC20006 DSPRSIGN                                                                           CRE073
g_SRC20007 DRNDMTD                                                                            CRE073
g_SRC20008 DRNDFRAC                                                                           CRE073
g_SCC20001 POST_DATE  Date
g_SCC20002 VALUE DATE Date
g_SCC20003 POST_RATE  Rate  L7
g_SCC20004 DR/CR
g_SCC20005 CCONTRSPR  Rate  L7                                                                CRE073
g_SCC20006 CSPRSIGN                                                                           CRE073
g_SCC20007 CRNDMTD                                                                            CRE073
g_SCC20008 CRNDFRAC                                                                           CRE073
g_SFTR0001 CMGA_TXT1                                                      216006
g_SFTR0002 CMGA_TXT2                                                      216006
g_SFTR0003 CMGA_TXT3                                                      216006
g_SFTR0004 CMGA_TXT4                                                      216006
     X/COPY WNCPYSRC,CG4510X001
PSNARR0001 PSNARR01                      Posting Narrative 1                                  CER038
PSNARR0002 PSNARR02                      Posting Narrative 2                                  CER038
PSNARR0003 PSNARR03                      Posting Narrative 3                                  CER038
PSNARR0004 PSNARR04                      Posting Narrative 4                                  CER038
PSNARR0005 PSNARR05                      Posting Narrative 5                                  CER038
PSNARR0006 PSNARR06                      Posting Narrative 6                                  CER038
PSNARR0007 PSNARR07                      Posting Narrative 7                                  CER038
PSNARR0008 PSNARR08                      Posting Narrative 8                                  CER038
PSNARR0009 PSNARR09                      Posting Narrative 9                                  CER038
PSNARR0010 PSNARR10                      Posting Narrative 10                                 CER038
PSNARR0011 PSNARR11                      Posting Narrative 11                                 CER038
PSNARR0012 PSNARR12                      Posting Narrative 12                                 CER038
PSNARR0013 PSNARR13                      Posting Narrative 13                                 CER038
PSNARR0014 PSNARR14                      Posting Narrative 14                                 CER038
PSNARR0015 PSNARR15                      Posting Narrative 15                                 CER038
PSNARR0016 PSNARR16                      Posting Narrative 16                                 CER038
PSNARR0017 PSNARR17                      Posting Narrative 17                                 CER038
PSNARR0018 PSNARR18                      Posting Narrative 18                                 CER038
PSNARR0019 PSNARR19                      Posting Narrative 19                                 CER038
PSNARR0020 PSNARR20                      Posting Narrative 20                                 CER038
PSNARR0021 PSNARR21                      Posting Narrative 21                               BUG24460
PSNARR0022 PSNARR22                      Posting Narrative 22                               BUG24460
**CTDATA ##GE
AGL
CRE
DDL
ERE
FGL
GFT
HGL
IGL
JGL
KGL
MGL
ORE
PRE
QRE
RGL
SSE
TFO
ULE
XGL
YGL
LGL                                                                                           CAP204
**CTDATA ##CPY
(c) Finastra International Limited 2001
     X/COPY WNCPYSRC,CG4510X002
