     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Stub Date')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS module                                       *
      *                                                               *
      *  IRVSTUBDTE - Validate Stub Date                              *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             stub date and confirms whether it has a valid     *
      *             value. If it is valid the 10A return code will be *
      *             blank; if it is not it will contain 'Error'       *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
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
      *  Prev Amend No. CDL028  *CREATE    Date 07Feb05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL028 - Automatic Rate Interpolations                       *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +----------------------------------------+
      ** ¦ Indicators Used                        ¦
      ** ¦ ===============                        ¦
      ** ¦ 21 - Valid Maturity Date               ¦
      ** +----------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** BJDFIN passed as a parameter to ZDATE1
     D    BJDFIN       S              1A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Stub Date passed as a parameter
     D   StubDate      S              6A
 
      ** Stub Date returned as parameter
     D   StubDyNo      S              5P 0
 
      ** Maturity date passed as a parameter to ZDATE1
     D   ZDATE         S              6A
 
      ** Day number returned by ZDATE1
     D   ZDAYNO        S              5P 0
 
      ** Error flag returned by ZDATE1
     D   Errorflag     S              1A
 
      ** Error message to be handed back as a parameter
     D   Msgid1        S                   LIKE(#Msgid)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      ** Reset Error messages
      *
     C                   RESET                   Errorfound
     C                   RESET                   Msgid1
     C                   MOVE      *OFF          *IN21
      *
      ** Validate Stub Date if not blank
      *
     C     StubDate      IFNE      *BLANKS
 
     C                   TESTN                   StubDate             9798
     C     *IN97         IFEQ      '1'
     C     *IN98         OREQ      '1'
     C                   MOVE      'Y'           NUMok             1
     C                   ELSE
     C                   MOVE      'N'           NUMok
     C                   ENDIF
 
     C     NUMok         IFEQ      'Y'
     C                   MOVE      StubDate      ZDATE
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    Errorflag
     C                   ENDIF
      *
      ** If StubDate invalid or non-numeric show error message
      *
     C     NUMok         IFEQ      'N'
     C     Errorflag     OREQ      'Y'
     C                   MOVE      'Y'           Errorfound
     C                   MOVEL     'MMM1068'     Msgid1
     C                   MOVE      *ON           *IN21
     C                   ENDIF
      *
      ** If the Maturity date is valid save it as a Midas Day number
      *
     C     *IN21         IFEQ      *OFF
     C                   MOVE      ZDAYNO        StubDyNo
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If the Maturity date is blank set Midas Day number to zero
      *
     C     StubDate      IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        StubDyNo
     C                   ENDIF
 
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
 
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
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid1
     C                   PARM                    BJDFIN
     C                   PARM                    StubDate
     C                   PARM                    StubDyNo
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2005
