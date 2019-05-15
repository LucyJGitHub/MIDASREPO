     H DEBUG NOMAIN
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas UT File fields description procedures')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities module                                     *
      *                                                               *
      *  UTFIELDS - This module contains procedures for handling file *
      *             field descriptions.                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK016             Date 10Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 29May01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP014  *CREATE    Date 08Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK016 - Release 5 packaging.  Change of IBM APIs at 5.2.    *
      *  CSD006 - Remove second level /COPYs, and /COPYs not          *
      *           maintained in core.                                 *
      *  CAP014 - Repair function enhancements                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      * --------------------------------------------------------------------
      **The*following*/COPY*includes*the*structure*for*the*QUSFLD*API,*********               CSD006
      **which*is*used*by*procdures*called*from*this*procedure,*and*************               CSD006
      **one*of*the*structures*is*returned*to*this*procedure.*******************               CSD006
      ****/if*not*defined(QUSLFLD_included)************************************               CSD006
      ****/define*QUSLFLD_included*********************************************               CSD006
     D****/COPY*QSYSINC/QRPGLESRC,QUSLFLD                                                     CSD006
      ****/endif***************************************************************               CSD006
      *************************************************************************               CSD006
      **This*one*has*generic*user-space*stuff**********************************               CSD006
      ******/if*not*defined(QUSGEN_included)***********************************               CSD006
      ******/define*QUSGEN_included********************************************               CSD006
     D******/COPY*QSYSINC/QRPGLESRC,QUSGEN                                                    CSD006
      ******/endif*************************************************************               CSD006
      * --------------------------------------------------------------------
     D/COPY QSYSINC/QRPGLESRC,QUSLFLD                                                         CPK016
     D/COPY QSYSINC/QRPGLESRC,QUSGEN                                                          CPK016
 
      **--------------------------------------------------------------------------------------------
      ***The*following*/COPY*line*includes*the*procedure*prototypes*for*the****               CPK016
      ***file*fields*procedures,*and*named*constants*used*by*those*procedures**               CPK016
     D***** UTCPYSRC,FILEFLDSPR                                                               CPK016
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ***The*following*/COPY*line*includes*the*procedure*prototypes*for********               CPK016
      ***various*IBM*APIs.*****************************************************               CPK016
     D***** UTCPYSRC,IBMAPIS_PR                                                               CPK016
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
     DQUSEC            DS                                                                     CPK016
      *                                             Qus EC                                    CPK016
     D QUSBPRV                 1      4B 0                                                    CPK016
      *                                             Bytes Provided                            CPK016
     D QUSBAVL                 5      8B 0                                                    CPK016
      *                                             Bytes Available                           CPK016
     D QUSEI                   9     15                                                       CPK016
      *                                             Exception Id                              CPK016
     D QUSERVED               16     16                                                       CPK016
      *                                             Reserved                                  CPK016
      *QUSED01                17     17                                                       CPK016
      *                                      Varying length                                   CPK016
     D QUSExcData             17     46                                                       CPK016
      *                                      Varying length field Exception Data              CPK016
                                                                                              CPK016
      ** The prototype for the GenFileFldList procedure                                       CPK016
      ** ----------------------------------------------                                       CPK016
      *                                                                                       CPK016
      ** The procedure returns a ten-alpha handle, which the other                            CPK016
      ** procedures use to refer to the correct data.  It receives a                          CPK016
      ** qualified file name.                                                                 CPK016
     D GenFileFldList  PR            10A                                                      CPK016
     D  QualFileName                 20A   value                                              CPK016
      *                                                                                       CPK016
      ** The prototype for the GetNextFldEnt procedure                                        CPK016
      ** ---------------------------------------------                                        CPK016
                                                                                              CPK016
      ** The procedure receives the ten-alpha handle which was returned by                    CPK016
      ** GenFileFldList, and returns either an API data structure, or                         CPK016
      ** an error code.                                                                       CPK016
     D GetNextFldEnt   PR                  LIKE(QUSL0100)                                     CPK016
     D  FileHandle                   10A   value                                              CPK016
                                                                                              CPK016
     D QFields         PR                  EXTPGM('QUSLFLD')                                  CPK016
     D  QualUSpace                   20A   CONST                                              CPK016
      **          The qualified name of the user space to use                                 CPK016
     D  Format                        8A   CONST                                              CPK016
      **      The record format to return                                                     CPK016
     D  QualFile                     20A   CONST                                              CPK016
      **        The qualified name of the file being processed                                CPK016
     D  RecordFormat                 10A   CONST                                              CPK016
      **            The record format of the file being processed                             CPK016
     D  Override                      1A   CONST                                              CPK016
      **        Whether or not to apply overrides                                             CPK016
     D  QErrStruct                         LIKE(QUSEC)                                        CPK016
      **     The standard API error structure                                                 CPK016
                                                                                              CPK016
      ** -------------------------------------------------------------------                  CPK016
      ** The QUSCRTUS (Create user space) API                                                 CPK016
      ** ------------------------------------                                                 CPK016
     D QUSCRTUS        PR                  EXTPGM('QUSCRTUS')                                 CPK016
     D  QualUSpace                   20A   CONST                                              CPK016
      **          The qualified name of the user space to create                              CPK016
     D  ExtAttr                      10A   CONST                                              CPK016
      **       The extendard attribute of the user space                                      CPK016
     D  InitialSize                   9B 0 CONST                                              CPK016
      **           The initial size of the user space                                         CPK016
     D  InitialValue                  1A   CONST                                              CPK016
      **            The initial value of every byte in the user space                         CPK016
     D  PublicAut                    10A   CONST                                              CPK016
      ** The public authority to the user space                                               CPK016
     D  Text                         51A   CONST                                              CPK016
      **    The text description of the user space                                            CPK016
     D  Replace                      10A   CONST                                              CPK016
      **       Whether or not to replace an existing user space                               CPK016
     D  QErrStruct                         LIKE(QUSEC)                                        CPK016
      **     The standard API error structure                                                 CPK016
                                                                                              CPK016
      ** -------------------------------------------------------------------                  CPK016
      ** The QUSRTVUS (Retrieve user space) API                                               CPK016
      ** --------------------------------------                                               CPK016
     D QUSRTVUS        PR                  EXTPGM('QUSRTVUS')                                 CPK016
     D  QualUSpace                   20A   CONST                                              CPK016
      **          The qualified name of the user space to retrieve                            CPK016
     D  StartPos                      9B 0 CONST                                              CPK016
      **        Start position of data to retrieve                                            CPK016
     D  DataLen                       9B 0 CONST                                              CPK016
      **        Length of data to retrieve                                                    CPK016
     D  Receiver                   2000A   OPTIONS(*VARSIZE)                                  CPK016
      **        Receiver variable (NOTE: this is set to an arbitrary length,                  CPK016
      **        which should be big enough for all requirements)                              CPK016
     D  QErrStruct                         LIKE(QUSEC)                                        CPK016
      * --------------------------------------------------------------------
      * Named constants
      * ---------------
      *
      * Array size for the file handle arrays
     D BigArraySize    C                   2000
      *
      * Error code returned by the procedures                                                 CPK016
     D APIERR          C                   'APIERR'                                           CPK016
      *
      * Error code to indicate that the array of file handles is full                         CPK016
     D APIFULL         C                   'APIFULL'                                          CPK016
      *
      * End code returned by the procedures                                                   CPK016
     D APIEND          C                   'APIEND'                                           CPK016
      *
      * --------------------------------------------------------------------
      * Standalone fields
      * -----------------
 
      * Array index; held in static storage to ensure continuity over
      * repeated calls.
     D Index           S              5I 0
 
      * Integer for the file handle; held in static storage to ensure
      * continuity over repeated calls.
     D FileHandleInt   S              5I 0
 
 
      * --------------------------------------------------------------------
      * Arrays and data structures
      * --------------------------
 
      * Two large arrays to hold the qualified file names
      * and the file handles allocated to them; held in static storage to
      * ensure continuity over repeated calls.
     D QualFileArr     S             20A   dim( BigArraySize )
     D FileHandleArr   S             10A   dim( BigArraySize )
 
      * Start position, entry length and number of entries in the user
      * space for the current file; all held in static storage to ensure
      * continuity over repeated calls.
     D StartPosArr     S             10I 0 dim( BigArraySize )
     D EntryLenArr     S             10I 0 dim( BigArraySize )
     D NoOfEntsArr     S             10I 0 dim( BigArraySize )
 
      * Number of entries processed for the particular file
     D EntsProcArr     S             10I 0 dim( BigArraySize )
 
      * --------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GenFileFldList - Generate the details of the fields in the    *
      *                  file                                         *
      *                                                               *
      *****************************************************************
     P GenFileFldList  B                   export
     D GenFileFldList  PI            10A
     D  QualFileName                 20A   value
 
      * --------------------------------------------------------------------
      * Standalone fields
      * -----------------
 
      * Short version of the array index to use with ixed-format
      * opcodes.
     D I               S                   like(Index) INZ(1)
 
      * --------------------------------------------------------------------
 
      * Check whether the qualified file name has already had its data
      * generated; if it has, just return the existing file handle.
     C     QualFileName  LOOKUP    QualFileArr(I)                         99
 
      * If the file name was received before and its handle was successfully
      * generated, just return that handle.
     C                   IF        *in99  AND FileHandleArr(I)
     C                                           <> *blanks
     C                   RETURN    FileHandleArr(I)
     C                   ENDIF
 
      * --------------------------------------------------------------------
 
      * First generate the file handle; this is done before the API is
      * called because the handle is used as the user space name for
      * the API.
      * Both the file handle integer and the array index are incremented...
     C                   EVAL      FileHandleInt = FileHandleInt + 1
     C                   EVAL      Index = Index + 1
 
      * If the index has become bigger than the maximum array size,
      * we can generate no more handles; report this error to the caller.
     C                   IF        Index > BigArraySize
     C                   RETURN    APIFULL
     C                   ENDIF
 
      * ... then the file name is put into its array...
     C                   EVAL      QualFileArr( Index ) = QualFileName
 
      * ... and the file handle is generated by concatenating a character
      *     with the integer, and placed in its array.  The %editc BIF is
      *     used, with and edit code of 'X', to convert the integer to
      *     character.
     C                   EVAL      FileHandleArr( Index ) =  'A'
     C                                + %editc( FileHandleInt : 'X' )
 
      * --------------------------------------------------------------------
 
      * Call the system APIs to generate the field description data.  The
      * user space name is the file handle generated above, with QTEMP as
      * the library.  First create the user space:
     C                   CALLP     QUSCRTUS( FileHandleArr(Index) + 'QTEMP' :
     C                                       'FILEFIELDS' : 2000 :
     C                                       X'00' : '*USE' : 'File fields' :
     C                                       '*YES' : QUSEC)
      * (The above gives the user space an initial size of 2000 bytes, with
      * each byte having an initial value of x'00', which is said to give
      * the best performance.  'FILEFIELDS' is the extended attribute of
      * the user space, and the '*YES' means 'replace if already there'.
      * QUSEC is the standard API error structure.)
 
      * If there was an error, reset values and report it to the caller
     C                   IF        QUSEI <> *blanks
     C                   EXSR      ErrExit
     C                   ENDIF
 
      * Next populate the user space with the file fields information:
     C                   CALLP     QFields( FileHandleArr(Index) + 'QTEMP' :
     C                                      'FLDL0100' : QualFileName :
     C                                      '*FIRST' : '1' : QUSEC )
      * (Here 'FLDL0100' is the name of the format (data structure)
      *************************************************************************
      **returned*by*the*API.**This*is*defined*in*a*/COPY*member*from***********               CSD006
      **QSYSINC.**'*FIRST'*means*get*data*for*the*first*format*in*the**********               CSD006
      * returned by the API.  This is defined in the /COPY member                             CSD006
      * FILEFLDSPR.  '*FIRST' means get data for the first format in the                      CSD006
      * file (the API supports multi-format files, but quite frankly, I
      * haven't bothered to deal with them here). '1' means that file
      * overrides should be applied.)
 
      * If there was an error, report it to the caller
     C                   IF        QUSEI <> *blanks
     C                   EXSR      ErrExit
     C                   ENDIF
 
      * Retrieve the generic header information from the user space, to
      * get the start position, entry length and number of entries
     C                   CALLP     QUSRTVUS( FileHandleArr(Index) + 'QTEMP' :
     C                                       1 : %len(QUSH0100) :
     C                                       QUSH0100 : QUSEC )
      * (QUSH0100 is the format for the generic header information that
      * all list APIs put into their user spaces.  1 is the start position
      * of that generic header information.)
 
      * If there was an error, report it to the caller
     C                   IF        QUSEI <> *blanks
     C                   EXSR      ErrExit
     C                   ENDIF
 
      ** The field QUSOLD now contains the offset to the list data section,
      ** QUSSEE contains the size of each entry and QUSNBRLE contains
      ** the number of entries in the list.
     C                   EVAL      StartPosArr(Index) = QUSOLD + 1
     C                   EVAL      EntryLenArr(Index) = QUSSEE
     C                   EVAL      NoOfEntsArr(Index) = QUSNBRLE
 
      * Initialise the array entry for the number of entries processed.
     C                   EVAL      EntsProcArr(Index) = 1
 
 
      * Return the file handle to the caller
     C                   RETURN     FileHandleArr(Index)
 
      * --------------------------------------------------------------------
 
     C     ErrExit       BEGSR
 
      * If there was an error, decrement everything and dump before telling
      * the caller.
     C                   DUMP
     C                   EVAL      FileHandleArr(Index) = *blanks
     C                   EVAL      Index = Index - 1
     C                   EVAL      FileHandleInt = FileHandleInt -1
     C                   RETURN    APIERR
 
     C                   ENDSR
 
      * --------------------------------------------------------------------
 
     P GenFileFldList  E
 
      * --------------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetNextFldEnt - Get the next field entry for a given file     *
      *                                                               *
      *****************************************************************
     P GetNextFldEnt   B                   export
     D GetNextFldEnt   PI                  LIKE(QUSL0100)
     D  FileHandle                   10A   value
 
      * --------------------------------------------------------------------
      * Named constants
      * ---------------
 
      * Local version of BigArraySize; redefined here because the compiler
      * does not recognise named constants as global.
     D BigArraySize    C                   2000
 
 
      * --------------------------------------------------------------------
      * Arrays and data structures
      * --------------------------
 
      * Short-named copy of the array to use with fixed-format opcodes.
     D FHArray         S                   like( FileHandleArr )
     D                                     dim( BigArraySize )
 
      * Use the file handle to look up the relevant array; this will set
      * the index for all the other arrays, too.  First copy the array to
      * short-named one, for use with the fixed-format opcode.
     C                   MOVEA     FileHandleArr FHArray
     C     FileHandle    LOOKUP    FHArray(Index)                         99
 
      * If the file handle was not found in the array, we have been passed
      * an invalid handle; this is unlikely, but must be dealt with tidily.
     C                   IF        NOT *in99
     C                   DUMP
     C                   RETURN    APIERR
     C                   ENDIF
 
      * If the number of entries processed has passed the number of
      * entries in the user space, indicate this to the caller.
     C                   IF        EntsProcArr(Index) > NoOfEntsArr(Index)
     C                   RETURN    APIEND
     C                   ENDIF
 
      * Retrieve the next batch of data from the user space.
      * Use the function %Len, as the entry length may change between                         CSD006
      * OS/400 release levels.                                                                CSD006
      *********************************                                                       CSD006
     C*******************CALLP*****QUSRTVUS( FileHandleArr(Index) + 'QTEMP' :                 CSD006
     C*********************************      StartPosArr(Index) :                             CSD006
     C*********************************      EntryLenArr(Index) :                             CSD006
     C*********************************      QUSL0100 : QUSEC )                               CSD006
     C                   CALLP     QUSRTVUS( FileHandleArr(Index) + 'QTEMP' :
     C                                       StartPosArr(Index) :
     C                                       %len(QUSL0100) :
     C                                       QUSL0100 : QUSEC )                               CSD006
 
      * If there was an error, report it to the caller
     C                   IF        QUSEI <> *blanks
     C                   DUMP
     C                   RETURN    APIERR
     C                   ENDIF
 
      * Otherwise increment the number of entries processed, increase the
      * current starting position by the entry length to get the next
      * starting position, and return the API structure.
     C                   EVAL      EntsProcArr(Index) = EntsProcArr(Index)
     C                                + 1
     C                   EVAL      StartPosArr(Index) = StartPosArr(Index)
     C                                + EntryLenArr(Index)
     C                   RETURN    QUSL0100
 
     P GetNextFldEnt   E
