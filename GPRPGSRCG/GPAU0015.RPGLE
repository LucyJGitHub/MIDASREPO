     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Action Selection - 1')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAU0015 - Action Selection - 1                              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. AR1058381          Date 11May23               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1058381 - Audit file maintenance crashes on webfaced       *
      *              screen. Convert hardcoded column header & footer *
      *              functions in DSPF into variables. Recompiled due *
      *              to changes in GPAU0015DF. (Child: AR1058383)     *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGPAU0015DFCF   E             WORKSTN
 
     D NARR1           C                   'CK/3=Exit,'                                    AR1058381
     D NARR2           C                   'CK/12=Abandon'                                 AR1058381
                                                                                           AR1058381
     D PSDS           SDS
     D  ERROR            *STATUS
     D  WKSID                244    253
     D  USRID                254    263
 
 
     C* INITIAL PROCESSING
 
     C                   EXSR      INIT
 
     C* DISPLAY THE SCREEN
 
     C                   Z-ADD     99            ER                2 0
     C     ER            DOWNE     *ZERO
     C                   EXSR      DSPLAY
     C                   END
 
     C                   SETON                                        LR
 
      /SPACE 5
      *****************************************************************
      * Display screen
      *****************************************************************
     C     DSPLAY        BEGSR
     C                   MOVE      NARR1         FOOTER1                                   AR1058381
     C                   MOVE      NARR2         FOOTER2                                   AR1058381
     C**********         WRITE     MESSAG                                                  AR1058381
     C                   WRITE     MAIN
     C                   WRITE     MESSAG                                                  AR1058381
     C                   READ      MAIN                                   99    *
     C                   MOVEL     *BLANK        DDERR            76
     C* CK/3
     C     *INKC         IFEQ      '1'
     C                   MOVEL     'EXIT  '      RETC
     C                   Z-ADD     *ZERO         ER
     C                   ELSE
     C* CK/12
     C     *INKL         IFEQ      '1'
     C                   MOVEL     'ABAND '      RETC
     C                   Z-ADD     *ZERO         ER
     C                   ELSE
     C* ENTER
     C                   EXSR      VALDSP
     C                   END
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Validate display
      *****************************************************************
     C     VALDSP        BEGSR
 
      * Approve
 
     C     SSAPR         IFNE      *BLANK
     C                   MOVEL     'APPROVE   '  AFACTN
     C                   EXSR      CALL_SELECT
     C                   ENDIF
 
      * Authorize
 
     C     SSAUT         IFNE      *BLANK
     C     ER            ANDNE     0
     C                   MOVEL     'AUTHORIZE '  AFACTN
     C                   EXSR      CALL_SELECT
     C                   ENDIF
 
      * Delete
 
     C     SSDEL         IFNE      *BLANK
     C     ER            ANDNE     0
     C                   MOVEL     'DELETE    '  AFACTN
     C                   EXSR      CALL_SELECT
     C                   ENDIF
 
      * FINISH
 
     C                   Z-ADD     *ZERO         ER
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Call selection
      *****************************************************************
     C     CALL_SELECT   BEGSR
     C                   CALL      'GPAU0016'                           9999    *
     C                   PARM      *BLANK        RETC
     C                   PARM                    AFFILE
     C                   PARM                    AFRCID
     C                   PARM                    AFDESC
     C                   PARM                    AFACTN           10
     C                   EXSR      CHKERR
 
     C* IF CK/3 TAKEN AT A LOWER LEVEL, THEN FINISH
 
     C     RETC          IFEQ      'EXIT'
     C                   Z-ADD     *ZERO         ER
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Initial processing
      *****************************************************************
     C     INIT          BEGSR
 
     C*  PARAMETERS PASSED
 
     C     *ENTRY        PLIST
     C                   PARM                    RETC              6
     C                   PARM                    AFFILE
     C                   PARM                    AFRCID
     C                   PARM                    AFDESC
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Check for error
      *****************************************************************
     C     CHKERR        BEGSR
 
     C* ERROR ON CALL OF PROGRAM
 
     C     *IN99         IFEQ      '1'
     C     ERROR         ANDNE     1
     C                   EXSR      *PSSR
     C                   END
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * *PSSR processing
      *****************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   MOVEL     '*CANCL'      RETURN            6
     C                   ENDSR     RETURN
      **********************************************************************
