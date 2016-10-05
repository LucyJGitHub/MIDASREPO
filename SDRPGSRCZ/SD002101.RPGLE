     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Commodity Details Maintenance')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD002101 - Midas SD Commodity Details Maintenance            *
      *                                                               *
      *  Function : This program maintains commodity details record   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CSW216             Date 14Mar16               *
      *  Prev Amend No. CSW215             Date 06Apr15               *
      *                 CMG003  *CREATE    Date 04Oct12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSW216 - SWIFT Changes 2016                                  *
      *  CSW215 - SWIFT Changes 2015                                  *
      *  CMG003 - SWIFT MT600 Message Generation                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSD002101DFCF   E             WORKSTN
      ** Midas SD Commodity Details Maintenance
 
     FSDCMDTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS1)
     F                                     USROPN
     F                                     COMMIT
      ** Midas SD Commodity Details Update
 
     FSDCURRL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Currency codes retrieval
 
     FSDCMSHL0  UF A E           K DISK    COMMIT
     F                                     RENAME(SDCMDTD0:SDCMSHD0)
      ** Commodity Details Shadow file
 
     FSDCUSHL1  IF   E           K DISK
      ** Currency Details Shadow file
 
     FSDCMTPPD  IF   E           K DISK
      ** Commodity Types File
 
     FSDCMUNPD  IF   E           K DISK
      ** Commodity Units File
 
     FSDPMRTPD  IF   E           K DISK
      ** Precious Metal Currencies File
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D AENA            S             78    DIM(5) CTDATA PERRCD(1)
     D A@CPY           DS
     D  CPY@                   1     80    DIM(1) CTDATA PERRCD(1)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank details
 
     D LDA           E DS           256    EXTNAME(LDA)
     D  SPAREX       E                     EXTFLD(SPARE)
      ** Local data area for database error details
 
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      ** Program data structure
 
     D JBDTTM          DS
     D  ##JDT                  1      7  0
     D  ##JCC                  1      1  0
     D  ##JYY                  2      3  0
     D  ##JMM                  4      5  0
     D  ##JDD                  6      7  0
     D  ##JTM                  8     13  0
     D  ##JHH                  8      9  0
     D  ##JNN                 10     11  0
     D  ##JSS                 12     13  0
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
 
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** File information data structure
 
     D @1DBRC        E DS                  EXTNAME(SDCMDTL0)
      ** UPD : Midas SD Currency codes update
 
     D #1DBRC          DS          9999
     D  #1DB1                  1      1
      ** Current/previous master file format fields for change control
 
     D YBRDCS          DS          9999
 
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First data structure for Access Programs, Short DS
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second data structure for Access Programs, long DS
 
     D P1PARM          DS             4
     D  P1CYCD                 1      3
     D  P1ANCD                 4      4
 
     D P2PARM          DS
     D  P2FNSC                 1      1
 
     D P3PARM          DS
     D  P3ANCD                 1      1
 
     D P4PARM          DS            12
     D  WOCYCD                 1      3
     D  WOSWCY                 4      6
     D  WNCYCD                 7      9
     D  WNSWCY                10     12
     D                 DS
     D  ZAMSDA                 1    132
     D  ZA0001                 1      4
      ** Message data for 'Commodity Type'
 
     D  ZA0002                 1     25
      ** Message data for 'Commodity Type Description'
 
     D  ZA0003                 1      4
      ** Message data for 'Denomination'
 
     D  ZA0004                 1      8
      ** Message data for 'Form'
 
     D  ZA0005                 1      3
      ** Message data for 'Unit'
 
     D  ZA0006                 1     30
      ** Message data for 'Unit Details'
 
     D DATA            DS          1024
     D  #1CMSN                 1     10
 
     D                 DS
     D  SVAL1                  1    200
     D  SVAL11                 1      1
      ** Data structure for AOSVALR0 string
 
     D                 DS
     D  SVALK1                 1     20    INZ('AuthReqCurrencyMaint')
 
     D PTimestamp      S               Z
     D WOCMSH          S             10
     D SWIFTchars      C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ-
     D                                     abcdefghijklmnopqrstuvwxyz-
     D                                     0123456789 /-?:().,''+'
     D AlphaUP         C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D CSW215          S              1A                                                      CSW215
     D CSW216          S              1A                                                      CSW216
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM
     C     P2FNSC        PARM                    WP0001            1
     C     P3ANCD        PARM                    WP0002            1
     C                   PARM                    P4PARM
 
      ** Initialize
 
     C                   EXSR      ZZINIT
 
      ** Check passed parameters
 
     C                   EXSR      FACKPM
 
      ** Perform once if all passed, else repeat
 
     C     W0RPT         DOUEQ     'N'
 
      ** Display and process key screen
 
     C                   EXSR      BADSKY
 
     C                   ENDDO
 
      ** Terminate program
 
     C                   EXSR      ZXEXPG
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BADSKY - Display and process key screen                      *
      *                                                               *
      *****************************************************************
     C     BADSKY        BEGSR
 
      ** Initialize key screen
 
     C                   MOVEL     P1CYCD        #1CYCD
     C                   MOVEL     'Y'           W0BYP             1
 
      ** Signal start of transaction
 
     C                   MOVEL     'Y'           W0TRN             1
     C                   DOW       W0TRN = 'Y' OR W0TRN = 'K'
 
      ** Ensure transaction continues (if reset)
 
     C                   MOVEL     'Y'           W0TRN
 
     C                   DOW       W0TRN = 'Y'
 
     C                   IF        W0BYP = 'Y'
     C                   IF        #1CYCD = *BLANKS OR *IN05 = '1'
     C                   MOVEL     'N'           W0BYP
     C                   ENDIF
     C                   ENDIF
 
      ** Bypass key screen
 
     C                   IF        W0BYP <> 'Y'
     C                   EXSR      BBEXFM
     C                   ENDIF
 
     C                   MOVEL     'N'           W0BYP
 
      ** Process response to key screen
 
     C   03              CAS                     ZXEXPG
     C   09              CAS                     BCCHMD
     C   05              CAS                     BDHMKY
     C                   CAS                     BEPRKY
     C                   ENDCS
 
     C                   DOW       W0TRN = 'R'
     C                   MOVEL     'Y'           W0TRN
     C                   EXSR      BEPRKY
     C                   ENDDO
 
     C                   ENDDO
     C                   ENDDO
 
     C     BAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BBEXFM - Display key screen and process HELP requests        *
      *                                                               *
      *****************************************************************
     C     BBEXFM        BEGSR
 
      ** Set screen conditioning indicators
 
     C     W0PMD         COMP      'ADD'                                  89
 
      ** Update screen time
 
     C                   TIME                    ##TME
     C                   DOU       W0HLP = 'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
 
      ** PUTOVR unless conditioned fields change
 
     C                   SETON                                            86
     C                   IF        *IN89 <> BBIN89
     C                   SETOFF                                           86
     C                   ENDIF
     C                   MOVE      *IN89         BBIN89            1
 
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDKEY
 
      ** Test cursor
 
     C                   EXSR      Y8TST
 
      ** Clear set cursor DDS indicator
 
     C                   IF        WCSRLC = 'OFF'
     C                   SETOFF                                       94
     C                   ENDIF
 
     C                   MOVE      *BLANK        WCSRLC
 
      ** If help requested, display help text
 
     C   25              EXSR      ZHHPKY
     C                   ENDDO
 
      ** Update job time
 
     C                   TIME                    ##JTM
 
      ** Clear messages from program message queue
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
 
     C                   MOVEL     'Y'           ZAFSMS            1
     C                   SETOFF                                           98
 
     C     BBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BCCHMD - Switch between *ADD/*CHANGE modes                   *
      *                                                               *
      *****************************************************************
     C     BCCHMD        BEGSR
 
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'CHG'         W0PMD             3
     C                   ELSE
     C                   MOVEL     'ADD'         W0PMD
     C                   ENDIF
 
     C     BCEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BDHMKY - Process HOME key                                    *
      *                                                               *
      *****************************************************************
     C     BDHMKY        BEGSR
 
     C                   MOVEL     'N'           W0TRN
 
     C     BDEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BEPRKY - Process key screen input                            *
      *                                                               *
      *****************************************************************
     C     BEPRKY        BEGSR
 
      ** Initialise detail screen
 
     C                   EXSR      MAIZ#1
 
      ** Validate key fields
 
     C                   EXSR      BFVLKY
 
     C     *IN98         CABEQ     '1'           BEEXIT
 
      ** Check for existing record for Currency
 
     C     KRTV          KLIST
     C                   KFLD                    A6CYCD
     C                   MOVEL     #1CYCD        A6CYCD
     C                   IF        CSD012 = 'Y' AND SVAL11 = 'Y'
     C                             AND P3ANCD <> 'D'
     C     KRTV          CHAIN     SDCUSHD0                           9091
     C                   ELSE
     C     KRTV          CHAIN     @A6REA3                            9091
     C                   ENDIF
 
     C                   IF        *IN91 = '1'
     C                   SETON                                        9831
     C                   GOTO      BEEXIT
     C                   ENDIF
     C
     C                   IF        *IN90 = *ON
 
      ** Send message '*Record no longer on file'
 
     C                   MOVEL     'Y2U0009'     W0RTN             7
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      BEEXIT
 
     C                   ELSE
 
      ** Check for existing record for Commodity
 
     C                   EXSR      SRCOMDFT
 
     C     #1CMSN        CHAIN     SDCMDTL0                           9091
     C                   ENDIF
     C
     C                   EVAL      P1ANCD = P3ANCD
 
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'ADD'         W0PMD
     C                   IF        P3ANCD = 'A'
     C                   EVAL      P1ANCD = 'I'
     C                   ENDIF
 
      ** USER: Initialize detail screen (new record)
      ** Currency DTL footer - Standard Functions  *
 
     C                   SELECT
     C                   WHEN      WUACWK = 'E'
     C                   MOVEA     AENA(1)       ##CTX1
     C                   WHEN      WUACWK = 'F'
     C                   MOVEA     AENA(3)       ##CTX1
     C                   WHEN      WUACWK = 'I'
     C                   MOVEA     AENA(5)       ##CTX1
     C                   ENDSL
 
     C                   ELSE
 
     C                   MOVEL     'CHG'         W0PMD
 
      ** Load screen fields from DBF
 
     C                   EXSR      MBFL#1
 
      ** CALC: Detail screen function fields
      ** USER: Initialize detail screen (existing record)
      ** CASE: PAR.Action Code is Delete
 
     C                   IF        P3ANCD = 'D'
     C                   IF        P2FNSC = 'C'
     C                   MOVEL     'F'           WUACWK
     C                   ELSE
     C                   MOVEL     'E'           WUACWK
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'I'           WUACWK
     C                   ENDIF
 
      ** Currency DTL footer - Standard Functions  *
 
     C                   SELECT
     C                   WHEN      WUACWK = 'E'
     C                   MOVEA     AENA(1)       ##CTX1
     C                   WHEN      WUACWK = 'F'
     C                   MOVEA     AENA(3)       ##CTX1
     C                   WHEN      WUACWK = 'I'
     C                   MOVEA     AENA(5)       ##CTX1
     C                   ENDSL
 
     C                   ENDIF
 
     C   98              GOTO      BEEXIT
 
      ** No error: Display and process details
 
     C                   EXSR      CADSDA
 
 
     C     BEEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BFVLKY - Validate key fields                                 *
      *                                                               *
      *****************************************************************
     C     BFVLKY        BEGSR
 
     C                   IF        W0PMD <> 'ADD'
     C                   EXSR      VACKRL
     C                   ENDIF
 
      ** USER: Validate key screen
      ** Currency Code required
 
     C     #1CYCD        IFEQ      *BLANK
     C                   SETON                                        9831
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
 
     C     BFEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CADSDA - Display and process detail screen                   *
      *                                                               *
      *****************************************************************
     C     CADSDA        BEGSR
 
      ** Conduct detail screen conversation
      ** Repeat until screen control flag is reset:
 
     C                   DOW       W0TRN = 'Y'
 
      ** Display detail screen
 
     C                   EXSR      CBEXFM
 
     C   03              CAS                     ZXEXPG
     C   12              CAS                     CCDSPV
     C   05              CAS                     CCDSPV
     C                   CAS                     CFPRSC
     C                   END
 
     C     W0TRN         IFEQ      'R'
     C     W0PMD         IFEQ      'ADD'
     C                   EXSR      MAIZ#1
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C     CAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CBEXFM - Display screen and process HELP requests            *
      *                                                               *
      *****************************************************************
     C     CBEXFM        BEGSR
 
     C                   EXSR      GBDSAD
 
      ** Update screen time
 
     C                   TIME                    ##TME
 
     C                   DOU       W0HLP = 'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
 
     C                   SETON                                            86
     C                   IF        *IN89 <> CBIN89
     C                   SETOFF                                           86
     C                   ENDIF
 
     C                   MOVE      *IN89         CBIN89            1
 
      ** Display screen
 
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
 
     C                   EXSR      Y8TST
 
     C                   IF        WCSRLC = 'OFF'
     C                   SETOFF                                       94
     C                   ENDIF
 
     C                   MOVE      *BLANK        WCSRLC
     C   25              EXSR      ZHHPKY
     C                   ENDDO
 
     C                   TIME                    ##JTM
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
 
     C                   MOVEL     'Y'           ZAFSMS            1
     C                   SETOFF                                           98
 
     C     CBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CCDSPV - Redisplay previous screen                           *
      *                                                               *
      *****************************************************************
     C     CCDSPV        BEGSR
 
      ** USER: Process key screen request
 
     C                   MOVEL     'USR0790'     P0RTN
     C                   EXSR      ZYEXPG
     C   05              MOVEL     'R'           W0TRN
     C   12              MOVEL     'K'           W0TRN
 
     C     CCEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CFPRSC - Validate Commodity fields details                   *
      *                                                               *
      *****************************************************************
     C     CFPRSC        BEGSR
 
     C                   MOVEL     'N'           W0DCF             1
     C                   EXSR      DCVLDL
 
      ** QUIT if error:
      ** Defer confirm/update requested
      ** No error: update record
 
     C   98              GOTO      CFEXIT
     C     W0DCF         CABEQ     'Y'           CFEXIT
     C                   EXSR      EBPR##
 
     C     CFEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DCVLDL - Validate Commodity details                          *
      *                                                               *
      *****************************************************************
     C     DCVLDL        BEGSR
 
      ** USER: Validate detail screen fields
      ** CASE: DTL.*CMD key is *Delete
 
     C                   IF        *IN10 = '1'
     C                   IF        P3ANCD = 'D'
     C                   MOVEL     'Y'           W0DCF
     C                   MOVEL     'DEL'         P0RTN
     C                   EXSR      ZYEXPG
     C                   ELSE
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
     C                   ENDIF
 
      ** CASE: DTL.*CMD key is Further Records
 
     C                   IF        *IN08 = '1'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      DCEXIT
     C                   ENDIF
 
      ** CALC: Detail screen function fields
      ** USER: Validate detail screen relations
      ** Commodity Type
 
     C                   IF        #1CMTP = *BLANKS
 
      ** Type: Entry is mandatory
 
     C                   MOVEL     #1CMTP        ZA0001
     C                   MOVEL     'USR4835'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9835
 
     C                   ELSE
 
      **Type: Entry must be uppercase alphabetic characters
 
     C     AlphaUP       CHECK     #1CMTP                                 54
     C                   IF        *IN54 = *ON
     C                   MOVEL     #1CMTP        ZA0001
     C                   MOVEL     'USR4836'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9835
     C                   ENDIF
     C                   ENDIF
 
      ** Commodity Type description
      ** Default Type Description
 
     C     #1CMTP        SETLL     SDCMTPPD                           90
     C     #1CMTP        CHAIN     SDCMTPPD                           90
     C                   IF        *IN90 = *OFF
     C                   EVAL      #1CMTD = A7CMTD
     C                   SETON                                        4243
     C                   ELSE
 
      ** Type Description: Entry is mandatory
 
     C                   IF        #1CMTD = *BLANKS
     C                   MOVEL     #1CMTD        ZA0002
     C                   MOVEL     'USR4837'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9836
     C                   ENDIF
     C                   ENDIF
 
      ** Denomination
 
     C                   IF        #1CMDN <> *BLANKS
     C     SWIFTchars    CHECK     #1CMDN                                 54
 
      ** Denomination: Entry must be valid SWIFT characters
 
     C                   IF        *IN54 = *ON
     C                   MOVEL     #1CMDN        ZA0003
     C                   MOVEL     'USR4838'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9837
     C                   ENDIF
     C                   ENDIF
 
      ** Form
 
     C                   IF        #1CMFM <> *BLANKS
 
      ** Form: Entry must be valid SWIFT characters
 
     C     SWIFTchars    CHECK     #1CMFM                                 54
     C                   IF        *IN54 = *ON
     C                   MOVEL     #1CMFM        ZA0004
     C                   MOVEL     'USR4825'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9838
     C                   ENDIF
     C                   ENDIF
 
      ** Unit
 
     C                   IF        #1CMUN = *BLANKS
 
      ** Unit: Entry is mandatory
 
     C                   MOVEL     #1CMUN        ZA0005
     C                   MOVEL     'USR4826'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9839
     C                   ELSE
 
      ** If valid entry, default description
 
     C     #1CMUN        SETLL     SDCMUNPD                           90
     C     #1CMUN        CHAIN     SDCMUNPD                           90
     C                   IF        *IN90 = *OFF
     C                   EVAL      #1CMUN = A7CMUN
     C                   EVAL      #1CMUT = A7CMUT
 
      ** Unit: Entry can't be GOZ or TOZ for GOLD
 
     C                   IF        #1CMTP = 'GOLD'
     C                             AND (#1CMUN = 'GOZ' OR #1CMUN = 'TOZ')
     C                   MOVEL     #1CMUN        ZA0005
     C                   MOVEL     'USR4828'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9839
     C                   ENDIF
 
      ** Unit: Entry must not be FOZ or TOZ for PALL, PLAT and SILV                           CSW216
                                                                                              CSW216
     C                   IF        CSW216 = 'Y'                                               CSW216
     C                   IF        (#1CMTP = 'PALL' OR #1CMTP = 'PLAT'                        CSW216
     C                             OR #1CMTP = 'SILV')                                        CSW216
     C                             AND (#1CMUN = 'FOZ' OR #1CMUN = 'TOZ')                     CSW216
     C                   MOVEL     #1CMUN        ZA0005                                       CSW216
     C                   MOVEL     'USS0667'     ZAMSID                                       CSW216
     C                   EXSR      ZASNMS                                                     CSW216
     C                   SETON                                        9839                    CSW216
     C                   ENDIF                                                                CSW216
     C                   ELSE                                                                 CSW216
                                                                                              CSW216
      ** Unit: Entry must be GOZ for PALL, PLAT and SILV                                      CSW215
                                                                                              CSW215
     C                   IF        CSW215 = 'Y'                                               CSW215
     C                   IF        (#1CMTP = 'PALL' OR #1CMTP = 'PLAT'                        CSW215
     C                             OR #1CMTP = 'SILV')                                        CSW215
     C                             AND #1CMUN <> 'GOZ'                                        CSW215
     C                   MOVEL     #1CMUN        ZA0005                                       CSW215
     C                   MOVEL     'USR4842'     ZAMSID                                       CSW215
     C                   EXSR      ZASNMS                                                     CSW215
     C                   SETON                                        9839                    CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
     C                   ENDIF                                                                CSW216
     C                   ELSE
 
      ** Unit: Entry must be a valid code
 
     C                   MOVEL     #1CMUN        ZA0005
     C                   MOVEL     'USR4827'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9839
     C                   ENDIF
     C                   ENDIF
 
      ** Unit detail
 
     C                   IF        #1CMUD <> *BLANKS
 
      ** Unit Detail: Entry must be valid SWIFT characters
 
     C     SWIFTchars    CHECK     #1CMUD                                 54
     C                   IF        *IN54 = *ON
     C                   MOVEL     #1CMUD        ZA0006
     C                   MOVEL     'USR4830'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9841
     C                   ENDIF
     C                   ELSE
 
      ** Unit Details: Entry is mandatory if Unit=OTH
 
     C                   IF        #1CMUN = 'OTH'
     C                   MOVEL     #1CMUD        ZA0006
     C                   MOVEL     'USR4829'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9841
     C                   ENDIF
     C                   ENDIF
 
     C     DCEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  EBPR## - Process Commmodity records                          *
      *                                                               *
      *****************************************************************
     C     EBPR##        BEGSR
 
      ** Process add/update request
 
     C     W0PMD         CASEQ     'ADD'         ECADRQ
     C     W0PMD         CASNE     'ADD'         EECHRQ
     C                   ENDCS
 
     C                   IF        W0RTN <> *BLANKS
     C                   MOVEL     'Y2U0018'     P0RTN
     C                   EXSR      ZYEXPG
     C                   ENDIF
 
     C                   IF        W0RTN = *BLANKS
 
      ** USER: Process command keys
      ** CASE: DTL.*CMD key is *Key screen
 
     C                   IF        *IN12 = '1'
     C                   MOVEL     'Y'           W0DCF
     C                   MOVEL     'USR0790'     P0RTN
     C                   EXSR      ZYEXPG
     C                   ELSE
 
      ** CASE: DTL.*CMD key is *Exit
 
     C                   IF        *IN03 = '1'
     C                   MOVEL     'Y'           W0DCF
     C                   MOVEL     'Y2U9999'     P0RTN
     C                   EXSR      ZYEXPG
     C                   ELSE
 
      ** CASE: DTL.*CMD key is Further Records
 
     C                   IF        *IN08 = '1'
     C                   IF        P3ANCD <> 'D'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   GOTO      EBEXIT
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        W0PMD = 'ADD'
     C                   MOVEL     'N'           W0RPT
     C                   ENDIF
 
     C                   MOVEL     'N'           W0TRN
     C                   ENDIF
 
     C     EBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ECADRQ - Process add request                                 *
      *                                                               *
      *****************************************************************
     C     ECADRQ        BEGSR
 
      ** USER: Create DBF record
 
     C                   EXSR      SACRRC
     C                   IF        W0RTN = *BLANKS
 
      ** Send message '*Record added'
 
     C                   MOVEL     'Y2U0011'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   COMMIT
     C                   ENDIF
 
     C     ECEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  EECHRQ - Process update request                              *
      *                                                               *
      *****************************************************************
     C     EECHRQ        BEGSR
 
      ** USER: Change DBF record
 
     C                   EXSR      SCCHRC
     C                   IF        W0RTN <> *BLANKS
 
      ** Data update error
      ** Reset screen fields if changed record
 
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1
     C                   ENDCS
     C                   ELSE
 
      ** Send message '*Record changed'
 
     C                   MOVEL     'Y2U0012'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   COMMIT
     C                   ENDIF
 
     C     EEEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FACKPM - Check passed parameters                             *
      *                                                               *
      *****************************************************************
     C     FACKPM        BEGSR
 
      ** Is full key present?
 
     C     P1CYCD        IFEQ      *BLANK
     C                   MOVEL     'Y'           W0RPT             1
     C                   ELSE
     C                   MOVEL     'N'           W0RPT
     C                   ENDIF
 
     C     FAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GADSAK - Set key screen conditioning indicators              *
      *                                                               *
      *****************************************************************
     C     GADSAK        BEGSR
 
     C     W0PMD         COMP      'ADD'                                  89
 
     C     GAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GBDSAD - Set detail screen conditioning indicators           *
      *                                                               *
      *****************************************************************
     C     GBDSAD        BEGSR
 
     C     W0PMD         COMP      'ADD'                                  89
 
      ** Protect key fields on detail screen
      ** Enable key screen
 
     C     P3ANCD        COMP      'D'                                    44
     C                   SETON                                        8788
 
     C     GBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MAIZ#1 - Initialise Commodity screen fields                  *
      *                                                               *
      *****************************************************************
     C     MAIZ#1        BEGSR
 
     C                   EVAL      #1CMSN = *BLANKS
     C                   EVAL      #1CMSC = *BLANKS
     C                   EVAL      #1CMTP = *BLANKS
     C                   EVAL      #1CMTD = *BLANKS
     C                   EVAL      #1CMDN = *BLANKS
     C                   EVAL      #1CMFM = *BLANKS
     C                   EVAL      #1CMUN = *BLANKS
     C                   EVAL      #1CMUT = *BLANKS
     C                   EVAL      #1CMUD = *BLANKS
 
     C     MAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MBFL#1 - Move Commodity file details to screen fields        *
      *                                                               *
      *****************************************************************
     C     MBFL#1        BEGSR
 
     C                   EVAL      #1CMSN = A6CMSN
     C                   EVAL      #1CMSC = A6CMSC
     C                   EVAL      #1CMTP = A6CMTP
     C                   EVAL      #1CMTD = A6CMTD
     C                   EVAL      #1CMDN = A6CMDN
     C                   EVAL      #1CMFM = A6CMFM
     C                   EVAL      #1CMUN = A6CMUN
     C                   EVAL      #1CMUT = A6CMUT
     C                   EVAL      #1CMUD = A6CMUD
 
      ** Hold existing record image
 
     C                   MOVEL     @1DBRC        #1DBRC
 
     C     MBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SACRRC - Write to Commodity Details File                     *
      *                                                               *
      *****************************************************************
     C     SACRRC        BEGSR
 
     C                   MOVEL     *BLANK        W0RTN             7
 
     C                   EVAL      A6CMSN = #1CMSN
     C                   EVAL      A6CMCC = A6CYCD
     C                   EVAL      A6CMSC = #1CMSC
     C                   EVAL      A6CMTP = #1CMTP
     C                   EVAL      A6CMTD = #1CMTD
     C                   EVAL      A6CMDN = #1CMDN
     C                   EVAL      A6CMFM = #1CMFM
     C                   EVAL      A6CMUN = #1CMUN
     C                   EVAL      A6CMUT = #1CMUT
     C                   EVAL      A6CMUD = #1CMUD
 
     C                   CALL      'ZAGENTS'
     C                   PARM                    PTimestamp
     C                   EVAL      A6CMTS = PTimestamp
     C                   EVAL      A6CMLD = RDNB
     C                   EVAL      A6CMJN = %CHAR(##JNO)
     C                   EVAL      A6CMJM = ##JOB
     C                   EVAL      A6CMJU = ##USR
     C                   EVAL      A6CZON = BJZONE
     C                   EVAL      A6CMLT = P1ANCD
 
      ** CASE: WRK.Window processing requir. is Yes
 
     C                   IF        WUWDPR = 'Y'
     C                   CALL      'WN0010'
     C                   PARM      ##PGM         UPGM             10
     C                   PARM      *BLANK        UFKEY             2
     C                   PARM      'I'           UACTCD            1
     C                   PARM                    DATA
     C                   PARM      *BLANK        W0RTN
     C                   PARM                    SPARE           256
 
      ** CASE: PAR.*Return code is *User QUIT requested
 
     C                   IF        W0RTN = 'Y2U9999'
     C                   MOVEL     W0RTN         P0RTN
     C                   EXSR      ZYEXPG
     C                   ELSE
 
      ** CASE: PAR.*Return code is WN Window Error
 
     C                   IF        W0RTN = 'USR0563'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      SAEXIT
     C                   ELSE
 
      ** CASE: PAR.*Return code is *DBF update error
 
     C                   IF        W0RTN = 'Y2U0004'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      SAEXIT
     C                   ELSE
 
      ** CASE: PAR.*Return code is *Previous Screen
 
     C                   IF        W0RTN = 'USR0790'
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      SAEXIT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     KLCRSA        KLIST
     C                   KFLD                    A6CMSN
 
     C     KLCRSA        SETLL     SDCMDTD0                               90
 
     C                   IF        *IN90 = '1'
     C                   MOVEL     'USR4834'     W0RTN             7
 
      ** Send message 'Commodity Shortname: Duplicate key found.'
 
     C                   MOVEL     'USR4834'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      SAEXIT
     C                   ENDIF
 
      ** If CSD012 is ON and Currencies is ON, output
      ** details to Shadow file.
 
     C                   IF        CSD012 = 'Y' AND SVAL11 = 'Y'
     C                   WRITE     SDCMSHD0                             91
     C                   IF        WOSWCY <> WNSWCY
     C                   EVAL      WOCMSH = WOCYCD + '-' + WOSWCY
     C     WOCMSH        SETLL     SDCMSHD0                           91
     C     WOCMSH        CHAIN     SDCMSHD0                           91
     C                   IF        *IN91 = '1'
     C     WOCMSH        CHAIN     SDCMDTD0                           91
     C                   IF        *IN91 = '0'
     C                   EVAL      A6CMLT = 'D'
     C                   WRITE     SDCMSHD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   WRITE     SDCMDTD0                             91
     C                   IF        WOSWCY <> WNSWCY
     C                   EVAL      WOCMSH = WOCYCD + '-' + WOSWCY
     C     WOCMSH        SETLL     SDCMDTD0                           91
     C     WOCMSH        CHAIN     SDCMDTD0                           91
     C                   IF        *IN91 = '0'
     C                   DELETE    SDCMDTD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Write error detected
 
     C                   IF        *IN91 = '1'
     C                   MOVEL     'Y2U0004'     W0RTN
     C                   ENDIF
 
     C     SAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SCCHRC - Update to Commodity Details File                    *
      *                                                               *
      *****************************************************************
     C     SCCHRC        BEGSR
 
     C                   MOVEL     *BLANK        W0RTN             7
     C                   MOVE      'N'           YBRDC             1
 
     C                   MOVEL     #1CMSN        A6CMSN
     C     KLCHSC        KLIST
     C                   KFLD                    A6CMSN
 
     C     KLCHSC        CHAIN     SDCMDTD0                           9091
 
     C                   IF        *IN90 = '1'
     C                   MOVEL     'Y2U0009'     W0RTN             7
 
      ** Send message '*Record no longer on file'
 
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   ENDIF
 
     C                   IF        *IN91 = '1'
     C                   MOVEL     'Y2U0004'     W0RTN
     C                   GOTO      SCEXIT
     C                   ENDIF
 
      ** Check for changed record
 
     C     #1DBRC        IFNE      @1DBRC
     C                   MOVEL     'Y2U0007'     W0RTN
 
      ** Send message '*Update not accepted'
 
     C                   MOVEL     'Y2U0007'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   UNLOCK    SDCMDTL0                             91
     C                   GOTO      SCEXIT
     C                   ENDIF
 
 
     C                   MOVE      @1DBRC        YBRDCS
     C                   EVAL      A6CMSN = #1CMSN
     C                   EVAL      A6CMSC = #1CMSC
     C                   EVAL      A6CMTP = #1CMTP
     C                   EVAL      A6CMTD = #1CMTD
     C                   EVAL      A6CMDN = #1CMDN
     C                   EVAL      A6CMFM = #1CMFM
     C                   EVAL      A6CMUN = #1CMUN
     C                   EVAL      A6CMUT = #1CMUT
     C                   EVAL      A6CMUD = #1CMUD
 
     C                   CALL      'ZAGENTS'
     C                   PARM                    PTimestamp
     C                   EVAL      A6CMTS = PTimestamp
     C                   EVAL      A6CMLD = RDNB
     C                   EVAL      A6CMJN = %CHAR(##JNO)
     C                   EVAL      A6CMJM = ##JOB
     C                   EVAL      A6CMJU = ##USR
     C                   EVAL      A6CZON = BJZONE
     C                   EVAL      A6CMLT = P1ANCD
 
     C                   IF        @1DBRC <> YBRDCS
     C                   MOVE      'Y'           YBRDC
     C                   ENDIF
 
      ** USER: Processing before Data update
      ** CASE: WRK.Window processing requir. is Yes
 
     C                   IF        WUWDPR = 'Y'
     C                   CALL      'WN0010'
     C                   PARM      ##PGM         UPGM             10
     C                   PARM      *BLANK        UFKEY             2
     C                   PARM      'A'           UACTCD            1
     C                   PARM                    DATA
     C                   PARM      *BLANK        W0RTN
     C                   PARM                    SPARE           256
 
      ** CASE: PAR.*Return code is *User QUIT requested
 
     C     W0RTN         IFEQ      'Y2U9999'
     C                   MOVEL     W0RTN         P0RTN
     C                   EXSR      ZYEXPG
     C                   ELSE
 
     C     W0RTN         IFEQ      'USR0563'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
      *
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      SCEXIT
     C                   ELSE
 
      ** CASE: PAR.*Return code is *DBF update error
 
     C                   IF        W0RTN = 'Y2U0004'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        98
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      SCEXIT
     C                   ELSE
 
      ** CASE: PAR.*Return code is *Previous Screen
 
     C                   IF        W0RTN = 'USR0790'
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      SCEXIT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        @1DBRC <> YBRDCS
     C                   MOVE      'Y'           YBRDC
     C                   ENDIF
 
      ** If changed update record otherwise release record
 
     C     YBRDC         IFEQ      'Y'
 
      ** If CSD012 is ON and Currencies is ON, output
      ** details to Shadow file.
 
     C                   IF        CSD012 = 'Y' AND SVAL11 = 'Y'
     C                   WRITE     SDCMSHD0                             91
     C                   ELSE
     C                   UPDATE    SDCMDTD0                             91
     C                   ENDIF
     C                   ELSE
     C                   UNLOCK    SDCMDTL0                             91
     C                   ENDIF
 
      ** Change error detected
 
     C     *IN91         IFEQ      '1'
     C                   MOVEL     'Y2U0004'     W0RTN
     C                   ELSE
     C                   MOVEL     @1DBRC        #1DBRC
     C                   ENDIF
 
     C     SCEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VACKRL - Select existing record                              *
      *                                                               *
      *****************************************************************
     C     VACKRL        BEGSR
 
     C                   MOVEL     #1CYCD        WK1X01            1
 
     C                   IF        WK1X01 = '?'
     C                   CALL      'SD0020S'                            90
     C                   PARM      *BLANK        W0RTN             7
     C     #1CYCD        PARM      #1CYCD        WQ0001            3
 
     C                   IF        *IN90 = '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0020S'     W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      ** Error detected?
 
     C                   IF        W0RTN <> *BLANKS AND W0RTN <> 'Y2U0016'
     C                   SETON                                        9831
     C                   ENDIF
     C                   MOVEL     'Y'           W0DCF
     C                   ENDIF
 
     C     VAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCOMDFT - Default initial details for Commodity             *
      *                                                               *
      *****************************************************************
     C     SRCOMDFT      BEGSR
 
      ** Commodity Shortname
      ** ISO Currency Code
 
     C                   EVAL      #1CMSN = A6CYCD + '-' + A6SWCY
     C                   EVAL      #1CMSC = A6SWCY
 
      ** Commodity Type
      ** Commodity Type description
 
     C     A6SWCY        SETLL     SDPMRTPD                           90
     C     A6SWCY        CHAIN     SDPMRTPD                           90
     C                   IF        *IN90 = '0'
     C                   EVAL      #1CMTP = A7CTYP
     C                   SETON                                        42
 
     C     #1CMTP        SETLL     SDCMTPPD                           90
     C     #1CMTP        CHAIN     SDCMTPPD                           90
 
     C                   IF        *IN90 = *OFF
     C                   EVAL      #1CMTD = A7CMTD
     C                   SETON                                        43
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Y8TST - Test cursor                                          *
      *                                                               *
      *****************************************************************
     C     Y8TST         BEGSR
 
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
 
     C     Y8EXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS- Send message to program's message queue              *
      *                                                               *
      *****************************************************************
     C     ZASNMS        BEGSR
 
     C                   IF        ZAPGMQ = *BLANKS
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
 
      ** If no message file specified, use default
 
     C                   IF        ZAMSGF = *BLANKS
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   ENDIF
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
 
      ** Clear all fields for default mechanism next time
 
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
 
     C     ZAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZHHPKY - Display HELP text                                   *
      *                                                               *
      *****************************************************************
     C     ZHHPKY        BEGSR
 
     C                   MOVEL     'Y'           W0HLP             1
 
      ** Extract cursor row and column
 
     C     @#RWCL        DIV       256           ZHCSRW            5 0
     C                   MVR                     ZHCSCL            5 0
 
      ** Save cursor position for redisplay
 
     C                   Z-ADD     ZHCSRW        ZZCSRW            3 0
     C                   Z-ADD     ZHCSCL        ZZCSCL            3 0
 
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10
     C                   PARM      *BLANK        YYHPFL           10
     C                   PARM      *BLANK        YYHPLB           10
     C                   PARM                    W0RTN             7
     C                   PARM      '*START'      YYHLVN           10
     C                   PARM      '*NORMAL'     YYUSOP           10
     C                   PARM      ZHCSRW        YYRW              5 0
     C                   PARM      ZHCSCL        YYCL              5 0
     C                   PARM      1             YYLGCT            5 0
     C                   PARM      W0GRP         YYLGVN           10
 
      ** Clear set cursor DDS indicator
 
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94
 
     C     ZHEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZXEXPG - Cancel and exit from key screen                     *
      *                                                               *
      *****************************************************************
     C     ZXEXPG        BEGSR
 
      ** USER: Exit program processing
      ** CASE: KEY.*CMD key is *Exit
 
     C                   IF        *IN03 = '1'
     C                   MOVEL     'Y2U9999'     P0RTN
     C                   EXSR      ZYEXPG
     C                   ENDIF
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
 
     C     ZXEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZYEXPG - Exit program: Direct                                *
      *                                                               *
      *****************************************************************
     C     ZYEXPG        BEGSR
 
      ** Terminate program
      ** Exit program
     C                   SETON                                        LR
     C                   RETURN
 
     C     ZYEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZZINIT - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     ZZINIT        BEGSR
 
     C     *DTAARA       DEFINE                  LDA
     C                   IF        W0ICL = *BLANKS
     C                   MOVEL     'Y'           W0ICL             1
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   ENDIF
 
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
     C                   MOVEL     *ZEROS        W0RTW             9 0
     C                   MOVEL     '400'         W0ENV             3
 
     C                   Z-ADD     UDATE         ##JDT
 
      ** Set century digit (If YY prior to 1940 treat as 20YY)
 
     C                   IF        ##JYY < 40
     C                   Z-ADD     1             ##JCC
     C                   ELSE
     C                   Z-ADD     0             ##JCC
     C                   ENDIF
 
     C                   TIME                    ##JTM
     C                   TIME                    ##TME             6 0
     C                   MOVEL     *BLANK        WUACWK            1
 
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
 
     C                   MOVEL     *BLANK        WUWDPR            1
     C                   MOVEL     *BLANK        WUMRDT            7
     C                   Z-ADD     *ZERO         WURDNB            5 0
     C                   MOVEL     *BLANK        WUSUC             1
     C                   MOVEL     *BLANK        WUDFF             1
     C                   MOVEL     *BLANK        WUMBIN            1
     C                   MOVE      *BLANK        WCSRLC            3
     C                   MOVEL     *BLANKS       W0CFL            10
     C                   Z-ADD     *ZEROS        W0CRW             5 0
     C                   Z-ADD     *ZEROS        W0CCL             5 0
     C                   MOVE      @1FFL         ZZFFL            10
     C                   MOVE      @1FLB         ZZFLB            10
     C                   MOVE      @1FMB         ZZFMB            10
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
 
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21
 
     C                   OPEN      SDCMDTL0
 
      ** Select initial mode
 
     C                   IF        @1NROP = *ZERO
     C                   MOVEL     'ADD'         W0PMD             3
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD
     C                   ENDIF
 
     C                   MOVEL     *BLANK        W0GRP             1
 
      ** USER: Initialize program
      ** Copyright Statement 1999 - Standard Functions  * copyright
      ** Get Rundate - Rundate  *
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB
     C                   MOVE      SUC           WUSUC
     C                   MOVE      DFF           WUDFF
     C                   MOVE      MBIN          WUMBIN
 
      ** CASE: PAR.Action Code is Delete
      ** CASE: PAR.Final Screen is Comm
 
     C     P3ANCD        IFEQ      'D'
     C     P2FNSC        IFEQ      'C'
     C                   MOVEL     'F'           WUACWK
     C                   ELSE
     C                   MOVEL     'E'           WUACWK
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'I'           WUACWK
     C                   ENDIF
 
      ** Currency DTL footer - Standard Functions  *
 
     C                   SELECT
     C                   WHEN      WUACWK = 'E'
     C                   MOVEA     AENA(1)       ##CTX1
     C                   WHEN      WUACWK = 'F'
     C                   MOVEA     AENA(3)       ##CTX1
     C                   WHEN      WUACWK = 'I'
     C                   MOVEA     AENA(5)       ##CTX1
     C                   ENDSL
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Check if CSD012 is switched on
 
     C                   CALL      'AOSARDR0'
     C                   PARM                    PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CSD012'      PSARD             6
      *
     C                   IF        PRTCD = *BLANKS
     C                   MOVE      'Y'           CSD012            1
     C                   ELSE
     C                   MOVE      'N'           CSD012
     C                   ENDIF
 
      ** Check if Commodity Authorisation is on
 
     C                   IF        CSD012 = 'Y'
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       RTNCDE            7
     C                   PARM                    SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM                    SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM                    SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK0           20
     C                   PARM                    SVAL10          200
 
     C                   IF        RTNCDE <> *BLANKS
     C                   IF        SVAL1 = '*NRF'
     C                   MOVE      SVALK1        DBKEY
     C                   ENDIF
 
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVE      'SDSVALPD'    DBFILE
     C                   MOVE      'SD002101'    DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CSW215
      ** Check if CSW215 is installed                                                         CSW215
                                                                                              CSW215
     C                   EVAL      CSW215 = 'N'                                               CSW215
     C                   CALL      'SWIF2015'                                                 CSW215
     C                   PARM      *BLANKS       PRTCD                                        CSW215
                                                                                              CSW215
     C                   IF        PRTCD = 'CSW2015'                                          CSW215
     C                   EVAL      CSW215 = 'Y'                                               CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW216
      ** Check if CSW216 is installed                                                         CSW216
                                                                                              CSW216
     C                   EVAL      CSW216 = 'N'                                               CSW216
     C                   CALL      'SWIF2016'                                                 CSW216
     C                   PARM      *BLANKS       PRTCD                                        CSW216
                                                                                              CSW216
     C                   IF        PRTCD = 'CSW2016'                                          CSW216
     C                   EVAL      CSW216 = 'Y'                                               CSW216
     C                   ENDIF                                                                CSW216
 
     C     ZZEXIT        ENDSR
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
 
     C                   DUMP
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   CALL      'DBERRCTL'
     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  AENA
F3=Main Menu   F8=Further Details   F10=Delete   F12=Previous
F3=Main Menu   F8=Further Details   F10=Delete
F3=Main Menu   F10=Delete   F12=Previous
F3=Main Menu
F3=Main Menu   F12=Previous
**  CPY@
(c) Misys International Banking Systems Ltd. 2012
