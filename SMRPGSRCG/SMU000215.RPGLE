     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM API Configuration Initialisation')            *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU000215 - Midas SM API Configuration Initialisation        *
      *                                                               *
      *  Function:  This program will initialise the new field        *
      *             APRDEL to 'Y'.                                    *
      *                                                               *
      *  Called By: SMUC000215 - Midas SM API Configuration           *
      *                          Initialisation Control               *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR808720           Date 03Aug11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204  *CREATE    Date 15Mar10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR808720 - Program should not have commitment control.       *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR    - Error processing                                   *
      *                                                               *
      *****************************************************************
 
     F*APICFGL0*UF   E           K DISK    INFSR(*PSSR) COMMIT                              AR808720
     FAPICFGL0  UF   E           K DISK    INFSR(*PSSR)                                     AR808720
      ** Midas AP API Configuration
 
      *****************************************************************
      /EJECT
      *****************************************************************
     D*LDA******     E DS           256    EXTNAME(LDA)                                     AR808720
      **********                                                                            AR808720
      ***Local*data*area*for*database*error*details**************                           AR808720
      ****LOCK*IN*LDA*immediately*before*and*OUT*LDA*immediately*                           AR808720
      ***after each database error handling.*********************                           AR808720
      **********                            134 141 DBFILE                                  AR808720
      *********Defines:                     142 170 DBKEY                                   AR808720
      **********                            171 180 DBPGM                                   AR808720
      **********                            181 1830DBASE                                   AR808720
      **********                                                                            AR808720
      ***The*following*/COPY*line*includes*all*the defined*fields*in*the*                   AR808720
      ***PSDS.**They*have*meaningful*names,*prefixed*by*'PS'.************                   AR808720
      **********                                                                            AR808720
     D*/COPY*GPCPYSRCG,PSDS                                                                 AR808720
      ***Program*Status*Data*Structure*                                                     AR808720
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      *********************************************************************
      /EJECT
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C     *LOVAL        SETLL     APICFGL0
     C                   READ      APICFGL0
     C                   DOW       NOT %EOF( APICFGL0 )
 
     C                   IF        APRDEL = *BLANKS
     C                   EVAL      APRDEL = 'Y'
     C                   UPDATE    T_APICFG
     C                   ENDIF
 
     C                   READ      APICFGL0
     C                   ENDDO
 
     C**********         COMMIT                                                             AR808720
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
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
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
