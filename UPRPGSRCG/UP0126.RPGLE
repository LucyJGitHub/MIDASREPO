     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Screen handling for CHGJOBDLBL')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP0126 - Screen handling for CHGJOBDLBL                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSC017             Date 26Feb03               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD046248 - Finastra Rebranding                               *
      *  CSC017 - Change library list to 250.                         *
      *                                                               *
      *****************************************************************
      *
      *  File containing list of job descriptions
     FUP0126DF  CF   E             WORKSTN
     F                                     SFILE(UP0126F1:RelRecNo)
      *
      * Main array containing job description library list
     D LIBL            S             14    DIM(251)
     D                                     ASCEND
      * Holding array containing for job description library list
     D LIBL2           S             14    DIM(250)
      * Holding array to look for duplicate entries on library list
     D DUPLIBL         S             13    DIM(251)
     D                                     ASCEND
      * Holding array for the original job description library list
     D ORIGLIBL        S             14    DIM(251)
      *
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *
      * Hold Sequence and Library data from array
     D                 DS
     D  LibraryArray           1     14
     D  SequenceA              1      4
     D  SequenceN              1      4  0
     D  Char1                  1      1
     D  Char2                  2      2
     D  Char3                  3      3
     D  Char4                  3      3
     D  Library                5     14
      *
      * Store Sequence and Library data from array
     D                 DS
     D  SaveLibArray           1     14
     D  SaveSeqA               1      4
     D  SaveSeqN               1      4  0
     D  SChar1                 1      1
     D  SChar2                 2      2
     D  SChar3                 3      3
     D  SaveLib                5     14
      *
      * Store Sequence and Library data to look for duplicate libraries
     D                 DS
     D  SearchArray            1     14
     D  SearchSeqA             1      4
     D  SearchSeqN             1      4  0
     D  SearchLib              5     14
      *
      * Store Library and position in array for duplicate libraries
     D                 DS
     D  DupArray               1     13
     D  DupLib                 1     10
     D  PositionA             11     13
     D  PositionN             11     13  0
      *
      * Data retrieved about data queue
     D DtaQDataDS      DS            80    OCCURS(1)
     D  NoOfMsgs              73     76B 0
      *
      * Data queue name and library
     D DtaQ            DS
     D  DataQueue              1     10
     D  DataQueueLib          11     20
      *
     D DtaQData        S             80
     D BlankSequence   S              1
     D BlankLibrary    S              1
     D DupLibrary      S              1
     D PreviousLib     S             10
     D EndMainLoop     S              1
     D Refresh         S              1
     D MessageID       S              7
     D NoChanges       S              1
     D FstRecWasErr    S              1
     D LibIdx          S              3  0
     D SearchIdx       S              3  0
     D TempIdx         S              3  0
     D LibIdx1         S              3  0
     D LibIdx2         S              3  0
     D LibIdx3         S              3  0
     D SeqIdx1         S              3  0
     D SeqIdx2         S              3  0
     D SeqIdx3         S              3  0
     D RebldIdx        S              3  0
     D RelRecNo        S              5  0
     D ErrRecNo        S              5  0
     D TtlColShifted   S              5  0
     D PageFactor      S              2  0
     D ColumnFactor    S              1  0
      *
      *****************************************************************
      *                                                               *
      *  List of indicators                                           *
      *                                                               *
      *  01 - General validation error message                        *
      *  09 - General validation error message for repeated use       *
      *  42 - Non-display of second column on screen                  *
      *  43 - Non-display of third column on screen                   *
      *  50 - Subfile EOF                                             *
      *  51 - Seq Validation error on first column - display only     *
      *  52 - Seq Validation error on second column - display only    *
      *  53 - Seq Validation error on third column - display only     *
      *  60 - SFLNXTCHG                                               *
      *  61 - Lib Validation error on first column - display only     *
      *  62 - Lib Validation error on second column - display only    *
      *  63 - Lib Validation error on third column - display only     *
      *  80 - SFLDSP                                                  *
      *  81 - SFLDSPCTL                                               *
      *  82 - SFLEND                                                  *
      *  86 - PUTOVR OVERLAY control                                  *
      *                                                               *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    Heading          40
     C                   PARM                    ExitCode          6
      *
     C                   EVAL      EndMainLoop = 'N'
      *
      * Subroutine to fill array from data queue
     C                   EXSR      DtaQtoArray
      *
      * Subroutine to build subfile for the first time
     C                   EXSR      BuildSubfile
      *
      * Perform subfile processing until F3 or F12 taken, or the subfile has
      *  passed validation and been accepted.
     C                   DOW       *INKC = *OFF and *INKL = *OFF
     C                             and EndMainLoop = 'N'
      *
     C                   EVAL      Refresh = 'N'
      *
      * If refresh was requested then rebuild subfile from ORIGLIBL.
     C                   IF        *INKE = *ON
     C                   EVAL      Refresh = 'Y'
     C                   EXSR      BuildSubfile
      *
     C                   ELSE
      * Read and validate subfile.
     C                   EXSR      ReadSubfile
      * If no changes are found then force out of the loop ...
     C                   IF        Nochanges = 'Y'
     C                   EVAL      EndMainLoop = 'Y'
      *
     C                   ELSE
      * ... or if there is an error, redisplay the subfile ...
     C                   IF        *IN01 = *ON
     C                   SETOFF                                       01
      * Send message for library list not replaced.
     C                   EVAL      MessageID = 'CPF2184'
     C                   EXSR      ErrorMsg
      *
     C                   EXSR      ReDspSubfile
      *
     C                   ELSE
      * ... or, if the subfile is valid, rebuild the array LIBL and
      *  redisplay the subfile.
     C                   EXSR      ReBldArray
     C                   EXSR      BuildSubfile
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
      * If the program was not exited with F3 or F12 then build data queue ...
     C                   IF        *INKC <> *ON and *INKL <> *ON
     C                   EXSR      ArrayToDtaQ
      *
     C                   ELSE
      * ... otherwise set the appropriate exit code.
     C                   IF        *INKC = *ON
     C                   EVAL      ExitCode = 'Exit'
     C                   ELSE
     C                   EVAL      ExitCode = 'Cancel'
     C                   ENDIF
     C                   ENDIF
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  BuildSubfile - Build subfile in readiness for display        *
      *                                                               *
      *  Called from: *MAIN                                           *
      *                                                               *
      *  Calls: Remove0s                                              *
      *                                                               *
      *****************************************************************
      *
     C     BuildSubfile  BEGSR
      *
      * This builds the whole subfile (90 records) at once.  Entries are read
      * from an array and placed in three columns page by page.  There are 251
      * possible entries which means that columns two and three do not go all
      * the way to the bottom of the subfile.
      *
      * Clear subfile and initialise indicators/indices/variables.
     C                   SETOFF                                       4243
     C                   SETOFF                                       515253
     C                   SETOFF                                       616263
     C                   SETOFF                                       8081
     C                   SETOFF                                       86
     C                   WRITE     UP0126F2
     C                   EVAL      SeqIdx1 = 001
     C                   EVAL      SeqIdx2 = 016
     C                   EVAL      SeqIdx3 = 031
     C                   EVAL      RelRecNo = 1
     C                   EVAL      SRECNO = 1
      *
      * Loop to control build of entire subfile.  The number 241 indicates that
      * column 1 has reached its final page.
     C                   DOU       SeqIdx1 > 241
      *
      * Loop to control build of subfile page.
     C                   DO        15
      *
      * If screen has been refreshed then use contents of the original array ...
     C                   IF        *INKE = *ON
     C                   EVAL      LibraryArray = ORIGLIBL(SeqIdx1)
     C                   ELSE
      * ... otherwise use the current array.
     C                   EVAL      LibraryArray = LIBL(SeqIdx1)
     C                   ENDIF
      *
      * Remove any leading zeros.
     C                   EXSR      Remove0s
     C                   EVAL      #SEQ1 = SequenceA
     C                   EVAL      #LIB1 = Library
      * Only build the second column if it is not too far down the subfile.
     C     *IN42         IFEQ      *OFF
      *
     C                   IF        *INKE = *ON
     C                   EVAL      LibraryArray = ORIGLIBL(SeqIdx2)
     C                   ELSE
     C                   EVAL      LibraryArray = LIBL(SeqIdx2)
     C                   ENDIF
      *
      * Remove any leading zeros.
     C                   EXSR      Remove0s
     C                   EVAL      #SEQ2 = SequenceA
     C                   EVAL      #LIB2 = Library
     C                   ENDIF
      * Only build the third column if it is not too far down the subfile.
     C     *IN43         IFEQ      *OFF
      *
     C                   IF        *INKE = *ON
     C                   EVAL      LibraryArray = ORIGLIBL(SeqIdx3)
     C                   ELSE
     C                   EVAL      LibraryArray = LIBL(SeqIdx3)
     C                   ENDIF
      *
      * Remove any leading zeros.
     C                   EXSR      Remove0s
     C                   EVAL      #SEQ3 = SequenceA
     C                   EVAL      #LIB3 = Library
     C                   ENDIF
      *
      * Write subfile record.
     C                   WRITE     UP0126F1
      *
      * Increment the indices for within the page.
     C                   EVAL      RelRecNo = RelRecNo + 1
     C                   EVAL      SeqIdx1 = SeqIdx1 + 1
     C                   EVAL      SeqIdx2 = SeqIdx2 + 1
     C                   EVAL      SeqIdx3 = SeqIdx3 + 1
      *
      * Once the subfile has got to a certain point then columns three ...
     C     SeqIdx1       IFEQ      196
     C                   SETON                                        43
     C                   ENDIF
      * ... and two should not be displayed.
     C     SeqIdx1       IFEQ      237
     C                   SETON                                        42
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Increment the columns' indices in readiness for the next page.
     C                   EVAL      SeqIdx1 = SeqIdx1 + 30
     C                   EVAL      SeqIdx2 = SeqIdx2 + 30
     C                   EVAL      SeqIdx3 = SeqIdx3 + 30
      *
     C                   ENDDO
      *
      * If Refresh was requested then rebuild the LIBL array from ORIGLBL.
     C                   IF        *INKE = *ON
     C                   EVAL      RebldIdx = 1
      *
     C                   DO        251
     C                   EVAL      LIBL(RebldIdx) = ORIGLIBL(RebldIdx)
     C                   EVAL      RebldIdx = RebldIdx + 1
     C                   ENDDO
      *
     C                   ENDIF
      *
      * Display screen.
     C                   SETON                                        808182
     C                   SETON                                        86
     C                   WRITE     UP0126M2
     C                   WRITE     UP0126C1
     C                   EXFMT     UP0126F2
      * Set off column display indicators in readiness for valiadtion.
     C                   SETOFF                                       4243
      *
     C     BuildSubfileE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ReDspSubfile - Redisplay subfile with errors                 *
      *                                                               *
      *  Called from: *MAIN                                           *
      *                                                               *
      *  Calls: UpdSubfile                                            *
      *                                                               *
      *****************************************************************
      *
     C     ReDspSubfile  BEGSR
      *
      * If an error has been found during the validation then the subfile
      * should be redisplayed with error messages.
      *
     C                   SETON                                        86
      *
      * ErrRecNo should contain the RRN of the first error found.  If this is known
      * then the subfile can be displayed at the page where the error occurred.
     C                   IF        ErrRecNo > 0 and ErrRecNo < 16
     C                   EVAL      SRECNO = 1
     C                   ENDIF
     C                   IF        ErrRecNo > 15 and ErrRecNo < 31
     C                   EVAL      SRECNO = 16
     C                   ENDIF
     C                   IF        ErrRecNo > 30 and ErrRecNo < 46
     C                   EVAL      SRECNO = 31
     C                   ENDIF
     C                   IF        ErrRecNo > 45 and ErrRecNo < 61
     C                   EVAL      SRECNO = 46
     C                   ENDIF
     C                   IF        ErrRecNo > 60 and ErrRecNo < 76
     C                   EVAL      SRECNO = 61
     C                   ENDIF
     C                   IF        ErrRecNo > 75 and ErrRecNo < 91
     C                   EVAL      SRECNO = 76
     C                   ENDIF
      *
      * Display subfile.
     C                   WRITE     UP0126M2
     C                   WRITE     UP0126C1
     C                   EXFMT     UP0126F2
      *
      * After redisplaying then clear program queue messages.
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ##PGM
     C                   PARM      '*SAME'       RelQueue
      *
     C     ReDspSubfileE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  RebldArray - Rebuild array so that it is sorted and has      *
      *                an extra first entry.                          *
      *                                                               *
      *  Called from: *MAIN                                           *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     ReBldArray    BEGSR
      *
      * Update array to ensure that the sort will put blank entries to the bottom
      * of the array.
     C                   EVAL      LibIdx = 1
      *
     C                   DO        251
     C                   EVAL      SaveLibArray = LIBL(LibIdx)
      * If sequence has any leading blanks then set to 0.
     C                   EXSR      Add0s
     C                   IF        SaveLib = *blank
      * By setting blank entries to 9s this will ensure that the sort will put them
      * to the bottom.
     C                   EVAL      SaveSeqA = '9999'
     C                   EVAL      SaveLib = '9999999999'
     C                   ENDIF
     C                   EVAL      LIBL(LibIdx) = SaveLibArray
     C                   EVAL      LibIdx = LibIdx + 1
     C                   ENDDO
      *
      * Sort the array.
     C                   SORTA     LIBL
      *
      * Because the subfile has 251 entries (including 0) then the first entry
      * needs to be 0000 and blank.  First write array out to holding array.
     C                   EVAL      LibIdx = 1
      *
     C                   DO        250
     C                   EVAL      LIBL2(LibIdx) = LIBL(LibIdx)
     C                   EVAL      LibIdx = LibIdx + 1
     C                   ENDDO
      *
      * Write first entry to array as 0000 and blank.
     C                   EVAL      LibIdx = 1
     C                   EVAL      SequenceN = 0000
     C                   EVAL      Library = *blank
     C                   EVAL      LIBL(LibIdx) = LibraryArray
      *
      * Write back to array from the holding array new sequence numbers and
      * changing the 9s in the library name to blank.
     C                   DO        250
     C                   EVAL      SequenceN = SequenceN + 0010
     C                   EVAL      LibIdx = LibIdx + 1
     C                   EVAL      SaveLibArray = LIBL2(LibIdx - 1)
     C                   IF        SaveLib = '9999999999'
     C                   EVAL      SaveLib = *blank
     C                   ENDIF
     C                   EVAL      Library = SaveLib
     C                   EVAL      LIBL(LibIdx) = LibraryArray
     C                   ENDDO
      *
     C     ReBldArrayE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ReadSubfile - Read subfile for changes or command keys       *
      *                                                               *
      *  Called from: *MAIN                                           *
      *                                                               *
      *  Calls: ValidateRec                                           *
      *                                                               *
      *****************************************************************
      *
     C     ReadSubfile   BEGSR
      *
      * Initialise variables.
     C                   EVAL      RelRecNo = 0
     C                   EVAL      NoChanges = 'N'
     C                   EVAL      FstRecWasErr = 'N'
      *
      * Because the subfile does not repostion itself properly put
      * a special check in if record 1 was in error.
     C     ErrRecNo      IFEQ      1
     C                   EVAL      FstRecWasErr = 'Y'
     C     ErrRecNo      CHAIN     UP0126F1
     C                   EVAL      LibIdx1 = ErrRecNo
     C                   EVAL      LibIdx2 = ErrRecNo + 15
     C                   EVAL      LibIdx3 = ErrRecNo + 30
     C                   EXSR      ValidateRec
     C                   ENDIF
      *
      * Read subfile for changes.
     C                   READC     UP0126F1                               50
     C     *IN50         IFEQ      *ON
     C     FstRecWasErr  ANDEQ     'N'
     C                   EVAL      NoChanges = 'Y'
     C                   ENDIF
      *
     C     *IN50         DOWEQ     *OFF
      * Retrieve array position for all 3 columns depending on the value
      * of the RRN.
     C                   IF        RelRecNo > 0 AND RelRecNo < 16
     C                   EVAL      LibIdx1 = RelRecNo
     C                   EVAL      LibIdx2 = RelRecNo + 15
     C                   EVAL      LibIdx3 = RelRecNo + 30
     C                   ENDIF
     C                   IF        RelRecNo > 15 AND RelRecNo < 31
     C                   EVAL      LibIdx1 = RelRecNo + 30
     C                   EVAL      LibIdx2 = RelRecNo + 45
     C                   EVAL      LibIdx3 = RelRecNo + 60
     C                   ENDIF
     C                   IF        RelRecNo > 30 AND RelRecNo < 46
     C                   EVAL      LibIdx1 = RelRecNo + 60
     C                   EVAL      LibIdx2 = RelRecNo + 75
     C                   EVAL      LibIdx3 = RelRecNo + 90
     C                   ENDIF
     C                   IF        RelRecNo > 45 AND RelRecNo < 61
     C                   EVAL      LibIdx1 = RelRecNo + 90
     C                   EVAL      LibIdx2 = RelRecNo + 105
     C                   EVAL      LibIdx3 = RelRecNo + 120
     C                   ENDIF
     C                   IF        RelRecNo > 60 AND RelRecNo < 76
     C                   EVAL      LibIdx1 = RelRecNo + 120
     C                   EVAL      LibIdx2 = RelRecNo + 135
     C                   EVAL      LibIdx3 = RelRecNo + 150
     C                   ENDIF
     C                   IF        RelRecNo > 75 AND RelRecNo < 91
     C                   EVAL      LibIdx1 = RelRecNo + 150
     C                   EVAL      LibIdx2 = RelRecNo + 165
     C                   EVAL      LibIdx3 = RelRecNo + 180
     C                   ENDIF
      *
      * Validate subfile record.
     C                   EXSR      ValidateRec
      *
      * Look for next changed record.
     C                   READC     UP0126F1                               50
      *
     C                   ENDDO
      *
      * Check that there are duplicate libraries on the library list but
      * only if no other errors have been found.
     C                   IF        *IN01 = *OFF
     C                   EXSR      DuplicateLib
     C                   ENDIF
      *
      * Check that only up to 250 libraries have been entered but
      * only if no other errors have been found.
     C                   IF        *IN01 = *OFF
     C                   EXSR      CheckNoofLibs
     C                   ENDIF
      *
     C     ReadSubfileE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateRec - Validate subfile record                        *
      *                                                               *
      *  Called from: ReadSubfile                                     *
      *                                                               *
      *  Calls: ValSequence                                           *
      *         ValLibrary                                            *
      *         Remove0s                                              *
      *                                                               *
      *****************************************************************
      *
     C     ValidateRec   BEGSR
      *
      * This validates all three columns of the record.  In an error is
      * found then 09 is set on.  If 09 is on then error display indicators
      * (51, 52 or 53) are set on for invalid sequences, or (61, 62 or 63)
      * for invalid libraries.  01 is also set on to indicate that the
      * record is in error.
      *
      * Validate first column of record.
     C                   EVAL      SequenceA = #SEQ1
     C                   EVAL      Library = #LIB1
     C                   EVAL      SaveLibArray = LIBL(LibIdx1)
     C                   EVAL      TempIdx = LibIdx1
     C                   SETOFF                                       515253
     C                   SETOFF                                       616263
      * Validate sequence.
     C                   EXSR      ValSequence
      * If sequence is invalid ...
     C     *IN09         IFEQ      *ON
     C                   SETON                                        0151
     C                   SETOFF                                       09
     C                   ELSE
      * ... otherwise ensure leading zeroes are blanked.
     C                   EXSR      Remove0s
     C                   EVAL      #SEQ1 = SequenceA
     C                   ENDIF
      *
      * Validate library.
     C                   EXSR      ValLibrary
      * If library is invalid ...
     C     *IN09         IFEQ      *ON
     C                   SETON                                        0161
     C                   SETOFF                                       09
     C                   ELSE
      * ... otherwise, check sequence was valid and update array.
     C     *IN51         IFEQ      *OFF
     C                   EVAL      LIBL(LibIdx1) = LibraryArray
     C                   ENDIF
     C                   ENDIF
      *
      * Validate second column of record.  Check first that there is a second
      * column; i.e. not too far down the subfile.
     C                   IF        LibIdx2 < 252
     C                   EVAL      SequenceA = #SEQ2
     C                   EVAL      Library = #LIB2
     C                   EVAL      SaveLibArray = LIBL(LibIdx2)
     C                   EVAL      TempIdx = LibIdx2
      * Validate sequence.
     C                   EXSR      ValSequence
      * If sequence is invalid ...
     C     *IN09         IFEQ      *ON
     C                   SETON                                        0152
     C                   SETOFF                                       09
     C                   ELSE
      * ... otherwise ensure leading zeroes are blanked.
     C                   EXSR      Remove0s
     C                   EVAL      #SEQ2 = SequenceA
     C                   ENDIF
      * Validate library.
     C                   EXSR      ValLibrary
      * If library is invalid ...
     C     *IN09         IFEQ      *ON
     C                   SETON                                        0162
     C                   SETOFF                                       09
     C                   ELSE
      * ... otherwise, check sequence was valid and update array.
     C     *IN52         IFEQ      *OFF
     C                   EVAL      LIBL(LibIdx2) = LibraryArray
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * Validate third column of record.  Check first that there is a third
      * column; i.e. not too far down the subfile.
     C                   IF        LibIdx3 < 256
     C                   EVAL      SequenceA = #SEQ3
     C                   EVAL      Library = #LIB3
     C                   EVAL      SaveLibArray = LIBL(LibIdx3)
     C                   EVAL      TempIdx = LibIdx3
      * Validate sequence.
     C                   EXSR      ValSequence
      * If sequence is invalid ...
     C     *IN09         IFEQ      *ON
     C                   SETON                                        0153
     C                   SETOFF                                       09
     C                   ELSE
      * ... otherwise ensure leading zeroes are blanked.
     C                   EXSR      Remove0s
     C                   EVAL      #SEQ3 = SequenceA
     C                   ENDIF
      * Validate library
     C                   EXSR      ValLibrary
      * If library is invalid ...
     C     *IN09         IFEQ      *ON
     C                   SETON                                        0163
     C                   SETOFF                                       09
     C                   ELSE
      * ... otherwise, check sequence was valid and update array.
     C     *IN53         IFEQ      *OFF
     C                   EVAL      LIBL(LibIdx3) = LibraryArray
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * If an error occurred then set SFLNXTCHG for record.
     C                   IF        *IN01 = *ON
     C                   SETON                                        60
      * Ensure the first record in error is captured so that the correct
      * subfile page can be displayed.
     C                   IF        RelRecNo < ErrRecNo or ErrRecNo = 0
     C                   EVAL      ErrRecNo = RelRecNo
     C                   ENDIF
     C                   ELSE
     C                   EVAL      ErrRecNo = 0
     C                   SETOFF                                       60
     C                   ENDIF
      * Update subfile record.
     C                   EXSR      UpdSubfile
      *
     C     ValidateRecE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValSequence - Validate sequence                              *
      *                                                               *
      *  Called from: ValidateRec                                     *
      *                                                               *
      *  Calls: ErrorMsg                                              *
      *                                                               *
      *****************************************************************
      *
     C     ValSequence   BEGSR
      *
     C                   EVAL      BlankSequence = 'N'
      *
     C                   IF        SequenceA <> *blanks
      * Call standard subroutine to convert field.
     C                   EVAL      ConvertField = SequenceA
     C                   CALL      'ZALIGN'
     C                   PARM                    ReturnCode        7
     C                   PARM                    ConvertField     16
     C                   PARM      *ZERO         NoOfDecimals      1 0
     C                   PARM      4             FldLength         2 0
     C                   PARM      *BLANK        NewField         16
      * If the sequence number is not valid then report.
     C                   IF        ReturnCode <> *blank
     C                   SETON                                        09
     C                   EVAL      MessageID = 'CPD6A70'
     C                   EXSR      ErrorMsg
     C                   ELSE
     C                   EVAL      SequenceA = %SUBST(NewField:13:4)
     C                   ENDIF
      *
      * If sequence is blank then flag accordingly.
     C                   ELSE
     C                   EVAL      BlankSequence = 'Y'
     C                   ENDIF
      *
     C     ValSequenceE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValLibrary - Validate library                                *
      *                                                               *
      *  Called from: ValidateRec                                     *
      *                                                               *
      *  Calls: ErrorMsg                                              *
      *                                                               *
      *****************************************************************
      *
     C     ValLibrary    BEGSR
      *
     C                   IF        Library <> *blanks
      * Align the library name so that it is left justified.
     C                   EVAL      Library = %TRIML(Library)
      * Chrck for libraries existence.
     C                   CALL      'UTCHKOBJ'
     C                   PARM                    ExistCode        10
     C                   PARM                    Library          10
     C                   PARM      '*LIBL'       Qsys             10
     C                   PARM      '*LIB'        ObjType          10
     C                   PARM      '*NONE'       Member           10
     C                   IF        ExistCode <> 'Exist'
      * If unable to perform check properly ...
     C                   IF        ExistCode = 'Error'
     C                   SETON                                        09
     C                   EVAL      MessageID = 'CPD6A74'
     C                   EVAL      MessageData = Library
     C                   EXSR      ErrorMsg
     C                   ELSE
      * ... or library doesn't exist.
     C                   SETON                                        09
     C                   EVAL      MessageID = 'CPF2110'
     C                   EVAL      MessageData = Library
     C                   EXSR      ErrorMsg
     C                   ENDIF
     C                   ELSE
      *
      * If library is valid and the sequence is blank then reset sequence.
     C                   IF        BlankSequence = 'Y' and *IN01 <> *ON
     C                   EVAL      SequenceA = SaveSeqA
     C                   ENDIF
     C                   ENDIF
      *
      * If library is blank then set to 9s for sorting purposes.
     C                   ELSE
     C                   EVAL      SequenceA = '9999'
     C                   EVAL      Library = '9999999999'
     C                   ENDIF
      *
     C     ValLibraryE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  UpdSubfile - Update subfile for SFLNXTCHG                    *
      *                                                               *
      *  Called from: ValidateRec                                     *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     UpdSubfile    BEGSR
      *
     C                   SETOFF                                       4243
      *
      * Use the display indicators to ensure columns two and three are
      * updated correctly.
     C                   IF        RelRecNo > 75
     C                   SETON                                        43
     C                   ENDIF
     C                   IF        RelRecNo > 86
     C                   SETON                                        42
     C                   ENDIF
      *
     C                   UPDATE    UP0126F1
      *
     C     UpdSubfileE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Remove0s - Remove leading zeroes from Sequence               *
      *                                                               *
      *  Called from: BuildSubfile                                    *
      *               ValidateRec                                     *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     Remove0s      BEGSR
      *
     C     Char1         IFEQ      '0'
     C                   EVAL      Char1 = *blank
     C     Char2         IFEQ      '0'
     C                   EVAL      Char2 = *blank
     C     Char3         IFEQ      '0'
     C                   EVAL      Char3 = *blank
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     Remove0sE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Add0s - Add zeroes back in to replace leading blanks         *
      *                                                               *
      *  Called from: ReBldArray                                      *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     Add0s         BEGSR
      *
     C     SChar1        IFEQ      ' '
     C                   EVAL      SChar1 = '0'
     C     SChar2        IFEQ      ' '
     C                   EVAL      SChar2 = '0'
     C     SChar3        IFEQ      ' '
     C                   EVAL      SChar3 = '0'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     Add0sE        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  DtaQtoArray - Fill array LIBL from data queue CHGJOBDO       *
      *                                                               *
      *  Called from: *MAIN                                           *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     DtaQtoArray   BEGSR
      *
      * This reads the data queue previously created in the CPP and fills the array.
      *
      * Initialise variable and index.
     C                   EVAL      SequenceN = 0
     C                   EVAL      LibIdx = 1
      *
      * Build first array entry as 0000 and blank.
     C                   EVAL      Library = *blanks
     C                   EVAL      LIBL(LibIdx) = LibraryArray
     C                   EVAL      ORIGLIBL(LibIdx) = LibraryArray
     C                   EVAL      SequenceN = SequenceN + 10
     C                   EVAL      LibIdx = LibIdx + 1
      *
     C                   EVAL      DataQueue = 'CHGJOBDO'
     C                   EVAL      DataQueueLib = 'QTEMP'
     C                   EVAL      DtaQData = *blanks
      *
      * Find out number of messages on data queue.
     C                   CALL      'UT0073'
     C                   PARM                    DtaQ
     C                   PARM                    DtaQData
     C                   EVAL      DtaQDataDS = DtaQData
      *
      * Receive all entries from data queue.
     C                   DO        NoOfMsgs
      *
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DataQueue
     C                   PARM                    DataQueueLib
     C                   PARM      10            Length            5 0
     C                   PARM                    Library
     C                   PARM      0             Wait              5 0
      *
     C                   EVAL      LIBL(LibIdx) = LibraryArray
     C                   EVAL      ORIGLIBL(LibIdx) = LibraryArray
     C                   EVAL      SequenceN = SequenceN + 10
     C                   EVAL      LibIdx = LibIdx + 1
     C                   ENDDO
      *
      * Fill the rest of the array with incremented sequences and blank libraries.
     C                   DOU       SequenceN > 2500
     C                   EVAL      Library = *blanks
     C                   EVAL      LIBL(LibIdx) = LibraryArray
     C                   EVAL      ORIGLIBL(LibIdx) = LibraryArray
     C                   EVAL      SequenceN = SequenceN + 10
     C                   EVAL      LibIdx = LibIdx + 1
     C                   ENDDO
      *
     C     DtaQtoArrayE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ArrayToDtaQ - Fill data queue CHGJOBDN from array LIBL       *
      *                                                               *
      *  Called from: *MAIN                                           *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     ArrayToDtaq   BEGSR
      *
      * Set index to 2 as first array entry will be blank.
     C                   EVAL      LibIdx = 2
     C                   EVAL      BlankLibrary = 'N'
      *
      * Set up variables for data queue which was created in the CPP.
     C                   EVAL      DataQueue = 'CHGJOBDN'
     C                   EVAL      DataQueueLib = 'QTEMP'
      *
      * Clear data queue for new library list.
     C                   CALL      'QCLRDTAQ'
     C                   PARM                    DataQueue
     C                   PARM                    DataQueueLib
      *
      * Send library names to data queue until library name is blank.
     C                   DOU       BlankLibrary = 'Y' or LibIdx > 251
      *
     C                   EVAL      LibraryArray = LIBL(LibIdx)
     C                   IF        Library = *blank
     C                   EVAL      BlankLibrary = 'Y'
     C                   ELSE
      *
     C                   CALL      'QSNDDTAQ'
     C                   PARM                    DataQueue
     C                   PARM                    DataQueueLib
     C                   PARM      10            Length            5 0
     C                   PARM                    Library
      *
     C                   ENDIF
     C                   EVAL      LibIdx = LibIdx + 1
     C                   ENDDO
      *
     C     ArrayToDtaQE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  DuplicateLib - Check for duplicate library                   *
      *                                                               *
      *  Called from: ValLibrary                                      *
      *                                                               *
      *  Calls: CalcErrRecNo                                          *
      *                                                               *
      *****************************************************************
      *
     C     DuplicateLib  BEGSR
      *
      * This reads through the updated LIBL array and sorts it in the array
      * DUPLIBL.  If a duplcate library name is found then send error message.
      *
      * Initialise variables and array.
     C                   EVAL      ErrRecNo   = 0
     C                   EVAL      SearchIdx  = 1
     C                   MOVE      *ALL'9'       DUPLIBL
      *
      * Build the array to check for duplicate library names.
     C                   DOU       SearchIdx > 251
      *
     C                   EVAL      SearchArray = LIBL(SearchIdx)
     C                   IF        SearchLib = *blank
     C                   EVAL      DupLib = '9999999999'
     C                   ELSE
     C                   EVAL      DupLib = SearchLib
     C                   ENDIF
     C                   EVAL      PositionN = SearchIdx
     C                   EVAL      DUPLIBL(SearchIdx) =  DupArray
      *
     C                   EVAL      SearchIdx  = SearchIdx + 1
      *
     C                   ENDDO
      *
      * Sort the array by library name.
     C                   SORTA     DUPLIBL
      *
     C                   EVAL      SearchIdx  = 1
     C                   EVAL      PreviousLib = *blank
     C                   EVAL      DupLibrary = 'N'
      *
     C                   DOU       SearchIdx > 251 or DupLib = '9999999999'
     C                             or DupLibrary = 'Y'
      *
     C                   EVAL      DupArray = DUPLIBL(SearchIdx)
     C                   IF        DupLib <> *blank
     C                   IF        DupLib = PreviousLib
      *
     C                   EVAL      DupLibrary = 'Y'
     C                   EXSR      CalcErrRecNo
      *
     C                   ELSE
     C                   EVAL      PreviousLib = DupLib
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      SearchIdx  = SearchIdx + 1
      *
     C                   ENDDO
      *
     C                   IF        DupLibrary = 'Y'
      *
     C                   EVAL      RelRecNo = ErrRecNo
     C                   SETON                                        01
     C     RelRecNo      CHAIN     UP0126F1
      *
      * Set on Error indicators for the subfile record with duplicate library
     C                   SETON                                        60
      *
     C     ColumnFactor  IFEQ      0
     C                   SETON                                        61
     C                   ELSE
     C     ColumnFactor  IFEQ      1
     C                   SETON                                        62
     C                   ELSE
     C     ColumnFactor  IFEQ      2
     C                   SETON                                        63
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      UpdSubfile
      *
      * Send 'Duplicate' error message to error message subfile
     C                   EVAL      MessageID = 'CPF2180'
     C                   EVAL      MessageData = DupLib
     C                   EXSR      ErrorMsg
     C                   ENDIF
      *
     C     DuplicateLibE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  CalcErrRecNo - Calculate the ErrRecNo of the duplicate       *
      *                 library in the subfile                        *
      *                                                               *
      *  Called from: DuplicateLib                                    *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     CalcErrRecNo  BEGSR
      *
      * Work out Column (0,1,2,3,4....).
      * 15 is the number of rows on the screen.
     C     PositionN     DIV       15            Column            2 0
     C                   MVR                     ColRemainder      2 0
     C                   IF        ColRemainder = 0
     C                   EVAL      Column = Column - 1
     C                   END
      *
      * Work out Column Number in each page (0,1,2) and Page Number (0,1,2,3,4...)
      * Column Number in each page is the ColumnFactor used in the calculation.
      * 3 is number of library columns on the screen.
     C     Column        DIV       3             PageNo            2 0
     C                   MVR                     ColumnFactor
      *
     C                   EVAL      PageFactor = PageNo * 2
      *
      * Calculate ErrRecNo
     C                   EVAL      TtlColShifted = PageFactor + Columnfactor
     C                   EVAL      ErrRecNo = PositionN - 15 * TtlColShifted
      *
     C     CalcErrRecNoE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  CheckNoofLibs - Check number of libraries on subfile         *
      *                                                               *
      *  Called from: ReadSubfile                                     *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     CheckNoofLibs BEGSR
      *
      * This reads through the entire subfile.  As soon as a blank library
      * is found the process is ended.  If no blank is found then this means
      * that 251 libraries have been entered which is too many.
      *
      * Initialise variables.
     C                   EVAL      RelRecNo = 1
     C                   EVAL      BlankLibrary = 'N'
      *
      * Begin reading subfile.
     C                   DOU       BlankLibrary = 'Y' or RelRecNo > 90
      *
     C     RelRecNo      CHAIN     UP0126F1
      *
     C                   IF        #LIB1 = *blank
     C                   EVAL      BlankLibrary = 'Y'
     C                   ENDIF
      *
     C                   IF        RelRecNo < 87
     C                   IF        #LIB2 = *blank
     C                   EVAL      BlankLibrary = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        RelRecNo < 76
     C                   IF        #LIB3 = *blank
     C                   EVAL      BlankLibrary = 'Y'
     C                   ENDIF
     C                   ENDIF
      *
      * Increment for next chain.
     C                   EVAL      RelRecNo = RelRecNo + 1
      *
     C                   ENDDO
      *
      * If end of loop reached and no blank library was found then 251
      * libraries were entered.  Send error message.
     C                   IF        BlankLibrary = 'N'
     C                   SETON                                        01
     C                   EVAL      MessageID = 'CPF219F'
     C                   EXSR      ErrorMsg
     C                   EVAL      ErrRecNo = 1
     C                   ENDIF
      *
     C     CheckNoofLibsEENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ErrorMsg - Build error mesaage subfile                       *
      *                                                               *
      *  Called from: ValSequence                                     *
      *               ValLibrary                                      *
      *                                                               *
      *  Calls: *NONE                                                 *
      *                                                               *
      *****************************************************************
      *
     C     ErrorMsg      BEGSR
      *
     C     PgmQueue      IFEQ      *blank
     C                   EVAL      PgmQueue = ##PGM
     C                   ENDIF
      *
      * Use standard program to send messages to program.
     C                   CALL      'Y2SNMGC'
     C                   PARM                    PgmQueue         10
     C                   PARM                    RelQueue          5
     C                   PARM                    MessageID
     C                   PARM      'QCPFMSG   '  MessageFile      10
     C                   PARM                    MessageData     132
     C                   PARM                    MessageType       7
      *
      * Reset fields for next call
     C                   EVAL      PgmQueue = *blanks
     C                   EVAL      RelQueue = *blanks
     C                   EVAL      MessageID = *blanks
     C                   EVAL      MessageFile = *blanks
     C                   EVAL      MessageData = *blanks
     C                   EVAL      MessageType = *blanks
      *
     C     ErrorMSgE     ENDSR
      *
