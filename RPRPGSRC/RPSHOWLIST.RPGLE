     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
     H OPTION(*SRCSTMT : *NODEBUGIO)

      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RPSHOWLIST - Show list of items                              *
      *                                                               *
      *  Function:  This module displays a list of items; it is used  *
      *             to displyay lists of previously-defined Products, *
      *             Servers and Environments.                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. CRP010  *CREATE    Date 03Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *   CRP010 - Created                                            *
      *                                                               *
      *****************************************************************

     FX110LF    IF   E           K DISK    usropn
     FX210LF    IF   E           K DISK    usropn
     FX310LF    IF   E           K DISK    usropn

     FX01FMD    CF   E             WORKSTN usropn include(LIST)
     F                                     rename(LIST : X1List)
     FX02FMD    CF   E             WORKSTN usropn include(LIST)
     F                                     rename(LIST : X2List)
     FX03FMD    CF   E             WORKSTN usropn include(LIST)
     F                                     rename(LIST : X3List)


      *---------------------------------------------------------------------

     D MAX_LIST_ENTRIES...
     D                 C                   15
     D GlobListArray   S             70A   dim(MAX_LIST_ENTRIES)


      *---------------------------------------------------------------------
      * Prototypes
      *---------------------------------------------------------------------
      * Prototype for the ShowList procedure
     D ShowList        PR                  extproc('RPSHOWLIST')
     D File                           2A
      *---------------------------------------------------------------------

     D BuildX1List     PR
     D ListArray                           like(GlobListArray)
     D                                     dim(MAX_LIST_ENTRIES)

     D BuildX2List     PR
     D ListArray                           like(GlobListArray)
     D                                     dim(MAX_LIST_ENTRIES)

     D BuildX3List     PR
     D ListArray                           like(GlobListArray)
     D                                     dim(MAX_LIST_ENTRIES)

    DD DisplayList     PR
     D ListArray                           like(GlobListArray)
     D                                     dim(MAX_LIST_ENTRIES)

      *---------------------------------------------------------------------

      *---------------------------------------------------------------------
      * Procedure interface for the main procedure (in conjunction with
      * the prototype, this replaces the *entry plist
      *---------------------------------------------------------------------
     D ShowList        PI
     D File                           2A
      *---------------------------------------------------------------------

     D ListArray       S                   like(GlobListArray)
     D                                     dim(MAX_LIST_ENTRIES)

      *---------------------------------------------------------------------

      * The files being left open at this level can cause problems
      * on repeated calls, so we close them all here (with error checking)
      * to be on the safe side.
     C                   close(e)  X01FMD
     C                   close(e)  X02FMD
     C                   close(e)  X03FMD
     C                   close(e)  X110LF
     C                   close(e)  X210LF
     C                   close(e)  X310LF

      * Now process according to which file is being handled.               oup
     C                   select
     C                   when      File = 'X1'
     C                   callp     BuildX1List(ListArray)

     C                   when      File = 'X2'
     C                   callp     BuildX2List(ListArray)

     C                   when      File = 'X3'
     C                   callp     BuildX3List(ListArray)

     C                   endsl

      * Now pass the generated list on to the display handler for displaying
     C                   callp     DisplayList(ListArray)


     C                   return

      *---------------------------------------------------------------------
      * End of main procedure
      *---------------------------------------------------------------------



      *---------------------------------------------------------------------
     P BuildX1List     B
     D MAX_LIST_ENTRIES...
     D                 C                   15
     D BuildX1List     PI
     D ListArray                           like(GlobListArray)
     D                                     dim(MAX_LIST_ENTRIES)
      *---------------------------------------------------------------------

     D X1_LIST_HEADER  C                   'Product      +
     D                                      Short name   +
     D                                      Description'

     D HEADER_LINES    C                   2

     D RollbackNo      S             10I 0
     D ListIndex       S             10I 0 inz(1)

      *---------------------------------------------------------------------

     C                   open(e)   X110LF
     C                   open(e)   X01FMD

      * Ensure that the array starts empty, and then put heading
      * information and a blank separator into the first two lines.
     C                   clear                   ListArray
     C                   eval      ListArray(1) = X1_LIST_HEADER
     C                   eval      ListArray(2) = *blanks

      * Incremement the index by the appropriate amount
     C                   eval      ListIndex = ListIndex + HEADER_LINES

      * Ensure that the file starts at the beginning each time, as we
      * are not trying to handle rolling.
     C     *loval        setll     X110LF

      * Loop until there are no more records or the maximum number of
      * array entries has been processed.
     C                   dou       %eof(X110LF) or ListIndex >
     C                                MAX_LIST_ENTRIES

      * If the end of file is reached at any point, don't do any more processing
     C                   read      X110LF
     C                   if        %eof(X110LF)
     C                   leave
     C                   endif

     C                   eval      ListArray(ListIndex) = X1PRDN + '     ' +
     C                                X1PRDS + '        ' + X1DESC

     C                   eval      ListIndex = ListIndex + 1

     C                   enddo
      *                  (End of "do until end of file or max list entries")

     C                   return


      *---------------------------------------------------------------------
     P BuildX1List     E
      *---------------------------------------------------------------------


      *---------------------------------------------------------------------
     P BuildX2List     B
     D MAX_LIST_ENTRIES...
     D                 C                   15
     D BuildX2List     PI
     D ListArray                           like(GlobListArray)
     D                                     dim(MAX_LIST_ENTRIES)
      *---------------------------------------------------------------------

     D X2_LIST_HEADER  C                   'Server name           +
     D                                      Server mnemomic  +
     D                                      Server description'

     D HEADER_LINES    C                   2

     D ListIndex       S             10I 0 inz(1)

      *---------------------------------------------------------------------


     C                   open(e)   X210LF
     C                   open(e)   X02FMD

      * Ensure that the array starts empty, and then put heading
      * information and a blank separator into the first two lines.
     C                   clear                   ListArray
     C                   eval      ListArray(1) = X2_LIST_HEADER
     C                   eval      ListArray(2) = *blanks

      * Incremement the index by the appropriate amount
     C                   eval      ListIndex = ListIndex + HEADER_LINES

      * Ensure that the file starts at the beginning each time, as we
      * are not trying to handle rolling.
     C     *loval        setll     X210LF

      * Loop until there are no more records or the maximum number of
      * array entries has been processed.
     C                   dou       %eof(X210LF) or ListIndex >
     C                                MAX_LIST_ENTRIES

      * If the end of file is reached at any point, don't do any more processing
     C                   read      X210LF
     C                   if        %eof(X210LF)
     C                   leave
     C                   endif

     C                   eval      ListArray(ListIndex) = X2DSID + '  ' +
     C                                X2DSMN + '               ' + X2DESC

     C                   eval      ListIndex = ListIndex + 1

     C                   enddo
      *                  (End of "do until end of file or max list entries")

     C                   return


      *---------------------------------------------------------------------
     P BuildX2List     E
      *---------------------------------------------------------------------


      *---------------------------------------------------------------------
     P BuildX3List     B
     D MAX_LIST_ENTRIES...
     D                 C                   15
     D BuildX3List     PI
     D ListArray                           like(GlobListArray)
     D                                     dim(MAX_LIST_ENTRIES)
      *---------------------------------------------------------------------

     D X3_LIST_HEADER  C                   'Environment mnemonic   +
     D                                      Linkage file library    +
     D                                      Subsystem name'

     D HEADER_LINES    C                   2

     D ListIndex       S             10I 0 inz(1)

      *---------------------------------------------------------------------


     C                   open(e)   X310LF
     C                   open(e)   X03FMD

      * Ensure that the array starts empty, and then put heading
      * information and a blank separator into the first two lines.
     C                   clear                   ListArray
     C                   eval      ListArray(1) = X3_LIST_HEADER
     C                   eval      ListArray(2) = *blanks

      * Incremement the index by the appropriate amount
     C                   eval      ListIndex = ListIndex + HEADER_LINES

      * Ensure that the file starts at the beginning each time, as we
      * are not trying to handle rolling.
     C     *loval        setll     X310LF

      * Loop until there are no more records or the maximum number of
      * array entries has been processed.
     C                   dou       %eof(X310LF) or ListIndex >
     C                                MAX_LIST_ENTRIES

      * If the end of file is reached at any point, don't do any more processing
     C                   read      X310LF
     C                   if        %eof(X310LF)
     C                   leave
     C                   endif

     C                   eval      ListArray(ListIndex) = X3UMN +
     C                                '                    ' + X3X7L +
     C                                '              ' + X3SBS

     C                   eval      ListIndex = ListIndex + 1
     C

     C                   enddo
      *                  (End of "do until end of file or max list entries")

     C                   return


      *---------------------------------------------------------------------
     P BuildX3List     E
      *---------------------------------------------------------------------


      *---------------------------------------------------------------------
     P DisplayList     B
     D MAX_LIST_ENTRIES...
     D                 C                   15
     D DisplayList     PI
     D ListArray                           like(GlobListArray)
     D                                     dim(MAX_LIST_ENTRIES)
      *---------------------------------------------------------------------

     D ListIndex       S             10I 0 inz(1)

      *---------------------------------------------------------------------

     C                   eval      LINE1 = ListArray(1)
     C                   eval      LINE2 = ListArray(2)
     C                   eval      LINE3 = ListArray(3)
     C                   eval      LINE4 = ListArray(4)
     C                   eval      LINE5 = ListArray(5)
     C                   eval      LINE6 = ListArray(6)
     C                   eval      LINE7 = ListArray(7)
     C                   eval      LINE8 = ListArray(8)
     C                   eval      LINE9 = ListArray(9)
     C                   eval      LINE10 = ListArray(10)
     C                   eval      LINE11 = ListArray(11)
     C                   eval      LINE12 = ListArray(12)
     C                   eval      LINE13 = ListArray(13)
     C                   eval      LINE14 = ListArray(14)
     C                   eval      LINE15 = ListArray(15)

      * Write the appropriate format to the screen, depending on which
      * display file is in use.
     C                   select

     C                   when      %open(X01FMD)
     C                   write     X1List

     C                   when      %open(X02FMD)
     C                   write     X2List

     C                   when      %open(X03FMD)
     C                   write     X3List

     C                   endsl

     C                   return

      *---------------------------------------------------------------------
     P DisplayList     E
      *---------------------------------------------------------------------

