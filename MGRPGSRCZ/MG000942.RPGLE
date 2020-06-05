     H DEBUG
     H*FTRANS**********************************************************                     AR858070
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MG Format interim transaction message')          *
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation Module                            *
      *                                                               *
      *  RPGLE/MG000942 - Midas MG Format interim transaction message *
      *                                                               *
      *  Function:  This module generates the MT942 messages for the  *
      *             Message Generation Module                         *
      *                                                               *
      *  Component of: GLC001415                                      *
      *                                                               *
      *  Remark: This module uses prototyped procedures.              *
      *          Their names start by #                               *
      *          They are written in MOD/MGCMNFCT                     *
      *          #SWIFTDt : Convert Midas date to Swift Date.         *
      *          #SWIFTAm : Convert Midas Amount in SWIFT Amount.     *
      *          #RtvTRNO : Retrieve the Transaction Reference.       *
      *          #RtvACID : Retrieve the Account Identifier.          *
      *          #RtvDtTm : Retrieve Date/Time Indication.            *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD055842           Date 02Jun20               *
      *  Prev Amend No. CMG008             Date 20Feb20               *
      *                 MD046248           Date 27Oct17               *
      *                 MD042041           Date 21Oct16               *
      *                 AR757762           Date 19Aug14               *
      *                 AR858070           Date 03Nov11               *
      *                 CGL146             Date 10Jul13               *
      *                 AR787620           Date 10Jun11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26515           Date 06Nov09               *
      *                 BUG26075           Date 18Sep09               *
      *                 BUG25800A          Date 16Sep09               *
      *                 BUG25529           Date 26Aug09               *
      *                 BUG25800           Date 01Sep09               *
      *                 BUG25476A          Date 28Aug09               *
      *                 BUG25311           Date 10Aug09               *
      *                 BUG24278           Date 16Jun09               *
      *                 BUG24069           Date 08Jun09               *
      *                 BUG23742           Date 26May09               *
      *                 BUG23280D          Date 10May09               *
      *                 BUG23280B          Date 18Apr09               *
      *                 BUG23040B          Date 01Apr09               *
      *                 BUG23040A          Date 25Mar09               *
      *                 BUG23284           Date 13Mar09               *
      *                 BUG23247           Date 10Mar09               *
      *                 BUG23280           Date 09Mar09               *
      *                 BUG23040           Date 04Mar09               *
      *                 BUG23172           Date 06Mar09               *
      *                 BUG23029           Date 02Mar09               *
      *                 BUG23032A          Date 27Feb09               *
      *                 BUG23032           Date 20Feb09               *
      *                 BUG22995           Date 20Feb09               *
      *                 BUG22981           Date 18Feb09               *
      *                 BUG22853           Date 12Feb09               *
      *                 BUG22687           Date 06Feb09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL013  *Create    Date 14May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055842 - Second tag 86 not translated to To Characters.    *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD042041 - Tag 61 is not sorted by DRCR and PSTA. Added a    *
      *             system value that when is set to 'Y', program     *
      *             use another logical file that is also sorted by   *
      *             DRCR and PSTA.                                    *
      *  AR757762 - MT942 Generation Error. Changed the number of     *
      *             occurrences for DsMsgRef to 9999.                 *
      *             (Child: AR757763)                                 *
      *  AR858070 - German characters from JE narratives are          *
      *             converted wrong into the messages (Child:AR858071)*
      *  CGL146 - MT940/MT950 Production in Input Cycle               *
      *           Added hooks: CGL146_001, CGL146_061, CGL146_062     *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,MGH00032                                 *
      *             WNCPYSRC,MGH00033                                 *
      *             WNCPYSRC,MGH00034                                 *
      *             WNCPYSRC,MGH00035                                 *
      *             WNCPYSRC,MGH00036                                 *
      *             WNCPYSRC,MGH00037                                 *
      *             WNCPYSRC,MGH00038                                 *
      *             WNCPYSRC,MGH00039                                 *
      *             WNCPYSRC,MGH00040                                 *
      *             WNCPYSRC,MGH00041                                 *
      *             WNCPYSRC,MGH00042                                 *
      *             WNCPYSRC,MGH00043                                 *
      *             WNCPYSRC,MGH00044                                 *
      *             WNCPYSRC,MGH00045                                 *
      *             WNCPYSRC,MGH00046                                 *
      *             WNCPYSRC,MGH00047                                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26515 - Lines 2 onwards were dropped in the flat file     *
      *  BUG26075 - Multicash Field 25 in error                       *
      *  BUG25800A - revert fix applied                               *
      *  BUG25529 - Multicash for Midas Plus requires GVC code on     *
      *             multicash narrative                               *
      *  BUG25800 - Missing subfield 4 - field 61 of MT940            *
      *             at regression test                                *
      *  BUG25476A - MT940 rejected by MMM                             *
      *  BUG25311 - Missing extended narrative on GCMS MT940          *
      *  BUG24278 -  Improper handling of /IACC/Dn indicator          *
      *  BUG24069 -  /IACC indicator not removed when network is not  *
      *              Multicash                                        *
      *  BUG23742 -  Improper handling of Ext Narr from Batch         *
      *              Interface Input                                  *
      *  BUG23280D - Extended Narrative incorrectly displayed in      *
      *              MT942/MT940                                      *
      *  BUG23280B - Extended Narrative incorrectly displayed in      *
      *              MT942/MT940                                      *
      *  BUG23040B - /IACC/Dn indicator formatting should not happen  *
      *              for non Multicash Networks                       *
      *  BUG23040A - MMM does not reformat Multicash MT942 with       *
      *             /IACC/Dn indicator                                *
      *  BUG23284 - Wrong Field 61 subfield 6 for SWIFT               *
      *  BUG23247 - Incorrect handling of invalid /IACC/Dn indicator  *
      *  BUG23280 - Extended Narrative incorrectly displayed in       *
      *             MT942/MT940                                       *
      *  BUG23040 - MMM does not reformat Multicash MT942 with        *
      *             /IACC/Dn indicator                                *
      *  BUG23172 - Account Number for SWIFT messages is always in    *
      *             IBAN format.                                      *
      *  BUG23029 - Field 21 conditioning for Multicash Network       *
      *  BUG23032A - /IACC/Dn indicator should not show on Field 86   *
      *  BUG23032 - /IACC/Dn indicator should not show on Field 86    *
      *  BUG22995 - Wrong GVC code output in field 86                 *
      *  BUG22981 - GVC characters should not be included in output   *
      *             for Multicash MT942 message in field 86           *
      *  BUG22853 - /IACC/Dn indicator should not show on Field 86    *
      *             when the network is not multicash                 *
      *  BUG22687 - Various error on MT94x generation                 *
      *  CER030 - Multicash German Feature                            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************

     FMGF942PD  UF   E             DISK    COMMIT
      ** Midas MG MT942 Gen. Extract File - Account detail

     FMGX942L0  UF   E           K DISK    COMMIT
      ** Midas MG MT942 Gen. Extract File - Posting Detail

     FMGX942L1  UF   E           K DISK    COMMIT                                           MD042041
     F                                     RENAME(MGX942D0:MGX942D1)                        MD042041

     FGLNW94L5  IF   E           K DISK
      ** Midas GL Network Accounts - MT94x - Live/Accnt+Dst

     FMEP920L0  UF   E           K DISK    COMMIT
      ** Midas ME Incoming MT920 Parts file

     FSDCUSTL7  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Customers by unique SWIFT ID

     FMGOMSGPD  O    E             DISK    COMMIT  PREFIX(Mo_)
      ** Midas MG Master Message Data file

     FMGOREFPD  O    E             DISK    COMMIT  PREFIX(Mr_)
      ** Midas MG Master Messages Reference file

     FSDCONVPD  IF   E           K DISK                   INFSR(*PSSR) USROPN               MD055842
      ** SWIFT Character Conversion file                                                    MD055842
                                                                                            MD055842
     FMG000942AUO    E             PRINTER USROPN
      ** Midas MG Interim Transaction Report - Audit

      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Database Access Indicators                                             *
      *                                                                        *
      * 27 - Access MT942 Extract File - Account detail (PF/MGF942PD)          *
      * 28 - Access MT942 Extract File - Posting Detail (LF/MGX942L0)          *
      *                                                                        *
      * Database Error Indicators                                              *
      *                                                                        *
      * U7 - Abnormal Completion                                               *
      * U8 - File Out of Balance                                               *
      * U7 + U8 - Database Error                                               *
      *                                                                        *
      * Other Indicators                                                       *
      *                                                                        *
      * 99 - Multi-purpose                                                     *
      *                                                                        *
      *========================================================================*

      *========================================================================*
      ** Automatically included D-specs
      ** ==============================

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** Manually included D-specs
      ** =========================

      ** Named constants
      ** ---------------

     D CRLF            C                   CONST(X'0D25')                       CRLF Control Charact

      ** Arrays and Data Structures
      ** --------------------------

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data Structure for Bank Details.

     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      **  Data structure for message management data.

     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)
      **  Data Structure for Network Details.

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      **  Data Structure for Branch details.

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **  Data Structure for Currency Details.

     D GLACCNT       E DS                  EXTNAME(ACCNTAB)  PREFIX(Gl_)
      **  Data Structure for Account Details.

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
      **  Data Structure for Customer Details.

     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(Sc_)
      **  External data structures for Switchable Features Details

     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  First DS for access programs, long data structure.

     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Second DS for access programs, short data structure.

     D DSLDY         E DS                  EXTNAME(DSLDY)
      **  Third DS for access programs, very long data structure.

     D MGAccDetl     E DS                  EXTNAME(MGF942PD)
      **  Data structure for MT942 Account details.
     D**MGNetAcc                     25           OVERLAY(MGAccDetl:1)                        CGL029
      ****Define*the*Network*Account.**********************************                       CGL029
     D**MGAccnt*                     18           OVERLAY(MGAccDetl:7)                        CGL029
      ****Define*the*full*account*number.******************************                       CGL029
     D  ArMGMIO                      65A   DIM(6) OVERLAY(MGAccDetl:139)
      **  Array containing the Manual Prod. Messages from 1 to 6
      *                                                                                       CER030
     D*ArrExtNar       S             70A   DIM(20)                                   CER030 BUG23742
     D ArrExtNar       S             70A   DIM(22)                                          BUG23742
      *                                                                                     BUG23742
      ** Array for 22 * 35                                                                  BUG23742
      *                                                                                     BUG23742
     D PArrExt         S             35A   DIM(22)                                          BUG23742
      *                                                                                       CER030
      ** Array of error message data                                                          CER030
      *                                                                                       CER030
     D MsgDtaXAr       S             45A   DIM(40)                                            CER030
      *                                                                                       CER030
      ** Array of error message IDs                                                           CER030
      *                                                                                       CER030
     D MsgIDXAr        S              7A   DIM(40)                                            CER030
      *                                                                                       CER030
      ** Array of Fields with warnings                                                        CER030
      *                                                                                       CER030
     D WFldNmXAr       S             10A   DIM(40)                                            CER030
      *                                                                                       CER030
      ** Array of warning message data                                                        CER030
      *                                                                                       CER030
     D WMsgDtXAr       S             45A   DIM(40)                                            CER030
      *                                                                                       CER030
      ** Array of warning message IDs                                                         CER030
      *                                                                                       CER030
     D WMsgIDXAr       S              7A   DIM(40)                                            CER030
      *                                                                                       CER030
      ** Array of Fields in error                                                             CER030
      *                                                                                       CER030
     D FldNamXAr       S             10A   DIM(40)                                            CER030
     D/COPY WNCPYSRC,MGH00032

     D MGNetAcc        DS                                                                     CGL029
     D  MGAccnt                      24A   OVERLAY(MGNetAcc:7)                                CGL029
     D  WkNWRK                             LIKE(MGNWRK)                                       CGL029
     D  WkBRCA                             LIKE(MGBRCA)                                       CGL029
     D  WkCUST                             LIKE(MGCNUM)                                       CGL029
     D  WkCCY                              LIKE(MGCCY)                                        CGL029
     D  WkACCD                             LIKE(MGACCD)                                       CGL029
     D  WkACSQ                             LIKE(MGACSQ)                                       CGL029
     D  WkNATY                             LIKE(MGNATY)                                       CGL029
      ** Network and Full Account Data Structure                                              CGL029
                                                                                              CGL029
     D DsMGADI         DS
      **  Data structure for MT942 Posting details - Additional information.
     D  MGADI1                       65A                                        Additional Inf. 1
     D  MGADI2                       65A                                        Additional Inf. 2
     D  MGADI3                       65A                                        Additional Inf. 3
     D  MGADI4                       65A                                        Additional Inf. 4
     D  MGADI5                       65A                                        Additional Inf. 5
     D  MGADI6                       65A                                        Additional Inf. 6
     D ArMGADI                       65A   DIM(6) OVERLAY(DsMGADI)
      **  Array containing the Additional Information from 1 to 6

     D*MULT*****       DS                  OCCURS(200)                                      BUG22687
     D MULT            DS                  OCCURS(999)                                      BUG22687
      **  Multiple occurrence data structure for message
     D  MTAG                   1      5                                         Tag
     D  MFLD                   6     55                                         Message Field Detail
     D  CTRC                  56     57                                         CR/LF field

     D  M              S              5U 0                                      Multi Occurence Idx
     D  P              S              5U 0                                      Previous Occure Idx
     D  L              S              5U 0                                      Last Occurence Idx

     D***DsMsgRef      E DS                  OCCURS(100)                                    AR757762
     D DsMsgRef      E DS                  OCCURS(9999)                                     AR757762
      **  Data structure to receive Master Messages Reference.
     D                                     EXTNAME(MGOREFPD) PREFIX(Mr_)

     D  Mr             S              5U 0                                      Multi Occurence Idx

     D DsResult        DS
      **  Data structure to receive result greater than 50 Characters.
     D  WkMult1                      50A                                        Fisrt 50 characters
     D  WkMult2                      50A                                        Last 50 characters

      ** Declared variables
      ** ------------------

     D P@RTCD          S              7A                                        Return Code
     D P@OPTN          S              7A                                        Option
     D P@NWRK          S              6A                                        Network Code
     D P@SARD          S              6A                                        Feature
     D P@BRCD          S              3A                                        Branch Code
     D P@CNUM          S              6A                                        Customer
     D P@CCY           S              3A                                        Currency Code
     D***P@ACCD*         S              4A                                        Account codeCGL029
     D P@ACCD          S             10A                                                      CGL029
     D P@ACSQ          S              2A                                        Account Sequence
     D P@RETL          S             10A                                        Retail Number
     D P@KEY1          S             10A
     D P@KYST          S              7A
     D KeyIMIR         S                   LIKE(MPIMIR)                         Network
     D KeyMSGR         S                   LIKE(MPMSGR)                         Branch Code - Alpha
     D KeyACTR         S                   LIKE(MPACTR)                         Customer number

     D MaxLength       S                   LIKE(ED2MXL)                         Maximum Length
     D CurLength       S                   LIKE(ED2MXL)                         Current Length
     D CurPagSeq       S              5U 0                                      Curr. Page Sequence
     D CurTRNO         S                   LIKE(Mr_TRNO)                        Curr. Transact. Ref.
     D SavNWRK         S                   LIKE(MGNWRK)                         Saved Network
     D SavBRCA         S                   LIKE(MGBRCA)                         Saved Branch code
     D SavCCY          S                   LIKE(MGCCY )                         Saved Currency
     D NbItems         S              5U 0                                      Nb. Movement by Msg
     D SavMULT         S             57A                                        Save MULT

     D CSW020          S              1    INZ('N')                             SWIFT Decimal Places

     D  X              S              5U 0                                      Working index
     D  WkMGDE         S              6A                                        Working field
     D  WkCnum         S              7
     D  WSwiftId       S             12

     D PRtcd           S             10A                                                      CER030
     D POptn           S              7A                                                      CER030
     D PSard           S              6A                                                      CER030
     D PNwrk           S              6A                                                      CER030
     D PMsgTyp         S              3A                                                      CER030
     D PBrca           S              3A                                                      CER030
     D*PCNum****       S              6  0                                             CER030 CER059
     D PCNum           S              6A                                                      CER059
     D PCcy            S              3A                                                      CER030
     D PAcno           S             10S 0                                                    CER030
     D PAcsq           S              2S 0                                                    CER030
     D PDCInd          S              1A                                                      CER030
     D PRtty           S              5A                                                      CER030
     D PNarr1          S             65A                                                      CER030
     D PNarr2          S             65A                                                      CER030
     D PNarr3          S             65A                                                      CER030
     D PNarr4          S             65A                                                      CER030
     D PNarr5          S             65A                                                      CER030
     D PNarr6          S             65A                                                      CER030
     D PFormL1         S             70A                                                      CER030
     D PFormL2         S             70A                                                      CER030
     D PFormL3         S             70A                                                      CER030
     D PFormL4         S             70A                                                      CER030
     D PFormL5         S             70A                                                      CER030
     D PFormL6         S             70A                                                      CER030
     D PFormL7         S             70A                                                      CER030
     D PFormL8         S             70A                                                      CER030
     D PFormL9         S             70A                                                      CER030
     D PFormL10        S             70A                                                      CER030
     D PFormL11        S             70A                                                      CER030
     D PFormL12        S             70A                                                      CER030
     D PFormL13        S             70A                                                      CER030
     D PFormL14        S             70A                                                      CER030
     D PFormL15        S             70A                                                      CER030
     D PFormL16        S             70A                                                      CER030
     D PFormL17        S             70A                                                      CER030
     D PFormL18        S             70A                                                      CER030
     D PFormL19        S             70A                                                      CER030
     D PFormL20        S             70A                                                      CER030
     D PFormL21        S             70A                                                    BUG23742
     D PFormL22        S             70A                                                    BUG23742
     D WKTag           S              5A                                                      CER030
     D WKValue         S            100A                                                      CER030
     D WFld86          S           9999A                                                      CER030
     D WKPos           S              5S 0                                                    CER030
     D WKEnd           S              5S 0                                                    CER030
     D WFrstFlg        S              1A                                                      CER030
     D WFldSep         S              1A                                                      CER030
     D WPos            S              3S 0                                                    CER030
     D WFinStr         S            700A                                                      CER030
     D WLen            S              3  0                                                    CER030
     D WIdx            S              3S 0                                                    CER030
     D WSubfld4        S              1A                                                      CER030
     D Idx             S              3  0                                                    CER030
     D CER030          S              1A                                                      CER030
     D MGX942          S              5A                                                    BUG22995
     D PCusN           S              6A                                                    BUG23172
     D PKey1           S             10A                                                    BUG23172
     D PKyst           S              7A                                                    BUG23172
     D PAcctCde        S             10A                                                    BUG23172
     D PAcctSeq        S              2A                                                    BUG23172
     D PRetl           S             10A                                                    BUG23172
     D WDCInd          S              1A                                                    BUG23040
     D WExtNar         S            390A                                                    BUG23280
     D WIndLn          S              3S 0                                                  BUG23247
     D WFst            S              1A                                                   BUG25476A
     D WResult         S             70A                                                   BUG25476A
      *                                                                                     BUG25529
      ** Parameter Variables to call 'AOSVALR0'                                             BUG25529
      *                                                                                     BUG25529
     D PSValK1         S             20A                                                    BUG25529
     D PSValK2         S             20A                                                    BUG25529
     D PSValK3         S             20A                                                    BUG25529
     D PSValK4         S             20A                                                    BUG25529
     D PSValK5         S             20A                                                    BUG25529
     D PSValK6         S             20A                                                    BUG25529
     D PSValK7         S             20A                                                    BUG25529
     D PSValK8         S             20A                                                    BUG25529
     D PSValK9         S             20A                                                    BUG25529
     D PSValK10        S             20A                                                    BUG25529
     D PSVal1          S            200A                                                    BUG25529
     D PSVal2          S            200A                                                    BUG25529
     D PSVal3          S            200A                                                    BUG25529
     D PSVal4          S            200A                                                    BUG25529
     D PSVal5          S            200A                                                    BUG25529
     D PSVal6          S            200A                                                    BUG25529
     D PSVal7          S            200A                                                    BUG25529
     D PSVal8          S            200A                                                    BUG25529
     D PSVal9          S            200A                                                    BUG25529
     D PSVal10         S            200A                                                    BUG25529
      *                                                                                     BUG25529
     D WFld21          S              3S 0                                                  BUG25529
     D WFld21a         S              1A                                                    BUG26515
     D PRtcd1          S              7A                                                    BUG25529
     D SValK1          C                   CONST('MT94xFld86Max')                           BUG25529
     D SValK2          C                   CONST('MT94xFld86LineOutput')                    BUG26515
     D SValK3          C                   CONST('MT94xAddedSortfor61')                     MD042041
     D WSort61         S              1A                                                    MD042041
      *                                                                                       CER030
     D WConv           S              1A                                                    MD055842
                                                                                            MD055842
     D ValSwiftChr     C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZ+               MD055842
     D                                            abcdefghijklmnopqrstuvwxyz+               MD055842
     D                                            0123456789+()?:-/,''. ')                  MD055842
      ** Valid Swift Characters                                                             MD055842
                                                                                            MD055842
     D WBlank          C                   CONST(' ')                                       MD055842
      ** Replacement Blank character                                                        MD055842
                                                                                            MD055842
     D WConvFld        S             65A                                                    MD055842
      ** String to be converted                                                             MD055842
                                                                                            MD055842
     D To_Char         S            100A                                                    MD055842
      ** TO character string                                                                MD055842
                                                                                            MD055842
     D Fr_Char         S            100A                                                    MD055842
      ** FROM character string                                                              MD055842
                                                                                            MD055842
     D WChrPos         S              3S 0                                                  MD055842
      ** Work field for %CHECK and %REPLACE operation                                       MD055842
                                                                                            MD055842
     D WChrLen         S              3S 0                                                  MD055842
      ** Work field for %SUBST operation                                                    MD055842
                                                                                            MD055842
     D/COPY WNCPYSRC,MGH00033
     D/COPY MGCPYSRC,MGCMNFCTDC
     D/COPY OFCPYSRCZ,CGL146_001                                                              CGL146

      ** Input Specs
      ** -----------

      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

      ** Read the first record from the MT942 extract file

     C                   READ      MGF942D0                               27

      ** Format Message Control.

      ** Do While records found on the MT942 extract file

     C                   DOW       NOT *IN27

      ** Initialize Working fields.

     C                   EXSR      $InitWkFld

      ** Retrieve Network details.

     C                   EXSR      $RtvNwrk

      ** Retrieve Branch details.

     C                   EXSR      $RtvBrch

      ** Retrieve Currency details.

     C                   EXSR      $RtvCCY

      ** Retrieve Network Account Details.

     C                   EXSR      $RtvNWAc

      ** Calculate the number of available characters by message.

     C                   EXSR      $RtvNbChar

      ** Retrieve Message Definition (Tag 20, 21, 25, 28, 34F, 13D)

     C                   EXSR      $RtvMsgDfn

      ** Process each account movement.

     C                   IF        WSort61 = 'Y'                                            MD042041
     C     Key           SETLL     MGX942L1                                                 MD042041
     C                   READE     MGX942D1                               28                MD042041
     C                   ELSE                                                               MD042041
     C     Key           SETLL     MGX942L0
     C     Key           READE     MGX942D0                               28
     C                   ENDIF                                                              MD042041
     C                   DOW       NOT *IN28

     ** Check the number of items by message

     C                   IF        ED2FNI = 'Y'                                 Fix number of items
     C                             AND NbItems = ED2NIM                         Number of items

      **   Create Message Details.

     C                   EXSR      $CrtMsgDtl

      **   Load Master Messages Reference data structure.

     C                   EXSR      $LdMsgRef

      **   Retrieve Next Message Definition (Tag 20, 21, 25, 28, 34F, 13D).

     C                   EXSR      $RtvMsgDfn

     C                   ENDIF

      ** Update number of items.

     C                   EVAL      NbItems = NbItems + 1                        Number of items

      ** Check the maximun of occurence.

      **  The maximum of occurence before to process a new items is:
      **    the number of occurence
      **    - 2 (tag 61 could be on 2 lines)
      **    - 6 (tag 86 could be on 6 lines)

     C                   IF        M >= %ELEM(MULT) - 8

      **   Create Message Details.

     C                   EXSR      $CrtMsgDtl

     C                   ENDIF

      ** Save the Previous number of occurence

     C                   EVAL      P = M

      ** Format field :61:

     C                   EXSR      $FMT61

      ** Format field :86:

     C                   EXSR      $FMT86

      ** Check the maximum length.

     C                   IF        CurLength > MaxLength

      **   Save the Last number of occurence.
      **   Load M with the previous occurence.

     C                   EVAL      L = M
     C                   EVAL      M = P

      **   By this way, M contains the occurences to unload on MGOMSGPD,
      **                P contains the last occurence processed,
      **                L contains the last occurence to process.

      **   Create Message Details.

     C                   EXSR      $CrtMsgDtl

      **   Load Master Messages Reference data structure.

     C                   EXSR      $LdMsgRef

      **   Retrieve Next Message Definition (Tag 20, 21, 25, 28, 34F, 13D).

     C                   EXSR      $RtvMsgDfn

      **   Shift the items not process to the correct occurence.

     C                   EXSR      $ShiftItem

     C                   ENDIF

      ** Delete account movement.

     C                   IF        WSort61 = 'Y'                                            MD042041
     C                   DELETE    MGX942D1                             99                  MD042041
     C                   ELSE                                                               MD042041
     C                   DELETE    MGX942D0                             99
     C                   ENDIF                                                              MD042041

      ** If Error,

     C                   IF        *IN99
     C     *LOCK         IN        LDA
     C                   EXSR      SRAccnt                                                    CGL029
     C                   EVAL      DBASE  = 006                                 * * * * * * * *
     C                   EVAL      DBKEY  = MGNetAcc                            *  DBERR 006  *
     C                   EVAL      DBFILE = 'MGX942PD'                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Next account movement.

     C                   IF        WSort61 = 'Y'                                            MD042041
     C     Key           READE     MGX942D1                               28                MD042041
     C                   ELSE                                                               MD042041
     C     Key           READE     MGX942D0                               28
     C                   ENDIF                                                              MD042041
     C                   ENDDO

      ** If Number and Sum of Entries (D/C) has to be generated.

     C                   IF        N42LSF = 'Y'                                 Number and Sum of En

      ** Format field :90D:

     C                   EXSR      $FMT90D

      ** Format field :90C:

     C                   EXSR      $FMT90C

     C                   ENDIF

      ** Format field :86: (additional information for the whole message)

     C                   EXSR      $FMT86F

      ** Create Message Details

     C                   EXSR      $CrtMsgDtl

      ** Load Master Messages Reference data structure.

     C                   EXSR      $LdMsgRef

      ** Create Message Reference.

     C                   EXSR      $CrtMsgRef

      ** Delete the Message.

     C                   DELETE    MGF942D0                             99

      ** If Error,

     C                   IF        *IN99
     C     *LOCK         IN        LDA
     C                   EXSR      SRAccnt                                                    CGL029
     C                   EVAL      DBASE  = 007                                 * * * * * * * *
     C                   EVAL      DBKEY  = MGNetAcc                            *  DBERR 007  *
     C                   EVAL      DBFILE = 'MGF942PD'                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** COMMIT all changes.

     C                   COMMIT

      ** Read next messages.

     C                   READ      MGF942D0                               27

     C                   ENDDO

     C                   EVAL      *INLR = *On
     C                   RETURN

      *========================================================================*
      * $InitWkFld: Initialize working fields.                                 *
      *------------------------------------------------------------------------*

     C     $InitWkFld    BEGSR
      *    ----------    -----

     C                   EVAL      MaxLength = *ZEROS                           Maximum Length
     C                   EVAL      Curlength = *ZEROS                           Current Length
     C                   EVAL      CurPagSeq = *ZEROS                           Curr. Page Sequence
     C                   EVAL      CurTRNO   = *BLANKS                          Curr. Transact. Ref.
     C                   EVAL      NbItems   = *Zeros                           Nb. Movement by Msg


      **  Clear Multi-Occurence for message details (MGOMSGPD)

     C*****1****         DO        200           X                                          BUG22687
     C     1             DO        999           X                                          BUG22687
     C     X             OCCUR     MULT
     C                   CLEAR                   MULT
     C                   ENDDO
     C                   EVAL      M = 0
     C     1             OCCUR     MULT

      **  Clear Multi-Occurence for message reference (MGOREFPD)

     C*****1****         DO        100           X                                          AR757762
     C     1             DO        9999          X                                          AR757762
     C     X             OCCUR     DsMsgRef
     C                   CLEAR                   DsMsgRef
     C                   ENDDO
     C                   EVAL      Mr = 0
     C     1             OCCUR     DsMsgRef

     C     @InitWkFld    ENDSR
      *    --------      -----

      *========================================================================*
      * $RtvNwrk: Retrieve Network details.                                    *
      *------------------------------------------------------------------------*

     C     $RtvNwrk      BEGSR
      *    --------      -----

     C                   IF        SavNWRK <> MGNWRK

     C                   CALLB     'AONWRKR1'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      MGNWRK        P@NWRK                         Network
     C     SDNWRK        PARM      SDNWRK        DSLDY

      ** If error,

     C                   IF        P@RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 001                                 * * * * * * * *
     C                   EVAL      DBKEY  = MGNWRK                              *  DBERR 001  *
     C                   EVAL      DBFILE = 'SDNWRKPD'                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      SAvNWRK = MGNWRK
      *                                                                                     MD055842
     C                   EVAL      WConv = EDCONV                                           MD055842

     C                   ENDIF

      *    --------      -----
     C     @ChkNwrk      ENDSR

      *========================================================================*
      * $RtvBrch: Retrieve Branch details.                                     *
      *------------------------------------------------------------------------*

     C     $RtvBrch      BEGSR
      *    --------      -----

     C                   IF        SavBRCA <> MGBRCA

     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      MGBRCA        P@BRCD                         Branch Code
     C     SDBRCH        PARM      SDBRCH        DSSDY

      ** If error,

     C                   IF        P@RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 002                                 * * * * * * * *
     C                   EVAL      DBKEY  = MGBRCA                              *  DBERR 002  *
     C                   EVAL      DBFILE = 'SDBRCHPD'                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      SAvBRCA = MGBRCA

     C                   ENDIF

      *    --------      -----
     C     @RtvBrch      ENDSR

      *========================================================================*
      * $RtvCCY: Retrieve Currency details.                                    *
      *------------------------------------------------------------------------*

     C     $RtvCCY       BEGSR
      *    -------       -----

     C                   IF        SavCCY  <> MGCCY

     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      MGCCY         P@CCY                          Currency
     C     SDCURR        PARM      SDCURR        DSSDY

      ** If Error,

     C                   IF        P@RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 003                                 * * * * * * * *
     C                   EVAL      DBKEY  = MGCCY                               *  DBERR 003  *
     C                   EVAL      DBFILE = 'SDCURRPD'                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      SAvCCY  = MGCCY

     C                   ENDIF

      *    -------       -----
     C     @RtvCCY       ENDSR

      *========================================================================*
      * $RtvNwAc: Retrieve Network Account Details.                            *
      *------------------------------------------------------------------------*

     C     $RtvNwAc      BEGSR
      *    --------      -----

     C     Key           CHAIN     GLNW94D0                           99

      ** If Error,

     C                   IF        *IN99
     C     *LOCK         IN        LDA
     C                   EXSR      SRAccnt                                                    CGL029
     C                   EVAL      DBASE  = 004                                 * * * * * * * *
     C                   EVAL      DBKEY  = MGNetAcc                            *  DBERR 004  *
     C                   EVAL      DBFILE = 'GLNW94PD'                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Retrieve account details (Account Type)

     C                   MOVEL     MGCNUM        P@CNUM                         Customer
     C                   MOVEL     MGACCD        P@ACCD                         Account code
     C                   MOVEL     MGACSQ        P@ACSQ                         Account Sequence

     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM      '*KEY'        P@OPTN                         Option
     C                   PARM      *BLANKS       P@RETL                         Retail Number
     C                   PARM                    P@CNUM                         Customer
     C                   PARM      MGCCY         P@CCY                          Currency
     C                   PARM                    P@ACCD                         Account code
     C                   PARM                    P@ACSQ                         Account Sequence
     C                   PARM      MGBRCA        P@BRCD                         Branch Code
     C     GLACCNT       PARM      GLACCNT       DSSDY

      ** Add the issue on the audit report.

     C                   IF        P@RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EXSR      SRAccnt                                                    CGL029
     C                   EVAL      DBASE  = 005                                 * * * * * * * *
     C                   EVAL      DBKEY  = MGAccnt                             *  DBERR 005  *
     C                   EVAL      DBFILE = 'ACCNTAB'                           * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      *    --------      -----
     C     @RtvNwAc      ENDSR

      *========================================================================*
      * $RtvNbChar: Calculate the number of available characters by message.   *
      *------------------------------------------------------------------------*

     C     $RtvNbChar    BEGSR
      *    ----------    -----

     C                   EVAL      MaxLength = ED2MXL                           MT942 maximum length

      ** If Number and Sum of Entries (D/C) has to be generated.
      **   2 X ':90D:00001EUR123456789012,45CR' => 2 X 30 characters.

     C                   IF        N42LSF = 'Y'                                 Number and Sum of En
     C                   EVAL      MaxLength = MaxLength - 60                   Maximum length
     C                   ENDIF

      ** Information to Account Owner.

     C     1             DO        6             X

      ** If the current Add. Info. is empty, the next one also.
      ** So,we can stop this processing.

     C                   IF        ArMGMIO(X) = *BLANKS
     C                   LEAVE
     C                   ENDIF
     C
     C                   IF        X = 1
     C                   EVAL      MaxLength = MaxLength                        Max. Length
     C                                         - 4                              :86:
     C                   ENDIF

     C                   EVAL      MaxLength = MaxLength                        Max. Length
     C                                         - %LEN(%TRIM(ArMGMIO(X)))        Msg Level Info 1-6
     C                                         - 2                              CRLF
     C                   ENDDO

      *    --------      -----
     C     @RtvNbChar    ENDSR

      *========================================================================*
      * $RtvMsgDfn: Retrieve Message Definition (Tag 20, 21, 25, 28, 34F, 13D) *
      *------------------------------------------------------------------------*

     C     $RtvMsgDfn    BEGSR
      *    ----------    -----

     C                   IF        CER030 = 'Y' AND EDMCNW = 'Y'                              CER030
      *                                                                                       CER030
     C                   IF        WSort61 = 'Y'                                            MD042041
     C     Key           CHAIN     MGX942L1                                                 MD042041
     C                   IF        %FOUND(MGX942L1)                                         MD042041
     C                   EVAL      MGX942 = 'FOUND'                                         MD042041
     C                   ELSE                                                               MD042041
     C                   EVAL      MGX942 = *BLANKS                                         MD042041
     C                   ENDIF                                                              MD042041
     C                   ELSE                                                               MD042041
     C     Key           CHAIN     MGX942L0                                                   CER030
      *                                                                                       CER030
     C**********         IF        NOT %FOUND(MGX942L0)                              CER030 BUG22995
     C******LOCK         IN        LDA                                               CER030 BUG22995
     C**********         EVAL      DBASE = 009                                       CER030 BUG22995
     C**********         EVAL      DBFILE = 'MGX942L0'                               CER030 BUG22995
     C**********         EVAL      DBKEY = MGNetAcc                                  CER030 BUG22995
     C**********         OUT       LDA                                               CER030 BUG22995
     C**********         EXSR      *PSSR                                             CER030 BUG22995
     C**********         ENDIF                                                       CER030 BUG22995
     C                   IF        %FOUND(MGX942L0)                                         BUG22995
     C                   EVAL      MGX942 = 'FOUND'                                         BUG22995
     C                   ELSE                                                               BUG22995
     C                   EVAL      MGX942 = *BLANKS                                         BUG22995
     C                   ENDIF                                                              BUG22995
     C                   ENDIF                                                              MD042041
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C/COPY WNCPYSRC,MGH00034
      ** Format field :20:

     C                   EXSR      $FMT20

      ** Format field :21:

     C                   EXSR      $FMT21

      ** Format field :25:

     C                   EXSR      $FMT25

      ** Format field :28C:

     C                   EXSR      $FMT28C

      ** Format field :34F: Debit/Credit

     C                   IF        MGDFLM = MGCFLM

     C                   EXSR      $FMT34F

     C                   ELSE

      ** Format field :34F: Debit

     C                   EXSR      $FMT34FD

      ** Format field :34F: Credit

     C                   EXSR      $FMT34FC

     C                   ENDIF

      ** Format field :13D:

     C                   EXSR      $FMT13D

      *    ----------    -----
     C     @RtvMsgDfn    ENDSR

      *========================================================================*
      * $FMT20  : Transaction Reference Number.                                *
      *------------------------------------------------------------------------*

     C     $FMT20        BEGSR
      *    ------        -----

      ** The Transaction reference is 'GL' + Rundate in format YYMMDD + Sequence hold
      ** in DTAARA/MGMT94DA.

     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT

     C                   EVAL      MTAG = ':20:'                                Tag
     C                   EVAL      MFLD = #RtvTRNO('GL':#SWIFTDt(BJRDNB))       Build TRNO
     C/COPY WNCPYSRC,MGH00035
                                                                                            BUG22687
      ** Load the current Transaction Ref.                                                  BUG22687
                                                                                            BUG22687
     C                   EVAL      CurTRNO = MFLD                                           BUG22687
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' AND                                           CER030
     C                             EDMCNW = 'Y' AND                                           CER030
     C                             MGFREF <> *BLANKS                                          CER030
     C                   EVAL      MFLD = MGFREF                                              CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   EVAL      CTRC = CRLF                                  CR/LF field

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length

      ***Load*the current Transaction Ref.                                                  BUG22687
      **********                                                                            BUG22687
     C**********         EVAL      CurTRNO = MFLD                                           BUG22687

      ** Update 920 parts details

     C     MGFL25        IFNE      *BLANKS
     C                   EXSR      $MEP920
     C                   ENDIF

      *    ------        -----
     C     @FMT20        ENDSR

      *========================================================================*
      * $FMT21  : Related Reference.                                           *
      *------------------------------------------------------------------------*

     C     $FMT21        BEGSR
      *    ------        -----

      ** If a related Reference exists.

     C                   IF        MGRREF <> *BLANKS
     C                             OR (CER030 = 'Y' AND EDMCNW = 'Y'                        BUG23029
     C                             AND MGX942 = 'FOUND')                                    BUG23029
     C/COPY WNCPYSRC,MGH00036

     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT

     C                   EVAL      MTAG = ':21:'                                Tag
     C                   EVAL      MFLD = MGRREF                                Related Reference
     C/COPY WNCPYSRC,MGH00037
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' AND EDMCNW = 'Y'                              CER030
     C                             AND MGX942 = 'FOUND'                                     BUG22995
     C**********         EVAL      MFLD = MGFD21                                     CER030 BUG25529
      *                                                                                     BUG26515
      ** If format is STRCT, use system value for no. of lines for field 86                 BUG26515
      *                                                                                     BUG26515
     C                   IF        EDF86F = 'STRCT'                                         BUG26515
     C                   EVAL      %SUBST(MGFD21:9:1) = WFld21a                             BUG26515
     C                   ENDIF                                                              BUG26515
      *                                                                                     BUG26515
     C                   EVAL      MFLD = %TRIM(MGFD21) +                                   BUG25529
     C                                    '/' + %CHAR(WFld21)                               BUG25529
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   EVAL      CTRC = CRLF                                  CR/LF field

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
     C                   ENDIF

      *    -------       -----
     C     @FMT21        ENDSR

      *========================================================================*
      * $FMT25  : Account Identification.                                      *
      *------------------------------------------------------------------------*

     C     $FMT25        BEGSR
      *    ------        -----

      ** The Account Identifier is:
      **   - MT920 Account Identifier if exist,
      **   - else, the IBAN if exist,
      **   - else, the Retail Account if exist,
      **   - else, the Full Account with the branch if multi-branching environment,

     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT

     C                   EVAL      MTAG = ':25:'                                Tag
     C                   EXSR      SRAccnt                                                    CGL029
     C                   EVAL      MFLD = #RtvACID(MGAccnt:                     Full Account
     C                                             MGACNO:                      Retail Account
     C                                             MGIBAN:                      IBAN
     C                                             MGFL25)                      MT920 Acc. Ident.
     C/COPY WNCPYSRC,MGH00038
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' AND EDMCNW = 'Y'                              CER030
     C                             AND MGX942 = 'FOUND'                                     BUG22995
     C                   EVAL      MFLD = MGFD25                                              CER030
     C                   ELSE                                                               BUG23172
     C                   CALL      'AOCUSTR0'                                               BUG23172
     C                   PARM      '*MSG   '     PRtcd                                      BUG23172
     C                   PARM      '*KEY   '     POptn                                      BUG23172
     C                   PARM      A8BICN        PKey1                                      BUG23172
     C                   PARM                    PKyst                                      BUG23172
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG23172
      *                                                                                     BUG23172
     C                   MOVE      MGCNUM        PCusN                                      BUG23172
     C                   MOVE      MGACCD        PAcctCde                                   BUG23172
     C                   MOVE      MGACSQ        PAcctSeq                                   BUG23172
     C                   SELECT                                                             BUG23172
                                                                                            BUG23172
     C                   WHEN      EDACNF = '*IBAN'                                         BUG23172
     C                   CALL      'AOACCTR0'                                               BUG23172
     C                   PARM      *BLANKS       PRtcd                                      BUG23172
     C                   PARM      '*KEY'        POptn                                      BUG23172
     C                   PARM      *BLANKS       PRetl                                      BUG23172
     C                   PARM                    PCusN                                      BUG23172
     C                   PARM      MGCCY         PCcy                                       BUG23172
     C                   PARM                    PAcctCde                                   BUG23172
     C                   PARM                    PAcctSeq                                   BUG23172
     C                   PARM      MGBRCA        PBrca                                      BUG23172
     C     GLACCNT       PARM      GLACCNT       DSSDY                                      BUG23172
      *                                                                                     BUG23172
     C                   IF        MGIBAN <> *BLANKS                                        BUG23172
     C                   EVAL      MFLD  = MGIBAN                                           BUG23172
     C                   ELSEIF    MGACNO <> *ZEROS                                         BUG23172
     C                   MOVE      *BLANKS       MGFD25                                     BUG23172
     C                   MOVEL     MGACNO        MGFD25                                     BUG23172
     C                   ELSE                                                               BUG23172
     C                   EVAL      MFLD = MGBRCA + PCusN + MGCCY +                          BUG23172
     C                                      PAcctcde + PAcctSeq                             BUG23172
     C                   ENDIF                                                              BUG23172
     C                   WHEN      EDACNF = '*LEDGER'                                       BUG23172
     C                   EVAL      MFLD   = MGBRCA                                          BUG23172
     C                                    + PCusN                                           BUG23172
     C                                    + MGCCY                                           BUG23172
     C                                    + PAcctcde                                        BUG23172
     C                                    + PAcctSeq                                        BUG23172
      *                                                                                     BUG23172
     C                   WHEN      EDACNF = '*RETAIL'                                       BUG23172
     C                   IF        MGACNO <> *ZEROS                                         BUG23172
     C                   MOVE      *BLANKS       MFLD                                       BUG23172
     C                   MOVEL     MGACNO        MFLD                                       BUG23172
     C                   ELSE                                                               BUG23172
     C                   EVAL      MFLD   = MGBRCA + PCusN + MGCCY +                        BUG23172
     C                                      PAcctcde + PAcctSeq                             BUG23172
     C                   ENDIF                                                              BUG23172
      *                                                                                     BUG26075
     C                   WHEN      EDACNF = '*BLZ'                                          BUG26075
      *                                                                                     BUG26075
     C                   IF        CER030 = 'Y' AND EDMCNW = 'Y'                            BUG26075
     C                   IF        MGACNO <> *ZEROS                                         BUG26075
     C                   EVAL      MFLD   = BBBLCD + '/' + %CHAR(MGACNO)                    BUG26075
     C                   ELSE                                                               BUG26075
     C                   EVAL      MFLD   = BBBLCD + '/' + MGBRCA +                         BUG26075
     C                                      PCusN + MGCCY + PAcctcde +                      BUG26075
     C                                      PAcctSeq                                        BUG26075
     C                   ENDIF                                                              BUG26075
      *                                                                                     BUG26075
     C                   ENDIF                                                              BUG26075
      *                                                                                     BUG23172
     C*                  WHEN      EDACNF = '*BLZ'                                          BUG23172
     C*                  IF        MGACNO <> *ZEROS                                         BUG23172
     C*                  EVAL      MFLD   = BBBLCD + '/' + %CHAR(MGACNO)                    BUG23172
     C*                  ELSE                                                               BUG23172
     C*                  EVAL      MFLD   = BBBLCD + '/' + MGBRCA +                         BUG23172
     C*                                     PCusN + MGCCY + PAcctcde +                      BUG23172
     C*                                     PAcctSeq                                        BUG23172
     C*                  ENDIF                                                              BUG23172
      *                                                                                     BUG23172
     C                   ENDSL                                                              BUG23172
     C                   ENDIF                                                                CER030
     C
     C                   EVAL      CTRC = CRLF                                  CR/LF field

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
      *    -------       -----
     C     @FMT25        ENDSR

      *========================================================================*
      * $FMT28C : Page Number/Continuation Identifier.                         *
      *------------------------------------------------------------------------*

     C     $FMT28C       BEGSR
      *    -------       -----

     C                   EVAL      CurPagSeq = CurPagSeq + 1                    Current Page Seq

     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT

     C                   EVAL      MTAG = ':28C:'                               Tag
     C                   EVAL      MFLD = %CHAR(MGSTNO)                         Statement Page Numb
     C                                    + '/'                                 /
     C                                    + %CHAR(CurPagSeq)                    Current Page Seq
     C
     C                   EVAL      CTRC = CRLF                                  CR/LF field

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
      *    -------       -----
     C     @FMT28C       ENDSR

      *========================================================================*
      * $FMT34F  : Floor Limit Indicator / Debit/Credit                        *
      *------------------------------------------------------------------------*

     C     $FMT34F       BEGSR
      *    --------      -----

     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT

     C                   EVAL      MTAG = ':34F:'                               Tag
     C                   EVAL      MFLD = A6SWCY                                SWIFT Currency Code
     C                                    + #SWIFTAm(MGDFLM:                    Debit Floor Limit
     C                                               A6NBDP:                    Number of Decimal Pl
     C                                               A6SWDP:                    SWIFT Number of Deci
     C                                               CSW020)                    Feature

     C                   EVAL      CTRC = CRLF                                  CR/LF field

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
      *    --------      -----
     C     @FMT34F       ENDSR

      *========================================================================*
      * $FMT34FD : Floor Limit Indicator / Debit                               *
      *------------------------------------------------------------------------*

     C     $FMT34FD      BEGSR
      *    --------      -----

     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT

     C                   EVAL      MTAG = ':34F:'                               Tag
     C                   EVAL      MFLD = A6SWCY                                SWIFT Currency Code
     C                                    + 'D'                                 Debit
     C                                    + #SWIFTAm(MGDFLM:                    Debit Floor Limit
     C                                               A6NBDP:                    Number of Decimal Pl
     C                                               A6SWDP:                    SWIFT Number of Deci
     C                                               CSW020)                    Feature

     C                   EVAL      CTRC = CRLF                                  CR/LF field

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
      *    --------      -----
     C     @FMT34FD      ENDSR

      *========================================================================*
      * $FMT34FC : Floor Limit Indicator / Credit                              *
      *------------------------------------------------------------------------*

     C     $FMT34FC      BEGSR
      *    --------      -----

     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT

     C                   EVAL      MTAG = ':34F:'                               Tag
     C                   EVAL      MFLD = A6SWCY                                SWIFT Currency Code
     C                                    + 'C'                                 Debit
     C                                    + #SWIFTAm(MGCFLM:                    Credit Floor Limit
     C                                               A6NBDP:                    Number of Decimal Pl
     C                                               A6SWDP:                    SWIFT Number of Deci
     C                                               CSW020)                    Feature

     C                   EVAL      CTRC = CRLF                                  CR/LF field

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
      *    --------      -----
     C     @FMT34FC      ENDSR

      *========================================================================*
      * $FMT13D : Date/Time Indicator.                                         *
      *------------------------------------------------------------------------*

     C     $FMT13D       BEGSR
      *    -------       -----

     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT

     C                   EVAL      MTAG = ':13D:'                               Tag
     C                   EVAL      MFLD = #RtvDtTm(N42LSD:                      Last statement date
     C                                             N42LST:                      Last statement time
     C                                             A8TMOF:                      Time Offset against
     C                                             A8SIGN:                      Time Offset Sign
     C                                             A8STOF:                      System Time Offset
     C                                             A8SSIN)                      System Time Offset S

     C                   EVAL      CTRC = CRLF                                  CR/LF field

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
      *    -------       -----
     C     @FMT13D       ENDSR

      *========================================================================*
      * $FMT61  : Statement Line.                                              *
      *------------------------------------------------------------------------*

     C     $FMT61        BEGSR
      *    ------        -----

     C                   IF        ED2F61 = 'Y'                                               CER030
     C**********                   and CER030 = 'Y'                               BUG25800 BUG25800A
     C**********                   or  CER030 = 'N'                               BUG25800 BUG25800A
     C                   MOVE      A6SWCY        WSubfld4                                     CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      WSubfld4 = *BLANKS                                         CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C/COPY WNCPYSRC,MGH00039
      ** First Part of field 61:
      **   Value Date - format YYMMDD
      **   Posting Date - format MMDD
      **   Debit/Credit Indicator
      **   Funds Code (3rd character of SWIFT currency Code)
      **   Posting Amount
      **   Sub Field 6
      **   Sub Field 7
      **   Sub Field 8

     C                   EVAL      DsResult = #SWIFTDt(MGVALD) +                Value Date - YYMMDD
     C                                        %SUBST(#SWIFTDt(MGPSTD):3:4) +    Posting Date - MMDD
     C                                        %TRIM(MGDRCR) +                   Debit/Credit
     C**********                              %SUBST(A6SWCY:3:1) +              Funds Code    CER030
     C                                        %TRIM(WSubfld4) +                               CER030
     C                                        %TRIM(#SWIFTAm(MGPSTA:            Posting Amount
     C                                                       A6NBDP:            Number of Decimal Pl
     C                                                       A6SWDP:            SWIFT Number of Deci
     C                                                       CSW020)) +         Feature CSW020
     C                                        MGSFD6 +                          Sub Field 6
     C                                        %TRIM(MGSFD7) +                   Sub Field 7
     C                                        %TRIM(MGSFD8)                     Sub Field 8
     C/COPY WNCPYSRC,MGH00040

      ** For Field 61 the maximum length is 66 characters,
      ** So, the result could be divided in 2 Occurances.

     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT

     C                   EVAL      MTAG = ':61:'                                Tag

      ** Load the first 50 Characters

     C                   EVAL      MFLD = WkMult1                               First 50 Characters

      ** If the result is greater than 50 characters,

     C                   IF        WkMult2 <> *BLANKS

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length

     C                   EVAL      M = M + 1                                    Next Occurance
     C     M             OCCUR     MULT

     C                   EVAL      MFLD = WkMult2                               Last 50 Characters

     C                   ENDIF

     C                   EVAL      CTRC = CRLF                                  CR/LF field

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length

      ** Second Part of field 61:
      **   Sub Field 9

      *                                                                                       CER030
     C                   EVAL      WDCInd = *BLANKS                                        BUG23040B
     C**********         IF        CER030 ='Y' AND EDMCNW = 'Y'                      CER030 BUG24069
     C                   IF        CER030 ='Y'                                              BUG24069
     C**********         EVAL      DsMGADI = %TRIM(MGADI1) +                         CER030 BUG23280
     C                   EVAL      WExtNar = %TRIM(MGADI1) +                                BUG23280
     C                                       %TRIM(MGADI2) +                                  CER030
     C                                       %TRIM(MGADI3) +                                  CER030
     C                                       %TRIM(MGADI4) +                                  CER030
     C                                       %TRIM(MGADI5) +                                  CER030
     C                                       %TRIM(MGADI6)                                    CER030
     C**********         EVAL      WPos = %SCAN('/IACC/D':DsMGADI)                   CER030 BUG23280
     C                   EVAL      WPos = %SCAN('/IACC/D':WExtNar)                          BUG23280
      *                                                                                       CER030
     C**********         EVAL      WDCInd = *BLANKS                               BUG23040 BUG23040B
      *                                                                                     BUG23040
     C                   IF        WPos > 0                                                   CER030
      *                                                                                     BUG23247
     C                   EVAL      WIndLn = WPos + 7                                        BUG23247
     C                   EVAL      WDCInd = %SUBST(DsMGADI:WIndLn:1)                        BUG23247
      *                                                                                     BUG23247
     C**********         IF        WDCInd = '0' OR WDCInd = '1' OR                 BUG23247 BUG23742
     C**********                   WDCInd = '2' OR WDCInd = '3'                    BUG23247 BUG23742
     C                   IF        EDMCNW = 'Y'                                             BUG24069
     C**********         IF        (MG8635 = *BLANKS AND (                         BUG23742 BUG24278
     C**********                   WDCInd = '0' OR WDCInd = '1' OR                 BUG23742 BUG24278
     C**********                   WDCInd = '2' OR WDCInd = '3')) OR               BUG23742 BUG24278
     C**********                   (MG8635 = 'Y' AND WDCInd = '1')                 BUG23742 BUG24278
     C                   IF        WDCInd = '0' OR WDCInd = '1' OR                          BUG24278
     C                             WDCInd = '2' OR WDCInd = '3'                             BUG24278
      *                                                                                     BUG24278
     C                   EVAL      MGSFD9 = *BLANKS                                           CER030
     C**********         EVAL      MGSFD9 = %SUBST(DsMGADI:WPos:8)                   CER030 BUG23280
     C                   EVAL      MGSFD9 = %SUBST(WExtNar:WPos:8)                          BUG23280
     C**********         EVAL      WDCInd = %SUBST(MGSFD9:8:1)                     BUG23040 BUG23247
     C                   ENDIF                                                              BUG23247
     C                   ENDIF                                                              BUG24069
      *                                                                                     BUG23247
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030

     C/COPY WNCPYSRC,MGH00041
     C                   IF        MGSFD9 <> *BLANKS

     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT

     C                   EVAL      MFLD = %TRIM(MGSFD9)                         Sub Field 9

     C                   EVAL      CTRC = CRLF                                  CR/LF field

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length

     C                   ENDIF

      *    ------        -----
     C     @FMT61        ENDSR

      *========================================================================*
      * $FMT86  : Information to Account Owner.                                *
      *------------------------------------------------------------------------*

     C     $FMT86        BEGSR
      *    ------        -----
      *                                                                                       CER030
      ** For Non- Multicash                                                                   CER030
      *                                                                                       CER030
     C**********         IF        CER030 <>'Y' OR EDMCNW <> 'Y'                     CER030 BUG22853
     C                   IF        CER030 <>'Y'                                             BUG22853
     C/COPY WNCPYSRC,MGH00042

     C     1             DO        6             X

      ** If the current Add. Info. is empty, the next one also.
      ** So,we can stop this processing.

     C                   IF        ArMGADI(X) = *BLANKS
     C                   LEAVE
     C                   ENDIF

      ** Retrieve Field 86 details.

     C                   EVAL      DsResult = %TRIM(ArMGADI(x))                 Additional Info.

      ** For Field 86 the maximum length is 65 characters,
      ** So, the result could be divided in 2 Occurances.

     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT

     C                   IF        X = 1
     C                   EVAL      MTAG = ':86:'                                Tag
     C                   ENDIF

      ** Load the first 50 Characters

     C                   EVAL      MFLD = WkMult1                               First 50 Characters

      ** If the result is greater than 50 characters,

     C                   IF        WkMult2 <> *BLANKS

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length

     C                   EVAL      M = M + 1                                    Next Occurance
     C     M             OCCUR     MULT

     C                   EVAL      MFLD = WkMult2                               Last 50 Characters

     C                   ENDIF

     C                   EVAL      CTRC = CRLF                                  CR/LF field

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length

     C                   ENDDO
     C/COPY WNCPYSRC,MGH00043
      *                                                                                       CER030
     C**********         ELSEIF    CER030 ='Y' AND EDMCNW ='Y'                       CER030 BUG22853
     C                   ELSEIF    CER030 ='Y'                                              BUG22853
     C                   EXSR      SRMTCash                                                   CER030
     C                   ENDIF                                                                CER030

      *    ------        -----
     C     @FMT86        ENDSR

      *========================================================================*
      * $FMT90D  : Number and Sum of Entries.                                  *
      *------------------------------------------------------------------------*

     C     $FMT90D       BEGSR
      *    -------       -----

      ** Number and Sum of entres
      **   Number of Debit
      **   SWIFT Currency Code
      **   Sum of Debit Posting

     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT

     C                   EVAL      MTAG = ':90D:'                               Tag
     C                   EVAL      MFLD = %TRIM(%CHAR(MGNBDB)) +                Number of Debit
     C                                    A6SWCY +                              SWIFT Currency Code
     C                                    #SWIFTAm(MGSMDB:                      Sum of Debit Posting
     C                                             A6NBDP:                      Number of Decimal Pl
     C                                             A6SWDP:                      SWIFT Number of Deci
     C                                             CSW020)                      Feature

     C                   EVAL      CTRC = CRLF                                  CR/LF field

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
      *    -------       -----
     C     @FMT90D       ENDSR

      *========================================================================*
      * $FMT90C  : Number and Sum of Entries.                                  *
      *------------------------------------------------------------------------*

     C     $FMT90C       BEGSR
      *    -------       -----

      ** Number and Sum of entres
      **   Number of Credit
      **   SWIFT Currency Code
      **   Sum of credit Posting

     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT

     C                   EVAL      MTAG = ':90C:'                               Tag
     C                   EVAL      MFLD = %TRIM(%CHAR(MGNBCR)) +                Number of Credit
     C                                    A6SWCY +                              SWIFT Currency Code
     C                                    #SWIFTAm(MGSMCR:                      Sum of Crebit Postin
     C                                             A6NBDP:                      Number of Decimal Pl
     C                                             A6SWDP:                      SWIFT Number of Deci
     C                                             CSW020)                      Feature

     C                   EVAL      CTRC = CRLF                                  CR/LF field

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
      *    -------       -----
     C     @FMT90C       ENDSR

      *========================================================================*
      * $FMT86F : Information to Account Owner for whole message.              *
      *------------------------------------------------------------------------*

     C     $FMT86F       BEGSR
      *    -------       -----

     C     1             DO        6             X

      ** If the current Add. Info. is empty, the next one also.
      ** So,we can stop this processing.

     C                   IF        ArMGMIO(X) = *BLANKS
     C                   LEAVE
     C                   ENDIF

      ** Retrieve Field 86 details.

     C                   EVAL      DsResult = %TRIM(ArMGMIO(X))                 Additional Info.
      *                                                                                     MD055842
      ** Convert non-SWIFT chars in Field 86 output fields                                  MD055842
     C                   IF        CMG008 = 'Y' AND WConv = 'Y'                             MD055842
     C                   Eval      WConvFld = *Blanks                                       MD055842
     C                   Eval      WConvFld = DsResult                                      MD055842
     C                   Exsr      ConvChar                                                 MD055842
     C                   Eval      DsResult = WConvFld                                      MD055842
     C                   ENDIF                                                              MD055842
      *                                                                                     MD055842

      ** For Field 86 the maximum length is 65 characters,
      ** So, the result could be divided in 2 Occurances.

     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT

     C                   IF        X = 1
     C                   EVAL      MTAG = ':86:'                                Tag
     C                   ENDIF

      ** Load the first 50 Characters

     C                   EVAL      MFLD = WkMult1                               First 50 Characters

      ** If the result is greater than 50 characters,

     C                   IF        WkMult2 <> *BLANKS

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length

     C                   EVAL      M = M + 1                                    Next Occurance
     C     M             OCCUR     MULT

     C                   EVAL      MFLD = WkMult2                               Last 50 Characters

     C                   ENDIF

     C                   EVAL      CTRC = CRLF                                  CR/LF field

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length

     C                   ENDDO

      *    -------       -----
     C     @FMT86F       ENDSR

      *========================================================================*
      * $CrtMsgDtl : Create Message details.                                   *
      *------------------------------------------------------------------------*

     C     $CrtMsgDtl    BEGSR
      *    ----------    -----

      ** Unload multi-occurence MULT in PF/MGOMSGPD.

     C     1             DO        M             X

     C     X             OCCUR     MULT
     C                   CLEAR                   MGOMSGD0
     C                   EVAL      Mo_MTAG = MTAG                               Message field Tag
     C                   EVAL      Mo_MFLD = MFLD                               Message Field Data
     C                   EVAL      Mo_CTRC = CTRC                               CRLF Control Charact
     C                   EVAL      Mo_TRNO = CurTRNO                            Transaction referenc
     C                   WRITE     MGOMSGD0
     C                   CLEAR                   MULT

     C                   ENDDO

      ** Position to the beginning of the Multi-Ocurrance

     C                   EVAL      M = 0
     C     1             OCCUR     MULT

      *    ----------    -----
     C     @CrtMsgDtl    ENDSR

      *========================================================================*
      * $LdMsgRef : Load Master Messages Reference data structure.             *
      *------------------------------------------------------------------------*

     C     $LdMsgRef     BEGSR
      *    ---------     -----

     C                   ADD       1             Mr

     C     Mr            OCCUR     DsMsgRef

     C                   EVAL      Mr_MODI = 'GL'                               General Ledger
     C                   EVAL      Mr_TRNO = CurTRNO                            Transaction referenc
     C/COPY WNCPYSRC,MGH00044
     C**********         IF        MGRNWK <> *BLANKS                                        BUG22687
     C**********         EVAL      Mr_NWRK = MGRNWK                                         BUG22687
     C                   IF        EDMCNW = 'Y'                                             BUG22687
     C                   EVAL      Mr_NWRK = 'MTCASH'                                       BUG22687
     C                   ELSE
     C                   EVAL      Mr_NWRK = MGNWRK                             Network
     C                   ENDIF
     C/COPY WNCPYSRC,MGH00045
     C/COPY OFCPYSRCZ,CGL146_061                                                              CGL146
     C                   MOVE      A8BICN        Mr_SECN                        Customer no of Send.
     C                   EVAL      Mr_NWSN = A8BTID                             Branch TID Address

      **  Default Customer no of destination.
      **  If the destination is a customer number, load the destination,
      **  Otherwide, the customer number of the account.

     C**********         EVAL      WkCnum = %Subst(MGDSTN:1:6) + '0'                          CSD027
     C**********         TESTN                   WkCnum               99                      CSD027
     C                   IF        %Subst(MGDSTN:7:4) = *BLANKS
     C**********                   AND *IN99                                                  CSD027
     C                   MOVEL     MGDSTN        Mr_DECN
     C                   ELSE
     C                   EVAL      Mr_DECN = MGCNUM
     C                   ENDIF

      **  Default Destination.

     C                   EVAL      Mr_NWDS = MGDSTN

      **  If the destination is a SWIFT address, retrieves the customer number of
      **  destination.
     C                   IF        %Subst(MGDSTN : 7 : 4) <> *Blanks

     C                   EVAL      WSwiftId = MGDSTN
     C     WSwiftId      CHAIN     @CUSTGE                            99
     C**  Try removing branch 'XXX' if fails the first time.
     C                   IF        *IN99 = *ON And
     C                             %Subst(WSwiftId : 9 : 3) = 'XXX'
     C                   EVAL      %Subst(WSwiftId : 9 : 3) = '   '
     C     WSwiftId      CHAIN     @CUSTGE                            99
     C                   ENDIF
     C                   IF        *IN99 = *OFF
     C                   MOVEL     BBCUST        Mr_DECN
     C                   ENDIF
     C
      **  If the destination is a customer number, retrieve the SWIFT address of dest.
     C
     C                   ELSE
     C
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM      MGDSTN        P@KEY1
     C                   PARM                    P@KYST
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        P@RTCD = *BLANKS
     C                   MOVEL     BBCUST        Mr_DECN
     C                   IF        BBCSID <> *BLANKS
     C                   EVAL      Mr_NWDS = BBCSID
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C
     C                   EVAL      Mr_MTPY = '942'                              Message Type
     C                   EVAL      Mr_MPRY = 'N'                                Message Priority
     C                   SELECT
     C                   WHEN      MGDMST = 'C'                                 Created
     C                   EVAL      Mr_MGSG = '1'                                Msg Status Group
     C                   EVAL      Mr_MGST = 'CRTD'                             Message Status
     C                   WHEN      MGDMST = 'R'                                 Ready to send
     C                   EVAL      Mr_MGSG = '2'                                Msg Status Group
     C                   EVAL      Mr_MGST = 'RSND'                             Message Status
     C                   WHEN      MGDMST = 'D'                                 Deleted
     C                   EVAL      Mr_MGSG = '4'                                Msg Status Group
     C                   EVAL      Mr_MGST = 'DLTD'                             Message Status
     C                   ENDSL
     C                   EVAL      Mr_HRDT = #SWIFTDt(BJRDNB+ENDSMN)            History Retention Dt
     C                   EVAL      WkMGDE  = #SWIFTDt(N42LSD)                   Msg Generation Date
     C                   MOVE      WkMGDE        Mr_MGDE                        Msg Generation Date
     C                   EVAL      Mr_MGTM = N42LST                             Msg Generation Time
     C                   EVAL      Mr_LADT = BJMRDT                             Last Action date
     C                   TIME                    Mr_LATM                        Last Action time
     C                   EVAL      Mr_CCY  = MGCCY                              Last Action date
     C                   IF        MGACNO <> *ZEROS                             Account Number SWIFT
     C                   MOVEL(P)  MGACNO        Mr_SACN                        Retail Account Numb.
     C                   ELSE
     C                   EXSR      SRAccnt                                                    CGL029
     C                   MOVE(P)   MGAccnt       Mr_SACN                        Full Account Number
     C                   ENDIF
     C                   IF        Gl_ATYP = 'R'                                Account Type A or R
     C                   EVAL      Mr_AORR = 'R'                                Retail
     C                   ELSE
     C                   EVAL      Mr_AORR = 'A'                                Other
     C                   ENDIF
     C                   EVAL      Mr_DESI = 'N'                                Demand Statement Id.
     C                   EVAL      Mr_BRCA = MGBRCA                             Branch Code
     C                   EVAL      Mr_CIND = '2'                                1 = 1999, 2 =2000

      ** Reset working fields.

     C                   EVAL      Curlength = *ZEROS                           Current Length
     C                   EVAL      CurTRNO   = *BLANKS                          Curr. Transact. Ref.
     C                   EVAL      NbItems   = *Zeros                           Nb. Movement by Msg

      *    ----------    -----
     C     @LdMsgRef     ENDSR

      *========================================================================*
      * $ShiftItem : Shift the items not process to the correct occurence.     *
      *------------------------------------------------------------------------*

     C     $ShiftItem    BEGSR
      *    ----------    -----

      ** Remark:  M contains the occurences to unload on MGOMSGPD,
      **          P contains the last occurence processed,
      **          L contains the last occurence to process.

      ** Position on the first occurence to process.

     C                   EVAL      P = P + 1
     C     P             DO        L             X

      ** Load working field with item detail to move.

     C     X             OCCUR     MULT
     C                   EVAL      SavMULT = MULT

      ** Release the old occurence.

     C                   CLEAR                   MULT

      ** Load working correct occurence with item detail.

     C                   EVAL      M = M + 1
     C     M             OCCUR     MULT
     C                   EVAL      MULT = SavMULT

     C                   EVAL      CurLength = CurLength                        Max. Length
     C                                         + %LEN(%TRIM(MTAG))              Tag Length
     C                                         + %LEN(%TRIM(MFLD))              Data Length
     C                                         + %LEN(%TRIM(CTRC))              CRLF Length
     C                   ENDDO

      *    ----------    -----
     C     @ShiftItem    ENDSR

      *========================================================================*
      * $CrtMsgRef : Create Message reference.                                 *
      *------------------------------------------------------------------------*

     C     $CrtMsgRef    BEGSR
      *    ----------    -----

      ** Unload multi-occurence DsMsgRef in PF/MGOREFPD.

     C     1             DO        Mr            X

      ** The multi-occurence DsMsgRef has the same layout as PF/MGOREFPD.

     C     X             OCCUR     DsMsgRef
     C                   WRITE     MGOREFD0

     C                   ENDDO

      *    ----------    -----
     C     @CrtMsgRef    ENDSR

      *========================================================================*
      * $MEP920    : Update MEP920PD parts details                             *
      *------------------------------------------------------------------------*

     C     $MEP920       BEGSR
      *    -------       -----

      ** Key to access 920 parts file

     C     KMEP          KLIST
     C                   KFLD                    KeyIMIR                        Network
     C                   KFLD                    KeyMSGR                        Branch Code - Alpha
     C                   KFLD                    KeyACTR                        Customer number

     C                   MOVEL     MGIMIR        KeyIMIR
     C                   MOVEL     '942'         KeyMSGR
     C                   MOVEL     MGFL25        KeyACTR

      **  Find record

     C     KMEP          CHAIN     MEP920L0                           99

     C                   IF        NOT *IN99
     C                   EVAL      MPM94X = MFLD                                Curr. Transac. Ref
     C                   UPDATE    MEP920P0
     C                   ENDIF

      *    -------       -----
     C     @MEP920       ENDSR
      *****************************************************************                       CGL029
      /EJECT                                                                                  CGL029
      *****************************************************************                       CGL029
      *                                                               *                       CGL029
      *  SRAccnt - Handles the Network Account and Full Account.      *                       CGL029
      *                                                               *                       CGL029
      *****************************************************************                       CGL029
     C     SRAccnt       BEGSR                                                                CGL029
      *                                                                                       CGL029
     C                   MOVE      MGNWRK        WkNWRK                                       CGL029
     C                   MOVE      MGBRCA        WkBRCA                                       CGL029
     C                   MOVE      MGCNUM        WkCUST                                       CGL029
     C                   MOVE      MGCCY         WkCCY                                        CGL029
     C                   MOVE      MGACCD        WkACCD                                       CGL029
     C                   MOVE      MGACSQ        WkACSQ                                       CGL029
     C                   MOVE      MGNATY        WkNATY                                       CGL029
      *                                                                                       CGL029
     C                   ENDSR                                                                CGL029
      *****************************************************************                       CGL029
      /EJECT                                                                                  CGL029
      *****************************************************************                       CGL029
      *                                                               *                       CER030
      *  SRMTCash - Process Extended Narratives for Multicash         *                       CER030
      *                                                               *                       CER030
      *  Called by: $FMT86                                            *                       CER030
      *                                                               *                       CER030
      *  Calls: SRLdFld                                               *                       CER030
      *                                                               *                       CER030
      *****************************************************************                       CER030
      *                                                                                       CER030
     C     SRMTCash      BEGSR                                                                CER030
      *                                                                                       CER030
     C                   EVAL      WFrstFlg = 'Y'                                             CER030
      *                                                                                       CER030
      ** Unstructured format                                                                  CER030
      *                                                                                       CER030
     C                   IF        EDF86F <> 'STRCT'                                          CER030
     C**********                   OR (%SUBST(MGSFD9:1:7) = '/IACC/D'             BUG23040A BUG23742
     C**********                       AND  EDF86F = 'STRCT')                     BUG23040A BUG23742
     C**********                   OR ((MG8635 = *BLANKS AND (                     BUG23742 BUG24278
     C**********                   WDCInd = '0' OR WDCInd = '1' OR                 BUG23742 BUG24278
     C**********                   WDCInd = '2' OR WDCInd = '3')) OR               BUG23742 BUG24278
     C**********                   (MG8635 = 'Y' AND WDCInd = '1')                 BUG23742 BUG24278
     C                             OR ((WDCInd = '0' OR WDCInd = '1' OR                     BUG24278
     C                             WDCInd = '2' OR WDCInd = '3')                            BUG24278
     C                             AND  EDF86F = 'STRCT')                                   BUG23742
      *                                                                                     BUG23040
     C                   EVAL      WPos = %SCAN('/IACC/D':DsMGADI)                          BUG23040
      *                                                                                     BUG23040
     C                   IF        WPos > 0                                                 BUG23040
      *                                                                                     BUG23247
     C                   EVAL      WIndLn = WPos + 7                                        BUG23247
     C                   EVAL      WDCInd = %SUBST(DsMGADI:WIndLn:1)                        BUG23247
      *                                                                                     BUG23247
     C**********         IF        WDCInd = '0' OR WDCInd = '1' OR                BUG23247 BUG23280B
     C**********                   WDCInd = '2' OR WDCInd = '3'                   BUG23247 BUG23280B
     C**********         EVAL      %SUBST(DsMGADI:WPos:8) = *BLANKS               BUG23040 BUG23280B
     C**********         ENDIF                                                    BUG23247 BUG23280B
      *                                                                                     BUG23247
     C                   ENDIF                                                              BUG23040
     C                   EVAL      PDCInd = *BLANKS                                        BUG23040B
     C**********         IF        EDMCNW = 'Y'                                   BUG23040B BUG24069
     C                   EVAL      PDCInd = WDCInd                                          BUG23040
     C**********         ENDIF                                                    BUG23040B BUG24069
     C**********         EVAL      MGADI1 = %TRIM(MGADI1)                        BUG23040A BUG23280B
     C**********         EVAL      MGADI2 = %TRIM(MGADI2)                        BUG23040A BUG23280B
     C**********         EVAL      MGADI3 = %TRIM(MGADI3)                        BUG23040A BUG23280B
     C**********         EVAL      MGADI4 = %TRIM(MGADI4)                        BUG23040A BUG23280B
     C**********         EVAL      MGADI5 = %TRIM(MGADI5)                        BUG23040A BUG23280B
     C**********         EVAL      MGADI6 = %TRIM(MGADI6)                        BUG23040A BUG23280B
      *                                                                                     BUG23284
      ** Initialize Output Parms to Blanks                                                  BUG23284
      *                                                                                     BUG23284
     C                   EVAL      PFormL1 = *BLANKS                                        BUG23284
     C                   EVAL      PFormL2 = *BLANKS                                        BUG23284
     C                   EVAL      PFormL3 = *BLANKS                                        BUG23284
     C                   EVAL      PFormL4 = *BLANKS                                        BUG23284
     C                   EVAL      PFormL5 = *BLANKS                                        BUG23284
     C                   EVAL      PFormL6 = *BLANKS                                        BUG23284
     C                   EVAL      PFormL7 = *BLANKS                                        BUG23284
     C                   EVAL      PFormL8 = *BLANKS                                        BUG23284
     C                   EVAL      PFormL9 = *BLANKS                                        BUG23284
     C                   EVAL      PFormL10 = *BLANKS                                       BUG23284
     C                   EVAL      PFormL11 = *BLANKS                                       BUG23284
     C                   EVAL      PFormL12 = *BLANKS                                       BUG23284
     C                   EVAL      PFormL13 = *BLANKS                                       BUG23284
     C                   EVAL      PFormL14 = *BLANKS                                       BUG23284
     C                   EVAL      PFormL15 = *BLANKS                                       BUG23284
     C                   EVAL      PFormL16 = *BLANKS                                       BUG23284
     C                   EVAL      PFormL17 = *BLANKS                                       BUG23284
     C                   EVAL      PFormL18 = *BLANKS                                       BUG23284
     C                   EVAL      PFormL19 = *BLANKS                                       BUG23284
     C                   EVAL      PFormL20 = *BLANKS                                       BUG23284
     C                   EVAL      PFormL21 = *BLANKS                                       BUG23742
     C                   EVAL      PFormL22 = *BLANKS                                       BUG23742
      *                                                                                       CER030
     C                   EVAL      ArrExtNar = *BLANKS                                     BUG23280D
     C                   EVAL      PArrExt = *BLANKS                                        BUG23742
      *                                                                                    BUG23280D
     C                   IF        MG8633 <> *BLANKS                                       BUG23280D
     C                   EVAL      PFormL1 = %TRIM(MG8633)                                 BUG23280D
     C                   ELSE                                                              BUG23280D
     C                   EVAL      PFormL1 = *BLANKS                                       BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
      ** If 22 * 35 structure is input call MG001901                                        BUG23742
      *                                                                                     BUG23742
     C                   IF        MG8635 ='Y'                                              BUG23742
      *                                                                                     BUG23742
     C                   EVAL      PArrExt(1) = MGADI1                                      BUG23742
     C                   EVAL      PArrExt(2) = MGADI2                                      BUG23742
     C                   EVAL      PArrExt(3) = MGADI3                                      BUG23742
     C                   EVAL      PArrExt(4) = MGADI4                                      BUG23742
     C                   EVAL      PArrExt(5) = MGADI5                                      BUG23742
     C                   EVAL      PArrExt(6) = MGADI6                                      BUG23742
     C                   EVAL      PArrExt(7) = MG8621                                      BUG23742
     C                   EVAL      PArrExt(8) = MG8622                                      BUG23742
     C                   EVAL      PArrExt(9) = MG8623                                      BUG23742
     C                   EVAL      PArrExt(10) = MG8624                                     BUG23742
     C                   EVAL      PArrExt(11) = MG8625                                     BUG23742
     C                   EVAL      PArrExt(12) = MG8626                                     BUG23742
     C                   EVAL      PArrExt(13) = MG8627                                     BUG23742
     C                   EVAL      PArrExt(14) = MG8628                                     BUG23742
     C                   EVAL      PArrExt(15) = MG8629                                     BUG23742
     C                   EVAL      PArrExt(16) = MG8660                                     BUG23742
     C                   EVAL      PArrExt(17) = MG8661                                     BUG23742
     C                   EVAL      PArrExt(18) = MG8662                                     BUG23742
     C                   EVAL      PArrExt(19) = MG8663                                     BUG23742
     C                   EVAL      PArrExt(20) = MG8664                                     BUG23742
     C                   EVAL      PArrExt(21) = MG8665                                     BUG23742
     C                   EVAL      PArrExt(22) = MG8632                                     BUG23742
      *                                                                                     BUG23742
     C                   CALL      'MG001901'                                               BUG23742
     C                   PARM                    PRtcd                                      BUG23742
     C                   PARM      '*FORMAT'     POptn                                      BUG23742
     C                   PARM      MGNWRK        PNwrk                                      BUG23742
     C                   PARM                    PMsgTyp                                    BUG23742
     C**********         PARM                    PBrca                             BUG23742 BUG25311
     C**********         PARM                    PCNum                             BUG23742 BUG25311
     C**********         PARM                    PCcy                              BUG23742 BUG25311
     C**********         PARM                    PAcno                             BUG23742 BUG25311
     C**********         PARM                    PAcsq                             BUG23742 BUG25311
     C                   PARM      MGBRCA        PBrca                                      BUG25311
     C                   PARM      MGCNUM        PCNum                                      BUG25311
     C                   PARM      MGCCY         PCcy                                       BUG25311
     C                   PARM      MGACCD        PAcno                                      BUG25311
     C                   PARM      MGACSQ        PAcsq                                      BUG25311
     C                   PARM                    PDCInd                                     BUG23742
     C                   PARM                    PRtty                                      BUG23742
     C                   PARM                    PArrExt                                    BUG23742
     C                   PARM                    PFormL1                                    BUG23742
     C                   PARM                    PFormL2                                    BUG23742
     C                   PARM                    PFormL3                                    BUG23742
     C                   PARM                    PFormL4                                    BUG23742
     C                   PARM                    PFormL5                                    BUG23742
     C                   PARM                    PFormL6                                    BUG23742
     C                   PARM                    PFormL7                                    BUG23742
     C                   PARM                    PFormL8                                    BUG23742
     C                   PARM                    PFormL9                                    BUG23742
     C                   PARM                    PFormL10                                   BUG23742
     C                   PARM                    PFormL11                                   BUG23742
     C                   PARM                    PFormL12                                   BUG23742
     C                   PARM                    PFormL13                                   BUG23742
     C                   PARM                    PFormL14                                   BUG23742
     C                   PARM                    PFormL15                                   BUG23742
     C                   PARM                    PFormL16                                   BUG23742
     C                   PARM                    PFormL17                                   BUG23742
     C                   PARM                    PFormL18                                   BUG23742
     C                   PARM                    PFormL19                                   BUG23742
     C                   PARM                    PFormL20                                   BUG23742
     C                   PARM                    PFormL21                                   BUG23742
     C                   PARM                    PFormL22                                   BUG23742
     C                   PARM                    Idx                                        BUG23742
     C                   PARM                    FldNamXAr                                  BUG23742
     C                   PARM                    MsgIDXAr                                   BUG23742
     C                   PARM                    MsgDtaXAr                                  BUG23742
     C                   PARM                    WFldNmXAr                                  BUG23742
     C                   PARM                    WMsgIDXAr                                  BUG23742
     C                   PARM                    WMsgDtXAr                                  BUG23742
     C                   ELSE                                                               BUG23742
      *                                                                                     BUG23742
     C                   CALL      'MG001900'                                                 CER030
     C                   PARM                    PRtcd                                        CER030
     C                   PARM      '*FORMAT'     POptn                                        CER030
     C                   PARM      MGNWRK        PNwrk                                        CER030
     C                   PARM                    PMsgTyp                                      CER030
     C**********         PARM                    PBrca                               CER030 BUG25311
     C**********         PARM                    PCNum                               CER030 BUG25311
     C**********         PARM                    PCcy                                CER030 BUG25311
     C**********         PARM                    PAcno                               CER030 BUG25311
     C**********         PARM                    PAcsq                               CER030 BUG25311
     C                   PARM      MGBRCA        PBrca                                      BUG25311
     C                   PARM      MGCNUM        PCNum                                      BUG25311
     C                   PARM      MGCCY         PCcy                                       BUG25311
     C                   PARM      MGACCD        PAcno                                      BUG25311
     C                   PARM      MGACSQ        PAcsq                                      BUG25311
     C                   PARM                    PDCInd                                       CER030
     C                   PARM                    PRtty                                        CER030
     C                   PARM      MGADI1        PNarr1                                       CER030
     C                   PARM      MGADI2        PNarr2                                       CER030
     C                   PARM      MGADI3        PNarr3                                       CER030
     C                   PARM      MGADI4        PNarr4                                       CER030
     C                   PARM      MGADI5        PNarr5                                       CER030
     C                   PARM      MGADI6        PNarr6                                       CER030
     C                   PARM                    PFormL1                                      CER030
     C                   PARM                    PFormL2                                      CER030
     C                   PARM                    PFormL3                                      CER030
     C                   PARM                    PFormL4                                      CER030
     C                   PARM                    PFormL5                                      CER030
     C                   PARM                    PFormL6                                      CER030
     C                   PARM                    PFormL7                                      CER030
     C                   PARM                    PFormL8                                      CER030
     C                   PARM                    PFormL9                                      CER030
     C                   PARM                    PFormL10                                     CER030
     C                   PARM                    PFormL11                                     CER030
     C                   PARM                    PFormL12                                     CER030
     C                   PARM                    PFormL13                                     CER030
     C                   PARM                    PFormL14                                     CER030
     C                   PARM                    PFormL15                                     CER030
     C                   PARM                    PFormL16                                     CER030
     C                   PARM                    PFormL17                                     CER030
     C                   PARM                    PFormL18                                     CER030
     C                   PARM                    PFormL19                                     CER030
     C                   PARM                    PFormL20                                     CER030
     C                   PARM                    Idx                                          CER030
     C                   PARM                    FldNamXAr                                    CER030
     C                   PARM                    MsgIDXAr                                     CER030
     C                   PARM                    MsgDtaXAr                                    CER030
     C                   PARM                    WFldNmXAr                                    CER030
     C                   PARM                    WMsgIDXAr                                    CER030
     C                   PARM                    WMsgDtXAr                                    CER030
      *                                                                                     BUG23742
     C                   ENDIF                                                              BUG23742
      *                                                                                       CER030
     C                   EVAL      ArrExtNar(1) = PFormL1                                     CER030
     C                   EVAL      ArrExtNar(2) = PFormL2                                     CER030
     C                   EVAL      ArrExtNar(3) = PFormL3                                     CER030
     C                   EVAL      ArrExtNar(4) = PFormL4                                     CER030
     C                   EVAL      ArrExtNar(5) = PFormL5                                     CER030
     C                   EVAL      ArrExtNar(6) = PFormL6                                     CER030
     C                   EVAL      ArrExtNar(7) = PFormL7                                     CER030
     C                   EVAL      ArrExtNar(8) = PFormL8                                     CER030
     C                   EVAL      ArrExtNar(9) = PFormL9                                     CER030
     C                   EVAL      ArrExtNar(10) = PFormL10                                   CER030
     C                   EVAL      ArrExtNar(11) = PFormL11                                   CER030
     C                   EVAL      ArrExtNar(12) = PFormL12                                   CER030
     C                   EVAL      ArrExtNar(13) = PFormL13                                   CER030
     C                   EVAL      ArrExtNar(14) = PFormL14                                   CER030
     C                   EVAL      ArrExtNar(15) = PFormL15                                   CER030
     C                   EVAL      ArrExtNar(16) = PFormL16                                   CER030
     C                   EVAL      ArrExtNar(17) = PFormL17                                   CER030
     C                   EVAL      ArrExtNar(18) = PFormL18                                   CER030
     C                   EVAL      ArrExtNar(19) = PFormL19                                   CER030
     C                   EVAL      ArrExtNar(20) = PFormL20                                   CER030
     C                   EVAL      ArrExtNar(21) = PFormL21                                 BUG23742
     C                   EVAL      ArrExtNar(22) = PFormL22                                 BUG23742
     C                   EVAL      WIdx = 1                                                   CER030
      *                                                                                       CER030
      ** Populate the Extended Narratives                                                     CER030
      *                                                                                       CER030
     C*****1****         DO        20                                                CER030 BUG23742
     C**********         IF        ArrExtNar(WIdx) = *BLANKS                        CER030 BUG23280D
     C**********         LEAVE                                                      CER030 BUG23280D
     C**********         ELSE                                                       CER030 BUG23280D
     C     1             DO        22                                                       BUG23742
     C                   IF        ArrExtNar(WIdx) <> *BLANKS                              BUG23280D
      *                                                                                    BUG25476A
      ** Change 1st character of extended narrative if ':' or '-'                          BUG25476A
      *                                                                                    BUG25476A
     C                   EVAL      WResult = ArrExtNar(WIdx)                               BUG25476A
     C                   EVAL      WFst = %SUBST(WResult:1:1)                              BUG25476A
     C                   IF        WFst = ':' OR WFst = '-'                                BUG25476A
     C                   MOVEL     '.'           WResult                                   BUG25476A
     C                   EVAL      ArrExtNar(WIdx) = WResult                               BUG25476A
     C                   ENDIF                                                             BUG25476A
      *                                                                                    BUG25476A
     C                   EVAL      M = M + 1                                                  CER030
     C     M             OCCUR     MULT                                                       CER030
      *                                                                                       CER030
     C                   IF        WFrstFlg = 'Y'                                             CER030
     C                   EVAL      MTAG = ':86:'                                              CER030
     C                   EVAL      WFrstFlg = 'N'                                             CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   EVAL      MFLD = ArrExtNar(WIdx)                                     CER030
      *                                                                                       CER030
     C**********         EVAL      WPos = %SCAN('/IACC/D':MFLD)                      CER030 BUG23742
      **********                                                                     CER030 BUG23742
     C**********         IF        WPos > 0                                          CER030 BUG23742
      **********                                                                   BUG23247 BUG23742
     C**********         EVAL      WIndLn = WPos + 7                               BUG23247 BUG23742
     C**********         EVAL      WDCInd = %SUBST(MFLD:WIndLn:1)                  BUG23247 BUG23742
      **********                                                                   BUG23247 BUG23742
     C**********         IF        WDCInd = '0' OR WDCInd = '1' OR                 BUG23247 BUG23742
     C**********                   WDCInd = '2' OR WDCInd = '3'                    BUG23247 BUG23742
     C**********         EVAL      %SUBST(MFLD:WPos:8) = *BLANKS                   BUG23247 BUG23742
     C**********         ENDIF                                                     BUG23247 BUG23742
      **********                                                                   BUG23247 BUG23742
     C**********         ENDIF                                                       CER030 BUG23742
      **********                                                                    CER030 BUG23280D
     C**********         IF        EDKLSP = 'Y'                                     CER030 BUG23280D
     C**********         EVAL      WPos = %CHECKR(' ':ArrExtNar(WIdx))              CER030 BUG23280D
      **********                                                                    CER030 BUG23280D
     C**********         IF        WPos > 0 AND WPos < 49                           CER030 BUG23280D
     C**********         EVAL      MFLD = %TRIM(MFLD) + EDLSEP                      CER030 BUG23040A
     C**********         EVAL      MFLD = %TRIM(MFLD) + %TRIM(EDLSEP)            BUG23040A BUG23280D
      **********                                                                    CER030 BUG23280D
     C**********         ELSEIF    WPos = 49                                        CER030 BUG23280D
     C**********         EVAL      MFLD = %TRIM(MFLD) + EDLSEP                      CER030 BUG23040A
     C**********         EVAL      MFLD = %TRIM(MFLD) + %TRIM(EDLSEP)            BUG23040A BUG23280D
     C**********         EVAL      CTRC = *BLANKS                                   CER030 BUG23280D
     C**********         EVAL      M = M + 1                                        CER030 BUG23280D
     C*****M****         OCCUR     MULT                                             CER030 BUG23280D
     C**********         EVAL      MFLD = %SUBST(EDLSEP:2)                          CER030 BUG23040A
     C**********         EVAL      MFLD = %TRIM(%SUBST(EDLSEP:2))                BUG23040A BUG23280D
     C**********         EVAL      CTRC = CRLF                                      CER030 BUG23280D
      **********                                                                    CER030 BUG23280D
     C**********         ELSEIF    WPos = 50                                        CER030 BUG23280D
     C**********         EVAL      CTRC = *BLANKS                                   CER030 BUG23280D
     C**********         EVAL      M = M + 1                                        CER030 BUG23280D
     C*****M****         OCCUR     MULT                                             CER030 BUG23280D
     C**********         EVAL      MFLD = EDLSEP                                    CER030 BUG23040A
     C**********         EVAL      MFLD = %TRIM(EDLSEP)                          BUG23040A BUG23280D
     C**********         EVAL      CTRC = CRLF                                      CER030 BUG23280D
     C**********         ENDIF                                                      CER030 BUG23280D
      **********                                                                    CER030 BUG23280D
     C**********         ENDIF                                                      CER030 BUG23280D
      *                                                                                       CER030
     C                   EVAL      CTRC = CRLF                                                CER030
      *                                                                                       CER030
     C                   IF        %SUBST(ArrExtNar(WIdx):51:20) <> *BLANKS                   CER030
     C                   EVAL      CTRC = *BLANKS                                             CER030
     C                   EVAL      CurLength = CurLength +                                    CER030
     C                                         %LEN(%TRIM(MTAG))+                             CER030
     C                                         %LEN(%TRIM(MFLD)) +                            CER030
     C                                         %LEN(%TRIM(CTRC))                              CER030
     C                   EVAL      M = M + 1                                                  CER030
     C     M             OCCUR     MULT                                                       CER030
     C                   EVAL      MFLD = %SUBST(ArrExtNar(WIdx):51:20)                       CER030
      *                                                                                       CER030
     C**********         EVAL      WPos = %SCAN('/IACC/D':MFLD)                      CER030 BUG23742
      **********                                                                     CER030 BUG23742
     C**********         IF        WPos > 0                                          CER030 BUG23742
      **********                                                                   BUG23247 BUG23742
     C**********         EVAL      WIndLn = WPos + 7                               BUG23247 BUG23742
     C**********         EVAL      WDCInd = %SUBST(MFLD:WIndLn:1)                  BUG23247 BUG23742
      **********                                                                   BUG23247 BUG23742
     C**********         IF        WDCInd = '0' OR WDCInd = '1' OR                 BUG23247 BUG23742
     C**********                   WDCInd = '2' OR WDCInd = '3'                    BUG23247 BUG23742
     C**********         EVAL      %SUBST(MFLD:WPos:8) = *BLANKS                     CER030 BUG23742
     C**********         ENDIF                                                     BUG23247 BUG23742
      **********                                                                   BUG23247 BUG23742
     C**********         ENDIF                                                       CER030 BUG23742
      **********                                                                     CER030 BUG23742
     C**********         IF        EDKLSP = 'Y'                                     CER030 BUG23280D
     C**********         EVAL      WPos = %CheckR(' ':ArrExtNar(WIdx))              CER030 BUG23280D
      **********                                                                    CER030 BUG23280D
     C**********         IF        WPos > 50 AND WPos < 71                          CER030 BUG23280D
     C**********         EVAL      MFLD = %TRIM(MFLD) + EDLSEP                      CER030 BUG23040A
     C**********         EVAL      MFLD = %TRIM(MFLD) + %TRIM(EDLSEP)            BUG23040A BUG23280D
     C**********         ENDIF                                                      CER030 BUG23280D
      **********                                                                    CER030 BUG23280D
     C**********         ENDIF                                                      CER030 BUG23280D
     C                   EVAL      CTRC = CRLF                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   EVAL      CurLength = CurLength +                                    CER030
     C                                         %LEN(%TRIM(MTAG)) +                            CER030
     C                                         %LEN(%TRIM(MFLD)) +                            CER030
     C                                         %LEN(%TRIM(CTRC))                              CER030
     C                   ENDIF                                                                CER030
     C                   EVAL      WIdx = WIdx + 1                                            CER030
     C                   ENDDO                                                                CER030
      *                                                                                       CER030
      ** Structured Format                                                                    CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      WFld86= *BLANKS                                            CER030
     C                   EVAL      WKTag= *BLANKS                                             CER030
     C                   EVAL      WFldSep = EDFSEP                                           CER030
      *                                                                                       CER030
      ** Subfield GVC                                                                         CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = 'GVC'                                              CER030
     C                   EVAL      WKValue = MG86GV                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Booking Text                                                                         CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '00'                                               CER030
     C                   EVAL      WKValue = MG8600                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Batch No                                                                             CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '10'                                               CER030
     C                   EVAL      WKValue = MG8610                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '20'                                               CER030
     C                   EVAL      WKValue = MG8620                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '21'                                               CER030
     C                   EVAL      WKValue = MG8621                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '22'                                               CER030
     C                   EVAL      WKValue = MG8622                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '23'                                               CER030
     C                   EVAL      WKValue = MG8623                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '24'                                               CER030
     C                   EVAL      WKValue = MG8624                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '25'                                               CER030
     C                   EVAL      WKValue = MG8625                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '26'                                               CER030
     C                   EVAL      WKValue = MG8626                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '27'                                               CER030
     C                   EVAL      WKValue = MG8627                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '28'                                               CER030
     C                   EVAL      WKValue = MG8628                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '29'                                               CER030
     C                   EVAL      WKValue = MG8629                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Bank Sort Code                                                                       CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '30'                                               CER030
     C                   EVAL      WKValue = MG8630                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Account Number                                                                       CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '31'                                               CER030
     C                   EVAL      WKValue = MG8631                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Account Name                                                                         CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '32'                                               CER030
     C                   EVAL      WKValue = MG8632                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Account Name                                                                         CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '33'                                               CER030
     C                   EVAL      WKValue = MG8633                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Text Code Supplement                                                                 CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '34'                                               CER030
     C                   EVAL      WKValue = MG8634                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Beneficiary Data                                                                     CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '35'                                               CER030
     C                   EVAL      WKValue = MG8635                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Beneficiary Data                                                                     CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '36'                                               CER030
     C                   EVAL      WKValue = MG8636                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** IBAN                                                                                 CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '38'                                               CER030
     C                   EVAL      WKValue = MG8638                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '60'                                               CER030
     C                   EVAL      WKValue = MG8660                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '61'                                               CER030
     C                   EVAL      WKValue = MG8661                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '62'                                               CER030
     C                   EVAL      WKValue = MG8662                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '63'                                               CER030
     C                   EVAL      WKValue = MG8663                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '64'                                               CER030
     C                   EVAL      WKValue = MG8664                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '65'                                               CER030
     C                   EVAL      WKValue = MG8665                                           CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDSR                                                                CER030
      *                                                                                       CER030
      *****************************************************************                       CER030
      /EJECT                                                                                  CER030
      *****************************************************************                       CER030
      *                                                               *                       CER030
      *  SRLdFld - Load data into long string corresponding to field  *                       CER030
      *            86                                                 *                       CER030
      *                                                               *                       CER030
      *  Called by: SRMTCash                                          *                       CER030
      *                                                               *                       CER030
      *  Calls: None                                                  *                       CER030
      *                                                               *                       CER030
      *****************************************************************                       CER030
      *                                                                                       CER030
     C     SRLdFld       BEGSR                                                                CER030
      *                                                                                       CER030
     C                   IF        WKValue <> *BLANKS                                         CER030
      *                                                                                       CER030
     C                   IF        WKTag = 'GVC'                                              CER030
     C**********         EVAL      WPos = %SCAN('/IACC/D':WKValue)                BUG23032 BUG23032A
      *                                                                                     BUG23032
     C**********         IF        WPos > 0                                       BUG23032 BUG23032A
     C**********         EVAL      %SUBST(WKValue:WPos:8) = *BLANKS               BUG23032 BUG23032A
     C**********         ENDIF                                                    BUG23032 BUG23032A
      *                                                                                     BUG23032
     C**********         EVAL      WFld86 = %TRIM(WKTAG) +                           CER030 BUG22981
     C**********                            %TRIM(WKValue)                           CER030 BUG22981
     C                   EVAL      WFld86 = %TRIM(WKValue)                                  BUG22981
     C                   ELSE                                                                 CER030
     C**********         EVAL      WPos = %SCAN('/IACC/D':WKValue)                BUG23032A BUG23742
      **********                                                                  BUG23032A BUG23742
     C**********         IF        WPos > 0                                       BUG23032A BUG23742
      **********                                                                   BUG23247 BUG23742
     C**********         EVAL      WIndLn = WPos + 7                               BUG23247 BUG23742
     C**********         EVAL      WDCInd = %SUBST(WKValue:WIndLn:1)               BUG23247 BUG23742
      **********                                                                   BUG23247 BUG23742
     C**********         IF        WDCInd = '0' OR WDCInd = '1' OR                 BUG23247 BUG23742
     C**********                   WDCInd = '2' OR WDCInd = '3'                    BUG23247 BUG23742
     C**********         EVAL      %SUBST(WKValue:WPos:8) = *BLANKS               BUG23032A BUG23742
     C**********         ENDIF                                                     BUG23247 BUG23742
      **********                                                                   BUG23247 BUG23742
     C**********         ENDIF                                                    BUG23032A BUG23742
      **********                                                                  BUG23032A BUG23742
     C                   EVAL      WFld86 = %TRIM(WFldSep) +                                  CER030
     C                                      %TRIM(WKTAG) +                                    CER030
     C                                      %TRIM(WKValue)                                    CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   EVAL      M = M + 1                                                  CER030
     C     M             OCCUR     MULT                                                       CER030
      *                                                                                       CER030
     C                   IF        WFrstFlg = 'Y'                                             CER030
     C                   EVAL      MTAG = ':86:'                                              CER030
     C                   EVAL      WFrstFlg = 'N'                                             CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   EVAL      MFLD = WFld86                                              CER030
     C                   EVAL      CTRC = CRLF                                                CER030
     C                   EVAL      CurLength  = CurLength +                                   CER030
     C                                          %LEN(%TRIM(WFld86))                           CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDSR                                                                CER030
      *                                                                                       CER030
      *****************************************************************                       CER030
      /EJECT                                                                                  CER030
      *****************************************************************                       CER030
      *========================================================================*            MD055842
      * BldConvFil : Build Conversion Table for removing non-SWIFT characters  *            MD055842
      *------------------------------------------------------------------------*            MD055842
                                                                                            MD055842
     C     BldConvFil    BEGSR                                                              MD055842
      *    ----------    -----                                                              MD055842
      *                                                                                     MD055842
      ** Open Character conversion file                                                     MD055842
     C                   Open      SDCONVPD                                                 MD055842
      *                                                                                     MD055842
      ** Initialise work fields                                                             MD055842
     C                   Eval      Fr_Char = *Blanks                                        MD055842
     C                   Eval      To_Char = *Blanks                                        MD055842
     C                   Eval      WChrLen = 0                                              MD055842
                                                                                            MD055842
      ** Read file and collect characters in FROM and TO alpha fields                       MD055842
     C     *Loval        Setll     SDCONVPD                                                 MD055842
     C                   Read      SDCONVPD                                                 MD055842
                                                                                            MD055842
     C                   Dow       NOT %EOF                                                 MD055842
     C                   Eval      Fr_Char = %SUBST(Fr_Char:1:WChrLen)+FRCHAR               MD055842
     C                   Eval      To_Char = %SUBST(To_Char:1:WChrLen)+TOCHAR               MD055842
     C                   Eval      WChrLen = WChrLen + 1                                    MD055842
                                                                                            MD055842
     C                   Read      SDCONVPD                                                 MD055842
     C                   Enddo                                                              MD055842
      *                                                                                     MD055842
      ** Close file                                                                         MD055842
     C                   Close     SDCONVPD                                                 MD055842
      *                  -----                                                              MD055842
     C                   ENDSR                                                              MD055842
      *========================================================================*            MD055842
      /EJECT                                                                                MD055842
      *========================================================================*            MD055842
      * ConvChar : Convert Character and remove remove invalid non-SWIFT chars *            MD055842
      *------------------------------------------------------------------------*            MD055842
                                                                                            MD055842
     C     ConvChar      BEGSR                                                              MD055842
      *    --------      -----                                                              MD055842
      *                                                                                     MD055842
      ** Only process field if not blank                                                    MD055842
     C                   If        WConvFld <> *BLANKS                                      MD055842
                                                                                            MD055842
      ** Convert all non-SWIFT characters based on conversion table                         MD055842
     C                   Eval      WConvFld = %XLATE(%TRIM(Fr_Char)                         MD055842
     C                                        :%TRIM(To_Char):WConvFld)                     MD055842
                                                                                            MD055842
      ** Convert all remaining non-SWIFT chars (not defined in the table)                   MD055842
      ** into blanks. Use pre-defined 'Valid Swift Chars' field for comparison.             MD055842
     C                   Eval      WChrPos = 0                                              MD055842
     C                   Eval      WChrPos = %CHECK(ValSwiftChr:WConvFld)                   MD055842
                                                                                            MD055842
      ** Repeat process until all invalid chars are found and converted to blank            MD055842
     C                   Dow       WChrPos > 0                                              MD055842
     C                   Eval      WConvFld=%REPLACE(WBlank:WConvFld:WChrPos:1)             MD055842
     C                   Eval      WChrPos = 0                                              MD055842
     C                   Eval      WChrPos = %CHECK(ValSwiftChr:WConvFld)                   MD055842
     C                   Enddo                                                              MD055842
                                                                                            MD055842
     C                   Endif                                                              MD055842
      *                  -----                                                              MD055842
     C                   ENDSR                                                              MD055842
      *========================================================================*            MD055842
      /EJECT                                                                                MD055842
     C/COPY WNCPYSRC,MGH00046

      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *------------------------------------------------------------------------*

     C     *INZSR        BEGSR
      *    ------        -----

      ** Initialise Copyright Array

     C                   MOVEA     CPY@          CPY@@            80

      ** Initialise LDA

     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBPGM
     C                   MOVEL     PSProcMod     DBMOD
     C                   OUT       LDA

      ** Retrieve Bank details.

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD                         Return Code
     C                   PARM      '*FIRST '     P@OPTN                         Option
     C     SDBANK        PARM      SDBANK        DSFDY

      **  Access SDMGMEPD for message management data.

     C                   CALL      'AOMGMER0'
     C                   PARM      '*DBERR '     P@RTCD                         Return Code
     C                   PARM      '*FIRST '     P@OPTN                         Option
     C     SDMGME        PARM      SDMGME        DSFDY

      ** Check if feature CSW020 'SWIFT Decimal Places' is present.

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      'CSW020'      P@SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CSW020
     C                   ENDIF

      ** Key to access Network Account or Posting details.

     C     Key           KLIST
     C                   KFLD                    MGNWRK                         Network
     C                   KFLD                    MGBRCA                         Account Branch
     C                   KFLD                    MGCNUM                         Account Customer
     C                   KFLD                    MGCCY                          Account Currency
     C                   KFLD                    MGACCD                         Account Code
     C                   KFLD                    MGACSQ                         Account Sequence
     C                   KFLD                    MGNATY                         Network Account type
     C                   KFLD                    MGDSTN                         MT94x Destination
     C/COPY WNCPYSRC,MGH00047
      *                                                                                       CER030
     C                   EVAL      CER030 = 'N'                                               CER030
      *                                                                                       CER030
      ** Check if feature CER030  is installed                                                CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER030 '     PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
      ** Database error                                                                       CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF   '                                         CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   EVAL      DBASE = 008                                                CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBKEY = PSard                                              CER030
     C                   OUT       LDA                                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C**********         Else                                                     BUG25800 BUG25800A
     C**********         Eval      CER030 = 'N'                                   BUG25800 BUG25800A
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
                                                                                            MD055842
      ** Check if feature CMG008 is installed                                               MD055842
                                                                                            MD055842
     C                   EVAL      CMG008 = 'N'                                             MD055842
                                                                                            MD055842
     C                   CALL      'AOSARDR0'                                               MD055842
     C                   PARM      *BLANKS       PRtcd                          Return Code MD055842
     C                   PARM      '*VERIFY'     POptn                          Option      MD055842
     C                   PARM      'CMG008 '     PSard                          Feature Ref MD055842
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD055842
                                                                                            MD055842
     C                   IF        PRtcd = *BLANKS                                          MD055842
     C                   MoveL     'Y'           CMG008            1                        MD055842
     C                   ENDIF                                                              MD055842
                                                                                            MD055842
      * If CMG008 is ON, build the character conversion table                               MD055842
                                                                                            MD055842
     C                   IF        CMG008 = 'Y'                                             MD055842
     C                   EXSR      BldConvFil                                               MD055842
     C                   ENDIF                                                              MD055842
                                                                                            MD055842
     C/COPY OFCPYSRCZ,CGL146_062                                                              CGL146
                                                                                            BUG25529
      ** Get the Maximum number of characters for field 86                                  BUG25529
                                                                                            BUG25529
     C                   CALL      'AOSVALR0'                                               BUG25529
     C                   PARM      *BLANKS       PRtcd1                                     BUG25529
     C                   PARM      SValK1        PSValK1                                    BUG25529
     C                   PARM                    PSVal1                                     BUG25529
     C**********         PARM      *BLANKS       PSValK2                           BUG25529 BUG26515
     C                   PARM      SValK2        PSValK2                                    BUG26515
     C                   PARM                    PSVal2                                     BUG25529
     C**********         PARM      *BLANKS       PSValK3                           BUG25529 MD042041
     C                   PARM      SValK3        PSValK3                                    MD042041
     C                   PARM                    PSVal3                                     BUG25529
     C                   PARM      *BLANKS       PSValK4                                    BUG25529
     C                   PARM                    PSVal4                                     BUG25529
     C                   PARM      *BLANKS       PSValK5                                    BUG25529
     C                   PARM                    PSVal5                                     BUG25529
     C                   PARM      *BLANKS       PSValK6                                    BUG25529
     C                   PARM                    PSVal6                                     BUG25529
     C                   PARM      *BLANKS       PSValK7                                    BUG25529
     C                   PARM                    PSVal7                                     BUG25529
     C                   PARM      *BLANKS       PSValK8                                    BUG25529
     C                   PARM                    PSVal8                                     BUG25529
     C                   PARM      *BLANKS       PSValK9                                    BUG25529
     C                   PARM                    PSVal9                                     BUG25529
     C                   PARM      *BLANKS       PSValK10                                   BUG25529
     C                   PARM                    PSVal10                                    BUG25529
      *                                                                                     BUG25529
     C                   IF        PRtcd1 <> *BLANKS                                        BUG25529
      *                                                                                     BUG25529
     C     *LOCK         IN        LDA                                                      BUG25529
     C                   EVAL      DBPGM = 'MG000942'                                       BUG25529
     C                   EVAL      DBFILE = 'SDSVALPD'                                      BUG25529
     C                   EVAL      DBASE = 010                                              BUG25529
     C                   EVAL      DBKEY = %TRIM(SValK1)                                    BUG25529
     C                   OUT       LDA                                                      BUG25529
      *                                                                                     BUG25529
     C                   EXSR      *PSSR                                                    BUG25529
      *                                                                                     BUG25529
     C                   ELSE                                                               BUG25529
      *                                                                                     BUG25529
     C                   MOVEL     PSVal1        WFld21                                     BUG25529
     C                   MOVEL     PSVal2        WFld21a                                    BUG26515
     C                   MOVEL     PSVAL3        WSort61                                    MD042041
      *                                                                                     BUG25529
     C                   ENDIF                                                              BUG25529
                                                                                            BUG25529

      *    ------        -----
     C     @INZSR        ENDSR

      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*

     C     *PSSR         BEGSR
      *    ----------    ------

      **  Write database error to report

     C                   OPEN      MG000942AU
     C                   WRITE     HEADAU
     C                   EXSR      SRAccnt                                                    CGL029
     C                   EVAL      DNTAC = MGNetAcc                             Network Account
     C                   WRITE     DBERROR

     C                   DUMP
     C                   ROLBK

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On

     C                   RETURN

      *    ----------    ------
     C     @PSSR         ENDSR

      *========================================================================*
      ***/COPY*MGCPYSRC,MGSWIFTRAN                                                          AR858070
**  CPY@
(c) Finastra International Limited 2002
