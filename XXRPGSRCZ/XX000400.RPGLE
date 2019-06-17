     H DEBUG
     H*COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')                         JMI112
     H COPYRIGHT('(c) Finastra International System 2018')                                    JMI112
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Nostro Balance extract')                      *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GL000031*-*Midas*Nostro*Balance*Extract***********************                       JMI112
      *  XX000400 - Midas Nostro Balance Extract                      *                       JMI112
      *                                                               *
      *  Function:  This module will extract Nostro accounts          *
      *             from ACCNTAB to data queue GLENBUDTAQ.            *
      *                                                               *
      *  Component of: GLC01                                          *
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************                       JMI112
      *  (c) Finastra International Limited 2018                      *                       JMI112
      *                                                               *
      *  Last Amend No. JMI112             Date 24May18               *
      *  Prev Amend No. CGL086  *CREATE    Date 31Jan07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI112 - Midas-Opics Data Transfer Amendments. Upgrade to    *
      *           FBM 2.1                                             *
      *  CGL086 - Midas-Opics Data Transfer Amendments                *

      *****************************************************************
      /EJECT
     FACCNTAB   IF   E           K DISK    INFSR(*PSSR)
      /SPACE 3
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

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      *****************************************************************
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure

      ** Breakdown of Data to be output to MQ Series Queue
     D                 DS
     D  DataQueueVal           1     45
     D*ICNUM*****              1      6S 0                                                    JMI112
     D ICNUM                   1      6                                                       JMI112
     D ICCY                    7      9
     D IACOD                  10     19S 0
     D IACSQ                  20     21S 0
     D IBRCA                  22     24
     D ILDBL                  25     45
      *
     D DataQueueName   S             10A   INZ('GLENBUDTAQ')
     D DataQueueLib    S             10A   INZ('*LIBL     ')

      /SPACE 3
      *****************************************************************
      * Main Subroutine
      *
      * Read ACCNTAB
     C                   READ      ACCNTAB                                80
      *
      * Do until end of file
     C     *IN80         DOWNE     *ON
     C     ATYP          IFEQ      'N'
     C     ACST          ANDEQ     ' '
      *
     C                   MOVE      CNUM          ICNUM
     C                   MOVE      CCY           ICCY
     C                   MOVE      ACOD          IACOD
     C                   MOVE      ACSQ          IACSQ
     C                   MOVE      BRCA          IBRCA
      *
      * Edit Ledger Balance

     C                   CALL      'ZSEDIT'
     C                   PARM      LDBL          ZFLD15           15 0
     C                   PARM      0             ZDECS             1 0
     C                   PARM      ' '           ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21

     C                   MOVE      ZOUT21        ILDBL
      *
     C                   Call      'QSNDDTAQ'                           90
     C                   Parm                    DataQueueName
     C                   Parm                    DataQueueLib
     C                   Parm                    DataQueueLen      5 0
     C                   Parm                    DataQueueVal
      *
     C                   IF        *IN90 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
     C                   READ      ACCNTAB                                80
     C                   ENDDO
      *
      ** Terminate Program
     C
     C                   SETON                                            LR
     C                   RETURN
      *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Clear Data Queue
     C                   Call      'QCLRDTAQ'                           90
     C                   Parm                    DataQueueName
     C                   Parm                    DataQueueLib
      *
     C                   IF        *IN90 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Eval      DataQueueLen = 45
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2018                                                       JMI112
