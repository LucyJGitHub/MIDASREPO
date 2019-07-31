     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIA*  OVRDBF FILE(OLD_FFD) TOFILE(QADSPFFD)                        *
/*XBIB*  OVRDBF FILE(NEW_FFD) TOFILE(QADSPFFD)                        *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Check if field is present')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP0891 - Check if field exists on a file                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CUP028 *MOVED      Date 08Sep04               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 CSC011 *CREATE     Date 13Sep02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP028 - Moved from zone to global.                          *
      *  CSC011 - 24x7 availability.                                  *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       69      Read, write or chain fail
      *
     FOLD_FFD   IF   E             DISK    INFSR(*PSSR)
     FNEW_FFD   IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(QWHDRFFD:FFDF)
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
     C     *ENTRY        PLIST
     C                   PARM                    FIELD            10
     C                   PARM                    STATUS            5
      *
     C                   MOVEL     '*NO '        Match_old         4
     C                   MOVEL     '*NO '        Match_new         4
      *
      * Read 'old' file
     C                   READ      QWHDRFFD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOUEQ     '1'
     C     Match_old     OREQ      '*YES'
      *
     C     WHFLDI        IFEQ      FIELD
     C                   MOVEL     '*YES'        Match_old
     C                   ENDIF
      *
     C                   READ      QWHDRFFD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Read 'new' file
     C                   READ      FFDF                                 6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOUEQ     '1'
     C     Match_new     OREQ      '*YES'
      *
     C     WHFLDI        IFEQ      FIELD
     C                   MOVEL     '*YES'        Match_new
     C                   ENDIF
      *
     C                   READ      FFDF                                 6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Set status
     C     Match_old     IFEQ      '*YES'
     C     Match_new     ANDEQ     '*YES'
     C                   MOVEL     '*BOTH'       STATUS
     C                   ENDIF
      *
     C     Match_old     IFEQ      '*YES'
     C     Match_new     ANDEQ     '*NO '
     C                   MOVEL     '*OLD '       STATUS
     C                   ENDIF
      *
     C     Match_old     IFEQ      '*NO '
     C     Match_new     ANDEQ     '*YES'
     C                   MOVEL     '*NEW '       STATUS
     C                   ENDIF
      *
     C     Match_old     IFEQ      '*NO '
     C     Match_new     ANDEQ     '*NO '
     C                   MOVEL     '*NONE'       STATUS
     C                   ENDIF
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
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
