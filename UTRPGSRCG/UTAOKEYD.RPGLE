     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Get file key information')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities module                                     *
      *                                                               *
      *  UTAOKEYD - Retrieve file key information                     *
      *                                                               *
      *  Function: This program returns inforamtion about the key     *
      *            fields of files.                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CUP021  *CREATE    Date 11Jan11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP021 - Rewrite of Action File processing                   *
      *                                                               *
      *****************************************************************
      *
      * The following /COPY lines include the structures necessary for the
      *  QDBRTVFD API.  The first is specific to that API; the second is
      *  the generic API error structure.
     D/COPY QSYSINC/QRPGLESRC,QDBRTVFD
     D/COPY QSYSINC/QRPGLESRC,QUSEC
      *
      * Parameters
     D ReturnCode      S              7
     D NumberOfkey     S              2  0
     D KeyName         S             10A   DIM(10)
     D FileName        S             10A
     D FileLib         S             10A
      *
      * Parameters for the QDBRTVFD API.
     D RcvrLen         S              9B 0 INZ(6400)
     D QualFRtn        S             20A
     D FormatRtn       S              8A   INZ('FILD0300')
     D QualFSent       S             20A
     D RcdFmtName      S             10A   INZ('*FIRST')
     D Override        S              1A   INZ('1')
     D System          S             10A   INZ('*LCL')
      * Format type (not actually used for the format we are requesting,
      *  but a required parameter).
     D FormatType      S             10A   INZ('*INT')
     D OUTDATA         S           6400A   INZ(*BLANKS)
     D StrPos          S              5I 0
     D Indx            S              2  0
      *
     D Recursive       S              1
      /EJECT
      *****************************************************************
      *
     C     Start         TAG
      *
     C                   EVAL      NumberOfKey = 0
     C                   CLEAR                   KeyName
      * Clear the returned error structure before passing it.
     C                   CLEAR                   QUSEC
      *
      * Set up the 'Bytes provided' field for the API error structure.
     C                   EVAL      QUSBPRV = 16
      *
      * Set up the qualified file name sent to the API.
     C                   EVAL      QualFSent = FileName + FileLib
      *
     C                   CALL      'QDBRTVFD'
     C                   PARM                    OUTDATA
     C                   PARM                    RcvrLen
     C                   PARM                    QualFRtn
     C                   PARM                    FormatRtn
     C                   PARM                    QualFSent
     C                   PARM                    RcdFmtName
     C                   PARM                    Override
     C                   PARM                    System
     C                   PARM                    FormatType
     C                   PARM                    QUSEC
      *
      * If the API returned an error, indicate this to the caller.
     C                   EVAL      ReturnCode = QUSEI
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      QDBQ62 = %SUBST(OutData:25:32)
     C                   EVAL      QDBQ63 = %SUBST(OutData:1:24)
      *
      * Process Key Information Stored in the OutputData Variable
     c                   Eval      StrPos=QDBKIO+1
     C                   EVAL      Indx = 0
     c                   Do        QDBNBROK
     C                   EVAL      Indx = Indx + 1
     C                   EVAL      QDBQ65 = %SUBST(OutData:StrPos:64)
     C                   EVAL      KeyName(Indx) = QDBIFN
     C                   EVAL      StrPos = StrPos + 64
     C                   ENDDO
      * Return the record length.
     C                   EVAL      NumberofKey = QDBNBROK
     C                   ENDIF
      *
     C                   SETON                                        LR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      * Received paramters.
     C                   PARM                    ReturnCode
     C                   PARM                    NumberOfKey
     C                   PARM                    KeyName
      * Sent parameters.
     C                   PARM                    FileName
     C                   PARM                    FileLib
      *
     C     INZSRE        ENDSR
      *
      /EJECT
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     Recursive     IFEQ      *BLANKS
      *
     C                   MOVE      'Y'           Recursive
      *
     C                   DUMP
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
