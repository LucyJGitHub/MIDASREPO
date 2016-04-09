     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MS Start/Stop Midas/CAS comms        *MODULE')
      *****************************************************************
      *                                                               *
      *  Midas SWIFT Direct link : Midas/CAS interface                *
      *                                                               *
      *  MS8030M - Start/Stop Midas/CAS communications                *
      *                                                               *
      *             Midas and the CBT using the Common Application    *
      *             Server (CAS).                                     *
      *                                                               *
      *             It is used for both incoming and outgoing         *
      *             messages.                                         *
      *                                                               *
      *  Called By: CMD/WRKCASIF Work with CAS interface              *
      *                                                               *
      *  Calls    : MSC8031M, MSC8032M.                               *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CSW008 *CREATE     Date 09AUG96               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW008 - Midas/CAS interface                                 *
      *  nnnnnn - (fix details)                                       *
      *                                                               *
      *****************************************************************
      /EJECT
     FMSMAPIL0  UF   E           K disk    infsr(srfile)
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
     C                   parm                    p@lmapid         26
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
      ** If l-mapid entered process just this session
     C     p@lmapid      ifne      '*ALL'
     C     p@lmapid      chain     msmapid0                           50
     C     *in50         ifeq      '0'
     C                   exsr      sr_proc
     C                   endif
     C                   else
      *
      ** Otherwise process all sessions
     C     *loval        setll     msmapid0
     C                   read      msmapid0                               50
     C     *in50         doweq     *off
     C                   exsr      sr_proc
     C                   read      msmapid0                               50
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
     C     p@lmapid      ifeq      MCMAPI
     C     p@lmapid      oreq      '*ALL'
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
      * Calls          : MSC8031M                                          *
      *                                                                    *
      **********************************************************************
      *
     C     sr_shutd      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_shutd'    @STK(Q)
      *
      ** Call CL function to end job if currently active. MSC8031M will send
      ** error message if job not found.
     C                   callb     'MSC8031M'
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
      * Calls          : MSC8032M                                          *
      *                                                                    *
      **********************************************************************
      *
     C     sr_start      begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_start'    @STK(Q)
      *
      ** Call CL function to submit job. MSC8032 will send error message if
      ** job already active.
     C                   callb     'MSC8032M'
     C                   parm                    MCMAPI
     C                   parm                    MCIPOP
     C                   parm                    MCJNAM
     C                   parm                    MCACCP
     C                   parm                    w@cjob
     C                   parm                    MCCJOB
     C                   parm                    MCCUSR
     C                   parm                    MCCNUM
     C                   parm                    MCSYTM
     C                   parm                    LIBR
      *
      ** Update communications job details
     C                   update    msmapid0
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      /COPY MSCPYSRC,SRERRC
**CTDATA cpy@
(c) Misys International Banking Systems Ltd. 2001
