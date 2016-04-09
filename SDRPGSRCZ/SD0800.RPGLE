     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Authorised Booking Branches for Customers')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      * SD0800 - Midas SD Authorised Booking Branches for Customers.  *
      *                                                               *
      *  Function:  This program displays a list of authorised        *
      *             booking Branches for Customer.                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CGL052             Date 02Dec15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG7305            Date 24May05               *
      *                 CDL029A            Date 09May05               *
      *                 CDL029             Date 23NOV04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL052 - Amend Washout Processing (Recompile)                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7305- Show the Customer Shortname instead of Number       *
      *  CDL029A- Adding new field                                    *
      * CDL029 - Midas SD Authorised Booking Branches for Customersnts*
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         F3 Exit                                         *
      *    05         F5 Refresh                                      *
      *    09         F9 Add/Change Mode                              *
      *    27         Rollup/Rolldown Key                             *
      *    30         Invalid Customer Branch                         *
      *    31         Invalid Booking  Branch                         *
      *    32         Invalid Selection                               *
      *    40         Global Error Indicator                          *
      *    41         Maintenance/Enquiry Mode                        *
      *    60         READ/CHAIN Indicator                            *
      *    61         READ Indicator                                  *
      *    62         READC Indicator                                 *
      *    79         Protect Selection Field                         *
      *    80         Subfile Clear (SFLCLR)                          *
      *    81         Subfile Display (SFLDSP)                        *
      *    82         Subfile End (SFLEND)                            *
      *    83         Force Input Format                              *
      *    86         PUTOVR Indicator                                *
      *    87         Enable Key Screen                               *
      *    89         Add Mode                                        *
      *    94         Subfile Next Change (SFLNXTCHG)                 *
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
      *  SRValidKey    -  Validate subfile record                     *
      *  SRValidate    -  Validate subfile record relations           *
      *  SRUpdate      -  Update records from subfile                 *
      *  SRDetail      -  Process action requested                    *
      *  SRAddReq      -  Process add request                         *
      *  SRDelReq      -  Process delete request                      *
      *  SRTrailer     -  Update Control Files                        *
      *  SRMode        -  Switch between *ADD and *CHANGE modes       *
      *  SRReload      -  Request subfile reload                      *
      *  SRClrScrn     -  Initialise subfile record                   *
      *  SRMove        -  Transfer records from SDABBCY1 to subfile   *
      *  SRWrite       -  Create Authorised Booking Branch            *
      *  SRDelete      -  Delete Authorised Booking Branch            *
      *  SRZasnms      -  Message handling subroutine                 *
      *  SREnd         -  End program                                 *
      *  *PSSR         -  Error handling subroutine                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSD0800DF  CF   E             WORKSTN USROPN
     F                                     SFILE(SD0800S0:@@RRN)
     F                                     INFSR(*PSSR)
      ** Midas SD Authorisation DL Adjustments Function Display

     FSDABBCL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(SDABBCD0:SDABBCD1)
      ** Midas SD Authorised Booking Branches for Customers)
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Control File Update Index

     FSDABBCL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Authorised Booking Branches for Customers)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
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

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

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

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 CDL029A
     D XXDFAC        E                     EXTFLD(QQDFAC)                                    CDL029A
      ** EXTERNAL DS FOR CUSTOMER DETAILS                                                    CDL029A
                                                                                             CDL029A
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure

     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PMODE           S              1
     D PRTCD           S              7
     D W#EROR          S              1
     D CAIN89          S              1
     D CAIN81          S              1
     D W0PMD           S              3
     D WLRCD           S              4  0
     D WKIPIN          S              1
     D W0NLR           S              1
     D WFNAM           S             10

     D W0RSF           S              1
     D WQA3N           S              3  0
     D WQB3N           S              3  0
     D WQC3N           S              3  0
     D WQD1            S              1
     D WQE1            S              1
     D WQF1            S              1
     D WQB10X          S             10
     D WQG3N           S              3  0
     D WSkipRec        S              1
     D @RUN            S              1
     D Wvalid          S              1
     D CPY2@           S             80

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      /EJECT
      *****************************************************************
     C
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

      ** Clear messages from program message queue
      ** Initialise and load subfile page
     C                   EXSR      SRBuild

     C                   EVAL      W0RSF = 'N'

      ** Display screen until reload requested

     C     W0RSF         DOWEQ     'N'

      ** Display screen
     C                   EXSR      SRDisplay

      ** Process response

     C     *INKC         CASEQ     '1'           SREnd

     C     *INKE         CASEQ     '1'           SRReload

     C     *IN27         CASEQ     '1'           SRLoad

     C                   CAS                     SRProcess
     C                   ENDCS

     C                   ENDDO

     C                   ENDDO
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *  Calls    : AOBANKR0 - Access Bank Details                    *
      *             *PSSR                                             *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Set up copyright parameter

     C                   MOVEA     CPY@          CPY2@

     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PMODE


      ** Initialize program name

     C                   MOVEL     'SD0800'      DBPGM

      ** Move workstation ID to screen field

     C                   EVAL      ##PGMQ = PSProcName
     C                   EVAL      DDUSR  = PsUser
     C                   EVAL      DDWID  = PsJobName

      ** Initialise Subfile Control

     C                   MOVE      *BLANKS       DDCBRH
     C                   MOVE      *BLANKS       DDCUST                                      CDL029A
     C                   MOVE      *BLANKS       DDCSSN                                      BUG7305
     C                   MOVE      *BLANKS       DDBBRH
     C                   Z-ADD     13            WSFPG             3 0

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Open files for update

     C                   OPEN      SD0800DF
      **  GET ZMUSER to access default branch

     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   MOVEL     BRC           W0BRC             3                         BUG7305
     C                   UNLOCK    ZMUSER

      ** Set to *CHANGE mode
     C                   EVAL      W0PMD = 'CHG'


     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRBuild - Initialise and Load Subfile Page                    *
      *                                                               *
      * Called by: Main routine                                       *
      * Calls    : QDCXLATE, SRLoad                                   *
      *****************************************************************
     C     SRBuild       BEGSR

      ** Initialise & load subfile page

     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD0800C0
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *OFF

      ** Reset Number of Records in Subfile

     C                   Z-ADD     0             WLRCD             4 0
      ** Position file
     C     KAUTH2        KLIST
     C                   KFLD                    DDCBRH
     C                   KFLD                    DDCUST                                      CDL029A
     C                   KFLD                    DDBBRH
      ** Position file
     C     KAUTH1        KLIST
     C                   KFLD                    DKCBRH
     C                   KFLD                    DKCUST                                      CDL029A
     C                   KFLD                    DKBBRH

     C     *LIKE         DEFINE    DKCBRH        WZCBRH
     C                   EVAL      WZCBRH = DKCBRH
     C     *LIKE         DEFINE    DKCUST        WZCUST                                      CDL029A
     C                   EVAL      WZCUST = DKCUST                                           CDL029A
     C     *LIKE         DEFINE    DKCSSN        WZCSSN                                      BUG7305
     C                   EVAL      WZCSSN = DKCSSN                                           BUG7305
     C     *LIKE         DEFINE    DKBBRH        WZBBRH
     C                   EVAL      WZBBRH = DKBBRH

      * If CHANGE mode, then position file:
     C     W0PMD         IFNE      'ADD'
      ** Save previous selector values

     C*****KAUTH1        SETLL     SDABBCL0                           82                     CDL029A
     C     *LOVAL        SETLL     SDABBCL0                           82                     CDL029A
     C  N82              READ      SDABBCL0                               82
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF

      ** Translate search mask for text field

     C     *LIKE         DEFINE    DKCBRH        WQCBRH

     C                   CALL      'QDCXLATE'
     C                   PARM      3             WQA5N             5 0
     C                   PARM      DKCBRH        WQCBRH
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X           10

     C     *LIKE         DEFINE    DKBBRH        WQBBRH

     C                   CALL      'QDCXLATE'
     C                   PARM      3             WQA5N
     C                   PARM      DKBBRH        WQBBRH
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X

     C     *LIKE         DEFINE    DKCUST        WQCUST                                      CDL029A
                                                                                             CDL029A
     C                   CALL      'QDCXLATE'                                                CDL029A
     C                   PARM      6             WQA5N             5 0                       CDL029A
     C                   PARM      DKCUST        WQCUST                                      CDL029A
     C                   PARM      'QSYSTRNTBL'  WQB10X                                      CDL029A
     C                   PARM      'QSYS'        WQC10X           10                         CDL029A
                                                                                             CDL029A
     C     *LIKE         DEFINE    DKCSSN        WQCSSN                                      BUG7305
                                                                                             BUG7305
     C                   CALL      'QDCXLATE'                                                BUG7305
     C                   PARM      10            WQA5N             5 0                       BUG7305
     C                   PARM      DKCSSN        WQCSSN                                      BUG7305
     C                   PARM      'QSYSTRNTBL'  WQB10X                                      BUG7305
     C                   PARM      'QSYS'        WQC10X           10                         BUG7305
                                                                                             BUG7305
      ** Load subfile page

     C                   EXSR      SRLoad
      * If no records found, display error message
     C                   IF        *IN82 and @@RRN  = 0
      * Send message '*No data to display'
     C                   EVAL      PZMsgID = 'Y2U0008'
     C                   EVAL      PZMsgFile = 'Y2USRMSG'
     C                   EXSR      SRZASNMS
     C                   END

     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRLoad - Load Subfile Page                                    *
      *                                                               *
      * Called by: Main routine, SRBuild                              *
      * Calls    : QCLSCAN                                            *
      *****************************************************************
     C     SRLoad        BEGSR

      ** Load subfile page but write empty page if add mode

     C                   EVAL      *IN94 = *OFF

      ** Re-establish fields in read-ahead record

     C                   IF        W0PMD <> 'ADD' and *IN27 and *IN82 = '0'
     C                   READP     SDABBCL0                               60
     C                   READ      SDABBCL0                               60
     C                   ENDIF

      ** Start at previous highest record in SFL

     C                   Z-ADD     WLRCD         @@RRN
     C                   Z-ADD     1             WRCTR             5 0

      ** Load next subfile page

     C     *IN82         DOWEQ     '0'
     C     WRCTR         ANDLE     WSFPG

      * Access Customer details                                                              BUG7305
     C                   CALLB     'AOCUSTR0'                                                BUG7305
     C                   PARM      *BLANKS       @RTCD                                       BUG7305
     C                   PARM      '*KEY     '   @OPTN                                       BUG7305
     C                   PARM      ABCUST        @CUST            10                         BUG7305
     C                   PARM      *BLANKS       @STS              7                         BUG7305
     C     SDCUST        PARM      SDCUST        DSFDY                                       BUG7305
      *                                                                                      BUG7305
     C     @RTCD         IFEQ      *BLANKS                                                   BUG7305
     C                   MOVEL     BBCUST        DDCUST                                      BUG7305
     C                   MOVEL     BBCSSN        DDCSSN                                      BUG7305
     C                   ELSE                                                                BUG7305
     C                   MOVEL     *BLANKS       DDCUST                                      BUG7305
     C                   MOVEL     *BLANKS       DDCSSN                                      BUG7305
     C                   ENDIF                                                               BUG7305
      *                                                                                      BUG7305
     C                   EVAL      WSkipRec = 'N'
     C                   ADD       1             @@RRN
     C                   MOVEA     '00000'       *IN(30)
     C                   MOVEA     '0'           *IN(37)                                     CDL029A

      ** Protect fields during Enquiry Mode

     C                   IF        PMODE = 'E'
     C                   EVAL      *IN79 = *ON
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
                                                                                             CDL029A
     C                   IF        W0PMD <> 'ADD' and PMODE = 'M'                            CDL029A
     C                   EVAL      *IN78 = *ON                                               CDL029A
     C                   ENDIF                                                               CDL029A

     C                   IF        (W0PMD <> 'ADD')

     C                   IF        DKCBRH <> *BLANKS

     C                   CALL      'QCLSCAN'
     C                   PARM                    CBRH
     C                   PARM      3             WQA3N
     C                   PARM      1             WQB3N
     C                   PARM                    WQCBRH
     C                   PARM      3             WQC3N
     C                   PARM      '1'           WQD1
     C                   PARM      '1'           WQE1
     C                   PARM      '?'           WQF1
     C                   PARM                    WQG3N

     C                   IF        WQG3N < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   IF        DKBBRH <> *BLANKS

     C                   CALL      'QCLSCAN'
     C                   PARM                    BBRH
     C                   PARM      3             WQA3N
     C                   PARM      1             WQB3N
     C                   PARM                    WQBBRH
     C                   PARM      3             WQC3N
     C                   PARM      '1'           WQD1
     C                   PARM      '1'           WQE1
     C                   PARM      '?'           WQF1
     C                   PARM                    WQG3N

     C                   IF        WQG3N < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
     C                   ENDIF
                                                                                             CDL029A
     C                   IF        DKCUST <> *BLANKS                                         CDL029A
                                                                                             CDL029A
     C                   CALL      'QCLSCAN'                                                 CDL029A
     C                   PARM                    ABCUST                                      CDL029A
     C                   PARM      6             WQA3N                                       CDL029A
     C                   PARM      1             WQB3N                                       CDL029A
     C                   PARM                    WQCUST                                      CDL029A
     C                   PARM      6             WQC3N                                       CDL029A
     C                   PARM      '1'           WQD1                                        CDL029A
     C                   PARM      '1'           WQE1                                        CDL029A
     C                   PARM      '?'           WQF1                                        CDL029A
     C                   PARM                    WQG3N                                       CDL029A
                                                                                             CDL029A
     C                   IF        WQG3N < 1                                                 CDL029A
     C                   EVAL      WSkipRec = 'Y'                                            CDL029A
     C                   ENDIF                                                               CDL029A
     C                   ENDIF                                                               CDL029A
                                                                                             BUG7305
     C                   IF        DKCSSN <> *BLANKS                                         BUG7305
                                                                                             BUG7305
     C                   CALL      'QCLSCAN'                                                 BUG7305
     C                   PARM                    BBCSSN                                      BUG7305
     C                   PARM      10            WQA3N                                       BUG7305
     C                   PARM      1             WQB3N                                       BUG7305
     C                   PARM                    WQCSSN                                      BUG7305
     C                   PARM      10            WQC3N                                       BUG7305
     C                   PARM      '1'           WQD1                                        BUG7305
     C                   PARM      '1'           WQE1                                        BUG7305
     C                   PARM      '?'           WQF1                                        BUG7305
     C                   PARM                    WQG3N                                       BUG7305
                                                                                             BUG7305
     C                   IF        WQG3N < 1 or DDCUST = *blanks                             BUG7305
     C                   EVAL      WSkipRec = 'Y'                                            BUG7305
     C                   ENDIF                                                               BUG7305
     C                   ENDIF                                                               BUG7305

     C                   ENDIF

     C                   IF        WSkipRec = 'N'

      ** Clear subfile fields

     C                   EXSR      SRClrScrn


      ** If CHANGE mode, load subfile fields
     C                   IF        W0PMD <> 'ADD'
     C                   EXSR      SRMove
      ** Validate subfile record
     C                   EXSR      SRValidate
     C                   END

      ** Output to subfile

     C                   ADD       1             WRCTR                81
     C                   EVAL      *IN81 = *ON

      ** If SFLRCD invalid, note that errors present

     C                   IF        *IN83 and *IN40 = '0'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
      ** Set screen conditioning indicators
     C                   IF        W0PMD = 'ADD'
     C                   EVAL      *IN89 = *ON
     C                   EVAL      *IN79 = *ON
     C                   ELSE
     C                   EVAL      *IN89 = *OFF
     C                   EVAL      *IN79 = *OFF
     C                   ENDIF

     C                   WRITE     SD0800S0

     C                   ELSE
     C                   SUB       1             @@RRN
     C                   ENDIF

      ** End of File

     C     W0PMD         IFNE      'ADD'
     C                   READ      SDABBCL0                               82
     C                   ENDIF

     C                   ENDDO

     C                   Z-ADD     @@RRN         WLRCD

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRDisplay - Display Subfile                                  *
      *                                                               *
      *  Called by: Main routine                                      *
      *  Calls    :                                                   *
      *****************************************************************
     C     SRDisplay     BEGSR

      ** Set screen conditioning indicators

     C                   IF        W0PMD = 'ADD'
     C                   EVAL      *IN89 = *ON
     C                   ELSE
     C                   EVAL      *IN89 = *OFF
     C                   ENDIF

      ** PUTOVR unless conditioned fields change

     C                   EVAL      *IN86 = *ON
     C                   IF        *IN89 <> CAIN89 OR *IN81 <> CAIN81
     C                   EVAL      *IN86 = *OFF
     C                   ENDIF

     C                   EVAL      CAIN89 = *IN89
     C                   EVAL      CAIN81 = *IN81

      ** Display appropriate Header depending upon Mode whether it is
      ** Enquiry or Maintenance

     C                   IF        PMODE = 'E'
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN79 = *ON
     C                   EVAL      *IN78 = *ON
     C                   ENDIF

     C                   TIME                    DDTIME
     C                   WRITE     SD0800C1
     C                   WRITE     SD0800F0
     C                   EXFMT     SD0800C0

      ** Clear messages from program message queue

     C                   CALL      'ZA0250'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRProcess - Process Screen Input                              *
      *                                                               *
      * Called by: Main routine                                       *
      * Calls    : SRReload, Validateaction, SRSelection          *
      *****************************************************************
     C     SRProcess     BEGSR

      ** Change of position specified

     C     W0PMD         IFNE      'ADD'
     C                   IF        WZCBRH <> DKCBRH OR WZBBRH <> DKBBRH
     C*****                        OR WZCUST <> DKCUST                                CDL029ABUG7305
     C                             OR WZCSSN <> DKCSSN                                       BUG7305
     C                   EXSR      SRReload
     C                   ENDIF
     C                   ENDIF

      ** Quit if reload requested

     C     W0RSF         IFNE      'Y'

      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.

     C                   IF        *IN81 = *ON
     C                   EVAL      WKIPIN = 'N'
      ** Process subfile records
     C                   EXSR      SRSubfileRec
     C                   IF        (*IN40 <> *ON) AND (WKIPIN = 'Y')
     C                   EXSR      SRUpdate
     C                   ENDIF

     C                   ENDIF
     C                   IF        *IN09 and *IN40 = '0'
     C                   EXSR      SRMode
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSubfileRec - Process Modified Subfile Record                *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRAction                                           *
      *                                                               *
      *****************************************************************

     C     SRSubfileRec  BEGSR

      ** Process modified subfile record

     C                   READC     SD0800S0                               62
     C     *IN62         DOWEQ     '0'
     C                   EXSR      SRAction
      ** Set screen conditioning indicators
     C                   IF        W0PMD = 'ADD'
     C                   EVAL      *IN89 = *ON
     C                   EVAL      *IN79 = *ON
     C                   ELSE
     C                   EVAL      *IN89 = *OFF
     C                   EVAL      *IN79 = *OFF
     C                   ENDIF
     C                   UPDATE    SD0800S0
     C                   READC     SD0800S0                               62
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAction       Process Subfile Record                          *
      *                                                               *
      * Called by: SRSubfileRec                                       *
      *                                                               *
      * Calls    : SRValidKey                                         *
      *****************************************************************
     C     SRAction      BEGSR

     C                   MOVEA     '00000'       *IN(30)
     C                   MOVE      '0'           *IN37                                       CDL029A
     C                   MOVE      '0'           *IN94
     C                   MOVE      '0'           *IN83

     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'N'           W0NLR             1
     C     DDCBRH        IFEQ      *BLANKS
     C     DDBBRH        ANDEQ     *BLANKS
     C     DDCUST        ANDEQ     *BLANKS                                                   CDL029A
     C     DDCSSN        ANDEQ     *BLANKS                                                   BUG7305
     C                   EVAL      W0NLR = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
      ** If not null record, continue
     C     W0NLR         IFNE      'Y'
     C                   EVAL      WKIPIN = 'Y'

     C                   EVAL      *IN94 = *ON

     C                   EXSR      SRValidKey

      ** Seton Global Error Indicator if error exists

     C                   IF        *IN83 = *ON
     C                   EVAL      *IN40 = *ON
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
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

     C     SRValidKey    BEGSR

      ** Validate Action Code
     C                   If        DDOPTN <> 'D' AND DDOPTN <> ' '
     C                             AND PMODE = 'M'
     C                   EVAL      W#EROR = 'Y'
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9276'
     C                   EXSR      SRZasnms
     C                   Endif
      *
      ** If single branching
      ** ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      ACSSES
     C                   ENDIF
      *
      ** If multibranching
      ** ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   EXSR      ACSSEM
     C                   ENDIF

      ** Validate subfile record relations

     C                   EXSR      SRValidate

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValidate - Validate Subfile Record Relations                *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *****************************************************************
     C     SRValidate    BEGSR
     C                   MOVE      '0'           *IN33
     C                   MOVE      '0'           *IN34
     C                   MOVE      '0'           *IN37                                       CDL029A
      *                                                                                      CDL029A
      ** Validate Customer branch
      * Access Branch details
     C                   CALLB     'AOBRCHR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCBRH        @BRCH             3
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      * Not Found
     C     @RTCD         IFNE      *BLANKS
     C     DDCUST        ANDEQ     *BLANKS                                                   CDL029A
     C     DDCSSN        ANDEQ     *BLANKS                                                   BUG7305
     C                   MOVE      'N'           WValid
     C                   MOVE      '1'           *IN33
     C                   MOVE      '1'           *IN94
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9273'
     C                   EXSR      SRZasnms
     C                   END
      *                                                                                      CDL029A
     C     @RTCD         IFEQ      *BLANKS                                                   CDL029A
     C                   MOVE      @BRCH         DDCBRH                                      CDL029A
     C                   ENDIF                                                               CDL029A
      *
      ** Validate Authorised Booking Branch
      * Access Branch details
     C                   CALLB     'AOBRCHR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDBBRH        @BRCH
     C     SDBRCH        PARM      SDBRCH        DSFDY
      *
      * Not Found
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           WValid
     C                   MOVE      '1'           *IN34
     C                   MOVE      '1'           *IN94
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9274'
     C                   EXSR      SRZasnms
     C                   END
      *                                                                                      CDL029A
     C     @RTCD         IFEQ      *BLANKS                                                   CDL029A
     C                   MOVE      @BRCH         DDBBRH                                      CDL029A
     C                   ENDIF                                                               CDL029A
      *
      ** Validate Customer Number                                                            CDL029A
      * Access Customer details                                                              CDL029A
     C                   CALLB     'AOCUSTR0'                                                CDL029A
     C                   PARM      *BLANKS       @RTCD                                       CDL029A
     C*****              PARM      '*VERIFY  '   @OPTN                                CDL029ABUG7305
     C                   PARM      '*KEY     '   @OPTN                                       BUG7305
     C*****              PARM      DDCUST        @CUST            10                  CDL029ABUG7305
     C                   PARM      DDCSSN        @CUST            10                         BUG7305
     C                   PARM      *BLANKS       @STS              7                         CDL029A
     C     SDCUST        PARM      SDCUST        DSFDY                                       CDL029A
      *                                                                                      CDL029A
      * Not Found                                                                            CDL029A
     C     @RTCD         IFNE      *BLANKS                                                   CDL029A
     C     DDCBRH        ANDEQ     *BLANKS                                                   CDL029A
     C                   MOVE      'N'           WValid                                      CDL029A
     C                   MOVE      '1'           *IN37                                       CDL029A
     C                   MOVE      '1'           *IN94                                       CDL029A
     C                   EVAL      *IN83 = *ON                                               CDL029A
     C                   EVAL      PZMsgID = 'USR0238'                                       CDL029A
     C                   EXSR      SRZasnms                                                  CDL029A
     C                   END                                                                 CDL029A
      *                                                                                      CDL029A
     C     @RTCD         IFEQ      *BLANKS                                                   CDL029A
     C*****              MOVEL     @CUST         DDCUST                               CDL029ABUG7305
     C                   MOVEL     BBCUST        DDCUST                                      BUG7305
     C                   MOVEL     BBCSSN        DDCSSN                                      BUG7305
     C                   ENDIF                                                               CDL029A
      *                                                                                      CDL029A
      ** Validate Cross-refs: either Customer or Branch                                      CDL029A
     C     DDCUST        IFNE      *BLANKS                                                   CDL029A
     C     DDCBRH        ANDNE     *BLANKS                                                   CDL029A
     C     DDCBRH        ORNE      *BLANKS                                                   BUG7305
     C     DDCSSN        ANDNE     *BLANKS                                                   BUG7305
     C                   MOVE      'N'           WValid                                      CDL029A
     C                   MOVE      '1'           *IN37                                       CDL029A
     C                   MOVE      '1'           *IN33                                       CDL029A
     C                   MOVE      '1'           *IN94                                       CDL029A
     C                   EVAL      *IN83 = *ON                                               CDL029A
     C                   EVAL      PZMsgID = 'USR9835'                                       CDL029A
     C                   EXSR      SRZasnms                                                  CDL029A
     C                   ENDIF                                                               CDL029A
      *                                                                                      CDL029A
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update Records from Subfile                        *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRDetail                                           *
      *                                                               *
      *****************************************************************

     C     SRUpdate      BEGSR

      ** Initialise subfile reload flag

     C                   IF        W0PMD = 'ADD'
     C                   EVAL      W0RSF = 'Y'
     C                   ELSE
     C                   EVAL      W0RSF = 'N'
     C                   ENDIF

      ** Process all modified subfile records

     C                   READC     SD0800S0                               62

     C                   DOW       *IN62 = *OFF
     C                   EXSR      SRDetail

      ** Rollback any DBF changes if error occur

     C                   IF        W#EROR <> *BLANKS
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF

      ** Set screen conditioning indicators
     C                   IF        W0PMD = 'ADD'
     C                   EVAL      *IN89 = *ON
     C                   EVAL      *IN79 = *ON
     C                   ELSE
     C                   EVAL      *IN89 = *OFF
     C                   EVAL      *IN79 = *OFF
     C                   ENDIF

     C                   UPDATE    SD0800S0
     C                   READC     SD0800S0                               62
     C                   ENDDO

      ** Cancel reload if errors occur

     C                   IF        *IN40 = *ON
     C                   EVAL      W0RSF = 'N'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetail - Process action requested                           *
      *                                                               *
      * Called by: SRUpdate                                           *
      *                                                               *
      * Calls    : SRAddReq, SRDelReq                                 *
      *                                                               *
      *****************************************************************

     C     SRDetail      BEGSR

      ** Set off error indicators

     C                   MOVEA     '000'         *IN(32)
     C                   MOVEA     '0'           *IN(37)                                     CDL029A
     C                   EVAL      *IN83 = *OFF

      ** Process add request

     C                   IF        W0PMD = 'ADD'
     C                   MOVEL     'N'           W0NLR             1
     C     DDCBRH        IFEQ      *BLANKS
     C     DDBBRH        ANDEQ     *BLANKS
     C     DDCUST        ANDEQ     *BLANKS                                                   CDL029A
     C     DDCSSN        ANDEQ     *BLANKS                                                   BUG7305
     C                   EVAL      W0NLR = 'Y'
     C                   ENDIF
     C                   IF        W0NLR <> 'Y'
     C                   EXSR      SRAddReq
     C                   ENDIF

     C                   ELSE

      ** Process delete request

     C                   IF        DDOPTN = 'D'
     C                   EXSR      SRDelReq
     C                   ENDIF
     C                   ENDIF

     C                   IF        *IN83 and *IN40 = *OFF
     C                   EVAL      *IN40 = *ON
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
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

     C     SRAddReq      BEGSR

      ** Create New Authorised Booking Branch

     C                   EXSR      SRWrite

      ** Error detected

     C                   IF        W#EROR <> *BLANKS
     C                   MOVEA     '11'          *IN(33)
     C                   MOVEA     '1'           *IN(37)                                     CDL029A
     C                   MOVE      '1'           *IN83
     C                   MOVE      '1'           *IN94
     C                   ELSE
     C                   EVAL      *IN94 = *OFF
     C                   EXSR      SRTrailer
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelReq - Process Delete Request                             *
      *                                                               *
      * Called by: SRDetail                                           *
      *                                                               *
      * Calls    : SRDelete, SRMove, SRClrScrn,SRTrailer              *
      *                                                               *
      *****************************************************************

     C     SRDelReq      BEGSR

     C                   EXSR      SRDelete

     C                   IF        W#EROR <> *BLANKS
      ** Delete unsuccessful
     C                   MOVEA     '11111'       *IN(30)
     C                   MOVE      '1'           *IN37                                       CDL029A
     C                   MOVE      '1'           *IN83
     C                   EVAL      *IN94 = *ON
     C                   EXSR      SRMove
     C                   ELSE
     C                   EXSR      SRTrailer
     C                   EXSR      SRClrScrn
     C                   EVAL      *IN94 = *OFF

      ** Reload subfile

     C                   EVAL      W0RSF = 'Y'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
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

     C     SRMode        BEGSR

      ** Switch between *ADD/*CHANGE modes

     C                   IF        W0PMD <> 'ADD'
     C                   EVAL      W0PMD = 'ADD'
     C                   EVAL      *IN78 = *OFF                                              CDL029A
     C                   ELSE
     C                   EVAL      W0PMD = 'CHG'
     C                   EVAL      *IN78 = *ON                                               CDL029A
     C                   ENDIF

     C                   EXSR      SRReload

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRReload - Request Subfile Reload                             *
      *                                                               *
      * Called by: Main routine, SRProcess                            *
      * Calls    :                                                    *
      *****************************************************************
     C     SRReload      BEGSR

      ** Request subfile reload
     C                   EVAL      W0RSF = 'Y'

     C                   IF        *IN05
     C                   MOVEA     '000'         *IN(32)
     C                   MOVE      '0'           *IN37                                       CDL029A
     C                   MOVE      '0'           *IN94
     C                   EVAL      DDOPTN = *Blanks
     C                   EVAL      DKCBRH= *Blanks
     C                   EVAL      DKCUST= *Blanks                                           CDL029A
     C                   EVAL      DKCSSN= *Blanks                                           BUG7305
     C                   EVAL      DKBBRH = *Blanks
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      * SRDelete - Delete Unauthorised Records                        *
      *                                                               *
      * Called by: SRSelection                                        *
      * Calls    :                                                    *
      *****************************************************************
     C     SRDelete      BEGSR

     C                   EVAL      W#EROR = *BLANKS

      ** Delete record
     C     KAUTH2        CHAIN     SDABBCL1                           91
      *
     C                   IF        *IN91 = '1'
     C                   EVAL      W#EROR = 'Y'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDABBCL1'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     DDCBRH        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   DELETE    SDABBCL1

     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Create Authorised Booking Branch                    *
      *                                                               *
      * Called by: SRAddReq                                           *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************

     C     SRWrite       BEGSR

     C                   EVAL      W#EROR = *BLANKS

      ** Check for duplicate primary key

     C     KAUTH2        SETLL     SDABBCL1                               60

     C                   IF        *IN60
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR9275'
     C                   EXSR      SRZasnms
      *
     C                   ELSE

     C                   EVAL      CBRH = DDCBRH
     C                   EVAL      ABCUST = DDCUST                                           CDL029A
     C                   EVAL      BBRH = DDBBRH
     C                   WRITE     SDABBCD1                             61

      ** Write error detected

     C                   IF        *IN61
     C                   EVAL      W#EROR = 'Y'
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
      *
      ** validate action codes for user
      *
     C                   CALL      'ZVACTU'
     C                   PARM      DDOPTN        ZACTN             1
     C                   PARM                    ERR               1 0
      *
      ** This action code invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
     C                   EVAL      PZMsgID = 'USR4436'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
      *
      **  Check user's authority for the action & Booking Branch.
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      DDOPTN        ZACTN             1
     C*****              PARM      BRC           ZBR               3                         BUG7305
     C                   PARM      W0BRC         ZBR               3                         BUG7305
     C                   PARM                    ERR               1 0
      *
      **   If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
     C                   EVAL      PZMsgFile = 'DRSMM'
     C                   EVAL      PZMsgID = 'RE71070'
     C                   EXSR      SRZasnms
     C                   ELSE
     C     ERR           IFEQ      2
     C                   MOVE      '1'           *IN32
     C                   MOVE      '1'           *IN94
     C                   EVAL      PZMsgID = 'USR4436'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTrailer - Update Control Files                              *
      *                                                               *
      * Called by: SRAddReq, SRDelReq                                 *
      *                                                               *
      * Calls    : *PSSR                                              *
      *                                                               *
      *****************************************************************

     C     SRTrailer     BEGSR

     C                   MOVEL     'SDABBCPD'    WFNAM
     C     WFNAM         CHAIN     SDFCTLL0                           50

     C                   IF        *IN50
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBKEY = WFNAM
     C                   EVAL      DBPGM = 'SD0800'
     C                   MOVEL     '003'         DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ELSE

     C                   SELECT
     C     W0PMD         WHENEQ    'ADD'
     C                   ADD       1             AHNORC
     C                   ADD       1             AHNOIN
     C     DDOPTN        WHENEQ    'D'
     C                   ADD       1             AHNODL
     C                   SUB       1             AHNORC
     C                   ENDSL

     C                   ENDIF

     C                   UPDATE    @AHREAU

     C                   COMMIT

     C                   ENDSR

      /EJECT
      *****************************************************************
      /EJECT
      *****************************************************************
      * SREnd - End Program                                           *
      *                                                               *
      * Called by: Main routine, SRSelection                          *
      * Calls    :                                                    *
      *****************************************************************
     C     SREnd         BEGSR

      ** Rollback any uncommitted DBF changes

     C                   ROLBK                                          60

      ** Terminate program

     C                   EVAL      *INLR = *ON

      ** Exit program

     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRZasnms - Message Handling Subroutine                        *
      *                                                               *
      * Called by: Various                                            *
      * Calls    : ZA0340                                             *
      *****************************************************************
     C     SRZasnms      BEGSR

     C                   IF        PZMsgFile = *BLANKS
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   ENDIF

     C                   CALL      'ZA0340'
     C                   PARM                    PZMsgFile        10
     C                   PARM                    PZMsgID          10

     C                   EVAL      PZMsgFile = *BLANKS

     C                   ENDSR
      /EJECT
      *****************************************************************
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
     C     SRClrScrn     BEGSR

      ** Clear subfile fields
     C                   MOVE      *BLANK        DDOPTN
     C                   MOVEL     *BLANK        DDCBRH
     C                   MOVEL     *BLANK        DDCUST                                      CDL029A
     C                   MOVEL     *BLANK        DDCSSN                                      BUG7305
     C                   MOVEL     *BLANK        DDBBRH

      ** Initialise subfile record

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMove - Transfer Records from SDABCCY1 to Subfile            *
      *                                                               *
      * Called by: SRLoad, SRDelReq                        *
      *                                                               *
      * Calls    : ZEDIT                                              *
      *                                                               *
      *****************************************************************
     C     SRMove        BEGSR

      ** Move SDABBCY0 fields to subfile

     C                   MOVEL     CBRH          DDCBRH
     C                   MOVEL     ABCUST        DDCUST                                      CDL029A
     C     ABCUST        IFNE      *BLANKS                                                   BUG7305
     C                   MOVEL     BBCSSN        DDCSSN                                      BUG7305
     C                   ENDIF                                                               BUG7305
     C                   MOVEL     BBRH          DDBBRH

      ** Hold current record image for change detection

     C                   ENDSR

      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
