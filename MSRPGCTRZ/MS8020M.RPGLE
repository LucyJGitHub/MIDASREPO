     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*OVR *  OVRDBF DMAPID DAT                                            *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MS CASmf session maintenance         *MODULE')
      *****************************************************************
      *                                                               *
      *  Midas SWIFT Direct link : Midas/CAS interface                *
      *                                                               *
      *  MS8020M - CASmf session maintenance                          *
      *                                                               *
      *  Function:  This program is used to maintain the file of      *
      *             CASmf sessions for a particular Midas system.     *
      *                                                               *
      *  Called By: MSC8020 - CASmf session maintenance               *
      *                                                               *
      *  Calls    : MSC8020M                                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. 119419             Date 17Jun97               *
      *                 118481             Date 27May97               *
      *                 CSW008 *CREATE     Date 21AUG96               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  119419 - Change shutdown (on toggle) to *SYNCHronous         *
      *  118481 - Midas/CAS interface changes for CASmf v2.1          *
      *           - DMAPID changed from PF to member of source        *
      *             file DAT                                          *
      *  CSW008 - Midas/CAS interface                                 *
      *                                                               *
      *****************************************************************
      /EJECT
     FMS8020DF  CF   E             workstn
     F                                     sfile(ms8020f3:w@rrn)
     F                                     infds(d@infds)
     FMSMAPIL0  UF A E           K disk    infsr(srfile)
     F*MAPID****IF*A*E**           disk    rename(dmapid:dmap2)                               118481
     FDMAPID    IF A E             disk    rename(dat:dmap2)                                  118481
      /EJECT
      /COPY MSCPYSRC,SRERRD
     D cpy@            S             80    dim(1) ctdata perrcd(1)
      ** Array containing copyright statement
      *
     D d@infds         DS
     D  w@lstrn              378    379B 0
      **  Last subfile start RRN
      *
     D  sdstat       E DS                  extname(sdstat)
      ** SDSTAT for system prefix
      *
     D  zmuser       E DS                  extname(zmuser)
      ** ZMUSER for user's default branch
      *
     D arr1            S             26A   dim(40)
      ** Array of L-MAPIDs from CASmf
      *
     D                 DS
     D  w@cjob                 1     26
     D  MCCJOB                 1     10
     D  MCCUSR                11     20
     D  MCCNUM                21     26
      ** Full id for communications job
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short data structure for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long data structure for access programs
      *
     D sdbank        E DS                  EXTNAME(SDBANKPD)
      ** Message Management data area
      *
     D @UC             C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D @LC             C                   'abcdefghijklmnopqrstuvwxyz'
      ** Upper and lower case characters for conversion
      *
      /SPACE 2
     IDMAP2
     I**************DMAPID                      DMAP3                                         118481
     I              SRCDTA                      DMAP3                                         118481
      ** Rename field on CASmf mapid file to avoid conflict with filename
      *
      /EJECT
      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_init       : Initialise program and session               *
      *  sr_detl       : Detail processing                            *
      *  sr_selec      : Display selection screen                     *
      *  sr_add        : Add new details                              *
      *  sr_psfl       : Process subfile selection                    *
      *  sr_check      : Check subfile action                         *
      *  sr_vald       : Validate input                               *
      *  sr_actn       : Determine action code                        *
      *  sr_enquire    : Enquire on session details                   *
      *  sr_amend      : Amend session details                        *
      *  sr_delete     : Delete session details                       *
      *  *PSSR         : Progam exception error routine               *
      *****************************************************************
      /EJECT
      *
      ** Set up copyright parameter
     C                   movea     cpy@          cpy2@            80
      *
      ** Push routine
     C                   z-add     1             Q
     C                   movel     'mainline'    @STK(Q)
      *
      ** Perform initial process
     C                   exsr      sr_init
      *
      ** Perform detail process
     C                   exsr      sr_detl
      *
      ** Shutdown and return
     C                   seton                                        LR
      /EJECT
      **********************************************************************
      * sr_detl        : Detail processing                                 *
      * -------                                                            *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : sr_selec                                          *
      *                                                                    *
      **********************************************************************
      *
     C     sr_detl       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_detl'     @STK(Q)
      *
      ** Write headings
     C                   write     ms8020f1
      *
      ** Display details and process until F3 or F12 (at top level) pressed
     C     *inkc         doueq     *on
     C     *inkl         oreq      *on
     C                   exsr      sr_selec
     C                   enddo
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_selec       : Display selection screen                          *
      * --------                                                           *
      *                                                                    *
      * Called by      : sr_detl                                           *
      *                                                                    *
      * Calls          : MCC8020M - Get job details                        *
      *                  sr_add                                            *
      *                  sr_psfl                                           *
      *                                                                    *
      **********************************************************************
      *
     C     sr_selec      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_selec'    @STK(Q)
      *
      ** Initialise subfile
     C                   movel     'Y'           w@details         1
     C                   setoff                                       2021
     C                   write     ms8020f4
      *
      ** Access first record on file
     C     *loval        setll     msmapid0
     C                   read      msmapid0                               50
      *
      ** If no record found display 'no details...'
     C     *in50         ifeq      *on
     C                   write     ms8020f6
     C                   seton                                        21
     C                   movel     'N'           w@details
     C                   else
     C                   seton                                        2021
     C                   z-add     1             w@rrn             5 0
     C                   endif
      *
      ** Process ROLLUP
     C     *in23         doueq     *off
      *
      ** RRN of first record on page
     C                   z-add     w@rrn         DSPREC
     C                   z-add     0             w@count           3 0
      *
      ** While records exist, fill subfile page
     C     *in50         doweq     *off
     C     w@count       andlt     16
      *
      ** Get status of current job
     C                   callb     'MSC8020M'
     C                   parm      w@cjob        p@cjob           26
     C                   parm      *blank        w@stat           10
      *
      ** Set up subfile fields
     C                   clear                   ms8020f3
     C                   movel     MCMAPI        s3mapi
     C                   movel     w@stat        S3stat
     C     MCIPOP        ifeq      'I'
     C                   movel(p)  'Input'       s3ipop
     C                   else
     C                   movel     'Output'      s3ipop
     C                   endif
      *
     C                   write     ms8020f3
     C                   add       1             w@rrn
     C                   add       1             w@count
      *
     C                   read      msmapid0                               50
     C                   enddo
      *
      ** Display subfile until command key or rollup pressed
     C     *inkc         doueq     *on
     C     *inke         oreq      *on
     C     *inki         oreq      *on
     C     *inkl         oreq      *on
     C     *in23         oreq      *on
      *
      ** if EoF set SFLEND
     C     *in50         ifeq      *on
     C                   seton                                        22
     C                   endif
      *
      ** Write message subfile
     C                   write     sflmsgc
      *
      ** Display subfile and get response
     C                   write     ms8020f2
     C                   exfmt     ms8020f4
      *
      ** Clear program message queue and reset subfile
     C                   call      'ZM1002'
     C                   setoff                                       22
     C                   z-add     w@lstrn       DSPREC
     C                   write     sflmsgc
      *
      ** Process user input:
     C                   select
      *
      ** - F9=Add (force F5=Refresh on return)
     C     *inki         wheneq    *on
     C                   exsr      sr_add
     C                   movel     *off          *inkl
     C                   movel     *on           *inke
      *
      ** - Enter=Process subfile selections (as long as there's some data)
     C     *inkc         wheneq    *off
     C     *inke         andeq     *off
     C     *inkl         andeq     *off
     C     *in23         andeq     *off
     C     w@details     andeq     'Y'
     C                   exsr      sr_psfl
     C                   movel     *off          *inkl
      *
     C                   endsl
     C                   enddo
     C                   enddo
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_add         : Add new details                                   *
      * ------                                                             *
      *                                                                    *
      * Called by      : sr_selec                                          *
      *                                                                    *
      * Calls          : sr_vald                                           *
      *                                                                    *
      **********************************************************************
      *
     C     sr_add        begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_add'      @STK(Q)
      *
      ** Check authority to add (Insert)
     C     'I'           scan      w@acts                                 61
     C     *in61         ifeq      *off
     C                   movel     'MEM6017'     p@msgid
     C                   call      'ZM1001'      p@snmsg
     C                   else
      *
      ** Initialise work fields
     C                   clear                   ms8020f5
     C                   seton                                        72
     C                   setoff                                       7071
     C                   movel     'I'           s5actn
     C                   movel     LIBR          s5sytm
      *
      ** Get user input until valid details entered or F3, F12
     C                   exfmt     ms8020f5
     C                   exsr      sr_vald
     C     *inkc         doweq     *off
     C     *inkl         andeq     *off
     C     w@valid       andeq     'N'
     C                   exfmt     ms8020f5
     C                   exsr      sr_vald
     C                   enddo
     C                   call      'ZM1002'
      *
      ** If not F3, F12 add record
     C     *inkc         ifeq      *off
     C     *inkl         andeq     *off
     C                   clear                   msmapid0
     C                   movel     LIBR          MCSYTM
     C                   movel     s5mapi        MCMAPI
     C                   movel     s5ipop        MCIPOP
     C                   movel     s5stup        MCSTUP
     C                   movel     s5otyp        MCOTYP
     C                   z-add     s5wait        MCWAIT
     C                   movel     s5accp        MCACCP
     C                   movel     s5xpgm        MCXPGM
     C                   movel     s5jnam        MCJNAM
     C                   movel     ##JOB         MCUJOB
     C                   movel     ##USR         MCUUSR
     C                   time                    MCATIM
     C                   movel     BJMRDT        MCARDT
     C                   movel     'I'           MCAACT
     C                   z-add     BJRDNB        MCRDNB
     C                   write     msmapid0
     C                   endif
      *
      ** (not authorised)
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_psfl        : Process subfile                                   *
      * -------                                                            *
      *                                                                    *
      * Called by      : sr_selec                                          *
      *                                                                    *
      * Calls          : sr_enquire                                        *
      *                  sr_delete                                         *
      *                  sr_amend                                          *
      *                                                                    *
      **********************************************************************
      *
     C     sr_psfl       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_psfl'     @STK(Q)
      *
      ** Read each subfile record for which entry has been made until F3
      ** is pressed
     C     *in60         doueq     *on
     C     *inkc         oreq      *on
      *
     C                   readc     ms8020f3                               60
     C     *in60         doweq     *off
     C     s3actn        andeq     *blank
     C                   update    ms8020f3
     C                   readc     ms8020f3                               60
     C                   enddo
      *
      ** Process selection
     C     *in60         ifeq      *off
      *
      ** Check action: if invalid inform user and stop
     C                   exsr      sr_check
     C     w@check       ifeq      'N'
     C                   seton                                        243060
     C                   else
      *
      ** Else process action (action subroutines should clear s3actn if
      ** successful, otherwise they should switch on *in30)
     C     s3actn        caseq     'E'           sr_enquire
     C     s3actn        caseq     'D'           sr_delete
     C     s3actn        caseq     'A'           sr_amend
     C     s3actn        caseq     'T'           sr_toggle
     C                   endcs
     C                   movel     *off          *inkl
     C                   endif
      *
     C                   update    ms8020f3
     C                   setoff                                       243035
      *
     C                   endif
     C                   enddo
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_check       : Check subfile action                              *
      * -------                                                            *
      *                                                                    *
      * Called by      : sr_psfl                                           *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_check      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_check'    @STK(Q)
      *
      ** Set check flag
     C                   movel     'Y'           w@check           1
      *
      ** Check valid action code
     C     s3actn        scan      'EDAT'                                 61
     C     *in61         ifeq      *off
     C                   movel     'MEM6006'     p@msgid
     C                   call      'ZM1001'      p@snmsg
     C                   movel     'N'           w@check
     C                   else
      *
      ** If valid, check user authorised
     C     s3actn        scan      w@acts                                 61
     C     *in61         ifeq      *off
     C                   movel     'MEM6013'     p@msgid
     C                   call      'ZM1001'      p@snmsg
     C                   movel     'N'           w@check
     C                   else
      *
      ** If status deleted no further action permitted
     C     s3stat        ifeq      'DELETED'
     C                   movel     'MEM6014'     p@msgid
     C                   call      'ZM1001'      p@snmsg
     C                   seton                                        35
     C                   movel     'N'           w@check
     C                   else
      *
      ** If action A,D,T get up-to-date status and check action valid
     C     s3actn        ifeq      'A'
     C     s3actn        oreq      'D'
     C     s3actn        oreq      'T'
      *
     C     s3mapi        chain(n)  msmapid0                           89
     C                   callb     'MSC8020M'
     C                   parm      w@cjob        p@cjob
     C                   parm      *blank        w@stat           10
      *
      **  - Status has changed (prevent toggle)
     C     s3stat        ifne      w@stat
     C                   movel     w@stat        s3stat
     C                   movel     'MEM6015'     p@msgid
     C                   call      'ZM1001'      p@snmsg
     C     s3actn        ifeq      'T'
     C                   movel     'N'           w@check
     C                   endif
     C                   endif
      *                                        7
      **  - Status not *OUTQ: unable to amend or delete
     C     s3stat        ifne      '*OUTQ'
     C     s3actn        andne     'T'
     C                   movel     'MEM6016'     p@msgid
     C                   call      'ZM1001'      p@snmsg
     C                   movel     'N'           w@check
     C                   endif
      *
     C                   endif
      *
     C                   endif
     C                   endif
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_vald        : Validate input                                    *
      * -------                                                            *
      *                                                                    *
      * Called by      : sr_add                                            *
      *                  sr_amend                                          *
      *                                                                    *
      * Calls          : sr_actn                                           *
      *                                                                    *
      **********************************************************************
      *
     C     sr_vald       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_vald'     @STK(Q)
      *
      ** Initialise validation work fields
     C                   movel     'Y'           w@valid           1
     C                   movea     '0000000'     *in(80)
     C                   call      'ZM1002'
      *
      ** Check L-MAPID exists on CASmf database
     C                   exsr      sr_actn
      *
      ** Check I/O
     C     s5ipop        scan      'IO'                                   61
     C     *in61         ifeq      *off
     C                   movel     'MEM6007'     p@msgid
     C                   call      'ZM1001'      p@snmsg
     C                   movel     'N'           w@valid
     C                   movel     *on           *in81
     C                   endif
      *
      ** Check start up option
     C     s5stup        scan      'AM'                                   61
     C     *in61         ifeq      *off
     C                   movel     'MEM6008'     p@msgid
     C                   call      'ZM1001'      p@snmsg
     C                   movel     'N'           w@valid
     C                   movel     *on           *in82
     C                   endif
      *
      ** Check open type
     C     s5otyp        scan      'FW'                                   61
     C     *in61         ifeq      *off
     C                   movel     'MEM6009'     p@msgid
     C                   call      'ZM1001'      p@snmsg
     C                   movel     'N'           w@valid
     C                   movel     *on           *in83
     C                   endif
      *
      ** Check wait time for option W (wait)
     C     s5otyp        ifeq      'W'
     C     s5wait        ifgt      99999
     C     s5wait        orlt      1
     C                   movel     'MEM6010'     p@msgid
     C                   call      'ZM1001'      p@snmsg
     C                   movel     'N'           w@valid
     C                   movel     *on           *in84
     C                   endif
     C                   endif
      *
      ** Check wait time for option F (force)
     C     s5otyp        ifeq      'F'
     C     s5wait        andne     0
     C                   movel     'MEM6011'     p@msgid
     C                   call      'ZM1001'      p@snmsg
     C                   movel     'N'           w@valid
     C                   movel     *on           *in84
     C                   endif
      *
      ** Check prefix correct for amendment
     C     s5actn        ifeq      'A'
     C     s5sytm        andne     LIBR
     C                   movel     'MEM6012'     p@msgid
     C                   call      'ZM1001'      p@snmsg
     C                   movel     'N'           w@valid
     C                   endif
      *
      ** If invalid display message details
     C                   write     sflmsgc
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_actn        : Determine action code                             *
      * -------                                                            *
      *                                                                    *
      * Called by      : sr_vald                                           *
      *                                                                    *
      * Calls          : MS8021M - CASmf session selection                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_actn       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_actn'     @STK(Q)
      *
      ** Initialise array of L-MAPIDs
     C                   clear                   arr1
     C                   z-add     1             t                 3 0
     C                   z-add     1             x                 3 0
      *
      ** Read L-MAPID details from CASmf file and build array. MAPID
      ** detail records begin 'l-mapid', which may be in upper or
      ** lower case, so convert to upper case before testing.
     C     t             setll     dmap2
     C                   read      dmap2                                  51
     C     *in51         doweq     *off
     C     dmap3         ifne      *blanks
     C                   z-add     1             t
     C                   move      *blanks       w#recl           50
     C     ' '           check     dmap3:t       s                 3 0
     C     ' '           scan      dmap3:s       t
     C     t             sub       s             len               3 0
     C     len           subst(P)  dmap3:s       fld1             26
     C     @UC:@LC       xlate     fld1          fld1
     C     fld1          ifeq      'l_mapid'
     C     ' '           check     dmap3:t       s
     C     ' '           checkr    dmap3         t
     C                   eval      len = (t - s) + 1
     C     len           subst(P)  dmap3:s       arr1(x)          26
     C                   add       1             x
     C                   endif
     C                   endif
     C                   read      dmap2                                  51
     C                   enddo
      *
      ** Validate user input
     C     s5mapi        ifeq      *blanks
      *
      ** The L-MAPID must be entered
     C                   movel     'MEM6018'     p@msgid
     C                   call      'ZM1001'      p@snmsg
     C                   movel     'N'           w@valid
     C                   movel     *on           *in80
     C                   else
      *
      ** Check for '?' in input field; if present execute L-MAPID
      ** selection processing.
     C     '?'           scan      s5mapi                                 62
     C     *in62         ifeq      *on
     C     *inkc         andeq     *off
     C     *inkl         andeq     *off
     C                   callb     'MS8021M'
     C                   parm                    arr1
     C                   parm                    s5mapi
     C                   parm                    retcde            2
     C                   endif
     C                   endif
      *
      ** No selection made
     C     '?'           scan      s5mapi                                 62
     C     *in62         ifeq      *on
     C                   movel     'MEM6019'     p@msgid
     C                   call      'ZM1001'      p@snmsg
     C                   movel     'N'           w@valid
     C                   movel     *on           *in80
     C                   endif
      *
     C                   z-add     1             x
     C     s5mapi        lookup    arr1(x)                                53
     C     *in53         ifeq      *off
     C     s5actn        ifeq      'I'
      *
      ** L-MAPID does not exist (for Insert)
     C                   movel     'MEM6023'     p@msgid
     C                   else
      *
      ** L-MAPID no longer exists (for Amend)
     C                   movel     'MEM6014'     p@msgid
     C                   endif
     C                   call      'ZM1001'      p@snmsg
     C                   movel     'N'           w@valid
     C                   movel     *on           *in80
     C                   else
      *
      ** If valid L-MAPID selected, check it is not already in use
     C     s5actn        ifeq      'I'
     C     s5mapi        setll     msmapid0                               65
     C     *in65         ifeq      *on
     C                   movel     'MEM6021'     p@msgid
     C                   call      'ZM1001'      p@snmsg
     C                   movel     'N'           w@valid
     C                   movel     *on           *in80
     C                   endif
     C                   endif
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_enquire     : Enquire on existing detail                        *
      * ----------                                                         *
      *                                                                    *
      * Called by      : sr_psfl                                           *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_enquire    begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_enquire'  @STK(Q)
      *
      ** Reaccess details
     C     s3mapi        chain(n)  msmapid0                           89
      *
      ** Initialise work fields
     C                   clear                   ms8020f5
     C                   seton                                        707172
     C                   setoff                                       73
     C                   movel     'E'           s5actn
      *
      ** Set up screen details
     C                   movel     MCMAPI        s5mapi
     C                   movel     MCIPOP        s5ipop
     C                   movel     MCSTUP        s5stup
     C                   movel     MCOTYP        s5otyp
     C                   movel     MCACCP        s5accp
     C                   movel     MCXPGM        s5xpgm
     C                   movel     MCJNAM        s5jnam
     C                   movel     MCSYTM        s5sytm
     C                   z-add     MCWAIT        s5wait
     C     MCCJOB        ifne      *blanks
     C                   movel(p)  MCCNUM        s5fulj
     C     s5fulj        cat       '/':0         s5fulj
     C     s5fulj        cat       MCCUSR:0      s5fulj
     C     s5fulj        cat       '/':0         s5fulj
     C     s5fulj        cat       MCCJOB:0      s5fulj
     C                   seton                                        73
     C                   end
      *
      ** Display details
     C                   exfmt     ms8020f5
      *
      ** Reset subfile action code
     C                   clear                   s3actn
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_amend       : Amend existing detail                             *
      * --------                                                           *
      *                                                                    *
      * Called by      : sr_psfl                                           *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_amend      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_amend'    @STK(Q)
      *
      ** Initialise work fields
     C                   clear                   ms8020f5
     C                   seton                                        7072
     C                   setoff                                       71
     C                   movel     'A'           s5actn
      *
      ** Reaccess details
     C     s3mapi        chain(n)  msmapid0                           89
      *
      ** Set up screen details
     C                   movel     MCMAPI        s5mapi
     C                   movel     MCIPOP        s5ipop
     C                   movel     MCSTUP        s5stup
     C                   movel     MCOTYP        s5otyp
     C                   movel     MCACCP        s5accp
     C                   movel     MCXPGM        s5xpgm
     C                   movel     MCJNAM        s5jnam
     C                   movel     MCSYTM        s5sytm
     C                   z-add     MCWAIT        s5wait
     C     MCSYTM        ifne      LIBR
     C                   setoff                                       72
     C                   endif
      *
      ** Get user input until valid details entered or F3, F12
     C                   exfmt     ms8020f5
     C                   exsr      sr_vald
     C     *inkc         doweq     *off
     C     *inkl         andeq     *off
     C     w@valid       andeq     'N'
     C                   exfmt     ms8020f5
     C                   exsr      sr_vald
     C                   enddo
     C                   call      'ZM1002'
      *
      ** If not F3, F12 update record
     C     *inkc         ifeq      *off
     C     *inkl         andeq     *off
     C     s5mapi        chain     msmapid0                           89
     C                   movel     s5mapi        MCMAPI
     C                   movel     s5ipop        MCIPOP
     C                   movel     s5stup        MCSTUP
     C                   movel     s5otyp        MCOTYP
     C                   z-add     s5wait        MCWAIT
     C                   movel     s5accp        MCACCP
     C                   movel     s5xpgm        MCXPGM
     C                   movel     s5jnam        MCJNAM
     C                   movel     s5sytm        MCSYTM
     C                   movel     ##JOB         MCUJOB
     C                   movel     ##USR         MCUUSR
     C                   time                    MCATIM
     C                   movel     BJMRDT        MCARDT
     C                   movel     'A'           MCAACT
     C                   z-add     BJRDNB        MCRDNB
     C                   update    msmapid0
     C                   endif
      *
      ** Reset subfile action code
     C                   clear                   s3actn
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_delete      : Delete existing detail                            *
      * ---------                                                          *
      *                                                                    *
      * Called by      : sr_psfl                                           *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_delete     begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_delete'   @STK(Q)
      *
      ** Access details and if found, delete
     C     s3mapi        chain     msmapid0                           89
     C     *in89         ifeq      *off
     C                   delete    msmapid0
     C                   endif
      *
      ** Update subfile fields
     C                   movel     'DELETED'     s3stat
     C                   seton                                        35
      *
      ** Reset subfile action code
     C                   clear                   s3actn
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_toggle      : Toggle session state                              *
      * ---------
      *                                                                    *
      * Called by      : sr_psfl                                           *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_toggle     begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_toggle'   @STK(Q)
      *
      ** If current state is *OUTQ, start session
     C     s3stat        ifeq      '*OUTQ'
     C                   call      'MS8030P'
     C                   parm      '*STARTUP'    p@oper            9
     C                   parm      s3mapi        p@lmapid         26
     C                   parm      '*MANUAL'     p@mode            7
     C                   parm      *BLANKS       p@type            7
     C                   else
      *
      ** Otherwise end session
     C                   call      'MS8030P'
     C                   parm      '*SHUTDOWN'   p@oper            9
     C                   parm      s3mapi        p@lmapid         26
     C                   parm      *BLANKS       p@mode            7
     C****************** parm      '*ASYNCH'     p@type            7                          119419
     C                   parm      '*SYNCH'      p@type            7                          119419
     C                   endif
      *
      ** Reset subfile action code
     C                   clear                   s3actn
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_init        : Initialise program                                *
      * -------                                                            *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : ZVRAT                                             *
      *                  AOBANKR0                                          *
      *                                                                    *
      **********************************************************************
      *
     C     sr_init       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_init'     @STK(Q)
      *
      ** Definitions
     C     p@snmsg       plist
     C                   parm                    p@msgid          10
     C                   parm                    p@msdta          78
      *
     C                   movel     'MS8020M'     PGMQ
     C                   clear                   MSGKEY
     C                   movel     'EADT'        s4acts
      *
      ** Access SDSTAT for system prefix
     C     *dtaara       define                  sdstat
     C                   in        sdstat
      *
      ** Access ZMUSER for users branch
     C     *dtaara       define                  zmuser
     C                   in        zmuser
      *
      ** Get valid action codes for user
     C                   call      'ZVRAT'
     C                   parm                    DBRN
     C                   parm      *blank        w@acts            6
     C                   parm                    w@zrc             1 0
      *
      ** Access bank details
     C                   call      'AOBANKR0'
     C                   parm      *blanks       p@rtcd            7
     C                   parm      '*FIRST'      p@optn            7
     C     sdbank        parm      *blanks       dsfdy
      *
      ** If the Access Object returns an error code, database error
     C     p@rtcd        ifne      *blank
     C                   movel     'AOBANKR0'    w0file
     C                   movel     'bank details'w0key
     C                   z-add     01            w0ernb
     C                   movel     'MEM5003'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   exsr      srerr
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
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
      *
      ********************************************************************
      /COPY MSCPYSRC,SRERRC
**CTDATA cpy@
(c) Finastra International Limited 2001
