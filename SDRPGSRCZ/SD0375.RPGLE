     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Tax Basket Maintenance')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0375 - Tax Basket Maintenance                              *
      *                                                               *
      *  Function:  This program maintains the Tax Basket Details     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 233036             Date 14Apr05               *
      *                 232543             Date 29Mar05               *
      *                 CGL031             Date 05Jul04               *
      *                 BUG3644            Date 12Jul04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  233036 - Possible to delete tax basket                       *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         F3 Exit                                         *
      *    05         F5 Refresh                                      *
      *    09         F9 Add/Change Mode                              *
      *    11         CGL031 Indicator                                *                       CGL031
      *    27         Rollup/Rolldown Key                             *
      *    31         Maintenance/Enquiry Mode                        *
      *    32         Invalid Selection                               *
      *    33         Invalid Country of Treaty                       *
      *    34         Invalid Tax Basket                              *
      *    35         Invalid Effective Date                          *
      *    36         Invalid Narrative                               *
      *    37         Invalid Tax Rate Applicable for Basket          *
      *    38         Invalid Transition Type                         *                       CGL031
      *    40         Global Error Indicator                          *
      *    60         READ/CHAIN Indicator                            *
      *    61         READ Indicator                                  *
      *    62         READC Indicator                                 *
      *    70         TESTN Indicator                                 *
      *    78         Protect Country of Treaty, Tax Basket, and Date *
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
      *  SRSubfileRec  -  Process modified subfile record             *
      *  SRAction      -  Process subfile record                      *
      *  SRNullRecord  -  Check for null record                       *
      *  SRValidKey    -  Validate subfile record                     *
      *  SRValidate    -  Validate subfile record relations           *
      *  SRUpdate      -  Update records from subfile                 *
      *  SRDetail      -  Process action requested                    *
      *  SRAddReq      -  Process add request                         *
      *  SRDelReq      -  Process delete request                      *
      *  SRUpdReq      -  Process update request                      *
      *  SRTrailer     -  Update Control Files                        *
      *  SRMode        -  Switch between *ADD and *CHANGE modes       *
      *  SRReload      -  Request subfile reload                      *
      *  SRProtect     -  Set display attributes for subfile record   *
      *  SRClrScrn     -  Initialise subfile record                   *
      *  SRMove        -  Transfer records from SDTXBSL1 to subfile   *
      *  SRWrite       -  Create Tax Basket Details                   *
      *  SRDelete      -  Delete Tax Basket Details                   *
      *  SRAmend       -  Update Tax Basket Details                   *
      *  SRFmtDatI     -  Format date for display                     *
      *  SRFmtDatO     -  Format date for output to file              *
      *  SRZasnms      -  Message handling subroutine                 *
      *  SREnd         -  End program                                 *
      *  *PSSR         -  Error handling subroutine                   *
      *                                                               *
      *****************************************************************
      /EJECT
     FSD0375DF  CF   E             WORKSTN USROPN
     F                                     SFILE(SD0375F0:SRLRN)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      *
     FSDTXBSL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(TXBSL0)
     F                                     COMMIT
     F                                     RENAME(SDTXBSD0:@TXBSL0)
      ** Tax Basket Details - Update
      *
     FSDTXBSL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(TXBSL1)
     F                                     RENAME(SDTXBSD0:@TXBSL1)
      ** Tax Basket Details - Retrieve
      *
     FSDWHTTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDWHTTD0:@WHTTL1)
      ** Withholding Tax Treaty Details by Basket
      *
     FSDWHTTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDWHTTD0:@WHTTL2)
      ** Withholding Tax Treaty Details by No Documentation Basket
      *
     FSDWHTTL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDWHTTD0:@WHTTL3)
      ** Withholding Tax Treaty Details by Default Backup Basket
      *
     F***SDCTTXL3  IF   E           K DISK    INFSR(*PSSR)                             CGL031 232543
      ***Midas*SD*Country*of*Tax*Codes*by*Tax*Basket*******************                CGL031 232543
     FSDCTTXL4  IF   E           K DISK    INFSR(*PSSR)                                       232543
      ** Midas SD Country of Tax Codes by Country of Treaty and Tax Basket                    232543
                                                                                              CGL031
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Control File Update Index
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      /EJECT
      *
      ** Review from fields
      *
     D                 DS
     D  SPOSN                  1     10
     D  SPOS1                  1      2
     D  SPOS2                  3      4
     D  SPOS3                  5     10
      *
      ** File Information
      *
     D TXBSL0          DS
     D  #TXBS0                 9      9
     D TXBSL1          DS
     D  #TXBS1                 9      9
      *
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structure for Bank Details
      *
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      ** External data structure for Country Codes
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL031
      ** External data structure for Switchable Features                                      CGL031
                                                                                              CGL031
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
      *
     D @1DBRC        E DS                  EXTNAME(SDTXBSL0)
      ** Current/previous master file format fields for change control
      *
     D*YCRDCS***       DS            31                                                       CGL031
     D YCRDCS          DS            32                                                       CGL031
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
      *
      ** Parameter list for ZDATE1 & ZDATE2
      *
     D PDateIs         S              6A
     D PDateIn         S              5P 0
     D PDateOut        S              6P 0
     D PDayNoOut       S              5P 0
     D PADateOut       S              7A
     D PErrorFlag      S              1A
      *
      ** Parameter list for ZALIGN
      *
     D PZAlignOk       S              1A
     D PZField         S             16A
     D PZADec          S              1  0
     D PZADig          S              2  0
      *
      ** Access Object Parameters                                                             CGL031
     D PRtCd           S              7A                                                      CGL031
     D POptn           S              7A                                                      CGL031
     D PSARD           S              6A                                                      CGL031
                                                                                              CGL031
      ** Switchable Features                                                                  CGL031
     D CGL031          S              1A                                                      CGL031
                                                                                              CGL031
      ** Key Fields                                                                           CGL031
     D KTAXB           S                   LIKE(EWTXBS)                                       CGL031
                                                                                              CGL031
     D @RUN            S              1
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Main Program
      *
     C                   DO        *HIVAL
      *
      ** Initialise and load subfile page
      *
     C                   EXSR      SRBuild
      *
     C                   MOVEL     'N'           W0RSF             1
      *
      ** Display screen until reload requested
      *
     C     W0RSF         DOWEQ     'N'
      *
      ** Display screen
      *
     C                   EXSR      SRDisplay
      *
      ** Process response
      *
     C     *IN03         CASEQ     '1'           SREnd
      *
     C     *IN05         CASEQ     '1'           SRReload
      *
     C     *IN27         CASEQ     '1'           SRLoad
      *
     C                   CAS                     SRProcess
     C                   ENDCS
      *
     C                   ENDDO
      *
     C                   ENDDO
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : AOBANKR0 - Access Bank Details                    *
      *             *PSSR                                             *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Receive entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMODE             1
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SD0375'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 0
     C                   OUT       LDA
      *
      ** Obtain default message file
      *
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      *
      ** Call Access Program for Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSSDY
      *
     C                   IF        WRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = WOPTN
     C                   EVAL      DBPGM  = 'SD0375'
     C                   EVAL      DBASE  = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CGL031
      ** Check if CGL031 is enabled.                                                          CGL031
                                                                                              CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtCd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
     C                   EVAL      CGL031 = 'N'                                               CGL031
     C                   EVAL      *IN11 = *OFF                                               CGL031
                                                                                              CGL031
     C                   IF        PRtCd = *BLANKS                                            CGL031
     C                   EVAL      CGL031 = 'Y'                                               CGL031
     C                   EVAL      *IN11 = *ON                                                CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
     C                   IF        PRtCd <> '*NRF   '                                         CGL031
     C     *LOCK         IN        LDA                                                        CGL031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
     C                   EVAL      DBKey = 'CGL031'                                           CGL031
     C                   EVAL      DBase = 101                                                CGL031
     C                   OUT       LDA                                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Open files for update
      *
     C                   OPEN      SD0375DF
     C     #TXBS0        IFNE      '1'
     C                   OPEN      SDTXBSL0
     C                   ENDIF
     C     #TXBS1        IFNE      '1'
     C                   OPEN      SDTXBSL1
     C                   ENDIF
      *
     C                   Z-ADD     14            WSFPG             3 0
      *
      ** Set to *CHANGE mode
      *
     C                   MOVEL     'CHG'         W0PMD             3
      *
      ** Initialise subfile control
      *
     C                   MOVEL     *BLANKS       SPOSN
     C                   MOVEL     BJMRDT        SRUNA
      *
     C                   EVAL      SPGM = PSProcName
     C                   EVAL      SWSID = PSJobName
     C                   EVAL      SUSER = PSUser
      *
      ** Initialise Key Lists
      *
     C     KEY1          KLIST
     C                   KFLD                    KCRTT             2
     C                   KFLD                    KTXBS             2
     C                   KFLD                    KEFDT             5 0
      *
     C     KEY2          KLIST
     C                   KFLD                    KCRTT
     C                   KFLD                    KTXBS
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBuild - Initialise and Load Subfile Page                    *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : SRFmtDatO, SRLoad, SRZasnms                        *
      *                                                               *
      *****************************************************************
      *
     C     SRBuild       BEGSR
      *
      ** Initialise & load subfile page
      *
     C                   MOVE      '1'           *IN80
     C                   WRITE     SD0375F1
     C                   MOVE      '0'           *IN80
     C                   MOVE      '0'           *IN81
      *
      ** Reset Number of Records in Subfile
      *
     C                   Z-ADD     0             WLRCD             4 0
      *
      ** If CHANGE mode, then position file
      *
     C                   IF        W0PMD <> 'ADD'
     C                   MOVEL     SPOSN         WPOSN            10
     C                   MOVEL     SPOS1         KCRTT
     C                   MOVEL     SPOS2         KTXBS
      *
     C                   MOVE      SPOS3         PDateIs
     C                   EXSR      SRFmtDatO
     C                   Z-ADD     PDayNoOut     KEFDT
      *
     C                   MOVEL     SPOS1         TBCRTT
     C                   MOVEL     SPOS2         TBTXBS
     C                   Z-ADD     PDayNoOut     TBEFDT
      *
      ** Setup key
      *
     C     KEY1          SETLL     @TXBSL1                            82
      *
     C                   READ      @TXBSL1                                82
     C                   ELSE
     C                   MOVE      '0'           *IN82
     C                   ENDIF
      *
      ** Load subfile page
      *
     C                   EXSR      SRLoad
      *
      ** If no records found, display error message
      *
     C                   IF        *IN82 and SRLRN = 0
     C                   MOVEL     'USR7590'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoad - Load Subfile Page                                    *
      *                                                               *
      * Called by: Main routine, SRBuild                              *
      *                                                               *
      * Calls    : SRClrScrn, SRMove, SRFmtDatI, SRValidate,          *
      *            SRProtect                                          *
      *                                                               *
      *****************************************************************
      *
     C     SRLoad        BEGSR
      *
      ** Load subfile page but write empty page if add mode
      *
     C                   MOVE      '0'           *IN84
      *
      ** Re-establish fields in read-ahead record
      *
     C                   IF        W0PMD <> 'ADD' and *IN27 and *IN82 = '0'
     C                   READP     @TXBSL1                                60
     C                   READ      @TXBSL1                                60
     C                   ENDIF
      *
      ** Start at previous highest record in SFL
      *
     C                   Z-ADD     WLRCD         SRLRN
     C                   Z-ADD     1             WRCTR             5 0
      *
      ** Load next subfile page
      *
     C     *IN82         DOWEQ     '0'
     C     WRCTR         ANDLE     WSFPG
      *
     C                   ADD       1             SRLRN
     C                   MOVEA     '000000'      *IN(32)
     C                   EVAL      *IN38 = *OFF                                               CGL031
     C                   MOVE      '0'           *IN87
      *
      ** Protect fields during Enquiry Mode
      *
     C                   IF        PMODE = 'E'
     C                   EVAL      *IN78 = '1'
     C                   EVAL      *IN79 = '1'
     C                   EVAL      *IN87 = '1'
     C                   ENDIF
      *
      ** Clear subfile fields
      *
     C                   EXSR      SRClrScrn
      *
      ** If CHANGE mode, load subfile fields
      *
     C                   IF        W0PMD <> 'ADD'
     C                   EXSR      SRMove
      *
     C                   MOVEL     TBCRTT        SCRTT
     C                   MOVEL     TBTXBS        STXBS
      *
     C                   IF        TBEFDT <> *ZEROS
     C                   Z-ADD     TBEFDT        PDateIn
     C                   EXSR      SRFmtDatI
     C                   MOVEL     PDateOut      SEFDT
     C                   ELSE
     C                   EVAL      SEFDT = *BLANKS
     C                   ENDIF
      *
      ** Validate subfile record and calculate derived fields
      *
     C                   EXSR      SRValidate
      *
     C                   ENDIF
      *
      ** Output to subfile
      *
     C                   ADD       1             WRCTR                81
     C                   MOVE      '1'           *IN81
      *
      ** If SFLRCD invalid, note that errors present
      *
     C                   IF        *IN83 and *IN40 = '0'
     C                   MOVE      '1'           *IN40
     C                   ENDIF
      *
      ** Set screen conditioning indicators
      *
     C                   EXSR      SRProtect
      *
     C                   WRITE     SD0375F0
      *
      ** End of File
      *
     C     W0PMD         IFNE      'ADD'
     C                   READ      @TXBSL1                                82
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   Z-ADD     SRLRN         WLRCD
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display Subfile                                  *
      *                                                               *
      *  Called by: Main routine                                      *
      *                                                               *
      *  Calls    : ZA0250                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRDisplay     BEGSR
      *
      ** Set screen conditioning indicators
      *
     C                   IF        W0PMD = 'ADD'
     C                   MOVE      '1'           *IN89
     C                   ELSE
     C                   MOVE      '0'           *IN89
     C                   ENDIF
      *
      ** PUTOVR unless conditioned fields change
      *
     C                   MOVE      '1'           *IN86
     C                   IF        *IN89 <> CAIN89 or *IN81 <> CAIN81
     C                   MOVE      '0'           *IN86
     C                   ENDIF
      *
     C                   MOVE      *IN89         CAIN89            1
     C                   MOVE      *IN81         CAIN81            1
      *
      ** Display appropriate Header depending upon Mode whether it is
      ** Enquiry or Maintenance
      *
     C                   IF        PMODE = 'E'
     C                   MOVE      '1'           *IN31
     C                   ENDIF
      *
      ** Set cursor by *SET CURSOR data
      *
     C                   TIME                    STIME
     C                   WRITE     #MSGCTL
     C                   WRITE     SD0375F2
     C                   EXFMT     SD0375F1
      *
      ** Clear messages from program message queue
      *
     C                   CALL      'ZA0250'
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Process Screen Input                              *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : SRReload, SRSubfileRec, SRUpdate, SRMode           *
      *                                                               *
      *****************************************************************
      *
     C     SRProcess     BEGSR
      *
      ** Change of position specified
      *
     C                   IF        W0PMD <> 'ADD' and WPOSN <> SPOSN
     C                   EXSR      SRReload
     C                   ENDIF
      *
      ** Quit if reload requested
      *
     C     W0RSF         IFNE      'Y'
      *
     C     *IN81         IFEQ      '1'
     C                   MOVEL     'N'           WKIPIN            1
      *
      ** Process subfile records
      *
     C                   EXSR      SRSubfileRec
      *
      ** Update DBF from subfile
      *
     C                   IF        *IN40 <> '1' and WKIPIN = 'Y'
     C                   EXSR      SRUpdate
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Switch between *ADD/*CHANGE modes is allowed when no errors
      ** exists during update
      *
     C                   IF        *IN09  and *IN40 = '0'
     C                   EXSR      SRMode
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSubfileRec - Process Modified Subfile Record                *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRAction, SRProtect                                *
      *                                                               *
      *****************************************************************
      *
     C     SRSubfileRec  BEGSR
      *
      ** Process modified subfile record
      *
     C                   READC     SD0375F0                               62
      *
     C     *IN62         DOWEQ     '0'
     C                   EXSR      SRAction
     C                   MOVE      '0'           *IN87
     C                   EXSR      SRProtect
     C                   UPDATE    SD0375F0
     C                   READC     SD0375F0                               62
     C                   ENDDO
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAction - Process Subfile Record                             *
      *                                                               *
      * Called by: SRSubfileRec                                       *
      *                                                               *
      * Calls    : SRNullRecord, SRValidKey                           *
      *                                                               *
      *****************************************************************
      *
     C     SRAction      BEGSR
      *
      ** Set off error indicators
      *
     C                   MOVEA     '000000'      *IN(32)
     C                   EVAL      *IN38 = *OFF                                               CGL031
     C                   MOVEA     '00'          *IN(83)
      *
      ** Check for null record if action is Insert
      *
     C                   IF        W0PMD = 'ADD'
     C                   EXSR      SRNullRecord
     C                   ENDIF
      *
      ** If not null record, continue
      *
     C     W0NLR         IFNE      'Y'
     C                   MOVEL     'Y'           WKIPIN
      *
     C                   MOVE      '1'           *IN84
      *
      ** Validate record
      *
     C                   EXSR      SRValidKey
      *
      ** Seton Global Error Indicator if error exists
      *
     C     *IN83         IFEQ      '1'
     C                   MOVE      '1'           *IN40
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNullRecord - Check for Null Record                          *
      *                                                               *
      * Called by: SRAction, SRDetail                                 *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRNullRecord  BEGSR
      *
     C                   MOVEL     'N'           W0NLR             1
      *
     C     SCRTT         IFEQ      *BLANKS
     C     STXBS         ANDEQ     *BLANKS
     C     SEFDT         ANDEQ     *BLANKS
     C     SNARR         ANDEQ     *BLANKS
     C     STRAB         ANDEQ     *BLANKS
     C     STRTY         ANDEQ     *BLANKS                                                    CGL031
     C                   MOVEL     'Y'           W0NLR
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidKey - Validate Subfile Record                          *
      *                                                               *
      * Called by: SRAction                                           *
      *                                                               *
      * Calls    : SRFmtDatO, SRZasnms, SRValidate                    *
      *                                                               *
      *****************************************************************
      *
     C     SRValidKey    BEGSR
      *
      ** In Add mode, need to move screen value to hidden file field
      *
     C                   IF        W0PMD = 'ADD'
     C                   MOVEL     SCRTT         S#CRTT
     C                   MOVEL     STXBS         S#TXBS
     C                   MOVEL     SEFDT         PDateIs
     C                   EXSR      SRFmtDatO
     C                   Z-ADD     PDayNoOut     S#EFDT
      *
      ** Country of Treaty is blank
      *
     C                   IF        SCRTT = *BLANKS
     C                   MOVE      '1'           *IN33
     C                   MOVE      '1'           *IN83
     C                   MOVEL     'USR7592'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Tax Basket is blank
      *
     C                   IF        STXBS = *BLANKS
     C                   MOVE      '1'           *IN34
     C                   MOVE      '1'           *IN83
     C                   MOVEL     'USR7593'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Effective Date is blank
      *
     C                   IF        SEFDT = *BLANKS
     C                   MOVE      '1'           *IN35
     C                   MOVE      '1'           *IN83
     C                   MOVEL     'USR7594'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Validate Action
      *
     C                   ELSE
      *
     C                   IF        S1SEL <> 'D' and S1SEL <> *BLANKS
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN83
     C                   MOVEL     'USR7591'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate subfile record relations
      *
     C                   EXSR      SRValidate
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate Subfile Record Relations                *
      *                                                               *
      * Called by: SRLoad, SRValidKey                                 *
      *                                                               *
      * Calls    : AOCTRYR0 - Access Country Codes                    *
      *            SRZasnms, SRFmtDatO, ZALIGN, ZEDIT                 *
      *                                                               *
      *****************************************************************
      *
     C     SRValidate    BEGSR
      *
      ** Validate Country of Treaty
      *
     C                   IF        W0PMD = 'ADD'
      *
     C                   CALL      'AOCTRYR0'
     C                   PARM      '*BLANKS '    WRTCD
     C                   PARM      '*KEY    '    WOPTN
     C                   PARM      SCRTT         WCRTT             2
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C                   IF        WRTCD <> *BLANKS
     C                   MOVE      '1'           *IN33
     C                   MOVE      '1'           *IN83
     C                   MOVEL     'USR7595'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   MOVE      A4CNCD        SCRTT
     C                   MOVE      A4CNCD        S#CRTT
     C                   ENDIF
      *
      ** Validate Tax Basket
      *
     C                   TESTN                   STXBS                70
     C                   IF        *IN70 = '0'
     C                   MOVE      '1'           *IN34
     C                   MOVE      '1'           *IN83
     C                   MOVEL     'USR7596'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Validate Effective Date
      *
     C                   MOVE      SEFDT         PDateIs
     C                   EXSR      SRFmtDatO
     C                   IF        PErrorFlag = 'Y'
     C                   MOVE      '1'           *IN35
     C                   MOVE      '1'           *IN83
     C                   MOVE      '1'           *IN40
     C                   MOVEL     'USR7597'     WZMsgID
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRZasnms
      *
     C                   ELSE
      *
      ** Effective Date must be equal to rundate or in the future
      *
     C                   IF        PDayNoOut < BJRDNB
     C                   MOVE      '1'           *IN35
     C                   MOVE      '1'           *IN83
     C                   MOVEL     'USR7598'     WZMsgID
     C                   MOVEL     'SDUSRMSG'    WZMsgFile
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Tax Rate Applicable for Band
      *
     C                   MOVE      *BLANKS       PZField
     C                   MOVE      STRAB         PZField
     C                   Z-ADD     2             PZADig
     C                   Z-ADD     4             PZADec
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZAlignOk
     C                   PARM                    PZField
     C                   PARM                    PZADec
     C                   PARM                    PZADig
      *
     C                   IF        PZAlignOk <> 'Y'
     C                   MOVE      '1'           *IN37
     C                   MOVE      '1'           *IN83
     C                   MOVE      '1'           *IN40
     C                   MOVEL     'USR7599'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   MOVE      PZField       SRATE
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZField
     C                   PARM                    PZADec
     C                   MOVE      PZField       STRAB
     C                   ENDIF
                                                                                              CGL031
      ** Validate Transition Type if CGL031 is enabled.                                       CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
                                                                                              CGL031
     C                   EVAL      S#TRTY = STRTY                                             CGL031
                                                                                              CGL031
     C                   IF        STRTY <> *BLANK                                            CGL031
                                                                                              CGL031
     C                   IF        STRTY <> '1' AND                                           CGL031
     C                             STRTY <> '2'                                               CGL031
                                                                                              CGL031
      ** Transition Type must be '1' or '2'.                                                  CGL031
                                                                                              CGL031
     C                   EVAL      *IN38 = *ON                                                CGL031
     C                   EVAL      *IN40 = *ON                                                CGL031
     C                   EVAL      *IN83 = *ON                                                CGL031
     C                   EVAL      WZMsgID = 'USR4706'                                        CGL031
     C                   EXSR      SRZasnms                                                   CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
     C**********         IF        W0PMD = 'ADD'                                       CGL031 232543
                                                                                              CGL031
      ** At this point, Transition Type must be defaulted to '2'.                             CGL031
                                                                                              CGL031
     C                   EVAL      S#TRTY = '2'                                               CGL031
     C                   EVAL      STRTY = '2'                                                CGL031
     C**********         ENDIF                                                         CGL031 232543
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update Records from Subfile                        *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRDetail, SRProtect                                *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdate      BEGSR
      *
      ** Initialise subfile reload flag
      *
     C                   IF        W0PMD = 'ADD'
     C                   MOVEL     'Y'           W0RSF
     C                   ELSE
     C                   MOVEL     'N'           W0RSF
     C                   ENDIF
      *
      ** Process all modified subfile records
      *
     C                   READC     SD0375F0                               62
      *
     C     *IN62         DOWEQ     '0'
     C                   EXSR      SRDetail
      *
      ** Rollback any DBF changes if error occur
      *
     C                   IF        W#EROR <> *BLANKS
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
      *
      ** Set screen conditioning indicators
      *
     C                   MOVEL     *BLANKS       S1SEL
     C                   EXSR      SRProtect
     C                   UPDATE    SD0375F0
     C                   READC     SD0375F0                               62
     C                   ENDDO
      *
      ** Cancel reload if errors occur
      *
     C                   IF        *IN40 = '1'
     C                   MOVEL     'N'           W0RSF
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetail - Process action requested                           *
      *                                                               *
      * Called by: SRUpdate                                           *
      *                                                               *
      * Calls    : SRNullRecord, SRAddReq, SRDelReq, SRUpdReq         *
      *                                                               *
      *****************************************************************
      *
     C     SRDetail      BEGSR
      *
      ** Set off error indicators
      *
     C                   MOVEA     '000000'      *IN(32)
     C                   EVAL      *IN38 = *OFF                                               CGL031
     C                   MOVE      '0'           *IN83
      *
      ** Process add request
      *
     C                   IF        W0PMD = 'ADD'
      *
     C                   EXSR      SRNullRecord
     C                   IF        W0NLR <> 'Y'
     C                   EXSR      SRAddReq
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Process delete request
      *
     C                   IF        S1SEL = 'D'
     C                   EXSR      SRDelReq
     C                   ELSE
      *
      ** Process change request
      *
     C                   EXSR      SRUpdReq
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        *IN83 and *IN40 = '0'
     C                   MOVE      '1'           *IN40
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAddReq - Process Add Request                                *
      *                                                               *
      * Called by: SRDetail                                           *
      *                                                               *
      * Calls    : SRWrite, SRTrailer                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRAddReq      BEGSR
      *
      ** Create Tax Basket Details
      *
     C                   EXSR      SRWrite
      *
      ** Error detected
      *
     C                   IF        W#EROR <> *BLANKS
     C                   MOVEA     '11111'       *IN(33)
     C                   EVAL      *IN38 = *ON                                                CGL031
     C                   MOVEA     '11'          *IN(83)
     C                   MOVE      '0'           *IN87
     C                   ELSE
     C                   MOVE      '0'           *IN84
     C                   MOVE      '1'           *IN87
     C                   EXSR      SRTrailer
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelReq - Process Delete Request                             *
      *                                                               *
      * Called by: SRDetail                                           *
      *                                                               *
      * Calls    : SRDelete, SRMove, SRClrScrn                        *
      *                                                               *
      *****************************************************************
      *
     C     SRDelReq      BEGSR
      *
      ** Delete Tax Basket Details
      *
     C                   EXSR      SRDelete
      *
     C                   IF        W#EROR <> *BLANKS
      *
      ** Delete unsuccessful
      *
     C                   MOVEA     '111111'      *IN(32)
     C                   EVAL      *IN38 = *ON                                                CGL031
     C                   MOVEA     '11'          *IN(83)
     C                   MOVE      '0'           *IN87
     C                   EXSR      SRMove
     C                   ELSE
      *
      ** Blank out record and protect from entry
      *
     C                   EXSR      SRTrailer
     C                   EXSR      SRClrScrn
     C                   MOVE      '0'           *IN84
     C                   MOVE      '1'           *IN87
      *
      ** Reload subfile
      *
     C                   MOVEL     'Y'           W0RSF
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdReq - Process Update Request                             *
      *                                                               *
      * Called by: SRDetail                                           *
      *                                                               *
      * Calls    : SRAmend, SRMove, SRTrailer                         *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdReq      BEGSR
      *
      ** Amend Tax Basket Details
      *
     C                   EXSR      SRAmend
      *
     C                   IF        W#EROR <> *BLANKS
     C                   MOVEA     '111111'      *IN(32)
     C                   EVAL      *IN38 = *ON                                                CGL031
     C                   MOVE      '0'           *IN87
     C                   MOVEA     '11'          *IN(83)
      *
      ** Reset subfile record if changed record
      *
     C                   EXSR      SRMove
     C                   ELSE
      *
      ** Enable entry
      *
     C                   MOVE      '0'           *IN84
     C                   MOVE      '0'           *IN87
     C                   EXSR      SRTrailer
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTrailer - Update Control Files                              *
      *                                                               *
      * Called by: SRAddReq, SRDelReq, SRUpdReq                       *
      *                                                               *
      * Calls    : *PSSR                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRTrailer     BEGSR
      *
     C                   MOVEL     'SDTXBSPD'    WFNAM            10
     C     WFNAM         CHAIN     SDFCTLL0                           60
      *
     C                   IF        *IN60
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBKEY = WFNAM
     C                   EVAL      DBPGM = 'SD0375'
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
     C                   SELECT
     C     W0PMD         WHENEQ    'ADD'
     C                   ADD       1             AHNORC
     C                   ADD       1             AHNOIN
     C     S1SEL         WHENEQ    'D'
     C                   ADD       1             AHNODL
     C                   SUB       1             AHNORC
     C     YCRDC         WHENEQ    'Y'
     C                   ADD       1             AHNOAM
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   UPDATE    @AHREAU
      *
     C                   COMMIT
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMode - Switch Between *ADD and *CHANGE Modes                *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRReload                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRMode        BEGSR
      *
      ** Switch between *ADD/*CHANGE modes
      *
     C                   IF        W0PMD <> 'ADD'
     C                   MOVEL     'ADD'         W0PMD
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       SPOSN
      *
     C                   EXSR      SRReload
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReload - Request Subfile Reload                             *
      *                                                               *
      * Called by: Main routine, SRProcess, SRMode                    *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRReload      BEGSR
      *
      ** Request subfile reload
      *
     C                   MOVEL     'Y'           W0RSF
      *
     C                   IF        *IN05
     C                   MOVE      *BLANKS       SPOSN
     C                   MOVE      *BLANKS       S1SEL
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProtect - Set Display Attributes for Subfile Record         *
      *                                                               *
      * Called by: SRLoad, SRSubfileRec, SRUpdate                     *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRProtect     BEGSR
      *
     C                   IF        W0PMD = 'ADD'
     C                   MOVE      '1'           *IN89
     C                   ELSE
     C                   MOVE      '0'           *IN89
     C                   ENDIF
      *
      ** Protect keys if change mode or updated record
      *
     C                   MOVEL     *IN87         *IN79
     C                   IF        *IN89
     C                   MOVE      '1'           *IN79
     C                   ENDIF
      *
     C                   MOVEL     *IN87         *IN78
     C                   IF        W0PMD = 'CHG'
     C                   MOVE      '1'           *IN78
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrScrn - Initialise Subfile Record                         *
      *                                                               *
      * Called by: SRLoad, SRDelReq                                   *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRClrScrn     BEGSR
      *
      ** Initialise subfile record
      *
     C                   EVAL      S#1DBRC = *BLANKS
     C                   EVAL      S#CRTT = *BLANKS
     C                   EVAL      S#TXBS = *BLANKS
     C                   EVAL      S#EFDT = 0
     C                   EVAL      SRECI = *BLANKS
     C                   EVAL      STYLC = *BLANKS
     C                   EVAL      SLCD = 0
     C                   EVAL      SRATE = 0
     C                   EVAL      S#TRTY = *BLANK                                            CGL031
     C                   EVAL      S1SEL = *BLANKS
     C                   EVAL      SCRTT = *BLANKS
     C                   EVAL      STXBS = *BLANKS
     C                   EVAL      SEFDT = *BLANKS
     C                   EVAL      SNARR = *BLANKS
     C                   EVAL      STRAB = *BLANKS
     C                   EVAL      STRTY = *BLANK                                             CGL031
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMove - Transfer Records from SDTXBSL1 to Subfile            *
      *                                                               *
      * Called by: SRLoad, SRDelReq, SRUpdReq                         *
      *                                                               *
      * Calls    : ZEDIT                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRMove        BEGSR
      *
      ** Move SDTXBSL0 fields to subfile
      *
     C                   MOVEL     TBCRTT        S#CRTT
     C                   MOVEL     TBTXBS        S#TXBS
     C                   MOVEL     TBEFDT        S#EFDT
     C                   MOVEL     TBNARR        SNARR
     C                   Z-ADD     TBTRAB        SRATE
     C                   MOVE      TBTRAB        PZField
     C                   Z-ADD     4             PZADec
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZField
     C                   PARM                    PZADec
     C                   MOVE      PZField       STRAB
     C                   MOVEL     TBRECI        SRECI
     C                   MOVEL     TBTYLC        STYLC
     C                   MOVEL     TBLCD         SLCD
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   EVAL      S#TRTY = TBTRTY                                            CGL031
     C                   EVAL      STRTY = TBTRTY                                             CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Hold current record image for change detection
      *
     C                   MOVEL     @1DBRC        S#1DBRC
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Create Tax Basket Details                           *
      *                                                               *
      * Called by: SRAddReq                                           *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRWrite       BEGSR
      *
     C                   MOVEL     *BLANKS       W#EROR
      *
      ** Create Tax Basket Details
      *
     C                   MOVEL     'D'           TBRECI
     C                   MOVEL     S#CRTT        TBCRTT
     C                   MOVEL     S#TXBS        TBTXBS
     C                   Z-ADD     S#EFDT        TBEFDT
     C                   MOVEL     SNARR         TBNARR
     C                   MOVEL     SRATE         TBTRAB
     C                   MOVE      'I'           TBTYLC
     C                   Z-ADD     BJRDNB        TBLCD
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   EVAL      TBTRTY = S#TRTY                                            CGL031
     C                   ELSE                                                                 CGL031
     C                   EVAL      TBTRTY = *BLANK                                            CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Check for duplicate primary key
      *
     C                   MOVEL     S#CRTT        KCRTT
     C                   MOVEL     S#TXBS        KTXBS
     C                   Z-ADD     S#EFDT        KEFDT
      *
     C     KEY1          SETLL     @TXBSL0                                60
      *
     C                   IF        *IN60
     C                   MOVEL     'Y'           W#EROR            1
     C                   MOVEL     'USR7601'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ELSE
      *
     C                   WRITE     @TXBSL0                              61
      *
      ** Write error detected
      *
     C                   IF        *IN61
     C                   MOVEL     'Y'           W#EROR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelete - Delete Tax Basket Details                          *
      *                                                               *
      * Called by: SRDelreq                                           *
      *                                                               *
      * Calls    : SRFmtDatO, SRZasnms                                *
      *                                                               *
      *****************************************************************
      *
     C     SRDelete      BEGSR
      *
      ** Delete Tax Basket Details
      *
     C                   MOVEL     *BLANKS       W#EROR
      *
      ** Set Key Fields
      *
     C                   MOVEL     SCRTT         KCRTT
     C                   MOVEL     STXBS         KTXBS
     C                   MOVE      SEFDT         PDateIs
     C                   EXSR      SRFmtDatO
     C                   Z-ADD     PDayNoOut     KEFDT
      *
      ** Check if the Tax Basket is being used as a Main Tax Basket
      *
     C     KEY2          CHAIN     @WHTTL1                            60
     C                   IF        *IN60 = '0'
     C                   MOVEL     'Y'           W#EROR
     C                   MOVEL     'USR7606'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Check if the Tax Basket is being used as a Default Tax Basket
      ** for No Documentation
      *
     C     KEY2          CHAIN     @WHTTL2                            60
     C                   IF        *IN60 = '0'
     C                   MOVEL     'Y'           W#EROR
     C                   MOVEL     'USR7607'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Check if the Tax Basket is being used as a Default Tax Basket
      ** for Backup Withholding
      *
     C     KEY2          CHAIN     @WHTTL3                            60
     C                   IF        *IN60 = '0'
     C                   MOVEL     'Y'           W#EROR
     C                   MOVEL     'USR7608'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ENDIF
                                                                                              CGL031
      ** Check if the Tax Basket is being used as a Country of Tax if                         CGL031
      ** CGL031 is enabled.                                                                   CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
                                                                                              CGL031
     C                   EVAL      KCRTT = SCRTT                                              232543
     C**********         EVAL      KTAXB = STXBS                                       CGL031 232543
     C*****KTAXB         CHAIN     SDCTTXL3                                            CGL031 232543
     C                   EVAL      KTXBS = STXBS                                              232543
     C     KEY1          CHAIN     @TXBSL0                            60                      233036
     C     KEY2          READPE    @TXBSl0                                60                  233036
     C     KEY2          CHAIN     SDCTTXL4                                                   232543
                                                                                              CGL031
     C                   IF        %FOUND                                                     CGL031
     C                             And KEFDT <= BJRDNB And *IN60 = *ON                        233036
     C                   EVAL      W#EROR = 'Y'                                               CGL031
     C                   EVAL      WZMsgID = 'USR4707'                                        CGL031
     C                   EXSR      SRZasnms                                                   CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
      *
     C                   IF        W#EROR <> 'Y'
      *
     C     KEY1          CHAIN     @TXBSL0                            6061
      *
      ** Record already deleted
      *
     C                   IF        *IN60
     C                   MOVEL     'Y'           W#EROR
     C                   MOVEL     'USR7602'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Record locked
      *
     C                   IF        *IN61
     C                   MOVEL     'Y'           W#EROR
     C                   MOVEL     'USR7603'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Check for changed record
      *
     C                   IF        S#1DBRC <> @1DBRC
     C                   MOVEL     'Y'           W#EROR
     C                   MOVEL     'USR7604'     WZMsgID
     C                   EXSR      SRZasnms
      *
      ** Release record lock
      *
     C     KEY1          SETLL     @TXBSL0                            6061
     C                   ELSE
      *
     C                   DELETE    @TXBSL0                              61
      *
      ** Delete error detected
      *
     C                   IF        *IN61
     C                   MOVEL     'Y'           W#EROR
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmend  - Update Tax Basket Details                          *
      *                                                               *
      * Called by: SRUpdReq                                           *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRAmend       BEGSR
      *
      ** Change Tax Basket Details
      *
     C                   MOVEL     *BLANKS       W#EROR
      *
      ** Set record data changed flag
      *
     C                   MOVE      'N'           YCRDC             1
      *
      ** Move key fields to SDTXBSL0
      *
     C                   MOVEL     S#CRTT        KCRTT
     C                   MOVEL     S#TXBS        KTXBS
     C                   Z-ADD     S#EFDT        KEFDT
      *
     C     KEY1          CHAIN     @TXBSL0                            6061
      *
      ** Record not found
      *
     C                   IF        *IN60
     C                   MOVEL     'Y'           W#EROR
     C                   MOVEL     'USR7605'     WZMsgID
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Record locked
      *
     C                   IF        *IN61
     C                   MOVEL     'Y'           W#EROR
     C                   ELSE
      *
      ** Check for changed record
      *
     C                   IF        S#1DBRC <> @1DBRC
     C                   MOVEL     'Y'           W#EROR
     C                   MOVEL     'USR7604'     WZMsgID
     C                   EXSR      SRZasnms
     C                   UNLOCK    SDTXBSL0                             61
     C                   ELSE
      *
      ** Store record data for null update check
      *
     C                   MOVEL     @1DBRC        YCRDCS
      *
      ** Move non-key fields to SDTXBSL0
      *
     C                   MOVE      'D'           TBRECI
     C                   MOVEL     S#CRTT        TBCRTT
     C                   MOVEL     S#TXBS        TBTXBS
     C                   Z-ADD     S#EFDT        TBEFDT
     C                   MOVEL     SNARR         TBNARR
     C                   MOVEL     SRATE         TBTRAB
     C                   MOVEL     'A'           TBTYLC
     C                   Z-ADD     BJRDNB        TBLCD
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   EVAL      TBTRTY = S#TRTY                                            CGL031
     C                   ELSE                                                                 CGL031
     C                   EVAL      TBTRTY = *BLANK                                            CGL031
     C                   ENDIF                                                                CGL031
      *
     C                   IF        @1DBRC <> YCRDCS
     C                   MOVE      'Y'           YCRDC
     C                   ENDIF
      *
      ** If changed update record otherwise release record
      *
     C                   IF        YCRDC = 'Y'
     C                   UPDATE    @TXBSL0                              61
     C                   ELSE
     C                   UNLOCK    SDTXBSL0                             61
     C                   ENDIF
      *
      ** Change error detected
      *
     C                   IF        *IN61
     C                   MOVEL     'Y'           W#EROR
     C                   ELSE
      *
      ** Update saved record image
      *
     C                   MOVEL     @1DBRC        S#1DBRC
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFmtDatI - Format date for display.                          *
      *                                                               *
      * Called by: SRLoad                                             *
      *                                                               *
      * Calls    : ZDATE2                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRFmtDatI     BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM      *BLANKS       PADateOut
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFmtDatO - Format date for output to file.                   *
      *                                                               *
      * Called by: SRBuild, SRValidKey, SRValidate, SRDelete          *
      *                                                               *
      * Calls    : ZDATE1                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRFmtDatO     BEGSR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDateIs
     C                   PARM      *ZERO         PDayNoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrorFlag
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZasnms - Message Handling Subroutine                        *
      *                                                               *
      * Called by: Various                                            *
      *                                                               *
      * Calls    : ZA0340                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRZasnms      BEGSR
      *
     C                   IF        WZMsgFile = *BLANKS
     C                   EVAL      WZMsgFile = ZADFMF
     C                   ENDIF
      *
     C                   CALL      'ZA0340'
     C                   PARM                    WZMsgFile        10
     C                   PARM                    WZMsgID          10
      *
     C                   EVAL      WZMsgFile = *BLANKS
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - End Program                                           *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
      *
     C     SREnd         BEGSR
      *
      ** Rollback any uncommitted DBF changes
      *
     C                   ROLBK                                          60
      *
      ** Terminate program
      *
     C                   MOVE      '1'           *INLR
      *
      ** Exit program
      *
     C                   RETURN
      *
     C                   ENDSR
      *
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
      *
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2001
