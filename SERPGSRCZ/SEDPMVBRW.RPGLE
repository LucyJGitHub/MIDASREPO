     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV browse function')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEDPMVBRW - Securities Browse function Module                *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of deals for selection,        *
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CSE071             Date 19Jul05               *
      *                 CSC022             Date 16Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CSE039             Date 21Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 207006             Date 18Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 203798             Date 11Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      *                 CSE016             Date 10Jan01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE015             Date 06Dec99               *
      *                 CSE017             Date 20Oct99               *
      *                 CSE012             Date 16Aug99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP004             Date 01Sep98               *
      *                 CAP003  *CREATE    Date 11May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSC022 - DBerr occurs. Recompiled only.                      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSE039 - Auto-settle of trades. Amendment to allow SEDPMVSIN *
      *           to be called from SE4400 in 'E' mode.               *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  207006 - Add Counterparty & Market Centre to SSI (Recompile) *
      *  203798 - Enhanced browsing                                   *
      *  CSE022 - Depository Definition Enhancement (Recompile)       *
      *  CSE016 - Extended Security Descriptions                      *
      *  CSE015 - Forward Valued Depot Movements (Recompiled)         *
      *  CSE017 - Cum/Ex Indicator on Depot Narratives (Recompiled)   *
      *  CSE012 - SE Depot Movement Narratives (Recompiled).          *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP004 - API's Phase 3.                                      *
      *           Allow browse by Front Office Id.                    *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEDPMVBDF CF   E             WORKSTN
     F                                     SFILE(SEDPMVS1:@@RRN)
     F                                     SFILE(SEDPMVS3:@@RRN)                CAP004
 
     FDPTMV     IF   E           K DISK    INFSR(*PSSR)
     FDPTMVR    IF   E           K DISK    INFSR(*PSSR)                                       203798
     F                                     RENAME(DPTMVDF:DPTMVRF)                            203798
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     FSEDPMVL0  IF   E           K DISK    INFSR(*PSSR)                         CAP004
     F                                     RENAME(DPTMVDF:DPTMVFO)              CAP004
     F/COPY WNCPYSRC,SEDPMVBF01
 
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
 
      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for Bank Details
      ** General ledger details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)                                  CSE016
      **  Data structure for securities trading details                                       CSE016
 
      ** DS for Access programs, short DS
      ** DS for Access Programs, long DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CSE016
      ** Parameter declaration of ZSDESC                                                      CSE016
                                                                                              CSE016
     D PSRPN           S             20A                                                      CSE016
     D PSFN1           S             30A                                                      CSE016
     D PSFN2           S             30A                                                      CSE016
     D PRSFD           S              1A                                                      CSE016
     D PRNME           S             41A                                                      CSE016
     D PFNM1           S             30A                                                      CSE016
     D PFNM2           S             50A                                                      CSE016
     D PFNM3           S             50A                                                      CSE016
     D/COPY WNCPYSRC,SEDPMVBD01
 
                                                                                              203798
      * Current Selection Fields                                                              203798
     D                 DS                                                                     203798
     D Curr_SEL                1     16                                                       203798
     D CurrDPSS                1     10                                                       203798
     D CurrDPRN               11     16                                                       203798
     D                 DS                                                                     203798
     D Curr_SEL2               1     36                                                       203798
     D CurrFODN                1     20                                                       203798
     D CurrDPSS2              21     30                                                       203798
     D CurrDPRN2              31     36                                                       203798
                                                                                              203798
                                                                                              203798
      * Previous Selection Fields                                                             203798
     D                 DS                                                                     203798
     D Prev_SEL                1     16                                                       203798
     D                 DS                                                                     203798
     D Prev_SEL2               1     36                                                       203798
                                                                                              203798
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** Rename fields to avoid conflict
      *
     IDPTMVDF
     I              RECI                        RECI_DPMV
 
     IDPTMVRF                                                                                 203798
     I              RECI                        RECI_DPMV                                     203798
                                                                                              203798
     ISECTYDF
     I              RECI                        RECI_SEC
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   EXSR      SRInit
      *
      ** Build sub-file
      *
     C     @BldSfl       IFEQ      'Y'
      *                                                                         CAP004
      **  If First time in or subfile by Midas trade number was previously      CAP004
      **  being run, then build subfile keyed on Midas trade number.            CAP004
      **  Stay in loop while F11 toggle key is used.                            CAP004
      *                                                                         CAP004
     C     WTRAD         IFNE      'F'                                          CAP004
     C     *INKK         DOUEQ     '0'                                          CAP004
     C                   EXSR      SRBldSfl
      *                                                                         CAP004
      **  If F11, switch to Front Office Deal subfile                           CAP004
      *                                                                         CAP004
     C     *INKK         IFEQ      '1'                                          CAP004
     C                   EXSR      SrBldSfl2                                    CAP004
     C                   END                                                    CAP004
     C                   END                                                    CAP004
      *
     C                   ELSE                                                   CAP004
      *
      **  If the subfile by Front Office Identifier was previously              CAP004
      **  being run, then build subfile keyed on Front Office ID.               CAP004
      **  Stay in loop while F11 toggle key is used.                            CAP004
      *
     C     *INKK         DOUEQ     '0'                                          CAP004
     C                   EXSR      SrBldSfl2                                    CAP004
      *                                                                         CAP004
      **  If F11, switch to Midas Deal Number subfile                           CAP004
      *                                                                         CAP004
     C     *INKK         IFEQ      '1'                                          CAP004
     C                   EXSR      SrBldSfl                                     CAP004
     C                   END                                                    CAP004
     C                   END                                                    CAP004
     C                   END
     C                   END
      *
      ** Read Subfile Record
      *
     C     @RdSfl        IFEQ      'Y'
     C                   EXSR      SRRdSfl
     C                   END
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl - SubFile Details Generation Routine                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRBldSfl      BEGSR
      *
      * Set indicator and flag for Midas (back) office trade number key used    CAP004
      *                                                                         CAP004
     C                   MOVE      'B'           WTRAD             1            CAP004
     C                   MOVE      '0'           *IN20                          CAP004
      *
      ** Check for user authority to Browse if Not Multi-Branching.
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      SRChkAut
     C                   END
      *                                                                                       203798
      ** Do until selection is not changed or F/11 is taken                                   203798
      *                                                                                       203798
     C     Curr_SEL      DOUEQ     Prev_SEL                                                   203798
     C     *INKK         OREQ      '1'                                                        203798
                                                                                              203798
      ** Update record selection fields                                                       203798
                                                                                              203798
     C                   EXSR      UPD_SELECT                                                 203798
     C                   MOVEL     Curr_SEL      Prev_SEL                                     203798
      *
      ** Validate transaction Reference Number (For Pointer)
      *
     C                   EXSR      SRValRef
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     SEDPMVS0
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     SEDPMVF1
      *
      **  Set file pointer on key displayed on screen.
      *
     C     Referkey      KLIST                                                                203798
     C                   KFLD                    @@DPRN            6                          203798
     C     Transkey      KLIST
     C                   KFLD                    @@DPSS           10
     C                   KFLD                    @@DPRN            6
     C/COPY WNCPYSRC,SEDPMVBC01
 
     C     @@DPSS        IFEQ      *BLANK                                                     203798
     C     @@DPRN        ANDNE     *BLANK                                                     203798
     C     ReferKey      SETLL     DPTMVR                                                     203798
     C                   ELSE                                                                 203798
     C     TransKey      SETLL     DPTMV
     C                   ENDIF                                                                203798
     C/COPY WNCPYSRC,SEDPMVBC02
      *
      ** Read a Valid Deal
      *
     C                   EXSR      SRRdTrans
      *
      ****If*no*records*exist*-*set*up*an*error*message.                                      203798
      ****and*terminate**************************                                             203798
      *******************************************                                             203798
     C*****@@EOF*********IFEQ******'Y'***********                                             203798
     C*******************MOVEL*****'FXM1007'*****@ERRMS                                       203798
     C*******************RETURN******************                                             203798
     C*******************END*********************                                             203798
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      **  or the selection is changed.                                                        203798
      *
     C*****@@EOF*********DOWNE     'Y'                                                        203798
     C******IN98*********ANDEQ     '1'                                                        203798
     C     *IN98         DOWEQ     '1'                                                        203798
     C     Curr_SEL      ANDEQ     Prev_SEL                                                   203798
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C*****@@CNT         ANDLT     14                                                         CSE016
     C     @@CNT         ANDLT     7                                                          CSE016
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Format Deal fields for output
      *
     C                   EXSR      SRFmtDet
      *
      **  Write the deal to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     SEDPMVS1
      *
      ** Read a Valid Deal
      *
     C                   EXSR      SRRdTrans
     C                   END
      *
      **  Retrieve time
      *
     C                   TIME                    DDTIME
                                                                                              203798
     C     @@CNT         IFEQ      0                                                          203798
     C                   SETOFF                                       98                      203798
     C                   EXFMT     SEDPMVX0                                                   203798
     C                   ELSE                                                                 203798
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SEDPMVS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SEDPMVS0                               99
     C                   ENDIF                                                                203798
                                                                                              203798
      ** Update record selection fields                                                       203798
                                                                                              203798
     C                   EXSR      UPD_SELECT                                                 203798
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   EVAL      *INLR = '1'
     C                   RETURN
     C                   END
      *
      **  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           @INKL
     C                   RETURN
     C                   END
 
     C                   END
                                                                                              203798
     C                   ENDDO                                                                203798
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                    CAP004
      *****************************************************************         CAP004
      *                                                               *         CAP004
      * SRBldSfl2 - SubFile Details Generation Routine                *         CAP004
      *            By Front Office Deal Number                        *         CAP004
      *                                                               *         CAP004
      * Called by: Main                                               *         CAP004
      *                                                               *         CAP004
      * Calls:  None                                                  *         CAP004
      *                                                               *         CAP004
      *****************************************************************         CAP004
                                                                                CAP004
     C     SRBldSfl2     BEGSR                                                  CAP004
      *                                                                         CAP004
      * Set indicator and flag for Front Office ID key used                     CAP004
      *                                                                         CAP004
     C                   MOVE      'F'           WTRAD                          CAP004
     C                   MOVE      '1'           *IN20                          CAP004
      *                                                                         CAP004
      ** Check for user authority to Browse if Not Multi-Branching.             CAP004
      *                                                                         CAP004
     C     BJSBRC        IFNE      *BLANK                                       CAP004
     C                   EXSR      SRChkAut                                     CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      ** Validate transaction Reference Number (For Pointer)                    CAP004
      *                                                                         CAP004
     C                   EXSR      SRValRef                                     CAP004
      *                                                                         CAP004
      **  Get Front Office ID                                                   CAP004
      *                                                                         CAP004
     C     @@DPSS        IFEQ      *BLANK                                                     203798
     C     @@DPRN        ANDNE     *BLANK                                                     203798
     C     ReferKey      SETLL     DPTMVR                                                     203798
     C                   READ      DPTMVR                                 89                  203798
     C     *IN89         DOWEQ     '0'                                                        203798
     C     DPMV          ANDNE     DPMVType                                                   203798
     C                   READ      DPTMVR                                 89                  203798
     C                   ENDDO                                                                203798
     C                   ELSE                                                                 203798
     C/COPY WNCPYSRC,SEDPMVBC03
     C*****TransKey******CHAIN     DPTMV                              89               CAP004 203798
     C/COPY WNCPYSRC,SEDPMVBC04
     C     TransKey      SETLL     DPTMV                                                      203798
     C                   READ      DPTMV                                  89                  203798
     C     *IN89         DOWEQ     '0'                                                        203798
     C     DPMV          ANDNE     DPMVType                                                   203798
     C                   READ      DPTMV                                  89                  203798
     C                   ENDDO                                                                203798
     C                   ENDIF                                                                203798
     C     *IN89         IFEQ      '0'                                                        203798
     C*******************MOVE******DMFRNT********@@FOTD           20                   CAP004 203798
     C******IN89*********IFEQ******'1'*****************                                CAP004 203798
     C*******************MOVE*******BLANK********@@FOTD                                CAP004 203798
     C*******************END***************************                                CAP004 203798
     C                   MOVE      DMFRNT        DFODN                                        203798
     C                   MOVE      DPSS          DDPSS                                        203798
     C                   MOVE      DPRN          DDPRN                                        203798
     C                   ELSE                                                                 203798
     C                   MOVE      *BLANK        DFODN                                        203798
     C                   MOVE      *BLANK        DDPSS                                        203798
     C                   MOVE      *BLANK        DDPRN                                        203798
     C                   END                                                                  203798
      *                                                                                       203798
      ** Do until selection is not changed or F/11 is taken                                   203798
      *                                                                                       203798
     C     Curr_SEL2     DOUEQ     Prev_SEL2                                                  203798
     C     *INKK         OREQ      '1'                                                        203798
                                                                                              203798
     C                   MOVEL     DFODN         @@FOTD           20                          203798
     C                   MOVEL     DDPSS         @@DPSS2          10                          203798
     C                   MOVEL     DDPRN         @@DPRN2           6                          203798
     C                   MOVEL     DFODN         CurrFODN                                     203798
     C                   MOVEL     DDPSS         CurrDPSS2                                    203798
     C                   MOVEL     DDPRN         CurrDPRN2                                    203798
     C                   MOVEL     Curr_SEL2     Prev_SEL2                                    203798
      *                                                                         CAP004
      **  Initialise subfile relative record number.                            CAP004
      *                                                                         CAP004
     C                   Z-ADD     0             @@RRN                          CAP004
      *                                                                         CAP004
      **  Clear subfile before refilling by writing control record              CAP004
      **  with SFLCLR active.                                                   CAP004
      *                                                                         CAP004
     C                   MOVE      '1'           *IN97                          CAP004
     C                   WRITE     SEDPMVS2                                     CAP004
     C                   MOVE      '0'           *IN97                          CAP004
      *                                                                         CAP004
      **  Write the select screen footer to the screen.                         CAP004
      *                                                                         CAP004
     C                   WRITE     SEDPMVF1                                     CAP004
      *                                                                         CAP004
      **  Set file pointer on key displayed on screen.                          CAP004
      *                                                                         CAP004
     C/COPY WNCPYSRC,SEDPMVBC05
     C*****@@FOTD********SETLL     DPTMVFO                                             CAP004 203798
     C/COPY WNCPYSRC,SEDPMVBC06
     C     @@FOTDK       SETLL     DPTMVFO                                                    203798
      *                                                                         CAP004
      ** Read a Valid Deal                                                      CAP004
      *                                                                         CAP004
     C                   EXSR      SRRdTrans                                    CAP004
      *                                                                         CAP004
      ****If*no*records*exist*-*set*up*an*error*message.                               CAP004 203798
      ****and*terminate**************************                                      CAP004 203798
      *******************************************                                      CAP004 203798
     C*****@@EOF*********IFEQ******'Y'***********                                      CAP004 203798
     C*******************MOVEL*****'FXM1007'*****@ERRMS                                CAP004 203798
     C*******************RETURN******************                                      CAP004 203798
     C*******************END*********************                                      CAP004 203798
      *                                                                         CAP004
      **  Set on ROLLUP indicator to drive initial loop.                        CAP004
      *                                                                         CAP004
     C                   MOVE      '1'           *IN98                          CAP004
      *                                                                         CAP004
      **  Read records from the file into the subfile until a page has          CAP004
      **  been filled or there are no more records.                             CAP004
      **  Repeat the process until either the end of file, ROLLUP               CAP004
      **  has not been entered or F3 or F12 is input.                           CAP004
      **  or the selection is changed.                                                        203798
      *                                                                         CAP004
     C*****@@EOF*********DOWNE     'Y'                                                 CAP004 203798
     C******IN98*********ANDEQ     '1'                                                 CAP004 203798
     C     *IN98         DOWEQ     '1'                                                        203798
     C     Curr_SEL2     ANDEQ     Prev_SEL2                                                  203798
      *                                                                         CAP004
      **  Initialise count of records written to subfile page.                  CAP004
      *                                                                         CAP004
     C                   Z-ADD     0             @@CNT                          CAP004
      *                                                                         CAP004
      **  For each record read, write it to the subfile.                        CAP004
      **  Do this until end of file or the subfile page is full.                CAP004
      *                                                                         CAP004
     C     @@EOF         DOWNE     'Y'                                          CAP004
     C*****@@CNT         ANDLT     14                                                  CAP004 CSE016
     C     @@CNT         ANDLT     7                                                          CSE016
      *                                                                         CAP004
      **  Increment the subfile record no. and records written fields.          CAP004
      *                                                                         CAP004
     C                   ADD       1             @@RRN                          CAP004
     C                   ADD       1             @@CNT                          CAP004
      *                                                                         CAP004
      ** Format Deal fields for output                                          CAP004
      *                                                                         CAP004
     C                   EXSR      SRFmtDet                                     CAP004
      *                                                                         CAP004
      **  Write the deal to the subfile.                                        CAP004
      *                                                                         CAP004
     C                   MOVE      *BLANK        DDOPT                          CAP004
     C                   Z-ADD     @@RRN         DDSFRN                         CAP004
     C                   WRITE     SEDPMVS3                                     CAP004
      *                                                                         CAP004
      ** Read a Valid Deal                                                      CAP004
      *                                                                         CAP004
     C                   EXSR      SRRdTrans                                    CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      **  Retrieve time                                                         CAP004
      *                                                                         CAP004
     C                   TIME                    DDTIME                         CAP004
                                                                                              203798
     C     @@CNT         IFEQ      0                                                          203798
     C                   SETOFF                                       98                      203798
     C                   EXFMT     SEDPMVX2                                                   203798
     C                   ELSE                                                                 203798
      *                                                                         CAP004
      **  Write the subfile control record to the screen to display             CAP004
      **  the subfile.                                                          CAP004
      *                                                                         CAP004
     C                   WRITE     SEDPMVS2                                     CAP004
      *                                                                         CAP004
      **  Read the subfile control record to determine whether records          CAP004
      **  have been selected or whether ROLLUP is required.                     CAP004
      *                                                                         CAP004
     C                   READ      SEDPMVS2                               99    CAP004
     C                   ENDIF                                                                203798
                                                                                              203798
     C                   MOVEL     DFODN         CurrFODN                                     203798
     C                   MOVEL     DDPSS         CurrDPSS2                                    203798
     C                   MOVEL     DDPRN         CurrDPRN2                                    203798
      *                                                                         CAP004
      **  If F3, bypass further processing.                                     CAP004
      *                                                                         CAP004
     C     *INKC         IFEQ      '1'                                          CAP004
     C                   MOVEL     '1'           @INKC                          CAP004
     C                   EVAL      *INLR = '1'                                  CAP004
     C                   RETURN                                                 CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      **  If F12, bypass further processing.                                    CAP004
      *                                                                         CAP004
     C     *INKL         IFEQ      '1'                                          CAP004
     C                   MOVEL     '1'           @INKL                          CAP004
     C                   RETURN                                                 CAP004
     C                   END                                                    CAP004
                                                                                CAP004
     C                   END                                                    CAP004
                                                                                              203798
     C                   ENDDO                                                                203798
                                                                                CAP004
     C                   ENDSR                                                  CAP004
                                                                                CAP004
      *****************************************************************         CAP004
      /EJECT                                                                    CAP004
      *****************************************************************
      *                                                               *
      * SRRdSfl - SubFile Details Generation Routine                  *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRRdSfl       BEGSR
      *
      ** Read the subfile for selected records
      ** Only process those for which the option field is not blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
     C     WTRAD         IFNE      'F'                                          CAP004
     C                   READC     SEDPMVS1                               99
     C                   ELSE                                                   CAP004
     C                   READC     SEDPMVS3                               99    CAP004
     C                   END
     C                   END
      *
      **  Return the selected deal number and option
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
 
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'D'
     C/COPY WNCPYSRC,SEDPMVBC07
     C                   MOVE      DDOPT         @OptSel
     C                   ELSE
     C                   MOVE      'E'           @OptSel
     C                   END
 
     C                   MOVE      DDDPRN        @RefSel
     C                   MOVE      DDDPSS        @SecSel
 
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFmtDet - Routine to change the file format transaction to   *
      *            Screen format.                                     *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls:  SRCvtDat                                              *
      *                                                               *
      ******************************************************************
 
     C     SRFmtDet      BEGSR
      *
      ** Reference Number
      *
     C                   MOVE      DPRN          DDDPRN
      *                                                                         CAP004
      * Front Office Identifier                                                 CAP004
      *                                                                         CAP004
     C                   MOVE      DMFRNT        DDFODN                         CAP004
      *
      ** Security Shortname
      *
     C                   MOVE      DPSS          DDDPSS
      *
      ** Walk In
      *
     C     DPMV          IFEQ      'WI'
      *
      ** In Depot
      ** In Date
      *
     C                   MOVE      DPID          DDDEPOT
 
     C                   MOVE      *BLANKS       DDDATE
 
     C     DPMD          IFNE      999999
     C                   Z-ADD     DPMD          ZDAYNO            5 0
 
     C                   EXSR      SRCvtDat
 
     C                   MOVE      ZDATE         DDDATE
     C                   ELSE
     C                   MOVE      '999999'      DDDATE
     C                   END
 
     C                   END
 
     C     DPMV          IFEQ      'WO'
      *
      ** Out Depot
      ** Sub-header
      ** Out Date
      *
     C                   MOVE      DPOD          DDDEPOT
      *
     C                   MOVE      *BLANKS       DDDATE
 
     C     DPDO          IFNE      999999
     C                   Z-ADD     DPDO          ZDAYNO
 
     C                   EXSR      SRCvtDat
 
     C                   MOVE      ZDATE         DDDATE
     C                   ELSE
     C                   MOVE      '999999'      DDDATE
     C                   END
 
     C                   END
      *
      ** Booking Branch
      *
     C                   MOVE      DPBA          DDDPBA
      *
      ** Book
      *
     C                   MOVE      DPBK          DDDPBK
      *
      ** Customer
      *
     C                   MOVE      DPBN          DDDPBN
      *
      ** Nominal
      *
      ** Retreive Nominal decimal position from Security
      *
     C     DPSS          CHAIN     SECTY                              98
      *
      ** DATABASE ERROR
      *
     C     *IN98         IFEQ      '1'
     C                   MOVEL     DPSS          DBKEY                         ***********
     C                   MOVEL     'SECTYD'      DBFILE                        * DBERR 01*
     C                   MOVEL     '001'         DBASE                         ***********
     C                   EXSR      *PSSR
 
     C                   ELSE
      *
      ** Format Nominal Amount
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DPNA          ZFIELD
     C                   MOVE      NMDP          ZADEC
 
     C                   EXSR      SRZEDIT
 
     C                   MOVE      ZFIELD        DDDPNA
 
     C                   END
      *                                                                                       CSE016
      ** Format security report description                                                   CSE016
      *                                                                                       CSE016
     C                   MOVE      *BLANKS       DDSRNM                                       CSE016
      *                                                                                       CSE016
     C     DDDPSS        IFNE      *BLANKS                                                    CSE016
      *                                                                                       CSE016
     C                   CALLB     'ZSDESC'                                                   CSE016
     C                   PARM      SRPN          PSRPN                                        CSE016
     C                   PARM                    PSFN1                                        CSE016
     C                   PARM                    PSFN2                                        CSE016
     C                   PARM                    CPNR                                         CSE016
     C                   PARM                    MATY                                         CSE016
     C                   PARM                    SCPP                                         CSE016
     C                   PARM                    SCPD                                         CSE016
     C                   PARM      BVRIDF        PRSFD                                        CSE016
     C                   PARM                    SCPI                                         CSE016
     C                   PARM                    PRNME                                        CSE016
     C                   PARM                    PFNM1                                        CSE016
     C                   PARM                    PFNM2                                        CSE016
     C                   PARM                    PFNM3                                        CSE016
      *                                                                                       CSE016
     C                   EVAL      DDSRNM = PRNME                                             CSE016
     C                   ENDIF                                                                CSE016
      *
      **  If the deal has been deleted then show this.
      *
     C     RECI_DPMV     IFEQ      'R'
     C     RECI_DPMV     OREQ      '*'
     C                   MOVE      '1'           *IN95
     C                   MOVEL     'ZZGBMSGF'    MSGNM
     C                   MOVEL     'ZZM1614'     MSGDNB
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB            7
     C                   PARM                    MSGNM            10
     C                   PARM                    MSGTXT           80
     C                   MOVEL     MSGTXT        DDTEXT
     C                   ELSE
     C                   MOVE      '0'           *IN95
     C                   MOVE      *BLANKS       DDTEXT
     C                   END
     C/COPY WNCPYSRC,SEDPMVBC08
 
     C                   ENDSR
 
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdTrans- Subroutine to Retrieve a valid Record from the     *
      *            Transaction file.                                  *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRRdTrans     BEGSR
      *
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C     @@EOF         DOUEQ     'Y'
     C     @@ERR         OREQ      *ZERO
     C     DPMV          ANDEQ     DPMVType
     C
      *
      **  Read the file.
     C/COPY WNCPYSRC,SEDPMVBC09
      *
     C     WTRAD         IFEQ      'B'                                          CAP004
     C     @@DPSS        IFEQ      *BLANK                                                     203798
     C     @@DPRN        ANDNE     *BLANK                                                     203798
     C                   READ      DPTMVR                                 96                  203798
     C                   ELSE                                                                 203798
     C                   READ      DPTMV                                  96
     C                   ENDIF                                                                203798
     C                   ELSE                                                   CAP004
     C                   READ      DPTMVFO                                96    CAP004
     C                   MOVE      RECI          RECI_DPMV
     C                   END                                                    CAP004
     C/COPY WNCPYSRC,SEDPMVBC10
      *
      ** End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   END
      *
      ** If deal read, check whether user can see it
      ** No check required if called from another program eg SE4400                           CSE039
      *
     C     CallProg      IfEq      *Blanks                                                    CSE039
     C     @@EOF         IFNE      'Y'
 
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    DPBA
     C                   PARM                    @@ERR
 
     C     BKOBUV        IFEQ      'Y'
     C     @@ERR         ANDEQ     *ZERO
     C                   CALL      'ZVOBU'
     C                   PARM                    ORBR
     C                   PARM                    @@ERR
     C                   END
 
     C                   END
     C                   END
     C                   EndIf                                                                CSE039
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  203798
      *****************************************************************                       203798
      * UPD_SELECT - UPDATE RECORD SELECTION FIELDS                                           203798
      *****************************************************************                       203798
     C     UPD_SELECT    BEGSR                                                                203798
                                                                                              203798
     C                   MOVEL     DDPSS         CurrDPSS                                     203798
     C                   MOVEL     DDPRN         CurrDPRN                                     203798
                                                                                              203798
     C                   ENDSR                                                                203798
      *****************************************************************                       203798
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkAut - Subroutine to Check for user's Authority           *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
     C     SrChkAut      BEGSR
      *
      * If called from SE4400 (Securities Movements Enquiry) skip                             CSE039
      * SPF processing.                                                                       CSE039
     C     CallProg      IFEQ      *BLANKS                                                    CSE039
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      ** Return Error Message
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   END
     C                   ENDIF                                                                CSE039
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValRef - Validate Reference Number                          *
      *                                                               *
      * Called by: SRBldSfl                                           *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SrValRef      BEGSR
      *
      ** Validate that the Reference Number is numeric or blank
      *
     C*******************TESTN                   DDDPRN               98        CAP004
     C                   TESTN                   DDPRN                98        CAP004
     C*******************MOVE      DDDPRN        @@TEST            1            CAP004
     C                   MOVE      DDPRN         @@TEST            1            CAP004
     C                   TESTZ                   @@TEST                   99
 
     C*****DDDPRN        IFEQ      *BLANKS                                      CAP004
     C     DDPRN         IFEQ      *BLANKS                                      CAP004
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C*******************MOVE      DDDPRN        @@DPRN                         CAP004
     C                   MOVE      DDPRN         @@DPRN                         CAP004
      *
      ***Return*Error*Message**************************                                       203798
      *
     C                   ELSE
     C*******************MOVEL*****'MMA0425'*****@ERRMS                                       203798
     C*******************RETURN******************                                             203798
     C                   MOVEL     *BLANK        @@DPRN                                       203798
     C                   END
      *
      ** Security
      *
     C*******************MOVE      DDDPSS        @@DPSS                         CAP004
     C                   MOVE      DDPSS         @@DPSS                         CAP004
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZEDIT - Format amount for screen output                     *
      *                                                               *
      * Called by: SRFmtDet                                           *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRZEDIT       BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      NMDP          ZADEC             1 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCvtDat - Convert Midas Date to DDMMYY (OR MMDDYY)           *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCvtDat      BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM                    ZADATE            7            Run-date in DDM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit- Initializtion Routine                                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
      *
      ** Clear Outputs
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OptSel
     C                   MOVE      *BLANK        @RefSel
     C                   MOVE      *BLANK        @SecSel
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
     C                   MOVE      '0'           *IN20                          CAP004
 
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - Exception Errors                                      *
      *                                                               *
      * Called by: *InzSR                                             *
      *                                                               *
      * Calls:  *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SEDPMVBRW'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
      *
      **  Terminte the program
      *
     C                   EXSR      *PSSR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *InzSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Received Parameters
      ** -------------------
      *
      ** Action Code
      ** Reference Number
      ** Security Shortname
      ** Build SubFile Indicator
      ** Read SubFile Indicator
     C                   PARM                    DDACTN            1
     C*******************PARM                    DDDPRN            6            CAP004
     C                   PARM                    DDPRN             6            CAP004
     C*******************PARM                    DDDPSS           10            CAP004
     C                   PARM                    DDPSS            10            CAP004
     C                   PARM                    DPMVType          2
     C                   PARM                    CallProg         10                          CSE039
     C                   PARM                    @BldSfl           1
     C                   PARM                    @RdSfl            1
      *
      ** Returned Parameters
      ** -------------------
      *
      ** Command Keys
      ** F3
      ** F12
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      ** Error Code
      *
     C                   PARM                    @ERRMS            7
      ** Option Selected
      ** Transaction Reference Number Selected
      ** Security Shortname Selected
     C                   PARM                    @OptSel           1
     C                   PARM                    @RefSel           6
     C                   PARM                    @SecSel          10
      *
      ** ICD Information Retrieval
      ** -------------------------
      *
      ** Initialize program name
      *
     C                   MOVEL     'SEDPMVBRW'   DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
      *
      ** Get Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '900'         DBASE                          * DBERR 900*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** Get General Ledger ICD
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   EXSR      SRERR                                        ************
     C                   END
                                                                                              CSE016
     C                   CALL      'AOSTRDR0'                                                 CSE016
     C                   PARM      *BLANKS       @RTCD                                        CSE016
     C                   PARM      '*FIRST'      @OPTN                                        CSE016
     C     SDSTRD        PARM      SDSTRD        DSSDY                                        CSE016
      *                                                                                       CSE016
      ** Database Error                                                                       CSE016
      *                                                                                       CSE016
     C     @RTCD         IFNE      *BLANKS                                                    CSE016
     C                   MOVEL     '*FIRST '     DBKEY                                        CSE016
     C                   MOVEL     'SDSTRDPD'    DBFILE                                       CSE016
     C                   MOVEL     '902'         DBASE                                        CSE016
     C                   EXSR      SRERR                                                      CSE016
     C                   ENDIF                                                                CSE016
                                                                                              203798
     C/COPY WNCPYSRC,SEDPMVBC11
     C     @@FOTDK       KLIST                                                                203798
     C                   KFLD                    @@FOTD                                       203798
     C                   KFLD                    @@DPSS2                                      203798
     C                   KFLD                    @@DPRN2                                      203798
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
