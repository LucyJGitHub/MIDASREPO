     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SC Create object listing')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCCOBJLCKR - Midas SC Create object listing                  *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD021351 *REWRITE  Date 19Jul13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 248228             Date 19Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG8447            Date 13Sep05               *
      *                 CDL038             Date 10May05               *
      *                 BUG3834 *CREATE    Date 18Jul04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD021351 - Design for Kill object locks                      *
      *  248228 - Amend the message displayed when reopening the input*
      *            cycle to send a more useful message.               *
      *  BUG8447 - Remove the commit and rolbk statements as there is *
      *            no need to have commitment control active.         *
      *  CDL038  - Extended Deal Sub Type                             *
      *  BUG3834 - New programs created to deal with object locks     *
      *                                                               *
      *****************************************************************

      ** Work fields

     D w@command       S           1024
     D w@lgth          S             15  5
     D Error           S              1A   inz('N')
     D inputFile       S             10
     D inputLibrary    S             10
     D inputType       S              7
     D OutputFile      S             10
     D OutputLibrary   S             10
     D PIMMED          S              1

      ** Main Process

      ** First up we need to retrieve a list of all the
      ** objects in the library

     C                   EVAL      w@command = 'DSPOBJD ' +
     C                                         'OBJ(' +
     C                                          %TRIM(inputLibrary) + '/' +
     C                                          %TRIM(inputFile) + ') ' +
     C                                         'OBJTYPE(' +
     C                                          %TRIM(inputType) + ') ' +
     C                                         'OUTPUT(*OUTFILE) ' +
     C                                         'OUTFILE(' +
     C                                         'QTEMP' + '/' +
     C                                         'DSPOBJD   ' + ')'
     C                   EVAL      w@lgth = %LEN(%TRIM(w@command))
     C                   CALL      'QCMDEXC'
     C                   PARM                    w@command
     C                   PARM                    w@lgth

      ** If Process Immediately = 'Y'

     C                   IF        PIMMED = 'Y'
     C                   CALL      'SCCOBJLCKJ'
     C                   ENDIF

      ** Leave

     C                   EVAL      *INLR = *ON
     C                   RETURN
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
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    inputFile
     C                   PARM                    inputLibrary
     C                   PARM                    inputType
     C                   PARM                    OutputFile
     C                   PARM                    OutputLibrary
     C                   PARM                    PIMMED

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
