     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2017')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  XX000102 - Mapping Matrix for Spot Trade Account Code        *
      *                                                               *
      *  Function:  This program maintains the mapping matrix to      *
      *  (I/C)      allow the user to map a Spot Trade P/L            *
      *             account code to a Spot Trade Equivalent account   *
      *             code and a Spot Revaluation account code per      *
      *             Foreign Currency.                                 *
      *                                                               *
      *  (c) Finastra International Limited 2017                      *
      *                                                               *
      *  Last Amend No. FVT102CC1           Date 05Jun17              *
      *  Prev Amend No. FVT102  *CREATE     Date 08May17              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  FVT102CC1 - Posting of P/L to Multiple Retained Earning      *
      *              Accounts (CC1)                                   *
      *  FVT102 - Posting of Profit and Loss to Multiple Retained     *
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
      *    33         Invalid Spot Trade Account Code                 *
      *    34         Invalid Foreign Currency Code                   *
      *    35         Invalid Spot Trade Equivalent Account Code      *
      *    36         Invalid Spot Revaluation Account Code           *
      *    37         Selection Mode                                  *
      *    40         Global Error Indicator                          *
      *    41         Invalid selection of drop-down window           *
      *    60         READ/CHAIN Indicator                            *
      *    61         READ Indicator                                  *
      *    62         READC Indicator                                 *
      *    70         TESTN Indicator                                 *
      *    78         Protect Spot Trade Account Code                 *
      *    79         Protect Selection Field                         *
      *    80         Subfile Clear (SFLCLR)                          *
      *    81         Subfile Display (SFLDSP)                        *
      *    82         Subfile End (SFLEND)                            *
      *    83         Force Input Format                              *
      *    84         Subfile Next Change (SFLNXTCHG)                 *
      *    86         PUTOVR Indicator                                *
      *    87         Enable Key Screen                               *
      *    88         Protect Spot Trade Equiv/Spot Reval. a/c codes  *
      *    89         Add Mode                                        *
      *    90         Selection ended in error.                       *
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
      *  SRVccysl      -  Select existing currency code record.       *
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
      *  SRChkDup      -  Check for duplicate Matrix details          *
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
     FXX000102DFCF   E             WORKSTN USROPN
     F                                     SFILE(XX000102S0:RRN)
     F                                     INFDS(INFDSDF)
     F                                     INFSR(*PSSR)
      *
      ** SD Spot Trade mapped File by MBFCCY/MBSRVL - Update Index
     FXXSRVLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(INFDSV0)
     F                                     COMMIT
     F                                     RENAME(XXSRVLD0:@XXSRVLL0)
      *
      ** SD Spot Trade mapped File by MBFCCY/MBSRVL - Retrieval Index
     FXXSRVLL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(INFDSV1)
     F                                     RENAME(XXSRVLD0:@XXSRVLL1)
      *
      ** SD Spot Trade a/c code by MBFCCY only   - Retrieval Index
     FXXSRVLL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(XXSRVLD0:@XXSRVLL2)
     F                                     PREFIX(V_)
      *
      ** SD Spot Trade mapped File by MBSPAE only - Retrieval Index
     FXXSRVLL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(XXSRVLD0:@XXSRVLL3)
     F                                     PREFIX(V_)
      *
      ** SD Spot Trade mapped File by MBSPTA only - Retrieval Index
     FXXSRVLL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(XXSRVLD0:@XXSRVLL4)
     F                                     PREFIX(V_)
      *
      ** SD Income and Expense a/c codes - Retrieval Index
     FXXINEXL3  IF   E           K DISK    INFSR(*PSSR)
      *
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
     D  SFLPosn                1     13
     D  #PosFccy               1      3
     D  #POSTRAD               4     13
      *
      ** File Information DS for XXSRVLL0
     D INFDSV0         DS
     D  FILOPV0                9      9
      *
      ** File Information DS for XXSRVLL1
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
      ** External DS for Currency Codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Current/previous master file format fields for change control
     D @1DBRC        E DS                  EXTNAME(XXSRVLL0)
      *
      ** Data Structure for record fields
     D YCRDCS          DS            38
      *
      ** Data Structure for screen fields
     D $$DBRC          DS            38
     D$$RECI                   1      1
     D$$SRVL                   2     11
     D$$FCCY                  12     14
     D$$SPAE                  15     24
     D$$SPTA                  25     34
     D$$LCDT                  35     37P 0
     D$$LCTP                  38     38
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
     D WPOSN           S              3
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
     D #AccdKey        S             10
     D #CcyKey         S              3
     D #KeyPos03       S              3
     D #KeyPos10       S             10
     D WSkipRec        S              1
     D WValid          S              1
     D WZLCDT          S                   LIKE(#LCDT)
     D WZCHTP          S                   LIKE(#CHTP)
     D WZFccy          S                   LIKE(#PosFccy)
     D WZTrad          S                   LIKE(#POSTRAD)
     D WK1X01          S              1
     D WKACCD          S             10
     D WKFCCY          S              3
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
     C                   EVAL      DBPGM    =    'XX000102'
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
     C                   OPEN      XX000102DF
      *
      *    '1' = file is open
     C     FILOPV0       IFNE      '1'
     C                   OPEN      XXSRVLL0
     C                   ENDIF
     C     FILOPV1       IFNE      '1'
     C                   OPEN      XXSRVLL1
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
     C                   MOVEL     *BLANK        #PosFccy
     C                   MOVEL     *BLANK        #POSTRAD
      *
      * Define file keys.
      *
     C     #FileKey      Klist
     C                   Kfld                    #CcyKey
     C                   Kfld                    #AccdKey
      *
     C     #FileKey2     Klist
     C                   Kfld                    #CcyKey
      *
     C     #FileKey3     Klist
     C                   Kfld                    #Accdkey
      *
     C     #KeyPos       Klist
     C                   Kfld                    #KeyPos03
     C                   Kfld                    #KeyPos10
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
     C                   WRITE     XX000102C0
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
     C                   MOVEL     #PosFccy      #KeyPos03
     C                   MOVEL     #PosTrad      #KeyPos10
     C     #KeyPos       SETLL     @XXSRVLL1                          82
     C                   READ      @XXSRVLL1                              82
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF
      *
      ** Save previous selector values
      *
     C                   EVAL      WZLCDT      =     #LCDT
     C                   EVAL      WZCHTP      =     #CHTP
     C                   EVAL      WZFccy      =     #PosFccy
     C*                  EVAL      WZYLDD      =     #PosYLCD
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
     C                   READP     @XXSRVLL1                              60
     C                   READ      @XXSRVLL1                              60
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
     C                   WHEN      #LCDT  <> 0  AND  MBLCDT  <> #lcdt
     C                   EVAL      WSkipRec = 'Y'
      *
     C                   WHEN      #CHTP  <> *BLANK  AND  MBLCTP  <> #CHTP
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
     C                   WRITE     XX000102S0
      *
     C                   ELSE
     C                   SUB       1             RRN
     C                   ENDIF
      *
      ** End of File
      *
     C     WkMode        IFNE      'ADD'
     C                   READ      @XXSRVLL1                              82
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
     C                   WRITE     XX000102C1
     C                   WRITE     XX000102F0
     C                   EXFMT     XX000102C0
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
     C                   READC     XX000102S0                             62
      *
     C                   DOW       *IN62 = *OFF
     C                   EXSR      SRAction
     C                   EVAL      *IN87 = *OFF
     C                   EXSR      SRProtect
     C                   UPDATE    XX000102S0
     C                   READC     XX000102S0                             62
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
     C     #BSRVL        IFEQ      *BLANKS
     C     #BFCCY        ANDEQ     *BLANKS
     C     #BSPAE        ANDEQ     *BLANKS
     C     #BSPTA        ANDEQ     *BLANKS
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
     C                   EVAL      ##BSRVL   =    #BSRVL
     C                   EVAL      ##BFCCY   =    #BFCCY
     C                   ENDIF
      *
      ** Spot Revaluation Account Code cannot be blank.
      *
     C                   IF        #BSRVL   =    *BLANKS
     C                   EVAL      *IN33    =    *ON
     C                   EVAL      *IN83    =    *ON
     C                   EVAL      PZMsgID  =    'SDX0058'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Validate Action
      *
     C                   IF        (#SELC <> 'D') and (#SELC <> *BLANKS)
     C                             AND (PMODE = 'M')
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     **  Send message: 'Invalid Action Code'
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
      * Calls    : SRVackrl, SRVccysl, SRZasnms                       *
      *                                                               *
      *****************************************************************
      *
     C     SRValidate    BEGSR
      *
      ** Validate Spot Trade Account
      ** =============================
      *
      ** Entry of the Spot Trade account is Mandatory
      *
      ** If Spot Trading Account was entered with "?",
      ** display the account codes selection window.
      *
     C                   MOVEL     #BSRVL        WK1X01
     C     WK1X01        IFEQ      '?'                                          Account Code
     C                   MOVEL     #BSRVL        WKACCD
     C                   EXSR      SRVackrl
     C     *IN41         IFEQ      *ON
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Invalid selection of a/c code for Spot Trade a/c.
     C                   EVAL      PZMsgID = 'SDX0040'
     C                   EXSR      SRZasnms
     C                   ELSE

     C                   EVAL      #BSRVL = WKACCD
     C                   ENDIF
     C                   ENDIF
      *
      **  If entered, the Spot Trade Account
      **  must be numeric.
      *
     C                   TESTN                   #BSRVL               70
     C     *IN70         IFEQ      '0'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send message: Spot Trade account is invalid
     C                   EVAL      PZMsgID = 'SDX0042'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
     C                   CALL      'AOACODR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      #BSRVL        @ACCD            10
     C     SDACOD        PARM      SDACOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Spot Trade account is invalid
     C                   EVAL      PZMsgID = 'SDX0042'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Spot Trade account cannot be a Title Only Account
      *
     C     A5TOIN        IFEQ      'Y'
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0041'
     C                   EXSR      SRZasnms
     C                   ENDIF

      ** Spot Trade account cannot be equal to the
      ** system level Spot Trade account code from the Trading ICD.
      *
     C     #BSRVL        IFEQ      BLSPTA
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0043'
     C                   EXSR      SRZasnms
     C                   ENDIF

      ** Spot Trade account must be defined as Spot Trade Account
      ** in Income and Expense Mapping Table.
      *
     C     #BSRVL        CHAIN     XXINEXL3
     C                   IF        not %Found(XXINEXL3)
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0074'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Foreign Currency Code
      ** ==============================
      *
      *  If Foreign Currency Code was entered with "?",
      *  display the currency codes selection window.
      *
     C                   MOVEL     #BFCCY        WK1X01
     C     WK1X01        IFEQ      '?'                                          Account Code
     C                   MOVEL     #BFCCY        WKFCCY
     C                   EXSR      SRVccysl
     C     *IN41         IFEQ      *ON
     C                   EVAL      *IN34 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Invalid selection of currency code for Foreign Currency.
     C                   EVAL      PZMsgID = 'SDX0045'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
     C                   EVAL      #BFCCY = WKFCCY
     C                   ENDIF
     C                   ENDIF
      *
      ** Foreign Currency Code cannot be blank if
      ** Spot Revaluation A/c has been entered.
      *
     C     #BFCCY        IFEQ      *BLANKS
     C     #BSRVL        ANDNE     *BLANKS
     C                   EVAL      *IN34 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0051'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Access currency details
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    #BFCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      *IN34 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Foreign Currency is invalid
     C                   EVAL      PZMsgID = 'SDX0052'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***Foreign*Currency*Code*cannot*be*equal*to*the                          FVT102CC1
      ***system*Base*Currency.                                                 FVT102CC1
      **********                                                               FVT102CC1
     C*****#BFCCY        IFEQ      BJCYCD                                      FVT102CC1
     C**********         EVAL      *IN34 = *ON                                 FVT102CC1
     C**********         EVAL      *IN83 = *ON                                 FVT102CC1
     C**********         EVAL      PZMsgID = 'SDX0060'                         FVT102CC1
     C**********         EXSR      SRZasnms                                    FVT102CC1
     C**********         ENDIF                                                 FVT102CC1
      *
      ** Validate Spot Revaluation Equivalent Account
      ** ============================================
      *
      ** If Spot Revaluation Equivalent Account was entered with "?",
      ** display the account codes selection window.
      *
     C                   MOVEL     #BSPAE        WK1X01
     C     WK1X01        IFEQ      '?'                                          Account Code
     C                   MOVEL     #BSPAE        WKACCD
     C                   EXSR      SRVackrl
     C     *IN41         IFEQ      *ON
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Invalid selection of a/c code for Spot Reval Equivalent a/c.
     C                   EVAL      PZMsgID = 'SDX0059'
     C                   EXSR      SRZasnms
     C                   ELSE

     C                   EVAL      #BSPAE = WKACCD
     C                   ENDIF
     C                   ENDIF
      *
      ** Spot Trade Equivalent a/c cannot be blank if
      ** Spot Trade A/c has been entered.
      *
     C     #BSPAE        IFEQ      *BLANKS
     C     #BSRVL        ANDNE     *BLANKS
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0047'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      **  The Spot Trade Equivalent account is mandatory and
      **  must be numeric.
      *
     C                   TESTN                   #BSPAE               70
     C     *IN70         IFEQ      '0'
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send message: Spot Trade account is invalid
     C                   EVAL      PZMsgID = 'SDX0048'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
     C                   CALL      'AOACODR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      #BSPAE        @ACCD            10
     C     SDACOD        PARM      SDACOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Spot Trade account is invalid
     C                   EVAL      PZMsgID = 'SDX0048'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Spot Trade Equivalent account cannot be a Title Only Account
      *
     C     A5TOIN        IFEQ      'Y'
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0049'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Spot Trade Equivalent account cannot be equal to the
      ** foreign currency Spot Trade Equivalent account from
      ** the Currency Details record SDCURRPD.
      *
     C     #BSPAE        IFEQ      A6SPAE
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0050'
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
      ** If Spot Revaluation Account was entered with "?",
      ** display the account codes selection window.
      *
     C                   MOVEL     #BSPTA        WK1X01
     C     WK1X01        IFEQ      '?'                                          Account Code
     C                   MOVEL     #BSPTA        WKACCD
     C                   EXSR      SRVackrl
     C     *IN41         IFEQ      *ON
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Invalid selection of a/c code for Spot Trade Account.
     C                   EVAL      PZMsgID = 'SDX0053'
     C                   EXSR      SRZasnms
     C                   ELSE

     C                   EVAL      #BSPTA = WKACCD
     C                   ENDIF
     C                   ENDIF
      *
      ** Spot Trade Account cannot be blank if
      ** Spot Revaluation A/c has been entered.
      *
     C     #BSPTA        IFEQ      *BLANKS
     C     #BSRVL        ANDNE     *BLANKS
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0057'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      **  If entered, the Spot Trade Account
      **  must be numeric.
      *
     C                   TESTN                   #BSPTA               70
     C     *IN70         IFEQ      '0'
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send message: Spot Trade Account is invalid
     C                   EVAL      PZMsgID = 'SDX0054'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
     C                   CALL      'AOACODR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      #BSPTA        @ACCD            10
     C     SDACOD        PARM      SDACOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
      ** Send msg: Spot Revaluation Account is invalid
     C                   EVAL      PZMsgID = 'SDX0054'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Spot Revalutation Account cannot be a Title Only Account
      *
     C     A5TOIN        IFEQ      'Y'
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0055'
     C                   EXSR      SRZasnms
     C                   ENDIF

      ** Spot Revaluation Account cannot be equal to the
      ** system level Spot Revaluation Account Code from the Trading ICD.
      *
     C     #BSPTA        IFEQ      BLSRAC
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0056'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      **  If no other errors yet, cross validate between account codes.
      *
     C     *IN83         IFEQ      *OFF
      *
      ** Spot Trad a/c entered cannot be the same a/c code
      ** as the Spot Trad Equiv a/c.
      *
     C     #BSRVL        IFEQ      #BSPAE
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0068'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Spot Trade a/c entered cannot be the same a/c code
      ** as the Spot Revaluation a/c.
      *
     C     #BSRVL        IFEQ      #BSPTA
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0069'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Spot Trad Equiv. a/c entered cannot be the same a/c code
      ** as the Spot Revaluation a/c.
      *
     C     #BSPAE        IFEQ      #BSPTA
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'SDX0070'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
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
      * SRVccysl - Select existing currency code record.              *
      *                                                               *
      * Called by: SRValidate                                         *
      *                                                               *
      * Calls    : 'SD0020S', SRZasnms                                *
      *                                                               *
      *****************************************************************
      *
     C     SRVccysl      BEGSR
      *
     C                   EVAL      *IN41 = *OFF
      * Name search required?
     C                   CALL      'SD0020S'                            90      Select Currency
     C                   PARM      *BLANK        W0RTN             7
     C     WKFCCY        PARM      WKFCCY        WQ0003            3
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'SDX0046'     W0RTN
      * Send message '*Error occured on CALL...'
     C                   EVAL      PZMsgID  =    'SDX0046'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'Y2U0016'
     C                   EVAL      *IN41 = *ON
     C                   END
      *
     C     VCEXIT        ENDSR
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
     C                   READC     XX000102S0                             62
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
     C                   UPDATE    XX000102S0
     C                   READC     XX000102S0                             62
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
     C                   EVAL      #PosFccy   =    *Blanks
     C                   EVAL      #POSTRAD   =    *Blanks
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
      ** Amend Spot Revaluation Account Details
      *
     C                   EXSR      SRAmend
      *
     C                   IF        W#EROR <> *BLANKS
     C                   EVAL      *IN87 = *OFF
     C                   MOVEA     '11'          *IN(83)
      *
      ** DO NOT reset subfile record if changed record
      *
     C*************      EXSR      SRMove
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
     C                   EVAL      #PosFccy    =     *Blanks
     C                   EVAL      #POSTRAD    =     *Blanks
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
     C                   MOVEL     *IN87         *IN88
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
     C                   EVAL      #BSRVL      =    *BLANKS
     C                   EVAL      #BFCCY      =    *BLANKS
     C                   EVAL      #BSPAE      =    *BLANKS
     C                   EVAL      #BSPTA      =    *BLANKS
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMove - Transfer Records from XXSRVLL1 to Subfile            *
      *                                                               *
      * Called by: SRLoad, SRDelReq, SRUpdReq                         *
      *                                                               *
      * Calls    : ZEDIT                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRMove        BEGSR
      *
      ** Move XXSRVLL1 fields to subfile
      *
     C                   MOVEL     MBSRVL        ##BSRVL
     C                   MOVEL     MBFCCY        ##BFCCY
     C                   MOVEL     MBRECI        #RECI
     C                   MOVEL     MBSRVL        #BSRVL
     C                   MOVEL     MBFCCY        #BFCCY
     C                   MOVEL     MBSPAE        #BSPAE
     C                   MOVEL     MBSPTA        #BSPTA
      *
      ** Hold current record image for change detection
      *
     C                   EVAL      ##DBRC      =     @1DBRC
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Create Spot Revaluation Account Details             *
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
      ** Check for duplicate Spot Reval a/c code & Foreign Currency combination.
      ** Error if found.
      *
     C                   MOVE      #BFCCY        #CcyKey
     C                   MOVEL     #BSRVL        #AccdKey
      *
     C     #FileKey      SETLL     @XXSRVLL0                              60
     C                   IF        *IN60
     C                   EVAL      W#EROR    =   'Y'
     C                   EVAL      *IN33 = *ON                                  spot reval a/c
     C                   EVAL      *IN34 = *ON                                  currency
     C                   EVAL      PZMsgID   =   'SDX0061'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Check for duplicate account codes between the values
      ** on this matrix.
      *
     C                   EXSR      SRChkDup
      *
     C                   IF        W#EROR = 'Y'
     C                   ELSE
      *
      ** Create Spot Revaluation Account Mapping matrix
      *
     C                   EVAL      MBRECI    =   'D'
     C                   MOVEL     #BSRVL        MBSRVL
     C                   MOVEL     #BFCCY        MBFCCY
     C                   MOVEL     #BSPAE        MBSPAE
     C                   MOVEL     #BSPTA        MBSPTA
     C                   Z-ADD     BJRDNB        MBLCDT
     C                   EVAL      MBLCTP    =   'I'
      *
     C                   WRITE     @XXSRVLL0                            61
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
      * SRDelete - Delete Spot Revaluation Account Details            *
      *                                                               *
      * Called by: SRDelreq                                           *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRDelete      BEGSR
      *
      ** Delete Spot Revaluation mapping
      *
     C                   EVAL      W#EROR = *BLANKS
      *
      ** Setup Key Field
      *
     C                   MOVE      #BFCCY        #KeyPos03
     C                   MOVEL     #BSRVL        #KeyPos10
     C     #KeyPos       CHAIN     @XXSRVLL0                          6061
      *
      ** Record already deleted
      *
     C                   IF        *IN60
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      *IN33 = *ON                                  spot reval a/c
     C                   EVAL      *IN34 = *ON                                  currency
     C                   EVAL      PZMsgID = 'SDX0031'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Record locked; Cannot allocate record.
      *
     C                   IF        *IN61
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      *IN33 = *ON                                  spot reval a/c
     C                   EVAL      *IN34 = *ON                                  currency
     C                   EVAL      PZMsgID = 'SDX0032'
     C                   EXSR      SRZasnms
     C                   ELSE
      *
      ** Check for changed record
      *
     C                   IF        ##DBRC     <>   @1DBRC
     C                   EVAL      W#EROR     =    'Y'
     C                   EVAL      *IN33 = *ON                                  spot reval a/c
     C                   EVAL      *IN34 = *ON                                  currency
     C                   EVAL      PZMsgID    =    'SDX0033'
     C                   EXSR      SRZasnms
      *
      ** Release record lock
      *
     C     #KeyPos       SETLL     @XXSRVLL0                          6061
     C                   ELSE
      *
     C                   DELETE    @XXSRVLL0                            61
      *
      ** Delete error detected
      *
     C                   IF        *IN61
     C                   EVAL      W#EROR = 'Y'
     C                   ENDIF
      *
      ** Reset key to subfile for re-display of screen.
      *
     C                   MOVE      *BLANKS       #KeyPos03
     C                   MOVE      *BLANKS       #KeyPos10
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
      * SRAmend  - Update Spot Revaluation Account Details            *
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
      ** Check for duplicate account codes between the values
      ** on this matrix.
      *
     C                   EXSR      SRChkDup
      *
     C                   IF        W#EROR = 'Y'
     C                   ELSE
      ** Set record data changed flag
      *
     C                   EVAL      YCRDC = 'N'
      *
      ** Move key fields to XXSRVLL0
      *
     C                   MOVE      ##BFCCY       #KeyPos03
     C                   MOVEL     ##BSRVL       #KeyPos10
      *
     C     #KeyPos       CHAIN     @XXSRVLL0                          6061
      *
      ** Record not found
      *
     C                   IF        *IN60
     C                   EVAL      W#EROR     =   'Y'
     C                   EVAL      *IN33 = *ON                                  spot reval a/c
     C                   EVAL      *IN34 = *ON                                  currency
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
     C                   EVAL      *IN33 = *ON                                  spot reval a/c
     C                   EVAL      *IN34 = *ON                                  currency
     C                   EVAL      PZMsgID = 'SDX0033'
     C                   EXSR      SRZasnms
     C                   UNLOCK    XXSRVLL0                             61
     C                   ELSE
      *
      ** Store record data for null update check
      *
     C                   EVAL      YCRDCS = @1DBRC
      *
      ** Move fields to XXSRVLL0
      *
     C                   EVAL      MBRECI  =   'D'
     C                   EVAL      MBLCTP  =   'A'
     C                   MOVEL     #BSRVL        MBSRVL
     C                   MOVEL     #BFCCY        MBFCCY
     C                   MOVEL     #BSPAE        MBSPAE
     C                   MOVEL     #BSPTA        MBSPTA
     C                   Z-ADD     BJRDNB        MBLCDT
      *
     C                   IF        @1DBRC   <>   YCRDCS
     C                   EVAL      YCRDC     =   'Y'
     C                   ENDIF
      *
      ** If changed update record otherwise release record
      *
     C                   IF        YCRDC = 'Y'
     C                   UPDATE    @XXSRVLL0                            61
     C                   ELSE
     C                   UNLOCK    XXSRVLL0                             61
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
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkDup - Check for duplicate Matrix details                 *
      *                                                               *
      * Called by: SRWrite, SRAmend                                   *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRChkDup      BEGSR
      *
      ** Read through Spot Reval Matrix by Foreign Currency.
      *
     C                   MOVE      #BFCCY        #CcyKey
     C     #FileKey2     SETLL     @XXSRVLL2                              60
     C     #FileKey2     READE     @XXSRVLL2                              60
     C     *IN60         DOWEQ     *OFF
      *
      ** Spot Reval a/c cannot be a Spot Trade a/c already
      ** existing for this currency (other than this record).
      *
     C                   IF        #BSRVL = V_MBSPTA
     C                   EVAL      W#EROR    =   'Y'
     C                   EVAL      *IN33 = *ON                                  spot reval a/c
     C                   EVAL      *IN34 = *ON                                  currency
     C                   EVAL      PZMsgID   =   'SDX0062'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Spot Reval a/c cannot be a Spot Trade Equiv. a/c already
      ** existing for this currency (other than this record).
      *
     C                   IF        #BSRVL = V_MBSPAE
     C                   EVAL      W#EROR    =   'Y'
     C                   EVAL      *IN33 = *ON                                  spot reval a/c
     C                   EVAL      *IN34 = *ON                                  currency
     C                   EVAL      PZMsgID   =   'SDX0063'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Spot Trade Equiv. a/c cannot be a Spot Reval a/c already
      ** existing for this currency (other than this record).
      *
     C                   IF        #BSPAE = V_MBSRVL
     C                   EVAL      W#EROR    =   'Y'
     C                   EVAL      *IN35 = *ON                                  spot trade equiv
     C                   EVAL      *IN34 = *ON                                  currency
     C                   EVAL      PZMsgID   =   'SDX0064'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Spot Trade Equiv. a/c cannot be a Spot Trade a/c already
      ** existing for this currency (other than this record).
      *
     C                   IF        #BSPAE = V_MBSPTA
     C                   EVAL      W#EROR    =   'Y'
     C                   EVAL      *IN35 = *ON                                  spot trade equiv
     C                   EVAL      *IN34 = *ON                                  currency
     C                   EVAL      PZMsgID   =   'SDX0065'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Spot Tradei a/c cannot be a Spot Reval a/c already
      ** existing for this currency (other than this record).
      *
     C                   IF        #BSPTA = V_MBSRVL
     C                   EVAL      W#EROR    =   'Y'
     C                   EVAL      *IN36 = *ON                                  spot trade a/c
     C                   EVAL      *IN34 = *ON                                  currency
     C                   EVAL      PZMsgID   =   'SDX0066'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Spot Trade a/c cannot be a Spot Trade Equiv. a/c already
      ** existing for this currency (other than this record).
      *
     C                   IF        #BSPTA = V_MBSPAE
     C                   EVAL      W#EROR    =   'Y'
     C                   EVAL      *IN36 = *ON                                  spot trade a/c
     C                   EVAL      *IN34 = *ON                                  currency
     C                   EVAL      PZMsgID   =   'SDX0067'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Read next Spot Reval record.
      *
     C     #FileKey2     READE     @XXSRVLL2                              60
     C                   ENDDO
      *
      *---------------------------------------------------------------------
      *
      **  Spot Trade Equivalent a/c and Spot Trade a/c must be unique
      **  across all currencies in the matrix.  Check if individual screen
      **  fields have changed before each validation.
      *
     C                   EVAL      $$DBRC      =     ##DBRC
      *
      **  Spot Trade Equivalent a/c can only exist once across
      **  all currencies (other than this record).
      *
     C                   IF        #BSPAE <> $$SPAE
     C                   MOVE      #BSPAE        #AccdKey
     C     #FileKey3     SETLL     @XXSRVLL3                              60
     C                   IF        *IN60
     C                   EVAL      W#EROR    =   'Y'
     C                   EVAL      *IN35 = *ON                                  spot trade equiv
     C                   EVAL      PZMsgID   =   'SDX0071'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
      *---------------------------------------------------------------------
      *
     C     EndChkDup     ENDSR
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
