     H DEBUG ALWNULL(*USRCTL)
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Global T_MLCCYRT Generation')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPTMLCRGEN - Global Currency Rates Details Generation        *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG4521  *CREATE   Date 14Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  BUG4521- Update file T_GPUTILSR                              *
      *                                                               *
      *****************************************************************
 
     FGZSDCURRL0IF   E           K DISK    INFSR(*PSSR)
O    FGPMLCSL0  O  A E             DISK    INFSR(*PSSR) COMMIT(D_COM)
O    F                                     USROPN
 
 
      * Read through each record on the global customer file and write to T_GPUTILSR
     C                   READ      SDCURRD0                               99
     C     *IN99         DOWEQ     *OFF
     C                   EXSR      SET_SDCURR
     C                   WRITE     GPMLCSPD
     C                   READ      SDCURRD0                               99
     C                   ENDDO
 
     C                   SETON                                        LR
     C                   RETURN
 
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Set output fields for a global currency
      ********************************************************************
     C     SET_SDCURR    BEGSR
 
      * Move GZSDCURRPD fields into layout for GPMLCSPD
      * Currency
     C                   EVAL      CCYCODE = A6CYCD
      * Number of decimal places
     C                   EVAL      CCYNDEC  = A6NBDP
      * Zone
     C                   EVAL      CCYZONE    = A6ZONE
      * Spot Rate
     C                   IF        A6MDIN = 'D'
     C     1             DIV       A6SPRT        CCYSRATE
     C                   ELSE
     C                   Z-ADD     A6SPRT        CCYSRATE
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
O     * Open for commit?
O
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
O    C                   OPEN      GPMLCSL0
B
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     RunBefore     IFEQ      *BLANKS
 
     C                   MOVE      'Y'           RunBefore         1
 
     C                   DUMP
     C                   ENDIF
 
     C                   SETON                                        LRU7U8
     C                   RETURN
 
     C                   ENDSR
      *********************************************************************
