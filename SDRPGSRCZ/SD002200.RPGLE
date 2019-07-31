     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Initialisation program for CAP210')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD002200 - Midas SD Initialisation program for CAP210        *
      *                                                               *
      *  Function:  This program provides transaction number to       *
      *             previous STRANF records                           *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1096788 *CREATE  Date 18Mar13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1096788 - DLAA details should be written in core STRANF    *
      *              file instead of the new DLSTRANFPD file          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7 - Database Error                                        *
      *    U8 - Database Error                                        *
      *    LR - Last record found                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSTRANFL2  UF A E           K DISK    INFSR(*PSSR)
      ** Midas DL STRANF Transactions Update
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
     ** First DS for access programs, Short Data Structure
 
     D PSDS           SDS
     D PSProcName        *PROC
     D PSJobName             244    253
     D PSUser                254    263
     D PSJobNo               264    269S 0
 
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
     D WRun            S              1A
     D PTimestamp      S               Z
     D PRtcd           S              7A
     D POptn           S              7A
     D DNATN           DS             6
     D  FNATN                  1      6  0
 
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Read STRANF records
 
     C                   READ      STRANFL2                               50
 
     C                   DOW       *IN50 = *OFF
     C                   IF        FLTRNN = *BLANKS
 
      ** Get next available transaction number and update Transaction
      ** Number field (initialise other CAP210 fields to 0 and blanks)
 
     C                   EXSR      SRGetNxt
     C                   MOVE      FNATN         FLTRNN
 
     C                   EVAL      FLLCD  = *ZEROS
     C                   EVAL      FLTYLC = *BLANKS
     C                   EVAL      FLUSGN = *BLANKS
     C                   EVAL      FLFRNT = *BLANKS
     C                   EVAL      FLAFRT = *BLANKS
     C                   EVAL      FLREPA = *BLANKS
     C                   EVAL      FLUSER = *BLANKS
     C                   CLEAR                   FLTMST
 
     C                   UPDATE    STRANFF
     C                   ENDIF
 
     ** Read next record
 
     C                   READ      STRANFL2                               50
     C
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetNxt - Get Next Transaction Number                       *
      *                                                               *
      *****************************************************************
      *
     C     SRGetNxt      BEGSR
 
     C     *DTAARA       DEFINE    AAJTN         DNATN
     C     *LOCK         IN        DNATN
     C                   MOVE      FNATN         ZZWK05            6 0
     C                   ADD       1             ZZWK05
     C                   MOVE      ZZWK05        FNATN
     C                   OUT       DNATN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically if a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
 
     C                   EVAL      WRun = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
