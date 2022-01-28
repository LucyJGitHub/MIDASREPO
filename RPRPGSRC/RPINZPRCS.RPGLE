     H DEBUG NOMAIN
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
     H OPTION(*SRCSTMT : *NODEBUGIO)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RPINZPRCS - Procedures for file / record initialisation      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. MD055679           Date 12May20               *
      *                 SF01014587         Date 07May13               *
      *                 001109  Bugzilla   Date 04Sep06               *
      *                 CRP026  *CREATE    Date 18Jul05               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  MD055679 - MQ V9 issue - repmidas jobs.                      *
      *           - Redeliver due to changes in PSSR_ILENE. Also,     *
      *             remove PSDS, not in Midas Replication repository. *
      *  SF01014587 - Changes to reduce likelihood of record locking. *
      *  001109 - Improve error information.                          *
      *  CRP026 - *SECURE method of Feeder processing means that      *
      *           a file may be used for storing the last journal     *
      *           sequence number.  File need to be initialised       *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************

     FRPFEEDSQNOUF A E           K DISK    usropn
      * The Feeder last used sequence number file

      */COPY*RPCPYSRC,PSDS                                                                  MD055679

     D checkAddFdrCtlRec...
     D                 PR            10A   extproc('checkAddFdrCtlRec')
     D                                1A

     D getFdrCtlRec    PR                  extproc('getFdrCtlRec')
     D                                1A
     D                               10A
     D                               10P 0

      *****************************************************************
      /EJECT
      *****************************************************************

      * --------------------------------------------------------------------
      * This procedure checks whether a control record exists for a specified
      *    Feeder number and if it does not creates one.
     P checkAddFdrCtlRec...
     P                 B                   export
     D checkAddFdrCtlRec...
     D                 PI            10A
     D   inFdrSeqNum                  1A

      ** Set ERROR to a different value in each block                           001109
     D**ERROR**********S             10A   inz('ERROR     ')                    001109
     D  ERROR          S             10A                                        001109
     D  BLANK          S             10A   inz(*BLANK)

      /free
       // Open and close the file each time to minimise locking problems
       open(e) RPFEEDSQNO;
       if %error;
        //return*ERROR;******                                                   //001109
          ERROR = 'FILE OPEN';                                                  //001109
          exsr *pssr;                                                           //001109
       endif;

       chain(e) inFdrSeqNum RPFDSQNOD0;
       if %error;
        //return*ERROR;******                                                   //001109
          ERROR = 'CHAIN';                                                      //001109
          exsr *pssr;                                                           //001109
       endif;

       // Update or insert, as appropriate
       if not %found(RPFEEDSQNO);
          RGFDRNUM = inFdrSeqNum;
          RGSEQNUM = 0;
          RGSTRNUM = 0;

          write(e) RPFDSQNOD0;
          if %error;
           //return*ERROR;******                                                //001109
             ERROR = 'WRITE';                                                   //001109
             exsr *pssr;                                                        //001109
          endif;
       endif;

       close(e) RPFEEDSQNO;
       if %error;
        //return*ERROR;******                                                   //001109
          ERROR = 'FILE CLOSE';                                                 //001109
          exsr *pssr;                                                           //001109
       endif;

       return BLANK;

      /end-free

      * SR without RETURN or ENDSR used so that appropriate code can be added   001109
     C/COPY RPCPYSRC,PSSR_ILENE                                                 001109
     C                   RETURN    ERROR                                        001109
     C                   ENDSR                                                  001109
                                                                                001109
     P checkAddFdrCtlRec...
     P                 E
      * --------------------------------------------------------------------

      * --------------------------------------------------------------------
      * This procedure checks the control record exists for a specified
      *   Feeder number.
     P getFdrCtlRec    B                   export
     D getFdrCtlRec    PI
     D  inFdrSeqNum                   1A
     D  outReturnCode                10A
     D  outJrnSeqNum                 10P 0

      ** Set ERROR to a different value in each block                           001109
     D**ERROR**********S             10A   inz('ERROR     ')                    001109
     D  ERROR          S             10A
     D  NOTFOUND       S             10A   inz('NOTFOUND  ')
     D  BLANK          S             10A   inz(*BLANK)

      /free
       // Open and close the file each time to minimise locking problems
       close(e) RPFEEDSQNO;
       open(e) RPFEEDSQNO;
       if %error;
        //outReturnCode*=*ERROR;*****                                           //001109
        //return;********************                                           //001109
          outReturnCode = 'FILE OPEN';                                          //001109
          exsr *pssr;                                                           //001109
       endif;

       // Note that we are including the N extension to prevent
       // requesting a record lock.
       chain(en) inFdrSeqNum RPFDSQNOD0;
       if %error;
          // We're going to retry once, just in case there was a locking
          // problem.  Such have been reported at client sites, though
          // I hope that the N extender above will prevent such problems.
          chain(en) inFdrSeqNum RPFDSQNOD0;
          if %error;
             outReturnCode = 'SEQNONOTFD';                                         //001109
             exsr *pssr;                                                           //001109
          endif;
       endif;

       // If record found, return the last journal sequence number used
       if %found(RPFEEDSQNO);
          outJrnSeqNum = RGSEQNUM;
       else;
          outReturnCode = NOTFOUND;
        //return;********************                                           //001109
          exsr *pssr;                                                           //001109
       endif;

       close(e) RPFEEDSQNO;
       if %error;
        //outReturnCode*=*ERROR;*****                                           //001109
        //return;********************                                           //001109
          outReturnCode = 'FILE CLOSE';                                         //001109
          exsr *pssr;                                                           //001109
       endif;

       outReturnCode = BLANK;
       return;

      /end-free

     C/COPY RPCPYSRC,PSSR_ILE                                                   001109
                                                                                001109
     P getFdrCtlRec    E
      * --------------------------------------------------------------------

