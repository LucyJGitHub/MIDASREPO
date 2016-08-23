     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MS Midas/SWIFT Meridian comms id maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Midas SWIFT                                          *
      *                                                               *
      *  MS6120M - Midas/SWIFT Meridian communications ID maintenance *
      *                                                               *
      *  Function:  This program is used to maintain the file of      *
      *             comms IDs for a particular Midas system.          *
      *                                                               *
      *  Called By: MSC6120 - Midas/Swift Meridian comms ID maintenance
      *                                                               *
      *  Calls    : MSC6120M                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSW038             Date 13Apr05               *
      *  Prev Amend No. BUG2843            Date 28May04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW025             Date 15Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW017 *CREATE     Date 11Feb99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW038 - Change to allow communication with MMM using        *
      *           MQSeries instead of data queues.  Here we force     *
      *           the maintenance screen to show MQSeries information,*
      *           and also add the ability to capture the queue       *
      *           manager name, so that a non-default manager may be  *
      *           used.                                               *
      *  BUG2843- Called MS6130P instead of MS8030P to enable toggle. *
      *  CSW025 - Midas Message Manager                               *
      *           - Extract messages to Meridian Link via Data Queue  *
      *  CSW017 - Midas/Swift Meridian interface                      *
      *                                                               *
      *****************************************************************
      /EJECT
     FMS6120DF  CF   E             workstn
     F                                     sfile(ms6120f3:w@rrn)
     F                                     infds(d@infds)
     FMSMCIDL0  UF A E           K disk    infsr(srfile)
      /EJECT
      /COPY MSCPYSRC,SRERRD
     D*cpy@************S             80    dim(1) ctdata perrcd(1)              CSW025
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
      ** --- Start of fields used by access programs -------------------------- CSW025
     D @RtCd           S              7A                                        CSW025
      ** Return code                                                            CSW025
     D @Optn           S              7A                                        CSW025
      ** Option                                                                 CSW025
     D @SARD           S              6A                                        CSW025
      ** Switchable feature ID (for AOSARDR0)                                   CSW025
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CSW025
      ** External DS for SAR details                                            CSW025
      ** --- End of fields used by access programs ---------------------------- CSW025
      *                                                                         CSW025
      /EJECT
      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_init       : Initialise program and session               *
      *  sr_setdsp     : Set display for MQSeries or Data Queue       *         CSW025
      *  sr_detl       : Detail processing                            *
      *  sr_selec      : Display selection screen                     *
      *  sr_add        : Add new details                              *
      *  sr_psfl       : Process subfile selection                    *
      *  sr_check      : Check subfile action                         *
      *  sr_vald       : Validate input                               *
      *  sr_enquire    : Enquire on session details                   *
      *  sr_amend      : Amend session details                        *
      *  sr_delete     : Delete session details                       *
      *  *PSSR         : Progam exception error routine               *
      *****************************************************************
      /EJECT
      *
      ***Set*up*copyright parameter                                             CSW025
     C*******************movea     cpy@          cpy2@            80            CSW025
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
     C                   write     ms6120f1
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
      * Calls          : MCC6120M - Get job details                        *
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
     C                   write     ms6120f4
      *
      ** Access first record on file
     C     *loval        setll     msmcidd0
     C                   read      msmcidd0                               50
      *
      ** If no record found display 'no details...'
     C     *in50         ifeq      *on
     C                   write     ms6120f6
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
     C                   callb     'MSC6120M'
     C                   parm      w@cjob        p@cjob           26
     C                   parm      *blank        w@stat           10
      *
      ** Set up subfile fields
     C                   clear                   ms6120f3
     C                   movel     MCMCID        s3mcid
     C                   movel     w@stat        S3stat
     C     MCIPOP        ifeq      'I'
     C                   movel(p)  'Input'       s3ipop
     C                   else
     C                   movel     'Output'      s3ipop
     C                   endif
      *
     C                   write     ms6120f3
     C                   add       1             w@rrn
     C                   add       1             w@count
      *
     C                   read      msmcidd0                               50
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
     C                   write     ms6120f2
     C                   exfmt     ms6120f4
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
     C                   clear                   ms6120f5
     C                   seton                                        72
     C                   setoff                                       7071
     C                   exsr      sr_setdsp                                    CSW025
     C                   movel     'I'           s5actn
     C                   movel     LIBR          s5sytm
      *
      ** Get user input until valid details entered or F3, F12
     C                   exfmt     ms6120f5
     C                   exsr      sr_vald
     C     *inkc         doweq     *off
     C     *inkl         andeq     *off
     C     w@valid       andeq     'N'
     C                   exfmt     ms6120f5
     C                   exsr      sr_vald
     C                   enddo
     C                   call      'ZM1002'
      *
      ** If not F3, F12 add record
     C     *inkc         ifeq      *off
     C     *inkl         andeq     *off
     C                   clear                   msmcidd0
     C                   movel     LIBR          MCSYTM
     C                   movel     s5mcid        MCMCID
      *                                                                         CSW025
     C*******************movel     s5mqqn        MCMQQN                         CSW025
     C                   IF        CSW025 = 'Y'                                 CSW025
     C                               AND CSW038 = 'N'                           CSW038
     C                   movel     s5dtqn        MCMQQN                         CSW025
     C                   ELSE                                                   CSW025
     C                   movel     s5mqmn        MCMQMN                         CSW038
     C                   movel     s5mqqn        MCMQQN                         CSW025
     C                   ENDIF                                                  CSW025
      *                                                                         CSW025
     C                   movel     s5ipop        MCIPOP
     C                   movel     s5stup        MCSTUP
     C                   movel     s5accp        MCACCP
     C                   movel     s5xpgm        MCXPGM
     C                   movel     s5jnam        MCJNAM
     C                   movel     ##JOB         MCUJOB
     C                   movel     ##USR         MCUUSR
     C                   time                    MCATIM
     C                   movel     BJMRDT        MCARDT
     C                   movel     'I'           MCAACT
     C                   z-add     BJRDNB        MCRDNB
     C                   write     msmcidd0
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
     C                   readc     ms6120f3                               60
     C     *in60         doweq     *off
     C     s3actn        andeq     *blank
     C                   update    ms6120f3
     C                   readc     ms6120f3                               60
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
     C                   update    ms6120f3
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
     C     s3mcid        chain(n)  msmcidd0                           89
     C                   callb     'MSC6120M'
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
      ** Validate meridian communications ID
     C     s5mcid        ifeq      *blanks
     C*******************movel     'MEM6018'     p@msgid                        CSW025
     C                   movel     'MEM6026'     p@msgid                        CSW025
     C                   call      'ZM1001'      p@snmsg
     C                   movel     'N'           w@valid
     C                   movel     *on           *in80
     C                   endif
      *
      ***Validate*MQ*series queue name                                          CSW025
     C*****s5mqqn********ifeq      *blanks                                      CSW025
     C*******************movel     'MEM6018'     p@msgid                        CSW025
     C*******************call      'ZM1001'      p@snmsg                        CSW025
     C*******************movel     'N'           w@valid                        CSW025
     C*******************movel     *on           *in81                          CSW025
     C*******************endif                                                  CSW025
      ** Validate queue name - MQ series queue or Data Queue depending upon     CSW025
      **  Switchable Feature value.                                             CSW025
     C                   IF        CSW025 = 'Y'                                 CSW025
     C                               AND CSW038 = 'N'                           CSW038
     C     s5dtqn        ifeq      *blanks                                      CSW025
     C                   movel     'MEM6024'     p@msgid                        CSW025
     C                   call      'ZM1001'      p@snmsg                        CSW025
     C                   movel     'N'           w@valid                        CSW025
     C                   movel     *on           *in81                          CSW025
     C                   endif                                                  CSW025
     C                   ELSE                                                   CSW025
     C     s5mqqn        ifeq      *blanks                                      CSW025
     C                   movel     'MEM6025'     p@msgid                        CSW025
     C                   call      'ZM1001'      p@snmsg                        CSW025
     C                   movel     'N'           w@valid                        CSW025
     C                   movel     *on           *in81                          CSW025
     C                   endif                                                  CSW025
     C                   ENDIF                                                  CSW025
      *
      ** Check I/O
     C     s5ipop        scan      'IO'                                   61
     C     *in61         ifeq      *off
     C*******************movel     'MEM6007'     p@msgid                        CSW025
     C                   movel     'MEM6027'     p@msgid                        CSW025
     C                   call      'ZM1001'      p@snmsg
     C                   movel     'N'           w@valid
     C                   movel     *on           *in82
     C                   endif
      *
      ** Check start up option
     C     s5stup        scan      'AM'                                   61
     C     *in61         ifeq      *off
     C                   movel     'MEM6008'     p@msgid
     C                   call      'ZM1001'      p@snmsg
     C                   movel     'N'           w@valid
     C                   movel     *on           *in83
     C                   endif
      *
      ** Check prefix correct for amendment
     C     s5actn        ifeq      'A'
     C     s5sytm        andne     LIBR
     C*******************movel     'MEM6012'     p@msgid                        CSW025
     C                   movel     'MEM6028'     p@msgid                        CSW025
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
     C     s3mcid        chain(n)  msmcidd0                           89
      *
      ** Initialise work fields
     C                   clear                   ms6120f5
     C                   seton                                        707172
     C                   setoff                                       73
     C                   exsr      sr_setdsp                                    CSW025
     C                   movel     'E'           s5actn
      *
      ** Set up screen details
     C                   movel     MCMCID        s5mcid
      *                                                                         CSW025
     C*******************movel     MCMQQN        s5mqqn                         CSW025
     C                   IF        CSW025 = 'Y'                                 CSW025
     C                               AND CSW038 = 'N'                           CSW038
     C                   movel     MCMQQN        s5dtqn                         CSW025
     C                   ELSE                                                   CSW025
     C                   movel     MCMQMN        s5mqmn                         CSW038
     C                   movel     MCMQQN        s5mqqn                         CSW025
     C                   ENDIF                                                  CSW025
      *                                                                         CSW025
     C                   movel     MCIPOP        s5ipop
     C                   movel     MCSTUP        s5stup
     C                   movel     MCACCP        s5accp
     C                   movel     MCXPGM        s5xpgm
     C                   movel     MCJNAM        s5jnam
     C                   movel     MCSYTM        s5sytm
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
     C                   exfmt     ms6120f5
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
     C                   clear                   ms6120f5
     C                   seton                                        7072
     C                   setoff                                       71
     C                   exsr      sr_setdsp                                    CSW025
     C                   movel     'A'           s5actn
      *
      ** Reaccess details
     C     s3mcid        chain(n)  msmcidd0                           89
      *
      ** Set up screen details
     C                   movel     MCMCID        s5mcid
      *                                                                         CSW025
     C*******************movel     MCMQQN        s5mqqn                         CSW025
     C                   IF        CSW025 = 'Y'                                 CSW025
     C                               AND CSW038 = 'N'                           CSW038
     C                   movel     MCMQQN        s5dtqn                         CSW025
     C                   ELSE                                                   CSW025
     C                   movel     MCMQMN        s5mqmn                         CSW038
     C                   movel     MCMQQN        s5mqqn                         CSW025
     C                   ENDIF                                                  CSW025
      *                                                                         CSW025
     C                   movel     MCIPOP        s5ipop
     C                   movel     MCSTUP        s5stup
     C                   movel     MCACCP        s5accp
     C                   movel     MCXPGM        s5xpgm
     C                   movel     MCJNAM        s5jnam
     C                   movel     MCSYTM        s5sytm
     C     MCSYTM        ifne      LIBR
     C                   setoff                                       72
     C                   endif
      *
      ** Get user input until valid details entered or F3, F12
     C                   exfmt     ms6120f5
     C                   exsr      sr_vald
     C     *inkc         doweq     *off
     C     *inkl         andeq     *off
     C     w@valid       andeq     'N'
     C                   exfmt     ms6120f5
     C                   exsr      sr_vald
     C                   enddo
     C                   call      'ZM1002'
      *
      ** If not F3, F12 update record
     C     *inkc         ifeq      *off
     C     *inkl         andeq     *off
     C     s5mcid        chain     msmcidd0                           89
     C                   movel     s5mcid        MCMCID
      *                                                                         CSW025
     C*******************movel     s5mqqn        MCMQQN                         CSW025
     C                   IF        CSW025 = 'Y'                                 CSW025
     C                               AND CSW038 = 'N'                           CSW038
     C                   movel     s5dtqn        MCMQQN                         CSW025
     C                   ELSE                                                   CSW025
     C                   movel     s5mqmn        MCMQMN                         CSW038
     C                   movel     s5mqqn        MCMQQN                         CSW025
     C                   ENDIF                                                  CSW025
      *                                                                         CSW025
     C                   movel     s5ipop        MCIPOP
     C                   movel     s5stup        MCSTUP
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
     C                   update    msmcidd0
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
     C     s3mcid        chain     msmcidd0                           89
     C     *in89         ifeq      *off
     C                   delete    msmcidd0
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
     C**********         call      'MS8030P'                                                 BUG2843
     C                   call      'MS6130P'                                                 BUG2843
     C                   parm      '*STARTUP'    p@oper            9
     C                   parm      s3mcid        p@mcid           26
     C                   parm      '*MANUAL'     p@mode            7
     C                   parm      *BLANKS       p@type            7
     C                   else
      *
      ** Otherwise end session
     C**********         call      'MS8030P'                                                 BUG2843
     C                   call      'MS6130P'                                                 BUG2843
     C                   parm      '*SHUTDOWN'   p@oper            9
     C                   parm      s3mcid        p@mcid           26
     C                   parm      *BLANKS       p@mode            7
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
      *                  AOSARDR0                                          *
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
     C                   movel     'MS6120M'     PGMQ
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
      *                                                                         CSW025
      ** Check if the Data Queue export feature is present.                     CSW025
      **  If not, export is via an MQSeries queue.                              CSW025
     C                   CALLB     'AOSARDR0'                                   CSW025
     C                   PARM      *BLANKS       @RTCD                          CSW025
     C                   PARM      '*VERIFY'     @OPTN                          CSW025
     C                   PARM      'CSW025'      @SARD                          CSW025
     C     SCSARD        PARM      SCSARD        DSFDY                          CSW025
     C     @RTCD         IFEQ      *BLANKS                                      CSW025
     C                   MOVE      'Y'           CSW025            1            CSW025
     C                   ELSE                                                   CSW025
     C                   MOVE      'N'           CSW025                         CSW025
     C                   ENDIF                                                  CSW025
 
      ** ... or rather, messages are sent to MMM via data queues unless                       CSW038
      **  CSW038 is on, in which case MQSeries queues are used.                               CSW038
     C                   if        CSW025 = 'Y'                                               CSW038
                                                                                              CSW038
     C                   CALLB     'AOSARDR0'                                                 CSW038
     C                   PARM      *BLANKS       @RTCD                                        CSW038
     C                   PARM      '*VERIFY'     @OPTN                                        CSW038
     C                   PARM      'CSW038'      @SARD                                        CSW038
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW038
     C     @RTCD         IFEQ      *BLANKS                                                    CSW038
     C                   MOVE      'Y'           CSW038            1                          CSW038
     C                   ELSE                                                                 CSW038
     C                   MOVE      'N'           CSW038                                       CSW038
     C                   ENDIF                                                                CSW038
                                                                                              CSW038
     C                   endif                                                                CSW038
 
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT                                                                    CSW025
      **********************************************************************    CSW025
      * sr_setdsp      : Set display for MQSeries or Data Queue            *    CSW025
      * ---------                                                          *    CSW025
      *                                                                    *    CSW025
      * Called by      : sr_init                                           *    CSW025
      *                                                                    *    CSW025
      * Calls          : none                                              *    CSW025
      *                                                                    *    CSW025
      **********************************************************************    CSW025
      *                                                                         CSW025
     C     sr_setdsp     begsr                                                  CSW025
      *                                                                         CSW025
      ** Push subroutine                                                        CSW025
     C                   add       1             Q                              CSW025
     C                   movel     'sr_setdsp'   @STK(Q)                        CSW025
      *                                                                         CSW025
      ** Set the display conditioning indicator according to whether            CSW025
      **  the Data Queue export feature is present or not.                      CSW025
     C     CSW025        IFEQ      'Y'                                          CSW025
     C     CSW038        ANDEQ     'N'                                          CSW038
     C                   SETON                                        74        CSW025
     C                   ELSE                                                   CSW025
     C                   SETOFF                                       74        CSW025
     C                   ENDIF                                                  CSW025
      *                                                                         CSW025
      ** Pop subroutine                                                         CSW025
     C                   clear                   @STK(Q)                        CSW025
     C                   sub       1             Q                              CSW025
     C                   endsr                                                  CSW025
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
