     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Write journal sequence to SCJSEQPD')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC002471 - Write the journal sequence number of an event    *
      *              to the audit file SCJSEQPD                       *
      *                                                               *
      *  Function: This module is used to write records containing    *
      *            a journal sequence number to the file SCJSEQPD.    *
      *                                                               *
      *  Component of: SC002471                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSC020  *CREATE    Date 31Mar04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC020 - Journaling changes for MidasPlus.                   *
      *                                                               *
      *****************************************************************
     FSCJSEQPD  O    E             DISK
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      *  Define entry parameters.
      *
     C     *ENTRY        plist
      *
      *  Standard event description
      *
     C                   parm                    Event            20
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
      *  Event text
      *
     C                   parm                    EvtTxt           50
      *
      *  Midas run day nunmber
      *
     C                   parm                    Rund              5 0
      *
      *  Journal receiver
      *
     C                   parm                    JrnRcv           10
      *
      *  Journal sequence number
      *
     C                   parm                    JrnSeq           10 0
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
      **  Set up error variables
      *
     C                   MOVE      *BLANKS       DBFILE            8
     C                   MOVE      *BLANKS       DBKEY            29
     C                   MOVE      *BLANKS       DBPGM            10
     C                   MOVEL     'SC002471'    DBPGM
     C                   Z-ADD     0             DBASE             3 0
      *
      **  Access Bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C                   IF        PRTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  Set up file fields.
      *
     C                   move      Event         JSEVNT
     C                   move      Comp          JSCOMP
     C                   move      CmpSeq        JSCSEQ
     C                   move      EvtFlg        JSFLAG
     C                   move      EvtTxt        JSTEXT
     C                   z-add     BJRDNB        JSRUND
     C                   move      JrnRcv        JSJREC
     C                   z-add     JrnSeq        JSJSEQ
     C                   move      JobNam        JSJOB
     C                   move      JobUsr        JSUSER
     C                   move      JobNo         JSNUMB
     C                   time                    JSTIME
      *
      *  Write record to file.
      *
     C                   write     SCJSEQD0
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
