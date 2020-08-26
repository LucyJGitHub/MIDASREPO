     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE T&N Rate Override')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE200100 - Midas RE Rate Override                            *
      *                                                               *
      *  Function:  This program allow the user to change the balance *
      *             at which the rate is fixed.                       *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE015  *CREATE    Date 18Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of Indicators                                       *
      *                                                               *
      *       80      Chain indicator for SDBSHSPD                    *
      *       81      Chain indicator for SDBSRTPD                    *
      *       82      Chain indicator for REINTD                      *
      *       83      Chain indicator for REINHSPD                    *
      *                                                               *
      *****************************************************************
 
     FREINT     IF   E           K DISK
     F                                     IGNORE(REINTAF)
     F                                     IGNORE(REINTZF)
     FREINHSL0  IF   E           K DISK
     FSDBSRTL0  IF   E           K DISK
     FSDBSHSL1  IF   E           K DISK
 
      *****************************************************************
      /SPACE 3
      *****************************************************************
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D BAL             S             15  0 DIM(11)
     D RAT             S             11  7 DIM(11)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
     D PGMDS          SDS
     D  SPGM                   1     10
     D  SJOB                 244    253
     D  SUSER                254    263
 
     D                 DS
     D  HKEY                   1     12
     D  HBLANK                 1      1
     D  HTYPE                  2      3
     D  HSBTYP                 4      8
     D  HCURR                  9     11
     D  HD                    12     12
 
     D                 DS
     D  BALDS                  1     88
     D  BAL1                   1      8P 0
     D  BAL2                   9     16P 0
     D  BAL3                  17     24P 0
     D  BAL4                  25     32P 0
     D  BAL5                  33     40P 0
     D  BAL6                  41     48P 0
     D  BAL7                  49     56P 0
     D  BAL8                  57     64P 0
     D  BAL9                  65     72P 0
     D  BAL10                 73     80P 0
     D  BAL11                 81     88P 0
 
     D                 DS
     D  RATDS                  1     66
     D  RAT1                   1      6P 7
     D  RAT2                   7     12P 7
     D  RAT3                  13     18P 7
     D  RAT4                  19     24P 7
     D  RAT5                  25     30P 7
     D  RAT6                  31     36P 7
     D  RAT7                  37     42P 7
     D  RAT8                  43     48P 7
     D  RAT9                  49     54P 7
     D  RAT10                 55     60P 7
     D  RAT11                 61     66P 7
 
     D #BALN           S             15  0
     D*#INTY****       S              2  0                                                    CSD103
     D #INTY           S              2                                                       CSD103
     D #INSB           S              5  0
     D #VDAT           S              5  0
 
     IREINTDF
     I              RECI                        HRECI
     I              BRT                         HBRT
     I              INTH                        HINTH
     I              RAT2                        HRAT2
     I              BAL2                        HBAL2
 
      *****************************************************************
     C/EJECT
      *****************************************************************
 
      ** Parameter list
 
     C     *ENTRY        PLIST
     C                   PARM                    RETCODE           7
     C                   PARM                    PCCY              3
     C**********         PARM                    PDIC              2 0                        CSD103
     C                   PARM                    PDIC              2                          CSD103
     C                   PARM                    PDST              5 0
     C                   PARM                    PDNIR             1
     C**********         PARM                    PCIC              2 0                        CSD103
     C                   PARM                    PCIC              2                          CSD103
     C                   PARM                    PCST              5 0
     C                   PARM                    PCNIR             1
     C                   PARM                    PVDT              5 0
     C                   PARM                    PDRCR             2
     C                   PARM                    PBALN            15 0
     C                   PARM                    PRAT             11 7
 
      ** Initialise data
 
     C                   EXSR      INIT
     C                   EXSR      GETRAT
 
      ** Exit from program
 
     C                   SETON                                        LR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Init - Initialise fields                                     *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     INIT          BEGSR
 
     C     BASKEY        KLIST
     C                   KFLD                    BSCCY             3
     C                   KFLD                    BSRAT             2
 
     C     BASKE2        KLIST
     C                   KFLD                    HSCCY             3
     C**********         KFLD                    HSRAT             2 0                        CSD103
     C                   KFLD                    HSRAT             2                          CSD103
     C                   KFLD                    HVDAT             5 0
 
     C     H2KEY         KLIST
     C                   KFLD                    HKEY
     C                   KFLD                    H2VDPC            5 0
 
     C                   MOVE      *BLANKS       RETCODE
     C                   Z-ADD     PBALN         WBALN            15 0
     C                   Z-ADD     *ZERO         PRAT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GETRAT - Get the corresponding threshold + base rate         *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:     GETRA2                                            *
      *                                                               *
      *****************************************************************
 
     C     GETRAT        BEGSR
 
      ** If Credit Interest type/subtype specified and periodic fixing
 
     C*****PCIC*         IFNE      0                                                          CSD103
     C     PCIC          IFNE      *BLANKS                                                    CSD103
     C     PCNIR         ANDEQ     'P'
 
      ** If balance is negative then in credit
 
     C     PDRCR         IFEQ      'CR'
     C**********         Z-ADD     PCIC          #INTY                                        CSD103
     C                   MOVE      PCIC          #INTY                                        CSD103
     C                   Z-ADD     PCST          #INSB
     C                   EXSR      GETRA2
     C                   ENDIF
     C                   ENDIF
 
      ** If Debit Interest type/subtype specified and periodic fixing
 
     C*****PDIC*         IFNE      0                                                          CSD103
     C     PDIC          IFNE      *BLANKS                                                    CSD103
     C     PDNIR         ANDEQ     'P'
 
      ** If balance is positive then in debit
 
     C     PDRCR         IFEQ      'DR'
     C**********         Z-ADD     PDIC          #INTY                                        CSD103
     C                   MOVE      PDIC          #INTY                                        CSD103
     C                   Z-ADD     PDST          #INSB
     C                   EXSR      GETRA2
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GETRA2 - Get the corresponding threshold + base rate         *
      *                                                               *
      *  Called By: GETRAT                                            *
      *                                                               *
      *  Calls:     GETINT, GETBAS, GETTHR                            *
      *                                                               *
      *****************************************************************
 
     C     GETRA2        BEGSR
 
      ** Calculate threshold rate based on balance
 
     C                   MOVE      WBALN         #BALN
     C                   MOVE      #BALN         PBALN
     C**********         MOVE      #INTY         PINTY             2 0                        CSD103
     C                   MOVE      #INTY         PINTY             2                          CSD103
     C                   MOVE      #INSB         PINSB             5 0
     C                   MOVE      PVDT          #VDAT
     C                   MOVE      #VDAT         PVDAT             5 0
     C                   Z-ADD     PBALN         BALMOD           15 0
 
      ** Get Interest Details
 
     C                   EXSR      GETINT
 
      ** Rate is zero if less than or equal to initial threshold
 
     C     BALMOD        IFGT      HINTH
 
      ** Get Base rate
 
     C                   EXSR      GETBAS
 
      ** Get threshold rate
 
     C                   EXSR      GETTHR
 
      ** Final rate is Base rate + threshold rate
 
     C     BASRAT        ADD       THRRAT        PRAT
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GETINT - Get interest details                                *
      *                                                               *
      *  Called By: GETRA2                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     GETINT        BEGSR
 
     C                   MOVE      *BLANKS       HBLANK
     C                   MOVE(P)   PINTY         HTYPE
     C                   MOVE(P)   PINSB         HSBTYP
     C                   MOVE(P)   PCCY          HCURR
     C                   MOVE      'D'           HD
 
     C     HKEY          CHAIN     REINT                              82
 
      ** move in balance fields and update records
 
     C     *IN82         IFEQ      '0'
     C     VDPC          ANDLE     PVDAT
     C                   MOVEL     HBAL2         BALDS
     C                   MOVEL     HRAT2         RATDS
     C                   ELSE
 
      ** If base rate
      ** not found, or value date earlier, use historic base rate.
 
     C                   Z-ADD     PVDAT         H2VDPC
     C     H2KEY         SETGT     REINHSL0                           83
     C     HKEY          READPE    REINHSL0                               83
 
     C     *IN83         IFEQ      '1'
 
     C                   MOVE      '*NOREC'      RETCODE
     C                   RETURN
 
     C                   ELSE
 
      ** move in historic balance fields and update records
 
     C                   MOVEL     H@BAL2        BALDS
     C                   MOVEL     H@RAT2        RATDS
     C                   Z-ADD     H@INTH        HINTH
     C                   ENDIF
     C                   ENDIF
 
     C                   Z-ADD     BAL1          BAL(1)
     C                   Z-ADD     BAL2          BAL(2)
     C                   Z-ADD     BAL3          BAL(3)
     C                   Z-ADD     BAL4          BAL(4)
     C                   Z-ADD     BAL5          BAL(5)
     C                   Z-ADD     BAL6          BAL(6)
     C                   Z-ADD     BAL7          BAL(7)
     C                   Z-ADD     BAL8          BAL(8)
     C                   Z-ADD     BAL9          BAL(9)
     C                   Z-ADD     BAL10         BAL(10)
     C                   Z-ADD     BAL11         BAL(11)
 
     C                   Z-ADD     RAT1          RAT(1)
     C                   Z-ADD     RAT2          RAT(2)
     C                   Z-ADD     RAT3          RAT(3)
     C                   Z-ADD     RAT4          RAT(4)
     C                   Z-ADD     RAT5          RAT(5)
     C                   Z-ADD     RAT6          RAT(6)
     C                   Z-ADD     RAT7          RAT(7)
     C                   Z-ADD     RAT8          RAT(8)
     C                   Z-ADD     RAT9          RAT(9)
     C                   Z-ADD     RAT10         RAT(10)
     C                   Z-ADD     RAT11         RAT(11)
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GETBAS - Get base Rate if specified                          *
      *                                                               *
      *  Called By: GETRA2                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     GETBAS        BEGSR
 
     C                   Z-ADD     0             BASRAT           11 7
     C*****HBRT*         IFNE      0                                                          CSD103
     C     HBRT          IFNE      *BLANKS                                                    CSD103
 
     C                   MOVE      PCCY          BSCCY
     C                   MOVE      HBRT          BSRAT
     C     BASKEY        CHAIN     SDBSRTL0                           81
 
      ** If base rate
      ** not found, or value date earlier, use historic base rate.
 
     C     *IN81         IFEQ      '1'
     C     BAVDNR        ORGT      PVDAT
 
     C                   MOVE      PCCY          HSCCY
     C                   MOVE      HBRT          HSRAT
     C                   Z-ADD     PVDAT         HVDAT
     C     BASKE2        SETLL     SDBSHSL1                           80
     C     BASKE2        READE     SDBSHSL1                               80
     C     *IN80         DOWEQ     '0'
     C     G0HIDT        ANDGT     PVDAT
     C     BASKE2        READPE    SDBSHSL1                               80
     C                   ENDDO
 
     C     *IN80         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVEL     'SDBSRTL0'    DBFILE
     C                   MOVEL     BSCCY         DBKEY
     C                   MOVE      BSRAT         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     G0CBSR        BASRAT
     C                   ENDIF
 
     C                   ELSE
 
     C                   Z-ADD     BACBSR        BASRAT
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GETTHR - Get threshold rate                                  *
      *                                                               *
      *  Called By: GETRA2                                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
 
     C     GETTHR        BEGSR
 
     C                   Z-ADD     0             THRRAT           11 7
     C                   Z-ADD     1             Z                 2 0
 
      ** Go through through each threhold level until balance is within
      ** threshold. The threshold rate will be the last rate stored.
 
     C     Z             DOWLE     11
     C     BALMOD        ANDGT     BAL(Z)
 
     C     BAL(Z)        IFNE      0
     C     Z             OREQ      1
     C                   Z-ADD     RAT(Z)        THRRAT           11 7
     C                   ENDIF
 
     C                   ADD       1             Z
     C                   ENDDO
 
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
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   MOVE      '*ERROR'      RETCODE
     C                   SETON                                        U7U8LR
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   RETURN
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************