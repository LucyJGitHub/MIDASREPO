     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG Edit Group Set  Edit record(1 screen)')
/*OVRF*: OVRDBF (File in program) (file on system)                  : *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                      *
     F*                                                               *
     F*  CG1030   Edit Group Set            Edit record(1 screen)     *
     F*                                                               *
     F*  Function:  This program xxxxxxxxxxxxxxxxxxxxxxxxxxxx         *
     F*  (phase(s))                                                   *
     F*                                                               *
     F*  Called By: mmCnnnn - (program name)                          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD054955           Date 16Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG2330            Date 29Apr04               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 115722             Date 12Feb98               *
      *                 085783             Date 05Apr95               *
     F*                 084569             DATE 10MAR95               *
     F*                 S01522             DATE 22NOV94               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
     F*  BUG2330- CG programs looking at wrong dataarea for CSC022    *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
     F*  115722 - Comment out references to CGUSRMSG/CGD1001          *
     F*  085783 - Correct /COPY statements.                           *
     F*  084569 - Provide additional validation (CG1025)              *
     F*  S01522 - User Defined Correspondence                         *
     F*                                                               *
     F*****************************************************************
     F*EDTRCD: Cpysrc Templates Initialise Program F-spec
     F/COPY WNCPYSRC,CG1030DFPG
     FCG1030DF  CF   E             WORKSTN
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Edit Group Set            Edit record(1 screen)
      *
     F*CGGSETL1* IF   E           K DISK                                                    MD054955
     F**********                           INFDS(INFDS1)                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      * RTV : Group Set Definition      Retrieval index
      *
     F*CGGSETL0* UF A E           K DISK    USROPN                                          MD054955
     F**********                           COMMIT                                           MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      * UPD : Group Set Definition      Update index
      *
     F*********** CGGSASL1IF  E           K        DISK                   084569
     F***********                                   KINFSR SRFILE         084569
      *                                                                   084569
      *********** Group set association retrieval index.                  084569
      *                                                                   084569
     F*********** CGRASCL2IF  E           K        DISK                   084569
     F***********                                   KINFSR SRFILE         084569
      *                                                                   084569
      *********** RDE association table by group/RDE/order.               084569
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D*  Array containing Copyright statement
     D***************** FIRST COMPILE TIME ARRAY *********************
      *                                                                                       CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      *                                                                                       CSC022
     D WCMT            S             10    DIM(10)
     D*
     D*COPY*CGCPYSRC,SRERRE                                                                 MD054955
     D/COPY CGCPYSRC,SRERRDLE                                                               MD054955
     D*
     D*  Copysource for error processing
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program E-spec
     D/COPY WNCPYSRC,CG1030DEPG
     D CGGSET        E DS                  EXTNAME(CGSETJW0)                                MD054955
     D*COPY*CGCPYSRC,SRERRI                                                                 MD054955
     D*
     D*  End of Program Error Processing copysource
     D*
     D*
     D*EDTRCD: Cpysrc Templates Initialise Program I-spec
     D/COPY WNCPYSRC,CG1030DIPG
      /EJECT
      * Data structures:
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D*@1DBRC***     E DS                  EXTNAME(CGGSETL0)                                MD054955
     D @1DBRC        E DS                  EXTNAME(CGSETJW0)                                MD054955
     D                                     PREFIX(X)                                        MD054955
      * UPD : Group Set Definition      Update index
      * Current/previous master file format fields for change control
      *
     D*#1DBRC***       DS            76                                                     MD054955
     D #1DBRC          DS            77                                                     MD054955
      * Stored master file format fields
     D  #1DB1                  1      1
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D*
     D* Get Rundate - Rundate  *
     D*
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
     D*
     D* Modules Data Structure *
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D*                                                                   S01194
     D* Data Structures used by Access Programs                           S01194
     D*                                                                   S01194
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01194
     D*                                                                   S01194
     D* Data Structures used by Access Programs                           S01194
     D*                                                                   S01194
      *                                                                                       CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      * Switchable Features Details accessed via Access Program                               CSC022
      *                                                                                       CSC022
     D WDSJOB        E DS                  EXTNAME(SCCMTJOB)
     D  WCMTNO       E                     EXTFLD(COMITNUM)
     D  WJOB01       E                     EXTFLD(COMITJOB1)
     D  WJOB02       E                     EXTFLD(COMITJOB2)
     D  WJOB03       E                     EXTFLD(COMITJOB3)
     D  WJOB04       E                     EXTFLD(COMITJOB4)
     D  WJOB05       E                     EXTFLD(COMITJOB5)
     D  WJOB06       E                     EXTFLD(COMITJOB6)
     D  WJOB07       E                     EXTFLD(COMITJOB7)
     D  WJOB08       E                     EXTFLD(COMITJOB8)
     D  WJOB09       E                     EXTFLD(COMITJOB9)
     D  WJOB10       E                     EXTFLD(COMITJOB10)
     D  WCJOBS                 4    103
      ** Commitment Control dataarea                                                          CSC022
      *                                                                                       CSC022
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I : MAP Action Code
     D  P1ACTC                 1      1
     D P2PARM          DS             6
      * KEY: Group Set Definition      Retrieval index
      * I : MAP Group Set Name
     D  P2GRPS                 1      6
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Invalid Action code (FT)'
      * Action Code
     D  ZA0001                 1      1
      *
     D DSMTR           DS
      *
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
      /EJECT
      *
      * Data to be passed to window processing
      *
     D/COPY QWINDSRC,CG1030WDTA
     D*...................................................................084569
     D P3PARM          DS                                                       084569
     D*                                                                   084569
     D* The P3PARM data structure passes group set details                084569
     D*  to program CG1025, as follows:                                   084569
     D*                                                                   084569
     D*  > P3GSET -- the group set name;                                  084569
     D*  > P3CSI  -- the complex set indicator;                           084569
     D*  > P3MI   -- the multiple indicator;                              084569
     D*  > P3RSI  -- the restricted set indicator; and                    084569
     D*  > P3MMG  -- the mail merge group flag.                           084569
     D*                                                                   084569
     D  P3GSET                 1      6                                         084569
     D  P3CSI                  7      7                                         084569
     D  P3MI                   8      8                                         084569
     D  P3RSI                  9      9                                         084569
     D  P3MMG                 10     10                                         084569
     D*...................................................................084569
     D* Named constants:                                                  084569
     D*                                                                   084569
     D* #MSG01 -- Message identifier for error 1 --                       084569
     D*           Records were found for this group set                   084569
     D*            on the RDE association table                           084569
     D*            (complex set indicator is T or Y)                      084569
     D*                                                                   084569
     D* #MSG02 -- Message identifier for error 2 --                       084569
     D*           Records were found for this group set                   084569
     D*            on the group set association table                     084569
     D*            (complex set indicator is N)                           084569
     D*                                                                   084569
     D* #MSG03 -- Message identifier for error 3 --                       084569
     D*           Records were found for this group set                   084569
     D*            on the RDE association table                           084569
     D*            (multiple indicator is T or Y)                         084569
     D*                                                                   084569
     D* #MSG04 -- Message identifier for error 4 --                       084569
     D*           A record was found for a parent group set               084569
     D*            in the group sets definitions file                     084569
     D*            with a multiple indicator of "N" (No)                  084569
     D*            (multiple indicator is Y)                              084569
     D*                                                                   084569
     D #MSG01          C                   CONST('CGD1831')
     D #MSG02          C                   CONST('CGD1832')
     D #MSG03          C                   CONST('CGD1833')
     D #MSG04          C                   CONST('CGD1834')
     I*                                                                   084569
     I* Note: this list must be kept matched with the similar list in     084569
     I*       program CG1025, since it is used to select which item       084569
     I*       is highlighted as being in error.                           084569
     I********************************************************************084569
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1            Action Code
     C                   PARM                    P2PARM                         KEY: Group Set
      *
      *  Set up primary reference
      *
     C                   MOVEL     P2PARM        W0PREF
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
      * Check passed parameters
     C                   EXSR      FACKPM
      * Perform once if all passed, else repeat
     C     W0RPT         DOUEQ     'N'
      * Display and process key screen
     C                   EXSR      BADSKY
     C                   END
      * Terminate program
     C                   EXSR      ZXEXPG
      *****************************************************************
      /EJECT
     CSR   BADSKY        BEGSR
      *================================================================
      * Display and process key screen
      *================================================================
      * Initialize key screen
     C                   EXSR      MDIZ#K
      * Bypass first display of key screen is possible
     C                   MOVEL     'Y'           W0BYP             1
      * Signal start of transaction
     C                   MOVEL     'Y'           W0TRN             1
     C     W0TRN         DOWEQ     'Y'
     C     W0TRN         OREQ      'K'
      * Ensure transaction continues (if reset)
     C                   MOVEL     'Y'           W0TRN             1
      * Conduct screen conversation
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1GRPS        IFEQ      *BLANK                                       Group Set Name
      * One or more key fields is blank
     C                   MOVEL     'N'           W0BYP
     C                   END
     C                   END
      * Bypass key screen
     C     W0BYP         IFNE      'Y'
      * Display key screen
     C                   EXSR      BBEXFM
     C                   END
      * Cancel key screen bypass
     C                   MOVEL     'N'           W0BYP
      * Process response to key screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
     C   12              CAS                     ZXEXPG
      * HOME: Reset screen fields
     C   05              CAS                     BDHMKY
      * Process key screen input
     C                   CAS                     BEPRKY
     C                   END
     C     W0TRN         DOWEQ     'R'
     C                   MOVEL     'Y'           W0TRN
     C                   EXSR      BEPRKY
     C                   END
      *
     C                   END
     C                   END
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBEXFM        BEGSR
      *================================================================
      * Display key screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GADSAK
      * Update screen time
     C                   TIME                    ##TME
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      BBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         BBIN89            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDKEY
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   BDHMKY        BEGSR
      *================================================================
      * Process HOME key
      *================================================================
     C                   MOVEL     'N'           W0TRN
      *================================================================
     CSR   BDEXIT        ENDSR
      /EJECT
     CSR   BEPRKY        BEGSR
      *================================================================
      * Process key screen input
      *================================================================
      * Initialise detail screen
     C                   EXSR      MAIZ#1
      * Validate key fields
     C                   EXSR      BFVLKY
     C     *IN99         CABEQ     '1'           BEEXIT
      * Check for existing record
     C     KRTV          KLIST
     C                   KFLD                    GSGRPS                         Group Set Name
      * Setup key
     C                   MOVEL     #1GRPS        GSGRPS                         Group Set Name
     C*****KRTV*         CHAIN     @GSETL1                            9091      *
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGGSET                                                                        MD054955
     C+ from CGSETJW0                                                                       MD054955
     C+ where GSGRPS = :GSGRPS and GSRECI = 'D'                                             MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       9091                  MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD054955
     C                   SETON                                        91                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
      * Send message 'Record Exists'
      *
     C     *IN90         IFEQ      '0'
     C     P1ACTC        ANDEQ     'I'
     C                   MOVEL     'CGD1112'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   SETON                                        9931      *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * If record does not exist, flip to add mode
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'ADD'         W0PMD
      * USER: Initialize detail screen (new record)
      * EDTRCD: Init. det. scr NW - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Dtl New Rcd
     C/COPY WNCPYSRC,CG1030DISN
     C                   ELSE
      * If record does exist, flip to change mode
     C                   MOVEL     'CHG'         W0PMD
      * Load screen fields from DBF
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * EDTRCD: Detail scrn funcs - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Calc Detail Function Flds
     C/COPY WNCPYSRC,CG1030DSFF
      * USER: Initialize detail screen (existing record)
      * EDTRCD: Init. det. scr EX - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Dtl Exist Rcd
     C/COPY WNCPYSRC,CG1030DISE
     C                   END
      *..................................................
     C   99              GOTO      BEEXIT
      *
      * No error: Display and process details
     C                   EXSR      CADSDA
      *
      *================================================================
     CSR   BEEXIT        ENDSR
      /EJECT
     CSR   BFVLKY        BEGSR
      *================================================================
      * Validate key fields
      *================================================================
      * USER: Validate key screen
      * EDTRCD: Valid key screen - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Key Screen
     C/COPY WNCPYSRC,CG1030DVKS
      *
      * Group Set Name required
      *
     C     #1GRPS        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
     C                   MOVEL     'CGD1090'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  Group set may not contain "\"
      *
     C     '\'           SCAN      #1GRPS                                 90
     C     *IN90         IFEQ      '1'
     C                   SETON                                        9931      *
     C                   MOVEL     'CGD1091'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *================================================================
     CSR   BFEXIT        ENDSR
      /EJECT
     CSR   CADSDA        BEGSR
      *================================================================
      * Display and process detail screen
      *================================================================
      * Conduct detail screen conversation
      * - repeat until screen control flag is reset:
     C     W0TRN         DOWEQ     'Y'
      * Display detail screen
     C                   EXSR      CBEXFM
      * Process response to detail screen
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
      * HOME: Reset screen fields
     C   05              CAS                     CCDSPV
      * Process detail screen input
     C                   CAS                     CFPRSC
     C                   END
     C     W0TRN         IFEQ      'R'
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'Y'           W0TRN
     C                   EXSR      MAIZ#1
     C                   END
     C                   END
      *
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   CBEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GBDSAD
      * Update screen time
     C                   TIME                    ##TME
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      * PUTOVR unless conditioned fields change
     C                   SETON                                            86    *
     C     *IN89         IFNE      CBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         CBIN89            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator
     C                   SETOFF                                           99    *
      *================================================================
     CSR   CBEXIT        ENDSR
      /EJECT
     CSR   CCDSPV        BEGSR
      *================================================================
      * Redisplay previous screen
      *================================================================
      * USER: Process key screen request
      * EDTRCD: Process key req. - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Process Key Screen Rqst
     C/COPY WNCPYSRC,CG1030DPKR
     C   05              MOVEL     'R'           W0TRN
      *
      * If insert go to key screen else exit
      *
     C     *IN12         IFEQ      '1'
     C     P1ACTC        IFEQ      'I'
     C                   MOVEL     'K'           W0TRN
     C                   ELSE
     C                   EXSR      ZXEXPG
     C                   END
     C                   END
      *================================================================
     CSR   CCEXIT        ENDSR
      /EJECT
     CSR   CFPRSC        BEGSR
      *================================================================
      * Validate record
      *================================================================
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * If delete is not pending....
      * Validate details
     C     P1ACTC        IFEQ      'I'
     C     P1ACTC        OREQ      'A'
     C  N10              CAS                     DCVLDL
     C                   END
     C                   END
      *
      *  Check referential integrity if delete
      *
     C     P1ACTC        IFEQ      'D'
     C                   EXSR      SRREFI
     C                   END
      *
      *  Call window processing
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      SRWIND
     C                   END
      * QUIT if error:
     C   99              GOTO      CFEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           CFEXIT
      * No error: update record
     C     P1ACTC        IFEQ      'A'
     C     P1ACTC        OREQ      'I'
     C     P1ACTC        OREQ      'D'
     C     *IN10         ANDEQ     '1'
     C                   EXSR      EBPR##
     C                   END
      *
      * Exit if enquire
      *
     C     P1ACTC        IFEQ      'E'
     C                   MOVEL     'N'           W0RPT
     C                   MOVEL     'N'           W0TRN
     C                   END
      *================================================================
     CSR   CFEXIT        ENDSR
      /EJECT
     CSR   DCVLDL        BEGSR
      *================================================================
      * Validate details
      *================================================================
      * USER: Validate detail screen fields
      * EDTRCD: Valid det. scrn - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Detail Screen
     C/COPY WNCPYSRC,CG1030DVSF
      * CALC: Detail screen function fields
      * EDTRCD: Detail scrn funcs - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Calc Detail Function Flds
     C/COPY WNCPYSRC,CG1030DSFF
      * USER: Validate detail screen relations
      * EDTRCD: Detail scrn rels - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Validate Screen Relns
     C/COPY WNCPYSRC,CG1030DVSR
      * Complex Set Indicator required
     C     #1CSET        IFNE      'N'                                          IF
     C     #1CSET        ANDNE     'Y'                                          IF
     C     #1CSET        ANDNE     'T'                                          IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'CGD1429'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Multiple Indicator required
     C     #1MREC        IFNE      'N'                                          IF
     C     #1MREC        ANDNE     'Y'                                          IF
     C                   SETON                                        9932      *
      * Send message '*Value required'
     C                   MOVEL     'CGD1430'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Restricted Set Indicator required
     C     #1RSET        IFNE      'N'                                          IF
     C     #1RSET        ANDNE     'Y'                                          IF
     C                   SETON                                        9933      *
      * Send message '*Value required'
     C                   MOVEL     'CGD1431'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Mail Merge Group required
     C     #1MMGR        IFNE      'N'                                          IF
     C     #1MMGR        ANDNE     'Y'                                          IF
     C                   SETON                                        9934      *
      * Send message '*Value required'
     C                   MOVEL     'CGD1432'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Description required
     C     #1DESC        IFEQ      *BLANK                                       IF
     C                   SETON                                        9935      *
      * Send message '*Value required'
     C                   MOVEL     'CGD1348'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      * Cross Validations
      *
     C     *IN99         IFEQ      '0'
     C                   EXSR      SRXVAL
     C                   END
      *================================================================
     CSR   DCEXIT        ENDSR
     C/EJECT
      *================================================================
      *                                                               *
      *  SRXVAL   : Validate Cross Validations                        *
      *                                                               *
      *================================================================
     CSR   SRXVAL        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRXVAL'      @STK(Q)
      *
      *   /COPY for extra validation
      *
      /COPY WNCPYSRC,CG1030XVAL
      *
      *  Check that complex set and repeating are compatible
      *
     C     #1CSET        IFEQ      'N'                                          IF
     C     #1MREC        ANDEQ     'Y'                                          IF
     C                   SETON                                        993132    *
      * Send message '*Value required'
     C                   MOVEL     'CGD1433'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
      *  Check that Restricted set and repeating are compatible
      *
     C     #1RSET        IFEQ      'N'                                          IF
     C     #1MREC        ANDEQ     'Y'                                          IF
     C                   SETON                                        993132    *
      * Send message '*Value required'
     C                   MOVEL     'CGD1435'     ZAMSID
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *
     C*********** If complex then no RDEs should be defined               084569
     C***********                                                         084569
     C********** #1CSET    IFEQ 'Y'                        IF             084569
     C***********                                                         084569
     C********** KGRPS     KLIST                                          084569
     C***********          KFLD           #1GRPS                          084569
     C***********                                                         084569
     C********** KGRPS     SETLLCGRASCL2                                  084569
     C********** KGRPS     READECGRASCL2                 90               084569
     C***********                                                         084569
     C********** *IN90     IFEQ '0'                        IF             084569
     C***********          SETON                     9931  *              084569
     C*********** Send message '*Value required'                          084569
     C***********          MOVEL'CGD1435' ZAMSID                          084569
     C***********          EXSR ZASNMS                                    084569
     C***********          END                             FI             084569
     C***********          END                             FI             084569
     C***********                                                         084569
     C*********** If not complex then no Group sets should be defined     084569
     C***********                                                         084569
     C********** #1CSET    IFEQ 'N'                        IF             084569
     C***********                                                         084569
     C********** KGRPS     SETLLCGGSASL1                                  084569
     C********** KGRPS     READECGGSASL1                 90               084569
     C***********                                                         084569
     C********** *IN90     IFEQ '0'                        IF             084569
     C***********          SETON                     9931  *              084569
     C*********** Send message '*Value required'                          084569
     C***********          MOVEL'CGD1435' ZAMSID                          084569
     C***********          EXSR ZASNMS                                    084569
     C***********          END                             FI             084569
     C***********          END                             FI             084569
     C*                                                                   084569
     C* Provide additional validation using CG1025:                       084569
     C*                                                                   084569
     C                   MOVE      #1GRPS        P3GSET                                        08456
     C                   MOVE      #1CSET        P3CSI                                         08456
     C                   MOVE      #1MREC        P3MI                                          08456
     C                   MOVE      #1RSET        P3RSI                                         08456
     C                   MOVE      #1MMGR        P3MMG                                         08456
     C*                                                                   084569
     C                   CALL      'CG1025'                                                    08456
     C                   PARM                    P3RTN             7                           08456
     C                   PARM                    P3PARM           10                           08456
     C                   PARM      ##PGM         P3PGM            10                           08456
     C*                                                                   084569
     C     P3RTN         IFNE      *BLANKS                                                     08456
     C                   SETON                                        99                       08456
     C                   MOVE      P3RTN         ZAMSID                                        08456
     C                   EXSR      ZASNMS                                                      08456
     C*                                                                   084569
     C* Which item?                                                       084569
     C                   SELECT                                                                08456
     C     P3RTN         WHENEQ    #MSG01                                                      08456
     C                   SETON                                        31                       08456
     C     P3RTN         WHENEQ    #MSG02                                                      08456
     C                   SETON                                        31                       08456
     C     P3RTN         WHENEQ    #MSG03                                                      08456
     C                   SETON                                        32                       08456
     C     P3RTN         WHENEQ    #MSG04                                                      08456
     C                   SETON                                        32                       08456
     C                   ENDSL                                                                 08456
     C*                                                                   084569
     C                   ENDIF                                                                 08456
     C*
      *  Unwind subroutine stack name
      *
     C     EXXVAL        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C/EJECT
      *================================================================
      *                                                               *
      *  SRREFI   : Referential Integrity Check                       *
      *                                                               *
      *================================================================
     CSR   SRREFI        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRREFI'      @STK(Q)
      *
      *   /COPY for extra validation
      *
      /COPY WNCPYSRC,CG1030REFI
      *
      *  Call referential integrity check process
      *
     C                   CALL      'CG0230'                             9090
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      #1GRPS        P@GRPS            6
     C                   PARM      ##PGM         P@CPGM           10
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'CG0230'      W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  If return code non-blank send message
      *
     C     P@RTCD        IFNE      *BLANK                                       IF
     C                   SETON                                        99        *
      * Send message '*Value required'
     C                   MOVEL     P@RTCD        ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      EXREFI
     C                   END                                                    FI
      *
      *  Unwind subroutine stack name
      *
     C     EXREFI        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record:
      *================================================================
      * Process delete request
     C   10              CAS                     EDDLRQ
      * Process add request
     C     W0PMD         CASEQ     'ADD'         ECADRQ
      * Process update request
     C     W0PMD         CASNE     'ADD'         EECHRQ
     C                   END
     C     W0RTN         IFNE      *BLANK
      * Error: ROLLBACK any DBF changes
     C     CSC022        IFEQ      'N'
     C     CSC022        OREQ      'Y'
     C     WCMTSK        ANDEQ     'N'
     C                   ROLBK
     C                   ELSE
     C                   SETON                                        U7U8
     C                   ENDIF
     C                   GOTO      EBEXIT
     C                   ELSE
      * Otherwise COMMIT any DBF changes
     C     CSC022        IFEQ      'N'
     C     CSC022        OREQ      'Y'
     C     WCMTSK        ANDEQ     'N'
     C                   COMMIT
     C                   ENDIF
     C                   END
     C     W0RTN         IFEQ      *BLANK
      * USER: Process command keys
      * EDTRCD: Process cmds - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Process Command Keys
     C/COPY WNCPYSRC,CG1030DPCK
     C     W0PMD         IFEQ      'ADD'
      * Exit after successful add
     C                   MOVEL     'R'           W0RPT
     C                   END
      * Restart program for next record
     C                   MOVEL     'N'           W0TRN
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
      * Create Group Set - Group Set Definition  *
     C                   EXSR      SACRRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record added'
     C                   MOVEL     'Y2U0011'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request
      *================================================================
      * USER: Delete DBF record
      * Delete Group Set - Group Set Definition  *
     C                   EXSR      SCCHRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record deleted'
     C                   MOVEL     'Y2U0013'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request
      *================================================================
      * USER: Change DBF record
      * Change Group Set - Group Set Definition  *
     C                   EXSR      SDCHRC
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Reset screen fields if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1
     C                   END
     C                   ELSE
      * Send message '*Record changed'
     C                   MOVEL     'Y2U0012'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACKPM        BEGSR
      *================================================================
      * Check passed parameters
      *================================================================
      * Is full key present?
     C     P2GRPS        IFEQ      *BLANK                                       Group Set Name
      * Not every key field passed - loop program
     C                   MOVEL     'Y'           W0RPT             1
     C                   ELSE
      * Full key passed, so single shot program
     C                   MOVEL     'N'           W0RPT
     C                   END
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   GADSAK        BEGSR
      *================================================================
      * Set key screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSAD        BEGSR
      *================================================================
      * Set detail screen conditioning indicators
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect key fields on detail screen
     C                   SETON                                        88        *
     C                   MOVEL     '0'           *IN79
     C     P1ACTC        IFEQ      'E'                                          *IF
     C     P1ACTC        OREQ      'D'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN78
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
      * Enable key screen
     C                   SETON                                        87        *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise record - except for key fields and "neither" paramete
      *================================================================
     C                   MOVEL     *BLANK        #1RECI                         Record Identifi
     C                   MOVEL     *BLANK        #1AJOB                         Job name
     C                   MOVEL     *BLANK        #1AACT                         Action Type
     C                   Z-ADD     *ZERO         #1RDNB                         Run day number
     C                   MOVEL     P1ACTC        #PACTC                         Action Code
     C                   MOVEL     *BLANK        #1CSET                         Complex Set Ind
     C                   MOVEL     *BLANK        #1MREC                         Multiple Indica
     C                   MOVEL     *BLANK        #1RSET                         Restricted Set
     C                   MOVEL     *BLANK        #1MMGR                         Mail Merge Grou
     C                   MOVEL     *BLANK        #1DESC                         Description
     C                   MOVEL     *BLANK        #1AUSR                         User name
     C                   Z-ADD     *ZERO         #1ATIM                         Action Time
     C                   MOVEL     *BLANK        #1ARDT                         Action Date
      *
      * Fill Command lines and narrative text from messages
      *
     C                   SELECT
      *
      * Insert screen
      *
     C     P1ACTC        WHENEQ    'I'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1034'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       ##CMD1
      *
      * Function keys
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1021'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
      * Enquiry screen
      *
     C     P1ACTC        WHENEQ    'E'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1035'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       ##CMD1
      *
      * Function keys
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1021'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
      *
      * Amendment screen
      *
     C     P1ACTC        WHENEQ    'A'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1036'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       ##CMD1
      *
      * Function keys
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1021'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
      *
      * Delete screen
      *
     C     P1ACTC        WHENEQ    'D'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1037'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONDT
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       ##CMD1
      *
      * Function keys and allow delete key
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1025'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C                   MOVEL     '1'           *IN77
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
     C                   ENDSL
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @GSETL1 fields to screen
      *================================================================
     C                   MOVEL     GSRECI        #1RECI                         Record Identifi
     C                   MOVEL     GSAJOB        #1AJOB                         Job name
     C                   MOVEL     GSAACT        #1AACT                         Action Type
     C                   Z-ADD     GSRDNB        #1RDNB                         Run day number
     C                   MOVEL     GSGRPS        #1GRPS                         Group Set Name
     C                   MOVEL     GSCSET        #1CSET                         Complex Set Ind
     C                   MOVEL     GSMREC        #1MREC                         Multiple Indica
     C                   MOVEL     GSRSET        #1RSET                         Restricted Set
     C                   MOVEL     GSMMGR        #1MMGR                         Mail Merge Grou
     C                   MOVEL     GSDESC        #1DESC                         Description
     C                   MOVEL     GSAUSR        #1AUSR                         User name
     C                   Z-ADD     GSATIM        #1ATIM                         Action Time
     C                   MOVEL     GSARDT        #1ARDT                         Action Date
      * Hold existing record image
     C                   eval      @1DBRC = CGGSET                                          MD054955
     C                   MOVEL     @1DBRC        #1DBRC
      *
      * Delete screen
      *
     C     P1ACTC        IFEQ      'D'
     C                   MOVEL     '1'           *IN77
     C                   END
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialize key screen
      *================================================================
     C                   MOVEL     P1ACTC        #PACTC                         Action Code
     C                   MOVEL     P2GRPS        #1GRPS                         Group Set Name
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1034'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONKY
      *
      * Action codes
      *
     C                   MOVEL     *BLANKS       #KCMD1
      *
      * Function keys
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1021'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        #KCMD2
      * USER: Initialize key screen
      * EDTRCD: Init. key screen - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Key Screen
     C/COPY WNCPYSRC,CG1030DIKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create Group Set - Group Set Definition  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @GSETL0
     C                   MOVEL     #1GRPS        GSGRPS                         Group Set Name
     C                   MOVEL     'D'           GSRECI                         Record Identifi
     C                   MOVEL     #1CSET        GSCSET                         Complex Set Ind
     C                   MOVEL     #1MREC        GSMREC                         Multiple Indica
     C                   MOVEL     #1RSET        GSRSET                         Restricted Set
     C                   MOVEL     #1MMGR        GSMMGR                         Mail Merge Grou
     C                   MOVEL     #1DESC        GSDESC                         Description
     C                   MOVEL     ##JOB         GSAJOB                         Job name
     C                   MOVEL     ##USR         GSAUSR                         User name
     C                   Z-ADD     ##JTM         GSATIM                         Action Time
     C                   MOVEL     WUMRDT        GSARDT                         Action Date
     C                   MOVEL     'I'           GSAACT                         Action Type
     C                   Z-ADD     WURDNB        GSRDNB                         Run day number
      *
     C     KLCRSA        KLIST
     C                   KFLD                    GSGRPS                         Group Set Name
      * Check for duplicate primary key
     C*****KLCRSA        SETLL     @GSETL0                                90    *
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGGSET                                                                        MD054955
     C+ from CGSETJW0                                                                       MD054955
     C+ where GSGRPS = :GSGRPS                                                              MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 0                                              MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGD1112'     W0RTN             7
      * USER: Processing if Data record already exists
      * Change Group Set - Group Set Definition  *
     C                   EXSR      SBCHRC
     C                   GOTO      SAEXIT
     C                   END
      *
     C**********         WRITE     @GSETL0                              91      *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ insert into CGSETBTD                                                                MD054955
     C+ (                                                                                   MD054955
     C+   GSGRPS                                                                            MD054955
     C+  ,GSRECI                                                                            MD054955
     C+  ,GSCSET                                                                            MD054955
     C+  ,GSMREC                                                                            MD054955
     C+  ,GSRSET                                                                            MD054955
     C+  ,GSMMGR                                                                            MD054955
     C+  ,GSDESC                                                                            MD054955
     C+  ,GSAJOB                                                                            MD054955
     C+  ,GSAUSR                                                                            MD054955
     C+  ,GSATIM                                                                            MD054955
     C+  ,GSARDT                                                                            MD054955
     C+  ,GSAACT                                                                            MD054955
     C+  ,GSRDNB                                                                            MD054955
     C+  ,GSMODE                                                                            MD054955
     C+ )                                                                                   MD054955
     C+ Values                                                                              MD054955
     C+ (                                                                                   MD054955
     C+   :GSGRPS                                                                           MD054955
     C+  ,:GSRECI                                                                           MD054955
     C+  ,:GSCSET                                                                           MD054955
     C+  ,:GSMREC                                                                           MD054955
     C+  ,:GSRSET                                                                           MD054955
     C+  ,:GSMMGR                                                                           MD054955
     C+  ,:GSDESC                                                                           MD054955
     C+  ,:GSAJOB                                                                           MD054955
     C+  ,:GSAUSR                                                                           MD054955
     C+  ,:GSATIM                                                                           MD054955
     C+  ,:GSARDT                                                                           MD054955
     C+  ,:GSAACT                                                                           MD054955
     C+  ,:GSRDNB                                                                           MD054955
     C+  ,'B'                                                                               MD054955
     C+ )                                                                                   MD054955
     C/END-EXEC                                                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ insert into CGSETXTD                                                                MD054955
     C+ (                                                                                   MD054955
     C+   GSGRPS                                                                            MD054955
     C+  ,GSMODE                                                                            MD054955
     C+ )                                                                                   MD054955
     C+ Values                                                                              MD054955
     C+ (                                                                                   MD054955
     C+   :GSGRPS                                                                           MD054955
     C+  ,'B'                                                                               MD054955
     C+ )                                                                                   MD054955
     C/END-EXEC                                                                             MD054955
      *
     C******IN91         IFEQ      '1'                                                      MD054955
     C                   If        (SQLCODE <> 0)                                           MD054955
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Change Group Set - Group Set Definition  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @GSETL0
     C                   MOVEL     #1GRPS        GSGRPS                         Group Set Name
      *
     C     KLCHSB        KLIST
     C                   KFLD                    GSGRPS                         Group Set Name
     C*****KLCHSB        CHAIN     @GSETL0                            9091      *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGGSET                                                                        MD054955
     C+ from CGSETJW0                                                                       MD054955
     C+ where GSGRPS = :#1GRPS                                                              MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       9091                  MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD054955
     C                   SETON                                        91                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SBEXIT
     C                   END
      *
      * Move non-key fields to @GSETL0
     C                   MOVEL     'D'           GSRECI                         Record Identifi
     C                   MOVEL     #1CSET        GSCSET                         Complex Set Ind
     C                   MOVEL     #1MREC        GSMREC                         Multiple Indica
     C                   MOVEL     #1RSET        GSRSET                         Restricted Set
     C                   MOVEL     #1MMGR        GSMMGR                         Mail Merge Grou
     C                   MOVEL     #1DESC        GSDESC                         Description
     C                   MOVEL     ##JOB         GSAJOB                         Job name
     C                   MOVEL     ##USR         GSAUSR                         User name
     C                   Z-ADD     ##JTM         GSATIM                         Action Time
     C                   MOVEL     WUMRDT        GSARDT                         Action Date
     C                   MOVEL     'I'           GSAACT                         Action Type
     C                   Z-ADD     WURDNB        GSRDNB                         Run day number
      *
     C**********         UPDATE    @GSETL0                              91      *           MD054955
     C                   If        GSMODE = 'B'                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGSETBTD set                                                                 MD054955
     C+   GSRECI = :GSRECI                                                                  MD054955
     C+  ,GSCSET = :GSCSET                                                                  MD054955
     C+  ,GSMREC = :GSMREC                                                                  MD054955
     C+  ,GSRSET = :GSRSET                                                                  MD054955
     C+  ,GSMMGR = :GSMMGR                                                                  MD054955
     C+  ,GSDESC = :GSDESC                                                                  MD054955
     C+  ,GSAJOB = :GSAJOB                                                                  MD054955
     C+  ,GSAUSR = :GSAUSR                                                                  MD054955
     C+  ,GSATIM = :GSATIM                                                                  MD054955
     C+  ,GSARDT = :GSARDT                                                                  MD054955
     C+  ,GSAACT = :GSAACT                                                                  MD054955
     C+  ,GSRDNB = :GSRDNB                                                                  MD054955
     C+ where GSGRPS = :#1GRPS                                                              MD054955
     C/END-EXEC                                                                             MD054955
     C                   Endif                                                              MD054955
     C                   If        GSMODE = 'C'                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGSETCTD set                                                                 MD054955
     C+   GSRECI = :GSRECI                                                                  MD054955
     C+  ,GSCSET = :GSCSET                                                                  MD054955
     C+  ,GSMREC = :GSMREC                                                                  MD054955
     C+  ,GSRSET = :GSRSET                                                                  MD054955
     C+  ,GSMMGR = :GSMMGR                                                                  MD054955
     C+  ,GSDESC = :GSDESC                                                                  MD054955
     C+  ,GSAJOB = :GSAJOB                                                                  MD054955
     C+  ,GSAUSR = :GSAUSR                                                                  MD054955
     C+  ,GSATIM = :GSATIM                                                                  MD054955
     C+  ,GSARDT = :GSARDT                                                                  MD054955
     C+  ,GSAACT = :GSAACT                                                                  MD054955
     C+  ,GSRDNB = :GSRDNB                                                                  MD054955
     C+ where GSGRPS = :#1GRPS                                                              MD054955
     C/END-EXEC                                                                             MD054955
     C                   Endif                                                              MD054955
     C******IN91*        IFEQ      '1'                                                      MD054955
     C                   IF        SQLCODE <> 0                                             MD054955
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCCHRC        BEGSR
      *================================================================
      * Delete Group Set - Group Set Definition  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @GSETL0
     C                   MOVEL     #1GRPS        GSGRPS                         Group Set Name
      *
     C     KLCHSC        KLIST
     C                   KFLD                    GSGRPS                         Group Set Name
     C*****KLCHSB        CHAIN     @GSETL0                            9091      *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGGSET                                                                        MD054955
     C+ from CGSETJW0                                                                       MD054955
     C+ where GSGRPS = :#1GRPS                                                              MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       9091                  MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD054955
     C                   SETON                                        91                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SCEXIT
     C                   END
      *
      * Check for changed record
     C                   eval      @1DBRC = CGGSET                                          MD054955
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C*****KLCHSC        SETLL     @GSETL0                            9091      *           MD054955
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *
      * USER: Processing before Data update
     C                   MOVEL     'D'           GSAACT                         Action Type
     C                   MOVEL     '*'           GSRECI                         Record Identifi
     C                   MOVEL     ##JOB         GSAJOB                         Job name
     C                   MOVEL     ##USR         GSAUSR                         User name
     C                   Z-ADD     ##JTM         GSATIM                         Action Time
     C                   MOVEL     WUMRDT        GSARDT                         Action Date
     C                   Z-ADD     WURDNB        GSRDNB                         Run day number
     C**********         UPDATE    @GSETL0                              91      *           MD054955
     C                   If        GSMODE = 'B'                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGSETBTD set                                                                 MD054955
     C+   GSRECI = :GSRECI                                                                  MD054955
     C+  ,GSAJOB = :GSAJOB                                                                  MD054955
     C+  ,GSAUSR = :GSAUSR                                                                  MD054955
     C+  ,GSATIM = :GSATIM                                                                  MD054955
     C+  ,GSARDT = :GSARDT                                                                  MD054955
     C+  ,GSAACT = :GSAACT                                                                  MD054955
     C+  ,GSRDNB = :GSRDNB                                                                  MD054955
     C+ where GSGRPS = :#1GRPS                                                              MD054955
     C/END-EXEC                                                                             MD054955
     C                   Endif                                                              MD054955
     C                   If        GSMODE = 'C'                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGSETCTD set                                                                 MD054955
     C+   GSRECI = :GSRECI                                                                  MD054955
     C+  ,GSAJOB = :GSAJOB                                                                  MD054955
     C+  ,GSAUSR = :GSAUSR                                                                  MD054955
     C+  ,GSATIM = :GSATIM                                                                  MD054955
     C+  ,GSARDT = :GSARDT                                                                  MD054955
     C+  ,GSAACT = :GSAACT                                                                  MD054955
     C+  ,GSRDNB = :GSRDNB                                                                  MD054955
     C+ where GSGRPS = :#1GRPS                                                              MD054955
     C/END-EXEC                                                                             MD054955
     C                   Endif                                                              MD054955
     C******IN91*        IFEQ      '1'                                                      MD054955
     C                   IF        SQLCODE <> 0                                             MD054955
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDCHRC        BEGSR
      *================================================================
      * Change Group Set - Group Set Definition  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @GSETL0
     C                   MOVEL     #1GRPS        GSGRPS                         Group Set Name
      *
     C     KLCHSD        KLIST
     C                   KFLD                    GSGRPS                         Group Set Name
     C*****KLCHSB        CHAIN     @GSETL0                            9091      *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGGSET                                                                        MD054955
     C+ from CGSETJW0                                                                       MD054955
     C+ where GSGRPS = :#1GRPS                                                              MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       9091                  MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD054955
     C                   SETON                                        91                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SDEXIT
     C                   END
      *
      * Check for changed record
     C                   eval      @1DBRC = CGGSET                                          MD054955
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      * Use SETLL to release record lock
     C*****KLCHSD        SETLL     @GSETL0                            9091      *           MD054955
     C                   GOTO      SDEXIT
     C                   END                                                    FI #1DBRC
      * Move non-key fields to @GSETL0
     C                   MOVEL     'D'           GSRECI                         Record Identifi
     C                   MOVEL     #1CSET        GSCSET                         Complex Set Ind
     C                   MOVEL     #1MREC        GSMREC                         Multiple Indica
     C                   MOVEL     #1RSET        GSRSET                         Restricted Set
     C                   MOVEL     #1MMGR        GSMMGR                         Mail Merge Grou
     C                   MOVEL     #1DESC        GSDESC                         Description
     C                   MOVEL     ##JOB         GSAJOB                         Job name
     C                   MOVEL     ##USR         GSAUSR                         User name
     C                   Z-ADD     ##JTM         GSATIM                         Action Time
     C                   MOVEL     WUMRDT        GSARDT                         Action Date
     C                   MOVEL     'A'           GSAACT                         Action Type
     C                   Z-ADD     WURDNB        GSRDNB                         Run day number
      *
     C**********         UPDATE    @GSETL0                              91      *           MD054955
     C                   If        GSMODE = 'B'                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGSETBTD set                                                                 MD054955
     C+   GSRECI = :GSRECI                                                                  MD054955
     C+  ,GSCSET = :GSCSET                                                                  MD054955
     C+  ,GSMREC = :GSMREC                                                                  MD054955
     C+  ,GSRSET = :GSRSET                                                                  MD054955
     C+  ,GSMMGR = :GSMMGR                                                                  MD054955
     C+  ,GSDESC = :GSDESC                                                                  MD054955
     C+  ,GSAJOB = :GSAJOB                                                                  MD054955
     C+  ,GSAUSR = :GSAUSR                                                                  MD054955
     C+  ,GSATIM = :GSATIM                                                                  MD054955
     C+  ,GSARDT = :GSARDT                                                                  MD054955
     C+  ,GSAACT = :GSAACT                                                                  MD054955
     C+  ,GSRDNB = :GSRDNB                                                                  MD054955
     C+ where GSGRPS = :#1GRPS                                                              MD054955
     C/END-EXEC                                                                             MD054955
     C                   Endif                                                              MD054955
     C                   If        GSMODE = 'C'                                             MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGSETCTD set                                                                 MD054955
     C+   GSRECI = :GSRECI                                                                  MD054955
     C+  ,GSCSET = :GSCSET                                                                  MD054955
     C+  ,GSMREC = :GSMREC                                                                  MD054955
     C+  ,GSRSET = :GSRSET                                                                  MD054955
     C+  ,GSMMGR = :GSMMGR                                                                  MD054955
     C+  ,GSDESC = :GSDESC                                                                  MD054955
     C+  ,GSAJOB = :GSAJOB                                                                  MD054955
     C+  ,GSAUSR = :GSAUSR                                                                  MD054955
     C+  ,GSATIM = :GSATIM                                                                  MD054955
     C+  ,GSARDT = :GSARDT                                                                  MD054955
     C+  ,GSAACT = :GSAACT                                                                  MD054955
     C+  ,GSRDNB = :GSRDNB                                                                  MD054955
     C+ where GSGRPS = :#1GRPS                                                              MD054955
     C/END-EXEC                                                                             MD054955
     C                   Endif                                                              MD054955
     C******IN91*        IFEQ      '1'                                                      MD054955
     C                   IF        SQLCODE <> 0                                             MD054955
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * Update saved record image
     C                   MOVEL     @1DBRC        #1DBRC
      * DBF change successful
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel and exit from key screen
      *================================================================
      * USER: Exit program processing
     C                   MOVEL     *BLANK        P0RTN
      *
      * CASE: CTL.*CMD key is CF03
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   END                                                    *FI
      * CASE: CTL.*CMD key is CF12
     C     *IN12         IFEQ      '1'                                          *IF
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   END                                                    *FI
      *
      * EDTRCD: Exit program - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Exit Program Processing
     C/COPY WNCPYSRC,CG1030DEPP
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * ROLLBACK any uncommitted DBF changes
     C     CSC022        IFEQ      'N'
     C     CSC022        OREQ      'Y'
     C     WCMTSK        ANDEQ     'N'
     C                   ROLBK                                          90
     C                   ELSE
     C                   SETON                                        U7U8
     C                   ENDIF
      *
      * Copy any undisplayed messages back to caller
     C                   CALL      'Y2CPMSC'
     C                   PARM                    ##PGM
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
      * Initialise indicators for re-entry
     C                   MOVE      '0'           *IN
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Obtain default message file
     C                   MOVEL     'CGUSRMSG'    ZADFMF           10
      * Define work field Midas run date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
     C                   MOVEL     '0'           *IN77
     C                   MOVEL     *BLANKS       BBIN89
     C                   MOVEL     *BLANKS       CBIN89
      * Open files first time only
     C     W0OPN         IFEQ      *BLANK
      * Begin commit control
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
     C**********         OPEN      CGGSETL0                                                 MD054955
      * Signal that files are now open
     C                   MOVE      'Y'           W0OPN             1
     C                   END
     C                   MOVEL     'N'           W0PMT             1
      * Select initial mode
     C     @1NROP        IFEQ      *ZERO
      * Add mode
     C                   MOVEL     'ADD'         W0PMD             3
     C                   ELSE
      * Change mode
     C                   MOVEL     'CHG'         W0PMD
     C                   END
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Retrieve Midas Date - R10 Standard Functions  *
     C*
     C*  Set up copyright parameter
     C*
     C                   MOVEA     CPY@          ACT@             80
     C*
     C* Get Rundate - Rundate  *
     C*
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   MOVE      'N'           CSC022            1
     C                   MOVE      'N'           WCMTSK            1
      *                                                                                       CSC022
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*VERIFY'     P@OPTN
     C                   PARM      'CSC022'      P@SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSC022
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC022
     C                   MOVE      'N'           WCMTSK
      *                                                                                       CSC022
     C                   IN        WDSJOB
      *                                                                                       CSC022
     C     WCMTNO        IFGT      0
     C                   MOVEA     WCJOBS        WCMT
     C                   Z-ADD     1             I                 2 0
      *                                                                                       CSC022
     C     ##JOB         LOOKUP    WCMT(I)                                50
     C     *IN50         IFEQ      *ON
     C                   MOVE      'Y'           WCMTSK
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSC022
     C                   ELSE
     C     P@RTCD        IFNE      '*NRF'
     C                   MOVEL     'CSC022'      W0KEY
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   Z-ADD     4             W0ERNB
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CSC022
     C                   ENDIF
      *                                                                                       CSC022
     C     *LIKE         DEFINE    SARN          P@SARD
     C************NAMVAR   DEFN           WDSJOB                                       CSC022BUG2330
     C     *DTAARA       DEFINE    SCCMTJOB      WDSJOB
      *                                                                                       CSC022
     C*
     C* Get modules information
     C*
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     MMODDS        PARM      *BLANKS       DSFDY                          O:Module Flg
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     2             W0ERNB                         * DB ERROR 02 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      * EDTRCD: Initialise prog - R10 Copy source templates  *
     C*EDTRCD: Cpysrc Templates Initialise Program C-spec
     C/COPY WNCPYSRC,CG1030DCPG
      *================================================================
     CSR   ZZEXIT        ENDSR
     C/EJECT
      *================================================================
      *                                                               *
      *  SRWIND   : Control Window Processing                         *
      *                                                               *
      *================================================================
     CSR   SRWIND        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRWIND'      @STK(Q)
      *
      * If window processing call WN0010
      *
     C     BGWDPR        IFEQ      'Y'
      *
      *    /copy to move data into the data structure fields passed
      *     as a parameter to the window controller
      *
      /COPY WNCPYSRC,CG1030MOV1
     C                   SELECT
     C     P1ACTC        WHENEQ    'I'
      *
      *     Insert Processing
      *
      /COPY WNCPYSRC,CG1030MOV2
     C     P1ACTC        WHENEQ    'A'
      *
      *     Amend Processing
      *
      /COPY WNCPYSRC,CG1030MOV3
     C     P1ACTC        WHENEQ    'D'
      *
      *     Delete Processing
      *
      /COPY WNCPYSRC,CG1000MOV4
     C     P1ACTC        WHENEQ    'E'
      *
      *     Enquire Processing
      *
      /COPY WNCPYSRC,CG1030MOV5
     C                   ENDSL
      *
     C                   CALL      'WN0010'                             9190
     C                   PARM      ##PGM         O#PGM            10
     C                   PARM      *BLANKS       O#CMD             2
     C                   PARM      P1ACTC        O#ACTN            1
     C                   PARM                    DATA
     C     R#RTN         PARM      *BLANKS       O#RTN             7
     C                   PARM                    EXTRA           256
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN91         IFEQ      '1'
     C                   MOVEL     'WN0010'      W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     3             W0ERNB                         * DB ERROR 03 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *   /copy to move data back from the data structure fields passed
      *    as a parameter to the window controller and control user
      *    defined processing.
      *
      /COPY WNCPYSRC,CG1030MOV6
      *
     C     *LIKE         DEFINE    O#RTN         R#RTN
     C     R#RTN         CABEQ     *BLANKS       EXWIND
      *
      *  Check return code and send message on action
      *  - set no update as some action has been specified.
      *
     C                   MOVEL     'Y'           W0DCF
     C     CSC022        IFEQ      'N'
     C     CSC022        OREQ      'Y'
     C     WCMTSK        ANDEQ     'N'
     C                   ROLBK
     C                   ELSE
     C                   SETON                                        U7U8
     C                   ENDIF
      *
     C                   SELECT
      *
      * *Return code is *User QUIT requested
      *
     C     R#RTN         WHENEQ    'Y2U9999'
     C                   MOVEL     'Y2U9999'     P0RTN
     C                   MOVEL     'Y2U9999'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   EXSR      ZYEXPG
      *
      * *Return code is WN Window Error
      *
     C     R#RTN         WHENEQ    'USR0563'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *
      * *Return code is *DBF update error
      *
     C     R#RTN         WHENEQ    'USR0567'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
      *
     C***Return*code*is**Previous*Screen******************************    115722
     C*                                                                   115722
     C***********R#RTN*****WHEQ 'USR0790'                                 115722
     C*********************MOVEL'CGD1001' ZAMSID                          115722
     C*********************EXSR ZASNMS                                    115722
     C                   ENDSL
      *
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXWIND        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *================================================================
     C*
     C* File and Program Error Processing
     C*
     C*COPY*CGCPYSRC,SRERRC                                                                 MD054955
     C/COPY CGCPYSRC,SRERRCLE                                                               MD054955
     O*EDTRCD: Cpysrc Templates Initialise Program O-spec
     O/COPY WNCPYSRC,CG1030DOPG
**  CPY@
(c) Finastra International Limited 2001
