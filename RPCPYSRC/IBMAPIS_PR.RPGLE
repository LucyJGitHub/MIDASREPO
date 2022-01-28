      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  IBMAPIS_PR - Prototypes for IBM APIs                         *
      *                                                               *
      *  Function:  This member contains the prototypes for assorted  *
      *  IBM APIs.  Use of these allows them to be called using       *
      *  CALLP, or with the free-format syntax.                       *
      *  It also enables compile-time paramater checking.             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. 173467  *CREATE    Date 19Dec99               *
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

      ** -------------------------------------------------------------------
      ** This section includes the declarations for the standard error
      ** structure, and also preents multiple inclusions of the same
      ** structure (as long as other inclusions follow the same convention)
      /if not defined(QUSEC_included)
      /define QUSEC_included
      /copy QSYSINC/QRPGLESRC,QUSEC
     D QUSExcData             17     46
      /endif
      ** -------------------------------------------------------------------

      ** -------------------------------------------------------------------
      ** The QUSLFLD (List fields) API
      ** -----------------------------
      ** (Note that we can't use its proper name because it clashes with
      **  the name in the QSYSINC declare)
     D QFields         PR                  EXTPGM('QUSLFLD')
     D  QualUSpace                   20A   CONST
      **          The qualified name of the user space to use
     D  Format                        8A   CONST
      **      The record format to return
     D  QualFile                     20A   CONST
      **        The qualified name of the file being processed
     D  RecordFormat                 10A   CONST
      **            The record format of the file being processed
     D  Override                      1A   CONST
      **        Whether or not to apply overrides
     D  QErrStruct                         LIKE(QUSEC)
      **     The standard API error structure

      ** -------------------------------------------------------------------
      ** The QUSCRTUS (Create user space) API
      ** ------------------------------------
     D QUSCRTUS        PR                  EXTPGM('QUSCRTUS')
     D  QualUSpace                   20A   CONST
      **          The qualified name of the user space to create
     D  ExtAttr                      10A   CONST
      **       The extendard attribute of the user space
     D  InitialSize                   9B 0 CONST
      **           The initial size of the user space
     D  InitialValue                  1A   CONST
      **            The initial value of every byte in the user space
     D  PublicAut                    10A   CONST
      ** The public authority to the user space
     D  Text                         51A   CONST
      **    The text description of the user space
     D  Replace                      10A   CONST
      **       Whether or not to replace an existing user space
     D  QErrStruct                         LIKE(QUSEC)
      **     The standard API error structure

      ** -------------------------------------------------------------------
      ** The QUSRTVUS (Retrieve user space) API
      ** --------------------------------------
     D QUSRTVUS        PR                  EXTPGM('QUSRTVUS')
     D  QualUSpace                   20A   CONST
      **          The qualified name of the user space to retrieve
     D  StartPos                      9B 0 CONST
      **        Start position of data to retrieve
     D  DataLen                       9B 0 CONST
      **        Length of data to retrieve
     D  Receiver                   2000A   OPTIONS(*VARSIZE)
      **        Receiver variable (NOTE: this is set to an arbitrary length,
      **        which should be big enough for all requirements)
     D  QErrStruct                         LIKE(QUSEC)
      **     The standard API error structure

      ** -------------------------------------------------------------------
      ** The QUSRJOBI (Retrieve Job Information) API
      ** -------------------------------------------
      ** (Note that we can't use its proper name because it clashes with
      **  the name in the QSYSINC declare)
     D QUserJobInfo    PR                  EXTPGM('QUSRJOBI')
     D  ReturnVar                  2048A   OPTIONS(*VARSIZE)
      **         The receiver variable; note that this is set to an
      **         arbitrary length here, as it can contain variable-length
      **         data.
     D  ReturnVarLen                  9B 0 CONST
      **            The length provided for the returned data
     D  ReturnFormat                  8A   CONST
      **            The format of the data to return
     D  QualJobName                  26A   CONST
      **           The qualified name of the job
     D  InJobIdent                   16A   CONST
      **          The internal job identifier
     D  QErrStruct                         LIKE(QUSEC)
      **     The standard API error structure
