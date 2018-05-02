     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MS Midas/CAS compression server      *MODULE')
      *****************************************************************
      *                                                               *
      *  Midas SWIFT Direct link : Midas/CAS interface                *
      *                                                               *
      *  MS8200M - Midas/CAS compression server                       *
      *                                                               *
      *  Function:  This program formats outgoing SWIFT messages      *
      *             and passes them via a data queue to the           *
      *             transmission program.                             *
      *                                                               *
      *  Sbmtd by : MSC8010 - Midas/CAS communications                *
      *                                                               *
      *  Calls    : QSNDDTAQ - Send data queue entry                  *
      *             QRCVDTAQ - Receive data queue entry               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSW218             Date 19Mar18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      *                 CFT013             Date 25May00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPK009             Date 16Aug99               *
      *                 CSW008 *CREATE     Date 05Dec97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW218 - SWIFT Changes 2018                                  *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CFT014 - MT103 Message Generation for FT                     *
      *  CFT013 - MT103 Message Generation for Non-FT                 *
      *           joint change with CFT014                            *
      *  CDL008 - Continuous Linked Settlement                        *
      *  CPK009 - Recompile problems found in DBA R3.00 packaging.    *
      *  CSW008 - Midas/CAS interface                                 *
      *                                                               *
      *****************************************************************
      /EJECT
     FMGOREFL0  UF   E           K disk    infsr(srfile)
     FMGOREFL3  UF   E           K disk    infsr(srfile)
     F                                     rename(mgorefd0:mgorefd3)
     FMGOMSGPD  IF   E           K disk    infsr(srfile)
     FMS8200AU  O    E             printer infsr(srfile)
     F                                     oflind(*in66)
     F                                     usropn
      /EJECT
      /COPY MSCPYSRC,SRERRD
     D cpy@            S             80    dim(1) ctdata perrcd(1)
      ** Array containing Copyright statement
      *
     D*TAB1************S              5A   ctdata perrcd(1) dim(1)                     CDL008 CFT014
     D*TAB1************S              5A   ctdata perrcd(1) dim(2)                     CFT014 CSW218
     D TAB1            S              5A   ctdata perrcd(1) dim(3)                            CSW218
      ** Table containing valid Block 3 Codes                                                 CDL008
      *                                                                                       CDL008
     D                 DS
     D  q@dqe                  1  12050
     D  q@sndref               1     50
     D  q@msgbuf              51  12050
     D                                     DIM(12000)
     D  q@prompt               1     50
     D  q@trace                1     50
      ** Data queue entry
      *
     D  msstat       E DS                  extname(MSSTAT)
     D  ZZ053N       E                     extfld(ZZ053)                        CPK009
      ** Midas/SWIFT Direct Link status data area
      *
      /SPACE 2
     D                 DS
     D  w@nwds                 1     20
     D  w@dbic                 1      8
     D  w@dbrch                9     11
      *
     D                 DS
     D  @sw2                   1     49
     D  txt1                   1      6    INZ('{1:F01')
     D  @snd2                  7     18
     D  @tandt                14     14
     D  txt2                  19     33    INZ('9999999999}{2:I')
     D  MTPY                  34     36
     D  @dst2                 37     48
     D  MPRY                  49     49
      **  SWIFT II message header for outgoing message formatting
      *
      /SPACE 2
     D  w@txt4         S              4A   inz('}{3:')                                        CDL008
      *                                                                                       CDL008
     D                 DS
     D  w@tx3                  1      4    inz('}{4:')
     D  w@cr                   5      5    inz(x'0d')
     D  w@lf                   6      6    inz(x'25')
     D  w@crlf                 5      6
     D  txt3                   1      6
     Dw@null           S              1    inz(x'00')
      ** Control codes and fixed texts
      *
      /EJECT
      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_trace      : Trace function                               *
      *  sr_cmprs      : Compress message and send to data queue      *
      *  sr_format     : Format message for transmission              *
      *  sr_reset      : Reset status of pending message              *
      *  *PSSR         : Standard program exception error routine     *
      *****************************************************************
      /EJECT
      *
      ** Set up copyright parameter
     C                   movea     cpy@          cpy2@            80
      *
      ** Define data areas
     C     *dtaara       define                  msstat
      *
      ** Parameter lists
     C     *entry        plist
     C                   parm                    p@dtqm           10
     C                   parm                    p@dtqc           10
      *
     C     q@rcvdtaq     plist
     C                   parm                    q@dtaq           10
     C                   parm      '*LIBL'       q@libl           10
     C                   parm                    q@length          5 0
     C                   parm                    q@dqe
     C                   parm                    q@wait            5 0
      *
     C     q@snddtaq     plist
     C                   parm      p@dtqm        q@dtaq
     C                   parm      '*LIBL'       q@libl
     C                   parm      12050         q@length
     C                   parm                    q@dqe
      *
      ** Push routine
     C                   z-add     1             Q
     C                   movel     'mainline'    @STK(Q)
      *
      ** Wait for prompt
     C                   movel     p@dtqc        q@dtaq
     C                   z-add     -1            q@wait
     C                   z-add     50            q@length
     C                   call      'QRCVDTAQ'    q@rcvdtaq
      *
      ** DoWhile shutdown not requested
     C     q@prompt      downe     '*SHUTDOWN'
      *
      ** Get next message and send to data queue
     C                   exsr      sr_trace
     C                   exsr      sr_cmprs
     C                   exsr      sr_trace
      *
      ** Wait for prompt
     C                   movel     p@dtqc        q@dtaq
     C                   z-add     -1            q@wait
     C                   z-add     50            q@length
     C                   call      'QRCVDTAQ'    q@rcvdtaq
     C                   enddo
      *
      ** Reset pending message if outstanding
     C                   exsr      sr_trace
     C                   exsr      sr_reset
     C                   exsr      sr_trace
      *
      ** Close printer file if open, and terminate
     C     w@prtopn      ifeq      'Y'
     C                   write     ms8200f3
     C                   close     ms8200au
     C                   endif
      *
     C                   seton                                        LR
      /EJECT
      **********************************************************************
      * sr_trace       : Trace function                                    *
      * --------                                                           *
      *                                                                    *
      * Called by      : mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_trace      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_trace'    @STK(Q)
      *
      ** Check whether trace requested. If it is, write trace information
      ** to report.
     C                   in        msstat
     C     TRACF         ifeq      'T'
      *
      ** If spool file not already open, open it now.
     C     w@prtopn      ifne      'Y'
     C                   movel     'Y'           w@prtopn          1
     C                   open      ms8200au
     C                   write     ms8200f1
     C                   endif
      *
      ** Check for overflow and rewrite headings if necessary.
     C     *in66         ifeq      *on
     C                   movel     *off          *in66
     C                   write     ms8200f1
     C                   endif
      *
      ** Set up standard details and write to report
     C                   time                    PR@TI
     C                   movel(p)  q@trace       PR@TR
     C                   write     ms8200t1
      *
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_cmprs       : Compress outgoing message and send to data queue  *
      * --------                                                           *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : QSNDDTAQ - Send data queue entry                  *
      *                                                                    *
      **********************************************************************
      *
     C     sr_cmprs      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_cmprs'    @STK(Q)
      *
      ** Initialise 'message found' indication
     C                   movel     'N'           w@msgfnd          1
      *
      ** If specific message requested, access file and check it is
      ** flagged for recovery
     C     q@prompt      ifne      '*NEXT'
      *
     C                   movel     q@prompt      w@trn            16
     C     w@trn         chain     mgorefd0                           50
      *
     C     *in50         ifeq      *off
     C     MGST          ifeq      'RECO'
     C                   movel     'R'           w@msgfnd
     C                   else
     C                   unlock    mgorefl0
     C                   endif
     C                   endif
      *
      ** Else get next Ready-to-Send message
     C                   else
     C     *loval        setll     mgorefd3
     C                   read      mgorefd3                               50
      *
     C     *in50         ifeq      *off
     C                   movel     'Y'           w@msgfnd
     C                   endif
     C                   endif
      *
      ** If message found, format and set status to 'PEND' (Pending Tx)
     C     w@msgfnd      ifne      'N'
      *
     C                   exsr      sr_format
     C     q@sndref      ifeq      '*ERROR'
     C                   movel     '4'           MGSG
     C                   movel     'EFMT'        MGST
     C                   else
     C                   movel     'PEND'        MGST
     C                   endif
      *
      ** Update appropriate format
     C     w@msgfnd      ifeq      'R'
     C                   update    mgorefd0
     C                   else
     C                   update    mgorefd3
     C                   endif
      *
      ** else (if no message found) set up '*NONE' for return
     C                   else
     C                   movel(p)  '*NONE'       q@sndref
     C                   endif
      *
      ** Send detail to data queue
     C                   call      'QSNDDTAQ'    q@snddtaq
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_format      : Format message for transmission                   *
      * ---------                                                          *
      *                                                                    *
      * Called by      : sr_out                                            *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_format     begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_format'   @STK(Q)
      *
      ** Access first data record which is not part-deleted
     C     TRNO          setll     mgomsgd0
     C     PTDL          doune     'D'
     C     *in15         oreq      *on
     C     TRNO          reade     mgomsgd0                               15
     C                   enddo
      *
      ** Database error if no live details found
     C     *in15         ifeq      *on
     C                   movel(p)  '*ERROR'      q@sndref
     C                   else
      *
      ** Expand destination address to 12 characters with 'X' between
      ** BIC and branch code, and branch code 'XXX' if not quoted.
     C                   movel(p)  NWDS          w@nwds
     C     w@dbrch       ifeq      *blanks
     C                   movel     'XXX'         w@dbrch
     C                   endif
     C                   movel(p)  w@dbic        @dst2
     C     @dst2         cat       'X':0         @dst2
     C     @dst2         cat       w@dbrch:0     @dst2
      *
      ** Set up sender's address and write SWIFT II header to message buffer
     C                   movel     NWSN          @snd2
     C                   z-add     1             p                 5 0
     C                   movea     @sw2          q@msgbuf(p)
     C                   add       49            p
      *
      ** Write delivery notification to message buffer if not blank,
      ** followed by end of block 2, start of block 4.
     C     DELC          ifne      '0'
     C     DELC          andne     ' '
     C                   movea     DELC          q@msgbuf(p)
     C                   add       1             p
     C                   endif
                                                                                              CDL008
      ** Output all Block 3 details first before Block 4                                      CDL008
                                                                                              CDL008
     C     *in15         ifeq      *off                                                       CDL008
                                                                                              CDL008
     C     MTAG          lookup    TAB1                                   17                  CDL008
                                                                                              CDL008
     C     *in17         ifeq      *on                                                        CDL008
                                                                                              CDL008
     C                   movea     w@txt4        q@msgbuf(p)                                  CDL008
     C                   add       4             p                                            CDL008
                                                                                              CDL008
     C     *in15         doweq     *off                                                       CDL008
     C     *in17         andeq     *on                                                        CDL008
                                                                                              CDL008
     C                   movel     MTAG          WBLK3             5                          CDL008
     C                   movel     '{'           WBLK3                                        CDL008
     C                   movea     WBLK3         q@msgbuf(p)                                  CDL008
     C                   add       5             p                                            CDL008
                                                                                              CDL008
     C                   movea     MFLD          q@msgbuf(p)                                  CDL008
     C     q@msgbuf(p)   downe     *blank                                                     CDL008
     C                   add       1             p                                            CDL008
     C                   enddo                                                                CDL008
     C                   movea     '}'           q@msgbuf(p)                                  CDL008
     C                   add       1             p                                            CDL008
                                                                                              CDL008
     C     PTDL          doune     'D'                                                        CDL008
     C     *in15         oreq      *on                                                        CDL008
     C     TRNO          reade     mgomsgd0                               15                  CDL008
     C                   enddo                                                                CDL008
     C     *in15         ifeq      *off                                                       CDL008
     C     MTAG          lookup    TAB1                                   17                  CDL008
     C                   endif                                                                CDL008
                                                                                              CDL008
     C                   enddo                                                                CDL008
                                                                                              CDL008
     C                   endif                                                                CDL008
                                                                                              CDL008
     C                   endif                                                                CDL008
      *                                                                                       CDL008
      ** Output Block 4 for remaining records                                                 CDL008
      *
     C                   movea     txt3          q@msgbuf(p)
     C                   add       6             p
      *
      ** Process remaining records
     C     *in15         doweq     *off
      *
      ** Set up message data in buffer
     C     ' '           checkr    MTAG          q                 5 0
     C                   movea     MTAG          q@msgbuf(p)
     C                   add       q             p
      *
     C     ' '           checkr    MFLD          q
     C                   movea     MFLD          q@msgbuf(p)
     C                   add       q             p
      *
     C     ' '           checkr    CTRC          q
     C                   movea     CTRC          q@msgbuf(p)
     C                   add       q             p
      *
      ** Read outgoing message file but ignore deleted parts
     C     PTDL          doune     'D'
     C     *in15         oreq      *on
     C     TRNO          reade     mgomsgd0                               15
     C                   enddo
      *
     C                   enddo
      *
      ** Append end of text block 4
     C                   movea     '-}'          q@msgbuf(p)
     C                   add       2             p
      *
      ** Append TNG (training) and PDE (Possible Duplicate Emission)
      ** trailers in block {5: if required
     C     @tandt        ifeq      '0'
     C     MPDE          oreq      'Y'
     C                   movea     '{5:'         q@msgbuf(p)
     C                   add       3             p
      *
      ** TNG required if sender's address is Test and Training (identified
      ** by '0' in position 8)
     C     @tandt        ifeq      '0'
     C                   movea     '{TNG:}'      q@msgbuf(p)
     C                   add       6             p
     C                   endif
      *
      ** PDE required if message sent is for recovery or PDE requested
     C     MPDE          ifeq      'Y'
     C     w@msgfnd      oreq      'R'
     C                   movea     '{PDE:}'      q@msgbuf(p)
     C                   add       6             p
     C                   endif
      *
      ** Add final closing }
     C                   movea     '}'           q@msgbuf(p)
     C                   add       1             p
     C                   endif
      *
      ** Add null termination for C
     C                   movea     w@null        q@msgbuf(p)
      *
      ** Set up sender's reference (we will use TRN)
     C                   movel(p)  TRNO          q@sndref
      *
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_reset       : Reset status of pending message for this session  *
      * --------         (only if link fails)                              *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : QRCVDTAQ - Send data queue entry                  *
      *                                                                    *
      **********************************************************************
      *
     C     sr_reset      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_reset'    @STK(Q)
      *
      ** Access last message on data queue. If found (ie. it hasn't been
      ** sent) reset its status to Ready-to-Send (RSND)
     C                   movel     p@dtqm        q@dtaq
     C                   z-add     0             q@wait
     C                   z-add     12050         q@length
     C                   call      'QRCVDTAQ'    q@rcvdtaq
      *
      ** If message found, reset status to RSND
     C     q@length      ifgt      0
     C                   movel     q@sndref      w@trn            16
     C     w@trn         chain     mgorefd0                           50
     C     *in50         ifeq      *off
     C     MGST          andeq     'PEND'
     C                   movel     'RSND'        MGST
     C                   update    mgorefd0
     C                   endif
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         begsr
      *
     C     @run          ifeq      *blank
     C                   move      'Y'           @run              1
     C                   dump
      *
     C                   endif
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     '*PSSR'       @STK(Q)
      *
     C                   seton                                        U7U8LR
     C                   return
     C                   endsr
      /EJECT
      *****************************************************************
      /COPY MSCPYSRC,SRERRC
**CTDATA cpy@
(c) Finastra International Limited 2001
**CTDATA TAB1                                                                                 CDL008
:103:                                                                                         CDL008
:119:                                                                                         CFT014
:121:                                                                                         CSW218
