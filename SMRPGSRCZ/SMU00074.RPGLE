     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Program for fix 122060')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00074 - Upgrade program for fix 122060                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 122060  *CREATE    Date 29Feb00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S12206001.                         *
      *                                                               *
      *****************************************************************
     F*
     FSDBAICL0  UF   E           K DISK
     F** BAI Configuration file
     F*
     FSDBAIIPD  UF   E             DISK
     F** BAI Installation Control Data
     F*
     F*****************************************************************
     D/EJECT
     D*****************************************************************
     D WQUOTE          S             50    DIM(1) CTDATA PERRCD(1)
     C/EJECT
     C*****************************************************************
     C*
     C** Update BAI Configuration file.
     C*
     C     WPGM          KLIST
     C                   KFLD                    WPGM1            10
     C                   KFLD                    WPGM2             3
     C*
     C                   MOVEL     'RE4144'      WPGM1
     C                   MOVE      'DRI'         WPGM2
     C*
     C     *LOVAL        SETLL     SDBAICL0
     C     WPGM          CHAIN     SDBAICL0                           70
     C     *IN70         DOWEQ     '0'
     C                   MOVE      *BLANKS       CFPGPM
     C                   MOVEA     WQUOTE        CFPGPM
     C                   UPDATE    @BAICL0
     C     WPGM          READE     SDBAICL0                               70
     C                   ENDDO
     C*
     C** Update BAI Installation Control Data.
     C*
     C     1             SETLL     SDBAIIPD
     C                   READ      SDBAIIPD                               70
     C     *IN70         IFEQ      '0'
     C                   MOVE      *BLANKS       FUDISP
     C                   MOVEL     'CASH_REC'    FUDISP
     C                   UPDATE    SDBAIID0
     C                   ENDIF
     C*
     C** Exit from program.
     C*
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C*
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      * Check to see that *PSSR has not already been called.
     C     *INLR         IFNE      *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  WQUOTE
'   '
