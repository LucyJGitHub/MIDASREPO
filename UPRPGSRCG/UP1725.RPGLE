     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*XBIA*  OVRDBF FILE(GMUL1) TOFILE(UPGMULTPD)                         *
/*XBIB*  OVRDBF FILE(GMUL2) TOFILE(UPGMULTPD)                         *
/*XBIC*  OVRDBF FILE(GMUL1KF) TOFILE(UPGMULTPD)                       *
/*XBID*  OVRDBF FILE(NEWGMUL) TOFILE(T_GRMENUL)                       *
/*STD *  RPGBASEBND                                                   *
/*EXI *  ALWNULL(*USRCTL)                                             *
/*EXI *  TEXT('Midas UP Build Action File for T_GRMENUL')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP1725 - Build Action File for T_GRMENUL                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK025             Date 25Aug06               *
      *  Prev Amend No. CUP031 *CREATE     Date 11Jan05               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CPK025 - MidasPlus 1.3 packaging.  Sometimes the CMPPFM puts *
      *           out a wrong result so it needs to be cross checked. *
      *  CUP031 - Creation of new set of Action File utilities.       *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       30      Chain - record not found
      *       35      ReadP - beginning of file error
      *       36      Chain - record not found (NEWGMUL)
      *       37      End of file (NEWGMULL)
      *       41      Null indicator for field MLGRPID
      *       42      Null indicator for field MLMENUCODE
      *
     FGMUL1     IF   E             DISK    INFSR(*PSSR)
     FGMUL2     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(T_GRMENUL:GMULF) PREFIX(X)
     FUPGMULPD  O    E             DISK    INFSR(*PSSR)
     FUPGMULL0  IF   E           K DISK    INFSR(*PSSR)                                       CPK025
     F                                     RENAME(UPGMULD0:ACTF)                              CPK025
     FNEWGMUL   IF   E           K DISK    INFSR(*PSSR)                         key on hyid, id,
     F                                     RENAME(T_GRMENUL:NEWGMULF)                  endid
     F                                     USROPN
     F                                     PREFIX(P_)
     FUPGMULMPD IF   E             DISK    INFSR(*PSSR)                         Moved T_GRMENUL recs
     F                                     USROPN
     FGMUL1KF   IF   E           K DISK    INFSR(*PSSR)                         Same as GMUL1 but
     F                                     RENAME(T_GRMENUL:GMUL1KD0) PREFIX(N_)  access by key
     F                                     USROPN
     F
      *
      /EJECT
     D LDA           E DS           256    EXTNAME(LDA)
      *
      * Local data area for database error details
      * *LOCK IN LDA immediately before and OUT LDA immediately
      * after each database error handling.
      *
      *                                     134 141 DBFILE
      *       Defines:                      142 170 DBKEY
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
 
     D KN_HYID         S                   LIKE(MLHYID)                         fld in NEWGMULKey
     D KN_ID           S                   LIKE(MLID)                           fld in NEWGMULKey
     D KN_ENDID        S                   LIKE(MLENDID)                        fld in NEWGMULKey
     D CMACTC          S                   LIKE(MLACTC)                                       CPK025
     D NotMove         S              1                                                       CPK025
      *
     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
      *
     C     COMP          KLIST
     C                   KFLD                    MLHYID
     C                   KFLD      *IN41         MLGRPID
     C                   KFLD                    MLLEVEL
     C                   KFLD                    MLPARENT
     C                   KFLD      *IN42         MLMENUCODE
      *
     C     NEWGMULKey    KLIST
     C                   KFLD                    KN_HYID
     C                   KFLD                    KN_ID
     C                   KFLD                    KN_ENDID
      *
     C     UPGMULL0Key   KLIST                                                                CPK025
     C                   KFLD                    CMACTC                                       CPK025
     C                   KFLD                    CMHYID                                       CPK025
     C                   KFLD      *IN41         CMGRPID                                      CPK025
     C                   KFLD                    CMLEVEL                                      CPK025
     C                   KFLD                    CMPARENT                                     CPK025
     C                   KFLD      *IN42         CMMENUCODE                                   CPK025
      *
     C                   IF        MODE   = 'I'
     C                   OPEN      NEWGMUL
     C                   ENDIF
      *
     C                   READ      GMUL1                                  20
      *
     C     *IN20         DOWEQ     '0'
      *
     C                   EVAL      *IN41  = %NULLIND(MLGRPID)
     C                   EVAL      *IN42  = %NULLIND(MLMENUCODE)
      *
     C     COMP          CHAIN     GMULF                              30
      *
      * If record not found then record has been deleted or added
      *  depending on mode.
      *
     C                   IF        (*IN30 = *ON)
     C
     C                   MOVE      MODE          MLACTC
      *
     C                   IF        MODE  = 'D'
     C                   EVAL      MLPOS        = *BLANK
     C                   EVAL      MLKHYID      = 0
     C                   EVAL      MLKGRPID     = 0
     C                   EVAL      MLKLEVEL     = 0
     C                   EVAL      MLKPARENT    = 0
     C                   EVAL      MLKMENUCOD   = *BLANK
     C                   WRITE     UPGMULD0
      *  Else 'Insert'
     C                   ELSE
     C                   EXSR      WrtInsert
     C                   ENDIF                                                  FI mode = 'D'
      *
     C                   ENDIF                                                  FI *IN30 = *ON
      *
      * Read next record
     C                   READ      GMUL1                                  20
      *
     C                   ENDDO                                                  OD *IN20 = *OFF
      *
     C                   IF        MODE   = 'I'
     C                   OPEN      GMUL1KF
     C                   OPEN      UPGMULMPD
     C                   EXSR      WrtMove
     C                   CLOSE     GMUL1KF
     C                   CLOSE     UPGMULMPD
     C                   ENDIF
      *
     C     ENDPGM        TAG
      *
     C                   IF        MODE   = 'I'
     C                   CLOSE     NEWGMUL
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * GetPosData  - Get positional data for the record to be        *
      *               inserted or moved.                              *
      *                                                               *
      * Called by:    WrtInsert                                       *
      *               WrtMove                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     GetPosData    BEGSR
      *
      * Chain to NEWGMUL file which is by order of Hierarchy Id, Link Id,
      * and End id.
     C     NEWGMULKey    CHAIN     NEWGMUL                            36        record not found
     C                   IF        *IN36 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Read previous record in NEWGMUL
     C                   READP     NEWGMUL                                35    beginning of file
      * If no previous record (ie, first record already), read next record
     C                   IF        *IN35        = *ON
     C     NEWGMULKey    CHAIN     NEWGMUL                            36        record not found
     C   36              EXSR      *PSSR
      *
     C                   READ      NEWGMUL                                37    end of file
      * If end of file error, error and end program.
     C                   IF        *IN37 = *ON
     C                   EXSR      *PSSR
     C                   ELSE
      * else (there is record after the insert record),
     C                   EVAL      MLPOS        = '*BEFORE'
     C                   ENDIF                                                  FI *IN37 = *ON
      *
     C                   ELSE                                                   else (*IN35 = *OFF)
      * else (there is record before the insert record),
     C                   EVAL      MLPOS        = '*AFTER '
     C                   ENDIF                                                  FI *IN35 = *ON
      *
      * set up the position details
     C                   EVAL      MLKHYID      = P_MLHYID
      *
     C                   IF        NOT %NULLIND(P_MLGRPID)
     C                   EVAL      MLKGRPID     = P_MLGRPID
     C                   ENDIF
     C                   EVAL      %NULLIND(MLKGRPID) = %NULLIND(P_MLGRPID)
      *
     C                   EVAL      MLKLEVEL     = P_MLLEVEL
     C                   EVAL      MLKPARENT    = P_MLPARENT
      *
     C                   IF        NOT %NULLIND(P_MLMENUCODE)
     C                   EVAL      MLKMENUCOD   = P_MLMENUCODE
     C                   ENDIF
     C                   EVAL      %NULLIND(MLKMENUCOD) = %NULLIND(P_MLMENUCODE)
      *
     C     GetPosDataE   ENDSR
      *
      *****************************************************************
      *                                                               *
      * WrtInsert     - Write actionfile with previous record details *
      *                 for Insert.                                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:     GetPosData                                         *
      *                                                               *
      *****************************************************************
      *
     C     WrtInsert     BEGSR
      *
      * Set up key list for accessing NEWGMUL file.
     C                   EVAL      KN_HYID   = MLHYID
     C                   EVAL      KN_ID     = MLID
     C                   EVAL      KN_ENDID  = MLENDID
      *
      * Get positional data for the record to be inserted.
     C                   EXSR      GetPosData
      *
     C                   WRITE     UPGMULD0
      *
     C     WrtInsertE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * WrtMove  - Read in UPGMULMPD and output move records to       *
      *            action file.                                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:     GetPosData                                         *
      *                                                               *
      *****************************************************************
      *
     C     WrtMove       BEGSR
      *
      * Read in Moved GRMENUL records
     C                   READ      UPGMULMPD                              20    EOF
      *
     C                   DOW       *IN20 = *OFF
      *
      * Set up key COMP to access GMUL2 and GMUL1KF for Link Id and End Id.
     C                   EVAL      MLHYID     =  CMHYID
      *
     C                   EVAL      MLGRPID    =  CMGRPID
     C                   IF        CMGRPID    =  0
     C                   EVAL      *IN41      = *ON
     C                   EVAL      %NULLIND(MLGRPID) = *ON
     C                   ELSE
     C                   EVAL      *IN41      = *OFF
     C                   EVAL      %NULLIND(MLGRPID) = *OFF
     C                   ENDIF                                                  FI CMGRPID    =  0
      *
     C                   EVAL      MLLEVEL    =  CMLEVEL
     C                   EVAL      MLPARENT   =  CMPARENT
      *
     C                   EVAL      MLMENUCODE =  CMMENUCODE
     C                   IF        CMMENUCODE =  *BLANK
     C                   EVAL      *IN42      = *ON
     C                   EVAL      %NULLIND(MLMENUCODE) = *ON
     C                   ELSE
     C                   EVAL      *IN42      = *OFF
     C                   EVAL      %NULLIND(MLMENUCODE) = *OFF
     C                   ENDIF                                                  FI CMMENUCODE=blank
      *
      * Chain to GMUL2 (in old lib) to get Link id and End id of the moved record
      * for report.
     C     COMP          CHAIN     GMUL2                              30        record not found
     C***30*             EXSR      *PSSR                                                      CPK025
     C   30              EXSR      ChkInsert                                                  CPK025
      *
      * If this is found to not be an actual move then read next record ...                   CPK025
     C                   IF        NotMove = 'Y'                                              CPK025
      * ... else if there is an error then report ...                                         CPK025
     C                   ELSE                                                                 CPK025
     C                   IF        NotMove = 'N'                                              CPK025
     C                   EVAL      MLPOS = *blanks                                            CPK025
     C                   EVAL      MLKHYID = 0                                                CPK025
     C                   EVAL      MLKGRPID = 0                                               CPK025
     C                   EVAL      MLKLEVEL = 0                                               CPK025
     C                   EVAL      MLKPARENT = 0                                              CPK025
     C                   EVAL      MLKMENUCOD  = '*ERROR'                                     CPK025
     C                   ELSE                                                                 CPK025
     C                   EVAL      MLID       = XMLID
     C                   EVAL      MLENDID    = XMLENDID
      *
      * Chain to GMUL1KF (T_GRMENUL file in new lib) to get Link id and End id of the
      * moved record for its positional data.
     C     COMP          CHAIN     GMUL1KF                            30        record not found
     C   30              EXSR      *PSSR
      *
      * Set up key list for accessing NEWGMUL file to get positional data.
     C                   EVAL      KN_HYID   = CMHYID
     C                   EVAL      KN_ID     = N_MLID
     C                   EVAL      KN_ENDID  = N_MLENDID
      *
      * Get positional data for the record to be inserted.
     C                   EXSR      GetPosData
      *
     C                   ENDIF                                                                CPK025
     C                   EVAL      MLACTC     =  'M'
     C                   WRITE     UPGMULD0
      *
     C                   ENDIF                                                                CPK025
      *
      * Read next Moved GRMENUL record
     C                   EVAL      NotMove = *blanks                                          CPK025
     C                   READ      UPGMULMPD                              20    EOF
     C                   ENDDO                                                  DOW *IN20 = *OFF
      *
     C     WrtMoveE      ENDSR
      *
      /EJECT
      *****************************************************************                       CPK025
      *                                                               *                       CPK025
      * ChkInsert - If 'moved' record not found on old file then      *                       CPK025
      *             check 'Inserted' records.  (CMPPFM seems to have  *                       CPK025
      *             a bug which mistakenly flags records as 'moved'.  *                       CPK025
      *                                                               *                       CPK025
      * Called by: WrtMove                                            *                       CPK025
      *                                                               *                       CPK025
      * Calls:                                                        *                       CPK025
      *                                                               *                       CPK025
      *****************************************************************                       CPK025
      *                                                                                       CPK025
     C     ChkInsert     BEGSR                                                                CPK025
      *                                                                                       CPK025
      * Set up key for CHAIN.                                                                 CPK025
     C                   EVAL      CMACTC = 'I'                                               CPK025
      *                                                                                       CPK025
     C     UPGMULL0Key   CHAIN     UPGMULL0                                                   CPK025
      *                                                                                       CPK025
     C                   IF        %FOUND                                                     CPK025
     C                   EVAL      NotMove = 'Y'                                              CPK025
     C                   ELSE                                                                 CPK025
     C                   EVAL      NotMove = 'N'                                              CPK025
     C                   ENDIF                                                                CPK025
      *                                                                                       CPK025
     C     ChkInsertE    ENDSR                                                                CPK025
      *                                                                                       CPK025
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
