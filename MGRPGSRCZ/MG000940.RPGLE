     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
     H*FTRANS**********************************************************                     AR858070
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MG MT940 Message Generation')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation Module                            *
      *                                                               *
      *  MG000940 - Midas MG MT940 Message Generation                 *
      *                                                               *
      *  Function:  This program formats the MT940 message and        *
      *             outputs it to MGOREFPD and MGOMSGPD.              *
      *                                                               *
      *  Called By: GLC001430                                         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD052633           Date 08Oct19
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD042371           Date 11Nov16               *
      *                 MD042041           Date 21Oct16               *
      *                 MD031691           Date 30Jul15               *
      *                 AR858070           Date 03Nov11               *
      *                 MD024641           Date 10Feb14               *
      *                 MD024415           Date 20Jan14               *
      *                 CGL146A            Date 10Jul13               *
      *                 CGL146             Date 10Jul13               *
      *                 AR972805           Date 27Feb13               *
      *                 222299             Date 20Feb13               *
      *                 256990             Date 06Oct08               *
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
      *                 BUG23557           Date 30Mar09               *
      *                 BUG23172A          Date 26Mar09               *
      *                 BUG23040A          Date 25Mar09               *
      *                 BUG23284           Date 13Mar09               *
      *                 BUG23247           Date 10Mar09               *
      *                 BUG23209           Date 06Mar09               *
      *                 BUG23040           Date 04Mar09               *
      *                 BUG23032A          Date 27Feb09               *
      *                 BUG23032           Date 23Feb09               *
      *                 BUG22981           Date 18Feb09               *
      *                 BUG22882           Date 16Feb09               *
      *                 BUG22853           Date 12Feb09               *
      *                 BUG22687           Date 06Feb09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 27Oct03               *
      *                 CGL013  *Create    Date 14May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052633 - MT940's closing balance figures is 1 digit short -*
      *             Increase the length of ZAMNT and ZSAMNT to handle *
      *             numeric size of (15,0).                           *
      *           - Applied for MD-53975                              *
      *  MD046248 - Finastra Rebranding                               *
      *  MD042371 - MT940 not accepted by SWIFT because it is too long*
      *  MD042041 - Tag 61 is not sorted by DRCR and PSTA. Added a    *
      *             system value that when is set to 'Y', program     *
      *             use another logical file that is also sorted by   *
      *             DRCR and PSTA.                                    *
      *  MD031691 - MT940 generated by BFM in COB is sometimes        *
      *             extracting more than 6 lines in Field 86 resul-   *
      *             ting to the message being NACKed by SWIFT.        *
      *           - Enhance the formatting of messages when it is     *
      *             for SWIFT network.  This is to make sure that     *
      *             it maximizes the 6x65 (lines/characters per line) *
      *             limit. i.e. Append details of similar subfields   *
      *             instead of always writing it on the next line.    *
      *           - Also make sure that the no more than the maximum  *
      *             number of lines as defined in the system values   *
      *             MT94xFld86LineOutput will be produced.            *
      *  AR858070 - German characters from JE narratives are          *
      *             converted wrong into the messages (Child:AR858071)*
      *  MD024641 - The field :65: Forward Available Balance is not   *
      *             correct if the statement date is in the past      *
      *  MD024415 - Correct I/C generation of MT940/MT950             *
      *            Amend hooks: CGL146_090, CGL146_093                *
      *            (Recompile)                                        *
      *  CGL146A - MT940/MT950 Production in Input Cycle              *
      *            Added hooks: CGL146_087, CGL146_088, CGL146_089    *
      *                         CGL146_090, CGL146_091, CGL146_092    *
      *                         CGL146_093, CGL146_094                *
      *  CGL146 - MT940/MT950 Production in Input Cycle               *
      *           Added hooks: CGL146_001, CGL146_057, CGL146_058     *
      *  AR972805 - Remove equate translation as done externally.     *
      *             Recompile over FTCPYSRC,FTSWIFTRAN.               *
      *             (Child: AR972806)                                 *
      *  222299 - Do not write IBAN to SWIFT Account on MGOREFPD      *
      *         - Internal IUS software cannot use IBANs              *
      *         - Applied for AR976533. (Child:AR976536)              *
      *  256990 - Discrepancy found in MT940 field 62M.               *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,MGH00013                                 *
      *             WNCPYSRC,MGH00014                                 *
      *             WNCPYSRC,MGH00015                                 *
      *             WNCPYSRC,MGH00016                                 *
      *             WNCPYSRC,MGH00017                                 *
      *             WNCPYSRC,MGH00018                                 *
      *             WNCPYSRC,MGH00019                                 *
      *             WNCPYSRC,MGH00020                                 *
      *             WNCPYSRC,MGH00021                                 *
      *             WNCPYSRC,MGH00022                                 *
      *             WNCPYSRC,MGH00023                                 *
      *             WNCPYSRC,MGH00024                                 *
      *             WNCPYSRC,MGH00025                                 *
      *             WNCPYSRC,MGH00026                                 *
      *             WNCPYSRC,MGH00027                                 *
      *             WNCPYSRC,MGH00028                                 *
      *             WNCPYSRC,MGH00029                                 *
      *             WNCPYSRC,MGH00030                                 *
      *             WNCPYSRC,MGH00031                                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26515 - Lines 2 onwards were dropped in the flat file     *
      *  BUG26075 - Multicash Field 25 in error                       *
      *  BUG25800A - revert fix applied                               *
      *  BUG25529 - Multicash for Midas Plus requires GVC code on     *
      *             multicash narrative                               *
      *  BUG25800 - Missing subfield 4 - field 61 of MT940            *
      *             at regression test                                *
      *  BUG25476A - MT940 rejected by MMM                            *
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
      *  BUG23557 - GLC001430 00001 is failing                        *
      *  BUG23172A - Account Number for SWIFT messages is always in   *
      *              IBAN format during MT940 generation.             *
      *  BUG23040A - MMM does not reformat Multicash MT942 with       *
      *             /IACC/Dn indicator                                *
      *  BUG23284 - Wrong Field 61 subfield 6 for SWIFT               *
      *  BUG23247 - Incorrect handling of invalid /IACC/Dn indicator  *
      *  BUG23209 - Extend the size of MULT from 2000 to 9000         *
      *  BUG23040 - MMM does not reformat Multicash MT942 with        *
      *             /IACC/Dn indicator                                *
      *  BUG23032A - /IACC/Dn indicator should not show on Field 86   *
      *  BUG23032 - /IACC/Dn indicator should not show on Field 86    *
      *  BUG22981 - GVC characters should not be included in output   *
      *             for Multicash MT942 message in field 86           *
      *  BUG22882 - Component GLC001430 failed                        *
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
      *  222373 - Parameter Mismatch                                  *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                              *
      *  01        -   EOF MGF940L0                                   *
      *  02        -   Chain failed in SDNWRKL1                       *
      *  03        -   Chain failed in GLNW94L0                       *
      *  15        -   Error on call to ZM0040, ZM0060                *
      *  41        -   Error on write to MGOREFPD                     *
      *  42        -   Error on write to MGOMSGPD                     *
      *  62        -   Chain failed on MGY940L0                       *
      *  62        -   EOF MGX940L0                                   *
      *  U7 U8 LR                                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRProc        - Detail processing                            *
      *  Format_MT940  - Format MT940 Message                         *
      *  Format_20     - Format Field 20 Transaction Number           *
      *  Format_21     - Format Field 21 Related Reference            *                       CER030
      *  Format_25     - Format Field 25, Account Identification      *
      *  Format_28     - Format Field 28C Entry and Page Number       *
      *  Format_60     - Format Field 60  Opening Balance             *
      *  Format_6186   - Format Repeating fields 61 and 86            *
      *  Format_62     - Format Field 62a Closing Balance             *
      *  Format_64     - Format Field 64  Closing Available Balance   *
      *  Format_65     - Format Repeating field 65                    *
      *  Format_86     - Format 86 - General Info to Account Owner    *
      *  Format_F62    - Format Final Field 62                        *
      *  SROref        - Output Record to MGOREFPD                    *
      *  SROMsg        - Output to PF/MGOMSGPD                        *
      *  SRAccLen      - Accumulate Message Length                    *
      *  SRDetFldLen   - Determine Field Length                       *
      *  SR_Clear1     - Clear work fields after each MGF940PD read   *
      *  SR_Clear2     - Clear work fields bef procg continuation page*
      *  Get_NwrkDet   - Get Network Details                          *
      *  Get_NwrkAcDet -  Get Network Account Details                 *
      *  Call_ZM0040   - Convert amount o SWIFT format                *
      *  Call_ZM0060   - Convert date to YYMMDD format                *
      *  SRMTCash - Process Extended Narratives for Multicash         *                       CER030
      *  SRLdFld - Load data into long string corresponding to field  *                       CER030
      *            86                                                 *                       CER030
      *  *INZSR        - Program Initialisation routine               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
     FMGF940L0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FMGX940L0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(X_)
     FMGX940L1  UF   E           K DISK    INFSR(*PSSR)                                     MD042041
     F                                     COMMIT                                           MD042041
     F                                     PREFIX(X_)                                       MD042041
     F                                     RENAME(MGX940D0:MGX940D1)                        MD042041
     FMGY940L0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     PREFIX(Y_)
     FSDNWRKL1  IF   E           K DISK    INFSR(*PSSR)
     FSDCUSTL7  IF   E           K DISK    INFSR(*PSSR)
     FGLNW94L0  IF   E           K DISK    INFSR(*PSSR)
     F/COPY WNCPYSRC,MGH00088
     FMGOREFL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(E_)
     F                                     RENAME(MGOREFD0:MGOREFL)
     FMGOREFPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     FMGOMSGPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     FMG000940AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
      /COPY OFCPYSRCZ,CGL146_088                                                             CGL146A
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D AMFLD           S              1    DIM(50)
     D AL100           S              1    DIM(100)
     D/COPY WNCPYSRC,MGH00013
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
      *                                                                                     MD042371
     D ArrStrFmt       S             70A   DIM(27)                                          MD042371

      ** File Information Data Structure for MG000940AU
     D SPOOLU          DS
     D   WFileU               83     92
     D   WFNumU              123    124B 0

     D*MULT*****       DS                  OCCURS(2000)                                     BUG23209
     D MULT            DS                  OCCURS(9000)                                     BUG23209
     D  MTAG                   1      5
     D  MFLD                   6     55
     D  CTRC                  56     57
      * Multiple ocurrence data structure

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Externally described DS for currency details

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** Externally described DS for branch details

     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      ** Externally described DS for message management details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
      **  Data Structure for Customer Details.
      *                                                                                    BUG23172A
     D GLACCNT       E DS                  EXTNAME(ACCNTAB)  PREFIX(GL_)                   BUG23172A
      *                                                                                    BUG23172A
      **  Data Structure for Account Details.                                              BUG23172A
      *                                                                                    BUG23172A

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access objects - short data structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access objects - long data structure
      *                                                                                       CER030
      ** External DS for SAR Details                                                          CER030
      *                                                                                       CER030
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER030

     D                 DS
     D   WCrlf                 1      2
     D   WWCr                  1      1
     D   WWLf                  2      2
      /COPY OFCPYSRCZ,CGL146_087                                                             CGL146A

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+



      ** Work variables

     D PCusN           S              6
     D WkCnum          S              7
     D*PAcctCde*       S              4                                                       CGL029
     D PAcctCde        S             10A                                                      CGL029
     D PAcctSeq        S              2
     D*WMsgCount       S              5  0                                                  BUG23209
     D WMsgCount       S              7  0                                                  BUG23209
     D WRundNum        S              6  0
     D WRundChr        S              6
     D WAccount        S             34
     D WPrvCBAL        S             15  0
     D WPrvCDate       S              5  0
     D*WLength**       S              6  0                                                  BUG23557
     D*WLength1*       S              6  0                                                  BUG23557
     D*WLength2*       S              6  0                                                  BUG23557
     D WLength         S              7  0                                                  BUG23557
     D WLength1        S              7  0                                                  BUG23557
     D WLength2        S              7  0                                                  BUG23557
     D WFst            S              1A                                                   BUG25476A
     D WResult         S             70A                                                   BUG25476A
     D WString100      S            100
     D WFldLen         S              3  0
     D WFld61Len       S              3  0
     D WFld65Len       S              3  0
     D***WFld86Len       S              3  0                                                MD042371
     D WFld86Len       S              7  0                                                  MD042371
     D W62Loc          S              4  0
     D WTRNO           S             16
     D WHrdt           S              6
     D WRun            S              1
     D X               S              6  0
     D Q               S              6  0
     D NewPage1        S              1
     D NewPage2        S              1
     D PageClBal       S             15  0
     D PageClDate      S              5  0
     D Subfld1         S              6
     D Subfld2         S              4
     D Subfld3         S              2
     D Subfld4         S              1
     D Subfld5         S             15
     D Subfld6         S              4
     D Subfld7         S             16
     D Subfld8         S             18
     D Subfld9         S             34
     D SavTrno         S             16

     D POptn           S              7A                                                      CER030
     D PSard           S              6A                                                      CER030
     D PNwrk           S              6A                                                      CER030
     D PMsgTyp         S              3A                                                      CER030
     D*PCNum****       S              6  0                                             CER030 CER059
     D PCNum           S              6A                                                      CER059
     D PBrca           S              3A                                                      CER030
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
     D WIdx            S              3S 0                                                    CER030
     D Idx             S              3  0                                                    CER030
     D CER030          S              1A                                                      CER030
     D MGX940          S              5A                                                    BUG22882
     D WDCInd          S              1A                                                    BUG23040
     D WIndLn          S              3S 0                                                  BUG23247
     D PKey1           S             10A                                                   BUG23172A
     D PKyst           S              7A                                                   BUG23172A
     D PRetl           S             10A                                                   BUG23172A
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
     D SValK1          C                   CONST('MT94xFld86Max')                           BUG25529
     D WFld21          S              3S 0                                                  BUG25529
     D SValK2          C                   CONST('MT94xFld86LineOutput')                    BUG26515
     D WFld21a         S              1A                                                    BUG26515
     D P@RTCD          S              7A                                                    BUG26075
     D P@OPTN          S              7A                                                    BUG26075
     D P@BRCA          S              3A                                                    BUG26075
      *                                                                                       CER030
     D                 DS
     D  KNwrk                  1      6
     D  KBrca                  7      9
     D**KCnum***              10     15  0                                                    CSD027
     D  KCnum                 10     15                                                       CSD027
     D  KCcy                  16     18
     D***KAccd**               19     22  0                                                   CGL029
     D***KAcsq**               23     24  0                                                   CGL029
     D***KNaty**               25     25                                                      CGL029
     D***KDstn**               26     36                                                      CGL029
     D***KNetAc*                1     36                                                      CGL029
     D  KAccd                 19     28  0                                                    CGL029
     D  KAcsq                 29     30  0                                                    CGL029
     D  KNaty                 31     31                                                       CGL029
     D  KDstn                 32     42                                                       CGL029
     D  KNetAc                 1     42                                                       CGL029

     D                 DS
     D   WSeqNum               1      6  0
     D   WSeqChr               1      6
     D                 DS
     D   WPageNum              1      5  0
     D   WPageChr              1      5
     D/COPY WNCPYSRC,MGH00014
      *                                                                                       CER030
     D WExtNarr        DS                                                                     CER030
     D  X_MGADI1                                                                              CER030
     D  X_MGADI2                                                                              CER030
     D  X_MGADI3                                                                              CER030
     D  X_MGADI4                                                                              CER030
     D  X_MGADI5                                                                              CER030
     D  X_MGADI6                                                                              CER030
     D/COPY OFCPYSRCZ,CGL146_001                                                              CGL146

     D SValK3          C                   CONST('MT94xAddedSortfor61')                     MD042041
     D WSort61         S              1A                                                    MD042041
     D WMFLD           S             55A                                                    MD042371
     D Wfld64Len       S              7  0                                                  MD042371
     D Wfld86ALen      S              7  0                                                  MD042371
     D Wfld86GLen      S              7  0                                                  MD042371
     D NewPage1A       S              1A                                                    MD042371
     D NewPage2A       S              1A                                                    MD042371
     D CX              S              3S 0                                                  MD042371
     D ChkLen86A       S              1A                                                    MD042371
     D WExtNar         S            100A                                                    MD042371

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      ** Process inputs.

     C                   EXSR      SRProc

      ** End the program

     C                   EXSR      SREnd

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Detail processing                                   *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR

     C                   EVAL      *IN01 = *OFF

     C     *LOVAL        SETLL     MGF940L0                               01
     C                   READ      MGF940L0                               01

     C                   DOW       *IN01 = *OFF
                                                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_089                                                             CGL146A

      ** Clear Work fields
     C                   EXSR      SR_Clear1

      ** Get network details
     C                   EXSR      Get_NwrkDet

      ** Get network account details
     C                   EXSR      Get_NwrkAcDet

     C                   DoU       NewPage1 = *Blank  And
     C                             NewPage1A = *BLANK AND                                   MD042371
     C                             NewPage2A = *BLANK AND                                   MD042371
     C                             NewPage2 = *Blank

      ** Clear Work fields
     C                   EXSR      SR_Clear2

      ** Format message
     C                   EXSR      Format_MT940

      ** ... output to PF/MGOREFPD

     C                   EXSR      SRORef

      ** ... output to PF/MGOMSGPD

     C                   EXSR      SROMsg

      ** Accumulate number of MT940s generated
     C                   Add       1             Count940

     C                   Enddo

      ** Delete MGF940PD record
     C                   Delete    MGF940L0
                                                                                             CGL146A
      /COPY OFCPYSRCZ,CGL146_090                                                             CGL146A

      ** Comit all changes

     C                   COMMIT

     C                   READ      MGF940L0                               01

     C                   Enddo

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_Clear1 - Clear work fields after each MGF940PD read       *
      *                                                               *
      *****************************************************************
     C     SR_Clear1     BEGSR

      *  Clear Multiple Data structure
     C                   Eval      X = 1
     C                   Dow       X <= Q
     C     X             Occur     MULT
     C                   Eval      MTAG = *Blanks
     C                   Eval      MFLD = *Blanks
     C                   Eval      X = X + 1
     C                   Enddo

     C                   Eval      WAccount = *blank
     C                   Eval      WPageNum = *zero
     C                   Eval      NewPage1 = *blank
     C                   Eval      NewPage2 = *blank
     C                   EVAL      NewPage1A = *BLANK                                       MD042371
     C                   EVAL      NewPage2A = *BLANK                                       MD042371
     C/COPY WNCPYSRC,MGH00015

      *  Reset Message length count to reflect allocated length for
      *  header and trailer.
     C                   Eval      WMsgCount = 100

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_Clear2 - Clear work fields before processing continuation *
      *              page                                             *
      *                                                               *
      *****************************************************************
     C     SR_Clear2     BEGSR

      *  Clear Multiple Data structure
     C                   Eval      X = 1
     C                   Dow       X <= Q
     C     X             Occur     MULT
     C                   Eval      MTAG = *Blanks
     C                   Eval      MFLD = *Blanks
     C                   Eval      X = X + 1
     C                   Enddo

     C                   Eval      WPageNum = WPageNum + 1
     C                   Eval      NewPage1 = *blank
     C                   Eval      NewPage2 = *blank
     C                   EVAL      NewPage1A = *BLANK                                       MD042371
     C                   EVAL      NewPage2A = *BLANK                                       MD042371
     C/COPY WNCPYSRC,MGH00016

      *  Reset Message length count to reflect allocated length for
      *  header and trailer.
     C                   Eval      WMsgCount = 100

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAccLen    - Accumulate Message Length                      *
      *                                                               *
      *****************************************************************
     C     SRAccLen      BEGSR
      *
      *  Add 5 for message tag and CRLF
     C                   Eval      WMsgCount = WMsgCount + 5
     C                   Eval      WMsgCount = WMsgCount + 2

      *  Determine fld length
     C                   MoveA     MFLD          AMFLD
     C                   Eval      X = 50

     C                   Dow       X > 0 AND
     C                             AMFLD(X) = *blank
     C                   Eval      X = X - 1
     C                   Enddo

      *  Add field length to message length
     C                   Add       X             WMsgCount

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetFldLen  - Determine Field Length                        *
      *                                                               *
      *****************************************************************
     C     SRDetFldLen   BEGSR

      *  Determine fld length
     C                   Eval      X = 100

     C                   Dow       X > 0 AND
     C                             AL100(X) = *blank
     C                   Eval      X = X - 1
     C                   Enddo

     C                   Z-add     X             WFldLen

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Get_NwrkDet - Get Network Details                            *
      *                                                               *
      *****************************************************************
     C     Get_NwrkDet   BEGSR

      *  Access Network Details to retrieve message settings
     C     MGNWRK        Chain     SDNWRKL1                           02

     C                   If        *IN02 = *ON
     C     *Lock         In        LDA
     C                   Eval      DBASE = 1
     C                   Eval      DBFILE = 'SDNWRKL1'
     C                   Eval      DBKEY = MGNWRK
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Get_NwrkAcDet  Get Network Account Details                   *
      *                 and account details                           *
      *                                                               *
      *****************************************************************
     C     Get_NwrkAcDet BEGSR

      *  Access Network Account Details to retrieve message settings
     C                   Eval      KNwrk  = MGNWRK
     C                   Eval      KBrca  = MGBRCA
     C                   Eval      KCnum  = MGCNUM
     C                   Eval      Kccy   = MGCCY
     C                   Eval      KAccd  = MGACCD
     C                   Eval      KAcsq  = MGACSQ
     C                   Eval      KNaty  = MGNATY
     C                   Eval      KDstn  = MGDSTN

     C     KNwrkAc       Chain     GLNW94L0                           03

     C                   If        *IN03 = *On
     C     *Lock         In        LDA
     C                   Eval      DBASE = 2
     C                   Eval      DBFILE = 'GLNW94L0'
     C                   Eval      DBKEY = KNetAc
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif

     C
     C*  Get SWIFT account code currency
     C                   Call      'AOCURRR0'
     C                   Parm      '*DBERR'      @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C                   Parm      MGCCY         @CCY              3
     C     SDCURR        Parm      SDCURR        DSSDY

      ** Error on call
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     3             DBASE
     C                   MOVEL     MGCCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                     BUG26075
     C                   Call      'AOBRCHR0'                                               BUG26075
     C                   Parm      *BLANKS       P@RTCD                                     BUG26075
     C                   Parm      '*KEY   '     P@OPTN                                     BUG26075
     C                   Parm      MGBRCA        P@BRCA                                     BUG26075
     C     SDBRCH        Parm      SDBRCH        DSFDY                                      BUG26075
                                                                                            BUG26075
      ** Error on call                                                                      BUG26075
     C     P@RTCD        IFNE      *BLANK                                                   BUG26075
     C     *LOCK         IN        LDA                                                      BUG26075
     C                   Z-ADD     4             DBASE                                      BUG26075
     C                   MOVEL     MGBRCA        DBKEY                                      BUG26075
     C                   MOVEL     'SDBRCHPD'    DBFILE                                     BUG26075
     C                   OUT       LDA                                                      BUG26075
     C                   EXSR      *PSSR                                                    BUG26075
     C                   ENDIF                                                              BUG26075
     C/COPY WNCPYSRC,MGH00017

     C                   Movel     MGCNUM        PCusN
     C                   Movel     MGACCD        PAcctCde
     C                   Movel     MGACSQ        PAcctSeq

     C*  Output IBAN, RE or GL account.
     C                   Select
     C                   When      MGIBAN <> *Blank
     C                   Movel     MGIBAN        WAccount
     C                   When      MGACNO <> 0
     C                   Movel     MGACNO        WAccount
     C                   Other
     C                   Eval      WAccount = MGBRCA + PCusN + MGCCY +
     C                                        PAcctCde + PAcctSeq
     C                   Endsl

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Format_MT940 - Format MT940 Message                          *
      *                                                               *
      *****************************************************************
     C     Format_MT940  BEGSR
     C/COPY WNCPYSRC,MGH00018

     C                   IF        CER030 = 'Y' AND EDMCNW = 'Y'                              CER030
      *                                                                                       CER030
     C                   IF        WSort61 = 'Y'                                            MD042041
     C     KNwrkAc       CHAIN     MGX940L1                                                 MD042041
     C                   IF        %FOUND(MGX940L1)                                         MD042041
     C                   EVAL      MGX940 = 'FOUND'                                         MD042041
     C                   ELSE                                                               MD042041
     C                   EVAL      MGX940 = *BLANKS                                         MD042041
     C                   ENDIF                                                              MD042041
     C                   ELSE                                                               MD042041
     C     KNwrkAc       CHAIN     MGX940L0                                                   CER030
      *                                                                                       CER030
     C**********         IF        NOT %FOUND(MGX940L0)                              CER030 BUG22882
     C******LOCK         IN        LDA                                               CER030 BUG22882
     C**********         EVAL      DBASE = 12                                        CER030 BUG22882
     C**********         EVAL      DBFILE = 'MGX940L0'                               CER030 BUG22882
     C**********         EVAL      DBKEY = KNetAc                                    CER030 BUG22882
     C**********         OUT       LDA                                               CER030 BUG22882
     C**********         EXSR      *PSSR                                             CER030 BUG22882
     C**********         ENDIF                                                       CER030 BUG22882
     C                   IF        %FOUND(MGX940L0)                                         BUG22882
     C                   EVAL      MGX940 = 'FOUND'                                         BUG22882
     C                   ELSE                                                               BUG22882
     C                   EVAL      MGX940 = *BLANKS                                         BUG22882
     C                   ENDIF                                                              BUG22882
     C                   ENDIF                                                              MD042041
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
                                                                                            MD024641
     C/COPY OFCPYSRCZ,CGL146_143                                                            MD024641
                                                                                            MD024641
      * Field :20: Transaction number
     C                   Exsr      Format_20
     C/COPY WNCPYSRC,MGH00019
      *                                                                                       CER030
      ** Field :21: Related Reference                                                         CER030
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' AND EDMCNW = 'Y'                              CER030
     C                             AND MGX940 = 'FOUND'                                     BUG22882
     C                   EXSR      Format_21                                                  CER030
     C                   ENDIF                                                                CER030
      *
      * Field :25: Account Identification
     C                   Exsr      Format_25
      *
      * Field :28C: Entry Number and Page Number
     C                   Exsr      Format_28
      *
     C                   Exsr      Format_60
      *
      * Repeating fields :61: Statement Line
      * And :86: Information to A/c Owner
      *
     C                   Exsr      Format_6186
      *
      * Field :62a: Closing Balance  (non-final)
     C                   Exsr      Format_62
      *
      * Do not format the following fields if new page.
      *
     C                   If        NewPage1 <>'Y'
      *
      * Field :64: Closing Available Balance
     C/COPY OFCPYSRCZ,CGL146_142                                                            MD024641
     C                   Exsr      Format_64
     C/COPY OFCPYSRCZ,CGL146_141                                                            MD024641
      *
     C                   IF        NewPage1A <> 'Y'                                         MD042371
      * Repeating field :65: Forward Available Balance
     C/COPY OFCPYSRCZ,CGL146_142                                                            MD024641
     C                   Exsr      Format_65
     C/COPY OFCPYSRCZ,CGL146_141                                                            MD024641
      *
     C                   If        NewPage2 <> 'Y'
      *
      *  Field :86: General Information to Account Owner
     C                   Exsr      Format_86
      *
      *  Field :62: Revisited (record final closing balance)
     C                   IF        NewPage2A <> 'Y'                                         MD042371
     C                   Exsr      Format_F62
      *
     C                   ENDIF                                                              MD042371
     C                   Endif                                                  NewPage2 <> 'Y'
     C                   ENDIF                                                              MD042371
     C                   Endif                                                  NewPage1 <> 'Y'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Format_20 - Format Field 20 Transaction Number                *
      *                                                               *
      *****************************************************************

     C     Format_20     BEGSR

      *  Field :20: Transaction number  = 'GL' + rundate in YYMMDD + sequence
      *
     C                   Eval      Q = 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':20:'
     C                   Eval      WSeqNum = WSeqNum + 1
      /COPY OFCPYSRCZ,CGL146_091                                                             CGL146A
     C                   Eval      SavTrno = 'GL' + WRundChr + WSeqChr
     C                   Eval      MFLD    = SavTrno
     C/COPY WNCPYSRC,MGH00020
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' AND                                           CER030
     C                             EDMCNW = 'Y' AND                                           CER030
     C                             X_MGFREF <> *BLANKS                                        CER030
     C                   EVAL      MFLD = X_MGFREF                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   Eval      CTRC    = WCrLf
      *
     C                   Exsr      SRAccLen                                     Accumulate Msg len
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************                       CER030
      *                                                               *                       CER030
      *  Format_21 - Format Field 21 Related Reference                *                       CER030
      *                                                               *                       CER030
      *  Called by : Main Processing                                  *                       CER030
      *                                                               *                       CER030
      *  Calls : SRAccLen                                             *                       CER030
      *                                                               *                       CER030
      *****************************************************************                       CER030
      *                                                                                       CER030
     C     Format_21     BEGSR                                                                CER030
      *                                                                                       CER030
     C                   EVAL      Q = Q + 1                                                  CER030
     C     Q             OCCUR     MULT                                                       CER030
     C                   EVAL      MTAG = ':21:'                                              CER030
     C**********         EVAL      MFLD = X_MGFD21                                   CER030 BUG25529
      *                                                                                     BUG26515
      ** If format is STRCT, use system value for no. of lines for fld 86                   BUG26515
      *                                                                                     BUG26515
     C                   IF        EDF86F = 'STRCT'                                         BUG26515
     C                   EVAL      %SUBST(X_MGFD21:9:1) = WFld21a                           BUG26515
     C                   ENDIF                                                              BUG26515
      *                                                                                     MD031691
     C                   IF        EDF86F = 'UNSD1'                                         MD031691
     C                   IF        EDNWRK = 'SWIFT'                                         MD031691
     C                   EVAL      %SUBST(X_MGFD21:9:1) = WFld21a                           MD031691
     C                   ENDIF                                                              MD031691
     C                   ENDIF                                                              MD031691
      *                                                                                     BUG26515
     C                   EVAL      MFLD = %TRIM(X_MGFD21) +                                 BUG25529
     C                                    '/' + %CHAR(WFld21)                               BUG25529
     C                   EVAL      CTRC = WCrLf                                               CER030
     C                   EXSR      SRAccLen                                                   CER030
      *                                                                                       CER030
     C                   ENDSR                                                                CER030
      *                                                                                       CER030
      *****************************************************************                       CER030
      /EJECT                                                                                  CER030
      *****************************************************************
      *                                                               *
      * Format_25 - Format Field 25, Account Identification           *
      *                                                               *
      *****************************************************************

     C     Format_25     BEGSR

      *  Field :25: Account Identification = IBAN, RE or GL account
      *
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':25:'
     C                   Eval      MFLD = WAccount
     C/COPY WNCPYSRC,MGH00021
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' AND EDMCNW = 'Y'                              CER030
     C                             AND MGX940 = 'FOUND'                                     BUG22882
     C                   EVAL      MFLD = X_MGFD25                                            CER030
     C                   ELSE                                                              BUG23172A
     C                   CALL      'AOCUSTR0'                                              BUG23172A
     C                   PARM      '*MSG   '     PRtcd                                     BUG23172A
     C                   PARM      '*KEY   '     POptn                                     BUG23172A
     C                   PARM      A8BICN        PKey1                                     BUG23172A
     C                   PARM                    PKyst                                     BUG23172A
     C     SDCUST        PARM      SDCUST        DSSDY                                     BUG23172A
      *                                                                                    BUG23172A
     C                   MOVE      MGCNUM        PCusN                                     BUG23172A
     C                   MOVE      MGACCD        PAcctCde                                  BUG23172A
     C                   MOVE      MGACSQ        PAcctSeq                                  BUG23172A
     C                   SELECT                                                            BUG23172A
                                                                                           BUG23172A
     C                   WHEN      EDACNF = '*IBAN'                                        BUG23172A
     C                   CALL      'AOACCTR0'                                              BUG23172A
     C                   PARM      *BLANKS       PRtcd                                     BUG23172A
     C                   PARM      '*KEY'        POptn                                     BUG23172A
     C                   PARM      *BLANKS       PRetl                                     BUG23172A
     C                   PARM                    PCusN                                     BUG23172A
     C                   PARM      MGCCY         PCcy                                      BUG23172A
     C                   PARM                    PAcctCde                                  BUG23172A
     C                   PARM                    PAcctSeq                                  BUG23172A
     C                   PARM      MGBRCA        PBrca                                     BUG23172A
     C     GLACCNT       PARM      GLACCNT       DSSDY                                     BUG23172A
      *                                                                                    BUG23172A
     C                   IF        MGIBAN <> *BLANKS                                       BUG23172A
     C                   EVAL      MFLD  = MGIBAN                                          BUG23172A
     C                   ELSEIF    MGACNO <> *ZEROS                                        BUG23172A
     C                   MOVE      *BLANKS       X_MGFD25                                  BUG23172A
     C                   MOVEL     MGACNO        X_MGFD25                                  BUG23172A
     C                   ELSE                                                              BUG23172A
     C                   EVAL      MFLD = MGBRCA + PCusN + MGCCY +                         BUG23172A
     C                                      PAcctcde + PAcctSeq                            BUG23172A
     C                   ENDIF                                                             BUG23172A
     C                   WHEN      EDACNF = '*LEDGER'                                      BUG23172A
     C                   EVAL      MFLD   = MGBRCA                                         BUG23172A
     C                                    + PCusN                                          BUG23172A
     C                                    + MGCCY                                          BUG23172A
     C                                    + PAcctcde                                       BUG23172A
     C                                    + PAcctSeq                                       BUG23172A
      *                                                                                    BUG23172A
     C                   WHEN      EDACNF = '*RETAIL'                                      BUG23172A
     C                   IF        MGACNO <> *ZEROS                                        BUG23172A
     C                   MOVE      *BLANKS       MFLD                                      BUG23172A
     C                   MOVEL     MGACNO        MFLD                                      BUG23172A
     C                   ELSE                                                              BUG23172A
     C                   EVAL      MFLD   = MGBRCA + PCusN + MGCCY +                       BUG23172A
     C                                      PAcctcde + PAcctSeq                            BUG23172A
     C                   ENDIF                                                             BUG23172A
      *                                                                                    BUG23172A
     C                   WHEN      EDACNF = '*BLZ'                                          BUG26075
      *                                                                                     BUG26075
     C                   IF        CER030 = 'Y' AND EDMCNW = 'Y'                            BUG26075
      *                                                                                     BUG26075
     C                   IF        MGACNO <> *ZEROS                                         BUG26075
     C                   EVAL      MFLD   = BBBLCD + '/' + %CHAR(MGACNO)                    BUG26075
     C                   ELSE                                                               BUG26075
     C                   EVAL      MFLD   = BBBLCD + '/' + MGBRCA +                         BUG26075
     C                                      PCusN + MGCCY + PAcctcde +                      BUG26075
     C                                      PAcctSeq                                        BUG26075
     C                   ENDIF                                                              BUG26075
      *                                                                                     BUG26075
     C                   ENDIF                                                              BUG26075
      *                                                                                     BUG26075
     C                   ENDSL                                                             BUG23172A
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C/COPY WNCPYSRC,MGH00089
     C                   Eval      CTRC    = WCrLf
      *
     C                   Exsr      SRAccLen                                     Accumulate Msg len
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Format_28 - Format Field 28C Entry and Page Number            *
      *                                                               *
      *****************************************************************

     C     Format_28     BEGSR

      *  Field :28C: Entry Number and Page Number

     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':28C:'
     C                   Movel     MGSTNO        MFLD
     C                   Cat       '/':0         MFLD
     C                   Cat       WPageChr:0    MFLD
     C                   Eval      CTRC    = WCrLf
      *
     C                   Exsr      SRAccLen                                     Accumulate Msg len
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Format_60 - Format Field 60  Opening Balance                  *
      *                                                               *
      *****************************************************************

     C     Format_60     BEGSR

      *  Field :60a: Opening Balance

     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
      *
      *  If page number is = 1, use opening balance and date from MGF940PD (option F)
      *  Else, use closing balance and date from previous page (option M)
      *
     C                   If        WPageNum = 1
     C                   Eval      MTAG = ':60F:'
     C                   Z-add     MGIOBL        ZAMT
     C                   Z-add     MGLSDT        ZMDAY
     C                   Else
     C                   Eval      MTAG = ':60M:'
     C                   Z-add     WPrvCBAL      ZAMT
     C**********         Z-add     WPrvCDate     ZMDAY                                        256990
     C                   Z-add     BJRDNB        ZMDAY                                        256990
      /COPY OFCPYSRCZ,CGL146_092                                                             CGL146A
     C                   Endif
      *
      *  Set this amount as starting point for this page's Closing Balance
     C                   Z-add     ZAMT          PageClBal
      *
      *  Determine DR/CR
     C                   If        ZAMT > *Zeros
     C                   Movel     'D'           MFLD
     C                   Else
     C                   Movel     'C'           MFLD
     C                   Endif
      *
      *  Convert Amount to SWIFT format
      *
     C                   Exsr      Call_ZM0040
      *
      *  Convert Date to YYMMDD  format
      *
     C                   Exsr      Call_ZM0060
      *
      *  Now, format MFLD
      *
     C                   Eval      %subst(MFLD :2:6)   = ZMDATE
     C                   Eval      %subst(MFLD :8:3)   = A6SWCY
     C**********         Eval      %subst(MFLD :11:15) = ZSAMNT
     C                   Eval      %subst(MFLD :11:17) = ZSAMNT                             MD052633
     C                   Eval      CTRC    = WCrLf

     C                   Exsr      SRAccLen                                     Accumulate Msg len
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Format_6186  - Format Repeating fields 61 and 86              *
      *                                                               *
      *****************************************************************

     C     Format_6186   BEGSR

      *    Format only if postings exist in MGX940L0 for this network account

     C                   IF        WSort61 = 'Y'                                            MD042041
     C     KNwrkAc       SETLL     MGX940L1                                                 MD042041
     C                   READ      MGX940L1                               65                MD042041
     C                   ELSE                                                               MD042041
     C     KNwrkAc       Setll     MGX940L0

     C                   READ      MGX940L0                               65
     C                   ENDIF                                                              MD042041

     C                   DOW       *IN65 = *OFF  And
     C                             KNWrk = X_MGNWRK  And
     C                             KBrca = X_MGBRCA  And
     C                             KCnum = X_MGCNUM  And
     C                             KCcy  = X_MGCCY   And
     C                             KAccd = X_MGACCD  And
     C                             KAcsq = X_MGACSQ  And
     C                             KNaty = X_MGNATY  And
     C                             KDstn = X_MGDSTN

      *    Begin Formatting Field :61:

     C                   Eval      WString100 = *Blank
     C                   Eval      Subfld1    = *Blank
     C                   Eval      Subfld2    = *Blank
     C                   Eval      Subfld3    = *Blank
     C                   Eval      Subfld4    = *Blank
     C                   Eval      Subfld5    = *Blank
     C                   Eval      Subfld6    = *Blank
     C                   Eval      Subfld7    = *Blank
     C                   Eval      Subfld8    = *Blank
     C                   Eval      Subfld9    = *Blank

      *    Subfld 1 = Value date in YYMMDD

     C                   Z-add     X_MGVALD      ZMDAY
      *
     C                   Exsr      Call_ZM0060
     C                   Eval      Subfld1 = ZMDATE

      *    Subfld 2 = Posting date in MMDD
     C                   Z-add     X_MGPSTD      ZMDAY
     C                   Exsr      Call_ZM0060
     C                   Move      ZMDATE        Subfld2

      *    Subfld 3 = Debit/Credit Indicator
     C                   Movel     X_MGDRCR      Subfld3

      *    Subfld 4 = Funds Code
     C                   IF        ED0F61 = 'Y'                                               CER030
     C**********                   and CER030 = 'Y'                               BUG25800 BUG25800A
     C**********                   or  CER030 = 'N'                               BUG25800 BUG25800A
     C/COPY WNCPYSRC,MGH00022
     C                   Move      A6SWCY        Subfld4
     C/COPY WNCPYSRC,MGH00023
     C                   ELSE                                                                 CER030
     C                   MOVE      *BLANKS       Subfld4                                      CER030
     C                   ENDIF                                                                CER030

      *    Subfld 5 = Posting Amount
     C                   Z-add     X_MGPSTA      ZAMT
     C                   Exsr      Call_ZM0040
     C                   Movel     ZSAMNT        Subfld5


      *    Subfld 6 = Transaction type identification code
     C                   Movel     X_MGSFD6      Subfld6

      *    Subfld 7 = Reference for the Account Owner
     C                   Movel     X_MGSFD7      Subfld7

      *    Subfld 8 = Account Servicing Institution's Reference
     C                   Movel     X_MGSFD8      Subfld8

      *    Subfld 9 = Supplementary Details
     C                   Movel     X_MGSFD9      Subfld9
     C/COPY WNCPYSRC,MGH00024
      *                                                                                       CER030
     C                   EVAL      WDCInd = *BLANKS                                        BUG23040B
     C**********         IF        CER030 = 'Y' AND EDMCNW = 'Y'                     CER030 BUG24069
     C                   IF        CER030 ='Y'                                              BUG24069
     C                   EVAL      WPos = %SCAN('/IACC/D':WExtNarr)                           CER030
      *                                                                                     BUG23040
     C**********         EVAL      WDCInd = *BLANKS                               BUG23040 BUG23040B
      *                                                                                     BUG23040
     C                   IF        WPos > 0                                                   CER030
      *                                                                                     BUG23247
     C                   EVAL      WIndLn = WPos + 7                                        BUG23247
     C                   EVAL      WDCInd = %SUBST(WExtNarr:WIndLn:1)                       BUG23247
      *                                                                                     BUG23247
     C**********         IF        WDCInd = '0' OR WDCInd = '1' OR                 BUG23247 BUG23742
     C**********                   WDCInd = '2' OR WDCInd = '3'                    BUG23247 BUG23742
     C                   IF        EDMCNW = 'Y'                                             BUG24069
     C**********         IF        (X_MG8635 = *BLANKS AND (                       BUG23742 BUG24278
     C**********                   WDCInd = '0' OR WDCInd = '1' OR                 BUG23742 BUG24278
     C**********                   WDCInd = '2' OR WDCInd = '3')) OR               BUG23742 BUG24278
     C**********                   (X_MG8635 = 'Y' AND WDCInd = '1')               BUG23742 BUG24278
     C                   IF        WDCInd = '0' OR WDCInd = '1' OR                          BUG24278
     C                             WDCInd = '2' OR WDCInd = '3'                             BUG24278
      *                                                                                     BUG24278
     C                   EVAL      Subfld9 = *BLANKS                                          CER030
     C                   EVAL      Subfld9 = %SUBST(WExtNarr:WPos:8)                          CER030
     C**********         EVAL      WDCInd = %SUBST(Subfld9:8:1)                    BUG23040 BUG23247
     C                   ENDIF                                                              BUG23247
      *                                                                                     BUG23247
     C                   ENDIF                                                              BUG24069
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030

      *    Concatenate Fld 61 subfields into 1 long string and determine length

     C                   Movel     Subfld1       Wstring100
     C                   Cat       Subfld2:0     Wstring100
     C                   Cat       Subfld3:0     Wstring100
     C                   Cat       Subfld4:0     Wstring100
     C                   Cat       Subfld5:0     Wstring100
     C                   Cat       Subfld6:0     Wstring100
     C                   Cat       Subfld7:0     Wstring100
     C                   Cat       Subfld8:0     Wstring100

     C                   MoveA     *Blanks       AL100
     C                   MoveA     WString100    AL100
     C                   Exsr      SRDetFldLen

     C*  Add 4 for tag and 2 for CRLF
     C                   Eval      Wfld61Len = WFldLen + 4 + 2

     C*  Field 61 subfield 9
     C                   MoveA     *Blanks       AL100
     C                   MoveA     Subfld9       AL100
     C                   Exsr      SRDetFldLen
     C*  Add 2 for CRLF
     C                   Eval      Wfld61Len = Wfld61Len + WFldLen + 2


      *    Now, count number of characters for fld 86
     C                   IF        CER030 <> 'Y'                                            MD042371

     C                   Eval      WFld86Len = 4

     C                   If        X_MGADI1 <> *blanks
     C                   MoveA     *Blanks       AL100
     C                   MoveA     X_MGADI1      AL100
     C                   Exsr      SRDetFldLen
     C                   Eval      WFld86Len = WFld86Len + WFldLen + 2
     C                   Endif

     C                   If        X_MGADI2 <> *blanks
     C                   MoveA     *Blanks       AL100
     C                   MoveA     X_MGADI2      AL100
     C                   Exsr      SRDetFldLen
     C                   Eval      WFld86Len = WFld86Len + WFldLen + 2
     C                   Endif

     C                   If        X_MGADI3 <> *blanks
     C                   MoveA     *Blanks       AL100
     C                   MoveA     X_MGADI3      AL100
     C                   Exsr      SRDetFldLen
     C                   Eval      WFld86Len = WFld86Len + WFldLen + 2
     C                   Endif

     C                   If        X_MGADI4 <> *blanks
     C                   MoveA     *Blanks       AL100
     C                   MoveA     X_MGADI4      AL100
     C                   Exsr      SRDetFldLen
     C                   Eval      WFld86Len = WFld86Len + WFldLen + 2
     C                   Endif

     C                   If        X_MGADI5 <> *blanks
     C                   MoveA     *Blanks       AL100
     C                   MoveA     X_MGADI5      AL100
     C                   Exsr      SRDetFldLen
     C                   Eval      WFld86Len = WFld86Len + WFldLen + 2
     C                   Endif

     C                   If        X_MGADI6 <> *blanks
     C                   MoveA     *Blanks       AL100
     C                   MoveA     X_MGADI6      AL100
     C                   Exsr      SRDetFldLen
     C                   Eval      WFld86Len = WFld86Len + WFldLen + 2
     C                   Endif
     C                   ELSE                                                               MD042371
     C                   EVAL      ChkLen86A = 'Y'                                          MD042371
     C                   EXSR      SRMTCash                                                 MD042371
     C                   EVAL      WFld86Len = Wfld86ALen                                   MD042371
     C                   ENDIF                                                              MD042371

      *    Leave this posting for next page if:
      *    (1)  Max MT940 Length < £current message count + Fld 62 Closing
      *         Balance approx length + current Fld 61 length +  Current Fld 86 length]
      *    (2)  OR  MT940 Length >= £current message count + current fld 61 length
      *          current Fld 86 length +  Fld 62 Closing Balance Approximate length]
      *         But only fld 64 is left to output (ie., no fld 65 and general fld 86 to
      *         be output) and adding this field will exceed maximum length.
      *    Else place this posting in MULT DS

     C                   Eval      WLength1 = WMsgCount + 32 + WFld61Len +
     C                                       WFld86Len
     C                   Eval      WLength2 = WLength1  + 32

     C     KNwrkAc       Chain     MGY940L0                           62
     C                   Unlock    MGY940L0
     C
     C                   If        ED0MXL < Wlength1 OR
     C                             ED0MXL >=  Wlength1 AND
     C                             ED0MXL <   Wlength2 AND
     C                             MGMIO1 =  *Blank    AND
     C                             *IN62  =  *On

     C                   Eval      NewPage1 = 'Y'
     C                   Leave

     C                   Else
      *
      *   Move Fld 61 into the multiple data structure
      *     First 50 characters
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':61:'
     C                   Movel     WString100    MFLD
     C                   Eval      CTRC    = WCrLf
      *     More than 50 characters
     C                   If        %subst(WString100 : 51 : 50 ) <> *blank
     C                   Movel     *blank        CTRC
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      CTRC    = WCrLf
     C                   Eval      MFLD = %subst(WString100 : 51 : 50)
     C                   Endif
      *     Subfld 9
     C                   If        Subfld9 <> *blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      CTRC    = WCrLf
     C                   Eval      MFLD = Subfld9
     C                   Endif
      *
      *   Move Fld 86 into the multiple data structure
      *
     C/COPY WNCPYSRC,MGH00025
      *                                                                                       CER030
      ** For Non-Multicash                                                                    CER030
      *                                                                                       CER030
     C**********         IF        CER030 <> 'Y' OR EDMCNW <> 'Y'                    CER030 BUG22853
     C                   IF        CER030 <> 'Y'                                            BUG22853
     C                   If        X_MGADI1 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':86:'
     C                   Movel     X_MGADI1      MFLD
     C                   Eval      CTRC    = WCrLf
     C                   If        %subst(X_MGADI1 : 51 : 15 ) <> *blank
     C                   Movel     *blank        CTRC
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      CTRC    = WCrLf
     C                   Eval      MFLD = %subst(X_MGADI1 : 51 : 15)
     C                   Endif
     C                   Endif
      *
     C                   If        X_MGADI2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Movel     X_MGADI2      MFLD
     C                   Eval      CTRC    = WCrLf
     C                   If        %subst(X_MGADI2 : 51 : 15 ) <> *blank
     C                   Movel     *blank        CTRC
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      CTRC    = WCrLf
     C                   Eval      MFLD = %subst(X_MGADI2 : 51 : 15)
     C                   Endif
     C                   Endif

     C                   If        X_MGADI3 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Movel     X_MGADI3      MFLD
     C                   Eval      CTRC    = WCrLf
     C                   If        %subst(X_MGADI3 : 51 : 15 ) <> *blank
     C                   Movel     *blank        CTRC
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      CTRC    = WCrLf
     C                   Eval      MFLD = %subst(X_MGADI3 : 51 : 15)
     C                   Endif
     C                   Endif

     C                   If        X_MGADI4 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Movel     X_MGADI4      MFLD
     C                   Eval      CTRC    = WCrLf
     C                   If        %subst(X_MGADI4 : 51 : 15 ) <> *blank
     C                   Movel     *blank        CTRC
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      CTRC    = WCrLf
     C                   Eval      MFLD = %subst(X_MGADI4 : 51 : 15)
     C                   Endif
     C                   Endif

     C                   If        X_MGADI5 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Movel     X_MGADI5      MFLD
     C                   Eval      CTRC    = WCrLf
     C                   If        %subst(X_MGADI5 : 51 : 15 ) <> *blank
     C                   Movel     *blank        CTRC
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      CTRC    = WCrLf
     C                   Eval      MFLD = %subst(X_MGADI5 : 51 : 15)
     C                   Endif
     C                   Endif

     C                   If        X_MGADI6 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Movel     X_MGADI6      MFLD
     C                   Eval      CTRC    = WCrLf
     C                   If        %subst(X_MGADI6 : 51 : 15 ) <> *blank
     C                   Movel     *blank        CTRC
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      CTRC    = WCrLf
     C                   Eval      MFLD = %subst(X_MGADI6 : 51 : 15)
     C                   Endif
     C                   Endif
     C/COPY WNCPYSRC,MGH00026
      *                                                                                       CER030
     C**********         ELSEIF    CER030 = 'Y' AND EDMCNW = 'Y'                     CER030 BUG22853
     C                   ELSEIF    CER030 = 'Y'                                             BUG22853
     C                   EVAL      ChkLen86A = 'N'                                          MD042371
     C                   EXSR      SRMTCash                                                   CER030
     C                   ENDIF                                                                CER030
      *
      *  Update Message Length
      *
     C                   Eval      WMsgCount = WMsgCount + WFld61Len + WFld86Len
      *
      *  Accumulate this page's Closing Balance
      *
     C                   If        %subst(X_MGDRCR : 1 : 1) = 'D'
     C                   Eval      PageClBal = PageClBal + X_MGPSTA
     C                   Else
     C                   Eval      PageClBal = PageClBal - X_MGPSTA
     C                   Endif
      *
      *  Record the value date used   for use in :62a:
     C                   Z-add     X_MGVALD      PageClDate
      *
      *  Delete record from MGX940PD
      *
     C                   IF        WSort61 = 'Y'                                            MD042041
     C                   DELETE    MGX940L1                                                 MD042041
     C                   ELSE                                                               MD042041
     C                   Delete    MGX940L0
     C                   ENDIF                                                              MD042041
      *
     C                   Endif

     C                   IF        WSort61 = 'Y'                                            MD042041
     C                   READ      MGX940L1                               65                MD042041
     C                   ELSE                                                               MD042041
     C                   READ      MGX940L0                               65
     C                   ENDIF                                                              MD042041

     C                   Enddo

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Format_62 - Format Field 62a Closing Balance                  *
      *                                                               *
      *****************************************************************

     C     Format_62     BEGSR

      *  Field :62a: Closing Balance  (non-final)

     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
      *
      *  At this stage, assume this is not the final page.  This will be
      *  revisited once the final field 86 is output.
      *
     C                   Eval      MTAG = ':62M:'
     C                   Z-add     PageClBal     ZAMT
     C**********         Z-add     PageClDate    ZMDAY                                        256990
     C                   Z-add     BJRDNB        ZMDAY                                        256990
      /COPY OFCPYSRCZ,CGL146_092                                                             CGL146A
      *
      *  Record occurence number for later update if last page
      *
     C                   Z-add     Q             W62Loc
      *
      *  Convert Amount to SWIFT format
      *
     C                   Exsr      Call_ZM0040
      *
      *  Convert Date to YYMMDD  format
      *
     C                   Exsr      Call_ZM0060
      *
      *  Now, format MFLD
      *
     C                   If        PageClBal > *Zeros
     C                   Movel     'D'           MFLD
     C                   Else
     C                   Movel     'C'           MFLD
     C                   Endif

     C                   Eval      %subst(MFLD :2:6)   = ZMDATE
     C                   Eval      %subst(MFLD :8:3)   = A6SWCY
     C**********         Eval      %subst(MFLD :11:15) = ZSAMNT                             MD052633
     C                   Eval      %subst(MFLD :11:17) = ZSAMNT                             MD052633
     C                   Eval      CTRC    = WCrLf

     C                   Z-add     PageClBal     WPrvCBAL
     C                   Z-add     ZMDAY         WPrvCDate

     C                   Exsr      SRAccLen                                     Accumulate Msg len
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Format_64 - Format Field 64  Closing Available Balance        *
      *                                                               *
      *****************************************************************

     C     Format_64     BEGSR

      *  Field :64: Closing Available Balance
      *
     C**********         Eval      Q = Q + 1                                                MD042371
     C*****Q****         Occur     MULT                                                     MD042371
      *
     C**********         Eval      MTAG = ':64:'                                            MD042371
     C                   EVAL      WMFLD = *BLANKS                                          MD042371
     C                   Z-add     MGCLBL        ZAMT
     C                   Z-add     BJRDNB        ZMDAY
      /COPY OFCPYSRCZ,CGL146_092                                                             CGL146A
      *
      *  Convert Amount to SWIFT format
      *
     C                   Exsr      Call_ZM0040
      *
      *  Convert Date to YYMMDD  format
      *
     C                   Exsr      Call_ZM0060
      *
      *  Now, format MFLD
      *
     C                   If        MGCLBL > *Zeros
     C**********         Movel     'D'           MFLD                                       MD042371
     C                   MOVEL     'D'           WMFLD                                      MD042371
     C                   Else
     C**********         Movel     'C'           MFLD                                       MD042371
     C                   MOVEL     'C'           WMFLD                                      MD042371
     C                   Endif

     C**********         Eval      %subst(MFLD :2:6)   = ZMDATE                             MD042371
     C**********         Eval      %subst(MFLD :8:3)   = A6SWCY                             MD042371
     C**********         Eval      %subst(MFLD :11:15) = ZSAMNT                             MD042371
     C                   EVAL      %subst(WMFLD :2:6)   = ZMDATE                            MD042371
     C                   EVAL      %subst(WMFLD :8:3)   = A6SWCY                            MD042371
     C**********         EVAL      %subst(WMFLD :11:15) = ZSAMNT                   MD042371 MD052633
     C                   EVAL      %subst(WMFLD :11:17) = ZSAMNT                            MD052633
     C**********         Eval      CTRC    = WCrLf                                          MD042371

     C**********         Exsr      SRAccLen                                                 MD042371
     C                   MOVEA     *BLANKS       AL100                                      MD042371
     C                   MOVEA     WMFLD         AL100                                      MD042371
     C                   EXSR      SRDetFldLen                                              MD042371
     C                   EVAL      Wfld64Len = WFldLen + 4 + 2                              MD042371
     C                   EVAL      WLength = WMsgCount + WFld64Len                          MD042371
     C                   If        ED0MXL < Wlength                                         MD042371
     C                   EVAL      NewPage1A = 'Y'                                          MD042371
     C                   LEAVESR                                                            MD042371
     C                   ELSE                                                               MD042371
     C                   EVAL      Q = Q + 1                                                MD042371
     C     Q             OCCUR     MULT                                                     MD042371
     C                   EVAL      MTAG = ':64:'                                            MD042371
     C                   EVAL      MFLD = WMFLD                                             MD042371
     C                   Eval      CTRC    = WCrLf                                          MD042371
     C                   EVAL      WMsgCount = WMsgCount + WFld64Len                        MD042371
     C                   ENDIF                                                              MD042371
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Format_65  - Format Repeating field 65                        *
      *                                                               *
      *****************************************************************

     C     Format_65     BEGSR

      *    Format only if records exist in MGY940L0 for this network account

     C     KNwrkAc       Setll     MGY940L0

     C                   READ      MGY940L0                               65

     C                   DOW       *IN65 = *OFF  And
     C                             KNWrk = Y_MGNWRK  And
     C                             KBrca = Y_MGBRCA  And
     C                             KCnum = Y_MGCNUM  And
     C                             KCcy  = Y_MGCCY   And
     C                             KAccd = Y_MGACCD  And
     C                             KAcsq = Y_MGACSQ  And
     C                             KNaty = Y_MGNATY  And
     C                             KDstn = Y_MGDSTN

      *    Begin Formatting Field :65:
     C                   Eval      WString100 = *Blank
      *
     C                   Z-add     Y_MGFAMT      ZAMT
     C                   Z-add     Y_MGFVDT      ZMDAY
      *
      *  Convert Amount to SWIFT format
      *
     C                   Exsr      Call_ZM0040
      *
      *  Convert Date to YYMMDD  format
      *
     C                   Exsr      Call_ZM0060

      *  Now, format MFLD
      *
     C                   If        Y_MGFAMT > *Zeros
     C                   Movel     'D'           WString100
     C                   Else
     C                   Movel     'C'           WString100
     C                   Endif

     C                   Eval      %subst(WString100 :2:6)   = ZMDATE
     C                   Eval      %subst(WString100 :8:3)   = A6SWCY
     C**********         Eval      %subst(WString100 :11:15) = ZSAMNT                       MD052633
     C                   Eval      %subst(WString100 :11:17) = ZSAMNT                       MD052633
     C                   Exsr      SRDetFldLen
     C*  Add 4 for tag and 2 for CRLF
     C                   Eval      Wfld65Len = WFldLen + 4 + 2

      *    Leave this record for next page if:
      *         Max MT940 Length < £current message count + current field 64 length)
      *    Else place this record in MULT DS

     C                   Eval      WLength = WMsgCount + WFld65Len
     C
     C                   If        ED0MXL < Wlength

     C                   Eval      NewPage2 = 'Y'
     C                   Leave

     C                   Else
      *
      *   Move Fld 65 into the multiple data structure
      *
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
      *
     C                   Eval      MTAG = ':65:'
     C                   Movel     WString100    MFLD
     C                   Eval      CTRC    = WCrLf

      *   Accumulate Message Length
     C                   Add       WFld65Len     WMsgCount

      *  Delete record from MGX940PD
     C                   Delete    MGY940L0

     C                   Endif

     C                   READ      MGY940L0                               65

     C                   Enddo

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Format_86 - Format 86 - General Info to Account Owner         *
      *                                                               *
      *****************************************************************

     C     Format_86     BEGSR

      *  Field :86: General Information to Account Owner
      ** Check for length                                                                   MD042371
      *                                                                                     MD042371
     C                   EVAL      WFld86GLen = 0                                           MD042371
     C                   IF        MGMIO1   <> *blanks                                      MD042371
     C                   EVAL      WFld86GLen = 4                                           MD042371
     C                   MOVEA     *Blanks       AL100                                      MD042371
     C                   MOVEA     MGMIO1        AL100                                      MD042371
     C                   EXSR      SRDetFldLen                                              MD042371
     C                   EVAL      WFld86GLen = WFld86GLen + WFldLen + 2                    MD042371
     C                   ENDIF                                                              MD042371
     C                   IF        MGMIO2   <> *blanks                                      MD042371
     C                   MOVEA     *Blanks       AL100                                      MD042371
     C                   MOVEA     MGMIO2        AL100                                      MD042371
     C                   EXSR      SRDetFldLen                                              MD042371
     C                   EVAL      WFld86GLen = WFld86GLen + WFldLen + 2                    MD042371
     C                   ENDIF                                                              MD042371
     C                   IF        MGMIO3   <> *blanks                                      MD042371
     C                   MOVEA     *Blanks       AL100                                      MD042371
     C                   MOVEA     MGMIO3        AL100                                      MD042371
     C                   EXSR      SRDetFldLen                                              MD042371
     C                   EVAL      WFld86GLen = WFld86GLen + WFldLen + 2                    MD042371
     C                   ENDIF                                                              MD042371
     C                   IF        MGMIO4   <> *blanks                                      MD042371
     C                   MOVEA     *Blanks       AL100                                      MD042371
     C                   MOVEA     MGMIO4        AL100                                      MD042371
     C                   EXSR      SRDetFldLen                                              MD042371
     C                   EVAL      WFld86GLen = WFld86GLen + WFldLen + 2                    MD042371
     C                   ENDIF                                                              MD042371
     C                   IF        MGMIO5   <> *blanks                                      MD042371
     C                   MOVEA     *Blanks       AL100                                      MD042371
     C                   MOVEA     MGMIO5        AL100                                      MD042371
     C                   EXSR      SRDetFldLen                                              MD042371
     C                   EVAL      WFld86GLen = WFld86GLen + WFldLen + 2                    MD042371
     C                   ENDIF                                                              MD042371
     C                   IF        MGMIO6   <> *blanks                                      MD042371
     C                   MOVEA     *Blanks       AL100                                      MD042371
     C                   MOVEA     MGMIO6        AL100                                      MD042371
     C                   EXSR      SRDetFldLen                                              MD042371
     C                   EVAL      WFld86GLen = WFld86GLen + WFldLen + 2                    MD042371
     C                   ENDIF                                                              MD042371
     C                   EVAL      WLength = WMsgCount + WFld86GLen                         MD042371
     C                   IF        ED0MXL < WLength                                         MD042371
     C                   EVAL      NewPage2A = 'Y'                                          MD042371
     C                   ELSE                                                               MD042371

     C                   If        MGMIO1 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':86:'
     C                   Movel     MGMIO1        MFLD
     C                   Eval      CTRC    = WCrLf
     C                   If        %subst(MGMIO1 : 51 : 15 ) <> *blank
     C                   Movel     *blank        CTRC
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      CTRC    = WCrLf
     C                   Eval      MFLD = %subst(MGMIO1 : 51 : 15)
     C                   Endif
     C                   Endif
      *
     C                   If        MGMIO2 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Movel     MGMIO2        MFLD
     C                   Eval      CTRC    = WCrLf
     C                   If        %subst(MGMIO2 : 51 : 15 ) <> *blank
     C                   Movel     *blank        CTRC
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      CTRC    = WCrLf
     C                   Eval      MFLD = %subst(MGMIO2 : 51 : 15)
     C                   Endif
     C                   Endif

     C                   If        MGMIO3 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Movel     MGMIO3        MFLD
     C                   Eval      CTRC    = WCrLf
     C                   If        %subst(MGMIO3 : 51 : 15 ) <> *blank
     C                   Movel     *blank        CTRC
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      CTRC    = WCrLf
     C                   Eval      MFLD = %subst(MGMIO3 : 51 : 15)
     C                   Endif
     C                   Endif

     C                   If        MGMIO4 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Movel     MGMIO4        MFLD
     C                   Eval      CTRC    = WCrLf
     C                   If        %subst(MGMIO4 : 51 : 15 ) <> *blank
     C                   Movel     *blank        CTRC
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      CTRC    = WCrLf
     C                   Eval      MFLD = %subst(MGMIO4 : 51 : 15)
     C                   Endif
     C                   Endif

     C                   If        MGMIO5 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Movel     MGMIO5        MFLD
     C                   Eval      CTRC    = WCrLf
     C                   If        %subst(MGMIO5 : 51 : 15 ) <> *blank
     C                   Movel     *blank        CTRC
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      CTRC    = WCrLf
     C                   Eval      MFLD = %subst(MGMIO5 : 51 : 15)
     C                   Endif
     C                   Endif

     C                   If        MGMIO6 <> *Blank
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Movel     MGMIO6        MFLD
     C                   Eval      CTRC    = WCrLf
     C                   If        %subst(MGMIO6 : 51 : 15 ) <> *blank
     C                   Eval      CTRC    = *blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Move      WCrlf         CTRC
     C                   Eval      MFLD = %subst(MGMIO6 : 51 : 15)
     C                   Endif
     C                   Endif
     C
     C                   EVAL      WMsgCount = WMsgCount + WFld86GLen                       MD042371
     C                   ENDIF                                                              MD042371
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Format_F62 - Format Final Field 62                            *
      *                                                               *
      *****************************************************************

     C     Format_F62    BEGSR

      *  Field :62: Revisited (record final closing balance)

     C     W62Loc        Occur     MULT
      *
     C                   Eval      MTAG = ':62F:'
     C                   Z-add     MGFCBL        ZAMT
     C                   Z-add     BJRDNB        ZMDAY
      /COPY OFCPYSRCZ,CGL146_092                                                             CGL146A
      *
      *  Convert Amount to SWIFT format
      *
     C                   Exsr      Call_ZM0040
      *
      *  Convert Date to YYMMDD  format
      *
     C                   Exsr      Call_ZM0060
      *
      *  Now, format MFLD
      *
     C                   If        MGFCBL > *Zeros
     C                   Movel     'D'           MFLD
     C                   Else
     C                   Movel     'C'           MFLD
     C                   Endif

     C                   Eval      %subst(MFLD :2:6)   = ZMDATE
     C                   Eval      %subst(MFLD :8:3)   = A6SWCY
     C**********         Eval      %subst(MFLD :11:15) = ZSAMNT                             MD052633
     C                   Eval      %subst(MFLD :11:17) = ZSAMNT                             MD052633
     C                   Eval      CTRC    = WCrLf

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROref - Output Record to MGOREFPD                            *
      *                                                               *
      *****************************************************************

     C     SROref        BEGSR

      ** Initialise fields on PF/MGOREFPD

     C                   CLEAR                   MGOREFD0
     C
     C                   Eval      SYTM = *Blanks
     C                   Eval      MODI = 'GL'
     C
     C                   Eval      TRNO = SavTRNO
     C                   Eval      TRNF = *Blanks
     C                   Eval      TRNM = *Blanks
     C                   Eval      MTRN = *Blanks
     C                   Eval      TNTP = *Blanks
     C                   Eval      SBTP = *Blanks
     C                   Eval      EVTP = *Blanks
     C/COPY WNCPYSRC,MGH00027
     C                   IF        EDMCNW = 'Y'                                             BUG22687
     C                   EVAL      NWRK = 'MTCASH'                                          BUG22687
     C                   ELSE                                                               BUG22687
     C                   Eval      NWRK = MGNWRK
     C/COPY WNCPYSRC,MGH00028
     C                   ENDIF                                                              BUG22687
     C/COPY OFCPYSRCZ,CGL146_057                                                              CGL146

     C**********         Call      'AOBRCHR0'                                               BUG26075
     C**********         Parm      *blanks       P@RTCD            7                        BUG26075
     C**********         Parm      '*KEY   '     P@OPTN            7                        BUG26075
     C**********         Parm      MGBRCA        P@BRCA            3                        BUG26075
     C*****SDBRCH        Parm      SDBRCH        DSFDY                                      BUG26075
      **********                                                                            BUG26075
      ***Error*on call                                                                      BUG26075
     C*****P@RTCD        IFNE      *BLANK                                                   BUG26075
     C******LOCK         IN        LDA                                                      BUG26075
     C**********         Z-ADD     4             DBASE                                      BUG26075
     C**********         MOVEL     MGBRCA        DBKEY                                      BUG26075
     C**********         MOVEL     'SDBRCHPD'    DBFILE                                     BUG26075
     C**********         OUT       LDA                                                      BUG26075
     C**********         EXSR      *PSSR                                                    BUG26075
     C**********         ENDIF                                                              BUG26075
     C/COPY WNCPYSRC,MGH00029
     C                   Move      A8BICN        SECN

      **    Default Customer no of destination.
      **    If the destination is a customer number, load the destination,
      **    Otherwide, the customer number of the account.

     C**********         Eval      WkCnum = %Subst(MGDSTN:1:6) + '0'                          CSD027
     C**********         TESTN                   WkCnum               99                      CSD027
     C**********         IF        %Subst(MGDSTN:7:4) = *BLANKS                               CSD027
     C**********                   AND *IN99                                                  CSD027
     C                   CALLB     'AOCUSTR0'                                                 CSD027
     C                   PARM      *BLANKS       P@RTCD                                       CSD027
     C                   PARM      '*KEY'        P@OPTN                                       CSD027
     C                   PARM      MGDSTN        P@KEY1                                       CSD027
     C                   PARM                    P@KYST                                       CSD027
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD027
     C                   IF        P@RTCD = *BLANKS                                           CSD027
     C                             AND P@KYST = '*CNUM  '                                     CSD027
     C                   Movel     MGDSTN        DECN
     C                   Else
     C                   eval      DECN    =     MGCNUM
     C                   endif

      **    Default Destination.
     C                   Eval      NWDS    =     MGDSTN

     C                   Eval      NWSN = A8BTID

      *   If the destination is a SWIFT address, retrieves the customer number of
      *   destination.
     C                   IF        %Subst(MGDSTN : 7 : 4) <> *Blanks

     C                   MOVEL     MGDSTN        WSwiftId         12
     C     WSwiftId      Chain     @CUSTGE                            44
     C*   Try removing branch 'XXX' if fails the first time.
     C                   If        *IN44 = *ON And
     C                             %Subst(WSwiftId : 9 : 3) = 'XXX'
     C                   Eval      %Subst(WSwiftId : 9 : 3) = '   '
     C     WSwiftId      Chain     @CUSTGE                            44
     C                   Endif
     C                   If        *IN44 = *OFF
     C                   Movel     BBCUST        DECN
     C                   ENDIF
     C
     C*
      *   If the destination is a customer number, retrieve the SWIFT address of dest.
     C
     C                   ELSE
     C
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY'        P@OPTN            7
     C                   PARM      MGDSTN        P@KEY1           10
     C                   PARM                    P@KYST            7
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   If        P@RTCD = *BLANKS
     C                   Movel     BBCUST        DECN
     C                   If        BBCSID <> *BLANKS
     C                   Movel     BBCSID        NWDS
     C                   Endif
     C                   Endif
     C                   Endif
     C
     C                   Movel     *Blanks       NWBN
     C                   Movel     '940'         MTPY

     C                   If        A6DPRU = 'Y'
     C                   Eval      MPRY = 'U'
     C                   Else
     C                   Eval      MPRY = 'N'
     C                   End

     C                   If        ED0DMS = 'C'
     C                   Movel     '1'           MGSG
     C                   Movel     'CRTD'        MGST
     C                   Else
     C                   Movel     '2'           MGSG
     C                   Movel     'RSND'        MGST
     C                   Endif

     C                   Movel     *blanks       LSCC
     C                   Movel     *blanks       F57U
     C                   Movel     *blanks       PTST
     C                   Movel     *blanks       CARQ
     C                   Movel     *blanks       MPDE
     C                   Movel     WHrdt         HRDT
     C                   Movel     WRundNum      MGDE
     C                   Z-add     N40LST        MGTM
     C                   Move      BJMRDT        LADT
     C                   Time                    LATM

     C                   If        MGST = 'RSND'
     C                   Move      BJMRDT        RELD
     C                   Eval      LATM = MGTM
     C                   Else
     C                   Move      *Blanks       RELD
     C                   Eval      RELT = 0
     C                   End

     C                   Eval      RUSR = *blanks
     C                   Eval      RWSN = *blanks

     C                   Movel     *blanks       AMTX
     C                   Movel     *blanks       AMTS
     C                   Movel     *blanks       SVDT
     C                   Move      MGCCY         CCY
     C                   Z-add     0             NSNO

     C                   Select
      *                                                                                       222299
      ** Don't use IBAN - Internal IUS pgms not designed to use.                              222299
      ** Revert to Re AcNo                                                                    222299
      *                                                                                       222299
     C**********         When      MGIBAN <> *Blank                                           222299
     C**********         Movel     MGIBAN        SACN                                         222299
     C**********         Movel     *blanks       AORR                                         222299
     C                   When      MGACNO <> 0
     C                   Movel     MGACNO        SACN
     C                   Movel     'R'           AORR
     C                   Other
     C**********         Eval      SACN = %SUBST(WAccount:4:15)                               CGL029
     C                   Eval      SACN = %SUBST(WAccount:4:21)                               CGL029
     C                   Movel     'A'           AORR
     C                   Endsl

     C                   Move      *blanks       DESI
     C                   Move      MGBRCA        BRCA
     C                   Move      *blanks       OTHB
     C                   Move      *blanks       RCBR
     C                   Move      *blanks       OTHT
     C                   Move      *blanks       NETI

     C                   If        A6NDWR = 'Y'
     C                   If        A6DNOR = 'Y'
     C                   Eval      DELC = '3'
     C                   Else
     C                   Eval      DELC = '1'
     C                   Endif
      *
     C                   Else
     C                   If        A6DNOR = 'Y'
     C                   Eval      DELC = '2'
     C                   Else
     C                   Eval      DELC = *Blanks
     C                   Endif
     C                   Endif
      *
      ** Ensure message priority and delivery notification valid
      ** MPRY = 'U' DELC = '1' or '3',
      ** MPRY = 'N' DELC = ' ' or '2'.
     C     MPRY          IFEQ      'U'
     C     DELC          ANDEQ     ' '
     C     MPRY          OREQ      'U'
     C     DELC          ANDEQ     '2'
     C                   MOVEL     '1'           DELC
     C                   END
      *
     C     MPRY          IFEQ      'N'
     C     DELC          ANDEQ     '1'
     C     MPRY          OREQ      'N'
     C     DELC          ANDEQ     '3'
     C                   MOVEL     '2'           DELC
     C                   END

     C                   Move      *blanks       DYST
     C                   Move      *blanks       RSID
     C                   Move      *blanks       MSE1
     C                   Move      *blanks       ELIN
     C                   Move      *blanks       SSAC
     C                   Move      *blanks       MIR
     C                   Eval      TSKS = 'Y'
     C                   Eval      TSKY = *Blanks
     C                   Eval      TSEQ = *Zeros
     C                   Eval      CFPF = *Blanks
     C                   Eval      PT210 = *Zeros
     C                   Eval      AVDT = *Zeros
     C                   Eval      ASEQ = *Zeros
     C                   Eval      TODY = *Blanks
      *
      ** Set-up Message Generation Century flag
      *
     C                   Movel     MGDE          YY                2 0
     C                   If        YY < 72
     C                   Eval      CIND = '2'
     C                   Else
     C                   Eval      CIND = '1'
     C                   Endif
     C                   Eval      CINDV = *Blanks
     C                   Move      *Blanks       CLSS              1

     C                   Write     MGOREFD0                             41

     C                   If        *IN41 = *ON
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'Write  '     DBKEY
     C                   MOVEL     'MGOREFPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROMsg - Output to PF/MGOMSGPD                               *
      *                                                               *
      *****************************************************************
     C     SROMsg        BEGSR

      ** Process Multiple Occurence Data Structure

     C                   Movel     *blanks       PTDL
     C                   Movel     SavTrno       TRNO
     C                   EVAL      X = 1
      *
      **  Write multiple occurrence data structure to MGOMSGPD
     C                   Z-ADD     1             X
     C     X             OCCUR     MULT
      *
     C                   Dow       X <= Q
     C                   Write     MGOMSGD0                             42
      *
      **  Error on write to PF/MGOMSGPD (message data file)
      *
     C                   If        *IN42
     C     *LOCK         IN        LDA
     C                   Z-Add     6             DBASE
     C                   Movel     '       '     DBKEY
     C                   Movel     'MGOMSGPD'    DBFILE
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   Eval      X = X + 1
     C     X             OCCUR     MULT
     C                   Enddo

     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Call_ZM0040 - Convert amount o SWIFT format                   *
      *                                                               *
      *****************************************************************

     C     Call_ZM0040   BEGSR
      *
      *  Convert Amount to SWIFT format
      *
     C                   Movel     MGCCY         ZCCY
     C**********         CALL      'ZM0040'                             15                  MD052633
     C                   CALL      'ZM0041'                             15                  MD052633
     C**********         PARM                    ZAMT             13 0                      MD052633
     C                   PARM                    ZAMT             15 0                      MD052633
     C                   PARM                    ZCCY              3
     C**********         PARM                    ZSAMNT           15                        MD052633
     C                   PARM                    ZSAMNT           17                        MD052633
     C                   PARM                    ZSCCY             3
     C                   PARM                    ZERR              1
     C                   PARM                    ZSWDPC            1                          222373
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     7             DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0040'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Call_ZM0060 - Convert date to YYMMDD format                   *
      *                                                               *
      *****************************************************************

     C     Call_ZM0060   BEGSR

     C                   CALL      'ZM0060'                             15
     C                   PARM                    ZMDAY             5 0
     C                   PARM                    ZMDATE            6
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     8             DBASE
     C                   MOVEL     '       '     DBKEY
     C                   MOVEL     'ZM0060'      DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CER030
      *                                                               *                       CER030
      *  SRMTCash - Process Extended Narratives for Multicash         *                       CER030
      *                                                               *                       CER030
      *  Called by: Format_6186                                       *                       CER030
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
     C**********                   OR (%SUBST(Subfld9:1:7) = '/IACC/D'            BUG23040A BUG23742
     C**********                       AND  EDF86F = 'STRCT')                     BUG23040A BUG23742
     C**********                   OR ((X_MG8635 = *BLANKS AND (                   BUG23742 BUG24278
     C**********                   WDCInd = '0' OR WDCInd = '1' OR                 BUG23742 BUG24278
     C**********                   WDCInd = '2' OR WDCInd = '3')) OR               BUG23742 BUG24278
     C**********                   (X_MG8635 = 'Y' AND WDCInd = '1')               BUG23742 BUG24278
     C                             OR ((WDCInd = '0' OR WDCInd = '1' OR                     BUG24278
     C                             WDCInd = '2' OR WDCInd = '3')                            BUG24278
     C                             AND  EDF86F = 'STRCT')                                   BUG23742
      *                                                                                     BUG23040
     C                   EVAL      WPos = %SCAN('/IACC/D':WExtNarr)                         BUG23040
      *                                                                                     BUG23040
     C                   IF        WPos > 0                                                 BUG23040
      *                                                                                     BUG23247
     C                   EVAL      WIndLn = WPos + 7                                        BUG23247
     C                   EVAL      WDCInd = %SUBST(WExtNarr:WIndLn:1)                       BUG23247
      *                                                                                     BUG23247
     C**********         IF        WDCInd = '0' OR WDCInd = '1' OR                BUG23247 BUG23280B
     C**********                   WDCInd = '2' OR WDCInd = '3'                   BUG23247 BUG23280B
     C**********         EVAL      %SUBST(WExtNarr:WPos:8) = *BLANKS              BUG23040 BUG23280B
     C**********         ENDIF                                                    BUG23247 BUG23280B
      *                                                                                     BUG23247
     C                   ENDIF                                                              BUG23040
      *                                                                                     BUG23040
     C                   EVAL      PDCInd = *BLANKS                                        BUG23040B
     C**********         IF        EDMCNW = 'Y'                                   BUG23040B BUG24069
     C                   EVAL      PDCInd = WDCInd                                          BUG23040
     C**********         ENDIF                                                    BUG23040B BUG24069
     C**********         EVAL      X_MGADI1 = %TRIM(X_MGADI1)                    BUG23040A BUG23280B
     C**********         EVAL      X_MGADI2 = %TRIM(X_MGADI2)                    BUG23040A BUG23280B
     C**********         EVAL      X_MGADI3 = %TRIM(X_MGADI3)                    BUG23040A BUG23280B
     C**********         EVAL      X_MGADI4 = %TRIM(X_MGADI4)                    BUG23040A BUG23280B
     C**********         EVAL      X_MGADI5 = %TRIM(X_MGADI5)                    BUG23040A BUG23280B
     C**********         EVAL      X_MGADI6 = %TRIM(X_MGADI6)                    BUG23040A BUG23280B
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
     C                   EVAL      PArrExt = *BLANKS                                        BUG23742
     C                   EVAL      ArrExtNar = *BLANKS                                     BUG23280D
      *                                                                                    BUG23280D
     C                   IF        X_MG8633 <> *BLANKS                                     BUG23280D
     C                   EVAL      PFormL1 = %TRIM(X_MG8633)                               BUG23280D
     C                   ELSE                                                              BUG23280D
     C                   EVAL      PFormL1 = *BLANKS                                       BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
      ** If 22 * 35 structure is input call MG001901                                        BUG23742
      *                                                                                     BUG23742
     C                   IF        X_MG8635 ='Y'                                            BUG23742
      *                                                                                     BUG23742
     C                   EVAL      PArrExt(1) = X_MGADI1                                    BUG23742
     C                   EVAL      PArrExt(2) = X_MGADI2                                    BUG23742
     C                   EVAL      PArrExt(3) = X_MGADI3                                    BUG23742
     C                   EVAL      PArrExt(4) = X_MGADI4                                    BUG23742
     C                   EVAL      PArrExt(5) = X_MGADI5                                    BUG23742
     C                   EVAL      PArrExt(6) = X_MGADI6                                    BUG23742
     C                   EVAL      PArrExt(7) = X_MG8621                                    BUG23742
     C                   EVAL      PArrExt(8) = X_MG8622                                    BUG23742
     C                   EVAL      PArrExt(9) = X_MG8623                                    BUG23742
     C                   EVAL      PArrExt(10) = X_MG8624                                   BUG23742
     C                   EVAL      PArrExt(11) = X_MG8625                                   BUG23742
     C                   EVAL      PArrExt(12) = X_MG8626                                   BUG23742
     C                   EVAL      PArrExt(13) = X_MG8627                                   BUG23742
     C                   EVAL      PArrExt(14) = X_MG8628                                   BUG23742
     C                   EVAL      PArrExt(15) = X_MG8629                                   BUG23742
     C                   EVAL      PArrExt(16) = X_MG8660                                   BUG23742
     C                   EVAL      PArrExt(17) = X_MG8661                                   BUG23742
     C                   EVAL      PArrExt(18) = X_MG8662                                   BUG23742
     C                   EVAL      PArrExt(19) = X_MG8663                                   BUG23742
     C                   EVAL      PArrExt(20) = X_MG8664                                   BUG23742
     C                   EVAL      PArrExt(21) = X_MG8665                                   BUG23742
     C                   EVAL      PArrExt(22) = X_MG8632                                   BUG23742
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
     C                   PARM      X_MGADI1      PNarr1                                       CER030
     C                   PARM      X_MGADI2      PNarr2                                       CER030
     C                   PARM      X_MGADI3      PNarr3                                       CER030
     C                   PARM      X_MGADI4      PNarr4                                       CER030
     C                   PARM      X_MGADI5      PNarr5                                       CER030
     C                   PARM      X_MGADI6      PNarr6                                       CER030
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
      *                                                                                     MD042371
      ** Check for length                                                                   MD042371
      *                                                                                     MD042371
     C                   IF        ChkLen86A = 'Y'                                          MD042371
     C                   EVAL      Wfld86ALen = 0                                           MD042371
     C                   EVAL      CX = 1                                                   MD042371
     C                   DOW       CX <= 22                                                 MD042371
     C                   MOVEA     *BLANKS       AL100                                      MD042371
     C                   EVAL      WExtNar = *BLANKS                                        MD042371
     C                   EVAL      WExtNar = ArrExtNar(CX)                                  MD042371
     C                   IF        WExtNar <> *BLANKS                                       MD042371
     C                   IF        CX = 1                                                   MD042371
     C                   EVAL      Wfld86ALen = 4                                           MD042371
     C                   ENDIF                                                              MD042371
     C                   MOVEA     WExtNar       AL100                                      MD042371
     C                   EXSR      SRDetFldLen                                              MD042371
     C                   EVAL      Wfld86ALen = Wfld86ALen +                                MD042371
     C                             WFldLen + 2                                              MD042371
     C                   ENDIF                                                              MD042371
     C                   EVAL      CX = CX + 1                                              MD042371
     C                   ENDDO                                                              MD042371
     C                   LEAVESR                                                            MD042371
     C                   ENDIF                                                              MD042371
      *                                                                                       CER030
      ** Populate the Extended Narratives                                                     CER030
      *                                                                                       CER030
     C*****1****         DO        20                                                CER030 BUG23742
     C     1             DO        22                                                       BUG23742
      *                                                                                     MD031691
     C                   IF        WIdx > %INT(WFld21a)                                     MD031691
     C                   IF        EDNWRK = 'SWIFT'                                         MD031691
     C                   EVAL      ArrExtNar(WIdx) = *Blanks                                MD031691
     C                   ENDIF                                                              MD031691
     C                   ENDIF                                                              MD031691
      *                                                                                     MD031691
     C                   IF        ArrExtNar(WIdx) <> *BLANKS                                 CER030
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
     C                   EVAL      Q = Q +1                                                   CER030
     C     Q             OCCUR     MULT                                                       CER030
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
     C**********         EVAL      %SUBST(MFLD:WPos:8) = *BLANKS                     CER030 BUG23742
     C**********         ENDIF                                                     BUG23247 BUG23742
      **********                                                                   BUG23247 BUG23742
     C**********         ENDIF                                                       CER030 BUG23742
      **********                                                                     CER030 BUG23742
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
     C**********         EVAL      Q = Q + 1                                        CER030 BUG23280D
     C*****Q****         OCCUR     MULT                                             CER030 BUG23280D
     C**********         EVAL      MFLD = %SUBST(EDLSEP:2)                          CER030 BUG23040A
     C**********         EVAL      MFLD = %TRIM(%SUBST(EDLSEP:2))                BUG23040A BUG23280D
     C**********         EVAL      CTRC = WCrLf                                     CER030 BUG23280D
      **********                                                                    CER030 BUG23280D
     C**********         ELSEIF    WPos = 50                                        CER030 BUG23280D
     C**********         EVAL      CTRC = *BLANKS                                   CER030 BUG23280D
     C**********         EVAL      Q = Q + 1                                        CER030 BUG23280D
     C*****Q****         OCCUR     MULT                                             CER030 BUG23280D
     C**********         EVAL      MFLD = EDLSEP                                    CER030 BUG23040A
     C**********         EVAL      MFLD = %TRIM(EDLSEP)                          BUG23040A BUG23280D
     C**********         EVAL      CTRC = WCrLf                                     CER030 BUG23280D
     C**********         ENDIF                                                      CER030 BUG23280D
      **********                                                                    CER030 BUG23280D
     C**********         ENDIF                                                      CER030 BUG23280D
      *                                                                                       CER030
     C                   EVAL      CTRC = WCrLf                                               CER030
      *                                                                                       CER030
     C                   IF        %SUBST(ArrExtNar(WIdx):51:20) <> *BLANKS                   CER030
     C                   EVAL      CTRC = *BLANKS                                             CER030
     C                   EVAL      WLength  = WLength +                                       CER030
     C                                        %LEN(%TRIM(MTAG)) +                             CER030
     C                                        %LEN(%TRIM(MFLD)) +                             CER030
     C                                        %LEN(%TRIM(CTRC))                               CER030
     C                   EVAL      Q = Q + 1                                                  CER030
     C     Q             OCCUR     MULT                                                       CER030
      *                                                                                       CER030
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
     C**********         EVAL      WPos = %CHECKR(' ':ArrExtNar(WIdx))              CER030 BUG23280D
      **********                                                                    CER030 BUG23280D
     C**********         IF        WPos > 50 AND WPos < 71                          CER030 BUG23280D
     C**********         EVAL      MFLD = %TRIM(MFLD) + EDLSEP                      CER030 BUG23040A
     C**********         EVAL      MFLD = %TRIM(MFLD) + %TRIM(EDLSEP)            BUG23040A BUG23280D
     C**********         ENDIF                                                      CER030 BUG23280D
      **********                                                                    CER030 BUG23280D
     C**********         ENDIF                                                      CER030 BUG23280D
     C                   EVAL      CTRC = WCrLf                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   EVAL      WLength  = WLength +                                       CER030
     C                                        %LEN(%TRIM(MTAG)) +                             CER030
     C                                        %LEN(%TRIM(MFLD)) +                             CER030
     C                                        %LEN(%TRIM(CTRC))                               CER030
      *                                                                                       CER030
     C**********         ELSE                                                        CER030 BUG25311
     C**********         LEAVE                                                       CER030 BUG25311
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   EVAL      WIdx = WIdx + 1                                            CER030
     C                   ENDDO                                                                CER030
      *                                                                                       CER030
      ** Structured Format                                                                    CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
     C                   IF        ChkLen86A = 'Y'                                          MD042371
     C                   EVAL      Wfld86ALen = 0                                           MD042371
     C                   MOVEA     *BLANKS       ArrExtNar                                  MD042371
     C                   EVAL      ArrStrFmt(1) = %TRIM(X_MG86GV)                           MD042371
     C                   EVAL      ArrStrFmt(2) = %TRIM(X_MG8600)                           MD042371
     C                   EVAL      ArrStrFmt(3) = %TRIM(X_MG8610)                           MD042371
     C                   EVAL      ArrStrFmt(4) = %TRIM(X_MG8620)                           MD042371
     C                   EVAL      ArrStrFmt(5) = %TRIM(X_MG8621)                           MD042371
     C                   EVAL      ArrStrFmt(6) = %TRIM(X_MG8622)                           MD042371
     C                   EVAL      ArrStrFmt(7) = %TRIM(X_MG8623)                           MD042371
     C                   EVAL      ArrStrFmt(8) = %TRIM(X_MG8624)                           MD042371
     C                   EVAL      ArrStrFmt(9) = %TRIM(X_MG8625)                           MD042371
     C                   EVAL      ArrStrFmt(10) = %TRIM(X_MG8626)                          MD042371
     C                   EVAL      ArrStrFmt(11) = %TRIM(X_MG8627)                          MD042371
     C                   EVAL      ArrStrFmt(12) = %TRIM(X_MG8628)                          MD042371
     C                   EVAL      ArrStrFmt(13) = %TRIM(X_MG8629)                          MD042371
     C                   EVAL      ArrStrFmt(14) = %TRIM(X_MG8630)                          MD042371
     C                   EVAL      ArrStrFmt(15) = %TRIM(X_MG8631)                          MD042371
     C                   EVAL      ArrStrFmt(16) = %TRIM(X_MG8632)                          MD042371
     C                   EVAL      ArrStrFmt(17) = %TRIM(X_MG8633)                          MD042371
     C                   EVAL      ArrStrFmt(18) = %TRIM(X_MG8634)                          MD042371
     C                   EVAL      ArrStrFmt(19) = %TRIM(X_MG8635)                          MD042371
     C                   EVAL      ArrStrFmt(20) = %TRIM(X_MG8636)                          MD042371
     C                   EVAL      ArrStrFmt(21) = %TRIM(X_MG8638)                          MD042371
     C                   EVAL      ArrStrFmt(22) = %TRIM(X_MG8660)                          MD042371
     C                   EVAL      ArrStrFmt(23) = %TRIM(X_MG8661)                          MD042371
     C                   EVAL      ArrStrFmt(24) = %TRIM(X_MG8662)                          MD042371
     C                   EVAL      ArrStrFmt(25) = %TRIM(X_MG8663)                          MD042371
     C                   EVAL      ArrStrFmt(26) = %TRIM(X_MG8664)                          MD042371
     C                   EVAL      ArrStrFmt(27) = %TRIM(X_MG8665)                          MD042371
      *                                                                                     MD042371
      ** Check for length                                                                   MD042371
      *                                                                                     MD042371
     C                   EVAL      CX = 1                                                   MD042371
     C                   EVAL      Wfld86ALen = 0                                           MD042371
     C                   DOW       CX <= 27                                                 MD042371
     C                   MOVEA     *BLANKS       AL100                                      MD042371
     C                   EVAL      WExtNar = *BLANKS                                        MD042371
     C                   EVAL      WExtNar = ArrStrFmt(CX)                                  MD042371
     C                   IF        WExtNar <> *BLANKS                                       MD042371
     C                   IF        CX = 1                                                   MD042371
     C                   EVAL      Wfld86ALen = 4                                           MD042371
     C                   ENDIF                                                              MD042371
     C                   MOVEA     WExtNar       AL100                                      MD042371
     C                   EXSR      SRDetFldLen                                              MD042371
     C                   EVAL      Wfld86ALen = Wfld86ALen +                                MD042371
     C                             WFldLen + 2                                              MD042371
     C                   ENDIF                                                              MD042371
     C                   EVAL      CX = CX + 1                                              MD042371
     C                   ENDDO                                                              MD042371
     C                   LEAVESR                                                            MD042371
     C                   ENDIF                                                              MD042371
      *                                                                                     MD042371
     C                   EVAL      WFld86= *BLANKS                                            CER030
     C                   EVAL      WKTag= *BLANKS                                             CER030
     C                   EVAL      WFldSep = EDFSEP                                           CER030
      *                                                                                       CER030
      ** Subfield GVC                                                                         CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = 'GVC'                                              CER030
     C                   EVAL      WKValue = X_MG86GV                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Booking Text                                                                         CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '00'                                               CER030
     C                   EVAL      WKValue = X_MG8600                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Batch No                                                                             CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '10'                                               CER030
     C                   EVAL      WKValue = X_MG8610                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '20'                                               CER030
     C                   EVAL      WKValue = X_MG8620                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '21'                                               CER030
     C                   EVAL      WKValue = X_MG8621                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '22'                                               CER030
     C                   EVAL      WKValue = X_MG8622                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '23'                                               CER030
     C                   EVAL      WKValue = X_MG8623                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '24'                                               CER030
     C                   EVAL      WKValue = X_MG8624                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '25'                                               CER030
     C                   EVAL      WKValue = X_MG8625                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '26'                                               CER030
     C                   EVAL      WKValue = X_MG8626                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '27'                                               CER030
     C                   EVAL      WKValue = X_MG8627                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '28'                                               CER030
     C                   EVAL      WKValue = X_MG8628                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '29'                                               CER030
     C                   EVAL      WKValue = X_MG8629                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Bank Sort Code                                                                       CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '30'                                               CER030
     C                   EVAL      WKValue = X_MG8630                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Account Number                                                                       CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '31'                                               CER030
     C                   EVAL      WKValue = X_MG8631                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Account Name                                                                         CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '32'                                               CER030
     C                   EVAL      WKValue = X_MG8632                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Account Name                                                                         CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '33'                                               CER030
     C                   EVAL      WKValue = X_MG8633                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Text Code Supplement                                                                 CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '34'                                               CER030
     C                   EVAL      WKValue = X_MG8634                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Beneficiary Data                                                                     CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '35'                                               CER030
     C                   EVAL      WKValue = X_MG8635                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Beneficiary Data                                                                     CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '36'                                               CER030
     C                   EVAL      WKValue = X_MG8636                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** IBAN                                                                                 CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '38'                                               CER030
     C                   EVAL      WKValue = X_MG8638                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '60'                                               CER030
     C                   EVAL      WKValue = X_MG8660                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '61'                                               CER030
     C                   EVAL      WKValue = X_MG8661                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '62'                                               CER030
     C                   EVAL      WKValue = X_MG8662                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '63'                                               CER030
     C                   EVAL      WKValue = X_MG8663                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '64'                                               CER030
     C                   EVAL      WKValue = X_MG8664                                         CER030
     C                   EXSR      SRLdFld                                                    CER030
      *                                                                                       CER030
      ** Details of Payments                                                                  CER030
      *                                                                                       CER030
     C                   EVAL      WKTag = '65'                                               CER030
     C                   EVAL      WKValue = X_MG8665                                         CER030
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
     C                   EVAL      WFld86 = *BLANKS                                           CER030
      *                                                                                       CER030
     C                   IF        WKTag = 'GVC'                                              CER030
     C**********         EVAL      WFld86 = %TRIM(WKTAG) +                           CER030 BUG22981
     C**********                            %TRIM(WKValue)                           CER030 BUG22981
     C**********         EVAL      WPos = %SCAN('/IACC/D':WKValue)                BUG23032 BUG23032A
      *                                                                                     BUG23032
     C**********         IF        WPos > 0                                       BUG23032 BUG23032A
     C**********         EVAL      %SUBST(WKValue:WPos:8) = *BLANKS               BUG23032 BUG23032A
     C**********         ENDIF                                                    BUG23032 BUG23032A
      *                                                                                     BUG23032
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
      *                                                                                    BUG23032A
     C                   EVAL      WFld86 = %TRIM(WFldSep) +                                  CER030
     C                                      %TRIM(WKTAG) +                                    CER030
     C                                      %TRIM(WKValue)                                    CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   EVAL      Q = Q + 1                                                  CER030
     C     Q             OCCUR     MULT                                                       CER030
      *                                                                                       CER030
     C                   IF        WFrstFlg = 'Y'                                             CER030
     C                   EVAL      MTAG = ':86:'                                              CER030
     C                   EVAL      WFrstFlg = 'N'                                             CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   EVAL      MFLD = WFld86                                              CER030
     C                   EVAL      CTRC = WCrLf                                               CER030
     C                   EVAL      WLength = WLength + %LEN(%TRIM(WFld86))                    CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDSR                                                                CER030
      *                                                                                       CER030
      *****************************************************************                       CER030
      /EJECT                                                                                  CER030
     C/COPY WNCPYSRC,MGH00030
     C/COPY OFCPYSRCZ,CGL146_093                                                             CGL146A
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

      ** Read in Installation Data

     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

      ** Access Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd             7
     C                   PARM      '*FIRST '     POptn             7
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error.

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 9
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access SDMGMEPD for message management data

     C                   CALL      'AOMGMER0'
     C                   PARM      '*MSG    '    PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDMGME        PARM      SDMGME        DSFDY

      ** Database error.

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDMGMEPD'
     C                   EVAL      DBASE = 10
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Convert history retention date to YYMMDD
      *
     C     BJRDNB        ADD       ENDSMN        ZMDAY
     C                   Exsr      Call_ZM0060
     C                   MOVE      ZMDATE        WHrdt
      *
     C                   Eval      ZMDAY = BJRDNB
     C                   Exsr      Call_ZM0060
     C                   Move      ZMDATE        WRundNum
     C                   Move      ZMDATE        WRundChr
      *

      **  Initialise constant fields
      *
     C                   Eval      WCrLf = *LOVAL
     C                   BITON     '457'         WWCr
     C                   BITON     '257'         WWLf

      ** Key List

     C     KNwrkAc       KLIST
     C                   KFLD                    KNwrk
     C                   KFLD                    KBrca
     C                   KFLD                    KCnum
     C                   KFLD                    KCcy
     C                   KFLD                    KAccd
     C                   KFLD                    KAcsq
     C                   KFLD                    KNaty
     C                   KFLD                    KDstn
     C/COPY WNCPYSRC,MGH00090

     C/COPY OFCPYSRCZ,CGL146_144                                                            MD024641
     C/COPY OFCPYSRCZ,CGL146_145                                                            MD024641
                                                                                            MD024641
      *  Access last generated sequence number from MGOREFPD
     C                   Eval      WTrno = 'GL' + WRundChr + '999999'
     C     WTrno         SETGT     MGOREFL0
     C                   READP     MGOREFL0                               15
      *    If ReadP successful, and first 8 characters of record read equals
      *    'GL' + rundate, store sequence number
     C                   If        *IN15 = *Off And
     C                             %subst(E_TRNO: 1 : 8) = 'GL' + WRundChr
     C                   Eval      WSeqChr = %subst(E_TRNO : 9 : 6)
     C                   Else
      *    Else  ReadP not successful or first 2 components do not match,
      *    this is first GL message so set sequence to blank
     C                   Eval      WSeqChr = *blank
     C                   Endif

     C                   Eval      Count940 = 0
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
     C                   EVAL      DBKEY = PSard                                              CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 11                                                 CER030
     C                   OUT       LDA                                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER030 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C/COPY WNCPYSRC,MGH00091
     C/COPY OFCPYSRCZ,CGL146_058                                                              CGL146
      ** Get the Maximum number of characters for field 86                                  BUG25529
      *                                                                                     BUG25529
     C                   CALL      'AOSVALR0'                                               BUG25529
     C                   PARM      *BLANKS       PRtcd                                      BUG25529
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
     C                   IF        PRtcd <> *BLANKS                                         BUG25529
      *                                                                                     BUG25529
     C     *LOCK         IN        LDA                                                      BUG25529
     C                   EVAL      DBPGM = 'MG000940'                                       BUG25529
     C                   EVAL      DBFILE = 'SDSVALPD'                                      BUG25529
     C                   EVAL      DBASE = 012                                              BUG25529
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

     C/COPY OFCPYSRCZ,CGL146_094                                                             CGL146A
     C/COPY WNCPYSRC,MGH00031
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREND  - Subroutine to End Program                            *
      *                                                               *
      *****************************************************************

     C     SREND         BEGSR

      **   Output Report Header

     C                   Write     HEADAU

      **   If there is a DB Error, Output the DB Error Information.
     C                   If        *INU7 = *ON
     C                   Write     DBERROR
     C                   Else
     C                   Write     HASRUN
     C                   Endif
      *
      *  End program
     C                   Seton                                        LR
     C                   Return

     C                   Endsr
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
      *
     C     *PSSR         BEGSR

     C                   DUMP

     C                   ROLBK
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      SREnd

     C                   ENDSR
      ********************************************************************
     O***/COPY*FTCPYSRC,FTSWIFTRAN                                                          AR858070
