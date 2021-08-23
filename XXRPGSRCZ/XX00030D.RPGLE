     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('FERAT File Formatting')                                *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM030D*-*FERAT*File*Formatting*******************************                       LUC109
      *  XX00030D - FERAT File Formatting                             *                       LUC109
      *                                                               *                       LUC109
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
      *  Prev Amend NO. MMI043             Date 11Dec98               *
      *                 nnnnnn             Date ddMmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MMI043 - Balance Sheet Extract                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *****************************************************************
      *
     FSDBANKPD  IF   E             DISK    USROPN
     FSDINTFV0  IF   E             DISK    USROPN
     FSDGELRPP  IF   E           K DISK    USROPN
     FSDBRCHV0  IF   E           K DISK
     FFERATDV1  IF   E           K DISK
     FRAT       O    E             DISK
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   01 - LF/FERATDV1   File I                                   *
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
      *  SFERAT - Processing each Extraction Record for Branch        *
      *  S00000 - Writing Branch Initial Record                       *
      *  S02000 - Writing Header Record                               *
      *  S05001/S05016 - Writing Details Records                      *
      *  S09000 - Writing Branch Final Record                         *
      *  S99000 - Writing Footer Record                               *
      ***GLM053*-*Calling*Routine*GLM053*for*date*conversion***********                       LUC109
      *  GLM053 - Calling Routine XX000053 for date conversion        *                       LUC109
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
      *
      *
      ** External Data Structure for RAT file
      *
     D R00000        E DS
     D R02000        E DS
     D T05001        E DS
     D T05002        E DS
     D R99000        E DS
      *
      *
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
      *  Calls: S02000 - SFERAT - S09000                              *
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
     C                   EXSR      SFERAT
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
      *  SFERAT -  Reading and processing each record extraction      *
      *            for the considered Branch                          *
      *                                                               *
      *  Called By: SBRCH                                             *
      *  Calls: from S05001 to S05002                                 *
      *                                                               *
      *****************************************************************
      *
     C     SFERAT        BEGSR
      *
     C     A8BRCD        SETLL     FERATDP0
     C     A8BRCD        READE     FERATDP0                               01
      *
     C     *IN01         DOWEQ     *OFF
     C                   EXSR      S05001
     C                   EXSR      S05002
      *
     C     A8BRCD        READE     FERATDP0                               01
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
     C                   RESET                   RATR
     C                   RESET                   R02000
      *
     C                   Z-ADD     02            TYPE
     C                   MOVE      A8BRCD        BRCODE
      *
     C                   MOVE      R02000        DATA
     C                   ADD       1             RRN
     C                   WRITE     RATR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05001 -  Writing Detail Record - Progressive 001            *
      *                                                               *
      *  Called By: SFERAT                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05001        BEGSR
      *
     C                   RESET                   RATR
      *
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     001           P05001
      *
     C                   MOVE      T05001        DATA
     C                   ADD       1             RRN
     C                   WRITE     RATR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S05002 -  Writing Detail Record - Progressive 002            *
      *                                                               *
      *  Called By: SFERAT                                            *
      *                                                               *
      *****************************************************************
      *
     C     S05002        BEGSR
      *
     C                   RESET                   RATR
      *
     C                   Z-ADD     05            TYPE
     C                   Z-ADD     002           P05002
      *
     C                   MOVE      T05002        DATA
     C                   ADD       1             RRN
     C                   WRITE     RATR
      *
     C                   ENDSR
      *
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
     C                   RESET                   RATR
      *
     C                   Z-ADD     09            TYPE
      *
     C                   ADD       1             RRN
     C                   WRITE     RATR
      *
     C                   ENDSR
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
     C                   RESET                   RATR
     C                   RESET                   R00000
      *
     C                   Z-ADD     00            TYPE
     C                   MOVE      A8CMCD        BKCODE
     C                   MOVE      BJSLCD        GRCODE
     C                   MOVE      'FERAT'       EXNAME
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
     C                   WRITE     RATR
      *
     C                   ENDSR
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
     C                   RESET                   RATR
     C                   RESET                   R99000
      *
     C                   Z-ADD     99            TYPE
     C     RRN           ADD       1             NUMREC
      *
     C                   MOVE      R99000        DATA
     C                   WRITE     RATR
      *
     C                   ENDSR
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
