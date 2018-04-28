     H DEBUG
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                       CGL120
/*STD *  RPGBASEBNC                                                   *                       CGL120
/*EXI *  TEXT('Midas GL Account balances extract - delete')           *
     F*****************************************************************
     F*                                                               *
     F*  Midas - General Ledger Module                                *
     F*                                                               *
     F*  GL3320D - ACCOUNT BALANCES EXTRACT - DELETE                  *
     F*                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD020565           Date 21May13               *
      *  Prev Amend No. CGL142             Date 06Aug12               *
      *                 CGL120             Date 20Sep10               *
      *                 CER049             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239118             Date 12Jun06               *
      *                 BUG7967            Date 26May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG4615            Date 26Oct04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 11Sep03               *
      *                 217910             Date 30May03               *
      *                 CGL018             Date 30Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 03Apr00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 25Aug00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 142089             Date 01Mar00               *
     F*                 171107             Date 22NOV99               *
     F*                 164290             Date 20Oct99               *
     F*                 149193             Date 20Oct99               *
     F*                 137916             Date 20Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                 CRE001             Date 20Feb97               *
     F*                 S01413             Date 13Apr93               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD020565 - GLREACRZ record locking on GLC3320 Task Split     *
      *  CGL142 - Tactical COB changes GL                             *
      *  CGL120 - GL COB Components Task Split                        *
      *         - Incorporate 260271A                                 *
      *         - Incorporate 260271                                  *
      *         - Incorporate CGL102                                  *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *  239118 - Update PBUDCPH trailer upon deletion of PBUDCPD     *
      *           record.                                             *
      *  BUG7967 - Update Trailer file to contain correct number of   *
      *            records. (note: BUG4615 was applied to OCBC as     *
      *            7967 - then was reopened as requiring addtl fix.   *
      *            7967 code here is that additional (reopen) codes)  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG4615 - Purge Cheque book details linked to accounts       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global processing.  Change to file key.             *
      *  217910 - Show retail account on postings (CRE008 fix)        *
      *  CGL018 - Risk Weighted Assets                                *
      *  CDE002 - Retail Account Margin History Update.               *
     F*  CPB002 - Meridian DBA Middleware Replication Customization.  *
     F*           (Recompiled)                                        *
     F*  142089 - Housekeeping on file RECIEUPD added for CEU025      *
     F*  171107 - Delete of ACCNTBXC doesn't only apply if CRE001 *ON *
     F*  164290 - Delete records for closed and deleted accounts from *
     F*           REAPWDPD.                                           *
     F*  149193 - Removal of postings from MEMOS file as for other    *
     F*           files in this program.                              *
     F*  137916 - Added a parameter (ACNO) when calling GL3320D       *
     F*           to update PBUDCPD when dropping records for         *
     F*           closed accounts                                     *
     F*  CRE001 - Overdraft Interest Calculation                      *
     F*  S01413 - Retail 3 Incorporation                              *
     F*                                                               *
     F*****************************************************************
     FREACR     UF   E           K DISK    INFSR(INFSR)
     F                                     IGNORE(REACRZF)                                    CGL142
     F                                     COMMIT                                             CGL120
     F***GLREACRZ  UF A E           K DISK    INFSR(INFSR)                           CGL142 MD020565
     FGLREACRZ  O    E           K DISK    INFSR(INFSR)                                     MD020565
     F                                     COMMIT                                             CGL142
     FREHISL    UF   E           K DISK    INFSR(INFSR)
     F                                     COMMIT                                             CGL120
     FREHPOPL   UF   E           K DISK    INFSR(INFSR)
     F                                     COMMIT                                             CGL120
     FRECOM     UF   E           K DISK    INFSR(INFSR)
     F                                     COMMIT                                             CGL120
     FREHPOML2  UF   E           K DISK    INFSR(INFSR)
     F                                     COMMIT                                             CGL120
     FREHPOSRL  UF   E           K DISK    INFSR(INFSR)
     F                                     COMMIT                                             CGL120
     FPBUDCPD   UF   E           K DISK    INFSR(INFSR)                         137916
     F                                     COMMIT                                             CGL120
      * Gl Account Master Core Extension                                  CRE001
     FACCNTBXC  UF   E           K DISK    INFSR(INFSR)                         CRE001
     F                                     COMMIT                                             CGL120
     F/COPY WNCPYSRC,GLH00734
      * Retail OverDraft History by Account/Date.                         CRE001
     FREODHSL0  UF   E           K DISK    INFSR(INFSR)                         CRE001
     F                                     COMMIT                                             CGL120
     F/COPY WNCPYSRC,GLH00735
     FMEMOSL1   UF   E           K DISK    INFSR(INFSR)                         149193
     F                                     COMMIT                                             CGL120
     F/COPY WNCPYSRC,GLH00736
     F*REAPWDPDUF*E****       K        DISK         KINFSR INFSR                       164290 CGP001
     FREAPWDL0  UF   E           K DISK    INFSR(INFSR)                                       CGP001
     F                                     COMMIT                                             CGL120
     F/COPY WNCPYSRC,GLH00737
      * Midas RE retail account password.                                 164290
     F***RECIEUL1UF**E        K        DISK         KINFSR INFSR   142089 217910
     FRECIEUL2  UF   E           K DISK    INFSR(INFSR)                         217910
     F                                     COMMIT                                             CGL120
     F/COPY WNCPYSRC,GLH00738
     FREHMRGL0  UF   E           K DISK    INFSR(INFSR)                         CDE002
     F                                     COMMIT                                             CGL120
     F/COPY WNCPYSRC,GLH00739
      *                                                                                      BUG4615
      ** Cheque book details file                                                            BUG4615
     FCHQBKL1   UF   E           K DISK    INFSR(INFSR)                                      BUG4615
     F                                     COMMIT                                             CGL120
     F/COPY WNCPYSRC,GLH00740
     FPBUDCPH   UF   E           K DISK    INFSR(INFSR)                                       239118
     F                                     COMMIT                                             CGL120
      * Midas RE Margin History Details.                                  CDE002
      * Account Risk Weighted Assets Codes                                CGL018
     FGLARWAL0  UF   E           K DISK    INFSR(INFSR)                         CGL018
     F                                     COMMIT                                             CGL120
     F/COPY WNCPYSRC,GLH00741
      ** Midas RE Accounts Overdraft History File                                             CER055
     FREAOHSL0  UF   E           K DISK    INFSR(INFSR)                                       CER055
     F                                     COMMIT                                             CGL120
     F/COPY WNCPYSRC,GL3320DF01
     F/EJECT
     F*****************************************************************
     F*                                                               *
     F*  F U N C T I O N   O F   I N D I C A T O R S                  *
     F*                                                               *
      *   70   - Setll finds equal key                                                        CGL120
     F*   76   - ReadP CHQBKL1                                        *                      BUG7967
      *   77   - Read CHQBKL1                                                                BUG4615
     F*   78   - READ REHMRGL0                                        *   CDE002
     F*   79   - CHAIN/READ TO REAPWDPD, MEMOSL1, PBUDCPD             *   164290
     F*   80   - READ REHISL                                          *
     F*   81   - READ REHPOPL                                         *
     F*   82   - READ REHPOML2                                        *
     F*   83   - READ REHPOSRL                                        *
     F*  85-86 - READ REACR                                           *
     F*   87   - READ RECOM                                           *
     F*   88   - READ GLARWAPD                                        *   CGL018
     F*   75   - READE REAOHSPD                                       *                       CER055
     F*                                                               *
     F*  90-99 - USED IN STANDARD SUBROUTINES                         *
     F*                                                               *
     F*   U7   - DATABASE ERROR                                       *
     F*   U8   - FILE CONTROLS OUT OF BALANCE                         *
     F*                                                               *
     F*****************************************************************
     F/EJECT
     F*****************************************************************
     F*                                                               *
     F*  S U B R O U T I N E   I N D E X                              *
     F*                                                               *
     F*  #A     - Initial processing                                  *
     F*  #B     - Main processing                                     *
     F*  #BA    - Drop records in REHISPP, REHISPS, REHISPM           *
     F*  #BB    - Drop records in REPOSPP                             *
     F*  #BC    - Drop records in REHPOSPM                            *
     F*  #BD    - Drop records in REHPOSR1, REHPOSR2,REHPOSR3         *
     F*  #BF    - Drop records in REACRD                              *
     F*  #BG    - Drop records in RECOM                               *
     F*  #BJ    - Drop records in PBUDCPD                             *   137916
     F*  #BK    - Drop records in MEMOSL1                             *   149193
     F*  #BL    - Drop records in REAPWDPD                            *   164290
     F*  #BM    - Drop records in RECIEUPD                            *   142089
     F*  #BP    - Drop records in REAOHSPD                            *                       CER055
     F*  #C     - Final processing                                    *
     F*  #CA    - Update REACRZ                                       *                       CGL120
     F*  INFSR  - File exception/error                                *
     F*                                                               *
     F*****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D/SPACE 2
     D***WKEY2**     DS                          1  18                                        CGL029
     D WKEY2           DS            24    OCCURS(1)                                          CGL029
     D*
     D** Data structure for KEY2
     D*
     D**********                              1   60#CNUM                                     CSD027
     D  #CNUM                  1      6                                                       CSD027
     D  #CCY                   7      9
     D**********                             10  130#ACOD                                     CGL029
     D**********                             14  150#ACSQ                                     CGL029
     D**********                             16  18 #BRCA                                     CGL029
     D  #ACOD                 10     19  0                                                    CGL029
     D  #ACSQ                 20     21  0                                                    CGL029
     D  #BRCA                 22     24                                                       CGL029
     D PSDS           SDS
     D*
     D** Program status data structure
     D*
     D  @FILE                201    208
     D  @JOB                 244    253
     D  @USER                254    263
     D LDA             DS           256
     D*
     D** Local Data Area
     D*
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     I/COPY WNCPYSRC,GL3320DI01
     C/EJECT
     C*
     C** Main program
     C*
     C*
     C** Initial processing
     C*
     C                   EXSR      #A
     C*
     C** Main processing
     C*
     C     *INU7         IFNE      '1'
     C     @TERM         ANDNE     'T'
     C                   EXSR      #B
     C                   ENDIF
     C*
     C** Final processing
     C*
     C                   EXSR      #C
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #A    INITIAL PROCESSING                         *
     C*                                                               *
     C*              - RECEIVE INPUT PARAMETERS                       *
     C*              - OPEN FILES IF FIRST CALL                       *
     C*              - INITIALISE KEY FIELDS OF EACH FILE WITH        *
     C*                INPUT PARAMETERS                               *
     C*                                                               *
     C*****************************************************************
     C     #A            BEGSR                                                  **#A BEGSR**
     C                   MOVEA     CPY@          BIS@             80
     C*
     C** Receive input parameters from RPG/GL3320
     C*
     C     *ENTRY        PLIST
     C                   PARM                    @TERM             1
     C                   PARM                    @BRCA             3
     C                   PARM                    @CNUM             6
     C                   PARM                    @CCY              3
     C**********           PARM           @ACOD   4                                           CGL029
     C                   PARM                    @ACOD            10                          CGL029
     C                   PARM                    @ACSQ             2
     C                   PARM                    @ACNO            10                          137916
     C*
     C** Initialise key fields of each file with input parameters
     C*
     C                   MOVE      @BRCA         XBRCA             3
     C**********           MOVE @CNUM     XCNUM   60                                          CSD027
     C                   MOVE      @CNUM         XCNUM             6                          CSD027
     C                   MOVE      @CCY          XCCY              3
     C**********           MOVE @ACOD     XACOD   40                                          CGL029
     C                   MOVE      @ACOD         XACOD            10 0                        CGL029
     C                   MOVE      @ACSQ         XACSQ             2 0
     C                   MOVE      @ACNO         XACNO            10 0                        137916
     C*
     C                   MOVE      *ZEROS        XDRCR             1 0
     C                   MOVE      *ZEROS        XHISD             5 0
     C                   MOVE      *BLANKS       XRSEQ             1
     C*
     C** Test termination parameter
     C*
     C     @TERM         IFEQ      'T'
     C                   GOTO      #AEND
     C                   ENDIF
     C*
     C** Check if this is the first run of the program
     C*
     C     @FIRST        IFEQ      *BLANK
     C                   MOVE      'N'           @FIRST            1
     C                   MOVEL     'GL3320D'     DBPGM
     C                   Z-ADD     0             WDEL              5 0                        CGL120
     C                   ENDIF
      *                                                                   CRE001
      ** Define LDA                                                       CRE001
      *                                                                   CRE001
     C     *DTAARA       DEFINE                  LDA                                          CRE001
      *                                                                   CRE001
      ** Check if SAR CRE001 is set on                                    CRE001
      *                                                                   CRE001
     C                   MOVE      'N'           CRE001            1                          CRE001
     C                   CALL      'AOSARDR0'                                                 CRE001
     C                   PARM      *BLANKS       @RTCD             7                          CRE001
     C                   PARM      '*VERIFY'     @OPTN             7                          CRE001
     C                   PARM      'CRE001'      @SARD             6                          CRE001
      *                                                                   CRE001
     C     @RTCD         IFNE      *BLANKS                                                    CRE001
     C     @RTCD         ANDNE     '*NRF   '                                                  CRE001
     C     *LOCK         IN        LDA                                                        CRE001
     C                   SETON                                        U7U8LR                  CRE001
     C                   MOVEL     'CRE001'      DBKEY                                        CRE001
     C                   MOVE      'SCSARDPD'    @FILE                          **************CRE001
     C                   Z-ADD     002           DBASE                          * DBERR0R 002*CRE001
     C                   OUT       LDA                                          **************CRE001
     C                   EXSR      INFSR                                                      CRE001
     C                   END                                                                  CRE001
      *                                                                   CRE001
     C     @RTCD         IFEQ      *BLANKS                                                    CRE001
     C                   MOVE      'Y'           CRE001                                       CRE001
     C                   END                                                                  CRE001
      *                                                                   CDE002
      ** Check if SAR CDE002 is set on                                    CDE002
      *                                                                   CDE002
     C                   MOVE      'N'           CDE002            1                          CDE002
     C                   CALL      'AOSARDR0'                                                 CDE002
     C                   PARM      *BLANKS       @RTCD                                        CDE002
     C                   PARM      '*VERIFY'     @OPTN                                        CDE002
     C                   PARM      'CDE002'      @SARD                                        CDE002
      *                                                                   CDE002
     C     @RTCD         IFNE      *BLANKS                                                    CDE002
     C     @RTCD         ANDNE     '*NRF   '                                                  CDE002
     C     *LOCK         IN        LDA                                                        CDE002
     C                   SETON                                        U7U8LR                  CDE002
     C                   MOVEL     'CDE002'      DBKEY                                        CDE002
     C                   MOVE      'SCSARDPD'    @FILE                                        CDE002
     C                   Z-ADD     003           DBASE                                        CDE002
     C                   OUT       LDA                                                        CDE002
     C                   EXSR      INFSR                                                      CDE002
     C                   END                                                                  CDE002
      *                                                                   CDE002
     C     @RTCD         IFEQ      *BLANKS                                                    CDE002
     C                   MOVE      'Y'           CDE002                                       CDE002
     C                   END                                                                  CDE002
      *                                                                   CGL018
      ***  Determine if switchable feature CGL018 is activated            CGL018
      *                                                                   CGL018
     C                   MOVE      'N'           CGL018            1                          CGL018
     C                   CALL      'AOSARDR0'                                                 CGL018
     C                   PARM      *BLANKS       @RTCD             7                          CGL018
     C                   PARM      '*VERIFY'     @OPTN             7                          CGL018
     C                   PARM      'CGL018'      @SARD             6                          CGL018
      *                                                                   CGL018
     C     @RTCD         IFNE      *BLANKS                                                    CGL018
     C     @RTCD         ANDNE     '*NRF   '                                                  CGL018
     C     *LOCK         IN        LDA                                                        CGL018
     C                   SETON                                        U7U8LR                  CGL018
     C                   MOVEL     'CGL018'      DBKEY                                        CGL018
     C                   MOVE      'SCSARDPD'    @FILE                          **************CGL018
     C                   Z-ADD     004           DBASE                          * DBERROR 004*CGL018
     C                   OUT       LDA                                          **************CGL018
     C                   EXSR      INFSR                                                      CGL018
     C                   END                                                                  CGL018
      *                                                                   CGL018
     C     @RTCD         IFEQ      *BLANKS                                                    CGL018
     C                   MOVE      'Y'           CGL018                                       CGL018
     C                   END                                                                  CGL018
      *                                                                                       CER055
      ***  Determine if switchable feature CER055 is activated                                CER055
      *                                                                                       CER055
     C                   MOVE      'N'           CER055            1                          CER055
     C                   CALL      'AOSARDR0'                                                 CER055
     C                   PARM      *BLANKS       @RTCD                                        CER055
     C                   PARM      '*VERIFY'     @OPTN                                        CER055
     C                   PARM      'CER055'      @SARD                                        CER055
      *                                                                                       CER055
     C     @RTCD         IFNE      *BLANKS                                                    CER055
     C     @RTCD         ANDNE     '*NRF   '                                                  CER055
     C     *LOCK         IN        LDA                                                        CER055
     C                   SETON                                        U7U8LR                  CER055
     C                   MOVEL     'CER055'      DBKEY                                        CER055
     C                   MOVE      'SCSARDPD'    @FILE                          ***************
     C                   Z-ADD     005           DBASE                          * DBERROR 005 *
     C                   OUT       LDA                                          ***************
     C                   EXSR      INFSR                                                      CER055
     C                   END                                                                  CER055
      *                                                                                       CER055
     C     @RTCD         IFEQ      *BLANKS                                                    CER055
     C                   MOVE      'Y'           CER055                                       CER055
     C                   END                                                                  CER055
     C*
     C** Determine keys for all files
     C*
     C     @KEY2         KLIST
     C                   KFLD                    XCNUM
     C                   KFLD                    XCCY
     C                   KFLD                    XACOD
     C                   KFLD                    XACSQ
     C                   KFLD                    XBRCA
     C     @KEY3         KLIST
     C                   KFLD                    XBRCA
     C                   KFLD                    XCNUM
     C                   KFLD                    XCCY
     C                   KFLD                    XACOD
     C                   KFLD                    XACSQ
     C                   KFLD                    XHISD
     C     @KEY4         KLIST
     C                   KFLD                    XBRCA
     C                   KFLD                    XCNUM
     C                   KFLD                    XCCY
     C                   KFLD                    XACOD
     C                   KFLD                    XACSQ
     C     @KEY5         KLIST
     C                   KFLD                    XBRCA
     C                   KFLD                    XCNUM
     C                   KFLD                    XCCY
     C                   KFLD                    XACOD
     C                   KFLD                    XACSQ
     C                   KFLD                    XHISD
     C                   KFLD                    XDRCR
     C                   KFLD                    XRSEQ
     C     @KEY6         KLIST                                                                137916
     C                   KFLD                    XACNO                                        137916
     C/COPY WNCPYSRC,GL3320DC03
     C     #AEND         ENDSR                                                  **#AEND TAG**
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #B    MAIN PROCESSING                            *
     C*                                                               *
     C*              - DROP RECORD IN FILES                           *
     C*                                                               *
     C*****************************************************************
     C     #B            BEGSR                                                  **#B BEGSR**
     C*
     C** Drop records in PF/REHISPP, PF/REHISPS, PF/REHISPM
     C*
     C                   EXSR      #BA
     C*
     C** Drop records in PF/REPOSPP
     C*
     C                   EXSR      #BB
     C*
     C** Drop records in PF/REHPOSPM
     C*
     C                   EXSR      #BC
     C*
     C** Drop records in PF/REHPOSR1, PF/REHPOSR2, PF/REHPOSR3
     C*
     C                   EXSR      #BD
     C*
     C** Drop records in PF/REACRD
     C*
     C                   EXSR      #BF
     C*
     C** Drop records in PF/RECOM
     C*
     C                   EXSR      #BG
      *                                                                   CRE001
     C********** CRE001    IFEQ 'Y'                                 CRE001171107
      *                                                                   CRE001
      * Drop records in ACCNTBXC                                          CRE001
     C                   EXSR      #BH                                                        CRE001
      *                                                                   CRE001
      * Drop records in REODHSL0                                          CRE001
     C     CRE001        IFEQ      'Y'                                                        171107
      *                                                                   171107
     C                   EXSR      #BI                                                        CRE001
      *                                                                   CRE001
     C                   ENDIF                                                                CRE001
     C** Drop records in PF/PBUDCPD                                       137916
     C                   EXSR      #BJ                                                        137916
     C** Drop records in MEMOSL1                                          149193
     C                   EXSR      #BK                                                        149193
     C** Drop records in PF/REAPWDPD                                      164290
     C                   EXSR      #BL                                                        164290
      *                                                                   CRE001
     C** Drop records in PF/RECIEUPD                                      142089
     C                   EXSR      #BM                                                        142089
      *                                                                                      BUG4615
      ** Drop records in CHQBKL1                                                             BUG4615
      *                                                                                      BUG4615
     C     XACNO         IFNE      *ZERO                                                     BUG4615
     C                   EXSR      SRDCHQ                                                    BUG4615
     C                   ENDIF                                                               BUG4615
      *                                                                   CDE002
      ** Drop recordms on REHMRGL0                                        CDE002
      *                                                                   CDE002
     C     CDE002        IFEQ      'Y'                                                        CDE002
     C                   EXSR      #BN                                                        CDE002
     C                   ENDIF                                                                CDE002
      *                                                                   CGL018
      * Drop records in GLARWAPD by LF GLARWAL0                           CGL018
     C     CGL018        IFEQ      'Y'                                                        CGL018
      *                                                                   CGL018
     C                   EXSR      #BO                                                        CGL018
      *                                                                   CGL018
     C                   ENDIF                                                                CGL018
      *                                                                                       CER055
      ** Drop records in REAOHSPD file                                                        CER055
      *                                                                                       CER055
     C     CER055        IFEQ      'Y'                                                        CER055
      *                                                                                       CER055
     C                   EXSR      #BP                                                        CER055
      *                                                                                       CER055
     C                   ENDIF                                                                CER055
      *                                                                   CDE002
     C/COPY WNCPYSRC,GL3320DC01
     C                   ENDSR
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #BA                                              *
     C*                                                               *
     C*  DROP RECORDS IN PF/REHISPP, PF/REHISPS, PF/REHISPM           *
     C*                                                               *
     C*****************************************************************
     C     #BA           BEGSR                                                  **#BA BEGSR**
     C*
     C** Access LF/REHISL
     C*
     C*****@KEY3         SETLL     REHISL                                                     CGL120
     C     @KEY4         SETLL     REHISL                                 70                  CGL120
     C*****@KEY4         READE     REHISL                                 80                  CGL120
     C   70@KEY4         READE     REHISL                                 80                  CGL120
     C*
     C** Delete record while it is found
     C*
     C     *IN80         DOWEQ     '0'
     C     *IN70         ANDEQ     '1'                                                        CGL120
     C                   DELETE    REHISL
     C*****@KEY4         READE     REHISL                                 80                  CGL120
     C     @KEY4         SETLL     REHISL                                 70                  CGL120
     C   70@KEY4         READE     REHISL                                 80                  CGL120
     C                   ENDDO
     C/COPY WNCPYSRC,GL3320DC04
     C                   ENDSR
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #BB                                              *
     C*                                                               *
     C*  DROP RECORDS IN PF/REHPOSPP                                  *
     C*                                                               *
     C*****************************************************************
     C     #BB           BEGSR                                                  **#BB BEGSR**
     C*
     C** Access LF/REHPOPL
     C*
     C*****@KEY4         SETLL     REHPOPL                                                    CGL120
     C     @KEY4         SETLL     REHPOPL                                70                  CGL120
     C*****@KEY4         READE     REHPOPL                                81                  CGL120
     C   70@KEY4         READE     REHPOPL                                81                  CGL120
     C*
     C** Delete record while it is found
     C*
     C     *IN81         DOWEQ     '0'
     C     *IN70         ANDEQ     '1'                                                        CGL120
     C                   DELETE    REHPOPL
     C*****@KEY4         READE     REHPOPL                                81                  CGL120
     C     @KEY4         SETLL     REHPOPL                                70                  CGL120
     C   70@KEY4         READE     REHPOPL                                81                  CGL120
     C                   ENDDO
     C                   ENDSR
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #BC                                              *
     C*                                                               *
     C*  DROP RECORDS IN PF/REHPOSPM                                  *
     C*                                                               *
     C*****************************************************************
     C     #BC           BEGSR                                                  **#BC BEGSR**
     C*
     C** Access LF/REHPOML2
     C*
     C*****@KEY3         SETLL     REHPOML2                                                   CGL120
     C     @KEY4         SETLL     REHPOML2                               70                  CGL120
     C*****@KEY4         READE     REHPOML2                               82                  CGL120
     C   70@KEY4         READE     REHPOML2                               82                  CGL120
     C*
     C** Delete record while it is found
     C*
     C     *IN82         DOWEQ     '0'
     C     *IN70         ANDEQ     '1'                                                        CGL120
     C                   DELETE    REHPOML2
     C*****@KEY4         READE     REHPOML2                               82
     C     @KEY4         SETLL     REHPOML2                               70                  CGL120
     C   70@KEY4         READE     REHPOML2                               82                  CGL120
     C                   ENDDO
     C                   ENDSR
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #BD                                              *
     C*                                                               *
     C*  DROP RECORDS IN PF/REHPOSR1, PF/REHPOSR2, PF/REHPOSR3        *
     C*                                                               *
     C*****************************************************************
     C     #BD           BEGSR                                                  **#BD BEGSR**
     C*
     C** Access LF/REHPOSRL
     C*
     C*****@KEY5         SETLL     REHPOSRL                                                   CGL120
     C     @KEY4         SETLL     REHPOSRL                               70                  CGL120
     C*****@KEY4         READE     REHPOSRL                               83                  CGL120
     C   70@KEY4         READE     REHPOSRL                               83                  CGL120
     C*
     C** Delete record while it is found
     C*
     C     *IN83         DOWEQ     '0'
     C     *IN70         ANDEQ     '1'                                                        CGL120
     C                   DELETE    REHPOSRL
     C*****@KEY4         READE     REHPOSRL                               83                  CGL120
     C     @KEY4         SETLL     REHPOSRL                               70                  CGL120
     C   70@KEY4         READE     REHPOSRL                               83                  CGL120
     C                   ENDDO
     C                   ENDSR
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #BF                                              *
     C*                                                               *
     C*  DROP RECORDS IN PF/REACRD                                    *
     C*                                                               *
     C*****************************************************************
     C     #BF           BEGSR                                                  **#BF BEGSR**
     C*
     C** Initialise counter of deleted record
     C*
     C**********         Z-ADD     0             WDEL              5 0                        CGL120
     C*
     C** Access LF/REACRD
     C*
     C     @KEY2         SETLL     REACR
     C     @KEY2         READE     REACR                                  85
     C*
     C** Delete record while it is found
     C*
     C     *IN85         DOWEQ     '0'
     C                   DELETE    REACR
     C                   ADD       1             WDEL
     C     @KEY2         READE     REACR                                  85
     C                   ENDDO
     C/COPY WNCPYSRC,GL3320DC05
     C*
     C***If*counter*of*deleted*record*is*different*from*zero,**********                       CGL120
     C***access*trailer************************************************                       CGL120
     C*
     C*****WDEL*         IFNE      0                                                          CGL120
     C******HIVAL        SETGT     REACR                                                      CGL120
     C**********         READP     REACR                                  86                  CGL120
     C*
     C***if*no*record*is*found*****************************************                       CGL120
     C*
     C******IN86         IFEQ      '1'                                                        CGL120
     C**********         MOVE      XCNUM         #CNUM                                        CGL120
     C**********         MOVE      XCCY          #CCY                                         CGL120
     C**********         MOVE      XACOD         #ACOD                                        CGL120
     C**********         MOVE      XACSQ         #ACSQ                                        CGL120
     C**********         MOVE      XBRCA         #BRCA                                        CGL120
     C**********         MOVEL     WKEY2         DBKEY                          **************CGL120
     C**********         MOVEL     'REACRZ'      DBFILE                         * DBERROR 001*CGL120
     C**********         MOVEL     '001'         DBASE                          **************CGL120
     C**********         MOVE      '1'           *INU7                                        CGL120
     C**********         GOTO      #BFEND                                                     CGL120
     C**********         ENDIF                                                                CGL120
     C*
     C***Subtract*the*counter*of*deleted*record*in*file*and*update*****                       CGL120
     C***trailer*******************************************************                       CGL120
     C*
     C**********         SUB       WDEL          NORE                                         CGL120
     C**********         UPDATE    REACRZF                                                    CGL120
     C**********         ENDIF                                                                CGL120
     C     #BFEND        ENDSR                                                  **#BFEND TAG**
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #BG                                              *
     C*                                                               *
     C*  DROP RECORDS IN PF/RECOM                                     *
     C*                                                               *
     C*****************************************************************
     C     #BG           BEGSR                                                  **#BG BEGSR**
     C*
     C** Access LF/RECOM
     C*
     C     @KEY4         SETLL     RECOM
     C     @KEY4         READE     RECOM                                  87
     C*
     C** Delete record while it is found
     C*
     C     *IN87         DOWEQ     '0'
     C                   DELETE    RECOM
     C     @KEY4         READE     RECOM                                  87
     C                   ENDDO
     C                   ENDSR
      *****************************************************************   CRE001
      /EJECT                                                              CRE001
      *****************************************************************   CRE001
      *                                                                   CRE001
      *  SUBROUTINE: #BH                                                  CRE001
      *                                                                   CRE001
      *  DROP RECORDS IN ACCNTBXC                                         CRE001
      *                                                                   CRE001
      *****************************************************************   CRE001
     C     #BH           BEGSR                                                                CRE001
      *                                                                   CRE001
     C     @KEY2         SETLL     ACCNTBXC                                                   CRE001
     C     @KEY2         READE     ACCNTBXC                               88                  CRE001
      *                                                                   CRE001
     C     *IN88         DOWEQ     '0'                                                        CRE001
     C                   DELETE    ACCNTBXC                                                   CRE001
     C     @KEY2         READE     ACCNTBXC                               88                  CRE001
     C                   ENDDO                                                                CRE001
      *                                                                   CRE001
     C                   ENDSR                                                                CRE001
      *****************************************************************   CRE001
      /EJECT                                                              CRE001
      *****************************************************************   CRE001
      *                                                                   CRE001
      *  SUBROUTINE: #BI                                                  CRE001
      *                                                                   CRE001
      *  DROP RECORDS IN REODHSL0                                         CRE001
      *                                                                   CRE001
      *****************************************************************   CRE001
     C     #BI           BEGSR                                                                CRE001
      *                                                                   CRE001
     C     @KEY3         SETLL     REODHSL0                                                   CRE001
     C     @KEY4         READE     REODHSL0                               89                  CRE001
      *                                                                   CRE001
     C     *IN89         DOWEQ     '0'                                                        CRE001
     C                   DELETE    REODHSL0                                                   CRE001
     C     @KEY4         READE     REODHSL0                               89                  CRE001
     C                   ENDDO                                                                CRE001
      *                                                                   CRE001
     C                   ENDSR                                                                CRE001
      *****************************************************************   CRE001
     C*****************************************************************   137916
     C*                                                               *   137916
     C*  SUBROUTINE: #BJ                                              *   137916
     C*                                                               *   137916
     C*  DROP RECORDS IN PF/PBUDCPD                                   *   137916
     C*                                                               *   137916
     C*****************************************************************   137916
     C     #BJ           BEGSR                                                  **#BJ BEGSR** 137916
     C                   SETOFF                                       79                      137916
     C** Find Retail A/c no in PF/PBUDCPD                                 137916
     C     @KEY6         CHAIN     PBUDCPD                            79                      137916
     C** Delete record when it is found                                   137916
     C     *IN79         IFEQ      '0'                                                        137916
     C                   DELETE    PBUDCPD                                                    137916
      *                                                                                       239118
      ** Update trailer file PBUDCPH.                                                         239118
      *                                                                                       239118
     C     *LOVAL        SETLL     PBUDCPH                                                    239118
     C                   READ      PBUDCPH                                25                  239118
     C     *IN25         IFEQ      '0'                                                        239118
     C                   SUB       1             NORE                                         239118
     C                   UPDATE    PBUDCPHF                                                   239118
     C                   ENDIF                                                                239118
      *                                                                                       239118
     C                   END                                                                  137916
     C                   ENDSR                                                                137916
     C*****************************************************************   149193
     C*                                                               *   149193
     C*  SUBROUTINE: #BK                                              *   149193
     C*                                                               *   149193
     C*  DROP RECORDS IN PF/MEMOS                                     *   149193
     C*                                                               *   149193
     C*****************************************************************   149193
     C     #BK           BEGSR                                                  **#BK BEGSR** 149193
     C                   SETOFF                                       79                      149193
     C** Access LF/MEMOSL1                                                149193
     C     @KEY2         SETLL     MEMOSL1                                                    149193
     C     @KEY2         READE     MEMOSL1                                79                  149193
     C** Delete record while it is found                                  149193
     C     *IN79         DOWEQ     '0'                                                        149193
     C                   DELETE    MEMOSL1                                                    149193
     C     @KEY2         READE     MEMOSL1                                79                  149193
     C                   ENDDO                                                                149193
     C                   ENDSR                                                                149193
      /EJECT                                                              CRE001
      *****************************************************************   164290
      *  SUBROUTINE: #BL                                                  164290
      *  DROP RECORDS IN PF/REAPWDPD                                      164290
      *****************************************************************   164290
     C     #BL           BEGSR                                                  **#BL BEGSR** 164290
     C                   SETOFF                                       79                      164290
     C** Find retail a/c number in PF/REAPWDPD                            164290
     C***********@KEY2     CHAINREAPWDPD             79                                164290 CGP001
     C     @KEY2         CHAIN     REAPWDL0                           79                      CGP001
     C** If record is found, delete it.                                   164290
     C     *IN79         DOWEQ     '0'                                                        164290
     C***********          DELETREAPWDPD                                               164290 CGP001
     C***********@KEY2     READEREAPWDPD                 79                            164290 CGP001
     C                   DELETE    REAPWDL0                                                   CGP001
     C     @KEY2         READE     REAPWDL0                               79                  CGP001
     C                   ENDDO                                                                164290
     C                   ENDSR                                                                164290
      *****************************************************************   164290
      /EJECT                                                              142089
      *****************************************************************   142089
      *  SUBROUTINE: #BM                                                  142089
      *  DROP RECORDS IN PF/RECIEUPD Used by Cashier with Co-Sign/EMU.    142089
      *****************************************************************   142089
     C     #BM           BEGSR                                                  **#BM BEGSR** 142089
     C                   SETOFF                                       79                      142089
     C** Find retail a/c number in PF/RECIEUPD                            142089
     C***********@KEY6     CHAINRECIEUL1             7979          142089 217910
     C     @KEY4         CHAIN     RECIEUL2                           7979                    217910
     C** If record is found, delete it.                                   142089
     C     *IN79         DOWEQ     '0'                                                        142089
     C***********          DELETRECIEUL1                           142089 217910
     C***********@KEY6     READERECIEUL1                 79        142089 217910
     C                   DELETE    RECIEUL2                                                   217910
     C     @KEY4         READE     RECIEUL2                               79                  217910
     C                   ENDDO                                                                142089
     C                   ENDSR                                                                142089
      *****************************************************************   142089
      /EJECT                                                              CRE001
      *****************************************************************   CDE002
      *                                                               *   CDE002
      *  SUBROUTINE: #BN                                              *   CDE002
      *                                                               *   CDE002
      *  DROP RECORDS IN PF/REHMRGPD                                  *   CDE002
      *                                                               *   CDE002
      *****************************************************************   CDE002
     C     #BN           BEGSR                                                  **#BN BEGSR** CDE002
      *                                                                   CDE002
      ** Access LF/REHMRGL0                                               CDE002
      *                                                                   CDE002
     C     @KEY4         SETLL     REHMRGL0                                                   CDE002
     C     @KEY4         READE     REHMRGL0                               78                  CDE002
      *                                                                   CDE002
      ** Delete record while it is found                                  CDE002
      *                                                                   CDE002
     C     *IN78         DOWEQ     '0'                                                        CDE002
     C                   DELETE    REHMRGL0                                                   CDE002
     C     @KEY4         READE     REHMRGL0                               78                  CDE002
     C                   ENDDO                                                                CDE002
     C                   ENDSR                                                                CDE002
      *****************************************************************   CDE002
      /EJECT                                                              CGL018
     C*****************************************************************   CGL018
     C*                                                               *   CGL018
     C*  SUBROUTINE: #BO                                              *   CGL018
     C*                                                               *   CGL018
     C*  DROP RECORDS IN PF/GLARWAPD                                  *   CGL018
     C*                                                               *   CGL018
     C*****************************************************************   CGL018
     C     #BO           BEGSR                                                  **#BO BEGSR** CGL018
     C*                                                                   CGL018
     C** Access LF/GLARWAL0                                               CGL018
     C*                                                                   CGL018
     C     @KEY4         SETLL     GLARWAL0                                                   CGL018
     C     @KEY4         READE     GLARWAL0                               88                  CGL018
     C*                                                                   CGL018
     C** Delete record while it is found                                  CGL018
     C*                                                                   CGL018
     C     *IN88         DOWEQ     '0'                                                        CGL018
     C                   DELETE    GLARWAL0                                                   CGL018
     C     @KEY4         READE     GLARWAL0                               88                  CGL018
     C                   ENDDO                                                                CGL018
     C                   ENDSR                                                                CGL018
     C*****************************************************************                       CER055
      /EJECT                                                                                  CER055
     C*****************************************************************                       CER055
     C*                                                               *                       CER055
     C*  SUBROUTINE: #BP                                              *                       CER055
     C*                                                               *                       CER055
     C*  DROP RECORDS IN PF/REAOHSPD                                  *                       CER055
     C*                                                               *                       CER055
     C*****************************************************************                       CER055
     C     #BP           BEGSR                                                  **#BP BEGSR**
      *                                                                                       CER055
      ** Access LF/REAOHSL0                                                                   CER055
      *                                                                                       CER055
     C     @KEY2         SETLL     REAOHSL0                                                   CER055
     C     @KEY2         READE     REAOHSL0                               75                  CER055
      *                                                                                       CER055
      ** Delete record while it is found                                                      CER055
      *                                                                                       CER055
     C     *IN75         DOWEQ     '0'                                                        CER055
     C                   DELETE    REAOHSD0                                                   CER055
     C     @KEY2         READE     REAOHSL0                               75                  CER055
     C                   ENDDO                                                                CER055
      *                                                                                       CER055
     C                   ENDSR                                                                CER055
      *****************************************************************                       CER055
      /EJECT                                                              CDE002
     C/COPY WNCPYSRC,GL3320DC02
      *****************************************************************                      BUG4615
      /EJECT                                                                                 BUG4615
      *****************************************************************                      BUG4615
      *                                                               *                      BUG4615
      *  SRDCHQ - Drop records in CHQBKPD                             *                      BUG4615
      *                                                               *                      BUG4615
      *****************************************************************                      BUG4615
     C     SRDCHQ        BEGSR                                                               BUG4615
     C                   Z-ADD     0             WDELCH            5 0                       BUG7967
      *                                                                                      BUG4615
      ** Access LF/CHQBKL1                                                                   BUG4615
      *                                                                                      BUG4615
     C     @KEY6         SETLL     CHQBKL1                                                   BUG4615
     C     @KEY6         READE     CHQBKL1                                77                 BUG4615
      *                                                                                      BUG4615
      ** Delete record while it is found                                                     BUG4615
      *                                                                                      BUG4615
     C     *IN77         DOWEQ     *OFF                                                      BUG4615
     C                   DELETE    CHQBKL1                                                   BUG4615
     C                   ADD       1             WDELCH                                      BUG7967
     C     @KEY6         READE     CHQBKL1                                77                 BUG4615
     C                   ENDDO                                                               BUG4615
     C*                                                                                      BUG7967
     C** If counter of deleted record is different from zero,                                BUG7967
     C** access trailer                                                                      BUG7967
     C*                                                                                      BUG7967
     C     WDELCH        IFNE      0                                                         BUG7967
     C     *HIVAL        SETGT     CHQBKL1                                                   BUG7967
     C                   READP     CHQBKL1                                76                 BUG7967
      *                                                                                      BUG7967
     C     *IN76         IFEQ      '0'                                                       BUG7967
     C*                                                                                      BUG7967
     C** Subtract the counter of deleted record in file and update                           BUG7967
     C** trailer                                                                             BUG7967
     C*                                                                                      BUG7967
     C                   SUB       WDELCH        NORE                                        BUG7967
     C                   UPDATE    CHQBKPTF                                                  BUG7967
     C                   ENDIF                                                               BUG7967
     C                   ENDIF                                                               BUG7967
      *                                                                                      BUG4615
     C                   ENDSR                                                               BUG4615
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE: #C    TERMINATION PROCESSING                     *
     C*                                                               *
     C*              - IF ERROR, SET TERMINATION PARAMETER TO 'E'     *
     C*              - IF TERMINATION PARAMETER IS 'T', SETON LR      *
     C*              - RETURN                                         *
     C*                                                               *
     C*****************************************************************
     C     #C            BEGSR                                                  **#C BEGSR**
     C*
     C** Test if database error
     C*
     C     *INU7         IFEQ      '1'
     C                   MOVE      '1'           *INLR
     C                   MOVE      'E'           @TERM
     C                   GOTO      #CEND
     C                   ENDIF
     C*
     C** Test termination parameter
     C*
     C     @TERM         IFEQ      'T'
     C                   EXSR      #CA                                                        CGL120
     C                   MOVE      '1'           *INLR
     C                   GOTO      #CEND
     C                   ENDIF
     C*
     C** If neither of the above conditions have been satisfied,
     C** return to the calling program
     C*
     C                   RETURN
     C     #CEND         ENDSR                                                  **#CEND TAG**
     C*****************************************************************                       CGL120
     C*                                                               *                       CGL120
     C*  SUBROUTINE: #CA                                              *                       CGL120
     C*                                                               *                       CGL120
     C*  UPDATE PF/REACRZ                                             *                       CGL120
     C*                                                               *                       CGL120
     C*****************************************************************                       CGL120
     C     #CA           BEGSR                                                                CGL120
      *                                                                                       CGL120
      ** If counter of deleted record is different from zero,                                 CGL120
      ** access trailer                                                                       CGL120
      *                                                                                       CGL120
     C     WDEL          IFNE      0                                                          CGL120
      *                                                                                       CGL142
     C**********         READ      GLREACRZ                               86         CGL142 MD020565
     C******IN86         IFEQ      *OFF                                              CGL142 MD020565
     C**********         ADD       WDEL          NORE                                CGL142 MD020565
     C**********         UPDATE    GLREACZF                                          CGL142 MD020565
     C**********         ELSE                                                        CGL142 MD020565
     C                   Z-ADD     WDEL          NORE                                         CGL142
     C                   WRITE     GLREACZF                                                   CGL142
     C**********         ENDIF                                                       CGL142 MD020565
      *                                                                                       CGL142
     C******HIVAL        SETGT     REACR                                               CGL120 CGL142
     C**********         READP     REACR                                  86           CGL120 CGL142
      ***************************************************************                  CGL120 CGL142
      ***If*no*record*is*found***************************************                  CGL120 CGL142
      ***************************************************************                  CGL120 CGL142
     C******IN86         IFEQ      '1'                                                 CGL120 CGL142
     C**********         MOVE      XCNUM         #CNUM                                 CGL120 CGL142
     C**********         MOVE      XCCY          #CCY                                  CGL120 CGL142
     C**********         MOVE      XACOD         #ACOD                                 CGL120 CGL142
     C**********         MOVE      XACSQ         #ACSQ                                 CGL120 CGL142
     C**********         MOVE      XBRCA         #BRCA                                 CGL120 CGL142
     C**********         MOVEL     WKEY2         DBKEY                   **************CGL120 CGL142
     C**********         MOVEL     'REACRZ'      DBFILE                  * DBERROR 001*CGL120 CGL142
     C**********         MOVEL     '001'         DBASE                   **************CGL120 CGL142
     C**********         MOVE      '1'           *INU7                                 CGL120 CGL142
     C**********         GOTO      #CAEND                                              CGL120 CGL142
     C**********         ENDIF                                                         CGL120 CGL142
      ***************************************************************                  CGL120 CGL142
      ***Subtract*the*counter*of*deleted*record*in*file*and*update***                  CGL120 CGL142
      ***trailer*****************************************************                  CGL120 CGL142
      ***************************************************************                  CGL120 CGL142
     C**********         SUB       WDEL          NORE                                  CGL120 CGL142
     C**********         UPDATE    REACRZF                                             CGL120 CGL142
     C                   ENDIF                                                                CGL120
     C     #CAEND        ENDSR                                                                CGL120
     C*****************************************************************
     C*                                                               *
     C*  INFSR - File exception/error subroutine                      *
     C*                                                               *
     C*  CALLED BY: Executes whenever file exception/error occurs     *
     C*                                                               *
     C*  CALLS:                                                       *
     C*                                                               *
     C*  USES : @ERR2  - Flag to prevent looping if further errors    *
     C*         @FILE  - Filename for which exception/error           *
     C*                  occurred (POSNS 201-208 OF PSDS)             *
     C*         @TERM  - Termination parameter                        *
     C*                                                               *
     C*****************************************************************
     C     INFSR         BEGSR                                                  **INFSR BEGSR**
     C*
     C** Set @ERR2 to 'Y' to prevent looping if further errors
     C*
     C     @ERR2         IFNE      'Y'
     C                   MOVE      'Y'           @ERR2             1
     C*
     C** Set up fields in local data area
     C*
     C                   MOVEL     @FILE         DBFILE
     C                   MOVE      '992'         DBASE
     C*
     C** Dump the program
     C*
     C                   DUMP
     C                   MOVE      'E'           @TERM
     C                   END
     C*
     C** Terminate the program
     C*
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDSR
     C*****************************************************************
** CPY@   **      OBJECT COPYRIGHT
(c) Misys International Banking Systems Ltd. 2001
