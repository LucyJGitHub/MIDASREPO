     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Get journal receiver of a component')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC002475 - Retrieve the name of a journal receiver attached  *
      *              during a CoB component for a particular run date *
      *                                                               *
      *  Function: This module is used to retrieve journal receiver   *
      *            names from the file SCJSEQPD based on a close of   *
      *            business component and run date.                   *
      *                                                               *
      *  Component of: SCC002475                                      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSC020  *CREATE    Date 31Mar04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC020 - Journaling changes for MidasPlus.                   *
      *                                                               *
      *****************************************************************
     FSCJSEQL2  IF   E           K DISK
      *
      *  Define entry parameters.
      *
     C     *ENTRY        plist
      *
      *  Run date
      *
     C                   parm                    RunDay            5 0
      *
      *  Close of business component name
      *
     C                   parm                    Comp             10
      *
      *  Close of business component sequence
      *
     C                   parm                    CmpSeq            5 0
      *
      *  Journal receiver
      *
     C                   parm                    JrnRcv           10
      *
      *  Journal sequence number
      *
     C                   parm                    JrnSeq           10 0
      *
      *  Key list for SCJSEQL2
      *
     C     KJSEQ         klist
     C                   kfld                    JSRUND
     C                   kfld                    JSCOMP
     C                   kfld                    JSCSEQ
     C                   kfld                    JSTIME
      *
      *  Set up Key fields.
      *
     C                   move      Comp          JSCOMP
     C                   z-add     CmpSeq        JSCSEQ
     C                   z-add     RunDay        JSRUND
     C                   move      *LOVAL        JSTIME
      *
      *  Set lower limits for specified component.
      *
     C     KJSEQ         setll     SCJSEQD0                           88
      *
      *  Read a record.
      *
     C                   read      SCJSEQD0                               24
      *
      *  If record found,
      *
     C     *IN24         ifeq      *OFF
     C     JSCOMP        andeq     Comp
     C     JSCSEQ        andeq     CmpSeq
     C     JSRUND        andeq     RunDay
      *
      *  Return journal receiver and sequence number.
      *
     C                   move      JSJREC        JrnRcv
     C                   z-add     JSJSEQ        JrnSeq
      *
      *  If record not found,
      *
     C                   else
      *
     C                   move      '          '  JrnRcv
     C                   z-add     1             JrnSeq
      *
     C                   endif
      *
      *  Terminate program and return to caller.
      *
     C                   eval      *INLR = *ON
     C                   return
      *
      *********************************************************************************************
