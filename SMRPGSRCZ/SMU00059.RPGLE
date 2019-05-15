     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Initialise BBTICS and BBSWFI fields to N')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00059 - Initialise BBTICS for TI Interface.               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 CTI001 *C *CREATE  Date 29Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CTI00101.                          *
      *  CTI001  - Midas-Trade Innovation Interface:                  *
      *           - Initialisation of TI Customer field.              *
      *                                                               *
      *****************************************************************
     FSDCUSTPD  UF   E             DISK
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFX               2
     C                   PARM                    SRC              10
     C                   PARM                    LIB              10
      *
     C                   READ      SDCUSTPD                               90
     C     *IN90         DOWEQ     '0'
      * If Trade Innovation Customer flag is blank then initialise
      * the field to 'N'.
     C     BBTICS        IFEQ      ' '
     C                   MOVE      'N'           BBTICS
     C                   ENDIF
      * If SWIFT Financial Institution flag is blank then initialise
      * the field to 'N'.
     C     BBSWFI        IFEQ      ' '
     C                   MOVE      BBBNBI        BBSWFI
     C                   ENDIF
     C                   UPDATE    SDCUSTD0
     C                   READ      SDCUSTPD                               90
     C                   END
      *
     C                   SETON                                        LR
     C                   RETURN
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
