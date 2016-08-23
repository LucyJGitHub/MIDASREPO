     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate capitalise interest indicator')      *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVCAPINT  - Validate capitalise interest indicator          *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             capitalise interest indicator and confirms        *
      *             whether it has a valid value.                     *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CDL015             Date 27Aug13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *  Prev Amend No. CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 02Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL015 - Daily Compounding of Interest                       *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Capitalise interest indicator received as a parameter
     D DDCptI          S              1A
 
      ** Deal Type received as a parameter
     D DDType          S              2A
 
      ** Deal Type OK received as a parameter
     D DDTypeOK        S              1A
 
      ** Interest Payment Frequency received as a parameter
     D DDIPFq          S              1A
                                                                                CDL006
     D CDL006          S              1A   IMPORT                               CDL006
 
      ** Status indicator for switchable feature CDL015                                       CDL015
     D CDL015          S              1A                                                      CDL015
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
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
 
      *
      ** Validate the capitalise interest indicator:
      ** - it must be Y or blank
      ** - for certain Deal types, it must not be Y
      ** - if Interest Payment Frequency is N, it must not be Y
     C*
     C                   IF        (DDCptI <> 'Y') AND (DDCptI <> ' ')
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0465'     Msgid1
     c                   ENDIF
     C*
     C                   IF        ErrorFound   <> 'Y'
     C                             AND DDTypeOK <> 'N'   AND DDType <> 'CL'
     C                             AND DDType   <> 'DL'  AND DDType <> 'CD'
     C                             AND DDCptI = 'Y'
     C                             AND CDL015 = 'N'                                           CDL015
     C                   IF        (CDL006 = 'N') OR (CDL006 = 'Y'              CDL006
     C                             AND DDType   <> 'DT'  AND DDType <> 'LT'     CDL006
     C                             AND DDType   <> 'DP'  AND DDType <> 'LP')    CDL006
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0466'     Msgid1
     c                   ENDIF                                                  CDL006
     C                   ENDIF
     C*
     C                   IF        ErrorFound <> 'Y'
     C                             AND (DDCptI = 'Y') AND (DDIPFq = 'N')
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0466'     Msgid1
     C                   ENDIF
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
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    DDCptI
     C                   PARM                    DDType
     C                   PARM                    DDTypeOK
     C                   PARM                    DDIPFq
     C                   PARM                    CDL015                                       CDL015
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
