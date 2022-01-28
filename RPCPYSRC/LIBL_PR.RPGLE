      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  LIBL_PR    - Prototypes for library-list procedures          *
      *                                                               *
      *  Function:  This member contains the prototypes for some      *
      *  library-list handling procedures.                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Last Amend No. 173467  *CREATE    Date 19Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  173467 - New                                                 *
      *                                                               *
      *****************************************************************
      /EJECT
      /if not defined(LiblProtosInc)
      /define LiblProtosInc

      * Named constants used by the procedures
      * --------------------------------------
     D LiblArrSize     C                   43
      *           The library list array size: the total number of libraries
      *           that can be in a full library list.

      /if not defined(APIERR_Inc)
      /define APIERR_Inc
      ** Error code returned by the procedures
     D APIERR          C                   'APIERR'
      /endif

      * The IsInLibl() procedure receives a library name and returns
      * true if it is in the library (system portion, user portion,
      * current or product library) and false if it is not.
     D IsInLibl        PR             1A
     D  Lib                          10A

      * The GetFullLibl() procedure returns an array containing the entire
      * library list: system portion, user portion, current library and
      * product libraries
     D GetFullLibl     PR            10A   dim(LiblArrSize)

      /endif
