     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE EU Customer Position Backvaluation setup')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE006670 - EU TAX Customer Position - remove records due to  *
      *              back valuations                                  *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *    This program deletes all records for a position that is    *
      *    after a backvaluation and writes the key details to        *
      *    temporary file ETCPOSTEMP so can be added back in          *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 236125 (reopen)    Date 23Sep05               *
      *                 236125             Date 22Sep05               *
      *                 235546 (reopen)    Date 31Aug05               *
      *                 235546  *CREATE    Date 27Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  236125 - Reopen - change call of SEVTAXDATE from calling     *
      *           the module to calling the program                   *
      *  236125 - Program is not using QTEMP version of file          *
      *  235546 - Duplicate records on ETCPOS on change of trade      *
      *  235546 - EU Tax backvaluations                               *
      *                                                               *
      *****************************************************************
 
     FETCPOSTEMPUF A E           K DISK    INFSR(*PSSR) USROPN
     FETCPOSL3  UF   E           K DISK    INFSR(*PSSR) COMMIT
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the SE standard declares
     D/COPY SECPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
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
 
     D Security      E DS                  EXTNAME(SECTYD) PREFIX(SEC_)
     D ValidTrade    E DS                  EXTNAME(SEVTRADPD)
     D T_REC         E                     EXTFLD(RECI)
     D ValidDpmv     E DS                  EXTNAME(SEVDPMVPD) PREFIX(D_)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for Access Programs, (very Long DS)
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
    2** Input parameters on call to AOPLCSR1
 
     D I@PARM          DS           256
     D  I#PORS                 1      1
     D  I#R997                 2      5
     D  I#CUST                 6     15
     D  I#BRCA                16     18
     D  I#BOOK                19     20
     D  I#PTFR                21     24
     D  I#CPGM                25     34
      *
      ** Output parameters on call to AOPLCSR1
      *
     D O@PARM          DS           256
     D  O#BOOK                 1      2
     D  O#PTFR                 3      6
     D  O#BICN                 7     12
     D  O#CRNM                13     22
     D  O#ACOF                23     24
 
      *                                                                                       236125
     D Command         S             48                                                       236125
      ** OVRDBF command for QCMDEXC to run                                                    236125
     D  Command1       S             23    INZ('OVRDBF FILE(ETCPOSTEMP)')                     236125
     D  Command2       S             25    INZ(' TOFILE(QTEMP/ETCPOSTEMP)')                   236125
      *                                                                                       236125
      ** Command length for QCMDEXC                                                           236125
     D CommandLen      S             15P 5 INZ(48)                                            236125
                                                                                              236125
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D KSesn           S                   LIKE(TDSS)
     D KBrca           S                   LIKE(TDBA)
     D KCust           S                   LIKE(TCNR)
     D KDate           S                   LIKE(TDVD)
     D TDate           S                   LIKE(TDVD)
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C* Initialisation
 
     C                   EXSR      INIT
 
     C* Trade records
 
     C                   IF        PType = 'T'
     C                   MOVEL     TDBA          KBrca
     C                   MOVEL     TDSS          KSesn
     C**********         Z-ADD     TCNR          KCust                                       CSD027A
     C                   EVAL      KCust = TCNR                                              CSD027A
     C*********          EVAL      TDate = TDVD                                               235546
     C                   EVAL      TDate = PTDVD                                              235546
     C                   MOVEL     TDMI          KMrk
     C                   MOVEL     PTFR          KPtfr
     C                   MOVEL     TDRF          KTRef
     C                   ENDIF
 
     C* Depot Movement records
 
     C                   IF        PType = 'D'
     C                   MOVEL     D_DPMK        KMrk
     C     KMrk          IFEQ      *BLANKS
     C                   MOVEL     SEC_MKTI      KMrk
     C                   ENDIF
     C                   MOVEL     D_PTFR        KPtfr
     C                   MOVEL     D_DPRN        KTRef
 
     C                   IF        D_DPMV = 'WI'
     C                   MOVEL     D_DPBA        KBrca
     C                   MOVEL     D_DPSS        KSesn
     C**********         Z-ADD     D_DPBN        KCust                                       CSD027A
     C                   EVAL      KCust = D_DPBN                                            CSD027A
     C***********        EVAL      TDate = D_DPMD                                             235546
     C                   EVAL      TDate = PTDVD                                              235546
     C                   ENDIF
 
     C                   IF        D_DPMV = 'WO'
     C                   MOVEL     D_DPBA        KBrca
     C                   MOVEL     D_DPSS        KSesn
     C**********         Z-ADD     D_DPBN        KCust                                       CSD027A
     C                   EVAL      KCust = D_DPBN                                            CSD027A
     C**********         EVAL      TDate = D_DPDO                                             235546
     C                   EVAL      TDate = PTDVD                                              235546
     C                   ENDIF
     C                   ENDIF
 
 
     C                   MOVEL     KCust         CustNum
     C     BGPFMG        IFEQ      'Y'
     C     FCPORS        ANDNE     'B'
     C                   MOVEL     FCPORS        I#PORS
     C                   MOVEL     FCR997        I#R997
     C                   MOVEL     KCust         I#CUST
     C                   MOVEL     *BLANKS       I#BRCA
     C                   MOVEL     *BLANKS       I#BOOK
     C                   MOVEL     *BLANKS       I#PTFR
     C                   MOVEL     *BLANKS       I#CPGM
      *
     C                   CALL      'AOPLCSR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    I@PARM
     C                   PARM      *BLANKS       O@PARM
     C     SDPLCS        PARM      SDPLCS        DSFDY
     C     @Rtcd         IFNE      'PMA0008'
     C     @Rtcd         ANDNE     'PMA0009'
     C                   MOVEL     'Y'           CustPM
     C                   END
     C                   END
     C     BGN4ST        IFEQ      'Y'
     C                   MOVEL     KCust         @KEY1
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1            10
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSLDY
 
     C     @RTCD         IFEQ      *BLANKS
     C     BBPRBA        ANDEQ     'Y'
     C                   MOVEL     'Y'           CustPB
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     'Y'           DDTDVDOK
     C     DDTDVDOK      DOWNE     *BLANKS
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
     C                   MOVEL     *BLANKS       DDTDVDOK
      *
      ** Validate whether account is blocked due to EU Tax
      *
     C****************   CALLB     'SEVTAXDATE'                                               236125
     C                   CALL      'SEVTAXDATE'                                               236125
      *
      * INPUTS
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       WDefault          1
     C                   PARM                    PActn             1
     C                   PARM                    KBrca
     C                   PARM                    KCust
     C                   PARM                    KSesn
     C                   PARM                    KPtfr             4
     C                   PARM                    KMrk              1
     C                   PARM                    PType             1
     C                   PARM                    KTRef             6
     C****************   PARM                    TDate             5 0                        235546
     C****************   PARM                    PTDVD                                  235546236125
     C                   PARM      PTDVD         VTDate            5 0                        236125
     C                   PARM      'DDTDVD'      WField           10
     C                   PARM                    Security
     C                   PARM                    CustDts
      *
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
     C                   PARM                    DDTDVDOK          1
 
     C                   MOVEL     WMsgDtXAr(1)  DATA              7
     C                   MOVEL     DATA          WType             1
     C                   MOVE      DATA          WTref             6
 
     C     KEYET         CHAIN     ETCPOSL3                           70
     C     *IN70         IFEQ      '0'
     C     WType         IFEQ      PType                                                      235546
     C     WTref         ANDEQ     KTref                                                      235546
     C                   ELSE                                                                 235546
     C                   Z-ADD     CSDA          TDATE                                        235546
     C                   WRITE     ETCPOSTMF
     C                   ENDIF                                                                235546
     C                   DELETE    ETCPOSNDF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   CLOSE     ETCPOSTEMP
     C                   SETON                                        LR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * INIT   - Initialisation                                       *
      *****************************************************************
     C     INIT          BEGSR
 
      ** Setup temporary file
 
     C                   CALL      'SEC006670'
      *                                                                                       236125
      ** Override ETCPOSTEMP to version in QTEMP                                              236125
      *                                                                                       236125
     C                   EVAL      Command = Command1 + Command2                              236125
     C                   CALL      'QCMDEXC'                                                  236125
     C                   PARM                    Command                                      236125
     C                   PARM                    CommandLen                                   236125
      *                                                                                       236125
     C                   OPEN      ETCPOSTEMP
 
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
     C                   PARM                    PActn
     C                   PARM                    PType
     C                   PARM                    ValidTrade
     C                   PARM                    ValidDpmv
     C                   PARM                    Security
     C                   PARM                    PTDVD             5 0                        235546
 
      ** Get Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   END
      *
      ** Get Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '905'         DBASE                          * DBERR 905*
     C                   EXSR      *PSSR                                        ************
     C                   END
      *
      ** Access Portfolio Management Details
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST'      @OPTN             7
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE                         ************
     C                   MOVEL     '906'         DBASE                          * DBERR 906*
     C                   EXSR      *PSSR                                        ************
     C                   END
 
     C                   END
 
      ** Define key list for file
 
     C     KEYET         KLIST
     C                   KFLD                    WType
     C                   KFLD                    WTref
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2005
