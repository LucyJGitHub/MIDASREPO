     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Audit Change Details - Retrieval')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUCDRTL - Audit Change Details - Retrieval                 *
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
 
     FGPAUCDPD  IF   E           K DISK    INFSR(*PSSR)
 
 
      * Field Attributes
      * Field Shortnames
     D/COPY GPCPYSRCG,GPAUFDATB
     D/COPY GPCPYSRCG,GPAUFDSNM
 
 
      * Field Contents
     D/COPY GPCPYSRCG,GPAUFDCON
 
 
     D                 DS
     D OUTPUT                  1    111
     D OUT                     1    111    DIM(111)
 
 
     D                 DS
     D DATA_                   1  25600
     D DATA                    1  25600    DIM(25600)
     D DTA                     1  25600    DIM(100)
 
     D                 DS
     D  w#cr                   1      1    inz(x'0d')
     D  w#lf                   2      2    inz(x'25')
 
 
      * Clear outputs
 
     C                   MOVEL     *BLANK        #_FDCON
     C                   MOVEL     *BLANK        #B_FDCON
 
      * Get 'AFTER' detail
 
     C                   MOVEL     'A'           ADBFAF
     C                   EXSR      GET_DETAIL
     C                   EXSR      FIELD_CONTENTS
 
      * If update
      *  'BEFORE' detail defaults first to 'AFTER' detail
     C     I#ENTT        IFEQ      'UP'
     C                   MOVEL     #_FDCON       #B_FDCON
     C                   ENDIF
 
      * Get 'BEFORE' detail
 
     C                   MOVEL     'B'           ADBFAF
     C                   EXSR      GET_DETAIL
     C                   EXSR      FIELD_CONTENTS
 
      * Return
 
     C                   RETURN
 
      ****************************************************************
      * Get detail
      ****************************************************************
     C     GET_DETAIL    BEGSR
 
     C                   MOVE      *BLANK        DTA
 
     C     GPAUCDK       SETLL     GPAUCDD0
     C     GPAUCDK       READE     GPAUCDD0                               99    *
     C     *IN99         DOWEQ     '0'
     C                   MOVEL     ADDATA        DTA(ADSEQN)
     C     GPAUCDK       READE     GPAUCDD0                               99    *
     C                   ENDDO
 
     C                   ENDSR
     C****************************************************************
     C/SPACE 5
      ****************************************************************
      * Field contents
      ****************************************************************
     C     FIELD_CONTENTSBEGSR
 
     C                   Z-ADD     1             #SO               5 0
     C                   Z-ADD     1             #EO               5 0
     C     w#lf          LOOKUP    DATA(#EO)                              60    *
     C     *IN60         DOWEQ     *ON
 
     C     #EO           SUB       #SO           #LO               5 099        *
 
     C     *IN99         IFEQ      *ON
 
      * Output = field shortname + contents
 
     C                   MOVE      *BLANK        OUTPUT
     C     #LO           SUBST     DATA_:#SO     OUTPUT
 
      * Get shortname and contents from output
 
     C                   Z-ADD     1             #EI               5 0
     C     w#cr          LOOKUP    OUT(#EI)                               99    *
     C     #EI           SUB       1             #LI               5 0
     C                   MOVE      *BLANK        FDSNAM
     C     #LI           SUBST     OUTPUT:1      FDSNAM           10
     C                   ADD       2             #LI
     C                   MOVE      *BLANK        FDCON
     C                   MOVEA     OUT(#LI)      FDCON           100
 
     C                   Z-ADD     1             #FD               5 0
     C     FDSNAM        LOOKUP    #_FDSNAM(#FD)                          99    *
     C     *IN99         IFEQ      *ON
     C     ADBFAF        IFEQ      'A'
     C                   MOVEL     FDCON         #_FDCON(#FD)
     C                   ELSE
     C                   MOVEL     FDCON         #B_FDCON(#FD)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C     #EO           ADD       1             #SO
     C                   Z-ADD     #SO           #EO
 
     C     w#lf          LOOKUP    DATA(#EO)                              60    *
     C                   ENDDO
 
     C                   ENDSR
     C****************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * INPUT
      * Zone
      * ID
      * Entry Type
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#CID            17 0
     C                   PARM                    I#ENTT            2
      * Field Attributes
      * Field Shortnames
     C                   PARM                    #_FDATRB
     C                   PARM                    #_FDSNAM
      * OUTPUT
      * Field Contents
     C                   PARM                    #_FDCON
     C                   PARM                    #B_FDCON
 
      * key list
     C     GPAUCDK       KLIST
     C                   KFLD                    I#ZONE
     C                   KFLD                    I#CID
     C                   KFLD                    ADBFAF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
