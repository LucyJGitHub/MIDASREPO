     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************                  HUT105
/*STD *  RPGBASEBND                                                   *                  HUT105
/*EXI *  TEXT('Midas SE Bulk Position Settlement Authorisation')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      ***SEH023**-*Bulk*Position*Settlement*Authorisation**************                  HUT105
      *  XX105023 - Bulk Position Settlement Authorisation            *                  HUT105
      *                                                               *
      *  Function:  This program allows bulk authorisation of         *
      *   (I/C)     outstanding Position Settlements that satisfy  al *
      *             the values entered on the three key fields        *
      *             (Security, Due Date, and Event Type).  It will    *
      *             also allow entry of a value date that will        *
      *             override the value date of the position           *
      *             settlement upon authorisation.                    *
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2008*************                  HUT105
      *  (c) Finastra International Systems Ltd. 2020                 *                  HUT105
      *                                                               *
      *  Last Amend No. HUT111             Date 07Apr20               *
      *  Prev Amend No. HUT105             Date 06Apr20               *
      *                 MD043182           Date 14Dec16               *
      *                 HUT024             Date 21Oct16               *
      *                 AR1027562          Date 12Sep12               *
      *                 AR1010460A         Date 10Aug12               *
      *                 AR1010460          Date 30Jul12               *
      *                 AR547625           Date 02Dec11               *
      *                 AR836848           Date 06Oct11               *
      *                 AR833272           Date 26Sep11               *
      *                 AR586601           Date 03Aug10               *
      *                 HUT015             Date 01Jul10               *
      *                 259148A            Date 14Apr09               *
      *                 259148             Date 05Mar09               *
      *                 258113             Date 14Jan09               *
      *                 HUT011I08          Date 20Aug08               *
      *                 HUT011I07          Date 19Aug08               *
      *                 HUT011I06          Date 05Aug08               *
      *                 HUT011I05          Date 01Aug08               *
      *                 HUT011I04          Date 30Jul08               *
      *                 HUT011I03          Date 18Jun08               *
      *                 HUT011  *CREATE    Date 12May08               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  HUT111 - 4 Eyes on Bulk Position Settlement                  *
      *           (Upgrade of HUT015 to FM2.1)                        *
      *  HUT105 - Bulk Position Settlements                           *
      *           (Upgrade HUT011/015 to FM2.1 SP22)                  *
      *  MD043182 - Inconsistency in Block CR/DR indicator and POST   *
      *  HUT024 - Corporate Actions Blocked Credit Account            *
      *  AR1027562 - As per the client's request if at least one      *
      *              record has a blocked CR/DR, bulk authorisation   *
      *              will be forbidden. (Child: AR1027563)            *
      *  AR1010460A - Field 'AUTH' introduced in AR1010460 is being   *
      *               overridden by ACCNTAB, use *IN70 instead.       *
      *               (Child: AR1010461A)                             *
      *  AR1010460 - Bulk Position Settlement Authorisation on        *
      *              Closed/Blocked Accounts, fix is to let valid     *
      *              records be authorised and introduce new error    *
      *              message to show the invalid settlement account.  *
      *              (Child: AR1010461)                               *
      *  AR547625 - No Warning message for SE bulk position sett      *
      *             authorisation for closed account. Fix is to add   *
      *             the validation of closed accounts.                *
      *             (Child: AR547626)                                 *
      *  AR836848 - If user is not authorized to any branch for these *
      *             transactions, user should get error message 'No   *
      *             outstanding Position Settlements for the Security *
      *             Event entered' also enhanced fix AR833272.        *
      *             (Child: AR836849)                                 *
      *  AR833272 - User is able to authorise position settlements    *
      *             that he is not authorised to (branch code).       *
      *             Fix is to update only those records that the user *
      *             is authorised to (Child: AR833273).               *
      *  AR586601 - Unable to allocate a record in PSAUT. Fix is to   *
      *             put 'N' in position 53 of CHAIN opcode used only  *
      *             for validation and not update.                    *
      *  HUT015 - 4eyes on Bulk Position Settlement Function          *
      *  259148A - Validate ALL settlement account.                   *
      *  259148 - Validate settlement account and value date.         *
      *  258113 - Recompiled due to changes in POSETV0 and POSETV2.   *
      *  HUT011I08 - Authorisation not reflected on Projected         *
      *              Account Movements                                *
      *  HUT011I07 - Unable to display value date during authorise    *
      *  HUT011I06 - Allow MT event type during amend                 *
      *  HUT011I05 - Unable to allocate record in POSETV2             *
      *  HUT011I04 - Value date must accept future date.              *
      *  HUT011I03 - Fix error during amend                           *
      *  HUT011 - Bulk Position Settlement Authorisation              *
      *                                                               *
      *****************************************************************
      *
      * ID F  C  H  L    FUNCTION OF INDICATORS
      *
      *       03         Exit from Program
      *       08         Unauthorised Pos Sett Report
      *       09         Authorised Pos Sett Report
      *       10         Authorised Position Settlement
      *       12         Cancel
      *       30         Action Field indicator
      *       31         Security,Due Date,Event Type(UL,PR)
      *       32         Value Date (UL,PR)
      *       33         Action field validation
      *       34         Security shortname validation
      *       35         Due Date validation
      *       36         Event Type validation
      *       37         Value Date validation
      *       38         Value Date display/non-display indicator
      *       40         Status Field
      *       41         Settlement Account validation                                        259148
      *       75         Error indicator in SR/VALINS
      *       76         Error indicator in SR/LOAD for Amend/Authorise
      *                  If position settlement should not be amended or
      *                  authorised, this indicator is set ON
      *       77         Indicator for no outstanding security event                       HUT011I03
      *       88         Chain to File
      *****************************************************************
      *
     F**********SEH023DF  CF   E             WORKSTN                                     HUT105
     FXX105023DFCF   E             WORKSTN                                               HUT105
      ** Bulk Amend/Auth of Position Settlements Display File
      *
     F**********POSETV0   IF   E           K DISK                                        HUT105
     FXXPOSEL0  IF   E           K DISK                                                  HUT105
     F**********POSETV2   UF   E           K DISK    COMMIT                              HUT105
     FXXPOSEL2  UF   E           K DISK    COMMIT                                        HUT105
     F                                               RENAME(POSETDF:POSETDFB)            HUT105
     FSECOATL0  IF   E           K DISK
     FSECORFL0  IF   E           K DISK
     FSECOALLA  UF   E           K DISK    COMMIT
     FSECODPL7  UF   E           K DISK    COMMIT
     FPOSETDY3  UF A E           K DISK    COMMIT
     FREADVCL3  UF A E           K DISK    COMMIT
     FSECTY     IF   E           K DISK
     FSDSECSL0  IF   E           K DISK
     FACCNT     IF   E           K DISK
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
     FACNUM     IF   E           K DISK
     F                                     RENAME(ACCNTABF:ACNUMF)
     FPSAUT     UF   E           K DISK                                                       HUT015
      ** Midas SE Position Settlement Authorisation detail                                    HUT015
      *                                                                                       HUT015
     F**********SEPOBCPP  O    E             DISK    COMMIT                                   HUT111
     FXXPOBCTD  O    E             DISK    COMMIT                                             HUT111
      **  Midas SE Position Settlement Blocked Credit Account Details                         HUT024
      *****************************************************************
      /EJECT
     D**********/COPY ZSRSRC,ZHOLE                                                     259148 HUT105
     D/COPY ZSRSRC,ZHOLELE                                                                    HUT105
      *
      ** Array containing Copyright statement
     D ERR             S             24    DIM(99)
      *                                                                                       HUT015
     D A@CPY           DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D LDA           E DS           256    EXTNAME(LDA)
     D  W24          E                     EXTFLD(SPARE)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D PSDS           SDS
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
      *
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
      *
     D ZMUSER          DS            17
      ** External data area of default branch for user
      *
     D  ZDFB                  11     13
      *
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D  TNLUX1               168    170P 0
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D  TNLUX2               168    170P 0
      *
     D DETREC        E DS                  EXTNAME(POSETD)
      ** DATA STRUCTURE FOR INITIALISING A RECORD
      *
     D  PBCAX        E                     EXTFLD(PBCA)
     D  PSSHX        E                     EXTFLD(PSSH)
     D  PCPYX        E                     EXTFLD(PCPY)
     D  PDUDX        E                     EXTFLD(PDUD)
     D  PEVTX        E                     EXTFLD(PEVT)
     D  PAUIX        E                     EXTFLD(PAUI)
     D  PSMIX        E                     EXTFLD(PSMI)
     D  CHTPX        E                     EXTFLD(CHTP)
     D  PMARX        E                     EXTFLD(PMAR)
      *                                                                                       259148
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      **  Retail Details                                                                      259148
     D  ACD2QQ       E                     EXTFLD(QQACCD)
      *                                                                                       259148
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      **  Securities Client Details                                                           259148
     D  ACD3QQ       E                     EXTFLD(QQACCD)
     D*                                                                                       259148
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D**  Branch Details                                                                      259148
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  DFLCD        E                     EXTFLD(LCD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *  FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)                                HUT105
      *  Second DS for access programs, Long data structure                              HUT105
      *
     D RUNDT           DS
      ** DATA AREA RUNDAT
      *
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
      *
      ** Constant Fields
     D #USTAT          C                   CONST('UNAUTHORISED')
     D #ASTAT          C                   CONST('AUTHORISED  ')
     D #AUTH           C                   CONST('Press F10 to confirm-
     D                                      bulk authorise of P-
     D                                     osition Settlements')
     D #VLDTX          C                   CONST('Value Date:')
     D #DFRMT          C                   CONST('(DDMMYY)')
      *
     D                 DS
     D  WREFNO                 1     26
     D  WSSH                   1     10
     D  WCPY                  11     16
     D  WBCA                  17     19
     D  WDUD                  20     24
     D  WEVT                  25     26
      *                                                                                       259148
     D                 DS            18
     D  PSEA@                  1     18
     D**CUS@****               1      6  0                                               HUT105
     D  CUS@                   1      6                                                  HUT105
     D  ACOD@                  7     16  0
     D  ACSQ@                 17     18  0
     D                 DS
     D**K1CNUM**               1      6  0                                               HUT105
     D  K1CNUM                 1      6                                                  HUT105
     D  K1CCY                  7      9
     D  QQACOD                10     13  0
     D  K1ACSQ                14     15  0
     D  K1BRCA                16     18
     D  K1ACOD                19     28  0
     D                 DS                                                       AR1010460
     D  MSGDTA                 1     24                                         AR1010460
     D  BRCA                   1      3                                         AR1010460
     D**CNUM****               4      9  0                                      AR1010460 HUT105
     D  CNUM                   4      9                                                   HUT105
     D  CCY                   10     12                                         AR1010460
     D  ACOD                  13     22  0                                      AR1010460
     D  ACSQ                  23     24  0                                      AR1010460
      *                                                                                   259148
     D**********/COPY ZSRSRC,ZHOLI                                                 259148 HUT105
     D/COPY ZSRSRC,ZHOLILE                                                                HUT105
      **  EXTERNAL DS FOR HOLIDAY DETAILS                                                 259148
      *                                                                                   259148
     D**********/COPY ZSRSRC,ZHOLDS                                                259148 HUT105
      **  EXTERNAL DS FOR HOLIDAY DETAILS AND ACCESS OBJECTS                              259148
     D*                                                                                   259148
      ** Reference Number Data Structure
      *
     D WPSET           C                   CONST('PositionSettlement')
      *
      ** Override Commands
     D DSSEC1          DS
     D  SECTZ1                 1     31    INZ('OVRDBF SECTYZ1 SECTY-
     D                                      SHARE(*NO)')
     D DSSEC2          DS
     D  SECTZ2                 1     31    INZ('OVRDBF SECTYZ2 SECTY-
     D                                      SHARE(*NO)')
      *
      *****************************************************************
      /SPACE 3
      *****************************************************************
     IACCNTABF
     I              RECI                        RECIA
     I              PTFR                        PTFR1
     IACNUMF
     I              RECI                        RECIA
     I              PTFR                        PTFR2
      *                                                                                       259148
     IPOSETDFB
     I              TNLU                        PTNLU
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ** Initialise data
      *
     C                   EXSR      INIT
      *
      ** Continue to redisplay the screen if F3 is not yet pressed
      *
     C     *IN03         DOUEQ     '1'
      *
     C                   MOVE      '0'           *IN08
     C                   MOVE      '0'           *IN09
      *
      ** Display program messages
      *
     C**********         WRITE     SEH023F3                                              HUT105
     C                   WRITE     XX105023F3                                            HUT105
      *
      ** Main Format of the display file
      *
     C     *IN38         IFEQ      '0'
     C     *IN75         ANDEQ     '1'
     C     *IN79         ANDEQ     '1'
     C     *IN80         ANDEQ     '0'
     C**********         EXFMT     SEH023F1                                              HUT105
     C                   EXFMT     XX105023F1                                            HUT105
     C     *IN03         IFEQ      '1'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
      *
      ** Clear program messages
      *
     C**********           EXSR CLEAR                                                      HUT011I03
      *
      ** Execute first validation on the screen
      *
     C                   EXSR      VALINS
     C     *IN12         IFEQ      '1'
     C                   EXSR      INIT
     C                   ENDIF
      *
     C     *IN08         IFEQ      '1'
     C     *IN80         ANDEQ     '0'
     C     *IN09         OREQ      '1'
     C     *IN80         ANDEQ     '0'
     C                   EXSR      REPORT
     C                   ENDIF
      *                                                                                    HUT011I03
      ** If no errors found on the first validation
      *
     C     *IN75         IFEQ      '0'
     C     *IN79         ANDEQ     '0'
      *
     C                   EXSR      LOAD
     C     *IN03         IFEQ      '1'
     C                   LEAVE
     C                   ENDIF
      *
     C     *IN12         CASEQ     '1'           INIT
     C     *IN08         CASEQ     '1'           REPORT
     C     *IN09         CASEQ     '1'           REPORT
     C                   CAS                     VALID
     C                   ENDCS
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Comit all changes
      *
     C**********           COMIT                                                           HUT011I05
      *
      ** Exit from program
      *
     C                   EXSR      #END
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CLEAR - CLEAR MESSAGE FILE                                   *
      *                                                               *
      *****************************************************************
     C     CLEAR         BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
     C                   Z-ADD     0             X                 4 0
     C                   CLEAR                   ERR
      *                                                                                    AR1010460
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  EXIT - EXIT FROM PROGRAM IF F3 HAS BEEN PRESSED              *
      *                                                               *
      *****************************************************************
     C     #END          BEGSR
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INIT - INITIALISE FIELDS                                     *
      *                                                               *
      *****************************************************************
      *
     C     INIT          BEGSR
      *
      ** Only do first time through
      *
     C     *IN01         IFEQ      '0'
      *
      **  Get Bank details
      *
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE    RUNDAT        RUNDT
     C                   IN        RUNDT
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Set up Key List for Chaining to POSET file
      *
     C     POSET0        KLIST
     C                   KFLD                    SESESN
     C                   KFLD                    KDUDT
     C                   KFLD                    SEEVTP
      *
     C     POSET1        KLIST
     C                   KFLD                    SESESN
     C                   KFLD                    KDUDT
     C                   KFLD                    SEEVTP
      *
     C     POSET2        KLIST
     C                   KFLD                    SESESN
     C                   KFLD                    KDUDT
     C                   KFLD                    SEEVTP
      *                                                                                       259148
      ** Key to ACCNTAB                                                                       259148
      *                                                                                       259148
     C     ACCNT1        KLIST
     C                   KFLD                    K1CNUM
     C                   KFLD                    K1CCY
     C                   KFLD                    K1ACOD
     C                   KFLD                    K1ACSQ
     C                   KFLD                    K1BRCA
      *                                                                                       259148
      ** Key to ACCNT                                                                         259148
      *                                                                                       259148
     C     ACCNT2        KLIST
     C                   KFLD                    CUS@
     C                   KFLD                    K2CCY             3
     C                   KFLD                    ACOD@
     C                   KFLD                    ACSQ@
     C                   KFLD                    K2BRCA            3
      *                                                                                       HUT015
      *  Key to PSAUT                                                                         HUT015
      *                                                                                       HUT015
     C     KPSAUT        KLIST
     C                   KFLD                    PBCA
     C                   KFLD                    PSSH
     C                   KFLD                    PCPY
     C                   KFLD                    PDUD
     C                   KFLD                    PEVT
     C                   KFLD                    PTFR
     C                   KFLD                    PTNLU
     C                   KFLD                    TXBS
     C                   KFLD                    BNFO
     C                   KFLD                    EXCD
      *
      ** Check if CRE020 is enabled.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CRE020'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   MOVE      'N'           CRE020            1
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CRE020
     C**********         MOVEL     'SEH023'      KPRGMN                                  HUT105
     C                   MOVEL     'XX105023'    KPRGMN                                  HUT105
     C                   ENDIF
     C*                                                                                       259148
     C**  Access SAR details file to see if S01512 SAR is installed.                          259148
     C*                                                                                       259148
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01512'      @SARD             6
     C*                                                                                       259148
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01512            1
     C                   MOVE      '1'           *IN19
     C                   ELSE
     C                   MOVE      'N'           S01512
     C                   MOVE      '0'           *IN19
     C                   ENDIF
     C*                                                                                       259148
     C**  Access Retail details                                                               259148
     C*                                                                                       259148
     C********** *INU1     IFEQ '1'                                                    259148 HUT024
     C                   CALL      'AORETLR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
     C**********           ENDIF                                                       259148 HUT024
      *                                                                                       HUT024
      **Obtain*switchable*feature*HUT024*status.                                       HUT024 HUT111
      * Obtain switchable feature HUT111 status.                                              HUT111
      *                                                                                       HUT024
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C**********         PARM      'HUT024'      @SARD             6                          HUT111
     C                   PARM      'HUT111'      @SARD             6                          HUT111
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       HUT024
     C     @RTCD         IFEQ      *BLANK
     C**********         MOVE      'Y'           HUT024            1                          HUT111
     C                   MOVE      'Y'           HUT111            1                          HUT111
     C                   ELSE
     C**********         MOVE      'N'           HUT024                                       HUT111
     C                   MOVE      'N'           HUT111                                       HUT111
     C                   ENDIF
      *                                                                                       HUT024
      **Obtain*switchable*feature*HUT015*status.                                       HUT015 HUT105
      *                                                                                       HUT015
     C**********         CALL      'AOSARDR0'                                                 HUT105
     C**********         PARM      *BLANKS       @RTCD             7                          HUT105
     C**********         PARM      '*VERIFY'     @OPTN             7                          HUT105
     C**********         PARM      'HUT015'      @SARD             6                          HUT105
     C*****SCSARD        PARM      SCSARD        DSFDY                                        HUT105
      *                                                                                       HUT015
     C**********         SELECT                                                               HUT105
     C*****@RTCD         WHENEQ    *BLANK                                                     HUT105
     C**********         MOVE      'Y'           HUT015            1                          HUT105
     C*****@RTCD         WHENEQ    '*NRF'                                                     HUT105
     C**********         MOVE      'N'           HUT015                                       HUT105
     C**********         OTHER                                                                HUT105
     C******LOCK         IN        LDA                                                        HUT105
     C**********         MOVEL     'SCSARDPD'    DBFILE                          *************HUT105
     C**********         Z-ADD     002           DBASE                           *DBERROR 002*HUT105
     C**********         MOVEL     @OPTN         DBKEY                           *************HUT105
     C**********         SETON                                        U7U8LR                  HUT105
     C**********         OUT       LDA                                                        HUT105
     C**********         EXSR      *PSSR                                                      HUT105
     C**********         ENDSL                                                                HUT105
      ** Override SECTY to SECTYZ1 and SECTYZ2
     C                   CALL      'QCMDEXC'
     C                   PARM                    SECTZ1
     C                   PARM      31            WWSEC            15 5
      *
     C                   CALL      'QCMDEXC'
     C                   PARM                    SECTZ2
     C                   PARM      31            WWSEC
      *
      ** Check if a System Value exists for this maintenance.
      *
     C     CRE020        IFEQ      'Y'
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      WPSET         PSV01            20
     C                   PARM                    PCS01           200
     C                   PARM                    PSV02            20
     C                   PARM                    PCS02           200
     C                   PARM                    PSV03            20
     C                   PARM                    PCS03           200
     C                   PARM                    PSV04            20
     C                   PARM                    PCS04           200
     C                   PARM                    PSV05            20
     C                   PARM                    PCS05           200
     C                   PARM                    PSV06            20
     C                   PARM                    PCS06           200
     C                   PARM                    PSV07            20
     C                   PARM                    PCS07           200
     C                   PARM                    PSV08            20
     C                   PARM                    PCS08           200
     C                   PARM                    PSV09            20
     C                   PARM                    PCS09           200
     C                   PARM                    PSV10            20
     C                   PARM                    PCS10           200
      *
     C                   MOVE      'N'           WSV01             1
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     PCS01         WSV01
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      '1'           *IN01
     C                   ENDIF
      *
      ** Clear program messages
      *
     C                   EXSR      CLEAR
      *
      ** Setup Screen Title Fields
      *
     C                   MOVEL     USER          ##USR
     C                   MOVEL     BJMRDT        ##MRDT
     C                   MOVEL     JOB           ##JOB
      *
      ** Initialise fields
      *
     C                   MOVE      *BLANKS       SESTAT
     C                   MOVE      *BLANKS       SEACTN
     C                   MOVE      *BLANKS       SESESN
     C                   MOVE      *BLANKS       SEDUDT
     C                   MOVE      *BLANKS       SEEVTP
     C                   MOVE      *BLANKS       SEVLDT
      *
      ** Initialise Indicators
      *
     C                   MOVE      *OFF          *IN08
     C                   MOVE      *OFF          *IN09
     C                   MOVE      *OFF          *IN30
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN32
     C                   MOVE      *OFF          *IN33
     C                   MOVE      *OFF          *IN34
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN36
     C                   MOVE      *OFF          *IN37
     C                   MOVE      *OFF          *IN38
     C                   MOVE      *OFF          *IN39
     C                   MOVE      *OFF          *IN40
     C                   MOVE      *OFF          *IN41
     C                   MOVE      *ON           *IN75
     C                   MOVE      *OFF          *IN78
     C                   MOVE      *ON           *IN79
     C                   MOVE      *OFF          *IN80
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALINS - VALIDATE ACTION CODE, SECURITY, DUE DATE            *
      *           & EVENT TYPE                                        *
      *                                                               *
      *****************************************************************
      *
     C     VALINS        BEGSR
      *                                                                                    HUT011I03
      ** Clear program messages                                                            HUT011I03
      *                                                                                    HUT011I03
     C     *IN37         IFEQ      '0'
     C     *IN41         ANDEQ     '0'
     C     *IN78         ANDEQ     '0'
     C                   EXSR      CLEAR
     C                   ENDIF
      *
     C                   MOVE      '0'           *IN75
     C                   MOVE      '0'           *IN79
     C                   MOVE      '0'           *IN80
      *
      ** Validate Action Code
      *
     C                   MOVE      '0'           *IN33
     C                   MOVEL     SEACTN        #ZACTN
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C**********           CALL 'ZVACTBU'                                                   AR836848
     C**********           PARM           #ZACTN  1                                         AR836848
     C**********           PARM           ZDFB                                              AR836848
     C**********           PARM           #ERR    10                                        AR836848
      *
     C********** #ERR      IFNE 0                                                           AR836848
     C     SEACTN        IFNE      'E'
     C     SEACTN        ANDNE     'A'
     C     SEACTN        ANDNE     'Y'
     C     SEACTN        OREQ      *BLANKS
     C                   MOVE      '1'           *IN33
     C                   MOVE      '1'           *IN75
     C                   MOVE      '1'           *IN79
     C                   MOVE      'HUT1108'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      ** Validate Security Shortname
      *
     C                   MOVE      '0'           *IN34
     C     SESESN        IFEQ      '?'
     C                   CALL      'SE0043'
     C                   PARM      SEACTN        PACODE            1
     C                   PARM      '?'           @SESN            10
      *
     C     @SESN         IFNE      *BLANKS
     C                   MOVEL     @SESN         SESESN
     C                   ELSE
     C                   MOVE      *BLANKS       SESESN
     C                   ENDIF
     C                   ENDIF
      *
      **  should not be blank
      *
     C     SESESN        IFEQ      *BLANKS
     C                   MOVE      '1'           *IN34
     C                   MOVE      '1'           *IN75
     C                   MOVE      '1'           *IN79
     C                   MOVE      'HUT1109'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      **  if manually inputted, should be a valid security shortname
      *
     C     SESESN        IFNE      *BLANKS
     C     SESESN        CHAIN     SECTY                              88
     C     *IN88         IFEQ      '1'
     C                   MOVE      '1'           *IN34
     C                   MOVE      '1'           *IN75
     C                   MOVE      '1'           *IN79
     C                   MOVE      'HUT1101'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Due Date (DDMMYY & not greater than rundate)
      *
     C                   MOVE      '0'           *IN35
     C                   MOVEL     SEDUDT        ZDATE1
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE1            6 0
     C                   PARM      *BLANKS       ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
     C                   Z-ADD     ZDAYNO        KDUDT             5 0
      *
     C     ZERR          IFNE      *BLANKS
     C                   MOVE      '1'           *IN35
     C                   MOVE      '1'           *IN75
     C                   MOVE      '1'           *IN79
     C                   MOVE      'HUT1106'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C     ZERR          IFEQ      *BLANKS
     C     ZDAYNO        ANDGT     RUND
     C                   MOVE      '1'           *IN35
     C                   MOVE      '1'           *IN75
     C                   MOVE      '1'           *IN79
     C                   MOVE      'HUT1106'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      ** Validate Event Type
      *
     C                   MOVE      '0'           *IN36
     C     SEEVTP        IFNE      'CP'
     C     SEEVTP        ANDNE     'DV'
     C     SEEVTP        ANDNE     'PP'
     C     SEEVTP        ANDNE     'MT'
     C     SEEVTP        ANDNE     'MP'
     C     SEEVTP        ANDNE     'RC'
     C                   MOVE      '1'           *IN36
     C                   MOVE      '1'           *IN75
     C                   MOVE      '1'           *IN79
     C                   MOVE      'HUT1102'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C     SEACTN        IFEQ      'A'
     C     SEEVTP        ANDNE     'CP'
     C     SEEVTP        ANDNE     'DV'
     C     SEEVTP        ANDNE     'MT'
     C                   MOVE      '1'           *IN36
     C                   MOVE      '1'           *IN75
     C                   MOVE      '1'           *IN79
     C                   MOVE      'HUT1103'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                     AR836848
     C*****POSET0        SETLL     POSETV0                                                  HUT105
     C*****POSET0        READE(N)  POSETV0                                88                HUT105
     C     POSET0        SETLL     XXPOSEL0                                                 HUT105
     C     POSET0        READE(N)  XXPOSEL0                               88                HUT105
      *                                                                                     AR836848
     C                   MOVE      *BLANKS       SAVBA
     C                   MOVE      *OFF          *IN81
      *                                                                                     AR836848
     C     *IN88         DOWEQ     '0'
     C     PBCA          IFNE      SAVBA
     C                   MOVEL     PBCA          SAVBA
     C                   Z-ADD     0             @ERR
     C                   CALL      'ZVACTBU'
     C                   PARM                    #ZACTN            1
     C                   PARM      PBCA          @ZBRCD            3
     C                   PARM                    @ERR              1 0
     C     @ERR          IFEQ      0
     C                   MOVE      *OFF          *IN81
     C                   LEAVE
     C                   ENDIF
     C     @ERR          IFEQ      2
     C                   MOVE      *ON           *IN81
     C                   ENDIF
     C                   ENDIF
     C*****POSET0        READE(N)  POSETV0                                88                HUT105
     C     POSET0        READE(N)  XXPOSEL0                               88                HUT105
     C                   ENDDO
      *                                                                                     AR836848
     C     *IN81         IFEQ      *ON
     C                   MOVE      '1'           *IN33
     C                   MOVE      '1'           *IN75
     C                   MOVE      '1'           *IN79
     C                   MOVE      'HUT1119'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  LOAD - LOAD VALUE DATE ON THE SCREEN                         *
      *                                                               *
      *****************************************************************
     C     LOAD          BEGSR
      *
      ** Check if the input fields are found in POSETV0
      *
     C                   MOVE      *OFF          *IN77
     C                   MOVE      *OFF          *IN08
     C                   MOVE      *OFF          *IN09
      *                                                                                    HUT011I03
     C********** POSET0    CHAINPOSETV0              88                                    HUT011I05
     C********** POSET0    CHAINPOSETV0             N88                           HUT011I05 AR836848
     C*****POSET0        SETLL     POSETV0                                                 HUT105
     C*****POSET0        READE(N)  POSETV0                                88               HUT105
     C     POSET0        SETLL     XXPOSEL0                                                HUT105
     C     POSET0        READE(N)  XXPOSEL0                               88               HUT105
      *                                                                                     AR836848
     C                   MOVE      *BLANKS       SAVBA
      *                                                                                     AR836848
     C     *IN88         DOWEQ     '0'
      *                                                                                     AR836848
     C     PBCA          IFNE      SAVBA
     C                   MOVEL     PBCA          SAVBA
     C                   Z-ADD     0             @ERR
     C                   CALL      'ZVACTBU'
     C                   PARM      SEACTN        #ZACTN
     C                   PARM      PBCA          @ZBRCD
     C                   PARM                    @ERR
      *                                                                                     AR836848
     C     @ERR          IFEQ      0
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
      *                                                                                     AR836848
     C*****POSET2        READE(N)  POSETV0                                88                HUT105
     C     POSET2        READE(N)  XXPOSEL0                               88                HUT105
     C                   ENDDO
      *                                                                                     AR836848
     C     *IN88         IFEQ      '1'
     C     @ERR          ORNE      0
     C                   MOVE      *ON           *IN75
     C                   MOVE      *ON           *IN76
     C                   MOVE      *ON           *IN77
     C                   MOVE      *ON           *IN79
     C                   MOVE      'HUT1104'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   MOVE      *ON           *IN80
     C**********         WRITE     SEH023F3                                              HUT105
     C**********         EXFMT     SEH023F1                                              HUT105
     C                   WRITE     XX105023F3                                            HUT105
     C                   EXFMT     XX105023F1                                            HUT105
     C                   ELSE
      *
     C                   MOVE      *ON           *IN40
     C                   MOVE      *OFF          *IN76
     C                   MOVE      *OFF          *IN75
      *
      **  Get the equivalent DDMMYY of value date from POSETV0
      **  for initial screen only (default the value date)                                 HUT011I03
      *
     C     *IN37         IFEQ      '0'
     C                   Z-ADD     PSVL          #VLDT0            5 0
     C                   Z-ADD     #VLDT0        ZDAYNO
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM      *BLANKS       ZDATFM
     C                   PARM                    ZDATE2            6 0
     C                   PARM                    ZADATE            7
      *
     C                   MOVEL     ZDATE2        PVLDT0            6
      *
     C********** POSET2    CHAINPOSETV2              89                                    HUT011I05
     C********** POSET2    CHAINPOSETV2             N89                           HUT011I05 AR833272
     C*****POSET2        SETLL     POSETV2                                               HUT105
     C*****POSET2        READE(N)  POSETV2                                89             HUT105
     C     POSET2        SETLL     XXPOSEL2                                              HUT105
     C     POSET2        READE(N)  XXPOSEL2                               89             HUT105
      *                                                                                     AR833272
     C                   MOVE      *BLANKS       SAVBA
      *                                                                                     AR836848
     C     *IN89         DOWEQ     '0'
      *                                                                                     AR833272
     C     PBCA          IFNE      SAVBA
     C                   MOVEL     PBCA          SAVBA
     C                   Z-ADD     0             @ERR
     C**********           CALL 'ZVBBU'                                            AR833272 AR836848
     C**********           PARM PBCA      @ZBRCD  3                                AR833272 AR836848
     C**********           PARM           @ERR    10                               AR833272 AR836848
     C                   CALL      'ZVACTBU'
     C                   PARM      SEACTN        #ZACTN
     C                   PARM      PBCA          @ZBRCD
     C                   PARM                    @ERR
      *                                                                                     AR833272
     C     @ERR          IFEQ      0
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
      *                                                                                     AR833272
     C*****POSET2        READE(N)  POSETV2                                89             HUT105
     C     POSET2        READE(N)  XXPOSEL2                               89             HUT105
     C                   ENDDO
      *                                                                                     AR833272
     C     *IN89         IFEQ      '0'
     C     @ERR          ANDEQ     0
      *
      ** If record found, position settlement is unauthorised
      ** Get the value date from POSETV2
      *
     C                   MOVEL     *BLANKS       SESTAT
     C                   MOVEL     #USTAT        SESTAT
     C                   Z-ADD     PSVL          #VLDT2            5 0
     C                   Z-ADD     #VLDT2        ZDAYNO
      *
      ** Get the equivalent DDMMYY of value date of POSETV2
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM      *BLANKS       ZDATFM
     C                   PARM                    ZDATE2            6 0
     C                   PARM                    ZADATE            7
      *
     C                   MOVEL     ZDATE2        PVLDT2            6
     C     SEVLDT        IFEQ      *BLANK
     C                   MOVEL     PVLDT2        SEVLDT
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Else, position settlement is already authorised
      ** Get the value date from POSETV0
      *
     C                   MOVEL     *BLANKS       SESTAT
     C                   MOVEL     #ASTAT        SESTAT
     C                   MOVEL     PVLDT0        SEVLDT
     C                   ENDIF
     C                   ENDIF
      *
      **  Enquire
      *
     C     SEACTN        IFEQ      'E'
     C                   MOVE      *ON           *IN40
     C                   MOVE      *ON           *IN30
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN32
     C                   ENDIF
      *
      **  Amend
      *
     C     SEACTN        IFEQ      'A'
     C                   MOVE      *ON           *IN40
     C                   MOVE      *OFF          *IN76
     C                   MOVE      *ON           *IN30
     C                   MOVE      *ON           *IN31
     C     SESTAT        IFEQ      #ASTAT
     C                   MOVE      *ON           *IN32
     C                   MOVE      *OFF          *IN38
     C                   MOVE      *ON           *IN76
     C                   MOVE      'HUT1105'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVEL     #VLDTX        SEVLTX
     C                   MOVEL     #DFRMT        SEFRMT
     C                   MOVE      *ON           *IN38
     C                   MOVE      *OFF          *IN32
     C                   ENDIF
     C                   ENDIF
      *
      **  Authorised
      *
     C     SEACTN        IFEQ      'Y'
     C                   MOVE      *ON           *IN40
     C                   MOVE      *ON           *IN30
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN32
     C                   MOVE      *OFF          *IN76
     C                   MOVE      *BLANKS       SEAUTH
      *
     C     SESTAT        IFEQ      #USTAT
     C                   MOVEL     #VLDTX        SEVLTX
     C                   MOVEL     #DFRMT        SEFRMT
     C                   MOVE      *ON           *IN38
     C                   MOVE      *ON           *IN39
     C                   MOVEL     #AUTH         SEAUTH
     C                   ELSE
     C                   MOVE      *ON           *IN76
     C                   MOVE      'HUT1105'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN37         IFEQ      *OFF
     C**********         WRITE     SEH023F3                                              HUT105
     C                   WRITE     XX105023F3                                            HUT105
     C                   ENDIF
     C**********         EXFMT     SEH023F1                                              HUT105
     C                   EXFMT     XX105023F1                                            HUT105
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALID - VALIDATION FOR AMEND AND AUTHORISE POS SETTLEMENT    *
      *                                                               *
      *****************************************************************
     C     VALID         BEGSR
      *                                                                                    HUT011I03
     C     *IN77         IFEQ      '0'
     C                   EXSR      CLEAR
     C                   ENDIF
      *
      ** If the Action Code is Enquire, exit the subroutine
      *
     C     SEACTN        IFEQ      'E'
     C                   GOTO      XVALID
     C                   ENDIF
      *                                                                                       HUT024
      * If HUT024 is On, perform check on all position settlements for the                    HUT024
      * defined Security, Due Date and Event Type and if any involve receipt                  HUT024
      * of funds over an account blocked for credits, show warning message                    HUT024
     C*****HUT024        IFEQ      'Y'                                                        HUT111
     C     HUT111        IFEQ      'Y'                                                        HUT111
     C     SEACTN        ANDEQ     'Y'
     C     *IN10         ANDEQ     *ON
     C     SEEVTP        IFEQ      'CP'
     C     SEEVTP        OREQ      'DV'
     C     SEEVTP        OREQ      'MT'
      *                                                                                       HUT024
      * If Account Blocked for Credit flag is 'Y', it means this check has                    HUT024
      * already been carried out and the warning message displayed.                           HUT024
      * If processing for the same Security, Due Date and Event Type combination              HUT024
      * skip the check now and allow processing to continue                                   HUT024
     C     ACBC          IFEQ      'Y'
     C     SESESN        ANDEQ     WSESN
     C     SEDUDT        ANDEQ     WDUDT
     C     SEEVTP        ANDEQ     WEVTP
     C                   MOVE      *ON           *IN83
     C                   GOTO      EABCCK
     C                   ENDIF
      *                                                                                       HUT024
     C                   MOVE      'N'           ACBC              1
     C                   MOVE      SESESN        WSESN            10
     C                   MOVE      SEDUDT        WDUDT             6
     C                   MOVE      SEEVTP        WEVTP             2
     C*****POSET2        SETLL     POSETV2                                               HUT105
     C*****POSET2        READE     POSETV2                                45             HUT105
     C     POSET2        SETLL     XXPOSEL2                                              HUT105
     C     POSET2        READE     XXPOSEL2                               45             HUT105
     C     *IN45         DOWEQ     *OFF
      *                                                                                       HUT024
      * If user not authorised to the branch then do not check the settlement                 HUT024
      * account as this will not be included in the bulk authorisation                        HUT024
     C                   Z-ADD     0             @ERR
     C                   CALL      'ZVACTBU'
     C                   PARM                    #ZACTN            1
     C                   PARM      PBCA          @ZBRCD            3
     C                   PARM                    @ERR              1 0
     C     @ERR          IFEQ      0
      *                                                                                       HUT024
      * User is authorised to the branch so check the settlement account if                   HUT024
      * settlement method is 04 or 14, or 05 and Retail account                               HUT024
     C     PSMT          IFEQ      04
     C                   MOVEL     PCPY          K1CNUM
     C                   MOVE      BMACCD        K1ACOD
     C                   MOVE      PSCU          K1CCY
     C                   Z-ADD     1             K1ACSQ
     C                   MOVEL     PBCA          K1BRCA
     C     ACCNT1        CHAIN     ACCNTABF                           99
     C     *IN99         IFEQ      '0'
     C     RECIA         ANDNE     'C'
     C                   TESTB     '3'           RETB                     17
     C     PPRE          IFEQ      'P'
     C     *IN17         ANDEQ     '1'
     C                   MOVE      'Y'           ACBC
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       HUT024
     C     PSMT          IFEQ      14
     C                   MOVEL     PSEA          ACNO
     C     ACNO          CHAIN     ACNUM                              99
     C     *IN99         IFEQ      '0'
     C     RECIA         ANDNE     'C'
     C                   TESTB     '3'           RETB                     17
     C     PPRE          IFEQ      'P'
     C     *IN17         ANDEQ     '1'
     C                   MOVE      'Y'           ACBC
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       HUT024
     C     PSMT          IFEQ      05
     C                   MOVEL     PSEA          PSEA@
     C                   MOVEL     PSCU          K2CCY
     C                   MOVEL     PSEB          K2BRCA
     C     ACCNT2        CHAIN     ACCNTABF                           99
     C     *IN99         IFEQ      '0'
     C     RECIA         ANDNE     'C'
     C     ATYP          ANDEQ     'R'
     C                   TESTB     '3'           RETB                     17
     C     PPRE          IFEQ      'P'
     C     *IN17         ANDEQ     '1'
     C                   MOVE      'Y'           ACBC
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       HUT024
     C                   ENDIF
     C*****POSET2        READE     POSETV2                                45                  HUT105
     C     POSET2        READE     XXPOSEL2                               45                  HUT105
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *                                                                                       HUT024
     C     EABCCK        TAG
      *                                                                                       259148
      ** Retrieve customer details                                                            259148
      *                                                                                       259148
     C                   MOVEL     PCPY          CUSTNO            6
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      CUSTNO        CUST              6
     C     SDSECS        PARM      SDSECS        DSSDY
      *
      ** If the Action Code is Amend, validate value date
      ****should*be*DDMMYY,*not*greater*than*rundate*and*not*******                        HUT011I04
      ****before*the*Due*Date**************************************                        HUT011I04
      *   should be DDMMYY and not before Due Date                                         HUT011I04
      *
     C     SEACTN        IFEQ      'A'
     C     *IN76         ANDEQ     '0'
     C                   MOVE      '0'           *IN37
     C                   MOVE      '0'           *IN78
     C                   MOVEL     SEVLDT        ZDATE             6 0
      *
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR
     C                   PARM                    ZDATE
     C                   PARM      *BLANKS       ZDATFM
     C                   PARM                    ZDAYNO
      *
     C     ZERR          IFNE      *BLANKS
     C                   MOVE      '1'           *IN37
     C                   MOVE      'HUT1107'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      **  Get the equivalent Midas Day No. of Value date entered
      *
     C                   Z-ADD     ZDAYNO        KVLDT             5 0
     C     ZERR          IFEQ      *BLANKS
     C     KVLDT         ANDLT     KDUDT
     C********** ZERR      OREQ *BLANKS                                                    HUT011I04
     C********** KVLDT     ANDGTRUND                                                       HUT011I04
     C                   MOVE      '1'           *IN37
     C                   MOVE      'HUT1107'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       259148
     C     S01512        IFEQ      'Y'
      *                                                                                       259148
      ** Value date should not be a holiday in local currency                                 259148
      ** for 03, 04, 05, 14, and 15 settlement methods.                                       259148
      *                                                                                       259148
     C     PSMT          IFEQ      03
     C     PSMT          OREQ      04
     C     PSMT          OREQ      05
     C     PSMT          OREQ      14
     C     PSMT          OREQ      15
      *                                                                                       259148
     C                   Z-ADD     KVLDT         ZDAYNO
     C                   MOVEL     BJLCCY        ZCCY
     C                   MOVE      BJSLCD        ZLOC
     C                   EXSR      ZCHKH
     C     ZIND          IFEQ      'H'
     C                   MOVE      '1'           *IN37
     C                   MOVE      'HUT1113'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF                                                  *IN99
     C                   ENDIF                                                  *PSMT
      *                                                                                       259148
      ** Value date should not be a holiday for nostro                                        259148
      ** location/currency for settlement methods 01, 02, 07, 08, and 12.                     259148
      *                                                                                       259148
     C     PSMT          IFEQ      01
     C     PSMT          OREQ      02
     C     PSMT          OREQ      07
     C     PSMT          OREQ      08
     C     PSMT          OREQ      12
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      PSEB          @DSNB             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *                                                                                       259148
     C                   MOVE      A8LCCD        ZLOC
      *                                                                                       259148
     C                   Z-ADD     KVLDT         ZDAYNO
     C                   MOVEL     PSCU          ZCCY
     C                   EXSR      ZCHKH
     C     ZIND          IFEQ      'H'
     C                   MOVE      '1'           *IN37
     C                   MOVE      'HUT1112'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF                                                  ZIND
     C                   ENDIF
     C                   ENDIF
      *
      **  If value date is valid
      *
     C     *IN37         IFEQ      *OFF
     C*****POSET2        SETLL     POSETV2                                               HUT105
     C*****POSET2        READE     POSETV2                                89             HUT105
     C     POSET2        SETLL     XXPOSEL2                                              HUT105
     C     POSET2        READE     XXPOSEL2                               89             HUT105
      *                                                                                     AR833272
     C                   MOVE      *BLANKS       SAVBA             3
      *                                                                                     AR833272
     C     *IN89         IFEQ      '0'
     C     *IN89         DOWEQ     '0'
      *                                                                                     AR833272
     C     PBCA          IFNE      SAVBA
     C                   MOVEL     PBCA          SAVBA
     C                   Z-ADD     0             @ERR
     C**********           CALL 'ZVBBU'                                            AR833272 AR836848
     C**********           PARM PBCA      @ZBRCD                                   AR833272 AR836848
     C**********           PARM           @ERR                                     AR833272 AR836848
     C                   CALL      'ZVACTBU'
     C                   PARM      SEACTN        #ZACTN
     C                   PARM      PBCA          @ZBRCD
     C                   PARM                    @ERR
     C                   ENDIF
      *                                                                                     AR833272
     C     @ERR          IFEQ      0
     C                   Z-ADD     KVLDT         PSVL
     C                   Z-ADD     RUND          LCD
     C                   MOVE      'A'           CHTP
     C                   UPDATE    POSETDFB
      *                                                                                       HUT015
      * If*HUT015*is*ON,*Update*'Previous'*fields*of*PSAUT*with*'Last'*fields          HUT015 HUT105
      * Update 'Previous' fields of PSAUT with 'Last' fields                                  HUT105
      *    then Update 'Last' fields with current information.                                HUT015
      *                                                                                       HUT015
     C*****HUT015        IFEQ      'Y'                                                        HUT105
     C     KPSAUT        CHAIN     PSAUT                              60                      HUT015
     C     *IN60         IFEQ      *OFF                                                       HUT015
     C                   MOVE      PALUSR        PAPUSR                                       HUT015
     C                   MOVE      PALCD         PAPCD                                        HUT015
     C                   MOVE      PALCTP        PAPCTP                                       HUT015
     C                   MOVE      USER          PALUSR                                       HUT015
     C                   Z-ADD     RUND          PALCD                                        HUT015
     C                   MOVE      'A'           PALCTP                                       HUT015
     C                   UPDATE    PSAUTDF                                                    HUT015
     C                   ENDIF                                                                HUT015
     C**********         ENDIF                                                                HUT105
      *                                                                                       HUT015
     C**********           MOVELPBCA      SAVBA                                    AR833272 AR836848
     C                   ENDIF
      *                                                                                     AR833272
     C*****POSET2        READE     POSETV2                                89                  HUT105
     C     POSET2        READE     XXPOSEL2                               89                  HUT105
     C                   ENDDO
      *
      **  A record is read and amended
      *
     C                   MOVE      'HUT1110'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C**********         WRITE     SEH023F3                                                   HUT105
     C                   WRITE     XX105023F3                                                 HUT105
     C                   MOVE      '1'           *IN78
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If the Action Code is Authorise and F10 is pressed
      *
     C     SEACTN        IFEQ      'Y'
     C     *IN10         ANDEQ     '1'
     C     *IN76         ANDEQ     '0'
     C                   MOVE      '0'           *IN41
     C                   MOVE      '0'           *IN75
     C                   MOVE      '0'           *IN79
     C*****POSET2        SETLL     POSETV2                                                    HUT105
     C*****POSET2        READE     POSETV2                                89                  HUT105
     C     POSET2        SETLL     XXPOSEL2                                                   HUT105
     C     POSET2        READE     XXPOSEL2                               89                  HUT105
      *                                                                                     AR833272
     C                   MOVE      *BLANKS       SAVBA
      *                                                                                     AR833272
     C     *IN89         IFEQ      '0'
     C     *IN89         DOWEQ     '0'
      *                                                                                     AR833272
     C     PBCA          IFNE      SAVBA
     C                   MOVEL     PBCA          SAVBA
     C                   Z-ADD     0             @ERR
     C**********           CALL 'ZVBBU'                                            AR833272 AR836848
     C**********           PARM PBCA      @ZBRCD                                   AR833272 AR836848
     C**********           PARM           @ERR                                     AR833272 AR836848
     C                   CALL      'ZVACTBU'
     C                   PARM      SEACTN        #ZACTN
     C                   PARM      PBCA          @ZBRCD
     C                   PARM                    @ERR
     C                   ENDIF
      *                                                                                     AR833272
     C     @ERR          IFEQ      0
      *                                                                                       259148
      ***Check*if*a/c*is*not*blocked***********************************             259148 AR1010460
      *****************************************************************             259148 AR1010460
     C********** PSMT      IFEQ 04                                                  259148 AR1010460
     C**********           MOVELPCPY      K1CNUM                                    259148 AR1010460
     C**********           MOVE BMACCD    K1ACOD                                    259148 AR1010460
     C**********           MOVE PSCU      K1CCY                                     259148 AR1010460
     C**********           Z-ADD1         K1ACSQ                                    259148 AR1010460
     C**********           MOVELPBCA      K1BRCA                                    259148 AR1010460
     C**********           SETOF                         99                         259148 AR1010460
     C**N99***** ACCNT1    CHAINACCNTABF             99                             259148 AR1010460
     C********** *IN99     IFEQ '0'                                                  259148 AR547625
     C********** RECIA     ANDNE'C'                                                  259148 AR547625
     C********** *IN99     IFEQ *ON                                               AR547625 AR1010460
     C********** RECIA     OREQ 'C'                                               AR547625 AR1010460
     C**********           MOVE '1'       *IN41                                   AR547625 AR1010460
     C**********           MOVE 'HUT1114' ZAMSID                                  AR547625 AR1010460
     C**********           MOVEL*BLANK    ZAMSGF                                  AR547625 AR1010460
     C**********           EXSR ZASNMS                                            AR547625 AR1010460
     C**********           ELSE                                                   AR547625 AR1010460
     C**********           TESTB'2'       RETB           16                         259148 AR1010460
     C**********           TESTB'3'       RETB           17                         259148 AR1010460
     C********** PPRE      IFEQ 'P'                                                 259148 AR1010460
     C********** *IN16     ANDEQ'1'                                                 259148 AR1010460
     C********** PPRE      OREQ 'R'                                                 259148 AR1010460
     C********** *IN17     ANDEQ'1'                                                 259148 AR1010460
     C**********           MOVE '1'       *IN41                                     259148 AR1010460
     C**********           MOVE 'HUT1114' ZAMSID                                    259148 AR1010460
     C**********           MOVEL*BLANK    ZAMSGF                                    259148 AR1010460
     C**********           EXSR ZASNMS                                              259148 AR1010460
     C**********           ENDIF                                                    259148 AR1010460
     C**********           ENDIF                                                    259148 AR1010460
     C**********           ENDIF                                                    259148 AR1010460
     C********** PSMT      IFEQ 15                                                  259148 AR1010460
     C**********           MOVELPCPY      K1CNUM                                    259148 AR1010460
     C**********           MOVE BFACCD    K1ACOD                                    259148 AR1010460
     C**********           MOVE PSCU      K1CCY                                     259148 AR1010460
     C**********           Z-ADDBFACSN    K1ACSQ                                    259148 AR1010460
     C********** PSEB      IFNE *BLANKS                                             259148 AR1010460
     C**********           MOVELPSEB      K1BRCA                                    259148 AR1010460
     C**********           ELSE                                                     259148 AR1010460
     C**********           MOVELPBCA      K1BRCA                                    259148 AR1010460
     C**********           ENDIF                                                    259148 AR1010460
     C**********           SETOF                         99                         259148 AR1010460
     C**N99***** ACCNT1    CHAINACCNTABF             99                             259148 AR1010460
     C********** *IN99     IFEQ '0'                                                  259148 AR547625
     C********** RECIA     ANDNE'C'                                                  259148 AR547625
     C********** *IN99     IFEQ *ON                                               AR547625 AR1010460
     C********** RECIA     OREQ 'C'                                               AR547625 AR1010460
     C**********           MOVE '1'       *IN41                                   AR547625 AR1010460
     C**********           MOVE 'HUT1117' ZAMSID                                  AR547625 AR1010460
     C**********           MOVEL*BLANK    ZAMSGF                                  AR547625 AR1010460
     C**********           EXSR ZASNMS                                            AR547625 AR1010460
     C**********           ELSE                                                   AR547625 AR1010460
     C**********           TESTB'2'       RETB           16                         259148 AR1010460
     C**********           TESTB'3'       RETB           17                         259148 AR1010460
     C********** PPRE      IFEQ 'P'                                                 259148 AR1010460
     C********** *IN16     ANDEQ'1'                                                 259148 AR1010460
     C********** PPRE      OREQ 'R'                                                 259148 AR1010460
     C********** *IN17     ANDEQ'1'                                                 259148 AR1010460
     C**********           MOVE '1'       *IN41                                     259148 AR1010460
     C**********           MOVE 'HUT1117' ZAMSID                                    259148 AR1010460
     C**********           MOVEL*BLANK    ZAMSGF                                    259148 AR1010460
     C**********           EXSR ZASNMS                                              259148 AR1010460
     C**********           ENDIF                                                    259148 AR1010460
     C**********           ENDIF                                                    259148 AR1010460
     C**********           ENDIF                                                    259148 AR1010460
     C********** PSMT      IFEQ 05                                                  259148 AR1010460
     C**********           MOVELPSEA      PSEA@                                     259148 AR1010460
     C**********           MOVELPSCU      K2CCY                                     259148 AR1010460
     C**********           MOVELPSEB      K2BRCA                                    259148 AR1010460
     C**********           SETOF                         99                         259148 AR1010460
     C********** ACCNT2    CHAINACCNT                99                             259148 AR1010460
     C********** *IN99     IFEQ '0'                                                  259148 AR547625
     C********** RECIA     ANDNE'C'                                                  259148 AR547625
     C********** *IN99     IFEQ *ON                                               AR547625 AR1010460
     C********** RECIA     OREQ 'C'                                               AR547625 AR1010460
     C**********           MOVE '1'       *IN41                                   AR547625 AR1010460
     C**********           MOVE 'HUT1115' ZAMSID                                  AR547625 AR1010460
     C**********           MOVEL*BLANK    ZAMSGF                                  AR547625 AR1010460
     C**********           EXSR ZASNMS                                            AR547625 AR1010460
     C**********           ELSE                                                   AR547625 AR1010460
     C**********           TESTB'2'       RETB           16                         259148 AR1010460
     C**********           TESTB'3'       RETB           17                         259148 AR1010460
     C********** PPRE      IFEQ 'P'                                                 259148 AR1010460
     C********** *IN16     ANDEQ'1'                                                 259148 AR1010460
     C********** PPRE      OREQ 'R'                                                 259148 AR1010460
     C********** *IN17     ANDEQ'1'                                                 259148 AR1010460
     C**********           MOVE '1'       *IN41                                     259148 AR1010460
     C**********           MOVE 'HUT1115' ZAMSID                                    259148 AR1010460
     C**********           MOVEL*BLANK    ZAMSGF                                    259148 AR1010460
     C**********           EXSR ZASNMS                                              259148 AR1010460
     C**********           ENDIF                                                    259148 AR1010460
     C**********           ENDIF                                                    259148 AR1010460
     C**********           ENDIF                                                    259148 AR1010460
     C********** PSMT      IFEQ 14                                                  259148 AR1010460
     C**********           MOVELPSEA      ACNO                                      259148 AR1010460
     C********** ACNO      CHAINACNUM                99                             259148 AR1010460
     C********** *IN99     IFEQ 'O'                                                   259147 259148A
     C********** *IN99     IFEQ '0'                                                259148A AR1010460
     C********** RECIA     ANDNE'C'                                                 259148 AR1010460
     C**********           Z-ADDCNUM      CUS@                                      259148 AR1010460
     C**********           Z-ADDACOD      ACOD@                                     259148 AR1010460
     C**********           Z-ADDACSQ      ACSQ@                                     259148 AR1010460
     C**********           MOVELBRCA      K2BRCA                                    259148 AR1010460
     C**********           MOVELCCY       K2CCY                                     259148 AR1010460
     C**********           SETOF                         99                         259148 AR1010460
     C********** ACCNT2    CHAINACCNT                99                             259148 AR1010460
     C********** *IN99     IFEQ '0'                                                  259148 AR547625
     C********** RECIA     ANDNE'C'                                                  259148 AR547625
     C********** *IN99     IFEQ *ON                                               AR547625 AR1010460
     C********** RECIA     OREQ 'C'                                               AR547625 AR1010460
     C**********           MOVE '1'       *IN41                                   AR547625 AR1010460
     C**********           MOVE 'HUT1116' ZAMSID                                  AR547625 AR1010460
     C**********           MOVEL*BLANK    ZAMSGF                                  AR547625 AR1010460
     C**********           EXSR ZASNMS                                            AR547625 AR1010460
     C**********           ELSE                                                   AR547625 AR1010460
     C**********           TESTB'2'       RETB           16                         259148 AR1010460
     C**********           TESTB'3'       RETB           17                         259148 AR1010460
     C********** PPRE      IFEQ 'P'                                                 259148 AR1010460
     C********** *IN16     ANDEQ'1'                                                 259148 AR1010460
     C********** PPRE      OREQ 'R'                                                 259148 AR1010460
     C********** *IN17     ANDEQ'1'                                                 259148 AR1010460
     C**********           MOVE '1'       *IN41                                     259148 AR1010460
     C**********           MOVE 'HUT1116' ZAMSID                                    259148 AR1010460
     C**********           MOVEL*BLANK    ZAMSGF                                    259148 AR1010460
     C**********           EXSR ZASNMS                                              259148 AR1010460
     C**********           ENDIF                                                    259148 AR1010460
     C**********           ENDIF                                                    259148 AR1010460
     C**********           ENDIF                                                    259148 AR1010460
     C**********           ENDIF                                                    259148 AR1010460
      *                                                                                    AR1027562
      ** Check if a/c is not blocked                                                       AR1027562
      *                                                                                    AR1027562
     C     PSMT          IFEQ      04
     C                   MOVEL     PCPY          K1CNUM
     C                   MOVE      BMACCD        K1ACOD
     C                   MOVE      PSCU          K1CCY
     C                   Z-ADD     1             K1ACSQ
     C                   MOVEL     PBCA          K1BRCA
     C                   SETOFF                                           99
     C  N99ACCNT1        CHAIN     ACCNTABF                           99
     C     *IN99         IFEQ      '0'
     C     RECIA         ANDNE     'C'
     C                   TESTB     '2'           RETB                     16
     C                   TESTB     '3'           RETB                     17
     C     PPRE          IFEQ      'P'
     C********** *IN16     ANDEQ'1'                                               AR1027562 MD043182
     C     *IN17         ANDEQ     '1'
     C*****HUT024        ANDEQ     'N'                                                      HUT111
     C     HUT111        ANDEQ     'N'                                                      HUT111
     C     PPRE          OREQ      'R'
     C********** *IN17     ANDEQ'1'                                               AR1027562 MD043182
     C     *IN16         ANDEQ     '1'
     C                   MOVE      '1'           *IN41
     C                   MOVE      'HUT1121'     ZAMSID
     C                   MOVEL     MSGDTA        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     PSMT          IFEQ      15
     C                   MOVEL     PCPY          K1CNUM
     C                   MOVE      BFACCD        K1ACOD
     C                   MOVE      PSCU          K1CCY
     C                   Z-ADD     BFACSN        K1ACSQ
     C     PSEB          IFNE      *BLANKS
     C                   MOVEL     PSEB          K1BRCA
     C                   ELSE
     C                   MOVEL     PBCA          K1BRCA
     C                   ENDIF
     C                   SETOFF                                           99
     C  N99ACCNT1        CHAIN     ACCNTABF                           99
     C     *IN99         IFEQ      '0'
     C     RECIA         ANDNE     'C'
     C                   TESTB     '2'           RETB                     16
     C                   TESTB     '3'           RETB                     17
     C     PPRE          IFEQ      'P'
     C********** *IN16     ANDEQ'1'                                               AR1027562 MD043182
     C     *IN17         ANDEQ     '1'
     C     PPRE          OREQ      'R'
     C********** *IN17     ANDEQ'1'                                               AR1027562 MD043182
     C     *IN16         ANDEQ     '1'
     C                   MOVE      '1'           *IN41
     C                   MOVE      'HUT1121'     ZAMSID
     C                   MOVEL     MSGDTA        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     PSMT          IFEQ      05
     C                   MOVEL     PSEA          PSEA@
     C                   MOVEL     PSCU          K2CCY
     C                   MOVEL     PSEB          K2BRCA
     C                   SETOFF                                           99
     C     ACCNT2        CHAIN     ACCNT                              99
     C     *IN99         IFEQ      '0'
     C     RECIA         ANDNE     'C'
     C                   TESTB     '2'           RETB                     16
     C                   TESTB     '3'           RETB                     17
     C     PPRE          IFEQ      'P'
     C********** *IN16     ANDEQ'1'                                               AR1027562 MD043182
     C     *IN17         ANDEQ     '1'
     C     ATYP          ANDNE     'R'
     C     PPRE          OREQ      'P'
     C     *IN17         ANDEQ     '1'
     C     ATYP          ANDEQ     'R'
     C*****HUT024        ANDEQ     'N'                                                      HUT111
     C     HUT111        ANDEQ     'N'                                                      HUT111
     C     PPRE          OREQ      'R'
     C********** *IN17     ANDEQ'1'                                               AR1027562 MD043182
     C     *IN16         ANDEQ     '1'
     C                   MOVE      '1'           *IN41
     C                   MOVE      'HUT1121'     ZAMSID
     C                   MOVEL     MSGDTA        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     PSMT          IFEQ      14
     C                   MOVEL     PSEA          ACNO
     C     ACNO          CHAIN     ACNUM                              99
     C     *IN99         IFEQ      '0'
     C     RECIA         ANDNE     'C'
     C**********         Z-ADD     CNUM          CUS@                                       HUT105
     C                   MOVE      CNUM          CUS@                                       HUT105
     C                   Z-ADD     ACOD          ACOD@
     C                   Z-ADD     ACSQ          ACSQ@
     C                   MOVEL     BRCA          K2BRCA
     C                   MOVEL     CCY           K2CCY
     C                   SETOFF                                           99
     C     ACCNT2        CHAIN     ACCNT                              99
     C     *IN99         IFEQ      '0'
     C     RECIA         ANDNE     'C'
     C                   TESTB     '2'           RETB                     16
     C                   TESTB     '3'           RETB                     17
     C     PPRE          IFEQ      'P'
     C********** *IN16     ANDEQ'1'                                               AR1027562 MD043182
     C     *IN17         ANDEQ     '1'
     C*****HUT024        ANDEQ     'N'                                                      HUT111
     C     HUT111        ANDEQ     'N'                                                      HUT111
     C     PPRE          OREQ      'R'
     C********** *IN17     ANDEQ'1'                                               AR1027562 MD043182
     C     *IN16         ANDEQ     '1'
     C                   MOVE      '1'           *IN41
     C                   MOVE      'HUT1121'     ZAMSID
     C                   MOVEL     MSGDTA        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       HUT015
      ***If*HUT015*is*ON,*check*if*current*user*is*=*last*action*user,*if*so,          HUT015 HUT105
      ** Check if current user is = last action user, if so,                                  HUT105
      **        issue error message.                                                          HUT015
      *                                                                                       HUT015
     C*****HUT015        IFEQ      'Y'                                                        HUT105
     C********** KPSAUT    CHAINPSAUT                60                              HUT015 AR586601
     C     KPSAUT        CHAIN(N)  PSAUT                              60                      HUT015
     C     *IN60         IFEQ      *OFF                                                       HUT015
     C     USER          ANDEQ     PALUSR                                                     HUT015
     C                   MOVE      '1'           *IN41                                        HUT015
     C                   MOVE      'HUT1118'     ZAMSID                                       HUT015
     C                   MOVEL     *BLANK        ZAMSGF                                       HUT015
     C                   EXSR      ZASNMS                                                     HUT015
     C                   ENDIF                                                                HUT015
     C**********         ENDIF                                                                HUT105
      *                                                                                       HUT015
     C**********           MOVELPBCA      SAVBA                                    AR833272 AR836848
     C                   ENDIF
      *                                                                                     AR833272
     C*****POSET2        READE     POSETV2                                89                  HUT105
     C     POSET2        READE     XXPOSEL2                               89                  HUT105
     C                   ENDDO
      *                                                                                       HUT024
      * If the bulk authorisation will include a settlement over an                           HUT024
      * account blocked for credits, save the key details and show message                    HUT024
     C     *IN83         IFEQ      *OFF
     C     *IN41         ANDEQ     *OFF
     C     ACBC          ANDEQ     'Y'
     C*****HUT024        ANDEQ     'Y'                                                        HUT111
     C     HUT111        ANDEQ     'Y'                                                        HUT111
     C                   MOVE      '1'           *IN41
     C                   MOVE      'HUT1124'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       259148
      * If settlement account is valid                                                        259148
      *                                                                                       259148
     C     *IN41         IFEQ      '0'
     C*****POSET2        SETLL     POSETV2                                                    HUT105
     C*****POSET2        READE     POSETV2                                89                  HUT105
     C     POSET2        SETLL     XXPOSEL2                                                   HUT105
     C     POSET2        READE     XXPOSEL2                               89                  HUT105
      *                                                                                       259148
     C**********           MOVE *BLANKS   AUTH    1                             AR1010460 AR1010460A
     C                   MOVE      *OFF          *IN70
     C                   MOVE      *BLANKS       SAVBA
      *                                                                                     AR833272
     C     *IN89         DOWEQ     '0'
      *                                                                                     AR833272
     C     PBCA          IFNE      SAVBA
     C                   MOVEL     PBCA          SAVBA
     C                   Z-ADD     0             @ERR
     C**********           CALL 'ZVBBU'                                            AR833272 AR836848
     C**********           PARM PBCA      @ZBRCD                                   AR833272 AR836848
     C**********           PARM           @ERR                                     AR833272 AR836848
     C                   CALL      'ZVACTBU'
     C                   PARM      SEACTN        #ZACTN
     C                   PARM      PBCA          @ZBRCD
     C                   PARM                    @ERR
     C                   ENDIF
      *                                                                                    AR1010460
     C                   MOVE      '0'           *IN41
     C                   EXSR      VALSET
      *                                                                                     AR833272
     C     @ERR          IFEQ      0
     C     *IN41         ANDEQ     '0'
     C**********           MOVE 'Y'       AUTH                                  AR1010460 AR1010460A
     C                   MOVE      *ON           *IN70
      *                                                                                     AR833272
      * Before update
     C                   MOVEL     *BLANKS       Z#BSTS
     C**********           MOVELPBCA      PBCAX                                            HUT011I08
     C**********           MOVELPSSH      PSSHX                                            HUT011I08
     C**********           MOVELPCPY      PCPYX                                            HUT011I08
     C**********           MOVELPDUD      PDUDX                                            HUT011I08
     C**********           MOVELPEVT      PEVTX                                            HUT011I08
     C**********           MOVELPAUI      PAUIX                                            HUT011I08
     C**********           MOVELPSMI      PSMIX                                            HUT011I08
     C**********           MOVELCHTP      CHTPX                                            HUT011I08
     C**********           MOVELPMAR      PMARX                                            HUT011I08
     C**********           MOVELDETREC    Z#BSTS                                           HUT011I08
      *
     C                   MOVE      'Y'           PAUI
     C                   MOVE      'Y'           PSMI
     C                   MOVE      'Y'           CHTP
     C                   Z-ADD     RUND          LCD
     C                   MOVE      'S'           PMAR
     C                   UPDATE    POSETDFB
      *                                                                                       HUT015
      * If HUT015 is ON, Update 'Previous' fields of PSAUT with 'Last' fields                 HUT015
      *    then Update 'Last' fields with current information.                                HUT015
      *                                                                                       HUT015
     C*****HUT015        IFEQ      'Y'                                                        HUT015
     C     KPSAUT        CHAIN     PSAUT                              60               HUT015 HUT105
     C     *IN60         IFEQ      *OFF                                                       HUT015
     C                   MOVE      PALUSR        PAPUSR                                       HUT015
     C                   MOVE      PALCD         PAPCD                                        HUT015
     C                   MOVE      PALCTP        PAPCTP                                       HUT015
     C                   MOVE      USER          PALUSR                                       HUT015
     C                   Z-ADD     RUND          PALCD                                        HUT015
     C                   MOVE      'Y'           PALCTP                                       HUT015
     C                   UPDATE    PSAUTDF                                                    HUT015
     C                   ENDIF                                                                HUT015
     C**********         ENDIF                                                         HUT015 HUT105
      *
      ** Get customer number(counter party) in POSETD
      *
     C                   MOVEL     PCPY          KCUST             6
      *
      ** Chain event type to SECOATL0
      *
     C     SEEVTP        CHAIN     SECOATL0                           90
     C     *IN90         IFEQ      '0'
     C                   EXSR      UPDCAF
     C                   ENDIF
      *
      ** If CRE020 is ON and PositionSettlement current value is 'Y'
      *
     C     CRE020        IFEQ      'Y'
     C     WSV01         ANDEQ     'Y'
     C                   EXSR      SRTNLU
     C                   EXSR      SRIDXT
     C                   ENDIF
      *
      * After update
     C                   MOVEL     PBCA          PBCAX
     C                   MOVEL     PSSH          PSSHX
     C                   MOVEL     PCPY          PCPYX
     C                   MOVEL     PDUD          PDUDX
     C                   MOVEL     PEVT          PEVTX
     C                   MOVEL     PAUI          PAUIX
     C                   MOVEL     PSMI          PSMIX
     C                   MOVEL     CHTP          CHTPX
     C                   MOVEL     PMAR          PMARX
     C                   MOVEL     DETREC        Z#ASTS
      *
      ***Do*online*position*file*update*if*due*date*is*equal*to*rundate****                HUT011I08
      ** Do online position file update                                                    HUT011I08
      *
     C********** KDUDT     IFEQ RUND                                                       HUT011I08
     C                   CALL      'AOOUPSU0'
     C                   PARM                    ##RTCD            7
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C     ##RTCD        IFEQ      '*ERROR*'
     C                   SETON                                        U7U8
     C     *LOCK         IN        LDA
     C                   Z-ADD     001           DBASE
     C                   MOVEL     'AOOUPSU0'    DBFILE
     C                   MOVEL     WREFNO        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   GOTO      XVALID
     C                   ENDIF
     C**********           ENDIF                                                           HUT011I08
      *                                                                                     AR833272
     C**********           MOVELPBCA      SAVBA                                    AR833272 AR836848
      *                                                                                       HUT024
      **If*HUT024*is*On*and*the*receipt*of*funds*is*over*an*account                    HUT024 HUT111
      * The receipt of funds is over an account                                               HUT111
      * blocked for credit, allow this but report it                                          HUT024
     C     *IN83         IFEQ      *ON
     C*****HUT024        ANDEQ     'Y'                                                        HUT111
     C     HUT111        ANDEQ     'Y'                                                        HUT111
     C                   MOVE      PSSH          XPSSH
     C                   MOVE      PEVT          XPEVT
     C                   MOVE      PCPY          XPCPY
     C                   MOVE      PBCA          XPBCA
     C                   MOVE      PSVL          XPSVL
     C                   MOVE      PAMD          XPAMD
     C                   MOVE      PSCU          XPSCU
     C                   MOVE      PSMT          XPSMT
     C                   MOVEL     ACNO          XACNO
     C**********         WRITE     SEPOBCD0                                                   HUT111
     C                   WRITE     XXPOBCD0                                                   HUT111
     C                   ENDIF
      *                                                                                       HUT024
     C                   ENDIF
      *
     C*****POSET2        READE     POSETV2                                89                  HUT105
     C     POSET2        READE     XXPOSEL2                               89                  HUT105
     C                   ENDDO
     C                   MOVE      *OFF          *IN83
      *
      ** A record is read and authorised
      *
     C********** AUTH      IFEQ 'Y'                                             AR1010460 AR1010460A
     C     *IN70         IFEQ      *ON
     C                   MOVE      'HUT1111'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C**********         WRITE     SEH023F3                                              HUT105
     C                   WRITE     XX105023F3                                            HUT105
     C                   MOVE      '1'           *IN75
     C                   MOVE      '1'           *IN79
     C                   MOVE      '0'           *IN38
     C                   MOVE      *BLANKS       SEAUTH
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                       259148
     C                   ENDIF
     C                   COMMIT
      *
     C     XVALID        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  REPORT - CALL SECH024 IF F8 OR F9 IS PRESSED                 *
      *                                                               *
      *****************************************************************
     C     REPORT        BEGSR
      *
     C                   EXSR      VALINS
      *                                                                                    HUT011I03
     C     SEACTN        IFEQ      'A'
     C     *IN38         ANDEQ     '1'
     C     *IN37         ANDEQ     '0'
     C     *IN75         ANDEQ     '0'
      *                                                                                    HUT011I03
     C                   MOVEL     SEVLDT        ZDATE             6 0
      *                                                                                    HUT011I03
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR
     C                   PARM                    ZDATE
     C                   PARM      *BLANKS       ZDATFM
     C                   PARM                    ZDAYNO
      *                                                                                    HUT011I03
     C     ZERR          IFNE      *BLANKS
     C                   MOVE      '1'           *IN37
      *                                                                                    HUT011I03
      ** Clear program messages first if F8/F9 is pressed then                             HUT011I03
      ** invalid value date is recognized and *IN78 = '1'                                  HUT011I03
      *                                                                                    HUT011I03
     C     *IN37         IFEQ      '1'
     C     *IN78         ANDEQ     '1'
     C                   EXSR      CLEAR
     C                   ENDIF
      *                                                                                    HUT011I03
     C                   MOVE      'HUT1107'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                    HUT011I03
      **  Get the equivalent Midas Day No. of Value date entered                           HUT011I03
      *                                                                                    HUT011I03
     C                   Z-ADD     ZDAYNO        KVLDT             5 0
     C     ZERR          IFEQ      *BLANKS
     C     KVLDT         ANDLT     KDUDT
     C     ZERR          OREQ      *BLANKS
     C     KVLDT         ANDGT     RUND
     C                   MOVE      '1'           *IN37
      *                                                                                    HUT011I03
      ** Clear program messages first if F8/F9 is pressed then                             HUT011I03
      ** invalid value date is recognized and *IN78 = '1'                                  HUT011I03
      *                                                                                    HUT011I03
     C     *IN37         IFEQ      '1'
     C     *IN78         ANDEQ     '1'
     C                   EXSR      CLEAR
     C                   ENDIF
      *                                                                                    HUT011I03
     C                   MOVE      'HUT1107'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                    HUT011I03
      ** Report will only be generated if all the input fields are valid                   HUT011I03
     C     *IN33         IFEQ      *OFF
     C     *IN34         ANDEQ     *OFF
     C     *IN35         ANDEQ     *OFF
     C     *IN36         ANDEQ     *OFF
     C     *IN37         ANDEQ     *OFF
      *                                                                                    HUT011I03
      ** If F8 is pressed, set sequence equal to '10001'
      ** If F9 is pressed, set sequence equal to '10002'
      *
     C     *IN08         IFEQ      '1'
     C                   MOVE      '10001'       SESEQN            5
     C                   ENDIF
      *
     C     *IN09         IFEQ      '1'
     C                   MOVE      '10002'       SESEQN            5
     C                   ENDIF
      *
     C**********         CALL      'SECHA24'                                               HUT105
     C                   CALL      'XXC10524A'                                             HUT105
     C                   PARM                    SESEQN
     C                   PARM                    SESESN
     C                   PARM                    SEDUDT
     C                   PARM                    SEEVTP
      *
     C                   ENDIF
      *                                                                                    HUT011I03
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDCAF - Update Transaction Number of Last Update            *
      *           in PF/SECOALPD and/or PF/SECODPPD.                  *
      *                                                               *
      *****************************************************************
      *
     C     UPDCAF        BEGSR
      *
     C     CUSTTP        KLIST
     C                   KFLD                    PBCA
     C                   KFLD                    PCPY
     C                   KFLD                    PEVT
     C                   KFLD                    PTFR
      *
     C     DEPOTP        KLIST
     C                   KFLD                    PBCA
     C                   KFLD                    PCPY
     C                   KFLD                    PEVT
      *
     C                   MOVE      *BLANK        FOUND             1
      *
     C                   MOVE      *BLANKS       PCPYTP            1
     C     KCUST         CHAIN     SDSECSL0                           91
     C     *IN91         IFEQ      '0'
     C                   MOVE      BFCLAS        PCPYTP
     C                   ENDIF
      *
     C     PCPYTP        IFEQ      'C'
     C     CUSTTP        SETLL     SECOALLA
     C     CUSTTP        READE     SECOALLA                               58
     C                   ELSE
     C     DEPOTP        SETLL     SECODPL7
     C     DEPOTP        READE     SECODPL7                               58
     C                   ENDIF
      *
     C     *IN58         DOUEQ     '1'
     C     FOUND         OREQ      'Y'
      *
     C     PCPYTP        IFEQ      'C'
     C     MCCORF        CHAIN     SECORFL0                           59
     C                   ELSE
     C     MBCORF        CHAIN     SECORFL0                           59
     C                   ENDIF
      *
     C     *IN59         IFEQ      '0'
     C     MASESN        ANDEQ     PSSH
     C     MAALEF        ANDEQ     PDUD
     C     MACOAT        ANDEQ     PEVT
      *
     C                   MOVEL     'Y'           FOUND
      *
     C     PCPYTP        IFEQ      'C'
     C                   Z-ADD     TNLU          MCTNL1
     C                   UPDATE    SECOALD0
     C                   ELSE
     C                   Z-ADD     TNLU          MBTNL1
     C                   UPDATE    SECODPD0
     C                   ENDIF
     C                   ENDIF
      *
     C     PCPYTP        IFEQ      'C'
     C     CUSTTP        READE     SECOALLA                               58
     C                   ELSE
     C     DEPOTP        READE     SECODPL7                               58
     C                   ENDIF
      *
     C                   END
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTNLU - Store original TNLU field on extension file         *
      *                                                               *
      *****************************************************************
     C     SRTNLU        BEGSR
      *
      ** If Insert, keep record keys and original TNLU on file
      *
     C                   MOVEL     PBCA          P3PBCA
     C                   MOVEL     PSSH          P3PSSH
     C                   MOVE      PCPY          P3PCPY
     C                   MOVE      PDUD          P3PDUD
     C                   MOVEL     PEVT          P3PEVT
      *
     C     KPOST3        KLIST
     C                   KFLD                    K3PBCA            3
     C                   KFLD                    K3PSSH           10
     C**********         KFLD                    K3PCPY            6 0                    HUT105
     C                   KFLD                    K3PCPY            6                      HUT105
     C                   KFLD                    K3PDUD            5 0
     C                   KFLD                    K3PEVT            2
     C                   KFLD                    K3TNLU            5 0
      *
     C     CHTP          IFEQ      'Y'
     C                   MOVEL     P3PBCA        K3PBCA
     C                   MOVEL     P3PSSH        K3PSSH
     C                   MOVE      P3PCPY        K3PCPY
     C                   MOVE      P3PDUD        K3PDUD
     C                   MOVEL     P3PEVT        K3PEVT
     C                   MOVE      TNLU          K3TNLU
      *
     C     KPOST3        CHAIN     POSETDD3                           87
     C     *IN87         IFEQ      '0'
     C                   MOVE      TNLU          P3TNLU
     C                   UPDATE    POSETDD3
     C                   ELSE
     C                   MOVE      TNLU          P3OTNL
     C                   MOVE      TNLU          P3TNLU
     C                   WRITE     POSETDD3
     C                   ENDIF
      *
     C                   ENDIF
     C                   MOVEL     P3OTNL        KNARR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIDXT - Handles the advice index of the current             *
      *           transaction.                                        *
      *                                                               *
      *****************************************************************
     C     SRIDXT        BEGSR
      *
      ** Only process authorised transactions.
      *
     C     PAUI          IFEQ      'Y'
      *
     C                   MOVE      *BLANKS       WREFNO
     C                   MOVE      PSSH          WSSH
     C                   MOVE      PCPY          WCPY
     C                   MOVE      PBCA          WBCA
     C                   MOVE      PDUD          WDUD
     C                   MOVE      PEVT          WEVT
      *
     C     KADVC         KLIST
     C                   KFLD                    KREFNO           30
     C                   KFLD                    KPRGMN           10
     C                   KFLD                    KNARR            29
      *
     C                   MOVE      *BLANKS       KREFNO
     C                   MOVEL     WREFNO        KREFNO
     C**********         MOVEL     'SEH023'      KPRGMN                                  HUT105
     C                   MOVEL     'XX105023'    KPRGMN                                  HUT105
      *
     C                   OPEN      READVCL3
     C     KADVC         CHAIN     READVCL3                           69
      *
     C     *IN69         IFEQ      *ON
     C                   MOVE      *BLANKS       RREFNO
     C                   MOVEL     WREFNO        RREFNO
     C                   MOVE      *BLANKS       RPRGMN
     C**********         MOVEL     'SEH023'      RPRGMN                                  HUT105
     C                   MOVEL     'XX105023'    RPRGMN                                  HUT105
     C                   MOVE      *BLANKS       RSEQNO
     C                   MOVE      PEVT          RTRTYP
      *
     C     CHTP          IFEQ      'Y'
     C                   MOVEL     'I'           RCHTYP
     C                   ENDIF
      *
     C                   MOVE      'Y'           RAUTHI
     C                   MOVE      'N'           RSAPIN
     C                   MOVEL     P3OTNL        RENARR
     C                   WRITE     READVCD0
      *
     C                   ELSE
      *
      ** Check first if this is a new record.
      *
     C     RCHTYP        IFEQ      'I'
     C     RSAPIN        ANDEQ     'N'
     C                   GOTO      EIDXT
     C                   ENDIF
      *
     C     CHTP          IFEQ      'Y'
     C                   MOVEL     'I'           RCHTYP
     C                   ENDIF
     C                   MOVE      'Y'           RAUTHI
     C                   MOVE      'N'           RSAPIN
     C                   UPDATE    READVCD0
     C                   ENDIF
      *
     C                   CLOSE     READVCL3
     C                   UNLOCK    READVCL3
      *
     C                   ENDIF
      *
     C     EIDXT         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS - Send message to program's message queue.            *
      *                                                               *
      *****************************************************************
      *
     C     ZASNMS        BEGSR
      *
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     'GBXXUSR'     ZAMSGF
     C                   MOVE      'MSG'         ZAMSGF
     C                   ENDIF
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN99
     C     ZAMSDA        IFNE      *BLANK
     C     MSGDTA        LOOKUP    ERR                                    99
     C                   ENDIF
      *                                                                                    AR1010460
     C     *IN99         IFEQ      *OFF
     C     ZAMSDA        ANDNE     *BLANK
     C                   ADD       1             X
     C                   MOVE      MSGDTA        ERR(X)
     C                   ENDIF
      *                                                                                    AR1010460
     C     *IN99         IFEQ      *OFF
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
     C                   ENDIF
      *                                                                                    AR1010460
     C                   MOVE      *OFF          *IN99
     C                   MOVE      *BLANKS       ZAMSDA
     C                   MOVE      *BLANKS       MSGDTA
      *
     C     ZAEXIT        ENDSR
      *
      *****************************************************************
      /EJECT                                                                               AR1010460
      *****************************************************************                    AR1010460
      *                                                               *                    AR1010460
      *  VALSET - Validate Settlement account.                        *                    AR1010460
      *                                                               *                    AR1010460
      *****************************************************************                    AR1010460
      *                                                                                    AR1010460
     C     VALSET        BEGSR
      *                                                                                    HUT024
     C                   MOVE      *OFF          *IN83
      *                                                                                    AR1010460
      ** Check if a/c is not blocked                                                       AR1010460
      *                                                                                    AR1010460
     C     PSMT          IFEQ      04
     C                   MOVEL     PCPY          K1CNUM
     C                   MOVE      BMACCD        K1ACOD
     C                   MOVE      PSCU          K1CCY
     C                   Z-ADD     1             K1ACSQ
     C                   MOVEL     PBCA          K1BRCA
      *                                                                                    AR1010460
     C     ACCNT1        CHAIN     ACCNTABF                           99
      *                                                                                    AR1010460
     C     *IN99         IFEQ      *ON
     C                   MOVE      '1'           *IN41
     C                   MOVE      'HUT1114'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C     RECIA         IFEQ      'C'
     C                   MOVE      '1'           *IN41
     C                   MOVE      'HUT1120'     ZAMSID
     C                   MOVEL     MSGDTA        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   TESTB     '3'           RETB                     17
     C     PPRE          IFEQ      'P'
     C     *IN17         ANDEQ     '1'
     C*****HUT024        ANDEQ     'Y'                                                   HUT111
     C     HUT111        ANDEQ     'Y'                                                   HUT111
     C                   MOVE      *ON           *IN83
     C                   ENDIF
     C**********           ELSE                                                  AR1010460 AR1027562
     C**********           TESTB'2'       RETB           16                      AR1010460 AR1027562
     C**********           TESTB'3'       RETB           17                      AR1010460 AR1027562
     C********** PPRE      IFEQ 'P'                                              AR1010460 AR1027562
     C********** *IN16     ANDEQ'1'                                              AR1010460 AR1027562
     C********** PPRE      OREQ 'R'                                              AR1010460 AR1027562
     C********** *IN17     ANDEQ'1'                                              AR1010460 AR1027562
     C**********           MOVE '1'       *IN41                                  AR1010460 AR1027562
     C**********           MOVE 'HUT1121' ZAMSID                                 AR1010460 AR1027562
     C**********           MOVELMSGDTA    ZAMSDA                                 AR1010460 AR1027562
     C**********           MOVEL*BLANK    ZAMSGF                                 AR1010460 AR1027562
     C**********           EXSR ZASNMS                                           AR1010460 AR1027562
     C**********           ENDIF                                                 AR1010460 AR1027562
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                    AR1010460
     C     PSMT          IFEQ      15
     C                   MOVEL     PCPY          K1CNUM
     C                   MOVE      BFACCD        K1ACOD
     C                   MOVE      PSCU          K1CCY
     C                   Z-ADD     BFACSN        K1ACSQ
     C     PSEB          IFNE      *BLANKS
     C                   MOVEL     PSEB          K1BRCA
     C                   ELSE
     C                   MOVEL     PBCA          K1BRCA
     C                   ENDIF
      *                                                                                    AR1010460
     C     ACCNT1        CHAIN     ACCNTABF                           99
      *                                                                                    AR1010460
     C     *IN99         IFEQ      *ON
     C                   MOVE      '1'           *IN41
     C                   MOVE      'HUT1117'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C     RECIA         IFEQ      'C'
     C                   MOVE      '1'           *IN41
     C                   MOVE      'HUT1120'     ZAMSID
     C                   MOVEL     MSGDTA        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C**********           ELSE                                                  AR1010460 AR1027562
     C**********           TESTB'2'       RETB           16                      AR1010460 AR1027562
     C**********           TESTB'3'       RETB           17                      AR1010460 AR1027562
     C********** PPRE      IFEQ 'P'                                              AR1010460 AR1027562
     C********** *IN16     ANDEQ'1'                                              AR1010460 AR1027562
     C********** PPRE      OREQ 'R'                                              AR1010460 AR1027562
     C********** *IN17     ANDEQ'1'                                              AR1010460 AR1027562
     C**********           MOVE '1'       *IN41                                  AR1010460 AR1027562
     C**********           MOVE 'HUT1121' ZAMSID                                 AR1010460 AR1027562
     C**********           MOVELMSGDTA    ZAMSDA                                 AR1010460 AR1027562
     C**********           MOVEL*BLANK    ZAMSGF                                 AR1010460 AR1027562
     C**********           EXSR ZASNMS                                           AR1010460 AR1027562
     C**********           ENDIF                                                 AR1010460 AR1027562
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                    AR1010460
     C     PSMT          IFEQ      05
     C                   MOVEL     PSEA          PSEA@
     C                   MOVEL     PSCU          K2CCY
     C                   MOVEL     PSEB          K2BRCA
      *                                                                                    AR1010460
     C     ACCNT2        CHAIN     ACCNT                              99
      *                                                                                    AR1010460
     C     *IN99         IFEQ      *ON
     C                   MOVE      '1'           *IN41
     C                   MOVE      'HUT1115'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C     RECIA         IFEQ      'C'
     C                   MOVE      '1'           *IN41
     C                   MOVE      'HUT1120'     ZAMSID
     C                   MOVEL     MSGDTA        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   TESTB     '3'           RETB                     17
     C     PPRE          IFEQ      'P'
     C     *IN17         ANDEQ     '1'
     C*****HUT024        ANDEQ     'Y'                                                   HUT111
     C     HUT111        ANDEQ     'Y'                                                   HUT111
     C     ATYP          ANDEQ     'R'
     C                   MOVE      *ON           *IN83
     C                   ENDIF
     C**********           ELSE                                                  AR1010460 AR1027562
     C**********           TESTB'2'       RETB           16                      AR1010460 AR1027562
     C**********           TESTB'3'       RETB           17                      AR1010460 AR1027562
     C********** PPRE      IFEQ 'P'                                              AR1010460 AR1027562
     C********** *IN16     ANDEQ'1'                                              AR1010460 AR1027562
     C********** PPRE      OREQ 'R'                                              AR1010460 AR1027562
     C********** *IN17     ANDEQ'1'                                              AR1010460 AR1027562
     C**********           MOVE '1'       *IN41                                  AR1010460 AR1027562
     C**********           MOVE 'HUT1121' ZAMSID                                 AR1010460 AR1027562
     C**********           MOVELMSGDTA    ZAMSDA                                 AR1010460 AR1027562
     C**********           MOVEL*BLANK    ZAMSGF                                 AR1010460 AR1027562
     C**********           EXSR ZASNMS                                           AR1010460 AR1027562
     C**********           ENDIF                                                 AR1010460 AR1027562
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                    AR1010460
     C     PSMT          IFEQ      14
     C                   MOVEL     PSEA          ACNO
      *                                                                                    AR1010460
     C     ACNO          CHAIN     ACNUM                              99
      *                                                                                    AR1010460
     C     *IN99         IFEQ      '0'
     C     RECIA         ANDNE     'C'
     C**********         Z-ADD     CNUM          CUS@                                    HUT105
     C                   MOVE      CNUM          CUS@                                    HUT105
     C                   Z-ADD     ACOD          ACOD@
     C                   Z-ADD     ACSQ          ACSQ@
     C                   MOVEL     BRCA          K2BRCA
     C                   MOVEL     CCY           K2CCY
      *                                                                                    AR1010460
     C     ACCNT2        CHAIN     ACCNT                              99
      *                                                                                    AR1010460
     C     *IN99         IFEQ      *ON
     C                   MOVE      '1'           *IN41
     C                   MOVE      'HUT1116'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C     RECIA         IFEQ      'C'
     C                   MOVE      '1'           *IN41
     C                   MOVE      'HUT1120'     ZAMSID
     C                   MOVEL     MSGDTA        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   TESTB     '3'           RETB                     17
     C     PPRE          IFEQ      'P'
     C     *IN17         ANDEQ     '1'
     C*****HUT024        ANDEQ     'Y'                                                   HUT111
     C     HUT111        ANDEQ     'Y'                                                   HUT111
     C                   MOVE      *ON           *IN83
     C                   ENDIF
     C**********           ELSE                                                  AR1010460 AR1027562
     C**********           TESTB'2'       RETB           16                      AR1010460 AR1027562
     C**********           TESTB'3'       RETB           17                      AR1010460 AR1027562
     C********** PPRE      IFEQ 'P'                                              AR1010460 AR1027562
     C********** *IN16     ANDEQ'1'                                              AR1010460 AR1027562
     C********** PPRE      OREQ 'R'                                              AR1010460 AR1027562
     C********** *IN17     ANDEQ'1'                                              AR1010460 AR1027562
     C**********           MOVE '1'       *IN41                                  AR1010460 AR1027562
     C**********           MOVE 'HUT1121' ZAMSID                                 AR1010460 AR1027562
     C**********           MOVELMSGDTA    ZAMSDA                                 AR1010460 AR1027562
     C**********           MOVEL*BLANK    ZAMSGF                                 AR1010460 AR1027562
     C**********           EXSR ZASNMS                                           AR1010460 AR1027562
     C**********           ENDIF                                                 AR1010460 AR1027562
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   MOVE      '1'           *IN41
     C                   MOVE      'HUT1116'     ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *                                                                                    AR1010460
     C     VAEXIT        ENDSR
      *                                                                                    AR1010460
      *****************************************************************                    AR1010460
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
     C*COPY*ZSRSRC*ZCHKH                                                               259148 HUT105
     C*COPY*ZSRSRC*ZACCH                                                               259148 HUT105
     C/COPY ZSRSRC,ZCHKHLE                                                                    HUT105
     C/COPY ZSRSRC,ZACCHLE                                                                    HUT105
      ********************************************************************
**CTDATA CPY@
(c) Finastra International Systems Ltd. 2020
