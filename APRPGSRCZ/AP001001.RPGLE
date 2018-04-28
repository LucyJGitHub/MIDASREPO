     H DEBUG
     F*****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AP Initialisation program for CAP201')
      *****************************************************************
      *                                                               *
      *  Midas - API                                                  *
      *                                                               *
      *  AP001001 - Midas AP Initialisation program for CAP201        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BUG27041*CREATE    Date 03Mar10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27041 - Incorrect mapping for MQ STCQ                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas ZA Transaction log file
     FZATRNLOGL1UF   E           K DISK    INFSR(*PSSR)
 
      ** Midas ZA Transaction errors file
     FZATRNERRL1UF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Main Processing
      *
      ** Update ZATRNLOGPD
     C
      *
     C     *LOVAL        SETLL     ZATRNLOGL1
     C                   READ      ZATRNLOGL1
     C                   DOW       NOT %EOF(ZATRNLOGL1)
      *
     C                   IF        AAMIDTRNID <> *BLANKS
     C                   EVAL      AAMIDTRID2 = AAMIDTRNID
      *
     C                   UPDATE    ZATRNLOGD0
     C                   ENDIF
      *
     C                   READ      ZATRNLOGL1
     C                   ENDDO
      *
      ** Update ZATRNERRPD
     C
      *
     C     *LOVAL        SETLL     ZATRNERRL1
     C                   READ      ZATRNERRL1
     C                   DOW       NOT %EOF(ZATRNERRL1)
      *
     C                   IF        ABMIDTRNID <> *BLANKS
     C                   EVAL      ABMIDTRID2 = ABMIDTRNID
      *
     C                   UPDATE    ZATRNERRD0
     C                   ENDIF
      *
     C                   READ      ZATRNERRL1
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
      *
     C
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
      *
     C                   MOVE      'Y'           @RUN              1
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2010
