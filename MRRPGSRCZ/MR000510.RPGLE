     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*XBIA*  DSPOBJD OBJ(TRANSA) OBJTYPE(*FILE) OUTPUT(*OUTFILE)          *
/*XBIA*                                    OUTFILE(QTEMP/MRQRY)       *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MR Extract Queries')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting module                           *
      *                                                               *
      *  RPGLE/MR000510 - Extract Queries                             *
      *                                                               *
      *  Function:  This module will read MRQRY as an input primary   *
      *             file.  For each required record from MRQRY, a     *
      *             record will be written to file MRQRYRPD.          *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CMR001  *CREATE    Date 16Aug04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Queries
     FMRQRY     IF   E             DISK    INFSR(*PSSR)
 
      ** Queries to be Run File
     FMRQRYRPD  UF A E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WKRUN           S              1
     D PRetCode        S              7
     D POption         S              7
     D I#ERMS          S             30
 
      ** Midas Day number
     D Day             S              5P 0
 
      ** Formatted date field for use in the parameter list
     D Date            S              8S 0
     D RunMth          S              2A
     D NWDMth          S              2A
 
      ** Date data structure
     D                 DS
     D DateC                   1      8
     D Month                   5      6
 
      ** Description data structure
     D                 DS
     D Text                    3     50
     D Freq                    3      4
     D ComSeq                  5      9
     D Seq                    10     11
 
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
 
     C     1             SETLL     MRQRY
 
     C                   READ      MRQRY
 
     C                   DOW       NOT %EOF(MRQRY)
 
     C                   MOVEL     ODOBTX        Text
 
      ** Process only records with required frequency
     C     Freq          IFEQ      'D '
     C     Freq          OREQ      ' D'
     C                   EXSR      SRProcess
     C                   ENDIF
 
     C     MonthEnd      IFEQ      'Y'
     C     Freq          IFEQ      'M '
     C     Freq          OREQ      ' M'
     C                   EXSR      SRProcess
     C                   ENDIF
     C                   ENDIF
 
     C     QuarterEnd    IFEQ      'Y'
     C     Freq          IFEQ      'QC'
     C     Freq          OREQ      'QF'
     C                   EXSR      SRProcess
     C                   ENDIF
     C                   ENDIF
 
     C     HalfYearEndCALIFEQ      'Y'
     C     Freq          ANDEQ     'HC'
     C                   EXSR      SRProcess
     C                   ENDIF
 
     C     HalfYearEndFINIFEQ      'Y'
     C     Freq          ANDEQ     'HF'
     C                   EXSR      SRProcess
     C                   ENDIF
 
     C     YearEndCAL    IFEQ      'Y'
     C     Freq          ANDEQ     'YC'
     C                   EXSR      SRProcess
     C                   ENDIF
 
     C     YearEndFIN    IFEQ      'Y'
     C     Freq          ANDEQ     'YF'
     C                   EXSR      SRProcess
     C                   ENDIF
 
     C                   READ      MRQRY
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Subroutine that Processes Records to be Written  *
      *              to the Extract File                              *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
 
      ** Set Query Name
     C                   EVAL      QRNAME = ODOBNM
 
      ** Set Description
     C                   EVAL      QRTEXT = ODOBTX
 
      ** Set Frequency
     C                   EVAL      QRFREQ = Freq
 
      ** Set Component Sequence
     C                   MOVEL     ComSeq        QRCMSQ
 
      ** Set Sequence
     C                   MOVEL     Seq           QRSEQ
 
      ** Set Processed
     C                   MOVEL     'N'           QRPROC
 
      ** Write record to output file
     C                   WRITE     MRQRYRD0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetMonth  - Subroutine that Gets Month via ZDATE9          *
      *                                                               *
      *****************************************************************
     C     SRGetMonth    BEGSR
 
     C                   CALLB     'ZDATE9'
     C                   PARM                    DAY
      ** Output
     C                   PARM                    DATE
     C                   PARM                    RTN               1
     C*
     C                   MOVEL     DATE          DATEC
 
     C                   ENDSR
      *****************************************************************
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
 
     C     *INZSR        BEGSR
 
      ** Initialise LDA field.
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'MR000510'
     C                   OUT       LDA
 
     C                   IN        RUNDAT
 
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get Month of Run Date
     C                   EVAL      Day = BJRDNB
     C                   EXSR      SRGetMonth
     C                   EVAL      RunMth = Month
 
      ** Get Month of Date of Next Working Day
     C                   EVAL      Day = BJDNWD
     C                   EXSR      SRGetMonth
     C                   EVAL      NWDMth = Month
 
     C*
     C                   MOVEL     *BLANKS       MonthEnd          1
     C                   MOVEL     *BLANKS       QuarterEnd        1
     C                   MOVEL     *BLANKS       HalfYearEndCAL    1
     C                   MOVEL     *BLANKS       HalfYearEndFIN    1
     C                   MOVEL     *BLANKS       YearEndCAL        1
     C                   MOVEL     *BLANKS       YearEndFIN        1
     C*
     C     RunMth        IFNE      NWDMth
     C                   MOVEL     'Y'           MonthEnd
     C*
     C                   SELECT
     C     RunMth        WHENEQ    '03'
     C                   MOVEL     'Y'           QuarterEnd
     C                   MOVEL     'Y'           HalfYearEndFIN
     C                   MOVEL     'Y'           YearEndFIN
     C*
     C     RunMth        WHENEQ    '06'
     C                   MOVEL     'Y'           QuarterEnd
     C                   MOVEL     'Y'           HalfYearEndCAL
     C*
     C     RunMth        WHENEQ    '09'
     C                   MOVEL     'Y'           QuarterEnd
     C                   MOVEL     'Y'           HalfYearEndFIN
     C*
     C     RunMth        WHENEQ    '12'
     C                   MOVEL     'Y'           QuarterEnd
     C                   MOVEL     'Y'           HalfYearEndCAL
     C                   MOVEL     'Y'           YearEndCAL
     C                   ENDSL
     C                   ENDIF
     C*
     C*
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WkRun = *BLANK
     C                   EVAL      WkRun = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
