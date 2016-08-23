     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Find text between two arguments')             *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000027 - Retrieve text between two arguments               *
      *             The two arguments will be trimmed to remove any   *
      *             leading blanks before the scan.                   *
      *             The text between the two arguments, its length    *
      *             and its start position in the string will be      *
      *             returned if found.                                *
      *             If either of the two arguments not found in the   *
      *             string, parameter PFndTxtPos will be returned with*
      *             value 0.                                          *
      *             Any error, U7U8 will be set ON.                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CUT008  *CREATE    Date 21Dec10               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CUT008 - CRTOBJ rewrite.                                     *
      *                                                               *
      *****************************************************************
      *
     D PString         S            999
     D PFndTxt         S            999
     D PLArg           S             50
     D PRArg           S             50
     D PFndTxtPos      S              3  0
     D PFndTxtLen      S              3  0
      *
     D LLen            S              3  0
     D RLen            S              3  0
     D SPos            S              3  0
      *
     D WLArg           S             50
     D WRArg           S             50
     D LArgStrPos      S              3  0
     D RArgStrPos      S              3  0
      *
     D Recursive       S              1    INZ(*blank)
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    PString                        In
     C                   PARM                    PLArg                          In
     C                   PARM                    PRArg                          In
     C                   PARM                    PFndTxt                        Out
     C                   PARM                    PFndTxtPos                     Out
     C                   PARM                    PFndTxtLen                     Out
      *
      * Initialise returned parameters
     C                   EVAL      PFndTxt    = *blank
     C                   EVAL      PFndTxtPos = 0
     C                   EVAL      PFndTxtLen = 0
      *
      * Trim the left argument and save in work field WLArg
     C                   EVAL      WLArg = %trim(PLArg)
      *
      * Get the length of the left argument
     C                   EVAL      LLen = %len(%trim(PLArg))
      *
      * Find start position of the right argument in the string PString
     C     WLArg:LLen    SCAN      PString       LArgStrPos               90
      *
     C                   IF        *IN90 = *ON                                  Left argument fnd
      *
      * Trim the right argument and save in work field WRArg
     C                   EVAL      WRArg = %trim(PRArg)
      *
      * Get the length of the right argument
     C                   EVAL      RLen = %len(%trim(PRArg))
      *
      * Find start position of the right argument search after the left argument
      *   and scan for the right argument in string PString
     C                   EVAL      SPos = LArgStrPos + LLen
     C     WRArg:RLen    SCAN      PString:SPos  RArgStrPos               90
      *
      * If right argument found, find the length and the string between the
      *   left and righ arguments to be returned.
     C                   IF        *IN90 = *ON                                  right argument fnd
     C                   EVAL      PFndTxtLen = RArgStrPos - SPos
     C                   EVAL      PFndTxt = %SUBST(PString:SPos:
     C                                       PFndTxtLen)
     C                   EVAL      PFndTxtPos = SPos
     C                   ENDIF                                                  End (Right Arg fnd)
      *
      * If NOT both arguments found, the PFndTxtPos will be zero.
      *
     C                   ENDIF                                                  End (Left Arg fnd)
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
