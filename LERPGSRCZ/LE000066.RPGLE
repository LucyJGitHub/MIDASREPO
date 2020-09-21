     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Update Faclty Hist based on FCIP Changes')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000066 - Update Facility History File based on FCIP        *
      *             Changes                                           *
      *                                                               *
      *  Function:  This program will rebuild the facility and its    *
      *  (CoB)      historical file based on the new credit agreement *
      *             facility structure amended during input cycle.    *
      *                                                               *
      *  Called By: LERC30A - Midas LE Facility History Update 2      *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD054782           Date 04Dec19               *
      *                 AR674226           Date 04Dec19               *
      *                 CLE168             Date 26Feb18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE148             Date 23Jul12               *
      *                 AR865353           Date 16Nov11               *
      *                 AR862472           Date 10Nov11               *
      *                 CLE147  *CREATE    Date 28Oct11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD054782 - SQNO and TSEQ conflicting with other file.        *
      *             Rename to @@FSQNO and @@FTSEQ.                    *
      *  AR674226 - Manual transaction reached 999. Increase the size *
      *             of utilisation sequence no. and transaction       *
      *             sequence. Recompile. (Child: AR674227)            *
      *           - Applied for MD054782.                             *
      *  CLE168 - Allow Debit of Blocked Account (Recompile)          *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR865353 - Manual Utilisation of tranche not accumulated     *
      *             to its current Credit Agreement                   *
      *  AR862472 - Some Structure Change Flags were not reset        *
      *             after COB. Also, LF to get tranche/GF currency    *
      *             was change to correct DB error in COB.            *
      *  CLE147 - Aggregate Facility                                  *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     F***LEFCLTLH  UF   E           K DISK    INFSR(*PSSR)                                  AR862472
     FLEFCLTLU  UF   E           K DISK    INFSR(*PSSR)                                     AR862472
     F                                     COMMIT
      ** Midas LE Facilities Extension File by Facility

     F***LEFCLTJ0  IF   E           K DISK    INFSR(*PSSR)                                  AR862472
     FFCLTYL0   IF   E           K DISK    INFSR(*PSSR)                                     AR862472
     F                                     RENAME(FCLTYFMF:TRFCLTFM)                        AR862472
     F                                     PREFIX(TR)
      ** Midas LE Customer Lending Facility File

     FFACHSAL8  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Facilities History File by Facility

     FFCLTYL3   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CA)
      ** Midas LE Facilities File - Record A

     FHISACT    O    E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas LE History Actions File

     FFACACT    UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AC:2)
     F                                     COMMIT
      ** Midas LE Facilities with Actions File

     FFACHSAL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FACHISAF:@@CHISAF)
     F                                     PREFIX(@@:2)
     F                                     COMMIT
      ** Midas LE Facilities History File by Date


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

      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Currency Details Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WRun            S              1A
     D PRetCode        S              7A
     D POption         S              7A
     D W#FcltySeq      S                   LIKE(FATSEQ)

      ** Key Fields
     D KTRFTP          S              3  0
     D KTRFNO          S              2  0
     D KCXFTP          S              5  0
     D KCOFTP          S              5  0
     D K#CANM          S              6A
     D K#CAFT          S              3  0
     D K#CAFN          S              2  0


      ** Parameters for ZXRATE module
     D ZRATE1          S             13P 8
     D ZMDI1           S              1
     D ZRATE2          S             13P 8
     D ZMDI2           S              1
     D ZRATEX          S             13P 8
     D ZMDIX           S              1

      ** Parameters for ZCONVZ1 module
     D ZAMTCI          S             15  0
     D ZEXCH           S             13P 8
     D ZMD             S              1
     D ZCCYI           S              3
     D ZCCYO           S              3
     D ZCDPI           S              1  0
     D ZCDPO           S              1  0
     D ZAMTCO          S             15  0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     I@@CHISAF                                                                              MD054782
     I              FASQNO                      @@FSQNO                                     MD054782
     I              FATSEQ                      @@FTSEQ                                     MD054782
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Read all records from the Facilities Extension file whose Detach/Attach
      ** action indicator is not equal to blanks

     C******LOVAL        SETLL     LEFCLTLH                                                 AR862472
     C**********         READ      LEFCLTLH                               10                AR862472
     C     *LOVAL        SETLL     LEFCLTLU                                                 AR862472
     C                   READ      LEFCLTLU                               10                AR862472

     C                   DOW       *IN10 = *OFF

     C                   IF        FCAXTN <> *BLANKS
     C                   MOVE      FCXFTP        KTRFTP
     C                   MOVE      FCXFNO        KTRFNO

     C*****KeyTranche    CHAIN     LEFCLTJ0                           11                    AR862472
     C     KeyTranche    CHAIN     FCLTYL0                            11                    AR862472
     C                   IF        *IN11 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C**********         EVAL      DBFILE = 'LEFCLTJ0'                                      AR862472
     C                   EVAL      DBFILE = 'FCLTYL0 '                                      AR862472
     C                   EVAL      DBKEY = FCXBRC + FCXFCU + FCXFTP + FCXFNO
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C
     C                   MOVEL     FCXFTP        KCXFTP
     C                   MOVE      FCXFNO        KCXFTP

      ** If CA action is attach

     C                   IF        FCAXTN = 'A'
     C                   EXSR      SrAttach

      ** If CA action is detach

     C                   ELSEIF     FCAXTN = 'D'
     C                   EXSR      SrDetach

      ** If CA action is change

     C                   ELSEIF     FCAXTN = 'C'
     C                   EXSR      SrDetach
     C                   EXSR      SrAttach
     C                   ENDIF
     C                   ENDIF                                                              AR862472

      ** Reset CA Change Flags and Attach/Detach Indicator

     C                   EVAL      FCOAFL = *BLANKS
     C                   EVAL      FCCHFL = *BLANKS
     C                   EVAL      FCAXTN = *BLANKS
     C                   UPDATE    LEFCLTD0
     C**********         ENDIF                                                              AR862472

      ** Read next record
     C**********         READ      LEFCLTLH                               10                AR862472
     C                   READ      LEFCLTLU                               10                AR862472

     C                   ENDDO

      ** Commit changes and terminate program

     C                   COMMIT
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAttach - Subroutine to process attach 'A' action           *
      *                                                               *
      *****************************************************************
     C     SrAttach      BEGSR

     C                   MOVE      0             W#FcltySeq

     C     KeyFCHSL8     SETLL     FACHSAL8
     C     KeyFCHSL8     READE     FACHSAL8                               99

     C     *IN99         DOWEQ     *OFF
     C                   IF        FARECI = 'D'

     C                   EVAL      W#FcltySeq = W#FcltySeq + 1

     C                   MOVE      FCCANM        K#CANM
     C                   MOVE      FCCAFT        K#CAFT
     C                   MOVE      FCCAFN        K#CAFN

      ** Access CA record for amount conversion

     C     KeyRecCA      CHAIN     FCLTYL3                            89
     C                   IF        *IN89 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'FCLTYL3 '
     C                   EVAL      DBKEY = FCCANM + FCCAFT + FCCAFN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Copy details from tranche record but this will be a new
      ** record for the credit agreement facility

     C                   EVAL      BRCA   = CABRCA
     C                   EVAL      HACNUM = FCCANM
     C                   MOVEL     FCCAFT        HAFCTY
     C                   MOVE      FCCAFN        HAFCTY
     C                   EVAL      HADATE = BJRDNB
     C                   EVAL      HASEQ  = W#FcltySeq
     C                   EVAL      HALOAN = FALOAN
     C                   EVAL      HAACTN = FAACTN

      ** If tranche currency is different from the CA currency, convert
      ** amount to CA currency

     C                   IF        TRFCCY <> CAFCCY
     C                   EXSR      SRConvertAmt
     C                   ELSE
     C                   EVAL      HAAAMT = FAAAMT
     C                   ENDIF

     C                   EVAL      HAPART = FAPART
     C                   EVAL      HALCRF = FALCRF
     C                   EVAL      GEDT   = FAGNDT
     C                   EVAL      HASQNO = FASQNO
     C                   EVAL      HAECIN = *BLANKS
     C                   EVAL      HARCIN = CARVCR
     C                   EVAL      HAGASS = FAGASS
     C                   EVAL      HATRRC = FARCIN
     C                   EVAL      HAOLRC = *BLANKS
     C                   EVAL      HATSEQ = W#FcltySeq
     C                   EVAL      HALUCY = FALUCY
     C                   EVAL      HALUAM = FALUAM
     C                   EVAL      HAEXRT = FAEXRT
     C                   EVAL      HARTMD = FARTMD
     C                   EVAL      HAPTYP = FAPTYP
     C                   EVAL      HARCSI = FARCSI
     C                   EVAL      HALPFI = FALPFI
     C                   EVAL      HADEAL = FADEAL
     C                   EVAL      HAMCY  = FAMCY
     C                   EVAL      HAACBR = FAACBR
     C                   EVAL      HAACCU = FAACCU
     C                   EVAL      HAACCY = FAACCY
     C                   EVAL      HAACCD = FAACCD
     C                   EVAL      HAACSQ = FAACSQ
     C                   EVAL      HAACNO = FAACNO
     C                   EVAL      HATTEO = FATTEO
     C                   EVAL      HAPTEO = FAPTEO
     C                   EVAL      HAEXCY = FAEXCY
     C                   EVAL      HATVAL = FATVAL
     C                   EVAL      HAWEIG = FAWEIG
     C                   EVAL      HAWCPC = FAWCPC
     C                   EVAL      HAINOF = FAINOF
     C                   EVAL      HAFXMT = FAFXMT
     C                   EVAL      HAFXPC = FAFXPC
     C                   EVAL      HARIND = FARIND
     C
     C                   WRITE     HISACTF

      ** Write CA record in FACACT if not yet existing

     C                   MOVE      BRCA          KABRCA
     C                   MOVE      HACNUM        KACNUM
     C                   MOVE      HAFCTY        KAFCTY
     C     KeyFACACT     CHAIN     FACACT                             88
     C     *IN88         IFEQ      *ON
     C                   MOVE      BRCA          ACCA
     C                   MOVE      HACNUM        ACCNUM
     C                   MOVEL     HAFCTY        ACFCTY
     C                   MOVE      BJRDNB        ACDATE
     C                   WRITE     FACACTF
     C                   ENDIF
     C                   ENDIF

     C     KeyFCHSL8     READE     FACHSAL8                               99
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDetach - Subroutine to process detach 'D' action           *
      *                                                               *
      *****************************************************************
     C     SrDetach      BEGSR

      ** Access tranche records from Facility History file

     C     KeyFCHSL8     SETLL     FACHSAL8
     C     KeyFCHSL8     READE     FACHSAL8                               99

     C     *IN99         DOWEQ     *OFF
     C                   MOVEL     FCOAFT        KCOFTP
     C                   MOVE      FCOAFN        KCOFTP

     C     KeyFCHSL1     SETLL     FACHSAL1
     C     KeyFCHSL1     READE     FACHSAL1                               98
     C     *IN98         DOWEQ     *OFF

     C                   IF        FALOAN = @@LOAN AND
     C                             FADEAL = @@DEAL AND
     C                             FAACNO = @@ACNO AND
     C**********                   FASQNO = @@SQNO AND                             AR865353 MD054782
     C                             FASQNO = @@FSQNO AND                                     MD054782
     C                             FAACTN = @@ACTN

      ** Delete corresponding CA transaction of each tranche

     C                   DELETE    @@CHISAF

      ** Write CA record in FACACT if not existing

     C                   MOVE      @@CA          KABRCA            3
     C                   MOVE      FCOANM        KACNUM            6
     C                   MOVE      KCOFTP        KAFCTY            5 0
     C     KeyFACACT     CHAIN     FACACT                             88
     C     *IN88         IFEQ      *ON
     C                   MOVE      @@CA          ACCA
     C                   MOVE      FCOANM        ACCNUM
     C                   MOVEL     FCOAFT        ACFCTY
     C                   MOVE      FCOAFN        ACFCTY
     C                   MOVE      BJRDNB        ACDATE
     C                   WRITE     FACACTF
     C                   ENDIF
     C                   ENDIF

     C     KeyFCHSL1     READE     FACHSAL1                               98
     C                   ENDDO

     C     KeyFCHSL8     READE     FACHSAL8                               99
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRConvertAmt - Subroutine to Convert tranche amount to CA    *
      *                                                               *
      *****************************************************************
     C     SRConvertAmt  BEGSR

      ** Get the cross rate between the tranche's currency and credit
      ** agreement's currency

     C                   EVAL      ZCCYI = TRFCCY
     C                   EVAL      ZCCYO = CAFCCY
     C                   EXSR      SRGetXRate

     C                   EVAL      ZEXCH = ZRATEX
     C                   EVAL      ZMD = ZMDIX

      ** Convert Action Amount to CA's currency

     C                   EVAL      ZAMTCI = FAAAMT
     C                   EXSR      SRCvtAmount
     C                   EVAL      HAAAMT = ZAMTCO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetXRate - Subroutine to Get the Cross Rate between Two    *
      *               Currencies                                      *
      *                                                               *
      *****************************************************************
     C     SRGetXRate    BEGSR

     C                   EVAL      I#LFD1 = ZCCYI
     C                   EXSR      SRGetCurDet
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZCDPI = A6NBDP

     C                   EVAL      I#LFD1 = ZCCYO
     C                   EXSR      SRGetCurDet
     C                   EVAL      ZRATE2 = A6SPRT
     C                   EVAL      ZMDI2 = A6MDIN
     C                   EVAL      ZCDPO = A6NBDP

     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
      ** Output
     C                   PARM      *ZEROS        ZRATEX
     C                   PARM      *BLANKS       ZMDIX

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCurDet - Subroutine that Retrieves Currency Details via *
      *                *MODULE/MXACSCURR                              *
      *                                                               *
      *****************************************************************
     C     SRGetCurDet   BEGSR

     C                   CALLB     'MXACSCURR'
      /COPY MXCPYSRC,MXACSPRME

     C                   IF        ACS_RTCD = '*ERROR '
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = I#LFD1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      SDCURR = InData

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtAmount - Subroutine that Converts Amount via            *
      *                *MODULE/ZCONVZ1                                *
      *                                                               *
      *****************************************************************
     C     SRCvtAmount   BEGSR

     C                   CALL      'ZCONVZ1'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
      ** Output
     C                   PARM      *ZEROS        ZAMTCO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPGM = 'LE000066'
     C                   EVAL      DBMOD = 'LE000066'
     C                   EVAL      DBASE = *ZEROS
     C                   OUT       LDA

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Key list for Tranche Facility
     C     KeyTranche    KLIST
     C**********         KFLD                    FCXBRC                                     AR862472
     C                   KFLD                    FCXFCU
     C                   KFLD                    KTRFTP
     C                   KFLD                    KTRFNO

      ** Key list for Tranche Facility - FACHSAL8
     C     KeyFCHSL8     KLIST
     C                   KFLD                    FCXFCU
     C                   KFLD                    KCXFTP

      ** Key list for Prev CA Facility - FACHSAL1
     C     KeyFCHSL1     KLIST
     C                   KFLD                    FCOANM
     C                   KFLD                    KCOFTP

      ** Key list for Recomputation - FCLTYL3
     C     KeyRecCA      KLIST
     C                   KFLD                    K#CANM
     C                   KFLD                    K#CAFT
     C                   KFLD                    K#CAFN

      ** Key list for Curr/Prev - FACACT
     C     KeyFACACT     KLIST
     C                   KFLD                    KABRCA
     C                   KFLD                    KACNUM
     C                   KFLD                    KAFCTY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
