     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility Hist Update for Retail Int.Cap.')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000030A - Midas LE Facility History Update for Retail      *
      *              Interest Capitalisation                          *
      *                                                               *
      *  Function:   This program will process retail account linked  *
      *              to facilities and generate facility history      *
      *              event for Interest Capitalisation. This program  *
      *              is patterned to core CLE025 program LE000030.    *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD052994  *CREATE  Date 25Nov19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052994 - CL Facility Event not Generated for Retail        *
      *             Account Debit Capitalised Interests               *
      *                                                               *
      *****************************************************************

     FREGEICPD  IF   E             DISK    INFSR(*PSSR)
     FACCNTJ2   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(A2)
     FFCLTYL3   IF   E           K DISK    INFSR(*PSSR)
     FPEFCLFL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFMP)

     FFACACTL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FFACHISHL  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FGLACNTL3  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FHISACT    O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     FLE000030P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN

      *****************************************************************
      /EJECT
      *****************************************************************

     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASEs

     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

      *****************************************************************
      /EJECT
      *****************************************************************

     D LERSTS        E DS                  EXTNAME(LERSTS) DTAARA
      ** LE Status Data Area

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details

     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** External DS for account code details

     D SDPLIN        E DS                  EXTNAME(SDPLINPD)
     D                                     PREFIX(PL)
      ** External DS for instrument type details

     D SDWEIG        E DS                  EXTNAME(GPWEIGPD)
      ** External DS for instrument type details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for customer details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for currency details

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for switchable details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure

     D SPOOL1          DS
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0

     D WACDBKEY        DS
     D  KACCNUM                            LIKE(A2CNUM)
     D  KACCCY                             LIKE(A2CCY)
     D  KACACOD                            LIKE(A2ACOD)
     D  KACACSQ                            LIKE(A2ACSQ)
     D  KACBRCA                            LIKE(A2BRCA)

     D WACCOUNT        DS
     D  RCUST                  1      6
     D  RDASH1                 7      7
     D  RCCY                   8     10
     D  RDASH2                11     11
     D  RACOD                 12     21
     D  RDASH3                22     22
     D  RACSQ                 23     24
     D  RDASH4                25     25
     D  RBRCA                 26     28

     D WFCLTY          DS
     D  RFCCU                  1      6
     D  RDASH5                 7      7
     D  RFACT                  8     10
     D  RDASH6                11     11
     D  RFCNO                 12     13

      ** Declared Variables

     D WCCY1           S              3
     D WCCY2           S              3
     D WINAMT          S             15  0
     D WOUTAMT         S             15  0
     D WRATE           S             13  8
     D WSPRT1          S             13  8
     D WSPRT2          S             13  8
     D XSPRT1          S             13  8
     D XSPRT2          S             13  8
     D WMDIN           S              1
     D WMDIN1          S              1
     D WMDIN2          S              1
     D XMDIN1          S              1
     D XMDIN2          S              1
     D WNBDP1          S              1  0
     D WNBDP2          S              1  0

      ** Access Object Variables

     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
     D PACOD           S             10
     D PCNUM           S             10
     D PCNST           S              7
     D CLE023          S              1

      ** Key Field Variables

     D WCUST           S                   LIKE(A2FCCU)
     D WFCLT           S                   LIKE(A2FACT)
     D WFCSQ           S                   LIKE(A2FCNO)

     D KFCNUM          S                   LIKE(FHCNUM)
     D KFFACT          S                   LIKE(FHFTYP)
     D KFFCNO          S                   LIKE(FHFSEQ)

     D KBRCA           S                   LIKE(BRCA)
     D KCNUM           S                   LIKE(FCCNUM)
     D KFCTY           S                   LIKE(FCFCTY)

     D KHBRCA          S                   LIKE(BRCA)
     D KHCNUM          S                   LIKE(FHCNUM)
     D KHFACT          S                   LIKE(FHFTYP)
     D KHFCNO          S                   LIKE(FHFSEQ)

      ** Work Variables

     D WACTBAL         S             15  0
     D WTEOP           S             15  0
     D WTEOF           S             15  0
     D WTEOC           S             15  0
     D WACTION         S              2
     D WACTDAT         S              5  0
     D WACTCCY         S              3
     D WREVAMT         S             15  0
     D WACTAMT         S             15  0
     D WTRMDIN         S              1
     D WTRXRAT         S             13  8
     D WWEICDE         S              2S 0
     D WWCDPCT         S              3  0
     D WINCOFF         S              1
     D WEXPOFF         S             15  0

     D DIFLN1          S              3  0
     D RQDLN1          S              3  0

     D ORFCCY          S                   LIKE(FCCY)
     D PFCCY           S                   LIKE(FCCY)
     D PCACY           S                   LIKE(CACY)
     D GIVEN           S              1
     D WERROR          S              1
     D WUPDAT          S              1
     D WRUN            S              1

      ** Standard Subroutine Parameters

     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Rename fields

     IFCLTYFMF
     I              BRCA                        FMBRCA
     I              ORED                        FMORED

     IFCLTYFMP
     I              BRCA                        FMBRCA

     IFACACTF
     I              BRCA                        RSBRCA

      *****************************************************************
      /EJECT
      *****************************************************************

      ** MAIN PROCESSING
      ** Process extracted Retail Interest Capitalisation

     C                   EXSR      SrREGEIC

      ** Close report file

     C                   EXSR      SrENDRPT

     C                   COMMIT
     C                   EVAL      *INLR = *ON
     C                   RETURN


      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrREGEIC - Process extracted Retail Interest Capitalisation   *
      *                                                               *
      *****************************************************************
     C     SrREGEIC      BEGSR

      ** Read first record

     C     *START        SETLL     REGEICPD
     C                   READ      REGEICPD

     C                   DOW       NOT %EOF(REGEICPD)

      ** Only process records if posting amount not to zero

     C                   IF        GEPSTA <> 0
     C
     C                   EVAL      KACCNUM = GECNUM
     C                   EVAL      KACCCY  = GECCY
     C                   EVAL      KACACOD = GEACOD
     C                   EVAL      KACACSQ = GEACSQ
     C                   EVAL      KACBRCA = GEBRCA

     C     KACCNT        CHAIN     ACCNTJ2

      ** Database error

     C                   IF        NOT %FOUND(ACCNTJ2)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = WACDBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE

     C                   EVAL      WCUST = A2FCCU
     C                   EVAL      WFCLT = A2FACT
     C                   EVAL      WFCSQ = A2FCNO

     C                   IF        WCUST <> *BLANKS and WCUST <> *ZEROS and
     C                             WFCLT <> *ZEROS  and WFCSQ <> *ZEROS

      ** Initialise fields

     C                   EVAL      WACTBAL = A2F1ACBL
     C                   EVAL      WTEOP = A2F1TEXO
     C                   EVAL      WTEOF = A2F1TEOF
     C                   EVAL      WTEOC = A2F1TEOC

     C                   IF        GEDRCR = 0
     C                   EVAL      WACTBAL = WACTBAL + GEPSTA
     C                   ELSE
     C                   EVAL      WACTBAL = WACTBAL - GEPSTA
     C                   ENDIF

      ** Generate 'AC' entry

     C                   EVAL      KFCNUM = A2FCCU
     C                   EVAL      KFFACT = A2FACT
     C                   EVAL      KFFCNO = A2FCNO
     C                   EVAL      WACTION = 'AC'
     C                   EVAL      WACTCCY = A2CCY
     C                   EVAL      WACTDAT = BJRDNB

      ** Determine Current Valuation Details

     C                   EXSR      SrCVALDET

     C                   EVAL      WREVAMT = WEXPOFF

      ** Process Action

     C                   EXSR      SrPROCACT

      ** Update GLACNTQD

     C     KACCNT        CHAIN     GLACNTL3

     C                   IF        %FOUND(GLACNTL3)

     C                   EVAL      F1ACBL = WACTBAL
     C                   EVAL      F1TEXO = WEXPOFF

     C                   EVAL      WCCY1 = GECCY
     C                   EVAL      WCCY2 = ORFCCY
     C                   EVAL      WINAMT = WEXPOFF
     C                   EXSR      SrCONVERT
     C                   EVAL      F1TEOF = WOUTAMT

      ** If facility is tranche

     C                   MOVE      WCUST         KFCNUM
     C                   MOVE      WFCLT         KFFACT
     C                   MOVE      WFCSQ         KFFCNO

     C     KFCLTY        CHAIN     FCLTYL3

     C                   IF        %FOUND(FCLTYL3) and TRCA = 'TR'
     C                   EVAL      WCCY1 = ORFCCY
     C                   EVAL      WCCY2 = CACY
     C                   EVAL      WINAMT = F1TEOF
     C                   EVAL      WRATE = WTRXRAT
     C                   EVAL      WMDIN = WTRMDIN
     C                   EVAL      GIVEN = 'Y'
     C                   EXSR      SrCONVERT
     C                   EVAL      F1TEOC = WOUTAMT
     C                   ENDIF

     C                   UPDATE    GLACNTD0

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Read next record

     C                   READ      REGEICPD

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCVALDET - Determine Current Valuation Details               *
      *                                                               *
      *****************************************************************
     C     SrCVALDET     BEGSR

      ** Access Account Code details

     C                   MOVE      A2ACOD        PACOD
     C                   CALLB     'AOACODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PACOD
     C     SDACOD        PARM      SDACOD        DSSDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDACODPD'
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = PACOD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access Instrument Types

     C                   CALL      'AOPLINR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    A5INNR
     C     SDPLIN        PARM      SDPLIN        DSFDY

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      WWEICDE = *ZEROS
     C                   EVAL      WWCDPCT = 100
     C                   EVAL      WINCOFF = 'Y'
     C                   ELSE

     C                   EVAL      WINCOFF = PLPDINOF

     C                   IF        WINCOFF = 'C'

     C                   MOVEL     A2CNUM        PCNUM

      ** Access Customer details

     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNUM
     C                   PARM                    PCNST
     C     SDCUST        PARM      SDCUST        DSSDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 004
     C                   EVAL      DBKEY = PCNUM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WINCOFF = BBINOF
     C                   ENDIF

     C                   ENDIF

      ** Access Instrument Types

     C                   CALL      'GPAOWEIGR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PLPDWEIG
     C     SDWEIG        PARM      SDWEIG        DSFDY

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      WWEICDE = PLPDWEIG
     C                   EVAL      WWCDPCT = 100
     C                   ELSE
     C                   EVAL      WWEICDE = PLPDWEIG
     C                   EVAL      WWCDPCT = PDPERC
     C                   ENDIF

     C                   ENDIF

     C                   IF        WACTBAL >= 0
     C                   EVAL      WEXPOFF = WACTBAL
     C                   ELSE

     C                   IF        WINCOFF = 'Y'
     C                   EVAL      WEXPOFF = WACTBAL * (WWCDPCT / 100)
     C                   ELSE
     C                   EVAL      WEXPOFF = 0
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPROCACT - Process Action Subroutine                         *
      *                                                               *
      *****************************************************************
     C     SrPROCACT     BEGSR

     C     KFCLTY        CHAIN     FCLTYL3                            25
     C                   IF        *IN25 = *ON
     C     KFCLTY        CHAIN     PEFCLFL3                           26
     C                   ENDIF

      ** If record not found in Facility Files, do not execute further

     C                   IF        *IN25 = *OFF or *IN26 = *OFF

     C                   EVAL      ORFCCY = FCCY

     C                   IF        RECI <> 'R'

      ** Determine Action Amount

     C                   IF        FCCY = WACTCCY
     C                   EVAL      WACTAMT = WREVAMT
     C                   ELSE
     C                   EVAL      WCCY1 = WACTCCY
     C                   EVAL      WCCY2 = FCCY
     C                   EVAL      WINAMT = WREVAMT
     C                   EXSR      SrCONVERT
     C                   EVAL      WACTAMT = WOUTAMT
     C                   ENDIF

     C                   EVAL      WACTAMT = WACTAMT - A2F1TEOF

      ** Update History Actions Table

     C                   IF        WACTAMT <> 0

      ** Update HISACT

     C                   EVAL      WUPDAT = '1'
     C                   EXSR      SrHISACT

      ** Update FACACT

     C                   EVAL      KBRCA = BRCA
     C                   EVAL      KCNUM = KFCNUM
     C                   MOVEL     KFFACT        KFCTY
     C                   MOVE      KFFCNO        KFCTY
     C                   EXSR      SrFACACT

      ** Update FACHISH

     C                   EVAL      KHBRCA = BRCA
     C                   EVAL      KHCNUM = KFCNUM
     C                   EVAL      KHFACT = KFFACT
     C                   EVAL      KHFCNO = KFFCNO
     C                   EXSR      SrFACHISH

     C                   ENDIF

      ** If facility is tranche

     C                   IF        TRCA = 'TR'

     C                   EVAL      WTRXRAT = CAXR
     C                   EVAL      WTRMDIN = CMDI

     C                   EVAL      KFCNUM = CANM
     C                   EVAL      KFFACT = CAFT
     C                   EVAL      KFFCNO = CAFN
     C                   EVAL      PFCCY = FCCY
     C                   EVAL      PCACY = CACY

     C     KFCLTY        CHAIN     FCLTYL3                            25

     C                   IF        *IN25 = *ON
     C     KFCLTY        CHAIN     PEFCLFL3                           26
     C                   ENDIF

      ** If record not found in PEFCLFM do not execute further

     C                   IF        *IN25 = *OFF OR *IN26 =*OFF

     C                   IF        RECI <> 'R'

      ** Determine Action Amount

     C                   IF        PCACY = PFCCY
     C                   EVAL      WACTAMT = WACTAMT
     C                   ELSE
     C                   EVAL      WCCY1 = PFCCY
     C                   EVAL      WCCY2 = PCACY
     C                   EVAL      WINAMT = WACTAMT
     C                   EVAL      WRATE = WTRXRAT
     C                   EVAL      WMDIN = WTRMDIN
     C                   EVAL      GIVEN = 'Y'
     C                   EXSR      SrCONVERT
     C                   EVAL      WACTAMT = WOUTAMT
     C                   ENDIF

     C                   IF        WACTAMT <> 0

      ** Update HISACT

     C                   EVAL      WUPDAT = '2'
     C                   EXSR      SrHISACT

      ** Update FACACT

     C                   EVAL      KBRCA = BRCA
     C                   EVAL      KCNUM = KFCNUM
     C                   MOVE      KFFCNO        KFCTY
     C                   MOVEL     KFFACT        KFCTY
     C                   EXSR      SrFACACT

      ** Update FACHISH

     C                   EVAL      KHBRCA = BRCA
     C                   EVAL      KHCNUM = KFCNUM
     C                   EVAL      KHFACT = KFFACT
     C                   EVAL      KHFCNO = KFFCNO
     C                   EXSR      SrFACHISH

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrHISACT - Update HISACT File                                 *
      *                                                               *
      *****************************************************************
     C     SrHISACT      BEGSR

     C                   EVAL      BRCA = FMBRCA
     C                   EVAL      HACNUM = KFCNUM
     C                   MOVEL     KFFACT        HAFCTY
     C                   MOVE      KFFCNO        HAFCTY
     C                   EVAL      HADATE = WACTDAT

     C                   IF        HADATE < FACHISD
     C                             AND FMORED < FACHISD
     C                   EVAL      HADATE = FACHISD
     C                   ENDIF

     C                   EVAL      HALOAN = *BLANKS
     C                   EVAL      HAACTN = WACTION
     C                   EVAL      HAAAMT = WACTAMT
     C                   EVAL      HAPART = *BLANKS
     C                   EVAL      HALCRF = *BLANKS
     C                   EVAL      GEDT = 0
     C                   EVAL      HASQNO = 0
     C                   EVAL      HAECIN = *BLANKS
     C                   EVAL      HAGASS = *BLANKS
     C                   EVAL      HATRRC = *BLANKS
     C                   EVAL      HAOLRC = *BLANKS
     C                   EVAL      HAPTYP = 0
     C                   EVAL      HARCSI = *BLANKS
     C                   EVAL      HALPFI = *BLANKS
     C                   EVAL      HADEAL = *ZEROS
     C                   EVAL      HAMCY = *BLANKS
     C                   EVAL      HAFXMT = *BLANKS
     C                   EVAL      HAFXPC = 0
     C                   EVAL      HARIND = *BLANKS

     C                   EVAL      HASEQ = 98
     C                   EVAL      HATSEQ = 98
     C                   EVAL      HARCIN = RVCR
     C                   EVAL      HAEXCY = WACTCCY

     C                   EVAL      HAACBR = A2BRCA
     C                   EVAL      HAACCU = A2CNUM
     C                   EVAL      HAACCY = A2CCY
     C                   EVAL      HAACCD = A2ACOD
     C                   EVAL      HAACSQ = A2ACSQ
     C                   EVAL      HAACNO = A2ACNO

     C                   EVAL      HAWEIG = WWEICDE
     C                   EVAL      HAWCPC = WWCDPCT
     C                   EVAL      HAINOF = WINCOFF
     C                   EVAL      HATVAL = WACTBAL

     C                   IF        WUPDAT = '1'

     C                   IF        FCCY <> WACTCCY
     C                   EVAL      HALUCY = WACTCCY
     C                   EVAL      HAEXRT = WRATE
     C                   EVAL      HARTMD = WMDIN
     C                   EVAL      HALUAM = WREVAMT - WTEOP
     C                   ELSE
     C                   EVAL      HALUCY = *BLANKS
     C                   EVAL      HAEXRT = 0
     C                   EVAL      HARTMD = *BLANKS
     C                   EVAL      HALUAM = 0
     C                   ENDIF

     C                   EVAL      HAPTEO = WTEOF
     C                   EVAL      WCCY1 = WACTCCY
     C                   EVAL      WCCY2 = FCCY
     C                   EVAL      WINAMT = WREVAMT
     C                   EXSR      SrCONVERT
     C                   EVAL      HATTEO = WOUTAMT

     C                   ELSE

     C                   IF        PCACY <> PFCCY
     C                   EVAL      HALUCY = PFCCY
     C                   EVAL      HAEXRT = WTRXRAT
     C                   EVAL      HARTMD = WTRMDIN
     C                   EVAL      HALUAM = WACTAMT
     C                   ELSE
     C                   EVAL      HALUCY = *BLANKS
     C                   EVAL      HAEXRT = 0
     C                   EVAL      HARTMD = *BLANKS
     C                   EVAL      HALUAM = 0
     C                   ENDIF

     C                   EVAL      HAPTEO = WTEOC
     C                   EVAL      HATTEO = HAPTEO + WACTAMT

     C                   ENDIF

     C                   WRITE     HISACTF

     C                   EXSR      SrREPORT

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFACACT - Update FACACT File                                 *
      *                                                               *
      *****************************************************************
     C     SrFACACT      BEGSR

      ** Check if facility exists in file

     C     KFACACT       CHAIN     FACACTL1

     C                   IF        %FOUND(FACACTL1)

     C                   IF        HADATE < FCDATE
     C                   EVAL      FCDATE = HADATE
     C                   UPDATE    FACACTF
     C                   ENDIF

     C                   ELSE

     C                   EVAL      RSBRCA = BRCA
     C                   EVAL      FCCNUM = KFCNUM
     C                   MOVEL     KFFACT        FCFCTY
     C                   MOVE      KFFCNO        FCFCTY
     C                   EVAL      FCDATE = HADATE

     C                   WRITE     FACACTF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFACHISH - Update FACHISH File                               *
      *                                                               *
      *****************************************************************
     C     SrFACHISH     BEGSR

     C                   IF        CLE023 = 'Y' and HADATE < BJRDNB

      ** Check if facility exists in file

     C     KFACHISH      CHAIN     FACHISHL

     C                   IF        %FOUND(FACHISHL)

     C                   EVAL      FHRWKR = 'Y'
     C                   EVAL      FHRWTP = 'B'

     C                   IF        FHRWDT = 0 or FHRWDT > HADATE
     C                   EVAL      FHRWDT = HADATE
     C                   ENDIF

     C                   UPDATE    FACHISHF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrREPORT - Write Details on Report                           *
      *                                                               *
      *****************************************************************
     C     SrREPORT      BEGSR

      ** Move details to report fields

     C                   EVAL      RDEAL = *BLANKS
     C                   EVAL      RACTION = HAACTN
     C                   EVAL      RDESC = 'ACCOUNT MOVEMENT'

      ** Format account

     C                   MOVE      HAACCU        RCUST
     C                   MOVE      '-'           RDASH1
     C                   MOVE      HAACCY        RCCY
     C                   MOVE      '-'           RDASH2
     C                   MOVE      HAACCD        RACOD
     C                   MOVE      '-'           RDASH3
     C                   MOVE      HAACSQ        RACSQ
     C                   MOVE      '-'           RDASH4
     C                   MOVE      HAACBR        RBRCA
     C                   EVAL      RACCOUNT = WACCOUNT

      ** Format facility

     C                   MOVE      KFCNUM        RFCCU
     C                   MOVE      '-'           RDASH5
     C                   MOVE      KFFACT        RFACT
     C                   MOVE      '-'           RDASH6
     C                   MOVE      KFFCNO        RFCNO
     C                   EVAL      RFACILTY = WFCLTY

      ** Format currency

     C                   IF        WUPDAT = '1'
     C                   EVAL      RVFCCY = FCCY
     C                   ELSE
     C                   EVAL      RVFCCY = PCACY
     C                   ENDIF

      ** Format date

     C                   EVAL      ZDAYNO = HADATE

     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE

     C                   EVAL      RVDATE = ZADATE

      ** Format amount

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    RVFCCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   EVAL      ZFLD15 = HAAAMT
     C                   EVAL      ZDECS = A6NBDP

     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      'J'           ZECODE
     C                   PARM                    ZOUT21

     C                   EVAL      RAMOUNT = ZOUT21

      ** Check that sufficient lines remain for the format

     C                   EVAL      RQDLN1 = 6
      *
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF

     C                   WRITE     DETAIL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrENDRPT - Close Report File                                 *
      *                                                               *
      *****************************************************************
     C     SrENDRPT      BEGSR

      ** Check that sufficient lines remain for the format

     C                   EVAL      RQDLN1 = 1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADP1
     C                   ENDIF

      ** Write out trailer format

     C                   WRITE     TRAILP1

     C                   CLOSE     LE000030P1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCONVERT - Convert Currency                                  *
      *                                                               *
      *****************************************************************
     C     SrCONVERT     BEGSR

      ** If one of currencies is blank, skip conversion

     C                   IF        WCCY1 = *BLANKS or WCCY2 = *BLANKS
     C                   EVAL      WOUTAMT = 0
     C                   EVAL      WRATE = 0
     C                   EVAL      WMDIN = *BLANKS
     C                   ELSE

      ** From currency

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    WCCY1
     C     SDCURR        PARM      SDCURR        DSSDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 005
     C                   EVAL      DBKEY = WCCY1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Save necessary details

     C                   EVAL      WSPRT1 = A6SPRT
     C                   EVAL      WMDIN1 = A6MDIN
     C                   EVAL      WNBDP1 = A6NBDP

      ** To currency

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    WCCY2
     C     SDCURR        PARM      SDCURR        DSSDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 006
     C                   EVAL      DBKEY = WCCY2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Save necessary details

     C                   EVAL      WSPRT2 = A6SPRT
     C                   EVAL      WMDIN2 = A6MDIN
     C                   EVAL      WNBDP2 = A6NBDP

     C                   IF        GIVEN = 'N'

      ** Get exchange rate

     C                   EVAL      XMDIN1 = WMDIN1
     C                   EVAL      XMDIN2 = WMDIN2
     C                   EVAL      XSPRT1 = WSPRT1
     C                   EVAL      XSPRT2 = WSPRT2

     C                   CALLB     'ZXRATE'
     C                   PARM                    XSPRT1
     C                   PARM                    XMDIN1
     C                   PARM                    XSPRT2
     C                   PARM                    XMDIN2
     C                   PARM                    WRATE
     C                   PARM                    WMDIN

     C                   ENDIF

      ** Convert amount

     C                   CALLB     'ZCONVZ1'
     C                   PARM                    WINAMT
     C                   PARM                    WRATE
     C                   PARM                    WMDIN
     C                   PARM                    WCCY1
     C                   PARM                    WCCY2
     C                   PARM                    WNBDP1
     C                   PARM                    WNBDP2
     C                   PARM                    WOUTAMT

     C                   ENDIF

     C                   EVAL      GIVEN = 'N'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Define DTAARA/LDA and Retrieve DTAARA/LERSTS

     C     *DTAARA       DEFINE                  LDA
     C                   IN        LERSTS

      ** Initialise work variables

     C                   EVAL      DBPGM = 'LE000030A'
     C                   EVAL      GIVEN = 'N'
     C                   EVAL      WERROR = 'N'

      ** Key Fields

     C     KACCNT        KLIST
     C                   KFLD                    KACCNUM
     C                   KFLD                    KACCCY
     C                   KFLD                    KACACOD
     C                   KFLD                    KACACSQ
     C                   KFLD                    KACBRCA

     C     KFCLTY        KLIST
     C                   KFLD                    KFCNUM
     C                   KFLD                    KFFACT
     C                   KFLD                    KFFCNO

     C     KFACACT       KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KFCTY

     C     KFACHISH      KLIST
     C                   KFLD                    KHBRCA
     C                   KFLD                    KHCNUM
     C                   KFLD                    KHFACT
     C                   KFLD                    KHFCNO

      ** Access Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = POPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check if CLE023 is switched on

     C                   EVAL      CLE023 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CLE023'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CLE023 = 'Y'
     C                   ENDIF

      ** Open report file

     C                   EVAL      RQDLN1 = 0
     C                   EVAL      DIFLN1 = 0

     C                   OPEN      LE000030P1
     C                   WRITE     HEADP1

     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program Exception Error Routine                          *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      ********************************************************************
