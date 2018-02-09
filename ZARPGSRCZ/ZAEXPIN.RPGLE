     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Exponential interpolation')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  RPGLE/ZAEXPIN - Perform Exponential Interpolation of a Rate  *
      *                                                               *
      *  Function:  This program interpolates between two points      *
      *             on an exponential curve.                          *
      *             This is basically ZEXPIN converted to RPG ILE.    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 211373             Date 05Mar03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  211373 - MCH1211 unmonitored - cannot divide by zero at 74.  *
      *           Problem occur when near date, far date and spot     *
      *           date are the same. Add a 3rd select statement for   *
      *           this scenario. This is based on code copied from    *
      *           original PL1 program ZEXPIN.                        *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
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
 
      /EJECT
 
      ** Work variables
 
     D WRdat           S             13  9
     D WRRat           S             13  9
 
      ** Parameters
 
     D PSDat           S              5  0
     D PNDat           S              5  0
     D PBDat           S              5  0
     D PFDat           S              5  0
     D PNRat           S             13  9
     D PFRat           S             13  9
     D PBRat           S             13  9
 
      /EJECT
 
     C                   Select
 
      ** When near date equals the interpolation date, interpolated rate
      ** would be the near rate
 
     C                   When      PNDat = PBDat
     C                   eval      PBRat = PNRat
 
      ** When far date equals the interpolation date, interpolated rate
      ** would be the far rate
 
     C                   When      PFDat = PBDat
     C                   eval      PBRat = PFRat
 
      ** When far date equals the spot date, interpolated rate                                211373
      ** will always be 1.                                                                    211373
                                                                                              211373
     C                   When      PFDat = PSDat                                              211373
     C                   eval      PBRat = 1                                                  211373
                                                                                              211373
      ** When the unknown rate falls after Spot and prior to the first
      ** known rate,
 
     C                   When      PNDat = PSDat
     C                   eval      WRdat = (PBDat - PSDat) / (PFDat - PSDat)
     C                   If        PFRat <> 0
     C                   eval      PBRat = PFRat ** WRdat
     C                   else
     C                   eval      PBRat = 0
     C                   endif
 
      ** When the unknown rate falls after the last known rate,
 
     C                   When      PFDat = 0
     C                   eval      WRdat = (PBDat - PSDat) / (PNDat - PSDat)
     C                   If        PNRat <> 0
     C                   eval      PBRat = PNRat ** WRdat
     C                   else
     C                   eval      PBRat = 0
     C                   endif
 
     C                   Other
 
      ** Result 5
 
     C                   eval      WRdat = (PBDat - PSDat) / (PNDat - PSDat)
     C                             * (PFDat - PBDat) / (PFDat - PNDat)
 
      ** Result 6
 
     C                   If        PNRat <> 0
     C                   eval      WRRat = PNRat ** WRdat
     C                   else
     C                   eval      WRRat = 0
     C                   endif
 
      ** When far date equals spot date, Result 7 will be 1.
 
     C                   If        PFDat = PSDat
     C                   eval      PBRat = 1
     C                   else
 
      ** Result 5
 
     C                   eval      WRdat = (PBDat - PSDat) / (PFDat - PSDat)
     C                             * (PBDat - PNDat) / (PFDat - PNDat)
 
      ** Result 7
 
     C                   If        PFRat <> 0
     C                   eval      PBRat = PFRat ** WRdat
     C                   else
     C                   eval      PBRat = 0
     C                   endif
     C                   endif
 
      ** Interpolated Rate
 
     C                   eval      PBRat = WRRat * PBRat
 
     C                   Endsl
 
     C                   eval      *INLR = *ON
 
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
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
 
      ** Inputs
 
     C                   PARM                    PSDat
     C                   PARM                    PNDat
     C                   PARM                    PBDat
     C                   PARM                    PFDat
     C                   PARM                    PNRat
     C                   PARM                    PFRat
 
      ** Output
 
     C                   PARM                    PBRat
 
     C                   ENDSR
 
