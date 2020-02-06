     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Global Customer Details Trigger Program')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPGPCUST02 - On-Line Update of Global File GPCUSGPD          *
      *             - Trigger program for GPCUSTPD                    *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 BUG4521  *CREATE   Date 14Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG4521- Update file GPCUSGPD                                *
      *                                                               *
      *****************************************************************
 
O    FGPCUSGL0  UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)
O    F                                     USROPN
O    FGPUTILL0  UF A E           K DISK    INFSR(*PSSR) COMMIT(D_COM)
O    F                                     USROPN
O
     D FILETYPE        S                   LIKE(UTSRTYPE)
O
O    D G_GPCUSTPD    E DS                  EXTNAME(GPCUSTPD)
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#BFAF            1
     C                   PARM                    I#TRAP            1
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
O
O     * Global File Updates
O
O    C     I#BFAF        IFEQ      'B'
O    C                   MOVEL     I#BIMG        G_GPCUSTPD
O    C                   ELSE
O    C                   MOVEL     I#AIMG        G_GPCUSTPD
O    C                   ENDIF
O
      * Use GPCUSTPD key to chain to T_GPCUSL0
O    C     K_GPCUSTL0    CHAIN     GPCUSGD0                           99
 
O     * 'Before'
O    C     I#BFAF        IFEQ      'B'
O    C  N99              DELETE    GPCUSGD0
     C  N99              EXSR      DLT_T_GPUTIL
O    C                   ELSE
O
O     * 'After'
O    C                   CLEAR                   GPCUSGD0
 
      * Move GPCUSTPD fields into layout for T_GPCUSL0
     C                   EXSR      SET_OUT_CUST
 
O     * Update if *IN99 is off else insert
O    C     *IN99         IFEQ      *OFF
O    C                   UPDATE    GPCUSGD0
     C                   EXSR      UPD_T_GPUTIL
O    C                   ELSE
O    C                   WRITE     GPCUSGD0
     C                   EXSR      WRT_T_GPUTIL
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
 
      ********************************************************************
      * Set output fields for a local customer
      ********************************************************************
     C     SET_OUT_CUST  BEGSR
 
      * Local Customer Number
     C                   EVAL      CUSCUST  = *Blanks
      * Global Customer ID
     C                   EVAL      CUSGLOB   = CUGCUS
      * Customer Shortname
     C                   EVAL      CUSCSSN   = CUCSSN
      * Cust. Name & Address 1
      * Cust. Name & Address 2
      * Cust. Name & Address 3
      * Cust. Name & Address 4
     C                   EVAL      CUSNA1    = CUCNA1
     C                   EVAL      CUSNA2    = CUCNA2
     C                   EVAL      CUSNA3    = CUCNA3
     C                   EVAL      CUSNA4    = CUCNA4
      * Customer Report Name
      * Customer Report Town
     C                   EVAL      CUSRNM    = CUCRNM
     C                   EVAL      CUSRTN    = CUCRTN
      * Branch
     C                   EVAL      CUSBRCD   = CUBRCD
      * Bank/non-bank Indicator
     C                   EVAL      CUSNBI    = CUBNBI
      * Global Industry Code
     C                   EVAL      CUSICD    = CUGICD
      * Global Account Officer Code
     C                   EVAL      CUSACO    = CUGACO
      * Country of Citizenship
      * Country of Location
     C                   EVAL      CUSCNCZ   = CUCNCZ
     C                   EVAL      CUSCOLC   = CUCOLC
      * Type of last Change
     C                   EVAL      CUSACTIVE = CUCHTP
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Write record to T_GPUTILSR
      ********************************************************************
     C     WRT_T_GPUTIL  BEGSR
B
     C                   Eval      UTSRTYPE = 1
     C                   Eval      UTSRCODE = CUSGLOB
     C                   Eval      UTSRNAME = CUSRNM + ' ' + CUSRTN
     C                   If        CUSACTIVE = 'D'
     C                   Eval      UTSRACTIVE = 'N'
     C                   Else
     C                   Eval      UTSRACTIVE = 'Y'
     C                   EndIf
B
      * Write the record to T_GPUTILSR
     C                   WRITE     T_GPUTILSR
B
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Delete a record from T_GPUTILSR
      ********************************************************************
     C     DLT_T_GPUTIL  BEGSR
B
      * Use CUSGLOB from to get position on GPUTILL0
B
     C                   Eval      KCODE = CUSGLOB
     C                   Eval      KTYPE = FILETYPE
 
     C     KEYUTIL       CHAIN     GPUTILL0                           92
     C     *IN92         IFEQ      *OFF
O    C                   DELETE    T_GPUTILSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Update a record on T_GPUTILSR
      ********************************************************************
     C     UPD_T_GPUTIL  BEGSR
B
      * Use CUSGLOB from to get position on GPUTILL0
B
     C                   Eval      KCODE = CUSGLOB
     C                   Eval      KTYPE = FILETYPE
 
     C     KEYUTIL       CHAIN     GPUTILL0                           92
     C     *IN92         IFEQ      *OFF
     C                   Eval      UTSRTYPE = 1
     C                   Eval      UTSRCODE = CUSGLOB
     C                   Eval      UTSRNAME = CUSRNM + ' ' + CUSRTN
     C                   If        CUSACTIVE = 'D'
     C                   Eval      UTSRACTIVE = 'N'
     C                   Else
     C                   Eval      UTSRACTIVE = 'Y'
     C                   EndIf
 
O    C                   UPDATE    T_GPUTILSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
O
O     * Open for commit?
O
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
O    C                   OPEN      GPCUSGL0
O
O    C                   CALL      'GPCOPN4COM'
O    C                   PARM                    D_COM             1
O    C                   OPEN      GPUTILL0
 
O    C     K_GPCUSTL0    KLIST
     C                   KFLD                    CUGCUS
 
     C     KEYUTIL       KLIST
     C                   KFLD                    KTYPE
     C                   KFLD                    KCODE            10
 
     C     *LIKE         DEFINE    UTSRTYPE      KTYPE
     C                   Z-ADD     1             FILETYPE
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     W#RUN         IFEQ      *BLANKS
 
     C                   MOVE      'Y'           W#RUN             1
 
     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
 
     C                   DUMP
      *
      * If no identified cause of error
      *
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
      *
      * Log an error on the error log
      *
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#ERMS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
 
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
