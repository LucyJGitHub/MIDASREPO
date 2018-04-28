     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM CAP210 Migration Utility for STRANF File')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SMU000216 - CAP210 Migration Utility for STRANF File         *
      *                                                               *
      *  Function:  This program provides transaction number to       *
      *             previous STRANF records                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD025682           Date 19Aug14               *
      *  Prev Amend No. AR1096788 *CREATE  Date 18Mar13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD025682 - STRANH needs updating else COB fails.             *
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
                                                                                            MD025682
     FSTRANH    UF   E             DISK    INFSR(*PSSR)                                     MD025682
     F                                     PREFIX(H)                                        MD025682
      ** Midas DL STRANH Transactions Header                                                MD025682
 
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
 
      ** Read STRANH trailer                                                                MD025682
                                                                                            MD025682
     C                   READ      STRANH                                 60                MD025682
                                                                                            MD025682
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
 
     C                   IF        FLTYLC <> *BLANKS                                        MD025682
                                                                                            MD025682
     ** Increment trailer                                                                   MD025682
                                                                                            MD025682
     C                   SELECT                                                             MD025682
                                                                                            MD025682
     ** If accrued adj. increase                                                            MD025682
                                                                                            MD025682
     C                   WHEN      SIGN = '+'                                               MD025682
     C                   EVAL      HNOID = HNOID + 1                                        MD025682
0213 C                   Z-ADD     HHDIW         ZZTOTI                                     MD025682
0214 C                   Z-ADD     HHDID         ZZTOTD                                     MD025682
                                                                                            MD025682
     ** Adjust trailer for increase                                                         MD025682
                                                                                            MD025682
     C                   MOVE      MAAM          ZZAMT                                      MD025682
0217 C                   EXSR      SRGLZADD                                                 MD025682
     C                   Z-ADD     ZZTOTI        HHDIW                                      MD025682
     C                   Z-ADD     ZZTOTD        HHDID                                      MD025682
                                                                                            MD025682
     ** If accrued adj. decrease                                                            MD025682
                                                                                            MD025682
     C                   WHEN      SIGN = '-'                                               MD025682
     C                   EVAL      HNODD = HNODD + 1                                        MD025682
0213 C                   Z-ADD     HHDDW         ZZTOTI                                     MD025682
0214 C                   Z-ADD     HHDDD         ZZTOTD                                     MD025682
                                                                                            MD025682
     ** Adjust trailer for decrease                                                         MD025682
                                                                                            MD025682
     C                   MOVE      MAAM          ZZAMT                                      MD025682
