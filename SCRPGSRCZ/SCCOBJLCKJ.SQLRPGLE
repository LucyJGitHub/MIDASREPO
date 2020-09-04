     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd 2013')
      *****************************************************************
/*XBIA*  DSPOBJD OBJ(*LIBL/SDBANKPD) OBJTYPE(*FILE)                   *
/*XBIA*  OUTPUT(*OUTFILE) OUTFILE(QTEMP/DSPOBJD)                      *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SC Check if objects are locked')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCCOBJLCKJ - Midas SC Check if objects are locked            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd 2013             *
      *                                                               *
      *  Last Amend No. MD021351  *CREATE  Date 19Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD021351 - Design for Kill object locks                      *
      *                                                               *
      *****************************************************************
     FDSPOBJD   IF   E             DISK
     F                                     USROPN
     FOBJECTLOCKO    E             DISK    RENAME(OBJECTLOCK:OBJLCKOUT)
     F                                     USROPN
 
      ** Common Structure for IBM API Error Code Parm
 
     D/COPY QSYSINC/QRPGLESRC,QUSEC
 
      ** Parameter for creating user space (QUSCRTUS)
 
     D SpaceName       DS
     D                               10    INZ('SCCOBJLCKR')
     D                               10    INZ('QTEMP     ')
     D Attribute       S             10    INZ('MISYS     ')
     D InitSize        S              9B 0 INZ(99999)
     D InitValue       S              1    INZ(x'00')
     D Authority       S             10    INZ('*ALL')
     D Text            S             50    INZ('Object locks')
     D Replace         S             10    INZ('*YES')
     D Domain          S             10    INZ('*USER')
 
      ** Parameters for finding object locks (QWCLOBJL)
 
     D Format          S              8    INZ('OBJL0100')
     D ObjectName      DS
     D Object                        10
     D ObjectLib                     10
     D ObjectType      S             10
     D MemberName      S             10
 
      ** Returned information from object lock API (QWCLOBJL)
      ** The OBJL0100 format
 
     D LockInfo        DS                  BASED(ListPtr)
     D JobName                       10
     D JobUser                       10
     D JobNumber                      6
     D LockState                     10
     D LockStatus                     9b 0
     D LockType                       9b 0
     D LockMember                    10
     D Share                          1
     D Reserved                       1
 
      ** Parameters for finding the pointer to the userspace (QUSPTRUS)
      ** filled by QWCLOBJL
 
     D Ptr             S               *
     D SpaceDS         DS                  BASED(Ptr)
     D SpaceField                 32767
     D SpaceArray                     1    OVERLAY(SpaceField) DIM(32767)
     D SpaceOffset                    9B 0 OVERLAY(SpaceField:125)
     D NumberEntry                    9B 0 OVERLAY(SpaceField:133)
     D SizeEntry                      9B 0 OVERLAY(SpaceField:137)
 
      ** The following data structure is returned by the
      ** QUSRJOBI api using JOBIO600
 
     D jobInfLen       S              4B 0
     D JobInf          DS           512
     D JobUserId              92    101
     D IPAddress             308    322
 
      ** Work fields
 
     D w@command       S           1024
     D w@lgth          S             15  5
     D sqlString       S           1024A
     D w@msg1          S             52A   inz('Do not close down your session,-
     D                                      there are some ')
     D w@msg2          S             52A   inz('locks on the COB. Reopen Input -
     D                                     Cycle will ')
     D w@msg3          S             52A   inz('continue after locks have been -
     D                                     removed.')
 
      ** Main Process
      ** Open the files
 
     C                   EVAL      w@command = 'OVRDBF FILE(OBJECTLOCK) ' +
     C                                         'TOFILE(QTEMP/OBJLCK) ' +
     C                                         'LVLCHK(*NO)'
     C                   EVAL      w@lgth = %LEN(%TRIM(w@command))
     C                   CALL      'QCMDEXC'
     C                   PARM                    w@command
     C                   PARM                    w@lgth
     C                   OPEN      OBJECTLOCK                           98
     C                   IF        *IN98 = *ON
     C                   EXSR      createOutFile
     C                   ELSE
     C                   CLOSE     OBJECTLOCK
     C                   ENDIF
 
      ** Clear the output file
 
     C                   EVAL      w@command = 'CLRPFM ' +
     C                                         'FILE(QTEMP/OBJLCK)'
     C                   EVAL      w@lgth = %LEN(%TRIM(w@command))
     C                   CALL      'QCMDEXC'
     C                   PARM                    w@command
     C                   PARM                    w@lgth
 
      ** Create overrides to the files
 
     C                   EVAL      w@command = 'OVRDBF FILE(DSPOBJD   ) ' +
     C                                         'TOFILE(' +
     C                                         'QTEMP' + '/' +
     C                                         'DSPOBJD   ' + ')'
     C                   EVAL      w@lgth = %LEN(%TRIM(w@command))
     C                   CALL      'QCMDEXC'
     C                   PARM                    w@command
     C                   PARM                    w@lgth
 
     C                   OPEN      DSPOBJD
     C                   OPEN      OBJECTLOCK
 
      ** Delete the user space if it exists
 
     C                   CALL      'QUSDLTUS'
     C                   PARM                    SpaceName
     C                   PARM                    QUSEC
 
      ** Create the user space
 
     C                   CALL      'QUSCRTUS'
     C                   PARM                    SpaceName
     C                   PARM                    Attribute
     C                   PARM                    InitSize
     C                   PARM                    InitValue
     C                   PARM                    Authority
     C                   PARM                    Text
     C                   PARM                    Replace
     C                   PARM                    QUSEC
     C                   PARM                    Domain
 
      ** Check for errors on QUSCRTUS
 
     C                   IF        QUSBAVL > 0
     C                   MOVEL     'QUSCRTUS'    APINAM           10
     C                   EXSR      APIERR
     C                   ENDIF
 
      ** Start at the beginning of the file
 
     C     1             SETLL     QLIDOBJD
     C                   READ      QLIDOBJD                               99
 
      ** Loop the file
 
     C                   DOW       *IN99 = *OFF
 
     C                   EVAL      Object = ODOBNM
     C                   EVAL      ObjectLib = ODLBNM
     C                   EVAL      ObjectType = ODOBTP
 
      ** Get object lock information
 
     C     ObjectType    IFEQ      '*FILE'
     C                   EVAL      MemberName = '*ALL'
     C                   ELSE
     C                   EVAL      MemberName = '*NONE'
     C                   ENDIF
 
     C                   CALL      'QWCLOBJL'
     C                   PARM                    SPACENAME
     C                   PARM                    Format
     C                   PARM                    ObjectName
     C                   PARM                    ObjectType
     C                   PARM                    MemberName
     C                   PARM                    QUSEC
 
      ** Check for errors on QWCLOBJL
 
     C                   IF        QUSBAVL > 0
     C                   MOVEL     'QWCLOBJL'    APINAM           10
     C     w@msg1        DSPLY
     C     w@msg2        DSPLY
     C     w@msg3        DSPLY
     C                   ENDIF
 
      ** Get a pointer to the user-space
 
     C                   CALL      'QUSPTRUS'
     C                   PARM                    SpaceName
     C                   PARM                    Ptr
 
      ** Spacefield now contains the info stored in the userspace, we need to access it
 
     C                   EVAL      SpaceOffset = SpaceOffset + 1
     C                   EVAL      listPtr = %Addr(SpaceArray(SpaceOffset))
 
      ** If there are still locks then need to tell the user
 
     C                   DO        NumberEntry
 
      ** Set up the parameters for the QUSRJOBI api
 
     C                   EVAL      job = jobName + jobUser + JobNumber
     C                   CLEAR                   JobInf
     C                   EVAL      JobInfLen = %LEN(JobInf)
     C                   EVAL      JobIntId = *BLANKS
 
      ** Call the API to get the IP address
 
     C     LOCKSTATE     IFNE      '*NONE'
     C                   CALL      'QUSRJOBI'                           9999
     C                   PARM                    JobInf
     C                   PARM                    JobInfLen
     C                   PARM      'JOBI0600'    APIfmt            8
     C                   PARM                    Job              26
     C                   PARM                    JobIntId         16
     C                   ENDIF
 
      ** Write the info onto the table
 
     C                   WRITE     OBJLCKOUT
 
      ** Get the next job
 
     C                   EVAL      SpaceOffset = SpaceOffset + SizeEntry
     C                   EVAL      listPtr = %Addr(SpaceArray(SpaceOffset))
     C                   ENDDO
 
      ** Get the next record
 
     C                   READ      QLIDOBJD                               99
     C                   ENDDO
 
      ** Delete the user space if it exists
 
     C                   CALL      'QUSDLTUS'
     C                   PARM                    SPACENAME
     C                   PARM                    QUSEC
 
      ** Leave
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CreateOutFile - Create the specified output file, if         *
      *                  it doesn't exist                             *
      *                                                               *
      *****************************************************************
     C     CreateOutFile BEGSR
 
      ** Create the table
 
     C                   EVAL      sqlString =
     C                             'CREATE TABLE QTEMP/OBJECTLOCK ' +
     C                             '(' +
     C                             'OBJECT CHAR (10) NOT NULL WITH DEFAULT,' +
     C                             'OBJECTLIB CHAR (10) NOT NULL WITH DEFAULT,'+
     C                             'OBJECTTYPE CHAR (10) NOT NULL WITH DEFAULT'+
     C                                                                      ','+
     C                             'JOBNAME CHAR (10) NOT NULL WITH DEFAULT,' +
     C                             'JOBUSER CHAR (10) NOT NULL WITH DEFAULT,' +
     C                             'JOBNUMBER CHAR (6) NOT NULL WITH DEFAULT,' +
     C                             'LOCKSTATE CHAR (10) NOT NULL WITH DEFAULT,'+
     C                             'LOCKSTATUS INT NOT NULL WITH DEFAULT,' +
     C                             'LOCKTYPE INT NOT NULL WITH DEFAULT,' +
     C                             'LOCKMEMBER CHAR (10) NOT NULL WITH DEFAULT'+
     C                                                                      ','+
     C                             'SHARE CHAR (1) NOT NULL WITH DEFAULT,' +
     C                             'JOBUSERID CHAR (10) NOT NULL WITH DEFAULT,'+
     C                             'IPADDRESS CHAR (15) NOT NULL WITH DEFAULT)'
     C                   EXSR      ExecuteSQL
 
      ** Rename the table (this is required to handle a
      ** consistant record fmt name)
 
     C                   EVAL      sqlString =
     C                             'RENAME TABLE QTEMP/OBJECTLOCK ' +
     C                             'TO SYSTEM NAME OBJLCK'
     C                   EXSR      ExecuteSQL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ExecuteSQL - Execute an sql statement, provided in sqlString *
      *                                                               *
      *****************************************************************
     C     ExecuteSQL    BEGSR
 
     C/EXEC SQL WHENEVER SQLERROR GOTO ERREX
     C/END-EXEC
 
      ** Prepare string S with the sqlString
 
     C/EXEC SQL PREPARE S FROM :sqlString
     C/END-EXEC
 
      ** Execute string S
 
     C/EXEC SQL EXECUTE S
     C/END-EXEC
     C                   IF        1 = 0
     C     ERREX         TAG
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
     C                   SETON                                            LR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  APIERR - Log any error encountered, and exit the program     *
      *                                                               *
      *****************************************************************
     C     APIERR        BEGSR
 
     C     APINAM        DSPLY
     C     QUSEI         DSPLY
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   Z-ADD     17            QUSBPRV
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
