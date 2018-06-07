     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Country of Tax Codes Maintenance')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000780 - Country of Tax Codes Maintenance                  *
      *                                                               *
      *  Function:  This program maintains the Country of Tax Codes   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD036195           Date 20Oct15               *
      *  Prev Amend No. MD036194           Date 16Oct15               *
      *                 CGL157             Date 17Aug15               *
      *                 MD046248           Date 27Oct17               *
      *                 MD033960           Date 29Jun15               *
      *                 AR808125           Date 03Aug11               *
      *                 AR795958           Date 29Jun11               *
      *                 AR795965           Date 27Jun11               *
      *                 AR738246A          Date 28Apr11               *
      *                 AR738246           Date 26Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26850           Date 21Dec09               *
      *                 BUG26841           Date 11Dec09               *
      *                 BUG26629           Date 04Nov09               *
      *                 BUG26436           Date 26Oct09               *
      *                 BUG25206           Date 28Jul09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23659           Date 13Apr09               *
      *                 BUG23639           Date 01Apr09               *
      *                 BUG23587           Date 25Mar09               *
      *                 BUG22517A          Date 06Feb09               *
      *                 BUG22534           Date 29Jan09               *
      *                 BUG22517           Date 02Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236137             Date 20Sep05               *
      *                 234037             Date 21Jun05               *
      *                 233696             Date 25May05               *
      *                 233082             Date 15Apr05               *
      *                 232543             Date 05Apr05               *
      *                 CGL035             Date 05Mar05               *
      *                 CGL032  *CREATE    Date 06Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD036195- Effective Date input is not retained               *
      *  MD036194 - Incorrect Error Message is displayed for setting  *
      *             invalid CRS Agreement input                       *
      *  CGL157 - CRS Reporting                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD033960 - Allow 'Y' as Default Tax Status for CER069.       *
      *  AR808125 - Allow '?' in third tax account code               *
      *  AR795958 - main and secondary tax basket                     *
      *  AR795965 - Validate third tax effective date only if         *
      *             recently amended                                  *
      *  AR738246A- Secondary Tax Account Code is mandatory if default*
      *             tax status is "T"; made Third Tax details as      *
      *             optional (Child: AR738247)                        *
      *  AR738246 - Secondary Tax Account Code is mandatory if default*
      *             tax status is "T" (Child: AR738247)               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26850 - Account Key Generator                             *
      *  BUG26841 - Third tax fields, though without fieldnames,      *
      *             are appearing in Country of Tax Codes (Recompile) *
      *  BUG26629 - Value on secondary effect date is getting blank   *
      *             when "A" is selected in the option box for Country*
      *             of Tax Codes Maintenance                          *
      *  BUG26436 - Third Tax Effec Date and Third Tax Accout Code    *
      *             is blank upon enquiry                             *
      *  BUG25206 - Country of Tax Codes missing field? (Recompile)   *
      *  CER054 - German Features - Church Tax                        *
      *  BUG23659 - Country Tax Codes date err                        *
      *  BUG23639 - Country of Tax Codes 3 issues                     *
      *  BUG23587 - Saving Account Threshold no more required         *
      *  BUG22517A - Stop validation of other threshold fields when   *
      *           country of residence is blank                       *
      *  BUG22534 - Date validation error.                            *
      *  BUG22517 - Re-order display fields to fit correct logic      *
      *  CER048 - German Features - Taxes                             *
      *  236137 - Change Control 1 for CGL031 & CGL032 - Part 4       *
      *           Changes to Premium and Discount Accrual Processing. *
      *           to maintain SDCTTXPD 6 new fields.                  *
      *  234037 - Problem on account code when country of residence   *
      *           used for the first time.                            *
      *  233696 - Problem on amending the account code                *
      *  233082 - Country of Tax Maintenance call on AOTXBSR0         *
      *  232543 - Fix to CGL032                                       *
      *  CGL035 - EUSD Upgrade to MidasPlus                           *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         F3 Exit                                         *
      *    05         F5 Refresh                                      *
      *    09         F9 Add/Change Mode                              *
      *    27         Rollup/Rolldown Key                             *
      *    31         Maintenance/Enquiry Mode                        *
      *    32         Invalid Selection                               *
      *    33         Invalid Country of Tax Code                     *
      *    34         Invalid Country Name                            *
      *    35         Invalid Country of Residence Code               *
      *    40         Global Error Indicator                          *
      *    56         De Minimis Rule Applicable in error     (#2DMAP)*                       236137
      *    57         Total Discount Percentage in error      (#2TTDP)*                       236137
      *    58         Yearly Discount Percentage in error     (#2YRDP)*                       236137
      *    59         Tax Calculation Basis in error          (#2TXCB)*                       236137
      *    60         READ/READP/CHAIN Indicator                      *
      *    61         WRITE Indicator                                 *
      *    62         READC Indicator                                 *
      *    64         Premium Amortiz. to be Deduct. in error (#2PADD)*                       236137
      *    65         Delta of TIS Taxable Only in error      (#2TIST)*                       236137
      *    78         Protect Country of Tax and Name                 *
      *    79         Protect Selection Field                         *
      *    80         Subfile Clear (SFLCLR)                          *
      *    81         Subfile Display (SFLDSP)                        *
      *    82         Subfile End (SFLEND)                            *
      *    83         Force Input Format                              *
      *    84         Subfile Next Change (SFLNXTCHG)                 *
      *    86         PUTOVR Indicator                                *
      *    87         Enable Key Screen                               *
      *    89         Add Mode                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  SRBuild       -  Initialise and load subfile page            *
      *  SRLoad        -  Load subfile page                           *
      *  SRDisplay     -  Display subfile                             *
      *  SRProcess     -  Process screen input                        *
      *  SRUpdate      -  Update records from subfile                 *
      *  SRDetail      -  Process action requested                    *
      *  SRAddRec      -  Process add request                         *
      *  SRDelReq      -  Process delete request                      *
      *  SRUpdReq      -  Process update request                      *
      *  SRTrailer     -  Update Control Files                        *
      *  SRMode        -  Switch between *ADD and *CHANGE modes       *
      *  SRReload      -  Request subfile reload                      *
      *  SRProtect     -  Set display attributes for subfile record   *
      *  SRClrScrn     -  Initialise subfile record                   *
      *  SRMove        -  Transfer records from SDCTTXL1 to subfile   *
      *  SRWrite       -  Create Country of Tax Details               *
      *  SRDelete      -  Delete Country of Tax Details               *
      *  SRAmend       -  Update Country of Tax Details               *
      *  SRZasnms      -  Message handling subroutine                 *
      *  SRZasnmsd     -  Message with data handling subroutine       *                       236137
      *  SREnd         -  End program                                 *
      *  *PSSR         -  Error handling subroutine                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSD000780DFCF   E             WORKSTN USROPN
     F                                     SFILE(SD000780S1:SRLRN)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
 
      ** Country of Tax Codes Update Index
     FSDCTTXL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(CTTXL0)
     F                                     COMMIT
     F                                     RENAME(SDCTTXD0:@CTTXL0)
 
      ** Country of Tax Codes Retrieval Index
     FSDCTTXL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(CTTXL1)
     F                                     RENAME(SDCTTXD0:@CTTXL1)
 
      ** Country of Tax Codes by Country of Residenc
     FSDCTTXL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCTTXD0:@CTTXL2)
                                                                                            BUG26850
      ** Country of Tax Codes by Main Tax Account Code                                      BUG26850
     FSDCTTXL5  IF   E           K DISK    INFSR(*PSSR)                                     BUG26850
     F                                     RENAME(SDCTTXD0:@CTTXL5)                         BUG26850
                                                                                            BUG26850
      ** Country of Tax Codes by Secondary Tax Account Code                                 BUG26850
     FSDCTTXL6  IF   E           K DISK    INFSR(*PSSR)                                     BUG26850
     F                                     RENAME(SDCTTXD0:@CTTXL6)                         BUG26850
                                                                                            BUG26850
      ** Country of Tax Codes with blank Country of Residence                               BUG26850
     FSDCTTXL7  IF   E           K DISK    INFSR(*PSSR)                                     BUG26850
     F                                     RENAME(SDCTTXD0:@CTTXL7)                         BUG26850
 
      ** Control File Update Index
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
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
 
      ** Review from fields
     D                 DS
     D  SPOSN                  1      5
     D WCTRTST         DS
     D  WTestF1                1      1A
     D  WTestF2                2      2A
 
      ** File Information
     D CTTXL0          DS
     D  #CTTX0                 9      9
     D CTTXL1          DS
     D  #CTTX1                 9      9
 
      ** Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
 
      ** Rundate data area
     D RUNDAT          DS
     D  WSUC                  11     11
     D  WMBIN                 13     13
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Country Details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      ** External data structure for Account Code Details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                                       CER048
      ** External DS for SAR Details                                                          CER048
      *                                                                                       CER048
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER048
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D CAIN89          S              1
     D CPY2@           S             80
 
      ** Database error workfields
     D PRTCD           S              7
     D POPTN           S              7
     D PCNCD           S              2
     D*PACOD*****      S              4                                                       CGL035
     D PACOD           S             10                                                       CGL035
 
      ***Message*file*workfields***************************************                       236137
      ** Message file workfields - Parameters list for ZA0340 / ZA0350.                       236137
     D PZMsgFile       S             10A   INZ('GBSDUSRMSG')
     D PZMsgID         S             10
     D PZMsgDta        S             45A                                                      236137
      ** Message data fields used as substitution values.                                     236137
     D #2TTDPLabel     S             14    INZ('Total Discount')                              236137
     D #2YRDPLabel     S             15    INZ('Yearly Discount')                             236137
 
      ** Parameters for AOTXBSR0
     D PIRTCD          S              7A
     D PIOPTN          S              7A
     D PICRTT          S              2A
     D PITXBS          S              2A
     D PIDATE          S              5P 0
     D PINARR          S             15A
     D PIRATE          S              6P 4
 
      ** General workfields
     D CAIN81          S              1
     D PMODE           S              1
                                                                                              236137
      ** Screen field original contents save variables.                                       236137
     D P2TXS1          S              1
     D P2EDT1          S              6
     D P2TRT1          S              1
     D P2TXS2          S              1
     D P2EDT2          S              6
     D P2TRT2          S              1
     D P2TXBS          S              2
     D*P2WTAC***       S              4                                                       CGL035
     D P2WTAC          S             10                                                       CGL035
     D P2DMAP          S              1                                                       236137
     D P2TTDP          S              7                                                       236137
     D P2YRDP          S              7                                                       236137
     D P2TXCB          S              1                                                       236137
     D P2PADD          S              1                                                       236137
     D P2TIST          S              1                                                       236137
                                                                                              236137
     D P2CRSA          S              1                                                       CGL157
     D P2FRYR          S              4                                                       CGL157
     D P2EFDT          S              6                                                       CGL157
     D P2RPDT          S              4                                                       CGL157
     D WFRYRN          S              4  0                                                    CGL157
     D WWEFDT          S              5P 0                                                    CGL157
     D CGL157          S              1                                                       CGL157
     D WWRTN           S              1                                                       CGL157
                                                                                              CGL157
     D WKIPIN          S              1
     D WFNAM           S             10
     D WCTRT           S              1
     D WCTRR           S              2
     D WCTRN           S             30
     D WDATEN          S              6  0
     D WDATEA          S              6
     D WLRCD           S              4  0
     D WNODAT          S              1
     D WPOSN           S              5
     D WRCTR           S              5  0
     D WSFPG           S              3  0
     D WSLCTR          S              3  0
     D WTXBSN          S              6  0
     D WTXBSA          S              6
     D WVEDT1          S              5  0
     D WVEDT2          S              5  0
     D WVEFDT          S              5P 0                                                    CGL157
     D WWDAYN          S              5P 0                                                    CGL157
     D WWDATE          S              8S 0                                                    CGL157
     D WWFRYR          S              4S 0                                                    CGL157
     D WWTACN          S              6  0
     D WWTACA          S              6
     D W0NLR           S              1
     D W1PMD           S              3
     D W1RSF           S              1
     D W2RSF           S              1
     D W#EROR          S              1
     D W#EROR2         S              1
                                                                                              236137
      ** Total and Yearly Discount percentages numeric values.                                236137
     D WWTTDP          S              6  3                                                    236137
     D WWYRDP          S              6  3                                                    236137
 
      ** QDCXLATE workfields
     D WQA5N           S              5  0
     D WQB10X          S             10
     D WQC10X          S             10
 
      ** QCLSCAN workfields
     D WQA3N           S              3  0
     D WQB3N           S              3  0
     D WQC3N           S              3  0
     D WQG3N           S              3  0
     D WQD1            S              1
     D WQE1            S              1
     D WQF1            S              1
 
      ** Subfile workfields
     D WSkipRec        S              1
     D WKeyScrn        S              1
     D WDetScrn        S              1
     D WValid          S              1
 
      ** Date workfields
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A
     D WEWSEDT         S              5  0 INZ(0)                                           BUG23659
                                                                                              236137
      ** Parameters for ZALIGN/ZEDIT                                                          236137
     D ZALIGNOK        S              1                                                       236137
     D ZFIELD          S             16                                                       236137
     D ZADEC           S              1  0                                                    236137
     D ZADIG           S              2  0                                                    236137
      *                                                                                       CER048
      ** Declare variable for Country of Tax Codes Maintenance                                CER048
      *                                                                                       CER048
     D CER048          S              1A                                                      CER048
     D P2StXb          S              2A                                                      CER048
     D P2StAc          S             10A                                                      CER048
     D P2SeDt          S              6A                                                      CER048
     D P2RaRl          S              8A                                                      CER048
     D P2RaEd          S              6A                                                      CER048
     D P2PaRl          S              8A                                                      CER048
     D P2InTh          S              7A                                                      CER048
     D P2JtTh          S              7A                                                      CER048
     D P2EcTh          S              7A                                                      CER048
     D*P2SaTh***       S              7A                                             CER048 BUG23587
     D P2MpCr          S              1A                                                      CER048
     D P2ThMd          S              1A                                                      CER048
     D WVSeDt          S              5P 0                                                    CER048
     D WVRaEd          S              5P 0                                                    CER048
     D PAcCd           S             10A                                                      CER048
     D PCrTx           S              2A                                                      CER048
     D PTxbs           S              2A                                                      CER048
     D PPsvd           S              5P 0                                                    CER048
     D PNarr           S             15A                                                      CER048
     D PTxrt           S              6P 4                                                    CER048
     D PSard           S              6A                                                      CER048
     D*WWSaTh***       S              5P 2                                           CER048 BUG23587
     D WWRaRl          S              7P 5                                                    CER048
     D WWPaRl          S              7P 5                                                    CER048
     D WInTh           S              6A                                                      CER048
     D WJtTh           S              6A                                                      CER048
     D WEcTh           S              6A                                                      CER048
     D W2InTh          S              6A                                                      CER048
     D W2JtTh          S              6A                                                      CER048
     D W2EcTh          S              6A                                                      CER048
      *                                                                                    BUG22517A
      ** Threshold Method Error Flag                                                       BUG22517A
     D ThMtd#Err       S               N                                                   BUG22517A
      *                                                                                       CER054
      ** Third Tax work fields                                                                CER054
      *                                                                                       CER054
     D CER054          S              1A                                                      CER054
     D P3TtXb          S              2A                                                      CER054
     D P3TtAm          S              1A                                                      CER054
     D P3TtAc          S             10A                                                      CER054
     D P3TeDt          S              6A                                                      CER054
     D WVteDt          S              5P 0                                                    CER054
      *                                                                                     BUG26850
      ** Variables for Main Tax Account Code checking                                       BUG26850
      *                                                                                     BUG26850
     D #ACCNT          S             10A                                                    BUG26850
     D #RDCNT          S              5P 0                                                  BUG26850
     D #RDERR          S              9A                                                    BUG26850
     D #MNACCNT        S             10A                                                    BUG26850
     D #SCACCNT        S             10A                                                    BUG26850
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Main Program
 
     C                   DO        *HIVAL
 
      ** Initialise and load subfile page
 
     C                   EXSR      SRBuild
 
     C                   EVAL      W1RSF = 'N'
 
      ** Display screen until reload requested
 
     C                   DOW       W1RSF = 'N'
 
      ** Display screen
 
     C                   EXSR      SRDisplay
 
      ** Process response
 
     C     *IN03         CASEQ     *ON           SREnd
 
     C     *IN05         CASEQ     *ON           SRReload
 
     C     *IN27         CASEQ     *ON           SRLoad
 
     C                   CAS                     SRProcess
     C                   ENDCS
     C                   IF        *IN03 = *ON
     C                   EXSR      SREnd
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDDO
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBuild - Initialise and Load Subfile Page                    *
      *                                                               *
      *****************************************************************
     C     SRBuild       BEGSR
 
      ** Initialise & load subfile page
 
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000780C1
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      WKeyScrn = 'N'
     C                   EVAL      WDetScrn = 'N'
     C                   EVAL      *IN79 = *OFF
 
      ** Reset Number of Records in Subfile
 
     C                   Z-ADD     0             WLRCD
 
      ** If CHANGE mode, then position file
 
 
     C                   IF        W1PMD <> 'ADD'
     C                   EVAL      WPOSN = SPOSN
 
      ** Setup key
 
     C     #1POS1        SETLL     @CTTXL1                            82
 
     C                   READ      @CTTXL1                                82
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF
 
      ** Save previous selector values
 
     C     *LIKE         DEFINE    #1POS1        WZCTRT
     C                   EVAL      WZCTRT = #1POS1
     C     *LIKE         DEFINE    #1POS2        WZCTNM
     C                   EVAL      WZCTNM = #1POS2
     C     *LIKE         DEFINE    #1POS3        WZCTRR
     C                   EVAL      WZCTRR = #1POS3
 
      ** Translate search mask for text field
 
     C     *LIKE         DEFINE    #1POS2        WQCTTR
 
     C                   CALL      'QDCXLATE'
     C                   PARM      20            WQA5N
     C                   PARM      #1POS2        WQCTTR
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X
 
      ** Load subfile page
 
     C                   EXSR      SRLoad
 
      ** If no records found, display error message
 
     C                   IF        *IN82 = *ON and SRLRN = 0
     C                   EVAL      PZMsgID = 'USR7590'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoad - Load Subfile Page                                    *
      *                                                               *
      *****************************************************************
     C     SRLoad        BEGSR
 
      ** Load subfile page but write empty page if add mode
 
     C                   EVAL      *IN84 = *OFF
 
      ** Re-establish fields in read-ahead record
 
     C                   IF        W1PMD <> 'ADD' and *IN27 = *ON and
     C                             *IN82 = '0'
     C                   READP     @CTTXL1                                60
     C                   READ      @CTTXL1                                60
     C                   ENDIF
 
      ** Start at previous highest record in SFL
 
     C                   Z-ADD     WLRCD         SRLRN
     C                   Z-ADD     1             WRCTR
 
      ** Load next subfile page
 
     C                   DOW       *IN82 = '0' and WRCTR <= WSFPG
 
     C                   EVAL      WSkipRec = 'N'
     C                   ADD       1             SRLRN
     C                   MOVEA     '000000'      *IN(32)
 
      ** Protect fields during Enquiry Mode
 
      ** Get Country Name
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      EWCTRT        PCNCD
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBPGM  = 'SD000780'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      #1CNNM = A4CNNM
     C                   ENDIF
 
     C                   IF        (W1PMD <> 'ADD')
     C                   SELECT
 
     C                   WHEN      #1POS1 <> *BLANK  AND  EWCTRT <> #1POS1
     C                   EVAL      WSkipRec = 'Y'
 
     C                   WHEN      #1POS3 <> *BLANK  AND  EWCTRR <> #1POS3
     C                   EVAL      WSkipRec = 'Y'
 
     C                   WHEN      #1POS2 <> *BLANKS
 
     C                   CALL      'QCLSCAN'
     C                   PARM                    A4CNNM
     C                   PARM      20            WQA3N
     C                   PARM      1             WQB3N
     C                   PARM                    WQCTTR
     C                   PARM      20            WQC3N
     C                   PARM      '1'           WQD1
     C                   PARM      '1'           WQE1
     C                   PARM      '?'           WQF1
     C                   PARM                    WQG3N
 
     C                   IF        WQG3N < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
 
     C                   ENDSL
     C                   ENDIF
 
     C                   IF        WSkipRec = 'N'
 
      ** Clear subfile fields
 
     C                   EXSR      SRClrScrn
 
      ** If CHANGE mode, load subfile fields
 
     C                   IF        W1PMD <> 'ADD'
     C                   EXSR      SRMove
 
     C                   ENDIF
 
      ** Output to subfile
 
     C                   ADD       1             WRCTR                81
     C                   EVAL      *IN81 = *ON
 
      ** If SFLRCD invalid, note that errors present
 
     C                   IF        *IN83 = *ON and *IN40 = '0'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
      ** Set screen conditioning indicators
 
     C                   EXSR      SRProtect
 
     C                   WRITE     SD000780S1
 
     C                   ELSE
     C                   SUB       1             SRLRN
     C                   ENDIF
 
      ** End of File
 
     C                   IF        W1PMD <> 'ADD'
     C                   READ      @CTTXL1                                82
     C                   ENDIF
 
     C                   ENDDO
 
     C                   Z-ADD     SRLRN         WLRCD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display Subfile                                  *
      *                                                               *
      *****************************************************************
 
     C     SRDisplay     BEGSR
 
      ** Set screen conditioning indicators
 
     C                   IF        W1PMD = 'ADD'
     C                   EVAL      *IN89 = *ON
     C                   ELSE
     C                   EVAL      *IN89 = *OFF
     C                   ENDIF
 
      ** PUTOVR unless conditioned fields change
 
     C                   IF        *IN89 <> CAIN89 OR *IN81 <> CAIN81
     C                   EVAL      *IN86 = *OFF
     C                   ENDIF
 
     C                   EVAL      CAIN89 = *IN89
     C                   EVAL      CAIN81 = *IN81
 
      ** Display appropriate Header depending upon Mode whether it is
      ** Enquiry or Maintenance
 
     C                   IF        PMODE = 'E'
     C                   EVAL      *IN31 = *ON
     C                   ENDIF
 
      ** Display appropriate Header depending upon Mode whether it is
      ** Enquiry or Maintenance
 
      ** Set cursor by *SET CURSOR data
 
     C                   TIME                    #1TIME
     C                   WRITE     SD000780C2
     C                   WRITE     SD000780F1
     C                   EXFMT     SD000780C1
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Process Screen Input                              *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
 
      ** Change of position specified
 
     C                   IF        W1PMD <> 'ADD' and WPOSN <> SPOSN
     C                             OR WZCTRT <> #1POS1  OR  WZCTNM <> #1POS2
     C                             OR WZCTRR <> #1POS3
     C                   EXSR      SRReload
     C                   ENDIF
 
      ** Quit if reload requested
 
     C                   IF        W1RSF <> 'Y'
 
     C                   IF        *IN81 = *ON
     C                   EVAL      WKIPIN = 'N'
     C                   ENDIF
 
      ** Process subfile records
 
     C                   EXSR      SRProcRec
 
 
      ** Switch between *ADD/*CHANGE modes is allowed when no errors
      ** exists during update
 
     C                   IF        *IN09 = *ON and *IN40 = *OFF
     C                   EXSR      SRMode
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update Records from Subfile                        *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
      ** Initialise subfile reload flag
 
     C                   IF        W1PMD = 'ADD'
     C                   EVAL      W1RSF = 'Y'
     C                   ELSE
     C                   EVAL      W1RSF = 'N'
     C                   ENDIF
 
     C                   EXSR      SRDetail
 
      ** Rollback any DBF changes if error occur
 
     C                   IF        W#EROR <> *BLANKS
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
      ** Cancel reload if errors occur
 
     C                   IF        *IN40 = *ON
     C                   EVAL      W1RSF = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetail - Process action requested                           *
      *                                                               *
      *****************************************************************
     C     SRDetail      BEGSR
 
      ** Set off error indicators
 
     C                   MOVEA     '000000'      *IN(32)
     C                   EVAL      *IN83 = *OFF
 
     C                   EXSR      SRWrite
     C                   IF        *IN83 = *ON and *IN40 = *OFF
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcRec - Process Request                                   *
      *                                                               *
      *****************************************************************
     C     SRProcRec     BEGSR
 
      ** Create Country Tax Code Details
 
     C     WKYCTR        KLIST
     C                   KFLD                    #1CTRT
     C                   KFLD                    #1CTRR
     C     WKYCNR        KLIST
     C                   KFLD                    #1CNRT
     C                   KFLD                    #1CNRR
 
     C                   EVAL      #1CNRT = *BLANKS
     C                   EVAL      #1CNRR = *BLANKS
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN71 = *OFF
     C                   EVAL      *IN73 = *OFF
     C                   EVAL      *IN70 = *ON
     C                   EVAL      *IN89 = *ON
 
      ** Process Amend/Delete Request
     C                   IF        W1PMD = 'CHG' and *IN09 <> *ON
 
     C                   DOW       *IN03 = *OFF and *IN12 = *OFF
     C                             and W1RSF = 'N' and WLRCD <> *ZEROS
 
      ** Check if Enquire
     C                   READC     SD000780S1                             62
 
     C                   DOW       *IN62 = *OFF
      ** Invalid Action Code
     C                   IF        (#1ACTN <> 'E' and #1ACTN <> 'D' and
     C                             #1ACTN <> 'A') or (#1ACTN <> 'E' and
     C                             PMODE = 'E'  )
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      PZMsgID = 'USR4429'
     C                   IF        PMODE = 'E'
     C                   EVAL      PZMsgID = 'USR7710'
     C                   ENDIF
     C                   EXSR      SRZasnms
     C                   EVAL      *IN40 = *ON
     C                   LEAVE
     C                   ELSE
 
     C                   IF        #1ACTN = 'E'
     C                   EXSR      SREnqReq
     C                   ENDIF
 
      ** Check if Delete
     C                   IF        #1ACTN = 'D' and PMODE = 'M'
     C                   EXSR      SRDelReq
     C                   ENDIF
 
      ** Check if Amend
     C                   IF        #1ACTN = 'A' and PMODE = 'M'
     C                   EXSR      SRAmdReq
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        *IN12 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   LEAVE
     C                   ENDIF
 
     C                   READC     SD000780S1                             62
     C                   IF        *IN62 = *OFF
     C                   EVAL      W1RSF = 'N'
     C                   ENDIF
 
     C                   ENDDO
     C                   EVAL      W1RSF = 'Y'
 
     C                   ENDDO
 
      ** If subfile is empty, resend message
 
     C                   IF        WLRCD = *ZEROS
     C                   EVAL      PZMsgID = 'USR7590'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        *IN09 = *ON and PMODE = 'M'
 
      ** Process Add Request
     C                   EXSR      SRAddReq
 
      ** Update Database
     C                   IF        (W#EROR =*BLANKS) AND (WKIPIN = 'Y')
     C                             and *IN12 = *OFF and *IN03 = *OFF
     C                   EXSR      SRUpdate
     C                   ENDIF
 
     C                   IF        W#EROR = *BLANKS and *IN12 = *OFF
     C                                              and *IN03 = *OFF
     C                   EVAL      W1PMD = 'ADD'
     C                   EXSR      SRTrailer
     C                   EXSR      SRReload
     C                   EVAL      *IN12 = *ON
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      *IN89 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnqReq - Process Enquire Request                            *
      *                                                               *
      *****************************************************************
     C     SREnqReq      BEGSR
 
     C     WKYCNR        CHAIN     SDCTTXL0                           08
 
     C                   IF        *IN08 = *ON
 
      ** Error message if record is missing
     C                   EVAL      *IN40 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7517'
     C                   EXSR      SRZasnms
     C                   ELSE
 
     C                   EXSR      SRScrn2Clr
 
      ** Get Country Name for Country Tax
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      EWCTRT        PCNCD
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7504'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      #1CNNM = A4CNNM
     C                   EVAL      #1CNRT = A4CNCD
     C                   ENDIF
 
      ** Get Country Name for Country of Residence
 
     C                   EVAL      WCTRN = *Blanks
     C                   IF        EWCTRR <> *BLANKS
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      EWCTRR        PCNCD
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7696'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      WCTRN = A4CNNM
     C                   EVAL      #1CNRR = A4CNCD
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      #2CTRT = #1CNRT
     C                   EVAL      #2CTNM = #1CNNM
     C                   EVAL      #2CTRR = #1CNRR
     C                   EVAL      #2CTRN = WCTRN
     C                   EVAL      #2TXS1 = EWTXS1
 
     C                   EVAL      ZDAYNO = EWEDT1
     C                   EXSR      ZDATE2
     C                   EVAL      #2EDT1 = *BLANKS
     C                   MOVEL     ZDATE         #2EDT1
     C                   EVAL      #2TRT1 = EWTRT1
     C                   EVAL      #2TXS2 = EWTXS2
     C                   IF        EWEDT2 <> 0
     C                   EVAL      ZDAYNO = EWEDT2
     C                   EXSR      ZDATE2
     C                   EVAL      #2EDT2 = *BLANKS
     C                   MOVEL     ZDATE         #2EDT2
     C                   ENDIF
     C                   EVAL      #2TRT2 = EWTRT2
     C                   EVAL      #2TXBS = EWTXBS
     C                   EVAL      #2WTAC = EWWTAC
     C                   EVAL      #2DMAP = EWDMAP                                            236137
     C                   MOVE      *BLANKS       ZFIELD                                       236137
     C     EWDMAP        IFEQ      'Y'                                                        236137
     C                   MOVE      EWTTDP        ZFIELD                                       236137
     C                   CALLB     'ZEDIT'                                                    236137
     C                   PARM                    ZFIELD                                       236137
     C                   PARM      3             ZADEC                                        236137
                                                                                              236137
     C                   ENDIF                                                                236137
     C                   MOVE      ZFIELD        #2TTDP                                       236137
     C                   MOVE      *BLANKS       ZFIELD                                       236137
     C     EWDMAP        IFEQ      'Y'                                                        236137
     C                   MOVE      EWYRDP        ZFIELD                                       236137
     C                   CALLB     'ZEDIT'                                                    236137
     C                   PARM                    ZFIELD                                       236137
     C                   PARM      3             ZADEC                                        236137
                                                                                              236137
     C                   ENDIF                                                                236137
     C                   MOVE      ZFIELD        #2YRDP                                       236137
     C                   EVAL      #2TXCB = EWTXCB                                            236137
     C                   EVAL      #2PADD = EWPADD                                            236137
     C                   EVAL      #2TIST = EWTIST                                            236137
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C                   EVAL      #2STXB = EWSTXB                                            CER048
     C                   EVAL      #2STAC = EWSTAC                                            CER048
      *                                                                                       CER048
      ** Formate Secondary Effective Date                                                     CER048
      *                                                                                       CER048
     C                   IF        EWSEDT <> *ZEROS                                           CER048
     C                   EVAL      ZDAYNO = EWSEDT                                            CER048
     C                   EXSR      ZDATE2                                                     CER048
     C                   EVAL      #2SEDT = *BLANKS                                           CER048
     C                   MOVEL     ZDATE         #2SEDT                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Formate Retail Accounts Average Rate Limit                                           CER048
      *                                                                                       CER048
     C                   MOVE      EWRARL        ZFIELD                                       CER048
     C                   EVAL      ZADEC = 5                                                  CER048
     C                   EXSR      SRZEDIT                                                    CER048
     C                   MOVE      ZFIELD        #2RARL                                       CER048
     C                   MOVE      *BLANKS       ZFIELD                                       CER048
      *                                                                                       CER048
      ** Formate Retail Accounts Average Rate Effective Date                                  CER048
      *                                                                                       CER048
     C                   IF        EWRAED <> *ZEROS                                           CER048
     C                   EVAL      ZDAYNO = EWRAED                                            CER048
     C                   EXSR      ZDATE2                                                     CER048
     C                   EVAL      #2RAED = *BLANKS                                           CER048
     C                   MOVEL     ZDATE         #2RAED                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Formate Previous Retail Accounts Rate Limit                                          CER048
      *                                                                                       CER048
     C                   MOVE      EWPARL        ZFIELD                                       CER048
     C                   EVAL      ZADEC = 5                                                  CER048
     C                   EXSR      SRZEDIT                                                    CER048
     C                   MOVE      ZFIELD        #2PARL                                       CER048
     C                   MOVE      *BLANKS       ZFIELD                                       CER048
     C**********         MOVE      EWINTH        #2INTH                              CER048 BUG23639
     C**********         MOVE      EWJTTH        #2JTTH                              CER048 BUG23639
     C**********         MOVE      EWECTH        #2ECTH                              CER048 BUG23639
     C                   EVAL      #2INTH = %EDITC(EWINTH:'Z')                              BUG23639
     C                   EVAL      #2JTTH = %EDITC(EWJTTH:'Z')                              BUG23639
     C                   EVAL      #2ECTH = %EDITC(EWECTH:'Z')                              BUG23639
      **********                                                                     CER048 BUG23587
      ***Formate*Saving*Accounts*Threshold                                           CER048 BUG23587
      **********                                                                     CER048 BUG23587
     C**********         MOVE      EWSATH        ZFIELD                              CER048 BUG23587
     C**********         EVAL      ZADEC = 2                                         CER048 BUG23587
     C**********         EXSR      SRZEDIT                                           CER048 BUG23587
     C**********         MOVE      ZFIELD        #2SATH                              CER048 BUG23587
     C**********         MOVE      *BLANKS       ZFIELD                              CER048 BUG23587
     C                   EVAL      #2MPCR = EWMPCR                                            CER048
     C                   EVAL      #2THMD = EWTHMD                                            CER048
      *                                                                                       CER048
      ** Set the Error Indicator                                                              CER048
      *                                                                                       CER048
     C                   EVAL      *IN14 = *OFF                                               CER048
     C                   EVAL      *IN15 = *OFF                                               CER048
     C                   EVAL      *IN16 = *OFF                                               CER048
     C                   EVAL      *IN17 = *OFF                                               CER048
     C                   EVAL      *IN18 = *OFF                                               CER048
     C                   EVAL      *IN19 = *OFF                                               CER048
     C                   EVAL      *IN20 = *OFF                                               CER048
     C                   EVAL      *IN21 = *OFF                                               CER048
     C**********         EVAL      *IN22 = *OFF                                      CER048 BUG23587
     C                   EVAL      *IN23 = *OFF                                               CER048
     C                   EVAL      *IN24 = *OFF                                               CER048
      *                                                                                       CER048
     C                   IF        CER054 = 'Y'                                               CER054
     C                   EVAL      #2TTAM = EWTTAM                                            CER054
     C                   EVAL      #2TTAC = EWTTAC                                            CER054
      *                                                                                       CER054
      ** Format Third Tax Effective Date                                                      CER054
      *                                                                                       CER054
     C                   IF        EWTEDT <> *ZEROS                                           CER054
     C                   EVAL      ZDAYNO = EWTEDT                                            CER054
     C                   EXSR      ZDATE2                                                     CER054
     C                   EVAL      #2TEDT = *BLANKS                                           CER054
     C                   MOVEL     ZDATE         #2TEDT                                       CER054
     C                   ENDIF                                                                CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
      ** Reset field error indicators                                                         CER054
      *                                                                                       CER054
     C                   EVAL      *IN90 = *OFF                                               CER054
     C                   EVAL      *IN91 = *OFF                                               CER054
     C                   EVAL      *IN92 = *OFF                                               CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER048
                                                                                              CGL157
     C                   IF        CGL157 = 'Y'                                               CGL157
     C                   EVAL      #2CRSA = EWCRSA                                            CGL157
     C                   EVAL      #2FRYR = EWFRYR                                            CGL157
     C                   EVAL      #2RPDT = EWRPDT                                            CGL157
     C                   IF        EWEFDT <> 0                                                CGL157
     C                   EVAL      ZDAYNO = EWEFDT                                            CGL157
     C                   EXSR      ZDATE2                                                     CGL157
     C                   EVAL      #2EFDT = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         #2EFDT                                       CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      W2RSF = 'N'
      ** Reset field error indicators.                                                        236137
     C                   MOVEA     '000000000000'*IN(43)
     C                   MOVEA     '0000'        *IN(56)                                      236137
     C                   MOVEA     '00'          *IN(64)                                      236137
     C                   IF        PMODE = 'E'
     C                   EVAL      *IN38 = *ON
     C                   ENDIF
 
     C                   DOW       *IN03 = *OFF and *IN12 = *OFF and
     C                             W2RSF = 'N'
     C                   WRITE     SD000780C2
     C                   WRITE     SD000780F1
     C                   EXFMT     SD000780D2
     C                   IF        *IN03 = *OFF and *IN12 = *OFF
     C                   EVAL      W2RSF = 'Y'
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDIF
     C                   EVAL      W1RSF = 'N'
     C                   IF        PMODE = 'E'
     C                   EVAL      *IN38 = *OFF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrn2 - Process Second Input Screen                         *
      *                                                               *
      *****************************************************************
     C     SRScrn2       BEGSR
 
      ** Error detected
     C                   MOVEA     '0000'        *IN(43)
     C                   EVAL      *IN55 = *ON
     C                   EVAL      *IN76 = *ON
 
     C                   IF        *IN09 = *ON
     C                   EXSR      SRScrn2Clr
     C                   EVAL      #2CTRT = #1CTRT
     C                   EVAL      #2CTNM = #1CNNM
     C                   EVAL      #2CTRR = #1CTRR
     C                   EVAL      #2CTRN = WCTRN
     C                   ENDIF
 
     C                   DOW       *IN03 = *OFF and *IN12 = *OFF and
     C                             W1RSF = 'N'
     C                   WRITE     SD000780C2
     C                   WRITE     SD000780F1
     C                   EXFMT     SD000780D2
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      W#EROR2 = 'N'
      ** Reset field error indicators.                                                        236137
     C                   MOVEA     '00000000'    *IN(47)
     C                   MOVEA     '0000'        *IN(56)                                      236137
     C                   MOVEA     '00'          *IN(64)                                      236137
     C                   MOVEA     '000'         *IN(67)                                      CGL157
     C                   MOVEA     '0'           *IN(72)                                      CGL157
     C                   IF        CER048 = 'Y'                                               CER048
     C                   MOVEA     '000000'      *IN(14)                                      CER048
     C                   MOVEA     '00000'       *IN(20)                                      CER048
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
     C                   EVAL      *IN90 = *OFF                                               CER054
     C                   EVAL      *IN91 = *OFF                                               CER054
     C                   EVAL      *IN92 = *OFF                                               CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER048
 
      ** If Exit not pressed, validate Input Screen 2
 
     C                   IF        *IN03 = *OFF and *IN12 = *OFF and
     C                             *IN05 = *OFF
     C                   EXSR      SRScrn2v
     C                   ENDIF
 
      ** If Refresh and Add action, clear fields
 
     C                   IF        *IN05 = *ON and *IN09 = *ON
     C                   EXSR      SRScrn2Clr
     C                   EVAL      #2CTRT = #1CTRT
     C                   EVAL      #2CTNM = #1CNNM
     C                   EVAL      #2CTRR = #1CTRR
     C                   EVAL      #2CTRN = WCTRN
     C                   ENDIF
 
      ** If Refresh and Amend action, restore original contents
 
     C                   IF        *IN05 = *ON and #1ACTN = 'A'
     C                   EVAL      #2TXS1 = P2TXS1
     C                   MOVEL     P2EDT1        #2EDT1
     C                   EVAL      #2TRT1 = P2TRT1
     C                   EVAL      #2TXS2 = P2TXS2
     C                   MOVEL     P2EDT2        #2EDT2
     C                   EVAL      #2TRT2 = P2TRT2
     C                   EVAL      #2TXBS = P2TXBS
     C                   EVAL      #2WTAC = P2WTAC
     C                   EVAL      #2DMAP = P2DMAP                                            236137
     C                   EVAL      #2TTDP = P2TTDP                                            236137
     C                   EVAL      #2YRDP = P2YRDP                                            236137
     C                   EVAL      #2TXCB = P2TXCB                                            236137
     C                   EVAL      #2PADD = P2PADD                                            236137
     C                   EVAL      #2TIST = P2TIST                                            236137
     C                   IF        CER048 = 'Y'                                               CER048
     C                   EVAL      #2STXB = P2StXb                                            CER048
     C                   EVAL      #2STAC = P2StAc                                            CER048
     C                   EVAL      #2SEDT = P2SeDt                                            CER048
     C                   EVAL      #2RARL = P2RaRl                                            CER048
     C                   EVAL      #2RAED = P2RaEd                                            CER048
     C                   EVAL      #2PARL = P2PaRl                                            CER048
     C                   EVAL      #2INTH = P2InTh                                            CER048
     C                   EVAL      #2JTTH = P2JtTh                                            CER048
     C                   EVAL      #2ECTH = P2EcTh                                            CER048
     C**********         EVAL      #2SATH = P2SaTh                                   CER048 BUG23587
     C                   EVAL      #2MPCR = P2MpCr                                            CER048
     C                   EVAL      #2THMD = P2ThMd                                            CER048
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
     C                   EVAL      #2TTAM = P3TtAm                                            CER054
     C                   EVAL      #2TTAC = P3TtAc                                            CER054
     C                   EVAL      #2TEDT = P3TeDt                                            CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER048
     C                   ENDIF
 
     C                   IF        *IN03 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      W1PMD = 'CHG'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
     C                   IF        W#EROR2 = 'N' and *IN05 = *OFF and
     C                             *IN12 = *OFF and *IN03 = *OFF
     C                   EVAL      W1PMD = 'CHG'
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      WKIPIN = 'Y'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        *IN12 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      W1PMD = 'CHG'
     C                   EVAL      #1CTRR = *BLANKS
     C                   EVAL      #1CTRT = *BLANKS
     C                   ENDIF
     C                   EVAL      *IN55 = *OFF
     C                   EVAL      *IN76 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrn2Clr - Clear fields for input in Second screen          *
      *                                                               *
      *****************************************************************
     C     SRScrn2Clr    BEGSR
 
     C                   EVAL      #2CTRT = *BLANKS
     C                   EVAL      #2CTNM = *BLANKS
     C                   EVAL      #2CTRR = *BLANKS
     C                   EVAL      #2CTRN = *BLANKS
     C                   EVAL      #2TXS1 = *BLANKS
     C                   EVAL      #2EDT1 = *BLANKS
     C                   EVAL      #2TRT1 = *BLANKS
     C                   EVAL      #2TXS2 = *BLANKS
     C                   EVAL      #2EDT2 = *BLANKS
     C                   EVAL      #2TRT2 = *BLANKS
     C                   EVAL      #2TXBS = *BLANKS
     C                   EVAL      #2WTAC = *BLANKS
     C                   EVAL      #2DMAP = *BLANKS                                           236137
     C                   EVAL      #2TTDP = *BLANKS                                           236137
     C                   EVAL      #2YRDP = *BLANKS                                           236137
     C                   EVAL      #2TXCB = *BLANKS                                           236137
     C                   EVAL      #2PADD = *BLANKS                                           236137
     C                   EVAL      #2TIST = *BLANKS                                           236137
     C                   EVAL      #2STXB = *BLANKS                                           CER048
     C                   EVAL      #2STAC = *BLANKS                                           CER048
     C                   EVAL      #2SEDT = *BLANKS                                           CER048
     C                   EVAL      #2RARL = *BLANKS                                           CER048
     C                   EVAL      #2RAED = *BLANKS                                           CER048
     C                   EVAL      #2PARL = *BLANKS                                           CER048
     C                   EVAL      #2INTH = *BLANKS                                           CER048
     C                   EVAL      #2JTTH = *BLANKS                                           CER048
     C                   EVAL      #2ECTH = *BLANKS                                           CER048
     C**********         EVAL      #2SATH = *BLANKS                                  CER048 BUG23587
     C                   EVAL      #2MPCR = *BLANKS                                           CER048
     C                   EVAL      #2THMD = *BLANKS                                           CER048
     C                   EVAL      P2RaRl = *BLANKS                                           CER048
     C                   EVAL      WWPaRl = *ZEROS                                            CER048
     C                   EVAL      #2TTAM = *BLANKS                                           CER054
     C                   EVAL      #2TTAC = *BLANKS                                           CER054
     C                   EVAL      #2TEDT = *BLANKS                                           CER054
     C                   IF        CGL157 = 'Y'                                               CGL157
     C                   EVAL      #2CRSA = *BLANKS                                           CGL157
     C                   EVAL      #2FRYR = *BLANKS                                           CGL157
     C                   EVAL      #2RPDT = *BLANKS                                           CGL157
     C                   EVAL      #2EFDT = *BLANKS                                           CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrn2v - Validate input in Second screen                    *
      *                                                               *
      *****************************************************************
     C     SRScrn2v      BEGSR
 
     C                   EVAL      #RDCNT = *ZERO                                           BUG26850
     C                   EVAL      #MNACCNT = *BLANKS                                       BUG26850
     C                   EVAL      #SCACCNT = *BLANKS                                       BUG26850
      *                                                                                     BUG26850
     C                   IF        #2CTRR <> *BLANKS                                        BUG26850
      *                                                                                     BUG26850
     C     #2CTRR        SETLL     SDCTTXL2                                                 BUG26850
     C     #2CTRR        READE     SDCTTXL2                                                 BUG26850
      *                                                                                     BUG26850
     C                   DOW       NOT %EOF(SDCTTXL2)                                       BUG26850
      *                                                                                     BUG26850
     C                   IF        %FOUND(SDCTTXL2)                                         BUG26850
     C                   EVAL      #RDCNT = #RDCNT + 1                                      BUG26850
     C                   ENDIF                                                              BUG26850
      *                                                                                     BUG26850
     C     #2CTRR        READE     SDCTTXL2                                                 BUG26850
     C                   ENDDO                                                              BUG26850
      *                                                                                     BUG26850
     C                   IF        #RDCNT > *ZERO                                           BUG26850
     C                   EVAL      #MNACCNT = EWWTAC                                        BUG26850
     C                   EVAL      #SCACCNT = EWSTAC                                        BUG26850
     C                   ENDIF                                                              BUG26850
      *                                                                                     BUG26850
     C                   ELSE                                                               BUG26850
      *                                                                                     BUG26850
     C     #2CTRT        CHAIN     SDCTTXL7                                                 BUG26850
     C                   IF        %FOUND(SDCTTXL7)                                         BUG26850
     C                   EVAL      #MNACCNT = EWWTAC                                        BUG26850
     C                   EVAL      #SCACCNT = EWSTAC                                        BUG26850
     C                   ENDIF                                                              BUG26850
      *                                                                                     BUG26850
     C                   ENDIF                                                              BUG26850
      *                                                                                     BUG26850
      ** Default Tax Status 1 can only be 'T'(Taxable), 'D'(Disclose), or 'E'(Exempt).
 
     C                   IF        #2TXS1 <> 'T' and #2TXS1 <> 'D'
     C                                           and #2TXS1 <> 'E'
     C                                           and #2TXS1 <> 'Y'                          MD033960
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN47 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR4746'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Effective Date 1 should not be blank
 
     C                   IF        #2EDT1 = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN48 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR4749'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Check valid date using the MOVE command
 
     C                   IF        *IN48 = *OFF
     C**********         MOVE      #2EDT1        WDATEN                                     BUG22534
     C**********         MOVE      WDATEN        WDATEA                                     BUG22534
     C                   MOVE      #2EDT1        WDATEA                                     BUG22534
 
      ** Valid date format
      **      Test if date is numeric
 
     C                   Z-ADD     *ZEROS        WVEDT1
     C                   TESTN                   WDATEA               9798
     C                   CALLB     'ZDATE1'
     C                   PARM                    WDATEA
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
 
      **   - invalid format or not numeric
     C                   IF        ErrorFlag = 'Y' or
     C                             (*IN97 = *OFF and *IN98 = *OFF)
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN48 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   IF        *IN97 = *OFF and *IN98 = *OFF
     C**********         EVAL      PZMsgID = 'USR4734'                                      BUG22534
     C                   EVAL      PZMsgID = 'USR4749'                                      BUG22534
     C                   ELSE
     C                   EVAL      PZMsgID = 'USR4736'
     C                   ENDIF
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
     C                   Z-ADD     ZDAYNO        WVEDT1
     C                   ENDIF
 
     C                   ENDIF
 
      ** Transition Type 1 must be either  '1' or '2'
 
     C                   IF        #2TRT1 = ' '
     C                   EVAL      #2TRT1 = '2'
     C                   ENDIF
     C                   IF        #2TRT1 <> '1' and #2TRT1 <> '2'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN49 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR4737'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Default Tax Status 2 can only be 'T'(Taxable) or 'D'(Disclose).
 
     C                   IF        #2TXS2 <> 'T' and #2TXS2 <> 'D'
     C                                           and #2TXS2 <> ' '
     C                                           and #2TXS2 <> 'Y'                          MD033960
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN50 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR4738'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Tax Status should be entered if Effective Date is entered
 
     C                   IF        #2TXS2 = *BLANKS AND #2EDT2 <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN50 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR4735'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Effective Date should be entered if Tax Status is entered
 
     C                   IF        #2EDT2 = *BLANKS AND #2TXS2 <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN50 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR4741'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Effective Date 2 is optional
      ** Check valid date using the MOVE command
 
     C                   Z-ADD     *ZEROS        WVEDT2
     C                   IF        #2EDT2 <> *BLANKS
     C**********         MOVE      #2EDT2        WDATEN                                     BUG22534
     C**********         MOVE      WDATEN        WDATEA                                     BUG22534
     C                   MOVE      #2EDT2        WDATEA                                     BUG22534
 
      ** Valid date format
      **      Test if date is numeric
 
     C                   TESTN                   WDATEA               9798
     C                   CALLB     'ZDATE1'
     C                   PARM                    WDATEA
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
 
      **   - invalid format or not numeric
     C                   IF        ErrorFlag = 'Y' or
     C                             (*IN97 = *OFF and *IN98 = *OFF)
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN51 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   IF        *IN97 = *OFF and *IN98 = *OFF
     C                   EVAL      PZMsgID = 'USR4739'
     C                   ELSE
     C                   EVAL      PZMsgID = 'USR4740'
     C                   ENDIF
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
     C                   Z-ADD     ZDAYNO        WVEDT2
     C                   ENDIF
 
      ** Effective Date 2  must be later than effective date for default tax
      ** status 1.
 
     C                   IF        *IN51 = *OFF and WVEDT2 <= WVEDT1
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN51 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR4742'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** Transition Type 2 must be either  '1' or '2'
 
     C                   IF        #2TRT2 = ' ' AND #2EDT2 <> *BLANKS
     C                             AND #2TXS2 <> *BLANKS
     C                   EVAL      #2TRT2 = '2'
     C                   ENDIF
     C                   IF        #2TRT2 <> '1' and #2TRT2 <> '2'
     C                                           and #2TRT2 <> ' '
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN52 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR4743'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Tax Basket should be input if country of residence is input.
 
     C                   IF        #2TXBS = *BLANKS and #1CTRR <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN53 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR4744'
     C                   EXSR      SRZasnms
     C                   ENDIF
                                                                                            AR795958
      ** '?' for Tax Basket selection screen                                                AR795958
                                                                                            AR795958
     C                   IF        #2TXBS = '?'                                             AR795958
     C                   CALL      'SD000780S'                                              AR795958
     C                   PARM      *BLANKS       PIRTCD                                     AR795958
     C                   PARM      #1CTRT        PICRTT                                     AR795958
     C                   PARM      *BLANKS       PITXBS                                     AR795958
                                                                                            AR795958
     C                   IF        PIRTCD = *BLANKS                                         AR795958
     C                   EVAL      #2TXBS = PITXBS                                          AR795958
     C                   ENDIF                                                              AR795958
     C                   ENDIF                                                              AR795958
 
      ** It should exist from the Tax Basket File.
 
     C                   IF        *IN53 = *OFF and #2TXBS <> *BLANKS
 
     C                   IF        *IN53 = *OFF
     C                   EVAL      WCTRTST = #2TXBS
     C                   CALL      'AOTXBSR0'
     C                   PARM      *BLANKS       PIRTCD
     C                   PARM      '*KEY   '     PIOPTN
     C                   PARM      #1CTRT        PICRTT
     C                   PARM      #2TXBS        PITXBS
     C**********         PARM      WVEDT1        PIDATE                                       232543
     C**********         PARM      *ZEROS        PIDATE                                232543 233082
     C                   PARM      99999         PIDATE                                       233082
     C                   PARM      *BLANKS       PINARR
     C                   PARM      *ZEROS        PIRATE
 
     C                   IF        PIRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN53 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR7697'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Withholding Tax Account Code is optional
 
     C                   IF        #2WTAC <> *BLANKS
 
     C                   IF        *IN54 = *OFF
 
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #2WTAC        PACOD
     C     SDACOD        PARM      SDACOD        DSSDY
 
      ** Record not found
 
     C                   IF        PRTCD = '*NRF   '
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN54 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR0173'
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
      ** Cannot be a title only account code
 
     C                   IF        A5TOIN = 'Y' and *IN54 = *OFF
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN54 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'USR0221'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   EVAL      #2WTAC = A5ACCD
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF                                                              BUG26850
 
      ** Tax Account Code should be the same for all country of residence
 
     C*****#2CTRR        CHAIN     SDCTTXL2                                                   233696
                                                                                              234037
      ***Initialise*EWWTAC*to*blanks*before*read.**********************              234037 BUG26850
                                                                                              234037
     C**********         EVAL      EWWTAC = *BLANKS                                  234037 BUG26850
                                                                                              233696
     C*****#2CTRR        SETLL     SDCTTXL2                                          233696 BUG26850
     C*****#2CTRR        READE     SDCTTXL2                                          233696 BUG26850
                                                                                              233696
     C**********         DOW       EWWTAC = *BLANKS AND                              233696 BUG26850
     C**********                   NOT %EOF(SDCTTXL2)                                233696 BUG26850
     C*****#2CTRR        READE     SDCTTXL2                                          233696 BUG26850
     C**********         ENDDO                                                       233696 BUG26850
 
     C**********         IF        %FOUND(SDCTTXL2)                                           233696
      *                                                                                     BUG26850
     C                   EVAL      #RDERR = *BLANKS                                         BUG26850
      *                                                                                     BUG26850
     C                   IF        #2CTRR <> *BLANKS                                        BUG26850
      *                                                                                     BUG26850
     C                   SELECT                                                             BUG26850
      *                                                                                     BUG26850
     C                   WHEN      #1ACTN = ' '                                             BUG26850
      *                                                                                     BUG26850
     C                   IF        #RDCNT > *ZERO                                           BUG26850
     C                   IF        #MNACCNT <> #2WTAC                                       BUG26850
     C                             AND #MNACCNT <> *BLANKS                                 AR738246A
     C                             AND #2WTAC <> *BLANKS                                   AR738246A
     C                   EVAL      #RDERR = 'DIFFERENT'                                     BUG26850
     C**********         EVAL      #2WTAC = #MNACCNT                              BUG26850 AR738246A
     C                   ENDIF                                                              BUG26850
     C                   ELSE                                                               BUG26850
     C                   IF        #2WTAC <> *BLANKS                                        BUG26850
     C                   EVAL      #ACCNT = #2WTAC                                          BUG26850
     C                   EXSR      SRAccntck                                                BUG26850
     C                   ENDIF                                                              BUG26850
     C                   ENDIF                                                              BUG26850
      *                                                                                     BUG26850
     C                   WHEN      #1ACTN = 'A'                                             BUG26850
      *                                                                                     BUG26850
     C                   SELECT                                                             BUG26850
     C                   WHEN      #RDCNT = 1                                               BUG26850
     C                   IF        #MNACCNT <> #2WTAC                                       BUG26850
     C                             AND #2WTAC <> *BLANKS                                    BUG26850
     C                   EVAL      #ACCNT = #2WTAC                                          BUG26850
     C                   EXSR      SRAccntck                                                BUG26850
     C                   ENDIF                                                              BUG26850
     C                   WHEN      #RDCNT > 1                                               BUG26850
     C                   IF        #MNACCNT <> #2WTAC                                       BUG26850
     C                             AND #MNACCNT <> *BLANKS                                 AR738246A
     C                             AND #2WTAC <> *BLANKS                                   AR738246A
     C                   EVAL      #RDERR = 'DIFFERENT'                                     BUG26850
     C**********         EVAL      #2WTAC = #MNACCNT                              BUG26850 AR738246A
     C                   ENDIF                                                              BUG26850
     C                   ENDSL                                                              BUG26850
      *                                                                                     BUG26850
     C                   ENDSL                                                              BUG26850
      *                                                                                     BUG26850
     C                   ELSE                                                               BUG26850
      *                                                                                     BUG26850
     C                   IF        #2WTAC <> *BLANKS                                        BUG26850
     C                             AND #MNACCNT <> #2WTAC                                   BUG26850
     C                   EVAL      #ACCNT = #2WTAC                                          BUG26850
     C                   EXSR      SRAccntck                                                BUG26850
     C                   ENDIF                                                              BUG26850
      *                                                                                     BUG26850
     C                   ENDIF                                                              BUG26850
      *                                                                                     BUG26850
     C                   IF        #2WTAC = *BLANKS                                         BUG26850
     C                             AND #2TXS1 = 'T'                                         BUG26850
     C                             or #2WTAC = *BLANKS                                      MD033960
     C                             AND #2TXS1 = 'Y'                                         MD033960
     C                   EVAL      #RDERR = 'MANDATORY'                                     BUG26850
     C                   ENDIF                                                              BUG26850
      *                                                                                     BUG26850
     C**********         IF        %FOUND(SDCTTXL2)                                  233696 BUG26850
     C**********         IF        EWWTAC <> #2WTAC                                         BUG26850
     C**********                   AND EWWTAC <> *BLANKS                             233696 BUG26850
      *                                                                                     BUG26850
      ** Error messages                                                                     BUG26850
      *                                                                                     BUG26850
     C                   IF        #RDERR <> *BLANKS                                        BUG26850
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN54 = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C**********         EVAL      PZMsgID = 'USR4791'                                      BUG26850
     C                   SELECT                                                             BUG26850
     C                   WHEN      #RDERR = 'DIFFERENT'                                     BUG26850
     C                   EVAL      PZMsgID = 'USR4816'                                      BUG26850
     C                   WHEN      #RDERR = '  PRIMARY'                                     BUG26850
     C                   EVAL      PZMsgID = 'USR4817'                                      BUG26850
     C                   WHEN      #RDERR = 'SECONDARY'                                     BUG26850
     C                   EVAL      PZMsgID = 'USR4818'                                      BUG26850
     C                   WHEN      #RDERR = 'MANDATORY'                                     BUG26850
     C                   EVAL      PZMsgID = 'USR4819'                                      BUG26850
     C                   ENDSL                                                              BUG26850
     C                   EXSR      SRZasnms
     C                   ENDIF
     C**********         ENDIF                                                              BUG26850
     C**********         ENDIF                                                                233696
 
     C**********         ENDIF                                                              BUG26850
                                                                                              236137
      ** De Minimis Rule Applicable indicator can only be 'Y' (Yes) or 'N' (No).              236137
      ** Default value is 'Y'.                                                                236137
     C                   IF        #2DMAP = *BLANKS                                           236137
     C                   EVAL      #2DMAP = 'Y'                                               236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
     C                   IF        #2DMAP <> 'N' and #2DMAP <> 'Y'                            236137
     C                   EVAL      *IN40 = *ON                                                236137
     C                   EVAL      *IN56 = *ON                                                236137
     C                   EVAL      W#EROR2 = 'Y'                                              236137
     C                   EVAL      PZMsgID = 'USR4901'                                        236137
     C                   EXSR      SRZasnms                                                   236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
      ** If De Minimis Rule Applicable indicator was set to 'N', both Total and               236137
      ** Yearly Discount percentages must be left empty.                                      236137
                                                                                              236137
     C                   Z-ADD     *ZEROS        WWTTDP                                       236137
     C                   Z-ADD     *ZEROS        WWYRDP                                       236137
     C                   IF        #2DMAP = 'N'                                 Begin DMAP    236137
                                                                                              236137
     C                   IF        (#2TTDP <> *BLANKS or #2TTDP <> *BLANKS)                   236137
                                                                                              236137
     C                   EVAL      *IN40 = *ON                                                236137
     C                   EVAL      *IN57 = (#2TTDP <> *BLANKS)                                236137
     C                   EVAL      *IN58 = (#2YRDP <> *BLANKS)                                236137
     C                   EVAL      W#EROR2 = 'Y'                                              236137
     C                   EVAL      PZMsgID = 'USR4902'                                        236137
     C                   EXSR      SRZasnms                                                   236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
      ** If De Minimis Rule Applicable indicator was set to 'Y', both Total and               236137
      ** Yearly Discount percentages must be filled.                                          236137
                                                                                              236137
     C                   ELSE                                                   Else DMAP     236137
                                                                                              236137
     C                   IF        #2TTDP = *BLANKS or #2YRDP = *BLANKS                       236137
                                                                                              236137
     C                   EVAL      *IN40 = *ON                                                236137
     C                   EVAL      *IN57 = (#2TTDP = *BLANKS)                                 236137
     C                   EVAL      *IN58 = (#2YRDP = *BLANKS)                                 236137
     C                   EVAL      W#EROR2 = 'Y'                                              236137
     C                   EVAL      PZMsgID = 'USR4903'                                        236137
     C                   EXSR      SRZasnms                                                   236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
      ** Total Discount Percentage must be valid percentage (6,3),                            236137
      ** between 0 and 100.                                                                   236137
                                                                                              236137
     C                   IF        #2TTDP <> *BLANKS                            Begin TTDP    236137
                                                                                              236137
      ** Align Screen Field.                                                                  236137
                                                                                              236137
     C                   CALLB     'ZALIGN'                                                   236137
     C                   PARM                    ZALIGNOK                                     236137
     C     ZFIELD        PARM      #2TTDP        ZFIELD                                       236137
     C                   PARM      3             ZADEC                                        236137
     C                   PARM      3             ZADIG                                        236137
                                                                                              236137
      ** If Total Discount Percentage is not a valid numeric percentage.                      236137
                                                                                              236137
     C     ZALIGNOK      IFEQ      'N'                                                        236137
                                                                                              236137
     C                   EVAL      *IN40 = *ON                                                236137
     C                   EVAL      *IN57 = *ON                                                236137
     C                   EVAL      W#EROR2 = 'Y'                                              236137
     C                   EVAL      PZMsgID = 'USR4904'                                        236137
     C                   EVAL      PZMsgDta= #2TTDPLabel                                      236137
     C                   EXSR      SRZasnmsd                                                  236137
                                                                                              236137
     C                   ELSE                                                                 236137
                                                                                              236137
      ** Format Screen Field.                                                                 236137
                                                                                              236137
     C                   MOVE      ZFIELD        WWTTDP                                       236137
     C                   CALLB     'ZEDIT'                                                    236137
     C     ZFIELD        PARM                    ZFIELD                                       236137
     C                   PARM      3             ZADEC                                        236137
     C                   MOVE      ZFIELD        #2TTDP                                       236137
                                                                                              236137
      ** If Total Discount Percentage is less than 0 or greater than 100.                     236137
                                                                                              236137
     C     WWTTDP        IFLT      0                                                          236137
     C     WWTTDP        ORGT      100                                                        236137
                                                                                              236137
     C                   EVAL      *IN40 = *ON                                                236137
     C                   EVAL      *IN57 = *ON                                                236137
     C                   EVAL      W#EROR2 = 'Y'                                              236137
     C                   EVAL      PZMsgID = 'USR4905'                                        236137
     C                   EVAL      PZMsgDta= #2TTDPLabel                                      236137
     C                   EXSR      SRZasnmsd                                                  236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
     C                   ENDIF                                                  End TTDP      236137
                                                                                              236137
      ** Yearly Discount Percentage must be valid percentage (6,3),                           236137
      ** between 0 and 100.                                                                   236137
                                                                                              236137
     C                   IF        #2YRDP <> *BLANKS                            Begin YRDP    236137
                                                                                              236137
      ** Align Screen Field.                                                                  236137
                                                                                              236137
     C                   CALLB     'ZALIGN'                                                   236137
     C                   PARM                    ZALIGNOK                                     236137
     C     ZFIELD        PARM      #2YRDP        ZFIELD                                       236137
     C                   PARM      3             ZADEC                                        236137
     C                   PARM      3             ZADIG                                        236137
                                                                                              236137
      ** If Yearly Discount Percentage is not a valid numeric percentage.                     236137
                                                                                              236137
     C     ZALIGNOK      IFEQ      'N'                                                        236137
                                                                                              236137
     C                   EVAL      *IN40 = *ON                                                236137
     C                   EVAL      *IN58 = *ON                                                236137
     C                   EVAL      W#EROR2 = 'Y'                                              236137
     C                   EVAL      PZMsgID = 'USR4904'                                        236137
     C                   EVAL      PZMsgDta= #2YRDPLabel                                      236137
     C                   EXSR      SRZasnmsd                                                  236137
                                                                                              236137
     C                   ELSE                                                                 236137
                                                                                              236137
      ** Format Screen Field.                                                                 236137
                                                                                              236137
     C                   MOVE      ZFIELD        WWYRDP                                       236137
     C                   CALLB     'ZEDIT'                                                    236137
     C     ZFIELD        PARM                    ZFIELD                                       236137
     C                   PARM      3             ZADEC                                        236137
     C                   MOVE      ZFIELD        #2YRDP                                       236137
                                                                                              236137
      ** If Yearly Discount Percentage is less than 0 or greater than 100.                    236137
                                                                                              236137
     C     WWYRDP        IFLT      0                                                          236137
     C     WWYRDP        ORGT      100                                                        236137
                                                                                              236137
     C                   EVAL      *IN40 = *ON                                                236137
     C                   EVAL      *IN58 = *ON                                                236137
     C                   EVAL      W#EROR2 = 'Y'                                              236137
     C                   EVAL      PZMsgID = 'USR4905'                                        236137
     C                   EVAL      PZMsgDta= #2YRDPLabel                                      236137
     C                   EXSR      SRZasnmsd                                                  236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
     C                   ENDIF                                                  End YRDP      236137
                                                                                              236137
     C                   ENDIF                                                  End DMAP      236137
                                                                                              236137
      ** Tax Calculation Basis must be 'S' (Staight line) or 'A' (Analytical).                236137
      ** Default value is 'S'.                                                                236137
     C                   IF        #2TXCB = *BLANKS                                           236137
     C                   EVAL      #2TXCB = 'S'                                               236137
     C                   ENDIF                                                                236137
     C                   IF        #2TXCB <> 'S' and #2TXCB <> 'A'                            236137
     C                   EVAL      *IN40 = *ON                                                236137
     C                   EVAL      *IN59 = *ON                                                236137
     C                   EVAL      W#EROR2 = 'Y'                                              236137
     C                   EVAL      PZMsgID = 'USR4906'                                        236137
     C                   EXSR      SRZasnms                                                   236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
      ** Premium Amortized to be Deducted indicator can only be 'Y' (Yes) or 'N' (No).        236137
      ** Default value is 'Y'.                                                                236137
     C                   IF        #2PADD = *BLANKS                                           236137
     C                   EVAL      #2PADD = 'Y'                                               236137
     C                   ENDIF                                                                236137
     C                   IF        #2PADD <> 'N' and #2PADD <> 'Y'                            236137
     C                   EVAL      *IN40 = *ON                                                236137
     C                   EVAL      *IN64 = *ON                                                236137
     C                   EVAL      W#EROR2 = 'Y'                                              236137
     C                   EVAL      PZMsgID = 'USR4907'                                        236137
     C                   EXSR      SRZasnms                                                   236137
                                                                                              236137
     C                   ENDIF                                                                236137
                                                                                              236137
      ** Delta of TIS Taxable Only indicator can only be 'Y' (Yes) or 'N' (No).               236137
      ** Default value is 'N'.                                                                236137
     C                   IF        #2TIST = *BLANKS                                           236137
     C                   EVAL      #2TIST = 'N'                                               236137
     C                   ENDIF                                                                236137
     C                   IF        #2TIST <> 'N' and #2TIST <> 'Y'                            236137
     C                   EVAL      *IN40 = *ON                                                236137
     C**********         EVAL      *IN65 = *ON                                         236137 CGL157
     C                   EVAL      *IN68 = *ON                                                CGL157
     C                   EVAL      W#EROR2 = 'Y'                                              236137
     C                   EVAL      PZMsgID = 'USR4908'                                        236137
     C                   EXSR      SRZasnms                                                   236137
                                                                                              236137
     C                   ENDIF                                                                236137
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
      ** Validation for Secondary Tax Basket                                                  CER048
      *                                                                                       CER048
     C                   IF        #2STXB <> *BLANKS                                          CER048
     C                   IF        #2CTRR = *BLANKS                                           CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN14 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8217'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
      *                                                                                       CER048
     C                   ELSEIF    #2CTRT <> *BLANKS                                          CER048
      *                                                                                       CER048
      ** '?' for Tax Basket selection screen                                                AR795958
                                                                                            AR795958
     C                   IF        #2STXB = '?'                                             AR795958
     C                   CALL      'SD000780S'                                              AR795958
     C                   PARM      *BLANKS       PIRTCD                                     AR795958
     C                   PARM      #2CTRT        PICRTT                                     AR795958
     C                   PARM      *BLANKS       PITXBS                                     AR795958
                                                                                            AR795958
     C                   IF        PIRTCD = *BLANKS                                         AR795958
     C                   EVAL      #2STXB = PITXBS                                          AR795958
     C                   ENDIF                                                              AR795958
     C                   ENDIF                                                              AR795958
                                                                                            AR795958
     C                   CALLB     'AOTXBSR0'                                                 CER048
     C                   PARM      *BLANKS       PRTCD                                        CER048
     C                   PARM      '*KEY   '     POPTN                                        CER048
     C                   PARM      #2CTRT        PCrtx                                        CER048
     C                   PARM      #2STXB        PTxbs                                        CER048
     C                   PARM      99999         PPsvd                                        CER048
     C                   PARM      *BLANKS       PNarr                                        CER048
     C                   PARM      *ZEROS        PTxrt                                        CER048
      *                                                                                       CER048
     C                   IF        PRTCD = '*NRF'                                             CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN14 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8216'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
     C                   ENDIF                                                                CER048
     C                   ENDIF                                                                CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C**********         IF        #2STXB <> *BLANKS AND                             CER048 AR738246
     C**********                   #2SEDT = *BLANKS                                  CER048 AR738246
     C**********         EVAL      *IN40 = *ON                                       CER048 AR738246
     C**********         EVAL      *IN14 = *ON                                       CER048 AR738246
     C**********         EVAL      W#EROR2 = 'Y'                                     CER048 AR738246
     C**********         EVAL      PZMsgID = 'USR8280'                               CER048 AR738246
     C**********         EXSR      SRZasnms                                          CER048 AR738246
     C**********         ENDIF                                                       CER048 AR738246
      *                                                                                     AR738246
      ** All Secondary fields must be filled up or All must be blanks whether               AR738246
      **    Resident or Non-resident                                                        AR738246
      *                                                                                     AR738246
     C                   IF        (#2STXB <> *BLANKS AND #2SEDT = *BLANKS AND              AR738246
     C                             #2STAC = *BLANKS) OR                                     AR738246
     C                             (#2STXB <> *BLANKS AND #2SEDT <> *BLANKS AND             AR738246
     C                             #2STAC = *BLANKS) OR                                     AR738246
     C                             (#2STXB <> *BLANKS AND #2SEDT =  *BLANKS AND             AR738246
     C                             #2STAC <> *BLANKS) OR                                    AR738246
     C                             (#2STXB = *BLANKS AND #2SEDT <> *BLANKS AND              AR738246
     C                             #2STAC = *BLANKS) OR                                     AR738246
     C                             (#2STXB = *BLANKS AND #2SEDT = *BLANKS AND               AR738246
     C                             #2STAC <> *BLANKS) OR                                    AR738246
     C                             (#2STXB = *BLANKS AND #2SEDT <> *BLANKS AND              AR738246
     C                             #2STAC <> *BLANKS)                                       AR738246
     C                                                                                      AR738246
     C                   EVAL      *IN40 = *ON                                              AR738246
     C                   EVAL      *IN14 = *ON                                              AR738246
     C                   EVAL      *IN15 = *ON                                              AR738246
     C                   EVAL      *IN16 = *ON                                              AR738246
     C                   EVAL      W#EROR2 = 'Y'                                            AR738246
     C                   EVAL      PZMsgID = 'USR4997'                                      AR738246
     C                   EXSR      SRZasnms                                                 AR738246
     C                   ENDIF                                                              AR738246
      *                                                                                       CER048
      ** Validation for Secondary Tax Account Code                                            CER048
      *                                                                                       CER048
     C                   IF        #2CTRR <> *BLANKS AND                                      CER048
     C                             #2STAC <> *BLANKS                                          CER048
      *                                                                                       CER048
     C                   CALLB     'AOACODR0'                                                 CER048
     C                   PARM      *BLANKS       PRTCD                                        CER048
     C                   PARM      '*KEY    '    POPTN                                        CER048
     C     #2STAC        PARM      #2STAC        PAcCd                                        CER048
     C     SDACOD        PARM      SDACOD        DSSDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRTCD <> *BLANKS                                           CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN15 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8218'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
      *                                                                                       CER048
     C                   ELSEIF    A5ACTY <>'G' OR A5TOIN <> 'N'                              CER048
      *                                                                                       CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN15 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8219'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ELSEIF    #2CTRR = *BLANKS AND                                       CER048
     C                             #2STAC <> *BLANKS                                          CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN15 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8220'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                     BUG26850
     C                   EVAL      #RDERR = *BLANKS                                         BUG26850
      *                                                                                     BUG26850
     C                   IF        #2CTRR <> *BLANKS                                        BUG26850
      *                                                                                     BUG26850
     C                   SELECT                                                             BUG26850
      *                                                                                     BUG26850
     C                   WHEN      #1ACTN = ' '                                             BUG26850
      *                                                                                     BUG26850
     C                   IF        #RDCNT > *ZERO                                           BUG26850
     C                   IF        #SCACCNT <> #2STAC                                       BUG26850
     C                   EVAL      #RDERR = 'DIFFERENT'                                     BUG26850
     C                   EVAL      #2STAC = #SCACCNT                                        BUG26850
     C                   ENDIF                                                              BUG26850
     C                   ELSE                                                               BUG26850
     C                   IF        #2STAC <> *BLANKS                                        BUG26850
     C                   EVAL      #ACCNT = #2STAC                                          BUG26850
     C                   EXSR      SRAccntck                                                BUG26850
     C                   ENDIF                                                              BUG26850
     C                   ENDIF                                                              BUG26850
      *                                                                                     BUG26850
     C                   WHEN      #1ACTN = 'A'                                             BUG26850
      *                                                                                     BUG26850
     C                   SELECT                                                             BUG26850
     C                   WHEN      #RDCNT = 1                                               BUG26850
     C                   IF        #SCACCNT <> #2STAC                                       BUG26850
     C                             AND #2STAC <> *BLANKS                                    BUG26850
     C                   EVAL      #ACCNT = #2STAC                                          BUG26850
     C                   EXSR      SRAccntck                                                BUG26850
     C                   ENDIF                                                              BUG26850
     C                   WHEN      #RDCNT > 1                                               BUG26850
     C                   IF        #SCACCNT <> #2STAC                                       BUG26850
     C                             AND #SCACCNT <> *BLANKS                                  AR738246
     C                             AND #2STAC <> *BLANKS                                    AR738246
     C                   EVAL      #RDERR = 'DIFFERENT'                                     BUG26850
     C**********         EVAL      #2STAC = #SCACCNT                               BUG26850 AR738246
     C                   ENDIF                                                              BUG26850
     C                   ENDSL                                                              BUG26850
      *                                                                                     BUG26850
     C                   ENDSL                                                              BUG26850
      *                                                                                     BUG26850
     C                   ELSE                                                               BUG26850
      *                                                                                     BUG26850
     C                   IF        #2STAC <> *BLANKS                                        BUG26850
     C                             AND #SCACCNT <> #2STAC                                   BUG26850
     C                   EVAL      #ACCNT = #2STAC                                          BUG26850
     C                   EXSR      SRAccntck                                                BUG26850
     C                   ENDIF                                                              BUG26850
      *                                                                                     BUG26850
     C                   ENDIF                                                              BUG26850
      *                                                                                     BUG26850
     C**********         IF        #2STAC = *BLANKS                                BUG26850 AR738246
     C**********                   AND #2TXS1 = 'T'                                BUG26850 AR738246
     C**********                   AND #2CTRR <> *BLANKS                           BUG26850 AR738246
     C**********         EVAL      #RDERR = 'MANDATORY'                            BUG26850 AR738246
     C**********         ENDIF                                                     BUG26850 AR738246
      *                                                                                     BUG26850
      ** Error Messages                                                                     BUG26850
      *                                                                                     BUG26850
     C                   IF        #RDERR <> *BLANKS                                        BUG26850
     C                   EVAL      *IN40 = *ON                                              BUG26850
     C                   EVAL      *IN15 = *ON                                              BUG26850
     C                   EVAL      W#EROR2 = 'Y'                                            BUG26850
     C                   SELECT                                                             BUG26850
     C                   WHEN      #RDERR = 'DIFFERENT'                                     BUG26850
     C                   EVAL      PZMsgID = 'USR4820'                                      BUG26850
     C                   WHEN      #RDERR = '  PRIMARY'                                     BUG26850
     C                   EVAL      PZMsgID = 'USR4821'                                      BUG26850
     C                   WHEN      #RDERR = 'SECONDARY'                                     BUG26850
     C                   EVAL      PZMsgID = 'USR4822'                                      BUG26850
     C**********         WHEN      #RDERR = 'MANDATORY'                            BUG26850 AR738246
     C**********         EVAL      PZMsgID = 'USR4823'                             BUG26850 AR738246
     C                   ENDSL                                                              BUG26850
     C                   EXSR      SRZasnms                                                 BUG26850
     C                   ENDIF                                                              BUG26850
      *                                                                                     BUG26850
      *                                                                                       CER048
      ** Retail Account AVg. Rate Limit                                                       CER048
      *                                                                                       CER048
     C                   Z-ADD     *ZEROS        WWRaRl                                       CER048
     C                   IF        #2RARL <> *BLANKS                                          CER048
      *                                                                                     BUG22517
     C                   IF        #2CTRR = *BLANKS                                         BUG22517
     C                   EVAL      *IN40 = *ON                                              BUG22517
     C                   EVAL      *IN23 = *ON                                              BUG22517
     C                   EVAL      W#EROR2 = 'Y'                                            BUG22517
     C                   EVAL      PZMsgID = 'USR8304'                                      BUG22517
     C                   EXSR      SRZasnms                                                 BUG22517
      *                                                                                     BUG22517
     C                   ELSE                                                               BUG22517
      *                                                                                       CER048
      ** Align Screen Field.                                                                  CER048
      *                                                                                       CER048
     C                   CALLB     'ZALIGN'                                                   CER048
     C                   PARM                    ZALIGNOK                                     CER048
     C     ZFIELD        PARM      #2RARL        ZFIELD                                       CER048
     C                   PARM      5             ZADEC                                        CER048
     C                   PARM      2             ZADIG                                        CER048
      *                                                                                       CER048
      ** If Retail Accounts Avg. Rate Limit is not a valid numeric field.                     CER048
      *                                                                                       CER048
     C     ZALIGNOK      IFEQ      'N'                                                        CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN23 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8245'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
      ** Format Screen Field.                                                                 CER048
      *                                                                                       CER048
     C                   MOVE      ZFIELD        WWRaRl                                       CER048
     C                   CALLB     'ZEDIT'                                                    CER048
     C     ZFIELD        PARM                    ZFIELD                                       CER048
     C                   PARM      5             ZADEC                                        CER048
     C                   MOVE      ZFIELD        #2RARL                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                     BUG22517
     C                   ENDIF                                                              BUG22517
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Previous retail accounts rate limlt                                                  CER048
      *                                                                                       CER048
     C                   IF        #2RARL <> P2RaRl                                           CER048
     C                   EVAL      #2PARL = P2RaRl                                            CER048
     C                   CALLB     'ZALIGN'                                                   CER048
     C                   PARM                    ZALIGNOK                                     CER048
     C     ZFIELD        PARM      #2PARL        ZFIELD                                       CER048
     C                   PARM      5             ZADEC                                        CER048
     C                   PARM      2             ZADIG                                        CER048
     C                   MOVE      ZFIELD        WWPaRl                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Validation for Secondary effecttive date                                             CER048
      *                                                                                       CER048
     C                   Z-ADD     *ZEROS        WVSeDt                                       CER048
     C                   IF        #2SEDT <> *BLANKS                                          CER048
      *                                                                                       CER048
     C                   IF        #2STXB = *BLANKS                                           CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN16 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8279'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
      *                                                                                       CER048
     C                   ELSEIF    #2STXB <> *BLANKS                                          CER048
     C**********         MOVE      #2SEDT        WDATEN                              CER048 BUG22534
     C**********         MOVE      WDATEN        WDATEA                              CER048 BUG22534
     C                   MOVE      #2SEDT        WDATEA                                     BUG22534
      *                                                                                       CER048
      ** Valid date formate                                                                   CER048
      *                                                                                       CER048
     C                   EVAL      WVSeDt = *ZEROS                                            CER048
     C                   TESTN                   WDATEA               9798                    CER048
     C                   CALLB     'ZDATE1'                                                   CER048
     C                   PARM                    WDATEA                                       CER048
     C                   PARM                    ZDAYNO                                       CER048
     C                   PARM                    BJDFIN                                       CER048
     C                   PARM                    ErrorFlag                                    CER048
      *                                                                                       CER048
      ** Invalid formate                                                                      CER048
      *                                                                                       CER048
     C                   IF        ErrorFlag = 'Y' OR                                         CER048
     C                             (*IN97 = *OFF AND *IN98 = *OFF)                            CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN16 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
      *                                                                                       CER048
     C                   IF        *IN97 = *OFF AND *IN98 = *OFF                              CER048
     C**********         EVAL      PZMsgID = 'USR8234'                               CER048 BUG22534
     C                   EVAL      PZMsgID = 'USR8299'                                      BUG22534
     C                   ELSE                                                                 CER048
     C**********         EVAL      PZMsgID = 'USR4736'                               CER048 BUG22534
     C                   EVAL      PZMsgID = 'USR8300'                                      BUG22534
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   EXSR      SRZasnms                                                   CER048
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
     C                   Z-ADD     ZDAYNO        WVSeDt                                       CER048
      *                                                                                       CER048
     C**********         ENDIF                                                       CER048 BUG22534
      *                                                                                     BUG23659
      ** Check if the Secondary Effect. Date Field was Amended                              BUG23659
      *                                                                                     BUG23659
     C                   IF        WEWSEDT <> ZDAYNO                                        BUG23659
      *                                                                                       CER048
      ** Data must be equal to or greater than system run date                                CER048
      *                                                                                       CER048
     C                   IF        ZDAYNO  < BJRDNB                                           CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN16 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8277'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
     C                   ENDIF                                                                CER048
      *                                                                                     BUG23659
     C                   ENDIF                                                              BUG23659
      *                                                                                     BUG22534
     C                   ENDIF                                                              BUG22534
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Validation for Retail Accounts average rate effective date                           CER048
      *                                                                                       CER048
     C                   Z-ADD     *ZEROS        WVRaEd                                       CER048
     C                   IF        #2RARL <> *BLANKS AND                                      CER048
     C                             WWRaRl <> *ZEROS AND                                       CER048
     C                             #2RAED <> *BLANKS                                          CER048
     C**********         MOVE      #2RAED        WDATEN                              CER048 BUG22534
     C**********         MOVE      WDATEN        WDATEA                              CER048 BUG22534
     C                   MOVE      #2RAED        WDATEA                                     BUG22534
      *                                                                                       CER048
      ** Valid date formate                                                                   CER048
      *                                                                                       CER048
     C                   EVAL      WVRaEd = *ZEROS                                            CER048
     C                   TESTN                   WDATEA               9798                    CER048
     C                   CALLB     'ZDATE1'                                                   CER048
     C                   PARM                    WDATEA                                       CER048
     C                   PARM                    ZDAYNO                                       CER048
     C                   PARM                    BJDFIN                                       CER048
     C                   PARM                    ErrorFlag                                    CER048
      *                                                                                       CER048
      ** Invalid formate                                                                      CER048
      *                                                                                       CER048
     C                   IF        ErrorFlag = 'Y' OR                                         CER048
     C                             (*IN97 = *OFF AND *IN98 = *OFF)                            CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN18 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
      *                                                                                       CER048
     C                   IF        *IN97 = *OFF AND *IN98 = *OFF                              CER048
     C**********         EVAL      PZMsgID = 'USR4734'                               CER048 BUG22534
     C                   EVAL      PZMsgID = 'USR8301'                                      BUG22534
     C                   ELSE                                                                 CER048
     C**********         EVAL      PZMsgID = 'USR4736'                               CER048 BUG22534
     C                   EVAL      PZMsgID = 'USR8302'                                      BUG22534
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   EXSR      SRZasnms                                                   CER048
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
     C                   Z-ADD     ZDAYNO        WVRaEd                                       CER048
      *                                                                                       CER048
     C**********         ENDIF                                                       CER048 BUG22534
      *                                                                                       CER048
      ** Data must be equal to or greater than system run date                                CER048
      *                                                                                       CER048
     C                   IF        ZDAYNO  < BJRDNB                                           CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN18 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8221'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
     C                   ENDIF                                                                CER048
      *                                                                                     BUG22534
     C                   ENDIF                                                              BUG22534
      *                                                                                       CER048
     C                   ELSEIF    (#2RARL = *BLANKS OR                                       CER048
     C                             WWRaRl = *ZEROS ) AND                                      CER048
     C                             #2RAED <> *BLANKS                                          CER048
      *                                                                                       CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN18 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8222'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                     BUG22517
     C                   EVAL      ThMtd#Err = *OFF                                        BUG22517A
      ** Threshold method                                                                   BUG22517
      *  moved from last portion of threshold validation                                    BUG22517
     C                   IF        #2THMD <>'Y' AND #2THMD  <>'N'                           BUG22517
     C                   Eval      ThMtd#Err = *ON                                         BUG22517A
     C                   EVAL      *IN40 = *ON                                              BUG22517
     C                   EVAL      *IN24 = *ON                                              BUG22517
     C                   EVAL      W#EROR2 = 'Y'                                            BUG22517
     C                   EVAL      PZMsgID = 'USR8232'                                      BUG22517
     C                   EXSR      SRZasnms                                                 BUG22517
      * Additional validation for Threshold Method                                          BUG22517
     C                   ELSE                                                               BUG22517
     C                   IF        #2THMD = 'Y' AND                                         BUG22517
     C                             #2CTRR = *BLANKS                                         BUG22517
     C                   Eval      ThMtd#Err = *ON                                         BUG22517A
     C                   EVAL      *IN40 = *ON                                              BUG22517
     C                   EVAL      *IN24 = *ON                                              BUG22517
     C                   EVAL      W#EROR2 = 'Y'                                            BUG22517
     C                   EVAL      PZMsgID = 'USR8303'                                      BUG22517
     C                   EXSR      SRZasnms                                                 BUG22517
     C                   ENDIF                                                              BUG22517
     C                   ENDIF                                                              BUG22517
      *                                                                                       CER048
      ** Individual Threshold                                                                 CER048
      *                                                                                       CER048
     C                   IF        #2THMD = 'Y'                                               CER048
     C                             AND ThMtd#Err = *OFF                                    BUG22517A
     C                   IF        #2INTH = *BLANKS                                           CER048
      *                                                                                       CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN17 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8223'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   EVALR     WInTh = %TRIMR(#2INTH)                                     CER048
     C                   TESTN                   WInTh                9596                    CER048
      *                                                                                       CER048
     C                   IF        *IN95 = '0' AND                                            CER048
     C                             *IN96 = '0'                                                CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN17 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8224'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ELSEIF    #2INTH <> *BLANKS AND                                      CER048
     C                             #2INTH <> *ZEROS AND                                       CER048
     C                             #2THMD = 'N'                                               CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN17 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8233'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Joint Threshold                                                                      CER048
      *                                                                                       CER048
     C                   IF        #2THMD = 'Y'                                               CER048
     C                             AND ThMtd#Err = *OFF                                    BUG22517A
     C                   IF        #2JTTH = *BLANKS                                           CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN19 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8225'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   EVALR     WJtTh = %TRIM(#2JTTH)                                      CER048
     C                   TESTN                   WJtTh                9596                    CER048
      *                                                                                       CER048
     C                   IF        *IN95 = '0' AND                                            CER048
     C                             *IN96 = '0'                                                CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN19 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8226'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ELSEIF    #2JTTH <> *BLANKS AND                                      CER048
     C                             #2JTTH <> *ZEROS AND                                       CER048
     C                             #2THMD = 'N'                                               CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN19 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8234'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Exemption Certificate Threshold                                                      CER048
      *                                                                                       CER048
     C                   IF        #2THMD = 'Y'                                               CER048
     C                             AND ThMtd#Err = *OFF                                    BUG22517A
     C                   IF        #2ECTH = *BLANKS                                           CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN21 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8227'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   EVALR     WEcTh = %TRIM(#2ECTH)                                      CER048
     C                   TESTN                   WEcTh                9596                    CER048
      *                                                                                       CER048
     C                   IF        *IN95 = '0' AND                                            CER048
     C                             *IN96 = '0'                                                CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN21 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8228'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ELSEIF    #2ECTH <> *BLANKS AND                                      CER048
     C                             #2ECTH <> *ZEROS AND                                       CER048
     C                             #2THMD = 'N'                                               CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN21 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8235'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
     C                   ENDIF                                                                CER048
      **********                                                                     CER048 BUG23587
      ***Saving*Account*Threshold                                                    CER048 BUG23587
      **********                                                                     CER048 BUG23587
     C**********         Z-ADD     *ZEROS        WWSaTh                              CER048 BUG23587
     C**********         IF        #2THMD = 'Y'                                      CER048 BUG23587
     C**********                   AND ThMtd#Err = *OFF                           BUG22517A BUG23587
     C**********         IF        #2SATH = *BLANKS                                  CER048 BUG23587
     C**********         EVAL      *IN40 = *ON                                       CER048 BUG23587
     C**********         EVAL      *IN22 = *ON                                       CER048 BUG23587
     C**********         EVAL      W#EROR2 = 'Y'                                     CER048 BUG23587
     C**********         EVAL      PZMsgID = 'USR8229'                               CER048 BUG23587
     C**********         EXSR      SRZasnms                                          CER048 BUG23587
     C**********         ELSE                                                        CER048 BUG23587
      **********                                                                     CER048 BUG23587
      ** Align Screen Field.                                                         CER048 BUG23587
      **********                                                                     CER048 BUG23587
     C**********         CALLB     'ZALIGN'                                          CER048 BUG23587
     C**********         PARM                    ZALIGNOK                            CER048 BUG23587
     C*****ZFIELD        PARM      #2SATH        ZFIELD                              CER048 BUG23587
     C**********         PARM      2             ZADEC                               CER048 BUG23587
     C**********         PARM      3             ZADIG                               CER048 BUG23587
      **********                                                                     CER048 BUG23587
      ***If*Saving*Account*Threshold*is*not*a*valid*numeric*field.                   CER048 BUG23587
      **********                                                                     CER048 BUG23587
     C*****ZALIGNOK      IFEQ      'N'                                               CER048 BUG23587
     C**********         EVAL      *IN40 = *ON                                       CER048 BUG23587
     C**********         EVAL      *IN22 = *ON                                       CER048 BUG23587
     C**********         EVAL      W#EROR2 = 'Y'                                     CER048 BUG23587
     C**********         EVAL      PZMsgID = 'USR8230'                               CER048 BUG23587
     C**********         EXSR      SRZasnms                                          CER048 BUG23587
     C**********         ELSE                                                        CER048 BUG23587
      **********                                                                     CER048 BUG23587
      ** Format Screen Field.                                                        CER048 BUG23587
      **********                                                                     CER048 BUG23587
     C**********         MOVE      ZFIELD        WWSaTh                              CER048 BUG23587
     C**********         CALLB     'ZEDIT'                                           CER048 BUG23587
     C*****ZFIELD        PARM                    ZFIELD                              CER048 BUG23587
     C**********         PARM      2             ZADEC                               CER048 BUG23587
     C**********         MOVE      ZFIELD        #2SATH                              CER048 BUG23587
     C**********         ENDIF                                                       CER048 BUG23587
     C**********         ENDIF                                                       CER048 BUG23587
      **********                                                                     CER048 BUG23587
     C**********         ELSEIF    #2SATH <> *BLANKS AND                             CER048 BUG23587
     C**********                   #2SATH <> '  0.00' AND                            CER048 BUG23587
     C**********                   #2THMD = 'N'                                      CER048 BUG23587
     C**********         EVAL      *IN40 = *ON                                       CER048 BUG23587
     C**********         EVAL      *IN22 = *ON                                       CER048 BUG23587
     C**********         EVAL      W#EROR2 = 'Y'                                     CER048 BUG23587
     C**********         EVAL      PZMsgID = 'USR8236'                               CER048 BUG23587
     C**********         EXSR      SRZasnms                                          CER048 BUG23587
     C**********         ENDIF                                                       CER048 BUG23587
      *                                                                                       CER048
      ** Margin point for Conversion rate                                                     CER048
      *                                                                                       CER048
     C                   IF        #2THMD = 'Y'                                               CER048
     C                             AND ThMtd#Err = *OFF                                    BUG22517A
     C                   IF        #2MPCR <>'Y' AND #2MPCR <>'N'                              CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN20 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C                   EVAL      PZMsgID = 'USR8231'                                        CER048
     C                   EXSR      SRZasnms                                                   CER048
     C                   ENDIF                                                                CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C**********         IF        #2THMD = 'N' AND                                           CER048
     C                   IF        #2CTRR = *BLANKS AND                                     BUG22517
     C                             #2MPCR <> *BLANKS                                          CER048
     C                   EVAL      *IN40 = *ON                                                CER048
     C                   EVAL      *IN20 = *ON                                                CER048
     C                   EVAL      W#EROR2 = 'Y'                                              CER048
     C**********         EVAL      PZMsgID = 'USR8273'                               CER048 BUG22517
     C                   EVAL      PZMsgID = 'USR8305'                                      BUG22517
     C                   EXSR      SRZasnms                                                   CER048
     C                   ENDIF                                                                CER048
      **********                                                                     CER048 BUG22517
      ***Threshold method                                                            CER048 BUG22517
      **********                                                                     CER048 BUG22517
     C**********         IF        #2THMD <>'Y' AND #2THMD  <>'N'                    CER048 BUG22517
     C**********         EVAL      *IN40 = *ON                                       CER048 BUG22517
     C**********         EVAL      *IN24 = *ON                                       CER048 BUG22517
     C**********         EVAL      W#EROR2 = 'Y'                                     CER048 BUG22517
     C**********         EVAL      PZMsgID = 'USR8232'                               CER048 BUG22517
     C**********         EXSR      SRZasnms                                          CER048 BUG22517
     C**********         ENDIF                                                       CER048 BUG22517
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
      *                                                                                       CER054
      ** Does Third Tax Affect Main Tax                                                       CER054
      *                                                                                       CER054
     C                   IF        #2TTAM <> 'Y'                                              CER054
     C                             AND #2TTAM <> 'N'                                          CER054
     C                   EVAL      *IN90 = *ON                                                CER054
     C                   EVAL      W#EROR2 = 'Y'                                              CER054
     C                   EVAL      PZMsgID = 'USR9913'                                        CER054
     C                   EXSR      SRZasnms                                                   CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
      ** Third Tax Account Code                                                               CER054
      *                                                                                       CER054
     C                   IF        (#2TTAC <> *BLANKS AND #2TEDT = *BLANKS) OR             AR738246A
     C                             (#2TTAC = *BLANKS AND #2TEDT <> *BLANKS)                AR738246A
     C                   EVAL      *IN91 = *ON                                             AR738246A
     C                   EVAL      *IN92 = *ON                                             AR738246A
     C                   EVAL      W#EROR2 = 'Y'                                           AR738246A
     C                   EVAL      PZMsgID = 'USR4998'                                     AR738246A
     C                   EXSR      SRZasnms                                                AR738246A
     C                   ENDIF                                                             AR738246A
      *                                                                                       CER054
     C                   IF        #2TTAC <> *BLANKS                                          CER054
     C                             AND #2CTRR <> *BLANKS                                      CER054
     C                   CALL      'AOACODR0'                                                 CER054
     C                   PARM      *BLANKS       PRTCD                                        CER054
     C                   PARM      '*KEY   '     POPTN                                        CER054
     C                   PARM      #2TTAC        PACOD                                        CER054
     C     SDACOD        PARM      SDACOD        DSSDY                                        CER054
                                                                                            AR808125
     C                   IF        PRTCD = *BLANKS                                          AR808125
     C                   EVAL      #2TTAC = PACOD                                           AR808125
     C                   ENDIF                                                              AR808125
      *                                                                                       CER054
      ** Database error                                                                       CER054
      *                                                                                       CER054
     C                   IF        PRTCD <> *BLANKS                                           CER054
     C                   EVAL      *IN91 = *ON                                                CER054
     C                   EVAL      W#EROR2 = 'Y'                                              CER054
     C                   EVAL      PZMsgID = 'USR9914'                                        CER054
     C                   EXSR      SRZasnms                                                   CER054
      *                                                                                       CER054
     C                   ELSEIF    A5ACTY <> 'G'                                              CER054
     C                   EVAL      *IN91 = *ON                                                CER054
     C                   EVAL      W#EROR2 = 'Y'                                              CER054
     C                   EVAL      PZMsgID = 'USR9915'                                        CER054
     C                   EXSR      SRZasnms                                                   CER054
      *                                                                                       CER054
     C                   ELSEIF    A5TOIN = 'Y'                                               CER054
     C                   EVAL      *IN91 = *ON                                                CER054
     C                   EVAL      W#EROR2 = 'Y'                                              CER054
     C                   EVAL      PZMsgID = 'USR9916'                                        CER054
     C                   EXSR      SRZasnms                                                   CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ELSE                                                                 CER054
      *                                                                                       CER054
     C                   IF        #2TTAC <> *BLANKS                                          CER054
     C                             AND #2CTRR = *BLANKS                                       CER054
     C                   EVAL      *IN91 = *ON                                                CER054
     C                   EVAL      W#EROR2 = 'Y'                                              CER054
     C                   EVAL      PZMsgID = 'USR9914'                                        CER054
     C                   EXSR      SRZasnms                                                   CER054
     C                   ENDIF                                                                CER054
      **********                                                                  BUG26436 AR738246A
     C**********         IF        #2TTAC = *BLANKS                               BUG26436 AR738246A
     C**********                   AND #2CTRR <> *BLANKS                          BUG26436 AR738246A
     C**********         EVAL      *IN91 = *ON                                    BUG26436 AR738246A
     C**********         EVAL      W#EROR2 = 'Y'                                  BUG26436 AR738246A
     C**********         EVAL      PZMsgID = 'USR9925'                            BUG26436 AR738246A
     C**********         EXSR      SRZasnms                                       BUG26436 AR738246A
     C**********         ENDIF                                                    BUG26436 AR738246A
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
      ** Third Tax Effective Date                                                             CER054
      *                                                                                       CER054
     C                   EVAL      WVTEDT = *ZEROS                                            CER054
     C                   IF        #2TEDT <> *BLANKS                                          CER054
     C                   EVAL      WDATEA = #2TEDT                                            CER054
     C                   TESTN                   WDATEA               9394                    CER054
     C                   CALLB     'ZDATE1'                                                   CER054
     C                   PARM      #2TEDT        ZDATEI            6                          CER054
     C                   PARM      *ZERO         ZDAYNO            5 0                        CER054
     C                   PARM                    BJDFIN                                       CER054
     C                   PARM                    ERRORFLAG         1                          CER054
      *                                                                                       CER054
     C                   IF        ERRORFLAG = 'Y'                                            CER054
     C                             OR (*IN93 = *OFF AND *IN94 = *OFF)                         CER054
     C                   EVAL      *IN92 = *ON                                                CER054
     C                   EVAL      W#EROR2 = 'Y'                                              CER054
      *                                                                                       CER054
     C                   IF        *IN93 = *OFF AND *IN94 = *OFF                              CER054
     C                   EVAL      PZMsgID = 'USR9918'                                        CER054
     C                   ELSE                                                                 CER054
     C                   EVAL      PZMsgID = 'USR9919'                                        CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   EXSR      SRZasnms                                                   CER054
      *                                                                                       CER054
     C                   ELSE                                                                 CER054
     C                   EVAL      WVTEDT = ZDAYNO                                            CER054
      *                                                                                       CER054
     C                   IF        #1ACTN = 'A' AND                                         AR795965
     C                             ZDAYNO = EWTEDT                                          AR795965
     C                   ELSE                                                               AR795965
     C                   IF        ZDAYNO < BJRDNB                                            CER054
     C                   EVAL      *IN92 = *ON                                                CER054
     C                   EVAL      W#EROR2 = 'Y'                                              CER054
     C                   EVAL      PZMsgID = 'USR9917'                                        CER054
     C                   EXSR      SRZasnms                                                   CER054
     C                   ENDIF                                                                CER054
     C                   ENDIF                                                              AR795965
     C                   ENDIF                                                                CER054
      **********                                                                  BUG26436 AR738246A
     C**********         ELSEIF    #2TEDT = *BLANKS AND                           BUG26436 AR738246A
     C**********                   #2CTRR <> *BLANKS                              BUG26436 AR738246A
     C**********         EVAL      *IN92 = *ON                                    BUG26436 AR738246A
     C**********         EVAL      W#EROR2 = 'Y'                                  BUG26436 AR738246A
     C**********         EVAL      PZMsgID = 'USR9926'                            BUG26436 AR738246A
     C**********         EXSR      SRZasnms                                       BUG26436 AR738246A
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER048
                                                                                              CGL157
     C                   IF        CGL157 = 'Y'                                               CGL157
     C                   IF        #2CRSA <> 'Y'                                              CGL157
     C                             AND #2CRSA <> 'N'                                          CGL157
     C                             AND #2CRSA <> ' '                                          CGL157
     C                   EVAL      *IN40 = *ON                                                CGL157
     C                   EVAL      *IN67 = *ON                                                CGL157
     C                   EVAL      W#EROR2 = 'Y'                                              CGL157
     C                   EVAL      PZMsgID = 'USS0600'                                        CGL157
     C                   EXSR      SRZasnms                                                   CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      WWEFDT = *Zero                                             CGL157
     C                   IF        #2EFDT = *BLANKS                                           CGL157
     C                             AND #2CRSA = 'Y'                                           CGL157
     C                   EVAL      *IN40 = *ON                                                CGL157
     C                   EVAL      *IN68 = *ON                                                CGL157
     C                   EVAL      W#EROR2 = 'Y'                                              CGL157
     C                   EVAL      PZMsgID = 'USS0601'                                        CGL157
     C                   EXSR      SRZasnms                                                   CGL157
     C                   ELSE                                                                 CGL157
     C                   IF        #2EFDT <> *BLANKS                                          CGL157
     C                   MOVE      #2EFDT        WDATEN                                       CGL157
     C                   MOVE      WDATEN        WDATEA                                       CGL157
     C                   TESTN                   #2EFDT               85                      CGL157
     C                   CALLB     'ZDATE1'                                                   CGL157
     C                   PARM                    WDATEA                                       CGL157
     C                   PARM                    ZDAYNO                                       CGL157
     C                   PARM                    BJDFIN                                       CGL157
     C                   PARM                    ErrorFlag                                    CGL157
     C                   IF        ErrorFlag = 'Y' or                                         CGL157
     C                             *IN85 = *OFF                                               CGL157
     C                   EVAL      *IN40 = *ON                                                CGL157
     C                   EVAL      *IN68 = *ON                                                CGL157
     C                   EVAL      W#EROR2 = 'Y'                                              CGL157
     C                   EVAL      PZMsgID = 'USS0602'                                        CGL157
     C                   EXSR      SRZasnms                                                   CGL157
     C                   ELSE                                                                 CGL157
     C                   Z-ADD     ZDAYNO        WWEFDT                                       CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        #2FRYR = *BLANKS                                           CGL157
     C                             AND #2CRSA = 'Y'                                           CGL157
     C                   EVAL      *IN40 = *ON                                                CGL157
     C                   EVAL      *IN69 = *ON                                                CGL157
     C                   EVAL      W#EROR2 = 'Y'                                              CGL157
     C                   EVAL      PZMsgID = 'USS0603'                                        CGL157
     C                   EXSR      SRZasnms                                                   CGL157
     C                   ELSE                                                                 CGL157
     C                   IF        #2FRYR <> *BLANKS                                          CGL157
     C                   MOVE      #2FRYR        WFRYRN                                       CGL157
     C                   TESTN                   #2FRYR               85                      CGL157
     C                   IF        *IN85 = *OFF                                               CGL157
     C                   EVAL      *IN40 = *ON                                                CGL157
     C                   EVAL      *IN69 = *ON                                                CGL157
     C                   EVAL      W#EROR2 = 'Y'                                              CGL157
     C                   EVAL      PZMsgID = 'USS0604'                                        CGL157
     C                   EXSR      SRZasnms                                                   CGL157
     C                   ELSE                                                                 CGL157
     C                   IF        *IN68 = *OFF                                               CGl157
     C                   CALLB     'ZDATE9'                                                   CGL157
     C                   PARM      WWEFDT        WWDAYN                                       CGL157
     C                   PARM                    WWDATE                                       CGL157
     C                   PARM                    WWRTN                                        CGL157
     C                   MOVEL     WWDATE        WWFRYR                                       CGL157
     C                   IF        WFRYRN < WWFRYR                                            CGL157
     C                   EVAL      *IN40 = *ON                                                CGL157
     C                   EVAL      *IN69 = *ON                                                CGL157
     C                   EVAL      W#EROR2 = 'Y'                                              CGL157
     C                   EVAL      PZMsgID = 'USS0605'                                        CGL157
     C                   EXSR      SRZasnms                                                   CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        #2RPDT = *BLANKS                                           CGL157
     C                             AND #2CRSA = 'Y'                                           CGL157
     C                   EVAL      *IN40 = *ON                                                CGL157
     C                   EVAL      *IN72 = *ON                                                CGL157
     C                   EVAL      W#EROR2 = 'Y'                                              CGL157
     C                   EVAL      PZMsgID = 'USS0606'                                        CGL157
     C                   EXSR      SRZasnms                                                   CGL157
     C                   ELSE                                                                 CGL157
     C                   IF        #2RPDT <> *BLANKS                                          CGL157
     C                   MOVEL     #2RPDT        WDATEA                                       CGL157
     C                   MOVE      '00'          WDATEA                                       CGL157
     C                   TESTN                   #2RPDT               85                      CGL157
     C                   CALLB     'ZDATE1'                                                   CGL157
     C                   PARM                    WDATEA                                       CGL157
     C                   PARM                    ZDAYNO                                       CGL157
     C                   PARM                    BJDFIN                                       CGL157
     C                   PARM                    ErrorFlag         1                          CGL157
     C                   IF        ErrorFlag = 'Y' or                                         CGL157
     C                             *IN85 = *OFF                                               CGL157
     C                   EVAL      *IN40 = *ON                                                CGL157
     C                   EVAL      *IN72 = *ON                                                CGL157
     C                   EVAL      W#EROR2 = 'Y'                                              CGL157
     C                   EVAL      PZMsgID = 'USS0615'                                      MD036194
     C                   EXSR      SRZasnms                                                   CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAddReq - Process Add Request                                *
      *                                                               *
      *****************************************************************
     C     SRAddReq      BEGSR

     C                   EVAL      #1CTRR = *BLANKS
     C                   EVAL      #1CTRT = *BLANKS

     C                   DOW       *IN03 = *OFF and *IN12 = *OFF
     C                             and W1RSF = 'N'
     C                   WRITE     SD000780C2
     C                   WRITE     SD000780F1
     C                   EXFMT     SD000780D1

      ** Clear messages from program message queue
      ** and reset work fields

     C                   CALL      'ZA0250'
     C                   EVAL      W#EROR = *BLANKS
     C                   MOVEA     '000'         *IN(40)

      ** If Exit not pressed, validate Input Screen 1 fields first
      ** before displaying the second Input screen

     C                   IF        *IN03 = *OFF and *IN12 = *OFF
 
      ** Country of Tax is mandatory
 
     C                   IF        #1CTRT = *Blanks
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR4720'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        W#EROR = *Blanks
     C                   EVAL      WCTRTST = #1CTRT
     C                   IF        WTestF1 = ' ' and WTestF2 <> '?' or
     C                             WTestF2 = ' ' and WTestF1 <> '?'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR4721'
     C                   EXSR      SRZasnms
     C                   END
     C                   END
 
      ** Country of Tax should exist from Country File
 
     C                   IF        W#EROR = *Blanks
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1CTRT        PCNCD
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7504'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      #1CNNM = A4CNNM
     C                   IF        WTestF1 = '?' or WTestF2 = '?'
     C                   EVAL      #1CTRT = A4CNCD
     C                   ENDIF
     C                   ENDIF
     C                   END
 
      ** Country of residence is optional
 
 
     C                   IF        #1CTRR <> *BLANKS
     C                   EVAL      WCTRTST = #1CTRR
     C                   IF        WTestF1 = ' ' and WTestF2 <> '?' or
     C                             WTestF2 = ' ' and WTestF1 <> '?'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN42 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7654'
     C                   EXSR      SRZasnms
     C                   END
     C                   END
 
      ** Country of Residence should exist from Country File
 
     C                   IF        *IN42 = *OFF and #1CTRR <> *BLANKS
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1CTRR        PCNCD
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN42 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7696'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      WCTRN = A4CNNM
     C                   IF        WTestF1 = '?' or WTestF2 = '?'
     C                   EVAL      #1CTRR = A4CNCD
     C                   ENDIF
     C                   ENDIF
     C                   END
     C                   IF        #1CTRR = *BLANKS
     C                   EVAL      WCTRN = *BLANKS
     C                   ENDIF
 
      ** Check if code already existing on file
 
     C                   IF        W#EROR = *Blanks
     C     WKYCTR        CHAIN     SDCTTXL0                           10
     C                   IF        *IN10 = *OFF
     C                   MOVEA     '000'         *IN(40)
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7655'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        W#EROR = *Blanks and
     C                             *IN12 = *OFF and *IN03 = *OFF
     C                   EXSR      SRScrn2
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** Clear messages from program message queue
     C                   CALL      'ZA0250'
 
     C                   IF        *IN03 = *ON or *IN12 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      W1PMD = 'ADD'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelReq - Process Delete Request                             *
      *                                                               *
      *****************************************************************
     C     SRDelReq      BEGSR
 
      ** Delete Country of Tax Details
 
     C                   EXSR      SRDelete
 
     C                   IF        W#EROR <> *BLANKS
 
      ** Delete unsuccessful
 
     C                   MOVEA     '1111'        *IN(32)
     C                   MOVEA     '11'          *IN(83)
     C                   EXSR      SRMove
     C                   ELSE
 
      ** Blank out record and protect from entry
 
     C                   EXSR      SRTrailer
     C                   EXSR      SRClrScrn
     C                   EVAL      *IN84 = *OFF
 
      ** Reload subfile
 
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      #1POS1 = *Blanks
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmdReq - Process Update Request                             *
      *                                                               *
      *****************************************************************
 
     C     SRAmdReq      BEGSR
 
      ** Amend Country of Tax Details
 
     C                   EXSR      SRAmend
 
     C                   IF        W#EROR <> *BLANKS or *IN03 = *ON or
     C                             *IN12 = *ON
     C                   MOVEA     '1111'        *IN(32)
     C                   MOVEA     '11'          *IN(83)
 
      ** Reset subfile record if changed record
 
     C                   EXSR      SRMove
     C                   ELSE
 
      ** Enable entry
 
     C                   EVAL      *IN84 = *OFF
     C                   EXSR      SRTrailer
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTrailer - Update Control Files                              *
      *                                                               *
      *****************************************************************
     C     SRTrailer     BEGSR
 
     C                   MOVEL     'SDCTTXPD'    WFNAM
     C     WFNAM         CHAIN     SDFCTLL0                           60
 
     C                   IF        *IN60 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBKEY = WFNAM
     C                   EVAL      DBPGM = 'SD000780'
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   SELECT
     C                   WHEN      W1PMD = 'ADD'
     C                   ADD       1             AHNORC
     C                   ADD       1             AHNOIN
     C                   WHEN      #1ACTN = 'D'
     C                   ADD       1             AHNODL
     C                   SUB       1             AHNORC
     C                   WHEN      WCTRT = 'Y'
     C                   ADD       1             AHNOAM
     C                   ENDSL
 
     C                   ENDIF
 
     C                   UPDATE    @AHREAU
 
     C                   COMMIT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMode - Switch Between *ADD and *CHANGE Modes                *
      *                                                               *
      *****************************************************************
     C     SRMode        BEGSR
 
      ** Switch between *ADD/*CHANGE modes
 
     C                   IF        W1PMD <> 'ADD'
     C                   EVAL      W1PMD = 'ADD'
     C                   ELSE
     C                   EVAL      W1PMD = 'CHG'
     C                   ENDIF
 
     C                   EVAL      SPOSN = *BLANKS
 
     C                   EXSR      SRReload
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReload - Request Subfile Reload                             *
      *                                                               *
      *****************************************************************
     C     SRReload      BEGSR
 
      ** Request subfile reload
 
     C                   EVAL      W1RSF = 'Y'
 
     C                   IF        *IN05 = *ON
     C                   EVAL      SPOSN = *BLANKS
     C                   EVAL      #1ACTN = *BLANKS
     C                   EVAL      #1POS1 = *Blanks
     C                   EVAL      #1POS2 = *Blanks
     C                   EVAL      #1POS3 = *Blanks
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProtect - Set Display Attributes for Subfile Record         *
      *                                                               *
      *****************************************************************
     C     SRProtect     BEGSR
 
     C                   IF        W1PMD = 'ADD'
     C                   EVAL      *IN89 = *ON
     C                   ELSE
     C                   EVAL      *IN89 = *OFF
     C                   ENDIF
 
      ** Protect keys if change mode or updated record
 
     C                   IF        *IN89 = *ON
     C                   EVAL      *IN79 = *ON
     C                   ENDIF
 
     C                   IF        W1PMD = 'CHG'
     C                   EVAL      *IN78 = *ON
     C                   ENDIF
 
      ** Protect fields during Selection Mode
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrScrn - Initialise Subfile Record                         *
      *                                                               *
      *****************************************************************
     C     SRClrScrn     BEGSR
 
      ** Initialise subfile record
 
     C                   EVAL      #1ACTN = *BLANKS
     C                   EVAL      #1CNRT = *BLANKS
     C                   EVAL      #1CNNM = *BLANKS
     C                   EVAL      #1CNRR = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMove - Transfer Records from SDCTTXL1 to Subfile            *
      *                                                               *
      *****************************************************************
     C     SRMove        BEGSR
 
      ** Move SDCTTXL0 fields to subfile
 
     C                   EVAL      #1CNRT = EWCTRT
     C                   EVAL      #1CNNM = A4CNNM
     C                   EVAL      #1CNRR = EWCTRR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Create Country of Tax Details                       *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR
 
     C                   EVAL      W#EROR = *BLANKS
 
      ** Create Country of Tax Details
 
     C                   EVAL      EWCTRT = #2CTRT
     C                   EVAL      EWCTRR = #2CTRR
     C                   EVAL      EWTXS1 = #2TXS1
     C                   Z-ADD     WVEDT1        EWEDT1
     C                   EVAL      EWTRT1 = #2TRT1
     C                   EVAL      EWTXS2 = #2TXS2
     C                   Z-ADD     WVEDT2        EWEDT2
     C                   EVAL      EWTRT2 = #2TRT2
     C                   EVAL      EWTXBS = #2TXBS
     C                   EVAL      EWWTAC = #2WTAC
     C                   EVAL      EWCHTP = 'I'
     C                   Z-ADD     BJRDNB        EWLCDT
     C                   EVAL      EWDMAP = #2DMAP                                            236137
     C                   Z-ADD     WWTTDP        EWTTDP                                       236137
     C                   Z-ADD     WWYRDP        EWYRDP                                       236137
     C                   EVAL      EWTXCB = #2TXCB                                            236137
     C                   EVAL      EWPADD = #2PADD                                            236137
     C                   EVAL      EWTIST = #2TIST                                            236137
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   EVAL      EWSTXB = #2STXB                                            CER048
     C                   EVAL      EWSTAC = #2STAC                                            CER048
      *                                                                                       CER048
     C                   Z-ADD     WVSeDt        EWSEDT                                       CER048
     C                   Z-ADD     WWRaRl        EWRARL                                       CER048
     C                   Z-ADD     WVRaEd        EWRAED                                       CER048
      *                                                                                       CER048
     C                   MOVE      WWPaRl        EWPARL                                       CER048
     C                   EVALR     W2InTh = %TRIMR(#2INTH)                                    CER048
     C                   MOVE      W2InTh        EWINTH                                       CER048
     C                   EVALR     W2JtTh = %TRIMR(#2JTTH)                                    CER048
     C                   MOVE      W2JtTh        EWJTTH                                       CER048
     C                   EVALR     W2EcTh = %TRIMR(#2ECTH)                                    CER048
     C                   MOVE      W2EcTh        EWECTH                                       CER048
      *                                                                                       CER048
     C**********         Z-ADD     WWSaTh        EWSATH                              CER048 BUG23587
     C                   MOVE      #2MPCR        EWMPCR                                       CER048
     C                   MOVE      #2THMD        EWTHMD                                       CER048
      *                                                                                       CER048
     C                   IF        CER054 = 'Y'                                               CER054
     C                   EVAL      EWTTAM = #2TTAM                                            CER054
     C                   EVAL      EWTTAC = #2TTAC                                            CER054
     C                   EVAL      EWTEDT = WVTEDT                                            CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER048
     C                   IF        CGL157 = 'Y'                                               CGL157
     C                   EVAL      EWCRSA = #2CRSA                                            CGL157
     C                   EVAL      EWFRYR = #2FRYR                                            CGL157
     C                   EVAL      EWRPDT = #2RPDT                                            CGL157
     C                   Z-ADD     WWEFDT        EWEFDT                                     MD036195
     C                   ENDIF                                                                CGL157
 
      ** Check for duplicate primary key
 
     C     WKYCTR        SETLL     @CTTXL0                                60
 
     C                   IF        *IN60 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0017'
     C                   EXSR      SRZasnms
     C                   ELSE
 
     C                   WRITE     @CTTXL0                              61
 
      ** Write error detected
 
     C                   IF        *IN61 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      *IN03 = *ON
     C                   ELSE
     C                   EXSR      SRGenRec
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelete - Delete Country of Tax Details                      *
      *                                                               *
      *****************************************************************
     C     SRDelete      BEGSR
 
      ** Deletion not allowed when system setup is complete
 
     C                   EVAL      W#EROR = *BLANKS
     C                   IF        WSUC <> 'N'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR4745'
     C                   EXSR      SRZasnms
     C                   ELSE
 
     C     WKYCNR        CHAIN     SDCTTXL0                           63
 
      ** Record already deleted
 
     C                   IF        *IN63 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7602'
     C                   EXSR      SRZasnms
     C                   ELSE
 
     C                   DELETE    SDCTTXL0
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmend  - Update Country of Tax Details                      *
      *                                                               *
      *****************************************************************
     C     SRAmend       BEGSR
 
      ** Change Country of Tax Details
 
     C                   EVAL      W#EROR = *BLANKS
     C                   EVAL      #1CTRR = #1CNRR
     C                   EVAL      #1CTRT = #1CNRT
 
     C                   EXSR      SRScrn2Clr
 
     C     WKYCNR        CHAIN     @CTTXL0                            63
 
      ** Record not found
 
     C                   IF        *IN63 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7605'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Move to display file fields
 
     C                   EVAL      #2CTRT = EWCTRT
     C                   EVAL      #2CTRR = EWCTRR
     C                   EVAL      #2TXS1 = EWTXS1
     C                   EVAL      ZDAYNO = EWEDT1
     C                   EXSR      ZDATE2
     C                   EVAL      #2EDT1 = *BLANKS
     C                   MOVEL     ZDATE         #2EDT1
     C                   EVAL      #2TRT1 = EWTRT1
     C                   EVAL      #2TXS2 = EWTXS2
     C                   IF        EWEDT2 <> 0
     C                   EVAL      ZDAYNO = EWEDT2
     C                   EXSR      ZDATE2
     C                   EVAL      #2EDT2 = *BLANKS
     C                   MOVEL     ZDATE         #2EDT2
     C                   ENDIF
     C                   EVAL      #2TRT2 = EWTRT2
     C                   EVAL      #2TXBS = EWTXBS
     C                   EVAL      #2WTAC = EWWTAC
     C                   EVAL      #2DMAP = EWDMAP                                            236137
     C                   MOVE      *BLANKS       ZFIELD                                       236137
     c     EWDMAP        IFEQ      'Y'                                                        236137
     C                   MOVE      EWTTDP        ZFIELD                                       236137
     C                   CALLB     'ZEDIT'                                                    236137
     C                   PARM                    ZFIELD                                       236137
     C                   PARM      3             ZADEC                                        236137
                                                                                              236137
     C                   ENDIF                                                                236137
     C                   MOVE      ZFIELD        #2TTDP                                       236137
     C                   MOVE      *BLANKS       ZFIELD                                       236137
     c     EWDMAP        IFEQ      'Y'                                                        236137
     C                   MOVE      EWYRDP        ZFIELD                                       236137
     C                   CALLB     'ZEDIT'                                                    236137
     C                   PARM                    ZFIELD                                       236137
     C                   PARM      3             ZADEC                                        236137
                                                                                              236137
     C                   ENDIF                                                                236137
     C                   MOVE      ZFIELD        #2YRDP                                       236137
     C                   EVAL      #2TXCB = EWTXCB                                            236137
     C                   EVAL      #2PADD = EWPADD                                            236137
     C                   EVAL      #2TIST = EWTIST                                            236137
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   EVAL      #2STXB = EWSTXB                                            CER048
     C                   EVAL      #2STAC = EWSTAC                                            CER048
      *                                                                                       CER048
     C                   IF        EWSEDT <> 0                                                CER048
      *                                                                                     BUG23659
      ** Save Current  Secondary Effect. Date                                               BUG23659
      *                                                                                     BUG23659
     C                   Z-ADD     EWSEDT        WEWSEDT                                    BUG23659
      *                                                                                     BUG23659
     C                   EVAL      ZDAYNO = EWSEDT                                            CER048
     C                   EXSR      ZDATE2                                                     CER048
     C                   EVAL      #2SEDT = *BLANKS                                           CER048
     C                   MOVEL     ZDATE         #2SEDT                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   MOVE      *BLANKS       ZFIELD                                       CER048
     C                   MOVE      EWRARL        ZFIELD                                       CER048
     C                   EVAL      ZADEC = 5                                                  CER048
     C                   EXSR      SRZEDIT                                                    CER048
     C                   MOVE      ZFIELD        #2RARL                                       CER048
      *                                                                                       CER048
     C                   IF        EWRAED <> 0                                                CER048
     C                   EVAL      ZDAYNO = EWRAED                                            CER048
     C                   EXSR      ZDATE2                                                     CER048
     C                   EVAL      #2RAED = *BLANKS                                           CER048
     C                   MOVEL     ZDATE         #2RAED                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   MOVE      *BLANKS       ZFIELD                                       CER048
     C                   MOVE      EWPARL        ZFIELD                                       CER048
     C                   MOVE      EWPARL        WWPaRl                                       CER048
     C                   EVAL      ZADEC = 5                                                  CER048
     C                   EXSR      SRZEDIT                                                    CER048
     C                   MOVE      ZFIELD        #2PARL                                       CER048
      *                                                                                       CER048
     C                   MOVE      EWINTH        #2INTH                                       CER048
     C                   MOVE      EWJTTH        #2JTTH                                       CER048
     C                   MOVE      EWECTH        #2ECTH                                       CER048
     C                   MOVE      *BLANKS       ZFIELD                                       CER048
     C**********         MOVE      EWSATH        ZFIELD                              CER048 BUG23587
      **********                                                                     CER048 BUG23587
     C**********         EVAL      ZADEC = 2                                         CER048 BUG23587
     C**********         EXSR      SRZEDIT                                           CER048 BUG23587
     C**********         MOVE      ZFIELD        #2SATH                              CER048 BUG23587
     C                   MOVE      EWMPCR        #2MPCR                                       CER048
     C                   MOVE      EWTHMD        #2THMD                                       CER048
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
     C                   EVAL      #2TTAM = EWTTAM                                            CER054
     C                   EVAL      #2TTAC = EWTTAC                                            CER054
     C                   IF        EWTEDT <> 0                                                CER054
     C                   EVAL      ZDAYNO = EWTEDT                                            CER054
     C                   EXSR      ZDATE2                                                     CER054
     C**********         EVAL      #2SEDT = *BLANKS                                  CER054 BUG26629
     C                   EVAL      #2TEDT = *BLANKS                                         BUG26629
     C                   MOVEL     ZDATE         #2TEDT                                       CER054
     C                   ENDIF                                                                CER054
     C                   ENDIF                                                                CER054
     C                   ENDIF                                                                CER048
     C                   IF        CGL157 = 'Y'                                               CGL157
     C                   EVAL      #2CRSA = EWCRSA                                            CGL157
     C                   EVAL      #2FRYR = EWFRYR                                            CGL157
     C                   EVAL      #2RPDT = EWRPDT                                            CGL157
     C                   IF        EWEFDT <> 0                                                CGL157
     C                   EVAL      ZDAYNO = EWEFDT                                            CGL157
     C                   EXSR      ZDATE2                                                     CGL157
     C                   EVAL      #2EFDT = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         #2EFDT                                       CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
 
      ** Put original contents aside in case of Refresh action
     C                   EVAL      P2TXS1 = #2TXS1
     C                   MOVEL     #2EDT1        P2EDT1
     C                   EVAL      P2TRT1 = #2TRT1
     C                   EVAL      P2TXS2 = #2TXS2
     C                   MOVEL     #2EDT2        P2EDT2
     C                   EVAL      P2TRT2 = #2TRT2
     C                   EVAL      P2TXBS = #2TXBS
     C                   EVAL      P2WTAC = #2WTAC
     C                   EVAL      P2DMAP = #2DMAP                                            236137
     C                   EVAL      P2TTDP = #2TTDP                                            236137
     C                   EVAL      P2YRDP = #2YRDP                                            236137
     C                   EVAL      P2TXCB = #2TXCB                                            236137
     C                   EVAL      P2PADD = #2PADD                                            236137
     C                   EVAL      P2TIST = #2TIST                                            236137
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   EVAL      P2StXb = #2STXB                                            CER048
     C                   EVAL      P2StAc = #2STAC                                            CER048
     C                   EVAL      P2SeDt = #2SEDT                                            CER048
     C                   EVAL      P2RaRl = #2RARL                                            CER048
     C                   EVAL      P2RaEd = #2RAED                                            CER048
     C                   EVAL      P2PaRl = #2PARL                                            CER048
     C                   EVAL      P2InTh = #2INTH                                            CER048
     C                   EVAL      P2JtTh = #2JTTH                                            CER048
     C                   EVAL      P2EcTh = #2ECTH                                            CER048
     C**********         EVAL      P2SaTh = #2SATH                                   CER048 BUG23587
     C                   EVAL      P2MpCr = #2MPCR                                            CER048
     C                   EVAL      P2ThMd = #2THMD                                            CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
     C                   IF        CER054 = 'Y'                                               CER054
     C                   EVAL      P3TtAm = #2TTAM                                            CER054
     C                   EVAL      P3TtAc = #2TTAC                                            CER054
     C                   EVAL      P3TeDt = #2TEDT                                            CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
      *                                                                                       CER048
     C                   IF        CGL157 = 'Y'                                               CGL157
     C                   EVAL      #2CRSA = EWCRSA                                            CGL157
     C                   EVAL      #2FRYR = EWFRYR                                            CGL157
     C                   EVAL      #2RPDT = EWRPDT                                            CGL157
     C                   IF        EWEFDT <> 0                                                CGL157
     C                   EVAL      ZDAYNO = EWEFDT                                            CGL157
     C                   EXSR      ZDATE2                                                     CGL157
     C                   EVAL      #2EFDT = *BLANKS                                           CGL157
     C                   MOVEL     ZDATE         #2EFDT                                       CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF                                                                CGL157
     C                   ENDIF
 
      ** Country of Tax should exist from Country File
 
     C                   EVAL      #2CTNM = *BLANKS
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #2CTRT        PCNCD
     C     SDCTRY        PARM      SDCTRY        DSFDY
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7504'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      #2CTNM = A4CNNM
     C                   ENDIF
 
      ** Country of residence is optional
 
     C                   EVAL      #2CTRN = *BLANKS
     C                   IF        #2CTRR <> *BLANKS
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #2CTRR        PCNCD
     C     SDCTRY        PARM      SDCTRY        DSFDY
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7696'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      #2CTRN = A4CNNM
     C                   ENDIF
     C                   ENDIF
 
      ** Check if code already existing on file
 
     C                   EXSR      SRScrn2
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
      ** Set record data changed flag
 
     C                   EVAL      WCTRT = 'N'
 
     C                   IF        W#EROR = *Blanks and *IN12 <> *ON and
     C                             *IN03 <> *ON
     C     WKYCNR        CHAIN     @CTTXL0                            63
 
      ** Record not found
 
     C                   IF        *IN63 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7605'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ***Populate*screen*fields****************************************                       236137
      ** Populate file fields.                                                                236137
 
     C                   EVAL      EWCTRT = #2CTRT
     C                   EVAL      EWCTRR = #2CTRR
     C                   EVAL      EWTXS1 = #2TXS1
     C                   Z-ADD     WVEDT1        EWEDT1
     C                   EVAL      EWTRT1 = #2TRT1
     C                   EVAL      EWTXS2 = #2TXS2
     C                   Z-ADD     WVEDT2        EWEDT2
     C                   EVAL      EWTRT2 = #2TRT2
     C                   EVAL      EWTXBS = #2TXBS
     C                   EVAL      EWWTAC = #2WTAC
     C                   EVAL      EWDMAP = #2DMAP                                            236137
     C                   Z-ADD     WWTTDP        EWTTDP                                       236137
     C                   Z-ADD     WWYRDP        EWYRDP                                       236137
     C                   EVAL      EWTXCB = #2TXCB                                            236137
     C                   EVAL      EWPADD = #2PADD                                            236137
     C                   EVAL      EWTIST = #2TIST                                            236137
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   EVAL      EWSTXB = #2STXB                                            CER048
     C                   EVAL      EWSTAC = #2STAC                                            CER048
      *                                                                                       CER048
     C                   Z-ADD     WVSeDt        EWSEDT                                       CER048
     C                   Z-ADD     WWRaRl        EWRARL                                       CER048
     C                   Z-ADD     WVRaEd        EWRAED                                       CER048
      *                                                                                       CER048
     C                   MOVE      WWPaRl        EWPARL                                       CER048
     C                   EVALR     W2InTh = %TRIMR(#2INTH)                                    CER048
     C                   MOVE      W2InTh        EWINTH                                       CER048
     C                   EVALR     W2JtTh = %TRIMR(#2JTTH)                                    CER048
     C                   MOVE      W2JtTh        EWJTTH                                       CER048
     C                   EVALR     W2EcTh = %TRIMR(#2ECTH)                                    CER048
     C                   MOVE      W2EcTh        EWECTH                                       CER048
      *                                                                                       CER048
     C**********         Z-ADD     WWSaTh        EWSATH                              CER048 BUG23587
     C                   EVAL      EWMPCR = #2MPCR                                            CER048
     C                   EVAL      EWTHMD = #2THMD                                            CER048
      *                                                                                       CER048
     C                   IF        CER054 = 'Y'                                               CER054
     C                   EVAL      EWTTAM = #2TTAM                                            CER054
     C                   EVAL      EWTTAC = #2TTAC                                            CER054
     C                   CALLB     'ZDATE1'                                                   CER054
     C                   PARM      #2TEDT        ZDATEI                                       CER054
     C                   PARM      *ZERO         ZDAYNO                                       CER054
     C                   PARM                    BJDFIN                                       CER054
     C                   PARM                    ERRORFLAG                                    CER054
     C                   EVAL      EWTEDT = ZDAYNO                                            CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        CGL157 = 'Y'                                               CGL157
     C                   EVAL      EWCRSA = #2CRSA                                            CGL157
     C                   EVAL      EWFRYR = #2FRYR                                            CGL157
     C                   EVAL      EWRPDT = #2RPDT                                            CGL157
     C                   Z-ADD     WWEFDT        EWEFDT                                       CGL157
     C                   ENDIF                                                                CGL157
     C                   EVAL      EWCHTP = 'A'
     C                   Z-ADD     BJRDNB        EWLCDT
     C                   UPDATE    @CTTXL0
     C                   EVAL      WCTRT = 'Y'
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN03 = *ON or *IN12 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************                     BUG26850
      /EJECT                                                                                BUG26850
      *****************************************************************                     BUG26850
      *                                                               *                     BUG26850
      * SRAccntck - Handles the checking of used account codes        *                     BUG26850
      *                                                               *                     BUG26850
      *****************************************************************                     BUG26850
     C     SRAccntck     BEGSR                                                              BUG26850
                                                                                            BUG26850
     C     #ACCNT        CHAIN     SDCTTXL5                                                 BUG26850
     C                   IF        %FOUND(SDCTTXL5)                                         BUG26850
     C                   EVAL      #RDERR = '  PRIMARY'                                     BUG26850
     C                   ELSE                                                               BUG26850
     C     #ACCNT        CHAIN     SDCTTXL6                                                 BUG26850
     C                   IF        %FOUND(SDCTTXL6)                                         BUG26850
     C                   EVAL      #RDERR = 'SECONDARY'                                     BUG26850
     C                   ENDIF                                                              BUG26850
     C                   ENDIF                                                              BUG26850
                                                                                            BUG26850
     C                   ENDSR                                                              BUG26850
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZasnms - Message Handling Subroutine                        *
      *                                                               *
      *****************************************************************
     C     SRZasnms      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       236137
      *                                                               *                       236137
      * SRZasnmsd - Handles the display of error messages with        *                       236137
      *             substitution values.                              *                       236137
      *                                                               *                       236137
      * Called By: SRScrn2v subroutine                                *                       236137
      *                                                               *                       236137
      * Calls:                                                        *                       236137
      * ZA0350   - Add message to pgm subfile message queue.          *                       236137
      *                                                               *                       236137
      *                                                               *                       236137
      *****************************************************************                       236137
     C     SRZasnmsd     BEGSR                                                                236137
                                                                                              236137
     C                   CALL      'ZA0350'                                                   236137
     C                   PARM                    PZMsgFile                                    236137
     C                   PARM                    PZMsgID                                      236137
     C                   PARM                    PZMsgDta                                     236137
                                                                                              236137
     C                   ENDSR                                                                236137
      *                                                                                       236137
      *****************************************************************                       236137
      /EJECT                                                                                  236137
      *****************************************************************
      *                                                               *
      * SREnd - End Program                                           *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR
 
      ** Rollback any uncommitted DBF changes
 
     C                   ROLBK                                          60
 
      ** If selection mode and F3 has been pressed
      ** Terminate program
     C                   EVAL      *INLR = *ON
 
      ** Exit program
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGenRec - Calls the initialisation programs to generate      *
      *            records in SDACTXPD and SDNHTXPD                   *
      *                                                               *
      *****************************************************************
     C     SRGenRec      BEGSR
 
      ** Generate records in SDACTXPD for the new Country of Tax defined
 
     C                   CALL      'SD000778'
 
      ** Generate records in SDNHTXPD for the new Country of Tax defined
 
     C                   CALL      'SD000779'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *                       CER048
      * SRZedit - Subroutine to formate numeric field                 *                       CER048
      *                                                               *                       CER048
      *****************************************************************                       CER048
     C     SRZedit       BEGSR                                                                CER048
      *                                                                                       CER048
     C                   CALLB     'ZEDIT'                                                    CER048
     C                   PARM                    ZFIELD                                       CER048
     C                   PARM                    ZADEC                                        CER048
      *                                                                                       CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER048
      /EJECT                                                                                  CER048
      *****************************************************************                       CER048
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@
 
      ** Receive entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PMODE
 
      ** Define LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SD000780'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      ** Obtain default message file
 
      ** Call Access Program for Bank Details
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBPGM  = 'SD000780'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Open files for update
     C                   OPEN      SD000780DF
     C                   IF        #CTTX0 <> '1'
     C                   OPEN      SDCTTXL0
     C                   ENDIF
     C                   IF        #CTTX1 <> '1'
     C                   OPEN      SDCTTXL1
     C                   ENDIF
 
                                                                                              CGL157
      ** Check if enhancement CGL157 (CRS Reporting) is on                                    CGL157
                                                                                              CGL157
     C                   CALLB     'AOSARDR0'                                                 CGL157
     C                   PARM      *BLANKS       PRTCD                                        CGL157
     C                   PARM      '*VERIFY'     POPTN                                        CGL157
     C                   PARM      'CGL157'      PSARD                                        CGL157
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL157
                                                                                              CGL157
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CGL157
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL157
     C                   EVAL      DBKEY  = 'CGL157'                                          CGL157
     C                   EVAL      DBASE  = 4                                                 CGL157
     C                   EXSR      *PSSR                                                      CGL157
     C                   ENDIF                                                                CGL157
      *                                                                                       CGL157
     C                   IF        PRTCD = *BLANKS                                            CGL157
     C                   EVAL      CGL157 = 'Y'                                               CGL157
     C                   EVAL      *IN39 = '0'                                                CGL157
     C                   ELSE                                                                 CGL157
     C                   EVAL      CGL157 = 'N'                                               CGL157
     C                   EVAL      *IN39 = '1'                                                CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   Z-ADD     14            WSFPG
 
      ** Set to *CHANGE mode
     C                   EVAL      W1PMD = 'CHG'
 
      ** Initialise subfile control
     C                   EVAL      SPOSN = *BLANKS
     C                   EVAL      #1RUNA = BJMRDT
     C                   EVAL      #1PGMQ = PSProcName
     C                   EVAL      #1WSID = PSJobName
     C                   EVAL      #1USER = PSUser
 
      * Initialise subfile control
     C                   MOVEL     *BLANK        #1POS1
     C                   MOVEL     *BLANK        #1POS2
     C                   MOVEL     *BLANK        #1POS3
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRTCD                                        CER048
     C                   PARM      '*VERIFY'     POPTN                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRTCD = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   EVAL      *IN13 = *ON                                                CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   EVAL      *IN13 = *OFF                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRTCD <> *BLANKS AND                                       CER048
     C                             PRTCD <> '*NRF   '                                         CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBKEY = 'CER048'                                           CER048
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER048
     C                   MOVE      '004'         DBASE                                        CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER054
     C                   CALL      'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRTCD                                        CER054
     C                   PARM      '*VERIFY'     POPTN                                        CER054
     C                   PARM      'CER054'      PSard                                        CER054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'N'                                               CER054
     C                   EVAL      *IN66 = *OFF                                               CER054
      *                                                                                       CER054
     C                   IF        PRTCD = *BLANKS                                            CER054
     C                   EVAL      CER054 = 'Y'                                               CER054
     C                   EVAL      *IN66 = *ON                                                CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   IF        PRTCD <> *BLANKS AND                                       CER054
     C                             PRTCD <> '*NRF   '                                         CER054
     C     *LOCK         IN        LDA                                                        CER054
     C                   EVAL      DBKEY = 'CER054'                                           CER054
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER054
     C                   MOVE      '005'         DBASE                                        CER054
     C                   OUT       LDA                                                        CER054
     C                   EXSR      *PSSR                                                      CER054
     C                   ENDIF                                                                CER054
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2004
