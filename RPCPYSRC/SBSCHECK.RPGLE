      /if defined(SBSCHECK_Inc)
      /eof
      * --------------------------------------------------------------------
      * These compiler directives prevent this member being
      * included if it has already been included.
      * --------------------------------------------------------------------
      /else
      /define SBSCHECK_Inc
      /endif
      *****************************************************************
      *                                                               *
      *  Member      : SBSCHECK    Declares required by subsystem-    *
      *                            checking functions.                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. 188295             Date 04Jan01               *
      *                 177251   *CREATE   Date 06Apr00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  188295 - Add IsLaunchJobActive() procedure                   *
      *  177251 - Fix required that we check for activity status      *
      *           of a subsystem and job(s) within it.                *
      *                                                               *
      *****************************************************************

      * --------------------------------------------------------------------
      * Include the procedure prototypes for the user space functions
     D/COPY RPCPYSRC,USPROCS
      * --------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      * The maximum number of jobs to list
     D MaxJobs         C                   100


      ** +--------------------------------------+
      ** ¦ Arrays and data structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ Procedure prototypes                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+

      * --------------------------------------------------------------------
      * The IsSbsActive procedure
      * -------------------------
     D IsSbsActive     PR             2A
     D  Subsystem                    10A   const

      * --------------------------------------------------------------------
      * The AreFeederJobsActive procedure
      * ---------------------------------
     D AreFeederJobsActive...
     D                 PR             2A
     D  Subsystem                    10A   const

      * --------------------------------------------------------------------
      * The ListActiveJobs procedure
      * ----------------------------
     D ListActiveJobs  PR
     D  UserSpace                    20A   value

      * --------------------------------------------------------------------
      * The IsLaunchJobActive procedure
      * -------------------------------
     D IsLaunchJobActive...
     D                 PR             2A
     D  Subsystem                    10A   const

