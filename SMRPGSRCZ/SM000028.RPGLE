     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update status on SMDLVCPD')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000028 - Update status on SMDLVCPD                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CUP023  *CREATE    Date 23Mar11               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP023 - Conversion of SMDLVCPD to single member.            *
      *                                                               *
      *****************************************************************
      *
     FSMDLVCL0  UF   E           K DISK
      *
     D RlsLvl          S             10
     D UpgPgm          S             10
     D MbrType         S             10
     D KRlsLvl         S             10
     D KUpgPgm         S             10
     D KMbrType        S             10
     D Recursive       S              1    INZ('N')
      *
     C     *ENTRY        PLIST
     C                   PARM                    RlsLvl           10
     C                   PARM                    UpgPgm           10
     C                   PARM                    MbrType          10
     C                   PARM                    Status            1
      *
     C                   EVAL      Recursive = 'N'
      *
     C     UpgPgmRec     KLIST
     C                   KFLD                    KRlsLvl
     C                   KFLD                    KUpgPgm
     C                   KFLD                    KMbrType
      *
     C                   EVAL      KRlsLvl = RlsLvl
     C                   EVAL      KUpgPgm = UpgPgm
     C                   EVAL      KMbrType = MbrType
      *
     C     UpgPgmRec     CHAIN     SMDLVCL0
     C                   IF        %FOUND
     C                   EVAL      AUUSTS = Status
     C                   UPDATE    @DLVCL0
     C                   ELSE
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   ENDIF
      *
     C     ENDPGM        TAG
     C                   EVAL      *INLR = *ON
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
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
