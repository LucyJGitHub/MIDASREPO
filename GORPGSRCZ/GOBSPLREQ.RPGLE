     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO BSPL Request')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSPLREQ - BSPL Request                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FFCRREQPD  O    E             DISK    INFSR(*PSSR)
 
 
      ** External data area for user name
     D ZMUSER          DS            17
     D  ZMUSR                  1     10
 
 
      *  Program Status Data Structure
     D PSDS           SDS
     D  USERID               254    263
 
 
      * Report Sequence Number
     D REPSEQ          DS
     D  SEQ                    1      5  0
 
 
 
      * Obtain next sequence number from data area REPSEQ and update
      * data area for next request.
 
     C     *DTAARA       DEFINE                  REPSEQ
     C     *LOCK         IN        REPSEQ
     C                   MOVE      SEQ           ReportSequence    5
     C                   ADD       1             SEQ
     C                   OUT       REPSEQ
 
      * WRITE A RECORD TO FCRREQPD
 
     C                   MOVEL     'GOBSPLRP '   D5RNAM
     C                   MOVEL     ReportSequenceD5RQSQ
     C                   MOVEL     *BLANK        D5SOID
     C                   MOVEL     'S'           D5LVL
     C                   MOVEL     *BLANK        D5ETTY
      * INPUT CYCLE
     C                   MOVEL     'Y'           D5IPCY
      * PERIODIC
     C                   MOVEL     'N'           D5PDFL
     C                   MOVEL     *BLANK        D5DLS1
     C                   MOVEL     *BLANK        D5DLS2
     C                   MOVEL     USERID        D5USRO
     C                   MOVEL     'N'           D5ARMF
     C                   MOVEL     'N'           D5AROD
     C                   MOVEL     'N'           D5DRQD
     C                   MOVEL     USERID        D5USRR
      * REQ TIME
     C                   TIME                    RTIME             6 0
     C                   MOVEL     RTIME         D5RQTM
      * CLOSE OF BUSINESS
     C                   MOVEL     'N'           D5COBR
     C                   MOVEL     *BLANKS       D5JBNM
     C                   MOVEL     *BLANKS       D5JUSR
     C                   MOVEL     *BLANKS       D5JBNB
     C                   MOVEL     *BLANK        D5PSQR
     C                   MOVEL     *BLANK        D5COTT
     C                   MOVEL     *BLANK        D5CSEQ
      *
     C                   WRITE     FCRREQD0
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
      **********************************************************************************
      * *INZSR - Initial Processing
      **********************************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * OUTPUTS
      * Sequence
 
     C                   PARM                    ReportSequence    5
 
      ** If ZMUSER exists, use the name from that, otherwise use the PSDS
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER                               99
     C     *IN99         IFEQ      '0'
     C                   UNLOCK    ZMUSER
     C                   ENDIF
 
     C     ZMUSR         IFNE      *BLANKS
     C                   MOVEL     ZMUSR         USERID
     C                   ENDIF
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
