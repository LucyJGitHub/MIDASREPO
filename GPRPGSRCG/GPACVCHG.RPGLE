     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Action to be Done on Valuation Change')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPACVCHG - Midas GP Action to be Done on Valuation Change    *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BG3906 (R          Date 02Nov04               *
      *                 BUG3860            Date 11Aug04               *
      *                 BG3906             DATE 28Jun04               *
      *                 CLE024             Date 20Oct03               *
      *                 CGP003  *CREATE    Date 19Mar04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BG3906 - (reopen) If T_UNUM is 9, set to 0 not 10.           *
      *  BUG3860 - (recompile)                                        *
      *  BG3906 - Spot Rate changes should trigger reworking of       *
      *           GPTRAPPD                                            *
      *  CLE024 - Collateralised Lending                              *
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
     FGPTRAPL2  IF   E           K DISK    INFSR(*PSSR)
     FGPTRAPL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GOTRAPD0:GOTRAPN0)
     F                                     PREFIX(UP)
     F                                     USROPN
     F                                     COMMIT
     FGPTRAPJ1  IF   E           K DISK    INFSR(*PSSR)
     F***GPZONEPD  IF   E             DISK    INFSR(*PSSR)                                    CLE024
 
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
 
     D  ConstHead1     C                   CONST('<?xml version="1.0" encoding')
     D  ConstHead2     C                   CONST('="UTF-8"?><calcManagerEvent ')
     D  ConstHead3     C                   CONST('xmlns="http://www.misys.com/')
     D  ConstHead4     C                   CONST('midas/midasplus/calculationm')
     D  ConstHead5     C                   CONST('anager/xml"><eventtype>')
     D  ConstHead6     C                   CONST('</eventtype>')
     D  ConstDet1      C                   CONST('<eventParam><paramName>')
     D  ConstDet2      C                   CONST('</paramName><paramValue>')
     D  ConstDet3      C                   CONST('</paramValue></eventParam>')
     D  ConstFoot      C                   CONST('</calcManagerEvent>')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D WQCMD           S            100    DIM(1)  CTDATA PERRCD(1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PZONE           S             10
     D PFLUPD          S             10
     D PKEY            S             30
     D KZONE           S             10
     D KFLUPD          S             10
     D KKEY            S             30
     D KSESN           S             10
     D WRKID           S             15S 0
     D WRKID2          S             15
     D WRUN            S              1
     D PCOMMAND        S            100
     D PLENGTH         S             15  5
     D BUFFRL          S           6000
     D BUFFRS          S            500
     D DTQLEN          S              5P 0
     D DTQLIB          S             10
     D DTQNAM          S             10
     D CHGTYPE         S              2
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PZONE
     C                   PARM                    PFLUPD
     C                   PARM                    PKEY
 
      ** Key lists
 
     C     KGVACA        KLIST
     C                   KFLD                    KZONE
     C                   KFLD                    KFLUPD
     C                   KFLD                    KKEY
 
     C     KGTRAP        KLIST
     C                   KFLD                    KZONE
     C                   KFLD                    KSESN
 
      ** Start commitment control
 
     C                   MOVEA     WQCMD(1)      PCOMMAND
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCOMMAND
     C                   PARM      100           PLENGTH
 
     C                   OPEN      GPTRAPL0
 
     C                   EVAL      WRKID = *ZEROS
 
      ** If record read from FWDRTFE or SDYLDRPD
 
     C                   IF        PFLUPD = 'FWDRTFE' or PFLUPD = 'SDYLDRPD'
     C                             OR PFLUPD = 'SDCURRPD'                                     CLE024
 
     C     PZONE         SETLL     GPTRAPJ1
     C     PZONE         READE     GPTRAPJ1
 
     C                   DOW       NOT %EOF(GPTRAPJ1)
 
     C                   IF        PKEY = P_CCY
 
      ** Update file
 
     C                   IF        T_ID <> WRKID
     C     T_ID          CHAIN     GOTRAPN0                           15
     C                   IF        *IN15 = *OFF
     C     UPT_UNUM      IFNE      9                                                         BUG3906
     C                   EVAL      UPT_UNUM = UPT_UNUM + 1
     C                   ELSE                                                                BUG3906
     C                   EVAL      UPT_UNUM = 0                                              BUG3906
     C                   ENDIF                                                               BUG3906
     C                   EVAL      UPT_GCOB = ' '                                             CLE024
     C                   EVAL      UPT_CCID = 0
     C                   UPDATE    GOTRAPN0
     C                   COMMIT
     C**********         EXSR      SRSNDXML                                                   CLE024
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      WRKID = T_ID
     C                   ENDIF
 
     C     PZONE         READE     GPTRAPJ1
     C                   ENDDO
 
     C                   ENDIF
 
      ** If record read from PRICED
 
     C                   IF        PFLUPD = 'PRICED'
 
     C                   EVAL      KZONE = PZONE
     C                   EVAL      KSESN = PKEY
 
     C     KGTRAP        SETLL     GPTRAPL2
     C     KGTRAP        READE     GPTRAPL2
 
     C                   DOW       NOT %EOF(GPTRAPL2)
 
      ** Update file
 
     C                   IF        T_ID <> WRKID
     C     T_ID          CHAIN     GOTRAPN0                           15
     C                   IF        *IN15 = *OFF
     C                   EVAL      UPT_UNUM = UPT_UNUM + 1
     C                   EVAL      UPT_GCOB = ' '                                             CLE024
     C                   EVAL      UPT_CCID = 0
     C                   UPDATE    GOTRAPN0
     C                   COMMIT
     C**********         EXSR      SRSNDXML                                                   CLE024
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      WRKID = T_ID
     C     KGTRAP        READE     GPTRAPL2
     C                   ENDDO
 
     C                   ENDIF
 
 
      ** If record read from SDCURRPD
 
     C************       IF        PFLUPD = 'SDCURRPD'                                        BG3906
     C                   IF        PFLUPD = 'SDCURRPDML'                                      BG3906
     C                   EXSR      SRSNDXML
 
     C                   ENDIF
      ** Delete matching records
 
     C                   EVAL      KZONE = PZONE
     C                   EVAL      KFLUPD = PFLUPD
     C                   IF        PFLUPD = 'SDCURRPDML'                                      BG3906
     C                   EVAL      KFLUPD = 'SDCURRPD'                                        BG3906
     C                   ENDIF                                                                BG3906
     C                   EVAL      KKEY = PKEY
 
     C     KGVACA        SETLL     GPVACAL0
     C     KGVACA        READE     GPVACAL0
 
     C                   DOW       NOT %EOF(GPVACAL0)
     C                   IF        KFLUPD <> 'SDCURRPD'                                       BG3906
     C                             OR KFLUPD = 'SDCURRPD'                                     BG3906
     C                             AND U_PROC = 'Y' AND U_PROCML = 'Y'                        BG3906
     C                   DELETE    GPVACAD0
     C                   ENDIF                                                                BG3906
     C     KGVACA        READE     GPVACAL0
     C                   ENDDO
 
     C                   CLOSE     GPTRAPL0
     C                   RETURN
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRSNDXML - Send Data to Data Queue                                *
      *                                                                   *
      *********************************************************************
 
     C     SRSNDXML      BEGSR
 
     C**********         IF        PFLUPD <> 'SDCURRPD'                                       CLE024
      ***Determine*change*type****************************************                        CLE024
      **********                                                                              CLE024
     C**********         IF        T_MOD = 'DL' and T_SMOD = 'LDNI'                           CLE024
     C**********         IF        T_TRTP = 'IT' or T_TRTP = 'TD' or                          CLE024
     C**********                   T_TRTP = 'CD' or T_TRTP = 'CI' or                          CLE024
     C**********                   T_TRTP = 'FT' or T_TRTP = 'DT' or                          CLE024
     C**********                   T_TRTP = 'LT'                                              CLE024
     C**********         EVAL      CHGTYPE = 'CV'                                             CLE024
     C**********         ENDIF                                                                CLE024
     C**********         ENDIF                                                                CLE024
      **********                                                                              CLE024
     C**********         IF        T_MOD = 'SE' and T_SMOD = 'SCPS'                           CLE024
     C**********         EVAL      CHGTYPE = 'CV'                                             CLE024
     C**********         ENDIF                                                                CLE024
      **********                                                                              CLE024
     C**********         IF        T_MOD = 'FXDL'                                             CLE024
     C**********         EVAL      CHGTYPE = 'EO'                                             CLE024
     C**********         ENDIF                                                                CLE024
      **********                                                                              CLE024
     C**********         IF        T_MOD = 'DL' and T_SMOD = 'LDNI'                           CLE024
     C**********         IF        T_TRTP = 'IP' or T_TRTP = 'TI' or                          CLE024
     C**********                   T_TRTP = 'CL' or T_TRTP = 'DL' or                          CLE024
     C**********                   T_TRTP = 'FL' or T_TRTP = 'DP' or                          CLE024
     C**********                   T_TRTP = 'LP'                                              CLE024
     C**********         EVAL      CHGTYPE = 'EO'                                             CLE024
     C**********         ENDIF                                                                CLE024
     C**********         ENDIF                                                                CLE024
      **********                                                                              CLE024
     C**********         IF        (T_MOD = 'DL' and T_SMOD = 'FRAS') or                      CLE024
     C**********                   (T_MOD = 'DL' and T_SMOD = 'SIRS') or                      CLE024
     C**********                   (T_MOD = 'DL' and T_SMOD = 'CIRS') or                      CLE024
     C**********                   (T_MOD = 'DL' and T_SMOD = 'CFCO') or                      CLE024
     C**********                   (T_MOD = 'LE' and T_SMOD = 'LOAN')                         CLE024
     C**********         EVAL      CHGTYPE = 'EO'                                             CLE024
     C**********         ENDIF                                                                CLE024
      **********                                                                              CLE024
     C**********         IF        T_MOD = 'GL' and T_SMOD = 'ACCT'                           CLE024
     C**********         EVAL      CHGTYPE = 'CE'                                             CLE024
     C**********         ENDIF                                                                CLE024
      **********                                                                              CLE024
     C**********         MOVE      T_ID          WRKID2                                       CLE024
      **********                                                                              CLE024
     C**********         EVAL      BUFFRL = ConstHead1 + ConstHead2 + ConstHead3              CLE024
     C**********                            + ConstHead4 + ConstHead5 +                       CLE024
     C**********                            'DATAFEED_UPDATE' + ConstHead6 +                  CLE024
     C**********                            ConstDet1 + 'T_ID' + ConstDet2 +                  CLE024
     C**********                            WRKID2 + ConstDet3 + ConstDet1 +                  CLE024
     C**********                            'calcIndicator' + ConstDet2 +                     CLE024
     C**********                            CHGTYPE + ConstDet3 + ConstFoot                   CLE024
      **********                                                                              CLE024
      ***Send*buffer to the data queue                                                        CLE024
      **********                                                                              CLE024
     C**********         IF        BUFFRL <> *BLANKS                                          CLE024
      **********                                                                              CLE024
     C**********         READ      GPZONEPD                                                   CLE024
      **********                                                                              CLE024
     C**********         DOW       NOT %EOF(GPZONEPD)                                         CLE024
      **********                                                                              CLE024
     C**********         EVAL      DTQLIB = ZOMSYS + 'DPLIB'                                  CLE024
      **********                                                                              CLE024
     C**********         CALL      'QSNDDTAQ'                           9999                  CLE024
     C**********         PARM      'CLECALCMGR'  DTQNAM                                       CLE024
     C**********         PARM                    DTQLIB                                       CLE024
     C**********         PARM      6000          DTQLEN                                       CLE024
     C**********         PARM                    BUFFRL                                       CLE024
      **********                                                                              CLE024
     C**********         READ      GPZONEPD                                                   CLE024
     C**********         ENDDO                                                                CLE024
      **********                                                                              CLE024
     C**********         ENDIF                                                                CLE024
     C**********         ENDIF                                                                CLE024
 
     C                   IF        PFLUPD =  'SDCURRPD'
     C                   EVAL      BUFFRS = ConstHead1 + ConstHead2 + ConstHead3
     C                                      + ConstHead4 + ConstHead5 +
     C                                      'RECALCULATE_ZONE' + ConstHead6 +
     C                                      ConstDet1 + 'ZONE' + ConstDet2 +
     C                                      %TRIM(PZONE) + ConstDet3 + ConstFoot
 
      ** Send buffer to the data queue
 
     C                   IF        BUFFRS <> *BLANKS
      *
      * Retrieve system id of global layer
     C                   CALL      'GPRTVLIB'
     C                   PARM                    System            2
     C                   EVAL      DTQLIB = System + 'GPLIB'
 
     C                   CALL      'QSNDDTAQ'                           9999
     C                   PARM      'GPMLTRNNFY'  DTQNAM
     C                   PARM                    DTQLIB
     C                   PARM      500           DTQLEN
     C                   PARM                    BUFFRS
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *********************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           50
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
**  WQCMD
CALL GPCMTCTL ('S' '          ')
