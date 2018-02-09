     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Access object for DSPFD *ACCPTH')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UTAOACCP - Access object for DSPFD *ACCPTH                   *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27790 *CREATE   Date 21Jun10               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27790 - New utility                                       *
      *                                                               *
      *****************************************************************
     FUPACCPTPD IF   E           K DISK    INFSR(*PSSR)
     F
      *
     D PFile           S             10
     D PPFile          S             10
     D PFmt            S             10
     D PKeyField       S             10
     D PKeyFieldNo     S              3  0
     D PMode           S              7
     D PReturn         S              7
     D PFieldData      S            200
     D KFile           S             10
     D KPFile          S             10
     D KFmt            S             10
     D KKeyField       S             10
     D KKeyFieldNo     S              3  0
     D Recursive       S              1
     D RcdCount        S              2  0 INZ(1)
     D StrPos          S              3  0 INZ(1)
      *
     D ACCP          E DS                  EXTNAME(UPACCPTPD)
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFile
     C                   PARM                    PPFile
     C                   PARM                    PFmt
     C                   PARM                    PKeyField
     C                   PARM                    PKeyFieldNo
     C                   PARM                    PMode
     C                   PARM                    PReturn
     C                   PARM                    PFieldData
      *
     C     KFullKey      KLIST
     C                   KFLD                    KFile
     C                   KFLD                    KPFile
     C                   KFLD                    KFmt
     C                   KFLD                    KKeyField
     C                   KFLD                    KKeyFieldNo
      *
     C     KKeyCheck     KLIST
     C                   KFLD                    KFile
      *
     C     KKeyFld       KLIST
     C                   KFLD                    KFile
      *
     C                   EVAL      PReturn = *blanks
     C                   EVAL      PFieldData = *blanks
      *
     C                   IF        PMode = '*KEYCHK'
     C                   EVAL      KFile       = PFile
     C                   EVAL      KPFile      = PPFile
     C                   EVAL      KFmt        = PFmt
     C     *LOVAL        SETLL     UPACCPTPD
     C     KKeyCheck     CHAIN     UPACCPTPD
     C                   IF        NOT(%FOUND) or
     C                             APACCP <> 'K'
     C                   EVAL      PReturn = '*NRF'
     C                   ELSE
     C                   EVAL      PFieldData = ACCP
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PMode = '*KEYFLD'
     C                   EVAL      KFile       = PFile
     C     *LOVAL        SETLL     UPACCPTPD
     C     KKeyFld       CHAIN     UPACCPTPD
     C                   IF        NOT(%FOUND) or
     C                             APACCP <> 'K'
     C                   EVAL      PReturn = '*NRF'
     C                   ELSE
     C                   DOU       %EOF or
     C                             RcdCount > APNKYF
     C                   EVAL      %SUBST(PFieldData:StrPos:10) = APKEYF
     C                   EVAL      RcdCount = RcdCount + 1
     C                   EVAL      StrPos = StrPos + 10
     C                   READ      UPACCPTPD
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PMode = '*RTV'
     C                   EVAL      KFile       = PFile
     C                   EVAL      KPFile      = PPFile
     C                   EVAL      KFmt        = PFmt
     C                   EVAL      KKeyField   = PKeyField
     C                   EVAL      KKeyFieldNo = PKeyFieldNo
     C     KFullKey      CHAIN     UPACCPTPD
     C                   IF        %FOUND
     C                   EVAL      PFieldData = ACCP
     C                   ELSE
     C                   EVAL      PReturn = '*NRF'
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   SETON                                        U7U8LR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   EVAL      PReturn = '*ERROR'
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
