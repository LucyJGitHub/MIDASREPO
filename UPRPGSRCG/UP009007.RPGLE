     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*XBI *  OVRDBF FILE(AFFDL02) TOFILE(UPAFFDL0) SHARE(*NO)             *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Get file field description for Act. Files')   *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP009007 - Get field information for Action Files            *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUP021  *CREATE    Date 11Jan11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP021 - Rewrite of Action File processing                   *
      *                                                               *
      *---------------------------------------------------------------*
     FAFFDL02   UF A E           K DISK
      *
     D KeyFieldArr     S             10A   DIM(10)
     D FLNAME          S             10A
     D inPssr          S               n
     D inLib           S             10
      *
      /COPY QSYSINC/QRPGLESRC,QUSEC
      /COPY QSYSINC/QRPGLESRC,QUSGEN
      /COPY QSYSINC/QRPGLESRC,QUSLFLD
      *
     D QualUsrSpcNm    S             20    inz('FFDUSRSP  QTEMP')
     D ExtAttr         S             10
     D InitialSize     S              9B 0 inz(32768)
     D InitialValue    S              1    inz(x'00')
     D PublicAut       S             10    inz('*USE')
     D SpcDesc         S             50    inz('Field List Space')
     D Replace         S             10    inz('*YES')
      *
     D QualFileName    DS
     D  iFile                        10    inz(*BLANKS)
     D  iLib                         10    inz(*BLANKS)
      *
     D SpcPtr          S               *
     D FldInfo         S                   like(qusl0100)
     D                                     based(FldPtr)
      *
     D StartPos        S              9b 0 inz(0)
     D DataLen         S              9b 0 inz(0)
      *
     D Ix              S                   like(qusnbrle)
      *
     D                 DS
     D aFldInfo                            dim(500)
     D aFldNam                             like(qusfn02)
     D                                     overlay(aFldInfo : *next)
     D aDtaTyp                             like(qusdt)
     D                                     overlay(aFldInfo : *next)
     D aOBfOff                             like(qusobp)
     D                                     overlay(aFldInfo : *next)
     D aBufLen                             like(qusflb)
     D                                     overlay(aFldInfo : *next)
     D aNumDigits                          like(qusigits)
     D                                     overlay(aFldInfo : *next)
     D aDecPos                             like(qusdp)
     D                                     overlay(aFldInfo : *next)
     D aFldText                            like(qusftd)
     D                                     overlay(aFldInfo : *next)
     D aColHg1                             like(qusch1)
     D                                     overlay(aFldInfo : *next)
     D aColHg2                             like(qusch2)
     D                                     overlay(aFldInfo : *next)
     D aColHg3                             like(qusch3)
     D                                     overlay(aFldInfo : *next)
      *
     D OutNumFlds      S              9  0
     D OutFldDetail    S            137A   DIM(500)
      *
      /EJECT
      *****************************************************************
      *
     C                   EXSR      GetInpFlds
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *********************************************************************
      *                                                                   *
      * GetInpFlds - Subroutine that retrieves input fields               *
      *                                                                   *
      *********************************************************************
      *
     C     GetInpFlds    BEGSR
      *
      * Set bytes provided (used in error code parameter).
     C                   EVAL      qusbprv     = 16
      *
      * Create user space.
     C                   CALL      'QUSCRTUS'
     C                   PARM                    QualUsrSpcNm
     C                   PARM      iFile         ExtAttr
     C                   PARM                    InitialSize
     C                   PARM                    InitialValue
     C                   PARM                    PublicAut
     C                   PARM                    SpcDesc
     C                   PARM                    Replace
     C                   PARM                    qusec
      *
     C                   EXSR      ChkApiErr
      *
      * Retrieve pointer to user space.
     C                   CALL      'QUSPTRUS'
     C                   PARM                    qualUsrSpcNm
     C                   PARM                    SpcPtr
     C                   PARM                    qusec
      *
     C                   EXSR      ChkApiErr
      *
     C                   CALL      'QUSLFLD'
     C                   PARM                    QualUsrSpcNm
     C                   PARM      'FLDL0100'    fmtName           8
     C                   PARM                    QualFileName
     C                   PARM      '*FIRST'      rec_fmt          10
     C                   PARM      '1'           override          1
     C                   PARM                    qusec
      *
     C                   EXSR      ChkApiErr
      *
     C                   EVAL      StartPos = 1
     C                   EVAL      DataLen = %LEN(qush0100)
     C                   CALL      'QUSRTVUS'
     C                   PARM                    QualUsrSpcNm
     C                   PARM                    StartPos
     C                   PARM                    DataLen
     C                   PARM                    qush0100
      *
     C                   EXSR      ChkApiErr
      *
     C                   CLEAR                   aFldInfo
     C                   EVAL      FldPtr = SpcPtr + qusold
      *
     C                   FOR       Ix = 1 to qusnbrle
     C                   EVAL      qusl0100 = FldInfo
      *
     C                   EVAL      aFldNam(Ix) = qusfn02
     C                   EVAL      aDtaTyp(Ix) = qusdt
     C                   EVAL      aOBfOff(Ix) = qusobp
     C                   EVAL      aBufLen(Ix) = qusflb
     C                   EVAL      aNumDigits(Ix) = qusigits
     C                   EVAL      aDecPos(Ix) = qusdp
     C                   EVAL      aFldText(Ix) = qusftd
     C                   EVAL      aColHg1(Ix) = qusch1
     C                   EVAL      aColHg2(Ix) = qusch2
     C                   EVAL      aColHg3(Ix) = qusch3
      *
      * Adjust for variable length field.
     C                   IF        qusvlfi     = '1'
     C                   EVAL      aOBfOff(Ix) = aOBfOff(Ix) + 2
     C                   EVAL      aBufLen(Ix) = aBufLen(Ix) - 2
     C                   ENDIF
 
     C                   IF        Ix < qusnbrle
     C                   EVAL      FldPtr = FldPtr + qussee
     C                   ENDIF
      *
     C                   ENDFOR
      *
     C                   EVAL      OutNumFlds = qusnbrle
     C                   MOVE      aFldInfo      OutFldDetail
      *
      * Delete user space.
     C                   CALL      'QUSDLTUS'
     C                   PARM                    QualUsrSpcNm
     C                   PARM                    qusec
      *
     C     GetInpFldsE   ENDSR
      *
      /EJECT
      *********************************************************************
      *                                                                   *
      * ChkApiErr - Subroutine that checks for API errors                 *
      *                                                                   *
      *********************************************************************
      *
     C     ChkApiErr     BEGSR
      *
     C                   IF        qusbavl > 0
     C                   EXSR      *pssr
     C                   ENDIF
      *
     C     ChkApiErrE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    FLNAME
     C                   PARM                    KeyFieldArr
     C                   PARM                    inLib
     C                   PARM                    OutNumFlds
     C                   PARM                    OutFldDetail
      *
     C                   EVAL      iFile = FLNAME
      *
     C                   IF        inLib = *BLANKS
     C                   EVAL      inLib = '*LIBL'
     C                   ENDIF
     C                   EVAL      iLib  = inLib
      *
     C     INZSRE        ENDSR
      *
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        NOT inPssr
     C                   EVAL      inPssr = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *********************************************************************