0217 C                   EXSR      SRGLZADD                                                 MD025682
     C                   Z-ADD     ZZTOTI        HHDDW                                      MD025682
     C                   Z-ADD     ZZTOTD        HHDDD                                      MD025682
     C                   ENDSL                                                              MD025682
     C                   ENDIF                                                              MD025682
                                                                                            MD025682
     ** Read next record
 
     C                   READ      STRANFL2                               50
     C
     C                   ENDDO
 
     ** Update STRANH trailer                                                               MD025682
                                                                                            MD025682
     C                   UPDATE    STRANHF                                                  MD025682
                                                                                            MD025682
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
      *****************************************************************                     MD025682
      *                                                               *                     MD025682
      *  SRGLZADD - Add an amount (ZZAMT) to the total (ZZTOTI,       *                     MD025682
      *             ZZTOTD)                                           *                     MD025682
      *                                                               *                     MD025682
      *****************************************************************                     MD025682
      *                                                                                     MD025682
     C     SRGLZADD      BEGSR                                                              MD025682
      *                                                                                     MD025682
     C                   Z-ADD     ZZAMT         ZZAMT            15 3    91                MD025682
     C                   IF        *IN91 = *ON                                              MD025682
     C                   GOTO      EGLZADD                                                  MD025682
     C                   ENDIF                                                              MD025682
      *                                                                                     MD025682
      ** Split ZZAMT into integer and decimal fields.                                       MD025682
      *                                                                                     MD025682
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0                      MD025682
     C                   MOVE      ZZAMT         ZZAMTD            3 0                      MD025682
      *                                                                                     MD025682
      ** Both ZZAMTI and ZZAMTD contain a 'SIGN' zone now.                                  MD025682
      *                                                                                     MD025682
     C                   EXSR      SRGLZSUM                                                 MD025682
      *                                                                                     MD025682
     C     EGLZADD       ENDSR                                                              MD025682
      *                                                                                     MD025682
      *****************************************************************                     MD025682
      /EJECT                                                                                MD025682
      *****************************************************************                     MD025682
      *                                                               *                     MD025682
      *  SRGLZSUM - Carry out addition                                *                     MD025682
      *                                                               *                     MD025682
      *****************************************************************                     MD025682
      *                                                                                     MD025682
     C     SRGLZSUM      BEGSR                                                              MD025682
      *                                                                                     MD025682
     C                   Z-ADD     ZZTOTI        ZZTOTI           15 0                      MD025682
     C                   Z-ADD     ZZTOTD        ZZTOTD            3 0                      MD025682
     C                   SETOFF                                       919293                MD025682
     C                   SETOFF                                       949599                MD025682
      *                                                                                     MD025682
      ** Determine sign of ZZAMTI/D (92 if negative).                                       MD025682
      *                                                                                     MD025682
     C     ZZAMTI        COMP      0                                    9293                MD025682
     C   93ZZAMTD        COMP      0                                    9293                MD025682
     C   93              GOTO      ZZSEND                                                   MD025682
      *                                                                                     MD025682
      ** Determine sign of ZZTOTI/D (91 if negative).                                       MD025682
      *                                                                                     MD025682
     C     ZZTOTI        COMP      0                                    9193                MD025682
     C   93ZZTOTD        COMP      0                                    9193                MD025682
      *                                                                                     MD025682
      **  If ZZTOTAL is zero, return ZZAmount.                                              MD025682
      *                                                                                     MD025682
     C   93              Z-ADD     ZZAMTI        ZZTOTI                                     MD025682
     C   93              Z-ADD     ZZAMTD        ZZTOTD                                     MD025682
     C   93              GOTO      ZZSEND                                                   MD025682
      *                                                                                     MD025682
      ** If signs differ, bypass overflow checks.                                           MD025682
      *                                                                                     MD025682
     C   91                                                                                 MD025682
     CANN92                                                                                 MD025682
     CORN91                                                                                 MD025682
     CAN 92              GOTO      ZZOFPS                                                   MD025682
      *                                                                                     MD025682
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0                      MD025682
     C     ZZWK2         COMP      999                                93                    MD025682
     C  N93ZZWK2         COMP      -999                                 93                  MD025682
      *                                                                                     MD025682
     C   93                                                                                 MD025682
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0                      MD025682
     C   93                                                                                 MD025682
     CAN 92ZZAMTI        SUB       1             ZZWK3                                      MD025682
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3                                      MD025682
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3                                      MD025682
      *                                                                                     MD025682
      ** If the modulus of ZZWK3 is LT mod. ZZTOTI, then O/F has                            MD025682
      ** occurred.                                                                          MD025682
      *                                                                                     MD025682
     C  N92ZZWK3         COMP      ZZTOTI                               99                  MD025682
     C   92ZZWK3         COMP      ZZTOTI                             99                    MD025682
     C  N99              Z-ADD     ZZWK2         ZZTOTD                                     MD025682
     C  N99              Z-ADD     ZZWK3         ZZTOTI                                     MD025682
      *                                                                                     MD025682
      ** If O/F, zeroise ZZAMT, indicator 99 set and ZZTOT                                  MD025682
      ** fields left intact.                                                                MD025682
      *                                                                                     MD025682
     C   99              Z-ADD     0             ZZAMT            15 3                      MD025682
     C                   GOTO      ZZSEND                                                   MD025682
      *                                                                                     MD025682
      ** The 'SIGNS' are different.                                                         MD025682
      *                                                                                     MD025682
     C     ZZOFPS        TAG                                                                MD025682
      *                                                                                     MD025682
      ** If ZZAMT was negative, make it positive to compare                                 MD025682
      ** with ZZTOT.                                                                        MD025682
      *                                                                                     MD025682
     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0                      MD025682
     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0                      MD025682
      *                                                                                     MD025682
      ** If ZZTOT was negative, make it positive to compare                                 MD025682
      ** with ZZAMT.                                                                        MD025682
      *                                                                                     MD025682
     C   91              Z-SUB     ZZTOTI        ZZTOTI                                     MD025682
     C   91              Z-SUB     ZZTOTD        ZZTOTD                                     MD025682
      *                                                                                     MD025682
      ** Both ZZAMT and ZZTOT are now positive.                                             MD025682
      *                                                                                     MD025682
     C     ZZTOTI        COMP      ZZAMTI                             93  95                MD025682
     C   95ZZTOTD        COMP      ZZAMTD                             93  95                MD025682
      *                                                                                     MD025682
      ** If ZZTOT EQ ZZAMT, return zero.                                                    MD025682
      *                                                                                     MD025682
     C   95              Z-ADD     0             ZZTOTI                                     MD025682
     C   95              Z-ADD     0             ZZTOTD                                     MD025682
     C   95              GOTO      ZZSEND                                                   MD025682
      *                                                                                     MD025682
      ** If ZZTOT GT ZZAMT.                                                                 MD025682
      *                                                                                     MD025682
     C   93ZZAMTD        COMP      ZZTOTD                             94                    MD025682
     C   93                                                                                 MD025682
     CAN 94ZZTOTI        SUB       1             ZZTOTI                                     MD025682
     C   93                                                                                 MD025682
     CAN 94ZZTOTD        ADD       1000          ZZWK2                                      MD025682
     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI                                     MD025682
     C   93                                                                                 MD025682
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD                                     MD025682
     C   93                                                                                 MD025682
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD                                     MD025682
      *                                                                                     MD025682
      ** If ZZAMT GT ZZTOT.                                                                 MD025682
      *                                                                                     MD025682
     C  N93ZZTOTD        COMP      ZZAMTD                             94                    MD025682
     C  N93                                                                                 MD025682
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0                      MD025682
     C  N93                                                                                 MD025682
     CAN 94ZZAMTD        ADD       1000          ZZWK2                                      MD025682
     C  N93                                                                                 MD025682
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI                                     MD025682
     C  N93                                                                                 MD025682
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI                                     MD025682
     C  N93                                                                                 MD025682
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD                                     MD025682
     C  N93                                                                                 MD025682
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD                                     MD025682
      *                                                                                     MD025682
      ** Reverse sign of ZZTOT if larger I/P fields were negative.                          MD025682
      *                                                                                     MD025682
     C                   SETOFF                                       94                    MD025682
     C   93                                                                                 MD025682
     CAN 91                                                                                 MD025682
     CORN93                                                                                 MD025682
     CAN 92              SETON                                        94                    MD025682
     C   94              Z-SUB     ZZTOTI        ZZTOTI                                     MD025682
     C   94              Z-SUB     ZZTOTD        ZZTOTD                                     MD025682
      *                                                                                     MD025682
      ** Restore sign of ZZAMTI and ZZAMTD if it was reversed.                              MD025682
      *                                                                                     MD025682
     C   92              Z-SUB     ZZAMTI        ZZAMTI                                     MD025682
     C   92              Z-SUB     ZZAMTD        ZZAMTD                                     MD025682
     C     ZZSEND        TAG                                                                MD025682
      *                                                                                     MD025682
      ** If ZZTOTD is zero and ZZTOTI is negative, set up ZZNEGD.                           MD025682
      *                                                                                     MD025682
     C                   SETOFF                                       96                    MD025682
     C     ZZTOTD        COMP      0                                      91                MD025682
     C   91ZZTOTI        COMP      0                                    96                  MD025682
     C   96              MOVE      '.000-'       ZZNEGD            5                        MD025682
      *                                                                                     MD025682
     C                   ENDSR                                                              MD025682
      *                                                                                     MD025682
      *****************************************************************                     MD025682
      /EJECT                                                                                MD025682
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
