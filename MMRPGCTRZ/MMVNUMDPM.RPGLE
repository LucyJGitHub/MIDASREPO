     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Number of Depot Movements')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVNUMDPM  - Validate Number of Depot Movements              *
      *                                                               *
      *  Function:  This module counts the total number of depot      *
      *             movements stored in the MMTRPDMPD temporary file  *
      *             and checks that it equals the number stored in the*
      *             appropriate field in the Repo trailer file        *
      *                                                               *
      *  Component of: SP6MM0003 - MM Core Non-kernel Validation 3    *
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
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 247785             Date 15May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247785 - Recompile on MMTRPDMPD.                             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
     FMMTRPDML0 IF   E           K DISK    INFSR(*PSSR)
      **
      ** +-----------------------------------+
      ** ¦ End of Manually Included F-Specs  ¦
      ** ¦ ================================  ¦
      ** +-----------------------------------+
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
     D*
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
 
      ** Calling Program
     D CallPgm         S             10A
 
      ** Error message code 1 received as a parameter
     D WMsgid1         S                   LIKE(#MsgID)
     D Msg1            S                   LIKE(#MsgID)
 
      ** Front Office Associated Transaction Reference
     D IHFOAS          S             20A
 
      ** Number of Depot Movements (according to trailer)
     D IHNODP          S             13A
 
     D @@NODP          S             15  0
     D @@IHNODP        S             13  0
 
      **
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      **
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
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   WarnFound
     C                   RESET                   ErrorFound
     C                   RESET                   Msg1
     C                   RESET                   WMsgid1
 
      ** Count the total number of Depot movements
     C
     C                   Z-ADD     *ZERO         @@NODP
     C     IHFOAS        CHAIN     MMTRPDMD0                          99
     C
     C     *IN99         DOWEQ     *OFF
     C                   ADD       1             @@NODP
     C     IHFOAS        READE     MMTRPDMD0                              99
     C                   ENDDO
     C
     C                   MOVE      IHNODP        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      12            ZADIG             2 0
     C                   MOVE      ZFIELD        @@IHNODP
     C
      ** Number of Depot Movements does not agree with trailer
     C     @@NODP        IFNE      @@IHNODP
     C
      ** If calling program is the Repair function then mismatch is only a warning
     C                   IF        CallPgm = 'MMREPORPR '
     C                   MOVE      'Y'           WarnFound
     C                   MOVEL     'MMM9022'     WMsgid1
     C                   ELSE
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM9022'     Msg1
     C                   ENDIF
     C
     C                   ENDIF
     C
      ** Return to calling module
     C                   IF        WarnFound = 'Y'
     C                   EVAL      RetCodeIn = 'Warning'
     C                   ENDIF
     C
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      *
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
     C                   PARM                    Msg1
     C                   PARM                    WMsgid1
     C                   PARM                    IHFOAS
     C                   PARM                    IHNODP
     C                   PARM                    CallPgm
 
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
(C) Copyright Finastra International Limited 2001
