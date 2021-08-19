     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('FECCD File Formatting')                                *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM029**-*FECCD*File*Formatting*******************************                       LUC109
      *  XX000029 - FECCD File Formatting                             *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: Balance sheet Extract                              *
      *                                                               *
      *                                                               *
      ***CALLED*BY**GLCM043*-*Head*Office*reporting*extract*file*******                       LUC109
      *  Called By XXC000043 - Head Office reporting extract file     *                       LUC109
      *                       creation component                      *
      *                                                               *                       LUC109
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1993,*1994**************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend No. MUI011             Date 11May04               *
      *                 LUC010             Date 22Aug01               *
      *                 MMI043             Date 11Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MUI011 - ALMS - Add detail records 17 and 18.                *
      *  LUC010 - Changes to Head Office Extracts - Re-compiled       *
      *  MMI043 - Balance Sheet Extract                               *
      *                                                               *
      *****************************************************************
      *
     FSDBANKPD  IF   E             DISK    USROPN
     FSDINTFV0  IF   E             DISK    USROPN
     FSDGELRPP  IF   E           K DISK    USROPN
     FSDBRCHV0  IF   E           K DISK
     FFECCDDV1  IF   E           K DISK
     FCCD       O    E             DISK
      *
      ** Reconciliation detail
     FGLRECOPP  IF A E             DISK
      *
      ** Reconciliation Totals
     FGLRECOV0  UF   E           K DISK
     F                                     RENAME(GLRECOPF:RECTOT)
      *
      ** Currency File
     FSDCURRL0  IF   E           K DISK
      *
      *
      ** External Data Structure for CCD file
      *
     D R00000        E DS
     D R02000        E DS
     D R05001        E DS
     D R05002        E DS
     D R05003        E DS
     D R05004        E DS
     D R05005        E DS
     D R05006        E DS
     D R05007        E DS
     D R05008        E DS
     D R05009        E DS
     D R05010        E DS
     D R05011        E DS
     D R05012        E DS
     D R05013        E DS
     D R05014        E DS
     D R05015        E DS
     D R05016        E DS
     D R05017        E DS                                                       MUI011
     D R05018        E DS                                                       MUI011
     D R99000        E DS
      *
     D                 DS
     D  @@ACB1                 1     18
     D  @@ACB2                 1     18  3
     D                 DS
     D  WKACNM                 1     18
     D  WKACCY                10     12
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   01 - LF/FECCDDV1   File I                                   *
      *   02 - LF/SDBRCHV0   File I                                   *
      *                                                               *
      *   LR - LF/SDBANKPD   File I                                   *
      *   LR - LF/SDINTFV0   File I                                   *
      *   LR - LF/SDGELRPP   File I                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  MAIN   - Main Processing                                     *
      *  SBRCH  - Processing each Branch                              *
      *  SFECCD - Processing each Extraction Record for Branch        *
      *  S00000 - Writing Branch Initial Record                       *
      *  S02000 - Writing Header Record                               *
      *  S05001/S05018 - Writing Details Records                      *
      *  S09000 - Writing Branch Final Record                         *
      *  S99000 - Writing Footer Record                               *
      ***GLM053*-*Calling*Routine*GLM053*for*date*conversion***********                       LUC109
      *  GLM053 - Calling Routine XX000053 for date conversion        *                       LUC109
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
      *
      *
     IGLRECOPF                                                                  S01158
     I              RECID                       DRECID                          S01158
     I              C9151                       DC9151                          S01158
     I              C9150                       DC9150                          S01158
     I              C0301                       DC0301                          S01158
     IRECTOT                                                                    S01158
     I              RECID                       TRECID                          S01158
     I              C9151                       TC9151                          S01158
     I              C9150                       TC9150                          S01158
     I              C0301                       TC0301                          S01158
      *
      **********************************************************************
      *
      * M A I N   L I N E
      *
      **********************************************************************
      *
     C     *INLR         IFNE      *ON
      *
     C                   EXSR      S00000
     C                   EXSR      SBRCH
     C                   EXSR      S99000
      *
     C                   ENDIF
      *
     C                   MOVE      *ON           *INLR
      *
      *****************************************************************
      *                                                               *
      *  SBRCH  -  Reading and processing each Branch                 *
      *                                                               *
      *  Called By: Main line                                         *
      *  Calls: S02000 - SFECCD - S09000                              *
      *                                                               *
      *****************************************************************
      *
     C     SBRCH         BEGSR
      *
     C     *LOVAL        SETLL     SDBRCHD0
     C                   READ      SDBRCHD0                               02
      *
     C     *IN02         DOWEQ     *OFF
     C                   EXSR      S02000
     C                   EXSR      SFECCD
     C                   EXSR      S09000
      *
     C                   READ      SDBRCHD0                               02
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SFECCD -  Reading and processing each record extraction      *
      *            for the considered Branch                          *
      *                                                               *
      *  Called By: SBRCH                                             *
      *  Calls: from S05001 to S05018                                 *
      *                                                               *
      *****************************************************************
      *
     C     SFECCD        BEGSR
      *
     C     A8BRCD        SETLL     FECCDDP0
     C     A8BRCD        READE     FECCDDP0                               01
      *
     C     *IN01         DOWEQ     *OFF
     C                   EXSR      S05001
     C                   EXSR      S05002
     C                   EXSR      S05003
     C                   EXSR      S05004
     C                   EXSR      S05005
     C                   EXSR      S05006
     C                   EXSR      S05007
     C                   EXSR      S05008
     C                   EXSR      S05009
     C                   EXSR      S05010
     C                   EXSR      S05011
     C                   EXSR      S05012
     C                   EXSR      S05013
     C                   EXSR      S05014
     C                   EXSR      S05015
     C                   EXSR      S05016
     C                   EXSR      S05017                                                      MUI01
     C                   EXSR      S05018                                                      MUI01
      *
      * Maintain Account Balances for reconciliation
     C     C9151         IFNE      *BLANKS
     C                   MOVE      C9151         WKACNM
     C                   EXSR      #RECO
     C                   ENDIF
      *
     C     A8BRCD        READE     FECCDDP0                               01
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S02000 -  Writing Branch Initial Record                      *
      *                                                               *
      *  Called By: SBRCH                                             *
      *                                                               *
      *****************************************************************
      *
     C     S02000        BEGSR
      *
     C                   RESET                   CCDR
     C                   RESET                   R02000
      *
     C                   Z-ADD     02            TYPE
     C                   MOVE      A8BRCD        BRCODE
      *
     C                   MOVE      R02000        DATA
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05001 -  Writing Detail Record - Progressive 001            *
      *                                                               *
      *  Called By: SFECCD                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05001        BEGSR
      *
     C                   RESET                   CCDR
      *
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     001           P05001
      *
     C                   MOVE      R05001        DATA
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05002 -  Writing Detail Record - Progressive 002            *
      *                                                               *
      *  Called By: SFECCD                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05002        BEGSR
      *
     C                   RESET                   CCDR
      *
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     002           P05002
      *
     C                   MOVE      R05002        DATA
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05003 -  Writing Detail Record - Progressive 003            *
      *                                                               *
      *  Called By: SFECCD                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05003        BEGSR
      *
     C                   RESET                   CCDR
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     003           P05003
     C                   MOVE      R05003        DATA
      *
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05004 -  Writing Detail Record - Progressive 004            *
      *                                                               *
      *  Called By: SFECCD                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05004        BEGSR
      *
     C                   RESET                   CCDR
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     004           P05004
     C                   MOVE      R05004        DATA
      *
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05005 -  Writing Detail Record - Progressive 005            *
      *                                                               *
      *  Called By: SFECCD                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05005        BEGSR
      *
     C                   RESET                   CCDR
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     005           P05005
     C                   MOVE      R05005        DATA
      *
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05006 -  Writing Detail Record - Progressive 006            *
      *                                                               *
      *  Called By: SFECCD                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05006        BEGSR
      *
     C                   RESET                   CCDR
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     006           P05006
     C                   MOVE      R05006        DATA
      *
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05007 -  Writing Detail Record - Progressive 007            *
      *                                                               *
      *  Called By: SFECCD                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05007        BEGSR
      *
     C                   RESET                   CCDR
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     007           P05007
     C                   MOVE      R05007        DATA
      *
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05008 -  Writing Detail Record - Progressive 008            *
      *                                                               *
      *  Called By: SFECCD                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05008        BEGSR
      *
     C                   RESET                   CCDR
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     008           P05008
     C                   MOVE      R05008        DATA
      *
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05009 -  Writing Detail Record - Progressive 009            *
      *                                                               *
      *  Called By: SFECCD                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05009        BEGSR
      *
     C                   RESET                   CCDR
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     009           P05009
     C                   MOVE      R05009        DATA
      *
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05010 -  Writing Detail Record - Progressive 010            *
      *                                                               *
      *  Called By: SFECCD                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05010        BEGSR
      *
     C                   RESET                   CCDR
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     010           P05010
     C                   MOVE      R05010        DATA
      *
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05011 -  Writing Detail Record - Progressive 011            *
      *                                                               *
      *  Called By: SFECCD                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05011        BEGSR
      *
     C                   RESET                   CCDR
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     011           P05011
     C                   MOVE      R05011        DATA
      *
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05012 -  Writing Detail Record - Progressive 012            *
      *                                                               *
      *  Called By: SFECCD                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05012        BEGSR
      *
     C                   RESET                   CCDR
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     012           P05012
     C                   MOVE      R05012        DATA
      *
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05013 -  Writing Detail Record - Progressive 013            *
      *                                                               *
      *  Called By: SFECCD                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05013        BEGSR
      *
     C                   RESET                   CCDR
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     013           P05013
     C                   MOVE      R05013        DATA
      *
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05014 -  Writing Detail Record - Progressive 014            *
      *                                                               *
      *  Called By: SFECCD                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05014        BEGSR
      *
     C                   RESET                   CCDR
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     014           P05014
     C                   MOVE      R05014        DATA
      *
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05015 -  Writing Detail Record - Progressive 015            *
      *                                                               *
      *  Called By: SFECCD                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05015        BEGSR
      *
     C                   RESET                   CCDR
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     015           P05015
     C                   MOVE      R05015        DATA
      *
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05016 -  Writing Detail Record - Progressive 016            *
      *                                                               *
      *  Called By: SFECCD                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05016        BEGSR
      *
     C                   RESET                   CCDR
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     016           P05016
     C                   MOVE      R05016        DATA
      *
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *****************************************************************   MUI011
      *                                                               *   MUI011
      *  S05017 -  Writing Detail Record - Progressive 017            *   MUI011
      *                                                               *   MUI011
      *  Called By: SFECCD                                            *   MUI011
      *                                                               *   MUI011
      *****************************************************************   MUI011
      *                                                                   MUI011
     C     S05017        BEGSR                                                                 MUI01
      *                                                                   MUI011
     C                   RESET                   CCDR                                          MUI01
     C                   Z-ADD     05            TYPE                                          MUI01
     C                   Z-ADD     017           P05017                                        MUI01
     C                   MOVE      R05017        DATA                                          MUI01
      *                                                                   MUI011
     C                   ADD       1             RRN                                           MUI01
     C                   WRITE     CCDR                                                        MUI01
      *                                                                   MUI011
     C                   ENDSR                                                                 MUI01
      *                                                                   MUI011
      *****************************************************************   MUI011
      *                                                               *   MUI011
      *  S05018 -  Writing Detail Record - Progressive 018            *   MUI011
      *                                                               *   MUI011
      *  Called By: SFECCD                                            *   MUI011
      *                                                               *   MUI011
      *****************************************************************   MUI011
      *                                                                   MUI011
     C     S05018        BEGSR                                                                 MUI01
      *                                                                   MUI011
     C                   RESET                   CCDR                                          MUI01
     C                   Z-ADD     05            TYPE                                          MUI01
     C                   Z-ADD     018           P05018                                        MUI01
     C                   MOVE      R05018        DATA                                          MUI01
      *                                                                   MUI011
     C                   ADD       1             RRN                                           MUI01
     C                   WRITE     CCDR                                                        MUI01
      *                                                                   MUI011
     C                   ENDSR                                                                 MUI01
      *                                                                   MUI011
      *****************************************************************
      *                                                               *
      *  S09000 -  Writing Branch Final Record                        *
      *                                                               *
      *  Called By: SBRCH                                             *
      *                                                               *
      *****************************************************************
      *
     C     S09000        BEGSR
      *
     C                   RESET                   CCDR
      *
     C                   Z-ADD     09            TYPE
      *
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *
      *
      *****************************************************************
      *                                                               *
      *  S00000 -  Writing Header Record                              *
      *                                                               *
      *  Called By: Main line                                         *
      *                                                               *
      *****************************************************************
      *
     C     S00000        BEGSR
      *
     C                   RESET                   CCDR
     C                   RESET                   R00000
      *
     C                   Z-ADD     00            TYPE
     C                   MOVE      A8CMCD        BKCODE
     C                   MOVE      BJSLCD        GRCODE
     C                   MOVE      'FECCD'       EXNAME
     C                   MOVE      *DATE         SYSDAT
      *
     C                   Z-ADD     MLACD         $$DAY
     C                   EXSR      GLM053
     C                   MOVE      $$DATE        LASTAC
      *
     C                   MOVE      MMDAT         LASTWR
      *
     C                   Z-ADD     BJDNWD        $$DAY
     C                   EXSR      GLM053
     C                   MOVE      $$DATE        NEXTWR
      *
     C                   MOVE      R00000        DATA
     C                   ADD       1             RRN
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *
      *
      *****************************************************************
      *                                                               *
      *  S99000 -  Writing Footer Record                              *
      *                                                               *
      *  Called By: Main line                                         *
      *                                                               *
      *****************************************************************
      *
     C     S99000        BEGSR
      *
     C                   RESET                   CCDR
     C                   RESET                   R99000
      *
     C                   Z-ADD     99            TYPE
     C     RRN           ADD       1             NUMREC
      *
     C                   MOVE      R99000        DATA
     C                   WRITE     CCDR
      *
     C                   ENDSR
      *
      *
      *
      *****************************************************************
      *                                                               *
      ***GLM053*-*Calling*Routine*GLM053*for*date*conversion***********                       LUC109
      *  GLM053 - Calling Routine XX000053 for date conversion        *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     GLM053        BEGSR
      *
     C                   CLEAR                   $$DATE
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    $$DAY             5 0
     C                   PARM                    $$DATE            8 0
      *
     C                   ENDSR
      *
      *
      *
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C                   OPEN      SDBANKPD                             LR
     C  NLR              READ      SDBANKD0                             LRLR
     C  NLR              CLOSE     SDBANKPD                             LR
      *
     C  NLR              OPEN      SDINTFV0                             LR
     C  NLR              READ      SDINTFV0                             LRLR
     C  NLR              CLOSE     SDINTFV0                             LR
      *
     C  NLRS9BRCH        CHAIN     SDBRCHD0                           LRLR
      *
     C  NLR              OPEN      SDGELRPP                             LR
     C  NLR              READ      SDGELRPP                             LRLR
     C  NLR              CLOSE     SDGELRPP                             LR
      *
     C     *LIKE         DEFINE    NUMREC        RRN
     C                   CLEAR                   RRN
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #RECO  -  Maintain Account Balances for Reconciliation       *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #RECO         BEGSR
     C*
     C                   MOVEL     C0301         WKSIGN            1
     C                   MOVE      C0301         WKACBL           18
     C* Account Balance Blanks
     C     WKACBL        IFEQ      *BLANKS
     C                   Z-ADD     *ZERO         @@ACBL           18 3
     C                   ELSE
     C                   MOVE      WKACBL        @@ACB1
     C                   Z-ADD     @@ACB2        @@ACBL
     C                   ENDIF
     C*
     C* Account Balance not zero
     C     @@ACBL        IFNE      *ZERO
      * Access currency to determine no. of decimal places
     C     WKACCY        CHAIN     SDCURRL0                           98
      *
     C     A6NBDP        IFEQ      1
     C                   MULT      10            @@ACBL
     C                   ENDIF
      *
     C     A6NBDP        IFEQ      2
     C                   MULT      100           @@ACBL
     C                   ENDIF
      *
     C     A6NBDP        IFEQ      3
     C                   MULT      1000          @@ACBL
     C                   ENDIF
      *
     C                   ENDIF
     C*
     C* Account Balance Negative - remember signs have been reversed.
     C     WKSIGN        IFEQ      '+'
     C                   Z-SUB     @@ACBL        @@ACBL
     C                   ENDIF
      *
      * Write Account Balance Detail Information
      *
     C                   MOVE      'D'           DRECID
     C                   MOVEL     WKACNM        DC9151
     C                   MOVEL     C9150         DC9150
     C                   Z-ADD     @@ACBL        DC0301
      *
     C                   WRITE     GLRECOPF
      *
      * Access Account Balance Total Information
      *
     C     WKACNM        CHAIN     RECTOT                             30
      *
      * Write Account Balance Total Information
     C     *IN30         IFEQ      *ON
     C                   MOVE      'T'           DRECID
     C                   MOVEL     WKACNM        DC9151
     C                   MOVE      *BLANKS       DC9150
     C                   Z-ADD     @@ACBL        DC0301
      *
     C                   WRITE     GLRECOPF
      *
     C                   ELSE
      *
      * Update Account Balance Total Information
     C                   ADD       @@ACBL        TC0301
      *
     C                   UPDATE    RECTOT
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  Subroutine  :  Dummy                                         *
      *                                                               *
      *  Function    : Dummy read of GLRECOPP for compile purposes    *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     DUMMY         BEGSR
      *
     C                   READ      GLRECOPP                               60
      *
     C                   ENDSR
      *
      *****************************************************************
