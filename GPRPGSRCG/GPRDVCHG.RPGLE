     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Read Valuation Change Alerts File')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPRDVCHG - Midas GP Read Valuation Change Alerts File        *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP009             Date 22Dec04               *
      *                 BG3906 (R          Date 02Nov04               *
      *                 BG3906 (reopen)    DATE 04Oct04               *
      *                 BG3906             DATE 28Jun04               *
      *                 CGP003  *CREATE    DATE 19Mar04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP009 - Local Zone Time Difference (Recompile)              *
      *  BG3906 - (reopen) Change submit to use job queue GPNOMAX     *
      *  BG3906 - (reopen) Unable to update the file twice for        *
      *           SDCURRPD                                            *
      *  BG3906 - Spot Rate changes should trigger reworking of       *
      *           GPTRAPPD                                            *
      *  CGP003 - Management Limits                                   *
      *           Required to inform Management Limits about          *
      *           changes in spot rates                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FGPVACAL0  UF   E           K DISK    INFSR(*PSSR)
     FGPZONEL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
     D/COPY GPCPYSRCG,GP_D_SPEC
      ** Data Area Giving Installation Control Details
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D WSBMJOB         S            100    DIM(2)  CTDATA PERRCD(1)
     D WTXT            DS           200
     D  WZONE                 37     46
     D  WFILE                 50     59
     D  WKEY2                 63     92
     D  WJOBNM               105    114
 
     D DTAFEED       E DS                  EXTNAME(DTAFEED) DTAARA(DTAFEED)
      ** Data Feed data area
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRUN            S              1
     D WKEY            S              4
     D PCOMMAND        S            200
     D PLENGTH         S             15  5
     D WRKTMST         S               Z
     D SYSTIME         S               Z
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C     *LOCK         IN        DTAFEED
     C                   EVAL      SYSTIME = %TIMESTAMP
 
      ** Read record for each zone
 
     C     *LOVAL        SETLL     GPZONEL0
     C                   READ      GPZONEL0
 
     C                   DOW       NOT %EOF(GPZONEL0)
 
      ** Reset file processed flags
 
     C                   MOVEL     'N'           FWDRT             1
     C                   MOVEL     'N'           PRICE             1
     C                   MOVEL     'N'           SDYLDR            1
     C                   MOVEL     'N'           SDCURR            1
     C                   MOVEL     'N'           SDCURRML          1                          BG3906
     C                   MOVEL     'N'           WRKML             1                          BG3906
     C                   MOVEL     *BLANKS       SAV_FEKEY
     C                   MOVEL     *BLANKS       SAV_PRKEY
     C                   MOVEL     *BLANKS       SAV_YRKEY
     C                   MOVEL     *BLANKS       SAV_CRKEY                                    BG3906
 
      ** Read valuation action records for this zone
 
     C     ZOZONE        SETLL     GPVACAL0
     C     ZOZONE        READE     GPVACAL0
 
     C                   DOW       NOT %EOF(GPVACAL0)
 
 
      ** Do unprocessed records
 
     C                   IF        U_PROC <> 'Y'
 
     C                   SELECT
     C     U_FILE        WHENEQ    'SDCURRPD'
     C*
     C     SDCURR        IFNE      'Y'
     C     U_KEY         ORNE      SAV_CRKEY                                                  BG3906
     C*************      EVAL      WRKTMST = U_TMST + %MINUTES(WAITCR)                        BG3906
     C                   EVAL      WRKTMST = U_TMST + %MINUTES(WAITFE)                        BG3906
     C     WRKTMST       IFLE      SYSTIME
     C                   MOVEL     'Y'           SDCURR
     C                   MOVEL     U_KEY         SAV_CRKEY                                    BG3906
     C                   EXSR      SRSBMJ
     C                   ENDIF
     C                   ENDIF
     C*
     C     SDCURR        IFEQ      'Y'
     C                   EXSR      SRUPD
     C                   ENDIF
     C*
     C     U_FILE        WHENEQ    'FWDRTFE'
     C*
     C     FWDRT         IFNE      'Y'
     C     U_KEY         ORNE      SAV_FEKEY
     C                   EVAL      WRKTMST = U_TMST + %MINUTES(WAITFE)
     C     WRKTMST       IFLE      SYSTIME
     C                   MOVEL     'Y'           FWDRT
     C                   MOVEL     U_KEY         SAV_FEKEY
     C                   EXSR      SRSBMJ
     C                   ENDIF
     C                   ENDIF
     C*
     C     FWDRT         IFEQ      'Y'
     C                   EXSR      SRUPD
     C                   ENDIF
     C*
     C     U_FILE        WHENEQ    'PRICED'
     C*
     C     PRICE         IFNE      'Y'
     C     U_KEY         ORNE      SAV_PRKEY
     C                   EVAL      WRKTMST = U_TMST + %MINUTES(WAITPR)
     C     WRKTMST       IFLE      SYSTIME
     C                   MOVEL     'Y'           PRICE
     C                   MOVEL     U_KEY         SAV_PRKEY
     C                   EXSR      SRSBMJ
     C                   ENDIF
     C                   ENDIF
     C*
     C     PRICE         IFEQ      'Y'
     C                   EXSR      SRUPD
     C                   ENDIF
     C*
     C     U_FILE        WHENEQ    'SDYLDRPD'
     C*
     C     SDYLDR        IFNE      'Y'
     C     U_KEY         ORNE      SAV_YRKEY
     C                   EVAL      WRKTMST = U_TMST + %MINUTES(WAITYR)
     C     WRKTMST       IFLE      SYSTIME
     C                   MOVEL     'Y'           SDYLDR
     C                   MOVEL     U_KEY         SAV_YRKEY
     C                   EXSR      SRSBMJ
     C                   ENDIF
     C                   ENDIF
     C*
     C     SDYLDR        IFEQ      'Y'
     C                   EXSR      SRUPD
     C                   ENDIF
     C                   ENDSL
     C*
     C                   ENDIF
                                                                                              BG3906
      ** Do unprocessed records for ML                                                        BG3906
                                                                                              BG3906
     C                   IF        U_PROCML <> 'Y'                                            BG3906
                                                                                              BG3906
     C                   SELECT                                                               BG3906
     C     U_FILE        WHENEQ    'SDCURRPD'                                                 BG3906
     C*                                                                                       BG3906
     C     SDCURRML      IFNE      'Y'                                                        BG3906
     C                   EVAL      WRKTMST = U_TMST + %MINUTES(WAITCR)                        BG3906
     C     WRKTMST       IFLE      SYSTIME                                                    BG3906
     C                   MOVEL     'Y'           SDCURRML                                     BG3906
     C                   MOVEL     'Y'           WRKML                                        BG3906
     C                   EXSR      SRSBMJ                                                     BG3906
     C                   MOVEL     *BLANKS       WRKML                                        BG3906
     C                   ENDIF                                                                BG3906
     C                   ENDIF                                                                BG3906
     C*                                                                                       BG3906
     C     SDCURRML      IFEQ      'Y'                                                        BG3906
     C                   EXSR      SRUPDML                                                    BG3906
     C                   ENDIF                                                                BG3906
     C*                                                                                       BG3906
     C                   ENDSL                                                                BG3906
     C*                                                                                       BG3906
     C                   ENDIF                                                                BG3906
     C*                                                                                       BG3906
     C     U_PROC        IFEQ      'Y'                                                        BG3906
     C     U_PROCML      OREQ      'Y'                                                        BG3906
     C                   UPDATE    GPVACAD0                                                   BG3906
     C                   ENDIF                                                                BG3906
     C*                                                                                       BG3906
     C     ZOZONE        READE     GPVACAL0
     C                   ENDDO
     C*
     C                   READ      GPZONEL0
     C                   ENDDO
 
     C                   RETURN
     C*
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRSBMJ - Submit Job Routine                                       *
      *                                                                   *
      *********************************************************************
 
     C     SRSBMJ        BEGSR
 
     C                   EVAL      WKEY = U_KEY
 
     C                   EVAL      WTXT = WSBMJOB(1) + WSBMJOB(2)
     C                   EVAL      WZONE = ZOZONE
     C                   EVAL      WFILE = U_FILE
     C     WRKML         IFEQ      'Y'                                                        BG3906
     C                   EVAL      WFILE = U_FILE + 'ML'                                      BG3906
     C                   ENDIF                                                                BG3906
     C                   EVAL      WKEY2 = U_KEY
     C                   EVAL      WJOBNM = 'GP' + ZOSHTC + WKEY
     C                   EVAL      PCOMMAND = WTXT
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCOMMAND
     C                   PARM      200           PLENGTH
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRUPD  - Update GPVACAPD Routine                                  *
      *                                                                   *
      *********************************************************************
 
     C     SRUPD         BEGSR
 
     C                   EVAL      U_PROC = 'Y'
     C     U_FILE        IFNE      'SDCURRPD'                                                 BG3906
     C                   EVAL      U_PROCML = 'Y'                                             BG3906
     C                   ENDIF                                                                BG3906
     C***********        UPDATE    GPVACAD0                                                   BG3906
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT                                                                                  BG3906
      *********************************************************************                   BG3906
      *                                                                   *                   BG3906
      * SRUPDML  - Update GPVACAPD Routine for ML                         *                   BG3906
      *                                                                   *                   BG3906
      *********************************************************************                   BG3906
                                                                                              BG3906
     C     SRUPDML       BEGSR                                                                BG3906
                                                                                              BG3906
     C                   EVAL      U_PROCML = 'Y'                                             BG3906
     C************       UPDATE    GPVACAD0                                             BG3906BG3906
                                                                                              BG3906
     C                   ENDSR                                                                BG3906
                                                                                              BG3906
      *********************************************************************                   BG3906
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           50
     C     *LIKE         DEFINE    U_KEY         SAV_FEKEY
     C     *LIKE         DEFINE    U_KEY         SAV_PRKEY
     C     *LIKE         DEFINE    U_KEY         SAV_YRKEY
     C     *LIKE         DEFINE    U_KEY         SAV_CRKEY                                    BG3906
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
** WSBMJOB
SBMJOB CMD(CALL PGM(GPACVCHG) PARM('          ' '          ' '                              '))
JOB(          ) JOBD(GPBCKGRD) OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) INLLIBL(*JOBD) JOBQ(GPNOMAX)
