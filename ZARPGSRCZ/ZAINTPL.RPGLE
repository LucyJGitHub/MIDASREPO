     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Straight Line Interpolation of a Rate')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  RPGLE/ZAINTPL - Perform Straight Line Interpolation of a     *
      *                  Rate                                         *
      *                                                               *
      *  Function: This module is a conversion of Midas standard      *
      *            routine ZINTPL.                                    *
      *            This method adds to the Near Rate a proportion of  *
      *            the difference between the Near Rate and the Far   *
      *            Rate. It will be used for yield curves whose in-   *
      *            terpolation method is equal to:                    *
      *            'S' - Straight Line Interpolation between Discount *
      *                  Factors                                      *
      *            'Y' - Straight Line Interpolation bet. Yield Rates *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CAS001  *CREATE    Date 23Nov01               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
      *  SRCalIntRat - Subroutine that performs Straight Line         *
      *                Interpolation of a Rate.                       *
      *                                                               *
      *****************************************************************
 
      /EJECT
 
      ** Work variables
 
     D WIXDat          s              5  0
     D WIYDat          s              5  0
     D WIIDat          s              9  9
     D WIIRat          s             13  9
 
      ** Parameters
 
     D PINDat          s              5  0
     D PIBDat          s              5  0
     D PIFDat          s              5  0
     D PINRat          s             13  9
     D PIFRat          s             13  9
     D PIBRat          s             13  9
 
      /EJECT
 
      ** Execute the standard subroutine
 
     C                   EXSR      SRCalIntRat
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCalIntRat - Subroutine that performs Straight Line          *
      *                Interpolation of a Rate.                       *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCalIntRat   BEGSR
 
      ** Initialise Fields.
 
     C                   Z-ADD     0             PIBRat
 
      ** To interpolate by straight line, all that is required is to
      ** add to the Near Rate a proportion of the difference between
      ** the Near Rate and the Far Rate.
      **
      ** Interpolated Rate = Near Rate + Increment Rate
      **
      ** Where:
      **                                           Interpolation Date - Near Date
      ** Increment Rate = (Far Rate - Near Rate) * ------------------------------
      **                                                Far Date - Near Date
      **
      ** First set up the Increment Rate with the difference between
      ** the Near Rate and the Far Rate.
 
     C     PIFRat        SUB       PINRat        WIIRat
 
      ** Then calculate the proportion of the period from the Near
      ** Date to the Far Date that equates to the Broken Date.
 
     C     PIBDat        SUB       PINDat        WIXDat
     C     PIFDat        SUB       PINDat        WIYDat
     C*                  IF        (WIXDat <> 0) AND (WIYDat = 0)
     C*                  ELSE
     C     WIXDat        DIV       WIYDat        WIIDat
     C*                  ENDIF
 
      ** Now the Proportion of the period can be applied to the
      ** differential of the Rates to give the Increment Rate.
 
     C                   MULT      WIIDat        WIIRat
 
      ** And finally the Increment Rate can be added to the Near Rate
      ** to give the Broken Rate.
 
     C     PINRat        ADD       WIIRat        PIBRat
      *
     C                   ENDSR
 
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
 
     C                   PARM                    PINDat
     C                   PARM                    PIBDat
     C                   PARM                    PIFDat
     C                   PARM                    PINRat
     C                   PARM                    PIFRat
 
      ** Output
 
     C                   PARM                    PIBRat
 
     C                   ENDSR
 
