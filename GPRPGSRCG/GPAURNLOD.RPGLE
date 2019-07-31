     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Audit Report Narrative - Load')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAURNRTL - Audit Report Narrative - Load                    *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD043639           Date 27Jan17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD043639 - Audit report name is same for all functions.      *
      *             Fix is to rename the Audit report according to    *
      *             function being audited. Change length of HLN.     *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGPAURNL0  IF   E           K DISK    INFSR(*PSSR)
 
 
      * Number of files whose field attributes are stored
     D NoofFiles       C                   CONST(20)
      * File/Record ID
     D #_FILRID        S             25    DIM(NoofFiles)
      * Total Lines
     D #_TOT           S          19800    DIM(NoofFiles)
      * Highest Line
     D*#_HLN****       S              2  0 DIM(NoofFiles)                                   MD043639
     D #_HLN           S              3  0 DIM(NoofFiles)                                   MD043639
 
 
     D TOT             S            132    DIM(150)
     D LIN             S              1    DIM(132)
     D SLIN            S              1    DIM(132)
 
 
      * Clear outputs
 
     C                   MOVEL     *BLANK        TOT
     C                   Z-ADD     1             HLN
 
 
      * Error if the file is not supplied
 
     C     InFile        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'NO FILE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     InFile        File_RecordID    25
     C                   MOVE      InRecordID    File_RecordID
 
 
      * If the file's report narratives were previously accessed,
      * use those report narratives
 
     C                   Z-ADD     1             #X                6 0
     C     File_RecordID LOOKUP    #_FILRID(#X)                           99    *
     C     *in99         IFEQ      *ON
     C                   MOVEA     #_TOT(#X)     TOT
     C                   Z-ADD     #_HLN(#X)     HLN
     C                   ELSE
 
      * Load narrative into report
 
     C                   EXSR      LOAD_NARR
 
      * Save the file's details
 
     C                   Z-ADD     1             #X
     C     *BLANK        LOOKUP    #_FILRID(#X)                           99    *
     C     *in99         IFEQ      *ON
     C                   MOVEL     File_RecordID #_FILRID(#X)
     C                   MOVEA     TOT           #_TOT(#X)
     C                   Z-ADD     HLN           #_HLN(#X)
     C                   ELSE
     C                   ADD       1             #C
     C                   MOVEL     File_RecordID #_FILRID(#C)
     C                   MOVEA     TOT           #_TOT(#C)
     C                   Z-ADD     HLN           #_HLN(#C)
     C     #C            IFEQ      NoofFiles
     C                   Z-ADD     *ZERO         #C
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Return
 
     C                   RETURN
 
     C/SPACE 5
      ****************************************************************
      * Load narrative into report
      ****************************************************************
     C     LOAD_NARR     BEGSR
 
     C** LOAD NARRATIVE FROM GPAURNPD
 
     C     GPAURNK       SETLL     GPAURND0
     C     GPAURNK       READE     GPAURND0                               99    *
 
     C* DO WHILE NOT EOF
 
     C     *IN99         DOWEQ     '0'
 
     C                   EXSR      FMT_NARR
 
     C     GPAURNK       READE     GPAURND0                               99    *
     C                   END
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Format narrative
      *****************************************************************
     C     FMT_NARR      BEGSR
 
     C* START POINT
 
     C                   Z-ADD     AFPS          X                 3 0
 
     C* GET LINE
 
     C                   MOVEA     TOT(AFLN)     SLIN
     C                   MOVEA     TOT(AFLN)     LIN
 
     C* DESCRIPTION
 
     C                   MOVEA     AFNARR        LIN(X)
 
     C* END POINT
 
     C                   ADD       AFDIG         X
     C     X             IFLE      132
     C                   MOVEA     SLIN(X)       LIN(X)
     C                   END
     C* UPDATE
     C                   MOVEA     LIN           TOT(AFLN)
 
     C* HIGHEST LINE?
 
     C     AFLN          IFGT      HLN
     C                   Z-ADD     AFLN          HLN
     C                   END
 
     C                   ENDSR
      ****************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * INPUT
      * File
      * Record ID
     C                   PARM                    InFile           10
     C                   PARM                    InRecordID       15
      * OUTPUT
      * Total lines
      * Highest Line
     C                   PARM                    TOT
     C**********         PARM                    HLN               2 0                      MD043639
     C                   PARM                    HLN               3 0                      MD043639
 
     C                   Z-ADD     *ZERO         #C                6 0
 
      * key list
     C     GPAURNK       KLIST
     C                   KFLD                    InFile
     C                   KFLD                    InRecordID
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
