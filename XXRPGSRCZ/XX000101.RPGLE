     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2017')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Income & Expense Mapping Maintenance')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  XX000101 - Mapping Matrix for Income and Expense Accounts    *
      *                                                               *
      *  Function:  This program maintains the mapping matrix to      *
      *  (I/C)      allow entry of a single or a range of Income and  *
      *             Expense accounts to be mapped to a Profit/Loss    *
      *             account and Spot Revaluation account.             *
      *                                                               *
      *  (c) Finastra International Limited 2017                      *
      *                                                               *
      *  Last Amend No. FTV102  *CREATE     Date 08May17              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  FTV102 - Posting of Profit and Loss to Multiple Retained     *
      *           Earnings Accounts.                                  *
      *                                                               *
      *****************************************************************
      *  Note:  The structure of this new program has been based on   *
      *         the existing core RPGLE program SD000741.             *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         F3 Exit                                         *
      *    05         F5 Refresh                                      *
      *    09         F9 Add/Change Mode                              *
      *    25         Message Control - Subfile End (SFLEND)          *
      *    27         Rollup/Rolldown Key                             *
      *    31         Maintenance/Enquiry Mode                        *
      *    32         Invalid Selection                               *
      *    33         Invalid 'From' Income and Expense Account       *
      *    34         Invalid 'To' Income and Expense Account         *
      *    35         Invalid Profit and Loss Account                 *
      *    36         Invalid Spot Revaluation Account                *
      *    37         Selection Mode                                  *
      *    40         Global Error Indicator                          *
      *    41         Invalid selection from drop-down window         *
      *    60         READ/CHAIN Indicator                            *
      *    61         READ Indicator                                  *
      *    62         READC Indicator                                 *
      *    70         TESTN Indicator                                 *
      *    78         Protect 'From' Income and Expense field         *
      *    79         Protect Selection Field                         *
      *    80         Subfile Clear (SFLCLR)                          *
      *    81         Subfile Display (SFLDSP)                        *
      *    82         Subfile End (SFLEND)                            *
      *    83         Force Input Format                              *
      *    84         Subfile Next Change (SFLNXTCHG)                 *
      *    86         PUTOVR Indicator                                *
      *    87         Enable Key Screen                               *
      *    88         Protect Profit & Loss and Spot Reval a/c codes  *
      *    89         Add Mode                                        *
      *    90         Select account code ended in error.             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  SRBuildSFL    -  Initialise and load subfile page            *
      *  SRLoad        -  Load subfile page                           *
      *  SRDisplay     -  Display subfile                             *
      *  SRProcess     -  Process screen input                        *
      *  SRSubfileRec  -  Process modified subfile record             *
      *  SRAction      -  Process subfile record                      *
      *  SRNullRecord  -  Check for null record                       *
      *  SRValidKey    -  Validate subfile record                     *
      *  SRValidate    -  Validate subfile record relations           *
      *  SRVackrl      -  Select existing account code record.        *
      *  SRUpdate      -  Update records from subfile                 *
      *  SRDetail      -  Process action requested                    *
      *  SRAddReq      -  Process add request                         *
      *  SRDelReq      -  Process delete request                      *
      *  SRUpdReq      -  Process update request                      *
      *  SRMode        -  Switch between *ADD and *CHANGE modes       *
      *  SRReload      -  Request subfile reload                      *
      *  SRProtect     -  Set display attributes for subfile record   *
      *  SRClrScrn     -  Initialise subfile record                   *
      *  SRMove        -  Transfer records from file to subfile       *
      *  SRWrite       -  Create Mapping Matrix details               *
      *  SRDelete      -  Delete Mapping Matrix details               *
      *  SRAmend       -  Update Mapping Matrix details               *
      *  SRZasnms      -  Message handling subroutine                 *
      *  SREnd         -  End program                                 *
      *  *PSSR         -  Error handling subroutine                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Display file for Mapping Matrix
     FXX000101DFCF   E             WORKSTN USROPN
     F                                     SFILE(XX000101S0:RRN)
     F                                     INFDS(INFDSDF)
     F                                     INFSR(*PSSR)
      *
      ** SD Income and Expense mapped File by MAINC1 - Update Index
     FXXINEXL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(INFDSV0)
     F                                     COMMIT
     F                                     RENAME(XXINEXD0:@XXINEXL0)
      *
      ** SD Income and Expense mapped File by MAINC1 - Retrieval Index
     FXXINEXL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(INFDSV1)
     F                                     COMMIT
     F                                     RENAME(XXINEXD0:@XXINEXL1)
      *
      ** SD Income and Expense mapped File by MAINC2 - Retrieval Index
     FXXINEXL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(XXINEXD0:@XXINEXL2)
      *****************************************************************
      /EJECT
      *****************************************************************
      *
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
      *
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Position SFL
     D                 DS
     D  SFLPosn                1     10
     D  #PosINC1               1     10
      *
      ** File Information DS for XXINEXL0
     D INFDSV0         DS
     D  FILOPV0                9      9
      *
      ** File Information DS for XXINEXL1
     D INFDSV1         DS
     D  FILOPV1                9      9
      *
      ** Display file information data structure
     D INFDSDF       E DS                  EXTNAME(Y2I#DSP)
      *
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      * External data structuer for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  OldAcntCode1 E                     EXTFLD(QQACCD)
      *
      * External Data structure for TRADING DETAILS
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  OldAcntCode2 E                     EXTFLD(QQACCD)
      *
      ** External data structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** External data structure for SDACODPD
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      *
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Current/previous master file format fields for change control
     D @1DBRC        E DS                  EXTNAME(XXINEXL0)
      *
      ** Data Structure for record fields
     D YCRDCS          DS            45
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PMODE           S              1
     D PRTCD           S              7
     D @RUN            S              1
     D RELOADSF        S              1
     D WkMode          S              3
     D WkNoSFLRcd      S              4  0
     D WPOSN           S             10
     D CAIN89          S              1
     D CAIN81          S              1
     D WKIPIN          S              1
     D W0NLR           S              1
     D WFNAM           S             10
     D W#EROR          S              1
     D YCRDC           S              1
     D WSLCTR          S              3  0
     D WNODAT          S              1
     D WRCTR           S              5  0
     D WSFPG           S              3  0
     D ZADFMF          S             10
     D PZMsgFile       S             10
     D PZMsgID         S             10
     D #FromKey        S             10  0
     D #ToKey          S             10  0
     D WSkipRec        S              1
     D WValid          S              1
     D WZLCDT          S                   LIKE(#LCDT)
     D WZCHTP          S                   LIKE(#CHTP)
     D WZINC1          S                   LIKE(#PosInc1)
     D WK1X01          S              1
     D WKACCD          S             10
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Main Program
      *
     C                   DO        *HIVAL
      *
      ** Initialise and load subfile page
      *
     C                   EXSR      SRBuildSFL
      *
     C                   EVAL      RELOADSF  = 'N'
      *
      ** Display screen until reload requested
      *
     C     RELOADSF      DOWEQ     'N'
      *
      ** Display screen
      *
     C                   EXSR      SRDisplay
      *
      ** Process response
      *
     C     *IN03         CASEQ     '1'           SREnd
     C     *IN05         CASEQ     '1'           SRReload
     C     *IN27         CASEQ     '1'           SRLoad
     C                   CAS                     SRProcess
     C                   ENDCS
      *
     C                   ENDDO
     C                   ENDDO
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : AOBANKR0 - Access Bank Details                    *
      *           : AOSARDR0 - Access SAR Details                     *
      *           : *PSSR                                             *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      *  Receive entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PMODE             1
      *
      ** Setup program name for reporting DB errors
      *
     C                   EVAL      DBPGM    =    'XX000101'
      *
      ** Define LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE   =    *BLANKS
     C                   EVAL      DBKEY    =    *BLANKS
     C                   EVAL      DBASE    =    1
     C                   OUT       LDA
      *
      ** Obtain default message file
      *
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF
     C                   IN        ZADFMF
      *
      ** Call Access Program for Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSSDY
      *
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE     =   'SDBANKPD'
     C                   EVAL      DBKEY      =   @OPTN
     C                   EVAL      DBASE      =   2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Call Access Program for General Ledger ICD Details
      ** to obtain the system level Profit and Loss Account Code.
      *
     C                   CALL      'AOGELRR1'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE     =   'SDGELRPD'
     C                   EVAL      DBKEY      =   @OPTN
     C                   EVAL      DBASE      =   3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Call Access Program for Trading ICD Details
      ** to obtain the system level Spot Revaluation Account Code.
      *
     C                   CALL      'AOTRADR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE     =   'SDTRADPD'
     C                   EVAL      DBKEY      =   @OPTN
     C                   EVAL      DBASE      =   4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Check to see if switchable feature FVT102 is on
      *
     C                   MOVE      'N'           FVT102            1
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'FVT102'      @SARD             6
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           FVT102
     C                   END
      *
      * If feature is not switched on, exit program
      *
     C     FVT102        IFEQ      'N'
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      ** Open files for update
      *
     C                   OPEN      XX000101DF
      *
      *    '1' = file is open
     C     FILOPV0       IFNE      '1'
     C                   OPEN      XXINEXL0
     C                   ENDIF
     C     FILOPV1       IFNE      '1'
     C                   OPEN      XXINEXL1
     C                   ENDIF
      *
     C                   Z-ADD     14            WSFPG
      *
      *  Set to *CHANGE mode
      *
     C                   EVAL      WkMode =  'CHG'
      *
      ** Initialise subfile control
      *
     C                   EVAL      SFLPosn   =    *BLANKS
     C                   EVAL      #RUNA     =    BJMRDT
     C                   EVAL      ##PGMQ    =    PSProcName
     C                   EVAL      #WSID     =    PSJobName
     C                   EVAL      #USER     =    PSUser
      *
     C                   Z-ADD     *ZERO         #LCDT
     C                   MOVEL     *BLANK        #CHTP
     C                   MOVEL     *BLANK        #POSINC1
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBuildSFL - Initialise and Load Subfile Page                 *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : SRLoad, SRZasnms                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRBuildSFL    BEGSR
      *
      ** Initialise & load subfile page
      *
     C                   EVAL      *IN80       =   *ON
     C                   WRITE     XX000101C0
     C                   EVAL      *IN80       =   *OFF
     C                   EVAL      *IN81       =   *OFF
      *
      *  Reset Number of Records in Subfile
      *
     C                   Z-ADD     0             WkNoSFLRcd
      *
      ** If CHANGE mode, then position file
      *
     C                   IF        WKMode    <>   'ADD'
     C                   EVAL      WPOSN     =     SFLPosn
      *
      ** Setup key
      *
     C                   MOVEL     #PosInc1      #KeyPos          10 0
     C     #KeyPos       SETLL     @XXINEXL1                          82
     C                   READ      @XXINEXL1                              82
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF
      *
      ** Save previous selector values
      *
     C                   EVAL      WZLCDT      =     #LCDT
     C                   EVAL      WZCHTP      =     #CHTP
     C                   EVAL      WZINC1      =     #PosInc1
      *
      *  Load subfile page
      *
     C                   EXSR      SRLoad
      *
      ** If no records found, display error message
      ** "No Data to Display".
      *
     C                   IF        *IN82   and   RRN = 0
     C                   EVAL      PZMsgID   =   'SDX0020'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoad - Load Subfile Page                                    *
      *                                                               *
      * Called by: Main routine, SRBuildSFL                           *
      *                                                               *
      * Calls    : SRClrScrn, SRMove, SRValidate, SRProtect           *
      *                                                               *
      *****************************************************************
      *
     C     SRLoad        BEGSR
      *
      ** Load subfile page but write empty page if add mode
      *
     C                   EVAL      *IN84 = *OFF
      *
      ** Re-establish fields in read-ahead record
      *
     C                   IF        WkMode  <> 'ADD'  AND
     C                             *IN27 and *IN82 = '0'
     C                   READP     @XXINEXL1                              60
     C                   READ      @XXINEXL1                              60
     C                   ENDIF
      *
      ** Start at previous highest record in SFL
      *
     C                   Z-ADD     WkNoSFLRcd    RRN
     C                   Z-ADD     1             WRCTR
      *
      ** Load next subfile page
      *
     C     *IN82         DOWEQ     '0'
     C     WRCTR         ANDLE     WSFPG
      *
     C                   EVAL      WSkipRec = 'N'
     C                   ADD       1             RRN
     C                   MOVEA     '000000'      *IN(32)
     C                   EVAL      *IN87 = *OFF
      *
      ** Protect fields during Enquiry Mode
      *
     C                   IF        PMODE = 'E'
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN79 = *ON
     C                   EVAL      *IN87 = *ON
     C                   EVAL      *IN88 = *ON
     C                   ENDIF
      *
     C                   IF        (WkMode <> 'ADD')
     C                   SELECT
     C                   WHEN      #LCDT  <> 0  AND  MALCDT  <> #lcdt
     C                   EVAL      WSkipRec = 'Y'
      *
     C                   WHEN      #CHTP  <> *BLANK  AND  MALCTP  <> #CHTP
     C                   EVAL      WSkipRec = 'Y'
      *
     C                   ENDSL
     C                   ENDIF
      *
     C                   IF        WSkipRec = 'N'
      *
      ** Clear subfile fields
      *
     C                   EXSR      SRClrScrn
      *
      ** If CHANGE mode, load subfile fields
      *
     C                   IF        WkMode    <>   'ADD'
     C                   EXSR      SRMove
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
     C                   EVAL      *IN81 = *ON
      *
      ** If SFLRCD invalid, note that errors present
      *
     C                   IF        *IN83 and *IN40 = '0'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
      *
      ** Set screen conditioning indicators
      *
     C                   EXSR      SRProtect
      *
     C                   WRITE     XX000101S0
      *
     C                   ELSE
     C                   SUB       1             RRN
     C                   ENDIF
      *
      ** End of File
      *
     C     WkMode        IFNE      'ADD'
     C                   READ      @XXINEXL1                              82
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   Z-ADD     RRN           WkNoSFLRcd
      *
     C                   ENDSR
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
     C                   IF        WkMode   = 'ADD'
     C                   EVAL      *IN89    = *ON
     C                   EVAL      *IN37    = *OFF
     C                   ELSE
     C                   EVAL      *IN89    = *OFF
     C                   EVAL      *IN37    = *OFF
     C                   ENDIF
      *
      ** PUTOVR unless conditioned fields change
      *
     C                   EVAL      *IN86 = *ON
     C                   IF        *IN89 <> CAIN89 OR *IN81 <> CAIN81
     C                   EVAL      *IN86 = *OFF
     C                   ENDIF
      *
     C                   EVAL      CAIN89 = *IN89
     C                   EVAL      CAIN81 = *IN81
      *
      ** Display appropriate Header depending upon Mode whether it is
      ** Enquiry or Maintenance
      *
     C                   IF        PMODE = 'E'
     C                   EVAL      *IN31 = *ON
     C                   ENDIF
      *
      ** Set cursor by *SET CURSOR data
      *
     C                   TIME                    #TIME
     C                   WRITE     XX000101C1
     C                   WRITE     XX000101F0
     C                   EXFMT     XX000101C0
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
     C                   IF        WkMode   <> 'ADD' and WPOSN <> SFLPosn
     C                   EXSR      SRReload
     C                   ENDIF
      *
      ** Quit if reload requested
      *
     C     RELOADSF      IFNE      'Y'
      *
     C                   IF        *IN81 = *ON
     C                   EVAL      WKIPIN = 'N'
      *
      ** Process subfile records
      *
     C                   EXSR      SRSubfileRec
      *
      ** Update DBF from subfile
      *
     C                   IF        (*IN40 <> *ON) and (WKIPIN = 'Y')
     C                   EXSR      SRUpdate
     C                   ENDIF
      *
      ** If an error already exists with the data on file, still allow deletion.
      *
     C                   IF        (#SELC = 'D') and (*IN40 = *ON)
     C                             and (WKIPIN = 'Y')
     C                   EXSR      SRUpdate
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Switch between *ADD/*CHANGE modes is allowed when no errors
      ** exists during update
      *
     C                   IF        *IN09 and *IN40 = '0'
     C                   EXSR      SRMode
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
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
     C                   READC     XX000101S0                             62
      *
     C                   DOW       *IN62 = *OFF
     C                   EXSR      SRAction
     C                   EVAL      *IN87 = *OFF
     C                   EXSR      SRProtect
     C                   UPDATE    XX000101S0
     C                   READC     XX000101S0                             62
     C                   ENDDO
      *
     C                   ENDSR
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
     C                   MOVEA     '00'          *IN(83)
      *
      ** Check for null record if action is Insert
      *
     C                   IF        WkMode  = 'ADD'
     C                   EXSR      SRNullRecord
     C                   ENDIF
      *
      ** If not null record, continue
      *
     C     W0NLR         IFNE      'Y'
     C                   EVAL      WKIPIN = 'Y'
      *
     C                   EVAL      *IN84 = *ON
      *
      ** Validate record
      *
     C                   EXSR      SRValidKey
      *
      ** Seton Global Error Indicator if error exists
      *
     C                   IF        *IN83 = *ON
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
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
     C                   EVAL      W0NLR = 'N'
      *
     C     #AINC1        IFEQ      *BLANKS
     C     #AINC2        ANDEQ     *BLANKS
     C     #APLA1        ANDEQ     *BLANKS
     C     #ASRVL        ANDEQ     *BLANKS
     C                   EVAL      W0NLR = 'Y'
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidKey - Validate Subfile Record                          *
      *                                                               *
      * Called by: SRAction                                           *
      *                                                               *
      * Calls    : SRZasnms, SRValidate                               *
      *                                                               *
      *****************************************************************
      *
     C     SRValidKey    BEGSR
      *
      ** In Add mode, need to move screen value to hidden file field
      *
     C                   IF        WkMode    =   'ADD'
     C                   EVAL      ##AINC1   =    #AINC1
     C                   ENDIF
      *
      ** 'From' Income and Expense Account cannot be blank.
      *
     C                   IF        #AINC1   =    *BLANKS
     C                   EVAL      *IN33    =    *ON
     C                   EVAL      *IN83    =    *ON
     C                   EVAL      PZMsgID  =    'SDX0021'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Validate Action
      *
     C                   IF        (#SELC <> 'D') and (#SELC <> *BLANKS)
     C                             AND (PMODE = 'M')
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
      *
      **  Send message: 'Invalid Action Code'
      *
     C                   EVAL      PZMsgID = 'SDX0023'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Validate subfile record relations
      *
     C                   IF        WkMode    =   'ADD'   OR
     C                             WkMode    =   'CHG'
     C                   EXSR      SRValidate
     C                   END
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate Subfile Record Relations                *
      *                                                               *
      * Called by: SRLoad, SRValidKey                                 *
      *                                                               *
      * Calls    : SRVackrl, SRZasnms                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRValidate    BEGSR
      *
      ** Validate 'From' Income and Expense Account
      ** ==========================================
      *
      *  If 'From' Income and Expense Account was entered with "?",
      *  display the account codes selection window.
      *
     C                   MOVEL     #AINC1        WK1X01
     C     WK1X01        IFEQ      '?'                                          Account Code
     C                   MOVEL     #AINC1        WKACCD
     C                   EXSR      SRVackrl
     C     *IN41         IFEQ      *ON
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Invalid selection of a/c code for Income/Expense a/c 1.
     C                   EVAL      PZMsgID = 'SDX0024'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
     C                   EVAL      #AINC1 = WKACCD
     C                   ENDIF
     C                   ENDIF
      *
      *  'From' Income and Expense Account cannot be blanks and
      *  must be numeric.
      *
     C     #AINC1        IFEQ      *BLANKS
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Income and Expense 1 Account is invalid
     C                   EVAL      PZMsgID = 'SDX0025'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
     C                   TESTN                   #AINC1               70
     C     *IN70         IFEQ      '0'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Income and Expense 1 Account is invalid
     C                   EVAL      PZMsgID = 'SDX0025'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Error if 'From' range already exists as an End Range.
      *
     C                   MOVE      #AINC1        #FromKey
     C     #FromKey      CHAIN     @XXINEXL2                          62
     C     *IN62         IFEQ      '0'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0029'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** 'From' Income & Expense a/c must be valid a/c if
      ** if 'To' a/c is not specified.
      *
     C                   IF        #AINC2    =  *BLANKS
      *
     C                   CALL      'AOACODR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      #AINC1        @ACCD            10
     C     SDACOD        PARM      SDACOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      *IN33    =  *ON
     C                   EVAL      *IN83    =  *ON
     C                   EVAL      PZMsgID  =  'SDX0044'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate 'To' Income and Expense Account
      ** ========================================
      *
      ** The 'To' field is optional.
      *
     C     #AINC2        IFNE      *BLANKS
      *
      *  If 'To' Income and Expense Account was entered with "?",
      *  display the account codes selection window.
      *
     C                   MOVEL     #AINC2        WK1X01
     C     WK1X01        IFEQ      '?'                                          Account Code
     C                   MOVEL     #AINC2        WKACCD
     C                   EXSR      SRVackrl
     C     *IN41         IFEQ      *ON
     C                   EVAL      *IN34 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Invalid selection of a/c code for Income/Expense a/c 2.
     C                   EVAL      PZMsgID = 'SDX0022'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
     C                   EVAL      #AINC2 = WKACCD
     C                   ENDIF
     C                   ENDIF
      *
      ** If entered, the 'To' Income and Expense Account
      ** must be numeric.
      *
     C                   TESTN                   #AINC2               70
     C     *IN70         IFEQ      '0'
     C                   EVAL      *IN34 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Income and Expense 2 Account is invalid
     C                   EVAL      PZMsgID = 'SDX0026'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** End Range cannot be the same or less than Start Range
      *
     C     #AINC2        IFLE      #AINC1
     C                   EVAL      *IN34 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0035'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Error if 'To' range already exists as a Start Range
      *
     C                   MOVE      #AINC2        #ToKey
     C     #ToKey        CHAIN     @XXINEXL1                          62
     C     *IN62         IFEQ      '0'
     C                   EVAL      *IN34 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0030'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Profit and Loss Account
      ** ================================
      *
      ** If Profit and Loss Account was entered with "?",
      ** display the account codes selection window.
      *
     C                   MOVEL     #APLA1        WK1X01
     C     WK1X01        IFEQ      '?'                                          Account Code
     C                   MOVEL     #APLA1        WKACCD
     C                   EXSR      SRVackrl
     C     *IN41         IFEQ      *ON
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Invalid selection of a/c code for Profit and Loss a/c.
     C                   EVAL      PZMsgID = 'SDX0037'
     C                   EXSR      SRZasnms
     C                   ELSE

     C                   EVAL      #APLA1 = WKACCD
     C                   ENDIF
     C                   ENDIF
      *
      ** Profit and Loss Account cannot be blank
      *
     C     #APLA1        IFEQ      *BLANKS
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0027'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      **  The Profit and Loss Account is mandatory and
      **  must be numeric.
      *
     C                   TESTN                   #APLA1               70
     C     *IN70         IFEQ      '0'
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send message: Profit and Loss account is invalid
     C                   EVAL      PZMsgID = 'SDX0028'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
     C                   CALL      'AOACODR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      #APLA1        @ACCD            10
     C     SDACOD        PARM      SDACOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Profit and Loss account is invalid
     C                   EVAL      PZMsgID = 'SDX0028'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Profit and Loss account cannot be a Title Only Account
      *
     C     A5TOIN        IFEQ      'Y'
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0036'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Profit and Loss account cannot be equal to the
      ** system level Profit/Loss Account from the GL ICD.
      *
     C     #APLA1        IFEQ      BKPLAC
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0039'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Spot Revaluation Account
      ** =================================
      *
      ** Entry of the Spot Revaluation account is optional.
      *
     C     #ASRVL        IFNE      *BLANKS
      *
      ** If Spot Revaluation Account was entered with "?",
      ** display the account codes selection window.
      *
     C                   MOVEL     #ASRVL        WK1X01
     C     WK1X01        IFEQ      '?'                                          Account Code
     C                   MOVEL     #ASRVL        WKACCD
     C                   EXSR      SRVackrl
     C     *IN41         IFEQ      *ON
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Invalid selection of a/c code for Spot Revaluation a/c.
     C                   EVAL      PZMsgID = 'SDX0040'
     C                   EXSR      SRZasnms
     C                   ELSE

     C                   EVAL      #ASRVL = WKACCD
     C                   ENDIF
     C                   ENDIF
      *
      **  If entered, the Spot Revaluation Account
      **  must be numeric.
      *
     C                   TESTN                   #ASRVL               70
     C     *IN70         IFEQ      '0'
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send message: Spot Revaluation account is invalid
     C                   EVAL      PZMsgID = 'SDX0042'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
     C                   CALL      'AOACODR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      #ASRVL        @ACCD            10
     C     SDACOD        PARM      SDACOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Spot Revaluation account is invalid
     C                   EVAL      PZMsgID = 'SDX0042'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Spot Revaluation account cannot be a Title Only Account
      *
     C     A5TOIN        IFEQ      'Y'
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0041'
     C                   EXSR      SRZasnms
     C                   ENDIF

      ** Spot Trading account cannot be equal to the
      ** system level Spot Trading account code from the Trading ICD.
      *
     C     #ASRVL        IFEQ      BLSPTA
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0043'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Spot Trading a/c cannot be blank.
     C                   EVAL      PZMsgID = 'SDX0073'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVackrl - Select existing account code record.               *
      *                                                               *
      * Called by: SRValidate                                         *
      *                                                               *
      * Calls    : 'SD0031S', SRZasnms                                *
      *                                                               *
      *****************************************************************
      *
     C     SRVackrl      BEGSR
      *
     C                   EVAL      *IN41 = *OFF
      * Name search required?
     C                   CALL      'SD0031S'                            90      Select Account
     C                   PARM      *BLANK        W0RTN             7
     C     WKACCD        PARM      WKACCD        WQ0010           10
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'SDX0038'     W0RTN
      * Send message '*Error occured on CALL...'
     C                   EVAL      PZMsgID  =    'SDX0038'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'Y2U0016'
     C                   EVAL      *IN41 = *ON
     C                   END
      *
     C     VAEXIT        ENDSR
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
     C                   IF        WkMode  = 'ADD'
     C                   EVAL      RELOADSF  = 'Y'
     C                   ELSE
     C                   EVAL      RELOADSF  = 'N'
     C                   ENDIF
      *
      ** Process all modified subfile records
      *
     C                   READC     XX000101S0                             62
      *
     C                   DOW       *IN62 = *OFF
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
     C                   EXSR      SRProtect
     C                   UPDATE    XX000101S0
     C                   READC     XX000101S0                             62
     C                   ENDDO
      *
      ** Cancel reload if errors occur
      *
     C                   IF        *IN40       =   *ON
     C                   EVAL      RELOADSF    =   'N'
     C                   ENDIF
      *
     C                   ENDSR
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
     C                   EVAL      *IN83 = *OFF
      *
      ** Process add request
      *
     C                   IF        WkMode   =  'ADD'
      *
     C                   EXSR      SRNullRecord
     C                   IF        W0NLR   <>  'Y'
     C                   EXSR      SRAddReq
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Process delete request
      *
     C                   IF        #SELC    =   'D'
     C                   EXSR      SRDelReq
     C                   ELSE
      *
      ** Process change request
      *
     C                   EXSR      SRUpdReq
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        *IN83 and *IN40 = *OFF
     C                   EVAL      *IN40 = *ON
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
      * Calls    : SRWrite                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRAddReq      BEGSR
      *
      ** Create Mapping Matrix
      *
     C                   EXSR      SRWrite
      *
      ** Error detected
      *
     C                   IF        W#EROR    <>  *BLANKS
     C                   MOVEA     '11111'       *IN(33)
     C                   MOVEA     '11'          *IN(83)
     C                   EVAL      *IN87     =   *OFF
     C                   ELSE
     C                   EVAL      *IN84     =   *OFF
     C                   EVAL      *IN87     =   *ON
     C                   ENDIF
      *
     C                   ENDSR
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
      ** Delete Mapping Matrix
      *
     C                   EXSR      SRDelete
      *
     C                   IF        W#EROR <> *BLANKS
      *
      ** Delete unsuccessful
      *
     C                   MOVEA     '111111'      *IN(32)
     C                   MOVEA     '11'          *IN(83)
     C                   EVAL      *IN87 = *OFF
     C                   EXSR      SRMove
     C                   ELSE
      *
      ** Blank out record and protect from entry
      *
     C                   EXSR      SRClrScrn
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      *IN87 = *ON
      *
      ** Reload subfile
      *
     C                   EVAL      RELOADSF   =    'Y'
     C                   EVAL      #PosInc1   =    *Blanks
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdReq - Process Update Request                             *
      *                                                               *
      * Called by: SRDetail                                           *
      *                                                               *
      * Calls    : SRAmend, SRMove                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdReq      BEGSR
      *
      ** Amend Income and Expense Account Details
      *
     C                   EXSR      SRAmend
      *
     C                   IF        W#EROR <> *BLANKS
     C                   MOVEA     '111111'      *IN(32)
     C                   EVAL      *IN87 = *OFF
     C                   MOVEA     '11'          *IN(83)
      *
      ** Reset subfile record if changed record
      *
     C                   EXSR      SRMove
     C                   ELSE
      *
      ** Enable entry
      *
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      *IN87 = *OFF
     C                   ENDIF
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
     C                   IF        WkMode   <> 'ADD'
     C                   EVAL      WkMode   =  'ADD'
     C                   ELSE
     C                   EVAL      WkMode   = 'CHG'
     C                   ENDIF
      *
     C                   EVAL      SFLPosn   =    *BLANKS
      *
     C                   EXSR      SRReload
      *
     C                   ENDSR
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
     C                   EVAL      RELOADSF  = 'Y'
      *
     C                   IF        *IN05
     C                   EVAL      SFLPosn     =     *BLANKS
     C                   EVAL      #SELC       =     *BLANKS
     C                   EVAL      #PosInc1    =     *Blanks
     C                   ENDIF
      *
     C                   ENDSR
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
     C                   IF        WkMode  = 'ADD'
     C                   EVAL      *IN89 = *ON
     C                   ELSE
     C                   EVAL      *IN89 = *OFF
     C                   ENDIF
      *
      ** Protect keys if change mode or updated record
      *
     C                   MOVEL     *IN87         *IN79
     C                   IF        *IN89
     C                   EVAL      *IN79 = *ON
     C                   ENDIF
      *
     C                   MOVEL     *IN87         *IN78
     C                   IF        WkMode  = 'CHG'
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN87 = *ON
     C                   ENDIF
      *
     C                   ENDSR
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
     C                   EVAL      ##DBRC      =    *BLANKS
     C                   EVAL      #RECI       =    *BLANKS
     C                   EVAL      #CHTP       =    *BLANKS
     C                   EVAL      #LCDT       =    *ZEROS
     C                   EVAL      #SELC       =    *BLANKS
     C                   EVAL      #AINC1      =    *BLANKS
     C                   EVAL      #AINC2      =    *BLANKS
     C                   EVAL      #APLA1      =    *BLANKS
     C                   EVAL      #ASRVL      =    *BLANKS
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMove - Transfer Records from XXINEXL1 to Subfile            *
      *                                                               *
      * Called by: SRLoad, SRDelReq, SRUpdReq                         *
      *                                                               *
      * Calls    : ZEDIT                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRMove        BEGSR
      *
      ** Move XXINEXL1 fields to subfile
      *
     C                   MOVEL     MAINC1        ##AINC1
     C                   MOVEL     MARECI        #RECI
     C                   MOVEL     MAINC1        #AINC1
      *
     C     MAINC2        IFEQ      0
     C                   MOVEL     *blanks       #AINC2
     C                   ELSE
     C                   MOVEL     MAINC2        #AINC2
     C                   ENDIF
      *
     C                   MOVEL     MAPLA1        #APLA1
      *
     C                   MOVEL     MASRVL        #ASRVL
      *
      ** Hold current record image for change detection
      *
     C                   EVAL      ##DBRC      =     @1DBRC
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Create Income and Expense Account Details           *
      *                                                               *
      * Called by: SRAddReq                                           *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRWrite       BEGSR
      *
     C                   EVAL      W#EROR    =   *BLANKS
      *
      ** Create Income and Expense Mapping matrix
      *
     C                   EVAL      MARECI    =   'D'
     C                   EVAL      MALCTP    =   'I'
     C                   MOVEL     #AINC1        MAINC1
     C                   MOVEL     #AINC2        MAINC2
     C                   MOVEL     #APLA1        MAPLA1
     C                   MOVEL     #ASRVL        MASRVL
     C                   Z-ADD     BJRDNB        MALCDT
      *
      ** Check for duplicate 'From' and 'To' range
      *
      ** Error if 'From' Range already exist either as a Start Range.
     C                   MOVE      #AINC1        #FromKey
     C     #FromKey      SETLL     @XXINEXL0                              60
     C                   IF        *IN60
     C                   EVAL      W#EROR    =   'Y'
     C                   EVAL      PZMsgID   =   'SDX0029'
     C                   EXSR      SRZasnms
     C                   END
      *
      ** Error if 'To' Range already exist either as an End Range
     C     #AINC2        IFNE      *BLANKS
     C                   MOVE      #AINC2        #ToKey
     C     #ToKey        SETLL     @XXINEXL2                              60
     C                   IF        *IN60
     C                   EVAL      W#EROR    =   'Y'
     C                   EVAL      PZMsgID   =   'SDX0030'
     C                   EXSR      SRZasnms
     C                   END
     C                   END
     C                   IF        *IN60
     C                   ELSE
     C                   WRITE     @XXINEXL0                            61
      *
      ** Write error detected
      *
     C                   IF        *IN61
     C                   EVAL      W#EROR = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelete - Delete Income and Expense Account Details          *
      *                                                               *
      * Called by: SRDelreq                                           *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRDelete      BEGSR
      *
      ** Delete Income and Expense mapping
      *
     C                   EVAL      W#EROR = *BLANKS
      *
      ** Setup Key Field
      *
     C                   MOVEL     #AINC1        #KeyPos
     C     #KeyPos       CHAIN     @XXINEXL0                          6061
      *
      ** Record already deleted
      *
     C                   IF        *IN60
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'SDX0031'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Record locked; Cannot allocate record.
      *
     C                   IF        *IN61
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'SDX0032'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Check for changed record
      *
     C                   IF        ##DBRC     <>   @1DBRC
     C                   EVAL      W#EROR     =    'Y'
     C                   EVAL      PZMsgID    =    'SDX0033'
     C                   EXSR      SRZasnms
      *
      ** Release record lock
      *
     C     #KeyPos       SETLL     @XXINEXL0                          6061
     C                   ELSE
      *
     C                   DELETE    @XXINEXL0                            61
      *
      ** Delete error detected
      *
     C                   IF        *IN61
     C                   EVAL      W#EROR = 'Y'
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
      * SRAmend  - Update Income and Expense Account Details          *
      *                                                               *
      * Called by: SRUpdReq                                           *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRAmend       BEGSR
      *
     C                   EVAL      W#EROR = *BLANKS
      *
      ** Set record data changed flag
      *
     C                   EVAL      YCRDC = 'N'
      *
      ** Move key fields to XXINEXL0
      *
     C**                 EVAL      #PosInc1  =  ##AINC1
     C                   MOVEL     ##AINC1       #KeyPos
      *
     C     #KeyPos       CHAIN     @XXINEXL0                          6061
      *
      ** Record not found
      *
     C                   IF        *IN60
     C                   EVAL      W#EROR     =   'Y'
     C                   EVAL      PZMsgID    =   'SDX0034'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Record locked
      *
     C                   IF        *IN61
     C                   EVAL      W#EROR = 'Y'
     C                   ELSE
      *
      ** Check for changed record
      *
     C                   IF        ##DBRC <> @1DBRC
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'SDX0033'
     C                   EXSR      SRZasnms
     C                   UNLOCK    XXINEXL0                             61
     C                   ELSE
      *
      ** Store record data for null update check
      *
     C                   EVAL      YCRDCS = @1DBRC
      *
      ** Move fields to XXINEXL0
      *
     C                   EVAL      MARECI  =   'D'
     C                   EVAL      MALCTP  =   'A'
     C                   MOVEL     #AINC1        MAINC1
     C                   MOVEL     #AINC2        MAINC2
     C                   MOVEL     #APLA1        MAPLA1
     C                   MOVEL     #ASRVL        MASRVL
     C                   Z-ADD     BJRDNB        MALCDT
      *
     C                   IF        @1DBRC   <>   YCRDCS
     C                   EVAL      YCRDC     =   'Y'
     C                   ENDIF
      *
      ** If changed update record otherwise release record
      *
     C                   IF        YCRDC = 'Y'
     C                   UPDATE    @XXINEXL0                            61
     C                   ELSE
     C                   UNLOCK    XXINEXL0                             61
     C                   ENDIF
      *
      ** Change error detected
      *
     C                   IF        *IN61
     C                   EVAL      W#EROR = 'Y'
     C                   ELSE
      *
      ** Update saved record image
      *
     C                   EVAL      ##DBRC = @1DBRC
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
     C                   IF        PZMsgFile = *BLANKS
     C                   EVAL      PZMsgFile = 'GBXXUSRMSG'
     C                   ENDIF
      *
     C                   CALL      'ZA0340'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID
      *
     C                   EVAL      PZMsgFile = *BLANKS
      *
     C                   ENDSR
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
      ** If selection mode and F3 has been pressed
      *
      ** Terminate program
      *
     C                   EVAL      *INLR = *ON
      *
      ** Exit program
      *
     C                   RETURN
      *
     C                   ENDSR
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
     C                   CALL      'DBERRCTL'
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
(c) Misys International Banking Systems 2017
