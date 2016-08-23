     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas UT Retrieve File Fields Descriptions')           *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UTRTVFLDD  Midas UT Retrieve File Fields Descriptions        *
      *                                                               *
      *  Function:  This program retrieve file fields descriptions    *
      *             of a file                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSD092   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D  FieldsDesc     DS
     D  FieldNameArr                 10A   dim( FieldArrSize )
     D  FieldPosnArr                 10I 0 dim( FieldArrSize )
     D  FieldLenArr                  10I 0 dim( FieldArrSize )
     D  FieldDigitArr                10I 0 dim( FieldArrSize )
     D  FieldTypeArr                  1A   dim( FieldArrSize )
     D  FieldTextArr                 30A   dim( FieldArrSize )
     D FieldArrSize    C                   1200
 
     D Prtcd           S              7A
     D PFileName       S             10A
     D PFieldsDesc     S                   like(FieldsDesc)
     D FieldsDescs     S                   like(FieldsDesc) dim(FileArrSize)
     D PFieldNum       S              5I 0
     D PRecordLen      S              5P 0
     D FileName        S             10A   inz(' ')
 
     D FileNames       DS
     D  FileNameArr                  10A   dim(FileArrSize)
     D FieldNums       DS
     D  FieldNumArr                   5I 0 dim(FileArrSize)
     D RecordLen       DS
     D  RecordLenArr                  5P 0 dim(FileArrSize)
     D  FileArrSize    C                   10
 
      * Index for the arrays
     D Idx             S              5I 0  inz(1)
     D Index           S              5I 0  inz(0)
     D WPos            S              5I 0  inz(0)
 
      * File handle used by the fields description procedures
     D FileHandle      S             10A
 
      ** The following /COPY line includes the procedure prototypes for the
      ** file fields procedures, and named constants used by those procedures.
     D/COPY UTCPYSRC,FILEFLDSPR
      **
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EVAL      WPos = %SCAN(PFileName:FileNames)
 
     C                   IF        Wpos <> *ZEROS
     C                   EVAL      Idx = (WPos + 9 ) / 10
     C                   EVAL      PFieldNum = FieldNumArr (Idx)
     C                   EVAL      PFieldsDesc = FieldsDescs (Idx)
 
     C                   ELSE
 
     C                   EXSR      GetFieldsDesc
 
     C                   EVAL      Idx = 1
     C                   DOW       FileNameArr(Idx) <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   ENDDO
 
     C                   EVAL      FileNameArr(Idx) = PFileName
     C                   EVAL      FieldNumArr(Idx) = PFieldNum
     C                   EVAL      FieldsDescs(Idx) = PFieldsDesc
 
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    Prtcd
     C                   PARM                    PFileName
     C                   PARM                    PFieldsDesc
     C                   PARM                    PFieldNum
 
     C                   CLEAR                   FileNames
     C                   CLEAR                   FieldNums
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  GetFieldsDesc - Get Fields Descriptions                      *
      *****************************************************************
     C     GetFieldsDesc BEGSR
 
      * First generate the file fields description data.  The procedure
      * returns a file handle which subsequent procedures use to refer to
      * the data for the file in question.
     C                   eval      FileHandle =
     C                                GenFileFldList( PFileName + '*LIBL' )
 
      * If an error occurred the handle will contain one of the error codes.
      * APIERR is a general error (a dump will also have been produced);
      * APIFULL means that we are trying to generate the data for more
      * than the maximum possible number of files.  At the time of writing
      * this was 2000, so it is not very likely.
     C                   IF        FileHandle = APIERR OR
     C                                FileHandle = APIFULL
     C                   EVAL      Prtcd = '*ERROR'
     C                   ENDIF
 
      * --------------------------------------------------------------------
 
      * Initialise some values.
     C                   CLEAR                   QUSL0100
     C                   CLEAR                   Index
     C                   CLEAR                   FieldsDesc
 
      * Loop until all the entries have been returned for the file (the
      * do-until loop is eternal; exiting is handled within the loop.
     C                   DOU       'Starsky' = 'Hutch'
 
      * Retrieve the details of the next field; the subprocedure retains
      * details of where it is in the list; all it needs is the file
      * handle.  QUSL0100 is a structure defined in a QSYSINC /COPY
      * member, which contains all the details we need (and more).
     C                   EVAL      QUSL0100 =
     C                                GetNextFldEnt( FileHandle )
 
      * If an error was reported, indicate this to the caller.
     C                   IF        %subst( QUSL0100 : 1 : 10 ) = APIERR
     C                   EVAL      Prtcd = '*ERROR'
     C                   EVAL      PFieldNum = 0
     C                   RETURN
     C                   ENDIF
 
      * End normally if GetNextFldEnt() indicates that all the
      * entries have been processed.
     C                   IF        %subst( QUSL0100 : 1 : 10 ) = APIEND
     C                   EVAL      Prtcd =  *BLANKS
     C                   EVAL      PFieldNum = Index
     C                   EVAL      PFieldsDesc = FieldsDesc
     C                   LEAVE
     C                   ENDIF
 
      * --------------------------------------------------------------------
      * Increment the array index for the next time round the loop.
     C                   EVAL      Index = Index + 1
 
     C                   EVAL      FieldNameArr( Index ) = QUSFN02
     C                   EVAL      FieldPosnArr( Index ) = QUSIBP
     C                   EVAL      FieldLenArr ( Index ) = QUSFLB
     C                   EVAL      FieldDigitArr( Index ) = QUSIGITS
     C                   EVAL      FieldTypeArr( Index ) = QUSDT
     C                   EVAL      FieldTextArr( Index ) = QUSFTD
 
     C                   ENDDO
      *                  (End of "Do until last entry processed")
 
     C                   ENDSR
      *****************************************************************
 
