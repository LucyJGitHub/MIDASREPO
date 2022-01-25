      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  BOIF_PR -    Prototypes for Back Office Interface            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. 000820 (Bugzilla)                             *
      *                         *CREATE    Date 28Mar06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  000820 - New                                                 *
      *                                                               *
      *****************************************************************
      /EJECT
      /if not defined(BOIFProtosInc)
      /define BOIFProtosInc

     D RPBOIF99        PR
     D  dataRequired                 10A
     D  dataReturned                 64A
     D  dataLength                    2P 0

      /endif
