     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Utility to populate CLGLAC in RECMHLPD')               *
      *****************************************************************
      *                                                               *
      *  Midas - FC Module                                            *
      *                                                               *
      *  SMU00228 - Utility to populate CLGLAC in RECMHLPD, RECMHLTPD *
      *               and RELCMHLPD                                   *
      *                                                               *
      *  Function:  This program will initialize CLGLAC field with    *
      *             CLGLAI value. CLGLAI will then be set to blank.   *
      *                                                               *
      *  Called By: SMUC00228                                         *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR676213 *CREATE   Date 19Nov10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR676213 - Incorrect definition of CLGLAI field              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
 
      ** RE Cash Management Hierarchy Links
     FRECMHLPD  UF   E           K DISK    INFSR(*PSSR)
 
      ** RE Cash Mgt Heirarchy Links - Temp
     FRECMHLTPD UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(A_)
 
      ** RE Live Cash Mgt Heirarchy Links
     FRELCMHLPD UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMHLD0:RECMHLD2)
     F                                     PREFIX(B_)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
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
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
 
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
 
     D @RUN            S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C                   READ      RECMHLPD
 
     C                   DOW       NOT %EOF(RECMHLPD)
 
     C                   EVAL      CLGLAC = CLGLAI
     C                   EVAL      CLGLAI = *BLANKS
     C                   UPDATE    RECMHLD0
 
     C                   READ      RECMHLPD
     C                   ENDDO
 
     C                   READ      RECMHLTPD
 
     C                   DOW       NOT %EOF(RECMHLTPD)
 
     C                   EVAL      A_CLGLAC = A_CLGLAI
     C                   EVAL      A_CLGLAI = *BLANKS
     C                   UPDATE    RECMHLD1
 
     C                   READ      RECMHLTPD
     C                   ENDDO
 
     C                   READ      RELCMHLPD
 
     C                   DOW       NOT %EOF(RELCMHLPD)
 
     C                   EVAL      B_CLGLAC = B_CLGLAI
     C                   EVAL      B_CLGLAI = *BLANKS
     C                   UPDATE    RECMHLD2
 
     C                   READ      RELCMHLPD
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   Return
 
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
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
