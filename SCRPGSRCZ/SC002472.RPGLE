     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Get journal sequence number of an event')     *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC002472 - Retrieve the journal sequence number of an        *
      *              event.                                           *
      *                                                               *
      *  Function: This module is used to retrieve journal sequence   *
      *            numbers from the file SCJSEQPD based on a standard *
      *            event description                                  *
      *                                                               *
      *  Component of: SC002472                                       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR965821           Date 10May12               *
      *                 AR853795           Date 22Oct11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSC020  *CREATE    Date 31Mar04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR965821 - FDC0050 00001 ends in database error              *
      *             (Child:AR965823)                                  *
      *  AR853795 - FDC0050 has a dump but completed normally         *
      *             (Child: AR853796)                                 *
      *  CSC020 - Journaling changes for MidasPlus.                   *
      *                                                               *
      *****************************************************************
     FSCJSEQL0  IF   E           K DISK
      *
      *  Define entry parameters.
      *
     C     *ENTRY        plist
      *
      *  Standard event description
      *
     C                   parm                    Event            20
      *
      *  Event flag
      *
     C                   parm                    EvtFlg            1
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
     C                   kfld                    JSEVNT
     C                   kfld                    JSFLAG
     C                   kfld                    JSTIME
      *
      *  Set up Key fields.
      *
     C                   move      Event         JSEVNT
     C                   move      EvtFlg        JSFLAG
     C                   move      *HIVAL        JSTIME
      *
      *  Read most recent record.
      *
     C     KJSEQ         setgt     SCJSEQD0
     C                   readp     SCJSEQD0
      *
      *  If record found,
      *
     C     JSEVNT        ifeq      Event
     C     JSFLAG        andeq     EvtFlg
      *
      *  Return journal receiver and sequence number.
      *
     C                   move      JSJREC        JrnRcv
     C                   z-add     JSJSEQ        JrnSeq
      *
      *  If record not found,
      *
     C                   else
     C     EVENT         IFEQ      'NDSUJR'                                                 AR965821
      *                                                                                     AR965821
     C                   CALL      'SCC2475'                                                AR965821
     C                   PARM                    WReturn          10                        AR965821
     C                   MOVE      WReturn       JrnRcv                                     AR965821
     C                   MOVE      *ZERO         JrnSeq                                     AR965821
      *                                                                                     AR965821
     C                   ELSE                                                               AR965821
     C                   movel     'SCJSEQL0'    DBFILE            8
     C                   movel     '002'         DBASE             3 0
     C                   movel     Event         DBKEY            29
     C                   move      EvtFlg        DBKEY
     C                   exsr      *PSSR
     C                   ENDIF                                                              AR965821
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
     C                   MOVE      *ON           *INU7                                      AR853795
     C                   MOVE      *ON           *INU8                                      AR853795
     C                   MOVE      *ON           *INLR
     C                   DUMP
 
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
     C****************************************************************
