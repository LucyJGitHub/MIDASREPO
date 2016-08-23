     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*USRCTL)                                             *
/*EXI *  TEXT('Midas UP Report Action File for T_GRMENUL')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP1726 - Report Action File for T_GRMENUL                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CUP031 *CREATE     Date 13Jan05               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CUP031 - Creation of new set of Action File utilities.       *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file indicator
      *       37      Overflow indicator
      *       60      Moveed records
      *       61      No moveed records to report
      *       62      Moved records headers
      *       69      Read or write errors
      *       70      Deleted records
      *       71      No deleted records to report
      *       72      Deleted records headers
      *       80      Inserted records
      *       81      No inserted records to report
      *       82      Inserted records headers
      *
     FUPGMULL0  IF   E           K DISK    INFSR(*PSSR)
     FUP1726P1  O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL)
     F                                     OFLIND(*IN37)
     F                                     USROPN
      *
      /EJECT
      *
      * File information data structure for P1 file; used for page end
      *   handling
     D SPOOL           DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D  OFLLN                188    189B 0
     D  PRTLN                367    368B 0
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      * Local data area for database error details
      * *LOCK IN LDA immediately before and OUT LDA immediately
      * after each database error handling.
      *
      *                                     134 141 DBFILE
      *        Defines:                     142 170 DBKEY
      *                                     171 180 DBPGM
      *                                     181 1830DBASE
      *
     D PSDS           SDS
      *
      * Program Status Data Structure.
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D #GRPID20        S             20                                         #RGPID in 20A.
     D #KGRPID20       S             20                                         #KRGPID in 20A.
 
     C     *ENTRY        PLIST
     C                   PARM                    HDRTXT
      *
     C                   OPEN      UP1726P1
      *
     C                   WRITE     HEADH                                69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *LOVAL        SETLL     UPGMULD0
      *
     C                   READ      UPGMULL0                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * If there are no records at all write 'no records'.
     C     *IN20         IFEQ      *ON
     C                   WRITE     NORECS                               69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   WRITE     TRAILP                               69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   GOTO      ENDPGM
      *
     C                   ELSE
     C                   SETON                                        70
     C                   WRITE     DTL2
     C                   SETOFF                                       70
     C                   ENDIF
      *
     C     MLACTC        IFNE      'D'
     C                   SETON                                        71
     C                   WRITE     DTL2
     C                   SETOFF                                       71
     C                   ELSE
     C                   SETON                                        72
     C                   WRITE     DTL2
     C                   SETOFF                                       72
     C                   ENDIF
      *
     C     MLACTC        DOWEQ     'D'
     C     *IN20         ANDNE     *ON
      *
      * Write headers if overflow on.
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADH                                69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   SETON                                        70
     C                   WRITE     DTL2
     C                   SETOFF                                       70
     C                   SETON                                        72
     C                   WRITE     DTL2
     C                   SETOFF                                       7237
     C                   ENDIF
      *
     C                   EXSR      DELETE
      *
     C                   READ      UPGMULL0                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO
      *
     C                   WRITE     HEADH                                69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   SETON                                        80
     C                   WRITE     DTL3
     C                   SETOFF                                       80
      *
     C     MLACTC        IFNE      'I'
     C                   SETON                                        81
     C                   WRITE     DTL3
     C                   SETOFF                                       81
     C                   ELSE
     C                   SETON                                        82
     C                   WRITE     DTL3
     C                   SETOFF                                       82
     C                   ENDIF
      *
     C     MLACTC        DOWEQ     'I'
     C     *IN20         ANDNE     *ON
      *
      * Write headers if overflow on.
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADH                                69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   SETON                                        80
     C                   WRITE     DTL3
     C                   SETOFF                                       80
     C                   SETON                                        82
     C                   WRITE     DTL3
     C                   SETOFF                                       8237
     C                   ENDIF
      *
     C                   EXSR      INSERT
      *
     C                   READ      UPGMULL0                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO
      *
     C                   WRITE     HEADH                                69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   SETON                                        60
     C                   WRITE     DTL1
     C                   SETOFF                                       60
      *
     C     MLACTC        IFNE      'M'
     C                   SETON                                        61
     C                   WRITE     DTL1
     C                   SETOFF                                       61
     C                   ELSE
     C                   SETON                                        62
     C                   WRITE     DTL1
     C                   SETOFF                                       62
     C                   ENDIF
      *
     C     MLACTC        DOWEQ     'M'
     C     *IN20         ANDNE     *ON
      *
      * Write headers if overflow on.
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADH                                69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   SETON                                        60
     C                   WRITE     DTL1
     C                   SETOFF                                       60
     C                   SETON                                        62
     C                   WRITE     DTL1
     C                   SETOFF                                       6237
     C                   ENDIF
      *
     C                   EXSR      MOVEREC
      *
     C                   READ      UPGMULL0                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO                                                  DOW MLACTC = 'M'
      *
     C                   WRITE     TRAILP                               69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     ENDPGM        TAG
     C                   CLOSE     UP1726P1
     C                   SETON                                        LR
     C                   RETURN
      *                                                               *
      *****************************************************************
      *                                                               *
      * DELETE subroutine - process deleted records                   *
      *                                                               *
      *****************************************************************
     C     DELETE        BEGSR
     C                   EVAL      #HYID      =  MLHYID
      *
     C                   IF        %NULLIND(MLGRPID)
     C                   EVALR     #GRPID20   = '= null value'
     C                   ELSE
     C                   EVALR     #GRPID20   = %EDITC(MLGRPID:'3')
     C                   ENDIF
      *
     C                   EVAL      #LEVEL     = MLLEVEL
     C                   EVAL      #PARENT20  = MLPARENT
      *
     C                   IF        %NULLIND(MLMENUCODE)
     C                   EVAL      #MENUCODE   = '= null value'
     C                   ELSE
     C                   EVAL      #MENUCODE   = MLMENUCODE
     C                   ENDIF
      *
     C                   WRITE     DTL2                                 69
     C     *IN69         IFEQ      *ON
     C                   SETON                                        U7U8
     C                   DUMP
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * INSERT subroutine - process inserted records                  *
      *                                                               *
      *****************************************************************
     C     INSERT        BEGSR
     C                   EVAL      #HYID       =  MLHYID
      *
     C                   IF        %NULLIND(MLGRPID)
     C                   EVAL      #GRPID      =  '= null value'
     C                   ELSE
     C                   EVAL      #GRPID20    = %EDITC(MLGRPID:'3')
     C                   EVALR     #GRPID      = #GRPID20
     C                   ENDIF
      *
     C                   EVAL      #LEVEL      = MLLEVEL
     C                   EVAL      #PARENT     = MLPARENT
      *
     C                   IF        %NULLIND(MLMENUCODE)
     C                   EVAL      #MENUCODE   = '= null value'
     C                   ELSE
     C                   EVAL      #MENUCODE   = MLMENUCODE
     C                   ENDIF
      *
     C                   EVALR     #POS        = MLPOS
     C                   EVAL      #KHYID      = MLKHYID
      *
     C                   IF        %NULLIND(MLKGRPID)
     C                   EVAL      #KGRPID     =  '= null value'
     C                   ELSE
     C                   EVAL      #KGRPID20   = %EDITC(MLKGRPID:'3')
     C                   EVALR     #KGRPID     = #KGRPID20
     C                   ENDIF
      *
     C                   EVAL      #KLEVEL     = MLKLEVEL
     C                   EVAL      #KPARENT    = MLKPARENT
      *
     C                   IF        %NULLIND(MLKMENUCOD)
     C                   EVAL      #KMENUCODE  = '= null value'
     C                   ELSE
     C                   EVAL      #KMENUCODE  = MLKMENUCOD
     C                   ENDIF
      *
     C                   WRITE     DTL3                                 69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * MOVEREC subroutine - process moved records                   *
      *                                                               *
      *****************************************************************
     C     MOVEREC       BEGSR
     C                   EVAL      #HYID       =  MLHYID
      *
     C                   IF        %NULLIND(MLGRPID)
     C                   EVAL      #GRPID      =  '= null value'
     C                   ELSE
     C                   EVAL      #GRPID20    = %EDITC(MLGRPID:'3')
     C                   EVALR     #GRPID      = #GRPID20
     C                   ENDIF
      *
     C                   EVAL      #LEVEL      = MLLEVEL
     C                   EVAL      #PARENT     = MLPARENT
      *
     C                   IF        %NULLIND(MLMENUCODE)
     C                   EVAL      #MENUCODE   = '= null value'
     C                   ELSE
     C                   EVAL      #MENUCODE   = MLMENUCODE
     C                   ENDIF
      *
     C                   EVALR     #POS        = MLPOS
     C                   EVAL      #KHYID      = MLKHYID
      *
     C                   IF        %NULLIND(MLKGRPID)
     C                   EVAL      #KGRPID     =  '= null value'
     C                   ELSE
     C                   EVAL      #KGRPID20   = %EDITC(MLKGRPID:'3')
     C                   EVALR     #KGRPID     = #KGRPID20
     C                   ENDIF
      *
     C                   EVAL      #KLEVEL     = MLKLEVEL
     C                   EVAL      #KPARENT    = MLKPARENT
      *
     C                   IF        %NULLIND(MLKMENUCOD)
     C                   EVAL      #KMENUCODE  = '= null value'
     C                   ELSE
     C                   EVAL      #KMENUCODE  = MLKMENUCOD
     C                   ENDIF
      *
     C                   WRITE     DTL1                                 69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     MOVERECE      ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
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
