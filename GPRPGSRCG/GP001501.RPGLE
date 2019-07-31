     H DEBUG ALWNULL(*USRCTL)
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Cancel T_MLRSVTRN for A/C Balance Check')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  GP001501 - Midas RE Cancel T_MLRSVTRN for A/C Balance Check  *
      *                                                               *
      *  Function:  This program will cancel reservation data         *
      *             from T_MLRSVTRN                                   *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD020087           Date 30Sep13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27356           Date 31Mar10               *
      *                 CAP205  *CREATE    Date 15Feb10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD020087 - ABC Issue on Amendments on Several Write on       *
      *             Authorise APIs                                    *
      *  BUG27356- Program REC001501 ended abnormally                 *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SrCancReserv - Update T_MLRSVTRN reservation of field ABCUPD  *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGPWTRAPL1 IF   E           K DISK    INFSR(*PSSR)
     FGPPDCRL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(A_:2)                                     MD020087
     FGPMLRSL0  UF   E           K DISK    INFSR(*PSSR)
     FGPPDCRL1  IF   E           K DISK    INFSR(*PSSR)                                     MD020087
     F                                     RENAME(T_GPPDCRSV:X_GPPDCRSV)                    MD020087
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY GPCPYSRCG,PSDS
 
      ** Program Status Data Structure
     D LDA             DS           256
      ** Local data area for database error details
 
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBTXT                184    256
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRun            S              1A
     D CommitID        S             10S 0
     D WRSID           S             15  0 INZ(*ZEROS)
     D Returncode      S              6A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Define LDA
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'GP001051'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBASE = 0
     C                   EVAL      DBTXT = *BLANKS
     C                   OUT       LDA
 
     C                   EXSR      SrCancReserv
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCancReserv - Update T_MLRSVTRN reservation of field ABCUPD  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrCancReserv  BEGSR
 
     C     CommitID      SETLL     GPWTRAPL1
     C     CommitID      READE     GPWTRAPL1
     C                   DOW       NOT %EOF(GPWTRAPL1)
     C                   IF        T_RSID <> WRSID
 
     C*****T_RSID        SETLL     GPPDCRL0                                                 MD020087
     C*****T_RSID        READE     GPPDCRL0                                                 MD020087
     C**********         DOW       NOT %EOF(GPPDCRL0)                                       MD020087
                                                                                            MD020087
      ** Get the Associated PDC Id (A_APID) from GPPDCRL0 then loop                         MD020087
      ** in GPPDCRL1 to cancel all reservations having the same A_APID                      MD020087
                                                                                            MD020087
     C     T_RSID        CHAIN     T_GPPDCRSV                                               MD020087
                                                                                            MD020087
     C                   IF        %FOUND (GPPDCRL0)                                        MD020087
     C     A_APID        SETLL     GPPDCRL1                                                 MD020087
     C     A_APID        READE     GPPDCRL1                                                 MD020087
                                                                                            MD020087
     C                   DOW       NOT %EOF(GPPDCRL1)                                       MD020087
 
      ** Ignore records with zero reservation ID
 
     C                   IF        PRRTID <> 0
     C     PRRTID        CHAIN     T_MLRSVTRN
 
     C                   IF        %FOUND (GPMLRSL0)
 
      ** Update Reservation Flag if value = 'N'
 
     C                   IF        ABCUPD = 'N'
     C                   EVAL      ABCUPD = 'Y'
     C                   UPDATE    T_MLRSVTRN
     C                   ENDIF
 
      ** Database error if record is not found
 
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'T_MLRSVTRN'
     C                   EVAL      DBASE = 1
     C                   MOVE      PRRTID        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
     C*****T_RSID        READE     GPPDCRL0                                                 MD020087
     C     A_APID        READE     GPPDCRL1                                                 MD020087
     C                   ENDDO
     C                   ENDIF                                                              MD020087
 
     C                   EVAL      WRSID = T_RSID
     C                   ENDIF
     C     CommitID      READE     GPWTRAPL1
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    CommitID
     C                   PARM                    Returncode
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
 
      ** Set ReturnCode to '*ERROR'
 
     C                   EVAL      ReturnCode = '*ERROR'
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP                                                               BUG27356
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
