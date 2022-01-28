     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
     H OPTION(*SRCSTMT : *NODEBUGIO)
      *****************************************************************
/*XBI *  CRTSRCPF   FILE(QTEMP/MDBASCRIPT)                            *
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RTVLSTF - Retreive list of files to be replicated via the    *
      *               current Feeder job                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. MD055679           Date 12May20               *
      *                 CRP026             Date 18Jul05               *
      *                 118924 (RoyalBlue) Date 16Oct01               *
      *                        *CREATE                                *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  MD055679 - MQ V9 issue - repmidas jobs.                      *
      *           - Redeliver due to changes in PSSR_ILENE.           *
      *  CRP026 - Feeder rewritten with a new name.                   *
      *  118924 - Improve Feeder performance by using RCVJRNE only    *
      *           on files that are to be replicated.                 *
      *           This module extracts all of the file names from all *
      *           of the relevant MDBASCRIPT members.                 *
      *                                                               *
      *****************************************************************
      /EJECT
     FX4PF      IF   E           K DISK    INFSR(*PSSR)

     FMDBASCRIPTIF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(MDBASCRIPT:ScriptFmt)

      /EJECT
      *****************************************************************

      * +--------------------------------------+
      * ¦ Manually included D-specs            ¦
      * ¦ =========================            ¦
      * +--------------------------------------+

      * +--------------------------------------+
      * ¦ Arrays and Data Structures           ¦
      * ¦ ==========================           ¦
      * +--------------------------------------+

      * +--------------------------------------+
      * ¦ Named constants                      ¦
      * ¦ ===============                      ¦
      * +--------------------------------------+

      *   Dummy condition for do loops
     D Goon            C                   const('true')

      *   Override with Data Base File basic string
     D OVRDBFStart     C                   const('OVRDBF FILE(MDBASCRIPT) MBR(')

      *   Delete Override string
     D DLTOVRString    C                   const('DLTOVR FILE(MDBASCRIPT)')

      *   Open parenthesis
     D OpenParen       C                   const('(')
      *   Close parenthesis
     D CloseParen      C                   const(')')
      *   Single space
     D Space           C                   const(' ')
      *   Forward slash
     D FwdSlash        C                   const('/')

      *   The tag indicating a table (file) name in a MDBASCRIPT member
     D TableTag        C                   const('<TABLE>')

      *   Number of elements in the arrays of file names
     D FilNamsArrMax   C                   const(300)

      *   Command parameter to ensure that journal entries for all file
      *    members are read.
     D MemberAll       C                   const(' *ALL')

      *   RCVJRNE command - parts before and after list of files
     D RCVJRNEPart1    C                   const('RCVJRNE +
     D                                     JRN(')
     D*RCVJRNEPart2    C                   const(' EXITPGM(KMQFDI) +            CRP026
     D***********                          FILE(')                              CRP026
     D RCVJRNEPart2    C                   const(' EXITPGM(RPFEEDER) +          CRP026
     D                                     FILE(')                              CRP026
     D RCVJRNEPart3    C                   const(' RCVRNG(')
     D RCVJRNEPart4    C                   const(' FROMENT(')
     D RCVJRNEPart5    C                   const(' JRNCDE((C *IGNFILSLT) +
     D                                     (U *IGNFILSLT) (R *ALLSLT)) +
     D                                     ENTTYP(DL PT PX UP UB CM RB SC ')
     D RCVJRNEPart6    C                   const(' ENTFMT(*TYPE3) +
     D                                     DELAY(5)')

      * +--------------------------------------+
      * ¦ Declared variables                   ¦
      * ¦ ==================                   ¦
      * +--------------------------------------+

      ** Parameters
      *   Feeder Sequence number - used to select Remote Product records
     D FeederSequence  S              1A

      *   ID of Back Office system - used to select Remote Product records
     D BackOfficeID    S              3A

      *   Values to be substituted into command string built
     D JournalLib      S             10A
     D Journal         S             10A
     D StartReceiver   S             10A
     D FromEntryAlp    S             10A
     D QuitCode        S              2A

      *   Return Code passed back to caller
     D ReturnCode      S             10A

      *   Formatted RCVJRNE passed back to caller
      *     Formatted file names are up to 5400 bytes long and additional
      ******text*is 135 bytes long - use 5600 for neatness.                     CRP026
      *     text is 137 bytes long - use 5600 for neatness.                     CRP026
     D CommandString   S           5600A

      ** Work fields

      *   Override with Data Base File string - to select MDBASCRIPT member
     D OVRDBFString    S             39A

      *   Length of the tag indicating a table name in a MDBASCRIPT member
     D TableTagLen     S              3P 0

      *   Position that the table tag was found in a MDBASCRIPT member
     D TableTagPos     S              3P 0

      *   Table name, extracted after the table tag
     D TableName       S             10A

      *   Arrays of file names extracted from the MDBASCRIPT members ...
     D FilNamsAllArry  S             10A   dim(FilNamsArrMax) inz('ZZZZZZZZZ*')
     D FileNamesTrimArray...
     D                 S             10A   dim(FilNamsArrMax)

      *   ... and the associated indexes
     D AllArrayIdx     S              3P 0 inz(0)
     D TrimArrayIdx    S              3P 0 inz(0)

      *   Table names reformatted for RCVJRNE
      *     Format is FILE((filename1 *ALL) (filename2 *ALL)),
      *     '(filename1 *ALL) ' is up to 18 bytes long and there is a
      *     maximum of 300 entries.  300 x 18 = 5400
     D TableNamesFmt   S           5400A

      *   Command passed to QCMDEXC
      *           - A variable is needed as constants cannot be passed
     D QCMDEXCString   S            256A
      *   Length of command passed to QCMDEXC
     D QCMDEXCLength   S             15P 5

      * +--------------------------------------+
      * ¦ End of D-specs                       ¦
      * ¦ ==============                       ¦
      * +--------------------------------------+
      *****************************************************************

      /EJECT
      *****************************************************************

     C     Start         TAG
      * Note: the above tag is only there to force the first comments in
      * the C-specs to appear after the D- or I-specs in compiled listings.

      * +--- Start of Main processing -----------------------------------+
      * ¦                                                                ¦
      * ¦ Initial processing is performed automatically: the *inzsr is   ¦
      * ¦ executed at program activation.                                ¦
      * ¦                                                                ¦
      * +----------------------------------------------------------------+

      * Read all entries on the Cross Reference file and for each record:
      * - reject if not for the specified Feeder Sequence number
      * - reject if not for the specified Back Office ID
      * - overide to the MDBASCRIPT member related to the Remote Product
      * - open that member
      * - read it to find all table names (i.e. those to be replicated)
      * - close the member
      * When complete, format the names for a RCVJRNE command and add in
      *  the other data to produce a complete RCVJRNE command

     C                   dou       Goon = 'false'

     C                   read      x4pf
     C                   if        %eof
      * End of file - exit loop
     C                   leave
     C                   endif

     C                   if           X4FDNM <> FeederSequence
     C                             or X4UNIT <> BackOfficeID
      * Record not to be processed - go to next one
     C                   iter
     C                   endif

      * Record is wanted - process associated MDBASCRIPT member
     C                   exsr      PrcsScript

     C                   enddo

      * Remove any duplicate file names
     C                   exsr      RmvDuplicates

      * Reformat file names for RCVJRNE command
     C                   exsr      FormatNames

      * Finish formatting command string
     C                   eval      CommandString =
     C                             RCVJRNEPart1 +
     C                             %trim(JournalLib) + FwdSlash +
     C                             %trim(Journal) + CloseParen +
     C                             RCVJRNEPart2 +
     C                             %trim(TableNamesFmt) + CloseParen +
     C                             RCVJRNEPart3 +
     C                             %trim(StartReceiver) + CloseParen +
     C                             RCVJRNEPart4 +
     C                             FromEntryAlp + CloseParen +
     C                             RCVJRNEPart5 +
     C                             QuitCode + CloseParen +
     C                             RCVJRNEPart6

     C                   SETON                                        LR

     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * PrcsScript - Process MDBASCRIPT member associated with        *
      *                 current record                                *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: ReadReformat                                           *
      *                                                               *
      *****************************************************************

     C     PrcsScript    begsr

      * Override to correct MDBASCRIPT member
     C                   eval      OVRDBFString = OVRDBFStart + 'RP' +
     C                              %trim(X4PRDN) + CloseParen

     C                   eval      QCMDEXCString = OVRDBFString
     C                   eval      QCMDEXCLength = %len(OVRDBFString)
     C                   call      'QCMDEXC'
     C                   parm                    QCMDEXCString
     C                   parm                    QCMDEXCLength

      * Open member
     C                   open(e)   MDBASCRIPT
     C                   if        %error
     C                   exsr      *PSSR
     C                   endif

      * Read data from MDBASCRIPT member
     C                   exsr      ReadScript
      * Close member
     C                   close(e)  MDBASCRIPT
     C                   if        %error
     C                   exsr      *PSSR
     C                   endif

      * Delete override
     C                   eval      QCMDEXCString = DLTOVRString
     C                   eval      QCMDEXCLength = %len(DLTOVRString)
     C                   call      'QCMDEXC'
     C                   parm                    QCMDEXCString
     C                   parm                    QCMDEXCLength

     C                   endsr
      ********************************************************************

      /EJECT
      *****************************************************************
      *                                                               *
      * ReadScript - Read data from a MDBASCRIPT member               *
      *                                                               *
      * Called by: PrcsScript                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     ReadScript    begsr

      * Read all entries in the MDBASCRIPT member, looking for file name,
      * (which will be like <TABLE>filename1)
      * and store those names in an array for further processing.

     C                   eval      TableTagLen = %len(TableTag)

     C                   dou       Goon = 'false'

     C                   read      MDBASCRIPT
     C                   if        %eof
      * End of file - exit loop
     C                   leave
     C                   endif

      * Look for <TABLE> - discard record if not found
     C                   eval      TableTagPos = %scan(TableTag : SRCDTA)
     C                   if        TableTagPos = 0
     C                   iter
     C                   endif

      * Tag <TABLE> was found - extract table name that follows it and
      *  store for later processing
     C                   eval      TableName = %trim(%subst(SRCDTA :
     C                                TableTagPos + TableTagLen))
     C                   eval      AllArrayIdx = AllArrayIdx + 1
     C                   eval      FilNamsAllArry(AllArrayIdx) =
     C                                TableName

     C                   enddo

     C                   endsr
      ********************************************************************

      /EJECT
      *****************************************************************
      *                                                               *
      * RmvDuplicates - Remove Duplicate entries from file names      *
      *                                                               *
      * Called by: PrcsScript                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     RmvDuplicates begsr

      * All file names have been extracted and stored in an array,
      *  however there may be some duplicates, if the same file is being
      *  replicated for more than one interface.
      *  So, sort the array and trim out duplicates by moving unique names
      *  to another array.

     C                   sorta     FilNamsAllArry

      * If there are no names in the script(s), shown by the first array
      *  entry being end marker, report an error and exit.
     C                   if        FilNamsAllArry(1) = 'ZZZZZZZZZ*'
     C                   eval      ReturnCode = 'NoFiles'
     C                   exsr      *pssr
     C                   endif

      * If we get to here there is data to process
     C                   eval      FileNamesTrimArray(1) = FilNamsAllArry(1)
     C                   eval      TrimArrayIdx = 2

     C     2             do        FilNamsArrMax AllArrayIdx

     C                   if        FilNamsAllArry(AllArrayIdx) = 'ZZZZZZZZZ*'
      * End of data so exit loop
     C                   leave
     C                   endif

     C                   if        FilNamsAllArry(AllArrayIdx) =
     C                             FileNamesTrimArray(TrimArrayIdx - 1)
      * Current entry in All array is already in Trim array so bypass
     C                   iter
     C                   endif

      * Current entry in All array is not in Trim array so copy in
     C                   eval      FileNamesTrimArray(TrimArrayIdx) =
     C                                FilNamsAllArry(AllArrayIdx)
     C                   eval      TrimArrayIdx = TrimArrayIdx + 1

     C                   enddo

     C                   endsr
      ********************************************************************

      /EJECT
      *****************************************************************
      *                                                               *
      * FormatNames - Reformat file names ready for RCVJRNE command   *
      *                                                               *
      * Called by: PrcsScript                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     FormatNames   begsr

      * Reformat the names in the Trimmed array ready for a RCVJRNE command,
      *  which needs them like FILE((filename1 *ALL) (filename2 *ALL))

     C     1             do        FilNamsArrMax TrimArrayIdx
     C                   if        FileNamesTrimArray(TrimArrayIdx)
     C                                                          = *blank
      * End of data so exit loop
     C                   leave
     C                   endif

      * Add reformatted table name to accumulated list of files
     C                   eval      TableNamesFmt = %trim(TableNamesFmt) +
     C                               Space + OpenParen +
     C                               %trim(FileNamesTrimArray(TrimArrayIdx)) +
     C                               MemberAll + CloseParen

     C                   enddo

     C                   endsr
      ********************************************************************

      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *inzsr        begsr

     C     *entry        plist
     C                   parm                    FeederSequence
     C                   parm                    BackOfficeID
     C                   parm                    JournalLib
     C                   parm                    Journal
     C                   parm                    StartReceiver
     C                   parm                    FromEntryAlp
     C                   parm                    QuitCode
     C                   parm                    ReturnCode
     C                   parm                    CommandString

     C                   endsr
      ********************************************************************

     C/EJECT
      ********************************************************************
      *--------------------------------------------------------------------
      * The following /COPY contains the program status subroutine
      * without a RETURN or ENDSR.
     C/COPY RPCPYSRC,PSSR_ILENE

     C                   IF        ReturnCode = *BLANK
     C                   EVAL      ReturnCode = 'Error'
     C                   ENDIF

     C                   RETURN

     C                   ENDSR
      *--------------------------------------------------------------------
      *****************************************************************

