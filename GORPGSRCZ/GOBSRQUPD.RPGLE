     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO BSPL Request Update')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSRQUPD - BSPL Request Update                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CAS014             Date 10Aug05               *
      *  Prev Amend No. CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAS014 - IAS21 (The Effects of Changes in Foreign Exchange   *
      *           Rates). Recompile.                                  *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGPBSRQL0  UF A E           K DISK    INFSR(*PSSR) PREFIX(O_)
     F                                     COMMIT
 
 
      * BSPL Request - File Format
     D GPBSRQ        E DS                  EXTNAME(GPBSRQPD) PREFIX(O_)
 
      * BSPL Request - File Format
     D ValidGPBSRQ   E DS                  EXTNAME(GPBSRQPD)
     D BSRQKey                 1     16
 
 
      * Clear outputs
 
     C                   MOVE      *BLANK        I#RTCD
     C                   MOVE      *BLANK        I#ERMS
 
      * Update record
 
     C     SCCHTP        CASEQ     'I'           INSERT
     C     SCCHTP        CASEQ     'A'           AMEND
     C     SCCHTP        CASEQ     'D'           DELETE
     C                   END
 
 
     C                   RETURN
 
      /EJECT
      ****************************************************************
      * INSERT A BSPL REQUEST RECORD                                 *
      ****************************************************************
     C     INSERT        BEGSR
 
      * SET RECORD
 
     C                   EVAL      GPBSRQ = ValidGPBSRQ
 
      *  WRITE RECORD
 
     C                   WRITE     GPBSRQD0
 
     C                   ENDSR
     C****************************************************************
      /EJECT
      ****************************************************************
      * AMEND A BSPL REQUEST RECORD                                  *
      ****************************************************************
     C     AMEND         BEGSR
 
      * ACCESS RECORD
 
     C     GPBSRQK       CHAIN     GPBSRQD0                           99
 
      * DATABASE ERROR IF RECORD NOT FOUND
 
     C     *IN99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'KEY ' + BSRQKey
     C                                      + 'NOT PRESENT IN GPBSRQPD'
     C                   EXSR      *PSSR
     C                   END
 
      * SET RECORD
 
     C                   EVAL      GPBSRQ = ValidGPBSRQ
 
      * UPDATE RECORD
 
     C                   UPDATE    GPBSRQD0
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
      ****************************************************************
      * DELETE A BSPL REQUEST RECORD                                 *
      ****************************************************************
     C     DELETE        BEGSR
 
      * ACCESS RECORD
 
     C     GPBSRQK       CHAIN     GPBSRQD0                           99
 
      * DATABASE ERROR IF RECORD NOT FOUND
 
     C     *IN99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'KEY ' + BSRQKey
     C                                      + 'NOT PRESENT IN GPBSRQPD'
     C                   EXSR      *PSSR
     C                   END
 
      * DELETE
 
     C                   DELETE    GPBSRQD0
 
     C                   ENDSR
      ****************************************************************
      /SPACE 5
      *******************************************************************
      * *INZSR - Initial Processing
      *******************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * BSPL Request - File Format
     C                   PARM                    ValidGPBSRQ
 
      * Key lists
 
     C     GPBSRQK       KLIST
     C                   KFLD                    SCRQTYP
     C                   KFLD                    SCRQID
 
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
