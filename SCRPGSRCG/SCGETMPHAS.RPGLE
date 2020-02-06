     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC Get Midas System Status')                     *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCGETMPHAS - Get Midas System Status                         *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. MD051743  *CREATE  Date 22Aug18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD051743 - Installation error UPC000148 encountered during   *
      *             GINZ (Global Initialization)                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FGPDWNLL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GP Downloaded data from zones

     FGPZONEL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GO Zone

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      **
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D MPHASVAL        S              1A

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    MPHASVAL

     C     ZONEKEY       KLIST
     C                   KFLD                    ZOMSYS
     C                   KFLD                    KEYDESC          20

     C                   EVAL      MPHASVAL = *BLANK
     C                   EVAL      KEYDESC  = 'MidasPhaseOfDay'

      ** Get Zone

     C                   CALL      'GOGETZONE'
     C                   PARM      *BLANKS       I#RTCD            7
     C                   PARM      *BLANKS       I#ERMS           50
      * INPUTS
     C                   PARM      'N'           I#FULLCHECK       1
      * OUTPUTS
     C                   PARM                    O#ZONE           10
     C                   PARM                    O#SHTC            4
     C                   PARM                    O#RDNB            5 0
     C                   PARM                    O#DNWD            5 0
     C                   PARM                    O#BCCY            3
     C                   PARM                    O#NJOB            1 0

      * Error detected  (*PSSR will end the program)

     C     I#RTCD        IFEQ      '*ERROR'
     C                   EXSR      *PSSR
     C                   END

      ** Get Main System and Midas Phase of Day

     C     O#ZONE        CHAIN     GPZONEL0                           99
     C                   IF        *IN99 = *OFF

     C     ZONEKEY       CHAIN     GPDWNLL0                           98
     C                   IF        *IN98 = *OFF
     C                   EVAL      MPHASVAL = DLVAL
     C                   ENDIF

     C                   ENDIF

      ** End Program and Return to Caller

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   DUMP

     C                   CALL      'DBERRCTL'

     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2018
