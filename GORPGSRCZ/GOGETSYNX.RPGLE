     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Get synchronisation executables')             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGETSYNX - Get Synchronisation Executables                  *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD055146           Date 04Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR1079991          Date 29Jan13               *
      *                 AR1064845          Date 05Dec12               *
      *                 262126             Date 12Oct09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 243724             Date 15Nov06               *
      *                 242731             Date 10Oct06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE041             Date 11Oct04               *
      *                 BG1364             Date 04Mar04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055146 - Failed MXC004802 seq. 00001 and others            *
      *             Increase Branch count to 900.                     *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1079991 - Deleted zonal journal entry records were not     *
      *              removed from the global file                     *
      *  AR1064845 - OPNQRYF QRYSLT exceeds 5000 characters           *
      *  262126 - QRYSLT cannot exceed 5000.                          *
      *  243724 - A length that is not valid is specified in the 2nd  *
      *           parameter that was sent to QCMDEXC. Fix 242731 has  *
      *           been corrected to send the maximum length allowed.  *
      *  242731 - Fix to enlarge size of OPNQRYF statement.           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  BG1364 - Filter Duplicate records in Bulk Synchronization    *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGPGLOBFL1 IF   E           K DISK
     FGZSDBRCHL1IF   E           K DISK
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D KY              S             10    DIM(9)
 
     D ZLFOVR          S              1    DIM(55) CTDATA PERRCD(55)
     D GLFOVR          S              1    DIM(55) CTDATA PERRCD(55)
     D GLFCLO          S              1    DIM(55) CTDATA PERRCD(55)
     D ZLFDLO          S              1    DIM(55) CTDATA PERRCD(55)
     D GLFDLO          S              1    DIM(55) CTDATA PERRCD(55)
 
     D OPNQRY          S             20    DIM(3) CTDATA PERRCD(1)
 
     D SUBZ            S             38    DIM(1) CTDATA PERRCD(1)
     D SUBB            S             35    DIM(3) CTDATA PERRCD(1)
 
     D                 DS
     D*QRYSLT***               1   2000                                                       242731
     D*QS*******               1   2000                                                       242731
     D**********                           DIM(2000)                                          242731
     D QRYSLT                  1  31000                                                       242731
     D QS                      1  31000                                                       242731
     D                                     DIM(31000)                                         242731
 
     D                 DS
     D QRYKEY                  1    500
     D QK                      1    500
     D                                     DIM(500)
 
     Dqrysltx          S          31000A                                                      262126
     Dqrytemp          S             25A                                                      262126
 
     C     GFGBRC        IFEQ      *BLANK
     C                   EXSR      S_ZONE
     C                   ELSE
     C                   EXSR      S_BRCA
     C                   ENDIF
 
     C     GFGBRC        IFEQ      *BLANK                                                     262126
     C                   EVAL      O_OPNQRY =   OPNQRY(1) + GFGLF
     C                                        + OPNQRY(2)
     C                                        + QRYSLT
     C                                        + QRYKEY
     C                                        + OPNQRY(3)
     C                   ELSE                                                                 262126
     C                   EVAL      O_OPNQRY =   OPNQRY(1) + GFGLF                             262126
     C                                        + OPNQRY(2)                                     262126
     C                                        + %trim(qrysltx)                                262126
     C                                        + QRYKEY                                        262126
     C                                        + OPNQRY(3)                                     262126
     C                   ENDIF                                                                262126
 
     C                   SETON                                        LR
     C                   RETURN
     C/SPACE 5
      ********************************************************************
      * Selection is by zone
      ********************************************************************
     C     S_ZONE        BEGSR
 
     C                   MOVEA     SUBZ(1)       QS(1)
     C                   MOVEA     GFZONE        QS(9)
     C                   MOVEA     I_ZONE        QS(25)
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Selection is by branch
      ********************************************************************
     C     S_BRCA        BEGSR
 
     C**********         Z-ADD     1             X                 4 0                        262126
     C                   eval      qrysltx = *blanks                                          262126
      * Blank branch                                                                          BG1364
     C**********         MOVEA     SUBB(1)       QS(1)                                 BG1364 262126
     C*****X****         ADD       8             Y                 4 0                 BG1364 262126
     C**********         MOVEA     GFGBRC        QS(Y)                                 BG1364 262126
     C**********         ADD       35            X                                     BG1364 262126
     C                   eval      qrysltx = 'QRYSLT('''                                      262126
     C                             + %trim(gfgbrc) + ' *EQ %VALUES("  " '                  AR1064845
     C**********                   + %trim(gfgbrc) + ' *EQ "   "'                   262126 AR1064845
                                                                                              BG1364
      * Live branches                                                                         BG1364
 
     C     I_ZONE        SETLL     SDBRCHD0
     C     I_ZONE        READE     SDBRCHD0                               99
     C     *IN99         DOWEQ     *OFF
     C*****X*************IFEQ      1                                                          BG1364
     C*******************MOVEA     SUBB(1)       QS(X)                                        BG1364
     C*******************ELSE                                                                 BG1364
     C**********         MOVEA     SUBB(2)       QS(X)                                        262126
     C*******************ENDIF                                                                BG1364
     C*****X****         ADD       8             Y                 4 0                        262126
     C**********         MOVEA     GFGBRC        QS(Y)                                        262126
     C*****X****         ADD       24            Y                                            262126
     C**********         MOVEA     A8BRCD        QS(Y)                                        262126
     C**********         ADD       35            X                                            262126
     C                   eval      qrytemp = *blanks                                          262126
     C**********         eval      qrytemp = ' *OR ' + %trim(gfgbrc)                 262126 ARXXXXXX
     C**********                            + ' *EQ "' + a8brcd + '"'               262126 AR1064845
     C                   eval      qrytemp =  '"' + a8brcd + '"'                           AR1064845
     C**********         eval      qrysltx = %trim(qrysltx) + qrytemp               262126 AR1079991
     C                   eval      qrysltx = %trim(qrysltx) + ' ' + qrytemp                AR1079991
     C     I_ZONE        READE     SDBRCHD0                               99
     C                   ENDDO
 
     C**********         MOVEA     SUBB(3)       QS(X)                                        262126
     C**********         eval      qrysltx = %trim(qrysltx) + ''')'                 262126 AR1064845
     C                   eval      qrysltx = %trim(qrysltx) + ')' + ''')'                  AR1064845
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Inputs
     C                   PARM                    I_GPF            10
     C                   PARM                    I_ZONE           10
      * Outputs
     C                   PARM                    O_GLFU           10
     C                   PARM                    O_ZLFOVR         60
     C                   PARM                    O_GLFOVR         60
     C                   PARM                    O_GLFCLO         60
     C                   PARM                    O_ZLFDLO         60
     C                   PARM                    O_GLFDLO         60
 
     C**********         PARM                    O_OPNQRY       5000                          242731
     C**********         PARM                    O_OPNQRY      32767                   242731 243724
     C                   PARM                    O_OPNQRY      32702                          243724
 
     C                   PARM                    O_ZLF            10                          BG1364
     C                   PARM                    O_BLFD            1                          BG1364
                                                                                              BG1364
     C                   PARM                    O_BLSY            1
     C                   PARM                    O_GFGPF          10                        MD055146
     C                   PARM                    O_GFGBRC         10                        MD055146
     C                   PARM                    O_GFGLF          10                        MD055146
 
     C                   MOVE      *BLANK        I#RTCD            7
     C                   MOVE      *BLANK        I#ERMS           50
     C                   MOVE      *BLANKS       O_GFGPF                                    MD055146
     C                   MOVE      *BLANKS       O_GFGBRC                                   MD055146
     C                   MOVE      *BLANKS       O_GFGLF                                    MD055146
                                                                                            MD055146
 
     C     I_GPF         CHAIN     GPGLOBFD0                          99
 
     C     *in99         IFEQ      *OFF
     C                   MOVEL     GFBLSY        O_BLSY
     C                   MOVEL     GFGLFU        O_GLFU
     C                   MOVEL     GFGPF         O_GFGPF                                    MD055146
     C                   MOVEL     GFGBRC        O_GFGBRC                                   MD055146
     C                   MOVEL     GFGLF         O_GFGLF                                    MD055146
     C                   ELSE
     C                   MOVEL     '?'           O_BLSY
     C                   ENDIF
 
      * End now if bulk synchronisation is not done for this file
 
     C     O_BLSY        IFNE      'Y'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
     C                   MOVEL     GFGKY1        KY(1)
     C                   MOVEL     GFGKY2        KY(2)
     C                   MOVEL     GFGKY3        KY(3)
     C                   MOVEL     GFGKY4        KY(4)
     C                   MOVEL     GFGKY5        KY(5)
     C                   MOVEL     GFGKY6        KY(6)
     C                   MOVEL     GFGKY7        KY(7)
     C                   MOVEL     GFGKY8        KY(8)
     C                   MOVEL     GFGKY9        KY(9)
 
     C                   MOVEA     '  KEYFLD('   QK(1)
     C                   Z-ADD     1             ZK                2 0
     C                   Z-ADD     10            ZL                5 0
     C     ZK            DOWLE     9
     C     KY(ZK)        ANDNE     *BLANK
     C                   MOVE      '('           QK(ZL)
     C                   ADD       1             ZL
     C                   MOVEA     KY(ZK)        KeyField         10
     C                   MOVEA     KeyField      QK(ZL)
     C                   ADD       10            ZL
     C                   MOVE      ')'           QK(ZL)
     C                   ADD       1             ZK
     C                   ADD       2             ZL
     C                   ENDDO
     C                   MOVE      ')'           QK(ZL)
 
     C                   MOVEA     GFZLF         ZLFOVR(17)
     C                   MOVEA     GFGLF         GLFOVR(17)
     C                   MOVEA     GFGLF         GLFCLO(17)
     C                   MOVEA     GFZLF         ZLFDLO(17)
     C                   MOVEA     GFGLF         GLFDLO(17)
 
     C                   MOVEA     ZLFOVR        O_ZLFOVR
     C                   MOVEA     GLFOVR        O_GLFOVR
     C                   MOVEA     GLFCLO        O_GLFCLO
     C                   MOVEA     ZLFDLO        O_ZLFDLO
     C                   MOVEA     GLFDLO        O_GLFDLO
                                                                                              BG1364
     C                   MOVEL     GFZLF         O_ZLF                                        BG1364
     C                   MOVEL     GFBLFD        O_BLFD                                       BG1364
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
** ZLFOVR
OVRDBF     FILE(          ) SEQONLY(*YES 4000)                                                CLE041
** GLFOVR
OVRDBF     FILE(          ) SHARE(*YES) OPNSCOPE(*JOB)
** GLFCLO
CLOF      OPNID(          )
** ZLFDLO
DLTOVR     FILE(          )
** GLFDLO
DLTOVR     FILE(          )
** OPNQRY
OPNQRYF FILE(
) OPTION(*ALL)
 OPNSCOPE(*JOB)
** SUBZ
QRYSLT('           *EQ "          "')
** SUBB
QRYSLT('           *EQ "   "
   *OR             *EQ "   "
')