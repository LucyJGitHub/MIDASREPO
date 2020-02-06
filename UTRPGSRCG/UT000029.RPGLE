     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Set up object and source names for CRTOBJ')   *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000029 - Replace fillers in creation parameters with       *
      *             passed in object and source file names.           *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUT008  *CREATE    Date 05Jan11               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUT008 - Rewrite of CRTOBJ.                                  *
      *                                                               *
      *****************************************************************
      *
     D PLibNObj        S             21
     D PLibNSrc        S             21
     D PSource         S              1
     D PCrtPrm         S            948
      *
     D FillerSPos      S              3  0
     D WFiller         S             21    INZ('**********/**********')
     D WFillerBIS      S             21    INZ('BISBISBISB/BISBISBISB')
      *
     D TxtToBeSrched   S            999                                         String to be searche
     D FndTxt          S            999                                         Text between argumen
     D LArg            S             50                                         Left Argument
     D RArg            S             50                                         Right Argument
     D FndTxtPos       S              3  0                                      PFndTxt start pos
     D FndTxtLen       S              3  0                                      PFndTxt length
      *
     D Recursive       S              1    INZ(*blank)
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLibNObj                       In
     C                   PARM                    PLibNSrc                       In
     C                   PARM                    PSource                        In
     C                   PARM                    PCrtPrm                        In/Out
      *
     C                   EXSR      FillLibNObj
      *
      * Scan and replace source file fillers only when there is source for the source
      * type (ie, PSource <> 'N')
     C                   IF        PSource <> 'N'
     C                   EXSR      FillLibNSrc
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  FillLibNObj - Replace object and library fillers with values *
      *                from PLibNObj.                                 *
      *                                                               *
      *****************************************************************
      *
     C     FillLibNObj   BEGSR
      *
      * Scan for '**********/**********' in PCrtPrm
     C     WFiller       SCAN      PCrtPrm       FillerSPos               90
      *
      * If not found, scan for BIS filler
     C                   IF        *IN90 = *OFF                                 WFiller not exist
     C     WFillerBIS    SCAN      PCrtPrm       FillerSPos               90
     C                   ENDIF
      *
      * If either '***' filler or BIS filler found, replace this filler with
      * object and library names.
     C                   IF        *IN90 = *ON
     C                   EVAL      PCrtPrm = %Replace(PLibNObj: PCrtPrm:
     C                                           FillerSPos: 21)
     C                   ENDIF
      *
     C     FillLibNObjE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  FillLibNSrc - Replace Source file and library fillers with   *
      *                values from PLibNSrc.                          *
      *                                                               *
      *****************************************************************
      *
     C     FillLibNSrc   BEGSR
      *
      * Call UT000027 to check if keyword SRCFILE exists in PCrtPrm
      *
     C                   CALL      'UT000027'
     C                   PARM      PCrtPrm       TxtToBeSrched
     C                   PARM      'SRCFILE('    LArg
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
      * If SRCFILE keyword found, replace the filler with library and source file names.
     C                   IF        FndTxtPos > 0
      *
     C                   IF        %Trim(FndTxt) = WFiller  or
     C                             %Trim(FndTxt) = WFillerBIS
      *
     C                   EVAL      PCrtPrm = %Replace(PLibNSrc: PCrtPrm:
     C                                           FndTxtPos: 21)
     C                   ENDIF
     C                   ENDIF
      *
     C     FillLibNSrcE  ENDSR
      *
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
