     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Network Description - Details 5 Validat°')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200145 - Midas SD Network Description Maintenance    *
      *                   (Details 5 Screen Validation - FTP          *
      *                   parameters)                                 *
      *                                                               *
      *  Function:  This module validates the fields of the fifth     *
      *             detail screen of a Network record.                *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CMG008             Date 20Feb20               *
      *  Prev Amend No. CSD101             Date 07Dec18               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL013  *CREATE    Date 25Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG008 - MT940, MT941, MT942, MT950 Translation Table.       *
      *           (Recompile)                                         *
      *  CSD101 - Password Encryption                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Error Indicators                                              *
      *                                                               *
      * 40 - General Error Indicator                                  *
      * 41 - Polling Frequency                                        *
      * 42 - Outgoing Remote File Name: File Prefix                   *
      * 43 - Outgoing Remote File Name: Suffix by Date                *
      * 44 - Outgoing Remote File Name: Suffix by Time                *
      * 45 - Outgoing Remote File Name: Suffix by Sequence            *
      * 46 - Outgoing Remote File Name: File Extension                *
      * 47 - Remote Path Name                                         *
      * 48 - Target Server Name                                       *
      * 49 - Server User Id.                                          *
      * 50 - Server Password.                                         *
      * 51 - Server Password. to Verify                               *
      * 52 - Exit Program Name                                        *
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

     D NewFilRcd     E DS                  EXTNAME(SDNWRKPD)
      ** New Network File Record (i.e. new state after amendments)
      *

     D ScrLayout     E DS                  EXTNAME(SD200125DF:SD200125F5)
      ** Detail 5 Screen Layout
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
      *                      Details 5 Fields Validation                       *
      *------------------------------------------------------------------------*

      ** Polling Frequency
      *
      ** -- The value must be > 0 and <= 999. As the field is only
      **    3 digits long, it isn't necessary to test the upper limit
      *
 B1  C                   IF        F5PFRQ < 1
     C                   MOVE      'USR3983'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN41
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
 E1  C                   ENDIF
      *
      ** End Polling Frequency

      ** Outgoing Remote File Name: File Prefix
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F5RFNP = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN42

      ** -- The value must not contain the characters \/:*?"<>|
      *
 X1  C                   ELSE

 B2  C                   IF        %Scan('\':F5RFNP:1) <> 0 OR
     C                             %Scan('/':F5RFNP:1) <> 0 OR
     C                             %Scan(':':F5RFNP:1) <> 0 OR
     C                             %Scan('*':F5RFNP:1) <> 0 OR
     C                             %Scan('?':F5RFNP:1) <> 0 OR
     C                             %Scan('"':F5RFNP:1) <> 0 OR
     C                             %Scan('<':F5RFNP:1) <> 0 OR
     C                             %Scan('>':F5RFNP:1) <> 0 OR
     C                             %Scan('|':F5RFNP:1) <> 0
     C                   MOVE      'USR3984'     ZAMSID
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
      ** End Outgoing Remote File Name: File Prefix

      ** Outgoing Remote File Name: Suffix by Date
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F5RFSD = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN43

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F5RFSD <> 'Y' AND F5RFSD <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
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
      ** End Outgoing Remote File Name: Suffix by Date

      ** Outgoing Remote File Name: Suffix by Time
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F5RFST = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN44

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F5RFST <> 'Y' AND F5RFST <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
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
      ** End Outgoing Remote File Name: Suffix by Time

      ** Outgoing Remote File Name: Suffix by Sequence
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F5RFSS = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN45

      ** -- The valid values are 'Y', 'N' and 'X'
      *
 X1  C                   ELSE

 B2  C                   IF        F5RFSS <> 'Y' AND F5RFSS <> 'N' AND
     C                             F5RFSS <> 'X'
     C                   MOVE      'USR3985'     ZAMSID
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
      ** End Outgoing Remote File Name: Suffix by Sequence

      ** Outgoing Remote File Name: File Extension
      *
      ** -- The value must be blanks if the Suffix by Sequence is 'X'
      *
 B1  C                   IF        F5FEXU <> *Blanks AND F5RFSS = 'X'
     C                   MOVE      'USR3986'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN46
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
 E1  C                   ENDIF
      *
      ** End Outgoing Remote File Name: File Extension

      ** Remote Path Name
      *
      ** -- The field optional
      *
      ** End Remote Path Name

      ** Target Server Name
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F5TSNM = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN48
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
 E1  C                   ENDIF
      *
      ** End Target Server Name

      ** Server User Id.
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F5SUID = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN49
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
 E1  C                   ENDIF
      *
      ** End Server User Id.

      ***Server*Password*and*Server*Password*to*Verify*****************                       CSD101
      *
      ***--*The*Field*is*mandatory*if*not*already*filled*in*file*******                       CSD101
      *
 B1  C**********         IF        EDSRVP = *Blanks AND F5SRVP = *Blanks                      CSD101
     C**********         MOVE      'USR3987'     ZAMSID                                       CSD101
     C**********         MOVE      *On           *IN50                                        CSD101

      ***--*Should*be*the*same*value*as*Server*Password*to*Verify******                       CSD101
      *
 X1  C**********         ELSE                                                                 CSD101

 B2  C**********         IF        F5SRVP <> F5SPWV                                           CSD101
     C**********         MOVE      'USR3988'     ZAMSID                                       CSD101
     C**********         MOVE      *On           *IN50                                        CSD101
 E2  C**********         ENDIF                                                                CSD101

 E1  C**********         ENDIF                                                                CSD101

      ***--*If*an*error*was*found**************************************                       CSD101
      *
     C**********         IF        *IN50                                                      CSD101
     C**********         EXSR      $ZaSndMsg                                                  CSD101
     C**********         MOVE      *On           *IN40                                        CSD101
     C**********         MOVEL(P)  '*MSG'        RetCodeOut                                   CSD101
     C**********         ENDIF                                                                CSD101
      *
      ***End*Server*Password*and*Server*Password*to*Verify*************                       CSD101

      ** Exit Program Name
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F5EXTP = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN52
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
 E1  C                   ENDIF
      *
      ** End Exit Program Name

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
