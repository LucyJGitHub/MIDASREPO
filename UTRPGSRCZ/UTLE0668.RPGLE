     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
     H FIXNBR (*NOZONED:*NOINPUTPACKED)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('RPG pgm for correcting FACHISA')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  UTLE0668 - LE utility to correct Facility History File.      *
      *                                                               *
      *  Function:  This program will add the missing PDCL            *
      *             repayments in FACHISA.                            *
      *                                                               *
      *  Called By: UTCLE0668 - CL program                            *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1036834 *CREATE  Date 03Oct16               *
      *                 XXXXXXXXX          Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1036834 - Missing PDCL repayments in facility history.     *
      *              Search and add all missing PDCL repayments.      *
      *              (Child: AR1036835)                               *
      *            - rerun for MD-22057                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FUTLE0668F1IF   E           K DISK    INFSR(*PSSR)
     FUTLE0668F2IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(HISTSHPF:MHISTSPF)
     FUTLE0668F3IF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FACHISAF:FACHIUPF)
     FLEHISFL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FACHISAF:FACHIS1F)
     F                                     IGNORE(HISACTF)
     FHISUPD    IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(HISACTF)
     FFCLTYL1   IF   E           K DISK    INFSR(*PSSR)
     FFACHISHL  UF   E           K DISK    INFSR(*PSSR)
     FFACACT    UF A E           K DISK    INFSR(*PSSR)
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
     F                                     PREFIX(C_)
     FMLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:MCLONCLF)
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
     F                                     PREFIX(C_)
     FUTLE0668P2O    E             PRINTER OFLIND(*IN80)
     FUTLE0668P1O    E             PRINTER OFLIND(*IN70)
      /EJECT
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  20  - Read UTLE0668F1, Live Loan History                     *
      *  21  - Read UTLE0668F2, Matured Loan History                  *
      *  23  - Chain to CLOAN                                         *
      *  24  - Chain to MLOAN                                         *
      *  30  - Update mode                                            *
      *  31  - LEHISFL0, FACHISA record format                        *
      *  40  - Array lookup                                           *
      *  41  - Chain to HISUPD, FACHISA update (add record)           *
      *  55  - Chain to FCLTYL1, Live facility                        *
      *  70 -  Overflow UTLE0668P1                                    *
      *  80 -  Overflow UTLE0668P2                                    *
      *  98  - Indicator used in standard subroutine                  *
      *  U7+U8  - Database Error                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the LE standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** Rundate data structure
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Bank Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Currency details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Branch Details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Data structure for Access Program
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** ZDate2 parameters
 
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A
 
     D WFSEQ           S              5P 0
     D LHCTR           S              2  0 INZ(*ZERO)
     D FHCTR           S              2  0 INZ(*ZERO)
     D WFCLTY          S             11A   INZ(*BLANK)
     D X               S              7  0 INZ(*ZERO)
 
      ** Variables for currency conversion
 
     D WFCXR           S             13  8
     D WFMDI           S              1A
     D WCCY1           S              3A
     D WCCY2           S              3A
     D WNBDP1          S              1  0
     D WNBDP2          S              1  0
     D WOUTAMT         S             15  0
     D WINAMT          S             15  0
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D FCLTYU          S             11A   DIM(9999)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
     IFACHISAF
     I              BRCA                        BRCAFA
     IHISTSHPF      10
     I              LCD                         HLCD
     IMHISTSPF      11
     I              LCD                         MLCD
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      ** Write header records.
      *
     C                   WRITE     HEADER1
     C                   WRITE     HEADER2
      *
      ** Process Live Loan history records.
      *
     C                   READ      HISTSHPF                               20
     C                   DOW       *IN20 = '0'
     C                   EVAL      VADATE = VDAT
      *
      ** If interest or fee PDCL, only process if FAMU = 'Y'.
      *
     C     LNRF          CHAIN     CLOANCLF                           23
     C                   IF        *IN23 = '0' and
     C                             (%SUBST(C_LTYP:1:1) = 'Y' or
     C                             %SUBST(C_LTYP:1:1) = 'Z') and
     C                             (C_FAMU = 'N' or C_FAMU = ' ')
     C                   READ      HISTSHPF                               20
     C                   ITER
     C                   ENDIF
      *
      ** Check if facility is a live facility.
      *
     C     *LOVAL        SETLL     FCLTYL1
     C     KEY001        CHAIN     FCLTYL1                            55
     C                   IF        *IN55 = '0'
     C                             and RECI = 'D'
     C                             and *IN23 = '0'
      *
     C                   IF        KACNUM <> FCUS
     C                             or KFACT <> FTYP
     C                             or KFCNO <> FSEQ
     C                             or KALOAN <> LNRF
     C                             or KADATE <> VDAT
     C                             or KAPRAM <> PRAM
      *
     C                   EVAL      KACNUM = FCUS
     C                   EVAL      KALOAN = LNRF
     C                   EVAL      KADATE = VDAT
     C                   EVAL      KFACT = FACT
     C                   EVAL      KFCNO = FCNO
     C                   Z-ADD     PRAM          KAPRAM           13 0
     C                   Z-ADD     1             LHCTR
     C                   MOVE      '0'           *IN31
     C                   ELSE
      *
      ** Count number of PDCL repayment w/ same vdat and amount.
      *
     C                   IF        PRAM = KAPRAM
     C                   EVAL      LHCTR += 1
     C                   ENDIF
     C                   Z-ADD     PRAM          KAPRAM
     C                   ENDIF
      *
      ** Check if repayment is missing in FACHISA.
      *
     C                   Z-ADD     0             FHCTR
     C                   MOVE      KACNUM        VACNUM
     C                   MOVEL     KFACT         VAFCTY
     C                   MOVE      KFCNO         VAFCTY
     C                   MOVEL     KALOAN        VALOAN
     C                   MOVE      KADATE        VADATE
      *
     C     *LOVAL        SETLL     FACHIS1F
     C     KEY003        CHAIN     FACHIS1F                           31
     C                   IF        *IN31 = '0'
      *
     C                   DOW       *IN31 = '0'
      *
      ** Should only of type 'RE' or 'MT'.
      *
     C                   IF        (FAACTN = 'RE' or FAACTN = 'MT')
     C                             and FAREVI = ' '
      *
      ** Count number of record with same vdat & amount in FACHISA.
      *
     C                   IF        C_FCCY <> C_CCY
      *
      ** Convert amount to Facility amount.
     C                   EXSR      srConvAmt
     C                   IF        FAAAMT = WOUTAMT
     C                   EVAL      FHCTR += 1
     C                   ENDIF
     C                   ELSE
     C                   IF        FAAAMT = PRAM
     C                   EVAL      FHCTR += 1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     KEY003        READE     FACHIS1F                               31
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** If repayments on HISTSHP is greater than repayments in FACHISA
      ** report as error.
      *
     C                   IF        LHCTR > FHCTR
     C                   MOVE      '1'           *IN31
     C                   ELSE
     C                   MOVE      '0'           *IN31
     C                   ENDIF
      *
     C                   IF        *IN31 = '1'
     C                   EXSR      srUpdateF
     C                   ENDIF
      *
     C                   ENDIF
     C                   READ      HISTSHPF                               20
     C                   ENDDO
      *
      ** Process Matured Loan history records.
      *
     C                   MOVE      '0'           *IN10
     C                   READ      MHISTSPF                               21
     C                   DOW       *IN21 = '0'
     C                   EVAL      VADATE = VDAT
      *
      ** If interest or fee PDCL, only process if FAMU = 'Y'.
      *
     C     LNRF          CHAIN     MCLONCLF                           24
     C                   IF        *IN24 = '0' and
     C                             (%SUBST(C_LTYP:1:1) = 'Y' or
     C                             %SUBST(C_LTYP:1:1) = 'Z') and
     C                             (C_FAMU = 'N' or C_FAMU = ' ')
     C                   READ      MHISTSPF                               21
     C                   ITER
     C                   ENDIF
      *
      ** Check if facility is a live facility.
      *
     C     *LOVAL        SETLL     FCLTYL1
     C     KEY001        CHAIN     FCLTYL1                            55
     C                   IF        *IN55 = '0'
     C                             and RECI = 'D'
     C                             and *IN24 = '0'
      *
     C                   IF        KACNUM <> FCUS
     C                             or KFACT <> FTYP
     C                             or KFCNO <> FSEQ
     C                             or KALOAN <> LNRF
     C                             or KADATE <> VDAT
     C                             or KAPRAM <> PRAM
      *
     C                   EVAL      KACNUM = FCUS
     C                   EVAL      KALOAN = LNRF
     C                   EVAL      KADATE = VDAT
     C                   EVAL      KFACT = FACT
     C                   EVAL      KFCNO = FCNO
     C                   Z-ADD     PRAM          KAPRAM
     C                   Z-ADD     1             LHCTR
     C                   MOVE      '0'           *IN31
     C                   ELSE
      *
      ** Count number of PDCL repayment w/ same vdat and amount.
      *
     C                   IF        PRAM = KAPRAM
     C                   EVAL      LHCTR += 1
     C                   ENDIF
     C                   Z-ADD     PRAM          KAPRAM
     C                   ENDIF
      *
      ** Check if repayment is missing in FACHISA.
      *
     C                   Z-ADD     0             FHCTR
     C                   MOVE      KACNUM        VACNUM
     C                   MOVEL     KFACT         VAFCTY
     C                   MOVE      KFCNO         VAFCTY
     C                   MOVEL     KALOAN        VALOAN
     C                   MOVE      KADATE        VADATE
      *
     C     *LOVAL        SETLL     FACHIS1F
     C     KEY003        CHAIN     FACHIS1F                           31
     C                   IF        *IN31 = '0'
      *
     C                   DOW       *IN31 = '0'
      *
      ** Should only of type 'RE' or 'MT'.
      *
     C                   IF        (FAACTN = 'RE' or FAACTN = 'MT')
     C                             and FAREVI = ' '
      *
      ** Count number of record with same vdat & amount in FACHISA
      *
     C                   IF        C_FCCY <> C_CCY
      *
      ** Convert amount to Facility amount.
      *
     C                   EXSR      srConvAmt
     C                   IF        FAAAMT = WOUTAMT
     C                   EVAL      FHCTR += 1
     C                   ENDIF
     C                   ELSE
     C                   IF        FAAAMT = PRAM
     C                   EVAL      FHCTR += 1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     KEY003        READE     FACHIS1F                               31
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** If repayments on MHISTHP is greater than repayments in FACHISA
      ** report as error.
      *
     C                   IF        LHCTR > FHCTR
     C                   MOVE      '1'           *IN31
     C                   ELSE
     C                   MOVE      '0'           *IN31
     C                   ENDIF
      *
     C                   IF        *IN31 = '1'
     C                   EXSR      srUpdateF
     C                   ENDIF
      *
     C                   ENDIF
     C                   READ      MHISTSPF                               21
     C                   ENDDO
      *
      ** Print Trailer.
      *
     C                   EXSR      srTRAIL
      *
      ** End of program.
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
      /SPACE 5
      *****************************************************************
      *  srUpdateF - Add record to FACHISA and update FACHISH/FACACT  *
      *                                                               *
      *  Called From:  Main program                                   *
      *                                                               *
      *  Calls: srDetail                                              *
      *                                                               *
      *****************************************************************
     C     srUpdateF     BEGSR
      *
     C                   EXSR      srConvAmt
      *
     C                   IF        *IN30 = '1'
      *
      ** Search for point of RE insertion in FACHISA.
      *
     C                   Z-ADD     0             WFSEQ
     C     *LOVAL        SETLL     FACHISAF
     C     KEY004        CHAIN     FACHISAF                           41
     C                   IF        *IN41 = '1'
     C     *LOVAL        SETLL     FACHISAF
     C     KEY005        CHAIN     FACHISAF                           41
     C                   ENDIF
      *
     C                   DOW       *IN41 = '0'
     C                             and FADATE <= VADATE
     C                             and FACNUM = VACNUM
     C                             and FAFCTY =  VAFCTY
      *
     C                   IF        FADATE = VADATE
     C                   EVAL      WFSEQ += 1
     C                   ENDIF
      *
     C                   MOVE      FARECI        YARECI            1
     C                   MOVE      FACNUM        YACNUM            6
     C                   MOVE      FAFCTY        YAFCTY            5 0
     C                   MOVE      FARCIN        YARCIN            1
     C                   READ      FACHISAF                               41
     C                   ENDDO
      *
      ** Also check the temporary file for transaction seq.
      *
     C     KEY004        SETLL(E)  FACHIUPF
     C                   IF        %EQUAL(UTLE0668F3)
     C     KEY004        READE     FACHIUPF                               41
      *
     C                   DOW       *IN41 = '0'
      *
     C                   EVAL      WFSEQ += 1
      *
     C                   MOVE      FARECI        YARECI            1
     C                   MOVE      FACNUM        YACNUM            6
     C                   MOVE      FAFCTY        YAFCTY            5 0
     C                   MOVE      FARCIN        YARCIN            1
     C     KEY004        READE     FACHIUPF                               41
     C                   ENDDO
     C                   ENDIF
      *
     C                   ADD       1             WFSEQ
     C                   MOVE      YARECI        FARECI
     C                   EVAL      BRCAFA = C_FCLB
     C                   EVAL      FACNUM = YACNUM
     C                   Z-ADD     YAFCTY        FAFCTY
     C                   Z-ADD     VADATE        FADATE
     C                   Z-ADD     WFSEQ         FAFSEQ
     C                   MOVE      LNRF          FALOAN
     C                   Z-ADD     WOUTAMT       FAAAMT
     C                   IF        AMTP = 'MA'
     C                   MOVE      'MT'          FAACTN
     C                   ELSE
     C                   MOVE      'RE'          FAACTN
     C                   ENDIF
     C                   MOVE      *BLANK        FAPART
     C                   MOVE      YARCIN        FARCIN
     C                   MOVE      *BLANK        FAREVI
     C                   MOVE      *BLANKS       FALCRF
     C*
     C                   IF        *IN10 = '1'
     C                   Z-ADD     HLCD          FAGNDT
     C                   ENDIF
     C                   IF        *IN11 = '1'
     C                   Z-ADD     MLCD          FAGNDT
     C                   ENDIF
      *
     C                   Z-ADD     0             FASQNO
     C                   MOVE      'Y'           FACFGI
     C                   MOVE      *BLANK        FAGASS
     C                   Z-ADD     FAFSEQ        FATSEQ
     C                   MOVE      CCY           FALUCY
     C                   Z-ADD     PRAM          FALUAM
     C                   Z-ADD     C_FCXR        FAEXRT
     C                   MOVE      C_FMDI        FARTMD
     C                   Z-ADD     C_PTYP        FAPTYP
     C                   MOVE      *BLANKS       FARCSI
     C                   Z-ADD     FAGNDT        FAORED
     C                   Z-ADD     *ZEROS        FAAFAM
     C                   Z-ADD     *ZEROS        FAPAMT
     C                   MOVE      *BLANKS       FALPFI
     C                   Z-ADD     *ZEROS        FAOFFS
     C                   Z-ADD     *ZEROS        FADEAL
     C                   MOVE      *BLANKS       FAMCY
     C                   MOVE      *BLANKS       FAACBR
     C                   MOVE      *BLANKS       FAACCU
     C                   MOVE      *BLANKS       FAACCY
     C                   Z-ADD     *ZEROS        FAACCD
     C                   Z-ADD     *ZEROS        FAACSQ
     C                   Z-ADD     *ZEROS        FAACNO
     C                   Z-ADD     *ZEROS        FATTEO
     C                   Z-ADD     *ZEROS        FAPTEO
     C                   MOVE      *BLANKS       FAEXCY
     C                   Z-ADD     *ZEROS        FATVAL
     C                   Z-ADD     *ZEROS        FAWEIG
     C                   Z-ADD     *ZEROS        FAWCPC
     C                   MOVE      *BLANKS       FAINOF
     C                   MOVE      *BLANKS       FAFXMT
     C                   Z-ADD     *ZEROS        FAFXPC
     C                   MOVE      *BLANKS       FARIND
      *
     C                   WRITE     FACHIUPF
     C                   ADD       1             NOADD
      *
      ** Update FACHISH/FACACT to recalculate facility on COB.
      *
     C     KEY001        CHAIN     FACHISHF                           86
      *
     C                   IF        *IN86 = '0'
     C                   EVAL      FHRWKR = 'Y'
     C     KEY005        SETLL     FACHISAF
     C                   READ      FACHISAF                               88
     C                   EVAL      FHRWDT = FADATE
     C                   EVAL      FHRWTP = 'M'
     C                   UPDATE    FACHISHF
      *
     C     KEY005        CHAIN     FACACTF                            86
      *
     C                   IF        *IN86 = '1'
     C                   EVAL      BRCA = BRCAFA
     C                   EVAL      FCCNUM = FACNUM
     C                   EVAL      FCFCTY = FAFCTY
     C                   EVAL      FCDATE = FADATE
     C                   WRITE     FACACTF
     C                   ELSE
     C                   EVAL      FCDATE = FADATE
     C                   UPDATE    FACACTF
     C                   ENDIF
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = *BLANKS
     C                   MOVE      VAFCTY        WWFACT            5
     C                   EVAL      DBFILE = 'FACHISH'
     C                   EVAL      DBKEY = BRCAFA + VACNUM + WWFACT
     C                   EVAL      DBPGM = 'UTLE0668'
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   IF        *IN70 = '1'
     C                   EVAL      PAGE += 1
     C                   WRITE     HEADER1
     C                   EVAL      *IN70 = '0'
     C                   ENDIF
     C                   WRITE     DBERROR1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EXSR      srDetail
      *
     C                   ENDSR
      /SPACE 5
      *****************************************************************
      *                                                               *
      *  srDetail - Process the details to be printed                 *
      *                                                               *
      *  Called From: srUpdateF                                       *
      *                                                               *
      *  Calls: FmtDate, DetDec and FmtAmnt                           *
      *                                                               *
      *****************************************************************
     C     srDetail      BEGSR
      *
     C                   MOVE      *BLANKS       WFCLTY
     C                   MOVE      *BLANKS       VFAMT0
     C                   MOVE      *BLANKS       VFAMT1
     C                   MOVE      *BLANKS       VFAMT2
     C                   MOVE      *BLANKS       VFAMT3
     C                   EVAL      VBRCA = BRCA
     C                   MOVE      FCUS          VCNUM
     C                   MOVE      KFACT         VFACT
     C                   MOVE      KFCNO         VFCNO
     C                   MOVE      LNRF          VLNRF
     C                   EVAL      VFCCY = C_FCCY
     C                   EVAL      VACTN = AMTP
      *
     C                   EVAL      ZDAYNO = KADATE
     C                   EXSR      FmtDate
     C                   EVAL      VDATE = ZADATE
      *
     C                   EXSR      DetDec
     C                   EXSR      FmtAmnt
      *
     C                   IF        *IN70 = '1'
     C                   EVAL      PAGE += 1
     C                   WRITE     HEADER1
     C                   EVAL      *IN70 = '0'
     C                   ENDIF
      *
     C                   WRITE     DETAIL1
     C                   EVAL      NOREAD += 1
      *
     C                   EVAL      WFCLTY = VCNUM + VFACT + VFCNO
     C     WFCLTY        LOOKUP    FCLTYU                                 40
      *
     C                   IF        *IN40 = '0'
     C                   EVAL      x += 1
     C                   EVAL      FCLTYU(x) = WFCLTY
     C                   EVAL      FACERR += 1
      *
     C                   IF        *IN80 = '1'
     C                   EVAL      PAGENO += 1
     C                   WRITE     HEADER2
     C                   EVAL      *IN80 = '0'
     C                   ENDIF
      *
     C                   WRITE     DETAIL2
     C                   ENDIF
      *
     C                   ENDSR
      /SPACE 5
      *****************************************************************
      *                                                               *
      *  srConvAmt - Convert and compute facility history amount.     *
      *                                                               *
      *  Called From:  srUpdateF                                      *
      *                                                               *
      *  Calls: ZCONV1                                                *
      *                                                               *
      *****************************************************************
     C     srConvAmt     BEGSR
      *
     C                   Z-ADD     PRAM          WINAMT
     C                   Z-ADD     PRAM          WRKFLD           15 0
      *
      ** Chain to loan file to get loan details (e.g FCXR, FCCY, etc).
      *
     C     *LOVAL        SETLL     CLOANCLF
     C     LNRF          CHAIN     CLOANCLF                           23
     C                   IF        *IN23 = '1'
     C     *LOVAL        SETLL     MCLONCLF
     C     LNRF          CHAIN     MCLONCLF                           24
     C                   ENDIF
      *
     C                   EVAL      WFCXR = C_FCXR
     C                   EVAL      WFMDI = C_FMDI
     C                   EVAL      WCCY1 = C_FCCY
     C                   EVAL      WCCY2 = C_CCY
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM                    WCCY2
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = WCCY2
     C                   EVAL      DBASE = 4
     C                   EVAL      DBPGM = 'UTLE0668'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      WNBDP2 = A6NBDP
      *
      ** If currencies are not equal, process conversion.
      *
     C                   IF        C_FCCY <> C_CCY
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    WCCY1
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = WCCY1
     C                   EVAL      DBASE = 5
     C                   EVAL      DBPGM = 'UTLE0668'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      WNBDP1 = A6NBDP
      *
      ** Process amount conversion.
      *
     C                   CALL      'ZCONVZ1'
     C                   PARM                    WINAMT
     C                   PARM                    WFCXR
     C                   PARM                    WFMDI
     C                   PARM                    WCCY2
     C                   PARM                    WCCY1
     C                   PARM                    WNBDP2
     C                   PARM                    WNBDP1
     C                   PARM                    WOUTAMT
      *
     C                   ELSE
      *
      ** If same currency, no need to convert.
      *
     C                   Z-ADD     WRKFLD        WOUTAMT
     C                   ENDIF
     C                   ENDSR
      /SPACE 5
      *****************************************************************
      *                                                               *
      *  srTRAIL - Print Trailer                                      *
      *                                                               *
      *  Called From:  Main program                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     srTRAIL       BEGSR
      *
      ** Print Next Page.
      *
     C                   IF        *IN70 = '1'
     C                   EVAL      PAGE += 1
     C                   WRITE     HEADER1
     C                   EVAL      *IN70 = '0'
     C                   ENDIF
      *
     C                   IF        *IN80 = '1'
     C                   EVAL      PAGENO += 1
     C                   WRITE     HEADER2
     C                   EVAL      *IN80 = '0'
     C                   ENDIF
      *
      ** Print 'No Details' if no error found.
      *
     C                   IF        NOREAD = 0
     C                             AND FACERR = 0
     C                   WRITE     NODTLS
     C                   EVAL      *IN12 = '1'
     C                   ELSE
     C                   WRITE     PRECS
     C                   ENDIF
      *
      ** Print 'End of Report'.
      *
     C                   WRITE     ENDOF
     C                   WRITE     TRAILER2
      *
     C                   ENDSR
      /SPACE 5
      *****************************************************************
      *                                                               *
      *  FmtDate - Call to 'ZDate2'                                   *
      *                                                               *
      *****************************************************************
     C     FmtDate       BEGSR
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANKS       ZADATE
      *
     C                   ENDSR
      /SPACE 5
      *****************************************************************
      *                                                               *
      *  DetDec - Determine number of decimal places                  *
      *                                                               *
      *****************************************************************
     C     DetDec        BEGSR
      *
     C                   MOVEA     '0000'        *IN(60)
      *
     C                   IF        WNBDP2 = 0
     C                   MOVE      '1'           *IN60
     C                   ENDIF
     C                   IF        WNBDP2 = 1
     C                   MOVE      '1'           *IN61
     C                   ENDIF
     C                   IF        WNBDP2 = 2
     C                   MOVE      '1'           *IN62
     C                   ENDIF
     C                   IF        WNBDP2 = 3
     C                   MOVE      '1'           *IN63
     C                   ENDIF
      *
     C                   ENDSR
      /SPACE 5
      *****************************************************************
      *                                                               *
      *  FmtAmnt - Move amount values into corresponding display      *
      *                                                               *
      *****************************************************************
     C     FmtAmnt       BEGSR
      *
     C                   IF        *IN60 = '1'
     C                   MOVE      WOUTAMT       VFAMT0
     C                   ENDIF
     C                   IF        *IN61 = '1'
     C                   MOVE      WOUTAMT       VFAMT1
     C                   ENDIF
     C                   IF        *IN62 = '1'
     C                   MOVE      WOUTAMT       VFAMT2
     C                   ENDIF
     C                   IF        *IN63 = '1'
     C                   MOVE      WOUTAMT       VFAMT3
     C                   ENDIF
      *
     C                   ENDSR
      /SPACE 5
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialisation Subroutine                           *
      *                                                               *
      *  Called From:  Main program                                   *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameter entry.
      *
     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
      *
      ** Define RUNDAT.
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Check mode if 'AUDIT' or 'UPDATE'.
      *
     C                   IF        MODE = 'U'
     C                             or MODE = 'u'
     C                   MOVE      '1'           *IN30
     C                   ELSE
     C                   MOVE      '0'           *IN30
     C                   ENDIF
      *
      ** Access bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBPGM = 'UTLE0668'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Initialise variables.
      *
     C                   MOVEA     CPY@          @CPY             80
     C                   Z-ADD     0             PAGE             10 0
     C                   Z-ADD     0             PAGENO           10 0
     C                   Z-ADD     0             FACERR
     C                   Z-ADD     0             NOREAD
     C                   Z-ADD     0             NOADD
     C                   MOVE      0             KFACT             3 0
     C                   MOVE      0             KFCNO             2 0
     C                   MOVE      *BLANK        KACNUM            6
     C                   Z-ADD     0             KAFCTY            5 0
     C                   MOVE      *BLANK        KALOAN            6
     C                   Z-ADD     0             KADATE            5 0
      *
     C                   MOVE      *BLANKS       VBRCA
     C                   MOVE      *BLANKS       VCNUM
     C                   MOVE      *BLANKS       VFACT
     C                   MOVE      *BLANKS       VFCNO
     C                   MOVE      *BLANKS       VDATE
     C                   MOVE      *BLANKS       VLNRF
     C                   MOVE      *BLANKS       VACTN
     C                   MOVE      *BLANKS       VFAMT0
     C                   MOVE      *BLANKS       VFAMT1
     C                   MOVE      *BLANKS       VFAMT2
     C                   MOVE      *BLANKS       VFAMT3
     C                   MOVE      *BLANKS       VFCCY
      *
      ** Set on *IN98 if date format is MMDDYY.
      *
     C                   IF        AGDFF = 'M'
     C                   MOVE      '1'           *IN98
     C                   ELSE
     C                   MOVE      '0'           *IN98
     C                   ENDIF
      *
      ** Key Lists.
      *
     C     KEY001        KLIST
     C                   KFLD                    C_FCLB
     C                   KFLD                    FCUS
     C                   KFLD                    FTYP
     C                   KFLD                    FSEQ
      *
     C     KEY002        KLIST
     C                   KFLD                    C_FCLB
     C                   KFLD                    CANM
     C                   KFLD                    CAFT
     C                   KFLD                    CAFN
      *
     C     KEY003        KLIST
     C                   KFLD                    C_FCLB
     C                   KFLD                    VACNUM            6
     C                   KFLD                    VAFCTY            5 0
     C                   KFLD                    VALOAN            6
     C                   KFLD                    VADATE            5 0
      *
     C     KEY004        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    VACNUM
     C                   KFLD                    VAFCTY
     C                   KFLD                    VADATE
      *
     C     KEY005        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    VACNUM
     C                   KFLD                    VAFCTY
      *
     C                   ENDSR
      /SPACE 5
      *****************************************************************
      *                                                               *
      *  *PSSR - Subroutine to handle error conditions                *
      *                                                               *
      *  CALLED FROM:  After abnormal operation occurs                *
      *                                                               *
      *  CALLS: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRUN = *BLANKS
     C                   MOVE      'Y'           WRUN              1
     C                   DUMP
     C                   ENDIF
      *
     C                   ADD       1             PAGE
     C                   WRITE     HEADER1
     C                   WRITE     DBERROR1
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2012
