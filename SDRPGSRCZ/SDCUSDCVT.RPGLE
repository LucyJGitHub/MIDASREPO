     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Conversion: File to Screen Fmt')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSDCVT - Customers Conversion: File to Screen Format      *
      *                                                               *
      *  Function:  This module converts the fields of a Customer     *
      *             from their format as on file to a screen format.  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD050212           Date 02Apr18               *
      *  Prev Amend No. MD051191           Date 05Jun18               *
      *                 CGL177             Date 11Jan16               *
      *                 MD035388           Date 20Oct15               *
      *                 CGL157             Date 17Aug15               *
      *                 MD046248           Date 27Oct17               *
      *                 CSW216             Date 14Mar16               *
      *                 CER071             Date 01Aug16               *
      *                 CER070             Date 25Nov14               *
      *                 CSW214             Date 25Nov14               *
      *                 MD030956           Date 09Oct14               *
      *                 MD027492           Date 12Jun14               *
      *                 CGL132             Date 01May13               *
      *                 MD022463           Date 27Sep13               *
      *                 CFT050             Date 03Jun13               *
      *                 AR1086546          Date 27Jun13               *
      *                 CLE134             Date 01Aug12               *
      *                 CSD090             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG17016           Date 13Mar08               *
      *                 BUG15872           Date 12Feb08               *
      *                 CSW207A            Date 02Aug07               *
      *                 CSW207             Date 06Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG13595           Date 20Mar07               *
      *                 BUG13525           Date 05Mar07               *
      *                 CSD079             Date 05Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW036             Date 15Dec04               *
      *                 CSW037             Date 14Dec04               *
      *                 CFX001             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 CGP001             Date 23May03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 211543             Date 17Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW024             Date 31Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 17May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050212 - Replication processing for SDCUSTXC (Recompile)   *
      *  MD051191 - US Phone Number field in FATCA Information tab    *
      *             blanks out after amendment authorisation          *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD033588 - FATCA Screen order rework                         *
      *  CGL157 - CRS Reporting                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CER071 - BAIS - Legal Form field                             *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0                      *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  MD027492 - Override Details in US Indicia screen is incorrect*
      *           - Applied fix MD026835                              *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  MD022463 - No screen is displayed to show Bank Directory     *
      *             Plus Detail Screen on Linked Customers during     *
      *             Amend and Enquire                                 *
      *  CFT050 - SWIFTRef Directories upload                         *
      *  AR1086546 - Upgrade of CDL025 to MP 1.4 (Child: AR1086547).  *
      *              Applied for MD021813                             *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CSD090 - Customer Segmentation                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17016 - Serios Midas error will be displayed (Recompile)  *
      *  BUG15872 - Applied fix BUG14992                              *
      *  BUG14992 - Some of CSW207 fields not completely upgraded     *
      *  CSW207A - SWIFT 2007 Changes                                 *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  BUG13595 - European Reporting fields not being populated     *
      *             properly during edit mode                         *
      *  BUG13525 - ECSD Mismatch between XML and RPG (Recompile)     *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CSW037 - AdditionaField Data on MT300/MT320                  *
      *  CFX001 - FX Margin Trading                                   *
      *  CLE025 - Credit Lines                                        *
      *  CGP001 - Global Processing                                   *
      *  211543 - Leading 0's are not displayed initially for the     *
      *           values of the Chips ID, Chaps Sort Code and Fedwire *
      *           Code fields.  Removed the ZEDIT processing on these *
      *           fields.  Applied fix 208507.                        *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
      *  CRE007 - Base Rate Tax 2001                                  *
      *  CDL008 - Continuous Linked Settlement                        *
      *  CAP034 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
     FSDBRCHL5  IF   E           K DISK                                                       CSD079
      ** RSQ : Midas SD Branch codes by customer number                                       CSD079
                                                                                              CSD079
     FSDCURRL1  IF   E           K DISK                                                       CSD079
      ** Midas SD Midas SD Currency codes retrieval                                           CSD079
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Customer - File Formats
     D CustFilFmt    E DS                  EXTNAME(SDCUSTPD)
     D/COPY WNCPYSRC,SDH00692
 
      * Customer Ex - File Format                                                             CGL132
     D CuXcFilFmt    E DS                  EXTNAME(SDCUSTXC)                                  CGL132
                                                                                              CGL132
      ** SDCRSHPD Transaction Details in File Format                                          CGL157
     D CrsdFilFmt    E DS                  EXTNAME(SDCRSHPD)                                  CGL157
                                                                                              CGL157
      * Base Rate Tax details - File Format
     D BrTxFilFmt    E DS                  EXTNAME(SDCBRTPD)
 
      * Private Banking Details - File Format
     D PrivFilFmt    E DS                  EXTNAME(SDPBDSPD)
     D                                     PREFIX(A_)
                                                                                              CGP001
      ** Global Customer X-Reference - File Format                                            CGP001
     D GCustFilFmt   E DS                  EXTNAME(GPCUSTXPD)                                 CGP001
                                                                                              CSD079
      ** Marketing Information                                                                CSD079
     D CumiFilFmt    E DS                  EXTNAME(SDCMRKPD)                                  CSD079
                                                                                              CSD079
      ** Additional Customer                                                                  CSD079
     D CuadFilFmt    E DS                  EXTNAME(SDACUSPD)                                  CSD079
                                                                                              CSD079
      ** Service Fees                                                                         CSD079
     D SfeeFilFmt    E DS                  EXTNAME(SDCFCDPD)                                  CSD079
                                                                                              CSD079
      ** Cheques and Card Details                                                             CSD079
     D ChecFilFmt    E DS                  EXTNAME(SDCHEQPD)                                  CSD079
                                                                                              CSD079
      ** Safe Details                                                                         CSD079
     D CusfFilFmt    E DS                  EXTNAME(SDSAFEPD)                                  CSD079
                                                                                              CSD079
      ** Risk Weighted Assets                                                                 CSD079
     D RwanFilFmt    E DS                  EXTNAME(SDVRWANPD)                                 CSD079
                                                                                              CSD079
      ** Future and Options                                                                   CSD079
     D CufoFilFmt    E DS                  EXTNAME(SDFOCSPD)                                  CSD079
     D Q1_QSMAC      E                     EXTFLD(QQSMAC)                                     CSD079
     D CufnFilFmt    E DS                  EXTNAME(SDFOX1PD)                                  CSD079
                                                                                              CSD079
      ** Portfolio Management                                                                 CSD079
     D CupmFilFmt    E DS                  EXTNAME(SDPLCSPD)                                  CSD079
                                                                                              CSD079
      ** TI Customer Details in File Format                                                   CSD079
     D TICDFILFMT    E DS                  EXTNAME(SDTICSPD)                                  CSD079
                                                                                              CSD079
      ** Lux(European Reporting) in file format                                               CSD079
     D CueuFilFmt    E DS                  EXTNAME(SDCUX2PD)                                  CSD079
                                                                                              CSD079
      ** Lux(IBLC - Extended Information) in file format                                      CSD079
     D CuibfFilFmt   E DS                  EXTNAME(SDCUX1PD)                                  CSD079
                                                                                           AR1086546
      ** Currency/Time of Netting Details                                                  AR1086546
     D CtnmFilFmt    E DS                  EXTNAME(SDVCTNMPD)                              AR1086546
                                                                                              CGP001
      * Customer - Screen Formats
     D CuPrim        E DS                  EXTNAME(SDCUPRPD)
     D CuCuxc        E DS                  EXTNAME(SDCUXCPD)                                  CGL132
     D CrSwFilFmt    E DS                  EXTNAME(SDCSSWPD)                                  CSW207
     D CuSwft        E DS                  EXTNAME(SDCUSWPD)                                  CSW207
     D CuFATC        E DS                  EXTNAME(SDFTCRPD)                                  CGL132
     D  DDCUST1      E                     EXTFLD(DDCUST)                                     CGL132
     D CuSeco        E DS                  EXTNAME(SDCUSEPD)
     D CuMsrt        E DS                  EXTNAME(SDCUMRPD)
     D CuBrtx        E DS                  EXTNAME(SDCUBRPD)
     D CuPriv        E DS                  EXTNAME(SDCUPBPD)
     D                                     PREFIX(A_)
                                                                                              CGL132
      ** FATCA Customer Details in file format                                                CGL132
     D CrFaFilFmt    E DS                  EXTNAME(SDFTCSPD)                                  CGL132
                                                                                              CGL132
      ** SDCRSSPD Transaction Details in Screen Format                                        CGL157
     D CrsdDets      E DS                  EXTNAME(SDCRSSPD)                                  CGL157
     D                                     PREFIX(A_)                                         CGL157
                                                                                              CGL157
                                                                                              CGL157
      ** SDVCRSDPD CRS Transaction Details in File Format                                     CGL157
     D TranCrsd      E DS                  EXTNAME(SDVCRSDPD)                                 CGL157
                                                                                              CGL157
      ** External DS for Country of Tax Codes                                                 CGL157
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                                  CGL157
                                                                                              CGL157
      ** Marketing Information                                                                CSD079
     D TranInCumi    E DS                  EXTNAME (SDCUMIPD)                                 CSD079
     D A9_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
                                                                                              CSD079
      ** Additional Customer                                                                  CSD079
     D TranInCuad    E DS                  EXTNAME (SDCUADPD)                                 CSD079
     D B1_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
     D A2_DDCNA1     E                     EXTFLD(DDCNA1)                                     CSD079
     D A3_DDCNA2     E                     EXTFLD(DDCNA2)                                     CSD079
     D A4_DDCNA3     E                     EXTFLD(DDCNA3)                                     CSD079
     D A8_DDCNA4     E                     EXTFLD(DDCNA4)                                     CSD079
     D A2_DDCSSN     E                     EXTFLD(DDCSSN)                                     CSD079
     D TranInACU3    E DS                  EXTNAME (SDACU3DPD)                                CER059
     D TranInACU4    E DS                  EXTNAME (SDACU4DPD)                                CER059
                                                                                              CSD079
      ** Service Fees                                                                         CSD079
     D TranInSfee    E DS                  EXTNAME (SDSFEEPD)                                 CSD079
     D A1_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
                                                                                              CSD079
      ** Cheques and Card Details                                                             CSD079
     D TranInChec    E DS                  EXTNAME (SDCHECPD)                                 CSD079
     D A2_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
                                                                                              CSD079
      ** Safe Details                                                                         CSD079
     D TranInCusf    E DS                  EXTNAME (SDCUSFPD)                                 CSD079
     D A3_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
                                                                                              CSD079
      ** FX netting Details                                                                   CSD079
     D TranInCufx    E DS                  EXTNAME (SDCUFXPD)                                 CSD079
     D A4_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
      ** Fiduciary Details                                                                    CSD079
     D TranInCufd    E DS                  EXTNAME (SDCUFDPD)                                 CSD079
     D A5_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
                                                                                              CSD079
      ** Risk Weighted Assets                                                                 CSD079
     D TranInRwan    E DS                  EXTNAME (SDRWANPD)                                 CSD079
     D A6_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
     D A1_DDCSSN     E                     EXTFLD(DDCSSN)                                     CSD079
     D A1_DDCRNM     E                     EXTFLD(DDCRNM)                                     CSD079
     D A1_DDCNA2     E                     EXTFLD(DDCNA2)                                     CSD079
                                                                                              CSD079
      ** Future and Options                                                                   CSD079
     D TranInCufo    E DS                  EXTNAME (SDCUFOPD)                                 CSD079
     D A7_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
     D A1_DDSMAC     E                     EXTFLD(DDSMAC)                                     CSD079
                                                                                              CSD079
      ** Portfolio Management                                                                 CSD079
     D TranInCupm    E DS                  EXTNAME (SDCUPMPD)                                 CSD079
     D A8_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
                                                                                              CSD079
      ** TI Details                                                                           CSD079
     D TranInTicd    E DS                  EXTNAME (SDTICDPD)                                 CSD079
     D B2_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
      ** Lux European & IBLC - Extended Information                                           CSD079
     D TranInCurx    E DS                  EXTNAME (SDCURXPD)                                 CSD079
                                                                                              CSW024
      ** Current Customer in Screen Format - MT3xx BEI Details                                CSW024
     D CuMT3X        E DS                  EXTNAME(SDCUMTPD)                                  CSW024
      ** Currency/Time of Netting                                                          AR1086546
     D TranInCtnm    E DS                  EXTNAME (SDCCTNPD)                              AR1086546
     D CT_DDACTN     E                     EXTFLD(DDACTN)                                  AR1086546
     D CT_DDCUST     E                     EXTFLD(DDCUST)                                  AR1086546
     D CT_DDNTCP     E                     EXTFLD(DDNTCP)                                  AR1086546
 
 
      ** Array used to move right Swift Id.
     D ROU             S              1    DIM(12)
 
      ** Array used to left-align countervalue.
     D                 DS                                                       E20653
     D  CTR                    1     21                                         E20653
     D                                     DIM(21)                              COUNTERVALUE     E20
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** EXTERNAL DS FOR Portfolio Management DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D***CuSW13*       E DS                  EXTNAME(SDSW13PD)                       CFT050 MD022463
     D***S13DDBRCD    E                     EXTFLD(DDBRCD)                           CFT050 MD022463
     D***S13DDCITY    E                     EXTFLD(DDCITY)                           CFT050 MD022463
      ** Customer dtls Bank directory plus details                                            CFT050
     D/COPY WNCPYSRC,SDCUSDND01
 
      ** Midas SD Currency codes                                                              CSD079
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CSD079
                                                                                              CSD079
     D WFTMST          DS                                                                     CGL132
     D  WWHH                   1      2                                                       CGL132
     D  WWMM                   3      4                                                       CGL132
     D  WWSS                   5      6                                                       CGL132
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PCrsdF          S            219A   DIM(30)                                            CGL177
     D PCrsdS          S            223A   DIM(30)                                            CGL177
     D WCNCD           S              2A                                                      CGL157
     D WCOLC           S              2A                                                      CGL157
     D @PCTRT          S              2A                                                      CGL157
     D @PCTRR          S              2A                                                      CGL157
     D CGL157          S              1A                                                      CGL157
     D X               S              2S 0                                                    CGL157
     D Y               S              2S 0                                                    CGL157
                                                                                              CGL157
     D PCRSDT          DS                                                                     CGL157
     D  DDCTRY                 1      2                                                       CGL157
     D  DDREPQ                 3      3                                                       CGL157
     D  DDREPU                 4     13                                                       CGL157
     D  DDREPD                14     19                                                       CGL157
     D  DDREPM                20     25                                                       CGL157
     D  DDREP1                26     89                                                       CGL157
     D  DDREP2                90    153                                                       CGL157
     D  DDEVD1               154    155                                                       CGL157
     D  DDEVS1               156    158                                                       CGL157
     D  DDEVD2               159    160                                                       CGL157
     D  DDEVS2               161    163                                                       CGL157
     D  DDEVD3               164    165                                                       CGL157
     D  DDEVS3               166    168                                                       CGL157
     D  DDEVD4               169    170                                                       CGL157
     D  DDEVS4               171    173                                                       CGL157
     D  DDEVD5               174    175                                                       CGL157
     D  DDEVS5               176    178                                                       CGL157
     D  DDTINN               179    203                                                       CGL157
     D  DDEFFD               204    209                                                       CGL157
     D  DDEXPD               210    215                                                       CGL157
     D  DDCODO               216    216                                                       CGL157
     D  DDJACM               217    217                                                       CGL157
     D  DDMAIQ               218    218                                                       CGL157
     D  DDPHOQ               219    219                                                       CGL157
     D  DDRPAY               220    220                                                       CGL157
     D  DDCRSA               221    221                                                       CGL157
     D  DDTINS               222    222                                                       CGL157
     D  DDAUHO               223    223                                                       CGL157
                                                                                              CGL177
     D CrFoFilFmt      DS                                                                   MD035388
     D  WCDESC                 1     50                                                     MD035388
     D  WPDESC                51    100                                                     MD035388
     D  WWBRTH               101    105                                                     MD035388
     D  WWCBTH               106    107                                                     MD035388
     D  WWBTHT               108    142                                                     MD035388
     D  WWCNCZ               143    144                                                     MD035388
     D  WWCDOM               145    146                                                     MD035388
     D  WWACCZ               147    148                                                     MD035388
     D  WWUTIN               149    173                                                     MD035388
                                                                                            MD035388
     D CuFOTH          DS                                                                   MD035388
     D  WCDESC1                1     50                                                     MD035388
     D  WPDESC1               51    100                                                     MD035388
     D  WNBRTH               101    106                                                     MD035388
     D  WWCBTH1              107    108                                                     MD035388
     D  WWBTHT1              109    143                                                     MD035388
     D  WWCNCZ1              144    145                                                     MD035388
     D  WWCDOM1              146    147                                                     MD035388
     D  WWACCZ1              148    149                                                     MD035388
     D  WWUTIN2              150    174                                                     MD035388
                                                                                            MD035388
     D CGP001          S              1A                                                      CGP001
                                                                                              CGP001
     D CFX001          S              1                                                       CFX001
     D CLE025          S              1                                                       CLE025
     D CLE134          S              1                                                       CLE134
      ** Swift installed flag                                                                 CSW207
     D CSW207          S              1A                                                      CSW207
                                                                                              CSW207
     D CSD090          S              1A   INZ('N')                                           CSD090
     D CSD079          S              1A   inz('N')                                           CSD079
     D S01425          S              1A   inz('N')                                           CSD079
     D CSD008          S              1A   inz('N')                                           CSD079
     D CDL002          S              1A   inz('N')                                           CSD079
     D CDL006          S              1A   inz('N')                                           CSD079
     D CGL018          S              1A                                                      CSD079
     D PRTCD           S              7A                                                      CSD079
     D POPTN           S              7A                                                      CSD079
     D PSARD           S              6A                                                      CSD079
     D PMODE           S              1A                                                      CSD079
     D ULX004          S              1A   inz('N')                                           CSD079
     D ULX609          S              1A   inz('N')                                           CSD079
     D ULX043          S              1A   inz('N')                                           CSD079
     D CDL025          S              1A   inz('N')                                        AR1086546
     D CGL132          S              1A                                                      CGL132
     D CTI006          S              1A                                                    MD030956
                                                                                              CSD079
      ** For date conversion                                                                  CSD079
     D ##DOB           DS                                                                     CSD079
     D ##DAT1                  1      4                                                       CSD079
     D ##CC                    5      6                                                       CSD079
     D ##YY                    7      8                                                       CSD079
      **                                                                                      CSD079
      ** Parameter for calling AOCURRR0                                                       CSD079
     D PRtnCde         S              7                                                       CSD079
     D PAJCD           S              3                                                       CSD079
                                                                                              CSD079
      ** Work fields                                                                          CSD079
     D W0RTN           S              7                                                       CSD079
     D ZUDIG           S              2P 0                                                    CSD079
     D ZUZAFF          S             16                                                       CSD079
     D #DDOBY          S              2P 0                                                    CSD079
     D #DDOBN          S              8P 0                                                    CSD079
     D #DDOBZ          S              4P 0                                                    CSD079
     D WUPMSC          S              1                                                       CSD079
                                                                                              CLE025
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      **************************************************************
      /EJECT
     C**************************************************************
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      ** SET PRIMARY SCREEN FIELDS
      *
     C                   EXSR      SCN_PRIM
      *
      ** SET SECONDARY SCREEN FIELDS
      *
     C                   EXSR      SCN_SECO
      *
      ** SET MESSAGE ROUTING SCREEN FIELDS
      *
     C                   EXSR      SCN_MSRT
                                                                                              CGL132
      ** Set FATCA detail screen fields                                                       CGL132
                                                                                              CGL132
     C                   IF        CGL132 = 'Y'                                               CGL132
     C                   EXSR      SCN_FATC                                                   CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL157
      ** Set CRS Customer Details if CGL157 is ON                                             CGL157
     C                   IF        CGL157 = 'Y'                                               CGL157
     C                   EXSR      SRCRSScn                                                   CGL157
     C                   ENDIF                                                                CGL157
      *
      ** SET BASE RATE TAX SCREEN FIELDS
      *
     C     S01383        IFEQ      'Y'
     C     BBTAIN        IFEQ      'I'
     C     BBTAIN        OREQ      'J'
     C     BBTAIN        OREQ      'R'                                                        CRE007
     C                   EXSR      SCN_BRTX
     C                   END
     C                   ENDIF
 
      ** SET PRIVATE BANKING SCREEN FIELDS
      *
     C     BGN4ST        IFEQ      'Y'
     C                   EXSR      SCN_PRIV
     C                   ENDIF
      *                                                                                       CSW024
      ** If enhancement CSW024 is installed and Midas/Swift direct link is installed,         CSW024
      ** set-up MT3X BEI & Fund details fields.                                               CSW024
      *                                                                                       CSW024
     C                   IF        CSW024 = 'Y' and BGMSDL = 'Y'                              CSW024
     C                   EXSR      SCN_MT3X                                                   CSW024
     C                   ENDIF                                                                CSW024
 
     C                   IF        CSD079 = 'Y'                                               CSD079
                                                                                              CSD079
      ** Set Marketing Information Screen Fields                                              CSD079
                                                                                              CSD079
     C                   EXSR      SCN_CUMI                                                   CSD079
                                                                                              CSD079
      ** Set Additional Customer Details Screen Fields                                        CSD079
                                                                                              CSD079
     C     S01425        IFEQ      'Y'                                                        CSD079
     C                   EXSR      SCN_Cuad                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Service Fees Screen Fields                                                       CSD079
                                                                                              CSD079
     C     CSD008        IFEQ      'Y'                                                        CSD079
     C                   EXSR      SCN_SFEE                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Cheques and Card Details Screen Fields                                           CSD079
                                                                                              CSD079
     C     BGNXST        IFEQ      'Y'                                                        CSD079
     C                   EXSR      SCN_CHEC                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Safe Details Screen Fields                                                       CSD079
                                                                                              CSD079
     C                   EXSR      SCN_CUSF                                                   CSD079
                                                                                              CSD079
      ** Set Fx netting Details Screen Fields                                                 CSD079
                                                                                              CSD079
     C     CDL002        IFEQ      'Y'                                                        CSD079
     C                   EXSR      SCN_CUFX                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Fiduciary Details Screen Fields                                                  CSD079
                                                                                              CSD079
     C     CDL006        IFEQ      'Y'                                                        CSD079
     C                   EXSR      SCN_CUFD                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Risk weighted assets Screen Fields                                               CSD079
                                                                                              CSD079
     C     CGL018        IFEQ      'Y'                                                        CSD079
     C                   EXSR      SCN_RWAN                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Futures and Option Screen Fields                                                 CSD079
                                                                                              CSD079
     C     BGFUOP        IFEQ      'Y'                                                        CSD079
     C                   EXSR      SCN_CUFO                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set FF Customers Maintenance Screen Fields                                           CSD079
                                                                                              CSD079
     C     BGFUOP        IFEQ      'Y'                                                        CSD079
     C     ULX004        ANDEQ     'Y'                                                        CSD079
     C                   EXSR      SCN_CUFN                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Portfolio Management Screen Fields                                               CSD079
                                                                                              CSD079
     C     WUPMSC        IFEQ      'Y'                                                        CSD079
     C                   EXSR      SCN_CUPM                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Trade Innovation Screen Fields                                                   CSD079
                                                                                              CSD079
     C     BGN3ST        IFEQ      'Y'                                                        CSD079
     C     CTI006        OREQ      'Y'                                                      MD030956
     C                   EXSR      SCN_TICD                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Lux(European reporting) Screen Fields                                            CSD079
                                                                                              CSD079
     C     ULX609        IFEQ      'Y'                                                        CSD079
     C                   EXSR      SCN_CUX2                                                   CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Set Lux(IBLC - Extended Information) Screen Fields                                   CSD079
                                                                                              CSD079
     C     ULX043        IFEQ      'Y'                                                        CSD079
     C                   EXSR      SCN_CUX1                                                   CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
      ** Set Currency/Time of Netting Fields                                               AR1086546
                                                                                           AR1086546
     C     CDL025        IFEQ      'Y'                                                     AR1086546
     C     CDL002        ANDEQ     'Y'                                                     AR1086546
     C     DDNET         ANDEQ     'Y'                                                     AR1086546
     C                   EXSR      SCN_CTNM                                                AR1086546
     C                   ENDIF                                                             AR1086546
                                                                                           AR1086546
     C                   ENDIF                                                                CSD079
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCN_PRIM - SET PRIMARY SCREEN FIELDS
      *****************************************************************
     C     SCN_PRIM      BEGSR
 
      *  Customer Number
     C                   MOVE      BBCUST        DDCUSN
 
      *  Customer Name & Adresse 1
     C                   MOVE      BBCNA1        DDCNA1
 
      *  Customer Shortname
     C                   MOVE      BBCSSN        DDCSSN
 
      *  Customer Name & Adresse 2
     C                   MOVE      BBCNA2        DDCNA2
 
      *  DRS Customer Shortname
     C                   MOVE      BBDRCS        DDDRCS
 
      *  Location Code
     C                   MOVE      BBLCCD        DDLCCD
 
      *  Customer Name & Adresse 3
     C                   MOVE      BBCNA3        DDCNA3
 
      *  Customer Name & Adresse 4
     C                   MOVE      BBCNA4        DDCNA4
 
      *  Customer Report Name
     C                   MOVEL     BBCRNM        DDCRNM
 
      ** Global Customer ID                                                                   CGP001
                                                                                              CGP001
     C                   IF        CGP001 = 'Y'                                               CGP001
     C                   EVAL      DDGCUS = CUGCUS                                            CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CGP001
      *  Customer Report Town
     C                   MOVEL     BBCRTN        DDCRTN
                                                                                              CSD025
      *  Customer De-Activated fields                                                         CSD025
     C     CSD025        IFEQ      'Y'                                                        CSD025
     C                   MOVEL     BBDEAC        DDDEAC                                       CSD025
     C                   MOVEL     *BLANKS       DDDEDT                                       CSD025
     C     BBDEDT        IFNE      0                                                          CSD025
     C                   Z-ADD     BBDEDT        ZDAYNO                                       CSD025
     C                   EXSR      ZDATE2                                                     CSD025
     C                   MOVEL     ZDATE         DDDEDT                                       CSD025
     C                   ENDIF                                                                CSD025
     C                   ENDIF                                                                CSD025
 
      *  Designated In Currency
     C                   MOVEL     BBDINC        DDDINC
 
      *  Parent Indicator
     C                   MOVE      BBPAIN        DDPAIN
 
      *  Parent Customer Number
     C                   MOVE      BBPCNB        DDPCNB
 
      *  Account Officer Code
     C                   MOVE      BBACOC        DDACOC
 
      *  Customer Alpha Sort Code
     C                   MOVE      BBCASC        DDCASC
 
      *  Branch Indicator
     C                   MOVE      BBBSIN        DDBSIN
 
      *  Country of Citizenship
     C                   MOVE      BBCNCZ        DDCNCZ
 
      *  Alternative Country of Citizenship                                                  CGL132
     C                   MOVE      XCACCZ        DDACCZ                                      CGL132
                                                                                             CGL132
      *  Creation Date                                                                       CGL132
     C     XCCRDT        IFEQ      *ZERO                                                     CGL132
     C                   MOVEL     *BLANKS       DDCRDT                                      CGL132
     C                   ELSE                                                                CGL132
     C                   Z-ADD     XCCRDT        ZDAYNO                                      CGL132
     C                   EXSR      ZDATE2                                                    CGL132
     C                   MOVEL     *BLANKS       DDCRDT                                      CGL132
     C                   MOVEL     ZDATE         DDCRDT                                      CGL132
     C                   ENDIF                                                               CGL132
                                                                                             CGL132
      *  Dormant Indicator                                                                   CGL132
     C                   IF        XCDRMT <> *BLANKS                                         CGL132
     C                   MOVE      XCDRMT        DDDRMT                                      CGL132
     C                   ELSE                                                                CGL132
     C                   MOVE      'N'           DDDRMT                                      CGL132
     C                   ENDIF                                                               CGL132
                                                                                             CGL132
      *  Country of Domicile
     C                   MOVE      BBCOLC        DDCOLC
 
      *  Bank/Non-Bank Indicator
     C                   MOVE      BBBNBI        DDBNBI
 
      *  Suspended Date
     C     BBSSDT        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDSDAL
     C                   ELSE
     C                   Z-ADD     BBSSDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     *BLANKS       DDSDAL
     C                   MOVEL     ZDATE         DDSDAL
     C                   ENDIF
 
      *  Local Institution Code
     C                   MOVE      BBLINC        DDLINC
 
      *  Date of first Contact
     C     BBDOIC        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDFCAL
     C                   ELSE
     C                   Z-ADD     BBDOIC        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     *BLANKS       DDFCAL
     C                   MOVEL     ZDATE         DDFCAL
     C                   ENDIF
 
      *  Local Industry Code
     C                   MOVEL     BBLICD        DDLICD
 
      *  Customer Telephone Number
     C                   MOVEL     BBCTNB        DDCTNB
 
      *  Taxable Indicator
     C                   MOVE      BBTAIN        DDTAIN
 
      *  Reuter Identifier
     C                   MOVE      BBREID        DDREID
 
      *  Branch code
     C                   MOVE      BBBRCD        DDBRCD
 
      *  Customer type
     C                   MOVE      BBCSTY        DDCSTY
 
      *  Allow Deletion in COB
     C                   MOVE      BBCDEL        DDCDEL
 
      *  Risk Weighting Code
     C                   MOVE      BBRWCD        DDRWCD
 
      *  M.A. Analysis by Associated Customer
     C                   MOVE      BBMCAC        DDMCAC
 
      *  Retail Customer Group
     C                   MOVEL     BBCGRP        DDCGRP
 
      *  Margin Type
     C     BBMGTP        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDMTSC
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      BBMGTP        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDMTSC
     C                   ENDIF
 
      *  Private Banking Customer
     C                   MOVEL     BBPRBA        DDPRBA
                                                                                              CLE025
      ** Set Facility Mandatory, Include Offsets, and                                         CLE025
      ** FX Margin Types flags                                                                CLE025
                                                                                              CLE025
     C                   IF        CLE025 = 'Y'                                               CLE025
     C                             OR  CFX001 = 'Y'                                           CFX001
     C                   EVAL      DDFCMF = BBFCMF                                            CLE025
     C                   EVAL      DDINOF = BBINOF                                            CLE025
     C                   EVAL      DDMSTF = BBMSTF                                            CLE025
     C                   EVAL      DDIOPC = BBIOPC                                            CLE025
     C                   ENDIF                                                                CLE025
 
                                                                                              CSW207
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
      ** Investor Capacity Indicator                                                          CSW207
     C                   EVAL      DDCICI = CSCICI                                            CSW207
      ** Party Capacity Indicator                                                             CSW207
     C                   EVAL      DDCPCI = CSCPCI                                            CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** International Business Entity Identifier                                             CSW207
     C                   EVAL      DDIBEI = CSIBEI                                            CSW207
     C/COPY WNCPYSRC,SDH00693
      ***LEIC*code***                                                                CFT050 MD022463
     C**********         EVAL      DDLEIC = CSLEIC                                   CFT050 MD022463
      ***Clearing*System**Code***                                                    CFT050 MD022463
     C**********         EVAL      DDCLSY = CSCLSY                                   CFT050 MD022463
      ** Clearing*Identification***                                                  CFT050 MD022463
     C**********         EVAL      DDCLID = CSCLID                                   CFT050 MD022463
      ***Bank*Directory*Record*Key***                                                CFT050 MD022463
     C**********         EVAL      DDBDRK = CSBDRK                                   CFT050 MD022463
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCN_SECO - SET SECONDARY SCREEN FIELDS
      *****************************************************************
     C     SCN_SECO      BEGSR
      *
      *  Swift Identifier
     C                   MOVEL     BBCSID        DDCSID
      *                                                                                       CSW036
      *  Swift Identifier 2                                                                   CSW036
     C     CSW036        ifeq      'Y'                                                        CSW036
     C                   MOVE      BBCSI2        DDCSI2                                       CSW036
     C                   endif                                                                CSW036
      *                                                                                       CSW036
      *  STTX Address
     C                   MOVE      BBSTAD        DDSTAD
      *
      *  Midas Telex Shortname
     C                   MOVE      BBTXA1        DDTXA1
      *
      *  Corporate Customer
     C                   MOVEL     BBCRPC        DDCRPC
      *
      *  Pseudo Swift Code
     C                   MOVEL     BBPSWC        DDPSWC
      *
      *  SWIFT Financial Instruction
     C                   MOVEL     BBSWFI        DDSWFI
 
      *  Chips ID
     C     BBCHID        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDCIDA
     C                   ELSE
     C**********         MOVE      *BLANKS       ZFIELD                                       211543
     C**********         MOVE      BBCHID        ZFIELD                                       211543
     C**********         Z-ADD     0             ZADEC                                        211543
     C**********         EXSR      ZEDIT                                                      211543
     C**********         MOVE      ZFIELD        DDCIDA                                       211543
     C                   MOVE      BBCHID        DDCIDA                                       211543
     C                   ENDIF
      *
      *  Chaps Sort Code
     C     BBCHSC        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDCSCA
     C                   ELSE
     C**********         MOVE      *BLANKS       ZFIELD                                       211543
     C**********         MOVE      BBCHSC        ZFIELD                                       211543
     C**********         Z-ADD     0             ZADEC                                        211543
     C**********         EXSR      ZEDIT                                                      211543
     C**********         MOVE      ZFIELD        DDCSCA                                       211543
     C                   MOVE      BBCHSC        DDCSCA                                       211543
     C                   ENDIF
      *
      *  Chips 2 ABA screen
     C     S01429        IFEQ      'Y'
     C     BBABA2        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDABAS
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      BBABA2        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDABAS
     C                   ENDIF
     C                   ELSE
     C     BBCABA        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDABAS
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      BBCABA        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDABAS
     C                   ENDIF
      *
     C                   ENDIF
      *
      *  BOJ Fin. Inst. Code
     C                   MOVEL     BBBFIC        DDBFIC
      *
      *  Bankleitzahl Code
     C                   MOVEL     BBBLCD        DDBLCD
      *
      *  Fedwire Code
     C     BBFWCD        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDFWCA
     C                   ELSE
     C**********         MOVE      *BLANKS       ZFIELD                                       211543
     C**********         MOVE      BBFWCD        ZFIELD                                       211543
     C**********         Z-ADD     0             ZADEC                                        211543
     C**********         EXSR      ZEDIT                                                      211543
     C**********         MOVE      ZFIELD        DDFWCA                                       211543
     C                   MOVE      BBFWCD        DDFWCA                                       211543
     C                   ENDIF
 
      *  Stop Statement Download
     C                   MOVE      BBSSDL        DDSSDL
                                                                                              CDL008
      ** CLS Settlement                                                                       CDL008
                                                                                              CDL008
     C     CDL008        IFEQ      'Y'                                                        CDL008
     C                   MOVE      BBCLSS        DDCLSS                                       CDL008
                                                                                              CDL008
      ** Effective Date                                                                       CDL008
                                                                                              CDL008
     C     BBEFDT        IFEQ      *ZERO                                                      CDL008
     C                   MOVE      *BLANKS       DDEFDT                                       CDL008
     C                   ELSE                                                                 CDL008
     C                   Z-ADD     BBEFDT        ZDAYNO                                       CDL008
     C                   EXSR      ZDATE2                                                     CDL008
     C                   MOVEL     *BLANKS       DDEFDT                                       CDL008
     C                   MOVEL     ZDATE         DDEFDT                                       CDL008
     C                   ENDIF                                                                CDL008
     C                   ENDIF                                                                CDL008
     C/COPY WNCPYSRC,SDCUSDNC01
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCN_MSRT - SET MESSAGE ROUTING SCREEN FIELDS
      *****************************************************************
     C     SCN_MSRT      BEGSR
 
      *  Message Types Not Generated No 01
     C                   MOVEL     BBNG01        DDNG01
 
      *  Message Types Not Generated No 02
     C                   MOVEL     BBNG02        DDNG02
 
      *  Message Types Not Generated No 03
     C                   MOVEL     BBNG03        DDNG03
 
      *  Message Types Not Generated No 04
     C                   MOVEL     BBNG04        DDNG04
 
      *  Message Types Not Generated No 05
     C                   MOVEL     BBNG05        DDNG05
 
      *  Message Types Not Generated No 06
     C                   MOVEL     BBNG06        DDNG06
 
      *  Message Types Not Generated No 07
     C                   MOVEL     BBNG07        DDNG07
 
      *  Message Types Not Generated No 08
     C                   MOVEL     BBNG08        DDNG08
 
      *  Message Types Not Generated No 09
     C                   MOVEL     BBNG09        DDNG09
 
      *  Message Types Not Generated No 10
     C                   MOVEL     BBNG10        DDNG10
 
      *  Message Types Not Generated No 11
     C                   MOVEL     BBNG11        DDNG11
 
      *  Message Types Not Generated No 12
     C                   MOVEL     BBNG12        DDNG12
 
      *  Message Types Not Generated No 13
     C                   MOVEL     BBNG13        DDNG13
 
      *  Message Types Not Generated No 14
     C                   MOVEL     BBNG14        DDNG14
 
      *  Message Types Not Generated No 15
     C                   MOVEL     BBNG15        DDNG15
 
 
      *
      ** Default Status Released 01
     C                   MOVEL     BBDS01        DDDS01
 
      ** Default Status Released 02
     C                   MOVEL     BBDS02        DDDS02
 
      ** Default Status Released 03
     C                   MOVEL     BBDS03        DDDS03
 
      ** Default Status Released 04
     C                   MOVEL     BBDS04        DDDS04
 
      ** Default Status Released 05
     C                   MOVEL     BBDS05        DDDS05
 
      ** Default Status Released 06
     C                   MOVEL     BBDS06        DDDS06
 
      ** Default Status Released 07
     C                   MOVEL     BBDS07        DDDS07
 
      ** Default Status Released 08
     C                   MOVEL     BBDS08        DDDS08
 
      ** Default Status Released 09
     C                   MOVEL     BBDS09        DDDS09
 
      ** Default Status Released 10
     C                   MOVEL     BBDS10        DDDS10
 
      ** Default Status Released 11
     C                   MOVEL     BBDS11        DDDS11
 
      ** Default Status Released 12
     C                   MOVEL     BBDS12        DDDS12
 
      ** Default Status Released 13
     C                   MOVEL     BBDS13        DDDS13
 
      ** Default Status Released 14
     C                   MOVEL     BBDS14        DDDS14
 
      ** Default Status Released 15
     C                   MOVEL     BBDS15        DDDS15
 
 
      *
      ** Default Network for MT1nn
     C                   MOVEL     BBDNW1        DDDNW1
 
      ** Default Network for MT2nn
     C                   MOVEL     BBDNW2        DDDNW2
 
      ** Default Network for MT3nn
     C                   MOVEL     BBDNW3        DDDNW3
 
      ** Default Network for MT4nn
     C                   MOVEL     BBDNW4        DDDNW4
 
      ** Default Network for MT5nn
     C                   MOVEL     BBDNW5        DDDNW5
 
      ** Default Network for MT6nn
     C                   MOVEL     BBDNW6        DDDNW6
 
      ** Default Network for MT7nn
     C                   MOVEL     BBDNW7        DDDNW7
 
      ** Default Network for MT8nn
     C                   MOVEL     BBDNW8        DDDNW8
 
      ** Default Network for MT9nn
     C                   MOVEL     BBDNW9        DDDNW9
 
 
     C                   ENDSR
                                                                                              CGL132
      *****************************************************************                       CGL132
      /EJECT                                                                                  CGL132
      *****************************************************************                       CGL132
      ** SCN_FATC - Set FATCA details screen fields                                           CGL132
      *****************************************************************                       CGL132
                                                                                              CGL132
     C     SCN_FATC      BEGSR                                                                CGL132
                                                                                              CGL132
      ** Action Code                                                                          CGL132
     C                   EVAL      DDACTI = DDACTN                                            CGL132
                                                                                              CGL132
      ** Customer Number                                                                      CGL132
     C                   EVAL      DDCUST1 = DDCUSN                                           CGL132
                                                                                              CGL132
      ** FATCA Classification Code                                                            CGL132
     C                   EVAL      DDCLAC = FACLAC                                            CGL132
                                                                                              CGL132
      ** FATCA Classification Date                                                            CGL132
     C                   IF        FACLAD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FACLAD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   EVAL      DDCLAF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDCLAF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDCLAF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Previous FATCA Classification Code                                                   CGL132
     C                   EVAL      DDPCLA = FAPCLA                                            CGL132
                                                                                              CGL132
      ** US Indicium Hold Mail - system value                                                 CGL132
     C                   EVAL      DDHMSV = FAHMSV                                            CGL132
                                                                                              CGL132
      ** US Indicium Hold Mail - system value date                                            CGL132
     C                   IF        FAHMSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FAHMSD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   EVAL      DDHMSF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDHMSF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDHMSF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Hold Mail - system value time                                            CGL132
     C                   EVAL      WFTMST = FAHMST                                            CGL132
     C                   EVAL      DDHMST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDHMST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Hold Mail - override value                                               CGL132
     C                   EVAL      DDHMOV = FAHMOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Hold Mail - override user name                                           CGL132
     C                   EVAL      DDHMON = FAHMON                                            CGL132
                                                                                              CGL132
      ** US Indicium Hold Mail - override date                                                CGL132
     C                   EVAL      DDHMOF = *BLANKS                                           CGL132
     C                   IF        FAHMOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FAHMOD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   MOVEL     ZDATE         DDHMOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Hold Mail - override time                                                CGL132
     C**********         EVAL      DDHMOM = FAHMOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FAHMOT                                          MD026835
     C                   EVAL      DDHMOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDHMOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Hold Mail - override active document                                     CGL132
     C                   EVAL      DDHMD1 = FAHMD1                                            CGL132
     C                   EVAL      DDHMD2 = FAHMD2                                            CGL132
     C                   EVAL      DDHMD3 = FAHMD3                                            CGL132
     C                   EVAL      DDHMD4 = FAHMD4                                            CGL132
     C                   EVAL      DDHMD5 = FAHMD5                                            CGL132
     C                   MOVE      FAHMS1        DDHMS1                                       CGL132
     C                   MOVE      FAHMS2        DDHMS2                                       CGL132
     C                   MOVE      FAHMS3        DDHMS3                                       CGL132
     C                   MOVE      FAHMS4        DDHMS4                                       CGL132
     C                   MOVE      FAHMS5        DDHMS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Hold Mail - comments                                                     CGL132
     C                   EVAL      DDHMC1 = %SUBST(FAHMCO:1:64)                               CGL132
     C                   EVAL      DDHMC2 = %SUBST(FAHMCO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Mailing Country - system value                                           CGL132
     C                   EVAL      DDMCSV = FAMCSV                                            CGL132
                                                                                              CGL132
      ** US Indicium Mailing Country - system value date                                      CGL132
     C                   IF        FAMCSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FAMCSD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   EVAL      DDMCSD = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDMCSD                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDMCSD                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Mailing Country - system value time                                      CGL132
     C                   EVAL      WFTMST = FAMCST                                            CGL132
     C                   EVAL      DDMCST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDMCST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Mailing Country - override value                                         CGL132
     C                   EVAL      DDMCOV = FAMCOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Mailing Country - override user name                                     CGL132
     C                   EVAL      DDMCON = FAMCON                                            CGL132
                                                                                              CGL132
      ** US Indicium Mailing Country - override date                                          CGL132
     C                   EVAL      DDMCOD = *BLANKS                                           CGL132
     C                   IF        FAMCOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FAMCOD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   MOVEL     ZDATE         DDMCOD                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Mailing Country - override time                                          CGL132
     C**********         EVAL      DDMCOT = FAMCOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FAMCOT                                          MD026835
     C                   EVAL      DDMCOT = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDMCOT = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Mailing Country - override active document                               CGL132
     C                   EVAL      DDMCD1 = FAMCD1                                            CGL132
     C                   EVAL      DDMCD2 = FAMCD2                                            CGL132
     C                   EVAL      DDMCD3 = FAMCD3                                            CGL132
     C                   EVAL      DDMCD4 = FAMCD4                                            CGL132
     C                   EVAL      DDMCD5 = FAMCD5                                            CGL132
     C                   MOVE      FAMCS1        DDMCS1                                       CGL132
     C                   MOVE      FAMCS2        DDMCS2                                       CGL132
     C                   MOVE      FAMCS3        DDMCS3                                       CGL132
     C                   MOVE      FAMCS4        DDMCS4                                       CGL132
     C                   MOVE      FAMCS5        DDMCS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Mailing Country - comments                                               CGL132
     C                   EVAL      DDMCC1 = %SUBST(FAMCCO:1:64)                               CGL132
     C                   EVAL      DDMCC2 = %SUBST(FAMCCO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - system value                                    CGL132
     C                   EVAL      DDRPSV = FARPSV                                            CGL132
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - system value date                               CGL132
     C                   IF        FARPSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FARPSD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   EVAL      DDRPSF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDRPSF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDRPSF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - system value time                               CGL132
     C                   EVAL      WFTMST = FARPST                                            CGL132
     C                   EVAL      DDRPST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDRPST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - override value                                  CGL132
     C                   EVAL      DDRPOV = FARPOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - override user name                              CGL132
     C                   EVAL      DDRPON = FARPON                                            CGL132
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - override date                                   CGL132
     C                   EVAL      DDRPOF = *BLANKS                                           CGL132
     C                   IF        FARPOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FARPOD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   MOVEL     ZDATE         DDRPOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - override time                                   CGL132
     C**********         EVAL      DDRPOM = FARPOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FARPOT                                          MD026835
     C                   EVAL      DDRPOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDRPOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - override                                        CGL132
      ** active document                                                                      CGL132
     C                   EVAL      DDRPD1 = FARPD1                                            CGL132
     C                   EVAL      DDRPD2 = FARPD2                                            CGL132
     C                   EVAL      DDRPD3 = FARPD3                                            CGL132
     C                   EVAL      DDRPD4 = FARPD4                                            CGL132
     C                   EVAL      DDRPD5 = FARPD5                                            CGL132
     C                   MOVE      FARPS1        DDRPS1                                       CGL132
     C                   MOVE      FARPS2        DDRPS2                                       CGL132
     C                   MOVE      FARPS3        DDRPS3                                       CGL132
     C                   MOVE      FARPS4        DDRPS4                                       CGL132
     C                   MOVE      FARPS5        DDRPS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Reg Payment Inst to US - comments                                        CGL132
     C                   EVAL      DDRPC1 = %SUBST(FARPCO:1:64)                               CGL132
     C                   EVAL      DDRPC2 = %SUBST(FARPCO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Account Authority Holder - system value                                  CGL132
     C                   EVAL      DDAUSV = FAAUSV                                            CGL132
                                                                                              CGL132
      ** US Indicium Account Authority Holder - system value date                             CGL132
     C                   IF        FAAUSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FAAUSD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   EVAL      DDAUSF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDAUSF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDAUSF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Account Authority Holder - system value time                             CGL132
     C                   EVAL      WFTMST = FAAUST                                            CGL132
     C                   EVAL      DDAUST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDAUST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Account Authority Holder - override value                                CGL132
     C                   EVAL      DDAUOV = FAAUOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Account Authority Holder - override user name                            CGL132
     C                   EVAL      DDAUON = FAAUON                                            CGL132
                                                                                              CGL132
      ** US Indicium Account Authority Holder - override date                                 CGL132
     C                   EVAL      DDAUOF = *BLANKS                                           CGL132
     C                   IF        FAAUOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FAAUOD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   MOVEL     ZDATE         DDAUOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Account Authority Holder - override time                                 CGL132
     C**********         EVAL      DDAUOM = FAAUOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FAAUOT                                          MD026835
     C                   EVAL      DDAUOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDAUOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Account Authority Holder - override                                      CGL132
      ** active document                                                                      CGL132
     C                   EVAL      DDAUD1 = FAAUD1                                            CGL132
     C                   EVAL      DDAUD2 = FAAUD2                                            CGL132
     C                   EVAL      DDAUD3 = FAAUD3                                            CGL132
     C                   EVAL      DDAUD4 = FAAUD4                                            CGL132
     C                   EVAL      DDAUD5 = FAAUD5                                            CGL132
     C                   MOVE      FAAUS1        DDAUS1                                       CGL132
     C                   MOVE      FAAUS2        DDAUS2                                       CGL132
     C                   MOVE      FAAUS3        DDAUS3                                       CGL132
     C                   MOVE      FAAUS4        DDAUS4                                       CGL132
     C                   MOVE      FAAUS5        DDAUS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Account Authority Holder - comments                                      CGL132
     C                   EVAL      DDAUC1 = %SUBST(FAAUCO:1:64)                               CGL132
     C                   EVAL      DDAUC2 = %SUBST(FAAUCO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Citizenship - system value                                               CGL132
     C                   EVAL      DDCISV = FACISV                                            CGL132
                                                                                              CGL132
      ** US Indicium Citizenship - system value date                                          CGL132
     C                   IF        FACISD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FACISD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   EVAL      DDCISF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDCISF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDCISF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Citizenship - system value time                                          CGL132
     C                   EVAL      WFTMST = FACIST                                            CGL132
     C                   EVAL      DDCIST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDCIST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Citizenship - override value                                             CGL132
     C                   EVAL      DDCIOV = FACIOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Citizenship - override user name                                         CGL132
     C                   EVAL      DDCION = FACION                                            CGL132
                                                                                              CGL132
      ** US Indicium Citizenship - override date                                              CGL132
     C                   EVAL      DDCIOF = *BLANKS                                           CGL132
     C                   IF        FACIOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FACIOD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   MOVEL     ZDATE         DDCIOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Citizenship - override time                                              CGL132
     C**********         EVAL      DDCIOM = FACIOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FACIOT                                          MD026835
     C                   EVAL      DDCIOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDCIOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Citizenship - override active document                                   CGL132
     C                   EVAL      DDCID1 = FACID1                                            CGL132
     C                   EVAL      DDCID2 = FACID2                                            CGL132
     C                   EVAL      DDCID3 = FACID3                                            CGL132
     C                   EVAL      DDCID4 = FACID4                                            CGL132
     C                   EVAL      DDCID5 = FACID5                                            CGL132
     C                   MOVE      FACIS1        DDCIS1                                       CGL132
     C                   MOVE      FACIS2        DDCIS2                                       CGL132
     C                   MOVE      FACIS3        DDCIS3                                       CGL132
     C                   MOVE      FACIS4        DDCIS4                                       CGL132
     C                   MOVE      FACIS5        DDCIS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Citizenship - comments                                                   CGL132
     C                   EVAL      DDCIC1 = %SUBST(FACICO:1:64)                               CGL132
     C                   EVAL      DDCIC2 = %SUBST(FACICO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - system value                                          CGL132
     C                   EVAL      DDCBSV = FACBSV                                            CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - system value date                                     CGL132
     C                   IF        FACBSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FACBSD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   EVAL      DDCBSF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDCBSF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDCBSF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - system value time                                     CGL132
     C                   EVAL      WFTMST = FACBST                                            CGL132
     C                   EVAL      DDCBST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDCBST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - override value                                        CGL132
     C                   EVAL      DDCBOV = FACBOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - override user name                                    CGL132
     C                   EVAL      DDCBON = FACBON                                            CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - override date                                         CGL132
     C                   EVAL      DDCBOF = *BLANKS                                           CGL132
     C                   IF        FACBOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FACBOD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   MOVEL     ZDATE         DDCBOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - override time                                         CGL132
     C**********         EVAL      DDCBOM = FACBOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FACBOT                                          MD026835
     C                   EVAL      DDCBOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDCBOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - override active document                              CGL132
     C                   EVAL      DDCBD1 = FACBD1                                            CGL132
     C                   EVAL      DDCBD2 = FACBD2                                            CGL132
     C                   EVAL      DDCBD3 = FACBD3                                            CGL132
     C                   EVAL      DDCBD4 = FACBD4                                            CGL132
     C                   EVAL      DDCBD5 = FACBD5                                            CGL132
     C                   MOVE      FACBS1        DDCBS1                                       CGL132
     C                   MOVE      FACBS2        DDCBS2                                       CGL132
     C                   MOVE      FACBS3        DDCBS3                                       CGL132
     C                   MOVE      FACBS4        DDCBS4                                       CGL132
     C                   MOVE      FACBS5        DDCBS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Country of Birth - comments                                              CGL132
     C                   EVAL      DDCBC1 = %SUBST(FACBCO:1:64)                               CGL132
     C                   EVAL      DDCBC2 = %SUBST(FACBCO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Country of Domicile - system value                                       CGL132
     C                   EVAL      DDCDSV = FACDSV                                            CGL132
                                                                                              CGL132
      ** US Indicium Country of Domicile - system value date                                  CGL132
     C                   IF        FACDSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FACDSD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   EVAL      DDCDSF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDCDSF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDCDSF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Country of Domicile - system value time                                  CGL132
     C                   EVAL      WFTMST = FACDST                                            CGL132
     C                   EVAL      DDCDST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDCDST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Country of Domicile - override value                                     CGL132
     C                   EVAL      DDCDOV = FACDOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Country of Domicile - override user name                                 CGL132
     C                   EVAL      DDCDON = FACDON                                            CGL132
                                                                                              CGL132
      ** US Indicium Country of Domicile - override date                                      CGL132
     C                   EVAL      DDCDOF = *BLANKS                                           CGL132
     C                   IF        FACDOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FACDOD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   MOVEL     ZDATE         DDCDOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Country of Domicile - override time                                      CGL132
     C**********         EVAL      DDCDMM = FACDOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FACDOT                                          MD026835
     C                   EVAL      DDCDMM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDCDMM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Country of Domicile - override active document                           CGL132
     C                   EVAL      DDCDD1 = FACDD1                                            CGL132
     C                   EVAL      DDCDD2 = FACDD2                                            CGL132
     C                   EVAL      DDCDD3 = FACDD3                                            CGL132
     C                   EVAL      DDCDD4 = FACDD4                                            CGL132
     C                   EVAL      DDCDD5 = FACDD5                                            CGL132
     C                   MOVE      FACDS1        DDCDS1                                       CGL132
     C                   MOVE      FACDS2        DDCDS2                                       CGL132
     C                   MOVE      FACDS3        DDCDS3                                       CGL132
     C                   MOVE      FACDS4        DDCDS4                                       CGL132
     C                   MOVE      FACDS5        DDCDS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Country of Domicile - comments                                           CGL132
     C                   EVAL      DDCDC1 = %SUBST(FACDCO:1:64)                               CGL132
     C                   EVAL      DDCDC2 = %SUBST(FACDCO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Green Card - system value                                                CGL132
     C                   EVAL      DDGCSV = FAGCSV                                            CGL132
                                                                                              CGL132
      ** US Indicium Green Card - system value date                                           CGL132
     C                   IF        FAGCSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FAGCSD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   EVAL      DDGCSF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDGCSF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDGCSF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Green Card - system value time                                           CGL132
     C                   EVAL      WFTMST = FAGCST                                            CGL132
     C                   EVAL      DDGCST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDGCST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Green Card - override value                                              CGL132
     C                   EVAL      DDGCOV = FAGCOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Green Card - override user name                                          CGL132
     C                   EVAL      DDGCON = FAGCON                                            CGL132
                                                                                              CGL132
      ** US Indicium Green Card - override date                                               CGL132
     C                   EVAL      DDGCOF = *BLANKS                                           CGL132
     C                   IF        FAGCOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FAGCOD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   MOVEL     ZDATE         DDGCOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Green Card - override time                                               CGL132
     C**********         EVAL      DDGCOM = FAGCOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FAGCOT                                          MD026835
     C                   EVAL      DDGCOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDGCOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Green Card - override active document                                    CGL132
     C                   EVAL      DDGCD1 = FAGCD1                                            CGL132
     C                   EVAL      DDGCD2 = FAGCD2                                            CGL132
     C                   EVAL      DDGCD3 = FAGCD3                                            CGL132
     C                   EVAL      DDGCD4 = FAGCD4                                            CGL132
     C                   EVAL      DDGCD5 = FAGCD5                                            CGL132
     C                   MOVE      FAGCS1        DDGCS1                                       CGL132
     C                   MOVE      FAGCS2        DDGCS2                                       CGL132
     C                   MOVE      FAGCS3        DDGCS3                                       CGL132
     C                   MOVE      FAGCS4        DDGCS4                                       CGL132
     C                   MOVE      FAGCS5        DDGCS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Green Card - comments                                                    CGL132
     C                   EVAL      DDGCC1 = %SUBST(FAGCCO:1:64)                               CGL132
     C                   EVAL      DDGCC2 = %SUBST(FAGCCO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Identity Document - system value                                         CGL132
     C                   EVAL      DDIDSV = FAIDSV                                            CGL132
                                                                                              CGL132
      ** US Indicium Identity Document - system value date                                    CGL132
     C                   IF        FAIDSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FAIDSD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   EVAL      DDIDSF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDIDSF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDIDSF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Identity Document - system value time                                    CGL132
     C                   EVAL      WFTMST = FAIDST                                            CGL132
     C                   EVAL      DDIDST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDIDST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Identity Document - override value                                       CGL132
     C                   EVAL      DDIDOV = FAIDOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Identity Document - override user name                                   CGL132
     C                   EVAL      DDIDON = FAIDON                                            CGL132
                                                                                              CGL132
      ** US Indicium Identity Document - override date                                        CGL132
     C                   EVAL      DDIDOF = *BLANKS                                           CGL132
     C                   IF        FAIDOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FAIDOD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   MOVEL     ZDATE         DDIDOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Identity Document - override time                                        CGL132
     C**********         EVAL      DDIDOM = FAIDOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FAIDOT                                          MD026835
     C                   EVAL      DDIDOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDIDOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Identity Document - override                                             CGL132
      ** active document                                                                      CGL132
     C                   EVAL      DDIDD1 = FAIDD1                                            CGL132
     C                   EVAL      DDIDD2 = FAIDD2                                            CGL132
     C                   EVAL      DDIDD3 = FAIDD3                                            CGL132
     C                   EVAL      DDIDD4 = FAIDD4                                            CGL132
     C                   EVAL      DDIDD5 = FAIDD5                                            CGL132
     C                   MOVE      FAIDS1        DDIDS1                                       CGL132
     C                   MOVE      FAIDS2        DDIDS2                                       CGL132
     C                   MOVE      FAIDS3        DDIDS3                                       CGL132
     C                   MOVE      FAIDS4        DDIDS4                                       CGL132
     C                   MOVE      FAIDS5        DDIDS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Identity Document - comments                                             CGL132
     C                   EVAL      DDIDC1 = %SUBST(FAIDCO:1:64)                               CGL132
     C                   EVAL      DDIDC2 = %SUBST(FAIDCO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Joint Account Member - system value                                      CGL132
     C                   EVAL      DDJASV = FAJASV                                            CGL132
                                                                                              CGL132
      ** US Indicium Joint Account Member - system value date                                 CGL132
     C                   IF        FAJASD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FAJASD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   EVAL      DDJASF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDJASF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDJASF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Joint Account Member - system value time                                 CGL132
     C                   EVAL      WFTMST = FAJAST                                            CGL132
     C                   EVAL      DDJAST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDJAST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Joint Account Member - override value                                    CGL132
     C                   EVAL      DDJAOV = FAJAOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Joint Account Member - override user name                                CGL132
     C                   EVAL      DDJAON = FAJAON                                            CGL132
                                                                                              CGL132
      ** US Indicium Joint Account Member - override date                                     CGL132
     C                   EVAL      DDJAOF = *BLANKS                                           CGL132
     C                   IF        FAJAOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FAJAOD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   MOVEL     ZDATE         DDJAOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Joint Account Member - override time                                     CGL132
     C**********         EVAL      DDJAOM = FAJAOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FAJAOT                                          MD026835
     C                   EVAL      DDJAOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDJAOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Joint Account Member - override active document                          CGL132
     C                   EVAL      DDJAD1 = FAJAD1                                            CGL132
     C                   EVAL      DDJAD2 = FAJAD2                                            CGL132
     C                   EVAL      DDJAD3 = FAJAD3                                            CGL132
     C                   EVAL      DDJAD4 = FAJAD4                                            CGL132
     C                   EVAL      DDJAD5 = FAJAD5                                            CGL132
     C                   MOVE      FAJAS1        DDJAS1                                       CGL132
     C                   MOVE      FAJAS2        DDJAS2                                       CGL132
     C                   MOVE      FAJAS3        DDJAS3                                       CGL132
     C                   MOVE      FAJAS4        DDJAS4                                       CGL132
     C                   MOVE      FAJAS5        DDJAS5                                       CGL132
                                                                                              CGL132
      ** US Indicium Joint Account Member - comments                                          CGL132
     C                   EVAL      DDJAC1 = %SUBST(FAJACO:1:64)                               CGL132
     C                   EVAL      DDJAC2 = %SUBST(FAJACO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium Telephone - system value                                                 CGL132
     C                   EVAL      DDTESV = FATESV                                            CGL132
                                                                                              CGL132
      ** US Indicium Telephone - system value date                                            CGL132
     C                   IF        FATESD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FATESD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   EVAL      DDTESF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDTESF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDTESF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Telephone - system value time                                            CGL132
     C                   EVAL      WFTMST = FATEST                                            CGL132
     C                   EVAL      DDTEST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDTEST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Telephone - override value                                               CGL132
     C                   EVAL      DDTEOV = FATEOV                                            CGL132
                                                                                              CGL132
      ** US Indicium Telephone - override user name                                           CGL132
     C                   EVAL      DDTEON = FATEON                                            CGL132
                                                                                              CGL132
      ** US Indicium Telephone - override date                                                CGL132
     C                   EVAL      DDTEOF = *BLANKS                                           CGL132
     C                   IF        FATEOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FATEOD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   MOVEL     ZDATE         DDTEOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium Telephone - override time                                                CGL132
     C**********         EVAL      DDTEOM = FATEOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FATEOT                                          MD026835
     C                   EVAL      DDTEOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDTEOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium Telephone - override active document                                     CGL132
     C                   EVAL      DDTED1 = FATED1                                            CGL132
     C                   EVAL      DDTED2 = FATED2                                            CGL132
     C                   EVAL      DDTED3 = FATED3                                            CGL132
     C                   EVAL      DDTED4 = FATED4                                            CGL132
     C                   EVAL      DDTED5 = FATED5                                            CGL132
     C                   MOVE      FATES1        DDTES1                                       CGL132
     C                   MOVE      FATES2        DDTES2                                       CGL132
     C                   MOVE      FATES3        DDTES3                                       CGL132
     C                   MOVE      FATES4        DDTES4                                       CGL132
     C                   MOVE      FATES5        DDTES5                                       CGL132
                                                                                              CGL132
      ** US Indicium Telephone - comments                                                     CGL132
     C                   EVAL      DDTEC1 = %SUBST(FATECO:1:64)                               CGL132
     C                   EVAL      DDTEC2 = %SUBST(FATECO:65:64)                              CGL132
                                                                                              CGL132
      ** US Indicium TIN - system value                                                       CGL132
     C                   EVAL      DDTXSV = FATXSV                                            CGL132
                                                                                              CGL132
      ** US Indicium TIN - system value time                                                  CGL132
     C                   EVAL      WFTMST = FATXST                                            CGL132
     C                   EVAL      DDTXST = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDTXST = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium TIN - system value date                                                  CGL132
     C                   IF        FATXSD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FATXSD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   EVAL      DDTXSF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDTXSF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDTXSF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium TIN - override value                                                     CGL132
     C                   EVAL      DDTXOV = FATXOV                                            CGL132
                                                                                              CGL132
      ** US Indicium TIN - override user name                                                 CGL132
     C                   EVAL      DDTXON = FATXON                                            CGL132
                                                                                              CGL132
      ** US Indicium TIN - override date                                                      CGL132
     C                   EVAL      DDTXOF = *BLANKS                                           CGL132
     C                   IF        FATXOD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FATXOD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   MOVEL     ZDATE         DDTXOF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** US Indicium TIN - override time                                                      CGL132
     C**********         EVAL      DDTXOM = FATXOT                                   CGL132 MD026835
     C                   EVAL      WFTMST = FATXOT                                          MD026835
     C                   EVAL      DDTXOM = *BLANKS                                         MD026835
     C                   IF        WFTMST <> *BLANKS                                        MD026835
     C                   EVAL      DDTXOM = WWHH + ':' + WWMM +                             MD026835
     C                                      ':' + WWSS                                      MD026835
     C                   ENDIF                                                              MD026835
                                                                                              CGL132
      ** US Indicium TIN - override active document                                           CGL132
     C                   EVAL      DDTXD1 = FATXD1                                            CGL132
     C                   EVAL      DDTXD2 = FATXD2                                            CGL132
     C                   EVAL      DDTXD3 = FATXD3                                            CGL132
     C                   EVAL      DDTXD4 = FATXD4                                            CGL132
     C                   EVAL      DDTXD5 = FATXD5                                            CGL132
     C                   MOVE      FATXS1        DDTXS1                                       CGL132
     C                   MOVE      FATXS2        DDTXS2                                       CGL132
     C                   MOVE      FATXS3        DDTXS3                                       CGL132
     C                   MOVE      FATXS4        DDTXS4                                       CGL132
     C                   MOVE      FATXS5        DDTXS5                                       CGL132
                                                                                              CGL132
      ** US Indicium TIN - comments                                                           CGL132
     C                   EVAL      DDTXC1 = %SUBST(FATXCO:1:64)                               CGL132
     C                   EVAL      DDTXC2 = %SUBST(FATXCO:65:64)                              CGL132
                                                                                              CGL132
      ** Exempt from FATCA                                                                    CGL132
     C                   EVAL      DDEXEM = FAEXEM                                            CGL132
                                                                                              CGL132
      ** Exemption date                                                                       CGL132
     C                   IF        FAEXED <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FAEXED                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   EVAL      DDEXEF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDEXEF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDEXEF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Exemption time                                                                       CGL132
     C                   EVAL      WFTMST = FAEXET                                            CGL132
     C                   EVAL      DDEXET = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDEXET = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   EVAL      DDEXEU = FAEXEU                                            CGL132
                                                                                              CGL132
      ** Exemption Remark                                                                     CGL132
     C                   EVAL      DDEXE1 = %SUBST(FAEXER:1:64)                               CGL132
     C                   EVAL      DDEXE2 = %SUBST(FAEXER:65:64)                              CGL132
     C                   EVAL      DDEXE3 = %SUBST(FAEXER:129:64)                             CGL132
     C                   EVAL      DDEXE4 = %SUBST(FAEXER:193:64)                             CGL132
                                                                                              CGL132
      ** Subject to Reporting                                                                 CGL132
     C                   EVAL      DDREPT = FAREPT                                            CGL132
                                                                                              CGL132
      ** GIIN                                                                                 CGL132
     C                   EVAL      DDGIIN = FAGIIN                                            CGL132
                                                                                              CGL132
      ** GIIN # Last Veri Date                                                                CGL132
     C                   IF        FAGIID <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FAGIID                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   EVAL      DDGIIF = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDGIIF                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDGIIF                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** GIIN Owner                                                                           CGL132
     C                   EVAL      DDGIIO = FAGIIO                                            CGL132
                                                                                              CGL132
      ** US Tax Identification Number                                                         CGL132
     C                   EVAL      DDUTIN = FAUTIN                                            CGL132
                                                                                              CGL132
      ** US Green Card                                                                        CGL132
     C                   EVAL      DDGREC = FAGREC                                            CGL132
                                                                                              CGL132
      ** Mailing Address                                                                      CGL132
     C                   EVAL      DDMAIL = FAMAIL                                            CGL132
                                                                                              CGL132
      ** US Phone Number                                                                      CGL132
     C                   EVAL      DDPHON = FAPHON                                            CGL132
                                                                                              CGL132
      ** FATCA Customer Type                                                                  CGL132
     C                   EVAL      DDCSTP = FACSTY                                            CGL132
                                                                                              CGL132
      ** FATCA Customer Sub Type                                                              CGL132
     C                   EVAL      DDCSST = FACSST                                            CGL132
                                                                                              CGL132
      ** Reporting Type                                                                       CGL132
     C                   EVAL      DDRPTT = FARPTT                                            CGL132
                                                                                              CGL132
      ** Reporting Type Remark                                                                CGL132
     C                   EVAL      DDRPT1 = %SUBST(FARPTR:1:64)                               CGL132
     C                   EVAL      DDRPT2 = %SUBST(FARPTR:65:64)                              CGL132
                                                                                              CGL132
      ** Reporting type date                                                                  CGL132
     C                   IF        FARPTD <> 0                                                CGL132
     C                   EVAL      ZDAYNO = FARPTD                                            CGL132
     C                   EXSR      ZDATE2                                                     CGL132
     C                   EVAL      DDRPTD = *BLANKS                                           CGL132
     C                   MOVEL     ZDATE         DDRPTD                                       CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVE      *BLANKS       DDRPTD                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Reporting type time                                                                  CGL132
     C                   EVAL      WFTMST = FARPTM                                            CGL132
     C                   EVAL      DDRPTM = *BLANKS                                           CGL132
     C                   IF        WFTMST <> *BLANKS                                          CGL132
     C                   EVAL      DDRPTM = WWHH + ':' + WWMM +                               CGL132
     C                                      ':' + WWSS                                        CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   EVAL      DDRPTU = FARPTU                                            CGL132
                                                                                              CGL132
      ** High Value Account                                                                   CGL132
     C                   EVAL      DDHVAC = FAHVAC                                            CGL132
                                                                                              CGL132
      ** FATCA Information complete                                                           CGL132
     C                   EVAL      DDINFC = FAINFC                                            CGL132
                                                                                              CGL132
      ** Exception Management Flag                                                            CGL132
     C                   EVAL      DDEXMA = FAEXMA                                            CGL132
                                                                                              CGL132
      ** Exception Management Identifier                                                      CGL132
     C                   EVAL      DDEXID = FAEXID                                            CGL132
                                                                                              CGL132
     C                   ENDSR                                                                CGL132
                                                                                              CGL132
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCN_BRTX - SET BASE RATE TAX SCREEN FIELDS
      *****************************************************************
     C     SCN_BRTX      BEGSR
 
      *  1st Party Name
      *  Holder 1 title
     C                   MOVE      H1TITL        DD1TTL
 
      **  Holder 1 name
     C                   MOVE      H1NAME        DD1NAM
 
      **  Holder 1 initials
     C                   MOVE      H1INIT        DD1INI
 
      **  Holder 1 BRT liable
     C                   MOVE      H1BRTL        DD1BRT
 
      **  Holder 1 address 1
     C                   MOVE      H1ADR1        DD1AD1
 
      **  Holder 1 National Insurance No
     C                   MOVE      H1NINO        DD1NIN
 
      **  Holder 1 address 2
     C                   MOVE      H1ADR2        DD1AD2
 
      **  Holder 1 Date of Birth
     C     H1DOB         IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DD1DOB
     C                   ELSE
     C                   MOVEL     H1DOB         DD1DOB
     C                   ENDIF
 
      **  Holder 1 address 3
     C                   MOVE      H1ADR3        DD1AD3
 
      **  Holder 1 Postcode 1
     C                   MOVE      H1PCD1        DD1PC1
 
      **  Holder 1 Postcode 2
     C                   MOVE      H1PCD2        DD1PC2
 
      **  Holder 1 Status  (Is this a new participant?)
      **  Default to 'N'
     C*JCA*              MOVE      ' '           DD1STS
     C                   MOVE      'N'           DD1STS
 
      ** 2nd Party Name
      *  Holder 2 title
     C                   MOVE      H2TITL        DD2TTL
 
      **  Holder 2 name
     C                   MOVE      H2NAME        DD2NAM
 
      **  Holder 2 initials
     C                   MOVE      H2INIT        DD2INI
 
      **  Holder 2 BRT liable
     C                   MOVE      H2BRTL        DD2BRT
 
      **  Holder 2 address 1
     C                   MOVE      H2ADR1        DD2AD1
 
      **  Holder 2 National Insurance No
     C                   MOVE      H2NINO        DD2NIN
 
      **  Holder 2 address 2
     C                   MOVE      H2ADR2        DD2AD2
 
      **  Holder 2 Date of Birth
     C     H2DOB         IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DD2DOB
     C                   ELSE
     C                   MOVEL     H2DOB         DD2DOB
     C                   ENDIF
 
      **  Holder 2 address 3
     C                   MOVE      H2ADR3        DD2AD3
 
      **  Holder 2 Postcode 1
     C                   MOVE      H2PCD1        DD2PC1
 
      **  Holder 2 Postcode 2
     C                   MOVE      H2PCD2        DD2PC2
 
      **  Holder 2 Status  (Is this a new participant?)
      **  Default to 'N'
     C*JCA*              MOVE      ' '           DD2STS
     C                   MOVE      'N'           DD2STS
 
      ** 3rd Party Name
      *  Holder 3 title
     C                   MOVE      H3TITL        DD3TTL
 
      **  Holder 3 name
     C                   MOVE      H3NAME        DD3NAM
 
      **  Holder 3 initials
     C                   MOVE      H3INIT        DD3INI
 
      **  Holder 3 BRT liable
     C                   MOVE      H3BRTL        DD3BRT
 
      **  Holder 3 address 1
     C                   MOVE      H3ADR1        DD3AD1
 
      **  Holder 3 National Insurance No
     C                   MOVE      H3NINO        DD3NIN
 
      **  Holder 3 address 2
     C                   MOVE      H3ADR2        DD3AD2
 
      **  Holder 3 Date of Birth
     C     H3DOB         IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DD3DOB
     C                   ELSE
     C                   MOVEL     H3DOB         DD3DOB
     C                   ENDIF
 
      **  Holder 3 address 3
     C                   MOVE      H3ADR3        DD3AD3
 
      **  Holder 3 Postcode 1
     C                   MOVE      H3PCD1        DD3PC1
 
      **  Holder 3 Postcode 2
     C                   MOVE      H3PCD2        DD3PC2
 
      **  Holder 3 Status  (Is this a new participant?)
      **  Default to 'N'
     C*JCA*              MOVE      ' '           DD3STS
     C                   MOVE      'N'           DD3STS
 
      ** 4th Party Name
      *  Holder 4 title
     C                   MOVE      H4TITL        DD4TTL
 
      **  Holder 4 name
     C                   MOVE      H4NAME        DD4NAM
 
      **  Holder 4 initials
     C                   MOVE      H4INIT        DD4INI
 
      **  Holder 4 BRT liable
     C                   MOVE      H4BRTL        DD4BRT
 
      **  Holder 4 address 1
     C                   MOVE      H4ADR1        DD4AD1
 
      **  Holder 4 National Insurance No
     C                   MOVE      H4NINO        DD4NIN
 
      **  Holder 4 address 2
     C                   MOVE      H4ADR2        DD4AD2
 
      **  Holder 4 Date of Birth
     C     H4DOB         IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DD4DOB
     C                   ELSE
     C                   MOVEL     H4DOB         DD4DOB
     C                   ENDIF
 
      **  Holder 4 address 3
     C                   MOVE      H4ADR3        DD4AD3
 
      **  Holder 4 Postcode 1
     C                   MOVE      H4PCD1        DD4PC1
 
      **  Holder 4 Postcode 2
     C                   MOVE      H4PCD2        DD4PC2
 
      **  Holder 4 Status  (Is this a new participant?)
      **  Default to 'N'
     C*JCA*              MOVE      ' '           DD4STS
     C                   MOVE      'N'           DD4STS
 
      ** 5th Party Name
      *  Holder 5 title
     C                   MOVE      H5TITL        DD5TTL
 
      **  Holder 5 name
     C                   MOVE      H5NAME        DD5NAM
 
      **  Holder 5 initials
     C                   MOVE      H5INIT        DD5INI
 
      **  Holder 5 BRT liable
     C                   MOVE      H5BRTL        DD5BRT
 
      **  Holder 5 address 1
     C                   MOVE      H5ADR1        DD5AD1
 
      **  Holder 5 National Insurance No
     C                   MOVE      H5NINO        DD5NIN
 
      **  Holder 5 address 2
     C                   MOVE      H5ADR2        DD5AD2
 
      **  Holder 5 Date of Birth
     C     H5DOB         IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DD5DOB
     C                   ELSE
     C                   MOVEL     H5DOB         DD5DOB
     C                   ENDIF
 
      **  Holder 5 address 3
     C                   MOVE      H5ADR3        DD5AD3
 
      **  Holder 5 Postcode 1
     C                   MOVE      H5PCD1        DD5PC1
 
      **  Holder 5 Postcode 2
     C                   MOVE      H5PCD2        DD5PC2
 
      **  Holder 5 Status  (Is this a new participant?)
      **  Default to 'N'
     C*JCA*              MOVE      ' '           DD5STS
     C                   MOVE      'N'           DD5STS
 
      **  Tax Indicator
     C                   MOVEL     TAXIND        DDTXIN
 
      **  Post 5/4/01 R105                                                                    CRE007
     C                   MOVE      PSTR          DDPSTR                                       CRE007
                                                                                              CRE007
      **  Further Parties indicator
     C                   MOVEL     ' '           DDFPAR
     C     H3NAME        IFNE      *BLANK
     C                   MOVEL     'Y'           DDFPAR
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCN_PRIV - SET PRIVATE BANKING SCREEN FIELDS
      *****************************************************************
     C     SCN_PRIV      BEGSR
      *
      *  Hold Mail Indicator
     C                   MOVE      A_PBHOLD      A_DDHOLD
      *
      *  Numbered Account Indicator
     C                   MOVE      A_PBNUAC      A_DDNUAC
      *
      *  Agent
     C     A_PBAGEN      IFEQ      *ZERO
     C                   MOVEL     *BLANKS       A_DDAGEN
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      A_PBAGEN      ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        A_DDAGEN
     C                   ENDIF
      *
      *  Valid Counterparty
     C                   MOVE      A_PBCOUN      A_DDCOUN
      *
      *  Requested PB Customer
     C                   MOVEL     A_PBREPB      A_DDREPB
 
      *  Private Banking Start Date
     C     A_PBPBST      IFEQ      *ZERO
     C                   MOVEL     *BLANKS       A_DDPBST
     C                   ELSE
     C                   Z-ADD     A_PBPBST      ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     *BLANKS       A_DDPBST
     C                   MOVEL     ZDATE         A_DDPBST
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSW024
      ** SCN_MT3X - SET MT3XX BEI & FUND SCREEN FIELDS                                        CSW024
      *****************************************************************                       CSW024
     C     SCN_MT3X      BEGSR                                                                CSW024
      *                                                                                       CSW024
      ** Corporate customer flag                                                              CSW024
     C                   MOVE      BBCORP        DDCORP                                       CSW024
      *                                                                                       CSW024
      ** Corporate BEI                                                                        CSW024
     C                   MOVE      BBCBEI        DDCBEI                                       CSW024
      *                                                                                       CSW024
      ** MT3xx Receiver Party Information 1                                                   CSW024
     C                   MOVE      BBRI01        DDRI01                                       CSW024
      *                                                                                       CSW024
      ** MT3xx Receiver Party Information 2                                                   CSW024
     C                   MOVE      BBRI02        DDRI02                                       CSW024
      *                                                                                       CSW024
      ** MT3xx Receiver Party Information 3                                                   CSW024
     C                   MOVE      BBRI03        DDRI03                                       CSW024
      *                                                                                       CSW024
      ** MT3xx Receiver Party Information 4                                                   CSW024
     C                   MOVE      BBRI04        DDRI04                                       CSW024
      *                                                                                       CSW024
      ** MT3xx Receiver Party Information 5                                                   CSW024
     C                   MOVE      BBRI05        DDRI05                                       CSW024
      *                                                                                       CSW024
      ** Fund Identification                                                                  CSW024
     C                   MOVE      BBFUND        DDFUND                                       CSW024
     C     CSW037        IFEQ      'Y'                                                        CSW037
     C                   MOVE      BBFNAC        DDFNAC                                       CSW037
     C                   ENDIF                                                                CSW037
                                                                                              CSW024
     C                   ENDSR                                                                CSW024
      *****************************************************************                       CSW024
      /EJECT                                                                                  CSW024
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *                       CSD079
      * ZALIGN - ALIGN an unsigned field                              *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     ZALIGN        BEGSR                                                                CSD079
                                                                                              CSD079
     C                   CALLB     'ZALIGN'                                                   CSD079
     C     W0RTN         PARM      *BLANKS       W0RTN                                        CSD079
     C     ZFIELD        PARM                    ZFIELD                                       CSD079
     C                   PARM                    ZADEC                                        CSD079
     C                   PARM                    ZUDIG                                        CSD079
     C     ZUZAFF        PARM      *BLANK        ZUZAFF                                       CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      * SRCurr - Access Currency Details                              *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C     SRCurr        BEGSR                                                                CSD079
                                                                                              CSD079
      ** Access currency details using deal currency                                          CSD079
                                                                                              CSD079
     C                   CALLB     'AOCURRR0'                                                 CSD079
     C                   PARM                    PRtnCde                                      CSD079
     C                   PARM      '*KEY   '     POptn                                        CSD079
     C                   PARM      BHCYCD        PAJCD                                        CSD079
     C     SDCURR        PARM      SDCURR        DSSDY                                        CSD079
                                                                                              CSD079
      ** Database error                                                                       CSD079
                                                                                              CSD079
     C                   IF        PRtnCde <> *BLANK                                          CSD079
     C     *LOCK         IN        LDA                                                        CSD079
     C                   EVAL      DBKEY = PAJCD                                              CSD079
     C                   EVAL      DBFILE = 'SDCURRPD'                                        CSD079
     C                   EVAL      DBASE = 003                                                CSD079
     C                   OUT       LDA                                                        CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ELSE                                                                 CSD079
     C                   Z-ADD     A6NBDP        ZADEC                                        CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** BLANK OUTPUTS (EXCEPT FOR ACTION CODE WITHIN CUSTOMER FORMATS)
      *
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        CuPrim
     C                   MOVEL     *BLANK        CuCuXC                                       CGL132
     C                   MOVEL     *BLANK        CuFATC                                       CGL132
     C                   MOVEL     *BLANK        CuSwft                                       CSW207
     C                   MOVEL     *BLANK        CuSeco
     C                   MOVEL     *BLANK        CuMT3X                                       CSW024
     C                   MOVEL     *BLANK        CuMsrt
     C                   MOVEL     *BLANK        CuBrtx
     C                   MOVEL     *BLANK        CuPriv
     C                   MOVEL     *BLANK        TranInCumi                                   CSD079
     C                   MOVEL     *BLANK        TranInCuad                                   CSD079
     C                   MOVEL     *BLANK        TranInACU3                                   CER059
     C                   MOVEL     *BLANK        TranInACU4                                   CER059
     C                   MOVEL     *BLANK        TranInSfee                                   CSD079
     C                   MOVEL     *BLANK        TranInCufx                                   CSD079
     C                   MOVEL     *BLANK        TranInCufd                                   CSD079
     C                   MOVEL     *BLANK        TranInChec                                   CSD079
     C                   MOVEL     *BLANK        TranInCusf                                   CSD079
     C                   MOVEL     *BLANK        TranInRwan                                   CSD079
     C                   MOVEL     *BLANK        TranInCufo                                   CSD079
     C                   MOVEL     *BLANK        TranInCupm                                   CSD079
     C                   MOVEL     *BLANK        TranInTicd                                   CSD079
     C                   MOVEL     *BLANK        TranInCtnm                                AR1086546
     C                   MOVEL     ##ACTN        DDACTN
     C/COPY WNCPYSRC,SDH00694
 
      *
     C                   ENDSR
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  SCN_CUMI - SET Customer Marketing Info SCREEN FIELDS         *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
      *                                                                                       CSD079
     C     SCN_CUMI      BEGSR                                                                CSD079
                                                                                              CSD079
      ** Group 1                                                                              CSD079
                                                                                              CSD079
     C                   EVAL      DDGPC1 = D7GPC1                                            CSD079
                                                                                              CSD079
      ** Group 2                                                                              CSD079
                                                                                              CSD079
     C                   EVAL      DDGPC2 = D7GPC2                                            CSD079
                                                                                              CSD079
      ** Group 3                                                                              CSD079
                                                                                              CSD079
     C                   EVAL      DDGPC3 = D7GPC3                                            CSD079
                                                                                              CSD079
      ** Group 4                                                                              CSD079
                                                                                              CSD079
     C                   EVAL      DDGPC4 = D7GPC4                                            CSD079
                                                                                              CSD079
      ** Group 5                                                                              CSD079
                                                                                              CSD079
     C                   EVAL      DDGPC5 = D7GPC5                                            CSD079
                                                                                              CSD079
      ** Customer Segmentation Code                                                           CSD090
                                                                                              CSD090
     C                   IF        CSD090 = 'Y'                                               CSD090
     C                   EVAL      DDCSDE = D7CSDE                                            CSD090
     C                   ENDIF                                                                CSD090
                                                                                              CSD090
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  SCN_CUAD - SET Additional Customer SCREEN FIELDS             *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
      *                                                                                       CSD079
     C     SCN_CUAD      BEGSR                                                                CSD079
                                                                                              CSD079
      ** Alternative Number                                                                   CSD079
                                                                                              CSD079
     C                   EVAL      DDALTN = E5ALTN                                            CSD079
                                                                                              CSD079
      ** Fax Number                                                                           CSD079
                                                                                              CSD079
     C                   EVAL      DDFXNB = E5FXNB                                            CSD079
                                                                                              CSD079
      ** Identity Number                                                                      CSD079
                                                                                              CSD079
     C                   EVAL      DDIDNO = E5IDNO                                            CSD079
                                                                                              CSD079
      ** Telex Number                                                                         CSD079
                                                                                              CSD079
     C                   EVAL      DDTXNB = E5TXNB                                            CSD079
                                                                                              CSD079
      ** Date of Birth                                                                        CSD079
                                                                                              CSD079
     C     E5BRTH        IFEQ      *ZERO                                                      CSD079
     C     E5BRT1        ANDEQ     *BLANKS                                                    CSD079
     C     E5BRTH        OREQ      *ZERO                                                      CSD079
     C     E5BRT1        ANDEQ     '000000'                                                   CSD079
     C                   EVAL      DDBRTH = *BLANKS                                           CSD079
     C                   ELSE                                                                 CSD079
     C     E5BRTH        IFNE      *ZERO                                                      CSD079
     C                   EVAL      ZDAYNO = E5BRTH                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   EVAL      DDBRTH = *BLANKS                                           CSD079
     C                   MOVE      ZDATE         #DDOBY                                       CSD079
     C                   MOVEL     ZDATE         #DDOBZ                                       CSD079
     C     #DDOBZ        MULT      10000         #DDOBN                                       CSD079
     C     #DDOBY        IFGE      72                                                         CSD079
     C     #DDOBY        ADD       1900          #DDOBZ                                       CSD079
     C                   ELSE                                                                 CSD079
     C     #DDOBY        ADD       2000          #DDOBZ                                       CSD079
     C                   ENDIF                                                                CSD079
     C                   ADD       #DDOBZ        #DDOBN                                       CSD079
     C                   MOVEL     #DDOBN        DDBRTH                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVE      E5BRT1        ##YY                                         CSD079
     C                   MOVEL     E5BRT1        ##DAT1                                       CSD079
     C                   MOVEL     E5BRT2        ##CC                                         CSD079
     C                   MOVEL     ##DOB         DDBRTH                                       CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Provisional Opening                                                                  CSD079
                                                                                              CSD079
     C                   EVAL      DDPRVO = E5PRVO                                            CSD079
                                                                                              CSD079
      ** Date of Last Visit                                                                   CSD079
                                                                                              CSD079
     C                   IF        E5DOLV = *ZERO                                             CSD079
     C                   EVAL      DDDOLV = *BLANKS                                           CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      ZDAYNO = E5DOLV                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   EVAL      DDDOLV = *BLANKS                                           CSD079
     C                   MOVEL     ZDATE         DDDOLV                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Mail Details                                                                         CSD079
                                                                                              CSD079
     C                   EVAL      DDMDTL = E5MDTL                                            CSD079
                                                                                              CSD079
      ** Cust. Name & Address 1                                                               CSD079
                                                                                              CSD079
     C                   EVAL      A2_DDCNA1 = E5CNA1                                         CSD079
                                                                                              CSD079
      ** Cust. Name & Address 2                                                               CSD079
                                                                                              CSD079
     C                   EVAL      A3_DDCNA2 = E5CNA2                                         CSD079
                                                                                              CSD079
      ** Cust. Name & Address 3                                                               CSD079
                                                                                              CSD079
     C                   EVAL      A4_DDCNA3 = E5CNA3                                         CSD079
                                                                                              CSD079
      ** Cust. Name & Address 4                                                               CSD079
                                                                                              CSD079
     C                   EVAL      A8_DDCNA4 = E5CNA4                                         CSD079
                                                                                              CSD079
      ** Code Word One                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDCWL1 = E5CWL1                                            CSD079
                                                                                              CSD079
      ** Code Word Two                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDCWL2 = E5CWL2                                            CSD079
                                                                                              CSD079
      ** Code Word Three                                                                      CSD079
                                                                                              CSD079
     C                   EVAL      DDCWL3 = E5CWL3                                            CSD079
                                                                                              CSD079
      ** Code Word Four                                                                       CSD079
                                                                                              CSD079
     C                   EVAL      DDCWL4 = E5CWL4                                            CSD079
                                                                                              CSD079
      ** Code Word Five                                                                       CSD079
                                                                                              CSD079
     C                   EVAL      DDCWL5 = E5CWL5                                            CSD079
                                                                                              CSD079
      ** City                                                                                 CSD079
                                                                                              CSD079
     C                   EVAL      DDCITY = E5CITY                                            CSD079
                                                                                              CSD079
      ** Zip Code                                                                             CSD079
                                                                                              CSD079
     C                   EVAL      DDZIPC = E5ZIPC                                            CSD079
                                                                                              CSD079
      ** Tax Identification Number                                                            CSD079
                                                                                              CSD079
     C                   EVAL      DDTINO = E5TINO                                            CSD079
                                                                                              CSD079
      ** Identification Type                                                                  CSD079
                                                                                              CSD079
     C                   EVAL      DDIDTP = E5IDTP                                            CSD079
                                                                                              CSD079
      ** Issuing Country                                                                      CSD079
                                                                                              CSD079
     C                   EVAL      DDISCT = E5ISCT                                            CSD079
                                                                                              CSD079
      ** Issuing Date                                                                         CSD079
                                                                                              CSD079
     C                   EVAL      DDISDT = E5ISDT                                            CSD079
                                                                                              CSD079
      ** Birth Date                                                                           CSD079
                                                                                              CSD079
     C                   EVAL      DDDBTH = E5DBTH                                            CSD079
                                                                                              CSD079
      ** Place of Birth - Country                                                             CSD079
                                                                                              CSD079
     C                   EVAL      DDBTHC = E5BTHC                                            CSD079
                                                                                              CSD079
      ** Place of Birth - Town                                                                CSD079
                                                                                              CSD079
     C                   EVAL      DDBTHT = E5BTHT                                            CSD079
                                                                                              CSD079
      ** Joint Account Type                                                                   CSD079
                                                                                              CSD079
     C                   EVAL      DDJATP = E5JATP                                            CSD079
                                                                                              CSD079
      ** Replication Indicator                                                                CSD079
                                                                                              CSD079
     C                   EVAL      DDREPI = E5REPI                                            CSD079
                                                                                              CSD079
      ** Field 01 Details                                                                     CSD079
                                                                                              CSD079
     C                   EVAL      DDF001 = E5FL01                                            CSD079
                                                                                              CSD079
      ** Field 02 Details                                                                     CSD079
                                                                                              CSD079
     C                   EVAL      DDF002 = E5FL02                                            CSD079
                                                                                              CSD079
      ** Field 03 Details                                                                     CSD079
                                                                                              CSD079
     C                   EVAL      DDF003 = E5FL03                                            CSD079
                                                                                              CSD079
      ** Field 04 Details                                                                     CSD079
                                                                                              CSD079
     C                   EVAL      DDF004 = E5FL04                                            CSD079
                                                                                              CSD079
      ** Field 05 Details                                                                     CSD079
                                                                                              CSD079
     C                   EVAL      DDF005 = E5FL05                                            CSD079
                                                                                              CSD079
      ** Field 06 Details                                                                     CSD079
                                                                                              CSD079
     C                   EVAL      DDF006 = E5FL06                                            CSD079
                                                                                              CSD079
      ** Field 7 Details                                                                      CSD079
                                                                                              CSD079
     C                   EVAL      DDF007 = E5FL07                                            CSD079
                                                                                              CSD079
      ** Field 8 Details                                                                      CSD079
                                                                                              CSD079
     C                   EVAL      DDF008 = E5FL08                                            CSD079
                                                                                              CSD079
      ** Field 9 Details                                                                      CSD079
                                                                                              CSD079
     C                   EVAL      DDF009 = E5FL09                                            CSD079
                                                                                              CSD079
      ** Field 10 Details                                                                     CSD079
                                                                                              CSD079
     C                   EVAL      DDF010 = E5FL10                                            CSD079
                                                                                              CSD079
      ** Issuer Code                                                                        BUG14992
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                             BUG14992
     C                   EVAL      DDISCD = E5ISCD                                          BUG14992
     C                   ELSE                                                               BUG14992
     C                   EVAL      DDISCD = *BLANKS                                         BUG14992
     C                   ENDIF                                                              BUG14992
                                                                                            BUG14992
      ** Title                                                                                CER059
     C                   EVAL      DDTITL = E5TITL                                            CER059
                                                                                              CER059
      ** Expiry Date                                                                          CER059
     C                   IF        E5EXDT = *ZERO                                             CER059
     C                   EVAL      DDEXDT = *BLANKS                                           CER059
     C                   ELSE                                                                 CER059
     C                   EVAL      ZDAYNO = E5EXDT                                            CER059
     C                   EXSR      ZDATE2                                                     CER059
     C                   EVAL      DDEXDT = *BLANKS                                           CER059
     C                   MOVEL     ZDATE         DDEXDT                                       CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Remarks 1                                                                            CER059
     C                   EVAL      DDREM1 = E5REM1                                            CER059
                                                                                              CER059
      ** Remarks 2                                                                            CER059
     C                   EVAL      DDREM2 = E5REM2                                            CER059
                                                                                              CER059
      ** Remarks 3                                                                            CER059
     C                   EVAL      DDREM3 = E5REM3                                            CER059
                                                                                              CER059
      ** Subject to §24c                                                                      CER059
     C                   EVAL      DDS24C = E5S24C                                            CER059
                                                                                              CER059
      ** Language ID                                                                          CER059
     C                   EVAL      DDLNID = E5LNID                                            CER059
                                                                                              CER059
      ** Correspondent Type                                                                   CER059
     C                   EVAL      DDCTYP = E5CTYP                                            CER059
                                                                                              CER059
      ** Zero Confirmation Flag                                                               CER059
     C                   EVAL      DDZCFG = E5ZCFG                                            CER059
                                                                                              CER059
      ** FX Customer                                                                          CER059
     C                   EVAL      DDFXCU = E5FXCU                                            CER059
                                                                                              CER059
      ** Securities Customer                                                                  CER059
     C                   EVAL      DDSECU = E5SECU                                            CER059
                                                                                              CER059
      ** Staff Member                                                                         CER059
     C                   EVAL      DDSMBR = E5SMBR                                            CER059
                                                                                              CER059
      ** Maiden Name                                                                          CER059
     C                   EVAL      DDMDNM = E5MDNM                                            CER059
                                                                                              CER059
      ** Spouse Reference                                                                     CER059
     C                   EVAL      DDSHRF = E5SHRF                                            CER059
                                                                                              CER059
      ** Partner/Associate Indicator                                                          CER059
     C                   EVAL      DDPIND = E5PIND                                            CER059
                                                                                              CER059
      ** Exemption Threshold                                                                  CER059
     C                   IF        E5EXTH <> *ZERO                                            CER059
     C                   MOVE      E5EXTH        DDEXTH                                       CER059
     C                   ELSE                                                                 CER059
     C                   MOVE      *BLANKS       DDEXTH                                       CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Exemption Threshold Approval Date                                                    CER059
     C                   IF        E5EADT = *ZERO                                             CER059
     C                   EVAL      DDEADT = *BLANKS                                           CER059
     C                   ELSE                                                                 CER059
     C                   EVAL      ZDAYNO = E5EADT                                            CER059
     C                   EXSR      ZDATE2                                                     CER059
     C                   EVAL      DDEADT = *BLANKS                                           CER059
     C                   MOVEL     ZDATE         DDEADT                                       CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Exemption Threshold Value Date                                                       CER059
     C                   IF        E5EVDT = *ZERO                                             CER059
     C                   EVAL      DDEVDT = *BLANKS                                           CER059
     C                   ELSE                                                                 CER059
     C                   EVAL      ZDAYNO = E5EVDT                                            CER059
     C                   EXSR      ZDATE2                                                     CER059
     C                   EVAL      DDEVDT = *BLANKS                                           CER059
     C                   MOVEL     ZDATE         DDEVDT                                       CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Exemption Threshold Expiry Date                                                      CER059
     C                   IF        E5ETXT = *ZERO                                             CER059
     C                   EVAL      DDETXT = *BLANKS                                           CER059
     C                   ELSE                                                                 CER059
     C                   EVAL      ZDAYNO = E5ETXT                                            CER059
     C                   EXSR      ZDATE2                                                     CER059
     C                   EVAL      DDETXT = *BLANKS                                           CER059
     C                   MOVEL     ZDATE         DDETXT                                       CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Identification Document No/Id                                                        CER059
     C                   EVAL      DDDCNM = E5DCID                                            CER059
                                                                                              CER059
      ** Identification Document Issued Place                                                 CER059
     C                   EVAL      DDISPL = E5DIPL                                            CER059
                                                                                              CER059
      ** Characteristic of Demand/Claim                                                       CER059
     C                   EVAL      DDCDCL = E5CDCL                                            CER059
                                                                                              CER059
      ** Sate Code                                                                            CER059
     C                   EVAL      DDSTCD = E5STCD                                            CER059
                                                                                              CER059
      ** Religious Affiliation Code                                                           CER059
     C                   EVAL      DDRLAF = E5RLAF                                            CER059
                                                                                              CER059
      ** Borrower Sector Classification Code                                                  CER059
     C                   IF        E5BSCC <> *ZERO                                            CER059
     C                   MOVEL     E5BSCC        DDBSCC                                       CER059
     C                   ELSE                                                                 CER059
     C                   MOVEL     *BLANK        DDBSCC                                       CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Economic Activity Code                                                               CER059
     C                   EVAL      DDECAC = E5ECAC                                            CER059
                                                                                              CER059
      ** Borrower Sector Classification/BISTA                                                 CER059
     C                   IF        E5BIST <> *ZERO                                            CER059
     C                   MOVEL     E5BIST        DDBIST                                       CER059
     C                   ELSE                                                                 CER059
     C                   MOVEL     *BLANK        DDBIST                                       CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
      ** Additional Borrowers Statistics Key                                                  CER059
     C                   EVAL      DDABSK = E5ABSK                                            CER059
                                                                                              CER059
      ** Customer Required for Bundesbank Reporting                                           CER059
     C                   EVAL      DDBEXT = E5BEXT                                            CER059
                                                                                              CER070
      ** Risk Classification / BISTRA                                                         CER070
     C                   EVAL      DDRIGR = E5RIGR                                            CER070
                                                                                              CER071
      ** Legal Form                                                                           CER071
     C                   EVAL      DDRECH = E5RECH                                            CER071
      *                                                                                       CLE134
      ** Past Due Processing                                                                  CLE134
      *                                                                                       CLE134
     C                   IF        CLE134 = 'Y'                                               CLE134
     C                   EVAL      DDPDCU = E5PDCU                                            CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CER059
      ** Alternative Tax Identification Numbers and TIN Countries                             CGL132
     C                   EVAL      DDTIN2 = E5TIN2                                            CGL132
     C                   EVAL      DDTNC2 = E5TNC2                                            CGL132
     C                   EVAL      DDTIN3 = E5TIN3                                            CGL132
     C                   EVAL      DDTNC3 = E5TNC3                                            CGL132
     C                   EVAL      DDTIN4 = E5TIN4                                            CGL132
     C                   EVAL      DDTNC4 = E5TNC4                                            CGL132
     C                   EVAL      DDTIN5 = E5TIN5                                            CGL132
     C                   EVAL      DDTNC5 = E5TNC5                                            CGL132
                                                                                              CGL157
      ** Effective Date 1                                                                     CGL157
     C                   IF        E5EFF1 = *ZERO                                             CGL157
     C                   EVAL      DDEFF1 = *BLANKS                                           CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      ZDAYNO = E5EFF1                                            CGL157
     C                   EXSR      ZDATE2                                                     CGL157
     C                   EVAL      DDEFF1 = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         DDEFF1                                       CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** Expiry Date 1                                                                        CGL157
     C                   IF        E5EXP1 = *ZERO                                             CGL157
     C                   EVAL      DDEXP1 = *BLANKS                                           CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      ZDAYNO = E5EXP1                                            CGL157
     C                   EXSR      ZDATE2                                                     CGL157
     C                   EVAL      DDEXP1 = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         DDEXP1                                       CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** Effective Date 2                                                                     CGL157
     C                   IF        E5EFF2 = *ZERO                                             CGL157
     C                   EVAL      DDEFF2 = *BLANKS                                           CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      ZDAYNO = E5EFF2                                            CGL157
     C                   EXSR      ZDATE2                                                     CGL157
     C                   EVAL      DDEFF2 = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         DDEFF2                                       CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** Expiry Date 2                                                                        CGL157
     C                   IF        E5EXP2 = *ZERO                                             CGL157
     C                   EVAL      DDEXP2 = *BLANKS                                           CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      ZDAYNO = E5EXP2                                            CGL157
     C                   EXSR      ZDATE2                                                     CGL157
     C                   EVAL      DDEXP2 = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         DDEXP2                                       CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** Effective Date 3                                                                     CGL157
     C                   IF        E5EFF3 = *ZERO                                             CGL157
     C                   EVAL      DDEFF3 = *BLANKS                                           CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      ZDAYNO = E5EFF3                                            CGL157
     C                   EXSR      ZDATE2                                                     CGL157
     C                   EVAL      DDEFF3 = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         DDEFF3                                       CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** Expiry Date 3                                                                        CGL157
     C                   IF        E5EXP3 = *ZERO                                             CGL157
     C                   EVAL      DDEXP3 = *BLANKS                                           CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      ZDAYNO = E5EXP3                                            CGL157
     C                   EXSR      ZDATE2                                                     CGL157
     C                   EVAL      DDEXP3 = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         DDEXP3                                       CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** Effective Date 4                                                                     CGL157
     C                   IF        E5EFF4 = *ZERO                                             CGL157
     C                   EVAL      DDEFF4 = *BLANKS                                           CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      ZDAYNO = E5EFF4                                            CGL157
     C                   EXSR      ZDATE2                                                     CGL157
     C                   EVAL      DDEFF4 = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         DDEFF4                                       CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** Expiry Date 4                                                                        CGL157
     C                   IF        E5EXP4 = *ZERO                                             CGL157
     C                   EVAL      DDEXP4 = *BLANKS                                           CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      ZDAYNO = E5EXP4                                            CGL157
     C                   EXSR      ZDATE2                                                     CGL157
     C                   EVAL      DDEXP4 = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         DDEXP4                                       CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** Effective Date 5                                                                     CGL157
     C                   IF        E5EFF5 = *ZERO                                             CGL157
     C                   EVAL      DDEFF5 = *BLANKS                                           CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      ZDAYNO = E5EFF5                                            CGL157
     C                   EXSR      ZDATE2                                                     CGL157
     C                   EVAL      DDEFF5 = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         DDEFF5                                       CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** Expiry Date 5                                                                        CGL157
     C                   IF        E5EXP5 = *ZERO                                             CGL157
     C                   EVAL      DDEXP5 = *BLANKS                                           CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      ZDAYNO = E5EXP5                                            CGL157
     C                   EXSR      ZDATE2                                                     CGL157
     C                   EVAL      DDEXP5 = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         DDEXP5                                       CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        CGL157 = 'Y'                                               CGL157
                                                                                              CGL157
     C                   CLEAR                   PCrsdS                                       CGL157
     C                   EVAL      X = 1                                                      CGL157
     C                   DOW       X < 31                                                     CGL157
     C                   EVAL      PCRSDT = *Blanks                                           CGL157
     C                   EVAL      TranCrsd = PCrsdF(X)                                       CGL157
     C                   IF        CVCTRY <> *Blanks                                          CGL157
     C                   EVAL      DDCTRY = CVCTRY                                            CGL157
     C                   EVAL      DDREPQ = CVREPT                                            CGL157
     C                   EVAL      DDREP1 = CVREPR                                            CGL157
     C                   MOVE      CVREPR        DDREP2                                       CGL157
                                                                                              CGL157
     C                   EVAL      DDREPD = *BLANKS                                           CGL157
     C                   IF        CVREPD <> *ZERO                                            CGL157
     C                   EVAL      ZDAYNO = CVREPD                                            CGL157
     C                   EXSR      ZDATE2                                                     CGL157
     C                   EVAL      DDREPD = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         DDREPD                                       CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      DDREPM = CVREPM                                            CGL157
     C                   EVAL      DDREPU = CVREPU                                            CGL157
     C                   EVAL      DDEVD1 = CVEVE1                                            CGL157
     C                   MOVE      CVEVS1        DDEVS1                                       CGL157
     C                   EVAL      DDEVD2 = CVEVE2                                            CGL157
     C                   MOVE      CVEVS2        DDEVS2                                       CGL157
     C                   EVAL      DDEVD3 = CVEVE3                                            CGL157
     C                   MOVE      CVEVS3        DDEVS3                                       CGL157
     C                   EVAL      DDEVD4 = CVEVE4                                            CGL157
     C                   MOVE      CVEVS4        DDEVS4                                       CGL157
     C                   EVAL      DDEVD5 = CVEVE5                                            CGL157
     C                   MOVE      CVEVS5        DDEVS5                                       CGL157
     C                   EVAL      DDTINN = CVTINN                                            CGL157
     C                   EVAL      DDCODO = CVCODO                                            CGL157
     C                   EVAL      DDJACM = CVJACM                                            CGL157
     C                   EVAL      DDMAIQ = CVMAIL                                            CGL157
     C                   EVAL      DDPHOQ = CVPHON                                            CGL157
     C                   EVAL      DDRPAY = CVRPAY                                            CGL157
     C                   EVAL      DDTINS = CVTINS                                            CGL177
     C                   EVAL      DDAUHO = CVAUHO                                            CGL177
                                                                                              CGL157
      ** Get CRS agreement                                                                    CGL157
     C                   EVAL      WCNCD = DDCTRY                                             CGL157
     C                   EVAL      WCOLC = BBCOLC                                             CGL157
                                                                                              CGL157
     C                   CALL      'AOCTTXR0'                                                 CGL157
     C                   PARM      *BLANKS       PRTCD                                        CGL157
     C                   PARM      '*KEY   '     POPTN                                        CGL157
     C                   PARM      WCNCD         @PCTRT                                       CGL157
     C                   PARM      WCOLC         @PCTRR                                       CGL157
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        CGL157
                                                                                              CGL157
     C                   IF        PRTCD = '*NRF   '                                          CGL157
     C                   EVAL      WCOLC = *BLANK                                             CGL157
     C                   CALL      'AOCTTXR0'                                                 CGL157
     C                   PARM      *BLANKS       PRTCD                                        CGL157
     C                   PARM      '*KEY   '     POPTN                                        CGL157
     C                   PARM      WCNCD         @PCTRT                                       CGL157
     C                   PARM      WCOLC         @PCTRR                                       CGL157
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        CGL157
                                                                                              CGL157
     C                   IF        PRTCD = *BLANK                                             CGL157
     C                   EVAL      DDCRSA = EWCRSA                                            CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      DDCRSA = *Blanks                                           CGL157
     C                   ENDIF                                                                CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      DDCRSA = EWCRSA                                            CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      DDEFFD = *BLANKS                                           CGL157
     C                   IF        CVEFFD <> *ZERO                                            CGL157
     C                   EVAL      ZDAYNO = CVEFFD                                            CGL157
     C                   EXSR      ZDATE2                                                     CGL157
     C                   EVAL      DDEFFD = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         DDEFFD                                       CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      DDEXPD = *BLANKS                                           CGL157
     C                   IF        CVEXPD <> *ZERO                                            CGL157
     C                   EVAL      ZDAYNO = CVEXPD                                            CGL157
     C                   EXSR      ZDATE2                                                     CGL157
     C                   EVAL      DDEXPD = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         DDEXPD                                       CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
     C                   EVAL      PCrsdS(X) = PCrsdT                                         CGL157
     C                   EVAL      X = X + 1                                                  CGL157
     C                   ENDDO                                                                CGL157
     C                   ENDIF                                                                CGL157
      ** Mailing Countries                                                                    CGL157
     C                   EVAL      DDCTR1 = E5CTR1                                            CGL157
     C                   EVAL      DDCTR2 = E5CTR2                                            CGL157
     C                   EVAL      DDCTR3 = E5CTR3                                            CGL157
     C                   EVAL      DDCTR4 = E5CTR4                                            CGL157
     C                   EVAL      DDCTR5 = E5CTR5                                            CGL157
                                                                                              CGL157
      ** Phone Number Countries                                                               CGL157
     C                   EVAL      DDPHN1 = E5PHN1                                            CGL157
     C                   EVAL      DDPHN2 = E5PHN2                                            CGL157
     C                   EVAL      DDPHN3 = E5PHN3                                            CGL157
     C                   EVAL      DDPHN4 = E5PHN4                                            CGL157
     C                   EVAL      DDPHN5 = E5PHN5                                            CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
                                                                                              CGL157
      *****************************************************************                       CGL157
      /EJECT                                                                                  CGL157
      *****************************************************************                       CGL157
      *                                                               *                       CGL157
      * SRCRSScn - Set CRS Screen Fields                              *                       CGL157
      *                                                               *                       CGL157
      *****************************************************************                       CGL157
     C     SRCRSScn      BEGSR                                                                CGL157
                                                                                              CGL157
      ** CRS Customer Details if CGL157 is ON                                                 CGL157
     C                   IF        CGL157 = 'Y'                                               CGL157
     C                   EVAL      A_DDCUSN = DDCUST                                        MD035388
     C                   EVAL      A_DDTYPE = CRTYPE                                          CGL157
     C                   EVAL      A_DDSTYP = CRSTYP                                          CGL157
     C                   EVAL      A_DDHVAL = CRHVAL                                          CGL157
     C                   EVAL      A_DDEXMP = CREXMP                                          CGL157
      ** Exemption date                                                                       CGL157
     C                   IF        CREXMD <> 0                                                CGL157
     C                   EVAL      ZDAYNO = CREXMD                                            CGL157
     C                   EXSR      ZDATE2                                                     CGL157
     C                   EVAL      A_DDEXMF = *BLANKS                                         CGL157
     C                   MOVEL     ZDATE         A_DDEXMF                                     CGL157
     C                   ELSE                                                                 CGL157
     C                   MOVE      *BLANKS       A_DDEXMF                                     CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** Exemption time                                                                       CGL157
     C                   EVAL      WFTMST = CREXMT                                            CGL157
     C                   EVAL      A_DDEXMT = *BLANKS                                         CGL157
     C                   IF        WFTMST <> *BLANKS                                          CGL157
     C                   EVAL      A_DDEXMT = WWHH + ':' + WWMM +                             CGL157
     C                                      ':' + WWSS                                        CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      A_DDEXMU = CREXMU                                          CGL157
                                                                                              CGL157
      ** CRS Info Complete Flag                                                               CGL157
     C                   EVAL      A_DDINFO = CRINFO                                          CGL157
                                                                                              CGL157
      ** CRS Exception Management                                                             CGL157
     C                   EVAL      A_DDEXMG = CREXMG                                          CGL157
                                                                                              CGL157
      ** CRS Exception Management ID                                                          CGL157
     C                   EVAL      A_DDEXMI = CREXMI                                          CGL157
                                                                                              CGL157
     C                   EVAL      A_DDEXM1 = %SUBST(CREXMR:1:64)                             CGL157
     C                   EVAL      A_DDEXM2 = %SUBST(CREXMR:65:64)                            CGL157
     C                   EVAL      A_DDEXM3 = %SUBST(CREXMR:129:64)                           CGL157
     C                   EVAL      A_DDEXM4 = %SUBST(CREXMR:193:64)                           CGL157
                                                                                              CGL157
      ** CRS Country Details                                                                  CGL157
     C                   CLEAR                   PCrsdS                                       CGL157
     C                   EVAL      X = 1                                                      CGL157
     C                   DOW       X < 31                                                     CGL157
     C                   EVAL      PCRSDT = *Blanks                                           CGL157
     C                   EVAL      TranCrsd = PCrsdF(X)                                       CGL157
     C                   IF        CVCTRY <> *Blanks                                          CGL157
     C                   EVAL      DDCTRY = CVCTRY                                            CGL157
     C                   EVAL      DDREPT = CVREPT                                            CGL157
     C                   EVAL      DDREP1 = CVREPR                                            CGL157
     C                   MOVE      CVREPR        DDREP2                                       CGL157
                                                                                              CGL157
     C                   EVAL      DDREPD = *BLANKS                                           CGL157
     C                   IF        CVREPD <> *ZERO                                            CGL157
     C                   EVAL      ZDAYNO = CVREPD                                            CGL157
     C                   EXSR      ZDate2                                                     CGL157
     C                   EVAL      DDREPD = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         DDREPD                                       CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      DDREPM = CVREPM                                            CGL157
     C                   EVAL      DDREPU = CVREPU                                            CGL157
     C                   EVAL      DDEVD1 = CVEVE1                                            CGL157
     C                   MOVE      CVEVS1        DDEVS1                                       CGL157
     C                   EVAL      DDEVD2 = CVEVE2                                            CGL157
     C                   MOVE      CVEVS2        DDEVS2                                       CGL157
     C                   EVAL      DDEVD3 = CVEVE3                                            CGL157
     C                   MOVE      CVEVS3        DDEVS3                                       CGL157
     C                   EVAL      DDEVD4 = CVEVE4                                            CGL157
     C                   MOVE      CVEVS4        DDEVS4                                       CGL157
     C                   EVAL      DDEVD5 = CVEVE5                                            CGL157
     C                   MOVE      CVEVS5        DDEVS5                                       CGL157
     C                   EVAL      DDTINN = CVTINN                                            CGL157
     C                   EVAL      DDCODO = CVCODO                                            CGL157
     C                   EVAL      DDJACM = CVJACM                                            CGL157
     C**********         EVAL      DDMAIL = CVMAIL                                   CGL157 MD051191
     C**********         EVAL      DDPHON = CVPHON                                   CGL157 MD051191
     C                   EVAL      DDMAIQ = CVMAIL                                          MD051191
     C                   EVAL      DDPHOQ = CVPHON                                          MD051191
     C                   EVAL      DDRPAY = CVRPAY                                            CGL157
     C                   EVAL      DDTINS = CVTINS                                            CGL177
                                                                                              CGL157
      ** Get CRS agreement                                                                    CGL157
     C                   EVAL      WCNCD = DDCTRY                                             CGL157
     C                   EVAL      WCOLC = BBCOLC                                             CGL157
                                                                                              CGL157
     C                   CALL      'AOCTTXR0'                                                 CGL157
     C                   PARM      *BLANKS       PRTCD                                        CGL157
     C                   PARM      '*KEY   '     POPTN                                        CGL157
     C                   PARM      WCNCD         @PCTRT                                       CGL157
     C                   PARM      WCOLC         @PCTRR                                       CGL157
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        CGL157
                                                                                              CGL157
     C                   IF        PRTCD = '*NRF   '                                          CGL157
     C                   EVAL      WCOLC = *BLANK                                             CGL157
     C                   CALL      'AOCTTXR0'                                                 CGL157
     C                   PARM      *BLANKS       PRTCD                                        CGL157
     C                   PARM      '*KEY   '     POPTN                                        CGL157
     C                   PARM      WCNCD         @PCTRT                                       CGL157
     C                   PARM      WCOLC         @PCTRR                                       CGL157
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        CGL157
                                                                                              CGL157
     C                   IF        PRTCD = *BLANK                                             CGL157
     C                   EVAL      DDCRSA = EWCRSA                                            CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      DDCRSA = *Blanks                                           CGL157
     C                   ENDIF                                                                CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      DDCRSA = EWCRSA                                            CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      DDEFFD = *BLANKS                                           CGL157
     C                   IF        CVEFFD <> *ZERO                                            CGL157
     C                   EVAL      ZDAYNO = CVEFFD                                            CGL157
     C                   EXSR      ZDate2                                                     CGL157
     C                   EVAL      DDEFFD = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         DDEFFD                                       CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      DDEXPD = *BLANKS                                           CGL157
     C                   IF        CVEXPD <> *ZERO                                            CGL157
     C                   EVAL      ZDAYNO = CVEXPD                                            CGL157
     C                   EXSR      ZDate2                                                     CGL157
     C                   EVAL      DDEXPD = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         DDEXPD                                       CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
     C                   EVAL      PCrsdS(X) = PCrsdT                                         CGL157
     C                   EVAL      X = X + 1                                                  CGL157
     C                   ENDDO                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  SCN_SFEE - SET Service Fees SCREEN FIELDS                    *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
      *                                                                                       CSD079
     C     SCN_SFEE      BEGSR                                                                CSD079
                                                                                              CSD079
      ** Settlement Account                                                                   CSD079
                                                                                              CSD079
     C                   EVAL      DDSMAC = E6SMAC                                            CSD079
                                                                                              CSD079
      ** Hold Mail Indicator                                                                  CSD079
                                                                                              CSD079
     C                   EVAL      DDHMIN = E6HMIN                                            CSD079
                                                                                              CSD079
      ** Numbered A/c Indicator                                                               CSD079
                                                                                              CSD079
     C                   EVAL      DDNAIN = E6NAIN                                            CSD079
                                                                                              CSD079
      ** Profit Centre                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDPFCD = E6PFCD                                            CSD079
                                                                                              CSD079
      ** Pft Cntr For Num A/C Chrg                                                            CSD079
                                                                                              CSD079
     C                   EVAL      DDPCAC = E6PCAC                                            CSD079
                                                                                              CSD079
      ** Pft Cntr For Hold Mail                                                               CSD079
                                                                                              CSD079
     C                   EVAL      DDPCHM = E6PCHM                                            CSD079
                                                                                              CSD079
      ** Vat on Service Fees                                                                  CSD079
                                                                                              CSD079
     C                   EVAL      DDTAIF = E6TAIF                                            CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  SCN_CHEC - SET Cheque and Card Details SCREEN FIELDS         *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
      *                                                                                       CSD079
     C     SCN_CHEC      BEGSR                                                                CSD079
                                                                                              CSD079
      ** Cheque Card 1                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDCAC1 = SCCAC1                                            CSD079
     C     SCDIS1        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCDIS1                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDDIS1                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDDIS1 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
     C     SCDRE1        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCDRE1                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDDRE1                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDDRE1 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Cheque Card 2                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDCAC2 = SCCAC2                                            CSD079
     C     SCDIS2        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCDIS2                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDDIS2                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDDIS2 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
     C     SCDRE2        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCDRE2                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDDRE2                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDDRE2 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Cheque Card 3                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDCAC3 = SCCAC3                                            CSD079
     C     SCDIS3        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCDIS3                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDDIS3                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDDIS3 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
     C     SCDRE3        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCDRE3                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDDRE3                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDDRE3 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Cheque Card 4                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDCAC4 = SCCAC4                                            CSD079
     C     SCDIS4        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCDIS4                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDDIS4                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDDIS4 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
     C     SCDRE4        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCDRE4                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDDRE4                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDDRE4 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Cheque Card 5                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDCAC5 = SCCAC5                                            CSD079
     C     SCDIS5        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCDIS5                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDDIS5                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDDIS5 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
     C     SCDRE5        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCDRE5                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDDRE5                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDDRE5 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Card Cheque Text                                                                     CSD079
                                                                                              CSD079
     C                   EVAL      DDCTX1 = SCCTX1                                            CSD079
                                                                                              CSD079
      ** Cheque Num 1                                                                         CSD079
                                                                                              CSD079
     C                   EVAL      DDCQF1 = SCCQF1                                            CSD079
     C                   EVAL      DDCQT1 = SCCQT1                                            CSD079
     C                   EVAL      DDCQQ1 = SCCQQ1                                            CSD079
     C     SCCQI1        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCCQI1                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDCQI1                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDCQI1 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Cheque Num 2                                                                         CSD079
                                                                                              CSD079
     C                   EVAL      DDCQF2 = SCCQF2                                            CSD079
     C                   EVAL      DDCQT2 = SCCQT2                                            CSD079
     C                   EVAL      DDCQQ2 = SCCQQ2                                            CSD079
     C     SCCQI2        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCCQI2                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDCQI2                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDCQI2 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Cheque Num 3                                                                         CSD079
                                                                                              CSD079
     C                   EVAL      DDCQF3 = SCCQF3                                            CSD079
     C                   EVAL      DDCQT3 = SCCQT3                                            CSD079
     C                   EVAL      DDCQQ3 = SCCQQ3                                            CSD079
     C     SCCQI3        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCCQI3                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDCQI3                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDCQI3 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Cheque Num 4                                                                         CSD079
                                                                                              CSD079
     C                   EVAL      DDCQF4 = SCCQF4                                            CSD079
     C                   EVAL      DDCQT4 = SCCQT4                                            CSD079
     C                   EVAL      DDCQQ4 = SCCQQ4                                            CSD079
     C     SCCQI4        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCCQI4                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDCQI4                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDCQI4 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Cheque Num 5                                                                         CSD079
                                                                                              CSD079
     C                   EVAL      DDCQF5 = SCCQF5                                            CSD079
     C                   EVAL      DDCQT5 = SCCQT5                                            CSD079
     C                   EVAL      DDCQQ5 = SCCQQ5                                            CSD079
     C     SCCQI5        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCCQI5                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDCQI5                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDCQI5 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Cheque Number Text                                                                   CSD079
                                                                                              CSD079
     C                   EVAL      DDCTX2 = SCCTX2                                            CSD079
                                                                                              CSD079
      ** Credit Card 1                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDCAN1 = SCCAN1                                            CSD079
     C                   EVAL      DDCAL1 = SCCAL1                                            CSD079
     C     SCCAI1        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCCAI1                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDCAI1                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDCAI1 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
     C     SCCAE1        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCCAE1                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDCAE1                                       CSD079
     C                   MOVEL     ZDATE         DDCAE1                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDCAE1 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Credit Card 2                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDCAN2 = SCCAN2                                            CSD079
     C                   EVAL      DDCAL2 = SCCAL2                                            CSD079
     C     SCCAI2        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCCAI2                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDCAI2                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDCAI2 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
     C     SCCAE2        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCCAE2                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDCAE2                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDCAE2 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Credit Card 3                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDCAN3 = SCCAN3                                            CSD079
     C                   EVAL      DDCAL3 = SCCAL3                                            CSD079
     C     SCCAI3        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCCAE3                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDCAI3                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDCAI3 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
     C     SCCAE3        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCCAE3                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDCAE3                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDCAE3 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Credit Card 4                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDCAN4 = SCCAN4                                            CSD079
     C                   EVAL      DDCAL4 = SCCAL4                                            CSD079
     C     SCCAI4        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCCAI4                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDCAI4                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDCAI4 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
     C     SCCAE4        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCCAE4                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDCAE4                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDCAE4 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Credit Card 5                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDCAN5 = SCCAN5                                            CSD079
     C                   EVAL      DDCAL5 = SCCAL5                                            CSD079
     C     SCCAI5        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCCAI5                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDCAI5                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDCAI5 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
     C     SCCAE5        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SCCAE5                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDCAE5                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDCAE5 = *BLANKS                                           CSD079
     C                   END                                                                  CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  SCN_CUSF - SET Safes Details SCREEN FIELDS                   *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
                                                                                              CSD079
     C     SCN_CUSF      BEGSR                                                                CSD079
                                                                                              CSD079
      ** Safe Number 1                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDSFN1 = SASFN1                                            CSD079
     C                   EVAL      DDSFS1 = SASFS1                                            CSD079
     C     SASFI1        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SASFI1                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDSFI1                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDSFI1 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Safe Number 2                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDSFN2 = SASFN2                                            CSD079
     C                   EVAL      DDSFS2 = SASFS2                                            CSD079
     C     SASFI2        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SASFI2                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDSFI2                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDSFI2 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Safe Number 3                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDSFN3 = SASFN3                                            CSD079
     C                   EVAL      DDSFS3 = SASFS3                                            CSD079
     C     SASFI3        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SASFI3                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDSFI3                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDSFI3 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Safe Number 4                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDSFN4 = SASFN4                                            CSD079
     C                   EVAL      DDSFS4 = SASFS4                                            CSD079
     C     SASFI4        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SASFI4                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDSFI4                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDSFI4 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Safe Number 5                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDSFN5 = SASFN5                                            CSD079
     C                   EVAL      DDSFS5 = SASFS5                                            CSD079
     C     SASFI5        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = SASFI5                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDSFI5                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDSFI5 = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  SCN_CUFX - SET FX netting SCREEN FIELDS                      *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
                                                                                              CSD079
     C     SCN_CUFX      BEGSR                                                                CSD079
                                                                                              CSD079
      ** Net Settlement                                                                       CSD079
                                                                                              CSD079
     C                   EVAL      DDNET  = BBNET                                             CSD079
                                                                                              CSD079
      ** Netting Group                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDNTGP = BBNTGP                                            CSD079
                                                                                              CSD079
      ** Net By Currency Pairs                                                                CSD079
                                                                                              CSD079
     C                   EVAL      DDNTCP = BBNTCP                                            CSD079
                                                                                              CSD079
      ** Net Notice Days                                                                      CSD079
                                                                                              CSD079
     C     BBNTND        IFEQ      *ZERO                                                      CSD079
     C                   MOVEL     *BLANKS       DDNTND                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVE      *BLANKS       ZFIELD                                       CSD079
     C                   MOVE      BBNTND        ZFIELD                                       CSD079
     C                   EVAL      ZADEC = 0                                                  CSD079
     C                   EXSR      ZEDIT                                                      CSD079
     C                   MOVE      ZFIELD        DDNTND                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Net Manual Matching                                                                  CSD079
                                                                                              CSD079
     C                   EVAL      DDNTMM = BBNTMM                                            CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  SCN_CUFD - SET Fiduciary Details SCREEN FIELDS               *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
                                                                                              CSD079
     C     SCN_CUFD      BEGSR                                                                CSD079
                                                                                              CSD079
      ** Commission Group                                                                     CSD079
                                                                                              CSD079
     C                   EVAL      DDCOMG = BBCOMG                                            CSD079
                                                                                              CSD079
      ** Charge Group                                                                         CSD079
                                                                                              CSD079
     C                   EVAL      DDCHRG = BBCHRG                                            CSD079
                                                                                              CSD079
      ** Agent                                                                                CSD079
                                                                                              CSD079
     C                   EVAL      DDAGNT = BBAGNT                                            CSD079
                                                                                              CSD079
      ** Trust Agreement Status                                                               CSD079
                                                                                              CSD079
     C                   EVAL      DDTRAS = BBTRAS                                            CSD079
                                                                                              CSD079
      ** Restrictions/narrative 1                                                             CSD079
                                                                                              CSD079
     C                   EVAL      DDNAR1 = BBNAR1                                            CSD079
                                                                                              CSD079
      ** Restrictions/narrative 2                                                             CSD079
                                                                                              CSD079
     C                   EVAL      DDNAR2 = BBNAR2                                            CSD079
                                                                                              CSD079
      ** Restrictions/narrative 3                                                             CSD079
                                                                                              CSD079
     C                   EVAL      DDNAR3 = BBNAR3                                            CSD079
                                                                                              CSD079
      ** Restrictions/narrative 4                                                             CSD079
                                                                                              CSD079
     C                   EVAL      DDNAR4 = BBNAR4                                            CSD079
                                                                                              CSD079
      ** Agents Percentage                                                                    CSD079
                                                                                              CSD079
     C     BBAGNP        IFEQ      *ZERO                                                      CSD079
     C                   MOVEL     *BLANKS       DDAGNP                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVE      *BLANKS       ZFIELD                                       CSD079
     C                   MOVE      BBAGNP        ZFIELD                                       CSD079
     C                   EVAL      ZADEC = 3                                                  CSD079
     C                   EXSR      ZEDIT                                                      CSD079
     C                   MOVE      ZFIELD        DDAGNP                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Default account code                                                                 CSD079
                                                                                              CSD079
     C     BBDFAC        IFEQ      *ZERO                                                      CSD079
     C                   MOVEL     *BLANKS       DDDFAC                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVE      *BLANKS       ZFIELD                                       CSD079
     C                   MOVE      BBDFAC        ZFIELD                                       CSD079
     C                   EVAL      ZADEC = 0                                                  CSD079
     C                   EXSR      ZEDIT                                                      CSD079
     C                   MOVE      ZFIELD        DDDFAC                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Default Account Sequence                                                             CSD079
                                                                                              CSD079
     C     BBDFAS        IFEQ      *ZERO                                                      CSD079
     C                   MOVEL     *BLANKS       DDDFAS                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVE      BBDFAS        DDDFAS                                       CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDSR                                                                CSD079
                                                                                              CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  SCN_RWAN - SET Risk Weighted Assets SCREEN FIELDS            *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
                                                                                              CSD079
     C     SCN_RWAN      BEGSR                                                                CSD079
                                                                                              CSD079
      ** Customer Number                                                                      CSD079
                                                                                              CSD079
     C                   EVAL      DDCUST =  RACUST                                           CSD079
                                                                                              CSD079
      ** RWA Code & Set Number                                                                CSD079
                                                                                              CSD079
     C                   EVAL      DDCOD1 = RACOD1                                            CSD079
     C                   EVAL      DDSET1 = RASET1                                            CSD079
     C                   EVAL      DDCOD2 = RACOD2                                            CSD079
     C                   EVAL      DDSET2 = RASET2                                            CSD079
     C                   EVAL      DDCOD3 = RACOD3                                            CSD079
     C                   EVAL      DDSET3 = RASET3                                            CSD079
     C                   EVAL      DDCOD4 = RACOD4                                            CSD079
     C                   EVAL      DDSET4 = RASET4                                            CSD079
     C                   EVAL      DDCOD5 = RACOD5                                            CSD079
     C                   EVAL      DDSET5 = RASET5                                            CSD079
     C                   EVAL      DDCOD6 = RACOD6                                            CSD079
     C                   EVAL      DDSET6 = RASET6                                            CSD079
     C                   EVAL      DDCOD7 = RACOD7                                            CSD079
     C                   EVAL      DDSET7 = RASET7                                            CSD079
     C                   EVAL      DDCOD8 = RACOD8                                            CSD079
     C                   EVAL      DDSET8 = RASET8                                            CSD079
     C                   EVAL      DDCOD9 = RACOD9                                            CSD079
     C                   EVAL      DDSET9 = RASET9                                            CSD079
     C                   EVAL      DDCOD10 = RACOD10                                          CSD079
     C                   EVAL      DDSET10 = RASET10                                          CSD079
     C                   EVAL      DDCOD11 = RACOD11                                          CSD079
     C                   EVAL      DDSET11 = RASET11                                          CSD079
     C                   EVAL      DDCOD12 = RACOD12                                          CSD079
     C                   EVAL      DDSET12 = RASET12                                          CSD079
     C                   EVAL      DDCOD13 = RACOD13                                          CSD079
     C                   EVAL      DDSET13 = RASET13                                          CSD079
     C                   EVAL      DDCOD14 = RACOD14                                          CSD079
     C                   EVAL      DDSET14 = RASET14                                          CSD079
     C                   EVAL      DDCOD15 = RACOD15                                          CSD079
     C                   EVAL      DDSET15 = RASET15                                          CSD079
     C                   EVAL      DDCOD16 = RACOD16                                          CSD079
     C                   EVAL      DDSET16 = RASET16                                          CSD079
     C                   EVAL      DDCOD17 = RACOD17                                          CSD079
     C                   EVAL      DDSET17 = RASET17                                          CSD079
     C                   EVAL      DDCOD18 = RACOD18                                          CSD079
     C                   EVAL      DDSET18 = RASET18                                          CSD079
     C                   EVAL      DDCOD19 = RACOD19                                          CSD079
     C                   EVAL      DDSET19 = RASET19                                          CSD079
     C                   EVAL      DDCOD20 = RACOD20                                          CSD079
     C                   EVAL      DDSET20 = RASET20                                          CSD079
     C                   EVAL      DDCOD21 = RACOD21                                          CSD079
     C                   EVAL      DDSET21 = RASET21                                          CSD079
     C                   EVAL      DDCOD22 = RACOD22                                          CSD079
     C                   EVAL      DDSET22 = RASET22                                          CSD079
     C                   EVAL      DDCOD23 = RACOD23                                          CSD079
     C                   EVAL      DDSET23 = RASET23                                          CSD079
     C                   EVAL      DDCOD24 = RACOD24                                          CSD079
     C                   EVAL      DDSET24 = RASET24                                          CSD079
     C                   EVAL      DDCOD25 = RACOD25                                          CSD079
     C                   EVAL      DDSET25 = RASET25                                          CSD079
     C                   EVAL      DDCOD26 = RACOD26                                          CSD079
     C                   EVAL      DDSET26 = RASET26                                          CSD079
     C                   EVAL      DDCOD27 = RACOD27                                          CSD079
     C                   EVAL      DDSET27 = RASET27                                          CSD079
     C                   EVAL      DDCOD28 = RACOD28                                          CSD079
     C                   EVAL      DDSET28 = RASET28                                          CSD079
     C                   EVAL      DDCOD29 = RACOD29                                          CSD079
     C                   EVAL      DDSET29 = RASET29                                          CSD079
     C                   EVAL      DDCOD30 = RACOD30                                          CSD079
     C                   EVAL      DDSET30 = RASET30                                          CSD079
     C                   EVAL      DDCOD31 = RACOD31                                          CSD079
     C                   EVAL      DDSET31 = RASET31                                          CSD079
     C                   EVAL      DDCOD32 = RACOD32                                          CSD079
     C                   EVAL      DDSET32 = RASET32                                          CSD079
     C                   EVAL      DDCOD33 = RACOD33                                          CSD079
     C                   EVAL      DDSET33 = RASET33                                          CSD079
     C                   EVAL      DDCOD34 = RACOD34                                          CSD079
     C                   EVAL      DDSET34 = RASET34                                          CSD079
     C                   EVAL      DDCOD35 = RACOD35                                          CSD079
     C                   EVAL      DDSET35 = RASET35                                          CSD079
     C                   EVAL      DDCOD36 = RACOD36                                          CSD079
     C                   EVAL      DDSET36 = RASET36                                          CSD079
     C                   EVAL      A1_DDCSSN = RACSSN                                         CSD079
     C                   EVAL      A1_DDCRNM = RACRNM                                         CSD079
     C                   EVAL      A1_DDCNA2 = RACNA2                                         CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  SCN_CUFO - SET Futures and Option SCREEN FIELDS              *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
                                                                                              CSD079
     C     SCN_CUFO      BEGSR                                                                CSD079
                                                                                              CSD079
      ** Currency Code                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDCYCD = BHCYCD                                            CSD079
                                                                                              CSD079
      ** Statement Frequency                                                                  CSD079
                                                                                              CSD079
     C                   EVAL      DDSTFQ = BHSTFQ                                            CSD079
                                                                                              CSD079
      ** Days in Month for Statement                                                          CSD079
                                                                                              CSD079
     C     BHDMFS        IFEQ      *ZERO                                                      CSD079
     C                   MOVEL     *BLANKS       DDDMFS                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVE      *BLANKS       ZFIELD                                       CSD079
     C                   MOVE      BHDMFS        ZFIELD                                       CSD079
     C                   EVAL      ZADEC = 0                                                  CSD079
     C                   EXSR      ZEDIT                                                      CSD079
     C                   MOVE      ZFIELD        DDDMFS                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Next Statement Date                                                                  CSD079
                                                                                              CSD079
     C     BHNSDT        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = BHNSDT                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDNSDT                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDNSDT = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** For Account of                                                                       CSD079
                                                                                              CSD079
     C                   EVAL      DDFACO = BHFACO                                            CSD079
                                                                                              CSD079
      ** Broker Indicator                                                                     CSD079
                                                                                              CSD079
     C                   EVAL      DDBKIN = BHBKIN                                            CSD079
                                                                                              CSD079
      ** Settlement Type                                                                      CSD079
                                                                                              CSD079
     C                   EVAL      DDSTTY = BHSTTY                                            CSD079
                                                                                              CSD079
      ** Settlement Account                                                                   CSD079
                                                                                              CSD079
     C                   EVAL      A1_DDSMAC = BHSMAC                                         CSD079
                                                                                              CSD079
      ** Counterparty Nostro                                                                  CSD079
                                                                                              CSD079
     C                   EVAL      DDCPNO = BHCPNO                                            CSD079
                                                                                              CSD079
      ** Correspondence Address                                                               CSD079
                                                                                              CSD079
     C                   EVAL      DDCOAD = BHCOAD                                            CSD079
                                                                                              CSD079
      ** For the Attention of                                                                 CSD079
                                                                                              CSD079
     C                   EVAL      DDFTAO  = BHFTAO                                           CSD079
                                                                                              CSD079
      ** Telex Confirmation Ind.                                                              CSD079
                                                                                              CSD079
     C                   EVAL      DDTXCI = BHTXCI                                            CSD079
                                                                                              CSD079
      ** Contract Limit                                                                       CSD079
                                                                                              CSD079
     C     BHCTLM        IFEQ      *ZERO                                                      CSD079
     C                   MOVEL     *BLANKS       DDCTLM                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVE      *BLANKS       ZFIELD                                       CSD079
     C                   MOVE      BHCTLM        ZFIELD                                       CSD079
     C                   EVAL      ZADEC = 0                                                  CSD079
     C                   EVAL      ZUDIG = 5                                                  CSD079
     C                   EXSR      ZALIGN                                                     CSD079
     C                   EVAL      ZADEC = 0                                                  CSD079
     C                   EXSR      ZEDIT                                                      CSD079
     C                   MOVE      ZFIELD        DDCTLM                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Revaluation Frequency                                                                CSD079
                                                                                              CSD079
     C                   EVAL      DDRVFQ = BHRVFQ                                            CSD079
                                                                                              CSD079
      ** Revaluation Base Day                                                                 CSD079
                                                                                              CSD079
     C     BHRVBD        IFEQ      *ZERO                                                      CSD079
     C                   MOVEL     *BLANKS       DDRVBD                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVE      *BLANKS       ZFIELD                                       CSD079
     C                   MOVE      BHRVBD        ZFIELD                                       CSD079
     C                   EVAL      ZADEC = 0                                                  CSD079
     C                   EXSR      ZEDIT                                                      CSD079
     C                   MOVE      ZFIELD        DDRVBD                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Next revaluation date                                                                CSD079
                                                                                              CSD079
     C     BHNRDT        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = BHNRDT                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDNRDT                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDNRDT = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Positions combined ind                                                               CSD079
                                                                                              CSD079
     C                   EVAL      DDPCIN = BHPCIN                                            CSD079
                                                                                              CSD079
      ** Automatic Closure ind                                                                CSD079
                                                                                              CSD079
     C                   EVAL      DDACIN = BHACIN                                            CSD079
                                                                                              CSD079
      ** Collateral Description                                                               CSD079
                                                                                              CSD079
     C                   EVAL      DDCODE = BHCODE                                            CSD079
                                                                                              CSD079
      ** Settlement Branch                                                                    CSD079
                                                                                              CSD079
     C                   EVAL      DDSEBR = BHSEBR                                            CSD079
                                                                                              CSD079
      ** Collateral Amount                                                                    CSD079
                                                                                              CSD079
     C     BHCOAM        IFEQ      *ZERO                                                      CSD079
     C                   MOVEL     *BLANKS       DDCOAM                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      ZADEC = 0                                                  CSD079
     C                   MOVE      *BLANKS       ZFIELD                                       CSD079
     C                   MOVE      BHCOAM        ZFIELD                                       CSD079
     C                   EXSR      SRCurr                                                     CSD079
     C                   EXSR      ZEDIT                                                      CSD079
     C                   MOVE      ZFIELD        DDCOAM                                       CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  SCN_CUFN - Set FF Customers Maintenance Screen Fields        *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
                                                                                              CSD079
     C     SCN_CUFN      BEGSR                                                                CSD079
                                                                                              CSD079
      ** Netting Agreement                                                                    CSD079
                                                                                              CSD079
     C     CANETA        IFEQ      *ZERO                                                      CSD079
     C                   MOVE      *BLANKS       DDNETA                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVE      CANETA        DDNETA                                       CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  SCN_CUPM - SET Portfolio Management SCREEN FIELDS            *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
                                                                                              CSD079
     C     SCN_CUPM      BEGSR                                                                CSD079
                                                                                              CSD079
      ** Date of Birth (Portfolio)                                                            CSD079
                                                                                              CSD079
     C     QBBDAT        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = QBBDAT                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDBDAT                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDBDAT = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Language Spoken                                                                      CSD079
                                                                                              CSD079
     C                   EVAL      DDLANG = QBLANG                                            CSD079
                                                                                              CSD079
      ** Customer Base Currency                                                               CSD079
                                                                                              CSD079
     C                   EVAL      DDCSBY = QBCSBY                                            CSD079
                                                                                              CSD079
      ** Safe Indicator                                                                       CSD079
                                                                                              CSD079
     C                   EVAL      DDSAFI = QBSAFI                                            CSD079
                                                                                              CSD079
      ** Documentation Sts Ind                                                                CSD079
                                                                                              CSD079
     C                   EVAL      DDDCMS = QBDCMS                                            CSD079
                                                                                              CSD079
      ** Valuation Frequency                                                                  CSD079
                                                                                              CSD079
     C                   EVAL      DDVLFQ = QBVLFQ                                            CSD079
                                                                                              CSD079
      ** Valuation Day in Month                                                               CSD079
                                                                                              CSD079
     C     QBVLDM        IFEQ      *ZERO                                                      CSD079
     C                   MOVEL     *BLANKS       DDVLDM                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVE      *BLANKS       ZFIELD                                       CSD079
     C                   MOVE      QBVLDM        ZFIELD                                       CSD079
     C                   EVAL      ZADEC = 0                                                  CSD079
     C                   EXSR      ZEDIT                                                      CSD079
     C                   MOVE      ZFIELD        DDVLDM                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Next Valuation Date                                                                  CSD079
                                                                                              CSD079
     C     QBVLND        IFNE      *ZEROS                                                     CSD079
     C                   EVAL      ZDAYNO = QBVLND                                            CSD079
     C                   EXSR      ZDATE2                                                     CSD079
     C                   MOVEL     ZDATE         DDVLND                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      DDVLND = *BLANKS                                           CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Holdings/Valuation Group                                                             CSD079
                                                                                              CSD079
     C                   EVAL      DDS1VR = QBS1VR                                            CSD079
                                                                                              CSD079
      ** Sector Breakdown Req                                                                 CSD079
                                                                                              CSD079
     C                   EVAL      DDS2VR = QBS2VR                                            CSD079
                                                                                              CSD079
      ** Past Year Perf Required                                                              CSD079
                                                                                              CSD079
     C                   EVAL      DDS3VR = QBS3VR                                            CSD079
                                                                                              CSD079
      ** Tax Year Perf Required                                                               CSD079
                                                                                              CSD079
     C                   EVAL      DDS4VR = QBS4VR                                            CSD079
                                                                                              CSD079
      ** Additional Perf Required                                                             CSD079
                                                                                              CSD079
     C                   EVAL      DDS5VR = QBS5VR                                            CSD079
                                                                                              CSD079
      ** Daily Cashflows Required                                                             CSD079
                                                                                              CSD079
     C                   EVAL      DDS6VR = QBS6VR                                            CSD079
                                                                                              CSD079
      ** Monthly Cashflows Reqd                                                               CSD079
                                                                                              CSD079
     C                   EVAL      DDS7VR = QBS7VR                                            CSD079
                                                                                              CSD079
      ** Yearly Cashflows Required                                                            CSD079
                                                                                              CSD079
     C                   EVAL      DDS8VR = QBS8VR                                            CSD079
                                                                                              CSD079
      ** All Portfolios in Cust CCY                                                           CSD079
                                                                                              CSD079
     C                   EVAL      DDAPBC = QBAPBC                                            CSD079
                                                                                              CSD079
      ** Pool Portfolio Cust Ind                                                              CSD079
                                                                                              CSD079
     C                   EVAL      DDPPCS = QBPPCS                                            CSD079
                                                                                              CSD079
      ** Default Portfolio                                                                    CSD079
                                                                                              CSD079
     C                   EVAL      DDDFPO = QBDFPO                                            CSD079
                                                                                              CSD079
      ** Instrument Summary                                                                   CSD079
                                                                                              CSD079
     C                   EVAL      DDINSU = QBINSU                                            CSD079
                                                                                              CSD079
      ** Currency Summary                                                                     CSD079
                                                                                              CSD079
     C                   EVAL      DDCYSU = QBCYSU                                            CSD079
                                                                                              CSD079
      ** Secret Code                                                                          CSD079
                                                                                              CSD079
     C                   EVAL      DDSECO = QBSECO                                            CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  SCN_TICD - SET TI interface SCREEN FIELDS                    *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
                                                                                              CSD079
     C     SCN_TICD      BEGSR                                                                CSD079
                                                                                              CSD079
      ** Charge FX Rate Code                                                                  CSD079
                                                                                              CSD079
     C                   EVAL      DDCFXC = TCCFXC                                            CSD079
                                                                                              CSD079
      ** Principal FX Rate Code                                                               CSD079
                                                                                              CSD079
     C                   EVAL      DDPFXC = TCPFXC                                            CSD079
                                                                                              CSD079
      ** Exempt From TF Taxes                                                                 CSD079
                                                                                              CSD079
     C                   EVAL      DDETIT = TCETIT                                            CSD079
                                                                                              CSD079
      ** Salutation                                                                           CSD079
                                                                                              CSD079
     C                   EVAL      DDSALU = TCSALU                                            CSD079
                                                                                              CSD079
      ** Telex                                                                                CSD079
                                                                                              CSD079
     C                   EVAL      DDTELX = TCTELX                                            CSD079
                                                                                              CSD079
      ** Telex Answer Back                                                                    CSD079
                                                                                              CSD079
     C                   EVAL      DDTXAB = TCTXAB                                            CSD079
                                                                                              CSD079
      ** Fax                                                                                  CSD079
                                                                                              CSD079
     C                   EVAL      DDFXNO = TCFXNO                                            CSD079
                                                                                              CSD079
      ** ZIP Code                                                                             CSD079
                                                                                              CSD079
     C                   EVAL      DDZPCD = TCZPCD                                            CSD079
                                                                                              CSD079
      ** TI Transfer Method                                                                   CSD079
                                                                                              CSD079
     C                   EVAL      DDTRFM = TCTRFM                                            CSD079
                                                                                              CSD079
      ** Default Language                                                                     CSD079
                                                                                              CSD079
     C                   EVAL      DDDLNG = TCDLNG                                            CSD079
                                                                                              CSD079
      ** Analysis Code                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      DDANAL = TCANAL                                            CSD079
                                                                                              CSD079
      ** Mail To Branch Code                                                                  CSD079
                                                                                              CSD079
     C                   EVAL      DDMLBR = TCMLBR                                            CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************
      /EJECT
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      ***SCN_CUX2 - Set Lux(European Reporting) Screen Fields         *              CSD079 BUG13595
      *  SCN_CUX1 - Set Lux(IBLC - Extended Information) Screen fields*                     BUG13595
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C*****SCN_CUX2      BEGSR                                                       CSD079 BUG13595
     C     SCN_CUX1      BEGSR                                                              BUG13595
                                                                                              CSD079
      ** Consolidation code                                                                   CSD079
                                                                                              CSD079
     C                   EVAL      LLLXTYPE = CUTYPE                                          CSD079
                                                                                              CSD079
      ** Identification Code                                                                  CSD079
                                                                                              CSD079
     C                   EVAL      LLLXIDCO = CUIDCO                                          CSD079
                                                                                              CSD079
      ** Identification                                                                       CSD079
                                                                                              CSD079
     C                   EVAL      LLLXIDEN = CUIDEN                                          CSD079
                                                                                              CSD079
      ** Immatriculation Code                                                                 CSD079
                                                                                              CSD079
     C                   EVAL      LLLXIMCO = CUIMCO                                          CSD079
                                                                                              CSD079
      ** Immatriculation                                                                      CSD079
                                                                                              CSD079
     C                   EVAL      LLLXIMNB = CUIMNB                                          CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      ***SCN_CUX1 - Set Lux(IBLC - Extended Information) Screen fields*              CSD079 BUG13595
      *  SCN_CUX2 - Set Lux(European Reporting) Screen fields         *                     BUG13595
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
     C*****SCN_CUX1      BEGSR                                                       CSD079 BUG13595
     C     SCN_CUX2      BEGSR                                                              BUG13595
                                                                                              CSD079
      ** Consolidation  Code                                                                  CSD079
                                                                                              CSD079
     C                   MOVE      VFCONS        L6LXCONS                                     CSD079
                                                                                              CSD079
      ** Economic Sector Code                                                                 CSD079
                                                                                              CSD079
     C                   MOVE      VFECOS        L6LXECOS                                     CSD079
                                                                                              CSD079
      ** Institution Reference                                                                CSD079
                                                                                              CSD079
     C                   MOVE      VFINRF        L6LXINRF                                     CSD079
                                                                                              CSD079
      ** Economic Group                                                                       CSD079
                                                                                              CSD079
     C                   EVAL      L6LXCGRP = VFCGRP                                          CSD079
                                                                                              CSD079
      ** Participation Percentage                                                             CSD079
                                                                                              CSD079
     C     VFPAPS        IFEQ      *ZERO                                                      CSD079
     C                   MOVEL     *BLANKS       L6LXPAPS                                     CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVE      *BLANKS       ZFIELD                                       CSD079
     C                   MOVE      VFPAPS        ZFIELD                                       CSD079
     C                   Z-ADD     2             ZADEC                                        CSD079
     C                   EXSR      ZEDIT                                                      CSD079
     C                   MOVE      ZFIELD        L6LXPAPS                                     CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      * Performing Indicator                                                                  CSD079
                                                                                              CSD079
     C                   EVAL      L6LXPERF = VFPERF                                          CSD079
                                                                                              CSD079
      ** New Economic Sector code                                                             CSD079
                                                                                              CSD079
     C                   MOVE      VFNCOS        L6LXNCOS                                     CSD079
                                                                                              CSD079
      ** Guarantees & Collateral Au                                                           CSD079
                                                                                              CSD079
     C                   EVAL      L6LXAUTG = VFAUTG                                          CSD079
                                                                                              CSD079
      ** Processing & Economic Gr.                                                            CSD079
                                                                                              CSD079
     C                   EVAL      L6LXPROG = VFPROG                                          CSD079
                                                                                              CSD079
      ** Asset Pledged                                                                        CSD079
                                                                                              CSD079
     C                   EVAL      L6LXASSP = VFASSP                                          CSD079
                                                                                              CSD079
      ** Investment Company Code                                                              CSD079
                                                                                              CSD079
     C                   EVAL      L6LXICCD = VFICCD                                          CSD079
                                                                                              CSD079
      ** Market Centre 'Y/N'                                                                  CSD079
                                                                                              CSD079
     C                   EVAL      L6LXMCID = VFMCID                                          CSD079
                                                                                              CSD079
      ** Subject to Minimum Reserve                                                           CSD079
                                                                                              CSD079
     C                   EVAL      L6LXSMRS = VFSMRS                                          CSD079
                                                                                              CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************                       CSD079
      /EJECT                                                                               AR1086546
      *****************************************************************                    AR1086546
      *                                                               *                    AR1086546
      *  SCN_CTNM - SET Currency/Time of Netting Screen Fields        *                    AR1086546
      *                                                               *                    AR1086546
      *****************************************************************                    AR1086546
                                                                                           AR1086546
     C     SCN_CTNM      BEGSR                                                             AR1086546
                                                                                           AR1086546
      ** Customer Number                                                                   AR1086546
                                                                                           AR1086546
     C                   EVAL      CT_DDCUST =  TNCUST                                     AR1086546
                                                                                           AR1086546
      ** Currencies, Time and Release Notice Days                                          AR1086546
                                                                                           AR1086546
     C                   EVAL      DDCCY1_1 = TNCCY1_1                                     AR1086546
     C                   EVAL      DDCCY2_1 = TNCCY2_1                                     AR1086546
     C                   EVAL      DDTIME_1 = TNTIME_1                                     AR1086546
     C                   EVAL      DDRNTD_1 = TNRNTD_1                                     AR1086546
     C                   EVAL      DDCCY1_2 = TNCCY1_2                                     AR1086546
     C                   EVAL      DDCCY2_2 = TNCCY2_2                                     AR1086546
     C                   EVAL      DDTIME_2 = TNTIME_2                                     AR1086546
     C                   EVAL      DDRNTD_2 = TNRNTD_2                                     AR1086546
     C                   EVAL      DDCCY1_3 = TNCCY1_3                                     AR1086546
     C                   EVAL      DDCCY2_3 = TNCCY2_3                                     AR1086546
     C                   EVAL      DDTIME_3 = TNTIME_3                                     AR1086546
     C                   EVAL      DDRNTD_3 = TNRNTD_3                                     AR1086546
     C                   EVAL      DDCCY1_4 = TNCCY1_4                                     AR1086546
     C                   EVAL      DDCCY2_4 = TNCCY2_4                                     AR1086546
     C                   EVAL      DDTIME_4 = TNTIME_4                                     AR1086546
     C                   EVAL      DDRNTD_4 = TNRNTD_4                                     AR1086546
     C                   EVAL      DDCCY1_5 = TNCCY1_5                                     AR1086546
     C                   EVAL      DDCCY2_5 = TNCCY2_5                                     AR1086546
     C                   EVAL      DDTIME_5 = TNTIME_5                                     AR1086546
     C                   EVAL      DDRNTD_5 = TNRNTD_5                                     AR1086546
     C                   EVAL      DDCCY1_6 = TNCCY1_6                                     AR1086546
     C                   EVAL      DDCCY2_6 = TNCCY2_6                                     AR1086546
     C                   EVAL      DDTIME_6 = TNTIME_6                                     AR1086546
     C                   EVAL      DDRNTD_6 = TNRNTD_6                                     AR1086546
     C                   EVAL      DDCCY1_7 = TNCCY1_7                                     AR1086546
     C                   EVAL      DDCCY2_7 = TNCCY2_7                                     AR1086546
     C                   EVAL      DDTIME_7 = TNTIME_7                                     AR1086546
     C                   EVAL      DDRNTD_7 = TNRNTD_7                                     AR1086546
     C                   EVAL      DDCCY1_8 = TNCCY1_8                                     AR1086546
     C                   EVAL      DDCCY2_8 = TNCCY2_8                                     AR1086546
     C                   EVAL      DDTIME_8 = TNTIME_8                                     AR1086546
     C                   EVAL      DDRNTD_8 = TNRNTD_8                                     AR1086546
     C                   EVAL      DDCCY1_9 = TNCCY1_9                                     AR1086546
     C                   EVAL      DDCCY2_9 = TNCCY2_9                                     AR1086546
     C                   EVAL      DDTIME_9 = TNTIME_9                                     AR1086546
     C                   EVAL      DDRNTD_9 = TNRNTD_9                                     AR1086546
     C                   EVAL      DDCCY1_10 = TNCCY1_10                                   AR1086546
     C                   EVAL      DDCCY2_10 = TNCCY2_10                                   AR1086546
     C                   EVAL      DDTIME_10 = TNTIME_10                                   AR1086546
     C                   EVAL      DDRNTD_10 = TNRNTD_10                                   AR1086546
                                                                                           AR1086546
     C                   ENDSR                                                             AR1086546
      *****************************************************************                    AR1086546
      /EJECT                                                                                  CSD079
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Customer file format
     C                   PARM                    CustFilFmt
     C/COPY WNCPYSRC,SDH00695
      *
      * Base Rate Tax file format
     C                   PARM                    BrtxFilFmt
      *
      * Private Banking format
     C                   PARM                    PrivFilFmt
     C                   PARM                    CumiFilFmt                                   CSD079
     C                   PARM                    CuadFilFmt                                   CSD079
     C                   PARM                    SfeeFilFmt                                   CSD079
     C                   PARM                    ChecFilFmt                                   CSD079
     C                   PARM                    CusfFilFmt                                   CSD079
     C                   PARM                    RwanFilFmt                                   CSD079
     C                   PARM                    CufoFilFmt                                   CSD079
     C                   PARM                    CufnFilFmt                                   CSD079
     C                   PARM                    CupmFilFmt                                   CSD079
     C                   PARM                    TicdFilFmt                                   CSD079
     C                   PARM                    CueuFilFmt                                   CSD079
     C                   PARM                    CuibfFilFmt                                  CSD079
     C                   PARM                    CtnmFilFmt                                AR1086546
                                                                                              CSD079
      ** Global Customer X-Reference                                                          CGP001
     C                   PARM                    GCustFilFmt                                  CGP001
     C                   PARM                    CrSwFilFmt                                   CSW207
     C                   PARM                    CuXcFilFmt                                   CGL132
     C                   PARM                    CrFaFilFmt                                   CGL132
      ** SDCRSDPD Transaction Details File Format                                             CGL157
     C                   PARM                    CrsdFilFmt                                   CGL157
                                                                                              CGL157
     C                   PARM                    PCrsdF                                       CGL157
      ** Switchable features                                                                  CLE025
     C                   PARM                    CLE025                                       CLE025
     C                   PARM                    CFX001                                       CFX001
      *
      * Output parameters
      *
      * Customer - screen formats
     C                   PARM                    CuPrim
     C                   PARM                    CuSeco
     C                   PARM                    CuMT3x                                       CSW024
     C                   PARM                    CuMsrt
     C                   PARM                    CuBrtx
     C                   PARM                    CuPriv
     C                   PARM                    TranInCumi                                   CSD079
     C                   PARM                    TranInCuad                                   CSD079
     C                   PARM                    TranInACU3                                   CER059
     C                   PARM                    TranInACU4                                   CER059
     C                   PARM                    TranInSfee                                   CSD079
     C                   PARM                    TranInCufx                                   CSD079
     C                   PARM                    TranInCufd                                   CSD079
     C                   PARM                    TranInChec                                   CSD079
     C                   PARM                    TranInCusf                                   CSD079
     C                   PARM                    TranInRwan                                   CSD079
     C                   PARM                    TranInCufo                                   CSD079
     C                   PARM                    TranInCupm                                   CSD079
     C                   PARM                    TranInTicd                                   CSD079
     C                   PARM                    TranInCurx                                   CSD079
     C                   PARM                    CuSwft                                       CSW207
     C                   PARM                    TranInCtnm                                AR1086546
     C**********         PARM                    CuSW13                              CFT050 MD022463
     C                   PARM                    CuCUXC                                       CGL132
     C                   PARM                    CuFATC                                       CGL132
      ** SDCRSSPD Transaction Details Screen Format                                           CGL157
     C                   PARM                    CrsdDets                                     CGL157
                                                                                              CGL157
     C                   PARM                    PCrsdS                                       CGL157
                                                                                              CGL157
     C/COPY WNCPYSRC,SDCUSDNC02
 
      *
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDCUSDCVT'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS MIDAS MODULES
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS PORTFOLIO MANAGEMNT DETAILS
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST'      @OPTN             7
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Access SAR details file to determine if SAR function S01383
      ** Base Rate Tax is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   ELSE
     C                   MOVEL     'N'           S01383
     C                   END
      *
      ** Access SAR details file to determine if Customer Deletion in COB
      ** (S01424) is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01424'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01424            1
     C                   ELSE
     C                   MOVEL     'N'           S01424
     C                   END
      *
      ** Access SAR details file to determine if CHIPS 2 is present
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01429'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01429            1
     C                   ELSE
     C                   MOVEL     'N'           S01429
     C                   END
                                                                                              CDL008
      ** Access SAR details file to determine if CDL008                                       CDL008
      ** Continuous Linked Settlement (CLS) is on.                                            CDL008
                                                                                              CDL008
     C                   CALLB     'AOSARDR0'                                                 CDL008
     C                   PARM      *BLANKS       @RTCD                                        CDL008
     C                   PARM      '*VERIFY'     @OPTN                                        CDL008
     C                   PARM      'CDL008'      @SARD                                        CDL008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL008
                                                                                              CDL008
     C     @RTCD         IFEQ      *BLANK                                                     CDL008
     C                   MOVEL     'Y'           CDL008            1                          CDL008
     C                   ELSE                                                                 CDL008
     C                   MOVEL     'N'           CDL008                                       CDL008
     C                   ENDIF                                                                CDL008
                                                                                              CSW024
      ** Access SAR details file to determine if CSW024                                       CSW024
      ** S.W.I.F.T. MT3xx Field 82/83/87 is installed.                                        CSW024
                                                                                              CSW024
     C                   CALLB     'AOSARDR0'                                                 CSW024
     C                   PARM      *BLANKS       @RTCD                                        CSW024
     C                   PARM      '*VERIFY'     @OPTN                                        CSW024
     C                   PARM      'CSW024'      @SARD                                        CSW024
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW024
                                                                                              CSW024
     C     @RTCD         IFEQ      *BLANK                                                     CSW024
     C                   MOVEL     'Y'           CSW024            1                          CSW024
     C                   ELSE                                                                 CSW024
     C                   MOVEL     'N'           CSW024                                       CSW024
     C                   ENDIF                                                                CSW024
                                                                                              CGP001
      ** Check if Global Data Layout Enhancement (CGP001) is on.                              CGP001
                                                                                              CGP001
     C                   EVAL      CGP001 = 'N'                                               CGP001
                                                                                              CGP001
     C                   CALLB     'AOSARDR0'                                                 CGP001
     C                   PARM      *BLANKS       @RTCD                                        CGP001
     C                   PARM      '*VERIFY'     @OPTN                                        CGP001
     C                   PARM      'CGP001'      @SARD                                        CGP001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGP001
                                                                                              CGP001
     C                   IF        @RTCD = *BLANKS                                            CGP001
     C                   EVAL      CGP001 = 'Y'                                               CGP001
     C                   ENDIF                                                                CGP001
                                                                                              CSW036
      ** Check if CSW036 is ON                                                                CSW036
     C                   CALLB     'AOSARDR0'                                                 CSW036
     C                   PARM      *BLANKS       @RTCD                                        CSW036
     C                   PARM      '*VERIFY'     @OPTN                                        CSW036
     C                   PARM      'CSW036'      @SARD                                        CSW036
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW036
                                                                                              CSW036
     C                   MOVE      'N'           CSW036            1                          CSW036
     C                   if        @RTCD = *BLANKS                                            CSW036
     C                   move      'Y'           CSW036                                       CSW036
     C                   endif                                                                CSW036
      *                                                                                       CSW037
      ** Check if CSW037 is ON                                                                CSW037
      *                                                                                       CSW037
     C                   EVAL      CSW037 = 'N'                                               CSW037
      *                                                                                       CSW037
     C                   CALLB     'AOSARDR0'                                                 CSW037
     C                   PARM      *BLANKS       @RTCD                                        CSW037
     C                   PARM      '*VERIFY'     @OPTN                                        CSW037
     C                   PARM      'CSW037'      @SARD                                        CSW037
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW037
      *                                                                                       CSW037
     C                   IF        @RTCD = *BLANKS                                            CSW037
     C                   MOVE      'Y'           CSW037            1                          CSW037
     C                   ENDIF                                                                CSW037
                                                                                              CSD025
      ** Check if Global Data Layout Enhancement (CSD025) is on.                              CSD025
                                                                                              CSD025
     C                   MOVE      'N'           CSD025            1                          CSD025
                                                                                              CSD025
     C                   CALLB     'AOSARDR0'                                                 CSD025
     C                   PARM      *BLANKS       @RTCD                                        CSD025
     C                   PARM      '*VERIFY'     @OPTN                                        CSD025
     C                   PARM      'CSD025'      @SARD                                        CSD025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD025
                                                                                              CSD025
     C                   IF        @RTCD = *BLANKS                                            CSD025
     C                   EVAL      CSD025 = 'Y'                                               CSD025
     C                   ENDIF                                                                CSD025
      *
      ** Check if SWIFT 2007 is installed                                                     CSW207
                                                                                              CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       @RTCD                                        CSW207
                                                                                              CSW207
     C                   IF        @RTCD = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
     C/COPY WNCPYSRC,SDH00696
                                                                                              CSW207
      ** Check if enhancement S01425 is on                                                    CSD079
      *                                                                                       CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'S01425'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS                                           CSD079
     C                             AND  PRTCD <> '*NRF   '                                    CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'S01425'                                          CSD079
     C                   EVAL      DBASE  = 905                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      S01425 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      S01425 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement ULX004 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'ULX004'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS                                           CSD079
     C                             AND  PRTCD <> '*NRF   '                                    CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'ULX004'                                          CSD079
     C                   EVAL      DBASE  = 912                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
 
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      ULX004 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      ULX004 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement ULX609 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'ULX609'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS                                           CSD079
     C                             AND  PRTCD <> '*NRF   '                                    CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'ULX609'                                          CSD079
     C                   EVAL      DBASE  = 915                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      ULX609 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      ULX609 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if Lux(IBLC - Extended Information) ULX043 is on                               CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'ULX043'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS                                           CSD079
     C                             AND  PRTCD <> '*NRF   '                                    CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'ULX043'                                          CSD079
     C                   EVAL      DBASE  = 913                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      ULX043 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      ULX043 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement CSD008 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'CSD008'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS                                           CSD079
     C                             AND  PRTCD <> '*NRF   '                                    CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'CSD008'                                          CSD079
     C                   EVAL      DBASE  = 906                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      CSD008 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      CSD008 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement CDL002 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'CDL002'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS                                           CSD079
     C                             AND  PRTCD <> '*NRF   '                                    CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'CDL002'                                          CSD079
     C                   EVAL      DBASE  = 907                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      CDL002 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      CDL002 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement CDL006 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'CDL006'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS                                           CSD079
     C                             AND  PRTCD <> '*NRF   '                                    CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'CDL006'                                          CSD079
     C                   EVAL      DBASE  = 908                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      CDL006 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      CDL006 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement CGL018 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'CGL018'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS                                           CSD079
     C                             AND  PRTCD <> '*NRF   '                                    CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'CGL018'                                          CSD079
     C                   EVAL      DBASE  = 909                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      CGL018 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      CGL018 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check if enhancement CSD079 is on                                                    CSD079
                                                                                              CSD079
     C                   CALLB     'AOSARDR0'                                                 CSD079
     C                   PARM      *BLANKS       PRTCD                                        CSD079
     C                   PARM      '*VERIFY'     POPTN                                        CSD079
     C                   PARM      'CSD079'      PSARD                                        CSD079
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD079
                                                                                              CSD079
     C                   IF        PRTCD <> *BLANKS                                           CSD079
     C                             AND  PRTCD <> '*NRF   '                                    CSD079
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD079
     C                   EVAL      DBKEY  = 'CSD079'                                          CSD079
     C                   EVAL      DBASE  = 910                                               CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C                   IF        PRTCD = *BLANKS                                            CSD079
     C                   EVAL      CSD079 = 'Y'                                               CSD079
     C                   ELSE                                                                 CSD079
     C                   EVAL      CSD079 = 'N'                                               CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Check Customer Segmentation feature if installed                                     CSD090
                                                                                              CSD090
     C                   CALLB     'AOSARDR0'                                                 CSD090
     C                   PARM      *BLANKS       PRTCD                                        CSD090
     C                   PARM      '*VERIFY'     POPTN                                        CSD090
     C                   PARM      'CSD090'      PSARD                                        CSD090
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD090
                                                                                              CSD090
     C                   IF        PRTCD <> *BLANKS                                           CSD090
     C                             AND  PRTCD <> '*NRF   '                                    CSD090
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD090
     C                   EVAL      DBKEY  = 'CSD090'                                          CSD090
     C                   EVAL      DBASE  = 916                                               CSD090
     C                   EXSR      *PSSR                                                      CSD090
     C                   ENDIF                                                                CSD090
                                                                                              CSD090
     C                   IF        PRTCD = *BLANKS                                            CSD090
     C                   EVAL      CSD090 = 'Y'                                               CSD090
     C                   ELSE                                                                 CSD090
     C                   EVAL      CSD090 = 'N'                                               CSD090
     C                   ENDIF                                                                CSD090
                                                                                              CSD090
                                                                                              CGL132
      ** Check if CGL132 is switched on                                                       CGL132
                                                                                              CGL132
     C                   CALLB     'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       @RTCD                                        CGL132
     C                   PARM      '*VERIFY'     @OPTN                                        CGL132
     C                   PARM      'CGL132'      @SARD                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
     C     @RTCD         IFEQ      *BLANK                                                     CGL132
     C                   MOVEL     'Y'           CGL132            1                          CGL132
     C                   ELSE                                                                 CGL132
     C                   MOVEL     'N'           CGL132                                       CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL157
      ** Check if CGL157 is switched on                                                       CGL157
                                                                                              CGL157
     C                   CALLB     'AOSARDR0'                                                 CGL157
     C                   PARM      *BLANKS       @RTCD                                        CGL157
     C                   PARM      '*VERIFY'     @OPTN                                        CGL157
     C                   PARM      'CGL157'      @SARD                                        CGL157
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL157
                                                                                              CGL157
     C     @RTCD         IFEQ      *BLANK                                                     CGL157
     C                   MOVEL     'Y'           CGL157                                       CGL157
     C                   ELSE                                                                 CGL157
     C                   MOVEL     'N'           CGL157                                       CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
      ** Check if Portfolio Management Enhancement is on                                      CSD079
                                                                                              CSD079
     C     BGPFMG        IFEQ      'Y'                                                        CSD079
     C                   CALLB     'AOPORTR0'                                                 CSD079
     C                   PARM      '*MSG    '    @RTCD                                        CSD079
     C                   PARM      '*FIRST  '    @OPTN                                        CSD079
     C     SDPORT        PARM      SDPORT        DSSDY                                        CSD079
                                                                                              CSD079
      ** Database error                                                                       CSD079
                                                                                              CSD079
     C     @RTCD         IFNE      *BLANK                                                     CSD079
     C                   MOVEL     @OPTN         DBKEY                                        CSD079
     C                   MOVEL     'SDPORTPD'    DBFILE                                       CSD079
     C                   MOVEL     '911'         DBASE                                        CSD079
     C                   EXSR      *PSSR                                                      CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      ** Portfolios Supported is Customer                                                     CSD079
                                                                                              CSD079
     C     FCPORS        IFEQ      'C'                                                        CSD079
     C                   MOVEL     'Y'           WUPMSC                                       CSD079
     C                   ELSE                                                                 CSD079
                                                                                              CSD079
      ** Retrieve Int Cust Branch - Branch Codes                                              CSD079
                                                                                              CSD079
     C                   EXSR      TWRVGN                                                     CSD079
                                                                                              CSD079
      ** Return code is Customer on branch codes                                              CSD079
                                                                                              CSD079
     C     W0RTN         IFEQ      'BRANCH'                                                   CSD079
     C                   MOVEL     'Y'           WUPMSC                                       CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVEL     'N'           WUPMSC                                       CSD079
     C                   ENDIF                                                                CSD079
     C                   ENDIF                                                                CSD079
     C                   ELSE                                                                 CSD079
     C                   MOVEL     'N'           WUPMSC                                       CSD079
     C                   ENDIF                                                                CSD079
                                                                                              CSD079
      *                                                                                       CLE134
      ** Check if feature CLE134 Past Due Processing is on.                                   CLE134
      *                                                                                       CLE134
     C                   CALLB     'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       PRTCD                                        CLE134
     C                   PARM      '*VERIFY'     POPTN                                        CLE134
     C                   PARM      'CLE134'      PSARD                                        CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
      *                                                                                       CLE134
     C                   IF        PRTCD <> *BLANKS                                           CLE134
     C                             AND PRTCD <> '*NRF   '                                     CLE134
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE134
     C                   EVAL      DBKEY = 'CLE134'                                           CLE134
     C                   EVAL      DBASE = 916                                                CLE134
     C                   EXSR      *PSSR                                                      CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       CLE134
     C                   IF        PRTCD = *BLANKS                                            CLE134
     C                   EVAL      CLE134 = 'Y'                                               CLE134
      *                                                                                       CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      CLE134 = 'N'                                               CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       CLE134
      ** Check if feature CDL025 is switched on.                                           AR1086546
                                                                                           AR1086546
     C                   CALLB     'AOSARDR0'                                              AR1086546
     C                   PARM      *BLANKS       PRTCD                                     AR1086546
     C                   PARM      '*VERIFY'     POPTN                                     AR1086546
     C                   PARM      'CDL025'      PSARD                                     AR1086546
     C     SCSARD        PARM      SCSARD        DSFDY                                     AR1086546
                                                                                           AR1086546
     C                   IF        PRTCD      <> *BLANKS       AND                         AR1086546
     C                             PRTCD      <> '*NRF   '                                 AR1086546
     C                   EVAL      DBFILE      = 'SCSARDPD'                                AR1086546
     C                   EVAL      DBKEY       = 'CDL025'                                  AR1086546
     C                   EVAL      DBASE       = 917                                       AR1086546
     C                   EXSR      *PSSR                                                   AR1086546
     C                   ENDIF                                                             AR1086546
      *                                                                                    AR1086546
     C                   IF        PRTCD       = *BLANKS                                   AR1086546
     C                   EVAL      CDL025      = 'Y'                                       AR1086546
      *                                                                                    AR1086546
     C                   ELSE                                                              AR1086546
     C                   EVAL      CDL025      = 'N'                                       AR1086546
     C                   ENDIF                                                             AR1086546
      *                                                                                     MD030956
      ** Check if feature CTI006 is switched on.                                            MD030956
      *                                                                                     MD030956
     C                   CALLB     'AOSARDR0'                                               MD030956
     C                   PARM      *BLANKS       PRTCD                                      MD030956
     C                   PARM      '*VERIFY'     POPTN                                      MD030956
     C                   PARM      'CTI006'      PSARD                                      MD030956
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD030956
                                                                                            MD030956
     C                   IF        PRTCD  <> *BLANKS AND                                    MD030956
     C                             PRTCD  <> '*NRF   '                                      MD030956
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD030956
     C                   EVAL      DBKEY  = 'CTI006'                                        MD030956
     C                   EVAL      DBASE  = 918                                             MD030956
     C                   EXSR      *PSSR                                                    MD030956
     C                   ENDIF                                                              MD030956
      *                                                                                     MD030956
     C                   IF        PRTCD  = *BLANKS                                         MD030956
     C                   EVAL      CTI006 = 'Y'                                             MD030956
     C                   ELSE                                                               MD030956
     C                   EVAL      CTI006 = 'N'                                             MD030956
     C                   ENDIF                                                              MD030956
      *                                                                                     MD030956
     C                   ENDSR
      *****************************************************************                       CSD079
      /EJECT                                                                                  CSD079
      *****************************************************************                       CSD079
      *                                                               *                       CSD079
      *  Retrieve Int Cust Branch - Branch Codes                      *                       CSD079
      *                                                               *                       CSD079
      *****************************************************************                       CSD079
                                                                                              CSD079
     CSR   TWRVGN        BEGSR                                                                CSD079
     C                   MOVEL     *BLANK        W0RTN                                        CSD079
     C     BBCUST        SETLL     @BRCHFM                                                    CSD079
     C     BBCUST        READE     @BRCHFM                                90                  CSD079
     C     *IN90         IFEQ      *ON                                                        CSD079
                                                                                              CSD079
      ** Data record not found                                                                CSD079
                                                                                              CSD079
     C                   MOVEL     *BLANK        W0RTN                                        CSD079
     C                   LEAVESR                                                              CSD079
     C                   ENDIF                                                                CSD079
      *                                                                                       CSD079
     C     *IN90         DOWEQ     *OFF                                                       CSD079
                                                                                              CSD079
      ** USER: Process Data record                                                            CSD079
                                                                                              CSD079
     C                   MOVEL     *BLANK        W0RTN                                        CSD079
     C                   MOVEL     'BRANCH'      W0RTN                                        CSD079
     C     DDCUSN        READE     @BRCHFM                                90                  CSD079
     C                   ENDDO                                                                CSD079
     C                   ENDSR                                                                CSD079
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
