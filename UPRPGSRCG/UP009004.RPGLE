     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*XBI *  OVRDBF FILE(CFFDL02) TOFILE(UPCFFDL0) SHARE(*NO)             *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Create file field definition')                *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP009004 - Create file fields definition                     *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR859322           Date 09Nov11               *
      *                 CUP021  *CREATE    Date 20Jan11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR859322 - Ensure AFCOID field has correct value.            *
      *  CUP021 - Rewrite of Action File processing                   *
      *                                                               *
      *---------------------------------------------------------------*
     FCFFDL02   UF A E           K DISK
 
      *****************************************************************
 
     D KeyFieldArr     S             10A   DIM(10)
     D FLNAME          S             10A
     D inPssr          S               n
     D inLib           S             10
      *
      /COPY QSYSINC/QRPGLESRC,QUSEC
      /COPY QSYSINC/QRPGLESRC,QUSGEN
      /COPY QSYSINC/QRPGLESRC,QUSLFLD
      *
     D QualUsrSpcNm    s             20    INZ('FFDUSRSP  QTEMP')
     D ExtAttr         s             10
     D InitialSize     s              9B 0 INZ(32768)
     D InitialValue    s              1    INZ(x'00')
     D PublicAut       s             10    INZ('*USE')
     D SpcDesc         s             50    INZ('Field List Space')
     D Replace         s             10    INZ('*YES')
      *
     D qualFileName    ds
     D  iFile                        10    INZ(*BLANKS)
     D  iLib                         10    INZ(*BLANKS)
      *
     D SpcPtr          S               *
     D FldInfo         S                   LIKE(qusl0100)
     D                                     BASED(FldPtr)
      *
     D StartPos        S              9B 0 INZ(0)
     D DataLen         S              9B 0 INZ(0)
      *
     D Ix              S                   like(qusnbrle)
      *
      * Set bytes provided (used in error code parameter).
     C                   EVAL      qusbprv = 16
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
     C                   EXSR      chkApiErr
      *
      * Retrieve pointer to user space.
     C                   CALL      'QUSPTRUS'
     C                   PARM                    QualUsrSpcNm
     C                   PARM                    SpcPtr
     C                   PARM                    qusec
 
     C                   EXSR      ChkApiErr
 
      *** List Fields (QUSLFLD) API
     C                   CALL      'QUSLFLD'
     C                   PARM                    QualUsrSpcNm
     C                   PARM      'FLDL0100'    fmtName           8
     C                   PARM                    qualFileName
     C                   PARM      '*FIRST'      rec_fmt          10
     C                   PARM      '1'           override          1
     C                   PARM                    qusec
      *
     C                   EXSR      ChkApiErr
      *
      * Retrieve user space.
     C                   EVAL      StartPos    = 1
     C                   EVAL      DataLen     = %len(qush0100)
     C                   CALL      'QUSRTVUS'
     C                   PARM                    QualUsrSpcNm
     C                   PARM                    StartPos
     C                   PARM                    DataLen
     C                   PARM                    qush0100
      *
     C                   EXSR      ChkApiErr
      *
      * Get field information from user space.
     C                   EVAL      FldPtr      = SpcPtr
     C                                         + qusold
      *
     C                   FOR       Ix          = 1 to qusnbrle
     C                   EVAL      qusl0100    = FldInfo
      *
      * Make sure if record not already exist before output.
     C                   EVAL      AFFDPS = qusibp
     C     UPCFFDK       CHAIN     UPAFFDD0                           9898
     C                   IF        *IN98 = '1'
     C                   EVAL      AFFDNM = qusfn02
     C                   EVAL      AFFDTP = qusdt
     C                   EVAL      AFFDLN = qusflb
     C                   EVAL      AFFDND = qusigits
     C                   EVAL      AFFDDP = qusdp
     C                   EVAL      AFFDTX = qusftd
     C                   EVAL      AFDIFF = '*'
     C                   EVAL      AFIGNU = ' '
     C                   EVAL      AFIGNC = ' '
     C**********         EVAL      AFCOID = qusic                                           AR859322
     C                   IF        qusic = '1'                                              AR859322
     C                   EVAL      AFCOID = 'Y'                                             AR859322
     C                   ELSE                                                               AR859322
     C                   EVAL      AFCOID = 'N'                                             AR859322
     C                   ENDIF                                                              AR859322
      *
      * Adjust for variable length field.
     C                   IF        qusvlfi = '1'
     C                   EVAL      AFFDPS = AFFDPS + 2
     C                   EVAL      AFFDLN = AFFDLN - 2
     C                   ENDIF
      *
     C     AFFDNM        LOOKUP    KeyFieldArr                            10
     C                   SELECT
     C                   WHEN      %EQUAL
     C                   EVAL      AFKEYF = 'Y'
     C                   OTHER
     C                   EVAL      AFKEYF = ' '
     C                   ENDSL
     C                   WRITE     UPAFFDD0
     C                   ENDIF
      *
     C                   IF        Ix  < qusnbrle
     C                   EVAL      FldPtr  = FldPtr + qussee
     C                   ENDIF
      *
     C                   ENDFOR
      *
      * Delete user space.
     C                   CALL      'QUSDLTUS'
     C                   PARM                    QualUsrSpcNm
     C                   PARM                    qusec
      *
     C                   EVAL      *INLR       = *ON
     C                   RETURN
      /EJECT
      *********************************************************************
      *                                                                   *
      * ChkApiErr - Subroutine that checks for API errors                 *
      *                                                                   *
      *********************************************************************
      *
     C     ChkApiErr     BEGSR
      *
     C                   IF        qusbavl     > 0
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     ChkApiErrE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    FLNAME
     C                   PARM                    KeyFieldArr
     C                   PARM                    inLib
      *
     C                   EVAL      iFile = FLNAME
     C                   EVAL      AFFILE = FLNAME
      *
     C                   IF        inLib = *BLANKS
     C                   EVAL      inLib = '*LIBL'
     C                   ENDIF
     C                   EVAL      iLib  = inLib
      *
     C     UPCFFDK       KLIST
     C                   KFLD                    AFFILE
     C                   KFLD                    AFFDPS
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
     C                   EVAL      inPssr      = *ON
     C                   EVAL      *INU7       = *ON
     C                   EVAL      *INU8       = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INLR       = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *********************************************************************
