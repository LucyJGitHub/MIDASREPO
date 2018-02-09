     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Get journal sequence of a job event')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC002473 - Retrieve the journal sequence number of a close   *
      *              of business component                            *
      *                                                               *
      *  Function: This module is used to retrieve journal sequence   *
      *            numbers from the file SCJSEQPD based on a close of *
      *            business component, job and event flag.            *
      *                                                               *
      *  Component of: SCC002473                                      *
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
     FSCJSEQL1  IF   E           K DISK
      *
      *  Define entry parameters.
      *
     C     *ENTRY        plist
      *
      *  Close of business component name
      *
     C                   parm                    Comp             10
      *
      *  Close of business component sequence
      *
     C                   parm                    CmpSeq            5 0
      *
      *  Event flag
      *
     C                   parm                    EvtFlg            1
      *
      *  Job name
      *
     C                   parm                    JobNam           10
      *
      *  Job user
      *
     C                   parm                    JobUsr           10
      *
      *  Job number
      *
     C                   parm                    JobNo             6
      *
      *  Journal receiver
      *
     C                   parm                    JrnRcv           10
      *
      *  Journal sequence number
      *
     C                   parm                    JrnSeq           10 0
      *
      *  Key list for SCJSEQL0
      *
     C     KJSEQ         klist
     C                   kfld                    JSCOMP
     C                   kfld                    JSCSEQ
     C                   kfld                    JSFLAG
     C                   kfld                    JSJOB
     C                   kfld                    JSUSER
     C                   kfld                    JSNUMB
      *
      *  Set up Key fields.
      *
     C                   move      Comp          JSCOMP
     C                   z-add     CmpSeq        JSCSEQ
     C                   move      EvtFlg        JSFLAG
     C                   move      JobNam        JSJOB
     C                   move      JobUsr        JSUSER
     C                   move      JobNo         JSNUMB
      *
      *  Chain to specified record.
      *
     C     KJSEQ         chain     SCJSEQD0                           88
      *
      *  If record found,
      *
     C     *IN88         ifeq      *OFF
      *
      *  Return journal receiver and sequence number.
      *
     C                   move      JSJREC        JrnRcv
     C                   z-add     JSJSEQ        JrnSeq
      *
      *  If record not found,
      *
     C                   else
     C                   move      '          '  JrnRcv
     C                   z-add     0             JrnSeq
     C                   exsr      *PSSR
      *
     C                   endif
      *
      *  Terminate program and return to caller.
      *
     C                   eval      *INLR = *ON
     C                   return
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WDUMP = *BLANKS
     C                   MOVE      'Y'           WDUMP             1
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
 
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
     C****************************************************************
