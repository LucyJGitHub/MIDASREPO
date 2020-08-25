     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Forecast Transactions A/C Key Generation')    *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS000014 - Forecast Transactions Account Key Generation      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 AR821740           Date 29Aug11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 229704             Date 23Sep04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR821740 - COB - No stamp tax account keys generated         *
      *             (Recompile)                                       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  229704 - Let forecast transactions generate a/c keys at      *
      *           start date even if the underlying ref. is not set.  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  LR     Last Record Indicator (program termination)           *
      *  U7,U8  DB Error Processing Indicator                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcDL   - Process Dealing Forecast Transactions           *
      *  SRProcLE   - Process Lending Forecast Transactions           *
      *  SRWriteKey - Write Account Key in DKEYSDP                    *
      *  SRBranch   - Access AOBRCHR0                                 *
      *  SRUpdTrl   - Update Trailer File                             *
      *  SRChkRCF   - Register the P1 Printer File via RCF            *
      *  SRReport   - Write a report                                  *
      *  SRAudit    - Audit report                                    *
      *  SREndRep   - Write the End of the Report                     *
      *  SRChkRCFA  - Register the AU Printer File via RCF            *
      *  SRGLZADD   - Subroutine to add an amount to the total        *
      *  SRGLZSUM   - Subroutine to carry out the additon for SRGLZADD*
      *                                                               *
      *  *INZSR - Initialise                                          *
      *  *PSSR - Error processing                                     *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FASFHTRL2  IF   E           K DISK    INFSR(*PSSR)
      ** Midas AS Forecast transaction file - by branch & FH ID

     FDKEYSDP   O  A E             DISK    INFSR(*PSSR)
     F                                     PREFIX(DK)
      ** Midas DL Deals Generated Account Keys - Detail

     FDKEYSZZ   UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(DZ)
      ** Midas DL Deals Generated Account Keys - Trailer

     FDLDLHGL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(DL)
      ** Midas DL Deals File

     FCLOANLB   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(LE)
      ** Midas LE Loans File

     FAS000014P1O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
     F                                     INFSR(*PSSR)
     F                                     OFLIND(*IN01)
      ** Midas AS FH A/C Generation - Detail

     FAS000014AUO    E             PRINTER INFDS(SPOOLU)
      ** Midas AS FH A/C Generation - Audit

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** File Information Data Structure for AS000011P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

      ** File Information Data Structure for AS000011AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Midas Modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Account Key Data Structure
     D WAcctKey        DS
     D  WkTran                 1      2
     D  WkType                 3      3
     D  WkSubT                 4      5
     D  WkBook                 6      9
     D  WkAmnt                10     10

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameters for ZSFILE
     D PSEQ            S              5
     D PSENTY          S              3
     D PSFILE          S             10
     D PZSNMU          S              6  0
     D PZSERR          S              1

      ** Parameters for Access Objects
     D PRetCode        S              7
     D POption         S              7
     D PBranch         S              3
     D PCurr           S              3

      ** Parameters for ZFRPED
     D PFLD15          S             15  0
     D PDECS           S              1  0
     D PECODE          S              1
     D POUT21          S             21
     D POUT22          S             22
     D POUT25          S             25

      ** Fields used in SRGLZADD/SRGLZSUM
     D ZZAMT           S             15  3
     D ZZAMTI          S             15  0
     D ZZAMTD          S              3  0
     D ZZTOTI          S             15  0
     D ZZTOTD          S              3  0
     D ZZWK2           S              4  0
     D ZZWK3           S             15  0
     D ZZNEGD          S              5

     D ZDATE           S              6  0

      ** Work variables
     D WkNoRec         S              5  0
     D WkVlInt         S             15  0
     D WkVlDec         S              3  0
     D WrkNORE         S              5  0
     D WkBRCA          S              3
     D WkEVCD          S              5  0
     D WkEvnt          S             13
     D WkTrail         S              1
     D WPrvBRCA        S              3
     D WProcess        S              1
     D WRun            S              1

      ** Key Fields
     D KBRCA           S              3
     D KUREF           S              6  0
     D KUREFA          S              6A                                                      CLE148

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      ** Read through the Forecast Transactions file

     C     *LOVAL        SETLL     ASFHTRL2
     C                   READ      ASFHTRL2

      ** If there are no records, produce audit report

     C                   IF        %EOF(ASFHTRL2)
     C                   EXSR      SRAudit

      ** Else, ensure report spool file is recorded by RCF

     C                   ELSE
     C                   EVAL      WkBRCA = FSBRCA
     C                   EXSR      SRBranch
     C                   EXSR      SRChkRCF

     C                   DOW       NOT %EOF(ASFHTRL2)

      ***Process*record*if*Underlying*Reference*is*not*zero************                       229704

     C**********         IF        FSUREF <> 0                                                229704

     C                   EVAL      WkTran = 'FH'
     C                   EVAL      WkSubT = FSSUBT
     C                   EVAL      WkBook = *BLANKS
     C                   EVAL      WkAmnt = 'A'

      ** Generate account key at start date or deletion date, except
      ** only if the transaction was entered and deleted on the same day

     C                   SELECT
     C                   WHEN      FSRECI = 'D'  AND  FSSDAT = BJRDNB
     C                   EVAL      WkEvnt = 'START DATE'
     C                   EVAL      WkType = 'D'
     C                   EVAL      WProcess = 'Y'

     C                   WHEN      FSRECI = '*'  AND  FSLCD = BJRDNB  AND
     C                             FSSDAT <> BJRDNB
     C                   EVAL      WkEvnt = 'DELETION DATE'
     C                   EVAL      WkType = 'D'
     C                   EVAL      WProcess = 'Y'

      ** Generate account key at maturity date

     C                   WHEN      FSRECI = 'D'  AND  FSMDAT = BJRDNB
     C**********                   OR FSUREF <> 0                                      229704 CLE148
     C                             OR FSUREF <> *BLANKS                                       CLE148
     C                   EVAL      WkEvnt = 'MATURITY DATE'
     C                   EVAL      WkType = 'M'
     C                   EVAL      WProcess = 'Y'

     C                   OTHER
     C                   EVAL      WProcess = 'N'
     C                   ENDSL

     C                   IF        WProcess = 'Y'
     C                   EVAL      KBRCA = FSBRCA
     C**********         EVAL      KUREF = FSUREF                                             CLE148
     C                   EVAL      KUREFA = FSUREF                                            CLE148
     C                   MOVEL     FSUREF        KUREF                                        CLE148

     C                   IF        FSMOD = 'DL'
     C                   EXSR      SRProcDL
     C                   ENDIF

     C                   IF        FSMOD = 'LE'
     C                   EXSR      SRProcLE
     C                   ENDIF
     C                   ENDIF
     C**********         ENDIF                                                                229704

     C                   READ      ASFHTRL2
     C                   ENDDO

      ** Write End of Report

     C                   EVAL      WkTrail = 'Y'
     C                   EXSR      SREndRep

      ** Update Trailer File

     C                   EXSR      SRUpdTrl

     C                   ENDIF

     C                   EVAL      *INLR = *ON

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcDL - Process Dealing FH                                *
      *                                                               *
      *****************************************************************

     C     SRProcDL      BEGSR

     C     KTran         CHAIN     DLDLHGL1

     C                   IF        NOT %FOUND(DLDLHGL1)
                                                                                              229704
     C**********         IF        FSUREF <> 0                                         229704 CLE148
     C                   IF        FSUREF <> *BLANKS                                          CLE148
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'DLDLHGL1'
     C                   MOVEL     FSUREF        DBKEY
     C                   EVAL      DBASE  = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE                                                                 229704
     C                   CLEAR                   DKEYSDPF                                     229704
     C                   ENDIF                                                                229704
                                                                                              229704
     C                   ELSE

     C                   EVAL      DKACSQ = DLCDAS
     C                   EVAL      DKVDAT = DLVDAT
     C                   EVAL      DKSLID = DLSLID
     C                   EVAL      DKBRTT = DLBRTT
     C                   EVAL      DKBRTE = DLBRTE
     C                   EVAL      DKRTSP = DLRTSP
     C                   EVAL      DKINTR = DLINTR
     C                   EVAL      DKYRAT = DLINTR
     C                   EVAL      DKCHNACH = DLCHNA
     C                   EVAL      DKPRFC = DLPRFC
     C                   EVAL      DKBOKC = DLBOKC
     C                   EVAL      DKRBDN = DLRBDN
     C                   EVAL      DKPTFR = DLPTFR
     C                   EVAL      DKSTCY = *BLANKS
                                                                                              229704
     C                   ENDIF                                                                229704

      ** Write Account Key in DKEYSDP

     C                   EXSR      SRWriteKey

      ** Write detail report

     C                   EXSR      SRReport
     C**********         ENDIF                                                                229704

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcLE - Process Lending FH                                *
      *                                                               *
      *****************************************************************

     C     SRProcLE      BEGSR

     C*****KTran         CHAIN     CLOANLB                                                    CLE148
     C     KTranLE       CHAIN     CLOANLB                                                    CLE148

     C                   IF        NOT %FOUND(CLOANLB)
                                                                                              229704
     C**********         IF        FSUREF <> 0                                         229704 CLE148
     C                   IF        FSUREF <> *BLANKS                                          CLE148
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'CLOANLB'
     C                   MOVEL     FSUREF        DBKEY
     C                   EVAL      DBASE  = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE                                                                 229704
     C                   CLEAR                   DKEYSDPF                                     229704
     C                   ENDIF                                                                229704
                                                                                              229704
     C                   ELSE

     C                   EVAL      DKACSQ = LELASQ
     C                   EVAL      DKVDAT = LEVDAT
     C                   EVAL      DKSLID = LESLID
     C                   EVAL      DKBRTT = LEBRTT
     C                   EVAL      DKBRTE = LEBRTE
     C                   EVAL      DKRTSP = LERTSP
     C                   EVAL      DKINTR = LEINTR
     C                   EVAL      DKYRAT = LEINTR
     C**********         EVAL      DKCHNACH = *ZEROS                                          CSD027
     C                   EVAL      DKCHNACH = *BLANKS                                         CSD027
     C                   EVAL      DKPRFC = LEPRFC
     C                   EVAL      DKBOKC = LEBOKC
     C                   EVAL      DKRBDN = *ZEROS
     C                   EVAL      DKPTFR = LEPTFR
     C                   EVAL      DKSTCY = LESCCY
                                                                                              229704
     C                   ENDIF                                                                229704

      ** Write Account Key in DKEYSDP

     C                   EXSR      SRWriteKey

      ** Write detail report

     C                   EXSR      SRReport
     C**********         ENDIF                                                                229704

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWriteKey - Write Account Key in DKEYSDP                    *
      *                                                               *
      *****************************************************************

     C     SRWriteKey    BEGSR

      ** Get Forecast Transaction's branch internal customer

     C                   EVAL      WkBRCA = FSBRCA
     C                   EXSR      SRBranch
     C                   MOVE      A8BICN        DKCNUM

     C                   EVAL      DKRECI = 'D'
     C*******************EVAL      DKAKEY = WAcctKey                                          CDL038
     C                   MOVEL     WAcctKey      DKAKEY                                       CDL038
     C**********         EVAL      DKDLNO = FSUREF                                            CLE148
     C                   MOVEL     FSUREF        DKDLNO                                       CLE148
     C                   EVAL      DKBRCA = FSBRCA
     C                   EVAL      DKEDAT = BJRDNB
     C                   EVAL      DKEAMT = FSAMNT
     C                   EVAL      DKECCY = FSCCY
     C                   EVAL      DKSETP = *ZEROS
     C                   EVAL      DKOSAC = *BLANKS
     C                   EVAL      DKREVI = *ZEROS
     C                   EVAL      DKOTHA = *ZEROS
     C                   EVAL      DKOTHC = *BLANKS
     C                   EVAL      DKEXRT = *ZEROS
     C                   EVAL      DKMDAT = FSMDAT
     C                   EVAL      DKFFVD = *ZEROS
     C                   EVAL      DKFFIN = *BLANKS
     C                   EVAL      DKZZ002 = *BLANKS
     C                   EVAL      DKFACO = *BLANKS
     C                   EVAL      DKOSBR = *BLANKS
     C                   EVAL      DKRTFC = *BLANKS

     C                   WRITE     DKEYSDPF

      ** Update Totals

     C                   EVAL      WkNoRec = WkNoRec + 1
     C                   EVAL      ZZAMT = DKEAMT / 1000

     C                   IF        ZZAMT < 0
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF

     C                   Z-ADD     WkVlInt       ZZTOTI
     C                   Z-ADD     WkVlDec       ZZTOTD
     C                   EXSR      SRGLZADD
     C                   Z-ADD     ZZTOTI        WkVlInt
     C                   Z-ADD     ZZTOTD        WkVlDec

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBranch - Access to AOBRCHR0                                *
      *                                                               *
      *****************************************************************

     C     SRBranch      BEGSR

     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      WkBRCA        PBranch
     C     SDBRCH        PARM      SDBRCH        DSSDY

     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBRCHPD'
     C                   EVAL      DBKEY  =  WkBRCA
     C                   EVAL      DBASE  =  003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdTrl - Update Trailer File                               *
      *                                                               *
      *****************************************************************

     C     SRUpdTrl      BEGSR

     C                   EVAL      DZNORE = WkNoRec
     C                   EVAL      DZHRWN = WkVlInt
     C                   EVAL      DZHRDC = WkVlDec
     C                   UPDATE    DKEYSZZF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkRCF - Register the P1 Printer File via RCF              *
      *                                                               *
      *****************************************************************

     C     SRChkRCF      BEGSR

     C                   OPEN      AS000014P1

      ** Ensure Spool File recorded by RCF

     C                   Z-ADD     SFNUM1        PZSNMU

     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM      *BLANKS       PSENTY
     C                   PARM      SFILE1        PSFILE
     C                   PARM                    PZSNMU
     C                   PARM      *BLANKS       PZSERR

      ** If Error occurs during ZSFILE processing, then return to the
      ** calling program

     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   WRITE     HEADP1

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReport - Write a Report                                    *
      *                                                               *
      *****************************************************************

     C     SRReport      BEGSR

     C                   IF        WkBRCA <> WPrvBRCA

     C                   IF        WPrvBRCA <> *BLANKS
     C                   EXSR      SREndRep
     C                   ENDIF

     C                   EXSR      SRBranch
     C                   EVAL      WPrvBRCA = WkBRCA
     C                   ENDIF

     C                   MOVE      DKCNUM        RCNUM
     C                   MOVE      DKDLNO        RTRAN
     C*******************EVAL      RAKEY = DKAKEY                                             CDL038
     C                   MOVEL     DKAKEY        RAKEY                                        CDL038
     C                   EVAL      RCURR = DKECCY
     C                   EVAL      RMOD  = FSMOD
     C                   EVAL      REVNT = WkEvnt

      ** Retrieve number of decimal places

     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      DKECCY        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 004
     C                   EVAL      DBKEY = PCurr
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Format Amount

     C                   EVAL      PFLD15 = DKEAMT
     C                   EVAL      PDECS = A6NBDP
     C                   EVAL      PECODE = 'J'

     C                   CALLB     'ZFRPED'
     C                   PARM                    PFLD15
     C                   PARM                    PDECS
     C                   PARM                    PECODE
     C                   PARM                    POUT22
     C                   PARM                    POUT25

     C                   EVAL      RAMNT = POUT22

     C                   IF        *IN01 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN01 = *OFF
     C                   ENDIF

     C                   WRITE     DETAIL

     C                   EVAL      WrkNORE = WrkNORE + 1

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Audit Report                                       *
      *                                                               *
      *****************************************************************

     C     SRAudit       BEGSR

     C                   WRITE     HEADAU
     C                   WRITE     NODTLS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndRep - Write the End of the Report                       *
      *                                                               *
      *****************************************************************

     C     SREndRep      BEGSR

      ** Format no. of records

     C                   Z-ADD     WrkNORE       PFLD15
     C                   Z-ADD     0             PDECS
     C                   EVAL      PECODE = 'J'

     C                   CALLB     'ZFRPED'
     C                   PARM                    PFLD15
     C                   PARM                    PDECS
     C                   PARM                    PECODE
     C                   PARM                    POUT22
     C                   PARM                    POUT25

     C                   MOVE      POUT22        RNOREC

     C                   IF        *IN01 = *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN01 = *OFF
     C                   ENDIF

     C                   IF        WkTrail = 'Y'
     C                   WRITE     TRAILP1
     C                   ENDIF

     C                   EVAL      *IN01 = *ON

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkRCFA - Register the AU Printer File via RCF             *
      *                                                               *
      *****************************************************************

     C     SRChkRCFA     BEGSR

      ** Ensure Audit Spool File recorded by RCF

     C                   Z-ADD     SFNUMU        PZSNMU

     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM      *BLANKS       PSENTY
     C                   PARM      SFILEU        PSFILE
     C                   PARM                    PZSNMU
     C                   PARM      *BLANKS       PZSERR

      ** If Error occurs during ZSFILE processing, then return to the
      ** calling program

     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGLZADD - Subroutine to add an amount to the total          *
      *                                                               *
      *****************************************************************

     C     SRGLZADD      BEGSR

     C                   Z-ADD     ZZAMT         ZZAMT                    91

     C                   IF        *IN91 = *ON
     C                   GOTO      ZZAEND
     C                   ENDIF

      ** Split ZZAMT into integer and decimal fields

     C                   Z-ADD     ZZAMT         ZZAMTI
     C                   MOVE      ZZAMT         ZZAMTD

      ** Both ZZAMTI and ZZAMTD contain a 'SIGN' zone now

     C                   EXSR      SRGLZSUM

     C     ZZAEND        ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGLZSUM - Subroutine to carry out the additon for SRGLZADD  *
      *                                                               *
      *****************************************************************

     C     SRGLZSUM      BEGSR

     C                   Z-ADD     ZZTOTI        ZZTOTI
     C                   Z-ADD     ZZTOTD        ZZTOTD
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN99 = *OFF

      ** Determine sign of ZZAMTI & D, 92 if neg.

     C     ZZAMTI        COMP      0                                    9293

     C                   IF        *IN93 = *ON
     C     ZZAMTD        COMP      0                                    9293
     C                   ENDIF

     C                   IF        *IN93 = *ON
     C                   GOTO      ZZSEND
     C                   ENDIF

      ** Determine sign of ZZTOTI & D, 91 if neg.

     C     ZZTOTI        COMP      0                                    9193

     C                   IF        *IN93 = *ON
     C     ZZTOTD        COMP      0                                    9193
     C                   ENDIF

      ** If ZZTOTAL is zero, return ZZAMOUNT.

     C                   IF        *IN93 = *ON
     C                   Z-ADD     ZZAMTI        ZZTOTI
     C                   Z-ADD     ZZAMTD        ZZTOTD
     C                   GOTO      ZZSEND
     C                   ENDIF

      ** If signs differ bypass overflow checks.

     C                   IF        *IN91 = *ON AND
     C                             *IN92 = *OFF OR
     C                             *IN91 = *OFF AND
     C                             *IN92 = *ON
     C                   GOTO      ZZOFPS
     C                   ENDIF

     C     ZZAMTD        ADD       ZZTOTD        ZZWK2
     C     ZZWK2         COMP      999                                93

     C                   IF        *IN93 = *OFF
     C     ZZWK2         COMP      -999                                 93
     C                   ENDIF

     C                   IF        *IN93 = *ON AND
     C                             *IN92 = *OFF
     C     ZZAMTI        ADD       1             ZZWK3
     C                   ENDIF

     C                   IF        *IN93 = *ON AND
     C                             *IN92 = *ON
     C     ZZAMTI        SUB       1             ZZWK3
     C                   ENDIF

     C                   IF        *IN93 = *ON
     C     ZZTOTI        ADD       ZZWK3         ZZWK3
     C                   ENDIF

     C                   IF        *IN93 = *OFF
     C     ZZTOTI        ADD       ZZAMTI        ZZWK3
     C                   ENDIF

      ** If the modulus of ZZWK3 is lt mod. ZZTOTI then O/F has occurred

     C                   IF        *IN92 = *OFF
     C     ZZWK3         COMP      ZZTOTI                               99
     C                   ENDIF

     C                   IF        *IN92 = *ON
     C     ZZWK3         COMP      ZZTOTI                             99
     C                   ENDIF

     C                   IF        *IN99 = *OFF
     C                   Z-ADD     ZZWK2         ZZTOTD
     C                   Z-ADD     ZZWK3         ZZTOTI
     C                   ENDIF

      ** If O/F zeroise ZZAMT, ind '99' set and ZZTOT fields left intact

     C                   IF        *IN99 = *ON
     C                   Z-ADD     0             ZZAMT
     C                   ENDIF

     C                   GOTO      ZZSEND

      ** The 'SIGNS' are different

     C     ZZOFPS        TAG

      ** If ZZAMT was negative, make it pos. to comp with ZZTOT

     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF

      ** If ZZTOT was negative, make it pos. to comp with ZZAMT.

     C                   IF        *IN91 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF

      ** Both ZZAMT and ZZTOT are noe positive

     C     ZZTOTI        COMP      ZZAMTI                             93  95

     C                   IF        *IN95 = *ON
     C     ZZTOTD        COMP      ZZAMTD                             93  95
     C                   ENDIF

      ** If ZZTOT eq. ZZAMT return zero.

     C                   IF        *IN95 = *ON
     C                   Z-ADD     0             ZZTOTI
     C                   Z-ADD     0             ZZTOTD
     C                   GOTO      ZZSEND
     C                   ENDIF

      ** If ZZTOT gt. ZZAMT.

     C                   IF        *IN93 = *ON
     C     ZZAMTD        COMP      ZZTOTD                             94
     C                   ENDIF

     C                   IF        *IN93 = *ON AND
     C                             *IN94 = *ON
     C     ZZTOTI        SUB       1             ZZTOTI
     C     ZZTOTD        ADD       1000          ZZWK2
     C                   ENDIF

     C                   IF        *IN93 = *ON
     C     ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C                   ENDIF

     C                   IF        *IN93 = *ON AND
     C                             *IN94 = *ON
     C     ZZWK2         SUB       ZZAMTD        ZZTOTD
     C                   ENDIF

     C                   IF        *IN93 = *ON AND
     C                             *IN94 = *OFF
     C     ZZTOTD        SUB       ZZAMTD        ZZTOTD
     C                   ENDIF

      ** If ZZAMT gt. ZZTOT.

     C                   IF        *IN93 = *OFF
     C     ZZTOTD        COMP      ZZAMTD                             94
     C                   ENDIF

     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *ON
     C     ZZAMTI        SUB       1             ZZWK3
     C     ZZAMTD        ADD       1000          ZZWK2
     C     ZZWK3         SUB       ZZTOTI        ZZTOTI
     C                   ENDIF

     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *OFF
     C     ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C                   ENDIF

     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *ON
     C     ZZWK2         SUB       ZZTOTD        ZZTOTD
     C                   ENDIF

     C                   IF        *IN93 = *OFF AND
     C                             *IN94 = *OFF
     C     ZZAMTD        SUB       ZZTOTD        ZZTOTD
     C                   ENDIF

      ** Reverse sign of ZZTOT if larger I/P fields were negative

     C                   EVAL      *IN94 = *OFF

     C                   IF        *IN93 = *ON AND
     C                             *IN91 = *ON OR
     C                             *IN93 = *OFF AND
     C                             *IN92 = *ON
     C                   EVAL      *IN94 = *ON
     C                   ENDIF

     C                   IF        *IN94 = *ON
     C                   Z-SUB     ZZTOTI        ZZTOTI
     C                   Z-SUB     ZZTOTD        ZZTOTD
     C                   ENDIF

      ** Restore sign of ZZAMTI & ZZAMTD If It was reversed.

     C                   IF        *IN92 = *ON
     C                   Z-SUB     ZZAMTI        ZZAMTI
     C                   Z-SUB     ZZAMTD        ZZAMTD
     C                   ENDIF

     C     ZZSEND        TAG

      ** If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD.

     C                   EVAL      *IN96 = *OFF

     C     ZZTOTD        COMP      0                                      91

     C                   IF        *IN91 = *ON
     C     ZZTOTI        COMP      0                                    96
     C                   ENDIF

     C                   IF        *IN96 = *ON
     C                   MOVE      '.000-'       ZZNEGD
     C                   ENDIF

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
     C                   EVAL      DBPGM = 'AS000014'
     C                   OUT       LDA

      ** Access bank details

     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Get the Event Control Date (Next Working Day - 1)

     C                   EVAL      WkEVCD = BJDNWD - 1

      ** Access the Midas Modules

     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDMMOD        PARM      SDMMOD        DSSDY

     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDMMODPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  006
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Set on Indicator for Multi-Branching process

     C                   IF        BGMBIN = 'Y'
     C                   EVAL      *IN37 = *ON
     C                   ENDIF

     C                   CALLB     'ZDATE2'
     C                   PARM                    WkEVCD
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANKS       REVCD

      ** Read Trailer file DKEYSZZ

     C                   READ      DKEYSZZ

     C                   IF        %EOF(DKEYSZZ)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'DKEYSZZ'
     C                   EVAL      DBKEY  =  'READ'
     C                   EVAL      DBASE  =  007
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ELSE
     C                   EVAL      WkNoRec = DZNORE
     C                   EVAL      WkVlInt = DZHRWN
     C                   EVAL      WkVlDec = DZHRDC
     C                   ENDIF

     C                   EVAL      WrkNORE = *ZEROS
     C                   EVAL      WkTrail = 'N'

      ** Key list for DLDLHGL1 and CLOANLB

     C     KTran         KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KUREF
      *                                                                                       CLE148
      ** Key list for CLOANLB                                                                 CLE148
      *                                                                                       CLE148
     C     KTranLE       KLIST                                                                CLE148
     C                   KFLD                    KBRCA                                        CLE148
     C                   KFLD                    KUREFA                                       CLE148

     C                   ENDSR

      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      *  *PSSR  - Program exception error routine                         *
      *           Called automatically if a program error occurs,         *
      *           or directly by the program code using EXSR.             *
      *           This subroutine DUMPs the program just once.            *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   DUMP
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

