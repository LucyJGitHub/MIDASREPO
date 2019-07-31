     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Fiduciary Taking Charges Module')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing  Module                         *
      *                                                               *
      *  MMFIDTCHG - MM Fiduciary Taking Charges Module               *
      *                                                               *
      *  Function:  This module computes for fiduciary taking charges.*
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027A            Date 09May06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDL006 - Dealing Fiduciary                                   *
      *                                                               *
      *****************************************************************
     FDLCCGDL0  IF   E           K DISK    INFSR(*PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,PSDS
 
     D                 DS
     D  ZRA                    1    112P 0
     D                                     DIM(14)
     D  FDSTU1                 1      8P 0
     D  FDSTU2                 9     16P 0
     D  FDSTU3                17     24P 0
     D  FDSTU4                25     32P 0
     D  FDSTU5                33     40P 0
     D  FDSTU6                41     48P 0
     D  FDSTU7                49     56P 0
     D  FDSTU8                57     64P 0
     D  FDSTU9                65     72P 0
     D  FDST10                73     80P 0
     D  FDST11                81     88P 0
     D  FDST12                89     96P 0
     D  FDST13                97    104P 0
     D  FDST14               105    112P 0
     D                 DS
     D  ZFL                    1    120P 0
     D                                     DIM(15)
     D  FDFC01                 1      8P 0
     D  FDFC02                 9     16P 0
     D  FDFC03                17     24P 0
     D  FDFC04                25     32P 0
     D  FDFC05                33     40P 0
     D  FDFC06                41     48P 0
     D  FDFC07                49     56P 0
     D  FDFC08                57     64P 0
     D  FDFC09                65     72P 0
     D  FDFC10                73     80P 0
     D  FDFC11                81     88P 0
     D  FDFC12                89     96P 0
     D  FDFC13                97    104P 0
     D  FDFC14               105    112P 0
     D  FDFC15               113    120P 0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structure for bank details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External data structure for customer details
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** External data structure for deal details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** Third DS for access programs, very long data structure
 
      *****************************************************************
      *                                                               *
      *    Main Routine                                               *
      *                                                               *
      *****************************************************************
 
      ** Define KLIST to access DLCCGDL0
 
     C     WWDLCC        KLIST
     C                   KFLD                    WWCCY             3
     C                   KFLD                    FDCCOM
 
      ** Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   Z-ADD     001           DBASE                          ************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DBERR 01 *
     C                   MOVEL     '*FIRST'      DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Deal Details
 
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   Z-ADD     002           DBASE                          ************
     C                   MOVEL     'SDDEALPD'    DBFILE                         * DBERR 02 *
     C                   MOVEL     '*FIRST'      DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      CUSTNO        WCUST            10
 
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WCUST         @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSLDY
 
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     003           DBASE                          ************
     C                   MOVEL     'SDCUSTPD'    DBFILE                         * DBERR 03 *
     C                   MOVEL     CUSTNO        DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     BBCHRG        IFEQ      *BLANKS
     C                   EXSR      SRTERM
     C                   ENDIF
 
     C     BNCTBC        IFEQ      'Y'
     C                   MOVE      BJCYCD        WWCCY
     C                   ELSE
     C                   MOVE      DEALCURRENCY  WWCCY
     C                   ENDIF
     C                   MOVE      CHARGECODE    FDCCOM
     C     WWDLCC        CHAIN     DLCCGDL0                           90
 
     C     *IN90         IFEQ      *ON
 
     C     *LOCK         IN        LDA
     C                   Z-ADD     004           DBASE                          ************
     C                   MOVEL     WWCCY         DBKEY                          * DBERR 04 *
     C                   MOVE      FDCCOM        DBKEY                          ************
     C                   MOVEL     'DLCCGDL0'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   MOVE      FDCHNR        CHARGEDESC
 
     C     BNCTBC        IFEQ      'Y'
     C     DEALCURRENCY  ANDNE     BJCYCD
 
      ** Convert the amounts,
      ** Details of BJCYCD (base currency)
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BJCYCD        WKEY1             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     005           DBASE                          ************
     C                   MOVEL     BJCYCD        DBKEY                          * DBERR 05 *
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     'MMFIDTCHG'   DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     A6NBDP        ZCDPI
     C                   MOVE      BJCYCD        ZCCYI
 
      ** Details  of deal currency
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DEALCURRENCY  WKEY1
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     006           DBASE                          ************
     C                   MOVEL     DEALCURRENCY  DBKEY                          * DBERR 06 *
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     'MMFIDTCHG'   DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     A6SPRT        ZEXCH
     C                   MOVE      A6MDIN        ZMD
     C                   MOVE      DEALCURRENCY  ZCCYO
     C                   MOVE      A6NBDP        ZCDPO
 
      ** Conversion amounts from base currency to deal currency
 
     C                   DO        14            X                 2 0
     C     ZRA(X)        IFNE      *ZERO
     C                   Z-ADD     ZRA(X)        ZAMTCI
     C                   Z-ADD     *ZEROS        ZAMTCO
 
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
 
     C                   Z-ADD     ZAMTCO        ZRA(X)
     C                   ENDIF
     C                   ENDDO
 
     C                   Z-ADD     FDMNCH        WMNCH
     C                   Z-ADD     FDMXCH        WMXCH
 
     C                   ENDIF
     C                   ENDIF
 
     C                   Z-ADD     *ZEROS        ZZ                2 0
 
      ** Loop until limit found
 
     C                   MOVE      *BLANK        ZFLAG             1
     C     ZFLAG         DOUEQ     'Y'
     C                   ADD       1             ZZ
 
      ** Range number reaches the limit
 
     C     ZZ            IFEQ      15
     C                   MOVE      'Y'           ZFLAG
     C                   LEAVE
     C                   ENDIF
 
      ** Amount less than the range limit
 
     C     AMOUNT        IFLE      ZRA(ZZ)
     C                   MOVE      'Y'           ZFLAG
     C                   ENDIF
 
      ** Range limit is zero
 
     C     ZRA(ZZ)       IFEQ      *ZERO
     C                   MOVE      'Y'           ZFLAG
     C                   ENDIF
     C                   ENDDO
 
     C     BNCTBC        IFEQ      'Y'
     C     DEALCURRENCY  ANDNE     BJCYCD
 
      ** Convert Flat charge level
 
     C                   Z-ADD     0             WCHAM            15 0
     C     ZFL(ZZ)       IFNE      0
     C                   Z-ADD     ZFL(ZZ)       ZAMTCI
     C                   Z-ADD     *ZEROS        ZAMTCO
 
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM                    ZAMTCO
 
     C                   Z-ADD     ZAMTCO        WCHAM
     C                   ENDIF
 
      ** Convert Minimum Charge
 
     C                   Z-ADD     0             WMNCH            15 0
     C     FDMNCH        IFNE      0
     C                   Z-ADD     FDMNCH        ZAMTCI
     C                   Z-ADD     *ZEROS        ZAMTCO
 
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM                    ZAMTCO
 
     C                   Z-ADD     ZAMTCO        WMNCH
     C                   ENDIF
 
      ** Convert Maximum Charge
 
     C                   Z-ADD     0             WMXCH            15 0
     C     FDMXCH        IFNE      0
     C                   Z-ADD     FDMXCH        ZAMTCI
     C                   Z-ADD     *ZEROS        ZAMTCO
 
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM                    ZAMTCO
 
     C                   Z-ADD     ZAMTCO        WMXCH
     C                   ENDIF
 
     C                   ELSE
     C                   Z-ADD     ZFL(ZZ)       WCHAM
     C                   Z-ADD     FDMNCH        WMNCH
     C                   Z-ADD     FDMXCH        WMXCH
     C                   ENDIF
 
     C     WCHAM         IFLT      WMNCH
     C                   Z-ADD     WMNCH         WCHAM
     C                   ELSE
     C     WCHAM         IFGT      WMXCH
     C     WMXCH         ANDNE     0
     C                   Z-ADD     WMXCH         WCHAM
     C                   ENDIF
     C                   ENDIF
 
     C                   Z-ADD     WCHAM         CHARGEAMT
 
     C                   EXSR      SRTERM
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR : Entry Parameters                                     *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    #PGM             10
     C                   PARM                    ACTIONCODE        1
     C                   PARM                    DEALNO            6 0
     C**********         PARM                    CUSTNO            6 0                       CSD027A
     C                   PARM                    CUSTNO            6                         CSD027A
     C                   PARM                    DEALCURRENCY      3
     C                   PARM                    AMOUNT           13 0
     C                   PARM                    CHARGECODE        2
     C                   PARM                    CHARGEDESC       20
     C                   PARM                    CHARGEAMT        13 0
     C                   PARM                    @RTCD             7
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTERM : Termination Subroutine                               *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRTERM        BEGSR
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
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
      * Called by: Main Routine                                       *
      *                                                               *
      * Calls: DBERRCTL                                               *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
