     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('User Maintenance+Menu Items details database updat')
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Function ILE Module                 *
      *                                                               *
      *  SFAMUSUPD - User Maintenance + Menu Items Details            *
      *              database update                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
      *
      * SF Midas User by USRP
     FMUSER     UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      *
      *  SF Midas User Trailer
     FMUSERZZ   UF A E             DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     PREFIX(ZZ)
      *
      * SF Midas User by REFUSR
     FMUSERL1   IF   E           K DISK
     F                                     RENAME(MUSERDDF:MUSERD1)
     F                                     PREFIX(D1)
      *
      * SF User Valid Booking Branches by USRP
     FMBRBS     UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     PREFIX(X_)
      *
      * SF User Valid Originating Branches by USRP
     FMBROS     UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     PREFIX(Y_)
      *
      * SF User Valid Companies by USRP
     FMCMPS     UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     PREFIX(Z_)
      *
 
     FSDFCTLL0  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      * Midas SD Standing Data Controls index
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D ChkAMUSFmt    E DS                  EXTNAME(MUSERDD)
     D                                     PREFIX(CH)
     D ChkBBRCFmt    E DS                  EXTNAME(MBRBSDD)
     D                                     PREFIX(CI)
     D ChkOBRCFmt    E DS                  EXTNAME(MBROSDD)
     D                                     PREFIX(CJ)
     D ChkCOMPFmt    E DS                  EXTNAME(MCMPSDD)
     D                                     PREFIX(CK)
      ** Rename fields for Timestamp checking
 
     D SFVAMUS       E DS                  EXTNAME(SFVAMUSPD)
     D                                     PREFIX(A_)
      ** Externally desc'd DS for valid User Defn + Menu Item Detail
     D SFVBBRC       E DS                  EXTNAME(SFVBBRCPD)
     D                                     PREFIX(B_)
      ** Externally desc'd DS for valid Booking Branch Detail
     D SFVOBRC       E DS                  EXTNAME(SFVOBRCPD)
     D                                     PREFIX(C_)
      ** Externally desc'd DS for valid Originating Branch Detail
     D SFVCOMP       E DS                  EXTNAME(SFVCOMPPD)
     D                                     PREFIX(D_)
      ** Externally desc'd DS for valid Companies Detail
 
     D OKAmuDets     E DS                  EXTNAME(SFEAMUSPD)
      * Error indicators for User Defn + Menu Items
     D OKBbrDets     E DS                  EXTNAME(SFEBBRCPD)
     D                                     PREFIX(B_)
      * Error indicators for Booking Branch
     D OKObrDets     E DS                  EXTNAME(SFEOBRCPD)
     D                                     PREFIX(O_)
      * Error indicators for Originating Branch
     D OKComDets     E DS                  EXTNAME(SFECOMPPD)
     D                                     PREFIX(C_)
      * Error indicators for Companies
 
     D B_AMUSF       E DS                  EXTNAME(MUSERDD)
     D                                     PREFIX(E_)
      **  Externally described DS for 'BEFORE UPDATE' User Defn + MI
     D B_BBRCF       E DS                  EXTNAME(MBRBSDD)
     D                                     PREFIX(F_)
      **  Externally described DS for 'BEFORE UPDATE' Booking Branch
     D B_OBRCF       E DS                  EXTNAME(MBROSDD)
     D                                     PREFIX(G_)
      **  Externally described DS for 'BEFORE UPDATE' Orig. Branch
     D B_COMPF       E DS                  EXTNAME(MCMPSDD)
     D                                     PREFIX(H_)
      **  Externally described DS for 'BEFORE UPDATE' Companies
 
      **  User Defn + Menu Items Details File
     D AMUSF         E DS                  EXTNAME(MUSERDD)
      **  Booking Branches Details File
     D BBRCF         E DS                  EXTNAME(MBRBSDD)
     D                                     PREFIX(B_)
      **  Originating Branches Details File
     D OBRCF         E DS                  EXTNAME(MBROSDD)
     D                                     PREFIX(O_)
      **  Companies Details File
     D COMPF         E DS                  EXTNAME(MCMPSDD)
     D                                     PREFIX(C_)
 
      * Data Structures for use with access programs
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Data structure for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for access programs, long data structure
 
      ** Midas API Message Header Format Definition
     D APHEAD        E DS                  EXTNAME(APHEADPD)
      * Data Structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCLCD         E                     EXTFLD(LCD)
      **
      * External DS for incoming data from General Ledger ICD File
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      **     RUNDAT data area.
     D RUNDAT          DS
     D  AGMRDT                 1      7
     D  AGRDNB                 8     10P 0
     D  AGSUC                 11     11
     D  AGDFF                 12     12
     D  AGMBIN                13     13
      *
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      * Outward parameters
      * RCD : Midas SD Deleted records file retrieval
     D PBRC            DS          3064
      * I :  File name
     D    PBFNME               1     10
      * I :  Long Key
     D    PBLKEY              11     60
      * I :  Deleted Data Record Pt1
     D    PBDR01              61    310
      * I :  Deleted Data Record Pt2
     D    PBDR02             311    560
      * I :  Deleted Data Record Pt3
     D    PBDR03             561    810
      * I :  Deleted Data Record Pt4
     D    PBDR04             811   1060
      * I :  Deleted Data Record Pt5
     D    PBDR05            1061   1310
      * I :  Deleted Data Record Pt6
     D    PBDR06            1311   1560
      * I :  Deleted Data Record Pt7
     D    PBDR07            1561   1810
      * I :  Deleted Data Record Pt8
     D    PBDR08            1811   2060
      * I :  Deleted Data Record Pt9
     D    PBDR09            2061   2310
      * I :  Deleted Data Record Pt10
     D    PBDR10            2311   2560
      * I :  Deleted Data Record Pt11
     D    PBDR11            2561   2810
      * I :  Deleted Data Record Pt12
     D    PBDR12            2811   3060
      * I :  Last Change Date
     D    PBLCD             3061   3063P 0
      * I :  Type of Last Change
     D    PBTYLC            3064   3064
 
     D WUDELR          DS          3000
     D    WUDR01               1    250
     D    WUDR02             251    500
     D    WUDR03             501    750
     D    WUDR04             751   1000
     D    WUDR05            1001   1250
     D    WUDR06            1251   1500
     D    WUDR07            1501   1750
     D    WUDR08            1751   2000
     D    WUDR09            2001   2250
     D    WUDR10            2251   2500
     D    WUDR11            2501   2750
     D    WUDR12            2751   3000
 
 
     D @Timestamp      S             26Z
      ** Fields defined for Enhancement CGL008
     D CGL008          S              1A
     D WFLG            S              1A
     D WUSER1          S             50A
 
      ** Account sequence field (packed) for call to CLINTSE
     D WKACSN          S              2P 0
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************
 
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
     C                   EXSR      CHKOTHUPD
 
     C                   IF        @@RTCD <> *BLANKS
     C                   GOTO      EXIT
     C                   ENDIF
 
      ** Insert, Amend, Re-activate or Delete the transaction
     C     A_USCHTP      CASEQ     'I'           INSERT
     C     A_USCHTP      CASEQ     'A'           AMEND
     C     A_USCHTP      CASEQ     'D'           DELETE
     C     A_USCHTP      CASEQ     'R'           REACTIVE
     C                   ENDCS
 
      * Exit From Program
     C     EXIT          TAG
 
     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      **  Program Parameters
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    @@RTCD            7
 
      ** Externally described DS for valid User Definition + Menu
      ** Items Detail
     C                   PARM                    SFVAMUS
      ** Externally described DS for valid Booking Branch
     C                   PARM                    SFVBBRC
      ** Externally described DS for valid Originating Branch
     C                   PARM                    SFVOBRC
      ** Externally described DS for valid Companies
     C                   PARM                    SFVCOMP
      *
      **  Access RUNDAT Data Area
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Access Bank Details
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY  = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'                          *************
     C                   EVAL      DBASE  = 909                                 * DBERR 909 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
     ** Check if CGL008 is Switched On
     C                   EVAL      CGL008 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd             7
     C                   PARM      '*VERIFY'     POptn             7
     C                   PARM      'CGL008'      PSard             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CGL008'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CGL008 = 'Y'
     C                   ENDIF
      *
      ** Access General Ledger ICD File
      *
     C                   CALL      'AOGELRR1'
     C                   PARM      '*DBERR  '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
 
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @Type             1
      *
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHKOTHUPD - Check for update by another workstation           *
      *                                                               *
      *****************************************************************
     C     CHKOTHUPD     BEGSR
 
      ** Retrieve current User Maintenance + Menu Items details
     C                   MOVE      A_USUSRP      MidasUSRP        10
 
     C                   CALLB     'SFAMUSRTV'
      * Inputs
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    @@MODE            6
      *
      * Response mode
     C                   PARM      ' '           @@RSMD            1
      *
      * Action Code
     C                   PARM      A_USCHTP      ACTN              1
      *
      * Front Office Transaction ID
     C                   PARM      A_USFRNT      FOTRID           20
      *
      * User
     C                   PARM                    MidasUSRP        10
      * User Security Level
     C                   PARM                    DDSECL            4
      *
      * Outputs
      *
      * User Definitions + Menu Items Details in File Format
     C                   PARM                    ChkAMUSFmt
      * User Booking Branches Details in File Format
     C                   PARM                    ChkBBRCFmt
      * User Originating Branches Details in File Format
     C                   PARM                    ChkOBRCFmt
      * User Companies Details in File Format
     C                   PARM                    ChkCOMPFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK          1
      *
      * OK - User
     C                   PARM                    DDUSRPOK          1
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Ix                3 0
      *
      ** Error if Timestamp is not the same (record has been changed
      **  by another workstation)
 
      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original Customer was fetched
      ** by this program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.
 
      ** Interactive mode:
     C                   IF        @TYPE = '1'
 
     C                   IF        CHUSTMST <> A_USTMST
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ENDIF
 
      ** Batch mode:
     C                   ELSE
     C                   IF        DDACTNOK = 'N' OR
     C                             DDUSRPOK = 'N'
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   Z-ADD     1             C                 2 0
 
     C                   DOW       C < ArrayMax AND
     C                             FldNameArr(C) <> *BLANKS
     C                   CLEAR                   DBError         132
     C                   EVAL      DBerror = 'Update error: ' + FOTRID
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
     C                   ADD       1             C
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * INSERT - Insert a transaction                                *
      *                                                              *
      ****************************************************************
     C     INSERT        BEGSR
 
      ** Access User Details
     C     A_USUSRP      CHAIN     MUSER                              99
      ** Database error
     C                   IF        *IN99 = *OFF
     C                   EVAL      DBKEY  = A_USUSRP
     C                   EVAL      DBFILE = 'MUSERDD'
     C                   EVAL      DBASE  = 901
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise User Maintenance + Menu Items Detail
     C                   CLEAR                   AMUSF
      ** Initialise Booking Branch Detail
     C                   CLEAR                   BBRCF
      ** Initialise Originating Branch Detail
     C                   CLEAR                   OBRCF
      ** Initialise Companies Detail
     C                   CLEAR                   COMPF
 
      ** Store Old fields for comparisons
     C                   MOVEL(P)  AMUSF         B_AMUSF
     C                   MOVEL(P)  BBRCF         B_BBRCF
     C                   MOVEL(P)  OBRCF         B_OBRCF
     C                   MOVEL(P)  COMPF         B_COMPF
      *
      *
      ** SET User Maintenance + Menu Items Detail FIELDS ON INSERT
      *
     C                   EVAL      RECI  = 'D'
     C                   EVAL      USRP  = A_USUSRP
     C                   EVAL      USER1 = A_USUSER1
     C                   EVAL      SECL  = A_USSECL
     C                   EVAL      TIMO  = 0
     C                   EVAL      GRPP  = A_USGRPP
     C                   EVAL      BANK  = A_USBANK
     C                   EVAL      DAFS  = A_USDAFS
     C                   EVAL      BRBS  = A_USBRBS
     C                   EVAL      BROS  = A_USBROS
     C                   EVAL      CMPS  = A_USCMPS
     C                   EVAL      ACDS  = A_USACDS
     C                   EVAL      DPPT  = A_USDPPT
     C                   EVAL      ROUT  = A_USROUT
     C                   EVAL      MUREP = A_USMUREP
     C                   EVAL      DBRN  = A_USDBRN
     C                   EVAL      MBREP = A_USMBREP
     C                   EVAL      SOCNT = A_USSOCNT
     C                   EVAL      LPWD  = 0
     C                   EVAL      LPWT  = '0'
     C                   EVAL      OUTQ  = A_USOUTQ
     C                   EVAL      DIRID = A_USDIRID
     C                   EVAL      DIRAD = A_USDIRAD
     C                   EVAL      LCD   = BJRDNB
     C                   EVAL      CHTP  = 'I'
     C                   TIME                    TIMEP             6 0
     C                   EVAL      LCT   = TIMEP
     C                   EVAL      PAUT  = A_USPAUT
     C                   EVAL      ROUF  = A_USROUF
     C                   EVAL      AURF  = A_USAURF
     C                   EVAL      REFP  = A_USREFP
     C                   EVAL      MULT  = A_USMULT
     C                   EVAL      ENTL  = A_USENTL
     C                   EVAL      AUT1  = A_USAUT1
     C                   EVAL      AUT2  = A_USAUT2
     C                   EVAL      COUTQ = A_USCOUTQ
     C                   EVAL      ACFA  = A_USACFA
     C                   EVAL      PCIU  = A_USPCIU
     C                   EVAL      ACTIN = A_USACTIN
     C                   EVAL      PCINM = A_USPCINM
      ** Move additional fields id CGL008 is switched on
     C                   IF        CGL008 = 'Y'
     C                   EVAL      ALACOD= A_USALACOD
     C                   EVAL      REFUSR= A_USREFUSR
     C                   EVAL      REFFLG= A_USREFFLG
     C                   EVAL      USRLVL= A_USUSRLVL
     C                   ENDIF
      *
     C                   EVAL      COBAUT= A_USCOBAUT
     C                   EVAL      TLID  = A_USTLID
      ** SET User Booking Branch Detail FIELDS ON INSERT
      *
     C                   EVAL      X_RECI = 'D'
     C                   EVAL      X_USRP = A_USUSRP
     C                   EVAL      X_NOBR = B_BBNOBR
     C                   EVAL      X_VBRA = B_BBVBRA
     C                   EVAL      X_LCD  = BJRDNB
     C                   EVAL      X_CHTP = 'I'
     C                   EVAL      X_LCT  = TIMEP
     C                   EVAL      X_VBRX = B_BBVBRX
      *
      ** SET User Originating Branch Detail FIELDS ON INSERT
      *
     C                   EVAL      Y_RECI = 'D'
     C                   EVAL      Y_USRP = A_USUSRP
     C                   EVAL      Y_NOBR = C_OBNOBR
     C                   EVAL      Y_VBRA = C_OBVBRA
     C                   EVAL      Y_LCD  = BJRDNB
     C                   EVAL      Y_CHTP = 'I'
     C                   EVAL      Y_LCT  = TIMEP
     C                   EVAL      Y_VBRX = C_OBVBRX
      *
      ** SET User Companies Detail FIELDS ON INSERT
      *
     C                   EVAL      Z_RECI = 'D'
     C                   EVAL      Z_USRP = A_USUSRP
     C                   EVAL      Z_NOOC = D_CMNOOC
     C                   EVAL      Z_VCMP = D_CMVCMP
     C                   EVAL      Z_LCD  = BJRDNB
     C                   EVAL      Z_CHTP = 'I'
     C                   EVAL      Z_LCT  = TIMEP
      *
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   EVAL      USTMST  = TimeStamp
      *
      ** Write new User Definition + Menu Item Detail
     C                   WRITE     MUSERDDF
      ** Write new Booking Branch Detail only if Booking Branch is Selected
     C                   IF        A_USBRBS = 'Y'
     C                   WRITE     MBRBSDDF
     C                   ENDIF
      ** Write new Originating Branch Detail only if Orig. Branch is Selected
     C                   IF        A_USBROS = 'Y'
     C                   WRITE     MBROSDDF
     C                   ENDIF
      ** Write new Companies Detail only if Companies is Selected
     C                   IF        A_USCMPS = 'Y'
     C                   WRITE     MCMPSDDF
     C                   ENDIF
      *
      ** Should always update trailer file at insert of user.
      *
     C     1             CHAIN     MUSERZZF                           85
      *
     C     *IN85         IFEQ      '1'
     C                   MOVE      'Z'           ZZRECI
     C                   Z-ADD     1             ZZNORE
     C                   WRITE     MUSERZZF
     C                   ELSE
     C                   ADD       1             ZZNORE
     C                   UPDATE    MUSERZZF
     C                   ENDIF
      *
      ** Update Reference Flag for Reference User
      *
     C                   IF        CGL008 = 'Y'
     C     A_USREFUSR    CHAIN     MUSERDDF
     C                   EVAL      REFFLG = 'Y'
     C                   UPDATE    MUSERDDF
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * AMEND  - Amend a transaction                                 *
      *                                                              *
      ****************************************************************
     C     AMEND         BEGSR
 
      ** Access User Details from User File
     C     A_USUSRP      CHAIN     MUSER                              96
      ** Database error
     C                   IF        *IN96 = *ON OR
     C                             RECI = 'C'
     C                   EVAL      DBKEY  = A_USUSRP
     C                   EVAL      DBFILE = 'MUSERDD'
     C                   EVAL      DBASE  = 902
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Access User Details from Booking Branch File
     C     A_USUSRP      CHAIN     MBRBS                              97
      *
      ** Access User Details from Originating Branch File
     C     A_USUSRP      CHAIN     MBROS                              98
      *
      ** Access User Details from Companies File
     C     A_USUSRP      CHAIN     MCMPS                              99
      *
      *
      ** Update 'BEFORE' status of User
     C                   MOVEL(P)  AMUSF         B_AMUSF
      *
     C                   IF        *IN97 = *ON
      ** Initialise 'BEFORE' status of User Booking Branch
     C                   CLEAR                   BBRCF
     C                   ENDIF
      *
     C                   IF        *IN98 = *ON
      ** Initialise 'BEFORE' status of User Originating Branch
     C                   CLEAR                   OBRCF
     C                   ENDIF
      *
     C                   IF        *IN99 = *ON
      ** Initialise 'BEFORE' status of User Companies
     C                   CLEAR                   COMPF
     C                   ENDIF
      *
      ** Update 'BEFORE' status of User Booking Branch
     C                   MOVEL(P)  BBRCF         B_BBRCF
      ** Update 'BEFORE' status of User Originating Branch
     C                   MOVEL(P)  OBRCF         B_OBRCF
      ** Update 'BEFORE' status of User Companies
     C                   MOVEL(P)  COMPF         B_COMPF
 
      *
      ** SET User Maintenance + Menu Items Detail FIELDS ON AMEND
      *
     C                   EVAL      RECI  = 'D'
     C                   EVAL      USRP  = A_USUSRP
     C                   EVAL      USER1 = A_USUSER1
     C                   EVAL      SECL  = A_USSECL
     C                   EVAL      TIMO  = 0
     C                   EVAL      GRPP  = A_USGRPP
     C                   EVAL      BANK  = A_USBANK
     C                   EVAL      DAFS  = A_USDAFS
     C                   EVAL      BRBS  = A_USBRBS
     C                   EVAL      BROS  = A_USBROS
     C                   EVAL      CMPS  = A_USCMPS
     C                   EVAL      ACDS  = A_USACDS
     C                   EVAL      DPPT  = A_USDPPT
     C                   EVAL      ROUT  = A_USROUT
     C                   EVAL      MUREP = A_USMUREP
     C                   EVAL      DBRN  = A_USDBRN
     C                   EVAL      MBREP = A_USMBREP
     C                   EVAL      SOCNT = A_USSOCNT
     C                   EVAL      LPWD  = 0
     C                   EVAL      LPWT  = '0'
     C                   EVAL      OUTQ  = A_USOUTQ
     C                   EVAL      DIRID = A_USDIRID
     C                   EVAL      DIRAD = A_USDIRAD
     C                   EVAL      LCD   = BJRDNB
     C                   EVAL      CHTP  = 'A'
     C                   TIME                    TIMEP             6 0
     C                   EVAL      LCT   = TIMEP
     C                   EVAL      PAUT  = A_USPAUT
     C                   EVAL      ROUF  = A_USROUF
     C                   EVAL      AURF  = A_USAURF
     C                   EVAL      REFP  = A_USREFP
     C                   EVAL      MULT  = A_USMULT
     C                   EVAL      ENTL  = A_USENTL
     C                   EVAL      AUT1  = A_USAUT1
     C                   EVAL      AUT2  = A_USAUT2
     C                   EVAL      COUTQ = A_USCOUTQ
     C                   EVAL      ACFA  = A_USACFA
     C                   EVAL      PCIU  = A_USPCIU
     C                   EVAL      ACTIN = A_USACTIN
     C                   EVAL      PCINM = A_USPCINM
      ** Move additional fields id CGL008 is switched on
     C                   IF        CGL008 = 'Y'
     C                   EVAL      ALACOD= A_USALACOD
     C                   EVAL      REFUSR= A_USREFUSR
     C                   EVAL      REFFLG= A_USREFFLG
     C                   EVAL      USRLVL= A_USUSRLVL
     C                   ENDIF
      *
     C                   EVAL      COBAUT= A_USCOBAUT
     C                   EVAL      TLID  = A_USTLID
      *
      ** SET User Booking Branch Detail FIELDS ON AMEND/INSERT
      *
     C                   IF        *IN97 = *ON
     C                   EVAL      X_CHTP = 'I'
     C                   ELSE
     C                   EVAL      X_CHTP = 'A'
     C                   ENDIF
      *
     C                   EVAL      X_RECI = 'D'
     C                   EVAL      X_USRP = A_USUSRP
     C                   EVAL      X_NOBR = B_BBNOBR
     C                   EVAL      X_VBRA = B_BBVBRA
     C                   EVAL      X_LCD  = BJRDNB
     C                   EVAL      X_LCT  = TIMEP
     C                   EVAL      X_VBRX = B_BBVBRX
      *
      ** SET User Originating Branch Detail FIELDS ON AMEND/INSERT
      *
     C                   IF        *IN98 = *ON
     C                   EVAL      Y_CHTP = 'I'
     C                   ELSE
     C                   EVAL      Y_CHTP = 'A'
     C                   ENDIF
      *
     C                   EVAL      Y_RECI = 'D'
     C                   EVAL      Y_USRP = A_USUSRP
     C                   EVAL      Y_NOBR = C_OBNOBR
     C                   EVAL      Y_VBRA = C_OBVBRA
     C                   EVAL      Y_LCD  = BJRDNB
     C                   EVAL      Y_LCT  = TIMEP
     C                   EVAL      Y_VBRX = C_OBVBRX
      *
      ** SET User Originating Branch Detail FIELDS ON AMEND/INSERT
      *
     C                   IF        *IN99 = *ON
     C                   EVAL      Z_CHTP = 'I'
     C                   ELSE
     C                   EVAL      Z_CHTP = 'A'
     C                   ENDIF
      *
     C                   EVAL      Z_RECI = 'D'
     C                   EVAL      Z_USRP = A_USUSRP
     C                   EVAL      Z_NOOC = D_CMNOOC
     C                   EVAL      Z_VCMP = D_CMVCMP
     C                   EVAL      Z_LCD  = BJRDNB
     C                   EVAL      Z_LCT  = TIMEP
      *
     ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   EVAL      USTMST  = TimeStamp
 
 
      *
      ** Update User Maintenance + Menu Items Record
     C                   UPDATE    MUSERDDF
      *
      * INSERT/AMEND Booking Branch only if Booking Branch is Selected
      * If Booking Branch Details Does not already exist then INSERT
      * Else UPDATE
     C                   IF        A_USBRBS = 'Y'
     C                   IF        *IN97 = *ON
     C                   WRITE     MBRBSDDF
     C                   ELSE
     C                   UPDATE    MBRBSDDF
     C                   ENDIF
     C                   ENDIF
      *
      * INSERT/AMEND Orig. Branch only if Orig. Branch is Selected
      * If Originating Branch Details Does not already exist then INSERT
      * Else UPDATE
     C                   IF        A_USBROS = 'Y'
     C                   IF        *IN98 = *ON
     C                   WRITE     MBROSDDF
     C                   ELSE
     C                   UPDATE    MBROSDDF
     C                   ENDIF
     C                   ENDIF
      *
      * INSERT/AMEND Companies only if Companies is Selected
      * If Companies Details Does not already exist then INSERT
      * Else UPDATE
     C                   IF        A_USCMPS = 'Y'
     C                   IF        *IN99 = *ON
     C                   WRITE     MCMPSDDF
     C                   ELSE
     C                   UPDATE    MCMPSDDF
     C                   ENDIF
     C                   ENDIF
      *
      ** Update Reference Flag for Reference User
      ** If reference user field is amended to be blank and there are
      ** no other users with this reference user, update MUSERDD for
      ** the reference user with 'Ref. User Flag' = 'N'
      *
     C                   IF        CGL008 = 'Y'
     C                   IF        A_USREFUSR = *BLANKS
      *
     C     E_REFUSR      SETLL     MUSERD1
     C     E_REFUSR      READE     MUSERD1                                06
     C                   EVAL      WFLG = '0'
      *
     C                   DOW       *IN06 = *OFF
     C                   IF        D1USRP <> D1REFUSR AND
     C                             D1RECI = 'D'       AND
     C                             D1USRP <>  A_USUSRP
     C                   EVAL      WFLG  = '1'
     C                   ENDIF
     C     E_REFUSR      READE     MUSERD1                                06
     C                   ENDDO
     C                   IF        WFLG = '0'
     C     E_REFUSR      CHAIN     MUSERDDF                           88
     C                   EVAL      REFFLG  = 'N'
     C                   UPDATE    MUSERDDF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * DELETE - Delete a transaction                                *
      *                                                              *
      ****************************************************************
     C     DELETE        BEGSR
 
      ** Access User Details from User File
     C     A_USUSRP      CHAIN     MUSER                              96
      ** Database error
     C                   IF        *IN96 = *ON
     C                   EVAL      DBKEY  = A_USUSRP
     C                   EVAL      DBFILE = 'MUSERDD'
     C                   EVAL      DBASE  = 903
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Access User Details from Booking Branch File
     C     A_USUSRP      CHAIN     MBRBS                              97
      *
      ** Access User Details from Originating Branch File
     C     A_USUSRP      CHAIN     MBROS                              98
      *
      ** Access User Details from Companies File
     C     A_USUSRP      CHAIN     MCMPS                              99
      *
 
     ** Update 'BEFORE' status of User
     C                   MOVEL(P)  AMUSF         B_AMUSF
      *
     C                   IF        *IN97 = *ON
      ** Initialise 'BEFORE' status of User Booking Branch
     C                   CLEAR                   BBRCF
     C                   ENDIF
      *
     C                   IF        *IN98 = *ON
      ** Initialise 'BEFORE' status of User Originating Branch
     C                   CLEAR                   OBRCF
     C                   ENDIF
      *
     C                   IF        *IN99 = *ON
      ** Initialise 'BEFORE' status of User Companies
     C                   CLEAR                   COMPF
     C                   ENDIF
      *
      ** Update 'BEFORE' status of User Booking Branch
     C                   MOVEL(P)  BBRCF         B_BBRCF
      ** Update 'BEFORE' status of User Originating Branch
     C                   MOVEL(P)  OBRCF         B_OBRCF
      ** Update 'BEFORE' status of User Companies
     C                   MOVEL(P)  COMPF         B_COMPF
      *
      ** SET User Maintenance + Menu Items Detail FIELDS ON DELETE
      *
     C                   EVAL      RECI  = 'C'
     C                   EVAL      BRBS  = A_USBRBS
     C                   EVAL      BROS  = A_USBROS
     C                   EVAL      CMPS  = A_USCMPS
     C                   EVAL      ACDS  = A_USACDS
     C                   EVAL      LCD   = BJRDNB
     C                   EVAL      CHTP  = 'D'
     C                   TIME                    TIMEP             6 0
     C                   EVAL      LCT   = TIMEP
      *
      *** If Multi-Branch Indicator is ON
      *
     C                   IF        AGMBIN = 'Y'
      *
      ** SET User Booking Branch Detail FIELDS ON DELETE
      *
     C                   IF        *IN97 = *OFF
     C                   EVAL      X_CHTP = 'D'
     C                   EVAL      X_RECI = 'C'
     C                   EVAL      X_LCD  = BJRDNB
     C                   EVAL      X_LCT  = TIMEP
     C                   UPDATE    MBRBSDDF
     C                   ENDIF
      *
      ** If Originating Branch Indicator is ON
      ** SET User Originating Branch Detail FIELDS ON AMEND/INSERT
      *
     C                   IF        BKOBUV = 'Y'
      *
     C                   IF        *IN98 = *OFF
     C                   EVAL      Y_CHTP = 'D'
     C                   EVAL      Y_RECI = 'C'
     C                   EVAL      Y_LCD  = BJRDNB
     C                   EVAL      Y_LCT  = TIMEP
     C                   UPDATE    MBROSDDF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** SET User Companies Detail FIELDS ON AMEND/INSERT
      *
     C                   IF        *IN99 = *OFF
     C                   EVAL      Z_CHTP = 'D'
     C                   EVAL      Z_RECI = 'C'
     C                   EVAL      Z_LCD  = BJRDNB
     C                   EVAL      Z_LCT  = TIMEP
     C                   UPDATE    MCMPSDDF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   EVAL      USTMST  = TimeStamp
 
      ** Update User Maintenance + Menu Items Record Marked for DELETE
     C                   UPDATE    MUSERDDF
      *
      *
      ** MUSERZZ should be updated with one less record so that it
      ** keeps track of all LIVE records on MUSERDD.
      *
     C     1             CHAIN     MUSERZZF                           85
      *
     C     *IN85         IFEQ      '0'
     C                   EVAL      ZZNORE = ZZNORE - 1
     C                   UPDATE    MUSERZZF
     C                   ENDIF
      *
      ** Update Reference Flag for Reference User
      ** If there are no reference user, update MUSERDD for
      ** the reference user with 'Ref. User Flag' = 'N'
      *
     C                   IF        CGL008 = 'Y'
      *
     C     E_REFUSR      SETLL     MUSERD1
     C     E_REFUSR      READE     MUSERD1                                07
     C                   EVAL      WFLG = *BLANKS
      *
     C                   DOW       *IN07 = *OFF
     C                   IF        D1USRP <> D1REFUSR AND
     C                             D1RECI = 'D'
     C                   EVAL      WFLG  = 'Y'
     C                   ENDIF
     C     E_REFUSR      READE     MUSERD1                                07
     C                   ENDDO
     C                   IF        WFLG <> 'Y'
     C     E_REFUSR      CHAIN     MUSERDDF                           88
     C                   IF        *IN88 = *OFF
     C                   EVAL      REFFLG  = 'N'
     C                   UPDATE    MUSERDDF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Call SFC0030 to Delete Directory Entries for User
      *
     C                   EVAL      WUSER1 = A_USUSER1
     C                   CALL      'SFC0030'
     C                   PARM      'D'           ACTCDE            1
     C                   PARM                    ERRCD             1
     C                   PARM                    A_USUSRP
     C                   PARM                    WUSER1
     C                   PARM                    A_USDIRID
     C                   PARM                    A_USDIRAD
      *
 
     C                   ENDSR
      ****************************************************************
      /EJECT
     *****************************************************************
     **                                                              *
     ** REACTIVE  - Re-Activate a transaction                        *
     **                                                              *
     *****************************************************************
     C     REACTIVE      BEGSR
      *
      ** Access User Details from User File
     C     A_USUSRP      CHAIN     MUSER                              96
      ** Database error
     C                   IF        *IN96 = *ON OR
     C                             RECI = 'D'
     C                   EVAL      DBKEY  = A_USUSRP
     C                   EVAL      DBFILE = 'MUSERDD'
     C                   EVAL      DBASE  = 904
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Access User Details from Booking Branch File
     C     A_USUSRP      CHAIN     MBRBS                              97
      *
      ** Access User Details from Originating Branch File
     C     A_USUSRP      CHAIN     MBROS                              98
      *
      ** Access User Details from Companies File
     C     A_USUSRP      CHAIN     MCMPS                              99
      *
      *
      ** Update 'BEFORE' status of User
     C                   MOVEL(P)  AMUSF         B_AMUSF
      *
     C                   IF        *IN97 = *ON
      ** Initialise 'BEFORE' status of User Booking Branch
     C                   CLEAR                   BBRCF
     C                   ENDIF
      *
     C                   IF        *IN98 = *ON
      ** Initialise 'BEFORE' status of User Originating Branch
     C                   CLEAR                   OBRCF
     C                   ENDIF
      *
     C                   IF        *IN99 = *ON
      ** Initialise 'BEFORE' status of User Companies
     C                   CLEAR                   COMPF
     C                   ENDIF
      *
      ** Update 'BEFORE' status of User Booking Branch
     C                   MOVEL(P)  BBRCF         B_BBRCF
      ** Update 'BEFORE' status of User Originating Branch
     C                   MOVEL(P)  OBRCF         B_OBRCF
      ** Update 'BEFORE' status of User Companies
     C                   MOVEL(P)  COMPF         B_COMPF
      *
      *
      ** SET User Maintenance + Menu Items Detail FIELDS ON REACTIVATE
      *
     C                   EVAL      RECI  = 'D'
     C                   EVAL      USRP  = A_USUSRP
     C                   EVAL      USER1 = A_USUSER1
     C                   EVAL      SECL  = A_USSECL
     C                   EVAL      TIMO  = 0
     C                   EVAL      GRPP  = A_USGRPP
     C                   EVAL      BANK  = A_USBANK
     C                   EVAL      DAFS  = A_USDAFS
     C                   EVAL      BRBS  = A_USBRBS
     C                   EVAL      BROS  = A_USBROS
     C                   EVAL      CMPS  = A_USCMPS
     C                   EVAL      ACDS  = A_USACDS
     C                   EVAL      DPPT  = A_USDPPT
     C                   EVAL      ROUT  = A_USROUT
     C                   EVAL      MUREP = A_USMUREP
     C                   EVAL      DBRN  = A_USDBRN
     C                   EVAL      MBREP = A_USMBREP
     C                   EVAL      SOCNT = A_USSOCNT
     C                   EVAL      LPWD  = 0
     C                   EVAL      LPWT  = '0'
     C                   EVAL      OUTQ  = A_USOUTQ
     C                   EVAL      DIRID = A_USDIRID
     C                   EVAL      DIRAD = A_USDIRAD
     C                   EVAL      LCD   = BJRDNB
     C                   EVAL      CHTP  = 'R'
     C                   TIME                    TIMEP             6 0
     C                   EVAL      LCT   = TIMEP
     C                   EVAL      PAUT  = A_USPAUT
     C                   EVAL      ROUF  = A_USROUF
     C                   EVAL      AURF  = A_USAURF
     C                   EVAL      REFP  = A_USREFP
     C                   EVAL      MULT  = A_USMULT
     C                   EVAL      ENTL  = A_USENTL
     C                   EVAL      AUT1  = A_USAUT1
     C                   EVAL      AUT2  = A_USAUT2
     C                   EVAL      COUTQ = A_USCOUTQ
     C                   EVAL      ACFA  = A_USACFA
     C                   EVAL      PCIU  = A_USPCIU
     C                   EVAL      ACTIN = A_USACTIN
     C                   EVAL      PCINM = A_USPCINM
      ** Move additional fields id CGL008 is switched on
     C                   IF        CGL008 = 'Y'
     C                   EVAL      ALACOD= A_USALACOD
     C                   EVAL      REFUSR= A_USREFUSR
     C                   EVAL      REFFLG= A_USREFFLG
     C                   EVAL      USRLVL= A_USUSRLVL
     C                   ENDIF
      *
     C                   EVAL      COBAUT= A_USCOBAUT
     C                   EVAL      USZONE= A_USUSZONE
     C                   EVAL      TLID  = A_USTLID
      *
      ** SET User Booking Branch Detail FIELDS ON REACTIVATE/INSERT
      *
     C                   IF        *IN97 = *ON
     C                   EVAL      X_CHTP = 'I'
     C                   ELSE
     C                   EVAL      X_CHTP = 'R'
     C                   ENDIF
      *
     C                   EVAL      X_RECI = 'D'
     C                   EVAL      X_USRP = A_USUSRP
     C                   EVAL      X_NOBR = B_BBNOBR
     C                   EVAL      X_VBRA = B_BBVBRA
     C                   EVAL      X_LCD  = BJRDNB
     C                   EVAL      X_LCT  = TIMEP
     C                   EVAL      X_VBRX = B_BBVBRX
      *
      ** SET User Originating Branch Detail FIELDS ON REACTIVATE /INSERT
      *
     C                   IF        *IN98 = *ON
     C                   EVAL      Y_CHTP = 'I'
     C                   ELSE
     C                   EVAL      Y_CHTP = 'R'
     C                   ENDIF
      *
     C                   EVAL      Y_RECI = 'D'
     C                   EVAL      Y_USRP = A_USUSRP
     C                   EVAL      Y_NOBR = C_OBNOBR
     C                   EVAL      Y_VBRA = C_OBVBRA
     C                   EVAL      Y_LCD  = BJRDNB
     C                   EVAL      Y_LCT  = TIMEP
     C                   EVAL      Y_VBRX = C_OBVBRX
      *
      ** SET User Companies Detail FIELDS ON REACTIVATE /INSERT
      *
     C                   IF        *IN99 = *ON
     C                   EVAL      Z_CHTP = 'I'
     C                   ELSE
     C                   EVAL      Z_CHTP = 'R'
     C                   ENDIF
      *
     C                   EVAL      Z_RECI = 'D'
     C                   EVAL      Z_USRP = A_USUSRP
     C                   EVAL      Z_NOOC = D_CMNOOC
     C                   EVAL      Z_VCMP = D_CMVCMP
     C                   EVAL      Z_LCD  = BJRDNB
     C                   EVAL      Z_LCT  = TIMEP
      *
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   EVAL      USTMST  = TimeStamp
      *
      ** Update User Maintenance + Menu Items Record
     C                   UPDATE    MUSERDDF
      *
      * INSERT/REACTIVATE Booking Branch only if Booking Branch is Selected
      * If Booking Branch Details Does not already exist then INSERT
      * Else UPDATE
     C                   IF        A_USBRBS = 'Y'
     C                   IF        *IN97 = *ON
     C                   WRITE     MBRBSDDF
     C                   ELSE
     C                   UPDATE    MBRBSDDF
     C                   ENDIF
     C                   ENDIF
      *
      * INSERT/REACTIVATE Orig. Branch only if Orig. Branch is Selected
      * If Originating Branch Details Does not already exist then INSERT
      * Else UPDATE
     C                   IF        A_USBROS = 'Y'
     C                   IF        *IN98 = *ON
     C                   WRITE     MBROSDDF
     C                   ELSE
     C                   UPDATE    MBROSDDF
     C                   ENDIF
     C                   ENDIF
      *
      * INSERT/REACTIVATE Companies only if Companies is Selected
      * If Companies Details Does not already exist then INSERT
      * Else UPDATE
     C                   IF        A_USCMPS = 'Y'
     C                   IF        *IN99 = *ON
     C                   WRITE     MCMPSDDF
     C                   ELSE
     C                   UPDATE    MCMPSDDF
     C                   ENDIF
     C                   ENDIF
      *
      ** Update Reference Flag for Reference User
      ** If reference user field is amended to be blank and there are
      ** no other users with this reference user, update MUSERDD for
      ** the reference user with 'Ref. User Flag' = 'N'
      *
     C                   IF        CGL008 = 'Y'
     C                   IF        A_USREFUSR = *BLANKS
      *
     C     E_REFUSR      SETLL     MUSERD1
     C     E_REFUSR      READE     MUSERD1                                06
     C                   EVAL      WFLG = '0'
      *
     C                   DOW       *IN06 = *OFF
     C                   IF        D1USRP <> D1REFUSR AND
     C                             D1RECI = 'D'       AND
     C                             D1USRP <>  A_USUSRP
     C                   EVAL      WFLG  = '1'
     C                   ENDIF
     C     E_REFUSR      READE     MUSERD1                                06
     C                   ENDDO
     C                   IF        WFLG = '0'
     C     E_REFUSR      CHAIN     MUSERDDF                           88
     C                   EVAL      REFFLG  = 'N'
     C                   UPDATE    MUSERDDF
     C                   ENDIF
      *
     C                   ELSE
      *
     C     A_USREFUSR    CHAIN     MUSERD1                            06
     C                   EVAL      REFFLG  = 'Y'
     C                   UPDATE    MUSERDDF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C*                  ENDIF
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
 
      ** Note: if non-standard processing required, use the PSSR_ILENE
      ** subroutine
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
