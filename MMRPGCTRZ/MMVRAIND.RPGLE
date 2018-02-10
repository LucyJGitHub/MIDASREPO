     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Rate Amount Indicator')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVRAIND   - Validate Rate Amount Indicator                  *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Rate Amount Indicator field and confirms          *
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
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP002  *CREATE    Date 22Sep97               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
      ** R/A Indicator - received as a parameter
     D DDRACD          S              1A
 
      ** Broker Code - received as a parameter
     D DDBKCD          S              4A
 
      ** Australian Brokerage Indicator - received as a parameter
     D AUS007          S              1A
 
      ** Brokerage Amount - received as a parameter
     D DDBRKG          S             14A
 
      ** Currency - received as a parameter
     D DDCCY           S              3A
 
      ** Brokerage Amount - received as a parameter
     D BJLCCY          S              3A
 
      ** Error in Brokerage field - must be blank if AUS007 on and
      ** Broker is MAIL, PHON, TELX, or RDS.
     D DDBrkgOK        S              1A
 
      ** Action Code - received as a parameter
     D DDACTN          S              1A
 
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
     C*
     C*  *------------------------*
     C*  * Validate R/A Indicator *
     C*  *------------------------*
     C*
     C**  Only process if Australian Brokerage switched on
     C*
     C     AUS007        IFEQ      'Y'
     C**
     C**  Amount and indicator not allowed for the following codes.
     C**
     C     DDBKCD        IFEQ      'MAIL'
     C     DDBKCD        OREQ      'TELX'
     C     DDBKCD        OREQ      'PHON'
     C     DDBKCD        OREQ      'RDS '
     C*
     C*
     C     DDRACD        IFNE      *BLANKS
     C     DDBRKG        ORNE      *BLANKS
     C     DDBRKG        IFNE      *BLANKS
     C                   MOVE      'N'           DDBrkgOK
     C                   END
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM1057'     Msgid1
     C                   END
     C*
     C*
     C                   ELSE
     C**
     C**  If foreign currency R/A indicator must be blank.
     C**
     C     DDCCY         IFNE      BJLCCY
     C     DDRACD        ANDNE     *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM1058'     Msgid1
     C                   END
     C**
     C**  If local currency R/A indicator must be 'R' or 'A'.
     C**
     C     DDCCY         IFEQ      BJLCCY
     C     DDRACD        ANDEQ     *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM1059'     Msgid1
     C                   END
     C*
     C*
     C                   END
     C                   END
     C*
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
     C                   PARM                    AUS007
     C                   PARM                    DDRACD
     C                   PARM                    DDBKCD
     C                   PARM                    DDBRKG
     C                   PARM                    DDCCY
     C                   PARM                    BJLCCY
     C                   PARM                    DDBrkgOK
     C                   PARM                    DDACTN
 
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
