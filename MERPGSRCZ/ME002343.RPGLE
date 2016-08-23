     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network A/c MT94x Dtl Desc.- Dtl 3 Valid°')   *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002343 - Midas ME Network Account MT94x Details      *
      *                   Description Maintenance                     *
      *                   (Details 3 Screen Validation - MT941/1      *
      *                   Details)                                    *
      *                                                               *
      *  Function:  This module validates the fields of the third     *
      *             details screen of a Network Account MT94x Details *
      *             record.                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Error Indicators                                              *
      *                                                               *
      * 40 - General Error Indicator                                  *
      * 41 - Date/Time Indicator                                      *
      * 42 - Opening Balance Information                              *
      * 43 - Number and Sum of Entries (D/C)                          *
      * 44 - Closing Available Balance                                *
      * 45 - Forward Available Balance                                *
      * 46 - Default MT941 Message Level Info. to Account Owner (1)   *
      * 47 - Default MT941 Message Level Info. to Account Owner (2)   *
      * 48 - Default MT941 Message Level Info. to Account Owner (3)   *
      * 49 - Default MT941 Message Level Info. to Account Owner (4)   *
      * 50 - Default MT941 Message Level Info. to Account Owner (5)   *
      * 51 - Default MT941 Message Level Info. to Account Owner (6)   *
      * (The DS IN40_TO_70 is used to cover the whole set of reserved *
      *  error indicators)                                            *
      *                                                               *
      * Database Error Indicators                                     *
      *                                                               *
      * U7 - Abnormal Completion                                      *
      * U8 - File Out of Balance                                      *
      * U7 + U8 - Database Error                                      *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      * 99 - Multi-purpose                                            *
      *                                                               *
      *****************************************************************
 
      ** Automatically included D-specs
      ** ==============================
      *
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      ** Manually included D-specs
      ** =========================
      *
 
      ** Named constants
      ** ---------------
      *
 
      ** X SWIFT character set, minus Cr & Lf
      *
     D SwiftXSet       C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ-
     D                                     abcdefghijklmnopqrstuvwxyz-
     D                                     0123456789 /-?:().,''+'
 
      ** Arrays and Data Structures
      ** --------------------------
      *
 
     D NewFilRcd     E DS                  EXTNAME(GLNW94PD)
      ** New Network Account MT94x Details File Record (i.e. new state after amendments)
      *
 
     D ScrLayout     E DS                  EXTNAME(ME002323DF:ME002323F3)
      ** Detail 3 Screen Layout
      *
 
      ** Declared variables
      ** ------------------
      *
 
      ** Error Indicators Array
      *
     D IN40_TO_70      S              1    DIM(31)
 
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *
 
      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    CallerIn         10
     C                   PARM                    ScrLayout
     C                   PARM                    IN40_TO_70
     C                   PARM                    NewFilRcd
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR subroutine
 
      *------------------------------------------------------------------------*
      *                      Details 1 Fields Validation                       *
      *------------------------------------------------------------------------*
 
      ** Date/Time Indicator
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F31DTI = *Blank
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN41
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F31DTI <> 'Y' AND F31DTI <> 'N'
     C                   MOVE      'ME00042'     ZAMSID
     C                   MOVE      *On           *IN41
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN41
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Date/Time Indicator
 
      ** Opening Balance Information
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F31OBI = *Blank
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN42
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F31OBI <> 'Y' AND F31OBI <> 'N'
     C                   MOVE      'ME00042'     ZAMSID
     C                   MOVE      *On           *IN42
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN42
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Opening Balance Information
 
      ** Number and Sum of Entries (D/C)
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F31LSF = *Blank
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN43
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F31LSF <> 'Y' AND F31LSF <> 'N'
     C                   MOVE      'ME00042'     ZAMSID
     C                   MOVE      *On           *IN43
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN43
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Number and Sum of Entries (D/C)
 
      ** Closing Available Balance
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F31CAB = *Blank
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN44
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F31CAB <> 'Y' AND F31CAB <> 'N'
     C                   MOVE      'ME00042'     ZAMSID
     C                   MOVE      *On           *IN44
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN44
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Closing Available Balance
 
      ** Forward Available Balance
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F31FAB = *Blank
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN45
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F31FAB <> 'Y' AND F31FAB <> 'N'
     C                   MOVE      'ME00042'     ZAMSID
     C                   MOVE      *On           *IN45
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN45
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Forward Available Balance
 
      ** Default MT941 Information to Account Owner (1)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F31MI1 = *Blanks AND
     C                             (F31MI2 <> *Blanks OR F31MI3 <> *Blanks OR
     C                              F31MI4 <> *Blanks OR F31MI5 <> *Blanks OR
     C                              F31MI6 <> *Blanks)
     C                   MOVE      'ME00058'     ZAMSID
     C                   MOVE      *On           *IN46
     C                   ENDIF
 
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F31MI1 <> *Blanks
     C     SwiftXSet     CHECK     F31MI1:1                               99
     C   99              MOVE      'ME00059'     ZAMSID
     C   99              MOVE      *On           *IN46
     C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN46
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT941 Information to Account Owner (1)
 
      ** Default MT941 Information to Account Owner (2)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F31MI2 = *Blanks AND
     C                             (F31MI3 <> *Blanks OR F31MI4 <> *Blanks OR
     C                              F31MI5 <> *Blanks OR F31MI6 <> *Blanks)
     C                   MOVE      'ME00058'     ZAMSID
     C                   MOVE      *On           *IN47
     C                   ENDIF
 
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F31MI2 <> *Blanks
     C     SwiftXSet     CHECK     F31MI2:1                               99
     C   99              MOVE      'ME00059'     ZAMSID
     C   99              MOVE      *On           *IN47
     C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN47
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT941 Information to Account Owner (2)
 
      ** Default MT941 Information to Account Owner (3)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F31MI3 = *Blanks AND
     C                             (F31MI4 <> *Blanks OR F31MI5 <> *Blanks OR
     C                              F31MI6 <> *Blanks)
     C                   MOVE      'ME00058'     ZAMSID
     C                   MOVE      *On           *IN48
     C                   ENDIF
 
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F31MI3 <> *Blanks
     C     SwiftXSet     CHECK     F31MI3:1                               99
     C   99              MOVE      'ME00059'     ZAMSID
     C   99              MOVE      *On           *IN48
     C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN48
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT941 Information to Account Owner (3)
 
      ** Default MT941 Information to Account Owner (4)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F31MI4 = *Blanks AND
     C                             (F31MI5 <> *Blanks OR F31MI6 <> *Blanks)
     C                   MOVE      'ME00058'     ZAMSID
     C                   MOVE      *On           *IN49
     C                   ENDIF
 
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F31MI4 <> *Blanks
     C     SwiftXSet     CHECK     F31MI4:1                               99
     C   99              MOVE      'ME00059'     ZAMSID
     C   99              MOVE      *On           *IN49
     C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN49
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT941 Information to Account Owner (4)
 
      ** Default MT941 Information to Account Owner (5)
      *
      ** -- The field can't be blank if the following is filled
      *
     C                   IF        F31MI5 = *Blanks AND F31MI6 <> *Blanks
     C                   MOVE      'ME00058'     ZAMSID
     C                   MOVE      *On           *IN50
     C                   ENDIF
 
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F31MI5 <> *Blanks
     C     SwiftXSet     CHECK     F31MI5:1                               99
     C   99              MOVE      'ME00059'     ZAMSID
     C   99              MOVE      *On           *IN50
     C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN50
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT941 Information to Account Owner (5)
 
      ** Default MT941 Information to Account Owner (6)
      *
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F31MI6 <> *Blanks
     C     SwiftXSet     CHECK     F31MI6:1                               99
     C   99              MOVE      'ME00059'     ZAMSID
     C   99              EXSR      $ZaSndMsg
     C   99              MOVE      *On           *IN51
     C   99              MOVE      *On           *IN40
     C   99              MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT941 Information to Account Owner (6)
 
      ** End of the module
      *
     C                   EXSR      $ExitMod
 
      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*
 
      *========================================================================*
      * $ZaSndMsg : Send message to the program message queue                  *
      *------------------------------------------------------------------------*
     C     $ZaSndMsg     BEGSR
      *    ----------    ------
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *    ----------    ------
     C     @ZaSndMsg     ENDSR
 
      *========================================================================*
      * $ExitMod  : Exit from the module                                       *
      *------------------------------------------------------------------------*
     C     $ExitMod      BEGSR
      *    ----------    ------
      ** Return the current values of the error indicators
      *
     C                   MOVEA     *IN(40)       IN40_TO_70
 
     C                   MOVE      *On           *INLR
     C                   RETURN
      *    ----------    ------
     C     @ExitMod      ENDSR
 
      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *========================================================================*
     C     *INZSR        BEGSR
      *    ----------    ------
      ** Initialise Copyright Array
      *
     C                   MOVEA     CPY@          CPY@@            80
 
      ** Define fields used by the message sending function
      *
      ** -- If no named caller --> set-up ZAPGM with the current program name
      *
     C                   IF        CallerIn = *Blanks
     C                   MOVEL     PSProcPgm     ZAPGM            10
 
      ** -- Otherwise set-up ZAPGM with the caller name
      *
     C                   ELSE
     C                   MOVEL     CallerIn      ZAPGM
     C                   ENDIF
 
     C                   MOVEL     'MEMSG'       ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *Blanks       ZAMSID            7
     C                   MOVEL     *Blanks       ZAMSDA          132
     C                   MOVEL     *Blanks       ZAMSTP            7
 
      ** Initialize error indicators with the values passed by the caller
      *
     C                   MOVEA     IN40_TO_70    *IN(40)
 
      ** Reset general error indicator
      *
     C                   MOVE      *OFF          *IN40
 
      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks
      *    ----------    ------
     C     @INZSR        ENDSR
 
      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
     C     *PSSR         BEGSR
      *    ----------    ------
     C                   DUMP
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
 
     C                   CALLB     'DBERRCTL'                           99
 
     C                   MOVEL(P)  '*ERROR'      RetCodeOut
     C                   EXSR      $ExitMod
      *    ----------    ------
     C     @PSSR         ENDSR
 
      *========================================================================*
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
