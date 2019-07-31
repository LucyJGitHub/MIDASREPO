     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Define message to be put on download q')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEDEFMSGC - Define message to be put on download channel     *
      *                                                               *
      *  Function:  This program gets the queue to be used for the    *
      *             download channel and sends the appropriate msg.   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *  Prev Amend No. CDE002  *CREATE    Date 03May01               *
      *                 XXXXXX             Date 00Xxx00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** MX Export Format Details
     FMXEXFDPD  IF   E           K DISK    INFSR(*PSSR)
 
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
 
      *
      ** Work parameters
     D I#ERMS          S             30A
     D I#RTCD          S              7A
 
     C     *ENTRY        PLIST
     C                   PARM                    W@Msg             2
 
     C                   EXSR      SR_FILE
     C                   EXSR      SR_PUT
 
     C                   SETON                                        LR
 
      *****************************************************************
      *                                                               *
      * SR_FILE - Subroutine to find the queue to use for download    *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     SR_FILE       BEGSR
 
      * open queue for put
     C                   MOVEL     'DENTRANPD'   K@FILE           10
     C     K@FILE        CHAIN     MXEXFDPD                           20
 
     C     *IN20         IFEQ      *ON
     C                   MOVEL     K@FILE        DBKEY
     C                   MOVEL     'MXEXFDPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SR_PUT - Subroutine to call the put message module            *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     SR_PUT        BEGSR
 
     C                   CALL      'DEPUTMSGC'
     C                   PARM                    Ret_Code          7
     C                   PARM                    Err_Mess         30
     C                   PARM                    W@Msg             2
     C                   PARM      EXMSGQ        P@QueueNm        48
     C
     C     Ret_Code      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEPUTMSGC'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDSR
     C*********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
