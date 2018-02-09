     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Straight line interpolation of a rate')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZAINTPL2 -   Perform Straight Line Interpolation of a Rate   *
      *                                                               *
      *  This module is similar to ZINTPL except for the rates are    *
      *  defined as 15,8.                                             *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 234440             Date 22Jun05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  234440 - Change control                                      *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      /EJECT
 
      ** Execute the standard subroutine
 
     C                   EXSR      ZINTPL
 
     C                   RETURN
      /EJECT
 
      ** +--- The converted ZINTPLZ2 starts here -------------------------+
      *****************************************************************
      *                                                               *
      *  ZINTPL - Standard Subroutine to Perform Straight Line        *
      *           Interpolation of a Rate.                            *
      *                                                               *
      *  NOTE: Rate Input fields are defined as 15,8 to allow         *
      *        Interpolation of Interest Rates, Exchange Rates or     *
      *        Discount Factors.                                      *
      *                                                               *
      *  Input:  ZINDAT ( 5,0) Near Date                              *
      *          ZIBDAT ( 5,0) Broken Date                            *
      *          ZIFDAT ( 5,0) Far Date                               *
      *          ZINRAT (15,8) Near Rate                              *
      *          ZIFRAT (15,8) Far Rate                               *
      *                                                               *
      *  Output: ZIBRAT (15,8) Broken Rate                            *
      *                                                               *
      *****************************************************************
      *
     C     ZINTPL        BEGSR                                                  *** ZINTPL ***
      *
      ***  Initialise Fields.
      *
     C                   Z-ADD     ZINDAT        ZINDAT            5 0
     C                   Z-ADD     ZIBDAT        ZIBDAT            5 0
     C                   Z-ADD     ZIFDAT        ZIFDAT            5 0
     C                   Z-ADD     ZINRAT        ZINRAT           15 8
     C                   Z-ADD     ZIFRAT        ZIFRAT           15 8
     C                   Z-ADD     0             ZIBRAT           15 8
      *
      ***  To interpolate by straight line, all that is required is to
      ***  add to the Near Rate a proportion of the difference between
      ***  the Near Rate and the Far Rate.
      ***
      ***                    Broken Date - Near Date
      ***  Increment Date = -------------------------
      ***                     Far Date - Near Rate
      ***
      ***  Increment Rate = (Far Rate - Near Rate) * Increment Date
      ***
      ***  Broken Rate = Near Rate + Increment Rate
      *
      ***  First set up the Increment Rate with the difference between
      ***  the Near Rate and the Far Rate.
      *
     C     ZIFRAT        SUB       ZINRAT        ZIIRAT           15 8
      *
      ***  Then calculate the proportion of the period from the Near
      ***  Date to the Far Date that equates to the Broken Date.
      *
     C     ZIBDAT        SUB       ZINDAT        ZIXDAT            5 0
     C     ZIFDAT        SUB       ZINDAT        ZIYDAT            5 0
     C     ZIXDAT        DIV       ZIYDAT        ZIIDAT           10 9                        234440
     C*****ZIXDAT        DIV       ZIYDAT        ZIIDAT            9 9                        234440
      *
      ***  Now the Proportion of the period can be applied to the
      ***  differential of the Rates to give the Increment Rate.
      *
     C                   MULT      ZIIDAT        ZIIRAT
      *
      ***  And finally the Increment Rate can be added to the Near Rate
      ***  to give the Broken Rate.
      *
     C     ZINRAT        ADD       ZIIRAT        ZIBRAT
      *
     C                   ENDSR
      *
      *****************************************************************
      ** +--- The converted ZINTPLZ2 ends here ---------------------------+
 
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
 
      ** INPUTS
 
     C                   PARM                    ZINDAT            5 0
     C                   PARM                    ZIBDAT            5 0
     C                   PARM                    ZIFDAT            5 0
     C                   PARM                    ZINRAT           15 8
     C                   PARM                    ZIFRAT           15 8
 
      ** OUTPUT
 
     C                   PARM                    ZIBRAT           15 8
 
     C                   ENDSR
      *****************************************************************
