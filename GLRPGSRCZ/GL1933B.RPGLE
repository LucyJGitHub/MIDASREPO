     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Format & send message to TOF via MQSeries')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL1933B - Customer Service Fees - Format and send message    *
      *            to TOF via MQSeries.                               *
      *                                                               *
      *  Function:  This program is invoked during COB if at least    *
      *             one record have been written to the GLIFTCPD      *
      *             file.  This program will format and send a        *
      *             message to Meridian to signal to TOF that fees    *
      *             are ready to receive information.                 *
      *                                                               *
      *                                                               *
      *  Called By: GL1933  - Customer Service Fees - Process Fees    *
      *                       with fee Processing Type equal to 'PP'. *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSD011  *CREATE    Date 04Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD011 - Performance Incentive Fees                          *
      *                                                               *
      *****************************************************************
      *
     FX110LF    IF   E           K DISK
      ** Meridian DBA products
      *
     FX410LF    IF   E           K DISK
      ** Meridain DBA processing environments
      *
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
      *
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
      ** Data Area giving System Prefix.
      *
     D PSDS           SDS
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D MsgHeader     E DS                  EXTNAME(APHEADPD)                    CAP004
      ** API Message Header Format Definition
      *
     D MQString        S           1228A                                        148739
      ** String to send return message to MQSeries
      *
     D MQCHLName       C                   CONST('PBSEX.EXTERNAL.')
      ** The Channel name - used to build up the MQSeries queue name.
      *
     D MSGType         C                   CONST('BENCHFEESRQST')
      ** The Message Type.- used to trigger TOF to send data back.
      *
     D Queue48         S             48A                                        CAP006
      ** Maximum length queue used in call to message sending routine           CAP006
 
      ****************************************************************
      *                M A I N   P R O C E S S I N G                 *
      ****************************************************************
      *
      ** Initial Subroutine
      *                  EXSR      *INZSR
      *
      ** Main Processing
     C                   EXSR      SRMAIN
      *
      ** Termination
     C                   EXSR      SREXIT
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  SRMAIN - Main Processing                                     *
      *                                                               *
      *  Called By : None                                             *
      *                                                               *
      *  Calls     :                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRMAIN        BEGSR
      *
      ** MQSeries queue name: PBSEX.EXTERNAL.xx1.yy
      *                       (xx-MIDAS prefix of the system.)
      *                       (yy-Departmental Server mnemonic)
      *
     C                   MOVE      *BLANKS       QNAME            21
     C                   MOVE      *BLANKS       WWUNIT            4
     C                   MOVE      *BLANKS       WWSERV            6
      *
      ** Populate the key fields
      *
     C                   MOVEL     'PBSEX'       KWPRDN
     C                   MOVEL     SYSPRX        KWUNIT
     C                   MOVE      '1'           KWUNIT
     C                   MOVE      *BLANKS       KWDSMN
      *
     C     KWX4PF        SETLL     X410LF                             80
      *
     C     *IN80         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   SETON                                        U7U8
     C                   Z-ADD     001           DBASE
     C                   MOVEL     'X4PF'        DBFILE
     C                   MOVEL     KWPRDN        WWKEY            13
     C                   MOVE      KWUNIT        WWKEY
     C                   MOVEL     WWKEY         DBKEY
     C                   MOVEL     'GL1933B'     DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
     C                   READ      X410LF                                 81
      *
     C     *IN81         IFEQ      *OFF
      *
      ** Build up the queue name - PBSEX.EXTERNAL.xx1.yy
      *
      ** xx1.
     C                   MOVEL     KWUNIT        WWUNIT
     C                   MOVE      '.'           WWUNIT
      ** xx1.yy
     C                   MOVEL     WWUNIT        WWSERV
     C                   MOVE      X4DSMN        WWSERV
      *
      ** PBSEX.EXTERNAL.xx1.yy
     C                   MOVEL     MQCHLName     QNAME
     C                   MOVE      WWSERV        QNAME
      *
      ** Format the Message Header.
      *
     C     KWPRDN        CHAIN     X110LF                             82
      *
     C     *IN82         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   SETON                                        U7U8
     C                   Z-ADD     002           DBASE
     C                   MOVEL     'X1PF'        DBFILE
     C                   MOVEL     'PBSEX'       DBKEY
     C                   MOVEL     'GL1933B'     DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *
      ** Layout of the message which is sent is based on the layout
      *  of API Message Header Format Definition file, (APHEADPD),
      *  with the following values;
      *
      ** Setup Message Header.
      *
     C                   MOVEL     MSGType       APTGTTYPE
     C                   MOVEL     'MIDAS'       APSRCSYS
     C                   MOVEL     X1PRDS        APTGTSYS
     C                   MOVEL     USER          APUSERID
      *
     C                   MOVEL     MsgHeader     MQString                                     CAP033
     C                   MOVEL     QNAME         Queue48
      *
      ** Call program ZAMSGTOFO (Send a message to the Front Office)
      *  to send an MQ message to Meridian to signal to TOF that Fees
      *  are ready to receive information.
      *
     C                   RESET                   ReturnCode       10            CAP006
     C                   CALLB     'ZAMSGTOFO'                                  CAP006
     C                   PARM                    ReturnCode                     CAP006
     C                   PARM                    Queue48                        CAP006
     C                   PARM                    MQString                       CAP006
 
      ** If return code is not blank, end in error
 
     C                   IF        ReturnCode <> *blanks
     C     *LOCK         IN        LDA
     C                   SETON                                        U7U8
     C                   Z-ADD     003           DBASE
     C                   MOVEL     'ZAMSGTOFO'   DBFILE
     C                   MOVEL     Queue48       DBKEY
     C                   MOVEL     'GL1933B'     DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SREXIT - Exit program and return control to calling program  *
      *                                                               *
      * Calls     - None                                              *
      * Called by - Main processing                                   *
      *                                                               *
      *****************************************************************
      *
     C     SREXIT        BEGSR
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
      *
      ** Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      *   *INZSR - Initial Processing                                 *
      *                                                               *
      *   Called by : Main processing                                 *
      *                                                               *
      *   Calls     : None.                                           *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Retrieve System Prefix.
      *
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT
      *
     C                   MOVEL     LIBR          SYSPRX            2            System Prefix
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   END
      *
      *
     C     KWX4PF        KLIST
     C                   KFLD                    KWPRDN            8            Product Name
     C                   KFLD                    KWUNIT            3            Envrnt mnemo
     C                   KFLD                    KWDSMN            2            Server mnemo
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
