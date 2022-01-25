     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H NOMAIN
     H EXTBININT(*YES)
      * (Treat external binary fields as integers - improves API handling)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RPUSPROCS - User-space handling procedures                   *
      *                                                               *
      *  Function:  This module contains procedure wrappers for some  *
      *             of the user-space handling APIs.                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. 177251  *CREATE    Date 06Apr00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  177251 - This fix required that we check the activity        *
      *           state of a subsystem and its jobs.                  *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+


      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+


      **--------------------------------------------------------------------------------------------
      ** The following /COPY lines include the structures necessary for the
      ** QBNLSPGM API.  The first is specific to that API; the second is
      ** the generic API error structure.
     D/COPY QSYSINC/QRPGLESRC,QBNLSPGM
     D/COPY QSYSINC/QRPGLESRC,QUSEC
      /if defined(DebugMode)
     D QUSExcData             17     46
      /endif

      ** The following /COPY includes the structures for the list APIs user
      ** space generic header
     D/COPY QSYSINC/QRPGLESRC,QUSGEN
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the prototypes for the procedures
      ** in this module
     D/COPY RPCPYSRC,USPROCS
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
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



      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************



      *---------------------------------------------------------------------------------------------
      /EJECT
      *---------------------------------------------------------------------------------------------
      *
      * CrtUsrSpc - Create the user space
      *
      *---------------------------------------------------------------------------------------------

     P CrtUsrSpc       B                   export
     D CrtUsrSpc       PI
     D  UsrSpace                     20A   value
     D  Text                         50A   value
      *---------------------------------------------------------------------------------------------

      ** The extended attribute of the user space
     D ExtAttr         S             10A

      ** The initial size of the user space
     D InitSize        S             10I 0 INZ(1024)

      ** The initial value of the contents of the user space
     D InitVal         S              1A   INZ(X'00')

      ** Public authority to the user space
     D PublicAut       S             10A   INZ('*USE')

      ** Description of the user space
     D UserSpaceText   S             50A

      ** Whether to replace if already there
     D Replace         S             10A   INZ('*YES')

      *---------------------------------------------------------------------------------------------


     C                   call      'QUSCRTUS'
     C                   parm                    UsrSpace
     C                   parm                    ExtAttr
     C                   parm                    InitSize
     C                   parm                    InitVal
     C                   parm                    PublicAut
     C                   parm                    Text
     C                   parm                    Replace
     C                   parm                    QUSEC

      *---------------------------------------------------------------------------------------------
     P CrtUsrSpc       E
      *---------------------------------------------------------------------------------------------

      *---------------------------------------------------------------------------------------------
      /EJECT
      *---------------------------------------------------------------------------------------------
      *
      * DltUsrSpc - Delete the user space
      *
      *---------------------------------------------------------------------------------------------
     P DltUsrSpc       B                   export
     D DltUsrSpc       PI
     D  UsrSpace                     20A   value
      *---------------------------------------------------------------------------------------------

      ** Delete the user space
     C                   clear                   QUSEC
     C                   call      'QUSDLTUS'
     C                   parm                    UsrSpace
     C                   parm                    QUSEC

      ** (Ignore errors)

      *---------------------------------------------------------------------------------------------
     P DltUsrSpc       E
      *---------------------------------------------------------------------------------------------

      *---------------------------------------------------------------------------------------------
      /EJECT
      *---------------------------------------------------------------------------------------------
      *
      * GetUSHdr - Get the user space header information
      *
      *---------------------------------------------------------------------------------------------
     P GetUSHdr        B                   export
     D GetUSHdr        PI                  like(USHeaderInfoDS)
     D  UsrSpace                     20A   value
      *---------------------------------------------------------------------------------------------

      ** Initialise the data length and start position, as this
      ** routine can be called more than once
     C                   eval      DataLen  = 150
     C                   eval      StartPos = 1

     C                   call      'QUSRTVUS'
     C                   parm                    UsrSpace
     C                   parm                    StartPos
     C                   parm                    DataLen
     C                   parm                    QUSH0100

      ** The field QUSOLD now contains the offset to the list data section,
      ** and QUSSEE contains the size of each entry; set DataLen up with
      ** this size, and StartPos with the offset + 1
     C                   eval      DataLen = QUSSEE
     C                   eval      StartPos = QUSOLD + 1

      ** Also extract the number of entries on the list
     C                   eval      NoOfEntries = QUSNBRLE

     C                   return    USHeaderInfoDS

      *---------------------------------------------------------------------------------------------
     P GetUSHdr        E
      *---------------------------------------------------------------------------------------------
