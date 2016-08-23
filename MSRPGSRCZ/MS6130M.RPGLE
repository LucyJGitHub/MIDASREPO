     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MS Start/Stop Midas/SWIFT Mer. comms')
      *****************************************************************
      *                                                               *
      *  Midas - Midas SWIFT                                          *
      *                                                               *
      *  MS6130M - Start/Stop Midas/Swift Meridian communications     *
      *                                                               *
      *             It is used for both incoming and outgoing         *
      *             messages.                                         *
      *                                                               *
      *  Called By: CMD/WRKMSMIF Work with Midas/Swift Meridian       *
      *                          interface                            *
      *                                                               *
      *  Calls    : MSC6131M, MSC6132M.                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CSW025             Date 15Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CSW017             Date 11Feb99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW025 - Midas Message Manager                               *
      *         - Pass OPERATION parameter from command forward       *
      *  CSW017 - Midas/SWIFT Meridian interface                      *
      *                                                               *
      *****************************************************************
      /EJECT
     FMSMCIDL0  UF   E           K disk    infsr(srfile)
      /EJECT
      /COPY MSCPYSRC,SRERRD
     D  sdstat       E DS                  extname(sdstat)
      ** SDSTAT for system prefix
      *
     D                 DS
     D  w@cjob                 1     26
     D  MCCJOB                 1     10
     D  MCCUSR                11     20
     D  MCCNUM                21     26
      ** Full id for communications job
      *
     D cpy@            S             80    dim(1) ctdata perrcd(1)
      ** Array containing Copyright statement
      *
      /EJECT
      *
      ** Set up copyright parameter
     C                   movea     cpy@          cpy2@            80
      *
     C     *entry        plist
     C                   parm                    p@oper            9
     C                   parm                    p@mcid           26
     C                   parm                    p@mode            7
     C                   parm                    p@type            7
      *
      ** Push routine
     C                   z-add     1             Q
     C                   movel     'mainline'    @STK(Q)
      *
      ** Access SDSTAT for system prefix
     C     *dtaara       define                  sdstat
     C                   in        sdstat
      *
      ** If Meridian communication ID entered, process just this session
     C     p@mcid        ifne      '*ALL'
     C     p@mcid        chain     msmcidd0                           50
     C     *in50         ifeq      '0'
     C                   exsr      sr_proc
     C                   endif
     C                   else
      *
      ** Otherwise process all sessions
     C     *loval        setll     msmcidd0
     C                   read      msmcidd0                               50
     C     *in50         doweq     *off
     C                   exsr      sr_proc
     C                   read      msmcidd0                               50
     C                   enddo
      *
     C                   endif
      *
     C                   seton                                        lr
      /EJECT
      **********************************************************************
      * sr_proc        : Process session details                           *
      * ------                                                             *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : sr_shutd                                          *
      *                  sr_start                                          *
      *                                                                    *
      **********************************************************************
      *
     C     sr_proc       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_proc'     @STK(Q)
      *
      ** If this record for session identified in parameter (or all)
     C     p@mcid        ifeq      MCMCID
     C     p@mcid        oreq      '*ALL'
      *
      ** Process shutdown request
     C     p@oper        ifeq      '*SHUTDOWN'
     C                   exsr      sr_shutd
     C                   else
      *
      ** Perform startup for manual request, or session identified for
      ** automatic startup processing
     C     p@mode        ifeq      '*MANUAL'
     C     MCSTUP        oreq      'A'
     C                   exsr      sr_start
     C                   endif
      *
     C                   endif
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_shutd       : Process shutdown                                  *
      * --------                                                           *
      *                                                                    *
      * Called by      : sr_proc                                           *
      *                                                                    *
      * Calls          : MSC6131M                                          *
      *                                                                    *
      **********************************************************************
      *
     C     sr_shutd      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_shutd'    @STK(Q)
      *
      ** Call CL function to end job if currently active. MSC6131M will send
      ** error message if job not found.
     C                   callb     'MSC6131M'
     C                   parm                    w@cjob
     C                   parm                    MCCJOB
     C                   parm                    MCCUSR
     C                   parm                    MCCNUM
     C                   parm                    p@type
     C                   parm                    MCSYTM
     C                   parm                    LIBR
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_start       : Process startup                                   *
      * --------                                                           *
      *                                                                    *
      * Called by      : sr_proc                                           *
      *                                                                    *
      * Calls          : MSC6132M                                          *
      *                                                                    *
      **********************************************************************
      *
     C     sr_start      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_start'    @STK(Q)
      *
      ** Call CL function to submit job. MSC6132 will send error message if
      ** job already active.
     C                   callb     'MSC6132M'
     C                   parm                    MCMCID
     C                   parm                    MCIPOP
     C                   parm                    MCJNAM
     C                   parm                    MCACCP
     C                   parm                    w@cjob
     C                   parm                    MCCJOB
     C                   parm                    MCCUSR
     C                   parm                    MCCNUM
     C                   parm                    MCSYTM
     C                   parm                    LIBR
     C                   parm                    p@oper                                       CSW025
      *
      ** Update communications job details
     C                   update    msmcidd0
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      /COPY MSCPYSRC,SRERRC
**CTDATA cpy@
(c) Misys International Banking Systems Ltd. 2001
