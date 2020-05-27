     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Network Description - Details 4 Validat°')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200144 - Midas SD Network Description Maintenance    *
      *                   (Details 4 Screen Validation - MT942)       *
      *                                                               *
      *  Function:  This module validates the fields of the fourth    *
      *             detail screen of a Network record.                *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CMG008             Date 20Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22807           Date 26Feb09               *
      *                 CER030             Date 09Jul08               *
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
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22807 - Generation of MT942s in MMM on the basis of       *
      *             maximum message length                            *
      *  CER030 - Multicash German Feature                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************

     FGLNW94L4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D4)
      ** Midas GL Network Accounts - MT94x - Live Records Allowing MT942
      *

      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Error Indicators                                                       *
      *                                                                        *
      * 40 - General Error Indicator                                           *
      * 41 - Allow MT942 Generation on Manual Request                          *
      * 42 - Default Message Status for Manual Request                         *
      * 43 - Allow MT942 Generation on Schedule                                *
      * 44 - Default Message Status for Schedule                               *
      * 45 - Allow MT942 Generation on External Request                        *
      * 46 - Default Message Status for External Request                       *
      * 47 - MT942 Maximum Message Length                                      *
      * 48 - Generate MT942 if no Movement                                     *
      * 49 - Fix Number of Items per Message                                   *
      * 50 - Number of Items per Message                                       *
      * 51 - MT942 Re-Extract Shadow Postings                                  *
      * 52 - MT942 Re-Extract Real Postings since Last MT940                   *
      * 53 - Default MT942 Message Level Information to Account Owner (1)      *
      * 54 - Default MT942 Message Level Information to Account Owner (2)      *
      * 55 - Default MT942 Message Level Information to Account Owner (3)      *
      * 56 - Default MT942 Message Level Information to Account Owner (4)      *
      * 57 - Default MT942 Message Level Information to Account Owner (5)      *
      * 58 - Default MT942 Message Level Information to Account Owner (6)      *
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

     D ScrLayout     E DS                  EXTNAME(SD200124DF:SD200124F4)
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

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

      *------------------------------------------------------------------------*
      *                      Details 4 Fields Validation                       *
      *------------------------------------------------------------------------*

      ** Allow MT942 Generation on Manual Request
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F42AMR = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN41

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F42AMR <> 'Y' AND F42AMR <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN41
 E2  C                   ENDIF

      ** -- The value can't be 'N' if there is at least one Network Account
      **    linked to the current Network Id. and allowing manual request
      **    for MT942
      *
 B2  C                   IF        F42AMR = 'N'
     C     EDNWRK        SETLL     GLNW94D4
     C     EDNWRK        READE     GLNW94D4                               99

 B3  C                   DOW       NOT *IN99

 B4  C                   IF        N42AMR = 'Y'
     C                   MOVE      'USR3998'     ZAMSID
     C                   MOVE      *On           *IN41
     C                   LEAVE
 E4  C                   ENDIF

     C     EDNWRK        READE     GLNW94D4                               99
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
      ** End Allow MT942 Generation on Manual Request

      ** Default Message Status for Manual Request
      *
      ** -- The field must be blank if "Allow MT942 Generation on Manual
      **    Request" is 'N'
      *
     C                   IF        F42AMR = 'N' AND F42SMR <> *Blank
     C                   MOVE      'USR3979'     ZAMSID
     C                   MOVE      *On           *IN42
     C                   ENDIF

      ** -- The valid values are 'R' and 'C' if "Allow MT942 Generation on
      **    Manual Request" is 'Y'
      *
     C                   IF        F42AMR = 'Y' AND
     C                             F42SMR <> 'R' AND F42SMR <> 'C'
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

      ** Allow MT942 Generation on Schedule
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F42AGS = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN43

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F42AGS <> 'Y' AND F42AGS <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN43
 E2  C                   ENDIF

      ** -- The value can't be 'N' if there is at least one Network Account
      **    linked to the current Network Id. and allowing on schedule request
      **    for MT942
      *
 B2  C                   IF        F42AGS = 'N'
     C     EDNWRK        SETLL     GLNW94D4
     C     EDNWRK        READE     GLNW94D4                               99

 B3  C                   DOW       NOT *IN99

 B4  C                   IF        N42AGS = 'Y'
     C                   MOVE      'USR3998'     ZAMSID
     C                   MOVE      *On           *IN43
     C                   LEAVE
 E4  C                   ENDIF

     C     EDNWRK        READE     GLNW94D4                               99
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
      ** End Allow MT942 Generation on Schedule

      ** Default Message Status for Schedule
      *
      ** -- The field must be blank if "Allow MT942 Generation on Schedule"
      **    is 'N'
      *
     C                   IF        F42AGS = 'N' AND F42SGS <> *Blank
     C                   MOVE      'USR3979'     ZAMSID
     C                   MOVE      *On           *IN44
     C                   ENDIF

      ** -- The valid values are 'R' and 'C' if "Allow MT942 Generation on
      **    Schedule" is 'Y'
      *
     C                   IF        F42AGS = 'Y' AND
     C                             F42SGS <> 'R' AND F42SGS <> 'C'
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

      ** Allow MT942 Generation on External Request
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F42AER = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN45

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F42AER <> 'Y' AND F42AER <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN45
 E2  C                   ENDIF

      ** -- The value can't be 'N' if there is at least one Network Account
      **    linked to the current Network Id. and allowing external request
      **    for MT942
      *
 B2  C                   IF        F42AER = 'N'
     C     EDNWRK        SETLL     GLNW94D4
     C     EDNWRK        READE     GLNW94D4                               99

 B3  C                   DOW       NOT *IN99

 B4  C                   IF        N42AER = 'Y'
     C                   MOVE      'USR3998'     ZAMSID
     C                   MOVE      *On           *IN45
     C                   LEAVE
 E4  C                   ENDIF

     C     EDNWRK        READE     GLNW94D4                               99
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
      ** End Allow MT942 Generation on External Request

      ** Default Message Status for External Request
      *
      ** -- The field must be blank if "Allow MT942 Generation on External
      **    Request" is 'N'
      *
     C                   IF        F42AER = 'N' AND F42SER <> *Blank
     C                   MOVE      'USR3979'     ZAMSID
     C                   MOVE      *On           *IN46
     C                   ENDIF

      ** -- The valid values are 'R' and 'C' if "Allow MT942 Generation on
      **    External Request" is 'Y'
      *
     C                   IF        F42AER = 'Y' AND
     C                             F42SER <> 'R' AND F42SER <> 'C'
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

      ** MT942 Maximum Message Length
      *
      ** -- The value must be > 1 and <= 999999. As the field is only
      **    6 digits long, it isn't necessary to test the upper limit
      *
 B1  C                   IF        F42MXL <= 1
     C                   MOVE      'USR3975'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN47
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
 E1  C                   ENDIF
      *                                                                                     BUG22807
      ** The maximum message length should not be more then 10000                           BUG22807
      ** for swift network or the Type of protocol is *MDBA                                 BUG22807
      *                                                                                     BUG22807
     C                   IF        (EDNWRK ='SWIFT'                                         BUG22807
     C                             OR EDPROT = '*MDBA')                                     BUG22807
     C                             AND F42MXL > 10000                                       BUG22807
     C                   MOVE      'USR8313'     ZAMSID                                     BUG22807
     C                   EXSR      $ZaSndMsg                                                BUG22807
     C                   MOVE      *ON           *IN47                                      BUG22807
     C                   MOVE      *ON           *IN40                                      BUG22807
     C                   MOVEL(P)  '*MSG'        RetCodeOut                                 BUG22807
     C                   ENDIF                                                              BUG22807
      *
      ** End MT942 Maximum Message Length

      ** Allow Generate MT942 if no Movement
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F42GNM = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN48

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F42GNM <> 'Y' AND F42GNM <> 'N'
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
      ** End Generate MT942 if no Movement

      ** Fix Number of Items per Message
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F42FNI = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN49

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F42FNI <> 'Y' AND F42FNI <> 'N'
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
      ** End Fix Number of Items per Message

      ** Number of Items per Message
      *
      ** -- The field must be zero if "Fix Number of Items per Message"
      **    is 'N'
      *
     C                   IF        F42FNI = 'N' AND F42NIM <> 0
     C                   MOVE      'USR3981'     ZAMSID
     C                   MOVE      *On           *IN50
     C                   ENDIF

      ** -- The field must be greater than zero if "Fix Number of Items
      **    per Message" is 'Y'
      *
     C                   IF        F42FNI = 'Y' AND F42NIM <= 0
     C                   MOVE      'USR3982'     ZAMSID
     C                   MOVE      *On           *IN50
     C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN50
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Number of Items per Message

      ** MT942 Re-Extract Shadow Postings
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F42RSP = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN51

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F42RSP <> 'Y' AND F42RSP <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN51
 E2  C                   ENDIF

 E1  C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN51
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End MT942 Re-Extract Shadow Postings

      ** MT942 Re-Extract Real Postings since Last MT940
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F42RPL = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN52

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F42RPL <> 'Y' AND F42RPL <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN52
 E2  C                   ENDIF

 E1  C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN52
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End MT942 Re-Extract Shadow Postings

      ** Default MT942 Message Level Information to Account Owner (1)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F42MI1 = *Blanks AND
     C                             (F42MI2 <> *Blanks OR F42MI3 <> *Blanks OR
     C                              F42MI4 <> *Blanks OR F42MI5 <> *Blanks OR
     C                              F42MI6 <> *Blanks)
     C                   MOVE      'USR3978'     ZAMSID
     C                   MOVE      *On           *IN53
     C                   ENDIF

      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F42MI1 <> *Blanks
     C     SwiftXSet     CHECK     F42MI1:1                               99
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
      ** End Default MT942 Message Level Information to Account Owner (1)

      ** Default MT942 Message Level Information to Account Owner (2)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F42MI2 = *Blanks AND
     C                             (F42MI3 <> *Blanks OR F42MI4 <> *Blanks OR
     C                              F42MI5 <> *Blanks OR F42MI6 <> *Blanks)
     C                   MOVE      'USR3978'     ZAMSID
     C                   MOVE      *On           *IN54
     C                   ENDIF

      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F42MI2 <> *Blanks
     C     SwiftXSet     CHECK     F42MI2:1                               99
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
      ** End Default MT942 Message Level Information to Account Owner (2)

      ** Default MT942 Message Level Information to Account Owner (3)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F42MI3 = *Blanks AND
     C                             (F42MI4 <> *Blanks OR F42MI5 <> *Blanks OR
     C                              F42MI6 <> *Blanks)
     C                   MOVE      'USR3978'     ZAMSID
     C                   MOVE      *On           *IN55
     C                   ENDIF

      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F42MI3 <> *Blanks
     C     SwiftXSet     CHECK     F42MI3:1                               99
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
      ** End Default MT942 Message Level Information to Account Owner (3)

      ** Default MT942 Message Level Information to Account Owner (4)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F42MI4 = *Blanks AND
     C                             (F42MI5 <> *Blanks OR F42MI6 <> *Blanks)
     C                   MOVE      'USR3978'     ZAMSID
     C                   MOVE      *On           *IN56
     C                   ENDIF

      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F42MI4 <> *Blanks
     C     SwiftXSet     CHECK     F42MI4:1                               99
     C   99              MOVE      'USR3997'     ZAMSID
     C   99              MOVE      *On           *IN56
     C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN56
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT942 Message Level Information to Account Owner (4)

      ** Default MT942 Message Level Information to Account Owner (5)
      *
      ** -- The field can't be blank if the following is filled
      *
     C                   IF        F42MI5 = *Blanks AND F42MI6 <> *Blanks
     C                   MOVE      'USR3978'     ZAMSID
     C                   MOVE      *On           *IN57
     C                   ENDIF

      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F42MI5 <> *Blanks
     C     SwiftXSet     CHECK     F42MI5:1                               99
     C   99              MOVE      'USR3997'     ZAMSID
     C   99              MOVE      *On           *IN57
     C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN57
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT942 Message Level Information to Account Owner (5)

      ** Default MT942 Message Level Information to Account Owner (6)
      *
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F42MI6 <> *Blanks
     C     SwiftXSet     CHECK     F42MI6:1                               99
     C   99              MOVE      'USR3997'     ZAMSID
     C   99              EXSR      $ZaSndMsg
     C   99              MOVE      *On           *IN58
     C   99              MOVE      *On           *IN40
     C   99              MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT942 Message Level Information to Account Owner (6)

     C                   IF        D42F61 <> 'Y' AND D42F61 <> 'N'                            CER030
     C                   EVAL      ZAMSID = 'USR3973'                                         CER030
     C                   EVAL      *IN59  = *ON                                               CER030
     C                   EXSR      $ZaSndMsg                                                  CER030
     C                   EVAL      *IN40 = *ON                                                CER030
     C                   EVAL      RetCodeOut = '*MSG'                                        CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
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
