     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/*S*D ***RPGBNOCVT*****************************************************              CSD053 MD056543
/*E*S ***RPGCVTOPT1****************************************************              CSD053 MD056543
/*STD *  RPGBASEBND                                                   *                     MD056543
/*EXI *  TEXT('Midas CG Report Correspondent details')
/*OVRF*: OVRDBF (File in program) (file on system)                  : *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CG0090 - Report Correspondent Details                        *
     F*                                                               *
     F*  Function:  This program provides details of a particular     *
     F*             correspondent.                                    *
     F*                                                               *
     F*  Called By: CGC0090 - Report Correspondent CL Controller      *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSD053             Date 01Jun06               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 086588             Date 21Apr95               *
      *                 086144             Date 10Mar95               *
      *                 S01522             Date 21Nov94               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD to readable  *
      *             unicode equivalent.                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  086588 - If charge currency is blank do not process charges. *
      *  086144 - Do not call AOBRCHR0 if CGCORRL0/CDBRCA (Branch) is *
      *           blank.                                              *
      *  S01522 - User Defined Correspondence                         *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  Indicator usage                                              *
     F*  ~~~~~~~~~~~~~~~                                              *
     F*                                                               *
     F*  03   -    Overflow on printer file                           *
     F*  50   -    First Cycle processing                             *
     F*  90   -    General work indicator                             *
     F*                                                               *
     F*****************************************************************
     F/COPY WNCPYSRC,CG0090DFPG
      *
      *  /Copy point for File Definition
      *
     FCG0090P1  O    E             PRINTER INFSR(SRFILE)
     F                                     OFLIND(*IN03)
     F                                     USROPN
      *
      * Transaction Report
      *
     FCGCORRL0  IF   E           K DISK
     F                                     INFSR(SRFILE)
      *
      * Correspondent Details Update index
      *
     F                                     INFDS(PRTINF)
     F/EJECT
     D*COPY*CGCPYSRC,SRERRE                                                                 MD056543
     D/COPY CGCPYSRC,SRERRDLE                                                               MD056543
      *
      *  End of Copysource for error processing
      *
      *
      *  Copyright Array
      *
     D CMD@            S             80    DIM(2) CTDATA PERRCD(1)
      *
      *  Array of QCMDEXC commands
      *
     D EDT             S              1    DIM(80)
      *
      *  Array of QCMDEXC command to edit
      *
      *
      *  Array of QCMDEXC commands
      *
      *
     D/COPY WNCPYSRC,CG0090DEPG
      *
      *  /Copy point for Arrays
      *
     D/EJECT
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      *  Define rundat data area
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Data Structures used by Access Programs
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      * Currency Details structure *
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      * Bank details Structure *
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      *  Define data for Branch file
      *
     D PRTINF          DS
      *
      * Printer file information data structure.
      *
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Data Structures used by Access Programs
      *
     D I#DTA           DS           256
      *
      *  Input parameters data structure
      *
      *           Spool file name (if blank, name unchanged).
      *                 N.B. To change name I#SPLR must be Y
      *                 Unless first call of program
      *
     D  I#SPLN                 1     10
      *
      *           Repeat open and close of spool file
      *                 If Y create new spool file
      *
     D  I#SPLR                11     11
      *
      *           Report Reference if Access checking is off
      *
     D  I#REFN                12     21
      *
      *           Report Override Flag / Page No.
      *
     D  I#ROVR                22     22
     D  I#PAGE                23     25  0
      *
      *           Report Title/Underline (uses msg ID on CGUSRMSG)
      *
     D  I#TITL                26     32
     D  I#TUL                 33     39
      *
      *  Define fields for group set printing
      *
     D  I#CORR                40     49
      *
      *  Structure Action time.
      *
     D D1ATIM          DS
     D  I#HOUR                 1      2  0
     D  I#COL1                 3      3    INZ(':')
     D  I#MINS                 4      5  0
     D  I#COL2                 6      6    INZ(':')
     D  I#SECS                 7      8  0
     D                 DS
     D  I#INHR                 1      2  0
     D  I#INMN                 3      4  0
     D  I#INSC                 5      6  0
     D  I#INTM                 1      6  0
     D CPYR@#          DS
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D*COPY*CGCPYSRC,SRERRI                                                                 MD056543
      *
      *  End of Program Error Processing copysource member
      *
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
     I/EJECT
      *****************************************************************
      *                 M A I N L I N E
      *****************************************************************
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      *  Define entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7
     C                   PARM                    W0ACT             8            Action code
     C                   PARM                    I#DTA                          Input Data Str.
     C                   PARM                    I#RSQN            5
      *
      * Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   END
      *
      *  If action is *CLOSE then call SROPT and close down program
      *
     C     W0ACT         IFEQ      '*CLOSE'
     C                   EXSR      SROPRT
     C                   MOVEL     '1'           *INLR
     C                   RETURN
     C                   END
      *
      *  Check action code and get Correspondent data.
      *
     C                   EXSR      SRCHCK
      *
      *  Call subroutine depending on action code
      *
     C     W0ACT         CASEQ     '*CORR  '     SRCORR
     C     W0ACT         CASEQ     '*CLOSESP'    SROPRT
     C                   CAS                     SRACT
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      * Return to calling program
      *
     C                   RETURN
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCHCK   : Check true action code                            *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRCHCK        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCHCK'      @STK(Q)
      *
      *  Retrieve title for report dependant on type of report
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      I#TITL        #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        H2TITL           60
      *
      *  Retrieve title underline
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      I#TUL         #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        H2TUL            60
      *
      *  Set up report reference
      *
     C                   MOVEL     I#REFN        H1REFN
      *
      *  Unwind subroutine stack name
      *
     C     EXCHCK        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCORR   : Control Print Output                              *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SROPRT - Open Printer File                        *
      *             SRHDR1 - Print Header of Report                   *
      *                                                               *
      *****************************************************************
     CSR   SRCORR        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCORR'      @STK(Q)
      *
      *  Open printer file etc
      *
     C                   EXSR      SROPRT
      *
      *  Print header of report
      *
     C                   EXSR      SRHDR1
      *
      *  Print Correspondent Details
      *
     C                   EXSR      SRCDTL
      *
      *  Unwind subroutine stack name
      *
     C     EXCORR        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCDTL   : Print Correspondence Details                      *
      *                                                               *
      *  CALLED BY: SRCORR - Control Print Output                     *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     CSR   SRCDTL        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCDTL'      @STK(Q)
      *
      *  Obtain Correspondence Details.
      *
     C     I#CORR        CHAIN     CGCORRL0                           90
      *
     C     *IN90         IFEQ      '1'                                          B001
      *
      *  Write 'No details to report'
      *
     C                   WRITE     F5DTL1
     C                   ELSE                                                   X001
      *
      *  Check branch exists
      *
     C     CDBRCA        IFNE      *BLANKS                                                    086144
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*KEY   '     P@OPTN            7            I:Option
     C                   PARM      CDBRCA        P@BRCD            3            I:Key field
     C********** SDBRCH    PARM           DSFDY            O:Format                           CGL029
     C     SDBRCH        PARM                    DSSDY                                        CGL029
      *
      * Branch not found
      *
     C     P@RTCD        IFNE      *BLANKS
     C     P@RTCD        ANDNE     '*NOSEL '
     C                   MOVEL     'AOBRCHR0'    W0FILE
     C                   MOVEL     CDBRCA        W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR  1 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   END                                                                   08614
      *
      *  Convert activation date.
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM      CDATDT        W2DAYN            5 0          Day No.
     C                   PARM      WUDFF         W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       D1ADAT                         DDMMMYY
      *
      *  Convert de-activation date.
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM      CDDADT        W2DAYN            5 0          Day No.
     C                   PARM      WUDFF         W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       D1DDAT                         DDMMMYY
      *
      *  Convert creation date.
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM      CDCDTE        W2DAYN            5 0          Day No.
     C                   PARM      WUDFF         W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       D1CDAT                         DDMMMYY
      *
      *  Convert next post date.
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM      CDNTDT        W2DAYN            5 0          Day No.
     C                   PARM      WUDFF         W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       D1NDAT                         DDMMMYY
      *
      *  Convert Default print date.
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM      CDDPDT        W2DAYN            5 0          Day No.
     C                   PARM      WUDFF         W2DTFM            1            Date Format
     C                   PARM      *ZEROS        W2DATE            6 0          Date
     C                   PARM      *BLANKS       D1PDAT                         DDMMMYY
      *
      *  Obtain Currency decimal places.
      *
     C     CDCCCY        IFNE      *BLANKS                                                    086588
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CDCCCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      *  Format Charge per item.
      *
     C                   CALL      'ZSEDIT'
     C                   PARM      CDCITM        ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      ' '           ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C                   MOVE      ZOUT21        D1CITM
      *
      *  Format Charge not posted.
      *
     C                   CALL      'ZSEDIT'
     C                   PARM      CDBSNB        ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      ' '           ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C                   MOVE      ZOUT21        D1BSNB
      *
      *  Format Accumulated charge to date.
      *
     C                   CALL      'ZSEDIT'
     C                   PARM      CDCACC        ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      ' '           ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C                   MOVE      ZOUT21        D1CACC
      *
      *  Format Accumulated charge to date.
      *
     C                   CALL      'ZSEDIT'
     C                   PARM      CDCACC        ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      ' '           ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C                   MOVE      ZOUT21        D1CACC
     C                   ENDIF                                                                086588
      *
      *  Format Day number.
      *
     C                   CALL      'ZSEDIT'
     C                   PARM      CDPDAY        ZFLD15           15 0
     C                   PARM      1             ZDECS             1 0
     C                   PARM      ' '           ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
      *
     C                   MOVEL     ZOUT21        D1PDAY
      *
      *  Format Action time
      *
     C                   Z-ADD     CDATIM        I#INTM
     C                   Z-ADD     I#INHR        I#HOUR
     C                   Z-ADD     I#INMN        I#MINS
     C                   Z-ADD     I#INSC        I#SECS
      *                                                                                     MD056543
      ** Move CGCORRPD Graphic fields                                                       MD056543
      *                                                                                     MD056543
     C                   EVAL      CDCORNP = *BLANKS                                        MD056543
     C                   EVAL      CDADD1P = *BLANKS                                        MD056543
     C                   EVAL      CDADD2P = *BLANKS                                        MD056543
     C                   EVAL      CDADD3P = *BLANKS                                        MD056543
     C                   EVAL      CDADD4P = *BLANKS                                        MD056543
     C                   EVAL      CDADD5P = *BLANKS                                        MD056543
     C                   EVAL      CDADD6P = *BLANKS                                        MD056543
     C                   EVAL      CDADD7P = *BLANKS                                        MD056543
     C                   EVAL      CDADD8P = *BLANKS                                        MD056543
     C                   EVAL      CDCORNP = CDCORN                                         MD056543
     C                   EVAL      CDADD1P = CDADD1                                         MD056543
     C                   EVAL      CDADD2P = CDADD2                                         MD056543
     C                   EVAL      CDADD3P = CDADD3                                         MD056543
     C                   EVAL      CDADD4P = CDADD4                                         MD056543
     C                   EVAL      CDADD5P = CDADD5                                         MD056543
     C                   EVAL      CDADD6P = CDADD6                                         MD056543
     C                   EVAL      CDADD7P = CDADD7                                         MD056543
     C                   EVAL      CDADD8P = CDADD8                                         MD056543
      *
      *  Write Correspondent detail line.
      *
     C                   WRITE     F1DTL1
     C                   ENDIF                                                  E001
      *
      *  Unwind subroutine stack name
      *
     C     EXCDTL        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *
      *****************************************************************
      *                                                               *
      *  SRHDR1   : Print Page Header                                 *
      *                                                               *
      *  CALLED BY: SRCORR - Print Correspondence Details             *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     CSR   SRHDR1        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRHDR1'      @STK(Q)
      *
      *  /Copy point for Header print 1
      *
     C/COPY WNCPYSRC,CG0090DPH1
      *
      *
      *  Write page header and switch off overflow indicator
      *
     C                   WRITE     F0HDR1
     C                   WRITE     F0HDR2
     C                   MOVEL     '0'           *IN03
      *
      *  /Copy point for Header print
      *
     C/COPY WNCPYSRC,CG0090HDR1
      *
      *
      *  Unwind subroutine stack name
      *
     C     EXHDR1        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SROPRT   : Control open and close of spool file CG0090P1     *
      *                                                               *
      *  CALLED BY: Mainline processing                               *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SROPRT        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SROPRT'      @STK(Q)
      *
      *  If first open or I#SPLR is 'Y', open and close file
      *  or close action specified
      *
     C     ##OPRT        IFEQ      *BLANKS
     C     I#SPLR        OREQ      'Y'
     C     W0ACT         OREQ      '*CLOSE'
     C     W0ACT         OREQ      '*CLOSESP'
      *
      *  If open and spool repeat is yes close the file
      *  or if close specified and file open
      *
     C     ##OPRT        IFNE      *BLANKS
     C     I#SPLR        ANDEQ     'Y'
     C     ##OPRT        ORNE      *BLANKS
     C     W0ACT         ANDEQ     '*CLOSE'
     C     ##OPRT        ORNE      *BLANKS
     C     W0ACT         ANDEQ     '*CLOSESP'
      *
      *  /Copy point for End of Report
      *
     C/COPY WNCPYSRC,CG0090DPER
      *
      *
      *  Print end of report before processing close of file
      *
     C                   WRITE     F0TRL1
      *
      *  Close file
      *
     C                   CLOSE     CG0090P1
     C                   MOVEL     *BLANKS       ##OPRT
     C                   Z-ADD     0             PAGE1
      *
      *  If *CLOSE exit section as no more processing
      *
     C     W0ACT         IFEQ      '*CLOSE'
     C     W0ACT         OREQ      '*CLOSESP'
     C                   GOTO      EXOPRT
     C                   END
     C                   END
      *
      *  If spool file name is requested change override
      *
     C     ##OPRT        IFEQ      *BLANKS
     C     I#SPLN        ANDNE     *BLANKS
      *
      *  Override file CG0090P1 share(*NO) and spool file name
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEA     I#SPLN        EDT(49)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     2             W0ERNB
     C                   EXSR      SRERR
     C                   END
      *
     C                   END
      *
      *  Open CG0090P1 for output
      *
     C                   OPEN      CG0090P1                             90
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CG0090P1'    W0FILE                         ***************
     C                   MOVEL     '*OPEN'       W0KEY                          * DB ERROR 03 *
     C                   Z-ADD     3             W0ERNB                         ***************
     C                   MOVEL     'MEM5005'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * If I#SPLN is not blank then this is the name for RCF
      *
     C     I#SPLN        IFNE      *BLANKS
     C                   MOVEL     I#SPLN        UUSFNM
     C                   ELSE
     C                   MOVEL     SFILEU        UUSFNM
     C                   END
      *
      * ZSFILE - Log Spool File
      *
      * Set up spool file number
      *
     C                   Z-ADD     SFNUMU        WUSFNB            6 0
     C                   MOVE      *BLANKS       UUSRSQ            5
     C     *LIKE         DEFINE    UUZSER        WUZSER
      *
      * ZSFILE - write report rqs
      *
     C                   CALL      'ZSFILE'                             90
     C     UUSRSQ        PARM      I#RSQN        UURSQN            5
     C                   PARM      *BLANKS       UUENTY            3
     C                   PARM                    UUSFNM           10
     C                   PARM      WUSFNB        UUSFNB            6 0
     C     WUZSER        PARM      *BLANK        UUZSER            1
      *
      * Report error on call to ZSFILE
      *
     C     *IN90         IFEQ      '1'
     C     WUZSER        OREQ      'Y'
     C                   MOVEL     '*CALL   '    W0FILE                         ***************
     C                   MOVEL     'ZSFILE'      W0KEY                          * DB ERROR 04 *
     C                   Z-ADD     4             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   MOVEL     'Y'           ##OPRT            1
      *
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXOPRT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRACT    : Undefined action - error                          *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRACT         BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRACT '      @STK(Q)
      *
      *  Database error undefined action
      *
     C                   MOVEL     '*ACTION '    W0FILE                         ***************
     C                   MOVEL     W0ACT         W0KEY                          * DB ERROR  5 *
     C                   Z-ADD     5             W0ERNB                         ***************
     C                   MOVEL     'MEM5006'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
      *
      *  Unwind subroutine stack name
      *
     C     EXACT         TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : None                                              *
      *                                                               *
      *****************************************************************
     CSR   SRINIT        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          ACT@             80
      *
      *  Get Rundate - Rundate
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *
      *  Extract bank details
      *
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     SDBANK        PARM      *BLANKS       DSFDY
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     6             W0ERNB                         * DB ERROR  6 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Indicate that set up is complete
      *
     C                   SETON                                        50
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *
      *  /Copy point for Calculation Specs
      *
     C/COPY WNCPYSRC,CG0090DCPG
     C/EJECT
     C*
     C* PSSR Processing
     C*
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD056543
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD056543
     C/EJECT
      *
      *  File and Program Error Processing
      *
     C*COPY*CGCPYSRC,SRERRC                                                                 MD056543
     C/COPY CGCPYSRC,SRERRCLE                                                               MD056543
     C/EJECT
     C/COPY WNCPYSRC,CG0090DOPG
      *
      *  /Copy point for Output Specs
      *
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA CMD@
OVRPRTF    FILE(CG0090P1  ) SHARE(*NO) SPLFNAME(XXXXXXXXXX) SECURE(*YES)
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES)
