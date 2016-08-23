     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*XBIA*  OVRDBF FILE(UTC000003F) TOFILE(UPFFDSTPD)                    *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Extract data from files for FILECOMP')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000008 - Extract data from files for CMPF                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. BUG27790 *CREATE    Date 18Jun10              *
      *  Prev Amend No. xxxxxx              Date ddMmmyy              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  BUG27790 - New utility                                       *
      *                                                               *
      *****************************************************************
     FInpFile   IP   F 4000        DISK    INFDS(IOFBK)
     FUTC000003FIF   E             DISK
     FUTCFKDPD  O    E             DISK
     FUTFLDDPD  O    E             DISK
     FUTFLDDL2  IF   E           K DISK    RENAME(UTFLDDD0:FLDDF)
      *
     D PFile           S             10
     D PKeyFlds        S            120
     D OS              S              4  0
     D IS              S              4  0
     D IL              S              4  0
     D Ix              S              2  0
     D Cx              S              3  0
     D ExtrToFldDta    S              1
      *
     D KeysA           S             10    DIM(12) ASCEND
     D InpBufPos       S             10S 0 DIM(12)
     D FldNo           S             10S 0 DIM(12)
      *
     D                 DS
     D  DBrrnA                 1     10
     D  DBrrnN                 1     10  0
      *
     D IOFBK           DS
     D  DBrrn                397    400I 0
      *
     IInpFile   NS  01
     I                                  1 4000  Data
      *
      * This element of the program uses logic cycle to read InpFile
     C                   EVAL      CKKFLD = *blank
     C                   EXSR      AccPthKFld
     C                   EVAL      CKRRN  = DBrrn
     C                   WRITE     UTCFKDD0
      *
      *****************************************************************
      *                                                               *
      * AccPthKFld - Put key fields into compare file (put rrn in if  *
      *              no key fields.                                   *
      *****************************************************************
      *                                                               *
     C     AccPthKFld    BEGSR
      *
      * If there are no keyfields then just use rrn.
     C                   IF        PKeyFlds <> *blank
     C                   EVAL      Ix = 1
     C                   EVAL      OS = 1
     C                   DOW       Ix <= 12 and
     C                             InpBufPos(Ix) <> 0 and
     C                             FldNo(Ix)  <> 0
     C                   EVAL      IS = InpBufPos(Ix)
     C                   EVAL      IL = FldNo(Ix)
     C                   IF        OS < 100 and
     C                             (OS + IL) <= 100
     C                   EVAL      %SUBST(CKKFLD:OS:IL) = %SUBST(Data:IS:IL)
     C                   EVAL      OS = OS + FldNo(Ix)
     C                   ENDIF
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
      *
     C                   ELSE
      *
     C                   EVAL      CKKFLD = *blank
     C                   EVAL      DBrrnN = DBrrn
     C                   EVAL      %SUBST(CKKFLD:1:10) = DBrrnA
     C                   ENDIF
      *
     C     AccPthKFldE   ENDSR
      *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFile
     C                   PARM                    PKeyFlds
      *
      * Load key fields, if any, into array.
     C                   IF        PKeyFlds <> *blank
     C                   MOVEA     PKeyFlds      KeysA
     C                   ENDIF
      *
     C                   EVAL      FDFILE = PFile
     C     PFile         CHAIN     FLDDF
     C                   IF        NOT(%FOUND)
     C                   EVAL      ExtrToFldDta = 'Y'
     C                   END
      * Write all fields to field details file (UTFLDD*) if not already there
      * and also get atttributes of key fields.
     C                   EVAL      FDFLDN = 1
     C                   READ      UTC000003F
     C                   DOW       NOT(%EOF)
     C                   IF        ExtrToFldDta = 'Y' and
     C                             WHFILE = FDFILE
     C                   EVAL      FDRPGN = WHFLDI
     C                   EVAL      FDBUFF = WHIBO
     C                   EVAL      FDLENG = WHFLDB
     C                   EVAL      FDDIGI = WHFLDD
     C                   EVAL      FDDECP = WHFLDP
     C                   EVAL      FDDESC = WHFTXT
     C                   EVAL      FDCOL1 = WHCHD1
     C                   EVAL      FDCOL2 = WHCHD2
     C                   EVAL      FDTYPE = WHFLDT
     C                   EVAL      FDSEQN = FDFLDN
     C                   WRITE     UTFLDDD0
     C                   EVAL      FDFLDN = FDFLDN + 1
     C                   ENDIF
      *
     C                   EVAL      Ix = 1
     C     WHFLDE        LOOKUP    KeysA(Ix)                              99
     C                   IF        *IN99 = *ON
     C                   IF        InpBufPos(Ix) = 0
     C                   EVAL      InpBufPos(Ix) = WHIBO
     C                   EVAL      FldNo(Ix) = WHFLDB
     C                   ENDIF
     C                   ENDIF
     C                   READ      UTC000003F
     C                   ENDDO
      * Key fields used.
     C                   EVAL      Cx = 0
     C                   EVAL      Ix = 1
     C     *zero         LOOKUP    InpBufPos(Ix)                          99
     C                   IF        *IN99 = *ON
     C                   EVAL      Cx = 10 * (Ix - 1) + 1
     C                   EVAL      %SUBST(PKeyFlds:Cx:(121 - Cx)) = *blanks
     C                   ENDIF
      *
     C                   ENDSR
     C*****************************************************************
