     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Work Midas Message Manager Server')
      *****************************************************************
      *                                                               *
      *  Midas Message Management                                     *
      *                                                               *
      *  ME2100 - Midas ME Work Midas Message Manager Server          *
      *                                                               *
      *  Function:  This module sends a Data Queue message to         *
      *             indicate that the end of Input Cycle has been     *
      *             reached.  This will be on the same Data Queue,    *
      *             but after the data messages.                      *
      *             Then this module waits for that messages to be    *
      *             sent back to here.  When that happens we know     *
      *             that the end of IC message is sent back to here,  *
      *             we know that Meridian has finished processing,    *
      *             so control is returned to the CL to stop Meridian.*
      *                                                               *
      *  Called By: MEC2100 - Work Midas Message Manager Server       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 236309             Date 07Nov05               *
      * Midas Release 4.01.02 ----------------------------------------*
      *  Prev Amend No. 211783 *CREATE     Date 13Nov02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW025  *CREATE    Date 15Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
 
      *  236309 - Add new parameter MIDASCOB. QRCVDTAQ will only be   *
      *           called if MIDASCOB <> 'Y'. If MIDASCOB = 'Y',       *
      *           QSNDDTAQ will be called with a new parameter.       *
      *  211783 - Pass data queue name to ME2100                      *
      *  CSW025 - Midas Message Manager                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY MSCPYSRC,SRERRD
      *****************************************************************
 
     D*APHEAD********E*DS                  EXTNAME(APHEADPD)                                  236309
     D APHEAD        E DS                  EXTNAME(APMH17PD)                                  236309
 
     D SDSTAT        E DS           256    EXTNAME(SDSTAT) DTAARA(SDSTAT)                     236309
                                                                                              236309
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     *entry        plist
     C                   parm                    p@SndDtaQueue    10
     C                   parm                    p@TrmDtaQueue    10
     C                   parm                    MIDASCOB          1                          236309
 
      ** Push routine
 
     C                   z-add     1             Q                 5 0
     C                   movel     'mainline'    @STK(Q)
 
      ** Outgoing message is just a Meridian 1.7 header - set the relevant
      ** fields
 
     C*******************eval      APTGTSYS  = 'Midas'                                        236309
     C*******************eval      APTGTTYPE = 'Rundate_Synch'                                211783
     C*******************eval      APTGTTYPE = 'Midas_Terminate'                       211783 236309
     C                   eval      RAMSGTYPE = 'Midas_Terminate'                              236309
     C                   eval      RATGTSYS  = 'Midas'                                        236309
 
     C     MIDASCOB      ifne      'Y'                                                        236309
     C                   eval      q@snddata = APHEAD
 
      ** Send the end of Input Cycle message to the outgoing Data Queue
 
     C                   call      'QSNDDTAQ'    q@SndDtaq
 
      ** Wait for the message to be sent back
 
     C                   call      'QRCVDTAQ'    q@RcvDtaq
     C                   else                                                                 236309
     C                   eval      q@snddata = APHEAD + LIBR                                  236309
     C                   call      'QSNDDTAQ'    q@SndDtaqK                                   236309
     C                   endif                                                                236309
 
      ** Program termination
 
     C                   seton                                        LR
     C                   return
 
      **********************************************************************
      /EJECT
      **********************************************************************
      * *inzsr         : Initial processing                                *
      * ------                                                             *
      *                                                                    *
      **********************************************************************
 
     C     *inzsr        begsr
 
      ** Push subroutine
 
     C                   add       1             Q
     C                   movel     '*inzsr'      @STK(Q)
 
      ** Define parameter lists
 
     C     q@snddtaq     plist
     C                   parm      p@SndDtaQueue q@dtaq
     C                   parm      '*LIBL'       q@libl
     C                   parm      12000         q@length          5 0
     C                   parm                    q@snddata     12000
 
     C     q@rcvdtaq     plist
     C                   parm      p@TrmDtaQueue q@dtaq           10
     C                   parm      '*LIBL'       q@libl           10
     C                   parm      256           q@length          5 0
     C                   parm                    q@rcvdata       256
     C                   parm      -1            q@wait            5 0
                                                                                              236309
     C     q@snddtaqK    plist                                                                236309
     C                   parm      p@SndDtaQueue q@dtaq                                       236309
     C                   parm      '*LIBL'       q@libl                                       236309
     C                   parm      12000         q@length                                     236309
     C                   parm                    q@snddata                                    236309
     C                   parm      4             q@klength         3 0                        236309
     C                   parm                    q@skey            4                          236309
                                                                                              236309
     C     MIDASCOB      ifeq      'Y'                                                        236309
     C                   in        SDSTAT                                                     236309
     C                   Call      'RTVNODEREF'                                               236309
     C                   Parm      LIBR          HostID            2                          236309
     C                   Parm                    noderef           2 0                        236309
      *                                                                                       236309
     C                   movel     noderef       q@skey                                       236309
     C                   move      '10'          q@skey                                       236309
     C                   endif                                                                236309
 
      ** Pop subroutine
 
     C                   clear                   @STK(Q)
     C                   sub       1             Q
 
     C                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         begsr
 
     C     @run          ifeq      *blank
     C                   move      'Y'           @run              1
 
     C                   dump
 
     C                   endif
 
      ** Push subroutine
 
     C                   add       1             Q
     C                   movel     '*PSSR'       @STK(Q)
 
     C                   seton                                        U7U8LR
     C                   return
 
     C                   endsr
 
      ********************************************************************
