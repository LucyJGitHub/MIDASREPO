     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas XX Build XXCUSTPP from IOCUSTPP')                *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  XX1419 - Build XXCUSTPPD using IOCUSTPP                      *
      *            IOCUST is 6,0 in MP and 6A in FM2021               *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. EML114  *CREATE    Date 23Sep21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML114 - Upgrade TFJ004 to FM2.1                             *
      *  TFJ004 - Inter-office Reconcile                              *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FIOCUSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(MP_)
      ** I/O Reconcile - I/O Customer Table at MP
      *
     FXXCUSTL1  UF A E           K DISK    INFSR(*PSSR)
      ** I/O Reconcile - I/O Customer Table at FM2021
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Program Parameters
     D PRtCd           S              7A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------- Start of Main Processing -------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Read IOCUSTPP file.
      *
     C     *LOVAL        SETLL     IOCUSTL1
      *
     C     *IN01         DOWEQ     *OFF
      *
     C                   READ      IOCUSTL1                               01
      *
     C     *IN01         IFEQ      *OFF
      *
      *  Move fields to XXCUSTPP
      *
     C                   MOVEL     MP_RECI       RECI
     C                   MOVEL     MP_IOCUST     IOCUST
     C                   MOVEL     MP_HCNUM2     HCNUM2
     C                   MOVEL     MP_CHTP       CHTP
     C                   Z-ADD     MP_LCD        LCD
      *
      *  Write the record.
      *
     C                   WRITE     XXCUSTP0
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRtCd
      *
     C                   EVAL      PRtCd = '       '
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   EVAL      PRtCd = '*ERROR '
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
