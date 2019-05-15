     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate Interest Payment Frequency')         *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  ZAVINTPFRQ - Validate Interest Payment Frequency             *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Interest Payment Frequency and confirms whether   *
      *             it has a valid value.                             *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *             This was originally a section of code which was   *
      *             repeated in each of the MM deals input programs   *
      *             (and possibly elsewhere). Code has been added     *
      *             around it to turn it into a compilable module     *
      *                                                               *
      *  Component of: ZA_ALL - All ZA modules service program        *
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
      *  Prev Amend No. CDL015             Date 27Aug13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 17Sep97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL015 - Daily Compounding of Interest                       *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field received as a parameter
     D Msgid1          S                   LIKE(#Msgid)
     D Msgid2          S                   LIKE(#Msgid)
 
      ** Midas Interest Payment Frequency - received as a parameter
     D DDIPFQ          S              1A
 
      ** Next interest Payment Date - received as a parameter
     D DDNDAT          S              6A
 
      ** Deal Currency - received as a parameter
     D DDCCY           S              3A
 
      ** Status indicator for switchable feature CDL015                                       CDL015
     D CDL015          S              1A                                                      CDL015
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
      *
      *  *--------------------------------------*
      *  * Validate Interest Payment Frequency  *
      *  *--------------------------------------*
      *
      **  If the next interest date is blank and the interest frequency
      **  is not, this is an error.
     C     DDNDAT        IFEQ      *BLANKS
     C     DDIPFQ        ANDNE     *BLANKS
     C     DDIPFQ        ANDNE     'N'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0434'     MSGID1
     C                   END
      *
      **  If the interest frequency is not M,Q,X,Y or blank it is an
      **  error.
     C     DDIPFQ        IFNE      *BLANK
     C     CDL015        ANDEQ     'N'                                                        CDL015
     C     DDIPFQ        ANDNE     'M'
     C     DDIPFQ        ANDNE     'Q'
     C     DDIPFQ        ANDNE     'X'
     C     DDIPFQ        ANDNE     'Y'
     C     DDIPFQ        ANDNE     'N'
      *                                                                                       CDL015
      **  If CDL015 is on, add 'D' and 'W' to list of valid frequency codes.                  CDL015
      *                                                                                       CDL015
     C     DDIPFQ        ORNE      *BLANK                                                     CDL015
     C     CDL015        ANDEQ     'Y'                                                        CDL015
     C     DDIPFQ        ANDNE     'M'                                                        CDL015
     C     DDIPFQ        ANDNE     'Q'                                                        CDL015
     C     DDIPFQ        ANDNE     'X'                                                        CDL015
     C     DDIPFQ        ANDNE     'Y'                                                        CDL015
     C     DDIPFQ        ANDNE     'N'                                                        CDL015
     C     DDIPFQ        ANDNE     'D'                                                        CDL015
     C     DDIPFQ        ANDNE     'W'                                                        CDL015
     C                   MOVE      'Y'           ErrorFound
      *                                                                                       CDL015
      **  Use CDL015-appropriate error message                                                CDL015
      *                                                                                       CDL015
     C     CDL015        IFEQ      'Y'                                                        CDL015
     C                   MOVEL     '5046214'     MSGID1                                       CDL015
     C                   ELSE                                                                 CDL015
     C                   MOVEL     'MMM0436'     MSGID1
     C                   ENDIF                                                                CDL015
     C                   END
     C     DDIPFQ        IFEQ      'N'
     C     DDNDAT        ANDNE     *BLANKS
     C                   MOVE      'Y'           ErrorFound
      *                                                                                       CDL015
      **  Use CDL015-appropriate error message                                                CDL015
      *                                                                                       CDL015
     C     CDL015        IFEQ      'Y'                                                        CDL015
     C                   MOVEL     '5046214'     MSGID1                                       CDL015
     C                   ELSE                                                                 CDL015
     C                   MOVEL     'MMM0436'     MSGID1
     C                   ENDIF                                                                CDL015
     C                   END
     C     DDCCY         IFNE      'AUD'
     C     DDIPFQ        ANDEQ     'N'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0437'     MSGID2
     C                   END
      *
      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    DDIPFQ
     C                   PARM                    DDNDAT
     C                   PARM                    DDCCY
     C                   PARM                    CDL015                                       CDL015
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
