     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Initialise field MDDIV1 from MDDIVU')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00096 - Initialise field MDDIV1 from MDDIVU.              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 190204 *C *CREATE  Date 26Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S190204R01.                        *
      *  190204  - This program will change the Dividend per Unit     *
      *            field (MDDIVU) in PF/SECODVPD from 9,0N to         *
      *            (MDDIV1) 13,8N.                                    *
      *                                                               *
      *****************************************************************
     FSECODVPD  UF   E           K DISK
      *
      ** Midas CO Dividend Events
      *
     C     *IN99         DOWEQ     '0'
      *
     C                   READ      SECODVPD                               99
      *
     C     *IN99         IFNE      '1'
     C                   Z-ADD     MDDIVU        MDDIV1
     C                   UPDATE    SECODVD0
     C                   END
      *
     C                   END
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *
      *  *PSSR - Subroutine to handle error conditions
      *
      *  Called from:  After abnormal operation occurs
      *
      *  Calls: Nothing
      *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
      *
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
