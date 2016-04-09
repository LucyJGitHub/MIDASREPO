     H NoMain   debug
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cashier TCP/IP socket service program')
      *****************************************************************
      *                                                               *
      *  Midas - Cashier Interface Module                             *
      *                                                               *
      *  RE004541 - Midas Cashier TCP/IP Socket Service Program       *
      *                                                               *
      *  Function:  This service program contains a set of functions  *
      *             required for the TCP/IP communication process     *
      *  Author: Alain Differdange                                    *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CRT012             Date 26NOV02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *  Prev Amend No. 206776             Date 20Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CRT004  *CREATE    Date 02JUN00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRT012 - Recompile over changed TTRANPD                      *
      *  206776 - Change Internal Job ID structure for 15 May 02 fix. *
      *           Very intermittent problem at all sites.             *
      *  CRT004 - Cashier Midas TCP/IP interface.                     *
      *                                                               *
      *****************************************************************
      *
      * Prototype Definitions
      *
     Dtcp_socket       S             10I 0
      *
     D sel_tcp         pr            10i 0
     d  socket                       10i 0
     d  time_sec                     10i 0
     d  wait_act                     10i 0
     d  rc                           10i 0
      *
     D opn_tcp         pr            10i 0
 
     D bnd_tcp         pr            10i 0
     d  socket                       10i 0 Const
     d  port                         10i 0 Const
     d  len                          10i 0 Const
     d  addr                           *
     d  size                         10i 0
 
     D lst_tcp         pr            10i 0
     d  socket                       10i 0 Const
     d  len                          10i 0 Const
     d  addr                           *
     d  size                         10i 0
 
     D con_tcp         pr            10i 0
     d  socket                       10i 0 Const
     d  host                         30
     d  hostlen                       2  0 Const
     d  port                          4  0 Const
 
     D snd_tcp         pr            10i 0
     d  socket                       10i 0 Const
     d  data                       9911
 
     D rcv_tcp         pr            10i 0
     d  socket                       10i 0 Const
     d  data                       9911
 
     D cls_tcp         pr            10i 0
     d  socket                       10i 0 Const
 
     D give_Ds         pr            10i 0
     d  jobid                        20
     d  socket                       10i 0 Const
 
     D take_Ds         pr            10i 0
     d  jobid                        20
 
     D Get_Jobint      pr            16
 
     D Log_Debug       pr            10i 0
     d  debugdata                  1000
 
     DFDZero           pr
     d FDES                          10U 0 Dim(7)
 
     D FDSet           pr
     D FD                            10I 0 Value
     D FDes                          10U 0 Dim(7)
 
     D FDClr           pr
     D FD                            10I 0 Value
     D FDes                          10U 0 Dim(7)
 
     D FDIsSet         pr            10I 0
     D FD                            10I 0 Value
     D FDes                          10U 0 Dim(7)
 
      * Variables
     D null            c                   const(x'00')
 
      ** G L O B A L  variables
      * Data strucuture represented a file descriptor
     D FD_Set          ds
     D   FDes                        10U 0 DIM(7)
      * a pointer on the file descriptor
     D FD_Set@         S               *   INZ(%Addr(FD_Set))
      * Debug variables
     DRE4540DA         S            128a   DTAARA
     DretDBG           S             10i 0
 
     D debugdata       ds
     D   debug_func                  10A
     D   debug_str                  990A
      /COPY ZSRSRC,RBEQENI2LE
 
      *----------------------------------------------------------------
      * FDZero- Zero all socket description bits in FDes array
      * Paramteres:
      *----------------------------------------------------------------
     P FDZero          B                   export
 
     D FDZero          pi
     D FDes                          10U 0 Dim(7)
 
     C                   Movel     *ALLX'00'     FDes
     PFDZero           E
 
      *----------------------------------------------------------------
      * FDSet - Set socket description bit:
      * Paramteres:
      * FD    A socket description number
      * FDes  An array of 7 integers (socket descriptor bit)
      *
      * Returnvalue none
      *----------------------------------------------------------------
     P FDSet           B                   export
 
     D FDSet           pi
     D FD                            10I 0 Value
     D FDes                          10U 0 Dim(7)
 
     DIdx              S              3P 0
     DPower            S              3P 0
 
     C     FD            DIV       32            Idx
     C                   MVR                     Power
     C                   Eval      Fdes(Idx + 1) =  Fdes(Idx + 1)+2 ** Power
 
     P FDSet           E
 
      *----------------------------------------------------------------
      * FDClr - Clear socket description bit
      * Paramteres:
      * FD    A socket description number
      * FDes  An array of 7 integers (socket descriptor bit)
      *
      * Returnvalue none
      *----------------------------------------------------------------
     P FDClr           B                   export
 
     D FDClr           pi
     D FD                            10I 0 Value
     D FDes                          10U 0 Dim(7)
 
     DIdx              S              3P 0
     DPower            S              3P 0
 
     C     FD            DIV       32            Idx
     C                   MVR                     Power
     C                   Eval      Fdes(Idx + 1) =  Fdes(Idx + 1)-2 ** power
 
     P FDClr           E
 
      *----------------------------------------------------------------
      * FDIsSet - Test if a socket description bit is set on
      * Paramteres:
      * FD    A socket description number
      * FDes  An array of 7 integers (socket descriptor bit)
      *
      * Returnvalue
      * 1 -  the bit is set on
      * 2 -  the bit is set off
      *----------------------------------------------------------------
     P FDIsSet         B                   export
 
     D FDIsSet         pi            10I 0
     D FD                            10I 0 Value
     D FDes                          10U 0 Dim(7)
 
     DIdx              S             10I 0
     DShiftFD          S             10U 0
     DPower            S              3P 0
     DResult           S              3p 0
     DSwitch           S             10I 0
 
     C     FD            DIV       32            Idx
     C                   MVR                     Power
     C                   Eval      ShiftFD =      FDes(Idx) / 2 ** power
     C     ShiftFD       DIV       2             RESULT
     C                   MVR                     Switch
     C                   Return                  Switch
 
     P FDIsSet         E
      *----------------------------------------------------------------
      * Receive data with time out                     AC begin
      *----------------------------------------------------------------
     P sel_tcp         B                   export
 
     D sel_tcp         pi            10i 0
     d  socket                       10i 0
     d  time_sec                     10i 0
     d  wait_act                     10i 0
     d  rc                           10i 0
 
     D select          PR            10i 0 extproc('select')
     d                               10i 0 value
     d                                 *   Value
     d                                 *   value
     d                                 *   value
     d                                 *   value
 
     d  TIMEVAL        S               *
 
     d  NIL            S               *   inz(*null)
 
      *TIMEVAL data structure
 
     D TimeOut         ds
     d  t_second                     10i 0
     d  t_milsec                     10i 0
 
     dFdes                           10U 0 Dim(7)
 
     C                   Eval         t_second = time_sec
     C                   Eval         t_milsec = 0
      *Initialize return code
     C                   Eval         rc = 0
      *Initialize file descriptor
     C                   Callp        FDZero(Fdes)
     C                   Callp        FDSet (socket:Fdes)
      *Need to be passed by pointer
     C                   Eval          TIMEVAL = %Addr(TimeOut)
      *Socket starting with zero
     C                   Eval          TCP_SOCKET = Socket + 1
      *Apply changes to descriptor
     C                   Eval          wait_act=select(TCP_SOCKET:
     C                                 FD_Set@:nil:nil:
     C                                 TIMEVAL)
      *Check Return code
     C                   if            wait_act < 0
     C                   Eval          rc = -1
     C                   else
     C                   Eval          rc = 0
     C                   endif
     C                   Return    rc
     P sel_tcp         E
      *----------------------------------------------------------------
      * Open Socket
      *----------------------------------------------------------------
 
     P opn_tcp         B                   export
     D opn_tcp         pi            10i 0
 
     D retSd           s             10i 0
     D opnskt          PR            10i 0 extproc('socket')
     d                               10i 0 value
     d                               10i 0 value
     d                               10i 0 value
 
     C                   Eval      retSd = opnskt(2:1:0)
     c                   Return    retSd
 
     Popn_tcp          E
 
      *----------------------------------------------------------------
      * End - Open Socket
      *----------------------------------------------------------------
 
      *****************************************************************
      *----------------------------------------------------------------
      * Bind -- server side
      *----------------------------------------------------------------
     P bnd_tcp         B                         export
 
     D bnd_tcp         pi            10i 0
     d retSd                         10i 0 Const
     d iport                         10i 0 Const
     d qlen                          10i 0 Const
     D addr                            *
     D size                          10i 0
 
     d retCd           s             10i 0
     d clnSd           s             10i 0
     D OptVal          S             10I 0 Inz( 1 )
     D OptValPtr       S               *   Inz( %Addr( OptVal ) )
     D LenOptVal       S             10I 0 Inz( %Size( OptVal ) )
     d retSdC          s             10a
     d retCdC          s             10a
 
     D addr1           ds
     d  $family                       5i 0
     d  $port                         5u 0
     d  $ip                          10u 0
     d  $zero                         8
 
     D Bind            pr            10i 0 extproc('bind')
     d                               10i 0 value
     d                                 *   value
     d                               10i 0 value
 
     D SetSockOpt      PR            10I 0 ExtProc( 'setsockopt' )
     D  Sckt                         10I 0 Value
     D  Level                        10I 0 Value
     D  Opt                          10I 0 Value
     D  OptValPtr                      *   Value
     D  OptValLen                    10I 0 Value
 
     D Socket          PR            10I 0 ExtProc( 'socket'  )
     D  AddrFam                      10I 0 Value
     D  SckType                      10I 0 Value
     D  Protocol                     10I 0 Value
 
      * DS to hold debug information
     D debugbind       ds          1000
     D   dbfunc                      10A   inz('BIND')
     D   dbsckt1              12     20A   inz('Socket = ')
     D   dbsckt2              21     30A
     D   dbretcd1             32     42A   inz(': Result = ')
     D   dbretcd2             43     52A
 
      * Allow socket descriptor to be reuseable
     C                   Eval      retCd    = SetSockOpt( retSd:
     C                                                    -1:
     C                                                    55:
     C                                                    OptValPtr:
     C                                                    LenOptVal )
 
     c                   eval      $family = 2
     c                   eval      $port = iport
     c                   eval      $ip   = 0
     c                   move      *allx'00'     $zero
     c                   eval      addr = %addr(addr1)
     c                   eval      size = %size(addr)
      * Bind
     c                   eval      retCd = bind(retSd:addr:size)
 
     c                   movel     retcd         dbsckt2
     c                   movel     retsd         dbretcd2
     c                   eval      retDBG= Log_Debug(debugbind)
 
     c                   return    retCD
 
     P bnd_tcp         E
      *****************************************************************
 
      *----------------------------------------------------------------
      * End - Bind -- server side
      *----------------------------------------------------------------
 
      *****************************************************************
      *----------------------------------------------------------------
      * Listen/Accept Server side
      *----------------------------------------------------------------
     P lst_tcp         B                         export
 
     D lst_tcp         pi            10i 0
     d retSd                         10i 0 Const
     d qlen                          10i 0 Const
     D addr                            *
     D size                          10i 0
 
     d clnSd           s             10i 0
     d retCd           s             10i 0
 
     D listen          pr            10i 0 extproc('listen')
     d                               10i 0 value
     d                               10i 0 value
 
     D accept          pr            10i 0 extproc('accept')
     d                               10i 0 value
     d                                 *   value
     d                                 *   value
 
      * DS to hold debug information
     D debuglisten     ds          1000
     D   dbfunc                      10A   inz('LISTEN')
     D   dbsckt1              12     20A   inz('Socket = ')
     D   dbsckt2              21     30A
     D   dbretcd1             32     42A   inz(': Result = ')
     D   dbretcd2             43     52A
 
      * Listen
     c                   eval      retCd = listen(retSd:qlen)
     c                   movel     retSd         dbsckt2
     c                   movel     retCd         dbretcd2
     c                   eval      retDBG= Log_Debug(debuglisten)
 
      * Accept
     c                   if        retCd = -1
     c                   return    -1
     c                   endif
 
     c                   eval      clnSd = accept(retSd:addr:%addr(size))
     c                   movel     'ACCEPT'      dbfunc
     c                   movel     retSd         dbsckt2
     c                   movel     clnSd         dbretcd2
     c                   eval      retDBG= Log_Debug(debuglisten)
     c                   return    clnSd
 
     P lst_tcp         E
      *****************************************************************
 
      *----------------------------------------------------------------
      * End - Listen/Accept -- server side
      *----------------------------------------------------------------
 
      *----------------------------------------------------------------
      * Connect socket
      *----------------------------------------------------------------
     P con_tcp         B                   export
     D con_tcp         pi            10i 0
     d  retSd                        10i 0 Const
     d  rmthost                      30
     d  rmthlen                       2  0 Const
     d  rmtport                       4  0 Const
 
     D retCd           s             10i 0
     D size            s             10i 0
     D addr            s               *
 
     D addr1           ds
     d  $family                       5i 0
     d  $port                         5u 0
     d  $ip                          10u 0
     d  $zero                         8
 
     D connect         pr            10i 0 extproc('connect')
     d                               10i 0 value
     d                                 *   value
     d                               10i 0 value
 
     D inet_addr       pr            10u 0 extproc('inet_addr')
     d                                 *   value
 
      * DS to hold debug information
     D debugconnect    ds          1000
     D   dbfunc                      10A   inz('CONNECT')
     D   dbsckt1              12     20A   inz('Socket = ')
     D   dbsckt2              21     30A
     D   dbretcd1             32     42A   inz(': Result = ')
     D   dbretcd2             43     52A
 
     C                   eval      rmthost=rmthost+null
 
     c                   eval      $ip = inet_addr(%addr(rmthost))
     c                   eval      $port = rmtport
     c                   move      *allx'00'     $zero
     c                   eval      $family = 2
     c                   eval      addr = %addr(addr1)
     c                   eval      size = %size(addr)
 
     c                   eval      retCd=connect(retSd:addr:size)
     c                   movel     retSd         dbsckt2
     c                   movel     retCd         dbretcd2
     c                   eval      retDBG= Log_Debug(debugconnect)
 
     c                   Return    retCd
     P con_tcp         E
      *----------------------------------------------------------------
      * End - Connect socket
      *----------------------------------------------------------------
 
      *----------------------------------------------------------------
      * Send
      *----------------------------------------------------------------
     P snd_tcp         B                   export
 
     D snd_tcp         pi            10i 0
     d  retSd                        10i 0 Const
     d  Sndstr                     9911
 
     d retCd           s             10i 0
     d flag            s             10i 0
     d Sndstrlen       s             10i 0
     d addr            s               *
     d nToGo           s             10i 0
     d nSent           s             10i 0
     d charLen         s              8a
     d retSdc          s             10a
 
     D send            pr            10i 0 extproc('send')
     d                               10i 0 value
     d                                 *   value
     d                               10i 0 value
     d                               10i 0 value
 
      * DS to hold debug information
     D debugsend       ds          1000
     D   dbfunc                      10A   inz('SEND')
     D   dbsckt1              12     20A   inz('Socket = ')
     D   dbsckt2              21     30A
     D   dbretcd1             32     42A   inz(': Result = ')
     D   dbretcd2             43     52A
     D   dbstr1               54     64A   inz(': String = ')
     D   dbstr2               65   1000A
 
     C                   eval      flag = 0
     c*                  eval      sndstr = %trim(sndstr) + null
     c*    null          scan      sndstr        sndstrlen
     C                   eval      charlen = %subst(sndstr:1:8)
     C                   move      charlen       sndstrlen
     C                   eval      sndstrlen = sndstrlen + 11
     c                   eval      %subst(sndstr:sndstrlen+1:1) = null
     c                   eval      addr = %addr(Sndstr)
     c                   eval      nToGo = sndstrlen
      *
     c                   dow       nToGo > 0 and retCD = 0
     c                   eval      nSent=send(retSd:addr:nToGo:flag)
 
     c                   movel     nsent         dbretcd2
     c                   movel     retsd         dbSckt2
     c                   movel(P)  sndstr        dbstr2
     c                   eval      retDBG= Log_Debug(debugsend)
 
     c                   if        nSent > 0
     c                   eval      nToGo = nToGo - nSent
     c                   eval      addr = addr + nSent
     c                   eval      retCD = 0
     c                   else
     c                   eval      retCD = -1
     c                   endif
     c                   enddo
      *
     c                   return    retCd
 
     P snd_tcp         E
      *----------------------------------------------------------------
      * End - Send
      *----------------------------------------------------------------
 
      *----------------------------------------------------------------
      * Receive
      *----------------------------------------------------------------
     P rcv_tcp         B                   export
 
     D rcv_tcp         pi            10i 0
     d  retSd                        10i 0 Const
     d  Rcvstr                     9911
 
     d retCd           s             10i 0
     d Rcvstrlen       s             10i 0
     d addr            s               *
     d flag            s             10i 0
     d nRecv           s             10i 0
     d nMsgLen         s              8s 0
     d nToGo           s             10i 0
 
     D recv            pr            10i 0 extproc('recv')
     d                               10i 0 value
     d                                 *   value
     d                               10i 0 value
     d                               10i 0 value
 
      * DS to hold debug information
     D debugreceive    ds          1000
     D   dbfunc                      10A   inz('RECEIVE')
     D   dbsckt1              12     20A   inz('Socket = ')
     D   dbsckt2              21     30A
     D   dbretcd1             32     42A   inz(': Result = ')
     D   dbretcd2             43     52A
     D   dbstr1               54     64A   inz(': String = ')
     D   dbstr2               65   1000A
 
     c                   eval      flag = 0
     c                   eval      addr = %addr(Rcvstr)
     c                   eval      Rcvstrlen = 9911
     c                   eval      nRecv=recv(retSd:addr:Rcvstrlen:flag)
     c                   movel     retSd         dbSckt2
     c                   movel     nRecv         dbRetcd2
     c                   movel(P)  Rcvstr        dbstr2
     c                   eval      retDBG= Log_Debug(debugreceive)
      *
     c                   if        nRecv > 0
      * Get message length (stored in first 8 chars + header of 11)
     c                   movel     Rcvstr        nMsgLen
     c                   eval      nToGo = nMsgLen - nRecv
     c                   eval      addr = addr + nRecv
     c                   eval      retCD = 0
     c                   else
     c                   eval      retCD = -1
     c                   endif
      * Loop to receive full message
     c                   dow       nToGo > 0 and retCD = 0
     c                   eval      nRecv=recv(retSd:addr:Rcvstrlen:flag)
     c                   movel     retSd         dbSckt2
     c                   movel     nRecv         dbRetcd2
     c                   movel     Rcvstr        dbstr2
     c                   eval      retDBG= Log_Debug(debugreceive)
      *
     c                   if        nRecv > 0
     c                   eval      nToGo = nToGo - nRecv
     c                   eval      addr = addr + nRecv
     c                   eval      retCD = 0
     c                   else
     c                   eval      retCD = -1
     c                   endif
      *
     c                   enddo
      *
     c                   return    retCd
 
     P rcv_tcp         E
      *----------------------------------------------------------------
      * End - Receive
      *----------------------------------------------------------------
 
      *----------------------------------------------------------------
      * Close Socket
      *----------------------------------------------------------------
     P cls_tcp         B                   export
     D cls_tcp         pi            10i 0
     d  retSd                        10i 0 Const
 
     d retCd           s             10i 0
     D closkt          PR            10i 0 extproc('close')
     d                               10i 0 value
 
      * DS to hold debug information
     D debugclose      ds          1000
     D   dbfunc                      10A   inz('CLOSE')
     D   dbsckt1              12     20A   inz('Socket = ')
     D   dbsckt2              21     30A
     D   dbretcd1             32     42A   inz(': Result = ')
     D   dbretcd2             43     52A
 
      * Close
     c                   eval      retCd = closkt(retsd)
     c                   movel     retSd         dbSckt2
     c                   movel     retCd         dbRetcd2
     c                   eval      retDBG= Log_Debug(debugclose)
     c                   Return    retCd
     P cls_tcp         E
      *----------------------------------------------------------------
      * End - Close
      *----------------------------------------------------------------
 
      *----------------------------------------------------------------
      * Give Descriptor
      *----------------------------------------------------------------
 
     P give_Ds         B                   export
 
     D give_Ds         pi            10i 0
     d  tgt_jobid                    20
     d  sD                           10i 0 Const
 
     d #bpos           s              2  0
     d retCd           s             10i 0
     d addr            s               *
     D giveds          pr            10i 0 extproc('givedescriptor')
     d                               10i 0 value
     d                                 *   value
 
      * DS to hold debug information
     D debuggiveds     ds          1000
     D   dbfunc                      10A   inz('GIVEDS')
     D   dbsckt1              12     20A   inz('Socket = ')
     D   dbsckt2              21     30A
     D   dbretcd1             32     42A   inz(': Result = ')
     D   dbretcd2             43     52A
     D   dbjobid              54     64A   inz(': Target = ')
     D   dbjobid2             65     84A
 
     c**** ' '********** scan      tgt_jobid     #bpos                                        206776
     c     ' '           scan      tgt_jobid:17  #bpos                                        206776
     c                   eval      %subst(tgt_jobid:#bpos:1) = X'00'
     c                   eval      addr = %addr(tgt_jobid)
     c                   eval      retcD= giveds(sD:addr)
     c                   movel     sD            dbSckt2
     c                   movel     retCd         dbRetcd2
     c                   movel     tgt_jobid     dbjobid2
     c                   eval      retDBG= Log_Debug(debuggiveds)
 
     c                   return    retCd
 
     P give_Ds         E
 
      *---------------------------------------------------------------
      * End - Give Descriptor
      *---------------------------------------------------------------
 
      *---------------------------------------------------------------
      * Take Descriptor
      *---------------------------------------------------------------
 
     P take_Ds         B                   export
 
     D take_Ds         pi            10i 0
     d  src_jobid                    20
 
     d #bpos           s              2  0
     d sD              s             10i 0
     d addr            s               *
     D takeds          pr            10i 0 extproc('takedescriptor')
     d                                 *   value
 
      * DS to hold debug information
     D debugtakeds     ds          1000
     D   dbfunc                      10A   inz('TAKEDS')
     D   dbsckt1              12     20A   inz('Socket = ')
     D   dbsckt2              21     30A
     D   dbretcd1             32     42A   inz(': Result = ')
     D   dbretcd2             43     52A
     D   dbjobid              54     64A   inz(': Source = ')
     D   dbjobid2             65     84A
 
     c*****' '***********scan      src_jobid     #bpos                                        206776
     c     ' '           scan      src_jobid:17  #bpos                                        206776
     c                   eval      %subst(src_jobid:#bpos:1) = X'00'
 
     c                   eval      addr = %addr(src_jobid)
     c                   eval      sD = takeds(addr)
     c                   movel     sD            dbSckt2
     c                   movel     src_jobid     dbjobid2
     c                   movel     sD            dbRetcd2
     c                   eval      retDBG= Log_Debug(debugtakeds)
 
     c                   return    sD
     P take_Ds         E
 
      *---------------------------------------------------------------
      * End - Take Descriptor
      *---------------------------------------------------------------
 
      *---------------------------------------------------------------
      * Get Job Internal Identifier
      *---------------------------------------------------------------
 
     P Get_Jobint      B                   export
 
     D Get_Jobint      pi            16
      *
     D JOBINFO         DS            50
      *                                       Job info from QUSRJOBI
     D  jobname                9     18
     D  jobuser               19     28
     D  jobno                 29     34
     D  jobint                35     50
      *
 
     C                   CALL      'QUSRJOBI'                           98
     C                   PARM      *BLANKS       JOBINFO
     C                   PARM      50            LENG              4 0
     C                   PARM      'JOBI0100'    INPT              8
     C                   PARM      '*'           QUAL             26
     C                   PARM      *BLANKS       INTR             16
      *
     c                   RETURN    JOBINT
      *
     P Get_Jobint      E
 
      *---------------------------------------------------------------
      * End - Take Descriptor
      *---------------------------------------------------------------
 
      *---------------------------------------------------------------
      * Write DEBUG information to dataqueue
      *---------------------------------------------------------------
 
     P Log_Debug       B                   export
 
     D Log_Debug       pi            10i 0
     d  debugdata                  1000
      *
     c                   IN        RE4540DA
     c                   movel     re4540da      debugflag         1
     c                   if        debugflag = 'Y'
      * Send Message to dataqueue
     C                   CALL      'QSNDDTAQ'                             70
     C                   PARM      'RE4540DQ'    P@QSN            10            DataQueue Name
     C                   PARM      '*LIBL'       P@QLS            10            DataQ Library
     C                   PARM      1000          P@QNS             5 0          DataQ Length
     C                   PARM      debugdata     P@QDS                          DataQueue Data
      *
     C                   MOVEL     'QSNDDTAQ'    P@QRS            10
     C                   MOVEL     P@QSN         P@QKY            20
      *----------------------------------------------------------------
      * Reset Values.
     C                   CLEAR                   P@QDS
     c                   endif
      *
     c                   RETURN    0
     P Log_Debug       E
 
      *---------------------------------------------------------------
      * End - Write DEBUG information to dataqueue
      *---------------------------------------------------------------
