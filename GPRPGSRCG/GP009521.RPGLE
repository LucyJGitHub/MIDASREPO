     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2017')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Validate FATCA Filer Category')               *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP009521 - Midas GP FATCA Filer Category                     *
      *                                                               *
      *  (c) Finastra International Limited 2017                      *
      *                                                               *
      *  Last Amend No. CGL185  *CREATE    Date 13Mar17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL185 - FATCA XML 2.0                                       *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======

      ** EXTERNAL DS FOR Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFA1        E                     EXTFLD(QQDFAC)

      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Error message id in GBSDUSRMSG
     D ErrMsgId        S              7

      ** System value to be processed
     D SystemValue     S             20

      ** Processing mode
     D ProcMode        S            190

      ** General error indicator
     D GenError        S              1

      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0

      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)

     D BranchArr       S              3A   DIM(64)
     D FatcaArr        S              8A   DIM(8)

     D Y               S              2P 0
     D Z               S              2P 0
     D WField          S            200A
     D PBrch           S              3A
     D WBrch           S              3A
     D PRTCD           S              7A
     D POPTN           S              7A
     D SVAL1           S            200A
     D NewCurrVal      S            200A
     D pos             S              3S 0
     D WFatca          S              8A
     D WLoop           S              1A

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   EVAL      Idx = 1
     C                   EVAL      y = 1
     C                   EVAL      z = 1
     C                   EVAL      WLoop = 'Y'
     C                   EVAL      SVAL1 = NewCurrVal

     C                   EVAL      pos = %SCAN('FATCA':SVAL1)
     C                   IF        pos <> 1
     C                   EVAL      GenError = 'Y'
     C                   MOVEL     'GPM0514'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   EVAL      pos = %SCAN('?':SVAL1)
     C                   IF        pos <> 0
     C                   EVAL      GenError = 'Y'
     C                   MOVEL     'GPM0514'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   EVAL      WFatca = %SUBST(SVAL1:pos:8)
     C                   EXSR      SrFATCA6XX
     C                   EVAL      pos = pos + 8
     C                   EVAL      FatcaArr(z) = WFatca
     C                   EVAL      z = z + 1

     C                   DOW       WLoop = 'Y'

      ** check for blanks
     C                   IF        %SUBST(SVAL1:pos:3) = '   '
     C                   EVAL      WField = %SUBST(SVAL1:pos:(201-pos))

      ** validation complete
     C                   IF        WField = *Blanks
     C                   EVAL      GenError = ' '
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   EVAL      GenError = 'Y'
     C                   MOVEL     'GPM0515'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ENDIF

      ** check for Filer Category
     C                   IF        %SUBST(SVAL1:pos:5) = 'FATCA'
     C                   EVAL      WFatca = %SUBST(SVAL1:pos:8)
     C                   EXSR      SrFATCA6XX
     C                   EVAL      pos = pos + 8
     C                   EVAL      FatcaArr(z) = WFatca
     C                   EVAL      z = z + 1
     C                   ELSE
      ** check for valid branch
     C                   EVAL      WBrch = %SUBST(SVAL1:pos:3)
     C                   EXSR      SrBranch
     C                   EVAL      pos = pos + 3
     C                   EVAL      BranchArr(y) = WBrch
     C                   EVAL      y = y + 1
     C                   ENDIF

     C                   ENDDO

     C                   EVAL      GenError = ' '
     C                   EVAL      *INLR = *ON

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFATCA6XX - Subroutine to check FATCA Filer Category         *
      *                                                               *
      *****************************************************************
     C     SrFATCA6XX    BEGSR

     C                   IF        WFatca = 'FATCA601'
     C                             OR WFatca = 'FATCA602'
     C                             OR WFatca = 'FATCA603'
     C                             OR WFatca = 'FATCA604'
     C                             OR WFatca = 'FATCA605'
     C                             OR WFatca = 'FATCA606'
     C                             OR WFatca = 'FATCA610'
     C                             OR WFatca = 'FATCA611'
     C                   ELSE
     C                   EVAL      GenError = 'Y'
     C                   MOVEL     'GPM0516'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   IF        %LOOKUP(WFatca:FatcaArr:1:8) <> 0
     C                   EVAL      GenError = 'Y'
     C                   MOVEL     'GPM0517'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBranch - Subroutine to check valid branch                   *
      *                                                               *
      *****************************************************************
     C     SrBranch      BEGSR

     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     Poptn
     C                   PARM      WBrch         PBrch
     C     SDBRCH        PARM      SDBRCH        DSFDY

     C                   IF        Prtcd <> *Blanks
     C                   EVAL      GenError = 'Y'
     C                   MOVEL     'GPM0518'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   IF        %LOOKUP(WBrch:BranchArr:1:64) <> 0
     C                   EVAL      GenError = 'Y'
     C                   MOVEL     'GPM0519'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** System value to be processed
     C                   PARM                    SystemValue
      ** Value entered by user
     C                   PARM                    NewCurrVal
      ** Processing Mode
     C                   PARM                    ProcMode
      ** General Error Indicator
     C                   PARM                    GenError
      ** Error message ID (number of entries)
     C                   PARM                    Idx
      ** Error message ID (array)
     C                   PARM                    MsgIDXArr

     C                   ENDSR
     C
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      GenError = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR
