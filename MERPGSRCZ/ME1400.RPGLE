     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058081
/**** *  RPGSQLBND                                                    *            MD058081 MD062018
/*STD *  RPGBASEBND                                                   *                     MD062018
/*EXI *  TEXT('Midas ME Access SWIFT BIC identifier info')            *
     F*****************************************************************
     F*                                                               *
     F*  Midas - Message Management Module
     F*                                                               *
     F*  ME1400 - Access SWIFT BIC Identifier Information             *
     F*                                                               *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD062018           Date 27Oct23               *
      *  Prev Amend No. MD058081           Date 11May21               *
      *                 260931             Date 25Nov15               *
      *                 MD046248           Date 27Oct17               *
      *                 MD040101           Date 11Aug16               *
      *                 MD036281           Date 26Oct15               *
      *                 MD019970           Date 19Aug14               *
      *                 MD027201           Date 26May14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG20280           Date 28Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 193630             Date 19Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 183583             Date 08Jun01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 101550             Date 09Jul96               *
      *                 099234             Date 09Jul96               *
     F*                 073187             DATE 21MAY96               *
     F*                 069250             DATE 03MAY94               *
     F*                 S01435             DATE 08NOV93               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD062018 - Performance issue with fTC0250. Replace SQL       *
      *             access by loading array.                          *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  260931 - Recompile due to changes in SDCUSTLS.               *
      *           Applied for MD-34062                                *
      *  MD046248 - Finastra Rebranding                               *
      *  MD040101 - Additional fix for MD-39405                       *
      *  MD036281 - Fusionbanking unable to recognise South African - *
      *             Australian Bank codes                             *
      *  MD019970 - Customer Details Amendment Error. Added validation*
      *             for MT3xx Corporate BEI.                          *
      *  MD027201 - Additional Beneficiary Validation                 *
      *  BUG20280 - Error in Amending Swift Identifier Field          *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  193630 - Use LF/SDCNSTL1 instead of LF/SDCNSTL0 to retrieve  *
      *           counterparty nostro details so that error CPF4293   *
      *           will not occur.                                     *
      *  183583 - Add extension file MGOEXTPD to store customer no.   *
      *           of field with SWIFT address.                        *
     F*  101550 - Add another chaining to SDCNSTPD for cases where    *
     F*           the BIC is not equal to blank and details are       *
     F*           found in this file.                                 *
     F*           (IF..ENDIF markers inserted for clarity.)           *
     F*  099234 - Add chaining to SDCNSTPD for cases where SWIFT      *
     F*           BIC is not equal to blank.                          *
     F*  073187 - Check if customer deleted                           *
     F*  069250 - Remove dummy OVRDBF command from creation parms.    *
     F*  S01435 - Incoming Message Management                         *
     F*                                                               *
     F*****************************************************************
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
/****F*:*OVRDBF*(File*in*program)*(file*on*system)******************:**   069250
     F*****************************************************************
     F*                                                               *
     F*  Indicator usage                                              *
     F*  ~~~~~~~~~~~~~~~                                              *
     F*                                                               *
     F*  50    First cycle                                            *
     F*  90    General work indicator                                 *
     F*                                                               *
     F*  U7/U8 Error Ocurred                                          *
     F*  LR    End program                                            *
     F*                                                               *
     F*****************************************************************
     FMEBICDL2  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
      *
      * RTV : SWIFT BIC Directory by SWIFT Identifier
      *
     FSDCUSTL7  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     RENAME(@CUSTGE:SDCUSTSW)
     FSDCUSTL5  IF   E           K DISK    USROPN                               183583
      *
      * RTV : Customer Details by SWIFT Identifier
      *
     FSDCNSTL2  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     RENAME(@CNSTLD:SDCNSTSW)
     F**SDCNSTL0IF  E         K        DISK                                            183583 193630
     FSDCNSTL1  IF   E           K DISK
     FSDCUSTLS  IF   E           K DISK    USROPN
     F*MEISOCL1* IF   E           K DISK                                                 MD MD058081
     FMEISOJW0  IT   F    2        DISK                                                     MD062018
      *
      * RTV : Counterparty Details by SWIFT identifier
      *
     F/COPY WNCPYSRC,ME1400DFPG
      *
      *  /Copy point for File Definition
      *
     F/EJECT
      *
      *  Copyright table
      *
     D/COPY WNCPYSRC,ME1400DEPG
      *
      *  /Copy point for Arrays
      *
     D*COPY*MECPYSRC,SRERRE                                                                 MD058081
     D/COPY MECPYSRC,SRERRELE                                                               MD058081
      *
      *  end of Copysource for error processing
      *
      ** Array of Commitment Job Names                                                        CSC022
     D CMTJOB          S             10    DIM(10)
      *                                                                                     MD027201
      ** BIC Validation Check                                                               MD027201
      *                                                                                     MD027201
     D ALPHA           S             26    DIM(1) CTDATA PERRCD(1)
     D ALPHN           S             36    DIM(1) CTDATA PERRCD(1)
     D XISO            S              2    DIM(999) FROMFILE(MEISOJW0)                      MD062018
     D/EJECT
     D/COPY WNCPYSRC,ME1400DIPG
      *
      *  /Copy point for Input specifications
      *
      *
     D CPYR@#          DS
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *
     D*COPY*MECPYSRC,SRERRI                                                                 MD058081
     D/COPY MECPYSRC,SRERRILE                                                               MD058081
      *
      *  End of Program Error Processing copysource member
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      *  Define rundat data area
      *
     D W0DTA1        E DS                  EXTNAME(SDCUSTPD)
      *
      *  Define Customer Details
      *
     D W0DTA2        E DS                  EXTNAME(SDCNSTPD)
      *
      *  Define Counterparty Details
      *
     D W0DTA3        E DS                  EXTNAME(MEBICDPD)
      *
      *  Define SWIFT BIC Directory
      *
     D MEISOC        E DS                  EXTNAME(MEISOJW0)                                MD058081
     D SCCMT           DS           256
     D  CMTNUM                 1      3  0
     D  CMTARR                 4    103
     D W0BICC          DS                                                                         MD
     D  WBNK                   1      4                                                           MD
     D  WCTY                   5      6                                                           MD
     D  WLOC                   7      8                                                           MD
     I/EJECT
      *****************************************************************
      *                 M A I N L I N E
      *****************************************************************
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      *  Define entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7
     C                   PARM                    W0BICC            8
     C                   PARM                    W0BICB            3
     C                   PARM                    W0DTA1
     C                   PARM                    W0DTA2
     C                   PARM                    W0DTA3
     C                   PARM                    W0CUST            1
     C                   PARM                    W0CNST            1
     C                   PARM                    W0BICD            1
      *
      * Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   END
      *
      *  Look up Customer Details
      *
     C                   EXSR      SRCUST
      *
      *  Look up Counterparty Details
      *
     C                   EXSR      SRCNST
      *
      *  Look up SWIFT Directory Details
      *
     C                   MOVEL     'Y'           ISBIC             1
     C     ALPHA(1)      CHECK     WBNK                                   95
     C     *IN95         IFEQ      '0'
     C*****WCTY          CHAIN     MEISOCL1                           95                    MD058081
     C*/EXEC*SQL                                                                   MD058081 MD062018
     C*+*SELECT**                                                                  MD058081 MD062018
     C*+*into*:MEISOC                                                              MD058081 MD062018
     C*+*from*MEISOJW0                                                             MD058081 MD062018
     C*+*where*M3ISOC = :WCTY                                                      MD058081 MD062018
     C*/END-EXEC                                                                   MD058081 MD062018
     C**********         IF        SQLCODE <> 0                                    MD058081 MD062018
     C**********         SETON                                        95           MD058081 MD062018
     C**********         ENDIF                                                     MD058081 MD062018
                                                                                            MD058081
     C     WCTY          LOOKUP    XISO                                   95                MD062018
     C******IN95         IFEQ      '0'                                                      MD062018
     C     *IN95         IFEQ      '1'                                                      MD062018
     C     ALPHN(1)      CHECK     WLOC                                   95
     C     *IN95         IFEQ      '0'
     C                   EXSR      SRBICD
     C                   ELSE
     C                   MOVE      'N'           ISBIC
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           ISBIC
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           ISBIC
     C                   ENDIF
      *
     C/COPY WNCPYSRC,ME1400C001
      *  Set up return code
      *
      *  If BIC Directory has records and no BIC found then
      *  return code will always be not found
      *
     C     ISBIC         IFEQ      'Y'
     C                   MOVEL     'Y2U0005'     W0RTN
     C                   ELSE
     C                   MOVEL     'FREEFMT'     W0RTN
     C**********           MOVEL'Y'       W0BICD                                   MD027201 MD036281
     C                   CLEAR                   W0DTA3
     C                   ENDIF
     C                   SELECT
      *
      *  Not on BIC directory but on Customer master file
      *
     C     ##BICD        WHENEQ    'Y'
     C     W0BICD        ANDNE     'Y'
     C     W0CUST        ANDEQ     'Y'
     C/COPY WNCPYSRC,ME1400C002
     C                   MOVEL     'MIN0244'     W0RTN
      *
      *  Not on BIC directory but on Counterparty Nostro file
      *
     C     ##BICD        WHENEQ    'Y'
     C     W0BICD        ANDNE     'Y'
     C     W0CNST        ANDEQ     'Y'
     C/COPY WNCPYSRC,ME1400C003
     C                   MOVEL     'MIN0245'     W0RTN
      *
      *  Not on BIC directory
      *
     C     ##BICD        WHENEQ    'Y'
     C     W0BICD        ANDNE     'Y'
     C/COPY WNCPYSRC,ME1400C004
     C                   MOVEL     'MIN0246'     W0RTN
      *                                                                                     MD019970
      *  Corporate BEI already exist in SDCUSTPD                                            MD019970
     C     W0CBEI        WHENEQ    'Y'
     C                   MOVEL     'MIN0247'     W0RTN
      *
      *  Found on one of the files
      *
     C     W0BICD        WHENEQ    'Y'
     C     W0CUST        OREQ      'Y'
     C     W0CNST        OREQ      'Y'
     C                   MOVEL     *BLANKS       W0RTN
     C                   ENDSL
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *  Return to calling program
      *
     C                   RETURN
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCUST   : Look up Customer Details                          *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCUST        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRCUST'      @STK(Q)
      *
      *  Clear W0DTA1 of data
      *
     C                   CLEAR                   W0DTA1
      *
      *  Access Customer details with key passed
      *
     C                   MOVEL     *BLANKS       BBCSID
     C                   MOVEL     W0BICC        BBCSID
     C                   MOVEL     *BLANKS       ##004             4
     C                   MOVEL     W0BICB        ##004
     C                   MOVE      ##004         BBCSID
      *
     C********** KCUST     CHAINSDCUSTSW             90                                     MD040101
     C     KCUST         SETLL     SDCUSTSW
     C     KCUST         READE     SDCUSTSW                               90
     C     *IN90         DOWEQ     *OFF
     C     BBDTDL        ANDNE     0
     C     KCUST         READE     SDCUSTSW                               90
     C                   ENDDO
     C                   MOVEL     *BLANKS       W0CUST
      *                                                                   073187
      * Record found and not deleted                                      073187
      *                                                                   073187
     C     *IN90         IFEQ      '0'
     C     BBDTDL        ANDEQ     0                                                           07318
     C                   MOVEL     'Y'           W0CUST            1
     C                   ELSE
      *
      * Address not found, if branch blank try XXX
      *
     C     W0BICB        IFEQ      *BLANKS
     C                   MOVE      'XXX '        BBCSID
      *
     C********** KCUST     CHAINSDCUSTSW             90                                     MD040101
     C     KCUST         SETLL     SDCUSTSW
     C     KCUST         READE     SDCUSTSW                               90
     C     *IN90         DOWEQ     *OFF
     C     BBDTDL        ANDNE     0
     C     KCUST         READE     SDCUSTSW                               90
     C                   ENDDO
     C                   MOVEL     *BLANKS       W0CUST
      *                                                                   073187
      * Record found and not deleted                                      073187
      *                                                                   073187
     C     *IN90         IFEQ      '0'
     C     BBDTDL        ANDEQ     0                                                           07318
     C                   MOVEL     'Y'           W0CUST
     C                   END
     C                   END
     C                   END
     C     W0CUST        IFNE      'Y'                                                         18358
     C                   MOVE      W0BICC        @FLD2             2                           18358
     C     @FLD2         IFEQ      '  '                                                        18358
     C                   MOVEL     W0BICC        @FLD6             6                           18358
     C     @FLD6         CHAIN     SDCUSTL5                           90                       18358
     C     *IN90         IFEQ      '0'                                                         18358
     C                   MOVEL     'Y'           W0CUST                                        18358
     C                   ENDIF                                                                 18358
     C                   ENDIF                                                                 18358
     C                   ENDIF                                                                 18358
      *                                                                                       CFT032
     C     CSW024        IFEQ      'Y'
     C     W0CUST        IFNE      'Y'
     C                   MOVE      *BLANKS       WBBCBE           11
     C     W0BICC        CAT       W0BICB:0      WBBCBE
     C     WBBCBE        CHAIN     SDCUSTLS                           90
     C     *IN90         IFEQ      '0'
     C     BBDTDL        ANDEQ     0
     C                   MOVEL     'Y'           W0CUST
     C                   ELSE
     C     W0BICB        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       WBBCBE
     C     W0BICC        CAT       'XXX':0       WBBCBE
     C     WBBCBE        CHAIN     SDCUSTLS                           90
     C     *IN90         IFEQ      '0'
     C     BBDTDL        ANDEQ     0
     C                   MOVEL     'Y'           W0CUST
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     EXCUST        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCNST   : Counterparty Nostro                               *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRCNST        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRCNST'      @STK(Q)
      *
      *  Clear W0DTA2 of data
      *
     C                   CLEAR                   W0DTA2
      *
      *  Access Counterparty details with key passed
      *
     C                   MOVEL     *BLANKS       AWSWID
     C                   MOVEL     W0BICC        AWSWID
     C                   MOVEL     *BLANKS       ##004             4
     C                   MOVEL     W0BICB        ##004
     C                   MOVE      ##004         BBCSID
      *
     C     KCNST         CHAIN     SDCNSTSW                           90
     C                   MOVEL     *BLANKS       W0CNST
     C     *IN90         IFEQ      '0'                                          B1
     C                   MOVEL     'Y'           W0CNST            1
      *                                                                   101550
      ** SWIFT ID is found, but CHAIN again if BIC is not blank to        101550
      ** get the correct details.                                         101550
      *                                                                   101550
     C     W0BICB        IFNE      *BLANKS                                       B2            10155
     C                   MOVEL     BBCSID        AWSWID                                        10155
     C     KCNST         CHAIN     SDCNSTSW                           90                       10155
     C     *IN90         IFEQ      '1'                                            B3           10155
     C                   MOVEL     *BLANKS       W0CNST                                        10155
     C                   ENDIF                                                    E3           10155
     C                   ENDIF                                                   E2            10155
      *                                                                   101550
     C                   ELSE                                                   X1
      *
      * Address not found, if branch blank try XXX
      *
     C     W0BICB        IFEQ      *BLANKS                                       B2
     C                   MOVE      'XXX '        AWSWID
     C     KCNST         CHAIN     SDCNSTSW                           90
     C                   MOVEL     *BLANKS       W0CNST
     C     *IN90         IFEQ      '0'                                            B3
     C                   MOVEL     'Y'           W0CNST
     C                   END                                                      E3
      *                                                                   099234
      ** Re-check address with branches not equal to blank                099234
      *                                                                   099234
     C                   ELSE                                                    X2            09923
     C                   MOVEL     *BLANKS       AWSWID                                        09923
     C                   MOVEL     BBCSID        AWSWID                                        09923
     C     KCNST         CHAIN     SDCNSTSW                           90                       09923
     C                   MOVEL     *BLANKS       W0CNST                                        09923
     C     *IN90         IFEQ      '0'                                            B3           09923
     C                   MOVEL     'Y'           W0CNST                                        09923
     C                   END                                                      E3           09923
     C                   END                                                     E2
     C                   END                                                    E1
     C     W0CNST        IFNE      'Y'                                                         18358
     C                   MOVEL     W0BICC        @FLD8             8                           18358
     C********** @FLD8     CHAINSDCNSTL0             90                   183583              193630
     C     @FLD8         CHAIN     SDCNSTL1                           90
     C     *IN90         IFEQ      '0'                                                         18358
     C                   MOVEL     'Y'           W0CNST                                        18358
     C                   ENDIF                                                                 18358
     C                   ENDIF                                                                 18358
      *
      *  Unwind subroutine stack name
      *
     C     EXCNST        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRBICD   : SWIFT Directory                                   *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRBICD        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRBICD'      @STK(Q)
      *
      *  Clear W0DTA3 of data
      *
     C                   CLEAR                   W0DTA3
      *
      *  If W0BICB is blank use 'XXX'
      *
     C                   MOVEL     W0BICC        BDBICC
     C                   MOVEL     W0BICB        BDBICB
     C     W0BICB        IFEQ      *BLANKS
     C                   MOVEL     'XXX'         BDBICB
     C                   END
      *
     C     KBIC          CHAIN     @BICDL2                            90
     C                   MOVEL     *BLANKS       W0BICD
     C     *IN90         IFEQ      '0'
     C                   MOVEL     'Y'           W0BICD            1
     C                   END
      *                                                                                     MD019970
     C     W0BICD        IFEQ      'Y'
     C                   MOVEL     'N'           W0CBEI            1
     C                   MOVE      *BLANKS       WBBCBE
     C     W0BICC        CAT       W0BICB:0      WBBCBE
     C     WBBCBE        CHAIN     SDCUSTLS                           90
     C     *IN90         IFEQ      '0'
     C     BBDTDL        ANDEQ     0
     C                   MOVEL     'Y'           W0CBEI
     C                   ENDIF
     C                   ENDIF
      *
      *  Unwind subroutine stack name
      *
     C     EXBICD        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SRINIT        BEGSR
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *  Indicate that set up is complete
      *
     C                   SETON                                        50
      *                                                                                       CSC022
      ** Check if CSC022 is switched *ON.                                                     CSC022
      *                                                                                       CSC022
     C     *DTAARA       DEFINE    SCCMTJOB      SCCMT
     C                   IN        SCCMT
      *                                                                                     BUG20280
      ** Array index error will occur if CSC022 is OFF                                      BUG20280
      ** and CSW024 is ON, initialisation of SCCMTJOB                                       BUG20280
      ** first, before checking CSC022 and CSW024                                           BUG20280
      *                                                                                     BUG20280
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSC022'      @SARD             6
      *                                                                                       CSC022
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC022            1
     C********** *NAMVAR   DEFN SCCMTJOB  SCCMT                                      CSC022 BUG20280
     C**********           IN   SCCMT                                                CSC022 BUG20280
     C                   Z-ADD     1             C                 3 0
     C                   MOVEL     *BLANKS       WCMTSK            1
     C                   MOVEA     CMTARR        CMTJOB
     C     CMTNUM        IFGT      0
     C     C             DOWLE     CMTNUM
     C     ##JOB         IFEQ      CMTJOB(C)
     C                   MOVEL     'Y'           WCMTSK
     C                   ENDIF
     C                   ADD       1             C
     C                   ENDDO
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           CSC022
     C                   ENDIF
      *                                                                                       CFT032
      ** Check if CSW024 is switched *ON.                                                     CFT032
      *                                                                                       CFT032
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSW024'      @SARD             6
      *                                                                                       CFT032
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSW024            1
     C                   Z-ADD     1             C                 3 0
     C                   MOVEL     *BLANKS       WCMTSK            1
     C                   MOVEA     CMTARR        CMTJOB
     C     CMTNUM        IFGT      0
     C     C             DOWLE     CMTNUM
     C     ##JOB         IFEQ      CMTJOB(C)
     C                   MOVEL     'Y'           WCMTSK
     C                   ENDIF
     C                   ADD       1             C
     C                   ENDDO
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           CSW024
     C                   ENDIF
      *
      *  Open files if not already open
      *
     C     FIL001        IFEQ      *BLANKS
     C                   OPEN      SDCUSTL7
     C                   OPEN      SDCUSTL5                                                    18358
     C                   OPEN      SDCNSTL2
     C                   OPEN      MEBICDL2
     C                   OPEN      SDCUSTLS
     C                   MOVEL     'Y'           FIL001            1
     C                   END
      *
      *  Define keys to files
      *
     C     KBIC          KLIST
     C                   KFLD                    BDBICC
     C                   KFLD                    BDBICB
     C     KCUST         KLIST
     C                   KFLD                    BBCSID
     C     KCNST         KLIST
     C                   KFLD                    AWSWID
      *
      *  Check MEBICDL2 for details
      *
     C                   MOVEL     *LOVAL        BDBICC
     C                   MOVEL     *LOVAL        BDBICB
     C     KBIC          SETLL     MEBICDL2
     C                   READ      @BICDL2                                90
     C                   MOVEL     *BLANKS       ##BICD
     C     *IN90         IFEQ      '0'
     C                   MOVEL     'Y'           ##BICD            1
     C                   END
      *
      *  Get Rundate information
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
     C/COPY WNCPYSRC,ME1400DCPG
      *
      *  /Copy point for Calculations
      *
     C/EJECT
      *
      *  File and Program Error Processing
      *
     C*COPY*MECPYSRC,SRERRC                                                                 MD058081
     C/COPY MECPYSRC,SRERRCLE                                                               MD058081
     C/EJECT
     C/COPY WNCPYSRC,ME1400DOPG
      *
      *  /Copy point for Outputs
      *
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA ALPHA
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**CTDATA ALPHN
ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890
