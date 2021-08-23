     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('COMPACT FEPRI EXTRACT')                                *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM049**-*COMPACT*FEPRI*EXTRACT*******************************                       LUC109
      *  XX000049 - COMPACT FEPRI EXTRACT                             *                       LUC109
      *                                                               *
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: to read the work file WKFEPRI, containing          *
      *            principal changes, and output the extract file     *
      *            FEPRI in final format.                             *
      *                                                               *
      ***CALLED*BY**GLCM048*-*GL*INT/PRI/TAS*Extract*******************                       LUC109
      *  CALLED BY GLC000048 - GL INT/PRI/TAS Extract                 *                       LUC109
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*Misys*2004**************************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend No. 230946   *Create   Date 01Dec04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  230946 - Reduce principal amounts on FEPRI by parts sold.    *
      *                                                               *
      *****************************************************************
      *
     FWKFEPRI   IF   E           K DISK
     FSDBANKPD  IF   E             DISK
     FSDINTFV0  IF   E             DISK
     FSDGELRPP  IF   E             DISK
     FSDBRCHV0  IF   E           K DISK
     FFEPRI     O    E             DISK
      *
      ** Header Record
      *
     D R00000        E DS
      *
      ** Detail Record - FEPRI
      *
     D DETPRI          DS
     D  F2PROG                 1      3  0
     D  F2COMP                 4      6
     D  F2BRCD                 7      9
     D  PVMODL                10     12
     D  PVDLNO                13     27
     D  PVFILE                28     32
     D  PVRPFR                33     33
     D  OUEDAT                34     41
     D  OUEAMT                42     60
     D  PVOUTH                61     61
     D  PVFILL                62     78
      *
      **********************************************************************
      *
      * M A I N   L I N E
      *
      **********************************************************************
      *
     C     *INLR         IFNE      *ON
      *
      * Write header records
      *
     C                   EXSR      S00000
      *
      * Process all branches
      *
     C                   EXSR      SBRCH
      *
      * Write footer records
      *
     C                   EXSR      S99000
      *
     C                   ENDIF
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  SBRCH  -  Process all branches                               *
      *                                                               *
      *  Called By: Main line                                         *
      *  Calls: S02000                                                *
      *         OUTPRI                                                *
      *         S09000                                                *
      *                                                               *
      *****************************************************************
      *
     C     SBRCH         BEGSR
      *
     C     *LOVAL        SETLL     SDBRCHD0
     C                   READ      SDBRCHD0                               01
      *
     C     *IN01         DOWEQ     *OFF
      *
      * Branch Initial Records
      *
     C                   EXSR      S02000
      *
      * Process work file
      *
     C     A8BRCD        SETLL     WKFEPRIF
     C     A8BRCD        READE     WKFEPRIF                               02
      *
      * Initial record
      *
     C     *IN02         IFEQ      *OFF
     C                   MOVE      F2MODL        PVMODL
     C                   MOVE      F2DLNO        PVDLNO
     C                   MOVE      F2FILE        PVFILE
     C                   MOVE      F2RPFR        PVRPFR
     C                   Z-ADD     HEDAT         $$DAY
     C                   Z-ADD     *ZERO         $$AMNT
     C                   MOVE      F2OUTH        PVOUTH
     C                   MOVE      F2FILL        PVFILL
     C                   MOVE      F2CCY         $$CCY
     C                   MOVE      'Y'           DETREC            1
     C                   ELSE
     C                   MOVE      'N'           DETREC
     C                   ENDIF
      *
     C     *IN02         DOWEQ     *OFF
      *
      * Output a record to the extract file for each deal and date.
      *
     C     F2DLNO        IFNE      PVDLNO
     C     F2OUTH        ORNE      PVOUTH
     C     HEDAT         ORNE      $$DAY
     C                   EXSR      OUTPRI
     C     F2DLNO        IFNE      PVDLNO
     C     F2OUTH        ORNE      PVOUTH
     C                   Z-ADD     *ZERO         $$AMNT
     C                   ENDIF
     C                   MOVE      F2MODL        PVMODL
     C                   MOVE      F2DLNO        PVDLNO
     C                   MOVE      F2FILE        PVFILE
     C                   MOVE      F2RPFR        PVRPFR
     C                   Z-ADD     HEDAT         $$DAY
     C                   MOVE      F2OUTH        PVOUTH
     C                   MOVE      F2FILL        PVFILL
     C                   MOVE      F2CCY         $$CCY
     C                   ENDIF
      *
      * Increase running principal total
      *
     C                   ADD       HEAMT         $$AMNT
      *
     C     A8BRCD        READE     WKFEPRIF                               02
     C                   ENDDO
      *
      * Output data for last detail record
      *
     C     DETREC        IFEQ      'Y'
     C                   EXSR      OUTPRI
     C                   ENDIF
      *
      * Branch Final Records
      *
     C                   EXSR      S09000
      *
     C                   READ      SDBRCHD0                               01
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  OUTPRI -  Write a record to Principal Changes extract file   *
      *                                                               *
      *  Called By: SBRCH                                             *
      *                                                               *
      *****************************************************************
      *
     C     OUTPRI        BEGSR
      *
     C                   EXSR      GLM053
     C                   MOVE      $$DATE        OUEDAT
      *
     C                   EXSR      GLM041
     C                   MOVE      $$CAMT        OUEAMT
      *
     C                   MOVE      '05'          RECC
     C                   MOVE      DETPRI        DATA
     C                   ADD       1             RRNPRI
      *
     C                   WRITE     FEPRIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  S00000 -  Write Header Record                                *
      *                                                               *
      *  Called By: Main line                                         *
      *  Calls: GLM053                                                *
      *                                                               *
      *****************************************************************
      *
     C     S00000        BEGSR
      *
     C                   MOVE      '00'          RECC
     C                   MOVE      A8CMCD        BKCODE
     C                   MOVE      BJSLCD        GRCODE
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
     C                   MOVE      'FEPRI'       EXNAME
     C                   MOVE      R00000        DATA
     C                   WRITE     FEPRIF
     C                   ADD       1             RRNPRI
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  S02000 -  Write Branch Header Record                         *
      *                                                               *
      *  Called By: SBRCH                                             *
      *                                                               *
      *****************************************************************
      *
     C     S02000        BEGSR
      *
     C                   MOVE      '02'          RECC
     C                   MOVEL(P)  A8BRCD        DATA
      *
     C                   WRITE     FEPRIF
     C                   ADD       1             RRNPRI            6 0
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  S09000 -  Write Branch Final Record                          *
      *                                                               *
      *  Called By: SBRCH                                             *
      *                                                               *
      *****************************************************************
      *
     C     S09000        BEGSR
      *
     C                   MOVE      '09'          RECC
     C                   MOVE      *BLANKS       DATA
      *
     C                   WRITE     FEPRIF
     C                   ADD       1             RRNPRI
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  S99000 -  Write Footer Record                                *
      *                                                               *
      *  Called By: Main line                                         *
      *                                                               *
      *****************************************************************
      *
     C     S99000        BEGSR
      *
     C                   MOVE      '99'          RECC
      *
     C                   ADD       1             RRNPRI
     C                   MOVEL(P)  RRNPRI        DATA
     C                   WRITE     FEPRIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      ***GLM041*-*Calling*Routine*GLM041*for*AM*data*type*conversion***                       LUC109
      *  GLM041 - Calling Routine XX000041 for AM data type conversion*                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     GLM041        BEGSR
      *
     C                   CLEAR                   $$CAMT
      *
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    $$CCY             3            Currency code
     C                   PARM                    $$AMNT           15 0          Amount
     C                   PARM                    $$CAMT           19            Converted amnt
     C                   PARM                    $$EROR            1            Error indicator
      *
     C                   ENDSR
      *
      /EJECT
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
      /EJECT
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
     C     1             CHAIN     SDBANKD0                           LR                       22861
      *
     C                   READ      SDINTFV0                               LR
      *
     C     S9BRCH        CHAIN     SDBRCHD0                           LR
      *
     C                   READ      SDGELRPP                               LR
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *
     C                   ENDSR
      *
