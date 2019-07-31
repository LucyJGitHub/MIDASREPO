     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Update extension file data on UPAFFD')        *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP009011 - Update extension file data on UPAFFD              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CUP040  *CREATE    Date 23Mar15               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP040 - New deliverable data methodology.                   *
      *                                                               *
      *****************************************************************
 
     D KeyFieldArr     S             10A   DIM(10)
     D FLNAME          S             10A
     D inPssr          S               n
      *
      /COPY QSYSINC/QRPGLESRC,QUSEC
      /COPY QSYSINC/QRPGLESRC,QUSGEN
      /COPY QSYSINC/QRPGLESRC,QUSLFLD
      *
     D QualUsrSpcNm    s             20    INZ('FFDUS     QTEMP')
     D ExtAttr         s             10
     D FmtName         s              8    INZ('FLDL0100')
     D RcdFmt          s             10    INZ('*FIRST')
     D OverRide        s              1    INZ('1')
     D InitialSize     s              9B 0 INZ(32768)
     D InitialValue    s              1    INZ(x'00')
     D PublicAut       s             10    INZ('*USE')
     D SpcDesc         s             50    INZ('Field List Space')
     D Replace         s             10    INZ('*YES')
      *
     D QualFileName    ds
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
      ** Create user space.
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
      ** Retrieve pointer to user space.
     C                   CALL      'QUSPTRUS'
     C                   PARM                    QualUsrSpcNm
     C                   PARM                    SpcPtr
     C                   PARM                    qusec
      *
     C                   EXSR      ChkApiErr
      *
      ** List Fields (QUSLFLD) API.
     C                   CALL      'QUSLFLD'
     C                   PARM                    QualUsrSpcNm
     C                   PARM                    FmtName
     C                   PARM                    QualFileName
     C                   PARM                    RcdFmt
     C                   PARM                    OverRide
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
      ** If the field is not a key field then update UPAFFDPD.
     C     qusfn02       LOOKUP    KeyFieldArr                            10
     C                   IF        NOT(%EQUAL)
     C/exec SQL
     C+ update UPAFFDPD set
     C+    AFKEYF = 'X'
     C+ where
     C+    AFFDNM = :qusfn02
     C/end-exec
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
      *
     C                   EVAL      iFile = FLNAME
     C                   EVAL      iLib  = '*LIBL'
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
