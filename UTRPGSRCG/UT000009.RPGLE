     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*XBIA*  OVRDBF FILE(CFKD1) TOFILE(UTCFKDPD)                          *
/*XBIB*  OVRDBF FILE(CFKD2) TOFILE(UTCFKDPD)                          *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Compare database files')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000009 - Compare database files                            *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27790 *CREATE   Date 23Jun10               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27790 - New utility                                       *
      *                                                               *
      *****************************************************************
     FCFKD1     IP   E           K DISK          RENAME(UTCFKDD0:CFKD1F)
     FCFKD2     IS   E           K DISK          RENAME(UTCFKDD0:CFKD2F)
     FInpFile1  IF   F 4000        DISK
     FInpFile2  IF   F 4000        DISK
     FUTFLDDPD  IF   E           K DISK
     FUTCMPFPD  IF A E             DISK
      *
     D PFile1          S             10
     D PFile2          S             10
     D PTFile          S             10
     D PIgnMtch        S              4
     D Xx              S              4  0
     D X1x             S              4  0
     D X2x             S              4  0
     D Cx              S              4  0
     D S1x             S              4  0
     D S2x             S              4  0
      *
     D Buff            S              4S 0 DIM(999)
     D Leng            S              4S 0 DIM(999)
     D rrnA1           S              9S 0 DIM(9999)
     D rrnA2           S              9S 0 DIM(9999)
      *
     ICFKD1F        01
     I              CKKFLD                      KFld1         L1M1
     I              CKRRN                       rrn1
      *
     ICFKD2F        02
     I              CKKFLD                      KFld2         L1M1
     I              CKRRN                       rrn2
      *
     IInpFile1  NS
     I                                  1 4000  FileDt1
     I                                  1 4000  FileDt1x
      *
     IInpFile2  NS
     I                                  1 4000  FileDt2
     I                                  1 4000  FileDt2x
      *
      * This part of the program is run through the logic cycle.
     C  NMR              DO
     C                   EXSR      PrePut
     C   01rrn1          CHAIN     InpFile1                           H1
     C   01              EVAL      CFFIL1 = PFile1
     C   01              EVAL      CFRRN1 = rrn1
     C   01              EVAL      CFDATA = FileDt1
     C   02rrn2          CHAIN     InpFile2                           H1
     C   02              EVAL      CFFIL2 = PFile2
     C   02              EVAL      CFRRN2 = rrn2
     C   02              EVAL      CFDATA = FileDt2
     C                   WRITE     UTCMPFD0
     C                   ENDDO
      *
     C   MR              DO
     C                   EVAL      *IN20 = *ON
     C   01              EVAL      X1x = X1x + 1
     C   01              IF        X1x <= 9999
     C                   EVAL      rrnA1(X1x) = rrn1
     C                   ENDIF
     C   01              IF        X1x = 0
     C                   EVAL      *INU8 = *ON
     C                   ENDIF
      *
     C   02              EVAL      X2x = X2x + 1
     C   02              IF        X2x <= 9999
     C                   EVAL      rrnA2(X2x) = rrn2
     C                   ENDIF
     C   02              IF        X2x = 0
     C                   EVAL      *INU8 = *ON
     C                   ENDIF
 
     C                   ENDDO
     C*
     CL1 20              EXSR      MatchRec
     CL1                 EVAL      *IN20 = *OFF
     CL1                 EVAL      X1x = 0
     CL1                 EVAL      X2x = 0
     CL1                 EVAL      rrnA1 = 0
     CL1                 EVAL      rrnA2 = 0
      *****************************************************************
      *                                                               *
      * PrePut -                                                      *
      *                                                               *
      *****************************************************************
     C     PrePut        BEGSR
      *
     C                   EVAL      CFSEQN = CFSEQN + 1
     C                   EVAL      CFTYPE = 'EX'                                *EXTRANEOUS
     C                   EVAL      CFFIL1 = *blanks
     C                   EVAL      CFFIL2 = *blanks
     C                   EVAL      CFRRN1 = 0
     C                   EVAL      CFRRN2 = 0
      *
     C     PrePutE       ENDSR
      *****************************************************************
      *                                                               *
      * MatchRec -                                                    *
      *                                                               *
      *****************************************************************
     C     MatchRec      BEGSR
      *
     C                   IF        X1x = 1 and
     C                             X2x = 1
     C                   EXSR      MatchRecOut
     C                   ELSE
     C                   IF        *INU8 = *OFF
     C                   EVAL      S1x = X1x
     C                   EVAL      S2x = X2x
      * Loop through rrn1 and search every rrn2 for a match.
     C                   EVAL      X1x = 1
     C                   DOW       X1x <= S1x
     C                   EVAL      rrn1 = rrnA1(X1x)
     C                   EVAL      X2x = 1
     C                   DOW       X2x <= S2x
     C                   IF        rrnA2(X2x) <> 0
     C                   EVAL      rrn2 = rrnA2(X2x)
     C     rrn1          CHAIN     InpFile1                           H1
     C     rrn2          CHAIN     InpFile2                           H1
     C                   EXSR      FmtFileDtl
     C                   IF        FileDt1 = FileDt2                            *MATCH
     C                   EVAL      *IN60 = *ON
     C                   EXSR      MatchRecOut
     C                   EVAL      *IN60 = *OFF
     C                   EVAL      rrnA1(X1x) = 0
     C                   EVAL      rrnA2(X2x) = 0
     C                   EVAL      X2x = S2x
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      X2x = X2x + 1
     C                   ENDDO
     C                   EVAL      X1x = X1x + 1
     C                   ENDDO
      * Loop through rrn1 - unmatched.
     C                   EVAL      X1x = 1
     C                   DOW       X1x <= S1x
     C                   IF        rrnA1(X1x) <> 0                              *UNMATCHED
     C                   EXSR      PrePut
     C     rrnA1(X1x)    CHAIN     InpFile1                           H1
     C                   EVAL      CFFIL1 = PFile1
     C                   EVAL      CFRRN1 = rrnA1(X1x)
     C                   EVAL      CFDATA = FileDt1
     C                   WRITE     UTCMPFD0
     C                   ENDIF
     C                   EVAL      X1x = X1x + 1
     C                   ENDDO
      * Loop through rrn2 - unmatched.
     C                   EVAL      X2x = 1
     C                   DOW       X2x <= S2x
     C                   IF        rrnA2(X2x) <> 0                              *UNMATCHED
     C                   EXSR      PrePut
     C     rrnA2(X2x)    CHAIN     InpFile2                           H1
     C                   MOVEL     PFile2        CFFIL2
     C                   EVAL      CFRRN2 = rrnA2(X2x)
     C                   EVAL      CFDATA = FileDt2
     C                   WRITE     UTCMPFD0
     C                   ENDIF
     C                   EVAL      X2x = X2x + 1
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     MatchRecE     ENDSR
      *
      *****************************************************************
      *                                                               *
      * MatchRecOut -                                                 *
      *                                                               *
      *****************************************************************
     C     MatchRecOut   BEGSR
      *
     C  N60rrn1          CHAIN     InpFile1                           H1
     C  N60rrn2          CHAIN     InpFile2                           H1
     C  N60              EXSR      FmtFileDtl
     C                   IF        FileDt1 <> FileDt2 or
     C                             PIgnMtch = '*NO '
     C                   EVAL      CFFIL1 = PFile1
     C                   EVAL      CFFIL2 = PFile2
     C                   EVAL      CFSEQN = CFSEQN + 1
     C                   IF        FileDt1 <> FileDt2
     C                   EVAL      CFTYPE = 'U1'
     C                   ELSE
     C                   EVAL      CFTYPE = 'M1'
     C                   ENDIF
     C                   EVAL      CFDATA = FileDt1x
     C                   EVAL      CFRRN1 = rrn1
     C                   EVAL      CFRRN2 = rrn2
     C                   WRITE     UTCMPFD0
     C                   EVAL      CFSEQN = CFSEQN + 1
     C                   IF        FileDt1 <> FileDt2
     C                   EVAL      CFTYPE = 'U2'
     C                   ELSE
     C                   EVAL      CFTYPE = 'M2'
     C                   ENDIF
     C                   EVAL      CFDATA = FileDt2x
     C                   WRITE     UTCMPFD0
     C                   ENDIF
      *
     C     MatchRecOutE  ENDSR
      *
      *****************************************************************
      *                                                               *
      * FmtFileDtl -                                                  *
      *                                                               *
      *****************************************************************
     C     FmtFileDtl    BEGSR
      *
     C                   EVAL      Xx = 1
     C                   DOW       Xx <= Cx
     C                   EVAL      %SUBST(FileDt1:Buff(Xx):Leng(Xx))
     C                             = %SUBST(FileDt2:Buff(Xx):Leng(Xx))
     C                   EVAL      Xx = Xx + 1
     C                   ENDDO
      *
     C     FmtFileDtlE   ENDSR
      *
     C*****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFile1
     C                   PARM                    PFile2
     C                   PARM                    PTFile
     C                   PARM                    PIgnMtch
      *
     C                   EVAL      CFCODE = 'R'
     C                   EVAL      CFSEQN = 0
     C                   EVAL      *IN99 = *OFF
     C   99
     CANN991             CHAIN     UTCMPFD0                           H1
      *
     C                   EVAL      Xx = 0
     C     PTFile        SETLL     UTFLDDPD
     C     PTFile        READE     UTFLDDPD                               99
     C                   DOW       *IN99 = *OFF
     C                   IF        FDSEQN = 999 and
     C                             Xx < 999
     C                   EVAL      Xx = Xx + 1
     C                   EVAL      Buff(Xx) = FDBUFF
     C                   EVAL      Leng(Xx) = FDLENG
     C                   ENDIF
     C     PTFile        READE     UTFLDDPD                               99
     C                   ENDDO
      *
     C                   EVAL      Cx = Xx
      *
     C                   ENDSR
     C*****************************************************************
