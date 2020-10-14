     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/*S*D ***RPGBNOCVT*****************************************************              CSD053 MD056543
/*E*S ***RPGCVTOPT1****************************************************              CSD053 MD056543
/*STD *  RPGBASEBND                                                   *                     MD056543
/*EXI *  TEXT('Midas CG UDC Summary of Correspond. Items Report')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG5410 - Summary of Correspondence Items Report              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Function:  This program produces a summary report of         *
      *             correspondence items in the extract file.         *
      *                                                               *
      *  Called By: CGC5410 - Print Summary of Correspondence Items - *
      *                        Extract                                *
      *                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CCG024             Date 29Sep16               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD053             Date 01Jun06               *
      *                 226537             Date 07Jul05               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 089984             Date 06Jly95               *
      *                 088008             Date 18May95               *
      *                 086662             DATE 25APR95               *
      *                 086136             DATE 20MAR95               *
      *                 086136             DATE 08MAR95               *
      *                 S01552             DATE 26JAN95               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD and CGCDSHPD *
      *             to readable unicode equivalent.                   *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG024 - Use Atlernate Name and Address in Correspondence    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *           (Recompile)                                         *
      *  226537 - Scheduled Print Date printed incorrectly. Display   *
      *           date or appropriate description for value on file.  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  089984 - Errors in report                                    *
      *  088008 - Print last confirmation                             *
      *  086662 - Add correspondence type to selection criteria       *
      *  086136 - 086136 needs amendment as if the data comes from    *
      *           CGXDCRPD 'Scheduled drop date' should be displayed  *
      *           on the report.                                      *
      *  086136 - SR/CNVDAT converts zero dates to 31DEC71.Where there*
      *           is no date move blanks to the output field.         *
      *           'Scheduled drop date' should be 'Retention Period'  *
      *           and be a number of days as opposed to a date.       *
      *  S01552 - Created for User Defined Correspondence             *
      *                                                               *
      *****************************************************************
     FCGUDCRPD  IF   E           K DISK    INFSR(SRFILE)
     F                                     USROPN
     F*** Correspondence Reference Details Extract
     F*
     FCGXDCRPD  IF   E           K DISK    INFSR(SRFILE)
     F                                     USROPN
     F                                     RENAME(@UDCRPD:@XDCRPD)
     F*** Correspondence Reference Details Extract - Archive
     F*
     F*GISTSL0IF  E           K        DISK         KINFSR SRFILE                             089984
     F*** Item Status Description
     F*
     FCGCORRL0  IF   E           K DISK    INFSR(SRFILE)
     F*** Correspondent Details
     FCGCORRL4  IF   E           K DISK    INFSR(SRFILE)                                      CCG024
     F*
     FCG5410P1  O    E             PRINTER INFDS(SPOOLP)
     F                                     USROPN
      *
      *****************************************************************
      *                                                               *
      * FUNCTION OF INDICATORS                                        *
      *                                                               *
      * 87               Chain fail on CGISTSL0                       *
      * 88               Chain fail on CGCORRL0                       *
      * 89               End of file/Chain fail on CGUDCRPD/CGXDCRPD  *
      *                                                               *
      *****************************************************************
     D*
     D*** Copyright Array
     D ACT@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D*COPY*CGCPYSRC,SRERRE                                                                 MD056543
     D/COPY CGCPYSRC,SRERRDLE                                                               MD056543
     D*
      /EJECT
     D*** Copyright Insertion
     D CPYR            DS
     D  CPY@                   1     80
     D*
     D SPOOLP          DS
     D  PFILE                 83     92
     D  PFNUM                123    124B 0
     D  LINE                 367    368B 0                                                    E39480
     D**  Spool file information data structure
     D*
     D DSRUN           DS
     D  RDAT                   1      7
     D  @DD                    1      2
     D  @MMM                   3      5
     D  @YY                    6      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
     D**  RUNDAT data area data structure (date format -ddmmmyy)
     D*
     D*
     D*COPY*CGCPYSRC,SRERRI                                                                 MD056543
     D*
     D P#PARM          DS           100
     D**  DS for data from RCF Parm
     D  PSUSER                 1     10
     D  PSDCOR                11     20
     D  PSPRIM                21     21
     D  PSPTYP                22     31
     D  PSPSTP                32     41
     D  ##FRDT                42     46  0
     D  ##TODT                47     51  0
     D  PSLGID                52     53
     D  PSSTS1                72     75
     D  PSSTS2                76     79
     D  PSSTS3                80     83
     D  PSSTS4                84     87
     D  PSSTS5                88     91
     D  PSATRM                92     92
     D  PSPPFN                93     93
     D  PSARCH                94     94
     D  PSSUMM                95     95
     D  PSCOT                 96     96                                                       086662
     D  PSPLST                97     97                                                       088008
     D*
     D*** Item Description constant
     D ##IDES          C                   CONST('<Description not fou-
     D                                     nd')
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D*** Bank details
     D*
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D*** Bank details
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D*** First data structure for access program, Short data structure
     D*
     D*** CG Audit Report Data Structure
     D*COPY CGCPYSRC,CGAUDTI                                                                MD056543
     D/COPY CGCPYSRC,CGAUDTDLE                                                              MD056543
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      * Data structure for AOSVALR0 string                                                    CCG024
     D                 DS                                                                     CCG024
     D  SVAL1                  1    200                                                       CCG024
     D  SVAL11                 1      1                                                       CCG024
      *                                                                                       CCG024
      * System Value                                                                          CCG024
     D                 DS                                                                     CCG024
     D  SVALK1                 1     20    INZ('RecipientSpecialChar')                        CCG024
      *                                                                                       CCG024
     I*
     C*****************************************************************
     C/EJECT
      /TITLE   CALCULATION SPECIFICATIONS
     C*****************************************************************
     C*
     C                   EXSR      INIT
     C*
     C*** Main processing
     C                   EXSR      MAIN
     C*
     C                   EXSR      FINAL
     C*
     C*** End program
     C                   SETON                                            LR
     C                   RETURN
     C*
     C*****************************************************************
     C*                                                               *
     C* INIT   -  Initial processing                                  *
     C*                                                               *
     C* Called by:                                                    *
     C*                                                               *
     C* Calls: AOBANKR0(pgm), RECONE                                  *
     C*                                                               *
     C*****************************************************************
     C*
     C     INIT          BEGSR
     C*
     C*
     C*** Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'INIT'        @STK(Q)
     C*
     C*................................................................
     C*
     C*** Set up copyright parameter
     C                   MOVEA     CPY@          ACT@             80
     C*
     C**  Parameters list
     C     *ENTRY        PLIST
     C                   PARM                    P#RSEQ            5
     C                   PARM                    P#RLVL            1
     C                   PARM                    P#BRCH            3
     C                   PARM                    P#PARM
     C                   PARM                    P#ARCH            1
      *                                                                                       086136
      **                                                                                      086136
     C     P#ARCH        IFEQ      'A'                                                        086136
     C                   SETON                                        86                      086136
     C                   ELSE                                                                 086136
     C                   SETOFF                                       86                      086136
     C                   ENDIF                                                                086136
     C*
     C**  Open files.
     C     P#ARCH        IFEQ      'A'
     C                   OPEN      CGXDCRPD
     C                   ELSE
     C                   OPEN      CGUDCRPD
     C                   ENDIF
     C*
     C*** Access dataarea RUNDAT for run date and multibranch indicator
     C     *DTAARA       DEFINE    RUNDAT        DSRUN
     C     *LOCK         IN        DSRUN
     C                   OUT       DSRUN
     C***   If dataarea not found perform database error processing
     C     RDAT          IFEQ      *BLANKS
     C                   MOVEL     'RUNDAT  '    W0FILE                         **************
     C                   MOVEL     'ONLY    '    W0KEY                          *DB ERROR 01 *
     C                   Z-ADD     1             W0ERNB                         **************
     C                   MOVEL     'MEM5002'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C*
     C*** Read in Installation Data
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBMSG  '    ##RTCD
     C                   PARM      '*FIRST  '    ##OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*** Error handling for access object
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'AOBANKR0'    W0FILE                         **************
     C                   MOVEL     '*FIRST  '    W0KEY                          *DB ERROR 02 *
     C                   Z-ADD     2             W0ERNB                         **************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C*
      *                                                                                       CCG024
      * Check if CCG024 is switched on                                                        CCG024
     C                   CALL      'AOSARDR0'                                                 CCG024
     C                   PARM                    ##RTCD                                       CCG024
     C                   PARM      '*VERIFY'     ##OPTN                                       CCG024
     C                   PARM      'CCG024'      P@SARD            1                          CCG024
      *                                                                                       CCG024
     C     ##RTCD        IFEQ      *BLANKS                                                    CCG024
     C                   MOVE      'Y'           CCG024            1                          CCG024
     C                   ELSE                                                                 CCG024
     C                   MOVE      'N'           CCG024                                       CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
      * Check System Value RecipientSpecialChar                                               CCG024
     C     CCG024        IFEQ      'Y'                                                        CCG024
      *                                                                                       CCG024
     C                   CALL      'AOSVALR0'                                                 CCG024
     C                   PARM      *BLANKS       RTNCDE            7                          CCG024
     C                   PARM                    SVALK1           20                          CCG024
     C                   PARM                    SVAL1           200                          CCG024
     C                   PARM      *BLANKS       SVALK2           20                          CCG024
     C                   PARM                    SVAL2           200                          CCG024
     C                   PARM      *BLANKS       SVALK3           20                          CCG024
     C                   PARM                    SVAL3           200                          CCG024
     C                   PARM      *BLANKS       SVALK4           20                          CCG024
     C                   PARM                    SVAL4           200                          CCG024
     C                   PARM      *BLANKS       SVALK5           20                          CCG024
     C                   PARM                    SVAL5           200                          CCG024
     C                   PARM      *BLANKS       SVALK6           20                          CCG024
     C                   PARM                    SVAL6           200                          CCG024
     C                   PARM      *BLANKS       SVALK7           20                          CCG024
     C                   PARM                    SVAL7           200                          CCG024
     C                   PARM      *BLANKS       SVALK8           20                          CCG024
     C                   PARM                    SVAL8           200                          CCG024
     C                   PARM      *BLANKS       SVALK9           20                          CCG024
     C                   PARM                    SVAL9           200                          CCG024
     C                   PARM      *BLANKS       SVALK0           20                          CCG024
     C                   PARM                    SVAL10          200                          CCG024
      *                                                                                       CCG024
     C     RTNCDE        IFNE      *BLANKS                                                    CCG024
     C     SVAL1         IFEQ      '*NRF'                                                     CCG024
     C                   MOVE      SVALK1        DBKEY                                        CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
     C                   MOVEL     'SDSVALR0'    W0FILE                                       CCG024
     C                   MOVEL     '*CALL'       W0KEY                                        CCG024
     C                   Z-ADD     21            W0ERNB                                       CCG024
     C                   MOVEL     'MEM5003'     W0MSGD                                       CCG024
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CCG024
     C                   EXSR      SRERR                                                      CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
     C*** Get the first record
     C                   EXSR      RECONE
     C*
     C*
     C     *LIKE         DEFINE    DRBRCA        ##PBRC
     C     *LIKE         DEFINE    DRBRCA        ##BRCD
     C     *LIKE         DEFINE    DRBRCA        ##BRC
     C*
     C*................................................................
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C*                                                               *
     C* FINAL  -  Final processing                                    *
     C*                                                               *
     C* Called by:                                                    *
     C*                                                               *
     C* Calls: SRAUDT                                                 *
     C*                                                               *
     C*****************************************************************
     C*
     C     FINAL         BEGSR
     C*
     C*
     C*** Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'FINAL'       @STK(Q)
     C*
     C*................................................................
     C*
     C*** Print End of Report message
     C     ##DREC        IFGT      0
     C                   WRITE     P1ENDB
     C                   ENDIF
     C*
     C*** Close print file
     C                   CLOSE     CG5410P1
     C*
     C*** Audit Report
     C                   EXSR      SRAUDT
     C*
     C*
     C*
     C*................................................................
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C*                                                               *
     C* MAIN  -  Main processing                                      *
     C*                                                               *
     C* Called by:                                                    *
     C*                                                               *
     C* Calls: SYSLVL, ALLBCH, SNGBCH                                 *
     C*                                                               *
     C*****************************************************************
     C*                                                               *
     C     MAIN          BEGSR
     C*
     C*** Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'MAIN'        @STK(Q)
     C*
     C*................................................................
     C*
     C*** Not end of file
     C     *IN89         DOWEQ     *OFF
     C*
     C*
     C                   SELECT
     C*
     C*** Level selected is SYSTEM
     C     P#RLVL        WHENEQ    'S'
     C                   EXSR      SYSLVL
     C*
     C*** Level selected is BRANCH
     C*** and selected branch is ALL
     C     P#RLVL        WHENEQ    'B'
     C     P#BRCH        ANDEQ     'ALL'
     C                   EXSR      ALLBCH
     C*
     C*** Level selected is BRANCH
     C*** and selected branch is not ALL
     C     P#RLVL        WHENEQ    'B'
     C     P#BRCH        ANDNE     'ALL'
     C                   EXSR      SNGBCH
     C                   ENDSL
     C*
     C                   ENDDO
     C*
     C*
     C*
     C*................................................................
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C*                                                               *
     C* SYSLVL - System Level report processing                       *
     C*                                                               *
     C* Called by: MAIN                                               *
     C*                                                               *
     C* Calls: SPLF, PRTSEL, RTVBRC, PRTDET                           *
     C*                                                               *
     C*****************************************************************
     C*
     C     SYSLVL        BEGSR
     C*
     C*** Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SYSLVL'      @STK(Q)
     C*
     C*................................................................
     C*
     C*
     C*** Print selection page
     C                   EXSR      PRTSEL
     C*
     C*** Retrieve Branch Details
     C                   MOVE      DRBRCA        ##BRC
     C                   EXSR      RTVBRC
     C*** Print Header
     C                   EXSR      PRTHED
     C                   MOVE      DRBRCA        ##PBRC
     C*
     C*
     C*** Print Items
     C*** Until End of File
     C     *IN89         DOWEQ     *OFF
      *                                                                                       086662
      **  Apply selection for correspsondent type here as opposed to in                       086662
      **  the OPNQRYF in CGC5410.                                                             086662
     C     PSCOT         IFEQ      'T'                                                        086662
     C     *LIKE         DEFINE    PSDCOR        W0CTYP                                       086662
     C                   MOVEL     PSDCOR        W0CTYP                                       086662
     C*                                                                                       086662
     C     DRDCOR        CHAIN     CGCORRL0                           88                      086662
     C     *IN88         IFEQ      *ON                                                        086662
     C                   MOVEL     'CGCORRL0'    W0FILE                         **************086662
     C                   MOVEL     DRDCOR        W0KEY                          *DB ERROR 07 *086662
     C                   Z-ADD     7             W0ERNB                         **************086662
     C                   MOVEL     'MEM5004'     W0MSGD                                       086662
     C                   MOVEL     'MIDAS  '     W0MSGF                                       086662
     C                   EXSR      SRERR                                                      086662
     C                   ENDIF                                                                086662
      *                                                                                       086662
     C     W0CTYP        IFNE      *BLANKS                                                    086662
     C     W0CTYP        ANDNE     CDCTYP                                                     086662
     C                   GOTO      NXTREC                                                     086662
     C                   ENDIF                                                                086662
     C                   ENDIF                                                                086662
     C*
     C***   Increment the count of records read
     C                   ADD       1             ##DREC            5 0
     C*
     C***   On change of branch or full page
     C     DRBRCA        IFNE      ##PBRC
     C     LINE          ORGT      55
     C*
     C***     Change of Branch So retrieve branch details
     C     DRBRCA        IFNE      ##PBRC
     C***       Print 'End of Branch'
     C                   WRITE     P1ENDA
     C***       Retrieve branch details
     C                   MOVE      DRBRCA        ##BRC
     C                   EXSR      RTVBRC
     C                   ENDIF
     C***     Print Header
     C                   EXSR      PRTHED
     C                   MOVE      DRBRCA        ##PBRC
     C*
     C                   ENDIF
     C*
     C***   Print Item
     C                   EXSR      PRTDET
      *                                                                                       086662
     C     NXTREC        TAG                                                                  086662
     C*
     C***   Access Correspondence Reference File
     C     P#ARCH        IFEQ      'A'
     C                   READ      CGXDCRPD                               89
     C                   ELSE
     C                   READ      CGUDCRPD                               89
     C                   ENDIF
     C*
     C*
     C                   ENDDO
     C*
     C*
     C*
     C*................................................................
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C*                                                               *
     C* ALLBCH - All Branch report processing                         *
     C*                                                               *
     C* Called by: MAIN                                               *
     C*                                                               *
     C* Calls: SPLF, PRTSEL, RTVBRC, PRTDET                           *
     C*                                                               *
     C*****************************************************************
     C*
     C     ALLBCH        BEGSR
     C*
     C*** Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'ALLBCH'      @STK(Q)
     C*
     C*................................................................
     C*
     C*
     C*** Retrieve Branch Details
     C                   MOVE      DRBRCA        ##BRC
     C                   EXSR      RTVBRC
     C*
     C*** Print selection page
     C                   EXSR      PRTSEL
     C*
     C*** Print Header
     C                   EXSR      PRTHED
     C*
     C*** Previous branch code
     C                   MOVE      DRBRCA        ##PBRC
     C*
     C*
     C*** Print Items
     C*** Until End of File
     C     *IN89         DOWEQ     *OFF
      *                                                                                       086662
      **  Apply selection for correspsondent type here as opposed to in                       086662
      **  the OPNQRYF in CGC5410.                                                             086662
     C     PSCOT         IFEQ      'T'                                                        086662
     C                   MOVEL     PSDCOR        W0CTYP                                       086662
     C                   ENDIF                                                                086662
      *                                                                                       CCG024
      ** If feature CCG024 is on and special character is found in DRDCOR                     CCG024
     C                   MOVEL     'N'           XFOUND            1                          CCG024
     C     CCG024        IFEQ      'Y'                                                        CCG024
     C     SVAL11        SCAN      DRDCOR                                 99                  CCG024
     C     *IN99         IFEQ      *ON                                                        CCG024
     C                   MOVEL     DRDCOR        XXCORR            6                          CCG024
     C     XXCORR        CHAIN     CGCORRL4                           88                      CCG024
     C     *IN88         IFEQ      *ON                                                        CCG024
     C                   MOVEL     'CGCORRL0'    W0FILE                                       CCG024
     C                   MOVEL     DRDCOR        W0KEY                                        CCG024
     C                   Z-ADD     88            W0ERNB                                       CCG024
     C                   MOVEL     'MEM5004'     W0MSGD                                       CCG024
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CCG024
     C                   EXSR      SRERR                                                      CCG024
     C                   ENDIF                                                                CCG024
     C                   MOVEL     'Y'           XFOUND                                       CCG024
     C                   ENDIF                                                                CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
     C     XFOUND        IFEQ      'N'                                                        CCG024
     C*                                                                                       086662
     C     DRDCOR        CHAIN     CGCORRL0                           88                      086662
     C     *IN88         IFEQ      *ON                                                        086662
     C                   MOVEL     'CGCORRL0'    W0FILE                         **************086662
     C                   MOVEL     DRDCOR        W0KEY                          *DB ERROR 08 *086662
     C                   Z-ADD     8             W0ERNB                         **************086662
     C                   MOVEL     'MEM5004'     W0MSGD                                       086662
     C                   MOVEL     'MIDAS  '     W0MSGF                                       086662
     C                   EXSR      SRERR                                                      086662
     C                   ENDIF                                                                086662
     C                   ENDIF                                                                CCG024
      *                                                                                       086662
     C     W0CTYP        IFNE      *BLANKS                                                    086662
     C     CDRTYP        ANDEQ     'T'                                                        086662
     C     W0CTYP        ANDNE     CDCTYP                                                     086662
     C                   GOTO      NXTRE1                                                     086662
     C                   ENDIF                                                                086662
     C*
     C***   Increment the count of records read
     C                   ADD       1             ##DREC            5 0
     C*
     C***   On change of branch or full page
     C     DRBRCA        IFNE      ##PBRC
     C     LINE          ORGT      55
     C*
     C***     Change of Branch So retrieve branch details
     C     DRBRCA        IFNE      ##PBRC
     C*
     C***       Print 'End of Branch'
     C                   WRITE     P1ENDA
     C***       Open spool file for next branch and log to RCF
     C                   CLOSE     CG5410P1
     C                   OPEN      CG5410P1
     C                   MOVE      PFILE         SFILE
     C                   Z-ADD     PFNUM         ZSNUM
     C                   MOVE      DRBRCA        ZSENTY
     C                   EXSR      SPLF
     C***       Retrieve Branch Details
     C                   MOVE      DRBRCA        ##BRC
     C                   EXSR      RTVBRC
     C***       Print selection page
     C                   EXSR      PRTSEL
     C                   ENDIF
     C***     Print Header
     C                   EXSR      PRTHED
     C                   MOVE      DRBRCA        ##PBRC
     C*
     C                   ENDIF
     C*
     C***   Print Item
     C                   EXSR      PRTDET
      *                                                                                       086662
     C     NXTRE1        TAG                                                                  086662
     C*
     C***   Access Correspondence Reference File
     C     P#ARCH        IFEQ      'A'
     C                   READ      CGXDCRPD                               89
     C                   ELSE
     C                   READ      CGUDCRPD                               89
     C                   ENDIF
     C*
     C*
     C                   ENDDO
     C*
     C*
     C*
     C*................................................................
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C*                                                               *
     C* SNGBCH - Single Branch report processing                      *
     C*                                                               *
     C* Called by: MAIN                                               *
     C*                                                               *
     C* Calls: SPLF, PRTSEL, PRTDET                                   *
     C*                                                               *
     C*****************************************************************
     C*
     C     SNGBCH        BEGSR
     C*
     C*** Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SNGBCH'      @STK(Q)
     C*
     C*................................................................
     C*
     C*
     C*** Retrieve Branch Details
     C                   MOVE      DRBRCA        ##BRC
     C                   EXSR      RTVBRC
     C*
     C*** Print selection page
     C                   EXSR      PRTSEL
     C*
     C*** Print Header
     C                   EXSR      PRTHED
     C*
     C*
     C*** Print Items
     C*** Until End of File
     C     *IN89         DOWEQ     *OFF
      *                                                                                       086662
      **  Apply selection for correspsondent type here as opposed to in                       086662
      **  the OPNQRYF in CGC5410.                                                             086662
     C     PSCOT         IFEQ      'T'                                                        086662
     C                   MOVEL     PSDCOR        W0CTYP                                       086662
     C*                                                                                       086662
     C     DRDCOR        CHAIN     CGCORRL0                           88                      086662
     C     *IN88         IFEQ      *ON                                                        086662
     C                   MOVEL     'CGCORRL0'    W0FILE                         **************086662
     C                   MOVEL     DRDCOR        W0KEY                          *DB ERROR 09 *086662
     C                   Z-ADD     9             W0ERNB                         **************086662
     C                   MOVEL     'MEM5004'     W0MSGD                                       086662
     C                   MOVEL     'MIDAS  '     W0MSGF                                       086662
     C                   EXSR      SRERR                                                      086662
     C                   ENDIF                                                                086662
      *                                                                                       086662
     C     W0CTYP        IFNE      *BLANKS                                                    086662
     C     W0CTYP        ANDNE     CDCTYP                                                     086662
     C                   GOTO      NXTRE2                                                     086662
     C                   ENDIF                                                                086662
     C                   ENDIF                                                                086662
     C*
     C***   Increment the count of records read
     C                   ADD       1             ##DREC            5 0
     C*
     C***   On Full page
     C     LINE          IFGT      55
     C***     Print Header
     C                   EXSR      PRTHED
     C                   ENDIF
     C*
     C***   Print Item
     C                   EXSR      PRTDET
      *                                                                                       086662
     C     NXTRE2        TAG                                                                  086662
     C*
     C***   Access Correspondence Item File
     C     P#ARCH        IFEQ      'A'
     C                   READ      CGXDCRPD                               89
     C                   ELSE
     C                   READ      CGUDCRPD                               89
     C                   ENDIF
     C*
     C*
     C                   ENDDO
     C*
     C*
     C*
     C*................................................................
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C*                                                               *
     C* PRTDET - Print Detail Record                                  *
     C*                                                               *
     C* Called by: SYSLVL, ALLBCH, SNGBCH                             *
     C*                                                               *
     C* Calls: SRERR, CNVDAT                                          *
     C*                                                               *
     C*****************************************************************
     C*
     C     PRTDET        BEGSR
     C*
     C*** Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'PRTDET'      @STK(Q)
     C*
     C*................................................................
     C*
     C*** Set up Fields
     C*
     C***   Destination Correspondent Code
     C                   MOVE      DRDCOR        PPDCOR
     C*
     C***   Destination Correspondent Name
      *                                                                                       CCG024
      ** If feature CCG024 is on and special character is found in DRDCOR                     CCG024
     C                   MOVEL     'N'           XFOUND            1                          CCG024
     C     CCG024        IFEQ      'Y'                                                        CCG024
     C     SVAL11        SCAN      DRDCOR                                 99                  CCG024
     C     *IN99         IFEQ      *ON                                                        CCG024
     C                   MOVEL     DRDCOR        XXCORR            6                          CCG024
     C     XXCORR        CHAIN     CGCORRL4                           88                      CCG024
     C     *IN88         IFEQ      *ON                                                        CCG024
     C                   MOVEL     'CGCORRL0'    W0FILE                                       CCG024
     C                   MOVEL     DRDCOR        W0KEY                                        CCG024
     C                   Z-ADD     89            W0ERNB                                       CCG024
     C                   MOVEL     'MEM5004'     W0MSGD                                       CCG024
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CCG024
     C                   EXSR      SRERR                                                      CCG024
     C                   ENDIF                                                                CCG024
     C                   MOVEL     'Y'           XFOUND                                       CCG024
     C                   ENDIF                                                                CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
     C     XFOUND        IFEQ      'N'
     C     DRDCOR        CHAIN     CGCORRL0                           88
     C     *IN88         IFEQ      *ON
     C                   MOVEL     'CGCORRL0'    W0FILE                         **************
     C                   MOVEL     DRDCOR        W0KEY                          *DB ERROR 04 *
     C                   Z-ADD     4             W0ERNB                         **************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF                                                                CCG024
     C*
     C                   MOVE      CDCORN        PPDCRN
     C*
     C***   Primary Correspondent is Destination Correspondent?
     C     DRPCOR        IFEQ      *BLANKS
     C***     Yes
     C                   MOVE      DRDCOR        PPPCOR
     C******************** MOVE CDCORN    PPPCRN                                              089984
     C*
     C                   ELSE
     C***     No
     C***     Primary Correspondent Code
     C                   MOVE      DRPCOR        PPPCOR
     C*
     C***     Primary Correspondent Name
     C     DRPCOR        CHAIN     CGCORRL0                           88
     C     *IN88         IFEQ      *ON
     C                   MOVEL     'CGCORRL0'    W0FILE                         **************
     C                   MOVEL     DRPCOR        W0KEY                          *DB ERROR 05 *
     C                   Z-ADD     5             W0ERNB                         **************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C*
     C******************** MOVE CDCORN    PPPCRN                                              089984
     C                   ENDIF
     C*
     C***   Print Item Type and Subtype
     C                   MOVE      DRPTYP        PPPTYP
     C                   MOVE      DRPSTP        PPPSTP
      *                                                                                       089984
     C                   MOVEL     DRITEM        PPITEM                                       089984
      *                                                                                       089984
     C*
     C***   Midas Transaction Reference
     C                   MOVE      DRMTRN        PPMTRN
     C*
     C***   Account
     C                   MOVE      DRMACT        PPMACT
     C*
     C***   Item Status Code
     C                   MOVE      DRISTS        PPISTS
     C*
     C***   Item Status Description
      *********                                                                               089984
     C*********  DRISTS    CHAINCGISTSL0             87                                       089984
     C*********  *IN87     IFEQ *ON                                                           089984
     C*********            MOVEL##IDES    PPIDES                                              089984
     C*********            ELSE                                                               089984
     C*********                                                                               089984
     C*********            MOVE ISDESC    PPIDES                                              089984
     C*********            ENDIF                                                              089984
     C*
     C***   Generation Date
     C     DRRDNB        IFNE      *ZEROS                                                     086136
     C                   MOVE      DRRDNB        #ZDAYN
     C                   EXSR      CNVDAT
     C                   MOVE      #ZDATA        PPARDT
     C                   ELSE                                                                 086136
     C                   MOVE      *BLANKS       PPARDT                                       086136
     C                   ENDIF                                                                086136
     C*
     C***   Scheduled Print Date
     C                   SELECT                                                               226537
     C     DRPRTD        WHENGT    0                                                          226537
     C********** DRPRTD    IFNE *ZEROS                                                 086136 226537
     C                   MOVE      DRPRTD        #ZDAYN
     C                   EXSR      CNVDAT
     C                   MOVE      #ZDATA        PPPRTD
     C     DRPRTD        WHENEQ    0                                                          226537
     C                   MOVEL     'IMED   '     PPPRTD                                       226537
     C     DRPRTD        WHENEQ    -1                                                         226537
     C                   MOVEL     'HOLD   '     PPPRTD                                       226537
     C                   OTHER                                                                226537
     C                   MOVEL     'Unknown'     PPPRTD                                       226537
     C                   ENDSL                                                                226537
     C**********           ELSE                                                        086136 226537
     C**********           MOVE *BLANKS   PPPRTD                                       086136 226537
     C**********           ENDIF                                                       086136 226537
     C*
     C******Scheduled*Drop*Date                                                               086136
     C***   Retention period                                                                  086136
     C***********          MOVE DRDDAT    #ZDAYN                                              086136
     C***********          EXSR CNVDAT                                                        086136
     C***********          MOVE #ZDATA    PPDDAT                                              086136
     C     P#ARCH        IFEQ      'C'                                                        086136
     C                   Z-ADD     DRDDAT        PPDDAT                                       086136
     C                   ELSE                                                                 086136
     C     DRDDAT        IFEQ      *ZEROS                                                     086136
     C                   MOVE      *BLANKS       P1DDAT                                       086136
     C                   ELSE                                                                 086136
     C                   MOVE      DRDDAT        #ZDAYN                                       086136
     C                   EXSR      CNVDAT                                                     086136
     C                   MOVE      #ZDATA        P1DDAT                                       086136
     C                   ENDIF                                                                086136
     C                   ENDIF                                                                086136
     C*
     C***   Language Id.
     C                   MOVE      DRLGID        PPLGID
     C*
     C*** Print the record
     C***   Summary
     C     PSSUMM        IFEQ      'Y'
     C                   WRITE     P1DETS
     C*
     C                   ELSE
     C***   Detail
     C                   WRITE     P1RULE
     C                   WRITE     P1DETL
     C***   Force overflow for detail report
     C     LINE          IFGT      45
     C                   ADD       11            LINE
     C                   ENDIF
     C                   ENDIF
     C*
     C*
     C*
     C*................................................................
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C*                                                               *
     C* PRTSEL - Print Selection Page                                 *
     C*                                                               *
     C* Called by: SYSLVL, ALLBCH, SNGBCH                             *
     C*                                                               *
     C* Calls: CNVDAT                                                 *
     C*                                                               *
     C*****************************************************************
     C*
     C     PRTSEL        BEGSR
     C*
     C*** Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'PRTSEL'      @STK(Q)
     C*
     C*................................................................
     C*
     C*** Setup dates
     C*
     C***   From Date
     C     ##FRDT        IFNE      *ZEROS                                                     086136
     C                   MOVE      ##FRDT        #ZDAYN
     C                   EXSR      CNVDAT
     C                   MOVE      #ZDATA        PSFRDT
     C                   ELSE                                                                 086136
     C                   MOVE      *BLANKS       PSFRDT                                       086136
     C                   ENDIF                                                                086136
     C*
     C***   To Date
     C     ##TODT        IFNE      *ZEROS                                                     086136
     C                   MOVE      ##TODT        #ZDAYN
     C                   EXSR      CNVDAT
     C                   MOVE      #ZDATA        PSTODT
     C                   ELSE                                                                 086136
     C                   MOVE      *BLANKS       PSTODT                                       086136
     C                   ENDIF                                                                086136
      *                                                                                       086662
      **  Ascertain whether Correspondent or Correspondent type.                              086662
     C     PSCOT         IFEQ      'T'                                                        086662
     C     *LIKE         DEFINE    PSDCOR        W1DCOR                                       086662
     C                   MOVEL     PSDCOR        W1DCOR                                       086662
     C                   MOVEL     PSDCOR        PSCTYP                                       086662
     C                   MOVE      *BLANKS       PSDCOR                                       086662
     C                   ENDIF                                                                086662
     C*
     C*** Print selections
     C                   WRITE     P1SELEC
     C*
     C*** Reset                                                                               086662
     C                   MOVEL     W1DCOR        PSDCOR                                       086662
     C*
     C*
     C*................................................................
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*
     C*
     C*****************************************************************
     C*                                                               *
     C* PRTHED - Print Header                                         *
     C*                                                               *
     C* Called by: SYSLVL, ALLBCH, SNGBCH                             *
     C*                                                               *
     C* Calls: CNVDAT                                                 *
     C*                                                               *
     C*****************************************************************
     C*
     C     PRTHED        BEGSR
     C*
     C*** Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'PRTHED'      @STK(Q)
     C*
     C*................................................................
     C*
     C*
     C                   SELECT
     C     PSSUMM        WHENEQ    'Y'
     C*** Summary Report Headings
     C                   WRITE     P1HEADA
     C                   WRITE     P1HEADB
     C                   WRITE     P1RULE
     C*
     C                   OTHER
     C*** Detail Report Headings
     C                   WRITE     P1HEADA
     C*
     C                   ENDSL
     C*
     C*
     C*
     C*................................................................
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C*                                                               *
     C* RTVBRC - Retrieve the Branch Details                          *
     C*                                                               *
     C* Called by: SYSLVL, ALLBCH                                     *
     C*                                                               *
     C* Calls: AOBRCHR0(pgm), SRERR                                   *
     C*                                                               *
     C*****************************************************************
     C*
     C     RTVBRC        BEGSR
     C*
     C*** Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'RTVBRC'      @STK(Q)
     C*
     C*................................................................
     C*
     C*** Retrieve Branch Details
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      '*KEY    '    ##OPTN            7
     C                   PARM      ##BRC         ##BRCD
     C********** SDBRCH    PARM SDBRCH    DSFDY                                               CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C***   Error handling for access object
     C     ##RTCD        IFNE      *BLANKS
     C                   MOVEL     'AOBRCHR0'    W0FILE                         **************
     C                   MOVEL     ##BRC         W0KEY                          *DB ERROR 03 *
     C                   Z-ADD     3             W0ERNB                         **************
     C                   MOVEL     'MEM5001'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C*
     C                   MOVEL     A8BRNM        PPBRNM
     C                   MOVEL     DRBRCA        PPBRCD
     C*
     C*
     C*
     C*................................................................
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C*                                                               *
     C* CNVDAT - Convert Day Number                                   *
     C*                                                               *
     C* Called by: SYSLVL, PRTDET                                     *
     C*                                                               *
     C* Calls: ZA0140(pgm)                                            *
     C*                                                               *
     C*****************************************************************
     C*
     C     CNVDAT        BEGSR
     C*
     C*** Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'CNVDAT'      @STK(Q)
     C*
     C*................................................................
     C*
     C                   CALL      'ZA0140'
     C                   PARM                    #ZDAYN            5 0
     C                   PARM      DATF          #ZDFMT            1
     C                   PARM                    #ZDATE            6 0
     C                   PARM                    #ZDATA            7
     C                   PARM                    SSRTN             1
     C                   PARM                    SSDAT8            8 0
     C*
     C*
     C*
     C*................................................................
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C*                                                               *
     C* RECONE -  Get the First Record                                *
     C*                                                               *
     C* Called by: INIT                                               *
     C*                                                               *
     C* Calls: SPLF, CNVDAT                                           *
     C*                                                               *
     C*****************************************************************
     C*
     C     RECONE        BEGSR
     C*
     C*** Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'RECONE'      @STK(Q)
     C*
     C*................................................................
     C*
     C*** Access Correspondence Item File
     C     P#ARCH        IFEQ      'A'
     C                   READ      CGXDCRPD                               89
     C                   ELSE
     C                   READ      CGUDCRPD                               89
     C                   ENDIF
     C*
     C*** Open report and log to RCF
     C                   OPEN      CG5410P1
     C                   MOVE      PFILE         SFILE
     C                   Z-ADD     PFNUM         ZSNUM
     C     P#RLVL        IFEQ      'S'
     C                   MOVE      *BLANKS       ZSENTY
     C                   ELSE
     C                   MOVE      DRBRCA        ZSENTY
     C                   ENDIF
     C                   EXSR      SPLF
     C*
     C*** No records to be printed
     C     *IN89         IFEQ      *ON
     C*
     C***   Print selection page and 'no records'
     C                   EXSR      PRTSEL
     C                   WRITE     P1NOREC
     C*
     C                   ENDIF
     C*
     C*
     C*
     C*................................................................
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C*                                                               *
     C* SPLF   -  Log Spool File to RCF via ZSFILE                    *
     C*                                                               *
     C* Called by: INIT                                               *
     C*                                                               *
     C* Calls: ZSFILE(pgm), *PSSR                                     *
     C*                                                               *
     C*****************************************************************
     C*
     C     SPLF          BEGSR
     C*
     C*** Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SPLF'        @STK(Q)
     C*
     C*................................................................
     C*
     C*
     C                   CALL      'ZSFILE'
     C                   PARM      P#RSEQ        ZSSEQ             5
     C                   PARM                    ZSENTY            3
     C                   PARM                    SFILE            10
     C                   PARM                    ZSNUM             6 0
     C                   PARM                    ZSERR             1
     C*
     C     ZSERR         IFEQ      'Y'
     C                   MOVEL     'ZSFILE  '    W0FILE                         **************
     C                   MOVEL     'ONLY    '    W0KEY                          *DB ERROR 06 *
     C                   Z-ADD     6             W0ERNB                         **************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C*
     C*
     C*
     C*................................................................
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C*                                                               *
     C* SRAUDT -  Audit Report Processing                             *
     C*                                                               *
     C* Called by: FINAL                                              *
     C*                                                               *
     C* Calls: CGZAUDIT(pgm)                                          *
     C*                                                               *
     C*****************************************************************
     C*
     C     SRAUDT        BEGSR
     C*
     C*** Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRAUDT'      @STK(Q)
     C*
     C*................................................................
     C*
      *
      **  Open the Audit Print File.
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG5410AU'    I#SPLN
     C                   MOVEL     'CG5410  '    I#REF
     C                   MOVE      'CGD1777'     I#TITL
     C                   MOVE      'CGD1778'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C*
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN             7
     C                   PARM      '*OPEN   '    W0ACT             8
     C                   PARM                    I#DTA
     C                   PARM                    W0RSQN            5
     C*
     C**  Output the Count of records read
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG5410  '    I#REF
     C                   MOVE      'CGD1777'     I#TITL
     C                   MOVE      'CGD1778'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVE      '*LINE   '    W1ACT
     C                   MOVE      *BLANKS       I#SUB
     C     P#ARCH        IFEQ      'A'
     C                   MOVEL     'CGXDCRPD'    I#SUB
     C                   ELSE
     C                   MOVEL     'CGUDCRPD'    I#SUB
     C                   ENDIF
     C                   MOVEL     'CAD1021'     I#TEXT
     C                   Z-ADD     ##DREC        I#QTY
     C                   Z-ADD     *ZERO         I#DECS
     C                   MOVE      '1'           I#EDIT
     C*
     C                   CALL      'CGZAUDIT'
     C                   PARM                    W1RTN             7
     C                   PARM                    W1ACT             8
     C                   PARM                    I#DTA
     C                   PARM                    W1RSQN            5
      *
      **  Skip a line.
     C                   MOVE      '*SKIP   '    W1ACT
     C*
     C                   CALL      'CGZAUDIT'
     C                   PARM                    W1RTN             7
     C                   PARM                    W1ACT             8
     C                   PARM                    I#DTA
     C                   PARM                    W1RSQN            5
      *
      **  Close the Audit Print File.
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG5410  '    I#REF
     C                   MOVE      'CGD1777'     I#TITL
     C                   MOVE      'CGD1778'     I#TUL
     C                   MOVEL     'CAD1008'     I#TEXT
     C                   MOVEL     'CGUSRMSG'    I#FILE
      *
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       ##RTCD
     C                   PARM      '*CLOSE  '    W0ACT             8
     C                   PARM                    I#DTA
     C                   PARM                    W0RSQN            5
     C*
     C*
     C*
     C*................................................................
     C*
     C**  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*COPY*CGCPYSRC,SRERRC                                                                 MD056543
     C/COPY CGCPYSRC,SRERRCLE                                                               MD056543
     C/EJECT
** CPY@   **      Object copyright
(c) Finastra International Limited 2001
