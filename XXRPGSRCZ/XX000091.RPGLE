     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Unauthorised Amount Accruals')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  XX000091 - Midas GL Unauthorised Amount Accruals             *
      *                                                               *
      *  Function:  This program displays a list of unauthorised      *
      *             amount accruals for processing.                   *
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. DAI101B            Date 02Oct19               *
      *  Prev Amend No. DAI101A            Date 29May19               *
      *                 MD052332           Date 23May19               *
      *                 MD037691           Date 23May19               *
      *                 DAI101  *CREATE    Date 23May19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DAI101B - Added changes onsite                               *
      *  DAI101A - Accrual Authorisation with CGL141                  *
      *  MD052332 - No confirmation before deletion is shown          *
      *  MD037691 - Requirement to deliver 'E' action code for un-    *
      *             authorised screen so that everybody can check for *
      *             un-authorised transactions.                       *
      *  DAI101 - Upgrade to FB Midas                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FXX000091DFCF   E             WORKSTN
     F                                     SFILE(XX0091S0:@@RRN)
      ** Midas GL Unauthorised Amount Accruals

     FXXAMACV0  IF   E           K DISK
      ** Midas GL Amount Accruals Detail - Retrieve

     FXXAMACV1  UF   E           K DISK
     F                                     RENAME(XXAMACD0:XXAMACD1)
     F                                     COMMIT
      ** Midas GL Amount Accruals Detail - Update
     FXXGLAMACY0UF   E           K DISK                                                      DAI101A
     F                                     RENAME(XXGLAMACT0:XXGLAMAC1D)                     DAI101A
     F                                     COMMIT                                            DAI101A
      ** Midas XX Amount Accruals Extended Narrative - Update
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

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Externally described DS for Currency Details

                                                                                             DAI101A
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 DAI101A
      ** External DS for SAR Details                                                         DAI101A
                                                                                             DAI101A
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** Long DS for access programs

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure

     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
                                                                                             DAI101A
     D DATA            DS          1024                                                      DAI101A
     D  #1BRCA                 1      3                                                      DAI101A
     D  #1AREF                 4      9                                                      DAI101A
     D  #1ATYP                10     10                                                      DAI101A
     D  #1PROG                11     20                                                      DAI101A
     D  #1CHTP                21     21                                                      DAI101A

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

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
     D CPY2@           S             80
     D PToNbDp         S              1  0
      ** Parameters for ZDATE2                                                              MD037691
     D PDaynoIn        S              5P 0                                                  MD037691
     D PDateOut        S              6  0                                                  MD037691
     D PADateOut       S              7A                                                    MD037691
     D ZFIELD          S             16                                                     MD037691
     D ZALIGNOK        S              1                                                     MD037691
     D ZADIG           S              2  0                                                  MD037691
     D ZADEC           S              1  0                                                  MD037691

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

      **  GET ZMUSER to access default branch

     C     *DTAARA       Define                  ZMUSER
     C                   In        ZMUSER
     C                   Unlock    ZMUSER

     C                   Do        *HIVAL

      ** If no records found, display no record screen and exit

     C     *Loval        Setll     XXAMACV0
     C                   Read      XXAMACV0                               82
      *
     C                   If        *IN82 = '1'

      ** Clear messages from program message queue

     C                   Call      'ZA0250'
      *
     C                   Write     XX0091C1
     C                   Exfmt     XX0091NR
     C                   Exsr      SREnd
     C                   EndIf

      ** Initialise and load subfile page

     C                   Exsr      SRBuild

     C                   Eval      W0RSF = 'N'

      ** Display screen until reload requested

     C     W0RSF         DowEq     'N'

      ** Display screen

     C                   Exsr      SRDisplay

      ** Process response

     C     *IN03         CASEQ     '1'           SREnd

     C     *IN05         CASEQ     '1'           SRReload

     C     *IN27         CASEQ     '1'           SRLoad

     C     *IN12         CASEQ     '1'           SREnd

     C                   CAS                     SRProcess
     C                   EndCs

     C                   EndDo

     C                   EndDo

      /EJECT
      *****************************************************************
      * SRBuild - Initialise and Load Subfile Page                    *
      *                                                               *
      * Called by: Main routine                                       *
      * Calls    : QDCXLATE, SRLoad                                   *
      *****************************************************************
     C     SRBuild       BegSr

      ** Initialise & load subfile page

     C                   Eval      *IN80 = *ON
     C                   Write     XX0091C0
     C                   Eval      *IN80 = *OFF
     C                   Eval      *IN81 = *OFF

      ** Reset Number of Records in Subfile

     C                   Z-Add     0             WLRCD             4 0

      ** Position file

     C     DDREFS        Setll     XXAMACV0
     C                   Read      XXAMACV0

      ** Save previous selector values

     C     *LIKE         Define    DDREFS        WZREFS
     C                   Eval      WZREFS = DDREFS

      ** Translate search mask for text field

     C     *LIKE         Define    DDREFS        WQREFS

     C                   Call      'QDCXLATE'
     C                   Parm      6             WQA5N             5 0
     C                   Parm      DDREFS        WQREFS
     C                   Parm      'QSYSTRNTBL'  WQB10X
     C                   Parm      'QSYS'        WQC10X           10

      ** Load Subfile page

     C                   Exsr      SRLoad

     C                   EndSr
      /EJECT
      *****************************************************************
      * SRLoad - Load Subfile Page                                    *
      *                                                               *
      * Called by: Main routine, SRBuild                              *
      * Calls    : QCLSCAN                                            *
      *****************************************************************
     C     SRLoad        BegSr

      ** Re-establish fields in Read-ahead record

     C                   If        *IN27 and *IN82 = '0'
     C                   ReadP     XXAMACV0                               60
     C                   Read      XXAMACV0                               60
     C                   EndIf

      ** Start at previous highest record in SFL

     C                   Z-Add     WLRCD         @@RRN
     C                   Z-Add     1             WRCTR             5 0

      ** Load next subfile page

     C     *IN82         DowEq     '0'
     C     WRCTR         ANDLE     WSFPG

     C                   Eval      WSkipRec = 'N'
     C                   Add       1             @@RRN
     C                   Eval      *IN32 = '0'

     C                   If        FBREF >= DDREFS
     C                   Else
     C                   Eval      WSkipRec = 'Y'
     C                   EndIf


     C                   If        WSkipRec = 'N'

      ** Load subfile fields

     C                   Move      *BLANK        DDOPTN
     C                   Move      *BLANKS       DDUSER           10
     C                   Move      FBREF         DDREF
     C                   MoveL     FBBRCA        DDBRCA
     C                   MoveL     FBCCY         DDCURR

     C                   Call      'AOCURRR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    DDCURR
     C     SDCurr        Parm      SDCurr        DSLDY
     C                   Eval      PToNbDp = A6NBDP

     C                   Z-Add     FBAMNT        ZFLD15           15 0
     C                   Z-Add     PToNbDp       ZDECS             1 0
     C                   Call      'ZSEDIT'
     C                   Parm                    ZFLD15
     C                   Parm                    ZDECS
     C                   Parm      'M'           ZECODE            1
     C                   Parm                    ZOUT21           21
     C                   Move      ZOUT21        DDAMT

     C                   Move      FBLCUS        DDUSER

     C                   SELECT
     C                   When      FBCHTP = 'I'
     C                   Eval      DDACTN = 'Insert'
     C                   When      FBCHTP = 'A'
     C                   Eval      DDACTN = 'Amend '
     C                   When      FBCHTP = 'D'
     C                   Eval      DDACTN = 'Delete'
     C                   ENDSL

      ** Output to subfile

     C                   Add       1             WRCTR                81
     C                   Eval      *IN81 = *ON
     C                   Write     XX0091S0

     C                   Else
     C                   Sub       1             @@RRN
     C                   EndIf

      ** End of File

     C                   Read      XXAMACV0                               82
     C                   EndDo

     C                   Z-Add     @@RRN         WLRCD

     C                   EndSr
      /EJECT
      *****************************************************************
      * SRReload - Request Subfile Reload                             *
      *                                                               *
      * Called by: Main routine, SRProcess                            *
      * Calls    :                                                    *
      *****************************************************************
     C     SRReload      BegSr

      ** Request Subfile reload

     C                   Eval      W0RSF = 'Y'

     C                   If        *IN05
     C                   Move      '0'           *IN32
     C                   Move      '0'           *IN94

     C                   Eval      DDOPTN = *Blanks
     C                   Eval      DDREFS = *Zeros

      ** Clear messages from program message queue

     C                   Call      'ZA0250'
     C                   EndIf

     C                   EndSr
      /EJECT
      *****************************************************************
      *  SRDisplay - Display Subfile                                  *
      *                                                               *
      *  Called by: Main routine                                      *
      *  Calls    :                                                   *
      *****************************************************************
     C     SRDisplay     BegSr

      ** PUTOVR unless conditioned fields change

     C                   Eval      *IN86 = *ON

     C                   TIME                    DDTIME
     C                   Write     XX0091C1
     C                   Write     XX0091F0
     C                   Exfmt     XX0091C0

      ** Clear messages from program message queue

     C                   Call      'ZA0250'

     C                   EndSr
      /EJECT
      *****************************************************************
      * SRProcess - Process Screen Input                              *
      *                                                               *
      * Called by: Main routine                                       *
      * Calls    : SRReload, SRValid, SRSelection                     *
      *****************************************************************
     C     SRProcess     BegSr

      ** Change of position specified

     C                   If        WZREFS <> DDREFS
     C                   Exsr      SRReload
     C                   EndIf

      ** Quit if reload requested

     C     W0RSF         IfNe      'Y'

      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.

     C                   Move      '0'           *IN94

     C                   ReadC     XX0091S0                               99
     C     *IN99         DowEq     '0'

      * Validate option code

     C                   Exsr      SRValid

      ** If action code is valid process selection

     C     *IN32         Ifeq      '0'
     C     DDOPTN        Andne     *BLANK
     C                   Exsr      SRSelection
     C                   EndIf

     C     *IN32         Ifeq      '0'
     C                   Eval      DDOPTN = *Blanks
     C                   Eval      W0RSF = 'Y'
     C                   EndIf

     C                   Update    XX0091S0
     C                   ReadC     XX0091S0                               99
     C                   EndDo

     C                   EndIf

     C                   EndSr
      /EJECT
      *****************************************************************
      * SRValid - Validate Option code                                *
      *                                                               *
      * Called by: SRProcess                                          *
      * Calls    : SRZasnms                                           *
      *****************************************************************
     C     SRValid       BegSr

     C                   Move      '0'           *IN32

      ** Validate Action Code

     C*******************If        DDOPTN <> 'D' AND DDOPTN <> 'X' AND                       DAI101B
     C                   If        DDOPTN <> 'R' AND DDOPTN <> 'X' AND                       DAI101B
     C                             DDOPTN <> ' '
     C                             AND DDOPTN <> 'E'                                        MD037691

     C                   Move      '1'           *IN32
     C                   Move      '1'           *IN94

     C                   Eval      PZMsgFile = 'GBXXUSRMSG'
     C**********         Eval      PZMsgID = 'XXX1040'                                      MD037691
     C                   Eval      PZMsgID = 'XXX1043'                                      MD037691

     C                   Exsr      SRZasnms
     C                   EndIf

      ** Check if record still exists

     C                   Z-Add     0             KNREF             6 0
     C                   Move      DDREF         KNREF
     C     KNREF         Chain     XXAMACV0                           85

      ** Send message 'Record no longer on file'

     C                   If        *IN85 = *ON
     C                   Move      '1'           *IN32
     C                   Move      '1'           *IN94
     C                   Eval      PZMsgFile = 'GBXXUSRMSG'
     C                   Eval      PZMsgID = 'XXX1042'
     C                   Exsr      SRZasnms
     C                   EndIf

      ** Validate User

     C                   If        DDOPTN = 'X' AND PsUser = DDUSER
     C                   Move      '1'           *IN32
     C                   Move      '1'           *IN94
     C                   Eval      PZMsgFile = 'GBXXUSRMSG'
     C                   Eval      PZMsgID = 'XXX1041'
     C                   Exsr      SRZasnms
     C                   EndIf

      ** If single branching
      ** ACCESS SECURITY CHECKING - SINGLE BRANCHING

     C     BJSBRC        Ifne      *BLANK
     C                   Exsr      ACSSES
     C                   EndIf

      ** If multibranching
      ** ACCESS SECURITY CHECKING - MULTI-BRANCHING

     C     BJSBRC        Ifeq      *BLANK
     C                   Exsr      ACSSEM
     C                   EndIf

     C                   EndSr
      /EJECT
      *****************************************************************
      * SRSelection - Process Selected transaction                    *
      *                                                               *
      * Called by: SRProcess                                          *
      * Calls    : Authorisation Programs, SREnd, SRZasnms            *
      *****************************************************************
     C     SRSelection   BegSr

      ** Pass the Key and Action code to the Authorisation programs

     C                   If        *IN32 = *OFF
     C                   If        DDOPTN = 'X'
     C     *LOCK         IN        LDA
     C                   Eval      PREN = 'GL1121'
     C**********         Eval      FNM  = DDREF + 'X'                                        DAI101A
     C                   Eval      FNM  = DDREF + 'X' +  FBCHTP                              DAI101A
     C                   OUT       LDA
     C                   Call      'GLC1120'
     C                   EndIf
     C
     C*******************If        DDOPTN = 'D'                                              DAI101B
     C                   If        DDOPTN = 'R'                                              DAI101B
     C                   Z-Add     0             KNREF2                                     MD052332
     C                   Move      DDREF         KNREF2                                     MD052332
     C     KNREF2        Chain     XXAMACV0                                                 MD052332
     C                   If        %FOUND                                                   MD052332
     C                   Move      FBREF         FAREF                                      MD052332
     C                   EVAL      ACTN=DDOPTN                                              MD052332
     C                   EVAL      SBRCA=FBBRCA                                             MD052332
     C                   EVAL      SCCY=FBCCY                                               MD052332
     C                   Z-Add     FBAMNT        ZFLD15           15 0                      MD052332
     C                   Z-Add     PToNbDp       ZDECS             1 0                      MD052332
     C                   Call      'ZSEDIT'                                                 MD052332
     C                   Parm                    ZFLD15                                     MD052332
     C                   Parm                    ZDECS                                      MD052332
     C                   Parm      'M'           ZECODE            1                        MD052332
     C                   Parm                    ZOUT21           21                        MD052332
     C                   Move      ZOUT21        SAMNT                                      MD052332
     C                   Move      FBPRFC        SPRFC                                      MD052332
     C                   EVAL      PDayNoIn = FBSTDT                                        MD052332
     C                   CALL      'ZDATE2'                                                 MD052332
     C                   PARM                    PDaynoIn                                   MD052332
     C                   PARM                    BJDFIN                                     MD052332
     C                   PARM      *ZERO         PDateOut                                   MD052332
     C                   PARM      *BLANKS       PADateOut                                  MD052332
     C                   MOVE      PDateOut      SSTDT                                      MD052332
     C                   EVAL      PDayNoIn = FBMDAT                                        MD052332
     C                   CALL      'ZDATE2'                                                 MD052332
     C                   PARM                    PDaynoIn                                   MD052332
     C                   PARM                    BJDFIN                                     MD052332
     C                   PARM      *ZERO         PDateOut                                   MD052332
     C                   PARM      *BLANKS       PADateOut                                  MD052332
     C                   MOVE      PDateOut      SMDAT                                       DAI101B
     C                   EVAL      PDayNoIn = FBAPDA                                         DAI101B
     C                   CALL      'ZDATE2'                                                  DAI101B
     C                   PARM                    PDaynoIn                                    DAI101B
     C                   PARM                    BJDFIN                                      DAI101B
     C                   PARM      *ZERO         PDateOut                                    DAI101B
     C                   PARM      *BLANKS       PADateOut                                   DAI101B
     C                   MOVE      PDateOut      SAPDA                                       DAI101B
     C                   DOW       '1'                                                      MD052332
      ** Set indicator to display F10                                                       MD052332
     C                   EVAL      *IN95 = '1'                                              MD052332
     C                   EXFMT     XX0091E1                                                 MD052332
     C                   If        *IN12 = '1'                                              MD052332
     C                             OR *IN03 = '1'                                           MD052332
     C                             OR *IN10 = '1'                                           MD052332
     C                   Leave                                                              MD052332
     C                   Else                                                                DAI101A
      *                                                                                      DAI101A
      ** F15 Extnded Narrative by CGL141                                                     DAI101A
      *                                                                                      DAI101A
     C                   If        *IN15 = '1' And                                           DAI101A
     C                             CGL141 = 'Y'                                              DAI101A
     C                   Eval      #1BRCA = SBRCA                                            DAI101A
     C                   Eval      #1AREF = FAREF                                            DAI101A
     C                   Eval      #1PROG = 'XX000091'                                       DAI101A
     C                   Eval      #1ATYP = 'A'                                              DAI101A
     C                   Eval      #1CHTP = FBCHTP                                           DAI101A
                                                                                             DAI101A
     C                   Call      'WN0010'                                                  DAI101A
     C                   Parm      'XX000091'    WPGM             10                         DAI101A
     C                   Parm                    WFNKY             2                         DAI101A
     C                   Parm      DDOPTN        WACTN             1                         DAI101A
     C                   Parm                    DATA                                        DAI101A
     C                   Parm      *Blanks       WRTCD             7                         DAI101A
     C                   Parm                    WSPAR           256                         DAI101A
     C                   Endif                                                               DAI101A
                                                                                             DAI101A
     C                   Endif                                                              MD052332
     C                   Enddo                                                              MD052332
     C                   EVAL      *IN95 = '0'
     C                   Endif                                                              MD052332
     C                   If        *IN10 = *ON                                              MD052332
     C                   Z-Add     0             KNREF2            6 0
     C                   Move      DDREF         KNREF2
     C     KNREF2        Chain     XXAMACD1                           85
     C                   If        *IN85 = *OFF
     C                   Delete    XXAMACD1                             86
     C                                                                                       DAI101A
     C     KNREF2        Chain     XXGLAMAC1D                         87                     DAI101A
     C                   If        *IN87 = *Off                                              DAI101A
     C                             And *IN86 = *Off                                          DAI101A
     C                   Delete    XXGLAMAC1D                           88                   DAI101A
     C                   Endif                                                               DAI101A
     C                                                                                       DAI101A
     C                   If        *IN86 = *Off
     C                             And *IN88 = *Off                                          DAI101A
     C                   Commit
     C                   EndIf
     C                   EndIf
     C                   EndIf                                                              MD052332
      *                                                                                     MD052332
     C                   EndIf
     C
     C                   If        DDOPTN = 'E'                                             MD037691
     C                   Z-Add     0             KNREF2                                     MD037691
     C                   Move      DDREF         KNREF2                                     MD037691
     C     KNREF2        Chain     XXAMACV0                                                 MD037691
     C                   If        %FOUND                                                   MD037691
     C                   Move      FBREF         FAREF                                      MD037691
     C                   EVAL      ACTN=DDOPTN                                              MD037691
     C                   EVAL      SBRCA=FBBRCA                                             MD037691
     C                   EVAL      SCCY=FBCCY                                               MD037691
     C                   Z-Add     FBAMNT        ZFLD15           15 0                      MD037691
     C                   Z-Add     PToNbDp       ZDECS             1 0                      MD037691
     C                   Call      'ZSEDIT'                                                 MD037691
     C                   Parm                    ZFLD15                                     MD037691
     C                   Parm                    ZDECS                                      MD037691
     C                   Parm      'M'           ZECODE            1                        MD037691
     C                   Parm                    ZOUT21           21                        MD037691
     C                   Move      ZOUT21        SAMNT                                      MD037691
     C                   Move      FBPRFC        SPRFC                                      MD037691
     C                   EVAL      PDayNoIn = FBSTDT                                        MD037691
     C                   CALL      'ZDATE2'                                                 MD037691
     C                   PARM                    PDaynoIn                                   MD037691
     C                   PARM                    BJDFIN                                     MD037691
     C                   PARM      *ZERO         PDateOut                                   MD037691
     C                   PARM      *BLANKS       PADateOut                                  MD037691
     C                   MOVE      PDateOut      SSTDT                                      MD037691
     C                   EVAL      PDayNoIn = FBMDAT                                        MD037691
     C                   CALL      'ZDATE2'                                                 MD037691
     C                   PARM                    PDaynoIn                                   MD037691
     C                   PARM                    BJDFIN                                     MD037691
     C                   PARM      *ZERO         PDateOut                                   MD037691
     C                   PARM      *BLANKS       PADateOut                                  MD037691
     C                   MOVE      PDateOut      SMDAT                                      MD037691
     C                   EVAL      PDayNoIn = FBAPDA                                         DAI101B
     C                   CALL      'ZDATE2'                                                  DAI101B
     C                   PARM                    PDaynoIn                                    DAI101B
     C                   PARM                    BJDFIN                                      DAI101B
     C                   PARM      *ZERO         PDateOut                                    DAI101B
     C                   PARM      *BLANKS       PADateOut                                   DAI101B
     C                   MOVE      PDateOut      SAPDA                                       DAI101B
     C                   DOW       '1'                                                       DAI101A
      ** Set indicator to display F10                                                        DAI101A
     C                   EVAL      *IN95 = '0'                                               DAI101A
     C                   EXFMT     XX0091E1
     C                   If        *IN12 = '1'                                               DAI101A
     C                             OR *IN03 = '1'                                            DAI101A
     C                   Leave                                                               DAI101A
     C                   Else                                                                DAI101A
      *                                                                                      DAI101A
      ** F15 Extnded Narrative by CGL141                                                     DAI101A
      *                                                                                      DAI101A
     C                   If        *IN15 = '1' And                                           DAI101A
     C                             CGL141 = 'Y'                                              DAI101A
     C                   Eval      #1BRCA = SBRCA                                            DAI101A
     C                   Eval      #1AREF = FAREF                                            DAI101A
     C                   Eval      #1PROG = 'XX000091'                                       DAI101A
     C                   Eval      #1ATYP = 'A'                                              DAI101A
     C                   Eval      #1CHTP = FBCHTP                                           DAI101A
                                                                                             DAI101A
     C                   Call      'WN0010'                                                  DAI101A
     C                   Parm      'XX000091'    WPGM                                        DAI101A
     C                   Parm                    WFNKY                                       DAI101A
     C                   Parm      DDOPTN        WACTN                                       DAI101A
     C                   Parm                    DATA                                        DAI101A
     C                   Parm      *Blanks       WRTCD                                       DAI101A
     C                   Parm                    WSPAR                                       DAI101A
     C                   Endif                                                               DAI101A
                                                                                             DAI101A
     C                   Endif                                                               DAI101A
     C                   Enddo                                                               DAI101A
     C                   Endif                                                              MD037691
     C                   EndIf                                                              MD037691
     C                   EndIf
     C                   Eval      PZMsgFile = 'REUSRMSG'


      ** Exit if F3 requested

     C                   If        *INKC = '1'
     C                   Exsr      SREnd
     C                   EndIf

     C                   EndSr
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BegSr

      ** validate action codes for user

     C                   If        DDOPTN <> *Blanks

     C                   Call      'ZVACTU'
     C                   Parm      DDOPTN        ZACTN             1
     C                   Parm                    ERR               1 0

     C**********         EVAL      ERR = 0                                             TEDD MD037691

      ** This action code invalid for user

     C     ERR           Ifeq      1
     C                   Move      '1'           *IN32
     C                   Move      '1'           *IN94
     C                   Eval      PZMsgFile = 'SDUSRMSG'
     C                   Eval      PZMsgID = 'USR4436'
     C                   Exsr      SRZasnms
     C                   EndIf

     C                   EndIf

     C                   EndSr
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BegSr

      **  Check user's authority for the action & Booking Branch.

     C                   If        DDOPTN <> *Blanks

     C                   Call      'ZVACTBU'
     C                   Parm      DDOPTN        ZACTN             1
     C**********         Parm      BRC           ZBR               3                        MD037691
     C                   Parm      DDBRCA        ZBR               3                        MD037691
     C                   Parm                    ERR               1 0

     C**********         EVAL      ERR = 0                                             TEDD MD037691

      **   If action invalid for user

     C     ERR           Ifeq      1
     C                   Move      '1'           *IN32
     C                   Move      '1'           *IN94
     C                   Eval      PZMsgFile = 'DRSMM'
     C                   Eval      PZMsgID = 'RE71070'
     C                   Exsr      SRZasnms
     C                   Else
     C     ERR           Ifeq      2
     C                   Move      '1'           *IN32
     C                   Move      '1'           *IN94
     C                   Eval      PZMsgFile = 'SDUSRMSG'
     C                   Eval      PZMsgID = 'USR4436'
     C                   Exsr      SRZasnms
     C                   EndIf
     C                   EndIf
     C                   EndIf
     C                   EndSr
      /EJECT
      *****************************************************************
      * SREnd - End Program                                           *
      *                                                               *
      * Called by: Main routine, SRSelection                          *
      * Calls    :                                                    *
      *****************************************************************
     C     SREnd         BegSr

      ** Terminate program

     C                   Eval      *INLR = *ON

      ** Exit program

     C                   Return

     C                   EndSr
      /EJECT
      *****************************************************************
      * SRZasnms - Message Handling Subroutine                        *
      *                                                               *
      * Called by: Various                                            *
      * Calls    : ZA0340                                             *
      *****************************************************************
     C     SRZasnms      BegSr

     C                   If        PZMsgFile = *BLANKS
     C                   Eval      PZMsgFile = 'GBXXUSRMSG'
     C                   EndIf

     C                   Call      'ZA0340'
     C                   Parm                    PZMsgFile        10
     C                   Parm                    PZMsgID          10

     C                   Eval      PZMsgFile = *BLANKS

     C                   EndSr
      /EJECT




      *****************************************************************
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *  Calls    : AOBANKR0 - Access Bank Details                    *
      *             *PSSR                                             *
      *****************************************************************
     C     *INZSR        BegSr

      ** Set up copyright parameter

     C                   MoveA     CPY@          CPY2@

      ** Initialize program name

     C                   MoveL     'XX000091'    DBPGM

      ** Move workstation ID to screen field

     C                   Eval      ##PGMQ = PSProcName
     C                   Eval      DDUSR  = PsUser
     C                   Eval      DDWID  = PsJobName

      ** Initialise Subfile Control

     C                   Z-Add     13            WSFPG             3 0

      ** Access Bank Details

     C                   Call      'AOBANKR0'
     C                   Parm      '*DBERR '     @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
      *                                                                                      DAI101A
      ** Verify feature CGL141                                                               DAI101A
      *                                                                                      DAI101A
     C                   Move      'N'           CGL141            1                         DAI101A
     C                   Call      'AOSARDR0'                                                DAI101A
     C                   Parm      *BLANKS       @RTCD                                       DAI101A
     C                   Parm      '*KEY'        @OPTN                                       DAI101A
     C                   Parm      'CGL141'      @KEY6             6                         DAI101A
     C     SCSARD        Parm      SCSARD        DSFDY                                       DAI101A
      *                                                                                      DAI101A
     C     @RTCD         Ifeq      *BLANKS                                                   DAI101A
     C                   Move      'Y'           CGL141                                      DAI101A
     C                   Endif                                                               DAI101A
     C                                                                                       DAI101A

     C                   EndSr
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2015
