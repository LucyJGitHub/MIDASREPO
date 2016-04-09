     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Universal Transactions Updater')              *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOUTUPDTR - Universal Transactions Updater                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD032884           Date 09Jun15               *
      *  Prev Amend No. AR1082904A         Date 09Feb14               *
      *                 AR1082904          Date 09Feb14               *
      *                 AR1031820          Date 24Feb15               *
      *                 AR1092236          Date 30Sep13               *
      *                 CLE134             Date 01Aug12               *
      *                 BUG27928           Date 26Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 15Feb10               *
      *                 261009             Date 06Jul09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG5221            Date 14Dec04               *
      *                 CGP009             Date 22Dec04               *
      *                 BUG3860            Date 11Aug04               *
      *                 BG3512             Date 29Jul04               *
      *                 BUG3391            Date 24Jun04               *
      *                 BUG3368            Date 16Jun04               *
      *                 CLE024             Date 20Oct03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD032884 - Performance enhancement for GOCXCLTS. Recompiled  *
      *             due to change in GOCASHPD and GOPOSNPD.           *
      *  AR1082904 - Credit Lines - Performance Issues - Critical     *
      *            - Enhance recovery process of messages sent to     *
      *              ML, CL and ABC data queues.                      *
      *            - Messages that are COB Generated will no longer   *
      *              ne sent to the data queue CLECALCMGR if Collate- *
      *              ralised lending or Credit Lines are switched     *
      *              ON.  This minimizes data being processed.        *
      *              (Child: AR1084389)                               *
      *  AR1082904A - Credit Lines - Performance Issues - Critical    *
      *             - Messages that are COB Generated should not be   *
      *               processed if CAP0205 is swithced on.            *
      *              (Child: AR1084389A)                              *
      *  AR1031820 - Also populate CLECALCMGR Dtaq if CLE025 is ON.   *
      *              (Child: AR1034778)                               *
      *            - Applied for MD-29803.                            *
      *  AR1092236 - ABC - Long delay or no updates. Do not clear     *
      *              GPUTUxxxN DTAQ on program start if next message  *
      *              to process is a STOP. (Child: AR1092237)         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  BUG27928 - Apply fix 259315                                  *
      *  259315 - PROCESS_XML subroutine should be executed if same   *
      *           zone                                                *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  261009 - Applied core fix 254264.                            *
      *  254264 - Check CGP003 in GPSARDPD before processing          *
      *           SND_MSG_ML.                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG5221 - Recompile over changed file GPCASPD and GOCASHPD   *
      *  CGP009 - Local Zone Time Difference (Recompile)              *
      *  BUG3860 - (recompile)                                        *
      *  BG3512 - Extract of SE Trades was missing                    *
      *  BUG3391 - Manual transactions do not update ML or CL exposure*
      *  BUG3368- Manual transactions do not update ML or CL exposure *
      *  CLE024 - Collateralised Lending                              *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

     FGPUTCIL1  UF   E           K DISK    INFSR(*PSSR) COMMIT

     FGPWTRAPL1 IF   E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(GOTRAPD0:GPWTRAPD0)

     FGOPOSNL0  IF   E           K DISK    INFSR(*PSSR) USROPN
     FGOCASHL0  IF   E           K DISK    INFSR(*PSSR) USROPN

     FGPUTXFL1  UF   E           K DISK    INFSR(*PSSR) COMMIT
     FGPUTXGL1  UF   E           K DISK    INFSR(*PSSR) COMMIT
     FGPUTXSL1  UF   E           K DISK    INFSR(*PSSR) COMMIT
     FGPUTXTL1  UF   E           K DISK    INFSR(*PSSR) COMMIT

     FGPTRAPL0  UF   E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(GOTRAPD0:GPTRAPD0)
     FGPPOSNL0  UF A E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(GOPOSND0:GPPOSND0)
     FGPCASHL0  UF A E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(GOCASHD0:GPCASHD0)
     FGPPOSTL2  UF A E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(GOPOSTD0:GPPOSTD0)
     FGOLSTUL0  UF   E           K DISK    INFSR(*PSSR)                                    AR1082904

     FGPULOGPD  O  A E             DISK    INFSR(*PSSR)

     F*GPTRAPL1* IF   E           K DISK    INFSR(*PSSR) COMMIT                       CLE024 BUG3391
     F**********                            RENAME(GOTRAPD0:GPTRAPD1)                 CLE024 BUG3391
                                                                                              CLE024
     FGPZONEL0  IF   E           K DISK    INFSR(*PSSR)                                       CLE024

     D/COPY ZACPYSRC,PSDS


     D ML_MSG          S              1    DIM(344) CTDATA PERRCD(86)
     D XMLArray        S             70    DIM(5)  CTDATA PERRCD(1)                           CLE024
                                                                                              CLE024
     D CLE024          S              1                                                       CLE024
     D PSARD           S              6                                                       CLE024
     D PRTCD           S              7                                                       CLE024
     D POPTN           S              7                                                       CLE024
     D PDtqDta         S            500                                                       CLE024
     D WCICCID         S             10                                                       CLE024
     D Wi              S              3P 0                                                    CLE024
     D WInitial        S             70                                                       CLE024
     D CGP003          S              1                                                       254264
     D CLE025          S              1                                                    AR1031820
     D CAP205          S              1                                                       CAP205
     D FirstCycle      S              1                                                    AR1082904
                                                                                           AR1082904
     D CID_LSTU        S             10  0                                                 AR1082904
     D CID_LSTU_ML     S             10  0                                                 AR1082904
     D CID_LSTU_CL     S             10  0                                                 AR1082904
     D CID_LSTU_ABC    S             10  0                                                 AR1082904
                                                                                           AR1082904
     D Key_LSTU        S             20                                                    AR1082904
     D Key_LSTU_ML     C                   'MLCommitId          '                          AR1082904
     D Key_LSTU_CL     C                   'CLCommitId          '                          AR1082904
     D Key_LSTU_ABC    C                   'ABCCommitId         '                          AR1082904
                                                                                              CAP205
     D ABCDATA         DS                                                                     CAP205
      ** Event Type                                                                           CAP205
     D    WEventType           1     20                                                       CAP205
      ** Event Detail                                                                         CAP205
     D    WDetail             22     31                                                       CAP205


     C     *ENTRY        PLIST
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#DTAQ           10


      * Infinite loop
      * (Program ends when asked to 'stop')

     C     *INLR         DOUEQ     *ON


      * Read the next commitment id

     C     GPUTCIK       SETLL     GPUTCID0
     C     GPUTCIK       READE     GPUTCID0                               99
     C     *IN99         DOWEQ     *OFF

     C                   MOVE      'N'           COB_Generated     1

      * Read all TRAP records with the commitment id just accessed

     C     CICCID        SETLL     GPWTRAPD0
     C     CICCID        READE     GPWTRAPD0                              99
     C     *IN99         DOWEQ     *OFF

     C     T_GCOB        IFEQ      'Y'
     C                   MOVE      'Y'           COB_Generated
     C                   ENDIF

      * If action is delete, delete the TRAP record

     C     T_ACTN        IFEQ      'D'
     C                   EXSR      DELETE_TRAP
     C                   ENDIF
                                                                                BUG3368
     C     T_MOD         IFNE      'MT'                                         BUG3368
     C     T_ACTN        OREQ      'D'                                          BUG3368

      * Delete positions, cashflows and postings

     C                   EXSR      DELETE_POSN
     C                   EXSR      DELETE_CASH
     C     T_MOD         IFEQ      'GL'
     C                   EXSR      DELETE_POST
     C                   ENDIF
     C                   ENDIF                                                  BUG3368

      * If TRAP record generated in COB
      *    Recover positions and cashflows (open files beforehand)
      * Else
      *    Extract positions, cashflows and postings

     C     T_ACTN        IFNE      'D'
     C*****T_MOD         ANDNE     'MT'                                             BUG3368  BUG3391
     C     T_MOD         IFEQ      'MT'                                                      BUG3391
     C                   EXSR      UPDATE_TRAP                                               BUG3391
     C                   ELSE                                                                BUG3391
     C     T_GCOB        IFEQ      'Y'
     C     T_MOD         ANDNE     'GL'
     C     ZFiles_Open   IFEQ      'N'
     C                   EXSR      OPENZFILES
     C                   ENDIF
     C                   EXSR      UPDATE_TRAP
     C                   EXSR      RECOVER_POSN
     C                   EXSR      RECOVER_CASH
     C                   ELSE
     C                   EXSR      EXTRACT_PCP
     C                   ENDIF
     C                   ENDIF                                                               BUG3391
     C                   ENDIF

     C     CICCID        READE     GPWTRAPD0                              99
     C                   ENDDO

      * If not COB generated
      *  Update management limits indicator to 'ready to update'
      *  Send message to Management Limits

     C     COB_Generated IFNE      'Y'
     C     CGP003        ANDEQ     'Y'                                                        254264
     C                   MOVEL     'R'           CIEXML
     C                   IF        FirstCycle = 'N' OR                                     AR1082904
     C                             (FirstCycle = 'Y' AND                                   AR1082904
     C                              CID_LSTU_ML <> CICCID)                                 AR1082904
     C                   EXSR      SND_MSG_ML
     C                   ENDIF                                                             AR1082904
     C                   ENDIF

     C                   MOVEL     'N'           CIUUNV
                                                                                              CLE024
      ** Set up Update Exposure for Collateralised Lending if installed.                      CLE024
                                                                                              CLE024
     C                   IF        CLE024 = 'Y'                                               CLE024
     C                             AND  COB_Generated <> 'Y'                               AR1082904
     C                   EVAL      CIUEXC = 'Y'                                               CLE024
     C                   ENDIF                                                                CLE024

     C                   EXCEPT

     C**********         COMMIT                                                            AR1082904
                                                                                              CLE024
      ** Generate xml data and send to data queue if Collateralised                           CLE024
      ** Lending is installed.                                                                CLE024
                                                                                              CLE024
     C                   IF        CLE024 = 'Y'                                               CLE024
     C                             AND  COB_Generated <> 'Y'                               AR1082904
     C                             OR CLE025 = 'Y'                                         AR1031820
                                                                                              CLE024
      ***Check*for*the*commitment*ID*on*GPTRAPPD************************              CLE024 BUG3391
      ******************************************************************              CLE024 BUG3391
     C*****CICCID        CHAIN     GPTRAPL1                                           CLE024 BUG3391
     C*******************IF        %FOUND(GPTRAPL1)                                           CLE024
     C                   IF        I#ZONE = T_ZONE                                            259315
     C                   IF        FirstCycle = 'N' OR                                     AR1082904
     C                             (FirstCycle = 'Y' AND                                   AR1082904
     C                              CID_LSTU_CL <> CICCID)                                 AR1082904
     C                   EXSR      PROCESS_XML                                                CLE024
     C                   ENDIF                                                             AR1082904
     C                   ENDIF                                                                259315
     C*******************ENDIF                                                                CLE024
                                                                                              CLE024
     C                   ENDIF                                                                CLE024
                                                                                              CAP205
     C                   IF        CAP205 = 'Y'                                               CAP205
     C                             AND  COB_Generated <> 'Y'                              AR1082904A
     C                   IF        FirstCycle = 'N' OR                                     AR1082904
     C                             (FirstCycle = 'Y' AND                                   AR1082904
     C                              CID_LSTU_ABC <> CICCID)                                AR1082904
     C                   EXSR      SndABCData                                                 CAP205
     C                   ENDIF                                                             AR1082904
     C                   ENDIF                                                                CAP205
                                                                                           AR1082904
     C                   COMMIT                                                            AR1082904
                                                                                           AR1082904
     C                   IF        FirstCycle = 'Y'                                        AR1082904
     C                   EVAL      FirstCycle = 'N'                                        AR1082904
     C                   ENDIF                                                             AR1082904

     C     GPUTCIK       READE     GPUTCID0                               99
     C                   ENDDO

      * Wait for a message

     C                   CALL      'QRCVDTAQ'
     C                   PARM      I#DTAQ        DtqNam           10
     C                   PARM      '*LIBL     '  DtqLib           10
     C                   PARM      10            DtqLen            5 0
     C                   PARM      *BLANK        DtqDta           10
     C                   PARM      -1            DtqWait           5 0

     C                   SELECT

      * If 'OPENZ' received, then open zone files

     C     DtqDta        WHENEQ    'OPENZ'
     C     ZFiles_Open   IFEQ      'N'
     C                   EXSR      OPENZFILES
     C                   ENDIF

      * If 'CLOSZ' received, then close zone files

     C     DtqDta        WHENEQ    'CLOSZ'
     C     ZFiles_Open   IFEQ      'Y'
     C                   EXSR      CLOSZFILES
     C                   ENDIF

      * If 'STOP' received, then end

     C     DtqDta        WHENEQ    'STOP'

      * Write to the log file
     C                   EVAL      UTMSG = 'Updater ' + JobNameSuffix
     C                                   + ' has ENDED'
     C                   EXSR      WRITE_LOG
     C                   SETON                                        LR
     C                   RETURN

     C                   ENDSL

     C                   ENDDO
      ********************************************************************                    CLE024
      /SPACE 5                                                                                CLE024
      ********************************************************************                    CLE024
      * Process XML                                                                           CLE024
      ********************************************************************                    CLE024
     C     PROCESS_XML   BEGSR                                                                CLE024
                                                                                              CLE024
      ** Set up xml data                                                                      CLE024
                                                                                              CLE024
     C                   MOVE      CICCID        WCICCID                                      CLE024
     C                   EVAL      XMLArray(4) = WInitial                                     CLE024
     C                   EVAL      XMLArray(4) = %TRIM(XMLArray(4)) +                         CLE024
     C                                           WCICCID                                      CLE024
                                                                                              CLE024
     C                   EVAL      PDtqDta = *BLANKS                                          CLE024
     C                   EVAL      Wi = 1                                                     CLE024
     C                   DOW       Wi < 6                                                     CLE024
     C                   EVAL      PDtqDta = %TRIM(PDtqDta) +                                 CLE024
     C                                       %TRIM(XMLArray(Wi))                              CLE024
     C                   EVAL      Wi = Wi + 1                                                CLE024
     C                   ENDDO                                                                CLE024
                                                                                              CLE024
     C     T_ZONE        CHAIN     GPZONEL0                                                   CLE024
     C                   IF        %FOUND(GPZONEL0)                                           CLE024
     C                   EVAL      DtqLib = ZOMSYS + 'DPLIB'                                  CLE024
     C                   ENDIF                                                                CLE024
                                                                                              CLE024
      ** Send xml data to data queue                                                          CLE024
                                                                                              CLE024
     C                   CALL      'QSNDDTAQ'                                                 CLE024
     C                   PARM      'CLECALCMGR'  DtqNam                                       CLE024
     C                   PARM                    DtqLib                                       CLE024
     C                   PARM      500           DtqLen                                       CLE024
     C                   PARM                    PDtqDta                                      CLE024
      *                                                                                    AR1082904
      ** Update GOLSTUPD for CL                                                            AR1082904
      *                                                                                    AR1082904
     C                   EVAL      Key_LSTU = Key_LSTU_CL                                  AR1082904
     C                   EVAL      CID_LSTU = CICCID                                       AR1082904
     C                   EXSR      SRUPD_LSTU                                              AR1082904
      *                                                                                    AR1082904
                                                                                              CLE024
     C                   ENDSR                                                                CLE024
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Delete TRAP record
      ********************************************************************
     C     DELETE_TRAP   BEGSR

     C     GPTRAPK       CHAIN     GPTRAPD0                           99
     C     *IN99         IFEQ      *OFF
     C                   DELETE    GPTRAPD0
     C                   ENDIF

     C                   SELECT
     C     T_MOD         WHENEQ    'FF'
     C     GPUTXFK       CHAIN     GPUTXFD0                           99
     C  N99              DELETE    GPUTXFD0
     C     T_MOD         WHENEQ    'GL'
     C     GPUTXGK       CHAIN     GPUTXGD0                           99
     C  N99              DELETE    GPUTXGD0
     C     T_MOD         WHENEQ    'SE'
     C     T_SMOD        ANDNE     'STRD'                                                     BG3512
     C     GPUTXSK       CHAIN     GPUTXSD0                           99
     C  N99              DELETE    GPUTXSD0
     C                   OTHER
     C     GPUTXTK       CHAIN     GPUTXTD0                           99
     C  N99              DELETE    GPUTXTD0
     C                   ENDSL

     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Delete positions
      ********************************************************************
     C     DELETE_POSN   BEGSR

     C     GPTRAPK       CHAIN     GPPOSND0                           99
     C     *IN99         DOWEQ     *OFF
     C                   DELETE    GPPOSND0
     C     GPTRAPK       READE     GPPOSND0                               99
     C                   ENDDO

     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Delete cashflows
      ********************************************************************
     C     DELETE_CASH   BEGSR

     C     GPTRAPK       CHAIN     GPCASHD0                           99
     C     *IN99         DOWEQ     *OFF
     C                   DELETE    GPCASHD0
     C     GPTRAPK       READE     GPCASHD0                               99
     C                   ENDDO

     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Delete postings
      ********************************************************************
     C     DELETE_POST   BEGSR

      * Delete ALL postings

     C     T_ACTN        IFEQ      'D'

     C     GPPOSTK       CHAIN     GPPOSTD0                           99
     C     *IN99         DOWEQ     *OFF
     C                   DELETE    GPPOSTD0
     C     GPPOSTK       READE     GPPOSTD0                               99
     C                   ENDDO

     C                   ELSE

      * Delete postings since account movement start date

     C     T_GCOB        IFEQ      'Y'

     C     GPUTXGK       CHAIN     GPUTXGD0                           99
     C  N99              Z-ADD     0             XGPRRN
     C  N99              UPDATE    GPUTXGD0

     C     GPPOSTK       CHAIN     GPPOSTD0                           99
     C  N99GPPOSTKD      SETLL     GPPOSTD0
     C  N99GPPOSTK       READE     GPPOSTD0                               99
     C     *IN99         DOWEQ     *OFF
     C                   DELETE    GPPOSTD0
     C     GPPOSTK       READE     GPPOSTD0                               99
     C                   ENDDO

     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Update TRAP record (commitment id)
      ********************************************************************
     C     UPDATE_TRAP   BEGSR

     C     GPTRAPK       CHAIN     GPTRAPD0                           99
     C     *IN99         IFEQ      *OFF
     C                   Z-ADD     CICCID        T_CCID
     C                   UPDATE    GPTRAPD0
     C                   ENDIF

     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Recover positions (This data was written in the previous zone COB)
      ********************************************************************
     C     RECOVER_POSN  BEGSR

     C     GPTRAPK       SETLL     GOPOSND0
     C     GPTRAPK       READE     GOPOSND0                               99
     C     *IN99         DOWEQ     *OFF
     C                   WRITE     GPPOSND0
     C     GPTRAPK       READE     GOPOSND0                               99
     C                   ENDDO

     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Recover cashflows (This data was written in the previous zone COB)
      ********************************************************************
     C     RECOVER_CASH  BEGSR

     C     GPTRAPK       SETLL     GOCASHD0
     C     GPTRAPK       READE     GOCASHD0                               99
     C     *IN99         DOWEQ     *OFF
     C                   WRITE     GPCASHD0
     C     GPTRAPK       READE     GOCASHD0                               99
     C                   ENDDO

     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Extract positions, cashflows and postings
      ********************************************************************
     C     EXTRACT_PCP   BEGSR

     C                   MOVEL     'GLOB'        I#LOC
     C                   Z-ADD     CICCID        I#CCID

     C                   MOVEL     '   '         I#EXTT

     C**********         Z-ADD     T_CNUM        I#CNUM                                       CSD027
     C                   EVAL      I#CNUM = T_CNUM                                            CSD027
     C                   MOVEL     T_PTFR        I#PTFR
     C                   MOVEL     T_BRCA        I#BRCA
     C                   MOVEL     T_BOOK        I#BOOK
     C                   MOVEL     T_ACCY        I#ACCY
     C                   MOVEL     T_ACOD        I#ACOD
     C                   MOVEL     T_ACSQ        I#ACSQ
     C                   MOVEL     T_SESN        I#SESN
     C                   MOVEL     T_MKTI        I#MKTI
     C                   MOVEL     T_ISTT        I#ISTT
     C                   Z-ADD     T_YRNO        I#YRNO
     C                   Z-ADD     T_MTHN        I#MTHN
     C                   MOVEL     T_PCAL        I#PCAL
     C                   Z-ADD     T_STRP        I#STRP
     C                   MOVEL     T_TREF        I#TREF

     C                   SELECT

      * Accounts

     C     T_SMOD        WHENEQ    'ACCT'
     C                   CALL      'GOXCACCT'
      /COPY GOCPYSRC,GOXCEPARM
     C     I#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOXCACCT'
     C                   EXSR      *PSSR
     C                   END

      * FX Deals

     C     T_SMOD        WHENEQ    'FXDL'
     C                   CALL      'GOXCFXDL'
      /COPY GOCPYSRC,GOXCEPARM
     C     I#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOXCFXDL'
     C                   EXSR      *PSSR
     C                   END

      * Loans/Deposits
     C     T_SMOD        WHENEQ    'LDNI'
     C                   CALL      'GOXCLDNI'
      /COPY GOCPYSRC,GOXCEPARM
     C     I#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOXCLDNI'
     C                   EXSR      *PSSR
     C                   END

      * NAs Purchased

     C     T_SMOD        WHENEQ    'NASP'
     C                   CALL      'GOXCNASP'
      /COPY GOCPYSRC,GOXCEPARM
     C     I#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOXCNASP'
     C                   EXSR      *PSSR
     C                   END

      * FRAs

     C     T_SMOD        WHENEQ    'FRAS'
     C                   CALL      'GOXCFRAS'
      /COPY GOCPYSRC,GOXCEPARM
     C     I#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOXCFRAS'
     C                   EXSR      *PSSR
     C                   END

      * Single Ccy Int. Rate Swaps

     C     T_SMOD        WHENEQ    'SIRS'
     C                   CALL      'GOXCSIRS'
      /COPY GOCPYSRC,GOXCEPARM
     C     I#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOXCSIRS'
     C                   EXSR      *PSSR
     C                   END

      * Cross Ccy Int. Rate Swaps

     C     T_SMOD        WHENEQ    'CIRS'
     C                   CALL      'GOXCCIRS'
      /COPY GOCPYSRC,GOXCEPARM
     C     I#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOXCCIRS'
     C                   EXSR      *PSSR
     C                   END

      * Cap/Floor/Collars

     C     T_SMOD        WHENEQ    'CFCO'
     C                   CALL      'GOXCCFCO'
      /COPY GOCPYSRC,GOXCEPARM
     C     I#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOXCCFCO'
     C                   EXSR      *PSSR
     C                   END

      * Customer Loans

     C     T_SMOD        WHENEQ    'LOAN'
     C                   CALL      'GOXCLOAN'
      /COPY GOCPYSRC,GOXCEPARM
     C     I#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOXCLOAN'
     C                   EXSR      *PSSR
     C                   END

      * SE Book Positions

     C     T_SMOD        WHENEQ    'SBPS'
     C                   CALL      'GOXCSBPS'
      /COPY GOCPYSRC,GOXCEPARM
     C     I#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOXCSBPS'
     C                   EXSR      *PSSR
     C                   END

      * SE Cust Positions

     C     T_SMOD        WHENEQ    'SCPS'
     C                   CALL      'GOXCSCPS'
      /COPY GOCPYSRC,GOXCEPARM
     C     I#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOXCSCPS'
     C                   EXSR      *PSSR
     C                   END
                                                                                              BG3512
      * SE Trades                                                                             BG3512
                                                                                              BG3512
     C     T_SMOD        WHENEQ    'STRD'                                                     BG3512
     C                   CALL      'GOXCSTRD'                                                 BG3512
      /COPY GOCPYSRC,GOXCEPARM                                                                BG3512
     C     I#RTCD        IFEQ      '*ERROR'                                                   BG3512
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOXCSTRD'                       BG3512
     C                   EXSR      *PSSR                                                      BG3512
     C                   END                                                                  BG3512

      * FF Book Positions

     C     T_SMOD        WHENEQ    'FBPS'
     C                   CALL      'GOXCFBPS'
      /COPY GOCPYSRC,GOXCEPARM
     C     I#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOXCFBPS'
     C                   EXSR      *PSSR
     C                   END

      * FF Cust Positions

     C     T_SMOD        WHENEQ    'FCPS'
     C                   CALL      'GOXCFCPS'
      /COPY GOCPYSRC,GOXCEPARM
     C     I#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOXCFCPS'
     C                   EXSR      *PSSR
     C                   END

     C                   OTHER

     C                   EVAL      I#ERMS = 'BAD SUB-MODULE IN GOUTUPDTR'
     C                   EXSR      *PSSR

     C                   ENDSL


     C                   ENDSR
      *******************************************************************
      /SPACE 5
      *********************************************************************
      * Write to the log file
      *********************************************************************
     C     WRITE_LOG     BEGSR
     C                   TIME                    TimeDate         12 0
     C                   MOVE      TimeDate      UTDATE
     C                   MOVEL     TimeDate      UTTIME
     C                   WRITE     GPULOGD0
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Open zone files
      *********************************************************************
     C     OPENZFILES    BEGSR
     C                   OPEN      GOPOSNL0
     C                   OPEN      GOCASHL0
     C                   MOVEL     'Y'           ZFiles_Open
      * Write to the log file
     C                   EVAL      UTMSG = 'Updater ' + JobNameSuffix
     C                                   + ' has opened zone files'
     C                   EXSR      WRITE_LOG
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Close zone files
      *********************************************************************
     C     CLOSZFILES    BEGSR
     C                   CLOSE     GOPOSNL0
     C                   CLOSE     GOCASHL0
     C                   MOVEL     'N'           ZFiles_Open
      * Write to the log file
     C                   EVAL      UTMSG = 'Updater ' + JobNameSuffix
     C                                   + ' has closed zone files'
     C                   EXSR      WRITE_LOG
     C                   ENDSR
      ********************************************************************                    CAP205
      /SPACE 5                                                                                CAP205
      ********************************************************************                    CAP205
      * Send ABC Data                                                                         CAP205
      ********************************************************************                    CAP205
     C     SndABCData    BEGSR                                                                CAP205
                                                                                              CAP205
     C     T_ZONE        CHAIN     GPZONEL0                                                   CAP205
     C                   IF        %FOUND(GPZONEL0)                                           CAP205
     C                   EVAL      DtqLib = ZOMSYS + 'DPLIB'                                  CAP205
     C                   ENDIF                                                                CAP205
                                                                                              CAP205
      ** Send xml data to data queue                                                          CAP205
                                                                                              CAP205
     C                   EVAL      WEventtype = 'GLOBAL_TRANSACTION'                          CAP205
     C                   MOVE      CICCID        WDetail                                      CAP205
                                                                                              CAP205
     C                   CALL      'QSNDDTAQ'                                                 CAP205
     C                   PARM      'CREABCQ'     DtqNam                                       CAP205
     C                   PARM                    DtqLib                                       CAP205
     C                   PARM      31            DtqLen                                       CAP205
     C                   PARM                    ABCData                                      CAP205
      *                                                                                    AR1082904
      ** Update GOLSTUPD for ABC                                                           AR1082904
      *                                                                                    AR1082904
     C                   EVAL      Key_LSTU = Key_LSTU_ABC                                 AR1082904
     C                   EVAL      CID_LSTU = CICCID                                       AR1082904
     C                   EXSR      SRUPD_LSTU                                              AR1082904
      *                                                                                    AR1082904
     C                   ENDSR                                                                CAP205
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * Send message to Management Limits
      *********************************************************************
     C     SND_MSG_ML    BEGSR

     C                   MOVEL     CICCID        CommitID         10
     C                   MOVEA     CommitID      ML_MSG(271)
     C                   MOVEA     ML_MSG        MLDtqDta
      * send a message
     C                   CALL      'QSNDDTAQ'                           9999
     C                   PARM      'GPMLTRNNFY'  DtqNam           10
     C                   PARM      '*LIBL     '  DtqLib           10
     C                   PARM      500           DtqLen            5 0
     C                   PARM                    MLDtqDta        500
      *                                                                                    AR1082904
     C                   IF        *IN99 = *ON                                             AR1082904
     C                   EXSR      *PSSR                                                   AR1082904
     C                   ENDIF                                                             AR1082904
      *                                                                                    AR1082904
      ** Update GOLSTUPD for ML                                                            AR1082904
      *                                                                                    AR1082904
     C                   EVAL      Key_LSTU = Key_LSTU_ML                                  AR1082904
     C                   EVAL      CID_LSTU = CICCID                                       AR1082904
     C                   EXSR      SRUPD_LSTU                                              AR1082904
      *                                                                                    AR1082904
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************                AR1082904
      * Update GOLSTUPD for ML, CL & ABC                                                   AR1082904
      *********************************************************************                AR1082904
     C     SRUPD_LSTU    BEGSR                                                             AR1082904
      *                                                                                    AR1082904
     C     Key_LSTU      CHAIN     GOLSTUL0                                                AR1082904
      *                                                                                    AR1082904
     C                   IF        %FOUND(GOLSTUL0)                                        AR1082904
     C                   EVAL      LUPVAL = CID_LSTU                                       AR1082904
     C                   UPDATE    GOLSTUD0                                                AR1082904
     C                   ENDIF                                                             AR1082904
      *                                                                                    AR1082904
     C                   ENDSR                                                             AR1082904
      *********************************************************************                AR1082904
      /SPACE 5                                                                             AR1082904
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR

      * Get Extract control information

      /COPY GOCPYSRC,GOGETEXCT
                                                                                              CLE024
      ** Determine if CLE024 is switched on                                                   CLE024
                                                                                              CLE024
     C                   CALL      'AOSARDR0'                                                 CLE024
     C                   PARM      *BLANKS       PRTCD                                        CLE024
     C                   PARM      '*VERIFY'     POPTN                                        CLE024
     C                   PARM      'CLE024'      PSARD                                        CLE024
                                                                                              CLE024
     C                   IF        PRTCD = *BLANKS                                            CLE024
     C                   MOVE      'Y'           CLE024                                       CLE024
     C                   EVAL      WInitial = XMLArray(4)                                     CLE024
     C                   ELSE                                                                 CLE024
     C                   MOVE      'N'           CLE024                                       CLE024
     C                   ENDIF                                                                CLE024
      *                                                                                       254264
      ** Determine if CGP003 is switched on                                                   254264
      *                                                                                       254264
     C                   CALL      'GPAOSARDR0'                                               254264
     C                   PARM      *BLANKS       PRTCD                                        254264
     C                   PARM      '*VERIFY'     POPTN                                        254264
     C                   PARM      'CGP003'      PSARD                                        254264
      *                                                                                       254264
     C                   IF        PRTCD = *BLANKS                                            254264
     C                   MOVE      'Y'           CGP003                                       254264
     C                   ELSE                                                                 254264
     C                   MOVE      'N'           CGP003                                       254264
     C                   ENDIF                                                                254264
                                                                                              CAP205
      ** Determine if CLE024 is switched on                                                   CAP205
                                                                                              CAP205
     C                   CALL      'AOSARDR0'                                                 CAP205
     C                   PARM      *BLANKS       PRTCD                                        CAP205
     C                   PARM      '*VERIFY'     POPTN                                        CAP205
     C                   PARM      'CAP205'      PSARD                                        CAP205
                                                                                              CAP205
     C                   IF        PRTCD = *BLANKS                                            CAP205
     C                   MOVE      'Y'           CAP205                                       CAP205
     C                   ELSE                                                                 CAP205
     C                   MOVE      'N'           CAP205                                       CAP205
     C                   ENDIF                                                                CAP205
      *                                                                                    AR1031820
      ** Determine if CLE025 is switched on                                                AR1031820
      *                                                                                    AR1031820
     C                   CALL      'AOSARDR0'                                              AR1031820
     C                   PARM      *BLANKS       PRTCD                                     AR1031820
     C                   PARM      '*VERIFY'     POPTN                                     AR1031820
     C                   PARM      'CLE025'      PSARD                                     AR1031820
                                                                                           AR1031820
     C                   IF        PRTCD = *BLANKS                                         AR1031820
     C                   MOVE      'Y'           CLE025                                    AR1031820
     C                   EVAL      WInitial = XMLArray(4)                                  AR1031820
     C                   ELSE                                                              AR1031820
     C                   MOVE      'N'           CLE025                                    AR1031820
     C                   ENDIF                                                             AR1031820

      * job attributes
     C                   EVAL      UTSRC  = 'U'
     C                   EVAL      UTJOB  = PSJobName
     C                   EVAL      UTUSER = PSUser
     C                   MOVEL     PSJobNo       PSJobNoA          6
     C                   EVAL      UTJOBN = PSJobNoA

      * No zone files open initially

     C                   MOVEL     'N'           ZFiles_Open       1

      * Identify the job number and job name suffix

     C                   MOVE      I#DTAQ        JobNumber         1 0
     C                   MOVE      I#DTAQ        JobNameSuffix     5

      ** Check next message to process in DTAQ, if equal to 'STOP' do                      AR1092236
      ** not clear. Remove *NO parameter is specified to avoid message                     AR1092236
      ** from being removed off the DTAQ during this QRCVDTAQ call                         AR1092236
                                                                                           AR1092236
     C                   CALL      'QRCVDTAQ'                                              AR1092236
     C                   PARM      I#DTAQ        DtqNam                                    AR1092236
     C                   PARM      '*LIBL     '  DtqLib                                    AR1092236
     C                   PARM      10            DtqLen                                    AR1092236
     C                   PARM      *BLANK        DtqDta                                    AR1092236
     C                   PARM      1             DtqWait                                   AR1092236
     C                   PARM      *BLANK        DtqKeyO           2                       AR1092236
     C                   PARM      0             DtqKeyL           3 0                     AR1092236
     C                   PARM      *BLANK        DtqKDta          10                       AR1092236
     C                   PARM      0             DtqSdrL           3 0                     AR1092236
     C                   PARM      *BLANK        DtqSdrO          10                       AR1092236
     C                   PARM      '*NO'         DtqRmvM          10                       AR1092236
     C                   PARM      10            DtqSizR           5 0                     AR1092236
     C                   PARM      *BLANK        DtqErIO          10                       AR1092236
                                                                                           AR1092236
     C                   IF        DtqDta <> 'STOP'                                        AR1092236
                                                                                           AR1092236
      * Clear the DTAQ

     C     DtqDta        DOUEQ     *BLANK
     C                   CALL      'QRCVDTAQ'
     C                   PARM      I#DTAQ        DtqNam           10
     C                   PARM      '*LIBL     '  DtqLib           10
     C                   PARM      10            DtqLen            5 0
     C                   PARM      *BLANK        DtqDta           10
     C                   PARM      1             DtqWait           5 0
     C                   ENDDO
                                                                                           AR1092236
     C                   ENDIF                                                             AR1092236

     C                   EVAL      FirstCycle = 'Y'                                        AR1082904
      ** Get CCID of last successful message sent to ML data queue                         AR1082904
     C                   EVAL      Key_LSTU  = Key_LSTU_ML                                 AR1082904
     C     Key_LSTU      CHAIN     GOLSTUL0                                                AR1082904
     C                   IF        %FOUND(GOLSTUL0)                                        AR1082904
     C                   EVAL      CID_LSTU_ML = LUPVAL                                    AR1082904
     C                   ENDIF                                                             AR1082904
      ** Get CCID of last successful message sent to CL data queue                         AR1082904
     C                   EVAL      Key_LSTU  = Key_LSTU_CL                                 AR1082904
     C     Key_LSTU      CHAIN     GOLSTUL0                                                AR1082904
     C                   IF        %FOUND(GOLSTUL0)                                        AR1082904
     C                   EVAL      CID_LSTU_CL = LUPVAL                                    AR1082904
     C                   ENDIF                                                             AR1082904
      ** Get CCID of last successful message sent to ABC data queue                        AR1082904
     C                   EVAL      Key_LSTU  = Key_LSTU_ABC                                AR1082904
     C     Key_LSTU      CHAIN     GOLSTUL0                                                AR1082904
     C                   IF        %FOUND(GOLSTUL0)                                        AR1082904
     C                   EVAL      CID_LSTU_ABC= LUPVAL                                    AR1082904
     C                   ENDIF                                                             AR1082904
                                                                                           AR1082904
      * Write to the log file
     C                   EVAL      UTMSG = 'Updater ' + JobNameSuffix
     C                                   + ' has STARTED'
     C                   EXSR      WRITE_LOG

      * Key lists

     C     GPUTCIK       KLIST
     C                   KFLD                    I#ZONE
     C                   KFLD                    JobNumber
     C     GPTRAPK       KLIST
     C                   KFLD                    T_ID
     C     GPPOSTK       KLIST
     C                   KFLD                    T_ID
     C     GPPOSTKD      KLIST
     C                   KFLD                    T_ID
     C                   KFLD                    I#AMRD
     C     GPUTXFK       KLIST
     C                   KFLD                    T_ZONE
     C                   KFLD                    T_SMOD
     C                   KFLD                    T_CNUM
     C                   KFLD                    T_BRCA
     C                   KFLD                    T_BOOK
     C                   KFLD                    T_ISTT
     C                   KFLD                    T_YRNO
     C                   KFLD                    T_MTHN
     C                   KFLD                    T_PCAL
     C                   KFLD                    T_STRP
     C     GPUTXGK       KLIST
     C                   KFLD                    T_ZONE
     C                   KFLD                    T_CNUM
     C                   KFLD                    T_BRCA
     C                   KFLD                    T_ACCY
     C                   KFLD                    T_ACOD
     C                   KFLD                    T_ACSQ
     C     GPUTXSK       KLIST
     C                   KFLD                    T_ZONE
     C                   KFLD                    T_SMOD
     C                   KFLD                    T_CNUM
     C                   KFLD                    T_PTFR
     C                   KFLD                    T_BRCA
     C                   KFLD                    T_BOOK
     C                   KFLD                    T_SESN
     C                   KFLD                    T_MKTI
     C     GPUTXTK       KLIST
     C                   KFLD                    T_ZONE
     C                   KFLD                    T_MOD
     C                   KFLD                    T_SMOD
     C                   KFLD                    T_TREF

     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
     OGPUTCID0  E
     O                       CIUUNV
     O                       CIEXML
     O                       CIUEXC                                                           CLE024
** ML_MSG
<?xml version="1.0" encoding="UTF-8"?>
<calcManagerEvent xmlns="http://www.misys.com/midas/midasplus/calculationmanager/xml">
<eventType>MIDAS_TRANSACTION</eventType><eventParam><paramName>CommitID</paramName>
<paramValue>nnnnnnnnnn</paramValue></eventParam></calcManagerEvent>
** XMLARRAY                                                                                   CLE024
<?xml version="1.0" encoding="UTF-8"?><calcManagerEvent xmlns                                 CLE024
="http://www.misys.com/midas/midasplus/calculationmanager/xml">                               CLE024
<eventType>GLOBAL_TRANSACTION</eventType>                                                     CLE024
<eventParam><paramName>CommitId</paramName><paramValue>                                       CLE024
</paramValue></eventParam></calcManagerEvent>                                                 CLE024
