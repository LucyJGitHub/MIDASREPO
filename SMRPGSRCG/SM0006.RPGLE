     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*XBI *  OVRDBF FILE(UPTLIBOF) TOFILE(QADSPOBJ)                       *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Remove records from UPNOTFPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM0006 - Remove records from UPNOTFPD                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CUP016 *CREATE     Date 01Apr03               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *  CUP016 - Add implementation software to core.                *
      *                                                               *
      *****************************************************************
      *
      * +--------------------------------------+
      * ¦ F-specs                              ¦
      * ¦ =======                              ¦
      * +--------------------------------------+
      *
     FUPTLIBOF  IF   E             DISK
     FUPNOTFPD  UF   E           K DISK    RENAME(QLIDOBJD:OBJD)
      *
     D Recursive       S              1
      * +--- Start of Main processing -----------------------------------+
      * ¦                                                                ¦
      * +----------------------------------------------------------------+
      *
     C     ObjectAndType KLIST
     C                   KFLD                    Object           10
     C                   KFLD                    Type              8
      *
     C                   EVAL      Recursive = 'N'
      *
     C     1             SETLL     UPTLIBOF
     C                   READ      UPTLIBOF                               20
      *
     C                   DOW       *IN20 = *OFF
      *
      * Chain to see if equivalent record on "from" file.
     C                   EVAL      Object = ODOBNM
     C                   EVAL      Type = ODOBTP
     C     ObjectAndType CHAIN     UPNOTFPD                           10
     C     *IN10         IFEQ      *OFF
     C                   DELETE    OBJD
     C                   ELSE
     C                   SETOFF                                       10
     C                   ENDIF
      *
     C                   READ      UPTLIBOF                               20
      *
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = 'N'
     C                   EVAL      Recursive = 'Y'
     C                   SETON                                        U7U8
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
