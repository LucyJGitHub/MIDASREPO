     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Notification Code Word')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVNCWD    - Validate Notification Code Word                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This module load the notification code word file as an     *
      *     array.  The fields :72: or :23E: is passed from the       *
      *     calling program.  If any data held with the two strings   *
      *     matches the notification code word, the message is        *
      *     determined to be notifed to the customer.                 *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CFT009  *CREATE    Date 09Jun00               *
      *                                    Date DDMmmYY               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *                                                               *
      *****************************************************************
     FFTNCWDL0  If   e           k Disk
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
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
 
 
      * Parameter string.  Note that this is 420 characters long to cater
      *  for both :72: and :23E: being passed.  (does not matter which order).
     D  Str_In         S            420
     D  NotifiedFlag   S              1
     D  CodeWord       S             10
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Array to load the notification code words table at run time
     DNot_Arr          S              8    DIM(500)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D  i              S              5  0
     D  j              S                   Like(i)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
 
      * +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
     C                   Eval      RetCodeIn      = *BlankS
     C                   Eval      NotifiedFlag   = 'X'
 
     C                   Eval      j = 1
 
     C                   Dow       j <= i
 
     C                   If        Not_Arr(j)     = *Blanks
     C                   Leave
     C                   Endif
 
     C     Not_Arr(j)    Scan      Str_In                                 88
 
     C                   If        *In88
     C                   Eval      NotifiedFlag   = 'N'
     C                   Eval      CodeWord       = Not_Arr(j)
     C                   Leave
     C                   Endif
 
     C                   Eval      j = j + 1
 
     C                   Enddo
 
     C                   Return
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
 
     C     *Entry        Plist
     C                   Parm                    RetCodeIn
     C                   Parm                    Str_In
     C                   Parm                    NotifiedFlag
     C                   Parm                    CodeWord
 
      * Load array.
     C                   Eval      *in89 = *Off
     C                   Read      FTNCWDL0                               89
     C                   Dow       *In89 = *Off
     C                   Add       1             i
     C                   MoveA     NCODEW        Not_Arr(i)
     C                   Read      FTNCWDL0                               89
     C                   Enddo
 
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
(c) Finastra International Limited 2001
