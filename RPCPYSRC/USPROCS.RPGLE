      /if defined(USPROCS_Inc)
      /eof
      * --------------------------------------------------------------------
      * These compiler directives prevent this member being
      * included if it has already been included.
      * --------------------------------------------------------------------
      /else
      /define USPROCS_Inc
      /endif
      *****************************************************************
      *                                                               *
      *  Member      : USPROCS     Declares required by user-space    *
      *                            handling procedures.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. 177251    *CREATE  Date 06Apr00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  177251 - Fix required that we check for activity status      *
      *           of a subsystem and job(s) within it.                *
      *                                                               *
      *****************************************************************

     D USHeaderInfoDS...
     D                 DS
     D  DataLen                      10I 0
     D  StartPos                     10I 0
     D  NoOfEntries                  10I 0


      * --------------------------------------------------------------------
      * Prototype for API QUSPTRUS - Retrieve pointer to user space
      * -----------------------------------------------------------
     D RtvPtr          PR                  EXTPGM('QUSPTRUS')
     D QualUserSpc                   20A
     D Pointer                         *
     D QUSECx                              like(QUSEC)

      * --------------------------------------------------------------------
      * The CrtUsrSpc procedure
      * -----------------------
     D CrtUsrSpc       PR
     D  UsrSpace                     20A   value
     D  Text                         50A   value

      * --------------------------------------------------------------------
      * The DltUsrSpc procedure
      * -----------------------
     D DltUsrSpc       PR
     D  UsrSpace                     20A   value

      * --------------------------------------------------------------------
      * The GetUSHdr procedure
      * ----------------------
     D GetUSHdr        PR                  like(USHeaderInfoDS)
     D  UsrSpace                     20A   value

