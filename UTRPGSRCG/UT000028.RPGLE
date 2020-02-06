     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Check if MIDASBNDDR is in BNDDIR list')       *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000028 - Check if MIDASBNDDR is specified in the BNDDIR    *
      *             list for creation parameter for CRTOBJ            *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUT008  *CREATE    Date 21Dec10               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUT008 - Rewrite of CRTOBJ.                                  *
      *                                                               *
      *****************************************************************
      *
     D PCrtPrm         S            948
     D PFound          S              1
      *
     D TxtToBeSrched   S            999
     D FndTxt          S            999
     D LArg            S             50
     D RArg            S             50
     D FndTxtPos       S              3  0
     D FndTxtLen       S              3  0
     D MBNDDRPos       S              3  0 INZ(0)
      *
     D Recursive       S              1    INZ(*blank)
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    PCrtPrm                        In
     C                   PARM                    PFound                         Out
      *
      * Initialise returned parameter
     C                   EVAL      PFound = 'N'
      *
      * Call UT000027 to check if keyword BNDDIR exists in PCrtPrm
      *
     C                   CALL      'UT000027'
     C                   PARM      PCrtPrm       TxtToBeSrched
     C                   PARM      'BNDDIR('     LArg
     C                   PARM      ')'           RArg
     C                   PARM                    FndTxt
     C                   PARM                    FndTxtPos
     C                   PARM                    FndTxtLen
      *
     C                   IF        *INU7 = *ON and
     C                             *INU8 = *ON
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      * If key word BNDDIR found, cehck if MIDASBNDDR is in the parameter list
     C                   IF        FndTxtPos > 0
      *
      * Scan 'MIDASBNDDR' in the parameter list for BNDDIR
     C     'MIDASBNDDR'  SCAN      FNDTXT        MBNDDRPos                90
      *
      * If MIDASBNDR is found in parameter list for BNDDIR, set return code
      *   to 'Y'.
     C                   IF        *IN90 = *ON
     C                   EVAL      PFound = 'Y'
     C                   ENDIF
      *
     C                   ENDIF                                                  END (EndTxtPos > 0)
      *
     C                   EVAL      *INLR = *ON
 
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
