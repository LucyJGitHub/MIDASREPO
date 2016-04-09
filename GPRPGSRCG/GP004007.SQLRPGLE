     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GP Users Security Report Selection')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP004007 - Midas GP Users Security Report Selection          *
      *                                                               *
      *  Function: Produce Midas GP Users Security Report Selection   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR892737B          Date 16Jan11               *
      *  Prev Amend No. AR892737A          Date 16Jan11               *
      *                 AR878597           Date 13Dec11               *
      *                 CBF005  *CREATE    Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR892737B - Permissions by User Report does not allow lower  *
      *              case characters on user profile                  *
      *  AR892737A - Permissions by User Report does not allow lower  *
      *              case characters on user profile                  *
      *  AR878597 - Global Compilation Issues                         *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      * *INZSR    - Program initialisation                            *
      * *PSSR     - Error handling subroutine                         *
      * SrExcSQLF - Subroutine to the declare and create aliases      *
      *             for files used in SQL statements in the program   *
      * SrClsSQLF - Subroutine to drop aliases used for files used in *
      *             SQL statements in the program                     *
      * SrExcSQL1 - Subroutine to execute SQL script for getting      *
      *             Level 1 field in the report                       *
      * SRFtcSQL1 - Subroutine to fetch records of StmSQL1 for getting*
      *             Level 1 field in the report                       *
      * SrClsSQL1 - Subroutine to close recordset of StmSQL1          *
      * SrScr1 - Subroutine to show Screen 1                          *
      * SrScr2 - Subroutine to show Screen 2                          *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas GP Users Security Report Selection
      *
     FGP004007DFCF   E             WORKSTN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ External data areas                  ¦
      ** ¦ ===================                  ¦
      ** +--------------------------------------+
      *
      ** Midas Local Data Area for database error reporting; based on
      ** external file
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Array containing Copyright statement
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array for error messages
      *
     D ErrMsgAr        S             80    DIM(2) CTDATA PERRCD(1)
      *
      **  Data structures for use with Access Objects
      *
     D GZSDBANK      E DS                  EXTNAME(GZSDBANKPD)
      *
      **  Program status data structure
      *
     D PSDS           SDS
     D SWSID                 244    253
     D USRID                 254    263
      *
      **  Data structure to store parameters
      *
     D TMPPARM         DS            17
     D SOPTN                   1      1
     D SUSRP                   2     11
     D SDEPT                  12     14
     D SDBRN                  15     17
      **********                                                                           AR892737B
      ***DS*for*SQL*cursor*RS1*****************************************                    AR892737B
      ******A.BFNMAPK                30A                                                   AR892737B
      **********                                                                           AR892737B
     D*DSRS1****       DS                                                                  AR892737B
     D*S1_USER**               1     30                                                    AR892737B
      *
      ** Parameters for GOGETZONE
      *
     D I#RTCD          S              7A
     D I#ERMS          S             50A
     D I#FULLCHECK     S              1A
     D O#ZONE          S             10A
     D O#SHTC          S              4A
     D O#RDNB          S              5  0
     D O#DNWD          S              5  0
     D O#BCCY          S              3A
     D O#NJOB          S              1  0
      **********                                                                           AR892737B
      ***SQL*work*variables********************************************                    AR892737B
      **********                                                                           AR892737B
     D*StmSQL1**       S           2000A                                                   AR892737B
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Program entry parameters
      *
     D*PSeq*****       S              5A                                                   AR892737A
     D*PLevl****       S              1A                                                   AR892737A
     D*PEnty****       S              3A                                                   AR892737A
     D Parm01          DS           100                                                    AR892737A
     D  PSeq                          5A                                                   AR892737A
     D  PLevl                         1A                                                   AR892737A
     D  PEnty                         3A                                                   AR892737A
     D  PAct                          1A                                                   AR892737A
     D  PCmd                          1A                                                   AR892737A
     D Parm02          S            100A                                                   AR892737A
     D Parm03          S            100A                                                   AR892737A
     D PParm           S            100A
     D*PAct*****       S              1A                                                   AR892737A
     D*PCmd*****       S              1A                                                   AR892737A
      *
      ** Other work variables
      *
     D PZone           S             10A
     D PRtCd           S              7A
     D PErms           S             50A
     D PCache          S              1A
     D PRecImage       S          32000A
     D R_Count         S              4  0                                                 AR892737B
      *
     D WRUN            S              1A
      ** Return code
     D @RtCd           S              7A
      ** Option
     D @Optn           S              7A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Execute screens
      *
     C                   EXSR      SrScr1
      *
     C                   IF        SOPTN = '1'
     C                   EVAL      SUSRP = *BLANKS
     C                   ENDIF
      *
     C                   EVAL      PParm = TMPParm
      *
     C                   IF        *IN01 = *ON
     C                   EVAL      PCmd = 'E'
     C                   ENDIF
      *
     C                   IF        *IN02 = *ON
     C                   EVAL      PCmd = 'F'
     C                   ENDIF
      *
     C                   IF        *IN04 = *ON
     C                   EVAL      PCmd = 'D'
     C                   ENDIF
      *
     C**********         EXSR      SrClsSQLF                                               AR892737B
      *
      ** Return
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrScr1 - Subroutine to show Screen 1                          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SrExcSQLF, SrScr2                                      *
      *                                                               *
      *****************************************************************
     C     SrScr1        BEGSR
      *
     C**********         EXSR      SrExcSQLF                                               AR892737B
      *
      ** Display first screen while F3 is not pressed
      *
     C                   DOW       *IN01 = *OFF AND
     C                             *IN02 = *OFF AND
     C                             *IN04 = *OFF AND
     C                             *IN07 = *OFF
      *
     C                   EXFMT     GP004007F1
      *
     C                   IF        *IN01 = *OFF AND
     C                             *IN02 = *OFF
     C                   SETOFF                                       1020
     C                   SETOFF                                       1121
      *
      ** Can only choose 1 or 2
      *
     C                   IF        SOPTN <> '1' AND
     C                             SOPTN <> '2'
     C                   SETON                                        1020
     C                   EVAL      EMSG = ErrMsgAr(1)
      *
      ** If option 1
      *
     C                   ELSE
     C                   IF        SOPTN = '1'
     C                   EVAL      *IN07 = *ON
      *
      ** If option 2
      *
     C                   ELSE
     C                   EXSR      SrScr2
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrScr2 - Subroutine to show Screen 2                          *
      *                                                               *
      * Called by: SrScr1                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrScr2        BEGSR
      *
      ** Display second screen
      *
     C                   DOW       *IN01 = *OFF AND
     C                             *IN02 = *OFF AND
     C                             *IN04 = *OFF AND
     C                             *IN07 = *OFF
      *
     C                   IF        *IN11 = *OFF AND
     C                             PAct <> 'E' AND
     C                             PAct <> 'D' AND
     C                             PAct <> 'A'
     C                   EVAL      SUSRP = *BLANKS
     C                   ENDIF
      *
     C                   EXFMT     GP004007F2
      *
     C                   IF        *IN01 = *OFF AND
     C                             *IN02 = *OFF
      *
     C                   SETOFF                                       1121
      *
     C**********         EXSR      SrExcSQL1                                               AR892737B
     C**********         EXSR      SrFtcSQL1                                               AR892737B
     C                   EXSR      SrExcSQLU                                               AR892737B
      *
      ** If inputted user is found
      *
     C**********         IF        SQLCODE = *ZEROS                                        AR892737B
     C                   IF        R_Count <> 0                                            AR892737B
     C                   SETON                                        07
      *
      ** If inputted user not is found
      *
     C                   ELSE
     C                   SETON                                        1121
     C                   EVAL      EMSG = ErrMsgAr(2)
     C                   ENDIF
     C**********         EXSR      SrClsSQL1                                               AR892737B
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   SETOFF                                       02
      *
     C                   ENDSR
      *****************************************************************                    AR892737B
      *                                                               *                    AR892737B
      * SrExcSQL  - Subroutine to execute SQL script                  *                    AR892737B
      *                                                               *                    AR892737B
      * Called by: SrScr2                                             *                    AR892737B
      *                                                               *                    AR892737B
      * Calls: None                                                   *                    AR892737B
      *                                                               *                    AR892737B
      *****************************************************************                    AR892737B
     C     SrExcSQLU     BEGSR                                                             AR892737B
      *                                                                                    AR892737B
     C/EXEC SQL                                                                            AR892737B
     C+  SELECT Count(*) into :R_Count from MIVW_USER                                      AR892737B
     C+         WHERE BFNAMEPK = :SUSRP                                                    AR892737B
     C/END-EXEC                                                                            AR892737B
      *                                                                                    AR892737B
     C                   ENDSR                                                             AR892737B
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************                    AR892737B
      **SrExcSQL1*-*Subroutine*to*execute*SQL*script*for*getting*******                    AR892737B
      **************Level*1*field*in*the*report************************                    AR892737B
      *****************************************************************                    AR892737B
      **Called*by:*SrScr2**********************************************                    AR892737B
      *****************************************************************                    AR892737B
      **Calls:*None****************************************************                    AR892737B
      *****************************************************************                    AR892737B
      *****************************************************************
     C*****SrExcSQL1     BEGSR                                                             AR892737B
      **********                                                                           AR892737B
      ***Reset*SQL*Statement*******************************************                    AR892737B
      **********                                                                           AR892737B
     C**********         EVAL      StmSQL1 = *BLANKS                                       AR892737B
      **********                                                                           AR892737B
      ***Statement:*SELECT*********************************************                    AR892737B
      **********                                                                           AR892737B
     C**********         EVAL      StmSQL1 = %TRIM(StmSQL1) + 'SELECT         '+           AR892737B
     C**********                   ' A.BFNAMEPK                               '            AR892737B
      **********                                                                           AR892737B
      ***Statement:*FROM***********************************************                    AR892737B
      **********                                                                           AR892737B
     C**********         EVAL      StmSQL1 = %TRIM(StmSQL1) + ' FROM          '+           AR892737B
     C**********                   ' A                                        '            AR892737B
      **********                                                                           AR892737B
      ***Statement:*WHERE**********************************************                    AR892737B
      **********                                                                           AR892737B
     C**********         EVAL      StmSQL1 = %TRIM(StmSQL1) + ' WHERE         '+           AR892737B
     C**********                   ' A.BFNAMEPK = '''+SUSRP+'''               '            AR892737B
      **********                                                                           AR892737B
     C*EXEC*SQL********************************************************                    AR892737B
     C**PREPARE*STATEMENT1*********************************************                    AR892737B
     C****FROM*:StmSQL1************************************************                    AR892737B
     C*END-EXEC********************************************************                    AR892737B
      **********                                                                           AR892737B
     C*EXEC*SQL********************************************************                    AR892737B
     C**DECLARE*RS1*CURSOR*********************************************                    AR892737B
     C****FOR*STATEMENT1***********************************************                    AR892737B
     C*END-EXEC********************************************************                    AR892737B
      **********                                                                           AR892737B
     C*EXEC*SQL********************************************************                    AR892737B
     C***OPEN*RS1******************************************************                    AR892737B
     C*END-EXEC********************************************************                    AR892737B
      **********                                                                           AR892737B
     C**********         ENDSR                                                             AR892737B
      *****************************************************************
      *EJECT****                                                                           AR892737B
      *****************************************************************
      *****************************************************************                    AR892737B
      **SRFtcSQL1*-*Subroutine*to*fetch*records*of*StmSQL1*for*getting*                    AR892737B
      **************Level*1*field*in*the*report************************                    AR892737B
      *****************************************************************                    AR892737B
      **Called*by:*SrScr2**********************************************                    AR892737B
      *****************************************************************                    AR892737B
      **Calls:*None****************************************************                    AR892737B
      *****************************************************************                    AR892737B
      *****************************************************************
     C*****SRFtcSQL1     BEGSR                                                             AR892737B
      **********                                                                           AR892737B
     C*EXEC*SQL********************************************************                    AR892737B
     C***FETCH*NEXT*FROM*RS1*INTO*:DSRS1*******************************                    AR892737B
     C*END-EXEC********************************************************                    AR892737B
      **********                                                                           AR892737B
     C**********         ENDSR                                                             AR892737B
      *****************************************************************
      *EJECT****                                                                           AR892737B
      *****************************************************************
      *****************************************************************                    AR892737B
      **SrClsSQL1*-*Subroutine*to*close*recordset*of*StmSQL1***********                    AR892737B
      *****************************************************************                    AR892737B
      **Called*by:*SrScr2**********************************************                    AR892737B
      *****************************************************************                    AR892737B
      **Calls:*None****************************************************                    AR892737B
      *****************************************************************                    AR892737B
      *****************************************************************
     C*****SrClsSQL1     BEGSR                                                             AR892737B
     C**********                                                                           AR892737B
     C*EXEC*SQL********************************************************                    AR892737B
     C***CLOSE*RS1*****************************************************                    AR892737B
     C*END-EXEC********************************************************                    AR892737B
     C**********                                                                           AR892737B
     C**********         ENDSR                                                             AR892737B
      *****************************************************************
      *EJECT****                                                                           AR892737B
      *****************************************************************
      *****************************************************************                    AR892737B
      **SrExcSQLF*-*Subroutine*to*the*declare*and*create*aliases*******                    AR892737B
      **************for*files*used*in*SQL*statements*in*the*program****                    AR892737B
      *****************************************************************                    AR892737B
      **Called*by:*SrScr1**********************************************                    AR892737B
      *****************************************************************                    AR892737B
      **Calls:*None****************************************************                    AR892737B
      *****************************************************************                    AR892737B
      *****************************************************************
     C*****SrExcSQLF     BEGSR                                                             AR892737B
      **********                                                                           AR892737B
     C*EXEC*SQL********************************************************                    AR892737B
     C**CREATE*ALIAS*A*FOR*MIVW_USER***********************************                    AR892737B
     C*END-EXEC********************************************************                    AR892737B
      **********                                                                           AR892737B
     C**********         ENDSR                                                             AR892737B
      *****************************************************************
      *EJECT****                                                                           AR892737B
      *****************************************************************
      *****************************************************************                    AR892737B
      **SrClsSQLF*-*Subroutine*to*drop*aliases*used*for*files*used*in**                    AR892737B
      **************SQL*statements*in*the*program**********************                    AR892737B
      *****************************************************************                    AR892737B
      **Called*by:*Main*Processing*************************************                    AR892737B
      *****************************************************************                    AR892737B
      **Calls:*None****************************************************                    AR892737B
      *****************************************************************                    AR892737B
      *****************************************************************
     C*****SrClsSQLF     BEGSR                                                             AR892737B
      **********                                                                           AR892737B
     C*EXEC*SQL********************************************************                    AR892737B
     C**DROP*ALIAS*A***************************************************                    AR892737B
     C*END-EXEC********************************************************                    AR892737B
      **********                                                                           AR892737B
     C**********         ENDSR                                                             AR892737B
      *****************************************************************
      *EJECT****                                                                           AR892737B
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Program Entry Parameter
      *
     C     *ENTRY        PLIST
     C**********         PARM                    PSeq                                      AR892737A
     C**********         PARM                    PLevl                                     AR892737A
     C**********         PARM                    PEnty                                     AR892737A
     C                   PARM                    Parm01                                    AR892737A
     C                   PARM                    Parm02                                    AR892737A
     C                   PARM                    Parm03                                    AR892737A
     C                   PARM                    PParm
     C**********         PARM                    PAct                                      AR892737A
     C**********         PARM                    PCmd                                      AR892737A
      *
      ** Check to see if Amend, Eequiry or Delete options are taken
      *
     C                   IF        PAct = 'A' AND
     C                             PAct = 'E' AND
     C                             PAct = 'D'
     C                   EVAL      TMPParm = PParm
     C                   ENDIF
      *
      ** Enable F10 if Delete is chosen
      *
     C                   IF        PAct = 'D'
     C                   SETON                                        030506
     C                   ENDIF
      *
     C                   IF        PAct = 'E'
     C                   SETON                                        0506
     C                   ENDIF
      *
      ** Get current zone
      *
     C                   CALL      'GOGETZONE'
     C                   PARM                    I#RTCD
     C                   PARM                    I#ERMS
     C                   PARM      'Y'           I#FULLCHECK
     C                   PARM                    O#ZONE
     C                   PARM                    O#SHTC
     C                   PARM                    O#RDNB
     C                   PARM                    O#DNWD
     C                   PARM                    O#BCCY
     C                   PARM                    O#NJOB
      *
      ** Obtain Run Date from GZSDBANKPD
      *
     C                   CALL      'GPACSZBNK'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      *BLANKS       PErms
     C                   PARM      O#ZONE        PZone
     C                   PARM      'N'           PCache
     C     GZSDBANK      PARM                    PRecImage
      *
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'GPACSZBNK'
     C                   EVAL      DBFILE = 'GZSDBANKPD'
     C                   EVAL      DBKEY = PRtcd
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      SRUNA = BJMRDT
      *
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2011
**  ErrMsgAr
Option not valid. You can only enter 1 or 2
Entry not a valid entry on file
