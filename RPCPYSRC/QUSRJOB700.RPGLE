      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  QUSRJOB700 - Version of the JOBI0700 fmt                     *
      *                                                               *
      *  Function:  This member contains our version of the JOBI0700  *
      *  format used by the QUSRJOBI API. The JOBI0700 format         *
      *  contains basic job information and library list information  *
      *  It is needed in this form so that the necessary arrays can   *
      *  be incorporated at the end of it with minimal difficulty.    *
      *                                                               *
      *  This member is mainly a copy of part of the QUSRJOBI include *
      *  supplied by IBM.                                             *
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

      /if not defined(QUSRJOB700_Included)
      /define QUSRJOB700_Included

     D******************************************************************
     D*Record structure for QUSRJOBI JOBI0700 format
     D****                                                           ***
     D*NOTE: The following type definition only defines the fixed
     D*  portion of the format.  Any varying length field will
     D*  have to be defined by the user.
     D******************************************************************
     DQUSQLL           DS
     D*                                             Qwc Lib List
     D QUSLN01                 1     11
     D*                                             Lib Name
     DQUSI0700         DS
     D*                                             Qwc JOBI0700
     D QUSBR06                 1      4B 0
     D*                                             Bytes Return
     D QUSBA06                 5      8B 0
     D*                                             Bytes Avail
     D QUSJN09                 9     18
     D*                                             Job Name
     D QUSUN08                19     28
     D*                                             User Name
     D QUSJNBR08              29     34
     D*                                             Job Number
     D QUSIJID06              35     50
     D*                                             Int Job ID
     D QUSJS17                51     60
     D*                                             Job Status
     D QUSJT09                61     61
     D*                                             Job Type
     D QUSJS18                62     62
     D*                                             Job Subtype
     D QUSERVED31             63     64
     D*                                             Reserved
     D QUSLIS                 65     68B 0
     D*                                             Libs In Syslibl
     D QUSPL                  69     72B 0
     D*                                             Prod Libs
     D QUSCL01                73     76B 0
     D*                                             Curr Libs
     D QUSLIU                 77     80B 0

     D*  The following entry is a marker (from the IBM originla) to make
     D*  it clear that the user must add a entry that will contain the
     D*  name of the libraries in the library list.
     D*                                             Libs In Usrlibl
     D*QUSLIB                        11    DIM(00001)
     D* QUSLN00                      11    OVERLAY(QUSLIB:00001)
     D*
     D*                             Varying length

      /endif
