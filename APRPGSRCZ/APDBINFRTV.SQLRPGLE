     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *          MD056606
/*STD *  RPGSQLMOD                                                    *          MD056606
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *          MD056606
/*EXI *  TEXT('Midas AP Database update control info retrieval  5')
      *****************************************************************
      *                                                               *
      *  Midas - API                                                  *
      *                                                               *
      *  APDBINFRTV - Database update controller information retrieval*
      *                                                               *
      *  Function: This module supplies information to the database   *
      *            update control CL, based on the function code      *
      *            which is received by that CL.                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD061096           Date 07Dec23               *
      *  Prev Amend No. MD056606           Date 07Sep20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 08Jan98               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061096 - DBU_YRAT job fails on start up. Add a colon before*
      *             FunctnCode so can be used as a global variable.   *
      *             Applied for MD-62023.                             *
      *  MD056606 - Deliverable Data Split for APDBINFPD              *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************


     F*APDBINFL0 IF   E           K DISK    INFSR(*PSSR)                                    MD056606

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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      * Incoming function code
     D FunctnCode      S              4A
      * Outgoing file to be updated
     D UpdateFile      S             10A
      * Outgoing wait time
     D WaitTime        S              4A
      * Outgoing update control program
     D UpdatePgm       S             10A
     D APDBINF       E DS                  EXTNAME(APDBIJW0)                                MD056606
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

     C*****FunctnCode    CHAIN     APDBINFD0                          20                    MD056606
     C/EXEC SQL                                                                             MD056606
     C+ SELECT *                                                                            MD056606
     C+ into :APDBINF                                                                       MD056606
     C+ from APDBIJW0                                                                       MD056606
     C+ where AQFNCODE = :FunctnCode                                                        MD061096
     C*+*where*AQFNCODE*=*FunctnCode***********************************            MD056606 MD061096
     C/END-EXEC                                                                             MD056606

     C                   EVAL      UpdateFile   = AQUpdFil
     C                   EVAL      WaitTime     = AQWaitTm
     C                   EVAL      UpdatePgm    = AQUpdPgm

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      * Incoming function code
     C                   PARM                    FunctnCode
      * Outgoing file to be updated
     C                   PARM                    UpdateFile
      * Outgoing wait time
     C                   PARM                    WaitTime
      * Outgoing update control program
     C                   PARM                    UpdatePgm

     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
