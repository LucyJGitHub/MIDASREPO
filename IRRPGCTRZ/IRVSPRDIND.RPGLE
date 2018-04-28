     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR: Validate Our/Their Spread Indicator')
      *****************************************************************
      *                                                               *
      *  Midas - IRS dealing module                                   *
      *                                                               *
      *  IRVSPRIND - IRS Validate Our/Their Spread indicator          *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Spread indicator field and confirms whether it has*
      *             a valid value.                                    *
      *             If it is valid the 10A return code will be blank; *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CAP003  *CREATE    Date 01Feb98               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
      *           use as APIs.                                        *
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
 
      ** Base Rate indicator passed from calling program as parameter-*IN35
     D  STBRTTok       S              1A
 
      ** Spread rate indicator passed from calling program- *IN36
     D  STRTSPok       S              1A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message returned to calling program as a parameter.
     DMsgid1           S                   LIKE(#Msgid)
 
      **Our/Their spread Indicator passed to program from calling program.
     D   STSPIN        S              1A
 
      **Our/Their Spread Rate passed as a paramater from calling programme
     D   STRTSP        S             12A
 
      **Our/Their Base rate code passed as a parameter from calling program
     D   STBRTT        S              2A
 
      **Base Rate code and Spread Indicator Check Indicator
     D   InitChk       S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   RESET                   InitChk
     C                   MOVE      'Y'           INITCHK
 
     C     STSPIN        IFNE      *BLANKS
     C     STBRTT        IFEQ      *BLANKS
     C     STRTSP        OREQ      *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0025'     Msgid1
     C                   MOVE      'N'           InitChk
     C                   END
     C
     C     InitChk       IFEQ      'Y'
     C     STSPIN        ANDNE     'A'
     C     STSPIN        ANDNE     'S'
     C     STSPIN        ANDNE     'P'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0024'     Msgid1
     C                   ENDIF
     C                   ENDIF
     C
 
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
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    STSPIN
     C                   PARM                    STRTSP
     C                   PARM                    STBRTT
 
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
(c) Misys International Banking Systems Ltd. 2001
