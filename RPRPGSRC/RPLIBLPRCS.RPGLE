     H DEBUG NOMAIN
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
     H OPTION(*SRCSTMT : *NODEBUGIO)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RPLIBLPRCS - Procedures for library list checking            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. 173467  *CREATE    Date 20Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  173467 - Created for requirement to check whethe QMQM is in  *
      *           the library list during run of DFNTRGMON.           *
      *                                                               *
      *****************************************************************
      /EJECT

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+


      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the procedure prototypes for
      ** various IBM APIs.                                                  s
     D/COPY RPCPYSRC,IBMAPIS_PR
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the prototypes for the procedures
      ** defined in this member.                                            s
     D/COPY RPCPYSRC,LIBL_PR
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      * This procedure returns true (*on) if the library received is
      * in the current job's complete library list, and false (*off) if it
      * is not.
     P IsInLibl        B                   export

     D IsInLibl        PI             1A
     D  Library                      10A

     D LiblArrSize     C                   43
      *           The library list array size: the total number of libraries
      *           that can be in a full library list.

     D FullLiblArr     S             10A   dim(LiblArrSize)

      * Get the full library list and scan the array for the library
      * in question
     C                   EVAL      FullLiblArr = GetFullLibl
     C     Library       LOOKUP    FullLiblArr                            99

     C                   RETURN    *in99

     C     *pssr         begsr
     C                   dump
     C                   endsr

     P IsInLibl        E

      *****************************************************************
      /EJECT
      *****************************************************************

      * This procedure returns the current job's complete library list
      * (ie system portion, user portion and any product or current
      * libraries).
     P GetFullLIbl     B                   export

     D LiblArrSize     C                   43
      *           The library list array size: the total number of libraries
      *           that can be in a full library list.

     D                 PI            10A   dim(LiblArrSize)


      /if not defined(QUSRJOBI700_Inc)
      /define QUSRJOBI700_Inc
      * --------------------------------------------------------------------
      * The following /COPY includes the structures for the job information
      * retrieved.
      * This include only contains the basic job information fields.
     D/COPY RPCPYSRC,QUSRJOB700

      * The array that is returned at the end of the job information
     D QLiblArray                    11A   dim(LiblArrSize)
      * This entry will contain the library list information.  This field
      *  will be an subfield of the data structure in the include.
      * --------------------------------------------------------------------
      /endif

      * The array that is returned by this procedure
     D FullLiblArray   S             10A   dim(LiblArrSize)

      * --------------------------------------------------------------------

      * Retrieve the job information
     C                   CALLP     QUserJobInfo(QUSI0700 : %len(QUSI0700) :
     C                                          'JOBI0700' : '*' : *blanks :
     C                                          QUSEC)

      * If there was an error, raise it to the caller
     C                   IF        QUSEI <> *blanks
     C                   RETURN    APIERR
     C                   ENDIF

      * Return the array of libraries
     C                   EVAL      FullLiblArray = QLiblArray
     C                   RETURN    FullLiblArray


     P GetFullLibl     E
