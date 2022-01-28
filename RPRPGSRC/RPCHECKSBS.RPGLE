     H NOMAIN
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RPCHECKSBS - Routines for checking active state of a         *
      *               subroutine and jobs within it.                  *
      *                                                               *
      *  Function:  This module contains procedures which check       *
      *             the active state of a subsystem and of a job      *
      *             or jobs within it.                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. CRP026             Date 18Jul05               *
      *                 188295             Date 09Jan01               *
      *                 177251  *CREATE    Date 06Apr00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  CRP026 - Test for Feeder(s) active changed as Feeder name    *
      *           has changed as part of rewrite.                     *
      *  188295 - Prevent restart messages being sent if the          *
      *           subsystem or the launch job is not active.  A new   *
      *           procedure was added to this module, which required  *
      *           that a block of D-specs be moved from an existing   *
      *           subprocedure to the global definitions.  This was   *
      *           done without commenting the deleted versions out,   *
      *           so as not to clutter up the code.                   *
      *  177251 - This fix required that we check the activity        *
      *           state of a subsystem and its jobs.                  *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the error structure used by many
      ** system APIs.
     D/COPY QSYSINC/QRPGLESRC,QUSEC
      /if defined(DebugMode)
     D QUSExcData             17     46
      /endif
      **--------------------------------------------------------------------------------------------

      * The following /COPY contains (mainly) procedure prototypes for
      * this module
      /COPY RPCPYSRC,SBSCHECK

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

      * --------------------------------------------------------------------    188295
      * 188295: Definitions moved from the AreFeederJobsActive() procedure
      * to here, because they are needed by more than one procedure.
      * --- start of moved definitions...
      * Name and text of user space to contain list of active jobs
     D JobUserSpace    S             20A   inz('JOBLIST   QTEMP')
     D JobUSText       C                   'List of active jobs'

      * The first of these pointers will contain the address of the
      * first byte of the user space (retrieved using an API).  The
      * second is a work one, which will be moved through the user space
      * by increments of the length of the entries.  The JobEntryDS data
      * structure is based on the latter pointer, which means that it
      * contains the data from the address that the pointer holds at
      * any time.
     D pUSJobStart     S               *
     D pUSJobPointer   S               *

      ** -----------------------------------------------------------------------
      ** Definition for the JOBL0200 format.
      ** This is copied from the QUSLJOB member in QSYSINC/QRPGLE, and
      ** modified to meet the requirements of the present functions.
      ** -----------------------------------------------------------------------
     DJobEntryDS       DS                  based(pUSJobPointer)
     D*                                             Qus JOBL0200
     D QUSJNU                  1     10
     D*                                             Job Name Used
     D QUSUNU                 11     20
     D*                                             User Name Used
     D QUSJNBRU               21     26
     D*                                             Job Number Used
     D QUSIJI00               27     42
     D*                                             Internal Job Id
     D QUSTATUS01             43     52
     D*                                             Status
     D QUSJT01                53     53
     D*                                             Job Type
     D QUSJS00                54     54
     D*                                             Job Subtype
     D QUSERVED18             55     56
     D*                                             Reserved
     D QUSJIS                 57     57
     D*                                             Job Info Status
     D QUSRSV205              58     60
     D*                                             Reserved2
     D QUSNBRFR               61     64B 0
     D*                                             Number Fields Rtnd
     D  QLenFldInfo           65     68B 0
     D*                                             Length of field info
     D  QKeyFld               69     72B 0
     D*                                             Key field
     D  QType                 73     73
     D*                                             Type of data
     D  QReserved             74     76
     D*                                             Reserved
     D  QDataLen              77     80B 0
     D*                                             Length of data
     D  QData                 81     90
     D*                                             Data
     D  QReserved2            91     91

      * --- ... end of moved definitions -----------------------------------    188295

      ** +--------------------------------------+
      ** ¦ End of global D-specs                ¦
      ** ¦ =====================                ¦
      ** +--------------------------------------+

      * --------------------------------------------------------------------

      ** +------------------------------------------+
      ** ¦ Prototypes for procedures in this module ¦
      ** ¦ ======================================== ¦
      ** +------------------------------------------+
     D ListActiveSubsystems...
     D                 PR
     D UserSpace                     20A

      * --------------------------------------------------------------------
      * Procedure interface for IsSbsActive
      * -----------------------------------
     P IsSbsActive     B                   export
     D IsSbsActive     PI             2A
     D  Subsystem                    10A   const
      * --------------------------------------------------------------------

      * Name and text of user space to contain list of active subsystems
     D SbsUserSpace    s             20A   inz('SBSLIST   QTEMP')
     D SbsUSText       C                   'List of active subsystems'

      * The first of these pointers will contain the address of the
      * first byte of the user space (retrieved using an API).  The
      * second is a work one, which will be moved through the user space
      * by increments of the length of the entries.  The SbsName field
      * is based on the latter pointer, which means that it contains the
      * the data (ten bytes) from the address that the pointer holds at
      * any time.
     D pUSSbsStart     S               *
     D pUSSbsPointer   S               *
     D SbsName         S             10A   based(pUSSbsPointer)

      * --------------------------------------------------------------------

      * Create a user space to contain the lis of active subsystems
     C                   callp     CrtUsrSpc(SbsUserSpace : SbsUSText)

      * Populate the user space with the list of active subsystems
     C                   callp     ListActiveSubsystems(SbsUserSpace)

      * Retrieve the generic header from the user space
     C                   eval      USHeaderInfoDS = GetUSHdr(SbsUserSpace)

      * Scan for the subsystem name from the beginning to the end of the
      * entries; first set the pointer to the address of the first byte of
      * data:
      * Retrieve a pointer to the use space
     C                   callp     RtvPtr(SbsUserSpace : pUSSbsStart : QUSEC)

      * Add the offset to the list data section, retrieved from the
      * generic header, to the pointer (the offset is one less than the
      * start position).
     C                   eval      pUSSbsPointer =
     C                                pUSSbsStart + StartPos - 1

      * Loop through the populated part of the space, checking for the
      * subsystem name.  The end condition of this do-until loop is that
      * the pointer has reached a value greater than or equal to the
      * start of the user space plus the offset to the start of the list#
      * data plus the product of the entry length and the number of entries;
      * when this condition becomes true, we have moved past the list data.
     C                   dou       pUSSbsPointer >=
     C                                pUSSbsStart + (StartPos - 1) +
     C                                (DataLen * NoOfEntries)

      * If an entry matches the requested subsystem name, return a positive
      * response.
     C                   if        SbsName = Subsystem
     C                   return    'Y'
     C                   endif

      * Increment the pointer position by the length of one data element
     C                   eval      pUSSbsPointer = pUSSbsPointer + DataLen

     C                   enddo
      *                  (End of "loop through the populated part of the
      *                   user space)

      * If we have reached this point, the relevant subsystem name was not
      * found, so indicate this to the caller
     C                   return    'N'


      * --------------------------------------------------------------------
     P IsSbsActive     E
      * --------------------------------------------------------------------

      * --------------------------------------------------------------------
     P ListActiveSubsystems...
     P                 B
     D ListActiveSubsystems...
     D                 PI
     D UserSpace                     20A
      * --------------------------------------------------------------------

      * Format of the generated list of active subsystems
     D SbsFormat       S              8A   INZ('SBSL0100')

      * --------------------------------------------------------------------

      ** Clear the returned error structure before passing it, as some
      ** APIs appear not to clear out old error message IDs.
     C                   clear                   QUSEC

     C                   call      'QWCLASBS'
      **                                      User space name
     C                   parm                    UserSpace
      **                                      Format of the generated list
     C                   parm                    SbsFormat
      **                                      Error structure
     C                   parm                    QUSEC

      * --------------------------------------------------------------------
     P ListActiveSubsystems...
     P                 E
      * --------------------------------------------------------------------


      *****************************************************************
      /EJECT
      *****************************************************************

      * --------------------------------------------------------------------
      * Procedure interface for AreFeederJobsActive
      * -------------------------------------------
     P AreFeederJobsActive...
     P                 B                   export
     D AreFeederJobsActive...
     D                 PI             2A
     D  Subsystem                    10A   const
      * --------------------------------------------------------------------

      * Definitions moved to the global area, because they are needed           188295
      * by more than one procedure.                                             188295

     D JobNameDS       DS
      * Data structure to split up a job name in the way that we are
      * interesred in
     D JobName1                       1A   overlay(JobNameDS)
     D JobNameFeed                    4A   overlay(JobNameDS : 5)
     D JobNameRPFEEDER...                                                       CRP026
     D                                8A   overlay(JobNameDS : 1)               CRP026

      * --------------------------------------------------------------------

      * Create a user space to contain the list of active jobs
     C                   callp     CrtUsrSpc(JobUserSpace : JobUSText)

      * Populate the user space with the list of active subsystems
     C                   callp     ListActiveJobs(JobUserSpace)

      * Retrieve the generic header from the user space
     C                   eval      USHeaderInfoDS = GetUSHdr(JobUserSpace)

      * Scan for the subsystem name from the beginning to the end of the
      * entries; first set the pointer to the address of the first byte of
      * data:
      * Retrieve a pointer to the use space
     C                   callp     RtvPtr(JobUserSpace : pUSJobStart : QUSEC)

      * Add the offset to the list data section, retrieved from the
      * generic header, to the pointer (the offset is one less than the
      * start position).
     C                   eval      pUSJobPointer =
     C                                pUSJobStart + StartPos - 1

      * Loop through the populated part of the space, checking for the
      * subsystem name.
     C                   dou       pUSJobPointer >=
     C                                pUSJobStart + (StartPos - 1) +
     C                                (DataLen * NoOfEntries)

      * If an entry matches the requested subsystem name, check for the job
      * having the layout we are interested in (MxxxFEEDn)
     C                   if        QData = Subsystem

      * Split the job name up into its componenent parts...
     C                   eval      JobNameDS = QUSJNU

      * ... and test them
     C                   if        JobName1 = 'M' AND JobNameFeed = 'FEED'
     C                             OR JobNameRPFEEDER ='RPFEEDER'               CRP026

      * We have found a feeder job in the subsystem we are interested in,
      * so end with a positive code
     C                   return    'Y'

     C                   endif
     C                   endif
      *                  (End of "If entry matches requested subsystem")

      * Not a job we are interested in, so increment the pointer by the
      * length of one data element and continue processing.
     C                   eval      pUSJobPointer = pUSJobPointer + DataLen

     C                   enddo
      *                  (End of "loop through the populated part of the
      *                   user space)

      * If the do loop ends without hitting the return above, no feeder
      * jobs in our subsystem were found; end with a negative code
     C                   return    'N'

      * --------------------------------------------------------------------
     P AreFeederJobsActive...
     P                 E
      * --------------------------------------------------------------------

      * --------------------------------------------------------------------
      * Procedure interface for ListActiveJobs
      * --------------------------------------
     P ListActiveJobs  B
     D ListActiveJobs  PI
     D  UserSpace                    20A   value
      * --------------------------------------------------------------------

      ** Format of the generated list of active jobs
     D JobFormat       S              8A   INZ('JOBL0200')

      ** Qualified job name for job list API
     D AllJobs         S             26A   INZ('*ALL      *ALL      *ALL  ')

      ** Job status for job list API
     D Active          S             10A   INZ('*ACTIVE')

      ** Job type for job list API
     D JobType         S              1A   INZ('*')

      ** Number of fields to return for job list API
     D NoOfFields      S             10I 0 INZ(1)

      * Array of field keys to return, for job list API (the field key
      * of 1906 tells the API that we want the subsytem name to be
      * included as part of the returned data).
     D FieldKeyArr     S             10I 0 dim(1) INZ(1906)

      * --------------------------------------------------------------------

      ** Clear the returned error structure before passing it, as some
      ** APIs appear not to clear out old error message IDs.
     C                   clear                   QUSEC

     C                   call      'QUSLJOB'
      **                                      User space name
     C                   parm                    UserSpace
      **                                      Format of the generated list
     C                   parm                    JobFormat
      **                                      Qualified job name
     C                   parm                    AllJobs
      **                                      Status
     C                   parm                    Active
      **                                      Error structure
     C                   parm                    QUSEC
      **                                      Job type
     C                   parm                    JobType
      **                                      Number of fields to return
     C                   parm                    NoOfFields
      **                                      Keys of fields to return
     C                   parm                    FieldKeyArr


      * --------------------------------------------------------------------
     P ListActiveJobs  E
      * --------------------------------------------------------------------

      *****************************************************************
      /EJECT
      *****************************************************************

      * --------------------------------------------------------------------    188295
      * Procedure interface for IsLaunchJobActive                               188295
      * -----------------------------------------                               188295
     P IsLaunchJobActive...                                                     188295
     P                 B                   export                               188295
     D IsLaunchJobActive...                                                     188295
     D                 PI             2A                                        188295
     D  Subsystem                    10A   const                                188295
      * --------------------------------------------------------------------    188295
                                                                                188295
      * The name of the launch job                                              188295
     D LAUNCH_JOB_NAME...                                                       188295
     D                 C                   'MDBALAUNCH'                         188295
                                                                                188295
      * --------------------------------------------------------------------    188295
                                                                                188295
      * Create a user space to contain the list of active jobs                  188295
     C                   callp     CrtUsrSpc(JobUserSpace : JobUSText)          188295
                                                                                188295
      * Populate the user space with the list of active jobs                    188295
     C                   callp     ListActiveJobs(JobUserSpace)                 188295
                                                                                188295
      * Retrieve the generic header from the user space                         188295
     C                   eval      USHeaderInfoDS = GetUSHdr(JobUserSpace)      188295
                                                                                188295
      * Scan for the subsystem name from the beginning to the end of the        188295
      * entries; first set the pointer to the address of the first byte of      188295
      * data:                                                                   188295
      * Retrieve a pointer to the use space                                     188295
     C                   callp     RtvPtr(JobUserSpace : pUSJobStart : QUSEC)   188295
                                                                                188295
      * Add the offset to the list data section, retrieved from the             188295
      * generic header, to the pointer (the offset is one less than the         188295
      * start position).                                                        188295
     C                   eval      pUSJobPointer =                              188295
     C                                pUSJobStart + StartPos - 1                188295
                                                                                188295
      * Loop through the populated part of the space, checking for the          188295
      * subsystem name.                                                         188295
     C                   dou       pUSJobPointer >=                             188295
     C                                pUSJobStart + (StartPos - 1) +            188295
     C                                (DataLen * NoOfEntries)                   188295
                                                                                188295
      * If an entry matches the requested subsystem name, check for the job     188295
      * being the launch job.                                                   188295
     C                   if        QData = Subsystem                            188295
                                                                                188295
     C                   if        QUSJNU = LAUNCH_JOB_NAME                     188295
                                                                                188295
      * We have found a launch job in the subsystem we are interested in,       188295
      * so end with a positive code                                             188295
     C                   return    'Y'                                          188295
                                                                                188295
     C                   endif                                                  188295
     C                   endif                                                  188295
      *                  (End of "If entry matches requested subsystem")        188295
                                                                                188295
      * Not a job we are interested in, so increment the pointer by the         188295
      * length of one data element and continue processing.                     188295
     C                   eval      pUSJobPointer = pUSJobPointer + DataLen      188295
                                                                                188295
     C                   enddo                                                  188295
      *                  (End of "loop through the populated part of the        188295
      *                   user space")                                          188295
                                                                                188295
      * If the do loop ends without hitting the return above, no launch         188295
      * job was found in our subsystem; end with a negative code                188295
     C                   return    'N'                                          188295
                                                                                188295
      * --------------------------------------------------------------------    188295
     P IsLaunchJobActive...                                                     188295
     P                 E                                                        188295
      * --------------------------------------------------------------------    188295

