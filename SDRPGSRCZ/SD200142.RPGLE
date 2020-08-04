     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Network Description - Details 2 Validat°')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200142 - Midas SD Network Description Maintenance    *
      *                   (Details 2 Screen Validation - MT940)       *
      *                                                               *
      *  Function:  This module validates the fields of the second    *
      *             detail screen of a Network record.                *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CMG008             Date 20Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL146             Date 10Jul13               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22807           Date 26Feb09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL013  *CREATE    Date 25Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL146 - MT940/MT950 Production in Input Cycle               *
      *           Added hooks: CGL146_001, CGL146_009, CGL146_015     *
      *                        CGL146_020, CGL146_024, CGL146_025     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22807 - Generation of MT942s in MMM on the basis of       *
      *             maximum message length                            *
      *  CER030 - Multicash German Feature                            *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************
 
      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Error Indicators                                                       *
      *                                                                        *
      * 40 - General Error Indicator                                           *
      * 41 - MT940 Maximum Message Length                                      *
      * 42 - Default MT940 Message Level Information to Account Owner (1)      *
      * 43 - Default MT940 Message Level Information to Account Owner (2)      *
      * 44 - Default MT940 Message Level Information to Account Owner (3)      *
      * 45 - Default MT940 Message Level Information to Account Owner (4)      *
      * 46 - Default MT940 Message Level Information to Account Owner (5)      *
      * 47 - Default MT940 Message Level Information to Account Owner (6)      *
      * 48 - Default MT940 Message Status                                      *
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
     D/COPY OFCPYSRCZ,CGL146_015                                                              CGL146
 
     D ScrLayout     E DS                  EXTNAME(SD200122DF:SD200122F2)
      ** Detail 2 Screen Layout
      *
     D/COPY OFCPYSRCZ,CGL146_020                                                              CGL146
 
      ** Declared variables
      ** ------------------
      *
 
      ** Error Indicators Array
      *
     D IN40_TO_70      S              1    DIM(31)
     D/COPY OFCPYSRCZ,CGL146_001                                                              CGL146
 
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
     C/COPY OFCPYSRCZ,CGL146_009                                                              CGL146
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR subroutine
 
      *------------------------------------------------------------------------*
      *                      Details 2 Fields Validation                       *
      *------------------------------------------------------------------------*
 
      ** Default MT940 Message Status
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F20DMS = *Blank
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN48
 
      ** -- The valid values are 'R' and 'C'
      *
 X1  C                   ELSE
 
 B2  C                   IF        F20DMS <> 'R' AND F20DMS <> 'C'
     C                   MOVE      'USR3980'     ZAMSID
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
      ** End MT940 Default Message Status
 
     C/COPY OFCPYSRCZ,CGL146_025                                                              CGL146
      ** MT940 Maximum Message Length
      *
      ** -- The value must be > 1 and <= 999999. As the field is only
      **    6 digits long, it isn't necessary to test the upper limit
      *
 B1  C                   IF        F20MXL <= 1
     C                   MOVE      'USR3975'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN41
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
 E1  C                   ENDIF
      *                                                                                     BUG22807
      ** The maximum message length should not be more then 10000                           BUG22807
      ** for swift network or the Type of protocol is *MDBA                                 BUG22807
      *                                                                                     BUG22807
     C                   IF        (EDNWRK ='SWIFT'                                         BUG22807
     C                             OR EDPROT = '*MDBA')                                     BUG22807
     C                             AND F20MXL > 10000                                       BUG22807
     C                   MOVE      'USR8313'     ZAMSID                                     BUG22807
     C                   EXSR      $ZaSndMsg                                                BUG22807
     C                   MOVE      *ON           *IN41                                      BUG22807
     C                   MOVE      *ON           *IN40                                      BUG22807
     C                   MOVEL(P)  '*MSG'        RetCodeOut                                 BUG22807
     C                   ENDIF                                                              BUG22807
      *
      ** End MT940 Maximum Message Length
 
      ** Default MT940 Message Level Information to Account Owner (1)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F20MI1 = *Blanks AND
     C                             (F20MI2 <> *Blanks OR F20MI3 <> *Blanks OR
     C                              F20MI4 <> *Blanks OR F20MI5 <> *Blanks OR
     C                              F20MI6 <> *Blanks)
     C                   MOVE      'USR3978'     ZAMSID
     C                   MOVE      *On           *IN42
     C                   ENDIF
 
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F20MI1 <> *Blanks
     C     SwiftXSet     CHECK     F20MI1:1                               99
     C   99              MOVE      'USR3997'     ZAMSID
     C   99              MOVE      *On           *IN42
     C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN42
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT940 Message Level Information to Account Owner (1)
 
      ** Default MT940 Message Level Information to Account Owner (2)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F20MI2 = *Blanks AND
     C                             (F20MI3 <> *Blanks OR F20MI4 <> *Blanks OR
     C                              F20MI5 <> *Blanks OR F20MI6 <> *Blanks)
     C                   MOVE      'USR3978'     ZAMSID
     C                   MOVE      *On           *IN43
     C                   ENDIF
 
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F20MI2 <> *Blanks
     C     SwiftXSet     CHECK     F20MI2:1                               99
     C   99              MOVE      'USR3997'     ZAMSID
     C   99              MOVE      *On           *IN43
     C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN43
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT940 Message Level Information to Account Owner (2)
 
      ** Default MT940 Message Level Information to Account Owner (3)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F20MI3 = *Blanks AND
     C                             (F20MI4 <> *Blanks OR F20MI5 <> *Blanks OR
     C                              F20MI6 <> *Blanks)
     C                   MOVE      'USR3978'     ZAMSID
     C                   MOVE      *On           *IN44
     C                   ENDIF
 
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F20MI3 <> *Blanks
     C     SwiftXSet     CHECK     F20MI3:1                               99
     C   99              MOVE      'USR3997'     ZAMSID
     C   99              MOVE      *On           *IN44
     C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN44
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT940 Message Level Information to Account Owner (3)
 
      ** Default MT940 Message Level Information to Account Owner (4)
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        F20MI4 = *Blanks AND
     C                             (F20MI5 <> *Blanks OR F20MI6 <> *Blanks)
     C                   MOVE      'USR3978'     ZAMSID
     C                   MOVE      *On           *IN45
     C                   ENDIF
 
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F20MI4 <> *Blanks
     C     SwiftXSet     CHECK     F20MI4:1                               99
     C   99              MOVE      'USR3997'     ZAMSID
     C   99              MOVE      *On           *IN45
     C                   ENDIF
 
      ** -- If an error was found
      *
     C                   IF        *IN45
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT940 Message Level Information to Account Owner (4)
 
      ** Default MT940 Message Level Information to Account Owner (5)
      *
      ** -- The field can't be blank if the following is filled
      *
     C                   IF        F20MI5 = *Blanks AND F20MI6 <> *Blanks
     C                   MOVE      'USR3978'     ZAMSID
     C                   MOVE      *On           *IN46
     C                   ENDIF
 
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F20MI5 <> *Blanks
     C     SwiftXSet     CHECK     F20MI5:1                               99
     C   99              MOVE      'USR3997'     ZAMSID
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
      ** End Default MT940 Message Level Information to Account Owner (5)
 
      ** Default MT940 Message Level Information to Account Owner (6)
      *
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        F20MI6 <> *Blanks
     C     SwiftXSet     CHECK     F20MI6:1                               99
     C   99              MOVE      'USR3997'     ZAMSID
     C   99              EXSR      $ZaSndMsg
     C   99              MOVE      *On           *IN47
     C   99              MOVE      *On           *IN40
     C   99              MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Default MT940 Message Level Information to Account Owner (6)
 
      *                                                                                       CER030
      ** Subfield 4 of field 61 is to be output for MT940 or not                              CER030
      ** The Field is mandatory                                                               CER030
      *                                                                                       CER030
     C                   IF        D20F61 <> 'Y' AND D20F61 <> 'N'                            CER030
     C                   EVAL      ZAMSID = 'USR3973'                                         CER030
     C                   EVAL      *IN49  = *ON                                               CER030
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
     C/COPY OFCPYSRCZ,CGL146_024                                                              CGL146
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
