     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Audit File - Retrieval')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUFLRTL - Audit File - Retrieval                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGPAUFLL0  IF   E           K DISK    INFSR(*PSSR)
 
 
      * Number of files whose details are stored
     D NoofFiles       C                   CONST(100)
      * Files
     D #_FIL           S             10    DIM(NoofFiles)
      * 1st Occurence of File
     D #_1OC           S              3  0 DIM(NoofFiles)
      * File/Record ID
     D #_FILRID        S             25    DIM(NoofFiles)
      * File Details
     D #_FILDET        S            102    DIM(NoofFiles)
 
 
      * File Details
     D GPAUFL        E DS                  EXTNAME(GPAUFLPD)
 
 
      * Clear outputs
 
     C                   CLEAR                   GPAUFL
 
 
      * Error if the file is not supplied
 
     C     InFile        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'NO FILE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Check that the file is present in the database
 
     C                   Z-ADD     1             #X
     C     InFile        LOOKUP    #_FIL(#X)                              99    *
     C     *in99         IFEQ      *OFF
     C                   EVAL      I#ERMS = 'INVALID FILE:' + InFile
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Look for files with a record ID first
 
     C     #_1OC(#X)     ADD       1             #C
 
      * Loop through all the input file's record IDs
      * Check whether the input record has a match on record ID
 
     C                   MOVEL     'N'           RecordIDMatch
 
     C     FileMatch     DOUEQ     'N'
     C     RecordIDMatch OREQ      'Y'
     C                   MOVEL     #_FILRID(#C)  StFile           10
     C                   MOVE      #_FILRID(#C)  StRecordID       15
     C     StFile        IFEQ      InFile
     C                   MOVEL     #_FILDET(#C)  GPAUFL
     C                   MOVEL     *BLANK        FlRecordID       15
     C                   EVAL      FlRecordID = %subst(InRecord:AFRIOB:AFRILN)
     C     ' '           SCAN      FlRecordID    #BP               2 0    98
     C   98              SUB       1             #BP                  98
     C  N98              Z-ADD     15            #BP
     C     FlRecordID:#BPSCAN      StRecordID                             99
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'Y'           RecordIDMatch     1
     C                   ENDIF
     C                   MOVEL     'Y'           FileMatch         1
     C                   ELSE
     C                   MOVEL     'N'           FileMatch
     C                   ENDIF
     C                   ADD       1             #C
     C                   ENDDO
 
      * If no match on record ID use 1st occurrence of file
 
     C     RecordIDMatch IFEQ      'N'
     C                   Z-ADD     #_1OC(#X)     #C
     C                   MOVEL     #_FILDET(#C)  GPAUFL
     C                   ENDIF
 
      * Return
 
     C                   RETURN
      *
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
      * Record
     C                   PARM                    InFile           10
     C                   PARM                    InRecord       4000
      * OUTPUT
      * File Details
     C                   PARM                    GPAUFL
 
     C                   Z-ADD     *ZERO         #C                6 0
 
      * Load file details
 
     C     *LOVAL        SETLL     GPAUFLD0
     C                   READ      GPAUFLD0                               99    *
     C     *in99         DOWEQ     *OFF
 
     C     AFACTV        IFEQ      'Y'
     C                   ADD       1             #C
 
     C                   Z-ADD     1             #X                6 0
     C     AFFILE        LOOKUP    #_FIL(#X)                              99    *
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    #_FIL(#X)                              99    *
     C                   MOVEL     AFFILE        #_FIL(#X)
     C                   Z-ADD     #C            #_1OC(#X)
     C                   ENDIF
 
     C                   MOVEL     AFFILE        #_FILRID(#C)
     C                   MOVE      AFRCID        #_FILRID(#C)
     C                   MOVEL     GPAUFL        #_FILDET(#C)
     C                   ENDIF
 
     C                   READ      GPAUFLD0                               99    *
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
