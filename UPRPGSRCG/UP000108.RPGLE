     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*XBI *  OVRDBF FILE(UPFDAPOF) TOFILE(QAFDACCP)                       *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Database cross reference')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade module                                       *
      *                                                               *
      *  UP000108 - Produce report of database mismatches - global    *
      *             and zone.                                         *                       CUP028
      *                                                               *
      *  Called By: UPC000108                                         *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256038             Date 21Jun08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CUP028             Date 13Sep04               *
      *                 CPK021             Date 08Sep04               *
      *                 CUP027 *CREATE     Date 25Mar04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256038 - Utility was not picking up LFs compiled over wrong  *
      *           physicals.                                          *
      *  CUP028 - Amend so that this program can be used for both     *
      *           zone and global.                                    *
      *  CPK021 - IBM API has changed.  Also stop printing duplicate  *
      *           records.                                            *
      *  CUP027 - Global layer migration of Bridge ICD to the System  *
      *           Values file.                                        *
      *                                                               *
      *****************************************************************
     FUPFDAPOF  IF   E             DISK
     FUP0108P1  O    E             PRINTER OFLIND(*IN37)
      /EJECT
      *
      * Data structure for user space name
     D                 DS
     D  QUS                    1     20
     D  US                     1     10
     D  USLIB                 11     20
      *
      * Data structure for qualified file name
     D                 DS
     D  QFILE                  1     20
     D  QFILEN                 1     10
     D  QFILEL                11     20
      * Data structure for error handling
     D                 DS
     D  ERRP                   1     26
     D  ERR1                   1      4B 0
     D  ERR2                   5      8B 0
     D  ERR3                   9     16
     D  ERR4                  17     17
     D  ERR5                  18     26
      *
      * Parameters for retrieval of user space header
     D USHEAD          DS
     D  ALLDTA                 1    140
     D  OFFLST               125    128B 0
     D  NOENTS               133    136B 0
     D  ENTSIZ               137    140B 0
      * Parameters for retrieval of user space data
     D USLIST          DS
     D  PFILE                  1     10
     D  PFILEL                11     20
     D  LFILE                 21     30
     D  LFILEL                31     40
     D  DTYPE                 41     41
     D  RES                   42     44
     D  REFNO                 45     48B 0
     D  ConstraintLib         49     58                                                       CPK021
     D  ConstraintLen         59     62B 0                                                    CPK021
     D  ConstraintNam         63    320                                                       CPK021
      * Parameters for user space retrieval API
     D                 DS
     D  USSTRT                 1      4B 0
     D  USLEN                  5      8B 0
     D**USDTA***               9    158                                                       CPK021
     D  USDTA                  9    328                                                       CPK021
     D PSDS           SDS
      * Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D  SPhysFile      S             10                                                       CPK021
     D  SPhysFileLib   S             10                                                       CPK021
     D  SLogFile       S             10                                                       CPK021
     D  SLogFileLib    S             10                                                       CPK021
      *
      /SPACE 3
      * Parameters passed to program
     C     *ENTRY        PLIST
     C                   PARM                    SYSID             2
     C                   PARM                    PROCESS           7                          CUP028
     C                   PARM                    ERR               1
      *
      * Set up library names
      *  depending on PROCESS parameter (*GLOBAL or *ZONE)                                    CUP028
     C     PROCESS       IFEQ      '*GLOBAL'                                                  CUP028
     C     SYSID         CAT       'GVLIB':0     DVLIB            10
     C     SYSID         CAT       'GPLIB':0     DPLIB            10
     C     SYSID         CAT       'GMLIB':0     DMLIB            10
     C     SYSID         CAT       'GTALIB':0    DTALIB           10
     C                   ENDIF                                                                CUP028
     C     PROCESS       IFEQ      '*ZONE  '                                                  CUP028
     C     SYSID         CAT       'DVLIB':0     DVLIB                                        CUP028
     C     SYSID         CAT       'DPLIB':0     DPLIB                                        CUP028
     C     SYSID         CAT       'DMLIB':0     DMLIB                                        CUP028
     C     SYSID         CAT       'DTALIB':0    DTALIB                                       CUP028
     C                   ENDIF                                                                CUP028
      *
      * Write first header for report
     C                   WRITE     HEADH                                69
     C                   WRITE     PHEAD                                69
     C     *IN69         IFEQ      *ON
     C                   MOVE      'Y'           ERR
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
      * Process physical files which have logicals built over them
      *  in a non-standard Midas library
      * Set up parameters for retrieval from user space
     C                   MOVEL     'DBR'         US
     C                   MOVEL     'QTEMP'       USLIB
     C                   MOVEL     '*ALL'        QFILEN
      *
     C                   MOVEL     DMLIB         QFILEL
     C                   MOVEL     DVLIB         LOGLIB           10
     C                   EXSR      BDBR
      *
     C                   MOVEL     DPLIB         QFILEL
     C                   EXSR      BDBR
      *
     C                   MOVEL     DTALIB        QFILEL
     C                   EXSR      BDBR
      *
     C     PFLAG         IFNE      'Y'
     C                   WRITE     NORECS                               69
     C     *IN69         IFEQ      *ON
     C                   MOVE      'Y'           ERR
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   ENDIF
      *
     C                   WRITE     HEADH                                69
     C                   WRITE     LHEAD                                69
     C     *IN69         IFEQ      *ON
     C                   MOVE      'Y'           ERR
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
      * Process logical files which are built over physicals in a
      *  non-standard Midas library
     C     1             SETLL     UPFDAPOF
     C                   READ      UPFDAPOF                             6920
     C     *IN69         IFEQ      *ON
     C                   MOVE      'Y'           ERR
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C     *IN20         DOUEQ     *ON
      *
      * Only check logicals
     C     APFTYP        IFEQ      'L'
      *
      * Check logical/physical relation is not duplicate
     C     APFILE        IFNE      SPFILE
     C     APBOF         ORNE      SAPBOF
      *
     C                   MOVEL     APBOF         APBOFP            2
     C     APLIB         IFEQ      DVLIB
     C     APBOL         IFNE      DMLIB
     C     APBOL         ANDNE     DPLIB
     C     APBOL         ANDNE     DTALIB
      *
     C     APBOL         IFEQ      DVLIB
     C*****APBOFP        ANDNE     'V_'                                                       256038
     C     APBOFP        IFNE      'V_'                                                       256038
     C                   EXSR      WFDR
     C                   ENDIF
     C                   ELSE                                                                 256038
     C                   EXSR      WFDR                                                       256038
     C                   ENDIF                                                                256038
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     APFILE        SPFILE           10
     C                   MOVEL     APBOF         SAPBOF           10
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      UPFDAPOF                             6920
     C     *IN69         IFEQ      *ON
     C                   MOVE      'Y'           ERR
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     LFLAG         IFNE      'Y'
     C                   WRITE     NORECS                               69
     C     *IN69         IFEQ      *ON
     C                   MOVE      'Y'           ERR
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   ENDIF
     C                   WRITE     TRAILP                               69
     C     *IN69         IFEQ      *ON
     C                   MOVE      'Y'           ERR
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
     C     BDBR          BEGSR
      * Use API to build list of database relations for DMLIB
     C                   CALL      'QDBLDBR'
     C                   PARM                    QUS
     C                   PARM      'DBRL0100'    FMT               8
     C                   PARM                    QFILE
     C                   PARM      *BLANKS       MBR              10
     C                   PARM      *BLANKS       RFMT             10
     C                   PARM                    ERRP
      *
      * Use API to retrieve list data from user space; first call gets
      *    user space header information (See I specs for DS)
     C                   CALL      'QUSRTVUS'
     C                   PARM                    QUS
     C                   PARM      1             USSTRT
     C                   PARM      140           USLEN
     C     USHEAD        PARM                    USDTA
      *
      * If no entries then set on indicator and skip further processing
     C     NOENTS        IFEQ      0                                            B01
     C                   SETON                                        71
     C                   ENDIF                                                  E01
      * Execute SR to loop through list data from user space if entrie
     C  N71              EXSR      RDBR
      *
     C     EBDBR         ENDSR
      *****************************************************************
     C     RDBR          BEGSR
      * Use API to retrieve list data from user space; set up control
     C                   Z-ADD     1             A                 5 0
     C                   Z-ADD     ENTSIZ        USLEN
     C     OFFLST        ADD       1             USSTRT
      *
     C     A             DOWLE     NOENTS                                       D01
     C                   CLEAR                   USDTA
      *
      * Call API to retrieve database relations
     C                   CALL      'QUSRTVUS'
     C                   PARM                    QUS
     C                   PARM                    USSTRT
     C                   PARM                    USLEN
     C     USLIST        PARM                    USDTA
      *
      * If database dependency does not match then write to report
     C     DTYPE         IFNE      *BLANKS
     C     LFILEL        ANDNE     LOGLIB
     C                   MOVE      'Y'           PFLAG             1
     C                   EXSR      WDBR
     C                   ENDIF
      *
     C                   ADD       1             A
     C                   ADD       ENTSIZ        USSTRT
     C                   ENDDO                                                  ED01
      *
     C     ERDBR         ENDSR
      *****************************************************************
     C     WDBR          BEGSR
      *
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADH                                69
     C                   WRITE     PHEAD                                69
     C                   MOVEL     *BLANKS       SPFILL           10
     C     *IN69         IFEQ      *ON
     C                   MOVE      'Y'           ERR
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   SETOFF                                       37
     C                   ENDIF
      *
     C                   MOVEL     PFILE         @PFIL
     C     PFILEL        IFEQ      SPFILL
     C                   MOVEL     *BLANKS       @PFILL
     C                   ELSE
     C                   MOVEL     PFILEL        @PFILL
     C                   MOVEL     PFILEL        SPFILL
     C                   ENDIF
     C                   MOVEL     LFILE         @LFIL
     C                   MOVEL     LFILEL        @LFILL
     C                   IF        PFILE <> SPhysFile or                                      CPK021
     C                             PFILEL <> SPhysFileLib or                                  CPK021
     C                             LFILE <> SLogFile or                                       CPK021
     C                             LFILEL <> SLogFileLib                                      CPK021
     C                   EVAL      SPhysFile = PFILE                                          CPK021
     C                   EVAL      SPhysFileLib = PFILEL                                      CPK021
     C                   EVAL      SLogFile = LFILE                                           CPK021
     C                   EVAL      SLogFileLib = LFILEL                                       CPK021
     C                   WRITE     PDTL                                 69
     C     *IN69         IFEQ      *ON
     C                   MOVE      'Y'           ERR
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   ENDIF                                                                CPK021
      *
     C     EWDBR         ENDSR
      *****************************************************************
     C     WFDR          BEGSR
      *
     C                   MOVE      'Y'           LFLAG             1
      *
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADH                                69
     C                   WRITE     LHEAD                                69
     C                   MOVEL     *BLANKS       SAPLIB           10
     C     *IN69         IFEQ      *ON
     C                   MOVE      'Y'           ERR
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   SETOFF                                       37
     C                   ENDIF
      *
     C                   MOVEL     APFILE        @LFIL
     C     APLIB         IFEQ      SAPLIB
     C                   MOVEL     *BLANKS       @LFILL
     C                   ELSE
     C                   MOVEL     APLIB         @LFILL
     C                   MOVEL     APLIB         SAPLIB
     C                   ENDIF
     C                   MOVEL     APBOF         @PFIL
     C                   MOVEL     APBOL         @PFILL
     C                   WRITE     LDTL                                 69
     C     *IN69         IFEQ      *ON
     C                   MOVE      'Y'           ERR
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C     EFDBR         ENDSR
      *****************************************************************
