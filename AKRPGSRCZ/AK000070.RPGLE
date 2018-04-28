     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AK Forecast Transactions A/C keys generation')   *
      *****************************************************************
      *                                                               *
      *  Midas - Account Key Generator                                *
      *                                                               *
      *  AK000070 - Forecast Transtions Account Keys Generator        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. AR1071025          Date 16Jan13               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CLE042             Date 06Sep05               *
      *                 CDL038             Date 10May05               *
      *                 CAS010             Date 09Feb05               *
      *                 228474             Date 21Jul04               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1071025 - Erroneous field will only highlight after the    *
      *              second enter (Recompile)                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CAS010 - IAS + PB Enhancements Upgrade to Midasplus          *
      *           (Recompile)                                         *
      *  228474 - Allow FH-subtype combination if subtype is a valid  *
      *           deal type or loan type.                             *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FAK000070DFCF   E             WORKSTN
      ** Midas AK SD Account Keys Work File
 
     FZACKEYAL  O  A E           K DISK    INFSR(*PSSR)
      ** Midas AK SD Account Keys Work File
 
     F***FDDTSTL1  IF   E           K DISK                                                    228474
      ***Midas*FD*Deal*type/subtype*file******************************                        228474
 
     FSDLOANL1  IF   E           K DISK
      ** Midas Loan Types/Sub-types Retrieval Index
 
     FSDACODL0  IF   E           K DISK
      ** Midas SD Account codes - update index
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Program status data structure
     D/COPY ZACPYSRC,PSDS
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Deal Types Array                                                                     228474
     D DLTYP           S              2A   DIM(22) CTDATA                                     228474
                                                                                              228474
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
      ** Data structure for ZACKEYAL fields
     D SDZACKEY      E DS                  EXTNAME(ZACKEYAL)
     D***WFTyp*****************2      3                                                       CDL038
     D***WEventD***************4      4                                                       CDL038
     D***WSTyp*****************5      6                                                       CDL038
     D***WAmtD****************11     11                                                       CDL038
     D***WCodes***************12     53                                                       CDL038
     D   WFTyp               158    159                                                       CDL038
     D   WEventD             160    160                                                       CDL038
     D   WSTyp               161    162                                                       CDL038
     D   WAmtD               167    167                                                       CDL038
     D   WCodes               14     55                                                       CDL038
 
      ** Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Bank details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters used for Y2CLMSC
 
     D PZAPGM                        10
     D PZAPGRL                        5
     D PZAMSID                        7
     D PZAMSGF                       10
     D PZAMSDA                      132
     D PZAMSTP                        7
 
      ** Parameters used for AOBANKR0
 
     D PRTCD                          7
     D POPTN                          7
 
     D WScr2Err                       1
     D WLDTYP                         2
     D WSTYPE                         2
     D WIdx                           2P 0                                                    228474
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   DOU       *IN03 = *ON
     C                             OR WScr2Err = 'N'
 
     C                   WRITE     #MSGCTL
     C                   EXFMT     ACKEYSF
 
      ** Clear messages from program message queue
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      SPGMQ         PZAPGM
     C                   PARM      '*SAME'       PZAPGRL
 
      ** Validate initial screen if F3 is not pressed
 
     C                   IF        *IN03 = *OFF
 
      ** Initialize screen 1 error indicators
 
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
 
      ** Check if subtype is a valid Deal or Loan type
 
     C                   IF        #1STYP = *BLANKS
     C                   EVAL      *IN25 = *ON
     C                   ELSE
     C**********         EVAL      WLDTYP = 'FH'                                              228474
     C**********         EVAL      WSTYPE = #1STYP                                            228474
     C*****KLDTST        CHAIN     SDLOANL1                                                   228474
     C*****KLDTST        CHAIN     FDDTSTL1                                                   228474
                                                                                              228474
     C                   EVAL      WLDTYP = #1STYP                                            228474
     C                   EVAL      WIdx = %LOOKUP(WLDTYP : DLTYP)                             228474
                                                                                              228474
      ** If not a deal type, check if loan type                                               228474
                                                                                              228474
     C                   IF        WIdx = *ZERO                                               228474
     C     WLDTYP        CHAIN     SDLOANL1                           25                      228474
     C                   ENDIF                                                                228474
                                                                                              228474
     C                   ENDIF
 
      ** Send error message "Sub-type must be a valid Deal or Loan
      ** Type" and turn on screen 1 error indicator
 
     C                   IF        *IN25 = *ON
     C**********                   OR NOT %FOUND(SDLOANL1)                                    228474
     C**********                   AND NOT %FOUND(FDDTSTL1)                                   228474
     C                   EVAL      *IN26  = *ON
     C                   EVAL      PZAMSID = 'USR4295'
     C                   EXSR      SRZASNMS
     C                   ENDIF
 
      ** If no errors, display and validate second screen
 
     C                   IF        *IN26 = *OFF
     C                   EXSR      SRSCRN2
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDDO
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCRN2 - Subroutine to display and validate screen 2        *
      *                                                               *
      *****************************************************************
     C     SRSCRN2       BEGSR
 
      ** Blank out previous values entered
 
     C                   EVAL      #1PrcpAC = *BLANKS
     C                   EVAL      #1PCtrAC = *BLANKS
 
      ** Initialize screen error indicator
 
     C                   EVAL      *IN28 = *OFF
     C                   EVAL      *IN29 = *OFF
 
      ** Display screen 2 until F3 or F12 is pressed, or all screen
      ** fields has been validated
 
     C                   DOU       *IN03 = *ON
     C                             OR *IN12 = *ON
     C                             OR WScr2Err = 'N'
 
     C                   EVAL      *IN03 = *OFF
     C                   EVAL      *IN12 = *OFF
 
     C                   WRITE     #MSGCTL
     C                   EXFMT     ACKEYFR
 
      ** Clear messages from program message queue
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      SPGMQ         PZAPGM
     C                   PARM      '*SAME'       PZAPGRL
 
     C                   EVAL      WScr2Err = *BLANKS
 
      ** Validate screen 2 if F3 and F12 is not pressed
 
     C                   IF        *IN03 = *OFF
     C                             AND *IN12 = *OFF
 
      ** Check #1PrcpAC (Principal Account) is entered and
      ** is a valid non-title Account code
 
     C                   IF        #1PrcpAC = *BLANKS
     C                   EVAL      *IN28 = *ON
     C                   ELSE
     C     #1PrcpAC      CHAIN     SDACODL0                           28
     C                   ENDIF
 
     C                   IF        *IN28 = *ON
     C                             OR A5TOIN = 'Y'
     C                   EVAL      WScr2Err = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   EVAL      PZAMSID = 'USR4230'
     C                   EXSR      SRZASNMS
     C                   ENDIF
 
      ** Check #1PCtrAC (Principal Contra Account) is entered
      ** and is a valid non-title Account code
 
     C                   IF        #1PCtrAC = *BLANKS
     C                   EVAL      *IN29 = *ON
     C                   ELSE
     C     #1PCtrAC      CHAIN     SDACODL0                           29
     C                   ENDIF
 
     C                   IF        *IN29 = *ON
     C                             OR A5TOIN = 'Y'
     C                   EVAL      WScr2Err = 'Y'
     C                   EVAL      *IN29 = *ON
     C                   EVAL      PZAMSID = 'USR4230'
     C                   EXSR      SRZASNMS
     C                   ENDIF
 
      ** If no error is found on screen, set-up fields for ZACKEYAL
 
     C                   IF        WScr2Err <> 'Y'
 
     C                   EVAL      RECI = 'D'
     C                   EVAL      AKEY = *BLANKS
     C                   EVAL      WFTYP = 'FH'
     C                   EVAL      WSTYP = #1STYP
     C                   EVAL      WCODES = *BLANKS
 
      ** Initialized pack fields in ZACKEYAL that will not be used
 
     C                   EVAL      LCD = 0
     C                   EVAL      TNLU = 0
 
      ** Update fields for Deletion Date keys
 
     C                   EVAL      WEVENTD = 'D'
 
      ** Format Key FHDyy....A where yy = Subtype
 
     C                   EVAL      WAMTD = 'A'
 
      ** DR fields
 
     C                   MOVE      #1PrcpAC      ACD1
     C                   EVAL      NCD1 = '01'
     C                   MOVE      '3'           PRF1
 
      ** CR fields
 
     C                   MOVE      #1PCtrAC      ACD4
     C                   EVAL      NCD4 = '01'
     C                   MOVE      '1'           PRF4
 
      ** Write details to ZACKEYAL
 
     C                   WRITE     ZACKEYAF
 
      ** Update fields for Maturity Date keys
 
     C                   EVAL      WEVENTD = 'M'
     C                   WRITE     ZACKEYAF
 
      ** Turn off screen 2 error indicator
 
     C                   EVAL      WScr2Err = 'N'
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZASNMS - Send message to program message queue             *
      *                                                               *
      *****************************************************************
     C     SRZASNMS      BEGSR
 
      ** Declare message file to use
 
     C                   EVAL      PZAMSGF = 'SDUSRMSG'
 
     C                   CALL      'Y2SNMGC'
     C                   PARM      SPGMQ         PZAPGM
     C                   PARM                    PZAPGRL
     C                   PARM                    PZAMSID
     C                   PARM                    PZAMSGF
     C                   PARM                    PZAMSDA
     C                   PARM                    PZAMSTP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  'AK000070'
     C                   OUT       LDA
 
     C                   EVAL      SPGMQ = 'AK000070'
 
      ** Use access program AOBANKR0 to retrieve SDBANKPD Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Initialize screen fields (User name, Job name, Date)
 
     C                   EVAL      #1USER = PSUser
     C                   EVAL      #1WSID = PSJobName
     C                   EVAL      #1RUNA = BJMRDT
 
      ** Key List for Loan Type/Subtype and Deal Type/Subtype
 
     C     KLDTST        KLIST
     C                   KFLD                    WLDTYP
     C                   KFLD                    WSTYPE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'AK000070'
     C                   OUT       LDA
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
**  CTDATA DLTYP                                                                              228474
IT                                                                                            228474
IP                                                                                            228474
TD                                                                                            228474
TI                                                                                            228474
CI                                                                                            228474
LN                                                                                            228474
CD                                                                                            228474
CL                                                                                            228474
DL                                                                                            228474
C1                                                                                            228474
C2                                                                                            228474
BP                                                                                            228474
BD                                                                                            228474
TB                                                                                            228474
DA                                                                                            228474
TA                                                                                            228474
FL                                                                                            228474
FT                                                                                            228474
DP                                                                                            228474
DT                                                                                            228474
LP                                                                                            228474
LT                                                                                            228474
