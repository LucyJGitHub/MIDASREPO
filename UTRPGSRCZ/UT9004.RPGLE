     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas UT Generate field numbers from field names')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities module                                     *
      *                                                               *
      *  UT9004 - Generate field numbers from field names             *
      *                                                               *
      *  Function:  This module generates a unique number for each    *
      *             field in two files (a header and a detail file)   *
      *             and stores the result in a member in ZAFLDNPD.    *
      *                                                               *
      *  Component of: GENFLDNOS command                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK016             Date 10Jul03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *  Prev Amend No. CUP021             Date 12Nov02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 174858             Date 20Jan00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 147775             Date 17Nov98               *
      *                 CAP004             Date 22OCt98               *
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CPK016 - Release 5 packaging.  Change of IBM APIs at 5.2.    *
      *  CUP021 - Re-write of GENFLDNOS command, to make it file      *
      *           driven and to allow existing members to be extended *
      *           Also don't use DBERRCTL in *PSSR                    *
      *  174858 - Close of file ZAFLDNPD is missing due to fix 147775 *
      *  147775 - General FF API errors: add processing to allow      *
      *           more than one detail file.                          *
      *  CAP004 - APIs phase 3.  Place file ZAFLDNPD under user       *
      *           control to ensure that the member to which it       *
      *           is overriden by the calling CL is the one that is   *
      *           actually opened each time.                          *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** The file to contain the list of field names and numbers (this
      ** will have been overridden by the CL to use the appropriate member)
     F*ZAFLDNPD**UF*A*E***          DISK                                        CAP004
     FZAFLDNPD  UF A E             DISK    USROPN                               CAP004
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
                                                                                              CUP021
      * Include the IBM-supplied data structures for the list APIs user                       CUP021
      *  space generic header                                                                 CUP021
     D*/****COPY QSYSINC/QRPGLESRC,QUSGEN                                                     CUP021
     D/COPY QSYSINC/QRPGLESRC,QUSGEN                                                          CPK016
      *                                                                                       CUP021
      * Include the IBM-supplied data structures for the QUSLFLD API                          CUP021
     D/COPY QSYSINC/QRPGLESRC,QUSLFLD                                                         CPK016
                                                                                              CUP021
      ***Include*the*core-maintained*Prototypes*for*IBM*APIs                           CUP021 CPK016
     D***** UTCPYSRC,IBMAPIS_PR                                                        CUP021 CPK016
     D***** UTCPYSRC,FILEFLDSPR                                                        CUP021 CPK016
 
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
      *                                                                                       CUP021
      * Constant for comparison if input is an extension list                                 CUP021
     D Extend          C                   Const('*EXTEND')                                   CUP021
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of additional detail files                                       147775
     D MoreFilArr      S             20A   DIM(20)                              147775
                                                                                147775
      ** Array of additional detail file formats                                147775
     D MoreFmtArr      S             10A   DIM(20)                              147775
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** ==========
      ** Parameters
 
      ** Header file and library
     D Header          S             20A
 
      ** Detail file and library
     D Detail          S             20A
 
      ** Header file format
     D HeaderFmt       S             10A
 
      ** Detail file format
     D DetailFmt       S             10A
                                                                                147775
      ** Number of additional detail files                                      147775
     D NoOfDetFil      S              2P 0                                      147775
                                                                                              CUP021
      ** Number of records already on file (for extension lists)                              CUP021
     D NbrOfRecords    S              5  0                                                    CUP021
 
      ** End of parameters
      ** =================
 
      ** File fields user space name
     D FieldsUS        S             20A   INZ('FIELDS    QTEMP     ')
 
      ** The record format returned by the API
     D APIFormat       S              8A   INZ('FLDL0100')
 
      ** Whether overrides are to be processed by the API
     D Override        S              1A   INZ('1')
 
      ** Count of fields
     D FieldCount      S              5P 0 INZ(1)
 
      ** Starting position of data in the user space
     D StartPos        S              9B 0 INZ(1)
 
      ** Length of data in user space (initialised to 150 because it is
      ** first used to get the generic header from the user space)
     D DataLen         S              9B 0 INZ(150)
 
      ** Receiver variable for user space generic header
     D GenHeader       S            150A
 
      ** Entry number in detail file and format arrays                          147775
     D EntryNo         S              5P 0                                      147775
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Close the file before opening it, in case it was left open             CAP004
      ** on an earlier call; if there is an error on the close, ignore it.      CAP004
     C                   CLOSE     ZAFLDNPD                             99      CAP004
     C                   OPEN      ZAFLDNPD                                     CAP004
                                                                                CAP004
      ** Reset the field counter to prevent problems on subsequent calls
     C                   RESET                   FieldCount
                                                                                              CUP021
      * Get the header file details to check whether this is an extension                     CUP021
      * list or not                                                                           CUP021
     C     10            Subst     Header        Check            10                          CUP021
                                                                                              CUP021
      ** If this is an extension list, get the last field sequence number;                    CUP021
      ** otherwise process the header file                                                    CUP021
     C                   If        Check = Extend                                             CUP021
     C                   Eval      FieldCount = NbrOfRecords + 1                              CUP021
     C                   Else                                                                 CUP021
 
      ** Retrieve the list of fields in the header file
     C                   CALL      'QUSLFLD'
     C                   PARM                    FieldsUS
     C                   PARM                    APIFormat
     C                   PARM                    Header
     C                   PARM                    HeaderFmt
     C                   PARM                    Override
 
      ** Retrieve the user space header information
     C                   EXSR      GetUSHdr
 
      ** Process the header fields information
     C                   EXSR      GenFldNos
     C                   EndIf                                                                CUP021
      **********                                                                              CUP021
      ***Retrieve the list of fields in the detail file                                       CUP021
     C**********         CALL      'QUSLFLD'                                                  CUP021
     C**********         PARM                    FieldsUS                                     CUP021
     C**********         PARM                    APIFormat                                    CUP021
     C**********         PARM                    Detail                                       CUP021
     C**********         PARM                    DetailFmt                                    CUP021
     C**********         PARM                    Override                                     CUP021
      **********                                                                              CUP021
      ***Retrieve the user space header information                                           CUP021
     C**********         EXSR      GetUSHdr                                                   CUP021
      **********                                                                              CUP021
      ***Process the header fields information                                                CUP021
     C**********         EXSR      GenFldNos                                                  CUP021
      **********                                                                CAP004        CUP021
      ***Close*the file to ensure that the correct member override is           CAP004        CUP021
      ***picked*up the next time.                                               CAP004        CUP021
     C**********         CLOSE     ZAFLDNPD                                     CAP004        CUP021
 
                                                                                147775
      ** Process any additional detail files                                    147775
     C                   IF        NoOfDetFil <> 0                              147775
     C**********         OPEN      ZAFLDNPD                                     174858        CUP021
     C                   EXSR      MoreDetail                                   147775
     C                   ENDIF                                                  147775
                                                                                147775
     C                   CLOSE     ZAFLDNPD                                     147775
                                                                                147775
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetUSHdr - Get the user space header information for use by   *
      *            later subroutines                                  *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     GetUSHdr      BEGSR
 
      ** Reset the data length, and start position, as this
      ** routine can be called more than once
     C                   RESET                   DataLen
     C                   RESET                   StartPos
 
     C                   CALL      'QUSRTVUS'
     C                   PARM                    FieldsUS
     C                   PARM                    StartPos
     C                   PARM                    DataLen
     C                   PARM                    GenHeader
 
      ** Put the returned generic header information into the QSYSINC
      ** data structure for it
     C                   MOVEL     GenHeader     QUSH0100
 
      ** The field QUSOLD now contains the offset to the list data section,
      ** and QUSSEE contains the size of each entry; set DataLen up with
      ** this size, and StartPos with the offset + 1
     C                   EVAL      DataLen = QUSSEE
     C                   EVAL      StartPos = QUSOLD + 1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GenFldNos - Retrieve the field names and generate the field   *
      *             numbers                                           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     GenFldNos     BEGSR
 
      ** For EACH entry in the list: retrieve the current entry
      ** (returned into format QUSL0100, which is declared in the QSYSINC
      ** QUSLFLD member); put the field name and current field count
      ** into the field fields; write a record to the file; increment
      ** the field count; and increase the starting position by the entry
      ** length.
 
     C                   DO        QUSNBRLE
     C
     C                   CALL      'QUSRTVUS'
     C                   PARM                    FieldsUS
     C                   PARM                    StartPos
     C                   PARM                    DataLen
     C                   PARM                    QUSL0100
 
      ** Field name is held in QUSFN02 from QUSL0100 data structure
     C                   EVAL      FIELDNAME = QUSFN02
     C                   EVAL      SEQUENCE = FieldCount
 
     C                   WRITE     ZAFLDND0
 
     C                   EVAL      FieldCount = FieldCount + 1
     C                   EVAL      StartPos = StartPos + DataLen
 
     C                   ENDDO
 
     C                   ENDSR
                                                                                147775
      *****************************************************************         147775
      /EJECT                                                                    147775
      *****************************************************************         147775
      *                                                               *         147775
      * MoreDetail - Process additional detail files                  *         147775
      *                                                               *         147775
      *****************************************************************         147775
                                                                                147775
     C     MoreDetail    BEGSR                                                  147775
                                                                                147775
      ** Loop for the number of detail files                                    147775
     C                   DO        NoOfDetFil    EntryNo                        147775
                                                                                147775
      ** Extract the array elements into variables for passing to the API       147775
     C                   EVAL      Detail = MoreFilArr(EntryNo)                 147775
     C                   EVAL      DetailFmt = MoreFmtArr(EntryNo)              147775
                                                                                147775
      ** Retrieve the list of fields in the detail file                         147775
     C                   CALL      'QUSLFLD'                                    147775
     C                   PARM                    FieldsUS                       147775
     C                   PARM                    APIFormat                      147775
     C                   PARM                    Detail                         147775
     C                   PARM                    DetailFmt                      147775
     C                   PARM                    Override                       147775
                                                                                147775
      ** Retrieve the user space header information                             147775
     C                   EXSR      GetUSHdr                                     147775
                                                                                147775
      ** Process the header fields information                                  147775
     C                   EXSR      GenFldNos                                    147775
                                                                                147775
     C                   ENDDO                                                  147775
                                                                                147775
     C                   ENDSR                                                  147775
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
      ** Incoming return code (10A, returned to caller)
     C                   PARM                    RetCodeIn
      ** Header file and library name (20A, from caller)
     C                   PARM                    Header
     ************                                                                             CUP021
     ****Detail*file and library name (20A, from caller)                                      CUP021
     C***********        PARM                    Detail                                       CUP021
      ** Header file format name (10A, from caller)
     C                   PARM                    HeaderFmt
     ****Detail*file format name (10A, from caller)                                           CUP021
     C***********        PARM                    DetailFmt                                    CUP021
      ** Number of additional detail files (5,0P)                               147775
     C                   PARM                    NoOfDetFil                     147775
      ** List of additional files (array of 20x20A)                             147775
     C                   PARM                    MoreFilArr                     147775
      ** List of additional file formats (array of 20x10A)                      147775
     C                   PARM                    MoreFmtArr                     147775
                                                                                147775
      ** Number of records already on file (for extension lists)                              CUP021
     C                   PARM                    NbrOfRecords                                 CUP021
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C*/***** COPY ZACPYSRC,PSSR_ILE                                                          CUP021
     C/COPY ZACPYSRC,PSSR_ILENE                                                               CUP021
                                                                                              CUP021
     C                   Eval      RetCodeIn = '*ERROR'                                       CUP021
     C                   CLOSE     ZAFLDNPD                                                   CUP021
     C                   ENDSR                                                                CUP021
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
