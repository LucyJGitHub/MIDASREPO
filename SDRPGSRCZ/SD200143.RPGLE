     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Network Description - Details 3 Validat°')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200143 - Midas SD Network Description Maintenance    *
      *                   (Details 3 Screen Validation - MT941)       *
      *                                                               *
      *  Function:  This module validates the fields of the third     *
      *             detail screen of a Network record.                *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CMG008             Date 20Feb20               **
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL013  *CREATE    Date 25Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************
 
     FGLNW94L3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D3)
      ** Midas GL Network Accounts - MT94x - Live Records Allowing MT941
      *
 
      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Error Indicators                                                       *
      *                                                                        *
      * 40 - General Error Indicator                                           *
      * 41 - Allow MT941 Generation on Manual Request                          *
      * 42 - Default Message Status for Manual Request                         *
      * 43 - Allow MT941 Generation on Schedule                                *
      * 44 - Default Message Status for Schedule                               *
      * 45 - Allow MT941 Generation on External Request                        *
      * 46 - Default Message Status for External Request                       *
      * 47 - MT941 Maximum Message Length                                      *
      * 48 - Generate MT941 if no Movement                                     *
      * 49 - MT941 Re-Extract Shadow Postings                                  *
      * 50 - MT941 Re-Extract Real Postings since Last MT940                   *
      * 51 - Default MT941 Message Level Information to Account Owner (1)      *
      * 52 - Default MT941 Message Level Information to Account Owner (2)      *
      * 53 - Default MT941 Message Level Information to Account Owner (3)      *
      * 54 - Default MT941 Message Level Information to Account Owner (4)      *
      * 55 - Default MT941 Message Level Information to Account Owner (5)      *
      * 56 - Default MT941 Message Level Information to Account Owner (6)      *
      * (The DS IN40_TO_70 is used to cover the whole set of reserved error    *
      *  indicators)                                                           *
      *                                                                        *
      * Database Error Indicators                                              *
      *                                                                        *
      * U7 - Abnormal Completion                                               *
      * U8 - File Out of Balance                                               *
      * U7 + U8 - Database Error                                               *
      *                                                                        *
      * Other Indicators                                                       *
      *                                                                        *
      * 99 - Multi-purpose                                                     *
      *                                                                        *
      *========================================================================*
 
      *========================================================================*
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
 
     D NewFilRcd     E DS                  EXTNAME(SDNWRKPD)
      ** New Network File Record (i.e. new state after amendments)
      *
 
     D ScrLayout     E DS                  EXTNAME(SD200123DF:SD200123F3)
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
      *                      Details 3 Fields Validation                       *
      *------------------------------------------------------------------------*
 
      ** Allow MT941 Generation on Manual Request
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F31AMR = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN41
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F31AMR <> 'Y' AND F31AMR <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN41
 E2  C                   ENDIF
 
      ** -- The value can't be 'N' if there is at least one Network Account
      **    linked to the current Network Id. and allowing manual request
      **    for MT941
      *
 B2  C                   IF        F31AMR = 'N'
     C     EDNWRK        SETLL     GLNW94D3
     C     EDNWRK        READE     GLNW94D3                               99
 
 B3  C                   DOW       NOT *IN99
 
 B4  C                   IF        N41AMR = 'Y'
     C                   MOVE      'USR3998'     ZAMSID
     C                   MOVE      *On           *IN41
     C                   LEAVE
 E4  C                   ENDIF
 
     C     EDNWRK        READE     GLNW94D3                               99
 E3  C                   ENDDO
 
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
      ** End Allow MT941 Generation on Manual Request
 
      ** Default Message Status for Manual Request
      *
      ** -- The field must be blank if "Allow MT941 Generation on Manual
      **    Request" is 'N'
      *
     C                   IF        F31AMR = 'N' AND F31SMR <> *Blank
     C                   MOVE      'USR3979'     ZAMSID
     C                   MOVE      *On           *IN42
     C                   ENDIF
 
      ** -- The valid values are 'R' and 'C' if "Allow MT941 Generation on
      **    Manual Request" is 'Y'
      *
     C                   IF        F31AMR = 'Y' AND
     C                             F31SMR <> 'R' AND F31SMR <> 'C'
     C                   MOVE      'USR3980'     ZAMSID
     C                   MOVE      *On           *IN42
     C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN42
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default Message Status for Manual Request
 
      ** Allow MT941 Generation on Schedule
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F31AGS = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN43
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F31AGS <> 'Y' AND F31AGS <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN43
 E2  C                   ENDIF
 
      ** -- The value can't be 'N' if there is at least one Network Account
      **    linked to the current Network Id. and allowing on schedule request
      **    for MT941
      *
 B2  C                   IF        F31AGS = 'N'
     C     EDNWRK        SETLL     GLNW94D3
     C     EDNWRK        READE     GLNW94D3                               99
 
 B3  C                   DOW       NOT *IN99
 
 B4  C                   IF        N41AGS = 'Y'
     C                   MOVE      'USR3998'     ZAMSID
     C                   MOVE      *On           *IN43
     C                   LEAVE
 E4  C                   ENDIF
 
     C     EDNWRK        READE     GLNW94D3                               99
 E3  C                   ENDDO
 
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
      ** End Allow MT941 Generation on Schedule
 
      ** Default Message Status for Schedule
      *
      ** -- The field must be blank if "Allow MT941 Generation on Schedule"
      **    is 'N'
      *
     C                   IF        F31AGS = 'N' AND F31SGS <> *Blank
     C                   MOVE      'USR3979'     ZAMSID
     C                   MOVE      *On           *IN44
     C                   ENDIF
 
      ** -- The valid values are 'R' and 'C' if "Allow MT941 Generation on
      **    Schedule" is 'Y'
      *
     C                   IF        F31AGS = 'Y' AND
     C                             F31SGS <> 'R' AND F31SGS <> 'C'
     C                   MOVE      'USR3980'     ZAMSID
     C                   MOVE      *On           *IN44
     C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN44
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default Message Status for Schedule
 
      ** Allow MT941 Generation on External Request
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F31AER = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN45
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F31AER <> 'Y' AND F31AER <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN45
 E2  C                   ENDIF
 
      ** -- The value can't be 'N' if there is at least one Network Account
      **    linked to the current Network Id. and allowing external request
      **    for MT941
      *
 B2  C                   IF        F31AER = 'N'
     C     EDNWRK        SETLL     GLNW94D3
     C     EDNWRK        READE     GLNW94D3                               99
 
 B3  C                   DOW       NOT *IN99
 
 B4  C                   IF        N41AER = 'Y'
     C                   MOVE      'USR3998'     ZAMSID
     C                   MOVE      *On           *IN45
     C                   LEAVE
 E4  C                   ENDIF
 
     C     EDNWRK        READE     GLNW94D3                               99
 E3  C                   ENDDO
 
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
      ** End Allow MT941 Generation on External Request
 
      ** Default Message Status for External Request
      *
      ** -- The field must be blank if "Allow MT941 Generation on External
      **    Request" is 'N'
      *
     C                   IF        F31AER = 'N' AND F31SER <> *Blank
     C                   MOVE      'USR3979'     ZAMSID
     C                   MOVE      *On           *IN46
     C                   ENDIF
 
      ** -- The valid values are 'R' and 'C' if "Allow MT941 Generation on
      **    External Request" is 'Y'
      *
     C                   IF        F31AER = 'Y' AND
     C                             F31SER <> 'R' AND F31SER <> 'C'
     C                   MOVE      'USR3980'     ZAMSID
     C                   MOVE      *On           *IN46
     C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN46
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default Message Status for External Request
 
      ** MT941 Maximum Message Length
      *
      ** -- The value must be > 1 and <= 999999. As the field is only
      **    6 digits long, it isn't necessary to test the upper limit
      *
 B1  C                   IF        F31MXL <= 1
     C                   MOVE      'USR3975'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN47
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
 E1  C                   ENDIF
      *
      ** End MT941 Maximum Message Length
 
      ** Allow Generate MT941 if no Movement
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F31GNM = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN48
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F31GNM <> 'Y' AND F31GNM <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN48
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN48
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Generate MT941 if no Movement
 
      ** MT941 Re-Extract Shadow Postings
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F31RSP = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN49
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F31RSP <> 'Y' AND F31RSP <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN49
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN49
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End MT941 Re-Extract Shadow Postings
 
      ** MT941 Re-Extract Real Postings since Last MT940
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F31RPL = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN50
 
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F31RPL <> 'Y' AND F31RPL <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN50
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN50
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End MT941 Re-Extract Shadow Postings
 
      ** Default MT941 Message Level Information to Account Owner (1)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F31MI1 = *Blanks AND
     C                             (F31MI2 <> *Blanks OR F31MI3 <> *Blanks OR
     C                              F31MI4 <> *Blanks OR F31MI5 <> *Blanks OR
     C                              F31MI6 <> *Blanks)
     C                   MOVE      'USR3978'     ZAMSID
     C                   MOVE      *On           *IN51
     C                   ENDIF
 
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F31MI1 <> *Blanks
     C     SwiftXSet     CHECK     F31MI1:1                               99
     C   99              MOVE      'USR3997'     ZAMSID
     C   99              MOVE      *On           *IN51
     C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN51
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT941 Message Level Information to Account Owner (1)
 
      ** Default MT941 Message Level Information to Account Owner (2)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F31MI2 = *Blanks AND
     C                             (F31MI3 <> *Blanks OR F31MI4 <> *Blanks OR
     C                              F31MI5 <> *Blanks OR F31MI6 <> *Blanks)
     C                   MOVE      'USR3978'     ZAMSID
     C                   MOVE      *On           *IN52
     C                   ENDIF
 
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F31MI2 <> *Blanks
     C     SwiftXSet     CHECK     F31MI2:1                               99
     C   99              MOVE      'USR3997'     ZAMSID
     C   99              MOVE      *On           *IN52
     C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN52
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT941 Message Level Information to Account Owner (2)
 
      ** Default MT941 Message Level Information to Account Owner (3)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F31MI3 = *Blanks AND
     C                             (F31MI4 <> *Blanks OR F31MI5 <> *Blanks OR
     C                              F31MI6 <> *Blanks)
     C                   MOVE      'USR3978'     ZAMSID
     C                   MOVE      *On           *IN53
     C                   ENDIF
 
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F31MI3 <> *Blanks
     C     SwiftXSet     CHECK     F31MI3:1                               99
     C   99              MOVE      'USR3997'     ZAMSID
     C   99              MOVE      *On           *IN53
     C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN53
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT941 Message Level Information to Account Owner (3)
 
      ** Default MT941 Message Level Information to Account Owner (4)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F31MI4 = *Blanks AND
     C                             (F31MI5 <> *Blanks OR F31MI6 <> *Blanks)
     C                   MOVE      'USR3978'     ZAMSID
     C                   MOVE      *On           *IN54
     C                   ENDIF
 
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F31MI4 <> *Blanks
     C     SwiftXSet     CHECK     F31MI4:1                               99
     C   99              MOVE      'USR3997'     ZAMSID
     C   99              MOVE      *On           *IN54
     C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN54
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT941 Message Level Information to Account Owner (4)
 
      ** Default MT941 Message Level Information to Account Owner (5)
      *
      ** -- The field can't be blank if the following is filled
      *
     C                   IF        F31MI5 = *Blanks AND F31MI6 <> *Blanks
     C                   MOVE      'USR3978'     ZAMSID
     C                   MOVE      *On           *IN55
     C                   ENDIF
 
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F31MI5 <> *Blanks
     C     SwiftXSet     CHECK     F31MI5:1                               99
     C   99              MOVE      'USR3997'     ZAMSID
     C   99              MOVE      *On           *IN55
     C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN55
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT941 Message Level Information to Account Owner (5)
 
      ** Default MT941 Message Level Information to Account Owner (6)
      *
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F31MI6 <> *Blanks
     C     SwiftXSet     CHECK     F31MI6:1                               99
     C   99              MOVE      'USR3997'     ZAMSID
     C   99              EXSR      $ZaSndMsg
     C   99              MOVE      *On           *IN56
     C   99              MOVE      *On           *IN40
     C   99              MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT941 Message Level Information to Account Owner (6)
 
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
 
     C                   MOVEL     'SDUSRMSG'    ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *Blanks       ZAMSID            7
     C                   MOVEL     *Blanks       ZAMSDA          132
     C                   MOVEL     *Blanks       ZAMSTP            7
 
      ** Initialize error indicators with the values passed by the caller
      *
     C                   MOVEA     IN40_TO_70    *IN(40)
 
      ** Reset general error indicator
      *
     C                   MOVE      *Off          *IN40
 
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
 
     C                   CALLB     'DBERRCTL'
 
     C                   MOVEL(P)  '*ERROR'      RetCodeOut
     C                   EXSR      $ExitMod
      *    ----------    ------
     C     @PSSR         ENDSR
 
      *========================================================================*
**  CPY@
(c) Finastra International Limited 2002
