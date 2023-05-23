     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC Update journal seq on MXOLEJPD & MXOLTJPD')   *
      *****************************************************************
      *                                                               *
      *  MidasPlus System Control                                     *
      *                                                               *
      *  SCUPMXOL - Update journal sequence on MXOLEJPD and MXOLTJPD  *
      *             files.                                            *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD035998 *CREATE   Date 22May23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD035998 - Midas Plus GPHAEXIT process should update journal *
      *             sequence in MXOLEJPD and MXOLTJPD files for Midas *
      *             Export Module.                                    *
      *                                                               *
      *****************************************************************
      *
     FMXOLEJPD  UF A E             DISK
      ** Midas MX On-Line Extract Journal Sequence Number.
      *
     FMXOLTJPD  UF A E             DISK
      ** Midas MX On-Line Transm. Journal Sequence Number.
      *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    JRNRCV           10
     C                   PARM                    JRNSEQ           10 0
      *
      *****************************************************************
      *
     C                   EXSR      EXTRTN
     C                   EXSR      TRNRTN
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  EXTRTN - Update Journal Sequence Number of Extract file      *
      *                                                               *
      *****************************************************************
     C     EXTRTN        BEGSR
      *
      **  Read record from MXOLEJPD
      *
     C                   READ      MXOLEJP0                               01
     C                   MOVE      JRNSEQ        I#LASTSEQ
      *
      **  If a record was read
      *
     C     *IN01         IFEQ      '0'
      *
      **  Update the file with the sequence number received
      *
     C                   UPDATE    MXOLEJP0
      *
      **  If no record available
      *
     C                   ELSE
      *
      **  Write a record to MXOLEJPD
      *
     C                   WRITE     MXOLEJP0
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  TRNRTN - Update Journal Sequence Number of Transm. file      *
      *                                                               *
      *****************************************************************
     C     TRNRTN        BEGSR
      *
      **  Read record from MXOLTJPD
      *
     C                   READ      MXOLTJP0                               01
     C                   MOVE      JRNSEQ        I#LASTSEQ
      *
      **  If a record was read
      *
     C     *IN01         IFEQ      '0'
      *
      **  Update the file with the sequence number received
      *
     C                   UPDATE    MXOLTJP0
      *
      **  If no record available
      *
     C                   ELSE
      *
      **  Write a record to MXOLTJPD
      *
     C                   WRITE     MXOLTJP0
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
