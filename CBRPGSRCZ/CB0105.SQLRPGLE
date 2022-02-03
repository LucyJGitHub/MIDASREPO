     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056555
/*STD *  RPGSQLBND                                                    *                     MD056555
/*EXI *  TEXT('Midas CB Update on request components')                *
      *****************************************************************
      *                                                               *
      *  Midas - Close Of Business Processing                         *
      *                                                               *
      *  CB0105 - UPDATE ALL ON-REQUEST REPORTS                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD059464           Date 18Jan22               *
      *  Prev Amend No. MD056555           Date 31Aug20               *
      *                 MD046248           Date 27Oct17               *
      *                 AR1096560          Date 18Mar13               *
      *                 AR888771           Date 24Jan12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 204813               Date 03Nov03             *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 074287               Date 02APR96             *
      *                 E38954               Date 29APR92             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD059464 - New component GLC0804 is not selected for COB run *
      *              even when requested via Periodic Report  Request *
      *              Maintenance                                      *
      *  MD056555 - Deliverable Data Split for SAR group              *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1096560 - Report SE0915 was not generated (Child:AR1096561)*
      *  AR888771 - Several LE components failed during COB. On-      *
      *             request components should not be executed when    *
      *             corresponding switchable feature is disabled.     *
      *  204813 - Include processing for non-report related on-req    *
      *           components.                                         *
      *  074287 - When the component name and component sequence no.  *
      *           is blank then do not process the record; this can   *
      *           happened if a report is run interactively when MPHAS*
      *           is in phase 'C', 'D' or 'E'.                        *
      *  E38954 - Field DBPGM is not blanked out before pgm name is   *
      *           moved in.                                           *
      *                                                               *
      *****************************************************************
     FFCRREQL4  IP   E           K DISK
     FCBCOBRL0  IF   E           K DISK
     FCBCOMSL0  UF   E           K DISK
     F*SCSARCL2* IF   E           K DISK                                                 AR MD056555
     F********************************************************************
     F*
     F*         FUNCTION OF INDICATORS
     F*
     F*   01    RECORDS ON FCRRREQL4
      *   78    CHAIN FOR SCSARCL2 for REPORT subroutine                                    AR888771
      *   79    CHAIN FOR SCSARCL2 for ORCOMP subroutine                                    AR888771
     F*   81    CHAIN FAIL FOR CBCOMSL0
     F*   82    CHAIN FAIL FOR CBCOMSL0 for CBCOBR processing                                 204813
     F*
     F********************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D CMPNDS          DS
     D*
     D** DATASTRUCTURE FOR DATABASE ERROR FIELDS IN  CBCOMSL0
     D** (for RCF)                                                                            204813
     D*
     D  D5COTT                 1     10
     D  D5CSEQ                11     15
     D COBRDS          DS
      *                                                                                       204813
      ** DATASTRUCTURE FOR DATABASE ERROR FIELDS IN CBCOMSL0                                  204813
      ** (for CBCOBRL0)                                                                       204813
      *                                                                                       204813
     D  CRCOTT                 1     10
     D  CRCSEQ                11     15
      *                                                                                       204813
     D LDA            UDS           256
     D*
     D** LOCAL DATA AREA FOR DATABASE ERROR STORE
     D*
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D SCSARC        E DS                  EXTNAME(SCSRCJW0)                                MD056555
     I@RREQAG
     I                                          D5RNAM        L3
     I                                          D5COTT        L2
     I                                          D5CSEQ        L1
     I*
      /EJECT
     C*
     C                   MOVEA     CPY@          BIS@             80
     C** INITIAL PROCESSING
     C*
     C** COMPONENTS KEY LIST
     C*
     C     CMPN          KLIST
     C                   KFLD                    D5COTT
     C                   KFLD                    D5CSEQ
      *                                                                                      204813
      ** CBCOBRL0 Key List                                                                   204813
      *                                                                                      204813
     C     COBR          KLIST
     C                   KFLD                    CRCOTT
     C                   KFLD                    CRCSEQ
     C*                                                                                      204813
     C** IF DETAIL RECORDS EXIST, SET ON INDICATOR
     C*
     C                   SETON                                        01
     C*
     C** SET UP DATABASE PROGRAM NAME
     C*
     CL1                 MOVEL     *BLANK        DBPGM                                         E3895
     CL1                 MOVEL     'CB0105'      DBPGM
     C*
     C** NO DETAIL TIME PROCESSING: PERFORM ALL PROCESSING ON CHANGE OF
     C** REPORT NAME, IF RECORDS HAVE BEEN FOUND
     C*
     CL1 01              EXSR      REPORT
     CLR                 EXSR      ORCOMP
     C*
      /EJECT
     C********************************************************************
     C*
     C*               INDEX OF SUBROUTINES
     C*
     C* REPORT - PROCESSING ON CHANGE OF REPORT NAME
     C* ORCOMP - Processing for on-request components                                         204813
     C* DBERR  - PROCESSING FOR DATABASE ERRORS
     C* *PSSR  - STANDARD ERROR ROUTINE
     C*
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R REPORT - TO PROCESS EACH REPORT NAME
     C*  CALLED FROM MAIN PROCESSING ON CHANGE OF REPORT NAME
     C*  CALLS ERROR
     C*
     C********************************************************************
     C     REPORT        BEGSR
     C*
     C** If component name and sequence number are blank then do not      074287
     C** process the record.                                              074287
     C*                                                                   074287
     C     D5COTT        IFNE      *BLANK                                                      07428
     C     D5CSEQ        ANDNE     *BLANK                                                      07428
      *                                                                                     AR888771
      ** Check if the report component is from a switchable feature                         AR888771
      *  and check if it is enabled                                                         AR888771
      *                                                                                     AR888771
     C                   MOVEL     'N'           WSARD             1
     C*****CMPN*         CHAIN     SCSARCL2                           79                    MD056555
     C/EXEC SQL                                                                             MD056555
     C+ SELECT *                                                                            MD056555
     C+ into :SCSARC                                                                        MD056555
     C+ from SCSRCJW0                                                                       MD056555
     C*+*where*ACCOTT*=*:D5COTT*and*ACCSEQ*=*D5CSEQ***************                 MD056555 MD059464
     C+ where ACCOTT = :D5COTT and ACCSEQ = :D5CSEQ                                         MD059464

     C/END-EXEC                                                                             MD056555
     C******IN79         IFEQ      '0'                                                      MD056555
     C                   IF        SQLCODE = 0                                              MD056555
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      ACSARN        @SARD             6
     C     @RTCD         IFEQ      *BLANKS
     C     ACAVAL        OREQ      'N'
     C                   MOVEL     'Y'           WSARD
     C                   ENDIF
     C                   ENDIF
     C*                                                                   074287
     C** ACCESS COMPONENT RECORD FOR THE REPORT
     C*
     C******IN79         IFEQ      '1'                                                      MD056555
     C     SQLCODE       IFEQ      100                                                      MD056555
     C     WSARD         OREQ      'Y'
     C     CMPN          CHAIN     CBCOMSL0                           81
     C*
     C** DATABASE ERROR IF NO RECORD FOUND
     C*
     C     *IN81         IFEQ      '1'
     C                   Z-ADD     2             DBASE
     C                   MOVEL     'CBCOMSL0'    DBFILE
     C                   MOVEL     CMPNDS        DBKEY
     C                   EXSR      DBERR
     C                   END
     C*
     C** UPDATE 'SELECT FOR TODAY'S COB' FIELD
     C*
     C                   MOVE      'Y'           DHCRQD
     C                   UPDATE    @DHREGG
     C*                                                                   074287
     C                   END                                                                   07428
     C                   ENDIF
     C*                                                                   074287
     C                   ENDSR
     C********************************************************************
      /EJECT
      ********************************************************************                    204813
      *                                                                                       204813
      *  S/R ORCOMP - To process each componant from the on-request                           204813
      *               components file                                                         204813
      *                                                                                       204813
      *  Called from Main Processing after the report processing is                           204813
      *  complete                                                                             204813
      *                                                                                       204813
      *  Calls ERROR                                                                          204813
      *                                                                                       204813
      ********************************************************************                    204813
     C     ORCOMP        BEGSR
      *                                                                                       204813
     C                   READ      CBCOBRL0                               99
      *                                                                                       204813
     C     *IN99         DOWEQ     *OFF
      *                                                                                       204813
      ** If component name and sequence number are blank then do not                          204813
      ** process the record.                                                                  204813
      *                                                                                       204813
     C     CRCOTT        IFNE      *BLANK
     C     CRCSEQ        ANDNE     *BLANK
      *                                                                                     AR888771
      ** Check if the component is from a switchable feature and                            AR888771
      *  check if it is enabled                                                             AR888771
      *                                                                                     AR888771
     C                   MOVEL     'N'           WSARD
     C*****COBR*         CHAIN     SCSARCL2                           78                    MD056555
     C/EXEC SQL                                                                             MD056555
     C+ SELECT *                                                                            MD056555
     C+ into :SCSARC                                                                        MD056555
     C+ from SCSRCJW0                                                                       MD056555
     C*+*where*ACCOTT*=*:CRCOTT*and*ACCSEQ*=*CRCSEQ***************                 MD056555 MD059464
     C+ where ACCOTT = :CRCOTT and ACCSEQ = :CRCSEQ                                         MD059464
     C/END-EXEC                                                                             MD056555
     C******IN78         IFEQ      '0'                                                      MD056555
     C                   IF        SQLCODE = 0                                              MD056555
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      ACSARN        @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           WSARD
     C                   ENDIF
     C                   ENDIF
      *                                                                                       204813
      ** Access component record on the runtime components file                               204813
      *                                                                                       204813
     C******IN78         IFEQ      '1'                                                      MD056555
     C     SQLCODE       IFEQ      100                                                      MD056555
     C     WSARD         OREQ      'Y'
     C     COBR          CHAIN     CBCOMSL0                           82
      *                                                                                       204813
      ** Database error if no record found                                                    204813
      *                                                                                       204813
     C     *IN82         IFEQ      '1'
     C                   Z-ADD     3             DBASE
     C                   MOVEL     'CBCOMSL0'    DBFILE
     C                   MOVEL     COBRDS        DBKEY
     C                   EXSR      DBERR
     C                   END
      *                                                                                       204813
      ** Update 'Select for Today's COB' field                                                204813
      *                                                                                       204813
     C                   MOVE      'Y'           DHCRQD
     C                   UPDATE    @DHREGG
     C                   ENDIF
      *                                                                                       204813
     C                   END
      *                                                                                       204813
      ** Read the next record                                                                 204813
      *                                                                                       204813
     C                   READ      CBCOBRL0                               99
      *                                                                                       204813
     C                   END
      *                                                                                       204813
     C                   SETON                                        LR
     C                   RETURN
      *                                                                                       204813
     C                   ENDSR
     C********************************************************************                    204813
      /EJECT                                                                                  204813
     C********************************************************************
     C*
     C*  S/R DBERR - TO PROCESS DATABASE ERRORS AND TERMINATE PROGRAM
     C*  CALLED FROM REPORT
     C*
     C********************************************************************
     C*
     C     DBERR         BEGSR
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   RETURN
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R *PSSR - ERROR ROUTINE
     C*  CALLED FROM DBERR
     C*
     C********************************************************************
     C*
     C     *PSSR         BEGSR
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
     C                   ENDSR
     C********************************************************************
** CPY@
(c) Finastra International Limited 2001
