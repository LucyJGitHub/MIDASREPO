     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Get file record length')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities module                                     *
      *                                                               *
      *  UTAORCDF - Get record length                                 *
      *                                                               *
      *  Function: This program returns the record length of a file   *
      *            passed to it.  In the case of a physical file or   *
      *            logical file with only one record format, this     *
      *            will be the actual record length.  In the case of  *
      *            a multiformat logical file it will be the length   *
      *            of the longest record format.                      *
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
      *****************************************************************
      *
      * The following /COPY lines include the structures necessary for the
      *  QDBRTVFD API.  The first is specific to that API; the second is
      *  the generic API error structure.
     D/COPY QSYSINC/QRPGLESRC,QDBRTVFD
     D/COPY QSYSINC/QRPGLESRC,QUSEC
      /EJECT
      *
      * Parameters
     D ReturnCode      S              7
     D RecordLen       S              5P 0
     D FileText        S             50
     D FileName        S             10
     D FileLib         S             10
      *
      * Parameters for the QDBRTVFD API.
     D RcvrLen         S              9B 0 INZ(400)
     D QualFRtn        S             20A
     D FormatRtn       S              8A   INZ('FILD0100')
     D QualFSent       S             20A
     D RcdFmtName      S             10A   INZ('*FIRST')
     D Override        S              1A   INZ('1')
     D System          S             10A   INZ('*LCL')
     D FormatType      S             10A   INZ('*INT')
      *
     D Recursive       S              1
      /EJECT
      *
     C     Start         TAG
      *
      * The QDBFRTVFD API will return the maximum record length in the
      *  field QDBFMXRL of data structure QDBQ25; these are defined in
      *  the include member QDBFRTVFD in QSYSINC/QRPGLESRC.
      *
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
     C                   PARM                    QDBQ25
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
      *
      * Return the record length.
     C                   EVAL      RecordLen = QDBFMXRL
     C                   EVAL      FileText = QDBFHTXT00
      *
     C                   RETURN
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
 
     C     *ENTRY        PLIST
      * Received parameters.
     C                   PARM                    ReturnCode
     C                   PARM                    RecordLen
     C                   PARM                    FileText
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
     C     PSSRE         ENDSR
      *********************************************************************
