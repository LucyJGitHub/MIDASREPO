     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO BSPL Request Deletion')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSRQDEL - BSPL Request Deletion                            *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAS014             Date 10Aug05               *
      *                 CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAS014 - IAS21 (The Effects of Changes in Foreign Exchange   *
      *           Rates). Recompile.                                  *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGPBSRQL0  UF   E           K DISK    INFSR(*PSSR)
 
 
      * BSPL Request - File Format
     D GPBSRQ        E DS                  EXTNAME(GPBSRQPD)
     D BSRQKey                 1     16
 
 
      * Clear outputs
 
     C                   MOVE      *BLANK        I#RTCD
     C                   MOVE      *BLANK        I#ERMS
 
      * ACCESS RECORD
 
     C                   MOVEL     RequestType   SCRQTYP
     C                   Z-ADD     RequestID     SCRQID
 
     C     GPBSRQK       CHAIN     GPBSRQD0                           99
 
      * DATABASE ERROR IF RECORD NOT FOUND
 
     C     *IN99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'KEY ' + BSRQKey
     C                                      + 'NOT PRESENT IN GPBSRQPD'
     C                   EXSR      *PSSR
     C                   END
 
      * DELETE RECORD
 
     C                   DELETE    GPBSRQD0
 
 
     C                   RETURN
 
      /SPACE 5
      *******************************************************************
      * *INZSR - Initial Processing
      *******************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * BSPL Request Type
      * BSPL Request ID
     C                   PARM                    RequestType       1
     C                   PARM                    RequestID        15 0
 
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
