     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Fontis TPP file pre-processing')              *
      *****************************************************************
      *                                                               *
      *  Midas - ME module                                            *
      *                                                               *
      *  ME2003 - Fontis TPP File Pre-Processing                      *
      *                                                               *
      *  Function:  This program will be called from the TPP          *
      *             background task to                                *
      *             1) Convert the current processed member of        *
      *             MGTPPPD from ASCI to EBCDIC                       *
      *             2) For each member, an index record will be       *
      *             written to MGTPPXPD an the message data to        *
      *             MGTPPMPD                                          *
      *                                                               *
      *  Called By: MECNNN2 -                                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CGL009  *CREATE    Date 02Jun99               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL009 - Midas Fontis IAT/TPP interface                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    50         EOF of MGTPPSPD                                 *
      *    90         General error indicator                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR  - Error processing                                    *
      *  *INZSR - Initialise                                          *
      *  SRCONV - Convert ASCII to EBCDIC                             *
      *  SRMDTA - Write header record to MGTPPMPD                     *
      *  SRINDX - Write header record to MGTPPXPD                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      * Fontis third party message Interface file
     FMGTPPSPD  IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
      * Fontis third party message Index
     FMGTPPXPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      * Fontis third party message Data
     FMGTPPMPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     FME2003AU  O    E             PRINTER
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /SPACE 3
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Data Area giving Installation Control Details
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** Account details
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
      /EJECT
      *
      ** Working
     DWMOR             DS
     DFFMODE
     DFFMOTM
      *
     DWSZDATA          S              2  0
     DWSZEBC           S              4  0
      ** Used only to define the size of arrays
     DWSDATA           S             40
      ** We use WSEBC to concatenate incoming data after
      ** they have been translated in EBCDIC
     DWSEBC            S           9999
      *
      ** Arrays
     DWDATA            DS
      ** We use the array DATA@ to write records, but also to scan presence
      ** of :tag: of which value are not filled necessary in the same record
      ** in MGTPPSPD
     DDATA@                         256    DIM(%SIZE(WSDATA))
      *
      ** Indexes
     DI                S                   LIKE(WSZDATA)
     DWPOS             S                   LIKE(WSZEBC)
      *
      ** Parameters for ZA0140M
     DSSRTN            S              1
     DSSDAYN           S              5  0
     DSSDFMT           S              1
     DSSDATE           S              6  0
     DSSDATA           S              7
     DSSDAT8           S              8  0
     DSSDAT8F          S              8  0
      *
      ** Parameters for AOACCTR0
     DP@RTCD           S              7
     DP@OPTN           S              7
     DP@RETL           S             10
     DP@CNUM           S              6
     DP@CUCD           S              3
     D***P@ACCD*          S              4                                                    CGL029
     DP@ACCD           S             10                                                       CGL029
     DP@ACSQ           S              2
     DP@BRCA           S              3
     D****ACCNT
      *
      ** Parameters for QDCXLATE
     DP#DALN           S              5  0
     DP#CVDA           S            256
     DP#CVTB           S             10
     DP#TBLB           S             10
     D*
     D** Define carriage return/line feed control characters
     D                 DS
     D  W@CR                   1      1    INZ(X'0D')
     D  W@LF                   2      2    INZ(X'25')
     D  W@CRLF                 1      2
     D*
      /SPACE 3
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE
      *****************************************************************
     C                   MOVEL     *BLANK        DATA@
     C                   Z-ADD     1             WPOS
      *
     C                   OPEN      MGTPPSPD
      *
     C     1             SETLL     MGTPPSPD
     C                   READ      MGTPPSPD                               50
     C     *IN50         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     001           DBASE
     C                   MOVEL(P)  'MGTPPSPD'    DBFILE
     C                   MOVEL(P)  '*FIRST'      DBKEY
     C                   WRITE     HEADAU
     C                   WRITE     DBEROR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     *BLANK        WSEBC
      *
     C     *IN50         DOWEQ     '0'
      *
      ** Translate datas from ASCII to EBCDIC
     C                   EXSR      SRCONV
      *
      ** Append new data translated to the existing one
     C     WSEBC         CAT       P#CVDA:0      WSEBC
      *
     C                   READ      MGTPPSPD                               50
      *
     C                   ENDDO
      *
     C                   MOVEA     WSEBC         DATA@
      *
      ** Create 'data' record
     C                   EXSR      SRMDTA
      ** Create 'index' record
     C                   EXSR      SRINDX
      *
     C                   CLOSE     MGTPPSPD
      *
     C                   RETURN
      /EJECT
      *****************************************************************
      * S/R SRCONV Convert ASCII to EBCDIC                            *
      * CALLED BY MAIN PROCEDURE                                      *
      * CALLS :                                                       *
      *****************************************************************
     C     SRCONV        BEGSR
      *
     C                   CALL      'QDCXLATE'                           90
     C                   PARM      256           P#DALN
     C                   PARM      FEDATA        P#CVDA
     C                   PARM      'QTCPEBC'     P#CVTB
     C                   PARM      'QUSRSYS'     P#TBLB
      *
     C     *IN90         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     002           DBASE
     C                   MOVEL(P)  'QDCXLATE'    DBFILE
     C                   MOVEL(P)  FEDATA        DBKEY
     C                   WRITE     HEADAU
     C                   WRITE     DBEROR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     END_SRCONV    ENDSR
      *****************************************************************
      * S/R SRMDTA Write header record to MGTPPMPD                    *
      * CALLED BY MAIN PROCEDURE                                      *
      * CALLS :                                                       *
      *****************************************************************
     C     SRMDTA        BEGSR
      *
     C                   Z-ADD     1             I
     C     DATA@(I)      DOWNE     *BLANK
     C                   MOVEA     DATA@(I)      FGMDTA
     C                   MOVEL     P#MIR         FGMIR
      *
     C                   WRITE     MGTPPMD0                             90
     C     *IN90         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     003           DBASE
     C                   MOVEL(P)  'MGTPPMPD'    DBFILE
     C                   MOVEL(P)  P#MIR         DBKEY
     C                   WRITE     HEADAU
     C                   WRITE     DBEROR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ADD       1             I
      *
     C     I             IFGT      WSZDATA
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     END_SRMDTA    ENDSR
      *****************************************************************
      * S/R SRINDX Write header record to MGTPPXPD                    *
      * CALLED BY MAIN PROCEDURE                                      *
      * CALLS :                                                       *
      *****************************************************************
     C     SRINDX        BEGSR
     C                   MOVEL     '100'         FFMTPY
      *
      ** Retrieve branch code of account present in tag 53B
     C     ':53B:'       SCAN      WDATA         WBG               4 0
      *
     C     WBG           IFEQ      0
     C                   MOVEL     BKMABR        FFBRCA
     C                   ENDIF
     C*
     C     WBG           IFNE      0
      *
      ** Account line starts with a '/'
     C                   ADD       6             WBG
      ** If it is a retail number
     C                   IF        (%SUBST(WDATA:WBG+10:2) = *blank)
     C                   EVAL      P@RETL = %SUBST(WDATA:WBG:10)
     C                   MOVEL     *BLANK        P@CNUM
     C                   MOVEL     *BLANK        P@CUCD
     C                   MOVEL     *BLANK        P@ACCD
     C                   MOVEL     *BLANK        P@ACSQ
     C                   MOVEL     *BLANK        P@BRCA
     C                   ELSE
      ** If it is a G/L account number
     C                   MOVEL     *BLANK        P@RETL
     C                   EVAL      P@BRCA = %SUBST(WDATA:WBG:3)
     C                   EVAL      P@CNUM = %SUBST(WDATA:WBG+3:6)
     C                   EVAL      P@CUCD = %SUBST(WDATA:WBG+9:3)
     C                   EVAL      P@ACCD = %SUBST(WDATA:WBG+12:4)
     C                   EVAL      P@ACSQ = %SUBST(WDATA:WBG+16:2)
     C                   ENDIF
     C                   CALLB     'AOACCTR0'                           90
     C                   PARM                    P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM                    P@RETL
     C                   PARM                    P@CNUM
     C                   PARM                    P@CUCD
     C                   PARM                    P@ACCD
     C                   PARM                    P@ACSQ
     C                   PARM                    P@BRCA
     C                   PARM                    ACCNT
      *
     C     *IN90         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     004           DBASE
     C                   MOVEL(P)  'AOACCTR0'    DBFILE
     C                   MOVEL(P)  'CALL'        DBKEY
     C                   WRITE     HEADAU
     C                   WRITE     DBEROR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     P@RTCD        IFNE      *BLANK
     C                   MOVEL     BKMABR        FFBRCA
     C                   ELSE
     C                   MOVEL     BRCA          FFBRCA
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Convert Midas rundate in CCYYMMDD
     C                   CALLB     'ZA0140M'                            90
     C                   PARM                    SSRTN
     C                   PARM      BJRDNB        SSDAYN
     C                   PARM      AGDFF         SSDFMT
     C                   PARM                    SSDATE
     C                   PARM                    SSDATA
     C                   PARM                    SSDAT8
     C                   PARM                    SSDAT8F
      *
     C     SSRTN         IFNE      '0'
     C     *IN90         OREQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     005           DBASE
     C                   MOVEL(P)  'ZA0140M'     DBFILE
     C                   MOVEL(P)  BJRDNB        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      SSDAT8        FFMODE
      ** Retrieve time HHMMSS
     C                   TIME                    FFMOTM
      *
     C                   MOVEL     P#MIR         FFMIR
     C                   MOVEL     'N'           FFMPRY
     C                   MOVEL     WMOR          FFMOR
     C                   MOVEL     *BLANK        FFIMPF
      *
     C                   WRITE     MGTPPXD0                             90
     C     *IN90         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     006           DBASE
     C                   MOVEL(P)  'MGTPPXPD'    DBFILE
     C                   MOVEL(P)  P#MIR         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     END_SRINDX    ENDSR
      /EJECT
      *****************************************************************
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
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ***************
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ROLBK
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ******************
      *
     C******BATCH********CALL      'DBERRCTL'
      *
      ********************************************************************
     C                   END
      *
      ************ END PROGRAM IF DBERRCTL NOT CALLED ********************
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    P#MIR            10
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      ** Retrieve Bank Details
     C                   CALLB     'AOBANKR0'                           90
     C                   PARM                    P@RTCD            7            B:Return code
     C                   PARM      '*FIRST'      P@OPTN            7            I:Option
     C     SDBANK        PARM      SDBANK        DSFDY                          O:Format
      *
     C     P@RTCD        IFNE      *BLANK
     C     *IN90         OREQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     007           DBASE
     C                   MOVEL(P)  'AOBANKR0'    DBFILE
     C                   MOVEL(P)  '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve General Ledger details to get main branch
     C**********         CALLB     'AOGELRR0'                           90                    CGL029
     C                   CALLB     'AOGELRR1'                           90                    CGL029
     C                   PARM                    P@RTCD            7            B:Return code
     C                   PARM      '*FIRST'      P@OPTN            7            I:Option
     C*****SDGELR        PARM      SDGELR        DSFDY                          O:FORMAT      CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
     C     P@RTCD        IFNE      *BLANK
     C     *IN90         OREQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     008           DBASE
     C                   MOVEL(P)  'AOMMODR0'    DBFILE
     C                   MOVEL(P)  '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      WSZDATA = %SIZE(WSDATA)
     C                   EVAL      WSZEBC = %SIZE(WSEBC)
      *
     C                   ENDSR
      *****************************************************************
      * SAMPLE ERROR                                                  *
      * Its a sample to show how handle errors. Don't call it         *
      *****************************************************************
     C     SPLERR        BEGSR
      *
      ***************** FOR EACH DATABASE ERROR *************************
      *
      ** Data base error in file (file)
      *
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     000           DBASE
     C                   MOVEL(P)  '(file)'      DBFILE
     C                   MOVEL(P)  '(key)'       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
