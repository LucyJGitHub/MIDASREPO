     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Write trigger entries')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEWRTTRIG - Write Trigger Entries                            *
      *                                                               *
      *  Function:  This module is called by all Midas transaction    *
      *             maintenance functions for which exposure is to    *
      *             be reported within CCRM at the point of writing   *
      *             or updating the transaction within the Midas      *
      *             database. The file DETRIGPD being journalled then *
      *             triggers the projected extract process. As the    *
      *             extract files themselves are journalled, these    *
      *             details are sent to CCRM through Meridian         *
      *             replication via MQ/Series messages.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CDE005             Date 20Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Prev Amend No. CCB009             Date 19Jun00               *
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CCB009 - COB Journalling. Set on LR to allow ENDCMTCTL.      *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
     FDETRIGPD  O    E             DISK    COMMIT
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      *
     C     *ENTRY        PLIST
     C                   PARM                    T#TREF
     C                   PARM                    T#TCAT
     C                   PARM                    T#RSRV           10            CDE005
      *
     C                   WRITE     DETRIGP0                                     *
      *
     C                   MOVEL     T#TREF        W#TREF            8            CCB009
     C     W#TREF        IFEQ      'SHUTDOWN'                                   CCB009
     C                   MOVEL     '1'           *INLR                          CCB009
     C                   ENDIF                                                  CCB009
      *                                                                         CCB009
     C                   RETURN
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
