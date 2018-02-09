     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Exponential interpolation')
      *****************************************************************
      *                                                               *
      *  Midas - Standard Processing                                  *
      *                                                               *
      *  ZAXPINR - Perform Exponential Interpolation of a Rate        *
      *                                                               *
      *  Function:  This program interpolates between two points      *
      *             on an exponential curve.                          *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 218227 *CREATE     Date 27Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  218227 - Introduce a new program that will perform           *
      *           exponential interpolation of a rate.  This is in    *
      *           replacement of ZAEXPIN.                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators:                                           *
      *                                                               *
      *  LR             End Call of program                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine Index:                                            *
      *                                                               *
      *  *INZSR      - Program Initialisation Routine                 *
      *                                                               *
      *****************************************************************
      *
      ** Parameters
      *
     D PSDat           S              5  0
     D PNDat           S              5  0
     D PBDat           S              5  0
     D PFDat           S              5  0
     D PNRat           S             13  9
     D PFRat           S             13  9
     D PBRat           S             13  9
      *
      ** Work variables
      *
     D Result1         S              8F
     D Result2         S              8F
     D Result3         S              8F
     D Result4         S              8F
     D Result5         S              8F
     D Result6         S              8F
     D Result7         S              8F
      *
      ** Set work fields to zero.
      *
     C                   EVAL      Result1 = 0
     C                   EVAL      Result2 = 0
     C                   EVAL      Result3 = 0
     C                   EVAL      Result4 = 0
      *
      ** If Broken Date = Near Date then output Near Rate.
      *
     C                   IF        PBDat =  PNDat
     C                   EVAL      PBRat =  PNRat
     C                   ELSE
      *
      ** If Broken Date = Far Date then output Far Rate.
      *
     C                   IF        PBDat =  PFDat
     C                   EVAL      PBRat =  PFRat
     C                   ELSE
      *
      ** If Near Date = Spot Date, Result6 will always be 1.
      *
     C                   IF        PNDat =  PSDat
     C                   EVAL      Result6 = 1
     C                   ELSE
     C                   EVAL      Result1 = (PBDat - PSDat) /
     C                             (PNDat - PSDat)
     C                   EVAL      Result2 = PFDat - PBDat
     C                   EVAL      Result3 = PFDat - PNDat
     C                   EVAL      Result4 = Result2 / Result3
     C                   EVAL      Result5 = Result1 * Result4
     C                   EVAL      Result6 = PNRat ** Result5
     C                   ENDIF
      *
      ** If Far Date = Spot Date, Result7 will always be 1.
      *
     C                   IF        PFDat = PSDat
     C                   EVAL      Result7 = 1
     C                   ELSE
     C                   EVAL      Result1 = (PBDat - PSDat) /
     C                             (PFDat - PSDat)
     C                   EVAL      Result2 = PBDat - PNDat
     C                   EVAL      Result3 = PFDat - PNDat
     C                   EVAL      Result4 = Result2 / Result3
     C                   EVAL      Result5 = Result1 * Result4
     C                   EVAL      Result7 = PFRat ** Result5
     C                   ENDIF
     C                   EVAL      PBRat = Result6 * Result7
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      *INLR = '1'
     C                   RETURN
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
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
     C                   PARM                    PSDat
     C                   PARM                    PNDat
     C                   PARM                    PBDat
     C                   PARM                    PFDat
     C                   PARM                    PNRat
     C                   PARM                    PFRat
      *
      ** Output
      *
     C                   PARM                    PBRat
      *
     C                   ENDSR
 
