     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Netting groups maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL001242  - Netting Groups Maintenance                       *
      *                                                               *
      *  Function:  This Program Defines Accounts To Be Netted And    *
      *             The Primary Accounts To Hold The Netted Balance   *
      *             For The Calculation Of The Risk.                  *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG2677            Date 25Jun04               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL018  *CREATE    Date 28Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG2677 - Corrected the size of the account work variable.   *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Any Cycle Or Condition                          *
      *    02         Any Cycle Or Condition                          *
      *    03         Any Cycle Or Condition                          *
      *      Display:                                                 *
      *    27         Insert Mode                                     *
      *    30         Action Code field                               *
      *    31         Branch, Cust., Curr., Code, Sequence fields     *
      *    32         Retail field                                    *
      *    33         Branch, Cust., Curr., Code, Sequence fields     *
      *    34         Retail field                                    *
      *    35         All/Re field                                    *
      *    36         Action field                                    *
      *    37         Multibranching                                  *
      *    38         All/Re field (PR, UL)                           *
      *    39         Y/N Indicator field (PR, UL)                    *
      *    40         Primary/Secondary field (PR, UL)                *
      *    41         Action field (PR, UL)                           *
      *    42         Delete Mode                                     *
      *    43         Enquiry Mode                                    *
      *    44         Y/N Indicator field (RI, PC)                    *
      *    45         Primary/Secondary field (RI, PC)                *
      *    46         Action field (RI, PC)                           *
      *    47         Account (RI, PC)                                *
      *    48         Enable F10 Key                                  *
      *    50         Prevent P=Primary on insert                     *
      *    80         'Rollup/Rolldown' text                          *
      *    91         SFLEND in MSGQ                                  *
      *    95         Date Format                                     *
      *    97         SFLDSP, SFLCLR, SFLDSPCTL                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
      *
      **  Midas GL Account details - full a/c number
      *
     FACCNTL0   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(A0)
     F                                     RENAME(ACCNTABF:ACCDL0)
      *
      **  Midas GL Account details - retail key
      *
     FACCNTL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(A1)
     F                                     RENAME(ACCNTABF:ACCDL1)
      *
      **  Risk Weighted Asset Netting Group Master File Upd
      *
     FGLNETGL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L0)
      *
      **  Risk Weighted Asset Netting Group Master File Retr
      *
     FGLNETGL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L1)
     F                                     RENAME(GLNETGD0:GLNETGD1)
      *
      **  Risk Weighted Asset Netting Group by Primary Group
      *
     FGLNETGL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L2)
     F                                     RENAME(GLNETGD0:GLNETGD2)
      *
      **  Risk Weighted Asset Netting Group by Primary Retai
      *
     FGLNETGL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L3)
     F                                     RENAME(GLNETGD0:GLNETGD3)
      *
      **  Risk Weighted Asset Master File Update Index
      *
     FSDRWASL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S1)
      *
      **  Risk Weighted Asset Codes Master File Update Index
      *
     FSDRWACL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CO)
      *
      **  Midas SD Customer details retrieval
      *
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CU)
      *
      **  Risk Weighted Assets Sets Maintenance Display
      *
     FGL001242DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(GL1242S1:DDSFRN)
     F                                     SFILE(GL1242S3:DDSFR2)
     F                                     INFDS(INFDS#)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for Access Programs, Short Data Structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** ExternaL DS for Bank Details
 
     D MUSER         E DS                  EXTNAME(MUSERDD)
     D                                     PREFIX(U)
      ** External DS for User Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program Status Data Structure
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
      *
     D INDIC1          S               N
     D INDIC2          S               N
     D INDIC3          S               N
     D INDIC4          S               N
 
     D ConfFlag        S              1A
     D ClrScnFlag      S              1A
     D B#ACOD          S             10S 0                                                    CGL029
     D T#4             S             10A                                                      CGL029
     D S#ACON          S             10S 0                                                    CGL029
      *
     D                 DS
     D DDCUSR                  1      6
     D*DNCUSR***               1      6  0                                                    CSD027
     D DNCUSR                  1      6                                                       CSD027
      *
     D                 DS
     D*DDACOR                  1      4                                                       CGL029
     D*DNACOR                  1      4  0                                                    CGL029
     D DDACOR                  1     10                                                       CGL029
     D DNACOR                  1     10  0                                                    CGL029
      *
     D                 DS
     D DDSEQR                  1      2
     D DNSEQR                  1      2  0
      *
     D                 DS
     D DDRETR                  1     10
     D DNRETR                  1     10  0
      *
     D                 DS
     D DDCUSI                  1      6
     D*DNCUSI***               1      6  0                                                    CSD027
     D DNCUSI                  1      6                                                       CSD027
      *
     D                 DS
     D*DDACOI                  1      4                                                       CGL029
     D*DNACOI                  1      4  0                                                    CGL029
     D DDACOI                  1     10                                                       CGL029
     D DNACOI                  1     10  0                                                    CGL029
      *
     D                 DS
     D DDSEQI                  1      2
     D DNSEQI                  1      2  0
      *
     D                 DS
     D DDRETI                  1     10
     D DNRETI                  1     10  0
      *
     D C#NUM           C                   '1234567890'
      *
     D V#ACC           DS
     D  V#BRC                  1      3
     D  V#P1                   4      4    INZ('-')
     D**V#CUSN**               5     10  0                                                    CSD027
     D  V#CUSN                 5     10                                                       CSD027
     D  V#CUSC                 5     10
     D  V#P2                  11     11    INZ('-')
     D  V#CCY                 12     14
     D  V#P3                  15     15    INZ('-')
     D**V#ACON*               16     19  0                                                    CGL029
     D**V#ACOC*               16     19                                                       CGL029
     D**V#P4***               20     20    INZ('-')                                           CGL029
     D**V#ACSN*               21     22  0                                                    CGL029
     D**V#ACSC*               21     22                                                       CGL029
     D  V#ACON                16     25  0                                                    CGL029
     D  V#ACOC                16     25                                                       CGL029
     D  V#P4                  26     26    INZ('-')                                           CGL029
     D  V#ACSN                27     28  0                                                    CGL029
     D  V#ACSC                27     28                                                       CGL029
      *
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      **  Clear message subfile
      *
     C                   EXSR      SRCLRM
      *
     C                   EVAL      VALSFLOK = *blank
     C                   EVAL      ClrScnFlag = *blank
      *
      ** Process until F3 entered
      *
     C                   DOW       *INKC = *OFF
      *
      ** Set Of Variables To Blank
      *
     C                   IF        VALSFLOK = *blank
     C                             and ClrScnFlag = *blank
     C                   MOVE      *BLANK        DDACOD                         Action
     C                   MOVE      *BLANK        DDBRCI                         1. Account
     C                   MOVE      *BLANK        DDCUSI
     C                   MOVE      *BLANK        DDCCYI
     C                   MOVE      *BLANK        DDACOI
     C                   MOVE      *BLANK        DDSEQI
     C                   MOVE      *BLANK        DDRETI                         1. Retail
     C                   MOVE      *BLANK        DDALRI                         ALL/RE        CGL018
     C                   MOVE      *BLANK        DDBRCR                         2. Account
     C                   MOVE      *BLANK        DDCUSR
     C                   MOVE      *BLANK        DDCCYR
     C                   MOVE      *BLANK        DDACOR
     C                   MOVE      *BLANK        DDSEQR
     C                   MOVE      *BLANK        DDRETR                         2. Retail
     C                   ENDIF                                                                CGL018
     C                   WRITE     GL1242M0                                     Message CTL
     C                   EXFMT     GL1242D1
      *
      **  F3 Key To Exit
      *
     C                   IF        *INKC = *ON
     C                   ITER
     C                   ENDIF
      *
      **  Clear message subfile
      *
     C                   EXSR      SRCLRM
     C                   EVAL      ClrScnFlag = *blank
      *
      **  Validate Action
      *
     C                   EXSR      SRVALACT
     C                   IF        VALSFLOK <> *BLANK
     C                   ITER
     C                   ENDIF
      *
      **  Validate Input Fields
      *
     C                   EXSR      SRVALIFLD
     C                   IF        VALSFLOK <> *BLANK
     C                   ITER
     C                   ENDIF
      *
      **  Get Some SFL
      *
     C                   EXSR      SRGETSFL
     C                   IF        VALSFLOK <> *BLANK
     C                   ITER
     C                   ENDIF
     C
      *
      **  Reading Records
      *
     C                   ENDDO
      *========================================================================================
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *========================================================================================
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      **  Initialise LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBPGM
     C                   OUT       LDA
      *
      **  Call Access Program for Bank Details - Title, Run Date and
      **  Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Handle Database Error.
      *
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE                         ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
      **  Check System Date Format, DDMMYY (*IN95 off)
      **                            MMDDYY (*IN95 on).
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        95
     C                   ENDIF
      *
      **  Access RUNDAT for multibranching indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C
     C     AGMBIN        IFEQ      'M'
     C                   SETON                                        37
     C                   ENDIF
     C
     C                   MOVEL     'GLUSRMSG'    ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *BLANK        ZAMSID            7
     C                   MOVEL     *BLANK        ZAMSDA          132
     C                   MOVEL     *BLANK        ZAMSTP            7
      *
      **  Set Display Variables
      *
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDWID = PSJobName
     C                   EVAL      DDPGMQ = PSProcPgm
      *
      **  Clear Message Subfile
      *
     C                   EXSR      SRCLRM
      *
      **  Set SFLMSG Indicator
      *
     C                   MOVE      *ON           *IN91
      *
      **  Set A Key For GLNETGL2
      *
     C     K#NETL2       KLIST
     C                   KFLD                    DDBRCR
     C                   KFLD                    DNCUSR
     C                   KFLD                    DDCCYR
     C                   KFLD                    DNACOR
     C                   KFLD                    DNSEQR
      *
      **  Set A Key For GLNETGL2
      *
     C     K#NETL2X      KLIST
     C                   KFLD                    DDBRCI
     C                   KFLD                    DNCUSI
     C                   KFLD                    DDCCYI
     C                   KFLD                    DNACOI
     C                   KFLD                    DNSEQI
      *
      **  Set A Key For GLNETGL2
      *
     C     K#NETL2XP     KLIST
     C                   KFLD                    DDBRCI
     C                   KFLD                    DNCUSI
     C                   KFLD                    DDCCYI
     C                   KFLD                    DNACOI
     C                   KFLD                    DNSEQI
     C                   KFLD                    V#PRIM            1
      *
      **  Set A Key For GLNETGL1 And GLNETGL2
      *
     C     K#GLNETL      KLIST
     C                   KFLD                    V#BRC
     C                   KFLD                    V#CUSN
     C                   KFLD                    V#CCY
     C                   KFLD                    V#ACON
     C                   KFLD                    V#ACSN
      *
      **  Set A Key For ACCNTL0
      *
     C     K#ACCL0       KLIST
     C                   KFLD                    DNCUSI
     C                   KFLD                    DDCCYI
     C                   KFLD                    DNACOI
     C                   KFLD                    DNSEQI
     C                   KFLD                    DDBRCI
      *
      **  Set A Key For ACCNTL0 (Customer, Currency)
      *
     C     K#ACCL03      KLIST
     C**********         KFLD                    K#CNUM            6 0                        CSD027
     C                   KFLD                    K#CNUM            6                          CSD027
     C                   KFLD                    K#CCY             3
      *
      **  Set A Key For GLNETGL2
      *
     C     K#GL2S        KLIST
     C                   KFLD                    A0BRCA
     C                   KFLD                    A0CNUM
     C                   KFLD                    A0CCY
     C                   KFLD                    A0ACOD
     C                   KFLD                    A0ACSQ
      *
     C                   ENDSR
      *
      /EJECT
 
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
      *
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  '(file)'
     C                   EVAL      DBKEY  =  '(key)'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  999
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  PSProcName
     C                   OUT       LDA
      *
     C                   DUMP
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
      **  Any Error, Do Rollback
      *
     C                   ROLBK
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
      * VALOPT - VALIDATE OPTION                                      *
      *****************************************************************
      *
     C     VALOPT        BEGSR
     C
     C     AGMBIN        IFEQ      'N'
     C                   CALL      'ZVACTU'
     C                   PARM                    WACTN             1
     C                   PARM                    WERR              1 0
      *
      **  In case of Multientity system, check if user is authorised
      **  for action in default branch
      *
     C                   ELSE
      *
     C                   CALL      'AOUSERR0'
     C                   PARM                    UReturn           7
     C                   PARM      '*KEY'        UOption           7
     C                   PARM      DDUSER        UUserID          10
     C     MUSER         PARM      MUSER         DSFDY
      *
     C                   CALL      'ZVACTBU'
     C                   PARM                    WACTN
     C                   PARM      UDBRN         WZBR              3
     C                   PARM                    WERR
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRSNDMSG - Send Message To The Program Message Queue          *
      * --------                                                      *
      * Called by:                                                    *
      * Calls: None                                                   *
      *****************************************************************
      *
     C     SRSENDMSG     BEGSR
     C
     C                   IF        ZAMSGF = *BLANKS
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
     C                   ENDIF
     C
     C                   CALL      'Y2SNMGC'
     C                   PARM      PSProcPgm     ZAPGM            10
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM      *BLANK        ZAMSTP
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRCLRM - CLEAR MESSAGE SUBFILE                                *
      * ------                                                        *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     SRCLRM        BEGSR
     C
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSPROCPGM     ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
     C
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * SRVALACT - Validate Action Field                              *
      * --------                                                      *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     SRVALACT      BEGSR
      *
     C                   MOVE      *BLANK        VALSFLOK
     C                   MOVE      *OFF          *IN30                          PC AND RI
      *
     C                   IF        DDACOD = *BLANK
     C                   EVAL      DDACOD = 'E'
     C                   ENDIF
      *
     C                   IF        (DDACOD <> 'I') AND (DDACOD <> 'A') AND
     C                             (DDACOD <> 'D') AND (DDACOD <> 'E')
      *
      **  Action code can only be I,A,E or D, enter a valid action
      *
     C                   MOVE      'USR0907'     ZAMSID
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN30                          PC AND RI
     C
     C                   ELSE
     C
     C                   EVAL      WACTN = DDACOD
     C                   EXSR      VALOPT
     C     WERR          IFNE      0
      *
      **  User not authorised to action code &1
      *
     C                   MOVE      'GLX0318'     ZAMSID
     C                   MOVEL(P)  DDACOD        ZAMSDA
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN30                          PC AND RI
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRGETSFL - Get Some SFL                                       *
      * --------                                                      *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     SRGETSFL      BEGSR
      *
     C                   DO
     C     REDIST        TAG
     C                   MOVE      *OFF          REDISP            1
      *
      **  Selection Of An Primary Account
      *
     C                   IF        (INDIC1 = *OFF)  AND (INDIC2 = *OFF)  AND
     C                             (INDIC3 = *OFF)  AND (INDIC4 = *OFF)  OR
     C                             (INDIC3 = *ON)   OR (INDIC4 = *ON)
     C                   EXSR      SRSELPRACC
      *
      **  Clear Message Subfile
      *
     C                   EXSR      SRCLRM
     C                   ENDIF
      *
      **  Selection Of An Open Account On The System
      *
     C                   IF        (INDIC1 = *ON) OR
     C                             (INDIC2 = *ON)
      *
      **  Fill The First Account
      *
     C                   EXSR      SRFILLFRST
     C                   IF        VALSFLOK <> *BLANK
     C                   LEAVE
     C                   ENDIF
      *
     C                   EXSR      SRFILLOPEN
     C                   ENDIF
      *
     C                   IF        REDISP = *ON
     C                   MOVE      *OFF          *INKL
     C                   GOTO      REDIST
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRSELPRACC - Selection Of An Primary Account                  *
      * ------                                                        *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     SRSELPRACC    BEGSR
      *
      **  Show Select Screen
      *
     C                   DOW       *INKC = *OFF AND
     C                             *INKL = *OFF
      *
      **  Build Primary Accounts Subfile
      *
     C                   EXSR      BLDPRSFL
     C
     C                   WRITE     GL1242M0                                     Message CTL
     C     SFLREC2       IFNE      0
     C                   WRITE     GL1242F2
     C                   EXFMT     GL1242S2
     C                   ELSE
      *
      **  No Record Screen
      *
     C                   MOVE      *ON           *IN80                          Text On Bottom Scr
     C                   EXFMT     GL1242N2
     C                   MOVE      *OFF          *IN80
     C                   ENDIF
      *
      **  F3/F12 Key
      *
     C                   IF        *INKC = *ON  OR
     C                             *INKL = *ON
     C                   Eval      ClrScnFlag = *blank
     C                   Eval      VALSFLOK = *blank
     C                   ITER
     C                   ENDIF
      *
      **  If Selection Field Is Not Blank Build SFL Again
      *
     C                   IF        DDACCR <> *BLANK
     C                   ITER
     C                   ENDIF
      *
      **  Validate Select Subfile Screen
      *
     C     SFLREC2       IFNE      0
     C                   EXSR      SRVALPRACC
     C                   IF        VALSFLOK = *BLANK
     C                   Eval      ClrScnFlag = 'N'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRFILLOPEN - Selection Of An Open Account On The System       *
      * ------                                                        *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     SRFILLOPEN    BEGSR
      *
      **  Enable/Disable F9 Key
      *
     C                   IF        (DDACOD = 'I') OR
     C                             (DDACOD = 'A')
     C                   MOVE      *OFF          *IN27
     C                   ELSE
     C                   MOVE      *ON           *IN27
     C                   ENDIF
      *
      **  Build Primary Accounts Subfile For 'I'
      *
     C                   IF        (DDACOD = 'I')
     C                   EXSR      BLDOPSFL
     C                   ENDIF
      *
      **  Build Primary Accounts Subfile For 'E', 'A', 'D'
      *
     C                   IF        (DDACOD = 'E') OR
     C                             (DDACOD = 'A') OR
     C                             (DDACOD = 'D')
     C                   EXSR      BLDOPSFLE
     C                   ENDIF
      *
     C                   IF        (DDACOD = 'D') OR
     C                             (DDACOD = 'A')
     C                   MOVE      *ON           *IN48                          Enable F10
     C                   ELSE
     C                   MOVE      *OFF          *IN48                          Disable F10
     C                   ENDIF
      *
      **  Set Fields To Enquiry Mode
      *
     C                   IF        (DDACOD = 'E')
     C                   MOVE      *ON           *IN43
     C                   ELSE
     C                   MOVE      *OFF          *IN43
     C                   ENDIF
      *
      **  P=Primary not allowed on insert
      *
     C                   EVAL      *IN50 = *off
     C                   IF        DDACOD = 'I'
     C                   EVAL      *IN50 = *on
     C                   ENDIF
      *
      **  Show Select Screen
      *
     C                   DOW       *INKC = *OFF AND
     C                             *INKL = *OFF
      *
      **  Set Fields To Delete Mode
      *
     C                   IF        (DDACOD = 'D')
     C                   MOVE      *ON           *IN42
      *
      **  Confirm delete by pressing F10
      *
     C                   MOVE      'CSF9101'     ZAMSID
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   ELSE
     C                   MOVE      *OFF          *IN42
     C                   ENDIF
      *
     C                   WRITE     GL1242M0                                     Message CTL
     C     SFLRECN       IFNE      0
     C                   WRITE     GL1242F1
     C                   EXFMT     GL1242S0
     C                   ELSE
      *
      **  No Retail Account
      *
     C                   EXFMT     GL1242N0
     C                   ENDIF
      *
      **  Clear message subfile
      *
     C                   EXSR      SRCLRM
      *
      **  F3 or F12 Key Pressed
      *
     C                   IF        (*INKC = *ON) OR (*INKL = *ON)
     C                   EVAL      ClrScnFlag = *blank
     C                   ITER
     C                   ENDIF
      *
      **  F9 Key Pressed
      *
     C                   IF        (*INKI = *ON) AND (DDACOD = 'A')
      *
     C                   EXSR      SRCHKSFL
     C                   IF        VALSFLOK <> *BLANK
     C                   ITER
     C                   ENDIF
      *
     C                   EXSR      SRADDACC
     C                   EVAL      DDACOD = 'I'
     C                   MOVE      'Y'           F9PRESSED         1
     C                   ITER
     C                   ENDIF
      *
      *
      **  F10 Key Pressed
      *
     C                   IF        (*INKJ = *ON) AND (DDACOD = 'D')
     C                   EXSR      SRDEL
     C                   EXSR      SRCLRM
      *
      **  Netting group for a/c &1&2&3&4&5 has been deleted
      *
     C**********         MOVE      *BLANK        T#18                                        BUG2677
     C**********         EVAL      T#18 = DDBRCS + DDCUSS + DDCCYS + DDACOS +                BUG2677
     C**********                   DDSEQS
     C                   MOVE      *BLANK        T#24                                        BUG2677
     C                   EVAL      T#24 = DDBRCS + DDCUSS + DDCCYS + DDACOS +                BUG2677
     C                             DDSEQS                                                    BUG2677
     C                   MOVE      'USR1009'     ZAMSID
     C**********         MOVEL(P)  T#18          ZAMSDA                                      BUG2677
     C                   MOVEL(P)  T#24          ZAMSDA                                      BUG2677
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   MOVE      *ON           *INKL
     C                   EVAL      ClrScnFlag = *blank
     C                   ITER
     C                   ENDIF
      *
      **  Validate SFL actions
      *
     C                   IF        (DDACOD <> 'D') AND
     C                             (DDACOD <> 'E')
      *
     C                   IF        (DDACOD = 'I')
     C                   EXSR      SRVALINS
     C                   ENDIF
      *
     C                   IF        (DDACOD = 'A')
     C                   MOVE      *BLANK        MODE              1
     C                   EXSR      SRVALAMD
     C                   ENDIF
      *
      **  F10 To Delete Any Account
      *
     C                   IF        V#YNI <> 0    AND
     C                             *INKJ = *ON   AND
     C                             VALSFLOK = *BLANK
     C                   EXSR      SRWRIAMD
     C                   MOVE      *ON           REDISP
     C                   ENDIF
      *
     C                   IF        VALSFLOK = *BLANK
      *
     C                   IF        (DDACOD = 'I')
     C                   EXSR      SRWRIINS
     C                   ENDIF
      *
     C                   IF        (DDACOD = 'A') AND
     C                             REDISP = *OFF
     C                   EXSR      SRWRIAMD
     C                   ENDIF
      *
     C                   MOVE      *ON           *INKL
     C                   EVAL      ClrScnFlag = *blank
      *
     C                   ELSE
     C                   ITER
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * BLDPRSFL - Build Primary Accounts Subfile                     *
      * ------                                                        *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     BLDPRSFL      BEGSR
      *
      **  Build For Full Midas Or Retail?
      *
     C                   IF        DDACCR <> *BLANK
     C                   EVAL      DDBRCR = %SUBST(DDACCR:1:3)
     C                   EVAL      DDCUSR = %SUBST(DDACCR:4:6)
     C                   EVAL      DDCCYR = %SUBST(DDACCR:10:3)
     C**********         EVAL      DDACOR = %SUBST(DDACCR:13:4)                               CGL029
     C**********         EVAL      DDSEQR = %SUBST(DDACCR:17:2)                               CGL029
     C                   EVAL      DDACOR = %SUBST(DDACCR:13:10)                              CGL029
     C                   EVAL      DDSEQR = %SUBST(DDACCR:23:2)                               CGL029
     C                   MOVE      *BLANK        DDACCR
     C                   MOVE      *OFF          INDIC4
     C                   MOVE      *ON           INDIC3
     C                   ENDIF
      *
     C                   MOVE      *BLANK        FOR               1
 
     C                   SELECT
 
     C                   WHEN      (INDIC3 = *ON)
     C                   EVAL      FOR = 'F'
      *
      ** Allow partial key
     C                   IF        DDCUSR = *blanks
     C                   EVAL      DDCUSR = '000000'
     C                   ENDIF
     C                   IF        DDACOR = *blanks
     C                   EVAL      DDACOR = '0000'
     C                   ENDIF
     C                   IF        DDSEQR = *blanks
     C                   EVAL      DDSEQR = '00'
     C                   ENDIF
 
     C                   WHEN      (INDIC4 = *ON)
     C                   EVAL      FOR = 'R'
 
     C                   ENDSL
      *
      **  Initiation Of Backup Variables
      *
     C                   MOVE      *BLANK        B#BRC             3
     C**********         Z-ADD     0             B#CUST            6 0                        CSD027
     C                   MOVE      *BLANKS       B#CUST            6                          CSD027
     C                   MOVE      *BLANK        B#CCY             3
     C**********         Z-ADD     0             B#ACOD            4 0                        CGL029
     C                   Z-ADD     0             B#ACOD                                       CGL029
     C                   Z-ADD     0             B#SEQ             2 0
      *
      **  Subfile Clearing
      *
     C                   MOVE      *ON           *IN97
     C                   WRITE     GL1242S2
     C                   MOVE      *OFF          *IN97
     C                   Z-ADD     0             DDSFR2
      *
      **  Read the record from the file, write the record to the subfile
      *
     C                   MOVE      *OFF          *IN01
      *
     C                   SELECT
     C                   WHEN      FOR = 'F'
     C     K#NETL2       SETLL     GLNETGL2
     C                   WHEN      FOR = 'R'
     C     DNRETR        SETLL     GLNETGL3
     C                   OTHER
     C     *LOVAL        SETLL     GLNETGL2
     C                   ENDSL
      *
     C                   MOVE      ' '           V#RDB3            1
      *
     C     *IN01         DOUEQ     *ON
      *
     C                   SELECT
     C                   WHEN      (FOR = 'F') OR (FOR = *BLANK)
     C                   READ(N)   GLNETGL2                               01
     C                   WHEN      FOR = 'R'
     C                   READ      GLNETGL3                               01
     C                   ENDSL
      *
     C                   IF        *IN01 = *OFF
      *
      **  GLNETGL2
      *
     C                   IF        (FOR = 'F') AND (L2RWRECI = *BLANK)    OR
     C                             (FOR = *BLANK) AND (L2RWRECI = *BLANK)
     C                   MOVE      'Y'           V#RDB3
     C                   MOVE      *ON           *IN02
      *
      **  Avoid A Double Counting
      *
     C                   IF        L2RWPBRCA = B#BRC  AND
     C                             L2RWPCUST = B#CUST AND
     C                             L2RWPCCY  = B#CCY  AND
     C                             L2RWPACOD = B#ACOD AND
     C                             L2RWPACSQ = B#SEQ
     C                   MOVE      *OFF          *IN02
     C                   ELSE
     C                   EVAL      B#BRC  = L2RWPBRCA
     C                   EVAL      B#CUST = L2RWPCUST
     C                   EVAL      B#CCY  = L2RWPCCY
     C                   EVAL      B#ACOD = L2RWPACOD
     C                   EVAL      B#SEQ  = L2RWPACSQ
     C                   ENDIF
      *
      **  If *In02 *On (Record is valid) Record is written to SFL
      *
     C     *IN02         IFEQ      *ON
     C                   EVAL      DDOPT = *BLANK
     C                   MOVE      *BLANK        T#6               6
     C                   MOVE      L2RWPCUST     T#6
     C**********         MOVE      *BLANK        T#4               4                          CGL029
     C                   MOVE      *BLANK        T#4                                          CGL029
     C                   MOVE      L2RWPACOD     T#4
     C                   MOVE      *BLANK        T#2               2
     C                   MOVE      L2RWPACSQ     T#2
     C                   EVAL      DDACCS = L2RWPBRCA + '-' + T#6 + '-' +
     C                             L2RWPCCY + '-' + T#4 + '-' + T#2
     C                   MOVE      *BLANK        DDRETS
     C                   IF        L2RWPACNO <> 0
     C                   MOVE      L2RWPACNO     DDRETS
     C                   ELSE
     C                   MOVE      *BLANK        DDRETS
     C                   ENDIF
     C                   ADD       1             DDSFR2
     C                   WRITE     GL1242S3
     C                   ENDIF
     C                   ENDIF
      *
      **  GLNETGL3
      *
     C                   IF        L3RWRECI = *BLANK AND                        Live Rec.
     C                             FOR = 'R'
     C                   MOVE      'Y'           V#RDB3
     C                   MOVE      *ON           *IN02
      *
      **  Avoid A Double Counting
      *
     C                   IF        L3RWPBRCA = B#BRC  AND
     C                             L3RWPCUST = B#CUST AND
     C                             L3RWPCCY  = B#CCY  AND
     C                             L3RWPACOD = B#ACOD AND
     C                             L3RWPACSQ = B#SEQ
     C                   MOVE      *OFF          *IN02
     C                   ELSE
     C                   EVAL      B#BRC  = L3RWPBRCA
     C                   EVAL      B#CUST = L3RWPCUST
     C                   EVAL      B#CCY  = L3RWPCCY
     C                   EVAL      B#ACOD = L3RWPACOD
     C                   EVAL      B#SEQ  = L3RWPACSQ
     C                   ENDIF
      *
      **  If *IN02 *ON (Record is valid) Record is written to SFL
      *
     C     *IN02         IFEQ      *ON
     C                   EVAL      DDOPT = *BLANK
     C                   MOVE      *BLANK        T#6               6
     C                   MOVE      L3RWPCUST     T#6
     C**********         MOVE      *BLANK        T#4               4                          CGL029
     C                   MOVE      *BLANK        T#4                                          CGL029
     C                   MOVE      L3RWPACOD     T#4
     C                   MOVE      *BLANK        T#2               2
     C                   MOVE      L3RWPACSQ     T#2
     C                   EVAL      DDACCS = L3RWPBRCA + '-' + T#6 + '-' +
     C                             L3RWPCCY + '-' + T#4 + '-' + T#2
     C                   MOVE      *BLANK        DDRETS
     C                   IF        L3RWPACNO <> 0
     C                   MOVE      L3RWPACNO     DDRETS
     C                   ENDIF
     C                   ADD       1             DDSFR2
     C                   WRITE     GL1242S3
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  /*IN01
     C                   ENDDO
     C
     C                   Z-ADD     DDSFR2        SFLREC2           3 0
      *
      **  Set on the first position
      *
     C                   IF        DDSFR2 <> 0
     C                   Z-ADD     1             DDSFR2
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRVALPRACC - Validate Select Subfile Screen                   *
      * ----------                                                    *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     SRVALPRACC    BEGSR
      *
      **  Set of indicators and variables
      *
     C                   MOVE      *BLANK        VALSFLOK          1
     C                   Z-ADD     1             DDSFR2
     C                   MOVE      'N'           V#RCS2            1
     C                   MOVE      *OFF          *IN01
      *
      **  Subfile read cycle
      *
     C                   DOU       *IN01 = *ON OR
     C                             V#RCS2 = 'Y'
     C                   READC     GL1242S3                               01
     C
     C                   IF        *IN01 = *OFF
     C
     C                   IF        DDOPT  = *BLANK
     C                   UPDATE    GL1242S3
     C                   ELSE
      *
      **  Save Action code to variable
      *
     C                   MOVE      DDOPT         V#ACT2            1
      *
      **  Validate option
      *
     C                   IF        DDOPT <> '1'
      *
      **  Selection must be '1'
      *
     C                   MOVE      'USR1019'     ZAMSID
     C                   MOVEL(P)  DDOPT         ZAMSDA
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN36
      *
     C                   ELSE
     C                   MOVE      'Y'           V#RCS2
      *
      **  Fill The 1st Account
      *
     C                   EVAL      DDBRCI = %SUBST(DDACCS:1:3)
     C                   EVAL      DDCUSI = %SUBST(DDACCS:5:6)
     C                   EVAL      DDCCYI = %SUBST(DDACCS:12:3)
     C**********         EVAL      DDACOI = %SUBST(DDACCS:16:4)                               CGL029
     C**********         EVAL      DDSEQI = %SUBST(DDACCS:21:2)                               CGL029
     C                   EVAL      DDACOI = %SUBST(DDACCS:16:10)                              CGL029
     C                   EVAL      DDSEQI = %SUBST(DDACCS:27:2)                               CGL029
      *
      **  Blank The 2nd Account & Retail
      *
     C                   EVAL      DDBRCR = *BLANK
     C                   EVAL      DDCUSR = *BLANK
     C                   EVAL      DDCCYR = *BLANK
     C                   EVAL      DDACOR = *BLANK
     C                   EVAL      DDSEQR = *BLANK
     C                   EVAL      DDRETR = *BLANK
     C                   LEAVE
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN36                          PC AND RI
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDDO
      *
      **  No record selected, validation VALSFLOK is set to 'N'
      *
     C                   IF        V#RCS2 = 'N'
     C                   MOVE      'N'           VALSFLOK
     C                   ENDIF
      *
      **  If an Action code entered, update SFL
      *
     C                   IF        V#RCS2 = 'Y'
     C                   UPDATE    GL1242S3
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * BLDOPSFL - Build Open Accounts On System Subfile              *
      * --------                                                      *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     BLDOPSFL      BEGSR
      *
      **  Subfile Clearing
      *
     C                   MOVE      *ON           *IN97
     C                   WRITE     GL1242S0
     C                   MOVE      *OFF          *IN97
     C                   Z-ADD     0             DDSFRN
     C                   MOVE      *OFF          *IN02
      *
      **  Turn Off Enquiry/Delete Mode
      *
     C                   MOVE      *OFF          *IN39
     C                   MOVE      *ON           *IN40
     C                   MOVE      *OFF          *IN41
     C                   MOVE      *OFF          *IN42
     C                   MOVE      *OFF          *IN43
     C                   MOVE      *OFF          *IN45
     C                   MOVE      *OFF          *IN46
      *
      **  Write The Customer Accounts to the subfile
      *
     C                   MOVE      ' '           V#RDB3            1
      *
     C                   SELECT
     C                   WHEN      (DDACOD = 'I') AND (FOR = 'F')
     C                   EVAL      K#CNUM = A0CNUM
     C                   EVAL      K#CCY  = A0CCY
     C                   WHEN      (DDACOD = 'I') AND (FOR = 'R')
     C                   EVAL      K#CNUM = A1CNUM
     C                   EVAL      K#CCY  = A1CCY
     C                   OTHER
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN02
     C                   ENDSL
      *
     C     K#ACCL03      SETLL     ACCNTL0
      *
     C     *IN02         DOWEQ     *OFF
     C     K#ACCL03      READE     ACCNTL0                                02
      *
     C                   IF        (*IN02 = *OFF) AND (A0RECI = 'D')
     C                   MOVE      'Y'           V#RDB3
     C                   MOVE      *ON           *IN03
      *
      **  Avoid A Double Counting
      *
     C                   MOVE      *BLANK        T#6
     C                   MOVE      A0CNUM        T#6
     C                   MOVE      *BLANK        T#4
     C                   MOVE      A0ACOD        T#4
     C                   MOVE      *BLANK        T#2
     C                   MOVE      A0ACSQ        T#2
     C                   MOVE      *BLANK        T#10
     C                   MOVE      A0ACNO        T#10
      *
     C                   IF        (FOR = 'F')     AND
     C                             A0BRCA = DDBRCS AND
     C                             T#6    = DDCUSS AND
     C                             A0CCY  = DDCCYS AND
     C                             T#4    = DDACOS AND
     C                             T#2    = DDSEQS
     C                   MOVE      *OFF          *IN03
     C                   ENDIF
      *
     C                   IF        (FOR = 'R')     AND
     C                             T#10 = DDRETS
     C                   MOVE      *OFF          *IN03
     C                   ENDIF
      *
      **  Select All Accounts Or Only Retail Accounts
      *
     C                   IF        (DDALRI <> 'ALL') AND
     C                             (A0ATYP <> 'R')
     C                   MOVE      *OFF          *IN03
     C                   ENDIF
      *
      **  If *In03 *On (Record is valid) Record is written to SFL
      *
     C     *IN03         IFEQ      *ON
     C                   MOVE      *BLANK        T#6               6
     C                   MOVE      A0CNUM        T#6
     C**********         MOVE      *BLANK        T#4               4                          CGL029
     C                   MOVE      *BLANK        T#4                                          CGL029
     C                   MOVE      A0ACOD        T#4
     C                   MOVE      *BLANK        T#2               2
     C                   MOVE      A0ACSQ        T#2
     C                   MOVE      *OFF          *IN46
     C                   MOVE      *BLANK        DDOPT
     C                   MOVE      *OFF          *IN47
     C                   EVAL      DDACC2 = A0BRCA + '-' + T#6 + '-' + A0CCY +
     C                             '-' + T#4 + '-' + T#2
     C                   MOVE      *BLANK        DDRET2
     C                   IF        A0ACNO <> 0
     C                   MOVE      A0ACNO        DDRET2
     C                   ENDIF
     C                   MOVEL(P)  A0ANAM        DDACN2
     C                   IF        (DDALRI = 'ALL')
     C                   MOVE      'N'           DDYN2B
     C                   MOVE      'N'           DDOPT
     C                   ELSE
     C                   MOVE      'Y'           DDYN2B
     C                   MOVE      'Y'           DDOPT
     C                   ENDIF
     C                   MOVE      'S'           DDPS2
     C                   MOVE      'S'           DDPS2B
     C                   ADD       1             DDSFRN
     C                   WRITE     GL1242S1
     C                   ENDIF
     C                   ENDIF                                                  /*IN02
     C                   ENDDO
     C
     C                   Z-ADD     DDSFRN        SFLRECN           3 0
      *
      **  Set on the first position
      *
     C                   IF        DDSFRN <> 0
     C                   Z-ADD     1             DDSFRN
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * BLDOPSFLE - Build Existing Primary/Secondary Accounts         *
      * ---------                                                     *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     BLDOPSFLE     BEGSR
      *
      **  Subfile Clearing
      *
     C                   MOVE      *ON           *IN97
     C                   WRITE     GL1242S0
     C                   MOVE      *OFF          *IN97
     C                   Z-ADD     0             DDSFRN
     C                   MOVE      *OFF          *IN02
      *
      **  Write The Customer Accounts to the subfile
      *
     C                   MOVE      ' '           V#RDB3            1
      *
     C                   SELECT
     C                   WHEN      (DDACOD = 'A') AND (FOR = 'F') OR
     C                             (DDACOD = 'D') AND (FOR = 'F') OR
     C                             (DDACOD = 'E') AND (FOR = 'F')
     C     K#NETL2X      SETLL     GLNETGL2
      *
     C                   WHEN      (DDACOD = 'A') AND (FOR = 'R') OR
     C                             (DDACOD = 'D') AND (FOR = 'R') OR
     C                             (DDACOD = 'E') AND (FOR = 'R')
     C                   EVAL      DDBRCI = L3RWPBRCA
     C                   EVAL      DNCUSI = L3RWPCUST
     C                   EVAL      DDCCYI = L3RWPCCY
     C                   EVAL      DNACOI = L3RWPACOD
     C                   EVAL      DNSEQI = L3RWPACSQ
     C     K#NETL2X      SETLL     GLNETGL2
      *
     C                   OTHER
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN02
     C                   ENDSL
      *
     C     *IN02         DOWEQ     *OFF
     C     K#NETL2X      READE(N)  GLNETGL2                               02
      *
     C                   IF        (*IN02 = *OFF) AND (L2RWRECI = *BLANK)
     C                   MOVE      'Y'           V#RDB3
     C                   MOVE      *ON           *IN03
      *
      **  Avoid A Double Counting, Check The Secondary Account
      *
     C                   MOVE      *BLANK        T#10
     C                   MOVE      L2RWACNO      T#10
      *
     C                   IF        (FOR = 'F')        AND
     C                             L2RWPRIM  = 'P'
     C                   MOVE      *OFF          *IN03
     C                   ENDIF
      *
     C                   IF        (FOR = 'R')     AND
     C                             T#10 = DDRETI
     C                   MOVE      *OFF          *IN03
     C                   ENDIF
      *
      **  If *In03 *On (Record is valid) Record (Secondary Part) Is written to SFL
      *
     C     *IN03         IFEQ      *ON
     C                   EVAL      DDOPT = *BLANK
     C                   MOVE      *BLANK        T#6               6
     C                   MOVE      L2RWCUST      T#6
     C**********         MOVE      *BLANK        T#4               4                          CGL029
     C                   MOVE      *BLANK        T#4                                          CGL029
     C                   MOVE      L2RWACOD      T#4
     C                   MOVE      *BLANK        T#2               2
     C                   MOVE      L2RWACSQ      T#2
     C                   MOVE      *OFF          *IN47
     C                   EVAL      DDACC2 = L2RWBRCA + '-' + T#6 + '-' +
     C                             L2RWCCY + '-' + T#4 + '-' + T#2
     C                   MOVE      *BLANK        DDRET2
     C                   IF        L2RWACNO <> 0
     C                   MOVE      L2RWACNO      DDRET2
     C                   ENDIF
     C                   MOVE      *BLANK        DDACN2
     C                   MOVE      'Y'           DDYN2B
     C                   MOVE      L2RWPRIM      DDPS2
      *
      **  Set Attribute Indicator
      *
     C                   IF        (DDACOD = 'E') OR
     C                             (DDACOD = 'D')
     C                   MOVE      *ON           *IN39
     C                   MOVE      *ON           *IN40
     C                   ELSE
     C                   MOVE      *OFF          *IN39
     C                   MOVE      *OFF          *IN40
     C                   ENDIF
      *
     C                   IF        (DDACOD = 'E') OR
     C                             (DDACOD = 'D')
     C                   MOVE      *ON           *IN41
     C                   ELSE
     C                   MOVE      *OFF          *IN41
     C                   ENDIF
      *
      **  Set default selection to 'Y' if retail accounts or if amendment to
      **  confirmed group, otherwise set to 'N'.
     C                   IF        DDACOD = 'I' or DDACOD = 'A'
     C                   IF        DDOPT = ' ' and DDALRI = 'RE '
     C                             or DDACOD = 'A' and L2RWCONF = 'C'
     C                   EVAL      DDOPT = 'Y'
     C                   ELSE
     C                   EVAL      DDOPT = 'N'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      DDOPT = ' '
     C                   ENDIF
 
     C                   ADD       1             DDSFRN
     C                   WRITE     GL1242S1
     C                   ENDIF
     C                   ENDIF                                                  /*IN02
     C                   ENDDO
     C
     C                   Z-ADD     DDSFRN        SFLRECN           3 0
      *
      **  Set on the first position
      *
     C                   IF        DDSFRN <> 0
     C                   Z-ADD     1             DDSFRN
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRFILLFRST - Fill The First Account                           *
      * ----------                                                    *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     SRFILLFRST    BEGSR
      *
      **  Set The Error Indic.
      *
     C                   MOVE      *BLANK        VALSFLOK
      *
      **  Build For Full Midas Or Retail?
      *
     C                   MOVE      *BLANK        FOR               1
     C                   SELECT
     C                   WHEN      (INDIC1 = *ON)
     C                   EVAL      FOR = 'F'
     C                   WHEN      (INDIC2 = *ON)
     C                   EVAL      FOR = 'R'
     C                   OTHER
     C                   MOVE      'N'           VALSFLOK
     C                   ENDSL
      *
     C                   DO
      *
     C                   IF        VALSFLOK = 'N'
     C                   LEAVE
     C                   ENDIF
      *
      **  Set The Primary Account (The Keys Are From The First Screen)
      *
     C                   SELECT
      *
     C                   WHEN      (DDACOD = 'I') AND (FOR = 'F')
     C     K#ACCL0       CHAIN     ACCNTL0                            01
      *
     C                   WHEN      (DDACOD = 'E') AND (FOR = 'F') OR
     C                             (DDACOD = 'A') AND (FOR = 'F') OR
     C                             (DDACOD = 'D') AND (FOR = 'F')
     C                   MOVE      'P'           V#PRIM
     C     K#NETL2XP     CHAIN(N)  GLNETGL2                           01
      *
     C                   WHEN      (DDACOD = 'I') AND (FOR = 'R')
     C     DNRETI        CHAIN     ACCNTL1                            01
      *
     C                   WHEN      (DDACOD = 'E') AND (FOR = 'R') OR
     C                             (DDACOD = 'A') AND (FOR = 'R') OR
     C                             (DDACOD = 'D') AND (FOR = 'R')
     C     DNRETI        CHAIN     GLNETGL3                           01
      *
     C                   OTHER
     C                   MOVE      'N'           VALSFLOK
     C                   ENDSL
      *
     C                   IF        (VALSFLOK = 'N') OR (*IN01 = *ON)
      *
     C                   IF        FOR = 'F'
     C**********         MOVE      *BLANK        T#18             18                         BUG2677
     C**********         EVAL      T#18 = DDBRCI + DDCUSI + DDCCYI + DDACOI +                BUG2677
     C**********                   DDSEQI                                                    BUG2677
     C                   MOVE      *BLANK        T#24             24                         BUG2677
     C                   EVAL      T#24 = DDBRCI + DDCUSI + DDCCYI + DDACOI +                BUG2677
     C                             DDSEQI                                                    BUG2677
      *
      **  Account &1 &2 &3 &4 &5 is not an open account
      *
     C                   MOVE      'USR1021'     ZAMSID
     C                   MOVE      *BLANK        ZAMSDA
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   ENDIF
      *
     C                   IF        FOR = 'R'
      *
      **  Retail account number is not valid
      *
     C                   MOVE      'USR1021'     ZAMSID
     C                   MOVE      *BLANK        ZAMSDA
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   ENDIF
      *
     C                   MOVE      'N'           VALSFLOK
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        (DDACOD = 'E') AND (FOR = 'R') OR
     C                             (DDACOD = 'A') AND (FOR = 'R') OR
     C                             (DDACOD = 'D') AND (FOR = 'R')
     C                   IF        (*IN01 = *OFF) AND (L3RWPRIM = 'S')
      *
      **  Retail account number is not valid
      *
     C                   MOVE      'GLM0014'     ZAMSID
     C                   MOVE      *BLANK        ZAMSDA
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
      *
      **  'I'
      *
     C                   IF        (DDACOD = 'I')
     C                   IF        FOR = 'F'
     C                   EVAL      DDBRCS = A0BRCA
     C                   MOVE      *BLANK        T#6
     C                   MOVE      A0CNUM        T#6
     C                   EVAL      DDCUSS = T#6
     C                   EVAL      DDCCYS = A0CCY
     C                   MOVE      *BLANK        T#4
     C                   MOVE      A0ACOD        T#4
     C                   EVAL      DDACOS = T#4
     C                   MOVE      *BLANK        T#2
     C                   MOVE      A0ACSQ        T#2
     C                   EVAL      DDSEQS = T#2
     C                   MOVE      *BLANK        T#10             10
     C                   MOVE      A0ACNO        T#10
     C                   EVAL      DDRETS = T#10
     C                   ENDIF
      *
     C                   IF        FOR = 'R'
     C                   EVAL      DDBRCS = A1BRCA
     C                   MOVE      *BLANK        T#6
     C                   MOVE      A1CNUM        T#6
     C                   EVAL      DDCUSS = T#6
     C                   EVAL      DDCCYS = A1CCY
     C                   MOVE      *BLANK        T#4
     C                   MOVE      A1ACOD        T#4
     C                   EVAL      DDACOS = T#4
     C                   MOVE      *BLANK        T#2
     C                   MOVE      A1ACSQ        T#2
     C                   EVAL      DDSEQS = T#2
     C                   MOVE      *BLANK        T#10
     C                   MOVE      A1ACNO        T#10
     C                   IF        A1ACNO = 0
     C                   EVAL      DDRETS = *BLANK
     C                   ELSE
     C                   EVAL      DDRETS = T#10
     C                   ENDIF
     C                   EVAL      DDCONF = '** UNCONFIRMED **'
     C                   ENDIF
      *
      **  'E', 'A', 'D'
      *
     C                   ELSE
     C                   IF        FOR = 'F'
     C                   EVAL      DDBRCS = L2RWPBRCA
     C                   MOVE      *BLANK        T#6
     C                   MOVE      L2RWPCUST     T#6
     C                   EVAL      DDCUSS = T#6
     C                   EVAL      DDCCYS = L2RWPCCY
     C                   MOVE      *BLANK        T#4
     C                   MOVE      L2RWPACOD     T#4
     C                   EVAL      DDACOS = T#4
     C                   MOVE      *BLANK        T#2
     C                   MOVE      L2RWPACSQ     T#2
     C                   EVAL      DDSEQS = T#2
     C                   MOVE      *BLANK        T#10             10
     C                   MOVE      L2RWPACNO     T#10
     C                   IF        L2RWPACNO = 0
     C                   EVAL      DDRETS = *BLANK
     C                   ELSE
     C                   EVAL      DDRETS = T#10
     C                   ENDIF
     C                   IF        L2RWCONF = 'U'
     C                   EVAL      DDCONF = '** UNCONFIRMED **'
     C                   ELSE
     C                   EVAL      DDCONF = ' ** CONFIRMED ** '
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        FOR = 'R'
     C                   EVAL      DDBRCS = L3RWPBRCA
     C                   MOVE      *BLANK        T#6
     C                   MOVE      L3RWPCUST     T#6
     C                   EVAL      DDCUSS = T#6
     C                   EVAL      DDCCYS = L3RWPCCY
     C                   MOVE      *BLANK        T#4
     C                   MOVE      L3RWPACOD     T#4
     C                   EVAL      DDACOS = T#4
     C                   MOVE      *BLANK        T#2
     C                   MOVE      L3RWPACSQ     T#2
     C                   EVAL      DDSEQS = T#2
     C                   MOVE      *BLANK        T#10             10
     C                   MOVE      L3RWPACNO     T#10
     C                   IF        L3RWPACNO = 0
     C                   EVAL      DDRETS = *BLANK
     C                   ELSE
     C                   EVAL      DDRETS = T#10
     C                   ENDIF
     C                   IF        L2RWCONF = 'U'
     C                   EVAL      DDCONF = '** UNCONFIRMED **'
     C                   ELSE
     C                   EVAL      DDCONF = ' ** CONFIRMED ** '
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRVALIFLD - Validate Input Fields                             *
      * ---------                                                     *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     SRVALIFLD     BEGSR
      *
     C                   DO
      *
      **  Setting Up - Begin
      *
     C                   MOVE      *BLANK        VALSFLOK
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN32
     C                   MOVE      *OFF          *IN33
     C                   MOVE      *OFF          *IN34
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          INDIC1
     C                   MOVE      *OFF          INDIC2
     C                   MOVE      *OFF          INDIC3
     C                   MOVE      *OFF          INDIC4
      *
      **  Protect Field All/RE
      *
     C                   IF        (DDACOD = 'D') OR (DDACOD = 'E')
     C                   MOVE      *BLANK        DDALRI
     C                   ELSE
     C                   MOVE      *OFF          *IN38
     C                   ENDIF
      *
      **  Are GL Account Included In RWA Calculations?
      *
     C                   IF        (DDACOD = 'I') OR (DDACOD = 'A')
     C                   EVAL      P@OP01 = 'RiskWeightAssetIncGL'
     C                   CALLB     'AOSVALR0'
     C                   PARM      *BLANK        P@RTCD            7
     C                   PARM                    P@OP01           20
     C                   PARM      *BLANK        P@VL01          200
     C                   PARM      *BLANK        P@OP02           20
     C                   PARM      *BLANK        P@VL02          200
     C                   PARM      *BLANK        P@OP03           20
     C                   PARM      *BLANK        P@VL03          200
     C                   PARM      *BLANK        P@OP04           20
     C                   PARM      *BLANK        P@VL04          200
     C                   PARM      *BLANK        P@OP05           20
     C                   PARM      *BLANK        P@VL05          200
     C                   PARM      *BLANK        P@OP06           20
     C                   PARM      *BLANK        P@VL06          200
     C                   PARM      *BLANK        P@OP07           20
     C                   PARM      *BLANK        P@VL07          200
     C                   PARM      *BLANK        P@OP08           20
     C                   PARM      *BLANK        P@VL08          200
     C                   PARM      *BLANK        P@OP09           20
     C                   PARM      *BLANK        P@VL09          200
     C                   PARM      *BLANK        P@OP10           20
     C                   PARM      *BLANK        P@VL10          200
      *
      **  Contact Misys: file SDSVALPD not set up for CGL018
      *
     C                   IF        P@RTCD <> *BLANK
     C                   MOVE      'USR9383'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   ENDIF
      *
     C                   IF        %SUBST(P@VL01:1:1) = 'N'
     C                   MOVE      *BLANK        DDALRI
     C                   MOVE      *ON           *IN36
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        (DDBRCI <> *BLANK) OR
     C                             (DDCUSI <> *BLANK) OR
     C                             (DDCCYI <> *BLANK) OR
     C                             (DDACOI <> *BLANK) OR
     C                             (DDSEQI <> *BLANK)
     C                   MOVE      *ON           INDIC1
     C                   ENDIF
      *
     C                   IF        (DDRETI <> *BLANK)
     C                   MOVE      *ON           INDIC2
     C                   ENDIF
      *
     C                   IF        (DDBRCR <> *BLANK) OR
     C                             (DDCUSR <> *BLANK) OR
     C                             (DDCCYR <> *BLANK) OR
     C                             (DDACOR <> *BLANK) OR
     C                             (DDSEQR <> *BLANK)
     C                   MOVE      *ON           INDIC3
     C                   ENDIF
      *
     C                   IF        (DDRETR <> *BLANK)
     C                   MOVE      *ON           INDIC4
     C                   ENDIF
      *
      **  Setting Up - End
      *
      **  Checking - Begin
      *
     C                   IF        INDIC1 = *ON
     C                   IF        (DDBRCI = *BLANK) OR
     C                             (DDCUSI = *BLANK) OR
     C                             (DDCCYI = *BLANK) OR
     C                             (DDACOI = *BLANK) OR
     C                             (DDSEQI = *BLANK)
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN31
     C                   ITER
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        INDIC1 = *ON AND INDIC2 = *ON
      *
      **  Only Account Ref. No. or Retail Number can be entered
      *
     C                   MOVE      'USR1005'     ZAMSID
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN31
     C                   MOVE      *ON           *IN32
     C                   ITER
     C                   ENDIF
      *
     C                   IF        INDIC3 = *ON AND INDIC4 = *ON
      *
      **  If Review From is entered Retail Number must be blank
      *
     C                   MOVE      'USR1007'     ZAMSID
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN33
     C                   MOVE      *ON           *IN34
     C                   ITER
     C                   ENDIF
      *
     C                   IF        *IN36 = *OFF
     C                   IF        (DDACOD = 'I') OR (DDACOD = 'A')
     C                   IF        DDALRI <> 'RE ' AND DDALRI <> 'ALL'
     C                   MOVE      *BLANK        T#10
     C                   MOVEL     'REALL'       T#10
      *
      **  Select 'RE' or 'ALL'
      *
     C                   MOVE      'USR1015'     ZAMSID
     C                   MOVE      *blanks       ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN35
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        DDRETI <> *BLANK
     C     C#NUM         CHECK     DDRETI                                 01
     C                   IF        *IN01 = *ON
      *
      **  Retail account number is not valid
      *
     C                   MOVE      'GLM0014'     ZAMSID
     C                   MOVE      *BLANK        ZAMSDA
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   ITER
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        DDRETR <> *BLANK
     C     C#NUM         CHECK     DDRETR                                 01
     C                   IF        *IN01 = *ON
      *
      **  Retail account number is not valid
      *
     C                   MOVE      'GLM0014'     ZAMSID
     C                   MOVE      *BLANK        ZAMSDA
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   ITER
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        (DDACOD = 'I') AND
     C                             (INDIC1 = *ON)
     C                   MOVE      *BLANK        V#ACC
     C                   MOVE      DDBRCI        V#BRC
     C**********         Z-ADD     DNCUSI        V#CUSN                                       CSD027
     C                   EVAL      V#CUSN = DNCUSI                                            CSD027
     C                   MOVE      DDCCYI        V#CCY
     C                   Z-ADD     DNACOI        V#ACON
     C                   Z-ADD     DNSEQI        V#ACSN
     C                   MOVE      *ON           *IN03
     C                   EXSR      SRCHKINS
     C                   IF        *IN03 = *OFF
     C                   MOVE      *ON           *IN31
     C                   MOVE      'N'           VALSFLOK
     C                   ITER
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        (DDACOD = 'I') AND
     C                             (INDIC2 = *ON)
     C     DNRETI        CHAIN     ACCNTL1                            01
      *
      **  Retail account number is not valid
      *
     C                   IF        *IN01 = *ON
     C                   MOVE      'GLM0014'     ZAMSID
     C                   MOVE      *BLANK        ZAMSDA
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   MOVE      *ON           *IN32
     C                   MOVE      'N'           VALSFLOK
     C                   ITER
     C                   ENDIF
      *
     C                   MOVE      *BLANK        V#ACC
     C                   MOVE      A1BRCA        V#BRC
     C**********         Z-ADD     A1CNUM        V#CUSN                                       CSD027
     C                   EVAL      V#CUSN = A1CNUM                                            CSD027
     C                   MOVE      A1CCY         V#CCY
     C                   Z-ADD     A1ACOD        V#ACON
     C                   Z-ADD     A1ACSQ        V#ACSN
     C                   MOVE      *ON           *IN03
     C                   EXSR      SRCHKINS
     C                   IF        *IN03 = *OFF
     C                   MOVE      *ON           *IN32
     C                   MOVE      'N'           VALSFLOK
     C                   ITER
     C                   ENDIF
     C                   ENDIF
      *
      **  Checking - End
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRWRIINS - WRITE AN RECORDS                                   *
      *****************************************************************
      *
     C     SRWRIINS      BEGSR
      *
      **  Set of indicators and variables
      *
     C                   IF        F9PRESSED <> 'Y'
     C                   Z-ADD     1             DDSFRN
     C                   MOVE      *OFF          *IN01
      *
      **  Write The Primary Account
      *
     C                   EVAL      L0RWRECI  = *BLANK
     C                   EVAL      L0RWPRIM  = 'P'
      *
     C                   EVAL      L0RWBRCA  = DDBRCS
     C                   EVAL      L0RWPBRCA = DDBRCS
     C                   MOVE      DDCUSS        L0RWCUST
     C                   MOVE      DDCUSS        L0RWPCUST
     C                   EVAL      L0RWCCY   = DDCCYS
     C                   EVAL      L0RWPCCY  = DDCCYS
     C                   MOVE      DDACOS        L0RWACOD
     C                   MOVE      DDACOS        L0RWPACOD
     C                   MOVE      DDSEQS        L0RWACSQ
     C                   MOVE      DDSEQS        L0RWPACSQ
     C                   IF        DDRETS = *BLANK
     C                   Z-ADD     0             L0RWACNO
     C                   Z-ADD     0             L0RWPACNO
     C                   ELSE
     C                   MOVE      DDRETS        L0RWACNO
     C                   MOVE      DDRETS        L0RWPACNO
     C                   ENDIF
      *
     C                   EVAL      L0RWCHTP  = 'I'
     C                   EVAL      L0RWPBAL  = 0
     C                   EVAL      L0RWSBAL  = 0
     C                   EVAL      L0RWCONF  = 'U'
     C                   EVAL      L0RWLCD   = AGRDNB
     C                   WRITE     GLNETGD0                             01
      *
     C                   IF        *IN01 = *ON
     C                   MOVE      'GLNETGL0'    DBFILE                         ***************
     C                   Z-ADD     2             DBASE                          * DB ERROR 02 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDIF
      *
      **  Write The Secondary Accounts
      **  Subfile read cycle
      *
     C                   EVAL      ConfFlag = *blank
     C                   DO        SFLRECN
     C     DDSFRN        CHAIN     GL1242S1                           01
     C
     C                   IF        *IN01 = *OFF
      *
     C                   IF        (DDOPT = 'Y')
     C                             or DDOPT = *blank and DDALRI = 'RE '
     C                   MOVE      *BLANK        L0RWRECI
      *
     C                   MOVE      *BLANK        V#ACC
     C                   MOVE      DDACC2        V#ACC
     C                   MOVE      *ON           *IN03
     C                   EXSR      SRCHECKDU
      *
     C                   IF        *IN03 = *ON
     C                   EVAL      L0RWPRIM = 'S'
     C                   EVAL      L0RWBRCA = V#BRC
     C                   EVAL      L0RWCUST = V#CUSN
     C                   EVAL      L0RWCCY  = V#CCY
     C                   EVAL      L0RWACOD = V#ACON
     C                   EVAL      L0RWACSQ = V#ACSN
     C                   MOVE      DDRET2        L0RWACNO
     C                   EVAL      L0RWPBRCA = DDBRCS
     C                   MOVE      DDCUSS        L0RWPCUST
     C                   EVAL      L0RWPCCY  = DDCCYS
     C                   MOVE      DDACOS        L0RWPACOD
     C                   MOVE      DDSEQS        L0RWPACSQ
      *
     C                   IF        DDRETS = *BLANK
     C                   Z-ADD     0             L0RWPACNO
     C                   ELSE
     C                   MOVE      DDRETS        L0RWPACNO
     C                   ENDIF
      *
     C                   EVAL      L0RWCHTP  = 'I'
     C                   EVAL      L0RWPBAL  = 0
     C                   EVAL      L0RWSBAL  = 0
     C                   EVAL      L0RWCONF  = 'C'
     C                   EVAL      ConfFlag = 'Y'
     C                   EVAL      L0RWLCD   = AGRDNB
     C                   WRITE     GLNETGD0                             01
      *
     C                   IF        *IN01 = *ON
     C                   MOVE      'GLNETGL0'    DBFILE                         ***************
     C                   Z-ADD     3             DBASE                          * DB ERROR 03 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ADD       1             DDSFRN
     C                   ENDDO
      *
      **  If secondary a/c selected confirm the primary account
      *
     C                   IF        ConfFlag = 'Y'
     C     K#NETL2X      CHAIN     GLNETGL2                           01
     C                   IF        *IN01 = *off
     C                   EVAL      L2RWCONF = 'C'
     C                   UPDATE    GLNETGD2
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      *BLANK        F9PRESSED
     C                   COMMIT
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRDEL - DELETE NETTING GROUP                                  *
      *****************************************************************
      *
     C     SRDEL         BEGSR
      *
     C                   MOVE      *OFF          *IN01
      *
      **  Delete The Netting Group By Primary Account Key
      *
     C                   MOVE      DDBRCS        DDBRCR
     C                   MOVE      DDCUSS        DNCUSR
     C                   MOVE      DDCCYS        DDCCYR
     C                   MOVE      DDACOS        DNACOR
     C                   MOVE      DDSEQS        DNSEQR
     C     K#NETL2       SETLL     GLNETGD2
      *
     C                   DOW       *IN01 = *OFF
     C     K#NETL2       READE     GLNETGD2                               01
      *
     C                   IF        *IN01 = *ON
     C                   ITER
     C                   ENDIF
      *
     C                   DELETE    GLNETGD2                             02
      *
     C                   IF        *IN02 = *ON
     C                   MOVE      'GLNETGL2'    DBFILE                         ***************
     C                   Z-ADD     4             DBASE                          * DB ERROR 04 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
     C                   ENDDO
      *
      **  Clear Fields On The First Screen
      *
     C                   MOVE      *BLANK        DDBRCI
     C                   MOVE      *BLANK        DDCUSI
     C                   MOVE      *BLANK        DDCCYI
     C                   MOVE      *BLANK        DDACOI
     C                   MOVE      *BLANK        DDSEQI
     C                   MOVE      *BLANK        DDRETI
     C                   MOVE      *BLANK        DDBRCR
     C                   MOVE      *BLANK        DDCUSR
     C                   MOVE      *BLANK        DDCCYR
     C                   MOVE      *BLANK        DDACOR
     C                   MOVE      *BLANK        DDSEQR
     C                   MOVE      *BLANK        DDRETR
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRWRIAMD - AMEND NETTING GROUP ACCOUNTS                       *
      *****************************************************************
      *
     C     SRWRIAMD      BEGSR
      *
      **  Set Of Primary Account
      *
     C                   IF        MODE = 'P'
     C                   MOVE      *BLANK        VALSFLOK
     C                   Z-ADD     1             DDSFRN
     C                   MOVE      'N'           V#RCS1            1
     C                   MOVE      *OFF          *IN01
     C                   Z-ADD     0             V#PSI
     C                   MOVE      'N'           PRIMACC           1
      *
      **  Subfile read cycle
      *
     C                   DO        SFLRECN
     C     DDSFRN        CHAIN     GL1242S1                           01
     C                   IF        *IN01 = *OFF
      *
     C                   IF        DDOPT = 'P'
     C                   MOVE      'Y'           PRIMACC
      *
      **  Which Secondary Account?
      *
     C                   MOVE      *BLANK        V#ACC
     C                   MOVE      DDACC2        V#ACC
     C                   MOVE      V#BRC         S#BRC             3
     C**********         Z-ADD     V#CUSN        S#CUSN            6 0                        CSD027
     C                   MOVE      V#CUSN        S#CUSN            6                          CSD027
     C                   MOVE      V#CCY         S#CCY             3
     C**********         Z-ADD     V#ACON        S#ACON            4 0                        CGL029
     C                   Z-ADD     V#ACON        S#ACON                                       CGL029
     C                   Z-ADD     V#ACSN        S#ACSN            2 0
     C                   MOVE      DDRET2        S#RET2           10 0
      *
      **  Set Accesible Key
      *
     C                   MOVE      DDBRCS        DDBRCI
     C                   MOVE      DDCUSS        DNCUSI
     C                   MOVE      DDCCYS        DDCCYI
     C                   MOVE      DDACOS        DNACOI
     C                   MOVE      DDSEQS        DNSEQI
     C                   LEAVE
     C                   ENDIF
     C                   ADD       1             DDSFRN
     C                   ENDIF
     C                   ENDDO
      *
      **  Process In Database
      *
     C                   Z-ADD     1             DDSFRN
     C                   IF        PRIMACC = 'Y'
     C                   MOVE      *OFF          *IN01
     C     K#NETL2X      SETLL     GLNETGL2
      *
     C                   DOW       *IN01 = *OFF
     C     K#NETL2X      READE     GLNETGL2                               01
      *
     C                   IF        *IN01 = *OFF
      *
     C                   IF        L2RWBRCA = S#BRC  AND
     C                             L2RWCUST = S#CUSN AND
     C                             L2RWCCY  = S#CCY  AND
     C                             L2RWACOD = S#ACON AND
     C                             L2RWACSQ = S#ACSN
      *
      **  Change To New Primary Account
      *
     C                   MOVE      'P'           L2RWPRIM
     C                   EVAL      L2RWPBRCA = S#BRC
     C                   EVAL      L2RWPCUST = S#CUSN
     C                   EVAL      L2RWPCCY  = S#CCY
     C                   EVAL      L2RWPACOD = S#ACON
     C                   EVAL      L2RWPACSQ = S#ACSN
     C                   EVAL      L2RWPACNO = S#RET2
     C                   EVAL      L2RWCONF  = 'C'
     C                   EVAL      L2RWCHTP  = 'A'
     C                   EVAL      L2RWLCD   = AGRDNB
     C                   UPDATE    GLNETGD2                             02
      *
     C                   IF        *IN02 = *ON
     C                   MOVE      'GLNETGL2'    DBFILE                         ***************
     C                   Z-ADD     5             DBASE                          * DB ERROR 05 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
      *
     C                   ELSE
      *
      **  Change To Secondary Account
      *
     C                   MOVE      'S'           L2RWPRIM
     C                   EVAL      L2RWPBRCA = S#BRC
     C                   EVAL      L2RWPCUST = S#CUSN
     C                   EVAL      L2RWPCCY  = S#CCY
     C                   EVAL      L2RWPACOD = S#ACON
     C                   EVAL      L2RWPACSQ = S#ACSN
     C                   EVAL      L2RWPACNO = S#RET2
     C                   EVAL      L2RWCONF  = 'C'
     C                   EVAL      L2RWCHTP  = 'A'
     C                   EVAL      L2RWLCD   = AGRDNB
     C                   UPDATE    GLNETGD2                             02
      *
     C                   IF        *IN02 = *ON
     C                   MOVE      'GLNETGL2'    DBFILE                         ***************
     C                   Z-ADD     6             DBASE                          * DB ERROR 06 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
     C                   MOVE      *ON           REDISP
     C                   ENDIF
      *
      **  Set Fields On The First Screen
      *
     C                   MOVE      V#BRC         DDBRCI
     C                   MOVE      V#CUSC        DDCUSI
     C                   MOVE      V#CCY         DDCCYI
     C                   MOVE      V#ACOC        DDACOI
     C                   MOVE      V#ACSC        DDSEQI
      *
     C                   ENDIF
      *
      **  Confirm or delete secondary accounts
      *
     C                   IF        MODE = 'S'
     C                   Z-ADD     1             DDSFRN
     C                   MOVE      *OFF          *IN01
     C                   EVAL      ConfFlag = *blank
      *
      **  Subfile read cycle
      *
     C                   DO        SFLRECN
     C     DDSFRN        CHAIN     GL1242S1                           01
     C
     C                   IF        *IN01 = *OFF
      *
     C                   MOVE      *BLANK        V#ACC
     C                   MOVE      DDACC2        V#ACC
     C     K#GLNETL      CHAIN     GLNETGD0                           02
     C                   IF        *IN02 = *OFF
 
     C                   IF        DDOPT = 'N'
     C                             or DDOPT = *blank and DDALRI = 'ALL'
     C                   DELETE    GLNETGD0                             03
     C                   ELSE
     C                   EVAL      L0RWCONF = 'C'
     C                   EVAL      L0RWCHTP  = 'A'
     C                   EVAL      L0RWLCD   = AGRDNB
     C                   UPDATE    GLNETGD0                             03
     C                   EVAL      ConfFlag = 'Y'
     C                   ENDIF
      *
     C                   IF        *IN03 = *ON
     C                   MOVE      'GLNETGL0'    DBFILE                         ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ADD       1             DDSFRN
      *
     C                   ENDDO
 
      ** If secondary account(s) selected or deleted, record the change
      ** on the primary account.
     C     K#NETL2X      CHAIN     GLNETGL2                           02
     C                   IF        *IN02 = *off
 
      ** If secondary account(s) selected confirm the primary account
     C                   IF        ConfFlag = 'Y'
     C                   EVAL      L2RWCONF = 'C'
     C                   ENDIF
     C                   EVAL      L2RWCHTP  = 'A'
     C                   EVAL      L2RWLCD   = AGRDNB
     C                   UPDATE    GLNETGD2
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        SFLRECN <> 0
     C                   EVAL      DDSFRN = 1
     C                   ENDIF
      *
     C                   COMMIT
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRADDACC - ADD ACCOUNTS INTO SFL                              *
      *****************************************************************
      *
     C     SRADDACC      BEGSR
      *
      **  Read Open Customer Accounts On System (Avoid A Double Counting ACCNTAB) -> 'N'
      *
     C                   EVAL      DDSFRN = SFLRECN
     C                   MOVE      *OFF          *IN01
     C**********         Z-ADD     0             K#CNUM                                       CSD027
     C                   EVAL      K#CNUM = *BLANKS                                           CSD027
     C                   MOVE      DDCUSS        K#CNUM
     C                   MOVE      DDCCYS        K#CCY
     C     K#ACCL03      SETLL     ACCNTL0
      *
     C     *IN01         DOWEQ     *OFF
     C     K#ACCL03      READE     ACCNTL0                                01
      *
     C                   IF        (*IN01 = *OFF) AND (A0RECI = 'D')
     C                   MOVE      *ON           *IN03
      *
      **  Select All Accounts Or Only Retail Accounts
      *
     C                   IF        (DDALRI <> 'ALL') AND
     C                             (A0ATYP <> 'R')
     C                   MOVE      *OFF          *IN03
     C                   ENDIF
      *
      **  Avoid A Double Counting
      *
     C     *IN03         IFEQ      *ON
     C                   EXSR      AVOIDAC
     C                   ENDIF
      *
      **  If *In03 *On (Record is valid) Record is written to SFL
      *
     C     *IN03         IFEQ      *ON
     C                   MOVE      *BLANK        T#6               6
     C                   MOVE      A0CNUM        T#6
     C**********         MOVE      *BLANK        T#4               4                          CGL029
     C                   MOVE      *BLANK        T#4                                          CGL029
     C                   MOVE      A0ACOD        T#4
     C                   MOVE      *BLANK        T#2               2
     C                   MOVE      A0ACSQ        T#2
     C                   MOVE      *OFF          *IN47
     C                   EVAL      DDACC2 = A0BRCA + '-' + T#6 + '-' + A0CCY +
     C                             '-' + T#4 + '-' + T#2
     C                   MOVE      *BLANK        DDRET2
      *
     C                   IF        A0ACNO <> 0
     C                   MOVE      A0ACNO        DDRET2
     C                   ENDIF
      *
     C                   MOVEL(P)  A0ANAM        DDACN2
     C                   MOVE      'N'           DDYN2B
      *
     C                   IF        (DDALRI = 'ALL')
     C                   MOVE      'N'           DDOPT
     C                   ELSE
     C                   MOVE      'Y'           DDOPT
     C                   ENDIF
      *
     C                   MOVE      'S'           DDPS2
     C                   MOVE      'S'           DDPS2B
     C                   ADD       1             DDSFRN
     C                   WRITE     GL1242S1
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C
     C                   Z-ADD     DDSFRN        SFLRECN           3 0
      *
      **  Set on the first position
      *
     C                   IF        DDSFRN <> 0
     C                   Z-ADD     1             DDSFRN
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * AVOIDAC - Avoid A Double Counting                             *
      *****************************************************************
      *
     C     AVOIDAC       BEGSR
      *
     C                   MOVE      *OFF          *IN04
     C     K#GL2S        SETLL     GLNETGL1
      *
     C                   DOW       *IN04 = *OFF
     C     K#GL2S        READE     GLNETGL1                               04
      *
     C                   IF        (*IN04 = *OFF)
     C                   MOVE      *OFF          *IN03
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRCHECKDU - Check If Account Exist - Avoid Double Counting    *
      * ----------                                                    *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     SRCHECKDU     BEGSR
      *
     C                   MOVE      *OFF          *IN01
     C     K#GLNETL      SETLL     GLNETGL1
      *
     C                   DOW       *IN01 = *OFF
     C     K#GLNETL      READE     GLNETGL1                               01
      *
     C                   IF        *IN01 = *OFF
      *
      **  Is The Same Primary Account?
      *
     C                   MOVE      *BLANK        T#6
     C                   MOVE      L1RWPCUST     T#6
     C                   MOVE      *BLANK        T#4
     C                   MOVE      L1RWPACOD     T#4
     C                   MOVE      *BLANK        T#2
     C                   MOVE      L1RWPACSQ     T#2
      *
     C                   IF        DDBRCS = L1RWPBRCA AND
     C                             DDCUSS = T#6       AND
     C                             DDCCYS = L1RWPCCY  AND
     C                             DDACOS = T#4       AND
     C                             DDSEQS = T#2
     C                   MOVE      *OFF          *IN03
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRVALINS - Validate Insert                                    *
      * --------                                                      *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     SRVALINS      BEGSR
      *
      **  Set of indicators and variables
      *
     C                   MOVE      *BLANK        VALSFLOK
     C                   Z-ADD     1             DDSFRN
     C                   MOVE      'N'           V#RCS1            1
     C                   MOVE      *OFF          *IN01
     C                   Z-ADD     0             V#PSI
     C                   Z-ADD     0             V#DEL             4 0
      *
      **  Subfile read cycle
      *
     C                   DO        SFLRECN
     C     DDSFRN        CHAIN     GL1242S1                           01
     C
     C                   IF        *IN01 = *OFF
      *
      **  Save Action code to variable
      *
     C                   MOVE      DDOPT         V#ACT1            1
      *
      **  Validate option
      *
     C                   IF        (DDOPT <> 'Y')    AND
     C                             (DDOPT <> 'N')    AND
     C                             (DDOPT <> *BLANK)
      *
      **  Y or N must be entered
      *
     C                   MOVE      'USR0912'     ZAMSID
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN46
     C                   ELSE
     C                   MOVE      *OFF          *IN46
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN47
      *
     C                   IF        (DDOPT = 'Y')  AND
     C                             (DDYN2B = 'N')
     C                   MOVE      *BLANK        V#ACC
     C                   MOVE      DDACC2        V#ACC
     C                   MOVE      *ON           *IN03
     C                   EXSR      SRCHKINS
     C                   IF        *IN03 = *OFF
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN47
     C                   ENDIF
     C                   ENDIF
      *
     C                   UPDATE    GL1242S1
     C                   ADD       1             DDSFRN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   IF        SFLRECN <> 0
     C                   EVAL      DDSFRN = 1
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRCHKINS  - Check If Account Exist In Netting Accounts        *
      * ----------                                                    *
      * CALLED BY:                                                    *
      * CALLS: NONE                                                   *
      *****************************************************************
      *
     C     SRCHKINS      BEGSR
      *
     C     K#GLNETL      CHAIN(N)  GLNETGL2                           03        Primary Acc
      *
     C                   IF        *IN03 = *OFF
                                                                                             BUG2677
     C**********         MOVE      *BLANK        T#36             36                         BUG2677
     C**********         EVAL      T#36 = V#BRC + V#CUSC + V#CCY + V#ACOC +                  BUG2677
     C**********                   V#ACSC + L1RWPBRCA + T#6 + L1RWPCCY + T#4 +               BUG2677
     C**********                   T#2                                                       BUG2677
     C                   MOVE      *BLANK        T#48             48                         BUG2677
     C                   EVAL      T#48 = V#BRC + V#CUSC + V#CCY + V#ACOC +                  BUG2677
     C                             V#ACSC + L1RWPBRCA + T#6 + L1RWPCCY + T#4 +               BUG2677
     C                             T#2                                                       BUG2677
     C                   ENDIF
      *
     C                   IF        *IN03 = *ON
     C     K#GLNETL      CHAIN     GLNETGL1                           03        Secondary Acc
      *
     C                   IF        *IN03 = *OFF
     C**********         MOVE      *BLANK        T#36             36                         BUG2677
     C**********         EVAL      T#36 = V#BRC + V#CUSC + V#CCY + V#ACOC +                  BUG2677
     C**********                   V#ACSC + L1RWPBRCA + T#6 + L1RWPCCY + T#4 +               BUG2677
     C**********                   T#2                                                       BUG2677
     C                   MOVE      *BLANK        T#48             48                         BUG2677
     C                   EVAL      T#48 = V#BRC + V#CUSC + V#CCY + V#ACOC +                  BUG2677
     C                             V#ACSC + L1RWPBRCA + T#6 + L1RWPCCY + T#4 +               BUG2677
     C                             T#2                                                       BUG2677
     C                   ENDIF
     C                   ENDIF
      *
      **  a/c &1&2&3&4&5 has already been selected as part of netting group for a/c &6&7&8&9&10
      *
     C                   IF        *IN03 = *OFF
     C                   MOVE      'USR1010'     ZAMSID
     C**********         MOVEL(P)  T#36          ZAMSDA                                      BUG2677
     C                   MOVEL(P)  T#48          ZAMSDA                                      BUG2677
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRVALAMD - AMEND NETTING GROUP ACCOUNTS                       *
      *****************************************************************
      *
     C     SRVALAMD      BEGSR
      *
     C                   MOVE      *BLANK        VALSFLOK
     C                   Z-ADD     1             DDSFRN
     C                   MOVE      'N'           V#RCS1            1
     C                   MOVE      *OFF          *IN01
     C                   Z-ADD     0             V#PSI             4 0
     C                   Z-ADD     0             V#YNI             4 0
     C                   MOVE      'N'           PRIMACC           1
      *
      **  Subfile read cycle
      *
     C                   DO        SFLRECN
     C     DDSFRN        CHAIN     GL1242S1                           01
      *
     C                   IF        *IN01 = *OFF
      *
      **  Selection must be Y (include), N (exclude) or P (primary)
      *
     C                   IF        (DDOPT <> 'N') AND
     C                             (DDOPT <> 'P') AND
     C                             (DDOPT <> 'Y') AND
     C                             (DDOPT <> *BLANK)
     C                   MOVE      'USR1020'     ZAMSID
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN46
     C                   ELSE
     C                   MOVE      *OFF          *IN46
     C                   ENDIF
      *
      **  Only one primary account can be selected
      *
     C                   IF        (DDOPT = 'P')
      *
      **  Disable And Turn Off F9 Key
      *
     C                   MOVE      *OFF          *INKI
     C                   MOVE      *ON           *IN27
      *
     C                   IF        V#PSI >= 1
     C                   MOVE      'USR1012'     ZAMSID
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN46
     C                   ELSE
     C                   ADD       1             V#PSI
     C                   MOVE      *OFF          *IN46
     C                   ENDIF
     C                   ENDIF
      *
      **  Confirm delete by pressing F10
      *
     C                   IF        (DDOPT = 'N')
      *
     C                   IF        (*IN48 = *OFF)
     C                   MOVE      'CSF9101'     ZAMSID
     C                   MOVE      *BLANK        ZAMSGF
     C                   EXSR      SRSENDMSG
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN48
     C                   ENDIF
      *
     C                   ADD       1             V#YNI
     C                   ENDIF
 
     C                   IF        DDOPT = 'Y'
     C                   ADD       1             V#YNI
     C                   ENDIF
      *
     C                   UPDATE    GL1242S1
     C                   ADD       1             DDSFRN
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        SFLRECN <> 0
     C                   EVAL      DDSFRN = 1
     C                   ENDIF
      *
     C                   IF        V#PSI >= 1
     C                   MOVE      'P'           MODE
     C                   ELSE
     C                   IF        V#YNI >= 1
     C                   MOVE      'S'           MODE
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRCHKSFL -                                                    *
      *****************************************************************
      *
     C     SRCHKSFL      BEGSR
      *
     C                   MOVE      *BLANK        VALSFLOK
     C                   Z-ADD     1             DDSFRN
     C                   MOVE      *OFF          *IN01
      *
      **  Subfile read cycle
      *
     C                   DO        SFLRECN
     C     DDSFRN        CHAIN     GL1242S1                           01
      *
     C                   IF        *IN01 = *OFF
      *
     C                   MOVE      *OFF          *IN46
     C                   IF        (DDOPT <> *BLANK)
     C                   MOVE      'N'           VALSFLOK
     C                   MOVE      *ON           *IN46
     C                   ENDIF
      *
     C                   UPDATE    GL1242S1
     C                   ADD       1             DDSFRN
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        SFLRECN <> 0
     C                   EVAL      DDSFRN = 1
     C                   ENDIF
      *
     C                   ENDSR
