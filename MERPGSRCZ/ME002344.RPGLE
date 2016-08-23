     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network A/c MT94x Dtl Desc.- Dtl 4 Valid°')   *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002344 - Midas ME Network Account MT94x Details      *
      *                   Description Maintenance                     *
      *                   (Details 4 Screen Validation - MT941/2      *
      *                   Details)                                    *
      *                                                               *
      *  Function:  This module validates the fields of the fourth    *
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
      *                 CGL029             Date 01Sep03               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
 
     FGLGS94L1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLGS94D0:GLGS94D1)
      ** Midas GL MT941/942 Generation Schedules - Retrieve
      *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Error Indicators                                              *
      *                                                               *
      * 40 - General Error Indicator                                  *
      * 41 - Generation if no Movement                                *
      * 42 - Allow Generation on External Request                     *
      * 43 - Allow Generation on Schedule                             *
      * 44 - Allow Generation on Manual Request                       *
      * 45 - Re-Extract all Postings from Last MT940                  *
      * 46 - Re-Extract all Shadow Postings                           *
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
 
      ** Arrays and Data Structures
      ** --------------------------
      *
 
     D NewFilRcd     E DS                  EXTNAME(GLNW94PD)
      ** New Network Account MT94x Details File Record (i.e. new state after amendments)
      *
 
     D ScrLayout     E DS                  EXTNAME(ME002324DF:ME002324F4)
      ** Detail 4 Screen Layout
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
     C                   PARM                    MT940StFq         1
 
      ** Key lists
      *
     C     KGLGS94L1     KLIST
     C                   KFLD                    N4NWRK
     C                   KFLD                    N4BRCA
     C                   KFLD                    N4CNUM
     C                   KFLD                    N4CCY
     C                   KFLD                    N4ACCD
     C                   KFLD                    N4ACSQ
     C                   KFLD                    N4NATY
     C                   KFLD                    N4DSTN
     C                   KFLD                    GSMTPY
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR subroutine
 
      *------------------------------------------------------------------------*
      *                      Details 1 Fields Validation                       *
      *------------------------------------------------------------------------*
 
      ** Generation if no Movement
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F41GNM = *Blank
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN41
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F41GNM <> 'Y' AND F41GNM <> 'N'
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
      ** End Generation if no Movement
 
      ** Allow Generation on External Request
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F41AER = *Blank
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN42
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F41AER <> 'Y' AND F41AER <> 'N'
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
      ** End Allow Generation on External Request
 
      ** Allow Generation on Schedule
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F41AGS = *Blank
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN43
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F41AGS <> 'Y' AND F41AGS <> 'N'
     C                   MOVE      'ME00042'     ZAMSID
     C                   MOVE      *On           *IN43
 E2  C                   ENDIF
 
      ** -- The field can't be 'N' if there is at least one linked
      **    generation schedule
      *
 B2  C                   IF        F41AGS = 'N'
     C                   EVAL      GSMTPY = '941'
     C     KGLGS94L1     SETLL     GLGS94D1                               99
     C   99              MOVE      'ME00063'     ZAMSID
     C   99              MOVE      *On           *IN43
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
      ** End Allow Generation on Schedule
 
      ** Allow Generation on Manual Request
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F41AMR = *Blank
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN44
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F41AMR <> 'Y' AND F41AMR <> 'N'
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
      ** End Allow Generation on Manual Request
 
      ** Re-Extract all Postings from Last MT940
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F41RPL = *Blank
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN45
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F41RPL <> 'Y' AND F41RPL <> 'N'
     C                   MOVE      'ME00042'     ZAMSID
     C                   MOVE      *On           *IN45
 E2  C                   ENDIF
 
      ***--*The*field can be 'Y' only if the MT940 statement frequency isn't
      ******'D'*or*blank
      **************
 B2  C**************     IF        F41RPL = 'Y' AND
     C**************               (MT940StFq = 'D' OR MT940StFq = *Blank)
     C**************     MOVE      'ME00061'     ZAMSID
     C**************     MOVE      *On           *IN45
 E2  C**************     ENDIF
 
 E1  C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN45
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Re-Extract all Postings from Last MT940
 
      ** Re-Extract all Shadow Postings
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F41RAS = *Blank
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN46
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F41RAS <> 'Y' AND F41RAS <> 'N'
     C                   MOVE      'ME00042'     ZAMSID
     C                   MOVE      *On           *IN46
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN46
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Re-Extract all Shadow Postings
 
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
