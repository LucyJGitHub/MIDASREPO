     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Update System ID for MSSENDPD')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP8006 - Update System ID on MSSENDPD                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01.03 ----------------------------------------*
      *  Last Amend No. CUP020 *CREATE     Date 08Jan03               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CUP020 - Update System IDs when copying libraries.           *
      *                                                               *
      *****************************************************************
      * ID F  C  H  L    FUNCTION OF INDICATORS
      *
      *       20      End of file
      *       69      Read, write, update or delete fail
      *
     FMSSENDPD  UF   E             DISK    INFSR(*PSSR)
      *
      /EJECT
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      * Parameters
     C     *ENTRY        PLIST
     C                   PARM                    From_ID           2
     C                   PARM                    To_ID             2
      *
     C                   Z-ADD     0             Pos_found         2 0
      *
     C     1             SETLL     MSSENDPD
      *
     C                   READ      MSSENDPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      *
     C     From_ID       SCAN      FTIN          Pos_found
     C     Pos_found     IFNE      0
     C                   EVAL      %SUBST(FTIN:Pos_found:2) = To_ID
     C                   UPDATE    MSSENDF                              69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   Z-ADD     0             Pos_found
      *
     C                   READ      MSSENDPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *
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
      ********************************************************************
      *
     C                   ENDSR
      *
      ********************************************************************
