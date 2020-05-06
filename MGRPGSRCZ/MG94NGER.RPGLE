     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MG External Extract Program')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation Module                            *
      *                                                               *
      *  MG94NGER - Midas MG MT94X Extract Program                    *
      *                                                               *
      *  Function:  This program Extracts the data into Extract file  *
      *             for Multicash format.                             *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD055642           Date 04May20               *
      *  Prev Amend No. MD050727           Date 21Jan17               *
      *                 CMG008             Date 19May10               *
      *                 MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 263479             Date 20Jan10               *
      *                 BUG26853           Date 15Dec09               *
      *                 BUG26780A          Date 11Dec09               *
      *                 BUG26814           Date 07Dec09               *
      *                 BUG26780           Date 23Nov09               *
      *                 BUG26512           Date 28Oct09               *
      *                 BUG26351           Date 16Oct09               *
      *                 BUG26430           Date 15Oct09               *
      *                 BUG26247           Date 30Sep09               *
      *                 BUG25529B          Date 18Sep09               *
      *                 BUG24278           Date 16Jun09               *
      *                 BUG24387           Date 16Jun09               *
      *                 BUG24304           Date 12Jun09               *
      *                 BUG23742           Date 26May09               *
      *                 BUG23280D          Date 10May09               *
      *                 BUG23280B          Date 18Apr09               *
      *                 BUG23040A          Date 25Mar09               *
      *                 BUG23280A          Date 25Mar09               *
      *                 BUG23284           Date 13Mar09               *
      *                 BUG23208           Date 12Mar09               *
      *                 BUG23190           Date 10Mar09               *
      *                 BUG22995           Date 20Feb09               *
      *                 BUG22687           Date 06Feb09               *
      *                 CER030  *CREATE    Date 09Jul08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055642 - FM 2.1 SP21 Duplicate MultiCash Narr 22 on        *
      *             field 61 subfield 86                              *
      *  MD050727 - Emergency fix to enable alphanumeric batches      *
      *             to be processed. Please see SFDC 01793714         *
      *  CMG008 - Upgrade of EMP005 to BF2.1 SP21                     *
      *      EMP005 - Non-SWIFT Character conversion.                 *
      *               This is an upgrade of TFJ002. As character      *
      *               conversion is now done in GL001432, EML008      *
      *               (to remove German characters) has been taken    *
      *               out from MG000940/942/950. Changes here also    *
      *               includes EMP008CC1 (removal of limitation on    *
      *               Destination and Network)                        *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  263479 - GVC code wrong fro some MT942.  Correctly retrieve  *
      *           record from GLNW94PD.                               *
      *  BUG26853 - GVC code received from interface was replaced     *
      *  BUG26780A - Incorrect subfield 00 and 10 values              *
      *  BUG26814 - Change Request Ver 4                              *
      *  BUG26780 - Incorrect subfield 00 and 10 values               *
      *  BUG26512 - Mapping for MT940 STRCT incorrect                 *
      *  BUG26351 - Multicash Narratives 19-22 were duplicated        *
      *  BUG26430 - Sub Field 10 is missing for STRCT format message  *
      *  BUG26247 - Multicash Narrative 2 and 3 were not mapped to    *
      *             Field 86 subfields 00 and 10                      *
      *           - Applied fix BUG25320                              *
      *  BUG25529B - Problem displaying MT94x message (Reopen)        *
      *  BUG24278 -  Improper handling of /IACC/Dn indicator          *
      *  BUG24387 -  Subfields 00 and 10 are missing                  *
      *  BUG24304 -  Error reformatting to STRCT format               *
      *  BUG23742 -  Improper handling of Ext Narr from Batch         *
      *              Interface Input                                  *
      *  BUG23280D - Extended Narrative incorrectly displayed in      *
      *              MT942/MT940                                      *
      *  BUG23280B - Extended Narrative incorrectly displayed in      *
      *              MT942/MT940                                      *
      *  BUG23040A - MMM does not reformat Multicash MT942 with       *
      *             /IACC/Dn indicator                                *
      *  BUG23280A - Extended Narrative incorrectly displayed in      *
      *              MT942/MT940                                      *
      *  BUG23284 - Wrong Field 61 subfield 6 for SWIFT               *
      *  BUG23208 - Errors in MT940 for structured MTCASH messages    *
      *  BUG23190 - Field 86 does not comply with MultiCash rules     *
      *  BUG22995 - Wrong GVC code output in field 86                 *
      *  BUG22687 - Various error on MT94x generation                 *
      *  CER030 - Multicash German Feature                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  Database Error Indicators                                    *
      *                                                               *
      *    U7         Abnormal Completion                             *
      *    U8         File Out of Balance                             *
      *    U7 + U8    Database Error                                  *
      *                                                               *
      *  Other Indicators                                             *
      *                                                               *
      *    99         Multi-purpose                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrRtvDetail - Retrieve Details                               *
      *  SrExtractTrTp - Extract data for Transaction Type            *
      *  SrExtract20 - Extract data for field 20                      *
      *  SrExtract21 - Extract data for field 21                      *
      *  SrExtract25 - Extract data for field 25                      *
      *  SrSF61F6 - Populate Sub field 61 of field 6                  *
      *  SrAccDet - Retrive network account details from transaction  *                    BUG23280A
      *  SrNwrk - Find network linked to transaction                  *                    BUG23280A
      *  SrExtract86 - Extract data for field 86                      *
      *  *INZSR - Program Initialisation routine                      *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas GL Account Posting Extension by Reference ID and Number
      *
     FGLAPSTL0  IF   E           K DISK                   INFSR(*PSSR)
      *
      ** Midas FT Inc. Payments
      *
     FINPAY     IF   E           K DISK                   INFSR(*PSSR)
      *
      ** Midas FT Out. Payments
      *
     FOTPAY     IF   E           K DISK                   INFSR(*PSSR)
      *
      ** Midas GL Journal Entry - Additional Information
      *
     FGLJENXL2  IF   E           K DISK                   INFSR(*PSSR)
     F                                                    PREFIX(G_)
      *                                                                                     BUG23742
      ** Midas GL Journal Entry - Multicash Narratives                                      BUG23742
      *                                                                                     BUG23742
     FGLMNARL1  IF   E           K DISK                   INFSR(*PSSR)                      BUG23742
      *                                                                                    BUG23280A
      ** Chain Retail Account                                                              BUG23280A
      *                                                                                    BUG23280A
     FACNUMA    IF   E           K DISK    INFSR(*PSSR)                                    BUG23280A
      *                                                                                    BUG23280A
     FGLJENPL0  IF   E           K DISK                   INFSR(*PSSR)                     BUG23280A
     F                                                    PREFIX(G1)                       BUG23280A
      *                                                                                    BUG23280A
      ** Midas GL Network Accounts - MT94x                                                 BUG23280A
      *                                                                                    BUG23280A
     FGLNW94L11 IF   E           K DISK                                                    BUG23280A
      *                                                                                    BUG23280A
     FGLNW94L8  IF   E           K DISK    RENAME(GLNW94D0:GLNW94D1)                       BUG23280A
      *
     FMGCONVPD  IF   E           K DISK                   INFSR(*PSSR) USROPN                 CMG008
      ** MG Character Conversion file                                                         CMG008
                                                                                              CMG008
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      ** Program Status Data Structure
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Data Structure for Posting detail in Message Genration Format
      *
     D MLposting     E DS                  EXTNAME(MGX940PD)
     D  MG8620to29                  350A   OVERLAY(MLPosting:653)
     D  MG8630to38                  350A   OVERLAY(MLPosting:1003)                          BUG26814
     D**MG8660to65                  210A   OVERLAY(MLPosting:1178)                          BUG24304
     D  MG8660to65                  210A   OVERLAY(MLPosting:1200)                          BUG24304
      *
      ** Data Structure for Posting detail in General Ledger format
      *
     D GLposting     E DS                  EXTNAME(GLPOSTPD) PREFIX(GL)
     D  WkBatch                       3A   OVERLAY(GLPosting:96)
     D  WkItem                        3A   OVERLAY(GLPosting:99)
     D  WkPstd                        5P 0 OVERLAY(GLPosting:33)                            BUG23742
      *
      ** Data Structure for Customer Details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Externally described DS for branch details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  BQQDFAC      E                     EXTFLD(QQDFAC)
      *
      **  Data Structure for Account Details
      *
     D GLACCNT       E DS                  EXTNAME(ACCNTAB)
      *
      ** External DS for SAR Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SC_LCD        E                     EXTFLD(LCD)
      *
      ** DS for Access Programs, Short Data Structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for access programs, very long data structure
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
     D SDNTTI        E DS                  EXTNAME(SDNTTIPD)
      *                                                                                     BUG26814
     D SDSVAL        E DS                  EXTNAME(SDSVALPD)                                BUG26814
      *
     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)
      *                                                                                    BUG23280A
     D DSNwrk        E DS                  EXTNAME(SDNWRKPD)                               BUG23280A
     D                                     PREFIX(N_)                                      BUG23280A
      *                                                                                    BUG23280A
      ** External DS for account details                                                   BUG23280A
      *                                                                                    BUG23280A
     D PACCN         E DS                  EXTNAME(ACCNTAB)                                BUG23280A
     D                                     PREFIX(IB)                                      BUG23280A
      ** External data structure for Nostro customer number                                BUG23280A
      *                                                                                    BUG23280A
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                               BUG23280A
     D S_QQACCD      E                     EXTFLD(QQACCD)                                  BUG23280A
      *
     D                 DS
      *
      ** Arrays to retrieve Module Transaction according Deal Type
      *
     D TransType                     40    DIM(41) CTDATA PERRCD(1)
     D    TrDealType                  2    OVERLAY(TransType)
     D      TrFiller1                 1    OVERLAY(TransType:*NEXT)
     D    TrModuleID                  2    OVERLAY(TransType:*NEXT)
     D      TrFiller2                 1    OVERLAY(TransType:*NEXT)
     D    TrDescrip                  34    OVERLAY(TransType:*NEXT)
      *                                                                                     BUG26814
     D WFldLen1                       2  0 DIM(26) CTDATA PERRCD(26)                        BUG26814
     D WFldLen2                       2  0 DIM(26) CTDATA PERRCD(26)                        BUG26814
      *
     D ORDCST          DS            35                                                    BUG23280A
     D  WSORC1                 1     35                                                    BUG23280A
     D  IBAN1                  1     34                                                    BUG23280A
     D  IBAN2                  2     35                                                    BUG23280A
      *                                                                                    BUG23280A
     D  ONUM                   1      6                                                    BUG23280A
     D  ORET                   1     10                                                    BUG23280A
     D  OCOD                   7     16                                                    BUG23280A
     D  OSEQ                  17     18                                                    BUG23280A
     D  OBRC                  19     21                                                    BUG23280A
      *                                                                                    BUG23280A
     D  ONUMS                  2      7                                                    BUG23280A
     D  ORETS                  2     11                                                    BUG23280A
     D  OCODS                  8     17                                                    BUG23280A
     D  OSEQS                 18     19                                                    BUG23280A
     D  OBRCS                 20     22                                                    BUG23280A
      *                                                                                    BUG23280A
      ** Destination account for credit extended narrative validations                     BUG23280A
      *                                                                                    BUG23280A
     D DESTAN          DS            35                                                    BUG23280A
     D  WSDST1                 1     35                                                    BUG23280A
      *                                                                                    BUG23280A
     D  DRET                   1     10                                                    BUG23280A
      *                                                                                    BUG23280A
     D  NCUR                   1      3                                                    BUG23280A
     D  NNUM                   4      5                                                    BUG23280A
     D  DNOS                   1      5                                                    BUG23280A
      *                                                                                    BUG23280A
     D  DNUM                   1      6                                                    BUG23280A
     D  DSCY                   7      9                                                    BUG23280A
     D  DCOD                  10     19                                                    BUG23280A
     D  DSEQ                  20     21                                                    BUG23280A
     D  DBRC                  22     24                                                    BUG23280A
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *                                                                                    BUG23280D
      ** Array for storing extended narratives                                             BUG23280D
      *                                                                                    BUG23280D
     D ArrExt          S             65A   DIM(6)                                          BUG23280D
      *                                                                                     BUG24304
      ** Array for storing extended narratives                                              BUG24304
      *                                                                                     BUG24304
     D Arr22           S             35A   DIM(22)                                          BUG24304
      *                                                                                    BUG23280A
      ** Key List Parameters                                                               BUG23280A
      *                                                                                    BUG23280A
     D KBrca           S                   LIKE(N4BRCA)                                    BUG23280A
     D KCNum           S                   LIKE(N4CNUM)                                    BUG23280A
     D KCcy            S                   LIKE(N4CCY)                                     BUG23280A
     D KAccd           S                   LIKE(N4ACCD)                                    BUG23280A
     D KAcsq           S                   LIKE(N4ACSQ)                                    BUG23280A
     D KNaty           S                   LIKE(N4NATY)                                       263479
     D KDstn           S                   LIKE(N4DSTN)                                       263479
      *                                                                                    BUG23280A
     D KNwrk           S                   LIKE(EDNWRK)                                    BUG23280A
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D PCusN           S              6A
     D PAcctCde        S             10A
     D PAcctSeq        S              2A
     D PNwrk           S              6A
     D PMsgTyp         S              3A
     D PBrca           S              3A
     D PRtty           S              5A
     D PReturnOut      S             10A
     D PKey1           S             10A
     D PKyst           S              7A
     D PNarr1          S             65A
     D PNarr2          S             65A
     D PNarr3          S             65A
     D PNarr4          S             65A
     D PNarr5          S             65A
     D PNarr6          S             65A
     D PRetl           S             10A
     D PCcy            S              3A
     D PSValK1         S             20A                                                    BUG26814
     D PSVal1          S            200A                                                    BUG26814
     D PSValK2         S             20A                                                    BUG26814
     D PSVal2          S            200A                                                    BUG26814
     D PSValK3         S             20A                                                    BUG26814
     D PSVal3          S            200A                                                    BUG26814
     D PSValK4         S             20A                                                    BUG26814
     D PSVal4          S            200A                                                    BUG26814
     D PSValK5         S             20A                                                    BUG26814
     D PSVal5          S            200A                                                    BUG26814
     D PSValK6         S             20A                                                    BUG26814
     D PSVal6          S            200A                                                    BUG26814
     D PSValK7         S             20A                                                    BUG26814
     D PSVal7          S            200A                                                    BUG26814
     D PSValK8         S             20A                                                    BUG26814
     D PSVal8          S            200A                                                    BUG26814
     D PSValK9         S             20A                                                    BUG26814
     D PSVal9          S            200A                                                    BUG26814
     D PSValK0         S             20A                                                    BUG26814
     D PSVal0          S            200A                                                    BUG26814
     D Wx              S              5U 0
     D CER031          S              1A
     D WkModuleID      S              2A
     D WkDealType      S              2A
     D WkField6        S              6A
     D WkOrigin        S              1A
     D WkIBANUsed      S              1A
     D WkFTFnd         S              2A
     D*WExtNarr**      S            390A                                                    BUG26814
     D*WExtNarr**      S            650A                                           BUG26814 BUG26853
     D WExtNarr        S            700A                                                    BUG26853
     D WSysPos         S              3P 0                                                  BUG26814
     D WSysVal         S              2A                                                    BUG26814
     D WSysPos1        S              3P 0                                                  BUG26853
     D WBatch          S              3A
     D WItem           S              3P 0
     D WNwrk           S              6A
     D WCpy            S             80A
     D WCnt            S              3S 0                                                  BUG23190
     D WCnt1           S              3S 0                                                  BUG23190
     D WCnt2           S              3S 0                                                  BUG26853
     D WSdntti         S              7A                                                    BUG23284
     D WTrTp           S              5A
     D WPos1           S              3  0                                                 BUG23040A
     D WInd            S              1A                                                   BUG23040A
     D WBrca1          S              3A                                                   BUG23280A
     D*WCusno1**       S              6  0                                          BUG23280A CER059
     D WCusno1         S              6A                                                      CER059
     D WCcy1           S              3A                                                   BUG23280A
     D WAccd1          S             10S 0                                                 BUG23280A
     D WAcsq1          S              2S 0                                                 BUG23280A
     D WCusno          S              6A                                                   BUG23280A
     D WAccd           S             10A                                                   BUG23280A
     D WAcsq           S              2A                                                   BUG23280A
     D WPos            S              3  0                                                 BUG23280A
     D WLen            S              2  0                                                 BUG23280A
     D WTAcno          S             10A                                                   BUG23280A
     D WAcno           S             10  0                                                 BUG23280A
     D WTmp            S            390A                                                   BUG23280A
     D WNarr           S            390A                                                   BUG23280B
     D WLSep           S              2A                                                   BUG23280A
      *                                                                                    BUG23280A
     D PIBan           S             47A                                                   BUG23280A
     D PIBan1          S             34A                                                   BUG23280A
     D PoWith          S             47A                                                   BUG23280A
     D PoNobl          S             34A                                                   BUG23280A
     D WPSp            S              3  0                                                 BUG23280B
     D WSepPos         S              3  0                                                 BUG23280B
     D WLine           S              2  0                                                 BUG23280B
     D WStart          S              3  0                                                 BUG23280B
     D WFlg            S              1A                                                   BUG23280B
     D WString         S            390A                                                   BUG23280B
      *                                                                                    BUG23280A
      *                                                                                    BUG23280A
      ** Parameters for AONOSTR0                                                           BUG23280B
      *                                                                                    BUG23280B
     D P1Rtcd          S              7A                                                   BUG23280B
     D P1Optn          S              7A                                                   BUG23280B
     D P1Cust          S              6A                                                   BUG23280B
     D P1Cycd          S              3A                                                   BUG23280B
     D P1Accd          S             10A                                                   BUG23280B
     D P1Acsn          S              2A                                                   BUG23280B
     D P1Nonb          S              2A                                                   BUG23280B
     D P1Brca          S              3A                                                   BUG23280B
     D P1Cssn          S             10A                                                   BUG23280B
     D P1Pnoi          S              1A                                                   BUG23280B
      *                                                                                    BUG23280B
     D*WIndx****       S              1  0                                        BUG23280D BUG24304
     D WIndx           S              2  0                                                  BUG24304
     D WLiId           S              2  0                                                  BUG24304
     D WLIdx           S              1  0                                                 BUG23280D
     D WRqLin          S              2  0                                                 BUG23280D
     D WRqChr          S              3  0                                                 BUG23280D
     D WLin            S              2  0                                                 BUG23280D
     D WChr            S              3  0                                                 BUG23280D
     D WNoChar         S              3  0                                                 BUG23280D
     D WFmtFlg         S              1A                                                   BUG23280D
     D WFmtStrct       S              1A                                                   BUG23280D
     D WStrct          S              1A                                                   BUG23280D
     D WBlFlg          S              1A                                                   BUG23280D
     D WFldSep         S              1A                                                   BUG23280D
     D*WNarr1****      S            450A                                          BUG23280D BUG26814
     D*WNarr1****      S            650A                                           BUG26814 BUG26853
     D WNarr1          S            700A                                                    BUG26853
     D WExtStr         S             27A                                                   BUG23280D
     D WField          S              3  0                                                 BUG23280D
     D WPsFld          S              3  0                                                 BUG23280D
     D WPsFld1         S              3  0                                                 BUG23280D
     D WPsFld2         S              3  0                                                  BUG26814
     D WSubFld         S              2  0                                                  BUG26814
     D WPsBl           S              3  0                                                 BUG23280D
     D WVal            S              3A                                                   BUG23280D
     D WVal1           S              3A                                                    BUG26853
     D Wk22Flg         S              1A                                                    BUG23742
     D WStrctFlg       S              1A                                                    BUG23742
     D CER030          S              1A                                                    BUG23742
     D WDate           S              5P 0                                                  BUG23742
     D WExt22          S            432A                                                    BUG24304
      *                                                                                    BUG23280D
     D WRefId          S                   LIKE(RFID)
     D WRefNo          S                   LIKE(RFNO)
     D WKeySysVal1     C                   CONST('MT94xFldTags')                            BUG26814
      *
                                                                                              CMG008
     D ValSwiftChr     C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZ+                 CMG008
     D                                            abcdefghijklmnopqrstuvwxyz+                 CMG008
     D                                            0123456789+()?:-/,''. ')                    CMG008
      ** Valid Swift Characters                                                               CMG008
                                                                                              CMG008
     D WBlank          C                   CONST(' ')                                         CMG008
      ** Replacement Blank character                                                          CMG008
                                                                                              CMG008
     D WConvFld        S             65A                                                      CMG008
      ** String to be converted                                                               CMG008
                                                                                              CMG008
     D To_Char         S            100A                                                      CMG008
      ** TO character string                                                                  CMG008
                                                                                              CMG008
     D Fr_Char         S            100A                                                      CMG008
      ** FROM character string                                                                CMG008
                                                                                              CMG008
     D WChrPos         S              3S 0                                                    CMG008
      ** Work field for %CHECK and %REPLACE operation                                         CMG008
                                                                                              CMG008
     D WChrLen         S              3S 0                                                    CMG008
      ** Work field for %SUBST operation                                                      CMG008
                                                                                              CMG008
     D WkBAEX22        S                   LIKE(BAEX22)                                     MD055642
      ** Work field for MultiCash Narrative 22 in file GLMNARPD                             MD055642
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
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
      ** Multicash Flag is 'Y', then 'MTCASH' is send as network to MMM
      *
     C**********         EVAL      MGNWRK = 'MTCASH'                                        BUG22687
     C                   EVAL      MG61S4 = *BLANKS
     C                   EVAL      MG8634 = *BLANKS
     C                   EVAL      MG8635 = *BLANKS
     C                   EVAL      MG8636 = *BLANKS
      *
      ** Retrieve Details
      *
     C                   EXSR      SrRtvDetail
      *
      ** Extract data for Transaction Type
      *
     C                   EXSR      SrExtractTrTp
      *
      ** Extract data for field 20
      *
     C                   EXSR      SrExtract20
      *
      ** Extract data for field 21
      *
     C                   EXSR      SrExtract21
      *
      ** Extract data for field 25
      *
     C                   EXSR      SrExtract25
      *
      ** Populate Sub field 61 of field 6
      *
     C                   EXSR      SrSf61f6
      *                                                                                    BUG23280A
      ** Extract network/separator linked to transaction                                   BUG23280A
      *                                                                                    BUG23280A
     C                   EXSR      SrAccDet                                                BUG23280A
      *
      ** Extract data for field 86
      *
     C                   EXSR      SrExtract86
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRtvDetail - Retrieve Details                               *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SrRtvDetail   BEGSR
      *
     C                   EVAL      WkModuleID = *BLANKS
     C                   EVAL      WkDealType = %SUBST(GLOTTP:1:2)
      *
     C                   SELECT
      *
      ** Lending
      *
     C                   WHEN      GLSPOS = '  GE-LE'
     C                   EVAL      WkModuleID = 'LE'
      *
      ** Dealing
      *
     C                   WHEN      GLSPOS = '  GE-DL'
     C                   EVAL      Wx = 1
     C     WkDealType    LOOKUP    TrDealType(Wx)                         99
      *
     C                   IF        *IN99 = *ON
     C                   EVAL      WkModuleID = TrModuleID(Wx)
     C                   ENDIF
      *
      ** Fund Transfer
      *
     C                   WHEN      GLSPOS = '  GE-FT'
     C                   EVAL      WkModuleID = 'FT'
      *
      ** General Ledger
      *
     C                   WHEN      GLSPOS = '  GE-XF' OR
     C                             GLSPOS = '  GE-XB'
     C                   EVAL      WkModuleID = 'GL'
      *
      ** Securities Trading module
      *
     C                   WHEN      GLSPOS = '  GE-ST'
     C                   EVAL      WkModuleID = 'SE'
      *
      ** Customer Exchange transactions
      *
     C                   WHEN      GLSPOS = '  GE-CE'
     C                   EVAL      WkModuleID = 'RE'
      *
      ** Standing Order
      *
     C                   WHEN      GLSPOS = '  GE-SO'
     C                   EVAL      WkModuleID = 'SO'
      *
     C                   ENDSL
      *
      **  Retail Transaction Type
      *
     C                   IF        %SUBST(GLOTRF:1:2) = '91'
     C                   EVAL      WkField6 = %SUBST(GLOTRF:1:6)
     C     '0123456789'  CHECK     WkField6      Wx
      *
     C                   IF        Wx = 6
     C                   EVAL      WkModuleID = 'RE'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Batch Transaction
      *
     C*****'0123456789'**CHECK     GLSPOS        Wx                                         MD050727
     C     '0123456789'  CHECK     GLSPOS:4      Wx                                         MD050727
      *
      ** Source of Posting contains 6 numeric digits (batch number +
      ** batch item)
      *
     C                   IF        Wx = 7
     C                   EVAL      WkModuleID = 'BA'
     C                   ENDIF
      *
      ** Retrieve FT details
      *
     C                   MOVEL     *BLANKS       WkOrigin
     C                   MOVEL     *BLANKS       WkIBANUsed
     C                   MOVEL     *BLANKS       WkFTFnd
      *
      ** Access transaction details
      *
     C                   IF        WkModuleID = 'FT' AND
     C                                          (GLOTTP = 'IN' OR
     C                                           GLOTTP = 'OP')
     C                   EVAL      *IN99 = *ON
      *
     C                   SELECT
      *
     C                   WHEN      GLOTTP = 'IN'
     C     GLPREF        CHAIN     INPAY                              99
      *
     C                   WHEN      GLOTTP = 'OP'
     C     GLPREF        CHAIN     OTPAY                              99
      *
     C                   ENDSL
      *
      ** Retrieve MultiCash Type
      *
     C                   IF        *IN99 = *OFF
     C                   MOVEL     GLOTTP        WkFTFnd
     C                   MOVEL     BBI3          WkOrigin
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Retrieve the network details
      *
     C                   CALL      'AONWRKR1'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      MGNWRK        PNwrk
     C     SDNWRK        PARM      SDNWRK        DSLDY
      *
     C                   EVAL      MG86FM = EDF86F
     C                   EVAL      MG86LN = EDNOLN
     C                   EVAL      MG86LH = EDNCLN
      *
     C                   EVAL      WLin = EDNOLN                                           BUG23280D
     C                   EVAL      WChr = EDNCLN                                           BUG23280D
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExtractTrTp - Extract data for Transaction Type            *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls : *PSSR                                                *
      *                                                               *
      *****************************************************************
      *
     C     SrExtractTrTp BEGSR
      *
     C                   EVAL      MGTRAT = GLTRAT
     C                   MOVE      GLTRAT        WTrTp
      *
     C                   CALL      'AONTTIR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      WTrTp         PRtty
     C                   PARM      MGNWRK        PNwrk
     C     SDNTTI        PARM      SDNTTI        DSFDY
      *
     C**********         IF        PRtcd <> *BLANKS                                         BUG22687
     C**********         EVAL      PReturnOut = 'PSSR_ERROR'                                BUG22687
     C**********         EXSR      *PSSR                                                    BUG22687
     C**********         ELSE                                                               BUG22687
     C                   IF        PRtcd = *BLANKS                                          BUG22687
      *
     C**********         IF        NINTTI <> *BLANKS                                        BUG22995
     C                             AND NINTTI <> *BLANKS                                    BUG22995
     C                   EVAL      MG86GV = NINTTI
     C                   ELSE
      *
     C                   IF        GLDRCR = 0
     C                   EVAL      MG86GV = EDGVCD
     C                   ELSE
     C                   EVAL      MG86GV = EDGVCC
     C                   ENDIF
      *
     C**********         ENDIF                                                              BUG22995
      *
     C                   ENDIF
      *
     C                   IF        MG86GV = *BLANKS
     C                   EVAL      MG86GV = '835'
     C                   ENDIF
      *
      ** Populate PRtcd value to be used for subfield 6 field 61                            BUG23284
      *                                                                                     BUG23284
     C                   EVAL      WSdNtti = PRtcd                                          BUG23284
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExtract20 - Extract data for field 20                      *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SrExtract20   BEGSR
      *
      ** Fixed Transaction Reference Number
      *
     C                   IF        EDFXTR <> *BLANKS
     C                   EVAL      MGFREF = EDFXTR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExtract21 - Extract data for field 21                      *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SrExtract21   BEGSR
      *
     C**********         EVAL      MGFD21 = EDF86F +                                       BUG25529B
     C                   EVAL      MGFD21 = %TRIM(EDF86F) +                                BUG25529B
     C                                      '/' + EDFSEP +
     C                                      '/' + %CHAR(EDNOLN) +
     C                                      '/' + %CHAR(EDNCLN)
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExtract25 - Extract data for field 25                      *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SrExtract25   BEGSR
      *
      ** Retrieve the branch Internal customer(A8BICN)
      *
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      MGBRCA        PBrca
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      ** Error on call
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = MGBRCA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve the Bankleitzahl code(BBBLCD)
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG   '     PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      A8BICN        PKey1
     C                   PARM                    PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   MOVE      MGCNUM        PCusN
     C                   MOVE      MGACCD        PAcctCde
     C                   MOVE      MGACSQ        PAcctSeq
      *
     C                   SELECT
      *
     C                   WHEN      EDACNF = '*IBAN'
      *
      *
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      *BLANKS       PRetl
     C                   PARM                    PCusN
     C                   PARM      MGCCY         PCcy
     C                   PARM                    PAcctCde
     C                   PARM                    PAcctSeq
     C                   PARM      MGBRCA        PBrca
     C     GLACCNT       PARM      GLACCNT       DSSDY
      *
     C                   IF        IBAN <> *BLANKS
     C                   EVAL      MGFD25  = IBAN
     C                   ELSEIF    GLACNO <> *ZEROS
     C                   MOVE      GLACNO        MGFD25
     C                   ELSE
     C                   EVAL      MGFD25 = MGBRCA + PCusN + MGCCY +
     C                                      PAcctcde + PAcctSeq
     C                   ENDIF
      *
     C                   WHEN      EDACNF = '*LEDGER'
     C                   EVAL      MGFD25 = MGBRCA + PCusN + MGCCY +
     C                                      PAcctcde + PAcctSeq
      *
     C                   WHEN      EDACNF = '*RETAIL'
     C                   IF        GLACNO <> *ZEROS
     C                   MOVE      GLACNO        MGFD25
     C                   ELSE
     C                   EVAL      MGFD25 = MGBRCA + PCusN + MGCCY +
     C                                      PAcctcde + PAcctSeq
     C                   ENDIF
      *
     C                   WHEN      EDACNF = '*BLZ'
     C                   IF        GLACNO <> *ZEROS
     C                   EVAL      MGFD25 = BBBLCD + '/' + %CHAR(GLACNO)
     C                   ELSE
     C                   EVAL      MGFD25 = BBBLCD + '/' + MGBRCA +
     C                                      PCusN + MGCCY + PAcctcde +
     C                                      PAcctSeq
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSF61F6 - Populate Sub field 61 of field 6                  *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SrSF61F6      BEGSR
      *
     C                   IF        WkModuleID <> 'FT' AND
     C                             (GLSPOS <>  '  GE-CX' OR
     C                             GLMGZ616 = *BLANKS)
     C                             AND WSdntti = *BLANKS                                    BUG23284
      *
     C                   EVAL      %SUBST(MGSFD6:1:1) = 'N'
     C                   EVAL      %SUBST(MGSFD6:2:3) = NINTTI
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrExtract86 - Extract data for field 86                      *
      *                                                               *
      *  Called by : Main Processing                                  *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SrExtract86   BEGSR
      *
     C                   EVAL      Wk22Flg = 'N'                                            BUG23742
      *                                                                                     BUG23742
     C                   IF        WkModuleID = 'BA' AND CER030 = 'Y'                       BUG23742
     C     KNarr1        CHAIN     GLMNARL1                                                 BUG23742
     C                   IF        %FOUND(GLMNARL1)                                         BUG23742
     C                   EVAL      Wk22Flg = 'Y'                                            BUG23742
     C                   MOVE      *BLANKS       MG8620to29                                 BUG26351
     C                   MOVE      *BLANKS       MG8660to65                                 BUG26351
     C                   ENDIF                                                              BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   IF        PMsgTyp = '940'
      *
     C                   IF        CER031 = 'Y'
     C                             AND Wk22Flg = 'N'                                        BUG23742
      *                                                                                     BUG23742
     C                   EVAL      WRefId = GLXRFI
     C                   EVAL      WRefNo = GLXRFN
      *
     C     KRef          CHAIN     GLAPSTL0
     C                   IF        %FOUND(GLAPSTL0)
      *
     C**********         IF        EDF86F = 'STRCT'                                        BUG23280B
     C**********         EVAL      WExtNarr = PSNAR1 + PSNAR2 +                            BUG23280B
     C**********                              PSNAR3 + PSNAR4 +                            BUG23280B
     C**********                              PSNAR5 + PSNAR6                              BUG23280B
     C**********         ELSE                                                              BUG23280B
     C                   EVAL      MGADI1 = PSNAR1
     C                   EVAL      MGADI2 = PSNAR2
     C                   EVAL      MGADI3 = PSNAR3
     C                   EVAL      MGADI4 = PSNAR4
     C                   EVAL      MGADI5 = PSNAR5
     C                   EVAL      MGADI6 = PSNAR6
     C**********         ENDIF                                                             BUG23280B
      *
     C                   ELSE                                                               BUG23208
      *                                                                                     BUG23208
     C**********         IF        EDF86F = 'STRCT'                               BUG23208 BUG23280B
     C**********         EVAL      WExtNarr = GLMGADI1 + GLMGADI2 +               BUG23208 BUG23280B
     C**********                              GLMGADI3 + GLMGADI4 +               BUG23208 BUG23280B
     C**********                              GLMGADI5 + GLMGADI6                 BUG23208 BUG23280B
     C**********         ELSE                                                     BUG23208 BUG23280B
      *                                                                                     BUG23208
     C                   EVAL      MGADI1 = GLMGADI1                                        BUG23208
     C                   EVAL      MGADI2 = GLMGADI2                                        BUG23208
     C                   EVAL      MGADI3 = GLMGADI3                                        BUG23208
     C                   EVAL      MGADI4 = GLMGADI4                                        BUG23208
     C                   EVAL      MGADI5 = GLMGADI5                                        BUG23208
     C                   EVAL      MGADI6 = GLMGADI6                                        BUG23208
     C                                                                                      BUG23208
     C                   ENDIF                                                              BUG23208
      *                                                                                     BUG23208
     C**********         ENDIF                                                    BUG23208 BUG23280B
      *
     C                   ELSE
     C**********         EVAL      WExtNarr = MGADI1 + MGADI2 +                            BUG23280B
     C                   EVAL      WNarr    = MGADI1 + MGADI2 +                            BUG23280B
     C                                        MGADI3 + MGADI4 +
     C                                        MGADI5 + MGADI6
      *
     C                   ENDIF
      *
     C                   ELSEIF    PMsgTyp = '942'
      *
     C                   IF        CER031 = 'Y'
      *
     C                   SELECT
      *
     C                   WHEN      WkModuleID = 'BA'
     C                             AND Wk22Flg = 'N'                                        BUG23742
     C     KBatch        CHAIN     GLJENXL2
      *
     C                   IF        %FOUND(GLJENXL2)
     C**********         IF        EDF86F = 'STRCT'                                        BUG23280B
     C**********         EVAL      WExtNarr = G_BAADI1 + G_BAADI2 +                        BUG23280B
     C**********                              G_BAADI3 + G_BAADI4 +                        BUG23280B
     C**********                              G_BAADI5 + G_BAADI6                          BUG23280B
     C**********         ELSE                                                              BUG23280B
     C                   EVAL      MGADI1 = G_BAADI1
     C                   EVAL      MGADI2 = G_BAADI2
     C                   EVAL      MGADI3 = G_BAADI3
     C                   EVAL      MGADI4 = G_BAADI4
     C                   EVAL      MGADI5 = G_BAADI5
     C                   EVAL      MGADI6 = G_BAADI6
     C**********         ENDIF                                                             BUG23280B
      *
     C                   ENDIF
      *
     C                   WHEN      GLOTTP = 'IN'
     C     GLPREF        CHAIN     INPAY
      *
     C                   IF        %FOUND(INPAY)
     C**********         IF        EDF86F = 'STRCT'                                        BUG23280B
     C**********         EVAL      WExtNarr = IEXT1 + IEXT2 +                              BUG23280B
     C**********                              IEXT3 + IEXT4 +                              BUG23280B
     C**********                              IEXT5 + IEXT6                                BUG23280B
     C**********         ELSE                                                              BUG23280B
     C                   EVAL      MGADI1 = IEXT1
     C                   EVAL      MGADI2 = IEXT2
     C                   EVAL      MGADI3 = IEXT3
     C                   EVAL      MGADI4 = IEXT4
     C                   EVAL      MGADI5 = IEXT5
     C                   EVAL      MGADI6 = IEXT6
     C**********         ENDIF                                                             BUG23280B
     C                   ENDIF
      *
     C                   WHEN      GLOTTP = 'OP'
     C     GLPREF        CHAIN     OTPAY
      *
     C                   IF        %FOUND(OTPAY)
      *
     C                   IF        GLDRCR = 0
     C**********         IF        EDF86F = 'STRCT'                                        BUG23280B
     C**********         EVAL      WExtNarr = OPEXT1 + OPEXT2 +                            BUG23280B
     C**********                              OPEXT3 + OPEXT4 +                            BUG23280B
     C**********                              OPEXT5 + OPEXT6                              BUG23280B
     C**********         ELSE                                                              BUG23280B
     C                   EVAL      MGADI1 = OPEXT1
     C                   EVAL      MGADI2 = OPEXT2
     C                   EVAL      MGADI3 = OPEXT3
     C                   EVAL      MGADI4 = OPEXT4
     C                   EVAL      MGADI5 = OPEXT5
     C                   EVAL      MGADI6 = OPEXT6
     C**********         ENDIF                                                             BUG23280B
      *
     C                   ELSEIF    GLDRCR = 1
     C**********         IF        EDF86F = 'STRCT'                                        BUG23280B
     C**********         EVAL      WExtNarr = OPEXC1 + OPEXC2 +                            BUG23280B
     C**********                              OPEXC3 + OPEXC4 +                            BUG23280B
     C**********                              OPEXC5 + OPEXC6                              BUG23280B
     C**********         ELSE                                                              BUG23280B
     C                   EVAL      MGADI1 = OPEXC1
     C                   EVAL      MGADI2 = OPEXC2
     C                   EVAL      MGADI3 = OPEXC3
     C                   EVAL      MGADI4 = OPEXC4
     C                   EVAL      MGADI5 = OPEXC5
     C                   EVAL      MGADI6 = OPEXC6
     C**********         ENDIF                                                             BUG23280B
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ELSE
     C**********         EVAL      WExtNarr = MGADI1 + MGADI2 +                            BUG23280B
     C                   EVAL      WNarr    = MGADI1 + MGADI2 +                            BUG23280B
     C                                        MGADI3 + MGADI4 +
     C                                        MGADI5 + MGADI6
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG23742
      ** If input is coming as 22 * 35 structure                                            BUG23742
      *                                                                                     BUG23742
     C                   IF        Wk22Flg = 'Y'                                            BUG23742
     C                   EVAL      WStrctFlg = 'Y'                                          BUG23742
      *                                                                                     BUG23742
     C                   EVAL      WPos1 = *ZEROS                                           BUG23742
     C                   IF        BAEX1 <> *BLANKS                                         BUG23742
     C                             AND EDF86F = 'STRCT'                                     BUG23742
     C**********         EVAL      WPos1 = %SCAN('/IACC/D1':BAEX1)                 BUG23742 BUG24278
     C                   EVAL      WPos1 = %SCAN('/IACC/D':BAEX1)                           BUG24278
      *                                                                                     BUG23742
     C                   IF        WPos1 > 0                                                BUG23742
      *                                                                                     BUG24278
     C                   EVAL      WInd = %SUBST(BAEX1:WPos1+7:1)                           BUG24278
      *                                                                                     BUG24278
     C                   IF        WInd = '0' OR WInd = '1' OR                              BUG24278
     C                             WInd = '2' OR WInd = '3'                                 BUG24278
     C                   EVAL      WStrctFlg = 'N'                                          BUG23742
     C                   ENDIF                                                              BUG24278
     C                   ENDIF                                                              BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   IF        WStrctFlg = 'Y' AND EDF86F ='STRCT'                      BUG23742
     C                             AND N_EDF86F = 'STRCT'                                   BUG24304
     C                   EVAL      MG86GV = %SUBST(BAEX1:1:3)                               BUG23742
     C                   EVAL      MG8600 = %SUBST(BAEX2 :1:27)                             BUG23742
     C                   EVAL      MG8610 = %SUBST(BAEX3:1:10)                              BUG23742
     C                   EVAL      MG8620 = %SUBST(BAEX4:1:27)                              BUG23742
     C                   EVAL      MG8621 = %SUBST(BAEX5:1:27)                              BUG23742
     C                   EVAL      MG8622 = %SUBST(BAEX6:1:27)                              BUG23742
     C                   EVAL      MG8623 = %SUBST(BAEX7:1:27)                              BUG23742
     C                   EVAL      MG8624 = %SUBST(BAEX8:1:27)                              BUG23742
     C                   EVAL      MG8625 = %SUBST(BAEX9:1:27)                              BUG23742
     C                   EVAL      MG8626 = %SUBST(BAEX10:1:35)                             BUG23742
     C                   EVAL      MG8627 = %SUBST(BAEX11:1:35)                             BUG23742
     C                   EVAL      MG8628 = %SUBST(BAEX12:1:35)                             BUG23742
     C                   EVAL      MG8629 = %SUBST(BAEX13:1:35)                             BUG23742
     C                   EVAL      MG8630 = %SUBST(BAEX14:1:10)                             BUG23742
     C                   EVAL      MG8631 = %SUBST(BAEX15:1:24)                             BUG23742
     C                   EVAL      MG8632 = %SUBST(BAEX16:1:27)                             BUG23742
     C                   EVAL      MG8633 = %SUBST(BAEX17:1:27)                             BUG23742
     C                   EVAL      MG8634 = %SUBST(BAEX18:1:3)                              BUG23742
     C                   EVAL      MG8638 = %SUBST(BAEX19:1:34)                             BUG23742
     C                   EVAL      MG8660 = %SUBST(BAEX20:1:35)                             BUG23742
     C                   EVAL      MG8661 = %SUBST(BAEX21:1:35)                             BUG23742
     C                   EVAL      MG8662 = %SUBST(BAEX22:1:35)                             BUG23742
      *                                                                                     BUG24304
     C                   ELSEIF    WStrctFlg = 'Y' AND EDF86F = 'STRCT'                     BUG24304
     C                             AND N_EDF86F <> 'STRCT'                                  BUG24304
      *                                                                                     BUG24304
     C                   EVAL      WStrct = 'N'                                             BUG24304
     C                   EVAL      WIndx = 1                                                BUG24304
     C                   EVAL      WLiId = 0                                                BUG24304
     C                   EVAL      WNoChar = *ZEROS                                         BUG24304
      *                                                                                     BUG24304
      ** Move values to an array                                                            BUG24304
      *                                                                                     BUG24304
     C                   EVAL      Arr22(1) = BAEX1                                         BUG24304
     C                   EVAL      Arr22(2) = BAEX2                                         BUG24304
     C                   EVAL      Arr22(3) = BAEX3                                         BUG24304
     C                   EVAL      Arr22(4) = BAEX4                                         BUG24304
     C                   EVAL      Arr22(5) = BAEX5                                         BUG24304
     C                   EVAL      Arr22(6) = BAEX6                                         BUG24304
     C                   EVAL      Arr22(7) = BAEX7                                         BUG24304
     C                   EVAL      Arr22(8) = BAEX8                                         BUG24304
     C                   EVAL      Arr22(9) = BAEX9                                         BUG24304
     C                   EVAL      Arr22(10) = BAEX10                                       BUG24304
     C                   EVAL      Arr22(11) = BAEX11                                       BUG24304
     C                   EVAL      Arr22(12) = BAEX12                                       BUG24304
     C                   EVAL      Arr22(13) = BAEX13                                       BUG24304
     C                   EVAL      Arr22(14) = BAEX14                                       BUG24304
     C                   EVAL      Arr22(15) = BAEX15                                       BUG24304
     C                   EVAL      Arr22(16) = BAEX16                                       BUG24304
     C                   EVAL      Arr22(17) = BAEX17                                       BUG24304
     C                   EVAL      Arr22(18) = BAEX18                                       BUG24304
     C                   EVAL      Arr22(19) = BAEX19                                       BUG24304
     C                   EVAL      Arr22(20) = BAEX20                                       BUG24304
     C                   EVAL      Arr22(21) = BAEX21                                       BUG24304
     C                   EVAL      Arr22(22) = BAEX22                                       BUG24304
      *                                                                                     BUG24304
      ** Get Number of lines/chars in extended narratives                                   BUG24304
      *                                                                                     BUG24304
     C                   DOW       WIndx < 23                                               BUG24304
     C                   EVAL      WNoChar = %LEN(%TRIM(Arr22(WIndx)))                      BUG24304
      *                                                                                     BUG24304
     C                   IF        WNoChar > *ZEROS                                         BUG24304
     C                   EVAL      WLiId = WLiId + 1                                        BUG24304
      *                                                                                     BUG24304
     C                   IF        WNoChar > 27  OR WLiId > 16                              BUG24304
     C                   EVAL      WStrct = 'Y'                                             BUG24304
     C                   LEAVE                                                              BUG24304
     C                   ENDIF                                                              BUG24304
      *                                                                                     BUG24304
     C                   ENDIF                                                              BUG24304
     C                   EVAL      WIndx = WIndx + 1                                        BUG24304
     C                   ENDDO                                                              BUG24304
      *                                                                                     BUG24304
     C                   IF        WStrct    = 'Y'                                          BUG24304
      *                                                                                     BUG24304
      ** If Wrap Text for requesting network is 'Y'                                         BUG24304
      *                                                                                     BUG24304
     C                   IF        EDWTXT = 'Y'                                             BUG24304
     C                   EXSR      SrMtDiv27                                                BUG24304
      *                                                                                     BUG24304
      ** Else if truncate is set for the network                                            BUG24304
      *                                                                                     BUG24304
     C                   ELSE                                                               BUG24304
      *                                                                                     BUG24304
     C                   EVAL      MG8620 = %SUBST(BAEX1:1:27)                              BUG24304
     C                   EVAL      MG8621 = %SUBST(BAEX2:1:27)                              BUG24304
     C                   EVAL      MG8622 = %SUBST(BAEX3:1:27)                              BUG24304
     C                   EVAL      MG8623 = %SUBST(BAEX4:1:27)                              BUG24304
     C                   EVAL      MG8624 = %SUBST(BAEX5:1:27)                              BUG24304
     C                   EVAL      MG8625 = %SUBST(BAEX6:1:27)                              BUG24304
     C                   EVAL      MG8626 = %SUBST(BAEX7:1:27)                              BUG24304
     C                   EVAL      MG8627 = %SUBST(BAEX8:1:27)                              BUG24304
     C                   EVAL      MG8628 = %SUBST(BAEX9:1:27)                              BUG24304
     C                   EVAL      MG8629 = %SUBST(BAEX10:1:27)                             BUG24304
     C                   EVAL      MG8660 = %SUBST(BAEX11:1:27)                             BUG24304
     C                   EVAL      MG8661 = %SUBST(BAEX12:1:27)                             BUG24304
     C                   EVAL      MG8662 = %SUBST(BAEX13:1:27)                             BUG24304
     C                   EVAL      MG8663 = %SUBST(BAEX14:1:27)                             BUG24304
     C                   EVAL      MG8664 = %SUBST(BAEX15:1:27)                             BUG24304
     C                   EVAL      MG8665 = %SUBST(BAEX16:1:27)                             BUG24304
     C                   ENDIF                                                              BUG24304
      *                                                                                     BUG24304
      ** No formatting required                                                             BUG24304
      *                                                                                     BUG24304
     C                   ELSE                                                               BUG24304
     C                   EVAL      MG8620 = %TRIM(BAEX1)                                    BUG24304
     C                   EVAL      MG8621 = %TRIM(BAEX2)                                    BUG24304
     C                   EVAL      MG8622 = %TRIM(BAEX3)                                    BUG24304
     C                   EVAL      MG8623 = %TRIM(BAEX4)                                    BUG24304
     C                   EVAL      MG8624 = %TRIM(BAEX5)                                    BUG24304
     C                   EVAL      MG8625 = %TRIM(BAEX6)                                    BUG24304
     C                   EVAL      MG8626 = %TRIM(BAEX7)                                    BUG24304
     C                   EVAL      MG8627 = %TRIM(BAEX8)                                    BUG24304
     C                   EVAL      MG8628 = %TRIM(BAEX9)                                    BUG24304
     C                   EVAL      MG8629 = %TRIM(BAEX10)                                   BUG24304
     C                   EVAL      MG8660 = %TRIM(BAEX11)                                   BUG24304
     C                   EVAL      MG8661 = %TRIM(BAEX12)                                   BUG24304
     C                   EVAL      MG8662 = %TRIM(BAEX13)                                   BUG24304
     C                   EVAL      MG8663 = %TRIM(BAEX14)                                   BUG24304
     C                   EVAL      MG8664 = %TRIM(BAEX15)                                   BUG24304
     C                   EVAL      MG8665 = %TRIM(BAEX16)                                   BUG24304
     C                   ENDIF                                                              BUG24304
      *                                                                                     BUG23742
      ** If requested format is not 'STRCT' pass to msg generation                          BUG23742
      *                                                                                     BUG23742
     C                   ELSE                                                               BUG23742
     C                   EVAL      MGADI1 = BAEX1                                           BUG23742
     C                   EVAL      MGADI2 = BAEX2                                           BUG23742
     C                   EVAL      MGADI3 = BAEX3                                           BUG23742
     C                   EVAL      MGADI4 = BAEX4                                           BUG23742
     C                   EVAL      MGADI5 = BAEX5                                           BUG23742
     C                   EVAL      MGADI6 = BAEX6                                           BUG23742
     C                   EVAL      MG8621 = BAEX7                                           BUG23742
     C                   EVAL      MG8622 = BAEX8                                           BUG23742
     C                   EVAL      MG8623 = BAEX9                                           BUG23742
     C                   EVAL      MG8624 = BAEX10                                          BUG23742
     C                   EVAL      MG8625 = BAEX11                                          BUG23742
     C                   EVAL      MG8626 = BAEX12                                          BUG23742
     C                   EVAL      MG8627 = BAEX13                                          BUG23742
     C                   EVAL      MG8628 = BAEX14                                          BUG23742
     C                   EVAL      MG8629 = BAEX15                                          BUG23742
     C                   EVAL      MG8660 = BAEX16                                          BUG23742
     C                   EVAL      MG8661 = BAEX17                                          BUG23742
     C                   EVAL      MG8662 = BAEX18                                          BUG23742
     C                   EVAL      MG8663 = BAEX19                                          BUG23742
     C                   EVAL      MG8664 = BAEX20                                          BUG23742
     C                   EVAL      MG8665 = BAEX21                                          BUG23742
     C                   EVAL      MG8632 = BAEX22                                          BUG23742
     C                   EVAL      MG8633 = N_EDNWRK                                        BUG23742
     C                   EVAL      MG8635 = 'Y'                                             BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   ELSE                                                               BUG23742
      *                                                                                    BUG23280B
      ** Merge all extended narratives to make a string of 390                             BUG23280B
      *                                                                                    BUG23280B
     C                   EVAL      WNarr = MGADI1 + MGADI2 +                               BUG23280B
     C                                     MGADI3 + MGADI4 +                               BUG23280B
     C                                     MGADI5 + MGADI6                                 BUG23280B
      *                                                                                    BUG23280B
      *                                                                                    BUG23280A
      ** Remove original line separators from extended narratives                          BUG23280A
      *                                                                                    BUG23280A
     C**********         EVAL      WTmp = *BLANKS                                BUG23280A BUG23280B
      *                                                                                    BUG23280A
     C**********         IF        WLSep <> *BLANKS                              BUG23280A BUG23280B
      *                                                                                    BUG23280A
     C**********         IF        EDF86F = 'STRCT'                              BUG23280A BUG23280B
     C**********         EVAL      WTmp = WExtNarr                               BUG23280A BUG23280B
     C**********         ELSE                                                    BUG23280A BUG23280B
     C**********         EVAL      WTmp =  MGADI1 + MGADI2 +                     BUG23280A BUG23280B
     C**********                           MGADI3 + MGADI4 +                     BUG23280A BUG23280B
     C**********                           MGADI5 + MGADI6                       BUG23280A BUG23280B
     C**********         ENDIF                                                   BUG23280A BUG23280B
      ** Loop to remove line separator from input ext narr data                            BUG23280A
      *                                                                                    BUG23280A
      *                                                                                    BUG23280A
     C**********         EVAL      WLen = %LEN(%TRIM(WLSep))                     BUG23280A BUG23280B
     C**********         EVAL      WPos = %SCAN(%TRIM(WLSep):WTmp)               BUG23280A BUG23280B
      *                                                                                    BUG23280A
     C**********         IF        WPos > *ZEROS                                 BUG23280A BUG23280B
     C**********         DOW       WPos > *ZEROS                                 BUG23280A BUG23280B
     C**********         EVAL      WTmp = %REPLACE('':WTmp:WPos:WLen)            BUG23280A BUG23280B
     C**********         EVAL      WPos = %SCAN(%TRIM(WLSep):WTmp)               BUG23280A BUG23280B
     C**********         ENDDO                                                   BUG23280A BUG23280B
      *                                                                          BUG23280A BUG23280B
      ** Move the string back to original variables                                        BUG23280A
      *                                                                                    BUG23280A
     C**********         IF        EDF86F = 'STRCT'                              BUG23280A BUG23280B
     C**********         EVAL      WExtNarr = WTmp                               BUG23280A BUG23280B
     C**********         ELSE                                                    BUG23280A BUG23280B
     C**********         EVAL      MGADI1 = %SUBST(WTmp :1 :65)                  BUG23280A BUG23280B
     C**********         EVAL      MGADI2 = %SUBST(WTmp :66 :65)                 BUG23280A BUG23280B
     C**********         EVAL      MGADI3 = %SUBST(WTmp :131 :65)                BUG23280A BUG23280B
     C**********         EVAL      MGADI4 = %SUBST(WTmp :196 :65)                BUG23280A BUG23280B
     C**********         EVAL      MGADI5 = %SUBST(WTmp :261 :65)                BUG23280A BUG23280B
     C**********         EVAL      MGADI6 = %SUBST(WTmp :326 :65)                BUG23280A BUG23280B
     C**********         ENDIF                                                   BUG23280A BUG23280B
      *                                                                                    BUG23280A
     C**********         ENDIF                                                   BUG23280A BUG23280B
     C**********         ENDIF                                                   BUG23280A BUG23280B
      *
     C                   EVAL      WSepPos = *ZEROS                                        BUG23280B
     C                   IF        WLSep <> *BLANKS                                        BUG23280B
     C                   EVAL      WSepPos = %SCAN(%TRIM(WLSep):WNarr)                     BUG23280B
     C                   EVAL      WLen = %LEN(%TRIM(WLSep))                               BUG23280B
     C                   ENDIF                                                             BUG23280B
     C                   EVAL      WExtNarr = WNarr                                        BUG23280B
      *                                                                                    BUG23280B
     C                   EVAL      WPos1 = *ZEROS                                          BUG23040A
     C                   IF        WExtNarr <> *BLANKS                                     BUG23040A
     C                             AND EDF86F = 'STRCT'                                    BUG23280B
     C                   EVAL      WPos1 = %SCAN('/IACC/D':WExtNarr)                       BUG23040A
      *                                                                                    BUG23040A
     C                   IF        WPos1 > 0                                               BUG23040A
      *                                                                                    BUG23040A
     C                   EVAL      WInd = %SUBST(WExtNarr:WPos1+7:1)                       BUG23040A
      *                                                                                    BUG23040A
     C                   IF        WInd = '0' OR WInd = '1' OR                             BUG23040A
     C                             WInd = '2' OR WInd = '3'                                BUG23040A
     C**********         EVAL      MGADI1 = %SUBST(WExtNarr: 1 :65)              BUG23040A BUG23280B
     C**********         EVAL      MGADI2 = %SUBST(WExtNarr:66 :65)              BUG23040A BUG23280B
     C**********         EVAL      MGADI3 = %SUBST(WExtNarr:131 :65)             BUG23040A BUG23280B
     C**********         EVAL      MGADI4 = %SUBST(WExtNarr:196 :65)             BUG23040A BUG23280B
     C**********         EVAL      MGADI5 = %SUBST(WExtNarr:261 :65)             BUG23040A BUG23280B
     C**********         EVAL      MGADI6 = %SUBST(WExtNarr:326 :65)             BUG23040A BUG23280B
     C                   EVAL      WExtNarr = *BLANKS                                      BUG23040A
     C                   ELSE                                                              BUG23040A
     C                   EVAL      WPos1 = *ZEROS                                          BUG23040A
     C                   ENDIF                                                             BUG23040A
      *                                                                                    BUG23040A
     C                   ENDIF                                                             BUG23040A
     C                   ENDIF                                                             BUG23040A
      *                                                                                    BUG23040A
     C                   IF        EDF86F = 'STRCT' AND WPos1 = 0                          BUG23280D
      *                                                                                    BUG23280D
     C                   IF        EDF86F = N_EDF86F                                       BUG23280D
      *                                                                                    BUG23280D
      ** Formatting to be done differently when default network is STRCT                   BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WPsFld  = 0                                             BUG23280D
     C                   IF        N_EDF86F = 'STRCT'                                      BUG23280D
     C                   MOVEL     N_EDFSEP      WVal                                      BUG23280D
     C                   MOVE      '20'          WVal                                      BUG23280D
     C                   EVAL      WPsFld = %SCAN(WVal : Wnarr)                            BUG23280D
     C                   MOVE      '00'          WVal                                       BUG26814
     C                   EVAL      WPsFld2 = %SCAN(WVal : Wnarr)                            BUG26814
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C**********         IF        WPsFld > 0                                     BUG23280D BUG26814
     C                   IF        WPsFld > 0 OR WPsFld2 > 0                                BUG26814
     C                   EVAL      WNarr1 = *BLANKS                                        BUG23280D
     C                   EVAL      WFldSep ='Y'                                            BUG23280D
      *                                                                                    BUG23280D
     C                   EXSR      SrSTFmt                                                 BUG23280D
     C**********         EVAL      WExtNarr =  %SUBST(WNarr1:1:387)               BUG23280D BUG26814
     C                   EVAL      WExtNarr =  WNarr1                                       BUG26814
     C                   EXSR      SrDiv27                                                 BUG23280D
     C                   ELSE                                                              BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WStrct = 'N'                                            BUG23280D
     C                   EVAL      WIndx = 1                                               BUG23280D
     C                   EVAL      WNoChar = *ZEROS                                        BUG23280D
      *                                                                                    BUG23280D
      ** Move values to an array                                                           BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      ArrExt(1) = MGADI1                                      BUG23280D
     C                   EVAL      ArrExt(2) = MGADI2                                      BUG23280D
     C                   EVAL      ArrExt(3) = MGADI3                                      BUG23280D
     C                   EVAL      ArrExt(4) = MGADI4                                      BUG23280D
     C                   EVAL      ArrExt(5) = MGADI5                                      BUG23280D
     C                   EVAL      ArrExt(6) = MGADI6                                      BUG23280D
      *                                                                                    BUG23280D
      ** Get Number of lines/chars in extended narratives                                  BUG23280D
      *                                                                                    BUG23280D
     C                   DOW       WIndx < 7                                               BUG23280D
     C                   EVAL      WNoChar = %LEN(%TRIM(ArrExt(WIndx)))                    BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WNoChar > 27                                            BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WStrct = 'Y'                                            BUG23280D
     C                   EXSR      SrMrgExt                                                BUG23280D
     C                   LEAVE                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
     C                   EVAL      WIndx = WIndx + 1                                       BUG23280D
     C                   ENDDO                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WStrct    = 'Y'                                         BUG23280D
     C                   EXSR      SrDiv27                                                 BUG23280D
      *                                                                                    BUG23280D
     C                   ELSE                                                              BUG23280D
     C                   EVAL      MG8620 = %TRIM(MGADI1)                                  BUG23280D
     C                   EVAL      MG8621 = %TRIM(MGADI2)                                  BUG23280D
     C                   EVAL      MG8622 = %TRIM(MGADI3)                                  BUG23280D
     C                   EVAL      MG8623 = %TRIM(MGADI4)                                  BUG23280D
     C                   EVAL      MG8624 = %TRIM(MGADI5)                                  BUG23280D
     C                   EVAL      MG8625 = %TRIM(MGADI6)                                  BUG23280D
     C                   ENDIF                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   ELSE                                                              BUG23280D
     C                   EVAL      WRqLin = WLin                                           BUG23280D
     C                   EVAL      WRqChr = WChr                                           BUG23280D
      *                                                                                    BUG23280D
     C                   IF        EDF86F= 'STRCT'                                         BUG23280D
     C                   EVAL      WRqLin = 15                                             BUG23280D
     C                   EVAL      WRqChr = 27                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
     C                   IF        N_EDF86F= 'STRCT'                                       BUG23280D
     C                   EVAL      N_EDNOLN =  15                                          BUG23280D
     C                   EVAL      N_EDNCLN = 27                                           BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
      ** No formatting required if requesting and default are STRCT                        BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WFmtStrct = *BLANKS                                     BUG23280D
      *                                                                                    BUG23280D
      ** If No line separators are used in data and either n/w is not STRCT or             BUG23280D
      ** if it is STRCT then /IACC/Dn indicator has been used with it.                     BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WSepPos = *ZEROS                                        BUG23280D
     C                   EVAL      WFmtStrct = 'N'                                         BUG23280D
      *                                                                                    BUG23280D
      ** Move values to an array                                                           BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      ArrExt(1) = MGADI1                                      BUG23280D
     C                   EVAL      ArrExt(2) = MGADI2                                      BUG23280D
     C                   EVAL      ArrExt(3) = MGADI3                                      BUG23280D
     C                   EVAL      ArrExt(4) = MGADI4                                      BUG23280D
     C                   EVAL      ArrExt(5) = MGADI5                                      BUG23280D
     C                   EVAL      ArrExt(6) = MGADI6                                      BUG23280D
      *                                                                                    BUG23280D
      ** Get Number of lines/chars in extended narratives                                  BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WIndx = 1                                               BUG23280D
     C                   EVAL      WLIdx = 1                                               BUG23280D
      *                                                                                    BUG23280D
     C                   DOW       WIndx < 7                                               BUG23280D
     C                   EVAL      WNoChar = %LEN(%TRIM(ArrExt(WIndx)))                    BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WNoChar > *ZEROS                                        BUG23280D
     C                   EVAL      WLIdx = WLIdx + 1                                       BUG23280D
      *                                                                                    BUG23280D
      ** If input no. of lines/chars is greater than requesting n/w's max len/chars        BUG23280D
      ** then formatting is required.                                                      BUG23280D
      ** Calculate for first line chars differently as it may contain /IACC/Dn indicator   BUG23280D
      *                                                                                    BUG23280D
     C                   IF        (WLIdx -1) > WRqLin OR                                  BUG23280D
     C                             WNoChar > WRqChr                                        BUG23280D
     C                   EVAL      WFmtStrct = 'Y'                                         BUG23280D
     C                   LEAVE                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WIndx = WIndx + 1                                       BUG23280D
     C                   ENDDO                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
      *                                                                                    BUG23280B
      ** If Wrap Text for requesting network is 'Y'                                        BUG23280B
      *                                                                                    BUG23280B
     C                   IF        EDWTXT = 'Y'                                            BUG23280B
      *                                                                                    BUG23280B
      ** If no line separator is used in the extended narrative                            BUG23280B
      *                                                                                    BUG23280B
     C                   IF        WSepPos = *ZEROS                                        BUG23280B
     C                   EVAL      WNarr = *BLANKS                                         BUG23280B
     C**********         EVAL      WNarr = %TRIM(MGADI1) + ' '+                  BUG23280B BUG23280D
     C**********                           %TRIM(MGADI2) + ' '+                  BUG23280B BUG23280D
     C**********                           %TRIM(MGADI3) + ' '+                  BUG23280B BUG23280D
     C**********                           %TRIM(MGADI4) + ' '+                  BUG23280B BUG23280D
     C**********                           %TRIM(MGADI5) + ' '+                  BUG23280B BUG23280D
     C**********                           %TRIM(MGADI6)                         BUG23280B BUG23280D
      **********                                                                            BUG26512
     C**********         EVAL      WNarr = %TRIM(MGADI1) + '  '+                  BUG23280D BUG26512
     C**********                           %TRIM(MGADI2) + '  '+                  BUG23280D BUG26512
     C**********                           %TRIM(MGADI3) + '  '+                  BUG23280D BUG26512
     C**********                           %TRIM(MGADI4) + '  '+                  BUG23280D BUG26512
     C**********                           %TRIM(MGADI5) + '  '+                  BUG23280D BUG26512
     C**********                           %TRIM(MGADI6)                          BUG23280D BUG26512
      *                                                                                     BUG26512
     C                   EVAL      WNarr = %TRIM(MGADI1) +                                  BUG26512
     C                                     %TRIM(MGADI2) +                                  BUG26512
     C                                     %TRIM(MGADI3) +                                  BUG26512
     C                                     %TRIM(MGADI4) +                                  BUG26512
     C                                     %TRIM(MGADI5) +                                  BUG26512
     C                                     %TRIM(MGADI6)                                    BUG26512
      *                                                                                     BUG26512
      ** If line separators are present                                                    BUG23280B
      *                                                                                    BUG23280B
     C                   ELSE                                                              BUG23280B
     C                   IF        EDKLSP = 'N' OR (EDKLSP = 'Y' AND                       BUG23280D
     C                             EDNWRK = N_EDNWRK)                                      BUG23280D
     C                   EVAL      WPos = %SCAN(%TRIM(WLSep):WNarr)                        BUG23280B
      *                                                                                    BUG23280B
     C                   DOW       WPos > *ZEROS                                           BUG23280B
     C**********         EVAL      WNarr = %REPLACE(' ':WNarr:WPos:WLen)         BUG23280B BUG23280D
     C                   EVAL      WNarr = %REPLACE('  ':WNarr:WPos:WLen)                  BUG23280D
     C                   EVAL      WPos = %SCAN(%TRIM(WLSep):WNarr)                        BUG23280B
     C                   ENDDO                                                             BUG23280B
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280B
     C                   ENDIF                                                             BUG23280B
      *                                                                                    BUG23280B
      ** If Structured format is used                                                      BUG23280B
      *                                                                                    BUG23280B
     C                   IF        EDF86F = 'STRCT' AND WPos1 = *ZEROS                     BUG23280B
     C                   EVAL      WExtNarr = WNarr                                        BUG23280B
      *                                                                                    BUG23280B
      ** The string should only contain 387 chars and not 390                              BUG23280B
      *                                                                                    BUG23280B
     C                   MOVE      '   '         WExtNarr                                  BUG23280B
     C                                                                                     BUG23280B
     C**********         IF        WExtNarr <> *BLANKS                                     BUG23280B
     C**********         EVAL      MG8620to29 = %SUBST(WExtNarr:1:350)                      BUG23190
     C**********         EVAL      MG8660to65 = %SUBST(WExtNarr:351:40)                     BUG23190
      *                                                                                    BUG23280D
      ** If no formatting required then simply put each ext narr in subfield               BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WFmtStrct = 'N' AND WSepPos = *ZEROS                    BUG23280D
     C                   EVAL      MG8620 = %TRIM(MGADI1)                                  BUG23280D
     C                   EVAL      MG8621 = %TRIM(MGADI2)                                  BUG23280D
     C                   EVAL      MG8622 = %TRIM(MGADI3)                                  BUG23280D
     C                   EVAL      MG8623 = %TRIM(MGADI4)                                  BUG23280D
     C                   EVAL      MG8624 = %TRIM(MGADI5)                                  BUG23280D
     C                   EVAL      MG8625 = %TRIM(MGADI6)                                  BUG23280D
     C                   ELSE                                                              BUG23280D
      *                                                                                     BUG23190
      ** Dividing extended narratives into 27 chars for Details of Payment                  BUG23190
      *                                                                                     BUG23190
     C**********         EVAL      WCnt = 1                                       BUG23190 BUG23280D
     C**********         EVAL      WCnt1 = 1                                      BUG23190 BUG23280D
      *                                                                                     BUG23190
     C**********         DOW       WCnt < 270                                     BUG23190 BUG23280D
     C**********         EVAL      %SUBST(MG8620to29:WCnt1) =                     BUG23190 BUG23280D
     C**********                   %SUBST(WExtNarr:WCnt:27)                       BUG23190 BUG23280D
     C**********         EVAL      WCnt = WCnt + 27                               BUG23190 BUG23280D
     C**********         EVAL      WCnt1 = WCnt1 + 35                             BUG23190 BUG23280D
     C**********         ENDDO                                                    BUG23190 BUG23280D
      *                                                                                     BUG23190
     C**********         EVAL      WCnt1 = 1                                      BUG23190 BUG23280D
     C**********         DOW       WCnt < 379                                     BUG23190 BUG23280D
     C**********         EVAL      %SUBST(MG8660to65:WCnt1) =                     BUG23190 BUG23280D
     C**********                   %SUBST(WExtNarr:WCnt:27)                       BUG23190 BUG23280D
     C**********         EVAL      WCnt = WCnt + 27                               BUG23190 BUG23280D
     C**********         EVAL      WCnt1 = WCnt1 + 35                             BUG23190 BUG23280D
      *                                                                                     BUG23190
     C**********         ENDDO                                                    BUG23190 BUG23280D
      *                                                                                     BUG23190
     C**********         IF        WCnt = 379                                     BUG23190 BUG23280D
     C**********         EVAL      %SUBST(MG8660to65:WCnt1) =                     BUG23190 BUG23280D
     C**********                   %SUBST(WExtNarr:WCnt)                          BUG23190 BUG23280D
     C**********         ENDIF                                                    BUG23190 BUG23280D
      *                                                                                     BUG23190
     C                   EXSR      SrDiv27                                                 BUG23280D
     C                   ENDIF                                                             BUG23280B
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280B
      ** Else if truncate is set for the network                                           BUG23280B
      *                                                                                    BUG23280B
     C                   ELSE                                                              BUG23280B
      *                                                                                    BUG23280B
      ** If no line separator is used in the extended narrative                            BUG23280B
      *                                                                                    BUG23280B
     C                   IF        WSepPos = *ZEROS                                        BUG23280B
      *                                                                                    BUG23280B
     C                   IF        EDF86F = 'STRCT' AND WPos1 = *ZEROS                     BUG23280B
     C                   EVAL      MG8620 = %SUBST(MGADI1:1:27)                            BUG23280B
     C                   EVAL      MG8621 = %SUBST(MGADI2:1:27)                            BUG23280B
     C                   EVAL      MG8622 = %SUBST(MGADI3:1:27)                            BUG23280B
     C                   EVAL      MG8623 = %SUBST(MGADI4:1:27)                            BUG23280B
     C                   EVAL      MG8624 = %SUBST(MGADI5:1:27)                            BUG23280B
     C                   EVAL      MG8625 = %SUBST(MGADI6:1:27)                            BUG23280B
     C                   ENDIF                                                             BUG23280B
      *                                                                                    BUG23280B
      ** If separators are used                                                            BUG23280B
      *                                                                                    BUG23280B
     C                   ELSE                                                              BUG23280B
     C                   IF        EDF86F = 'STRCT' AND WPos1 = *ZEROS                     BUG23280B
     C                   MOVE      '   '         WExtNarr                                  BUG23280B
      *                                                                                    BUG23280B
      ** Loop to pick one extended narrative at a time and truncate                        BUG23280B
      *                                                                                    BUG23280B
     C                   EVAL      WLine = 1                                               BUG23280B
     C                   EVAL      WStart = 1                                              BUG23280B
     C                   EVAL      WCnt1 = 1                                               BUG23280B
      *                                                                                    BUG23280B
      ** Set the no of characters in the Line separator                                    BUG23280B
      *                                                                                    BUG23280B
     C                   EVAL      WPSp= %SCAN(%TRIM(WLSep):WExtNarr)                      BUG23280B
     C                                                                                     BUG23280B
     C                   DOW       WLine  <  17                                            BUG23280B
     C                   EVAL      WString = %SUBST(WExtNarr:                              BUG23280B
     C                                       WStart: (WPSp - WStart))                      BUG23280B
      *                                                                                    BUG23280B
      ** If no data, Leave the loop                                                        BUG23280B
      *                                                                                    BUG23280B
     C                   IF        %SUBST(WExtNarr:WStart) = *BLANKS                       BUG23280B
     C                   LEAVE                                                             BUG23280B
     C                   ENDIF                                                             BUG23280B
      *                                                                                    BUG23280B
     C                   IF        WLine < 11                                              BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      %SUBST(MG8620to29:WCnt1) =                              BUG23280B
     C**********                   %SUBST(WString:1:27)                           BUG23280B BUG26814
     C                             %SUBST(WString:1:WFldLen2(WLine))                        BUG26814
     C**********         EVAL      WCnt1 = WCnt1 + 35                             BUG23280B BUG26814
     C                   EVAL      WCnt1 = WCnt1 + WFldLen1(WLine)                          BUG26814
     C                   EVAL      WLine = WLine + 1                                       BUG23280B
     C                   ELSE                                                              BUG23280D
      *                                                                                     BUG26814
     C                   IF        WLine < 19                                               BUG26814
     C                   EVAL      %SUBST(MG8630to38:WCnt1) =                               BUG26814
     C                             %SUBST(WString:1:WFldLen2(WLine))                        BUG26814
     C                   EVAL      WCnt1 = WCnt1 + WFldLen1(WLine)                          BUG26814
     C                   EVAL      WLine = WLine + 1                                        BUG26814
     C                   ELSE                                                               BUG26814
     C**********         IF        WLine = 11                                     BUG23280D BUG26814
     C                   IF        WLine = 19                                               BUG26814
     C                   EVAL      WCnt1 = 1                                               BUG23280D
     C                   ENDIF                                                             BUG23280D
     C                   EVAL      %SUBST(MG8660to65:WCnt1) =                              BUG23280D
     C**********                   %SUBST(WString:1:27)                           BUG23280D BUG26814
     C                             %SUBST(WString:1:WFldLen2(WLine))                        BUG26814
     C**********         EVAL      WCnt1 = WCnt1 + 35                             BUG23280D BUG26814
     C                   EVAL      WCnt1 = WCnt1 + WFldLen1(WLine)                          BUG26814
     C                   EVAL      WLine = WLine + 1                                       BUG23280D
     C                   ENDIF                                                              BUG26814
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
      *                                                                                    BUG23280B
     C                   IF        WFlg = 'Y'                                              BUG23280B
     C                   LEAVE                                                             BUG23280B
     C                   ENDIF                                                             BUG23280B
     C                   EVAL      WStart = WPSp + WLen                                    BUG23280B
      *                                                                                    BUG23280B
      ** Find the position of the Line Separator                                           BUG23280B
      *                                                                                    BUG23280B
     C                   EVAL      WPSp= %SCAN(%TRIM(WLSep):WExtNarr:WStart)               BUG23280B
     C                   IF        WPSp = *ZEROS                                           BUG23280B
     C                   EVAL      WPSp = %LEN(%TRIM(WExtNarr)) + 1                        BUG23280B
     C                   EVAL      WFlg = 'Y'                                              BUG23280B
     C                   ENDIF                                                             BUG23280B
     C                   ENDDO                                                             BUG23280B
      *                                                                                    BUG23280B
      ** Else , just replace the incoming line separator with the requesting               BUG23280B
      ** network's line separator                                                          BUG23280B
      *                                                                                    BUG23280B
     C**********         ELSE                                                    BUG23280B BUG23280D
      *                                                                                    BUG23280B
     C**********         IF        EDLSEP <> N_EDLSEP                            BUG23280B BUG23280D
     C**********         EVAL      WPos = %SCAN(%TRIM(WLSep):WNarr)              BUG23280B BUG23280D
      *                                                                                    BUG23280B
     C**********         DOW       WPos > *ZEROS                                 BUG23280B BUG23280D
     C**********         EVAL      WNarr = %REPLACE(%TRIM(EDLSEP):WNarr          BUG23280B BUG23280D
     C**********                           :WPos:WLen)                           BUG23280B BUG23280D
     C**********         EVAL      WPos = %SCAN(%TRIM(WLSep):WNarr)              BUG23280B BUG23280D
     C**********         ENDDO                                                   BUG23280B BUG23280D
     C**********         ENDIF                                                   BUG23280B BUG23280D
      *                                                                                    BUG23280B
     C                   ENDIF                                                             BUG23280B
     C                   ENDIF                                                             BUG23280B
     C                   ENDIF                                                             BUG23280B
      *                                                                                    BUG23280B
      ** Divide the changed WNarr into 6 * 65 fields                                       BUG23280B
      *                                                                                    BUG23280B
     C**********         IF        EDF86F <> 'STRCT' OR WPos1 > *ZEROS           BUG23280B BUG23280D
     C**********         EVAL      MGADI1 = %SUBST(WNarr: 1 :65)                 BUG23280B BUG23280D
     C**********         EVAL      MGADI2 = %SUBST(WNarr:66 :65)                 BUG23280B BUG23280D
     C**********         EVAL      MGADI3 = %SUBST(WNarr:131 :65)                BUG23280B BUG23280D
     C**********         EVAL      MGADI4 = %SUBST(WNarr:196 :65)                BUG23280B BUG23280D
     C**********         EVAL      MGADI5 = %SUBST(WNarr:261 :65)                BUG23280B BUG23280D
     C**********         EVAL      MGADI6 = %SUBST(WNarr:326 :65)                BUG23280B BUG23280D
     C**********         ENDIF                                                   BUG23280B BUG23280D
      *                                                                                    BUG23280B
     C                   ENDIF                                                             BUG23280D
     C**********         EVAL      MG8633 = *BLANKS                               BUG23280D BUG26814
      *                                                                                    BUG23280D
      ** Pass default network to Message generation program                                BUG23280D
      *                                                                                    BUG23280D
     C                   ELSE                                                              BUG23280D
     C                   EVAL      MG8633 = N_EDNWRK                                       BUG23280D
     C                   ENDIF                                                             BUG23280D
     C                   ENDIF                                                              BUG24387
      *
      ** For Multicash structured format
      *
     C                   IF        EDF86F = 'STRCT'
     C                             AND WPos1 = *ZEROS                                      BUG23040A
     C                             OR( Wk22Flg = 'Y' AND                                    BUG24387
     C                             WStrctFlg = 'Y' AND EDF86F = 'STRCT'                     BUG24387
     C                             AND N_EDF86F <> 'STRCT' )                                BUG24387
      *
      ** Booking Text
      *
     C                   IF        Wk22Flg = 'Y'                                            BUG25320
     C                             AND BAEX2 <> *BLANKS                                     BUG26780
     C                             AND N_EDF86F = 'STRCT'                                   BUG26780
     C                   EVAL      MG8600 = %SUBST(BAEX2 :1:27)                             BUG25320
     C                   ELSE                                                               BUG25320
     C                   IF        MG8600 = *BLANKS                                         BUG26814
     C                   EVAL      MG8600 = GLPNAR
     C                   ENDIF                                                              BUG26814
     C                   ENDIF                                                              BUG25320
      *
      ** Batch No
      *
     C**********         EVAL      MG8610 = '000'                                           BUG26814
      *
     C                   SELECT
      *
     C                   WHEN      WkModuleId = 'BA'
     C**********         EVAL      MG8610 = WkBatch + '/' + WkItem                          BUG25320
     C                   IF        BAEX3 <> *BLANKS                                         BUG26430
     C                             AND N_EDF86F = 'STRCT'                                   BUG26780
     C                   EVAL      MG8610 = %SUBST(BAEX3:1:10)                              BUG25320
     C                   ELSE                                                               BUG26430
     C                   IF        MG8610 = *BLANKS                                         BUG26814
     C                   EVAL      MG8610 = WkBatch + '/' + WkItem                          BUG26430
     C                   ENDIF                                                              BUG26430
     C                   ENDIF                                                              BUG26814
      *
     C                   WHEN      WkModuleId = 'FT'
     C                   EVAL      MG8610 = %SUBST(GLPREF:6:10)
      *
     C                   WHEN      GLOTRF <> *BLANKS
     C                   EVAL      MG8610 = GLOTRF
      *
     C                   ENDSL
      *                                                                                     BUG26814
     C                   IF        MG8610 = *BLANKS                                         BUG26814
     C                   EVAL      MG8610 = '000'                                           BUG26814
     C                   ENDIF                                                              BUG26814
      *
      ** BSC Ordering Party/Payee
      *
     C                   SELECT
      *
      ** Incoming Payment
      *
     C                   WHEN      WkFTFnd = 'IN'
      *
      ** ?30 - Bank Sort Code - Ordering Bank
      *
     C                   IF        %SUBST(ORB1:1:1) = '/' AND
     C                             %SUBST(ORB1:10:26) = *BLANKS
      *
     C     '0123456789'  CHECK     ORB1:2        Wx
      *
     C                   IF        Wx = 10
     C                   EVAL      MG8630 = %SUBST(ORB1:2:8)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** ?31 - Account Number - Ordering Customer
      *
     C                   IF        WkOrigin <> 'T' AND
     C                             %SUBST(ORC1:1:1) = '/'
     C                   EVAL      MG8631 = %SUBST(ORC1:2:24)
     C                   ENDIF
      *
      ** ?32 - Account Name - Ordering Customer
      *
     C                   IF        %SUBST(ORC2:1:1) <> '.'
     C                   EVAL      MG8632 = ORC2
     C                   ENDIF
      *
      ** ?33 - Account Name - Ordering Customer
      *
     C                   IF        %SUBST(ORC3:1:1) <> '.'
     C                   EVAL      MG8633 = ORC3
     C                   ENDIF
      *
      ** Outgoing Payment
      *
     C                   WHEN      WkFTFnd = 'OP'
      *
      ** ?30 - Bank Sort Code - Account with Bank
      *
     C                   IF        %SUBST(ACB1:9:27) = *BLANKS
     C     '0123456789'  CHECK     ACB1          Wx
      *
     C                   IF        Wx = 9
     C                   EVAL      MG8630 = %SUBST(ACB1:1:8)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** ?31 - Account Number - Beneficiary Customer
      *
     C                   IF        WkOrigin <> 'T' AND
     C                             %SUBST(BNC1:1:1) = '/'
     C                   EVAL      MG8631 = %SUBST(BNC1:2:24)
     C                   ENDIF
      *
      ** ?32 - Account Name - Beneficiary Customer
      *
     C                   IF        %SUBST(BNC2:1:1) <> '.'
     C                   EVAL      MG8632 = BNC2
     C                   ENDIF
      *
      ** ?33 - Account Name - Beneficiary Customer
      *
     C                   IF        %SUBST(BNC3:1:1) <> '.'
     C                   EVAL      MG8633 = BNC3
     C                   ENDIF
      *
     C                   IF        WkIBANUsed = 'Y'
     C                   EVAL      MG8638 = *BLANKS
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C**********         ENDIF                                                     BUG23742 BUG24387
      *                                                                                       CMG008
      ** Convert non-SWIFT chars in Field 86 output fields                                    CMG008
     C                   IF        CMG008 = 'Y'                                               CMG008
     C                   EXSR      SrConvFld86                                                CMG008
     C                   ENDIF                                                                CMG008
      *                                                                                       CMG008
     C                   ENDSR
      *
      *****************************************************************                    BUG23280D
      /EJECT                                                                               BUG23280D
      *****************************************************************                    BUG23280D
     C     SrSTFmt       BEGSR                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WPsFld  = 0                                             BUG23280D
     C                   EVAL      WPsFld1 = 0                                             BUG23280D
     C**********         EVAL      WField  = 1                                    BUG23280D BUG26853
     C                   EVAL      WField  = 4                                              BUG26853
     C                   EVAL      WFlg  = *BLANKS                                         BUG23280D
     C                   EVAL      WSubFld = 0                                              BUG26814
      *                                                                                    BUG23280D
      ** Replace all field separators with dummy line separator                            BUG23280D
      ** from system value MT94xFldTags                                                     BUG26814
      *                                                                                    BUG23280D
     C                   EVAL      WSysPos  = 1                                             BUG26814
     C                   DOU       WSysPos  > 200                                           BUG26814
     C                   EVAL      WSysVal  = %SUBST(PSVal1:WSysPos:2)                      BUG26814
     C                   IF        WSysVal  = *BLANKS                                       BUG26814
     C                   LEAVE                                                              BUG26814
     C                   ENDIF                                                              BUG26814
     C                   MOVE      WSysVal       WVal                                       BUG26814
     C                   EXSR      SrSetNar                                                 BUG26814
     C                   EVAL      WSysPos += 2                                             BUG26814
     C                   ENDDO                                                              BUG26814
                                                                                            BUG26814
     C**********         MOVE      '20'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '21'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '22'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '23'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '24'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '25'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '26'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '27'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '28'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '29'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '60'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '61'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '62'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '63'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '64'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '65'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
     C                                                                                     BUG23280D
     C                   ENDSR                                                             BUG23280D
      *****************************************************************                    BUG23280D
      /EJECT                                                                               BUG23280D
      *****************************************************************                    BUG23280D
     C     SrSetNar      BEGSR                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WFlg = 'Y'                                              BUG23280D
     C                   LEAVESR                                                           BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                     BUG26814
     C                   ADD       1             WSubFld                                    BUG26814
      *                                                                                    BUG23280D
     C                   EVAL      WExtStr = *BLANKS                                       BUG23280D
     C                   EVAL      WPsFld = %SCAN(WVal: Wnarr)                             BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WPsFld > *ZEROS                                         BUG23280D
      * GVC                                                                                 BUG26853
     C                   IF        WPsFld = 4                                               BUG26853
     C                   EVAL      %SUBST(WNarr1:1:3) =                                     BUG26853
     C                             %SUBST(WNarr:1:3)                                        BUG26853
     C                   ENDIF                                                              BUG26853
      *                                                                                    BUG23280D
     C                   MOVEL     N_EDFSEP      WVal1                                      BUG26853
     C                   EVAL      WSysPos1 = WSysPos                                       BUG26853
      * Loop Until we can get the next Subfield on the narrative                            BUG26853
     C                   DOU       WSysPos1 > 200                                           BUG26853
     C                             OR WPsFld1 > *ZERO                                       BUG26853
     C                   EVAL      WSysVal = %SUBST(PSVal1:WSysPos1:2)                      BUG26853
     C                   IF        WSysVal = *BLANKS                                        BUG26853
     C                   LEAVE                                                              BUG26853
     C                   ENDIF                                                              BUG26853
     C                   MOVE      WSysVal       WVal1                                      BUG26853
     C                   EVAL      WPsFld1= %SCAN(WVal1:Wnarr:WPsFld + 1)                   BUG26853
     C                   EVAL      WSysPos1 += 2                                            BUG26853
     C                   ENDDO                                                              BUG26853
      *                                                                                     BUG26853
     C**********         EVAL      WPsFld1= %SCAN(N_EDFSEP:Wnarr:WPsFld + 1)      BUG23280D BUG26853
      *                                                                                    BUG23280D
     C                   IF        WPsFld1 = *ZEROS                                        BUG23280D
     C                   EVAL      WPsFld1 = %LEN(%TRIM(WNarr)) + 1                        BUG23280D
     C                   EVAL      WFlg = 'Y'                                              BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WExtStr = %SUBST(WNarr : WPsFld + 3:                    BUG23280D
     C                                       WPsFld1-(WPsFld + 3))                         BUG23280D
     C**********         EVAL      %SUBST(WNarr1:WField:27) = WExtStr             BUG23280D BUG26814
     C                   EVAL      %SUBST(WNarr1:WField:WFldLen2(WSubFld))                  BUG26814
     C                             = WExtStr                                                BUG26814
      *                                                                                    BUG23280D
     C**********         EVAL      WField = WField + 27                           BUG23280D BUG26814
      *                                                                                    BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                     BUG26814
     C                   EVAL      WField = WField + WFldLen2(WSubFld)                      BUG26814
      *                                                                                    BUG23280D
     C                   ENDSR                                                             BUG23280D
      *****************************************************************                    BUG23280D
      /EJECT                                                                               BUG23280D
      *****************************************************************                    BUG23280D
     C     SrMrgExt      BEGSR                                                             BUG23280D
     C                   EVAL      WIndx = 1                                               BUG23280D
     C                   EVAL      WNoChar = *ZEROS                                        BUG23280D
     C                   EVAL      WBlFlg ='N'                                             BUG23280D
     C                   EVAL      WExtNarr= *BLANKS                                       BUG23280D
     C                   EVAL      WPsBl = 1                                               BUG23280D
      *                                                                                    BUG23280D
     C                   DOW       WIndx < 7                                               BUG23280D
     C                   EVAL      WNoChar = %LEN(%TRIM(ArrExt(WIndx)))                    BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WNoChar < 63                                            BUG23280D
     C                   EVAL      %SUBST(WExtNarr:WPsBl : WNoChar)                        BUG23280D
     C                             = %TRIMR(ArrExt(WIndx ))                                BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WNoChar = 27  AND WBlFlg = 'N'                          BUG23280D
     C                   EVAL      WPsBl = WPsBl + WNoChar                                 BUG23280D
     C                   ELSE                                                              BUG23280D
     C                   EVAL      WBlFlg = 'Y'                                            BUG23280D
     C                   EVAL      WPsBl = WPsBl + WNoChar + 2                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   ELSE                                                              BUG23280D
     C                   EVAL      %SUBST(WExtNarr:WPsBl : WNoChar)                        BUG23280D
     C                             = ArrExt(WIndx)                                         BUG23280D
     C                   EVAL      WPsBl = WPsBl + 65                                      BUG23280D
      *                                                                                    BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WIndx = WIndx + 1                                       BUG23280D
     C                   ENDDO                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   ENDSR                                                             BUG23280D
      *****************************************************************                    BUG23280D
      /EJECT                                                                               BUG23280D
      *****************************************************************                    BUG23280D
     C     Srdiv27       BEGSR                                                             BUG23280D
      *                                                                                    BUG23280D
      ** Dividing extended narratives into 27 chars for Details of Payment                 BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WCnt = 1                                                BUG23280D
     C                   EVAL      WCnt1 = 1                                               BUG23280D
     C                   EVAL      WSubFld = 1                                              BUG26814
      * GVC                                                                                 BUG26853
     C                   IF        WFldSep = 'Y'                                            BUG26853
     C                   IF        %SUBST(WExtNarr:1:3) <> *BLANKS                          BUG26853
     C                   EVAL      MG86GV = %SUBST(WExtNarr:1:3)                            BUG26853
     C                   ENDIF                                                              BUG26853
     C                   EVAL      WCnt = WCnt + 3                                          BUG26853
     C                   ENDIF                                                              BUG26853
      *                                                                                     BUG26814
     C                   IF        WFldSep = 'Y'                                           BUG26780A
     C                   EVAL      MG8600=                                                  BUG26814
     C                             %SUBST(WExtNarr:WCnt:WFldLen2(WSubFld))                  BUG26814
     C                   EVAL      WCnt = WCnt + WFldLen2(WSubFld)                          BUG26853
     C                   ENDIF                                                             BUG26780A
     C**********         EVAL      WCnt = WCnt + WFldLen2(WSubFld)                 BUG26814 BUG26853
     C                   ADD       1             WSubFld                                    BUG26814
     C                   IF        WFldSep = 'Y'                                           BUG26780A
     C                   EVAL      MG8610=                                                  BUG26814
     C                             %SUBST(WExtNarr:WCnt:WFldLen2(WSubFld))                  BUG26814
     C                   EVAL      WCnt = WCnt + WFldLen2(WSubFld)                          BUG26853
     C                   ENDIF                                                             BUG26780A
     C**********         EVAL      WCnt = WCnt + WFldLen2(WSubFld)                 BUG26814 BUG26853
     C                   ADD       1             WSubFld                                    BUG26814
     C                   IF        WCnt > 1                                                 BUG26853
     C                   Z-ADD     WCnt          WCnt2                                      BUG26853
     C                   ELSE                                                               BUG26853
     C                   Z-ADD     0             WCnt2                                      BUG26853
     C                   ENDIF                                                              BUG26853
      *                                                                                    BUG23280D
     C**********         DOW       WCnt < 270                                     BUG23280D BUG26814
     C**********         DOW       WCnt < 307                                      BUG26814 BUG26853
     C                   DOW       WCnt < (270 + WCnt2)                                     BUG26853
     C                   EVAL      %SUBST(MG8620to29:WCnt1) =                              BUG23280D
     C**********                   %SUBST(WExtNarr:WCnt:27)                       BUG23280D BUG26814
     C                             %SUBST(WExtNarr:WCnt:WFldLen2(WSubFld))                  BUG26814
     C**********         EVAL      WCnt = WCnt + 27                               BUG23280D BUG26814
     C**********         EVAL      WCnt1 = WCnt1 + 35                             BUG23280D BUG26814
     C                   EVAL      WCnt = WCnt + WFldLen2(WSubFld)                          BUG26814
     C                   EVAL      WCnt1 = WCnt1 + WFldLen1(WSubFld)                        BUG26814
     C                   ADD       1             WSubFld                                    BUG26814
      *                                                                                     BUG26814
     C                   ENDDO                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WCnt1 = 1                                                BUG26814
     C**********         DOW       WCnt < 488                                      BUG26814 BUG26853
     C                   DOW       WCnt < (451 + WCnt2)                                     BUG26853
     C                   EVAL      %SUBST(MG8630to38:WCnt1) =                               BUG26814
     C                             %SUBST(WExtNarr:WCnt:WFldLen2(WSubFld))                  BUG26814
     C                   EVAL      WCnt = WCnt + WFldLen2(WSubFld)                          BUG26814
     C                   EVAL      WCnt1 = WCnt1 + WFldLen1(WSubFld)                        BUG26814
     C                   ADD       1             WSubFld                                    BUG26814
      *                                                                                     BUG26814
     C                   ENDDO                                                              BUG26814
      *                                                                                     BUG26814
     C                   EVAL      WCnt1 = 1                                               BUG23280D
     C**********         DOW       WCnt < 379                                     BUG23280D BUG26814
     C**********         DOW       WCnt < 650                                      BUG26814 BUG26853
     C                   DOW       WCnt < (613 + WCnt2)                                     BUG26853
     C                   EVAL      %SUBST(MG8660to65:WCnt1) =                              BUG23280D
     C**********                   %SUBST(WExtNarr:WCnt:27)                       BUG23280D BUG26814
     C                             %SUBST(WExtNarr:WCnt:WFldLen2(WSubFld))                  BUG26814
     C**********         EVAL      WCnt = WCnt + 27                               BUG23280D BUG26814
     C**********         EVAL      WCnt1 = WCnt1 + 35                             BUG23280D BUG26814
     C                   EVAL      WCnt = WCnt + WFldLen2(WSubFld)                          BUG26814
     C                   EVAL      WCnt1 = WCnt1 + WFldLen1(WSubFld)                        BUG26814
     C                   ADD       1             WSubFld                                    BUG26814
      *                                                                                    BUG23280D
     C                   ENDDO                                                             BUG23280D
      *                                                                                    BUG23280D
     C**********         IF        WCnt = 379                                     BUG23280D BUG26814
     C**********         IF        WCnt = 650                                      BUG26814 BUG26853
     C                   IF        WCnt = (613 + WCnt2)                                     BUG26853
     C                             AND WCnt1 < 210                                          BUG26853
     C                   EVAL      %SUBST(MG8660to65:WCnt1) =                              BUG23280D
     C                             %SUBST(WExtNarr:WCnt)                                   BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   ENDSR                                                             BUG23280D
      *****************************************************************                     BUG24304
      /EJECT                                                                                BUG24304
      *****************************************************************                     BUG24304
     C     SrMtdiv27     BEGSR                                                              BUG24304
      *                                                                                     BUG24304
      ** Form a string of 432 chars                                                         BUG24304
      *                                                                                     BUG24304
     C                   EVAL      WIndx =1                                                 BUG24304
     C                   EVAL      WExt22 = *BLANKS                                         BUG24304
      *                                                                                     BUG24304
     C
     C                   EVAL      WkBAEX22  = BAEX22                                       MD055642
     C                   IF        WkModuleID = 'BA' AND MG8632 <> *BLANKS                  MD055642
     C                   EVAL      WkBAEX22  = *BLANKS                                      MD055642
     C                   ENDIF                                                              MD055642
     C
     C                   EVAL      WExt22 = %TRIM(BAEX1) + '  ' +                           BUG24304
     C                             %TRIM(BAEX2)+'  '+%TRIM(BAEX3)+'  '+                     BUG24304
     C                             %TRIM(BAEX4)+'  '+%TRIM(BAEX5)+'  '+                     BUG24304
     C                             %TRIM(BAEX6)+'  '+%TRIM(BAEX7)+'  '+                     BUG24304
     C                             %TRIM(BAEX8)+'  '+%TRIM(BAEX9)+'  '+                     BUG24304
     C                             %TRIM(BAEX10)+'  '+%TRIM(BAEX11)+ '  '+                  BUG24304
     C                             %TRIM(BAEX12)+'  '+%TRIM(BAEX13)+ '  '+                  BUG24304
     C                             %TRIM(BAEX14)+'  '+%TRIM(BAEX15)+ '  '+                  BUG24304
     C                             %TRIM(BAEX16)+'  '+%TRIM(BAEX17)+ '  '+                  BUG24304
     C                             %TRIM(BAEX18)+'  '+%TRIM(BAEX19)+ '  '+                  BUG24304
     C                             %TRIM(BAEX20)+'  '+%TRIM(BAEX21)+ '  '+                  BUG24304
     C**********                   %TRIM(BAEX22)                                   BUG24304 MD055642
     C                             %TRIM(WkBAEX22)                                          MD055642
      *                                                                                     BUG24304
      ** Dividing extended narratives into 27 chars for Details of Payment                  BUG24304
      *                                                                                     BUG24304
     C                   EVAL      WCnt = 1                                                 BUG24304
     C                   EVAL      WCnt1 = 1                                                BUG24304
      *                                                                                     BUG24304
     C                   DOW       WCnt < 270                                               BUG24304
     C                   EVAL      %SUBST(MG8620to29:WCnt1) =                               BUG24304
     C                             %SUBST(WExt22:WCnt:27)                                   BUG24304
     C                   EVAL      WCnt = WCnt + 27                                         BUG24304
     C                   EVAL      WCnt1 = WCnt1 + 35                                       BUG24304
     C                   ENDDO                                                              BUG24304
      *                                                                                     BUG24304
     C                   EVAL      WCnt1 = 1                                                BUG24304
     C                   DOW       WCnt < 406                                               BUG24304
     C                   EVAL      %SUBST(MG8660to65:WCnt1) =                               BUG24304
     C                             %SUBST(WExt22:WCnt:27)                                   BUG24304
     C                   EVAL      WCnt = WCnt + 27                                         BUG24304
     C                   EVAL      WCnt1 = WCnt1 + 35                                       BUG24304
      *                                                                                     BUG24304
     C                   ENDDO                                                              BUG24304
      *                                                                                     BUG24304
     C                   IF        WCnt = 406                                               BUG24304
     C                   EVAL      %SUBST(MG8660to65:WCnt1) =                               BUG24304
     C                             %SUBST(WExt22:WCnt)                                      BUG24304
     C                   ENDIF                                                              BUG24304
      *                                                                                     BUG24304
     C                   ENDSR                                                              BUG24304
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *                    BUG23280A
      *  SrAccDet - Retrive network account details from transaction  *                    BUG23280A
      *                                                               *                    BUG23280A
      *  Called by : SrExtract86                                      *                    BUG23280A
      *                                                               *                    BUG23280A
      *  Calls : SrNwrk                                               *                    BUG23280A
      *                                                               *                    BUG23280A
      *****************************************************************                    BUG23280A
      *                                                                                    BUG23280A
     C     SrAccDet      BEGSR                                                             BUG23280A
      *                                                                                    BUG23280A
      ** Access transaction details                                                        BUG23280A
      ** Retrieve network details as per the retail account used                           BUG23280A
      *                                                                                    BUG23280A
     C                   IF        WkModuleID = 'FT'                                       BUG23280A
      *                                                                                    BUG23280A
     C                   IF        GLOTTP = 'IN'                                           BUG23280A
      *                                                                                    BUG23280A
      ** Getting customer nuber,branch,ccy etc from the beneficiary entered                BUG23280A
      *                                                                                    BUG23280A
     C                   IF        BNCT = 'R'  OR BNCT = 'P'                               BUG23280A
     C                             OR BNCT = 'I'                                           BUG23280A
      *                                                                                    BUG23280A
     C                   SELECT                                                            BUG23280A
      *                                                                                    BUG23280A
     C                   WHEN      BNCT = 'R'                                              BUG23280A
     C                   EVAL      WTAcno = %SUBST(BNC1 : 1 : 10)                          BUG23280A
     C                   MOVEL     *BLANKS       WAcno                                     BUG23280A
     C                   MOVEL     WTAcno        WAcno                                     BUG23280A
      *                                                                                    BUG23280A
     C     WAcno         CHAIN     ACNUMA                                                  BUG23280A
      *                                                                                    BUG23280A
     C                   IF        %FOUND(ACNUMA)                                          BUG23280A
      *                                                                                    BUG23280A
     C                   EVAL      WCusno1 = CNUM                                          BUG23280A
     C                   EVAL      WCcy1 = CCY                                             BUG23280A
     C                   EVAL      WAccd1 = ACOD                                           BUG23280A
     C                   EVAL      WAcsq1 = ACSQ                                           BUG23280A
     C                   EVAL      WBrca1 = BRCA                                           BUG23280A
     C                   ENDIF                                                             BUG23280A
      *                                                                                    BUG23280A
      ** Partial Account                                                                   BUG23280A
      *                                                                                    BUG23280A
     C                   WHEN      BNCT = 'P'                                              BUG23280A
      *                                                                                    BUG23280A
     C                   EVAL      WCusno = %SUBST(BNC1 : 1 : 6)                           BUG23280A
     C*                  EVAL      WCcy1 = PCCY                                            BUG23280A
     C                   EVAL      WAccd = %SUBST(BNC1 : 7 : 10)                           BUG23280A
     C                   EVAL      WAcsq = %SUBST(BNC1 : 17 : 2)                           BUG23280A
     C                   EVAL      WBrca1= %SUBST(BNC1 : 19 : 3)                           BUG23280A
      *                                                                                    BUG23280A
     C                   MOVE      WCusno        WCusno1                                   BUG23280A
     C                   MOVE      WAccd         WAccd1                                    BUG23280A
     C                   MOVE      WAcsq         WAcsq1                                    BUG23280A
      *                                                                                    BUG23280A
      ** IBAN Account                                                                      BUG23280A
      *                                                                                    BUG23280A
     C                   WHEN      BNCT = 'I'                                              BUG23280A
      *                                                                                    BUG23280A
     C                   IF        %SUBST(BNC1 : 1 : 1) = '/'                              BUG23280A
     C     34            SUBST     BNC1:2        PIBan                                     BUG23280A
     C                   ELSE                                                              BUG23280A
     C                   MOVEL     BNC1          PIBan                                     BUG23280A
     C                   ENDIF                                                             BUG23280A
                                                                                           BUG23280A
     C                   CALL      'AOIBANR3'                                              BUG23280A
     C                   PARM                    PRtcd                                     BUG23280A
     C                   PARM                    PIBan                                     BUG23280A
     C                   PARM                    PoWith                                    BUG23280A
     C     PIBan1        PARM                    PoNobl                                    BUG23280A
      *                                                                                    BUG23280A
     C                   MOVE      *BLANKS       DSSDY                                     BUG23280A
     C                   CALL      'AOIBANR4'                                              BUG23280A
     C                   PARM                    PRtcd                                     BUG23280A
     C                   PARM      '*KEY'        POptn                                     BUG23280A
     C                   PARM                    PIBan1           34                       BUG23280A
     C     PACCN         PARM                    DSSDY                                     BUG23280A
      *                                                                                    BUG23280A
     C                   EVAL      WCcy1 = PCCY                                            BUG23280A
     C******             Z-ADD     IBCNUM        WCusno1                            BUG23280A CER059
     C                   MOVEL     IBCNUM        WCusno1                                      CER059
     C                   Z-ADD     IBACOD        WAccd1                                    BUG23280A
     C                   Z-ADD     IBACSQ        WAcsq1                                    BUG23280A
     C                   EVAL      WBrca1 = IBBRCA                                         BUG23280A
      *                                                                                    BUG23280A
     C                   ENDSL                                                             BUG23280A
      *                                                                                    BUG23280A
     C                   ELSE                                                              BUG23280A
      *                                                                                    BUG23280A
     C*********          EVAL      WCusno1 = *ZEROS                                 BUG23280A CER059
     C                   EVAL      WCusno1 = *BLANKS                                          CER059
     C                   EVAL      WCcy1 = *BLANKS                                         BUG23280A
     C                   EVAL      WAccd1 = *ZEROS                                         BUG23280A
     C                   EVAL      WAcsq1 = *ZEROS                                         BUG23280A
     C                   EVAL      WBrca1 = *BLANKS                                        BUG23280A
      *                                                                                    BUG23280A
     C                   ENDIF                                                             BUG23280A
      *                                                                                    BUG23280A
      *                                                                                    BUG23280A
     C                   ELSEIF    GLOTTP = 'OP'                                           BUG23280A
     C                   IF        GLDRCR = 0                                              BUG23280B
      *                                                                                    BUG23280B
     C                   EVAL      WSORC1 = ORC1                                           BUG23280A
      *                                                                                    BUG23280A
     C**********         EVAL      WCusno1= *ZEROS                                  BUG23280A CER059
     C                   EVAL      WCusno1= *BLANKS                                           CER059
     C                   EVAL      WCcy1  = *BLANKS                                        BUG23280A
     C                   EVAL      WAccd1 = *ZEROS                                         BUG23280A
     C                   EVAL      WAcsq1 = *ZEROS                                         BUG23280A
     C                   EVAL      WBrca1 = *BLANKS                                        BUG23280A
      *                                                                                    BUG23280A
     C                   SELECT                                                            BUG23280A
      *                                                                                    BUG23280A
      ** Retail account (ordering customer)                                                BUG23280A
      *                                                                                    BUG23280A
     C                   WHEN      ORCT = 'R'                                              BUG23280A
      *                                                                                    BUG23280A
     C                   IF        %SUBST(ORDCST:1:1) = '/'                                BUG23280A
     C                   MOVEL     ORETS         ACNO                                      BUG23280A
     C                   ELSE                                                              BUG23280A
     C                   MOVEL     ORET          ACNO                                      BUG23280A
     C                   ENDIF                                                             BUG23280A
      *                                                                                    BUG23280A
     C     ACNO          CHAIN     ACNUMA                                                  BUG23280A
      *                                                                                    BUG23280A
     C                   IF        %FOUND(ACNUMA)                                          BUG23280A
     C                   EVAL      WCusno1 = CNUM                                          BUG23280A
     C                   EVAL      WCcy1  = CCY                                            BUG23280A
     C                   EVAL      WAccd1 = ACOD                                           BUG23280A
     C                   EVAL      WAcsq1 = ACSQ                                           BUG23280A
     C                   EVAL      WBrca1 = BRCA                                           BUG23280A
     C                   ENDIF                                                             BUG23280A
      *                                                                                    BUG23280A
      ** Partial account identifier                                                        BUG23280A
      *                                                                                    BUG23280A
     C                   WHEN      ORCT = 'P'                                              BUG23280A
      *                                                                                    BUG23280A
     C                   IF        %SUBST(ORDCST:1:1) = '/'                                BUG23280A
     C                   EVAL      WCusno = ONUMS                                          BUG23280A
     C                   EVAL      WCcy1  = SMCY                                           BUG23280A
     C                   EVAL      WAccd  = OCODS                                          BUG23280A
     C                   EVAL      WAcsq  = OSEQS                                          BUG23280A
     C                   EVAL      WBrca1 = OBRCS                                          BUG23280A
      *                                                                                    BUG23280A
     C                   ELSE                                                              BUG23280A
      *                                                                                    BUG23280A
     C                   EVAL      WCusno = ONUM                                           BUG23280A
     C                   EVAL      WCcy1  = SMCY                                           BUG23280A
     C                   EVAL      WAccd  = OCOD                                           BUG23280A
     C                   EVAL      WAcsq  = OSEQ                                           BUG23280A
     C                   EVAL      WBrca1 = OBRC                                           BUG23280A
      *                                                                                    BUG23280A
     C                   ENDIF                                                             BUG23280A
      *                                                                                    BUG23280A
     C                   MOVEL     WCusno        WCusno1                                   BUG23280A
     C                   MOVEL     WAccd         WAccd1                                    BUG23280A
     C                   MOVEL     WAcsq         WAcsq1                                    BUG23280A
      *                                                                                    BUG23280A
      ** IBAN Account                                                                      BUG23280A
      *                                                                                    BUG23280A
     C                   WHEN      ORCT = 'I'                                              BUG23280A
      *                                                                                    BUG23280A
     C                   IF        %SUBST(ORDCST:1:1) = '/'                                BUG23280A
     C                   CALL      'AOIBANR2'                                              BUG23280A
     C                   PARM      *BLANKS       PRtcd                                     BUG23280A
     C                   PARM      IBAN2         PIBan                                     BUG23280A
     C     PACCN         PARM      PACCN         DSSDY                                     BUG23280A
      *                                                                                    BUG23280A
     C                   ELSE                                                              BUG23280A
      *                                                                                    BUG23280A
     C                   CALL      'AOIBANR2'                                              BUG23280A
     C                   PARM      *BLANKS       PRtcd                                     BUG23280A
     C                   PARM      IBAN1         PIBan                                     BUG23280A
     C     PACCN         PARM      PACCN         DSSDY                                     BUG23280A
      *                                                                                    BUG23280A
     C                   ENDIF                                                             BUG23280A
      *                                                                                    BUG23280A
     C                   EVAL      WCusno1= IBCNUM                                         BUG23280A
     C                   EVAL      WCcy1  = SMCY                                           BUG23280A
     C                   EVAL      WAccd1 = IBACOD                                         BUG23280A
     C                   EVAL      WAcsq1 = IBACSQ                                         BUG23280A
     C                   EVAL      WBrca1 = IBBRCA                                         BUG23280A
      *                                                                                    BUG23280A
     C                   ENDSL                                                             BUG23280A
      *                                                                                    BUG23280B
     C                   ELSEIF    GLDRCR = 1                                              BUG23280B
      *                                                                                    BUG23280B
      ** Initialize the parameters                                                         BUG23280B
      *                                                                                    BUG23280B
     C                   EVAL      WSDST1 = DST1                                           BUG23280B
      *                                                                                    BUG23280B
     C**********         EVAL      WCusno1= *ZEROS                                  BUG23280B CER059
     C                   EVAL      WCusno1= *BLANKS                                           CER059
     C                   EVAL      WCcy1  = *BLANKS                                        BUG23280B
     C                   EVAL      WAccd1 = *ZEROS                                         BUG23280B
     C                   EVAL      WAcsq1 = *ZEROS                                         BUG23280B
     C                   EVAL      WBrca1 = *BLANKS                                        BUG23280B
      *                                                                                    BUG23280B
     C                   SELECT                                                            BUG23280B
      *                                                                                    BUG23280B
      ** Retail account                                                                    BUG23280B
      *                                                                                    BUG23280B
     C                   WHEN      DSTT = 'R'                                              BUG23280B
      *                                                                                    BUG23280B
     C                   MOVE      DRET          ACNO                                      BUG23280B
     C     ACNO          CHAIN     ACNUMA                                                  BUG23280B
      *                                                                                    BUG23280B
     C                   IF        %FOUND(ACNUMA)                                          BUG23280B
     C                   EVAL      WCusno1 = CNUM                                          BUG23280B
     C                   EVAL      WCcy1   = CCY                                           BUG23280B
     C                   EVAL      WAccd1  = ACOD                                          BUG23280B
     C                   EVAL      WAcsq1  = ACSQ                                          BUG23280B
     C                   EVAL      WBrca1  = BRCA                                          BUG23280B
     C                   ENDIF                                                             BUG23280B
      *                                                                                    BUG23280B
      ** Nostro Account                                                                    BUG23280B
      *                                                                                    BUG23280B
     C                   WHEN      DSTT = 'F'                                              BUG23280B
      *                                                                                    BUG23280B
     C                   CALL      'AONOSTR0'                                              BUG23280B
     C                   PARM      *BLANKS       P1Rtcd                                    BUG23280B
     C                   PARM      '*KEY   '     P1Optn                                    BUG23280B
     C                   PARM      *BLANKS       P1Cust                                    BUG23280B
     C                   PARM      NCUR          P1Cycd                                    BUG23280B
     C                   PARM      *BLANKS       P1Accd                                    BUG23280B
     C                   PARM      *BLANKS       P1Acsn                                    BUG23280B
     C                   PARM      NNUM          P1Nonb                                    BUG23280B
     C                   PARM      *BLANKS       P1Brca                                    BUG23280B
     C                   PARM      *BLANKS       P1Cssn                                    BUG23280B
     C                   PARM      *BLANKS       P1Pnoi                                    BUG23280B
     C     SDNOST        PARM      SDNOST        DSFDY                                     BUG23280B
      *                                                                                    BUG23280B
     C                   MOVE      A7CUST        WCusno1                                   BUG23280B
     C                   MOVE      A7ACCD        WAccd1                                    BUG23280B
     C                   MOVE      A7ACSN        WAcsq1                                    BUG23280B
     C                   EVAL      WBrca1 = A7BRCD                                         BUG23280B
     C                   EVAL      WCcy1 = NCUR                                            BUG23280B
      *                                                                                    BUG23280B
      ** Full Account                                                                      BUG23280B
      *                                                                                    BUG23280B
     C                   WHEN      DSTT = 'G'                                              BUG23280B
     C                   MOVEL     DNUM          WCusno1                                   BUG23280B
     C                   EVAL      WCCY1 = DSCY                                            BUG23280B
     C                   MOVEL     DCOD          WAccd1                                    BUG23280B
     C                   MOVEL     DSEQ          WAcsq1                                    BUG23280B
     C                   EVAL      WBRCA1 = DBRC                                           BUG23280B
      *                                                                                    BUG23280B
     C                   ENDSL                                                             BUG23280B
     C                   ENDIF                                                             BUG23280B
      *                                                                                    BUG23280B
     C                   ENDIF                                                             BUG23280A
      *                                                                                    BUG23280A
     C                   ELSEIF    WkModuleID = 'BA'                                       BUG23280A
     C     KBatch        CHAIN     GLJENPL0                                                BUG23280A
     C                   IF        %FOUND(GLJENPL0)                                        BUG23280A
     C                   MOVE      G1BTCUST      WCusno1                                   BUG23280A
     C                   EVAL      WCcy1  = G1BTCYCD                                       BUG23280A
     C                   MOVE      G1BTACCD      WAccd1                                    BUG23280A
     C                   MOVE      G1BTACSN      WAcsq1                                    BUG23280A
     C                   EVAL      WBrca1 = G1BTIBCA                                       BUG23280A
     C                                                                                     BUG23280A
     C                   ENDIF                                                             BUG23280A
     C                   ENDIF                                                             BUG23280A
      *                                                                                    BUG23280A
      ** Get the network of original transaction to find line separator                    BUG23280A
      *                                                                                    BUG23280A
     C                   EXSR      SrNwrk                                                  BUG23280A
      *                                                                                    BUG23280A
     C                   ENDSR                                                             BUG23280A
      *                                                                                    BUG23280A
      *****************************************************************                    BUG23280A
      /EJECT                                                                               BUG23280A
      *****************************************************************                    BUG23280A
      *                                                               *                    BUG23280A
      *  SrNwrk  - Find network linked to transaction                 *                    BUG23280A
      *                                                               *                    BUG23280A
      *  Called by : SrAccDett                                        *                    BUG23280A
      *                                                               *                    BUG23280A
      *  Calls : None                                                 *                    BUG23280A
      *                                                               *                    BUG23280A
      *****************************************************************                    BUG23280A
      *                                                                                    BUG23280A
     C     SrNwrk        BEGSR                                                             BUG23280A
      *                                                                                    BUG23280A
     C                   EVAL      KBrca = WBrca1                                          BUG23280A
     C                   EVAL      KCNum = WCusno1                                         BUG23280A
     C                   EVAL      KCcy =  WCcy1                                           BUG23280A
     C                   EVAL      KAccd = WAccd1                                          BUG23280A
     C                   EVAL      KAcsq = WAcsq1                                          BUG23280A
     C                   EVAL      KNaty = MGNATY                                             263479
     C                   EVAL      KDstn = MGDSTN                                             263479
      *                                                                                    BUG23280A
      ** When Account is not present then use the default 'SWIFT'                          BUG23280A
      *                                                                                    BUG23280A
     C     KAcct         CHAIN     GLNW94L11                                               BUG23280A
      *                                                                                    BUG23280A
     C                   IF        NOT %FOUND (GLNW94L11)                                  BUG23280A
      *                                                                                    BUG23280A
     C*****KAcct         CHAIN     GLNW94L8                                         BUG23280A 263479
     C     KAcct2        CHAIN     GLNW94L8                                                   263479
     C                   IF        NOT %FOUND (GLNW94L8)                                   BUG23280A
     C                   EVAL      KNwrk = 'SWIFT'                                         BUG23280A
     C                   ELSE                                                              BUG23280A
      *                                                                                    BUG23280A
      ** Loop to get First network with Extended naarative flag as 'Y'                     BUG23280A
      *                                                                                    BUG23280A
     C                   DOW       NOT %EOF(GLNW94L8)                                      BUG23280A
     C                   EVAL      KNwrk = N4NWRK                                          BUG23280A
      *                                                                                    BUG23280A
     C                   CALL      'AONWRKR1'                                              BUG23280A
     C                   PARM      *BLANKS       PRtCd                                     BUG23280A
     C                   PARM      '*KEY'        POptn                                     BUG23280A
     C                   PARM      KNwrk         PNwrk                                     BUG23280A
     C     DSNwrk        PARM                    DSLDY                                     BUG23280A
      *                                                                                    BUG23280A
     C                   IF        PRtCd <> *BLANKS                                        BUG23280A
      *                                                                                    BUG23280A
     C     *LOCK         IN        LDA                                                     BUG23280A
      *                                                                                    BUG23280A
     C                   EVAL      DBASE = 001                                             BUG23280A
     C                   EVAL      DBFILE = 'SDNWRKPD'                                     BUG23280A
     C                   EVAL      DBKEY  = KNwrk                                          BUG23280A
     C                   EVAL      DBPGM = 'MG94NGER'                                      BUG23280A
      *                                                                                    BUG23280A
     C                   OUT       LDA                                                     BUG23280A
     C                   EXSR      *PSSR                                                   BUG23280A
     C                   ENDIF                                                             BUG23280A
      *                                                                                    BUG23280A
     C**********         IF        EDENRA <> 'Y'                                    BUG23280A 263479
     C*****KAcct         READE     GLNW94L8                                         BUG23280A 263479
     C                   IF        N_EDENRA <> 'Y'                                            263479
     C     KAcct2        READE     GLNW94L8                                                   263479
     C                   ELSE                                                              BUG23280A
     C                   LEAVE                                                             BUG23280A
     C                   ENDIF                                                             BUG23280A
     C                   ENDDO                                                             BUG23280A
      *                                                                                    BUG23280A
     C                   ENDIF                                                             BUG23280A
      *                                                                                    BUG23280A
     C                   ELSE                                                              BUG23280A
     C                   EVAL      KNwrk = N4NWRK                                          BUG23280A
     C                   ENDIF                                                             BUG23280A
      *                                                                                    BUG23280A
      *                                                                                    BUG23280A
      ** Retrieve the associated network record and find the format                        BUG23280A
      ** related to the network else issue an error                                        BUG23280A
      *                                                                                    BUG23280A
     C                   CALL      'AONWRKR1'                                              BUG23280A
     C                   PARM      *BLANKS       PRtCd                                     BUG23280A
     C                   PARM      '*KEY'        POptn                                     BUG23280A
     C                   PARM      KNwrk         PNwrk                                     BUG23280A
     C     DSNwrk        PARM                    DSLDY                                     BUG23280A
      *                                                                                    BUG23280A
     C                   IF        PRtCd <> *BLANKS                                        BUG23280A
      *                                                                                    BUG23280A
     C     *LOCK         IN        LDA                                                     BUG23280A
      *                                                                                    BUG23280A
     C                   EVAL      DBASE = 002                                             BUG23280A
     C                   EVAL      DBFILE = 'SDNWRKPD'                                     BUG23280A
     C                   EVAL      DBKEY  = KNwrk                                          BUG23280A
     C                   EVAL      DBPGM = 'MG94NGER'                                      BUG23280A
      *                                                                                    BUG23280A
     C                   OUT       LDA                                                     BUG23280A
     C                   EXSR      *PSSR                                                   BUG23280A
     C                   ENDIF                                                             BUG23280A
      *                                                                                    BUG23280A
      ** Line Separator for the transaction                                                BUG23280A
      *                                                                                    BUG23280A
     C                   EVAL      WLSep = N_EDLSEP                                        BUG23280A
      *                                                                                    BUG23280A
     C                   ENDSR                                                             BUG23280A
      *****************************************************************                    BUG23280A
      /EJECT                                                                               BUG23280A
      *========================================================================*              CMG008
      * SrConvFld86 : Convert Non-SWIFT chars found in FIELD 86 output fields  *              CMG008
      *------------------------------------------------------------------------*              CMG008
                                                                                              CMG008
     C     SrConvFld86   BEGSR                                                                CMG008
      *    -----------   -----                                                                CMG008
                                                                                              CMG008
      ** Convert MGADI1                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MGADI1                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MGADI1 = WConvFld                                          CMG008
      ** Convert MGADI2                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MGADI2                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MGADI2 = WConvFld                                          CMG008
      ** Convert MGADI3                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MGADI3                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MGADI3 = WConvFld                                          CMG008
      ** Convert MGADI4                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MGADI4                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MGADI4 = WConvFld                                          CMG008
      ** Convert MGADI5                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MGADI5                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MGADI5 = WConvFld                                          CMG008
      ** Convert MGADI6                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MGADI6                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MGADI6 = WConvFld                                          CMG008
      ** Convert MG8620                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8620                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8620 = WConvFld                                          CMG008
      ** Convert MG8621                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8621                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8621 = WConvFld                                          CMG008
      ** Convert MG8622                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8622                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8622 = WConvFld                                          CMG008
      ** Convert MG8623                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8623                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8623 = WConvFld                                          CMG008
      ** Convert MG8624                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8624                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8624 = WConvFld                                          CMG008
      ** Convert MG8625                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8625                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8625 = WConvFld                                          CMG008
      ** Convert MG8626                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8626                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8626 = WConvFld                                          CMG008
      ** Convert MG8627                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8627                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8627 = WConvFld                                          CMG008
      ** Convert MG8628                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8628                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8628 = WConvFld                                          CMG008
      ** Convert MG8629                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8629                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8629 = WConvFld                                          CMG008
      ** Convert MG8660                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8660                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8660 = WConvFld                                          CMG008
      ** Convert MG8661                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8661                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8661 = WConvFld                                          CMG008
      ** Convert MG8662                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8662                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8662 = WConvFld                                          CMG008
      ** Convert MG8663                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8663                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8663 = WConvFld                                          CMG008
      ** Convert MG8664                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8664                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8664 = WConvFld                                          CMG008
      ** Convert MG8665                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8665                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8665 = WConvFld                                          CMG008
      ** Convert MG8632                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8632                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8632 = WConvFld                                          CMG008
      ** Convert MG8633                                                                       CMG008
     C                   Eval      WConvFld = *Blanks                                         CMG008
     C                   Eval      WConvFld = MG8633                                          CMG008
     C                   Exsr      ConvChar                                                   CMG008
     C                   Eval      MG8633 = WConvFld                                          CMG008
                                                                                              CMG008
      *                  -----                                                                CMG008
     C                   ENDSR                                                                CMG008
                                                                                              CMG008
      /EJECT                                                                                  CMG008
      *========================================================================*              CMG008
      * BldConvFil : Build Conversion Table for removing non-SWIFT characters  *              CMG008
      *------------------------------------------------------------------------*              CMG008
                                                                                              CMG008
     C     BldConvFil    BEGSR                                                                CMG008
      *    ----------    -----                                                                CMG008
      *                                                                                       CMG008
      ** Open Character conversion file                                                       CMG008
     C                   Open      MGCONVPD                                                   CMG008
      *                                                                                       CMG008
      ** Initialise work fields                                                               CMG008
     C                   Eval      Fr_Char = *Blanks                                          CMG008
     C                   Eval      To_Char = *Blanks                                          CMG008
     C                   Eval      WChrLen = 0                                                CMG008
                                                                                              CMG008
      ** Read file and collect characters in FROM and TO alpha fields                         CMG008
     C     *Loval        Setll     MGCONVPD                                                   CMG008
     C                   Read      MGCONVPD                                                   CMG008
                                                                                              CMG008
     C                   Dow       NOT %EOF                                                   CMG008
     C                   Eval      Fr_Char = %SUBST(Fr_Char:1:WChrLen)+FRCHAR                 CMG008
     C                   Eval      To_Char = %SUBST(To_Char:1:WChrLen)+TOCHAR                 CMG008
     C                   Eval      WChrLen = WChrLen + 1                                      CMG008
                                                                                              CMG008
     C                   Read      MGCONVPD                                                   CMG008
     C                   Enddo                                                                CMG008
      *                                                                                       CMG008
      ** Close file                                                                           CMG008
     C                   Close     MGCONVPD                                                   CMG008
      *                  -----                                                                CMG008
     C                   ENDSR                                                                CMG008
                                                                                              CMG008
      *========================================================================*              CMG008
      * ConvChar : Convert Character and remove remove invalid non-SWIFT chars *              CMG008
      *------------------------------------------------------------------------*              CMG008
                                                                                              CMG008
     C     ConvChar      BEGSR                                                                CMG008
      *    --------      -----                                                                CMG008
      *                                                                                       CMG008
      ** Only process field if not blank                                                      CMG008
     C                   If        WConvFld <> *BLANKS                                        CMG008
                                                                                              CMG008
      ** Convert all non-SWIFT characters based on conversion table                           CMG008
     C                   Eval      WConvFld = %XLATE(%TRIM(Fr_Char)                           CMG008
     C                                        :%TRIM(To_Char):WConvFld)                       CMG008
                                                                                              CMG008
      ** Convert all remaining non-SWIFT chars (not defined in the table)                     CMG008
      ** into blanks. Use pre-defined 'Valid Swift Chars' field for comparison.               CMG008
     C                   Eval      WChrPos = 0                                                CMG008
     C                   Eval      WChrPos = %CHECK(ValSwiftChr:WConvFld)                     CMG008
                                                                                              CMG008
      ** Repeat process until all invalid chars are found and converted to blank              CMG008
     C                   Dow       WChrPos > 0                                                CMG008
     C                   Eval      WConvFld=%REPLACE(WBlank:WConvFld:WChrPos:1)               CMG008
     C                   Eval      WChrPos = 0                                                CMG008
     C                   Eval      WChrPos = %CHECK(ValSwiftChr:WConvFld)                     CMG008
     C                   Enddo                                                                CMG008
                                                                                              CMG008
     C                   Endif                                                                CMG008
      *                  -----                                                                CMG008
     C                   ENDSR                                                                CMG008
                                                                                              CMG008
      *****************************************************************                    BUG23280A
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by : Implicitly on program activation                 *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Initialize Copyright Array
      *
     C                   MOVEA     CPY@          WCpy
      *
      ** Entry Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    PReturnOut
     C                   PARM                    PMsgTyp
     C                   PARM                    GLPosting
     C                   PARM                    MLPosting
      *
      ** Check if feature CER031  is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CER031'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CER031 = 'Y'
     C                   ELSE
      *
      ** Else, database error (return code other than *NRF)
      *
     C                   IF        PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = PSard
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      CER031 = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                     BUG23742
      ** Check if feature CER030  is installed                                              BUG23742
      *                                                                                     BUG23742
     C                   CALL      'AOSARDR0'                                               BUG23742
     C                   PARM      *BLANKS       PRtcd                                      BUG23742
     C                   PARM      '*VERIFY'     POptn                                      BUG23742
     C                   PARM      'CER030'      PSard                                      BUG23742
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG23742
      *                                                                                     BUG23742
     C                   IF        PRtcd = *BLANKS                                          BUG23742
     C                   EVAL      CER030 = 'Y'                                             BUG23742
     C                   ELSE                                                               BUG23742
      *                                                                                     BUG23742
      ** Else, database error (return code other than *NRF)                                 BUG23742
      *                                                                                     BUG23742
     C                   IF        PRtcd <> '*NRF   '                                       BUG23742
     C     *LOCK         IN        LDA                                                      BUG23742
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG23742
     C                   EVAL      DBKEY = PSard                                            BUG23742
     C                   EVAL      DBASE = 2                                                BUG23742
     C                   OUT       LDA                                                      BUG23742
     C                   EXSR      *PSSR                                                    BUG23742
     C                   ELSE                                                               BUG23742
     C                   EVAL      CER030 = 'N'                                             BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                    BUG23280A
      ** KList for file GLNW94L8,L11                                                       BUG23280A
      *                                                                                    BUG23280A
     C     KAcct         KLIST                                                             BUG23280A
     C                   KFLD                    KBrca                                     BUG23280A
     C                   KFLD                    KCNum                                     BUG23280A
     C                   KFLD                    KCcy                                      BUG23280A
     C                   KFLD                    KAccd                                     BUG23280A
     C                   KFLD                    KAcsq                                     BUG23280A
     C                   KFLD                    KNaty                                        263479
     C                   KFLD                    KDstn                                        263479
      *                                                                                       263479
     C     KAcct2        KLIST                                                                263479
     C                   KFLD                    KBrca                                        263479
     C                   KFLD                    KCNum                                        263479
     C                   KFLD                    KCcy                                         263479
     C                   KFLD                    KAccd                                        263479
     C                   KFLD                    KAcsq                                        263479
      *
     C     KRef          KLIST
     C                   KFLD                    WRefId
     C                   KFLD                    WRefNo
      *
     C     KBatch        KLIST
     C                   KFLD                    WBatch
     C                   KFLD                    WItem
      *                                                                                     BUG23742
     C     KNarr1        KLIST                                                              BUG23742
     C                   KFLD                    WDate                                      BUG23742
     C                   KFLD                    WBatch                                     BUG23742
     C                   KFLD                    WItem                                      BUG23742
      *
     C                   EVAL      WBatch = WkBatch
     C                   MOVE      WkItem        WItem
     C                   EVAL      WDate  = WkPstd                                          BUG23742
      *
                                                                                            BUG26814
      ** Retrieve system values.                                                            BUG26814
                                                                                            BUG26814
     C                   CALL      'AOSVALR0'                                               BUG26814
     C                   PARM      *BLANKS       PRtcd                                      BUG26814
     C                   PARM      WKeySysVal1   PSValK1                                    BUG26814
     C                   PARM                    PSVal1                                     BUG26814
     C                   PARM                    PSValK2                                    BUG26814
     C                   PARM                    PSVal2                                     BUG26814
     C                   PARM                    PSValK3                                    BUG26814
     C                   PARM                    PSVal3                                     BUG26814
     C                   PARM                    PSValK4                                    BUG26814
     C                   PARM                    PSVal4                                     BUG26814
     C                   PARM                    PSValK5                                    BUG26814
     C                   PARM                    PSVal5                                     BUG26814
     C                   PARM                    PSValK6                                    BUG26814
     C                   PARM                    PSVal6                                     BUG26814
     C                   PARM                    PSValK7                                    BUG26814
     C                   PARM                    PSVal7                                     BUG26814
     C                   PARM                    PSValK8                                    BUG26814
     C                   PARM                    PSVal8                                     BUG26814
     C                   PARM                    PSValK9                                    BUG26814
     C                   PARM                    PSVal9                                     BUG26814
     C                   PARM                    PSValK0                                    BUG26814
     C                   PARM                    PSVal0                                     BUG26814
                                                                                            BUG26814
      ** If the system value is not found then issue a database error.                      BUG26814
                                                                                            BUG26814
     C                   IF        PRtcd    <> *BLANKS                                      BUG26814
     C     *LOCK         IN        LDA                                                      BUG26814
     C                   EVAL      DBFile = 'SDSVALPD'                                      BUG26814
     C                   EVAL      DBase = 002                                              BUG26814
                                                                                            BUG26814
     C                   IF        PSVal1 = '*NRF'                                          BUG26814
     C                   EVAL      DBKey = PSValK1                                          BUG26814
     C                   ENDIF                                                              BUG26814
     C                   ENDIF                                                              BUG26814
                                                                                            BUG26814
      ** Check if feature CMG008 is installed                                                 CMG008
                                                                                              CMG008
     C                   EVAL      CMG008 = 'N'                                               CMG008
                                                                                              CMG008
     C                   CALL      'AOSARDR0'                                                 CMG008
     C                   PARM      *BLANKS       PRtcd                          Return Code   CMG008
     C                   PARM      '*VERIFY'     POptn                          Option        CMG008
     C                   PARM      'CMG008 '     PSard                          Feature Ref   CMG008
                                                                                              CMG008
     C                   IF        PRtcd = *BLANKS                                            CMG008
     C                   MoveL     'Y'           CMG008            1                          CMG008
     C                   ENDIF                                                                CMG008
                                                                                              CMG008
      * If CMG008 is ON, build the character conversion table                                 CMG008
                                                                                              CMG008
     C                   IF        CMG008 = 'Y'                                               CMG008
     C                   EXSR      BldConvFil                                                 CMG008
     C                   ENDIF                                                                CMG008
                                                                                              CMG008
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by : (**calling routines**)                           *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        PReturnOut = *BLANKS
     C                   EVAL      PReturnOut = 'PSSR_ERROR'
     C                   ENDIF
      *
     C                   DUMP
     C                   ROLBK
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2008
**CTDATA TransType
FP FX Foreign Exch. Purch.
FS FX Foreign Exch. Sold
CX FX Cross Deal
SW FX Swap Deal
OP FX Option
OT FX Option Takedown
PI FX Purch. Cover. Inter.
SI FX Sale Cover. Interest
RF IR Interest Rate Floors
RP IR Interest Rate Caps
RR IR Interest Rate Collar
RS IR Single curr.int.Swap
RX IR Single curr.int.Swap
FR FR Future Rate Agreement
IT MM Interbank taking
IP MM Interbank placing
TD MM Time deposit
TI MM Time loan
CI MM CD issued
CD MM Call/notice deposit
CL MM Call/notice deposit
DL MM Demand loan
C1 NP Primary CD
C2 NP Secondary CD
BP NP Bond
BD NP Bill
TB NP Treasury bill
DA NP Bank acceptance
TA NP Trade acceptance
CS NS Primary or secondary CD sold
BS NS Bond Sold
BR NS Bill Sold
TS NS Treasury bill Sold
RA NS Bank acceptance Sold
TR NS Trade acceptance Sold
FL DF Fixed term Placing (Bank side)
FT DF Fixed term Taking (Customer side)
DT DF Call Taking
LT DF Call Taking (Fiduciary Loan)
DP DF Call Placing
LP DF Call Placing (Fiduciary Loan)
**CTDATA WFldLen1                                                                           BUG26814
2710353535353535353535351224353503272734353535353535                                        BUG26814
**CTDATA WFldLen2                                                                           BUG26814
2710272727272727272727271224272703272734272727272727                                        BUG26814
