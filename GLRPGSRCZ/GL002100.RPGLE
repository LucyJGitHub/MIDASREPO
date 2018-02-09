     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Amount Amortisation Maintenance')             *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL002100 - Midas GL Amount Amortisation Input                *
      *                                                               *
      *  Function:  This module enables the user to insert, maintain  *
      *             and enquire upon Amount Amortisation details.     *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 252091             Date 19Aug14               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG12598           Date 15Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242286             Date 27Sep06               *
      *                 BUG12413           Date 02Nov06               *
      *                 BUG10841           Date 17Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAS011             Date 16May05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  252091 - Amended program to prevent calculation of discount  *
      *           amount to have a very large value that may cause    *
      *           database error.                                     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  BUG12598 - Linear Effective Yield computation is wrong       *
      *  242286 - Enhance calculation of interest for calc basis 6.   *
      *  BUG12413 - GL Amount Amortization set up missing             *
      *  BUG10841 - Database error due to computed Yield limitation   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators:                                           *
      *                                                               *
      *    26    Enable F5                                            *
      *    27    Enable F10                                           *
      *    28    Enable F12                                           *
      *                                                               *
      *    30    Error indicator for Transaction Reference            *
      *    31    Error indicator for Action Code                      *
      *    32    Error indicator for Branch Code                      *
      *    33    Error indicator for Currency Code                    *
      *    34    Error indicator for Profit Centre                    *
      *    35    Error indicator for Start Date                       *
      *    36    Error indicator for Maturity Date                    *
      *    37    Error indicator for Discounted Amount                *
      *    38    Error indicator for Par Amount                       *
      *    39    Error indicator for Effective Yield                  *
      *    40    Error indicator for Calculation Basis                *
      *    41    Error indicator for Amortisation Method              *
      *    42    Error indicator for Debit Account Code               *
      *    43    Error indicator for Debit A/C Sequence No.           *
      *    44    Error indicator for Debit Customer Number            *
      *    45    Error indicator for Credit Account Code              *
      *    46    Error indicator for Credit A/C Sequence No.          *
      *    47    Error indicator for Credit Customer Number           *
      *    48    Error indicator for Posting Narrative                *
      *    49    Display user message                                 *
      *                                                               *
      *    50    Protect Prompt fields                                *
      *    51    Protect Detail fields except for #2EFYL #2MDAT       *
      *          #PRAM and #2DSAM                                     *
      *    52    Protect #2EFYL                                       *
      *    53    Protect #2MDAT #2PRAM and #2DSAM                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrDisplay - Display screen                                   *
      *  SrEnquire - Enquiry processing                               *
      *  SrInsert - Insert processing                                 *
      *  SrAmend - Amend processing                                   *
      *  SrDelete - Delete processing                                 *
      *  SrWrite - Write details to GLAMRTPD                          *
      *  SrUpdate - Amend/Update details in GLAMRTPD                  *
      *  SrFiletoScrn - Format and move file field values to screen   *
      *  SrValidate - Process field validations                       *
      *  SrValActCde - Validate Action Code                           *
      *  SrValAREF - Validate Transaction Reference                   *
      *  SrValBRCA - Validate Branch Code                             *
      *  SrValCCY - Validate Currency Code                            *
      *  SrValPRFC - Validate Profit Centre                           *
      *  SrValSTDT - Validate Start Date                              *
      *  SrValMDAT - Validate Maturity Date                           *
      *  SrValDSAM - Validate Discounted Amount                       *
      *  SrValPRAM - Validate Par Amount                              *
      *  SrValEFYL - Validate Effective Yield                         *
      *  SrValCLBS - Validate Calculation Basis                       *
      *  SrValAMMD - Validate Amortisation Method                     *
      *  SrValDRCO - Validate Debit Account Code                      *
      *  SrValDRSQ - Validate Debit Account Sequence                  *
      *  SrValDRCN - Validate Debit Customer                          *
      *  SrValCRCO - Validate Credit Account Code                     *
      *  SrValCRSQ - Validate Credit Account Sequence                 *
      *  SrValCRCN - Validate Credit Customer                         *
      *  SrValNARR - Validate Posting Narrative                       *
      *  SrValDebitAC - Validate Debit Account                        *
      *  SrValCreditAC - Validate Credit Account                      *
      *  SrCustomer - Access Customer details                         *
      *  SrAcctCode - Access Account code details                     *
      *  SrCurrency - Access Currency details                         *
      *  SrFullAcct - Validate Full Account Key                       *
      *  SrValCalAmort - Validate if approriate amortisation values   *
      *                  are inputted then calculate for other values *
      *                  as necessary                                 *
      *  SrCalcDSAM - Calculate Discounted Amount                     *
      *  SrCalcPRAM - Calculate Par Amount                            *
      *  SrCalcEFYL - Calculate Effective Yield                       *
      *  SrZEdit - Format amount                                      *
      *  SrZDate1 - Validate & convert date to a day number           *
      *  SrZDate2 - Convert a day number to date format               *
      *  SrZAlign - Validate and align amounts                        *
      *  SrZASign - Validate and align signed amounts                 *
      *  SrZasnms - Message Handling Subroutine                       *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGL002100DFCF   E             WORKSTN INFSR(*PSSR)
      ** Amount Amortisations Maintenance Display File
 
     FGLAMRTL0  UF A E           K DISK    COMMIT
      ** Amount Amortisations File - Update
     F                                     INFSR(*PSSR)
 
     FGLAMRTL1  IF   E           K DISK
      ** Amount Amortisations File - Retrieve
     F                                     INFSR(*PSSR)
     F                                     RENAME(GLAMRTD0:GLAMRTD1)
     FGLAMRZPD  UF   E             DISK    COMMIT
      ** Amount Amortisations File - Trailer
 
     FACCNT     IF   E           K DISK
      ** General Ledger Accounts master
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
     D RUNDAT          DS
     D  MultBrcInd            13     13
 
     DZMUSER           DS            17
     D  DefBrch               11     13
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D Digits          C                   '0123456789'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Profit Center Details
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
 
      ** External data structure for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CAS011
 
      ** External data structure for Account Code Details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
      ** External data structure for Narrative Code Details
     D SDNARR        E DS                  EXTNAME(SDNARRPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      ** DS for screen fields
     D WScrnFld        DS
     D  #1ACTN                 1      1
     D  #1AREF                 2      7
     D  #2BRCA                 8     10
     D  #2CCY                 11     13
     D  #2PRFC                14     17
     D  #2STDT                18     23
     D  #2MDAT                24     29
     D  #2DSAM                30     43
     D  #2PRAM                44     57
     D  #2EFYL                58     73
     D  #2CLBS                74     74
     D  #2AMMD                75     75
     D**#2DRCO********        76     79                                                       CAS011
     D**#2DRSQ********        80     81                                                       CAS011
     D**#2DRCN********        82     87                                                       CAS011
     D**#2CRCO********        88     91                                                       CAS011
     D**#2CRSQ********        92     93                                                       CAS011
     D**#2CRCN********        94     99                                                       CAS011
     D**#2NARR********       100    129                                                       CAS011
     D  #2DRCO                76     85                                                       CAS011
     D  #2DRSQ                86     87                                                       CAS011
     D  #2DRCN                88     93                                                       CAS011
     D  #2CRCO                94    103                                                       CAS011
     D  #2CRSQ               104    105                                                       CAS011
     D  #2CRCN               106    111                                                       CAS011
     D  #2NARR               112    141                                                       CAS011
     D  WPrompt                1      7
     D**WDetail********        8    129                                                       CAS011
     D  WDetail                8    141                                                       CAS011
     D  WBakDtlB              24     73
 
     D PZMsgData       DS           132
     D  WString1               1     16
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRetCode        S              7A
     D POption         S              7A
     D PSard           S              6A
     D PBranch         S              3A
     D PAction         S              1A
     D PError          S              1P 0
     D PCcy            S              3A
     D PProfCtr        S              4A
     D PCustomer       S             10A
     D PKeyStat        S              7A
     D*PAcctCode*******S              4A                                                      CAS011
     D PAcctCode       S             10A                                                      CAS011
 
     D PReturnCd       S              1A
     D PBookCd         S              2A
     D PTransType      S              5A
     D PSubType        S              2A
     D PBranchCd       S              3A
     D PDeptCd         S              3A
     D PUser           S             10A
     D PAcctOfcrCd     S              2A
     D PCustNum        S              6A
     D PPrftCntrCd     S              4A
     D PNarrCode       S              2A
 
     D PDateIn         S              6A
     D PDaynoOut       S              5P 0
     D PDateError      S              1A
     D PDaynoIn        S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7A
 
     D PZAlignOk       S              1A
     D PZField         S             16A
     D PZField2        S             15A
     D PZDec           S              2  0
     D PZDig           S              2  0
 
     D PZFld17         S             17A
     D PZSDCSP         S              1A
     D PZOut15         S             15A
     D PZFSign         S              1A
     D PZASignOk       S              1A
 
     D PZPgmQ          S             10A
     D PZRelQ          S              5A
     D PZMsgID         S              7A
     D PZMsgFile       S             10A
     D PZMsgType       S              7A
 
     D WInitScr        S              1A
     D WError          S              1A
     D WRun            S              1A
     D WBakDtlA        S             50A
     D WNumeric        S              1  0
     D WNum6           S              6  0
     D WChar15         S             15A
     D WNarr28         S             28A
     D WFullAcctErr    S              1A
     D WReference      S              6  0
     D WDRCNMsgID      S              7A
     D WCompleted      S              1A
     D WNegative       S              1A
 
     D WFld130         S             13P 0
     D WFld131         S             13P 1
     D WFld132         S             13P 2
     D WFld133         S             13P 3
     D WFld153         S             15P 3
 
     D WkSTDT          S              5P 0
     D WkMDAT          S              5P 0
     D WKDiscAmt       S             15P 3
     D WKParAmnt       S             15P 3
     D WDscAmount      S             13P 0
     D WParAmount      S             13P 0
     D WEffYield       S             14P12
     D WEffYldDif      S             14P12
     D WEffYieldU      S             14P12
     D WEffYieldL      S             14P12
     D WNoOfYears      S             15P 8
     D WDaysInYear     S              3P 0
     D***WCalcEFYL       S             14P12                                                BUG10841
     D WCalcEFYL       S             18P12                                                  BUG10841
     D***WAbsEFYL        S             14P12                                                BUG10841
     D WAbsEFYL        S             18P12                                                  BUG10841
     D WZAmt           S             15P 0
     D WZDsAm          S                   LIKE(A1DSAM)
 
     D WEfyl           S                   LIKE(A1EFYL)
     D WEfyl2          S             15A
 
     D*KCust****       S              6  0                                                    CSD027
     D KCust           S              6A                                                      CSD027
     D KCcy            S              3A
     D*KAcct*********  S              4  0                                                    CAS011
     D KAcct           S             10  0                                                    CAS011
     D KSeq            S              2  0
     D KBrca           S              3A
 
     D ZZAMT           S             15P 3
     D ZZAMTI          S             15P 0
     D ZZAMTD          S              3P 0
     D ZZNEGD          S              5A
     D ZZTOTI          S             15P 0
     D ZZTOTD          S              3P 0
     D ZZWK2           S              4P 0
     D ZZWK3           S             15P 0
 
     D***PINT6DY*      S             15  7                                                    242286
     D PINT6DY         S             15  9                                                    242286
     D PINTDY          S              5  0
     D RetCodeOut      S             10
 
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
 
     ** Process until user exits program (F3)
     C                   DOW       *INKC = *OFF
 
      ** Set indicators controlling screen and field attributes
     C                   EVAL      WInitScr = *ON
     C                   EVAL      *IN26 = *ON
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      *IN28 = *OFF
     C                   EVAL      *IN50 = *OFF
     C                   EVAL      *IN51 = *OFF
     C                   EVAL      *IN52 = *OFF
     C                   EVAL      *IN53 = *OFF
 
      ** Display screen
     C                   EXSR      SrDisplay
 
     C
     C                   SELECT
 
      ** F3 Exit
     C                   WHEN      *INKC = *ON
 
      ** F5 Refresh
     C                   WHEN      *INKE = *ON
     C                   MOVE      *BLANKS       WPrompt
 
      ** Process initial screen
     C                   OTHER
 
      ** Validate initial screen
     C                   EXSR      SrValidate
 
      ** If no errors found, continue with processing details
     C                   IF        WError = *OFF
 
      ** Set off flag which controls display of prompt and
      ** details screen
     C                   EVAL      WInitScr = *OFF
 
     C                   SELECT
 
      ** Insert record
     C                   WHEN      #1ACTN = 'I'
     C                   EXSR      SrInsert
 
      ** Amend record
     C                   WHEN      #1ACTN = 'A'
     C                   EXSR      SrAmend
 
      ** Delete record
     C                   WHEN      #1ACTN = 'D'
     C                   EXSR      SrDelete
 
      ** Enquire record
     C                   WHEN      #1ACTN = 'E'
     C                   EXSR      SrEnquire
 
     C                   ENDSL
 
      ** Clear screen fields
     C*******************MOVE      *BLANKS       WScrnFld                                   BUG12413
     C                   IF        #1ACTN = 'I' OR
     C                             #1ACTN = 'A' OR
     C                             #1ACTN = 'D'
 
     C                   IF        WError = *OFF AND
     C                             WCompleted = *ON OR
     C                             *INKJ = *ON
     C                   COMMIT
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      *BLANKS       WScrnFld                                   BUG12413
 
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDisplay - Display screen                                    *
      *                                                               *
      *****************************************************************
     C     SrDisplay     BEGSR
 
      ** Write screen formats
     C                   WRITE     GL002100F0
     C                   WRITE     GL002100F3
     C                   WRITE     GL002100C1
 
     C                   IF        WInitScr = *ON
     C                   EXFMT     GL002100F1
     C                   ELSE
     C                   EVAL      *IN50 = *ON
     C                   WRITE     GL002100F1
     C                   EXFMT     GL002100F2
     C                   ENDIF
 
      ** Reset error indicators
     C                   MOVEA     '0000000000'  *IN(30)
     C                   MOVEA     '000000000'   *IN(40)
 
      ** Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGMQ        PZPgmQ
     C                   PARM      '*SAME'       PZRelQ
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEnquire - Enquiry processing                                *
      *                                                               *
      *****************************************************************
 
     C     SrEnquire     BEGSR
 
      ** Set indicators controlling screen and field attributes
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN51 = *ON
     C                   EVAL      *IN52 = *ON
     C                   EVAL      *IN53 = *ON
 
      ** Move file field values to screen for display
     C                   EXSR      SrFiletoScrn
 
      ** Display screen
     C                   EXSR      SrDisplay
     C                   MOVE      *BLANKS       WPrompt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInsert - Insert processing                                  *
      *                                                               *
      *****************************************************************
 
     C     SrInsert      BEGSR
 
      ** Set indicators controlling screen and field attributes
     C                   EVAL      *IN26 = *ON
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN51 = *OFF
     C                   EVAL      *IN52 = *OFF
     C                   EVAL      *IN53 = *OFF
 
     ** Process until user exits program (F3) or returns to previous
     ** screen (F12)
     C                   DOW       *INKC = *OFF AND
     C                             *INKL = *OFF
 
      ** Display screen
     C                   EXSR      SrDisplay
 
     C                   SELECT
 
      ** F3 Exit or F12 Previous screen
     C                   WHEN      *INKC = *ON OR
     C                             *INKL = *ON
     C                   MOVE      *BLANKS       WScrnFld
 
      ** F5 Refresh
     C                   WHEN      *INKE = *ON
     C                   MOVE      *BLANKS       WDetail
 
      ** Process initial screen
     C                   OTHER
 
      ** Validate initial screen
     C                   EVAL      WCompleted = *ON
     C                   EXSR      SrValidate
 
      ** If no errors found, update file
     C                   IF        WError = *OFF AND
     C                             WCompleted = *ON
     C                   EXSR      SrWrite
     C                   EVAL      *INKL = *ON
     C                   ENDIF
     C                   ENDSL
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAmend - Amend processing                                    *
      *                                                               *
      *****************************************************************
 
     C     SrAmend       BEGSR
 
      ** Set indicators controlling screen and field attributes
     C                   EVAL      *IN26 = *ON
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN51 = *ON
     C                   EVAL      *IN53 = *OFF
 
      ** Effective Yield is only amendable if amortisation method is
      ** non-linear
     C                   IF        A1AMMD = 'L'
     C                   EVAL      *IN52 = *ON
     C                   ELSE
     C                   EVAL      *IN52 = *OFF
     C                   ENDIF
 
      ** Move file field values to screen for display
     C                   EXSR      SrFiletoScrn
     C                   MOVE      WBakDtlB      WBakDtlA
 
     ** Process until user exits program (F3) or returns to previous
     ** screen (F12)
     C                   DOW       *INKC = *OFF AND
     C                             *INKL = *OFF
 
      ** Display screen
     C                   EXSR      SrDisplay
 
     C                   SELECT
 
      ** F3 Exit or F12 Previous screen
     C                   WHEN      *INKC = *ON OR
     C                             *INKL = *ON
     C                   MOVE      *BLANKS       WScrnFld
 
      ** F5 Refresh
     C                   WHEN      *INKE = *ON
     C                   MOVE      WBakDtlA      WBakDtlB
 
      ** Process initial screen
     C                   OTHER
 
      ** Validate initial screen
     C                   EVAL      WCompleted = *ON
     C                   EXSR      SrValidate
 
      ** If no errors found, update file
     C                   IF        WError = *OFF AND
     C                             WCompleted = *ON
     C                   EXSR      SrUpdate
     C                   EVAL      *INKL = *ON
     C                   ENDIF
     C                   ENDSL
     C                   ENDDO
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDelete - Delete processing                                  *
      *                                                               *
      *****************************************************************
 
     C     SrDelete      BEGSR
 
      ** Set indicators controlling screen and field attributes
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN27 = *ON
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN51 = *ON
     C                   EVAL      *IN52 = *ON
     C                   EVAL      *IN53 = *ON
 
      ** Move file field values to screen for display
     C                   EXSR      SrFiletoScrn
 
     ** Process until user exits program (F3) or returns to previous
     ** screen (F12)
     C                   DOW       *INKC = *OFF AND
     C                             *INKL = *OFF
 
      ** Display screen
     C                   EXSR      SrDisplay
 
     C                   SELECT
 
      ** F3 Exit or F12 Previous screen
     C                   WHEN      *INKC = *ON OR
     C                             *INKL = *ON
     C                   MOVE      *BLANKS       WScrnFld
 
      ** F10 Delete
     C                   WHEN      *INKJ = *ON
     C                   EXSR      SrUpdate
     C                   EVAL      *INKL = *ON
 
      ** Enter key pressed (ignore)
     C                   OTHER
 
     C                   ENDSL
     C                   ENDDO
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWrite - Write details to GLAMRTPD                           *
      *                                                               *
      *****************************************************************
 
     C     SrWrite       BEGSR
 
      ** Record ID, Transaction Reference, Branch, Currency, Profit Centre
     C                   EVAL      A1RECI = 'D'
     C                   MOVE      #1AREF        A1AREF
     C                   EVAL      A1BRCA = #2BRCA
     C                   EVAL      A1CCY  = #2CCY
     C                   EVAL      A1PRFC = #2PRFC
 
      ** Start date, Maturity Date
     C                   EVAL      A1STDT = WkSTDT
     C                   EVAL      A1MDAT = WkMDAT
 
      ** Discount Amount, Par Amount
     C                   EVAL      A1DSAM = WDscAmount
     C                   EVAL      A1PRAM = WParAmount
 
      ** Effective Yield, Calculation Basis, Amortisation Method
     C                   EVAL      A1EFYL = WEffYield
     C                   EVAL      A1CLBS = #2CLBS
     C                   EVAL      A1AMMD = #2AMMD
 
      ** Debit Details
     C                   MOVE      #2DRCO        A1DRCO
     C                   MOVE      #2DRSQ        A1DRSQ
     C                   MOVE      #2DRCN        A1DRCN
 
      ** Credit Details
     C                   MOVE      #2CRCO        A1CRCO
     C                   MOVE      #2CRSQ        A1CRSQ
     C                   MOVE      #2CRCN        A1CRCN
 
      ** Posting Narrative, Amount amortisized posted to date, Amount
      ** unamortisized to date, Transaction number of last update,
      ** Original entry date, Last change date, Last change type
     C                   EVAL      A1NARR = #2NARR
     C                   EVAL      A1AATD = *ZERO
     C                   EVAL      A1UNAM = WParAmount - WDscAmount
     C                   EVAL      A1TNLU = *ZERO
     C                   EVAL      A1ORED = BJRDNB
     C                   EVAL      A1LCD  = BJRDNB
     C                   EVAL      A1CHTP = #1ACTN
 
     C                   WRITE     GLAMRTD0
 
      **  Update the trailer file
 
     C     1             SETLL     GLAMRZPD
     C                   READ      GLAMRZPD                               90
 
      ** DATABASE ERROR
 
     C     *IN90         IFEQ      '1'
     C                   EVAL      DBFILE = 'GLAMRZPD'
     C                   EVAL      DBASE = 2
     C                   EXSR      *PSSR
     C                   END
 
     C                   EVAL      INNO = INNO + 1
     C                   EVAL      NORE = NORE + 1
 
     C                   MOVE      A1DSAM        ZZAMT
     C                   EVAL      ZZTOTI = HRWN
     C                   EVAL      ZZTOTD = HRDN
     C                   EXSR      SrGLZAdd
     C                   EVAL      HRWN = ZZTOTI
     C                   EVAL      HRDN = ZZTOTD
 
     C                   MOVE      A1DSAM        ZZAMT
     C                   EVAL      ZZTOTI = INSH
     C                   EVAL      ZZTOTD = INSD
     C                   EXSR      SrGLZAdd
     C                   EVAL      INSH = ZZTOTI
     C                   EVAL      INSD = ZZTOTD
 
     C                   UPDATE    GLAMRZD0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUpdate - Amend/Update details in GLAMRTPD                   *
      *                                                               *
      *****************************************************************
 
     C     SrUpdate      BEGSR
 
      ** Set to record to be updated
     C                   MOVE      #1AREF        WReference
     C     WReference    CHAIN     GLAMRTL0
 
      ** Delete
     C                   IF        #1ACTN = 'D'
     C                   EVAL      A1RECI = 'C'
     C                   EVAL      A1LCD  = BJRDNB
     C                   EVAL      A1CHTP = #1ACTN
     C                   ENDIF
 
      ** Amend
     C                   IF        #1ACTN = 'A'
     C                   EVAL      A1MDAT = WkMDAT
     C                   EVAL      WZDsAm = A1DSAM
     C                   EVAL      A1DSAM = WDscAmount
     C                   EVAL      A1PRAM = WParAmount
     C                   EVAL      A1UNAM = WParAmount - WDscAmount
     C                   EVAL      A1EFYL = WEffYield
     C                   EVAL      A1TNLU = *ZERO
     C                   EVAL      A1LCD  = BJRDNB
     C                   EVAL      A1CHTP = #1ACTN
     C                   ENDIF
 
     C                   UPDATE    GLAMRTD0
 
      **  Update the trailer file
 
     C     1             SETLL     GLAMRZPD
     C                   READ      GLAMRZPD                               90
 
      ** DATABASE ERROR
 
     C     *IN90         IFEQ      '1'
     C                   EVAL      DBFILE = 'GLAMRZPD'
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   END
 
     C                   IF        #1ACTN = 'A'
     C                   EVAL      AMDN = AMDN + 1
 
     C                   EVAL      WZAmt = A1DSAM - WZDsAm
 
     C                   MOVE      WZAmt         ZZAMT
     C                   EVAL      ZZTOTI = HRWN
     C                   EVAL      ZZTOTD = HRDN
     C                   EXSR      SrGLZAdd
     C                   EVAL      HRWN = ZZTOTI
     C                   EVAL      HRDN = ZZTOTD
 
     C                   MOVE      WZAmt         ZZAMT
     C                   EVAL      ZZTOTI = AMDH
     C                   EVAL      ZZTOTD = AMDD
     C                   EXSR      SrGLZAdd
     C                   EVAL      AMDH = ZZTOTI
     C                   EVAL      AMDD = ZZTOTD
 
     C                   ENDIF
 
     C                   IF        #1ACTN = 'D'
     C                   EVAL      DELN = DELN + 1
     C                   EVAL      NORE = NORE - 1
 
     C                   MOVE      A1DSAM        ZZAMT
     C                   EVAL      ZZTOTI = HRWN
     C                   EVAL      ZZTOTD = HRDN
     C                   EXSR      SrGLZSub
     C                   EVAL      HRWN = ZZTOTI
     C                   EVAL      HRDN = ZZTOTD
 
     C                   MOVE      A1DSAM        ZZAMT
     C                   EVAL      ZZTOTI = DLEH
     C                   EVAL      ZZTOTD = DLED
     C                   EXSR      SrGLZAdd
     C                   EVAL      DLEH = ZZTOTI
     C                   EVAL      DLED = ZZTOTD
 
     C                   ENDIF
 
     C                   UPDATE    GLAMRZD0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFiletoScrn - Format and move file field values to screen    *
      *                                                               *
      *****************************************************************
 
     C     SrFiletoScrn  BEGSR
 
      ** Branch, Currency and Profit Centre
     C                   EVAL      #2BRCA = A1BRCA
     C                   EVAL      #2CCY  = A1CCY
     C                   EVAL      #2PRFC = A1PRFC
 
      ** Start Date
     C                   EVAL      PDaynoIn = A1STDT
     C                   EXSR      SrZDate2
     C                   MOVE      PDateOut      #2STDT
 
      ** Maturity Date
     C                   EVAL      PDaynoIn = A1MDAT
     C                   EXSR      SrZDate2
     C                   MOVE      PDateOut      #2MDAT
 
      ** Get the currency decimal places
     C                   EVAL      PCcy = #2CCY
     C                   EXSR      SrCurrency
 
      ** Discount Amount
     C                   Z-ADD     A6NBDP        PZDec
     C                   MOVE      *BLANKS       PZField
     C                   MOVE      A1DSAM        PZField
     C                   EXSR      SrZEdit
     C                   MOVE      PZField       #2DSAM
 
      ** Par Amount
     C                   MOVE      *BLANKS       PZField
     C                   MOVE      A1PRAM        PZField
     C                   EXSR      SrZEdit
     C                   MOVE      PZField       #2PRAM
 
      ** Effective Yield
     C                   Z-ADD     12            PZDec
     C                   MOVE      *BLANKS       PZField
 
     C                   IF        A1EFYL < 0
     C                   EVAL      WEfyl = A1EFYL * (-1)
 
     C                   MOVE      WEfyl         PZField
     C                   EXSR      SrZEdit
     C                   MOVEL     PZField       PZField2
     C                   MOVEL     PZField2      WEfyl2
     C     WEfyl2        CAT       '-'           #2EFYL
 
     C                   ELSE
 
     C                   MOVE      A1EFYL        PZField
     C                   EXSR      SrZEdit
     C                   MOVE      PZField       #2EFYL
 
     C                   ENDIF
 
      ** Calculation Basis and Amortisation Method
     C                   EVAL      #2CLBS = A1CLBS
     C                   EVAL      #2AMMD = A1AMMD
 
      ** Debut and Credit account details
     C                   MOVE      A1DRCO        #2DRCO
     C                   MOVE      A1DRSQ        #2DRSQ
     C                   MOVE      A1DRCN        #2DRCN
     C                   MOVE      A1CRCO        #2CRCO
     C                   MOVE      A1CRSQ        #2CRSQ
     C                   MOVE      A1CRCN        #2CRCN
 
      ** Posting Narrative
     C                   EVAL      #2NARR = A1NARR
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValidate - Process field validations                        *
      *                                                               *
      *****************************************************************
 
     C     SrValidate    BEGSR
 
      ** Initialise error flag
     C                   EVAL      WError = *OFF
 
      ** For initial screen, only validate reference and action code
     C                   IF        WInitScr = *ON
 
      ** Validate Action Code
     C                   EXSR      SrValActCde
 
      ** Validate Reference
     C                   IF        *IN31 = *OFF
     C                   EXSR      SrValAREF
     C                   ENDIF
 
     C                   ELSE
 
      ** For inserts, validate all detail fields. For amendments, only
      ** validate par amount, discount amount, and maturity date when
      ** linear method is used, while effective yield is also validated
      ** when the non-linear method is also used.
 
      ** Validate Branch Code
     C                   IF        #1ACTN = 'I'
     C                   EXSR      SrValBRCA
     C                   ENDIF
 
      ** Validate Currency Code
     C                   EXSR      SrValCCY
     C
 
     C                   IF        #1ACTN = 'I'
 
      ** Validate Debit Customer but send messages later to preserve
      ** correspondence of messages displayed to fields highlighted
     C                   EXSR      SrValDRCN
 
      ** Validate Profit Centre if debit customer is valid
     C                   IF        *IN44 = *OFF
     C                   EXSR      SrValPRFC
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Start Date
     C                   EXSR      SrValSTDT
 
      ** Validate Maturity Date
     C                   EXSR      SrValMDAT
 
      ** Process only if currency is valid
     C                   IF        *IN33 = *OFF
 
      ** Validate Discount Amount
     C                   EXSR      SrValDSAM
 
      ** Validate Par Amount
     C                   EXSR      SrValPRAM
 
     C                   ENDIF
 
      ** Validate Effective Yield
     C                   EXSR      SrValEFYL
 
      ** Validate Calculation Basis
     C                   EXSR      SrValCLBS
 
     C                   IF        #1ACTN = 'I'
 
      ** Validate Amortisation Method
     C                   EXSR      SrValAMMD
 
      ** Validate Debit Account Code
     C                   EXSR      SrValDRCO
 
      ** Validate Debit Account Sequence
     C                   EXSR      SrValDRSQ
 
      ** Send error message for Debit Customer previously validated
     C                   IF        *IN44 = *ON
     C                   EVAL      PZMsgID = WDRCNMsgID
     C                   EXSR      SrZasnms
     C                   ENDIF
 
      ** Validate Credit Account Code
     C                   EXSR      SrValCRCO
 
      ** Validate Credit Account Sequence
     C                   EXSR      SrValCRSQ
 
      ** Validate Credit Customer
     C                   EXSR      SrValCRCN
 
      ** Validate Posting Narrative
     C                   EXSR      SrValNARR
 
      ** Validate Full Account Key - Debit
     C                   EXSR      SrValDebitAC
 
      ** Validate Full Account Key - Credit
     C                   EXSR      SrValCreditAC
 
     C                   ENDIF
 
      ** If all fields are valid, check if approriate amortisation
      ** values are inputted and calculate for necessary values
     C                   IF        WError <> *ON
     C                   EXSR      SrValCalAmort
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValActCde - Validate Action Code                            *
      *                                                               *
      *****************************************************************
 
     C     SrValActCde   BEGSR
 
      ** Action code must be 'I', 'A', 'E' or 'D'
     C                   IF        #1ACTN <> 'I' AND
     C                             #1ACTN <> 'A' AND
     C                             #1ACTN <> 'E' AND
     C                             #1ACTN <> 'D'
     C                   EVAL      *IN31 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR0907'
     C                   EXSR      SrZasnms
     C                   ENDIF
 
      ** Check user authorization
     C                   IF        *IN31 = *OFF  AND
     C                             MultBrcInd <> 'Y'
     C                   MOVE      #1ACTN        PAction
     C                   CALL      'ZVACTU'
     C                   PARM                    PAction
     C                   PARM                    PError
 
     C                   IF        PError <> *ZERO
     C                   EVAL      *IN31 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1105'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValAREF - Validate Transaction Reference                    *
      *                                                               *
      *****************************************************************
 
     C     SrValAREF     BEGSR
 
      ** Transaction reference must not be blank
     C                   IF        #1AREF = *BLANK
     C                   EVAL      *IN30 = *ON
     C                   EVAL      PZMsgID = 'USR1100'
     C                   ELSE
 
      ** Must also be numeric
     C                   EVAL      WNumeric = %CHECK(Digits : #1AREF)
     C                   IF        WNumeric > 0
     C                   EVAL      *IN30 = *ON
     C                   EVAL      PZMsgID = 'USR1101'
     C                   ENDIF
 
      ** Must be between 000001 and 999998
     C                   IF        *IN30 = *OFF
     C                   MOVE      #1AREF        WNum6
     C                   IF        WNum6 < 1 OR
     C                             WNum6 > 999998
     C                   EVAL      *IN30 = *ON
     C                   EVAL      PZMsgID = 'USR1104'
     C                   ENDIF
     C                   ENDIF
 
      ** Must not be an existing live record for inserts
     C                   IF        *IN30 = *OFF
     C                   MOVE      #1AREF        WReference
     C     WReference    CHAIN     GLAMRTL1
     C                   IF        %FOUND(GLAMRTL1) AND
     C                             A1RECI = 'D'     AND
     C                             #1ACTN = 'I'
     C                   EVAL      *IN30 = *ON
     C                   EVAL      PZMsgID = 'USR1103'
     C                   ENDIF
 
     C                   IF        %FOUND(GLAMRTL1) AND
     C                             A1RECI = 'C'     AND
     C                             #1ACTN = 'I'
     C                   EVAL      *IN30 = *ON
     C                   EVAL      PZMsgID = 'USR1144'
     C                   ENDIF
 
      ** Must be an existing live record for amends, deletes, and
      ** enquiries
     C                   IF        #1ACTN = 'D' OR
     C                             #1ACTN = 'A'
     C                   IF        NOT %FOUND(GLAMRTL1) OR
     C                             %FOUND(GLAMRTL1) AND
     C                             A1RECI = 'C'OR
     C                             %FOUND(GLAMRTL1) AND
     C                             A1RECI = '*'
     C                   EVAL      *IN30 = *ON
     C                   EVAL      PZMsgID = 'USR1102'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #1ACTN = 'E'
     C                   IF        %FOUND(GLAMRTL1) AND
     C                             A1RECI = 'C' OR
     C                             %FOUND(GLAMRTL1) AND
     C                             A1RECI = '*'
     C                   EVAL      PZMsgID = 'USR1143'
     C                   EVAL      *IN30 = *ON
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Send error message if present
     C                   IF        *IN30 = *ON
     C                   EXSR      SrZasnms
 
     C                   IF        *IN49 <> *ON
     C                   EVAL      WError = *ON
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValBRCA - Validate Branch Code                              *
      *                                                               *
      *****************************************************************
 
     C     SrValBRCA     BEGSR
 
      ** If blank, set to default branch obtained from data area ZMUSER
     C                   IF        #2BRCA= *BLANKS
     C                   EVAL      #2BRCA = DefBrch
     C                   ELSE
 
      ** Access Branch details
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      #2BRCA        PBranch
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Error if inputed branch is not found
     C                   IF        PRetCode <> *BLANK
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'CSF9133'
     C                   EXSR      SrZasnms
     C                   ELSE
     C                   EVAL      #2BRCA = A8BRCD
     C                   ENDIF
 
      ** Determine if user is authorised
     C                   IF        *IN32 = *OFF AND
     C                             MultBrcInd = 'Y'
 
     C                   MOVE      #1ACTN        PAction
     C                   MOVE      #2BRCA        PBranch
     C                   CALL      'ZVACTBU'
     C                   PARM                    PAction
     C                   PARM                    PBranch
     C                   PARM                    PError
 
     C                   IF        PError <> *ZERO
     C                   IF        PError = 1
     C                   EVAL      PZMsgID = 'USR1106'
     C                   ELSE
     C                   EVAL      PZMsgID = 'USR1107'
     C                   ENDIF
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WError = *ON
     C                   EXSR      SrZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValCCY - Validate currenct code                             *
      *                                                               *
      *****************************************************************
 
     C     SrValCCY      BEGSR
 
      ** Currency is mandatory
     C                   IF        #2CCY = *BLANKS
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'GLX0123'
     C                   EXSR      SrZasnms
     C                   ELSE
 
      ** Get the currency decimal places
     C                   EVAL      PCcy = #2CCY
     C                   EXSR      SrCurrency
 
      ** Database error
     C                   IF        PRetCode <> *BLANK
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'CSF9038'
     C                   EXSR      SrZasnms
     C                   ELSE
     C                   MOVE      A6CYCD        #2CCY
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValPRFC - Validate Profit Centre                            *
      *                                                               *
      *****************************************************************
 
     C     SrValPRFC     BEGSR
 
      ** Must be an existing profit centre
     C                   IF        #2PRFC <> *BLANK
     C                   CALL      'AOPRFCR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY    '    POption
     C                   PARM      #2PRFC        PProfCtr
     C     SDPRFC        PARM      SDPRFC        DSFDY
 
     C                   IF        PRetCode <> *BLANK
     C                   EVAL      *IN34 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'CSF9136'
     C                   EXSR      SrZasnms
     C                   ELSE
     C                   EVAL      #2PRFC = DSPCCD
     C                   ENDIF
     C                   ELSE
 
      ** Set to default if blank
     C                   CALL      'AOPRFMR0'
     C                   PARM      *BLANKS       PReturnCd
     C                   PARM      *BLANKS       PBookCd
     C                   PARM      *BLANKS       PTransType
     C                   PARM      *BLANKS       PSubType
     C                   PARM      #2BRCA        PBranchCd
     C                   PARM      *BLANKS       PDeptCd
     C                   PARM      PSUser        PUser
     C                   PARM                    PAcctOfcrCd
     C                   PARM                    PCustNum
     C                   PARM      *BLANKS       PPrftCntrCd
 
     C                   EVAL      #2PRFC = PPrftCntrCd
     C                   IF        PReturnCd = '2'
     C                   EVAL      *IN34 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'CSF9136'
     C                   EXSR      SrZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValSTDT - Validate Start Date                               *
      *                                                               *
      *****************************************************************
 
     C     SrValSTDT     BEGSR
 
      ** Start date is mandatory
     C                   IF        #2STDT = *BLANKS
     C                   EVAL      *IN35 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1108'
     C                   EXSR      SrZasnms
     C                   ELSE
 
      ** Validate date format
     C                   MOVE      #2STDT        PDateIn
     C                   EXSR      SrZDate1
     C                   IF        PDateError = 'Y'
     C                   EVAL      *IN35 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1109'
     C                   EXSR      SrZasnms
     C                   ELSE
     C                   Z-ADD     PDaynoOut     WkSTDT
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValMDAT - Validate Maturity Date                            *
      *                                                               *
      *****************************************************************
 
     C     SrValMDAT     BEGSR
 
      ** Start date is mandatory
     C                   IF        #2MDAT = *BLANKS
     C                   EVAL      *IN36 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1110'
     C                   EXSR      SrZasnms
     C                   ELSE
 
      ** Validate date format
     C                   MOVE      #2MDAT        PDateIn
     C                   EXSR      SrZDate1
     C                   IF        PDateError = 'Y'
     C                   EVAL      *IN36 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1111'
     C                   EXSR      SrZasnms
     C                   ELSE
 
      ** Maturity date must be equal or greater than start date
     C                   Z-ADD     PDaynoOut     WkMDAT
     C                   IF        WkMDAT < WkSTDT
     C                   EVAL      *IN36 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1112'
     C                   EXSR      SrZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValDSAM - Validate Discounted Amount                        *
      *                                                               *
      *****************************************************************
 
     C     SrValDSAM     BEGSR
 
      ** Amount must be valid
     C                   IF        #2DSAM <> *BLANKS
     C                   MOVE      *BLANKS       PZField
     C                   MOVEL     #2DSAM        PZField
     C                   Z-ADD     A6NBDP        PZDec
     C     13            SUB       PZDec         PZDig
     C                   EXSR      SrZAlign
 
     C                   IF        PZAlignOk <> 'Y'
     C                   EVAL      *IN37 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1132'
     C                   EXSR      SrZasnms
     C                   ELSE
 
      ** Move discount amount to save variable
     C                   MOVE      PZField       WDscAmount
 
      ** Format and move to corresponding screen field
     C                   EXSR      SrZEdit
     C                   MOVE      PZField       #2DSAM
 
      ** Discount amount must be greater than zero
     C                   EVAL      WKDiscAmt = WFld153
     C                   IF        WKDiscAmt <= *ZERO
     C                   EVAL      *IN37 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1133'
     C                   EXSR      SrZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValPRAM - Validate Par Amount                               *
      *                                                               *
      *****************************************************************
 
     C     SrValPRAM     BEGSR
 
      ** Amount must be valid
     C                   IF        #2PRAM <> *BLANKS
     C                   MOVE      *BLANKS       PZField
     C                   MOVEL     #2PRAM        PZField
     C                   Z-ADD     A6NBDP        PZDec
     C     13            SUB       PZDec         PZDig
     C                   EXSR      SrZAlign
 
     C                   IF        PZAlignOk <> 'Y'
     C                   EVAL      *IN38 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1134'
     C                   EXSR      SrZasnms
     C                   ELSE
 
      ** Move par amount to save variable
     C                   MOVE      PZField       WParAmount
 
      ** Format and move to corresponding screen field
     C                   EVAL      WKParAmnt = WFld153
     C                   EXSR      SrZEdit
     C                   MOVE      PZField       #2PRAM
 
      ** Par amount must be greater than zero
     C                   IF        WKParAmnt <= *ZERO
     C                   EVAL      *IN38 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1135'
     C                   EXSR      SrZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValEFYL - Validate Effective Yield                          *
      *                                                               *
      *****************************************************************
 
     C     SrValEFYL     BEGSR
 
      ** Must be valid yield
     C                   IF        #2EFYL <> *BLANKS
     C                   MOVE      *BLANKS       PZFld17
     C                   MOVEL     #2EFYL        PZFld17
     C                   Z-ADD     12            PZDec
     C                   Z-ADD     2             PZDig
     C                   EXSR      SrZASign
 
     C                   IF        PZASignOk <> 'Y'
     C                   EVAL      *IN39 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1136'
     C                   EXSR      SrZasnms
     C                   ELSE
 
      ** Move discount amount to file field, to work variable for
      ** calculation, and format and move for screen field
     C                   MOVE      PZOut15       A1EFYL
     C                   MOVE      PZOut15       WEffYield
     C                   MOVE      PZOut15       PZField
     C                   EXSR      SrZEdit
 
     C                   IF        PZFSign = '-' AND
     C                             WEffYield <> *ZERO
     C                   MOVE      PZField       WChar15
     C     WChar15       CAT       '-'           #2EFYL
     C                   Z-SUB     A1EFYL        A1EFYL
     C                   Z-SUB     WEffYield     WEffYield
     C                   ELSE
     C                   MOVE      PZField       #2EFYL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValCLBS - Validate Calculation Basis                        *
      *                                                               *
      *****************************************************************
 
     C     SrValCLBS     BEGSR
 
      ** Calculation basis is mandatory
     C                   IF        #2CLBS = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1113'
     C                   EXSR      SrZasnms
     C                   ELSE
 
      ** Valid values are only 1, 2, 3, 4, 5 and 6
     C                   IF        #2CLBS <> '1' AND
     C                             #2CLBS <> '2' AND
     C                             #2CLBS <> '3' AND
     C                             #2CLBS <> '4' AND
     C                             #2CLBS <> '5' AND
     C                             #2CLBS <> '6'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1114'
     C                   EXSR      SrZasnms
     C                   ELSE
 
      ** Set length of a year based on calculation basis
     C                   SELECT
     C                   WHEN      #2CLBS = '2' OR
     C                             #2CLBS = '3' OR
     C                             #2CLBS = '5'
     C                   Z-ADD     360           WDaysInYear
     C                   WHEN      #2CLBS = '1' OR
     C                             #2CLBS = '4'
     C                   Z-ADD     365           WDaysInYear
     C                   WHEN      #2CLBS = '6'
     C                   Z-ADD     366           WDaysInYear
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValAMMD - Validate Amortisation Method                      *
      *                                                               *
      *****************************************************************
 
     C     SrValAMMD     BEGSR
 
      ** Amortisation method is mandatory
     C                   IF        #2AMMD = *BLANKS
     C                   EVAL      *IN41 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1115'
     C                   EXSR      SrZasnms
     C                   ELSE
 
      ** Valid values are only 'N' and 'L'
     C                   IF        #2AMMD <> 'N' AND
     C                             #2AMMD <> 'L'
     C                   EVAL      *IN41 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1116'
     C                   EXSR      SrZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValDRCO - Validate Debit Account Code                       *
      *                                                               *
      *****************************************************************
 
     C     SrValDRCO     BEGSR
 
      ** Debit account code is mandatory
     C                   IF        #2DRCO = *BLANK
     C                   EVAL      *IN42 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1117'
     C                   EXSR      SrZasnms
     C                   ELSE
 
      ** Must exist in file
     C                   EVAL      PAcctCode = #2DRCO
     C                   EXSR      SrAcctCode
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      *IN42 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1118'
     C                   EXSR      SrZasnms
     C                   ELSE
     C                   EVAL      #2DRCO = A5ACCD
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValDRSQ - Validate Debit Account Sequence                   *
      *                                                               *
      *****************************************************************
 
     C     SrValDRSQ     BEGSR
 
      ** Debit account sequence is mandatory
     C                   IF        #2DRSQ = *BLANK
     C                   EVAL      *IN43 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1121'
     C                   EXSR      SrZasnms
     C                   ELSE
 
      ** Must be numeric
     C                   EVAL      WNumeric = %CHECK(Digits : #2DRSQ)
     C                   IF        WNumeric > 0
     C                   EVAL      *IN43 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1122'
     C                   EXSR      SrZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValDRCN - Validate Debit Customer                           *
      *                                                               *
      *****************************************************************
 
     C     SrValDRCN     BEGSR
 
      ** Debit Customer is mandatory
     C                   EVAL      WDRCNMsgID = *BLANKS
     C                   IF        #2DRCN = *BLANKS
     C                   EVAL      *IN44 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      WDRCNMsgID = 'USR1125'
     C                   ELSE
 
      ** Must exist in file
     C                   EVAL      PCustomer = #2DRCN
     C                   EXSR      SrCustomer
     C                   IF        PRetCode <> *BLANKS OR
     C                             BBDTDL <> *ZERO
     C                   EVAL      *IN44 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      WDRCNMsgID = 'USR1126'
     C                   ELSE
     C                   EVAL      #2DRCN = BBCUST
     C                   ENDIF
     C                   ENDIF
 
      ** If debit code is valid, set details needed for profit code validation
     C                   IF        *IN44 = *OFF
     C                   EVAL      PCustNum = BBCUST
     C                   EVAL      PAcctOfcrCd = BBACOC
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValCRCO - Validate Credit Account Code                      *
      *                                                               *
      *****************************************************************
 
     C     SrValCRCO     BEGSR
 
      ** Credit account code is mandatory
     C                   IF        #2CRCO = *BLANK
     C                   EVAL      *IN45 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1119'
     C                   EXSR      SrZasnms
     C                   ELSE
 
      ** Must exist in file
     C                   EVAL      PAcctCode = #2CRCO
     C                   EXSR      SrAcctCode
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      *IN45 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1120'
     C                   EXSR      SrZasnms
     C                   ELSE
     C                   EVAL      #2CRCO = A5ACCD
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValCRSQ - Validate Credit Account Sequence                  *
      *                                                               *
      *****************************************************************
 
     C     SrValCRSQ     BEGSR
 
      ** Credit account sequence is mandatory
     C                   IF        #2CRSQ = *BLANK
     C                   EVAL      *IN46 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1123'
     C                   EXSR      SrZasnms
     C                   ELSE
 
      ** Must be numeric
     C                   EVAL      WNumeric = %CHECK(Digits : #2CRSQ)
     C                   IF        WNumeric > 0
     C                   EVAL      *IN46 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1124'
     C                   EXSR      SrZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValCRCN - Validate Credit Customer                          *
      *                                                               *
      *****************************************************************
 
     C     SrValCRCN     BEGSR
 
      ** Credit Customer is mandatory
     C                   IF        #2CRCN = *BLANK
     C                   EVAL      *IN47 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1127'
     C                   EXSR      SrZasnms
     C                   ELSE
 
      ** Must exist in file
     C                   EVAL      PCustomer = #2CRCN
     C                   EXSR      SrCustomer
     C                   IF        PRetCode <> *BLANKS OR
     C                             BBDTDL <> *ZERO
     C                   EVAL      *IN47 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1128'
     C                   EXSR      SrZasnms
     C                   ELSE
     C                   EVAL      #2CRCN = BBCUST
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValNARR - Validate Narrative                                *
      *                                                               *
      *****************************************************************
 
     C     SrValNARR     BEGSR
 
      ** Narrative is mandatory
     C                   IF        #2NARR = *BLANKS
     C                   EVAL      *IN48 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'GLX0055'
     C                   EXSR      SrZasnms
     C                   ELSE
 
      ** If only first 2 characters are entered, it must be a valid
      ** narrative code
     C                   MOVE      #2NARR        WNarr28
     C                   IF        WNarr28 = *BLANKS
     C                   CALL      'AONARRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      #2NARR        PNarrCode
     C     SDNARR        PARM      SDNARR        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      *IN48 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1129'
     C                   EXSR      SrZasnms
     C                   ELSE
     C                   EVAL      #2NARR = ALDON
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValDebitAC - Validate Debit Account                         *
      *                                                               *
      *****************************************************************
 
     C     SrValDebitAC  BEGSR
 
     C                   IF        *IN32 = *OFF AND
     C                             *IN33 = *OFF AND
     C                             *IN42 = *OFF AND
     C                             *IN43 = *OFF AND
     C                             *IN44 = *OFF
 
     C                   MOVE      #2DRCN        KCust
     C                   MOVE      #2CCY         KCcy
     C                   MOVE      #2DRCO        KAcct
     C                   MOVE      #2DRSQ        KSeq
     C                   MOVE      #2BRCA        KBrca
 
     C                   EXSR      SrFullAcct
     C                   IF        WFullAcctErr = *ON
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN42 = *ON
     C                   EVAL      *IN43 = *ON
     C                   EVAL      *IN44 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1130'
     C                   EXSR      SrZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValCreditAC - Validate Credit Account                       *
      *                                                               *
      *****************************************************************
 
     C     SrValCreditAC BEGSR
 
     C                   IF        *IN32 = *OFF AND
     C                             *IN33 = *OFF AND
     C                             *IN45 = *OFF AND
     C                             *IN46 = *OFF AND
     C                             *IN47 = *OFF
 
     C                   MOVE      #2CRCN        KCust
     C                   MOVE      #2CCY         KCcy
     C                   MOVE      #2CRCO        KAcct
     C                   MOVE      #2CRSQ        KSeq
     C                   MOVE      #2BRCA        KBrca
 
     C                   EXSR      SrFullAcct
     C                   IF        WFullAcctErr = *ON
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN45 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EVAL      *IN47 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1131'
     C                   EXSR      SrZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCustomer - Access Customer details                          *
      *                                                               *
      *****************************************************************
 
     C     SrCustomer    BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCustomer
     C                   PARM                    PKeyStat
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAcctCode - Access Account code details                      *
      *                                                               *
      *****************************************************************
 
     C     SrAcctCode    BEGSR
 
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PAcctCode
     C*****SDACOD        PARM      SDACOD        DSFDY                                        CAS011
     C     SDACOD        PARM      SDACOD        DSSDY                                        CAS011
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCurrency - Access Currency details                          *
      *                                                               *
      *****************************************************************
 
     C     SrCurrency    BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFullAcct - Validate Full Account Key                        *
      *                                                               *
      *****************************************************************
 
     C     SrFullAcct    BEGSR
 
     C                   EVAL      WFullAcctErr = *OFF
     C     KFullAcct     CHAIN     ACCNT
     C                   IF        NOT %FOUND(ACCNT)
     C                   EVAL      WFullAcctErr = *ON
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValCalAmort - Validate if approriate amortisation values    *
      * are inputted then calculate for other values as necessary     *
      *                                                               *
      *****************************************************************
 
     C     SrValCalAmort BEGSR
 
      ** Compute for number of years to be used in calculations
     C                   EXSR      SRINTDY
     C                   EVAL(R)   WNoOfYears = PINTDY / WDaysInYear
 
     C                   SELECT
 
      ** If Linear method is used, Par Amount is mandatory
     C                   WHEN      #2PRAM = *BLANK AND
     C                             #2AMMD = 'L'
     C                   EVAL      *IN38 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1137'
     C                   EXSR      SrZasnms
 
      ** Error if Discount Amount, Par Amount and Effective Yield
      ** are all blanks
     C                   WHEN      #2DSAM = *BLANK AND
     C                             #2PRAM = *BLANK AND
     C                             #2EFYL = *BLANK
     C                   EVAL      *IN37 = *ON
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN39 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1138'
     C                   EXSR      SrZasnms
 
      ** Effective Yield must be inputted to calculate for discount
      ** amount
     C                   WHEN      #2DSAM = *BLANK AND
     C                             #2PRAM <> *BLANK AND
     C                             #2EFYL = *BLANK
     C                   EVAL      *IN39 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1139'
     C                   EXSR      SrZasnms
 
      ** Effective Yield must be inputted to calculate for par
      ** amount
     C                   WHEN      #2DSAM <> *BLANK AND
     C                             #2PRAM = *BLANK AND
     C                             #2EFYL = *BLANK
     C                   EVAL      *IN39 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1140'
     C                   EXSR      SrZasnms
 
      ** Either discount amount or par amount must be inputted
      ** to be able to calculate for the other
     C                   WHEN      #2DSAM = *BLANK AND
     C                             #2PRAM = *BLANK AND
     C                             #2EFYL <> *BLANK
     C                   EVAL      *IN37 = *ON
     C                   EVAL      *IN38 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      PZMsgID = 'USR1141'
     C                   EXSR      SrZasnms
 
      ** Calculate for effective yield if discount amount and par
      ** amount are inputted
     C                   WHEN      #2DSAM <> *BLANK AND
     C                             #2PRAM <> *BLANK AND
     C                             #2EFYL = *BLANK
     C                   EXSR      SrCalcEFYL
     C                   EVAL      WCompleted = *OFF
 
      ** Calculate for par amount if discount amount and
      ** effective yield are inputted. Set redisplay flag on.
     C                   WHEN      #2DSAM <> *BLANK AND
     C                             #2PRAM = *BLANK AND
     C                             #2EFYL <> *BLANK
     C                   EXSR      SrCalcPRAM
     C                   EVAL      WCompleted = *OFF
 
      ** Calculate for discount amount if par amount and
      ** effective yield are inputted. Set redisplay flag on.
     C                   WHEN      #2DSAM = *BLANK AND
     C                             #2PRAM <> *BLANK AND
     C                             #2EFYL <> *BLANK
     C                   EXSR      SrCalcDSAM
     C                   EVAL      WCompleted = *OFF
 
      ** Validate inputted effective yield if discount amount, par
      ** amount and effective yield are all inputted.
     C                   WHEN      #2DSAM <> *BLANK AND
     C                             #2PRAM <> *BLANK AND
     C                             #2EFYL <> *BLANK
     C                   EXSR      SrCalcEFYL
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCalcDSAM - Calculate Discounted Amount                      *
      *                                                               *
      *****************************************************************
 
     C     SrCalcDSAM    BEGSR
 
      ** For Linear method, use:
      ** D = P / [ 1 + r * n ]
     C                   IF        #2AMMD = 'L'
     C**********         EVAL(R)   WKDiscAmt = WKParAmnt / (1 +  (WEffYield                   252091
     C**********                   /100)* WNoOfYears)                                         252091
     C                   EVAL(R)   WKDiscAmt = WKParAmnt / (1 +  (WEffYield                   252091
     C                             /100)/ WNoOfYears)                                         252091
 
      ** For Non-linear method, use:
      ** D = P / ( 1 + r ) ^ n
     C                   ELSE
     C                   EVAL(R)   WKDiscAmt = WKParAmnt / ((1 + (WEffYield
     C                             /100)) ** WNoOfYears)
     C                   ENDIF
 
      ** Move amount to working field with correct decimal
     C                   MOVE      *BLANKS       PZField
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL(R)   WFld130 = WKDiscAmt
     C                   MOVE      WFld130       PZField
     C                   WHEN      A6NBDP = 1
     C                   EVAL(R)   WFld131 = WKDiscAmt
     C                   MOVE      WFld131       PZField
     C                   WHEN      A6NBDP = 2
     C                   EVAL(R)   WFld132 = WKDiscAmt
     C                   MOVE      WFld132       PZField
     C                   WHEN      A6NBDP = 3
     C                   EVAL(R)   WFld133 = WKDiscAmt
     C                   MOVE      WFld133       PZField
     C                   ENDSL
     C                   EVAL      PZDec = A6NBDP
     C                   EXSR      SrZEdit
     C                   MOVE      PZField       #2DSAM
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCalcPRAM - Calculate Par Amount                             *
      *                                                               *
      *****************************************************************
 
     C     SrCalcPRAM    BEGSR
 
      ** For Linear method, use:
      ** P = D * (1 + r) ^ n
     C                   IF        #2AMMD = 'N'
     C                   EVAL(R)   WKParAmnt = WKDiscAmt * ((1 +  (WEffYield
     C                             /100))** WNoOfYears)
 
      ** Move amount to working field with correct decimal
     C                   MOVE      *BLANKS       PZField
     C                   SELECT
     C                   WHEN      A6NBDP = 0
     C                   EVAL(R)   WFld130 = WKParAmnt
     C                   MOVE      WFld130       PZField
     C                   WHEN      A6NBDP = 1
     C                   EVAL(R)   WFld131 = WKParAmnt
     C                   MOVE      WFld131       PZField
     C                   WHEN      A6NBDP = 2
     C                   EVAL(R)   WFld132 = WKParAmnt
     C                   MOVE      WFld132       PZField
     C                   WHEN      A6NBDP = 3
     C                   EVAL(R)   WFld133 = WKParAmnt
     C                   MOVE      WFld133       PZField
     C                   ENDSL
     C                   EVAL      PZDec = A6NBDP
     C                   EXSR      SrZEdit
     C                   MOVE      PZField       #2PRAM
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCalcEFYL - Calculate Effective Yield                        *
      *                                                               *
      *****************************************************************
 
     C     SrCalcEFYL    BEGSR
 
      ** For Linear method, use:
      ***r*=*((1-(P/D))***((No.*days*in*year***100)/No.*Days*to*Maturity)                  BUG12598
      ** r = ((P/D)-1) * (No. days in year * 100)/Maturity - Start date                    BUG12598
     C                   EXSR      SRINTDY
 
     C**********         IF        #2AMMD = 'L'                                             BUG12598
     C**********         EVAL(R)   WCalcEFYL = ((WKParAmnt/WKDiscAmt)-1) *                  BUG12598
     C**********                   (PINTDY/WDaysInYear) * 100                               BUG12598
     C                   IF        #2AMMD = 'L'                                             BUG12598
     C                   EVAL(R)   WCalcEFYL = ((WKParAmnt/WKDiscAmt)-1) *                  BUG12598
     C                             (WDaysInYear/PINTDY) * 100                               BUG12598
 
      ** For Non-linear method, use:
      ** r = [ (P/D) ^ (1/n) ] - 1
     C                   ELSE
     C                   EVAL(RH)  WCalcEFYL = (((WKParAmnt/WKDiscAmt) **
     C                             (1/WNoOfYears)) - 1) * 100
     C                   ENDIF
 
      ** If calculated yield is negative, flag for negative and use the
      ** unsigned value for string formatting
     C                   IF        WCalcEFYL < 0
     C                   EVAL      WAbsEFYL = WCalcEFYL * (-1)
     C                   EVAL      WNegative = *ON
     C                   ELSE
     C                   EVAL      WAbsEFYL = WCalcEFYL
     C                   EVAL      WNegative = *OFF
     C                   ENDIF
 
     C                   MOVE      *BLANKS       PZField
     C                   MOVE      WAbsEFYL      PZField
     C                   EVAL      PZDec = 12
     C                   EXSR      SrZEdit
 
      ** If effective yield is blank, move calculated value to screen field
      ** or when amending and amortisation method is linear, override former
      ** value with the newly calculated one
     C                   IF        #2EFYL = *BLANK OR
     C                             #2EFYL <> *BLANK AND
     C                             *IN52 = *ON
     C                   EVAL      WChar15 = *BLANKS
     C                   IF        WCalcEFYL < 100                                          BUG10841
     C                   IF        WNegative = *ON AND
     C                             WAbsEFYL <> *ZERO
     C                   MOVE      PZField       WChar15
     C     WChar15       CAT       '-'           #2EFYL
     C                   ELSE
     C                   MOVE      PZField       #2EFYL
     C                   ENDIF
 
      ** If screen value is not the same as the calculated one, set completed
      ** flag off to redisplay screen
     C                   IF        WEffYield <> WCalcEFYL
     C**********         EVAL      WEffYield = WCalcEFYL                                    BUG10841
     C                   MOVE      WCalcEFYL     WEffYield                                  BUG10841
     C                   EVAL      WCompleted = *OFF
     C                   ENDIF
     C                   ENDIF                                                              BUG10841
 
     C                   ELSE
 
      ** Else if blank and value doesn't match calculated yield, send error
      ** message 'System calculated effective yield is XX.XXXXXXXXXXXX'
 
      ** Get the upperbound and lowerbound values allowed
 
     C                   EVAL      WEffYldDif = WEffYield * 0.01
     C                   EVAL      WEffYieldU = WEffYield + WEffYldDif
     C                   EVAL      WEffYieldL = WEffYield - WEffYldDif
 
      ** If Calculated Effective Rate is negative
 
     C                   IF        WCalcEFYL < 0
 
     C                   IF        WCalcEFYL < WEffYieldU OR
     C                             WCalcEFYL > WEffYieldL
 
     C                   EVAL      *IN39 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      WString1 = PZField
     C                   EVAL      PZMsgID = 'USR1142'
     C                   EXSR      SrZasnms
     C                   ENDIF
 
     C                   ELSE
 
      ** If Calculated Effective Rate is positive
 
     C                   IF        WCalcEFYL > WEffYieldU OR
     C                             WCalcEFYL < WEffYieldL
 
     C                   EVAL      *IN39 = *ON
     C                   EVAL      WError = *ON
     C                   EVAL      WString1 = PZField
     C                   EVAL      PZMsgID = 'USR1142'
     C                   EXSR      SrZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
                                                                                            BUG10841
     C                   IF        WCalcEFYL >= 100                                         BUG10841
     C                   EVAL      *IN37 = *ON                                              BUG10841
     C                   EVAL      *IN38 = *ON                                              BUG10841
     C                   EVAL      WError = *ON                                             BUG10841
     C                   EVAL      WString1 = PZField                                       BUG10841
     C                   EVAL      PZMsgID = 'USR1145'                                      BUG10841
     C                   EXSR      SrZasnms                                                 BUG10841
     C                   ENDIF                                                              BUG10841
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrZEdit - Format amount                                       *
      *                                                               *
      *****************************************************************
 
     C     SrZEdit       BEGSR
 
     C                   CALLB     'ZEDIT2'
     C                   PARM                    PZField
     C                   PARM                    PZDec
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrZDate1 - Validate & convert date to a day number            *
      *                                                               *
      *****************************************************************
 
     C     SrZDate1      BEGSR
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDateIn
     C                   PARM      *ZERO         PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    PDateError
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrZDate2 - Convert a day number to date format                *
      *                                                               *
      *****************************************************************
 
     C     SrZDate2      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDaynoIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PDateOut
     C                   PARM                    PADateOut
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrZAlign - Validate and align amounts                         *
      *                                                               *
      *****************************************************************
 
     C     SrZAlign      BEGSR
 
     C                   CALLB     'ZALIGN2'
     C                   PARM      'Y'           PZAlignOk
     C                   PARM                    PZField
     C                   PARM                    PZDec
     C                   PARM                    PZDig
 
      ** Move validated amount to working field with correct decimal
     C                   SELECT
     C                   WHEN      PZDec = 0
     C                   MOVE      PZField       WFld130
     C                   Z-ADD     WFld130       WFld153
     C                   WHEN      PZDec = 1
     C                   MOVE      PZField       WFld131
     C                   Z-ADD     WFld131       WFld153
     C                   WHEN      PZDec = 2
     C                   MOVE      PZField       WFld132
     C                   Z-ADD     WFld132       WFld153
     C                   WHEN      PZDec = 3
     C                   MOVE      PZField       WFld133
     C                   Z-ADD     WFld133       WFld153
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrZASign - Validate and align signed amounts                  *
      *                                                               *
      *****************************************************************
 
     C     SrZASign      BEGSR
 
     C                   CALLB     'ZASIGN2'
     C                   PARM      'Y'           PZASignOk
     C                   PARM                    PZFld17
     C                   PARM                    PZDig
     C                   PARM                    PZDec
     C                   PARM      *BLANK        PZSDCSP
     C                   PARM                    PZOut15
     C                   PARM                    PZFSign
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrZasnms - Message Handling Subroutine                        *
      *                                                               *
      *****************************************************************
 
     C     SrZasnms      BEGSR
 
      ** Send message
     C                   CALL      'Y2SNMGC'
     C                   PARM      ##PGMQ        PZPgmQ
     C                   PARM                    PZRelQ
     C                   PARM                    PZMsgID
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgData
     C                   PARM      *BLANKS       PZMsgType
 
     C                   EVAL      PZMsgID = *BLANKS
     C                   EVAL      PZMsgData = *BLANKS
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGLZAdd - Adds a running amount to a total amount.          *
      *                                                               *
      *****************************************************************
     C     SrGLZAdd      BEGSR
 
     C                   IF        ZZAMT = *ZERO
     C                   LEAVESR
     C                   ENDIF
 
      ** Split ZZAMT into integer and decimal fields.
 
     C                   EVAL      ZZAMTI = ZZAMT
     C                   MOVE      ZZAMT         ZZAMTD
 
      ** Both ZZAMTI and ZZAMTD now contain a 'sign' zone.
 
     C                   EXSR      SrGLZSum
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGLZSub - Subtracts a running amount from a total amount.   *
      *                                                               *
      *****************************************************************
     C     SrGLZSub      BEGSR
 
      ** Just reverse the sign & add.
 
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   EXSR      SrGLZAdd
     C                   Z-SUB     ZZAMT         ZZAMT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGLZSum - Carries out the addition for SrGLZAdd.            *
      *                                                               *
      *****************************************************************
     C     SrGLZSum      BEGSR
 
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN99 = *OFF
 
     C                   IF        ZZAMTI = *ZERO AND
     C                             ZZAMTD = *ZERO
     C                   EXSR      SrZSEnd
     C                   LEAVESR
     C                   ENDIF
 
      ** Determine the sign of ZZAMTI & ZZAMTD.
 
     C                   IF        ZZAMTI < *ZERO OR
     C                             ZZAMTD < *ZERO
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
 
      ** Determine the sign of ZZTOTI and ZZTOTD.
 
     C                   IF        ZZTOTI = *ZERO AND
     C                             ZZTOTD = *ZERO
     C                   EVAL      ZZTOTI = ZZAMTI
     C                   EVAL      ZZTOTD = ZZAMTD
     C                   EXSR      SrZSEnd
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        ZZTOTI < *ZERO OR
     C                             ZZTOTD < *ZERO
     C                   EVAL      *IN91 = *ON
     C                   ENDIF
 
      ** If the signs differ, bypass overflow checks.
 
     C                   IF        *IN91 <> *IN92
     C                   EXSR      SrZOfPs
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      ZZWK2 = ZZAMTD + ZZTOTD
 
     C                   IF        ZZWK2 > 999 OR
     C                             ZZWK2 < -999
 
     C                   IF        *IN92 = *ON
     C                   EVAL      ZZWK3 = ZZAMTI - 1
     C                   ELSE
     C                   EVAL      ZZWK3 = ZZAMTI + 1
     C                   ENDIF
 
     C                   EVAL      ZZWK3 = ZZWK3 + ZZTOTI
 
     C                   ELSE
     C                   EVAL      ZZWK3 = ZZTOTI + ZZAMTI
     C                   ENDIF
 
      ** If mod. ZZWK3 is < mod. ZZTOTI, then overflow has occurred.
 
     C                   IF        (*IN92 = *ON AND ZZWK3 > ZZTOTI) OR
     C                             (*IN92 = *OFF AND ZZWK3 < ZZTOTI)
     C                   EVAL      ZZAMT = *ZERO
     C                   EVAL      *IN99 = *ON
     C                   ELSE
     C                   Z-ADD     ZZWK2         ZZTOTD
     C                   Z-ADD     ZZWK3         ZZTOTI
     C                   ENDIF
 
     C                   EXSR      SrZSEnd
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZOfPs - Bypass overflow processing for SrGLZSum.           *
      *                                                               *
      *****************************************************************
     C     SrZOfPs       BEGSR
 
      ** If ZZAMT was neg., make it pos. for comparison with ZZTOT.
 
     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF
 
      ** If ZZTOT was neg., make it pos. for comparison with ZZAMT.
 
     C                   IF        *IN91 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
 
      ** If ZZTOT = ZZAMT, return zero.
 
     C                   IF        ZZTOTI = ZZAMTI AND
     C                             ZZTOTD = ZZAMTD
     C                   EVAL      ZZTOTI = *ZERO
     C                   EVAL      ZZTOTD = *ZERO
     C                   EXSR      SrZSEnd
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      *IN93 = *OFF
 
     C                   IF        ZZTOTI > ZZAMTI OR
     C                             ZZTOTD > ZZAMTD
 
     C                   EVAL      *IN93 = *ON
 
     C                   IF        ZZAMTD > ZZTOTD
     C                   EVAL      ZZTOTI = ZZTOTI - 1
     C                   EVAL      ZZWK2 = ZZTOTD + 1000
     C                   EVAL      ZZTOTD = ZZWK2 - ZZAMTD
     C                   ELSE
     C                   EVAL      ZZTOTD = ZZTOTD - ZZAMTD
     C                   ENDIF
 
     C                   EVAL      ZZTOTI = ZZTOTI - ZZAMTI
 
     C                   ELSE
 
     C                   IF        ZZTOTD > ZZAMTD
     C                   EVAL      ZZWK3 = ZZAMTI - 1
     C                   EVAL      ZZWK2 = ZZAMTD + 1000
     C                   EVAL      ZZTOTI = ZZWK3 - ZZTOTI
     C                   EVAL      ZZTOTD = ZZWK2 - ZZTOTD
     C                   ELSE
     C                   EVAL      ZZTOTI = ZZAMTI - ZZTOTI
     C                   EVAL      ZZTOTD = ZZAMTD - ZZTOTD
     C                   ENDIF
 
     C                   ENDIF
 
      ** Reverse the sign of ZZTOT if the larger I/P fields were neg.
 
     C                   EVAL      *IN94 = *OFF
 
     C                   IF        (*IN93 = *ON AND *IN91 = *ON) OR
     C                             (*IN93 = *OFF AND *IN92 = *ON)
     C                   EVAL      *IN94 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF
 
      ** Restore the sign of ZZAMTI & ZZAMTD if it was reversed.
 
     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF
 
     C                   EXSR      SrZSEnd
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZSEnd - End processing for SrGLZSum.                       *
      *                                                               *
      *****************************************************************
     C     SrZSEnd       BEGSR
 
      ** If ZZTOTD = zero and ZZTOTI is neg., set ZZNEGD.
 
     C                   EVAL      *IN96 = *OFF
     C                   EVAL      *IN91 = *OFF
 
     C                   IF        ZZTOTD = *ZERO AND
     C                             ZZTOTI < *ZERO
     C                   EVAL      ZZNEGD = '.000-'
     C                   EVAL      *IN96 = *ON
     C                   EVAL      *IN91 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINTDY - Calculate number of days between two dates         *
      *                                                               *
      *****************************************************************
     C     SRINTDY       BEGSR
 
     C                   CALLB     'ZINTDY'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *ZEROS        PINTDY
     C                   PARM                    WkSTDT
     C                   PARM                    WkMDAT
     C                   PARM                    #2CLBS
     C                   PARM      *ZEROS        PINT6DY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C                   EVAL      DBPGM = 'GL002100'
 
      ** Access multi-branching indicator from RUNDAT
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
 
      ** Access default branch from ZMUSER
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
 
      ** If multibranch is 'N', protect Branch and set it to default
      ** from obtained from data area ZMUSER
     C                   IF        MultBrcInd = 'N'
     C                   EVAL      *IN54 = *ON
     C                   EVAL      #2BRCA = DefBrch
     C                   ENDIF
 
      ** Call Access Program for Bank Details
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POption
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      ##PGMQ = PSProcName
     C                   EVAL      #1RUNA = BJMRDT
     C                   EVAL      #1WSID = PSJobName
     C                   EVAL      #1USER = PSUser
 
      ** Key list for ACCNT
     C     KFullAcct     KLIST
     C                   KFLD                    KCust
     C                   KFLD                    KCcy
     C                   KFLD                    KAcct
     C                   KFLD                    KSeq
     C                   KFLD                    KBrca
 
      ** Set error message file
     C                   EVAL      PZMsgFile = 'GLUSRMSG'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *  Called by: Various                                           *
      *                                                               *
      *  Calls    : DBERRCTL - Database Error Control                 *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
