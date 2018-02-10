     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate LDI Int. payment day in mth')        *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVNXINTDY - Validate LDI Interest payment day in month      *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             LDI Interest payment day in month and confirms    *
      *             whether it has a valid value.                     *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
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
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 201593             Date 13Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 17Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL015 - Daily Compounding of Interest                       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  201593 - Interest frequency day in a month is not defaulted  *
      *           if the next interest payment date has a warning     *
      *           error.                                              *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
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
 
     D                 DS             6
      **  Data structure to change format to MMDDYY/DDMMYY
     D  @@DTOU                 1      6  0
     D  @@DAT1                 1      2  0
     D  @@DAT2                 3      4  0
     D  @@YYY                  5      6  0
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
 
      ** LDI interest payment day in month - received as a parameter
     D DDIPDM          S              2A
 
      ** Interest Payment Frequency - received as a parameter
     D DDIPFQ          S              1A
 
      ** Next Interest Payment Date - received as a parameter
     D DDNDAT          S              6A
 
      ** Next Interest Payment Date OK Flag - received as a parameter
     D DDNDatOK        S              1A
 
      ** Date format indicator - received as a parameter
     D BJDFIN          S              1A
 
      ** Work field
     D @WK20           S              2  0
 
      ** Work field
     D @TEST           S              1A
 
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
 
      *  *------------------------------------------*
      *  * Validate Interest Frequency Day in Month *
      *  *------------------------------------------*
      *
     C     DDIPFQ        IFEQ      'N'
     C     DDIPFQ        OREQ      'D'                                                        CDL015
     C     CDL015        ANDEQ     'Y'                                                        CDL015
     C     DDIPFQ        OREQ      'W'                                                        CDL015
     C     CDL015        ANDEQ     'Y'                                                        CDL015
     C     DDIPDM        IFNE      *BLANKS
     C     DDIPFQ        IFEQ      'D'                                                        CDL015
     C     DDIPFQ        OREQ      'W'                                                        CDL015
     C                   MOVEL     '5046213'     MSGID1                                       CDL015
     C                   ELSE                                                                 CDL015
     C                   MOVEL     'MMM0455'     MSGID1
     C                   ENDIF                                                                CDL015
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   ELSE
      *
      *
      **  If the interest frequency day in month is not blank, and is
      **  not an integer between 00 and 31 it is an error.
     C     DDIPDM        IFNE      *BLANKS
     C                   TESTN                   DDIPDM               6263
     C                   MOVE      DDIPDM        @TEST
     C                   TESTZ                   @TEST                    73
      *
     C     *IN62         IFEQ      '1'
     C     *IN73         ANDEQ     '1'
     C     *IN73         OREQ      '1'
     C     *IN63         ANDEQ     '1'
     C                   MOVE      DDIPDM        @WK20
     C     @WK20         IFLT      0
     C     @WK20         ORGT      31
     C                   MOVEL     'MMM0455'     MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   END
      *
     C     *IN62         IFEQ      '0'
     C     *IN63         ANDEQ     '0'
     C     *IN73         OREQ      '0'
     C                   MOVEL     'MMM0455'     MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   END
      *
      **  If the interest frequency day in month is not blank, and the
      **  interest frequency is blank, this is an error.
     C     DDIPFQ        IFEQ      *BLANKS
     C                   MOVEL     'MMM0456'     MSGID1
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   END
     C                   END
      *
     C**  If the next interest date is not blank and the interest
     C**  payment day in month is blank or '00', set the day in month
     C** to the days part of the value date
     C     DDNDAT        IFNE      *BLANKS
     C     DDIPFQ        ANDNE     *BLANKS
     C*****DDNDatOK      ANDEQ     'Y'                                                        201593
     C     DDNDatOK      ANDNE     'N'                                                        201593
 
     C     DDIPDM        IFEQ      *BLANKS
     C     DDIPDM        OREQ      '00'
     C     DDIPFQ        ANDNE     *BLANK
 
      *                                                                                       CDL015
      ** Skip the defaulting if CDL015 is ON and frequency is 'D' or 'W'                      CDL015
      *                                                                                       CDL015
     C     CDL015        IFNE      'Y'                                                        CDL015
     C     DDIPFQ        ORNE      'D'                                                        CDL015
     C     DDIPFQ        ANDNE     'W'                                                        CDL015
     C                   MOVE      DDNDAT        @@DTOU
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @@DAT1        DDIPDM
     C                   ELSE
     C                   MOVE      @@DAT2        DDIPDM
     C                   END
     C                   ENDIF                                                                CDL015
 
     C                   END
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
     C                   PARM                    DDIPDM
     C                   PARM                    DDIPFQ
     C                   PARM                    DDNDAT
     C                   PARM                    DDNDatOK
     C                   PARM                    BJDFIN
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
